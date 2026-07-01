<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Inline scripts extracted verbatim from inequality-solver.jsp (Phase 1
    of the math-studio migration). Behavior unchanged from the legacy
    page. Phase 2 will replace the input layer with MathLive + AI scan
    while keeping this partial as the logic source.
--%>
<% String _v = String.valueOf(System.currentTimeMillis()); %>
    <%-- math-tool-engine-boot provides KaTeX, nerdamer (+Solve), Plotly loader,
         tool-utils, dark-mode, search, image-to-math, and math-ai-cores-engine. --%>

    <script>
    (function() {
    'use strict';

    // Read from #ic-expr when present (math-studio shell — math-input-setup
    // mirrors MathLive ascii-math here). Fall back to #iq-expr for any
    // legacy environment that hasn't migrated.
    var exprInput = document.getElementById('ic-expr') || document.getElementById('iq-expr');
    var previewEl = document.getElementById('iq-preview');
    var varSelect = document.getElementById('iq-var');
    var solveBtn = document.getElementById('iq-solve-btn');
    var resultContent = document.getElementById('iq-result-content');
    var resultActions = document.getElementById('iq-result-actions');
    var graphHint = document.getElementById('iq-graph-hint');
    var numberlineHint = document.getElementById('iq-numberline-hint');

    var lastResultLatex = '', lastResultText = '', compilerLoaded = false;
    var pendingGraph = null, pendingNumberline = null, lastSolveContext = null;

    window.toggleFaq = function(btn) { btn.parentElement.classList.toggle('open'); };

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.iq-output-tab');
    var panels = document.querySelectorAll('.iq-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('iq-panel-' + panel).classList.add('active');
            if (panel === 'numberline' && pendingNumberline) { renderNumberLine(pendingNumberline); pendingNumberline = null; }
            if (panel === 'graph' && pendingGraph) { loadPlotly(function() { renderGraph(pendingGraph); }); pendingGraph = null; }
            if (panel === 'python' && !compilerLoaded) { loadCompilerWithTemplate(); compilerLoaded = true; }
        });
    });

    // ========== Syntax Help ==========
    document.getElementById('iq-syntax-btn').addEventListener('click', function() {
        var c = document.getElementById('iq-syntax-content');
        c.classList.toggle('open');
        this.querySelector('.iq-syntax-chevron').style.transform = c.classList.contains('open') ? 'rotate(180deg)' : '';
    });

    // ========== Quick Examples ==========
    document.getElementById('iq-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.iq-example-chip');
        if (!chip) return;
        exprInput.value = chip.getAttribute('data-expr');
        updatePreview();
        exprInput.focus();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    exprInput.addEventListener('input', function() { clearTimeout(previewTimer); previewTimer = setTimeout(updatePreview, 200); });
    varSelect.addEventListener('change', updatePreview);

    function updatePreview() {
        var raw = exprInput.value.trim();
        if (!raw) { previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type an inequality above\u2026</span>'; return; }
        try {
            // normalizeRaw may throw on equations; guard so the preview just
            // shows the hint instead of crashing.
            var normalized;
            try { normalized = normalizeRaw(raw); } catch (_) { normalized = raw; }
            var latex = inequalityToLatex(normalized);
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch(e) { previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>'; }
    }

    function inequalityToLatex(raw) {
        // Handle compound: a < expr < b
        var compoundMatch = raw.match(/^(.+?)\s*(<=?)\s*(.+?)\s*(<=?)\s*(.+)$/);
        if (compoundMatch && !compoundMatch[3].match(/[<>=]/)) {
            var l = exprToLatex(compoundMatch[1]);
            var op1 = compoundMatch[2] === '<=' ? '\\leq' : '<';
            var mid = exprToLatex(compoundMatch[3]);
            var op2 = compoundMatch[4] === '<=' ? '\\leq' : '<';
            var r = exprToLatex(compoundMatch[5]);
            return l + ' ' + op1 + ' ' + mid + ' ' + op2 + ' ' + r;
        }
        var parts = raw.split(/(>=|<=|>|<)/);
        if (parts.length >= 3) {
            var lhs = exprToLatex(parts[0].trim());
            var op = parts[1] === '>=' ? '\\geq' : parts[1] === '<=' ? '\\leq' : parts[1] === '>' ? '>' : '<';
            var rhs = exprToLatex(parts.slice(2).join('').trim());
            return lhs + ' ' + op + ' ' + rhs;
        }
        return exprToLatex(raw);
    }

    function exprToLatex(expr) {
        var e = expr.replace(/\|([^|]+)\|/g, 'abs($1)');
        try { return nerdamer(e).toTeX(); } catch(err) {
            return e.replace(/\*/g, ' \\cdot ').replace(/abs\(([^)]+)\)/g, '|$1|');
        }
    }

    function escapeHtml(s) { var d = document.createElement('div'); d.appendChild(document.createTextNode(s)); return d.innerHTML; }

    // ========== Pre-parse normalization ==========
    // Handles common student/teacher input quirks: Unicode glyphs from PDFs
    // and textbooks, implicit multiplication, and equations typed where an
    // inequality was expected.
    function normalizeRaw(s) {
        if (s == null) return '';
        s = String(s);
        // Unicode comparison ops → ASCII
        s = s.replace(/≤/g, '<=').replace(/≥/g, '>=').replace(/⩽/g, '<=').replace(/⩾/g, '>=');
        s = s.replace(/＜/g, '<').replace(/＞/g, '>').replace(/≠/g, '!=');
        // Various dashes / unicode minus → ASCII -
        s = s.replace(/[−–—]/g, '-');
        // Unicode multiplication
        s = s.replace(/[×·]/g, '*');
        // Unicode superscripts
        s = s.replace(/²/g, '^2').replace(/³/g, '^3').replace(/⁴/g, '^4').replace(/⁵/g, '^5').replace(/⁶/g, '^6');
        // Unicode infinity
        s = s.replace(/∞/g, 'infinity');
        // Detect bare equation (= but not <= or >=) — surface a friendly hint.
        var stripped = s.replace(/<=/g, '').replace(/>=/g, '').replace(/!=/g, '');
        if (stripped.indexOf('=') >= 0) {
            throw new Error('That looks like an equation, not an inequality. Use <, >, <=, or >= as the comparison. (For equations like x²−4=0, try the quadratic-solver or polynomial-calculator.)');
        }
        // Implicit multiplication: 2x → 2*x, (x+1)(x-2) → (x+1)*(x-2),
        // 2(x+1) → 2*(x+1). Tighten gaps so nerdamer parses cleanly.
        s = s.replace(/(\d)([a-zA-Z(])/g, '$1*$2');
        s = s.replace(/\)([a-zA-Z0-9(])/g, ')*$1');
        return s.replace(/\s+/g, ' ').trim();
    }

    // ========== Core: Parse Inequality ==========
    function parseInequality(input) {
        var raw = normalizeRaw(input.trim());

        // Absolute value: |expr| op val
        var absMatch = raw.match(/^\|([^|]+)\|\s*(>=?|<=?)\s*(.+)$/);
        if (absMatch) {
            var inner = absMatch[1], aop = absMatch[2], aval = absMatch[3].trim();
            if (aop === '<' || aop === '<=') {
                // |f| < a => -a < f < a
                return { type: 'compound', parts: [
                    { type: 'standard', expr: '(' + inner + ')-(' + aval + ')', op: aop, origLhs: inner, origRhs: aval },
                    { type: 'standard', expr: '(-(' + aval + '))-(' + inner + ')', op: aop, origLhs: '-' + aval, origRhs: inner }
                ], absInner: inner, absOp: aop, absVal: aval };
            } else {
                // |f| > a => f > a OR f < -a
                return { type: 'union', parts: [
                    { type: 'standard', expr: '(' + inner + ')-(' + aval + ')', op: aop === '>=' ? '>=' : '>', origLhs: inner, origRhs: aval },
                    { type: 'standard', expr: '(-(' + aval + '))-(' + inner + ')', op: aop === '>=' ? '>=' : '>', origLhs: '-' + aval, origRhs: inner }
                ], absInner: inner, absOp: aop, absVal: aval };
            }
        }

        // abs(expr) op val
        var absFnMatch = raw.match(/^abs\(([^)]+)\)\s*(>=?|<=?)\s*(.+)$/);
        if (absFnMatch) return parseInequality('|' + absFnMatch[1] + '|' + absFnMatch[2] + absFnMatch[3]);

        // Compound: a < expr < b
        var cMatch = raw.match(/^(.+?)\s*(<=?)\s*(.+?)\s*(<=?)\s*(.+)$/);
        if (cMatch) {
            var cLeft = cMatch[1].trim(), cOp1 = cMatch[2], cMid = cMatch[3].trim(), cOp2 = cMatch[4], cRight = cMatch[5].trim();
            // Check mid doesn't contain operators (to avoid false matches)
            if (!/[<>=]/.test(cMid)) {
                return { type: 'compound', parts: [
                    { type: 'standard', expr: '(' + cMid + ')-(' + cLeft + ')', op: cOp1 === '<=' ? '>=' : '>', origLhs: cMid, origRhs: cLeft },
                    { type: 'standard', expr: '(' + cMid + ')-(' + cRight + ')', op: cOp2 === '<=' ? '<=' : '<', origLhs: cMid, origRhs: cRight }
                ], compoundLeft: cLeft, compoundMid: cMid, compoundRight: cRight, compoundOp1: cOp1, compoundOp2: cOp2 };
            }
        }

        // Standard: lhs op rhs
        var opMatch = raw.match(/^(.*?)(>=|<=|>|<)(.*)$/);
        if (!opMatch) throw new Error('No inequality operator found. Use >, >=, <, or <=');
        var lhs = opMatch[1].trim(), op = opMatch[2], rhs = opMatch[3].trim();
        if (!lhs) throw new Error('Missing left-hand side');
        if (!rhs) rhs = '0';
        // Normalize: move rhs to left => expr = lhs - rhs
        lhs = lhs.replace(/\|([^|]+)\|/g, 'abs($1)');
        rhs = rhs.replace(/\|([^|]+)\|/g, 'abs($1)');
        var expr;
        if (rhs === '0') { expr = lhs; } else { expr = '(' + lhs + ')-(' + rhs + ')'; }
        return { type: 'standard', expr: expr, op: op, origLhs: lhs, origRhs: rhs };
    }

    // ========== Core: Solve ==========
    function solveStandard(expr, op, v) {
        var roots = [], denomZeros = [];
        // Find roots
        try {
            var sols = nerdamer.solve(expr, v);
            var solText = sols.text();
            roots = parseSolutions(solText);
        } catch(e) { /* no roots found */ }

        // Detect rational: try to find denominator zeros
        // Method 1: Check original expression for / at top level
        var denomExpr = extractDenominator(expr);
        if (denomExpr) {
            try {
                var denomSols = nerdamer.solve(denomExpr, v);
                denomZeros = parseSolutions(denomSols.text());
            } catch(e2) {}
        }
        // Method 2: Check nerdamer simplified form for ^(-1) or /
        if (denomZeros.length === 0) {
            try {
                var texRepr = nerdamer(expr).text();
                var negExpMatch = texRepr.match(/\(([^)]+)\)\^(?:\(-1\)|-1)/);
                if (negExpMatch) {
                    try {
                        var ds = nerdamer.solve(negExpMatch[1], v);
                        denomZeros = parseSolutions(ds.text());
                    } catch(e3) {}
                } else if (texRepr.indexOf('/') !== -1) {
                    var slParts = texRepr.match(/^(.+?)\/(.+)$/);
                    if (slParts) {
                        try {
                            var ds2 = nerdamer.solve(slParts[2], v);
                            denomZeros = parseSolutions(ds2.text());
                        } catch(e4) {}
                    }
                }
            } catch(e) {}
        }

        // Combine and sort critical points
        var allCritical = roots.concat(denomZeros);
        allCritical = uniqueSorted(allCritical);

        // Build intervals
        var intervals = [];
        if (allCritical.length === 0) {
            intervals.push({ left: -Infinity, right: Infinity, testPoint: 0 });
        } else {
            intervals.push({ left: -Infinity, right: allCritical[0], testPoint: allCritical[0] - 1 });
            for (var i = 0; i < allCritical.length - 1; i++) {
                intervals.push({ left: allCritical[i], right: allCritical[i+1], testPoint: (allCritical[i] + allCritical[i+1]) / 2 });
            }
            intervals.push({ left: allCritical[allCritical.length-1], right: Infinity, testPoint: allCritical[allCritical.length-1] + 1 });
        }

        // Test each interval
        var signChart = [];
        for (var j = 0; j < intervals.length; j++) {
            var sign = evaluateSign(expr, v, intervals[j].testPoint);
            var inSol = checkSign(sign, op);
            signChart.push({ interval: intervals[j], testPoint: intervals[j].testPoint, sign: sign, inSolution: inSol });
        }

        // Build solution intervals
        var includeEndpoints = (op === '>=' || op === '<=');
        var solutionIntervals = [];
        for (var k = 0; k < signChart.length; k++) {
            if (!signChart[k].inSolution) continue;
            var intv = signChart[k].interval;
            var li = (intv.left === -Infinity) ? false : (includeEndpoints && !isDenomZero(intv.left, denomZeros));
            var ri = (intv.right === Infinity) ? false : (includeEndpoints && !isDenomZero(intv.right, denomZeros));
            solutionIntervals.push({ left: intv.left, right: intv.right, leftInclusive: li, rightInclusive: ri });
        }

        // Merge adjacent
        solutionIntervals = mergeIntervals(solutionIntervals);

        var isAllReals = solutionIntervals.length === 1 && solutionIntervals[0].left === -Infinity && solutionIntervals[0].right === Infinity;
        return { criticalPoints: allCritical, denomZeros: denomZeros, roots: roots, signChart: signChart, intervals: solutionIntervals, expression: expr, op: op, isEmpty: solutionIntervals.length === 0, isAllReals: isAllReals };
    }

    function solveInequality(parsed, v) {
        if (parsed.type === 'standard') return solveStandard(parsed.expr, parsed.op, v);
        if (parsed.type === 'compound') {
            var s1 = solveStandard(parsed.parts[0].expr, parsed.parts[0].op, v);
            var s2 = solveStandard(parsed.parts[1].expr, parsed.parts[1].op, v);
            return { type: 'compound', sol1: s1, sol2: s2, intervals: intersectIntervals(s1.intervals, s2.intervals),
                     criticalPoints: uniqueSorted(s1.criticalPoints.concat(s2.criticalPoints)),
                     signChart: s1.signChart.concat(s2.signChart),
                     isEmpty: false, isAllReals: false, expression: parsed.parts[0].expr, op: parsed.parts[0].op };
        }
        if (parsed.type === 'union') {
            var u1 = solveStandard(parsed.parts[0].expr, parsed.parts[0].op, v);
            var u2 = solveStandard(parsed.parts[1].expr, parsed.parts[1].op, v);
            return { type: 'union', sol1: u1, sol2: u2, intervals: unionIntervals(u1.intervals, u2.intervals),
                     criticalPoints: uniqueSorted(u1.criticalPoints.concat(u2.criticalPoints)),
                     signChart: u1.signChart, isEmpty: false, isAllReals: false, expression: parsed.parts[0].expr, op: parsed.parts[0].op };
        }
        throw new Error('Unknown parsed type');
    }

    // ========== Helpers ==========
    function extractDenominator(expr) {
        // Find top-level '/' in original expression string
        var depth = 0;
        for (var i = 0; i < expr.length; i++) {
            if (expr[i] === '(') depth++;
            else if (expr[i] === ')') depth--;
            else if (expr[i] === '/' && depth === 0) {
                var denom = expr.substring(i + 1).trim();
                if (denom[0] === '(' && denom[denom.length - 1] === ')') {
                    denom = denom.substring(1, denom.length - 1);
                }
                return denom;
            }
        }
        return null;
    }

    function parseSolutions(text) {
        if (!text || text === '[]') return [];
        var inner = text.replace(/^\[/, '').replace(/\]$/, '');
        if (!inner.trim()) return [];
        var parts = inner.split(',');
        var result = [];
        for (var i = 0; i < parts.length; i++) {
            var p = parts[i].trim();
            if (p.indexOf('i') !== -1) continue; // skip complex
            try {
                var val = parseFloat(nerdamer(p).text('decimals'));
                if (isFinite(val)) result.push(val);
            } catch(e) {
                var n = parseFloat(p);
                if (isFinite(n)) result.push(n);
            }
        }
        return result;
    }

    function uniqueSorted(arr) {
        var seen = {}, result = [];
        for (var i = 0; i < arr.length; i++) {
            var key = arr[i].toFixed(10);
            if (!seen[key]) { seen[key] = true; result.push(arr[i]); }
        }
        return result.sort(function(a,b) { return a - b; });
    }

    function evaluateSign(expr, v, val) {
        try {
            var obj = {}; obj[v] = val;
            var result = nerdamer(expr, obj).text('decimals');
            var num = parseFloat(result);
            if (isNaN(num)) return '?';
            if (Math.abs(num) < 1e-10) return '0';
            return num > 0 ? '+' : '-';
        } catch(e) { return '?'; }
    }

    function checkSign(sign, op) {
        if (op === '>' || op === '>=') return sign === '+';
        if (op === '<' || op === '<=') return sign === '-';
        return false;
    }

    function isDenomZero(val, denomZeros) {
        for (var i = 0; i < denomZeros.length; i++) {
            if (Math.abs(val - denomZeros[i]) < 1e-10) return true;
        }
        return false;
    }

    function mergeIntervals(intervals) {
        if (intervals.length <= 1) return intervals;
        var merged = [intervals[0]];
        for (var i = 1; i < intervals.length; i++) {
            var last = merged[merged.length - 1];
            var cur = intervals[i];
            if (Math.abs(last.right - cur.left) < 1e-10 && (last.rightInclusive || cur.leftInclusive)) {
                last.right = cur.right;
                last.rightInclusive = cur.rightInclusive;
            } else {
                merged.push(cur);
            }
        }
        return merged;
    }

    function intersectIntervals(a, b) {
        var result = [];
        for (var i = 0; i < a.length; i++) {
            for (var j = 0; j < b.length; j++) {
                var left = Math.max(a[i].left, b[j].left);
                var right = Math.min(a[i].right, b[j].right);
                if (left < right || (left === right && a[i].leftInclusive && b[j].leftInclusive)) {
                    var li = (left === a[i].left ? a[i].leftInclusive : b[j].leftInclusive);
                    if (left === a[i].left && left === b[j].left) li = a[i].leftInclusive && b[j].leftInclusive;
                    var ri = (right === a[i].right ? a[i].rightInclusive : b[j].rightInclusive);
                    if (right === a[i].right && right === b[j].right) ri = a[i].rightInclusive && b[j].rightInclusive;
                    result.push({ left: left, right: right, leftInclusive: li, rightInclusive: ri });
                }
            }
        }
        return result;
    }

    function unionIntervals(a, b) {
        return mergeIntervals(a.concat(b).sort(function(x,y) { return x.left - y.left; }));
    }

    function formatInterval(intervals) {
        if (intervals.length === 0) return '\u2205';
        return intervals.map(function(iv) {
            var l = iv.left === -Infinity ? '(-\u221E' : (iv.leftInclusive ? '[' : '(') + formatNum(iv.left);
            var r = iv.right === Infinity ? '\u221E)' : formatNum(iv.right) + (iv.rightInclusive ? ']' : ')');
            return l + ', ' + r;
        }).join(' \u222A ');
    }

    function formatIntervalLatex(intervals) {
        if (intervals.length === 0) return '\\emptyset';
        return intervals.map(function(iv) {
            var l = iv.left === -Infinity ? '(-\\infty' : (iv.leftInclusive ? '[' : '(') + formatNum(iv.left);
            var r = iv.right === Infinity ? '\\infty)' : formatNum(iv.right) + (iv.rightInclusive ? ']' : ')');
            return l + ', ' + r;
        }).join(' \\cup ');
    }

    function formatNum(n) { return Number.isInteger(n) ? String(n) : n.toFixed(4).replace(/0+$/, '').replace(/\.$/, ''); }

    function formatSetBuilder(v, intervals) {
        if (intervals.length === 0) return '\\emptyset';
        var intervalLatex = formatIntervalLatex(intervals);
        return '\\{' + v + ' \\in \\mathbb{R} \\mid ' + v + ' \\in ' + intervalLatex + '\\}';
    }

    // ========== Main Solve ==========
    solveBtn.addEventListener('click', doSolve);
    exprInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doSolve(); });
    document.addEventListener('keydown', function(e) { if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') doSolve(); });

    function doSolve() {
        var raw = exprInput.value.trim();
        var v = varSelect.value;
        if (!raw) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter an inequality.', 2000, 'warning'); return; }

        try {
            var parsed = parseInequality(raw);
            var solution = solveInequality(parsed, v);

            // Fix isEmpty/isAllReals for compound/union
            if (solution.intervals) {
                solution.isEmpty = solution.intervals.length === 0;
                solution.isAllReals = solution.intervals.length === 1 && solution.intervals[0].left === -Infinity && solution.intervals[0].right === Infinity;
            }

            lastSolveContext = { raw: raw, parsed: parsed, solution: solution, v: v };
            lastResultLatex = formatIntervalLatex(solution.intervals);
            lastResultText = formatInterval(solution.intervals);

            showResult(raw, parsed, solution, v);
            resultActions.classList.add('visible');

            // Prepare number line and graph data
            pendingNumberline = solution;
            pendingGraph = { solution: solution, expr: parsed.type === 'standard' ? parsed.expr : (parsed.parts ? parsed.parts[0].expr : '0'), v: v };

            // Auto-render if tabs already active
            if (document.getElementById('iq-panel-numberline').classList.contains('active')) { renderNumberLine(pendingNumberline); pendingNumberline = null; }
            if (document.getElementById('iq-panel-graph').classList.contains('active') && pendingGraph) { loadPlotly(function() { renderGraph(pendingGraph); }); pendingGraph = null; }
            if (numberlineHint) numberlineHint.style.display = 'none';
            if (graphHint) graphHint.style.display = 'none';
        } catch(err) {
            showError(raw, err.message);
        }
    }

    // ========== Display Result ==========
    function showResult(raw, parsed, solution, v) {
        var html = '<div class="iq-result-math">';
        html += '<div class="iq-result-label">Inequality</div>';
        html += '<div id="iq-r-original"></div>';
        html += '<div class="iq-result-label" style="margin-top:1rem;">Solution (Interval Notation)</div>';
        if (solution.isEmpty) {
            html += '<div class="iq-result-solution" style="background:#ef4444;">\u2205 &nbsp; No Solution</div>';
        } else if (solution.isAllReals) {
            html += '<div class="iq-result-solution">(-\u221E, \u221E) &nbsp; All Real Numbers</div>';
        } else {
            html += '<div class="iq-result-solution" id="iq-r-interval"></div>';
        }
        html += '<div class="iq-result-label" style="margin-top:0.75rem;">Set-Builder Notation</div>';
        html += '<div id="iq-r-setbuilder" style="font-size:1rem;padding:0.5rem 0;"></div>';

        // Sign chart table (only for standard or first part)
        var sc = solution.signChart || (solution.sol1 ? solution.sol1.signChart : []);
        if (sc.length > 0) {
            html += '<div class="iq-result-label" style="margin-top:1rem;">Sign Chart</div>';
            html += '<table class="iq-sign-chart"><thead><tr><th>Interval</th><th>Test Point</th><th>Sign</th><th>In Solution?</th></tr></thead><tbody>';
            for (var i = 0; i < sc.length; i++) {
                var iv = sc[i].interval;
                var ivStr = (iv.left === -Infinity ? '(-\u221E' : '(' + formatNum(iv.left)) + ', ' + (iv.right === Infinity ? '\u221E)' : formatNum(iv.right) + ')');
                var signClass = sc[i].sign === '+' ? 'positive' : sc[i].sign === '-' ? 'negative' : 'zero';
                var inSolClass = sc[i].inSolution ? ' in-solution' : '';
                html += '<tr><td>' + escapeHtml(ivStr) + '</td><td>' + formatNum(sc[i].testPoint) + '</td>';
                html += '<td class="' + signClass + '">' + sc[i].sign + '</td>';
                html += '<td class="' + signClass + inSolClass + '">' + (sc[i].inSolution ? '\u2713 Yes' : '\u2717 No') + '</td></tr>';
            }
            html += '</tbody></table>';
        }

        html += '<button type="button" class="iq-steps-btn" id="iq-steps-btn" onclick="showSteps()">\u{1F4DD} Show Steps</button>';
        html += '<div id="iq-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        // Render KaTeX
        try { katex.render(inequalityToLatex(raw), document.getElementById('iq-r-original'), { displayMode: true, throwOnError: false }); } catch(e) {}
        if (!solution.isEmpty && !solution.isAllReals) {
            try { katex.render(formatIntervalLatex(solution.intervals), document.getElementById('iq-r-interval'), { displayMode: true, throwOnError: false }); } catch(e) {}
        }
        try { katex.render(formatSetBuilder(v, solution.intervals), document.getElementById('iq-r-setbuilder'), { displayMode: true, throwOnError: false }); } catch(e) {}
    }

    // ========== Steps ==========
    window.showSteps = function() {
        if (!lastSolveContext) return;
        var ctx = lastSolveContext;
        var v = ctx.v, parsed = ctx.parsed, solution = ctx.solution, raw = ctx.raw;
        var area = document.getElementById('iq-steps-area');
        if (area.children.length > 0) { area.innerHTML = ''; return; }

        var steps = [];
        steps.push({ title: 'Write the inequality', latex: inequalityToLatex(raw) });

        var mainExpr = parsed.type === 'standard' ? parsed.expr : (parsed.parts ? parsed.parts[0].expr : raw);
        var mainOp = parsed.type === 'standard' ? parsed.op : (parsed.parts ? parsed.parts[0].op : '>');
        var opLatex = mainOp === '>=' ? '\\geq' : mainOp === '<=' ? '\\leq' : mainOp === '>' ? '>' : '<';
        steps.push({ title: 'Move all terms to one side', latex: exprToLatex(mainExpr) + ' ' + opLatex + ' 0' });

        // Try to factor
        try {
            var factored = nerdamer('factor(' + mainExpr + ')').toTeX();
            if (factored !== exprToLatex(mainExpr)) {
                steps.push({ title: 'Factor the expression', latex: factored + ' ' + opLatex + ' 0' });
            }
        } catch(e) {}

        // Critical points
        var cps = solution.criticalPoints || [];
        if (cps.length > 0) {
            var cpLatex = cps.map(function(cp) { return v + ' = ' + formatNum(cp); }).join(', \\quad ');
            steps.push({ title: 'Find critical points', latex: cpLatex });
        } else {
            steps.push({ title: 'Find critical points', latex: '\\text{No real critical points found}' });
        }

        steps.push({ title: 'Build sign chart and test intervals', latex: '\\text{Test a point from each interval to determine the sign of } f(' + v + ')' });

        // Solution
        steps.push({ title: 'Identify solution intervals', latex: '\\text{Solution: } ' + formatIntervalLatex(solution.intervals) });
        steps.push({ title: 'Write in interval notation', latex: formatIntervalLatex(solution.intervals) });

        var html = '<div class="iq-steps-container"><div class="iq-steps-header">\u{1F4DD} Step-by-Step Solution</div>';
        for (var i = 0; i < steps.length; i++) {
            html += '<div class="iq-step"><div class="iq-step-num">' + (i+1) + '</div><div class="iq-step-body">';
            html += '<div class="iq-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="iq-step-math" id="iq-step-math-' + i + '"></div></div></div>';
        }
        html += '</div>';
        area.innerHTML = html;
        for (var j = 0; j < steps.length; j++) {
            try { katex.render(steps[j].latex, document.getElementById('iq-step-math-' + j), { displayMode: true, throwOnError: false }); } catch(e) {}
        }
    };

    // ========== Error ==========
    function showError(expr, msg) {
        resultActions.classList.remove('visible');
        resultContent.innerHTML = '<div class="iq-error"><h4>Could Not Solve</h4><p>The inequality <strong>' + escapeHtml(expr) + '</strong> could not be solved.' + (msg ? ' (' + escapeHtml(msg) + ')' : '') + '</p><ul><li>Check syntax (see Syntax Help)</li><li>Use explicit multiplication: 2*x not 2x</li><li>Try a simpler form</li></ul></div>';
    }

    // ========== Number Line ==========
    function renderNumberLine(solution) {
        var container = document.getElementById('iq-numberline-container');
        var intervals = solution.intervals || [];
        var cps = solution.criticalPoints || [];

        // Determine range
        var min = -5, max = 5;
        if (cps.length > 0) { min = cps[0] - 2; max = cps[cps.length-1] + 2; }
        var range = max - min || 10;
        var W = 600, H = 100, pad = 50;
        var scale = function(v) { return pad + (v - min) / range * (W - 2*pad); };

        var svg = '<svg viewBox="0 0 ' + W + ' ' + H + '" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:600px;display:block;margin:0 auto;">';
        // Axis
        svg += '<line x1="' + pad + '" y1="50" x2="' + (W-pad) + '" y2="50" stroke="#94a3b8" stroke-width="1.5"/>';
        svg += '<polygon points="' + (W-pad+5) + ',50 ' + (W-pad-5) + ',44 ' + (W-pad-5) + ',56" fill="#94a3b8"/>';
        svg += '<polygon points="' + (pad-5) + ',50 ' + (pad+5) + ',44 ' + (pad+5) + ',56" fill="#94a3b8"/>';

        // Tick marks for critical points
        for (var i = 0; i < cps.length; i++) {
            var cx = scale(cps[i]);
            svg += '<line x1="' + cx + '" y1="42" x2="' + cx + '" y2="58" stroke="#94a3b8" stroke-width="1"/>';
            svg += '<text x="' + cx + '" y="75" font-size="12" fill="#059669" font-weight="600" text-anchor="middle">' + formatNum(cps[i]) + '</text>';
        }

        // Solution intervals (shading)
        for (var j = 0; j < intervals.length; j++) {
            var iv = intervals[j];
            var x1 = iv.left === -Infinity ? pad : scale(iv.left);
            var x2 = iv.right === Infinity ? (W-pad) : scale(iv.right);
            svg += '<line x1="' + x1 + '" y1="50" x2="' + x2 + '" y2="50" stroke="#059669" stroke-width="5" stroke-linecap="round"/>';
            // Arrows for infinity
            if (iv.left === -Infinity) svg += '<polygon points="' + (pad-3) + ',50 ' + (pad+7) + ',44 ' + (pad+7) + ',56" fill="#059669"/>';
            if (iv.right === Infinity) svg += '<polygon points="' + (W-pad+3) + ',50 ' + (W-pad-7) + ',44 ' + (W-pad-7) + ',56" fill="#059669"/>';
        }

        // Circles at critical points
        for (var k = 0; k < cps.length; k++) {
            var px = scale(cps[k]);
            var filled = isEndpointIncluded(cps[k], intervals);
            if (filled) {
                svg += '<circle cx="' + px + '" cy="50" r="5" fill="#059669" stroke="#059669" stroke-width="2"/>';
            } else {
                svg += '<circle cx="' + px + '" cy="50" r="5" fill="var(--bg-primary,#fff)" stroke="#059669" stroke-width="2.5"/>';
            }
        }

        svg += '</svg>';
        container.innerHTML = svg;
    }

    function isEndpointIncluded(val, intervals) {
        for (var i = 0; i < intervals.length; i++) {
            if (Math.abs(intervals[i].left - val) < 1e-10 && intervals[i].leftInclusive) return true;
            if (Math.abs(intervals[i].right - val) < 1e-10 && intervals[i].rightInclusive) return true;
        }
        return false;
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly) return;
        var expr = cfg.expr, v = cfg.v, solution = cfg.solution;
        var cps = solution.criticalPoints || [];
        var min = -5, max = 5;
        if (cps.length > 0) { min = cps[0] - 3; max = cps[cps.length-1] + 3; }

        var xs = [], ys = [];
        var step = (max - min) / 300;
        for (var x = min; x <= max; x += step) {
            xs.push(x);
            try {
                var obj = {}; obj[v] = x;
                var val = parseFloat(nerdamer(expr, obj).text('decimals'));
                ys.push(isFinite(val) ? val : null);
            } catch(e) { ys.push(null); }
        }

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var traces = [{
            x: xs, y: ys, type: 'scatter', mode: 'lines',
            line: { color: '#059669', width: 2.5 }, name: 'f(' + v + ')'
        }];

        // Highlight solution regions on x-axis
        var shapes = [];
        var intervals = solution.intervals || [];
        for (var i = 0; i < intervals.length; i++) {
            var iv = intervals[i];
            shapes.push({
                type: 'rect', xref: 'x', yref: 'paper',
                x0: iv.left === -Infinity ? min - 1 : iv.left,
                x1: iv.right === Infinity ? max + 1 : iv.right,
                y0: 0, y1: 1,
                fillcolor: 'rgba(5,150,105,0.1)', line: { width: 0 }
            });
        }

        // Critical point dots
        if (cps.length > 0) {
            var cpYs = [];
            for (var j = 0; j < cps.length; j++) {
                try {
                    var obj2 = {}; obj2[v] = cps[j];
                    cpYs.push(parseFloat(nerdamer(expr, obj2).text('decimals')));
                } catch(e) { cpYs.push(0); }
            }
            traces.push({
                x: cps, y: cpYs, type: 'scatter', mode: 'markers',
                marker: { color: '#059669', size: 8, line: { color: '#fff', width: 2 } }, name: 'Critical Points'
            });
        }

        // Zero line
        traces.push({
            x: [min, max], y: [0, 0], type: 'scatter', mode: 'lines',
            line: { color: '#94a3b8', width: 1, dash: 'dash' }, showlegend: false
        });

        var layout = {
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', color: isDark ? '#f1f5f9' : '#0f172a' },
            margin: { t: 20, r: 20, b: 40, l: 50 },
            xaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: '#94a3b8' },
            yaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: '#94a3b8' },
            shapes: shapes, showlegend: false
        };

        Plotly.newPlot('iq-graph-container', traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function loadCompilerWithTemplate() {
        var template = document.getElementById('iq-compiler-template').value;
        var raw = exprInput.value.trim() || 'x^2 - 4 >= 0';
        var v = varSelect.value;
        var parsed;
        try { parsed = parseInequality(raw); } catch(e) { parsed = { type: 'standard', expr: 'x**2 - 4', op: '>=' }; }
        var expr = (parsed.type === 'standard' ? parsed.expr : (parsed.parts ? parsed.parts[0].expr : 'x**2-4')).replace(/\^/g, '**');
        var opStr = parsed.type === 'standard' ? parsed.op : (parsed.parts ? parsed.parts[0].op : '>=');
        var pyOp = opStr === '>=' ? '>=' : opStr === '<=' ? '<=' : opStr === '>' ? '>' : '<';
        var code;
        if (template === 'sympy-solve') {
            code = 'from sympy import symbols, solve_univariate_inequality, S, oo\nfrom sympy.parsing.sympy_parser import parse_expr\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = parse_expr(\'' + expr.replace(/'/g, "\\'") + '\')\n\nresult = solve_univariate_inequality(expr ' + pyOp + ' 0, ' + v + ', relational=False)\nprint(f"Solution: {result}")';
        } else {
            code = 'from sympy import symbols, reduce_inequalities\n\n' + v + ' = symbols(\'' + v + '\')\n\nresult = reduce_inequalities([\'' + expr + ' ' + pyOp + ' 0\'], ' + v + ')\nprint(f"Solution: {result}")';
        }
        var b64 = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64 });
        document.getElementById('iq-compiler-iframe').src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }
    document.getElementById('iq-compiler-template').addEventListener('change', function() { loadCompilerWithTemplate(); });

    // ========== Actions ==========
    document.getElementById('iq-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        else navigator.clipboard.writeText(lastResultLatex);
    });
    document.getElementById('iq-copy-text-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') ToolUtils.copyToClipboard(lastResultText, 'Copied!');
        else navigator.clipboard.writeText(lastResultText);
    });
    document.getElementById('iq-share-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl({ expr: exprInput.value, 'var': varSelect.value }, { toolName: 'Inequality Solver' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });
    document.getElementById('iq-download-pdf-btn').addEventListener('click', function() {
        if (!lastSolveContext) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning'); return; }
        downloadResultPdf();
    });

    function downloadResultPdf() {
        var ctx = lastSolveContext;

        // Build off-screen container for capture
        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        // Title
        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#059669;';
        title.textContent = 'Inequality Solver \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#059669,#10b981,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        // Inequality
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = 'Inequality';
        container.appendChild(qLabel);

        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
        container.appendChild(qMath);
        try { katex.render(inequalityToLatex(ctx.raw), qMath, { displayMode: true, throwOnError: false }); } catch(e) { qMath.textContent = ctx.raw; }

        // Solution
        var aLabel = document.createElement('div');
        aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent = 'Solution (Interval Notation)';
        container.appendChild(aLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#ecfdf5;border-radius:8px;';
        container.appendChild(aMath);
        try { katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false }); } catch(e) { aMath.textContent = lastResultText; }

        // Plain text version
        var textDiv = document.createElement('div');
        textDiv.style.cssText = 'font-size:14px;color:#334155;margin-bottom:20px;font-family:monospace;';
        textDiv.textContent = lastResultText;
        container.appendChild(textDiv);

        // Include steps if rendered
        var stepsArea = document.getElementById('iq-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.iq-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#059669;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.iq-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.iq-step-math');
                if (mathEl) {
                    var sMath = document.createElement('div');
                    sMath.style.cssText = 'font-size:16px;';
                    var katexAnnotation = mathEl.querySelector('annotation');
                    if (katexAnnotation) {
                        katex.render(katexAnnotation.textContent, sMath, { displayMode: true, throwOnError: false });
                    } else {
                        sMath.innerHTML = mathEl.innerHTML;
                    }
                    stepBody.appendChild(sMath);
                }

                stepRow.appendChild(stepBody);
                container.appendChild(stepRow);
            }
        }

        // Footer
        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Inequality Solver</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        // Capture and generate PDF
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

        var loadHtml2Canvas = (typeof html2canvas !== 'undefined')
            ? Promise.resolve()
            : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');

        loadHtml2Canvas.then(function() {
            return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
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

            var filename = 'inequality-' + ctx.raw.replace(/[^a-zA-Z0-9]/g, '_').substring(0, 30) + '.pdf';
            pdf.save(filename);

            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed', 3000, 'error');
        });
    }

    // ========== Load from URL ==========
    (function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var expr = params.get('expr');
        var v = params.get('var');
        if (v) varSelect.value = v;
        if (expr) {
            exprInput.value = decodeURIComponent(expr);
            updatePreview();
            setTimeout(doSolve, 300);
        }
    })();

    })();
    </script>

<%-- ─── math-studio shell wiring (Phase 2) ───────────────────────────────
     The legacy IIFE above operates on #iq-expr / #iq-solve-btn / chips.
     This block adds the math-studio shell glue: image-scan AI button,
     auto-solve on empty-state chip click, and a busy-lock on the CTA.
     Lives in the same partial so the load order (math-libs → this →
     math-input-setup) is preserved. --%>
<script>
(function () {
    'use strict';

    // ── Auto-solve on empty-state chip click ─────────────────────────────
    // Chips have data-expr (matching the legacy partial's chip handler
    // contract). We capture clicks at document level, write the value
    // into #ic-expr (math-input-setup's hooked setter seeds MathLive),
    // and trigger #iq-solve-btn so the partial's solver runs.
    var icExpr = document.getElementById('ic-expr');
    var solveBtn = document.getElementById('iq-solve-btn');
    if (!icExpr || !solveBtn) return;

    document.addEventListener('click', function (e) {
        if (!e.target || !e.target.closest) return;
        var chip = e.target.closest('.ic-example-chip');
        if (!chip) return;
        var expr = chip.getAttribute('data-expr');
        if (!expr) return;
        // Write to #ic-expr — the hooked setter from math-input-setup
        // seeds the visible <math-field>. Then dispatch input so the
        // legacy partial's preview + state pick it up.
        icExpr.value = expr;
        icExpr.dispatchEvent(new Event('input', { bubbles: true }));
        // Auto-solve after MathLive settles.
        setTimeout(function () { solveBtn.click(); }, 120);
    }, true);

    // ── CTA enable-state ─────────────────────────────────────────────────
    function updateEnableState() {
        var ready = !!(icExpr.value || '').trim();
        solveBtn.classList.toggle('is-disabled', !ready);
        solveBtn.setAttribute('aria-disabled', ready ? 'false' : 'true');
    }
    icExpr.addEventListener('input', updateEnableState);
    updateEnableState();

    // ── Busy-lock + auto-scroll while solving ────────────────────────────
    var resultContent = document.getElementById('iq-result-content');
    var scrollTarget = document.getElementById('iq-panel-result');
    var safetyTimer = null, observer = null;
    function unlock() {
        solveBtn.classList.remove('is-busy');
        if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
        if (observer) { observer.disconnect(); observer = null; }
    }
    function lock() {
        if (solveBtn.classList.contains('is-busy')) return false;
        solveBtn.classList.add('is-busy');
        if ('MutationObserver' in window && resultContent) {
            observer = new MutationObserver(unlock);
            observer.observe(resultContent, { childList: true, subtree: true, characterData: true });
        }
        safetyTimer = setTimeout(unlock, 30000);
        return true;
    }
    solveBtn.addEventListener('click', function () {
        if (!(icExpr.value || '').trim()) return;
        lock();
        if (scrollTarget && scrollTarget.scrollIntoView) {
            setTimeout(function () { scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'start' }); }, 140);
        }
    });

    // ── FAQ accordion (math-studio shell convention) ─────────────────────
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });

    // ── Clear button: reset MathLive + inputs + restore empty state ──────
    var clearBtn = document.getElementById('iq-clear-btn');
    if (clearBtn) {
        clearBtn.addEventListener('click', function () {
            var mf = document.getElementById('ic-mathfield');
            if (mf && typeof mf.setValue === 'function') {
                try { mf.setValue(''); } catch (e) {}
            }
            icExpr.value = '';
            icExpr.dispatchEvent(new Event('input', { bubbles: true }));

            // Hide the result-actions toolbar (legacy partial added .visible)
            var actions = document.getElementById('iq-result-actions');
            if (actions) actions.classList.remove('visible');

            // Restore the empty-state node inside the result panel.
            var resultContent = document.getElementById('iq-result-content');
            var emptyState = document.getElementById('iq-empty-state');
            if (resultContent && emptyState && !resultContent.contains(emptyState)) {
                resultContent.innerHTML = '';
                resultContent.appendChild(emptyState);
            }

            // Reset hint visibility on number-line and graph panels.
            var nlHint = document.getElementById('iq-numberline-hint');
            var gHint  = document.getElementById('iq-graph-hint');
            if (nlHint) nlHint.style.display = '';
            if (gHint)  gHint.style.display = '';
            var nlContainer = document.getElementById('iq-numberline-container');
            var gContainer  = document.getElementById('iq-graph-container');
            if (nlContainer) nlContainer.innerHTML = '';
            if (gContainer)  gContainer.innerHTML = '';

            updateEnableState();
            try { mf && mf.focus(); } catch (e) {}
        });
    }
})();
</script>

<%-- ─── Image-to-math scanner — inequality-specific extraction prompt ─── --%>
<script>
(function () {
    if (typeof ImageToMath === 'undefined') return;
    var CTX = '<%=request.getContextPath()%>';
    ImageToMath.init({
        buttonId: 'iq-image-btn',
        aiUrl: CTX + '/ai',
        toolName: 'Inequality Solver',
        extractionPrompt:
            'You are a math problem extractor for an inequality solver.\n' +
            'Given OCR text from a math image, extract ALL inequality problems.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "expr": the inequality as plain ASCII text the solver accepts\n' +
            '  - "display": the same inequality in LaTeX for preview\n\n' +
            'Format rules for "expr":\n' +
            '  - Use < > <= >= for the comparison operators (NOT ≤ ≥)\n' +
            '  - Use ^ for powers: x^2, x^3\n' +
            '  - Use | | for absolute value: |x - 3| < 5 (or abs(x-3))\n' +
            '  - Compound forms: 2 < x + 1 < 8 are supported\n' +
            '  - Rational forms: (x+1)/(x-2) > 0 are supported\n\n' +
            'Return ONLY valid JSON array, no markdown fences.\n' +
            'If no problems found, return [].\n\n' +
            'Examples:\n' +
            'Input: "Solve x squared minus 5x plus 6 less than 0"\n' +
            'Output: [{"expr":"x^2 - 5x + 6 < 0","display":"x^{2}-5x+6<0"}]\n' +
            'Input: "|x − 3| ≤ 5"\n' +
            'Output: [{"expr":"|x-3| <= 5","display":"|x-3| \\\\leq 5"}]',
        onSelect: function (problem) {
            if (!problem) return;
            var expr = problem.expr || '';
            if (!expr) return;
            var ic = document.getElementById('ic-expr');
            if (ic) {
                ic.value = expr;
                ic.dispatchEvent(new Event('input', { bubbles: true }));
            }
            setTimeout(function () {
                var sb = document.getElementById('iq-solve-btn');
                if (sb && !sb.classList.contains('is-disabled')) sb.click();
            }, 350);
        }
    });

    /** Headless solve for Algebra AI — same parse + sign-chart engine as page Solve. */
    window.InequalitySolverCore = {
        solveFromRaw: function (raw, varName, opts) {
            opts = opts || {};
            var v = varName || 'x';
            if (!raw || !String(raw).trim()) {
                return { ok: false, error: 'Missing inequality.' };
            }
            try {
                var parsed = parseInequality(String(raw).trim());
                var solution = solveInequality(parsed, v);
                if (solution.intervals) {
                    solution.isEmpty = solution.intervals.length === 0;
                    solution.isAllReals = solution.intervals.length === 1
                        && solution.intervals[0].left === -Infinity
                        && solution.intervals[0].right === Infinity;
                }
                var resultLatex = formatIntervalLatex(solution.intervals);
                var resultText = formatInterval(solution.intervals);
                var steps = [];
                if (opts.withSteps) {
                    steps.push({ title: 'Write the inequality', latex: inequalityToLatex(String(raw).trim()) });
                    var mainExpr = parsed.type === 'standard' ? parsed.expr
                        : (parsed.parts ? parsed.parts[0].expr : String(raw).trim());
                    var mainOp = parsed.type === 'standard' ? parsed.op
                        : (parsed.parts ? parsed.parts[0].op : '>');
                    var opLatex = mainOp === '>=' ? '\\geq' : mainOp === '<=' ? '\\leq' : mainOp;
                    steps.push({ title: 'Solution set', latex: resultLatex });
                }
                return {
                    ok: true,
                    action: 'inequality',
                    resultText: resultText,
                    resultLatex: resultLatex,
                    method: 'Sign-chart inequality solver (page engine)',
                    steps: steps,
                    input: { raw: String(raw).trim(), variable: v },
                };
            } catch (err) {
                return { ok: false, error: err.message || 'Could not solve inequality.' };
            }
        },
    };
})();
</script>
