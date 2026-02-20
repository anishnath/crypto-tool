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
    s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')   // ² ³
         .replace(/\u2074/g, '^4').replace(/\u2075/g, '^5')    // ⁴ ⁵
         .replace(/\u2076/g, '^6').replace(/\u2077/g, '^7')    // ⁶ ⁷
         .replace(/\u2078/g, '^8').replace(/\u2079/g, '^9')    // ⁸ ⁹
         .replace(/\u2070/g, '^0').replace(/\u00b9/g, '^1')    // ⁰ ¹
         .replace(/\u207b/g, '-')                               // ⁻ (superscript minus)
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
    var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|sqrt';
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

var api = { normalizeExpr: normalizeExpr, checkNonElementaryIntegral: checkNonElementaryIntegral, evalBound: evalBound };

if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
} else {
    var g = typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};
    g.IntegralCalculatorCore = api;
}
