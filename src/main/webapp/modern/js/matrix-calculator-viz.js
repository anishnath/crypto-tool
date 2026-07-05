/**
 * Matrix geometric visualization (Plotly unit square / unit cube overlays).
 * Shared by Math AI chat; same logic as the Matrix Calculator Visualize tab.
 * Requires MatrixCalculatorCore (load matrix-calculator-core.js first).
 */
(function () {
  'use strict';

  function core() {
    return typeof window !== 'undefined' ? window.MatrixCalculatorCore : null;
  }

  var VISUALIZABLE_OPS = ['determinant', 'inverse', 'transpose', 'eigenvectors',
    'power', 'multiply', 'add', 'subtract'];

  var COLORS = {
    unit: '#94a3b8',
    primary: '#15803d',
    flip: '#dc2626',
    b: '#0891b2',
    sum: '#7c3aed',
    eig1: '#ea580c',
    eig2: '#0891b2',
  };

  var CUBE_FACES = [
    [0, 1, 2], [0, 2, 3],
    [4, 5, 6], [4, 6, 7],
    [0, 1, 5], [0, 5, 4],
    [3, 2, 6], [3, 6, 7],
    [1, 2, 6], [1, 6, 5],
    [0, 3, 7], [0, 7, 4],
  ];
  var CUBE_EDGES = [
    [0, 1], [1, 2], [2, 3], [3, 0],
    [4, 5], [5, 6], [6, 7], [7, 4],
    [0, 4], [1, 5], [2, 6], [3, 7],
  ];

  function isNumericCells(cells) {
    var c = core();
    if (c && c.isNumericCells) return c.isNumericCells(cells);
    if (!cells || !cells.length) return false;
    var numRe = /^-?\d*\.?\d+(?:[eE][+-]?\d+)?$/;
    for (var i = 0; i < cells.length; i++) {
      var row = cells[i];
      if (!row || !row.length) return false;
      for (var j = 0; j < row.length; j++) {
        var s = (row[j] || '').trim();
        if (!numRe.test(s)) return false;
        if (!isFinite(parseFloat(s))) return false;
      }
    }
    return true;
  }

  function cellsToMatrix(cells) {
    var c = core();
    if (c && c.cellsToNumericMatrix) return c.cellsToNumericMatrix(cells);
    return cells.map(function (row) {
      return row.map(function (cell) { return parseFloat(cell); });
    });
  }

  function isBinaryOp(op) {
    var c = core();
    return !!(c && c.OPS && c.OPS[op] && c.OPS[op].binary);
  }

  function canVisualize(op, cellsA, cellsB) {
    if (VISUALIZABLE_OPS.indexOf(op) === -1) return false;
    if (!cellsA) return false;
    var rows = cellsA.length;
    var cols = cellsA[0] ? cellsA[0].length : 0;
    if (rows !== cols) return false;
    if (rows !== 2 && rows !== 3) return false;
    if (op === 'eigenvectors' && rows === 3) return false;
    if (!isNumericCells(cellsA)) return false;
    if (isBinaryOp(op)) {
      if (!cellsB || !isNumericCells(cellsB)) return false;
      if (cellsB.length !== rows || cellsB[0].length !== cols) return false;
    }
    return true;
  }

  function applyMat(M, vec) {
    var n = M.length;
    var out = new Array(n);
    for (var i = 0; i < n; i++) {
      var s = 0;
      for (var j = 0; j < n; j++) s += M[i][j] * vec[j];
      out[i] = s;
    }
    return out;
  }

  function transformPath(M, path) {
    var c = core();
    if (c && c.transformPath) return c.transformPath(M, path);
    return path.map(function (p) { return applyMat(M, p); });
  }

  function unitSquare() {
    var c = core();
    if (c && c.unitSquare) return c.unitSquare();
    return [[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]];
  }

  function unitCubeVerts() {
    return [[0, 0, 0], [1, 0, 0], [1, 1, 0], [0, 1, 0],
      [0, 0, 1], [1, 0, 1], [1, 1, 1], [0, 1, 1]];
  }

  function det2(M) {
    var c = core();
    if (c && c.det2) return c.det2(M);
    return M[0][0] * M[1][1] - M[0][1] * M[1][0];
  }

  function det3(M) {
    return M[0][0] * (M[1][1] * M[2][2] - M[1][2] * M[2][1])
      - M[0][1] * (M[1][0] * M[2][2] - M[1][2] * M[2][0])
      + M[0][2] * (M[1][0] * M[2][1] - M[1][1] * M[2][0]);
  }

  function inv2(M) {
    var c = core();
    if (c && c.inv2) return c.inv2(M);
    var d = det2(M);
    if (Math.abs(d) < 1e-12) return null;
    return [[M[1][1] / d, -M[0][1] / d], [-M[1][0] / d, M[0][0] / d]];
  }

  function inv3(M) {
    var d = det3(M);
    if (Math.abs(d) < 1e-12) return null;
    function cof(i, j) {
      var rs = [0, 1, 2].filter(function (r) { return r !== i; });
      var cs = [0, 1, 2].filter(function (s) { return s !== j; });
      var m = [[M[rs[0]][cs[0]], M[rs[0]][cs[1]]],
        [M[rs[1]][cs[0]], M[rs[1]][cs[1]]]];
      return ((i + j) % 2 === 0 ? 1 : -1) * det2(m);
    }
    var out = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) out[i][j] = cof(j, i) / d;
    }
    return out;
  }

  function combine(A, B, op) {
    var c = core();
    if (c && c.combine) return c.combine(A, B, op);
    var n = A.length;
    var C = [];
    for (var i = 0; i < n; i++) {
      var r = [];
      for (var j = 0; j < n; j++) {
        r.push(op === 'add' ? A[i][j] + B[i][j] : A[i][j] - B[i][j]);
      }
      C.push(r);
    }
    return C;
  }

  function eigen2(A) {
    var c = core();
    if (c && c.eigen2) return c.eigen2(A);
    var a = A[0][0];
    var b = A[0][1];
    var c21 = A[1][0];
    var d = A[1][1];
    var tr = a + d;
    var det = a * d - b * c21;
    var disc = tr * tr - 4 * det;
    if (disc < 0) return null;
    var s = Math.sqrt(disc);
    var lams = [(tr + s) / 2, (tr - s) / 2];
    function vecFor(lam) {
      var v;
      if (Math.abs(b) > 1e-10) v = [b, lam - a];
      else if (Math.abs(c21) > 1e-10) v = [lam - d, c21];
      else v = (Math.abs(lam - a) < 1e-10) ? [1, 0] : [0, 1];
      var nrm = Math.sqrt(v[0] * v[0] + v[1] * v[1]) || 1;
      return [v[0] / nrm, v[1] / nrm];
    }
    return { values: lams, vectors: [vecFor(lams[0]), vecFor(lams[1])] };
  }

  function trace2DPath(path, name, color, opts) {
    opts = opts || {};
    return {
      x: path.map(function (p) { return p[0]; }),
      y: path.map(function (p) { return p[1]; }),
      mode: 'lines',
      name: name,
      line: { color: color, width: opts.width || 3, dash: opts.dash || 'solid' },
      fill: opts.nofill ? 'none' : 'toself',
      fillcolor: opts.fill || (color + '33'),
      hoverinfo: 'name',
    };
  }

  function trace2DArrow(p0, p1, name, color) {
    return {
      x: [p0[0], p1[0]],
      y: [p0[1], p1[1]],
      mode: 'lines+markers',
      name: name,
      line: { color: color, width: 4 },
      marker: { size: [0, 12], color: color, symbol: 'arrow', angleref: 'previous' },
      hoverinfo: 'name',
    };
  }

  function build2DTraces(op, A, B, n) {
    var sq = unitSquare();
    var traces = [];
    traces.push(trace2DPath(sq, 'Unit square', COLORS.unit,
      { dash: 'dot', width: 2, fill: 'rgba(148,163,184,0.10)' }));

    if (op === 'determinant' || op === 'transpose' || op === 'eigenvectors') {
      var Asq = transformPath(A, sq);
      var d = det2(A);
      var primary = (op === 'determinant' && d < 0) ? COLORS.flip : COLORS.primary;
      traces.push(trace2DPath(Asq, 'A applied', primary, { fill: primary + '40' }));
      if (op === 'transpose') {
        var At = [[A[0][0], A[1][0]], [A[0][1], A[1][1]]];
        traces.push(trace2DPath(transformPath(At, sq), 'A^T applied', COLORS.b,
          { dash: 'dash', fill: COLORS.b + '30' }));
      }
      if (op === 'eigenvectors') {
        var eig = eigen2(A);
        if (eig) {
          eig.vectors.forEach(function (v, i) {
            var color = i === 0 ? COLORS.eig1 : COLORS.eig2;
            var lam = eig.values[i];
            traces.push(trace2DArrow([0, 0], [v[0] * 1.5, v[1] * 1.5],
              'v' + (i + 1) + '  (λ = ' + lam.toFixed(2) + ')', color));
            traces.push({
              x: [0, v[0] * lam * 1.5],
              y: [0, v[1] * lam * 1.5],
              mode: 'lines',
              name: 'A v' + (i + 1) + ' = λ v' + (i + 1),
              line: { color: color, width: 2, dash: 'dot' },
              hoverinfo: 'name',
              showlegend: false,
            });
          });
        } else {
          traces.push({
            x: [0], y: [0],
            mode: 'text',
            text: ['\u00A0\u00A0\u00A0\u00A0(complex eigenvalues — no real eigenvectors to draw)'],
            textposition: 'middle right',
            textfont: { size: 12, color: COLORS.flip },
            name: 'Complex eigenvalues',
            hoverinfo: 'text',
            showlegend: false,
          });
        }
      }
    } else if (op === 'inverse') {
      traces.push(trace2DPath(transformPath(A, sq), 'A applied', COLORS.primary,
        { fill: COLORS.primary + '40' }));
      var Ainv = inv2(A);
      if (Ainv) {
        traces.push(trace2DPath(transformPath(Ainv, sq), 'A^{-1} applied', COLORS.flip,
          { dash: 'dash', fill: COLORS.flip + '20' }));
      }
    } else if (op === 'multiply') {
      var Bsq = transformPath(B, sq);
      traces.push(trace2DPath(Bsq, 'B applied', COLORS.b, { dash: 'dash', fill: COLORS.b + '30' }));
      traces.push(trace2DPath(transformPath(A, Bsq), '(A B) applied', COLORS.primary,
        { fill: COLORS.primary + '40' }));
    } else if (op === 'add' || op === 'subtract') {
      traces.push(trace2DPath(transformPath(A, sq), 'A applied', COLORS.primary,
        { width: 2, fill: COLORS.primary + '20' }));
      traces.push(trace2DPath(transformPath(B, sq), 'B applied', COLORS.b,
        { width: 2, fill: COLORS.b + '20' }));
      traces.push(trace2DPath(transformPath(combine(A, B, op), sq),
        (op === 'add' ? '(A+B)' : '(A−B)') + ' applied', COLORS.sum,
        { width: 3, fill: COLORS.sum + '40' }));
    } else if (op === 'power') {
      var k;
      var current = sq.slice();
      var absN = Math.min(Math.abs(n || 0), 4);
      for (k = 1; k <= absN; k++) {
        current = transformPath(A, current);
        var alpha = Math.round((0.18 + (k / absN) * 0.30) * 255).toString(16).padStart(2, '0');
        traces.push(trace2DPath(current, 'A^' + k + ' applied',
          COLORS.primary, { width: 2 + Math.min(k, 2), fill: COLORS.primary + alpha }));
      }
      if (absN === 0) {
        traces.push(trace2DPath(sq, 'A^0 = I (= unit square)', COLORS.primary,
          { fill: COLORS.primary + '40' }));
      }
    }
    return traces;
  }

  function layout2D() {
    return {
      autosize: true,
      margin: { l: 40, r: 20, t: 30, b: 50 },
      xaxis: {
        scaleanchor: 'y',
        scaleratio: 1,
        zeroline: true,
        zerolinecolor: '#cbd5e1',
        zerolinewidth: 1,
        gridcolor: '#e2e8f0',
      },
      yaxis: {
        zeroline: true,
        zerolinecolor: '#cbd5e1',
        zerolinewidth: 1,
        gridcolor: '#e2e8f0',
      },
      showlegend: true,
      legend: { orientation: 'h', y: -0.12 },
      hovermode: 'closest',
      plot_bgcolor: '#ffffff',
      paper_bgcolor: 'transparent',
    };
  }

  function transformedCube(M) {
    return unitCubeVerts().map(function (v) { return applyMat(M, v); });
  }

  function trace3DMesh(verts, name, color, opacity) {
    return {
      type: 'mesh3d',
      x: verts.map(function (v) { return v[0]; }),
      y: verts.map(function (v) { return v[1]; }),
      z: verts.map(function (v) { return v[2]; }),
      i: CUBE_FACES.map(function (f) { return f[0]; }),
      j: CUBE_FACES.map(function (f) { return f[1]; }),
      k: CUBE_FACES.map(function (f) { return f[2]; }),
      opacity: opacity,
      color: color,
      name: name,
      showlegend: true,
      hoverinfo: 'name',
      flatshading: true,
    };
  }

  function trace3DEdges(verts, color) {
    var xs = [];
    var ys = [];
    var zs = [];
    CUBE_EDGES.forEach(function (e) {
      xs.push(verts[e[0]][0], verts[e[1]][0], null);
      ys.push(verts[e[0]][1], verts[e[1]][1], null);
      zs.push(verts[e[0]][2], verts[e[1]][2], null);
    });
    return {
      type: 'scatter3d',
      mode: 'lines',
      x: xs,
      y: ys,
      z: zs,
      line: { color: color, width: 4 },
      showlegend: false,
      hoverinfo: 'skip',
    };
  }

  function build3DTraces(op, A, B, n) {
    var verts0 = unitCubeVerts();
    var traces = [];
    traces.push(trace3DMesh(verts0, 'Unit cube', COLORS.unit, 0.10));
    traces.push(trace3DEdges(verts0, COLORS.unit));

    if (op === 'determinant' || op === 'transpose') {
      var At = transformedCube(A);
      var primary = (op === 'determinant' && det3(A) < 0) ? COLORS.flip : COLORS.primary;
      traces.push(trace3DMesh(At, 'A applied', primary, 0.30));
      traces.push(trace3DEdges(At, primary));
      if (op === 'transpose') {
        var Atrans = [[A[0][0], A[1][0], A[2][0]],
          [A[0][1], A[1][1], A[2][1]],
          [A[0][2], A[1][2], A[2][2]]];
        var Att = transformedCube(Atrans);
        traces.push(trace3DMesh(Att, 'A^T applied', COLORS.b, 0.20));
        traces.push(trace3DEdges(Att, COLORS.b));
      }
    } else if (op === 'inverse') {
      var At2 = transformedCube(A);
      traces.push(trace3DMesh(At2, 'A applied', COLORS.primary, 0.25));
      traces.push(trace3DEdges(At2, COLORS.primary));
      var Ainv3 = inv3(A);
      if (Ainv3) {
        var Ainvt = transformedCube(Ainv3);
        traces.push(trace3DMesh(Ainvt, 'A^{-1} applied', COLORS.flip, 0.15));
        traces.push(trace3DEdges(Ainvt, COLORS.flip));
      }
    } else if (op === 'multiply') {
      var Bt = transformedCube(B);
      var ABv = Bt.map(function (v) { return applyMat(A, v); });
      traces.push(trace3DMesh(Bt, 'B applied', COLORS.b, 0.18));
      traces.push(trace3DEdges(Bt, COLORS.b));
      traces.push(trace3DMesh(ABv, '(A B) applied', COLORS.primary, 0.30));
      traces.push(trace3DEdges(ABv, COLORS.primary));
    } else if (op === 'add' || op === 'subtract') {
      traces.push(trace3DMesh(transformedCube(A), 'A applied', COLORS.primary, 0.15));
      traces.push(trace3DMesh(transformedCube(B), 'B applied', COLORS.b, 0.15));
      var Ct3 = transformedCube(combine(A, B, op));
      traces.push(trace3DMesh(Ct3, (op === 'add' ? '(A+B)' : '(A−B)') + ' applied', COLORS.sum, 0.30));
      traces.push(trace3DEdges(Ct3, COLORS.sum));
    } else if (op === 'power') {
      var absN = Math.min(Math.abs(n || 0), 3);
      var current = unitCubeVerts();
      for (var k = 1; k <= absN; k++) {
        current = current.map(function (v) { return applyMat(A, v); });
        traces.push(trace3DMesh(current, 'A^' + k + ' applied',
          COLORS.primary, 0.15 + (k / absN) * 0.20));
        traces.push(trace3DEdges(current, COLORS.primary));
      }
    }
    return traces;
  }

  function layout3D() {
    return {
      autosize: true,
      margin: { l: 0, r: 0, t: 30, b: 0 },
      scene: {
        xaxis: { title: 'x', backgroundcolor: '#fafafa' },
        yaxis: { title: 'y', backgroundcolor: '#fafafa' },
        zaxis: { title: 'z', backgroundcolor: '#fafafa' },
        aspectmode: 'data',
        camera: { eye: { x: 1.6, y: 1.6, z: 1.2 } },
      },
      showlegend: true,
      legend: { orientation: 'h', y: -0.05 },
      paper_bgcolor: 'transparent',
    };
  }

  function makeCaption(op, A) {
    var det = A.length === 2 ? det2(A) : det3(A);
    switch (op) {
      case 'determinant':
        return 'Shaded ' + (A.length === 2 ? 'parallelogram' : 'parallelepiped')
          + ' = image of the unit ' + (A.length === 2 ? 'square' : 'cube')
          + ' under A. Signed ' + (A.length === 2 ? 'area' : 'volume')
          + ' = det A = ' + det.toFixed(4)
          + (det < 0 ? ' — negative means orientation is reversed.' : '.');
      case 'inverse':
        return 'A applied (solid) and A⁻¹ applied (dashed). A⁻¹ undoes A.';
      case 'transpose':
        return 'Image under A (solid) vs. under Aᵀ (dashed). Same signed '
          + (A.length === 2 ? 'area' : 'volume') + ' since det(Aᵀ) = det(A).';
      case 'eigenvectors':
        return 'Coloured arrows are eigenvectors — directions A leaves invariant.';
      case 'power':
        return 'Successive applications of A (capped at '
          + (A.length === 2 ? '4' : '3') + ' frames for readability).';
      case 'multiply':
        return 'B applied first (dashed), then A (solid) = (AB) on the unit '
          + (A.length === 2 ? 'square' : 'cube') + '.';
      case 'add':
      case 'subtract':
        return 'A applied, B applied, and (' + (op === 'add' ? 'A+B' : 'A−B')
          + ') applied to the unit shape.';
      default:
        return '';
    }
  }

  function applyDarkTheme(layout, isDark) {
    if (!isDark || !layout) return layout;
    var out = JSON.parse(JSON.stringify(layout));
    if (out.xaxis) {
      out.xaxis.gridcolor = '#334155';
      out.xaxis.zerolinecolor = '#475569';
      out.xaxis.color = '#cbd5e1';
    }
    if (out.yaxis) {
      out.yaxis.gridcolor = '#334155';
      out.yaxis.zerolinecolor = '#475569';
      out.yaxis.color = '#cbd5e1';
    }
    out.plot_bgcolor = '#1e293b';
    out.paper_bgcolor = 'transparent';
    out.font = { family: 'Inter, sans-serif', size: 11, color: '#cbd5e1' };
    if (out.legend) out.legend.font = { size: 10, color: '#cbd5e1' };
    if (out.scene) {
      ['xaxis', 'yaxis', 'zaxis'].forEach(function (ax) {
        if (out.scene[ax]) {
          out.scene[ax].backgroundcolor = '#1e293b';
          out.scene[ax].gridcolor = '#334155';
          out.scene[ax].color = '#cbd5e1';
        }
      });
    }
    return out;
  }

  function buildPlotlyPlot(taskOrParsed) {
    var c = core();
    if (!c) return null;

    var parsed = taskOrParsed;
    if (taskOrParsed && (taskOrParsed.matrixA || taskOrParsed.raw
      || (taskOrParsed.op && !taskOrParsed.cellsA))) {
      parsed = c.parseTask ? c.parseTask(taskOrParsed) : null;
    }
    if (!parsed || !canVisualize(parsed.op, parsed.cellsA, parsed.cellsB)) return null;

    var A = cellsToMatrix(parsed.cellsA);
    var B = (parsed.cellsB && isBinaryOp(parsed.op)) ? cellsToMatrix(parsed.cellsB) : null;
    var dim = A.length;
    var n = parsed.n;

    return {
      traces: dim === 2 ? build2DTraces(parsed.op, A, B, n) : build3DTraces(parsed.op, A, B, n),
      layout: dim === 2 ? layout2D() : layout3D(),
      caption: makeCaption(parsed.op, A),
      dim: dim,
      op: parsed.op,
    };
  }

  function canVisualizeTask(task) {
    var c = core();
    if (!c || !c.parseTask) return false;
    var parsed = c.parseTask(task);
    if (!parsed) return false;
    return canVisualize(parsed.op, parsed.cellsA, parsed.cellsB);
  }

  function attach() {
    var c = core();
    if (!c) return;
    c.canVisualize = canVisualize;
    c.canVisualizeTask = canVisualizeTask;
    c.buildPlotlyPlot = buildPlotlyPlot;
    c.applyMatrixPlotDarkTheme = applyDarkTheme;
  }

  attach();
})();
