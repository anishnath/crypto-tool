<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- SEO Meta -->
<title>Mean, Median, Mode Finder — Paste Numbers, Outliers, Sorted List + Histogram</title>
<meta name="description" content="Paste numbers to instantly get mean, median, and mode with outlier detection, a sorted list, and a histogram. Perfect for stats homework and analysts.">
<meta name="keywords" content="mean median mode, average calculator, outlier detection, IQR, histogram, stats homework, statistics calculator, sorted list, descriptive statistics, median, mode, mean, visualize data">
<link rel="canonical" href="https://8gwifi.org/mean-median-mode.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Mean, Median, Mode Finder — With Outliers & Histogram">
<meta property="og:description" content="Paste your numbers and see mean, median, mode, outliers, sorted list and histogram.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/mean-median-mode.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Mean, Median, Mode Finder — With Outliers & Histogram">
<meta name="twitter:description" content="Fast stats: mean, median, mode, outliers, sorted list and histogram.">

<%@ include file="header-script.jsp"%>

<!-- Histogram removed; no external chart library needed -->

<style>
  .kap-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.6rem; font-weight: 800; text-align: center;
    padding: 0.75rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #60a5fa; text-shadow: 0 2px 12px rgba(59,130,246,0.45);
    letter-spacing: 0.15rem;
  }
  .hero-sub { text-align: center; margin-top: 0.5rem; color: #6b7280; }

  .controls { display:flex; flex-wrap:wrap; gap:0.5rem; align-items:center; margin:1rem 0; }
  .controls > * { margin-bottom:0.25rem; }
  .tiny { font-size:0.85rem; color:#6b7280; }
  .pill { display:inline-block; padding:0.35rem 0.6rem; border-radius:999px; font-size:0.9rem; }
  .pill-green{ background:#10b981; color:#0b1f17; font-weight:700; }
  .pill-gray{ background:#e5e7eb; color:#374151; font-weight:600; }

  .flex{ display:flex; } .justify-between{ justify-content:space-between; } .align-center{ align-items:center; }
  .gap-2{ gap:.5rem; }

  .input-pane { display:grid; grid-template-columns: 1fr; gap: .75rem; }
  .data-area { width: 100%; min-height: 140px; }

  .cards { display:grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin-top: .75rem; }
  .cardx {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px;
  }
  .cardx h6 { margin: 0 0 6px 0; font-weight: 700; color: #374151; }
  .big { font-size: 1.4rem; font-weight: 800; color: #111827; }

  .chips { display:flex; flex-wrap: wrap; gap: 6px; margin-top: .5rem; }
  .chip {
    display:inline-flex; align-items:center; justify-content:center;
    padding: 4px 8px; border-radius: 999px; font-weight: 700; font-size: 0.9rem;
    background:#f3f4f6; color:#111827; border: 1px solid #e5e7eb;
  }
  .chip.outlier { background: #fee2e2; color:#7f1d1d; border-color:#fecaca; }
  .chip.median { background: #dcfce7; color:#065f46; border-color:#bbf7d0; }
  .chip.mode { background: #ede9fe; color:#5b21b6; border-color:#ddd6fe; }

  .viz-grid { display:grid; grid-template-columns: 1.4fr 1fr; gap: 12px; margin-top: 1rem; }
  .panel {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px;
  }
  .panel h5 { margin: 0 0 8px 0; color:#374151; }

  .math-block {
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    background: #f9fafb;
    border: 1px dashed #e5e7eb;
    padding: 10px 12px;
    border-radius: 8px;
    color: #111827;
    margin-top: 8px;
    line-height: 1.4;
  }

  @media (max-width: 992px) { .cards{ grid-template-columns: repeat(2, 1fr); } .viz-grid{ grid-template-columns: 1fr; } }
  @media (max-width: 576px){ .hero-number{ font-size:2.1rem; letter-spacing:0.1rem; } }
</style>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Mean, Median, Mode Finder — Paste Numbers",
  "url":"https://8gwifi.org/mean-median-mode.jsp",
  "description":"Paste a list of numbers to compute mean, median, mode, and outliers with a sorted list and histogram.",
  "keywords":"mean median mode, average calculator, outliers, histogram, IQR, statistics calculator, descriptive statistics"
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="kap-container">
  <h1 class="mt-4">Mean, Median, Mode Finder</h1>
  <p class="tiny">Paste numbers separated by commas, spaces, or newlines. Get <span class="pill pill-green">mean</span>, <span class="pill pill-green">median</span>, <span class="pill pill-green">mode</span>, outliers, a sorted list, and a histogram.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">—</div>
  <div class="hero-sub" id="heroHint">Paste values or use Sample Data to try it out</div>

  <div class="input-pane">
    <textarea class="form-control data-area" id="dataArea" placeholder="Paste numbers here (e.g., 12, 15, 15, 21, 28, 35, 35, 35, 42)"></textarea>
    <div class="controls">
      <button type="button" class="btn btn-secondary" id="btnSample"><i class="fas fa-flask"></i> Sample Data</button>
      <button type="button" class="btn btn-success" id="btnAnalyze"><i class="fas fa-calculator"></i> Analyze</button>
      <button type="button" class="btn btn-outline-danger" id="btnClear"><i class="fas fa-eraser"></i> Clear</button>

      <!-- Bins slider removed (histogram removed) -->

      <div class="ml-auto"></div>
      <button type="button" class="btn btn-outline-primary" id="btnCopy"><i class="fas fa-copy"></i> Copy Summary</button>
    </div>
  </div>

  <div class="cards">
    <div class="cardx">
      <h6>Mean</h6>
      <div class="big" id="statMean">—</div>
      <div class="tiny" id="statCount">n = 0</div>
    </div>
    <div class="cardx">
      <h6>Median</h6>
      <div class="big" id="statMedian">—</div>
      <div class="tiny" id="statRange">range: —</div>
    </div>
    <div class="cardx">
      <h6>Mode</h6>
      <div class="big" id="statMode">—</div>
      <div class="tiny" id="statModeNote">—</div>
    </div>
    <div class="cardx">
      <h6>Outliers (IQR)</h6>
      <div class="big" id="statOutliers">—</div>
      <div class="tiny" id="statIQR">IQR: — | Q1: — | Q3: —</div>
    </div>
  </div>

  <div class="panel" style="margin-top:12px;">
    <h5>Sorted Values</h5>
    <div class="tiny">Median and outliers are highlighted.</div>
    <div class="chips" id="sortedChips"></div>
  </div>

  <div class="panel" style="margin-top:12px;">
    <h5>Calculations & Formulas</h5>
    <div id="formulaMean" class="math-block"></div>
    <div id="formulaMedian" class="math-block"></div>
    <div id="formulaMode" class="math-block"></div>
    <div id="formulaOutliers" class="math-block"></div>
  </div>

  <div class="panel" style="margin-top:12px;">
    <h5>How this works</h5>
    <p class="tiny">
      We parse your numbers and compute descriptive statistics. Outliers are detected using the IQR rule:
      values below Q1 − 1.5×IQR or above Q3 + 1.5×IQR are flagged. The histogram uses automatic binning
      (Sturges’ rule) unless you override it with the slider.
    </p>
    <ul class="tiny" style="margin-bottom:0;">
      <li>Paste freely — commas, spaces, new lines all work.</li>
      <li>Modes: if multiple values share the top frequency, they’re all listed.</li>
      <li>Tip: For clean histograms with small datasets, try 5–10 bins.</li>
    </ul>
  </div>

</div>

<script>
(function(){
  var area = document.getElementById('dataArea');
  var meanEl = document.getElementById('statMean');
  var medianEl = document.getElementById('statMedian');
  var modeEl = document.getElementById('statMode');
  var modeNoteEl = document.getElementById('statModeNote');
  var outliersEl = document.getElementById('statOutliers');
  var iqrEl = document.getElementById('statIQR');
  var countEl = document.getElementById('statCount');
  var rangeEl = document.getElementById('statRange');
  var chipsEl = document.getElementById('sortedChips');
  var heroEl = document.getElementById('heroNumber');
  var hintEl = document.getElementById('heroHint');

  var btnSample = document.getElementById('btnSample');
  var btnAnalyze = document.getElementById('btnAnalyze');
  var btnClear = document.getElementById('btnClear');
  var btnCopy = document.getElementById('btnCopy');

  // Formula blocks
  var fMean = document.getElementById('formulaMean');
  var fMedian = document.getElementById('formulaMedian');
  var fMode = document.getElementById('formulaMode');
  var fOutliers = document.getElementById('formulaOutliers');

  var debounceTimer = null;

  function parseNumbers(text) {
    var matches = String(text || '').match(/-?\d*\.?\d+(?:e-?\d+)?/gi);
    if (!matches) return [];
    return matches.map(function(s){ return parseFloat(s); }).filter(function(x){ return isFinite(x); });
  }
  function round(n, p){ var f = Math.pow(10, p || 2); return Math.round(n * f) / f; }

  function medianOfSorted(arr) {
    var n = arr.length;
    if (n === 0) return NaN;
    var mid = Math.floor(n/2);
    return n % 2 ? arr[mid] : (arr[mid-1] + arr[mid]) / 2;
  }
  function quartiles(sorted) {
    var n = sorted.length;
    if (n < 2) return { q1: NaN, q3: NaN };
    var mid = Math.floor(n/2);
    var lower = sorted.slice(0, mid);
    var upper = sorted.slice(n % 2 ? mid+1 : mid);
    return { q1: medianOfSorted(lower), q3: medianOfSorted(upper) };
  }
  function modes(arr) {
    if (arr.length === 0) return [];
    var freq = Object.create(null), max = 0;
    arr.forEach(function(v){ var k = String(v); freq[k] = (freq[k] || 0) + 1; if (freq[k] > max) max = freq[k]; });
    var ms = Object.keys(freq).filter(function(k){ return freq[k] === max; }).map(function(k){ return parseFloat(k); });
    if (ms.length === Object.keys(freq).length) return []; // no mode
    return ms.sort(function(a,b){ return a-b; });
  }

  function sturges(n) { return Math.max(3, Math.ceil(Math.log2(n) + 1)); }

  function buildHistogram(sorted, bins) {
    if (!sorted.length) return { labels: [], counts: [] };
    var min = sorted[0], max = sorted[sorted.length - 1];
    if (min === max) return { labels: [String(min)], counts: [sorted.length] };

    var k = bins || sturges(sorted.length);
    var width = (max - min) / k;
    var labels = [], counts = new Array(k).fill(0);
    for (var i=0;i<k;i++){
      var start = min + i*width;
      var end = i === k-1 ? max : (min + (i+1)*width);
      labels.push(round(start,2) + '–' + round(end,2));
    }
    for (var j=0;j<sorted.length;j++){
      var idx = Math.min(k-1, Math.floor((sorted[j] - min) / width));
      counts[idx]++;
    }
    return { labels: labels, counts: counts };
  }

  function renderHistogram(sorted) {
    var bins = parseInt(binRange.value, 10);
    if (bins === 0 || isNaN(bins)) bins = null;
    binVal.textContent = bins ? String(bins) : 'auto';

    var data = buildHistogram(sorted, bins);
    var ctx = document.getElementById('histCanvas').getContext('2d');

    if (chart) { chart.destroy(); }
    chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: data.labels,
        datasets: [{
          label: 'Frequency',
          data: data.counts,
          backgroundColor: 'rgba(59,130,246,0.35)',
          borderColor: 'rgba(59,130,246,1)',
          borderWidth: 1,
          // Extra-compact bars for better fit
          categoryPercentage: 0.8,
          barPercentage: 0.8,
          maxBarThickness: 12
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { mode: 'index', intersect: false }
        },
        layout: { padding: 2 },
        scales: {
          x: {
            ticks: {
              maxRotation: 0,
              autoSkip: true,
              maxTicksLimit: 8,
              font: { size: 10 }
            },
            grid: { display: false }
          },
          y: {
            beginAtZero: true,
            ticks: { precision: 0, maxTicksLimit: 4, font: { size: 10 } },
            grid: { drawBorder: false }
          }
        }
      }
    });
  }

  function renderChips(sorted, med, outSet, modeSet) {
    chipsEl.innerHTML = '';
    sorted.forEach(function(v){
      var chip = document.createElement('span');
      chip.className = 'chip' + (outSet.has(v) ? ' outlier' : '') + (modeSet.has(v) ? ' mode' : '') + (v === med ? ' median' : '');
      chip.textContent = String(v);
      chipsEl.appendChild(chip);
    });
  }

  function analyze() {
    var arr = parseNumbers(area.value).sort(function(a,b){ return a-b; });
    var n = arr.length;
    if (n === 0) {
      meanEl.textContent = '—'; medianEl.textContent = '—'; modeEl.textContent = '—'; modeNoteEl.textContent = '—';
      outliersEl.textContent = '—'; iqrEl.textContent = 'IQR: — | Q1: — | Q3: —'; countEl.textContent = 'n = 0'; rangeEl.textContent = 'range: —';
      chipsEl.innerHTML = ''; heroEl.textContent = '—';
      if (fMean) fMean.innerHTML = '';
      if (fMedian) fMedian.innerHTML = '';
      if (fMode) fMode.innerHTML = '';
      if (fOutliers) fOutliers.innerHTML = '';
      return;
    }

    var sum = arr.reduce(function(a,b){ return a+b; }, 0);
    var mean = sum / n;
    var med = medianOfSorted(arr);
    var ms = modes(arr);
    var qs = quartiles(arr);
    var IQR = (qs.q3 - qs.q1);
    var lowerFence = qs.q1 - 1.5 * IQR;
    var upperFence = qs.q3 + 1.5 * IQR;
    var outs = arr.filter(function(v){ return v < lowerFence || v > upperFence; });
    var outSet = new Set(outs);
    var modeSet = new Set(ms);

    meanEl.textContent = String(round(mean, 4));
    medianEl.textContent = String(round(med, 4));
    modeEl.textContent = ms.length ? ms.join(', ') : 'No mode';
    modeNoteEl.textContent = ms.length ? ('Freq peak: ' + arr.filter(function(v){ return v === ms[0]; }).length) : 'All values equally frequent';
    outliersEl.textContent = outs.length ? outs.join(', ') : 'None';
    iqrEl.textContent = 'IQR: ' + round(IQR,4) + ' | Q1: ' + round(qs.q1,4) + ' | Q3: ' + round(qs.q3,4);
    countEl.textContent = 'n = ' + n;
    rangeEl.textContent = 'range: ' + round(arr[0],4) + ' → ' + round(arr[n-1],4);

    heroEl.textContent = 'Mean: ' + round(mean, 4);

    renderChips(arr, med, outSet, modeSet);

    // Build readable calculation strings
    var displayNums = arr.slice(0, 25).join(' + ') + (arr.length > 25 ? ' + …' : '');
    var meanStr = '<strong>Mean</strong>: (Σ xᵢ) / n = (' + displayNums + ') / ' + n + ' = <strong>' + round(mean,4) + '</strong>';

    var medianStr;
    if (n % 2 === 1) {
      var midIdx = Math.floor(n/2);
      medianStr = '<strong>Median</strong> (odd n): x<sub>'+(midIdx+1)+'</sub> = <strong>'+ round(arr[midIdx],4) +'</strong>';
    } else {
      var r1 = arr[n/2 - 1], r2 = arr[n/2];
      medianStr = '<strong>Median</strong> (even n): (x<sub>'+ (n/2) +'</sub> + x<sub>'+ (n/2 + 1) +'</sub>) / 2 = ('+ round(r1,4) +' + '+ round(r2,4) +') / 2 = <strong>'+ round(med,4) +'</strong>';
    }

    var modeStr;
    if (ms.length) {
      var freqPeak = arr.filter(function(v){ return v === ms[0]; }).length;
      modeStr = '<strong>Mode</strong>: ' + ms.join(', ') + ' (frequency ' + freqPeak + ')';
    } else {
      modeStr = '<strong>Mode</strong>: No mode — all values equally frequent';
    }

    var outStr = '<strong>Outliers (IQR)</strong>: Q1 = ' + round(qs.q1,4) + ', Q3 = ' + round(qs.q3,4) +
                 ', IQR = Q3 − Q1 = ' + round(IQR,4) +
                 ', fences = [' + round(lowerFence,4) + ', ' + round(upperFence,4) + '] → ' +
                 (outs.length ? ('Outliers: ' + outs.join(', ')) : 'None');

    if (fMean) fMean.innerHTML = meanStr;
    if (fMedian) fMedian.innerHTML = medianStr;
    if (fMode) fMode.innerHTML = modeStr;
    if (fOutliers) fOutliers.innerHTML = outStr;
  }

  function copySummary() {
    var txt = [
      'Mean: ' + meanEl.textContent,
      'Median: ' + medianEl.textContent,
      'Mode: ' + modeEl.textContent,
      iqrEl.textContent,
      countEl.textContent,
      rangeEl.textContent
    ].join('\\n');
    navigator.clipboard && navigator.clipboard.writeText(txt).then(function(){}, function(){});
  }

  function sampleData() {
    // Ask for N and distribution; provide sensible defaults
    var n = parseInt(prompt('How many numbers? (N)', '50'), 10);
    if (!(n > 0) || n > 5000) n = 50;
    var dist = prompt('Distribution? (uniform, normal, skewed)', 'normal');
    dist = (dist || 'normal').toLowerCase();

    // Generators
    function randUniform(min, max) { return min + Math.random() * (max - min); }
    function randNormal(mu, sigma) {
      // Box-Muller transform
      var u = 1 - Math.random();
      var v = 1 - Math.random();
      var z = Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
      return mu + sigma * z;
    }
    function randSkewed(lambda) {
      // Exponential-like positive skew
      return -Math.log(1 - Math.random()) * (lambda || 30);
    }

    var arr = [];
    if (dist.startsWith('u')) {
      for (var i=0;i<n;i++) arr.push(Math.round(randUniform(0, 100) * 100) / 100);
    } else if (dist.startsWith('s')) {
      for (var j=0;j<n;j++) arr.push(Math.round(randSkewed(30) * 100) / 100);
    } else {
      // normal by default
      for (var k=0;k<n;k++) arr.push(Math.round(randNormal(50, 15) * 100) / 100);
    }

    area.value = arr.join(', ');
    analyze();
    hintEl.textContent = 'Sample generated: N=' + n + ' (' + dist + '). Tweak or paste your own.';
  }

  // events
  btnSample.addEventListener('click', sampleData);
  btnAnalyze.addEventListener('click', analyze);
  btnClear.addEventListener('click', function(){ area.value = ''; analyze(); });
  btnCopy.addEventListener('click', copySummary);
  // Histogram removed: no bin slider updates needed

  area.addEventListener('input', function(){
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(analyze, 250);
  });

  // init
  analyze();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
