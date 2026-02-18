/**
 * Trigonometric Function Calculator - Core Orchestration
 * Modes: evaluate | quadrant | coterminal
 */
(function() {
'use strict';

var TC = window.TrigCommon;
var G = window.TrigGraph;
var E = window.TrigExport;

// ==================== State ====================

var state = {
    mode: 'evaluate',
    expression: 'sin(45)',
    unit: 'deg',
    lastResult: null,
    compilerLoaded: false,
    pendingGraph: null
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.modeBtns = document.querySelectorAll('.trig-mode-btn');
    els.exprInput = document.getElementById('trig-expr');
    els.unitBtns = document.querySelectorAll('.trig-unit-btn');
    els.unitGroup = document.getElementById('trig-unit-group');
    els.preview = document.getElementById('trig-preview');
    els.calcBtn = document.getElementById('trig-calc-btn');
    els.clearBtn = document.getElementById('trig-clear-btn');
    els.resultContent = document.getElementById('trig-result-content');
    els.emptyState = document.getElementById('trig-empty-state');
    els.resultActions = document.getElementById('trig-result-actions');
    els.tabBtns = document.querySelectorAll('.trig-output-tab');
    els.panels = document.querySelectorAll('.trig-panel');
    els.copyLatexBtn = document.getElementById('trig-copy-latex-btn');
    els.shareBtn = document.getElementById('trig-share-btn');
    els.compilerIframe = document.getElementById('trig-compiler-iframe');
    els.graphHint = document.getElementById('trig-graph-hint');
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;
    els.modeBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-mode') === mode);
    });
    updatePreview();
}

// ==================== Unit Toggle ====================

function switchUnit(unit) {
    state.unit = unit;
    els.unitBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-unit') === unit);
    });
    updatePreview();
}

// ==================== Preview ====================

function updatePreview() {
    if (!els.preview || !els.exprInput) return;
    var expr = els.exprInput.value.trim();
    if (!expr) {
        els.preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter an expression above\u2026</span>';
        return;
    }
    var texExpr = TC.exprToLatex(expr);
    var unitLabel = state.unit === 'deg' ? '^{\\circ}' : '\\text{ rad}';
    var latex = '';
    if (state.mode === 'evaluate') {
        latex = texExpr + unitLabel;
    } else if (state.mode === 'quadrant') {
        latex = '\\text{Quadrant of } ' + texExpr + unitLabel;
    } else {
        latex = '\\text{Coterminal of } ' + texExpr + unitLabel;
    }
    TC.renderKaTeX(els.preview, latex, false);
}

// ==================== Parse Expression ====================

function parseAngle(expr, unit) {
    // Handle common formats: sin(45), 210, pi/3, 750, etc.
    expr = expr.trim().replace(/°/g, '').replace(/\s+/g, '');

    // If it's a simple number
    var num = parseFloat(expr);
    if (!isNaN(num) && /^-?[\d.]+$/.test(expr)) {
        return unit === 'deg' ? num : TC.radToDeg(num);
    }

    // pi expressions
    if (/pi/i.test(expr)) {
        var piExpr = expr.replace(/pi/gi, String(Math.PI)).replace(/\^/g, '**');
        try {
            /* eslint-disable no-new-func */
            var val = new Function('return ' + piExpr)();
            if (isFinite(val)) return TC.radToDeg(val);
        } catch (e) { /* ignore */ }
    }

    return num;
}

function parseTrigFunction(expr) {
    // Parse expressions like sin(45), cos(pi/3), tan(60)
    var match = expr.match(/^(sin|cos|tan|csc|sec|cot)\s*\(\s*(.+)\s*\)$/i);
    if (match) {
        return { func: match[1].toLowerCase(), angle: match[2] };
    }
    return null;
}

// ==================== Evaluate Mode ====================

function renderEvaluate(container, expr, unit) {
    container.innerHTML = '';
    var parsed = parseTrigFunction(expr);
    if (!parsed) {
        TC.showError(container, 'Enter a trig function like sin(45), cos(pi/3), tan(60).');
        return;
    }

    var angleDeg = parseAngle(parsed.angle, unit);
    if (isNaN(angleDeg)) {
        TC.showError(container, 'Could not parse angle: ' + parsed.angle);
        return;
    }

    var normDeg = TC.normalizeAngleDeg(angleDeg);
    var angleRad = TC.degToRad(angleDeg);
    var fn = parsed.func;
    var stepNum = 1;

    // Badge
    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = 'Evaluate ' + fn;
    container.appendChild(badge);

    // Step 1: Identify
    var angleLatex = unit === 'deg' ? angleDeg + '^\\circ' : parsed.angle.replace(/pi/gi, '\\pi');
    container.appendChild(TC.buildStepDOM(stepNum++, 'Identify the function and angle', fn + '(' + angleLatex + ')'));

    // Step 2: Convert if needed
    if (unit === 'deg') {
        container.appendChild(TC.buildStepDOM(stepNum++, 'Convert to radians', angleDeg + '^\\circ = ' + TC.fmt(angleRad) + '\\text{ rad}'));
    }

    // Step 3: Check special angles
    var special = TC.SPECIAL_ANGLES[normDeg];
    var exactLatex = '';
    var numericVal = 0;

    if (special) {
        exactLatex = special[fn] || '';
        container.appendChild(TC.buildStepDOM(stepNum++, normDeg + '\u00B0 is a special angle', fn + '(' + normDeg + '^\\circ) = ' + exactLatex));

        // Get numeric value
        if (fn === 'sin') numericVal = Math.sin(angleRad);
        else if (fn === 'cos') numericVal = Math.cos(angleRad);
        else if (fn === 'tan') numericVal = Math.tan(angleRad);
        else if (fn === 'csc') numericVal = 1 / Math.sin(angleRad);
        else if (fn === 'sec') numericVal = 1 / Math.cos(angleRad);
        else if (fn === 'cot') numericVal = 1 / Math.tan(angleRad);
    } else {
        // Non-special angle: compute numerically
        if (fn === 'sin') numericVal = Math.sin(angleRad);
        else if (fn === 'cos') numericVal = Math.cos(angleRad);
        else if (fn === 'tan') numericVal = Math.tan(angleRad);
        else if (fn === 'csc') numericVal = 1 / Math.sin(angleRad);
        else if (fn === 'sec') numericVal = 1 / Math.cos(angleRad);
        else if (fn === 'cot') numericVal = 1 / Math.tan(angleRad);

        container.appendChild(TC.buildStepDOM(stepNum++, 'Compute numerically', fn + '(' + TC.fmt(angleRad) + ') = ' + TC.fmt(numericVal)));
    }

    // Step: Final answer
    var finalLatex = fn + '(' + angleLatex + ')';
    if (exactLatex && exactLatex.indexOf('undefined') === -1) {
        finalLatex += ' = ' + exactLatex + ' \\approx ' + TC.fmt(numericVal);
    } else if (exactLatex && exactLatex.indexOf('undefined') !== -1) {
        finalLatex += ' = ' + exactLatex;
    } else {
        finalLatex += ' \\approx ' + TC.fmt(numericVal);
    }
    container.appendChild(TC.buildStepDOM(stepNum, '<strong>Result</strong>', '\\boxed{' + finalLatex + '}'));

    // Show all 6 functions for this angle
    if (special) {
        var allFuncs = document.createElement('div');
        allFuncs.style.marginTop = '1rem';
        var allLabel = document.createElement('div');
        allLabel.className = 'trig-input-label';
        allLabel.textContent = 'ALL TRIG VALUES AT ' + normDeg + '\u00B0';
        allFuncs.appendChild(allLabel);

        var grid = document.createElement('div');
        grid.className = 'trig-angle-values';
        var funcNames = ['sin', 'cos', 'tan', 'csc', 'sec', 'cot'];
        for (var i = 0; i < funcNames.length; i++) {
            var item = document.createElement('div');
            item.className = 'trig-angle-value-item';
            var label = document.createElement('div');
            label.className = 'trig-angle-value-label';
            label.textContent = funcNames[i];
            item.appendChild(label);
            var math = document.createElement('div');
            math.className = 'trig-angle-value-math';
            TC.renderKaTeX(math, special[funcNames[i]], false);
            item.appendChild(math);
            grid.appendChild(item);
        }
        allFuncs.appendChild(grid);
        container.appendChild(allFuncs);
    }

    state.lastResult = { func: fn, angleDeg: angleDeg, angleRad: angleRad, numeric: numericVal };

    // Graph
    state.pendingGraph = function() {
        G.renderFunctionPlot('trig-graph-container', {
            functions: [{ expr: fn + '(x)', label: fn + '(x)' }],
            solutions: [{ x: angleRad, y: numericVal, label: fn + '(' + angleLatex + ') = ' + TC.fmt(numericVal) }]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Quadrant Mode ====================

function renderQuadrant(container, expr, unit) {
    container.innerHTML = '';
    var angleDeg = parseAngle(expr, unit);
    if (isNaN(angleDeg)) {
        TC.showError(container, 'Enter an angle value (e.g., 210, pi/4).');
        return;
    }

    var normDeg = TC.normalizeAngleDeg(angleDeg);
    var quadrant = TC.getQuadrant(angleDeg);
    var refAngle = TC.getReferenceAngle(angleDeg);
    var signs = TC.getQuadrantSigns(quadrant);
    var stepNum = 1;

    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = 'Quadrant Analysis';
    container.appendChild(badge);

    var angleLatex = unit === 'deg' ? angleDeg + '^\\circ' : expr.replace(/pi/gi, '\\pi');

    // Step 1: Normalize
    container.appendChild(TC.buildStepDOM(stepNum++, 'Normalize the angle to [0\u00B0, 360\u00B0)', angleDeg + '^\\circ \\to ' + normDeg + '^\\circ'));

    // Step 2: Determine quadrant
    container.appendChild(TC.buildStepDOM(stepNum++, 'Determine the quadrant', normDeg + '^\\circ \\text{ is in } \\textbf{Quadrant ' + quadrant + '}'));

    // Step 3: Reference angle
    container.appendChild(TC.buildStepDOM(stepNum++, 'Find the reference angle', '\\text{Reference angle} = ' + refAngle + '^\\circ'));

    // Step 4: Sign table
    var tableWrap = document.createElement('div');
    tableWrap.style.marginTop = '0.5rem';
    var tableLabel = document.createElement('div');
    tableLabel.className = 'trig-step-desc';
    tableLabel.innerHTML = '<strong>Step ' + stepNum + ':</strong> Signs of trig functions in Q' + quadrant;
    tableWrap.appendChild(tableLabel);

    var table = document.createElement('table');
    table.className = 'trig-sign-table';
    var thead = document.createElement('thead');
    var headRow = document.createElement('tr');
    var funcs = ['sin', 'cos', 'tan', 'csc', 'sec', 'cot'];
    for (var i = 0; i < funcs.length; i++) {
        var th = document.createElement('th');
        th.textContent = funcs[i];
        headRow.appendChild(th);
    }
    thead.appendChild(headRow);
    table.appendChild(thead);

    var tbody = document.createElement('tbody');
    var row = document.createElement('tr');
    for (var j = 0; j < funcs.length; j++) {
        var td = document.createElement('td');
        var signVal = signs[funcs[j]];
        td.textContent = signVal > 0 ? '+' : '\u2212';
        td.className = signVal > 0 ? 'trig-sign-positive' : 'trig-sign-negative';
        row.appendChild(td);
    }
    tbody.appendChild(row);
    table.appendChild(tbody);
    tableWrap.appendChild(table);
    container.appendChild(tableWrap);

    // Show values if special angle
    var special = TC.SPECIAL_ANGLES[normDeg];
    if (special) {
        var valGrid = document.createElement('div');
        valGrid.className = 'trig-angle-values';
        valGrid.style.marginTop = '0.75rem';
        for (var k = 0; k < funcs.length; k++) {
            var item = document.createElement('div');
            item.className = 'trig-angle-value-item';
            var lbl = document.createElement('div');
            lbl.className = 'trig-angle-value-label';
            lbl.textContent = funcs[k] + '(' + normDeg + '\u00B0)';
            item.appendChild(lbl);
            var math = document.createElement('div');
            math.className = 'trig-angle-value-math';
            TC.renderKaTeX(math, special[funcs[k]], false);
            item.appendChild(math);
            valGrid.appendChild(item);
        }
        container.appendChild(valGrid);
    }

    state.lastResult = { angleDeg: angleDeg, quadrant: quadrant, refAngle: refAngle };

    // Graph
    state.pendingGraph = function() {
        G.renderUnitCircle('trig-graph-container', {
            angles: [normDeg],
            highlightQuadrant: quadrant,
            showRefAngle: true
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Coterminal Mode ====================

function renderCoterminal(container, expr, unit) {
    container.innerHTML = '';
    var angleDeg = parseAngle(expr, unit);
    if (isNaN(angleDeg)) {
        TC.showError(container, 'Enter an angle value (e.g., 750, -330).');
        return;
    }

    var normDeg = TC.normalizeAngleDeg(angleDeg);
    var stepNum = 1;

    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = 'Coterminal Angles';
    container.appendChild(badge);

    // Step 1: Normalize
    container.appendChild(TC.buildStepDOM(stepNum++, 'Normalize to [0\u00B0, 360\u00B0)', angleDeg + '^\\circ \\equiv ' + normDeg + '^\\circ'));

    // Step 2: Formula
    container.appendChild(TC.buildStepDOM(stepNum++, 'Coterminal angle formula', '\\theta_{co} = ' + normDeg + '^\\circ + 360^\\circ \\cdot n, \\quad n \\in \\mathbb{Z}'));

    // Positive coterminals
    var pos = [], neg = [];
    for (var n = 1; n <= 3; n++) { pos.push(normDeg + 360 * n); }
    for (var m = 1; m <= 3; m++) { neg.push(normDeg - 360 * m); }

    // Step 3: List
    container.appendChild(TC.buildStepDOM(stepNum++, 'Positive coterminal angles (n = 1, 2, 3)', pos.join('^\\circ,\\; ') + '^\\circ'));
    container.appendChild(TC.buildStepDOM(stepNum, 'Negative coterminal angles (n = -1, -2, -3)', neg.join('^\\circ,\\; ') + '^\\circ'));

    // Visual list
    var listWrap = document.createElement('div');
    listWrap.className = 'trig-coterminal-list';
    listWrap.style.marginTop = '0.75rem';
    for (var p = 0; p < pos.length; p++) {
        var pi = document.createElement('div');
        pi.className = 'trig-coterminal-item trig-coterminal-positive';
        pi.textContent = '+' + pos[p] + '\u00B0';
        listWrap.appendChild(pi);
    }
    for (var ni = 0; ni < neg.length; ni++) {
        var ne = document.createElement('div');
        ne.className = 'trig-coterminal-item trig-coterminal-negative';
        ne.textContent = neg[ni] + '\u00B0';
        listWrap.appendChild(ne);
    }
    container.appendChild(listWrap);

    state.lastResult = { angleDeg: angleDeg, normDeg: normDeg, positives: pos, negatives: neg };

    // Graph
    state.pendingGraph = function() {
        G.renderUnitCircle('trig-graph-container', {
            angles: [normDeg],
            showCoterminals: true,
            coterminals: [normDeg]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Calculate ====================

function calculate() {
    var expr = els.exprInput ? els.exprInput.value.trim() : '';
    if (!expr) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter an expression.', 2000, 'warning');
        return;
    }
    state.expression = expr;

    var container = els.resultContent;
    if (!container) return;

    if (els.emptyState) els.emptyState.style.display = 'none';
    if (els.resultActions) els.resultActions.style.display = 'flex';

    switch (state.mode) {
        case 'evaluate': renderEvaluate(container, expr, state.unit); break;
        case 'quadrant': renderQuadrant(container, expr, state.unit); break;
        case 'coterminal': renderCoterminal(container, expr, state.unit); break;
    }
}

// ==================== Tab Switching ====================

function switchTab(panel) {
    els.tabBtns.forEach(function(b) { b.classList.toggle('active', b.getAttribute('data-panel') === panel); });
    els.panels.forEach(function(p) { p.classList.toggle('active', p.id === 'trig-panel-' + panel); });

    if (panel === 'graph' && state.pendingGraph) {
        state.pendingGraph();
        state.pendingGraph = null;
    }
    if (panel === 'python' && !state.compilerLoaded && els.compilerIframe) {
        var contextMeta = document.querySelector('meta[name="context-path"]');
        var contextPath = contextMeta ? contextMeta.content : '';
        els.compilerIframe.src = E.getCompilerUrl(state.mode, state, contextPath);
        state.compilerLoaded = true;
    }
}

// ==================== Examples ====================

var EXAMPLES = {
    'eval-sin45':   { mode: 'evaluate', expr: 'sin(45)', unit: 'deg' },
    'eval-cospi3':  { mode: 'evaluate', expr: 'cos(pi/3)', unit: 'rad' },
    'eval-tan60':   { mode: 'evaluate', expr: 'tan(60)', unit: 'deg' },
    'quad-210':     { mode: 'quadrant', expr: '210', unit: 'deg' },
    'coterm-750':   { mode: 'coterminal', expr: '750', unit: 'deg' }
};

function loadExample(key) {
    var ex = EXAMPLES[key];
    if (!ex) return;
    switchMode(ex.mode);
    switchUnit(ex.unit);
    if (els.exprInput) els.exprInput.value = ex.expr;
    updatePreview();
    calculate();
}

// ==================== Share URL ====================

function loadFromUrl() {
    var data = E.parseShareUrl();
    if (!data) return;
    if (data.m) switchMode(data.m);
    if (data.u) switchUnit(data.u);
    if (data.e && els.exprInput) els.exprInput.value = data.e;
    updatePreview();
    setTimeout(calculate, 100);
}

// ==================== Init ====================

function init() {
    initDOM();

    // Mode buttons
    els.modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchMode(btn.getAttribute('data-mode')); });
    });

    // Unit buttons
    els.unitBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchUnit(btn.getAttribute('data-unit')); });
    });

    // Input
    if (els.exprInput) {
        els.exprInput.addEventListener('input', updatePreview);
        els.exprInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') calculate(); });
    }

    // Buttons
    if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);
    if (els.clearBtn) els.clearBtn.addEventListener('click', function() {
        if (els.exprInput) els.exprInput.value = '';
        if (els.resultContent) els.resultContent.innerHTML = '';
        if (els.emptyState) { els.emptyState.style.display = 'flex'; els.resultContent.appendChild(els.emptyState); }
        if (els.resultActions) els.resultActions.style.display = 'none';
        updatePreview();
    });

    // Tabs
    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchTab(btn.getAttribute('data-panel')); });
    });

    // Export buttons
    if (els.copyLatexBtn) els.copyLatexBtn.addEventListener('click', function() { E.copyLatex(state.mode, state); });
    if (els.shareBtn) els.shareBtn.addEventListener('click', function() { E.copyShareUrl(state); });

    // Examples
    document.querySelectorAll('.trig-example-chip').forEach(function(chip) {
        chip.addEventListener('click', function() { loadExample(chip.getAttribute('data-example')); });
    });

    // Load from URL
    loadFromUrl();
    updatePreview();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
