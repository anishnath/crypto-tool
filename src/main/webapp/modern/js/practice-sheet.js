/**
 * Practice Sheet Module
 * Reusable worksheet generator for any tool page.
 *
 * Usage:
 *   ToolUtils.PracticeSheet.init({
 *       containerId: 'practiceSection',
 *       title: 'Subnet Practice',
 *       toolColor: '#0891b2',
 *       difficulties: [
 *           { id: 'easy',   label: 'Easy',   description: 'Simple problems' },
 *           { id: 'medium', label: 'Medium', description: 'Moderate difficulty' },
 *           { id: 'hard',   label: 'Hard',   description: 'Challenging problems' }
 *       ],
 *       generateProblems: function(difficulty, count) {
 *           // Return array of problem objects:
 *           // [{ prompt: 'HTML string for the question',
 *           //    fields: [{ id: 'f1', label: 'Answer', answer: '42', placeholder: '' }],
 *           //    hint: 'Optional hint text' }]
 *       }
 *   });
 *
 * Version: 1.0
 */
(function () {
    'use strict';

    if (!window.ToolUtils) window.ToolUtils = {};
    if (window.ToolUtils.PracticeSheet) return;

    // --------------- state ---------------
    var _cfg = null;
    var _problems = [];
    var _answered = false;
    var _score = { correct: 0, total: 0 };

    // --------------- public API ---------------
    window.ToolUtils.PracticeSheet = {

        /**
         * Initialise and render the practice sheet into a container.
         * @param {Object} cfg - configuration (see header comment)
         */
        init: function (cfg) {
            _cfg = cfg;
            _problems = [];
            _answered = false;

            _injectStyles(cfg.toolColor || 'var(--tool-primary, #6366f1)');

            var el = document.getElementById(cfg.containerId);
            if (!el) return;

            el.innerHTML = _renderShell(cfg);
            _bindShellEvents(cfg);
        },

        /** Generate a new problem set for the current difficulty. */
        generate: function () {
            if (!_cfg) return;
            var diff = _getSelectedDifficulty();
            var count = parseInt(document.getElementById('ps-count').value, 10) || 5;
            _problems = _cfg.generateProblems(diff, count);
            _answered = false;
            _score = { correct: 0, total: 0 };
            _renderProblems();
        },

        /** Check all answers and show results. */
        check: function () {
            if (!_problems.length) return;
            _answered = true;
            _score = { correct: 0, total: 0 };

            for (var i = 0; i < _problems.length; i++) {
                var p = _problems[i];
                for (var j = 0; j < p.fields.length; j++) {
                    var f = p.fields[j];
                    var input = document.getElementById('ps-f-' + i + '-' + j);
                    if (!input) continue;
                    var userVal = input.value.trim();
                    var correct = _normalise(userVal) === _normalise(f.answer);
                    _score.total++;
                    if (correct) _score.correct++;
                    input.classList.remove('ps-correct', 'ps-incorrect');
                    input.classList.add(correct ? 'ps-correct' : 'ps-incorrect');

                    // show correct answer next to incorrect
                    var fb = input.parentElement.querySelector('.ps-field-feedback');
                    if (!fb) {
                        fb = document.createElement('span');
                        fb.className = 'ps-field-feedback';
                        input.parentElement.appendChild(fb);
                    }
                    fb.textContent = correct ? '' : f.answer;
                    fb.className = 'ps-field-feedback' + (correct ? '' : ' ps-show');
                }
            }

            _renderScoreBanner();
        },

        /** Show answers without user input. */
        reveal: function () {
            if (!_problems.length) return;
            _answered = true;
            for (var i = 0; i < _problems.length; i++) {
                var p = _problems[i];
                for (var j = 0; j < p.fields.length; j++) {
                    var f = p.fields[j];
                    var input = document.getElementById('ps-f-' + i + '-' + j);
                    if (!input) continue;
                    input.value = f.answer;
                    input.classList.remove('ps-incorrect');
                    input.classList.add('ps-correct');
                    var fb = input.parentElement.querySelector('.ps-field-feedback');
                    if (fb) fb.textContent = '';
                }
            }
            var banner = document.getElementById('ps-score');
            if (banner) banner.innerHTML = '<span class="ps-score-text">Answers revealed</span>';
        },

        /** Open browser print dialog for a clean worksheet. */
        print: function () {
            if (!_problems.length) {
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generate problems first', 2000, 'warning');
                return;
            }
            var printArea = document.createElement('div');
            printArea.id = 'psPrintArea';
            printArea.innerHTML = _buildPrintHtml();
            document.body.appendChild(printArea);
            window.print();
            setTimeout(function () { printArea.remove(); }, 1200);
        },

        /** Download worksheet as PNG image using ToolUtils.downloadCanvasAsImage. */
        download: function () {
            if (!_problems.length) {
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generate problems first', 2000, 'warning');
                return;
            }
            if (typeof ToolUtils === 'undefined' || !ToolUtils.downloadCanvasAsImage) {
                // Fallback: trigger print so the user can "Save as PDF"
                this.print();
                return;
            }

            // Build a styled off-screen element for capture
            var wrapper = document.createElement('div');
            wrapper.id = 'psDownloadCapture';
            wrapper.style.cssText = 'position:fixed;left:-9999px;top:0;width:800px;padding:40px;'
                + 'font-family:Inter,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,sans-serif;'
                + 'font-size:14px;color:#0f172a;background:#fff;line-height:1.6;';
            wrapper.innerHTML = _buildDownloadHtml();
            document.body.appendChild(wrapper);

            var title = (_cfg.title || 'practice-worksheet').toLowerCase().replace(/[^a-z0-9]+/g, '-');
            var filename = title + '-' + _problems.length + 'q.png';

            ToolUtils.downloadCanvasAsImage(wrapper, filename, {
                scale: 2,
                backgroundColor: '#ffffff',
                padding: 10,
                showToast: true,
                toastMessage: 'Worksheet PNG downloaded!',
                showSupportPopup: false
            }).then(function () {
                wrapper.remove();
            }).catch(function () {
                wrapper.remove();
            });
        },

        /** Return current problems (for external use). */
        getProblems: function () { return _problems; },

        /** Return current score. */
        getScore: function () { return _score; }
    };

    // --------------- internal ---------------

    function _getSelectedDifficulty() {
        var radios = document.querySelectorAll('input[name="ps-diff"]');
        for (var i = 0; i < radios.length; i++) {
            if (radios[i].checked) return radios[i].value;
        }
        return _cfg.difficulties[0].id;
    }

    function _normalise(s) {
        return String(s).trim().toLowerCase().replace(/\s+/g, ' ');
    }

    // --------------- render shell ---------------

    function _renderShell(cfg) {
        var h = '';
        h += '<div class="ps-shell">';

        // Header row
        h += '<div class="ps-header">';
        h += '<div class="ps-title">' + _esc(cfg.title || 'Practice Sheet') + '</div>';
        h += '</div>';

        // Controls row
        h += '<div class="ps-controls">';

        // Difficulty chips
        h += '<div class="ps-diff-row">';
        for (var i = 0; i < cfg.difficulties.length; i++) {
            var d = cfg.difficulties[i];
            var checked = i === 0 ? ' checked' : '';
            h += '<label class="ps-diff-chip">';
            h += '<input type="radio" name="ps-diff" value="' + _esc(d.id) + '"' + checked + '>';
            h += '<span class="ps-diff-label">' + _esc(d.label) + '</span>';
            if (d.description) h += '<span class="ps-diff-desc">' + _esc(d.description) + '</span>';
            h += '</label>';
        }
        h += '</div>';

        // Count + Generate
        h += '<div class="ps-gen-row">';
        h += '<label class="ps-count-label">Questions:';
        h += '<select id="ps-count" class="ps-count-select">';
        h += '<option value="3">3</option>';
        h += '<option value="5" selected>5</option>';
        h += '<option value="10">10</option>';
        h += '</select></label>';
        h += '<button type="button" class="ps-btn ps-btn-generate" id="ps-generate-btn">Generate</button>';
        h += '</div>';

        h += '</div>'; // .ps-controls

        // Problems area
        h += '<div id="ps-problems" class="ps-problems">';
        h += '<div class="ps-empty">Select difficulty and click <strong>Generate</strong> to start practicing.</div>';
        h += '</div>';

        // Score banner (hidden initially)
        h += '<div id="ps-score" class="ps-score-banner"></div>';

        // Action buttons (hidden until problems exist)
        h += '<div id="ps-actions" class="ps-actions" style="display:none;">';
        h += '<button type="button" class="ps-btn ps-btn-check" id="ps-check-btn">Check Answers</button>';
        h += '<button type="button" class="ps-btn ps-btn-reveal" id="ps-reveal-btn">Show Answers</button>';
        h += '<button type="button" class="ps-btn ps-btn-print" id="ps-print-btn">Print Worksheet</button>';
        h += '<button type="button" class="ps-btn ps-btn-download" id="ps-download-btn">Download PNG</button>';
        h += '</div>';

        h += '</div>'; // .ps-shell
        return h;
    }

    function _bindShellEvents() {
        document.getElementById('ps-generate-btn').addEventListener('click', function () {
            ToolUtils.PracticeSheet.generate();
        });
        document.getElementById('ps-check-btn').addEventListener('click', function () {
            ToolUtils.PracticeSheet.check();
        });
        document.getElementById('ps-reveal-btn').addEventListener('click', function () {
            ToolUtils.PracticeSheet.reveal();
        });
        document.getElementById('ps-print-btn').addEventListener('click', function () {
            ToolUtils.PracticeSheet.print();
        });
        document.getElementById('ps-download-btn').addEventListener('click', function () {
            ToolUtils.PracticeSheet.download();
        });
    }

    // --------------- render problems ---------------

    function _renderProblems() {
        var container = document.getElementById('ps-problems');
        if (!_problems.length) {
            container.innerHTML = '<div class="ps-empty">No problems generated.</div>';
            document.getElementById('ps-actions').style.display = 'none';
            return;
        }

        var h = '';
        for (var i = 0; i < _problems.length; i++) {
            var p = _problems[i];
            h += '<div class="ps-problem">';
            h += '<div class="ps-problem-num">' + (i + 1) + '</div>';
            h += '<div class="ps-problem-body">';
            h += '<div class="ps-prompt">' + p.prompt + '</div>';
            if (p.hint) h += '<div class="ps-hint">' + _esc(p.hint) + '</div>';
            h += '<div class="ps-fields">';
            for (var j = 0; j < p.fields.length; j++) {
                var f = p.fields[j];
                h += '<div class="ps-field-group">';
                h += '<label class="ps-field-label" for="ps-f-' + i + '-' + j + '">' + _esc(f.label) + '</label>';
                h += '<div class="ps-field-input-wrap">';
                h += '<input type="text" id="ps-f-' + i + '-' + j + '" class="ps-field-input" placeholder="' + _esc(f.placeholder || '') + '" autocomplete="off" spellcheck="false">';
                h += '</div>';
                h += '</div>';
            }
            h += '</div>'; // .ps-fields
            h += '</div>'; // .ps-problem-body
            h += '</div>'; // .ps-problem
        }

        container.innerHTML = h;
        document.getElementById('ps-actions').style.display = '';
        document.getElementById('ps-score').innerHTML = '';
    }

    // --------------- score banner ---------------

    function _renderScoreBanner() {
        var banner = document.getElementById('ps-score');
        var pct = _score.total > 0 ? Math.round(_score.correct / _score.total * 100) : 0;
        var emoji = pct === 100 ? '&#127942;' : pct >= 70 ? '&#128170;' : pct >= 40 ? '&#128161;' : '&#128218;';
        banner.innerHTML = '<span class="ps-score-icon">' + emoji + '</span>'
            + '<span class="ps-score-text">' + _score.correct + ' / ' + _score.total + ' correct (' + pct + '%)</span>';
        banner.className = 'ps-score-banner ps-score-show'
            + (pct === 100 ? ' ps-score-perfect' : pct >= 70 ? ' ps-score-good' : '');
    }

    // --------------- print ---------------

    function _buildPrintHtml() {
        var h = '';
        h += '<div class="ps-print-title">' + _esc(_cfg.title || 'Practice Worksheet') + '</div>';
        var diff = _getSelectedDifficulty();
        var diffLabel = '';
        for (var d = 0; d < _cfg.difficulties.length; d++) {
            if (_cfg.difficulties[d].id === diff) { diffLabel = _cfg.difficulties[d].label; break; }
        }
        h += '<div class="ps-print-info">Difficulty: ' + _esc(diffLabel) + ' &nbsp;|&nbsp; ' + _problems.length + ' questions</div>';

        for (var i = 0; i < _problems.length; i++) {
            var p = _problems[i];
            h += '<div class="ps-print-problem">';
            h += '<div class="ps-print-num">' + (i + 1) + '.</div>';
            h += '<div class="ps-print-body">';
            h += '<div class="ps-print-prompt">' + p.prompt + '</div>';
            for (var j = 0; j < p.fields.length; j++) {
                var f = p.fields[j];
                h += '<div class="ps-print-field">' + _esc(f.label) + ': <span class="ps-print-blank"></span></div>';
            }
            h += '</div></div>';
        }

        // Answer key on second half
        h += '<div class="ps-print-answer-key">';
        h += '<div class="ps-print-answer-title">Answer Key</div>';
        for (var ai = 0; ai < _problems.length; ai++) {
            var ap = _problems[ai];
            h += '<div class="ps-print-answer-row"><strong>' + (ai + 1) + '.</strong> ';
            var parts = [];
            for (var aj = 0; aj < ap.fields.length; aj++) {
                parts.push(ap.fields[aj].label + ': ' + ap.fields[aj].answer);
            }
            h += _esc(parts.join(' | '));
            h += '</div>';
        }
        h += '</div>';

        h += '<div class="ps-print-footer">Generated by 8gwifi.org</div>';
        return h;
    }

    // --------------- download (PNG capture) ---------------

    function _buildDownloadHtml() {
        var diff = _getSelectedDifficulty();
        var diffLabel = '';
        for (var d = 0; d < _cfg.difficulties.length; d++) {
            if (_cfg.difficulties[d].id === diff) { diffLabel = _cfg.difficulties[d].label; break; }
        }

        var h = '';

        // Title
        h += '<div style="text-align:center;font-size:22px;font-weight:800;color:#0f172a;margin-bottom:4px;">'
            + _esc(_cfg.title || 'Practice Worksheet') + '</div>';
        h += '<div style="text-align:center;font-size:13px;color:#64748b;margin-bottom:20px;">'
            + 'Difficulty: ' + _esc(diffLabel) + '  |  ' + _problems.length + ' questions  |  8gwifi.org</div>';

        // Divider
        h += '<div style="height:2px;background:linear-gradient(90deg,transparent,' + (_cfg.toolColor || '#0891b2') + ',transparent);margin-bottom:20px;"></div>';

        // Problems
        for (var i = 0; i < _problems.length; i++) {
            var p = _problems[i];
            h += '<div style="display:flex;gap:10px;margin-bottom:16px;padding:12px 14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;">';
            h += '<div style="font-size:15px;font-weight:700;color:' + (_cfg.toolColor || '#0891b2') + ';min-width:24px;padding-top:2px;">' + (i + 1) + '</div>';
            h += '<div style="flex:1;">';
            // Prompt — strip any HTML tags for cleaner capture
            h += '<div style="font-size:14px;font-weight:600;color:#0f172a;margin-bottom:8px;font-family:monospace;">' + p.prompt + '</div>';
            // Fields as blank lines
            for (var j = 0; j < p.fields.length; j++) {
                var f = p.fields[j];
                h += '<div style="font-size:13px;color:#475569;margin-bottom:6px;">'
                    + _esc(f.label) + ': <span style="display:inline-block;width:160px;border-bottom:1.5px solid #94a3b8;margin-left:6px;">&nbsp;</span></div>';
            }
            h += '</div></div>';
        }

        // Answer key section
        h += '<div style="margin-top:24px;padding-top:16px;border-top:2px dashed #cbd5e1;">';
        h += '<div style="font-size:16px;font-weight:700;color:#0f172a;margin-bottom:10px;">Answer Key</div>';
        for (var ai = 0; ai < _problems.length; ai++) {
            var ap = _problems[ai];
            var parts = [];
            for (var aj = 0; aj < ap.fields.length; aj++) {
                parts.push(ap.fields[aj].label + ': ' + ap.fields[aj].answer);
            }
            h += '<div style="font-size:12px;color:#334155;margin-bottom:4px;font-family:monospace;">'
                + '<strong>' + (ai + 1) + '.</strong> ' + _esc(parts.join(' | ')) + '</div>';
        }
        h += '</div>';

        // Footer
        h += '<div style="text-align:center;color:#94a3b8;font-size:11px;margin-top:20px;">Generated by 8gwifi.org</div>';

        return h;
    }

    // --------------- styles ---------------

    function _injectStyles(color) {
        if (document.getElementById('ps-styles')) return;
        var s = document.createElement('style');
        s.id = 'ps-styles';
        s.textContent = ''
            /* shell */
            + '.ps-shell{font-family:var(--font-sans,Inter,-apple-system,sans-serif);}'
            + '.ps-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:0.75rem;}'
            + '.ps-title{font-size:1rem;font-weight:700;color:var(--text-primary,#0f172a);}'
            + '[data-theme="dark"] .ps-title{color:var(--text-primary,#f1f5f9);}'

            /* controls */
            + '.ps-controls{margin-bottom:1rem;}'
            + '.ps-diff-row{display:flex;flex-wrap:wrap;gap:0.5rem;margin-bottom:0.75rem;}'
            + '.ps-diff-chip{display:inline-flex;align-items:center;gap:0.375rem;padding:0.375rem 0.75rem;'
            + 'border:1.5px solid var(--border,#e2e8f0);border-radius:9999px;cursor:pointer;'
            + 'font-size:0.8125rem;transition:all 0.15s;background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);}'
            + '.ps-diff-chip:hover{border-color:' + color + ';}'
            + '.ps-diff-chip input{display:none;}'
            + '.ps-diff-chip input:checked+.ps-diff-label{color:' + color + ';font-weight:600;}'
            + '.ps-diff-chip:has(input:checked){border-color:' + color + ';background:rgba(8,145,178,0.08);}'
            + '.ps-diff-label{font-weight:500;}'
            + '.ps-diff-desc{font-size:0.6875rem;color:var(--text-muted,#94a3b8);}'
            + '[data-theme="dark"] .ps-diff-chip{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);color:var(--text-primary,#e2e8f0);}'
            + '[data-theme="dark"] .ps-diff-chip:has(input:checked){background:rgba(8,145,178,0.15);border-color:' + color + ';}'
            + '.ps-gen-row{display:flex;align-items:center;gap:0.75rem;}'
            + '.ps-count-label{font-size:0.8125rem;font-weight:500;color:var(--text-secondary,#475569);display:flex;align-items:center;gap:0.375rem;}'
            + '.ps-count-select{padding:0.25rem 0.5rem;border:1.5px solid var(--border,#e2e8f0);border-radius:0.375rem;font-size:0.8125rem;'
            + 'background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);cursor:pointer;}'
            + '[data-theme="dark"] .ps-count-label{color:var(--text-secondary,#94a3b8);}'
            + '[data-theme="dark"] .ps-count-select{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);color:var(--text-primary,#e2e8f0);}'

            /* buttons */
            + '.ps-btn{padding:0.5rem 1rem;border:none;border-radius:0.5rem;font-size:0.8125rem;font-weight:600;cursor:pointer;'
            + 'font-family:var(--font-sans);transition:opacity 0.15s,transform 0.1s;}'
            + '.ps-btn:active{transform:scale(0.97);}'
            + '.ps-btn-generate{background:linear-gradient(135deg,' + color + ',#06b6d4);color:#fff;}'
            + '.ps-btn-check{background:linear-gradient(135deg,#10b981,#059669);color:#fff;}'
            + '.ps-btn-reveal{background:var(--bg-secondary,#f8fafc);color:var(--text-secondary,#475569);border:1.5px solid var(--border,#e2e8f0);}'
            + '.ps-btn-print{background:var(--bg-secondary,#f8fafc);color:var(--text-secondary,#475569);border:1.5px solid var(--border,#e2e8f0);}'
            + '.ps-btn-download{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;}'
            + '[data-theme="dark"] .ps-btn-reveal,[data-theme="dark"] .ps-btn-print{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);color:var(--text-secondary,#94a3b8);}'
            + '.ps-actions{display:flex;flex-wrap:wrap;gap:0.5rem;margin-top:1rem;}'

            /* empty */
            + '.ps-empty{text-align:center;padding:2rem 1rem;color:var(--text-muted,#94a3b8);font-size:0.875rem;}'

            /* problems */
            + '.ps-problems{display:flex;flex-direction:column;gap:0.75rem;}'
            + '.ps-problem{display:flex;gap:0.75rem;padding:0.875rem;background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:0.625rem;}'
            + '[data-theme="dark"] .ps-problem{background:rgba(255,255,255,0.04);border-color:rgba(255,255,255,0.1);}'
            + '.ps-problem-num{font-size:0.875rem;font-weight:700;color:' + color + ';min-width:1.5rem;padding-top:0.125rem;}'
            + '.ps-problem-body{flex:1;min-width:0;}'
            + '.ps-prompt{font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);margin-bottom:0.5rem;font-family:var(--font-mono,monospace);}'
            + '[data-theme="dark"] .ps-prompt{color:var(--text-primary,#f1f5f9);}'
            + '.ps-hint{font-size:0.75rem;color:var(--text-muted,#94a3b8);margin-bottom:0.5rem;font-style:italic;}'

            /* fields */
            + '.ps-fields{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:0.5rem;}'
            + '.ps-field-group{display:flex;flex-direction:column;gap:0.125rem;}'
            + '.ps-field-label{font-size:0.6875rem;font-weight:500;color:var(--text-muted,#94a3b8);text-transform:uppercase;letter-spacing:0.03em;}'
            + '.ps-field-input-wrap{position:relative;}'
            + '.ps-field-input{width:100%;padding:0.375rem 0.5rem;border:1.5px solid var(--border,#e2e8f0);border-radius:0.375rem;'
            + 'font-size:0.8125rem;font-family:var(--font-mono,monospace);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);transition:border-color 0.15s;}'
            + '.ps-field-input:focus{outline:none;border-color:' + color + ';box-shadow:0 0 0 2px rgba(8,145,178,0.15);}'
            + '[data-theme="dark"] .ps-field-input{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);color:var(--text-primary,#e2e8f0);}'

            /* correct / incorrect */
            + '.ps-field-input.ps-correct{border-color:#10b981!important;background:rgba(16,185,129,0.08);}'
            + '.ps-field-input.ps-incorrect{border-color:#ef4444!important;background:rgba(239,68,68,0.08);}'
            + '[data-theme="dark"] .ps-field-input.ps-correct{background:rgba(16,185,129,0.12);}'
            + '[data-theme="dark"] .ps-field-input.ps-incorrect{background:rgba(239,68,68,0.12);}'
            + '.ps-field-feedback{display:none;font-size:0.6875rem;color:#ef4444;font-family:var(--font-mono,monospace);margin-top:0.125rem;}'
            + '.ps-field-feedback.ps-show{display:block;}'
            + '[data-theme="dark"] .ps-field-feedback{color:#fca5a5;}'

            /* score banner */
            + '.ps-score-banner{text-align:center;padding:0;overflow:hidden;max-height:0;transition:all 0.3s;}'
            + '.ps-score-banner.ps-score-show{padding:0.75rem 1rem;margin-top:0.75rem;border-radius:0.5rem;max-height:80px;'
            + 'background:var(--bg-tertiary,#f1f5f9);border:1px solid var(--border,#e2e8f0);}'
            + '.ps-score-banner.ps-score-perfect{background:rgba(16,185,129,0.12);border-color:#10b981;}'
            + '.ps-score-banner.ps-score-good{background:rgba(59,130,246,0.1);border-color:#3b82f6;}'
            + '[data-theme="dark"] .ps-score-banner.ps-score-show{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);}'
            + '[data-theme="dark"] .ps-score-banner.ps-score-perfect{background:rgba(16,185,129,0.15);border-color:#10b981;}'
            + '[data-theme="dark"] .ps-score-banner.ps-score-good{background:rgba(59,130,246,0.12);border-color:#3b82f6;}'
            + '.ps-score-icon{font-size:1.25rem;margin-right:0.5rem;}'
            + '.ps-score-text{font-size:0.9375rem;font-weight:600;color:var(--text-primary,#0f172a);}'
            + '[data-theme="dark"] .ps-score-text{color:var(--text-primary,#f1f5f9);}'

            /* print styles */
            + '@media print{'
            + 'body *{visibility:hidden!important;}#psPrintArea,#psPrintArea *{visibility:visible!important;}'
            + '#psPrintArea{position:absolute;top:0;left:0;width:100%;font-family:Arial,Helvetica,sans-serif;font-size:14px;color:#000;}'
            + '}'
            + '.ps-print-title{text-align:center;font-size:1.5rem;font-weight:700;margin-bottom:0.375rem;}'
            + '.ps-print-info{text-align:center;color:#666;margin-bottom:1.25rem;font-size:0.875rem;}'
            + '.ps-print-problem{display:flex;gap:0.5rem;margin-bottom:1rem;page-break-inside:avoid;}'
            + '.ps-print-num{font-weight:700;min-width:1.5rem;}'
            + '.ps-print-body{flex:1;}'
            + '.ps-print-prompt{font-weight:600;margin-bottom:0.5rem;font-family:monospace;}'
            + '.ps-print-field{margin-bottom:0.375rem;font-size:0.9rem;}'
            + '.ps-print-blank{display:inline-block;width:140px;border-bottom:1px solid #000;margin-left:4px;}'
            + '.ps-print-answer-key{margin-top:2rem;padding-top:1rem;border-top:2px solid #ccc;page-break-before:always;}'
            + '.ps-print-answer-title{font-size:1.1rem;font-weight:700;margin-bottom:0.5rem;}'
            + '.ps-print-answer-row{font-size:0.85rem;margin-bottom:0.25rem;font-family:monospace;}'
            + '.ps-print-footer{text-align:center;color:#999;font-size:0.75rem;margin-top:2rem;}'
        ;
        document.head.appendChild(s);
    }

    function _esc(s) {
        if (s == null) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

})();
