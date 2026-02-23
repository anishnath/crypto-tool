/**
 * Laplace Transform Calculator - DOM/UI logic
 * Computes forward and inverse Laplace transforms via SymPy on OneCompiler.
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.LT_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var forwardInput  = document.getElementById('lt-forward-expr');
    var inverseInput  = document.getElementById('lt-inverse-expr');
    var previewEl     = document.getElementById('lt-preview');
    var computeBtn    = document.getElementById('lt-compute-btn');
    var resultContent = document.getElementById('lt-result-content');
    var resultActions = document.getElementById('lt-result-actions');
    var emptyState    = document.getElementById('lt-empty-state');
    var graphHint     = document.getElementById('lt-graph-hint');
    var forwardWrap   = document.getElementById('lt-forward-wrap');
    var inverseWrap   = document.getElementById('lt-inverse-wrap');

    var currentMode = 'forward';
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
        var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|sqrt|Heaviside|DiracDelta';
        s = s.replace(new RegExp('(' + FUNS + ')\\s*(\\d+)\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2*$3)');
        s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2)');
        s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
        s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
        s = s.replace(new RegExp('([b-zB-Z])(' + FUNS + ')\\(', 'g'), '$1*$2(');
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
            .replace(/tan\(/g, '\\tan(')
            .replace(/sinh\(/g, '\\sinh(')
            .replace(/cosh\(/g, '\\cosh(')
            .replace(/tanh\(/g, '\\tanh(')
            .replace(/log\(/g, '\\ln(')
            .replace(/exp\(([^)]+)\)/g, 'e^{$1}')
            .replace(/Heaviside\(/g, '\\theta(')
            .replace(/DiracDelta\(/g, '\\delta(')
            .replace(/\^([a-zA-Z0-9]+)/g, '^{$1}')
            .replace(/\^(\([^)]+\))/g, '^{$1}');
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
    var modeBtns = document.querySelectorAll('.lt-mode-btn');
    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            if (mode === 'forward') {
                forwardWrap.style.display = '';
                inverseWrap.style.display = 'none';
            } else {
                forwardWrap.style.display = 'none';
                inverseWrap.style.display = '';
            }
            updatePreview();
            updateExamples();
        });
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.lt-output-tab');
    var panels  = document.querySelectorAll('.lt-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('lt-panel-' + panel).classList.add('active');

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
        btn.addEventListener('click', function() {
            content.classList.toggle('open');
            var chevron = btn.querySelector('svg');
            chevron.style.transform = content.classList.contains('open') ? 'rotate(180deg)' : '';
        });
    }
    setupToggle('lt-syntax-btn', 'lt-syntax-content');
    setupToggle('lt-pairs-btn', 'lt-pairs-content');

    // ========== Render Laplace Pairs Table ==========
    var pairsData = [
        ['1', '\\frac{1}{s}'],
        ['t^n', '\\frac{n!}{s^{n+1}}'],
        ['e^{-at}', '\\frac{1}{s+a}'],
        ['\\sin(\\omega t)', '\\frac{\\omega}{s^2+\\omega^2}'],
        ['\\cos(\\omega t)', '\\frac{s}{s^2+\\omega^2}'],
        ['t \\cdot e^{-at}', '\\frac{1}{(s+a)^2}'],
        ['e^{-at}\\sin(\\omega t)', '\\frac{\\omega}{(s+a)^2+\\omega^2}'],
        ['\\delta(t)', '1'],
        ['\\theta(t-a)', '\\frac{e^{-as}}{s}']
    ];
    for (var i = 0; i < pairsData.length; i++) {
        try {
            katex.render(pairsData[i][0], document.getElementById('lt-pair-f' + i), { throwOnError: false });
            katex.render(pairsData[i][1], document.getElementById('lt-pair-F' + i), { throwOnError: false });
        } catch(e) {}
    }

    // ========== Quick Examples ==========
    var forwardExamples = [
        { label: '1', expr: '1' },
        { label: 't', expr: 't' },
        { label: 't\u00B2', expr: 't^2' },
        { label: 'e^(-3t)', expr: 'e^(-3*t)' },
        { label: 'sin(2t)', expr: 'sin(2*t)' },
        { label: 'cos(5t)', expr: 'cos(5*t)' },
        { label: 't\u00B7e^(-t)', expr: 't*e^(-t)' },
        { label: 'e^(-t)sin(t)', expr: 'e^(-t)*sin(t)' },
        { label: 'sinh(t)', expr: 'sinh(t)' },
        { label: '\u03B4(t)', expr: 'DiracDelta(t)' }
    ];
    var inverseExamples = [
        { label: '1/s', expr: '1/s' },
        { label: '1/s\u00B2', expr: '1/s^2' },
        { label: '1/(s+3)', expr: '1/(s+3)' },
        { label: '1/(s\u00B2+4)', expr: '1/(s^2+4)' },
        { label: 's/(s\u00B2+9)', expr: 's/(s^2+9)' },
        { label: '1/(s+1)\u00B2', expr: '1/(s+1)^2' },
        { label: '1/((s+1)(s+2))', expr: '1/((s+1)*(s+2))' },
        { label: '1/(s*(s+1))', expr: '1/(s*(s+1))' },
        { label: '1/s\u00B3', expr: '1/s^3' }
    ];

    var randomForward = [
        { expr: '1' }, { expr: 't' }, { expr: 't^2' }, { expr: 't^3' },
        { expr: 'e^(-3*t)' }, { expr: 'e^(-t)' }, { expr: 'sin(2*t)' },
        { expr: 'cos(5*t)' }, { expr: 't*e^(-t)' }, { expr: 't^2*e^(-3*t)' },
        { expr: 'e^(-t)*sin(t)' }, { expr: 'sinh(t)' }, { expr: 'cosh(t)' },
        { expr: 't*sin(t)' }, { expr: 'Heaviside(t-2)' }, { expr: 'DiracDelta(t)' },
        { expr: 'e^(-2*t)*cos(3*t)' }, { expr: 't^2*sin(t)' }
    ];
    var randomInverse = [
        { expr: '1/s' }, { expr: '1/s^2' }, { expr: '1/(s+3)' },
        { expr: '1/(s^2+4)' }, { expr: 's/(s^2+9)' }, { expr: '1/(s+1)^2' },
        { expr: '1/((s+1)*(s+2))' }, { expr: '(2*s+3)/(s^2+4*s+13)' },
        { expr: 's/(s^2+2*s+5)' }, { expr: '1/(s*(s+1))' },
        { expr: '(s+1)/(s^2*(s+2))' }, { expr: '1/s^3' },
        { expr: '1/(s^2+1)' }, { expr: 's/(s^2+4)' },
        { expr: '1/((s+1)*(s+3))' }, { expr: '(s+2)/(s^2+4*s+8)' }
    ];

    // ========== Random Button ==========
    document.getElementById('lt-random-btn').addEventListener('click', function() {
        var pool = currentMode === 'forward' ? randomForward : randomInverse;
        var ex = pool[Math.floor(Math.random() * pool.length)];
        if (currentMode === 'forward') {
            forwardInput.value = ex.expr;
        } else {
            inverseInput.value = ex.expr;
        }
        updatePreview();
    });

    function updateExamples() {
        var container = document.getElementById('lt-examples');
        var examples = currentMode === 'forward' ? forwardExamples : inverseExamples;
        var html = '';
        for (var i = 0; i < examples.length; i++) {
            html += '<button type="button" class="lt-example-chip" data-expr="' + escapeHtml(examples[i].expr) + '">' + escapeHtml(examples[i].label) + '</button>';
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('lt-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.lt-example-chip');
        if (!chip) return;
        var expr = chip.getAttribute('data-expr');
        if (currentMode === 'forward') {
            forwardInput.value = expr;
        } else {
            inverseInput.value = expr;
        }
        updatePreview();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    function bindPreviewInput(el) {
        el.addEventListener('input', function() {
            clearTimeout(previewTimer);
            previewTimer = setTimeout(updatePreview, 200);
        });
    }
    bindPreviewInput(forwardInput);
    bindPreviewInput(inverseInput);

    function updatePreview() {
        try {
            var latex;
            if (currentMode === 'forward') {
                var expr = normalizeExpr(forwardInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function of t above\u2026</span>';
                    return;
                }
                latex = '\\mathcal{L}\\left\\{' + exprToLatex(expr) + '\\right\\}';
            } else {
                var expr = normalizeExpr(inverseInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function of s above\u2026</span>';
                    return;
                }
                latex = '\\mathcal{L}^{-1}\\left\\{' + exprToLatex(expr) + '\\right\\}';
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = 'from sympy import symbols, laplace_transform, inverse_laplace_transform, apart, simplify, latex, sin, cos, tan, exp, log, sqrt, pi, sinh, cosh, tanh, Heaviside, DiracDelta, factorial, oo\n';
        code += 'from sympy import Function, Rational\n';
        code += 'import json, numpy as np\n';
        code += 't = symbols("t", positive=True)\n';
        code += 's = symbols("s")\n';
        code += 'a, w, n = symbols("a w n", positive=True)\n\n';

        if (mode === 'forward') {
            var expr = exprToPython(normalizeExpr(forwardInput.value.trim()));
            // DiracDelta needs t without positive=True (otherwise SymPy evals delta(t)→0)
            code += 'f_expr_str = "' + expr.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"\n';
            code += 'if "DiracDelta" in f_expr_str:\n';
            code += '    t_dd = symbols("t")\n';
            code += '    f_dd = eval(f_expr_str, {"t": t_dd, "s": s, "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "sinh": sinh, "cosh": cosh, "tanh": tanh, "Heaviside": Heaviside, "DiracDelta": DiracDelta, "factorial": factorial})\n';
            code += '    F, a_conv, cond = laplace_transform(f_dd, t_dd, s)\n';
            code += '    F = simplify(F)\n';
            code += '    f = f_dd.subs(t_dd, t)\n';
            code += 'else:\n';
            code += '    f = ' + expr + '\n';
            code += '    try:\n';
            code += '        F, a_conv, cond = laplace_transform(f, t, s)\n';
            code += '        F = simplify(F)\n';
            code += '    except Exception as e:\n';
            code += '        print("ERROR:" + str(e))\n';
            code += '        import sys; sys.exit(0)\n\n';
            // Results
            code += 'print("RESULT:" + latex(F))\n';
            code += 'print("TEXT:" + str(F))\n';
            code += 'print("CONVERGENCE:" + str(a_conv))\n\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given function", "latex": "f(t) = " + latex(f)})\n';
            code += 'steps.append({"title": "Definition of Laplace transform", "latex": r"\\\\mathcal{L}\\\\{f(t)\\\\} = \\\\int_0^{\\\\infty} f(t) \\\\, e^{-st} \\\\, dt"})\n';
            code += 'steps.append({"title": "Identify transform type", "latex": "\\\\text{Apply standard Laplace pair or theorem}"})\n';
            code += 'steps.append({"title": "Apply Laplace transform", "latex": "F(s) = " + latex(F)})\n';
            code += 'if a_conv is not None and str(a_conv) != "True":\n';
            code += '    steps.append({"title": "Region of convergence", "latex": "\\\\text{Re}(s) > " + latex(a_conv)})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{L}\\\\{" + latex(f) + r"\\\\} = " + latex(F) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot data (plot f(t) for forward mode)
            code += 'try:\n';
            code += '    from sympy import lambdify, Piecewise\n';
            code += '    f_num = lambdify(t, f, modules=["numpy", {"Heaviside": lambda x: np.heaviside(x, 0.5), "DiracDelta": lambda x: np.where(np.abs(x) < 0.01, 50.0, 0.0)}])\n';
            code += '    t_vals = np.linspace(0, 10, 200)\n';
            code += '    y_vals = np.array([float(f_num(ti)) if np.isfinite(f_num(ti)) else 0.0 for ti in t_vals])\n';
            code += '    y_vals = np.clip(y_vals, -1e6, 1e6)\n';
            code += '    print("PLOT_X:" + json.dumps(t_vals.tolist()))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals.tolist()))\n';
            code += 'except:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y:[]")\n';
        } else {
            // Inverse mode
            var expr = exprToPython(normalizeExpr(inverseInput.value.trim()));
            code += 'F_raw = ' + expr + '\n';
            code += 'try:\n';
            code += '    F_pf = apart(F_raw, s)\n';
            code += 'except:\n';
            code += '    F_pf = F_raw\n\n';
            code += 'try:\n';
            code += '    f = inverse_laplace_transform(F_pf, s, t, noconds=True)\n';
            code += '    f = simplify(f)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';
            // Results
            code += 'print("RESULT:" + latex(f))\n';
            code += 'print("TEXT:" + str(f))\n\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given F(s)", "latex": "F(s) = " + latex(F_raw)})\n';
            code += 'if F_pf != F_raw:\n';
            code += '    steps.append({"title": "Partial fraction decomposition", "latex": "F(s) = " + latex(F_pf)})\n';
            code += 'steps.append({"title": "Apply inverse Laplace transform", "latex": r"\\\\mathcal{L}^{-1}\\\\{F(s)\\\\} = " + latex(f)})\n';
            code += 'if "Heaviside" in str(f):\n';
            code += '    steps.append({"title": "Note: Heaviside step function", "latex": r"\\\\theta(t) = 1 \\\\text{ for } t \\\\geq 0, \\\\; 0 \\\\text{ for } t < 0"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{L}^{-1}\\\\{" + latex(F_raw) + r"\\\\} = " + latex(f) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot data (plot f(t) for inverse mode)
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    f_num = lambdify(t, f, modules=["numpy", {"Heaviside": lambda x: np.heaviside(x, 0.5), "DiracDelta": lambda x: np.where(np.abs(x) < 0.01, 50.0, 0.0)}])\n';
            code += '    t_vals = np.linspace(0, 10, 200)\n';
            code += '    y_vals = np.array([float(f_num(ti)) if np.isfinite(f_num(ti)) else 0.0 for ti in t_vals])\n';
            code += '    y_vals = np.clip(y_vals, -1e6, 1e6)\n';
            code += '    print("PLOT_X:" + json.dumps(t_vals.tolist()))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals.tolist()))\n';
            code += 'except:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y:[]")\n';
        }
        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    forwardInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });
    inverseInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });

    function doCompute() {
        var inputVal = currentMode === 'forward' ? forwardInput.value.trim() : inverseInput.value.trim();
        if (!inputVal) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter an expression.', 2000, 'warning');
            return;
        }

        resultActions.classList.remove('visible');
        var modeLabel = currentMode === 'forward' ? 'forward Laplace transform' : 'inverse Laplace transform';
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="lt-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing ' + modeLabel + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);
        var mode = currentMode;

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.LT_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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

            // Check for explicit ERROR
            var errMatch = stdout.match(/ERROR:(.+)/);
            if (errMatch) {
                showError(errMatch[1].trim());
                return;
            }

            parseAndShowResult(mode, stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            showError(err.name === 'AbortError' ? 'Request timed out' : err.message);
        });
    }

    // ========== Parse & Display Result ==========
    function parseAndShowResult(mode, stdout) {
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
        var cMatch = stdout.match(/CONVERGENCE:([^\n]*)/);

        var result = rMatch ? rMatch[1].trim() : '0';
        var text = tMatch ? tMatch[1].trim() : result;
        var convergence = cMatch ? cMatch[1].trim() : null;

        showResult(mode, result, text, convergence, steps);

        if (plotX.length > 0 && plotY.length > 0) {
            pendingGraph = { x: plotX, y: plotY, mode: mode };
            if (graphHint) graphHint.style.display = 'none';
            var graphPanel = document.getElementById('lt-panel-graph');
            if (graphPanel.classList.contains('active')) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
        }

        resultActions.classList.add('visible');
    }

    function showResult(mode, resultLatex, resultText, convergence, steps) {
        var symbol = mode === 'forward'
            ? '\\mathcal{L}\\{f(t)\\}'
            : '\\mathcal{L}^{-1}\\{F(s)\\}';
        lastResultLatex = symbol + ' = ' + resultLatex;
        lastResultText = resultText;

        var modeLabel = mode === 'forward' ? 'Forward Laplace Transform' : 'Inverse Laplace Transform';
        var html = '<div class="lt-result-math">';
        html += '<div class="lt-result-label">' + modeLabel + '</div>';
        html += '<div class="lt-result-main" id="lt-r-result"></div>';

        if (convergence && convergence !== 'True' && convergence !== 'None' && mode === 'forward') {
            html += '<div class="lt-convergence-badge" id="lt-convergence">ROC: Re(s) &gt; ' + escapeHtml(convergence) + '</div>';
        }

        html += '<div class="lt-result-detail"><span class="lt-method-badge">' + modeLabel + ' (SymPy CAS)</span></div>';
        html += '<button type="button" class="lt-steps-btn" id="lt-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="lt-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render(lastResultLatex, document.getElementById('lt-r-result'), { displayMode: true, throwOnError: false });

        var stepsBtn = document.getElementById('lt-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('lt-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="lt-steps-container">';
        html += '<div class="lt-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="lt-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="lt-step">';
            html += '<span class="lt-step-num">' + (i + 1) + '</span>';
            html += '<div class="lt-step-body">';
            html += '<div class="lt-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="lt-step-math" id="lt-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('lt-step-math-' + j);
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
        var html = '<div class="lt-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use explicit multiplication: t*e^(-t) not te^(-t)</li>';
        html += '<li>Use ^ for powers: t^2 or (s+1)^2</li>';
        html += '<li>For forward mode: expression must be in terms of t</li>';
        html += '<li>For inverse mode: expression must be in terms of s</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg || !cfg.x || cfg.x.length === 0) return;
        var container = document.getElementById('lt-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        var trace = {
            x: cfg.x,
            y: cfg.y,
            type: 'scatter',
            mode: 'lines',
            line: { color: '#0891b2', width: 2.5 },
            name: 'f(t)'
        };

        var layout = {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            xaxis: {
                title: 't',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8'
            },
            yaxis: {
                title: 'f(t)',
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
        var code = 'from sympy import *\n\nt = symbols("t", positive=True)\ns = symbols("s")\n\n';
        if (currentMode === 'forward') {
            var expr = exprToPython(normalizeExpr(forwardInput.value.trim())) || 't**2*exp(-3*t)';
            code += '# Forward Laplace Transform\nf = ' + expr + '\n\n';
            code += 'F, a_conv, cond = laplace_transform(f, t, s)\n';
            code += 'F = simplify(F)\n\n';
            code += 'print(f"f(t) = {f}")\n';
            code += 'print(f"L{{f(t)}} = F(s) = {F}")\n';
            code += 'print(f"Region of convergence: Re(s) > {a_conv}")\n';
        } else {
            var expr = exprToPython(normalizeExpr(inverseInput.value.trim())) || '1/(s**2+1)';
            code += '# Inverse Laplace Transform\nF = ' + expr + '\n\n';
            code += '# Partial fraction decomposition\n';
            code += 'F_pf = apart(F, s)\n';
            code += 'print(f"F(s) = {F}")\n';
            code += 'if F_pf != F:\n';
            code += '    print(f"Partial fractions: {F_pf}")\n\n';
            code += 'f = inverse_laplace_transform(F_pf, s, t, noconds=True)\n';
            code += 'f = simplify(f)\n';
            code += 'print(f"L^(-1){{F(s)}} = f(t) = {f}")\n';
        }
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('lt-compiler-iframe');
        iframe.src = (window.LT_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share ==========
    document.getElementById('lt-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    // ========== Download PDF ==========
    document.getElementById('lt-download-pdf-btn').addEventListener('click', function() {
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
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#0891b2;';
        title.textContent = 'Laplace Transform Calculator \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#0891b2,#06b6d4,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        var modeLabel = currentMode === 'forward' ? 'Forward Laplace Transform' : 'Inverse Laplace Transform';
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = modeLabel;
        container.appendChild(qLabel);

        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
        container.appendChild(qMath);
        try {
            var inputExpr = currentMode === 'forward' ? forwardInput.value : inverseInput.value;
            var previewLatex = currentMode === 'forward'
                ? '\\mathcal{L}\\left\\{' + exprToLatex(inputExpr) + '\\right\\}'
                : '\\mathcal{L}^{-1}\\left\\{' + exprToLatex(inputExpr) + '\\right\\}';
            katex.render(previewLatex, qMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            qMath.textContent = currentMode === 'forward' ? forwardInput.value : inverseInput.value;
        }

        var aLabel = document.createElement('div');
        aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent = 'Result';
        container.appendChild(aLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#ecfeff;border-radius:8px;';
        container.appendChild(aMath);
        try {
            katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            aMath.textContent = lastResultText;
        }

        var stepsArea = document.getElementById('lt-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.lt-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#0891b2;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.lt-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.lt-step-math');
                if (mathEl) {
                    var sMath = document.createElement('div');
                    sMath.style.cssText = 'font-size:16px;';
                    var katexAnnotation = mathEl.querySelector('annotation');
                    if (katexAnnotation) {
                        katex.render(katexAnnotation.textContent, sMath, { displayMode: true, throwOnError: false });
                    } else {
                        sMath.innerHTML = mathEl.innerHTML;
                    }
                    stepBody.appendChild(sMath);
                }

                stepRow.appendChild(stepBody);
                container.appendChild(stepRow);
            }
        }

        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Laplace Transform Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
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
            var pageHeight = pdf.internal.pageSize.getHeight();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;
            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            var usableHeight = pageHeight - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }
            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);

            pdf.save('laplace-transform-' + currentMode + '.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet ==========
    document.getElementById('lt-worksheet-btn').addEventListener('click', function() {
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
        var fwdProblems = shuffleArray(randomForward).slice(0, 6);
        var invProblems = shuffleArray(randomInverse).slice(0, 6);

        var win = window.open('', '_blank');
        if (!win) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please allow pop-ups to print worksheet', 3000, 'warning');
            return;
        }

        var katexCSS = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css';
        var katexJS  = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js';

        var html = '<!DOCTYPE html><html><head><meta charset="utf-8">';
        html += '<title>Laplace Transform Worksheet</title>';
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
        html += '.ws-section-number { display: inline-block; width: 28px; height: 28px; background: #0891b2; color: #fff; text-align: center; line-height: 28px; font-size: 14px; font-weight: bold; margin-right: 8px; }';
        html += '.ws-problem { margin-bottom: 6px; page-break-inside: avoid; }';
        html += '.ws-problem-num { font-weight: bold; margin-right: 6px; }';
        html += '.ws-problem-expr { font-size: 16px; margin: 6px 0; }';
        html += '.ws-workspace { border: 1px dashed #ccc; min-height: 100px; margin: 8px 0; padding: 6px; position: relative; }';
        html += '.ws-workspace::after { content: "Show your work here"; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); color: #ddd; font-size: 12px; font-style: italic; }';
        html += '.ws-answer-line { border-bottom: 1px solid #333; height: 28px; margin: 4px 0 16px 0; font-size: 13px; color: #888; padding-top: 8px; }';
        html += '.ws-footer { text-align: center; font-size: 10px; color: #999; margin-top: 24px; border-top: 1px solid #ddd; padding-top: 8px; }';
        html += '.ws-no-print { text-align: center; margin-bottom: 16px; }';
        html += '@media print { .ws-no-print { display: none; } .ws-workspace { min-height: 110px; } }';
        html += '</style></head><body>';

        html += '<div class="ws-no-print">';
        html += '<button onclick="window.print()" style="padding:10px 28px;font-size:15px;font-weight:600;background:#0891b2;color:#fff;border:none;border-radius:6px;cursor:pointer;">Print Worksheet</button>';
        html += '</div>';

        html += '<div class="ws-header">';
        html += '<div class="ws-title">Laplace Transform Worksheet</div>';
        html += '<div class="ws-subtitle">Forward &amp; Inverse Transforms</div>';
        html += '</div>';

        html += '<div class="ws-meta">';
        html += '<span>Name: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Date: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Score: <span class="ws-meta-field">&nbsp; / 12</span></span>';
        html += '</div>';

        var problemNum = 1;

        // Forward section
        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">I</span>Forward Laplace Transform &mdash; Find F(s)</div>';
        for (var i = 0; i < fwdProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Compute <strong>L{f(t)}</strong> where ';
            html += '<span class="ws-problem-expr" data-katex="f(t) = ' + texEscape(fwdProblems[i].expr) + '"></span>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: F(s) = </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        // Inverse section
        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">II</span>Inverse Laplace Transform &mdash; Find f(t)</div>';
        for (var i = 0; i < invProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Compute <strong>L<sup>&minus;1</sup>{F(s)}</strong> where ';
            html += '<span class="ws-problem-expr" data-katex="F(s) = ' + texEscape(invProblems[i].expr) + '"></span>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: f(t) = </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        html += '<div class="ws-footer">Generated by 8gwifi.org Laplace Transform Calculator &mdash; ' + new Date().toLocaleDateString() + '</div>';

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
        function matchParen(str, openIdx) {
            var depth = 1;
            for (var j = openIdx + 1; j < str.length; j++) {
                if (str[j] === '(') depth++;
                else if (str[j] === ')') { depth--; if (depth === 0) return j; }
            }
            return -1;
        }
        function replaceFnBrace(str, fn, texCmd) {
            var needle = fn + '(';
            var idx;
            while ((idx = str.indexOf(needle)) !== -1) {
                var openIdx = idx + fn.length;
                var closeIdx = matchParen(str, openIdx);
                if (closeIdx === -1) break;
                var inner = str.substring(openIdx + 1, closeIdx);
                str = str.substring(0, idx) + texCmd + '{' + inner + '}' + str.substring(closeIdx + 1);
            }
            return str;
        }
        function replaceFnBackslash(str, fn) {
            return str.split(fn + '(').join('\\' + fn + '(');
        }
        s = s.replace(/\*/g, ' \\cdot ');
        s = s.replace(/\^(\d+)/g, '^{$1}');
        s = s.replace(/\^([a-zA-Z])/g, '^{$1}');
        s = s.replace(/\^\(([^)]+)\)/g, '^{$1}');
        s = replaceFnBrace(s, 'sqrt', '\\sqrt');
        var fns = ['sin','cos','tan','sinh','cosh','tanh','log','ln'];
        for (var i = 0; i < fns.length; i++) {
            s = replaceFnBackslash(s, fns[i]);
        }
        s = s.replace(/Heaviside\(/g, '\\theta(');
        s = s.replace(/DiracDelta\(/g, '\\delta(');
        return s;
    }

    document.getElementById('lt-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'forward') {
            params.f = forwardInput.value;
        } else {
            params.f = inverseInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Laplace Transform Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'forward' || shareMode === 'inverse')) {
            var btn = document.querySelector('.lt-mode-btn[data-mode="' + shareMode + '"]');
            if (btn) btn.click();
            var f = urlParams.get('f');
            if (f) {
                if (shareMode === 'forward') {
                    forwardInput.value = f;
                } else {
                    inverseInput.value = f;
                }
                updatePreview();
            }
        }
    } catch(e) {}

})();
