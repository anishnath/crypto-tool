/**
 * Derivative Calculator - shared core logic.
 * Uses normalizeExpr from IntegralCalculatorCore (sin3x → sin(3*x)).
 * Load integral-calculator-core.js BEFORE this script.
 */
'use strict';

var normalizeExpr = (typeof IntegralCalculatorCore !== 'undefined' && IntegralCalculatorCore.normalizeExpr)
    ? IntegralCalculatorCore.normalizeExpr
    : function(e) { return (e && e.trim) ? e.trim() : (e || ''); };

var api = { normalizeExpr: normalizeExpr };
var g = typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : {};
g.DerivativeCalculatorCore = api;
