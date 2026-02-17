/**
 * Linear Solver - Matrix Computation Engines
 * Gaussian elimination, Gauss-Jordan, LU decomposition, Cramer's Rule, Matrix Inverse, Least Squares
 * Polynomial systems via Newton-Raphson with safe expression evaluator
 */
(function() {
'use strict';

var EPS = 1e-10;

// ==================== Utility Functions ====================

function smartFormat(num) {
    if (num === undefined || num === null || isNaN(num)) return '0';
    if (Math.abs(num) < EPS) return '0';
    if (Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(6)).toString();
}

function cloneMatrix(mat) {
    return mat.map(function(row) { return row.slice(); });
}

function multiplyMatrices(A, B) {
    var m = A.length, n = B[0].length, p = B.length;
    var result = [];
    for (var i = 0; i < m; i++) {
        result[i] = [];
        for (var j = 0; j < n; j++) {
            var sum = 0;
            for (var k = 0; k < p; k++) {
                sum += A[i][k] * B[k][j];
            }
            result[i][j] = sum;
        }
    }
    return result;
}

function transpose(A) {
    var m = A.length, n = A[0].length;
    var AT = [];
    for (var j = 0; j < n; j++) {
        AT[j] = [];
        for (var i = 0; i < m; i++) {
            AT[j][i] = A[i][j];
        }
    }
    return AT;
}

function determinant(mat) {
    var n = mat.length;
    if (n === 1) return mat[0][0];
    if (n === 2) return mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0];
    if (n === 3) {
        return mat[0][0] * (mat[1][1] * mat[2][2] - mat[1][2] * mat[2][1]) -
               mat[0][1] * (mat[1][0] * mat[2][2] - mat[1][2] * mat[2][0]) +
               mat[0][2] * (mat[1][0] * mat[2][1] - mat[1][1] * mat[2][0]);
    }
    // General case: LU-based determinant for n > 3
    var A = cloneMatrix(mat);
    var sign = 1;
    for (var k = 0; k < n; k++) {
        var pivot = k;
        for (var i = k + 1; i < n; i++) {
            if (Math.abs(A[i][k]) > Math.abs(A[pivot][k])) pivot = i;
        }
        if (Math.abs(A[pivot][k]) < EPS) return 0;
        if (pivot !== k) {
            var tmp = A[k]; A[k] = A[pivot]; A[pivot] = tmp;
            sign *= -1;
        }
        for (var i = k + 1; i < n; i++) {
            var factor = A[i][k] / A[k][k];
            for (var j = k + 1; j < n; j++) {
                A[i][j] -= factor * A[k][j];
            }
        }
    }
    var det = sign;
    for (var i = 0; i < n; i++) det *= A[i][i];
    return det;
}

function invertMatrix(mat) {
    var n = mat.length;
    var A = cloneMatrix(mat);
    var I = [];
    for (var i = 0; i < n; i++) {
        I[i] = [];
        for (var j = 0; j < n; j++) {
            I[i][j] = i === j ? 1 : 0;
        }
    }

    for (var i = 0; i < n; i++) {
        var pivot = i;
        for (var k = i + 1; k < n; k++) {
            if (Math.abs(A[k][i]) > Math.abs(A[pivot][i])) pivot = k;
        }
        if (Math.abs(A[pivot][i]) < EPS) return null;

        if (pivot !== i) {
            var tmpA = A[i]; A[i] = A[pivot]; A[pivot] = tmpA;
            var tmpI = I[i]; I[i] = I[pivot]; I[pivot] = tmpI;
        }

        var pivotVal = A[i][i];
        for (var j = 0; j < n; j++) {
            A[i][j] /= pivotVal;
            I[i][j] /= pivotVal;
        }

        for (var k = 0; k < n; k++) {
            if (k !== i) {
                var factor = A[k][i];
                for (var j = 0; j < n; j++) {
                    A[k][j] -= factor * A[i][j];
                    I[k][j] -= factor * I[i][j];
                }
            }
        }
    }
    return I;
}

function verifySolution(A, x, b) {
    var result = [];
    for (var i = 0; i < A.length; i++) {
        var sum = 0;
        for (var j = 0; j < x.length; j++) {
            sum += A[i][j] * x[j];
        }
        result.push(sum);
    }
    var maxError = 0;
    for (var i = 0; i < b.length; i++) {
        maxError = Math.max(maxError, Math.abs(result[i] - b[i]));
    }
    return { computed: result, error: maxError };
}

// ==================== LaTeX Formatting ====================

function formatAugmentedMatrix(aug) {
    var m = aug.length;
    var n = aug[0].length - 1;
    var rows = aug.map(function(row) {
        var left = row.slice(0, n).map(function(v) { return smartFormat(v); });
        var right = smartFormat(row[n]);
        return left.concat(['|', right]).join(' & ');
    });
    return '\\left[\\begin{array}{' + Array(n + 1).join('c') + '|c}' + rows.join(' \\\\ ') + '\\end{array}\\right]';
}

function formatVector(vec) {
    return '\\begin{bmatrix}' + vec.map(function(v) { return smartFormat(v); }).join(' \\\\ ') + '\\end{bmatrix}';
}

function formatMatrix(mat) {
    var rows = mat.map(function(row) {
        return row.map(function(v) { return smartFormat(v); }).join(' & ');
    });
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
}

// ==================== Gaussian Elimination ====================

function solveGaussian(A, b) {
    var m = A.length;
    var n = A[0].length;
    var steps = [];

    var aug = A.map(function(row, i) { return row.concat([b[i]]); });

    steps.push({ desc: 'Starting with augmented matrix [A | b]', latex: formatAugmentedMatrix(aug) });

    var pivotRow = 0;

    for (var col = 0; col < n && pivotRow < m; col++) {
        var maxRow = pivotRow;
        for (var i = pivotRow + 1; i < m; i++) {
            if (Math.abs(aug[i][col]) > Math.abs(aug[maxRow][col])) maxRow = i;
        }

        if (Math.abs(aug[maxRow][col]) < EPS) {
            steps.push({ desc: 'Column ' + (col + 1) + ' has no pivot, skipping' });
            continue;
        }

        if (maxRow !== pivotRow) {
            var tmp = aug[maxRow]; aug[maxRow] = aug[pivotRow]; aug[pivotRow] = tmp;
            steps.push({ desc: 'R_{' + (pivotRow + 1) + '} \\leftrightarrow R_{' + (maxRow + 1) + '}', latex: formatAugmentedMatrix(aug) });
        }

        var pivotVal = aug[pivotRow][col];
        if (Math.abs(pivotVal - 1) > EPS) {
            for (var j = 0; j <= n; j++) aug[pivotRow][j] /= pivotVal;
            steps.push({ desc: 'R_{' + (pivotRow + 1) + '} = R_{' + (pivotRow + 1) + '} \\div ' + smartFormat(pivotVal), latex: formatAugmentedMatrix(aug) });
        }

        var eliminated = [];
        for (var i = pivotRow + 1; i < m; i++) {
            var factor = aug[i][col];
            if (Math.abs(factor) > EPS) {
                eliminated.push('R_{' + (i + 1) + '} = R_{' + (i + 1) + '} - ' + smartFormat(factor) + ' \\cdot R_{' + (pivotRow + 1) + '}');
                for (var j = 0; j <= n; j++) aug[i][j] -= factor * aug[pivotRow][j];
            }
        }

        if (eliminated.length > 0) {
            steps.push({ desc: eliminated.join(', \\quad '), latex: formatAugmentedMatrix(aug) });
        }

        pivotRow++;
    }

    steps.push({ desc: 'Row echelon form achieved', latex: formatAugmentedMatrix(aug) });

    // Check inconsistency
    for (var i = 0; i < m; i++) {
        var allZeros = true;
        for (var j = 0; j < n; j++) {
            if (Math.abs(aug[i][j]) > EPS) { allZeros = false; break; }
        }
        if (allZeros && Math.abs(aug[i][n]) > EPS) {
            return { type: 'inconsistent', steps: steps, message: 'Row ' + (i + 1) + ': 0 = ' + smartFormat(aug[i][n]) + ' (contradiction)' };
        }
    }

    // Count pivots
    var pivotCount = 0, pivotCols = [];
    for (var i = 0; i < m && i < n; i++) {
        for (var j = 0; j < n; j++) {
            if (Math.abs(aug[i][j]) > EPS) {
                pivotCount++;
                pivotCols.push(j);
                break;
            }
        }
    }

    if (pivotCount < n) {
        var freeCols = [];
        for (var j = 0; j < n; j++) {
            if (pivotCols.indexOf(j) === -1) freeCols.push(j);
        }
        return { type: 'infinite', steps: steps, pivotCount: pivotCount, freeCols: freeCols, aug: aug };
    }

    // Back substitution
    var x = new Array(n).fill(0);
    steps.push({ desc: 'Back substitution' });

    for (var i = Math.min(m, n) - 1; i >= 0; i--) {
        var pivotCol = -1;
        for (var j = 0; j < n; j++) {
            if (Math.abs(aug[i][j]) > EPS) { pivotCol = j; break; }
        }
        if (pivotCol === -1) continue;

        x[pivotCol] = aug[i][n];
        for (var j = pivotCol + 1; j < n; j++) {
            x[pivotCol] -= aug[i][j] * x[j];
        }
        steps.push({ desc: 'x_{' + (pivotCol + 1) + '} = ' + smartFormat(x[pivotCol]) });
    }

    return { type: 'unique', solution: x, steps: steps };
}

// ==================== Gauss-Jordan (RREF) ====================

function solveGaussJordan(A, b) {
    var m = A.length;
    var n = A[0].length;
    var steps = [];
    var aug = A.map(function(row, i) { return row.concat([b[i]]); });

    steps.push({ desc: 'Starting Gauss-Jordan Elimination (RREF)', latex: formatAugmentedMatrix(aug) });

    var pivotRow = 0;
    for (var col = 0; col < n && pivotRow < m; col++) {
        var maxRow = pivotRow;
        for (var i = pivotRow + 1; i < m; i++) {
            if (Math.abs(aug[i][col]) > Math.abs(aug[maxRow][col])) maxRow = i;
        }
        if (Math.abs(aug[maxRow][col]) < EPS) continue;

        if (maxRow !== pivotRow) {
            var tmp = aug[maxRow]; aug[maxRow] = aug[pivotRow]; aug[pivotRow] = tmp;
            steps.push({ desc: 'R_{' + (pivotRow + 1) + '} \\leftrightarrow R_{' + (maxRow + 1) + '}', latex: formatAugmentedMatrix(aug) });
        }

        var pivotVal = aug[pivotRow][col];
        for (var j = 0; j <= n; j++) aug[pivotRow][j] /= pivotVal;
        steps.push({ desc: 'R_{' + (pivotRow + 1) + '} = R_{' + (pivotRow + 1) + '} \\div ' + smartFormat(pivotVal), latex: formatAugmentedMatrix(aug) });

        // Eliminate all rows (above and below)
        var eliminated = [];
        for (var i = 0; i < m; i++) {
            if (i === pivotRow) continue;
            var factor = aug[i][col];
            if (Math.abs(factor) > EPS) {
                for (var j = 0; j <= n; j++) aug[i][j] -= factor * aug[pivotRow][j];
                eliminated.push('R_{' + (i + 1) + '} = R_{' + (i + 1) + '} - ' + smartFormat(factor) + ' \\cdot R_{' + (pivotRow + 1) + '}');
            }
        }
        if (eliminated.length > 0) {
            steps.push({ desc: eliminated.join(', \\quad '), latex: formatAugmentedMatrix(aug) });
        }

        pivotRow++;
    }

    steps.push({ desc: 'Reduced Row Echelon Form (RREF) achieved', latex: formatAugmentedMatrix(aug) });

    // Check inconsistency
    for (var i = 0; i < m; i++) {
        var allZeros = true;
        for (var j = 0; j < n; j++) {
            if (Math.abs(aug[i][j]) > EPS) { allZeros = false; break; }
        }
        if (allZeros && Math.abs(aug[i][n]) > EPS) {
            return { type: 'inconsistent', steps: steps, message: 'Row ' + (i + 1) + ': 0 = ' + smartFormat(aug[i][n]) };
        }
    }

    var x = new Array(n).fill(0);
    var pivotCols = [];
    for (var i = 0; i < Math.min(m, n); i++) {
        for (var j = 0; j < n; j++) {
            if (Math.abs(aug[i][j]) > EPS) {
                x[j] = aug[i][n];
                pivotCols.push(j);
                break;
            }
        }
    }

    if (pivotCols.length < n) {
        var freeCols = [];
        for (var j = 0; j < n; j++) {
            if (pivotCols.indexOf(j) === -1) freeCols.push(j);
        }
        return { type: 'infinite', steps: steps, pivotCount: pivotCols.length, freeCols: freeCols, aug: aug };
    }

    return { type: 'unique', solution: x, steps: steps };
}

// ==================== LU Decomposition ====================

function solveLU(A, b) {
    var n = A.length;
    var steps = [];
    var L = [];
    var U = cloneMatrix(A);

    for (var i = 0; i < n; i++) {
        L[i] = new Array(n).fill(0);
        L[i][i] = 1;
    }

    steps.push({ desc: 'LU Decomposition: A = LU', latex: 'A = ' + formatMatrix(A) });

    for (var k = 0; k < n; k++) {
        if (Math.abs(U[k][k]) < EPS) {
            return { type: 'inconsistent', steps: steps, message: 'LU decomposition failed (zero pivot at column ' + (k + 1) + ')' };
        }
        for (var i = k + 1; i < n; i++) {
            L[i][k] = U[i][k] / U[k][k];
            for (var j = k; j < n; j++) {
                U[i][j] -= L[i][k] * U[k][j];
            }
        }
    }

    steps.push({ desc: 'Lower triangular matrix L', latex: 'L = ' + formatMatrix(L) });
    steps.push({ desc: 'Upper triangular matrix U', latex: 'U = ' + formatMatrix(U) });

    // Forward substitution: Ly = b
    var y = new Array(n).fill(0);
    for (var i = 0; i < n; i++) {
        y[i] = b[i];
        for (var j = 0; j < i; j++) y[i] -= L[i][j] * y[j];
    }
    steps.push({ desc: 'Forward substitution: Ly = b', latex: 'y = ' + formatVector(y) });

    // Back substitution: Ux = y
    var x = new Array(n).fill(0);
    for (var i = n - 1; i >= 0; i--) {
        x[i] = y[i];
        for (var j = i + 1; j < n; j++) x[i] -= U[i][j] * x[j];
        x[i] /= U[i][i];
    }
    steps.push({ desc: 'Back substitution: Ux = y', latex: 'x = ' + formatVector(x) });

    return { type: 'unique', solution: x, steps: steps };
}

// ==================== Cramer's Rule ====================

function solveCramer(A, b) {
    var n = A.length;
    var steps = [];

    if (n > 4) {
        return { type: 'inconsistent', steps: [], message: "Cramer's rule is only efficient for n ≤ 4" };
    }

    steps.push({ desc: "Cramer's Rule: x_i = \\det(A_i) / \\det(A)" });

    var detA = determinant(A);
    steps.push({ desc: '\\det(A) = ' + smartFormat(detA), latex: 'A = ' + formatMatrix(A) });

    if (Math.abs(detA) < EPS) {
        return { type: 'inconsistent', steps: steps, message: 'det(A) = 0, system has no unique solution' };
    }

    var x = [];
    for (var i = 0; i < n; i++) {
        var Ai = cloneMatrix(A);
        for (var j = 0; j < n; j++) Ai[j][i] = b[j];
        var detAi = determinant(Ai);
        x[i] = detAi / detA;
        steps.push({ desc: 'x_{' + (i + 1) + '} = \\frac{\\det(A_{' + (i + 1) + '})}{\\det(A)} = \\frac{' + smartFormat(detAi) + '}{' + smartFormat(detA) + '} = ' + smartFormat(x[i]) });
    }

    return { type: 'unique', solution: x, steps: steps };
}

// ==================== Matrix Inverse Method ====================

function solveInverse(A, b) {
    var n = A.length;
    var steps = [];

    steps.push({ desc: 'Matrix Inverse Method: x = A^{-1}b' });

    var detA = determinant(A);
    if (Math.abs(detA) < EPS) {
        return { type: 'inconsistent', steps: steps, message: 'Matrix A is singular (det = 0)' };
    }

    var invA = invertMatrix(A);
    if (!invA) {
        return { type: 'inconsistent', steps: steps, message: 'Matrix A is not invertible' };
    }

    steps.push({ desc: 'A^{-1}', latex: 'A^{-1} = ' + formatMatrix(invA) });

    var x = [];
    for (var i = 0; i < n; i++) {
        x[i] = 0;
        for (var j = 0; j < n; j++) {
            x[i] += invA[i][j] * b[j];
        }
    }

    steps.push({ desc: 'x = A^{-1}b', latex: 'x = ' + formatVector(x) });

    return { type: 'unique', solution: x, steps: steps };
}

// ==================== Least Squares ====================

function solveLeastSquares(A, b) {
    var m = A.length;
    var n = A[0].length;
    var steps = [];

    steps.push({ desc: 'Least Squares: minimize \\|Ax - b\\|^2' });
    steps.push({ desc: 'System is ' + m + ' equations, ' + n + ' variables', latex: 'A = ' + formatMatrix(A) + ', \\quad b = ' + formatVector(b) });

    // Compute A^T
    var AT = transpose(A);
    steps.push({ desc: 'Step 1: Compute A^T', latex: 'A^T = ' + formatMatrix(AT) });

    // Compute A^T A (FIXED: was AT[i][k]*AT[j][k], should be AT[i][k]*A[k][j])
    var ATA = [];
    for (var i = 0; i < n; i++) {
        ATA[i] = new Array(n).fill(0);
        for (var j = 0; j < n; j++) {
            for (var k = 0; k < m; k++) {
                ATA[i][j] += AT[i][k] * A[k][j];
            }
        }
    }
    steps.push({ desc: 'Step 2: Compute A^T A', latex: 'A^T A = ' + formatMatrix(ATA) });

    // Compute A^T b
    var ATb = new Array(n).fill(0);
    for (var i = 0; i < n; i++) {
        for (var j = 0; j < m; j++) {
            ATb[i] += AT[i][j] * b[j];
        }
    }
    steps.push({ desc: 'Step 3: Compute A^T b', latex: 'A^T b = ' + formatVector(ATb) });

    // Solve (A^T A) x = A^T b
    steps.push({ desc: 'Step 4: Solve normal equations (A^T A)x = A^T b' });
    var result = solveGaussian(ATA, ATb);

    if (result.type !== 'unique') {
        return { type: 'inconsistent', steps: steps, message: 'Normal equations singular (A^T A not invertible)' };
    }

    var x = result.solution;
    steps.push({ desc: 'Least squares solution', latex: 'x = ' + formatVector(x) });

    // Compute residual
    var Ax = new Array(m).fill(0);
    for (var i = 0; i < m; i++) {
        for (var j = 0; j < n; j++) {
            Ax[i] += A[i][j] * x[j];
        }
    }

    var residuals = new Array(m).fill(0);
    var residualNorm = 0;
    for (var i = 0; i < m; i++) {
        residuals[i] = Ax[i] - b[i];
        residualNorm += residuals[i] * residuals[i];
    }
    residualNorm = Math.sqrt(residualNorm);

    steps.push({ desc: 'Residual \\|Ax - b\\| = ' + smartFormat(residualNorm) });

    return { type: 'least-squares', solution: x, residual: residualNorm, residuals: residuals, Ax: Ax, steps: steps };
}

// ==================== Safe Expression Evaluator ====================
// Replaces eval() for polynomial evaluation

function safeEval(expr, vars) {
    // Tokenize and evaluate using a simple recursive descent parser
    var pos = 0;
    var str = expr.replace(/\s+/g, '');

    function peek() { return str[pos] || ''; }
    function consume() { return str[pos++]; }

    function parseNumber() {
        var start = pos;
        if (peek() === '-' || peek() === '+') pos++;
        while (/[0-9.]/.test(peek())) pos++;
        var num = parseFloat(str.substring(start, pos));
        if (isNaN(num)) throw new Error('Invalid number at position ' + start);
        return num;
    }

    function parseAtom() {
        // Parenthesized expression
        if (peek() === '(') {
            consume(); // '('
            var val = parseExpr();
            if (peek() === ')') consume(); // ')'
            return val;
        }

        // Negative prefix
        if (peek() === '-') {
            consume();
            return -parsePower();
        }

        // Variable or number
        if (/[a-zA-Z]/.test(peek())) {
            var name = '';
            while (/[a-zA-Z_]/.test(peek())) name += consume();
            // Check built-in functions
            if (name === 'sqrt' && peek() === '(') {
                consume();
                var val = parseExpr();
                if (peek() === ')') consume();
                return Math.sqrt(val);
            }
            if (name === 'abs' && peek() === '(') {
                consume();
                var val = parseExpr();
                if (peek() === ')') consume();
                return Math.abs(val);
            }
            if (name === 'sin' && peek() === '(') {
                consume();
                var val = parseExpr();
                if (peek() === ')') consume();
                return Math.sin(val);
            }
            if (name === 'cos' && peek() === '(') {
                consume();
                var val = parseExpr();
                if (peek() === ')') consume();
                return Math.cos(val);
            }
            if (name === 'exp' && peek() === '(') {
                consume();
                var val = parseExpr();
                if (peek() === ')') consume();
                return Math.exp(val);
            }
            if (name === 'log' && peek() === '(') {
                consume();
                var val = parseExpr();
                if (peek() === ')') consume();
                return Math.log(val);
            }
            // Variable lookup
            if (vars.hasOwnProperty(name)) return vars[name];
            if (name === 'pi' || name === 'PI') return Math.PI;
            if (name === 'e' || name === 'E') return Math.E;
            throw new Error('Unknown variable: ' + name);
        }

        return parseNumber();
    }

    function parsePower() {
        var base = parseAtom();
        if (peek() === '^' || (peek() === '*' && str[pos + 1] === '*')) {
            if (peek() === '*') { consume(); consume(); }
            else { consume(); }
            var exp = parsePower(); // right-associative
            return Math.pow(base, exp);
        }
        return base;
    }

    function parseImplicitMul() {
        var val = parsePower();
        // Implicit multiplication: 2x, xy, 2(x+1), etc.
        while (pos < str.length && (peek() === '(' || /[a-zA-Z]/.test(peek()))) {
            // Check it's not an operator
            if ('+-*/^)'.indexOf(peek()) >= 0) break;
            val *= parsePower();
        }
        return val;
    }

    function parseTerm() {
        var val = parseImplicitMul();
        while (peek() === '*' || peek() === '/') {
            var op = consume();
            var right = parseImplicitMul();
            if (op === '*') val *= right;
            else val /= right;
        }
        return val;
    }

    function parseExpr() {
        var val = parseTerm();
        while (peek() === '+' || peek() === '-') {
            var op = consume();
            var right = parseTerm();
            if (op === '+') val += right;
            else val -= right;
        }
        return val;
    }

    var result = parseExpr();
    return result;
}

// ==================== Polynomial System Solver (Newton-Raphson) ====================

function evaluatePolynomial(expr, x, numVars) {
    var varNames = ['x', 'y', 'z'];
    var vars = {};
    for (var i = 0; i < numVars; i++) {
        vars[varNames[i]] = x[i];
    }
    return safeEval(expr, vars);
}

function computeJacobian(functions, x, numVars) {
    var n = functions.length;
    var J = [];
    var h = 1e-7;

    for (var i = 0; i < n; i++) {
        J[i] = new Array(numVars).fill(0);
        for (var j = 0; j < numVars; j++) {
            var xPlus = x.slice();
            var xMinus = x.slice();
            xPlus[j] += h;
            xMinus[j] -= h;

            var fPlus = evaluatePolynomial(functions[i].left, xPlus, numVars) - evaluatePolynomial(functions[i].right, xPlus, numVars);
            var fMinus = evaluatePolynomial(functions[i].left, xMinus, numVars) - evaluatePolynomial(functions[i].right, xMinus, numVars);

            J[i][j] = (fPlus - fMinus) / (2 * h);
        }
    }

    return J;
}

function solvePolynomialSystem(equations, numVars, guess) {
    var steps = [];
    var varNames = ['x', 'y', 'z'];
    var maxIter = 20;
    var tolerance = 1e-8;

    steps.push({ desc: 'Newton-Raphson Method for Polynomial System' });
    steps.push({ desc: 'Variables: ' + varNames.slice(0, numVars).join(', ') + ', Tolerance: ' + tolerance });

    var x = guess.slice();
    steps.push({ desc: 'Initial guess: (' + x.map(function(v) { return smartFormat(v); }).join(', ') + ')' });

    var converged = false;

    for (var iter = 0; iter < maxIter; iter++) {
        var f = equations.map(function(eq) {
            return evaluatePolynomial(eq.left, x, numVars) - evaluatePolynomial(eq.right, x, numVars);
        });

        var norm = Math.sqrt(f.reduce(function(sum, val) { return sum + val * val; }, 0));

        if (iter % 3 === 0 || norm < tolerance || iter === maxIter - 1) {
            steps.push({ desc: 'Iteration ' + (iter + 1) + ': (' + x.map(function(v) { return smartFormat(v); }).join(', ') + '), \\|f\\| = ' + smartFormat(norm) });
        }

        if (norm < tolerance) {
            converged = true;
            steps.push({ desc: 'Converged after ' + (iter + 1) + ' iterations' });
            break;
        }

        var J = computeJacobian(equations, x, numVars);
        var negF = f.map(function(v) { return -v; });
        var deltaResult = solveGaussian(J, negF);

        if (deltaResult.type !== 'unique') {
            return { type: 'inconsistent', steps: steps, message: 'Jacobian singular at iteration ' + (iter + 1) };
        }

        var delta = deltaResult.solution;
        for (var i = 0; i < numVars; i++) {
            x[i] += delta[i];
        }
    }

    if (!converged) {
        steps.push({ desc: 'Did not converge after ' + maxIter + ' iterations. Solution may be approximate.' });
    }

    // Verification
    steps.push({ desc: 'Verification:' });
    for (var i = 0; i < equations.length; i++) {
        var left = evaluatePolynomial(equations[i].left, x, numVars);
        var right = evaluatePolynomial(equations[i].right, x, numVars);
        var residual = Math.abs(left - right);
        steps.push({ desc: 'Eq ' + (i + 1) + ': ' + smartFormat(left) + ' \\approx ' + smartFormat(right) + ' \\quad (\\text{error: }' + residual.toExponential(2) + ')' });
    }

    return { type: 'polynomial-solution', solution: x, converged: converged, steps: steps };
}

// ==================== Auto-Select Solver ====================

function autoSelectMethod(m, n) {
    if (m > n) return 'least-squares';
    if (m < n) return 'gaussian';
    if (n <= 3) return 'gaussian';
    return 'gaussian';
}

// ==================== Exports ====================

window.LinearSolverMatrix = {
    EPS: EPS,
    smartFormat: smartFormat,
    cloneMatrix: cloneMatrix,
    multiplyMatrices: multiplyMatrices,
    transpose: transpose,
    determinant: determinant,
    invertMatrix: invertMatrix,
    verifySolution: verifySolution,
    formatAugmentedMatrix: formatAugmentedMatrix,
    formatVector: formatVector,
    formatMatrix: formatMatrix,
    solveGaussian: solveGaussian,
    solveGaussJordan: solveGaussJordan,
    solveLU: solveLU,
    solveCramer: solveCramer,
    solveInverse: solveInverse,
    solveLeastSquares: solveLeastSquares,
    solvePolynomialSystem: solvePolynomialSystem,
    evaluatePolynomial: evaluatePolynomial,
    safeEval: safeEval,
    autoSelectMethod: autoSelectMethod
};

})();
