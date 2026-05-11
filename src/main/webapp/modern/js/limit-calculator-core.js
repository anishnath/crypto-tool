/**
 * Limit Calculator — shared core logic.
 *
 * Pure-compute API (no DOM). Used by:
 *   - limit-calculator.jsp / limit-calculator.js (the live tool)
 *   - latex/static/js/math-insert.js (LaTeX editor inline solve)
 *   - limit-calculator-test (Node test harness)
 *
 * Depends on:
 *   - nerdamer (CAS, browser global or require'd)
 *   - IntegralCalculatorCore.normalizeExpr (loaded BEFORE this file)
 */
'use strict';

var LimitCalculatorCore = (function () {

    // ── 1. Normalisation borrowed from IntegralCalculatorCore ───────────────

    var normalizeExpr =
        (typeof IntegralCalculatorCore !== 'undefined' && IntegralCalculatorCore.normalizeExpr)
            ? IntegralCalculatorCore.normalizeExpr
            : function (e) { return (e && e.trim) ? e.trim() : (e || ''); };

    // Allow Node tests / non-window contexts to find nerdamer
    function getNerdamer() {
        if (typeof nerdamer !== 'undefined') return nerdamer;
        if (typeof window !== 'undefined' && window.nerdamer) return window.nerdamer;
        return null;
    }

    // ── 2. Parse a textual point ("0", "infinity", "pi", etc.) → JS value ──

    function parsePoint(pt) {
        var p = String(pt || '').trim()
            .replace(/π/g, 'pi').replace(/∞/g, 'infinity').replace(/−/g, '-')
            .replace(/²/g, '^2').replace(/³/g, '^3')
            .toLowerCase();
        if (p === 'infinity' || p === 'inf') return Infinity;
        if (p === '-infinity' || p === '-inf') return -Infinity;
        if (p === 'pi') return Math.PI;
        if (p === 'e') return Math.E;
        var val = parseFloat(p);
        return isNaN(val) ? null : val;
    }

    // ── 3. Pure compute helpers (moved from limit-calculator.js) ────────────

    function splitFraction(expr) {
        var depth = 0;
        for (var i = 0; i < expr.length; i++) {
            if (expr[i] === '(') depth++;
            else if (expr[i] === ')') depth--;
            if (depth === 0 && expr[i] === '/' && i > 0 && i < expr.length - 1) {
                return { num: expr.substring(0, i), den: expr.substring(i + 1) };
            }
        }
        return null;
    }

    function safeEval(expr, v, a) {
        try {
            var nd = getNerdamer();
            if (!nd) return null;
            var scope = {}; scope[v] = a;
            return parseFloat(nd(expr).evaluate(scope).text('decimals'));
        } catch (e) { return null; }
    }

    function checkKnownLimits(expr, v, a) {
        var e = expr.replace(/\s/g, '').toLowerCase();
        var vv = v.toLowerCase();
        if ((e === 'sin(' + vv + ')/' + vv || e === 'sin(' + vv + ')/(' + vv + ')') && a === 0)
            return { value: 1, method: 'Known Limit (sin(x)/x)' };
        if ((e === '(e^' + vv + '-1)/' + vv || e === '(e^(' + vv + ')-1)/' + vv || e === '(e^' + vv + '-1)/(' + vv + ')') && a === 0)
            return { value: 1, method: 'Known Limit ((e^x-1)/x)' };
        if (e === 'tan(' + vv + ')/' + vv && a === 0)
            return { value: 1, method: 'Known Limit (tan(x)/x)' };
        if ((e === '(1-cos(' + vv + '))/' + vv + '^2' || e === '(1-cos(' + vv + '))/(' + vv + '^2)') && a === 0)
            return { value: 0.5, method: 'Known Limit ((1-cos(x))/x²)' };
        return null;
    }

    function convergeTo(vals) {
        if (vals.length < 2) return vals.length === 1 ? vals[0] : null;
        var last = vals[vals.length - 1];
        var prev = vals[vals.length - 2];
        if (Math.abs(last) > 1e12) return last > 0 ? Infinity : -Infinity;
        if (Math.abs(last - prev) < 0.01) return Math.round(last * 1e8) / 1e8;
        return last;
    }

    function numericalLimit(expr, v, a, dir) {
        var table = { left: [], right: [] };
        var leftVals = [], rightVals = [];
        if (isFinite(a)) {
            var offsets = [0.1, 0.01, 0.001, 0.0001, 0.00001];
            if (dir !== 'right') {
                for (var i = 0; i < offsets.length; i++) {
                    var xv = a - offsets[i]; var yv = safeEval(expr, v, xv);
                    table.left.push({ x: xv, y: yv });
                    if (yv !== null && isFinite(yv)) leftVals.push(yv);
                }
            }
            if (dir !== 'left') {
                for (var j = 0; j < offsets.length; j++) {
                    var xr = a + offsets[j]; var yr = safeEval(expr, v, xr);
                    table.right.push({ x: xr, y: yr });
                    if (yr !== null && isFinite(yr)) rightVals.push(yr);
                }
            }
        } else {
            var bigVals = a === Infinity ? [10, 100, 1000, 10000, 100000] : [-10, -100, -1000, -10000, -100000];
            for (var k = 0; k < bigVals.length; k++) {
                var xb = bigVals[k]; var yb = safeEval(expr, v, xb);
                table.right.push({ x: xb, y: yb });
                if (yb !== null && isFinite(yb)) rightVals.push(yb);
            }
        }
        var leftLim = convergeTo(leftVals);
        var rightLim = convergeTo(rightVals);
        var value = null;
        if (dir === 'left') value = leftLim;
        else if (dir === 'right') value = rightLim;
        else if (leftLim !== null && rightLim !== null && Math.abs(leftLim - rightLim) < 0.001) value = (leftLim + rightLim) / 2;
        else if (!isFinite(a)) value = rightLim;
        return { value: value, leftValue: leftLim, rightValue: rightLim, table: table };
    }

    function buildApproxTable(expr, v, a, dir) {
        return numericalLimit(expr, v, a, dir).table;
    }

    function compute(expr, v, a, dir) {
        var nd = getNerdamer();
        var result = { value: null, method: 'Numerical', form: null, approxTable: null, numApprox: null };

        // Step 1: Try direct substitution
        if (isFinite(a) && nd) {
            try {
                var scope = {}; scope[v] = a;
                var val = nd(expr).evaluate(scope);
                var num = parseFloat(val.text('decimals'));
                if (isFinite(num)) {
                    result.value = num; result.method = 'Direct Substitution';
                    result.approxTable = buildApproxTable(expr, v, a, dir);
                    return result;
                }
            } catch (e) {}
        }

        // Step 2: Detect indeterminate form for fractions
        var fracParts = splitFraction(expr);
        if (fracParts && isFinite(a)) {
            var numVal = safeEval(fracParts.num, v, a);
            var denVal = safeEval(fracParts.den, v, a);
            if (numVal !== null && denVal !== null) {
                if (Math.abs(numVal) < 1e-10 && Math.abs(denVal) < 1e-10) result.form = '0/0';
                else if (!isFinite(numVal) && !isFinite(denVal)) result.form = '∞/∞';
            }
        }

        // Step 3: Try algebraic simplification
        if (nd) {
            try {
                var simplified = nd('simplify(' + expr + ')').text();
                if (simplified !== expr && isFinite(a)) {
                    var scope2 = {}; scope2[v] = a;
                    var val2 = parseFloat(nd(simplified).evaluate(scope2).text('decimals'));
                    if (isFinite(val2)) {
                        result.value = val2; result.method = 'Algebraic Simplification';
                        result.approxTable = buildApproxTable(expr, v, a, dir);
                        return result;
                    }
                }
            } catch (e) {}
        }

        // Step 4: L'Hopital for 0/0 or inf/inf
        if (fracParts && nd && (result.form === '0/0' || result.form === '∞/∞')) {
            try {
                var numExpr = fracParts.num; var denExpr = fracParts.den;
                for (var iter = 0; iter < 3; iter++) {
                    var numD = nd('diff(' + numExpr + ',' + v + ')').text();
                    var denD = nd('diff(' + denExpr + ',' + v + ')').text();
                    var newExpr = '(' + numD + ')/(' + denD + ')';
                    var scope3 = {}; scope3[v] = a;
                    var val3 = parseFloat(nd(newExpr).evaluate(scope3).text('decimals'));
                    if (isFinite(val3)) {
                        result.value = val3; result.method = "L'Hôpital's Rule";
                        result.approxTable = buildApproxTable(expr, v, a, dir);
                        return result;
                    }
                    numExpr = numD; denExpr = denD;
                }
            } catch (e) {}
        }

        // Step 5: Known limits
        var known = checkKnownLimits(expr, v, a);
        if (known !== null) {
            result.value = known.value; result.method = known.method;
            result.approxTable = buildApproxTable(expr, v, a, dir);
            return result;
        }

        // Step 6: Numerical approximation
        var approx = numericalLimit(expr, v, a, dir);
        result.approxTable = approx.table;
        if (approx.value !== null) {
            result.value = approx.value;
            result.method = 'Numerical Approximation';
            result.numApprox = approx;
        } else if (approx.leftValue !== null && approx.rightValue !== null) {
            if (dir === 'left') { result.value = approx.leftValue; result.method = 'Numerical (Left)'; }
            else if (dir === 'right') { result.value = approx.rightValue; result.method = 'Numerical (Right)'; }
            else { result.value = 'DNE'; result.method = 'Does Not Exist'; result.numApprox = approx; }
        } else if (approx.leftValue !== null) {
            result.value = approx.leftValue; result.method = 'Numerical (Left)';
        } else if (approx.rightValue !== null) {
            result.value = approx.rightValue; result.method = 'Numerical (Right)';
        } else {
            result.value = 'DNE'; result.method = 'Does Not Exist';
        }
        return result;
    }

    // ── 4. LaTeX → expression converter (for editor integration) ────────────

    function findMatchingBrace(s, openPos) {
        if (s.charAt(openPos) !== '{') return -1;
        var depth = 1;
        for (var i = openPos + 1; i < s.length; i++) {
            var c = s.charAt(i);
            if (c === '{') depth++;
            else if (c === '}') {
                depth--;
                if (depth === 0) return i;
            }
        }
        return -1;
    }

    // Convert LaTeX function-body fragments like
    //   "\frac{\sin x}{x}"  →  "(sin(x))/(x)"  (then normalizeExpr cleans it up)
    function latexBodyToExpr(latex) {
        if (!latex) return '';
        var s = String(latex);

        // Drop spacing macros, \left/\right, displaystyle, etc.
        s = s.replace(/\\(left|right|,|;|:|!|>|displaystyle|textstyle|limits|nolimits)\b/g, '');
        s = s.replace(/\\\\/g, ' ');

        // Symbols and Greek letters
        var symbols = {
            'pi': 'pi', 'theta': 'theta', 'alpha': 'alpha', 'beta': 'beta',
            'gamma': 'gamma', 'delta': 'delta', 'epsilon': 'epsilon',
            'varepsilon': 'epsilon', 'zeta': 'zeta', 'eta': 'eta',
            'iota': 'iota', 'kappa': 'kappa', 'lambda': 'lambda',
            'mu': 'mu', 'nu': 'nu', 'xi': 'xi', 'rho': 'rho',
            'sigma': 'sigma', 'tau': 'tau', 'upsilon': 'upsilon',
            'phi': 'phi', 'varphi': 'phi', 'chi': 'chi',
            'psi': 'psi', 'omega': 'omega',
            'infty': 'Infinity', 'cdot': '*', 'times': '*', 'div': '/'
        };
        Object.keys(symbols).forEach(function (k) {
            s = s.replace(new RegExp('\\\\' + k + '\\b', 'g'), symbols[k]);
        });

        // \frac{A}{B} → (A)/(B), recursive
        function expandFrac(input) {
            var out = '', i = 0;
            while (i < input.length) {
                if (input.substr(i, 6) === '\\frac{') {
                    var startNum = i + 5; // points at '{'
                    var endNum = findMatchingBrace(input, startNum);
                    if (endNum < 0) { out += input.charAt(i++); continue; }
                    var startDen = endNum + 1;
                    if (input.charAt(startDen) !== '{') { out += input.charAt(i++); continue; }
                    var endDen = findMatchingBrace(input, startDen);
                    if (endDen < 0) { out += input.charAt(i++); continue; }
                    var num = expandFrac(input.substring(startNum + 1, endNum));
                    var den = expandFrac(input.substring(startDen + 1, endDen));
                    out += '(' + num + ')/(' + den + ')';
                    i = endDen + 1;
                } else {
                    out += input.charAt(i++);
                }
            }
            return out;
        }
        s = expandFrac(s);

        // \sqrt{X} → sqrt(X), recursive
        function expandSqrt(input) {
            var out = '', i = 0;
            while (i < input.length) {
                if (input.substr(i, 6) === '\\sqrt{') {
                    var start = i + 5;
                    var end = findMatchingBrace(input, start);
                    if (end < 0) { out += input.charAt(i++); continue; }
                    out += 'sqrt(' + expandSqrt(input.substring(start + 1, end)) + ')';
                    i = end + 1;
                } else {
                    out += input.charAt(i++);
                }
            }
            return out;
        }
        s = expandSqrt(s);

        // Strip backslash from common function names
        s = s.replace(/\\(arcsin|arccos|arctan|arccot|arcsec|arccsc|sin|cos|tan|cot|sec|csc|sinh|cosh|tanh|log|ln|exp|sqrt)\b/g, '$1');

        // Strip lone braces around single tokens: "{x}" → "x"
        s = s.replace(/\{([^{}]+)\}/g, '$1');

        // Final cleanup: drop any lingering backslashes (unknown commands)
        s = s.replace(/\\/g, '');

        return s.trim();
    }

    // Strip any trailing "= <answer>" from a body, balancing braces so we
    // don't cut inside a \frac{}{} or similar. Lets users re-select a
    // previously-solved limit (e.g. "\lim_{x\to 0} sin(x)/x = 1") and have
    // the parser focus on just the function part.
    function stripTrailingEquation(s) {
        if (!s) return s;
        var depth = 0;
        for (var i = 0; i < s.length; i++) {
            var c = s.charAt(i);
            if (c === '{') depth++;
            else if (c === '}') depth--;
            else if (c === '=' && depth === 0) {
                return s.substring(0, i).trim();
            }
        }
        return s.trim();
    }

    // Parse a full \lim_{var \to point[^+|^-]} body LaTeX selection
    // → { variable, pointStr, direction, bodyExpr }   or null on miss
    function parseLatexLimit(fullLatex) {
        if (!fullLatex) return null;
        var s = String(fullLatex).trim();

        // Strip outer $...$ / \(...\) / $$...$$ wrappers if user grabbed them
        s = s.replace(/^\$\$([\s\S]+)\$\$$/, '$1')
             .replace(/^\$([\s\S]+)\$$/, '$1')
             .replace(/^\\\(([\s\S]+)\\\)$/, '$1')
             .replace(/^\\\[([\s\S]+)\\\]$/, '$1')
             .trim();

        // Match \lim_{var \to point [^{+|-}]} body
        var re = /^\s*\\lim\s*_\s*\{\s*([a-zA-Z])\s*(?:\\to|->|→|\\rightarrow)\s*([^}^]+?)(?:\s*\^\s*\{?\s*([+\-])\s*\}?)?\s*\}\s*([\s\S]+)$/;
        var m = s.match(re);
        if (!m) return null;

        var variable = m[1];
        var pointLatex = m[2].trim();
        var dirSign = m[3] || '';
        // Drop any trailing "= <answer>" the user may have included
        var bodyLatex = stripTrailingEquation(m[4].trim());

        var pointStr = pointLatex
            .replace(/\\infty\b/g, 'infinity')
            .replace(/\\pi\b/g, 'pi')
            .replace(/\\e\b/g, 'e')
            .replace(/\s+/g, '');

        var direction = dirSign === '+' ? 'right' : dirSign === '-' ? 'left' : 'two-sided';
        var bodyExpr = normalizeExpr(latexBodyToExpr(bodyLatex));

        return {
            variable: variable,
            pointStr: pointStr,
            pointLatex: pointLatex,
            direction: direction,
            bodyLatex: bodyLatex,
            bodyExpr: bodyExpr
        };
    }

    // ── 4b. Expression / point → LaTeX (used in step text) ──────────────────

    function exprToLatex(expr) {
        var nd = getNerdamer();
        if (nd) {
            try { return nd(expr).toTeX(); } catch (e) {}
        }
        // Fallback: best-effort string substitutions
        return String(expr || '')
            .replace(/\*/g, ' \\cdot ')
            .replace(/sqrt\(/g, '\\sqrt{').replace(/\)/g, '}')
            .replace(/\^(\w)/g, '^{$1}');
    }

    function pointToLatex(pt) {
        var p = String(pt || '').trim()
            .replace(/∞/g, 'infinity').replace(/π/g, 'pi').replace(/−/g, '-')
            .replace(/₀/g, '0').replace(/₁/g, '1').replace(/₂/g, '2').replace(/₃/g, '3')
            .replace(/₄/g, '4').replace(/₅/g, '5').replace(/₆/g, '6').replace(/₇/g, '7')
            .replace(/₈/g, '8').replace(/₉/g, '9')
            .toLowerCase();
        if (p === 'infinity' || p === 'inf') return '\\infty';
        if (p === '-infinity' || p === '-inf') return '-\\infty';
        if (p === 'pi') return '\\pi';
        if (p === 'e') return 'e';
        return pt;
    }

    // ── 4c. Step-by-step solution generator ─────────────────────────────────
    // ctx: { expr, v, a, ptStr, result, exprTeX, arrow, valueLatex }
    // Returns [{ title, latex }, ...]  or null if the method is unknown.

    function generateSteps(ctx) {
        var nd = getNerdamer();
        var steps = [];
        var expr = ctx.expr, v = ctx.v, res = ctx.result;
        var exprTeX = ctx.exprTeX, arrow = ctx.arrow;

        steps.push({
            title: 'State the limit',
            latex: '\\lim_{' + arrow + '}\\left[' + exprTeX + '\\right]'
        });

        if (res.method === 'Direct Substitution') {
            steps.push({
                title: 'Try direct substitution: ' + v + ' = ' + ctx.ptStr,
                latex: 'f(' + ctx.ptStr + ') = ' + ctx.valueLatex
            });
            steps.push({
                title: 'The function is defined at ' + v + ' = ' + ctx.ptStr,
                latex: '\\lim_{' + arrow + '}' + exprTeX + ' = ' + ctx.valueLatex
            });
            return steps;
        }

        if (res.form) {
            steps.push({
                title: 'Direct substitution yields indeterminate form',
                latex: '\\text{Form: }' + res.form
            });
        }

        var frac = splitFraction(expr);

        if (res.method === "L'Hôpital's Rule" && frac && nd) {
            steps.push({
                title: "Apply L'Hôpital's Rule: differentiate numerator and denominator",
                latex: '\\lim_{' + arrow + '}\\frac{f(' + v + ')}{g(' + v + ')} = \\lim_{' + arrow + '}\\frac{f\'(' + v + ')}{g\'(' + v + ')}'
            });
            try {
                var numD = nd('diff(' + frac.num + ',' + v + ')');
                var denD = nd('diff(' + frac.den + ',' + v + ')');
                steps.push({ title: 'Differentiate numerator',  latex: 'f\'(' + v + ') = ' + numD.toTeX() });
                steps.push({ title: 'Differentiate denominator', latex: 'g\'(' + v + ') = ' + denD.toTeX() });
                steps.push({
                    title: 'Evaluate the new limit',
                    latex: '\\lim_{' + arrow + '}\\frac{' + numD.toTeX() + '}{' + denD.toTeX() + '} = ' + ctx.valueLatex
                });
            } catch (e) {
                steps.push({ title: 'Evaluate after applying the rule', latex: '= ' + ctx.valueLatex });
            }
            return steps;
        }

        if (res.method === 'Algebraic Simplification' && frac) {
            steps.push({
                title: 'Simplify the expression algebraically',
                latex: '\\text{Factor and cancel common terms}'
            });
            if (nd) {
                try {
                    var simplified = nd('simplify(' + expr + ')').toTeX();
                    steps.push({ title: 'Simplified form', latex: simplified });
                } catch (e) {}
            }
            steps.push({
                title: 'Substitute ' + v + ' = ' + ctx.ptStr,
                latex: '= ' + ctx.valueLatex
            });
            return steps;
        }

        if (res.method && res.method.indexOf('Known Limit') === 0) {
            steps.push({
                title: 'This is a known standard limit',
                latex: '\\lim_{' + arrow + '}' + exprTeX + ' = ' + ctx.valueLatex
            });
            return steps;
        }

        // Numerical / DNE — show table approach
        if (res.method === 'Numerical Approximation' || res.method === 'Does Not Exist' ||
            (res.method && res.method.indexOf('Numerical') === 0)) {
            steps.push({
                title: 'Use numerical approximation',
                latex: '\\text{Evaluate } f(' + v + ') \\text{ for values approaching } ' + ctx.ptStr
            });
            if (res.numApprox && res.numApprox.leftValue !== null && res.numApprox.rightValue !== null) {
                var lv = typeof res.numApprox.leftValue === 'number' ? res.numApprox.leftValue.toFixed(4) : String(res.numApprox.leftValue);
                var rv = typeof res.numApprox.rightValue === 'number' ? res.numApprox.rightValue.toFixed(4) : String(res.numApprox.rightValue);
                steps.push({
                    title: 'Left-hand limit',
                    latex: '\\lim_{' + v + '\\to ' + pointToLatex(ctx.ptStr) + '^{-}} = ' + lv
                });
                steps.push({
                    title: 'Right-hand limit',
                    latex: '\\lim_{' + v + '\\to ' + pointToLatex(ctx.ptStr) + '^{+}} = ' + rv
                });
            }
            steps.push({
                title: 'Conclusion',
                latex: '\\lim_{' + arrow + '}' + exprTeX + ' = ' + ctx.valueLatex
            });
            return steps;
        }

        return null;
    }

    // ── 5. Format a JS value back to LaTeX ──────────────────────────────────

    function formatValueLatex(value) {
        if (value === 'DNE') return '\\text{Does Not Exist}';
        if (value === Infinity) return '\\infty';
        if (value === -Infinity) return '-\\infty';
        if (typeof value === 'number') {
            if (!isFinite(value)) return '\\text{undefined}';
            if (Number.isInteger(value)) return value.toString();
            var s = value.toFixed(6).replace(/0+$/, '').replace(/\.$/, '');
            return s;
        }
        return String(value);
    }

    // ── 6. End-to-end: LaTeX in, structured + LaTeX result out ──────────────

    function solveFromLatex(fullLatex, opts) {
        opts = opts || {};
        var parsed = parseLatexLimit(fullLatex);
        if (!parsed) {
            return { ok: false, error: 'Could not parse limit from "' + fullLatex + '"' };
        }
        var a = parsePoint(parsed.pointStr);
        if (a === null) {
            return { ok: false, error: 'Invalid limit point "' + parsed.pointStr + '"' };
        }
        if (!getNerdamer()) {
            return { ok: false, error: 'nerdamer not loaded' };
        }
        try {
            var result = compute(parsed.bodyExpr, parsed.variable, a, parsed.direction);
            var resultLatex = formatValueLatex(result.value);
            var ret = {
                ok: true,
                input: parsed,
                result: result,
                resultLatex: resultLatex,
                method: result.method
            };
            if (opts.withSteps) {
                // Build the context the step generator needs
                var arrow = parsed.variable + '\\to ' + pointToLatex(parsed.pointStr);
                if (parsed.direction === 'right') arrow += '^{+}';
                else if (parsed.direction === 'left') arrow += '^{-}';
                var ctx = {
                    expr: parsed.bodyExpr,
                    v: parsed.variable,
                    a: a,
                    ptStr: parsed.pointStr,
                    result: result,
                    exprTeX: exprToLatex(parsed.bodyExpr),
                    arrow: arrow,
                    valueLatex: resultLatex
                };
                ret.steps = generateSteps(ctx);
                ret.stepsContext = ctx;
            }
            return ret;
        } catch (e) {
            return { ok: false, error: 'Compute failed: ' + (e && e.message ? e.message : e) };
        }
    }

    return {
        normalizeExpr: normalizeExpr,
        parsePoint: parsePoint,
        compute: compute,
        splitFraction: splitFraction,
        safeEval: safeEval,
        checkKnownLimits: checkKnownLimits,
        numericalLimit: numericalLimit,
        convergeTo: convergeTo,
        buildApproxTable: buildApproxTable,
        latexBodyToExpr: latexBodyToExpr,
        parseLatexLimit: parseLatexLimit,
        formatValueLatex: formatValueLatex,
        exprToLatex: exprToLatex,
        pointToLatex: pointToLatex,
        generateSteps: generateSteps,
        solveFromLatex: solveFromLatex
    };
})();

if (typeof window !== 'undefined') window.LimitCalculatorCore = LimitCalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = LimitCalculatorCore;
