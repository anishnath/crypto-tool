/**
 * Quadratic Solver - Core Orchestration
 * State management, event binding, solve flow, preview updates
 */
(function() {
'use strict';

var R = window.QuadraticSolverRender;
var G = window.QuadraticSolverGraph;
var E = window.QuadraticSolverExport;

// ==================== State ====================

var state = {
    formType: 'standard',   // standard | vertex | factored | inequality
    method: 'all',           // all | formula | completing | factoring
    a: 1, b: 5, c: 6,       // standard-form coefficients (computed from any form)
    vertexA: 1, vertexH: 0, vertexK: 0,
    factorA: 1, factorR1: 0, factorR2: 0,
    operator: '>',
    lastResult: null,
    pendingGraph: false
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.formBtns = document.querySelectorAll('.qs-form-btn');
    els.formSections = {
        standard: document.getElementById('qs-form-standard'),
        vertex: document.getElementById('qs-form-vertex'),
        factored: document.getElementById('qs-form-factored'),
        inequality: document.getElementById('qs-form-inequality'),
        horizontal: document.getElementById('qs-form-horizontal')
    };
    els.formHint = document.getElementById('qs-form-hint');

    // Standard inputs
    els.coeffA = document.getElementById('qs-coeff-a');
    els.coeffB = document.getElementById('qs-coeff-b');
    els.coeffC = document.getElementById('qs-coeff-c');

    // Vertex inputs
    els.vertexA = document.getElementById('qs-vertex-a');
    els.vertexH = document.getElementById('qs-vertex-h');
    els.vertexK = document.getElementById('qs-vertex-k');

    // Factored inputs
    els.factorA = document.getElementById('qs-factor-a');
    els.factorR1 = document.getElementById('qs-factor-r1');
    els.factorR2 = document.getElementById('qs-factor-r2');

    // Inequality inputs
    els.ineqA = document.getElementById('qs-ineq-a');
    els.ineqB = document.getElementById('qs-ineq-b');
    els.ineqC = document.getElementById('qs-ineq-c');
    els.ineqOp = document.getElementById('qs-ineq-op');

    // Horizontal parabola inputs
    els.horizA = document.getElementById('qs-horiz-a');
    els.horizB = document.getElementById('qs-horiz-b');
    els.horizC = document.getElementById('qs-horiz-c');

    // Preview
    els.preview = document.getElementById('qs-preview');

    // Method
    els.methodSelect = document.getElementById('qs-method');

    // Buttons
    els.solveBtn = document.getElementById('qs-solve-btn');
    els.clearBtn = document.getElementById('qs-clear-btn');

    // Output
    els.resultContent = document.getElementById('qs-result-content');
    els.emptyState = document.getElementById('qs-empty-state');
    els.stepsArea = document.getElementById('qs-steps-area');
    els.resultActions = document.getElementById('qs-result-actions');
    els.graphHint = document.getElementById('qs-graph-hint');

    // Tabs
    els.tabBtns = document.querySelectorAll('.qs-output-tab');
    els.panels = document.querySelectorAll('.qs-panel');

    // Action buttons
    els.copyLatexBtn = document.getElementById('qs-copy-latex-btn');
    els.shareBtn = document.getElementById('qs-share-btn');
    els.downloadPdfBtn = document.getElementById('qs-download-pdf-btn');
    els.printWorksheetBtn = document.getElementById('qs-print-worksheet-btn');
}

// ==================== Form Type Switching ====================

function switchFormType(type) {
    state.formType = type;

    els.formBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-type') === type);
    });

    Object.keys(els.formSections).forEach(function(key) {
        if (els.formSections[key]) {
            els.formSections[key].style.display = key === type ? 'block' : 'none';
        }
    });

    // Update hint
    if (els.formHint) {
        var hints = {
            standard: 'ax\u00B2 + bx + c = 0',
            vertex: 'a(x \u2212 h)\u00B2 + k = 0',
            factored: 'a(x \u2212 r\u2081)(x \u2212 r\u2082) = 0',
            inequality: 'ax\u00B2 + bx + c \u2277 0',
            horizontal: 'x = ay\u00B2 + by + c'
        };
        els.formHint.textContent = hints[type] || '';
    }

    // Show/hide method selector for inequality or horizontal
    var methodGroup = document.getElementById('qs-method-group');
    if (methodGroup) {
        methodGroup.style.display = (type === 'inequality' || type === 'horizontal') ? 'none' : 'block';
    }

    updatePreview();
}

// ==================== Coefficient Reading ====================

function getStandardCoeffs() {
    var a, b, c;

    switch (state.formType) {
        case 'standard':
            a = parseFloat(els.coeffA.value) || 0;
            b = parseFloat(els.coeffB.value) || 0;
            c = parseFloat(els.coeffC.value) || 0;
            break;
        case 'vertex':
            var va = parseFloat(els.vertexA.value) || 0;
            var vh = parseFloat(els.vertexH.value) || 0;
            var vk = parseFloat(els.vertexK.value) || 0;
            state.vertexA = va; state.vertexH = vh; state.vertexK = vk;
            a = va;
            b = -2 * va * vh;
            c = va * vh * vh + vk;
            break;
        case 'factored':
            var fa = parseFloat(els.factorA.value) || 0;
            var fr1 = parseFloat(els.factorR1.value) || 0;
            var fr2 = parseFloat(els.factorR2.value) || 0;
            state.factorA = fa; state.factorR1 = fr1; state.factorR2 = fr2;
            a = fa;
            b = -fa * (fr1 + fr2);
            c = fa * fr1 * fr2;
            break;
        case 'inequality':
            a = parseFloat(els.ineqA.value) || 0;
            b = parseFloat(els.ineqB.value) || 0;
            c = parseFloat(els.ineqC.value) || 0;
            state.operator = els.ineqOp ? els.ineqOp.value : '>';
            break;
        case 'horizontal':
            a = parseFloat(els.horizA && els.horizA.value) || 0;
            b = parseFloat(els.horizB && els.horizB.value) || 0;
            c = parseFloat(els.horizC && els.horizC.value) || 0;
            break;
        default:
            a = 0; b = 0; c = 0;
    }

    state.a = a; state.b = b; state.c = c;
    return { a: a, b: b, c: c };
}

// ==================== Root Calculation ====================

function calculateRoots(a, b, c) {
    var disc = b * b - 4 * a * c;
    if (disc >= 0) {
        var sqrtDisc = Math.sqrt(disc);
        return { type: 'real', x1: (-b + sqrtDisc) / (2 * a), x2: (-b - sqrtDisc) / (2 * a) };
    } else {
        return { type: 'complex', real: -b / (2 * a), imag: Math.sqrt(-disc) / (2 * a) };
    }
}

// ==================== Inequality Solver ====================

function solveInequalityResult(a, b, c, roots, op) {
    var opSymbol = op === '>=' ? '\u2265' : (op === '<=' ? '\u2264' : op);
    var result = { intervalLatex: '', intervalHtml: '' };

    if (roots.type === 'complex') {
        var allOrNone = (a > 0 && (op === '>' || op === '>=')) || (a < 0 && (op === '<' || op === '<='));
        if (allOrNone) {
            result.intervalLatex = 'x \\in \\mathbb{R}';
            result.intervalHtml = 'x \u2208 \u211D (all real numbers)';
        } else {
            result.intervalLatex = '\\emptyset';
            result.intervalHtml = 'No solution (\u2205)';
        }
        return result;
    }

    var x1 = Math.min(roots.x1, roots.x2);
    var x2 = Math.max(roots.x1, roots.x2);
    var f = R.fmt;

    var needBetween = (a > 0 && (op === '<' || op === '<=')) || (a < 0 && (op === '>' || op === '>='));
    var inclusive = op === '>=' || op === '<=';

    if (needBetween) {
        var lb = inclusive ? '[' : '(';
        var rb = inclusive ? ']' : ')';
        result.intervalLatex = 'x \\in ' + lb + f(x1) + ',\\,' + f(x2) + rb;
        result.intervalHtml = 'x \u2208 ' + lb + f(x1) + ', ' + f(x2) + rb;
    } else {
        var lb1 = '(-\\infty,\\,';
        var rb1 = inclusive ? ']' : ')';
        var lb2 = inclusive ? '[' : '(';
        var rb2 = ',\\,+\\infty)';
        result.intervalLatex = 'x \\in ' + lb1 + f(x1) + rb1 + ' \\cup ' + lb2 + f(x2) + rb2;
        var hLb1 = inclusive ? ']' : ')';
        var hLb2 = inclusive ? '[' : '(';
        result.intervalHtml = 'x \u2208 (-\u221E, ' + f(x1) + hLb1 + ' \u222A ' + hLb2 + f(x2) + ', +\u221E)';
    }

    return result;
}

// ==================== Horizontal Parabola (x = ay^2 + by + c) ====================

function solveHorizontal(a, b, c) {
    // Vertex: (h, k) where h = c - b^2/(4a), k = -b/(2a)
    var k = -b / (2 * a);
    var h = c - (b * b) / (4 * a);
    var p = 1 / (4 * a);  // (y-k)^2 = 4p(x-h)
    var focusX = h + p;
    var focusY = k;
    var directrixX = h - p;
    var opensRight = a > 0;

    var result = {
        isHorizontal: true,
        a: a, b: b, c: c,
        vertex: { h: h, k: k },
        focus: { x: focusX, y: focusY },
        directrix: directrixX,
        p: p,
        opensRight: opensRight
    };
    state.lastResult = result;

    var html = R.renderHorizontalSolution(result);
    if (els.resultContent) els.resultContent.innerHTML = html;
    if (els.emptyState) els.emptyState.style.display = 'none';

    R.postRenderHorizontal(result);

    if (els.resultActions) els.resultActions.style.display = 'flex';

    var stepsFrag = R.renderHorizontalSteps(result);
    if (els.stepsArea) {
        els.stepsArea.innerHTML = '';
        if (stepsFrag) els.stepsArea.appendChild(stepsFrag);
    }

    state.pendingGraph = true;
    state.pendingGraphHorizontal = true;
    if (els.graphHint) els.graphHint.style.display = 'none';

    var graphPanel = document.getElementById('qs-panel-graph');
    if (graphPanel && graphPanel.classList.contains('active')) {
        renderPendingGraph();
    }
}

// ==================== Solve ====================

function solve() {
    var coeffs = getStandardCoeffs();
    var a = coeffs.a, b = coeffs.b, c = coeffs.c;

    if (!a || a === 0) {
        R.showError(els.resultContent, 'Coefficient \'a\' must be non-zero for a quadratic equation.');
        if (els.emptyState) els.emptyState.style.display = 'none';
        if (els.resultActions) els.resultActions.style.display = 'none';
        if (els.stepsArea) els.stepsArea.innerHTML = '';
        return;
    }

    // Horizontal parabola: x = ay^2 + by + c (different output: vertex, focus, directrix)
    if (state.formType === 'horizontal') {
        solveHorizontal(a, b, c);
        return;
    }

    var disc = b * b - 4 * a * c;
    var roots = calculateRoots(a, b, c);
    var method = els.methodSelect ? els.methodSelect.value : 'all';

    var result = {
        a: a, b: b, c: c,
        disc: disc,
        roots: roots,
        method: method,
        formType: state.formType,
        isInequality: state.formType === 'inequality',
        operator: state.operator
    };

    // Inequality interval
    if (result.isInequality) {
        var ineqResult = solveInequalityResult(a, b, c, roots, state.operator);
        result.intervalLatex = ineqResult.intervalLatex;
        result.intervalHtml = ineqResult.intervalHtml;
    }

    // Area under parabola between roots (when two distinct real roots)
    if (roots.type === 'real' && disc > 0) {
        var r1 = Math.min(roots.x1, roots.x2);
        var r2 = Math.max(roots.x1, roots.x2);
        var F = function(x) { return (a / 3) * x * x * x + (b / 2) * x * x + c * x; };
        result.areaBetweenRoots = Math.abs(F(r2) - F(r1));
    }

    state.lastResult = result;

    // Render result
    var html;
    if (result.isInequality) {
        html = R.renderInequality(result);
    } else {
        html = R.renderSolution(result);
    }

    if (els.resultContent) els.resultContent.innerHTML = html;
    if (els.emptyState) els.emptyState.style.display = 'none';

    // Post-render KaTeX
    R.postRenderRoots(result);

    // Show action buttons
    if (els.resultActions) els.resultActions.style.display = 'flex';

    // Render steps
    R.renderSteps(result, els.stepsArea);

    // Prepare graph
    state.pendingGraph = true;
    if (els.graphHint) els.graphHint.style.display = 'none';

    var graphPanel = document.getElementById('qs-panel-graph');
    if (graphPanel && graphPanel.classList.contains('active')) {
        renderPendingGraph();
    }
}

// ==================== Preview ====================

var previewTimer = null;
function updatePreview() {
    if (previewTimer) clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        if (!els.preview) return;

        var coeffs = getStandardCoeffs();
        var a = coeffs.a, b = coeffs.b, c = coeffs.c;
        var f = R.fmt;

        var latex = '';
        if (state.formType === 'horizontal') {
            var ha = parseFloat(els.horizA && els.horizA.value) || 0;
            var hb = parseFloat(els.horizB && els.horizB.value) || 0;
            var hc = parseFloat(els.horizC && els.horizC.value) || 0;
            latex = 'x = ';
            if (ha !== 0) latex += (ha === 1 ? '' : (ha === -1 ? '-' : f(ha))) + 'y^2';
            if (hb !== 0) latex += (hb > 0 ? ' + ' : ' - ') + (Math.abs(hb) === 1 ? '' : f(Math.abs(hb))) + 'y';
            if (hc !== 0) latex += (hc > 0 ? ' + ' : ' - ') + f(Math.abs(hc));
        } else if (state.formType === 'vertex') {
            var va = state.vertexA, vh = state.vertexH, vk = state.vertexK;
            var aStr = va === 1 ? '' : (va === -1 ? '-' : f(va));
            var hSign = vh >= 0 ? '-' : '+';
            var kSign = vk >= 0 ? '+' : '-';
            latex = aStr + '(x ' + hSign + ' ' + f(Math.abs(vh)) + ')^2 ' + kSign + ' ' + f(Math.abs(vk)) + ' = 0';
        } else if (state.formType === 'factored') {
            var fa = state.factorA, fr1 = state.factorR1, fr2 = state.factorR2;
            var faStr = fa === 1 ? '' : (fa === -1 ? '-' : f(fa));
            var r1Sign = fr1 >= 0 ? '-' : '+';
            var r2Sign = fr2 >= 0 ? '-' : '+';
            latex = faStr + '(x ' + r1Sign + ' ' + f(Math.abs(fr1)) + ')(x ' + r2Sign + ' ' + f(Math.abs(fr2)) + ') = 0';
        } else {
            // Standard or inequality
            latex = '';
            if (a === 1) latex += 'x^2';
            else if (a === -1) latex += '-x^2';
            else if (a !== 0) latex += f(a) + 'x^2';

            if (b !== 0) {
                latex += (b > 0 ? ' + ' : ' - ') + (Math.abs(b) === 1 ? '' : f(Math.abs(b))) + 'x';
            }
            if (c !== 0) {
                latex += (c > 0 ? ' + ' : ' - ') + f(Math.abs(c));
            }

            if (state.formType === 'inequality') {
                var opMap = { '>': '>', '<': '<', '>=': '\\geq', '<=': '\\leq' };
                latex += ' ' + (opMap[state.operator] || '>') + ' 0';
            } else {
                latex += ' = 0';
            }
        }

        try {
            katex.render(latex, els.preview, { displayMode: true, throwOnError: false });
        } catch (e) {
            els.preview.textContent = latex;
        }
    }, 100);
}

// ==================== Graph ====================

function renderPendingGraph() {
    if (!state.pendingGraph || !state.lastResult) return;
    G.loadPlotly(function() {
        var r = state.lastResult;
        if (r.isHorizontal) {
            G.renderHorizontalParabola('qs-graph-container', r.a, r.b, r.c, r.vertex, r.focus);
        } else {
            var ineqOp = r.isInequality ? r.operator : null;
            G.renderParabola('qs-graph-container', r.a, r.b, r.c, r.roots, ineqOp);
        }
    });
}

// ==================== Examples ====================

var examples = {
    'perfect-square': { type: 'standard', a: 1, b: -6, c: 9 },
    'two-roots': { type: 'standard', a: 1, b: 5, c: 6 },
    'complex': { type: 'standard', a: 1, b: 2, c: 5 },
    'difference-squares': { type: 'standard', a: 1, b: 0, c: -16 },
    'vertex-form': { type: 'vertex', a: 2, h: 3, k: -8 },
    'inequality': { type: 'inequality', a: 1, b: -5, c: 6, op: '<' },
    'horizontal': { type: 'horizontal', a: 1, b: -4, c: 2 },
    'random': null
};

function loadExample(name) {
    if (name === 'random') {
        var randomExamples = [
            { a: 1, b: 5, c: 6 }, { a: 1, b: -5, c: 6 }, { a: 1, b: 0, c: -16 },
            { a: 2, b: 4, c: -6 }, { a: 1, b: 2, c: 1 }, { a: -1, b: 4, c: -3 },
            { a: 3, b: -12, c: 9 }, { a: 1, b: 0, c: 1 }
        ];
        var ex = randomExamples[Math.floor(Math.random() * randomExamples.length)];
        switchFormType('standard');
        if (els.coeffA) els.coeffA.value = ex.a;
        if (els.coeffB) els.coeffB.value = ex.b;
        if (els.coeffC) els.coeffC.value = ex.c;
        updatePreview();
        setTimeout(solve, 50);
        return;
    }

    var ex = examples[name];
    if (!ex) return;

    switchFormType(ex.type);

    if (ex.type === 'standard') {
        if (els.coeffA) els.coeffA.value = ex.a;
        if (els.coeffB) els.coeffB.value = ex.b;
        if (els.coeffC) els.coeffC.value = ex.c;
    } else if (ex.type === 'vertex') {
        if (els.vertexA) els.vertexA.value = ex.a;
        if (els.vertexH) els.vertexH.value = ex.h;
        if (els.vertexK) els.vertexK.value = ex.k;
    } else if (ex.type === 'inequality') {
        if (els.ineqA) els.ineqA.value = ex.a;
        if (els.ineqB) els.ineqB.value = ex.b;
        if (els.ineqC) els.ineqC.value = ex.c;
        if (els.ineqOp) els.ineqOp.value = ex.op || '>';
    } else if (ex.type === 'horizontal') {
        if (els.horizA) els.horizA.value = ex.a;
        if (els.horizB) els.horizB.value = ex.b;
        if (els.horizC) els.horizC.value = ex.c;
    }

    updatePreview();
    setTimeout(solve, 50);
}

// ==================== URL Loading ====================

function loadFromURL() {
    var shared = E.parseShareUrl();
    if (!shared) return false;

    var type = shared.t || 'standard';
    switchFormType(type);

    if (type === 'vertex' && shared.va !== undefined) {
        if (els.vertexA) els.vertexA.value = shared.va;
        if (els.vertexH) els.vertexH.value = shared.vh || 0;
        if (els.vertexK) els.vertexK.value = shared.vk || 0;
    } else if (type === 'horizontal' && shared.ha !== undefined) {
        if (els.horizA) els.horizA.value = shared.ha;
        if (els.horizB) els.horizB.value = shared.hb || 0;
        if (els.horizC) els.horizC.value = shared.hc || 0;
    } else if (type === 'factored' && shared.fa !== undefined) {
        if (els.factorA) els.factorA.value = shared.fa;
        if (els.factorR1) els.factorR1.value = shared.fr1 || 0;
        if (els.factorR2) els.factorR2.value = shared.fr2 || 0;
    } else {
        // Standard or inequality
        if (els.coeffA) els.coeffA.value = shared.a || 1;
        if (els.coeffB) els.coeffB.value = shared.b || 0;
        if (els.coeffC) els.coeffC.value = shared.c || 0;

        if (type === 'inequality') {
            if (els.ineqA) els.ineqA.value = shared.a || 1;
            if (els.ineqB) els.ineqB.value = shared.b || 0;
            if (els.ineqC) els.ineqC.value = shared.c || 0;
            if (els.ineqOp && shared.op) els.ineqOp.value = shared.op;
        }
    }

    if (shared.m) {
        if (els.methodSelect) els.methodSelect.value = shared.m;
    }

    updatePreview();
    setTimeout(solve, 300);
    return true;
}

// ==================== Clear ====================

function clearAll() {
    if (els.coeffA) els.coeffA.value = 1;
    if (els.coeffB) els.coeffB.value = 0;
    if (els.coeffC) els.coeffC.value = 0;
    if (els.vertexA) els.vertexA.value = 1;
    if (els.vertexH) els.vertexH.value = 0;
    if (els.vertexK) els.vertexK.value = 0;
    if (els.factorA) els.factorA.value = 1;
    if (els.factorR1) els.factorR1.value = 0;
    if (els.factorR2) els.factorR2.value = 0;
    if (els.ineqA) els.ineqA.value = 1;
    if (els.ineqB) els.ineqB.value = 0;
    if (els.ineqC) els.ineqC.value = 0;
    if (els.horizA) els.horizA.value = 1;
    if (els.horizB) els.horizB.value = -4;
    if (els.horizC) els.horizC.value = 2;

    if (els.resultContent) els.resultContent.innerHTML = '';
    if (els.emptyState) els.emptyState.style.display = 'flex';
    if (els.resultActions) els.resultActions.style.display = 'none';
    if (els.stepsArea) els.stepsArea.innerHTML = '';
    if (els.graphHint) els.graphHint.style.display = 'block';

    state.lastResult = null;
    state.pendingGraph = false;
    updatePreview();
}

// ==================== PDF Download ====================

function downloadResultPdf() {
    if (!state.lastResult) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
        return;
    }

    var container = document.createElement('div');
    container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);

    var title = document.createElement('div');
    title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#7c3aed;';
    title.textContent = 'Quadratic Equation Solver — 8gwifi.org';
    container.appendChild(title);

    var divider = document.createElement('div');
    divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#7c3aed,#a78bfa,transparent);margin-bottom:24px;';
    container.appendChild(divider);

    if (els.resultContent) {
        var resultClone = els.resultContent.cloneNode(true);
        var emptyEl = resultClone.querySelector('.tool-empty-state');
        if (emptyEl) emptyEl.remove();
        resultClone.style.background = 'transparent';
        container.appendChild(resultClone);
    }

    if (els.stepsArea && els.stepsArea.children.length > 0) {
        var stepsLabel = document.createElement('div');
        stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin:20px 0 12px;padding-top:16px;border-top:1px solid #e2e8f0;';
        stepsLabel.textContent = 'Step-by-Step Solution';
        container.appendChild(stepsLabel);
        container.appendChild(els.stepsArea.cloneNode(true));
    }

    var footer = document.createElement('div');
    footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML = '<span>Generated by 8gwifi.org</span><span>' + new Date().toLocaleDateString() + '</span>';
    container.appendChild(footer);

    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

    var loadHtml2Canvas = (typeof html2canvas !== 'undefined')
        ? Promise.resolve()
        : (ToolUtils && ToolUtils._loadScript ? ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js') : Promise.reject('ToolUtils not found'));

    loadHtml2Canvas.then(function() {
        return ToolUtils && ToolUtils._loadScript ? ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js') : Promise.reject('ToolUtils not found');
    }).then(function() {
        return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false });
    }).then(function(canvas) {
        document.body.removeChild(container);
        var imgData = canvas.toDataURL('image/png');
        var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
        var pageWidth = pdf.internal.pageSize.getWidth();
        var pageHeight = pdf.internal.pageSize.getHeight();
        var margin = 10;
        var usableWidth = pageWidth - margin * 2;
        var imgWidth = usableWidth;
        var imgHeight = (canvas.height * usableWidth) / canvas.width;
        var usableHeight = pageHeight - margin * 2;
        if (imgHeight > usableHeight) {
            imgHeight = usableHeight;
            imgWidth = (canvas.width * usableHeight) / canvas.height;
        }
        var x = (pageWidth - imgWidth) / 2;
        pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);
        var r = state.lastResult;
        var baseName = r.isHorizontal ? 'horizontal-parabola' : (r.isInequality ? 'quadratic-inequality' : 'quadratic');
        var filename = baseName + '-solution.pdf';
        pdf.save(filename);
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
    }).catch(function(err) {
        console.error('PDF generation failed:', err);
        if (container.parentNode) document.body.removeChild(container);
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed', 3000, 'error');
    });
}

// ==================== Print Worksheet ====================

function getAnswer(p) {
    if (p.ineq) {
        var r1 = (-p.b - Math.sqrt(p.b * p.b - 4 * p.a * p.c)) / (2 * p.a);
        var r2 = (-p.b + Math.sqrt(p.b * p.b - 4 * p.a * p.c)) / (2 * p.a);
        var lo = Math.min(r1, r2), hi = Math.max(r1, r2);
        if (p.op === '<') return 'x \u2208 (' + lo.toFixed(2) + ', ' + hi.toFixed(2) + ')';
        if (p.op === '>') return 'x \u2208 (-\u221e, ' + lo.toFixed(2) + ') \u222a (' + hi.toFixed(2) + ', +\u221e)';
        if (p.op === '\u2264') return 'x \u2208 [' + lo.toFixed(2) + ', ' + hi.toFixed(2) + ']';
        return 'x \u2208 (-\u221e, ' + lo.toFixed(2) + '] \u222a [' + hi.toFixed(2) + ', +\u221e)';
    }
    if (p.horiz) {
        var k = -p.b / (2 * p.a), h = p.c - p.b * p.b / (4 * p.a);
        return 'Vertex (' + h.toFixed(2) + ', ' + k.toFixed(2) + '), p = ' + (1 / (4 * p.a)).toFixed(2);
    }
    var disc = p.b * p.b - 4 * p.a * p.c;
    if (disc >= 0) {
        var x1 = (-p.b + Math.sqrt(disc)) / (2 * p.a);
        var x2 = (-p.b - Math.sqrt(disc)) / (2 * p.a);
        var s1 = Math.abs(x1) < 1e-6 ? '0' : (Math.abs(x1 - Math.round(x1)) < 1e-6 ? String(Math.round(x1 * 100) / 100) : x1.toFixed(2));
        var s2 = Math.abs(x2) < 1e-6 ? '0' : (Math.abs(x2 - Math.round(x2)) < 1e-6 ? String(Math.round(x2 * 100) / 100) : x2.toFixed(2));
        if (Math.abs(x1 - x2) < 1e-9) return 'x = ' + s1 + ' (double)';
        return 'x = ' + s1 + ', ' + s2;
    }
    var re = -p.b / (2 * p.a), im = Math.sqrt(-disc) / (2 * p.a);
    return 'x = ' + re.toFixed(2) + ' \u00B1 ' + im.toFixed(2) + 'i';
}

function eqToString(a, b, c) {
    var parts = [];
    if (a !== 0) parts.push((a === 1 ? '' : (a === -1 ? '-' : a)) + 'x\u00B2');
    if (b !== 0) parts.push((b > 0 ? '+' : '') + (Math.abs(b) === 1 ? '' : b) + 'x');
    if (c !== 0) parts.push((c > 0 ? '+' : '') + c);
    return (parts.length ? parts.join(' ') : '0') + ' = 0';
}

function generateWorksheetProblems() {
    var rnd = function(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; };
    var problems = [];
    var used = {};

    function addEasy() {
        var key, r1, r2, a, b, c;
        if (rnd(0, 2) === 0) {
            r1 = rnd(-4, 4);
            a = 1; b = -2 * r1; c = r1 * r1;
            key = 'psq:' + r1;
        } else if (rnd(0, 2) === 1) {
            r1 = rnd(2, 8);
            a = 1; b = 0; c = -r1 * r1;
            key = 'dos:' + r1;
        } else {
            r1 = rnd(-5, 5); r2 = rnd(-5, 5);
            while (r1 === r2) r2 = rnd(-5, 5);
            a = 1; b = -(r1 + r2); c = r1 * r2;
            key = 'int:' + r1 + ',' + r2;
        }
        if (used[key]) return false;
        used[key] = true;
        problems.push({ type: 'easy', a: a, b: b, c: c, eq: eqToString(a, b, c) });
        return true;
    }

    function addMedium() {
        var key, r1, r2, a, b, c, k, h;
        if (rnd(0, 3) === 0) {
            k = rnd(-2, 2); h = rnd(-2, 2);
            a = 1; b = -2 * k; c = h + k * k;
            key = 'horiz:' + k + ',' + h;
            if (used[key]) return false;
            used[key] = true;
            var hEq = 'x = y\u00B2' + (b >= 0 ? '+' : '') + b + 'y' + (c >= 0 ? '+' : '') + c;
            problems.push({ type: 'medium', horiz: true, a: a, b: b, c: c, eq: hEq });
            return true;
        }
        r1 = rnd(-4, 4); r2 = rnd(-4, 4);
        while (r1 === r2) r2 = rnd(-4, 4);
        a = rnd(1, 3); b = -a * (r1 + r2); c = a * r1 * r2;
        key = 'med:' + a + ',' + r1 + ',' + r2;
        if (used[key]) return false;
        used[key] = true;
        problems.push({ type: 'medium', a: a, b: b, c: c, eq: eqToString(a, b, c) });
        return true;
    }

    function addHard() {
        var key, a, b, c, r1, r2;
        if (rnd(0, 2) === 0) {
            var p = rnd(-2, 2), q = rnd(1, 3);
            a = 1; b = -2 * p; c = p * p + q * q;
            key = 'cpx:' + p + ',' + q;
            if (used[key]) return false;
            used[key] = true;
            problems.push({ type: 'hard', a: a, b: b, c: c, eq: eqToString(a, b, c) });
            return true;
        }
        if (rnd(0, 2) === 1) {
            r1 = rnd(-3, 3); r2 = rnd(-3, 3);
            while (r1 >= r2) { r1 = rnd(-3, 3); r2 = rnd(-3, 3); }
            a = 1; b = -(r1 + r2); c = r1 * r2;
            var op = ['<', '>', '\u2264', '\u2265'][rnd(0, 3)];
            key = 'ineq:' + a + ',' + b + ',' + c + op;
            if (used[key]) return false;
            used[key] = true;
            problems.push({ type: 'hard', ineq: true, op: op, a: a, b: b, c: c,
                eq: eqToString(a, b, c).replace(' = 0', ' ' + op + ' 0') });
            return true;
        }
        a = 1; b = rnd(1, 5); c = rnd(-5, -1);
        var tries = 0;
        while ((b * b - 4 * a * c <= 0 || Math.sqrt(b * b - 4 * a * c) % 1 === 0) && tries++ < 50) {
            b = rnd(1, 5); c = rnd(-5, -1);
        }
        if (tries >= 50) return addHard();
        key = 'irr:' + a + ',' + b + ',' + c;
        if (used[key]) return false;
        used[key] = true;
        problems.push({ type: 'hard', a: a, b: b, c: c, eq: eqToString(a, b, c) });
        return true;
    }

    while (problems.length < 50) {
        var target = problems.length;
        if (target < 17) { addEasy(); }
        else if (target < 34) { addMedium(); }
        else { addHard(); }
        if (problems.length === target) addEasy();
    }

    return problems;
}

function printWorksheet() {
    var problems = generateWorksheetProblems();
    var html = '<div class="qs-print-wrapper">';
    html += '<div class="qs-print-title">Quadratic Equation Practice Worksheet (50 Problems)</div>';
    html += '<div class="qs-print-info">Name: _____________________  Date: _____________  Solve each equation. Show your work.</div>';
    html += '<div class="qs-print-problems">';
    var prevType = '';
    for (var i = 0; i < problems.length; i++) {
        var p = problems[i];
        if (p.type !== prevType) {
            html += '<div class="qs-print-section">' + p.type.charAt(0).toUpperCase() + p.type.slice(1) + '</div>';
            prevType = p.type;
        }
        html += '<div class="qs-print-item">';
        html += '<span class="qs-print-num">' + (i + 1) + '.</span>';
        html += '<span class="qs-print-eq">' + p.eq + '</span>';
        html += '<span class="qs-print-blank"></span>';
        html += '</div>';
    }
    html += '</div>';

    html += '<div class="qs-print-answer-key">';
    html += '<div class="qs-print-answer-title">ANSWER KEY (Teacher Use)</div>';
    for (var j = 0; j < problems.length; j++) {
        html += '<div class="qs-print-answer-row"><span>' + (j + 1) + '.</span> ' + getAnswer(problems[j]) + '</div>';
    }
    html += '</div>';

    html += '<div class="qs-print-footer">Generated by 8gwifi.org Quadratic Formula Calculator</div>';
    html += '</div>';

    var printArea = document.createElement('div');
    printArea.id = 'qsPrintArea';
    printArea.className = 'qs-print-root';
    printArea.innerHTML = html;
    document.body.appendChild(printArea);
    window.print();
    setTimeout(function() { if (printArea.parentNode) printArea.parentNode.removeChild(printArea); }, 1000);
}

// ==================== Event Binding ====================

function init() {
    initDOM();

    // Form type toggle
    els.formBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchFormType(this.getAttribute('data-type'));
        });
    });

    // Solve
    if (els.solveBtn) els.solveBtn.addEventListener('click', solve);

    // Clear
    if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

    // Output tabs
    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            els.tabBtns.forEach(function(b) { b.classList.remove('active'); });
            els.panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            var target = document.getElementById('qs-panel-' + panel);
            if (target) target.classList.add('active');

            if (panel === 'graph' && state.pendingGraph) {
                renderPendingGraph();
            }
        });
    });

    // Method change
    if (els.methodSelect) els.methodSelect.addEventListener('change', function() {
        state.method = this.value;
    });

    // Input change → preview update
    var allInputs = document.querySelectorAll('.qs-coeff-input, #qs-ineq-op, #qs-horiz-a, #qs-horiz-b, #qs-horiz-c');
    allInputs.forEach(function(input) {
        input.addEventListener('input', updatePreview);
        input.addEventListener('change', updatePreview);
    });

    // Action buttons
    if (els.copyLatexBtn) {
        els.copyLatexBtn.addEventListener('click', function() {
            if (state.lastResult) {
                var r = state.lastResult;
                if (r.isHorizontal) {
                    E.copyHorizontalLatex(r);
                } else {
                    E.copyLatex(r.a, r.b, r.c, r.roots, r.method);
                }
            }
        });
    }

    if (els.shareBtn) {
        els.shareBtn.addEventListener('click', function() {
            getStandardCoeffs();  // refresh state from form before building share URL
            E.copyShareUrl(state);
        });
    }

    if (els.downloadPdfBtn) {
        els.downloadPdfBtn.addEventListener('click', downloadResultPdf);
    }

    if (els.printWorksheetBtn) {
        els.printWorksheetBtn.addEventListener('click', printWorksheet);
    }

    // Example chips
    document.querySelectorAll('[data-example]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    });

    // FAQ toggle
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // Load from URL or auto-solve
    if (!loadFromURL()) {
        updatePreview();
        setTimeout(solve, 300);
    }
}

// ==================== Init ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
