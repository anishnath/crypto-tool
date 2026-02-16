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
        var num = parseFloat(entries[j]);
        if (!isFinite(num)) throw new Error('Invalid number: ' + entries[j]);
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

  /* ── Matrix to HTML table for print ── */
  function matrixToPrintTable(mat, label) {
    var html = '';
    if (label) html += '<div style="font-weight:600;margin-bottom:0.25rem;font-size:0.9rem">' + label + '</div>';
    html += '<table class="print-matrix-grid" style="border-collapse:collapse;margin-bottom:0.75rem"><tbody>';
    for (var i = 0; i < mat.length; i++) {
      html += '<tr>';
      for (var j = 0; j < mat[i].length; j++) {
        html += '<td style="border:1px solid #333;padding:0.35rem 0.6rem;text-align:center;font-family:monospace;min-width:2em">' + mat[i][j] + '</td>';
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

  /* ── Exercise generator for print worksheet (various question forms) ── */
  function pickRandom(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
  }

  function generateExerciseProblems(exerciseType, count) {
    count = count || 5;
    var blank = '<span class="print-exercise-blank" style="display:inline-block;width:60px;border-bottom:1px solid #000;margin:0 4px;vertical-align:middle"></span>';
    var html = '<div class="print-exercise" style="margin-top:2rem;padding:1rem;border:1px solid #ccc;border-radius:8px;break-inside:avoid">';
    html += '<h3 style="margin:0 0 1rem;font-size:1.1rem;">Practice Exercises</h3>';

    for (var q = 0; q < count; q++) {
      html += '<div style="margin-bottom:1.5rem;padding-bottom:1rem;border-bottom:1px dashed #e2e8f0">';
      if (exerciseType === 'addition') {
        var addForms = [
          { op: 'A + B', gen: function() { var r=2+(q%2), c=2+(q%2); return { A: generateRandomMatrix(r,c,-5,5), B: generateRandomMatrix(r,c,-5,5), prompt: 'Find A + B', answer: 'A + B = ' + blank }; } },
          { op: 'A - B', gen: function() { var r=2, c=2+(q%2); return { A: generateRandomMatrix(r,c,-5,5), B: generateRandomMatrix(r,c,-5,5), prompt: 'Find A - B', answer: 'A - B = ' + blank }; } },
          { op: 'cA', gen: function() { var c=2+Math.floor(Math.random()*3); var M=generateRandomMatrix(2,2,-4,4); return { c: c, A: M, prompt: 'Find ' + c + 'A (scalar multiplication)', answer: c + 'A = ' + blank }; } },
          { op: 'aA+bB', gen: function() { var a=2+Math.floor(Math.random()*2), b=1+Math.floor(Math.random()*2); var A=generateRandomMatrix(2,2,-3,3), B=generateRandomMatrix(2,2,-3,3); return { a:a, b:b, A:A, B:B, prompt: 'Find ' + a + 'A + ' + b + 'B (linear combination)', answer: a + 'A + ' + b + 'B = ' + blank }; } }
        ];
        var gf = pickRandom(addForms);
        var g = gf.gen();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + g.prompt + '</p>';
        html += matrixToPrintTable(g.A, 'A =');
        if (g.B) html += matrixToPrintTable(g.B, 'B =');
        if (g.c) html += '<p style="margin:0 0 0.5rem;font-size:0.9rem">Scalar c = ' + g.c + '</p>';
        if (g.a !== undefined) html += '<p style="margin:0 0 0.5rem;font-size:0.9rem">Scalars a = ' + g.a + ', b = ' + g.b + '</p>';
        html += '<p style="margin:0.5rem 0 0">' + g.answer + '</p>';
      } else if (exerciseType === 'transpose') {
        var dims = [[2,3],[3,2],[2,4],[4,2],[3,4],[2,2],[3,3]];
        var d = dims[q % dims.length];
        var M = generateRandomMatrix(d[0], d[1], -5, 5);
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': Find A<sup>T</sup>. Matrix A is ' + d[0] + '×' + d[1] + '.</p>';
        html += matrixToPrintTable(M, 'A =');
        html += '<p style="margin:0.5rem 0 0">A<sup>T</sup> = ' + blank + '</p>';
      } else if (exerciseType === 'multiplication') {
        var multDims = [[2,2,2],[2,3,2],[3,2,3],[2,2,3],[3,3,2]];
        var md = multDims[q % multDims.length];
        var Ma = generateRandomMatrix(md[0], md[1], -3, 3);
        var Mb = generateRandomMatrix(md[1], md[2], -3, 3);
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': Find A × B. A is ' + md[0] + '×' + md[1] + ', B is ' + md[1] + '×' + md[2] + '.</p>';
        html += matrixToPrintTable(Ma, 'A =');
        html += matrixToPrintTable(Mb, 'B =');
        html += '<p style="margin:0.5rem 0 0">A × B = ' + blank + '</p>';
      } else if (exerciseType === 'determinant') {
        var detForms = [
          function() { var m=generateRandomMatrix(2,2,-5,5); return { mat: m, prompt: 'Find det(A) for this 2×2 matrix', answer: 'det(A) = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-5,5); return { mat: m, prompt: 'Use the formula det(A) = ad - bc. Find det(A).', answer: 'det(A) = ' + blank }; },
          function() { var m=generateRandomMatrix(3,3,-4,4); return { mat: m, prompt: 'Find det(A) for this 3×3 matrix (use cofactor expansion or row reduction)', answer: 'det(A) = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-5,5); return { mat: m, prompt: 'Is A singular? (det = 0 means singular) det(A) = ' + blank }; }
        ];
        var df = pickRandom(detForms);
        var dg = df();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + dg.prompt + '</p>';
        html += matrixToPrintTable(dg.mat, 'A =');
        html += '<p style="margin:0.5rem 0 0">' + dg.answer + '</p>';
      } else if (exerciseType === 'inverse') {
        var invForms = [
          function() { var m=generateRandomMatrix(2,2,-4,4); while(m[0][0]*m[1][1]-m[0][1]*m[1][0]===0) m=generateRandomMatrix(2,2,-4,4); return { mat: m, prompt: 'Find A<sup>-1</sup>', answer: 'A<sup>-1</sup> = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-4,4); while(m[0][0]*m[1][1]-m[0][1]*m[1][0]===0) m=generateRandomMatrix(2,2,-4,4); return { mat: m, prompt: 'Compute the inverse of A using [d -b; -c a] / (ad-bc)', answer: 'A<sup>-1</sup> = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-3,3); while(m[0][0]*m[1][1]-m[0][1]*m[1][0]===0) m=generateRandomMatrix(2,2,-3,3); return { mat: m, prompt: 'Is A invertible? Find A<sup>-1</sup> if it exists.', answer: 'A<sup>-1</sup> = ' + blank }; }
        ];
        var iff = pickRandom(invForms);
        var ig = iff();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + ig.prompt + '</p>';
        html += matrixToPrintTable(ig.mat, 'A =');
        html += '<p style="margin:0.5rem 0 0">' + ig.answer + '</p>';
      } else if (exerciseType === 'power') {
        var powForms = [
          function() { var m=generateRandomMatrix(2,2,-3,3); return { mat: m, p: 2, prompt: 'Find A²', answer: 'A² = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-3,3); return { mat: m, p: 3, prompt: 'Find A³', answer: 'A³ = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-2,2); return { mat: m, p: 4, prompt: 'Find A⁴', answer: 'A⁴ = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-3,3); return { mat: m, p: 2, prompt: 'Compute A × A. What is A²?', answer: 'A² = ' + blank }; }
        ];
        var pf = pickRandom(powForms);
        var pg = pf();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + pg.prompt + '</p>';
        html += matrixToPrintTable(pg.mat, 'A =');
        html += '<p style="margin:0.5rem 0 0">' + pg.answer + '</p>';
      } else if (exerciseType === 'rank') {
        var rankForms = [
          function() { var r=2,c=2+(q%2); return { mat: generateRandomMatrix(r,c,-4,4), prompt: 'Find rank(A). A is ' + r + '×' + c + '.', answer: 'rank(A) = ' + blank }; },
          function() { var r=3,c=2; return { mat: generateRandomMatrix(r,c,-4,4), prompt: 'How many linearly independent rows does A have? Find rank(A).', answer: 'rank(A) = ' + blank }; },
          function() { var r=2,c=3; return { mat: generateRandomMatrix(r,c,-4,4), prompt: 'Find the rank of A.', answer: 'rank(A) = ' + blank }; },
          function() { var m=generateRandomMatrix(3,3,-3,3); return { mat: m, prompt: 'Is A full rank? (full rank = rank = min(rows, cols)). rank(A) = ' + blank, answer: 'rank(A) = ' + blank }; }
        ];
        var rf = pickRandom(rankForms);
        var rg = rf();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + rg.prompt + '</p>';
        html += matrixToPrintTable(rg.mat, 'A =');
        html += '<p style="margin:0.5rem 0 0">' + rg.answer + '</p>';
      } else if (exerciseType === 'eigenvalue') {
        var eigForms = [
          function() { var m=generateRandomMatrix(2,2,-4,4); return { mat: m, prompt: 'Find the eigenvalues λ₁ and λ₂ of A.', answer: 'λ₁ = ' + blank + ', λ₂ = ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-4,4); return { mat: m, prompt: 'Find eigenvalues. For one eigenvalue, give an eigenvector.', answer: 'λ₁ = ' + blank + ', eigenvector: ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-3,3); return { mat: m, prompt: 'Solve det(A - λI) = 0. What are the eigenvalues?', answer: 'Eigenvalues: ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-4,4); return { mat: m, prompt: 'Find trace(A) and det(A). How do they relate to eigenvalues? (λ₁+λ₂ = trace, λ₁λ₂ = det)', answer: 'λ₁ = ' + blank + ', λ₂ = ' + blank }; }
        ];
        var ef = pickRandom(eigForms);
        var eg = ef();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + eg.prompt + '</p>';
        html += matrixToPrintTable(eg.mat, 'A =');
        html += '<p style="margin:0.5rem 0 0">' + eg.answer + '</p>';
      } else if (exerciseType === 'classifier') {
        var classForms = [
          function() { var m=generateRandomMatrix(2+(q%2),2+(q%2),-3,3); return { mat: m, prompt: 'Classify this matrix. List all types that apply (e.g. square, diagonal, symmetric).', answer: 'Types: ' + blank }; },
          function() { var m=generateRandomMatrix(2,3,-3,3); return { mat: m, prompt: 'Is A square or rectangular? What are its dimensions?', answer: 'Shape: ' + blank + ', dimensions: ' + blank }; },
          function() { var m=generateRandomMatrix(2,2,-3,3); return { mat: m, prompt: 'Is A symmetric? (Check if A = A<sup>T</sup>)', answer: 'Symmetric? ' + blank }; },
          function() { var m=generateRandomMatrix(3,3,-2,2); return { mat: m, prompt: 'List matrix properties: rank, trace (sum of diagonal), singular or non-singular?', answer: 'Properties: ' + blank }; }
        ];
        var cf = pickRandom(classForms);
        var cg = cf();
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': ' + cg.prompt + '</p>';
        html += matrixToPrintTable(cg.mat, 'A =');
        html += '<p style="margin:0.5rem 0 0">' + cg.answer + '</p>';
      } else {
        var defMat = generateRandomMatrix(2, 2, -4, 4);
        html += '<p style="margin:0 0 0.5rem;font-weight:500">Q' + (q + 1) + ': Compute the result</p>';
        html += matrixToPrintTable(defMat, 'A =');
        html += '<p style="margin:0.5rem 0 0">Answer: ' + blank + '</p>';
      }
      html += '</div>';
    }
    html += '</div>';
    return html;
  }

  /* ── Print Worksheet ── */
  /* opts: { resultIds, stepsId, cardClass, exerciseType } - exerciseType: addition|transpose|multiplication|determinant|inverse|power|rank|eigenvalue|classifier */
  function printWorksheet(btn, toolName, opts) {
    if (!btn) return;
    opts = opts || {};
    var cardClass = opts.cardClass || '.tool-card';
    var resultIds = opts.resultIds || ['resultArea'];
    var stepsId = opts.stepsId || 'stepsArea';
    var exerciseType = opts.exerciseType || 'addition';
    var exerciseCount = opts.exerciseCount || 5;

    btn.addEventListener('click', function () {
      var hasResult = false;
      var resultCards = [];
      for (var i = 0; i < resultIds.length; i++) {
        var el = document.getElementById(resultIds[i]);
        if (!el) continue;
        var card = el.closest(cardClass);
        var hasContent = el.querySelector && (el.querySelector('.result-card') || el.querySelector('.eigenvalue-card') || el.querySelector('.matrix-display') || el.querySelector('.matrix-grid') || el.querySelector('.classification-card') || el.querySelector('.matrix-svg-wrapper') || (el.dataset && el.dataset.state === 'matrix') || (el.innerHTML && el.innerHTML.trim() && !el.textContent.match(/Enter a matrix|will appear here|Run the classifier/)));
        if (!hasContent && el.innerHTML) {
          var txt = (el.textContent || '').trim();
          if (txt.length > 30 && !/Enter a matrix|will appear here|Run the classifier|Click classify/.test(txt)) hasContent = true;
        }
        if (card && hasContent) {
          hasResult = true;
          resultCards.push(card);
        }
      }
      var stepsEl = document.getElementById(stepsId);
      var hasSteps = stepsEl && (stepsEl.querySelector('.step-card') || stepsEl.querySelector('.matrix-display') || stepsEl.querySelector('.explain-step') || (stepsEl.innerHTML && stepsEl.innerHTML.trim().length > 50 && !stepsEl.textContent.match(/Run the classifier|will appear here/)));
      if (!stepsEl) hasSteps = false;

      var printArea = document.createElement('div');
      printArea.id = 'printArea';
      printArea.style.cssText = 'padding:2rem;font-family:Inter,sans-serif;color:#0f172a;';

      var html = '<div class="matrix-print-title" style="text-align:center;font-size:1.5rem;font-weight:700;margin-bottom:0.5rem;">' + (toolName || 'Matrix') + ' Worksheet</div>';
      html += '<div class="matrix-print-info" style="text-align:center;color:#64748b;margin-bottom:1.5rem;font-size:0.875rem;">' + new Date().toLocaleDateString() + ' &nbsp;|&nbsp; 8gwifi.org</div>';

      if (hasResult || hasSteps) {
        for (var j = 0; j < resultCards.length; j++) {
          var r = resultCards[j].cloneNode(true);
          r.querySelectorAll('button').forEach(function (b) { b.remove(); });
          html += '<div class="matrix-print-result">' + r.innerHTML + '</div>';
        }
        if (hasSteps && stepsEl) {
          var stepsCard = stepsEl.closest(cardClass);
          if (stepsCard) {
            var s = stepsCard.cloneNode(true);
            s.querySelectorAll('button').forEach(function (b) { b.remove(); });
            html += '<div class="matrix-print-steps" style="margin-top:2rem;">' + s.innerHTML + '</div>';
          }
        }
      }

      html += generateExerciseProblems(exerciseType, exerciseCount);

      html += '<div class="matrix-print-footer" style="text-align:center;color:#94a3b8;font-size:0.8rem;margin-top:2rem;">Generated by 8gwifi.org</div>';

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

  /* ── Public API ── */
  window.MatrixUtils = {
    EPS: EPS,
    initMathJax: initMathJax,
    rerender: rerender,
    parseMatrix: parseMatrix,
    cloneMatrix: cloneMatrix,
    smartFormat: smartFormat,
    formatMatrix: formatMatrix,
    createIdentity: createIdentity,
    multiply: multiply,
    transpose: transpose,
    shareURL: shareURL,
    downloadImage: downloadImage,
    loadFromURL: loadFromURL,
    printWorksheet: printWorksheet
  };
})();
