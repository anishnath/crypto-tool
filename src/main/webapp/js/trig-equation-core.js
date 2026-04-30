/**
 * Trigonometric Equation Solver - Core Orchestration
 * Modes: solve_equation | solve_inequality | simplify
 */
(function() {
'use strict';

var TC = window.TrigCommon;
var G = window.TrigGraph;
var E = window.TrigExport;

// ==================== State ====================

var state = {
    mode: 'solve_equation',
    expression: 'sin(x) = 1/2',
    unit: 'rad',
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

    // Hide unit toggle for simplify mode
    if (els.unitGroup) {
        els.unitGroup.style.display = mode === 'simplify' ? 'none' : 'block';
    }

    updatePreview();
}

// ==================== Unit Toggle ====================

function switchUnit(unit) {
    state.unit = unit;
    els.unitBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-unit') === unit);
    });
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
    var latex = '';
    if (state.mode === 'solve_equation') latex = '\\text{Solve: } ' + texExpr;
    else if (state.mode === 'solve_inequality') latex = '\\text{Solve: } ' + texExpr;
    else latex = '\\text{Simplify: } ' + texExpr;
    TC.renderKaTeX(els.preview, latex, false);
}

// ==================== Solve Equation ====================

function renderSolveEquation(container, expr, unit) {
    container.innerHTML = '';

    // ── Layer 1: client-side regex shortcut (instant, free) ──
    var simpleResult = trySolveSimple(expr);
    if (simpleResult) {
        renderClientSolution(container, simpleResult, expr, unit);
        setupEquationGraph(expr);
        return;
    }

    // ── Layer 2: SymPy via OneCompiler (deterministic, ~200-600ms) ──
    // Send the TEXT input, not the math-field LaTeX.  MathLive's ascii-
    // math seeder occasionally mangles "sin" → "s\in" (set-membership)
    // when seeding from chip-written text — corrupt LaTeX would make
    // SymPy parse e.g. "(1-cos(2x))/(s) ∈ (2x)" instead of the intended
    // expression.  The text input is authoritative in all paths (chip,
    // Visual mode via sanitised mirror, Text mode native).
    TC.showSpinner(container, 'Solving equation...');
    setupEquationGraph(expr);

    var fallbackToAI = function () {
        TC.callAI('trigonometry', expr, 'solve_equation', 'x', '', function (err, steps, method) {
            if (err) { TC.showError(container, 'Error: ' + err); return; }
            TC.showAISteps(container, steps, method || 'Equation Solver');
        });
    };
    if (!window.TrigBackend) { fallbackToAI(); return; }
    window.TrigBackend.compute({
        text: expr, mode: 'solve_equation', unit: unit, variable: 'x'
    }, function (res) {
        if (res && res.ok && res.answer_latex) {
            renderSympySolveResult(container, res, expr);
        } else {
            fallbackToAI();
        }
    });
}

// Render a CAS result.  If the backend returned named derivation
// steps, walk them out as numbered steps before the boxed answer;
// otherwise show just the boxed answer.  answer_str (the raw CAS
// representation) is used to detect EmptySet / Reals for nicer copy.
function renderSympySolveResult(container, res, expr) {
    container.innerHTML = '';

    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = 'Step-by-step solution';
    container.appendChild(badge);

    var stepNum = 1;
    var steps = (res.steps && res.steps.length) ? res.steps : [];

    // Step 0 (always): show the original input so students see where
    // the derivation starts.
    if (steps.length > 0) {
        container.appendChild(TC.buildStepDOM(stepNum++,
            'Original expression', TC.safeTeX(expr)));
        for (var i = 0; i < steps.length; i++) {
            var s = steps[i];
            container.appendChild(TC.buildStepDOM(stepNum++,
                s.label || s.rule || 'Apply rule', s.after_latex));
        }
    }

    var title;
    if (res.answer_str === 'EmptySet') {
        title = 'No real solution';
    } else if (res.answer_str === 'Reals' || res.answer_str === 'S.Reals') {
        title = 'Identity — true for all real x';
    } else if (res.kind === 'inequality') {
        title = 'Solution set';
    } else if (res.kind === 'simplify') {
        title = '<strong>Simplified form</strong>';
    } else if (res.kind === 'evaluate') {
        title = '<strong>Exact value</strong>';
    } else {
        title = '<strong>General solution</strong>';
    }
    container.appendChild(TC.buildStepDOM(stepNum, title,
        '\\boxed{' + res.answer_latex + '}'));
}

// (Helper readTrigLatex removed — controllers now send the text input
//  value directly to TrigBackend.compute.  Math-field LaTeX is unsafe
//  because MathLive's ascii-math seeder can mangle "sin" → "s\in" when
//  parsing chip-written text, producing corrupt LaTeX that misleads
//  parse_latex.  The text input is authoritative across all paths.)

function parseKValue(kStr) {
    kStr = kStr.trim();
    if (kStr === '1/2') return 0.5;
    if (kStr === '-1/2') return -0.5;
    if (/^-?sqrt\(2\)\/2$/i.test(kStr)) return kStr[0] === '-' ? -Math.SQRT2 / 2 : Math.SQRT2 / 2;
    if (/^-?sqrt\(3\)\/2$/i.test(kStr)) return kStr[0] === '-' ? -Math.sqrt(3) / 2 : Math.sqrt(3) / 2;
    if (/^-?sqrt\(3\)$/i.test(kStr)) return kStr[0] === '-' ? -Math.sqrt(3) : Math.sqrt(3);
    if (/^-?sqrt\(2\)$/i.test(kStr)) return kStr[0] === '-' ? -Math.SQRT2 : Math.SQRT2;
    return parseFloat(kStr);
}

// No-solution template data for each trig function
var NO_SOLUTION_TEMPLATES = {
    sin: {
        range: '[-1, 1]',
        rangeTex: '[-1,\\; 1]',
        check: function(k) { return Math.abs(k) > 1; },
        reason: function(k, kStr) {
            return 'The range of \\sin(x) is [-1,\\; 1]. Since ' + kStr + (k > 1 ? ' > 1' : ' < -1') + ', no real number x can satisfy this equation.';
        }
    },
    cos: {
        range: '[-1, 1]',
        rangeTex: '[-1,\\; 1]',
        check: function(k) { return Math.abs(k) > 1; },
        reason: function(k, kStr) {
            return 'The range of \\cos(x) is [-1,\\; 1]. Since ' + kStr + (k > 1 ? ' > 1' : ' < -1') + ', no real number x can satisfy this equation.';
        }
    },
    csc: {
        range: '(-\u221E, -1] \u222A [1, \u221E)',
        rangeTex: '(-\\infty, -1] \\cup [1, \\infty)',
        check: function(k) { return Math.abs(k) < 1 || k === 0; },
        reason: function(k, kStr) {
            return 'The range of \\csc(x) is (-\\infty, -1] \\cup [1, \\infty). Since |' + kStr + '| < 1, no real number x can satisfy this equation.';
        }
    },
    sec: {
        range: '(-\u221E, -1] \u222A [1, \u221E)',
        rangeTex: '(-\\infty, -1] \\cup [1, \\infty)',
        check: function(k) { return Math.abs(k) < 1 || k === 0; },
        reason: function(k, kStr) {
            return 'The range of \\sec(x) is (-\\infty, -1] \\cup [1, \\infty). Since |' + kStr + '| < 1, no real number x can satisfy this equation.';
        }
    }
    // tan and cot have range (-inf, inf), always solvable
};

function trySolveSimple(expr) {
    // Pattern: func(x) = k  for sin, cos, tan, csc, sec, cot
    var match = expr.match(/^(sin|cos|tan|csc|sec|cot)\s*\(\s*x\s*\)\s*=\s*(.+)$/i);
    if (!match) return null;

    var func = match[1].toLowerCase();
    var kStr = match[2].trim();
    var k = parseKValue(kStr);

    if (isNaN(k)) return null;

    // Check no-solution cases using templates
    var tmpl = NO_SOLUTION_TEMPLATES[func];
    if (tmpl && tmpl.check(k)) {
        return { noSolution: true, func: func, k: k, kStr: kStr, rangeTex: tmpl.rangeTex, reason: tmpl.reason(k, kStr) };
    }

    // For csc/sec/cot, we only handle the no-solution detection client-side
    // Actual solving of these is delegated to AI
    if (func === 'csc' || func === 'sec' || func === 'cot') return null;

    var solutions = [];
    var generalForm = '';

    if (func === 'sin') {
        var alpha = Math.asin(k);
        solutions.push({ x: alpha, label: 'x = ' + formatRad(alpha) });
        solutions.push({ x: Math.PI - alpha, label: 'x = ' + formatRad(Math.PI - alpha) });
        generalForm = 'x = ' + formatRad(alpha) + ' + 2n\\pi \\text{ or } x = ' + formatRad(Math.PI - alpha) + ' + 2n\\pi';
    } else if (func === 'cos') {
        var beta = Math.acos(k);
        solutions.push({ x: beta, label: 'x = ' + formatRad(beta) });
        solutions.push({ x: -beta, label: 'x = ' + formatRad(-beta) });
        generalForm = 'x = \\pm ' + formatRad(beta) + ' + 2n\\pi';
    } else if (func === 'tan') {
        var gamma = Math.atan(k);
        solutions.push({ x: gamma, label: 'x = ' + formatRad(gamma) });
        generalForm = 'x = ' + formatRad(gamma) + ' + n\\pi';
    }

    return { func: func, k: k, kStr: kStr, solutions: solutions, generalForm: generalForm };
}

function formatRad(val) {
    // Try to express as a nice pi fraction
    var piRatio = val / Math.PI;
    if (Math.abs(piRatio) < 0.0001) return '0';
    if (Math.abs(piRatio - 1) < 0.0001) return '\\pi';
    if (Math.abs(piRatio + 1) < 0.0001) return '-\\pi';

    // Check common fractions
    var fracs = [
        [1, 6], [1, 4], [1, 3], [1, 2], [2, 3], [3, 4], [5, 6],
        [7, 6], [5, 4], [4, 3], [3, 2], [5, 3], [7, 4], [11, 6]
    ];
    for (var i = 0; i < fracs.length; i++) {
        var n = fracs[i][0], d = fracs[i][1];
        if (Math.abs(piRatio - n / d) < 0.0001) return '\\frac{' + n + '\\pi}{' + d + '}';
        if (Math.abs(piRatio + n / d) < 0.0001) return '-\\frac{' + n + '\\pi}{' + d + '}';
    }

    return TC.fmt(val);
}

function renderClientSolution(container, result, expr, unit) {
    if (result.error) {
        TC.showError(container, result.error);
        return;
    }

    // No-solution template rendering
    if (result.noSolution) {
        renderNoSolutionEquation(container, result);
        return;
    }

    var stepNum = 1;
    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = 'Equation Solver';
    container.appendChild(badge);

    container.appendChild(TC.buildStepDOM(stepNum++, 'Identify the equation', result.func + '(x) = ' + result.kStr));

    if (result.func === 'sin') {
        container.appendChild(TC.buildStepDOM(stepNum++, 'Apply arcsin', 'x_1 = \\arcsin(' + result.kStr + ') = ' + formatRad(result.solutions[0].x)));
        container.appendChild(TC.buildStepDOM(stepNum++, 'Second solution in [0, 2\u03C0)', 'x_2 = \\pi - \\arcsin(' + result.kStr + ') = ' + formatRad(result.solutions[1].x)));
    } else if (result.func === 'cos') {
        container.appendChild(TC.buildStepDOM(stepNum++, 'Apply arccos', 'x_1 = \\arccos(' + result.kStr + ') = ' + formatRad(result.solutions[0].x)));
        container.appendChild(TC.buildStepDOM(stepNum++, 'Second solution (negative)', 'x_2 = -\\arccos(' + result.kStr + ') = ' + formatRad(result.solutions[1].x)));
    } else if (result.func === 'tan') {
        container.appendChild(TC.buildStepDOM(stepNum++, 'Apply arctan', 'x = \\arctan(' + result.kStr + ') = ' + formatRad(result.solutions[0].x)));
    }

    container.appendChild(TC.buildStepDOM(stepNum, '<strong>General solution</strong>', '\\boxed{' + result.generalForm + '}, \\quad n \\in \\mathbb{Z}'));

    // Graph
    state.pendingGraph = function() {
        var pts = [];
        for (var i = 0; i < result.solutions.length; i++) {
            pts.push({ x: result.solutions[i].x, y: result.k, label: result.solutions[i].label });
        }
        G.renderFunctionPlot('trig-graph-container', {
            functions: [{ expr: result.func + '(x)', label: result.func + '(x)' }],
            overlayFunctions: [{ expr: String(result.k), label: 'y = ' + result.kStr }],
            solutions: pts
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

function renderNoSolutionEquation(container, result) {
    container.innerHTML = '';

    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = 'No Solution';
    badge.style.background = 'var(--trig-gradient, linear-gradient(135deg, #dc2626, #ef4444))';
    container.appendChild(badge);

    var funcTex = '\\' + result.func;
    var eqTex = funcTex + '(x) = ' + result.kStr;

    container.appendChild(TC.buildStepDOM(1, 'Identify the equation', eqTex));
    container.appendChild(TC.buildStepDOM(2, 'Recall the range of ' + funcTex, '\\text{Range of } ' + funcTex + '(x) = ' + result.rangeTex));
    container.appendChild(TC.buildStepDOM(3, 'Check if the value is within range', result.reason));
    container.appendChild(TC.buildStepDOM(4, '<strong>Conclusion</strong>', '\\boxed{\\text{No Solution} \\;\\; \\varnothing}'));

    // Graph: show the function and the horizontal line that doesn't intersect
    state.pendingGraph = function() {
        G.renderFunctionPlot('trig-graph-container', {
            functions: [{ expr: result.func + '(x)', label: funcTex + '(x)' }],
            overlayFunctions: [{ expr: String(result.k), label: 'y = ' + result.kStr }]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Inequality No-Solution Detection ====================

var INEQ_TEMPLATES = {
    // sin(x) > k where k >= 1  → No solution (sin never exceeds 1)
    // sin(x) >= k where k > 1  → No solution
    // sin(x) < k where k <= -1 → No solution (sin never below -1)
    // sin(x) <= k where k < -1 → No solution
    // sin(x) > k where k < -1  → All real numbers
    // sin(x) < k where k > 1   → All real numbers
    // Same logic for cos(x)
    sin: { min: -1, max: 1, tex: '\\sin', rangeTex: '[-1,\\; 1]' },
    cos: { min: -1, max: 1, tex: '\\cos', rangeTex: '[-1,\\; 1]' },
    csc: { min: null, max: null, gapMin: -1, gapMax: 1, tex: '\\csc', rangeTex: '(-\\infty, -1] \\cup [1, \\infty)' },
    sec: { min: null, max: null, gapMin: -1, gapMax: 1, tex: '\\sec', rangeTex: '(-\\infty, -1] \\cup [1, \\infty)' }
};

function tryInequalityNoSolution(expr) {
    // Match: func(x) op k  where op is >, >=, <, <=
    var match = expr.match(/^(sin|cos|csc|sec)\s*\(\s*x\s*\)\s*(>=?|<=?)\s*(.+)$/i);
    if (!match) return null;

    var func = match[1].toLowerCase();
    var op = match[2];
    var kStr = match[3].trim();
    var k = parseKValue(kStr);
    if (isNaN(k)) return null;

    var tmpl = INEQ_TEMPLATES[func];
    if (!tmpl) return null;

    var funcTex = tmpl.tex + '(x)';
    var ineqTex = funcTex + ' ' + (op === '>=' ? '\\geq' : op === '<=' ? '\\leq' : op) + ' ' + kStr;

    // For bounded functions (sin, cos): range is [min, max]
    if (tmpl.min !== null) {
        var isNoSolution = false;
        var isAllReals = false;
        var reason = '';

        // Greater than / greater-equal checks
        if (op === '>' && k >= tmpl.max) {
            isNoSolution = true;
            reason = funcTex + ' \\text{ has maximum value } ' + tmpl.max + '. \\text{ Since } ' + kStr + ' \\geq ' + tmpl.max + ', \\text{ no } x \\text{ satisfies } ' + ineqTex + '.';
        } else if (op === '>=' && k > tmpl.max) {
            isNoSolution = true;
            reason = funcTex + ' \\text{ has maximum value } ' + tmpl.max + '. \\text{ Since } ' + kStr + ' > ' + tmpl.max + ', \\text{ no } x \\text{ satisfies } ' + ineqTex + '.';
        }
        // Less than / less-equal checks
        else if (op === '<' && k <= tmpl.min) {
            isNoSolution = true;
            reason = funcTex + ' \\text{ has minimum value } ' + tmpl.min + '. \\text{ Since } ' + kStr + ' \\leq ' + tmpl.min + ', \\text{ no } x \\text{ satisfies } ' + ineqTex + '.';
        } else if (op === '<=' && k < tmpl.min) {
            isNoSolution = true;
            reason = funcTex + ' \\text{ has minimum value } ' + tmpl.min + '. \\text{ Since } ' + kStr + ' < ' + tmpl.min + ', \\text{ no } x \\text{ satisfies } ' + ineqTex + '.';
        }
        // All reals checks
        else if (op === '>' && k < tmpl.min) {
            isAllReals = true;
            reason = funcTex + ' \\text{ has minimum value } ' + tmpl.min + '. \\text{ Since } ' + kStr + ' < ' + tmpl.min + ', \\text{ every real } x \\text{ satisfies } ' + ineqTex + '.';
        } else if (op === '>=' && k <= tmpl.min) {
            isAllReals = true;
            reason = funcTex + ' \\geq ' + tmpl.min + ' \\text{ for all } x, \\text{ and } ' + kStr + ' \\leq ' + tmpl.min + ', \\text{ so every real } x \\text{ satisfies } ' + ineqTex + '.';
        } else if (op === '<' && k > tmpl.max) {
            isAllReals = true;
            reason = funcTex + ' \\text{ has maximum value } ' + tmpl.max + '. \\text{ Since } ' + kStr + ' > ' + tmpl.max + ', \\text{ every real } x \\text{ satisfies } ' + ineqTex + '.';
        } else if (op === '<=' && k >= tmpl.max) {
            isAllReals = true;
            reason = funcTex + ' \\leq ' + tmpl.max + ' \\text{ for all } x, \\text{ and } ' + kStr + ' \\geq ' + tmpl.max + ', \\text{ so every real } x \\text{ satisfies } ' + ineqTex + '.';
        }

        if (isNoSolution) return { type: 'no_solution', func: func, funcTex: funcTex, ineqTex: ineqTex, rangeTex: tmpl.rangeTex, reason: reason, k: k, kStr: kStr };
        if (isAllReals) return { type: 'all_reals', func: func, funcTex: funcTex, ineqTex: ineqTex, rangeTex: tmpl.rangeTex, reason: reason, k: k, kStr: kStr };
    }

    // For gap functions (csc, sec): range is (-inf, gapMin] ∪ [gapMax, inf), gap is (gapMin, gapMax)
    if (tmpl.gapMin !== undefined) {
        // csc(x) > k where k in (-1, 1) exclusive, or csc(x) >= k where k in (-1, 1) → not no-solution but complicated
        // Simple no-solution: csc(x) = 0 is impossible (gap doesn't include 0), but that's an equation
        // For inequalities: csc(x) < k where k > -1 and < 1... skip, let AI handle non-trivial gap cases
    }

    return null;
}

function renderNoSolutionInequality(container, result) {
    container.innerHTML = '';

    var isNoSol = result.type === 'no_solution';
    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = isNoSol ? 'No Solution' : 'All Real Numbers';
    if (isNoSol) badge.style.background = 'var(--trig-gradient, linear-gradient(135deg, #dc2626, #ef4444))';
    else badge.style.background = 'linear-gradient(135deg, #059669, #10b981)';
    container.appendChild(badge);

    container.appendChild(TC.buildStepDOM(1, 'Identify the inequality', result.ineqTex));
    container.appendChild(TC.buildStepDOM(2, 'Recall the range of ' + result.funcTex, '\\text{Range of } ' + result.funcTex + ' = ' + result.rangeTex));
    container.appendChild(TC.buildStepDOM(3, 'Determine if solutions exist', result.reason));

    if (isNoSol) {
        container.appendChild(TC.buildStepDOM(4, '<strong>Conclusion</strong>', '\\boxed{\\text{No Solution} \\;\\; \\varnothing}'));
    } else {
        container.appendChild(TC.buildStepDOM(4, '<strong>Conclusion</strong>', '\\boxed{x \\in \\mathbb{R} \\;\\; \\text{(all real numbers)}}'));
    }

    // Graph: show the function and the threshold line
    state.pendingGraph = function() {
        G.renderFunctionPlot('trig-graph-container', {
            functions: [{ expr: result.func + '(x)', label: result.funcTex }],
            overlayFunctions: [{ expr: String(result.k), label: 'y = ' + result.kStr }]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

function setupEquationGraph(expr) {
    state.pendingGraph = function() {
        // Try to parse the equation for graphing
        var parts = expr.split('=');
        var funcs = [{ expr: parts[0].trim().replace(/\^/g, '**'), label: 'LHS' }];
        if (parts.length > 1) {
            funcs.push({ expr: parts[1].trim().replace(/\^/g, '**'), label: 'RHS' });
        }
        G.renderFunctionPlot('trig-graph-container', { functions: funcs });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Solve Inequality ====================

function renderSolveInequality(container, expr, unit) {
    container.innerHTML = '';

    // Check no-solution / all-reals cases client-side first
    var ineqResult = tryInequalityNoSolution(expr);
    if (ineqResult) {
        renderNoSolutionInequality(container, ineqResult);
        return;
    }

    // ── SymPy via OneCompiler — handles non-trivial inequalities
    //    deterministically (sin(x)>1/2 → Interval.open(π/6, 5π/6)). ──
    TC.showSpinner(container, 'Solving inequality...');
    state.pendingGraph = function () {
        var cleanExpr = expr.replace(/>=?|<=?/g, ' ').trim().split(/\s+/)[0];
        G.renderFunctionPlot('trig-graph-container', {
            functions: [{ expr: cleanExpr.replace(/\^/g, '**'), label: cleanExpr }]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };

    var fallbackToAI = function () {
        TC.callAI('trigonometry', expr, 'solve_inequality', 'x', '', function (err, steps, method) {
            if (err) { TC.showError(container, 'Error: ' + err); return; }
            TC.showAISteps(container, steps, method || 'Inequality Solver');
        });
    };
    if (!window.TrigBackend) { fallbackToAI(); return; }
    window.TrigBackend.compute({
        text: expr, mode: 'solve_inequality', variable: 'x'
    }, function (res) {
        if (res && res.ok && res.answer_latex) {
            renderSympySolveResult(container, res, expr);
        } else {
            fallbackToAI();
        }
    });
}

// ==================== Simplify ====================

function renderSimplify(container, expr) {
    container.innerHTML = '';

    // Try nerdamer first
    if (typeof nerdamer !== 'undefined') {
        try {
            var simplified = nerdamer('simplify(' + expr + ')').text();
            var originalTex = TC.safeTeX(expr);
            var simplifiedTex = TC.safeTeX(simplified);

            if (simplified !== expr && simplifiedTex !== originalTex) {
                var badge = document.createElement('div');
                badge.className = 'trig-result-badge';
                badge.textContent = 'Simplification (Nerdamer)';
                container.appendChild(badge);

                container.appendChild(TC.buildStepDOM(1, 'Original expression', originalTex));
                container.appendChild(TC.buildStepDOM(2, 'Apply simplification', simplifiedTex));
                container.appendChild(TC.buildStepDOM(3, '<strong>Result</strong>', '\\boxed{' + simplifiedTex + '}'));

                state.pendingGraph = function() {
                    G.renderFunctionPlot('trig-graph-container', {
                        functions: [
                            { expr: expr, label: 'Original' },
                            { expr: simplified, label: 'Simplified' }
                        ]
                    });
                    if (els.graphHint) els.graphHint.style.display = 'none';
                };
                return;
            }
        } catch (e) { /* fallback to AI */ }
    }

    // ── SymPy via OneCompiler — multi-strategy simplifier covers the
    //    cases nerdamer can't (e.g. cos(2x)+sin(2x)tan(x) → 1). ──
    TC.showSpinner(container, 'Simplifying...');
    state.pendingGraph = function () {
        G.renderFunctionPlot('trig-graph-container', {
            functions: [{ expr: expr.replace(/\^/g, '**'), label: expr }]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };

    var fallbackToAI = function () {
        TC.callAI('trigonometry', expr, 'simplify', 'x', '', function (err, steps, method) {
            if (err) { TC.showError(container, 'Error: ' + err); return; }
            TC.showAISteps(container, steps, method || 'Simplification');
        });
    };
    if (!window.TrigBackend) { fallbackToAI(); return; }
    window.TrigBackend.compute({
        text: expr, mode: 'simplify', variable: 'x'
    }, function (res) {
        if (res && res.ok && res.answer_latex) {
            renderSympySolveResult(container, res, expr);
        } else {
            fallbackToAI();
        }
    });
}

// ==================== Calculate ====================

function calculate() {
    var expr = els.exprInput ? els.exprInput.value.trim() : '';
    // Strip any LaTeX leak (\sin, \frac, \left( etc.) before client-side
    // regex / nerdamer / AI all see the value.
    if (window.MathInput && window.MathInput.latexToAscii) {
        expr = window.MathInput.latexToAscii(expr);
    }
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
        case 'solve_equation': renderSolveEquation(container, expr, state.unit); break;
        case 'solve_inequality': renderSolveInequality(container, expr, state.unit); break;
        case 'simplify': renderSimplify(container, expr); break;
    }

    // If the Graph tab is already active, fire the pending graph now —
    // otherwise the new closure would only render after a tab switch.
    var graphPanel = document.getElementById('trig-panel-graph');
    if (graphPanel && graphPanel.classList.contains('active') && state.pendingGraph) {
        state.pendingGraph();
        state.pendingGraph = null;
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
    'eq-sin12':    { mode: 'solve_equation', expr: 'sin(x) = 1/2' },
    'eq-sin2x':    { mode: 'solve_equation', expr: 'sin(2*x) = cos(x)' },
    'eq-2cos':     { mode: 'solve_equation', expr: '2*cos(x)^2 - 1 = 0' },
    'ineq-sin':    { mode: 'solve_inequality', expr: 'sin(x) > 1/2' },
    'simp-sincos': { mode: 'simplify', expr: 'sin(x)^4 - cos(x)^4' }
};

function loadExample(key) {
    var ex = EXAMPLES[key];
    if (!ex) return;
    switchMode(ex.mode);
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

    els.modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchMode(btn.getAttribute('data-mode')); });
    });

    els.unitBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchUnit(btn.getAttribute('data-unit')); });
    });

    if (els.exprInput) {
        els.exprInput.addEventListener('input', updatePreview);
        els.exprInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') calculate(); });
    }

    if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);
    if (els.clearBtn) els.clearBtn.addEventListener('click', function() {
        if (els.exprInput) els.exprInput.value = '';
        if (els.resultContent) els.resultContent.innerHTML = '';
        if (els.emptyState) { els.emptyState.style.display = 'flex'; els.resultContent.appendChild(els.emptyState); }
        if (els.resultActions) els.resultActions.style.display = 'none';
        updatePreview();
    });

    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchTab(btn.getAttribute('data-panel')); });
    });

    if (els.copyLatexBtn) els.copyLatexBtn.addEventListener('click', function() { E.copyLatex(state.mode, state); });
    if (els.shareBtn) els.shareBtn.addEventListener('click', function() { E.copyShareUrl(state); });

    document.querySelectorAll('.trig-example-chip').forEach(function(chip) {
        chip.addEventListener('click', function() { loadExample(chip.getAttribute('data-example')); });
    });

    loadFromUrl();
    updatePreview();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
