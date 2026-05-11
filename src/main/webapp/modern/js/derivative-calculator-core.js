/**
 * Derivative Calculator — shared core logic.
 *
 * Pure-compute API used by:
 *   - derivative-calculator.jsp (the live tool, via DerivativeCalculatorCore namespace)
 *   - latex/static/js/math-insert.js (LaTeX editor's Σ Solve dropdown)
 *
 * Depends on:
 *   - nerdamer (CAS, browser global)
 *   - IntegralCalculatorCore.normalizeExpr + .latexBodyToExpr (loaded BEFORE this file)
 */
'use strict';

var DerivativeCalculatorCore = (function () {

    var ICC = (typeof IntegralCalculatorCore !== 'undefined') ? IntegralCalculatorCore
            : (typeof window !== 'undefined' && window.IntegralCalculatorCore) ? window.IntegralCalculatorCore
            : null;

    var normalizeExpr =
        (ICC && ICC.normalizeExpr) ? ICC.normalizeExpr
        : function (e) { return (e && e.trim) ? e.trim() : (e || ''); };

    var latexBodyToExpr =
        (ICC && ICC.latexBodyToExpr) ? ICC.latexBodyToExpr
        : function (e) { return e || ''; };

    function getNerdamer() {
        if (typeof nerdamer !== 'undefined') return nerdamer;
        if (typeof window !== 'undefined' && window.nerdamer) return window.nerdamer;
        return null;
    }

    // Strip trailing "= <answer>" so re-selected derivatives still parse.
    function stripTrailingEquation(s) {
        if (!s) return s;
        var depth = 0;
        for (var i = 0; i < s.length; i++) {
            var c = s.charAt(i);
            if (c === '{') depth++;
            else if (c === '}') depth--;
            else if (c === '=' && depth === 0) return s.substring(0, i).trim();
        }
        return s.trim();
    }

    // ── LaTeX → structured derivative ────────────────────────────────────────
    //
    // Recognised forms:
    //   \frac{d}{dx} body              (1st derivative)
    //   \frac{d^{n}}{dx^{n}} body      (n-th derivative, curly exponent)
    //   \frac{d^n}{dx^n} body          (n-th derivative, single-digit exponent)
    //   \frac{d}{dx}(body)             (parenthesised body)
    //
    // Returns { variable, order, bodyLatex, bodyExpr } or null.
    function parseLatexDerivative(fullLatex) {
        if (!fullLatex) return null;
        var s = String(fullLatex).trim();
        s = s.replace(/^\$\$([\s\S]+)\$\$$/, '$1')
             .replace(/^\$([\s\S]+)\$$/, '$1')
             .replace(/^\\\(([\s\S]+)\\\)$/, '$1')
             .replace(/^\\\[([\s\S]+)\\\]$/, '$1')
             .trim();
        s = stripTrailingEquation(s);

        // Numerator group: \{ d (\^{n} | \^n)? \}
        // Denominator group: \{ d <var> (\^{n} | \^n)? \}
        var re = /^\\frac\s*\{\s*d(?:\^(?:\{(\d+)\}|(\d+)))?\s*\}\s*\{\s*d([a-zA-Z])(?:\^(?:\{(\d+)\}|(\d+)))?\s*\}\s*/;
        var m = s.match(re);
        if (!m) return null;

        var orderNum = parseInt(m[1] || m[2] || '1', 10);
        var orderDen = parseInt(m[4] || m[5] || '1', 10);
        if (orderNum !== orderDen) return null;
        var variable = m[3];
        var order = orderNum;

        var body = s.substring(m[0].length).trim();
        // \left(...\right) → strip
        body = body.replace(/^\\left\(/, '(').replace(/\\right\)$/, ')');
        // Strip a balanced outer pair of parens
        if (body.charAt(0) === '(' && body.charAt(body.length - 1) === ')') {
            var depth = 0, balanced = true;
            for (var i = 0; i < body.length; i++) {
                if (body.charAt(i) === '(') depth++;
                else if (body.charAt(i) === ')') depth--;
                if (depth === 0 && i < body.length - 1) { balanced = false; break; }
            }
            if (balanced) body = body.substring(1, body.length - 1).trim();
        }

        if (!body) return null;
        var bodyExpr = normalizeExpr(latexBodyToExpr(body));

        return {
            variable: variable,
            order: order,
            bodyLatex: body,
            bodyExpr: bodyExpr
        };
    }

    // ── Compute via nerdamer ─────────────────────────────────────────────────

    function compute(expr, v, order) {
        var nd = getNerdamer();
        if (!nd) return null;
        order = order || 1;
        try {
            var call = 'diff(' + expr + ', ' + v + (order > 1 ? ', ' + order : '') + ')';
            var r = nd(call);
            var resTeX = r.toTeX();
            var resTxt = r.text();
            // Detect unresolved / pass-through (e.g. nerdamer can't differentiate)
            if (/diff\(/.test(resTxt)) {
                return { method: 'Symbolic (unresolved)', unresolved: true,
                         resultLatex: resTeX, value: resTxt };
            }
            return {
                method: order > 1 ? ('Derivative (order ' + order + ')') : 'Derivative',
                unresolved: false,
                resultLatex: resTeX,
                value: resTxt
            };
        } catch (e) {
            return null;
        }
    }

    // ── Step builder (basic — derivative pattern decomposition is a future v2) ──

    function buildDerivativeSteps(parsed, result) {
        var v = parsed.variable;
        var order = parsed.order || 1;
        var leftSide = (order === 1)
            ? '\\frac{d}{d' + v + '}\\left[ ' + parsed.bodyLatex + ' \\right]'
            : '\\frac{d^{' + order + '}}{d' + v + '^{' + order + '}}\\left[ ' + parsed.bodyLatex + ' \\right]';

        return [
            { title: 'State the derivative', latex: leftSide },
            { title: 'Apply differentiation rules',
              latex: leftSide + ' = ' + result.resultLatex },
            { title: 'Result',
              latex: leftSide + ' = ' + result.resultLatex }
        ];
    }

    // ── Public entry point ───────────────────────────────────────────────────

    function solveFromLatex(fullLatex, opts) {
        opts = opts || {};
        var parsed = parseLatexDerivative(fullLatex);
        if (!parsed) {
            return Promise.resolve({ ok: false, error: 'Could not parse derivative from "' + fullLatex + '"' });
        }
        var nd = getNerdamer();
        if (!nd) return Promise.resolve({ ok: false, error: 'Math engine not loaded' });

        var result;
        try { result = compute(parsed.bodyExpr, parsed.variable, parsed.order); }
        catch (e) { return Promise.resolve({ ok: false, error: 'Compute failed: ' + e.message }); }
        if (!result) {
            return Promise.resolve({ ok: false, error: 'Could not differentiate "' + parsed.bodyLatex + '"' });
        }
        if (result.unresolved) {
            return Promise.resolve({ ok: false, error: 'Could not differentiate this expression in closed form.' });
        }
        var ret = {
            ok: true,
            input: parsed,
            result: result,
            resultLatex: result.resultLatex,
            method: result.method
        };
        if (opts.withSteps) ret.steps = buildDerivativeSteps(parsed, result);
        return Promise.resolve(ret);
    }

    return {
        normalizeExpr: normalizeExpr,
        latexBodyToExpr: latexBodyToExpr,
        stripTrailingEquation: stripTrailingEquation,
        parseLatexDerivative: parseLatexDerivative,
        compute: compute,
        buildDerivativeSteps: buildDerivativeSteps,
        solveFromLatex: solveFromLatex
    };
})();

if (typeof window !== 'undefined') window.DerivativeCalculatorCore = DerivativeCalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = DerivativeCalculatorCore;
