/**
 * Laplace Transform — shared core (SymPy via OneCompiler).
 * Used by laplace-transform-calculator.js and Generic Math AI chat.
 *
 * Browser: window.LaplaceCalculatorCore. Node: module.exports.
 */
'use strict';

var LaplaceCalculatorCore = (function () {

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
        s = s.replace(/^\\?mathcal\{L\}\s*\^?\{-?1\}\s*\{?\s*F\s*\(\s*s\s*\)\s*\}?\s*=\s*/i, '');
        s = s.replace(/^\\?mathcal\{L\}\s*\{?\s*f\s*\(\s*t\s*\)\s*\}?\s*=\s*/i, '');
        s = s.replace(/^F\s*\(\s*s\s*\)\s*=\s*/i, '');
        s = s.replace(/^f\s*\(\s*t\s*\)\s*=\s*/i, '');
        return s;
    }

    function resolveCtx(opts) {
        opts = opts || {};
        return opts.ctx || window.MATH_CALC_CTX || window.LT_CALC_CTX || '';
    }

    /**
     * @param {{ mode?: string, expr?: string, forwardExpr?: string, inverseExpr?: string }} spec
     */
    function buildSympyCode(spec) {
        var mode = spec && String(spec.mode || 'forward').toLowerCase();
        if (mode === 'inverse' || mode === 'inverse-laplace' || mode === 'ilaplace') mode = 'inverse';
        else mode = 'forward';

        var exprRaw = mode === 'inverse'
            ? (spec.inverseExpr || spec.expr || spec.Fs || spec.fs || '')
            : (spec.forwardExpr || spec.expr || spec.ft || spec.f || '');
        var expr = exprToPython(normalizeExpr(exprRaw));

        var code = 'from sympy import symbols, laplace_transform, inverse_laplace_transform, apart, simplify, latex, sin, cos, tan, exp, log, sqrt, pi, sinh, cosh, tanh, Heaviside, DiracDelta, factorial, oo\n';
        code += 'from sympy import Function, Rational\n';
        code += 'import json, numpy as np\n';
        code += 't = symbols("t", positive=True)\n';
        code += 's = symbols("s")\n';
        code += 'a, w, n = symbols("a w n", positive=True)\n\n';

        if (mode === 'forward') {
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
            code += 'print("RESULT:" + latex(F))\n';
            code += 'print("TEXT:" + str(F))\n';
            code += 'print("CONVERGENCE:" + str(a_conv))\n\n';
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given function", "latex": "f(t) = " + latex(f)})\n';
            code += 'steps.append({"title": "Definition of Laplace transform", "latex": r"\\\\mathcal{L}\\\\{f(t)\\\\} = \\\\int_0^{\\\\infty} f(t) \\\\, e^{-st} \\\\, dt"})\n';
            code += 'steps.append({"title": "Identify transform type", "latex": "\\\\text{Apply standard Laplace pair or theorem}"})\n';
            code += 'steps.append({"title": "Apply Laplace transform", "latex": "F(s) = " + latex(F)})\n';
            code += 'if a_conv is not None and str(a_conv) != "True":\n';
            code += '    steps.append({"title": "Region of convergence", "latex": "\\\\text{Re}(s) > " + latex(a_conv)})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{L}\\\\{" + latex(f) + r"\\\\} = " + latex(F) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
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
        } else {
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
            code += 'print("RESULT:" + latex(f))\n';
            code += 'print("TEXT:" + str(f))\n\n';
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given F(s)", "latex": "F(s) = " + latex(F_raw)})\n';
            code += 'if F_pf != F_raw:\n';
            code += '    steps.append({"title": "Partial fraction decomposition", "latex": "F(s) = " + latex(F_pf)})\n';
            code += 'steps.append({"title": "Apply inverse Laplace transform", "latex": r"\\\\mathcal{L}^{-1}\\\\{F(s)\\\\} = " + latex(f)})\n';
            code += 'if "Heaviside" in str(f):\n';
            code += '    steps.append({"title": "Note: Heaviside step function", "latex": r"\\\\theta(t) = 1 \\\\text{ for } t \\\\geq 0, \\\\; 0 \\\\text{ for } t < 0"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\mathcal{L}^{-1}\\\\{" + latex(F_raw) + r"\\\\} = " + latex(f) + r"}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
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
            return Promise.resolve({ ok: false, error: 'Network unavailable for the Laplace engine.' });
        }

        var mode = String(spec && spec.mode || 'forward').toLowerCase();
        if (mode === 'inverse' || mode === 'inverse-laplace' || mode === 'ilaplace') mode = 'inverse';
        else mode = 'forward';

        var expr = mode === 'inverse'
            ? normalizeExpr(spec && (spec.inverseExpr || spec.expr || spec.Fs) || '')
            : normalizeExpr(spec && (spec.forwardExpr || spec.expr || spec.ft) || '');

        if (!expr) {
            return Promise.resolve({
                ok: false,
                error: mode === 'inverse' ? 'Enter F(s) for the inverse Laplace transform.' : 'Enter f(t) for the forward Laplace transform.',
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
        var mode = String(task && (task.laplaceMode || task.transformMode || task.mode) || 'forward').toLowerCase();
        if (/inverse|ilaplace|inv/.test(mode)) mode = 'inverse';
        else mode = 'forward';

        var spec = {
            mode: mode,
            forwardExpr: task ? (task.forwardExpr || task.ft || (mode === 'forward' ? (task.expr || task.raw) : '')) : '',
            inverseExpr: task ? (task.inverseExpr || task.Fs || task.fs || (mode === 'inverse' ? (task.expr || task.raw) : '')) : '',
            expr: task ? (task.expr || task.raw || '') : '',
        };
        return solve(spec, opts);
    }

    function timePlotLayout(isDark) {
        return {
            margin: { t: 28, r: 16, b: 44, l: 56 },
            xaxis: {
                title: 't',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
            },
            yaxis: {
                title: 'f(t)',
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

    function buildPlotTraces(cfg) {
        return [{
            x: cfg.x,
            y: cfg.y,
            type: 'scatter',
            mode: 'lines',
            line: { color: '#0891b2', width: 2.5 },
            name: 'f(t)',
        }];
    }

    return {
        normalizeExpr: normalizeExpr,
        exprToPython: exprToPython,
        buildSympyCode: buildSympyCode,
        parseStdout: parseStdout,
        solve: solve,
        solveTask: solveTask,
        timePlotLayout: timePlotLayout,
        buildPlotTraces: buildPlotTraces,
    };
})();

if (typeof window !== 'undefined') window.LaplaceCalculatorCore = LaplaceCalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = LaplaceCalculatorCore;
