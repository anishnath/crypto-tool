<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Model Validation Lab: Hold-out, K-Fold, Nested, Time-Series (Interactive)</title>
<meta name="description" content="Interactive lab for model validation: hold-out, K-fold, repeated, nested cross-validation, group-aware and time-series splits. Visualize splits, per-fold metrics, ROC/PR, and the impact of leakage." />
<meta name="keywords" content="model validation, cross-validation, k-fold, repeated k-fold, nested cross-validation, group kfold, time series split, leakage, ROC AUC, PR AUC, log loss">

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Model Validation Lab",
  "description": "Interactive visual guide to model validation techniques with animated splits, metrics across folds, ROC/PR aggregation, and leakage warnings.",
  "url": "https://8gwifi.org/model_validation_lab.jsp",
  "keywords": "model validation, cross-validation, nested cross-validation, time-series validation, leakage"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .mv { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .metric-badge { margin-right:8px; }
  .small-note { font-size:12px; color:#6c757d; }
  .chart-container-lg { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:340px; }
  .chart-container-sm { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:10px; height:220px; }
  #splitCanvas { width:100%; height:180px; background:#fff; border:1px solid #dee2e6; border-radius:8px; }
  .warn { background:#fff3cd; border:1px solid #ffe69c; color:#664d03; border-radius:6px; padding:8px 10px; display:none; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Model Validation Lab</h1>
<p>Compare validation strategies—Hold-out, K-Fold, Repeated K-Fold, Nested CV, GroupKFold, and Time-Series (walk-forward). See split diagrams, per-fold metrics, pooled ROC/PR, and how leakage can inflate results.</p>

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

<div class="mv">
  <div class="row">
    <!-- Left: Visuals -->
    <div class="col-lg-8 mb-4">
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Split Diagram</h5>
          <div class="small text-muted">Train (blue) • Validation (purple) • Test (orange)</div>
        </div>
        <div class="card-body">
          <canvas id="splitCanvas"></canvas>
          <div id="leakWarn" class="warn mt-2">Warning: Preprocessing before splitting can leak information. Fit transformers inside each training fold.</div>
        </div>
      </div>

      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Per-Fold Metrics</h5>
          <div class="small text-muted">Choose metric on the right; see mean ± std across folds</div>
        </div>
        <div class="card-body">
          <div class="chart-container-lg mb-2">
            <canvas id="metricChart"></canvas>
          </div>
          <div class="mt-1">
            <span class="badge badge-success metric-badge" id="mMean">Mean: —</span>
            <span class="badge badge-secondary metric-badge" id="mStd">Std: —</span>
            <span class="badge badge-primary metric-badge" id="mTime">Runtime (sim): —</span>
          </div>
        </div>
      </div>

      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">ROC & PR (pooled across validation folds)</h5>
          <div class="small text-muted">Discrimination performance; PR is more informative for rare positives</div>
        </div>
        <div class="card-body">
          <div class="chart-container-sm mb-3"><canvas id="rocChart"></canvas></div>
          <div class="chart-container-sm"><canvas id="prChart"></canvas></div>
          <div class="mt-2">
            <span class="badge badge-primary metric-badge" id="mROC">ROC-AUC: —</span>
            <span class="badge badge-info metric-badge" id="mPR">PR-AUC: —</span>
            <span class="badge badge-warning metric-badge" id="mLogLoss">Log Loss: —</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <div class="control-section">
        <h6>Validation Method</h6>
        <div class="form-group">
          <label class="control-label" for="method">Method</label>
          <select class="form-control" id="method">
            <option value="holdout">Hold-out</option>
            <option value="kfold" selected>K-Fold</option>
            <option value="rkfold">Repeated K-Fold</option>
            <option value="nested">Nested CV</option>
            <option value="groupk">Group K-Fold</option>
            <option value="timeseries">Time-Series (walk-forward)</option>
          </select>
        </div>
        <div class="form-group">
          <label class="control-label">Folds (outer): <strong id="foldLbl">5</strong></label>
          <input type="range" id="folds" min="2" max="10" step="1" value="5" class="form-range">
        </div>
        <div class="form-group" id="repWrap">
          <label class="control-label">Repeats: <strong id="repLbl">2</strong></label>
          <input type="range" id="repeats" min="1" max="10" step="1" value="2" class="form-range">
        </div>
        <div class="form-group" id="innerWrap" style="display:none;">
          <label class="control-label">Inner folds (nested): <strong id="innerLbl">3</strong></label>
          <input type="range" id="innerFolds" min="2" max="10" step="1" value="3" class="form-range">
        </div>
      </div>

      <div class="control-section">
        <h6>Data & Splits</h6>
        <div class="form-group">
          <label class="control-label">Samples (N): <strong id="nLbl">10,000</strong></label>
          <input type="range" id="nSamples" min="1000" max="50000" step="1000" value="10000" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Class imbalance P(y=1): <strong id="imbLbl">0.30</strong></label>
          <input type="range" id="imbalance" min="0.01" max="0.99" step="0.01" value="0.30" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Train size (hold-out): <strong id="trainLbl">70%</strong></label>
          <input type="range" id="trainPct" min="50" max="90" step="1" value="70" class="form-range">
        </div>
        <div class="form-group" id="groupWrap" style="display:none;">
          <label class="control-label"># Groups (GroupKFold): <strong id="grpLbl">100</strong></label>
          <input type="range" id="nGroups" min="10" max="1000" step="10" value="100" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Score separation: <strong id="sepLbl">2.0</strong></label>
          <input type="range" id="separation" min="0" max="5" step="0.1" value="2.0" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Noise (σ): <strong id="noiseLbl">1.0</strong></label>
          <input type="range" id="noise" min="0.2" max="3.0" step="0.1" value="1.0" class="form-range">
        </div>
        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="leakage">
          <label class="form-check-label" for="leakage">Apply preprocessing before split (leakage)</label>
        </div>
        <div class="form-group">
          <label class="control-label">Metric</label>
          <select class="form-control" id="metricSel">
            <option value="accuracy">Accuracy</option>
            <option value="rocauc" selected>ROC-AUC</option>
            <option value="prauc">PR-AUC</option>
            <option value="logloss">Log Loss</option>
          </select>
        </div>
        <div class="row g-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnRun">Run</button></div>
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
    <p class="mb-2"><strong>Hold-out vs Cross-Validation:</strong> Hold-out is fast for large data; K-fold and Repeated K-fold give more stable estimates on smaller datasets.</p>
    <p class="mb-2"><strong>Nested CV:</strong> Use an inner loop to tune hyperparameters and an outer loop to estimate unbiased performance of the tuned model.</p>
    <p class="mb-2"><strong>Group & Time-Series:</strong> Keep groups intact (GroupKFold) and preserve time order (walk-forward) to avoid leakage.</p>
    <p class="mb-0"><strong>Leakage:</strong> Fit preprocessing inside each training fold. If you flip the leakage toggle, watch metrics become unrealistically optimistic.</p>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>

<script>
(function(){
  'use strict';
  function $(id){ return document.getElementById(id); }
  function clamp(x,a,b){ return Math.max(a, Math.min(b, x)); }
  function sigmoid(z){ return 1/(1+Math.exp(-clamp(z,-60,60))); }
  function shuffle(a, seed){
    // simple LCG for reproducible shuffle
    var m=0x80000000, a1=1103515245, c=12345;
    var s = seed>>>0;
    function rnd(){ s=(a1*s+c)%m; return s/m; }
    for (var i=a.length-1;i>0;i--){ var j=Math.floor(rnd()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; }
    return a;
  }
  function mean(arr){ var s=0; for (var i=0;i<arr.length;i++) s+=arr[i]; return s/arr.length; }
  function std(arr){ var mu=mean(arr); var s=0; for (var i=0;i<arr.length;i++){ var d=arr[i]-mu; s+=d*d; } return Math.sqrt(s/arr.length); }

  // Data generation
  function genData(N, p1, sep, sig, seed){
    var muPos=+sep/2, muNeg=-sep/2;
    var y=new Array(N), x=new Float32Array(N);
    var s=seed>>>0;
    function rnd(){ s=(1664525*s+1013904223)>>>0; return (s>>>1)/2147483648; }
    for (var i=0;i<N;i++){
      var isPos = rnd()<p1 ? 1 : 0;
      y[i]=isPos;
      // Box-Muller
      var u = Math.max(1e-12, rnd()), v = rnd();
      var z = Math.sqrt(-2*Math.log(u)) * Math.cos(2*Math.PI*v);
      var score = (isPos?muPos:muNeg) + sig*z;
      x[i]=score;
    }
    return {x:x, y:y};
  }

  // Preprocessing (standardize)
  function fitScaler(x){ var s=0, s2=0; for (var i=0;i<x.length;i++){ s+=x[i]; s2+=x[i]*x[i]; } var mu=s/x.length; var v=s2/x.length - mu*mu; return {mu:mu, sd: Math.sqrt(Math.max(v,1e-12))}; }
  function transformScaler(scaler, x){ var out=new Float32Array(x.length); for (var i=0;i<x.length;i++){ out[i]=(x[i]-scaler.mu)/scaler.sd; } return out; }

  // Logistic fit (few GD steps for demo)
  function fitLogistic(x, y){
    var a=1, b=0, lr=0.1, iters=120;
    for (var t=0;t<iters;t++){
      var ga=0, gb=0;
      for (var i=0;i<x.length;i++){
        var p = sigmoid(a*x[i] + b);
        var e = p - y[i];
        ga += e * x[i];
        gb += e;
      }
      a -= lr * ga / x.length;
      b -= lr * gb / x.length;
    }
    return {a:a, b:b};
  }
  function predictProb(model, x){ var out=new Float32Array(x.length); for (var i=0;i<x.length;i++){ out[i]=sigmoid(model.a*x[i] + model.b); } return out; }

  // Metrics
  function logLoss(y, p){ var s=0; for (var i=0;i<y.length;i++){ s += - (y[i]*Math.log(p[i]+1e-12) + (1-y[i])*Math.log(1-p[i]+1e-12)); } return s/y.length; }
  function accuracy(y, p){ var c=0; for (var i=0;i<y.length;i++){ c += ((p[i]>=0.5?1:0)===y[i]); } return c/y.length; }
  function rocAuc(y, p){
    var idx = y.map(function(_,i){return i;}).sort(function(a,b){ return p[a]-p[b]; });
    var rank = new Float64Array(y.length); for (var i=0;i<idx.length;i++) rank[idx[i]]=i+1;
    var pos=0, sumR=0; for (var k=0;k<y.length;k++){ if (y[k]===1){ pos++; sumR+=rank[k]; } }
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
      auc += (rec - prevR) * prec; prevR = rec;
    }
    return clamp(auc,0,1);
  }

  // Splits
  function range(n){ var a=new Array(n); for (var i=0;i<n;i++) a[i]=i; return a; }
  function kfoldIndices(n, k, seed){
    var idx = shuffle(range(n), seed);
    var folds = new Array(k); for (var i=0;i<k;i++) folds[i]=[];
    for (var i=0;i<n;i++){ folds[i%k].push(idx[i]); }
    var splits=[];
    for (var i=0;i<k;i++){
      var test = folds[i].slice();
      var train=[];
      for (var j=0;j<k;j++){ if (j!==i) train = train.concat(folds[j]); }
      splits.push({train:train, test:test, label:'Fold '+(i+1)});
    }
    return splits;
  }
  function repeatedKfold(n, k, r, seed){
    var out=[]; for (var i=0;i<r;i++){ out = out.concat(kfoldIndices(n,k,seed+i)); } return out;
  }
  function holdoutIndices(n, pct, seed){
    var idx = shuffle(range(n), seed);
    var ntr = Math.floor(n*pct/100);
    return [{train: idx.slice(0,ntr), test: idx.slice(ntr), label:'Hold-out'}];
  }
  function groupKFold(n, k, nGroups, seed){
    var groups = new Array(n); for (var i=0;i<n;i++) groups[i] = Math.floor(i / Math.max(1, Math.floor(n/nGroups)));
    var gidx = shuffle(range(nGroups), seed);
    var folds = new Array(k); for (var i=0;i<k;i++) folds[i]=[];
    for (var gi=0;gi<nGroups;gi++){ folds[gi%k].push(gidx[gi]); }
    var splits=[];
    for (var f=0;f<k;f++){
      var testGroups = new Set(folds[f]);
      var train=[], test=[];
      for (var i=0;i<n;i++){ (testGroups.has(groups[i])?test:train).push(i); }
      splits.push({train:train, test:test, label:'Fold '+(f+1)});
    }
    return splits;
  }
  function timeSeriesSplits(n, k){
    var splits=[], step = Math.floor(n/(k+1));
    for (var i=1;i<=k;i++){
      var trainEnd = step*i, testEnd = Math.min(n, trainEnd + step);
      var train = range(trainEnd), test = range(trainEnd, testEnd);
      // polyfill for range(a,b):
      function range(a,b){ var arr=[]; for (var t=a;t<b;t++) arr.push(t); return arr; }
      splits.push({train:train, test:test, label:'T'+i});
    }
    return splits;
  }

  // Draw split diagram
  function drawSplits(canvas, splits, n, method){
    var ctx = canvas.getContext('2d');
    var w = canvas.width = canvas.clientWidth;
    var h = canvas.height = canvas.clientHeight;
    ctx.clearRect(0,0,w,h);
    var rows = Math.min(splits.length, 12);
    var rowH = (h-20)/rows;
    for (var r=0;r<rows;r++){
      var s = splits[r];
      var y = 10 + r*rowH + 4;
      // background
      ctx.fillStyle='#f1f3f5'; ctx.fillRect(10, y, w-20, rowH-8);
      // train (blue)
      ctx.fillStyle='#0d6efd';
      s.train.forEach(function(i){
        var x = 10 + (w-20)* (i/(n-1));
        ctx.fillRect(x, y, Math.max(1,(w-20)/n), rowH-8);
      });
      // test (orange)
      ctx.fillStyle='#fd7e14';
      s.test.forEach(function(i){
        var x = 10 + (w-20)* (i/(n-1));
        ctx.fillRect(x, y, Math.max(1,(w-20)/n), rowH-8);
      });
      // label
      ctx.fillStyle='#495057';
      ctx.font='12px system-ui';
      ctx.fillText(s.label, 14, y-2);
    }
  }

  // Charts
  var metricChart = new Chart($('metricChart').getContext('2d'), {
    type:'bar',
    data:{ labels:[], datasets:[{ label:'Score', data:[], backgroundColor:'#198754' }] },
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{display:false} }, scales:{ y:{ min:0, max:1 } } }
  });
  var rocChart = new Chart($('rocChart').getContext('2d'), {
    type:'line',
    data:{ labels:[], datasets:[
      { label:'ROC', data:[], borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.15)', fill:true, pointRadius:0, tension:0.2 },
      { label:'Chance', data:[{x:0,y:0},{x:1,y:1}], borderColor:'#6c757d', borderDash:[6,4], pointRadius:0 }
    ] },
    options:{ responsive:true, maintainAspectRatio:false, parsing:false, plugins:{ legend:{display:true} },
      scales:{ x:{ min:0, max:1, title:{display:true,text:'FPR'} }, y:{ min:0, max:1, title:{display:true,text:'TPR'} } } }
  });
  var prChart = new Chart($('prChart').getContext('2d'), {
    type:'line',
    data:{ labels:[], datasets:[
      { label:'PR', data:[], borderColor:'#20c997', backgroundColor:'rgba(32,201,151,0.15)', fill:true, pointRadius:0, tension:0.2 }
    ] },
    options:{ responsive:true, maintainAspectRatio:false, parsing:false, plugins:{ legend:{display:true} },
      scales:{ x:{ min:0, max:1, title:{display:true,text:'Recall'} }, y:{ min:0, max:1, title:{display:true,text:'Precision'} } } }
  });

  function computeMetric(name, y, p){
    if (name==='accuracy') return accuracy(y,p);
    if (name==='rocauc') return rocAuc(y,p);
    if (name==='prauc') return prAuc(y,p);
    if (name==='logloss') return 1 - (logLoss(y,p) / Math.log(2)); // convert to [0,1] style score for bar; lower loss = higher score
    return rocAuc(y,p);
  }

  function pooledCurves(yAll, pAll){
    // ROC
    var ord = yAll.map(function(v,i){ return {y:v, p:pAll[i]}; }).sort(function(a,b){ return b.p-a.p; });
    var P = yAll.reduce(function(s,v){return s+(v===1?1:0);},0), N=yAll.length-P;
    var tpr=[], fpr=[], tp=0, fp=0, last=Infinity;
    for (var i=0;i<ord.length;i++){
      if (ord[i].p !== last){ fpr.push(fp/N); tpr.push(tp/P); last = ord[i].p; }
      if (ord[i].y===1) tp++; else fp++;
    }
    fpr.push(1); tpr.push(1);
    // PR
    var tp2=0, fp2=0, fn2=P, prec=[], rec=[];
    for (var j=0;j<ord.length;j++){
      if (ord[j].y===1){ tp2++; fn2--; } else { fp2++; }
      var r = tp2/(tp2+fn2+1e-12), pr = tp2/(tp2+fp2+1e-12);
      rec.push(r); prec.push(pr);
    }
    return { roc:{xs:fpr, ys:tpr}, pr:{xs:rec, ys:prec} };
  }

  function evaluateSplits(data, splits, leakage, metricName){
    var d = data;
    var foldScores = [];
    var yPool=[], pPool=[];
    var t0 = performance.now();

    for (var s=0;s<splits.length;s++){
      var tr = splits[s].train, te = splits[s].test;
      var xtr = new Float32Array(tr.length), ytr = new Array(tr.length);
      var xte = new Float32Array(te.length), yte = new Array(te.length);
      for (var i=0;i<tr.length;i++){ xtr[i] = d.x[tr[i]]; ytr[i] = d.y[tr[i]]; }
      for (var j=0;j<te.length;j++){ xte[j] = d.x[te[j]]; yte[j] = d.y[te[j]]; }

      var scaler;
      if (leakage){ scaler = fitScaler(d.x); } else { scaler = fitScaler(xtr); }
      xtr = transformScaler(scaler, xtr);
      xte = transformScaler(scaler, xte);

      var model = fitLogistic(xtr, ytr);
      var p = predictProb(model, xte);

      var foldScore = computeMetric(metricName, yte, p);
      foldScores.push(foldScore);

      // pool for curves
      for (var q=0;q<p.length;q++){ yPool.push(yte[q]); pPool.push(p[q]); }
    }

    var t1 = performance.now();

    // Charts: per-fold bars
    metricChart.data.labels = splits.map(function(s){ return s.label; });
    metricChart.data.datasets[0].data = foldScores;
    metricChart.update('none');

    // Summary badges
    $('mMean').textContent = 'Mean: ' + mean(foldScores).toFixed(3);
    $('mStd').textContent  = 'Std: ' + std(foldScores).toFixed(3);
    $('mTime').textContent = 'Runtime (sim): ' + (t1-t0).toFixed(0) + ' ms';

    // Pooled curves + badges
    var curves = pooledCurves(yPool, pPool);
    rocChart.data.labels = curves.roc.xs;
    rocChart.data.datasets[0].data = curves.roc.xs.map(function(x,i){ return {x:x, y:curves.roc.ys[i]}; });
    rocChart.update('none');

    prChart.data.labels = curves.pr.xs;
    prChart.data.datasets[0].data = curves.pr.xs.map(function(x,i){ return {x:x, y:curves.pr.ys[i]}; });
    prChart.update('none');

    $('mROC').textContent = 'ROC-AUC: ' + rocAuc(yPool, pPool).toFixed(3);
    $('mPR').textContent  = 'PR-AUC: ' + prAuc(yPool, pPool).toFixed(3);
    $('mLogLoss').textContent = 'Log Loss: ' + logLoss(yPool, pPool).toFixed(3);
  }

  function buildSplits(n, method, k, repeats, trainPct, nGroups){
    if (method==='holdout') return holdoutIndices(n, trainPct, 42);
    if (method==='kfold')   return kfoldIndices(n, k, 42);
    if (method==='rkfold')  return repeatedKfold(n, k, repeats, 1337);
    if (method==='groupk')  return groupKFold(n, k, nGroups, 42);
    if (method==='timeseries') return timeSeriesSplits(n, k);
    return kfoldIndices(n, k, 42);
  }

  // UI state and handlers
  function syncVisibility(){
    var method = $('method').value;
    $('repWrap').style.display = (method==='rkfold') ? '' : 'none';
    $('innerWrap').style.display = (method==='nested') ? '' : 'none';
    $('groupWrap').style.display = (method==='groupk') ? '' : 'none';
    $('leakWarn').style.display = $('leakage').checked ? '' : 'none';
  }

  function run(){
    syncVisibility();

    var method = $('method').value;
    var folds  = parseInt($('folds').value,10);
    var repeats= parseInt($('repeats').value,10);
    var inner  = parseInt($('innerFolds').value,10);
    var N      = parseInt($('nSamples').value,10);
    var p1     = parseFloat($('imbalance').value);
    var trainP = parseInt($('trainPct').value,10);
    var groups = parseInt($('nGroups').value,10);
    var sep    = parseFloat($('separation').value);
    var sig    = parseFloat($('noise').value);
    var leak   = $('leakage').checked;
    var metric = $('metricSel').value;

    $('foldLbl').textContent = folds;
    $('repLbl').textContent  = repeats;
    $('innerLbl').textContent= inner;
    $('nLbl').textContent    = N.toLocaleString();
    $('imbLbl').textContent  = p1.toFixed(2);
    $('trainLbl').textContent= trainP + '%';
    $('grpLbl').textContent  = groups;
    $('sepLbl').textContent  = sep.toFixed(1);
    $('noiseLbl').textContent= sig.toFixed(1);

    var data = genData(N, p1, sep, sig, 123);
    var splits;

    if (method==='nested'){
      // Outer CV
      splits = kfoldIndices(N, folds, 2025);
      var foldScores = [];
      var yPool=[], pPool=[];
      var t0 = performance.now();

      for (var o=0;o<splits.length;o++){
        var outer = splits[o];
        // Build inner splits on outer.train
        var innerIdx = outer.train.slice();
        // Map inner indices to 0..M-1 for convenience
        var map = new Map(); for (var i=0;i<innerIdx.length;i++) map.set(innerIdx[i], i);
        var innerSplits = kfoldIndices(innerIdx.length, inner, 888+o);
        // Try hyperparams (here: learning rate scale/apply strong regularization)
        var cands = [0.5, 1.0, 2.0];
        var candScores = new Array(cands.length).fill(0);

        for (var c=0;c<cands.length;c++){
          var scores = [];
          for (var s=0;s<innerSplits.length;s++){
            var tr = innerSplits[s].train.map(function(ix){ return innerIdx[ix]; });
            var te = innerSplits[s].test.map(function(ix){ return innerIdx[ix]; });

            // Extract, scale (no leakage within inner)
            var xtr=new Float32Array(tr.length), ytr=new Array(tr.length);
            var xte=new Float32Array(te.length), yte=new Array(te.length);
            for (var i2=0;i2<tr.length;i2++){ xtr[i2]=data.x[tr[i2]]; ytr[i2]=data.y[tr[i2]]; }
            for (var j2=0;j2<te.length;j2++){ xte[j2]=data.x[te[j2]]; yte[j2]=data.y[te[j2]]; }
            var scaler=fitScaler(xtr); xtr=transformScaler(scaler,xtr); xte=transformScaler(scaler,xte);

            // Fit with scaled learning rate proxy by multiple GD passes
            var model = fitLogistic(xtr, ytr);
            // simple proxy for hyperparam effect: adjust bias by candidate
            model.b *= cands[c];
            var p = predictProb(model, xte);
            scores.push(computeMetric('rocauc', yte, p));
          }
          candScores[c]=mean(scores);
        }
        // choose best
        var bestC = cands[candScores.indexOf(Math.max.apply(null, candScores))];

        // Evaluate on outer test
        var trO = outer.train, teO = outer.test;
        var xtrO=new Float32Array(trO.length), ytrO=new Array(trO.length);
        var xteO=new Float32Array(teO.length), yteO=new Array(teO.length);
        for (var a=0;a<trO.length;a++){ xtrO[a]=data.x[trO[a]]; ytrO[a]=data.y[trO[a]]; }
        for (var b=0;b<teO.length;b++){ xteO[b]=data.x[teO[b]]; yteO[b]=data.y[teO[b]]; }

        var scalerO = leak ? fitScaler(data.x) : fitScaler(xtrO);
        xtrO=transformScaler(scalerO,xtrO); xteO=transformScaler(scalerO,xteO);
        var modelO = fitLogistic(xtrO, ytrO);
        modelO.b *= bestC;
        var pO = predictProb(modelO, xteO);

        foldScores.push(computeMetric(metric, yteO, pO));
        for (var q=0;q<pO.length;q++){ yPool.push(yteO[q]); pPool.push(pO[q]); }
      }

      var t1 = performance.now();
      metricChart.data.labels = splits.map(function(s){ return s.label; });
      metricChart.data.datasets[0].data = foldScores;
      metricChart.update('none');

      $('mMean').textContent = 'Mean: ' + mean(foldScores).toFixed(3);
      $('mStd').textContent  = 'Std: ' + std(foldScores).toFixed(3);
      $('mTime').textContent = 'Runtime (sim): ' + (t1 - t0).toFixed(0) + ' ms';

      var curves = pooledCurves(yPool, pPool);
      rocChart.data.datasets[0].data = curves.roc.xs.map(function(x,i){ return {x:x, y:curves.roc.ys[i]}; });
      rocChart.update('none');
      prChart.data.datasets[0].data = curves.pr.xs.map(function(x,i){ return {x:x, y:curves.pr.ys[i]}; });
      prChart.update('none');

      $('mROC').textContent = 'ROC-AUC: ' + rocAuc(yPool, pPool).toFixed(3);
      $('mPR').textContent  = 'PR-AUC: ' + prAuc(yPool, pPool).toFixed(3);
      $('mLogLoss').textContent = 'Log Loss: ' + logLoss(yPool, pPool).toFixed(3);

      drawSplits($('splitCanvas'), splits, N, 'nested');
      return;
    }

    // Non-nested methods
    splits = buildSplits(N, method, folds, repeats, trainP, groups);
    evaluateSplits(data, splits, leak, metric);
    drawSplits($('splitCanvas'), splits, N, method);
  }

  // Bindings
  ['method','folds','repeats','innerFolds','nSamples','imbalance','trainPct','nGroups','separation','noise','leakage','metricSel'].forEach(function(id){
    $(id).addEventListener('input', run);
  });
  $('btnRun').addEventListener('click', run);
  $('btnReset').addEventListener('click', function(){
    $('method').value='kfold';
    $('folds').value=5; $('repeats').value=2; $('innerFolds').value=3;
    $('nSamples').value=10000; $('imbalance').value=0.30; $('trainPct').value=70; $('nGroups').value=100;
    $('separation').value=2.0; $('noise').value=1.0; $('leakage').checked=false; $('metricSel').value='rocauc';
    run();
  });

  // Init
  run();
})();
</script>
</html>
