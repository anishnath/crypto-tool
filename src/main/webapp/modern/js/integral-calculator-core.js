/**
 * Integral Calculator - shared core logic (no DOM/nerdamer coupling for pure functions).
 * Used by: integral-calculator.jsp (browser) and integral-calculator-test (Node).
 * Supports: browser (IntegralCalculatorCore global) and Node (module.exports).
 */
'use strict';

function normalizeExpr(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    var s = expr.trim();
    s = s.replace(/(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\s*(\d+)\s*([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, '$1($2*$3)');
    s = s.replace(/(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\s*([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, '$1($2)');
    s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
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
    var str = (s || '').toString().trim().toLowerCase();
    if (str === 'pi') return Math.PI;
    if (str === 'e') return Math.E;
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
