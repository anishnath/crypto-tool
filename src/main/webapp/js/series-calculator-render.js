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
    // For multi-line aligned blocks, fall back to line-by-line rendering if aligned fails
    try {
        renderKaTeX(math, latex, true);
        // Check if rendering produced an error node
        if (math.querySelector('.katex-error')) throw new Error('fallback');
    } catch (e) {
        // Fall back: split on \\[Xpt] and render line by line
        math.innerHTML = '';
        var lines = latex.replace(/\\begin\{aligned\}&?/g, '').replace(/\\end\{aligned\}/g, '').split(/\\\\\[\d+pt\]&?/);
        for (var li = 0; li < lines.length; li++) {
            var line = lines[li].trim();
            if (!line) continue;
            var lineDiv = document.createElement('div');
            lineDiv.style.cssText = 'margin-bottom:0.25rem;';
            renderKaTeX(lineDiv, line, true);
            math.appendChild(lineDiv);
        }
    }

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

function buildStepDOMMulti(number, description, latexLines) {
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
    content.appendChild(desc);

    for (var i = 0; i < latexLines.length; i++) {
        var lineDiv = document.createElement('div');
        lineDiv.className = 'sc-step-math';
        if (i < latexLines.length - 1) lineDiv.style.marginBottom = '0.375rem';
        renderKaTeX(lineDiv, latexLines[i], true);
        content.appendChild(lineDiv);
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

function isPolynomialTerminating(derivs, numTerms) {
    // Check if all trailing coefficients are zero — means the series terminates
    for (var n = numTerms - 1; n >= 0; n--) {
        if (Math.abs(derivs[n] / factorial(n)) >= 1e-12) {
            // Check if all derivatives beyond this point would also be zero
            // For a polynomial of degree d, the (d+1)th derivative is zero
            // We detect this by checking if the last computed derivative is zero
            return Math.abs(derivs[numTerms - 1] / factorial(numTerms - 1)) < 1e-12;
        }
    }
    return true;
}

function buildSeriesLatex(derivs, numTerms, center, skipEllipsis) {
    var latex = '';
    var terminates = skipEllipsis || isPolynomialTerminating(derivs, numTerms);
    for (var n = 0; n < numTerms; n++) {
        var coeff = derivs[n] / factorial(n);
        if (Math.abs(coeff) < 1e-12 && n > 0) continue; // skip zero terms

        if (n > 0 && coeff >= 0 && latex) latex += ' + ';
        else if (n > 0 && coeff < 0) latex += ' ';

        if (n === 0) {
            latex += fmt(coeff);
        } else {
            var absCoeff = Math.abs(coeff);
            var coeffStr = absCoeff === 1 ? (coeff < 0 ? '-' : '') : fmt(coeff);
            var xTerm = center === 0 ? 'x' : (center < 0 ? '(x + ' + fmt(Math.abs(center)) + ')' : '(x - ' + fmt(center) + ')');
            var power = n === 1 ? '' : '^{' + n + '}';
            latex += coeffStr + xTerm + power;
        }
    }
    if (!terminates) latex += ' + \\cdots';
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

function renderSteps(container, derivs, numTerms, center, derivativeLatexes, derivativeTexts) {
    if (!container) return;
    container.innerHTML = '';

    var seriesName = center === 0 ? 'Maclaurin' : 'Taylor';
    var stepNum = 0;

    // Steps header
    var header = document.createElement('div');
    header.className = 'sc-steps-header';
    header.innerHTML = '<h4>Step-by-Step Solution</h4><p>' + seriesName + ' series expansion with ' + numTerms + ' terms centered at a = ' + fmt(center) + '</p>';
    container.appendChild(header);

    // ===== Step 1: Recall the formula =====
    stepNum++;
    var centerLatex = fmt(center);
    var shiftLatex = center === 0 ? 'x' : (center < 0 ? '(x + ' + fmt(Math.abs(center)) + ')' : '(x - ' + fmt(center) + ')');
    var formulaLatex = center === 0
        ? 'f(x) = \\sum_{n=0}^{\\infty} \\frac{f^{(n)}(0)}{n!}\\,x^n = f(0) + f\'(0)\\,x + \\frac{f\'\'(0)}{2!}x^2 + \\cdots'
        : 'f(x) = \\sum_{n=0}^{\\infty} \\frac{f^{(n)}(' + centerLatex + ')}{n!}' + shiftLatex + '^n';
    container.appendChild(buildStepDOM(
        stepNum,
        'Recall the <strong>' + seriesName + ' series formula</strong>',
        formulaLatex,
        null
    ));

    // ===== Steps 2..N+1: Each derivative =====
    for (var n = 0; n < numTerms; n++) {
        stepNum++;
        var value = derivs[n];
        var fNotation = n === 0 ? 'f' :
                        n === 1 ? "f'" :
                        n === 2 ? "f''" :
                        n === 3 ? "f'''" :
                        'f^{(' + n + ')}';

        // Description
        var desc;
        if (n === 0) {
            desc = 'Evaluate the original function at <strong>x = ' + fmt(center) + '</strong>' +
                   '<span class="sc-term-badge">n = 0</span>';
        } else {
            desc = 'Compute the <strong>' + getOrdinal(n) + ' derivative</strong> and evaluate at <strong>x = ' + fmt(center) + '</strong>' +
                   '<span class="sc-term-badge">n = ' + n + '</span>';
        }

        // Show derivative expression if available
        var derivExprLatex = '';
        if (derivativeLatexes && derivativeLatexes[n]) {
            if (n === 0) {
                derivExprLatex = 'f(x) = ' + derivativeLatexes[n];
            } else {
                derivExprLatex = fNotation + '(x) = ' + derivativeLatexes[n];
            }
        }

        // Show evaluation
        var evalLatex = fNotation + '(' + fmt(center) + ') = ' + fmt(value);

        // Show coefficient = f^(n)(a) / n! with symbolic fraction from nerdamer
        var factN = factorial(n);
        var coeff = value / factN;
        var coeffTex = fmt(coeff);

        // Try to get symbolic fraction using nerdamer
        if (window.nerdamer && derivativeTexts && derivativeTexts[n]) {
            try {
                var symbolicCoeff = nerdamer('(' + derivativeTexts[n] + ')/' + factN).evaluate({ x: center });
                coeffTex = symbolicCoeff.toTeX();
            } catch (e) {
                // fallback to decimal
            }
        }

        var coeffLatex = '\\frac{' + fNotation + '(' + fmt(center) + ')}{' + n + '!} = \\frac{' + fmt(value) + '}{' + factN + '} = ' + coeffTex;

        // Show the resulting term
        var xPart = '';
        var centerTerm = center === 0 ? 'x' : (center < 0 ? '(x + ' + fmt(Math.abs(center)) + ')' : '(x - ' + fmt(center) + ')');
        if (n === 0) {
            xPart = '';
        } else if (n === 1) {
            xPart = '\\,' + centerTerm;
        } else {
            xPart = '\\,' + centerTerm + '^{' + n + '}';
        }
        var termResultLatex = '\\text{Term } ' + n + ' = ' + coeffTex + xPart;

        // Build array of LaTeX lines to render separately
        var latexLines = [];
        if (derivExprLatex) {
            latexLines.push(derivExprLatex);
        }
        latexLines.push(evalLatex);
        latexLines.push(coeffLatex);
        latexLines.push('\\boxed{' + termResultLatex + '}');

        container.appendChild(buildStepDOMMulti(stepNum, desc, latexLines));
    }

    // ===== Final Step: Plug into the Taylor Formula =====
    stepNum++;
    var formulaParts = [];
    var asmCenterTerm = center === 0 ? 'x' : (center < 0 ? '(x + ' + fmt(Math.abs(center)) + ')' : '(x - ' + fmt(center) + ')');
    for (var i = 0; i < numTerms; i++) {
        var c = derivs[i] / factorial(i);
        // Skip zero-coefficient terms (except the constant term if it's the only one so far)
        if (Math.abs(c) < 1e-12 && (formulaParts.length > 0 || i < numTerms - 1)) continue;

        var fmtDeriv = fmt(derivs[i]);
        var fmtFact = String(factorial(i));
        var power = i === 1 ? '' : '^{' + i + '}';
        var termStr;
        if (i === 0) {
            termStr = '\\frac{' + fmtDeriv + '}{' + fmtFact + '}';
        } else {
            termStr = '\\frac{' + fmtDeriv + '}{' + fmtFact + '}' + asmCenterTerm + power;
        }
        if (formulaParts.length > 0 && derivs[i] >= 0) {
            formulaParts.push(' + ' + termStr);
        } else {
            formulaParts.push(termStr);
        }
    }
    if (formulaParts.length === 0) formulaParts.push('0');

    var terminates = isPolynomialTerminating(derivs, numTerms);
    var plugLatex = 'f(x) = ' + formulaParts.join('') + (terminates ? '' : ' + \\cdots');

    container.appendChild(buildStepDOM(
        stepNum,
        '<strong>Plug into the Taylor formula</strong>',
        plugLatex,
        null
    ));

    // ===== Final Simplified Solution =====
    stepNum++;

    // Build Nerdamer-based simplified result as immediate fallback
    var simplifiedParts = [];
    for (var i = 0; i < numTerms; i++) {
        var c = derivs[i] / factorial(i);
        if (Math.abs(c) < 1e-12 && (simplifiedParts.length > 0 || i < numTerms - 1)) continue;

        var symCoeffTex = '';
        if (window.nerdamer && derivativeTexts && derivativeTexts[i]) {
            try {
                var sc = nerdamer('(' + derivativeTexts[i] + ')/' + factorial(i)).evaluate({ x: center });
                symCoeffTex = sc.toTeX();
            } catch (e) {}
        }
        if (!symCoeffTex) symCoeffTex = fmt(c);

        var termStr;
        if (i === 0) {
            termStr = symCoeffTex;
        } else {
            var power = i === 1 ? '' : '^{' + i + '}';
            var absC = Math.abs(c);
            if (Math.abs(absC - 1) < 1e-12) {
                termStr = (c < 0 ? '-' : '') + asmCenterTerm + power;
            } else {
                termStr = symCoeffTex + '\\,' + asmCenterTerm + power;
            }
        }
        if (simplifiedParts.length > 0 && c >= 0) {
            simplifiedParts.push(' + ' + termStr);
        } else {
            simplifiedParts.push(termStr);
        }
    }
    if (simplifiedParts.length === 0) simplifiedParts.push('0');
    var eq = terminates ? '=' : '\\approx';
    var simplifiedLatex = '\\boxed{f(x) ' + eq + ' ' + simplifiedParts.join('') + (terminates ? '' : ' + \\cdots') + '}';

    // Build the step with a SymPy target area
    var step = document.createElement('div');
    step.className = 'sc-step';

    var numEl = document.createElement('div');
    numEl.className = 'sc-step-number';
    numEl.textContent = stepNum;

    var content = document.createElement('div');
    content.className = 'sc-step-content';

    var desc = document.createElement('div');
    desc.className = 'sc-step-desc';
    desc.innerHTML = '<strong>Final Simplified Solution</strong>';

    // Nerdamer result (shown immediately)
    var nerdamerResult = document.createElement('div');
    nerdamerResult.className = 'sc-step-math';
    renderKaTeX(nerdamerResult, simplifiedLatex, true);

    // SymPy result placeholder (will be filled async, replaces Nerdamer result)
    var sympyTarget = document.createElement('div');
    sympyTarget.id = 'sc-sympy-simplified';

    content.appendChild(desc);
    content.appendChild(nerdamerResult);
    content.appendChild(sympyTarget);
    step.appendChild(numEl);
    step.appendChild(content);
    container.appendChild(step);
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
    buildStepDOMMulti: buildStepDOMMulti,
    buildSeriesLatex: buildSeriesLatex,
    isPolynomialTerminating: isPolynomialTerminating,
    renderResult: renderResult,
    renderSteps: renderSteps,
    renderConvergence: renderConvergence,
    showError: showError
};

})();
