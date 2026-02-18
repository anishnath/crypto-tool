/**
 * Trigonometry Calculator - Common Helpers & Data
 * Shared by all 3 trig pages
 */
(function() {
'use strict';

// ==================== Formatting Helpers ====================

function fmt(n) {
    if (typeof n === 'string') return n;
    if (Number.isInteger(n)) return String(n);
    var s = n.toFixed(6);
    return s.replace(/\.?0+$/, '') || '0';
}

function renderKaTeX(el, latex, displayMode) {
    try {
        katex.render(latex, el, { displayMode: displayMode !== false, throwOnError: false });
    } catch (e) {
        el.textContent = latex;
    }
}

function buildStepDOM(number, desc, latex) {
    var step = document.createElement('div');
    step.className = 'trig-step';

    var numEl = document.createElement('div');
    numEl.className = 'trig-step-number';
    numEl.textContent = number;
    step.appendChild(numEl);

    var content = document.createElement('div');
    content.className = 'trig-step-content';

    if (desc) {
        var descEl = document.createElement('div');
        descEl.className = 'trig-step-desc';
        descEl.innerHTML = desc;
        content.appendChild(descEl);
    }

    if (latex) {
        var mathEl = document.createElement('div');
        mathEl.className = 'trig-step-math';
        renderKaTeX(mathEl, latex, true);
        content.appendChild(mathEl);
    }

    step.appendChild(content);
    return step;
}

function safeTeX(expr) {
    if (typeof nerdamer !== 'undefined') {
        try {
            return nerdamer(expr).toTeX();
        } catch (e) { /* fallback */ }
    }
    return expr;
}

/**
 * Convert a trig expression string to presentable LaTeX (no nerdamer required).
 * Handles: sin, cos, tan, csc, sec, cot, arcsin/asin, ^2, pi, *, /, fractions, >=, <=, >, <
 *
 * Examples:
 *   sin(45)           → \sin(45)
 *   cos(pi/3)         → \cos(\frac{\pi}{3})
 *   tan(x)^2          → \tan(x)^{2}
 *   sec(x)/(2*sin(x)) → \frac{\sec(x)}{2\sin(x)}
 *   sin(x) > 1/2      → \sin(x) > \frac{1}{2}
 *   1 - cos(2*x)      → 1 - \cos(2x)
 */
function exprToLatex(expr) {
    if (!expr) return '';
    // If already contains LaTeX backslash commands, return as-is
    if (/\\(sin|cos|tan|frac|left|right|pi|theta|csc|sec|cot|cdot)/.test(expr)) return expr;

    var s = expr.trim();

    // Step 1: Handle top-level division as \frac{numerator}{denominator}
    // Find the main '/' that splits the expression (not inside parentheses)
    s = _wrapFractions(s);

    // Step 2: Replace trig/math function names with LaTeX commands
    var funcs = ['arcsin','arccos','arctan','arccot','arcsec','arccsc','asin','acos','atan','sinh','cosh','tanh','sin','cos','tan','csc','sec','cot','log','ln','sqrt'];
    for (var i = 0; i < funcs.length; i++) {
        var f = funcs[i];
        var re = new RegExp('\\b' + f + '(?=\\s*[\\({]|\\s*[a-zA-Z0-9]|\\s*\\^)', 'g');
        s = s.replace(re, '\\' + f);
    }
    // Catch remaining standalone function names not followed by parens
    for (var i = 0; i < funcs.length; i++) {
        var f = funcs[i];
        var re = new RegExp('\\b' + f + '\\b', 'g');
        s = s.replace(re, '\\' + f);
    }

    // Step 3: pi → \pi, theta → \theta
    s = s.replace(/\bpi\b/gi, '\\pi');
    s = s.replace(/\btheta\b/gi, '\\theta');

    // Step 4: ^2, ^3, ^n → ^{2}, ^{3}, ^{n}
    s = s.replace(/\^([0-9a-zA-Z])/g, '^{$1}');

    // Step 5: Remove explicit * between coefficient and function: 2\cdot \sin → 2\sin
    // But keep * between variables: x*y → x \cdot y
    s = s.replace(/\*/g, ' ');
    // Clean up: number directly before \func doesn't need space
    s = s.replace(/(\d)\s+(\\(?:sin|cos|tan|csc|sec|cot|log|ln|sqrt|arcsin|arccos|arctan|pi))/g, '$1$2');

    // Step 6: >= and <= → \geq, \leq
    s = s.replace(/>=/g, '\\geq ');
    s = s.replace(/<=/g, '\\leq ');

    return s;
}

/**
 * Find top-level '/' in an expression and wrap as \frac{num}{den}.
 * Respects parentheses nesting. Only handles a single top-level '/'.
 */
function _wrapFractions(s) {
    // Find '/' that is not inside parentheses
    var depth = 0;
    var slashIdx = -1;
    for (var i = 0; i < s.length; i++) {
        if (s[i] === '(') depth++;
        else if (s[i] === ')') depth--;
        else if (s[i] === '/' && depth === 0) {
            slashIdx = i;
            break;
        }
    }
    if (slashIdx === -1) return s;

    var num = s.substring(0, slashIdx).trim();
    var den = s.substring(slashIdx + 1).trim();

    // Strip outer parens if the entire numerator/denominator is wrapped
    num = _stripOuterParens(num);
    den = _stripOuterParens(den);

    // Recursively handle fractions inside num and den
    num = _wrapFractions(num);
    den = _wrapFractions(den);

    return '\\frac{' + num + '}{' + den + '}';
}

/**
 * Strip outer parentheses if they wrap the entire expression.
 * e.g. "(2*sin(x))" → "2*sin(x)" but "(a+b)*(c+d)" stays.
 */
function _stripOuterParens(s) {
    if (s.length < 2 || s[0] !== '(') return s;
    var depth = 0;
    for (var i = 0; i < s.length; i++) {
        if (s[i] === '(') depth++;
        else if (s[i] === ')') depth--;
        if (depth === 0 && i < s.length - 1) return s; // closing paren isn't the last char
    }
    if (depth === 0) return s.substring(1, s.length - 1);
    return s;
}

// ==================== AI Integration ====================

/**
 * Fix common AI LaTeX issues:
 * - Adjacent \text{} blocks losing spaces between them
 * - Ensure space after \text{...} before math content
 * - Purely-text LaTeX rendered properly
 */
function fixAILatex(latex) {
    if (!latex) return latex;
    // 1. Fix bare trig function names that AI forgot to escape: sin( → \sin(
    //    Only match if NOT already preceded by backslash
    var trigFuncs = ['arcsin','arccos','arctan','arccot','arcsec','arccsc','sinh','cosh','tanh','sin','cos','tan','csc','sec','cot','log','ln'];
    for (var i = 0; i < trigFuncs.length; i++) {
        var f = trigFuncs[i];
        // Match function name NOT preceded by \ and followed by ( or space or ^
        var re = new RegExp('(?<!\\\\)\\b(' + f + ')\\s*(?=[\\(\\^])', 'g');
        latex = latex.replace(re, '\\' + f);
    }
    // 2. Ensure space between adjacent \text{} blocks: \text{foo}\text{bar} → \text{foo} \text{bar}
    latex = latex.replace(/\}\\text\{/g, '} \\text{');
    // 3. Ensure space after \text{...} when followed by math (letter, \, [, ()
    latex = latex.replace(/\}([a-zA-Z\[\(\\])/g, '} $1');
    // 4. Ensure space before \text{} when preceded by math content
    latex = latex.replace(/([a-zA-Z0-9\)\]])\\text\{/g, '$1 \\text{');
    // 5. Use \; (medium space) between closing } and opening [ for intervals
    latex = latex.replace(/\} \[/g, '} \\; [');
    return latex;
}

function showAISteps(container, steps, method) {
    if (!steps || !steps.length) {
        showError(container, 'No steps returned.');
        return;
    }
    container.innerHTML = '';

    if (method) {
        var badge = document.createElement('div');
        badge.className = 'trig-result-badge';
        badge.textContent = method;
        container.appendChild(badge);
    }

    for (var i = 0; i < steps.length; i++) {
        var s = steps[i];
        var title = s.title || s.t || '';
        var latex = fixAILatex(s.latex || s.l || '');
        container.appendChild(buildStepDOM(i + 1, title, latex));
    }
}

function showError(container, message) {
    container.innerHTML = '';
    var div = document.createElement('div');
    div.className = 'trig-error';
    div.textContent = message;
    container.appendChild(div);
}

function showSpinner(container, message) {
    container.innerHTML = '';
    var wrap = document.createElement('div');
    wrap.className = 'trig-spinner';
    var ring = document.createElement('div');
    ring.className = 'trig-spinner-ring';
    wrap.appendChild(ring);
    var text = document.createElement('div');
    text.className = 'trig-spinner-text';
    text.textContent = message || 'Solving...';
    wrap.appendChild(text);
    container.appendChild(wrap);
}

function callAI(operation, expression, mode, variable, answer, callback) {
    var contextPath = document.querySelector('meta[name="context-path"]');
    var base = contextPath ? contextPath.getAttribute('content') : '';
    var url = base + '/CFExamMarkerFunctionality?action=math_steps';

    var payload = {
        operation: operation,
        expression: expression,
        mode: mode || '',
        variable: variable || 'x'
    };
    if (answer) payload.answer = answer;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                var data = JSON.parse(xhr.responseText);
                if (data.success && data.steps) {
                    callback(null, data.steps, data.method || '');
                } else {
                    callback(data.error || 'Unexpected response');
                }
            } catch (e) {
                callback('Failed to parse response');
            }
        } else {
            callback('Server error (' + xhr.status + ')');
        }
    };
    xhr.onerror = function() { callback('Network error'); };
    xhr.send(JSON.stringify(payload));
}

// ==================== Angle Helpers ====================

function normalizeAngleDeg(deg) {
    deg = deg % 360;
    if (deg < 0) deg += 360;
    return deg;
}

function degToRad(deg) {
    return deg * Math.PI / 180;
}

function radToDeg(rad) {
    return rad * 180 / Math.PI;
}

function getQuadrant(deg) {
    deg = normalizeAngleDeg(deg);
    if (deg === 0 || deg === 360) return 1;
    if (deg > 0 && deg < 90) return 1;
    if (deg === 90) return 1; // on axis, convention Q1
    if (deg > 90 && deg < 180) return 2;
    if (deg === 180) return 2;
    if (deg > 180 && deg < 270) return 3;
    if (deg === 270) return 3;
    return 4;
}

function getReferenceAngle(deg) {
    deg = normalizeAngleDeg(deg);
    if (deg <= 90) return deg;
    if (deg <= 180) return 180 - deg;
    if (deg <= 270) return deg - 180;
    return 360 - deg;
}

function getQuadrantSigns(q) {
    // All Students Take Calculus
    var signs = {
        1: { sin: 1, cos: 1, tan: 1, csc: 1, sec: 1, cot: 1 },
        2: { sin: 1, cos: -1, tan: -1, csc: 1, sec: -1, cot: -1 },
        3: { sin: -1, cos: -1, tan: 1, csc: -1, sec: -1, cot: 1 },
        4: { sin: -1, cos: 1, tan: -1, csc: -1, sec: 1, cot: -1 }
    };
    return signs[q] || signs[1];
}

// ==================== Special Angles Table ====================

var SPECIAL_ANGLES = {
    0:   { sin: '0',                   cos: '1',                   tan: '0',                   csc: '\\text{undefined}',   sec: '1',                   cot: '\\text{undefined}',   sinVal: 0, cosVal: 1 },
    30:  { sin: '\\frac{1}{2}',        cos: '\\frac{\\sqrt{3}}{2}', tan: '\\frac{1}{\\sqrt{3}}', csc: '2',                 sec: '\\frac{2}{\\sqrt{3}}', cot: '\\sqrt{3}',          sinVal: 0.5, cosVal: Math.sqrt(3)/2 },
    45:  { sin: '\\frac{\\sqrt{2}}{2}', cos: '\\frac{\\sqrt{2}}{2}', tan: '1',                  csc: '\\sqrt{2}',          sec: '\\sqrt{2}',          cot: '1',                   sinVal: Math.SQRT2/2, cosVal: Math.SQRT2/2 },
    60:  { sin: '\\frac{\\sqrt{3}}{2}', cos: '\\frac{1}{2}',        tan: '\\sqrt{3}',          csc: '\\frac{2}{\\sqrt{3}}', sec: '2',                 cot: '\\frac{1}{\\sqrt{3}}', sinVal: Math.sqrt(3)/2, cosVal: 0.5 },
    90:  { sin: '1',                   cos: '0',                   tan: '\\text{undefined}',   csc: '1',                   sec: '\\text{undefined}',   cot: '0',                   sinVal: 1, cosVal: 0 },
    120: { sin: '\\frac{\\sqrt{3}}{2}', cos: '-\\frac{1}{2}',      tan: '-\\sqrt{3}',          csc: '\\frac{2}{\\sqrt{3}}', sec: '-2',                cot: '-\\frac{1}{\\sqrt{3}}', sinVal: Math.sqrt(3)/2, cosVal: -0.5 },
    135: { sin: '\\frac{\\sqrt{2}}{2}', cos: '-\\frac{\\sqrt{2}}{2}', tan: '-1',               csc: '\\sqrt{2}',          sec: '-\\sqrt{2}',         cot: '-1',                  sinVal: Math.SQRT2/2, cosVal: -Math.SQRT2/2 },
    150: { sin: '\\frac{1}{2}',        cos: '-\\frac{\\sqrt{3}}{2}', tan: '-\\frac{1}{\\sqrt{3}}', csc: '2',              sec: '-\\frac{2}{\\sqrt{3}}', cot: '-\\sqrt{3}',        sinVal: 0.5, cosVal: -Math.sqrt(3)/2 },
    180: { sin: '0',                   cos: '-1',                  tan: '0',                   csc: '\\text{undefined}',   sec: '-1',                  cot: '\\text{undefined}',   sinVal: 0, cosVal: -1 },
    210: { sin: '-\\frac{1}{2}',       cos: '-\\frac{\\sqrt{3}}{2}', tan: '\\frac{1}{\\sqrt{3}}', csc: '-2',              sec: '-\\frac{2}{\\sqrt{3}}', cot: '\\sqrt{3}',         sinVal: -0.5, cosVal: -Math.sqrt(3)/2 },
    225: { sin: '-\\frac{\\sqrt{2}}{2}', cos: '-\\frac{\\sqrt{2}}{2}', tan: '1',               csc: '-\\sqrt{2}',         sec: '-\\sqrt{2}',         cot: '1',                   sinVal: -Math.SQRT2/2, cosVal: -Math.SQRT2/2 },
    240: { sin: '-\\frac{\\sqrt{3}}{2}', cos: '-\\frac{1}{2}',     tan: '\\sqrt{3}',          csc: '-\\frac{2}{\\sqrt{3}}', sec: '-2',               cot: '\\frac{1}{\\sqrt{3}}', sinVal: -Math.sqrt(3)/2, cosVal: -0.5 },
    270: { sin: '-1',                  cos: '0',                   tan: '\\text{undefined}',   csc: '-1',                  sec: '\\text{undefined}',   cot: '0',                   sinVal: -1, cosVal: 0 },
    300: { sin: '-\\frac{\\sqrt{3}}{2}', cos: '\\frac{1}{2}',     tan: '-\\sqrt{3}',          csc: '-\\frac{2}{\\sqrt{3}}', sec: '2',                cot: '-\\frac{1}{\\sqrt{3}}', sinVal: -Math.sqrt(3)/2, cosVal: 0.5 },
    315: { sin: '-\\frac{\\sqrt{2}}{2}', cos: '\\frac{\\sqrt{2}}{2}', tan: '-1',              csc: '-\\sqrt{2}',         sec: '\\sqrt{2}',          cot: '-1',                  sinVal: -Math.SQRT2/2, cosVal: Math.SQRT2/2 },
    330: { sin: '-\\frac{1}{2}',       cos: '\\frac{\\sqrt{3}}{2}', tan: '-\\frac{1}{\\sqrt{3}}', csc: '-2',             sec: '\\frac{2}{\\sqrt{3}}', cot: '-\\sqrt{3}',         sinVal: -0.5, cosVal: Math.sqrt(3)/2 },
    360: { sin: '0',                   cos: '1',                   tan: '0',                   csc: '\\text{undefined}',   sec: '1',                   cot: '\\text{undefined}',   sinVal: 0, cosVal: 1 }
};

// ==================== Identity Categories ====================

var IDENTITY_CATEGORIES = {
    pythagorean: {
        name: 'Pythagorean Identities',
        identities: [
            { latex: '\\sin^2\\theta + \\cos^2\\theta = 1', description: 'Fundamental Pythagorean identity' },
            { latex: '1 + \\tan^2\\theta = \\sec^2\\theta', description: 'Divide by cos²θ' },
            { latex: '1 + \\cot^2\\theta = \\csc^2\\theta', description: 'Divide by sin²θ' }
        ]
    },
    sum_difference: {
        name: 'Sum & Difference Formulas',
        identities: [
            { latex: '\\sin(A \\pm B) = \\sin A\\cos B \\pm \\cos A\\sin B', description: 'Sine of sum/difference' },
            { latex: '\\cos(A \\pm B) = \\cos A\\cos B \\mp \\sin A\\sin B', description: 'Cosine of sum/difference' },
            { latex: '\\tan(A \\pm B) = \\frac{\\tan A \\pm \\tan B}{1 \\mp \\tan A\\tan B}', description: 'Tangent of sum/difference' }
        ]
    },
    double_angle: {
        name: 'Double Angle Formulas',
        identities: [
            { latex: '\\sin 2A = 2\\sin A\\cos A', description: 'Sine double angle' },
            { latex: '\\cos 2A = \\cos^2 A - \\sin^2 A = 2\\cos^2 A - 1 = 1 - 2\\sin^2 A', description: 'Cosine double angle (3 forms)' },
            { latex: '\\tan 2A = \\frac{2\\tan A}{1 - \\tan^2 A}', description: 'Tangent double angle' }
        ]
    },
    half_angle: {
        name: 'Half Angle Formulas',
        identities: [
            { latex: '\\sin\\frac{A}{2} = \\pm\\sqrt{\\frac{1 - \\cos A}{2}}', description: 'Sine half angle' },
            { latex: '\\cos\\frac{A}{2} = \\pm\\sqrt{\\frac{1 + \\cos A}{2}}', description: 'Cosine half angle' },
            { latex: '\\tan\\frac{A}{2} = \\frac{\\sin A}{1 + \\cos A} = \\frac{1 - \\cos A}{\\sin A}', description: 'Tangent half angle' }
        ]
    },
    negative_angle: {
        name: 'Negative Angle (Even/Odd) Identities',
        identities: [
            { latex: '\\sin(-\\theta) = -\\sin\\theta', description: 'Sine is odd' },
            { latex: '\\cos(-\\theta) = \\cos\\theta', description: 'Cosine is even' },
            { latex: '\\tan(-\\theta) = -\\tan\\theta', description: 'Tangent is odd' },
            { latex: '\\csc(-\\theta) = -\\csc\\theta', description: 'Cosecant is odd' },
            { latex: '\\sec(-\\theta) = \\sec\\theta', description: 'Secant is even' },
            { latex: '\\cot(-\\theta) = -\\cot\\theta', description: 'Cotangent is odd' }
        ]
    },
    sum_to_product: {
        name: 'Sum-to-Product Formulas',
        identities: [
            { latex: '\\sin A + \\sin B = 2\\sin\\frac{A+B}{2}\\cos\\frac{A-B}{2}', description: 'Sum of sines' },
            { latex: '\\sin A - \\sin B = 2\\cos\\frac{A+B}{2}\\sin\\frac{A-B}{2}', description: 'Difference of sines' },
            { latex: '\\cos A + \\cos B = 2\\cos\\frac{A+B}{2}\\cos\\frac{A-B}{2}', description: 'Sum of cosines' },
            { latex: '\\cos A - \\cos B = -2\\sin\\frac{A+B}{2}\\sin\\frac{A-B}{2}', description: 'Difference of cosines' }
        ]
    },
    product_to_sum: {
        name: 'Product-to-Sum Formulas',
        identities: [
            { latex: '\\sin A\\cos B = \\frac{1}{2}[\\sin(A+B) + \\sin(A-B)]', description: 'Sine × Cosine' },
            { latex: '\\cos A\\cos B = \\frac{1}{2}[\\cos(A-B) + \\cos(A+B)]', description: 'Cosine × Cosine' },
            { latex: '\\sin A\\sin B = \\frac{1}{2}[\\cos(A-B) - \\cos(A+B)]', description: 'Sine × Sine' }
        ]
    },
    cofunction: {
        name: 'Cofunction Identities',
        identities: [
            { latex: '\\sin\\theta = \\cos(90^\\circ - \\theta)', description: 'Sine = cosine of complement' },
            { latex: '\\cos\\theta = \\sin(90^\\circ - \\theta)', description: 'Cosine = sine of complement' },
            { latex: '\\tan\\theta = \\cot(90^\\circ - \\theta)', description: 'Tangent = cotangent of complement' },
            { latex: '\\sec\\theta = \\csc(90^\\circ - \\theta)', description: 'Secant = cosecant of complement' }
        ]
    }
};

// ==================== Export Namespace ====================

window.TrigCommon = {
    fmt: fmt,
    renderKaTeX: renderKaTeX,
    buildStepDOM: buildStepDOM,
    safeTeX: safeTeX,
    exprToLatex: exprToLatex,
    showAISteps: showAISteps,
    showError: showError,
    showSpinner: showSpinner,
    callAI: callAI,
    normalizeAngleDeg: normalizeAngleDeg,
    degToRad: degToRad,
    radToDeg: radToDeg,
    getQuadrant: getQuadrant,
    getReferenceAngle: getReferenceAngle,
    getQuadrantSigns: getQuadrantSigns,
    SPECIAL_ANGLES: SPECIAL_ANGLES,
    IDENTITY_CATEGORIES: IDENTITY_CATEGORIES
};

})();
