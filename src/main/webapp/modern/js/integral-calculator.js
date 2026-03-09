/**
 * Integral Calculator - DOM/UI logic
 * Requires: IntegralCalculatorCore (integral-calculator-core.js), nerdamer, KaTeX
 * Context path: set window.INTEGRAL_CALC_CTX before load (e.g. from JSP)
 */
(function() {
    'use strict';

        var normalizeExpr = IntegralCalculatorCore.normalizeExpr;
        var checkNonElementaryIntegral = IntegralCalculatorCore.checkNonElementaryIntegral;
        var evalBound = function(s) { return IntegralCalculatorCore.evalBound(s, nerdamer); };

        // ========== DOM References ==========
        var exprInput    = document.getElementById('ic-expr');
        var previewEl    = document.getElementById('ic-preview');
        var varSelect    = document.getElementById('ic-var');
        var boundsWrap   = document.getElementById('ic-bounds');
        var lowerInput   = document.getElementById('ic-lower');
        var upperInput   = document.getElementById('ic-upper');
        var integrateBtn = document.getElementById('ic-integrate-btn');
        var resultContent = document.getElementById('ic-result-content');
        var resultActions = document.getElementById('ic-result-actions');
        var emptyState   = document.getElementById('ic-empty-state');
        var graphHint    = document.getElementById('ic-graph-hint');

        var currentMode = 'indefinite';
        var lastResultLatex = '';
        var lastResultText = '';
        var compilerLoaded = false;
        var pendingGraph = null;

        // ========== Autocomplete ==========
        var acEl = document.getElementById('ic-autocomplete');
        var acIdx = -1;
        var acVisible = false;
        var acSuggestions = [
            // Power
            { expr: 'x^2', display: 'x^2', cat: 'Power' },
            { expr: 'x^3', display: 'x^3', cat: 'Power' },
            { expr: 'x^(-2)', display: 'x^(-2)', cat: 'Power' },
            { expr: 'sqrt(x)', display: 'sqrt(x)', cat: 'Power' },
            { expr: '1/sqrt(x)', display: '1/sqrt(x)', cat: 'Power' },
            { expr: '(x^2+1)^2', display: '(x\u00B2+1)\u00B2', cat: 'Power' },
            { expr: '(2*x+3)^3', display: '(2x+3)\u00B3', cat: 'Power' },
            { expr: 'x^(3/2)', display: 'x^(3/2)', cat: 'Power' },
            // Trig
            { expr: 'sin(x)', display: 'sin(x)', cat: 'Trig' },
            { expr: 'cos(x)', display: 'cos(x)', cat: 'Trig' },
            { expr: 'tan(x)', display: 'tan(x)', cat: 'Trig' },
            { expr: 'sec(x)^2', display: 'sec\u00B2(x)', cat: 'Trig' },
            { expr: 'csc(x)^2', display: 'csc\u00B2(x)', cat: 'Trig' },
            { expr: 'sin(2*x)', display: 'sin(2x)', cat: 'Trig' },
            { expr: 'sin(3*x)', display: 'sin(3x)', cat: 'Trig' },
            { expr: 'cos(5*x)', display: 'cos(5x)', cat: 'Trig' },
            { expr: 'sin(x)^2', display: 'sin\u00B2(x)', cat: 'Trig' },
            { expr: 'cos(x)^2', display: 'cos\u00B2(x)', cat: 'Trig' },
            { expr: 'sec(x)*tan(x)', display: 'sec(x)\u00B7tan(x)', cat: 'Trig' },
            { expr: 'sin(x)*cos(x)', display: 'sin(x)\u00B7cos(x)', cat: 'Trig' },
            { expr: 'sin(3*x)+cos(2*x)', display: 'sin(3x)+cos(2x)', cat: 'Trig' },
            { expr: 'sin(x)^3', display: 'sin\u00B3(x)', cat: 'Trig' },
            { expr: 'tan(x)^2', display: 'tan\u00B2(x)', cat: 'Trig' },
            { expr: 'sin(x)^2*cos(x)', display: 'sin\u00B2(x)\u00B7cos(x)', cat: 'Trig' },
            { expr: 'sin(x)^4', display: 'sin\u2074(x)', cat: 'Trig' },
            // Exponential
            { expr: 'e^x', display: 'e^x', cat: 'Exp' },
            { expr: 'e^(-x)', display: 'e^(-x)', cat: 'Exp' },
            { expr: 'e^(2*x)', display: 'e^(2x)', cat: 'Exp' },
            { expr: 'x^2*e^(-x^2)', display: 'x\u00B2\u00B7e^(-x\u00B2)', cat: 'Exp' },
            { expr: 'e^(x)*x^3', display: 'e^x\u00B7x\u00B3', cat: 'Exp' },
            // Log
            { expr: 'log(x)', display: 'ln(x)', cat: 'Log' },
            { expr: '1/x', display: '1/x', cat: 'Log' },
            { expr: 'log(x)/x', display: 'ln(x)/x', cat: 'Log' },
            { expr: 'log(x)^2', display: 'ln\u00B2(x)', cat: 'Log' },
            { expr: 'x*log(x)', display: 'x\u00B7ln(x)', cat: 'Log' },
            { expr: 'log(x^2+1)', display: 'ln(x\u00B2+1)', cat: 'Log' },
            // Hyperbolic
            { expr: 'sinh(x)', display: 'sinh(x)', cat: 'Hyp' },
            { expr: 'cosh(x)', display: 'cosh(x)', cat: 'Hyp' },
            { expr: 'tanh(x)', display: 'tanh(x)', cat: 'Hyp' },
            { expr: 'sinh(x)^2', display: 'sinh\u00B2(x)', cat: 'Hyp' },
            { expr: 'x*cosh(x)', display: 'x\u00B7cosh(x)', cat: 'Hyp' },
            // Inverse Trig
            { expr: '1/(x^2+1)', display: '1/(x\u00B2+1)', cat: 'Inv Trig' },
            { expr: '1/sqrt(1-x^2)', display: '1/\u221A(1-x\u00B2)', cat: 'Inv Trig' },
            { expr: 'asin(x)', display: 'arcsin(x)', cat: 'Inv Trig' },
            { expr: 'acos(x)', display: 'arccos(x)', cat: 'Inv Trig' },
            { expr: 'atan(x)', display: 'arctan(x)', cat: 'Inv Trig' },
            { expr: 'x*atan(x)', display: 'x\u00B7arctan(x)', cat: 'Inv Trig' },
            // By Parts
            { expr: 'x*e^x', display: 'x\u00B7e^x', cat: 'Parts' },
            { expr: 'x*sin(x)', display: 'x\u00B7sin(x)', cat: 'Parts' },
            { expr: 'x*cos(x)', display: 'x\u00B7cos(x)', cat: 'Parts' },
            { expr: 'x^2*e^x', display: 'x\u00B2\u00B7e^x', cat: 'Parts' },
            { expr: 'x^2*log(x)', display: 'x\u00B2\u00B7ln(x)', cat: 'Parts' },
            { expr: 'x*e^(-x)', display: 'x\u00B7e^(-x)', cat: 'Parts' },
            { expr: 'e^x*sin(x)', display: 'e^x\u00B7sin(x)', cat: 'Parts' },
            { expr: 'e^x*cos(x)', display: 'e^x\u00B7cos(x)', cat: 'Parts' },
            { expr: 'x^3*e^x', display: 'x\u00B3\u00B7e^x', cat: 'Parts' },
            { expr: 'x^2*sin(x)', display: 'x\u00B2\u00B7sin(x)', cat: 'Parts' },
            { expr: 'x^2*cos(x)', display: 'x\u00B2\u00B7cos(x)', cat: 'Parts' },
            { expr: 'log(x)^2', display: 'ln\u00B2(x)', cat: 'Parts' },
            { expr: 'e^x*sin(x)*cos(x)', display: 'e^x\u00B7sin(x)\u00B7cos(x)', cat: 'Parts' },
            // Rational / Partial Fractions
            { expr: '1/(x^2-1)', display: '1/(x\u00B2-1)', cat: 'Rational' },
            { expr: 'x/(x^2+1)', display: 'x/(x\u00B2+1)', cat: 'Rational' },
            { expr: 'x/sqrt(x^2+1)', display: 'x/\u221A(x\u00B2+1)', cat: 'Rational' },
            { expr: '1/(x^3+1)', display: '1/(x\u00B3+1)', cat: 'Rational' },
            { expr: '1/(x^2+2*x+1)', display: '1/(x\u00B2+2x+1)', cat: 'Rational' },
            { expr: 'x^2/(x^2+1)', display: 'x\u00B2/(x\u00B2+1)', cat: 'Rational' },
            { expr: '(2*x+3)/(x^2+3*x+2)', display: '(2x+3)/(x\u00B2+3x+2)', cat: 'Rational' },
            { expr: '1/(x*(x+1))', display: '1/(x(x+1))', cat: 'Rational' },
            { expr: '1/sqrt(x^2+1)', display: '1/\u221A(x\u00B2+1)', cat: 'Rational' },
            // Polynomial
            { expr: '3*x^2+2*x-5', display: '3x\u00B2+2x-5', cat: 'Poly' },
            { expr: 'x^2+3*x', display: 'x\u00B2+3x', cat: 'Poly' },
            { expr: 'x^4-3*x^2+2', display: 'x\u2074-3x\u00B2+2', cat: 'Poly' },
            { expr: '5*x^3-2*x^2+x-7', display: '5x\u00B3-2x\u00B2+x-7', cat: 'Poly' },
            // Substitution
            { expr: '2*x*cos(x^2)', display: '2x\u00B7cos(x\u00B2)', cat: 'U-Sub' },
            { expr: 'e^(sin(x))*cos(x)', display: 'e^sin(x)\u00B7cos(x)', cat: 'U-Sub' },
            { expr: 'x/sqrt(1-x^2)', display: 'x/\u221A(1-x\u00B2)', cat: 'U-Sub' },
            { expr: 'sin(x)/cos(x)^2', display: 'sin(x)/cos\u00B2(x)', cat: 'U-Sub' },
            { expr: 'x*sqrt(x^2+1)', display: 'x\u00B7\u221A(x\u00B2+1)', cat: 'U-Sub' },
            { expr: '1/(x*log(x))', display: '1/(x\u00B7ln(x))', cat: 'U-Sub' },
            // Trig Substitution
            { expr: 'sqrt(1-x^2)', display: '\u221A(1-x\u00B2)', cat: 'Trig Sub' },
            { expr: 'sqrt(x^2+1)', display: '\u221A(x\u00B2+1)', cat: 'Trig Sub' },
            { expr: 'sqrt(x^2-1)', display: '\u221A(x\u00B2-1)', cat: 'Trig Sub' },
            { expr: '1/(x^2+1)^(3/2)', display: '1/(x\u00B2+1)^(3/2)', cat: 'Trig Sub' },
            // Definite - Basic
            { expr: 'x**2, (x, 0, 1)', display: 'x\u00B2 from 0 to 1', cat: 'Definite' },
            { expr: 'sin(x), (x, 0, pi)', display: 'sin(x) from 0 to \u03C0', cat: 'Definite' },
            { expr: 'exp(x), (x, 0, 1)', display: 'e^x from 0 to 1', cat: 'Definite' },
            { expr: '1/x, (x, 1, E)', display: '1/x from 1 to e', cat: 'Definite' },
            { expr: 'cos(x), (x, 0, pi/2)', display: 'cos(x) from 0 to \u03C0/2', cat: 'Definite' },
            { expr: 'e^(-x), (x, 0, oo)', display: 'e^(-x) from 0 to \u221E', cat: 'Definite' },
            { expr: '1/(x^2+1), (x, 0, 1)', display: '1/(x\u00B2+1) from 0 to 1', cat: 'Definite' },
            { expr: 'x*e^x, (x, 0, 1)', display: 'x\u00B7e^x from 0 to 1', cat: 'Definite' },
            // Definite - Complex
            { expr: 'sin(x)**2, (x, 0, pi)', display: 'sin\u00B2(x) from 0 to \u03C0', cat: 'Definite' },
            { expr: 'x**3, (x, -1, 1)', display: 'x\u00B3 from -1 to 1', cat: 'Definite' },
            { expr: '3*x**2+2*x, (x, 0, 1)', display: '3x\u00B2+2x from 0 to 1', cat: 'Definite' },
            { expr: 'sqrt(x), (x, 0, 1)', display: '\u221Ax from 0 to 1', cat: 'Definite' },
            { expr: 'x**2*exp(-x), (x, 0, oo)', display: 'x\u00B2\u00B7e^(-x) from 0 to \u221E', cat: 'Definite' },
            { expr: '1/sqrt(1-x**2), (x, 0, 1/2)', display: '1/\u221A(1-x\u00B2) from 0 to 1/2', cat: 'Definite' },
            { expr: 'x*sin(x), (x, 0, pi)', display: 'x\u00B7sin(x) from 0 to \u03C0', cat: 'Definite' },
            { expr: 'sin(x)*cos(x), (x, 0, pi/2)', display: 'sin(x)\u00B7cos(x) from 0 to \u03C0/2', cat: 'Definite' },
            { expr: 'x/(x**2+1), (x, 0, 1)', display: 'x/(x\u00B2+1) from 0 to 1', cat: 'Definite' },
            { expr: 'exp(-x**2), (x, 0, oo)', display: 'e^(-x\u00B2) from 0 to \u221E (Gaussian)', cat: 'Definite' },
            { expr: '1/(1+x**2), (x, -oo, oo)', display: '1/(1+x\u00B2) from -\u221E to \u221E', cat: 'Definite' },
            { expr: 'log(x), (x, 1, E)', display: 'ln(x) from 1 to e', cat: 'Definite' },
            { expr: 'x**2*sin(x), (x, 0, pi)', display: 'x\u00B2\u00B7sin(x) from 0 to \u03C0', cat: 'Definite' }
        ];

        function acFilter(query) {
            if (!query) return [];
            var q = query.toLowerCase();
            var matches = [];
            for (var i = 0; i < acSuggestions.length; i++) {
                var s = acSuggestions[i];
                if (s.expr.toLowerCase().indexOf(q) !== -1 || s.display.toLowerCase().indexOf(q) !== -1) {
                    matches.push(s);
                    if (matches.length >= 10) break;
                }
            }
            return matches;
        }

        function acRender(matches) {
            if (!matches.length) { acClose(); return; }
            var html = '';
            for (var i = 0; i < matches.length; i++) {
                html += '<div class="ic-autocomplete-item' + (i === acIdx ? ' selected' : '') + '" data-idx="' + i + '">'
                    + '<span>' + escapeHtml(matches[i].display) + '</span>'
                    + '<span class="ic-autocomplete-cat">' + escapeHtml(matches[i].cat) + '</span>'
                    + '</div>';
            }
            acEl.innerHTML = html;
            acEl.classList.add('active');
            acVisible = true;
        }

        function acClose() {
            acEl.classList.remove('active');
            acEl.innerHTML = '';
            acIdx = -1;
            acVisible = false;
        }

        function acSelect(item) {
            exprInput.value = item.expr;
            acClose();
            updatePreview();
            exprInput.focus();
        }

        // Delegated click on autocomplete items
        acEl.addEventListener('mousedown', function(e) {
            // Use mousedown instead of click so it fires before blur
            var el = e.target.closest('.ic-autocomplete-item');
            if (!el) return;
            e.preventDefault();
            var idx = parseInt(el.getAttribute('data-idx'), 10);
            var matches = acFilter(exprInput.value.trim());
            if (matches[idx]) acSelect(matches[idx]);
        });

        // Close on blur (small delay for mousedown to register)
        exprInput.addEventListener('blur', function() {
            setTimeout(acClose, 150);
        });

        // Keyboard navigation
        exprInput.addEventListener('keydown', function(e) {
            if (!acVisible) return;
            var matches = acFilter(exprInput.value.trim());
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                acIdx = (acIdx + 1) % matches.length;
                acRender(matches);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                acIdx = acIdx <= 0 ? matches.length - 1 : acIdx - 1;
                acRender(matches);
            } else if (e.key === 'Enter' && acIdx >= 0) {
                e.preventDefault();
                e.stopImmediatePropagation();
                if (matches[acIdx]) acSelect(matches[acIdx]);
            } else if (e.key === 'Escape') {
                e.preventDefault();
                acClose();
            }
        });

        // ========== FAQ ==========
        window.toggleFaq = function(btn) {
            btn.parentElement.classList.toggle('open');
        };
        /** Convert nerdamer-style expr to Python/SymPy (e.g. e^x -> exp(x), ^ -> **) */
        function nerdamerToPython(expr) {
            var py = (expr || '')
                .replace(/e\^(\([^)]+\))/g, 'exp$1')
                .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
                .replace(/\^/g, '**')
                // Convert integer fractions in exponents to Rational: **(3/2) → **(Rational(3,2))
                .replace(/\*\*\((\d+)\/(\d+)\)/g, '**(Rational($1,$2))')
                // Insert * between digit and variable: 3x → 3*x, 2pi → 2*pi
                .replace(/(\d)([a-zA-Z])/g, '$1*$2')
                // Insert * between closing paren and opening paren or variable: )(  )x
                .replace(/\)(\()/g, ')*$1')
                .replace(/\)([a-zA-Z])/g, ')*$1');
            return py;
        }

        /** Extract symbols in pyExpr that are not the integration variable. */
        function getExtraSymbols(pyExpr, v) {
            var KNOWN = ['exp','log','sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','coth','csch','sech','sqrt','asin','acos','atan','pi'];
            var seen = {};
            var re = /\b([a-z][a-z]*)\b/g;
            var m;
            while ((m = re.exec(pyExpr)) !== null) {
                var w = m[1];
                if (KNOWN.indexOf(w) >= 0) continue;
                if (w === v) continue;
                seen[w] = true;
            }
            return Object.keys(seen).sort();
        }

        function buildSympySymbolsDecl(v, pyExpr) {
            var extra = getExtraSymbols(pyExpr, v);
            var all = extra.length > 0 ? extra.concat(v) : [v];
            var opts = (extra.length > 0) ? ", positive=True" : "";
            return all.join(', ') + " = symbols('" + all.join(' ') + "'" + opts + ")";
        }

        var ruleDisplayNames = { PartsRule: 'Integration by parts', ExpRule: 'Exponential', URule: 'u-Substitution', RewriteRule: 'Rewrite', ReciprocalRule: 'Reciprocal', ArctanRule: 'Arctan', PowerRule: 'Power rule', AddRule: 'Sum rule', ConstantTimesRule: 'Constant factor', AlternativeRule: 'Alternative', ConstantRule: 'Constant', Other: 'Other' };

        /** Client-side: parse RULES string, build paths, decide tabs. */
        function parseSympyOutput(expr, v, resultLatex, rulesStr, exprLatex) {
            var rules = (rulesStr.match(/\w+Rule/g) || []).filter(function(r, i, a) { return a.indexOf(r) === i; });
            var integrand = (exprLatex || expr.replace(/\*/g, '\\cdot ') || 'f(x)');
            var stepLatex = '\\int ' + integrand + '\\,d' + v + ' = ' + resultLatex + ' + C';
            var step = { title: 'Result', latex: stepLatex, rule: rules[0] || 'Other' };
            var paths = [];
            var altMatch = rulesStr.match(/alternatives=\[([^\]]*(?:\([^)]*\)[^\]]*)*)\]/);
            if (altMatch) {
                var altBlock = altMatch[1];
                var altStarts = [];
                var depth = 0;
                for (var j = 0; j < altBlock.length; j++) {
                    var c = altBlock[j];
                    if (c === '(') { if (depth === 0) altStarts.push(j); depth++; }
                    else if (c === ')') depth--;
                }
                var firstRules = [];
                altStarts.forEach(function(start) {
                    var sub = altBlock.substring(start);
                    var m = sub.match(/^(\w+)Rule/);
                    if (m) firstRules.push(m[1] + 'Rule');
                });
                if (firstRules.length > 1) {
                    firstRules.forEach(function(rn, idx) {
                        paths.push({ name: 'Method ' + (idx + 1) + ': ' + (ruleDisplayNames[rn] || rn), steps: [step], rules: [rn] });
                    });
                }
            }
            if (paths.length === 0) {
                paths = [{ name: 'Solution', steps: [step], rules: rules }];
            }
            return { paths: paths };
        }

        // ========== Mode Toggle ==========
        var modeBtns = document.querySelectorAll('.ic-mode-btn');
        modeBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                var mode = this.getAttribute('data-mode');
                if (mode === currentMode) return;
                currentMode = mode;
                modeBtns.forEach(function(b) { b.classList.remove('active'); });
                this.classList.add('active');
                if (mode === 'definite') {
                    boundsWrap.classList.add('visible');
                } else {
                    boundsWrap.classList.remove('visible');
                }
                updatePreview();
            });
        });

        // ========== Output Tabs ==========
        var tabBtns = document.querySelectorAll('.ic-output-tab');
        var panels  = document.querySelectorAll('.ic-panel');
        tabBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                var panel = this.getAttribute('data-panel');
                tabBtns.forEach(function(b) { b.classList.remove('active'); });
                panels.forEach(function(p) { p.classList.remove('active'); });
                this.classList.add('active');
                document.getElementById('ic-panel-' + panel).classList.add('active');

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
        var syntaxBtn = document.getElementById('ic-syntax-btn');
        var syntaxContent = document.getElementById('ic-syntax-content');
        syntaxBtn.addEventListener('click', function() {
            syntaxContent.classList.toggle('open');
            var chevron = syntaxBtn.querySelector('.ic-syntax-chevron');
            if (syntaxContent.classList.contains('open')) {
                chevron.style.transform = 'rotate(180deg)';
            } else {
                chevron.style.transform = '';
            }
        });

        // ========== Quick Examples ==========
        document.getElementById('ic-examples').addEventListener('click', function(e) {
            var chip = e.target.closest('.ic-example-chip');
            if (!chip) return;
            exprInput.value = chip.getAttribute('data-expr');
            updatePreview();
            exprInput.focus();
        });

        // ========== Live Preview ==========
        /** Parse SymPy-style input: "integrand, (var, a, b)" → { integrand, var, a, b } */
        function parseSympyStyleInput(raw) {
            if (!raw || typeof raw !== 'string') return null;
            var m = raw.match(/^(.+),\s*\(\s*(\w+)\s*,\s*([^,)]+)\s*,\s*([^)]+)\s*\)\s*$/);
            if (!m) return null;
            return { integrand: m[1].trim(), var: m[2], a: m[3].trim(), b: m[4].trim() };
        }

        /** Convert SymPy-style integrand to calculator form: ** → ^ for nerdamer */
        function integrandForNerdamer(s) {
            return (s || '').replace(/\*\*/g, '^');
        }

        var previewTimer = null;
        exprInput.addEventListener('input', function() {
            clearTimeout(previewTimer);
            previewTimer = setTimeout(updatePreview, 200);
            // Autocomplete
            var q = exprInput.value.trim();
            if (q.length > 0) {
                acIdx = -1;
                var matches = acFilter(q);
                acRender(matches);
            } else {
                acClose();
            }
        });
        varSelect.addEventListener('change', updatePreview);

        function updatePreview() {
            var rawExpr = exprInput.value.trim();
            var v = varSelect.value;
            if (!rawExpr) {
                previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above\u2026</span>';
                return;
            }
            var parsed = parseSympyStyleInput(rawExpr);
            var expr = parsed ? integrandForNerdamer(parsed.integrand) : rawExpr;
            var a, b;
            if (parsed) {
                v = parsed.var;
                a = parsed.a;
                b = parsed.b;
            } else {
                a = lowerInput.value.trim() || 'a';
                b = upperInput.value.trim() || 'b';
            }
            try {
                var normalized = normalizeExpr(expr);
                var latex = exprToLatex(normalized);
                var integralLatex;
                if (currentMode === 'definite' || parsed) {
                    a = parsed ? parsed.a : (lowerInput.value.trim() || 'a');
                    b = parsed ? parsed.b : (upperInput.value.trim() || 'b');
                    integralLatex = '\\int_{' + boundToLatex(a) + '}^{' + boundToLatex(b) + '} ' + latex + ' \\, d' + v;
                } else {
                    integralLatex = '\\int ' + latex + ' \\, d' + v;
                }
                katex.render(integralLatex, previewEl, { displayMode: true, throwOnError: false });
            } catch (e) {
                previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
            }
        }

        lowerInput.addEventListener('input', function() { clearTimeout(previewTimer); previewTimer = setTimeout(updatePreview, 200); });
        upperInput.addEventListener('input', function() { clearTimeout(previewTimer); previewTimer = setTimeout(updatePreview, 200); });

        function exprToLatex(expr) {
            try {
                var parsed = nerdamer(expr);
                return parsed.toTeX();
            } catch (e) {
                // Fallback: basic manual conversion
                return expr
                    .replace(/\*/g, ' \\cdot ')
                    .replace(/sqrt\(/g, '\\sqrt{').replace(/\)/g, '}')
                    .replace(/\^(\w)/g, '^{$1}');
            }
        }

        function boundToLatex(s) {
            return s.replace(/\u221e/g, '\\infty')                      // ∞
                .replace(/\u03c0/g, '\\pi')                          // π
                .replace(/\u2212/g, '-')                              // − (Unicode minus)
                .replace(/\u2080/g, '0').replace(/\u2081/g, '1')    // ₀ ₁
                .replace(/\u2082/g, '2').replace(/\u2083/g, '3')    // ₂ ₃
                .replace(/\u2084/g, '4').replace(/\u2085/g, '5')    // ₄ ₅
                .replace(/\u2086/g, '6').replace(/\u2087/g, '7')    // ₆ ₇
                .replace(/\u2088/g, '8').replace(/\u2089/g, '9')    // ₈ ₉
                .replace(/\binfinity\b/gi, '\\infty')
                .replace(/\binf\b/gi, '\\infty')
                .replace(/\boo\b/g, '\\infty')
                .replace(/\bpi\b/gi, '\\pi');
        }

        // ========== Precomputed Integrals (bypass nerdamer + SymPy for unsupported / slow cases) ==========
        var PRECOMPUTED_INTEGRALS = {
            'coth(x)': {
                resultTeX: 'x - \\log{\\left(\\tanh{\\left(x \\right)} + 1 \\right)} + \\log{\\left(\\tanh{\\left(x \\right)} \\right)}',
                resultText: 'x - log(tanh(x) + 1) + log(tanh(x))',
                method: 'Rewrite + u-Substitution',
                rulesStr: 'RewriteRule(integrand=coth(x), variable=x, rewritten=cosh(x)/sinh(x), substep=URule)',
                exprTeX: '\\coth{\\left(x \\right)}',
                steps: [
                    { title: 'Rewrite coth(x)', latex: '\\coth(x) = \\frac{\\cosh(x)}{\\sinh(x)}' },
                    { title: 'Substitute u = sinh(x), du = cosh(x) dx', latex: '\\int \\frac{\\cosh(x)}{\\sinh(x)} \\, dx = \\int \\frac{1}{u} \\, du = \\ln|u| + C' },
                    { title: 'Back-substitute', latex: '= \\ln|\\sinh(x)| + C' }
                ]
            },
            'csch(x)': {
                resultTeX: '\\log{\\left(\\tanh{\\left(\\frac{x}{2} \\right)} \\right)}',
                resultText: 'log(tanh(x/2))',
                method: 'Rewrite + u-Substitution',
                rulesStr: 'RewriteRule(integrand=csch(x), variable=x, rewritten=(1 - tanh(x/2)**2)/(2*tanh(x/2)), substep=URule)',
                exprTeX: '\\operatorname{csch}{\\left(x \\right)}',
                steps: [
                    { title: 'Rewrite using half-angle', latex: '\\operatorname{csch}(x) = \\frac{1 - \\tanh^2(x/2)}{2\\tanh(x/2)}' },
                    { title: 'Substitute u = tanh(x/2)', latex: '\\int \\frac{1}{u} \\, du = \\ln|u| + C' },
                    { title: 'Back-substitute', latex: '= \\ln|\\tanh(x/2)| + C' }
                ]
            },
            'sech(x)': {
                resultTeX: '2 \\operatorname{atan}{\\left(\\tanh{\\left(\\frac{x}{2} \\right)} \\right)}',
                resultText: '2*atan(tanh(x/2))',
                method: 'Rewrite + u-Substitution',
                rulesStr: 'RewriteRule(integrand=sech(x), variable=x, rewritten=(1 - tanh(x/2)**2)/(tanh(x/2)**2 + 1), substep=URule)',
                exprTeX: '\\operatorname{sech}{\\left(x \\right)}',
                steps: [
                    { title: 'Rewrite using half-angle', latex: '\\operatorname{sech}(x) = \\frac{1 - \\tanh^2(x/2)}{\\tanh^2(x/2) + 1}' },
                    { title: 'Substitute u = tanh(x/2)', latex: '\\int \\frac{2}{u^2 + 1} \\, du = 2\\arctan(u) + C' },
                    { title: 'Back-substitute', latex: '= 2\\arctan(\\tanh(x/2)) + C' }
                ]
            }
        };

        /**
         * Look up a precomputed integral. Returns null if not found.
         * Normalizes the variable: coth(t) matches the coth(x) entry.
         */
        function lookupPrecomputed(expr, v) {
            var key = expr.replace(new RegExp('\\b' + v + '\\b', 'g'), 'x');
            return PRECOMPUTED_INTEGRALS[key] || null;
        }

        /**
         * Substitute the actual variable back into precomputed LaTeX / text.
         */
        function substituteVar(s, v) {
            if (v === 'x') return s;
            return s.replace(/\bx\b/g, v).replace(/\\left\(x/g, '\\left(' + v);
        }

        // ========== Integration ==========
        integrateBtn.addEventListener('click', doIntegrate);
        exprInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') doIntegrate();
        });

        function doIntegrate() {
            var rawExpr = exprInput.value.trim();
            var parsed = parseSympyStyleInput(rawExpr);
            var expr, v, useDefinite, a, b;
            if (parsed) {
                expr = normalizeExpr(integrandForNerdamer(parsed.integrand));
                v = parsed.var;
                a = parsed.a;
                b = parsed.b;
                useDefinite = true;
                // Sync UI: switch to definite, set bounds and variable
                if (currentMode !== 'definite') {
                    document.querySelector('.ic-mode-btn[data-mode="definite"]').click();
                }
                lowerInput.value = a;
                upperInput.value = b;
                if (varSelect.querySelector('option[value="' + v + '"]')) { varSelect.value = v; }
                updatePreview();
            } else {
                expr = normalizeExpr(rawExpr);
                v = varSelect.value;
                useDefinite = (currentMode === 'definite');
                a = lowerInput.value.trim() || '0';
                b = upperInput.value.trim() || '1';
            }
            if (!rawExpr) {
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a function.', 2000, 'warning');
                return;
            }

            // Check precomputed integrals first (instant results for coth, csch, sech etc.)
            var precomp = lookupPrecomputed(expr, v);
            if (precomp) {
                var pMethod = precomp.method;
                var pResultTeX = substituteVar(precomp.resultTeX, v);
                var pResultText = substituteVar(precomp.resultText, v);
                var pStepsCache = { paths: [{ name: 'Solution', steps: precomp.steps.map(function(s) {
                    return { title: s.title, latex: substituteVar(s.latex, v) };
                }), rules: (precomp.rulesStr.match(/\w+Rule/g) || []) }] };

                if (!useDefinite) {
                    showIndefiniteResult(expr, v, pResultTeX, pResultText, pMethod, pStepsCache);
                    resultActions.classList.add('visible');
                    if (emptyState) emptyState.style.display = 'none';
                    try { prepareGraph(expr, v, nerdamerToPython(expr), 'indefinite', null, null); } catch(e) {}
                } else {
                    // For definite integrals of precomputed functions, fall through to SymPy
                    // since we need numeric evaluation at the specific bounds
                    sympyFallback(expr, v);
                }
                return;
            }

            try {
                // Compute indefinite integral
                var result = nerdamer('integrate(' + expr + ', ' + v + ')');
                var failed = false;
                try { failed = result.hasIntegral(); } catch (e) { /* hasIntegral may not exist in some builds */ }

                if (failed) {
                    sympyFallback(expr, v);
                    return;
                }

                var resultTeX = result.toTeX();
                var resultText = result.text();

                // Validate nerdamer result by evaluating at test points
                // Catches cases where nerdamer returns expressions with hidden division by zero
                try {
                    var testScope = {};
                    testScope[v] = 1;
                    var testVal = parseFloat(nerdamer(resultText).evaluate(testScope).text('decimals'));
                    if (!isFinite(testVal)) throw new Error('non-finite');
                    testScope[v] = 2;
                    testVal = parseFloat(nerdamer(resultText).evaluate(testScope).text('decimals'));
                    if (!isFinite(testVal)) throw new Error('non-finite');
                } catch (evalErr) {
                    sympyFallback(expr, v);
                    return;
                }

                // Detect known non-elementary integrals (Nerdamer returns incorrect results for these)
                // Route to SymPy which can return correct special-function answers (erf, Si, li, etc.)
                var nonElem = checkNonElementaryIntegral(expr, v);
                if (nonElem) {
                    sympyFallback(expr, v);
                    return;
                }

                var method = identifyMethod(expr);

                if (!useDefinite) {
                    showIndefiniteResult(expr, v, resultTeX, resultText, method);
                    prepareGraph(expr, v, result.text(), 'indefinite', null, null);
                } else {
                    a = a || lowerInput.value.trim() || '0';
                    b = b || upperInput.value.trim() || '1';
                    // Compute definite integral
                    var defResult;
                    var numericVal;
                    try {
                        defResult = nerdamer('defint(' + expr + ', ' + a + ', ' + b + ', ' + v + ')');
                        numericVal = parseFloat(defResult.text('decimals'));
                    } catch (e2) {
                        // Fallback: evaluate antiderivative at bounds (use actual variable; evalBound for pi/e)
                        try {
                            var aNum = evalBound(a);
                            var bNum = evalBound(b);
                            var scope = {};
                            scope[v] = aNum;
                            var Fa = nerdamer(result.text()).evaluate(scope);
                            scope[v] = bNum;
                            var Fb = nerdamer(result.text()).evaluate(scope);
                            numericVal = parseFloat(Fb.text('decimals')) - parseFloat(Fa.text('decimals'));
                            defResult = nerdamer(Fb.text() + '-(' + Fa.text() + ')');
                        } catch (e3) {
                            numericVal = NaN;
                        }
                    }
                    var exactText = defResult ? defResult.text() : '';
                    // If nerdamer returned non-finite definite result, fall through to SymPy
                    if (!isFinite(numericVal)) {
                        sympyFallback(expr, v);
                        return;
                    }
                    showDefiniteResult(expr, v, a, b, resultTeX, resultText, exactText, numericVal, method);
                    prepareGraph(expr, v, result.text(), 'definite', a, b);
                }

                resultActions.classList.add('visible');
                if (emptyState) emptyState.style.display = 'none';

            } catch (err) {
                sympyFallback(expr, v);
            }
        }

        // ========== Method Identification ==========
        function identifyMethod(expr) {
            if (/\*/.test(expr) && /(sin|cos|e\^|exp)/.test(expr)) return 'Integration by Parts';
            if (/\/.*\(/.test(expr) || /\/\(/.test(expr)) return 'Partial Fractions / Substitution';
            if (/sinh|cosh|tanh|coth|csch|sech/.test(expr)) return 'Hyperbolic Integration';
            if (/sin|cos|tan|sec|csc|cot/.test(expr)) return 'Trigonometric Integration';
            if (/e\^|exp\(/.test(expr)) return 'Exponential Integration';
            if (/log\(|ln\(/.test(expr)) return 'Logarithmic Integration';
            if (/^\s*[\d.]*\*?[a-z]\^[\d]+/.test(expr) || /^\s*[a-z]\^/.test(expr)) return 'Power Rule';
            return 'Symbolic Integration';
        }

        // ========== Result Display: Indefinite ==========
        function showIndefiniteResult(expr, v, resultTeX, resultText, method, sympyStepsCache) {
            var exprTeX = exprToLatex(expr);
            lastResultLatex = resultTeX + ' + C';
            lastResultText = resultText + ' + C';

            lastIntegrationContext = { expr: expr, v: v, resultTeX: resultTeX, resultText: resultText, method: method, mode: 'indefinite', a: null, b: null, sympyStepsCache: sympyStepsCache || null };

            var html = '<div class="ic-result-math">';
            html += '<div class="ic-result-label">Integral</div>';
            html += '<div id="ic-r-integral"></div>';
            html += '<div class="ic-result-label" style="margin-top:1rem;">Result</div>';
            html += '<div class="ic-result-main" id="ic-r-result"></div>';
            html += '<div class="ic-result-detail">';
            html += '<span class="ic-method-badge">' + escapeHtml(method) + '</span>';
            html += '</div>';
            html += '<button type="button" class="ic-steps-btn" id="ic-steps-btn">&#128221; Show Steps</button>';
            html += '<div id="ic-steps-area"></div>';
            html += '</div>';
            resultContent.innerHTML = html;

            var stepsBtn = document.getElementById('ic-steps-btn');
            if (stepsBtn) stepsBtn.addEventListener('click', function() { window.showSteps && window.showSteps(); });

            katex.render('\\int ' + exprTeX + ' \\, d' + v + ' =', document.getElementById('ic-r-integral'), { displayMode: true, throwOnError: false });
            katex.render(resultTeX + ' + C', document.getElementById('ic-r-result'), { displayMode: true, throwOnError: false });
        }

        // ========== Result Display: Non-Elementary ==========
        function showNonElementaryResult(expr, v, exprLatex, method, sympyStepsCache) {
            var exprTeX = exprToLatex(expr);
            lastResultLatex = '\\text{No elementary closed form}';
            lastResultText = 'No elementary closed form';

            lastIntegrationContext = { expr: expr, v: v, resultTeX: '', resultText: '', method: method, mode: 'indefinite', a: null, b: null, sympyStepsCache: sympyStepsCache || null };

            var html = '<div class="ic-result-math">';
            html += '<div class="ic-result-label">Integral</div>';
            html += '<div id="ic-r-integral"></div>';
            html += '<div class="ic-result-label" style="margin-top:1rem;">Result</div>';
            html += '<div class="ic-result-main" id="ic-r-result" style="color:#e67e22;font-size:0.95rem;padding:0.75rem 0;">This integral cannot be expressed in terms of elementary functions.<br>Use definite mode with bounds for a numerical result.</div>';
            html += '<div class="ic-result-detail">';
            html += '<span class="ic-method-badge">Non-Elementary (Elliptic)</span>';
            html += '</div>';
            html += '<button type="button" class="ic-steps-btn" id="ic-steps-btn">&#128221; Show Analysis</button>';
            html += '<div id="ic-steps-area"></div>';
            html += '</div>';
            resultContent.innerHTML = html;

            var stepsBtn = document.getElementById('ic-steps-btn');
            if (stepsBtn) stepsBtn.addEventListener('click', function() { window.showSteps && window.showSteps(); });

            katex.render('\\int ' + exprTeX + ' \\, d' + v, document.getElementById('ic-r-integral'), { displayMode: true, throwOnError: false });
        }

        // ========== Result Display: Definite ==========
        function showDefiniteResult(expr, v, a, b, resultTeX, resultText, exactText, numericVal, method, sympyStepsCache) {
            var exprTeX = exprToLatex(expr);
            var numStr = isFinite(numericVal) ? numericVal.toFixed(6) : 'N/A';
            var aTeX = boundToLatex(a);
            var bTeX = boundToLatex(b);
            lastResultLatex = '\\int_{' + aTeX + '}^{' + bTeX + '} ' + exprTeX + ' \\, d' + v + ' = ' + (exactText || numStr);
            lastResultText = 'integral from ' + a + ' to ' + b + ' of ' + expr + ' d' + v + ' = ' + (exactText || numStr);

            lastIntegrationContext = { expr: expr, v: v, resultTeX: resultTeX, resultText: resultText + (exactText ? ' = ' + exactText : ''), method: method, mode: 'definite', a: a, b: b, sympyStepsCache: sympyStepsCache || null };

            var html = '<div class="ic-result-math">';
            html += '<div class="ic-result-label">Definite Integral</div>';
            html += '<div id="ic-r-integral"></div>';

            if (isFinite(numericVal)) {
                html += '<div class="ic-result-numeric">&asymp; ' + escapeHtml(numStr) + (exactText && exactText !== numStr ? '&nbsp;&nbsp;(exact: ' + escapeHtml(exactText) + ')' : '') + '</div>';
            }

            html += '<div class="ic-result-label" style="margin-top:0.75rem;">Result</div>';
            html += '<div id="ic-r-antideriv"></div>';

            if (isFinite(numericVal)) {
                html += '<div class="ic-result-detail">';
                html += 'F(' + escapeHtml(boundToLatex(b)) + ') - F(' + escapeHtml(boundToLatex(a)) + ') = ' + escapeHtml(numStr);
                html += '<br><span class="ic-method-badge" style="margin-top:0.375rem;">' + escapeHtml(method) + '</span>';
                html += '</div>';
            }

            html += '<button type="button" class="ic-steps-btn" id="ic-steps-btn">&#128221; Show Steps</button>';
            html += '<div id="ic-steps-area"></div>';
            html += '</div>';
            resultContent.innerHTML = html;

            var stepsBtn = document.getElementById('ic-steps-btn');
            if (stepsBtn) stepsBtn.addEventListener('click', function() { window.showSteps && window.showSteps(); });

            katex.render('\\int_{' + aTeX + '}^{' + bTeX + '} ' + exprTeX + ' \\, d' + v + ' =', document.getElementById('ic-r-integral'), { displayMode: true, throwOnError: false });
            katex.render(resultTeX, document.getElementById('ic-r-antideriv'), { displayMode: true, throwOnError: false });
        }

        function showNonElementaryError(expr, v, info) {
            resultActions.classList.remove('visible');
            var html = '<div class="ic-error">';
            html += '<h4>Non-Elementary Integral</h4>';
            html += '<p>The integral of <strong>' + escapeHtml(info.name) + '</strong> cannot be expressed in terms of elementary functions (polynomials, exponentials, logs, trig).</p>';
            html += '<p>It defines the <strong>' + escapeHtml(info.symbol) + '</strong> function: ' + escapeHtml(info.desc) + '</p>';
            html += '<p>Use a <strong>definite integral</strong> with bounds for a numeric result.</p>';
            html += '</div>';
            resultContent.innerHTML = html;
            if (emptyState) emptyState.style.display = 'none';
        }

        // ========== Error State ==========
        function showError(expr, msg) {
            resultActions.classList.remove('visible');
            var html = '<div class="ic-error">';
            html += '<h4>Could Not Integrate</h4>';
            html += '<p>The expression <strong>' + escapeHtml(expr) + '</strong> could not be symbolically integrated.' + (msg ? ' (' + escapeHtml(msg) + ')' : '') + '</p>';
            html += '<ul>';
            html += '<li>Simplify the expression</li>';
            html += '<li>Check syntax (see Syntax Help)</li>';
            html += '<li>Use numerical approximation (switch to Definite with bounds)</li>';
            html += '</ul>';
            html += '</div>';
            resultContent.innerHTML = html;
            if (emptyState) emptyState.style.display = 'none';
        }

        // ========== SymPy Fallback via OneCompiler ==========
        function boundToSympy(s) {
            return (s || '').replace(/\u03c0/g, 'pi').replace(/\u221e/g, 'oo').replace(/\u2212/g, '-')
                .replace(/^-?infinity$/i, function(m) { return m.charAt(0) === '-' ? '-oo' : 'oo'; })
                .replace(/^-?inf$/i, function(m) { return m.charAt(0) === '-' ? '-oo' : 'oo'; });
        }

        function sympyFallback(expr, v) {
            var pyExpr = nerdamerToPython(expr);
            var a = boundToSympy(lowerInput.value.trim()) || '0';
            var b = boundToSympy(upperInput.value.trim()) || '1';
            var isDefinite = (currentMode === 'definite');

            // Show loading state
            resultActions.classList.remove('visible');
            resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
                '<div class="ic-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
                '<p style="color:var(--text-secondary);font-size:0.9375rem;">Trying advanced solver...</p></div>';
            if (emptyState) emptyState.style.display = 'none';

            var symDecl = buildSympySymbolsDecl(v, pyExpr);
            var code;
            if (isDefinite) {
                code = 'from sympy import *\n' +
                    'from sympy.integrals.manualintegrate import integral_steps, DontKnowRule\n' +
                    'import json\n' +
                    symDecl + '\n' +
                    'expr = simplify(' + pyExpr + ')\n' +
                    'try:\n    steps = integral_steps(expr, ' + v + ')\nexcept:\n    steps = None\n' +
                    'import signal\n' +
                    'def _timeout(s, f): raise TimeoutError\n' +
                    'signal.signal(signal.SIGALRM, _timeout)\n' +
                    'signal.alarm(10)\n' +
                    'try:\n' +
                    '    antideriv = integrate(expr, ' + v + ')\n' +
                    'except (TimeoutError, Exception):\n' +
                    '    antideriv = Integral(expr, ' + v + ')\n' +
                    'finally:\n' +
                    '    signal.alarm(0)\n' +
                    'if isinstance(antideriv, Integral):\n' +
                    '    # No closed-form antiderivative — fast numeric evaluation\n' +
                    '    result = Integral(expr, (' + v + ', ' + a + ', ' + b + '))\n' +
                    '    print(\'LATEX:\' + latex(result))\n' +
                    '    print(\'TEXT:\' + str(result))\n' +
                    '    print(\'EXPR:\' + latex(expr))\n' +
                    '    print(\'RULES:\' + (str(steps) if steps else ""))\n' +
                    '    print(\'ANTIDERIV:\')\n' +
                    '    try:\n' +
                    '        from scipy.integrate import quad as _quad\n' +
                    '        from math import isfinite as _isf, inf as _inf\n' +
                    '        _f = lambdify(' + v + ', expr, "numpy")\n' +
                    '        _val, _err = _quad(_f, float(' + a + '), float(' + b + '), limit=100)\n' +
                    '        if not _isf(_val) or (abs(_val) > 1e-10 and abs(_err/_val) > 0.01):\n' +
                    '            raise ValueError("divergent or unreliable")\n' +
                    '        print(\'NUMERIC:\' + str(_val))\n' +
                    '    except:\n' +
                    '        print(\'NUMERIC:NaN\')\n' +
                    'else:\n' +
                    '    # Has closed-form antiderivative — evaluate at bounds\n' +
                    '    result = integrate(expr, (' + v + ', ' + a + ', ' + b + '))\n' +
                    '    print(\'LATEX:\' + latex(result))\n' +
                    '    print(\'TEXT:\' + str(result))\n' +
                    '    print(\'EXPR:\' + latex(expr))\n' +
                    '    print(\'RULES:\' + (str(steps) if steps else ""))\n' +
                    '    print(\'ANTIDERIV:\' + latex(antideriv))\n' +
                    '    try:\n' +
                    '        print(\'NUMERIC:\' + str(float(result)))\n' +
                    '    except:\n' +
                    '        print(\'NUMERIC:NaN\')\n' +
                    '    try:\n' +
                    '        var_sym = ' + v + '\n' +
                    '        a_s = sympify("' + a.replace(/"/g, '\\"') + '")\n' +
                    '        b_s = sympify("' + b.replace(/"/g, '\\"') + '")\n' +
                    '        def _ev(bound):\n' +
                    '            if bound == oo: return limit(antideriv, var_sym, oo)\n' +
                    '            if bound == -oo: return limit(antideriv, var_sym, -oo)\n' +
                    '            return antideriv.subs(var_sym, bound)\n' +
                    '        v_u = _ev(b_s); v_l = _ev(a_s)\n' +
                    '        a_tex = "\\\\infty" if a_s == oo else ("-\\\\infty" if a_s == -oo else latex(a_s))\n' +
                    '        b_tex = "\\\\infty" if b_s == oo else ("-\\\\infty" if b_s == -oo else latex(b_s))\n' +
                    '        ev_latex = r"\\left[ " + latex(antideriv) + r" \\right]_{" + a_tex + "}^{" + b_tex + "} = " + latex(v_u) + " - (" + latex(v_l) + ") = " + latex(result)\n' +
                    '        print("EVAL_STEP:" + json.dumps({"title":"Evaluate at bounds","latex":ev_latex}))\n' +
                    '    except: pass';
            } else {
                code = 'from sympy import *\n' +
                    'from sympy.integrals.manualintegrate import integral_steps, DontKnowRule\n' +
                    symDecl + '\n' +
                    'expr = simplify(' + pyExpr + ')\n' +
                    'try:\n    steps = integral_steps(expr, ' + v + ')\nexcept:\n    steps = None\n' +
                    'import signal\n' +
                    'def _timeout(s, f): raise TimeoutError\n' +
                    'signal.signal(signal.SIGALRM, _timeout)\n' +
                    'signal.alarm(10)\n' +
                    'try:\n' +
                    '    result = integrate(expr, ' + v + ')\n' +
                    'except (TimeoutError, Exception):\n' +
                    '    result = Integral(expr, ' + v + ')\n' +
                    'finally:\n' +
                    '    signal.alarm(0)\n' +
                    'print(\'LATEX:\' + latex(result))\n' +
                    'print(\'TEXT:\' + str(result))\n' +
                    'print(\'EXPR:\' + latex(expr))\n' +
                    '# When integral_steps gives DontKnowRule but integrate() succeeded,\n' +
                    '# build synthetic steps by decomposing the result into terms\n' +
                    'if steps and isinstance(steps, DontKnowRule) and not isinstance(result, Integral) and not result.has(Integral):\n' +
                    '    _terms = result.as_ordered_terms()\n' +
                    '    _sub = []\n' +
                    '    for _t in _terms:\n' +
                    '        _d = diff(_t, ' + v + ')\n' +
                    '        _s = integral_steps(_d, ' + v + ')\n' +
                    '        _rule = type(_s).__name__ if _s and not isinstance(_s, DontKnowRule) else "Direct"\n' +
                    '        _sub.append(_rule)\n' +
                    '    steps_str = "AddRule(substeps=[" + ", ".join(_sub) + "])"\n' +
                    '    print(\'RULES:\' + steps_str)\n' +
                    'elif steps and isinstance(steps, DontKnowRule) and (isinstance(result, Integral) or result.has(Integral)):\n' +
                    '    # Non-elementary integral: generate decomposition steps\n' +
                    '    import json as _json\n' +
                    '    _st = []\n' +
                    '    numer, denom = expr.as_numer_denom()\n' +
                    '    denom_factored = factor(denom)\n' +
                    '    denom_factors = Mul.make_args(denom_factored)\n' +
                    '    rat_f = []; irr_f = []; sqrt_inner = None\n' +
                    '    for _f in denom_factors:\n' +
                    '        _hi = False; _atoms = _f.atoms(Pow) if not isinstance(_f, Pow) else {_f}\n' +
                    '        for _a in _atoms:\n' +
                    '            if isinstance(_a, Pow) and not _a.exp.is_integer:\n' +
                    '                _hi = True\n' +
                    '                if _a.exp == Rational(1,2): sqrt_inner = _a.base\n' +
                    '                break\n' +
                    '        if _hi: irr_f.append(_f)\n' +
                    '        else: rat_f.append(_f)\n' +
                    '    rat_d = Mul(*rat_f) if rat_f else S.One\n' +
                    '    irr_p = Mul(*irr_f) if irr_f else S.One\n' +
                    '    _st.append({"title":"Identify the integral","latex":r"\\int "+latex(expr)+r" \\,d' + v + '"})\n' +
                    '    if rat_d != S.One:\n' +
                    '        uf = expand(rat_d); ff = factor(rat_d)\n' +
                    '        if len(Mul.make_args(ff)) > 1 and ff != uf:\n' +
                    '            _st.append({"title":"Factor the polynomial part of denominator","latex":latex(uf)+" = "+latex(ff)})\n' +
                    '    if sqrt_inner is not None:\n' +
                    '        try:\n' +
                    '            _p = Poly(sqrt_inner, ' + v + ')\n' +
                    '            if _p.degree() == 2:\n' +
                    '                _a,_b,_c = _p.all_coeffs()\n' +
                    '                if _b != 0:\n' +
                    '                    _h = Rational(_b, 2*_a); _k = _c - _b**2/(4*_a)\n' +
                    '                    _comp = _a*(' + v + '+_h)**2+_k\n' +
                    '                    _st.append({"title":"Complete the square under the radical","latex":r"\\sqrt{"+latex(sqrt_inner)+r"} = \\sqrt{"+latex(_comp)+"}"})\n' +
                    '        except: pass\n' +
                    '    if rat_d != S.One:\n' +
                    '        _re = numer/rat_d\n' +
                    '        try: _pf = apart(_re, ' + v + ')\n' +
                    '        except: _pf = _re\n' +
                    '        if _pf != _re:\n' +
                    '            _st.append({"title":"Partial fraction decomposition","latex":latex(_re)+" = "+latex(_pf)})\n' +
                    '            _terms = Add.make_args(_pf)\n' +
                    '            _ti = [simplify(_t/irr_p) for _t in _terms]\n' +
                    '            _sl = " + ".join([r"\\int "+latex(_t)+r" \\,d' + v + '" for _t in _ti])\n' +
                    '            _st.append({"title":"Split the integral","latex":r"\\int "+latex(expr)+r" \\,d' + v + ' = "+_sl})\n' +
                    '            for _t in _ti:\n' +
                    '                _tr = integrate(_t, ' + v + ')\n' +
                    '                if _tr and not isinstance(_tr, Integral) and not _tr.has(Integral):\n' +
                    '                    _st.append({"title":"Integrate term","latex":r"\\int "+latex(_t)+r" \\,d' + v + ' = "+latex(_tr)})\n' +
                    '                else:\n' +
                    '                    _st.append({"title":"Non-elementary sub-integral","latex":r"\\int "+latex(_t)+r" \\,d' + v + ' \\\\text{ has no elementary closed form}"})\n' +
                    '    _st.append({"title":"Conclusion","latex":r"\\text{This integral cannot be expressed using elementary functions. For definite integrals, numerical methods give the exact value.}"})\n' +
                    '    print("NON_ELEMENTARY_STEPS:" + _json.dumps(_st, separators=(",",":")))\n' +
                    '    print(\'RULES:DontKnowRule\')\n' +
                    'else:\n' +
                    '    print(\'RULES:\' + (str(steps) if steps else ""))';
            }

            var controller = new AbortController();
            var timeoutId = setTimeout(function() { controller.abort(); }, 180000);

            fetch((window.INTEGRAL_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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

                    // Only fail on real errors (not SymPy warnings); require no stdout
                    // For definite integrals, allow unevaluated Integral if NUMERIC value exists
                    // For non-elementary integrals, allow through if decomposition steps exist
                    var hasNumeric = /NUMERIC:(?!NaN)[\d.\-]/.test(stdout);
                    var hasNonElemSteps = stdout.indexOf('NON_ELEMENTARY_STEPS:') !== -1;
                    if ((!stdout && stderr) || (!stdout && !stderr) || (stdout.indexOf('Integral(') !== -1 && !(isDefinite && hasNumeric) && !hasNonElemSteps)) {
                        showError(expr, stderr || 'Could not solve this integral');
                        return;
                    }

                    var method = 'Advanced Solver';
                    var latexMatch = stdout.match(/LATEX:([^\n]*)/);
                    var textMatch = stdout.match(/TEXT:([^\n]*)/);
                    var exprMatch = stdout.match(/EXPR:([\s\S]*?)(?=\nRULES|\nANTIDERIV|\nNUMERIC|$)/);
                    var rulesMatch = stdout.match(/RULES:([\s\S]*?)(?=\nANTIDERIV|\nNUMERIC|$)/);
                    var antiderivMatch = stdout.match(/ANTIDERIV:([^\n]*)/);
                    var evalStepLine = stdout.split('\n').filter(function(l) { return l.indexOf('EVAL_STEP:') === 0; })[0];
                    var evalStepMatch = evalStepLine ? { 1: evalStepLine.replace(/^EVAL_STEP:/, '') } : null;
                    var resultTeX = latexMatch ? latexMatch[1].trim() : stdout;
                    var resultText = textMatch ? textMatch[1].trim() : resultTeX;
                    var exprLatex = exprMatch ? exprMatch[1].trim() : '';
                    var rulesStr = rulesMatch ? rulesMatch[1].trim() : '';
                    var antiderivLatex = antiderivMatch ? antiderivMatch[1].trim() : '';
                    var stepResultLatex = isDefinite ? antiderivLatex : resultTeX;
                    var sympyStepsCache;
                    if (isDefinite) {
                        if (evalStepMatch) {
                            try {
                                var evalStep = JSON.parse(evalStepMatch[1]);
                                sympyStepsCache = { paths: [{ name: 'Solution', steps: [evalStep], rules: [] }] };
                            } catch (e) { sympyStepsCache = null; }
                        } else {
                            sympyStepsCache = null;
                        }
                    } else {
                        sympyStepsCache = (stepResultLatex && rulesStr) ? parseSympyOutput(expr, v, stepResultLatex, rulesStr, exprLatex) : null;
                    }

                    // Handle non-elementary integrals with decomposition steps
                    if (hasNonElemSteps) {
                        var neMatch = stdout.match(/NON_ELEMENTARY_STEPS:(\[[\s\S]*?\])(?=\n|$)/);
                        var neSteps = [];
                        try { neSteps = JSON.parse(neMatch[1]); } catch(e) {}
                        var neStepsCache = { paths: [{ name: 'Solution', steps: neSteps, rules: [] }] };
                        if (isDefinite) {
                            var numericMatch = stdout.match(/NUMERIC:([^\n]*)/);
                            var numericStr = numericMatch ? numericMatch[1].trim() : 'NaN';
                            var numericVal = parseFloat(numericStr);
                            showDefiniteResult(expr, v, a, b, resultTeX, resultText, resultText, numericVal, method, neStepsCache);
                        } else {
                            showNonElementaryResult(expr, v, exprLatex, method, neStepsCache);
                        }
                        resultActions.classList.add('visible');
                        try { prepareGraph(expr, v, pyExpr, isDefinite ? 'definite' : 'indefinite', isDefinite ? a : null, isDefinite ? b : null); } catch(e) {}
                    } else if (isDefinite) {
                        var numericMatch = stdout.match(/NUMERIC:([^\n]*)/);
                        var numericStr = numericMatch ? numericMatch[1].trim() : 'NaN';
                        var numericVal = parseFloat(numericStr);
                        var exactText = resultText;

                        showDefiniteResult(expr, v, a, b, resultTeX, resultText, exactText, numericVal, method, sympyStepsCache);
                        resultActions.classList.add('visible');
                        try { prepareGraph(expr, v, pyExpr, 'definite', a, b); } catch(e) {}
                    } else {
                        showIndefiniteResult(expr, v, resultTeX, resultText, method, sympyStepsCache);
                        resultActions.classList.add('visible');
                        try { prepareGraph(expr, v, pyExpr, 'indefinite', null, null); } catch(e) {}
                    }
                })
                .catch(function(err) {
                    clearTimeout(timeoutId);
                    showError(expr, err.name === 'AbortError' ? 'Request timed out' : err.message);
                });
        }

        // ========== Step-by-Step Solutions ==========
        var lastIntegrationContext = null; // stores {expr, v, resultText, method, mode, a, b}

        function generateTemplateSteps(expr, v, resultTeX, method) {
            var steps = [];
            var e = expr.trim();

            // Power rule: x^n or c*x^n
            if (/^(\d+\*?)?[a-z]\^(\d+)$/.test(e)) {
                var m = e.match(/^(\d+\*?)?([a-z])\^(\d+)$/);
                var coeff = m[1] ? parseInt(m[1]) : 1;
                var n = parseInt(m[3]);
                var np1 = n + 1;
                steps.push({ title: 'Apply Power Rule', latex: '\\int ' + (coeff > 1 ? coeff : '') + v + '^{' + n + '} \\, d' + v + ' = ' + (coeff > 1 ? coeff + ' \\cdot ' : '') + '\\frac{' + v + '^{' + np1 + '}}{' + np1 + '}' });
                if (coeff > 1) {
                    steps.push({ title: 'Simplify coefficient', latex: '= \\frac{' + coeff + '}{' + np1 + '}' + v + '^{' + np1 + '} + C' });
                } else {
                    steps.push({ title: 'Add constant of integration', latex: '= \\frac{' + v + '^{' + np1 + '}}{' + np1 + '} + C' });
                }
                return steps;
            }

            // Simple sin(x), cos(x), e^x, 1/x, sec^2(x)
            var basicIntegrals = {
                'sin(x)':    [{ title: 'Standard trig integral', latex: '\\int \\sin(' + v + ') \\, d' + v + ' = -\\cos(' + v + ') + C' }],
                'cos(x)':    [{ title: 'Standard trig integral', latex: '\\int \\cos(' + v + ') \\, d' + v + ' = \\sin(' + v + ') + C' }],
                'e^x':       [{ title: 'Exponential rule', latex: '\\int e^{' + v + '} \\, d' + v + ' = e^{' + v + '} + C' }],
                '1/x':       [{ title: 'Reciprocal rule', latex: '\\int \\frac{1}{' + v + '} \\, d' + v + ' = \\ln|' + v + '| + C' }],
                'sec(x)^2':  [{ title: 'Standard trig integral', latex: '\\int \\sec^2(' + v + ') \\, d' + v + ' = \\tan(' + v + ') + C' }],
                'tan(x)':    [{ title: 'Standard trig integral', latex: '\\int \\tan(' + v + ') \\, d' + v + ' = -\\ln|\\cos(' + v + ')| + C' }],
                'log(x)':    [{ title: 'Integration by parts (u = ln x, dv = dx)', latex: '\\int \\ln(' + v + ') \\, d' + v + ' = ' + v + '\\ln(' + v + ') - ' + v + ' + C' }]
            };
            // Normalize variable: replace actual var with x for lookup
            var normalized = e.replace(new RegExp(v, 'g'), 'x');
            if (basicIntegrals[normalized]) {
                return basicIntegrals[normalized];
            }

            // Sum of terms: split by + or - at top level
            // e.g. x^2+3*x, sin(x)+cos(x)
            var terms = splitTerms(e);
            if (terms && terms.length > 1) {
                steps.push({ title: 'Split into sum of integrals', latex: '\\int \\left(' + exprToLatex(e) + '\\right) d' + v + ' = ' + terms.map(function(t) { return '\\int ' + exprToLatex(t.trim()) + ' \\, d' + v; }).join(' + ') });
                // Try to get each term's integral
                var allResolved = true;
                var partResults = [];
                for (var i = 0; i < terms.length; i++) {
                    try {
                        var r = nerdamer('integrate(' + terms[i] + ', ' + v + ')');
                        if (r.hasIntegral && r.hasIntegral()) { allResolved = false; break; }
                        partResults.push(r.toTeX());
                    } catch (ex) { allResolved = false; break; }
                }
                if (allResolved && partResults.length === terms.length) {
                    for (var j = 0; j < terms.length; j++) {
                        steps.push({ title: 'Integrate term ' + (j + 1), latex: '\\int ' + exprToLatex(terms[j].trim()) + ' \\, d' + v + ' = ' + partResults[j] });
                    }
                    steps.push({ title: 'Combine and add constant', latex: '= ' + resultTeX + ' + C' });
                    return steps;
                }
            }

            // Constant multiple: c*f(x)
            var constMatch = e.match(/^(\d+)\*(.+)$/);
            if (constMatch) {
                var c = constMatch[1];
                var inner = constMatch[2];
                steps.push({ title: 'Factor out constant', latex: '\\int ' + c + ' \\cdot ' + exprToLatex(inner) + ' \\, d' + v + ' = ' + c + '\\int ' + exprToLatex(inner) + ' \\, d' + v });
                try {
                    var innerResult = nerdamer('integrate(' + inner + ', ' + v + ')');
                    if (!innerResult.hasIntegral || !innerResult.hasIntegral()) {
                        steps.push({ title: 'Integrate inner function', latex: '= ' + c + ' \\left(' + innerResult.toTeX() + '\\right) + C' });
                        steps.push({ title: 'Simplify', latex: '= ' + resultTeX + ' + C' });
                        return steps;
                    }
                } catch (ex) { /* fall through to AI */ }
            }

            // 1/(x^2+1) -> arctan
            if (normalized === '1/(x^2+1)') {
                steps.push({ title: 'Recognize standard form', latex: '\\int \\frac{1}{' + v + '^2 + 1} \\, d' + v + ' \\text{ matches } \\int \\frac{1}{u^2+1} du = \\arctan(u)' });
                steps.push({ title: 'Apply formula', latex: '= \\arctan(' + v + ') + C' });
                return steps;
            }

            // 1/sqrt(1-x^2) -> arcsin
            if (normalized === '1/sqrt(1-x^2)') {
                steps.push({ title: 'Recognize standard form', latex: '\\int \\frac{1}{\\sqrt{1-' + v + '^2}} \\, d' + v + ' \\text{ matches } \\int \\frac{1}{\\sqrt{1-u^2}} du = \\arcsin(u)' });
                steps.push({ title: 'Apply formula', latex: '= \\arcsin(' + v + ') + C' });
                return steps;
            }

            return null; // No template available — needs AI
        }

        function splitTerms(expr) {
            // Split by + or - at top level (not inside parentheses)
            var terms = [];
            var depth = 0;
            var current = '';
            for (var i = 0; i < expr.length; i++) {
                var ch = expr[i];
                if (ch === '(' || ch === '[') depth++;
                else if (ch === ')' || ch === ']') depth--;
                if (depth === 0 && (ch === '+' || (ch === '-' && i > 0 && current.trim()))) {
                    terms.push(current.trim());
                    current = ch === '-' ? '-' : '';
                } else {
                    current += ch;
                }
            }
            if (current.trim()) terms.push(current.trim());
            return terms.length > 1 ? terms : null;
        }

        /** Fetch SymPy: servlet returns STEPS JSON + result. JS parses and builds UI. opts: { mode, a, b } for definite eval step. */
        function fetchSympySteps(expr, v, cb, opts) {
            opts = opts || {};
            var pyExpr = nerdamerToPython(expr);
            var code;
            if (opts.mode === 'definite' && opts.a != null && opts.b != null) {
                var a = opts.a, b = opts.b;
                code = 'import json\n' +
                    'from sympy import *\n' +
                    'from sympy.integrals.manualintegrate import integral_steps, DontKnowRule, RewriteRule, AddRule, ConstantTimesRule, URule, ReciprocalRule, ArctanRule, PartsRule, ExpRule, PowerRule, ConstantRule, AlternativeRule, TrigSubstitutionRule, SinRule, CosRule, CoshRule, SinhRule, Sec2Rule, Csc2Rule, SecTanRule, CscCotRule, ArcsinRule, ArcsinhRule, CompleteSquareRule, CyclicPartsRule, SqrtQuadraticRule, ReciprocalSqrtQuadraticRule, PiecewiseRule, ErfRule, SiRule, LiRule, EiRule, CiRule, ChiRule, ShiRule, UpperGammaRule, FresnelCRule, FresnelSRule, EllipticERule, EllipticFRule, DiracDeltaRule, HeavisideRule, NestedPowRule, DerivativeRule\n' +
                    'def _c(r): return getattr(r,"integrand",None) or getattr(r,"context",None)\n' +
                    'def _s(r): return getattr(r,"variable",None) or getattr(r,"symbol",None)\n' +
                    'def r2s(rule,v,st=None):\n' +
                    '    if st is None: st=[]\n' +
                    '    if rule is None or isinstance(rule, DontKnowRule): return st\n' +
                    '    vs=_s(rule) or v; vs=str(vs)\n' +
                    '    res=None\n' +
                    '    try:\n' +
                    '        ctx=_c(rule); res=rule.eval() if hasattr(rule,"eval") else None\n' +
                    '        if isinstance(rule,RewriteRule):\n' +
                    '            st.append({"title":"Rewrite","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = \\\\int "+latex(rule.rewritten)+r" \\\\,d"+vs,"rule":"RewriteRule"}); r2s(rule.substep,v,st)\n' +
                    '        elif isinstance(rule,AddRule):\n' +
                    '            st.append({"title":"Sum rule","latex":r"\\\\int (f+g)\\\\,d"+vs+r" = \\\\int f\\\\,d"+vs+r" + \\\\int g\\\\,d"+vs,"rule":"AddRule"}); [r2s(s,v,st) for s in rule.substeps]; st.append({"title":"Combine","latex":"= "+latex(res),"rule":"AddRule"}) if res else None\n' +
                    '        elif isinstance(rule,ConstantTimesRule):\n' +
                    '            st.append({"title":"Constant factor","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(rule.constant)+r" \\\\int "+latex(rule.other)+r" \\\\,d"+vs,"rule":"ConstantTimesRule"}); r2s(rule.substep,v,st); st.append({"title":"Simplify","latex":"= "+latex(res),"rule":"ConstantTimesRule"}) if res else None\n' +
                    '        elif isinstance(rule,URule):\n' +
                    '            st.append({"title":"u-Substitution","latex":r"Let\\\\ u = "+latex(rule.u_func)+r",\\\\quad \\\\frac{du}{d"+vs+r"} = "+latex(rule.u_func.diff(_s(rule))),"rule":"URule"}); r2s(rule.substep,v,st); st.append({"title":"Back substitute","latex":"= "+latex(res),"rule":"URule"}) if res else None\n' +
                    '        elif isinstance(rule,ReciprocalRule): st.append({"title":"Reciprocal","latex":r"\\\\int \\\\frac{1}{"+latex(rule.base)+r"} \\\\,d"+vs+r" = \\\\ln|"+latex(rule.base)+r"| + C = "+latex(res),"rule":"ReciprocalRule"})\n' +
                    '        elif isinstance(rule,ArctanRule): st.append({"title":"Arctan","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ArctanRule"})\n' +
                    '        elif isinstance(rule,PartsRule):\n' +
                    '            st.append({"title":"Integration by parts","latex":r"\\\\int u\\\\,dv = uv - \\\\int v\\\\,du.\\\\quad u="+latex(rule.u)+r",\\\\ dv="+latex(rule.dv)+r"\\\\,d"+vs,"rule":"PartsRule"}); r2s(rule.v_step,v,st); r2s(rule.second_step,v,st); st.append({"title":"Result","latex":"= "+latex(res),"rule":"PartsRule"}) if res else None\n' +
                    '        elif isinstance(rule,ExpRule): st.append({"title":"Exponential","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ExpRule"})\n' +
                    '        elif isinstance(rule,PowerRule): st.append({"title":"Power rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"PowerRule"})\n' +
                    '        elif isinstance(rule,ConstantRule): st.append({"title":"Constant","latex":r"\\\\int "+latex(rule.constant)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ConstantRule"})\n' +
                    '        elif isinstance(rule,TrigSubstitutionRule):\n' +
                    '            st.append({"title":"Trig substitution","latex":r"Let\\\\ "+vs+r" = "+latex(rule.func)+r",\\\\quad d"+vs+r" = "+latex(diff(rule.func,rule.theta))+r"\\\\,d"+latex(rule.theta),"rule":"TrigSubstitutionRule"}); st.append({"title":"Rewrite integrand","latex":r"\\\\int "+latex(rule.rewritten)+r" \\\\,d"+latex(rule.theta),"rule":"TrigSubstitutionRule"}); r2s(rule.substep,v,st); st.append({"title":"Back substitute","latex":"= "+latex(res),"rule":"TrigSubstitutionRule"}) if res else None\n' +
                    '        elif isinstance(rule,(SinRule,CosRule)): st.append({"title":"Trig rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"TrigRule"})\n' +
                    '        elif isinstance(rule,(SinhRule,CoshRule)): st.append({"title":"Hyperbolic rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"HyperbolicRule"})\n' +
                    '        elif isinstance(rule,(Sec2Rule,Csc2Rule)): st.append({"title":"Trig rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"TrigRule"})\n' +
                    '        elif isinstance(rule,(SecTanRule,CscCotRule)): st.append({"title":"Trig rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"TrigRule"})\n' +
                    '        elif isinstance(rule,ArcsinRule): st.append({"title":"Arcsin","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ArcsinRule"})\n' +
                    '        elif isinstance(rule,ArcsinhRule): st.append({"title":"Arcsinh","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ArcsinhRule"})\n' +
                    '        elif isinstance(rule,CompleteSquareRule):\n' +
                    '            st.append({"title":"Complete the square","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = \\\\int "+latex(rule.rewritten)+r" \\\\,d"+vs,"rule":"CompleteSquareRule"}); r2s(rule.substep,v,st)\n' +
                    '        elif isinstance(rule,CyclicPartsRule):\n' +
                    '            prs=rule.parts_rules\n' +
                    '            for i,pr in enumerate(prs): st.append({"title":"By parts (round "+str(i+1)+")","latex":r"u = "+latex(pr.u)+r",\\\\ dv = "+latex(pr.dv)+r" \\\\,d"+vs,"rule":"CyclicPartsRule"})\n' +
                    '            st.append({"title":"Solve for integral","latex":"= "+latex(res),"rule":"CyclicPartsRule"}) if res else None\n' +
                    '        elif isinstance(rule,(SqrtQuadraticRule,ReciprocalSqrtQuadraticRule)): st.append({"title":"Standard form","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":type(rule).__name__})\n' +
                    '        elif isinstance(rule,PiecewiseRule):\n' +
                    '            st.append({"title":"Piecewise","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs,"rule":"PiecewiseRule"})\n' +
                    '            for sc in (rule.subfunctions if hasattr(rule,"subfunctions") else []): r2s(sc,v,st)\n' +
                    '            st.append({"title":"Result","latex":"= "+latex(res),"rule":"PiecewiseRule"}) if res else None\n' +
                    '        elif isinstance(rule,ErfRule): st.append({"title":"Error function","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ErfRule"})\n' +
                    '        elif isinstance(rule,(SiRule,LiRule,EiRule,CiRule,ChiRule,ShiRule)): st.append({"title":"Special function","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":type(rule).__name__})\n' +
                    '        elif isinstance(rule,UpperGammaRule): st.append({"title":"Upper incomplete gamma","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"UpperGammaRule"})\n' +
                    '        elif isinstance(rule,(FresnelCRule,FresnelSRule)): st.append({"title":"Fresnel integral","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":type(rule).__name__})\n' +
                    '        elif isinstance(rule,(EllipticERule,EllipticFRule)): st.append({"title":"Elliptic integral","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":type(rule).__name__})\n' +
                    '        elif isinstance(rule,DiracDeltaRule): st.append({"title":"Dirac delta","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"DiracDeltaRule"})\n' +
                    '        elif isinstance(rule,HeavisideRule):\n' +
                    '            st.append({"title":"Heaviside step","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs,"rule":"HeavisideRule"}); r2s(rule.substep,v,st); st.append({"title":"Result","latex":"= "+latex(res),"rule":"HeavisideRule"}) if res else None\n' +
                    '        elif isinstance(rule,NestedPowRule): st.append({"title":"Nested power","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = \\\\int "+vs+r"^{"+latex(rule.exp)+r"} \\\\,d"+vs+r" = "+latex(res),"rule":"NestedPowRule"})\n' +
                    '        elif isinstance(rule,DerivativeRule): st.append({"title":"Derivative rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"DerivativeRule"})\n' +
                    '        elif isinstance(rule,AlternativeRule): [r2s(a,v,st) for a in rule.alternatives[:1]]; st.append({"title":"Result","latex":"= "+latex(res)}) if not st and res else None\n' +
                    '        else: st.append({"title":type(rule).__name__.replace("Rule",""),"latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)}) if ctx and res else None\n' +
                    '    except: st.append({"title":"Result","latex":"= "+latex(res)}) if res else None\n' +
                    '    return st\n' +
                    buildSympySymbolsDecl(v, pyExpr) + '\n' +
                    'expr = ' + pyExpr + '\n' +
                    'a_s = sympify("' + (''+a).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '")\n' +
                    'b_s = sympify("' + (''+b).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '")\n' +
                    'antideriv = integrate(expr, ' + v + ')\n' +
                    'result = integrate(expr, (' + v + ', a_s, b_s))\n' +
                    'st = []\n' +
                    'try:\n' +
                    '    steps = integral_steps(expr, ' + v + ')\n' +
                    '    if steps and not isinstance(steps, DontKnowRule):\n' +
                    '        st = r2s(steps, ' + v + ')\n' +
                    'except: pass\n' +
                    'if not st and antideriv and not isinstance(antideriv, Integral) and not antideriv.has(Integral):\n' +
                    '    try: pf = apart(expr, ' + v + ')\n' +
                    '    except: pf = expr\n' +
                    '    did_decompose = False\n' +
                    '    if pf != expr:\n' +
                    '        st.append({"title":"Partial fraction decomposition","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = \\\\\\\\int "+latex(pf)+r" \\\\,d' + v + '"})\n' +
                    '        terms = Add.make_args(pf)\n' +
                    '        for t in terms:\n' +
                    '            t_steps = integral_steps(t, ' + v + ')\n' +
                    '            t_int = integrate(t, ' + v + ')\n' +
                    '            if t_steps and not isinstance(t_steps, DontKnowRule):\n' +
                    '                r2s(t_steps, ' + v + ', st)\n' +
                    '            elif t_int and not isinstance(t_int, Integral):\n' +
                    '                st.append({"title":"Integrate term","latex":r"\\\\int "+latex(t)+r" \\\\,d' + v + ' = "+latex(t_int)})\n' +
                    '        st.append({"title":"Combine","latex":"= "+latex(antideriv)})\n' +
                    '        did_decompose = True\n' +
                    '    if not did_decompose:\n' +
                    '        r_terms = Add.make_args(antideriv)\n' +
                    '        if len(r_terms) > 1:\n' +
                    '            st.append({"title":"Decompose result","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = "+latex(antideriv)})\n' +
                    '            for rt in r_terms:\n' +
                    '                d_rt = diff(rt, ' + v + ')\n' +
                    '                t_steps = integral_steps(d_rt, ' + v + ')\n' +
                    '                if t_steps and not isinstance(t_steps, DontKnowRule):\n' +
                    '                    r2s(t_steps, ' + v + ', st)\n' +
                    '                else:\n' +
                    '                    st.append({"title":"Integrate term","latex":r"\\\\int "+latex(d_rt)+r" \\\\,d' + v + ' = "+latex(rt)})\n' +
                    '            st.append({"title":"Combine","latex":"= "+latex(antideriv)})\n' +
                    '        else:\n' +
                    '            st = [{"title":"Antiderivative","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = "+latex(antideriv)}]\n' +
                    'if not st and (not antideriv or isinstance(antideriv, Integral) or antideriv.has(Integral)):\n' +
                    '    numer, denom = expr.as_numer_denom()\n' +
                    '    denom_factored = factor(denom)\n' +
                    '    denom_factors = Mul.make_args(denom_factored)\n' +
                    '    rat_f = []; irr_f = []; sqrt_inner = None\n' +
                    '    for _f in denom_factors:\n' +
                    '        _hi = False; _atoms = _f.atoms(Pow) if not isinstance(_f, Pow) else {_f}\n' +
                    '        for _a in _atoms:\n' +
                    '            if isinstance(_a, Pow) and not _a.exp.is_integer:\n' +
                    '                _hi = True\n' +
                    '                if _a.exp == Rational(1,2): sqrt_inner = _a.base\n' +
                    '                break\n' +
                    '        if _hi: irr_f.append(_f)\n' +
                    '        else: rat_f.append(_f)\n' +
                    '    rat_d = Mul(*rat_f) if rat_f else S.One\n' +
                    '    irr_p = Mul(*irr_f) if irr_f else S.One\n' +
                    '    st.append({"title":"Identify the integral","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + '"})\n' +
                    '    if rat_d != S.One:\n' +
                    '        uf = expand(rat_d); ff = factor(rat_d)\n' +
                    '        if len(Mul.make_args(ff)) > 1 and ff != uf:\n' +
                    '            st.append({"title":"Factor the polynomial part of denominator","latex":latex(uf)+" = "+latex(ff)})\n' +
                    '    if sqrt_inner is not None:\n' +
                    '        try:\n' +
                    '            _p = Poly(sqrt_inner, ' + v + ')\n' +
                    '            if _p.degree() == 2:\n' +
                    '                _a,_b,_c = _p.all_coeffs()\n' +
                    '                if _b != 0:\n' +
                    '                    _h = Rational(_b, 2*_a); _k = _c - _b**2/(4*_a)\n' +
                    '                    _comp = _a*(' + v + '+_h)**2+_k\n' +
                    '                    st.append({"title":"Complete the square under the radical","latex":r"\\\\sqrt{"+latex(sqrt_inner)+r"} = \\\\sqrt{"+latex(_comp)+"}"})\n' +
                    '        except: pass\n' +
                    '    if rat_d != S.One:\n' +
                    '        _re = numer/rat_d\n' +
                    '        try: _pf = apart(_re, ' + v + ')\n' +
                    '        except: _pf = _re\n' +
                    '        if _pf != _re:\n' +
                    '            st.append({"title":"Partial fraction decomposition","latex":latex(_re)+" = "+latex(_pf)})\n' +
                    '            _terms = Add.make_args(_pf)\n' +
                    '            _ti = [simplify(_t/irr_p) for _t in _terms]\n' +
                    '            _sl = " + ".join([r"\\\\int "+latex(_t)+r" \\\\,d' + v + '" for _t in _ti])\n' +
                    '            st.append({"title":"Split the integral","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = "+_sl})\n' +
                    '            for _t in _ti:\n' +
                    '                _tr = integrate(_t, ' + v + ')\n' +
                    '                if _tr and not isinstance(_tr, Integral) and not _tr.has(Integral):\n' +
                    '                    st.append({"title":"Integrate term","latex":r"\\\\int "+latex(_t)+r" \\\\,d' + v + ' = "+latex(_tr)})\n' +
                    '                else:\n' +
                    '                    st.append({"title":"Non-elementary sub-integral","latex":r"\\\\int "+latex(_t)+r" \\\\,d' + v + ' \\\\\\\\text{ has no elementary closed form}"})\n' +
                    '    st.append({"title":"Conclusion","latex":r"\\\\text{This integral cannot be expressed using elementary functions. For definite integrals, numerical methods give the exact value.}"})\n' +
                    'try:\n' +
                    '    if antideriv and not isinstance(antideriv, Integral):\n' +
                    '        def _ev(bnd):\n' +
                    '            if bnd == oo: return limit(antideriv, ' + v + ', oo)\n' +
                    '            if bnd == -oo: return limit(antideriv, ' + v + ', -oo)\n' +
                    '            return antideriv.subs(' + v + ', bnd)\n' +
                    '        v_u, v_l = _ev(b_s), _ev(a_s)\n' +
                    '        a_tex = "\\\\infty" if a_s == oo else ("-\\\\infty" if a_s == -oo else latex(a_s))\n' +
                    '        b_tex = "\\\\infty" if b_s == oo else ("-\\\\infty" if b_s == -oo else latex(b_s))\n' +
                    '        ev_latex = r"\\\\left[ " + latex(antideriv) + r" \\\\right]_{" + a_tex + "}^{" + b_tex + "} = " + latex(v_u) + " - (" + latex(v_l) + ") = " + latex(result)\n' +
                    '        st.append({"title":"Evaluate at bounds","latex":ev_latex})\n' +
                    'except: pass\n' +
                    'print("STEPS:" + (json.dumps(st, separators=(",",":")) if st else "[]"))\n' +
                    'print("RESULT=" + (latex(antideriv) if antideriv and not isinstance(antideriv, Integral) else ""))\n' +
                    'print("EXPR=" + latex(expr))\n' +
                    'print("RULES=")\n';
            } else {
                code = 'import json\n' +
                'from sympy import *\n' +
                'from sympy.integrals.manualintegrate import integral_steps, DontKnowRule, RewriteRule, AddRule, ConstantTimesRule, URule, ReciprocalRule, ArctanRule, PartsRule, ExpRule, PowerRule, ConstantRule, AlternativeRule, TrigSubstitutionRule, SinRule, CosRule, CoshRule, SinhRule, Sec2Rule, Csc2Rule, SecTanRule, CscCotRule, ArcsinRule, ArcsinhRule, CompleteSquareRule, CyclicPartsRule, SqrtQuadraticRule, ReciprocalSqrtQuadraticRule, PiecewiseRule, ErfRule, SiRule, LiRule, EiRule, CiRule, ChiRule, ShiRule, UpperGammaRule, FresnelCRule, FresnelSRule, EllipticERule, EllipticFRule, DiracDeltaRule, HeavisideRule, NestedPowRule, DerivativeRule\n' +
                'def _c(r): return getattr(r,"integrand",None) or getattr(r,"context",None)\n' +
                'def _s(r): return getattr(r,"variable",None) or getattr(r,"symbol",None)\n' +
                'def r2s(rule,v,st=None):\n' +
                '    if st is None: st=[]\n' +
                '    if rule is None or isinstance(rule, DontKnowRule): return st\n' +
                '    vs=_s(rule) or v; vs=str(vs)\n' +
                '    res=None\n' +
                '    try:\n' +
                '        ctx=_c(rule); res=rule.eval() if hasattr(rule,"eval") else None\n' +
                '        if isinstance(rule,RewriteRule):\n' +
                '            st.append({"title":"Rewrite","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = \\\\int "+latex(rule.rewritten)+r" \\\\,d"+vs,"rule":"RewriteRule"}); r2s(rule.substep,v,st)\n' +
                '        elif isinstance(rule,AddRule):\n' +
                '            st.append({"title":"Sum rule","latex":r"\\\\int (f+g)\\\\,d"+vs+r" = \\\\int f\\\\,d"+vs+r" + \\\\int g\\\\,d"+vs,"rule":"AddRule"}); [r2s(s,v,st) for s in rule.substeps]; st.append({"title":"Combine","latex":"= "+latex(res)+r" + C","rule":"AddRule"}) if res else None\n' +
                '        elif isinstance(rule,ConstantTimesRule):\n' +
                '            st.append({"title":"Constant factor","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(rule.constant)+r" \\\\int "+latex(rule.other)+r" \\\\,d"+vs,"rule":"ConstantTimesRule"}); r2s(rule.substep,v,st); st.append({"title":"Simplify","latex":"= "+latex(res)+r" + C","rule":"ConstantTimesRule"}) if res else None\n' +
                '        elif isinstance(rule,URule):\n' +
                '            st.append({"title":"u-Substitution","latex":r"Let\\\\ u = "+latex(rule.u_func)+r",\\\\quad \\\\frac{du}{d"+vs+r"} = "+latex(rule.u_func.diff(_s(rule))),"rule":"URule"}); r2s(rule.substep,v,st); st.append({"title":"Back substitute","latex":"= "+latex(res)+r" + C","rule":"URule"}) if res else None\n' +
                '        elif isinstance(rule,ReciprocalRule): st.append({"title":"Reciprocal","latex":r"\\\\int \\\\frac{1}{"+latex(rule.base)+r"} \\\\,d"+vs+r" = \\\\ln|"+latex(rule.base)+r"| + C = "+latex(res),"rule":"ReciprocalRule"})\n' +
                '        elif isinstance(rule,ArctanRule): st.append({"title":"Arctan","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"ArctanRule"})\n' +
                '        elif isinstance(rule,PartsRule):\n' +
                '            st.append({"title":"Integration by parts","latex":r"\\\\int u\\\\,dv = uv - \\\\int v\\\\,du.\\\\quad u="+latex(rule.u)+r",\\\\ dv="+latex(rule.dv)+r"\\\\,d"+vs,"rule":"PartsRule"}); r2s(rule.v_step,v,st); r2s(rule.second_step,v,st); st.append({"title":"Result","latex":"= "+latex(res)+r" + C","rule":"PartsRule"}) if res else None\n' +
                '        elif isinstance(rule,ExpRule): st.append({"title":"Exponential","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"ExpRule"})\n' +
                '        elif isinstance(rule,PowerRule): st.append({"title":"Power rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"PowerRule"})\n' +
                '        elif isinstance(rule,ConstantRule): st.append({"title":"Constant","latex":r"\\\\int "+latex(rule.constant)+r" \\\\,d"+vs+r" = "+latex(res),"rule":"ConstantRule"})\n' +
                '        elif isinstance(rule,TrigSubstitutionRule):\n' +
                '            st.append({"title":"Trig substitution","latex":r"Let\\\\ "+vs+r" = "+latex(rule.func)+r",\\\\quad d"+vs+r" = "+latex(diff(rule.func,rule.theta))+r"\\\\,d"+latex(rule.theta),"rule":"TrigSubstitutionRule"}); st.append({"title":"Rewrite integrand","latex":r"\\\\int "+latex(rule.rewritten)+r" \\\\,d"+latex(rule.theta),"rule":"TrigSubstitutionRule"}); r2s(rule.substep,v,st); st.append({"title":"Back substitute","latex":"= "+latex(res)+r" + C","rule":"TrigSubstitutionRule"}) if res else None\n' +
                '        elif isinstance(rule,(SinRule,CosRule)): st.append({"title":"Trig rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"TrigRule"})\n' +
                '        elif isinstance(rule,(SinhRule,CoshRule)): st.append({"title":"Hyperbolic rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"HyperbolicRule"})\n' +
                '        elif isinstance(rule,(Sec2Rule,Csc2Rule)): st.append({"title":"Trig rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"TrigRule"})\n' +
                '        elif isinstance(rule,(SecTanRule,CscCotRule)): st.append({"title":"Trig rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"TrigRule"})\n' +
                '        elif isinstance(rule,ArcsinRule): st.append({"title":"Arcsin","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"ArcsinRule"})\n' +
                '        elif isinstance(rule,ArcsinhRule): st.append({"title":"Arcsinh","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"ArcsinhRule"})\n' +
                '        elif isinstance(rule,CompleteSquareRule):\n' +
                '            st.append({"title":"Complete the square","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = \\\\int "+latex(rule.rewritten)+r" \\\\,d"+vs,"rule":"CompleteSquareRule"}); r2s(rule.substep,v,st)\n' +
                '        elif isinstance(rule,CyclicPartsRule):\n' +
                '            prs=rule.parts_rules\n' +
                '            for i,pr in enumerate(prs): st.append({"title":"By parts (round "+str(i+1)+")","latex":r"u = "+latex(pr.u)+r",\\\\ dv = "+latex(pr.dv)+r" \\\\,d"+vs,"rule":"CyclicPartsRule"})\n' +
                '            st.append({"title":"Solve for integral","latex":"= "+latex(res)+r" + C","rule":"CyclicPartsRule"}) if res else None\n' +
                '        elif isinstance(rule,(SqrtQuadraticRule,ReciprocalSqrtQuadraticRule)): st.append({"title":"Standard form","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":type(rule).__name__})\n' +
                '        elif isinstance(rule,PiecewiseRule):\n' +
                '            st.append({"title":"Piecewise","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs,"rule":"PiecewiseRule"})\n' +
                '            for sc in (rule.subfunctions if hasattr(rule,"subfunctions") else []): r2s(sc,v,st)\n' +
                '            st.append({"title":"Result","latex":"= "+latex(res)+r" + C","rule":"PiecewiseRule"}) if res else None\n' +
                '        elif isinstance(rule,ErfRule): st.append({"title":"Error function","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"ErfRule"})\n' +
                '        elif isinstance(rule,(SiRule,LiRule,EiRule,CiRule,ChiRule,ShiRule)): st.append({"title":"Special function","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":type(rule).__name__})\n' +
                '        elif isinstance(rule,UpperGammaRule): st.append({"title":"Upper incomplete gamma","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"UpperGammaRule"})\n' +
                '        elif isinstance(rule,(FresnelCRule,FresnelSRule)): st.append({"title":"Fresnel integral","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":type(rule).__name__})\n' +
                '        elif isinstance(rule,(EllipticERule,EllipticFRule)): st.append({"title":"Elliptic integral","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":type(rule).__name__})\n' +
                '        elif isinstance(rule,DiracDeltaRule): st.append({"title":"Dirac delta","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"DiracDeltaRule"})\n' +
                '        elif isinstance(rule,HeavisideRule):\n' +
                '            st.append({"title":"Heaviside step","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs,"rule":"HeavisideRule"}); r2s(rule.substep,v,st); st.append({"title":"Result","latex":"= "+latex(res)+r" + C","rule":"HeavisideRule"}) if res else None\n' +
                '        elif isinstance(rule,NestedPowRule): st.append({"title":"Nested power","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = \\\\int "+vs+r"^{"+latex(rule.exp)+r"} \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"NestedPowRule"})\n' +
                '        elif isinstance(rule,DerivativeRule): st.append({"title":"Derivative rule","latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C","rule":"DerivativeRule"})\n' +
                '        elif isinstance(rule,AlternativeRule): [r2s(a,v,st) for a in rule.alternatives[:1]]; st.append({"title":"Result","latex":"= "+latex(res)+r" + C"}) if not st and res else None\n' +
                '        else: st.append({"title":type(rule).__name__.replace("Rule",""),"latex":r"\\\\int "+latex(ctx)+r" \\\\,d"+vs+r" = "+latex(res)+r" + C"}) if ctx and res else None\n' +
                '    except: st.append({"title":"Result","latex":"= "+latex(res)+r" + C"}) if res else None\n' +
                '    return st\n' +
                'try:\n' +
                '    ' + buildSympySymbolsDecl(v, pyExpr) + '\n' +
                '    expr = ' + pyExpr + '\n' +
                '    steps = integral_steps(expr, ' + v + ')\n' +
                '    st = []\n' +
                '    if steps and not isinstance(steps, DontKnowRule):\n' +
                '        result = integrate(expr, ' + v + ')\n' +
                '        st = r2s(steps, ' + v + ')\n' +
                '        if not st and result: st = [{"title":"Result","latex":r"\\\\int "+latex(expr)+" \\\\,d"+str(' + v + ')+" = "+latex(result)+r" + C"}]\n' +
                '    else:\n' +
                '        import signal\n' +
                '        class _TO(Exception): pass\n' +
                '        def _th(s,f): raise _TO()\n' +
                '        old_h = signal.signal(signal.SIGALRM, _th)\n' +
                '        signal.alarm(10)\n' +
                '        try: result = integrate(expr, ' + v + ')\n' +
                '        except _TO: result = None\n' +
                '        finally:\n' +
                '            signal.alarm(0)\n' +
                '            signal.signal(signal.SIGALRM, old_h)\n' +
                '        if result and not isinstance(result, Integral) and not result.has(Integral):\n' +
                '            try: pf = apart(expr, ' + v + ')\n' +
                '            except: pf = expr\n' +
                '            did_decompose = False\n' +
                '            if pf != expr:\n' +
                '                st.append({"title":"Partial fraction decomposition","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = \\\\\\\\int "+latex(pf)+r" \\\\,d' + v + '"})\n' +
                '                terms = Add.make_args(pf)\n' +
                '                for t in terms:\n' +
                '                    t_steps = integral_steps(t, ' + v + ')\n' +
                '                    t_int = integrate(t, ' + v + ')\n' +
                '                    if t_steps and not isinstance(t_steps, DontKnowRule):\n' +
                '                        r2s(t_steps, ' + v + ', st)\n' +
                '                    elif t_int and not isinstance(t_int, Integral):\n' +
                '                        st.append({"title":"Integrate term","latex":r"\\\\int "+latex(t)+r" \\\\,d' + v + ' = "+latex(t_int)+r" + C"})\n' +
                '                st.append({"title":"Combine","latex":"= "+latex(result)+r" + C"})\n' +
                '                did_decompose = True\n' +
                '            if not did_decompose:\n' +
                '                r_terms = Add.make_args(result)\n' +
                '                if len(r_terms) > 1:\n' +
                '                    st.append({"title":"Decompose result","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = "+latex(result)+r" + C"})\n' +
                '                    for rt in r_terms:\n' +
                '                        d_rt = diff(rt, ' + v + ')\n' +
                '                        t_steps = integral_steps(d_rt, ' + v + ')\n' +
                '                        if t_steps and not isinstance(t_steps, DontKnowRule):\n' +
                '                            r2s(t_steps, ' + v + ', st)\n' +
                '                        else:\n' +
                '                            st.append({"title":"Integrate term","latex":r"\\\\int "+latex(d_rt)+r" \\\\,d' + v + ' = "+latex(rt)+r" + C"})\n' +
                '                    st.append({"title":"Combine","latex":"= "+latex(result)+r" + C"})\n' +
                '                else:\n' +
                '                    st.append({"title":"Antiderivative","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = "+latex(result)+r" + C"})\n' +
                '        elif not result or isinstance(result, Integral) or result.has(Integral):\n' +
                '            result = None\n' +
                '            numer, denom = expr.as_numer_denom()\n' +
                '            denom_factored = factor(denom)\n' +
                '            denom_factors = Mul.make_args(denom_factored)\n' +
                '            rat_f = []; irr_f = []; sqrt_inner = None\n' +
                '            for _f in denom_factors:\n' +
                '                _hi = False; _atoms = _f.atoms(Pow) if not isinstance(_f, Pow) else {_f}\n' +
                '                for _a in _atoms:\n' +
                '                    if isinstance(_a, Pow) and not _a.exp.is_integer:\n' +
                '                        _hi = True\n' +
                '                        if _a.exp == Rational(1,2): sqrt_inner = _a.base\n' +
                '                        break\n' +
                '                if _hi: irr_f.append(_f)\n' +
                '                else: rat_f.append(_f)\n' +
                '            rat_d = Mul(*rat_f) if rat_f else S.One\n' +
                '            irr_p = Mul(*irr_f) if irr_f else S.One\n' +
                '            st.append({"title":"Identify the integral","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + '"})\n' +
                '            if rat_d != S.One:\n' +
                '                uf = expand(rat_d); ff = factor(rat_d)\n' +
                '                if len(Mul.make_args(ff)) > 1 and ff != uf:\n' +
                '                    st.append({"title":"Factor the polynomial part of denominator","latex":latex(uf)+" = "+latex(ff)})\n' +
                '            if sqrt_inner is not None:\n' +
                '                try:\n' +
                '                    _p = Poly(sqrt_inner, ' + v + ')\n' +
                '                    if _p.degree() == 2:\n' +
                '                        _a,_b,_c = _p.all_coeffs()\n' +
                '                        if _b != 0:\n' +
                '                            _h = Rational(_b, 2*_a); _k = _c - _b**2/(4*_a)\n' +
                '                            _comp = _a*(' + v + '+_h)**2+_k\n' +
                '                            st.append({"title":"Complete the square under the radical","latex":r"\\\\sqrt{"+latex(sqrt_inner)+r"} = \\\\sqrt{"+latex(_comp)+"}"})\n' +
                '                except: pass\n' +
                '            if rat_d != S.One:\n' +
                '                _re = numer/rat_d\n' +
                '                try: _pf = apart(_re, ' + v + ')\n' +
                '                except: _pf = _re\n' +
                '                if _pf != _re:\n' +
                '                    st.append({"title":"Partial fraction decomposition","latex":latex(_re)+" = "+latex(_pf)})\n' +
                '                    _terms = Add.make_args(_pf)\n' +
                '                    _ti = [simplify(_t/irr_p) for _t in _terms]\n' +
                '                    _sl = " + ".join([r"\\\\int "+latex(_t)+r" \\\\,d' + v + '" for _t in _ti])\n' +
                '                    st.append({"title":"Split the integral","latex":r"\\\\int "+latex(expr)+r" \\\\,d' + v + ' = "+_sl})\n' +
                '                    for _t in _ti:\n' +
                '                        _tr = integrate(_t, ' + v + ')\n' +
                '                        if _tr and not isinstance(_tr, Integral) and not _tr.has(Integral):\n' +
                '                            st.append({"title":"Integrate term","latex":r"\\\\int "+latex(_t)+r" \\\\,d' + v + ' = "+latex(_tr)})\n' +
                '                        else:\n' +
                '                            st.append({"title":"Non-elementary sub-integral","latex":r"\\\\int "+latex(_t)+r" \\\\,d' + v + ' \\\\\\\\text{ has no elementary closed form}"})\n' +
                '            st.append({"title":"Conclusion","latex":r"\\\\text{This integral cannot be expressed using elementary functions. For definite integrals, numerical methods give the exact value.}"})\n' +
                '    print("STEPS:" + (json.dumps(st, separators=(",",":")) if st else "[]"))\n' +
                '    print("RESULT=" + (latex(result) if result else ""))\n' +
                '    print("EXPR=" + latex(expr))\n' +
                '    print("RULES=" + (str(steps) if steps else ""))\n' +
                'except Exception as e:\n' +
                '    print("STEPS:[]")\n' +
                '    print("RESULT=")\n' +
                '    print("RULES=")\n';
            }

            var controller = new AbortController();
            var timeoutId = setTimeout(function() { controller.abort(); }, 180000);

            fetch((window.INTEGRAL_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
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
                    // Only fail on real errors, not SymPy deprecation warnings
                    if (stderr && /error|exception|traceback/i.test(stderr) && !stdout) { cb(null); return; }
                    var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\nRESULT|\nEXPR|\nRULES|$)/);
                    var resultMatch = stdout.match(/RESULT=(.*?)(?:\n|$)/s);
                    var exprMatch = stdout.match(/EXPR=([\s\S]*?)(?=\nRULES|$)/);
                    var rulesMatch = stdout.match(/RULES=([\s\S]*?)(?=\nRESULT|\nRULES|$)/s);
                    var stepsJson = stepsMatch ? stepsMatch[1] : '';
                    var resultLatex = resultMatch && resultMatch[1] ? resultMatch[1].trim() : '';
                    var exprLatex = exprMatch && exprMatch[1] ? exprMatch[1].trim() : '';
                    var rulesStr = rulesMatch && rulesMatch[1] ? rulesMatch[1].trim() : '';
                    var stepsArr = [];
                    try { if (stepsJson) stepsArr = JSON.parse(stepsJson); } catch (e) {}
                    if (stepsArr.length > 0) {
                        cb({ paths: [{ name: 'Solution', steps: stepsArr, rules: [] }] });
                        return;
                    }
                    if (!resultLatex || !rulesStr) { cb(null); return; }
                    cb(parseSympyOutput(expr, v, resultLatex, rulesStr, exprLatex));
                })
                .catch(function() {
                    clearTimeout(timeoutId);
                    cb(null);
                });
        }

        function doShowSteps() {
            if (!lastIntegrationContext) return;
            var ctx = lastIntegrationContext;
            var stepsBtn = document.getElementById('ic-steps-btn');

            // 1. Try template steps first
            var templateSteps = generateTemplateSteps(ctx.expr, ctx.v, ctx.resultTeX, ctx.method);
            if (templateSteps && templateSteps.length > 0) {
                renderSteps(templateSteps, ctx.method, false);
                if (stepsBtn) stepsBtn.style.display = 'none';
                return;
            }

            // 2. SymPy steps: use cache only if it has multiple steps (full solution, not just eval-at-bounds).
            var cached = ctx.sympyStepsCache;
            var cachedSteps = cached && cached.paths && cached.paths[0] && cached.paths[0].steps;
            var useCached = cachedSteps && cachedSteps.length > 1;
            if (useCached) {
                renderStepsWithTabs(cached.paths, ctx.method || 'Advanced Solver');
                if (stepsBtn) stepsBtn.style.display = 'none';
                return;
            }

            if (stepsBtn) {
                stepsBtn.classList.add('loading');
                stepsBtn.innerHTML = '<span class="ic-spinner"></span> Generating steps\u2026';
            }

            var fetchOpts = { mode: ctx.mode, a: ctx.a, b: ctx.b };
            fetchSympySteps(ctx.expr, ctx.v, function(sympyData) {
                if (sympyData && sympyData.paths) {
                    renderStepsWithTabs(sympyData.paths, ctx.method || 'Advanced Solver');
                    if (stepsBtn) stepsBtn.style.display = 'none';
                    return;
                }
                var payload = {
                    operation: 'integrate',
                    expression: ctx.expr,
                    variable: ctx.v,
                    answer: ctx.resultText
                };
                if (ctx.mode === 'definite' && ctx.a && ctx.b) {
                    payload.bounds = { lower: ctx.a, upper: ctx.b };
                }
                fetch((window.INTEGRAL_CALC_CTX || '') + '/CFExamMarkerFunctionality?action=math_steps', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                })
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.success && data.steps && data.steps.length > 0) {
                            renderSteps(data.steps, data.method || ctx.method, true);
                        } else {
                            renderStepsError(data.error || 'Could not generate steps');
                        }
                        if (stepsBtn) stepsBtn.style.display = 'none';
                    })
                    .catch(function(err) {
                        renderStepsError('Network error. Please try again.');
                        if (stepsBtn) {
                            stepsBtn.classList.remove('loading');
                            stepsBtn.innerHTML = '\u{1F4DD} Show Steps';
                        }
                    });
            }, fetchOpts);
        };
        window.showSteps = doShowSteps;

        /** Prepare LaTeX for KaTeX rendering. Pass through if already LaTeX; only wrap plain text.
         *  LaTeX can have \\ (commands), ^{} (superscripts), _{} (subscripts) — never wrap those. */
        function prepareLatexForKatex(latex) {
            if (!latex || typeof latex !== 'string') return latex;
            /* Normalize double-backslashes to single backslashes.
               SymPy's latex() output goes through json.dumps → JSON.parse, which
               causes commands like \int, \frac, \quad to arrive as \\int, \\frac etc.
               KaTeX needs single-backslash commands, so we collapse every \\ → \. */
            latex = latex.replace(/\\\\/g, '\\');
            var hasLatex = /\\|[\^_]|\{[^}]*\}/.test(latex);
            if (!hasLatex) {
                /* Pure plain text — wrap entirely in \text{} */
                return '\\text{' + latex.replace(/\\/g, '\\\\').replace(/}/g, '\\}') + '}';
            }
            /* Mixed content (AI-generated or SymPy): wrap sequences of 2+ English words
               (each 2+ chars) in \text{} so spaces are preserved in KaTeX math mode.
               Matches: "Use the substitution method" but not single-char variables like u, x */
            latex = latex.replace(/((?:[A-Za-z]{2,} ){2,}[A-Za-z]{2,})/g, '\\text{$1}');
            /* Wrap leading words like "Let", "Solve" before math (common in SymPy steps) */
            latex = latex.replace(/^([A-Z][a-z]+)\\ /g, '\\text{$1} ');
            return latex;
        }

        var STEP_COLLAPSE_THRESHOLD = 8; // collapse if more than this many steps
        var STEP_VISIBLE_HEAD = 3;        // show first N steps when collapsed
        var STEP_VISIBLE_TAIL = 2;        // show last N steps when collapsed

        function renderSteps(steps, method, isAI) {
            var container = document.getElementById('ic-steps-area');
            if (!container) return;
            var shouldCollapse = steps.length > STEP_COLLAPSE_THRESHOLD;

            var html = '<div class="ic-steps-container">';
            html += '<div class="ic-steps-header">';
            html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
            html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
            if (isAI) {
                html += '<span class="ic-steps-ai-badge">AI Generated</span>';
            }
            html += '</div>';

            html += '<div class="ic-steps-scroll' + (shouldCollapse ? ' collapsed' : '') + '">';
            for (var i = 0; i < steps.length; i++) {
                var hidden = shouldCollapse && i >= STEP_VISIBLE_HEAD && i < steps.length - STEP_VISIBLE_TAIL;
                html += '<div class="ic-step' + (hidden ? ' ic-step-hidden' : '') + '">';
                html += '<span class="ic-step-num">' + (i + 1) + '</span>';
                html += '<div class="ic-step-body">';
                html += '<div class="ic-step-title">' + escapeHtml(steps[i].title) + '</div>';
                html += '<div class="ic-step-math" id="ic-step-math-' + i + '"></div>';
                html += '</div></div>';
                if (hidden && i === STEP_VISIBLE_HEAD) {
                    var hiddenCount = steps.length - STEP_VISIBLE_HEAD - STEP_VISIBLE_TAIL;
                    html += '<button type="button" class="ic-steps-expand-btn" id="ic-steps-expand">';
                    html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>';
                    html += 'Show all ' + steps.length + ' steps (' + hiddenCount + ' hidden)';
                    html += '</button>';
                }
            }
            html += '</div></div>';
            container.innerHTML = html;

            for (var j = 0; j < steps.length; j++) {
                var el = document.getElementById('ic-step-math-' + j);
                if (el && steps[j].latex) {
                    try {
                        var prepared = prepareLatexForKatex(steps[j].latex);
                        katex.render(prepared, el, { displayMode: true, throwOnError: false });
                    } catch (e) {
                        el.textContent = steps[j].latex;
                    }
                }
            }

            if (shouldCollapse) {
                var expandBtn = document.getElementById('ic-steps-expand');
                if (expandBtn) {
                    expandBtn.addEventListener('click', function() {
                        var scroll = container.querySelector('.ic-steps-scroll');
                        if (!scroll) return;
                        var isCollapsed = scroll.classList.contains('collapsed');
                        scroll.classList.toggle('collapsed');
                        var hiddenCount = steps.length - STEP_VISIBLE_HEAD - STEP_VISIBLE_TAIL;
                        this.innerHTML = isCollapsed
                            ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>Collapse steps (' + hiddenCount + ' shown)'
                            : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>Show all ' + steps.length + ' steps (' + hiddenCount + ' hidden)';
                    });
                }
            }
        }

        /** SymPy steps with tabs: paths = [{name, steps, rules}, ...]. Tabs = path names, or "All" + rule names per path. */
        function renderStepsWithTabs(paths, method) {
            var container = document.getElementById('ic-steps-area');
            if (!container || !paths || paths.length === 0) return;
            var totalSteps = 0;
            for (var ti = 0; ti < paths.length; ti++) totalSteps += (paths[ti].steps || []).length;

            var html = '<div class="ic-steps-container">';
            html += '<div class="ic-steps-header">';
            html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
            html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + totalSteps + ')</span>';
            html += '<span class="ic-steps-cas-badge">CAS</span>';
            html += '</div>';

            var hasMultiplePaths = paths.length > 1;
            var firstPath = paths[0];
            var firstRules = (firstPath.rules || []).filter(Boolean);
            var hasMultipleRules = firstRules.length > 1;

            if (hasMultiplePaths) {
                html += '<div class="ic-steps-tabs">';
                for (var p = 0; p < paths.length; p++) {
                    html += '<button type="button" class="ic-step-tab' + (p === 0 ? ' active' : '') + '" data-path="' + p + '">' + escapeHtml(paths[p].name) + '</button>';
                }
                html += '</div>';
            } else if (hasMultipleRules) {
                html += '<div class="ic-steps-tabs">';
                html += '<button type="button" class="ic-step-tab active" data-filter="all">All</button>';
                for (var r = 0; r < firstRules.length; r++) {
                    var rn = firstRules[r];
                    html += '<button type="button" class="ic-step-tab" data-filter="' + escapeHtml(rn) + '">' + escapeHtml(ruleDisplayNames[rn] || rn) + '</button>';
                }
                html += '</div>';
            }

            html += '<div class="ic-steps-panels">';
            for (var pi = 0; pi < paths.length; pi++) {
                var path = paths[pi];
                var steps = path.steps || [];
                var shouldCollapse = steps.length > STEP_COLLAPSE_THRESHOLD;
                html += '<div class="ic-steps-panel' + (pi === 0 ? ' active' : '') + '" data-path="' + pi + '">';
                html += '<div class="ic-steps-scroll' + (shouldCollapse ? ' collapsed' : '') + '" data-panel="' + pi + '">';
                for (var si = 0; si < steps.length; si++) {
                    var st = steps[si];
                    var ruleCls = st.rule ? ' ic-step-rule-' + st.rule : '';
                    var hidden = shouldCollapse && si >= STEP_VISIBLE_HEAD && si < steps.length - STEP_VISIBLE_TAIL;
                    html += '<div class="ic-step' + ruleCls + (hidden ? ' ic-step-hidden' : '') + '" data-rule="' + (st.rule || '') + '">';
                    html += '<span class="ic-step-num">' + (si + 1) + '</span>';
                    html += '<div class="ic-step-body">';
                    html += '<div class="ic-step-title">' + escapeHtml(st.title) + '</div>';
                    html += '<div class="ic-step-math" id="ic-step-math-' + pi + '-' + si + '"></div>';
                    html += '</div></div>';
                    if (hidden && si === STEP_VISIBLE_HEAD) {
                        var hiddenCount = steps.length - STEP_VISIBLE_HEAD - STEP_VISIBLE_TAIL;
                        html += '<button type="button" class="ic-steps-expand-btn" data-expand-panel="' + pi + '">';
                        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>';
                        html += 'Show all ' + steps.length + ' steps (' + hiddenCount + ' hidden)';
                        html += '</button>';
                    }
                }
                html += '</div></div>';
            }
            html += '</div></div>';
            container.innerHTML = html;

            for (var pi2 = 0; pi2 < paths.length; pi2++) {
                var s = paths[pi2].steps || [];
                for (var si2 = 0; si2 < s.length; si2++) {
                    var el = document.getElementById('ic-step-math-' + pi2 + '-' + si2);
                    if (el && s[si2].latex) {
                        try {
                            katex.render(prepareLatexForKatex(s[si2].latex), el, { displayMode: true, throwOnError: false });
                        } catch (e) {
                            el.textContent = s[si2].latex;
                        }
                    }
                }
            }

            container.querySelectorAll('.ic-step-tab').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var pathIdx = this.getAttribute('data-path');
                    var filter = this.getAttribute('data-filter');
                    container.querySelectorAll('.ic-step-tab').forEach(function(b) { b.classList.remove('active'); });
                    this.classList.add('active');
                    if (filter !== null) {
                        var panel = container.querySelector('.ic-steps-panel.active');
                        var steps = panel ? panel.querySelectorAll('.ic-step') : container.querySelectorAll('.ic-step');
                        steps.forEach(function(s) {
                            s.style.display = (filter === 'all' || s.getAttribute('data-rule') === filter) ? '' : 'none';
                        });
                    } else if (pathIdx !== null && paths.length > 1) {
                        container.querySelectorAll('.ic-steps-panel').forEach(function(p) {
                            p.classList.toggle('active', p.getAttribute('data-path') === pathIdx);
                        });
                    }
                });
            });

            // Expand/collapse buttons for panels with many steps
            container.querySelectorAll('.ic-steps-expand-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var panelIdx = this.getAttribute('data-expand-panel');
                    var scroll = container.querySelector('.ic-steps-scroll[data-panel="' + panelIdx + '"]');
                    if (!scroll) return;
                    var isCollapsed = scroll.classList.contains('collapsed');
                    scroll.classList.toggle('collapsed');
                    var panelSteps = paths[parseInt(panelIdx)].steps || [];
                    var hiddenCount = panelSteps.length - STEP_VISIBLE_HEAD - STEP_VISIBLE_TAIL;
                    this.innerHTML = isCollapsed
                        ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>Collapse steps (' + hiddenCount + ' shown)'
                        : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>Show all ' + panelSteps.length + ' steps (' + hiddenCount + ' hidden)';
                });
            });
        }

        function renderStepsError(msg) {
            var container = document.getElementById('ic-steps-area');
            if (!container) return;
            container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">' + escapeHtml(msg) + '</div>';
        }

        // ========== Graph ==========
        function prepareGraph(exprStr, v, antiderivStr, mode, a, b) {
            pendingGraph = { expr: exprStr, v: v, antideriv: antiderivStr, mode: mode, a: a, b: b };
            if (graphHint) graphHint.style.display = 'none';

            // If graph tab is already active, render immediately
            var graphPanel = document.getElementById('ic-panel-graph');
            if (graphPanel.classList.contains('active')) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
        }

        function renderGraph(cfg) {
            if (!window.Plotly) return;
            var container = document.getElementById('ic-graph-container');

            var xMin, xMax;
            if (cfg.mode === 'definite' && cfg.a !== null && cfg.b !== null) {
                var aNum = evalBound(cfg.a);
                var bNum = evalBound(cfg.b);
                var range = Math.abs(bNum - aNum) || 2;
                xMin = aNum - range * 0.5;
                xMax = bNum + range * 0.5;
            } else {
                xMin = -10;
                xMax = 10;
            }

            var n = 500;
            var xs = [], ysFx = [], ysFxAntideriv = [];
            var step = (xMax - xMin) / n;

            for (var i = 0; i <= n; i++) {
                var xVal = xMin + i * step;
                xs.push(xVal);
                ysFx.push(evalAtPoint(cfg.expr, cfg.v, xVal));
                if (cfg.antideriv) {
                    ysFxAntideriv.push(evalAtPoint(cfg.antideriv, cfg.v, xVal));
                }
            }

            var traces = [];

            // f(x) trace
            traces.push({
                x: xs, y: ysFx,
                type: 'scatter', mode: 'lines',
                name: 'f(' + cfg.v + ') = ' + cfg.expr,
                line: { color: '#4f46e5', width: 2.5 }
            });

            if (cfg.mode === 'indefinite' && cfg.antideriv) {
                // F(x) trace
                traces.push({
                    x: xs, y: ysFxAntideriv,
                    type: 'scatter', mode: 'lines',
                    name: 'F(' + cfg.v + ') (antiderivative)',
                    line: { color: '#10b981', width: 2, dash: 'dash' }
                });
            }

            if (cfg.mode === 'definite' && cfg.a !== null && cfg.b !== null) {
                // Shaded area
                var aNum = evalBound(cfg.a);
                var bNum = evalBound(cfg.b);
                var fillXs = [], fillYs = [];
                var fillN = 200;
                var fillStep = (bNum - aNum) / fillN;
                for (var j = 0; j <= fillN; j++) {
                    var fx = aNum + j * fillStep;
                    fillXs.push(fx);
                    fillYs.push(evalAtPoint(cfg.expr, cfg.v, fx));
                }
                // Close the area to x-axis
                fillXs.push(bNum); fillYs.push(0);
                fillXs.push(aNum); fillYs.push(0);

                traces.push({
                    x: fillXs, y: fillYs,
                    type: 'scatter', mode: 'lines',
                    fill: 'toself',
                    fillcolor: 'rgba(79, 70, 229, 0.15)',
                    line: { color: 'rgba(79, 70, 229, 0.3)', width: 0 },
                    name: 'Area [' + cfg.a + ', ' + cfg.b + ']',
                    showlegend: true
                });
            }

            var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
            var layout = {
                margin: { t: 30, r: 20, b: 40, l: 50 },
                xaxis: { title: cfg.v, gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: isDark ? '#475569' : '#cbd5e1', color: isDark ? '#cbd5e1' : '#475569' },
                yaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: isDark ? '#475569' : '#cbd5e1', color: isDark ? '#cbd5e1' : '#475569' },
                paper_bgcolor: isDark ? '#1e293b' : '#fff',
                plot_bgcolor: isDark ? '#1e293b' : '#fff',
                font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#cbd5e1' : '#475569' },
                legend: { x: 0, y: 1.12, orientation: 'h', font: { size: 11 } },
                showlegend: true
            };

            Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
        }

        function evalAtPoint(exprStr, v, xVal) {
            try {
                var scope = {};
                scope[v] = xVal;
                var val = parseFloat(nerdamer(exprStr).evaluate(scope).text('decimals'));
                if (!isFinite(val) || Math.abs(val) > 1e6) return null;
                return val;
            } catch (e) {
                return null;
            }
        }

        // ========== Python Compiler ==========
        function buildCompilerCode(template) {
            var expr = normalizeExpr(exprInput.value.trim()) || 'x**2';
            var pyExpr = nerdamerToPython(expr);
            var v = varSelect.value;
            var a = lowerInput.value.trim() || '0';
            var b = upperInput.value.trim() || '1';

            var symDecl = buildSympySymbolsDecl(v, pyExpr);
            if (template === 'symbolic-indef') {
                return 'from sympy import *\n\n' + symDecl + '\nexpr = ' + pyExpr + '\n\nresult = integrate(expr, ' + v + ')\nprint("Integral:")\npprint(result)\nprint("\\nLaTeX:", latex(result))';
            } else if (template === 'symbolic-def') {
                return 'from sympy import *\n\n' + symDecl + '\nexpr = ' + pyExpr + '\n\nresult = integrate(expr, (' + v + ', ' + a + ', ' + b + '))\nprint("Definite integral from ' + a + ' to ' + b + ':")\npprint(result)\nprint("\\nNumeric:", float(result))';
            } else {
                // SciPy: needs math.* prefixes; sec/csc/cot must be expanded
                var scipyExpr = pyExpr
                    .replace(/sec\(([^)]+)\)/g, '(1/math.cos($1))')
                    .replace(/csc\(([^)]+)\)/g, '(1/math.sin($1))')
                    .replace(/cot\(([^)]+)\)/g, '(math.cos($1)/math.sin($1))')
                    .replace(/sinh\(/g, 'math.sinh(')
                    .replace(/cosh\(/g, 'math.cosh(')
                    .replace(/tanh\(/g, 'math.tanh(')
                    .replace(/asin\(/g, 'math.asin(')
                    .replace(/acos\(/g, 'math.acos(')
                    .replace(/atan\(/g, 'math.atan(')
                    .replace(/sin\(/g, 'math.sin(')
                    .replace(/cos\(/g, 'math.cos(')
                    .replace(/tan\(/g, 'math.tan(')
                    .replace(/exp\(/g, 'math.exp(')
                    .replace(/sqrt\(/g, 'math.sqrt(')
                    .replace(/log\(/g, 'math.log(')
                    .replace(/abs\(/g, 'math.fabs(')
                    .replace(/\bpi\b/g, 'math.pi');
                return 'from scipy.integrate import quad\nimport math\n\ndef f(' + v + '):\n    return ' + scipyExpr + '\n\nresult, error = quad(f, ' + a + ', ' + b + ')\nprint(f"Numerical integral: {result}")\nprint(f"Error estimate: {error}")';
            }
        }

        function loadCompilerWithTemplate() {
            var template = document.getElementById('ic-compiler-template').value;
            var code = buildCompilerCode(template);
            var b64Code = btoa(unescape(encodeURIComponent(code)));
            var config = JSON.stringify({ lang: 'python', code: b64Code });
            var iframe = document.getElementById('ic-compiler-iframe');
            iframe.src = (window.INTEGRAL_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
        }

        document.getElementById('ic-compiler-template').addEventListener('change', function() {
            loadCompilerWithTemplate();
        });

        // ========== Copy / Share ==========
        document.getElementById('ic-copy-latex-btn').addEventListener('click', function() {
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
            } else {
                navigator.clipboard.writeText(lastResultLatex);
            }
        });

        document.getElementById('ic-copy-text-btn').addEventListener('click', function() {
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.copyToClipboard(lastResultText, 'Result copied!');
            } else {
                navigator.clipboard.writeText(lastResultText);
            }
        });

        document.getElementById('ic-share-btn').addEventListener('click', function() {
            var params = { expr: exprInput.value, v: varSelect.value, mode: currentMode };
            if (currentMode === 'definite') {
                params.a = lowerInput.value;
                params.b = upperInput.value;
            }
            if (typeof ToolUtils !== 'undefined') {
                var url = ToolUtils.generateShareUrl(params, { toolName: 'Integral Calculator' });
                ToolUtils.copyToClipboard(url, 'Share URL copied!');
            }
        });

        // ========== Download PDF ==========
        document.getElementById('ic-download-pdf-btn').addEventListener('click', function() {
            downloadResultPdf();
        });

        function downloadResultPdf() {
            if (!lastIntegrationContext) {
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
                return;
            }

            var ctx = lastIntegrationContext;
            var exprTeX = exprToLatex(ctx.expr);

            // Build a clean off-screen container for capture
            var container = document.createElement('div');
            container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
            document.body.appendChild(container);

            // Title
            var title = document.createElement('div');
            title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#4f46e5;';
            title.textContent = 'Integral Calculator — 8gwifi.org';
            container.appendChild(title);

            var divider = document.createElement('div');
            divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#4f46e5,#6366f1,transparent);margin-bottom:24px;';
            container.appendChild(divider);

            // Question section
            var qLabel = document.createElement('div');
            qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
            qLabel.textContent = ctx.mode === 'definite' ? 'Definite Integral' : 'Indefinite Integral';
            container.appendChild(qLabel);

            var qMath = document.createElement('div');
            qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
            container.appendChild(qMath);

            if (ctx.mode === 'definite') {
                katex.render('\\int_{' + ctx.a + '}^{' + ctx.b + '} ' + exprTeX + ' \\, d' + ctx.v, qMath, { displayMode: true, throwOnError: false });
            } else {
                katex.render('\\int ' + exprTeX + ' \\, d' + ctx.v, qMath, { displayMode: true, throwOnError: false });
            }

            // Answer section
            var aLabel = document.createElement('div');
            aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
            aLabel.textContent = 'Result';
            container.appendChild(aLabel);

            var aMath = document.createElement('div');
            aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#eef2ff;border-radius:8px;';
            container.appendChild(aMath);

            if (ctx.mode === 'definite') {
                katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false });
            } else {
                katex.render(ctx.resultTeX + ' + C', aMath, { displayMode: true, throwOnError: false });
            }

            // Method badge
            var methodDiv = document.createElement('div');
            methodDiv.style.cssText = 'font-size:13px;color:#64748b;margin-bottom:20px;';
            methodDiv.textContent = 'Method: ' + ctx.method;
            container.appendChild(methodDiv);

            // Include steps if they've been rendered
            var stepsArea = document.getElementById('ic-steps-area');
            if (stepsArea && stepsArea.children.length > 0) {
                var stepsLabel = document.createElement('div');
                stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
                stepsLabel.textContent = 'Step-by-Step Solution';
                container.appendChild(stepsLabel);

                var stepEls = stepsArea.querySelectorAll('.ic-step');
                for (var i = 0; i < stepEls.length; i++) {
                    var stepRow = document.createElement('div');
                    stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                    var stepNum = document.createElement('div');
                    stepNum.style.cssText = 'width:24px;height:24px;background:#4f46e5;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                    stepNum.textContent = (i + 1);
                    stepRow.appendChild(stepNum);

                    var stepBody = document.createElement('div');
                    stepBody.style.cssText = 'flex:1;';

                    var titleEl = stepEls[i].querySelector('.ic-step-title');
                    if (titleEl) {
                        var sTitle = document.createElement('div');
                        sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                        sTitle.textContent = titleEl.textContent;
                        stepBody.appendChild(sTitle);
                    }

                    var mathEl = stepEls[i].querySelector('.ic-step-math');
                    if (mathEl) {
                        var sMath = document.createElement('div');
                        sMath.style.cssText = 'font-size:16px;';
                        // Re-render KaTeX from the katex source annotation
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
            footer.innerHTML = '<span>Generated by 8gwifi.org Integral Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
            container.appendChild(footer);

            // Capture and generate PDF
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

            // Ensure html2canvas is loaded
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

                // If the image is taller than one page, scale it down to fit
                var usableHeight = pageHeight - margin * 2;
                if (imgHeight > usableHeight) {
                    imgHeight = usableHeight;
                    imgWidth = (canvas.width * usableHeight) / canvas.height;
                }

                var x = (pageWidth - imgWidth) / 2;
                pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);

                var filename = 'integral-' + ctx.expr.replace(/[^a-zA-Z0-9]/g, '_').substring(0, 30) + '.pdf';
                pdf.save(filename);

                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
            }).catch(function(err) {
                console.error('PDF generation failed:', err);
                if (container.parentNode) document.body.removeChild(container);
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
            });
        }

        // ========== Load from URL ==========
        function loadFromUrl() {
            var urlParams = new URLSearchParams(window.location.search);
            var expr = urlParams.get('expr');
            var v = urlParams.get('v');
            var mode = urlParams.get('mode');
            var a = urlParams.get('a');
            var b = urlParams.get('b');

            if (expr) {
                exprInput.value = decodeURIComponent(expr);
            }
            if (v) {
                varSelect.value = v;
            }
            if (mode === 'definite') {
                currentMode = 'definite';
                modeBtns.forEach(function(btn) {
                    btn.classList.toggle('active', btn.getAttribute('data-mode') === 'definite');
                });
                boundsWrap.classList.add('visible');
                if (a) lowerInput.value = decodeURIComponent(a);
                if (b) upperInput.value = decodeURIComponent(b);
            }
            if (expr) {
                updatePreview();
                // Auto-integrate after short delay to let nerdamer load
                setTimeout(doIntegrate, 300);
            }
        }

        // ========== Utility ==========
        function escapeHtml(str) {
            var div = document.createElement('div');
            div.appendChild(document.createTextNode(str));
            return div.innerHTML;
        }

        // ========== Print Worksheet ==========
        function openIntegralWorksheet() {
            if (typeof WorksheetEngine !== 'undefined') {
                WorksheetEngine.open({
                    jsonUrl: 'worksheet/math/calculus/integrals.json',
                    title: 'Integrals',
                    accentColor: '#4f46e5',
                    branding: '8gwifi.org',
                    defaultCount: 20
                });
            }
        }
        var icWsBtn = document.getElementById('ic-worksheet-btn');
        if (icWsBtn) icWsBtn.addEventListener('click', openIntegralWorksheet);

        // ========== Init ==========
        window.showSteps = doShowSteps;
        loadFromUrl();

    }());
