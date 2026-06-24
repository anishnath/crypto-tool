/**
 * Viz workspace — docked pane (default) or detachable floating panel.
 */
(function (global) {
    'use strict';

    var DEFAULT_VIZ_LANGS = ['java', 'python', 'go', 'cpp'];
    var DOCK_PREF_KEY = 'oc-viz-dock-mode';

    function createWorkspace(config) {
        var supportedLangs = config.supportedLanguages || DEFAULT_VIZ_LANGS.slice();
        var api = global.OcViz.createApiClient(config.apiBase);
        var player = null;
        var lastResult = null;
        var lastSteps = null;
        var vizMode = 'ds';      // 'ds' (data structures) | 'concurrency' (swim lanes)
        var concModel = null;
        var lastRunCode = null;  // editor code at the last Visualize run (staleness check)
        var staleBannerEl = null;
        var staleTimer = null;
        var open = false;
        var recording = false;
        var isAttached = true;

        var els = {
            btn: document.getElementById('vizBtn'),
            shell: document.getElementById('vizShell'),
            dock: document.getElementById('vizPaneDock'),
            floatHost: document.getElementById('vizFloatHost'),
            modal: document.getElementById('vizModal'),
            codeRow: document.getElementById('ideCodeVizRow'),
            splitHandle: document.getElementById('vizSplitHandle'),
            shellHeader: document.getElementById('vizShellHeader'),
            attachBtn: document.getElementById('vizAttachBtn'),
            detachBtn: document.getElementById('vizDetachBtn'),
            closeBtn: document.getElementById('vizCloseBtn'),
            captureRoot: document.getElementById('vizCaptureRoot'),
            stage: document.getElementById('vizStage'),
            stepCard: document.getElementById('vizStepCard'),
            playback: document.getElementById('vizPlayback'),
            recordStatus: document.getElementById('vizRecordStatus'),
            vizLog: document.getElementById('vizLogContent'),
            helpPanel: document.getElementById('vizHelpContent'),
            templates: document.getElementById('vizTemplatesContent'),
            shellTabs: document.querySelectorAll('.viz-shell-tab'),
            shellPanes: document.querySelectorAll('.viz-shell-pane')
        };

        var templatesForLang = [];

        try {
            var saved = localStorage.getItem(DOCK_PREF_KEY);
            if (saved === 'detached') isAttached = false;
            if (saved === 'attached') isAttached = true;
        } catch (e) { /* ignore */ }

        var lineDecorationIds = [];
        var hadGlyphMargin = false;

        function isVizLanguage(lang) {
            return supportedLangs.indexOf(lang) >= 0;
        }

        function updateButtonVisibility(lang) {
            if (!els.btn) return;
            var show = isVizLanguage(lang);
            els.btn.style.display = show ? '' : 'none';
            if (!show && open) closePane();
        }

        function highlightLine(line) {
            if (!config.editor) return;
            var ed = config.editor;
            var lineNum = parseInt(line, 10);
            if (isNaN(lineNum) || lineNum <= 0) {
                clearLineHighlight();
                return;
            }
            ed.revealLineInCenter(lineNum);
            ed.setPosition({ lineNumber: lineNum, column: 1 });
            var rulerLane = global.monaco && global.monaco.editor && global.monaco.editor.OverviewRulerLane
                ? global.monaco.editor.OverviewRulerLane.Full : 4;
            lineDecorationIds = ed.deltaDecorations(lineDecorationIds, [{
                range: new monaco.Range(lineNum, 1, lineNum, 1),
                options: {
                    isWholeLine: true,
                    className: 'viz-line-highlight',
                    linesDecorationsClassName: 'viz-line-gutter',
                    glyphMarginClassName: 'viz-exec-glyph',
                    overviewRuler: { color: '#6366f1', position: rulerLane }
                }
            }]);
        }

        function clearLineHighlight() {
            if (!config.editor || !lineDecorationIds.length) return;
            lineDecorationIds = config.editor.deltaDecorations(lineDecorationIds, []);
        }

        function setEditorVizMode(active) {
            if (!config.editor) return;
            if (active) {
                hadGlyphMargin = !!config.editor.getOption(monaco.editor.EditorOption.glyphMargin);
                config.editor.updateOptions({ glyphMargin: true });
            } else {
                config.editor.updateOptions({ glyphMargin: hadGlyphMargin });
            }
        }

        function saveDockPref() {
            try {
                localStorage.setItem(DOCK_PREF_KEY, isAttached ? 'attached' : 'detached');
            } catch (e) { /* ignore */ }
        }

        function updateAttachDetachUi() {
            if (!els.shell) return;
            els.shell.classList.toggle('viz-mode-attached', isAttached);
            els.shell.classList.toggle('viz-mode-detached', !isAttached);
            if (els.attachBtn) els.attachBtn.hidden = isAttached;
            if (els.detachBtn) els.detachBtn.hidden = !isAttached;
            if (els.shellHeader) {
                els.shellHeader.title = isAttached
                    ? 'Visualization panel (docked)'
                    : 'Drag to move · double-click to center';
            }
        }

        function moveShellToParent(parent) {
            if (!els.shell || !parent) return;
            parent.appendChild(els.shell);
        }

        function resetFloatPosition() {
            if (!els.shell || isAttached) return;
            els.shell.classList.remove('viz-is-dragged');
            if (window.innerWidth >= 992) {
                els.shell.style.left = 'auto';
                els.shell.style.right = '20px';
                els.shell.style.top = '50%';
                els.shell.style.transform = 'translateY(-50%)';
            } else {
                els.shell.style.left = '50%';
                els.shell.style.right = 'auto';
                els.shell.style.top = '50%';
                els.shell.style.transform = 'translate(-50%, -50%)';
            }
        }

        function clearFloatStyles() {
            if (!els.shell) return;
            els.shell.classList.remove('viz-is-dragged');
            els.shell.style.left = '';
            els.shell.style.right = '';
            els.shell.style.top = '';
            els.shell.style.transform = '';
        }

        function placeShellForMode() {
            updateAttachDetachUi();
            if (isAttached) {
                moveShellToParent(els.dock);
                clearFloatStyles();
            } else {
                moveShellToParent(els.floatHost);
                resetFloatPosition();
            }
        }

        function syncVisibility() {
            if (!els.shell) return;
            if (open) {
                els.shell.hidden = false;
                if (isAttached) {
                    if (els.codeRow) els.codeRow.classList.add('viz-active');
                    if (els.splitHandle) els.splitHandle.classList.add('is-visible');
                    if (els.modal) {
                        els.modal.classList.remove('show');
                        els.modal.setAttribute('aria-hidden', 'true');
                    }
                } else {
                    if (els.codeRow) els.codeRow.classList.remove('viz-active');
                    if (els.splitHandle) els.splitHandle.classList.remove('is-visible');
                    if (els.modal) {
                        els.modal.classList.add('show');
                        els.modal.setAttribute('aria-hidden', 'false');
                    }
                }
            } else {
                els.shell.hidden = true;
                if (els.codeRow) els.codeRow.classList.remove('viz-active');
                if (els.splitHandle) els.splitHandle.classList.remove('is-visible');
                if (els.modal) {
                    els.modal.classList.remove('show');
                    els.modal.setAttribute('aria-hidden', 'true');
                }
            }
        }

        function attachToPane() {
            if (isAttached) return;
            isAttached = true;
            saveDockPref();
            placeShellForMode();
            syncVisibility();
        }

        function detachFromPane() {
            if (!isAttached) return;
            isAttached = false;
            saveDockPref();
            placeShellForMode();
            syncVisibility();
        }

        function switchModalTab(name) {
            els.shellTabs.forEach(function (tab) {
                tab.classList.toggle('active', tab.getAttribute('data-viz-tab') === name);
            });
            els.shellPanes.forEach(function (pane) {
                pane.classList.toggle('active', pane.getAttribute('data-viz-pane') === name);
            });
        }

        function renderPlaybackControls() {
            if (!els.playback) return;
            els.playback.innerHTML =
                '<div class="viz-playback-controls">' +
                '<button type="button" id="vizBtnStart" title="Start"><i class="fas fa-backward-step"></i></button>' +
                '<button type="button" id="vizBtnBack" title="Step back"><i class="fas fa-chevron-left"></i></button>' +
                '<button type="button" id="vizBtnPlay" title="Play/Pause"><i class="fas fa-play"></i></button>' +
                '<button type="button" id="vizBtnFwd" title="Step forward"><i class="fas fa-chevron-right"></i></button>' +
                '<button type="button" id="vizBtnEnd" title="End"><i class="fas fa-forward-step"></i></button>' +
                '<select id="vizSpeedSelect" title="Playback speed"></select>' +
                '<button type="button" id="vizBtnReplay" title="Replay last run"><i class="fas fa-redo"></i> Replay</button>' +
                '<button type="button" id="vizBtnRecord" class="viz-record-btn" title="Record steps as animated GIF"><span class="viz-rec-dot"></span><span>Record GIF</span></button>' +
                '</div>' +
                '<input type="range" class="viz-scrubber" id="vizScrubber" min="0" max="0" value="0" />' +
                '<div class="viz-step-info" id="vizStepInfo">Step 0 / 0</div>';

            global.OcViz.PLAYBACK_SPEEDS.forEach(function (s, i) {
                var opt = document.createElement('option');
                opt.value = String(i);
                opt.textContent = s.label;
                if (i === 2) opt.selected = true;
                document.getElementById('vizSpeedSelect').appendChild(opt);
            });

            document.getElementById('vizBtnStart').onclick = function () { if (player) player.goTo(0); };
            document.getElementById('vizBtnBack').onclick = function () { if (player) player.stepBack(); };
            document.getElementById('vizBtnPlay').onclick = function () { if (player) player.togglePlay(); };
            document.getElementById('vizBtnFwd').onclick = function () { if (player) player.stepForward(); };
            document.getElementById('vizBtnEnd').onclick = function () {
                if (player) player.goTo(player.getCount() - 1);
            };
            document.getElementById('vizBtnReplay').onclick = function () {
                if (lastSteps) loadSteps(lastSteps, lastResult);
            };
            document.getElementById('vizSpeedSelect').onchange = function (e) {
                if (player) player.setSpeed(parseInt(e.target.value, 10) || 0);
            };
            document.getElementById('vizScrubber').oninput = function (e) {
                if (player) {
                    player.pause();
                    player.goTo(parseInt(e.target.value, 10) || 0);
                }
            };
            document.getElementById('vizBtnRecord').onclick = recordVisualizationGif;
        }

        function setPlaybackDisabled(disabled) {
            ['vizBtnStart', 'vizBtnBack', 'vizBtnPlay', 'vizBtnFwd', 'vizBtnEnd', 'vizBtnReplay', 'vizScrubber', 'vizSpeedSelect']
                .forEach(function (id) {
                    var node = document.getElementById(id);
                    if (node) node.disabled = disabled;
                });
        }

        function setRecordUi(active, statusText) {
            recording = active;
            var btn = document.getElementById('vizBtnRecord');
            if (btn) {
                btn.disabled = active;
                btn.classList.toggle('is-recording', active);
                var dot = btn.querySelector('.viz-rec-dot');
                var lbl = btn.querySelector('span:last-child');
                if (dot) dot.classList.toggle('viz-rec-active', active);
                if (lbl) lbl.textContent = active ? 'Recording…' : 'Record GIF';
            }
            if (els.recordStatus) {
                if (statusText) {
                    els.recordStatus.hidden = false;
                    els.recordStatus.textContent = statusText;
                } else {
                    els.recordStatus.hidden = true;
                    els.recordStatus.textContent = '';
                }
            }
            setPlaybackDisabled(active);
            if (els.closeBtn) els.closeBtn.disabled = active;
            if (els.attachBtn) els.attachBtn.disabled = active;
            if (els.detachBtn) els.detachBtn.disabled = active;
        }

        var recordCode = { panel: null, rows: null, body: null, lastLine: -1 };

        function buildRecordCodePanel(code) {
            var panel = document.createElement('div');
            panel.className = 'viz-record-code';
            var title = el('div', 'viz-record-code-title', 'Code');
            panel.appendChild(title);
            var body = el('div', 'viz-record-code-body');
            var rows = [];
            String(code || '').split('\n').forEach(function (text, i) {
                var row = el('div', 'viz-record-code-line');
                row.appendChild(el('span', 'viz-record-code-num', String(i + 1)));
                row.appendChild(el('span', 'viz-record-code-src', text.length ? text : ' '));
                body.appendChild(row);
                rows.push(row);
            });
            panel.appendChild(body);
            recordCode.panel = panel;
            recordCode.rows = rows;
            recordCode.body = body;
            recordCode.lastLine = -1;
            return panel;
        }

        function setRecordCodeLine(line) {
            if (!recordCode.rows) return;
            var ln = parseInt(line, 10);
            if (recordCode.lastLine === ln) return;
            var prev = recordCode.rows[recordCode.lastLine - 1];
            if (prev) prev.classList.remove('is-active');
            var row = (ln >= 1) ? recordCode.rows[ln - 1] : null;
            if (row) {
                row.classList.add('is-active');
                recordCode.body.scrollTop = Math.max(0, row.offsetTop - recordCode.body.clientHeight / 2);
            }
            recordCode.lastLine = ln;
        }

        function el(tag, cls, text) {
            var node = document.createElement(tag);
            if (cls) node.className = cls;
            if (text != null) node.textContent = text;
            return node;
        }

        function teardownRecordCode() {
            if (recordCode.panel && recordCode.panel.parentNode) {
                recordCode.panel.parentNode.removeChild(recordCode.panel);
            }
            if (els.captureRoot) els.captureRoot.classList.remove('viz-recording-with-code');
            recordCode = { panel: null, rows: null, body: null, lastLine: -1 };
        }

        function recordVisualizationGif() {
            if (recording || (global.OcViz.isVizRecording && global.OcViz.isVizRecording())) return;
            if (!player || !player.getCount()) {
                alert('Run Visualize first — no steps to record.');
                return;
            }
            var lang = 'viz';
            var payload = getRunPayload();
            if (payload && payload.language) lang = payload.language;

            // Add a synced code panel into the captured region so the GIF shows code + viz.
            var codeText = (config.editor && config.editor.getValue) ? config.editor.getValue()
                : (payload && payload.code) || '';
            if (els.captureRoot && codeText) {
                var panel = buildRecordCodePanel(codeText);
                els.captureRoot.insertBefore(panel, els.captureRoot.firstChild);
                els.captureRoot.classList.add('viz-recording-with-code');
                if (player.getIndex) setRecordCodeLine(lastStepLine());
            }

            var brand = (lang === 'java' || lang === 'python' || lang === 'go')
                ? '8gwifi.org/online-' + lang + '-compiler'
                : '8gwifi.org';

            setRecordUi(true, 'Preparing…');
            global.OcViz.recordGif({
                captureEl: els.captureRoot || els.stage,
                player: player,
                stepCount: player.getCount(),
                frameDelayMs: player.getSpeedMs ? player.getSpeedMs() : 300,
                brand: brand,
                filename: 'algorithm-viz-' + lang + '-' + Date.now() + '.gif',
                ensureStageTab: function () { switchModalTab('stage'); },
                onStatus: function (text) { setRecordUi(!!text, text); }
            }).catch(function (err) {
                alert(err.message || String(err));
            }).finally(function () {
                setRecordUi(false, null);
                teardownRecordCode();
            });
        }

        function lastStepLine() {
            if (!lastSteps || !player) return null;
            var s = lastSteps[player.getIndex ? player.getIndex() : 0];
            return s ? s.line : null;
        }

        function updatePlaybackUi(idx, total, playing) {
            var scrub = document.getElementById('vizScrubber');
            var info = document.getElementById('vizStepInfo');
            var playBtn = document.getElementById('vizBtnPlay');
            var recordBtn = document.getElementById('vizBtnRecord');
            if (scrub) {
                scrub.max = String(Math.max(0, total - 1));
                scrub.value = String(idx);
            }
            if (info) info.textContent = total ? ('Step ' + (idx + 1) + ' / ' + total) : 'No steps';
            if (playBtn) {
                playBtn.innerHTML = playing ? '<i class="fas fa-pause"></i>' : '<i class="fas fa-play"></i>';
            }
            if (recordBtn && !recording) recordBtn.disabled = !total;
        }

        function onPlayerStep(idx, step, total) {
            if (vizMode === 'concurrency' && concModel) {
                global.OcViz.renderConcStep(els.stage, concModel, idx);
                var ev = concModel.events[idx];
                highlightLine(ev && ev.line);
                if (recordCode.panel) setRecordCodeLine(ev && ev.line);
                if (els.stepCard && ev) {
                    els.stepCard.innerHTML = (ev.line && ev.line > 0)
                        ? '<i class="fas fa-location-arrow"></i> Line <strong>' + ev.line + '</strong> · ' + escapeHtml(ev.type)
                        : escapeHtml(ev.type);
                }
                updatePlaybackUi(idx, total, player && player.isPlaying());
                return;
            }
            global.OcViz.renderStep(els.stage, step);
            highlightLine(step && step.line);
            if (recordCode.panel) setRecordCodeLine(step && step.line);
            if (els.stepCard && step) {
                if (step.line != null && step.line > 0) {
                    els.stepCard.innerHTML = '<i class="fas fa-location-arrow"></i> Executing line <strong>' + step.line + '</strong> in editor';
                } else {
                    els.stepCard.textContent = '';
                }
            }
            updatePlaybackUi(idx, total, player && player.isPlaying());
        }

        function loadSteps(steps, result) {
            lastSteps = steps;
            lastResult = result;
            if (player) player.destroy();
            if (!steps || !steps.length) {
                if (els.stage) {
                    els.stage.innerHTML = '<div class="viz-stage-empty">No visualization steps were returned.</div>';
                }
                if (els.stepCard) els.stepCard.textContent = '';
                setPlaybackDisabled(true);
                updatePlaybackUi(0, 0, false);
                return;
            }
            setPlaybackDisabled(false);
            player = global.OcViz.createPlayer({
                steps: steps,
                onStep: onPlayerStep,
                onPlayingChange: function (playing) {
                    updatePlaybackUi(player.getIndex(), player.getCount(), playing);
                }
            });
            onPlayerStep(0, steps[0], steps.length);
        }

        function openPane() {
            open = true;
            placeShellForMode();
            syncVisibility();
            setEditorVizMode(true);
            if (els.btn) els.btn.classList.add('is-active');
            switchModalTab('stage');
            if (typeof config.onPaneToggle === 'function') config.onPaneToggle(true);
        }

        function closePane() {
            if (recording || (global.OcViz.isVizRecording && global.OcViz.isVizRecording())) return;
            open = false;
            syncVisibility();
            if (els.btn) els.btn.classList.remove('is-active');
            if (player) player.pause();
            clearLineHighlight();
            hideStaleBanner();
            setEditorVizMode(false);
            if (typeof config.onPaneToggle === 'function') config.onPaneToggle(false);
        }

        function setVizLog(text) {
            if (els.vizLog) els.vizLog.textContent = text || '';
        }

        function renderHelp(data) {
            if (!els.helpPanel) return;
            if (!data) {
                els.helpPanel.innerHTML = '<p>Loading capabilities…</p>';
                return;
            }
            var cap = data.capabilities || data;
            var html = '<h4>Visualization support (' + escapeHtml(data.language || cap.engine || '') + ')</h4>';
            if (cap.engine) html += '<p>Engine: <code>' + escapeHtml(cap.engine) + '</code></p>';
            if (cap.tracers && cap.tracers.length) {
                html += '<h4>Tracers</h4><p>' + cap.tracers.map(function (t) {
                    return '<code>' + escapeHtml(t) + '</code>';
                }).join(', ') + '</p>';
            }
            if (cap.supported && cap.supported.length) {
                html += '<h4>Supported</h4><ul>';
                cap.supported.forEach(function (s) {
                    html += '<li><strong>' + escapeHtml(s.category || 'Feature') + '</strong>';
                    if (s.structures && s.structures.length) {
                        html += ' — ' + s.structures.map(function (x) { return escapeHtml(x); }).join(', ');
                    }
                    if (s.operations && s.operations.length) {
                        html += '<br><span class="viz-help-ops">' + s.operations.map(function (x) {
                            return escapeHtml(x);
                        }).join(' · ') + '</span>';
                    }
                    if (s.notes) {
                        html += '<br><span class="viz-help-note">' + escapeHtml(s.notes) + '</span>';
                    }
                    html += '</li>';
                });
                html += '</ul>';
            }
            if (cap.unsupported && cap.unsupported.length) {
                html += '<h4>Not supported yet</h4><ul>';
                cap.unsupported.forEach(function (u) {
                    html += '<li><strong>' + escapeHtml(u.item || '') + '</strong>';
                    if (u.reason) html += ' — ' + escapeHtml(u.reason);
                    if (u.alternative) {
                        html += '<br><span class="viz-help-note">Use instead: ' + escapeHtml(u.alternative) + '</span>';
                    }
                    html += '</li>';
                });
                html += '</ul>';
            }
            els.helpPanel.innerHTML = html;
        }

        function escapeHtml(s) {
            return String(s)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;');
        }

        function loadCapabilities(lang) {
            return api.getLanguageCapabilities(lang).then(function (cap) {
                renderHelp(cap);
                return cap;
            }).catch(function () {
                renderHelp({ description: 'Could not load capabilities.' });
            });
        }

        function renderTemplates(lang) {
            if (!els.templates) return;
            templatesForLang = (global.OcViz.getTemplates && global.OcViz.getTemplates(lang)) || [];
            if (!templatesForLang.length) {
                els.templates.innerHTML = '<p class="viz-tpl-empty">No templates for this language yet.</p>';
                return;
            }
            var html = '<p class="viz-tpl-intro">Pick a ready-to-run algorithm. It loads into the editor and visualizes immediately.</p>';
            html += '<div class="viz-tpl-grid">';
            templatesForLang.forEach(function (t, i) {
                html += '<button type="button" class="viz-tpl-card" data-tpl-idx="' + i + '">' +
                    '<span class="viz-tpl-badge">' + escapeHtml(t.tracer) + '</span>' +
                    '<span class="viz-tpl-title">' + escapeHtml(t.title) + '</span>' +
                    '<span class="viz-tpl-cat">' + escapeHtml(t.category) + '</span>' +
                    '<span class="viz-tpl-desc">' + escapeHtml(t.desc) + '</span>' +
                    '</button>';
            });
            html += '</div>';
            els.templates.innerHTML = html;
        }

        function onTemplatePick(idx) {
            var t = templatesForLang[idx];
            if (!t) return;
            if (typeof config.setEditorCode === 'function') {
                config.setEditorCode(t.code);
            }
            switchModalTab('stage');
            runVisualize();
        }

        function getRunPayload() {
            return typeof config.getExecutePayload === 'function' ? config.getExecutePayload() : null;
        }

        function setLoading(loading) {
            if (!els.btn) return;
            els.btn.disabled = loading;
            els.btn.innerHTML = loading
                ? '<i class="fas fa-spinner fa-spin"></i> <span>Visualizing…</span>'
                : '<i class="fas fa-project-diagram"></i> <span>Visualize</span>';
        }

        // ── Staleness: when the editor changes after a run, prompt to re-visualize ──
        function showStaleBanner() {
            if (!els.stage || !els.stage.parentNode) return;
            if (staleBannerEl) { staleBannerEl.style.display = ''; }
            else {
                var bar = document.createElement('div');
                bar.className = 'viz-stale-banner';
                bar.innerHTML = '<span><i class="fas fa-pen"></i> Code changed since this run.</span>' +
                    '<button type="button" class="viz-stale-rerun"><i class="fas fa-rotate-right"></i> Re-visualize</button>';
                bar.querySelector('.viz-stale-rerun').addEventListener('click', function () { runVisualize(); });
                els.stage.parentNode.insertBefore(bar, els.stage);
                staleBannerEl = bar;
            }
            if (els.btn) els.btn.classList.add('viz-btn-stale');
        }

        function hideStaleBanner() {
            if (staleBannerEl) staleBannerEl.style.display = 'none';
            if (els.btn) els.btn.classList.remove('viz-btn-stale');
        }

        function markStaleIfChanged() {
            if (!open || recording) return;
            var payload = getRunPayload();
            var code = payload && payload.code;
            if (code == null) return; // multi-file run: skip staleness tracking
            if (lastRunCode != null && code !== lastRunCode) showStaleBanner();
            else hideStaleBanner();
        }

        function scheduleStaleCheck() {
            if (staleTimer) clearTimeout(staleTimer);
            staleTimer = setTimeout(markStaleIfChanged, 250);
        }

        function setStageLoading() {
            if (els.stage) {
                els.stage.innerHTML =
                    '<div class="viz-stage-empty viz-stage-loading">' +
                    '<div class="viz-spinner" aria-hidden="true"></div>' +
                    '<div class="viz-loading-title">Tracing execution…</div>' +
                    '<div class="viz-loading-sub">Compiling and instrumenting your code. First run can take 10–20s.</div>' +
                    '</div>';
            }
            if (els.stepCard) els.stepCard.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Preparing visualization…';
            setPlaybackDisabled(true);
            updatePlaybackUi(0, 0, false);
        }

        function runVisualize() {
            var payload = getRunPayload();
            if (!payload) return Promise.resolve();
            if (!isVizLanguage(payload.language)) {
                alert('Visualization is available for Java, Python, Go and C++ only.');
                return Promise.resolve();
            }
            if (payload.files && payload.files.length > 1) {
                alert('Multi-file visualization is not supported yet. Use a single main file.');
                return Promise.resolve();
            }
            openPane();
            lastRunCode = payload.code != null ? payload.code : null;
            hideStaleBanner();
            setLoading(true);
            setStageLoading();
            return api.execute(payload).then(function (data) {
                if (global.OcViz.isConcurrency && global.OcViz.isConcurrency(data)) {
                    vizMode = 'concurrency';
                    concModel = global.OcViz.buildConcSteps(data);
                    var out = concModel.stdout && concModel.stdout.length
                        ? concModel.stdout.join('\n') : '(no console output)';
                    setVizLog('--- console ---\n' + out);
                    loadSteps(concModel.steps, data);
                    return data;
                }
                vizMode = 'ds';
                concModel = null;
                setVizLog(global.OcViz.formatVizLog(data.commands || []));
                if (data.stderr) {
                    setVizLog((els.vizLog ? els.vizLog.textContent : '') + '\n\n--- stderr ---\n' + data.stderr);
                }
                var parsed = global.OcViz.buildSteps(data.commands || []);
                loadSteps(parsed.steps, data);
                if (data.stderr && parsed.steps.length <= 1) switchModalTab('log');
                return data;
            }).catch(function (err) {
                setVizLog('Error: ' + (err.message || String(err)));
                if (els.stage) {
                    els.stage.innerHTML = '<div class="viz-stage-empty">' + escapeHtml(err.message || String(err)) + '</div>';
                }
                if (els.stepCard) els.stepCard.textContent = '';
                switchModalTab('log');
            }).finally(function () {
                setLoading(false);
            });
        }

        function initSplitDrag() {
            if (!els.splitHandle || !els.codeRow) return;
            var editorSection = els.codeRow.querySelector('.ide-editor-section');
            if (!editorSection) return;
            var dragging = false;
            els.splitHandle.addEventListener('mousedown', function (e) {
                if (!isAttached || !open) return;
                dragging = true;
                els.splitHandle.classList.add('is-dragging');
                e.preventDefault();
            });
            document.addEventListener('mousemove', function (e) {
                if (!dragging || !els.codeRow) return;
                var rect = els.codeRow.getBoundingClientRect();
                var pct = ((e.clientX - rect.left) / rect.width) * 100;
                pct = Math.max(30, Math.min(70, pct));
                editorSection.style.flex = '0 0 ' + pct + '%';
            });
            document.addEventListener('mouseup', function () {
                dragging = false;
                if (els.splitHandle) els.splitHandle.classList.remove('is-dragging');
            });
        }

        function initFloatDrag() {
            var shell = els.shell;
            var handle = els.shellHeader;
            if (!shell || !handle) return;
            var drag = { active: false, x: 0, y: 0, left: 0, top: 0 };

            handle.addEventListener('mousedown', function (e) {
                if (isAttached || e.button !== 0) return;
                if (e.target.closest('.viz-shell-action')) return;
                var rect = shell.getBoundingClientRect();
                shell.classList.add('viz-is-dragged');
                shell.style.transform = 'none';
                shell.style.right = 'auto';
                shell.style.left = rect.left + 'px';
                shell.style.top = rect.top + 'px';
                drag.active = true;
                drag.x = e.clientX;
                drag.y = e.clientY;
                drag.left = rect.left;
                drag.top = rect.top;
                document.body.style.userSelect = 'none';
                e.preventDefault();
            });

            document.addEventListener('mousemove', function (e) {
                if (!drag.active || isAttached) return;
                var nl = drag.left + (e.clientX - drag.x);
                var nt = drag.top + (e.clientY - drag.y);
                var pad = 8;
                nl = Math.max(pad, Math.min(window.innerWidth - shell.offsetWidth - pad, nl));
                nt = Math.max(pad, Math.min(window.innerHeight - shell.offsetHeight - pad, nt));
                shell.style.left = nl + 'px';
                shell.style.top = nt + 'px';
            });

            document.addEventListener('mouseup', function () {
                if (!drag.active) return;
                drag.active = false;
                document.body.style.userSelect = '';
            });

            handle.addEventListener('dblclick', function (e) {
                if (isAttached || e.target.closest('.viz-shell-action')) return;
                resetFloatPosition();
            });
        }

        function initShellHandlers() {
            if (els.closeBtn) els.closeBtn.addEventListener('click', closePane);
            if (els.attachBtn) els.attachBtn.addEventListener('click', attachToPane);
            if (els.detachBtn) els.detachBtn.addEventListener('click', detachFromPane);
            els.shellTabs.forEach(function (tab) {
                tab.addEventListener('click', function () {
                    switchModalTab(tab.getAttribute('data-viz-tab'));
                });
            });
            if (els.templates) {
                els.templates.addEventListener('click', function (e) {
                    var card = e.target.closest('.viz-tpl-card');
                    if (!card) return;
                    onTemplatePick(parseInt(card.getAttribute('data-tpl-idx'), 10));
                });
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && open && !recording) closePane();
            });
            initSplitDrag();
            initFloatDrag();
        }

        function init() {
            renderPlaybackControls();
            updatePlaybackUi(0, 0, false);
            placeShellForMode();
            syncVisibility();
            if (els.stage) {
                els.stage.innerHTML = '<div class="viz-stage-empty">Click <strong>Visualize</strong> to trace algorithm execution step by step.</div>';
            }
            if (els.btn) els.btn.addEventListener('click', runVisualize);
            if (config.editor && typeof config.editor.onDidChangeModelContent === 'function') {
                config.editor.onDidChangeModelContent(scheduleStaleCheck);
            }
            initShellHandlers();
            var lang0 = config.initialLanguage || 'python';
            updateButtonVisibility(lang0);
            if (isVizLanguage(lang0)) {
                loadCapabilities(lang0);
                renderTemplates(lang0);
            }
        }

        return {
            init: init,
            runVisualize: runVisualize,
            updateLanguage: function (lang) {
                updateButtonVisibility(lang);
                if (isVizLanguage(lang)) {
                    loadCapabilities(lang);
                    renderTemplates(lang);
                }
            },
            isOpen: function () { return open; },
            isAttached: function () { return isAttached; },
            attachToPane: attachToPane,
            detachFromPane: detachFromPane,
            closePane: closePane
        };
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.createWorkspace = createWorkspace;
}(typeof window !== 'undefined' ? window : this));
