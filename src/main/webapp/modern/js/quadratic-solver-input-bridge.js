/**
 * Quadratic Solver — MathLive input bridge.
 *
 * Parses a single typed/visual equation (e.g. "x^2 + 5x + 6 = 0",
 * "(x-2)(x+3) = 0", "x^2 - 5x + 6 < 0", "x = y^2 - 4y + 2") into
 * { form, a, b, c, op? } and shovels the result into the legacy
 * coefficient inputs (#qs-coeff-a/b/c, #qs-vertex-*, #qs-ineq-*,
 * #qs-horiz-*) so the unmodified core JS (quadratic-solver-core.js)
 * solves it via its existing flow.
 *
 * Public surface:
 *   window.QuadraticInputBridge.parse(expr)        — pure parser
 *   window.QuadraticInputBridge.applyExample(text) — seed MathLive + #ic-expr
 *
 * Why a bridge instead of a rewrite: render/graph/export/core total ~2k
 * lines and are battle-tested. Replacing the input layer is the smallest
 * change that delivers "MathLive first, fewer inputs."
 */
(function () {
'use strict';

var ND = (typeof nerdamer !== 'undefined') ? nerdamer : null;

// ===== Normalization =====
//
// MathLive's ascii-math output is mostly clean but can include LaTeX
// remnants depending on how the user typed: \cdot for ·, \: for the
// math-mode-space, braces around groups (x^{2}), \left/\right wrappers,
// and inequality commands (\le, \ge). nerdamer chokes on any of those.
// We also need explicit '*' for implicit multiplication (5x, 2(x+1)).
function normalize(raw) {
    if (raw == null) return '';
    var s = String(raw);

    // LaTeX-y artifacts that may leak through MathLive's ascii-math.
    s = s.replace(/\\cdot/g, '*');
    s = s.replace(/\\times/g, '*');
    s = s.replace(/\\div/g, '/');
    s = s.replace(/\\leq/g, '<=');
    s = s.replace(/\\le\b/g, '<=');
    s = s.replace(/\\geq/g, '>=');
    s = s.replace(/\\ge\b/g, '>=');
    s = s.replace(/\\lt/g, '<');
    s = s.replace(/\\gt/g, '>');
    s = s.replace(/\\neq/g, '!=');
    s = s.replace(/\\left/g, '');
    s = s.replace(/\\right/g, '');
    s = s.replace(/\\:/g, ' ');
    s = s.replace(/\\,/g, ' ');
    s = s.replace(/\\;/g, ' ');
    s = s.replace(/\\!/g, '');
    s = s.replace(/\\\s/g, ' ');

    // Replace {x+1} with (x+1) — LaTeX grouping → parens. Iterate so
    // nested groups also get rewritten (innermost first via regex pass).
    var prev;
    do { prev = s; s = s.replace(/\{([^{}]*)\}/g, '($1)'); } while (s !== prev);

    // Unicode normalizations.
    s = s.replace(/²/g, '^2').replace(/³/g, '^3').replace(/⁴/g, '^4');
    s = s.replace(/π/g, 'pi').replace(/×/g, '*').replace(/·/g, '*');
    s = s.replace(/−/g, '-').replace(/–/g, '-').replace(/—/g, '-');
    s = s.replace(/≤/g, '<=').replace(/≥/g, '>=');

    // Implicit multiplication: 5x → 5*x, 2(x+1) → 2*(x+1), )(x → )*(x.
    s = s.replace(/(\d)([a-zA-Z(])/g, '$1*$2');
    s = s.replace(/\)([a-zA-Z0-9(])/g, ')*$1');

    s = s.replace(/\s+/g, ' ').trim();
    return s;
}

function num(node) {
    if (node == null) return 0;
    var n = parseFloat(node.toString());
    return isFinite(n) ? n : NaN;
}

// Evaluate a nerdamer-parseable expression at varName = value.
// Implemented by textual substitution + numeric evaluation, because
// nerdamer 1.1.13 doesn't expose .coeffs() as an instance method and
// .sub() / direct subs args have inconsistent behavior across builds.
function evalAt(expr, varName, value) {
    if (!ND) return NaN;
    var pattern = new RegExp('\\b' + varName + '\\b', 'g');
    var subbed = expr.replace(pattern, '(' + value + ')');
    try {
        var sym = ND(subbed);
        if (typeof sym.evaluate === 'function') sym = sym.evaluate();
        var n = parseFloat(sym.toString());
        return isFinite(n) ? n : NaN;
    } catch (e) {
        return NaN;
    }
}

// Cleanup near-integers (sample-and-solve introduces tiny FP noise).
function snap(v) {
    if (!isFinite(v)) return v;
    var r = Math.round(v);
    return Math.abs(v - r) < 1e-9 ? r : v;
}

// Extract (a, b, c) of an at-most-quadratic polynomial in `varName` by
// sampling at 0, 1, -1, 2 and solving the resulting linear system.
// Returns { a, b, c } or { error }.
function extractQuadCoeffs(unifiedExpr, varName) {
    var f0  = evalAt(unifiedExpr, varName, 0);
    var f1  = evalAt(unifiedExpr, varName, 1);
    var fm1 = evalAt(unifiedExpr, varName, -1);
    var f2  = evalAt(unifiedExpr, varName, 2);
    if (window.__QS_BRIDGE_DEBUG) console.log('[qs-bridge] samples:', { f0: f0, f1: f1, fm1: fm1, f2: f2 });

    if (isNaN(f0) || isNaN(f1) || isNaN(fm1) || isNaN(f2)) {
        return { error: 'Couldn\'t evaluate the equation numerically. Check the syntax help.' };
    }

    var c = f0;
    var a = (f1 + fm1) / 2 - c;
    var b = f1 - a - c;

    // Degree check: f(2) must equal 4a + 2b + c for a true quadratic.
    var expected = 4 * a + 2 * b + c;
    var scale = Math.max(1, Math.abs(f2), Math.abs(expected));
    if (Math.abs(expected - f2) > 1e-6 * scale) {
        return { error: 'Highest power of ' + varName + ' must be 2 — try a quadratic equation.' };
    }

    return { a: snap(a), b: snap(b), c: snap(c) };
}

// ===== Parser =====
//
// Returns { form, a, b, c, op? } or { error: string }.
// form ∈ { 'standard', 'inequality', 'horizontal' } — vertex/factored
// inputs collapse to 'standard' once expanded, which is fine because the
// core's solve flow only branches on inequality vs horizontal vs other.
function parse(rawExpr) {
    var DEBUG = !!window.__QS_BRIDGE_DEBUG;
    if (DEBUG) console.log('[qs-bridge] raw input:', JSON.stringify(rawExpr));
    var s = normalize(rawExpr);
    if (DEBUG) console.log('[qs-bridge] normalized:', JSON.stringify(s));
    if (!s) return { error: 'Type an equation first.' };
    if (!ND) return { error: 'Math engine not loaded.' };

    // Inequality op (longer first so '<=' wins over '<').
    var op = null;
    var m = s.match(/(<=|>=|<|>)/);
    if (m) {
        op = m[1];
        s = s.replace(/(<=|>=|<|>)/, '=');
    }

    // Split on the first '=' (treat absence as "= 0").
    var lhs, rhs;
    var eqIdx = s.indexOf('=');
    if (eqIdx === -1) { lhs = s; rhs = '0'; }
    else { lhs = s.slice(0, eqIdx).trim(); rhs = s.slice(eqIdx + 1).trim() || '0'; }
    if (!lhs) return { error: 'Left side is empty.' };

    // Horizontal parabola: lhs is exactly "x", rhs is a poly in y.
    var lhsClean = lhs.replace(/\s+/g, '');
    if (lhsClean === 'x' && /\by\b/.test(rhs) && !/\bx\b/.test(rhs)) {
        if (op) return { error: 'Inequalities are not supported for horizontal parabolas.' };
        var hRes = extractQuadCoeffs('(' + rhs + ')', 'y');
        if (DEBUG) console.log('[qs-bridge] horizontal coeffs:', hRes);
        if (hRes.error) return hRes;
        if (hRes.a === 0) return { error: 'Not a quadratic — coefficient of y² is zero.' };
        return { form: 'horizontal', a: hRes.a, b: hRes.b, c: hRes.c };
    }

    // All other shapes → sample (lhs - rhs) at four x-values and solve.
    var unified = '(' + lhs + ')-(' + rhs + ')';
    if (DEBUG) console.log('[qs-bridge] unified expr:', unified);
    var res = extractQuadCoeffs(unified, 'x');
    if (DEBUG) console.log('[qs-bridge] standard coeffs:', res);
    if (res.error) return res;
    if (res.a === 0) return { error: 'Not a quadratic — coefficient of x² is zero.' };

    return op
        ? { form: 'inequality', a: res.a, b: res.b, c: res.c, op: op }
        : { form: 'standard', a: res.a, b: res.b, c: res.c };
}

// ===== Apply parsed result to legacy DOM inputs + form-type =====
function applyToLegacyState(parsed) {
    if (!parsed || parsed.error) return false;

    function setVal(id, v) {
        var el = document.getElementById(id);
        if (el) el.value = v;
    }

    if (parsed.form === 'horizontal') {
        setVal('qs-horiz-a', parsed.a);
        setVal('qs-horiz-b', parsed.b);
        setVal('qs-horiz-c', parsed.c);
    } else if (parsed.form === 'inequality') {
        setVal('qs-ineq-a', parsed.a);
        setVal('qs-ineq-b', parsed.b);
        setVal('qs-ineq-c', parsed.c);
        setVal('qs-ineq-op', parsed.op || '>');
    } else {
        setVal('qs-coeff-a', parsed.a);
        setVal('qs-coeff-b', parsed.b);
        setVal('qs-coeff-c', parsed.c);
    }

    // Trigger the legacy form-type switch by clicking the matching
    // (hidden) form button — this is what the core listens for.
    var formBtn = document.querySelector('.qs-form-btn[data-type="' + parsed.form + '"]');
    if (formBtn) formBtn.click();
    return true;
}

// ===== Seed MathLive + plain input from an example string =====
function applyExample(asciiMath) {
    var mf = document.getElementById('ic-mathfield');
    var ex = document.getElementById('ic-expr');
    if (ex) ex.value = asciiMath;
    if (mf && typeof mf.setValue === 'function') {
        try { mf.setValue(asciiMath, { format: 'ascii-math' }); } catch (e) {}
    }
    // Notify input listeners (CTA enable, mode-toggle bridge, etc.).
    if (ex) ex.dispatchEvent(new Event('input', { bubbles: true }));
}

window.QuadraticInputBridge = {
    parse: parse,
    applyToLegacyState: applyToLegacyState,
    applyExample: applyExample,
    normalize: normalize
};

// One-shot self-test you can run from DevTools to confirm the chain:
//   window.__QS_BRIDGE_DEBUG = true; QuadraticInputBridge.parse('x^2+5x+6=0')
// Expect: { form: 'standard', a: 1, b: 5, c: 6 }

})();
