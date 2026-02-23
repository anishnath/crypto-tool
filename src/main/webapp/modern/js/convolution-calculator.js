/**
 * Convolution Calculator - DOM/UI logic
 * Computes continuous and discrete convolution via SymPy on OneCompiler.
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.CV_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var contFInput    = document.getElementById('cv-cont-f');
    var contGInput    = document.getElementById('cv-cont-g');
    var discXInput    = document.getElementById('cv-disc-x');
    var discHInput    = document.getElementById('cv-disc-h');
    var previewEl     = document.getElementById('cv-preview');
    var computeBtn    = document.getElementById('cv-compute-btn');
    var resultContent = document.getElementById('cv-result-content');
    var resultActions = document.getElementById('cv-result-actions');
    var emptyState    = document.getElementById('cv-empty-state');
    var graphHint     = document.getElementById('cv-graph-hint');
    var contWrap      = document.getElementById('cv-cont-wrap');
    var discWrap      = document.getElementById('cv-disc-wrap');

    var currentMode = 'continuous';
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
             .replace(/\u03c0/g, 'pi')
             .replace(/\u221a/g, 'sqrt')
             .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')
             .replace(/\u2212/g, '-')
             .replace(/\u00d7/g, '*');
        var FUNS = 'sin|cos|tan|exp|log|ln|sqrt|Heaviside|DiracDelta|sinh|cosh';
        s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2)');
        s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
        s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
        s = s.replace(new RegExp('(\\d)(' + FUNS + ')\\(', 'g'), '$1*$2(');
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
            .replace(/Heaviside\(/g, '\\theta(')
            .replace(/DiracDelta\(/g, '\\delta(')
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
    var modeBtns = document.querySelectorAll('.cv-mode-btn');
    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            if (mode === 'continuous') {
                contWrap.style.display = '';
                discWrap.style.display = 'none';
            } else {
                contWrap.style.display = 'none';
                discWrap.style.display = '';
            }
            updatePreview();
            updateExamples();
        });
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.cv-output-tab');
    var panels  = document.querySelectorAll('.cv-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('cv-panel-' + panel).classList.add('active');

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
    setupToggle('cv-syntax-btn', 'cv-syntax-content');
    setupToggle('cv-props-btn', 'cv-props-content');

    // ========== Render Properties Table ==========
    var propsData = [
        ['f * g = g * f', '\\text{Order doesn\'t matter}'],
        ['(f*g)*h = f*(g*h)', '\\text{Grouping doesn\'t matter}'],
        ['f*(g+h) = f*g + f*h', '\\text{Over addition}'],
        ['f * \\delta = f', '\\delta \\text{ is identity}'],
        ['f(t-t_0)*g(t) = (f*g)(t-t_0)', '\\text{Shift passes through}'],
        ['\\frac{d}{dt}(f*g) = f\'*g = f*g\'', '\\text{Derivative of either}'],
        ['\\mathcal{F}\\{f*g\\} = F(\\omega)\\cdot G(\\omega)', '\\text{Convolution theorem}']
    ];
    for (var i = 0; i < propsData.length; i++) {
        try {
            katex.render(propsData[i][0], document.getElementById('cv-prop-formula-' + i), { throwOnError: false });
            katex.render(propsData[i][1], document.getElementById('cv-prop-notes-' + i), { throwOnError: false });
        } catch(e) {}
    }

    // ========== Quick Examples ==========
    var contExamples = [
        { label: 'e\u207B\u1D57u(t) \u2217 u(t)', f: 'exp(-t)*Heaviside(t)', g: 'Heaviside(t)' },
        { label: 'u(t) \u2217 u(t)', f: 'Heaviside(t)', g: 'Heaviside(t)' },
        { label: 'e\u207B\u1D57u(t) \u2217 e\u207B\u00B2\u1D57u(t)', f: 'exp(-t)*Heaviside(t)', g: 'exp(-2*t)*Heaviside(t)' },
        { label: 'rect \u2217 rect', f: 'Heaviside(t)-Heaviside(t-1)', g: 'Heaviside(t)-Heaviside(t-1)' },
        { label: 'te\u207B\u1D57u(t) \u2217 u(t)', f: 't*exp(-t)*Heaviside(t)', g: 'Heaviside(t)' },
        { label: 'e\u207B\u1D57u(t) \u2217 e\u207B\u1D57u(t)', f: 'exp(-t)*Heaviside(t)', g: 'exp(-t)*Heaviside(t)' },
        { label: 'sin(t)u(t) \u2217 u(t)', f: 'sin(t)*Heaviside(t)', g: 'Heaviside(t)' },
        { label: '\u03B4(t) \u2217 e\u207B\u1D57u(t)', f: 'DiracDelta(t)', g: 'exp(-t)*Heaviside(t)' }
    ];

    var discExamples = [
        { label: '[1,1,1] \u2217 [1,1,1]', x: '1,1,1', h: '1,1,1' },
        { label: '[1,2,3] \u2217 [1,1]', x: '1,2,3', h: '1,1' },
        { label: '[1,0,1] \u2217 [2,1]', x: '1,0,1', h: '2,1' },
        { label: '[1,2,1] \u2217 [1,-1]', x: '1,2,1', h: '1,-1' },
        { label: '[3,2,1] \u2217 [1,1,1,1]', x: '3,2,1', h: '1,1,1,1' },
        { label: '[1,1,1,1] \u2217 [1,1,1,1]', x: '1,1,1,1', h: '1,1,1,1' }
    ];

    var randomCont = [
        { f: 'exp(-t)*Heaviside(t)', g: 'Heaviside(t)' },
        { f: 'Heaviside(t)', g: 'Heaviside(t)' },
        { f: 'exp(-t)*Heaviside(t)', g: 'exp(-2*t)*Heaviside(t)' },
        { f: 'Heaviside(t)-Heaviside(t-1)', g: 'Heaviside(t)-Heaviside(t-1)' },
        { f: 't*exp(-t)*Heaviside(t)', g: 'Heaviside(t)' },
        { f: 'exp(-t)*Heaviside(t)', g: 'exp(-t)*Heaviside(t)' },
        { f: 'sin(t)*Heaviside(t)', g: 'Heaviside(t)' },
        { f: 'DiracDelta(t)', g: 'exp(-t)*Heaviside(t)' },
        { f: 'exp(-2*t)*Heaviside(t)', g: 'Heaviside(t)-Heaviside(t-2)' },
        { f: 't*Heaviside(t)', g: 'exp(-t)*Heaviside(t)' },
        { f: 'cos(t)*Heaviside(t)', g: 'exp(-t)*Heaviside(t)' },
        { f: 'exp(-3*t)*Heaviside(t)', g: 'exp(-t)*Heaviside(t)' }
    ];

    var randomDisc = [
        { x: '1,1,1', h: '1,1,1' },
        { x: '1,2,3', h: '1,1' },
        { x: '1,0,1', h: '2,1' },
        { x: '1,2,1', h: '1,-1' },
        { x: '3,2,1', h: '1,1,1,1' },
        { x: '1,1,1,1', h: '1,1,1,1' },
        { x: '1,2,3,4', h: '1,0,1' },
        { x: '2,1,3', h: '1,2' },
        { x: '1,-1,1,-1', h: '1,1' },
        { x: '5,3,1', h: '1,1,1' }
    ];

    // ========== Random Button ==========
    document.getElementById('cv-random-btn').addEventListener('click', function() {
        if (currentMode === 'continuous') {
            var ex = randomCont[Math.floor(Math.random() * randomCont.length)];
            contFInput.value = ex.f;
            contGInput.value = ex.g;
        } else {
            var ex = randomDisc[Math.floor(Math.random() * randomDisc.length)];
            discXInput.value = ex.x;
            discHInput.value = ex.h;
        }
        updatePreview();
    });

    function updateExamples() {
        var container = document.getElementById('cv-examples');
        var html = '';
        if (currentMode === 'continuous') {
            for (var i = 0; i < contExamples.length; i++) {
                html += '<button type="button" class="cv-example-chip" data-f="' + escapeHtml(contExamples[i].f) + '" data-g="' + escapeHtml(contExamples[i].g) + '">' + escapeHtml(contExamples[i].label) + '</button>';
            }
        } else {
            for (var i = 0; i < discExamples.length; i++) {
                html += '<button type="button" class="cv-example-chip" data-x="' + escapeHtml(discExamples[i].x) + '" data-h="' + escapeHtml(discExamples[i].h) + '">' + escapeHtml(discExamples[i].label) + '</button>';
            }
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('cv-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.cv-example-chip');
        if (!chip) return;
        if (currentMode === 'continuous') {
            contFInput.value = chip.getAttribute('data-f') || '';
            contGInput.value = chip.getAttribute('data-g') || '';
        } else {
            discXInput.value = chip.getAttribute('data-x') || '';
            discHInput.value = chip.getAttribute('data-h') || '';
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
    bindPreviewInput(contFInput);
    bindPreviewInput(contGInput);
    bindPreviewInput(discXInput);
    bindPreviewInput(discHInput);

    function updatePreview() {
        try {
            var latex;
            if (currentMode === 'continuous') {
                var f = normalizeExpr(contFInput.value.trim());
                var g = normalizeExpr(contGInput.value.trim());
                if (!f && !g) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter f(t) and g(t) above\u2026</span>';
                    return;
                }
                latex = '(' + (f ? exprToLatex(f) : 'f(t)') + ') * (' + (g ? exprToLatex(g) : 'g(t)') + ')';
            } else {
                var x = discXInput.value.trim();
                var h = discHInput.value.trim();
                if (!x && !h) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter x[n] and h[n] above\u2026</span>';
                    return;
                }
                latex = '[' + (x || 'x[n]') + '] * [' + (h || 'h[n]') + ']';
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = '';

        if (mode === 'continuous') {
            var fExpr = exprToPython(normalizeExpr(contFInput.value.trim()));
            var gExpr = exprToPython(normalizeExpr(contGInput.value.trim()));

            code += 'from sympy import symbols, integrate, simplify, latex, sin, cos, exp, log, sqrt, pi, Heaviside, DiracDelta, oo, Piecewise, lambdify\n';
            code += 'import numpy as np\nimport json\n\n';
            code += 't, tau = symbols("t tau", real=True)\n\n';
            code += 'f_expr = ' + fExpr + '\n';
            code += 'g_expr = ' + gExpr + '\n\n';
            code += 'f_tau = f_expr.subs(t, tau)\n';
            code += 'g_shifted = g_expr.subs(t, t - tau)\n\n';
            code += 'try:\n';
            code += '    conv = integrate(f_tau * g_shifted, (tau, -oo, oo))\n';
            code += '    result = simplify(conv)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';
            code += 'print("RESULT:" + latex(result))\n';
            code += 'print("TEXT:" + str(result))\n\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given functions", "latex": "f(t) = " + latex(f_expr) + ", \\\\quad g(t) = " + latex(g_expr)})\n';
            code += 'steps.append({"title": "Convolution definition", "latex": r"(f*g)(t) = \\\\int_{-\\\\infty}^{\\\\infty} f(\\\\tau) \\\\, g(t-\\\\tau) \\\\, d\\\\tau"})\n';
            code += 'steps.append({"title": "Substitute", "latex": "f(\\\\tau) = " + latex(f_tau) + ", \\\\quad g(t-\\\\tau) = " + latex(g_shifted)})\n';
            code += 'steps.append({"title": "Evaluate integral", "latex": r"\\\\int_{-\\\\infty}^{\\\\infty} " + latex(f_tau * g_shifted) + r" \\\\, d\\\\tau"})\n';
            code += 'steps.append({"title": "Result", "latex": r"\\\\boxed{(f*g)(t) = " + latex(result) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot
            code += 'try:\n';
            code += '    f_num = lambdify(t, result, modules=["numpy", {"Heaviside": lambda x: np.heaviside(x, 0.5), "DiracDelta": lambda x: np.where(np.abs(x) < 0.01, 50.0, 0.0)}])\n';
            code += '    t_vals = np.linspace(-2, 10, 300)\n';
            code += '    y_vals = np.array([float(f_num(tv)) if np.isfinite(f_num(tv)) else 0.0 for tv in t_vals])\n';
            code += '    y_vals = np.clip(y_vals, -1e6, 1e6)\n';
            code += '    print("PLOT_X:" + json.dumps(t_vals.tolist()))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals.tolist()))\n';
            code += 'except:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y:[]")\n';
        } else {
            // Discrete mode
            var xArr = discXInput.value.trim();
            var hArr = discHInput.value.trim();

            code += 'import numpy as np\nimport json\n\n';
            code += 'x = np.array([' + xArr + '], dtype=float)\n';
            code += 'h = np.array([' + hArr + '], dtype=float)\n';
            code += 'y = np.convolve(x, h).tolist()\n';
            code += 'n_vals = list(range(len(y)))\n\n';
            code += 'print("RESULT:" + str(y))\n';
            code += 'print("TEXT:" + str(y))\n\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given sequences", "latex": "x[n] = [' + xArr + '], \\\\quad h[n] = [' + hArr + ']"})\n';
            code += 'steps.append({"title": "Definition", "latex": r"(x*h)[n] = \\\\sum_{k} x[k] \\\\cdot h[n-k]"})\n';
            code += 'steps.append({"title": "Output length", "latex": "\\\\text{len}(y) = \\\\text{len}(x) + \\\\text{len}(h) - 1 = " + str(len(y))})\n';
            code += 'for i in range(len(y)):\n';
            code += '    steps.append({"title": "y[" + str(i) + "]", "latex": "y[" + str(i) + "] = " + str(y[i])})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            code += 'print("PLOT_X:" + json.dumps(n_vals))\n';
            code += 'print("PLOT_Y:" + json.dumps(y))\n';
        }
        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    [contFInput, contGInput, discXInput, discHInput].forEach(function(el) {
        if (el) el.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });
    });

    function doCompute() {
        var hasInput;
        if (currentMode === 'continuous') {
            hasInput = contFInput.value.trim() && contGInput.value.trim();
        } else {
            hasInput = discXInput.value.trim() && discHInput.value.trim();
        }
        if (!hasInput) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter both functions.', 2000, 'warning');
            return;
        }

        resultActions.classList.remove('visible');
        var modeLabel = currentMode === 'continuous' ? 'continuous convolution' : 'discrete convolution';
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="cv-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing ' + modeLabel + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.CV_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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
        var plotXMatch = stdout.match(/PLOT_X:(\[[\s\S]*?\])/);
        var plotYMatch = stdout.match(/PLOT_Y:(\[[\s\S]*?\])/);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch(e) {}
        var plotX = [], plotY = [];
        try { if (plotXMatch) plotX = JSON.parse(plotXMatch[1]); } catch(e) {}
        try { if (plotYMatch) plotY = JSON.parse(plotYMatch[1]); } catch(e) {}

        var rMatch = stdout.match(/RESULT:([^\n]*)/);
        var tMatch = stdout.match(/TEXT:([^\n]*)/);

        var result = rMatch ? rMatch[1].trim() : '0';
        var text = tMatch ? tMatch[1].trim() : result;

        showResult(result, text, steps);

        if (plotX.length > 0 && plotY.length > 0) {
            pendingGraph = { x: plotX, y: plotY, mode: currentMode };
            if (graphHint) graphHint.style.display = 'none';
            var graphPanel = document.getElementById('cv-panel-graph');
            if (graphPanel.classList.contains('active')) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
        }

        resultActions.classList.add('visible');
    }

    function showResult(resultLatex, resultText, steps) {
        var modeLabel = currentMode === 'continuous' ? 'Continuous Convolution' : 'Discrete Convolution';
        if (currentMode === 'continuous') {
            lastResultLatex = '(f * g)(t) = ' + resultLatex;
        } else {
            lastResultLatex = '(x * h)[n] = ' + resultText;
        }
        lastResultText = resultText;

        var html = '<div class="cv-result-math">';
        html += '<div class="cv-result-label">' + modeLabel + '</div>';
        html += '<div class="cv-result-main" id="cv-r-result"></div>';
        html += '<div class="cv-result-detail"><span class="cv-method-badge">' + modeLabel + (currentMode === 'continuous' ? ' (SymPy CAS)' : ' (NumPy)') + '</span></div>';
        html += '<button type="button" class="cv-steps-btn" id="cv-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="cv-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        var displayLatex = currentMode === 'continuous' ? lastResultLatex : '(x * h)[n] = [' + resultText.replace(/[\[\]]/g, '') + ']';
        try {
            katex.render(prepareLatexForKatex(displayLatex), document.getElementById('cv-r-result'), { displayMode: true, throwOnError: false });
        } catch(e) {
            document.getElementById('cv-r-result').textContent = resultText;
        }

        var stepsBtn = document.getElementById('cv-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('cv-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="cv-steps-container">';
        html += '<div class="cv-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="cv-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="cv-step">';
            html += '<span class="cv-step-num">' + (i + 1) + '</span>';
            html += '<div class="cv-step-body">';
            html += '<div class="cv-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="cv-step-math" id="cv-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('cv-step-math-' + j);
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
        var html = '<div class="cv-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        if (currentMode === 'continuous') {
            html += '<li>Check expression syntax (see Syntax Help)</li>';
            html += '<li>Use explicit multiplication: t*exp(-t) not texp(-t)</li>';
            html += '<li>Use Heaviside(t) for unit step function</li>';
            html += '<li>Use DiracDelta(t) for impulse function</li>';
        } else {
            html += '<li>Enter comma-separated numbers: 1,2,3</li>';
            html += '<li>No brackets needed, just values</li>';
            html += '<li>Both sequences must be non-empty</li>';
        }
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg || !cfg.x || cfg.x.length === 0) return;
        var container = document.getElementById('cv-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        var trace;
        if (cfg.mode === 'discrete') {
            // Stem plot
            trace = {
                x: cfg.x,
                y: cfg.y,
                type: 'bar',
                width: 0.3,
                marker: { color: '#d97706' },
                name: 'y[n]'
            };
        } else {
            trace = {
                x: cfg.x,
                y: cfg.y,
                type: 'scatter',
                mode: 'lines',
                line: { color: '#d97706', width: 2.5 },
                name: '(f*g)(t)'
            };
        }

        var xTitle = cfg.mode === 'discrete' ? 'n' : 't';
        var yTitle = cfg.mode === 'discrete' ? 'y[n]' : '(f*g)(t)';

        var layout = {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            xaxis: {
                title: xTitle,
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8'
            },
            yaxis: {
                title: yTitle,
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8'
            },
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#cbd5e1' : '#475569' }
        };

        Plotly.newPlot(container, [trace], layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function buildCompilerCode() {
        var code = '';
        if (currentMode === 'continuous') {
            var fExpr = exprToPython(normalizeExpr(contFInput.value.trim())) || 'exp(-t)*Heaviside(t)';
            var gExpr = exprToPython(normalizeExpr(contGInput.value.trim())) || 'Heaviside(t)';
            code += 'from sympy import *\n\nt, tau = symbols("t tau", real=True)\n\n';
            code += '# Continuous Convolution\nf = ' + fExpr + '\ng = ' + gExpr + '\n\n';
            code += 'f_tau = f.subs(t, tau)\ng_shifted = g.subs(t, t - tau)\n\n';
            code += 'conv = integrate(f_tau * g_shifted, (tau, -oo, oo))\n';
            code += 'result = simplify(conv)\n\n';
            code += 'print(f"f(t) = {f}")\nprint(f"g(t) = {g}")\n';
            code += 'print(f"(f*g)(t) = {result}")\n';
        } else {
            var xArr = discXInput.value.trim() || '1,2,3';
            var hArr = discHInput.value.trim() || '1,1,1';
            code += 'import numpy as np\n\n';
            code += '# Discrete Convolution\nx = np.array([' + xArr + '])\nh = np.array([' + hArr + '])\n\n';
            code += 'y = np.convolve(x, h)\n\n';
            code += 'print(f"x[n] = {x}")\nprint(f"h[n] = {h}")\n';
            code += 'print(f"y[n] = (x*h)[n] = {y}")\n';
        }
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('cv-compiler-iframe');
        iframe.src = (window.CV_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share ==========
    document.getElementById('cv-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    // ========== Download PDF ==========
    document.getElementById('cv-download-pdf-btn').addEventListener('click', function() {
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
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#d97706;';
        title.textContent = 'Convolution Calculator \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#d97706,#f59e0b,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = currentMode === 'continuous' ? 'Continuous Convolution' : 'Discrete Convolution';
        container.appendChild(qLabel);

        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;padding:16px;background:#fffbeb;border-radius:8px;';
        container.appendChild(qMath);
        try {
            katex.render(lastResultLatex, qMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            qMath.textContent = lastResultText;
        }

        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Convolution Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
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
            pdf.save('convolution-' + currentMode + '.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet ==========
    document.getElementById('cv-worksheet-btn').addEventListener('click', function() {
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
        var contProblems = shuffleArray(randomCont).slice(0, 5);
        var discProblems = shuffleArray(randomDisc).slice(0, 5);

        var win = window.open('', '_blank');
        if (!win) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please allow pop-ups to print worksheet', 3000, 'warning');
            return;
        }

        var katexCSS = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css';
        var katexJS  = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js';

        var html = '<!DOCTYPE html><html><head><meta charset="utf-8">';
        html += '<title>Convolution Worksheet</title>';
        html += '<link rel="stylesheet" href="' + katexCSS + '">';
        html += '<style>';
        html += 'body { font-family: "Times New Roman", Georgia, serif; max-width: 750px; margin: 0 auto; padding: 24px 32px; color: #111; line-height: 1.5; }';
        html += '.ws-header { text-align: center; border-bottom: 3px double #333; padding-bottom: 12px; margin-bottom: 8px; }';
        html += '.ws-title { font-size: 22px; font-weight: bold; margin: 0 0 4px 0; }';
        html += '.ws-subtitle { font-size: 13px; color: #555; margin: 0; }';
        html += '.ws-meta { display: flex; justify-content: space-between; font-size: 13px; margin: 12px 0 20px 0; border-bottom: 1px solid #ccc; padding-bottom: 8px; }';
        html += '.ws-meta-field { border-bottom: 1px solid #333; min-width: 160px; display: inline-block; margin-left: 4px; }';
        html += '.ws-section { margin-bottom: 24px; }';
        html += '.ws-section-title { font-size: 16px; font-weight: bold; margin-bottom: 12px; padding: 4px 8px; background: #f0f0f0; border: 1px solid #ddd; }';
        html += '.ws-section-number { display: inline-block; width: 28px; height: 28px; background: #d97706; color: #fff; text-align: center; line-height: 28px; font-size: 14px; font-weight: bold; margin-right: 8px; }';
        html += '.ws-problem { margin-bottom: 6px; page-break-inside: avoid; }';
        html += '.ws-problem-num { font-weight: bold; margin-right: 6px; }';
        html += '.ws-workspace { border: 1px dashed #ccc; min-height: 100px; margin: 8px 0; padding: 6px; position: relative; }';
        html += '.ws-workspace::after { content: "Show your work here"; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); color: #ddd; font-size: 12px; font-style: italic; }';
        html += '.ws-answer-line { border-bottom: 1px solid #333; height: 28px; margin: 4px 0 16px 0; font-size: 13px; color: #888; padding-top: 8px; }';
        html += '.ws-footer { text-align: center; font-size: 10px; color: #999; margin-top: 24px; border-top: 1px solid #ddd; padding-top: 8px; }';
        html += '.ws-no-print { text-align: center; margin-bottom: 16px; }';
        html += '@media print { .ws-no-print { display: none; } .ws-workspace { min-height: 110px; } }';
        html += '</style></head><body>';

        html += '<div class="ws-no-print">';
        html += '<button onclick="window.print()" style="padding:10px 28px;font-size:15px;font-weight:600;background:#d97706;color:#fff;border:none;border-radius:6px;cursor:pointer;">Print Worksheet</button>';
        html += '</div>';

        html += '<div class="ws-header">';
        html += '<div class="ws-title">Convolution Worksheet</div>';
        html += '<div class="ws-subtitle">Continuous &amp; Discrete Convolution</div>';
        html += '</div>';

        html += '<div class="ws-meta">';
        html += '<span>Name: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Date: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Score: <span class="ws-meta-field">&nbsp; / 10</span></span>';
        html += '</div>';

        var num = 1;

        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">I</span>Continuous Convolution</div>';
        for (var i = 0; i < contProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + num + '.</span>';
            html += 'Compute (f*g)(t) where f(t) = <code>' + escapeHtml(contProblems[i].f) + '</code> and g(t) = <code>' + escapeHtml(contProblems[i].g) + '</code>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: (f*g)(t) = </div>';
            html += '</div>';
            num++;
        }
        html += '</div>';

        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">II</span>Discrete Convolution</div>';
        for (var i = 0; i < discProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + num + '.</span>';
            html += 'Compute (x*h)[n] where x[n] = [' + escapeHtml(discProblems[i].x) + '] and h[n] = [' + escapeHtml(discProblems[i].h) + ']';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: y[n] = </div>';
            html += '</div>';
            num++;
        }
        html += '</div>';

        html += '<div class="ws-footer">Generated by 8gwifi.org Convolution Calculator &mdash; ' + new Date().toLocaleDateString() + '</div>';
        html += '</body></html>';

        win.document.write(html);
        win.document.close();
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Worksheet opened! Use Print or Save as PDF.', 2500, 'success');
    }

    document.getElementById('cv-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'continuous') {
            params.f = contFInput.value;
            params.g = contGInput.value;
        } else {
            params.x = discXInput.value;
            params.h = discHInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Convolution Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'continuous' || shareMode === 'discrete')) {
            var btn = document.querySelector('.cv-mode-btn[data-mode="' + shareMode + '"]');
            if (btn) btn.click();
            if (shareMode === 'continuous') {
                var f = urlParams.get('f');
                var g = urlParams.get('g');
                if (f) contFInput.value = f;
                if (g) contGInput.value = g;
            } else {
                var x = urlParams.get('x');
                var h = urlParams.get('h');
                if (x) discXInput.value = x;
                if (h) discHInput.value = h;
            }
            updatePreview();
        }
    } catch(e) {}

})();
