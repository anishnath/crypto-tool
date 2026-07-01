<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for limit-calculator.jsp.

    Shared infrastructure (KaTeX / nerdamer / MathLive / image-to-math /
    tool-utils / dark-mode / search / plotly loader) is loaded separately
    by /math/partials/math-tool-engine-boot.inc.jsp + math-input-setup.jsp.

    CAS cores come from math-ai-cores-engine.js (loaded by engine boot).
--%>

<!-- Practice worksheet — shared engine, limit-specific question bank. -->
<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>

<!-- Context for image-scan + Python compiler iframe. -->
<script>window.__LC_CTX='<%=request.getContextPath()%>';</script>

<!-- Main DOM/UI controller. -->
<script src="<%=request.getContextPath()%>/modern/js/limit-calculator.js"></script>

<!-- ─── Image-to-math scanner init — limit-specific prompt ─── -->
    <script>
    // ─── Image to Math: Scan limit problems from image ───
    (function() {
    var LC_CTX = window.__LC_CTX || '';

    ImageToMath.init({
        buttonId: 'lc-image-btn',
        aiUrl: LC_CTX + '/ai',
        toolName: 'Limit Calculator',
        extractionPrompt:
            'You are a math problem extractor for a limit calculator.\n' +
            'Given OCR text from a math image, extract ALL limit problems.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "latex": the function f(x) ONLY in LaTeX (NOT the full limit notation). Examples: "\\frac{\\sin(x)}{x}", "x^{2}-1"\n' +
            '  - "variable": the variable (default "x")\n' +
            '  - "point": the point the variable approaches in LaTeX (e.g. "0", "\\infty", "-\\infty", "\\pi")\n' +
            '  - "direction": "two-sided", "left", or "right"\n' +
            '  - "display": the full limit in LaTeX for display (e.g. "\\lim_{x \\to 0} \\frac{\\sin(x)}{x}")\n\n' +
            'CRITICAL RULES:\n' +
            '- "latex" must be ONLY the function, NOT the \\lim or arrow part.\n' +
            '- Keep LaTeX notation as-is.\n' +
            '- Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
            '- If no problems found, return []\n\n' +
            'Example:\n' +
            'Input: "Find the limit of sin(x)/x as x approaches 0"\n' +
            'Output: [{"latex":"\\\\frac{\\\\sin(x)}{x}","variable":"x","point":"0","direction":"two-sided","display":"\\\\lim_{x \\\\to 0} \\\\frac{\\\\sin(x)}{x}"}]',
        onSelect: function(problem) {
            // Single problem — fill the UI and calculate
            var lc = window.__LC_SCAN__ || {};
            if (lc.fillAndSolve) lc.fillAndSolve(problem);
        },
        onSolveAll: function(problems) {
            batchSolveLimits(problems);
        }
    });

    function batchSolveLimits(problems) {
        var existing = document.getElementById('itm-results-overlay');
        if (existing) existing.remove();

        var ov = document.createElement('div');
        ov.id = 'itm-results-overlay';
        ov.className = 'itm-results-overlay';
        ov.innerHTML =
            '<div class="itm-results-modal">' +
            '  <div class="itm-results-header">' +
            '    <span class="itm-results-title">Solving ' + problems.length + ' Limit' + (problems.length > 1 ? 's' : '') + '</span>' +
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

        var closeResults = function() {
            ov.style.display = 'none';
            document.body.style.overflow = '';
            ov.remove();
        };
        document.getElementById('itm-results-close').addEventListener('click', closeResults);
        document.getElementById('itm-results-done').addEventListener('click', closeResults);
        ov.addEventListener('click', function(e) { if (e.target === ov) closeResults(); });

        var body = document.getElementById('itm-results-body');

        problems.forEach(function(p, i) {
            var display = p.display || p.latex || '';
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

        solveNextLimit(problems, 0);
    }

    function solveNextLimit(problems, idx) {
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
        var ptLatex = p.point || '0';
        var dir = p.direction || 'two-sided';
        var pyLiteral = funcLatex.replace(/"""/g, '\\"\\"\\"');
        var ptPyLiteral = ptLatex.replace(/"""/g, '\\"\\"\\"');

        // Map direction to SymPy's dir argument
        var sympyDir = dir === 'left' ? '"-"' : dir === 'right' ? '"+"' : '"+-"';

        var code =
            'from sympy import *\n' +
            'from sympy.parsing.latex import parse_latex\n' +
            'import json, re, signal\n' +
            'FUNC_LATEX = r"""' + pyLiteral + '"""\n' +
            'PT_LATEX = r"""' + ptPyLiteral + '"""\n' +
            'V = "' + v + '"\n' +
            '# Strip sizing commands\n' +
            'FUNC_LATEX = re.sub(r"\\\\left\\s*([({\\\\[|])", r"\\1", FUNC_LATEX)\n' +
            'FUNC_LATEX = re.sub(r"\\\\right\\s*([)}\\\\]|])", r"\\1", FUNC_LATEX)\n' +
            'FUNC_LATEX = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr)\\s*", "", FUNC_LATEX)\n' +
            'try:\n' +
            '    expr = parse_latex(FUNC_LATEX)\n' +
            'except Exception:\n' +
            '    expr = parse_latex(FUNC_LATEX, backend="lark")\n' +
            'if getattr(expr, "data", None) == "_ambig":\n' +
            '    expr = expr.children[0]\n' +
            '# parse_latex treats e as Symbol; replace with Euler number E\n' +
            'expr = expr.subs(Symbol("e"), E)\n' +
            'try:\n' +
            '    pt = parse_latex(PT_LATEX)\n' +
            'except Exception:\n' +
            '    try:\n' +
            '        pt = parse_latex(PT_LATEX, backend="lark")\n' +
            '    except Exception:\n' +
            '        pt = sympify(PT_LATEX.replace("\\\\infty","oo").replace("\\\\pi","pi"))\n' +
            'var = Symbol(V)\n' +
            'def _timeout(s, f): raise TimeoutError\n' +
            'signal.signal(signal.SIGALRM, _timeout)\n' +
            'signal.alarm(10)\n' +
            'try:\n' +
            '    result = limit(expr, var, pt, dir=' + sympyDir + ')\n' +
            'except (TimeoutError, Exception) as e:\n' +
            '    result = None\n' +
            'finally:\n' +
            '    signal.alarm(0)\n' +
            'if result is None:\n' +
            '    print("ERROR:Could not compute this limit")\n' +
            'else:\n' +
            '    print("LATEX:" + latex(result))\n' +
            '    print("TEXT:" + str(result))\n' +
            '    print("EXPR:" + str(expr).replace("**", "^"))\n' +
            '    # Detect method\n' +
            '    method = "SymPy Solver"\n' +
            '    try:\n' +
            '        direct = expr.subs(var, pt)\n' +
            '        if direct.is_finite:\n' +
            '            method = "Direct Substitution"\n' +
            '        else:\n' +
            '            method = "L\\\'Hopital\\\'s Rule"\n' +
            '    except Exception:\n' +
            '        pass\n' +
            '    print("METHOD:" + method)\n' +
            '    # Steps\n' +
            '    steps = []\n' +
            '    pt_tex = latex(pt)\n' +
            '    arrow = V + " \\\\to " + pt_tex\n' +
            '    expr_tex = latex(expr)\n' +
            '    res_tex = latex(result)\n' +
            '    steps.append({"title":"State the limit","latex":"\\\\lim_{" + arrow + "}\\\\left[" + expr_tex + "\\\\right]"})\n' +
            '    try:\n' +
            '        direct = expr.subs(var, pt)\n' +
            '        if direct.is_finite and not direct.has(zoo, nan, oo, -oo):\n' +
            '            steps.append({"title":"Direct substitution: " + V + " = " + str(pt),"latex":"f(" + pt_tex + ") = " + latex(direct)})\n' +
            '            steps.append({"title":"Result","latex":"\\\\lim_{" + arrow + "}" + expr_tex + " = " + res_tex})\n' +
            '        else:\n' +
            '            form = latex(direct) if direct else "undefined"\n' +
            '            steps.append({"title":"Direct substitution yields indeterminate form","latex":"\\\\text{Form: }" + form})\n' +
            '            numer, denom = expr.as_numer_denom()\n' +
            '            if denom != 1:\n' +
            '                nd = diff(numer, var)\n' +
            '                dd = diff(denom, var)\n' +
            '                steps.append({"title":"Apply L\\\'Hopital\\\'s Rule","latex":"\\\\lim_{" + arrow + "}\\\\frac{" + latex(numer) + "}{" + latex(denom) + "} = \\\\lim_{" + arrow + "}\\\\frac{" + latex(nd) + "}{" + latex(dd) + "}"})\n' +
            '            steps.append({"title":"Result","latex":"\\\\lim_{" + arrow + "}" + expr_tex + " = " + res_tex})\n' +
            '    except Exception:\n' +
            '        steps.append({"title":"Result","latex":"\\\\lim_{" + arrow + "}" + expr_tex + " = " + res_tex})\n' +
            '    print("STEPS:" + json.dumps(steps))\n';

        fetch(LC_CTX + '/OneCompilerFunctionality?action=execute', {
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
            if (!stdout) throw new Error('No result from solver');

            var latexMatch = stdout.match(/LATEX:([^\n]*)/);
            var textMatch = stdout.match(/TEXT:([^\n]*)/);
            var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?:\n|$)/);
            var resultTeX = latexMatch ? latexMatch[1].trim() : '';
            var resultText = textMatch ? textMatch[1].trim() : resultTeX;
            if (!resultTeX && !resultText) throw new Error('Could not compute this limit');

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
                        '<div class="itm-result-step-title">' + (s.title || '').replace(/</g,'&lt;') + '</div>' +
                        '<div id="' + stepId + '" data-step-katex="' + (s.latex || '').replace(/&/g,'&amp;').replace(/"/g,'&quot;') + '"></div></div>';
                });
                html += '</div>';
            }
            bodyEl.innerHTML = html;

            if (window.katex) {
                var probEl = document.getElementById('itm-ri-' + idx);
                var ansEl = document.getElementById('itm-ra-' + idx);
                if (probEl) {
                    var display = p.display || '\\lim_{' + v + ' \\to ' + ptLatex + '} ' + funcLatex;
                    try { katex.render(display, probEl, { throwOnError: false, displayMode: false }); }
                    catch(e) { probEl.textContent = display; }
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
            bodyEl.innerHTML = '<div class="itm-result-error-msg">' + (err.message || 'Error').replace(/</g,'&lt;') + '</div>';
        })
        .finally(function() {
            solveNextLimit(problems, idx + 1);
        });
    }
    })();
    </script>
</body>
