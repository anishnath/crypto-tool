/**
 * Series Calculator - Core Orchestration
 * State management, events, integration with Render/Graph/Export modules
 * Uses Nerdamer for symbolic differentiation (exact fractions, clean LaTeX)
 */
(function() {
'use strict';

var R = window.SeriesCalcRender;
var G = window.SeriesCalcGraph;
var E = window.SeriesCalcExport;

// ==================== State ====================

var state = {
    funcInput: 'e^x',
    seriesType: 'maclaurin',
    center: 0,
    numTerms: 5,
    mode: 'expansion',      // expansion | remainder | integral | limit
    currentFunction: null,  // preprocessed string for nerdamer
    derivativesAtCenter: [],
    derivativeExprs: [],    // LaTeX strings for step display
    derivativeTexts: [],    // raw nerdamer text strings for symbolic coefficients
    compilerLoaded: false,
    pendingGraph: false,
    sympyCalled: false
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function toLatex(exprStr) {
    try {
        return nerdamer(exprStr).toTeX();
    } catch (e) {
        return exprStr;
    }
}

function detectPolynomialDegree(expr) {
    var match = expr.match(/x\^(\d+)/g);
    if (!match) return 0;
    var maxDeg = 0;
    for (var i = 0; i < match.length; i++) {
        var d = parseInt(match[i].replace('x^', ''));
        if (d > maxDeg) maxDeg = d;
    }
    return maxDeg;
}

// ==================== Autocomplete ====================

var acSuggestions = [
    { expr: 'e^x', display: 'e^x', cat: 'Exponential' },
    { expr: 'e^(-x)', display: 'e^(-x)', cat: 'Exponential' },
    { expr: 'e^(2*x)', display: 'e^(2*x)', cat: 'Exponential' },
    { expr: 'x*e^x', display: 'x*e^x', cat: 'Exponential' },
    { expr: 'sin(x)', display: 'sin(x)', cat: 'Trig' },
    { expr: 'cos(x)', display: 'cos(x)', cat: 'Trig' },
    { expr: 'tan(x)', display: 'tan(x)', cat: 'Trig' },
    { expr: 'sin(2*x)', display: 'sin(2*x)', cat: 'Trig' },
    { expr: 'cos(2*x)', display: 'cos(2*x)', cat: 'Trig' },
    { expr: 'sin(x)^2', display: 'sin(x)^2', cat: 'Trig' },
    { expr: 'cos(x)^2', display: 'cos(x)^2', cat: 'Trig' },
    { expr: 'ln(1+x)', display: 'ln(1+x)', cat: 'Logarithmic' },
    { expr: 'ln(x)', display: 'ln(x)', cat: 'Logarithmic' },
    { expr: 'ln(1-x)', display: 'ln(1-x)', cat: 'Logarithmic' },
    { expr: 'sqrt(1+x)', display: 'sqrt(1+x)', cat: 'Power/Root' },
    { expr: '(1+x)^n', display: '(1+x)^n', cat: 'Power/Root' },
    { expr: 'x^2', display: 'x^2', cat: 'Power/Root' },
    { expr: 'x^3', display: 'x^3', cat: 'Power/Root' },
    { expr: '1/(1-x)', display: '1/(1-x)', cat: 'Geometric' },
    { expr: '1/(1+x)', display: '1/(1+x)', cat: 'Geometric' },
    { expr: '1/(1-x)^2', display: '1/(1-x)^2', cat: 'Geometric' },
    { expr: 'x/(1-x)', display: 'x/(1-x)', cat: 'Geometric' },
    { expr: 'asin(x)', display: 'asin(x)', cat: 'Inverse Trig' },
    { expr: 'atan(x)', display: 'atan(x)', cat: 'Inverse Trig' },
    { expr: 'acos(x)', display: 'acos(x)', cat: 'Inverse Trig' },
    { expr: 'sinh(x)', display: 'sinh(x)', cat: 'Hyperbolic' },
    { expr: 'cosh(x)', display: 'cosh(x)', cat: 'Hyperbolic' },
    { expr: 'tanh(x)', display: 'tanh(x)', cat: 'Hyperbolic' },
    { expr: 'e^x*sin(x)', display: 'e^x*sin(x)', cat: 'Combined' },
    { expr: 'e^x*cos(x)', display: 'e^x*cos(x)', cat: 'Combined' },
    { expr: 'x*sin(x)', display: 'x*sin(x)', cat: 'Combined' },
    { expr: 'x*cos(x)', display: 'x*cos(x)', cat: 'Combined' },
    { expr: 'sin(x)/x', display: 'sin(x)/x', cat: 'Combined' }
];

var acSelectedIndex = -1;
var acVisible = false;
var acBlurTimer = null;

function acFilter(query) {
    if (!query) return [];
    var q = query.toLowerCase();
    var matches = [];
    for (var i = 0; i < acSuggestions.length; i++) {
        var s = acSuggestions[i];
        if (s.expr.toLowerCase().indexOf(q) !== -1 || s.display.toLowerCase().indexOf(q) !== -1) {
            matches.push(s);
            if (matches.length >= 8) break;
        }
    }
    return matches;
}

function acRender(matches) {
    var dropdown = $('sc-func-autocomplete');
    if (!dropdown) return;
    if (matches.length === 0) {
        dropdown.classList.remove('active');
        acVisible = false;
        acSelectedIndex = -1;
        return;
    }
    var html = '';
    for (var i = 0; i < matches.length; i++) {
        html += '<div class="sc-func-ac-item" data-index="' + i + '" data-expr="' + matches[i].expr + '">'
            + '<span>' + matches[i].display + '</span>'
            + '<span class="sc-func-ac-cat">' + matches[i].cat + '</span>'
            + '</div>';
    }
    dropdown.innerHTML = html;
    dropdown.classList.add('active');
    acVisible = true;
    acSelectedIndex = -1;
}

function acSelect(expr) {
    var input = $('sc-func-input');
    if (input) {
        input.value = expr;
        input.focus();
    }
    acClose();
    updatePreview();
}

function acClose() {
    var dropdown = $('sc-func-autocomplete');
    if (dropdown) dropdown.classList.remove('active');
    acVisible = false;
    acSelectedIndex = -1;
}

function acHighlight(index) {
    var dropdown = $('sc-func-autocomplete');
    if (!dropdown) return;
    var items = dropdown.querySelectorAll('.sc-func-ac-item');
    for (var i = 0; i < items.length; i++) {
        items[i].classList.toggle('selected', i === index);
    }
    if (items[index]) {
        items[index].scrollIntoView({ block: 'nearest' });
    }
    acSelectedIndex = index;
}

function initAutocomplete() {
    var input = $('sc-func-input');
    var dropdown = $('sc-func-autocomplete');
    if (!input || !dropdown) return;

    input.addEventListener('input', function() {
        var val = this.value.trim();
        var matches = acFilter(val);
        acRender(matches);
    });

    input.addEventListener('keydown', function(e) {
        if (!acVisible) return;
        var dropdown = $('sc-func-autocomplete');
        var items = dropdown ? dropdown.querySelectorAll('.sc-func-ac-item') : [];
        var count = items.length;
        if (count === 0) return;

        if (e.key === 'ArrowDown') {
            e.preventDefault();
            var next = acSelectedIndex < count - 1 ? acSelectedIndex + 1 : 0;
            acHighlight(next);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            var prev = acSelectedIndex > 0 ? acSelectedIndex - 1 : count - 1;
            acHighlight(prev);
        } else if (e.key === 'Enter') {
            if (acSelectedIndex >= 0 && acSelectedIndex < count) {
                e.preventDefault();
                e.stopPropagation();
                var expr = items[acSelectedIndex].getAttribute('data-expr');
                acSelect(expr);
            }
        } else if (e.key === 'Escape') {
            e.preventDefault();
            acClose();
        }
    });

    input.addEventListener('blur', function() {
        acBlurTimer = setTimeout(function() { acClose(); }, 150);
    });

    input.addEventListener('focus', function() {
        var val = this.value.trim();
        if (val) {
            var matches = acFilter(val);
            acRender(matches);
        }
    });

    dropdown.addEventListener('mousedown', function(e) {
        e.preventDefault(); // prevent blur
        var item = e.target.closest('.sc-func-ac-item');
        if (item) {
            var expr = item.getAttribute('data-expr');
            acSelect(expr);
        }
    });
}

// ==================== SymPy Helpers ====================

/** Convert user input to Python/SymPy syntax */
function toPython(expr) {
    return (expr || '')
        .replace(/e\^(\([^)]+\))/g, 'exp$1')
        .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
        .replace(/\bln\(/g, 'log(')
        .replace(/\^/g, '**')
        .replace(/(\d)([a-zA-Z])/g, '$1*$2')
        .replace(/\)(\()/g, ')*$1')
        .replace(/\)([a-zA-Z])/g, ')*$1');
}

/** Get extra symbols beyond x for SymPy declaration */
function getExtraSymbols(pyExpr) {
    var KNOWN = ['exp','log','sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','sqrt','asin','acos','atan','pi','ln'];
    var seen = {};
    var re = /\b([a-z][a-z]*)\b/g;
    var m;
    while ((m = re.exec(pyExpr)) !== null) {
        var w = m[1];
        if (KNOWN.indexOf(w) >= 0 || w === 'x') continue;
        seen[w] = true;
    }
    return Object.keys(seen).sort();
}

var sympyController = null;

/** Call SymPy via OneCompiler to get exact series expansion */
function sympySimplify(funcInput, center, numTerms) {
    // Abort any previous request
    if (sympyController) { try { sympyController.abort(); } catch(e) {} }
    sympyController = new AbortController();

    var pyExpr = toPython(funcInput);
    var extra = getExtraSymbols(pyExpr);
    var allSyms = extra.concat(['x']);
    var opts = extra.length > 0 ? ', positive=True' : '';
    var symDecl = allSyms.join(', ') + " = symbols('" + allSyms.join(' ') + "'" + opts + ')';

    var centerPy = String(center).replace(/pi/g, 'pi');

    var code = 'from sympy import *\n' +
        symDecl + '\n' +
        'f = ' + pyExpr + '\n' +
        'try:\n' +
        '    s = series(f, x, ' + centerPy + ', n=' + numTerms + ')\n' +
        '    poly = s.removeO()\n' +
        '    has_O = s.has(Symbol("O")) or "O(" in str(s)\n' +
        '    print("LATEX:" + latex(poly))\n' +
        '    print("TEXT:" + str(poly))\n' +
        '    print("TERMINATES:" + str(not has_O))\n' +
        '    print("FULL:" + latex(s))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))\n';

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    var timeoutId = setTimeout(function() { sympyController.abort(); }, 30000);

    // No spinner — Nerdamer result is already visible as fallback.
    // SymPy will silently upgrade it when the response arrives.
    var simplifiedEl = document.getElementById('sc-sympy-simplified');

    fetch(contextPath + '/OneCompilerFunctionality?action=execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
        signal: sympyController.signal
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        clearTimeout(timeoutId);
        var stdout = (data.Stdout || data.stdout || '').trim();
        var stderr = (data.Stderr || data.stderr || '').trim();

        if (!stdout || stdout.indexOf('ERROR:') === 0) {
            // SymPy failed — keep the Nerdamer result as-is
            if (simplifiedEl) simplifiedEl.innerHTML = '';
            return;
        }

        var latexMatch = stdout.match(/LATEX:([^\n]*)/);
        var fullMatch = stdout.match(/FULL:([^\n]*)/);
        var termMatch = stdout.match(/TERMINATES:([^\n]*)/);

        if (!latexMatch) {
            if (simplifiedEl) simplifiedEl.innerHTML = '';
            return;
        }

        var resultLatex = latexMatch[1].trim();
        var fullLatex = fullMatch ? fullMatch[1].trim() : resultLatex;
        var terminates = termMatch ? termMatch[1].trim() === 'True' : false;

        var eq = terminates ? '=' : '\\approx';
        var displayLatex = terminates ? resultLatex : fullLatex;
        var boxedLatex = '\\boxed{f(x) ' + eq + ' ' + displayLatex + '}';

        // Update the simplified solution element — replace Nerdamer result
        if (simplifiedEl) {
            // Hide the Nerdamer result (previous sibling)
            var nerdamerEl = simplifiedEl.previousElementSibling;
            if (nerdamerEl && nerdamerEl.classList.contains('sc-step-math')) {
                nerdamerEl.style.display = 'none';
            }

            simplifiedEl.innerHTML = '';

            var mathDiv = document.createElement('div');
            mathDiv.className = 'sc-step-math';
            R.renderKaTeX(mathDiv, boxedLatex, true);
            simplifiedEl.appendChild(mathDiv);

            if (terminates) {
                var note = document.createElement('div');
                note.style.cssText = 'font-size:0.75rem;color:var(--sc-tool);margin-top:0.5rem;font-weight:500;';
                note.textContent = 'This is a polynomial — the series terminates exactly.';
                simplifiedEl.appendChild(note);
            }
        }
    })
    .catch(function() {
        clearTimeout(timeoutId);
        // Silently keep Nerdamer result on network error / abort
        if (simplifiedEl) simplifiedEl.innerHTML = '';
    });
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;
    var btns = document.querySelectorAll('.sc-mode-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === mode);
    }

    // Show/hide mode-specific inputs
    var ids = ['sc-remainder-inputs', 'sc-integral-inputs', 'sc-limit-inputs'];
    for (var j = 0; j < ids.length; j++) {
        var el = $(ids[j]);
        if (el) el.style.display = 'none';
    }
    if (mode === 'remainder') { var r = $('sc-remainder-inputs'); if (r) r.style.display = 'block'; }
    if (mode === 'integral') { var ig = $('sc-integral-inputs'); if (ig) ig.style.display = 'block'; }
    if (mode === 'limit') { var l = $('sc-limit-inputs'); if (l) l.style.display = 'block'; }

    // Show/hide expansion-only UI
    var typeToggle = $('sc-type-toggle-group');
    if (typeToggle) typeToggle.style.display = (mode === 'limit') ? 'none' : '';

    // Hide main function input in limit mode (it has its own expression input)
    var funcInputEl = $('sc-func-input');
    var funcInputGroup = funcInputEl ? funcInputEl.closest('.tool-form-group') : null;
    if (funcInputGroup) funcInputGroup.style.display = (mode === 'limit') ? 'none' : '';

    // Update button text
    var solveBtn = $('sc-solve-btn');
    if (solveBtn) {
        var labels = { expansion: 'Calculate Series', remainder: 'Calculate Error Bound', integral: 'Approximate Integral', limit: 'Evaluate Limit' };
        solveBtn.textContent = labels[mode] || 'Calculate';
    }

    // Update card header
    var cardHeader = document.querySelector('.tool-card-header');
    if (cardHeader) {
        var headers = { expansion: 'Series Expansion', remainder: 'Error Bound', integral: 'Integral Approximation', limit: 'Limit Evaluation' };
        cardHeader.textContent = headers[mode] || 'Series Expansion';
    }

    // Update compiler dropdown based on mode
    updateCompilerDropdown();
    updatePreview();
}

function updateCompilerDropdown() {
    var sel = $('sc-compiler-template');
    if (!sel) return;
    // Reset to standard options for expansion, show mode-specific for others
    var opts;
    switch (state.mode) {
        case 'remainder':
            opts = [{ v: 'sympy-remainder', t: 'Error Bound' }, { v: 'sympy-series', t: 'Series Expansion' }];
            break;
        case 'integral':
            opts = [{ v: 'sympy-integral', t: 'Integral Approximation' }, { v: 'sympy-series', t: 'Series Expansion' }];
            break;
        case 'limit':
            opts = [{ v: 'sympy-limit', t: 'Limit via Series' }, { v: 'sympy-series', t: 'Series Expansion' }];
            break;
        default:
            opts = [
                { v: 'sympy-series', t: 'Series Expansion' },
                { v: 'numpy-approx', t: 'Numeric Approximation' },
                { v: 'sympy-convergence', t: 'Convergence Analysis' }
            ];
    }
    sel.innerHTML = '';
    for (var i = 0; i < opts.length; i++) {
        var o = document.createElement('option');
        o.value = opts[i].v;
        o.textContent = opts[i].t;
        sel.appendChild(o);
    }
}

// ==================== SymPy-based Mode Calculations ====================

function getContextPath() {
    var meta = document.querySelector('meta[name="context-path"]');
    return meta ? (meta.getAttribute('content') || '') : '';
}

function setSolveButtonBusy(busy) {
    var btn = $('sc-solve-btn');
    if (!btn) return;
    btn.disabled = busy;
    if (busy) {
        btn.setAttribute('data-original-text', btn.textContent);
        btn.textContent = 'Computing\u2026';
    } else {
        var orig = btn.getAttribute('data-original-text');
        if (orig) btn.textContent = orig;
    }
}

function callSymPy(code, callback) {
    if (sympyController) { try { sympyController.abort(); } catch(e) {} }
    sympyController = new AbortController();
    var timeoutId = setTimeout(function() { sympyController.abort(); }, 30000);

    setSolveButtonBusy(true);

    // Show loading spinner in result
    var content = $('sc-result-content');
    if (content) {
        var empty = $('sc-empty-state');
        if (empty) empty.style.display = 'none';
        content.innerHTML = '<div style="text-align:center;padding:2rem;"><div class="sc-sympy-spinner"></div><p style="margin-top:0.75rem;font-size:0.8125rem;color:var(--text-muted);">Computing...</p></div>';
    }

    fetch(getContextPath() + '/OneCompilerFunctionality?action=execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
        signal: sympyController.signal
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        clearTimeout(timeoutId);
        setSolveButtonBusy(false);
        var stdout = (data.Stdout || data.stdout || '').trim();
        var stderr = (data.Stderr || data.stderr || '').trim();
        callback(stdout, stderr);
    })
    .catch(function(err) {
        clearTimeout(timeoutId);
        setSolveButtonBusy(false);
        if (content) {
            R.showError(content, 'Computation failed. Check your inputs and try again.');
        }
    });
}

// ==================== PDF Download ====================

/**
 * Re-render all KaTeX inside a container so html2canvas can capture them.
 * Cloned KaTeX nodes lose font metrics; fresh katex.render() fixes that.
 * Also forces light-mode colours on every element for white-background PDF.
 */
function prepareContainerForCapture(root) {
    // Re-render every KaTeX block from its LaTeX source annotation
    var katexEls = root.querySelectorAll('.katex');
    for (var i = 0; i < katexEls.length; i++) {
        var ann = katexEls[i].querySelector('annotation');
        if (ann && ann.textContent && window.katex) {
            var parent = katexEls[i].parentNode;
            var isDisplay = !!(parent && parent.classList && parent.classList.contains('sc-step-math'));
            var wrapper = document.createElement('div');
            try {
                katex.render(ann.textContent, wrapper, { displayMode: isDisplay, throwOnError: false });
                parent.replaceChild(wrapper, katexEls[i]);
            } catch (e) { /* keep original on error */ }
        }
    }
    // Force all text/bg to light-mode colours
    var allEls = root.querySelectorAll('*');
    for (var j = 0; j < allEls.length; j++) {
        var el = allEls[j];
        var cs = window.getComputedStyle(el);
        var rgb = cs.color.match(/\d+/g);
        if (rgb && parseInt(rgb[0]) > 180 && parseInt(rgb[1]) > 180 && parseInt(rgb[2]) > 180) {
            el.style.color = '#0f172a';
        }
        var bgRgb = cs.backgroundColor.match(/\d+/g);
        if (bgRgb && parseInt(bgRgb[0]) < 60 && parseInt(bgRgb[1]) < 60 && parseInt(bgRgb[2]) < 60) {
            el.style.backgroundColor = '#ffffff';
        }
    }
}

function buildPdfSteps(container) {
    var stepsArea = $('sc-steps-area');
    if (!stepsArea || stepsArea.children.length === 0) return;

    var stepsLabel = document.createElement('div');
    stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin:24px 0 12px;border-top:1px solid #e2e8f0;padding-top:16px;';
    stepsLabel.textContent = 'Step-by-Step Solution';
    container.appendChild(stepsLabel);

    // Mode accent colours for step numbers
    var accentColors = { expansion: '#2563eb', remainder: '#d97706', integral: '#7c3aed', limit: '#e11d48' };
    var accent = accentColors[state.mode] || '#2563eb';

    var stepEls = stepsArea.querySelectorAll('.sc-step');
    for (var i = 0; i < stepEls.length; i++) {
        var stepRow = document.createElement('div');
        stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:14px;';

        // Numbered circle
        var numDiv = document.createElement('div');
        numDiv.style.cssText = 'width:24px;height:24px;background:' + accent + ';color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
        numDiv.textContent = (i + 1);
        stepRow.appendChild(numDiv);

        var body = document.createElement('div');
        body.style.cssText = 'flex:1;min-width:0;';

        // Description text
        var descEl = stepEls[i].querySelector('.sc-step-desc');
        if (descEl) {
            var descDiv = document.createElement('div');
            descDiv.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:6px;';
            descDiv.textContent = descEl.textContent;
            body.appendChild(descDiv);
        }

        // Re-render each math block from annotation source
        var mathEls = stepEls[i].querySelectorAll('.sc-step-math, .sc-step-derivative');
        for (var m = 0; m < mathEls.length; m++) {
            var ann = mathEls[m].querySelector('annotation');
            if (ann && ann.textContent && window.katex) {
                var mathDiv = document.createElement('div');
                mathDiv.style.cssText = 'font-size:16px;margin-bottom:4px;overflow-x:hidden;';
                try {
                    katex.render(ann.textContent, mathDiv, { displayMode: true, throwOnError: false });
                } catch (e) {
                    mathDiv.textContent = ann.textContent;
                }
                body.appendChild(mathDiv);
            }
        }

        stepRow.appendChild(body);
        container.appendChild(stepRow);
    }
}

function downloadResultPdf() {
    var resultContent = $('sc-result-content');
    if (!resultContent || !resultContent.innerHTML.trim()) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
        return;
    }

    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

    // Build an off-screen container with white background for capture
    var container = document.createElement('div');
    container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);

    // Title
    var modeTitles = { expansion: 'Series Expansion', remainder: 'Error Bound', integral: 'Integral Approximation', limit: 'Limit Evaluation' };
    var modeColors = { expansion: '#2563eb', remainder: '#d97706', integral: '#7c3aed', limit: '#e11d48' };
    var modeColor = modeColors[state.mode] || '#2563eb';

    var title = document.createElement('div');
    title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:' + modeColor + ';';
    title.textContent = (modeTitles[state.mode] || 'Series Calculator') + ' \u2014 8gwifi.org';
    container.appendChild(title);

    var divider = document.createElement('div');
    divider.style.cssText = 'height:2px;background:linear-gradient(90deg,' + modeColor + ',transparent);margin-bottom:24px;';
    container.appendChild(divider);

    // Clone result content and re-render all KaTeX fresh
    var resultClone = resultContent.cloneNode(true);
    resultClone.style.cssText = 'font-size:16px;';
    container.appendChild(resultClone);
    prepareContainerForCapture(container);

    // Build steps by re-rendering math from annotation sources
    buildPdfSteps(container);

    // Footer
    var footer = document.createElement('div');
    footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML = '<span>Generated by 8gwifi.org Series Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
    container.appendChild(footer);

    // Load libraries and generate
    var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve()
        : (typeof ToolUtils !== 'undefined' && ToolUtils._loadScript ? ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js') : Promise.reject('No loader'));

    loadHtml2Canvas
        .then(function() {
            return (typeof window.jspdf !== 'undefined') ? Promise.resolve()
                : (typeof ToolUtils !== 'undefined' && ToolUtils._loadScript ? ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js') : Promise.reject('No loader'));
        })
        .then(function() {
            return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false });
        })
        .then(function(canvas) {
            document.body.removeChild(container);
            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
            var pageWidth = pdf.internal.pageSize.getWidth();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;
            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            var usableHeight = pdf.internal.pageSize.getHeight() - margin * 2;
            if (imgHeight > usableHeight) { imgHeight = usableHeight; imgWidth = (canvas.width * usableHeight) / canvas.height; }
            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);

            var filename = 'series-' + (state.mode || 'expansion') + '-' + (state.funcInput || 'result').replace(/[^a-zA-Z0-9]/g, '_').substring(0, 30) + '.pdf';
            pdf.save(filename);
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('PDF downloaded!', 2000, 'success');
                if (ToolUtils.showSupportPopup) ToolUtils.showSupportPopup('Series Calculator', 'Downloaded: ' + filename);
            }
        })
        .catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + (err.message || err), 3000, 'error');
        });
}

function parseTags(stdout) {
    var result = {};
    var lines = stdout.split('\n');
    for (var i = 0; i < lines.length; i++) {
        var idx = lines[i].indexOf(':');
        if (idx > 0) {
            var key = lines[i].substring(0, idx).trim();
            var val = lines[i].substring(idx + 1).trim();
            result[key] = val;
        }
    }
    return result;
}

function calculateRemainder() {
    var funcInput = $('sc-func-input').value.trim();
    var numTerms = parseInt($('sc-num-terms').value) || 5;
    var centerStr = $('sc-center-point').value.trim() || '0';
    var evalPoint = ($('sc-eval-point') || {}).value || '0.5';

    if (!funcInput) { R.showError($('sc-result-content'), 'Please enter a function.'); return; }

    var pyExpr = toPython(funcInput);
    var extra = getExtraSymbols(pyExpr);
    var allSyms = extra.concat(['x']);
    var opts = extra.length > 0 ? ', positive=True' : '';
    var symDecl = allSyms.join(', ') + " = symbols('" + allSyms.join(' ') + "'" + opts + ')';

    var code = 'from sympy import *\n' +
        symDecl + '\n' +
        'f = ' + pyExpr + '\n' +
        'a = ' + toPython(centerStr) + '\n' +
        'n_terms = ' + numTerms + '\n' +
        'eval_x = ' + toPython(evalPoint) + '\n' +
        'try:\n' +
        '    # Taylor polynomial\n' +
        '    s = series(f, x, a, n=n_terms)\n' +
        '    poly = s.removeO()\n' +
        '    # (n+1)th derivative\n' +
        '    d = f\n' +
        '    for i in range(n_terms):\n' +
        '        d = diff(d, x)\n' +
        '    # Lagrange remainder: |f^(n+1)(c)| / (n+1)! * |x-a|^(n+1)\n' +
        '    # Find max of |f^(n+1)| on interval [a, eval_x]\n' +
        '    lo = Min(a, eval_x)\n' +
        '    hi = Max(a, eval_x)\n' +
        '    try:\n' +
        '        M = maximum(Abs(d), x, Interval(lo, hi))\n' +
        '    except:\n' +
        '        # fallback: evaluate at endpoints and midpoint\n' +
        '        pts = [lo, hi, (lo+hi)/2]\n' +
        '        M = max(abs(float(d.subs(x, p))) for p in pts)\n' +
        '        M = Float(M)\n' +
        '    bound = M / factorial(n_terms) * Abs(eval_x - a)**n_terms\n' +
        '    actual_err = Abs(f.subs(x, eval_x) - poly.subs(x, eval_x))\n' +
        '    Rn = Function("R_n")\n' +
        '    print("FORMULA:" + latex(Eq(Rn(x), d / factorial(n_terms) * (x - a)**n_terms)))\n' +
        '    print("BOUND:" + str(float(bound)))\n' +
        '    print("ACTUAL_ERROR:" + str(float(actual_err)))\n' +
        '    print("LATEX_POLY:" + latex(poly))\n' +
        '    print("LATEX_REMAINDER:" + latex(Eq(Symbol("B"), bound)) + r" \\quad \\text{(upper bound)}")\n' +
        '    print("STEP_DERIV_EXPR:" + latex(d))\n' +
        '    print("STEP_MAX_DERIV:" + str(float(M)))\n' +
        '    print("STEP_INTERVAL:" + str(float(lo)) + "," + str(float(hi)))\n' +
        '    print("STEP_EVAL_EXACT:" + str(float(f.subs(x, eval_x))))\n' +
        '    print("STEP_EVAL_POLY:" + str(float(poly.subs(x, eval_x))))\n' +
        'except Exception as e:\n' +
        '    print("CALCERROR:" + str(e))\n';

    callSymPy(code, function(stdout, stderr) {
        var content = $('sc-result-content');
        if (!stdout || stdout.indexOf('CALCERROR:') === 0) {
            R.showError(content, 'Error computing remainder: ' + (stdout.replace('CALCERROR:', '') || stderr || 'unknown error'));
            return;
        }
        var tags = parseTags(stdout);
        if (tags['CALCERROR']) { R.showError(content, 'Error computing remainder: ' + tags['CALCERROR']); return; }
        R.renderRemainderResult({
            latexRemainder: tags['LATEX_REMAINDER'] || tags['FORMULA'] || '',
            bound: tags['BOUND'] || '',
            actualError: tags['ACTUAL_ERROR'] || '',
            latexPoly: tags['LATEX_POLY'] || ''
        }, content);

        var actions = $('sc-result-actions');
        if (actions) actions.style.display = 'flex';

        var stepsArea = $('sc-steps-area');
        R.renderRemainderSteps(stepsArea, tags);
        var stepsCta = $('sc-steps-cta');
        var stepsBtn = $('sc-steps-toggle-btn');
        if (stepsCta) stepsCta.style.display = 'block';
        if (stepsArea) stepsArea.style.display = 'none';
        if (stepsBtn) {
            stepsBtn.classList.remove('open');
            stepsBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5l7 7-7 7"/></svg> Show Step-by-Step Solution';
        }
        var convergenceArea = $('sc-convergence-area');
        if (convergenceArea) convergenceArea.innerHTML = '';

        updateCompiler();
    });
}

function calculateIntegral() {
    var funcInput = $('sc-func-input').value.trim();
    var numTerms = parseInt($('sc-num-terms').value) || 5;
    var centerStr = $('sc-center-point').value.trim() || '0';
    var lower = ($('sc-int-lower') || {}).value || '0';
    var upper = ($('sc-int-upper') || {}).value || '1';

    if (!funcInput) { R.showError($('sc-result-content'), 'Please enter a function.'); return; }

    var pyExpr = toPython(funcInput);
    var extra = getExtraSymbols(pyExpr);
    var allSyms = extra.concat(['x']);
    var opts = extra.length > 0 ? ', positive=True' : '';
    var symDecl = allSyms.join(', ') + " = symbols('" + allSyms.join(' ') + "'" + opts + ')';

    var code = 'from sympy import *\n' +
        symDecl + '\n' +
        'f = ' + pyExpr + '\n' +
        'a = ' + toPython(centerStr) + '\n' +
        'n_terms = ' + numTerms + '\n' +
        'lo = ' + toPython(lower) + '\n' +
        'hi = ' + toPython(upper) + '\n' +
        'try:\n' +
        '    s = series(f, x, a, n=n_terms)\n' +
        '    poly = s.removeO()\n' +
        '    # Integrate the Taylor polynomial term-by-term\n' +
        '    approx_integral = integrate(poly, (x, lo, hi))\n' +
        '    # Exact integral\n' +
        '    exact_integral = integrate(f, (x, lo, hi))\n' +
        '    err = Abs(exact_integral - approx_integral)\n' +
        '    print("APPROX:" + str(float(approx_integral)))\n' +
        '    print("EXACT:" + str(float(exact_integral)))\n' +
        '    print("ABSERROR:" + str(float(err)))\n' +
        '    print("LATEX_POLY:" + latex(poly))\n' +
        '    print("LATEX_INTEGRAL:" + latex(Eq(Symbol("I_{approx}"), approx_integral)))\n' +
        '    print("LATEX_EXACT:" + latex(Eq(Symbol("I_{exact}"), exact_integral)))\n' +
        '    antideriv = integrate(poly, x)\n' +
        '    print("STEP_ANTIDERIV:" + latex(antideriv))\n' +
        '    print("STEP_SETUP:" + latex(Integral(poly, (x, lo, hi))))\n' +
        '    print("STEP_UPPER_VAL:" + str(float(antideriv.subs(x, hi))))\n' +
        '    print("STEP_LOWER_VAL:" + str(float(antideriv.subs(x, lo))))\n' +
        'except Exception as e:\n' +
        '    print("CALCERROR:" + str(e))\n';

    callSymPy(code, function(stdout, stderr) {
        var content = $('sc-result-content');
        if (!stdout || stdout.indexOf('CALCERROR:') === 0) {
            R.showError(content, 'Error computing integral: ' + (stdout.replace('CALCERROR:', '') || stderr || 'unknown error'));
            return;
        }
        var tags = parseTags(stdout);
        if (tags['CALCERROR']) {
            R.showError(content, 'Error computing integral: ' + tags['CALCERROR']);
            return;
        }
        R.renderIntegralResult({
            approx: tags['APPROX'] || '',
            exact: tags['EXACT'] || '',
            error: tags['ABSERROR'] || '',
            latexPoly: tags['LATEX_POLY'] || '',
            latexIntegral: tags['LATEX_INTEGRAL'] || '',
            latexExact: tags['LATEX_EXACT'] || ''
        }, content);

        var actions = $('sc-result-actions');
        if (actions) actions.style.display = 'flex';

        var stepsArea = $('sc-steps-area');
        R.renderIntegralSteps(stepsArea, tags);
        var stepsCta = $('sc-steps-cta');
        var stepsBtn = $('sc-steps-toggle-btn');
        if (stepsCta) stepsCta.style.display = 'block';
        if (stepsArea) stepsArea.style.display = 'none';
        if (stepsBtn) {
            stepsBtn.classList.remove('open');
            stepsBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5l7 7-7 7"/></svg> Show Step-by-Step Solution';
        }
        var convergenceArea = $('sc-convergence-area');
        if (convergenceArea) convergenceArea.innerHTML = '';

        updateCompiler();
    });
}

function calculateLimit() {
    var limitExpr = ($('sc-limit-expr') || {}).value || 'sin(x)/x';
    var limitPoint = ($('sc-limit-point') || {}).value || '0';
    var numTerms = parseInt($('sc-num-terms').value) || 5;

    if (!limitExpr) { R.showError($('sc-result-content'), 'Please enter an expression.'); return; }

    var pyExpr = toPython(limitExpr);
    var pyPoint = toPython(limitPoint);
    // Map 'inf' to SymPy oo
    if (pyPoint === 'inf' || pyPoint === 'infinity') pyPoint = 'oo';
    if (pyPoint === '-inf' || pyPoint === '-infinity') pyPoint = '-oo';

    var extra = getExtraSymbols(pyExpr);
    var allSyms = extra.concat(['x']);
    var opts = extra.length > 0 ? ', positive=True' : '';
    var symDecl = allSyms.join(', ') + " = symbols('" + allSyms.join(' ') + "'" + opts + ')';

    var code = 'from sympy import *\n' +
        symDecl + '\n' +
        'expr = ' + pyExpr + '\n' +
        'pt = ' + pyPoint + '\n' +
        'try:\n' +
        '    lim_val = limit(expr, x, pt)\n' +
        '    if pt == oo or pt == -oo:\n' +
        '        # For infinite limits, series expansion is not useful\n' +
        '        print("LIMIT:" + str(lim_val))\n' +
        '        print("LATEX_EXPANSION:")\n' +
        '        print("LATEX_SIMPLIFIED:")\n' +
        '        print("LATEX_LIMIT:" + latex(Eq(Symbol("L"), lim_val)))\n' +
        '    else:\n' +
        '        expanded = series(expr, x, pt, n=' + numTerms + ')\n' +
        '        simplified = expanded.removeO()\n' +
        '        print("LIMIT:" + str(lim_val))\n' +
        '        print("LATEX_EXPANSION:" + latex(expanded))\n' +
        '        print("LATEX_SIMPLIFIED:" + latex(simplified))\n' +
        '        print("LATEX_LIMIT:" + latex(Eq(Symbol("L"), lim_val)))\n' +
        '        print("STEP_ORIGINAL:" + latex(expr))\n' +
        '        try:\n' +
        '            direct = expr.subs(x, pt)\n' +
        '            print("STEP_DIRECT:" + str(direct))\n' +
        '        except:\n' +
        '            print("STEP_DIRECT:indeterminate")\n' +
        '        try:\n' +
        '            print("STEP_NUMER_EXPAND:" + latex(series(numer(expr), x, pt, n=' + numTerms + ')))\n' +
        '            print("STEP_DENOM_EXPAND:" + latex(series(denom(expr), x, pt, n=' + numTerms + ')))\n' +
        '        except:\n' +
        '            pass\n' +
        'except Exception as e:\n' +
        '    print("CALCERROR:" + str(e))\n';

    callSymPy(code, function(stdout, stderr) {
        var content = $('sc-result-content');
        if (!stdout || stdout.indexOf('CALCERROR:') === 0) {
            R.showError(content, 'Error computing limit: ' + (stdout.replace('CALCERROR:', '') || stderr || 'unknown error'));
            return;
        }
        var tags = parseTags(stdout);
        if (tags['CALCERROR']) { R.showError(content, 'Error computing limit: ' + tags['CALCERROR']); return; }
        R.renderLimitResult({
            limit: tags['LIMIT'] || '',
            latexExpansion: tags['LATEX_EXPANSION'] || '',
            latexSimplified: tags['LATEX_SIMPLIFIED'] || '',
            latexLimit: tags['LATEX_LIMIT'] ? '\\boxed{' + tags['LATEX_LIMIT'] + '}' : ''
        }, content);

        var actions = $('sc-result-actions');
        if (actions) actions.style.display = 'flex';

        var stepsArea = $('sc-steps-area');
        R.renderLimitSteps(stepsArea, tags);
        var stepsCta = $('sc-steps-cta');
        var stepsBtn = $('sc-steps-toggle-btn');
        if (stepsCta) stepsCta.style.display = 'block';
        if (stepsArea) stepsArea.style.display = 'none';
        if (stepsBtn) {
            stepsBtn.classList.remove('open');
            stepsBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5l7 7-7 7"/></svg> Show Step-by-Step Solution';
        }
        var convergenceArea = $('sc-convergence-area');
        if (convergenceArea) convergenceArea.innerHTML = '';

        updateCompiler();
    });
}

// ==================== Core Computation ====================

function calculateSeries() {
    // Dispatch to mode-specific handler
    if (state.mode === 'remainder') { calculateRemainder(); return; }
    if (state.mode === 'integral') { calculateIntegral(); return; }
    if (state.mode === 'limit') { calculateLimit(); return; }

    state.sympyCalled = false;

    var funcInput = $('sc-func-input').value.trim();
    var numTerms = parseInt($('sc-num-terms').value) || 5;
    var centerStr = $('sc-center-point').value.trim() || '0';

    if (!funcInput) {
        R.showError($('sc-result-content'), 'Please enter a function.');
        return;
    }

    if (!window.nerdamer) {
        R.showError($('sc-result-content'), 'Math library not loaded. Please refresh the page.');
        return;
    }

    numTerms = Math.max(1, Math.min(20, numTerms));

    try {
        // Parse center point
        state.center = parseFloat(nerdamer(centerStr).evaluate().text());
        state.funcInput = funcInput;
        state.numTerms = numTerms;

        // Preprocess function input for nerdamer
        var processedInput = funcInput
            .replace(/\be\^x\b/g, 'exp(x)')
            .replace(/\be\^\(/g, 'exp(')
            .replace(/\bln\(/g, 'log(')
            .replace(/\bpi\b/g, 'pi');

        // Store function as string (nerdamer works with strings)
        state.currentFunction = processedInput;

        // For polynomials, auto-detect degree and ensure enough terms
        var detectedDegree = detectPolynomialDegree(processedInput);
        if (detectedDegree > 0 && numTerms <= detectedDegree) {
            numTerms = detectedDegree + 1;
            state.numTerms = numTerms;
            var numTermsInput = $('sc-num-terms');
            if (numTermsInput) numTermsInput.value = numTerms;
        }

        // Calculate derivatives using nerdamer
        state.derivativesAtCenter = [];
        state.derivativeExprs = [];
        state.derivativeTexts = [];
        var derivStr = processedInput;

        for (var n = 0; n < numTerms; n++) {
            // Evaluate derivative at center
            var value = parseFloat(nerdamer(derivStr).evaluate({ x: state.center }).text());
            state.derivativesAtCenter.push(value);

            // Store LaTeX derivative expression for step display
            state.derivativeExprs.push(toLatex(derivStr));

            // Store raw nerdamer text for symbolic coefficient rendering
            state.derivativeTexts.push(derivStr);

            // Differentiate for next iteration
            if (n < numTerms - 1) {
                derivStr = nerdamer.diff(derivStr, 'x').text();
            }
        }

        // Render result
        var funcLatex = toLatex(state.currentFunction);
        R.renderResult(
            $('sc-result-content'),
            funcLatex,
            state.derivativesAtCenter,
            numTerms,
            state.center,
            state.seriesType
        );

        // Render steps (hidden until user clicks CTA)
        var stepsArea = $('sc-steps-area');
        R.renderSteps(
            stepsArea,
            state.derivativesAtCenter,
            numTerms,
            state.center,
            state.derivativeExprs,
            state.derivativeTexts
        );

        // Show steps CTA button, collapse steps
        var stepsCta = $('sc-steps-cta');
        var stepsBtn = $('sc-steps-toggle-btn');
        if (stepsCta) stepsCta.style.display = 'block';
        if (stepsArea) stepsArea.style.display = 'none';
        if (stepsBtn) {
            stepsBtn.classList.remove('open');
            stepsBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5l7 7-7 7"/></svg> Show Step-by-Step Solution';
        }

        // Render convergence analysis
        R.renderConvergence($('sc-convergence-area'), funcInput);

        // Show result actions
        var actions = $('sc-result-actions');
        if (actions) actions.style.display = 'flex';

        // Hide empty state
        var empty = $('sc-empty-state');
        if (empty) empty.style.display = 'none';

        // Update graph
        updateGraph();

        // Update term slider
        var slider = $('sc-term-slider');
        if (slider) {
            slider.max = numTerms;
            slider.value = numTerms;
        }
        var sliderVal = $('sc-term-slider-value');
        if (sliderVal) sliderVal.textContent = numTerms;

        // Update compiler
        updateCompiler();

    } catch (error) {
        R.showError($('sc-result-content'), 'Error: ' + error.message);
    }
}

function updateGraph() {
    if (!state.currentFunction || state.derivativesAtCenter.length === 0) return;

    var container = $('sc-graph-container');
    if (!container) return;

    var hint = $('sc-graph-hint');
    if (hint) hint.style.display = 'none';

    if (!window.Plotly) {
        state.pendingGraph = true;
        G.loadPlotly(function() {
            state.pendingGraph = false;
            doRenderGraph();
        });
    } else {
        doRenderGraph();
    }
}

function doRenderGraph() {
    var funcStr = state.currentFunction;
    var evalFn = function(xVal) {
        try {
            return parseFloat(nerdamer(funcStr).evaluate({ x: xVal }).text());
        } catch(e) { return NaN; }
    };
    var sliderVal = parseInt(($('sc-term-slider') || {}).value) || state.numTerms;
    G.renderGraph(
        'sc-graph-container',
        evalFn,
        'x',
        state.derivativesAtCenter,
        state.center,
        sliderVal
    );
}

function updateCompiler() {
    if (!state.compilerLoaded) return;
    var iframe = $('sc-compiler-iframe');
    var templateSelect = $('sc-compiler-template');
    if (!iframe || !templateSelect) return;

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    // Pass mode-specific params for compiler templates
    var funcForCompiler = state.funcInput;
    var centerForCompiler = state.center;
    var extra = {};
    if (state.mode === 'limit') {
        funcForCompiler = ($('sc-limit-expr') || {}).value || 'sin(x)/x';
        centerForCompiler = ($('sc-limit-point') || {}).value || '0';
    }
    if (state.mode === 'remainder') {
        extra.evalPoint = ($('sc-eval-point') || {}).value || '0.5';
    }
    if (state.mode === 'integral') {
        extra.lower = ($('sc-int-lower') || {}).value || '0';
        extra.upper = ($('sc-int-upper') || {}).value || '1';
    }

    var url = E.getCompilerUrl(
        templateSelect.value,
        funcForCompiler,
        centerForCompiler,
        state.numTerms,
        contextPath,
        extra
    );
    iframe.src = url;
}

function loadCompiler() {
    if (state.compilerLoaded) return;
    state.compilerLoaded = true;

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    var iframe = $('sc-compiler-iframe');
    var templateSelect = $('sc-compiler-template');
    if (!iframe || !templateSelect) return;

    var url = E.getCompilerUrl(
        templateSelect.value,
        state.funcInput,
        state.center,
        state.numTerms,
        contextPath
    );
    iframe.src = url;
}

// ==================== UI Handlers ====================

function switchSeriesType(type) {
    state.seriesType = type;
    var btns = document.querySelectorAll('.sc-type-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-type') === type);
    }

    var centerGroup = $('sc-center-group');
    if (centerGroup) {
        centerGroup.style.display = type === 'taylor' ? 'block' : 'none';
    }
    if (type === 'maclaurin') {
        var centerInput = $('sc-center-point');
        if (centerInput) centerInput.value = '0';
        state.center = 0;
    }

    updatePreview();
}

/**
 * Build the live-preview LaTeX string for the current mode.
 * Returns {latex: string} or {empty: string} when input is missing.
 */
function buildPreviewLatex(opts) {
    var mode = opts.mode || 'expansion';
    var funcInput = opts.funcInput || '';
    var center = opts.center || 0;
    var numTerms = opts.numTerms || 5;
    var a = R.fmt(center);

    if (mode === 'expansion') {
        if (!funcInput) return { empty: 'Enter a function to see preview' };
        var centerStr = center === 0 ? '' : ' - ' + center;
        return { latex: 'f(x) = \\sum_{n=0}^{' + numTerms + '} \\frac{f^{(n)}(' + a + ')}{n!}(x' + centerStr + ')^n' };
    }
    if (mode === 'remainder') {
        if (!funcInput) return { empty: 'Enter a function to see preview' };
        var evalPt = opts.evalPoint || 'x';
        return { latex: '\\left|R_{' + numTerms + '}(' + evalPt + ')\\right| \\leq \\frac{M}{(' + numTerms + '+1)!}\\left|' + evalPt + ' - ' + a + '\\right|^{' + numTerms + '+1}' };
    }
    if (mode === 'integral') {
        if (!funcInput) return { empty: 'Enter a function to see preview' };
        var lo = opts.lower || 'a';
        var hi = opts.upper || 'b';
        return { latex: '\\int_{' + lo + '}^{' + hi + '} f(x)\\,dx \\approx \\int_{' + lo + '}^{' + hi + '} P_{' + numTerms + '}(x)\\,dx' };
    }
    if (mode === 'limit') {
        var limitExpr = opts.limitExpr || '';
        var limitPt = opts.limitPoint || '0';
        if (!limitExpr) return { empty: 'Enter an expression to see preview' };
        return { latex: '\\lim_{x \\to ' + limitPt + '} \\left(' + limitExpr + '\\right)' };
    }
    return { empty: 'Unknown mode' };
}

var previewTimer = null;
function updatePreview() {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        var preview = $('sc-preview');
        if (!preview || !window.katex) return;

        var result = buildPreviewLatex({
            mode: state.mode || 'expansion',
            funcInput: ($('sc-func-input') || {}).value || '',
            center: state.seriesType === 'maclaurin' ? 0 : (parseFloat(($('sc-center-point') || {}).value) || 0),
            numTerms: parseInt(($('sc-num-terms') || {}).value) || 5,
            evalPoint: ($('sc-eval-point') || {}).value || 'x',
            lower: ($('sc-int-lower') || {}).value || 'a',
            upper: ($('sc-int-upper') || {}).value || 'b',
            limitExpr: ($('sc-limit-expr') || {}).value || '',
            limitPoint: ($('sc-limit-point') || {}).value || '0'
        });

        if (result.empty) {
            preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">' + result.empty + '</span>';
        } else {
            R.renderKaTeX(preview, result.latex, true);
        }
    }, 100);
}

function loadExample(name) {
    var examples = {
        'exp':     { f: 'e^x',       t: 'maclaurin', n: 5 },
        'sin':     { f: 'sin(x)',     t: 'maclaurin', n: 7 },
        'cos':     { f: 'cos(x)',     t: 'maclaurin', n: 7 },
        'ln':      { f: 'ln(1+x)',    t: 'maclaurin', n: 6 },
        'geo':     { f: '1/(1-x)',    t: 'maclaurin', n: 6 },
        'sqrt':    { f: 'sqrt(1+x)',  t: 'maclaurin', n: 6 },
        'tan':     { f: 'tan(x)',     t: 'maclaurin', n: 5 },
        'taylor':  { f: 'sin(x)',     t: 'taylor',    n: 7, c: 'pi' }
    };

    var ex = examples[name];
    if (!ex) return;

    var funcInput = $('sc-func-input');
    var numTermsInput = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.value = ex.f;
    if (numTermsInput) numTermsInput.value = ex.n;
    if (centerInput) centerInput.value = ex.c || '0';

    switchSeriesType(ex.t);
    updatePreview();
    calculateSeries();
}

function clearAll() {
    var funcInput = $('sc-func-input');
    var numTerms = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.value = '';
    if (numTerms) numTerms.value = '5';
    if (centerInput) centerInput.value = '0';

    state.derivativesAtCenter = [];
    state.derivativeExprs = [];
    state.derivativeTexts = [];
    state.currentFunction = null;

    var content = $('sc-result-content');
    if (content) {
        content.innerHTML = '<div class="tool-empty-state" id="sc-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&Sigma;</div>' +
            '<h3>Enter a function</h3>' +
            '<p>Calculate Taylor or Maclaurin series expansion with step-by-step solutions.</p>' +
            '</div>';
    }

    var actions = $('sc-result-actions');
    if (actions) actions.style.display = 'none';

    var stepsArea = $('sc-steps-area');
    if (stepsArea) { stepsArea.innerHTML = ''; stepsArea.style.display = 'none'; }

    var stepsCta = $('sc-steps-cta');
    if (stepsCta) stepsCta.style.display = 'none';

    var convergenceArea = $('sc-convergence-area');
    if (convergenceArea) convergenceArea.innerHTML = '';

    var hint = $('sc-graph-hint');
    if (hint) hint.style.display = '';

    switchSeriesType('maclaurin');
    updatePreview();
}

function loadFromURL() {
    var data = E.parseShareUrl();
    if (!data) return false;

    var funcInput = $('sc-func-input');
    var numTerms = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.value = data.f || '';
    if (numTerms) numTerms.value = data.n || 5;
    if (centerInput) centerInput.value = data.c || '0';

    switchSeriesType(data.t || 'maclaurin');
    calculateSeries();
    return true;
}

// ==================== Initialization ====================

function init() {
    // Mode toggle
    var modeBtns = document.querySelectorAll('.sc-mode-btn');
    for (var m = 0; m < modeBtns.length; m++) {
        modeBtns[m].addEventListener('click', function() {
            switchMode(this.getAttribute('data-mode'));
        });
    }

    // Series type toggle
    var typeBtns = document.querySelectorAll('.sc-type-btn');
    for (var i = 0; i < typeBtns.length; i++) {
        typeBtns[i].addEventListener('click', function() {
            switchSeriesType(this.getAttribute('data-type'));
        });
    }

    // Solve & Clear buttons
    var solveBtn = $('sc-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculateSeries);

    var clearBtn = $('sc-clear-btn');
    if (clearBtn) clearBtn.addEventListener('click', clearAll);

    // Steps toggle CTA
    var stepsToggle = $('sc-steps-toggle-btn');
    if (stepsToggle) {
        stepsToggle.addEventListener('click', function() {
            var stepsArea = $('sc-steps-area');
            if (!stepsArea) return;
            var isOpen = stepsArea.style.display !== 'none';
            stepsArea.style.display = isOpen ? 'none' : 'block';
            this.classList.toggle('open', !isOpen);
            this.innerHTML = (isOpen
                ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5l7 7-7 7"/></svg> Show Step-by-Step Solution'
                : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5l7 7-7 7"/></svg> Hide Step-by-Step Solution');

            // Trigger SymPy on first open for this calculation
            if (!isOpen && !state.sympyCalled && state.currentFunction) {
                state.sympyCalled = true;
                sympySimplify(state.funcInput, state.center, state.numTerms);
            }
        });
    }

    // Output tabs
    var tabs = document.querySelectorAll('.sc-output-tab');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
            this.classList.add('active');

            var panels = document.querySelectorAll('.sc-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.toggle('active', panels[k].id === 'sc-panel-' + panel);
            }

            if (panel === 'graph' && state.currentFunction) updateGraph();
            if (panel === 'python' && !state.compilerLoaded) loadCompiler();
        });
    }

    // Function palette buttons
    var paletteBtns = document.querySelectorAll('.sc-palette-btn');
    for (var p = 0; p < paletteBtns.length; p++) {
        paletteBtns[p].addEventListener('click', function() {
            var input = $('sc-func-input');
            if (!input) return;
            var text = this.getAttribute('data-insert');
            var start = input.selectionStart;
            var end = input.selectionEnd;
            var val = input.value;
            input.value = val.substring(0, start) + text + val.substring(end);
            var newPos = start + text.length;
            input.setSelectionRange(newPos, newPos);
            input.focus();
            updatePreview();
        });
    }

    // Input changes trigger preview
    var funcInput = $('sc-func-input');
    var numTerms = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.addEventListener('input', updatePreview);
    if (numTerms) numTerms.addEventListener('input', updatePreview);
    if (centerInput) centerInput.addEventListener('input', updatePreview);

    // Mode-specific input listeners for live preview
    var modeInputIds = ['sc-eval-point', 'sc-int-lower', 'sc-int-upper', 'sc-limit-expr', 'sc-limit-point'];
    for (var mi = 0; mi < modeInputIds.length; mi++) {
        var modeEl = $(modeInputIds[mi]);
        if (modeEl) modeEl.addEventListener('input', updatePreview);
    }

    // Enter key to solve (only when autocomplete is not active with a selection)
    if (funcInput) funcInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !(acVisible && acSelectedIndex >= 0)) calculateSeries();
    });

    // Term slider
    var slider = $('sc-term-slider');
    if (slider) {
        slider.addEventListener('input', function() {
            var val = parseInt(this.value);
            var display = $('sc-term-slider-value');
            if (display) display.textContent = val;
            if (state.currentFunction && window.Plotly) {
                doRenderGraph();
            }
        });
    }

    // Action buttons
    var shareBtn = $('sc-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function() {
            E.copyShareUrl(state);
        });
    }

    // Download PDF
    var pdfBtn = $('sc-download-pdf-btn');
    if (pdfBtn) {
        pdfBtn.addEventListener('click', downloadResultPdf);
    }

    // Worksheet button
    var worksheetBtn = $('sc-worksheet-btn');
    if (worksheetBtn) {
        worksheetBtn.addEventListener('click', function() {
            if (typeof WorksheetEngine !== 'undefined') {
                WorksheetEngine.open({
                    jsonUrl: getContextPath() + '/worksheet/math/calculus/taylor_series.json',
                    title: 'Taylor & Maclaurin Series',
                    accentColor: '#2563eb',
                    branding: '8gwifi.org',
                    defaultCount: 20
                });
            }
        });
    }

    // Compiler template change
    var compilerTemplate = $('sc-compiler-template');
    if (compilerTemplate) {
        compilerTemplate.addEventListener('change', updateCompiler);
    }

    // Example chips
    var chips = document.querySelectorAll('.sc-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    }

    // FAQ toggles
    if (typeof window.toggleFaq === 'undefined') {
        window.toggleFaq = function(btn) {
            var item = btn.parentElement;
            var answer = item.querySelector('.faq-answer');
            var chevron = btn.querySelector('.faq-chevron');
            var isOpen = answer.style.maxHeight && answer.style.maxHeight !== '0px';
            answer.style.maxHeight = isOpen ? '0px' : answer.scrollHeight + 'px';
            answer.style.padding = isOpen ? '0 1rem' : '0.75rem 1rem';
            if (chevron) chevron.style.transform = isOpen ? '' : 'rotate(180deg)';
        };
    }

    // Initialize autocomplete
    initAutocomplete();

    // Initialize preview
    updatePreview();

    // Load from URL if params exist
    if (!loadFromURL()) {
        // Preload Plotly
        G.loadPlotly();
    }
}

// ==================== DOM Ready ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
