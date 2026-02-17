/**
 * Series Calculator - Render Module
 * KaTeX step-by-step rendering for Taylor/Maclaurin series
 */
(function() {
'use strict';

// ==================== Helpers ====================

function fmt(n) {
    if (n === 0) return '0';
    if (Math.abs(n) < 0.0001 && n !== 0) return n.toExponential(4);
    if (Math.abs(n - Math.round(n)) < 0.0001) return String(Math.round(n));
    return n.toFixed(6).replace(/\.?0+$/, '');
}

function factorial(n) {
    if (n === 0 || n === 1) return 1;
    var r = 1;
    for (var i = 2; i <= n; i++) r *= i;
    return r;
}

function renderKaTeX(el, latex, displayMode) {
    if (!el || !window.katex) return;
    try {
        katex.render(latex, el, { displayMode: displayMode !== false, throwOnError: false });
    } catch (e) {
        el.textContent = latex;
    }
}

function buildStepDOM(number, description, latex, extraLatex) {
    var step = document.createElement('div');
    step.className = 'sc-step';

    var numEl = document.createElement('div');
    numEl.className = 'sc-step-number';
    numEl.textContent = number;

    var content = document.createElement('div');
    content.className = 'sc-step-content';

    var desc = document.createElement('div');
    desc.className = 'sc-step-desc';
    desc.innerHTML = description;

    var math = document.createElement('div');
    math.className = 'sc-step-math';
    renderKaTeX(math, latex, true);

    content.appendChild(desc);
    content.appendChild(math);

    if (extraLatex) {
        var extra = document.createElement('div');
        extra.className = 'sc-step-derivative';
        renderKaTeX(extra, extraLatex, true);
        content.appendChild(extra);
    }

    step.appendChild(numEl);
    step.appendChild(content);
    return step;
}

function getOrdinal(n) {
    var ords = ['', '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th',
                '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th', '19th', '20th'];
    return n < ords.length ? ords[n] : n + 'th';
}

// ==================== Series LaTeX Builder ====================

function buildSeriesLatex(derivs, numTerms, center) {
    var latex = '';
    for (var n = 0; n < numTerms; n++) {
        var coeff = derivs[n] / factorial(n);
        if (n > 0 && coeff >= 0) latex += ' + ';
        else if (n > 0) latex += ' ';

        if (n === 0) {
            latex += fmt(coeff);
        } else {
            var absCoeff = Math.abs(coeff);
            var coeffStr = absCoeff === 1 ? (coeff < 0 ? '-' : '') : fmt(coeff);
            var xTerm = center === 0 ? 'x' : '(x - ' + fmt(center) + ')';
            var power = n === 1 ? '' : '^{' + n + '}';
            latex += coeffStr + xTerm + power;
        }
    }
    latex += ' + \\cdots';
    return latex;
}

// ==================== Main Renderers ====================

function renderResult(container, funcLatex, derivs, numTerms, center, seriesType) {
    if (!container) return;
    container.innerHTML = '';

    // Original function
    var funcDiv = document.createElement('div');
    funcDiv.style.cssText = 'margin-bottom:0.75rem;';
    renderKaTeX(funcDiv, 'f(x) = ' + funcLatex, true);
    container.appendChild(funcDiv);

    // Series name badge
    var badge = document.createElement('div');
    badge.className = 'sc-formula-box';
    var seriesName = seriesType === 'maclaurin' ? 'Maclaurin' : 'Taylor';
    badge.innerHTML = '<strong>' + seriesName + ' Series around x = ' + fmt(center) + '</strong>';
    container.appendChild(badge);

    // Series expansion
    var seriesDiv = document.createElement('div');
    seriesDiv.style.cssText = 'margin-top:0.75rem;overflow-x:auto;';
    var seriesLatex = buildSeriesLatex(derivs, numTerms, center);
    renderKaTeX(seriesDiv, 'f(x) \\approx ' + seriesLatex, true);
    container.appendChild(seriesDiv);
}

function renderSteps(container, derivs, numTerms, center, derivativeLatexes) {
    if (!container) return;
    container.innerHTML = '';

    for (var n = 0; n < numTerms; n++) {
        var value = derivs[n];
        var fNotation = n === 0 ? 'f' :
                        n === 1 ? "f'" :
                        n === 2 ? "f''" :
                        n === 3 ? "f'''" :
                        'f^{(' + n + ')}';

        var desc = n === 0 ?
            'Evaluate function at x = ' + fmt(center) + '<span class="sc-term-badge">Term ' + (n + 1) + '</span>' :
            'Calculate ' + getOrdinal(n) + ' derivative at x = ' + fmt(center) + '<span class="sc-term-badge">Term ' + (n + 1) + '</span>';

        var stepLatex = fNotation + '(' + fmt(center) + ') = ' + fmt(value);

        // Show the term contribution
        var factN = factorial(n);
        var termLatex = '\\text{Term: } \\frac{' + fmt(value) + '}{' + factN + '}';
        if (n === 0) {
            // no x term
        } else if (n === 1) {
            termLatex += center === 0 ? 'x' : '(x - ' + fmt(center) + ')';
        } else {
            termLatex += center === 0 ? 'x^{' + n + '}' : '(x - ' + fmt(center) + ')^{' + n + '}';
        }

        var derivLatex = derivativeLatexes && derivativeLatexes[n] ? derivativeLatexes[n] : null;

        container.appendChild(buildStepDOM(n + 1, desc, stepLatex, derivLatex));
    }
}

function renderConvergence(container, funcStr) {
    if (!container) return;
    container.innerHTML = '';

    var box = document.createElement('div');
    box.className = 'sc-convergence';

    var info = '';
    if (funcStr.indexOf('exp') !== -1 || funcStr === 'e ^ x' || funcStr === 'e^x') {
        info = '<h4>Radius of Convergence: R = &infin;</h4><p>The exponential function e<sup>x</sup> converges for all real numbers.</p>';
    } else if (funcStr.indexOf('sin') !== -1 || funcStr.indexOf('cos') !== -1) {
        info = '<h4>Radius of Convergence: R = &infin;</h4><p>Trigonometric functions sin(x) and cos(x) converge for all real numbers.</p>';
    } else if (funcStr.indexOf('ln') !== -1 || funcStr.indexOf('log') !== -1) {
        info = '<h4>Radius of Convergence: R = 1 (for ln(1+x))</h4><p>The series converges for &minus;1 &lt; x &le; 1.</p>';
    } else if (funcStr.indexOf('1 / (1') !== -1 || funcStr.indexOf('1/(1') !== -1) {
        info = '<h4>Radius of Convergence: R = 1</h4><p>The geometric series converges for |x| &lt; 1.</p>';
    } else if (funcStr.indexOf('tan') !== -1) {
        info = '<h4>Radius of Convergence: R = &pi;/2</h4><p>The tangent series converges within (&minus;&pi;/2, &pi;/2).</p>';
    } else if (funcStr.indexOf('sqrt') !== -1) {
        info = '<h4>Radius of Convergence: R = 1</h4><p>The binomial series for &radic;(1+x) converges for |x| &le; 1.</p>';
    } else {
        info = '<h4>Convergence Analysis</h4><p>The radius of convergence depends on the nearest singularity. Use the ratio test: R = lim(n&rarr;&infin;) |a<sub>n</sub>/a<sub>n+1</sub>|</p>';
    }

    box.innerHTML = info;
    container.appendChild(box);
}

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div style="padding:1rem;background:#fef2f2;border-left:3px solid #ef4444;border-radius:0.5rem;color:#dc2626;font-size:0.8125rem;">' + message + '</div>';
}

// ==================== Exports ====================

window.SeriesCalcRender = {
    fmt: fmt,
    factorial: factorial,
    renderKaTeX: renderKaTeX,
    buildStepDOM: buildStepDOM,
    buildSeriesLatex: buildSeriesLatex,
    renderResult: renderResult,
    renderSteps: renderSteps,
    renderConvergence: renderConvergence,
    showError: showError
};

})();
