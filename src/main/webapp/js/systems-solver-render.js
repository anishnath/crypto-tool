/**
 * Systems of Equations Solver - Render Module
 * Step-by-step solution rendering with KaTeX for 2×2 and 3×3 systems.
 * Supports Cramer's rule, Gaussian elimination, substitution, and matrix inversion.
 */
(function () {
'use strict';

var EPS = 1e-10;

// ==================== Number Formatting ====================

/**
 * Format a number, trimming unnecessary decimals.
 * @param {number} n
 * @returns {string}
 */
function fmtN(n) {
    if (!isFinite(n)) return String(n);
    if (Math.abs(n - Math.round(n)) < EPS) return String(Math.round(n));
    // up to 6 significant decimal places, strip trailing zeros
    var s = n.toFixed(6).replace(/\.?0+$/, '');
    return s === '-0' ? '0' : s;
}

/**
 * Format a coefficient + variable, e.g. 2x, -x, x, -3.5x.
 * Returns '' when n is 0.
 * @param {number} n
 * @param {string} variable
 * @returns {string}
 */
function fmtCoef(n, variable) {
    if (Math.abs(n) < EPS) return '';
    if (Math.abs(Math.abs(n) - 1) < EPS) {
        return (n < 0 ? '-' : '') + variable;
    }
    return fmtN(n) + variable;
}

/**
 * Format a subsequent term with leading sign, e.g. "+ 3y", "- 2y", "" if zero.
 * @param {number} n
 * @param {string} variable
 * @returns {string}
 */
function fmtTerm(n, variable) {
    if (Math.abs(n) < EPS) return '';
    var abs = Math.abs(n);
    var sign = n > 0 ? '+ ' : '- ';
    var coef = Math.abs(Math.abs(n) - 1) < EPS ? '' : fmtN(abs);
    return sign + coef + variable;
}

/**
 * Format a 2-variable equation: ax + by = c
 * @param {number} a
 * @param {number} b
 * @param {number} c
 * @returns {string}
 */
function fmtEq2(a, b, c) {
    var lhs = fmtCoef(a, 'x');
    var term = fmtTerm(b, 'y');
    if (lhs === '' && term === '') return '0 = ' + fmtN(c);
    if (lhs === '') lhs = (b < 0 ? '-' : '') + (Math.abs(Math.abs(b) - 1) < EPS ? '' : fmtN(Math.abs(b))) + 'y';
    else if (term !== '') lhs += ' ' + term;
    else if (term === '' && Math.abs(b) >= EPS) {
        // b is non-zero but fmtTerm returned '' - shouldn't happen
    }
    return lhs + ' = ' + fmtN(c);
}

/**
 * Format a 3-variable equation: ax + by + cz = d
 * @param {number} a
 * @param {number} b
 * @param {number} c
 * @param {number} d
 * @returns {string}
 */
function fmtEq3(a, b, c, d) {
    var parts = [];
    var lhs = '';

    // First non-zero term is the leading term (no sign prefix if positive)
    var terms = [
        { n: a, v: 'x' },
        { n: b, v: 'y' },
        { n: c, v: 'z' }
    ];

    var leading = true;
    for (var i = 0; i < terms.length; i++) {
        var n = terms[i].n, v = terms[i].v;
        if (Math.abs(n) < EPS) continue;
        if (leading) {
            lhs += fmtCoef(n, v);
            leading = false;
        } else {
            var abs = Math.abs(n);
            var sign = n > 0 ? '+ ' : '- ';
            var coef = Math.abs(abs - 1) < EPS ? '' : fmtN(abs);
            lhs += ' ' + sign + coef + v;
        }
    }

    if (lhs === '') lhs = '0';
    return lhs + ' = ' + fmtN(d);
}

// ==================== LaTeX Builders ====================

/**
 * Build augmented matrix LaTeX for 2×2 system: [a b | c; d e | f]
 * @param {Array} rows  Array of 2 rows, each [a, b, c]
 * @returns {string}
 */
function buildAugLatex2(rows) {
    var r0 = rows[0], r1 = rows[1];
    return [
        '\\left[\\begin{array}{cc|c}',
        fmtN(r0[0]) + ' & ' + fmtN(r0[1]) + ' & ' + fmtN(r0[2]) + ' \\\\',
        fmtN(r1[0]) + ' & ' + fmtN(r1[1]) + ' & ' + fmtN(r1[2]),
        '\\end{array}\\right]'
    ].join('\n');
}

/**
 * Build augmented matrix LaTeX for 3×3 system.
 * @param {Array} rows  Array of 3 rows, each [a, b, c, d]
 * @returns {string}
 */
function buildAugLatex3(rows) {
    var r0 = rows[0], r1 = rows[1], r2 = rows[2];
    return [
        '\\left[\\begin{array}{ccc|c}',
        fmtN(r0[0]) + ' & ' + fmtN(r0[1]) + ' & ' + fmtN(r0[2]) + ' & ' + fmtN(r0[3]) + ' \\\\',
        fmtN(r1[0]) + ' & ' + fmtN(r1[1]) + ' & ' + fmtN(r1[2]) + ' & ' + fmtN(r1[3]) + ' \\\\',
        fmtN(r2[0]) + ' & ' + fmtN(r2[1]) + ' & ' + fmtN(r2[2]) + ' & ' + fmtN(r2[3]),
        '\\end{array}\\right]'
    ].join('\n');
}

/**
 * Build a 2×2 matrix LaTeX (no augmentation).
 * @param {Array} m  [[a,b],[c,d]]
 * @returns {string}
 */
function buildMatLatex2(m) {
    return [
        '\\begin{pmatrix}',
        fmtN(m[0][0]) + ' & ' + fmtN(m[0][1]) + ' \\\\',
        fmtN(m[1][0]) + ' & ' + fmtN(m[1][1]),
        '\\end{pmatrix}'
    ].join('\n');
}

/**
 * Format a 2×2 determinant expansion: |a b; c d| = ad - bc = N
 * @param {number} a
 * @param {number} b
 * @param {number} c
 * @param {number} d
 * @returns {string}
 */
function fmtDet2(a, b, c, d) {
    var det = a * d - b * c;
    return [
        '\\begin{vmatrix} ' + fmtN(a) + ' & ' + fmtN(b) + ' \\\\ ' + fmtN(c) + ' & ' + fmtN(d) + ' \\end{vmatrix}',
        '= (' + fmtN(a) + ')(' + fmtN(d) + ') - (' + fmtN(b) + ')(' + fmtN(c) + ')',
        '= ' + fmtN(a * d) + ' - (' + fmtN(b * c) + ')',
        '= ' + fmtN(det)
    ].join(' ');
}

// ==================== Internal Math Helpers ====================

/** Compute 2×2 determinant */
function det2(a, b, c, d) { return a * d - b * c; }

/** Compute 3×3 determinant by cofactor expansion along row 0 */
function det3(m) {
    return m[0][0] * det2(m[1][1], m[1][2], m[2][1], m[2][2])
         - m[0][1] * det2(m[1][0], m[1][2], m[2][0], m[2][2])
         + m[0][2] * det2(m[1][0], m[1][1], m[2][0], m[2][1]);
}

/** Deep-copy a 2D array */
function copyMatrix(m) {
    return m.map(function (row) { return row.slice(); });
}

// ==================== 2×2 Cramer's Rule ====================

/**
 * Cramer's rule for 2×2 system.
 * @param {Array} A  [[a11,a12],[a21,a22]]
 * @param {Array} b  [b1, b2]
 * @returns {Array}  Array of step objects {title, katex, plain}
 */
function renderCramer2x2(A, b) {
    var a11 = A[0][0], a12 = A[0][1];
    var a21 = A[1][0], a22 = A[1][1];
    var b1 = b[0], b2 = b[1];

    var D  = det2(a11, a12, a21, a22);
    var Dx = det2(b1,  a12, b2,  a22);
    var Dy = det2(a11, b1,  a21, b2);

    var steps = [];

    // Step 1: write the system
    steps.push({
        title: 'Write the system',
        katex: '\\begin{cases} ' + fmtEq2(a11, a12, b1) + ' \\\\ ' + fmtEq2(a21, a22, b2) + ' \\end{cases}',
        plain: fmtEq2(a11, a12, b1) + '  |  ' + fmtEq2(a21, a22, b2)
    });

    // Step 2: coefficient matrix determinant D
    steps.push({
        title: 'Compute the coefficient determinant D',
        katex: 'D = ' + fmtDet2(a11, a12, a21, a22),
        plain: 'D = ' + fmtN(D)
    });

    if (Math.abs(D) < EPS) {
        steps.push({
            title: 'D = 0 — Cramer\'s rule does not apply',
            katex: 'D = 0 \\Rightarrow \\text{system is either inconsistent or has infinitely many solutions}',
            plain: 'D = 0. Cannot apply Cramer\'s rule.'
        });
        return steps;
    }

    // Step 3: Dx
    steps.push({
        title: 'Compute D\u209B (replace x-column with constants)',
        katex: 'D_x = ' + fmtDet2(b1, a12, b2, a22),
        plain: 'Dx = ' + fmtN(Dx)
    });

    // Step 4: Dy
    steps.push({
        title: 'Compute D\u1D67 (replace y-column with constants)',
        katex: 'D_y = ' + fmtDet2(a11, b1, a21, b2),
        plain: 'Dy = ' + fmtN(Dy)
    });

    // Step 5: solve
    var x = Dx / D, y = Dy / D;
    steps.push({
        title: 'Apply Cramer\'s rule: x = D\u209B/D, y = D\u1D67/D',
        katex: 'x = \\dfrac{D_x}{D} = \\dfrac{' + fmtN(Dx) + '}{' + fmtN(D) + '} = ' + fmtN(x) +
               ' \\qquad y = \\dfrac{D_y}{D} = \\dfrac{' + fmtN(Dy) + '}{' + fmtN(D) + '} = ' + fmtN(y),
        plain: 'x = ' + fmtN(x) + ', y = ' + fmtN(y)
    });

    return steps;
}

// ==================== 2×2 Gaussian Elimination ====================

/**
 * Gaussian elimination for 2×2 system.
 * @param {Array} A  [[a11,a12],[a21,a22]]
 * @param {Array} b  [b1, b2]
 * @returns {Array}  Steps array
 */
function renderGaussian2x2(A, b) {
    var steps = [];
    var a11 = A[0][0], a12 = A[0][1], b1 = b[0];
    var a21 = A[1][0], a22 = A[1][1], b2 = b[1];

    // Step 1: augmented matrix
    steps.push({
        title: 'Write the augmented matrix [A|b]',
        katex: buildAugLatex2([[a11, a12, b1], [a21, a22, b2]]),
        plain: '[' + fmtN(a11) + ' ' + fmtN(a12) + ' | ' + fmtN(b1) + '; ' + fmtN(a21) + ' ' + fmtN(a22) + ' | ' + fmtN(b2) + ']'
    });

    // Partial pivot: swap rows if needed
    var r0 = [a11, a12, b1];
    var r1 = [a21, a22, b2];

    if (Math.abs(r0[0]) < Math.abs(r1[0])) {
        var tmp = r0; r0 = r1; r1 = tmp;
        steps.push({
            title: 'Partial pivoting: swap R\u2081 and R\u2082 (larger pivot first)',
            katex: 'R_1 \\leftrightarrow R_2 \\quad \\Rightarrow \\quad ' + buildAugLatex2([r0, r1]),
            plain: 'Swap rows for numerical stability.'
        });
    }

    // Forward elimination
    if (Math.abs(r0[0]) < EPS) {
        steps.push({
            title: 'Pivot is zero — system may be singular',
            katex: '\\text{Cannot eliminate: pivot} = 0',
            plain: 'Pivot element is 0.'
        });
        return steps;
    }

    var m = r1[0] / r0[0];
    var nr1 = [
        r1[0] - m * r0[0],
        r1[1] - m * r0[1],
        r1[2] - m * r0[2]
    ];

    var mStr = fmtN(m);
    steps.push({
        title: 'Eliminate x from R\u2082: R\u2082 \u2190 R\u2082 \u2212 (' + mStr + ')R\u2081',
        katex: 'R_2 \\leftarrow R_2 - \\left(' + mStr + '\\right)R_1 \\quad \\Rightarrow \\quad ' + buildAugLatex2([r0, nr1]),
        plain: 'R2 <- R2 - (' + mStr + ')R1'
    });

    // Check for inconsistency / infinite solutions
    if (Math.abs(nr1[0]) < EPS && Math.abs(nr1[1]) < EPS) {
        if (Math.abs(nr1[2]) < EPS) {
            steps.push({
                title: 'Row of zeros obtained \u2014 infinitely many solutions',
                katex: '0 = 0 \\Rightarrow \\text{infinite solutions (dependent equations)}',
                plain: 'Infinite solutions.'
            });
        } else {
            steps.push({
                title: 'Contradiction: 0 = ' + fmtN(nr1[2]) + ' \u2014 no solution',
                katex: '0 = ' + fmtN(nr1[2]) + ' \\Rightarrow \\text{no solution (inconsistent)}',
                plain: 'No solution.'
            });
        }
        return steps;
    }

    // Back-substitution
    var y = nr1[2] / nr1[1];
    var x = (r0[2] - r0[1] * y) / r0[0];

    steps.push({
        title: 'Back-substitute: solve for y from R\u2082',
        katex: fmtN(nr1[1]) + 'y = ' + fmtN(nr1[2]) + ' \\Rightarrow y = \\dfrac{' + fmtN(nr1[2]) + '}{' + fmtN(nr1[1]) + '} = ' + fmtN(y),
        plain: 'y = ' + fmtN(y)
    });

    steps.push({
        title: 'Substitute y = ' + fmtN(y) + ' into R\u2081 to find x',
        katex: fmtN(r0[0]) + 'x + ' + fmtN(r0[1]) + '(' + fmtN(y) + ') = ' + fmtN(r0[2]) +
               ' \\Rightarrow x = \\dfrac{' + fmtN(r0[2]) + ' - ' + fmtN(r0[1] * y) + '}{' + fmtN(r0[0]) + '} = ' + fmtN(x),
        plain: 'x = ' + fmtN(x)
    });

    steps.push({
        title: 'Solution',
        katex: 'x = ' + fmtN(x) + ' \\qquad y = ' + fmtN(y),
        plain: 'x = ' + fmtN(x) + ', y = ' + fmtN(y)
    });

    return steps;
}

// ==================== 2×2 Substitution ====================

/**
 * Substitution method for 2×2 system.
 * @param {Array} A  [[a11,a12],[a21,a22]]
 * @param {Array} b  [b1, b2]
 * @returns {Array}  Steps array
 */
function renderSubstitution2x2(A, b) {
    var steps = [];
    var a11 = A[0][0], a12 = A[0][1], b1 = b[0];
    var a21 = A[1][0], a22 = A[1][1], b2 = b[1];

    // Step 1: write system
    steps.push({
        title: 'Write the system',
        katex: '\\begin{cases} ' + fmtEq2(a11, a12, b1) + ' \\quad (1) \\\\ ' + fmtEq2(a21, a22, b2) + ' \\quad (2) \\end{cases}',
        plain: '(1) ' + fmtEq2(a11, a12, b1) + '  |  (2) ' + fmtEq2(a21, a22, b2)
    });

    // Choose which variable to isolate (x from eq1 if a11 ≠ 0, else y, else from eq2)
    var isolateX = Math.abs(a11) >= EPS;
    var isolateFromEq1 = Math.abs(a11) >= EPS || Math.abs(a12) >= EPS;

    if (!isolateFromEq1) {
        // eq1 is trivial, try eq2
        isolateX = Math.abs(a21) >= EPS;
    }

    if (isolateX && Math.abs(a11) >= EPS) {
        // Isolate x from eq1
        var xCoefStr = fmtN(a11);
        var yPartStr = Math.abs(a12) < EPS ? '' : ' - \\dfrac{' + fmtN(a12) + '}{' + fmtN(a11) + '}y';
        var xExprNum = function (yVal) { return (b1 - a12 * yVal) / a11; };

        steps.push({
            title: 'Isolate x from equation (1)',
            katex: fmtN(a11) + 'x = ' + fmtN(b1) + (Math.abs(a12) < EPS ? '' : ' - ' + fmtN(a12) + 'y') +
                   ' \\Rightarrow x = \\dfrac{' + fmtN(b1) + (Math.abs(a12) < EPS ? '' : ' - ' + fmtN(a12) + 'y') + '}{' + fmtN(a11) + '}',
            plain: 'x = (' + fmtN(b1) + (Math.abs(a12) < EPS ? '' : ' - ' + fmtN(a12) + 'y') + ') / ' + fmtN(a11)
        });

        // Substitute into eq2
        // a21 * ( (b1 - a12*y)/a11 ) + a22*y = b2
        // a21*b1/a11 - a21*a12/a11 * y + a22*y = b2
        // y * (a22 - a21*a12/a11) = b2 - a21*b1/a11
        var yCoef = a22 - a21 * a12 / a11;
        var yRhs  = b2 - a21 * b1 / a11;

        steps.push({
            title: 'Substitute x into equation (2)',
            katex: fmtN(a21) + ' \\cdot \\dfrac{' + fmtN(b1) + (Math.abs(a12) < EPS ? '' : ' - ' + fmtN(a12) + 'y') + '}{' + fmtN(a11) + '} + ' + fmtN(a22) + 'y = ' + fmtN(b2),
            plain: 'Substitute x expression into eq (2).'
        });

        steps.push({
            title: 'Simplify and collect y terms',
            katex: fmtN(yCoef) + 'y = ' + fmtN(yRhs),
            plain: fmtN(yCoef) + 'y = ' + fmtN(yRhs)
        });

        if (Math.abs(yCoef) < EPS) {
            if (Math.abs(yRhs) < EPS) {
                steps.push({ title: 'Infinitely many solutions (0 = 0)', katex: '0 = 0', plain: 'Infinite solutions.' });
            } else {
                steps.push({ title: 'No solution (contradiction: 0 = ' + fmtN(yRhs) + ')', katex: '0 = ' + fmtN(yRhs), plain: 'No solution.' });
            }
            return steps;
        }

        var y = yRhs / yCoef;
        var x = (b1 - a12 * y) / a11;

        steps.push({
            title: 'Solve for y',
            katex: 'y = \\dfrac{' + fmtN(yRhs) + '}{' + fmtN(yCoef) + '} = ' + fmtN(y),
            plain: 'y = ' + fmtN(y)
        });

        steps.push({
            title: 'Back-substitute y = ' + fmtN(y) + ' to find x',
            katex: 'x = \\dfrac{' + fmtN(b1) + ' - ' + fmtN(a12) + '(' + fmtN(y) + ')}{' + fmtN(a11) + '} = \\dfrac{' + fmtN(b1 - a12 * y) + '}{' + fmtN(a11) + '} = ' + fmtN(x),
            plain: 'x = ' + fmtN(x)
        });

        steps.push({
            title: 'Solution',
            katex: 'x = ' + fmtN(x) + ' \\qquad y = ' + fmtN(y),
            plain: 'x = ' + fmtN(x) + ', y = ' + fmtN(y)
        });

    } else if (Math.abs(a12) >= EPS) {
        // Isolate y from eq1
        var yCoefEq1 = a12;
        var yRhsEq1 = b1 - a11 * 0; // will be function of x

        steps.push({
            title: 'Isolate y from equation (1)',
            katex: fmtN(a12) + 'y = ' + fmtN(b1) + (Math.abs(a11) < EPS ? '' : ' - ' + fmtN(a11) + 'x') +
                   ' \\Rightarrow y = \\dfrac{' + fmtN(b1) + (Math.abs(a11) < EPS ? '' : ' - ' + fmtN(a11) + 'x') + '}{' + fmtN(a12) + '}',
            plain: 'y = (' + fmtN(b1) + (Math.abs(a11) < EPS ? '' : ' - ' + fmtN(a11) + 'x') + ') / ' + fmtN(a12)
        });

        // a21*x + a22*(b1 - a11*x)/a12 = b2
        var xCoef2 = a21 - a22 * a11 / a12;
        var xRhs2  = b2 - a22 * b1 / a12;

        steps.push({
            title: 'Substitute y into equation (2) and simplify',
            katex: fmtN(xCoef2) + 'x = ' + fmtN(xRhs2),
            plain: fmtN(xCoef2) + 'x = ' + fmtN(xRhs2)
        });

        if (Math.abs(xCoef2) < EPS) {
            if (Math.abs(xRhs2) < EPS) {
                steps.push({ title: 'Infinitely many solutions', katex: '0 = 0', plain: 'Infinite solutions.' });
            } else {
                steps.push({ title: 'No solution', katex: '0 = ' + fmtN(xRhs2), plain: 'No solution.' });
            }
            return steps;
        }

        var x2 = xRhs2 / xCoef2;
        var y2 = (b1 - a11 * x2) / a12;

        steps.push({
            title: 'Solve for x',
            katex: 'x = \\dfrac{' + fmtN(xRhs2) + '}{' + fmtN(xCoef2) + '} = ' + fmtN(x2),
            plain: 'x = ' + fmtN(x2)
        });

        steps.push({
            title: 'Back-substitute x = ' + fmtN(x2) + ' to find y',
            katex: 'y = \\dfrac{' + fmtN(b1) + ' - ' + fmtN(a11) + '(' + fmtN(x2) + ')}{' + fmtN(a12) + '} = ' + fmtN(y2),
            plain: 'y = ' + fmtN(y2)
        });

        steps.push({
            title: 'Solution',
            katex: 'x = ' + fmtN(x2) + ' \\qquad y = ' + fmtN(y2),
            plain: 'x = ' + fmtN(x2) + ', y = ' + fmtN(y2)
        });

    } else {
        steps.push({
            title: 'Trivial or zero-coefficient system',
            katex: '\\text{Both coefficients of x and y in row 1 are zero}',
            plain: 'Cannot apply substitution — degenerate system.'
        });
    }

    return steps;
}

// ==================== 2×2 Matrix Inversion ====================

/**
 * Matrix inversion method for 2×2 system.
 * Solves [A][x] = [b] via x = A^{-1} b.
 * @param {Array} A  [[a11,a12],[a21,a22]]
 * @param {Array} b  [b1, b2]
 * @returns {Array}  Steps array
 */
function renderMatrix2x2(A, b) {
    var steps = [];
    var a11 = A[0][0], a12 = A[0][1];
    var a21 = A[1][0], a22 = A[1][1];
    var b1 = b[0], b2 = b[1];

    var D = det2(a11, a12, a21, a22);

    // Step 1: matrix form
    steps.push({
        title: 'Write in matrix form A\u22C5x = b',
        katex: buildMatLatex2(A) + ' \\begin{pmatrix} x \\\\ y \\end{pmatrix} = \\begin{pmatrix} ' + fmtN(b1) + ' \\\\ ' + fmtN(b2) + ' \\end{pmatrix}',
        plain: 'Ax = b'
    });

    // Step 2: determinant
    steps.push({
        title: 'Compute det(A)',
        katex: '\\det(A) = ' + fmtDet2(a11, a12, a21, a22),
        plain: 'det(A) = ' + fmtN(D)
    });

    if (Math.abs(D) < EPS) {
        steps.push({
            title: 'det(A) = 0 \u2014 matrix is singular, no unique inverse',
            katex: '\\det(A) = 0 \\Rightarrow A^{-1} \\text{ does not exist}',
            plain: 'Matrix is singular.'
        });
        return steps;
    }

    // Step 3: inverse formula
    var inv = [
        [ a22 / D, -a12 / D],
        [-a21 / D,  a11 / D]
    ];

    steps.push({
        title: 'Inverse formula: A\u207B\u00B9 = (1/det) \u00D7 adjugate(A)',
        katex: 'A^{-1} = \\dfrac{1}{' + fmtN(D) + '} ' + buildMatLatex2([[a22, -a12], [-a21, a11]]) +
               ' = ' + buildMatLatex2(inv),
        plain: 'A-inverse computed.'
    });

    // Step 4: multiply
    var x = inv[0][0] * b1 + inv[0][1] * b2;
    var y = inv[1][0] * b1 + inv[1][1] * b2;

    steps.push({
        title: 'Multiply x = A\u207B\u00B9b',
        katex: '\\begin{pmatrix} x \\\\ y \\end{pmatrix} = ' + buildMatLatex2(inv) +
               ' \\begin{pmatrix} ' + fmtN(b1) + ' \\\\ ' + fmtN(b2) + ' \\end{pmatrix}',
        plain: 'x = A^{-1} * b'
    });

    steps.push({
        title: 'Solution',
        katex: 'x = ' + fmtN(inv[0][0]) + '(' + fmtN(b1) + ') + ' + fmtN(inv[0][1]) + '(' + fmtN(b2) + ') = ' + fmtN(x) +
               ' \\qquad y = ' + fmtN(inv[1][0]) + '(' + fmtN(b1) + ') + ' + fmtN(inv[1][1]) + '(' + fmtN(b2) + ') = ' + fmtN(y),
        plain: 'x = ' + fmtN(x) + ', y = ' + fmtN(y)
    });

    return steps;
}

// ==================== 3×3 Cramer's Rule ====================

/**
 * Cramer's rule for 3×3 system.
 * @param {Array} A  3×3 matrix (array of 3 rows, each with 3 elements)
 * @param {Array} b  [b1, b2, b3]
 * @returns {Array}  Steps array
 */
function renderCramer3x3(A, b) {
    var steps = [];

    // Helper: render 3×3 det LaTeX
    function det3Latex(m) {
        return '\\begin{vmatrix} ' +
            fmtN(m[0][0]) + ' & ' + fmtN(m[0][1]) + ' & ' + fmtN(m[0][2]) + ' \\\\ ' +
            fmtN(m[1][0]) + ' & ' + fmtN(m[1][1]) + ' & ' + fmtN(m[1][2]) + ' \\\\ ' +
            fmtN(m[2][0]) + ' & ' + fmtN(m[2][1]) + ' & ' + fmtN(m[2][2]) + ' \\end{vmatrix}';
    }

    function det3LatexExpansion(m) {
        var d = det3(m);
        var a = m[0][0], bv = m[0][1], c = m[0][2];
        var minor11 = det2(m[1][1], m[1][2], m[2][1], m[2][2]);
        var minor12 = det2(m[1][0], m[1][2], m[2][0], m[2][2]);
        var minor13 = det2(m[1][0], m[1][1], m[2][0], m[2][1]);
        return det3Latex(m) +
            ' = ' + fmtN(a) + '(' + fmtN(minor11) + ') - ' + fmtN(bv) + '(' + fmtN(minor12) + ') + ' + fmtN(c) + '(' + fmtN(minor13) + ')' +
            ' = ' + fmtN(d);
    }

    // Step 1: write system
    steps.push({
        title: 'Write the system',
        katex: '\\begin{cases} ' + fmtEq3(A[0][0], A[0][1], A[0][2], b[0]) + ' \\\\ ' +
               fmtEq3(A[1][0], A[1][1], A[1][2], b[1]) + ' \\\\ ' +
               fmtEq3(A[2][0], A[2][1], A[2][2], b[2]) + ' \\end{cases}',
        plain: fmtEq3(A[0][0], A[0][1], A[0][2], b[0]) + '  |  ' +
               fmtEq3(A[1][0], A[1][1], A[1][2], b[1]) + '  |  ' +
               fmtEq3(A[2][0], A[2][1], A[2][2], b[2])
    });

    // Step 2: D
    var D = det3(A);
    steps.push({
        title: 'Compute D = det(A) (cofactor expansion along row 1)',
        katex: 'D = ' + det3LatexExpansion(A),
        plain: 'D = ' + fmtN(D)
    });

    if (Math.abs(D) < EPS) {
        steps.push({
            title: 'D = 0 \u2014 Cramer\'s rule does not apply',
            katex: 'D = 0 \\Rightarrow \\text{system is singular}',
            plain: 'D = 0, singular system.'
        });
        return steps;
    }

    // Dx: replace col 0 with b
    var Ax = [
        [b[0], A[0][1], A[0][2]],
        [b[1], A[1][1], A[1][2]],
        [b[2], A[2][1], A[2][2]]
    ];
    var Dx = det3(Ax);
    steps.push({
        title: 'Compute D\u209B: replace x-column with constants b',
        katex: 'D_x = ' + det3LatexExpansion(Ax),
        plain: 'Dx = ' + fmtN(Dx)
    });

    // Dy: replace col 1 with b
    var Ay = [
        [A[0][0], b[0], A[0][2]],
        [A[1][0], b[1], A[1][2]],
        [A[2][0], b[2], A[2][2]]
    ];
    var Dy = det3(Ay);
    steps.push({
        title: 'Compute D\u1D67: replace y-column with constants b',
        katex: 'D_y = ' + det3LatexExpansion(Ay),
        plain: 'Dy = ' + fmtN(Dy)
    });

    // Dz: replace col 2 with b
    var Az = [
        [A[0][0], A[0][1], b[0]],
        [A[1][0], A[1][1], b[1]],
        [A[2][0], A[2][1], b[2]]
    ];
    var Dz = det3(Az);
    steps.push({
        title: 'Compute D\u1D69: replace z-column with constants b',
        katex: 'D_z = ' + det3LatexExpansion(Az),
        plain: 'Dz = ' + fmtN(Dz)
    });

    // Solve
    var x = Dx / D, y = Dy / D, z = Dz / D;
    steps.push({
        title: 'Apply Cramer\'s rule: x = D\u209B/D, y = D\u1D67/D, z = D\u1D69/D',
        katex: 'x = \\dfrac{' + fmtN(Dx) + '}{' + fmtN(D) + '} = ' + fmtN(x) +
               ' \\qquad y = \\dfrac{' + fmtN(Dy) + '}{' + fmtN(D) + '} = ' + fmtN(y) +
               ' \\qquad z = \\dfrac{' + fmtN(Dz) + '}{' + fmtN(D) + '} = ' + fmtN(z),
        plain: 'x = ' + fmtN(x) + ', y = ' + fmtN(y) + ', z = ' + fmtN(z)
    });

    return steps;
}

// ==================== 3×3 Gaussian Elimination ====================

/**
 * Full Gaussian elimination with partial pivoting and back-substitution for 3×3.
 * @param {Array} A  3×3 coefficient matrix
 * @param {Array} b  [b1, b2, b3]
 * @returns {Array}  Steps array
 */
function renderGaussian3x3(A, b) {
    var steps = [];

    // Build augmented matrix [A|b] as array of rows
    var aug = [
        [A[0][0], A[0][1], A[0][2], b[0]],
        [A[1][0], A[1][1], A[1][2], b[1]],
        [A[2][0], A[2][1], A[2][2], b[2]]
    ];

    function augRows() { return copyMatrix(aug); }

    // Step 1: initial augmented matrix
    steps.push({
        title: 'Write the augmented matrix [A|b]',
        katex: buildAugLatex3(augRows()),
        plain: 'Initial augmented matrix.'
    });

    // Forward elimination
    for (var col = 0; col < 3; col++) {
        // Partial pivot: find max abs value in column at or below current row
        var maxRow = col, maxVal = Math.abs(aug[col][col]);
        for (var r = col + 1; r < 3; r++) {
            if (Math.abs(aug[r][col]) > maxVal) {
                maxVal = Math.abs(aug[r][col]);
                maxRow = r;
            }
        }

        // Swap rows if needed
        if (maxRow !== col) {
            var tmpRow = aug[col];
            aug[col] = aug[maxRow];
            aug[maxRow] = tmpRow;

            var rLabels = ['R_1', 'R_2', 'R_3'];
            steps.push({
                title: 'Partial pivoting: swap ' + rLabels[col] + ' and ' + rLabels[maxRow] + ' for larger pivot',
                katex: rLabels[col] + ' \\leftrightarrow ' + rLabels[maxRow] + ' \\quad \\Rightarrow \\quad ' + buildAugLatex3(augRows()),
                plain: 'Swap R' + (col + 1) + ' and R' + (maxRow + 1) + '.'
            });
        }

        // Check pivot
        if (Math.abs(aug[col][col]) < EPS) {
            steps.push({
                title: 'Pivot is zero in column ' + (col + 1) + ' \u2014 system may be singular or degenerate',
                katex: '\\text{pivot}_{' + (col + 1) + (col + 1) + '} = 0',
                plain: 'Zero pivot encountered.'
            });
            continue;
        }

        // Eliminate entries below pivot
        for (var row = col + 1; row < 3; row++) {
            if (Math.abs(aug[row][col]) < EPS) continue;

            var m = aug[row][col] / aug[col][col];
            var mFmt = fmtN(m);
            var rLabel = ['R_1', 'R_2', 'R_3'];

            for (var k = col; k < 4; k++) {
                aug[row][k] = aug[row][k] - m * aug[col][k];
                if (Math.abs(aug[row][k]) < EPS) aug[row][k] = 0;
            }

            steps.push({
                title: 'Eliminate column ' + (col + 1) + ' in row ' + (row + 1) + ': ' +
                       'R' + (row + 1) + ' \u2190 R' + (row + 1) + ' \u2212 (' + mFmt + ')R' + (col + 1),
                katex: rLabel[row] + ' \\leftarrow ' + rLabel[row] + ' - \\left(' + mFmt + '\\right)' + rLabel[col] +
                       ' \\quad \\Rightarrow \\quad ' + buildAugLatex3(augRows()),
                plain: 'R' + (row + 1) + ' <- R' + (row + 1) + ' - (' + mFmt + ')R' + (col + 1)
            });
        }
    }

    // Upper-triangular form
    steps.push({
        title: 'Upper-triangular form achieved',
        katex: buildAugLatex3(augRows()),
        plain: 'Upper triangular form.'
    });

    // Check for inconsistency / infinite solutions
    for (var chk = 0; chk < 3; chk++) {
        var allZeroCoef = Math.abs(aug[chk][0]) < EPS && Math.abs(aug[chk][1]) < EPS && Math.abs(aug[chk][2]) < EPS;
        if (allZeroCoef) {
            if (Math.abs(aug[chk][3]) < EPS) {
                steps.push({
                    title: 'Row of zeros: infinitely many solutions',
                    katex: '0 = 0 \\Rightarrow \\text{system has infinitely many solutions}',
                    plain: 'Infinite solutions.'
                });
            } else {
                steps.push({
                    title: 'Contradiction: 0 = ' + fmtN(aug[chk][3]) + ' \u2014 no solution',
                    katex: '0 = ' + fmtN(aug[chk][3]) + ' \\Rightarrow \\text{no solution (inconsistent)}',
                    plain: 'No solution.'
                });
            }
            return steps;
        }
    }

    // Back-substitution
    var sol = [0, 0, 0];
    for (var i = 2; i >= 0; i--) {
        if (Math.abs(aug[i][i]) < EPS) continue;
        var rhs = aug[i][3];
        for (var j = i + 1; j < 3; j++) {
            rhs -= aug[i][j] * sol[j];
        }
        sol[i] = rhs / aug[i][i];
    }

    var varNames = ['x', 'y', 'z'];

    // Show back-substitution step for z
    steps.push({
        title: 'Back-substitute: solve for z from row 3',
        katex: fmtN(aug[2][2]) + 'z = ' + fmtN(aug[2][3]) +
               ' \\Rightarrow z = \\dfrac{' + fmtN(aug[2][3]) + '}{' + fmtN(aug[2][2]) + '} = ' + fmtN(sol[2]),
        plain: 'z = ' + fmtN(sol[2])
    });

    // Show back-substitution step for y
    var yRhsDisp = aug[1][3] - aug[1][2] * sol[2];
    steps.push({
        title: 'Back-substitute z = ' + fmtN(sol[2]) + ' into row 2 to find y',
        katex: fmtN(aug[1][1]) + 'y + ' + fmtN(aug[1][2]) + '(' + fmtN(sol[2]) + ') = ' + fmtN(aug[1][3]) +
               ' \\Rightarrow y = \\dfrac{' + fmtN(yRhsDisp) + '}{' + fmtN(aug[1][1]) + '} = ' + fmtN(sol[1]),
        plain: 'y = ' + fmtN(sol[1])
    });

    // Show back-substitution step for x
    var xRhsDisp = aug[0][3] - aug[0][1] * sol[1] - aug[0][2] * sol[2];
    steps.push({
        title: 'Back-substitute y, z into row 1 to find x',
        katex: fmtN(aug[0][0]) + 'x + ' + fmtN(aug[0][1]) + '(' + fmtN(sol[1]) + ') + ' + fmtN(aug[0][2]) + '(' + fmtN(sol[2]) + ') = ' + fmtN(aug[0][3]) +
               ' \\Rightarrow x = \\dfrac{' + fmtN(xRhsDisp) + '}{' + fmtN(aug[0][0]) + '} = ' + fmtN(sol[0]),
        plain: 'x = ' + fmtN(sol[0])
    });

    steps.push({
        title: 'Solution',
        katex: 'x = ' + fmtN(sol[0]) + ' \\qquad y = ' + fmtN(sol[1]) + ' \\qquad z = ' + fmtN(sol[2]),
        plain: 'x = ' + fmtN(sol[0]) + ', y = ' + fmtN(sol[1]) + ', z = ' + fmtN(sol[2])
    });

    return steps;
}

// ==================== All Methods Summary 2×2 ====================

/**
 * Render a compact summary card showing results from all 4 methods for 2×2.
 * @param {Array} A
 * @param {Array} b
 * @returns {string}  HTML string
 */
function renderAllMethods2x2(A, b) {
    var D = det2(A[0][0], A[0][1], A[1][0], A[1][1]);

    function finalResult(steps) {
        // Find last step with a 'plain' that looks like x=..., y=...
        for (var i = steps.length - 1; i >= 0; i--) {
            if (steps[i].plain && steps[i].plain.indexOf('x =') >= 0) {
                return steps[i].plain;
            }
        }
        return 'N/A';
    }

    var methods = [
        { id: 'cramer',         label: "Cramer's Rule",     steps: Math.abs(D) >= EPS ? renderCramer2x2(A, b) : [] },
        { id: 'gaussian',       label: 'Gaussian Elim.',    steps: renderGaussian2x2(A, b) },
        { id: 'substitution',   label: 'Substitution',      steps: renderSubstitution2x2(A, b) },
        { id: 'matrix',         label: 'Matrix Inversion',  steps: Math.abs(D) >= EPS ? renderMatrix2x2(A, b) : [] }
    ];

    var html = '<div class="sy-summary-grid">';
    for (var i = 0; i < methods.length; i++) {
        var m = methods[i];
        var res = m.steps.length > 0 ? finalResult(m.steps) : 'N/A (D = 0)';
        html += '<div class="sy-summary-card">';
        html += '<div class="sy-summary-card-title">' + m.label + '</div>';
        html += '<div class="sy-summary-result">' + escapeHtml(res) + '</div>';
        html += '</div>';
    }
    html += '</div>';
    return html;
}

// ==================== System Classification ====================

/**
 * Solve the system A x = b and return {x, y, z, det, type}.
 * @param {Array} A  2×2 or 3×3 matrix
 * @param {Array} b  RHS vector
 * @returns {Object}
 */
function solveSystem(A, b) {
    var n = A.length;

    if (n === 2) {
        var D = det2(A[0][0], A[0][1], A[1][0], A[1][1]);
        if (Math.abs(D) < EPS) {
            // Check consistency: if equations are proportional with same ratio on b
            var type = classifySystem2x2(A, b);
            return { x: null, y: null, det: D, type: type };
        }
        var Dx = det2(b[0], A[0][1], b[1], A[1][1]);
        var Dy = det2(A[0][0], b[0], A[1][0], b[1]);
        return { x: Dx / D, y: Dy / D, det: D, type: 'unique' };
    }

    if (n === 3) {
        var D3 = det3(A);
        if (Math.abs(D3) < EPS) {
            // Try to detect infinite vs no solution via augmented matrix rank
            var aug3 = [
                [A[0][0], A[0][1], A[0][2], b[0]],
                [A[1][0], A[1][1], A[1][2], b[1]],
                [A[2][0], A[2][1], A[2][2], b[2]]
            ];
            // Gaussian elimination to test rank
            var rank = computeRankAug(aug3);
            if (rank.rankA < rank.rankAug) {
                return { x: null, y: null, z: null, det: D3, type: 'none' };
            }
            return { x: null, y: null, z: null, det: D3, type: 'infinite' };
        }

        var Ax3 = [[b[0], A[0][1], A[0][2]], [b[1], A[1][1], A[1][2]], [b[2], A[2][1], A[2][2]]];
        var Ay3 = [[A[0][0], b[0], A[0][2]], [A[1][0], b[1], A[1][2]], [A[2][0], b[2], A[2][2]]];
        var Az3 = [[A[0][0], A[0][1], b[0]], [A[1][0], A[1][1], b[1]], [A[2][0], A[2][1], b[2]]];

        return {
            x: det3(Ax3) / D3,
            y: det3(Ay3) / D3,
            z: det3(Az3) / D3,
            det: D3,
            type: 'unique'
        };
    }

    return { type: 'none', det: 0 };
}

/**
 * Compute rank of coefficient matrix and augmented matrix for 3×3.
 * @param {Array} aug  4-column augmented matrix
 * @returns {{rankA, rankAug}}
 */
function computeRankAug(aug) {
    var m = copyMatrix(aug);
    var rowCount = m.length;

    for (var col = 0; col < 3; col++) {
        var pivotRow = -1;
        for (var r = col; r < rowCount; r++) {
            if (Math.abs(m[r][col]) > EPS) { pivotRow = r; break; }
        }
        if (pivotRow === -1) continue;
        var tmp = m[col]; m[col] = m[pivotRow]; m[pivotRow] = tmp;
        for (var r2 = col + 1; r2 < rowCount; r2++) {
            var f = m[r2][col] / m[col][col];
            for (var k = col; k < 4; k++) m[r2][k] -= f * m[col][k];
        }
    }

    var rankA = 0, rankAug = 0;
    for (var i = 0; i < rowCount; i++) {
        var nonzeroA = false, nonzeroAug = false;
        for (var j = 0; j < 3; j++) { if (Math.abs(m[i][j]) > EPS) { nonzeroA = true; break; } }
        if (Math.abs(m[i][3]) > EPS) nonzeroAug = true;
        if (nonzeroA) rankA++;
        if (nonzeroA || nonzeroAug) rankAug++;
    }
    return { rankA: rankA, rankAug: rankAug };
}

/**
 * Classify a 2×2 system.
 * @param {Array} A
 * @param {Array} b
 * @returns {'unique'|'infinite'|'none'}
 */
function classifySystem2x2(A, b) {
    var D = det2(A[0][0], A[0][1], A[1][0], A[1][1]);
    if (Math.abs(D) >= EPS) return 'unique';

    // D = 0: check if rows are proportional with same ratio for b
    var a1 = A[0][0], b1c = A[0][1], c1 = b[0];
    var a2 = A[1][0], b2c = A[1][1], c2 = b[1];

    // If row1 and row2 are proportional (including b), infinite; else no solution
    if (Math.abs(a1) > EPS || Math.abs(b1c) > EPS) {
        var ratio;
        if (Math.abs(a1) > EPS) ratio = a2 / a1;
        else ratio = b2c / b1c;

        var checkA = Math.abs(b2c - ratio * b1c) < EPS;
        var checkB = Math.abs(c2 - ratio * c1) < EPS;
        return (checkA && checkB) ? 'infinite' : 'none';
    }

    // Both coefficients of row1 are zero
    if (Math.abs(c1) < EPS) return 'infinite'; // 0=0, row is trivial
    return 'none';
}

// ==================== DOM Rendering ====================

/**
 * Render a solution type badge HTML string.
 * @param {'unique'|'infinite'|'none'} type
 * @returns {string}
 */
function renderSolutionBadge(type) {
    var map = {
        unique:   { cls: 'sy-badge-unique',   text: 'Unique Solution' },
        infinite: { cls: 'sy-badge-infinite', text: 'Infinite Solutions' },
        none:     { cls: 'sy-badge-none',     text: 'No Solution' },
        dependent:{ cls: 'sy-badge-infinite', text: 'Dependent System' }
    };
    var info = map[type] || map['none'];
    return '<span class="sy-solution-badge ' + info.cls + '">' +
           '<span class="sy-badge-dot"></span>' +
           escapeHtml(info.text) +
           '</span>';
}

/**
 * Build DOM fragment of numbered step cards from a steps array.
 * @param {Array}  steps   Array of {title, katex, plain}
 * @param {string} accent  Optional accent color override (unused currently)
 * @returns {DocumentFragment}
 */
function renderSteps(steps, accent) {
    var frag = document.createDocumentFragment();
    if (!steps || steps.length === 0) return frag;

    for (var i = 0; i < steps.length; i++) {
        var step = steps[i];
        var el = document.createElement('div');
        el.className = 'sy-step';

        var numEl = document.createElement('div');
        numEl.className = 'sy-step-number';
        numEl.textContent = String(i + 1);

        var contentEl = document.createElement('div');
        contentEl.className = 'sy-step-content';

        if (step.title) {
            var titleEl = document.createElement('div');
            titleEl.className = 'sy-step-title';
            titleEl.innerHTML = escapeHtml(step.title);
            contentEl.appendChild(titleEl);
        }

        if (step.katex) {
            var mathEl = document.createElement('div');
            mathEl.className = 'sy-step-math';
            renderKatexEl(mathEl, step.katex, true);
            contentEl.appendChild(mathEl);
        } else if (step.plain) {
            var plainEl = document.createElement('div');
            plainEl.className = 'sy-step-plain';
            plainEl.textContent = step.plain;
            contentEl.appendChild(plainEl);
        }

        el.appendChild(numEl);
        el.appendChild(contentEl);
        frag.appendChild(el);
    }

    return frag;
}

/**
 * Build verification card HTML for 2×2 system.
 * @param {Array}  A
 * @param {Array}  b
 * @param {number} x
 * @param {number} y
 * @returns {string}
 */
function renderVerification2x2(A, b, x, y) {
    var lhs1 = A[0][0] * x + A[0][1] * y;
    var lhs2 = A[1][0] * x + A[1][1] * y;
    var ok1  = Math.abs(lhs1 - b[0]) < 1e-7;
    var ok2  = Math.abs(lhs2 - b[1]) < 1e-7;
    var allOk = ok1 && ok2;

    var checkMark = '&#10003;';
    var crossMark = '&#10007;';

    var html = '<div class="sy-verify-card ' + (allOk ? 'sy-verify-pass' : 'sy-verify-warn') + '">';
    html += '<div class="sy-verify-header">' + (allOk ? checkMark + ' Solution Verified' : crossMark + ' Verification Failed') + '</div>';
    html += '<div class="sy-verify-row"><strong>Eq. 1:</strong> <span>' +
            escapeHtml(fmtEq2(A[0][0], A[0][1], b[0])) +
            '</span> <span class="' + (ok1 ? 'sy-verify-check' : 'sy-verify-fail') + '">' +
            fmtN(lhs1) + ' ' + (ok1 ? checkMark : '&#8800; ' + fmtN(b[0])) + '</span></div>';
    html += '<div class="sy-verify-row"><strong>Eq. 2:</strong> <span>' +
            escapeHtml(fmtEq2(A[1][0], A[1][1], b[1])) +
            '</span> <span class="' + (ok2 ? 'sy-verify-check' : 'sy-verify-fail') + '">' +
            fmtN(lhs2) + ' ' + (ok2 ? checkMark : '&#8800; ' + fmtN(b[1])) + '</span></div>';
    html += '</div>';
    return html;
}

/**
 * Build verification card HTML for 3×3 system.
 * @param {Array}  A
 * @param {Array}  b
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @returns {string}
 */
function renderVerification3x3(A, b, x, y, z) {
    var lhs = [
        A[0][0] * x + A[0][1] * y + A[0][2] * z,
        A[1][0] * x + A[1][1] * y + A[1][2] * z,
        A[2][0] * x + A[2][1] * y + A[2][2] * z
    ];
    var ok = [
        Math.abs(lhs[0] - b[0]) < 1e-7,
        Math.abs(lhs[1] - b[1]) < 1e-7,
        Math.abs(lhs[2] - b[2]) < 1e-7
    ];
    var allOk = ok[0] && ok[1] && ok[2];
    var checkMark = '&#10003;';
    var crossMark = '&#10007;';
    var eqs = [
        fmtEq3(A[0][0], A[0][1], A[0][2], b[0]),
        fmtEq3(A[1][0], A[1][1], A[1][2], b[1]),
        fmtEq3(A[2][0], A[2][1], A[2][2], b[2])
    ];

    var html = '<div class="sy-verify-card ' + (allOk ? 'sy-verify-pass' : 'sy-verify-warn') + '">';
    html += '<div class="sy-verify-header">' + (allOk ? checkMark + ' Solution Verified' : crossMark + ' Verification Failed') + '</div>';
    for (var i = 0; i < 3; i++) {
        html += '<div class="sy-verify-row"><strong>Eq. ' + (i + 1) + ':</strong> <span>' +
                escapeHtml(eqs[i]) +
                '</span> <span class="' + (ok[i] ? 'sy-verify-check' : 'sy-verify-fail') + '">' +
                fmtN(lhs[i]) + ' ' + (ok[i] ? checkMark : '&#8800; ' + fmtN(b[i])) + '</span></div>';
    }
    html += '</div>';
    return html;
}

/**
 * Inject HTML or a DOM fragment into a container element.
 * @param {Element}          container
 * @param {string|Node}      htmlOrFragment
 */
function renderToContainer(container, htmlOrFragment) {
    if (!container) return;
    container.innerHTML = '';
    if (typeof htmlOrFragment === 'string') {
        container.innerHTML = htmlOrFragment;
    } else {
        container.appendChild(htmlOrFragment);
    }
}

/**
 * Run katex.renderMathInElement on a container for inline and display math.
 * @param {Element} container
 */
function katexify(container) {
    if (!container || typeof katex === 'undefined' || !katex.renderMathInElement) return;
    try {
        katex.renderMathInElement(container, {
            delimiters: [
                { left: '\\[', right: '\\]', display: true },
                { left: '\\(', right: '\\)', display: false }
            ],
            throwOnError: false
        });
    } catch (e) {
        /* silent */
    }
}

// ==================== Internal Helpers ====================

/**
 * Render KaTeX into an element.
 * @param {Element} el
 * @param {string}  latex
 * @param {boolean} displayMode
 */
function renderKatexEl(el, latex, displayMode) {
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

function escapeHtml(str) {
    if (typeof str !== 'string') str = String(str);
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
}

// ==================== Exports ====================

window.SystemsSolverRender = {
    fmtN: fmtN,
    fmtCoef: fmtCoef,
    fmtTerm: fmtTerm,
    fmtEq2: fmtEq2,
    fmtEq3: fmtEq3,
    buildAugLatex2: buildAugLatex2,
    buildAugLatex3: buildAugLatex3,
    buildMatLatex2: buildMatLatex2,
    fmtDet2: fmtDet2,
    renderCramer2x2: renderCramer2x2,
    renderGaussian2x2: renderGaussian2x2,
    renderSubstitution2x2: renderSubstitution2x2,
    renderMatrix2x2: renderMatrix2x2,
    renderCramer3x3: renderCramer3x3,
    renderGaussian3x3: renderGaussian3x3,
    renderAllMethods2x2: renderAllMethods2x2,
    solveSystem: solveSystem,
    classifySystem2x2: classifySystem2x2,
    renderSolutionBadge: renderSolutionBadge,
    renderSteps: renderSteps,
    renderVerification2x2: renderVerification2x2,
    renderVerification3x3: renderVerification3x3,
    renderToContainer: renderToContainer,
    katexify: katexify
};

})();
