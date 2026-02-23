/**
 * Bode Plot Generator - DOM/UI logic
 * Computes Bode magnitude & phase plots via SymPy on OneCompiler.
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.BP_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var tfInput       = document.getElementById('bp-tf-expr');
    var zpkZerosInput = document.getElementById('bp-zpk-zeros');
    var zpkPolesInput = document.getElementById('bp-zpk-poles');
    var zpkGainInput  = document.getElementById('bp-zpk-gain');
    var previewEl     = document.getElementById('bp-preview');
    var computeBtn    = document.getElementById('bp-compute-btn');
    var resultContent = document.getElementById('bp-result-content');
    var resultActions = document.getElementById('bp-result-actions');
    var emptyState    = document.getElementById('bp-empty-state');
    var graphHint     = document.getElementById('bp-graph-hint');
    var tfWrap        = document.getElementById('bp-tf-wrap');
    var zpkWrap       = document.getElementById('bp-zpk-wrap');

    var currentMode = 'transfer';
    var lastResultLatex = '';
    var lastResultText = '';
    var compilerLoaded = false;
    var pendingGraph = null;

    // ========== Utility ==========
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function exprToPython(expr) {
        var py = (expr || '').trim()
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1');
        py = py.replace(/\bln\(/g, 'log(');
        return py;
    }

    function normalizeExpr(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        var s = expr.trim();
        s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')
             .replace(/\u2074/g, '^4').replace(/\u2075/g, '^5')
             .replace(/\u2076/g, '^6').replace(/\u2077/g, '^7')
             .replace(/\u2078/g, '^8').replace(/\u2079/g, '^9')
             .replace(/\u2070/g, '^0').replace(/\u00b9/g, '^1')
             .replace(/\u03c0/g, 'pi')
             .replace(/\u221a/g, 'sqrt')
             .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')
             .replace(/\u2212/g, '-')
             .replace(/\u00d7/g, '*');
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        s = s.replace(/\bln\(/g, 'log(');
        return s;
    }

    function exprToLatex(expr) {
        if (!expr) return '';
        return expr
            .replace(/\*\*/g, '^')
            .replace(/\*/g, ' \\cdot ')
            .replace(/sqrt\(([^)]+)\)/g, '\\sqrt{$1}')
            .replace(/sin\(/g, '\\sin(')
            .replace(/cos\(/g, '\\cos(')
            .replace(/exp\(([^)]+)\)/g, 'e^{$1}')
            .replace(/\^(\d+)/g, '^{$1}')
            .replace(/\^\(([^)]+)\)/g, '^{$1}');
    }

    function prepareLatexForKatex(latex) {
        if (!latex || typeof latex !== 'string') return latex;
        latex = latex.replace(/\\\\/g, '\\');
        var hasLatex = /\\|[\^_]|\{[^}]*\}/.test(latex);
        if (!hasLatex) {
            return '\\text{' + latex.replace(/\\/g, '\\\\').replace(/}/g, '\\}') + '}';
        }
        return latex;
    }

    // ========== FAQ ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Mode Toggle ==========
    var modeBtns = document.querySelectorAll('.bp-mode-btn');
    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            if (mode === 'transfer') {
                tfWrap.style.display = '';
                zpkWrap.style.display = 'none';
            } else {
                tfWrap.style.display = 'none';
                zpkWrap.style.display = '';
            }
            updatePreview();
            updateExamples();
        });
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.bp-output-tab');
    var panels  = document.querySelectorAll('.bp-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('bp-panel-' + panel).classList.add('active');

            if (panel === 'graph' && pendingGraph) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Collapsible toggles ==========
    function setupToggle(btnId, contentId) {
        var btn = document.getElementById(btnId);
        var content = document.getElementById(contentId);
        if (!btn || !content) return;
        btn.addEventListener('click', function() {
            content.classList.toggle('open');
            var chevron = btn.querySelector('svg');
            if (chevron) chevron.style.transform = content.classList.contains('open') ? 'rotate(180deg)' : '';
        });
    }
    setupToggle('bp-syntax-btn', 'bp-syntax-content');
    setupToggle('bp-tf-btn', 'bp-tf-content');

    // ========== Render Common Transfer Functions Table ==========
    var tfData = [
        ['\\text{First-order LP}', '\\frac{1}{\\tau s+1}', '\\text{Low-pass}'],
        ['\\text{First-order HP}', '\\frac{\\tau s}{\\tau s+1}', '\\text{High-pass}'],
        ['\\text{Second-order LP}', '\\frac{\\omega_n^2}{s^2+2\\zeta\\omega_n s+\\omega_n^2}', '\\text{Low-pass}'],
        ['\\text{Second-order HP}', '\\frac{s^2}{s^2+2\\zeta\\omega_n s+\\omega_n^2}', '\\text{High-pass}'],
        ['\\text{Band-pass}', '\\frac{2\\zeta\\omega_n s}{s^2+2\\zeta\\omega_n s+\\omega_n^2}', '\\text{Band-pass}'],
        ['\\text{Integrator}', '\\frac{1}{s}', '\\text{-20 dB/dec}'],
        ['\\text{Differentiator}', 's', '\\text{+20 dB/dec}'],
        ['\\text{PID Controller}', 'K_p+\\frac{K_i}{s}+K_d s', '\\text{Control}']
    ];
    for (var i = 0; i < tfData.length; i++) {
        try {
            katex.render(tfData[i][0], document.getElementById('bp-tf-sys-' + i), { throwOnError: false });
            katex.render(tfData[i][1], document.getElementById('bp-tf-hs-' + i), { throwOnError: false });
            katex.render(tfData[i][2], document.getElementById('bp-tf-type-' + i), { throwOnError: false });
        } catch(e) {}
    }

    // ========== Quick Examples ==========
    var tfExamples = [
        { label: '1/(s+1)', expr: '1/(s+1)' },
        { label: '1/(s\u00B2+2s+1)', expr: '1/(s^2+2*s+1)' },
        { label: '10/(s+10)', expr: '10/(s+10)' },
        { label: 's/(s+1)', expr: 's/(s+1)' },
        { label: '100/(s\u00B2+10s+100)', expr: '100/(s^2+10*s+100)' },
        { label: '(s+1)/(s\u00B2+s+1)', expr: '(s+1)/(s^2+s+1)' },
        { label: '1/(s(s+1))', expr: '1/(s*(s+1))' },
        { label: '10(s+1)/(s(s+10))', expr: '10*(s+1)/(s*(s+10))' },
        { label: '1/(s\u00B3+2s\u00B2+2s+1)', expr: '1/(s^3+2*s^2+2*s+1)' },
        { label: '\u03C9\u00B2/(s\u00B2+2\u03B6\u03C9s+\u03C9\u00B2)', expr: '100/(s^2+2*s+100)' }
    ];

    var zpkExamples = [
        { label: 'K=1, z=[], p=[-1]', zeros: '', poles: '-1', gain: '1' },
        { label: 'K=10, z=[-1], p=[0,-10]', zeros: '-1', poles: '0,-10', gain: '10' },
        { label: 'K=100, z=[], p=[-5+8.66j,-5-8.66j]', zeros: '', poles: '-5+8.66j,-5-8.66j', gain: '100' }
    ];

    var randomPool = [
        { expr: '1/(s+1)' }, { expr: '1/(s^2+2*s+1)' }, { expr: '10/(s+10)' },
        { expr: 's/(s+1)' }, { expr: '100/(s^2+10*s+100)' }, { expr: '(s+1)/(s^2+s+1)' },
        { expr: '1/(s*(s+1))' }, { expr: '10*(s+1)/(s*(s+10))' }, { expr: '1/(s^3+2*s^2+2*s+1)' },
        { expr: '100/(s^2+2*s+100)' }, { expr: '1/(s^2+0.5*s+4)' }, { expr: 's^2/(s^2+s+1)' },
        { expr: '(s+2)/((s+1)*(s+3))' }, { expr: '1000/((s+10)*(s+100))' }, { expr: '(s^2+1)/(s^2+s+1)' },
        { expr: '1/(s+5)' }, { expr: '50/(s^2+7*s+50)' }
    ];

    // ========== Random Button ==========
    document.getElementById('bp-random-btn').addEventListener('click', function() {
        if (currentMode === 'transfer') {
            var ex = randomPool[Math.floor(Math.random() * randomPool.length)];
            tfInput.value = ex.expr;
        } else {
            var ex = zpkExamples[Math.floor(Math.random() * zpkExamples.length)];
            zpkZerosInput.value = ex.zeros;
            zpkPolesInput.value = ex.poles;
            zpkGainInput.value = ex.gain;
        }
        updatePreview();
    });

    function updateExamples() {
        var container = document.getElementById('bp-examples');
        var html = '';
        if (currentMode === 'transfer') {
            for (var i = 0; i < tfExamples.length; i++) {
                html += '<button type="button" class="bp-example-chip" data-expr="' + escapeHtml(tfExamples[i].expr) + '">' + escapeHtml(tfExamples[i].label) + '</button>';
            }
        } else {
            for (var i = 0; i < zpkExamples.length; i++) {
                html += '<button type="button" class="bp-example-chip" data-zeros="' + escapeHtml(zpkExamples[i].zeros) + '" data-poles="' + escapeHtml(zpkExamples[i].poles) + '" data-gain="' + escapeHtml(zpkExamples[i].gain) + '">' + escapeHtml(zpkExamples[i].label) + '</button>';
            }
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('bp-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.bp-example-chip');
        if (!chip) return;
        if (currentMode === 'transfer') {
            tfInput.value = chip.getAttribute('data-expr');
        } else {
            zpkZerosInput.value = chip.getAttribute('data-zeros') || '';
            zpkPolesInput.value = chip.getAttribute('data-poles') || '';
            zpkGainInput.value = chip.getAttribute('data-gain') || '1';
        }
        updatePreview();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    function bindPreviewInput(el) {
        if (!el) return;
        el.addEventListener('input', function() {
            clearTimeout(previewTimer);
            previewTimer = setTimeout(updatePreview, 200);
        });
    }
    bindPreviewInput(tfInput);
    bindPreviewInput(zpkZerosInput);
    bindPreviewInput(zpkPolesInput);
    bindPreviewInput(zpkGainInput);

    function updatePreview() {
        try {
            var latex;
            if (currentMode === 'transfer') {
                var expr = normalizeExpr(tfInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a transfer function H(s) above\u2026</span>';
                    return;
                }
                latex = 'H(s) = ' + exprToLatex(expr);
            } else {
                var z = zpkZerosInput.value.trim();
                var p = zpkPolesInput.value.trim();
                var k = zpkGainInput.value.trim() || '1';
                if (!p && !z) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter zeros, poles, and gain\u2026</span>';
                    return;
                }
                latex = 'H(s) = ' + k + ' \\cdot \\frac{' + (z ? '\\prod(s - z_i)' : '1') + '}{' + (p ? '\\prod(s - p_i)' : '1') + '}';
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = 'from sympy import symbols, fraction, cancel, Poly, solve, latex, simplify, sqrt, pi, exp, log, Rational\n';
        code += 'import numpy as np\nimport json\n\n';
        code += 's = symbols("s")\n\n';

        if (mode === 'transfer') {
            var expr = exprToPython(normalizeExpr(tfInput.value.trim()));
            code += 'expr = ' + expr + '\n\n';
        } else {
            var zeros = zpkZerosInput.value.trim();
            var poles = zpkPolesInput.value.trim();
            var gain = zpkGainInput.value.trim() || '1';
            code += 'K = ' + gain + '\n';
            code += 'num_expr = K\n';
            if (zeros) {
                var zarr = zeros.split(',');
                for (var i = 0; i < zarr.length; i++) {
                    code += 'num_expr = num_expr * (s - (' + zarr[i].trim() + '))\n';
                }
            }
            code += 'den_expr = 1\n';
            if (poles) {
                var parr = poles.split(',');
                for (var i = 0; i < parr.length; i++) {
                    code += 'den_expr = den_expr * (s - (' + parr[i].trim() + '))\n';
                }
            }
            code += 'from sympy import expand\n';
            code += 'expr = expand(num_expr) / expand(den_expr)\n\n';
        }

        // Get numerator and denominator coefficients
        code += 'num, den = fraction(cancel(expr))\n';
        code += 'num_poly = Poly(num, s)\n';
        code += 'den_poly = Poly(den, s)\n';
        code += 'num_coeffs = [complex(c) for c in num_poly.all_coeffs()]\n';
        code += 'den_coeffs = [complex(c) for c in den_poly.all_coeffs()]\n\n';

        // Frequency sweep
        code += 'w = np.logspace(-2, 4, 500)\n';
        code += 'jw = 1j * w\n\n';

        // Evaluate H(jw)
        code += 'num_val = np.polyval(num_coeffs, jw)\n';
        code += 'den_val = np.polyval(den_coeffs, jw)\n';
        code += 'H = num_val / den_val\n\n';

        code += 'mag_db = 20 * np.log10(np.abs(H) + 1e-30)\n';
        code += 'phase_deg = np.degrees(np.unwrap(np.angle(H)))\n\n';

        // Zeros and poles
        code += 'zeros = solve(num, s)\n';
        code += 'poles = solve(den, s)\n\n';

        // Output
        code += 'print("RESULT:" + latex(expr))\n';
        code += 'print("TEXT:" + str(expr))\n';
        code += 'print("ZEROS:" + json.dumps([str(z) for z in zeros]))\n';
        code += 'print("POLES:" + json.dumps([str(p) for p in poles]))\n\n';

        // Steps
        code += 'steps = []\n';
        code += 'steps.append({"title": "Given transfer function", "latex": "H(s) = " + latex(expr)})\n';
        code += 'steps.append({"title": "Factor numerator and denominator", "latex": "\\\\text{Numerator: } " + latex(num) + ", \\\\quad \\\\text{Denominator: } " + latex(den)})\n';
        code += 'if zeros:\n';
        code += '    steps.append({"title": "Zeros (roots of numerator)", "latex": "s = " + ", ".join([latex(z) for z in zeros])})\n';
        code += 'else:\n';
        code += '    steps.append({"title": "Zeros", "latex": "\\\\text{None}"})\n';
        code += 'steps.append({"title": "Poles (roots of denominator)", "latex": "s = " + ", ".join([latex(p) for p in poles])})\n';
        code += 'steps.append({"title": "System order", "latex": "\\\\text{Order } " + str(den_poly.degree())})\n';
        code += 'steps.append({"title": "Bode magnitude", "latex": "|H(j\\\\omega)|_{\\\\text{dB}} = 20 \\\\log_{10}|H(j\\\\omega)|"})\n';
        code += 'steps.append({"title": "Bode phase", "latex": "\\\\angle H(j\\\\omega) = \\\\arg(H(j\\\\omega))"})\n';
        code += 'print("STEPS:" + json.dumps(steps))\n\n';

        // Plot data
        code += 'print("PLOT_W:" + json.dumps(w.tolist()))\n';
        code += 'print("PLOT_MAG:" + json.dumps(mag_db.tolist()))\n';
        code += 'print("PLOT_PHASE:" + json.dumps(phase_deg.tolist()))\n';

        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    tfInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });

    function doCompute() {
        var inputVal;
        if (currentMode === 'transfer') {
            inputVal = tfInput.value.trim();
        } else {
            inputVal = zpkPolesInput.value.trim() || zpkZerosInput.value.trim();
        }
        if (!inputVal) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a transfer function.', 2000, 'warning');
            return;
        }

        resultActions.classList.remove('visible');
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="bp-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing Bode plot...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.BP_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            clearTimeout(timeoutId);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();

            if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                showError(stderr || 'Computation failed. Check your expression syntax.');
                return;
            }

            var errMatch = stdout.match(/ERROR:(.+)/);
            if (errMatch) {
                showError(errMatch[1].trim());
                return;
            }

            parseAndShowResult(stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            showError(err.name === 'AbortError' ? 'Request timed out' : err.message);
        });
    }

    // ========== Parse & Display Result ==========
    function parseAndShowResult(stdout) {
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\nPLOT|$)/);
        var plotWMatch = stdout.match(/PLOT_W:(\[[\s\S]*?\])/);
        var plotMagMatch = stdout.match(/PLOT_MAG:(\[[\s\S]*?\])/);
        var plotPhaseMatch = stdout.match(/PLOT_PHASE:(\[[\s\S]*?\])/);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch(e) {}
        var plotW = [], plotMag = [], plotPhase = [];
        try { if (plotWMatch) plotW = JSON.parse(plotWMatch[1]); } catch(e) {}
        try { if (plotMagMatch) plotMag = JSON.parse(plotMagMatch[1]); } catch(e) {}
        try { if (plotPhaseMatch) plotPhase = JSON.parse(plotPhaseMatch[1]); } catch(e) {}

        var rMatch = stdout.match(/RESULT:([^\n]*)/);
        var tMatch = stdout.match(/TEXT:([^\n]*)/);
        var zMatch = stdout.match(/ZEROS:(\[[^\n]*\])/);
        var pMatch = stdout.match(/POLES:(\[[^\n]*\])/);

        var result = rMatch ? rMatch[1].trim() : '0';
        var text = tMatch ? tMatch[1].trim() : result;
        var zeros = [];
        var poles = [];
        try { if (zMatch) zeros = JSON.parse(zMatch[1]); } catch(e) {}
        try { if (pMatch) poles = JSON.parse(pMatch[1]); } catch(e) {}

        showResult(result, text, zeros, poles, steps);

        if (plotW.length > 0 && plotMag.length > 0) {
            pendingGraph = { w: plotW, mag: plotMag, phase: plotPhase };
            if (graphHint) graphHint.style.display = 'none';
            var graphPanel = document.getElementById('bp-panel-graph');
            if (graphPanel.classList.contains('active')) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
        }

        resultActions.classList.add('visible');
    }

    function showResult(resultLatex, resultText, zeros, poles, steps) {
        lastResultLatex = 'H(s) = ' + resultLatex;
        lastResultText = resultText;

        var html = '<div class="bp-result-math">';
        html += '<div class="bp-result-label">Transfer Function</div>';
        html += '<div class="bp-result-main" id="bp-r-result"></div>';

        if (zeros.length > 0) {
            html += '<div class="bp-info-badge">Zeros: ' + escapeHtml(zeros.join(', ')) + '</div>';
        }
        if (poles.length > 0) {
            html += '<div class="bp-info-badge">Poles: ' + escapeHtml(poles.join(', ')) + '</div>';
        }

        html += '<div class="bp-result-detail"><span class="bp-method-badge">Bode Plot Generator (SymPy CAS)</span></div>';
        html += '<button type="button" class="bp-steps-btn" id="bp-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="bp-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render(lastResultLatex, document.getElementById('bp-r-result'), { displayMode: true, throwOnError: false });

        var stepsBtn = document.getElementById('bp-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('bp-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="bp-steps-container">';
        html += '<div class="bp-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="bp-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="bp-step">';
            html += '<span class="bp-step-num">' + (i + 1) + '</span>';
            html += '<div class="bp-step-body">';
            html += '<div class="bp-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="bp-step-math" id="bp-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('bp-step-math-' + j);
            if (el && steps[j].latex) {
                try {
                    katex.render(prepareLatexForKatex(steps[j].latex), el, { displayMode: true, throwOnError: false });
                } catch (e) {
                    el.textContent = steps[j].latex;
                }
            }
        }
    }

    // ========== Error State ==========
    function showError(msg) {
        resultActions.classList.remove('visible');
        var html = '<div class="bp-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use explicit multiplication: 2*s not 2s</li>';
        html += '<li>Use ^ for powers: s^2 or (s+1)^2</li>';
        html += '<li>Expression must be a rational function in s</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph (Dual Subplot Bode Plot) ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg || !cfg.w || cfg.w.length === 0) return;
        var container = document.getElementById('bp-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        var magTrace = {
            x: cfg.w,
            y: cfg.mag,
            type: 'scatter',
            mode: 'lines',
            line: { color: '#dc2626', width: 2.5 },
            name: '|H(j\u03C9)| dB',
            xaxis: 'x',
            yaxis: 'y'
        };

        var phaseTrace = {
            x: cfg.w,
            y: cfg.phase,
            type: 'scatter',
            mode: 'lines',
            line: { color: '#2563eb', width: 2.5 },
            name: '\u2220H(j\u03C9)\u00B0',
            xaxis: 'x2',
            yaxis: 'y2'
        };

        var layout = {
            grid: { rows: 2, columns: 1, pattern: 'independent', roworder: 'top to bottom' },
            margin: { t: 30, r: 30, b: 50, l: 70 },
            xaxis: {
                type: 'log',
                title: '',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8'
            },
            yaxis: {
                title: 'Magnitude (dB)',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
                domain: [0.55, 1]
            },
            xaxis2: {
                type: 'log',
                title: '\u03C9 (rad/s)',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8'
            },
            yaxis2: {
                title: 'Phase (\u00B0)',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
                domain: [0, 0.42]
            },
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#cbd5e1' : '#475569' },
            showlegend: false
        };

        Plotly.newPlot(container, [magTrace, phaseTrace], layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function buildCompilerCode() {
        var code = 'from sympy import *\nimport numpy as np\n\ns = symbols("s")\n\n';
        var expr = exprToPython(normalizeExpr(tfInput.value.trim())) || '1/(s**2 + 2*s + 1)';
        code += '# Bode Plot Generator\nH = ' + expr + '\n\n';
        code += 'num, den = fraction(cancel(H))\n';
        code += 'num_poly = Poly(num, s)\n';
        code += 'den_poly = Poly(den, s)\n\n';
        code += 'print(f"H(s) = {H}")\n';
        code += 'print(f"Zeros: {solve(num, s)}")\n';
        code += 'print(f"Poles: {solve(den, s)}")\n';
        code += 'print(f"Order: {den_poly.degree()}")\n';
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('bp-compiler-iframe');
        iframe.src = (window.BP_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share ==========
    document.getElementById('bp-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    // ========== Download PDF ==========
    document.getElementById('bp-download-pdf-btn').addEventListener('click', function() {
        downloadResultPdf();
    });

    function downloadResultPdf() {
        if (!lastResultLatex) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
            return;
        }

        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#dc2626;';
        title.textContent = 'Bode Plot Generator \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#dc2626,#ef4444,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = 'Transfer Function';
        container.appendChild(qLabel);

        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
        container.appendChild(qMath);
        try {
            katex.render(lastResultLatex, qMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            qMath.textContent = lastResultText;
        }

        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Bode Plot Generator</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

        var loadHtml2Canvas = (typeof html2canvas !== 'undefined')
            ? Promise.resolve()
            : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');

        loadHtml2Canvas.then(function() {
            return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
        }).then(function() {
            return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false });
        }).then(function(canvas) {
            document.body.removeChild(container);
            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
            var pageWidth = pdf.internal.pageSize.getWidth();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            pdf.addImage(imgData, 'PNG', margin, margin, usableWidth, imgHeight);
            pdf.save('bode-plot.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet ==========
    document.getElementById('bp-worksheet-btn').addEventListener('click', function() {
        generateWorksheet();
    });

    function shuffleArray(arr) {
        var a = arr.slice();
        for (var i = a.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var tmp = a[i]; a[i] = a[j]; a[j] = tmp;
        }
        return a;
    }

    function generateWorksheet() {
        var problems = shuffleArray(randomPool).slice(0, 8);
        var win = window.open('', '_blank');
        if (!win) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please allow pop-ups to print worksheet', 3000, 'warning');
            return;
        }

        var katexCSS = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css';
        var katexJS  = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js';

        var html = '<!DOCTYPE html><html><head><meta charset="utf-8">';
        html += '<title>Bode Plot Worksheet</title>';
        html += '<link rel="stylesheet" href="' + katexCSS + '">';
        html += '<style>';
        html += 'body { font-family: "Times New Roman", Georgia, serif; max-width: 750px; margin: 0 auto; padding: 24px 32px; color: #111; line-height: 1.5; }';
        html += '.ws-header { text-align: center; border-bottom: 3px double #333; padding-bottom: 12px; margin-bottom: 8px; }';
        html += '.ws-title { font-size: 22px; font-weight: bold; margin: 0 0 4px 0; }';
        html += '.ws-subtitle { font-size: 13px; color: #555; margin: 0; }';
        html += '.ws-meta { display: flex; justify-content: space-between; font-size: 13px; margin: 12px 0 20px 0; border-bottom: 1px solid #ccc; padding-bottom: 8px; }';
        html += '.ws-meta-field { border-bottom: 1px solid #333; min-width: 160px; display: inline-block; margin-left: 4px; }';
        html += '.ws-problem { margin-bottom: 6px; page-break-inside: avoid; }';
        html += '.ws-problem-num { font-weight: bold; margin-right: 6px; }';
        html += '.ws-problem-expr { font-size: 16px; margin: 6px 0; }';
        html += '.ws-workspace { border: 1px dashed #ccc; min-height: 100px; margin: 8px 0; padding: 6px; position: relative; }';
        html += '.ws-workspace::after { content: "Sketch Bode plot here"; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); color: #ddd; font-size: 12px; font-style: italic; }';
        html += '.ws-answer-line { border-bottom: 1px solid #333; height: 28px; margin: 4px 0 16px 0; font-size: 13px; color: #888; padding-top: 8px; }';
        html += '.ws-footer { text-align: center; font-size: 10px; color: #999; margin-top: 24px; border-top: 1px solid #ddd; padding-top: 8px; }';
        html += '.ws-no-print { text-align: center; margin-bottom: 16px; }';
        html += '@media print { .ws-no-print { display: none; } .ws-workspace { min-height: 130px; } }';
        html += '</style></head><body>';

        html += '<div class="ws-no-print">';
        html += '<button onclick="window.print()" style="padding:10px 28px;font-size:15px;font-weight:600;background:#dc2626;color:#fff;border:none;border-radius:6px;cursor:pointer;">Print Worksheet</button>';
        html += '</div>';

        html += '<div class="ws-header">';
        html += '<div class="ws-title">Bode Plot Worksheet</div>';
        html += '<div class="ws-subtitle">Magnitude &amp; Phase Plots</div>';
        html += '</div>';

        html += '<div class="ws-meta">';
        html += '<span>Name: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Date: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Score: <span class="ws-meta-field">&nbsp; / ' + problems.length + '</span></span>';
        html += '</div>';

        for (var i = 0; i < problems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + (i + 1) + '.</span>';
            html += 'Sketch the Bode plot (magnitude and phase) for ';
            html += '<span class="ws-problem-expr" data-katex="H(s) = ' + texEscape(problems[i].expr) + '"></span>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Corner frequencies: </div>';
            html += '</div>';
        }

        html += '<div class="ws-footer">Generated by 8gwifi.org Bode Plot Generator &mdash; ' + new Date().toLocaleDateString() + '</div>';

        html += '<script src="' + katexJS + '"><\/script>';
        html += '<script>';
        html += 'document.addEventListener("DOMContentLoaded", function() {';
        html += '  var exprs = document.querySelectorAll("[data-katex]");';
        html += '  for (var i = 0; i < exprs.length; i++) {';
        html += '    try { katex.render(exprs[i].getAttribute("data-katex"), exprs[i], { displayMode: false, throwOnError: false }); }';
        html += '    catch(e) { exprs[i].textContent = exprs[i].getAttribute("data-katex"); }';
        html += '  }';
        html += '});';
        html += '<\/script>';
        html += '</body></html>';

        win.document.write(html);
        win.document.close();
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Worksheet opened! Use Print or Save as PDF.', 2500, 'success');
    }

    function texEscape(s) {
        s = s.replace(/\*/g, ' \\cdot ');
        s = s.replace(/\^(\d+)/g, '^{$1}');
        s = s.replace(/\^([a-zA-Z])/g, '^{$1}');
        s = s.replace(/\^\(([^)]+)\)/g, '^{$1}');
        return s;
    }

    document.getElementById('bp-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'transfer') {
            params.f = tfInput.value;
        } else {
            params.z = zpkZerosInput.value;
            params.p = zpkPolesInput.value;
            params.k = zpkGainInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Bode Plot Generator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'transfer' || shareMode === 'zpk')) {
            var btn = document.querySelector('.bp-mode-btn[data-mode="' + shareMode + '"]');
            if (btn) btn.click();
            if (shareMode === 'transfer') {
                var f = urlParams.get('f');
                if (f) { tfInput.value = f; updatePreview(); }
            } else {
                var z = urlParams.get('z');
                var p = urlParams.get('p');
                var k = urlParams.get('k');
                if (z) zpkZerosInput.value = z;
                if (p) zpkPolesInput.value = p;
                if (k) zpkGainInput.value = k;
                updatePreview();
            }
        }
    } catch(e) {}

})();
