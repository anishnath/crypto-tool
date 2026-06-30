/**
 * Bode Plot — shared core (SymPy + NumPy via OneCompiler).
 * Used by bode-plot-generator.js and Generic Math AI chat.
 *
 * Browser: window.BodeCalculatorCore. Node: module.exports.
 */
'use strict';

var BodeCalculatorCore = (function () {

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
        s = s.replace(/^H\s*\(\s*s\s*\)\s*=\s*/i, '');
        return s;
    }

    function resolveCtx(opts) {
        opts = opts || {};
        return opts.ctx || window.MATH_CALC_CTX || window.BP_CALC_CTX || '';
    }

    /**
     * @param {{ mode?: string, transferFunction?: string, zeros?: string, poles?: string, gain?: string }} spec
     */
    function buildSympyCode(spec) {
        var mode = spec && spec.mode === 'zpk' ? 'zpk' : 'transfer';
        var code = 'from sympy import symbols, fraction, cancel, Poly, solve, latex, simplify, sqrt, pi, exp, log, Rational\n';
        code += 'import numpy as np\nimport json\n\n';
        code += 's = symbols("s")\n\n';

        if (mode === 'transfer') {
            var expr = exprToPython(normalizeExpr(spec.transferFunction || spec.expr || ''));
            code += 'expr = ' + expr + '\n\n';
        } else {
            var zeros = String(spec.zeros || '').trim();
            var poles = String(spec.poles || '').trim();
            var gain = String(spec.gain || '1').trim() || '1';
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
                for (var j = 0; j < parr.length; j++) {
                    code += 'den_expr = den_expr * (s - (' + parr[j].trim() + '))\n';
                }
            }
            code += 'from sympy import expand\n';
            code += 'expr = expand(num_expr) / expand(den_expr)\n\n';
        }

        code += 'num, den = fraction(cancel(expr))\n';
        code += 'num_poly = Poly(num, s)\n';
        code += 'den_poly = Poly(den, s)\n';
        code += 'num_coeffs = [complex(c) for c in num_poly.all_coeffs()]\n';
        code += 'den_coeffs = [complex(c) for c in den_poly.all_coeffs()]\n\n';
        code += 'w = np.logspace(-2, 4, 500)\n';
        code += 'jw = 1j * w\n\n';
        code += 'num_val = np.polyval(num_coeffs, jw)\n';
        code += 'den_val = np.polyval(den_coeffs, jw)\n';
        code += 'H = num_val / den_val\n\n';
        code += 'mag_db = 20 * np.log10(np.abs(H) + 1e-30)\n';
        code += 'phase_deg = np.degrees(np.unwrap(np.angle(H)))\n\n';
        code += 'zeros = solve(num, s)\n';
        code += 'poles = solve(den, s)\n\n';
        code += 'print("RESULT:" + latex(expr))\n';
        code += 'print("TEXT:" + str(expr))\n';
        code += 'print("ZEROS:" + json.dumps([str(z) for z in zeros]))\n';
        code += 'print("POLES:" + json.dumps([str(p) for p in poles]))\n\n';
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
        code += 'print("PLOT_W:" + json.dumps(w.tolist()))\n';
        code += 'print("PLOT_MAG:" + json.dumps(mag_db.tolist()))\n';
        code += 'print("PLOT_PHASE:" + json.dumps(phase_deg.tolist()))\n';
        return code;
    }

    function parseStdout(stdout) {
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\nPLOT|$)/);
        var plotWMatch = stdout.match(/PLOT_W:(\[[\s\S]*?\])/);
        var plotMagMatch = stdout.match(/PLOT_MAG:(\[[\s\S]*?\])/);
        var plotPhaseMatch = stdout.match(/PLOT_PHASE:(\[[\s\S]*?\])/);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch (e) {}
        var plotW = [], plotMag = [], plotPhase = [];
        try { if (plotWMatch) plotW = JSON.parse(plotWMatch[1]); } catch (e) {}
        try { if (plotMagMatch) plotMag = JSON.parse(plotMagMatch[1]); } catch (e) {}
        try { if (plotPhaseMatch) plotPhase = JSON.parse(plotPhaseMatch[1]); } catch (e) {}

        var rMatch = stdout.match(/RESULT:([^\n]*)/);
        var tMatch = stdout.match(/TEXT:([^\n]*)/);
        var zMatch = stdout.match(/ZEROS:(\[[^\n]*\])/);
        var pMatch = stdout.match(/POLES:(\[[^\n]*\])/);

        var resultLatex = rMatch ? rMatch[1].trim() : '0';
        var resultText = tMatch ? tMatch[1].trim() : resultLatex;
        var zeros = [], poles = [];
        try { if (zMatch) zeros = JSON.parse(zMatch[1]); } catch (e) {}
        try { if (pMatch) poles = JSON.parse(pMatch[1]); } catch (e) {}

        return {
            ok: true,
            resultLatex: resultLatex,
            resultText: resultText,
            zeros: zeros,
            poles: poles,
            steps: steps,
            plotW: plotW,
            plotMag: plotMag,
            plotPhase: plotPhase,
        };
    }

    /**
     * @param {{ mode?: string, transferFunction?: string, zeros?: string, poles?: string, gain?: string }} spec
     * @param {object} [opts]
     */
    function solve(spec, opts) {
        opts = opts || {};
        if (typeof fetch === 'undefined') {
            return Promise.resolve({ ok: false, error: 'Network unavailable for the Bode engine.' });
        }

        var mode = spec && spec.mode === 'zpk' ? 'zpk' : 'transfer';
        var tf = normalizeExpr(spec && (spec.transferFunction || spec.expr) || '');
        var hasZpk = spec && (String(spec.poles || '').trim() || String(spec.zeros || '').trim());
        if (mode === 'transfer' && !tf) {
            return Promise.resolve({ ok: false, error: 'Enter a transfer function H(s).' });
        }
        if (mode === 'zpk' && !hasZpk) {
            return Promise.resolve({ ok: false, error: 'Enter at least one pole or zero for ZPK mode.' });
        }

        var code = buildSympyCode(spec);
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
     * @param {{ mode?: string, transferFunction?: string, expr?: string, zeros?: string, poles?: string, gain?: string }} task
     * @param {object} [opts]
     */
    function solveTask(task, opts) {
        var inputMode = String(task && (task.inputMode || task.bodeMode || task.mode) || 'transfer').toLowerCase();
        if (inputMode === 'zpk' || inputMode === 'zeros-poles-gain') inputMode = 'zpk';
        else inputMode = 'transfer';

        var spec = {
            mode: inputMode,
            transferFunction: task ? (task.transferFunction || task.hs || task.expr || '') : '',
            zeros: task ? (task.zeros || '') : '',
            poles: task ? (task.poles || '') : '',
            gain: task ? (task.gain || '1') : '1',
        };
        return solve(spec, opts);
    }

    function bodePlotLayout(isDark) {
        return {
            grid: { rows: 2, columns: 1, pattern: 'independent', roworder: 'top to bottom' },
            margin: { t: 28, r: 16, b: 44, l: 56 },
            xaxis: {
                type: 'log',
                title: '',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
            },
            yaxis: {
                title: 'Magnitude (dB)',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
                domain: [0.55, 1],
            },
            xaxis2: {
                type: 'log',
                title: '\u03C9 (rad/s)',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
            },
            yaxis2: {
                title: 'Phase (\u00B0)',
                gridcolor: isDark ? '#334155' : '#e2e8f0',
                color: isDark ? '#cbd5e1' : '#475569',
                zerolinecolor: isDark ? '#475569' : '#94a3b8',
                domain: [0, 0.42],
            },
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', size: 11, color: isDark ? '#cbd5e1' : '#475569' },
            showlegend: false,
            height: 420,
        };
    }

    function buildPlotTraces(cfg) {
        return [
            {
                x: cfg.w,
                y: cfg.mag,
                type: 'scatter',
                mode: 'lines',
                line: { color: '#dc2626', width: 2.5 },
                name: '|H(j\u03C9)| dB',
                xaxis: 'x',
                yaxis: 'y',
            },
            {
                x: cfg.w,
                y: cfg.phase,
                type: 'scatter',
                mode: 'lines',
                line: { color: '#2563eb', width: 2.5 },
                name: '\u2220H(j\u03C9)\u00B0',
                xaxis: 'x2',
                yaxis: 'y2',
            },
        ];
    }

    return {
        normalizeExpr: normalizeExpr,
        exprToPython: exprToPython,
        buildSympyCode: buildSympyCode,
        parseStdout: parseStdout,
        solve: solve,
        solveTask: solveTask,
        bodePlotLayout: bodePlotLayout,
        buildPlotTraces: buildPlotTraces,
    };
})();

if (typeof window !== 'undefined') window.BodeCalculatorCore = BodeCalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = BodeCalculatorCore;
