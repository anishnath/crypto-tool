<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for series-calculator.jsp.

    Shared infrastructure (KaTeX / nerdamer / tool-utils / dark-mode /
    search / plotly loader / image-to-math) is loaded separately by
    /math/partials/math-libs.jsp — include this file AFTER it.

    Series uses a plain text input (no MathLive), so math-input-setup.jsp
    is NOT included by the parent page.

    Load order inside this partial:
      1. series-calculator-render.js   — KaTeX rendering helpers
      2. series-calculator-graph.js    — Plotly convergence plot
      3. series-calculator-export.js   — PDF / share / LaTeX
      4. worksheet-engine.js           — printable worksheet (series bank)
      5. series-calculator-core.js     — main DOM/UI controller
      6. __SC_CTX context var          — used by image-scan + python compiler
      7. image-to-math init (inline)   — series-specific prompt + handlers
--%>

<script src="<%=request.getContextPath()%>/js/series-calculator-render.js"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-graph.js"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-export.js"></script>
<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-core.js"></script>

<!-- Context for image-scan + Python compiler iframe. -->
<script>window.__SC_CTX='<%=request.getContextPath()%>';</script>

<!-- ─── Image-to-math scanner init — series-specific prompt ─── -->
<script>
(function() {
var SC_CTX = window.__SC_CTX || '';

ImageToMath.init({
    buttonId: 'sc-image-btn',
    aiUrl: SC_CTX + '/ai',
    toolName: 'Series Calculator',
    extractionPrompt:
        'You are a math problem extractor for a Taylor/Maclaurin series calculator.\n' +
        'Given OCR text from a math image, extract ALL series expansion problems.\n' +
        'Return a JSON array. Each object has:\n' +
        '  - "latex": the function f(x) in LaTeX (e.g. "\\sin(x)", "e^{x}", "\\ln(1+x)")\n' +
        '  - "expr": the function in plain math (e.g. "sin(x)", "e^x", "ln(1+x)")\n' +
        '  - "center": center point a (default "0" for Maclaurin)\n' +
        '  - "terms": number of terms if specified (default 6)\n' +
        '  - "display": full problem in LaTeX for display\n\n' +
        'CRITICAL RULES:\n' +
        '- "expr" must be in calculator format: sin(x), e^x, ln(1+x), x^2, sqrt(x)\n' +
        '- Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
        '- If no problems found, return []\n\n' +
        'Example:\n' +
        'Input: "Find the Maclaurin series for e^x up to 5 terms"\n' +
        'Output: [{"latex":"e^{x}","expr":"e^x","center":"0","terms":5,"display":"e^{x} \\\\text{ about } x=0"}]',
    onSelect: function(problem) {
        var funcInput = document.getElementById('sc-func-input');
        var centerInput = document.getElementById('sc-center-point');
        var termsInput = document.getElementById('sc-num-terms');
        if (funcInput) funcInput.value = problem.expr || problem.latex || '';
        if (centerInput && problem.center != null) centerInput.value = problem.center;
        if (termsInput && problem.terms) termsInput.value = problem.terms;
        setTimeout(function() {
            var solveBtn = document.getElementById('sc-solve-btn');
            if (solveBtn) solveBtn.click();
        }, 300);
    },
    onSolveAll: function(problems) {
        batchSolveSeries(problems);
    }
});

function batchSolveSeries(problems) {
    var existing = document.getElementById('itm-results-overlay');
    if (existing) existing.remove();

    var ov = document.createElement('div');
    ov.id = 'itm-results-overlay';
    ov.className = 'itm-results-overlay';
    ov.innerHTML =
        '<div class="itm-results-modal">' +
        '  <div class="itm-results-header">' +
        '    <span class="itm-results-title">Expanding ' + problems.length + ' Series</span>' +
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
        var display = p.display || p.latex || p.expr || '';
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
    solveNextSeries(problems, 0);
}

function solveNextSeries(problems, idx) {
    if (idx >= problems.length) return;
    var p = problems[idx];
    var card = document.getElementById('itm-rc-' + idx);
    var status = document.getElementById('itm-rs-' + idx);
    var bodyEl = document.getElementById('itm-rb-' + idx);

    card.className = 'itm-result-card solving';
    status.className = 'itm-result-status solving';
    status.textContent = 'Expanding...';
    bodyEl.innerHTML = '<div class="itm-spinner"></div>';
    card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    var funcExpr = (p.expr || p.latex || 'e^x').replace(/\^/g, '**').replace(/\be\b(?!\s*\()/g, 'E').replace(/\bln\b/g, 'log');
    var center = p.center || '0';
    var numTerms = parseInt(p.terms) || 6;
    center = center.replace(/\\infty/g, 'oo').replace(/\\pi/g, 'pi');

    var code = 'from sympy import *\nimport json\n' +
        'x = symbols("x")\n' +
        'f = ' + funcExpr + '\n' +
        'a = ' + center + '\n' +
        'n = ' + numTerms + '\n' +
        'try:\n' +
        '    s = series(f, x, a, n=n)\n' +
        '    poly = s.removeO()\n' +
        '    print("LATEX:" + latex(poly))\n' +
        '    print("TEXT:" + str(poly))\n' +
        '    print("FULL:" + latex(s))\n' +
        '    steps = []\n' +
        '    steps.append({"title":"Function","latex":"f(x) = " + latex(f)})\n' +
        '    if a == 0:\n' +
        '        steps.append({"title":"Maclaurin series formula","latex":r"f(x) = \\\\sum_{n=0}^{\\\\infty} \\\\frac{f^{(n)}(0)}{n!} x^n"})\n' +
        '    else:\n' +
        '        steps.append({"title":"Taylor series formula","latex":r"f(x) = \\\\sum_{n=0}^{\\\\infty} \\\\frac{f^{(n)}(" + latex(a) + r")}{n!} (x-" + latex(a) + r")^n"})\n' +
        '    cur = f\n' +
        '    for i in range(min(n, 5)):\n' +
        '        val = cur.subs(x, a)\n' +
        '        if i == 0:\n' +
        '            steps.append({"title":"f(" + latex(a) + ")","latex":"f(" + latex(a) + ") = " + latex(val)})\n' +
        '        else:\n' +
        '            steps.append({"title":"f" + "\\\\prime"*min(i,3) + ("^{("+str(i)+")}") * (1 if i>3 else 0) + "(" + latex(a) + ")","latex":"f^{(" + str(i) + ")}(" + latex(a) + ") = " + latex(val)})\n' +
        '        cur = diff(cur, x)\n' +
        '    steps.append({"title":"Series expansion","latex":latex(s)})\n' +
        '    try:\n' +
        '        from sympy import Abs as sp_Abs\n' +
        '        terms_list = poly.as_ordered_terms()\n' +
        '        if len(terms_list) >= 2:\n' +
        '            ratio = sp_Abs(terms_list[-1] / terms_list[-2])\n' +
        '            R = limit(1/ratio.rewrite(x), x, oo)\n' +
        '            if R.is_finite and R > 0:\n' +
        '                steps.append({"title":"Radius of convergence","latex":"R = " + latex(R)})\n' +
        '    except Exception:\n' +
        '        pass\n' +
        '    print("STEPS:" + json.dumps(steps))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))\n';

    fetch(SC_CTX + '/OneCompilerFunctionality?action=execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python', version: '3.10', code: code })
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        var stdout = (data.Stdout || data.stdout || '').trim();
        var stderr = (data.Stderr || data.stderr || '').trim();
        if (stdout.indexOf('ERROR:') === 0) throw new Error(stdout.replace('ERROR:', ''));
        if (!stdout && stderr) throw new Error(stderr.split('\n').pop() || 'Solver error');
        if (!stdout) throw new Error('No result');

        var latexMatch = stdout.match(/LATEX:([^\n]*)/);
        var textMatch = stdout.match(/TEXT:([^\n]*)/);
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?:\n|$)/);
        var resultTeX = latexMatch ? latexMatch[1].trim() : '';
        var resultText = textMatch ? textMatch[1].trim() : resultTeX;
        if (!resultTeX) throw new Error('Could not expand series');

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
                var label = (p.display || p.latex || p.expr || '');
                try { katex.render(label, probEl, { throwOnError: false, displayMode: false }); }
                catch(e) { probEl.textContent = label; }
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
        solveNextSeries(problems, idx + 1);
    });
}
})();
</script>
