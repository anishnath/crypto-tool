/**
 * Percentage Calculator - Render Module
 * KaTeX step-by-step rendering for percentage calculations
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

function fmtMoney(n) {
    if (!isFinite(n)) return String(n);
    return n.toFixed(2);
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
    step.className = 'pc-step';

    var numEl = document.createElement('div');
    numEl.className = 'pc-step-number';
    numEl.textContent = number;

    var content = document.createElement('div');
    content.className = 'pc-step-content';

    var desc = document.createElement('div');
    desc.className = 'pc-step-desc';
    desc.innerHTML = description;

    content.appendChild(desc);

    if (latex) {
        var math = document.createElement('div');
        math.className = 'pc-step-math';
        renderKaTeX(math, latex, true);
        content.appendChild(math);
    }

    step.appendChild(numEl);
    step.appendChild(content);
    return step;
}

function makeHeader(container, html) {
    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:1rem;';
    header.innerHTML = '<span class="pc-rule-badge">' + html + '</span>';
    container.appendChild(header);
}

function makeResult(container, latex) {
    var resultDiv = document.createElement('div');
    resultDiv.style.cssText = 'text-align:center;margin-bottom:1rem;';
    renderKaTeX(resultDiv, latex, true);
    container.appendChild(resultDiv);
}

// ==================== Percent Of ====================

function renderPercentOf(container, x, y) {
    if (!container) return;
    container.innerHTML = '';
    var result = (x / 100) * y;

    makeHeader(container, 'X% of Y');
    makeResult(container, fmt(x) + '\\% \\text{ of } ' + fmt(y) + ' = ' + fmt(result));

    container.appendChild(buildStepDOM(1, '<strong>Write the formula</strong>',
        '\\text{Result} = \\frac{X}{100} \\times Y'));
    container.appendChild(buildStepDOM(2, '<strong>Substitute values</strong>',
        '\\frac{' + fmt(x) + '}{100} \\times ' + fmt(y)));
    container.appendChild(buildStepDOM(3, '<strong>Convert percent to decimal</strong>',
        fmt(x) + '\\% = ' + fmt(x / 100)));
    container.appendChild(buildStepDOM(4, '<strong>Multiply</strong>',
        fmt(x / 100) + ' \\times ' + fmt(y) + ' = ' + fmt(result)));
}

// ==================== What Percent ====================

function renderWhatPercent(container, x, y) {
    if (!container) return;
    container.innerHTML = '';
    if (y === 0) { showError(container, 'Base (Y) cannot be zero.'); return; }
    var result = (x / y) * 100;

    makeHeader(container, 'X is what % of Y');
    makeResult(container, fmt(x) + ' \\text{ is } ' + fmt(result) + '\\% \\text{ of } ' + fmt(y));

    container.appendChild(buildStepDOM(1, '<strong>Write the formula</strong>',
        '\\text{Percent} = \\frac{X}{Y} \\times 100'));
    container.appendChild(buildStepDOM(2, '<strong>Substitute values</strong>',
        '\\frac{' + fmt(x) + '}{' + fmt(y) + '} \\times 100'));
    container.appendChild(buildStepDOM(3, '<strong>Divide</strong>',
        '\\frac{' + fmt(x) + '}{' + fmt(y) + '} = ' + fmt(x / y)));
    container.appendChild(buildStepDOM(4, '<strong>Multiply by 100</strong>',
        fmt(x / y) + ' \\times 100 = ' + fmt(result) + '\\%'));
}

// ==================== Increase By ====================

function renderIncreaseBy(container, pct, base) {
    if (!container) return;
    container.innerHTML = '';
    var increase = base * (pct / 100);
    var result = base + increase;

    makeHeader(container, 'Increase by X%');
    makeResult(container, fmt(base) + ' + ' + fmt(pct) + '\\% = ' + fmt(result));

    container.appendChild(buildStepDOM(1, '<strong>Write the formula</strong>',
        '\\text{Result} = Y \\times \\left(1 + \\frac{X}{100}\\right)'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate the multiplier</strong>',
        '1 + \\frac{' + fmt(pct) + '}{100} = 1 + ' + fmt(pct / 100) + ' = ' + fmt(1 + pct / 100)));
    container.appendChild(buildStepDOM(3, '<strong>Calculate the increase amount</strong>',
        fmt(base) + ' \\times ' + fmt(pct / 100) + ' = ' + fmt(increase)));
    container.appendChild(buildStepDOM(4, '<strong>Add to base</strong>',
        fmt(base) + ' + ' + fmt(increase) + ' = ' + fmt(result)));
}

// ==================== Decrease By ====================

function renderDecreaseBy(container, pct, base) {
    if (!container) return;
    container.innerHTML = '';
    var decrease = base * (pct / 100);
    var result = base - decrease;

    makeHeader(container, 'Decrease by X%');
    makeResult(container, fmt(base) + ' - ' + fmt(pct) + '\\% = ' + fmt(result));

    container.appendChild(buildStepDOM(1, '<strong>Write the formula</strong>',
        '\\text{Result} = Y \\times \\left(1 - \\frac{X}{100}\\right)'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate the multiplier</strong>',
        '1 - \\frac{' + fmt(pct) + '}{100} = 1 - ' + fmt(pct / 100) + ' = ' + fmt(1 - pct / 100)));
    container.appendChild(buildStepDOM(3, '<strong>Calculate the decrease amount</strong>',
        fmt(base) + ' \\times ' + fmt(pct / 100) + ' = ' + fmt(decrease)));
    container.appendChild(buildStepDOM(4, '<strong>Subtract from base</strong>',
        fmt(base) + ' - ' + fmt(decrease) + ' = ' + fmt(result)));
}

// ==================== Percent Change ====================

function renderPercentChange(container, a, b) {
    if (!container) return;
    container.innerHTML = '';
    if (a === 0) { showError(container, 'Starting value (A) cannot be zero.'); return; }
    var change = ((b - a) / a) * 100;
    var sign = change >= 0 ? '+' : '';
    var direction = change >= 0 ? 'increase' : 'decrease';

    makeHeader(container, '% Change: A &rarr; B');
    makeResult(container, '\\text{Change} = ' + sign + fmt(change) + '\\% \\;(' + direction + ')');

    container.appendChild(buildStepDOM(1, '<strong>Write the formula</strong>',
        '\\text{% Change} = \\frac{B - A}{A} \\times 100'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate the difference</strong>',
        'B - A = ' + fmt(b) + ' - ' + fmt(a) + ' = ' + fmt(b - a)));
    container.appendChild(buildStepDOM(3, '<strong>Divide by original</strong>',
        '\\frac{' + fmt(b - a) + '}{' + fmt(a) + '} = ' + fmt((b - a) / a)));
    container.appendChild(buildStepDOM(4, '<strong>Multiply by 100</strong>',
        fmt((b - a) / a) + ' \\times 100 = ' + sign + fmt(change) + '\\%'));
}

// ==================== Reverse Percentage ====================

function renderReverse(container, discPct, finalPrice) {
    if (!container) return;
    container.innerHTML = '';
    var divisor = 1 - discPct / 100;
    if (divisor === 0) { showError(container, 'Discount cannot be 100%.'); return; }
    var original = finalPrice / divisor;

    makeHeader(container, 'Original Before Discount');
    makeResult(container, '\\text{Original} = ' + fmt(original));

    container.appendChild(buildStepDOM(1, '<strong>Write the formula</strong>',
        '\\text{Original} = \\frac{\\text{Final Price}}{1 - \\frac{\\text{Discount\\%}}{100}}'));
    container.appendChild(buildStepDOM(2, '<strong>Calculate the divisor</strong>',
        '1 - \\frac{' + fmt(discPct) + '}{100} = 1 - ' + fmt(discPct / 100) + ' = ' + fmt(divisor)));
    container.appendChild(buildStepDOM(3, '<strong>Divide</strong>',
        '\\frac{' + fmt(finalPrice) + '}{' + fmt(divisor) + '} = ' + fmt(original)));
    container.appendChild(buildStepDOM(4, '<strong>Verify</strong>',
        fmt(original) + ' - ' + fmt(discPct) + '\\% = ' + fmt(original) + ' - ' + fmt(original * discPct / 100) + ' = ' + fmt(finalPrice)));
}

// ==================== Discount Simulator ====================

function renderDiscountSim(container, basePrice, discPct, taxPct, qty) {
    if (!container) return;
    container.innerHTML = '';

    var discAmt = basePrice * (discPct / 100);
    var afterDisc = basePrice - discAmt;
    var taxAmt = afterDisc * (taxPct / 100);
    var finalEach = afterDisc + taxAmt;
    var grand = finalEach * qty;

    makeHeader(container, 'Discount + Tax Simulator');
    makeResult(container, '\\text{Grand Total} = ' + fmtMoney(grand));

    container.appendChild(buildStepDOM(1, '<strong>Calculate discount</strong>',
        fmt(basePrice) + ' \\times \\frac{' + fmt(discPct) + '}{100} = ' + fmtMoney(discAmt)));
    container.appendChild(buildStepDOM(2, '<strong>Price after discount</strong>',
        fmt(basePrice) + ' - ' + fmtMoney(discAmt) + ' = ' + fmtMoney(afterDisc)));
    container.appendChild(buildStepDOM(3, '<strong>Calculate tax</strong>',
        fmtMoney(afterDisc) + ' \\times \\frac{' + fmt(taxPct) + '}{100} = ' + fmtMoney(taxAmt)));
    container.appendChild(buildStepDOM(4, '<strong>Final per unit</strong>',
        fmtMoney(afterDisc) + ' + ' + fmtMoney(taxAmt) + ' = ' + fmtMoney(finalEach)));

    if (qty > 1) {
        container.appendChild(buildStepDOM(5, '<strong>Grand total (Qty &times; ' + fmt(qty) + ')</strong>',
            fmtMoney(finalEach) + ' \\times ' + fmt(qty) + ' = ' + fmtMoney(grand)));
    }

    // Line-item breakdown
    var breakdownDiv = document.createElement('div');
    breakdownDiv.style.cssText = 'margin-top:1rem;';

    var items = [
        { label: 'Base Price', value: fmtMoney(basePrice) },
        { label: 'Discount (' + fmt(discPct) + '%)', value: '-' + fmtMoney(discAmt) },
        { label: 'After Discount', value: fmtMoney(afterDisc) },
        { label: 'Tax (' + fmt(taxPct) + '%)', value: '+' + fmtMoney(taxAmt) },
        { label: 'Final (each)', value: fmtMoney(finalEach) }
    ];
    if (qty > 1) {
        items.push({ label: 'Quantity', value: 'x' + fmt(qty) });
    }
    items.push({ label: 'Grand Total', value: fmtMoney(grand), total: true });

    for (var i = 0; i < items.length; i++) {
        var row = document.createElement('div');
        row.className = 'pc-sim-item' + (items[i].total ? ' pc-sim-total' : '');
        row.innerHTML = '<span class="pc-sim-item-label">' + items[i].label + '</span><span class="pc-sim-item-value">' + items[i].value + '</span>';
        breakdownDiv.appendChild(row);
    }
    container.appendChild(breakdownDiv);
}

// ==================== Chained Steps ====================

function renderChain(container, start, stepsStr) {
    if (!container) return;
    container.innerHTML = '';

    var steps = (stepsStr || '').split(',').map(function(s) { return s.trim(); }).filter(Boolean);
    if (!steps.length) { showError(container, 'Enter at least one step (e.g., +10%, -5%).'); return; }

    var current = start;
    var trail = [fmt(start)];

    makeHeader(container, 'Chained Percentage Steps');

    container.appendChild(buildStepDOM(1, '<strong>Starting value</strong>',
        '\\text{Start} = ' + fmt(start)));

    for (var i = 0; i < steps.length; i++) {
        var step = steps[i];
        var prev = current;

        if (/^[+-]\d+(\.\d+)?%$/.test(step)) {
            var p = parseFloat(step);
            current = current * (1 + p / 100);
            var sign = p >= 0 ? '+' : '';
            container.appendChild(buildStepDOM(i + 2,
                '<strong>Step ' + (i + 1) + ': ' + step + '</strong>',
                fmt(prev) + ' \\times (1 ' + sign + ' \\frac{' + fmt(Math.abs(p)) + '}{100}) = ' +
                fmt(prev) + ' \\times ' + fmt(1 + p / 100) + ' = ' + fmt(current)));
        } else if (/^[+-]\d+(\.\d+)?$/.test(step)) {
            var n = parseFloat(step);
            current = current + n;
            container.appendChild(buildStepDOM(i + 2,
                '<strong>Step ' + (i + 1) + ': ' + step + ' (absolute)</strong>',
                fmt(prev) + ' + (' + fmt(n) + ') = ' + fmt(current)));
        } else {
            container.appendChild(buildStepDOM(i + 2,
                '<strong>Step ' + (i + 1) + ': ' + step + '</strong> (skipped - invalid format)', null));
            continue;
        }
        trail.push(fmt(current));
    }

    // Final result
    var totalChange = start !== 0 ? ((current - start) / start) * 100 : 0;
    var totalSign = totalChange >= 0 ? '+' : '';
    container.appendChild(buildStepDOM('=',
        '<strong>Final Result</strong>',
        fmt(start) + ' \\xrightarrow{\\text{' + steps.length + ' steps}} ' + fmt(current) +
        ' \\quad (' + totalSign + fmt(totalChange) + '\\% \\text{ overall})'));
}

// ==================== Error ====================

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div style="padding:1rem;background:#fef2f2;border-left:3px solid #ef4444;border-radius:0.5rem;color:#dc2626;font-size:0.8125rem;">' + message + '</div>';
}

// ==================== Exports ====================

window.PctCalcRender = {
    fmt: fmt,
    fmtMoney: fmtMoney,
    renderKaTeX: renderKaTeX,
    buildStepDOM: buildStepDOM,
    renderPercentOf: renderPercentOf,
    renderWhatPercent: renderWhatPercent,
    renderIncreaseBy: renderIncreaseBy,
    renderDecreaseBy: renderDecreaseBy,
    renderPercentChange: renderPercentChange,
    renderReverse: renderReverse,
    renderDiscountSim: renderDiscountSim,
    renderChain: renderChain,
    showError: showError
};

})();
