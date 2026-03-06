/**
 * Matrix Practice Problems Generator
 * Shared problem generator for all 9 matrix calculator pages.
 * Works with ToolUtils.PracticeSheet from practice-sheet.js
 */
(function() {
    'use strict';

    // ── Helpers ──────────────────────────────────────────────────────────

    function randInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function randMatrix(rows, cols, min, max) {
        var m = [];
        for (var i = 0; i < rows; i++) {
            var row = [];
            for (var j = 0; j < cols; j++) row.push(randInt(min, max));
            m.push(row);
        }
        return m;
    }

    function smartFmt(n) {
        if (typeof n === 'string') return n;
        if (Number.isInteger(n)) return String(n);
        return parseFloat(n.toFixed(2)).toString();
    }

    function exactFmt(n) {
        if (window.MatrixUtils && typeof window.MatrixUtils.formatExactNumber === 'function') {
            return window.MatrixUtils.formatExactNumber(n);
        }
        return smartFmt(n);
    }

    function matToStr(m) {
        return m.map(function(r) { return r.map(smartFmt).join(' '); }).join('; ');
    }

    function matToHtml(m) {
        var h = '<table style="border-collapse:collapse;margin:0.5rem 0;display:inline-table">';
        for (var i = 0; i < m.length; i++) {
            h += '<tr>';
            for (var j = 0; j < m[i].length; j++) {
                h += '<td style="border:1px solid var(--border,#ccc);padding:4px 10px;text-align:center;font-family:monospace;min-width:32px">' + smartFmt(m[i][j]) + '</td>';
            }
            h += '</tr>';
        }
        h += '</table>';
        return h;
    }

    function randFractionEntry(min, max, minDen, maxDen) {
        var den = randInt(minDen || 2, maxDen || 11);
        var num = randInt(min * den, max * den);
        if (num === 0) num = den;
        return { value: num / den, text: num + '/' + den };
    }

    function randMatrixWithFractions(rows, cols, min, max, fractionProbability) {
        var numeric = [];
        var display = [];
        for (var i = 0; i < rows; i++) {
            var nRow = [];
            var dRow = [];
            for (var j = 0; j < cols; j++) {
                if (Math.random() < (fractionProbability == null ? 0.45 : fractionProbability)) {
                    var entry = randFractionEntry(min, max, 2, 11);
                    nRow.push(entry.value);
                    dRow.push(entry.text);
                } else {
                    var iv = randInt(min, max);
                    nRow.push(iv);
                    dRow.push(String(iv));
                }
            }
            numeric.push(nRow);
            display.push(dRow);
        }
        return { numeric: numeric, display: display };
    }

    // ── Matrix operations ────────────────────────────────────────────────

    function matAdd(A, B) {
        var R = [];
        for (var i = 0; i < A.length; i++) {
            var row = [];
            for (var j = 0; j < A[0].length; j++) row.push(A[i][j] + B[i][j]);
            R.push(row);
        }
        return R;
    }

    function matSub(A, B) {
        var R = [];
        for (var i = 0; i < A.length; i++) {
            var row = [];
            for (var j = 0; j < A[0].length; j++) row.push(A[i][j] - B[i][j]);
            R.push(row);
        }
        return R;
    }

    function matScale(c, A) {
        return A.map(function(r) { return r.map(function(v) { return c * v; }); });
    }

    function matMul(A, B) {
        var rA = A.length, cA = A[0].length, cB = B[0].length;
        var R = [];
        for (var i = 0; i < rA; i++) {
            var row = [];
            for (var j = 0; j < cB; j++) {
                var s = 0;
                for (var k = 0; k < cA; k++) s += A[i][k] * B[k][j];
                row.push(s);
            }
            R.push(row);
        }
        return R;
    }

    function matTranspose(m) {
        var R = [];
        for (var j = 0; j < m[0].length; j++) {
            var row = [];
            for (var i = 0; i < m.length; i++) row.push(m[i][j]);
            R.push(row);
        }
        return R;
    }

    function det2x2(m) {
        return m[0][0] * m[1][1] - m[0][1] * m[1][0];
    }

    function det3x3(m) {
        return m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
             - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
             + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
    }

    function detNxN(m) {
        var n = m.length;
        if (n === 1) return m[0][0];
        if (n === 2) return det2x2(m);
        if (n === 3) return det3x3(m);
        var det = 0;
        for (var j = 0; j < n; j++) {
            var sub = [];
            for (var i = 1; i < n; i++) {
                var row = [];
                for (var k = 0; k < n; k++) { if (k !== j) row.push(m[i][k]); }
                sub.push(row);
            }
            det += (j % 2 === 0 ? 1 : -1) * m[0][j] * detNxN(sub);
        }
        return det;
    }

    function inv2x2(m) {
        var d = det2x2(m);
        if (d === 0) return null;
        return [
            [m[1][1] / d, -m[0][1] / d],
            [-m[1][0] / d, m[0][0] / d]
        ];
    }

    function inv3x3(m) {
        var d = det3x3(m);
        if (d === 0) return null;
        var cofactors = [];
        for (var i = 0; i < 3; i++) {
            var row = [];
            for (var j = 0; j < 3; j++) {
                var sub = [];
                for (var r = 0; r < 3; r++) {
                    if (r === i) continue;
                    var srow = [];
                    for (var c = 0; c < 3; c++) { if (c !== j) srow.push(m[r][c]); }
                    sub.push(srow);
                }
                row.push(((i + j) % 2 === 0 ? 1 : -1) * det2x2(sub));
            }
            cofactors.push(row);
        }
        var adj = matTranspose(cofactors);
        return adj.map(function(r) { return r.map(function(v) { return v / d; }); });
    }

    /** Generate a nice 3x3 matrix with integer inverse */
    function niceInvertible3x3() {
        // Use a product of elementary matrices with small entries
        for (var attempt = 0; attempt < 50; attempt++) {
            var m = randMatrix(3, 3, -3, 3);
            var d = det3x3(m);
            if (d !== 0 && Math.abs(d) <= 3) {
                var inv = inv3x3(m);
                if (inv) {
                    var allInt = true;
                    for (var i = 0; i < 3; i++)
                        for (var j = 0; j < 3; j++)
                            if (!Number.isInteger(inv[i][j])) allInt = false;
                    if (allInt) return m;
                }
            }
        }
        // Fallback: identity-like
        return [[1, 0, 1], [0, 1, 0], [1, 0, 2]];
    }

    function matRREF(m) {
        // clone
        var A = m.map(function(r) { return r.slice(); });
        var rows = A.length, cols = A[0].length;
        var r = 0;
        for (var c = 0; c < cols && r < rows; c++) {
            // find pivot
            var pivot = -1;
            for (var i = r; i < rows; i++) {
                if (Math.abs(A[i][c]) > 1e-10) { pivot = i; break; }
            }
            if (pivot === -1) continue;
            var tmp = A[r]; A[r] = A[pivot]; A[pivot] = tmp;
            var scale = A[r][c];
            for (var j = 0; j < cols; j++) A[r][j] /= scale;
            for (var i = 0; i < rows; i++) {
                if (i === r) continue;
                var f = A[i][c];
                for (var j = 0; j < cols; j++) A[i][j] -= f * A[r][j];
            }
            r++;
        }
        return { rref: A, rank: r };
    }

    function pick(arr) { return arr[randInt(0, arr.length - 1)]; }

    // ── Problem generators ───────────────────────────────────────────────

    // 1. ADDITION
    function genAddition(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var type = pick(['add', 'sub']);
                var A = randMatrix(2, 2, -9, 9), B = randMatrix(2, 2, -9, 9);
                var ans = type === 'add' ? matAdd(A, B) : matSub(A, B);
                var op = type === 'add' ? '+' : '−';
                p = {
                    prompt: 'Compute A ' + op + ' B:<br>' + matToHtml(A) + ' <span style="font-size:1.3rem;vertical-align:middle;margin:0 0.5rem">' + op + '</span> ' + matToHtml(B),
                    hint: type === 'add' ? 'Add corresponding entries' : 'Subtract corresponding entries',
                    fields: [{ id: 'result', label: 'Result (row; row)', answer: matToStr(ans), placeholder: 'e.g. 3 5; 7 9' }]
                };
            } else if (difficulty === 'medium') {
                var variant = pick(['add3', 'scalar']);
                if (variant === 'add3') {
                    var A = randMatrix(3, 3, -5, 5), B = randMatrix(3, 3, -5, 5);
                    var ans = matAdd(A, B);
                    p = {
                        prompt: 'Compute A + B:<br>' + matToHtml(A) + ' <span style="font-size:1.3rem;vertical-align:middle;margin:0 0.5rem">+</span> ' + matToHtml(B),
                        hint: 'Add corresponding entries element-wise',
                        fields: [{ id: 'result', label: 'Result (row; row; row)', answer: matToStr(ans), placeholder: 'e.g. 1 2 3; 4 5 6; 7 8 9' }]
                    };
                } else {
                    var c = randInt(2, 5);
                    var A = randMatrix(3, 3, -5, 5);
                    var ans = matScale(c, A);
                    p = {
                        prompt: 'Compute ' + c + 'A where A =<br>' + matToHtml(A),
                        hint: 'Multiply every entry by ' + c,
                        fields: [{ id: 'result', label: 'Result (row; row; row)', answer: matToStr(ans), placeholder: 'e.g. 1 2 3; 4 5 6; 7 8 9' }]
                    };
                }
            } else {
                var a = randInt(2, 4), b = randInt(2, 4);
                var A = randMatrix(2, 2, -5, 5), B = randMatrix(2, 2, -5, 5);
                var ans = matAdd(matScale(a, A), matScale(b, B));
                p = {
                    prompt: 'Compute ' + a + 'A + ' + b + 'B:<br>A = ' + matToHtml(A) + '<br>B = ' + matToHtml(B),
                    hint: 'Scale each matrix first, then add',
                    fields: [{ id: 'result', label: 'Result (row; row)', answer: matToStr(ans), placeholder: 'e.g. 3 5; 7 9' }]
                };
            }
            problems.push(p);
        }
        return problems;
    }

    // 2. MULTIPLICATION
    function genMultiplication(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var A = randMatrix(2, 2, -5, 5), B = randMatrix(2, 2, -5, 5);
                var ans = matMul(A, B);
                p = {
                    prompt: 'Compute A × B:<br>' + matToHtml(A) + ' <span style="font-size:1.3rem;vertical-align:middle;margin:0 0.5rem">×</span> ' + matToHtml(B),
                    hint: 'Row × column dot products',
                    fields: [{ id: 'result', label: 'Result (row; row)', answer: matToStr(ans), placeholder: 'e.g. 3 5; 7 9' }]
                };
            } else if (difficulty === 'medium') {
                var A = randMatrix(2, 3, -4, 4), B = randMatrix(3, 2, -4, 4);
                var ans = matMul(A, B);
                p = {
                    prompt: 'Compute A × B (2×3 · 3×2):<br>' + matToHtml(A) + ' <span style="font-size:1.3rem;vertical-align:middle;margin:0 0.5rem">×</span> ' + matToHtml(B),
                    hint: 'Result is 2×2. Each entry = dot product of A row and B column',
                    fields: [{ id: 'result', label: 'Result (row; row)', answer: matToStr(ans), placeholder: 'e.g. 3 5; 7 9' }]
                };
            } else {
                var A = randMatrix(3, 3, -3, 3), B = randMatrix(3, 3, -3, 3);
                var ans = matMul(A, B);
                p = {
                    prompt: 'Compute A × B (3×3):<br>' + matToHtml(A) + ' <span style="font-size:1.3rem;vertical-align:middle;margin:0 0.5rem">×</span> ' + matToHtml(B),
                    hint: 'Each entry c_ij = sum of a_ik * b_kj for k=1..3',
                    fields: [{ id: 'result', label: 'Result (row; row; row)', answer: matToStr(ans), placeholder: 'e.g. 1 2 3; 4 5 6; 7 8 9' }]
                };
            }
            problems.push(p);
        }
        return problems;
    }

    // 3. DETERMINANT
    function genDeterminant(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var useFraction = Math.random() < 0.45;
                var m = useFraction ? randMatrixWithFractions(2, 2, -9, 9, 0.6) : { numeric: randMatrix(2, 2, -9, 9), display: null };
                var d = det2x2(m.numeric);
                p = {
                    prompt: 'Find det(A):<br>' + matToHtml(m.display || m.numeric),
                    hint: 'det = ad − bc for [[a,b],[c,d]]',
                    fields: [{ id: 'det', label: 'det(A)', answer: exactFmt(d) }]
                };
            } else if (difficulty === 'medium') {
                var useFraction = Math.random() < 0.35;
                var m = useFraction ? randMatrixWithFractions(3, 3, -5, 5, 0.45) : { numeric: randMatrix(3, 3, -5, 5), display: null };
                var d = det3x3(m.numeric);
                p = {
                    prompt: 'Find det(A):<br>' + matToHtml(m.display || m.numeric),
                    hint: 'Expand along the first row using cofactors',
                    fields: [{ id: 'det', label: 'det(A)', answer: exactFmt(d) }]
                };
            } else {
                var variant = pick(['det4', 'singular', 'det4_fraction']);
                if (variant === 'det4') {
                    var m = randMatrix(4, 4, -3, 3);
                    var d = detNxN(m);
                    p = {
                        prompt: 'Find det(A) for this 4×4 matrix:<br>' + matToHtml(m),
                        hint: 'Expand by cofactors along a row with zeros, or row-reduce',
                        fields: [{ id: 'det', label: 'det(A)', answer: exactFmt(d) }]
                    };
                } else if (variant === 'det4_fraction') {
                    var m = randMatrixWithFractions(4, 4, -3, 3, 0.4);
                    var d = detNxN(m.numeric);
                    p = {
                        prompt: 'Find det(A) for this 4×4 matrix with fractions:<br>' + matToHtml(m.display),
                        hint: 'Use row-reduction/LU carefully with fraction arithmetic',
                        fields: [{ id: 'det', label: 'det(A)', answer: exactFmt(d) }]
                    };
                } else {
                    // make singular: row3 = row1 + row2
                    var m = randMatrix(3, 3, -5, 5);
                    for (var j = 0; j < 3; j++) m[2][j] = m[0][j] + m[1][j];
                    p = {
                        prompt: 'Is this matrix singular? Find det(A):<br>' + matToHtml(m),
                        hint: 'Look at the relationship between rows',
                        fields: [
                            { id: 'det', label: 'det(A)', answer: exactFmt(0) },
                            { id: 'singular', label: 'Singular? (yes/no)', answer: 'yes' }
                        ]
                    };
                }
            }
            problems.push(p);
        }
        return problems;
    }

    // 4. INVERSE
    function genInverse(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                // ensure invertible 2x2 with integer inverse
                var m, inv;
                for (var a = 0; a < 50; a++) {
                    m = randMatrix(2, 2, -5, 5);
                    var d = det2x2(m);
                    if (Math.abs(d) === 1) { inv = inv2x2(m); break; }
                }
                if (!inv) { m = [[1, 2], [0, 1]]; inv = [[1, -2], [0, 1]]; }
                p = {
                    prompt: 'Find A⁻¹:<br>' + matToHtml(m),
                    hint: 'Use formula: (1/det) × [[d,−b],[−c,a]]',
                    fields: [{ id: 'result', label: 'A⁻¹ (row; row)', answer: matToStr(inv), placeholder: 'e.g. 1 -2; 0 1' }]
                };
            } else if (difficulty === 'medium') {
                var m = niceInvertible3x3();
                var inv = inv3x3(m);
                p = {
                    prompt: 'Find A⁻¹ (3×3):<br>' + matToHtml(m),
                    hint: 'Use cofactor/adjugate method or row-reduce [A|I]',
                    fields: [{ id: 'result', label: 'A⁻¹ (row; row; row)', answer: matToStr(inv), placeholder: 'e.g. 1 0 0; 0 1 0; 0 0 1' }]
                };
            } else {
                var variant = pick(['invertible', 'singular']);
                if (variant === 'singular') {
                    var m = randMatrix(3, 3, -4, 4);
                    for (var j = 0; j < 3; j++) m[2][j] = m[0][j] + m[1][j];
                    p = {
                        prompt: 'Is A invertible? If yes, find A⁻¹:<br>' + matToHtml(m),
                        hint: 'Check det(A) first',
                        fields: [
                            { id: 'invertible', label: 'Invertible? (yes/no)', answer: 'no' },
                            { id: 'reason', label: 'Why? (det=0 / rows dependent / other)', answer: 'det=0' }
                        ]
                    };
                } else {
                    var m = niceInvertible3x3();
                    var inv = inv3x3(m);
                    var d = det3x3(m);
                    p = {
                        prompt: 'Is A invertible? If yes, find A⁻¹:<br>' + matToHtml(m),
                        hint: 'First compute det(A)',
                        fields: [
                            { id: 'invertible', label: 'Invertible? (yes/no)', answer: 'yes' },
                            { id: 'result', label: 'A⁻¹ (row; row; row)', answer: matToStr(inv), placeholder: 'e.g. 1 0 0; 0 1 0; 0 0 1' }
                        ]
                    };
                }
            }
            problems.push(p);
        }
        return problems;
    }

    // 5. TRANSPOSE
    function genTranspose(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var m = randMatrix(2, 3, -9, 9);
                var t = matTranspose(m);
                p = {
                    prompt: 'Find Aᵀ:<br>' + matToHtml(m),
                    hint: 'Swap rows and columns: (Aᵀ)ᵢⱼ = Aⱼᵢ',
                    fields: [{ id: 'result', label: 'Aᵀ (row; row; row)', answer: matToStr(t), placeholder: 'e.g. 1 4; 2 5; 3 6' }]
                };
            } else if (difficulty === 'medium') {
                var m = randMatrix(3, 3, -5, 5);
                var t = matTranspose(m);
                p = {
                    prompt: 'Find Aᵀ:<br>' + matToHtml(m),
                    hint: 'Swap rows and columns for the 3×3 matrix',
                    fields: [{ id: 'result', label: 'Aᵀ (row; row; row)', answer: matToStr(t), placeholder: 'e.g. 1 2 3; 4 5 6; 7 8 9' }]
                };
            } else {
                var variant = pick(['symmetric', 'skew']);
                var m = randMatrix(3, 3, -4, 4);
                if (variant === 'symmetric') {
                    // make symmetric: A = (M + Mᵀ)/2 but keep ints
                    for (var r = 0; r < 3; r++)
                        for (var c = r + 1; c < 3; c++)
                            m[c][r] = m[r][c];
                    var isSym = 'yes';
                    p = {
                        prompt: 'Is this matrix symmetric (A = Aᵀ)?<br>' + matToHtml(m),
                        hint: 'Compare A with Aᵀ — symmetric means aᵢⱼ = aⱼᵢ for all i,j',
                        fields: [{ id: 'symmetric', label: 'Symmetric? (yes/no)', answer: 'yes' }]
                    };
                } else {
                    // make skew-symmetric: aᵢⱼ = −aⱼᵢ, diagonal = 0
                    for (var r = 0; r < 3; r++) {
                        m[r][r] = 0;
                        for (var c = r + 1; c < 3; c++) {
                            m[c][r] = -m[r][c];
                        }
                    }
                    p = {
                        prompt: 'Is this matrix skew-symmetric (A = −Aᵀ)?<br>' + matToHtml(m),
                        hint: 'Skew-symmetric: aᵢⱼ = −aⱼᵢ and diagonal entries are 0',
                        fields: [{ id: 'skew', label: 'Skew-symmetric? (yes/no)', answer: 'yes' }]
                    };
                }
            }
            problems.push(p);
        }
        return problems;
    }

    // 6. RANK
    function genRank(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var m = randMatrix(2, 3, -5, 5);
                var rnk = matRREF(m).rank;
                p = {
                    prompt: 'Find rank(A):<br>' + matToHtml(m),
                    hint: 'Row-reduce and count non-zero rows',
                    fields: [{ id: 'rank', label: 'rank(A)', answer: String(rnk) }]
                };
            } else if (difficulty === 'medium') {
                var m = randMatrix(3, 3, -4, 4);
                var rnk = matRREF(m).rank;
                p = {
                    prompt: 'Find rank(A):<br>' + matToHtml(m),
                    hint: 'Row-reduce to echelon form',
                    fields: [{ id: 'rank', label: 'rank(A)', answer: String(rnk) }]
                };
            } else {
                var m = randMatrix(3, 4, -3, 3);
                // sometimes make rank-deficient
                if (Math.random() < 0.4) {
                    for (var j = 0; j < 4; j++) m[2][j] = m[0][j] + m[1][j];
                }
                var info = matRREF(m);
                var nullity = 4 - info.rank;
                p = {
                    prompt: 'Find rank and nullity of A (3×4):<br>' + matToHtml(m),
                    hint: 'Rank-Nullity theorem: rank + nullity = #columns',
                    fields: [
                        { id: 'rank', label: 'rank(A)', answer: String(info.rank) },
                        { id: 'nullity', label: 'nullity(A)', answer: String(nullity) }
                    ]
                };
            }
            problems.push(p);
        }
        return problems;
    }

    // 7. EIGENVALUE
    function genEigenvalue(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                // diagonal matrix — eigenvalues are diagonal entries
                var d1 = randInt(-5, 5), d2 = randInt(-5, 5);
                var m = [[d1, 0], [0, d2]];
                var evs = [Math.min(d1, d2), Math.max(d1, d2)];
                p = {
                    prompt: 'Find the eigenvalues of A:<br>' + matToHtml(m),
                    hint: 'For a diagonal matrix, eigenvalues are the diagonal entries',
                    fields: [
                        { id: 'l1', label: 'λ₁ (smaller)', answer: String(evs[0]) },
                        { id: 'l2', label: 'λ₂ (larger)', answer: String(evs[1]) }
                    ]
                };
            } else if (difficulty === 'medium') {
                // 2x2 with integer eigenvalues: build from known eigenvalues
                var l1 = randInt(-4, 4), l2 = randInt(-4, 4);
                // A = [[a, b],[c, d]] with trace=l1+l2, det=l1*l2
                // Simple: upper triangular
                var b = randInt(-3, 3);
                var m = [[l1, b], [0, l2]];
                // shuffle via similarity? Keep simple for practice
                var evs = [Math.min(l1, l2), Math.max(l1, l2)];
                p = {
                    prompt: 'Find the eigenvalues of A:<br>' + matToHtml(m),
                    hint: 'Solve det(A − λI) = 0, i.e. λ² − tr(A)λ + det(A) = 0',
                    fields: [
                        { id: 'l1', label: 'λ₁ (smaller)', answer: String(evs[0]) },
                        { id: 'l2', label: 'λ₂ (larger)', answer: String(evs[1]) }
                    ]
                };
            } else {
                // trace/det conceptual
                var l1 = randInt(-5, 5), l2 = randInt(-5, 5);
                var tr = l1 + l2, dt = l1 * l2;
                var b = randInt(1, 3);
                var m = [[l1, b], [0, l2]];
                p = {
                    prompt: 'Given A with tr(A) = ' + tr + ' and det(A) = ' + dt + ':<br>' + matToHtml(m) + '<br>Find eigenvalues using the relation λ² − tr(A)λ + det(A) = 0',
                    hint: 'Eigenvalues satisfy λ² − (' + tr + ')λ + (' + dt + ') = 0',
                    fields: [
                        { id: 'trace', label: 'tr(A) = λ₁ + λ₂', answer: String(tr) },
                        { id: 'det', label: 'det(A) = λ₁ · λ₂', answer: String(dt) },
                        { id: 'l1', label: 'λ₁ (smaller)', answer: String(Math.min(l1, l2)) },
                        { id: 'l2', label: 'λ₂ (larger)', answer: String(Math.max(l1, l2)) }
                    ]
                };
            }
            problems.push(p);
        }
        return problems;
    }

    // 8. POWER
    function genPower(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var m = randMatrix(2, 2, -3, 3);
                var ans = matMul(m, m);
                p = {
                    prompt: 'Compute A²:<br>' + matToHtml(m),
                    hint: 'A² = A × A',
                    fields: [{ id: 'result', label: 'A² (row; row)', answer: matToStr(ans), placeholder: 'e.g. 1 2; 3 4' }]
                };
            } else if (difficulty === 'medium') {
                var m = randMatrix(2, 2, -2, 2);
                var ans = matMul(matMul(m, m), m);
                p = {
                    prompt: 'Compute A³:<br>' + matToHtml(m),
                    hint: 'A³ = A × A × A (compute A² first, then multiply by A)',
                    fields: [{ id: 'result', label: 'A³ (row; row)', answer: matToStr(ans), placeholder: 'e.g. 1 2; 3 4' }]
                };
            } else {
                var variant = pick(['idempotent', 'nilpotent']);
                if (variant === 'idempotent') {
                    // idempotent: A² = A. Example: projection matrix
                    var m = [[1, 0], [0, 0]];
                    var a2 = matMul(m, m);
                    var isIdem = matToStr(m) === matToStr(a2) ? 'yes' : 'no';
                    p = {
                        prompt: 'Is A idempotent (A² = A)?<br>' + matToHtml(m),
                        hint: 'Compute A² and check if it equals A',
                        fields: [
                            { id: 'a2', label: 'A² (row; row)', answer: matToStr(a2), placeholder: 'e.g. 1 0; 0 0' },
                            { id: 'idempotent', label: 'Idempotent? (yes/no)', answer: isIdem }
                        ]
                    };
                } else {
                    // nilpotent: A² = 0
                    var choices = [
                        [[0, 1], [0, 0]],
                        [[0, 0], [1, 0]],
                        [[0, randInt(1, 3)], [0, 0]]
                    ];
                    var m = pick(choices);
                    var a2 = matMul(m, m);
                    p = {
                        prompt: 'Is A nilpotent (Aⁿ = 0 for some n)?<br>' + matToHtml(m),
                        hint: 'Compute A². If A² = 0, then A is nilpotent of index 2',
                        fields: [
                            { id: 'a2', label: 'A² (row; row)', answer: matToStr(a2), placeholder: 'e.g. 0 0; 0 0' },
                            { id: 'nilpotent', label: 'Nilpotent? (yes/no)', answer: 'yes' }
                        ]
                    };
                }
            }
            problems.push(p);
        }
        return problems;
    }

    // 9. CLASSIFIER
    function genClassifier(difficulty, count) {
        var problems = [];
        for (var i = 0; i < count; i++) {
            var p;
            if (difficulty === 'easy') {
                var variant = pick(['diagonal', 'identity', 'zero']);
                var n = pick([2, 3]);
                var m;
                if (variant === 'identity') {
                    m = [];
                    for (var r = 0; r < n; r++) {
                        var row = [];
                        for (var c = 0; c < n; c++) row.push(r === c ? 1 : 0);
                        m.push(row);
                    }
                } else if (variant === 'zero') {
                    m = [];
                    for (var r = 0; r < n; r++) { var row = []; for (var c = 0; c < n; c++) row.push(0); m.push(row); }
                } else {
                    m = [];
                    for (var r = 0; r < n; r++) {
                        var row = [];
                        for (var c = 0; c < n; c++) row.push(r === c ? randInt(1, 9) : 0);
                        m.push(row);
                    }
                }
                p = {
                    prompt: 'Classify this matrix (diagonal, identity, zero, scalar, or other):<br>' + matToHtml(m),
                    hint: 'Check if all off-diagonal entries are zero',
                    fields: [{ id: 'type', label: 'Type', answer: variant }]
                };
            } else if (difficulty === 'medium') {
                var variant = pick(['symmetric', 'upper_triangular', 'lower_triangular']);
                var m = randMatrix(3, 3, -5, 5);
                if (variant === 'symmetric') {
                    for (var r = 0; r < 3; r++)
                        for (var c = r + 1; c < 3; c++) m[c][r] = m[r][c];
                } else if (variant === 'upper_triangular') {
                    for (var r = 1; r < 3; r++)
                        for (var c = 0; c < r; c++) m[r][c] = 0;
                } else {
                    for (var r = 0; r < 3; r++)
                        for (var c = r + 1; c < 3; c++) m[r][c] = 0;
                }
                var label = variant.replace('_', ' ');
                p = {
                    prompt: 'Classify: symmetric, upper triangular, or lower triangular?<br>' + matToHtml(m),
                    hint: 'Symmetric: aᵢⱼ = aⱼᵢ. Upper tri: zeros below diagonal. Lower tri: zeros above diagonal.',
                    fields: [{ id: 'type', label: 'Type', answer: label }]
                };
            } else {
                var variant = pick(['orthogonal', 'positive_definite']);
                if (variant === 'orthogonal') {
                    // rotation matrix
                    var angles = [0, 90, 180, 270];
                    var deg = pick(angles);
                    var rad = deg * Math.PI / 180;
                    var c = Math.round(Math.cos(rad)), s = Math.round(Math.sin(rad));
                    var m = [[c, -s], [s, c]];
                    var AAt = matMul(m, matTranspose(m));
                    var isOrtho = (AAt[0][0] === 1 && AAt[1][1] === 1 && AAt[0][1] === 0 && AAt[1][0] === 0) ? 'yes' : 'no';
                    p = {
                        prompt: 'Is this matrix orthogonal (AAᵀ = I)?<br>' + matToHtml(m),
                        hint: 'Compute AAᵀ and check if it equals the identity matrix',
                        fields: [{ id: 'orthogonal', label: 'Orthogonal? (yes/no)', answer: isOrtho }]
                    };
                } else {
                    // positive definite: symmetric with positive eigenvalues
                    var a = randInt(2, 5), b = randInt(0, 1);
                    var m = [[a, b], [b, a]]; // always PD when a > |b|
                    p = {
                        prompt: 'Is this symmetric matrix positive definite (all eigenvalues > 0)?<br>' + matToHtml(m),
                        hint: 'Check: all leading principal minors are positive',
                        fields: [
                            { id: 'pd', label: 'Positive definite? (yes/no)', answer: 'yes' },
                            { id: 'reason', label: 'Leading minors: a₁₁ and det(A)', answer: a + ', ' + (a * a - b * b) }
                        ]
                    };
                }
            }
            problems.push(p);
        }
        return problems;
    }

    // ── Public API ───────────────────────────────────────────────────────

    window.MatrixPractice = {
        addition:       genAddition,
        multiplication: genMultiplication,
        determinant:    genDeterminant,
        inverse:        genInverse,
        transpose:      genTranspose,
        rank:           genRank,
        eigenvalue:     genEigenvalue,
        power:          genPower,
        classifier:     genClassifier
    };

})();
