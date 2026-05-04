/**
 * Quadratic Solver - Render Module
 * Step-by-step solution rendering with KaTeX
 */
(function() {
'use strict';

// ==================== Helpers ====================

function fmt(n) {
    if (Number.isInteger(n)) return String(n);
    var s = n.toFixed(4);
    return s.replace(/\.?0+$/, '') || '0';
}

function fmtCoeff(val, variable) {
    if (val === 0) return '';
    var abs = Math.abs(val);
    var sign = val > 0 ? '+' : '-';
    var coef = abs === 1 && variable ? '' : fmt(abs);
    return sign + ' ' + coef + variable;
}

function fmtLeading(val, variable) {
    if (val === 0) return '';
    if (val === 1) return variable;
    if (val === -1) return '-' + variable;
    return fmt(val) + variable;
}

function gcd(a, b) {
    a = Math.abs(a); b = Math.abs(b);
    while (b) { var t = b; b = a % b; a = t; }
    return a || 1;
}

// Recognize rational numbers up to denominator 12 (covers halves, thirds,
// quarters, sixths, eighths, twelfths). Returns {num, den} in lowest terms,
// or null when the value is genuinely irrational.
function rationalize(n) {
    if (!isFinite(n)) return null;
    var sign = n < 0 ? -1 : 1;
    var abs = Math.abs(n);
    if (Math.abs(abs - Math.round(abs)) < 1e-6) return { num: sign * Math.round(abs), den: 1 };
    for (var den = 2; den <= 12; den++) {
        var num = abs * den;
        if (Math.abs(num - Math.round(num)) < 1e-6) {
            var n_int = Math.round(num);
            var g = gcd(n_int, den);
            return { num: sign * (n_int / g), den: den / g };
        }
    }
    return null;
}

function fmtRational(rat) {
    if (rat.den === 1) return String(rat.num);
    return '\\frac{' + rat.num + '}{' + rat.den + '}';
}

function buildStepDOM(number, description, latex) {
    var step = document.createElement('div');
    step.className = 'qs-step';

    var numEl = document.createElement('div');
    numEl.className = 'qs-step-number';
    numEl.textContent = number;
    step.appendChild(numEl);

    var content = document.createElement('div');
    content.className = 'qs-step-content';

    if (description) {
        var desc = document.createElement('div');
        desc.className = 'qs-step-desc';
        desc.innerHTML = description;
        content.appendChild(desc);
    }

    if (latex) {
        var mathEl = document.createElement('div');
        mathEl.className = 'qs-step-math';
        try {
            katex.render(latex, mathEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            mathEl.textContent = latex;
        }
        content.appendChild(mathEl);
    }

    step.appendChild(content);
    return step;
}

function renderKaTeX(container, latex) {
    try {
        katex.render(latex, container, { displayMode: true, throwOnError: false });
    } catch (e) {
        container.textContent = latex;
    }
}

// ==================== Main Render ====================

function renderSolution(result) {
    var html = '';

    // Result summary card
    html += '<div class="qs-result-section">';

    if (result.roots.type === 'real') {
        html += '<div class="qs-result-badge qs-badge-success">';
        html += result.disc > 0 ? 'Two Real Roots' : 'Repeated Root';
        html += '</div>';

        html += '<div class="qs-result-label">Solutions</div>';
        html += '<div class="qs-result-math" id="qs-root-math"></div>';

        if (result.disc > 0) {
            html += '<div class="qs-result-detail">';
            html += '<strong>x&#8321;</strong> = ' + fmt(result.roots.x1) + ' &nbsp;&nbsp; ';
            html += '<strong>x&#8322;</strong> = ' + fmt(result.roots.x2);
            html += '</div>';
        } else {
            html += '<div class="qs-result-detail">';
            html += '<strong>x</strong> = ' + fmt(result.roots.x1) + ' (double root)';
            html += '</div>';
        }
    } else {
        html += '<div class="qs-result-badge qs-badge-warning">Complex Roots</div>';
        html += '<div class="qs-result-label">Solutions</div>';
        html += '<div class="qs-result-math" id="qs-root-math"></div>';
        html += '<div class="qs-result-detail">';
        html += '<strong>x&#8321;</strong> = ' + fmt(result.roots.real) + ' + ' + fmt(result.roots.imag) + 'i &nbsp;&nbsp; ';
        html += '<strong>x&#8322;</strong> = ' + fmt(result.roots.real) + ' &minus; ' + fmt(result.roots.imag) + 'i';
        html += '</div>';
    }

    // Discriminant info
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>Discriminant:</strong> &Delta; = ' + fmt(result.disc);
    if (result.disc > 0) html += ' &gt; 0 (two distinct real roots)';
    else if (result.disc === 0) html += ' = 0 (one repeated root)';
    else html += ' &lt; 0 (complex conjugate roots)';
    html += '</div>';

    // Vertex info
    var h = -result.b / (2 * result.a);
    var k = result.c - result.b * result.b / (4 * result.a);
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>Vertex:</strong> (' + fmt(h) + ', ' + fmt(k) + ') &nbsp; ';
    html += '<strong>Axis:</strong> x = ' + fmt(h) + ' &nbsp; ';
    html += '<strong>Opens:</strong> ' + (result.a > 0 ? 'Upward' : 'Downward');
    html += '</div>';

    // X-intercept & midpoint info
    if (result.roots.type === 'real' && result.disc > 0) {
        var r1 = Math.min(result.roots.x1, result.roots.x2);
        var r2 = Math.max(result.roots.x1, result.roots.x2);
        var mid = (r1 + r2) / 2;
        html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
        html += '<strong>X-intercepts:</strong> (' + fmt(r1) + ', 0) and (' + fmt(r2) + ', 0) &nbsp; ';
        html += '<strong>Midpoint:</strong> x = ' + fmt(mid);
        html += ' &nbsp; <span style="color:var(--text-muted);font-size:0.85em;">(equals vertex x-coordinate)</span>';
        html += '</div>';
    } else if (result.roots.type === 'real' && result.disc === 0) {
        html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
        html += '<strong>X-intercept:</strong> (' + fmt(result.roots.x1) + ', 0) &mdash; parabola touches the x-axis at the vertex';
        html += '</div>';
    } else {
        html += '<div class="qs-result-detail qs-no-intercept-box" style="margin-top:0.5rem;padding:0.5rem 0.75rem;background:var(--bg-secondary);border-left:3px solid var(--qs-tool);border-radius:4px;">';
        html += '<strong>No x-intercepts</strong> &mdash; the parabola does not cross the x-axis. ';
        html += 'The entire curve lies ' + (result.a > 0 ? 'above' : 'below') + ' the x-axis.';
        html += ' The vertex (' + fmt(h) + ', ' + fmt(k) + ') is the ' + (result.a > 0 ? 'minimum' : 'maximum') + ' point.';
        html += '</div>';
    }

    // Area under parabola between roots (when two distinct real roots)
    if (result.areaBetweenRoots !== undefined) {
        html += '<div class="qs-result-detail qs-area-box" style="margin-top:0.75rem;">';
        html += '<strong>Area under parabola</strong> (between roots x&#8321; and x&#8322;): ';
        html += '<span class="qs-area-value">' + fmt(result.areaBetweenRoots) + '</span>';
        html += ' <span class="qs-area-hint">square units</span>';
        html += '</div>';
    }

    html += '</div>';
    return html;
}

function renderHorizontalSolution(result) {
    var v = result.vertex, f = result.focus;
    var html = '<div class="qs-result-section">';
    html += '<div class="qs-result-badge qs-badge-info">Horizontal Parabola</div>';
    html += '<div class="qs-result-label">Standard Conic Form</div>';
    html += '<div class="qs-result-math" id="qs-horiz-std-math"></div>';
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>Vertex:</strong> (' + fmt(v.h) + ', ' + fmt(v.k) + ') &nbsp; ';
    html += '<strong>Focus:</strong> (' + fmt(f.x) + ', ' + fmt(f.y) + ') &nbsp; ';
    html += '<strong>Directrix:</strong> x = ' + fmt(result.directrix);
    html += '</div>';
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>Axis of symmetry:</strong> y = ' + fmt(v.k) + ' &nbsp; ';
    html += '<strong>Opens:</strong> ' + (result.opensRight ? 'Right' : 'Left');
    html += ' <span style="color:var(--text-muted);font-size:0.85em;">(a ' + (result.opensRight ? '&gt; 0' : '&lt; 0') + ')</span>';
    html += '</div>';
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>p</strong> = ' + fmt(result.p) + ' &nbsp;';
    html += '<span style="color:var(--text-muted);font-size:0.85em;">(focal distance)</span> &nbsp; ';
    html += '<strong>4p</strong> = ' + fmt(4 * result.p) + ' &nbsp;';
    html += '<span style="color:var(--text-muted);font-size:0.85em;">(coefficient in (y &minus; k)&sup2; = 4p(x &minus; h))</span>';
    html += '</div>';
    html += '</div>';
    return html;
}

function postRenderHorizontal(result) {
    var el = document.getElementById('qs-horiz-std-math');
    if (!el) return;
    var v = result.vertex;
    var signH = v.h >= 0 ? '-' : '+';
    var signK = v.k >= 0 ? '-' : '+';
    var latex = '(y ' + signK + ' ' + fmt(Math.abs(v.k)) + ')^2 = ' + fmt(4 * result.p) + '(x ' + signH + ' ' + fmt(Math.abs(v.h)) + ')';
    renderKaTeX(el, latex);
}

function renderHorizontalSteps(result) {
    var a = result.a, b = result.b, c = result.c;
    var v = result.vertex, p = result.p;
    var frag = document.createDocumentFragment();

    frag.appendChild(buildStepDOM(1, '<strong>Start with</strong> x = ay\u00B2 + by + c',
        'x = ' + fmt(a) + 'y^2 ' + (b >= 0 ? '+' : '-') + ' ' + fmt(Math.abs(b)) + 'y ' + (c >= 0 ? '+' : '-') + ' ' + fmt(Math.abs(c))));

    var k = -b / (2 * a);
    frag.appendChild(buildStepDOM(2, '<strong>Vertex y-coordinate</strong> from k = &minus;b/(2a)',
        'k = \\frac{-(' + fmt(b) + ')}{2(' + fmt(a) + ')} = ' + fmt(k)));

    var h = c - (b * b) / (4 * a);
    frag.appendChild(buildStepDOM(3, '<strong>Vertex x-coordinate</strong>: h = c - b\u00B2/(4a)',
        'h = ' + fmt(c) + ' - \\frac{(' + fmt(b) + ')^2}{4(' + fmt(a) + ')} = ' + fmt(h)));

    frag.appendChild(buildStepDOM(4, '<strong>Standard form</strong> (y \u2212 k)\u00B2 = 4p(x \u2212 h). Parameter p = 1/(4a)',
        'p = \\frac{1}{4(' + fmt(a) + ')} = ' + fmt(p) + ', \\quad (y - ' + fmt(k) + ')^2 = ' + fmt(4 * p) + '(x - ' + fmt(h) + ')'));

    var fx = h + p;
    frag.appendChild(buildStepDOM(5, '<strong>Focus</strong> F = (h + p, k) &nbsp; <strong>Directrix</strong> x = h \u2212 p',
        'F = (' + fmt(fx) + ', ' + fmt(k) + '), \\quad \\text{Directrix: } x = ' + fmt(result.directrix)));

    return frag;
}

function renderInequality(result) {
    var html = '<div class="qs-result-section">';
    html += '<div class="qs-result-badge qs-badge-info">Inequality Solution</div>';
    html += '<div class="qs-result-label">Solution Set</div>';
    html += '<div class="qs-result-math" id="qs-root-math"></div>';
    html += '<div class="qs-result-detail">' + result.intervalHtml + '</div>';

    // Discriminant detail (parity with standard render)
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>Discriminant:</strong> &Delta; = ' + fmt(result.disc);
    if (result.disc > 0) html += ' &gt; 0 (two real roots)';
    else if (result.disc === 0) html += ' = 0 (one repeated root)';
    else html += ' &lt; 0 (no real roots &mdash; parabola entirely on one side of x-axis)';
    html += '</div>';

    // Vertex + axis + opens
    var h = -result.b / (2 * result.a);
    var k = result.c - result.b * result.b / (4 * result.a);
    html += '<div class="qs-result-detail" style="margin-top:0.5rem;">';
    html += '<strong>Vertex:</strong> (' + fmt(h) + ', ' + fmt(k) + ') &nbsp; ';
    html += '<strong>Axis:</strong> x = ' + fmt(h) + ' &nbsp; ';
    html += '<strong>Opens:</strong> ' + (result.a > 0 ? 'Upward' : 'Downward');
    html += '</div>';

    if (result.areaBetweenRoots !== undefined) {
        html += '<div class="qs-result-detail qs-area-box" style="margin-top:0.75rem;">';
        html += '<strong>Area under parabola</strong> (between roots): ';
        html += '<span class="qs-area-value">' + fmt(result.areaBetweenRoots) + '</span> square units';
        html += '</div>';
    }
    html += '</div>';
    return html;
}

function postRenderRoots(result) {
    var el = document.getElementById('qs-root-math');
    if (!el) return;

    var latex;
    if (result.isInequality) {
        latex = result.intervalLatex || '';
    } else if (result.roots.type === 'real') {
        if (result.disc > 0) {
            latex = 'x_1 = ' + fmt(result.roots.x1) + ', \\quad x_2 = ' + fmt(result.roots.x2);
        } else {
            latex = 'x = ' + fmt(result.roots.x1);
        }
    } else {
        latex = 'x = ' + fmt(result.roots.real) + ' \\pm ' + fmt(result.roots.imag) + 'i';
    }
    renderKaTeX(el, latex);
}

// ==================== Step Renderers ====================

function renderFormulaSteps(result) {
    var a = result.a, b = result.b, c = result.c;
    var disc = result.disc, roots = result.roots;
    var frag = document.createDocumentFragment();

    frag.appendChild(buildStepDOM(1, '<strong>Apply the quadratic formula</strong>',
        'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}'));

    frag.appendChild(buildStepDOM(2, '<strong>Substitute</strong> a = ' + fmt(a) + ', b = ' + fmt(b) + ', c = ' + fmt(c),
        'x = \\frac{-(' + fmt(b) + ') \\pm \\sqrt{(' + fmt(b) + ')^2 - 4(' + fmt(a) + ')(' + fmt(c) + ')}}{2(' + fmt(a) + ')}'));

    frag.appendChild(buildStepDOM(3, '<strong>Calculate the discriminant</strong>',
        '\\Delta = ' + fmt(b) + '^2 - 4(' + fmt(a) + ')(' + fmt(c) + ') = ' + fmt(b * b) + ' - ' + fmt(4 * a * c) + ' = ' + fmt(disc)));

    var rootLatex;
    if (roots.type === 'real') {
        if (disc > 0) {
            var sqrtDisc = Math.sqrt(disc);
            rootLatex = 'x = \\frac{' + fmt(-b) + ' \\pm ' + fmt(sqrtDisc) + '}{' + fmt(2 * a) + '}';
            frag.appendChild(buildStepDOM(4, '<strong>Calculate roots</strong>', rootLatex));
            frag.appendChild(buildStepDOM(5, '<strong>Root 1</strong>',
                'x_1 = \\frac{' + fmt(-b) + ' + ' + fmt(sqrtDisc) + '}{' + fmt(2 * a) + '} = ' + fmt(roots.x1)));
            frag.appendChild(buildStepDOM(6, '<strong>Root 2</strong>',
                'x_2 = \\frac{' + fmt(-b) + ' - ' + fmt(sqrtDisc) + '}{' + fmt(2 * a) + '} = ' + fmt(roots.x2)));
        } else {
            rootLatex = 'x = \\frac{' + fmt(-b) + '}{' + fmt(2 * a) + '} = ' + fmt(roots.x1);
            frag.appendChild(buildStepDOM(4, '<strong>Single root</strong> (&Delta; = 0)', rootLatex));
        }
        if (result.areaBetweenRoots !== undefined) {
            var r1 = Math.min(roots.x1, roots.x2);
            var r2 = Math.max(roots.x1, roots.x2);
            frag.appendChild(buildStepDOM(7, '<strong>Area under parabola</strong> (between roots)',
                '\\int_{' + fmt(r1) + '}^{' + fmt(r2) + '} (' + fmt(a) + 'x^2 ' + (b >= 0 ? '+' : '') + fmt(b) + 'x ' + (c >= 0 ? '+' : '') + fmt(c) + ')\\,dx = ' + fmt(result.areaBetweenRoots) + ' \\text{ sq units}'));
        }
    } else {
        var sqrtNegDisc = Math.sqrt(-disc);
        rootLatex = 'x = \\frac{' + fmt(-b) + ' \\pm ' + fmt(sqrtNegDisc) + 'i}{' + fmt(2 * a) + '} = ' + fmt(roots.real) + ' \\pm ' + fmt(roots.imag) + 'i';
        frag.appendChild(buildStepDOM(4, '<strong>Complex roots</strong> (&Delta; &lt; 0)', rootLatex));
    }

    return frag;
}

function renderCompletingSquareSteps(result) {
    var a = result.a, b = result.b, c = result.c, roots = result.roots;
    var h = -b / (2 * a);
    var k = c - b * b / (4 * a);
    var frag = document.createDocumentFragment();

    // Step 1: start
    var eqLatex = fmtLeading(a, 'x^2') + ' ' + fmtCoeff(b, 'x') + ' ' + fmtCoeff(c, '') + ' = 0';
    frag.appendChild(buildStepDOM(1, '<strong>Start with the equation</strong>', eqLatex));

    // Step 2: divide by a
    if (a !== 1) {
        frag.appendChild(buildStepDOM(2, '<strong>Divide by a = ' + fmt(a) + '</strong>',
            'x^2 ' + fmtCoeff(b / a, 'x') + ' ' + fmtCoeff(c / a, '') + ' = 0'));
    }

    var stepN = a !== 1 ? 3 : 2;

    // Move constant
    frag.appendChild(buildStepDOM(stepN, '<strong>Move constant to right side</strong>',
        'x^2 ' + fmtCoeff(b / a, 'x') + ' = ' + fmt(-c / a)));
    stepN++;

    // Add (b/2a)^2
    var halfBOverA = b / (2 * a);
    var sqTerm = halfBOverA * halfBOverA;
    frag.appendChild(buildStepDOM(stepN, '<strong>Add</strong> (b/2a)&sup2; = ' + fmt(sqTerm) + ' <strong>to both sides</strong>',
        'x^2 ' + fmtCoeff(b / a, 'x') + ' + ' + fmt(sqTerm) + ' = ' + fmt(-c / a + sqTerm)));
    stepN++;

    // Factor
    var hSign = h >= 0 ? '-' : '+';
    frag.appendChild(buildStepDOM(stepN, '<strong>Factor left side as perfect square</strong>',
        '(x ' + hSign + ' ' + fmt(Math.abs(h)) + ')^2 = ' + fmt(-k / a)));
    stepN++;

    // Take sqrt
    if (roots.type === 'real') {
        var sqrtVal = Math.sqrt(Math.abs(-k / a));
        frag.appendChild(buildStepDOM(stepN, '<strong>Take square root of both sides</strong>',
            'x = ' + fmt(h) + ' \\pm ' + fmt(sqrtVal)));
    } else {
        var sqrtVal2 = Math.sqrt(Math.abs(k / a));
        frag.appendChild(buildStepDOM(stepN, '<strong>Take square root</strong> (negative inside &rarr; complex)',
            'x = ' + fmt(roots.real) + ' \\pm ' + fmt(roots.imag) + 'i'));
    }

    return frag;
}

function renderFactoringSteps(result) {
    var a = result.a, b = result.b, c = result.c;
    var roots = result.roots;
    var frag = document.createDocumentFragment();

    if (roots.type === 'complex') {
        var warn = document.createElement('div');
        warn.className = 'qs-error';
        warn.innerHTML = '<h4>Cannot Factor Over Reals</h4><p>Complex roots &mdash; use the quadratic formula or completing the square.</p>';
        frag.appendChild(warn);
        return frag;
    }

    var rat1 = rationalize(roots.x1);
    var rat2 = rationalize(roots.x2);

    // Truly irrational roots (e.g. x = 1 ± √2) — factoring over the rationals
    // is not possible. Tell the student to switch methods.
    if (!rat1 || !rat2) {
        var warn2 = document.createElement('div');
        warn2.className = 'qs-error';
        warn2.innerHTML = '<h4>Irrational Roots</h4><p>Roots are irrational: x&#8321; = ' + fmt(roots.x1) +
            ', x&#8322; = ' + fmt(roots.x2) + '. Use the quadratic formula or completing the square instead &mdash; this equation does not factor over the rationals.</p>';
        frag.appendChild(warn2);
        return frag;
    }

    // Both roots integer → classic AC method.
    if (rat1.den === 1 && rat2.den === 1) {
        var r1 = rat1.num, r2 = rat2.num;
        frag.appendChild(buildStepDOM(1,
            '<strong>Find two numbers</strong> that multiply to ac = ' + fmt(a * c) + ' and add to b = ' + fmt(b),
            fmt(a * c) + ' = (' + fmt(-a * r1) + ')(' + fmt(-r2) + '), \\quad ' + fmt(-a * r1) + ' + ' + fmt(-r2) + ' = ' + fmt(b)));

        var r1Sign = r1 >= 0 ? '-' : '+';
        var r2Sign = r2 >= 0 ? '-' : '+';
        frag.appendChild(buildStepDOM(2, '<strong>Write in factored form</strong>',
            fmtLeading(a, '') + '(x ' + r1Sign + ' ' + fmt(Math.abs(r1)) + ')(x ' + r2Sign + ' ' + fmt(Math.abs(r2)) + ') = 0'));

        frag.appendChild(buildStepDOM(3, '<strong>Set each factor to zero</strong>',
            'x = ' + fmt(r1) + ' \\quad \\text{or} \\quad x = ' + fmt(r2)));
        return frag;
    }

    // At least one root is rational with a denominator (e.g. -3/2).
    // Factor as (p₁x − q₁)(p₂x − q₂) where root q/p comes from factor (px − q).
    // Leading coefficient p₁·p₂ should match a (any leftover scale stays out front).
    var p1 = rat1.den, q1 = rat1.num;
    var p2 = rat2.den, q2 = rat2.num;
    var leadProd = p1 * p2;
    var scale = a / leadProd;
    var scaleLatex = (Math.abs(scale - 1) < 1e-9) ? '' : (Math.abs(scale + 1) < 1e-9 ? '-' : fmt(scale));

    function factorLatex(p, q) {
        var pStr = (p === 1) ? 'x' : fmt(p) + 'x';
        var sign = (q >= 0) ? '-' : '+';
        return pStr + ' ' + sign + ' ' + fmt(Math.abs(q));
    }

    frag.appendChild(buildStepDOM(1,
        '<strong>Roots are rational</strong> &mdash; recognize them as fractions',
        'x_1 = ' + fmtRational(rat1) + ', \\quad x_2 = ' + fmtRational(rat2)));

    frag.appendChild(buildStepDOM(2,
        '<strong>Factor as</strong> <em>(p&#8321;x &minus; q&#8321;)(p&#8322;x &minus; q&#8322;)</em> &mdash; for root q/p the factor is (px &minus; q)',
        scaleLatex + '(' + factorLatex(p1, q1) + ')(' + factorLatex(p2, q2) + ') = 0'));

    frag.appendChild(buildStepDOM(3, '<strong>Set each factor to zero</strong>',
        factorLatex(p1, q1) + ' = 0 \\implies x = ' + fmtRational(rat1) +
        ', \\quad ' + factorLatex(p2, q2) + ' = 0 \\implies x = ' + fmtRational(rat2)));

    return frag;
}

function renderInequalitySteps(result) {
    var a = result.a, b = result.b, c = result.c;
    var roots = result.roots, op = result.operator;
    var disc = result.disc;
    var frag = document.createDocumentFragment();

    function fEval(x) { return a * x * x + b * x + c; }
    function opHolds(v) {
        if (op === '<')  return v <  0;
        if (op === '<=') return v <= 0;
        if (op === '>')  return v >  0;
        if (op === '>=') return v >= 0;
        return false;
    }

    // ── No real roots ── parabola entirely above or below the x-axis.
    if (roots.type === 'complex') {
        var allReal = (a > 0 && (op === '>' || op === '>=')) || (a < 0 && (op === '<' || op === '<='));
        var desc = a > 0
            ? 'Parabola opens upward with no real roots &mdash; lies entirely above the x-axis.'
            : 'Parabola opens downward with no real roots &mdash; lies entirely below the x-axis.';
        frag.appendChild(buildStepDOM(1,
            '<strong>Discriminant is negative</strong> &mdash; ' + desc,
            '\\Delta = ' + fmt(disc) + ' < 0'));
        frag.appendChild(buildStepDOM(2,
            '<strong>Test any x-value</strong> to confirm the sign of f(x)',
            'f(0) = ' + fmt(fEval(0)) + ' \\;' + (fEval(0) > 0 ? '> 0' : '< 0')));
        frag.appendChild(buildStepDOM(3, '<strong>Conclusion</strong>',
            allReal ? 'x \\in \\mathbb{R} \\;\\text{(all real numbers)}' : '\\emptyset \\;\\text{(no solution)}'));
        return frag;
    }

    var x1 = Math.min(roots.x1, roots.x2);
    var x2 = Math.max(roots.x1, roots.x2);

    // ── Step 1: roots
    frag.appendChild(buildStepDOM(1,
        '<strong>Find the roots</strong> of <em>' + fmtLeading(a, 'x^2') + ' ' + fmtCoeff(b, 'x') + ' ' + fmtCoeff(c, '') + ' = 0</em>',
        'x_1 = ' + fmt(x1) + ', \\quad x_2 = ' + fmt(x2)));

    // ── Step 2: pick three test points (one per interval) and EVALUATE f(x).
    var tL = Math.floor(x1) - 1;
    var tMRaw = (x1 + x2) / 2;
    var tM = Math.abs(tMRaw - Math.round(tMRaw)) < 1e-9 ? Math.round(tMRaw) : Number(tMRaw.toFixed(2));
    var tR = Math.ceil(x2) + 1;
    if (tL >= x1) tL = x1 - 1;
    if (tR <= x2) tR = x2 + 1;
    var fL = fEval(tL), fM = fEval(tM), fR = fEval(tR);

    var checkL = opHolds(fL), checkM = opHolds(fM), checkR = opHolds(fR);
    var testLatex = '\\begin{array}{lcl}' +
        'f(' + fmt(tL) + ') &=& ' + fmt(fL) + (fL > 0 ? ' > 0' : (fL < 0 ? ' < 0' : ' = 0')) + (checkL ? ' \\;\\checkmark' : '') + ' \\\\ ' +
        'f(' + fmt(tM) + ') &=& ' + fmt(fM) + (fM > 0 ? ' > 0' : (fM < 0 ? ' < 0' : ' = 0')) + (checkM ? ' \\;\\checkmark' : '') + ' \\\\ ' +
        'f(' + fmt(tR) + ') &=& ' + fmt(fR) + (fR > 0 ? ' > 0' : (fR < 0 ? ' < 0' : ' = 0')) + (checkR ? ' \\;\\checkmark' : '') +
        '\\end{array}';
    frag.appendChild(buildStepDOM(2,
        '<strong>Test one x-value from each interval</strong> &mdash; pick a point in <em>(&minus;&infin;, ' + fmt(x1) + ')</em>, <em>(' + fmt(x1) + ', ' + fmt(x2) + ')</em>, and <em>(' + fmt(x2) + ', +&infin;)</em>',
        testLatex));

    // ── Step 3: visible sign chart strip.
    var sL = fL > 0 ? '+' : (fL < 0 ? '−' : '0');
    var sM = fM > 0 ? '+' : (fM < 0 ? '−' : '0');
    var sR = fR > 0 ? '+' : (fR < 0 ? '−' : '0');
    var colorPos = '#15803d', colorNeg = '#dc2626';
    var step3 = buildStepDOM(3, '<strong>Sign chart</strong>', null);
    var chartHTML =
        '<div class="qs-sign-chart" style="display:grid;grid-template-columns:1fr auto 1fr auto 1fr;gap:0.5rem;align-items:center;text-align:center;margin:0.5rem 0;padding:0.75rem 0.5rem;background:var(--bg-secondary,#f5f5f4);border:1px solid var(--border,rgba(0,0,0,0.08));border-radius:0.5rem;font-family:var(--font-mono,monospace);font-size:1rem;">' +
        '<span style="color:' + (fL > 0 ? colorPos : colorNeg) + ';font-weight:700;font-size:1.15rem;">(' + sL + ')</span>' +
        '<span style="background:var(--qs-tool,#7c3aed);color:#fff;padding:0.2rem 0.5rem;border-radius:999px;font-size:0.8rem;font-weight:600;">x = ' + fmt(x1) + '</span>' +
        '<span style="color:' + (fM > 0 ? colorPos : colorNeg) + ';font-weight:700;font-size:1.15rem;">(' + sM + ')</span>' +
        '<span style="background:var(--qs-tool,#7c3aed);color:#fff;padding:0.2rem 0.5rem;border-radius:999px;font-size:0.8rem;font-weight:600;">x = ' + fmt(x2) + '</span>' +
        '<span style="color:' + (fR > 0 ? colorPos : colorNeg) + ';font-weight:700;font-size:1.15rem;">(' + sR + ')</span>' +
        '</div>';
    var holder = document.createElement('div');
    holder.innerHTML = chartHTML;
    var content3 = step3.querySelector('.qs-step-content');
    if (content3) content3.appendChild(holder.firstChild);
    frag.appendChild(step3);

    // ── Step 4: read the satisfying intervals.
    frag.appendChild(buildStepDOM(4,
        '<strong>Read the intervals</strong> where f(x) ' + (op === '>=' ? '&ge;' : op === '<=' ? '&le;' : op) + ' 0',
        result.intervalLatex));

    return frag;
}

// ==================== Full Steps Rendering ====================

function renderSteps(result, container) {
    if (!container) return;
    container.innerHTML = '';

    var methods = result.method === 'all'
        ? ['formula', 'completing', 'factoring']
        : [result.method];

    if (result.isInequality) {
        methods = ['inequality'];
    }

    methods.forEach(function(method) {
        var wrapper = document.createElement('div');
        wrapper.className = 'qs-steps-wrapper';
        wrapper.style.marginBottom = '1rem';

        var header = document.createElement('div');
        header.className = 'qs-steps-header';

        var titles = {
            formula: 'Quadratic Formula',
            completing: 'Completing the Square',
            factoring: 'Factoring',
            inequality: 'Inequality Analysis'
        };
        header.textContent = titles[method] || method;
        wrapper.appendChild(header);

        var body = document.createElement('div');
        var frag;
        switch (method) {
            case 'formula': frag = renderFormulaSteps(result); break;
            case 'completing': frag = renderCompletingSquareSteps(result); break;
            case 'factoring': frag = renderFactoringSteps(result); break;
            case 'inequality': frag = renderInequalitySteps(result); break;
            default: frag = renderFormulaSteps(result);
        }
        body.appendChild(frag);
        wrapper.appendChild(body);
        container.appendChild(wrapper);
    });
}

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div class="qs-error"><h4>Error</h4><p>' + message + '</p></div>';
}

// ==================== Exports ====================

window.QuadraticSolverRender = {
    renderSolution: renderSolution,
    renderInequality: renderInequality,
    renderHorizontalSolution: renderHorizontalSolution,
    postRenderRoots: postRenderRoots,
    postRenderHorizontal: postRenderHorizontal,
    renderSteps: renderSteps,
    renderHorizontalSteps: renderHorizontalSteps,
    showError: showError,
    buildStepDOM: buildStepDOM,
    renderKaTeX: renderKaTeX,
    fmt: fmt
};

})();
