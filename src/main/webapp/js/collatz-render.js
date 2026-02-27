/**
 * Collatz Conjecture - Render Module
 * Compact step-list display with operation badges and magnitude bars
 */
(function() {
'use strict';

/**
 * Create a single step row for the sequence list.
 * Shows: step# | operation badge | value | magnitude bar
 */
function renderStepRow(num, index, prevNum, isPeak, isOne, peakValue) {
    var row = document.createElement('div');
    row.className = 'cc-step-row';
    if (isPeak) row.className += ' cc-step-peak';
    if (isOne) row.className += ' cc-step-done';

    // Step number
    var stepNum = document.createElement('span');
    stepNum.className = 'cc-step-num';
    stepNum.textContent = index;

    // Operation badge
    var op = document.createElement('span');
    op.className = 'cc-step-op';
    if (index === 0) {
        op.className += ' cc-op-start';
        op.textContent = 'START';
    } else if (prevNum % 2 === 0) {
        op.className += ' cc-op-even';
        op.innerHTML = '&#xF7;2';
    } else {
        op.className += ' cc-op-odd';
        op.innerHTML = '3n+1';
    }

    // Value
    var val = document.createElement('span');
    val.className = 'cc-step-val';
    if (isPeak) val.className += ' cc-val-peak';
    if (isOne) val.className += ' cc-val-done';
    val.textContent = num.toLocaleString();

    // Magnitude bar (proportional to peak)
    var barWrap = document.createElement('span');
    barWrap.className = 'cc-step-bar-wrap';
    var bar = document.createElement('span');
    bar.className = 'cc-step-bar';
    if (isPeak) bar.className += ' cc-bar-peak';
    if (isOne) bar.className += ' cc-bar-done';
    // Use log scale for bar width to handle huge peaks
    var pct = peakValue > 1
        ? (Math.log(num + 1) / Math.log(peakValue + 1)) * 100
        : 100;
    bar.style.width = Math.max(2, Math.min(100, pct)) + '%';
    barWrap.appendChild(bar);

    row.appendChild(stepNum);
    row.appendChild(op);
    row.appendChild(val);
    row.appendChild(barWrap);

    return row;
}

/**
 * Create the scrollable sequence container (header + list body).
 */
function createSequenceContainer() {
    var wrap = document.createElement('div');
    wrap.className = 'cc-step-list';

    // Header row
    var header = document.createElement('div');
    header.className = 'cc-step-header';
    header.innerHTML =
        '<span class="cc-step-num">Step</span>' +
        '<span class="cc-step-op">Rule</span>' +
        '<span class="cc-step-val">Value</span>' +
        '<span class="cc-step-bar-wrap">Magnitude</span>';
    wrap.appendChild(header);

    // Scrollable body
    var body = document.createElement('div');
    body.className = 'cc-step-body';
    body.id = 'cc-step-body';
    wrap.appendChild(body);

    return wrap;
}

/**
 * Render stats HTML with live/final labels.
 */
function renderStats(startValue, currentStep, currentPeak, totalSteps, isComplete) {
    var html = '<div class="cc-stats-grid">';

    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">Starting Number</div>';
    html += '<div class="cc-stat-value">' + startValue.toLocaleString() + '</div>';
    html += '</div>';

    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">' + (isComplete ? 'Total Steps' : 'Current Step') + '</div>';
    html += '<div class="cc-stat-value">' + currentStep.toLocaleString() + '</div>';
    html += '</div>';

    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">' + (isComplete ? 'Peak Value' : 'Peak So Far') + '</div>';
    html += '<div class="cc-stat-value">' + currentPeak.toLocaleString() + '</div>';
    html += '</div>';

    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">' + (isComplete ? 'Sequence Length' : 'Total Steps') + '</div>';
    html += '<div class="cc-stat-value">' + totalSteps.toLocaleString() + '</div>';
    html += '</div>';

    html += '</div>';
    return html;
}

function showError(container, msg) {
    if (!container) return;
    container.innerHTML =
        '<div class="tool-empty-state">' +
        '<svg style="width:3rem;height:3rem;color:var(--cc-tool);margin-bottom:0.75rem;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>' +
        '<h3>' + msg + '</h3>' +
        '<p>Please enter a valid positive integer between 1 and 100,000.</p>' +
        '</div>';
}

function showEmpty(container) {
    if (!container) return;
    container.innerHTML =
        '<div class="tool-empty-state">' +
        '<svg style="width:3rem;height:3rem;color:var(--cc-tool);margin-bottom:0.75rem;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/></svg>' +
        '<h3>Explore the 3n+1 Conjecture</h3>' +
        '<p>Enter a starting number and click Start to watch the Collatz sequence unfold.</p>' +
        '</div>';
}

function showStatus(container, text, running) {
    if (!container) return;
    var dotClass = 'cc-status-dot';
    if (running) dotClass += ' cc-running';
    container.innerHTML =
        '<div class="cc-status">' +
        '<span class="' + dotClass + '"></span>' +
        '<span>' + text + '</span>' +
        '</div>';
}

window.CollatzRender = {
    renderStepRow: renderStepRow,
    createSequenceContainer: createSequenceContainer,
    renderStats: renderStats,
    showError: showError,
    showEmpty: showEmpty,
    showStatus: showStatus
};

})();
