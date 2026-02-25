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

    // Build the final simplified solution step
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

    // Exact result placeholder (will be filled async)
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

// ==================== Remainder Result ====================

function renderRemainderResult(data, container) {
    if (!container) return;
    container.innerHTML = '';

    // Hide empty state
    var empty = document.getElementById('sc-empty-state');
    if (empty) empty.style.display = 'none';

    // Title
    var title = document.createElement('div');
    title.className = 'sc-formula-box';
    title.innerHTML = '<strong>Lagrange Remainder / Error Bound</strong>';
    container.appendChild(title);

    // Remainder formula box
    var box = document.createElement('div');
    box.className = 'sc-remainder-box';

    var h4 = document.createElement('h4');
    h4.textContent = 'Remainder Formula';
    box.appendChild(h4);

    if (data.latexRemainder) {
        var mathDiv = document.createElement('div');
        mathDiv.className = 'sc-step-math';
        renderKaTeX(mathDiv, data.latexRemainder, true);
        box.appendChild(mathDiv);
    }

    // Upper bound
    if (data.bound !== undefined) {
        var boundRow = document.createElement('div');
        boundRow.className = 'sc-result-row';
        boundRow.innerHTML = '<span>Upper bound |R<sub>n</sub>(x)| &le;</span> <strong>' + data.bound + '</strong>';
        box.appendChild(boundRow);
    }

    // Actual error
    if (data.actualError !== undefined) {
        var errRow = document.createElement('div');
        errRow.className = 'sc-result-row';
        errRow.innerHTML = '<span>Actual error |f(x) &minus; P<sub>n</sub>(x)| =</span> <strong>' + data.actualError + '</strong>';
        box.appendChild(errRow);
    }

    // Comparison
    if (data.bound !== undefined && data.actualError !== undefined) {
        var cmp = document.createElement('div');
        cmp.style.cssText = 'margin-top:0.5rem;font-size:0.8125rem;padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;';
        var actualNum = parseFloat(data.actualError);
        var boundNum = parseFloat(data.bound);
        if (!isNaN(actualNum) && !isNaN(boundNum) && actualNum <= boundNum) {
            cmp.innerHTML = '<span style="color:#059669;">&#10003;</span> Actual error is within the Lagrange bound, as expected.';
        } else {
            cmp.innerHTML = '<span style="color:#d97706;">&#9888;</span> Bound verification — check interval for max derivative.';
        }
        box.appendChild(cmp);
    }

    container.appendChild(box);

    // Taylor polynomial
    if (data.latexPoly) {
        var polyBox = document.createElement('div');
        polyBox.style.cssText = 'margin-top:0.75rem;';
        var polyLabel = document.createElement('div');
        polyLabel.style.cssText = 'font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem;';
        polyLabel.textContent = 'Taylor Polynomial Used';
        polyBox.appendChild(polyLabel);
        var polyMath = document.createElement('div');
        polyMath.className = 'sc-step-math';
        renderKaTeX(polyMath, data.latexPoly, true);
        polyBox.appendChild(polyMath);
        container.appendChild(polyBox);
    }
}

// ==================== Integral Result ====================

function renderIntegralResult(data, container) {
    if (!container) return;
    container.innerHTML = '';

    var empty = document.getElementById('sc-empty-state');
    if (empty) empty.style.display = 'none';

    // Title
    var title = document.createElement('div');
    title.className = 'sc-formula-box';
    title.innerHTML = '<strong>Definite Integral Approximation via Taylor Series</strong>';
    container.appendChild(title);

    // Integral result box
    var box = document.createElement('div');
    box.className = 'sc-integral-box';

    var h4 = document.createElement('h4');
    h4.textContent = 'Integration Result';
    box.appendChild(h4);

    // Integrated polynomial display
    if (data.latexIntegral) {
        var mathDiv = document.createElement('div');
        mathDiv.className = 'sc-step-math';
        renderKaTeX(mathDiv, data.latexIntegral, true);
        box.appendChild(mathDiv);
    }

    // Approximate value
    if (data.approx !== undefined) {
        var approxRow = document.createElement('div');
        approxRow.className = 'sc-result-row';
        approxRow.innerHTML = '<span>Approximate value:</span> <strong>' + data.approx + '</strong>';
        box.appendChild(approxRow);
    }

    // Exact value
    if (data.exact !== undefined) {
        var exactRow = document.createElement('div');
        exactRow.className = 'sc-result-row';
        exactRow.innerHTML = '<span>Exact value:</span> <strong>' + data.exact + '</strong>';
        box.appendChild(exactRow);
    }

    // Error
    if (data.error !== undefined) {
        var errRow = document.createElement('div');
        errRow.className = 'sc-result-row';
        errRow.innerHTML = '<span>Approximation error:</span> <strong>' + data.error + '</strong>';
        box.appendChild(errRow);
    }

    container.appendChild(box);

    // Show the Taylor polynomial used
    if (data.latexPoly) {
        var polyBox = document.createElement('div');
        polyBox.style.cssText = 'margin-top:0.75rem;';
        var polyLabel = document.createElement('div');
        polyLabel.style.cssText = 'font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem;';
        polyLabel.textContent = 'Taylor Polynomial Used';
        polyBox.appendChild(polyLabel);
        var polyMath = document.createElement('div');
        polyMath.className = 'sc-step-math';
        renderKaTeX(polyMath, data.latexPoly, true);
        polyBox.appendChild(polyMath);
        container.appendChild(polyBox);
    }

    // Exact integral LaTeX
    if (data.latexExact) {
        var exactBox = document.createElement('div');
        exactBox.style.cssText = 'margin-top:0.5rem;';
        var exactLabel = document.createElement('div');
        exactLabel.style.cssText = 'font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem;';
        exactLabel.textContent = 'Exact Integral';
        exactBox.appendChild(exactLabel);
        var exactMath = document.createElement('div');
        exactMath.className = 'sc-step-math';
        renderKaTeX(exactMath, data.latexExact, true);
        exactBox.appendChild(exactMath);
        container.appendChild(exactBox);
    }
}

// ==================== Limit Result ====================

function renderLimitResult(data, container) {
    if (!container) return;
    container.innerHTML = '';

    var empty = document.getElementById('sc-empty-state');
    if (empty) empty.style.display = 'none';

    // Title
    var title = document.createElement('div');
    title.className = 'sc-formula-box';
    title.innerHTML = '<strong>Limit Evaluation via Taylor Series</strong>';
    container.appendChild(title);

    // Limit result box
    var box = document.createElement('div');
    box.className = 'sc-limit-box';

    var h4 = document.createElement('h4');
    h4.textContent = 'Limit Result';
    box.appendChild(h4);

    // Series expansion step
    if (data.latexExpansion) {
        var expLabel = document.createElement('div');
        expLabel.style.cssText = 'font-size:0.75rem;font-weight:500;color:var(--text-secondary);margin-bottom:0.25rem;';
        expLabel.textContent = 'Series substitution:';
        box.appendChild(expLabel);
        var expMath = document.createElement('div');
        expMath.className = 'sc-step-math';
        renderKaTeX(expMath, data.latexExpansion, true);
        box.appendChild(expMath);
    }

    // Simplified expression
    if (data.latexSimplified) {
        var simpLabel = document.createElement('div');
        simpLabel.style.cssText = 'font-size:0.75rem;font-weight:500;color:var(--text-secondary);margin-top:0.5rem;margin-bottom:0.25rem;';
        simpLabel.textContent = 'Simplified:';
        box.appendChild(simpLabel);
        var simpMath = document.createElement('div');
        simpMath.className = 'sc-step-math';
        renderKaTeX(simpMath, data.latexSimplified, true);
        box.appendChild(simpMath);
    }

    // Final limit value (boxed)
    if (data.latexLimit) {
        var limitMath = document.createElement('div');
        limitMath.className = 'sc-step-math';
        limitMath.style.marginTop = '0.75rem';
        renderKaTeX(limitMath, data.latexLimit, true);
        box.appendChild(limitMath);
    } else if (data.limit !== undefined) {
        var limitRow = document.createElement('div');
        limitRow.className = 'sc-result-row';
        limitRow.style.cssText = 'font-size:1rem;margin-top:0.5rem;';
        limitRow.innerHTML = '<span>Limit =</span> <strong>' + data.limit + '</strong>';
        box.appendChild(limitRow);
    }

    container.appendChild(box);
}

// ==================== Remainder Steps ====================

function renderRemainderSteps(container, data) {
    if (!container) return;
    container.innerHTML = '';

    // Header with amber accent
    var header = document.createElement('div');
    header.className = 'sc-steps-header sc-steps-header--remainder';
    header.innerHTML = '<h4>Step-by-Step: Error Bound</h4><p>Lagrange remainder analysis</p>';
    container.appendChild(header);

    var stepNum = 0;

    // Step 1: Recall the Lagrange Remainder formula
    stepNum++;
    container.appendChild(buildStepDOM(
        stepNum,
        'Recall the <strong>Lagrange Remainder formula</strong>',
        'R_n(x) = \\frac{f^{(n+1)}(c)}{(n+1)!} \\cdot (x - a)^{n+1}',
        '\\text{where } c \\text{ is between } a \\text{ and } x'
    ));

    // Step 2: Build the Taylor polynomial
    stepNum++;
    var polyLatex = data['LATEX_POLY'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        'Build the <strong>Taylor polynomial</strong>',
        'P_n(x) = ' + polyLatex,
        null
    ));

    // Step 3: Compute the (n+1)th derivative
    stepNum++;
    var derivExpr = data['STEP_DERIV_EXPR'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        'Compute the <strong>(n+1)th derivative</strong>',
        'f^{(n+1)}(x) = ' + derivExpr,
        null
    ));

    // Step 4: Find M = max|f^(n+1)| on interval
    stepNum++;
    var maxDeriv = data['STEP_MAX_DERIV'] || '?';
    var interval = data['STEP_INTERVAL'] || '?,?';
    var parts = interval.split(',');
    var lo = parts[0] || '?';
    var hi = parts[1] || '?';
    container.appendChild(buildStepDOMMulti(
        stepNum,
        'Find <strong>M = max|f<sup>(n+1)</sup>|</strong> on the interval',
        [
            '\\text{Interval: } [' + lo + ',\\, ' + hi + ']',
            'M = \\max_{c \\in [' + lo + ',\\,' + hi + ']} \\left|f^{(n+1)}(c)\\right| = ' + maxDeriv
        ]
    ));

    // Step 5: Apply the bound and compare
    stepNum++;
    var bound = data['BOUND'] || '?';
    var actualErr = data['ACTUAL_ERROR'] || '?';
    var evalExact = data['STEP_EVAL_EXACT'] || '?';
    var evalPoly = data['STEP_EVAL_POLY'] || '?';
    var boundNum = parseFloat(bound);
    var actualNum = parseFloat(actualErr);
    var checkmark = (!isNaN(boundNum) && !isNaN(actualNum) && actualNum <= boundNum)
        ? '\\;\\color{green}{\\checkmark}'
        : '';
    container.appendChild(buildStepDOMMulti(
        stepNum,
        '<strong>Apply the bound and compare</strong>',
        [
            'f(x_0) = ' + evalExact + ', \\quad P_n(x_0) = ' + evalPoly,
            '\\text{Actual error } = |f(x_0) - P_n(x_0)| = ' + actualErr,
            '\\boxed{\\text{Bound } = ' + bound + '}' + checkmark
        ]
    ));
}

// ==================== Integral Steps ====================

function renderIntegralSteps(container, data) {
    if (!container) return;
    container.innerHTML = '';

    // Header with purple accent
    var header = document.createElement('div');
    header.className = 'sc-steps-header sc-steps-header--integral';
    header.innerHTML = '<h4>Step-by-Step: Integral Approximation</h4><p>Definite integral via Taylor polynomial</p>';
    container.appendChild(header);

    var stepNum = 0;

    // Step 1: Replace f(x) with its Taylor polynomial
    stepNum++;
    var polyLatex = data['LATEX_POLY'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        'Replace <strong>f(x)</strong> with its Taylor polynomial',
        'f(x) \\approx P_n(x) = ' + polyLatex,
        null
    ));

    // Step 2: Set up the definite integral
    stepNum++;
    var setupLatex = data['STEP_SETUP'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        'Set up the <strong>definite integral</strong>',
        setupLatex,
        null
    ));

    // Step 3: Integrate term-by-term
    stepNum++;
    var antideriv = data['STEP_ANTIDERIV'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        '<strong>Integrate term-by-term</strong>',
        'F(x) = \\int P_n(x)\\,dx = ' + antideriv,
        null
    ));

    // Step 4: Evaluate at bounds: F(b) - F(a)
    stepNum++;
    var upperVal = data['STEP_UPPER_VAL'] || '?';
    var lowerVal = data['STEP_LOWER_VAL'] || '?';
    container.appendChild(buildStepDOMMulti(
        stepNum,
        'Evaluate at bounds: <strong>F(b) &minus; F(a)</strong>',
        [
            'F(b) = ' + upperVal,
            'F(a) = ' + lowerVal,
            'F(b) - F(a) = ' + upperVal + ' - ' + lowerVal + ' = ' + (data['APPROX'] || '?')
        ]
    ));

    // Step 5: Compare approximate vs exact
    stepNum++;
    var approx = data['APPROX'] || '?';
    var exact = data['EXACT'] || '?';
    var err = data['ABSERROR'] || '?';
    container.appendChild(buildStepDOMMulti(
        stepNum,
        '<strong>Compare approximate vs exact</strong>',
        [
            '\\text{Approximate: } ' + approx,
            '\\text{Exact: } ' + exact,
            '\\boxed{\\text{Error } = ' + err + '}'
        ]
    ));
}

// ==================== Limit Steps ====================

function renderLimitSteps(container, data) {
    if (!container) return;
    container.innerHTML = '';

    // Header with rose accent
    var header = document.createElement('div');
    header.className = 'sc-steps-header sc-steps-header--limit';
    header.innerHTML = '<h4>Step-by-Step: Limit Evaluation</h4><p>Limit via Taylor series expansion</p>';
    container.appendChild(header);

    var stepNum = 0;
    var isInfinite = !data['STEP_ORIGINAL'];

    if (isInfinite) {
        // Infinite limit — fewer steps
        stepNum++;
        container.appendChild(buildStepDOM(
            stepNum,
            'Identify the <strong>limit expression</strong>',
            '\\text{Evaluate } \\lim_{x \\to \\pm\\infty}',
            null
        ));

        stepNum++;
        var limitLatex = data['LATEX_LIMIT'] || '\\text{(not available)}';
        container.appendChild(buildStepDOM(
            stepNum,
            '<strong>Evaluate the limit</strong> directly',
            '\\boxed{' + limitLatex + '}',
            null
        ));
        return;
    }

    // Step 1: Identify the limit expression
    stepNum++;
    var origLatex = data['STEP_ORIGINAL'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        'Identify the <strong>limit expression</strong>',
        '\\lim_{x \\to \\text{pt}} \\left(' + origLatex + '\\right)',
        null
    ));

    // Step 2: Check for indeterminate form
    stepNum++;
    var directVal = data['STEP_DIRECT'] || '?';
    var isIndeterminate = directVal === 'nan' || directVal === 'indeterminate' || directVal === 'zoo' || directVal === 'oo' || directVal === 'NaN';
    var desc2 = isIndeterminate
        ? 'Check for <strong>indeterminate form</strong> — direct substitution gives <code>' + directVal + '</code>'
        : 'Check for <strong>indeterminate form</strong> — direct substitution gives <code>' + directVal + '</code>';
    container.appendChild(buildStepDOM(
        stepNum,
        desc2,
        '\\text{Direct substitution} \\to ' + directVal,
        isIndeterminate ? '\\text{Indeterminate form — use series expansion}' : null
    ));

    // Step 3: Expand using Taylor series
    stepNum++;
    var hasNumerDenom = data['STEP_NUMER_EXPAND'] && data['STEP_DENOM_EXPAND'];
    if (hasNumerDenom) {
        container.appendChild(buildStepDOMMulti(
            stepNum,
            '<strong>Expand numerator and denominator</strong> using Taylor series',
            [
                '\\text{Numerator: } ' + data['STEP_NUMER_EXPAND'],
                '\\text{Denominator: } ' + data['STEP_DENOM_EXPAND']
            ]
        ));
    } else {
        var expansion = data['LATEX_EXPANSION'] || '\\text{(not available)}';
        container.appendChild(buildStepDOM(
            stepNum,
            '<strong>Expand using Taylor series</strong>',
            expansion,
            null
        ));
    }

    // Step 4: Simplify the expression
    stepNum++;
    var simplified = data['LATEX_SIMPLIFIED'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        '<strong>Simplify</strong> the expression',
        simplified,
        null
    ));

    // Step 5: Evaluate the limit
    stepNum++;
    var limitLatex = data['LATEX_LIMIT'] || '\\text{(not available)}';
    container.appendChild(buildStepDOM(
        stepNum,
        '<strong>Evaluate the limit</strong>',
        '\\boxed{' + limitLatex + '}',
        null
    ));
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
    showError: showError,
    renderRemainderResult: renderRemainderResult,
    renderIntegralResult: renderIntegralResult,
    renderLimitResult: renderLimitResult,
    renderRemainderSteps: renderRemainderSteps,
    renderIntegralSteps: renderIntegralSteps,
    renderLimitSteps: renderLimitSteps
};

})();
