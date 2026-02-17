/**
 * Exponent Calculator - Render Module
 * KaTeX step-by-step rendering for exponent laws
 */
(function() {
'use strict';

// ==================== Helpers ====================

function fmt(n) {
    if (n === 0) return '0';
    if (!isFinite(n)) return String(n);
    if (Math.abs(n - Math.round(n)) < 1e-9) return String(Math.round(n));
    return n.toFixed(6).replace(/\.?0+$/, '');
}

function fmtSci(n) {
    if (Math.abs(n) >= 1e6 || (Math.abs(n) < 0.001 && n !== 0)) {
        return n.toExponential(4);
    }
    return fmt(n);
}

function renderKaTeX(el, latex, displayMode) {
    if (!el || !window.katex) return;
    try {
        katex.render(latex, el, { displayMode: displayMode !== false, throwOnError: false });
    } catch (e) {
        el.textContent = latex;
    }
}

function buildStepDOM(number, description, latex) {
    var step = document.createElement('div');
    step.className = 'ec-step';

    var numEl = document.createElement('div');
    numEl.className = 'ec-step-number';
    numEl.textContent = number;

    var content = document.createElement('div');
    content.className = 'ec-step-content';

    var desc = document.createElement('div');
    desc.className = 'ec-step-desc';
    desc.innerHTML = description;

    content.appendChild(desc);

    if (latex) {
        var math = document.createElement('div');
        math.className = 'ec-step-math';
        renderKaTeX(math, latex, true);
        content.appendChild(math);
    }

    step.appendChild(numEl);
    step.appendChild(content);
    return step;
}

// ==================== Basic Power ====================

function renderBasicPower(container, base, exp) {
    if (!container) return;
    container.innerHTML = '';

    var result = Math.pow(base, exp);

    // Result header
    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Basic Power: a<sup>n</sup></span>';
    container.appendChild(header);

    // Main result
    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, fmt(base) + '^{' + fmt(exp) + '} = ' + fmtSci(result), true);
    container.appendChild(resultDiv);

    // Steps
    if (exp === 0) {
        container.appendChild(buildStepDOM(1, '<strong>Zero Exponent Rule:</strong> Any non-zero number raised to 0 equals 1',
            fmt(base) + '^{0} = 1'));
        container.appendChild(buildStepDOM(2, '<strong>Why?</strong> Using quotient rule: a<sup>n</sup> &divide; a<sup>n</sup> = a<sup>0</sup> = 1', null));
    } else if (exp < 0) {
        container.appendChild(buildStepDOM(1, '<strong>Negative Exponent Rule:</strong> a<sup>&minus;n</sup> = 1/a<sup>n</sup>',
            fmt(base) + '^{' + fmt(exp) + '} = \\frac{1}{' + fmt(base) + '^{' + fmt(-exp) + '}}'));
        container.appendChild(buildStepDOM(2, '<strong>Calculate positive power</strong>',
            fmt(base) + '^{' + fmt(-exp) + '} = ' + fmtSci(Math.pow(base, -exp))));
        container.appendChild(buildStepDOM(3, '<strong>Take reciprocal</strong>',
            '\\frac{1}{' + fmtSci(Math.pow(base, -exp)) + '} = ' + fmtSci(result)));
    } else if (exp % 1 !== 0) {
        // Fractional exponent
        container.appendChild(buildStepDOM(1, '<strong>Fractional Exponent:</strong> Represents a root combined with a power',
            fmt(base) + '^{' + fmt(exp) + '} = ' + fmtSci(result)));
    } else if (exp > 0 && exp <= 8) {
        // Show repeated multiplication
        var parts = [];
        for (var i = 0; i < exp; i++) parts.push(fmt(base));
        container.appendChild(buildStepDOM(1, '<strong>Repeated Multiplication</strong>',
            fmt(base) + '^{' + fmt(exp) + '} = ' + parts.join(' \\times ') + ' = ' + fmtSci(result)));
    } else {
        container.appendChild(buildStepDOM(1, '<strong>Calculation</strong>',
            fmt(base) + '^{' + fmt(exp) + '} = ' + fmtSci(result)));
    }

    // Scientific notation for large/small
    if (Math.abs(result) >= 1e6 || (Math.abs(result) < 0.001 && result !== 0)) {
        container.appendChild(buildStepDOM('&#9881;', '<strong>Scientific Notation</strong>',
            fmt(base) + '^{' + fmt(exp) + '} = ' + result.toExponential(4)));
    }
}

// ==================== Exponent Rules ====================

function renderProductRule(container, base, m, n) {
    if (!container) return;
    container.innerHTML = '';
    var result = Math.pow(base, m + n);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Product Rule: a<sup>m</sup> &times; a<sup>n</sup> = a<sup>m+n</sup></span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, fmt(base) + '^{' + fmt(m) + '} \\times ' + fmt(base) + '^{' + fmt(n) + '} = ' + fmt(base) + '^{' + fmt(m + n) + '}', true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Identify same base</strong>', '\\text{Base} = ' + fmt(base)));
    container.appendChild(buildStepDOM(2, '<strong>Add exponents</strong>', fmt(m) + ' + ' + fmt(n) + ' = ' + fmt(m + n)));
    container.appendChild(buildStepDOM(3, '<strong>Write result</strong>',
        fmt(base) + '^{' + fmt(m) + '} \\times ' + fmt(base) + '^{' + fmt(n) + '} = ' + fmt(base) + '^{' + fmt(m + n) + '} = ' + fmtSci(result)));
}

function renderQuotientRule(container, base, m, n) {
    if (!container) return;
    container.innerHTML = '';
    var result = Math.pow(base, m - n);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Quotient Rule: a<sup>m</sup> &divide; a<sup>n</sup> = a<sup>m&minus;n</sup></span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, '\\frac{' + fmt(base) + '^{' + fmt(m) + '}}{' + fmt(base) + '^{' + fmt(n) + '}} = ' + fmt(base) + '^{' + fmt(m - n) + '}', true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Identify same base</strong>', '\\text{Base} = ' + fmt(base)));
    container.appendChild(buildStepDOM(2, '<strong>Subtract exponents</strong>', fmt(m) + ' - ' + fmt(n) + ' = ' + fmt(m - n)));
    container.appendChild(buildStepDOM(3, '<strong>Write result</strong>',
        fmt(base) + '^{' + fmt(m - n) + '} = ' + fmtSci(result)));
}

function renderPowerRule(container, base, m, n) {
    if (!container) return;
    container.innerHTML = '';
    var result = Math.pow(base, m * n);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Power Rule: (a<sup>m</sup>)<sup>n</sup> = a<sup>mn</sup></span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, '(' + fmt(base) + '^{' + fmt(m) + '})^{' + fmt(n) + '} = ' + fmt(base) + '^{' + fmt(m * n) + '}', true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Identify base and exponents</strong>',
        '\\text{Base} = ' + fmt(base) + ', \\quad m = ' + fmt(m) + ', \\quad n = ' + fmt(n)));
    container.appendChild(buildStepDOM(2, '<strong>Multiply exponents</strong>', fmt(m) + ' \\times ' + fmt(n) + ' = ' + fmt(m * n)));
    container.appendChild(buildStepDOM(3, '<strong>Write result</strong>',
        fmt(base) + '^{' + fmt(m * n) + '} = ' + fmtSci(result)));
}

function renderProductPower(container, a, b, n) {
    if (!container) return;
    container.innerHTML = '';
    var result = Math.pow(a, n) * Math.pow(b, n);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Power of Product: (ab)<sup>n</sup> = a<sup>n</sup>b<sup>n</sup></span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, '(' + fmt(a) + ' \\cdot ' + fmt(b) + ')^{' + fmt(n) + '} = ' + fmt(a) + '^{' + fmt(n) + '} \\cdot ' + fmt(b) + '^{' + fmt(n) + '}', true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Distribute exponent</strong>',
        '(' + fmt(a) + ' \\cdot ' + fmt(b) + ')^{' + fmt(n) + '} = ' + fmt(a) + '^{' + fmt(n) + '} \\cdot ' + fmt(b) + '^{' + fmt(n) + '}'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate each power</strong>',
        fmt(a) + '^{' + fmt(n) + '} = ' + fmtSci(Math.pow(a, n)) + ', \\quad ' + fmt(b) + '^{' + fmt(n) + '} = ' + fmtSci(Math.pow(b, n))));
    container.appendChild(buildStepDOM(3, '<strong>Multiply</strong>',
        fmtSci(Math.pow(a, n)) + ' \\times ' + fmtSci(Math.pow(b, n)) + ' = ' + fmtSci(result)));
}

function renderQuotientPower(container, a, b, n) {
    if (!container) return;
    container.innerHTML = '';
    var result = Math.pow(a, n) / Math.pow(b, n);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Power of Quotient: (a/b)<sup>n</sup> = a<sup>n</sup>/b<sup>n</sup></span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, '\\left(\\frac{' + fmt(a) + '}{' + fmt(b) + '}\\right)^{' + fmt(n) + '} = \\frac{' + fmt(a) + '^{' + fmt(n) + '}}{' + fmt(b) + '^{' + fmt(n) + '}}', true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Distribute exponent</strong>',
        '\\left(\\frac{' + fmt(a) + '}{' + fmt(b) + '}\\right)^{' + fmt(n) + '} = \\frac{' + fmt(a) + '^{' + fmt(n) + '}}{' + fmt(b) + '^{' + fmt(n) + '}}'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate each power</strong>',
        fmt(a) + '^{' + fmt(n) + '} = ' + fmtSci(Math.pow(a, n)) + ', \\quad ' + fmt(b) + '^{' + fmt(n) + '} = ' + fmtSci(Math.pow(b, n))));
    container.appendChild(buildStepDOM(3, '<strong>Divide</strong>',
        '\\frac{' + fmtSci(Math.pow(a, n)) + '}{' + fmtSci(Math.pow(b, n)) + '} = ' + fmtSci(result)));
}

function renderNegativeExp(container, base, exp) {
    if (!container) return;
    container.innerHTML = '';
    var absExp = Math.abs(exp);
    var result = Math.pow(base, exp);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Negative Exponent: a<sup>&minus;n</sup> = 1/a<sup>n</sup></span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, fmt(base) + '^{' + fmt(exp) + '} = \\frac{1}{' + fmt(base) + '^{' + fmt(absExp) + '}} = ' + fmtSci(result), true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Convert to reciprocal</strong>',
        fmt(base) + '^{' + fmt(exp) + '} = \\frac{1}{' + fmt(base) + '^{' + fmt(absExp) + '}}'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate positive power</strong>',
        fmt(base) + '^{' + fmt(absExp) + '} = ' + fmtSci(Math.pow(base, absExp))));
    container.appendChild(buildStepDOM(3, '<strong>Take reciprocal</strong>',
        '\\frac{1}{' + fmtSci(Math.pow(base, absExp)) + '} = ' + fmtSci(result)));
}

function renderZeroExp(container, base) {
    if (!container) return;
    container.innerHTML = '';

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Zero Exponent: a<sup>0</sup> = 1</span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, fmt(base) + '^{0} = 1', true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Rule:</strong> Any non-zero number raised to 0 equals 1',
        fmt(base) + '^{0} = 1'));
    container.appendChild(buildStepDOM(2, '<strong>Why?</strong> Using the quotient rule',
        '\\frac{a^n}{a^n} = a^{n-n} = a^0 = 1'));
}

function renderFractionalExp(container, base, m, n) {
    if (!container) return;
    container.innerHTML = '';
    var result = Math.pow(base, m / n);

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">Fractional Exponent: a<sup>m/n</sup> = <sup>n</sup>&radic;(a<sup>m</sup>)</span>';
    container.appendChild(header);

    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, fmt(base) + '^{' + fmt(m) + '/' + fmt(n) + '} = \\sqrt[' + fmt(n) + ']{' + fmt(base) + '^{' + fmt(m) + '}} = ' + fmtSci(result), true);
    container.appendChild(resultDiv);

    container.appendChild(buildStepDOM(1, '<strong>Understand the fraction</strong>',
        '\\text{Numerator } ' + fmt(m) + ' = \\text{power}, \\quad \\text{Denominator } ' + fmt(n) + ' = \\text{root}'));
    container.appendChild(buildStepDOM(2, '<strong>Method 1: Power first</strong>',
        fmt(base) + '^{' + fmt(m) + '} = ' + fmtSci(Math.pow(base, m)) +
        ', \\quad \\sqrt[' + fmt(n) + ']{' + fmtSci(Math.pow(base, m)) + '} = ' + fmtSci(result)));
    container.appendChild(buildStepDOM(3, '<strong>Method 2: Root first</strong>',
        '\\sqrt[' + fmt(n) + ']{' + fmt(base) + '} = ' + fmtSci(Math.pow(base, 1/n)) +
        ', \\quad (' + fmtSci(Math.pow(base, 1/n)) + ')^{' + fmt(m) + '} = ' + fmtSci(result)));
}

// ==================== Simplify ====================

function renderSimplify(container, type, a, b) {
    if (!container) return;
    container.innerHTML = '';

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';

    if (type === 'combo1') {
        header.innerHTML = '<span class="ec-rule-badge">Simplify: (a&sup2;)&sup3; &times; a&sup4;</span>';
        container.appendChild(header);
        var r = document.createElement('div');
        r.style.cssText = 'text-align:center;margin-bottom:1rem;';
        renderKaTeX(r, '(' + fmt(a) + '^2)^3 \\times ' + fmt(a) + '^4 = ' + fmt(a) + '^{10} = ' + fmtSci(Math.pow(a, 10)), true);
        container.appendChild(r);
        container.appendChild(buildStepDOM(1, '<strong>Apply power rule to (a&sup2;)&sup3;</strong>',
            '(' + fmt(a) + '^2)^3 = ' + fmt(a) + '^{2 \\times 3} = ' + fmt(a) + '^6'));
        container.appendChild(buildStepDOM(2, '<strong>Apply product rule</strong>',
            fmt(a) + '^6 \\times ' + fmt(a) + '^4 = ' + fmt(a) + '^{6+4} = ' + fmt(a) + '^{10}'));
        container.appendChild(buildStepDOM(3, '<strong>Numerical result</strong>',
            fmt(a) + '^{10} = ' + fmtSci(Math.pow(a, 10))));

    } else if (type === 'combo2') {
        header.innerHTML = '<span class="ec-rule-badge">Simplify: a&sup8; &divide; (a&sup2;)&sup3;</span>';
        container.appendChild(header);
        var r2 = document.createElement('div');
        r2.style.cssText = 'text-align:center;margin-bottom:1rem;';
        renderKaTeX(r2, '\\frac{' + fmt(a) + '^8}{(' + fmt(a) + '^2)^3} = ' + fmt(a) + '^{2} = ' + fmtSci(Math.pow(a, 2)), true);
        container.appendChild(r2);
        container.appendChild(buildStepDOM(1, '<strong>Apply power rule to denominator</strong>',
            '(' + fmt(a) + '^2)^3 = ' + fmt(a) + '^{6}'));
        container.appendChild(buildStepDOM(2, '<strong>Apply quotient rule</strong>',
            fmt(a) + '^8 \\div ' + fmt(a) + '^6 = ' + fmt(a) + '^{8-6} = ' + fmt(a) + '^2'));
        container.appendChild(buildStepDOM(3, '<strong>Numerical result</strong>',
            fmt(a) + '^2 = ' + fmtSci(Math.pow(a, 2))));

    } else if (type === 'combo3') {
        header.innerHTML = '<span class="ec-rule-badge">Simplify: (a&sup3;b&sup2;)&sup4;</span>';
        container.appendChild(header);
        var r3 = document.createElement('div');
        r3.style.cssText = 'text-align:center;margin-bottom:1rem;';
        renderKaTeX(r3, '(' + fmt(a) + '^3 \\cdot ' + fmt(b) + '^2)^4 = ' + fmt(a) + '^{12} \\cdot ' + fmt(b) + '^{8}', true);
        container.appendChild(r3);
        container.appendChild(buildStepDOM(1, '<strong>Apply power of product</strong>',
            '(a^3 b^2)^4 = (a^3)^4 \\cdot (b^2)^4'));
        container.appendChild(buildStepDOM(2, '<strong>Apply power rule to each</strong>',
            '(a^3)^4 = a^{12}, \\quad (b^2)^4 = b^{8}'));
        container.appendChild(buildStepDOM(3, '<strong>Numerical result</strong>',
            fmt(a) + '^{12} \\cdot ' + fmt(b) + '^{8} = ' + fmtSci(Math.pow(a, 12)) + ' \\times ' + fmtSci(Math.pow(b, 8)) + ' = ' + fmtSci(Math.pow(a, 12) * Math.pow(b, 8))));

    } else if (type === 'combo4') {
        header.innerHTML = '<span class="ec-rule-badge">Simplify: a<sup>&minus;2</sup> &times; a&sup5;</span>';
        container.appendChild(header);
        var r4 = document.createElement('div');
        r4.style.cssText = 'text-align:center;margin-bottom:1rem;';
        renderKaTeX(r4, fmt(a) + '^{-2} \\times ' + fmt(a) + '^5 = ' + fmt(a) + '^{3} = ' + fmtSci(Math.pow(a, 3)), true);
        container.appendChild(r4);
        container.appendChild(buildStepDOM(1, '<strong>Apply product rule</strong>',
            'a^{-2} \\times a^5 = a^{-2+5} = a^3'));
        container.appendChild(buildStepDOM(2, '<strong>Alternative view</strong>',
            'a^{-2} = \\frac{1}{a^2}, \\quad \\frac{a^5}{a^2} = a^3'));
        container.appendChild(buildStepDOM(3, '<strong>Numerical result</strong>',
            fmt(a) + '^3 = ' + fmtSci(Math.pow(a, 3))));
    }
}

// ==================== All Laws ====================

function renderAllLaws(container, base) {
    if (!container) return;
    container.innerHTML = '';

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="ec-rule-badge">All 8 Laws of Exponents (a = ' + fmt(base) + ')</span>';
    container.appendChild(header);

    var laws = [
        { title: '1. Product Rule', formula: 'a^m \\times a^n = a^{m+n}',
          example: fmt(base) + '^3 \\times ' + fmt(base) + '^2 = ' + fmt(base) + '^5 = ' + fmtSci(Math.pow(base, 5)) },
        { title: '2. Quotient Rule', formula: '\\frac{a^m}{a^n} = a^{m-n}',
          example: fmt(base) + '^7 \\div ' + fmt(base) + '^4 = ' + fmt(base) + '^3 = ' + fmtSci(Math.pow(base, 3)) },
        { title: '3. Power Rule', formula: '(a^m)^n = a^{mn}',
          example: '(' + fmt(base) + '^2)^3 = ' + fmt(base) + '^6 = ' + fmtSci(Math.pow(base, 6)) },
        { title: '4. Power of Product', formula: '(ab)^n = a^n b^n',
          example: '(' + fmt(base) + ' \\cdot 3)^2 = ' + fmt(base) + '^2 \\cdot 9 = ' + fmtSci(Math.pow(base, 2) * 9) },
        { title: '5. Power of Quotient', formula: '\\left(\\frac{a}{b}\\right)^n = \\frac{a^n}{b^n}',
          example: '\\left(\\frac{' + fmt(base) + '}{2}\\right)^2 = \\frac{' + fmtSci(Math.pow(base, 2)) + '}{4} = ' + fmtSci(Math.pow(base, 2) / 4) },
        { title: '6. Negative Exponent', formula: 'a^{-n} = \\frac{1}{a^n}',
          example: fmt(base) + '^{-2} = \\frac{1}{' + fmtSci(Math.pow(base, 2)) + '} = ' + fmtSci(Math.pow(base, -2)) },
        { title: '7. Zero Exponent', formula: 'a^0 = 1',
          example: fmt(base) + '^0 = 1' },
        { title: '8. Fractional Exponent', formula: 'a^{m/n} = \\sqrt[n]{a^m}',
          example: fmt(base) + '^{3/2} = \\sqrt{' + fmt(base) + '^3} = ' + fmtSci(Math.pow(base, 1.5)) }
    ];

    for (var i = 0; i < laws.length; i++) {
        var card = document.createElement('div');
        card.className = 'ec-law-card';

        var title = document.createElement('h4');
        title.textContent = laws[i].title;
        card.appendChild(title);

        var formula = document.createElement('div');
        formula.className = 'ec-law-formula';
        renderKaTeX(formula, laws[i].formula, true);
        card.appendChild(formula);

        var example = document.createElement('div');
        example.className = 'ec-law-example';
        renderKaTeX(example, laws[i].example, false);
        card.appendChild(example);

        container.appendChild(card);
    }
}

// ==================== Error ====================

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div style="padding:1rem;background:#fef2f2;border-left:3px solid #ef4444;border-radius:0.5rem;color:#dc2626;font-size:0.8125rem;">' + message + '</div>';
}

// ==================== Exports ====================

window.ExponentCalcRender = {
    fmt: fmt,
    fmtSci: fmtSci,
    renderKaTeX: renderKaTeX,
    buildStepDOM: buildStepDOM,
    renderBasicPower: renderBasicPower,
    renderProductRule: renderProductRule,
    renderQuotientRule: renderQuotientRule,
    renderPowerRule: renderPowerRule,
    renderProductPower: renderProductPower,
    renderQuotientPower: renderQuotientPower,
    renderNegativeExp: renderNegativeExp,
    renderZeroExp: renderZeroExp,
    renderFractionalExp: renderFractionalExp,
    renderSimplify: renderSimplify,
    renderAllLaws: renderAllLaws,
    showError: showError
};

})();
