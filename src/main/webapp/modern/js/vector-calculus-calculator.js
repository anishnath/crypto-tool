/**
 * Vector Calculus Calculator - DOM/UI logic
 * Computes gradient, divergence, and curl via SymPy on OneCompiler.
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.VC_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var scalarInput   = document.getElementById('vc-scalar-expr');
    var fxInput       = document.getElementById('vc-fx');
    var fyInput       = document.getElementById('vc-fy');
    var fzInput       = document.getElementById('vc-fz');
    var previewEl     = document.getElementById('vc-preview');
    var computeBtn    = document.getElementById('vc-compute-btn');
    var resultContent = document.getElementById('vc-result-content');
    var resultActions = document.getElementById('vc-result-actions');
    var emptyState    = document.getElementById('vc-empty-state');
    var graphHint     = document.getElementById('vc-graph-hint');
    var scalarWrap    = document.getElementById('vc-scalar-wrap');
    var vectorWrap    = document.getElementById('vc-vector-wrap');

    var currentMode = 'gradient';
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

    /** Convert user input to Python/SymPy syntax */
    function exprToPython(expr) {
        var py = (expr || '').trim()
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1')
            .replace(/([a-zA-Z])\(/g, function(m, c) {
                var fns = ['sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','exp','log','ln','sqrt','asin','acos','atan','abs'];
                // Check if the char is the end of a known function
                return m; // keep as-is, functions already have parens
            });
        // ln → log for SymPy
        py = py.replace(/\bln\(/g, 'log(');
        return py;
    }

    /** Normalize Unicode in user input */
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
        var LA = '(?=[+\\-*/^)\\s,]|$|(?:' + FUNS + '))';
        s = s.replace(new RegExp('(' + FUNS + ')\\s*(\\d+)\\s*([a-zA-Z])' + LA, 'g'), '$1($2*$3)');
        s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])' + LA, 'g'), '$1($2)');
        s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
        s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
        s = s.replace(new RegExp('([b-zB-Z])(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(new RegExp('(\\d)(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        s = s.replace(/\bln\(/g, 'log(');
        return s;
    }

    /** Convert expression to basic LaTeX for KaTeX preview (no nerdamer) */
    function exprToLatex(expr) {
        if (!expr) return '';
        return expr
            .replace(/\*\*/g, '^')
            .replace(/\*/g, ' \\cdot ')
            .replace(/sqrt\(([^)]+)\)/g, '\\sqrt{$1}')
            .replace(/sin\(/g, '\\sin(')
            .replace(/cos\(/g, '\\cos(')
            .replace(/tan\(/g, '\\tan(')
            .replace(/sec\(/g, '\\sec(')
            .replace(/csc\(/g, '\\csc(')
            .replace(/cot\(/g, '\\cot(')
            .replace(/sinh\(/g, '\\sinh(')
            .replace(/cosh\(/g, '\\cosh(')
            .replace(/tanh\(/g, '\\tanh(')
            .replace(/log\(/g, '\\ln(')
            .replace(/exp\(([^)]+)\)/g, 'e^{$1}')
            .replace(/\^([a-zA-Z0-9]+)/g, '^{$1}')
            .replace(/\^(\([^)]+\))/g, '^{$1}');
    }

    /** Prepare LaTeX from SymPy for KaTeX: normalize double-backslashes */
    function prepareLatexForKatex(latex) {
        if (!latex || typeof latex !== 'string') return latex;
        latex = latex.replace(/\\\\/g, '\\');
        var hasLatex = /\\|[\^_]|\{[^}]*\}/.test(latex);
        if (!hasLatex) {
            return '\\text{' + latex.replace(/\\/g, '\\\\').replace(/}/g, '\\}') + '}';
        }
        latex = latex.replace(/((?:[A-Za-z]{2,} ){2,}[A-Za-z]{2,})/g, '\\text{$1}');
        latex = latex.replace(/^([A-Z][a-z]+)\\ /g, '\\text{$1} ');
        return latex;
    }

    // ========== FAQ ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Mode Toggle ==========
    var modeBtns = document.querySelectorAll('.vc-mode-btn');
    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            if (mode === 'gradient') {
                scalarWrap.style.display = '';
                vectorWrap.style.display = 'none';
            } else {
                scalarWrap.style.display = 'none';
                vectorWrap.style.display = '';
            }
            updatePreview();
            updateExamples();
        });
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.vc-output-tab');
    var panels  = document.querySelectorAll('.vc-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('vc-panel-' + panel).classList.add('active');

            if (panel === 'graph' && pendingGraph) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Syntax Help Toggle ==========
    var syntaxBtn = document.getElementById('vc-syntax-btn');
    var syntaxContent = document.getElementById('vc-syntax-content');
    syntaxBtn.addEventListener('click', function() {
        syntaxContent.classList.toggle('open');
        var chevron = syntaxBtn.querySelector('.vc-syntax-chevron');
        if (syntaxContent.classList.contains('open')) {
            chevron.style.transform = 'rotate(180deg)';
        } else {
            chevron.style.transform = '';
        }
    });

    // ========== Quick Examples ==========
    var gradientExamples = [
        { label: 'x\u00B2+y\u00B2+z\u00B2', scalar: 'x^2 + y^2 + z^2' },
        { label: 'x\u00B7y\u00B7z', scalar: 'x*y*z' },
        { label: 'sin(x)\u00B7cos(y)\u00B7e^z', scalar: 'sin(x)*cos(y)*e^z' },
        { label: 'x\u00B2y+y\u00B2z+z\u00B2x', scalar: 'x^2*y + y^2*z + z^2*x' }
    ];
    var divergenceExamples = [
        { label: '(x, y, z) = 3', fx: 'x', fy: 'y', fz: 'z' },
        { label: '(x\u00B2, y\u00B2, z\u00B2)', fx: 'x^2', fy: 'y^2', fz: 'z^2' },
        { label: '(xy, yz, zx)', fx: 'x*y', fy: 'y*z', fz: 'z*x' }
    ];
    var curlExamples = [
        { label: '(-y, x, 0) rotation', fx: '-y', fy: 'x', fz: '0' },
        { label: '(yz, xz, xy) curl=0', fx: 'y*z', fy: 'x*z', fz: 'x*y' },
        { label: '(x\u00B2y, yz, xz\u00B2)', fx: 'x^2*y', fy: 'y*z', fz: 'x*z^2' }
    ];

    // Extended pool for Random button
    var randomGradient = [
        { scalar: 'x^2 + y^2 + z^2' },
        { scalar: 'x*y*z' },
        { scalar: 'sin(x)*cos(y)*e^z' },
        { scalar: 'x^2*y + y^2*z + z^2*x' },
        { scalar: 'x^3 + y^3 + z^3' },
        { scalar: 'x^10 + y^10' },
        { scalar: 'log(x^2 + y^2 + z^2)' },
        { scalar: 'sqrt(x^2 + y^2 + z^2)' },
        { scalar: 'e^(x+y+z)' },
        { scalar: 'x^2*y^2*z^2' },
        { scalar: 'sin(x*y) + cos(y*z)' },
        { scalar: 'x/(x^2 + y^2 + z^2)' },
        { scalar: 'x^4*y^3*z^2' },
        { scalar: 'e^(-x^2 - y^2 - z^2)' },
        { scalar: 'atan(y/x)' },
        { scalar: 'x*sin(y) + y*cos(z) + z*e^x' },
        { scalar: 'x^2*y^3 + z^5' },
        { scalar: 'cos(x)*sin(y)*sinh(z)' }
    ];
    var randomDivergence = [
        { fx: 'x', fy: 'y', fz: 'z' },
        { fx: 'x^2', fy: 'y^2', fz: 'z^2' },
        { fx: 'x*y', fy: 'y*z', fz: 'z*x' },
        { fx: 'sin(x)', fy: 'cos(y)', fz: 'e^z' },
        { fx: 'x^2*y', fy: 'y^2*z', fz: 'z^2*x' },
        { fx: 'x^3', fy: 'y^3', fz: 'z^3' },
        { fx: 'e^x', fy: 'e^y', fz: 'e^z' },
        { fx: 'x*y*z', fy: 'x*y*z', fz: 'x*y*z' },
        { fx: 'cos(y*z)', fy: 'sin(x*z)', fz: 'x*y' },
        { fx: 'x/(x^2+y^2)', fy: 'y/(x^2+y^2)', fz: '0' },
        { fx: 'y^2*z', fy: 'x*z^2', fz: 'x^2*y' },
        { fx: 'x^10', fy: 'y^10', fz: 'z^10' }
    ];
    var randomCurl = [
        { fx: '-y', fy: 'x', fz: '0' },
        { fx: 'y*z', fy: 'x*z', fz: 'x*y' },
        { fx: 'x^2*y', fy: 'y*z', fz: 'x*z^2' },
        { fx: '-y^2', fy: 'x^2', fz: 'z' },
        { fx: 'z*sin(x)', fy: 'x*cos(y)', fz: 'y*e^z' },
        { fx: 'x*y^2', fy: '-x^2*y', fz: 'z^3' },
        { fx: 'e^y', fy: 'e^z', fz: 'e^x' },
        { fx: 'y^3', fy: 'z^3', fz: 'x^3' },
        { fx: 'sin(y)', fy: 'sin(z)', fz: 'sin(x)' },
        { fx: 'x^2 + y*z', fy: 'y^2 + x*z', fz: 'z^2 + x*y' },
        { fx: 'cos(y)*z', fy: 'sin(x)*z', fz: 'x*y' },
        { fx: 'y*z^2', fy: 'x^2*z', fz: 'x*y^2' }
    ];

    // ========== Random Button ==========
    document.getElementById('vc-random-btn').addEventListener('click', function() {
        var pool = currentMode === 'gradient' ? randomGradient :
                   currentMode === 'divergence' ? randomDivergence : randomCurl;
        var ex = pool[Math.floor(Math.random() * pool.length)];
        if (currentMode === 'gradient') {
            scalarInput.value = ex.scalar;
        } else {
            fxInput.value = ex.fx;
            fyInput.value = ex.fy;
            fzInput.value = ex.fz;
        }
        updatePreview();
    });

    function updateExamples() {
        var container = document.getElementById('vc-examples');
        var examples = currentMode === 'gradient' ? gradientExamples :
                       currentMode === 'divergence' ? divergenceExamples : curlExamples;
        var html = '';
        for (var i = 0; i < examples.length; i++) {
            var ex = examples[i];
            if (currentMode === 'gradient') {
                html += '<button type="button" class="vc-example-chip" data-scalar="' + escapeHtml(ex.scalar) + '">' + escapeHtml(ex.label) + '</button>';
            } else {
                html += '<button type="button" class="vc-example-chip" data-fx="' + escapeHtml(ex.fx) + '" data-fy="' + escapeHtml(ex.fy) + '" data-fz="' + escapeHtml(ex.fz) + '">' + escapeHtml(ex.label) + '</button>';
            }
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('vc-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.vc-example-chip');
        if (!chip) return;
        if (currentMode === 'gradient') {
            scalarInput.value = chip.getAttribute('data-scalar');
        } else {
            fxInput.value = chip.getAttribute('data-fx');
            fyInput.value = chip.getAttribute('data-fy');
            fzInput.value = chip.getAttribute('data-fz');
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
    bindPreviewInput(scalarInput);
    bindPreviewInput(fxInput);
    bindPreviewInput(fyInput);
    bindPreviewInput(fzInput);

    function updatePreview() {
        try {
            var latex;
            if (currentMode === 'gradient') {
                var expr = normalizeExpr(scalarInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a scalar field above\u2026</span>';
                    return;
                }
                latex = '\\nabla f = \\nabla\\left(' + exprToLatex(expr) + '\\right)';
            } else if (currentMode === 'divergence') {
                var fx = normalizeExpr(fxInput.value.trim());
                var fy = normalizeExpr(fyInput.value.trim());
                var fz = normalizeExpr(fzInput.value.trim());
                if (!fx && !fy && !fz) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type vector field components above\u2026</span>';
                    return;
                }
                latex = '\\nabla \\cdot \\mathbf{F} = \\frac{\\partial}{\\partial x}\\left(' + exprToLatex(fx || '0') + '\\right) + \\frac{\\partial}{\\partial y}\\left(' + exprToLatex(fy || '0') + '\\right) + \\frac{\\partial}{\\partial z}\\left(' + exprToLatex(fz || '0') + '\\right)';
            } else {
                var fx = normalizeExpr(fxInput.value.trim());
                var fy = normalizeExpr(fyInput.value.trim());
                var fz = normalizeExpr(fzInput.value.trim());
                if (!fx && !fy && !fz) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type vector field components above\u2026</span>';
                    return;
                }
                latex = '\\nabla \\times \\mathbf{F} = \\begin{vmatrix} \\hat{\\mathbf{i}} & \\hat{\\mathbf{j}} & \\hat{\\mathbf{k}} \\\\ \\frac{\\partial}{\\partial x} & \\frac{\\partial}{\\partial y} & \\frac{\\partial}{\\partial z} \\\\ ' + exprToLatex(fx || '0') + ' & ' + exprToLatex(fy || '0') + ' & ' + exprToLatex(fz || '0') + ' \\end{vmatrix}';
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = 'from sympy import symbols, diff, latex, simplify, sin, cos, tan, exp, log, sqrt, pi, sec, csc, cot, sinh, cosh, tanh, asin, acos, atan, Abs\n';
        code += 'import json, numpy as np\n';
        code += 'x, y, z = symbols("x y z")\n\n';

        if (mode === 'gradient') {
            var expr = exprToPython(normalizeExpr(scalarInput.value.trim()));
            code += 'f = ' + expr + '\n';
            code += 'gx = simplify(diff(f, x))\n';
            code += 'gy = simplify(diff(f, y))\n';
            code += 'gz = simplify(diff(f, z))\n\n';
            // Results
            code += 'print("RESULT_X:" + latex(gx))\n';
            code += 'print("RESULT_Y:" + latex(gy))\n';
            code += 'print("RESULT_Z:" + latex(gz))\n';
            code += 'print("TEXT_X:" + str(gx))\n';
            code += 'print("TEXT_Y:" + str(gy))\n';
            code += 'print("TEXT_Z:" + str(gz))\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given scalar field", "latex": "f(x,y,z) = " + latex(f)})\n';
            code += 'steps.append({"title": "Definition of gradient", "latex": r"\\\\nabla f = \\\\frac{\\\\partial f}{\\\\partial x}\\\\hat{\\\\mathbf{i}} + \\\\frac{\\\\partial f}{\\\\partial y}\\\\hat{\\\\mathbf{j}} + \\\\frac{\\\\partial f}{\\\\partial z}\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Compute partial derivative w.r.t. x", "latex": r"\\\\frac{\\\\partial f}{\\\\partial x} = " + latex(diff(f,x)) + (" = " + latex(gx) if gx != diff(f,x) else "")})\n';
            code += 'steps.append({"title": "Compute partial derivative w.r.t. y", "latex": r"\\\\frac{\\\\partial f}{\\\\partial y} = " + latex(diff(f,y)) + (" = " + latex(gy) if gy != diff(f,y) else "")})\n';
            code += 'steps.append({"title": "Compute partial derivative w.r.t. z", "latex": r"\\\\frac{\\\\partial f}{\\\\partial z} = " + latex(diff(f,z)) + (" = " + latex(gz) if gz != diff(f,z) else "")})\n';
            code += 'steps.append({"title": "Simplify each component", "latex": r"\\\\nabla f = \\\\left(" + latex(gx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(gy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(gz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\nabla f = \\\\left(" + latex(gx) + ", " + latex(gy) + ", " + latex(gz) + r"\\\\right)}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot data
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    gx_f = lambdify((x,y,z), gx, "numpy")\n';
            code += '    gy_f = lambdify((x,y,z), gy, "numpy")\n';
            code += '    gz_f = lambdify((x,y,z), gz, "numpy")\n';
            code += '    pts = np.linspace(-2, 2, 6)\n';
            code += '    data = []\n';
            code += '    for xi in pts:\n';
            code += '        for yi in pts:\n';
            code += '            for zi in pts:\n';
            code += '                try:\n';
            code += '                    u = float(gx_f(xi, yi, zi))\n';
            code += '                    v = float(gy_f(xi, yi, zi))\n';
            code += '                    w = float(gz_f(xi, yi, zi))\n';
            code += '                    if all(abs(c) < 1e6 for c in [u,v,w]):\n';
            code += '                        data.append([float(xi),float(yi),float(zi),u,v,w])\n';
            code += '                except: pass\n';
            code += '    print("PLOT:" + json.dumps(data))\n';
            code += 'except:\n';
            code += '    print("PLOT:[]")\n';
        } else if (mode === 'divergence') {
            var fx = exprToPython(normalizeExpr(fxInput.value.trim())) || '0';
            var fy = exprToPython(normalizeExpr(fyInput.value.trim())) || '0';
            var fz = exprToPython(normalizeExpr(fzInput.value.trim())) || '0';
            code += 'Fx = ' + fx + '\n';
            code += 'Fy = ' + fy + '\n';
            code += 'Fz = ' + fz + '\n\n';
            code += 'dFx_dx = diff(Fx, x)\n';
            code += 'dFy_dy = diff(Fy, y)\n';
            code += 'dFz_dz = diff(Fz, z)\n';
            code += 'div = simplify(dFx_dx + dFy_dy + dFz_dz)\n\n';
            code += 'print("RESULT:" + latex(div))\n';
            code += 'print("TEXT:" + str(div))\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given vector field", "latex": r"\\\\mathbf{F} = \\\\left(" + latex(Fx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(Fy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(Fz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Definition of divergence", "latex": r"\\\\nabla \\\\cdot \\\\mathbf{F} = \\\\frac{\\\\partial F_x}{\\\\partial x} + \\\\frac{\\\\partial F_y}{\\\\partial y} + \\\\frac{\\\\partial F_z}{\\\\partial z}"})\n';
            code += 'steps.append({"title": "Compute each partial derivative", "latex": r"\\\\frac{\\\\partial F_x}{\\\\partial x} = " + latex(dFx_dx) + r", \\\\quad \\\\frac{\\\\partial F_y}{\\\\partial y} = " + latex(dFy_dy) + r", \\\\quad \\\\frac{\\\\partial F_z}{\\\\partial z} = " + latex(dFz_dz)})\n';
            code += 'steps.append({"title": "Sum the partial derivatives", "latex": r"\\\\nabla \\\\cdot \\\\mathbf{F} = " + latex(dFx_dx) + " + " + latex(dFy_dy) + " + " + latex(dFz_dz) + " = " + latex(div)})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n';
            code += 'print("PLOT:[]")\n';
        } else {
            // curl
            var fx = exprToPython(normalizeExpr(fxInput.value.trim())) || '0';
            var fy = exprToPython(normalizeExpr(fyInput.value.trim())) || '0';
            var fz = exprToPython(normalizeExpr(fzInput.value.trim())) || '0';
            code += 'Fx = ' + fx + '\n';
            code += 'Fy = ' + fy + '\n';
            code += 'Fz = ' + fz + '\n\n';
            code += 'cx = simplify(diff(Fz, y) - diff(Fy, z))\n';
            code += 'cy = simplify(diff(Fx, z) - diff(Fz, x))\n';
            code += 'cz = simplify(diff(Fy, x) - diff(Fx, y))\n\n';
            code += 'print("RESULT_X:" + latex(cx))\n';
            code += 'print("RESULT_Y:" + latex(cy))\n';
            code += 'print("RESULT_Z:" + latex(cz))\n';
            code += 'print("TEXT_X:" + str(cx))\n';
            code += 'print("TEXT_Y:" + str(cy))\n';
            code += 'print("TEXT_Z:" + str(cz))\n';
            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given vector field", "latex": r"\\\\mathbf{F} = \\\\left(" + latex(Fx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(Fy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(Fz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}"})\n';
            code += 'steps.append({"title": "Curl as determinant", "latex": r"\\\\nabla \\\\times \\\\mathbf{F} = \\\\begin{vmatrix} \\\\hat{\\\\mathbf{i}} & \\\\hat{\\\\mathbf{j}} & \\\\hat{\\\\mathbf{k}} \\\\\\\\ \\\\frac{\\\\partial}{\\\\partial x} & \\\\frac{\\\\partial}{\\\\partial y} & \\\\frac{\\\\partial}{\\\\partial z} \\\\\\\\ " + latex(Fx) + " & " + latex(Fy) + " & " + latex(Fz) + r" \\\\end{vmatrix}"})\n';
            code += 'steps.append({"title": "i-component", "latex": r"\\\\hat{\\\\mathbf{i}}: \\\\frac{\\\\partial}{\\\\partial y}\\\\left(" + latex(Fz) + r"\\\\right) - \\\\frac{\\\\partial}{\\\\partial z}\\\\left(" + latex(Fy) + r"\\\\right) = " + latex(diff(Fz,y)) + " - " + latex(diff(Fy,z)) + " = " + latex(cx)})\n';
            code += 'steps.append({"title": "j-component", "latex": r"\\\\hat{\\\\mathbf{j}}: \\\\frac{\\\\partial}{\\\\partial z}\\\\left(" + latex(Fx) + r"\\\\right) - \\\\frac{\\\\partial}{\\\\partial x}\\\\left(" + latex(Fz) + r"\\\\right) = " + latex(diff(Fx,z)) + " - " + latex(diff(Fz,x)) + " = " + latex(cy)})\n';
            code += 'steps.append({"title": "k-component", "latex": r"\\\\hat{\\\\mathbf{k}}: \\\\frac{\\\\partial}{\\\\partial x}\\\\left(" + latex(Fy) + r"\\\\right) - \\\\frac{\\\\partial}{\\\\partial y}\\\\left(" + latex(Fx) + r"\\\\right) = " + latex(diff(Fy,x)) + " - " + latex(diff(Fx,y)) + " = " + latex(cz)})\n';
            code += 'steps.append({"title": "Final result", "latex": r"\\\\boxed{\\\\nabla \\\\times \\\\mathbf{F} = \\\\left(" + latex(cx) + r"\\\\right)\\\\hat{\\\\mathbf{i}} + \\\\left(" + latex(cy) + r"\\\\right)\\\\hat{\\\\mathbf{j}} + \\\\left(" + latex(cz) + r"\\\\right)\\\\hat{\\\\mathbf{k}}}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';
            // Plot data
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    cx_f = lambdify((x,y,z), cx, "numpy")\n';
            code += '    cy_f = lambdify((x,y,z), cy, "numpy")\n';
            code += '    cz_f = lambdify((x,y,z), cz, "numpy")\n';
            code += '    pts = np.linspace(-2, 2, 6)\n';
            code += '    data = []\n';
            code += '    for xi in pts:\n';
            code += '        for yi in pts:\n';
            code += '            for zi in pts:\n';
            code += '                try:\n';
            code += '                    u = float(cx_f(xi, yi, zi))\n';
            code += '                    v = float(cy_f(xi, yi, zi))\n';
            code += '                    w = float(cz_f(xi, yi, zi))\n';
            code += '                    if all(abs(c) < 1e6 for c in [u,v,w]):\n';
            code += '                        data.append([float(xi),float(yi),float(zi),u,v,w])\n';
            code += '                except: pass\n';
            code += '    print("PLOT:" + json.dumps(data))\n';
            code += 'except:\n';
            code += '    print("PLOT:[]")\n';
        }
        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    scalarInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });

    function doCompute() {
        // Validate
        if (currentMode === 'gradient') {
            if (!scalarInput.value.trim()) {
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a scalar field.', 2000, 'warning');
                return;
            }
        } else {
            if (!fxInput.value.trim() && !fyInput.value.trim() && !fzInput.value.trim()) {
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter at least one vector component.', 2000, 'warning');
                return;
            }
        }

        // Show loading
        resultActions.classList.remove('visible');
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="vc-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing ' + currentMode + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);
        var mode = currentMode;

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.VC_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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

            parseAndShowResult(mode, stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            showError(err.name === 'AbortError' ? 'Request timed out' : err.message);
        });
    }

    // ========== Parse & Display Result ==========
    function parseAndShowResult(mode, stdout) {
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\nPLOT|\nRESULT|$)/);
        var plotMatch = stdout.match(/PLOT:(\[[\s\S]*?\])$/m);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch(e) {}
        var plotData = [];
        try { if (plotMatch) plotData = JSON.parse(plotMatch[1]); } catch(e) {}

        if (mode === 'gradient' || mode === 'curl') {
            var rxMatch = stdout.match(/RESULT_X:([^\n]*)/);
            var ryMatch = stdout.match(/RESULT_Y:([^\n]*)/);
            var rzMatch = stdout.match(/RESULT_Z:([^\n]*)/);
            var txMatch = stdout.match(/TEXT_X:([^\n]*)/);
            var tyMatch = stdout.match(/TEXT_Y:([^\n]*)/);
            var tzMatch = stdout.match(/TEXT_Z:([^\n]*)/);

            var rx = rxMatch ? rxMatch[1].trim() : '0';
            var ry = ryMatch ? ryMatch[1].trim() : '0';
            var rz = rzMatch ? rzMatch[1].trim() : '0';
            var tx = txMatch ? txMatch[1].trim() : rx;
            var ty = tyMatch ? tyMatch[1].trim() : ry;
            var tz = tzMatch ? tzMatch[1].trim() : rz;

            showVectorResult(mode, rx, ry, rz, tx, ty, tz, steps);

            if (plotData.length > 0) {
                pendingGraph = { data: plotData, mode: mode };
                if (graphHint) graphHint.style.display = 'none';
                var graphPanel = document.getElementById('vc-panel-graph');
                if (graphPanel.classList.contains('active')) {
                    loadPlotly(function() { renderGraph(pendingGraph); });
                }
            }
        } else {
            // divergence - scalar result
            var rMatch = stdout.match(/RESULT:([^\n]*)/);
            var tMatch = stdout.match(/TEXT:([^\n]*)/);
            var result = rMatch ? rMatch[1].trim() : '0';
            var text = tMatch ? tMatch[1].trim() : result;

            showScalarResult(result, text, steps);
        }

        resultActions.classList.add('visible');
    }

    function showVectorResult(mode, rx, ry, rz, tx, ty, tz, steps) {
        var symbol = mode === 'gradient' ? '\\nabla f' : '\\nabla \\times \\mathbf{F}';
        lastResultLatex = symbol + ' = \\left(' + rx + '\\right)\\hat{\\mathbf{i}} + \\left(' + ry + '\\right)\\hat{\\mathbf{j}} + \\left(' + rz + '\\right)\\hat{\\mathbf{k}}';
        lastResultText = '(' + tx + ', ' + ty + ', ' + tz + ')';

        var modeLabel = mode === 'gradient' ? 'Gradient' : 'Curl';
        var html = '<div class="vc-result-math">';
        html += '<div class="vc-result-label">' + modeLabel + '</div>';
        html += '<div class="vc-result-main" id="vc-r-result"></div>';
        html += '<div class="vc-vector-result">';
        html += '<div class="vc-vector-component"><span class="vc-component-badge">i</span><span id="vc-r-i"></span></div>';
        html += '<div class="vc-vector-component"><span class="vc-component-badge">j</span><span id="vc-r-j"></span></div>';
        html += '<div class="vc-vector-component"><span class="vc-component-badge">k</span><span id="vc-r-k"></span></div>';
        html += '</div>';
        html += '<div class="vc-result-detail"><span class="vc-method-badge">' + modeLabel + ' (SymPy CAS)</span></div>';
        html += '<button type="button" class="vc-steps-btn" id="vc-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="vc-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render(lastResultLatex, document.getElementById('vc-r-result'), { displayMode: true, throwOnError: false });
        katex.render(rx, document.getElementById('vc-r-i'), { displayMode: false, throwOnError: false });
        katex.render(ry, document.getElementById('vc-r-j'), { displayMode: false, throwOnError: false });
        katex.render(rz, document.getElementById('vc-r-k'), { displayMode: false, throwOnError: false });

        var stepsBtn = document.getElementById('vc-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    function showScalarResult(resultLatex, resultText, steps) {
        lastResultLatex = '\\nabla \\cdot \\mathbf{F} = ' + resultLatex;
        lastResultText = resultText;

        var html = '<div class="vc-result-math">';
        html += '<div class="vc-result-label">Divergence</div>';
        html += '<div class="vc-result-main" id="vc-r-result"></div>';
        html += '<div class="vc-result-detail"><span class="vc-method-badge">Divergence (SymPy CAS)</span></div>';
        html += '<button type="button" class="vc-steps-btn" id="vc-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="vc-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render(lastResultLatex, document.getElementById('vc-r-result'), { displayMode: true, throwOnError: false });

        var stepsBtn = document.getElementById('vc-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('vc-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="vc-steps-container">';
        html += '<div class="vc-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="vc-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="vc-step">';
            html += '<span class="vc-step-num">' + (i + 1) + '</span>';
            html += '<div class="vc-step-body">';
            html += '<div class="vc-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="vc-step-math" id="vc-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('vc-step-math-' + j);
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
        var html = '<div class="vc-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use explicit multiplication: x*y not xy</li>';
        html += '<li>Use ^ for powers: x^2 not x2</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg || !cfg.data || cfg.data.length === 0) return;
        var container = document.getElementById('vc-graph-container');

        var xs = [], ys = [], zs = [], us = [], vs = [], ws = [];
        for (var i = 0; i < cfg.data.length; i++) {
            var p = cfg.data[i];
            xs.push(p[0]); ys.push(p[1]); zs.push(p[2]);
            us.push(p[3]); vs.push(p[4]); ws.push(p[5]);
        }

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        var trace = {
            type: 'cone',
            x: xs, y: ys, z: zs,
            u: us, v: vs, w: ws,
            colorscale: 'Portland',
            sizemode: 'absolute',
            sizeref: 1,
            showscale: true,
            colorbar: { title: 'Magnitude', tickfont: { color: isDark ? '#cbd5e1' : '#475569' }, titlefont: { color: isDark ? '#cbd5e1' : '#475569' } }
        };

        var layout = {
            margin: { t: 30, r: 20, b: 30, l: 20 },
            scene: {
                xaxis: { title: 'x', gridcolor: isDark ? '#334155' : '#e2e8f0', color: isDark ? '#cbd5e1' : '#475569' },
                yaxis: { title: 'y', gridcolor: isDark ? '#334155' : '#e2e8f0', color: isDark ? '#cbd5e1' : '#475569' },
                zaxis: { title: 'z', gridcolor: isDark ? '#334155' : '#e2e8f0', color: isDark ? '#cbd5e1' : '#475569' },
                bgcolor: isDark ? '#1e293b' : '#fff'
            },
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#cbd5e1' : '#475569' }
        };

        Plotly.newPlot(container, [trace], layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function buildCompilerCode() {
        var code = 'from sympy import *\nimport json\n\nx, y, z = symbols("x y z")\n\n';
        if (currentMode === 'gradient') {
            var expr = exprToPython(normalizeExpr(scalarInput.value.trim())) || 'x**2 + y**2 + z**2';
            code += '# Scalar field\nf = ' + expr + '\n\n';
            code += '# Gradient: (df/dx, df/dy, df/dz)\n';
            code += 'grad = [simplify(diff(f, v)) for v in (x, y, z)]\n\n';
            code += 'print("Gradient of f =")\npprint(f)\nprint()\n';
            code += 'for i, (comp, var) in enumerate(zip(grad, ["x","y","z"])):\n';
            code += '    print(f"  df/d{var} = {comp}")\n';
            code += 'print(f"\\ngrad f = ({grad[0]}, {grad[1]}, {grad[2]})")\n';
        } else if (currentMode === 'divergence') {
            var fx = exprToPython(normalizeExpr(fxInput.value.trim())) || 'x';
            var fy = exprToPython(normalizeExpr(fyInput.value.trim())) || 'y';
            var fz = exprToPython(normalizeExpr(fzInput.value.trim())) || 'z';
            code += '# Vector field F = (Fx, Fy, Fz)\n';
            code += 'Fx = ' + fx + '\nFy = ' + fy + '\nFz = ' + fz + '\n\n';
            code += '# Divergence: dFx/dx + dFy/dy + dFz/dz\n';
            code += 'div = simplify(diff(Fx, x) + diff(Fy, y) + diff(Fz, z))\n\n';
            code += 'print(f"F = ({Fx}, {Fy}, {Fz})")\n';
            code += 'print(f"div F = {div}")\n';
        } else {
            var fx = exprToPython(normalizeExpr(fxInput.value.trim())) || '-y';
            var fy = exprToPython(normalizeExpr(fyInput.value.trim())) || 'x';
            var fz = exprToPython(normalizeExpr(fzInput.value.trim())) || '0';
            code += '# Vector field F = (Fx, Fy, Fz)\n';
            code += 'Fx = ' + fx + '\nFy = ' + fy + '\nFz = ' + fz + '\n\n';
            code += '# Curl: (dFz/dy - dFy/dz, dFx/dz - dFz/dx, dFy/dx - dFx/dy)\n';
            code += 'cx = simplify(diff(Fz, y) - diff(Fy, z))\n';
            code += 'cy = simplify(diff(Fx, z) - diff(Fz, x))\n';
            code += 'cz = simplify(diff(Fy, x) - diff(Fx, y))\n\n';
            code += 'print(f"F = ({Fx}, {Fy}, {Fz})")\n';
            code += 'print(f"curl F = ({cx}, {cy}, {cz})")\n';
        }
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('vc-compiler-iframe');
        iframe.src = (window.VC_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share ==========
    document.getElementById('vc-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    // ========== Download PDF ==========
    document.getElementById('vc-download-pdf-btn').addEventListener('click', function() {
        downloadResultPdf();
    });

    function downloadResultPdf() {
        if (!lastResultLatex) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
            return;
        }

        // Build off-screen container for capture
        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        // Title
        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#4f46e5;';
        title.textContent = 'Vector Calculus Calculator — 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#4f46e5,#6366f1,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        // Mode label
        var modeLabel = currentMode.charAt(0).toUpperCase() + currentMode.slice(1);
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = modeLabel;
        container.appendChild(qLabel);

        // Input expression
        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
        container.appendChild(qMath);
        try {
            if (currentMode === 'gradient') {
                katex.render('\\nabla \\left(' + exprToLatex(scalarInput.value) + '\\right)', qMath, { displayMode: true, throwOnError: false });
            } else if (currentMode === 'divergence') {
                katex.render('\\nabla \\cdot \\mathbf{F}, \\quad \\mathbf{F} = \\left(' + exprToLatex(fxInput.value) + ',\\; ' + exprToLatex(fyInput.value) + ',\\; ' + exprToLatex(fzInput.value) + '\\right)', qMath, { displayMode: true, throwOnError: false });
            } else {
                katex.render('\\nabla \\times \\mathbf{F}, \\quad \\mathbf{F} = \\left(' + exprToLatex(fxInput.value) + ',\\; ' + exprToLatex(fyInput.value) + ',\\; ' + exprToLatex(fzInput.value) + '\\right)', qMath, { displayMode: true, throwOnError: false });
            }
        } catch (e) {
            qMath.textContent = currentMode === 'gradient' ? scalarInput.value : fxInput.value + ', ' + fyInput.value + ', ' + fzInput.value;
        }

        // Result section
        var aLabel = document.createElement('div');
        aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent = 'Result';
        container.appendChild(aLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#eef2ff;border-radius:8px;';
        container.appendChild(aMath);
        try {
            katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            aMath.textContent = lastResultText;
        }

        // Include steps if rendered
        var stepsArea = document.getElementById('vc-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.vc-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#4f46e5;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.vc-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.vc-step-math');
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

        // Footer
        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Vector Calculus Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        // Capture and generate PDF
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

            var filename = 'vector-calculus-' + currentMode + '.pdf';
            pdf.save(filename);

            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet (WorksheetEngine) ==========
    document.getElementById('vc-worksheet-btn').addEventListener('click', function() {
        if (typeof WorksheetEngine !== 'undefined') {
            WorksheetEngine.open({
                jsonUrl: 'worksheet/math/calculus/vector_calculus.json',
                title: 'Vector Calculus',
                accentColor: '#7c3aed',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        }
    });

    document.getElementById('vc-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'gradient') {
            params.f = scalarInput.value;
        } else {
            params.fx = fxInput.value;
            params.fy = fyInput.value;
            params.fz = fzInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Vector Calculus Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'gradient' || shareMode === 'divergence' || shareMode === 'curl')) {
            // Click the mode button
            var btn = document.querySelector('.vc-mode-btn[data-mode="' + shareMode + '"]');
            if (btn) btn.click();
            if (shareMode === 'gradient') {
                var f = urlParams.get('f');
                if (f) { scalarInput.value = f; updatePreview(); }
            } else {
                var fx = urlParams.get('fx');
                var fy = urlParams.get('fy');
                var fz = urlParams.get('fz');
                if (fx) fxInput.value = fx;
                if (fy) fyInput.value = fy;
                if (fz) fzInput.value = fz;
                updatePreview();
            }
        }
    } catch(e) {}

})();
