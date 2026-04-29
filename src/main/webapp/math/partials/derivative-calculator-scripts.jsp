<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for derivative-calculator.jsp.

    Shared infrastructure (KaTeX / nerdamer / MathLive / image-to-math /
    tool-utils / dark-mode / search / plotly loader) is loaded separately
    by /math/partials/math-libs.jsp + /math/partials/math-input-setup.jsp
    — include this file BETWEEN them in the tool page.

    Load order inside this partial:
      1. integral-calculator-core.js  — provides normalizeExpr (dep)
      2. derivative-calculator-core.js — thin wrapper on normalizeExpr
      3. worksheet-engine.js          — practice worksheet (may generalise later)
      4. derivative-calculator.js     — main DOM/UI controller (externalised
                                         from the old inline <script> block)
      5. image-to-math init (inline)  — derivative-specific prompt + SymPy wiring
--%>

<!-- Dependency: integral-calculator-core defines normalizeExpr, used by
     DerivativeCalculatorCore.  Must load before derivative-calculator-core.js. -->
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/derivative-calculator-core.js"></script>

<!-- Practice worksheet — shared engine, derivative-specific question bank. -->
<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>

<!-- Main DOM/UI controller. -->
<script src="<%=request.getContextPath()%>/modern/js/derivative-calculator.js"></script>

<!-- ─── Image-to-math scanner init — derivative-specific prompt ─── -->
    <script>
    (function () {
    'use strict';

    var DC_CTX = '<%=request.getContextPath()%>';
    var scan = window.__DC_SCAN__;
    if (!scan || typeof ImageToMath === 'undefined') return;

    ImageToMath.init({
        buttonId: 'dc-image-btn',
        aiUrl: DC_CTX + '/ai',
        toolName: 'Derivative Calculator',
        extractionPrompt:
            'You are a math problem extractor for a derivative calculator.\n' +
            'Given OCR text from a math image, extract ALL differentiation problems.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "latex": the function being differentiated, in LaTeX (ONLY the function f(x), NOT the d/dx operator).\n' +
            '            Examples: "x^{2}", "\\sin(x)", "\\frac{1}{x}", "x e^{x}", "\\sqrt{x^{2}+1}"\n' +
            '  - "variable": the differentiation variable (default "x")\n' +
            '  - "order": derivative order as an integer, 1 to 5 (default 1; "second derivative" → 2, f\'\'\' → 3, etc.)\n' +
            '  - "display": the full problem in LaTeX for display (e.g. "\\frac{d}{dx}\\left[x^{2}\\right]" or "f\'\'(x) \\text{ if } f(x)=\\sin(x)")\n\n' +
            'CRITICAL RULES:\n' +
            '- Extract ONLY the problems to solve, NOT the solutions/answers.\n' +
            '- "latex" must be ONLY the function expression, NOT the d/dx notation. Strip any \\frac{d}{dx}, d^n/dx^n, f\', f\'\', or \\text{d}/\\text{d}x wrapper.\n' +
            '- If an order is shown as f\', return order 1; f\'\' → 2; f\'\'\' → 3; f^{(4)} → 4; etc.\n' +
            '- Keep LaTeX notation as-is: \\frac, \\sin, \\cos, \\sqrt, \\ln, \\pi, \\exp, ^{}, _{}.\n' +
            '- Do NOT convert to calculator format. Return raw LaTeX.\n' +
            '- Return ONLY a valid JSON array, no markdown fences, no explanation.\n' +
            '- If no problems found, return []\n\n' +
            'Example:\n' +
            'Input: "Differentiate: $\\frac{d}{dx}\\left[x^{2}\\right]$ and find $f\'\'(x)$ for $f(x)=\\sin(x)$."\n' +
            'Output: [{"latex":"x^{2}","variable":"x","order":1,"display":"\\\\frac{d}{dx}\\\\left[x^{2}\\\\right]"},{"latex":"\\\\sin(x)","variable":"x","order":2,"display":"f\'\'(x) \\\\text{ if } f(x)=\\\\sin(x)"}]',
        onSelect: function (problem) {
            var latex = problem.latex || problem.expr || '';
            if (!latex) return;
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Parsing expression…', 1500, 'info');
            parseLatexExprViaBackend(latex, function (r) {
                if (!r.ok || !r.expr) {
                    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Could not parse that expression.', 2500, 'warning');
                    return;
                }
                scan.exprInput.value = r.expr;
                if (problem.variable && scan.varSelect.querySelector('option[value="' + problem.variable + '"]')) {
                    scan.varSelect.value = problem.variable;
                }
                var n = parseInt(problem.order, 10);
                if (isFinite(n) && n >= 1 && n <= 5) scan.setOrder(n);
                scan.updatePreview();
                setTimeout(scan.doDifferentiate, 200);
            });
        },
        onSolveAll: function (problems) {
            batchSolveDerivatives(problems);
        }
    });

    // ─── LaTeX → calculator expression via SymPy parse_latex ───
    // Used for the single-pick fill. SymPy is the single source of
    // truth for LaTeX; no client-side regex conversion.
    function parseLatexExprViaBackend(latex, cb) {
        var s = (latex || '').trim();
        if (!s) { cb({ ok: false, error: 'empty' }); return; }
        var pyLiteral = s.replace(/"""/g, '\\"\\"\\"');
        var code =
            'import json\n' +
            'from sympy.parsing.latex import parse_latex\n' +
            'LATEX = r"""' + pyLiteral + '"""\n' +
            'out = {"ok": False}\n' +
            'try:\n' +
            '    parsed = parse_latex(LATEX, backend="lark")\n' +
            '    if getattr(parsed, "data", None) == "_ambig":\n' +
            '        parsed = parsed.children[0]\n' +
            '    parsed = parsed.subs(Symbol("e"), E)\n' +
            '    out = {"ok": True, "expr": str(parsed).replace("**", "^")}\n' +
            'except Exception as e:\n' +
            '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e)}\n' +
            'print("RESULT:" + json.dumps(out))\n';
        fetch(DC_CTX + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var m = stdout.match(/RESULT:(\{[\s\S]*\})/);
            if (!m) { cb({ ok: false, error: 'no backend response' }); return; }
            try { cb(JSON.parse(m[1])); }
            catch (e) { cb({ ok: false, error: 'bad backend JSON' }); }
        })
        .catch(function (err) { cb({ ok: false, error: err.message || 'network error' }); });
    }

    // ─── Batch solve modal ───
    // Mirrors the integral calculator's batch pattern exactly:
    // reuse the itm-results-* CSS from image-to-math.css, solve
    // problems sequentially on the Python backend, render each
    // card as it resolves.
    function batchSolveDerivatives(problems) {
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

        var closeResults = function () {
            ov.style.display = 'none';
            document.body.style.overflow = '';
            ov.remove();
        };
        document.getElementById('itm-results-close').addEventListener('click', closeResults);
        document.getElementById('itm-results-done').addEventListener('click', closeResults);
        ov.addEventListener('click', function (e) { if (e.target === ov) closeResults(); });

        var body = document.getElementById('itm-results-body');

        problems.forEach(function (p, i) {
            var display = p.display || p.latex || p.expr || '';
            var card = document.createElement('div');
            card.className = 'itm-result-card';
            card.id = 'itm-rc-' + i;
            card.innerHTML =
                '<div class="itm-result-card-header">' +
                '  <span class="itm-result-num">' + (i + 1) + '</span>' +
                '  <span class="itm-result-problem" id="itm-rp-' + i + '">' + scan.escapeHtml(display) + '</span>' +
                '  <span class="itm-result-status pending" id="itm-rs-' + i + '">Pending</span>' +
                '</div>' +
                '<div class="itm-result-card-body" id="itm-rb-' + i + '"></div>';
            body.appendChild(card);

            if (window.katex) {
                try { katex.render(display, document.getElementById('itm-rp-' + i), { throwOnError: false, displayMode: false }); }
                catch (e) { /* fall back to text */ }
            }
        });

        solveNextDerivative(problems, 0);
    }

    function solveNextDerivative(problems, idx) {
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

        var funcLatex = p.latex || p.expr || '';
        var v = (p.variable || 'x').trim() || 'x';
        var n = parseInt(p.order, 10); if (!(n >= 1 && n <= 5)) n = 1;
        var pyLiteral = funcLatex.replace(/"""/g, '\\"\\"\\"');

        var code =
            'from sympy import *\n' +
            'from sympy.parsing.latex import parse_latex\n' +
            'import json, signal\n' +
            'import re\n' +
            'LATEX = r"""' + pyLiteral + '"""\n' +
            'V = ' + JSON.stringify(v) + '\n' +
            'N = ' + n + '\n' +
            '# Strip sizing commands parse_latex cannot handle\n' +
            'LATEX = re.sub(r"\\\\left\\s*([({\\\\[|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\right\\s*([)}\\\\]|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr)\\s*", "", LATEX)\n' +
            'try:\n' +
            '    parsed = parse_latex(LATEX)\n' +
            'except Exception:\n' +
            '    parsed = parse_latex(LATEX, backend="lark")\n' +
            'if getattr(parsed, "data", None) == "_ambig":\n' +
            '    parsed = parsed.children[0]\n' +
            '# parse_latex treats e as Symbol; replace with Euler number E\n' +
            'parsed = parsed.subs(Symbol("e"), E)\n' +
            'var = Symbol(V)\n' +
            'def _timeout(s, f): raise TimeoutError\n' +
            'signal.signal(signal.SIGALRM, _timeout)\n' +
            'signal.alarm(10)\n' +
            'try:\n' +
            '    result = diff(parsed, var, N)\n' +
            '    try:\n' +
            '        result = simplify(result)\n' +
            '    except Exception:\n' +
            '        pass\n' +
            'finally:\n' +
            '    signal.alarm(0)\n' +
            'print("LATEX:" + latex(result))\n' +
            'print("TEXT:" + str(result))\n' +
            '# Return expression in calculator-friendly form (** → ^)\n' +
            'print("EXPR:" + str(parsed).replace("**", "^"))\n';

        fetch(DC_CTX + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();
            if (!stdout && stderr) throw new Error(stderr.split('\n').pop() || 'Solver error');
            if (!stdout) throw new Error('No result from solver');

            var latexMatch = stdout.match(/LATEX:([^\n]*)/);
            var textMatch = stdout.match(/TEXT:([^\n]*)/);
            var exprMatch = stdout.match(/EXPR:([^\n]*)/);
            var resultTeX = latexMatch ? latexMatch[1].trim() : '';
            var resultText = textMatch ? textMatch[1].trim() : resultTeX;
            var exprCalc = exprMatch ? exprMatch[1].trim() : '';
            if (!resultTeX && !resultText) throw new Error('Could not solve this derivative');

            // Normalize SymPy LaTeX for KaTeX (\\cmd → \cmd)
            var resultTeXNorm = resultTeX.replace(/\\\\/g, '\\');

            // Generate steps client-side using the same engine as the main UI
            var dc = window.__DC_SCAN__ || {};
            var _identifyDiffMethod = dc.identifyDiffMethod || function() { return 'Differentiation'; };
            var _generateDiffSteps = dc.generateDiffSteps || function() { return null; };
            var _exprToLatex = dc.exprToLatex || function(e) { return e; };
            var method = _identifyDiffMethod(exprCalc || funcLatex);
            var steps = _generateDiffSteps(exprCalc, v, resultTeXNorm, method) || [];

            // If client-side steps failed, show at least a basic step
            if (!steps.length) {
                steps = [{
                    title: 'Differentiate with respect to ' + v,
                    latex: '\\frac{d}{d' + v + '}\\left[' + _exprToLatex(exprCalc || funcLatex) + '\\right] = ' + resultTeXNorm
                }];
            }

            var html = '';
            html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
            html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';

            if (steps.length) {
                html += '<button class="itm-result-steps-btn" data-steps-idx="' + idx + '">Show Steps</button>';
                html += '<div class="itm-result-steps-area" id="itm-rsa-' + idx + '">';
                steps.forEach(function (s) {
                    var stepId = 'itm-rst-' + idx + '-' + Math.random().toString(36).substr(2, 5);
                    html += '<div class="itm-result-step">' +
                            '  <div class="itm-result-step-title">' + scan.escapeHtml(s.title) + '</div>' +
                            '  <div id="' + stepId + '" data-step-katex="' + scan.escapeHtml(s.latex).replace(/"/g, '&quot;') + '"></div>' +
                            '</div>';
                });
                html += '</div>';
            }
            bodyEl.innerHTML = html;

            if (window.katex) {
                var integralEl = document.getElementById('itm-ri-' + idx);
                var answerEl = document.getElementById('itm-ra-' + idx);
                if (integralEl) {
                    try {
                        var display = p.display;
                        if (!display) {
                            var notation = (n === 1)
                                ? '\\frac{d}{d' + v + '}'
                                : '\\frac{d^{' + n + '}}{d' + v + '^{' + n + '}}';
                            display = notation + '\\left[' + funcLatex + '\\right]';
                        }
                        katex.render(display, integralEl, { throwOnError: false, displayMode: false });
                    } catch (e) { integralEl.textContent = funcLatex; }
                }
                if (answerEl) {
                    try { katex.render('= ' + resultTeXNorm, answerEl, { throwOnError: false, displayMode: true }); }
                    catch (e) { answerEl.textContent = '= ' + resultText; }
                }
                // Steps are already in single-backslash KaTeX-ready format from generateDiffSteps
                bodyEl.querySelectorAll('[data-step-katex]').forEach(function (el) {
                    var raw = el.getAttribute('data-step-katex');
                    try { katex.render(raw, el, { throwOnError: false, displayMode: true }); }
                    catch (e) { el.textContent = raw; }
                });
            }

            var stepsBtn = bodyEl.querySelector('[data-steps-idx="' + idx + '"]');
            if (stepsBtn) {
                stepsBtn.addEventListener('click', function () {
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
        .catch(function (err) {
            card.className = 'itm-result-card error';
            status.className = 'itm-result-status fail';
            status.textContent = 'Failed';
            bodyEl.innerHTML = '<div class="itm-result-error-msg">' + scan.escapeHtml(err.message) + '</div>';
        })
        .finally(function () {
            solveNextDerivative(problems, idx + 1);
        });
    }
    })();
    </script>
