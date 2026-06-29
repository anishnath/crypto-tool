/**
 * Integral Calculator - shared core logic (no DOM/nerdamer coupling for pure functions).
 * Used by: integral-calculator.jsp (browser) and integral-calculator-test (Node).
 * Supports: browser (IntegralCalculatorCore global) and Node (module.exports).
 */
'use strict';

function normalizeExpr(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    var s = expr.trim();
    /* Strip ALL internal whitespace before applying implicit-multiplication
       rules.  Reason: MathLive's ascii-math output for `x^2 \sin(x)` is
       `x^2 sin(x)` (space-separated) — but the implicit-mul rules below
       expect adjacency (e.g. `\d` followed by a function name) to insert
       the missing `*`.  Without this strip, "x^2 sin(x)" passes through
       unchanged and nerdamer rejects it.  Whitespace is never load-bearing
       in math expressions, so dropping it globally is safe. */
    s = s.replace(/\s+/g, '');
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

/** Split on commas only when parenthesis depth is zero (supports Rational(1,2) in bounds). */
function splitCommaAtDepth0(inner) {
    var parts = [];
    var depth = 0;
    var start = 0;
    for (var i = 0; i < inner.length; i++) {
        var c = inner[i];
        if (c === '(') depth++;
        else if (c === ')') {
            depth--;
            if (depth < 0) return [];
        } else if (c === ',' && depth === 0) {
            parts.push(inner.slice(start, i).trim());
            start = i + 1;
        }
    }
    parts.push(inner.slice(start).trim());
    return parts;
}

/**
 * Parse SymPy-style "integrand, (var, a, b)" when the integrand may contain commas
 * (e.g. Max(0, sqrt(1-x^2)-1/2), Sum(...)).
 * Returns { integrand, var, a, b } or null.
 */
function parseSympyStyleInput(raw) {
    if (!raw || typeof raw !== 'string') return null;
    var s = raw.replace(/\s+/g, ' ').trim();
    if (s.length < 6) return null;
    if (s[s.length - 1] !== ')') return null;
    var depth = 1;
    var i = s.length - 2;
    while (i >= 0 && depth > 0) {
        var c = s[i];
        if (c === ')') depth++;
        else if (c === '(') depth--;
        i--;
    }
    if (depth !== 0) return null;
    var tupleOpen = i + 1;
    if (s[tupleOpen] !== '(') return null;
    var inner = s.slice(tupleOpen + 1, s.length - 1);
    var parts = splitCommaAtDepth0(inner);
    if (parts.length !== 3) return null;
    var varName = parts[0];
    if (!/^\w+$/.test(varName)) return null;
    var before = s.slice(0, tupleOpen).trim();
    if (!/,\s*$/.test(before)) return null;
    var integrand = before.replace(/,\s*$/, '').trim();
    if (!integrand) return null;
    return { integrand: integrand, var: varName, a: parts[1].trim(), b: parts[2].trim() };
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

// ─────────────────────────────────────────────────────────────────────────
//  LaTeX → nerdamer pipeline (used by the LaTeX editor's Σ Solve dropdown
//  to handle integrals selected from the document).
// ─────────────────────────────────────────────────────────────────────────

function _findMatchingBrace(s, openPos) {
    if (s.charAt(openPos) !== '{') return -1;
    var depth = 1;
    for (var i = openPos + 1; i < s.length; i++) {
        var c = s.charAt(i);
        if (c === '{') depth++;
        else if (c === '}') { depth--; if (depth === 0) return i; }
    }
    return -1;
}

// Convert a LaTeX expression body to a nerdamer-friendly form.
// Handles \frac, \sqrt, Greek letters, function names with backslash,
// and spacing macros. Mirrors the limit-core converter.
function latexBodyToExpr(latex) {
    if (!latex) return '';
    var s = String(latex);
    s = s.replace(/\\(left|right|,|;|:|!|>|displaystyle|textstyle|limits|nolimits)\b/g, '');
    s = s.replace(/\\\\/g, ' ');
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
    function expandFrac(input) {
        var out = '', i = 0;
        while (i < input.length) {
            if (input.substr(i, 6) === '\\frac{') {
                var startNum = i + 5;
                var endNum = _findMatchingBrace(input, startNum);
                if (endNum < 0) { out += input.charAt(i++); continue; }
                var startDen = endNum + 1;
                if (input.charAt(startDen) !== '{') { out += input.charAt(i++); continue; }
                var endDen = _findMatchingBrace(input, startDen);
                if (endDen < 0) { out += input.charAt(i++); continue; }
                var num = expandFrac(input.substring(startNum + 1, endNum));
                var den = expandFrac(input.substring(startDen + 1, endDen));
                out += '(' + num + ')/(' + den + ')';
                i = endDen + 1;
            } else { out += input.charAt(i++); }
        }
        return out;
    }
    s = expandFrac(s);
    function expandSqrt(input) {
        var out = '', i = 0;
        while (i < input.length) {
            if (input.substr(i, 6) === '\\sqrt{') {
                var start = i + 5;
                var end = _findMatchingBrace(input, start);
                if (end < 0) { out += input.charAt(i++); continue; }
                out += 'sqrt(' + expandSqrt(input.substring(start + 1, end)) + ')';
                i = end + 1;
            } else { out += input.charAt(i++); }
        }
        return out;
    }
    s = expandSqrt(s);
    s = s.replace(/\\(arcsin|arccos|arctan|arccot|arcsec|arccsc|sin|cos|tan|cot|sec|csc|sinh|cosh|tanh|log|ln|exp|sqrt)\b/g, '$1');
    s = s.replace(/\{([^{}]+)\}/g, '$1');
    s = s.replace(/\\/g, '');
    return s.trim();
}

// Strip trailing "= <answer>" the user may have included after a previous solve.
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

// Parse a full \int [_lo^hi] body dx LaTeX selection
// → { variable, lower, upper, isDefinite, bodyLatex, bodyExpr }
function parseLatexIntegral(fullLatex) {
    if (!fullLatex) return null;
    var s = String(fullLatex).trim();
    s = s.replace(/^\$\$([\s\S]+)\$\$$/, '$1')
         .replace(/^\$([\s\S]+)\$$/, '$1')
         .replace(/^\\\(([\s\S]+)\\\)$/, '$1')
         .replace(/^\\\[([\s\S]+)\\\]$/, '$1')
         .trim();
    s = stripTrailingEquation(s);

    if (s.indexOf('\\int') < 0) return null;
    var intIdx = s.indexOf('\\int');
    // Anything before \int is junk we'd rather not have, but tolerate
    s = s.substring(intIdx);

    var i = 4; // past "\int"
    var lower = null, upper = null;

    function readBound() {
        if (i >= s.length) return null;
        if (s.charAt(i) === '{') {
            var end = _findMatchingBrace(s, i);
            if (end < 0) return null;
            var b = s.substring(i + 1, end).trim();
            i = end + 1;
            return b;
        }
        var m = s.substring(i).match(/^(-?\\\w+|-?[\d.]+|-?[a-zA-Z])/);
        if (m) { i += m[1].length; return m[1]; }
        return null;
    }

    if (s.charAt(i) === '_') { i++; lower = readBound(); }
    if (s.charAt(i) === '^') { i++; upper = readBound(); }
    // Either order is allowed: ^upper before _lower
    if (lower === null && s.charAt(i) === '_') { i++; lower = readBound(); }

    var rest = s.substring(i).trim();

    // Find trailing "dx" — variable preceded by 'd', possibly preceded by spacing macro
    var varMatch = rest.match(/(?:\\[,;:!])?\s*d\s*([a-zA-Z])\b\s*$/);
    if (!varMatch) return null;

    var variable = varMatch[1];
    var bodyLatex = rest.substring(0, varMatch.index).trim();
    var isDefinite = (lower !== null && upper !== null);
    var bodyExpr = normalizeExpr(latexBodyToExpr(bodyLatex));

    return {
        variable: variable,
        lower: lower,
        upper: upper,
        isDefinite: isDefinite,
        bodyLatex: bodyLatex,
        bodyExpr: bodyExpr
    };
}

// Compute via nerdamer integrate/defint. Returns null on hard failure,
// or { method, resultLatex, value, antiderivativeLatex, unresolved }.
function computeIntegral(expr, v, lower, upper) {
    var nd = (typeof nerdamer !== 'undefined') ? nerdamer
           : (typeof window !== 'undefined' && window.nerdamer) ? window.nerdamer
           : null;
    if (!nd) return null;

    var antiderTeX = null, antider = null;
    try {
        antider = nd('integrate(' + expr + ', ' + v + ')');
        antiderTeX = antider.toTeX();
    } catch (e) {}

    if (lower !== null && upper !== null) {
        // Convert bounds to nerdamer-friendly form
        var loExpr = normalizeExpr(latexBodyToExpr(String(lower)));
        var hiExpr = normalizeExpr(latexBodyToExpr(String(upper)));

        // First try nerdamer's built-in defint
        try {
            var def = nd('defint(' + expr + ', ' + loExpr + ', ' + hiExpr + ', ' + v + ')');
            var defTeX = def.toTeX();
            var defTxt = def.text();
            var unresolved = /\\int|defint|integrate/.test(defTeX) ||
                             /defint|integrate/.test(defTxt);
            if (!unresolved) {
                return {
                    method: 'Definite Integral',
                    unresolved: false,
                    resultLatex: defTeX,
                    value: defTxt,
                    antiderivativeLatex: antiderTeX
                };
            }
        } catch (e) { /* fall through to FTC */ }

        // Fallback: Fundamental Theorem of Calculus — F(b) - F(a) via the
        // already-computed antiderivative.
        if (antider && antiderTeX && !/integrate/.test(antider.text())) {
            try {
                var fHi = antider.sub(v, hiExpr);
                var fLo = antider.sub(v, loExpr);
                var diff = nd('simplify((' + fHi.text() + ') - (' + fLo.text() + '))');
                var diffTxt = diff.text();
                var diffTeX = diff.toTeX();
                if (!/integrate|defint/.test(diffTxt)) {
                    return {
                        method: "Definite Integral (FTC)",
                        unresolved: false,
                        resultLatex: diffTeX,
                        value: diffTxt,
                        antiderivativeLatex: antiderTeX
                    };
                }
            } catch (e) { /* fall through */ }
        }

        // Both paths failed — return the unresolved integral
        return {
            method: 'Symbolic (unresolved)',
            unresolved: true,
            resultLatex: '\\int_{' + lower + '}^{' + upper + '} ' + bodyForLatex(expr) + '\\, d' + v,
            value: null,
            antiderivativeLatex: antiderTeX
        };
    }
    // Indefinite
    if (!antider || !antiderTeX) return null;
    var unresolvedI = /\\int|integrate/.test(antiderTeX);
    return {
        method: unresolvedI ? 'Symbolic (unresolved)' : 'Indefinite Integral',
        unresolved: unresolvedI,
        resultLatex: unresolvedI ? antiderTeX : (antiderTeX + ' + C'),
        value: null,
        antiderivativeLatex: antiderTeX
    };
}

// ─────────────────────────────────────────────────────────────────────────
//  SymPy backend bridge — used when nerdamer can't solve symbolically.
//  Reaches out to /OneCompilerFunctionality?action=execute (the same
//  endpoint the live integral-calculator.jsp uses) and runs SymPy.
// ─────────────────────────────────────────────────────────────────────────

// Friendly names for SymPy's manualintegrate Rule classes (mirrors the
// live tool's display map). Used by buildIntegralSteps() to render the
// "Method" line in the worked solution.
var RULE_DISPLAY_NAMES = {
    PartsRule: 'Integration by parts', ExpRule: 'Exponential rule',
    URule: 'u-Substitution',         RewriteRule: 'Rewrite',
    ReciprocalRule: 'Reciprocal',    ArctanRule: 'Arctan rule',
    PowerRule: 'Power rule',         AddRule: 'Sum rule',
    ConstantTimesRule: 'Constant factor',
    AlternativeRule: 'Alternative method',
    ConstantRule: 'Constant rule',   TrigRule: 'Trig rule',
    LogRule: 'Logarithmic',          DontKnowRule: 'No closed-form rule'
};

function extractRuleDisplayNames(rulesStr) {
    if (!rulesStr) return [];
    var matches = rulesStr.match(/\w+Rule/g) || [];
    var seen = {};
    var out = [];
    matches.forEach(function (r) {
        if (seen[r]) return; seen[r] = true;
        out.push(RULE_DISPLAY_NAMES[r] || r);
    });
    return out;
}

var SYMPY_NOT_SYMBOL_NAMES = ['exp','log','sin','cos','tan','sec','csc','cot',
    'sinh','cosh','tanh','coth','csch','sech','sqrt','asin','acos','atan',
    'pi','Sum','Product','Integral','oo','Rational','Mod','Max','Min',
    'min','max','Abs','re','im','gamma','factorial','floor','ceil','ceiling','sign','E'];

/* Convert postfix factorial (`x!`, `(x+1)!`, `(x!)!`) to SymPy/nerdamer's
   prefix `factorial(...)`. Postfix `!` is valid math notation but invalid
   Python syntax — without this step, the generated SymPy code
   `expr = simplify(x!)` throws SyntaxError before any solving begins.
   Skips `!=` (inequality) so it doesn't mangle other code. */
function convertFactorial(s) {
    // DIAGNOSTIC LOG — remove once the cache issue is confirmed past us.
    try { console.log('[IC] convertFactorial IN :', JSON.stringify(s)); } catch (_) {}
    if (!s || s.indexOf('!') < 0) {
        try { console.log('[IC] convertFactorial OUT (no-op):', JSON.stringify(s)); } catch (_) {}
        return s;
    }
    var out = '';
    var i = 0;
    while (i < s.length) {
        var ch = s.charAt(i);
        if (ch !== '!' || s.charAt(i + 1) === '=') {
            out += ch; i++;
            continue;
        }
        var prev = out.charAt(out.length - 1);
        if (prev === ')') {
            // Walk back to the matching '(' through any nesting.
            var depth = 1;
            var j = out.length - 2;
            while (j >= 0 && depth > 0) {
                if (out.charAt(j) === ')') depth++;
                else if (out.charAt(j) === '(') depth--;
                if (depth === 0) break;
                j--;
            }
            if (depth === 0 && j >= 0) {
                out = out.substring(0, j) + 'factorial' + out.substring(j);
                i++;
                continue;
            }
        } else if (/[A-Za-z0-9_]/.test(prev)) {
            // Walk back to the start of the identifier/number token.
            var k = out.length - 1;
            while (k >= 0 && /[A-Za-z0-9_]/.test(out.charAt(k))) k--;
            k++;
            var token = out.substring(k);
            out = out.substring(0, k) + 'factorial(' + token + ')';
            i++;
            continue;
        }
        // Stray '!' with no operand — leave it for SymPy to error on
        // (a clearer message than mangling silently).
        out += ch; i++;
    }
    try { console.log('[IC] convertFactorial OUT:', JSON.stringify(out)); } catch (_) {}
    return out;
}

function nerdamerToPython(expr) {
    try { console.log('[IC] nerdamerToPython IN :', JSON.stringify(expr), '   BUILD-MARKER=v3-factorial-fix-2026-05-15'); } catch (_) {}
    var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|coth|csch|sech|log|ln|sqrt|asin|acos|atan|asinh|acosh|atanh|exp|abs|floor|ceil|min|max|Min|Max|frac|Sum|Rational|Product|Integral|Mod|factorial|gamma|Gamma|beta|erf';
    var py = (expr || '')
        .replace(/e\^([a-zA-Z_]+\([^)]*\))/g, 'exp($1)')
        .replace(/e\^(\([^)]+\))/g, 'exp$1')
        .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
        .replace(/\^/g, '**')
        .replace(/\*\*\((\d+)\/(\d+)\)/g, '**(Rational($1,$2))')
        .replace(/\bInfinity\b/g, 'oo')
        .replace(/(\d)([a-zA-Z])/g, '$1*$2');
    /* Postfix factorial → prefix factorial(). Must run AFTER the e^... and
       ^ rewrites (otherwise `(x+1)!` could be touched mid-rewrite) but
       BEFORE the closing-paren-then-letter implicit-mul step below
       (which would turn `(x+1)!` into `(x+1)*!`). */
    py = convertFactorial(py);
    py = py.replace(new RegExp('\\b(' + FUNS + ')\\(', 'gi'), '$1(');
    py = py.replace(/\)(\()/g, ')*$1')
           .replace(/\)([a-zA-Z])/g, ')*$1')
           .replace(/([a-zA-Z0-9])\(/g, '$1*(');
    try { console.log('[IC] nerdamerToPython OUT:', JSON.stringify(py)); } catch (_) {}
    py = py.replace(/(\w+)\(/g, '$1(');
    return py;
}

function boundToSympy(s) {
    var r = String(s || '')
        .replace(/π/g, 'pi').replace(/∞/g, 'oo').replace(/−/g, '-')
        .replace(/^-?infinity$/i, function (m) { return m.charAt(0) === '-' ? '-oo' : 'oo'; })
        .replace(/^-?inf$/i, function (m) { return m.charAt(0) === '-' ? '-oo' : 'oo'; });
    r = r.replace(/e\^(\([^)]+\))/g, 'exp$1')
        .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
        .replace(/\^/g, '**');
    r = r.replace(/\be\b(?!\s*\()/g, 'E');
    return r;
}

function buildSympySymbolsDecl(v, pyExpr) {
    var seen = {};
    var re = /\b([a-z][a-z]*)\b/g, m;
    while ((m = re.exec(pyExpr)) !== null) {
        var w = m[1];
        if (SYMPY_NOT_SYMBOL_NAMES.indexOf(w) >= 0) continue;
        if (w === v) continue;
        seen[w] = true;
    }
    var extra = Object.keys(seen).sort();
    var all = extra.length > 0 ? extra.concat(v) : [v];
    var opts = (extra.length > 0) ? ", positive=True" : "";
    return all.join(', ') + " = symbols('" + all.join(' ') + "'" + opts + ")";
}

function _ctxPath() {
    if (typeof window === 'undefined') return '';
    return window.MATH_CALC_CTX ||
           window.INTEGRAL_CALC_CTX ||
           (window.CONFIG && window.CONFIG.ctx) ||
           (function () {
               var meta = document.querySelector && document.querySelector('meta[name="ctx"]');
               return meta && meta.content ? meta.content : '';
           })();
}

// Async SymPy solve. Returns a Promise resolving to
//   { ok, resultLatex, value, method, antiderivativeLatex }
// or { ok: false, error: '...' }
function solveViaSympy(expr, v, lower, upper) {
    var pyExpr = nerdamerToPython(expr);
    var symDecl = buildSympySymbolsDecl(v, pyExpr);
    var isDefinite = (lower !== null && upper !== null);
    var aPy = isDefinite ? boundToSympy(latexBodyToExpr(String(lower))) : null;
    var bPy = isDefinite ? boundToSympy(latexBodyToExpr(String(upper))) : null;

    // Walks a SymPy manualintegrate Rule tree and emits
    // [{title, latex}, ...] — proper step-by-step content (partial fractions,
    // u-substitution, integration-by-parts breakdown, etc.).
    var ruleWalkerPy = [
        '_RULE_TITLES = {',
        "    'PowerRule': 'Apply the power rule',",
        "    'URule': 'Apply u-substitution',",
        "    'PartsRule': 'Apply integration by parts',",
        "    'AddRule': 'Use the sum rule (split into terms)',",
        "    'ConstantTimesRule': 'Factor out the constant',",
        "    'ConstantRule': 'Apply the constant rule',",
        "    'RewriteRule': 'Rewrite the integrand',",
        "    'PartialFractionRule': 'Decompose into partial fractions',",
        "    'TrigRule': 'Apply a trigonometric rule',",
        "    'SinRule': r'Apply \\int \\sin = -\\cos rule',",
        "    'CosRule': r'Apply \\int \\cos = \\sin rule',",
        "    'TanRule': r'Apply \\int \\tan rule',",
        "    'CotRule': r'Apply \\int \\cot rule',",
        "    'SecRule': r'Apply \\int \\sec rule',",
        "    'CscRule': r'Apply \\int \\csc rule',",
        "    'PowerRuleSinRule': r'\\sin power rule',",
        "    'PowerRuleCosRule': r'\\cos power rule',",
        "    'ExpRule': 'Apply the exponential rule',",
        "    'LogRule': 'Apply the logarithmic rule (1/x)',",
        "    'ArctanRule': 'Apply the arctangent rule',",
        "    'ReciprocalRule': 'Apply the reciprocal rule',",
        "    'AlternativeRule': 'Alternative method',",
        "    'DontKnowRule': '(No standard rule applies)'",
        '}',
        '',
        '# In modern SymPy (>=1.10), Rule fields are `integrand` and `variable`.',
        'def _count_nodes(rule, _d=0):',
        '    if rule is None or _d > 14: return 0',
        '    n = 1',
        '    try:',
        "        if hasattr(rule, 'substep') and rule.substep is not None:",
        '            n += _count_nodes(rule.substep, _d+1)',
        "        if hasattr(rule, 'substeps') and rule.substeps:",
        '            for s in rule.substeps: n += _count_nodes(s, _d+1)',
        "        if hasattr(rule, 'alternatives') and rule.alternatives:",
        '            n += _count_nodes(rule.alternatives[0], _d+1)',
        "        if hasattr(rule, 'second_step') and rule.second_step is not None:",
        '            n += _count_nodes(rule.second_step, _d+1)',
        '    except: pass',
        '    return n',
        '',
        'def _rule_steps(rule, _depth=0):',
        '    out = []',
        '    if rule is None or _depth > 14: return out',
        '    name = type(rule).__name__',
        '    # AlternativeRule is a chooser, not a step — pick the shortest path and recurse.',
        "    if name == 'AlternativeRule':",
        '        try:',
        '            alts = list(rule.alternatives)',
        '            if alts:',
        '                best = min(alts, key=lambda a: _count_nodes(a))',
        '                return _rule_steps(best, _depth+1)',
        '        except: pass',
        '        return out',
        '    title = _RULE_TITLES.get(name, name)',
        '    rvar = getattr(rule, "variable", None)',
        '    rint = getattr(rule, "integrand", None)',
        '    detail = ""',
        '    try:',
        '        ctx_latex = latex(rint) if rint is not None else ""',
        "        if name == 'PowerRule':",
        '            ne = rule.exp + 1',
        '            detail = r"\\int " + ctx_latex + r"\\, d" + str(rvar) + r" = \\frac{" + str(rvar) + r"^{" + latex(ne) + r"}}{" + latex(ne) + r"}"',
        "        elif name == 'URule':",
        '            uf = rule.u_func',
        '            try: du = simplify(diff(uf, rvar))',
        '            except: du = None',
        '            detail = r"\\text{Let } u = " + latex(uf)',
        '            if du is not None: detail += r",\\quad du = " + latex(du) + r"\\, d" + str(rvar)',
        "        elif name == 'PartsRule':",
        '            try: detail = r"\\text{Let } u = " + latex(rule.u) + r",\\quad dv = " + latex(rule.dv) + r"\\, d" + str(rvar)',
        '            except: pass',
        "        elif name == 'ConstantTimesRule':",
        '            try: detail = r"\\int " + latex(rule.constant) + r"\\cdot " + latex(rule.other) + r"\\, d" + str(rvar) + r" = " + latex(rule.constant) + r"\\, \\int " + latex(rule.other) + r"\\, d" + str(rvar)',
        '            except: pass',
        "        elif name == 'AddRule':",
        '            try:',
        '                terms = [latex(s.integrand) for s in rule.substeps if getattr(s, "integrand", None) is not None]',
        '                if terms: detail = r"\\int \\left(" + " + ".join(terms) + r"\\right) d" + str(rvar) + r" = " + " + ".join([r"\\int " + t + r"\\, d" + str(rvar) for t in terms])',
        '            except: pass',
        "        elif name == 'PartialFractionRule':",
        '            try: detail = ctx_latex + r" = " + latex(rule.partial_fraction)',
        '            except: pass',
        "        elif name == 'RewriteRule':",
        '            try: detail = ctx_latex + r" \\;\\Rightarrow\\; " + latex(rule.rewritten)',
        '            except: pass',
        "        elif name == 'ConstantRule':",
        '            try: detail = r"\\int " + latex(rule.constant) + r"\\, d" + str(rvar) + r" = " + latex(rule.constant) + r"\\, " + str(rvar)',
        '            except: pass',
        "        elif name == 'LogRule':",
        '            detail = r"\\int \\frac{1}{" + str(rvar) + r"}\\, d" + str(rvar) + r" = \\log\\!\\left|" + str(rvar) + r"\\right|"',
        "        elif name == 'ExpRule':",
        '            detail = r"\\int e^{" + str(rvar) + r"}\\, d" + str(rvar) + r" = e^{" + str(rvar) + r"}"',
        "        elif name == 'ArctanRule':",
        '            detail = r"\\int \\frac{1}{1 + " + str(rvar) + r"^{2}}\\, d" + str(rvar) + r" = \\arctan(" + str(rvar) + r")"',
        "        elif name == 'ReciprocalRule':",
        '            try: detail = r"\\int \\frac{1}{" + latex(rule.base) + r"}\\, d" + str(rvar) + r" = \\log\\!\\left|" + latex(rule.base) + r"\\right|"',
        '            except: pass',
        '    except: pass',
        '    fallback = (r"\\int " + ctx_latex + r"\\, d" + str(rvar)) if rint is not None and rvar is not None else ""',
        '    out.append({"title": title, "latex": detail if detail else fallback})',
        '    # Recurse into common children',
        '    try:',
        "        if hasattr(rule, 'substep') and rule.substep is not None:",
        '            out.extend(_rule_steps(rule.substep, _depth+1))',
        "        if hasattr(rule, 'substeps') and rule.substeps is not None:",
        '            for s in rule.substeps:',
        '                out.extend(_rule_steps(s, _depth+1))',
        "        if hasattr(rule, 'second_step') and rule.second_step is not None:",
        '            out.extend(_rule_steps(rule.second_step, _depth+1))',
        '    except: pass',
        '    return out'
    ].join('\n');

    var preamble =
        'from sympy import *\n' +
        'from sympy.integrals.manualintegrate import integral_steps\n' +
        'import json, signal\n' +
        symDecl + '\n' +
        ruleWalkerPy + '\n' +
        'def _t(s,f): raise TimeoutError\n' +
        'signal.signal(signal.SIGALRM, _t)\n' +
        'signal.alarm(10)\n' +
        'try:\n' +
        '    expr = simplify(' + pyExpr + ')\n' +
        '    try:\n' +
        '        _ir = integral_steps(expr, ' + v + ')\n' +
        '        rules_str = str(_ir)\n' +
        '        steps_data = _rule_steps(_ir)\n' +
        '    except:\n' +
        '        rules_str = ""\n' +
        '        steps_data = []\n';

    var bodyDef =
        '    antider = integrate(expr, ' + v + ')\n' +
        '    if isinstance(antider, Integral):\n' +
        '        result = Integral(expr, (' + v + ', ' + aPy + ', ' + bPy + '))\n' +
        '        antider_tex = ""\n' +
        '    else:\n' +
        '        result = integrate(expr, (' + v + ', ' + aPy + ', ' + bPy + '))\n' +
        '        antider_tex = latex(antider)\n' +
        '    out = {\n' +
        '        "ok": True,\n' +
        '        "latex": latex(result),\n' +
        '        "text": str(result),\n' +
        '        "antider_tex": antider_tex,\n' +
        '        "rules_str": rules_str,\n' +
        '        "steps": steps_data,\n' +
        '        "unresolved": isinstance(result, Integral) or result.has(Integral),\n' +
        '    }\n' +
        '    try: out["numeric"] = float(result)\n' +
        '    except: out["numeric"] = None\n';

    var bodyIndef =
        '    result = integrate(expr, ' + v + ')\n' +
        '    out = {\n' +
        '        "ok": True,\n' +
        '        "latex": latex(result),\n' +
        '        "text": str(result),\n' +
        '        "rules_str": rules_str,\n' +
        '        "steps": steps_data,\n' +
        '        "unresolved": isinstance(result, Integral) or result.has(Integral),\n' +
        '    }\n';

    var trailer =
        'except TimeoutError:\n' +
        '    out = {"ok": False, "error": "Solver timed out (10s)"}\n' +
        'except Exception as e:\n' +
        '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e)}\n' +
        'finally:\n' +
        '    signal.alarm(0)\n' +
        'print("RESULT:" + json.dumps(out))\n';

    var code = preamble + (isDefinite ? bodyDef : bodyIndef) + trailer;

    var url = _ctxPath() + '/OneCompilerFunctionality?action=execute';
    return fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python', version: '3.10', code: code })
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        var stdout = (data.Stdout || data.stdout || '').trim();
        var m = stdout.match(/RESULT:(\{[\s\S]*\})/);
        if (!m) return { ok: false, error: 'Solver gave no result' };
        var parsed; try { parsed = JSON.parse(m[1]); }
        catch (e) { return { ok: false, error: 'Solver returned bad data' }; }
        if (!parsed.ok) return { ok: false, error: parsed.error || 'Solver failed' };
        if (parsed.unresolved) {
            return { ok: false, error: 'No closed-form result found' };
        }
        var resultLatex = isDefinite ? parsed.latex : (parsed.latex + ' + C');
        return {
            ok: true,
            method: isDefinite ? 'Definite Integral' : 'Indefinite Integral',
            unresolved: false,
            resultLatex: resultLatex,
            value: parsed.text,
            antiderivativeLatex: parsed.antider_tex || null,
            numericValue: parsed.numeric,
            rulesStr: parsed.rules_str || '',
            ruleDisplayNames: extractRuleDisplayNames(parsed.rules_str || ''),
            sympySteps: Array.isArray(parsed.steps) ? parsed.steps : []
        };
    })
    .catch(function (err) {
        return { ok: false, error: 'Solver network error: ' + (err && err.message || err) };
    });
}

function bodyForLatex(expr) {
    // best-effort fallback when nerdamer can't toTeX; just return expr as-is
    var nd = (typeof nerdamer !== 'undefined') ? nerdamer
           : (typeof window !== 'undefined' && window.nerdamer) ? window.nerdamer : null;
    if (nd) {
        try { return nd(expr).toTeX(); } catch (e) {}
    }
    return expr;
}

function formatValueLatex(value) {
    if (value === null || value === undefined) return '';
    if (value === Infinity) return '\\infty';
    if (value === -Infinity) return '-\\infty';
    return String(value);
}

// Wrap SymPy's per-rule steps in the same shape buildIntegralSteps produces:
// "State the integral" header + per-rule details + "Result" footer.
function wrapSympySteps(parsed, result) {
    var v = parsed.variable;
    var integralLatex = parsed.isDefinite
        ? '\\int_{' + parsed.lower + '}^{' + parsed.upper + '} ' + parsed.bodyLatex + '\\, d' + v
        : '\\int ' + parsed.bodyLatex + '\\, d' + v;

    var out = [{ title: 'State the integral', latex: integralLatex }];
    var inner = (result.sympySteps || []).filter(function (s) {
        // Drop the top-level "DontKnowRule" line — it's noise when integrate() succeeded
        return s && s.title && s.title.indexOf('No standard rule') < 0;
    });
    inner.forEach(function (s) { out.push(s); });

    if (parsed.isDefinite && result.antiderivativeLatex) {
        out.push({
            title: 'Apply the Fundamental Theorem of Calculus',
            latex: '\\left[' + result.antiderivativeLatex + '\\right]_{' + parsed.lower + '}^{' + parsed.upper + '} = ' + result.resultLatex
        });
    }
    out.push({ title: 'Result', latex: integralLatex + ' = ' + result.resultLatex });
    return out;
}

// Build a step list for the integral. Works with either the nerdamer or
// SymPy result shape. If ruleDisplayNames is non-empty (SymPy path), a
// "Method" line is included between "State" and "Antiderivative".
function buildIntegralSteps(parsed, result) {
    var steps = [];
    var v = parsed.variable;
    var integralLatex = parsed.isDefinite
        ? '\\int_{' + parsed.lower + '}^{' + parsed.upper + '} ' + parsed.bodyLatex + '\\, d' + v
        : '\\int ' + parsed.bodyLatex + '\\, d' + v;

    steps.push({ title: 'State the integral', latex: integralLatex });

    var ruleNames = result.ruleDisplayNames || [];
    if (ruleNames.length) {
        // Drop "No closed-form rule" (DontKnowRule) when the integral was
        // actually solved — happens when SymPy's manualintegrate doesn't
        // recognise the path but integrate() succeeded anyway.
        var meaningful = ruleNames.filter(function (n) { return n !== 'No closed-form rule'; });
        if (meaningful.length) {
            steps.push({
                title: 'Method',
                latex: '\\text{' + meaningful.join(', ') + '}'
            });
        }
    }

    if (parsed.isDefinite) {
        if (result.antiderivativeLatex) {
            steps.push({
                title: 'Find the antiderivative',
                latex: 'F(' + v + ') = ' + result.antiderivativeLatex
            });
            steps.push({
                title: 'Apply the Fundamental Theorem of Calculus',
                latex: '\\left[F(' + v + ')\\right]_{' + parsed.lower + '}^{' + parsed.upper + '}' +
                       ' = F(' + parsed.upper + ') - F(' + parsed.lower + ') = ' + result.resultLatex
            });
        } else {
            steps.push({
                title: 'Compute the definite integral',
                latex: integralLatex + ' = ' + result.resultLatex
            });
        }
    } else {
        steps.push({
            title: 'Antiderivative',
            latex: result.resultLatex
        });
    }

    steps.push({
        title: 'Result',
        latex: integralLatex + ' = ' + result.resultLatex
    });

    return steps;
}

// Returns a Promise<{ok, input, result, resultLatex, method, [steps]} | {ok:false, error}>.
//
// Modes:
//   - opts.withSteps = false  →  nerdamer first (sync, fast); SymPy fallback if unresolved
//   - opts.withSteps = true   →  SymPy first (rich step-by-step from integral_steps);
//                                fall back to nerdamer's basic 3-step if SymPy fails
function solveFromLatex(fullLatex, opts) {
    opts = opts || {};
    var parsed = parseLatexIntegral(fullLatex);
    if (!parsed) {
        return Promise.resolve({ ok: false, error: 'Could not parse integral from "' + fullLatex + '"' });
    }
    var nd = (typeof nerdamer !== 'undefined') ? nerdamer
           : (typeof window !== 'undefined' && window.nerdamer) ? window.nerdamer : null;
    if (!nd) return Promise.resolve({ ok: false, error: 'Math engine not loaded' });

    function nerdamerOnce() {
        try { return computeIntegral(parsed.bodyExpr, parsed.variable, parsed.lower, parsed.upper); }
        catch (e) { return null; }
    }

    // ── Steps mode: SymPy first for the rich rule-tree breakdown ─────────────
    if (opts.withSteps && opts.useSympy !== false) {
        return solveViaSympy(parsed.bodyExpr, parsed.variable, parsed.lower, parsed.upper)
            .then(function (sym) {
                if (sym.ok) {
                    return {
                        ok: true,
                        input: parsed,
                        result: sym,
                        resultLatex: sym.resultLatex,
                        method: sym.method,
                        steps: wrapSympySteps(parsed, sym)
                    };
                }
                // SymPy failed — try nerdamer's basic 3-step fallback
                var nr = nerdamerOnce();
                if (nr && !nr.unresolved) {
                    return {
                        ok: true,
                        input: parsed,
                        result: nr,
                        resultLatex: nr.resultLatex,
                        method: nr.method + ' (basic steps)',
                        steps: buildIntegralSteps(parsed, nr)
                    };
                }
                return { ok: false, error: sym.error };
            });
    }

    // ── Plain solve / show graph: nerdamer first, SymPy if unresolved ───────
    var ndResult = nerdamerOnce();
    if (ndResult && !ndResult.unresolved) {
        return Promise.resolve({
            ok: true,
            input: parsed,
            result: ndResult,
            resultLatex: ndResult.resultLatex,
            method: ndResult.method
        });
    }

    if (opts.useSympy === false) {
        return Promise.resolve({
            ok: false,
            error: 'No closed-form result; advanced solver disabled.'
        });
    }

    return solveViaSympy(parsed.bodyExpr, parsed.variable, parsed.lower, parsed.upper)
        .then(function (sympyResult) {
            if (sympyResult.ok) {
                return {
                    ok: true,
                    input: parsed,
                    result: sympyResult,
                    resultLatex: sympyResult.resultLatex,
                    method: sympyResult.method
                };
            }
            return {
                ok: false,
                error: 'No closed-form result: ' + sympyResult.error
            };
        });
}

var api = {
    normalizeExpr: normalizeExpr,
    checkNonElementaryIntegral: checkNonElementaryIntegral,
    evalBound: evalBound,
    checkKingsProperty: checkKingsProperty,
    parseSympyStyleInput: parseSympyStyleInput,
    // ── New LaTeX-driven API used by the editor's Σ Solve ──
    latexBodyToExpr: latexBodyToExpr,
    stripTrailingEquation: stripTrailingEquation,
    parseLatexIntegral: parseLatexIntegral,
    compute: computeIntegral,
    formatValueLatex: formatValueLatex,
    nerdamerToPython: nerdamerToPython,
    boundToSympy: boundToSympy,
    buildSympySymbolsDecl: buildSympySymbolsDecl,
    extractRuleDisplayNames: extractRuleDisplayNames,
    RULE_DISPLAY_NAMES: RULE_DISPLAY_NAMES,
    buildIntegralSteps: buildIntegralSteps,
    solveViaSympy: solveViaSympy,
    solveFromLatex: solveFromLatex   // returns Promise — nerdamer first, SymPy fallback
};

if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
} else {
    var g = typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};
    g.IntegralCalculatorCore = api;
}
