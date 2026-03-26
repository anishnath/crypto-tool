/**
 * Integral Calculator - shared core logic (no DOM/nerdamer coupling for pure functions).
 * Used by: integral-calculator.jsp (browser) and integral-calculator-test (Node).
 * Supports: browser (IntegralCalculatorCore global) and Node (module.exports).
 */
'use strict';

function normalizeExpr(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    var s = expr.trim();
    /* Unicode math → ASCII: superscripts, symbols, operators */
    /* Superscript minus + digits → ^(-N) before individual replacements */
    var supDigit = '\u00b2\u00b3\u2074\u2075\u2076\u2077\u2078\u2079\u2070\u00b9';
    var supMap = {'\u00b2':'2','\u00b3':'3','\u2074':'4','\u2075':'5','\u2076':'6','\u2077':'7','\u2078':'8','\u2079':'9','\u2070':'0','\u00b9':'1'};
    s = s.replace(new RegExp('\u207b([' + supDigit + ']+)', 'g'), function(_, ds) {
        return '^(-' + ds.replace(new RegExp('[' + supDigit + ']', 'g'), function(c) { return supMap[c]; }) + ')';
    });
    s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')   // ² ³
         .replace(/\u2074/g, '^4').replace(/\u2075/g, '^5')    // ⁴ ⁵
         .replace(/\u2076/g, '^6').replace(/\u2077/g, '^7')    // ⁶ ⁷
         .replace(/\u2078/g, '^8').replace(/\u2079/g, '^9')    // ⁸ ⁹
         .replace(/\u2070/g, '^0').replace(/\u00b9/g, '^1')    // ⁰ ¹
         .replace(/\u207b/g, '-')                               // ⁻ (superscript minus, standalone fallback)
         .replace(/\u03c0/g, 'pi')                              // π
         .replace(/\u221e/g, 'Infinity')                        // ∞
         .replace(/\u221a/g, 'sqrt')                            // √
         .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')      // · ⋅
         .replace(/\u2212/g, '-')                               // − (minus sign)
         .replace(/\u00f7/g, '/')                               // ÷
         .replace(/\u00d7/g, '*');                              // ×
    /* Unicode subscript digits → regular digits */
    s = s.replace(/\u2080/g, '0').replace(/\u2081/g, '1')
         .replace(/\u2082/g, '2').replace(/\u2083/g, '3')
         .replace(/\u2084/g, '4').replace(/\u2085/g, '5')
         .replace(/\u2086/g, '6').replace(/\u2087/g, '7')
         .replace(/\u2088/g, '8').replace(/\u2089/g, '9');
    /* arcsin → asin, arccos → acos, arctan → atan, arccot → acot, arcsec → asec, arccsc → acsc */
    s = s.replace(/\barc(sin|cos|tan|cot|sec|csc)\b/g, 'a$1');
    var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|coth|csch|sech|log|ln|sqrt';
    /* sin^2025(x) → sin(x)^2025 — otherwise nerdamer reads sin^2025(x) as sin^2025*x (wrong). */
    s = s.replace(new RegExp('\\b(' + FUNS + ')\\^([0-9]+)\\(([^)]+)\\)', 'g'), '$1($3)^$2');
    /* Lookahead: operator, close-paren, whitespace, comma, end-of-string,
       OR the start of another known function name (handles sinxcosx). */
    var LA = '(?=[+\\-*/^)\\s,]|$|(?:' + FUNS + '))';
    /* --- trig / hyp / log / sqrt shorthand without parens --- */
    /* sin2x → sin(2*x), ln3t → ln(3*t), sqrt2x → sqrt(2*x) */
    s = s.replace(new RegExp('(' + FUNS + ')\\s*(\\d+)\\s*([a-zA-Z])' + LA, 'g'), '$1($2*$3)');
    /* sinx → sin(x), lnx → ln(x), sqrtx → sqrt(x) */
    s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])' + LA, 'g'), '$1($2)');
    /* e^3t → e^(3*t) */
    s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
    /* xe^x without * is parsed by nerdamer as (xe)^x; normalize to x*e^x */
    s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
    /* xsin(x), ycos(x), xsinh(x), xlog(x) etc — insert * before known functions.
       Skip 'a' prefix to preserve asin, acos, atan. */
    s = s.replace(new RegExp('([b-zB-Z])(' + FUNS + ')\\(', 'g'), '$1*$2(');
    /* Also handle digit prefix: 2sqrt(x) → 2*sqrt(x), 2sin(x) → 2*sin(x) */
    s = s.replace(new RegExp('(\\d)(' + FUNS + ')\\(', 'g'), '$1*$2(');
    /* )cos( or )cos^2026( → )*cos…  (e.g. sin^2(x)cos^3(x)). Plain )cos( has no ^; Bee-style adds ^n before (. */
    s = s.replace(new RegExp('\\)(' + FUNS + ')(\\^[0-9]+)?\\(', 'g'), ')*$1$2(');
    /* 2025cos^2026 → 2025*cos^2026 after sin(x)^2025cos(x)^2026 (before generic digit·letter). */
    s = s.replace(new RegExp('(\\d)(' + FUNS + ')(\\^)', 'g'), '$1*$2$3');
    /* Implicit multiplication: 3x → 3*x, 2y → 2*y (digit followed by variable).
       Function names (sin, cos, ...) already handled above with parens inserted. */
    s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
    /* ln → log (nerdamer uses log for natural logarithm) */
    s = s.replace(/\bln\(/g, 'log(');
    return s;
}

function checkNonElementaryIntegral(expr, v) {
    var e = expr.replace(/\s+/g, ' ').trim().toLowerCase();
    var vNorm = v.toLowerCase();
    var norm = e.replace(new RegExp(vNorm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gi'), 'x');
    if (/^1\/(log|ln)\s*\(\s*x\s*\)\s*$/.test(norm) || /^1\/(log|ln)\s*x\s*$/.test(norm)) {
        return { name: '1/ln(' + v + ')', symbol: 'li(' + v + ')', desc: 'logarithmic integral li(' + v + ') = ∫ dt/ln(t). No closed form in elementary functions.' };
    }
    if (/e\^\(x\^2\)|exp\(x\^2\)/.test(norm)) {
        return { name: 'e^(x^2)', symbol: 'erf(x)', desc: 'related to the error function erf(x). No closed form in elementary functions.' };
    }
    if (/sin\(x\)\/x|sin\(x\)\/\s*x/.test(norm)) {
        return { name: 'sin(x)/x', symbol: 'Si(x)', desc: 'sine integral Si(x). No closed form in elementary functions.' };
    }
    return null;
}

function evalBound(s, nerdamer) {
    var str = (s || '').toString().trim()
        .replace(/\u03c0/g, 'pi')          // π
        .replace(/\u221e/g, 'Infinity')     // ∞
        .replace(/\u2212/g, '-')            // − (Unicode minus)
        .replace(/\u00b2/g, '^2')           // ²
        .replace(/\u00b3/g, '^3')           // ³
        .toLowerCase();
    if (str === 'pi') return Math.PI;
    if (str === 'e') return Math.E;
    if (str === 'infinity' || str === 'inf') return Infinity;
    if (str === '-infinity' || str === '-inf') return -Infinity;
    var nm = nerdamer || (typeof global !== 'undefined' && global.nerdamer) || (typeof window !== 'undefined' && window.nerdamer);
    if (nm) {
        try {
            return parseFloat(nm(s).evaluate().text('decimals'));
        } catch (e) { /* fall through */ }
    }
    return parseFloat(s) || 0;
}

/**
 * King's Property detector for definite integrals.
 * If ∫ₐᵇ f(x)/(f(x)+f(a+b-x)) dx, the result is (b-a)/2.
 *
 * Detection: parse "N/(D)" form, check that D = N + N', where N' is N
 * with x replaced by (a+b-x). Verified numerically at multiple test points.
 *
 * Returns { value: (b-a)/2, exact, latex, steps } or null.
 */
function checkKingsProperty(expr, v, a, b, nerdamerRef) {
    var nm = nerdamerRef || (typeof global !== 'undefined' && global.nerdamer) || (typeof window !== 'undefined' && window.nerdamer);
    if (!nm) return null;

    // Parse bounds to numbers
    var aNum = evalBound(a, nm);
    var bNum = evalBound(b, nm);
    if (!isFinite(aNum) || !isFinite(bNum)) return null;
    var sum = aNum + bNum;  // a + b

    try {
        // Detect free parameters (variables other than the integration variable).
        // e.g. in sin(x)^m/(cos(x)^m+sin(x)^m), m is a free parameter.
        var freeParams = [];
        try {
            var vars = nm(expr).variables();
            for (var vi = 0; vi < vars.length; vi++) {
                if (vars[vi] !== v) freeParams.push(vars[vi]);
            }
        } catch (_) {}

        // Test values for free parameters — use several values to ensure
        // the property holds for all of them, not just one lucky choice.
        var paramSets = [{}];
        if (freeParams.length > 0) {
            paramSets = [];
            var testParamValues = [2, 3.5, 7];  // integer, fractional, larger
            for (var pi = 0; pi < testParamValues.length; pi++) {
                var ps = {};
                for (var pj = 0; pj < freeParams.length; pj++) {
                    ps[freeParams[pj]] = testParamValues[pi];
                }
                paramSets.push(ps);
            }
        }

        // Strategy: evaluate the integrand at x and check if
        // integrand(x) + integrand(a+b-x) ≈ 1 at multiple test points.
        // If so, it satisfies King's property and the integral = (b-a)/2.
        // For expressions with free parameters, verify across multiple param values.
        var testPoints = [0.1, 0.3, 0.5, 0.7, 0.9];
        var allOne = true;

        for (var psi = 0; psi < paramSets.length && allOne; psi++) {
            for (var i = 0; i < testPoints.length; i++) {
                var xVal = aNum + testPoints[i] * (bNum - aNum);
                var mirrorVal = sum - xVal;  // a + b - x

                var scope1 = {};
                scope1[v] = xVal;
                var scope2 = {};
                scope2[v] = mirrorVal;

                // Add free parameter values to both scopes
                for (var pk in paramSets[psi]) {
                    scope1[pk] = paramSets[psi][pk];
                    scope2[pk] = paramSets[psi][pk];
                }

                var f1 = parseFloat(nm(expr).evaluate(scope1).text('decimals'));
                var f2 = parseFloat(nm(expr).evaluate(scope2).text('decimals'));

                if (!isFinite(f1) || !isFinite(f2)) { allOne = false; break; }
                if (Math.abs(f1 + f2 - 1) > 1e-9) { allOne = false; break; }
            }
        }

        if (!allOne) return null;

        // King's property confirmed: ∫ₐᵇ f(x) dx = (b-a)/2
        var numericVal = (bNum - aNum) / 2;

        // Build exact symbolic answer
        var exactText, exactTeX;
        try {
            var symExact = nm('(' + b + '-(' + a + '))/2').text();
            exactText = symExact;
            exactTeX = nm('(' + b + '-(' + a + '))/2').toTeX();
        } catch (_) {
            exactText = String(numericVal);
            exactTeX = String(numericVal);
        }

        // Build step-by-step explanation
        var steps = [
            { title: "King's Property (Symmetry Rule)",
              latex: '\\text{If } f(x) + f(a+b-x) = 1 \\text{ for all } x \\in [a,b], \\text{ then } \\int_a^b f(x)\\,dx = \\frac{b-a}{2}' },
            { title: 'Verify symmetry',
              latex: '\\text{Let } I = \\int_{' + a + '}^{' + b + '} f(' + v + ')\\,d' + v +
                     '.\\text{ Substitute } ' + v + ' \\to (' + a + '+' + b + '-' + v + '):' },
            { title: 'Apply substitution',
              latex: 'I = \\int_{' + a + '}^{' + b + '} f(' + a + '+' + b + '-' + v + ')\\,d' + v +
                     ' = \\int_{' + a + '}^{' + b + '} \\bigl(1 - f(' + v + ')\\bigr)\\,d' + v },
            { title: 'Add original and substituted',
              latex: '2I = \\int_{' + a + '}^{' + b + '} \\bigl[f(' + v + ') + f(' + a + '+' + b + '-' + v + ')\\bigr]\\,d' + v +
                     ' = \\int_{' + a + '}^{' + b + '} 1\\,d' + v + ' = ' + b + ' - ' + a },
            { title: 'Solve for I',
              latex: 'I = \\frac{' + b + ' - ' + a + '}{2} = ' + exactTeX }
        ];

        return {
            value: numericVal,
            exactText: exactText,
            exactTeX: exactTeX,
            method: "King's Property (Symmetry)",
            steps: steps
        };
    } catch (_) {
        return null;
    }
}

var api = { normalizeExpr: normalizeExpr, checkNonElementaryIntegral: checkNonElementaryIntegral, evalBound: evalBound, checkKingsProperty: checkKingsProperty };

if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
} else {
    var g = typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};
    g.IntegralCalculatorCore = api;
}
