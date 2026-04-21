/**
 * AIProgressBar — reusable phased horizontal progress bar.
 *
 * Build once, reuse for any long-running AI call.
 *   var pb = AIProgressBar.attach(containerEl, { phases, estimatedMs });
 *   pb.start();           // show + begin ticking
 *   pb.stop(true);        // success: fill to 100%, then hide
 *   pb.stop(false);       // failure: hide immediately
 *   pb.destroy();         // remove DOM
 *
 * Pass custom `phases: [{pct, ms, label}, ...]` and `estimatedMs` to tune.
 * Omit to use defaults tuned for ~4 minute AI calls.
 */
(function (global) {
    'use strict';

    var DEFAULT_ESTIMATED_MS = 240000; // 4 min
    var DEFAULT_PHASES = [
        { pct: 12, ms: 3000,   label: 'Sending request...' },
        { pct: 25, ms: 15000,  label: 'Model is thinking...' },
        { pct: 45, ms: 45000,  label: 'Generating code...' },
        { pct: 65, ms: 90000,  label: 'Refining parameters...' },
        { pct: 80, ms: 150000, label: 'Finalizing output...' },
        { pct: 90, ms: 210000, label: 'Almost done...' }
    ];

    function formatRemaining(ms) {
        if (ms <= 0) return 'almost done';
        if (ms < 60000) return '~' + Math.max(1, Math.ceil(ms / 1000)) + 's';
        var m = Math.ceil(ms / 60000);
        return m === 1 ? '~1 min' : '~' + m + ' min';
    }

    function attach(container, opts) {
        if (!container) throw new Error('AIProgressBar.attach: container element required');
        opts = opts || {};
        var phases = (opts.phases && opts.phases.length) ? opts.phases : DEFAULT_PHASES;
        var estimatedMs = opts.estimatedMs || DEFAULT_ESTIMATED_MS;

        var root = document.createElement('div');
        root.className = 'aipb';
        root.innerHTML =
            '<div class="aipb-text">' +
                '<span class="aipb-label"><span class="aipb-spinner"></span><span class="aipb-msg">Working…</span></span>' +
                '<span class="aipb-time"></span>' +
            '</div>' +
            '<div class="aipb-bar"><div class="aipb-fill"></div></div>';
        container.appendChild(root);

        var fillEl = root.querySelector('.aipb-fill');
        var msgEl  = root.querySelector('.aipb-msg');
        var timeEl = root.querySelector('.aipb-time');

        var timer = null;
        var startTime = 0;

        function tick() {
            var elapsed = Date.now() - startTime;
            var pct = 0, label = phases[0].label;
            for (var i = phases.length - 1; i >= 0; i--) {
                if (elapsed >= phases[i].ms) {
                    pct = phases[i].pct;
                    label = phases[i].label;
                    if (i < phases.length - 1) {
                        var next = phases[i + 1];
                        var frac = (elapsed - phases[i].ms) / (next.ms - phases[i].ms);
                        pct += (next.pct - pct) * Math.min(frac, 1);
                    }
                    break;
                }
            }
            if (elapsed < phases[0].ms) {
                pct = (elapsed / phases[0].ms) * phases[0].pct;
                label = phases[0].label;
            }
            fillEl.style.transition = 'width 1s linear';
            fillEl.style.width = Math.min(pct, 95) + '%';
            msgEl.textContent = label;
            timeEl.textContent = formatRemaining(estimatedMs - elapsed);
        }

        function start() {
            if (timer) { clearInterval(timer); timer = null; }
            root.classList.add('active');
            fillEl.style.transition = 'none';
            fillEl.style.width = '0%';
            startTime = Date.now();
            msgEl.textContent = phases[0].label;
            timeEl.textContent = formatRemaining(estimatedMs);
            timer = setInterval(tick, 1000);
        }

        function stop(success) {
            if (timer) { clearInterval(timer); timer = null; }
            if (success) {
                fillEl.style.transition = 'width 0.3s ease';
                fillEl.style.width = '100%';
                msgEl.textContent = 'Done!';
                timeEl.textContent = '';
                setTimeout(function () { root.classList.remove('active'); }, 1200);
            } else {
                root.classList.remove('active');
            }
        }

        function destroy() {
            if (timer) { clearInterval(timer); timer = null; }
            if (root.parentNode) root.parentNode.removeChild(root);
        }

        return { start: start, stop: stop, destroy: destroy, el: root };
    }

    global.AIProgressBar = { attach: attach };
})(window);
