/**
 * Viz workspace — docked pane (default) or detachable floating panel.
 */
(function (global) {
    'use strict';

    var DEFAULT_VIZ_LANGS = ['java', 'python', 'go', 'cpp', 'rust'];
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
            ownership: document.getElementById('vizOwnership'),
            ownTab: document.querySelector('.viz-tab-ownership'),
            shellTabs: document.querySelectorAll('.viz-shell-tab'),
            shellPanes: document.querySelectorAll('.viz-shell-pane')
        };

        var currentLang = config.initialLanguage || 'python';
        var lastOwnCode = null;   // code at the last ownership run (cache key)
        var ownLoaded = false;
        var ownOverlay = null;    // Monaco permission overlay (lazy)
        var ownShowPerms = true;  // paint permissions on the editor

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
            currentLang = lang;
            updateOwnershipTab(lang);
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
            if (name === 'ownership') ensureOwnership();
            else if (ownOverlay) ownOverlay.setVisible(false); // hide perm overlay off-tab
        }

        // Show the Ownership tab only for Rust (it runs a different engine).
        function updateOwnershipTab(lang) {
            if (els.ownTab) els.ownTab.hidden = (lang !== 'rust');
            if (lang !== 'rust') {
                if (ownOverlay) ownOverlay.clear();
                // If we leave Rust while Ownership is the active tab, fall back to stage.
                if (els.ownTab && els.ownTab.classList.contains('active')) switchModalTab('stage');
            }
        }

        function ownMessage(html) {
            if (els.ownership) els.ownership.innerHTML = '<div class="own-empty">' + html + '</div>';
        }

        // Lazily create the Monaco permission overlay (paints R/W/O on the editor).
        function getOverlay() {
            if (ownOverlay) return ownOverlay;
            if (global.OcOwnershipOverlay && config.editor && global.monaco) {
                ownOverlay = global.OcOwnershipOverlay.create({ editor: config.editor, monaco: global.monaco });
            }
            return ownOverlay;
        }

        // Pane = the overlay toggle + the runtime (stack/heap) view. Permissions
        // live on the editor, so the code is not duplicated here.
        function renderOwnershipPane(ownership) {
            els.ownership.innerHTML =
                '<div class="own-overlay-bar">' +
                '<label class="own-toggle"><input type="checkbox" id="ownShowPermsCb"' +
                (ownShowPerms ? ' checked' : '') + '> Highlight permissions on the code</label>' +
                '<span class="own-overlay-hint">Use-sites underlined (red = permission missing) · hover for R/W/O · ⊞ in the gutter = changes · click a step below to jump</span>' +
                '</div><div id="ownRuntimeBody"></div>';
            var cb = els.ownership.querySelector('#ownShowPermsCb');
            if (cb) cb.addEventListener('change', function () {
                ownShowPerms = cb.checked;
                var ov = getOverlay();
                if (ov) ov.setVisible(ownShowPerms);
            });
            var body = els.ownership.querySelector('#ownRuntimeBody');
            global.OcOwnership.renderRuntime(body, ownership);
            // Click a runtime step → jump to its source line in the editor.
            if (body) body.addEventListener('click', function (e) {
                var step = e.target.closest && e.target.closest('.mv-step[data-line]');
                var ov = getOverlay();
                if (step && ov) ov.reveal(parseInt(step.getAttribute('data-line'), 10));
            });
        }

        // Lazily run the rust-ownership engine. Cached on code; the permission
        // layer is painted onto the editor and the pane shows the runtime view.
        function ensureOwnership() {
            if (!els.ownership || !global.OcOwnership) return;
            var payload = getRunPayload();
            if (!payload || payload.language !== 'rust') {
                ownMessage('Ownership analysis is available for Rust only.');
                return;
            }
            if (payload.files && payload.files.length > 1) {
                ownMessage('Multi-file ownership is not supported yet — use a single <code>main.rs</code>.');
                return;
            }
            var code = payload.code != null ? payload.code
                : (payload.files && payload.files[0] ? payload.files[0].content : '');
            var ov = getOverlay();
            if (ownLoaded && code === lastOwnCode) {        // cached — just re-show overlay
                if (ov && ownShowPerms && ov.hasData()) ov.setVisible(true);
                return;
            }
            lastOwnCode = code;
            ownLoaded = false;
            els.ownership.innerHTML =
                '<div class="own-loading"><div class="viz-spinner" aria-hidden="true"></div>' +
                '<div>Analyzing ownership… (first run pulls the toolchain — up to ~30s)</div></div>';
            api.execute({ language: 'rust-ownership', code: code }).then(function (data) {
                ownLoaded = true;
                if (data && data.ownership) {
                    if (ov && ownShowPerms) ov.apply(code, data.ownership);
                    renderOwnershipPane(data.ownership);
                } else {
                    ownMessage('No ownership analysis returned' +
                        (data && data.stderr ? ':<pre>' + escapeHtml(data.stderr) + '</pre>' : '.'));
                }
            }).catch(function (err) {
                ownLoaded = false;
                ownMessage('Error: ' + escapeHtml(err && err.message || String(err)));
            });
        }

        // When the editor changes, the painted permissions no longer line up —
        // clear them and force a re-run next time the Ownership tab is opened.
        function invalidateOwnershipOnEdit() {
            if (ownOverlay && ownOverlay.hasData() && config.editor &&
                config.editor.getValue() !== ownOverlay.analyzedCode()) {
                ownOverlay.clear();
                ownLoaded = false;
            }
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
                '<span class="viz-lens-toggle" id="vizLensToggle" style="display:none" title="Switch view: data structures or raw memory (stack &amp; heap)">' +
                '<button type="button" id="vizLensStruct" class="active">Structures</button>' +
                '<button type="button" id="vizLensMem">Memory</button>' +
                '</span>' +
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

            var lensStruct = document.getElementById('vizLensStruct');
            var lensMem = document.getElementById('vizLensMem');
            if (lensStruct && lensMem) {
                lensStruct.onclick = function () {
                    global.OcViz.setMemView(false);
                    lensStruct.classList.add('active'); lensMem.classList.remove('active');
                    rerenderCurrent();
                };
                lensMem.onclick = function () {
                    global.OcViz.setMemView(true);
                    lensMem.classList.add('active'); lensStruct.classList.remove('active');
                    rerenderCurrent();
                };
            }
        }

        function rerenderCurrent() {
            if (player && lastSteps && lastSteps.length) {
                var i = player.getIndex();
                onPlayerStep(i, lastSteps[i], lastSteps.length);
            }
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

        // ── Auto-fit / zoom: a growing drawing scales to stay whole (no scroll) ──
        var fitScale = 1, userScale = null, panX = 0, panY = 0, zoomBar = null, zoomWired = false;

        function resetFit() { fitScale = 1; userScale = null; panX = 0; panY = 0; }
        function stageFit() { return els.stage && els.stage.querySelector('.viz-fit'); }

        function computeFit() {
            var fit = stageFit(); if (!fit || !els.stage) return 1;
            var natW = fit.scrollWidth, natH = fit.scrollHeight;
            var vw = els.stage.clientWidth, vh = els.stage.clientHeight;
            if (!natW || !natH || !vw || !vh) return 1;
            return Math.min(1, vw / natW, vh / natH);      // only shrink to fit, never upscale
        }
        function applyFit(scale) {
            var fit = stageFit(); if (!fit) return;
            fit.style.transform = 'translate(' + panX + 'px,' + panY + 'px) scale(' + scale + ')';
            var pct = document.getElementById('vizZoomPct');
            if (pct) pct.textContent = Math.round(scale * 100) + '%';
            var over = fit.scrollWidth * scale > els.stage.clientWidth + 1 || fit.scrollHeight * scale > els.stage.clientHeight + 1;
            els.stage.classList.toggle('viz-pannable', !!over);
        }
        function setUserZoom(s) { userScale = Math.max(0.1, Math.min(4, s)); applyFit(userScale); }
        function toggleMaximize() {
            if (!els.shell) return;
            els.shell.classList.toggle('viz-maximized');
            resetFit(); setTimeout(fitStage, 30);          // re-fit to the new size
        }
        function ensureZoomBar() {
            if (!zoomBar) {
                zoomBar = document.createElement('div');
                zoomBar.className = 'viz-zoombar'; zoomBar.id = 'vizZoomBar';
                zoomBar.innerHTML =
                    '<button type="button" data-z="out" title="Zoom out">−</button>' +
                    '<span class="viz-zoom-pct" id="vizZoomPct">100%</span>' +
                    '<button type="button" data-z="in" title="Zoom in">+</button>' +
                    '<button type="button" data-z="fit" title="Fit to view"><i class="fas fa-expand"></i></button>' +
                    '<button type="button" data-z="max" title="Maximize"><i class="fas fa-up-right-and-down-left-from-center"></i></button>';
                zoomBar.addEventListener('click', function (e) {
                    var b = e.target.closest && e.target.closest('button'); if (!b) return;
                    var z = b.getAttribute('data-z');
                    if (z === 'in') setUserZoom((userScale || fitScale) * 1.25);
                    else if (z === 'out') setUserZoom((userScale || fitScale) / 1.25);
                    else if (z === 'fit') { resetFit(); fitStage(); }
                    else if (z === 'max') toggleMaximize();
                });
            }
            if (!zoomWired && els.stage) {
                zoomWired = true;
                els.stage.addEventListener('wheel', function (e) {
                    if (!stageFit()) return;
                    e.preventDefault();
                    setUserZoom((userScale || fitScale) * (e.deltaY < 0 ? 1.1 : 0.9));
                }, { passive: false });
                var drag = null;
                els.stage.addEventListener('mousedown', function (e) {
                    if (!els.stage.classList.contains('viz-pannable')) return;
                    drag = { x: e.clientX, y: e.clientY, px: panX, py: panY };
                    els.stage.classList.add('viz-panning');
                });
                window.addEventListener('mousemove', function (e) {
                    if (!drag) return;
                    panX = drag.px + (e.clientX - drag.x); panY = drag.py + (e.clientY - drag.y);
                    applyFit(userScale != null ? userScale : fitScale);
                });
                window.addEventListener('mouseup', function () { drag = null; els.stage && els.stage.classList.remove('viz-panning'); });
                window.addEventListener('resize', function () {
                    if (!stageFit()) return;
                    if (userScale != null) { applyFit(userScale); return; }
                    fitScale = computeFit(); applyFit(fitScale);   // resize is deliberate → allow re-fit up
                });
            }
            return zoomBar;
        }
        // Wrap the freshly-rendered tracers into a scalable layer and scale to fit.
        function fitStage() {
            var st = els.stage; if (!st) return;
            var bar = ensureZoomBar();
            if (!st.querySelector('.viz-fit')) {
                var fit = document.createElement('div');
                fit.className = 'viz-fit';
                var kids = [];
                for (var i = 0; i < st.children.length; i++) kids.push(st.children[i]);
                kids.forEach(function (k) { if (k !== bar) fit.appendChild(k); });
                st.appendChild(fit);
            }
            st.classList.add('viz-fitmode');
            st.appendChild(bar);                            // renderStep cleared it; re-attach overlay
            var needed = computeFit();
            var scale;
            if (userScale != null) scale = userScale;
            else { fitScale = Math.min(fitScale, needed); scale = fitScale; }   // monotonic zoom-out
            applyFit(scale);
        }

        function onPlayerStep(idx, step, total) {
            if (vizMode === 'concurrency' && concModel) {
                global.OcViz.renderConcStep(els.stage, concModel, idx);
                fitStage();
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
            fitStage();
            highlightLine(step && step.line);
            if (recordCode.panel) setRecordCodeLine(step && step.line);
            if (els.stepCard && step) {
                var lineHtml = (step.line != null && step.line > 0)
                    ? '<i class="fas fa-location-arrow"></i> Executing line <strong>' + step.line + '</strong>'
                    : '';
                var opsHtml = (step.reads != null)
                    ? '<span class="viz-ops-inline" title="reads / comparisons · writes / updates">reads <b>' +
                        step.reads + '</b> · writes <b>' + step.writes + '</b></span>'
                    : '';
                els.stepCard.innerHTML = lineHtml + (lineHtml && opsHtml ? ' · ' : '') + opsHtml;
            }
            updatePlaybackUi(idx, total, player && player.isPlaying());
        }

        function loadSteps(steps, result) {
            lastSteps = steps;
            lastResult = result;
            resetFit();                     // new trace → start unscaled, auto-fit as it grows
            if (player) player.destroy();
            // Memory lens toggle: show only when the trace carries memory snapshots; default to Structures.
            var lensToggle = document.getElementById('vizLensToggle');
            var hasMem = global.OcViz.traceHasMem && global.OcViz.traceHasMem(steps);
            if (lensToggle) lensToggle.style.display = hasMem ? '' : 'none';
            if (global.OcViz.setMemView) global.OcViz.setMemView(false);
            var ls = document.getElementById('vizLensStruct'), lm = document.getElementById('vizLensMem');
            if (ls) ls.classList.add('active');
            if (lm) lm.classList.remove('active');
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
            if (ownOverlay) ownOverlay.setVisible(false); // unpaint permissions
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
            // Auto-fill the program-arguments input from the template so an
            // args-driven example runs correctly on pick; clear it otherwise.
            if (typeof config.setArgs === 'function') {
                config.setArgs(t.args || []);
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
                alert('Visualization is available for Java, Python, Go, C++ and Rust only.');
                return Promise.resolve();
            }
            if (payload.files && payload.files.length > 1) {
                alert('Multi-file visualization is not supported yet. Use a single main file.');
                return Promise.resolve();
            }
            openPane();
            // bash has no read/patch highlights (arrays re-render via `set`), so
            // hide the "reading / just changed" legend to avoid implying cues
            // that never light up.
            if (global.OcViz.setArrayLegend) {
                global.OcViz.setArrayLegend(payload.language !== 'bash');
            }
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
                config.editor.onDidChangeModelContent(function () {
                    scheduleStaleCheck();
                    invalidateOwnershipOnEdit();
                });
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
