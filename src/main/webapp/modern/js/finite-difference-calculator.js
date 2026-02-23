/**
 * Finite Difference Calculator - DOM/UI logic
 * Computes finite difference approximations via SymPy on OneCompiler.
 * 3 modes: Symbolic, Numerical, Weights
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.FD_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var symbolicInput = document.getElementById('fd-symbolic-expr');
    var symbolicOrder = document.getElementById('fd-symbolic-order');
    var symbolicPoints = document.getElementById('fd-symbolic-points');
    var numericalData  = document.getElementById('fd-numerical-data');
    var numericalOrder = document.getElementById('fd-numerical-order');
    var numericalEvalPt = document.getElementById('fd-numerical-eval');
    var weightsOrder   = document.getElementById('fd-weights-order');
    var weightsPoints  = document.getElementById('fd-weights-points');
    var weightsCenter  = document.getElementById('fd-weights-center');
    var previewEl      = document.getElementById('fd-preview');
    var computeBtn     = document.getElementById('fd-compute-btn');
    var resultContent  = document.getElementById('fd-result-content');
    var resultActions  = document.getElementById('fd-result-actions');
    var emptyState     = document.getElementById('fd-empty-state');
    var graphHint      = document.getElementById('fd-graph-hint');

    var currentMode = 'symbolic';
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
        var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|sqrt|asin|acos|atan';
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
            .replace(/asin\(/g, '\\arcsin(')
            .replace(/acos\(/g, '\\arccos(')
            .replace(/atan\(/g, '\\arctan(')
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
    var modeBtns = document.querySelectorAll('.fd-mode-btn');
    var symbolicWrap  = document.getElementById('fd-symbolic-wrap');
    var numericalWrap = document.getElementById('fd-numerical-wrap');
    var weightsWrap   = document.getElementById('fd-weights-wrap');

    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            symbolicWrap.style.display  = mode === 'symbolic'  ? '' : 'none';
            numericalWrap.style.display = mode === 'numerical' ? '' : 'none';
            weightsWrap.style.display   = mode === 'weights'   ? '' : 'none';
            updatePreview();
            updateExamples();
        });
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.fd-output-tab');
    var panels  = document.querySelectorAll('.fd-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('fd-panel-' + panel).classList.add('active');

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
    setupToggle('fd-syntax-btn', 'fd-syntax-content');
    setupToggle('fd-formulas-btn', 'fd-formulas-content');

    // ========== Render Formulas Table ==========
    var formulasData = [
        ['Forward (1st)', '\\frac{f(x+h)-f(x)}{h}', 'O(h)'],
        ['Backward (1st)', '\\frac{f(x)-f(x-h)}{h}', 'O(h)'],
        ['Central (1st)', '\\frac{f(x+h)-f(x-h)}{2h}', 'O(h^2)'],
        ['Central (2nd)', '\\frac{f(x+h)-2f(x)+f(x-h)}{h^2}', 'O(h^2)'],
        ['5-pt Central (1st)', '\\frac{-f(x+2h)+8f(x+h)-8f(x-h)+f(x-2h)}{12h}', 'O(h^4)'],
        ['Forward (2nd)', '\\frac{f(x+2h)-2f(x+h)+f(x)}{h^2}', 'O(h)'],
        ['3-pt Forward (1st)', '\\frac{-3f(x)+4f(x+h)-f(x+2h)}{2h}', 'O(h^2)'],
        ['Richardson', '\\frac{4D(h/2)-D(h)}{3}', 'O(h^4)']
    ];
    for (var i = 0; i < formulasData.length; i++) {
        try {
            var el = document.getElementById('fd-formula-f' + i);
            if (el) katex.render(formulasData[i][1], el, { throwOnError: false });
            var accEl = document.getElementById('fd-formula-a' + i);
            if (accEl) katex.render(formulasData[i][2], accEl, { throwOnError: false });
        } catch(e) {}
    }

    // ========== Quick Examples ==========
    var symbolicExamples = [
        { label: 'x\u00B3', expr: 'x**3', order: '1' },
        { label: 'sin(x)', expr: 'sin(x)', order: '1' },
        { label: 'e\u02E3', expr: 'exp(x)', order: '1' },
        { label: 'x\u2074\u22122x\u00B2', expr: 'x**4 - 2*x**2', order: '2' },
        { label: 'ln(x)', expr: 'log(x)', order: '1' },
        { label: 'cos(x\u00B2)', expr: 'cos(x**2)', order: '1' },
        { label: '1/(1+x\u00B2)', expr: '1/(1+x**2)', order: '1' },
        { label: 'x\u00B7sin(x)', expr: 'x*sin(x)', order: '2' }
    ];
    var numericalExamples = [
        { label: 'Linear', data: '0,0; 1,2; 2,4; 3,6', order: '1', eval: '1' },
        { label: 'Quadratic', data: '0,0; 1,1; 2,4; 3,9; 4,16', order: '1', eval: '2' },
        { label: 'Cubic', data: '0,0; 1,1; 2,8; 3,27; 4,64', order: '1', eval: '2' },
        { label: 'Exponential', data: '0,1; 0.5,1.649; 1,2.718; 1.5,4.482; 2,7.389', order: '1', eval: '1' },
        { label: 'Trig data', data: '0,0; 0.5,0.479; 1,0.841; 1.5,0.997; 2,0.909', order: '2', eval: '1' },
        { label: 'Custom', data: '-2,4; -1,1; 0,0; 1,1; 2,4', order: '2', eval: '0' }
    ];
    var weightsExamples = [
        { label: '3-pt d=1', order: '1', points: '-1,0,1', center: '0' },
        { label: '5-pt d=1', order: '1', points: '-2,-1,0,1,2', center: '0' },
        { label: '3-pt d=2', order: '2', points: '-1,0,1', center: '0' },
        { label: '5-pt d=2', order: '2', points: '-2,-1,0,1,2', center: '0' }
    ];

    var randomSymbolic = [
        { expr: 'x**3', order: '1' }, { expr: 'sin(x)', order: '1' },
        { expr: 'exp(x)', order: '1' }, { expr: 'x**4 - 2*x**2', order: '2' },
        { expr: 'log(x)', order: '1' }, { expr: 'cos(x**2)', order: '1' },
        { expr: '1/(1+x**2)', order: '1' }, { expr: 'x*sin(x)', order: '2' },
        { expr: 'tan(x)', order: '1' }, { expr: 'sqrt(x)', order: '1' },
        { expr: 'x**5 - 3*x**3 + x', order: '1' }, { expr: 'exp(-x**2)', order: '1' },
        { expr: 'asin(x)', order: '1' }, { expr: 'x*exp(x)', order: '1' },
        { expr: 'log(1+x**2)', order: '1' }
    ];
    var randomNumerical = [
        { data: '0,0; 1,2; 2,4; 3,6', order: '1', eval: '1' },
        { data: '0,0; 1,1; 2,4; 3,9; 4,16', order: '1', eval: '2' },
        { data: '0,0; 1,1; 2,8; 3,27; 4,64', order: '1', eval: '2' },
        { data: '0,1; 0.5,1.649; 1,2.718; 1.5,4.482; 2,7.389', order: '1', eval: '1' },
        { data: '0,0; 0.5,0.479; 1,0.841; 1.5,0.997; 2,0.909', order: '2', eval: '1' },
        { data: '-2,4; -1,1; 0,0; 1,1; 2,4', order: '2', eval: '0' },
        { data: '0,1; 1,2.718; 2,7.389; 3,20.086; 4,54.598', order: '1', eval: '2' },
        { data: '0,0; 1,0.841; 2,0.909; 3,0.141; 4,-0.757', order: '1', eval: '1' },
        { data: '1,0; 2,0.693; 3,1.099; 4,1.386; 5,1.609', order: '1', eval: '3' },
        { data: '0,0; 0.25,0.247; 0.5,0.479; 0.75,0.682; 1,0.841', order: '1', eval: '0.5' }
    ];
    var randomWeights = [
        { order: '1', points: '-1,0,1', center: '0' },
        { order: '1', points: '-2,-1,0,1,2', center: '0' },
        { order: '2', points: '-1,0,1', center: '0' },
        { order: '2', points: '-2,-1,0,1,2', center: '0' },
        { order: '1', points: '0,1,2', center: '0' },
        { order: '1', points: '-2,-1,0', center: '0' },
        { order: '3', points: '-2,-1,0,1,2', center: '0' },
        { order: '1', points: '-3,-2,-1,0,1,2,3', center: '0' }
    ];

    // ========== Random Button ==========
    document.getElementById('fd-random-btn').addEventListener('click', function() {
        if (currentMode === 'symbolic') {
            var ex = randomSymbolic[Math.floor(Math.random() * randomSymbolic.length)];
            symbolicInput.value = ex.expr;
            symbolicOrder.value = ex.order;
        } else if (currentMode === 'numerical') {
            var ex = randomNumerical[Math.floor(Math.random() * randomNumerical.length)];
            numericalData.value = ex.data;
            numericalOrder.value = ex.order;
            numericalEvalPt.value = ex.eval;
        } else {
            var ex = randomWeights[Math.floor(Math.random() * randomWeights.length)];
            weightsOrder.value = ex.order;
            weightsPoints.value = ex.points;
            weightsCenter.value = ex.center;
        }
        updatePreview();
    });

    function updateExamples() {
        var container = document.getElementById('fd-examples');
        var html = '';
        if (currentMode === 'symbolic') {
            for (var i = 0; i < symbolicExamples.length; i++) {
                var ex = symbolicExamples[i];
                html += '<button type="button" class="fd-example-chip" data-expr="' + escapeHtml(ex.expr) + '" data-order="' + ex.order + '">' + escapeHtml(ex.label) + '</button>';
            }
        } else if (currentMode === 'numerical') {
            for (var i = 0; i < numericalExamples.length; i++) {
                var ex = numericalExamples[i];
                html += '<button type="button" class="fd-example-chip" data-data="' + escapeHtml(ex.data) + '" data-order="' + ex.order + '" data-eval="' + ex.eval + '">' + escapeHtml(ex.label) + '</button>';
            }
        } else {
            for (var i = 0; i < weightsExamples.length; i++) {
                var ex = weightsExamples[i];
                html += '<button type="button" class="fd-example-chip" data-order="' + ex.order + '" data-points="' + escapeHtml(ex.points) + '" data-center="' + ex.center + '">' + escapeHtml(ex.label) + '</button>';
            }
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('fd-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.fd-example-chip');
        if (!chip) return;
        if (currentMode === 'symbolic') {
            symbolicInput.value = chip.getAttribute('data-expr');
            symbolicOrder.value = chip.getAttribute('data-order') || '1';
        } else if (currentMode === 'numerical') {
            numericalData.value = chip.getAttribute('data-data');
            numericalOrder.value = chip.getAttribute('data-order') || '1';
            numericalEvalPt.value = chip.getAttribute('data-eval') || '';
        } else {
            weightsOrder.value = chip.getAttribute('data-order') || '1';
            weightsPoints.value = chip.getAttribute('data-points');
            weightsCenter.value = chip.getAttribute('data-center') || '0';
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
    bindPreviewInput(symbolicInput);
    bindPreviewInput(symbolicOrder);
    bindPreviewInput(numericalData);
    bindPreviewInput(numericalOrder);
    bindPreviewInput(weightsOrder);
    bindPreviewInput(weightsPoints);

    function updatePreview() {
        try {
            var latex;
            if (currentMode === 'symbolic') {
                var expr = normalizeExpr(symbolicInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type an expression in x above\u2026</span>';
                    return;
                }
                var ord = symbolicOrder.value || '1';
                latex = '\\Delta^{' + ord + '}\\left[' + exprToLatex(expr) + '\\right]';
            } else if (currentMode === 'numerical') {
                var data = numericalData.value.trim();
                if (!data) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter data points above\u2026</span>';
                    return;
                }
                latex = '\\text{apply\\_finite\\_diff on data points}';
            } else {
                var pts = weightsPoints.value.trim();
                if (!pts) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter grid points above\u2026</span>';
                    return;
                }
                var ord = weightsOrder.value || '1';
                latex = '\\text{finite\\_diff\\_weights}(' + ord + ',\\,[' + pts + '])';
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Parse data points ==========
    function parseDataPoints(str) {
        // Accepts: "0,0; 1,1; 2,8" or "(0,0),(1,1),(2,8)"
        var pairs = str.replace(/[()]/g, '').split(';').map(function(s) { return s.trim(); }).filter(Boolean);
        if (pairs.length === 1 && pairs[0].indexOf(',') !== -1) {
            // Try comma-separated pairs with parens: (0,0),(1,1)
            var alt = str.replace(/[()]/g, '').split(/\s*[;]\s*/);
            if (alt.length > 1) pairs = alt;
        }
        var xs = [], ys = [];
        for (var i = 0; i < pairs.length; i++) {
            var parts = pairs[i].split(',').map(function(s) { return s.trim(); });
            if (parts.length >= 2) {
                xs.push(parseFloat(parts[0]));
                ys.push(parseFloat(parts[1]));
            }
        }
        return { x: xs, y: ys };
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = 'from sympy import *\n';
        code += 'from sympy import finite_diff_weights, differentiate_finite\n';
        code += 'import json, numpy as np\n\n';

        if (mode === 'symbolic') {
            var expr = exprToPython(normalizeExpr(symbolicInput.value.trim()));
            var order = parseInt(symbolicOrder.value) || 1;
            var npts = parseInt(symbolicPoints.value) || 0;

            code += 'x, h = symbols("x h")\n';
            code += 'expr = ' + expr + '\n';
            code += 'order = ' + order + '\n\n';

            // Build points list
            if (npts > 0) {
                code += 'n_pts = ' + npts + '\n';
                code += 'pts = [x + i*h for i in range(-n_pts//2, n_pts//2 + 1)]\n';
            } else {
                code += 'pts = [x + i*h for i in range(-order, order + 1)]\n';
            }

            code += 'try:\n';
            code += '    fd = differentiate_finite(diff(expr, x, order), x, points=pts)\n';
            code += '    fd_simplified = simplify(fd)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';

            code += 'exact = diff(expr, x, order)\n';
            code += 'exact_simplified = simplify(exact)\n\n';

            code += 'print("RESULT:" + latex(fd_simplified))\n';
            code += 'print("TEXT:" + str(fd_simplified))\n';
            code += 'print("EXACT:" + latex(exact_simplified))\n\n';

            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given function", "latex": "f(x) = " + latex(expr)})\n';
            code += 'steps.append({"title": "Derivative order", "latex": "n = " + str(order)})\n';
            code += 'steps.append({"title": "Stencil points", "latex": "\\\\text{Points: }" + latex(pts)})\n';
            code += 'steps.append({"title": "Exact derivative", "latex": "f^{(" + str(order) + ")}(x) = " + latex(exact_simplified)})\n';
            code += 'steps.append({"title": "Finite difference approximation", "latex": "\\\\Delta^{" + str(order) + "}[f] = " + latex(fd_simplified)})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{" + latex(fd_simplified) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';

            // Plot data
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    h_val = 0.1\n';
            code += '    x_vals = np.linspace(-5, 5, 200)\n';
            code += '    exact_num = lambdify(x, exact_simplified, "numpy")\n';
            code += '    fd_num = lambdify(x, fd_simplified.subs(h, h_val), "numpy")\n';
            code += '    y_exact = np.array([float(exact_num(xi)) if np.isfinite(exact_num(xi)) else 0.0 for xi in x_vals])\n';
            code += '    y_fd = np.array([float(fd_num(xi)) if np.isfinite(fd_num(xi)) else 0.0 for xi in x_vals])\n';
            code += '    y_exact = np.clip(y_exact, -1e6, 1e6)\n';
            code += '    y_fd = np.clip(y_fd, -1e6, 1e6)\n';
            code += '    print("PLOT_X:" + json.dumps(x_vals.tolist()))\n';
            code += '    print("PLOT_Y1:" + json.dumps(y_exact.tolist()))\n';
            code += '    print("PLOT_Y2:" + json.dumps(y_fd.tolist()))\n';
            code += 'except Exception as e:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y1:[]")\n';
            code += '    print("PLOT_Y2:[]")\n';

        } else if (mode === 'numerical') {
            var parsed = parseDataPoints(numericalData.value.trim());
            var order = parseInt(numericalOrder.value) || 1;
            var evalPt = numericalEvalPt.value.trim() || String(parsed.x[Math.floor(parsed.x.length / 2)] || 0);

            code += 'from sympy import Rational, S\n\n';
            code += 'x_list = ' + JSON.stringify(parsed.x) + '\n';
            code += 'y_list = ' + JSON.stringify(parsed.y) + '\n';
            code += 'x_pts = [S(str(v)) for v in x_list]\n';
            code += 'y_pts = [S(str(v)) for v in y_list]\n';
            code += 'x0 = S("' + evalPt + '")\n';
            code += 'order = ' + order + '\n\n';

            code += 'try:\n';
            code += '    from sympy.calculus.finite_diff import apply_finite_diff\n';
            code += '    result = apply_finite_diff(order, x_pts, y_pts, x0)\n';
            code += '    result_f = float(result)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';

            code += 'print("RESULT:" + str(result_f))\n';
            code += 'print("TEXT:" + str(result_f))\n\n';

            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Data points", "latex": "\\\\{(" + ", ".join([str(x_list[i]) + "," + str(y_list[i]) for i in range(len(x_list))]) + ")\\\\}"})\n';
            code += 'steps.append({"title": "Derivative order", "latex": "n = " + str(order)})\n';
            code += 'steps.append({"title": "Evaluation point", "latex": "x_0 = " + str(x0)})\n';
            code += 'steps.append({"title": "Apply finite difference weights", "latex": "\\\\text{apply\\\\_finite\\\\_diff}(" + str(order) + ", x, y, " + str(x0) + ")"})\n';
            code += 'steps.append({"title": "Result", "latex": r"\\\\boxed{f^{(" + str(order) + ")}(" + str(x0) + ") \\\\approx " + str(round(result_f, 8)) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';

            // Plot
            code += 'print("PLOT_X:" + json.dumps(x_list))\n';
            code += 'print("PLOT_Y:" + json.dumps(y_list))\n';
            code += 'print("EVAL_PT:" + json.dumps({"x": float(x0), "y": result_f}))\n';

        } else {
            // Weights mode
            var order = parseInt(weightsOrder.value) || 1;
            var pts = weightsPoints.value.trim().split(',').map(function(s) { return s.trim(); }).filter(Boolean);
            var center = weightsCenter.value.trim() || '0';

            code += 'from sympy import Rational, S\n\n';
            code += 'order = ' + order + '\n';
            code += 'x_list = [S("' + pts.join('"), S("') + '")]\n';
            code += 'x0 = S("' + center + '")\n\n';

            code += 'try:\n';
            code += '    weights = finite_diff_weights(order, x_list, x0)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';

            // Format output
            code += 'result = []\n';
            code += 'for d in range(order + 1):\n';
            code += '    w = weights[d][-1]\n';
            code += '    w_strs = [str(Rational(wi).limit_denominator(10000)) for wi in w]\n';
            code += '    result.append(w_strs)\n';
            code += '    print("ORDER_" + str(d) + ":" + json.dumps(w_strs))\n\n';

            code += 'print("RESULT:" + json.dumps(result))\n';
            code += 'print("POINTS:" + json.dumps([str(p) for p in x_list]))\n\n';

            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Grid points", "latex": "x = [" + ", ".join([str(p) for p in x_list]) + "]"})\n';
            code += 'steps.append({"title": "Center point", "latex": "x_0 = " + str(x0)})\n';
            code += 'steps.append({"title": "Maximum derivative order", "latex": "d_{max} = " + str(order)})\n';
            code += 'for d in range(order + 1):\n';
            code += '    w = weights[d][-1]\n';
            code += '    w_latex = ", ".join([latex(Rational(wi).limit_denominator(10000)) for wi in w])\n';
            code += '    steps.append({"title": "Weights for order " + str(d), "latex": "[" + w_latex + "]"})\n';
            code += 'steps.append({"title": "Final weights matrix", "latex": r"\\\\boxed{\\\\text{See table above}}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n';

            // Bar chart data (weights for highest order)
            code += 'w_final = [float(Rational(wi).limit_denominator(10000)) for wi in weights[order][-1]]\n';
            code += 'print("BAR_X:" + json.dumps([str(p) for p in x_list]))\n';
            code += 'print("BAR_Y:" + json.dumps(w_final))\n';
        }
        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    symbolicInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });

    function doCompute() {
        var valid = false;
        if (currentMode === 'symbolic') valid = !!symbolicInput.value.trim();
        else if (currentMode === 'numerical') valid = !!numericalData.value.trim();
        else valid = !!weightsPoints.value.trim();

        if (!valid) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please fill in the required fields.', 2000, 'warning');
            return;
        }

        resultActions.classList.remove('visible');
        var modeLabels = { symbolic: 'symbolic differentiation', numerical: 'numerical approximation', weights: 'difference weights' };
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="fd-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing ' + modeLabels[currentMode] + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);
        var mode = currentMode;

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.FD_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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
                showError(stderr || 'Computation failed. Check your input.');
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
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\n|$)/);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch(e) {}

        var rMatch = stdout.match(/RESULT:([^\n]*)/);
        var tMatch = stdout.match(/TEXT:([^\n]*)/);
        var result = rMatch ? rMatch[1].trim() : '';
        var text = tMatch ? tMatch[1].trim() : result;

        if (mode === 'symbolic') {
            var exactMatch = stdout.match(/EXACT:([^\n]*)/);
            var exact = exactMatch ? exactMatch[1].trim() : '';
            showSymbolicResult(result, text, exact, steps);

            // Graph: dual trace
            var plotXMatch = stdout.match(/PLOT_X:(\[[\s\S]*?\])/);
            var plotY1Match = stdout.match(/PLOT_Y1:(\[[\s\S]*?\])/);
            var plotY2Match = stdout.match(/PLOT_Y2:(\[[\s\S]*?\])/);
            var plotX = [], plotY1 = [], plotY2 = [];
            try { if (plotXMatch) plotX = JSON.parse(plotXMatch[1]); } catch(e) {}
            try { if (plotY1Match) plotY1 = JSON.parse(plotY1Match[1]); } catch(e) {}
            try { if (plotY2Match) plotY2 = JSON.parse(plotY2Match[1]); } catch(e) {}

            if (plotX.length > 0) {
                pendingGraph = { type: 'symbolic', x: plotX, y1: plotY1, y2: plotY2 };
                if (graphHint) graphHint.style.display = 'none';
                var graphPanel = document.getElementById('fd-panel-graph');
                if (graphPanel.classList.contains('active')) {
                    loadPlotly(function() { renderGraph(pendingGraph); });
                }
            }
        } else if (mode === 'numerical') {
            showNumericalResult(result, text, steps);

            var plotXMatch = stdout.match(/PLOT_X:(\[[\s\S]*?\])/);
            var plotYMatch = stdout.match(/PLOT_Y:(\[[\s\S]*?\])/);
            var evalPtMatch = stdout.match(/EVAL_PT:(\{[^\n]*\})/);
            var plotX = [], plotY = [], evalPt = null;
            try { if (plotXMatch) plotX = JSON.parse(plotXMatch[1]); } catch(e) {}
            try { if (plotYMatch) plotY = JSON.parse(plotYMatch[1]); } catch(e) {}
            try { if (evalPtMatch) evalPt = JSON.parse(evalPtMatch[1]); } catch(e) {}

            if (plotX.length > 0) {
                pendingGraph = { type: 'numerical', x: plotX, y: plotY, evalPt: evalPt };
                if (graphHint) graphHint.style.display = 'none';
                var graphPanel = document.getElementById('fd-panel-graph');
                if (graphPanel.classList.contains('active')) {
                    loadPlotly(function() { renderGraph(pendingGraph); });
                }
            }
        } else {
            showWeightsResult(result, text, steps, stdout);

            var barXMatch = stdout.match(/BAR_X:(\[[\s\S]*?\])/);
            var barYMatch = stdout.match(/BAR_Y:(\[[\s\S]*?\])/);
            var barX = [], barY = [];
            try { if (barXMatch) barX = JSON.parse(barXMatch[1]); } catch(e) {}
            try { if (barYMatch) barY = JSON.parse(barYMatch[1]); } catch(e) {}

            if (barX.length > 0) {
                pendingGraph = { type: 'weights', x: barX, y: barY };
                if (graphHint) graphHint.style.display = 'none';
                var graphPanel = document.getElementById('fd-panel-graph');
                if (graphPanel.classList.contains('active')) {
                    loadPlotly(function() { renderGraph(pendingGraph); });
                }
            }
        }

        resultActions.classList.add('visible');
    }

    function showSymbolicResult(resultLatex, resultText, exactLatex, steps) {
        lastResultLatex = resultLatex;
        lastResultText = resultText;

        var html = '<div class="fd-result-math">';
        html += '<div class="fd-result-label">Finite Difference Approximation</div>';
        html += '<div class="fd-result-main" id="fd-r-result"></div>';
        if (exactLatex) {
            html += '<div style="margin-top:0.5rem;"><span class="fd-result-label">Exact Derivative</span></div>';
            html += '<div id="fd-r-exact" style="font-size:1.1rem;padding:0.5rem 0;"></div>';
        }
        html += '<div class="fd-result-detail"><span class="fd-method-badge">Symbolic FD (SymPy CAS)</span></div>';
        html += '<button type="button" class="fd-steps-btn" id="fd-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="fd-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        try { katex.render(prepareLatexForKatex(resultLatex), document.getElementById('fd-r-result'), { displayMode: true, throwOnError: false }); } catch(e) { document.getElementById('fd-r-result').textContent = resultText; }
        if (exactLatex) {
            try { katex.render(prepareLatexForKatex(exactLatex), document.getElementById('fd-r-exact'), { displayMode: true, throwOnError: false }); } catch(e) {}
        }

        var stepsBtn = document.getElementById('fd-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    function showNumericalResult(resultText, text, steps) {
        lastResultLatex = resultText;
        lastResultText = text;

        var html = '<div class="fd-result-math">';
        html += '<div class="fd-result-label">Numerical Derivative</div>';
        html += '<div class="fd-result-main" style="font-size:1.5rem;font-family:var(--font-mono);color:var(--tool-primary);">' + escapeHtml(resultText) + '</div>';
        html += '<div class="fd-result-detail"><span class="fd-method-badge">Numerical FD (SymPy)</span></div>';
        html += '<button type="button" class="fd-steps-btn" id="fd-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="fd-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        var stepsBtn = document.getElementById('fd-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    function showWeightsResult(resultJson, text, steps, stdout) {
        lastResultLatex = 'Weights matrix';
        lastResultText = resultJson;

        var weights;
        try { weights = JSON.parse(resultJson); } catch(e) { weights = []; }
        var pointsMatch = stdout.match(/POINTS:(\[[^\n]*\])/);
        var points = [];
        try { if (pointsMatch) points = JSON.parse(pointsMatch[1]); } catch(e) {}

        var html = '<div class="fd-result-math">';
        html += '<div class="fd-result-label">Finite Difference Weights</div>';

        // Build weights table
        if (weights.length > 0 && points.length > 0) {
            html += '<table class="fd-weights-table"><thead><tr><th>Order</th>';
            for (var j = 0; j < points.length; j++) {
                html += '<th>x=' + escapeHtml(points[j]) + '</th>';
            }
            html += '</tr></thead><tbody>';
            for (var d = 0; d < weights.length; d++) {
                html += '<tr><td style="font-weight:600;">d=' + d + '</td>';
                for (var j = 0; j < weights[d].length; j++) {
                    html += '<td>' + escapeHtml(weights[d][j]) + '</td>';
                }
                html += '</tr>';
            }
            html += '</tbody></table>';
        }

        html += '<div class="fd-result-detail"><span class="fd-method-badge">Weights (SymPy)</span></div>';
        html += '<button type="button" class="fd-steps-btn" id="fd-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="fd-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        var stepsBtn = document.getElementById('fd-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('fd-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="fd-steps-container">';
        html += '<div class="fd-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="fd-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="fd-step">';
            html += '<span class="fd-step-num">' + (i + 1) + '</span>';
            html += '<div class="fd-step-body">';
            html += '<div class="fd-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="fd-step-math" id="fd-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('fd-step-math-' + j);
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
        var html = '<div class="fd-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use explicit multiplication: 2*x not 2x</li>';
        html += '<li>Use ^ or ** for powers: x^2 or x**2</li>';
        html += '<li>Symbolic mode: expression must be in terms of x</li>';
        html += '<li>Numerical mode: data as x,y pairs separated by semicolons</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg) return;
        var container = document.getElementById('fd-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var bgColor = isDark ? '#1e293b' : '#fff';
        var gridColor = isDark ? '#334155' : '#e2e8f0';
        var textColor = isDark ? '#cbd5e1' : '#475569';
        var zeroColor = isDark ? '#475569' : '#94a3b8';

        var layout = {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            xaxis: { gridcolor: gridColor, color: textColor, zerolinecolor: zeroColor },
            yaxis: { gridcolor: gridColor, color: textColor, zerolinecolor: zeroColor },
            paper_bgcolor: bgColor,
            plot_bgcolor: bgColor,
            font: { family: 'Inter, sans-serif', size: 12, color: textColor },
            legend: { x: 0.02, y: 0.98 }
        };

        var traces = [];

        if (cfg.type === 'symbolic') {
            layout.xaxis.title = 'x';
            layout.yaxis.title = "f'(x)";
            traces.push({
                x: cfg.x, y: cfg.y1, type: 'scatter', mode: 'lines',
                line: { color: '#6366f1', width: 2.5 }, name: 'Exact derivative'
            });
            traces.push({
                x: cfg.x, y: cfg.y2, type: 'scatter', mode: 'lines',
                line: { color: '#0d9488', width: 2, dash: 'dash' }, name: 'FD approximation'
            });
        } else if (cfg.type === 'numerical') {
            layout.xaxis.title = 'x';
            layout.yaxis.title = 'y';
            traces.push({
                x: cfg.x, y: cfg.y, type: 'scatter', mode: 'markers',
                marker: { color: '#0d9488', size: 10 }, name: 'Data points'
            });
            if (cfg.evalPt) {
                traces.push({
                    x: [cfg.evalPt.x], y: [cfg.evalPt.y], type: 'scatter', mode: 'markers',
                    marker: { color: '#ef4444', size: 14, symbol: 'star' }, name: "f'(x\u2080)"
                });
            }
        } else if (cfg.type === 'weights') {
            layout.xaxis.title = 'Grid point';
            layout.yaxis.title = 'Weight';
            traces.push({
                x: cfg.x, y: cfg.y, type: 'bar',
                marker: { color: cfg.y.map(function(v) { return v >= 0 ? '#0d9488' : '#ef4444'; }) },
                name: 'Weights'
            });
        }

        Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function buildCompilerCode() {
        var code = 'from sympy import *\nfrom sympy import finite_diff_weights, differentiate_finite\n\n';
        if (currentMode === 'symbolic') {
            var expr = exprToPython(normalizeExpr(symbolicInput.value.trim())) || 'x**3';
            var order = symbolicOrder.value || '1';
            code += 'x, h = symbols("x h")\n';
            code += 'expr = ' + expr + '\n';
            code += 'order = ' + order + '\n\n';
            code += '# Finite difference approximation\n';
            code += 'fd = differentiate_finite(diff(expr, x, order), x)\n';
            code += 'fd_simplified = simplify(fd)\n\n';
            code += '# Exact derivative for comparison\n';
            code += 'exact = diff(expr, x, order)\n\n';
            code += 'print(f"f(x) = {expr}")\n';
            code += 'print(f"Exact f^({order})(x) = {simplify(exact)}")\n';
            code += 'print(f"FD approximation = {fd_simplified}")\n';
        } else if (currentMode === 'numerical') {
            var parsed = parseDataPoints(numericalData.value.trim());
            var order = numericalOrder.value || '1';
            var evalPt = numericalEvalPt.value.trim() || '0';
            code += 'from sympy.calculus.finite_diff import apply_finite_diff\n\n';
            code += 'x_list = ' + JSON.stringify(parsed.x) + '\n';
            code += 'y_list = ' + JSON.stringify(parsed.y) + '\n';
            code += 'x0 = ' + evalPt + '\n';
            code += 'order = ' + order + '\n\n';
            code += 'result = apply_finite_diff(order, x_list, y_list, x0)\n';
            code += 'print(f"f^({order})({x0}) ≈ {float(result)}")\n';
        } else {
            var pts = weightsPoints.value.trim() || '-1,0,1';
            var order = weightsOrder.value || '1';
            var center = weightsCenter.value.trim() || '0';
            code += 'order = ' + order + '\n';
            code += 'x_list = [' + pts + ']\n';
            code += 'x0 = ' + center + '\n\n';
            code += 'weights = finite_diff_weights(order, x_list, x0)\n';
            code += 'for d in range(order + 1):\n';
            code += '    w = weights[d][-1]\n';
            code += '    print(f"Order {d}: {[str(Rational(wi).limit_denominator(10000)) for wi in w]}")\n';
        }
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('fd-compiler-iframe');
        iframe.src = (window.FD_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share / PDF ==========
    document.getElementById('fd-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    document.getElementById('fd-download-pdf-btn').addEventListener('click', function() {
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
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#0d9488;';
        title.textContent = 'Finite Difference Calculator \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#0d9488,#14b8a6,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        var modeLabels = { symbolic: 'Symbolic Differentiation', numerical: 'Numerical Approximation', weights: 'Difference Weights' };
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = modeLabels[currentMode];
        container.appendChild(qLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#f0fdfa;border-radius:8px;';
        container.appendChild(aMath);
        try {
            katex.render(prepareLatexForKatex(lastResultLatex), aMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            aMath.textContent = lastResultText;
        }

        var stepsArea = document.getElementById('fd-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.fd-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#0d9488;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.fd-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.fd-step-math');
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
        footer.innerHTML = '<span>Generated by 8gwifi.org Finite Difference Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
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
            pdf.save('finite-difference-' + currentMode + '.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet ==========
    document.getElementById('fd-worksheet-btn').addEventListener('click', function() {
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
        var symProblems = shuffleArray(randomSymbolic).slice(0, 3);
        var numProblems = shuffleArray(randomNumerical).slice(0, 2);
        var wtProblems  = shuffleArray(randomWeights).slice(0, 1);

        var win = window.open('', '_blank');
        if (!win) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please allow pop-ups to print worksheet', 3000, 'warning');
            return;
        }

        var katexCSS = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css';
        var katexJS  = 'https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js';

        var html = '<!DOCTYPE html><html><head><meta charset="utf-8">';
        html += '<title>Finite Difference Worksheet</title>';
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
        html += '.ws-section-number { display: inline-block; width: 28px; height: 28px; background: #0d9488; color: #fff; text-align: center; line-height: 28px; font-size: 14px; font-weight: bold; margin-right: 8px; }';
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
        html += '<button onclick="window.print()" style="padding:10px 28px;font-size:15px;font-weight:600;background:#0d9488;color:#fff;border:none;border-radius:6px;cursor:pointer;">Print Worksheet</button>';
        html += '</div>';

        html += '<div class="ws-header">';
        html += '<div class="ws-title">Finite Difference Worksheet</div>';
        html += '<div class="ws-subtitle">Symbolic, Numerical &amp; Weights</div>';
        html += '</div>';

        html += '<div class="ws-meta">';
        html += '<span>Name: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Date: <span class="ws-meta-field">&nbsp;</span></span>';
        html += '<span>Score: <span class="ws-meta-field">&nbsp; / 6</span></span>';
        html += '</div>';

        var problemNum = 1;

        // Symbolic
        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">I</span>Symbolic Finite Difference Approximation</div>';
        for (var i = 0; i < symProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Find the finite difference approximation of f<sup>(' + symProblems[i].order + ')</sup>(x) for <strong>f(x) = ' + escapeHtml(symProblems[i].expr.replace(/\*\*/g, '^').replace(/\*/g, '\u00B7')) + '</strong>';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        // Numerical
        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">II</span>Numerical Derivative from Data</div>';
        for (var i = 0; i < numProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Given data points <strong>' + escapeHtml(numProblems[i].data) + '</strong>, estimate f<sup>(' + numProblems[i].order + ')</sup>(' + numProblems[i].eval + ')';
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        // Weights
        html += '<div class="ws-section">';
        html += '<div class="ws-section-title"><span class="ws-section-number">III</span>Finite Difference Weights</div>';
        for (var i = 0; i < wtProblems.length; i++) {
            html += '<div class="ws-problem">';
            html += '<span class="ws-problem-num">' + problemNum + '.</span>';
            html += 'Compute the finite difference weights for derivative order <strong>' + wtProblems[i].order + '</strong> using grid points <strong>[' + escapeHtml(wtProblems[i].points) + ']</strong> centered at x\u2080=' + wtProblems[i].center;
            html += '<div class="ws-workspace"></div>';
            html += '<div class="ws-answer-line">Answer: </div>';
            html += '</div>';
            problemNum++;
        }
        html += '</div>';

        html += '<div class="ws-footer">Generated by 8gwifi.org Finite Difference Calculator &mdash; ' + new Date().toLocaleDateString() + '</div>';
        html += '</body></html>';

        win.document.write(html);
        win.document.close();

        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Worksheet opened! Use Print or Save as PDF.', 2500, 'success');
    }

    document.getElementById('fd-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'symbolic') {
            params.f = symbolicInput.value;
            params.o = symbolicOrder.value;
        } else if (currentMode === 'numerical') {
            params.d = numericalData.value;
            params.o = numericalOrder.value;
            params.e = numericalEvalPt.value;
        } else {
            params.p = weightsPoints.value;
            params.o = weightsOrder.value;
            params.c = weightsCenter.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Finite Difference Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'symbolic' || shareMode === 'numerical' || shareMode === 'weights')) {
            var btn = document.querySelector('.fd-mode-btn[data-mode="' + shareMode + '"]');
            if (btn) btn.click();
            if (shareMode === 'symbolic') {
                var f = urlParams.get('f');
                if (f) symbolicInput.value = f;
                var o = urlParams.get('o');
                if (o) symbolicOrder.value = o;
            } else if (shareMode === 'numerical') {
                var d = urlParams.get('d');
                if (d) numericalData.value = d;
                var o = urlParams.get('o');
                if (o) numericalOrder.value = o;
                var ev = urlParams.get('e');
                if (ev) numericalEvalPt.value = ev;
            } else {
                var p = urlParams.get('p');
                if (p) weightsPoints.value = p;
                var o = urlParams.get('o');
                if (o) weightsOrder.value = o;
                var c = urlParams.get('c');
                if (c) weightsCenter.value = c;
            }
            updatePreview();
        }
    } catch(e) {}

})();
