/**
 * Z-Transform Calculator - DOM/UI logic
 * Computes forward and inverse Z-transforms via SymPy on OneCompiler.
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.ZT_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var forwardInput  = document.getElementById('zt-forward-expr');
    var inverseInput  = document.getElementById('zt-inverse-expr');
    var previewEl     = document.getElementById('zt-preview');
    var computeBtn    = document.getElementById('zt-compute-btn');
    var resultContent = document.getElementById('zt-result-content');
    var resultActions = document.getElementById('zt-result-actions');
    var emptyState    = document.getElementById('zt-empty-state');
    var graphHint     = document.getElementById('zt-graph-hint');
    var forwardWrap   = document.getElementById('zt-forward-wrap');
    var inverseWrap   = document.getElementById('zt-inverse-wrap');

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
        var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|sqrt';
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
    var modeBtns = document.querySelectorAll('.zt-mode-btn');
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
    var tabBtns = document.querySelectorAll('.zt-output-tab');
    var panels  = document.querySelectorAll('.zt-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('zt-panel-' + panel).classList.add('active');

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
    setupToggle('zt-syntax-btn', 'zt-syntax-content');
    setupToggle('zt-pairs-btn', 'zt-pairs-content');

    // ========== Render Z-Transform Pairs Table ==========
    var pairsData = [
        ['\\delta[n]', '1'],
        ['u[n]', '\\frac{z}{z-1}'],
        ['n', '\\frac{z}{(z-1)^2}'],
        ['a^n', '\\frac{z}{z-a}'],
        ['n \\cdot a^n', '\\frac{az}{(z-a)^2}'],
        ['n^2', '\\frac{z(z+1)}{(z-1)^3}'],
        ['\\cos(\\omega_0 n)', '\\frac{z^2-z\\cos\\omega_0}{z^2-2z\\cos\\omega_0+1}'],
        ['\\sin(\\omega_0 n)', '\\frac{z\\sin\\omega_0}{z^2-2z\\cos\\omega_0+1}'],
        ['(-1)^n', '\\frac{z}{z+1}']
    ];
    for (var i = 0; i < pairsData.length; i++) {
        try {
            katex.render(pairsData[i][0], document.getElementById('zt-pair-x' + i), { throwOnError: false });
            katex.render(pairsData[i][1], document.getElementById('zt-pair-X' + i), { throwOnError: false });
        } catch(e) {}
    }

    // ========== Quick Examples ==========
    var forwardExamples = [
        { label: '1', expr: '1' },
        { label: 'n', expr: 'n' },
        { label: 'n\u00B2', expr: 'n^2' },
        { label: '(1/2)\u207F', expr: '(1/2)**n' },
        { label: '(3/4)\u207F', expr: '(3/4)**n' },
        { label: '(-1)\u207F', expr: '(-1)**n' },
        { label: 'n\u00B7(1/2)\u207F', expr: 'n*(1/2)**n' },
        { label: '2\u207F', expr: '2**n' }
    ];
    var inverseExamples = [
        { label: 'z/(z-1)', expr: 'z/(z-1)' },
        { label: 'z/(z-1/2)', expr: 'z/(z-1/2)' },
        { label: 'z/(z-1)\u00B2', expr: 'z/(z-1)^2' },
        { label: 'z/(z+1)', expr: 'z/(z+1)' },
        { label: 'z\u00B2/((z-1)(z-1/2))', expr: 'z^2/((z-1)*(z-1/2))' },
        { label: 'z/(z\u00B2-z+1/2)', expr: 'z/(z^2-z+1/2)' },
        { label: '1/(z-1)', expr: '1/(z-1)' }
    ];

    var randomForward = [
        { expr: '1' }, { expr: 'n' }, { expr: 'n^2' }, { expr: 'n^3' },
        { expr: '(1/2)**n' }, { expr: '(3/4)**n' }, { expr: '(-1)**n' },
        { expr: 'n*(1/2)**n' }, { expr: '2**n' }, { expr: '(2/3)**n' },
        { expr: 'n*(3/4)**n' }, { expr: 'cos(pi*n/3)*((1/2)**n)' }
    ];
    var randomInverse = [
        { expr: 'z/(z-1)' }, { expr: 'z/(z-1/2)' }, { expr: 'z/(z-1)^2' },
        { expr: 'z/(z+1)' }, { expr: 'z^2/((z-1)*(z-1/2))' },
        { expr: 'z/(z^2-z+1/2)' }, { expr: '1/(z-1)' },
        { expr: 'z^2/((z-1)*(z-1/3))' }, { expr: 'z*(z-1/2)/((z-1)*(z-1/4))' },
        { expr: 'z/(z-1/4)' }
    ];

    // ========== Random Button ==========
    document.getElementById('zt-random-btn').addEventListener('click', function() {
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
        var container = document.getElementById('zt-examples');
        var examples = currentMode === 'forward' ? forwardExamples : inverseExamples;
        var html = '';
        for (var i = 0; i < examples.length; i++) {
            html += '<button type="button" class="zt-example-chip" data-expr="' + escapeHtml(examples[i].expr) + '">' + escapeHtml(examples[i].label) + '</button>';
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('zt-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.zt-example-chip');
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
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a sequence x[n] above\u2026</span>';
                    return;
                }
                latex = '\\mathcal{Z}\\left\\{' + exprToLatex(expr) + '\\right\\}';
            } else {
                var expr = normalizeExpr(inverseInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function of z above\u2026</span>';
                    return;
                }
                latex = '\\mathcal{Z}^{-1}\\left\\{' + exprToLatex(expr) + '\\right\\}';
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = 'from sympy import symbols, Sum, oo, simplify, latex, sin, cos, tan, exp, log, sqrt, pi, Rational, cancel, fraction, solve, Piecewise, I\n';
        code += 'from sympy import Function\n';
        code += 'import json, numpy as np\n';
        code += 'n = symbols("n", integer=True, nonnegative=True)\n';
        code += 'z = symbols("z")\n\n';

        if (mode === 'forward') {
            var expr = exprToPython(normalizeExpr(forwardInput.value.trim()));
            code += 'x_n = ' + expr + '\n\n';
            code += 'try:\n';
            code += '    X_raw = Sum(x_n * z**(-n), (n, 0, oo)).doit()\n';
            code += '    roc_cond = None\n';
            code += '    if isinstance(X_raw, Piecewise):\n';
            code += '        X = simplify(X_raw.args[0][0])\n';
            code += '        roc_cond = str(X_raw.args[0][1])\n';
            code += '    else:\n';
            code += '        X = simplify(X_raw)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';
            // Results
            code += 'print("RESULT:" + latex(X))\n';
            code += 'print("TEXT:" + str(X))\n';
            code += 'if roc_cond:\n';
            code += '    print("CONVERGENCE:" + roc_cond)\n\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given sequence", "latex": "x[n] = " + latex(x_n)})\n';
            code += 'steps.append({"title": "Definition of Z-transform", "latex": r"X(z) = \\\\sum_{n=0}^{\\\\infty} x[n] \\\\cdot z^{-n}"})\n';
            code += 'steps.append({"title": "Evaluate the sum", "latex": "\\\\text{Identify geometric series or known pair}"})\n';
            code += 'steps.append({"title": "Simplify", "latex": "X(z) = " + latex(X)})\n';
            code += 'if roc_cond:\n';
            code += '    steps.append({"title": "Region of convergence", "latex": "\\\\text{" + roc_cond + "}"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{Z}\\\\{" + latex(x_n) + r"\\\\} = " + latex(X) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot data (stem plot for discrete sequence)
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    x_func = lambdify(n, x_n, modules=["numpy"])\n';
            code += '    n_vals = list(range(0, 21))\n';
            code += '    y_vals = [float(x_func(ni)) if np.isfinite(x_func(ni)) else 0.0 for ni in n_vals]\n';
            code += '    print("PLOT_X:" + json.dumps(n_vals))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals))\n';
            code += 'except:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y:[]")\n';
        } else {
            // Inverse mode - residue method
            var expr = exprToPython(normalizeExpr(inverseInput.value.trim()));
            code += 'from sympy import residue, apart\n';
            code += 'X_z = ' + expr + '\n\n';
            code += 'try:\n';
            code += '    integrand = X_z * z**(n-1)\n';
            code += '    denom = fraction(cancel(X_z))[1]\n';
            code += '    poles = solve(denom, z)\n';
            code += '    x_n_result = sum(residue(integrand, z, p) for p in poles)\n';
            code += '    x_n_result = simplify(x_n_result)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';
            // Results
            code += 'print("RESULT:" + latex(x_n_result))\n';
            code += 'print("TEXT:" + str(x_n_result))\n\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given X(z)", "latex": "X(z) = " + latex(X_z)})\n';
            code += 'try:\n';
            code += '    X_pf = apart(X_z / z, z)\n';
            code += '    steps.append({"title": "Compute X(z)/z for partial fractions", "latex": "\\\\frac{X(z)}{z} = " + latex(X_pf)})\n';
            code += 'except:\n';
            code += '    pass\n';
            code += 'steps.append({"title": "Find poles of denominator", "latex": "\\\\text{Poles: }" + ", ".join(latex(p) for p in poles)})\n';
            code += 'steps.append({"title": "Apply residue method", "latex": r"x[n] = \\\\sum_k \\\\text{Res}\\\\left[X(z) \\\\cdot z^{n-1}, z=z_k\\\\right]"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{Z}^{-1}\\\\{" + latex(X_z) + r"\\\\} = " + latex(x_n_result) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot data (stem plot)
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    x_func = lambdify(n, x_n_result, modules=["numpy"])\n';
            code += '    n_vals = list(range(0, 21))\n';
            code += '    y_vals = [float(x_func(ni)) if np.isfinite(x_func(ni)) else 0.0 for ni in n_vals]\n';
            code += '    print("PLOT_X:" + json.dumps(n_vals))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals))\n';
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
        var modeLabel = currentMode === 'forward' ? 'forward Z-transform' : 'inverse Z-transform';
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="zt-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing ' + modeLabel + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);
        var mode = currentMode;

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.ZT_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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
            var graphPanel = document.getElementById('zt-panel-graph');
            if (graphPanel.classList.contains('active')) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
        }

        resultActions.classList.add('visible');
    }

    function showResult(mode, resultLatex, resultText, convergence, steps) {
        var symbol = mode === 'forward'
            ? '\\mathcal{Z}\\{x[n]\\}'
            : '\\mathcal{Z}^{-1}\\{X(z)\\}';
        lastResultLatex = symbol + ' = ' + resultLatex;
        lastResultText = resultText;

        var modeLabel = mode === 'forward' ? 'Forward Z-Transform' : 'Inverse Z-Transform';
        var html = '<div class="zt-result-math">';
        html += '<div class="zt-result-label">' + modeLabel + '</div>';
        html += '<div class="zt-result-main" id="zt-r-result"></div>';

        if (convergence && convergence !== 'True' && convergence !== 'None' && mode === 'forward') {
            html += '<div class="zt-convergence-badge" id="zt-convergence">ROC: ' + escapeHtml(convergence) + '</div>';
        }

        html += '<div class="zt-result-detail"><span class="zt-method-badge">' + modeLabel + ' (SymPy CAS)</span></div>';
        html += '<button type="button" class="zt-steps-btn" id="zt-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="zt-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render(lastResultLatex, document.getElementById('zt-r-result'), { displayMode: true, throwOnError: false });

        var stepsBtn = document.getElementById('zt-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('zt-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="zt-steps-container">';
        html += '<div class="zt-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="zt-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="zt-step">';
            html += '<span class="zt-step-num">' + (i + 1) + '</span>';
            html += '<div class="zt-step-body">';
            html += '<div class="zt-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="zt-step-math" id="zt-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('zt-step-math-' + j);
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
        var html = '<div class="zt-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use explicit multiplication: n*(1/2)**n not n(1/2)^n</li>';
        html += '<li>Use ** or ^ for powers: (1/2)^n or (1/2)**n</li>';
        html += '<li>For forward mode: expression must be in terms of n</li>';
        html += '<li>For inverse mode: expression must be in terms of z</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph (Stem Plot) ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg || !cfg.x || cfg.x.length === 0) return;
        var container = document.getElementById('zt-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        // Stem plot: markers + vertical lines from y=0
        var shapes = [];
        for (var i = 0; i < cfg.x.length; i++) {
            shapes.push({
                type: 'line',
                x0: cfg.x[i], x1: cfg.x[i],
                y0: 0, y1: cfg.y[i],
                line: { color: '#059669', width: 2 }
            });
        }

        var trace = {
            x: cfg.x,
            y: cfg.y,
            type: 'scatter',
            mode: 'markers',
            marker: { color: '#059669', size: 8, line: { color: '#047857', width: 1.5 } },
            name: 'x[n]'
        };

        var layout = {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            shapes: shapes,
            xaxis: {
                title: 'n',
                dtick: 1,
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8'
            },
            yaxis: {
                title: 'x[n]',
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
        var code = 'from sympy import *\n\nn = symbols("n", integer=True, nonnegative=True)\nz = symbols("z")\n\n';
        if (currentMode === 'forward') {
            var expr = exprToPython(normalizeExpr(forwardInput.value.trim())) || '(Rational(1,2))**n';
            code += '# Forward Z-Transform\nx_n = ' + expr + '\n\n';
            code += 'X = Sum(x_n * z**(-n), (n, 0, oo)).doit()\n';
            code += 'X = simplify(X)\n\n';
            code += 'print(f"x[n] = {x_n}")\n';
            code += 'print(f"Z{{x[n]}} = X(z) = {X}")\n';
        } else {
            var expr = exprToPython(normalizeExpr(inverseInput.value.trim())) || 'z/(z-1)';
            code += '# Inverse Z-Transform (Residue Method)\nX_z = ' + expr + '\n\n';
            code += 'integrand = X_z * z**(n-1)\n';
            code += 'denom = fraction(cancel(X_z))[1]\n';
            code += 'poles = solve(denom, z)\n';
            code += 'x_n = sum(residue(integrand, z, p) for p in poles)\n';
            code += 'x_n = simplify(x_n)\n\n';
            code += 'print(f"X(z) = {X_z}")\n';
            code += 'print(f"Poles: {poles}")\n';
            code += 'print(f"Z^(-1){{X(z)}} = x[n] = {x_n}")\n';
        }
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('zt-compiler-iframe');
        iframe.src = (window.ZT_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share ==========
    document.getElementById('zt-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    // ========== Download PDF ==========
    document.getElementById('zt-download-pdf-btn').addEventListener('click', function() {
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
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#059669;';
        title.textContent = 'Z-Transform Calculator \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#059669,#10b981,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        var modeLabel = currentMode === 'forward' ? 'Forward Z-Transform' : 'Inverse Z-Transform';
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
                ? '\\mathcal{Z}\\left\\{' + exprToLatex(inputExpr) + '\\right\\}'
                : '\\mathcal{Z}^{-1}\\left\\{' + exprToLatex(inputExpr) + '\\right\\}';
            katex.render(previewLatex, qMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            qMath.textContent = currentMode === 'forward' ? forwardInput.value : inverseInput.value;
        }

        var aLabel = document.createElement('div');
        aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent = 'Result';
        container.appendChild(aLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#ecfdf5;border-radius:8px;';
        container.appendChild(aMath);
        try {
            katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            aMath.textContent = lastResultText;
        }

        var stepsArea = document.getElementById('zt-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.zt-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#059669;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.zt-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.zt-step-math');
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
        footer.innerHTML = '<span>Generated by 8gwifi.org Z-Transform Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
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

            pdf.save('z-transform-' + currentMode + '.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet ==========
    document.getElementById('zt-worksheet-btn').addEventListener('click', function() {
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
        html += '<title>Z-Transform Worksheet</title>';
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
        html += '.ws-section-number { display: inline-block; width: 28px; height: 28px; background: #059669; color: #fff; text-align: center; line-height: 28px; font-size: 14px; font-weight: bold; margin-right: 8px; }';
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
        html += '<button onclick="window.print()" style="padding:10px 28px;font-size:15px;font-weight:600;background:#059669;color:#fff;border:none;border-radius:6px;cursor:pointer;">Print Worksheet</button>';
        html += '</div>';

        html += '<div class="ws-header">';
        html += '<div class="ws-title">Z-Transform Worksheet</div>';
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
        html += '<div class="ws-section-title"><span class="ws-section-number">I</span>Forward Z-Transform &mdash; Find X(z)</div>';
        for (var i = 0; i < fwdProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Compute <strong>Z{x[n]}</strong> where ';
            html += '<span class="ws-problem-expr" data-katex="x[n] = ' + texEscape(fwdProblems[i].expr) + '"></span>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: X(z) = </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        // Inverse section
        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">II</span>Inverse Z-Transform &mdash; Find x[n]</div>';
        for (var i = 0; i < invProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Compute <strong>Z<sup>&minus;1</sup>{X(z)}</strong> where ';
            html += '<span class="ws-problem-expr" data-katex="X(z) = ' + texEscape(invProblems[i].expr) + '"></span>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: x[n] = </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        html += '<div class="ws-footer">Generated by 8gwifi.org Z-Transform Calculator &mdash; ' + new Date().toLocaleDateString() + '</div>';

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
        return s;
    }

    document.getElementById('zt-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'forward') {
            params.f = forwardInput.value;
        } else {
            params.f = inverseInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Z-Transform Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'forward' || shareMode === 'inverse')) {
            var btn = document.querySelector('.zt-mode-btn[data-mode="' + shareMode + '"]');
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

    // ========== AI: Describe in English → expression ==========
    var aiInput = document.getElementById('zt-ai-input');
    var aiBtn = document.getElementById('zt-ai-btn');
    var aiStatus = document.getElementById('zt-ai-status');

    var AI_SYSTEM = 'You are a digital signal processing expert. Given a plain-English description, output ONLY the mathematical expression.\n' +
        'If the description is a time-domain sequence, output a function of n.\n' +
        'If the description is a Z-domain system/filter, output a function of z.\n' +
        'Use * for multiplication, ^ for powers, parentheses for grouping.\n' +
        'Output ONLY the expression — no explanation, no text, no prefixes.\n\n' +
        'Examples:\n' +
        '"unit step sequence" → 1\n' +
        '"exponential decay a=0.5" → (1/2)^n\n' +
        '"cosine frequency pi/4" → cos(pi*n/4)\n' +
        '"damped sinusoid r=0.9 omega=pi/6" → 0.9^n*sin(pi*n/6)\n' +
        '"first order IIR low pass alpha=0.1" → 0.1/(1-0.9*z^(-1))\n' +
        '"digital integrator trapezoidal T=0.01" → 0.005*(z+1)/(z-1)\n' +
        '"moving average filter length 4" → (1/4)*(1+z^(-1)+z^(-2)+z^(-3))\n' +
        'RESPOND WITH ONLY THE EXPRESSION.';

    function setAiStatus(msg, cls) {
        if (!aiStatus) return;
        aiStatus.textContent = msg;
        aiStatus.className = 'zt-ai-status ' + (cls || '');
        aiStatus.style.display = msg ? 'block' : 'none';
    }

    if (aiBtn && aiInput) {
        aiBtn.addEventListener('click', function() { generateFromAI(); });
        aiInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !aiBtn.disabled) generateFromAI();
        });
        document.querySelectorAll('.zt-ai-chip').forEach(function(chip) {
            chip.addEventListener('click', function() {
                aiInput.value = chip.getAttribute('data-prompt');
                var mode = chip.getAttribute('data-mode');
                if (mode && mode !== currentMode) {
                    document.querySelector('.zt-mode-btn[data-mode="' + mode + '"]').click();
                }
                aiInput.focus();
            });
        });
    }

    function generateFromAI() {
        var desc = aiInput.value.trim();
        if (!desc) { setAiStatus('Enter a description', 'error'); return; }

        aiBtn.disabled = true;
        aiBtn.textContent = 'Thinking...';
        setAiStatus('AI is generating...', 'loading');

        fetch((window.ZT_CALC_CTX || '') + '/ai', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                messages: [
                    { role: 'system', content: AI_SYSTEM },
                    { role: 'user', content: desc + (currentMode === 'inverse' ? ' (give Z-domain function of z)' : ' (give time-domain sequence of n)') }
                ],
                stream: false
            })
        })
        .then(function(r) {
            if (r.status === 429) throw new Error('Rate limit — try again in a minute');
            if (!r.ok) throw new Error('AI unavailable');
            return r.json();
        })
        .then(function(data) {
            var text = '';
            if (data.message && data.message.content) text = data.message.content;
            else if (data.response) text = data.response;
            else if (data.choices && data.choices[0]) {
                text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');
            }
            if (!text) throw new Error('Empty AI response');

            text = text.replace(/```[a-z]*\s*/gi, '').replace(/```/g, '').trim();
            text = text.replace(/^[xXhH]\([nz]\)\s*=\s*/i, '').trim();
            var lines = text.split('\n').filter(function(l) { return l.trim() && !l.match(/^[A-Za-z ]{10,}/); });
            text = (lines[0] || text.split('\n')[0]).trim();

            if (!text || text.length > 200) throw new Error('AI returned invalid expression');

            if (currentMode === 'forward') {
                forwardInput.value = text;
                forwardInput.dispatchEvent(new Event('input', { bubbles: true }));
            } else {
                inverseInput.value = text;
                inverseInput.dispatchEvent(new Event('input', { bubbles: true }));
            }

            setAiStatus('Generated: ' + text, 'success');
            setTimeout(function() { computeBtn.click(); }, 300);
        })
        .catch(function(err) {
            setAiStatus(err.message, 'error');
        })
        .finally(function() {
            aiBtn.disabled = false;
            aiBtn.textContent = 'Generate';
        });
    }

})();
