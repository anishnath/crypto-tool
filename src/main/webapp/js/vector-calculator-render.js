/**
 * Vector Calculator - Render Module
 * Step-by-step solution rendering with KaTeX + pure JS vector math
 */
(function() {
'use strict';

// ==================== Helpers ====================

function fmt(n) {
    if (typeof n === 'string') return n;
    if (Number.isInteger(n)) return String(n);
    var s = n.toFixed(6);
    return s.replace(/\.?0+$/, '') || '0';
}

function renderKaTeX(el, latex, displayMode) {
    try {
        katex.render(latex, el, { displayMode: displayMode !== false, throwOnError: false });
    } catch (e) {
        el.textContent = latex;
    }
}

function buildStepDOM(number, desc, latex) {
    var step = document.createElement('div');
    step.className = 'vc-step';

    var numEl = document.createElement('div');
    numEl.className = 'vc-step-number';
    numEl.textContent = number;
    step.appendChild(numEl);

    var content = document.createElement('div');
    content.className = 'vc-step-content';

    if (desc) {
        var descEl = document.createElement('div');
        descEl.className = 'vc-step-desc';
        descEl.innerHTML = desc;
        content.appendChild(descEl);
    }

    if (latex) {
        var mathEl = document.createElement('div');
        mathEl.className = 'vc-step-math';
        renderKaTeX(mathEl, latex, true);
        content.appendChild(mathEl);
    }

    step.appendChild(content);
    return step;
}

function vecTeX(v, name) {
    name = name || '';
    var prefix = name ? '\\vec{' + name + '} = ' : '';
    if (v.length === 2) {
        return prefix + '\\begin{pmatrix} ' + fmt(v[0]) + ' \\\\ ' + fmt(v[1]) + ' \\end{pmatrix}';
    }
    return prefix + '\\begin{pmatrix} ' + fmt(v[0]) + ' \\\\ ' + fmt(v[1]) + ' \\\\ ' + fmt(v[2]) + ' \\end{pmatrix}';
}

function scalarTeX(n) {
    return fmt(n);
}

// ==================== Pure JS Vector Math ====================

function vecAdd(a, b) {
    var r = [];
    for (var i = 0; i < a.length; i++) r.push(a[i] + b[i]);
    return r;
}

function vecSub(a, b) {
    var r = [];
    for (var i = 0; i < a.length; i++) r.push(a[i] - b[i]);
    return r;
}

function vecScale(a, k) {
    var r = [];
    for (var i = 0; i < a.length; i++) r.push(a[i] * k);
    return r;
}

function dot(a, b) {
    var s = 0;
    for (var i = 0; i < a.length; i++) s += a[i] * b[i];
    return s;
}

function cross(a, b) {
    return [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0]
    ];
}

function magnitude(v) {
    var s = 0;
    for (var i = 0; i < v.length; i++) s += v[i] * v[i];
    return Math.sqrt(s);
}

function unitVec(v) {
    var mag = magnitude(v);
    if (mag === 0) return null;
    var r = [];
    for (var i = 0; i < v.length; i++) r.push(v[i] / mag);
    return r;
}

function angle(a, b) {
    var magA = magnitude(a);
    var magB = magnitude(b);
    if (magA === 0 || magB === 0) return null;
    var cosTheta = dot(a, b) / (magA * magB);
    cosTheta = Math.max(-1, Math.min(1, cosTheta));
    var rad = Math.acos(cosTheta);
    return { radians: rad, degrees: rad * 180 / Math.PI };
}

function proj(a, b) {
    // projection of b onto a
    var d = dot(a, b);
    var magA2 = dot(a, a);
    if (magA2 === 0) return null;
    var scalar = d / magA2;
    return vecScale(a, scalar);
}

function rej(a, b) {
    // rejection of b from a (b - proj_a(b))
    var p = proj(a, b);
    if (!p) return null;
    return vecSub(b, p);
}

function parallelogramArea(a, b) {
    if (a.length === 3) {
        var c = cross(a, b);
        return magnitude(c);
    }
    // 2D: |a1*b2 - a2*b1|
    return Math.abs(a[0] * b[1] - a[1] * b[0]);
}

function tripleScalar(a, b, c) {
    var cr = cross(b, c);
    return dot(a, cr);
}

function isLinearlyIndependent(a, b) {
    if (a.length === 3) {
        var c = cross(a, b);
        return magnitude(c) > 1e-10;
    }
    // 2D: determinant
    var det = a[0] * b[1] - a[1] * b[0];
    return Math.abs(det) > 1e-10;
}

// ==================== Render Functions ====================

function renderAdd(container, a, b, dim) {
    container.innerHTML = '';
    var result = vecAdd(a, b);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Vector Addition</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\vec{a} + \\vec{b} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    var compParts = [];
    for (var i = 0; i < a.length; i++) {
        compParts.push(fmt(a[i]) + ' + ' + fmt(b[i]) + ' = ' + fmt(result[i]));
    }
    container.appendChild(buildStepDOM(2, '<strong>Add component-wise</strong>', compParts.join(', \\quad ')));
    container.appendChild(buildStepDOM(3, '<strong>Result</strong>', '\\vec{a} + \\vec{b} = ' + vecTeX(result)));

    return { result: result, type: 'vector' };
}

function renderSubtract(container, a, b, dim) {
    container.innerHTML = '';
    var result = vecSub(a, b);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Vector Subtraction</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\vec{a} - \\vec{b} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    var compParts = [];
    for (var i = 0; i < a.length; i++) {
        compParts.push(fmt(a[i]) + ' - (' + fmt(b[i]) + ') = ' + fmt(result[i]));
    }
    container.appendChild(buildStepDOM(2, '<strong>Subtract component-wise</strong>', compParts.join(', \\quad ')));
    container.appendChild(buildStepDOM(3, '<strong>Result</strong>', '\\vec{a} - \\vec{b} = ' + vecTeX(result)));

    return { result: result, type: 'vector' };
}

function renderScalarMultiply(container, a, k, dim) {
    container.innerHTML = '';
    var result = vecScale(a, k);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Scalar Multiplication</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, fmt(k) + ' \\cdot \\vec{a} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vector and scalar</strong>', vecTeX(a, 'a') + ', \\quad k = ' + fmt(k)));

    var compParts = [];
    for (var i = 0; i < a.length; i++) {
        compParts.push(fmt(k) + ' \\cdot ' + fmt(a[i]) + ' = ' + fmt(result[i]));
    }
    container.appendChild(buildStepDOM(2, '<strong>Multiply each component by k</strong>', compParts.join(', \\quad ')));
    container.appendChild(buildStepDOM(3, '<strong>Result</strong>', fmt(k) + ' \\vec{a} = ' + vecTeX(result)));

    return { result: result, type: 'vector' };
}

function renderDotProduct(container, a, b, dim) {
    container.innerHTML = '';
    var result = dot(a, b);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Dot Product</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\vec{a} \\cdot \\vec{b} = ' + fmt(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    var formula = '\\vec{a} \\cdot \\vec{b} = ';
    var terms = [];
    var compLabels = ['x', 'y', 'z'];
    for (var i = 0; i < a.length; i++) {
        terms.push('a_' + compLabels[i] + ' \\cdot b_' + compLabels[i]);
    }
    formula += terms.join(' + ');
    container.appendChild(buildStepDOM(2, '<strong>Apply dot product formula</strong>', formula));

    var compParts = [];
    for (var j = 0; j < a.length; j++) {
        compParts.push('(' + fmt(a[j]) + ')(' + fmt(b[j]) + ')');
    }
    container.appendChild(buildStepDOM(3, '<strong>Substitute values</strong>', '= ' + compParts.join(' + ')));

    var evalParts = [];
    for (var k = 0; k < a.length; k++) {
        evalParts.push(fmt(a[k] * b[k]));
    }
    container.appendChild(buildStepDOM(4, '<strong>Evaluate each term</strong>', '= ' + evalParts.join(' + ') + ' = ' + fmt(result)));

    // Geometric interpretation
    if (result === 0) {
        container.appendChild(buildStepDOM(5, '<strong>Interpretation</strong>', '\\vec{a} \\cdot \\vec{b} = 0 \\implies \\vec{a} \\perp \\vec{b} \\text{ (orthogonal)}'));
    }

    return { result: result, type: 'scalar' };
}

function renderCrossProduct(container, a, b) {
    container.innerHTML = '';
    var result = cross(a, b);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Cross Product</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\vec{a} \\times \\vec{b} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));
    container.appendChild(buildStepDOM(2, '<strong>Set up the determinant</strong>',
        '\\vec{a} \\times \\vec{b} = \\begin{vmatrix} \\hat{i} & \\hat{j} & \\hat{k} \\\\ ' +
        fmt(a[0]) + ' & ' + fmt(a[1]) + ' & ' + fmt(a[2]) + ' \\\\ ' +
        fmt(b[0]) + ' & ' + fmt(b[1]) + ' & ' + fmt(b[2]) + ' \\end{vmatrix}'));

    container.appendChild(buildStepDOM(3, '<strong>Expand along the first row</strong>',
        '= \\hat{i}(' + fmt(a[1]) + ' \\cdot ' + fmt(b[2]) + ' - ' + fmt(a[2]) + ' \\cdot ' + fmt(b[1]) + ')' +
        ' - \\hat{j}(' + fmt(a[0]) + ' \\cdot ' + fmt(b[2]) + ' - ' + fmt(a[2]) + ' \\cdot ' + fmt(b[0]) + ')' +
        ' + \\hat{k}(' + fmt(a[0]) + ' \\cdot ' + fmt(b[1]) + ' - ' + fmt(a[1]) + ' \\cdot ' + fmt(b[0]) + ')'));

    container.appendChild(buildStepDOM(4, '<strong>Compute each component</strong>',
        '= \\hat{i}(' + fmt(a[1] * b[2]) + ' - ' + fmt(a[2] * b[1]) + ')' +
        ' - \\hat{j}(' + fmt(a[0] * b[2]) + ' - ' + fmt(a[2] * b[0]) + ')' +
        ' + \\hat{k}(' + fmt(a[0] * b[1]) + ' - ' + fmt(a[1] * b[0]) + ')'));

    container.appendChild(buildStepDOM(5, '<strong>Result</strong>', '\\vec{a} \\times \\vec{b} = ' + vecTeX(result)));

    var mag = magnitude(result);
    container.appendChild(buildStepDOM(6, '<strong>Magnitude (area of parallelogram)</strong>', '|\\vec{a} \\times \\vec{b}| = ' + fmt(mag)));

    return { result: result, type: 'vector' };
}

function renderMagnitude(container, a, dim) {
    container.innerHTML = '';
    var result = magnitude(a);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Magnitude</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '|\\vec{a}| = ' + fmt(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vector</strong>', vecTeX(a, 'a')));

    var sqTerms = [];
    var compLabels = ['x', 'y', 'z'];
    for (var i = 0; i < a.length; i++) {
        sqTerms.push('a_' + compLabels[i] + '^2');
    }
    container.appendChild(buildStepDOM(2, '<strong>Apply magnitude formula</strong>', '|\\vec{a}| = \\sqrt{' + sqTerms.join(' + ') + '}'));

    var valTerms = [];
    for (var j = 0; j < a.length; j++) {
        valTerms.push(fmt(a[j]) + '^2');
    }
    container.appendChild(buildStepDOM(3, '<strong>Substitute values</strong>', '= \\sqrt{' + valTerms.join(' + ') + '}'));

    var sumTerms = [];
    var total = 0;
    for (var k = 0; k < a.length; k++) {
        sumTerms.push(fmt(a[k] * a[k]));
        total += a[k] * a[k];
    }
    container.appendChild(buildStepDOM(4, '<strong>Compute</strong>', '= \\sqrt{' + sumTerms.join(' + ') + '} = \\sqrt{' + fmt(total) + '} = ' + fmt(result)));

    return { result: result, type: 'scalar' };
}

function renderUnitVector(container, a, dim) {
    container.innerHTML = '';
    var mag = magnitude(a);

    if (mag === 0) {
        showError(container, 'Cannot compute unit vector of the zero vector.');
        return null;
    }

    var result = unitVec(a);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Unit Vector</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\hat{a} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vector</strong>', vecTeX(a, 'a')));
    container.appendChild(buildStepDOM(2, '<strong>Compute magnitude</strong>', '|\\vec{a}| = ' + fmt(mag)));
    container.appendChild(buildStepDOM(3, '<strong>Divide by magnitude</strong>', '\\hat{a} = \\frac{\\vec{a}}{|\\vec{a}|} = \\frac{1}{' + fmt(mag) + '}' + vecTeX(a)));
    container.appendChild(buildStepDOM(4, '<strong>Result</strong>', '\\hat{a} = ' + vecTeX(result)));

    // Verify
    container.appendChild(buildStepDOM(5, '<strong>Verify: magnitude = 1</strong>', '|\\hat{a}| = ' + fmt(magnitude(result))));

    return { result: result, type: 'vector' };
}

function renderAngle(container, a, b, dim) {
    container.innerHTML = '';
    var result = angle(a, b);

    if (!result) {
        showError(container, 'Cannot compute angle with a zero vector.');
        return null;
    }

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Angle Between Vectors</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\theta = ' + fmt(result.degrees) + '^\\circ');
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    var d = dot(a, b);
    var magA = magnitude(a);
    var magB = magnitude(b);
    container.appendChild(buildStepDOM(2, '<strong>Compute dot product</strong>', '\\vec{a} \\cdot \\vec{b} = ' + fmt(d)));
    container.appendChild(buildStepDOM(3, '<strong>Compute magnitudes</strong>', '|\\vec{a}| = ' + fmt(magA) + ', \\quad |\\vec{b}| = ' + fmt(magB)));

    var cosVal = d / (magA * magB);
    container.appendChild(buildStepDOM(4, '<strong>Apply formula</strong>', '\\cos\\theta = \\frac{\\vec{a} \\cdot \\vec{b}}{|\\vec{a}||\\vec{b}|} = \\frac{' + fmt(d) + '}{' + fmt(magA) + ' \\cdot ' + fmt(magB) + '} = ' + fmt(cosVal)));
    container.appendChild(buildStepDOM(5, '<strong>Result</strong>', '\\theta = \\arccos(' + fmt(cosVal) + ') = ' + fmt(result.radians) + ' \\text{ rad} = ' + fmt(result.degrees) + '^\\circ'));

    return { result: result, type: 'angle' };
}

function renderProjection(container, a, b, dim) {
    container.innerHTML = '';
    var result = proj(a, b);

    if (!result) {
        showError(container, 'Cannot project onto the zero vector.');
        return null;
    }

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Vector Projection</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\text{proj}_{\\vec{a}} \\vec{b} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    var d = dot(a, b);
    var magA2 = dot(a, a);
    container.appendChild(buildStepDOM(2, '<strong>Compute dot products</strong>', '\\vec{a} \\cdot \\vec{b} = ' + fmt(d) + ', \\quad \\vec{a} \\cdot \\vec{a} = ' + fmt(magA2)));

    var scalar = d / magA2;
    container.appendChild(buildStepDOM(3, '<strong>Compute scalar coefficient</strong>', '\\frac{\\vec{a} \\cdot \\vec{b}}{\\vec{a} \\cdot \\vec{a}} = \\frac{' + fmt(d) + '}{' + fmt(magA2) + '} = ' + fmt(scalar)));
    container.appendChild(buildStepDOM(4, '<strong>Multiply by direction vector</strong>', '\\text{proj}_{\\vec{a}} \\vec{b} = ' + fmt(scalar) + ' \\cdot ' + vecTeX(a) + ' = ' + vecTeX(result)));

    return { result: result, type: 'vector' };
}

function renderRejection(container, a, b, dim) {
    container.innerHTML = '';
    var p = proj(a, b);
    if (!p) {
        showError(container, 'Cannot compute rejection from the zero vector.');
        return null;
    }
    var result = vecSub(b, p);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Vector Rejection</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\text{rej}_{\\vec{a}} \\vec{b} = ' + vecTeX(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));
    container.appendChild(buildStepDOM(2, '<strong>Compute projection</strong>', '\\text{proj}_{\\vec{a}} \\vec{b} = ' + vecTeX(p)));
    container.appendChild(buildStepDOM(3, '<strong>Subtract projection from b</strong>', '\\text{rej}_{\\vec{a}} \\vec{b} = \\vec{b} - \\text{proj}_{\\vec{a}} \\vec{b}'));
    container.appendChild(buildStepDOM(4, '<strong>Result</strong>', '= ' + vecTeX(b) + ' - ' + vecTeX(p) + ' = ' + vecTeX(result)));

    // Verify orthogonality
    var d = dot(result, p);
    container.appendChild(buildStepDOM(5, '<strong>Verify orthogonality</strong>', '\\text{rej} \\cdot \\text{proj} = ' + fmt(d) + (Math.abs(d) < 1e-10 ? ' \\approx 0 \\;\\checkmark' : '')));

    return { result: result, type: 'vector' };
}

function renderArea(container, a, b, dim) {
    container.innerHTML = '';
    var result = parallelogramArea(a, b);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Parallelogram Area</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\text{Area} = ' + fmt(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    if (dim === 3) {
        var c = cross(a, b);
        container.appendChild(buildStepDOM(2, '<strong>Compute cross product</strong>', '\\vec{a} \\times \\vec{b} = ' + vecTeX(c)));
        container.appendChild(buildStepDOM(3, '<strong>Area = magnitude of cross product</strong>', '\\text{Area} = |\\vec{a} \\times \\vec{b}| = ' + fmt(result)));
    } else {
        container.appendChild(buildStepDOM(2, '<strong>Apply 2D formula</strong>', '\\text{Area} = |a_x b_y - a_y b_x|'));
        container.appendChild(buildStepDOM(3, '<strong>Substitute</strong>', '= |' + fmt(a[0]) + ' \\cdot ' + fmt(b[1]) + ' - ' + fmt(a[1]) + ' \\cdot ' + fmt(b[0]) + '| = |' + fmt(a[0] * b[1] - a[1] * b[0]) + '| = ' + fmt(result)));
    }

    return { result: result, type: 'scalar' };
}

function renderTripleScalar(container, a, b, c) {
    container.innerHTML = '';
    var result = tripleScalar(a, b, c);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Triple Scalar Product</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, '\\vec{a} \\cdot (\\vec{b} \\times \\vec{c}) = ' + fmt(result));
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b') + ', \\quad ' + vecTeX(c, 'c')));

    var cr = cross(b, c);
    container.appendChild(buildStepDOM(2, '<strong>Compute b &times; c</strong>', '\\vec{b} \\times \\vec{c} = ' + vecTeX(cr)));
    container.appendChild(buildStepDOM(3, '<strong>Compute a &middot; (b &times; c)</strong>', '\\vec{a} \\cdot ' + vecTeX(cr) + ' = ' + fmt(result)));

    // Geometric interpretation
    container.appendChild(buildStepDOM(4, '<strong>Volume of parallelepiped</strong>', '\\text{Volume} = |\\vec{a} \\cdot (\\vec{b} \\times \\vec{c})| = ' + fmt(Math.abs(result))));

    if (Math.abs(result) < 1e-10) {
        container.appendChild(buildStepDOM(5, '<strong>Interpretation</strong>', '\\text{Volume} = 0 \\implies \\text{vectors are coplanar}'));
    }

    return { result: result, type: 'scalar' };
}

function renderLinearIndependence(container, a, b, dim) {
    container.innerHTML = '';
    var independent = isLinearlyIndependent(a, b);

    var badge = document.createElement('div');
    badge.innerHTML = '<span class="vc-result-badge">Linear Independence</span>';
    container.appendChild(badge);

    var mainMath = document.createElement('div');
    mainMath.className = 'vc-result-math';
    renderKaTeX(mainMath, independent ? '\\text{Linearly Independent}' : '\\text{Linearly Dependent}');
    container.appendChild(mainMath);

    container.appendChild(buildStepDOM(1, '<strong>Write the vectors</strong>', vecTeX(a, 'a') + ', \\quad ' + vecTeX(b, 'b')));

    if (dim === 3) {
        var c = cross(a, b);
        container.appendChild(buildStepDOM(2, '<strong>Compute cross product</strong>', '\\vec{a} \\times \\vec{b} = ' + vecTeX(c)));
        var mag = magnitude(c);
        container.appendChild(buildStepDOM(3, '<strong>Check if cross product is zero</strong>', '|\\vec{a} \\times \\vec{b}| = ' + fmt(mag)));
        container.appendChild(buildStepDOM(4, '<strong>Result</strong>',
            independent
                ? '|\\vec{a} \\times \\vec{b}| \\neq 0 \\implies \\text{linearly independent}'
                : '|\\vec{a} \\times \\vec{b}| = 0 \\implies \\text{linearly dependent (parallel)}'
        ));
    } else {
        var det = a[0] * b[1] - a[1] * b[0];
        container.appendChild(buildStepDOM(2, '<strong>Compute 2D determinant</strong>',
            '\\det \\begin{pmatrix} ' + fmt(a[0]) + ' & ' + fmt(b[0]) + ' \\\\ ' + fmt(a[1]) + ' & ' + fmt(b[1]) + ' \\end{pmatrix} = ' + fmt(a[0]) + ' \\cdot ' + fmt(b[1]) + ' - ' + fmt(a[1]) + ' \\cdot ' + fmt(b[0]) + ' = ' + fmt(det)));
        container.appendChild(buildStepDOM(3, '<strong>Result</strong>',
            independent
                ? '\\det \\neq 0 \\implies \\text{linearly independent}'
                : '\\det = 0 \\implies \\text{linearly dependent (parallel)}'
        ));
    }

    return { result: independent, type: 'boolean' };
}

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div class="vc-error"><h4>Error</h4><p>' + message + '</p></div>';
}

function showAISteps(container, steps, method) {
    if (!container) return;
    var wrapper = document.createElement('div');
    wrapper.className = 'vc-steps-container';

    var header = document.createElement('div');
    header.className = 'vc-steps-header';
    header.textContent = (method || 'AI') + ' \u2014 Step-by-Step Solution';
    wrapper.appendChild(header);

    var body = document.createElement('div');
    body.style.padding = '0.5rem';
    for (var i = 0; i < steps.length; i++) {
        var s = steps[i];
        body.appendChild(buildStepDOM(i + 1, s.description || s.title || s.t || '', s.latex || s.math || s.l || ''));
    }
    wrapper.appendChild(body);
    container.appendChild(wrapper);
}

// ==================== Exports ====================

window.VecCalcRender = {
    fmt: fmt,
    renderKaTeX: renderKaTeX,
    buildStepDOM: buildStepDOM,
    vecTeX: vecTeX,
    vecAdd: vecAdd,
    vecSub: vecSub,
    vecScale: vecScale,
    dot: dot,
    cross: cross,
    magnitude: magnitude,
    unitVec: unitVec,
    angle: angle,
    proj: proj,
    rej: rej,
    parallelogramArea: parallelogramArea,
    tripleScalar: tripleScalar,
    isLinearlyIndependent: isLinearlyIndependent,
    renderAdd: renderAdd,
    renderSubtract: renderSubtract,
    renderScalarMultiply: renderScalarMultiply,
    renderDotProduct: renderDotProduct,
    renderCrossProduct: renderCrossProduct,
    renderMagnitude: renderMagnitude,
    renderUnitVector: renderUnitVector,
    renderAngle: renderAngle,
    renderProjection: renderProjection,
    renderRejection: renderRejection,
    renderArea: renderArea,
    renderTripleScalar: renderTripleScalar,
    renderLinearIndependence: renderLinearIndependence,
    showError: showError,
    showAISteps: showAISteps
};

})();
