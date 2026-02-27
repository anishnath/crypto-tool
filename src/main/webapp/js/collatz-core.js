/**
 * Collatz Conjecture - Core Orchestration
 * State management, events, live animation with real-time graph + stats
 */
(function() {
'use strict';

var R = window.CollatzRender;
var G = window.CollatzGraph;
var E = window.CollatzExport;

// ==================== State ====================

var state = {
    startNumber: 27,
    sequence: [],
    animationInterval: null,
    currentIndex: 0,
    peakValue: 0,
    peakSoFar: 0,
    stoppingTime: 0
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function collatzStep(n) {
    if (n % 2 === 0) return n / 2;
    return 3 * n + 1;
}

function generateSequence(start) {
    var sequence = [start];
    var current = start;
    var steps = 0;
    var peak = start;
    var MAX_STEPS = 10000;

    while (current !== 1 && steps < MAX_STEPS) {
        current = collatzStep(current);
        sequence.push(current);
        if (current > peak) peak = current;
        steps++;
    }

    return { sequence: sequence, steps: steps, peak: peak };
}

// ==================== Animation ====================

function displayNextNumber(speed) {
    if (state.currentIndex >= state.sequence.length) {
        finishSequence();
        return;
    }

    var container = $('cc-sequence-area');
    if (!container) return;

    // Create step-list container on first call
    var stepBody = container.querySelector('#cc-step-body');
    if (!stepBody) {
        container.innerHTML = '';
        container.appendChild(R.createSequenceContainer());
        stepBody = container.querySelector('#cc-step-body');
    }

    var num = state.sequence[state.currentIndex];
    var prevNum = state.currentIndex > 0 ? state.sequence[state.currentIndex - 1] : 0;
    var isPeak = (num === state.peakValue && num > state.sequence[0]);
    var isOne = (num === 1);

    // Track running peak
    if (num > state.peakSoFar) state.peakSoFar = num;

    stepBody.appendChild(R.renderStepRow(num, state.currentIndex, prevNum, isPeak, isOne, state.peakValue));

    // Auto-scroll step body
    stepBody.scrollTop = stepBody.scrollHeight;

    // Live graph: add point
    G.addPoint(state.currentIndex, num, state.sequence.length);

    // Live stats
    var statsEl = $('cc-stats-area');
    if (statsEl) {
        statsEl.innerHTML = R.renderStats(
            state.sequence[0],
            state.currentIndex,
            state.peakSoFar,
            state.stoppingTime,
            false
        );
    }

    // Update status
    var statusEl = $('cc-status-area');
    if (statusEl) {
        R.showStatus(statusEl, 'Step ' + state.currentIndex + ' of ' + state.stoppingTime + ' \u2014 Current: ' + num.toLocaleString(), true);
    }

    state.currentIndex++;
    state.animationInterval = setTimeout(function() { displayNextNumber(speed); }, speed);
}

function finishSequence() {
    stopAnimation();

    // Final stats
    var statsEl = $('cc-stats-area');
    if (statsEl) {
        statsEl.innerHTML = R.renderStats(
            state.sequence[0],
            state.stoppingTime,
            state.peakValue,
            state.sequence.length,
            true
        );
    }

    // Update status
    var statusEl = $('cc-status-area');
    if (statusEl) {
        R.showStatus(statusEl, 'Complete \u2014 Reached 1 in ' + state.stoppingTime + ' steps', false);
        var dot = statusEl.querySelector('.cc-status-dot');
        if (dot) dot.className = 'cc-status-dot cc-done';
    }

    // Finalise graph with peak + end markers
    G.finaliseChart(state.sequence);
}

// ==================== Actions ====================

function startSequence() {
    stopAnimation();

    var input = $('cc-start-number');
    if (!input) return;

    var startNum = parseInt(input.value, 10);
    if (isNaN(startNum) || startNum < 1 || startNum > 100000) {
        R.showError($('cc-sequence-area'), 'Invalid starting number');
        return;
    }

    // Reset display
    resetDisplay();

    var result = generateSequence(startNum);
    state.startNumber = startNum;
    state.sequence = result.sequence;
    state.stoppingTime = result.steps;
    state.peakValue = result.peak;
    state.peakSoFar = 0;
    state.currentIndex = 0;

    // Initialise live graph (empty, ready for points)
    G.initLiveChart('cc-graph-area', startNum, result.steps, result.peak);

    var speedInput = $('cc-speed-slider');
    var speed = speedInput ? parseInt(speedInput.value, 10) : 300;

    displayNextNumber(speed);
}

function stopAnimation() {
    if (state.animationInterval) {
        clearTimeout(state.animationInterval);
        state.animationInterval = null;
    }

    // Update status if mid-animation
    if (state.currentIndex > 0 && state.currentIndex < state.sequence.length) {
        var statusEl = $('cc-status-area');
        if (statusEl) {
            R.showStatus(statusEl, 'Paused at step ' + state.currentIndex + ' of ' + state.stoppingTime, false);
        }
    }
}

function resetDisplay() {
    var seqArea = $('cc-sequence-area');
    if (seqArea) R.showEmpty(seqArea);

    var statsArea = $('cc-stats-area');
    if (statsArea) statsArea.innerHTML = '';

    var statusArea = $('cc-status-area');
    if (statusArea) statusArea.innerHTML = '';

    G.destroyChart('cc-graph-area');
    var graphArea = $('cc-graph-area');
    if (graphArea) graphArea.innerHTML = '';
}

function resetVisualization() {
    stopAnimation();
    state.sequence = [];
    state.currentIndex = 0;
    state.stoppingTime = 0;
    state.peakValue = 0;
    state.peakSoFar = 0;
    resetDisplay();
}

function tryNumber(num) {
    var input = $('cc-start-number');
    if (input) input.value = num;
    startSequence();
}

function shareUrl() {
    if (state.sequence.length > 0) {
        E.copyShareUrl(state.startNumber);
    }
}

// ==================== Speed Slider ====================

function updateSpeedDisplay() {
    var slider = $('cc-speed-slider');
    var display = $('cc-speed-display');
    if (slider && display) {
        display.textContent = slider.value + 'ms';
    }
}

// ==================== FAQ ====================

function toggleFaq(btn) {
    if (!btn) return;
    var item = btn.parentElement;
    if (!item) return;
    var isOpen = item.classList.contains('active');

    // Close all
    var items = document.querySelectorAll('.faq-item');
    for (var i = 0; i < items.length; i++) {
        items[i].classList.remove('active');
    }

    if (!isOpen) {
        item.classList.add('active');
    }
}

// ==================== Init ====================

function init() {
    // Preload Plotly so graph is ready instantly when Start is clicked
    G.loadPlotly();

    // Event bindings
    var startBtn = $('cc-start-btn');
    if (startBtn) startBtn.addEventListener('click', startSequence);

    var stopBtn = $('cc-stop-btn');
    if (stopBtn) stopBtn.addEventListener('click', stopAnimation);

    var resetBtn = $('cc-reset-btn');
    if (resetBtn) resetBtn.addEventListener('click', resetVisualization);

    var shareBtn = $('cc-share-btn');
    if (shareBtn) shareBtn.addEventListener('click', shareUrl);

    // Enter key on input
    var input = $('cc-start-number');
    if (input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') startSequence();
        });
    }

    // Speed slider
    var speedSlider = $('cc-speed-slider');
    if (speedSlider) {
        speedSlider.addEventListener('input', updateSpeedDisplay);
    }

    // Record number buttons
    var recordBtns = document.querySelectorAll('.cc-record-btn');
    for (var i = 0; i < recordBtns.length; i++) {
        (function(btn) {
            btn.addEventListener('click', function() {
                var num = parseInt(btn.getAttribute('data-number'), 10);
                if (!isNaN(num)) tryNumber(num);
            });
        })(recordBtns[i]);
    }

    // Show empty state
    R.showEmpty($('cc-sequence-area'));

    // Check for shared URL
    var shared = E.parseShareUrl();
    if (shared && shared.n) {
        var num = parseInt(shared.n, 10);
        if (!isNaN(num) && num >= 1 && num <= 100000) {
            if (input) input.value = num;
            startSequence();
        }
    }
}

// Expose toggleFaq globally for onclick attributes
window.toggleFaq = toggleFaq;

document.addEventListener('DOMContentLoaded', init);

window.CollatzCore = {
    startSequence: startSequence,
    stopAnimation: stopAnimation,
    resetVisualization: resetVisualization,
    tryNumber: tryNumber,
    generateSequence: generateSequence
};

})();
