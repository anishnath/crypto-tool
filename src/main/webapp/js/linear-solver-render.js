/**
 * Linear Solver - Output Rendering
 * KaTeX rendering for matrices, step-by-step display, AI response rendering
 */
(function() {
'use strict';

var M = window.LinearSolverMatrix;

function renderKaTeX(latex, el, displayMode) {
    if (!el) return;
    if (typeof katex === 'undefined') {
        el.textContent = latex;
        return;
    }
    try {
        katex.render(latex, el, { displayMode: displayMode !== false, throwOnError: false });
    } catch (e) {
        el.textContent = latex;
    }
}

function createEl(tag, className, html) {
    var el = document.createElement(tag);
    if (className) el.className = className;
    if (html) el.innerHTML = html;
    return el;
}

// ==================== Result Rendering ====================

function renderUniqueResult(result, method) {
    var html = '<div class="ls-result-section">';
    html += '<div class="ls-result-badge ls-badge-success">Unique Solution</div>';
    html += '<div class="ls-result-label">SOLUTION VECTOR</div>';
    html += '<div id="ls-solution-katex" class="ls-result-math"></div>';
    html += '<div class="ls-method-info">';
    html += '<span class="ls-method-badge">' + escapeHtml(method) + '</span>';
    html += '</div>';
    html += '</div>';
    return html;
}

function renderLeastSquaresResult(result, method) {
    var html = '<div class="ls-result-section">';
    html += '<div class="ls-result-badge ls-badge-info">Least Squares Solution</div>';
    html += '<div class="ls-result-label">BEST FIT SOLUTION</div>';
    html += '<div id="ls-solution-katex" class="ls-result-math"></div>';
    html += '<div class="ls-result-detail">';
    html += '<strong>Residual norm:</strong> ||Ax - b|| = ' + M.smartFormat(result.residual);
    html += '</div>';
    html += '<div class="ls-method-info">';
    html += '<span class="ls-method-badge">' + escapeHtml(method) + '</span>';
    html += '</div>';
    html += '</div>';
    return html;
}

function renderMatrixResult(result, method) {
    var html = '<div class="ls-result-section">';
    html += '<div class="ls-result-badge ls-badge-success">Matrix Solution</div>';
    html += '<div class="ls-result-label">SOLUTION MATRIX X</div>';
    html += '<div id="ls-solution-katex" class="ls-result-math"></div>';
    html += '<div class="ls-method-info">';
    html += '<span class="ls-method-badge">' + escapeHtml(method) + '</span>';
    html += '</div>';
    html += '</div>';
    return html;
}

function renderInconsistentResult(result) {
    var html = '<div class="ls-result-section">';
    html += '<div class="ls-result-badge ls-badge-warning">No Solution (Inconsistent)</div>';
    html += '<p class="ls-error-msg">' + escapeHtml(result.message) + '</p>';
    html += '<p class="ls-error-hint">The system has contradictory equations and cannot be solved.</p>';
    html += '</div>';
    return html;
}

function renderInfiniteResult(result) {
    var freeCols = result.freeCols || [];
    var freeVars = freeCols.map(function(c) { return 'x_{' + (c + 1) + '}'; }).join(', ');

    var html = '<div class="ls-result-section">';
    html += '<div class="ls-result-badge ls-badge-info">Infinite Solutions</div>';
    html += '<div class="ls-result-label">FREE VARIABLES</div>';
    html += '<div id="ls-free-vars-katex" class="ls-result-math"></div>';
    html += '<div class="ls-result-label" style="margin-top:1rem">PARAMETRIC FORM</div>';
    html += '<div id="ls-parametric-katex" class="ls-result-math"></div>';
    html += '</div>';
    return html;
}

function renderPolynomialResult(result) {
    var varNames = ['x', 'y', 'z'];
    var html = '<div class="ls-result-section">';
    html += '<div class="ls-result-badge ' + (result.converged ? 'ls-badge-success' : 'ls-badge-warning') + '">';
    html += (result.converged ? 'Converged' : 'Approximate') + ' Solution</div>';
    html += '<div class="ls-result-label">SOLUTION</div>';
    for (var i = 0; i < result.solution.length; i++) {
        html += '<div class="ls-poly-var">' + varNames[i] + ' = ' + M.smartFormat(result.solution[i]) + '</div>';
    }
    html += '</div>';
    return html;
}

// Post-render: apply KaTeX to elements
function postRenderResult(result) {
    var solEl = document.getElementById('ls-solution-katex');
    if (solEl) {
        if (result.type === 'unique' || result.type === 'least-squares') {
            renderKaTeX('x = ' + M.formatVector(result.solution), solEl);
        } else if (result.type === 'matrix-solution') {
            renderKaTeX('X = ' + M.formatMatrix(result.solution), solEl);
        }
    }

    // Infinite solutions
    if (result.type === 'infinite') {
        var freeEl = document.getElementById('ls-free-vars-katex');
        var paramEl = document.getElementById('ls-parametric-katex');
        if (freeEl) {
            var freeLatex = result.freeCols.map(function(c) { return 'x_{' + (c + 1) + '}'; }).join(', ') + ' \\text{ are free}';
            renderKaTeX(freeLatex, freeEl);
        }
        if (paramEl && result.aug) {
            var paramNames = ['t', 's', 'r', 'u'];
            var params = result.freeCols.map(function(col, idx) { return { col: col, name: paramNames[idx] || 't_' + idx }; });
            var n = result.aug[0].length - 1;
            var latex = '\\begin{cases}';
            for (var j = 0; j < n; j++) {
                if (result.freeCols.indexOf(j) >= 0) {
                    var paramIdx = result.freeCols.indexOf(j);
                    latex += 'x_{' + (j + 1) + '} = ' + params[paramIdx].name + ' \\\\';
                } else {
                    var rowIdx = -1;
                    for (var i = 0; i < result.aug.length; i++) {
                        if (Math.abs(result.aug[i][j]) > M.EPS) { rowIdx = i; break; }
                    }
                    if (rowIdx !== -1) {
                        var expr = M.smartFormat(result.aug[rowIdx][n]);
                        for (var k = j + 1; k < n; k++) {
                            var coeff = -result.aug[rowIdx][k];
                            if (Math.abs(coeff) > M.EPS && result.freeCols.indexOf(k) >= 0) {
                                var pIdx = result.freeCols.indexOf(k);
                                var sign = coeff > 0 ? '+' : '';
                                expr += sign + M.smartFormat(coeff) + params[pIdx].name;
                            }
                        }
                        latex += 'x_{' + (j + 1) + '} = ' + expr + ' \\\\';
                    }
                }
            }
            latex += '\\end{cases}';
            renderKaTeX(latex, paramEl);
        }
    }
}

// ==================== Steps Rendering ====================

function renderSteps(steps, container) {
    if (!container || !steps || steps.length === 0) return;

    container.innerHTML = '';

    var wrapper = createEl('div', 'ls-steps-wrapper');
    var header = createEl('div', 'ls-steps-header', 'Step-by-Step Solution');
    wrapper.appendChild(header);

    for (var i = 0; i < steps.length; i++) {
        var step = steps[i];
        var stepEl = createEl('div', 'ls-step');

        var numEl = createEl('span', 'ls-step-number', String(i + 1));
        stepEl.appendChild(numEl);

        var contentEl = createEl('div', 'ls-step-content');

        if (step.desc) {
            var descEl = createEl('div', 'ls-step-desc');
            // If desc contains LaTeX-like content, try rendering
            if (step.desc.indexOf('\\') >= 0 || step.desc.indexOf('_') >= 0) {
                renderKaTeX(step.desc, descEl, false);
            } else {
                descEl.textContent = step.desc;
            }
            contentEl.appendChild(descEl);
        }

        if (step.latex) {
            var mathEl = createEl('div', 'ls-step-math');
            renderKaTeX(step.latex, mathEl);
            contentEl.appendChild(mathEl);
        }

        stepEl.appendChild(contentEl);
        wrapper.appendChild(stepEl);
    }

    container.appendChild(wrapper);
}

// ==================== AI Steps Rendering ====================

function renderAISteps(data, container) {
    if (!container || !data || !data.steps || data.steps.length === 0) return;

    container.innerHTML = '';

    var wrapper = createEl('div', 'ls-steps-wrapper');
    var header = createEl('div', 'ls-steps-header');
    header.innerHTML = 'AI-Generated Steps <span class="ls-method-badge">AI</span>';
    wrapper.appendChild(header);

    for (var i = 0; i < data.steps.length; i++) {
        var step = data.steps[i];
        var stepEl = createEl('div', 'ls-step');

        var numEl = createEl('span', 'ls-step-number', String(i + 1));
        stepEl.appendChild(numEl);

        var contentEl = createEl('div', 'ls-step-content');

        // Title
        if (step.title || step.t) {
            var titleEl = createEl('div', 'ls-step-desc');
            titleEl.textContent = step.title || step.t;
            contentEl.appendChild(titleEl);
        }

        // LaTeX or text
        var ltx = step.latex || step.l || '';
        if (ltx) {
            var mathEl = createEl('div', 'ls-step-math');
            // Sentence detection heuristic (same as logarithm calculator)
            var wordCount = (ltx.match(/[a-zA-Z]{2,}/g) || []).length;
            var isSentence = wordCount >= 4 && ltx.indexOf(' ') >= 0;
            if (isSentence) {
                mathEl.style.color = 'var(--text-secondary)';
                mathEl.style.fontSize = '0.875rem';
                mathEl.style.lineHeight = '1.6';
                mathEl.textContent = ltx.replace(/\\\\/g, '\\');
            } else {
                renderKaTeX(ltx, mathEl);
            }
            contentEl.appendChild(mathEl);
        }

        stepEl.appendChild(contentEl);
        wrapper.appendChild(stepEl);
    }

    container.appendChild(wrapper);
}

// ==================== Verification Rendering ====================

function renderVerification(A, x, b, container) {
    if (!container) return;

    var verification = M.verifySolution(A, x, b);
    var passed = verification.error < 0.0001;

    var html = '<div class="ls-verification ' + (passed ? 'ls-verify-pass' : 'ls-verify-warn') + '">';
    html += '<div class="ls-verify-header">' + (passed ? 'Solution Verified' : 'Verification') + '</div>';
    html += '<div class="ls-verify-row"><strong>Computed Ax:</strong></div>';
    html += '<div id="ls-verify-ax" class="ls-result-math"></div>';
    html += '<div class="ls-verify-row"><strong>Expected b:</strong></div>';
    html += '<div id="ls-verify-b" class="ls-result-math"></div>';
    html += '<div class="ls-verify-row"><strong>Max error:</strong> ' + verification.error.toExponential(3) + '</div>';
    html += '</div>';

    container.innerHTML = html;

    renderKaTeX('Ax = ' + M.formatVector(verification.computed), document.getElementById('ls-verify-ax'));
    renderKaTeX('b = ' + M.formatVector(b), document.getElementById('ls-verify-b'));
}

// ==================== Helpers ====================

function escapeHtml(str) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
}

// ==================== Exports ====================

window.LinearSolverRender = {
    renderKaTeX: renderKaTeX,
    renderUniqueResult: renderUniqueResult,
    renderLeastSquaresResult: renderLeastSquaresResult,
    renderMatrixResult: renderMatrixResult,
    renderInconsistentResult: renderInconsistentResult,
    renderInfiniteResult: renderInfiniteResult,
    renderPolynomialResult: renderPolynomialResult,
    postRenderResult: postRenderResult,
    renderSteps: renderSteps,
    renderAISteps: renderAISteps,
    renderVerification: renderVerification
};

})();
