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

    html += '</div>';
    return html;
}

function renderInequality(result) {
    var html = '<div class="qs-result-section">';
    html += '<div class="qs-result-badge qs-badge-info">Inequality Solution</div>';
    html += '<div class="qs-result-label">Solution Set</div>';
    html += '<div class="qs-result-math" id="qs-root-math"></div>';
    html += '<div class="qs-result-detail">' + result.intervalHtml + '</div>';
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
    var disc = result.disc, roots = result.roots;
    var frag = document.createDocumentFragment();

    if (roots.type === 'complex') {
        var warn = document.createElement('div');
        warn.className = 'qs-error';
        warn.innerHTML = '<h4>Cannot Factor Over Reals</h4><p>Complex roots &mdash; use the quadratic formula or completing the square.</p>';
        frag.appendChild(warn);
        return frag;
    }

    var isRational = function(n) { return Math.abs(n - Math.round(n)) < 0.0001; };

    if (isRational(roots.x1) && isRational(roots.x2)) {
        var r1 = Math.round(roots.x1), r2 = Math.round(roots.x2);

        frag.appendChild(buildStepDOM(1, '<strong>Find two numbers</strong> that multiply to ac = ' + fmt(a * c) + ' and add to b = ' + fmt(b),
            fmt(a * c) + ' = (' + fmt(-a * r1) + ')(' + fmt(-a * r2 / a) + '), \\quad ' + fmt(-a * r1) + ' + ' + fmt(-a * r2 / a) + ' = ' + fmt(b)));

        var r1Sign = r1 >= 0 ? '-' : '+';
        var r2Sign = r2 >= 0 ? '-' : '+';
        frag.appendChild(buildStepDOM(2, '<strong>Write in factored form</strong>',
            fmtLeading(a, '') + '(x ' + r1Sign + ' ' + fmt(Math.abs(r1)) + ')(x ' + r2Sign + ' ' + fmt(Math.abs(r2)) + ') = 0'));

        frag.appendChild(buildStepDOM(3, '<strong>Set each factor to zero</strong>',
            'x = ' + fmt(r1) + ' \\quad \\text{or} \\quad x = ' + fmt(r2)));
    } else {
        var warn2 = document.createElement('div');
        warn2.className = 'qs-error';
        warn2.innerHTML = '<h4>Irrational Roots</h4><p>This equation does not factor neatly over the integers. Roots: x&#8321; = ' + fmt(roots.x1) + ', x&#8322; = ' + fmt(roots.x2) + '</p>';
        frag.appendChild(warn2);
    }

    return frag;
}

function renderInequalitySteps(result) {
    var a = result.a, b = result.b, c = result.c;
    var roots = result.roots, op = result.operator;
    var frag = document.createDocumentFragment();

    if (roots.type === 'complex') {
        var desc = a > 0 ? 'Parabola opens upward with no real roots.' : 'Parabola opens downward with no real roots.';
        frag.appendChild(buildStepDOM(1, '<strong>Discriminant is negative</strong> &mdash; ' + desc, '\\Delta = ' + fmt(result.disc) + ' < 0'));
        return frag;
    }

    var x1 = Math.min(roots.x1, roots.x2);
    var x2 = Math.max(roots.x1, roots.x2);

    frag.appendChild(buildStepDOM(1, '<strong>Find the roots</strong>',
        'x_1 = ' + fmt(x1) + ', \\quad x_2 = ' + fmt(x2)));

    frag.appendChild(buildStepDOM(2, '<strong>Test intervals</strong>: The parabola opens ' + (a > 0 ? 'upward' : 'downward'),
        '(-\\infty, ' + fmt(x1) + '), \\quad (' + fmt(x1) + ', ' + fmt(x2) + '), \\quad (' + fmt(x2) + ', +\\infty)'));

    var signInfo;
    if (a > 0) {
        signInfo = 'Positive outside roots, negative between roots';
    } else {
        signInfo = 'Negative outside roots, positive between roots';
    }
    frag.appendChild(buildStepDOM(3, '<strong>Sign chart:</strong> ' + signInfo, null));

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
    postRenderRoots: postRenderRoots,
    renderSteps: renderSteps,
    showError: showError,
    buildStepDOM: buildStepDOM,
    renderKaTeX: renderKaTeX,
    fmt: fmt
};

})();
