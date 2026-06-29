/**
 * Vector Calculus Calculator Core — shared SymPy backbone for page + Math AI chat.
 * Gradient, divergence, curl (same OneCompiler/SymPy engine as the VC page).
 */
var VCCalculatorCore = (function () {
    'use strict';

    var VC_MODES = { gradient: 1, divergence: 1, curl: 1 };

    function stripLatex(s) {
        if (!s) return s;
        s = String(s).trim();
        s = s.replace(/^\$+\s*|\s*\$+$/g, '');
        s = s.replace(/\\cdot\s*/g, '*').replace(/\\times\s*/g, '*').replace(/\\ast\s*/g, '*');
        s = s.replace(/\\left/g, '').replace(/\\right/g, '');
        var prev;
        do {
            prev = s;
            s = s.replace(/\\frac\s*\{([^{}]*)\}\s*\{([^{}]*)\}/g, '(($1)/($2))');
        } while (s !== prev);
        s = s.replace(/\\sqrt\s*\{([^{}]*)\}/g, 'sqrt($1)');
        s = s.replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|exp|sqrt|abs)\b/g, '$1');
        s = s.replace(/\\pi\b/g, 'pi');
        s = s.replace(/[{}]/g, '');
        return s;
    }

    function normalizeExpr(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        var s = stripLatex(expr.trim());
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
        var LA = '(?=[+\\-*/^)\\s,]|$|(?:' + FUNS + '))';
        s = s.replace(new RegExp('(' + FUNS + ')\\s*(\\d+)\\s*([a-zA-Z])' + LA, 'g'), '$1($2*$3)');
        s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])' + LA, 'g'), '$1($2)');
        s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
        s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
        s = s.replace(new RegExp('([b-zB-Z])(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(new RegExp('(\\d)(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        s = s.replace(/\bln\(/g, 'log(');
        s = s.replace(/\*\s+(?=[a-zA-Z(0-9])/g, '*');
        s = s.replace(/\s+/g, ' ');
        return s.trim();
    }

    function exprToPython(expr) {
        var py = normalizeExpr(expr || '');
        if (!py) return '0';
        py = py
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1');
        py = py.replace(/\bln\(/g, 'log(');
        return py;
    }

    function normalizeMode(mode) {
        var m = String(mode || 'gradient').toLowerCase();
        if (m === 'grad' || m === 'nabla') m = 'gradient';
        if (m === 'div') m = 'divergence';
        return VC_MODES[m] ? m : 'gradient';
    }

    function taskToSpec(task) {
        var mode = normalizeMode(task && task.mode);
        return {
            mode: mode,
            scalar: (task && (task.scalar || task.f || (mode === 'gradient' ? task.expr : ''))) || '',
            fx: (task && (task.fx || task.Fx)) || '',
            fy: (task && (task.fy || task.Fy)) || '',
            fz: (task && (task.fz || task.Fz)) || '',
        };
    }

    function appendVectorFieldPlot(code, vx, vy, vz) {
        code += 'try:\n';
        code += '    from sympy import lambdify\n';
        code += '    _ux = lambdify((x,y,z), ' + vx + ', "numpy")\n';
        code += '    _uy = lambdify((x,y,z), ' + vy + ', "numpy")\n';
        code += '    _uz = lambdify((x,y,z), ' + vz + ', "numpy")\n';
        code += '    pts = np.linspace(-2, 2, 6)\n';
        code += '    data = []\n';
        code += '    for xi in pts:\n';
        code += '        for yi in pts:\n';
        code += '            for zi in pts:\n';
        code += '                try:\n';
        code += '                    u = float(_ux(xi, yi, zi))\n';
        code += '                    v = float(_uy(xi, yi, zi))\n';
        code += '                    w = float(_uz(xi, yi, zi))\n';
        code += '                    if all(abs(c) < 1e6 for c in [u,v,w]):\n';
        code += '                        data.append([float(xi),float(yi),float(zi),u,v,w])\n';
        code += '                except: pass\n';
        code += '    print("PLOT:" + json.dumps(data))\n';
        code += 'except:\n';
        code += '    print("PLOT:[]")\n';
        return code;
    }

    function buildCode(spec) {
        var mode = normalizeMode(spec.mode);
        var code = 'from sympy import symbols, diff, latex, simplify, sin, cos, tan, exp, log, sqrt, pi, sec, csc, cot, sinh, cosh, tanh, asin, acos, atan, Abs\n';
        code += 'import json, numpy as np\n';
        code += 'x, y, z = symbols("x y z")\n\n';

        if (mode === 'gradient') {
            var expr = exprToPython(spec.scalar);
            code += 'f = ' + expr + '\n';
            code += 'gx = simplify(diff(f, x))\n';
            code += 'gy = simplify(diff(f, y))\n';
            code += 'gz = simplify(diff(f, z))\n\n';
            code += 'print("RESULT_X:" + latex(gx))\n';
            code += 'print("RESULT_Y:" + latex(gy))\n';
            code += 'print("RESULT_Z:" + latex(gz))\n';
            code += 'print("TEXT_X:" + str(gx))\n';
            code += 'print("TEXT_Y:" + str(gy))\n';
            code += 'print("TEXT_Z:" + str(gz))\n';
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given scalar field", "latex": "f(x,y,z) = " + latex(f)})\n';
            code += 'steps.append({"title": "Definition of gradient", "latex": r"\\\\nabla f = \\\\frac{\\\\partial f}{\\\\partial x}\\\\hat{\\\\mathbf{i}} + \\\\frac{\\\\partial f}{\\\\partial y}\\\\hat{\\\\mathbf{j}} + \\\\frac{\\\\partial f}{\\\\partial z}\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Compute partial derivative w.r.t. x", "latex": r"\\\\frac{\\\\partial f}{\\\\partial x} = " + latex(diff(f,x)) + (" = " + latex(gx) if gx != diff(f,x) else "")})\n';
            code += 'steps.append({"title": "Compute partial derivative w.r.t. y", "latex": r"\\\\frac{\\\\partial f}{\\\\partial y} = " + latex(diff(f,y)) + (" = " + latex(gy) if gy != diff(f,y) else "")})\n';
            code += 'steps.append({"title": "Compute partial derivative w.r.t. z", "latex": r"\\\\frac{\\\\partial f}{\\\\partial z} = " + latex(diff(f,z)) + (" = " + latex(gz) if gz != diff(f,z) else "")})\n';
            code += 'steps.append({"title": "Simplify each component", "latex": r"\\\\nabla f = \\\\left(" + latex(gx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(gy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(gz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\nabla f = \\\\left(" + latex(gx) + ", " + latex(gy) + ", " + latex(gz) + r"\\\\right)}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            code = appendVectorFieldPlot(code, 'gx', 'gy', 'gz');
        } else if (mode === 'divergence') {
            var fx = exprToPython(spec.fx) || '0';
            var fy = exprToPython(spec.fy) || '0';
            var fz = exprToPython(spec.fz) || '0';
            code += 'Fx = ' + fx + '\n';
            code += 'Fy = ' + fy + '\n';
            code += 'Fz = ' + fz + '\n\n';
            code += 'dFx_dx = diff(Fx, x)\n';
            code += 'dFy_dy = diff(Fy, y)\n';
            code += 'dFz_dz = diff(Fz, z)\n';
            code += 'div = simplify(dFx_dx + dFy_dy + dFz_dz)\n\n';
            code += 'print("RESULT:" + latex(div))\n';
            code += 'print("TEXT:" + str(div))\n';
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given vector field", "latex": r"\\\\mathbf{F} = \\\\left(" + latex(Fx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(Fy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(Fz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Definition of divergence", "latex": r"\\\\nabla \\\\cdot \\\\mathbf{F} = \\\\frac{\\\\partial F_x}{\\\\partial x} + \\\\frac{\\\\partial F_y}{\\\\partial y} + \\\\frac{\\\\partial F_z}{\\\\partial z}"})\n';
            code += 'steps.append({"title": "Compute each partial derivative", "latex": r"\\\\frac{\\\\partial F_x}{\\\\partial x} = " + latex(dFx_dx) + r", \\\\quad \\\\frac{\\\\partial F_y}{\\\\partial y} = " + latex(dFy_dy) + r", \\\\quad \\\\frac{\\\\partial F_z}{\\\\partial z} = " + latex(dFz_dz)})\n';
            code += 'steps.append({"title": "Sum the partial derivatives", "latex": r"\\\\nabla \\\\cdot \\\\mathbf{F} = " + latex(dFx_dx) + " + " + latex(dFy_dy) + " + " + latex(dFz_dz) + " = " + latex(div)})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n';
            code += 'print("PLOT:[]")\n';
        } else {
            var fx2 = exprToPython(spec.fx) || '0';
            var fy2 = exprToPython(spec.fy) || '0';
            var fz2 = exprToPython(spec.fz) || '0';
            code += 'Fx = ' + fx2 + '\n';
            code += 'Fy = ' + fy2 + '\n';
            code += 'Fz = ' + fz2 + '\n\n';
            code += 'cx = simplify(diff(Fz, y) - diff(Fy, z))\n';
            code += 'cy = simplify(diff(Fx, z) - diff(Fz, x))\n';
            code += 'cz = simplify(diff(Fy, x) - diff(Fx, y))\n\n';
            code += 'print("RESULT_X:" + latex(cx))\n';
            code += 'print("RESULT_Y:" + latex(cy))\n';
            code += 'print("RESULT_Z:" + latex(cz))\n';
            code += 'print("TEXT_X:" + str(cx))\n';
            code += 'print("TEXT_Y:" + str(cy))\n';
            code += 'print("TEXT_Z:" + str(cz))\n';
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given vector field", "latex": r"\\\\mathbf{F} = \\\\left(" + latex(Fx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(Fy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(Fz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Curl as determinant", "latex": r"\\\\nabla \\\\times \\\\mathbf{F} = \\\\begin{vmatrix} \\\\hat{\\\\mathbf{i}} & \\\\hat{\\\\mathbf{j}} & \\\\hat{\\\\mathbf{k}} \\\\\\\\ \\\\frac{\\\\partial}{\\\\partial x} & \\\\frac{\\\\partial}{\\\\partial y} & \\\\frac{\\\\partial}{\\\\partial z} \\\\\\\\ " + latex(Fx) + " & " + latex(Fy) + " & " + latex(Fz) + r" \\\\end{vmatrix}"})\n';
            code += 'steps.append({"title": "i-component", "latex": r"\\\\hat{\\\\mathbf{i}}: \\\\frac{\\\\partial}{\\\\partial y}\\\\left(" + latex(Fz) + r"\\\\right) - \\\\frac{\\\\partial}{\\\\partial z}\\\\left(" + latex(Fy) + r"\\\\right) = " + latex(diff(Fz,y)) + " - " + latex(diff(Fy,z)) + " = " + latex(cx)})\n';
            code += 'steps.append({"title": "j-component", "latex": r"\\\\hat{\\\\mathbf{j}}: \\\\frac{\\\\partial}{\\\\partial z}\\\\left(" + latex(Fx) + r"\\\\right) - \\\\frac{\\\\partial}{\\\\partial x}\\\\left(" + latex(Fz) + r"\\\\right) = " + latex(diff(Fx,z)) + " - " + latex(diff(Fz,x)) + " = " + latex(cy)})\n';
            code += 'steps.append({"title": "k-component", "latex": r"\\\\hat{\\\\mathbf{k}}: \\\\frac{\\\\partial}{\\\\partial x}\\\\left(" + latex(Fy) + r"\\\\right) - \\\\frac{\\\\partial}{\\\\partial y}\\\\left(" + latex(Fx) + r"\\\\right) = " + latex(diff(Fy,x)) + " - " + latex(diff(Fx,y)) + " = " + latex(cz)})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\nabla \\\\times \\\\mathbf{F} = \\\\left(" + latex(cx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(cy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(cz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            code = appendVectorFieldPlot(code, 'cx', 'cy', 'cz');
        }
        return code;
    }

    function line(stdout, key) {
        var m = stdout.match(new RegExp(key + ':([^\n]*)'));
        return m ? m[1].trim() : '';
    }

    function parseSteps(stdout) {
        var steps = [];
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\nPLOT|\nRESULT|$)/);
        try {
            if (stepsMatch) steps = JSON.parse(stepsMatch[1]);
        } catch (e) { /* ignore */ }
        return steps;
    }

    function prepareLatex(latex) {
        if (!latex || typeof latex !== 'string') return latex;
        return latex.replace(/\\\\/g, '\\');
    }

    function parsePlotData(stdout) {
        var plotMatch = stdout.match(/PLOT:(\[[\s\S]*?\])$/m);
        var plotData = [];
        try {
            if (plotMatch) plotData = JSON.parse(plotMatch[1]);
        } catch (e) { /* ignore */ }
        return plotData;
    }

    function parseResult(mode, stdout) {
        mode = normalizeMode(mode);
        var steps = parseSteps(stdout);
        var plotData = parsePlotData(stdout);

        if (mode === 'divergence') {
            var result = line(stdout, 'RESULT');
            var text = line(stdout, 'TEXT') || result;
            if (!result && !text) {
                return { ok: false, error: 'Computation failed.', mode: mode };
            }
            return {
                ok: true,
                mode: mode,
                resultLatex: '\\nabla \\cdot \\mathbf{F} = ' + prepareLatex(result),
                text: text,
                steps: steps,
                plotData: plotData,
                method: 'Symbolic vector calculus solver',
            };
        }

        var rx = line(stdout, 'RESULT_X');
        var ry = line(stdout, 'RESULT_Y');
        var rz = line(stdout, 'RESULT_Z');
        if (!rx && !ry && !rz) {
            return { ok: false, error: 'Computation failed.', mode: mode };
        }
        var symbol = mode === 'gradient' ? '\\nabla f' : '\\nabla \\times \\mathbf{F}';
        var resultLatex = symbol + ' = \\left(' + prepareLatex(rx) + '\\right)\\hat{\\mathbf{i}} + \\left(' + prepareLatex(ry) + '\\right)\\hat{\\mathbf{j}} + \\left(' + prepareLatex(rz) + '\\right)\\hat{\\mathbf{k}}';
        return {
            ok: true,
            mode: mode,
            resultLatex: resultLatex,
            rx: prepareLatex(rx),
            ry: prepareLatex(ry),
            rz: prepareLatex(rz),
            steps: steps,
            plotData: plotData,
            method: 'Symbolic vector calculus solver',
        };
    }

    function resolveCtx(opts) {
        if (opts && opts.ctx) return opts.ctx;
        if (typeof window !== 'undefined' && window.VC_CALC_CTX) return window.VC_CALC_CTX;
        if (typeof window !== 'undefined' && window.__CTX__) return window.__CTX__;
        var meta = typeof document !== 'undefined' && document.querySelector('meta[name="ctx"]');
        return meta ? meta.getAttribute('content') || '' : '';
    }

    function validateSpec(spec) {
        var mode = normalizeMode(spec.mode);
        if (mode === 'gradient') {
            if (!String(spec.scalar || '').trim()) {
                return 'Enter a scalar field f(x,y,z).';
            }
        } else if (!String(spec.fx || '').trim() && !String(spec.fy || '').trim() && !String(spec.fz || '').trim()) {
            return 'Enter at least one vector component (Fx, Fy, Fz).';
        }
        return null;
    }

    function solve(spec, opts) {
        opts = opts || {};
        spec = spec || {};
        var err = validateSpec(spec);
        if (err) {
            return Promise.resolve({ ok: false, error: err, mode: normalizeMode(spec.mode) });
        }
        if (typeof fetch === 'undefined') {
            return Promise.resolve({ ok: false, error: 'Network unavailable for the vector calculus engine.', mode: spec.mode });
        }
        var code = buildCode(spec);
        var ctx = resolveCtx(opts);
        var controller = (typeof AbortController !== 'undefined') ? new AbortController() : null;
        var signal = opts.signal || (controller ? controller.signal : undefined);
        var timeoutMs = opts.timeoutMs != null ? opts.timeoutMs : 90000;
        var timeoutId = controller ? setTimeout(function () { controller.abort(); }, timeoutMs) : null;

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
                    return { ok: false, error: stderr || 'Computation failed.', mode: spec.mode };
                }
                return parseResult(spec.mode, stdout);
            })
            .catch(function (err) {
                if (timeoutId) clearTimeout(timeoutId);
                return {
                    ok: false,
                    error: err.name === 'AbortError' ? 'Request timed out (' + (timeoutMs / 1000) + 's)' : err.message,
                    mode: spec.mode,
                };
            });
    }

    function maxVectorLength(us, vs, ws) {
        var maxLen = 0;
        for (var i = 0; i < us.length; i++) {
            var u = Number(us[i]) || 0;
            var v = Number(vs[i]) || 0;
            var w = Number(ws[i]) || 0;
            var len = Math.sqrt(u * u + v * v + w * w);
            if (len > maxLen) maxLen = len;
        }
        return maxLen;
    }

    /**
     * Plotly cone trace tuned for [-2,2] sample grid — scaled mode so large gradients
     * (polynomials) and small ones (trig) both render inside the scene.
     */
    function buildPlotlyConeTrace(xs, ys, zs, us, vs, ws, opts) {
        opts = opts || {};
        var isDark = !!opts.isDark;
        var fontSize = opts.colorbarFontSize || 12;
        var maxLen = maxVectorLength(us, vs, ws);
        return {
            type: 'cone',
            x: xs,
            y: ys,
            z: zs,
            u: us,
            v: vs,
            w: ws,
            colorscale: 'Portland',
            sizemode: 'scaled',
            sizeref: maxLen > 0 ? 0.45 : 1,
            anchor: 'tail',
            showscale: true,
            colorbar: {
                title: 'Magnitude',
                tickfont: { color: isDark ? '#cbd5e1' : '#475569', size: fontSize },
                titlefont: { color: isDark ? '#cbd5e1' : '#475569', size: fontSize },
            },
        };
    }

    function solveTask(task, opts) {
        return solve(taskToSpec(task), opts);
    }

    return {
        normalizeExpr: normalizeExpr,
        exprToPython: exprToPython,
        buildCode: buildCode,
        parseResult: parseResult,
        taskToSpec: taskToSpec,
        solve: solve,
        solveTask: solveTask,
        buildPlotlyConeTrace: buildPlotlyConeTrace,
    };
})();

if (typeof window !== 'undefined') window.VCCalculatorCore = VCCalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = VCCalculatorCore;
