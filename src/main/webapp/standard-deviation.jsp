<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- SEO Meta -->
<title>Standard Deviation Calculator — Sample/Population, Variance + Bell Curve</title>
<meta name="description" content="Paste numbers to compute standard deviation and variance with a sample/population toggle. See the bell curve plotted with μ and ±σ markers.">
<meta name="keywords" content="standard deviation calculator, sd calculator, variance calculator, population standard deviation, sample standard deviation, bell curve, normal distribution">
<link rel="canonical" href="https://8gwifi.org/standard-deviation.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Standard Deviation Calculator — Variance + Bell Curve">
<meta property="og:description" content="Compute mean, variance, and standard deviation (sample/pop). Visual bell curve with μ and ±σ.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/standard-deviation.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Standard Deviation Calculator — Variance + Bell Curve">
<meta name="twitter:description" content="Paste data, toggle sample/population, and see the bell curve with μ and σ markers.">

<%@ include file="header-script.jsp"%>

<style>
  .sd-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.6rem; font-weight: 800; text-align: center;
    padding: 0.75rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #22c55e; text-shadow: 0 2px 12px rgba(34,197,94,0.45);
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

  /* Compact bell curve canvas */
  #curveCanvas {
    width: 100%;
    height: 160px;
    display: block;
  }

  @media (max-width: 992px) { .cards{ grid-template-columns: repeat(2, 1fr); } }
  @media (max-width: 576px){ .hero-number{ font-size:2.1rem; letter-spacing:0.1rem; } }
</style>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Standard Deviation Calculator — Sample/Population",
  "url":"https://8gwifi.org/standard-deviation.jsp",
  "description":"Compute standard deviation and variance with sample vs population, plus a normal curve plot.",
  "keywords":"standard deviation calculator, variance, population SD, sample SD, bell curve"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="sd-container">
  <h1 class="mt-4">Standard Deviation Calculator</h1>
  <p class="tiny">Paste numbers separated by commas, spaces, or newlines. Toggle <span class="pill pill-green">sample</span> vs <span class="pill pill-gray">population</span>. See mean, variance, standard deviation, and a bell curve.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">—</div>
  <div class="hero-sub" id="heroHint">Paste values or use Sample Data to try it out</div>

  <div class="input-pane">
    <textarea class="form-control data-area" id="dataArea" placeholder="Paste numbers here (e.g., 11, 14, 16, 20, 21, 23, 24, 30)"></textarea>
    <div class="controls">
      <div class="btn-group btn-group-toggle" data-toggle="buttons" style="margin-right:8px;">
        <label class="btn btn-sm btn-outline-primary active" id="lblSample">
          <input type="radio" name="mode" id="modeSample" autocomplete="off" checked> Sample
        </label>
        <label class="btn btn-sm btn-outline-primary" id="lblPopulation">
          <input type="radio" name="mode" id="modePopulation" autocomplete="off"> Population
        </label>
      </div>

      <button type="button" class="btn btn-secondary" id="btnSample"><i class="fas fa-flask"></i> Sample Data</button>
      <button type="button" class="btn btn-success" id="btnAnalyze"><i class="fas fa-calculator"></i> Analyze</button>
      <button type="button" class="btn btn-outline-danger" id="btnClear"><i class="fas fa-eraser"></i> Clear</button>

      <div class="ml-auto"></div>
      <button type="button" class="btn btn-outline-primary" id="btnCopy"><i class="fas fa-copy"></i> Copy Summary</button>
    </div>
  </div>

  <div class="cards">
    <div class="cardx">
      <h6>Count</h6>
      <div class="big" id="statCount">0</div>
      <div class="tiny" id="statModeText">Mode: sample</div>
    </div>
    <div class="cardx">
      <h6>Mean (μ / x̄)</h6>
      <div class="big" id="statMean">—</div>
      <div class="tiny" id="statSum">Σx = —</div>
    </div>
    <div class="cardx">
      <h6>Variance (σ² / s²)</h6>
      <div class="big" id="statVar">—</div>
      <div class="tiny" id="statVarNote">—</div>
    </div>
    <div class="cardx">
      <h6>Std Dev (σ / s)</h6>
      <div class="big" id="statSD">—</div>
      <div class="tiny" id="statSigmaRule">—</div>
    </div>
  </div>

  <div class="panel" style="margin-top:12px;">
    <h5>Bell Curve (Normal Distribution)</h5>
    <canvas id="curveCanvas" height="160"></canvas>
    <div class="tiny">Curve uses your mean and standard deviation. Markers show μ and ±1σ, ±2σ, ±3σ.</div>
  </div>

  <div class="panel" style="margin-top:12px;">
    <h5>Calculations & Formulas</h5>
    <div id="formulaMean" class="math-block"></div>
    <div id="formulaVar" class="math-block"></div>
    <div id="formulaSD" class="math-block"></div>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  var area = document.getElementById('dataArea');
  var heroEl = document.getElementById('heroNumber');
  var hintEl = document.getElementById('heroHint');

  var lblSample = document.getElementById('lblSample');
  var lblPopulation = document.getElementById('lblPopulation');
  var modeSample = document.getElementById('modeSample');
  var modePopulation = document.getElementById('modePopulation');

  var btnSample = document.getElementById('btnSample');
  var btnAnalyze = document.getElementById('btnAnalyze');
  var btnClear = document.getElementById('btnClear');
  var btnCopy = document.getElementById('btnCopy');

  var countEl = document.getElementById('statCount');
  var modeTextEl = document.getElementById('statModeText');
  var sumEl = document.getElementById('statSum');
  var meanEl = document.getElementById('statMean');
  var varEl = document.getElementById('statVar');
  var varNoteEl = document.getElementById('statVarNote');
  var sdEl = document.getElementById('statSD');
  var sigmaRuleEl = document.getElementById('statSigmaRule');

  var fMean = document.getElementById('formulaMean');
  var fVar = document.getElementById('formulaVar');
  var fSD = document.getElementById('formulaSD');

  var canvas = document.getElementById('curveCanvas');
  var ctx = canvas.getContext('2d');

  var debounceTimer = null;

  function parseNumbers(text) {
    var matches = String(text || '').match(/-?\d*\.?\d+(?:e-?\d+)?/gi);
    if (!matches) return [];
    return matches.map(function(s){ return parseFloat(s); }).filter(function(x){ return isFinite(x); });
  }
  function round(n, p){ var f = Math.pow(10, p || 4); return Math.round(n * f) / f; }

  function computeStats(arr, isSample) {
    var n = arr.length;
    if (!n) return { n:0, sum:0, mean:NaN, variance:NaN, sd:NaN };
    var sum = arr.reduce(function(a,b){ return a+b; }, 0);
    var mean = sum / n;
    var ss = 0;
    for (var i=0;i<n;i++) {
      var d = arr[i] - mean;
      ss += d*d;
    }
    var variance = isSample ? (n>1 ? ss / (n-1) : NaN) : ss / n;
    var sd = isFinite(variance) ? Math.sqrt(variance) : NaN;
    return { n:n, sum:sum, mean:mean, variance:variance, sd:sd, ss:ss };
  }

  function updateModeButtons() {
    // Toggle the active class for Bootstrap styling
    if (modeSample.checked) { lblSample.classList.add('active'); lblPopulation.classList.remove('active'); }
    else { lblPopulation.classList.add('active'); lblSample.classList.remove('active'); }
  }

  function drawCurve(mean, sd) {
    // Clear
    ctx.clearRect(0,0,canvas.width, canvas.height);
    if (!isFinite(mean) || !isFinite(sd) || sd <= 0) return;

    var W = canvas.width, H = canvas.height;
    // range μ ± 4σ
    var xMin = mean - 4*sd, xMax = mean + 4*sd;
    function nx(x){ return (x - xMin) / (xMax - xMin) * W; }
    function ny(y){ return H - y * H; }
    function pdf(x){ return (1/(sd*Math.sqrt(2*Math.PI))) * Math.exp(-0.5 * Math.pow((x-mean)/sd, 2)); }

    // Calculate max pdf at mean for scaling
    var ymax = pdf(mean) * 1.15;

    // Curve
    ctx.beginPath();
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 2;
    for (var i=0;i<=500;i++){
      var x = xMin + (xMax - xMin) * (i/500);
      var y = pdf(x) / ymax; // normalize to [0,~1]
      var X = nx(x), Y = ny(y);
      if (i===0) ctx.moveTo(X,Y); else ctx.lineTo(X,Y);
    }
    ctx.stroke();

    // Markers μ, ±σ, ±2σ, ±3σ
    ctx.strokeStyle = '#9ca3af';
    ctx.lineWidth = 1;
    var marks = [0,1,2,3,-1,-2,-3].map(function(k){ return mean + k*sd; });
    marks.forEach(function(mx, idx){
      var X = nx(mx);
      ctx.beginPath();
      ctx.moveTo(X, ny(0));
      ctx.lineTo(X, ny(0.95));
      ctx.stroke();
      ctx.fillStyle = '#6b7280';
      ctx.font = '10px system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial';
      var label = (idx===0 ? 'μ' : (idx<4 ? ('+'+idx+'σ') : (-(idx-3)+'σ')));
      ctx.fillText(label, X+3, 12);
    });
  }

  function analyze() {
    var arr = parseNumbers(area.value).sort(function(a,b){ return a-b; });
    var isSample = modeSample.checked;
    updateModeButtons();

    if (arr.length === 0) {
      countEl.textContent = '0';
      modeTextEl.textContent = 'Mode: ' + (isSample ? 'sample' : 'population');
      meanEl.textContent = '—';
      varEl.textContent = '—';
      sdEl.textContent = '—';
      sumEl.textContent = 'Σx = —';
      varNoteEl.textContent = '—';
      sigmaRuleEl.textContent = '—';
      heroEl.textContent = '—';
      if (fMean) fMean.innerHTML = '';
      if (fVar) fVar.innerHTML = '';
      if (fSD) fSD.innerHTML = '';
      ctx.clearRect(0,0,canvas.width, canvas.height);
      return;
    }

    var stats = computeStats(arr, isSample);
    countEl.textContent = String(stats.n);
    modeTextEl.textContent = 'Mode: ' + (isSample ? 'sample' : 'population');
    meanEl.textContent = String(round(stats.mean, 6));
    varEl.textContent = isFinite(stats.variance) ? String(round(stats.variance, 6)) : 'NaN';
    sdEl.textContent = isFinite(stats.sd) ? String(round(stats.sd, 6)) : 'NaN';
    sumEl.textContent = 'Σx = ' + round(stats.sum, 6);
    varNoteEl.textContent = isSample ? 's² = Σ(x − x̄)² / (n − 1)' : 'σ² = Σ(x − μ)² / n';
    sigmaRuleEl.textContent = '68–95–99.7% rule around μ ± σ, ±2σ, ±3σ';

    heroEl.textContent = 'SD: ' + (isFinite(stats.sd) ? round(stats.sd, 6) : 'NaN');

    // Formulas
    var firstTerms = arr.slice(0, 12).map(function(v){ return round(v, 4); }).join(' + ') + (arr.length > 12 ? ' + …' : '');
    var fMeanStr = '<strong>Mean</strong>: x̄ = (Σxᵢ)/n = (' + firstTerms + ') / ' + stats.n + ' = <strong>' + round(stats.mean,6) + '</strong>';
    var denom = isSample ? '(n − 1)' : 'n';
    var fVarStr = '<strong>Variance</strong>: ' + (isSample ? 's²' : 'σ²') + ' = Σ(xᵢ − ' + (isSample ? 'x̄' : 'μ') + ')² / ' + denom +
                  ' = ' + round(stats.ss,6) + ' / ' + (isSample ? (stats.n > 1 ? (stats.n - 1) : '—') : stats.n) +
                  ' = <strong>' + (isFinite(stats.variance) ? round(stats.variance,6) : 'NaN') + '</strong>';
    var fSDStr = '<strong>Std Dev</strong>: ' + (isSample ? 's' : 'σ') + ' = √' + (isSample ? 's²' : 'σ²') + ' = √' +
                 (isFinite(stats.variance) ? round(stats.variance,6) : 'NaN') + ' = <strong>' + (isFinite(stats.sd) ? round(stats.sd,6) : 'NaN') + '</strong>';

    fMean.innerHTML = fMeanStr;
    fVar.innerHTML = fVarStr;
    fSD.innerHTML = fSDStr;

    // Draw curve
    // Ensure canvas width is current CSS width
    canvas.width = canvas.clientWidth;
    canvas.height = 160;
    drawCurve(stats.mean, stats.sd);
  }

  function copySummary() {
    var txt = [
      'Mode: ' + (modeSample.checked ? 'sample' : 'population'),
      'Count: ' + countEl.textContent,
      'Mean: ' + meanEl.textContent,
      'Variance: ' + varEl.textContent,
      'Std Dev: ' + sdEl.textContent
    ].join('\\n');
    navigator.clipboard && navigator.clipboard.writeText(txt).then(function(){}, function(){});
  }

  function sampleData() {
    var n = parseInt(prompt('How many numbers? (N)', '50'), 10);
    if (!(n > 0) || n > 5000) n = 50;
    var dist = prompt('Distribution? (uniform, normal, skewed)', 'normal');
    dist = (dist || 'normal').toLowerCase();

    function randUniform(min, max) { return min + Math.random() * (max - min); }
    function randNormal(mu, sigma) {
      var u = 1 - Math.random();
      var v = 1 - Math.random();
      var z = Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
      return mu + sigma * z;
    }
    function randSkewed(lambda) { return -Math.log(1 - Math.random()) * (lambda || 30); }

    var arr = [];
    if (dist.startsWith('u')) {
      for (var i=0;i<n;i++) arr.push(Math.round(randUniform(0, 100) * 100) / 100);
    } else if (dist.startsWith('s')) {
      for (var j=0;j<n;j++) arr.push(Math.round(randSkewed(30) * 100) / 100);
    } else {
      for (var k=0;k<n;k++) arr.push(Math.round(randNormal(50, 15) * 100) / 100);
    }

    area.value = arr.join(', ');
    analyze();
    hintEl.textContent = 'Sample generated: N=' + n + ' (' + dist + '). Tweak or paste your own.';
  }

  // Events
  btnAnalyze.addEventListener('click', analyze);
  btnClear.addEventListener('click', function(){ area.value = ''; analyze(); });
  btnCopy.addEventListener('click', copySummary);
  btnSample.addEventListener('click', sampleData);
  modeSample.addEventListener('change', analyze);
  modePopulation.addEventListener('change', analyze);

  area.addEventListener('input', function(){
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(analyze, 250);
  });
  window.addEventListener('resize', function(){ analyze(); });

  // init
  analyze();
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
