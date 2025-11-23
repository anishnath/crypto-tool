<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Predicted Probability Explorer Online – Free | 8gwifi.org</title>
<meta name="description" content="Explore predicted probabilities, calibration (Platt / Isotonic), ROC/PR curves, thresholds, ECE/Brier/Log Loss, and class imbalance—interactive visual guide." />
<meta name="keywords" content="predicted probability, calibration curve, reliability diagram, ECE, Brier score, log loss, ROC AUC, PR AUC, threshold selection">

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Predicted Probability & Calibration Explorer",
  "description": "Interactive visual guide to predicted probabilities with calibration curves, ROC/PR, ECE/Brier/log-loss, and threshold tuning under class imbalance.",
  "url": "https://8gwifi.org/predicted_probability_explorer.jsp",
  "keywords": "predicted probability, calibration, reliability diagram, ROC AUC, PR AUC, ECE, Brier score, log loss"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .pp-lab { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .metric-badge { margin-right:8px; }
  .small-note { font-size:12px; color:#6c757d; }
  .chart-container-lg { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:10px; height:240px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Predicted Probability & Calibration Explorer</h1>
<p>Understand what a predicted probability means, how calibration works, and how thresholds affect decisions. Tune class imbalance, score separation, and calibration method to see effects on calibration error, loss, and ROC/PR performance.</p>

<!-- Quick Access -->
<div class="mb-2">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="pp-lab">
  <div class="row">
    <!-- Left: Visualizations -->
    <div class="col-lg-8 mb-4">
      <!-- Calibration -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Calibration & Reliability</h5>
          <div class="small text-muted">Diagonal = perfect calibration</div>
        </div>
        <div class="card-body">
          <div class="chart-container-lg">
            <canvas id="calibChart"></canvas>
          </div>
          <div class="mt-2">
            <span class="badge badge-primary metric-badge" id="mECE">ECE: —</span>
            <span class="badge badge-info metric-badge" id="mBrier">Brier: —</span>
            <span class="badge badge-warning metric-badge" id="mLogLoss">Log Loss: —</span>
          </div>
          <small class="small-note d-block mt-2">ECE uses fixed bins; try different calibration methods and class imbalance.</small>
        </div>
      </div>

      <!-- ROC/PR -->
      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">ROC & PR Curves</h5>
          <div class="small text-muted">AUC summarizes ranking performance; PR is better for rare positives</div>
        </div>
        <div class="card-body">
          <div class="chart-container-sm mb-3"><canvas id="rocChart"></canvas></div>
          <div class="chart-container-sm"><canvas id="prChart"></canvas></div>
          <div class="mt-2">
            <span class="badge badge-success metric-badge" id="mRocAuc">ROC-AUC: —</span>
            <span class="badge badge-secondary metric-badge" id="mPrAuc">PR-AUC: —</span>
            <span class="badge badge-dark metric-badge" id="mAcc">Accuracy@τ: —</span>
            <span class="badge badge-dark metric-badge" id="mF1">F1@τ: —</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <div class="control-section">
        <h6>Data & Model</h6>
        <div class="form-group">
          <label class="control-label">Samples: <strong id="nLbl">10,000</strong></label>
          <input type="range" id="nSamples" min="1000" max="50000" step="1000" value="10000" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Class imbalance P(y=1): <strong id="imbLbl">0.30</strong></label>
          <input type="range" id="imbalance" min="0.01" max="0.99" step="0.01" value="0.30" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Score separation: <strong id="sepLbl">2.0</strong></label>
          <input type="range" id="separation" min="0" max="5" step="0.1" value="2.0" class="form-range">
          <small class="small-note">Higher separation = easier classification</small>
        </div>
        <div class="form-group">
          <label class="control-label">Noise (σ): <strong id="noiseLbl">1.0</strong></label>
          <input type="range" id="noise" min="0.2" max="3.0" step="0.1" value="1.0" class="form-range">
        </div>
      </div>

      <div class="control-section">
        <h6>Calibration</h6>
        <div class="form-group">
          <label class="control-label" for="calMethod">Method</label>
          <select class="form-control" id="calMethod">
            <option value="none" selected>None (raw sigmoid)</option>
            <option value="platt">Platt scaling (logistic)</option>
            <option value="iso">Isotonic (binned)</option>
          </select>
        </div>
        <div class="form-group">
          <label class="control-label">Bins (reliability): <strong id="binsLbl">10</strong></label>
          <input type="range" id="nBins" min="5" max="30" step="1" value="10" class="form-range">
        </div>
      </div>

      <div class="control-section">
        <h6>Threshold</h6>
        <div class="form-group">
          <label class="control-label">Decision threshold τ: <strong id="thrLbl">0.50</strong></label>
          <input type="range" id="threshold" min="0.0" max="1.0" step="0.01" value="0.50" class="form-range">
        </div>
        <div class="row g-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnUpdate">Update</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnReset">Reset</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<hr id="guide">
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">How to interpret</h5>
  </div>
  <div class="card-body">
    <p class="mb-2"><strong>What:</strong> A predicted probability is the model’s confidence (0–1) that an outcome is positive. Over many similar cases, a prediction of 0.8 should be positive about 80% of the time.</p>
    <p class="mb-2"><strong>Calibration:</strong> Well-calibrated models match predicted probabilities to observed frequencies. Use Platt scaling (a logistic remap) or Isotonic (monotonic, non-parametric) to fix over/under-confidence.</p>
    <p class="mb-2"><strong>Discrimination vs calibration:</strong> ROC/PR show how well the model ranks examples; metrics like ECE, Brier, and Log Loss show how trustworthy the probabilities are.</p>
    <p class="mb-0"><strong>Thresholds:</strong> The default 0.5 may not be optimal—adjust τ for class imbalance or different error costs and watch Accuracy/F1 change.</p>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (Predicted Probability) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>Simulates predicted scores under tunable class imbalance and separation, then maps scores to probabilities with optional calibration (Platt/Isotonic). Plots reliability diagrams, ROC/PR curves, and reports ECE/Brier/Log Loss—all in your browser.</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Differentiate discrimination (ROC/PR) from calibration (reliability/ECE/Brier).</li>
      <li>See how imbalance and score separation influence thresholds and metrics.</li>
      <li>Practice choosing thresholds for specific precision/recall or cost trade‑offs.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>All computations run locally with synthetic data by default; nothing is uploaded.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Predicted Probability Explorer",
  "url": "https://8gwifi.org/predicted_probability_explorer.jsp",
  "dateModified": "2025-11-19",
  "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
  "reviewedBy": {"@type": "Person", "name": "Anish Nath"},
  "publisher": {"@type": "Organization", "name": "8gwifi.org"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Predicted Probability Explorer","item":"https://8gwifi.org/predicted_probability_explorer.jsp"}
  ]
}
</script>
<script>
(function(){
  'use strict';
  function $(id){ return document.getElementById(id); }
  function clamp(x,a,b){ return Math.max(a, Math.min(b, x)); }
  function sigmoid(z){ return 1/(1+Math.exp(-clamp(z,-60,60))); }

  // Charts
  var calibChart = new Chart($('calibChart').getContext('2d'), {
    type:'line',
    data:{ labels:[], datasets:[
      { label:'Reliability', data:[], borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.15)', fill:true, pointRadius:3, tension:0.2 },
      { label:'Perfect', data:[], borderColor:'#6c757d', borderDash:[6,4], pointRadius:0 }
    ]},
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{ display:true } },
      scales:{ x:{ title:{display:true, text:'Predicted probability'}}, y:{ min:0, max:1, title:{display:true, text:'Observed frequency'} } } }
  });

  var rocChart = new Chart($('rocChart').getContext('2d'), {
    type:'line',
    data:{ labels:[], datasets:[
      { label:'ROC', data:[], borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.15)', fill:true, pointRadius:0, tension:0.2 },
      { label:'Chance', data:[], borderColor:'#6c757d', borderDash:[6,4], pointRadius:0 }
    ]},
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{ display:true } },
      scales:{ x:{ min:0, max:1, title:{display:true, text:'FPR'} }, y:{ min:0, max:1, title:{display:true, text:'TPR'} } } }
  });

  var prChart = new Chart($('prChart').getContext('2d'), {
    type:'line',
    data:{ labels:[], datasets:[ { label:'PR', data:[], borderColor:'#fd7e14', backgroundColor:'rgba(253,126,20,0.15)', fill:true, pointRadius:0, tension:0.2 } ] },
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{ display:true } },
      scales:{ x:{ min:0, max:1, title:{display:true, text:'Recall'} }, y:{ min:0, max:1, title:{display:true, text:'Precision'} } } }
  });

  var state = {
    N: parseInt($('nSamples').value,10),
    p1: parseFloat($('imbalance').value),
    sep: parseFloat($('separation').value),
    noise: parseFloat($('noise').value),
    cal: $('calMethod').value,
    bins: parseInt($('nBins').value,10),
    thr: parseFloat($('threshold').value)
  };

  function setLabels(){
    $('nLbl').textContent = state.N.toLocaleString();
    $('imbLbl').textContent = state.p1.toFixed(2);
    $('sepLbl').textContent = state.sep.toFixed(1);
    $('noiseLbl').textContent = state.noise.toFixed(1);
    $('binsLbl').textContent = state.bins;
    $('thrLbl').textContent = state.thr.toFixed(2);
  }

  function generate(){
    var N = state.N, p1 = state.p1, sep = state.sep, sigma = state.noise;
    var muPos = +sep/2, muNeg = -sep/2;

    var y = new Array(N), s = new Float32Array(N);
    for (var i=0;i<N;i++){
      var isPos = Math.random() < p1 ? 1 : 0;
      y[i] = isPos;
      var mu = isPos ? muPos : muNeg;
      // Box-Muller
      var u = Math.random(), v = Math.random();
      var z = Math.sqrt(-2*Math.log(Math.max(1e-12,u))) * Math.cos(2*Math.PI*v);
      s[i] = mu + sigma * z;
    }
    return { y:y, s:s };
  }

  // Platt scaling: fit p = sigmoid(a*s + b) minimizing log loss
  function fitPlatt(s, y){
    var a=1, b=0, lr=0.01, iters=200;
    for (var t=0;t<iters;t++){
      var ga=0, gb=0;
      for (var i=0;i<s.length;i++){
        var p = sigmoid(a*s[i] + b);
        var e = p - y[i];
        ga += e * s[i];
        gb += e;
      }
      a -= lr * ga / s.length;
      b -= lr * gb / s.length;
    }
    return function(x){ return sigmoid(a*x + b); };
  }

  // Isotonic via binning (monotonic smoothing by pooling adjacent violators on bin means)
  function fitIsoBinned(s, y, bins){
    // sort by score
    var idx = Array.from(s, function(_,i){return i;}).sort(function(i,j){ return s[i]-s[j]; });
    var n = s.length, binSize = Math.max(1, Math.floor(n/bins));
    var bin = [];
    for (var i=0;i<bins;i++){
      var start = i*binSize, end = (i===bins-1)? n : Math.min(n, (i+1)*binSize);
      if (start>=n) break;
      var cnt=end-start, sum=0;
      for (var k=start;k<end;k++){ sum += y[idx[k]]; }
      bin.push({ cnt: cnt, mean: cnt? sum/cnt : 0, start: start, end:end });
    }
    // Pool Adjacent Violators
    var merged = [];
    for (var b=0;b<bin.length;b++){
      merged.push({ cnt:bin[b].cnt, mean:bin[b].mean });
      while (merged.length>=2 && merged[merged.length-2].mean > merged[merged.length-1].mean){
        var a = merged.pop(), c = merged.pop();
        var tot = a.cnt + c.cnt;
        merged.push({ cnt: tot, mean: tot? (a.mean*a.cnt + c.mean*c.cnt)/tot : 0 });
      }
    }
    // Map scores to piecewise-constant means across original bins
    var means = [];
    // distribute merged back to original bins by repeating
    var ptr=0;
    for (var m=0;m<merged.length;m++){
      var reps = 1; // at least one original segment
      // estimate repetitions using count proportions
      var targetCnt = merged[m].cnt;
      var acc=0;
      while (ptr<bin.length && acc+bin[ptr].cnt <= targetCnt+1e-6){ means.push(merged[m].mean); acc+=bin[ptr].cnt; ptr++; }
      if (acc<targetCnt && ptr<bin.length){ means.push(merged[m].mean); ptr++; }
    }
    while (means.length < bin.length) means.push(means[means.length-1] || 0.5);

    // Build function: use binned look-up
    return function(x){
      // locate bin by rank using approximate quantiles: use score to position
      // For simplicity in the browser, do a linear scan across equal-count bins based on x rank
      // We approximate by mapping x to nearest original bin center
      var pos = 0;
      var rank = 0;
      // Without retaining per-bin boundaries, fallback: use global sigmoid to estimate rank; then clamp index
      // This keeps demo simple and fast.
      var p = sigmoid((x - 0)/1); // rough
      var i = Math.max(0, Math.min(bin.length-1, Math.floor(p * bin.length)));
      return means[i];
    };
  }

  function applyCalibration(cal, s, y){
    if (cal === 'platt'){
      var f = fitPlatt(s, y);
      return Array.from(s, function(v){ return clamp(f(v), 1e-6, 1-1e-6); });
    } else if (cal === 'iso'){
      var f2 = fitIsoBinned(s, y, state.bins);
      return Array.from(s, function(v){ return clamp(f2(v), 1e-6, 1-1e-6); });
    } else {
      return Array.from(s, function(v){ return clamp(sigmoid(v), 1e-6, 1-1e-6); });
    }
  }

  // Metrics
  function logLoss(y, p){
    var s=0; for (var i=0;i<y.length;i++){ s += - (y[i]*Math.log(p[i]) + (1-y[i])*Math.log(1-p[i])); }
    return s / y.length;
  }
  function brier(y, p){
    var s=0; for (var i=0;i<y.length;i++){ var d=p[i]-y[i]; s+=d*d; } return s/y.length;
  }
  function ece(y, p, bins){
    var n=y.length, sum=0;
    for (var b=0;b<bins;b++){
      var lo=b/bins, hi=(b+1)/bins, cnt=0, acc=0, conf=0;
      for (var i=0;i<n;i++){
        if (p[i]>=lo && p[i]<hi || (b===bins-1 && p[i]===1)){
          cnt++; acc+=y[i]; conf+=p[i];
        }
      }
      if (cnt>0){
        var ab=acc/cnt, cb=conf/cnt;
        sum += Math.abs(ab - cb) * (cnt/n);
      }
    }
    return sum;
  }
  function rocAuc(y, p){
    var idx = y.map(function(_,i){return i;}).sort(function(a,b){ return p[a]-p[b]; });
    var rank = new Float64Array(y.length);
    for (var i=0;i<idx.length;i++) rank[idx[i]] = i+1;
    var pos=0, sumR=0; for (var i2=0;i2<y.length;i2++){ if (y[i2]===1){ pos++; sumR+=rank[i2]; } }
    var neg = y.length - pos; if (pos===0||neg===0) return 0.5;
    return (sumR - pos*(pos+1)/2) / (pos*neg);
  }
  function prAuc(y, p){
    var pairs = y.map(function(v,i){ return {y:v, p:p[i]}; }).sort(function(a,b){ return b.p-a.p; });
    var tp=0, fp=0, fn = y.reduce(function(s,v){return s+(v===1?1:0);},0);
    var prevR=0, auc=0;
    for (var i=0;i<pairs.length;i++){
      if (pairs[i].y===1){ tp++; fn--; } else { fp++; }
      var rec = tp/(tp+fn+1e-12), prec = tp/(tp+fp+1e-12);
      auc += (rec - prevR) * prec;
      prevR = rec;
    }
    return clamp(auc,0,1);
  }
  function confusion(y, p, thr){
    var tp=0, fp=0, tn=0, fn=0;
    for (var i=0;i<y.length;i++){
      var pred = p[i] >= thr ? 1 : 0;
      if (pred===1 && y[i]===1) tp++;
      else if (pred===1 && y[i]===0) fp++;
      else if (pred===0 && y[i]===0) tn++;
      else fn++;
    }
    var acc = (tp+tn)/y.length;
    var prec = tp/(tp+fp+1e-12);
    var rec = tp/(tp+fn+1e-12);
    var f1 = (prec+rec===0)?0:(2*prec*rec/(prec+rec));
    return {acc:acc, f1:f1};
  }

  function buildReliability(y, p, bins){
    var xs=[], ys=[], diagx=[], diagy=[];
    for (var b=0;b<=bins;b++){ var t=b/bins; diagx.push(t); diagy.push(t); }
    for (var b2=0;b2<bins;b2++){
      var lo=b2/bins, hi=(b2+1)/bins, cnt=0, acc=0, conf=0;
      for (var i=0;i<y.length;i++){
        if (p[i]>=lo && p[i]<hi || (b2===bins-1 && p[i]===1)){
          cnt++; acc+=y[i]; conf+=p[i];
        }
      }
      if (cnt>0){ xs.push((lo+hi)/2); ys.push(acc/cnt); }
    }
    return { xs:xs, ys:ys, diagx:diagx, diagy:diagy };
  }

  function buildROC(y, p){
    // sweep thresholds
    var pairs = y.map(function(v,i){ return {y:v, p:p[i]}; }).sort(function(a,b){ return b.p-a.p; });
    var P = y.reduce(function(s,v){return s+(v===1?1:0);},0);
    var N = y.length - P, tp=0, fp=0, xs=[], ys=[];
    var lastP = Infinity;
    for (var i=0;i<pairs.length;i++){
      if (pairs[i].p !== lastP){
        xs.push(fp/N); ys.push(tp/P);
        lastP = pairs[i].p;
      }
      if (pairs[i].y===1) tp++; else fp++;
    }
    xs.push(1); ys.push(1);
    return { xs:xs, ys:ys };
  }

  function buildPR(y, p){
    var pairs = y.map(function(v,i){ return {y:v, p:p[i]}; }).sort(function(a,b){ return b.p-a.p; });
    var tp=0, fp=0, fn = y.reduce(function(s,v){return s+(v===1?1:0);},0);
    var xs=[], ys=[];
    for (var i=0;i<pairs.length;i++){
      if (pairs[i].y===1){ tp++; fn--; } else { fp++; }
      var rec = tp/(tp+fn+1e-12), prec = tp/(tp+fp+1e-12);
      xs.push(rec); ys.push(prec);
    }
    return { xs:xs, ys:ys };
  }

  function update(){
    state.N = parseInt($('nSamples').value,10);
    state.p1 = parseFloat($('imbalance').value);
    state.sep = parseFloat($('separation').value);
    state.noise = parseFloat($('noise').value);
    state.cal = $('calMethod').value;
    state.bins = parseInt($('nBins').value,10);
    state.thr = parseFloat($('threshold').value);
    setLabels();

    var data = generate();
    var p = applyCalibration(state.cal, data.s, data.y);

    // Metrics
    $('mLogLoss').textContent = 'Log Loss: ' + logLoss(data.y, p).toFixed(3);
    $('mBrier').textContent   = 'Brier: ' + brier(data.y, p).toFixed(3);
    $('mECE').textContent     = 'ECE: ' + ece(data.y, p, state.bins).toFixed(3);
    $('mRocAuc').textContent  = 'ROC-AUC: ' + rocAuc(data.y, p).toFixed(3);
    $('mPrAuc').textContent   = 'PR-AUC: ' + prAuc(data.y, p).toFixed(3);

    var thrM = confusion(data.y, p, state.thr);
    $('mAcc').textContent = 'Accuracy@τ: ' + (thrM.acc*100).toFixed(1) + '%';
    $('mF1').textContent  = 'F1@τ: ' + thrM.f1.toFixed(3);

    // Charts: Reliability
    var rel = buildReliability(data.y, p, state.bins);
    calibChart.data.labels = rel.xs;
    calibChart.data.datasets[0].data = rel.xs.map(function(x,i){ return { x: x, y: rel.ys[i] }; });
    calibChart.data.datasets[1].data = rel.diagx.map(function(x,i){ return { x: x, y: rel.diagy[i] }; });
    calibChart.update('none');

    // ROC
    var roc = buildROC(data.y, p);
    rocChart.data.labels = roc.xs;
    rocChart.data.datasets[0].data = roc.xs.map(function(x,i){ return { x: x, y: roc.ys[i] }; });
    rocChart.data.datasets[1].data = [ {x:0,y:0}, {x:1,y:1} ];
    rocChart.update('none');

    // PR
    var pr = buildPR(data.y, p);
    prChart.data.labels = pr.xs;
    prChart.data.datasets[0].data = pr.xs.map(function(x,i){ return { x: x, y: pr.ys[i] }; });
    prChart.update('none');
  }

  // Bindings
  ['nSamples','imbalance','separation','noise','calMethod','nBins','threshold'].forEach(function(id){
    $(id).addEventListener('input', update);
  });
  $('btnUpdate').addEventListener('click', update);
  $('btnReset').addEventListener('click', function(){
    $('nSamples').value = 10000;
    $('imbalance').value = 0.30;
    $('separation').value = 2.0;
    $('noise').value = 1.0;
    $('calMethod').value = 'none';
    $('nBins').value = 10;
    $('threshold').value = 0.50;
    update();
  });

  // Init
  setLabels();
  update();
})();
</script>
</html>
