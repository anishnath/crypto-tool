/**
 * Diophantine Equation Solver
 * Linear (ax+by=c), System, Quadratic (sums of squares, Pell), Modular congruences
 * Step-by-step extended Euclidean algorithm, Bezout identity, CRT
 * Export: Copy LaTeX, PDF, Share
 */
(function() {
    'use strict';

    // ===== DOM References =====
    var linearA = document.getElementById('dio-linear-a');
    var linearB = document.getElementById('dio-linear-b');
    var linearC = document.getElementById('dio-linear-c');
    var sysA1 = document.getElementById('dio-sys-a1');
    var sysB1 = document.getElementById('dio-sys-b1');
    var sysC1 = document.getElementById('dio-sys-c1');
    var sysA2 = document.getElementById('dio-sys-a2');
    var sysB2 = document.getElementById('dio-sys-b2');
    var sysC2 = document.getElementById('dio-sys-c2');
    var quadType = document.getElementById('dio-quad-type');
    var quadN = document.getElementById('dio-quad-n');
    var quadD = document.getElementById('dio-quad-D');
    var quadPellCount = document.getElementById('dio-quad-pell-count');
    var quadGA = document.getElementById('dio-quad-ga');
    var quadGB = document.getElementById('dio-quad-gb');
    var quadGC = document.getElementById('dio-quad-gc');
    var quadGN = document.getElementById('dio-quad-gn');
    var modType = document.getElementById('dio-mod-type');
    var modA = document.getElementById('dio-mod-a');
    var modB = document.getElementById('dio-mod-b');
    var modM = document.getElementById('dio-mod-m');
    var modRemainders = document.getElementById('dio-mod-remainders');
    var modModuli = document.getElementById('dio-mod-moduli');
    var previewEl = document.getElementById('dio-preview');
    var computeBtn = document.getElementById('dio-compute-btn');
    var resultContent = document.getElementById('dio-result-content');
    var emptyState = document.getElementById('dio-empty-state');
    var graphHint = document.getElementById('dio-graph-hint');
    var exportRow = document.getElementById('dio-export-row');

    var currentMode = 'linear';
    var isComputing = false;
    var pendingGraph = null;
    var compilerLoaded = false;
    var lastResultLatex = '';
    var lastResultText = '';
    var lastStepsData = null;

    // ===== Utility =====
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(String(str)));
        return div.innerHTML;
    }

    function parseNum(val, def) {
        var n = parseInt(String(val).trim(), 10);
        return isNaN(n) ? def : n;
    }

    // ===== Mode Toggle =====
    var allWraps = {
        linear: document.getElementById('dio-linear-wrap'),
        system: document.getElementById('dio-system-wrap'),
        quadratic: document.getElementById('dio-quadratic-wrap'),
        modular: document.getElementById('dio-modular-wrap')
    };

    document.querySelectorAll('.dio-mode-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            document.querySelectorAll('.dio-mode-btn').forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            Object.keys(allWraps).forEach(function(k) {
                if (allWraps[k]) allWraps[k].style.display = k === mode ? '' : 'none';
            });
            updatePreview();
            updateExamples();
        });
    });

    // ===== Quadratic sub-type toggle =====
    var quadSumWrap = document.getElementById('dio-quad-sum-wrap');
    var quadPellWrap = document.getElementById('dio-quad-pell-wrap');
    var quadGeneralWrap = document.getElementById('dio-quad-general-wrap');

    if (quadType) {
        quadType.addEventListener('change', function() {
            var t = this.value;
            if (quadSumWrap) quadSumWrap.style.display = t === 'sum_squares' ? '' : 'none';
            if (quadPellWrap) quadPellWrap.style.display = t === 'pell' ? '' : 'none';
            if (quadGeneralWrap) quadGeneralWrap.style.display = t === 'general' ? '' : 'none';
            updatePreview();
        });
    }

    // ===== Modular sub-type toggle =====
    var modSingleWrap = document.getElementById('dio-mod-single-wrap');
    var modSystemWrap = document.getElementById('dio-mod-system-wrap');

    if (modType) {
        modType.addEventListener('change', function() {
            var t = this.value;
            if (modSingleWrap) modSingleWrap.style.display = t === 'single' ? '' : 'none';
            if (modSystemWrap) modSystemWrap.style.display = t === 'system' ? '' : 'none';
            updatePreview();
        });
    }

    // ===== Preview =====
    function updatePreview() {
        if (!previewEl) return;
        var latex = '';
        if (currentMode === 'linear') {
            var a = parseNum(linearA.value, 6);
            var b = parseNum(linearB.value, 9);
            var c = parseNum(linearC.value, 15);
            latex = a + 'x + ' + b + 'y = ' + c;
        } else if (currentMode === 'system') {
            var a1 = parseNum(sysA1.value, 2);
            var b1 = parseNum(sysB1.value, 3);
            var c1 = parseNum(sysC1.value, 7);
            var a2 = parseNum(sysA2.value, 4);
            var b2 = parseNum(sysB2.value, 5);
            var c2 = parseNum(sysC2.value, 11);
            latex = '\\begin{cases} ' + a1 + 'x + ' + b1 + 'y = ' + c1 + ' \\\\ ' + a2 + 'x + ' + b2 + 'y = ' + c2 + ' \\end{cases}';
        } else if (currentMode === 'quadratic') {
            var qt = quadType ? quadType.value : 'sum_squares';
            if (qt === 'sum_squares') {
                var n = parseNum(quadN.value, 50);
                latex = 'x^2 + y^2 = ' + n;
            } else if (qt === 'pell') {
                var D = parseNum(quadD.value, 2);
                latex = 'x^2 - ' + D + 'y^2 = 1';
            } else {
                var ga = parseNum(quadGA.value, 1);
                var gb = parseNum(quadGB.value, 0);
                var gc = parseNum(quadGC.value, 1);
                var gn = parseNum(quadGN.value, 25);
                latex = ga + 'x^2';
                if (gb !== 0) latex += ' + ' + gb + 'xy';
                latex += ' + ' + gc + 'y^2 = ' + gn;
            }
        } else if (currentMode === 'modular') {
            var mt = modType ? modType.value : 'single';
            if (mt === 'single') {
                var ma = parseNum(modA.value, 7);
                var mb = parseNum(modB.value, 3);
                var mm = parseNum(modM.value, 15);
                latex = ma + 'x \\equiv ' + mb + ' \\pmod{' + mm + '}';
            } else {
                latex = 'x \\equiv a_i \\pmod{m_i} \\quad \\text{(CRT)}';
            }
        }
        try {
            if (typeof katex !== 'undefined') {
                katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
            } else {
                previewEl.textContent = latex;
            }
        } catch(e) { previewEl.textContent = latex; }
    }

    // Live preview on input
    var allInputs = document.querySelectorAll('#dio-linear-wrap input, #dio-system-wrap input, #dio-quadratic-wrap input, #dio-modular-wrap input');
    allInputs.forEach(function(inp) {
        inp.addEventListener('input', updatePreview);
    });

    // ===== Code Generators =====

    function buildLinearCode() {
        var a = parseNum(linearA.value, 6);
        var b = parseNum(linearB.value, 9);
        var c = parseNum(linearC.value, 15);
        return [
            'from sympy import igcd, diophantine, symbols, Eq',
            'import json',
            'a, b, c = ' + a + ', ' + b + ', ' + c,
            'd = igcd(abs(a), abs(b))',
            'print("META_GCD:" + str(d))',
            'print("META_METHOD:Extended Euclidean Algorithm")',
            '',
            '# Check solvability',
            'if a == 0 and b == 0:',
            '    if c == 0:',
            '        print("RESULT:Trivially true (0=0), all integers are solutions")',
            '        print("TEXT:0x + 0y = 0")',
            '        print("META_SOLVABLE:True")',
            '        print("STEP1_TITLE:Trivial case")',
            '        print("STEP1_LATEX:0 = 0 \\\\text{ is always true}")',
            '    else:',
            '        print("RESULT:No solution (0 \\\\neq " + str(c) + ")")',
            '        print("TEXT:0x + 0y = " + str(c))',
            '        print("META_SOLVABLE:False")',
            '        print("STEP1_TITLE:No solution")',
            '        print("STEP1_LATEX:0 \\\\neq " + str(c))',
            'elif c % d != 0:',
            '    print("RESULT:No integer solution exists")',
            '    print("TEXT:" + str(a) + "x + " + str(b) + "y = " + str(c))',
            '    print("META_SOLVABLE:False")',
            '    print("STEP1_TITLE:Check solvability")',
            '    print("STEP1_LATEX:\\\\gcd(" + str(a) + ", " + str(b) + ") = " + str(d) + " \\\\nmid " + str(c) + " \\\\implies \\\\text{no solution}")',
            'else:',
            '    # Extended Euclidean Algorithm',
            '    def ext_gcd(a, b):',
            '        if b == 0: return a, 1, 0',
            '        g, x1, y1 = ext_gcd(b, a % b)',
            '        return g, y1, x1 - (a // b) * y1',
            '    g, x0, y0 = ext_gcd(a, b)',
            '    # Scale to solution of ax + by = c',
            '    scale = c // d',
            '    x0 *= scale',
            '    y0 *= scale',
            '    # Verify',
            '    assert a * x0 + b * y0 == c',
            '    b_d = b // d',
            '    a_d = a // d',
            '    print("RESULT:" + str(a) + "x + " + str(b) + "y = " + str(c) + " solved")',
            '    print("TEXT:x = " + str(x0) + " + " + str(b_d) + "t, \\\\; y = " + str(y0) + " - " + str(a_d) + "t")',
            '    print("RESULT_LATEX:x = " + str(x0) + " + " + str(b_d) + "t, \\\\quad y = " + str(y0) + " - " + str(a_d) + "t, \\\\quad t \\\\in \\\\mathbb{Z}")',
            '    print("META_SOLVABLE:True")',
            '    print("META_X0:" + str(x0))',
            '    print("META_Y0:" + str(y0))',
            '    print("VERIFIED:True")',
            '    print("STEP1_TITLE:Check solvability")',
            '    print("STEP1_LATEX:\\\\gcd(" + str(a) + ", " + str(b) + ") = " + str(d) + " \\\\mid " + str(c) + " \\\\implies \\\\text{solution exists}")',
            '    print("STEP2_TITLE:Extended Euclidean Algorithm")',
            '    # Show EEA steps',
            '    aa, bb = abs(a), abs(b)',
            '    steps = []',
            '    while bb > 0:',
            '        q = aa // bb',
            '        steps.append(str(aa) + " = " + str(q) + " \\\\cdot " + str(bb) + " + " + str(aa % bb))',
            '        aa, bb = bb, aa % bb',
            '    print("STEP2_LATEX:" + " \\\\\\\\\\n".join(steps))',
            '    print("STEP3_TITLE:Bezout coefficients")',
            '    g2, bx, by = ext_gcd(a, b)',
            '    print("STEP3_LATEX:" + str(a) + "(" + str(bx) + ") + " + str(b) + "(" + str(by) + ") = " + str(d) + " \\\\quad \\\\text{(Bezout identity)}")',
            '    print("STEP4_TITLE:Particular solution")',
            '    print("STEP4_LATEX:x_0 = " + str(x0) + ", \\\\quad y_0 = " + str(y0) + " \\\\quad \\\\text{(verify: }" + str(a) + " \\\\cdot " + str(x0) + " + " + str(b) + " \\\\cdot " + str(y0) + " = " + str(a*x0 + b*y0) + "\\\\text{)}")',
            '    print("STEP5_TITLE:General solution")',
            '    print("STEP5_LATEX:x = " + str(x0) + " + " + str(b_d) + "t, \\\\quad y = " + str(y0) + " - " + str(a_d) + "t, \\\\quad t \\\\in \\\\mathbb{Z}")',
            '    # Generate plot points',
            '    pts_x = [x0 + b_d * t for t in range(-10, 11)]',
            '    pts_y = [y0 - a_d * t for t in range(-10, 11)]',
            '    print("PLOT_X:" + json.dumps(pts_x))',
            '    print("PLOT_Y:" + json.dumps(pts_y))'
        ].join('\n');
    }

    function buildSystemCode() {
        var a1 = parseNum(sysA1.value, 2);
        var b1 = parseNum(sysB1.value, 3);
        var c1 = parseNum(sysC1.value, 7);
        var a2 = parseNum(sysA2.value, 4);
        var b2 = parseNum(sysB2.value, 5);
        var c2 = parseNum(sysC2.value, 11);
        return [
            'from sympy import symbols, Eq, solve, igcd, latex',
            'import json',
            'a1, b1, c1 = ' + a1 + ', ' + b1 + ', ' + c1,
            'a2, b2, c2 = ' + a2 + ', ' + b2 + ', ' + c2,
            'print("META_METHOD:Cramer / SymPy Integer Solve")',
            '',
            'det = a1 * b2 - a2 * b1',
            'print("STEP1_TITLE:System of equations")',
            'print("STEP1_LATEX:\\\\begin{cases} " + str(a1) + "x + " + str(b1) + "y = " + str(c1) + " \\\\\\\\\\\\\\\\ " + str(a2) + "x + " + str(b2) + "y = " + str(c2) + " \\\\end{cases}")',
            'print("STEP2_TITLE:Compute determinant")',
            'print("STEP2_LATEX:\\\\Delta = a_1 b_2 - a_2 b_1 = " + str(a1) + "\\\\cdot" + str(b2) + " - " + str(a2) + "\\\\cdot" + str(b1) + " = " + str(det))',
            '',
            'if det == 0:',
            '    # Singular: check consistency',
            '    if a1 * c2 == a2 * c1 and b1 * c2 == b2 * c1:',
            '        print("RESULT:Infinitely many solutions (equations are dependent)")',
            '        print("TEXT:Dependent system, reduces to single equation")',
            '        print("META_SOLVABLE:Infinite")',
            '        print("STEP3_TITLE:Dependent system")',
            '        print("STEP3_LATEX:\\\\Delta = 0 \\\\text{ and equations are proportional} \\\\implies \\\\text{infinitely many solutions}")',
            '    else:',
            '        print("RESULT:No integer solution (inconsistent system)")',
            '        print("TEXT:Inconsistent system")',
            '        print("META_SOLVABLE:False")',
            '        print("STEP3_TITLE:Inconsistent")',
            '        print("STEP3_LATEX:\\\\Delta = 0 \\\\text{ but equations are not proportional} \\\\implies \\\\text{no solution}")',
            'else:',
            '    det_x = c1 * b2 - c2 * b1',
            '    det_y = a1 * c2 - a2 * c1',
            '    print("STEP3_TITLE:Cramer\'s rule")',
            '    print("STEP3_LATEX:\\\\Delta_x = " + str(c1) + "\\\\cdot" + str(b2) + " - " + str(c2) + "\\\\cdot" + str(b1) + " = " + str(det_x) + ", \\\\quad \\\\Delta_y = " + str(a1) + "\\\\cdot" + str(c2) + " - " + str(a2) + "\\\\cdot" + str(c1) + " = " + str(det_y))',
            '    if det_x % det == 0 and det_y % det == 0:',
            '        x_sol = det_x // det',
            '        y_sol = det_y // det',
            '        print("RESULT:x = " + str(x_sol) + ", y = " + str(y_sol))',
            '        print("TEXT:x = " + str(x_sol) + ", y = " + str(y_sol))',
            '        print("RESULT_LATEX:x = " + str(x_sol) + ", \\\\quad y = " + str(y_sol))',
            '        print("META_SOLVABLE:True")',
            '        print("VERIFIED:True")',
            '        print("STEP4_TITLE:Integer solution")',
            '        print("STEP4_LATEX:x = \\\\frac{\\\\Delta_x}{\\\\Delta} = \\\\frac{" + str(det_x) + "}{" + str(det) + "} = " + str(x_sol) + ", \\\\quad y = \\\\frac{\\\\Delta_y}{\\\\Delta} = \\\\frac{" + str(det_y) + "}{" + str(det) + "} = " + str(y_sol))',
            '        print("STEP5_TITLE:Verification")',
            '        v1 = a1 * x_sol + b1 * y_sol',
            '        v2 = a2 * x_sol + b2 * y_sol',
            '        print("STEP5_LATEX:" + str(a1) + "(" + str(x_sol) + ") + " + str(b1) + "(" + str(y_sol) + ") = " + str(v1) + " = " + str(c1) + " \\\\; \\\\checkmark \\\\\\\\\\n" + str(a2) + "(" + str(x_sol) + ") + " + str(b2) + "(" + str(y_sol) + ") = " + str(v2) + " = " + str(c2) + " \\\\; \\\\checkmark")',
            '        print("PLOT_X:" + json.dumps([x_sol]))',
            '        print("PLOT_Y:" + json.dumps([y_sol]))',
            '    else:',
            '        print("RESULT:No integer solution (det does not divide)")',
            '        print("TEXT:Delta_x/Delta or Delta_y/Delta not integer")',
            '        print("META_SOLVABLE:False")',
            '        print("STEP4_TITLE:No integer solution")',
            '        print("STEP4_LATEX:\\\\frac{" + str(det_x) + "}{" + str(det) + "} \\\\text{ or } \\\\frac{" + str(det_y) + "}{" + str(det) + "} \\\\notin \\\\mathbb{Z}")'
        ].join('\n');
    }

    function buildQuadraticCode() {
        var qt = quadType ? quadType.value : 'sum_squares';
        if (qt === 'sum_squares') {
            var n = parseNum(quadN.value, 50);
            return [
                'import json, math',
                'n = ' + n,
                'print("META_METHOD:Brute-force search")',
                'print("STEP1_TITLE:Given equation")',
                'print("STEP1_LATEX:x^2 + y^2 = " + str(n))',
                '',
                'if n < 0:',
                '    print("RESULT:No solution (n < 0)")',
                '    print("TEXT:x^2 + y^2 = " + str(n))',
                '    print("META_SOLVABLE:False")',
                '    print("STEP2_TITLE:No solution")',
                '    print("STEP2_LATEX:x^2 + y^2 \\\\geq 0 > " + str(n))',
                'else:',
                '    solutions = []',
                '    limit = int(math.isqrt(n)) + 1',
                '    for x in range(0, limit):',
                '        rem = n - x * x',
                '        if rem < 0: break',
                '        y = int(math.isqrt(rem))',
                '        if y * y == rem:',
                '            solutions.append((x, y))',
                '            if y != 0 and x != y:',
                '                solutions.append((y, x))',
                '    # Include negatives and sort',
                '    all_sols = set()',
                '    for x, y in solutions:',
                '        for sx in [1, -1]:',
                '            for sy in [1, -1]:',
                '                all_sols.add((sx*x, sy*y))',
                '    all_sols = sorted(all_sols)',
                '    if len(all_sols) == 0:',
                '        print("RESULT:No representation as sum of two squares")',
                '        print("TEXT:x^2 + y^2 = " + str(n))',
                '        print("META_SOLVABLE:False")',
                '        print("STEP2_TITLE:Search complete")',
                '        print("STEP2_LATEX:\\\\text{No integers } x, y \\\\text{ with } x^2 + y^2 = " + str(n))',
                '    else:',
                '        nonneg = [(x,y) for x,y in all_sols if x >= 0 and y >= 0]',
                '        sol_str = ", ".join(["(" + str(x) + "," + str(y) + ")" for x,y in nonneg[:10]])',
                '        print("RESULT:" + str(len(all_sols)) + " solutions found")',
                '        print("TEXT:" + sol_str)',
                '        latex_sols = ", ".join(["(" + str(x) + "," + str(y) + ")" for x,y in nonneg[:10]])',
                '        print("RESULT_LATEX:" + latex_sols + (" \\\\; \\\\ldots" if len(nonneg)>10 else ""))',
                '        print("META_SOLVABLE:True")',
                '        print("META_COUNT:" + str(len(all_sols)))',
                '        print("VERIFIED:True")',
                '        print("STEP2_TITLE:Non-negative solutions")',
                '        print("STEP2_LATEX:" + latex_sols)',
                '        print("STEP3_TITLE:Total with signs")',
                '        print("STEP3_LATEX:\\\\text{" + str(len(all_sols)) + " total solutions (including } \\\\pm x, \\\\pm y \\\\text{)}")',
                '        px = [p[0] for p in all_sols]',
                '        py = [p[1] for p in all_sols]',
                '        print("PLOT_X:" + json.dumps(px))',
                '        print("PLOT_Y:" + json.dumps(py))'
            ].join('\n');
        } else if (qt === 'pell') {
            var D = parseNum(quadD.value, 2);
            var count = parseInt(quadPellCount ? quadPellCount.value : '8', 10) || 8;
            count = Math.max(1, Math.min(20, count));
            return [
                'from sympy import sqrt, integer_nthroot, continued_fraction_periodic, continued_fraction_convergents, Rational',
                'import json, math',
                'D = ' + D,
                'n_sol = ' + count,
                'print("META_METHOD:Continued fractions")',
                'print("STEP1_TITLE:Given equation")',
                'print("STEP1_LATEX:x^2 - " + str(D) + "y^2 = 1 \\\\quad \\\\text{(Pell equation)}")',
                '',
                '# Check D is not a perfect square',
                'sr = int(math.isqrt(D))',
                'if sr * sr == D:',
                '    print("RESULT:D=" + str(D) + " is a perfect square, no non-trivial solution")',
                '    print("TEXT:D must not be a perfect square")',
                '    print("META_SOLVABLE:False")',
                '    print("STEP2_TITLE:Invalid D")',
                '    print("STEP2_LATEX:D = " + str(D) + " = " + str(sr) + "^2 \\\\text{ is a perfect square}")',
                'elif D <= 0:',
                '    print("RESULT:D must be a positive non-square integer")',
                '    print("TEXT:Invalid D")',
                '    print("META_SOLVABLE:False")',
                'else:',
                '    # Find fundamental solution via continued fraction',
                '    cf = continued_fraction_periodic(0, 1, D)',
                '    # cf = [a0, [a1, a2, ..., a_period]]',
                '    a0 = cf[0]',
                '    periodic = cf[1] if len(cf) > 1 else []',
                '    period = len(periodic)',
                '    print("STEP2_TITLE:Continued fraction of sqrt(" + str(D) + ")")',
                '    cf_str = "[" + str(a0) + "; \\\\overline{" + ", ".join(str(x) for x in periodic) + "}]" if periodic else str(a0)',
                '    print("STEP2_LATEX:\\\\sqrt{" + str(D) + "} = " + cf_str + ", \\\\quad \\\\text{period} = " + str(period))',
                '    # Get convergents',
                '    from sympy import S',
                '    full_cf = [a0] + list(periodic)',
                '    # Build convergents until we find fundamental solution',
                '    h_prev, h_curr = 0, 1',
                '    k_prev, k_curr = 1, 0',
                '    x1, y1 = None, None',
                '    idx = 0',
                '    max_iter = 200',
                '    while idx < max_iter:',
                '        if idx == 0:',
                '            ai = a0',
                '        else:',
                '            ai = periodic[(idx - 1) % period]',
                '        h_prev, h_curr = h_curr, ai * h_curr + h_prev',
                '        k_prev, k_curr = k_curr, ai * k_curr + k_prev',
                '        if h_curr * h_curr - D * k_curr * k_curr == 1:',
                '            x1, y1 = h_curr, k_curr',
                '            break',
                '        idx += 1',
                '    if x1 is None:',
                '        print("RESULT:Could not find fundamental solution")',
                '        print("META_SOLVABLE:False")',
                '    else:',
                '        solutions = [(x1, y1)]',
                '        xn, yn = x1, y1',
                '        for _ in range(n_sol - 1):',
                '            xn, yn = x1 * xn + D * y1 * yn, x1 * yn + y1 * xn',
                '            solutions.append((xn, yn))',
                '        sol_str = ", ".join(["(" + str(x) + "," + str(y) + ")" for x,y in solutions[:6]])',
                '        print("RESULT:" + str(len(solutions)) + " solutions generated")',
                '        print("TEXT:" + sol_str)',
                '        latex_list = " \\\\\\\\\\\n".join(["(" + str(x) + ", " + str(y) + ")" for x,y in solutions])',
                '        print("RESULT_LATEX:" + latex_list)',
                '        print("META_SOLVABLE:True")',
                '        print("META_FUNDAMENTAL:(" + str(x1) + ", " + str(y1) + ")")',
                '        print("VERIFIED:True")',
                '        print("STEP3_TITLE:Fundamental solution")',
                '        print("STEP3_LATEX:(x_1, y_1) = (" + str(x1) + ", " + str(y1) + ") \\\\quad \\\\text{verify: }" + str(x1) + "^2 - " + str(D) + " \\\\cdot " + str(y1) + "^2 = " + str(x1**2 - D*y1**2))',
                '        print("STEP4_TITLE:Recurrence")',
                '        print("STEP4_LATEX:x_{n+1} = x_1 x_n + D y_1 y_n, \\\\quad y_{n+1} = x_1 y_n + y_1 x_n")',
                '        print("STEP5_TITLE:Solution sequence")',
                '        seq_latex = " \\\\\\\\\\\n".join(["(x_{" + str(i+1) + "}, y_{" + str(i+1) + "}) = (" + str(solutions[i][0]) + ", " + str(solutions[i][1]) + ")" for i in range(min(8, len(solutions)))])',
                '        print("STEP5_LATEX:" + seq_latex)',
                '        px = [p[0] for p in solutions]',
                '        py = [p[1] for p in solutions]',
                '        print("PLOT_X:" + json.dumps(px))',
                '        print("PLOT_Y:" + json.dumps(py))'
            ].join('\n');
        } else {
            // general quadratic
            var ga = parseNum(quadGA.value, 1);
            var gb = parseNum(quadGB.value, 0);
            var gc = parseNum(quadGC.value, 1);
            var gn = parseNum(quadGN.value, 25);
            return [
                'import json, math',
                'a, b, c, n = ' + ga + ', ' + gb + ', ' + gc + ', ' + gn,
                'print("META_METHOD:Brute-force search")',
                'print("STEP1_TITLE:Given equation")',
                'print("STEP1_LATEX:" + str(a) + "x^2 + " + str(b) + "xy + " + str(c) + "y^2 = " + str(n))',
                'disc = b*b - 4*a*c',
                'print("STEP2_TITLE:Discriminant")',
                'print("STEP2_LATEX:\\\\Delta = b^2 - 4ac = " + str(b) + "^2 - 4(" + str(a) + ")(" + str(c) + ") = " + str(disc))',
                '',
                'solutions = set()',
                'limit = int(math.isqrt(abs(n) * 4 + 1)) + 2 if n != 0 else 50',
                'limit = min(limit, 500)',
                'for x in range(-limit, limit + 1):',
                '    for y in range(-limit, limit + 1):',
                '        if a*x*x + b*x*y + c*y*y == n:',
                '            solutions.add((x, y))',
                '    if len(solutions) > 200: break',
                'solutions = sorted(solutions)',
                'if len(solutions) == 0:',
                '    print("RESULT:No integer solutions found in range")',
                '    print("TEXT:" + str(a) + "x^2 + " + str(b) + "xy + " + str(c) + "y^2 = " + str(n))',
                '    print("META_SOLVABLE:False")',
                '    print("STEP3_TITLE:Search result")',
                '    print("STEP3_LATEX:\\\\text{No solutions found for } |x|, |y| \\\\leq " + str(limit))',
                'else:',
                '    sol_str = ", ".join(["(" + str(x) + "," + str(y) + ")" for x,y in solutions[:12]])',
                '    print("RESULT:" + str(len(solutions)) + " solutions found")',
                '    print("TEXT:" + sol_str)',
                '    print("RESULT_LATEX:" + sol_str + (" \\\\; \\\\ldots" if len(solutions)>12 else ""))',
                '    print("META_SOLVABLE:True")',
                '    print("META_COUNT:" + str(len(solutions)))',
                '    print("VERIFIED:True")',
                '    print("STEP3_TITLE:Solutions")',
                '    print("STEP3_LATEX:" + sol_str)',
                '    px = [p[0] for p in solutions]',
                '    py = [p[1] for p in solutions]',
                '    print("PLOT_X:" + json.dumps(px))',
                '    print("PLOT_Y:" + json.dumps(py))'
            ].join('\n');
        }
    }

    function buildModularCode() {
        var mt = modType ? modType.value : 'single';
        if (mt === 'single') {
            var a = parseNum(modA.value, 7);
            var b = parseNum(modB.value, 3);
            var m = parseNum(modM.value, 15);
            return [
                'from sympy import igcd, mod_inverse',
                'import json',
                'a, b, m = ' + a + ', ' + b + ', ' + m,
                'print("META_METHOD:Extended Euclidean / Modular Inverse")',
                'print("STEP1_TITLE:Given congruence")',
                'print("STEP1_LATEX:" + str(a) + "x \\\\equiv " + str(b) + " \\\\pmod{" + str(m) + "}")',
                '',
                'if m <= 0:',
                '    print("RESULT:Modulus must be positive")',
                '    print("TEXT:Invalid modulus")',
                '    print("META_SOLVABLE:False")',
                'else:',
                '    d = igcd(abs(a), m)',
                '    print("STEP2_TITLE:GCD check")',
                '    print("STEP2_LATEX:\\\\gcd(" + str(a) + ", " + str(m) + ") = " + str(d))',
                '    if b % d != 0:',
                '        print("RESULT:No solution")',
                '        print("TEXT:" + str(a) + "x = " + str(b) + " (mod " + str(m) + ")")',
                '        print("META_SOLVABLE:False")',
                '        print("STEP3_TITLE:No solution")',
                '        print("STEP3_LATEX:\\\\gcd(" + str(a) + ", " + str(m) + ") = " + str(d) + " \\\\nmid " + str(b) + " \\\\implies \\\\text{no solution}")',
                '    else:',
                '        # Reduce: (a/d)x = (b/d) mod (m/d)',
                '        a_r = a // d',
                '        b_r = b // d',
                '        m_r = m // d',
                '        inv = mod_inverse(a_r, m_r)',
                '        x0 = (inv * b_r) % m_r',
                '        # All solutions mod m',
                '        solutions = sorted(set([(x0 + i * m_r) % m for i in range(d)]))',
                '        sol_str = ", ".join([str(s) for s in solutions])',
                '        print("RESULT:x = " + sol_str + " (mod " + str(m) + ")")',
                '        print("TEXT:x = " + sol_str + " (mod " + str(m) + ")")',
                '        print("RESULT_LATEX:x \\\\equiv " + sol_str + " \\\\pmod{" + str(m) + "}")',
                '        print("META_SOLVABLE:True")',
                '        print("VERIFIED:True")',
                '        if d > 1:',
                '            print("STEP3_TITLE:Reduce equation")',
                '            print("STEP3_LATEX:\\\\frac{" + str(a) + "}{" + str(d) + "}x \\\\equiv \\\\frac{" + str(b) + "}{" + str(d) + "} \\\\pmod{\\\\frac{" + str(m) + "}{" + str(d) + "}} \\\\implies " + str(a_r) + "x \\\\equiv " + str(b_r) + " \\\\pmod{" + str(m_r) + "}")',
                '            print("STEP4_TITLE:Modular inverse")',
                '            print("STEP4_LATEX:" + str(a_r) + "^{-1} \\\\equiv " + str(inv) + " \\\\pmod{" + str(m_r) + "}")',
                '            print("STEP5_TITLE:Solution (" + str(d) + " solutions mod " + str(m) + ")")',
                '            print("STEP5_LATEX:x \\\\equiv " + sol_str + " \\\\pmod{" + str(m) + "}")',
                '        else:',
                '            print("STEP3_TITLE:Modular inverse")',
                '            print("STEP3_LATEX:" + str(a) + "^{-1} \\\\equiv " + str(inv) + " \\\\pmod{" + str(m) + "}")',
                '            print("STEP4_TITLE:Solution")',
                '            print("STEP4_LATEX:x \\\\equiv " + str(inv) + " \\\\cdot " + str(b) + " \\\\equiv " + str(x0) + " \\\\pmod{" + str(m) + "}")',
                '            print("STEP5_TITLE:Verification")',
                '            print("STEP5_LATEX:" + str(a) + " \\\\cdot " + str(x0) + " = " + str(a * x0) + " \\\\equiv " + str((a * x0) % m) + " \\\\pmod{" + str(m) + "} \\\\; \\\\checkmark")'
            ].join('\n');
        } else {
            // CRT system
            var rems = modRemainders ? modRemainders.value : '2, 3, 1';
            var mods = modModuli ? modModuli.value : '3, 5, 7';
            return [
                'from sympy.ntheory.modular import crt',
                'from sympy import igcd',
                'import json',
                'remainders = [' + rems + ']',
                'moduli = [' + mods + ']',
                'print("META_METHOD:Chinese Remainder Theorem")',
                'print("STEP1_TITLE:System of congruences")',
                'lines = []',
                'for i in range(len(remainders)):',
                '    lines.append("x \\\\equiv " + str(remainders[i]) + " \\\\pmod{" + str(moduli[i]) + "}")',
                'print("STEP1_LATEX:" + " \\\\\\\\\\\n".join(lines))',
                '',
                '# Check pairwise coprimality',
                'coprime = True',
                'for i in range(len(moduli)):',
                '    for j in range(i+1, len(moduli)):',
                '        if igcd(moduli[i], moduli[j]) != 1:',
                '            coprime = False',
                '            break',
                '    if not coprime: break',
                '',
                'if not coprime:',
                '    print("RESULT:Moduli are not pairwise coprime")',
                '    print("TEXT:CRT requires pairwise coprime moduli")',
                '    print("META_SOLVABLE:False")',
                '    print("STEP2_TITLE:Coprimality check")',
                '    print("STEP2_LATEX:\\\\text{Moduli are NOT pairwise coprime}")',
                'else:',
                '    result = crt(moduli, remainders)',
                '    if result is None:',
                '        print("RESULT:No solution found")',
                '        print("META_SOLVABLE:False")',
                '    else:',
                '        x_sol, M = result',
                '        x_sol = int(x_sol) % int(M)',
                '        M = int(M)',
                '        print("RESULT:x = " + str(x_sol) + " (mod " + str(M) + ")")',
                '        print("TEXT:x = " + str(x_sol) + " (mod " + str(M) + ")")',
                '        print("RESULT_LATEX:x \\\\equiv " + str(x_sol) + " \\\\pmod{" + str(M) + "}")',
                '        print("META_SOLVABLE:True")',
                '        print("META_MODULUS:" + str(M))',
                '        print("VERIFIED:True")',
                '        print("STEP2_TITLE:Combined modulus")',
                '        mod_prod = " \\\\cdot ".join([str(m) for m in moduli])',
                '        print("STEP2_LATEX:M = " + mod_prod + " = " + str(M))',
                '        print("STEP3_TITLE:CRT construction")',
                '        parts = []',
                '        for i in range(len(moduli)):',
                '            Mi = M // moduli[i]',
                '            parts.append("M_" + str(i+1) + " = " + str(M) + "/" + str(moduli[i]) + " = " + str(Mi))',
                '        print("STEP3_LATEX:" + ", \\\\quad ".join(parts))',
                '        print("STEP4_TITLE:Solution")',
                '        print("STEP4_LATEX:x \\\\equiv " + str(x_sol) + " \\\\pmod{" + str(M) + "}")',
                '        print("STEP5_TITLE:Verification")',
                '        checks = []',
                '        for i in range(len(moduli)):',
                '            checks.append(str(x_sol) + " \\\\mod " + str(moduli[i]) + " = " + str(x_sol % moduli[i]) + " = " + str(remainders[i]) + " \\\\; \\\\checkmark")',
                '        print("STEP5_LATEX:" + " \\\\\\\\\\\n".join(checks))'
            ].join('\n');
        }
    }

    function buildCode() {
        switch (currentMode) {
            case 'linear': return buildLinearCode();
            case 'system': return buildSystemCode();
            case 'quadratic': return buildQuadraticCode();
            case 'modular': return buildModularCode();
            default: return buildLinearCode();
        }
    }

    // ===== Examples =====
    var linearExamples = [
        { label: '6x+9y=15', a:'6', b:'9', c:'15' },
        { label: '3x+5y=1', a:'3', b:'5', c:'1' },
        { label: '12x+8y=28', a:'12', b:'8', c:'28' },
        { label: '7x+11y=100', a:'7', b:'11', c:'100' },
        { label: 'No solution: 6x+9y=10', a:'6', b:'9', c:'10' }
    ];
    var systemExamples = [
        { label: '2x+3y=7, 4x+5y=11', a1:'2', b1:'3', c1:'7', a2:'4', b2:'5', c2:'11' },
        { label: '3x+2y=1, 5x+3y=2', a1:'3', b1:'2', c1:'1', a2:'5', b2:'3', c2:'2' },
        { label: 'x+y=10, 2x-y=5', a1:'1', b1:'1', c1:'10', a2:'2', b2:'-1', c2:'5' }
    ];
    var quadraticExamples = [
        { label: 'x\u00B2+y\u00B2=50', qtype:'sum_squares', n:'50' },
        { label: 'x\u00B2+y\u00B2=25', qtype:'sum_squares', n:'25' },
        { label: 'Pell D=2', qtype:'pell', D:'2', count:'8' },
        { label: 'Pell D=3', qtype:'pell', D:'3', count:'6' },
        { label: 'x\u00B2+y\u00B2=100', qtype:'sum_squares', n:'100' }
    ];
    var modularExamples = [
        { label: '7x\u22613 mod 15', mtype:'single', a:'7', b:'3', m:'15' },
        { label: '3x\u22611 mod 7', mtype:'single', a:'3', b:'1', m:'7' },
        { label: 'CRT: 2,3,1 mod 3,5,7', mtype:'system', remainders:'2, 3, 1', moduli:'3, 5, 7' },
        { label: 'CRT: 1,4,6 mod 3,5,7', mtype:'system', remainders:'1, 4, 6', moduli:'3, 5, 7' }
    ];

    function getExamples() {
        switch (currentMode) {
            case 'linear': return linearExamples;
            case 'system': return systemExamples;
            case 'quadratic': return quadraticExamples;
            case 'modular': return modularExamples;
            default: return linearExamples;
        }
    }

    function updateExamples() {
        var container = document.getElementById('dio-examples');
        if (!container) return;
        var arr = getExamples();
        container.innerHTML = arr.map(function(ex) {
            return '<button type="button" class="dio-example-chip" data-ex=\'' + JSON.stringify(ex).replace(/'/g, '&#39;') + '\'>' + escapeHtml(ex.label) + '</button>';
        }).join('');
    }
    updateExamples();

    document.getElementById('dio-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.dio-example-chip');
        if (!chip) return;
        try {
            var ex = JSON.parse(chip.getAttribute('data-ex').replace(/&#39;/g, "'"));
            applyPreset(ex);
            updatePreview();
        } catch(err) {}
    });

    function applyPreset(ex) {
        if (currentMode === 'linear') {
            if (linearA) linearA.value = ex.a || '6';
            if (linearB) linearB.value = ex.b || '9';
            if (linearC) linearC.value = ex.c || '15';
        } else if (currentMode === 'system') {
            if (sysA1) sysA1.value = ex.a1 || '2';
            if (sysB1) sysB1.value = ex.b1 || '3';
            if (sysC1) sysC1.value = ex.c1 || '7';
            if (sysA2) sysA2.value = ex.a2 || '4';
            if (sysB2) sysB2.value = ex.b2 || '5';
            if (sysC2) sysC2.value = ex.c2 || '11';
        } else if (currentMode === 'quadratic') {
            if (quadType && ex.qtype) {
                quadType.value = ex.qtype;
                quadType.dispatchEvent(new Event('change'));
            }
            if (ex.qtype === 'sum_squares') {
                if (quadN) quadN.value = ex.n || '50';
            } else if (ex.qtype === 'pell') {
                if (quadD) quadD.value = ex.D || '2';
                if (quadPellCount) quadPellCount.value = ex.count || '8';
            } else {
                if (quadGA) quadGA.value = ex.ga || '1';
                if (quadGB) quadGB.value = ex.gb || '0';
                if (quadGC) quadGC.value = ex.gc || '1';
                if (quadGN) quadGN.value = ex.gn || '25';
            }
        } else if (currentMode === 'modular') {
            if (modType && ex.mtype) {
                modType.value = ex.mtype;
                modType.dispatchEvent(new Event('change'));
            }
            if (ex.mtype === 'single') {
                if (modA) modA.value = ex.a || '7';
                if (modB) modB.value = ex.b || '3';
                if (modM) modM.value = ex.m || '15';
            } else {
                if (modRemainders) modRemainders.value = ex.remainders || '2, 3, 1';
                if (modModuli) modModuli.value = ex.moduli || '3, 5, 7';
            }
        }
    }

    // Random
    document.getElementById('dio-random-btn').addEventListener('click', function() {
        var arr = getExamples();
        var p = arr[Math.floor(Math.random() * arr.length)];
        applyPreset(p);
        updatePreview();
    });

    // ===== Output Tabs =====
    var tabBtns = document.querySelectorAll('.dio-output-tab');
    var panels = document.querySelectorAll('.dio-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('dio-panel-' + panel).classList.add('active');
            if (panel === 'graph' && pendingGraph) loadPlotly(function() { renderGraph(pendingGraph); });
            if (panel === 'python' && !compilerLoaded) { loadCompilerWithTemplate(); compilerLoaded = true; }
        });
    });

    function loadCompilerWithTemplate() {
        var code = buildCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('dio-compiler-iframe');
        if (iframe) iframe.src = (window.DIO_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ===== Reference Table =====
    var formulaData = [
        { f: 'ax + by = c', m: '\\text{Extended Euclidean algorithm}' },
        { f: '\\begin{cases} a_1 x + b_1 y = c_1 \\\\ a_2 x + b_2 y = c_2 \\end{cases}', m: '\\text{Cramer\'s rule (integer check)}' },
        { f: 'x^2 + y^2 = n', m: '\\text{Brute-force / Cornacchia}' },
        { f: 'x^2 - Dy^2 = 1', m: '\\text{Continued fractions}' },
        { f: 'ax \\equiv b \\pmod{m}', m: '\\text{Modular inverse}' },
        { f: 'x \\equiv a_i \\pmod{m_i}', m: '\\text{Chinese Remainder Theorem}' }
    ];

    function renderFormulas() {
        if (typeof katex === 'undefined') return;
        formulaData.forEach(function(row, i) {
            var fEl = document.getElementById('dio-formula-f' + i);
            var mEl = document.getElementById('dio-formula-m' + i);
            if (fEl) katex.render(row.f, fEl, { throwOnError: false });
            if (mEl) katex.render(row.m, mEl, { throwOnError: false });
        });
    }

    var formulasToggle = document.getElementById('dio-formulas-toggle');
    var formulasContent = document.getElementById('dio-formulas-content');
    if (formulasToggle) {
        formulasToggle.addEventListener('click', function() {
            var open = formulasContent.style.display !== 'none';
            formulasContent.style.display = open ? 'none' : '';
            formulasToggle.querySelector('.dio-formulas-chevron').style.transform = open ? '' : 'rotate(180deg)';
            if (!open) renderFormulas();
        });
    }

    var syntaxToggle = document.getElementById('dio-syntax-toggle');
    var syntaxContent = document.getElementById('dio-syntax-content');
    if (syntaxToggle) {
        syntaxToggle.addEventListener('click', function() {
            var open = syntaxContent.style.display !== 'none';
            syntaxContent.style.display = open ? 'none' : '';
            syntaxToggle.querySelector('.dio-formulas-chevron').style.transform = open ? '' : 'rotate(180deg)';
        });
    }

    // ===== Result Display =====
    function showError(msg) {
        if (emptyState) emptyState.style.display = 'none';
        resultContent.innerHTML = '<div class="dio-error"><h4>Error</h4><p>' + escapeHtml(msg) + '</p></div>';
        pendingGraph = null;
        if (exportRow) exportRow.style.display = 'none';
    }

    function showResult(stdout) {
        if (emptyState) emptyState.style.display = 'none';

        var errMatch = stdout.match(/ERROR:([^\n]*)/);
        if (errMatch) { showError(errMatch[1].trim()); return; }

        // Check for Python traceback
        if (stdout.indexOf('Traceback') !== -1) {
            var tbLines = stdout.split('\n');
            var lastLine = '';
            for (var tbi = tbLines.length - 1; tbi >= 0; tbi--) {
                if (tbLines[tbi].trim()) { lastLine = tbLines[tbi].trim(); break; }
            }
            showError(lastLine || 'Python execution error');
            return;
        }

        // Parse metadata
        var meta = {};
        var metaRe = /META_(\w+):([^\n]*)/g;
        var m;
        while ((m = metaRe.exec(stdout)) !== null) meta[m[1]] = m[2].trim();

        // Parse steps
        var steps = [];
        var stepRe = /STEP(\d+)_TITLE:([^\n]*)/g;
        while ((m = stepRe.exec(stdout)) !== null) {
            var idx = m[1];
            var latexMatch = stdout.match(new RegExp('STEP' + idx + '_LATEX:([^\n]*)'));
            steps.push({ title: m[2].trim(), latex: latexMatch ? latexMatch[1].trim() : '' });
        }
        lastStepsData = steps;

        // Parse result
        var resultMatch = stdout.match(/RESULT:([^\n]*)/);
        var resultLatexMatch = stdout.match(/RESULT_LATEX:([^\n]*)/);
        var textMatch = stdout.match(/TEXT:([^\n]*)/);
        var verifiedMatch = stdout.match(/VERIFIED:([^\n]*)/);

        var resultText = resultMatch ? resultMatch[1].trim() : 'Computed';
        lastResultText = resultText;
        lastResultLatex = resultLatexMatch ? resultLatexMatch[1].trim() : (textMatch ? textMatch[1].trim() : resultText);

        // Parse graph data
        var pxMatch = stdout.match(/PLOT_X:(\[[^\n]*\])/);
        var pyMatch = stdout.match(/PLOT_Y:(\[[^\n]*\])/);
        var graphData = null;
        try {
            if (pxMatch && pyMatch) {
                graphData = { x: JSON.parse(pxMatch[1]), y: JSON.parse(pyMatch[1]) };
            }
        } catch(e) {}
        pendingGraph = graphData;

        // Build HTML
        var verified = verifiedMatch ? verifiedMatch[1].trim() === 'True' : null;
        var solvable = meta.SOLVABLE;
        var methodLabel = meta.METHOD || 'Computation';

        var methodBadge = '<span class="dio-method-badge">' + escapeHtml(methodLabel) + '</span>';
        var verBadge = (verified === true) ? '<span class="dio-verified-badge">Verified</span>' : '';
        var solvBadge = '';
        if (solvable === 'False') solvBadge = '<span class="dio-nosolution-badge">No Solution</span>';
        else if (solvable === 'True') solvBadge = '<span class="dio-verified-badge">Solvable</span>';
        var gcdBadge = meta.GCD ? '<span class="dio-classify-badge">gcd = ' + escapeHtml(meta.GCD) + '</span>' : '';
        var countBadge = meta.COUNT ? '<span class="dio-classify-badge">' + escapeHtml(meta.COUNT) + ' solutions</span>' : '';
        var fundBadge = meta.FUNDAMENTAL ? '<span class="dio-classify-badge">Fund: ' + escapeHtml(meta.FUNDAMENTAL) + '</span>' : '';

        var html = '<div class="dio-meta-row">' + methodBadge + solvBadge + verBadge + gcdBadge + countBadge + fundBadge + '</div>';

        // Result box
        html += '<div class="dio-result-math"><div class="dio-result-label">RESULT</div>';
        html += '<div class="dio-result-main" id="dio-result-main-katex"></div></div>';

        // Steps
        if (steps.length > 0) {
            html += '<div class="dio-steps"><div class="dio-steps-title">Step-by-Step Solution</div>';
            steps.forEach(function(step, i) {
                html += '<div class="dio-step">';
                html += '<div class="dio-step-num">' + (i + 1) + '</div>';
                html += '<div class="dio-step-body">';
                html += '<div class="dio-step-title">' + escapeHtml(step.title) + '</div>';
                if (step.latex) html += '<div class="dio-step-math" id="dio-step-math-' + i + '"></div>';
                html += '</div></div>';
            });
            html += '</div>';
        }

        resultContent.innerHTML = html;

        // Render KaTeX
        if (typeof katex !== 'undefined') {
            var mainEl = document.getElementById('dio-result-main-katex');
            if (mainEl) {
                try {
                    katex.render(lastResultLatex, mainEl, { displayMode: true, throwOnError: false });
                } catch(e) {
                    mainEl.textContent = lastResultLatex;
                }
            }
            steps.forEach(function(step, i) {
                var el = document.getElementById('dio-step-math-' + i);
                if (el && step.latex) {
                    try {
                        katex.render(step.latex, el, { displayMode: true, throwOnError: false });
                    } catch(e) {
                        el.textContent = step.latex;
                    }
                }
            });
        }

        if (exportRow) exportRow.style.display = '';

        // Update graph hint and auto-render graph
        if (graphHint) graphHint.style.display = graphData ? 'none' : '';
        if (graphData) {
            loadPlotly(function() { renderGraph(graphData); });
        }
    }

    // ===== Graph Rendering =====
    function renderGraph(data) {
        if (!data || !data.x || !data.y) return;
        var container = document.getElementById('dio-graph-container');
        if (!container) return;

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var bgColor = isDark ? '#1e1e2e' : '#ffffff';
        var gridColor = isDark ? '#374151' : '#e5e7eb';
        var textColor = isDark ? '#e5e7eb' : '#374151';

        var trace = {
            x: data.x,
            y: data.y,
            mode: 'markers',
            type: 'scatter',
            marker: {
                size: 8,
                color: '#7c3aed',
                line: { color: '#fff', width: 1 }
            },
            name: 'Integer solutions'
        };

        var layout = {
            title: { text: 'Integer Solution Points', font: { size: 14, color: textColor } },
            xaxis: { title: 'x', gridcolor: gridColor, color: textColor, dtick: data.x.length < 30 ? 1 : undefined },
            yaxis: { title: 'y', gridcolor: gridColor, color: textColor, dtick: data.y.length < 30 ? 1 : undefined },
            paper_bgcolor: bgColor,
            plot_bgcolor: bgColor,
            margin: { l: 50, r: 20, t: 40, b: 50 },
            showlegend: false
        };

        if (typeof Plotly !== 'undefined') {
            Plotly.newPlot(container, [trace], layout, { responsive: true, displayModeBar: false });
        }
    }

    // ===== Compute =====
    function setComputing(busy) {
        isComputing = busy;
        if (computeBtn) {
            computeBtn.disabled = busy;
            computeBtn.textContent = busy ? 'Solving...' : 'Solve';
        }
    }

    function doCompute() {
        if (isComputing) return;
        setComputing(true);
        compilerLoaded = false;

        var code = buildCode();
        if (emptyState) emptyState.style.display = 'none';
        if (exportRow) exportRow.style.display = 'none';
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;"><p style="color:var(--text-secondary);font-size:0.9375rem;">Solving...</p></div>';

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.DIO_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            clearTimeout(timeoutId);
            setComputing(false);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();
            if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                showError(stderr || 'Computation failed.');
                return;
            }
            showResult(stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            setComputing(false);
            showError(err.name === 'AbortError' ? 'Request timed out (90s)' : err.message);
        });
    }

    if (computeBtn) {
        computeBtn.addEventListener('click', doCompute);
    }

    // ===== Export: Copy LaTeX =====
    var copyLatexBtn = document.getElementById('dio-copy-latex-btn');
    if (copyLatexBtn) {
        copyLatexBtn.addEventListener('click', function() {
            var text = lastResultLatex || lastResultText || '';
            if (lastStepsData && lastStepsData.length > 0) {
                text += '\n\n% Steps:\n';
                lastStepsData.forEach(function(s, i) {
                    text += '% Step ' + (i+1) + ': ' + s.title + '\n';
                    if (s.latex) text += s.latex + '\n';
                });
            }
            navigator.clipboard.writeText(text).then(function() {
                copyLatexBtn.textContent = 'Copied!';
                setTimeout(function() { copyLatexBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg> LaTeX'; }, 1500);
            });
        });
    }

    // ===== Export: PDF =====
    var pdfBtn = document.getElementById('dio-download-pdf-btn');
    if (pdfBtn) {
        pdfBtn.addEventListener('click', function() {
            var w = window.open('', '_blank');
            var content = '<html><head><title>Diophantine Solution</title>';
            content += '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">';
            content += '<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"><\/script>';
            content += '<style>body{font-family:serif;max-width:700px;margin:2rem auto;padding:1rem;} .step{margin:1rem 0;} .step-num{font-weight:bold;} .katex-display{margin:0.5rem 0;}</style>';
            content += '</head><body>';
            content += '<h1>Diophantine Equation - Solution</h1>';
            content += '<div id="result"></div>';
            if (lastStepsData && lastStepsData.length > 0) {
                content += '<h2>Step-by-Step Solution</h2>';
                lastStepsData.forEach(function(s, i) {
                    content += '<div class="step"><span class="step-num">Step ' + (i+1) + ':</span> ' + escapeHtml(s.title);
                    if (s.latex) content += '<div id="step-' + i + '"></div>';
                    content += '</div>';
                });
            }
            content += '<script>';
            content += 'try{katex.render("' + lastResultLatex.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '", document.getElementById("result"), {displayMode:true,throwOnError:false});}catch(e){document.getElementById("result").textContent="' + escapeHtml(lastResultText) + '";}';
            if (lastStepsData) {
                lastStepsData.forEach(function(s, i) {
                    if (s.latex) {
                        content += 'try{katex.render("' + s.latex.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '", document.getElementById("step-' + i + '"), {displayMode:true,throwOnError:false});}catch(e){}';
                    }
                });
            }
            content += 'setTimeout(function(){window.print();},500);';
            content += '<\/script></body></html>';
            w.document.write(content);
            w.document.close();
        });
    }

    // ===== Export: Share URL =====
    var shareBtn = document.getElementById('dio-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function() {
            var params = new URLSearchParams();
            params.set('mode', currentMode);
            if (currentMode === 'linear') {
                params.set('a', linearA.value); params.set('b', linearB.value); params.set('c', linearC.value);
            } else if (currentMode === 'system') {
                params.set('a1', sysA1.value); params.set('b1', sysB1.value); params.set('c1', sysC1.value);
                params.set('a2', sysA2.value); params.set('b2', sysB2.value); params.set('c2', sysC2.value);
            } else if (currentMode === 'quadratic') {
                params.set('qt', quadType.value);
                if (quadType.value === 'sum_squares') params.set('n', quadN.value);
                else if (quadType.value === 'pell') { params.set('D', quadD.value); params.set('count', quadPellCount.value); }
                else { params.set('ga', quadGA.value); params.set('gb', quadGB.value); params.set('gc', quadGC.value); params.set('gn', quadGN.value); }
            } else if (currentMode === 'modular') {
                params.set('mt', modType.value);
                if (modType.value === 'single') { params.set('a', modA.value); params.set('b', modB.value); params.set('m', modM.value); }
                else { params.set('rems', modRemainders.value); params.set('mods', modModuli.value); }
            }
            var url = window.location.origin + window.location.pathname + '?' + params.toString();
            navigator.clipboard.writeText(url).then(function() {
                shareBtn.textContent = 'Copied!';
                setTimeout(function() { shareBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg> Share'; }, 1500);
            });
        });
    }

    // ===== URL Param Restore =====
    function restoreFromURL() {
        var params = new URLSearchParams(window.location.search);
        var mode = params.get('mode');
        if (!mode) return;

        // Activate mode
        var btn = document.querySelector('.dio-mode-btn[data-mode="' + mode + '"]');
        if (btn) btn.click();

        if (mode === 'linear') {
            if (params.has('a') && linearA) linearA.value = params.get('a');
            if (params.has('b') && linearB) linearB.value = params.get('b');
            if (params.has('c') && linearC) linearC.value = params.get('c');
        } else if (mode === 'system') {
            if (params.has('a1') && sysA1) sysA1.value = params.get('a1');
            if (params.has('b1') && sysB1) sysB1.value = params.get('b1');
            if (params.has('c1') && sysC1) sysC1.value = params.get('c1');
            if (params.has('a2') && sysA2) sysA2.value = params.get('a2');
            if (params.has('b2') && sysB2) sysB2.value = params.get('b2');
            if (params.has('c2') && sysC2) sysC2.value = params.get('c2');
        } else if (mode === 'quadratic') {
            var qt = params.get('qt');
            if (qt && quadType) { quadType.value = qt; quadType.dispatchEvent(new Event('change')); }
            if (qt === 'sum_squares' && params.has('n') && quadN) quadN.value = params.get('n');
            if (qt === 'pell') {
                if (params.has('D') && quadD) quadD.value = params.get('D');
                if (params.has('count') && quadPellCount) quadPellCount.value = params.get('count');
            }
            if (qt === 'general') {
                if (params.has('ga') && quadGA) quadGA.value = params.get('ga');
                if (params.has('gb') && quadGB) quadGB.value = params.get('gb');
                if (params.has('gc') && quadGC) quadGC.value = params.get('gc');
                if (params.has('gn') && quadGN) quadGN.value = params.get('gn');
            }
        } else if (mode === 'modular') {
            var mt = params.get('mt');
            if (mt && modType) { modType.value = mt; modType.dispatchEvent(new Event('change')); }
            if (mt === 'single') {
                if (params.has('a') && modA) modA.value = params.get('a');
                if (params.has('b') && modB) modB.value = params.get('b');
                if (params.has('m') && modM) modM.value = params.get('m');
            } else {
                if (params.has('rems') && modRemainders) modRemainders.value = params.get('rems');
                if (params.has('mods') && modModuli) modModuli.value = params.get('mods');
            }
        }
        updatePreview();
    }

    // ===== Init =====
    updatePreview();
    restoreFromURL();

})();
