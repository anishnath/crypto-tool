/**
 * Collatz Conjecture - Render Module
 * DOM element creation for sequence numbers, stats, and educational content
 */
(function() {
'use strict';

function renderSequenceNumber(num, index, isPeak, isOne) {
    var el = document.createElement('div');
    el.className = 'cc-sequence-number';
    if (isPeak) el.className += ' cc-peak';
    if (isOne) el.className += ' cc-one';
    if (!isPeak && !isOne) {
        el.className += num % 2 === 0 ? ' cc-even' : ' cc-odd';
    }
    el.textContent = num.toLocaleString();
    el.title = 'Step ' + index + ': ' + num.toLocaleString() + (num % 2 === 0 ? ' (even, divide by 2)' : ' (odd, 3n+1)');
    return el;
}

function renderArrow() {
    var el = document.createElement('div');
    el.className = 'cc-sequence-arrow';
    el.innerHTML = '&#8594;';
    return el;
}

function renderStats(startValue, steps, peak, seqLength) {
    var html = '<div class="cc-stats-grid">';
    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">Starting Number</div>';
    html += '<div class="cc-stat-value">' + startValue.toLocaleString() + '</div>';
    html += '</div>';
    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">Steps to Reach 1</div>';
    html += '<div class="cc-stat-value">' + steps.toLocaleString() + '</div>';
    html += '</div>';
    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">Peak Value</div>';
    html += '<div class="cc-stat-value">' + peak.toLocaleString() + '</div>';
    html += '</div>';
    html += '<div class="cc-stat-card">';
    html += '<div class="cc-stat-label">Sequence Length</div>';
    html += '<div class="cc-stat-value">' + seqLength.toLocaleString() + '</div>';
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
    renderSequenceNumber: renderSequenceNumber,
    renderArrow: renderArrow,
    renderStats: renderStats,
    showError: showError,
    showEmpty: showEmpty,
    showStatus: showStatus
};

})();
