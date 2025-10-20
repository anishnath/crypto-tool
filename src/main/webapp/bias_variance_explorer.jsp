<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Bias–Variance Tradeoff Explorer - Interactive polynomial regression on a noisy sine curve with training vs validation error curves and sweet spot highlight.">
<meta name="keywords" content="bias variance tradeoff visual, underfitting vs overfitting demo, polynomial regression visualization, ML generalization, training validation error">
<title>Bias–Variance Tradeoff Explorer</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Bias–Variance Tradeoff Explorer",
  "description": "Interactive demo of bias–variance tradeoff: fit polynomial regression on a noisy sine curve, see training vs validation error and the sweet spot.",
  "url": "https://8gwifi.org/bias_variance_explorer.jsp",
  "keywords": "bias variance tradeoff visual, underfitting vs overfitting demo, polynomial regression visualization"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .bv-lab { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:260px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .metric-card { background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.green { background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%); }
  .metric-label { font-size:12px; opacity:0.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .small-note { font-size:12px; color:#6c757d; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">📈 Bias–Variance Tradeoff Explorer</h1>
<p>Fit polynomial regression to a noisy sine wave. Explore how model complexity (degree) affects training and validation error, and find the sweet spot between underfitting and overfitting.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#errors" class="btn btn-outline-primary">Error Curves</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="bv-lab">
  <div class="row">
    <!-- Left column -->
    <div class="col-lg-8 mb-4">
      <!-- Data + Fit -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Data & Model Fit</h5>
          <small class="text-muted">Dataset: y = sin(2πx) + noise, x ∈ [0, 1]</small>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="fitChart"></canvas>
          </div>
          <div class="row mt-3">
            <div class="col-md-6">
              <div class="metric-card">
                <div class="metric-label">Train MSE</div>
                <div class="metric-value" id="mTrain">—</div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="metric-card green">
                <div class="metric-label">Validation MSE</div>
                <div class="metric-value" id="mVal">—</div>
              </div>
            </div>
          </div>
          <small class="small-note d-block mt-1">Blue curve: model fit. Scatter: training (solid) and validation (hollow) points.</small>
        </div>
      </div>

      <!-- Error curves -->
      <div class="card mb-4" id="errors">
        <div class="card-header">
          <h5 class="mb-0">Training vs Validation Error</h5>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="errChart"></canvas>
          </div>
          <small class="small-note d-block mt-1">The validation curve typically goes down then up: the lowest point marks the sweet spot (best generalization).</small>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset -->
      <div class="control-section">
        <h6>📦 Dataset</h6>
        <div class="slider-label"><span>Samples (N)</span><strong id="nVal">120</strong></div>
        <input type="range" id="n" min="40" max="400" step="10" value="120" class="form-range">

        <div class="slider-label"><span>Noise σ</span><strong id="noiseVal">0.20</strong></div>
        <input type="range" id="noise" min="0" max="0.6" step="0.01" value="0.20" class="form-range">

        <div class="slider-label"><span>Train / Val split</span><strong id="splitVal">70 / 30</strong></div>
        <input type="range" id="split" min="50" max="90" step="5" value="70" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnGen">Generate</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnShuffle">Shuffle Split</button></div>
        </div>
      </div>

      <!-- Model -->
      <div class="control-section">
        <h6>🤖 Model (Polynomial Regression)</h6>
        <div class="slider-label"><span>Degree</span><strong id="degVal">3</strong></div>
        <input type="range" id="degree" min="0" max="20" step="1" value="3" class="form-range">

        <div class="slider-label"><span>Ridge λ</span><strong id="lamVal">1e-6</strong></div>
        <input type="range" id="lambda" min="0" max="0.01" step="0.0005" value="0.000001" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-success btn-sm w-100" id="btnFit">Fit Model</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnCurve">Compute Curve</button></div>
        </div>
      </div>

      <!-- Sweet spot -->
      <div class="control-section">
        <h6>🎯 Sweet Spot</h6>
        <div class="small">Min validation error at degree: <strong id="sweetDeg">—</strong></div>
        <div class="small">Val MSE at sweet spot: <strong id="sweetMse">—</strong></div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function(){
  // Shortcuts
  function $(id){ return document.getElementById(id); }

  // State
  var X=[], Y=[], idxTrain=[], idxVal=[];
  var model = { degree:3, lambda:1e-6, w:null };

  // Charts
  var fitChart = new Chart($('#fitChart'), {
    type:'scatter',
    data:{ datasets:[
      {label:'Train', data:[], pointRadius:3, backgroundColor:'#0d6efd'},
      {label:'Val',   data:[], pointRadius:3, backgroundColor:'#0d6efd', borderColor:'#0d6efd', showLine:false, pointStyle:'circle', radius:3, borderWidth:1, parsing:false,
       segment:{ }, pointBorderColor:'#0d6efd', pointBackgroundColor:'#ffffff'},
      {label:'Model', data:[], type:'line', borderWidth:2, borderColor:'#20c997', pointRadius:0, fill:false, parsing:false}
    ]},
    options:{
      responsive:true, maintainAspectRatio:false,
      scales:{ x:{ min:0, max:1, title:{display:true, text:'x'}}, y:{ min:-1.5, max:1.5, title:{display:true, text:'y'}}},
      plugins:{ legend:{ labels:{ color:'#212529'} } }
    }
  });

  var errChart = new Chart($('#errChart'), {
    type:'line',
    data:{ labels:[], datasets:[
      {label:'Train MSE', data:[], borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.15)', tension:0.2},
      {label:'Val MSE',   data:[], borderColor:'#f5576c', backgroundColor:'rgba(245,87,108,0.15)', tension:0.2, pointRadius:3 }
    ]},
    options:{
      responsive:true, maintainAspectRatio:false,
      scales:{ x:{ title:{display:true, text:'Degree'}}, y:{ title:{display:true, text:'MSE'}, min:0 }},
      plugins:{ legend:{ display:true } }
    }
  });

  // UI bindings
  $('#n').addEventListener('input', function(){ $('#nVal').textContent=this.value; });
  $('#noise').addEventListener('input', function(){ $('#noiseVal').textContent=parseFloat(this.value).toFixed(2); });
  $('#split').addEventListener('input', function(){ var tr=parseInt(this.value); $('#splitVal').textContent=tr+' / '+(100-tr); });
  $('#degree').addEventListener('input', function(){ $('#degVal').textContent=this.value; model.degree=parseInt(this.value); });
  $('#lambda').addEventListener('input', function(){ $('#lamVal').textContent=this.value; model.lambda=parseFloat(this.value); });

  $('#btnGen').addEventListener('click', function(){ generateData(); fitCurrent(); });
  $('#btnShuffle').addEventListener('click', function(){ splitTrainVal(); fitCurrent(); });
  $('#btnFit').addEventListener('click', function(){ fitCurrent(true); });
  $('#btnCurve').addEventListener('click', function(){ computeCurve(); });

  // Data generation: noisy sine
  function generateData(){
    var n=parseInt($('#n').value);
    var sigma=parseFloat($('#noise').value);
    X=[]; Y=[];
    for(var i=0;i<n;i++){
      var x=Math.random(); // [0,1]
      var y=Math.sin(2*Math.PI*x) + randn()*sigma;
      X.push(x); Y.push(y);
    }
    splitTrainVal();
    renderData();
  }

  function splitTrainVal(){
    var n=X.length; var idx=[]; for(var i=0;i<n;i++) idx.push(i);
    // shuffle then split
    idx.sort(function(){ return Math.random()-0.5; });
    var trPct=parseInt($('#split').value)/100, cut=Math.floor(n*trPct);
    idxTrain=idx.slice(0,cut); idxVal=idx.slice(cut);
  }

  function renderData(){
    var trainPts = idxTrain.map(function(i){ return {x:X[i], y:Y[i]}; });
    var valPts   = idxVal.map(function(i){ return {x:X[i], y:Y[i]}; });
    fitChart.data.datasets[0].data = trainPts;
    fitChart.data.datasets[1].data = valPts;
    fitChart.update('none');
  }

  // Polynomial features
  function polyFeatures(x, d){
    var v=new Array(d+1);
    var p=1; for(var k=0;k<=d;k++){ v[k]=p; p*=x; }
    return v;
  }

  // Fit by ridge-regularized normal equation
  function fitPolynomial(degree, lambda, xIdx){
    if(xIdx.length===0) return null;
    var d=degree, m=xIdx.length;
    var XtX = zeros(d+1, d+1);
    var XtY = new Array(d+1).fill(0);
    for(var t=0;t<m;t++){
      var i=xIdx[t];
      var phi = polyFeatures(X[i], d);
      var yi = Y[i];
      for(var r=0;r<=d;r++){
        XtY[r] += phi[r]*yi;
        for(var c=0;c<=d;c++){
          XtX[r][c] += phi[r]*phi[c];
        }
      }
    }
    // ridge: XtX + lambda*I
    for(var r2=0;r2<=d;r2++){ XtX[r2][r2] += lambda; }
    var w = solveSymmetric(XtX, XtY);
    return w;
  }

  function predictPoly(w, x){
    if(!w) return 0;
    var y=0, p=1;
    for(var k=0;k<w.length;k++){ y += w[k]*p; p*=x; }
    return y;
  }

  function mseOnIdx(w, idx){
    if(!w || idx.length===0) return NaN;
    var s=0;
    for(var t=0;t<idx.length;t++){
      var i=idx[t];
      var e = predictPoly(w, X[i]) - Y[i];
      s += e*e;
    }
    return s/idx.length;
  }

  function fitCurrent(updateSweet){
    model.w = fitPolynomial(model.degree, model.lambda, idxTrain);
    // Update fit curve
    var pts=[];
    for(var k=0;k<=200;k++){
      var x=k/200;
      pts.push({x:x, y:predictPoly(model.w, x)});
    }
    fitChart.data.datasets[2].data = pts;
    fitChart.update('none');

    var tr = mseOnIdx(model.w, idxTrain);
    var va = mseOnIdx(model.w, idxVal);
    $('#mTrain').textContent = isNaN(tr)? '—' : tr.toFixed(4);
    $('#mVal').textContent   = isNaN(va)? '—' : va.toFixed(4);

    if(updateSweet){ // re-evaluate sweet spot for current deg quickly
      computeCurve();
    }
  }

  function computeCurve(){
    var maxD=20, lam=model.lambda;
    var degs=[], tr=[], va=[];
    var best={deg:null, val:Infinity};
    for(var d=0; d<=maxD; d++){
      var w = fitPolynomial(d, lam, idxTrain);
      var mtr = mseOnIdx(w, idxTrain);
      var mva = mseOnIdx(w, idxVal);
      degs.push(''+d); tr.push(mtr); va.push(mva);
      if(mva<best.val){ best={deg:d, val:mva}; }
    }
    errChart.data.labels = degs;
    errChart.data.datasets[0].data = tr;
    errChart.data.datasets[1].data = va;
    // Highlight sweet spot by making that point larger
    var pointStyles = new Array(va.length).fill(3);
    pointStyles[best.deg] = 7;
    errChart.data.datasets[1].pointRadius = pointStyles;
    errChart.update('none');

    $('#sweetDeg').textContent = best.deg;
    $('#sweetMse').textContent = best.val.toFixed(4);
  }

  // Linear algebra helpers
  function zeros(r,c){ var A=new Array(r); for(var i=0;i<r;i++){ A[i]=new Array(c).fill(0); } return A; }
  function solveSymmetric(A, b){
    // Simple Gaussian elimination with partial pivoting (sufficient for small (d+1)≤21)
    var n=A.length;
    var M=zeros(n,n+1);
    for(var i=0;i<n;i++){ for(var j=0;j<n;j++){ M[i][j]=A[i][j]; } M[i][n]=b[i]; }
    for(var col=0; col<n; col++){
      // pivot
      var piv=col, max=Math.abs(M[col][col]);
      for(var r=col+1;r<n;r++){ var v=Math.abs(M[r][col]); if(v>max){ max=v; piv=r; } }
      if(piv!==col){ var tmp=M[col]; M[col]=M[piv]; M[piv]=tmp; }
      var diag=M[col][col] || 1e-12;
      // normalize
      for(var j=col; j<=n; j++){ M[col][j]/=diag; }
      // eliminate
      for(var r2=0; r2<n; r2++){
        if(r2===col) continue;
        var f=M[r2][col];
        for(var j2=col; j2<=n; j2++){ M[r2][j2]-=f*M[col][j2]; }
      }
    }
    var x=new Array(n);
    for(var i2=0;i2<n;i2++){ x[i2]=M[i2][n]; }
    return x;
  }

  function randn(){
    var u=0,v=0;
    while(u===0) u=Math.random();
    while(v===0) v=Math.random();
    return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v);
  }

  // Init
  generateData();
  fitCurrent(true);
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">How to use & What to learn</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Quick start</h6>
        <ol class="mb-2">
          <li>Adjust Samples and Noise, then click Generate.</li>
          <li>Move the Degree slider to change model complexity and click Fit Model.</li>
          <li>Click Compute Curve to plot Training vs Validation MSE across degrees.</li>
        </ol>
        <h6>Underfitting vs Overfitting</h6>
        <ul class="mb-0">
          <li>Low degree (e.g., 0–2): high bias → both Train and Val error high.</li>
          <li>High degree (e.g., 12–20): low bias but high variance → Train low, Val rises.</li>
          <li>Sweet spot: the degree with minimum Val MSE → best generalization.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Tips</h6>
        <ul class="mb-2">
          <li>Use more samples or add Ridge λ to stabilize high-degree fits.</li>
          <li>Re-shuffle split to see how sensitive the sweet spot is.</li>
          <li>Try extreme noise to see validation error increase overall.</li>
        </ul>
        <div class="small-note">This demo targets “bias variance tradeoff visual”, “underfitting vs overfitting demo”, and “polynomial regression visualization”.</div>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
