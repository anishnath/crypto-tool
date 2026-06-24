/**
 * Inline algorithm visualizer for tutorials.
 *
 * Two entry points:
 *  1. Auto-wires static blocks: <div class="code-block" data-viz-lang="go"><pre><code>…</code></pre></div>
 *  2. OcVizTutorial.visualize(lang, code, mountEl) — used by the embedded compiler widget.
 *
 * Reuses the standalone OcViz modules (api/parser/render/player) — no Monaco needed.
 */
(function (global) {
    'use strict';

    function ready(fn) {
        if (document.readyState !== 'loading') fn();
        else document.addEventListener('DOMContentLoaded', fn);
    }

    function el(tag, cls, text) {
        var n = document.createElement(tag);
        if (cls) n.className = cls;
        if (text != null) n.textContent = text;
        return n;
    }

    function buildPanel() {
        var root = el('div', 'tv-viz');
        var status = el('div', 'tv-viz-status', 'Loading visualizer…');
        var body = el('div', 'tv-viz-body');
        var codePanel = el('div', 'tv-viz-code');
        var stage = el('div', 'viz-stage'); // renderStep targets a .viz-stage container
        body.appendChild(codePanel);
        body.appendChild(stage);
        var controls = el('div', 'tv-viz-controls');
        root.appendChild(status);
        root.appendChild(body);
        root.appendChild(controls);

        var rows = [], lastLine = -1;
        function setCode(code) {
            codePanel.innerHTML = '';
            rows = [];
            String(code || '').split('\n').forEach(function (text, i) {
                var row = el('div', 'tv-viz-line');
                row.appendChild(el('span', 'tv-viz-num', String(i + 1)));
                row.appendChild(el('span', 'tv-viz-src', text.length ? text : ' '));
                codePanel.appendChild(row);
                rows.push(row);
            });
        }
        function setLine(line) {
            var ln = parseInt(line, 10);
            if (ln === lastLine) return;
            if (rows[lastLine - 1]) rows[lastLine - 1].classList.remove('is-active');
            if (ln >= 1 && rows[ln - 1]) {
                var r = rows[ln - 1];
                r.classList.add('is-active');
                // Keep the executing line centered in the panel so it's always in view.
                var target = r.offsetTop - (codePanel.clientHeight - r.offsetHeight) / 2;
                codePanel.scrollTop = Math.max(0, target);
                codePanel.scrollLeft = 0; // show the start of the active line (and its highlight bar)
            }
            lastLine = ln;
        }

        return {
            root: root, stage: stage, controls: controls, player: null,
            setCode: setCode, setLine: setLine,
            status: function (t) { status.textContent = t || ''; status.style.display = t ? '' : 'none'; }
        };
    }

    function runViz(lang, code, panel) {
        var base = global.OC_VIZ_BASE || '/OneCompilerVizFunctionality';
        var api = global.OcViz.createApiClient(base);
        panel.status('Visualizing…');
        api.execute({ language: lang, code: code }).then(function (data) {
            var parsed = global.OcViz.buildSteps((data && data.commands) || []);
            if (!parsed.steps.length) {
                panel.status((data && data.stderr) ? ('No steps. ' + data.stderr) : 'No visualization steps were produced.');
                return;
            }
            panel.setCode(code);
            var player;
            player = global.OcViz.createPlayer({
                steps: parsed.steps,
                onStep: function (idx, step, total) {
                    global.OcViz.renderStep(panel.stage, step);
                    panel.setLine(step && step.line);
                    syncControls(panel, player, idx, total);
                },
                onPlayingChange: function () {
                    syncControls(panel, player, player.getIndex(), player.getCount());
                }
            });
            panel.player = player;
            renderControls(panel, player);
            player.goTo(0);
            panel.status('');
        }).catch(function (e) {
            panel.status('Error: ' + (e && e.message ? e.message : String(e)));
        });
    }

    function renderControls(panel, player) {
        panel.controls.innerHTML =
            '<button type="button" data-act="start" title="Start">&#9198;</button>' +
            '<button type="button" data-act="back" title="Step back">&#9664;</button>' +
            '<button type="button" data-act="play" title="Play/Pause">&#9658;</button>' +
            '<button type="button" data-act="fwd" title="Step forward">&#9654;</button>' +
            '<button type="button" data-act="end" title="End">&#9197;</button>' +
            '<input type="range" class="tv-viz-scrub" min="0" max="0" value="0">' +
            '<span class="tv-viz-step">Step 0 / 0</span>';
        panel.controls.querySelector('[data-act="start"]').onclick = function () { player.goTo(0); };
        panel.controls.querySelector('[data-act="back"]').onclick = function () { player.stepBack(); };
        panel.controls.querySelector('[data-act="play"]').onclick = function () { player.togglePlay(); };
        panel.controls.querySelector('[data-act="fwd"]').onclick = function () { player.stepForward(); };
        panel.controls.querySelector('[data-act="end"]').onclick = function () { player.goTo(player.getCount() - 1); };
        panel.controls.querySelector('.tv-viz-scrub').oninput = function (e) {
            player.pause();
            player.goTo(parseInt(e.target.value, 10) || 0);
        };
    }

    function syncControls(panel, player, idx, total) {
        var scrub = panel.controls.querySelector('.tv-viz-scrub');
        var info = panel.controls.querySelector('.tv-viz-step');
        var play = panel.controls.querySelector('[data-act="play"]');
        if (scrub) { scrub.max = String(Math.max(0, total - 1)); scrub.value = String(idx); }
        if (info) info.textContent = 'Step ' + (total ? idx + 1 : 0) + ' / ' + total;
        if (play) play.innerHTML = player.isPlaying() ? '&#10073;&#10073;' : '&#9658;';
    }

    // Public: build a viz panel inside mountEl, run it, return a control with destroy().
    function visualize(lang, code, mountEl) {
        if (!global.OcViz || !global.OcViz.buildSteps) return null;
        var panel = buildPanel();
        mountEl.appendChild(panel.root);
        runViz(lang, code, panel);
        return {
            root: panel.root,
            destroy: function () {
                if (panel.player) panel.player.destroy();
                if (panel.root.parentNode) panel.root.parentNode.removeChild(panel.root);
            }
        };
    }

    // Auto-wire static tutorial code blocks.
    function setupBlock(block) {
        var lang = (block.getAttribute('data-viz-lang') || '').toLowerCase();
        var codeEl = block.querySelector('code');
        if (!lang || !codeEl) return;
        var btn = el('button', 'tv-viz-btn');
        btn.type = 'button';
        btn.innerHTML = '<span class="tv-viz-ico">&#9658;</span> Visualize';
        block.appendChild(btn);
        var ctrl = null;
        btn.addEventListener('click', function () {
            if (ctrl) { ctrl.destroy(); ctrl = null; btn.classList.remove('is-open'); return; }
            btn.classList.add('is-open');
            var mount = el('div', 'tv-viz-mount');
            block.parentNode.insertBefore(mount, block.nextSibling);
            ctrl = visualize(lang, codeEl.textContent, mount);
            if (mount.scrollIntoView) mount.scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
    }

    ready(function () {
        if (!global.OcViz || !global.OcViz.buildSteps || !global.OcViz.createApiClient) return;
        var blocks = document.querySelectorAll('.code-block[data-viz-lang], .tutorial-viz[data-viz-lang]');
        Array.prototype.forEach.call(blocks, setupBlock);
    });

    global.OcVizTutorial = { visualize: visualize };
}(typeof window !== 'undefined' ? window : this));
