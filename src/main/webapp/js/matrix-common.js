/**
 * matrix-common.js – shared utilities for all matrix calculator pages.
 * Attach everything to window.MatrixUtils so each page can call e.g.
 *   MatrixUtils.parseMatrix(text, 3, 3)
 */
(function () {
  'use strict';

  var EPS = 1e-10;

  /* ── MathJax configuration ── */
  function initMathJax() {
    window.MathJax = {
      loader: { load: ['[tex]/color'] },
      tex: {
        packages: { '[+]': ['color'] },
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']]
      },
      startup: {
        ready: function () {
          MathJax.startup.defaultReady();
          console.log('MathJax loaded and ready');
        }
      }
    };
  }

  /* Re-render MathJax for given elements */
  function rerender(el) {
    if (window.MathJax && window.MathJax.typesetPromise) {
      var els = Array.isArray(el) ? el : [el];
      MathJax.typesetPromise(els).catch(function (err) { console.error(err); });
    }
  }

  /* ── Matrix parsing ── */
  function parseNumericToken(token) {
    var value = (token || '').trim();
    var numberPattern = /^[+-]?(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?$/i;

    if (value.indexOf('/') !== -1) {
      var parts = value.split('/');
      if (parts.length !== 2 || !numberPattern.test(parts[0]) || !numberPattern.test(parts[1])) {
        throw new Error('Invalid fraction: ' + token);
      }
      var numerator = Number(parts[0]);
      var denominator = Number(parts[1]);
      if (!isFinite(numerator) || !isFinite(denominator) || Math.abs(denominator) < EPS) {
        throw new Error('Invalid fraction: ' + token);
      }
      return numerator / denominator;
    }

    if (!numberPattern.test(value)) {
      throw new Error('Invalid number: ' + token);
    }

    var num = Number(value);
    if (!isFinite(num)) {
      throw new Error('Invalid number: ' + token);
    }
    return num;
  }

  function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  function randomNonZeroInt(min, max) {
    var value = 0;
    while (value === 0) {
      value = randomInt(min, max);
    }
    return value;
  }

  function generateRandomNumericToken(options) {
    options = options || {};
    var minVal = options.minVal == null ? -10 : options.minVal;
    var maxVal = options.maxVal == null ? 10 : options.maxVal;
    var minDen = options.minDenominator == null ? 2 : options.minDenominator;
    var maxDen = options.maxDenominator == null ? 12 : options.maxDenominator;
    var fractionProbability = options.fractionProbability == null ? 0.35 : options.fractionProbability;
    var forceFraction = !!options.forceFraction;

    var useFraction = forceFraction || Math.random() < fractionProbability;
    if (!useFraction) {
      return String(randomInt(minVal, maxVal));
    }

    var denominator = randomNonZeroInt(minDen, maxDen);
    var numerator = randomInt(minVal * denominator, maxVal * denominator);
    if (numerator === 0) {
      numerator = randomNonZeroInt(minVal * denominator, maxVal * denominator);
    }
    return String(numerator) + '/' + String(denominator);
  }

  function generateRandomMatrixText(rows, cols, options) {
    options = options || {};
    var guaranteeMixed = options.guaranteeMixed == null ? true : !!options.guaranteeMixed;
    var total = rows * cols;
    var forceFractionIndex = -1;
    var forcePlainIndex = -1;

    if (guaranteeMixed && total >= 2) {
      forceFractionIndex = randomInt(0, total - 1);
      forcePlainIndex = randomInt(0, total - 1);
      while (forcePlainIndex === forceFractionIndex) {
        forcePlainIndex = randomInt(0, total - 1);
      }
    }

    var lines = [];
    for (var i = 0; i < rows; i++) {
      var row = [];
      for (var j = 0; j < cols; j++) {
        var index = i * cols + j;
        if (index === forceFractionIndex) {
          row.push(generateRandomNumericToken(Object.assign({}, options, { forceFraction: true })));
        } else if (index === forcePlainIndex) {
          row.push(String(randomInt(options.minVal == null ? -10 : options.minVal, options.maxVal == null ? 10 : options.maxVal)));
        } else {
          row.push(generateRandomNumericToken(options));
        }
      }
      lines.push(row.join(' '));
    }
    return lines.join('\n');
  }

  function parseMatrix(text, rows, cols) {
    var lines = text.trim().split('\n').filter(function (r) { return r.trim(); });
    if (lines.length !== rows) {
      throw new Error('Expected ' + rows + ' rows, got ' + lines.length);
    }
    var matrix = [];
    for (var i = 0; i < rows; i++) {
      var entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);
      if (entries.length !== cols) {
        throw new Error('Row ' + (i + 1) + ': expected ' + cols + ' entries, got ' + entries.length);
      }
      var row = [];
      for (var j = 0; j < cols; j++) {
        var num = parseNumericToken(entries[j]);
        row.push(num);
      }
      matrix.push(row);
    }
    return matrix;
  }

  /* ── Clone ── */
  function cloneMatrix(mat) {
    return mat.map(function (row) { return row.slice(); });
  }

  /* ── Smart formatting ── */
  function smartFormat(num) {
    if (Math.abs(num) < EPS) return '0';
    if (Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(3)).toString();
  }

  function formatExactNumber(value, options) {
    options = options || {};
    var maxDenominator = options.maxDenominator == null ? 200 : options.maxDenominator;
    var tolerance = options.tolerance == null ? 1e-9 : options.tolerance;
    var num = Number(value);

    if (!isFinite(num)) return String(value);
    if (Math.abs(num) < EPS) return '0';
    if (Math.abs(num - Math.round(num)) < tolerance) return String(Math.round(num));

    var sign = num < 0 ? -1 : 1;
    var x = Math.abs(num);
    var h1 = 1, h2 = 0, k1 = 0, k2 = 1;
    var b = x;

    while (true) {
      var a = Math.floor(b);
      var h = a * h1 + h2;
      var k = a * k1 + k2;

      if (k > maxDenominator) break;

      var approx = h / k;
      if (Math.abs(approx - x) < tolerance) {
        var numerator = sign * h;
        return numerator + '/' + k;
      }

      h2 = h1; h1 = h;
      k2 = k1; k1 = k;

      var frac = b - a;
      if (Math.abs(frac) < tolerance) break;
      b = 1 / frac;
    }

    return smartFormat(num);
  }

  /* ── Basic LaTeX bmatrix ── */
  function formatMatrix(mat) {
    var rows = mat.map(function (row) {
      return row.map(function (val) {
        var n = Math.abs(val) < EPS ? 0 : val;
        return smartFormat(n);
      }).join(' & ');
    });
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  /* ── Identity matrix ── */
  function createIdentity(n) {
    var I = [];
    for (var i = 0; i < n; i++) {
      I[i] = [];
      for (var j = 0; j < n; j++) {
        I[i][j] = i === j ? 1 : 0;
      }
    }
    return I;
  }

  /* ── Matrix multiplication (general m×p * p×q) ── */
  function multiply(A, B) {
    var m = A.length;
    var p = B.length;
    var q = B[0].length;
    var result = [];
    for (var i = 0; i < m; i++) {
      result[i] = [];
      for (var j = 0; j < q; j++) {
        var sum = 0;
        for (var k = 0; k < p; k++) {
          sum += A[i][k] * B[k][j];
        }
        result[i][j] = sum;
      }
    }
    return result;
  }

  /* ── Random matrix for exercises ── */
  function generateRandomMatrix(rows, cols, minVal, maxVal) {
    minVal = minVal == null ? -5 : minVal;
    maxVal = maxVal == null ? 5 : maxVal;
    var mat = [];
    for (var i = 0; i < rows; i++) {
      mat[i] = [];
      for (var j = 0; j < cols; j++) {
        mat[i][j] = Math.floor(Math.random() * (maxVal - minVal + 1)) + minVal;
      }
    }
    return mat;
  }

  function generateRandomFractionMatrix(rows, cols, minVal, maxVal, fractionProbability) {
    var text = generateRandomMatrixText(rows, cols, {
      minVal: minVal == null ? -5 : minVal,
      maxVal: maxVal == null ? 5 : maxVal,
      fractionProbability: fractionProbability == null ? 0.45 : fractionProbability,
      guaranteeMixed: true
    });
    return parseMatrix(text, rows, cols);
  }

  /* ── Matrix to HTML table for print ── */
  function matrixToPrintTable(mat, label, options) {
    options = options || {};
    var exact = !!options.exact;
    var html = '';
    if (label) html += '<div style="font-weight:600;margin-bottom:0.25rem;font-size:0.9rem">' + label + '</div>';
    html += '<table class="print-matrix-grid" style="border-collapse:collapse;margin-bottom:0.75rem"><tbody>';
    for (var i = 0; i < mat.length; i++) {
      html += '<tr>';
      for (var j = 0; j < mat[i].length; j++) {
        var displayValue = exact ? formatExactNumber(mat[i][j]) : mat[i][j];
        html += '<td style="border:1px solid #333;padding:0.35rem 0.6rem;text-align:center;font-family:monospace;min-width:2em">' + displayValue + '</td>';
      }
      html += '</tr>';
    }
    html += '</tbody></table>';
    return html;
  }

  /* ── Transpose ── */
  function transpose(mat) {
    var m = mat.length;
    var n = mat[0].length;
    var T = [];
    for (var j = 0; j < n; j++) {
      T[j] = [];
      for (var i = 0; i < m; i++) {
        T[j][i] = mat[i][j];
      }
    }
    return T;
  }

  /* ── Matrix addition ── */
  function addMatrix(A, B) {
    return A.map(function(row, i) { return row.map(function(v, j) { return v + B[i][j]; }); });
  }

  /* ── Matrix subtraction ── */
  function subtractMatrix(A, B) {
    return A.map(function(row, i) { return row.map(function(v, j) { return v - B[i][j]; }); });
  }

  /* ── Scalar multiply ── */
  function scalarMultiply(c, M) {
    return M.map(function(row) { return row.map(function(v) { return c * v; }); });
  }

  /* ── Determinant (up to 4×4, cofactor expansion) ── */
  function determinant(M) {
    var n = M.length;
    if (n === 1) return M[0][0];
    if (n === 2) return M[0][0] * M[1][1] - M[0][1] * M[1][0];
    var det = 0;
    for (var j = 0; j < n; j++) {
      var sub = [];
      for (var i = 1; i < n; i++) {
        var row = [];
        for (var k = 0; k < n; k++) { if (k !== j) row.push(M[i][k]); }
        sub.push(row);
      }
      det += (j % 2 === 0 ? 1 : -1) * M[0][j] * determinant(sub);
    }
    return det;
  }

  /* ── Matrix power (square, integer n >= 0) ── */
  function matPow(M, n) {
    var sz = M.length;
    var result = createIdentity(sz);
    var base = cloneMatrix(M);
    while (n > 0) {
      if (n % 2 === 1) result = multiply(result, base);
      base = multiply(base, base);
      n = Math.floor(n / 2);
    }
    return result;
  }

  /* ── Rank via Gaussian elimination ── */
  function rank(M) {
    var m = M.length, n = M[0].length;
    var A = M.map(function(r) { return r.slice(); });
    var r = 0;
    for (var col = 0; col < n && r < m; col++) {
      var pivot = -1;
      for (var i = r; i < m; i++) { if (Math.abs(A[i][col]) > EPS) { pivot = i; break; } }
      if (pivot < 0) continue;
      var tmp = A[r]; A[r] = A[pivot]; A[pivot] = tmp;
      var scale = A[r][col];
      for (var j = col; j < n; j++) A[r][j] /= scale;
      for (var i2 = 0; i2 < m; i2++) {
        if (i2 === r) continue;
        var f = A[i2][col];
        for (var j2 = col; j2 < n; j2++) A[i2][j2] -= f * A[r][j2];
      }
      r++;
    }
    return r;
  }

  /* ── 2x2 inverse ── */
  function inverse2x2(M) {
    var d = M[0][0] * M[1][1] - M[0][1] * M[1][0];
    if (Math.abs(d) < EPS) return null;
    return [[M[1][1] / d, -M[0][1] / d], [-M[1][0] / d, M[0][0] / d]];
  }

  /* ── Eigenvalues of 2x2 ── */
  function eigenvalues2x2(M) {
    var tr = M[0][0] + M[1][1];
    var det = M[0][0] * M[1][1] - M[0][1] * M[1][0];
    var disc = tr * tr - 4 * det;
    if (disc >= 0) {
      return [smartFormat((tr + Math.sqrt(disc)) / 2), smartFormat((tr - Math.sqrt(disc)) / 2)];
    }
    var re = tr / 2, im = Math.sqrt(-disc) / 2;
    return [smartFormat(re) + ' + ' + smartFormat(im) + 'i', smartFormat(re) + ' - ' + smartFormat(im) + 'i'];
  }

  /* ── Classify matrix types (simple) ── */
  function classifyMatrix(M) {
    var m = M.length, n = M[0].length, types = [];
    if (m === n) {
      types.push('Square (' + m + '×' + n + ')');
      var isSym = true, isSkew = true, isDiag = true, isUpper = true, isLower = true;
      for (var i = 0; i < m; i++) for (var j = 0; j < n; j++) {
        if (i !== j && Math.abs(M[i][j]) > EPS) isDiag = false;
        if (i > j && Math.abs(M[i][j]) > EPS) isUpper = false;
        if (i < j && Math.abs(M[i][j]) > EPS) isLower = false;
        if (Math.abs(M[i][j] - M[j][i]) > EPS) isSym = false;
        if (Math.abs(M[i][j] + M[j][i]) > EPS) isSkew = false;
      }
      if (isDiag) types.push('Diagonal');
      if (isSym) types.push('Symmetric');
      if (isSkew) types.push('Skew-Symmetric');
      if (isUpper) types.push('Upper Triangular');
      if (isLower) types.push('Lower Triangular');
      var d = determinant(M);
      types.push(Math.abs(d) < EPS ? 'Singular' : 'Non-Singular');
    } else {
      types.push('Rectangular (' + m + '×' + n + ')');
    }
    types.push('Rank ' + rank(M));
    return types;
  }

  /* ── Share URL ── */
  function shareURL(btn, getParamsFn) {
    if (!btn) return;
    btn.addEventListener('click', function () {
      try {
        var params = getParamsFn();
        if (!params) return;

        var baseUrl = window.location.origin + window.location.pathname;
        var sp = new URLSearchParams();
        var keys = Object.keys(params);
        for (var i = 0; i < keys.length; i++) {
          sp.set(keys[i], params[keys[i]]);
        }
        var shareUrl = baseUrl + '?' + sp.toString();

        if (window.ToolUtils && window.ToolUtils.copyToClipboard) {
          ToolUtils.copyToClipboard(shareUrl, {
            toastMessage: 'Share URL copied to clipboard!',
            showSupportPopup: true,
            toolName: 'Matrix Calculator'
          });
        } else {
          if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(shareUrl).then(function () {
              _flashBtn(btn, 'btn-outline-primary', 'btn-success', '<i class="fas fa-check"></i> Copied!');
            }).catch(function (err) { alert('Failed to copy URL: ' + err); });
          } else {
            var ta = document.createElement('textarea');
            ta.value = shareUrl;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
            alert('URL copied to clipboard!');
          }
        }
      } catch (err) {
        console.error('Error creating share URL:', err);
        alert('Failed to create share URL');
      }
    });
  }

  /* ── Download Image ── */
  function downloadImage(btn, prefix, noResultMsg) {
    if (!btn) return;
    btn.addEventListener('click', async function () {
      var resultCard = document.querySelector('#resultArea');
      if (resultCard) resultCard = resultCard.closest('.card') || resultCard.closest('.tool-card');
      if (!resultCard || !resultCard.querySelector('.result-card')) {
        if (window.ToolUtils && window.ToolUtils.showToast) {
          ToolUtils.showToast(noResultMsg || 'No result to download. Please calculate first.', 2500, 'warning');
        } else {
          alert(noResultMsg || 'No result to download. Please calculate first.');
        }
        return;
      }

      var originalHTML = btn.innerHTML;
      btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
      btn.disabled = true;

      try {
        if (window.MathJax && window.MathJax.typesetPromise) {
          await MathJax.typesetPromise([resultCard]);
          await new Promise(function (r) { setTimeout(r, 800); });
        }

        var ts = new Date().toISOString().slice(0, 10);
        var filename = (prefix || 'matrix') + '-' + ts + '.png';
        var filter = function (node) {
          if (node.tagName === 'SCRIPT') return false;
          if (node.classList && node.classList.contains('MathJax_Preview')) return false;
          if (node.nodeType === Node.TEXT_NODE) {
            var t = node.textContent || '';
            if (t.indexOf('$$') !== -1 || t.indexOf('\\begin{bmatrix}') !== -1) return false;
          }
          return true;
        };

        var ok = false;
        if (window.ToolUtils && window.ToolUtils.downloadDomAsImage) {
          ok = await ToolUtils.downloadDomAsImage(resultCard, filename, {
            filter: filter,
            backgroundColor: '#ffffff',
            showToast: true,
            toastMessage: 'Downloaded ' + filename,
            showSupportPopup: true,
            toolName: 'Matrix Calculator'
          });
        } else if (typeof domtoimage !== 'undefined' && domtoimage.toPng) {
          var dataUrl = await domtoimage.toPng(resultCard, {
            quality: 1,
            bgcolor: '#ffffff',
            width: resultCard.offsetWidth,
            height: resultCard.offsetHeight,
            style: { margin: '0', padding: '20px' },
            filter: filter
          });
          var link = document.createElement('a');
          link.download = filename;
          link.href = dataUrl;
          link.click();
          ok = true;
        }
        if (ok) {
          _flashBtn(btn, 'btn-outline-success', 'btn-success', '<i class="fas fa-check"></i> Downloaded!');
        } else {
          btn.innerHTML = originalHTML;
          btn.disabled = false;
        }
      } catch (err) {
        console.error('Error generating image:', err);
        if (window.ToolUtils && window.ToolUtils.showToast) {
          ToolUtils.showToast('Failed to generate image: ' + (err.message || ''), 3000, 'error');
        } else {
          alert('Failed to generate image: ' + err.message);
        }
        btn.innerHTML = originalHTML;
        btn.disabled = false;
      }
    });
  }

  /* ── Load from URL ── */
  function loadFromURL(callback) {
    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.toString().length > 0) {
      try {
        var params = {};
        urlParams.forEach(function (v, k) { params[k] = v; });
        if (params.matrix) {
          params.matrix = decodeURIComponent(atob(params.matrix));
        }
        if (params.A) {
          params.A = decodeURIComponent(atob(params.A));
        }
        if (params.B) {
          params.B = decodeURIComponent(atob(params.B));
        }
        return callback(params);
      } catch (err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  /* ── Exercise generator for print worksheet ── */
  /* Generates min 20 random questions from Easy / Medium / Hard levels */
  function pickRandom(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
  }

  /* Shuffle array in-place (Fisher–Yates) */
  function shuffle(arr) {
    for (var i = arr.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
    }
    return arr;
  }

  /* Generate a specific invertible matrix of given size */
  function generateInvertibleMatrix(n, minVal, maxVal) {
    var m;
    for (var tries = 0; tries < 50; tries++) {
      m = generateRandomMatrix(n, n, minVal, maxVal);
      if (Math.abs(determinant(m)) > EPS) return m;
    }
    /* fallback: identity + random diagonal */
    m = createIdentity(n);
    for (var i = 0; i < n; i++) m[i][i] = 1 + Math.floor(Math.random() * 4);
    return m;
  }

  /* Generate a matrix with a specific rank target */
  function generateRankDeficientMatrix(rows, cols, targetRank) {
    /* Build by multiplying an (rows×targetRank) × (targetRank×cols) */
    var L = generateRandomMatrix(rows, targetRank, -3, 3);
    var R = generateRandomMatrix(targetRank, cols, -3, 3);
    return multiply(L, R).map(function(row) {
      return row.map(function(v) { return Math.round(v); });
    });
  }

  /* Difficulty badge HTML */
  var diffBadge = {
    Easy:   '<span style="display:inline-block;font-size:0.7rem;font-weight:600;padding:0.1rem 0.4rem;border-radius:4px;background:#d1fae5;color:#065f46;margin-left:0.4rem;vertical-align:middle">Easy</span>',
    Medium: '<span style="display:inline-block;font-size:0.7rem;font-weight:600;padding:0.1rem 0.4rem;border-radius:4px;background:#fef3c7;color:#92400e;margin-left:0.4rem;vertical-align:middle">Medium</span>',
    Hard:   '<span style="display:inline-block;font-size:0.7rem;font-weight:600;padding:0.1rem 0.4rem;border-radius:4px;background:#fee2e2;color:#991b1b;margin-left:0.4rem;vertical-align:middle">Hard</span>'
  };

  /* ── Question generators per exercise type ── */
  /* Each returns { question: htmlString, answer: htmlString, difficulty: 'Easy'|'Medium'|'Hard' } */

  var questionBank = {
    addition: [
      /* Easy: 2×2 A+B */
      function() {
        var A = generateRandomMatrix(2,2,-5,5), B = generateRandomMatrix(2,2,-5,5);
        var ans = addMatrix(A, B);
        return { difficulty: 'Easy',
          question: 'Find A + B' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(ans, 'A + B =') };
      },
      /* Easy: 2×2 A-B */
      function() {
        var A = generateRandomMatrix(2,2,-5,5), B = generateRandomMatrix(2,2,-5,5);
        var ans = subtractMatrix(A, B);
        return { difficulty: 'Easy',
          question: 'Find A − B' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(ans, 'A − B =') };
      },
      /* Easy: scalar multiply cA, 2×2 */
      function() {
        var c = 2 + Math.floor(Math.random()*4);
        var A = generateRandomMatrix(2,2,-4,4);
        return { difficulty: 'Easy',
          question: 'Find ' + c + 'A' + matrixToPrintTable(A, 'A ='),
          answer: matrixToPrintTable(scalarMultiply(c, A), c + 'A =') };
      },
      /* Medium: 3×3 A+B */
      function() {
        var A = generateRandomMatrix(3,3,-5,5), B = generateRandomMatrix(3,3,-5,5);
        return { difficulty: 'Medium',
          question: 'Find A + B (3×3)' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(addMatrix(A, B), 'A + B =') };
      },
      /* Medium: 2×3 A-B */
      function() {
        var A = generateRandomMatrix(2,3,-5,5), B = generateRandomMatrix(2,3,-5,5);
        return { difficulty: 'Medium',
          question: 'Find A − B (2×3)' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(subtractMatrix(A, B), 'A − B =') };
      },
      /* Medium: aA + bB, 2×2 */
      function() {
        var a = 2 + Math.floor(Math.random()*3), b = 1 + Math.floor(Math.random()*3);
        var A = generateRandomMatrix(2,2,-3,3), B = generateRandomMatrix(2,2,-3,3);
        return { difficulty: 'Medium',
          question: 'Find ' + a + 'A + ' + b + 'B' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(addMatrix(scalarMultiply(a, A), scalarMultiply(b, B)), a + 'A + ' + b + 'B =') };
      },
      /* Hard: 3×3 aA - bB */
      function() {
        var a = 2 + Math.floor(Math.random()*2), b = 1 + Math.floor(Math.random()*3);
        var A = generateRandomMatrix(3,3,-4,4), B = generateRandomMatrix(3,3,-4,4);
        return { difficulty: 'Hard',
          question: 'Find ' + a + 'A − ' + b + 'B (3×3)' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(subtractMatrix(scalarMultiply(a, A), scalarMultiply(b, B)), a + 'A − ' + b + 'B =') };
      },
      /* Hard: 4×4 A+B */
      function() {
        var A = generateRandomMatrix(4,4,-5,5), B = generateRandomMatrix(4,4,-5,5);
        return { difficulty: 'Hard',
          question: 'Find A + B (4×4)' + matrixToPrintTable(A, 'A =') + matrixToPrintTable(B, 'B ='),
          answer: matrixToPrintTable(addMatrix(A, B), 'A + B =') };
      }
    ],
    transpose: [
      function() { var M=generateRandomMatrix(2,2,-5,5); return { difficulty:'Easy', question:'Find A<sup>T</sup> (2×2)'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(transpose(M),'A<sup>T</sup> =') }; },
      function() { var M=generateRandomMatrix(2,3,-5,5); return { difficulty:'Easy', question:'Find A<sup>T</sup> (2×3)'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(transpose(M),'A<sup>T</sup> =') }; },
      function() { var M=generateRandomMatrix(3,2,-5,5); return { difficulty:'Easy', question:'Find A<sup>T</sup> (3×2)'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(transpose(M),'A<sup>T</sup> =') }; },
      function() { var M=generateRandomMatrix(3,3,-5,5); return { difficulty:'Medium', question:'Find A<sup>T</sup> (3×3). Is A symmetric?'+matrixToPrintTable(M,'A ='), answer: (function(){ var T=transpose(M); var sym=true; for(var i=0;i<3;i++) for(var j=0;j<3;j++) if(Math.abs(M[i][j]-T[i][j])>EPS) sym=false; return matrixToPrintTable(T,'A<sup>T</sup> =')+'<div style="font-size:0.85rem;margin-top:0.25rem">Symmetric: <strong>'+(sym?'Yes':'No')+'</strong></div>'; })() }; },
      function() { var M=generateRandomMatrix(3,4,-4,4); return { difficulty:'Medium', question:'Find A<sup>T</sup> (3×4). State dimensions of A<sup>T</sup>.'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(transpose(M),'A<sup>T</sup> = (4×3)') }; },
      function() { var M=generateRandomMatrix(2,4,-5,5); return { difficulty:'Medium', question:'Find A<sup>T</sup> (2×4)'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(transpose(M),'A<sup>T</sup> =') }; },
      function() { var M=generateRandomMatrix(4,3,-4,4); return { difficulty:'Hard', question:'Find A<sup>T</sup> (4×3) and verify (A<sup>T</sup>)<sup>T</sup> = A'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(transpose(M),'A<sup>T</sup> =')+'<div style="font-size:0.85rem;margin-top:0.25rem">(A<sup>T</sup>)<sup>T</sup> = A  ✓</div>' }; },
      function() { var M=generateRandomMatrix(4,4,-3,3); return { difficulty:'Hard', question:'Find A<sup>T</sup> (4×4). Is A symmetric or skew-symmetric?'+matrixToPrintTable(M,'A ='), answer: (function(){ var T=transpose(M); var sym=true,skew=true; for(var i=0;i<4;i++) for(var j=0;j<4;j++){if(Math.abs(M[i][j]-T[i][j])>EPS) sym=false; if(Math.abs(M[i][j]+T[i][j])>EPS) skew=false;} return matrixToPrintTable(T,'A<sup>T</sup> =')+'<div style="font-size:0.85rem;margin-top:0.25rem">Symmetric: <strong>'+(sym?'Yes':'No')+'</strong>, Skew-symmetric: <strong>'+(skew?'Yes':'No')+'</strong></div>'; })() }; }
    ],
    multiplication: [
      function() { var A=generateRandomMatrix(2,2,-3,3),B=generateRandomMatrix(2,2,-3,3); return { difficulty:'Easy', question:'Find A × B (2×2)'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B =') }; },
      function() { var A=generateRandomMatrix(2,2,-4,4),B=generateRandomMatrix(2,2,-4,4); return { difficulty:'Easy', question:'Find A × B'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B =') }; },
      function() { var A=generateRandomMatrix(2,3,-3,3),B=generateRandomMatrix(3,2,-3,3); return { difficulty:'Medium', question:'Find A × B. A is 2×3, B is 3×2.'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B = (2×2)') }; },
      function() { var A=generateRandomMatrix(3,2,-3,3),B=generateRandomMatrix(2,3,-3,3); return { difficulty:'Medium', question:'Find A × B. A is 3×2, B is 2×3.'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B = (3×3)') }; },
      function() { var A=generateRandomMatrix(2,3,-2,2),B=generateRandomMatrix(3,4,-2,2); return { difficulty:'Medium', question:'Find A × B. A is 2×3, B is 3×4.'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B = (2×4)') }; },
      function() { var A=generateRandomMatrix(3,3,-3,3),B=generateRandomMatrix(3,3,-3,3); return { difficulty:'Hard', question:'Find A × B (3×3)'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B =') }; },
      function() { var A=generateRandomMatrix(3,3,-2,2),B=generateRandomMatrix(3,3,-2,2); return { difficulty:'Hard', question:'Find A × B and B × A. Are they equal?'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B =')+'<div style="margin-top:0.5rem">'+matrixToPrintTable(multiply(B,A),'B × A =')+'</div><div style="font-size:0.85rem">Equal: <strong>'+(JSON.stringify(multiply(A,B))===JSON.stringify(multiply(B,A))?'Yes':'No')+'</strong></div>' }; },
      function() { var A=generateRandomMatrix(4,2,-2,2),B=generateRandomMatrix(2,4,-2,2); return { difficulty:'Hard', question:'Find A × B. A is 4×2, B is 2×4.'+matrixToPrintTable(A,'A =')+matrixToPrintTable(B,'B ='), answer:matrixToPrintTable(multiply(A,B),'A × B = (4×4)') }; }
    ],
    determinant: [
      function() {
        var M = generateRandomMatrix(2,2,-5,5);
        var d = determinant(M);
        return {
          difficulty:'Easy',
          question:'Find det(A) for this 2×2 matrix' + matrixToPrintTable(M, 'A ='),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong></span>'
        };
      },
      function() {
        var M = generateRandomFractionMatrix(2,2,-8,8,0.65);
        var d = determinant(M);
        return {
          difficulty:'Easy',
          question:'Find det(A) with fraction entries' + matrixToPrintTable(M, 'A =', { exact: true }),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong>' + (Math.abs(d)<EPS ? ' (singular)' : ' (non-singular)') + '</span>'
        };
      },
      function() {
        var M = generateRandomFractionMatrix(2,2,-5,5,0.55);
        var d = determinant(M);
        return {
          difficulty:'Easy',
          question:'Compute |A| and state if A is invertible' + matrixToPrintTable(M, 'A =', { exact: true }),
          answer:'<span>|A| = <strong>' + formatExactNumber(d) + '</strong> → ' + (Math.abs(d)<EPS?'Not invertible':'Invertible') + '</span>'
        };
      },
      function() {
        var M = generateRandomMatrix(3,3,-3,3);
        var d = determinant(M);
        return {
          difficulty:'Medium',
          question:'Find det(A) for this 3×3 matrix using cofactor expansion' + matrixToPrintTable(M, 'A ='),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong></span>'
        };
      },
      function() {
        var M = generateRandomFractionMatrix(3,3,-4,4,0.45);
        var d = determinant(M);
        return {
          difficulty:'Medium',
          question:'Find det(A) (3×3) with fractions' + matrixToPrintTable(M, 'A =', { exact: true }),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong>' + (Math.abs(d)<EPS?' (singular)':' (non-singular)') + '</span>'
        };
      },
      function() {
        var M = generateRandomFractionMatrix(3,3,-3,3,0.4);
        var d = determinant(M);
        var c = 2 + Math.floor(Math.random()*3);
        return {
          difficulty:'Medium',
          question:'If det(A) = ?, what is det(' + c + 'A)? (A is 3×3)' + matrixToPrintTable(M, 'A =', { exact: true }),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong>, det(' + c + 'A) = ' + c + '³ × det(A) = <strong>' + formatExactNumber(c*c*c*d) + '</strong></span>'
        };
      },
      function() {
        var M = generateRandomFractionMatrix(4,4,-2,2,0.4);
        var d = determinant(M);
        return {
          difficulty:'Hard',
          question:'Find det(A) for this 4×4 matrix' + matrixToPrintTable(M, 'A =', { exact: true }),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong></span>'
        };
      },
      function() {
        var M = generateRandomFractionMatrix(4,4,-3,3,0.4);
        var d = determinant(M);
        return {
          difficulty:'Hard',
          question:'Find det(A) (4×4). Is A singular?' + matrixToPrintTable(M, 'A =', { exact: true }),
          answer:'<span>det(A) = <strong>' + formatExactNumber(d) + '</strong> → ' + (Math.abs(d)<EPS?'Singular':'Non-singular') + '</span>'
        };
      }
    ],
    inverse: [
      function() { var M=generateInvertibleMatrix(2,-4,4); var inv=inverse2x2(M); var disp=inv.map(function(r){return r.map(function(v){return smartFormat(v);});}); return { difficulty:'Easy', question:'Find A⁻¹'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(disp,'A⁻¹ =') }; },
      function() { var M=generateInvertibleMatrix(2,-5,5); var inv=inverse2x2(M); var disp=inv.map(function(r){return r.map(function(v){return smartFormat(v);});}); return { difficulty:'Easy', question:'Find the inverse of A'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(disp,'A⁻¹ =') }; },
      function() { var M=generateInvertibleMatrix(2,-6,6); var inv=inverse2x2(M); var disp=inv.map(function(r){return r.map(function(v){return smartFormat(v);});}); return { difficulty:'Easy', question:'Compute A⁻¹ and verify det(A) ≠ 0'+matrixToPrintTable(M,'A ='), answer:'<span>det(A) = '+smartFormat(determinant(M))+'</span>'+matrixToPrintTable(disp,'A⁻¹ =') }; },
      function() { var M=generateRandomMatrix(2,2,0,0); M[0][0]=2;M[1][1]=3; return { difficulty:'Medium', question:'Find A⁻¹ (or explain why it doesn\'t exist)'+matrixToPrintTable(M,'A ='), answer:(function(){var d=determinant(M);if(Math.abs(d)<EPS) return '<span>det(A) = 0, A is singular — no inverse exists</span>'; var inv=inverse2x2(M); return matrixToPrintTable(inv.map(function(r){return r.map(function(v){return smartFormat(v);});}), 'A⁻¹ =');})() }; },
      function() { var M=generateInvertibleMatrix(2,-5,5); var inv=inverse2x2(M); var disp=inv.map(function(r){return r.map(function(v){return smartFormat(v);});}); return { difficulty:'Medium', question:'Find A⁻¹ using the formula A⁻¹ = (1/det)·adj(A)'+matrixToPrintTable(M,'A ='), answer:'<span>det(A) = '+smartFormat(determinant(M))+'</span>'+matrixToPrintTable(disp,'A⁻¹ =') }; },
      /* Singular matrix — no inverse */
      function() { var a=1+Math.floor(Math.random()*3),b=1+Math.floor(Math.random()*3); var M=[[a,b],[a*2,b*2]]; return { difficulty:'Medium', question:'Find A⁻¹ (or explain why it doesn\'t exist)'+matrixToPrintTable(M,'A ='), answer:'<span>det(A) = '+smartFormat(determinant(M))+' = 0 → A is <strong>singular</strong>, no inverse exists (Row 2 = 2 × Row 1)</span>' }; },
      function() { var M=generateInvertibleMatrix(3,-2,2); var d=determinant(M); return { difficulty:'Hard', question:'Find det(A) and state if A⁻¹ exists (3×3)'+matrixToPrintTable(M,'A ='), answer:'<span>det(A) = <strong>'+smartFormat(d)+'</strong> '+(Math.abs(d)<EPS?'→ no inverse':'→ A⁻¹ exists')+'</span>' }; },
      function() { var M=generateInvertibleMatrix(3,-3,3); return { difficulty:'Hard', question:'Is this 3×3 matrix invertible? Find det(A).'+matrixToPrintTable(M,'A ='), answer:'<span>det(A) = <strong>'+smartFormat(determinant(M))+'</strong> → Invertible</span>' }; }
    ],
    power: [
      function() { var M=generateRandomMatrix(2,2,-2,2); var R=matPow(M,2); return { difficulty:'Easy', question:'Find A²'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A² =') }; },
      function() { var M=generateRandomMatrix(2,2,-2,2); var R=matPow(M,2); return { difficulty:'Easy', question:'Compute A × A'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A² =') }; },
      function() { var M=generateRandomMatrix(2,2,-2,2); var R=matPow(M,3); return { difficulty:'Medium', question:'Find A³'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A³ =') }; },
      function() { var M=generateRandomMatrix(2,2,-2,2); var R=matPow(M,4); return { difficulty:'Medium', question:'Find A⁴'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A⁴ =') }; },
      function() { var M=createIdentity(3); return { difficulty:'Medium', question:'Find A⁵ where A = I₃ (3×3 identity)'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(M,'A⁵ = I₃ =')+'<div style="font-size:0.85rem">Any power of the identity matrix is itself.</div>' }; },
      function() { var M=generateRandomMatrix(2,2,-3,3); var R2=matPow(M,2),R3=matPow(M,3); var isIdem=JSON.stringify(R2.map(function(r){return r.map(function(v){return Math.abs(v)<EPS?0:Math.round(v);});}))=== JSON.stringify(M.map(function(r){return r.map(function(v){return Math.abs(v)<EPS?0:Math.round(v);})})); return { difficulty:'Hard', question:'Find A² and A³. Is A idempotent (A²=A)?'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R2.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A² =')+'<div style="margin-top:0.25rem">'+matrixToPrintTable(R3.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A³ =')+'</div><div style="font-size:0.85rem">Idempotent: <strong>'+(isIdem?'Yes':'No')+'</strong></div>' }; },
      function() { var M=generateRandomMatrix(2,2,-1,1); var R=matPow(M,5); return { difficulty:'Hard', question:'Find A⁵'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A⁵ =') }; },
      function() { var M=generateRandomMatrix(3,3,-1,1); var R=matPow(M,2); return { difficulty:'Hard', question:'Find A² (3×3 matrix)'+matrixToPrintTable(M,'A ='), answer:matrixToPrintTable(R.map(function(r){return r.map(function(v){return smartFormat(v);});}),'A² =') }; }
    ],
    rank: [
      function() { var M=generateRandomMatrix(2,2,-5,5); return { difficulty:'Easy', question:'Find rank(A) (2×2)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong>, nullity = '+(2-rank(M))+'</span>' }; },
      function() { var M=generateRandomMatrix(2,3,-4,4); return { difficulty:'Easy', question:'Find rank(A) (2×3)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong>, nullity = '+(3-rank(M))+'</span>' }; },
      function() { var M=generateRandomMatrix(3,2,-4,4); return { difficulty:'Easy', question:'Find rank(A) (3×2)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong></span>' }; },
      function() { var M=generateRandomMatrix(3,3,-3,3); return { difficulty:'Medium', question:'Find rank(A) and nullity(A) (3×3)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong>, nullity = <strong>'+(3-rank(M))+'</strong></span>' }; },
      function() { var M=generateRankDeficientMatrix(3,3,1); return { difficulty:'Medium', question:'Find rank(A). Is A singular? (3×3)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong> (< 3, so A is <strong>singular</strong>)</span>' }; },
      function() { var M=generateRandomMatrix(3,4,-3,3); return { difficulty:'Medium', question:'Find rank(A) (3×4)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong>, nullity = '+(4-rank(M))+'</span>' }; },
      function() { var M=generateRankDeficientMatrix(4,4,2); return { difficulty:'Hard', question:'Find rank(A) and nullity(A) (4×4)'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong>, nullity = <strong>'+(4-rank(M))+'</strong></span>' }; },
      function() { var M=generateRandomMatrix(4,3,-3,3); return { difficulty:'Hard', question:'Find rank(A) (4×3). Can rank exceed 3?'+matrixToPrintTable(M,'A ='), answer:'<span>rank(A) = <strong>'+rank(M)+'</strong>. Max possible rank = min(4,3) = 3.</span>' }; }
    ],
    eigenvalue: [
      function() { var M=generateRandomMatrix(2,2,-3,3); var e=eigenvalues2x2(M); return { difficulty:'Easy', question:'Find the eigenvalues of A (2×2)'+matrixToPrintTable(M,'A ='), answer:'<span>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong></span>' }; },
      function() { var M=generateRandomMatrix(2,2,-4,4); var e=eigenvalues2x2(M); var tr=M[0][0]+M[1][1]; return { difficulty:'Easy', question:'Find eigenvalues (trace = '+smartFormat(tr)+')'+matrixToPrintTable(M,'A ='), answer:'<span>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong></span>' }; },
      function() { var d1=1+Math.floor(Math.random()*4), d2=1+Math.floor(Math.random()*4); var M=[[d1,0],[0,d2]]; return { difficulty:'Easy', question:'Find eigenvalues of this diagonal matrix'+matrixToPrintTable(M,'A ='), answer:'<span>λ₁ = <strong>'+d1+'</strong>, λ₂ = <strong>'+d2+'</strong> (diagonal entries)</span>' }; },
      function() { var M=generateRandomMatrix(2,2,-5,5); var e=eigenvalues2x2(M); var tr=M[0][0]+M[1][1],det2=M[0][0]*M[1][1]-M[0][1]*M[1][0]; return { difficulty:'Medium', question:'Find eigenvalues. Verify λ₁+λ₂ = trace and λ₁·λ₂ = det.'+matrixToPrintTable(M,'A ='), answer:'<span>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong><br>trace = '+smartFormat(tr)+', det = '+smartFormat(det2)+'</span>' }; },
      function() { var M=generateRandomMatrix(2,2,-5,5); var e=eigenvalues2x2(M); return { difficulty:'Medium', question:'Find eigenvalues using the characteristic polynomial λ² − tr(A)λ + det(A) = 0'+matrixToPrintTable(M,'A ='), answer:'<span>tr = '+smartFormat(M[0][0]+M[1][1])+', det = '+smartFormat(M[0][0]*M[1][1]-M[0][1]*M[1][0])+'<br>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong></span>' }; },
      function() { var M=generateRandomMatrix(2,2,-4,4); var e=eigenvalues2x2(M); return { difficulty:'Medium', question:'Find eigenvalues of A. Are they real or complex?'+matrixToPrintTable(M,'A ='), answer: (function(){var disc=(M[0][0]+M[1][1])*(M[0][0]+M[1][1])-4*(M[0][0]*M[1][1]-M[0][1]*M[1][0]); return '<span>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong><br>Discriminant = '+smartFormat(disc)+' → '+(disc>=0?'<strong>Real</strong>':'<strong>Complex</strong>')+'</span>';})() }; },
      function() { var M=generateRandomMatrix(2,2,-6,6); var e=eigenvalues2x2(M); return { difficulty:'Hard', question:'Find eigenvalues and determine if A is positive definite (both λ > 0?)'+matrixToPrintTable(M,'A ='), answer: (function(){var l1=parseFloat(e[0]),l2=parseFloat(e[1]); var pd=(isFinite(l1)&&isFinite(l2)&&l1>0&&l2>0); return '<span>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong><br>Positive definite: <strong>'+(pd?'Yes':'No')+'</strong></span>';})() }; },
      function() { var M=generateRandomMatrix(2,2,-5,5); var e=eigenvalues2x2(M); return { difficulty:'Hard', question:'Find eigenvalues. What is det(A−λI) for λ=0?'+matrixToPrintTable(M,'A ='), answer:'<span>λ₁ = <strong>'+e[0]+'</strong>, λ₂ = <strong>'+e[1]+'</strong><br>det(A−0·I) = det(A) = <strong>'+smartFormat(determinant(M))+'</strong></span>' }; }
    ],
    classifier: [
      function() { var M=generateRandomMatrix(2,2,-3,3); return { difficulty:'Easy', question:'Classify this matrix. List all types that apply.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var M=createIdentity(2); return { difficulty:'Easy', question:'Classify this matrix.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var M=[[0,0],[0,0]]; return { difficulty:'Easy', question:'Classify the zero matrix.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var M=generateRandomMatrix(3,3,-2,2); return { difficulty:'Medium', question:'Classify this 3×3 matrix. List all types.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var M=generateRandomMatrix(2,3,-3,3); return { difficulty:'Medium', question:'Classify this non-square matrix.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var a=1+Math.floor(Math.random()*3),b=1+Math.floor(Math.random()*3),c=1+Math.floor(Math.random()*3); var M=[[a,0,0],[0,b,0],[0,0,c]]; return { difficulty:'Medium', question:'Classify this diagonal matrix.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var M=generateRandomMatrix(3,3,-3,3); /* force upper triangular */ for(var i=1;i<3;i++) for(var j=0;j<i;j++) M[i][j]=0; return { difficulty:'Hard', question:'Classify this matrix. List all types that apply.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; },
      function() { var M=generateRandomMatrix(4,4,-2,2); return { difficulty:'Hard', question:'Classify this 4×4 matrix.'+matrixToPrintTable(M,'A ='), answer:'<span>'+classifyMatrix(M).join(', ')+'</span>' }; }
    ]
  };

  /* Friendly topic labels */
  var topicLabels = {
    addition: 'Addition & Subtraction',
    multiplication: 'Multiplication',
    determinant: 'Determinant',
    inverse: 'Inverse',
    transpose: 'Transpose',
    rank: 'Rank & Nullity',
    eigenvalue: 'Eigenvalue & Eigenvector',
    power: 'Matrix Power',
    classifier: 'Matrix Classification'
  };

  /* Generate N problems from a single bank */
  function _generateFromBank(bank, count) {
    var easyGens = [], medGens = [], hardGens = [];
    for (var g = 0; g < bank.length; g++) {
      var sample = bank[g]();
      if (sample.difficulty === 'Easy') easyGens.push(g);
      else if (sample.difficulty === 'Medium') medGens.push(g);
      else hardGens.push(g);
    }
    if (easyGens.length === 0) easyGens = medGens.slice();
    if (medGens.length === 0) medGens = easyGens.slice();
    if (hardGens.length === 0) hardGens = medGens.slice();

    var easyCount = Math.ceil(count * 0.35);
    var medCount  = Math.ceil(count * 0.35);
    var hardCount = count - easyCount - medCount;

    var problems = [];
    var qi;
    for (qi = 0; qi < easyCount; qi++) problems.push(bank[pickRandom(easyGens)]());
    for (qi = 0; qi < medCount; qi++)  problems.push(bank[pickRandom(medGens)]());
    for (qi = 0; qi < hardCount; qi++) problems.push(bank[pickRandom(hardGens)]());
    shuffle(problems);
    return problems;
  }

  /* Build HTML for a numbered question list + collect answers; startNum = first question number */
  function _renderQuestions(problems, startNum) {
    var html = '';
    var answers = [];
    for (var q = 0; q < problems.length; q++) {
      var p = problems[q];
      var num = startNum + q;
      html += '<div class="ws-question">';
      html += '<p class="ws-q-header">Q' + num + '. ' + diffBadge[p.difficulty];
      if (p.topic) html += ' <span class="ws-topic-tag">' + p.topic + '</span>';
      html += '</p>';
      html += '<div class="ws-q-body">' + p.question + '</div>';
      html += '</div>';
      answers.push({ q: num, difficulty: p.difficulty, topic: p.topic || '', html: p.answer });
    }
    return { html: html, answers: answers };
  }

  /* Build answer key HTML from answer array */
  function _renderAnswerKey(answers, title) {
    var html = '<div class="ws-page-break">';
    html += '<h2 class="ws-answer-title">' + (title || 'Answer Key') + '</h2>';
    for (var a = 0; a < answers.length; a++) {
      html += '<div class="ws-answer-item">';
      html += '<p class="ws-a-header">Q' + answers[a].q + ' ' + diffBadge[answers[a].difficulty];
      if (answers[a].topic) html += ' <span class="ws-topic-tag">' + answers[a].topic + '</span>';
      html += '</p>';
      html += '<div class="ws-a-body">' + answers[a].html + '</div>';
      html += '</div>';
    }
    html += '</div>';
    return html;
  }

  function generateExerciseProblems(exerciseType, count) {
    count = Math.max(count || 20, 20);
    var bank = questionBank[exerciseType] || questionBank['addition'];
    var primaryLabel = topicLabels[exerciseType] || exerciseType;

    /* ── Section 1: Primary topic ── */
    var primaryProblems = _generateFromBank(bank, count);
    var sec1 = _renderQuestions(primaryProblems, 1);

    var html = '';
    html += '<div class="ws-section-header">';
    html += '<div class="ws-section-num">Section 1</div>';
    html += '<div class="ws-section-label">' + primaryLabel + ' <span class="ws-q-count">(' + count + ' Questions)</span></div>';
    html += '</div>';
    html += sec1.html;

    /* ── Section 2: Mixed Practice from all OTHER topics ── */
    var otherKeys = [];
    for (var key in questionBank) {
      if (questionBank.hasOwnProperty(key) && key !== exerciseType) otherKeys.push(key);
    }

    var mixedCount = 20;
    /* distribute roughly evenly across topics, minimum 2 per topic */
    var perTopic = Math.max(2, Math.floor(mixedCount / otherKeys.length));
    var mixedProblems = [];
    for (var t = 0; t < otherKeys.length; t++) {
      var topicKey = otherKeys[t];
      var topicBank = questionBank[topicKey];
      var topicProbs = _generateFromBank(topicBank, perTopic);
      var label = topicLabels[topicKey] || topicKey;
      for (var tp = 0; tp < topicProbs.length; tp++) topicProbs[tp].topic = label;
      mixedProblems = mixedProblems.concat(topicProbs);
    }
    shuffle(mixedProblems);
    /* trim to exactly mixedCount */
    if (mixedProblems.length > mixedCount) mixedProblems = mixedProblems.slice(0, mixedCount);

    var sec2StartNum = count + 1;
    var sec2 = _renderQuestions(mixedProblems, sec2StartNum);

    html += '<div class="ws-page-break"></div>';
    html += '<div class="ws-section-header">';
    html += '<div class="ws-section-num">Section 2</div>';
    html += '<div class="ws-section-label">Mixed Practice <span class="ws-q-count">(' + mixedProblems.length + ' Questions)</span></div>';
    html += '</div>';
    html += sec2.html;

    /* ── Answer Keys ── */
    html += _renderAnswerKey(sec1.answers, 'Answer Key — Section 1: ' + primaryLabel);
    html += _renderAnswerKey(sec2.answers, 'Answer Key — Section 2: Mixed Practice');

    return html;
  }

  /* ── Print Worksheet ── */
  /* opts: { exerciseType, exerciseCount } - exerciseType: addition|transpose|multiplication|determinant|inverse|power|rank|eigenvalue|classifier */
  function printWorksheet(btn, toolName, opts) {
    if (!btn) return;
    opts = opts || {};
    var exerciseType = opts.exerciseType || 'addition';
    var exerciseCount = Math.max(opts.exerciseCount || 20, 20);
    var totalQ = exerciseCount + 20; /* primary + mixed */

    btn.addEventListener('click', function () {
      var printArea = document.createElement('div');
      printArea.id = 'printArea';

      /* ── Print Stylesheet ── */
      var css = '<style>';
      css += '#printArea{padding:1.5cm;font-family:"Inter","Segoe UI",system-ui,sans-serif;color:#0f172a;font-size:11pt;line-height:1.5}';
      /* Header */
      css += '.ws-header{text-align:center;margin-bottom:1.5rem;padding-bottom:1rem;border-bottom:3px double #1e293b}';
      css += '.ws-title{font-size:1.6rem;font-weight:800;letter-spacing:-0.02em;margin:0 0 0.15rem;color:#0f172a}';
      css += '.ws-subtitle{font-size:0.85rem;color:#64748b;margin:0.25rem 0}';
      css += '.ws-meta{display:flex;justify-content:space-between;align-items:center;margin-top:0.75rem;padding:0.6rem 0.8rem;background:#f8fafc;border:1px solid #e2e8f0;border-radius:6px;font-size:0.82rem;color:#475569}';
      css += '.ws-meta-field{flex:1}';
      css += '.ws-meta-field:not(:last-child){border-right:1px solid #e2e8f0;padding-right:0.75rem;margin-right:0.75rem}';
      css += '.ws-meta-label{font-weight:600;font-size:0.7rem;text-transform:uppercase;letter-spacing:0.05em;color:#94a3b8;display:block}';
      css += '.ws-meta-value{margin-top:0.15rem;min-width:100px;border-bottom:1px dotted #94a3b8;display:inline-block;width:100%}';
      /* Section headers */
      css += '.ws-section-header{display:flex;align-items:center;gap:0.6rem;margin:1.5rem 0 1rem;padding:0.6rem 0.8rem;background:linear-gradient(135deg,#1e293b,#334155);border-radius:6px;color:#fff}';
      css += '.ws-section-num{font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;opacity:0.8}';
      css += '.ws-section-label{font-size:1rem;font-weight:700}';
      css += '.ws-q-count{font-weight:400;font-size:0.8rem;opacity:0.7}';
      /* Topic tag (for mixed section) */
      css += '.ws-topic-tag{display:inline-block;font-size:0.65rem;font-weight:600;padding:0.05rem 0.35rem;border-radius:3px;background:#e0e7ff;color:#3730a3;margin-left:0.3rem;vertical-align:middle}';
      /* Questions */
      css += '.ws-question{margin-bottom:1rem;padding:0.6rem 0.75rem;border:1px solid #e2e8f0;border-radius:6px;break-inside:avoid;background:#fff}';
      css += '.ws-q-header{margin:0 0 0.35rem;font-weight:700;font-size:0.92rem;color:#1e293b}';
      css += '.ws-q-body{margin-left:0.15rem;font-size:0.88rem;color:#334155}';
      css += '.ws-q-body table{border-collapse:collapse;margin:0.4rem 0;display:inline-table;vertical-align:middle}';
      css += '.ws-q-body td{border:1px solid #94a3b8;padding:0.2rem 0.5rem;text-align:center;min-width:2rem;font-size:0.85rem}';
      /* Answer key */
      css += '.ws-page-break{page-break-before:always}';
      css += '.ws-answer-title{margin:0 0 0.75rem;font-size:1.1rem;font-weight:800;padding-bottom:0.4rem;border-bottom:2px solid #1e293b;color:#0f172a}';
      css += '.ws-answer-item{margin-bottom:0.45rem;padding:0.35rem 0.6rem;border-left:3px solid #3b82f6;background:#f8fafc;border-radius:0 4px 4px 0;break-inside:avoid}';
      css += '.ws-a-header{margin:0 0 0.15rem;font-weight:700;font-size:0.8rem;color:#1e293b}';
      css += '.ws-a-body{font-size:0.78rem;margin-left:0.15rem;color:#334155}';
      css += '.ws-a-body table{border-collapse:collapse;margin:0.25rem 0;display:inline-table}';
      css += '.ws-a-body td{border:1px solid #94a3b8;padding:0.15rem 0.4rem;text-align:center;min-width:1.5rem;font-size:0.75rem}';
      /* Footer */
      css += '.ws-footer{text-align:center;color:#94a3b8;font-size:0.7rem;margin-top:1.5rem;padding-top:0.5rem;border-top:1px solid #e2e8f0}';
      /* Print overrides */
      css += '@media print{#printArea{padding:0.8cm}body>*:not(#printArea){display:none!important}.ws-section-header{-webkit-print-color-adjust:exact;print-color-adjust:exact}.ws-answer-item{-webkit-print-color-adjust:exact;print-color-adjust:exact}.ws-topic-tag{-webkit-print-color-adjust:exact;print-color-adjust:exact}.ws-meta{-webkit-print-color-adjust:exact;print-color-adjust:exact}}';
      css += '</style>';

      var primaryLabel = topicLabels[exerciseType] || exerciseType;
      var dateStr = new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });

      var html = css;
      /* ── Header ── */
      html += '<div class="ws-header">';
      html += '<h1 class="ws-title">' + (toolName || 'Matrix') + ' — Practice Worksheet</h1>';
      html += '<p class="ws-subtitle">' + totalQ + ' Questions &bull; Easy / Medium / Hard &bull; 8gwifi.org</p>';
      html += '<div class="ws-meta">';
      html += '<div class="ws-meta-field"><span class="ws-meta-label">Name</span><span class="ws-meta-value">&nbsp;</span></div>';
      html += '<div class="ws-meta-field"><span class="ws-meta-label">Date</span><span class="ws-meta-value">' + dateStr + '</span></div>';
      html += '<div class="ws-meta-field"><span class="ws-meta-label">Score</span><span class="ws-meta-value">&nbsp;&nbsp;&nbsp;/ ' + totalQ + '</span></div>';
      html += '</div>';
      html += '</div>';

      /* ── Questions (Section 1 + Section 2 + Answer Keys) ── */
      html += generateExerciseProblems(exerciseType, exerciseCount);

      /* ── Footer ── */
      html += '<div class="ws-footer">Generated by 8gwifi.org &mdash; Free Online Matrix Calculators &amp; Learning Tools</div>';

      printArea.innerHTML = html;
      document.body.appendChild(printArea);
      window.print();
      setTimeout(function () { printArea.remove(); }, 1000);
    });
  }

  /* ── internal: flash a button ── */
  function _flashBtn(btn, fromClass, toClass, html) {
    var original = btn.innerHTML;
    btn.innerHTML = html;
    btn.classList.remove(fromClass);
    btn.classList.add(toClass);
    setTimeout(function () {
      btn.innerHTML = original;
      btn.classList.remove(toClass);
      btn.classList.add(fromClass);
      btn.disabled = false;
    }, 2000);
  }

  /* ── Make a steps card collapsible (default collapsed) ── */
  function makeStepsCollapsible(cardEl, opts) {
    if (!cardEl) return;
    opts = opts || {};
    var headerEl = cardEl.querySelector('.tool-card-header');
    var bodyEl = cardEl.querySelector('.tool-card-body');
    if (!headerEl || !bodyEl) return;

    /* wrap header content in toggle */
    var label = headerEl.textContent.trim();
    headerEl.innerHTML = '<div class="matrix-steps-toggle" role="button" tabindex="0" aria-expanded="false">' +
      '<span>' + label + '</span>' +
      '<span class="steps-chevron">&#9660;</span>' +
      '</div>';
    bodyEl.classList.add('matrix-steps-body', 'collapsed');
    bodyEl.style.maxHeight = '0';

    var toggle = headerEl.querySelector('.matrix-steps-toggle');
    function flip() {
      var expanded = toggle.getAttribute('aria-expanded') === 'true';
      if (expanded) {
        bodyEl.style.maxHeight = bodyEl.scrollHeight + 'px';
        requestAnimationFrame(function() { bodyEl.classList.add('collapsed'); bodyEl.style.maxHeight = '0'; });
        toggle.setAttribute('aria-expanded', 'false');
      } else {
        bodyEl.classList.remove('collapsed');
        bodyEl.style.maxHeight = bodyEl.scrollHeight + 'px';
        toggle.setAttribute('aria-expanded', 'true');
        setTimeout(function() { bodyEl.style.maxHeight = 'none'; }, 300);
      }
    }
    toggle.addEventListener('click', flip);
    toggle.addEventListener('keydown', function(e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); flip(); } });

    /* auto-expand when content is populated */
    var stepsInner = bodyEl.querySelector('#stepsArea') || bodyEl.querySelector('#stepsContent') || bodyEl.firstElementChild;
    if (stepsInner) {
      var obs = new MutationObserver(function() {
        var txt = (stepsInner.textContent || '').trim();
        if (txt.length > 50 && !/will appear here|Detailed .* steps/.test(txt) && toggle.getAttribute('aria-expanded') === 'false') {
          flip();
        }
      });
      obs.observe(stepsInner, { childList: true, subtree: true, characterData: true });
    }
  }

  /* ── Step Engine (reusable structured pedagogy flow) ── */
  function createStepEngine(options) {
    options = options || {};
    var steps = [];

    function _push(kind, title, payload) {
      steps.push({
        kind: kind,
        title: title || '',
        text: payload && payload.text ? payload.text : '',
        html: payload && payload.html ? payload.html : '',
        latex: payload && payload.latex ? payload.latex : '',
        level: payload && payload.level ? payload.level : ''
      });
    }

    return {
      note: function (title, text, level) {
        _push('note', title, { text: text, level: level || 'info' });
      },
      operation: function (title, text) {
        _push('operation', title || 'Operation', { text: text, level: 'info' });
      },
      matrix: function (title, latex, text) {
        _push('matrix', title || 'Matrix', { latex: latex, text: text });
      },
      equation: function (title, latex, text) {
        _push('equation', title || 'Equation', { latex: latex, text: text });
      },
      result: function (title, text, latex) {
        _push('result', title || 'Result', { text: text, latex: latex, level: 'success' });
      },
      rawHtml: function (title, html) {
        _push('html', title || 'Detail', { html: html });
      },
      all: function () {
        return steps.slice();
      },
      count: function () {
        return steps.length;
      }
    };
  }

  function _stepPreviewText(step) {
    var raw = (step && (step.text || step.html || step.title || '')) || '';
    return String(raw)
      .replace(/<div class="matrix-display"[\s\S]*?<\/div>/g, 'Matrix updated.')
      .replace(/<[^>]*>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
  }

  function _buildStepCheckpoints(steps) {
    if (!steps || !steps.length) return [];
    var first = steps[0];
    var middle = steps[Math.floor((steps.length - 1) / 2)];
    var last = steps[steps.length - 1];
    return [
      { title: 'Start', body: _stepPreviewText(first) || 'Initialization.' },
      { title: 'Middle', body: _stepPreviewText(middle) || 'Main transformations.' },
      { title: 'Finish', body: _stepPreviewText(last) || 'Final result extracted.' }
    ];
  }

  function renderStepEngine(steps, options) {
    options = options || {};
    if (!steps || !steps.length) {
      return '<div style="color:var(--text-muted)">No detailed steps generated.</div>';
    }

    var classNames = {
      layout: options.layoutClass || 'teacher-layout',
      stream: options.streamClass || 'teacher-step-stream',
      step: options.stepClass || 'teacher-step',
      stepHead: options.stepHeadClass || 'teacher-step-head',
      stepBody: options.stepBodyClass || 'teacher-step-body',
      checkpoint: options.checkpointClass || 'teacher-checkpoint',
      checkpointTitle: options.checkpointTitleClass || 'teacher-checkpoint-title',
      checkpointBody: options.checkpointBodyClass || 'teacher-checkpoint-body',
      matrixWrap: options.matrixClass || 'matrix-display',
      player: options.playerClass || 'matrix-step-player',
      playerHeader: options.playerHeaderClass || 'matrix-step-player-header',
      playerMeta: options.playerMetaClass || 'matrix-step-player-meta',
      playerProgress: options.playerProgressClass || 'matrix-step-progress',
      playerBar: options.playerBarClass || 'matrix-step-progress-bar',
      playerViewport: options.playerViewportClass || 'matrix-step-viewport',
      playerSlide: options.playerSlideClass || 'matrix-step-slide',
      playerControls: options.playerControlsClass || 'matrix-step-controls'
    };

    var stepHtml = steps.map(function (step, idx) {
      var title = step.title || ('Step ' + (idx + 1));
      var parts = [];
      if (step.text) parts.push('<div>' + step.text + '</div>');
      if (step.html) parts.push(step.html);
      if (step.latex) parts.push('<div class="' + classNames.matrixWrap + '">$$' + step.latex + '$$</div>');
      if (!parts.length) parts.push('<div>' + _stepPreviewText(step) + '</div>');

      return '<div class="' + classNames.step + '">' +
        '<div class="' + classNames.stepHead + '">Step ' + (idx + 1) + ' · ' + title + '</div>' +
        '<div class="' + classNames.stepBody + '">' + parts.join('') + '</div>' +
      '</div>';
    }).join('');

    var checkpointHtml = _buildStepCheckpoints(steps).map(function (item) {
      return '<div class="' + classNames.checkpoint + '">' +
        '<div class="' + classNames.checkpointTitle + '">' + item.title + '</div>' +
        '<div class="' + classNames.checkpointBody + '">' + item.body + '</div>' +
      '</div>';
    }).join('');

    if (options.mode === 'player') {
      var slideHtml = steps.map(function (step, idx) {
        var title = step.title || ('Step ' + (idx + 1));
        var parts = [];
        if (step.text) parts.push('<div>' + step.text + '</div>');
        if (step.html) parts.push(step.html);
        if (step.latex) parts.push('<div class="' + classNames.matrixWrap + '">$$' + step.latex + '$$</div>');
        if (!parts.length) parts.push('<div>' + _stepPreviewText(step) + '</div>');

        return '<article class="' + classNames.playerSlide + (idx === 0 ? ' is-active' : '') + '" data-step-index="' + idx + '">' +
          '<div class="' + classNames.stepHead + '">Step ' + (idx + 1) + ' · ' + title + '</div>' +
          '<div class="' + classNames.stepBody + '">' + parts.join('') + '</div>' +
        '</article>';
      }).join('');

      return '<div class="' + classNames.layout + '">' +
        '<div class="' + classNames.player + '" data-step-player data-step-count="' + steps.length + '">' +
          '<div class="' + classNames.playerHeader + '">' +
            '<div class="' + classNames.playerMeta + '"><strong data-step-current>1</strong> / <span data-step-total>' + steps.length + '</span></div>' +
            '<div class="' + classNames.playerProgress + '"><div class="' + classNames.playerBar + '" data-step-progress style="width:' + (100 / steps.length) + '%"></div></div>' +
          '</div>' +
          '<div class="' + classNames.playerViewport + '">' + slideHtml + '</div>' +
          '<div class="' + classNames.playerControls + '">' +
            '<button type="button" class="tool-btn-outline" data-step-action="prev">Previous</button>' +
            '<button type="button" class="tool-action-btn" data-step-action="next">Next Step</button>' +
          '</div>' +
        '</div>' +
        '<div>' + checkpointHtml + '</div>' +
      '</div>';
    }

    return '<div class="' + classNames.layout + '">' +
      '<div class="' + classNames.stream + '">' + stepHtml + '</div>' +
      '<div>' + checkpointHtml + '</div>' +
    '</div>';
  }

  function createMatrixAnimationEngine(options) {
    options = options || {};
    var frames = [];
    var previous = null;

    function _computeChanged(prev, next) {
      var changed = [];
      if (!prev || !next) return changed;
      for (var i = 0; i < next.length; i++) {
        for (var j = 0; j < next[i].length; j++) {
          if (Math.abs((next[i][j] || 0) - (prev[i][j] || 0)) > EPS) {
            changed.push(i + ':' + j);
          }
        }
      }
      return changed;
    }

    return {
      addFrame: function (title, matrix, note, meta) {
        var snapshot = cloneMatrix(matrix);
        var changed = _computeChanged(previous, snapshot);
        frames.push({
          title: title || 'Frame',
          note: note || '',
          matrix: snapshot,
          changed: changed,
          meta: meta || null
        });
        previous = snapshot;
      },
      all: function () {
        return frames.slice();
      },
      count: function () {
        return frames.length;
      }
    };
  }

  function renderMatrixAnimation(frames, options) {
    options = options || {};
    if (!frames || !frames.length) {
      return '';
    }

    var title = options.title || 'Matrix Animation';
    var playerId = 'matrix-anim-' + Date.now() + '-' + Math.floor(Math.random() * 1000000);
    window.__matrixAnimStore = window.__matrixAnimStore || {};
    window.__matrixAnimStore[playerId] = frames;

    return '<div class="matrix-anim-player" data-matrix-anim-player data-matrix-anim-id="' + playerId + '">' +
      '<div class="matrix-anim-header">' +
        '<div class="matrix-anim-title">' + title + '</div>' +
        '<div class="matrix-anim-meta"><strong data-matrix-anim-current>1</strong>/<span data-matrix-anim-total>' + frames.length + '</span></div>' +
      '</div>' +
      '<div class="matrix-anim-progress"><div class="matrix-anim-progress-bar" data-matrix-anim-progress style="width:' + (100 / frames.length) + '%"></div></div>' +
      '<div class="matrix-anim-stage">' +
        '<div class="matrix-anim-frame-title" data-matrix-anim-frame-title></div>' +
        '<div class="matrix-anim-grid-wrap" data-matrix-anim-grid></div>' +
        '<div class="matrix-anim-note" data-matrix-anim-note></div>' +
      '</div>' +
      '<div class="matrix-anim-controls">' +
        '<button type="button" class="tool-btn-outline" data-matrix-anim-action="prev">Previous</button>' +
        '<button type="button" class="tool-action-btn" data-matrix-anim-action="next">Next</button>' +
      '</div>' +
    '</div>';
  }

  function initMatrixAnimation(root) {
    if (!root) return;
    var players = root.querySelectorAll('[data-matrix-anim-player]');
    players.forEach(function (player) {
      if (player.__matrixAnimReady) return;
      player.__matrixAnimReady = true;

      var playerId = player.getAttribute('data-matrix-anim-id');
      var frames = window.__matrixAnimStore && window.__matrixAnimStore[playerId];
      if (!frames || !frames.length) return;

      var index = 0;
      var gridEl = player.querySelector('[data-matrix-anim-grid]');
      var titleEl = player.querySelector('[data-matrix-anim-frame-title]');
      var noteEl = player.querySelector('[data-matrix-anim-note]');
      var currentEl = player.querySelector('[data-matrix-anim-current]');
      var progressEl = player.querySelector('[data-matrix-anim-progress]');
      var prevBtn = player.querySelector('[data-matrix-anim-action="prev"]');
      var nextBtn = player.querySelector('[data-matrix-anim-action="next"]');

      function buildGrid(frame) {
        var changedSet = {};
        (frame.changed || []).forEach(function (key) { changedSet[key] = true; });

        var html = '<table class="matrix-anim-grid"><tbody>';
        for (var r = 0; r < frame.matrix.length; r++) {
          html += '<tr data-matrix-anim-row="' + r + '">';
          for (var c = 0; c < frame.matrix[r].length; c++) {
            var key = r + ':' + c;
            var cls = changedSet[key] ? ' class="cell-changed"' : '';
            html += '<td' + cls + '>' + formatExactNumber(frame.matrix[r][c]) + '</td>';
          }
          html += '</tr>';
        }
        html += '</tbody></table>';
        return html;
      }

      function animateMotion(frame) {
        if (!frame || !frame.meta || !gridEl) return;

        if (frame.meta.type === 'swap' && frame.meta.rows && frame.meta.rows.length === 2) {
          var rowA = frame.meta.rows[0];
          var rowB = frame.meta.rows[1];
          var rowEls = gridEl.querySelectorAll('[data-matrix-anim-row]');
          var aEl = rowEls[rowA];
          var bEl = rowEls[rowB];
          if (!aEl || !bEl) return;

          var aRect = aEl.getBoundingClientRect();
          var bRect = bEl.getBoundingClientRect();
          var shift = bRect.top - aRect.top;

          try {
            aEl.animate([
              { transform: 'translateY(' + shift + 'px)', background: 'rgba(59,130,246,0.18)' },
              { transform: 'translateY(0)', background: 'transparent' }
            ], { duration: 420, easing: 'cubic-bezier(0.22, 1, 0.36, 1)' });

            bEl.animate([
              { transform: 'translateY(' + (-shift) + 'px)', background: 'rgba(59,130,246,0.18)' },
              { transform: 'translateY(0)', background: 'transparent' }
            ], { duration: 420, easing: 'cubic-bezier(0.22, 1, 0.36, 1)' });
          } catch (err) {
            // no-op fallback for browsers without WAAPI
          }
          return;
        }

        if (frame.meta.type === 'eliminate' && frame.meta.targetRows && frame.meta.targetRows.length) {
          var allRows = gridEl.querySelectorAll('[data-matrix-anim-row]');
          frame.meta.targetRows.forEach(function (rowIndex, index) {
            var rowEl = allRows[rowIndex];
            if (!rowEl) return;
            try {
              rowEl.animate([
                { transform: 'translateX(12px)', background: 'rgba(16,185,129,0.16)' },
                { transform: 'translateX(0)', background: 'transparent' }
              ], { duration: 320 + (index * 60), easing: 'ease-out' });
            } catch (err) {
              // no-op fallback
            }
          });
        }
      }

      function render() {
        var frame = frames[index];
        if (!frame) return;

        if (titleEl) titleEl.textContent = frame.title || ('Step ' + (index + 1));
        if (noteEl) noteEl.textContent = frame.note || '';
        if (currentEl) currentEl.textContent = String(index + 1);
        if (progressEl) progressEl.style.width = (((index + 1) / frames.length) * 100) + '%';

        if (gridEl) {
          gridEl.classList.remove('frame-enter');
          void gridEl.offsetWidth;
          gridEl.innerHTML = buildGrid(frame);
          gridEl.classList.add('frame-enter');
          animateMotion(frame);
        }

        if (prevBtn) prevBtn.disabled = index === 0;
        if (nextBtn) nextBtn.textContent = index >= frames.length - 1 ? 'Replay' : 'Next';
      }

      function goNext() {
        if (index >= frames.length - 1) {
          index = 0;
        } else {
          index += 1;
        }
        render();
      }

      function goPrev() {
        index = Math.max(0, index - 1);
        render();
      }

      if (prevBtn) prevBtn.addEventListener('click', goPrev);
      if (nextBtn) nextBtn.addEventListener('click', goNext);
      render();
    });
  }

  function initStepPlayer(root) {
    if (!root) return;
    var players = root.querySelectorAll('[data-step-player]');
    players.forEach(function (player) {
      if (player.__stepPlayerReady) return;
      player.__stepPlayerReady = true;

      var slides = Array.prototype.slice.call(player.querySelectorAll('[data-step-index]'));
      if (!slides.length) return;

      var current = 0;
      var total = slides.length;
      var currentEl = player.querySelector('[data-step-current]');
      var progressEl = player.querySelector('[data-step-progress]');
      var prevBtn = player.querySelector('[data-step-action="prev"]');
      var nextBtn = player.querySelector('[data-step-action="next"]');

      function render() {
        slides.forEach(function (slide, idx) {
          slide.classList.toggle('is-active', idx === current);
          slide.classList.toggle('is-past', idx < current);
        });

        if (currentEl) currentEl.textContent = String(current + 1);
        if (progressEl) progressEl.style.width = (((current + 1) / total) * 100) + '%';
        if (prevBtn) prevBtn.disabled = current === 0;
        if (nextBtn) {
          nextBtn.textContent = current >= total - 1 ? 'Replay' : 'Next Step';
        }
      }

      function next() {
        if (current >= total - 1) {
          current = 0;
        } else {
          current += 1;
        }
        render();
      }

      function prev() {
        current = Math.max(0, current - 1);
        render();
      }

      if (prevBtn) prevBtn.addEventListener('click', prev);
      if (nextBtn) nextBtn.addEventListener('click', next);
      render();
    });
  }

  /* ── Public API ── */
  window.MatrixUtils = {
    EPS: EPS,
    initMathJax: initMathJax,
    rerender: rerender,
    parseMatrix: parseMatrix,
    parseNumericToken: parseNumericToken,
    cloneMatrix: cloneMatrix,
    smartFormat: smartFormat,
    formatExactNumber: formatExactNumber,
    formatMatrix: formatMatrix,
    createIdentity: createIdentity,
    multiply: multiply,
    transpose: transpose,
    shareURL: shareURL,
    generateRandomNumericToken: generateRandomNumericToken,
    generateRandomMatrixText: generateRandomMatrixText,
    downloadImage: downloadImage,
    loadFromURL: loadFromURL,
    printWorksheet: printWorksheet,
    makeStepsCollapsible: makeStepsCollapsible,
    createStepEngine: createStepEngine,
    renderStepEngine: renderStepEngine,
    initStepPlayer: initStepPlayer,
    createMatrixAnimationEngine: createMatrixAnimationEngine,
    renderMatrixAnimation: renderMatrixAnimation,
    initMatrixAnimation: initMatrixAnimation
  };
})();
