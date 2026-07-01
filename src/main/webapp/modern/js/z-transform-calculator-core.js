/**
 * Z-Transform — shared core (SymPy via OneCompiler).
 * Used by z-transform-calculator.js and Generic Math AI chat.
 */
'use strict';

var ZTransformCalculatorCore = (function () {

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
        s = s.replace(/^\\?mathcal\{Z\}\s*\^?\{-?1\}\s*\{?\s*X\s*\(\s*z\s*\)\s*\}?\s*=\s*/i, '');
        s = s.replace(/^\\?mathcal\{Z\}\s*\{?\s*x\s*\[\s*n\s*\]\s*\}?\s*=\s*/i, '');
        s = s.replace(/^X\s*\(\s*z\s*\)\s*=\s*/i, '');
        s = s.replace(/^x\s*\[\s*n\s*\]\s*=\s*/i, '');
        return s;
    }

    function resolveCtx(opts) {
        opts = opts || {};
        return opts.ctx || window.MATH_CALC_CTX || window.ZT_CALC_CTX || '';
    }

    /**
     * @param {{ mode?: string, expr?: string, forwardExpr?: string, inverseExpr?: string }} spec
     */
    function buildSympyCode(spec) {
        var mode = spec && String(spec.mode || 'forward').toLowerCase();
        if (/inverse|iz|inv/.test(mode)) mode = 'inverse';
        else mode = 'forward';

        var exprRaw = mode === 'inverse'
            ? (spec.inverseExpr || spec.expr || spec.Xz || spec.X_z || spec.xz || '')
            : (spec.forwardExpr || spec.expr || spec.xn || spec.x_n || '');
        var expr = exprToPython(normalizeExpr(exprRaw));

        var code = 'from sympy import symbols, Sum, oo, simplify, latex, sin, cos, tan, exp, log, sqrt, pi, Rational, cancel, fraction, solve, Piecewise, I\n';
        code += 'from sympy import Function\n';
        code += 'import json, numpy as np\n';
        code += 'n = symbols("n", integer=True, nonnegative=True)\n';
        code += 'z = symbols("z")\n\n';

        if (mode === 'forward') {
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
            code += 'print("RESULT:" + latex(X))\n';
            code += 'print("TEXT:" + str(X))\n';
            code += 'if roc_cond:\n';
            code += '    print("CONVERGENCE:" + roc_cond)\n\n';
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given sequence", "latex": "x[n] = " + latex(x_n)})\n';
            code += 'steps.append({"title": "Definition of Z-transform", "latex": r"X(z) = \\\\sum_{n=0}^{\\\\infty} x[n] \\\\cdot z^{-n}"})\n';
            code += 'steps.append({"title": "Evaluate the sum", "latex": "\\\\text{Identify geometric series or known pair}"})\n';
            code += 'steps.append({"title": "Simplify", "latex": "X(z) = " + latex(X)})\n';
            code += 'if roc_cond:\n';
            code += '    steps.append({"title": "Region of convergence", "latex": "\\\\text{" + roc_cond + "}"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{Z}\\\\{" + latex(x_n) + r"\\\\} = " + latex(X) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
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
            code += 'print("RESULT:" + latex(x_n_result))\n';
            code += 'print("TEXT:" + str(x_n_result))\n\n';
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

    function parseStdout(stdout) {
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\nPLOT|$)/);
        var plotXMatch = stdout.match(/PLOT_X:(\[[\s\S]*?\])/);
        var plotYMatch = stdout.match(/PLOT_Y:(\[[\s\S]*?\])/);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch (e) {}
        var plotX = [], plotY = [];
        try { if (plotXMatch) plotX = JSON.parse(plotXMatch[1]); } catch (e) {}
        try { if (plotYMatch) plotY = JSON.parse(plotYMatch[1]); } catch (e) {}

        var rMatch = stdout.match(/RESULT:([^\n]*)/);
        var tMatch = stdout.match(/TEXT:([^\n]*)/);
        var cMatch = stdout.match(/CONVERGENCE:([^\n]*)/);

        return {
            ok: true,
            resultLatex: rMatch ? rMatch[1].trim() : '0',
            resultText: tMatch ? tMatch[1].trim() : '',
            convergence: cMatch ? cMatch[1].trim() : null,
            steps: steps,
            plotX: plotX,
            plotY: plotY,
        };
    }

    /**
     * @param {{ mode?: string, expr?: string, forwardExpr?: string, inverseExpr?: string }} spec
     * @param {object} [opts]
     */
    function solve(spec, opts) {
        opts = opts || {};
        if (typeof fetch === 'undefined') {
            return Promise.resolve({ ok: false, error: 'Network unavailable for the Z-transform engine.' });
        }

        var mode = String(spec && spec.mode || 'forward').toLowerCase();
        if (/inverse|iz|inv/.test(mode)) mode = 'inverse';
        else mode = 'forward';

        var expr = mode === 'inverse'
            ? normalizeExpr(spec && (spec.inverseExpr || spec.expr || spec.Xz || spec.X_z) || '')
            : normalizeExpr(spec && (spec.forwardExpr || spec.expr || spec.xn || spec.x_n) || '');

        if (!expr) {
            return Promise.resolve({
                ok: false,
                error: mode === 'inverse'
                    ? 'Enter X(z) for the inverse Z-transform.'
                    : 'Enter x[n] for the forward Z-transform.',
            });
        }

        var code = buildSympyCode(Object.assign({}, spec, { mode: mode }));
        var ctx = resolveCtx(opts);
        var controller = (typeof AbortController !== 'undefined') ? new AbortController() : null;
        var signal = opts.signal || (controller ? controller.signal : undefined);
        var timeoutId = controller ? setTimeout(function () { controller.abort(); }, opts.timeoutMs || 90000) : null;

        return fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: signal,
        })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (timeoutId) clearTimeout(timeoutId);
                var stdout = (data.Stdout || data.stdout || '').trim();
                var stderr = (data.Stderr || data.stderr || '').trim();
                if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                    return { ok: false, error: stderr || 'Computation failed. Check expression syntax.' };
                }
                var errMatch = stdout.match(/ERROR:(.+)/);
                if (errMatch) return { ok: false, error: errMatch[1].trim() };
                var parsed = parseStdout(stdout);
                parsed.mode = mode;
                return parsed;
            })
            .catch(function (err) {
                if (timeoutId) clearTimeout(timeoutId);
                return {
                    ok: false,
                    error: (err && err.name === 'AbortError') ? 'Request timed out' : (err && err.message ? err.message : String(err)),
                };
            });
    }

    /**
     * @param {object} task
     * @param {object} [opts]
     */
    function solveTask(task, opts) {
        var mode = String(task && (task.zTransformMode || task.transformMode || task.mode) || 'forward').toLowerCase();
        if (/inverse|iz|inv/.test(mode)) mode = 'inverse';
        else mode = 'forward';

        var spec = {
            mode: mode,
            forwardExpr: task ? (task.forwardExpr || task.xn || task.x_n || (mode === 'forward' ? (task.expr || task.raw) : '')) : '',
            inverseExpr: task ? (task.inverseExpr || task.Xz || task.X_z || task.xz || (mode === 'inverse' ? (task.expr || task.raw) : '')) : '',
            expr: task ? (task.expr || task.raw || '') : '',
        };
        return solve(spec, opts);
    }

    function stemPlotLayout(isDark) {
        return {
            margin: { t: 28, r: 16, b: 44, l: 56 },
            xaxis: {
                title: 'n',
                dtick: 1,
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
            },
            yaxis: {
                title: 'x[n]',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
            },
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', size: 11, color: isDark ? '#cbd5e1' : '#475569' },
            showlegend: false,
            height: 320,
        };
    }

    function buildStemPlot(cfg) {
        var shapes = [];
        var x = cfg.x || [];
        var y = cfg.y || [];
        for (var i = 0; i < x.length; i++) {
            shapes.push({
                type: 'line',
                x0: x[i], x1: x[i],
                y0: 0, y1: y[i],
                line: { color: '#059669', width: 2 },
            });
        }
        return {
            traces: [{
                x: x,
                y: y,
                type: 'scatter',
                mode: 'markers',
                marker: { color: '#059669', size: 8, line: { color: '#047857', width: 1.5 } },
                name: 'x[n]',
            }],
            layoutExtras: { shapes: shapes },
        };
    }

    return {
        normalizeExpr: normalizeExpr,
        exprToPython: exprToPython,
        buildSympyCode: buildSympyCode,
        parseStdout: parseStdout,
        solve: solve,
        solveTask: solveTask,
        stemPlotLayout: stemPlotLayout,
        buildStemPlot: buildStemPlot,
    };
})();

if (typeof window !== 'undefined') window.ZTransformCalculatorCore = ZTransformCalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = ZTransformCalculatorCore;
