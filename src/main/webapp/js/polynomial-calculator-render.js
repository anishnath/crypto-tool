/**
 * Polynomial Calculator - Render Module
 * Step-by-step solution rendering with KaTeX + Nerdamer
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
    step.className = 'poly-step';

    var numEl = document.createElement('div');
    numEl.className = 'poly-step-number';
    numEl.textContent = number;
    step.appendChild(numEl);

    var content = document.createElement('div');
    content.className = 'poly-step-content';

    if (desc) {
        var descEl = document.createElement('div');
        descEl.className = 'poly-step-desc';
        descEl.innerHTML = desc;
        content.appendChild(descEl);
    }

    if (latex) {
        var mathEl = document.createElement('div');
        mathEl.className = 'poly-step-math';
        renderKaTeX(mathEl, latex, true);
        content.appendChild(mathEl);
    }

    step.appendChild(content);
    return step;
}

function safeTeX(expr) {
    try {
        return nerdamer(expr).toTeX();
    } catch (e) {
        return expr;
    }
}

function safeExpand(expr) {
    try {
        return nerdamer(expr).expand().text();
    } catch (e) {
        return expr;
    }
}

// ==================== Render Functions ====================

function renderAdd(container, p1, p2) {
    container.innerHTML = '';
    try {
        var p1tex = safeTeX(p1);
        var p2tex = safeTeX(p2);
        var result = nerdamer(p1 + '+(' + p2 + ')').expand();
        var resultTex = result.toTeX();
        var resultText = result.text();

        // Result badge
        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Addition</span>';
        container.appendChild(badge);

        // Main result
        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';
        renderKaTeX(mainMath, 'P(x) + Q(x) = ' + resultTex);
        container.appendChild(mainMath);

        // Steps
        container.appendChild(buildStepDOM(1, '<strong>Write the polynomials</strong>', 'P(x) = ' + p1tex));
        container.appendChild(buildStepDOM(2, '<strong>Write the second polynomial</strong>', 'Q(x) = ' + p2tex));
        container.appendChild(buildStepDOM(3, '<strong>Add the polynomials</strong>', 'P(x) + Q(x) = (' + p1tex + ') + (' + p2tex + ')'));
        container.appendChild(buildStepDOM(4, '<strong>Combine like terms</strong>', '= ' + resultTex));

        return { resultText: resultText, resultTeX: resultTex, p1tex: p1tex, p2tex: p2tex };
    } catch (e) {
        showError(container, 'Could not add polynomials: ' + e.message);
        return null;
    }
}

function renderSubtract(container, p1, p2) {
    container.innerHTML = '';
    try {
        var p1tex = safeTeX(p1);
        var p2tex = safeTeX(p2);
        var result = nerdamer(p1 + '-(' + p2 + ')').expand();
        var resultTex = result.toTeX();
        var resultText = result.text();

        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Subtraction</span>';
        container.appendChild(badge);

        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';
        renderKaTeX(mainMath, 'P(x) - Q(x) = ' + resultTex);
        container.appendChild(mainMath);

        container.appendChild(buildStepDOM(1, '<strong>Write the polynomials</strong>', 'P(x) = ' + p1tex));
        container.appendChild(buildStepDOM(2, '<strong>Write the second polynomial</strong>', 'Q(x) = ' + p2tex));
        container.appendChild(buildStepDOM(3, '<strong>Distribute the negative sign</strong>', 'P(x) - Q(x) = (' + p1tex + ') - (' + p2tex + ')'));
        container.appendChild(buildStepDOM(4, '<strong>Combine like terms</strong>', '= ' + resultTex));

        return { resultText: resultText, resultTeX: resultTex, p1tex: p1tex, p2tex: p2tex };
    } catch (e) {
        showError(container, 'Could not subtract polynomials: ' + e.message);
        return null;
    }
}

function renderMultiply(container, p1, p2) {
    container.innerHTML = '';
    try {
        var p1tex = safeTeX(p1);
        var p2tex = safeTeX(p2);
        var unexpanded = nerdamer('(' + p1 + ')*(' + p2 + ')');
        var result = unexpanded.expand();
        var resultTex = result.toTeX();
        var resultText = result.text();

        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Multiplication</span>';
        container.appendChild(badge);

        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';
        renderKaTeX(mainMath, 'P(x) \\cdot Q(x) = ' + resultTex);
        container.appendChild(mainMath);

        container.appendChild(buildStepDOM(1, '<strong>Write the polynomials</strong>', 'P(x) = ' + p1tex));
        container.appendChild(buildStepDOM(2, '<strong>Write the second polynomial</strong>', 'Q(x) = ' + p2tex));
        container.appendChild(buildStepDOM(3, '<strong>Multiply using distribution</strong>', '(' + p1tex + ') \\cdot (' + p2tex + ')'));
        container.appendChild(buildStepDOM(4, '<strong>Expand and collect terms</strong>', '= ' + resultTex));

        return { resultText: resultText, resultTeX: resultTex, p1tex: p1tex, p2tex: p2tex };
    } catch (e) {
        showError(container, 'Could not multiply polynomials: ' + e.message);
        return null;
    }
}

function renderDivide(container, p1, p2) {
    container.innerHTML = '';
    try {
        var p1tex = safeTeX(p1);
        var p2tex = safeTeX(p2);

        var divResult = nerdamer('div(' + p1 + ',' + p2 + ')');
        var parts = divResult.text();
        // div returns [quotient, remainder]
        var quotient, remainder;
        try {
            // nerdamer div returns a vector [q, r]
            var arr = parts.replace(/^\[|\]$/g, '').split(',');
            quotient = arr[0] ? arr[0].trim() : '0';
            remainder = arr[1] ? arr[1].trim() : '0';
        } catch (ex) {
            quotient = parts;
            remainder = '0';
        }

        var qTex = safeTeX(quotient);
        var rTex = safeTeX(remainder);

        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Long Division</span>';
        container.appendChild(badge);

        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';
        if (remainder === '0') {
            renderKaTeX(mainMath, '\\frac{P(x)}{Q(x)} = ' + qTex);
        } else {
            renderKaTeX(mainMath, '\\frac{P(x)}{Q(x)} = ' + qTex + ' + \\frac{' + rTex + '}{' + p2tex + '}');
        }
        container.appendChild(mainMath);

        container.appendChild(buildStepDOM(1, '<strong>Dividend (numerator)</strong>', 'P(x) = ' + p1tex));
        container.appendChild(buildStepDOM(2, '<strong>Divisor (denominator)</strong>', 'Q(x) = ' + p2tex));
        container.appendChild(buildStepDOM(3, '<strong>Perform polynomial long division</strong>', '\\frac{' + p1tex + '}{' + p2tex + '}'));
        container.appendChild(buildStepDOM(4, '<strong>Quotient</strong>', 'Q(x) = ' + qTex));
        container.appendChild(buildStepDOM(5, '<strong>Remainder</strong>', 'R(x) = ' + rTex));

        if (remainder === '0') {
            container.appendChild(buildStepDOM(6, '<strong>Result</strong> &mdash; Divides evenly!', p1tex + ' = (' + p2tex + ')(' + qTex + ')'));
        } else {
            container.appendChild(buildStepDOM(6, '<strong>Result</strong>', p1tex + ' = (' + p2tex + ')(' + qTex + ') + ' + rTex));
        }

        return { resultText: quotient, resultTeX: qTex, remainder: remainder, remainderTeX: rTex, p1tex: p1tex, p2tex: p2tex };
    } catch (e) {
        showError(container, 'Could not divide polynomials: ' + e.message);
        return null;
    }
}

function renderFactor(container, poly) {
    container.innerHTML = '';
    try {
        var polyTex = safeTeX(poly);
        var factored = nerdamer('factor(' + poly + ')');
        var factoredTex = factored.toTeX();
        var factoredText = factored.text();

        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Factoring</span>';
        container.appendChild(badge);

        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';
        renderKaTeX(mainMath, polyTex + ' = ' + factoredTex);
        container.appendChild(mainMath);

        container.appendChild(buildStepDOM(1, '<strong>Original polynomial</strong>', 'P(x) = ' + polyTex));
        container.appendChild(buildStepDOM(2, '<strong>Factor the polynomial</strong>', polyTex + ' = ' + factoredTex));

        // Try to find degree
        try {
            var expanded = nerdamer(poly).expand().text();
            var degree = nerdamer('deg(' + expanded + ', x)').text();
            var degreeInfo = document.createElement('div');
            degreeInfo.className = 'poly-result-detail';
            degreeInfo.innerHTML = '<strong>Degree:</strong> ' + degree;
            container.appendChild(degreeInfo);
        } catch (ex) {}

        return { resultText: factoredText, resultTeX: factoredTex, p1tex: polyTex };
    } catch (e) {
        showError(container, 'Could not factor polynomial: ' + e.message);
        return null;
    }
}

function renderRoots(container, poly) {
    container.innerHTML = '';
    try {
        var polyTex = safeTeX(poly);
        var rootsResult = nerdamer('roots(' + poly + ')');
        var rootsText = rootsResult.text();
        var rootsTex = rootsResult.toTeX();

        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Root Finding</span>';
        container.appendChild(badge);

        container.appendChild(buildStepDOM(1, '<strong>Set polynomial equal to zero</strong>', polyTex + ' = 0'));

        // Try factoring first
        try {
            var factored = nerdamer('factor(' + poly + ')');
            var factoredTex = factored.toTeX();
            if (factoredTex !== polyTex) {
                container.appendChild(buildStepDOM(2, '<strong>Factor the polynomial</strong>', factoredTex + ' = 0'));
            }
        } catch (ex) {}

        // Parse roots
        var rootsArr = rootsText.replace(/^\[|\]$/g, '').split(',').map(function(r) { return r.trim(); }).filter(function(r) { return r.length > 0; });

        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';

        if (rootsArr.length === 0) {
            renderKaTeX(mainMath, '\\text{No roots found}');
        } else {
            var rootLatexParts = [];
            for (var i = 0; i < rootsArr.length; i++) {
                rootLatexParts.push('x_{' + (i + 1) + '} = ' + safeTeX(rootsArr[i]));
            }
            renderKaTeX(mainMath, rootLatexParts.join(', \\quad '));
        }
        container.appendChild(mainMath);

        var stepN = 3;
        for (var j = 0; j < rootsArr.length; j++) {
            container.appendChild(buildStepDOM(stepN++, '<strong>Root ' + (j + 1) + '</strong>', 'x_{' + (j + 1) + '} = ' + safeTeX(rootsArr[j])));
        }

        // Root count info
        var detail = document.createElement('div');
        detail.className = 'poly-result-detail';
        detail.innerHTML = '<strong>Number of roots:</strong> ' + rootsArr.length;
        container.appendChild(detail);

        return { resultText: rootsText, resultTeX: rootsTex, roots: rootsArr, p1tex: polyTex };
    } catch (e) {
        showError(container, 'Could not find roots: ' + e.message);
        return null;
    }
}

function renderEvaluate(container, poly, xVal) {
    container.innerHTML = '';
    try {
        var polyTex = safeTeX(poly);
        var val = parseFloat(xVal);
        if (isNaN(val)) { showError(container, 'Please enter a valid number for x.'); return null; }

        var result = nerdamer(poly).evaluate({ x: val });
        var resultText = result.text('decimals');
        var resultTex = result.toTeX();

        var badge = document.createElement('div');
        badge.innerHTML = '<span class="poly-result-badge">Evaluation</span>';
        container.appendChild(badge);

        var mainMath = document.createElement('div');
        mainMath.className = 'poly-result-math';
        renderKaTeX(mainMath, 'P(' + fmt(val) + ') = ' + resultTex);
        container.appendChild(mainMath);

        container.appendChild(buildStepDOM(1, '<strong>Original polynomial</strong>', 'P(x) = ' + polyTex));
        container.appendChild(buildStepDOM(2, '<strong>Substitute x = ' + fmt(val) + '</strong>', 'P(' + fmt(val) + ') = ' + polyTex.replace(/x/g, '(' + fmt(val) + ')')));
        container.appendChild(buildStepDOM(3, '<strong>Compute the result</strong>', 'P(' + fmt(val) + ') = ' + resultTex));

        return { resultText: resultText, resultTeX: resultTex, p1tex: polyTex, evalX: val };
    } catch (e) {
        showError(container, 'Could not evaluate polynomial: ' + e.message);
        return null;
    }
}

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div class="poly-error"><h4>Error</h4><p>' + message + '</p></div>';
}

function showAISteps(container, steps, method) {
    if (!container) return;
    var wrapper = document.createElement('div');
    wrapper.className = 'poly-steps-container';

    var header = document.createElement('div');
    header.className = 'poly-steps-header';
    header.textContent = (method || 'AI') + ' — Step-by-Step Solution';
    wrapper.appendChild(header);

    var body = document.createElement('div');
    body.style.padding = '0.5rem';
    for (var i = 0; i < steps.length; i++) {
        var s = steps[i];
        body.appendChild(buildStepDOM(i + 1, s.description || s.title || '', s.latex || s.math || ''));
    }
    wrapper.appendChild(body);
    container.appendChild(wrapper);
}

// ==================== Exports ====================

window.PolyCalcRender = {
    fmt: fmt,
    renderKaTeX: renderKaTeX,
    buildStepDOM: buildStepDOM,
    renderAdd: renderAdd,
    renderSubtract: renderSubtract,
    renderMultiply: renderMultiply,
    renderDivide: renderDivide,
    renderFactor: renderFactor,
    renderRoots: renderRoots,
    renderEvaluate: renderEvaluate,
    showError: showError,
    showAISteps: showAISteps,
    safeTeX: safeTeX
};

})();
