<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for vector-calculus-calculator.jsp.

    Shared infrastructure (KaTeX / nerdamer / tool-utils / dark-mode /
    search / plotly loader / image-to-math) is loaded separately by
    /math/partials/math-libs.jsp — include this file AFTER it.

    Vector-calc has 3 separate text inputs (Fx, Fy, Fz) for vector field
    components, so MathLive (single math-field) does NOT apply.
    math-input-setup.jsp is NOT included by the parent page.

    Load order inside this partial:
      1. worksheet-engine.js                  — printable worksheet (vector bank)
      2. window.VC_CALC_CTX context var       — used by main controller
      3. vector-calculus-calculator.js        — main DOM/UI controller
      4. image-to-math init (inline)          — vector-specific prompt + handlers
--%>

<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>

<!-- Context for image-scan + Python compiler iframe (legacy var name kept). -->
<script>window.VC_CALC_CTX = "<%=request.getContextPath()%>";</script>

<script src="<%=request.getContextPath()%>/modern/js/vector-calculus-calculator.js"></script>

<!-- ─── Image-to-math scanner init — vector-calc-specific prompt ─── -->
<script>
(function() {
var VC_CTX = window.VC_CALC_CTX || '';

ImageToMath.init({
    buttonId: 'vc-image-btn',
    aiUrl: VC_CTX + '/ai',
    toolName: 'Vector Calculus Calculator',
    extractionPrompt:
        'You are a math problem extractor for a vector calculus calculator.\n' +
        'Given OCR text from a math image, extract ALL vector calculus problems.\n' +
        'Return a JSON array. Each object has:\n' +
        '  - "operation": "gradient", "divergence", or "curl"\n' +
        '  - "scalar": scalar field expression (for gradient), e.g. "x^2 + y^2 + z^2"\n' +
        '  - "fx": x-component of vector field (for divergence/curl)\n' +
        '  - "fy": y-component of vector field\n' +
        '  - "fz": z-component of vector field\n' +
        '  - "display": full problem in LaTeX for display\n' +
        '  - "latex": the expression (scalar or "F = (fx, fy, fz)" form) for display\n\n' +
        'CRITICAL RULES:\n' +
        '- Use plain math notation, NOT LaTeX commands (e.g. "x^2*y" not "x^{2}y").\n' +
        '- Use * for multiplication, ^ for exponents.\n' +
        '- For gradient: set "scalar" field, leave fx/fy/fz empty.\n' +
        '- For divergence/curl: set "fx","fy","fz" fields, leave "scalar" empty.\n' +
        '- Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
        '- If no problems found, return []\n\n' +
        'Example:\n' +
        'Input: "Find the gradient of f(x,y,z) = x^2*y + e^z"\n' +
        'Output: [{"operation":"gradient","scalar":"x^2*y + e^z","fx":"","fy":"","fz":"","display":"\\\\nabla(x^2 y + e^z)","latex":"x^2 y + e^z"}]',
    onSelect: function(problem) {
        var op = problem.operation || 'gradient';
        var modeBtn = document.querySelector('.vc-mode-btn[data-mode="' + op + '"]');
        if (modeBtn) modeBtn.click();

        if (op === 'gradient') {
            var scalarInput = document.getElementById('vc-scalar-expr');
            if (scalarInput) scalarInput.value = problem.scalar || problem.expr || '';
        } else {
            var fxInput = document.getElementById('vc-fx');
            var fyInput = document.getElementById('vc-fy');
            var fzInput = document.getElementById('vc-fz');
            if (fxInput) fxInput.value = problem.fx || '';
            if (fyInput) fyInput.value = problem.fy || '';
            if (fzInput) fzInput.value = problem.fz || '';
        }
        setTimeout(function() {
            var computeBtn = document.getElementById('vc-compute-btn');
            if (computeBtn) computeBtn.click();
        }, 300);
    },
    onSolveAll: function(problems) {
        batchSolveVector(problems);
    }
});

function batchSolveVector(problems) {
    var existing = document.getElementById('itm-results-overlay');
    if (existing) existing.remove();

    var ov = document.createElement('div');
    ov.id = 'itm-results-overlay';
    ov.className = 'itm-results-overlay';
    ov.innerHTML =
        '<div class="itm-results-modal">' +
        '  <div class="itm-results-header">' +
        '    <span class="itm-results-title">Solving ' + problems.length + ' Problem' + (problems.length > 1 ? 's' : '') + '</span>' +
        '    <button class="itm-close" id="itm-results-close">&times;</button>' +
        '  </div>' +
        '  <div class="itm-results-body" id="itm-results-body"></div>' +
        '  <div class="itm-results-footer">' +
        '    <button class="itm-btn" id="itm-results-done">Close</button>' +
        '  </div>' +
        '</div>';
    document.body.appendChild(ov);
    ov.style.display = 'flex';
    document.body.style.overflow = 'hidden';

    var closeResults = function() { ov.style.display = 'none'; document.body.style.overflow = ''; ov.remove(); };
    document.getElementById('itm-results-close').addEventListener('click', closeResults);
    document.getElementById('itm-results-done').addEventListener('click', closeResults);
    ov.addEventListener('click', function(e) { if (e.target === ov) closeResults(); });

    var body = document.getElementById('itm-results-body');
    problems.forEach(function(p, i) {
        var display = p.display || p.latex || p.scalar || '';
        var card = document.createElement('div');
        card.className = 'itm-result-card';
        card.id = 'itm-rc-' + i;
        card.innerHTML =
            '<div class="itm-result-card-header">' +
            '  <span class="itm-result-num">' + (i + 1) + '</span>' +
            '  <span class="itm-result-problem" id="itm-rp-' + i + '"></span>' +
            '  <span class="itm-result-status pending" id="itm-rs-' + i + '">Pending</span>' +
            '</div>' +
            '<div class="itm-result-card-body" id="itm-rb-' + i + '"></div>';
        body.appendChild(card);
        if (window.katex) {
            try { katex.render(display, document.getElementById('itm-rp-' + i), { throwOnError: false, displayMode: false }); }
            catch(e) { document.getElementById('itm-rp-' + i).textContent = display; }
        }
    });
    solveNextVector(problems, 0);
}

function solveNextVector(problems, idx) {
    if (idx >= problems.length) return;
    var p = problems[idx];
    var card = document.getElementById('itm-rc-' + idx);
    var status = document.getElementById('itm-rs-' + idx);
    var bodyEl = document.getElementById('itm-rb-' + idx);

    card.className = 'itm-result-card solving';
    status.className = 'itm-result-status solving';
    status.textContent = 'Solving...';
    bodyEl.innerHTML = '<div class="itm-spinner"></div>';
    card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    var op = p.operation || 'gradient';
    var code = 'from sympy import symbols, diff, latex, simplify, sin, cos, tan, exp, log, sqrt, pi, E, sec, csc, cot, sinh, cosh, tanh, asin, acos, atan, Abs, Symbol\n';
    code += 'import json\n';
    code += 'x, y, z = symbols("x y z")\n\n';

    function sanitize(expr) {
        return (expr || '0').replace(/\^/g, '**').replace(/\be\b(?!\s*\()/g, 'E');
    }

    if (op === 'gradient') {
        var scalar = sanitize(p.scalar || p.expr || '0');
        code += 'f = ' + scalar + '\n';
        code += 'gx = simplify(diff(f, x))\ngy = simplify(diff(f, y))\ngz = simplify(diff(f, z))\n';
        code += 'print("LATEX:" + latex(gx) + ", " + latex(gy) + ", " + latex(gz))\n';
        code += 'print("TEXT:(" + str(gx) + ", " + str(gy) + ", " + str(gz) + ")")\n';
        code += 'steps = []\n';
        code += 'steps.append({"title":"Given scalar field","latex":"f(x,y,z) = " + latex(f)})\n';
        code += 'steps.append({"title":"Partial derivative w.r.t. x","latex":r"\\\\frac{\\\\partial f}{\\\\partial x} = " + latex(gx)})\n';
        code += 'steps.append({"title":"Partial derivative w.r.t. y","latex":r"\\\\frac{\\\\partial f}{\\\\partial y} = " + latex(gy)})\n';
        code += 'steps.append({"title":"Partial derivative w.r.t. z","latex":r"\\\\frac{\\\\partial f}{\\\\partial z} = " + latex(gz)})\n';
        code += 'steps.append({"title":"Result","latex":r"\\\\nabla f = \\\\left(" + latex(gx) + ", " + latex(gy) + ", " + latex(gz) + r"\\\\right)"})\n';
        code += 'print("STEPS:" + json.dumps(steps))\n';
    } else if (op === 'divergence') {
        var fx = sanitize(p.fx), fy = sanitize(p.fy), fz = sanitize(p.fz);
        code += 'Fx = ' + fx + '\nFy = ' + fy + '\nFz = ' + fz + '\n';
        code += 'divF = simplify(diff(Fx,x) + diff(Fy,y) + diff(Fz,z))\n';
        code += 'print("LATEX:" + latex(divF))\n';
        code += 'print("TEXT:" + str(divF))\n';
        code += 'steps = []\n';
        code += 'steps.append({"title":"Given vector field","latex":r"\\\\mathbf{F} = \\\\left(" + latex(Fx) + r"\\\\right)\\\\hat{i} + \\\\left(" + latex(Fy) + r"\\\\right)\\\\hat{j} + \\\\left(" + latex(Fz) + r"\\\\right)\\\\hat{k}"})\n';
        code += 'steps.append({"title":"Definition","latex":r"\\\\nabla \\\\cdot \\\\mathbf{F} = \\\\frac{\\\\partial F_x}{\\\\partial x} + \\\\frac{\\\\partial F_y}{\\\\partial y} + \\\\frac{\\\\partial F_z}{\\\\partial z}"})\n';
        code += 'steps.append({"title":"Compute partials","latex":latex(diff(Fx,x)) + " + " + latex(diff(Fy,y)) + " + " + latex(diff(Fz,z))})\n';
        code += 'steps.append({"title":"Simplify","latex":r"\\\\nabla \\\\cdot \\\\mathbf{F} = " + latex(divF)})\n';
        code += 'print("STEPS:" + json.dumps(steps))\n';
    } else {
        var fx2 = sanitize(p.fx), fy2 = sanitize(p.fy), fz2 = sanitize(p.fz);
        code += 'Fx = ' + fx2 + '\nFy = ' + fy2 + '\nFz = ' + fz2 + '\n';
        code += 'cx = simplify(diff(Fz,y) - diff(Fy,z))\n';
        code += 'cy = simplify(diff(Fx,z) - diff(Fz,x))\n';
        code += 'cz = simplify(diff(Fy,x) - diff(Fx,y))\n';
        code += 'print("LATEX:" + latex(cx) + ", " + latex(cy) + ", " + latex(cz))\n';
        code += 'print("TEXT:(" + str(cx) + ", " + str(cy) + ", " + str(cz) + ")")\n';
        code += 'steps = []\n';
        code += 'steps.append({"title":"Given vector field","latex":r"\\\\mathbf{F} = \\\\left(" + latex(Fx) + r"\\\\right)\\\\hat{i} + \\\\left(" + latex(Fy) + r"\\\\right)\\\\hat{j} + \\\\left(" + latex(Fz) + r"\\\\right)\\\\hat{k}"})\n';
        code += 'steps.append({"title":"Definition","latex":r"\\\\nabla \\\\times \\\\mathbf{F} = \\\\begin{vmatrix} \\\\hat{i} & \\\\hat{j} & \\\\hat{k} \\\\\\\\ \\\\frac{\\\\partial}{\\\\partial x} & \\\\frac{\\\\partial}{\\\\partial y} & \\\\frac{\\\\partial}{\\\\partial z} \\\\\\\\ F_x & F_y & F_z \\\\end{vmatrix}"})\n';
        code += 'steps.append({"title":"i-component","latex":r"\\\\frac{\\\\partial F_z}{\\\\partial y} - \\\\frac{\\\\partial F_y}{\\\\partial z} = " + latex(cx)})\n';
        code += 'steps.append({"title":"j-component","latex":r"\\\\frac{\\\\partial F_x}{\\\\partial z} - \\\\frac{\\\\partial F_z}{\\\\partial x} = " + latex(cy)})\n';
        code += 'steps.append({"title":"k-component","latex":r"\\\\frac{\\\\partial F_y}{\\\\partial x} - \\\\frac{\\\\partial F_x}{\\\\partial y} = " + latex(cz)})\n';
        code += 'steps.append({"title":"Result","latex":r"\\\\nabla \\\\times \\\\mathbf{F} = \\\\left(" + latex(cx) + ", " + latex(cy) + ", " + latex(cz) + r"\\\\right)"})\n';
        code += 'print("STEPS:" + json.dumps(steps))\n';
    }

    fetch(VC_CTX + '/OneCompilerFunctionality?action=execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python', version: '3.10', code: code })
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        var stdout = (data.Stdout || data.stdout || '').trim();
        var stderr = (data.Stderr || data.stderr || '').trim();
        if (!stdout && stderr) throw new Error(stderr.split('\n').pop() || 'Solver error');
        if (!stdout) throw new Error('No result from solver');

        var latexMatch = stdout.match(/LATEX:([^\n]*)/);
        var textMatch = stdout.match(/TEXT:([^\n]*)/);
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?:\n|$)/);
        var resultTeX = latexMatch ? latexMatch[1].trim() : '';
        var resultText = textMatch ? textMatch[1].trim() : resultTeX;
        if (!resultTeX && !resultText) throw new Error('Computation failed');

        var resultTeXNorm = resultTeX.replace(/\\\\/g, '\\');

        var html = '';
        html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
        html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';

        var steps = [];
        if (stepsMatch) { try { steps = JSON.parse(stepsMatch[1]); } catch(e) {} }
        if (steps.length) {
            html += '<button class="itm-result-steps-btn" data-steps-idx="' + idx + '">Show Steps</button>';
            html += '<div class="itm-result-steps-area" id="itm-rsa-' + idx + '">';
            steps.forEach(function(s) {
                var stepId = 'itm-rst-' + idx + '-' + Math.random().toString(36).substr(2, 5);
                html += '<div class="itm-result-step">' +
                    '<div class="itm-result-step-title">' + (s.title || '').replace(/</g, '&lt;') + '</div>' +
                    '<div id="' + stepId + '" data-step-katex="' + (s.latex || '').replace(/&/g, '&amp;').replace(/"/g, '&quot;') + '"></div></div>';
            });
            html += '</div>';
        }
        bodyEl.innerHTML = html;

        if (window.katex) {
            var probEl = document.getElementById('itm-ri-' + idx);
            var ansEl = document.getElementById('itm-ra-' + idx);
            if (probEl) {
                var opLabel = op === 'gradient' ? '\\nabla f' : op === 'divergence' ? '\\nabla \\cdot \\mathbf{F}' : '\\nabla \\times \\mathbf{F}';
                try { katex.render(opLabel, probEl, { throwOnError: false, displayMode: false }); }
                catch(e) { probEl.textContent = op; }
            }
            if (ansEl) {
                try { katex.render('= ' + resultTeXNorm, ansEl, { throwOnError: false, displayMode: true }); }
                catch(e) { ansEl.textContent = '= ' + resultText; }
            }
            bodyEl.querySelectorAll('[data-step-katex]').forEach(function(el) {
                var raw = el.getAttribute('data-step-katex');
                var norm = raw.replace(/\\\\/g, '\\');
                try { katex.render(norm, el, { throwOnError: false, displayMode: true }); }
                catch(e) { el.textContent = raw; }
            });
        }

        var stepsBtn = bodyEl.querySelector('[data-steps-idx="' + idx + '"]');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                var area = document.getElementById('itm-rsa-' + idx);
                if (area) {
                    area.classList.toggle('open');
                    stepsBtn.textContent = area.classList.contains('open') ? 'Hide Steps' : 'Show Steps';
                }
            });
        }

        card.className = 'itm-result-card solved';
        status.className = 'itm-result-status done';
        status.textContent = 'Solved';
    })
    .catch(function(err) {
        card.className = 'itm-result-card error';
        status.className = 'itm-result-status fail';
        status.textContent = 'Failed';
        bodyEl.innerHTML = '<div class="itm-result-error-msg">' + (err.message || 'Error').replace(/</g, '&lt;') + '</div>';
    })
    .finally(function() {
        solveNextVector(problems, idx + 1);
    });
}
})();
</script>
