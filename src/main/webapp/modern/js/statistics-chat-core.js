/**
 * Statistics chat engine — descriptive stats, z-score, normal CDF, percentiles.
 * Requires StatsCommon + StatsGraph (jStat lazy-loaded for normal distribution).
 */
(function statisticsChatCoreModule() {
  'use strict';

  const MODES = new Set(['descriptive', 'zscore', 'normal', 'percentile', 'ttest', 'correlation']);

  function C() { return typeof window !== 'undefined' ? window.StatsCommon : null; }
  function G() { return typeof window !== 'undefined' ? window.StatsGraph : null; }

  function normalizeMode(raw) {
    let m = String(raw || 'descriptive').toLowerCase().replace(/\s+/g, '_');
    if (m === 'z-score' || m === 'z_score') m = 'zscore';
    if (m === 'summary' || m === 'describe') m = 'descriptive';
    if (m === 't-test' || m === 't_test' || m === 'ttest') m = 'ttest';
    if (m === 'corr' || m === 'pearson' || m === 'r') m = 'correlation';
    return MODES.has(m) ? m : 'descriptive';
  }

  function parseLines(text) {
    if (!text || !String(text).trim()) return [];
    return String(text).trim().split(/[\n]+/).map((s) => parseFloat(s.trim())).filter((n) => !isNaN(n) && isFinite(n));
  }

  function mean(arr) {
    if (!arr.length) return NaN;
    let s = 0;
    for (let i = 0; i < arr.length; i++) s += arr[i];
    return s / arr.length;
  }

  function sampleSd(arr) {
    if (arr.length < 2) return NaN;
    const m = mean(arr);
    let ss = 0;
    for (let i = 0; i < arr.length; i++) ss += (arr[i] - m) * (arr[i] - m);
    return Math.sqrt(ss / (arr.length - 1));
  }

  function tPValue(t, df, tail) {
    if (!window.jStat?.studentt?.cdf) return NaN;
    const cdf = window.jStat.studentt.cdf(t, df);
    if (tail === 'two') return 2 * (1 - window.jStat.studentt.cdf(Math.abs(t), df));
    if (tail === 'right') return 1 - cdf;
    return cdf;
  }

  function num(val) {
    if (val == null || val === '') return NaN;
    const n = parseFloat(String(val).replace(/,/g, ''));
    return Number.isFinite(n) ? n : NaN;
  }

  function loadJStatAsync() {
    return new Promise((resolve) => {
      if (window.jStat) { resolve(window.jStat); return; }
      const graph = G();
      if (graph?.loadJStat) graph.loadJStat(() => resolve(window.jStat || null));
      else resolve(null);
    });
  }

  function fmt(n, dp) {
    const c = C();
    return c ? c.fmt(n, dp) : String(n);
  }

  function solveDescriptive(task, withSteps) {
    const c = C();
    if (!c) return { ok: false, error: 'StatsCommon not loaded.' };

    const raw = String(task.data || task.expr || task.text || '').trim();
    const arr = c.parseNumbers(raw);
    if (!arr.length) {
      return { ok: false, error: 'Enter comma- or space-separated numbers in data:' };
    }

    const pop = /population|pop|sigma/.test(String(task.population || task.varianceType || task.sample || '').toLowerCase());
    const desc = c.computeDescriptive(arr);
    if (!desc) return { ok: false, error: 'Could not compute descriptive statistics.' };

    const sd = pop ? desc.sdPop : desc.sd;
    const variance = pop ? desc.variancePop : desc.variance;
    const sdLabel = pop ? '\\sigma' : 's';
    const varLabel = pop ? '\\sigma^2' : 's^2';

    const resultLatex = `n=${desc.n},\\; \\bar{x}=${fmt(desc.mean)},\\; \\tilde{x}=${fmt(desc.median)},\\; ${sdLabel}=${fmt(sd)},\\; ${varLabel}=${fmt(variance)}`;
    const resultText = [
      `n = ${desc.n}`,
      `Mean = ${fmt(desc.mean)}`,
      `Median = ${fmt(desc.median)}`,
      `Mode: ${desc.mode.description}`,
      `${pop ? 'Population' : 'Sample'} SD = ${fmt(sd)}`,
      `${pop ? 'Population' : 'Sample'} variance = ${fmt(variance)}`,
      `Min = ${fmt(desc.min)}, Max = ${fmt(desc.max)}, Range = ${fmt(desc.range)}`,
      `SEM = ${fmt(desc.sem)}, CV = ${fmt(desc.cv)}%`,
    ].join('\n');

    const steps = withSteps ? [
      { title: 'Count & sum', latex: `n=${desc.n},\\; \\sum x_i=${fmt(desc.sum)}` },
      { title: 'Mean', latex: `\\bar{x}=\\frac{\\sum x_i}{n}=${fmt(desc.mean)}` },
      { title: 'Median', latex: `\\tilde{x}=${fmt(desc.median)}` },
      { title: pop ? 'Population variance' : 'Sample variance (Bessel)', latex: `${varLabel}=${fmt(variance)}` },
      { title: 'Standard deviation', latex: `${sdLabel}=\\sqrt{${varLabel}}=${fmt(sd)}` },
    ] : [];

    const quarts = c.computeQuartiles(desc.sorted);
    const graphInput = arr.length >= 2 ? {
      graphType: 'histogram',
      freqDist: c.computeFrequencyDist(desc.sorted),
      mean: desc.mean,
      sd,
      n: desc.n,
      quarts,
    } : undefined;

    return {
      ok: true,
      action: 'statistics',
      kind: 'descriptive',
      resultLatex,
      resultText,
      method: pop ? 'Descriptive statistics (population)' : 'Descriptive statistics (sample)',
      steps,
      input: graphInput,
    };
  }

  function solveZScore(task, withSteps) {
    const x = num(task.x ?? task.value ?? task.score);
    const mu = num(task.mean ?? task.mu ?? task.populationMean);
    const sd = num(task.sd ?? task.sigma ?? task.stddev ?? task.populationSd);
    if (!Number.isFinite(x) || !Number.isFinite(mu) || !Number.isFinite(sd) || sd <= 0) {
      return { ok: false, error: 'z-score needs x, mean (μ), and sd (σ > 0).' };
    }
    const z = (x - mu) / sd;
    const resultLatex = `z=\\frac{${fmt(x)}-${fmt(mu)}}{${fmt(sd)}}=${fmt(z)}`;

    const steps = withSteps ? [
      { title: 'Standardize', latex: `z=\\frac{x-\\mu}{\\sigma}` },
      { title: 'Substitute', latex: `z=\\frac{${fmt(x)}-${fmt(mu)}}{${fmt(sd)}}` },
      { title: 'Result', latex: `z=${fmt(z)}` },
    ] : [];

    return {
      ok: true,
      action: 'statistics',
      kind: 'zscore',
      resultLatex,
      method: 'Z-score standardization',
      steps,
      z,
      mu,
      sd,
      x,
      input: {
        graphType: 'normal',
        mean: mu,
        sd,
        shadeZ: z,
        title: `Z-score: x=${fmt(x)}, z=${fmt(z)}`,
      },
      needsJStat: true,
    };
  }

  async function finishZScoreWithJStat(base) {
    const js = await loadJStatAsync();
    if (!js?.normal?.cdf) {
      return { ...base, resultText: base.resultLatex.replace(/\\/g, '') };
    }
    const p = js.normal.cdf(base.z, 0, 1);
    const pct = p * 100;
    const resultText = `P(Z < ${fmt(base.z)}) = ${fmt(p, 4)} (${fmt(pct, 2)}%)\nP(Z > ${fmt(base.z)}) = ${fmt(1 - p, 4)}`;
    const resultLatex = `${base.resultLatex},\\; P(Z<z)=${fmt(p, 4)}`;
    return { ...base, resultLatex, resultText };
  }

  async function solveNormal(task, withSteps) {
    const js = await loadJStatAsync();
    if (!js?.normal?.cdf) {
      return { ok: false, error: 'jStat not loaded for normal distribution.' };
    }

    const mu = num(task.mean ?? task.mu ?? 0);
    const sd = num(task.sd ?? task.sigma ?? task.stddev ?? 1);
    if (!Number.isFinite(sd) || sd <= 0) {
      return { ok: false, error: 'Normal mode needs σ > 0 (default μ=0, σ=1).' };
    }

    const zDirect = num(task.z);
    const xVal = num(task.x ?? task.value);
    const z = Number.isFinite(zDirect) ? zDirect : (Number.isFinite(xVal) ? (xVal - mu) / sd : NaN);
    if (!Number.isFinite(z)) {
      return { ok: false, error: 'normal mode needs z: or x: (with mean/sd).' };
    }

    const pLess = js.normal.cdf(z, 0, 1);
    const xAtZ = mu + z * sd;
    const resultLatex = `P(X \\le ${fmt(xAtZ)}) = P(Z \\le ${fmt(z)}) = ${fmt(pLess, 4)}`;
    const steps = withSteps ? [
      { title: 'Standardize', latex: `z=\\frac{x-\\mu}{\\sigma}=\\frac{${fmt(xAtZ)}-${fmt(mu)}}{${fmt(sd)}}=${fmt(z)}` },
      { title: 'Normal CDF', latex: `P(Z \\le ${fmt(z)}) = ${fmt(pLess, 4)}` },
    ] : [];

    return {
      ok: true,
      action: 'statistics',
      kind: 'normal',
      resultLatex,
      resultText: `P(Z ≤ ${fmt(z)}) = ${fmt(pLess, 4)} (${fmt(pLess * 100, 2)}%)`,
      method: `Normal distribution (μ=${fmt(mu)}, σ=${fmt(sd)})`,
      steps,
      input: {
        graphType: 'normal',
        mean: mu,
        sd,
        shadeZ: z,
        title: `P(Z ≤ ${fmt(z)}) = ${fmt(pLess, 4)}`,
      },
    };
  }

  async function solveTTest(task, withSteps) {
    const js = await loadJStatAsync();
    if (!js?.studentt?.cdf) {
      return { ok: false, error: 'jStat not loaded for t-test.' };
    }

    const c = C();
    const variant = String(task.ttestType || task.variant || task.test || 'one').toLowerCase();
    const alpha = num(task.alpha) || 0.05;
    const tail = String(task.tail || 'two').toLowerCase();
    const mu0 = num(task.mu0 ?? task.mu ?? task.h0);

    if (variant === 'one' || variant === 'one_sample' || variant === 'one-sample') {
      const data = c ? c.parseNumbers(String(task.data || task.sample || '')) : [];
      if (data.length < 2) return { ok: false, error: 'ttest (one-sample) needs data: with at least 2 values.' };
      if (!Number.isFinite(mu0)) return { ok: false, error: 'ttest needs mu0: (hypothesized mean).' };
      const n = data.length;
      const xbar = mean(data);
      const s = sampleSd(data);
      const se = s / Math.sqrt(n);
      const t = (xbar - mu0) / se;
      const df = n - 1;
      const p = tPValue(t, df, tail);
      const resultLatex = `t=\\frac{\\bar{x}-\\mu_0}{s/\\sqrt{n}}=\\frac{${fmt(xbar)}-${fmt(mu0)}}{${fmt(se)}}=${fmt(t)},\\; df=${df},\\; p=${fmt(p, 4)}`;
      const resultText = [
        `n = ${n}, x̄ = ${fmt(xbar)}, s = ${fmt(s)}`,
        `t = ${fmt(t)}, df = ${df}`,
        `p-value (${tail}-tailed) = ${fmt(p, 4)}`,
        p < alpha ? `Reject H₀ at α = ${alpha}` : `Fail to reject H₀ at α = ${alpha}`,
      ].join('\n');
      const steps = withSteps ? [
        { title: 'Sample mean & SD', latex: `\\bar{x}=${fmt(xbar)},\\; s=${fmt(s)},\\; n=${n}` },
        { title: 'Test statistic', latex: `t=\\frac{${fmt(xbar)}-${fmt(mu0)}}{${fmt(s)}/\\sqrt{${n}}}=${fmt(t)}` },
        { title: 'p-value', latex: `p=${fmt(p, 4)}` },
      ] : [];
      return {
        ok: true,
        action: 'statistics',
        kind: 'ttest',
        resultLatex,
        resultText,
        method: 'One-sample t-test',
        steps,
      };
    }

    const d1 = c ? c.parseNumbers(String(task.data1 || task.sample1 || task.group1 || '')) : [];
    const d2 = c ? c.parseNumbers(String(task.data2 || task.sample2 || task.group2 || '')) : [];
    if (d1.length < 2 || d2.length < 2) {
      return { ok: false, error: 'ttest (two-sample) needs data1: and data2: with at least 2 values each.' };
    }
    const n1 = d1.length;
    const n2 = d2.length;
    const x1 = mean(d1);
    const x2 = mean(d2);
    const s1 = sampleSd(d1);
    const s2 = sampleSd(d2);
    const pooledVar = ((n1 - 1) * s1 * s1 + (n2 - 1) * s2 * s2) / (n1 + n2 - 2);
    const se = Math.sqrt(pooledVar * (1 / n1 + 1 / n2));
    const t = (x1 - x2) / se;
    const df = n1 + n2 - 2;
    const p = tPValue(t, df, tail);
    const resultLatex = `t=\\frac{\\bar{x}_1-\\bar{x}_2}{s_p\\sqrt{1/n_1+1/n_2}}=${fmt(t)},\\; df=${df},\\; p=${fmt(p, 4)}`;
    const resultText = [
      `Sample 1: n=${n1}, x̄=${fmt(x1)}, s=${fmt(s1)}`,
      `Sample 2: n=${n2}, x̄=${fmt(x2)}, s=${fmt(s2)}`,
      `t = ${fmt(t)}, df = ${df}, p = ${fmt(p, 4)} (${tail}-tailed)`,
    ].join('\n');
    const steps = withSteps ? [
      { title: 'Group means', latex: `\\bar{x}_1=${fmt(x1)},\\; \\bar{x}_2=${fmt(x2)}` },
      { title: 'Pooled SE', latex: `SE=${fmt(se)}` },
      { title: 'Test statistic', latex: `t=${fmt(t)},\\; df=${df},\\; p=${fmt(p, 4)}` },
    ] : [];
    return {
      ok: true,
      action: 'statistics',
      kind: 'ttest',
      resultLatex,
      resultText,
      method: 'Two-sample t-test (equal variance)',
      steps,
    };
  }

  function pearsonCorr(x, y) {
    const n = Math.min(x.length, y.length);
    if (n < 2) return NaN;
    const mx = mean(x.slice(0, n));
    const my = mean(y.slice(0, n));
    let num = 0;
    let dx2 = 0;
    let dy2 = 0;
    for (let i = 0; i < n; i++) {
      const dx = x[i] - mx;
      const dy = y[i] - my;
      num += dx * dy;
      dx2 += dx * dx;
      dy2 += dy * dy;
    }
    return dx2 * dy2 === 0 ? 0 : num / Math.sqrt(dx2 * dy2);
  }

  async function solveCorrelation(task, withSteps) {
    const js = await loadJStatAsync();
    const c = C();
    let x = parseLines(task.x || task.xdata || task.dataX || '');
    let y = parseLines(task.y || task.ydata || task.dataY || '');
    if (!x.length && c) x = c.parseNumbers(String(task.data || ''));
    if (!y.length && task.ydata == null && task.dataY == null && task.y == null) {
      /* paired comma lists in data/data2 */
    }
    if (!y.length) y = parseLines(task.data2 || task.y || '');
    if (x.length && !y.length && String(task.y || '').includes(',')) {
      y = c ? c.parseNumbers(String(task.y)) : [];
    }
    if (x.length < 2 || y.length < 2) {
      return { ok: false, error: 'correlation needs x: and y: (newline or comma lists, same length ≥ 2).' };
    }
    const n = Math.min(x.length, y.length);
    x = x.slice(0, n);
    y = y.slice(0, n);
    const r = pearsonCorr(x, y);
    let p = NaN;
    if (js?.studentt?.cdf && n > 2 && Math.abs(r) < 1) {
      const t = r * Math.sqrt((n - 2) / (1 - r * r));
      p = 2 * (1 - js.studentt.cdf(Math.abs(t), n - 2));
    }
    const resultLatex = `r=\\frac{\\sum (x_i-\\bar{x})(y_i-\\bar{y})}{\\sqrt{\\sum(x_i-\\bar{x})^2\\sum(y_i-\\bar{y})^2}}=${fmt(r)}`;
    const resultText = [
      `n = ${n}`,
      `Pearson r = ${fmt(r)}`,
      Number.isFinite(p) ? `p-value (two-tailed) ≈ ${fmt(p, 4)}` : '',
    ].filter(Boolean).join('\n');
    const steps = withSteps ? [
      { title: 'Compute means', latex: `\\bar{x}=${fmt(mean(x))},\\; \\bar{y}=${fmt(mean(y))}` },
      { title: 'Pearson r', latex: `r=${fmt(r)}` },
    ] : [];
    return {
      ok: true,
      action: 'statistics',
      kind: 'correlation',
      resultLatex,
      resultText,
      method: 'Pearson correlation',
      steps,
      input: {
        graphType: 'scatter',
        x,
        y,
        r,
      },
    };
  }

  function solvePercentile(task, withSteps) {
    const c = C();
    if (!c) return { ok: false, error: 'StatsCommon not loaded.' };

    const raw = String(task.data || task.expr || '').trim();
    const arr = c.parseNumbers(raw);
    const p = num(task.percentile ?? task.p ?? task.percent);
    if (!arr.length) return { ok: false, error: 'percentile mode needs data: with numbers.' };
    if (!Number.isFinite(p) || p < 0 || p > 100) {
      return { ok: false, error: 'percentile needs p: between 0 and 100.' };
    }

    const sorted = arr.slice().sort((a, b) => a - b);
    const val = c.computePercentile(sorted, p);
    const resultLatex = `P_{${fmt(p, 1)}} = ${fmt(val)}`;
    const steps = withSteps ? [
      { title: 'Sort data', latex: `n=${sorted.length}` },
      { title: 'Percentile formula', latex: `P_{${fmt(p, 1)}} \\text{ (linear interpolation)}` },
      { title: 'Value', latex: `P_{${fmt(p, 1)}}=${fmt(val)}` },
    ] : [];

    return {
      ok: true,
      action: 'statistics',
      kind: 'percentile',
      resultLatex,
      method: `${fmt(p, 1)}th percentile`,
      steps,
      input: arr.length >= 2 ? {
        graphType: 'histogram',
        freqDist: c.computeFrequencyDist(sorted),
        percentile: p,
        percentileValue: val,
      } : undefined,
    };
  }

  async function solveTask(task, opts) {
    const withSteps = !!(opts && opts.withSteps);
    const mode = normalizeMode(task.mode || task.statMode);
    let r;

    if (mode === 'zscore') r = solveZScore(task, withSteps);
    else if (mode === 'normal') r = await solveNormal(task, withSteps);
    else if (mode === 'percentile') r = solvePercentile(task, withSteps);
    else if (mode === 'ttest') r = await solveTTest(task, withSteps);
    else if (mode === 'correlation') r = await solveCorrelation(task, withSteps);
    else r = solveDescriptive(task, withSteps);

    if (!r || !r.ok) return r;
    if (r.needsJStat) return finishZScoreWithJStat(r);
    return r;
  }

  function canGraphTask(task) {
    const mode = normalizeMode(task?.mode || task?.statMode);
    if (mode === 'descriptive' || mode === 'percentile') {
      const c = C();
      const arr = c ? c.parseNumbers(String(task?.data || task?.expr || '')) : [];
      return arr.length >= 2;
    }
    if (mode === 'zscore' || mode === 'normal') {
      const sd = num(task?.sd ?? task?.sigma ?? task?.stddev ?? 1);
      return Number.isFinite(sd) && sd > 0;
    }
    if (mode === 'correlation') {
      const x = parseLines(task?.x || task?.xdata || task?.dataX || '');
      const y = parseLines(task?.y || task?.ydata || task?.dataY || task?.data2 || '');
      return x.length >= 2 && y.length >= 2;
    }
    return false;
  }

  function renderGraphInChat(plotEl, input) {
    const graph = G();
    if (!plotEl || !input || !graph) {
      if (plotEl) plotEl.innerHTML = '<p class="vca-math-result-method">Stats graph module not loaded.</p>';
      return Promise.resolve(false);
    }

    const id = plotEl.id || ('stat-chat-plot-' + Date.now());
    if (!plotEl.id) plotEl.id = id;
    plotEl.style.minHeight = '280px';
    plotEl.style.width = '100%';

    return new Promise((resolve) => {
      const done = () => {
        try {
          if (input.graphType === 'histogram' && graph.renderHistogram) {
            graph.renderHistogram(id, input.freqDist, {
              title: 'Frequency histogram',
              normalOverlay: input.mean != null && input.sd > 0,
              mean: input.mean,
              sd: input.sd,
              n: input.n,
            });
            resolve(true);
          } else if (input.graphType === 'normal' && graph.renderNormalCurve) {
            graph.renderNormalCurve(id, input.mean, input.sd, {
              title: input.title || 'Normal distribution',
              shadeZ: input.shadeZ,
              shadeX: input.shadeX,
            });
            resolve(true);
          } else if (input.graphType === 'scatter' && graph.renderScatterPlot) {
            graph.renderScatterPlot(id, input.x, input.y, {
              title: `Scatter plot (r = ${input.r != null ? fmt(input.r) : '?'})`,
              regressionLine: true,
              xLabel: 'x',
              yLabel: 'y',
            });
            resolve(true);
          } else {
            resolve(false);
          }
        } catch (_) {
          resolve(false);
        }
      };

      if (typeof graph.loadPlotly === 'function') graph.loadPlotly(done);
      else if (typeof window.loadPlotly === 'function') window.loadPlotly(done);
      else done();
    });
  }

  window.StatisticsChatCore = {
    solveTask,
    canGraphTask,
    renderGraphInChat,
    normalizeMode,
  };
})();
