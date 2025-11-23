<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Bias–Variance Tradeoff Explorer - Interactive underfitting vs overfitting demo using polynomial regression on a noisy sine dataset with training/validation error curves and sweet spot.">
<meta name="keywords" content="bias variance tradeoff visual, underfitting vs overfitting demo, polynomial regression visualization, ML generalization, bias variance graph">
<title>Bias–Variance Tradeoff Explorer Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Bias–Variance Tradeoff Explorer",
  "description": "Interactive visualization of the bias–variance tradeoff with polynomial regression on a noisy sine dataset. Compare training vs validation error and find the sweet spot.",
  "url": "https://8gwifi.org/bias_variance_tradeoff.jsp",
  "keywords": "bias variance tradeoff visual, underfitting vs overfitting demo, polynomial regression visualization, machine learning generalization"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .bv { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:260px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .metric-card { background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-label { font-size:12px; opacity:0.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }
  .small-note { font-size:12px; color:#6c757d; }
  .dot-train { width:10px; height:10px; border-radius:50%; background:#0d6efd; display:inline-block; margin-right:6px; }
  .dot-val { width:10px; height:10px; border-radius:50%; background:#198754; display:inline-block; margin-right:6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Bias–Variance Tradeoff Explorer</h1>
<p>See underfitting vs overfitting with polynomial regression on a noisy sine curve. Compare training vs validation error and find the “sweet spot”.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#curves" class="btn btn-outline-primary">Error Curves</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="bv">
  <div class="row">
    <!-- Left: Data + Fit -->
    <div class="col-lg-8 mb-4">
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Noisy Sine Data & Polynomial Fit</h5>
          <div class="small">
            <span class="small-note"><span class="dot-train"></span>Train • <span class="dot-val" style="background:#6f42c1;"></span>Val</span>
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="fitChart"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Blue dots = train, purple dots = validation, black line = true sine, orange line = fitted polynomial.</small>

          <div class="row mt-3">
            <div class="col-md-4">
              <div class="metric-card">
                <div class="metric-label">Train MSE</div>
                <div class="metric-value" id="mTrain">—</div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="metric-card" style="background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%);">
                <div class="metric-label">Val MSE</div>
                <div class="metric-value" id="mVal">—</div>
              </div>
            </div>
            <div class="col-md-4 small-note d-flex align-items-center">
              Degree ↑ → more flexible (risk overfit). Lambda ↑ → smoother (less variance).
            </div>
          </div>
        </div>
      </div>

      <!-- Error Curves -->
      <div class="card mb-4" id="curves">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Training vs Validation Error</h5>
          <small class="text-muted">Sweet spot = lowest validation error</small>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="errChart"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Hover to see per-degree errors. Vertical line marks the degree with minimal validation error.</small>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Data -->
      <div class="control-section">
        <h6>📦 Data</h6>
        <div class="slider-label"><span>Train size</span><strong id="nTrainLbl">60</strong></div>
        <input type="range" id="nTrain" min="20" max="200" step="5" value="60" class="form-range">

        <div class="slider-label"><span>Val size</span><strong id="nValLbl">40</strong></div>
        <input type="range" id="nVal" min="20" max="200" step="5" value="40" class="form-range">

        <div class="slider-label"><span>Noise σ</span><strong id="noiseLbl">0.20</strong></div>
        <input type="range" id="noise" min="0" max="0.8" step="0.01" value="0.20" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnGen">Generate</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnSeed">Randomize Seed</button></div>
        </div>
      </div>

      <!-- Model -->
      <div class="control-section">
        <h6>🤖 Model (Polynomial Regression)</h6>
        <div class="slider-label"><span>Degree</span><strong id="degLbl">5</strong></div>
        <input type="range" id="degree" min="0" max="20" step="1" value="5" class="form-range">

        <div class="slider-label"><span>Lambda (L2)</span><strong id="lamLbl">0.00</strong></div>
        <input type="range" id="lambda" min="0" max="1" step="0.01" value="0.00" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-success btn-sm w-100" id="btnFit">Fit</button></div>
          <div class="col"><button class="btn btn-outline-primary btn-sm w-100" id="btnSweep">Compute Curve</button></div>
        </div>
      </div>

      <!-- Sweet spot -->
      <div class="control-section">
        <h6>⭐ Sweet Spot</h6>
        <div class="small">
          Best degree: <strong id="bestDeg">—</strong><br>
          Train/Val MSE at best: <strong id="bestTrain">—</strong> / <strong id="bestVal">—</strong>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function(){
  function $(id){ return document.getElementById(id); }
  function rand(){ return Math.random(); }
  function randn(){ var u=0,v=0; while(u===0)u=rand(); while(v===0)v=rand(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }

  // State
  var seed = 42;
  function sr(){ // seeded random 0..1
    var x = Math.sin(seed++) * 10000; return x - Math.floor(x);
  }

  // Data
  var trainX=[], trainY=[], valX=[], valY=[];

  function trueFn(x){ return Math.sin(2*Math.PI*x); }

  function genData(){
    var nTr=parseInt($('nTrain').value), nVa=parseInt($('nVal').value), sigma=parseFloat($('noise').value);
    trainX=[]; trainY=[]; valX=[]; valY=[];
    for(var i=0;i<nTr;i++){
      var x = sr(); var y = trueFn(x) + sigma*randn();
      trainX.push(x); trainY.push(y);
    }
    for(var j=0;j<nVa;j++){
      var x2 = sr(); var y2 = trueFn(x2) + sigma*randn();
      valX.push(x2); valY.push(y2);
    }
  }

  // Poly features up to degree d
  function polyFeatures(xArr, d){
    var X=[];
    for(var i=0;i<xArr.length;i++){
      var row=new Array(d+1);
      var x = xArr[i];
      var p=1;
      for(var k=0;k<=d;k++){
        row[k]=p;
        p*=x;
      }
      X.push(row);
    }
    return X;
  }

  // Normal equation: theta = (X^T X + lam I)^-1 X^T y
  function fitRidge(X, y, lam){
    var XT = transpose(X);
    var XTX = matMul(XT, X);
    // add lam*I
    for(var i=0;i<XTX.length;i++){ XTX[i][i] += lam; }
    var XTy = matVec(XT, y);
    var theta = solveSymmetric(XTX, XTy);
    return theta;
  }

  function predict(X, theta){
    var y=new Array(X.length);
    for(var i=0;i<X.length;i++){
      var s=0;
      for(var k=0;k<theta.length;k++) s+= X[i][k]*theta[k];
      y[i]=s;
    }
    return y;
  }

  function mse(y, yhat){
    var s=0;
    for(var i=0;i<y.length;i++){
      var d=yhat[i]-y[i];
      s+=d*d;
    }
    return y.length>0 ? s/y.length : 0;
  }

  // Minimal matrix utils
  function transpose(A){
    var m=A.length, n=A[0].length, T=new Array(n);
    for(var i=0;i<n;i++){ T[i]=new Array(m); }
    for(var r=0;r<m;r++){ for(var c=0;c<n;c++){ T[c][r]=A[r][c]; } }
    return T;
  }
  function matMul(A,B){
    var m=A.length, n=A[0].length, p=B[0].length;
    var C=new Array(m);
    for(var i=0;i<m;i++){
      C[i]=new Array(p);
      for(var j=0;j<p;j++){
        var s=0;
        for(var k=0;k<n;k++) s+=A[i][k]*B[k][j];
        C[i][j]=s;
      }
    }
    return C;
  }
  function matVec(A, v){
    var m=A.length, n=A[0].length;
    var out=new Array(m);
    for(var i=0;i<m;i++){
      var s=0;
      for(var j=0;j<n;j++) s+=A[i][j]*v[j];
      out[i]=s;
    }
    return out;
  }
  // Solve symmetric positive-definite with Gaussian elimination (basic)
  function solveSymmetric(A, b){
    // Copy
    var n=A.length;
    var M=new Array(n);
    for(var i=0;i<n;i++){ M[i]=A[i].slice(); }
    var x=b.slice();
    // Forward elimination
    for(var k=0;k<n;k++){
      var piv=M[k][k];
      if(Math.abs(piv)<1e-12){ // jitter
        M[k][k]+=1e-8; piv=M[k][k];
      }
      for(var j=k;j<n;j++){ M[k][j]/=piv; }
      x[k]/=piv;
      for(var i=k+1;i<n;i++){
        var f=M[i][k];
        for(var j=k;j<n;j++){ M[i][j]-=f*M[k][j]; }
        x[i]-=f*x[k];
      }
    }
    // Back substitution
    for(var i=n-1;i>=0;i--){
      var s=x[i];
      for(var j=i+1;j<n;j++){ s-=M[i][j]*x[j]; }
      x[i]=s; // diag normalized to 1
    }
    return x;
  }

  // Charts
  var fitChart = new Chart($('fitChart'), {
    type:'scatter',
    data:{ datasets:[
      {label:'Train', data:[], pointRadius:3, backgroundColor:'#0d6efd'},
      {label:'Val',   data:[], pointRadius:3, backgroundColor:'#6f42c1'},
      {label:'True f(x)', type:'line', data:[], parsing:false, borderColor:'#212529', borderWidth:2, pointRadius:0},
      {label:'Fit', type:'line', data:[], parsing:false, borderColor:'#fd7e14', borderWidth:2, pointRadius:0}
    ]},
    options:{
      responsive:true, maintainAspectRatio:false,
      scales:{ x:{ min:0, max:1, title:{display:true,text:'x'}}, y:{ min:-1.5, max:1.5, title:{display:true,text:'y'} } },
      plugins:{ legend:{ display:true } }
    }
  });

  var errChart = new Chart($('errChart'), {
    type:'line',
    data:{ labels:[], datasets:[
      {label:'Train MSE', data:[], borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.1)', tension:0.2},
      {label:'Val MSE',   data:[], borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.1)', tension:0.2}
    ]},
    options:{ responsive:true, maintainAspectRatio:false,
      scales:{ x:{ title:{display:true,text:'Degree'}}, y:{ title:{display:true,text:'MSE'}, min:0 } },
      plugins:{ legend:{ display:true }, annotation:{} }
    }
  });

  // Annotation (vertical line) helper
  function markSweetSpot(idx){
    // Simple marker by updating dataset point styles + console note
    // For simplicity without extra plugin, we can set a small dot on the minimum validation
    // We'll also show values in the Sweet Spot box.
  }

  // Update charts with current fit
  function refreshFit(){
    var d=parseInt($('degree').value), lam=parseFloat($('lambda').value);
    var Xtr=polyFeatures(trainX, d), Xva=polyFeatures(valX, d);
    var theta=fitRidge(Xtr, trainY, lam);
    var yhatTr=predict(Xtr, theta), yhatVa=predict(Xva, theta);
    var mtr=mse(trainY, yhatTr), mva=mse(valY, yhatVa);
    $('mTrain').textContent=mtr.toFixed(4);
    $('mVal').textContent=mva.toFixed(4);

    // update scatter/fits
    fitChart.data.datasets[0].data = trainX.map(function(x,i){ return {x:x, y:trainY[i]}; });
    fitChart.data.datasets[1].data = valX.map(function(x,i){ return {x:x, y:valY[i]}; });

    // true function
    var xs=[], ys=[], ysFit=[];
    var N=200;
    for(var i=0;i<=N;i++){
      var x=i/N;
      xs.push(x);
    }
    var Xgrid=polyFeatures(xs, d);
    var yfit=predict(Xgrid, theta);
    for(var i2=0;i2<xs.length;i2++){
      ys.push(trueFn(xs[i2]));
      ysFit.push(yfit[i2]);
    }
    fitChart.data.datasets[2].data = xs.map(function(x,i){ return {x:x, y:ys[i]}; });
    fitChart.data.datasets[3].data = xs.map(function(x,i){ return {x:x, y:ysFit[i]}; });
    fitChart.update('none');
  }

  function sweepCurve(){
    var lam=parseFloat($('lambda').value);
    var maxD=20;
    var degrees=[], tr=[], va=[];
    for(var d=0; d<=maxD; d++){
      var Xtr=polyFeatures(trainX, d), Xva=polyFeatures(valX, d);
      var theta=fitRidge(Xtr, trainY, lam);
      var yhatTr=predict(Xtr, theta), yhatVa=predict(Xva, theta);
      tr.push(mse(trainY, yhatTr));
      va.push(mse(valY, yhatVa));
      degrees.push(d);
    }
    errChart.data.labels = degrees;
    errChart.data.datasets[0].data = tr;
    errChart.data.datasets[1].data = va;

    // sweet spot (min val)
    var minIdx=0, minVal=va[0];
    for(var i=1;i<va.length;i++){ if(va[i]<minVal){ minVal=va[i]; minIdx=i; } }
    $('bestDeg').textContent = degrees[minIdx];
    $('bestTrain').textContent = tr[minIdx].toFixed(4);
    $('bestVal').textContent = va[minIdx].toFixed(4);

    errChart.update('none');
  }

  // UI bindings
  $('nTrain').addEventListener('input', function(){ $('nTrainLbl').textContent=this.value; });
  $('nVal').addEventListener('input', function(){ $('nValLbl').textContent=this.value; });
  $('noise').addEventListener('input', function(){ $('noiseLbl').textContent=parseFloat(this.value).toFixed(2); });

  $('degree').addEventListener('input', function(){ $('degLbl').textContent=this.value; refreshFit(); });
  $('lambda').addEventListener('input', function(){ $('lamLbl').textContent=parseFloat(this.value).toFixed(2); refreshFit(); });

  $('btnGen').addEventListener('click', function(){ genData(); refreshFit(); sweepCurve(); });
  $('btnSeed').addEventListener('click', function(){ seed = Math.floor(Math.random()*100000); genData(); refreshFit(); sweepCurve(); });
  $('btnFit').addEventListener('click', function(){ refreshFit(); });
  $('btnSweep').addEventListener('click', function(){ sweepCurve(); });

  // Init
  $('nTrainLbl').textContent=$('nTrain').value;
  $('nValLbl').textContent=$('nVal').value;
  $('noiseLbl').textContent=parseFloat($('noise').value).toFixed(2);
  $('degLbl').textContent=$('degree').value;
  $('lamLbl').textContent=parseFloat($('lambda').value).toFixed(2);

  genData();
  refreshFit();
  sweepCurve();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">Underfitting vs Overfitting: find the sweet spot</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>How to use</h6>
        <ol class="mb-2">
          <li>Click Generate to sample a new train/validation set from a noisy sine.</li>
          <li>Move the <strong>Degree</strong> slider to change model complexity; <strong>Lambda</strong> adds smoothing.</li>
          <li>Click “Compute Curve” to plot Train vs Val error across degrees; the “Best degree” marks the sweet spot.</li>
        </ol>
        <h6>What to observe</h6>
        <ul class="mb-0">
          <li>Low degree: high bias → both Train and Val errors are large (underfit).</li>
          <li>High degree: low bias but high variance → Train error drops, Val error rises (overfit).</li>
          <li>Middle range: Val error is lowest → best generalization.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Tips</h6>
        <ul class="mb-2">
          <li>Increase Noise to make the task harder; the sweet spot shifts to smaller degrees.</li>
          <li>Increase Lambda to smooth the fit and reduce variance at high degrees.</li>
          <li>Change Train/Val sizes to see how more data stabilizes validation error.</li>
        </ul>
        <div class="small-note">Search terms: “bias variance tradeoff visual”, “underfitting vs overfitting demo”, “polynomial regression visualization”.</div>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
