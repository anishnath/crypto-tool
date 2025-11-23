<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Imbalanced Learning Workshop - Resampling (undersample, oversample, SMOTE), class weights, focal loss, and threshold tuning with PR/ROC curves.">
<meta name="keywords" content="imbalanced learning, class weights, SMOTE, undersampling, oversampling, focal loss, precision recall">
<title>Imbalanced Learning Workshop Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Imbalanced Learning Workshop",
  "description": "Interactive imbalanced learning: resampling (undersample, oversample, SMOTE), class weights, focal loss, and threshold tuning with PR/ROC curves and confusion matrix.",
  "url": "https://8gwifi.org/imbalanced_learning_workshop.jsp",
  "keywords": "imbalanced learning, SMOTE, class weights, focal loss, precision-recall, PR curve, ROC"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .imb-viz { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:260px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  #imbCanvas { width:100%; height:100%; background:#ffffff; border:2px solid #e9ecef; border-radius:6px; cursor:crosshair; }
  .metric-card { background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.green { background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%); }
  .metric-card.pink  { background:linear-gradient(135deg,#f093fb 0%,#f5576c 100%); }
  .metric-label { font-size:12px; opacity:0.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .legend-dot { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
  .dot-red { background:#dc3545; border:1px solid #721c24; }
  .dot-green { background:#28a745; border:1px solid #155724; }
  table.confusion { font-size: 12px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">⚖️ Imbalanced Learning Workshop</h1>
<p>Handle rare events with resampling (undersample, oversample, SMOTE), class weighting, focal loss, and threshold tuning. Inspect PR/ROC curves and the confusion matrix.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#dataset" class="btn btn-outline-primary">Dataset & Model</a>
    <a href="#curves" class="btn btn-outline-primary">PR / ROC</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<!-- Beginner Quick Start -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">Beginner Quick Start</h5>
  </div>
  <div class="card-body">
    <ol class="mb-2">
      <li><strong>Generate data:</strong> Set <em>Total samples</em>, <em>Pos %</em> (minority prevalence), and <em>Noise</em>, then click <strong>Generate</strong>.</li>
      <li><strong>Choose resampling (optional):</strong> Undersample/Oversample/SMOTE to balance the <em>training</em> set, then click <strong>Apply Resampling</strong>.</li>
      <li><strong>Train:</strong> Use <em>Train Step</em> or <em>Train 100</em>. Increase <em>Class weight (pos)</em> or <em>Focal γ</em> if the model ignores positives.</li>
      <li><strong>Decide:</strong> Move the <em>Threshold</em> slider to trade precision vs recall. Watch the confusion matrix and PR/ROC curves update.</li>
    </ol>
    <div class="small text-muted">
      Tips: PR curve (left) is more informative for imbalance. The colored background shows predicted probability; the dashed line is the decision boundary.
    </div>
  </div>
</div>

<div class="imb-viz">
  <div class="row">
    <!-- Left column -->
    <div class="col-lg-8 mb-4">
      <!-- Dataset & Model -->
      <div class="card mb-4" id="dataset">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Dataset & Model</h5>
          <div class="small">
            <span class="legend-dot dot-green"></span>Positive (1)
            <span class="legend-dot dot-red ms-3"></span>Negative (0)
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="imbCanvas"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Tip: Click the canvas to add a point to the selected class. Apply resampling to adjust training distribution.</small>
          <div class="row mt-3">
            <div class="col-md-3"><div class="metric-card"><div class="metric-label">Precision</div><div class="metric-value" id="mPrec">—</div></div></div>
            <div class="col-md-3"><div class="metric-card green"><div class="metric-label">Recall</div><div class="metric-value" id="mRec">—</div></div></div>
            <div class="col-md-3"><div class="metric-card pink"><div class="metric-label">F1</div><div class="metric-value" id="mF1">—</div></div></div>
            <div class="col-md-3"><div class="metric-card" style="background:linear-gradient(135deg,#ffd86f 0%, #fc6262 100%);"><div class="metric-label">PR AUC</div><div class="metric-value" id="mAP">—</div></div></div>
          </div>
          <div class="row mt-2">
            <div class="col-md-6">
              <table class="table table-bordered table-sm text-center confusion">
                <thead><tr><th></th><th>Pred 0</th><th>Pred 1</th></tr></thead>
                <tbody>
                  <tr><th style="text-align:left;">Actual 0</th><td id="cmTN">—</td><td id="cmFP">—</td></tr>
                  <tr><th style="text-align:left;">Actual 1</th><td id="cmFN">—</td><td id="cmTP">—</td></tr>
                </tbody>
              </table>
            </div>
            <div class="col-md-6">
              <div class="slider-label"><span>Threshold</span><strong id="thVal">0.50</strong></div>
              <input type="range" id="th" min="0.05" max="0.95" step="0.01" value="0.50" class="form-range">
              <small class="text-muted">Adjust decision threshold to trade precision vs recall.</small>
            </div>
          </div>
        </div>
      </div>

      <!-- PR & ROC Curves -->
      <div class="card mb-4" id="curves">
        <div class="card-header">
          <h5 class="mb-0">Precision–Recall & ROC</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="chart-container-sm">
                <canvas id="prChart"></canvas>
              </div>
              <small class="text-muted d-block mt-2">PR curve is informative for imbalanced data.</small>
            </div>
            <div class="col-md-6">
              <div class="chart-container-sm">
                <canvas id="rocChart"></canvas>
              </div>
              <small class="text-muted d-block mt-2">Diagonal line is random classifier.</small>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset -->
      <div class="control-section">
        <h6>📦 Dataset</h6>
        <div class="row g-2">
          <div class="col-6">
            <label class="form-label small">Total samples</label>
            <input type="number" id="nTotal" class="form-control form-control-sm" value="400" min="100" max="5000" step="50">
          </div>
          <div class="col-6">
            <label class="form-label small">Pos %</label>
            <input type="number" id="posPct" class="form-control form-control-sm" value="15" min="1" max="50" step="1">
          </div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col-6">
            <label class="form-label small">Noise (σ)</label>
            <input type="number" id="noise" class="form-control form-control-sm" value="0.6" min="0" max="2" step="0.1">
          </div>
          <div class="col-6">
            <label class="form-label small">Add class</label>
            <select id="classSel" class="form-select form-select-sm">
              <option value="1">Class 1 (Green)</option>
              <option value="0">Class 0 (Red)</option>
            </select>
          </div>
        </div>
        <small class="text-muted d-block mt-2">
          Pos % controls the rarity of the positive class. Higher Noise makes classes overlap and the task harder.
        </small>
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnGen">Generate</button></div>
          <div class="col"><button class="btn btn-danger btn-sm w-100" id="btnClear">Clear</button></div>
        </div>
      </div>

      <!-- Resampling -->
      <div class="control-section">
        <h6>🔁 Resampling</h6>
        <div class="mb-2">
          <select id="resample" class="form-select form-select-sm">
            <option value="none" selected>None</option>
            <option value="under">Undersample majority</option>
            <option value="over">Oversample minority</option>
            <option value="smote">SMOTE (synthetic minority)</option>
          </select>
        </div>
        <small class="text-muted d-block mb-2">
          Undersample = faster but may drop information. Oversample = simple duplication. SMOTE = creates synthetic minority points between neighbors.
        </small>
        <div class="slider-label"><span>Target Pos %</span><strong id="tgtPosVal">40</strong></div>
        <input type="range" id="tgtPos" min="10" max="90" step="5" value="40" class="form-range">
        <button class="btn btn-outline-secondary btn-sm w-100 mt-2" id="btnApplyResample">Apply Resampling</button>
        <small class="text-muted d-block mt-1">Resampling affects training distribution only; evaluation uses all points.</small>
      </div>

      <!-- Model -->
      <div class="control-section">
        <h6>🤖 Model (Logistic)</h6>
        <div class="row g-2">
          <div class="col-4">
            <label class="form-label small">w0</label>
            <input type="number" id="w0" class="form-control form-control-sm" step="0.1" value="0">
          </div>
          <div class="col-4">
            <label class="form-label small">w1</label>
            <input type="number" id="w1" class="form-control form-control-sm" step="0.1" value="0">
          </div>
          <div class="col-4">
            <label class="form-label small">b</label>
            <input type="number" id="b" class="form-control form-control-sm" step="0.1" value="0">
          </div>
        </div>
        <div class="slider-label mt-2"><span>LR</span><strong id="lrVal">0.10</strong></div>
        <input type="range" id="lr" min="0.001" max="1" step="0.001" value="0.10" class="form-range">

        <div class="slider-label"><span>Epochs/Step</span><strong id="epVal">10</strong></div>
        <input type="range" id="epochs" min="1" max="200" step="1" value="10" class="form-range">

        <div class="slider-label"><span>Class weight (pos)</span><strong id="cwVal">3.0</strong></div>
        <input type="range" id="cwPos" min="1" max="10" step="0.5" value="3.0" class="form-range">

        <div class="slider-label"><span>Focal γ</span><strong id="gammaVal">0.0</strong></div>
        <input type="range" id="gamma" min="0" max="3" step="0.1" value="0.0" class="form-range">
        <small class="text-muted d-block mt-1">
          Class weight (pos) increases penalty for missing positives (↑ recall). Focal γ focuses learning on hard examples (try 1.5–2.0 for heavy imbalance).
        </small>

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-success btn-sm w-100" id="btnTrain">Train Step</button></div>
          <div class="col"><button class="btn btn-success btn-sm w-100" id="btnTrainMany">Train 100</button></div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnAuto">Auto ⏵</button></div>
          <div class="col"><button class="btn btn-warning btn-sm w-100" id="btnResetW">Reset Weights</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function() {
  function $(id){ return document.getElementById(id); }
  function randn(){ var u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }
  function sigmoid(z){ return 1/(1+Math.exp(-Math.max(-50, Math.min(50, z)))); }

  // Canvas
  var canvas = $('imbCanvas'), ctx = canvas.getContext('2d');
  function resizeCanvas(){ var p=canvas.parentElement; canvas.width=Math.max(320, p.clientWidth-4); canvas.height=Math.max(260, p.clientHeight-4); drawAll(); }
  window.addEventListener('resize', resizeCanvas);

  // Domain mapping [-2,2]
  function toCanvas(x,y){ var W=canvas.width,H=canvas.height; var nx=(x+2)/4, ny=(y+2)/4; return {cx:nx*W, cy:(1-ny)*H}; }
  function toDomain(cx,cy){ var W=canvas.width,H=canvas.height; var nx=cx/W, ny=1-(cy/H); return {x:nx*4-2, y:ny*4-2}; }

  // Data
  var points = []; // all points: {x,y,c}
  var trainIdx = []; // training indices after resampling
  var autoTimer = null;

  // Model
  var W = { w0:0, w1:0, b:0 };

  // Charts
  var prChart = new Chart($('prChart'), {
    type:'line', data:{ labels:[], datasets:[{ label:'PR', data:[], parsing:false, borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.1)', tension:0.2 }] },
    options:{ responsive:true, maintainAspectRatio:false, parsing:false, scales:{ x:{ min:0, max:1, title:{display:true,text:'Recall'}}, y:{ min:0, max:1, title:{display:true,text:'Precision'}} } }
  });
  var rocChart = new Chart($('rocChart'), {
    type:'line', data:{ labels:[], datasets:[
      { label:'ROC', data:[], parsing:false, borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.1)', tension:0.2 },
      { label:'Random', data:[{x:0,y:0},{x:1,y:1}], parsing:false, borderColor:'#6c757d', borderDash:[6,6], pointRadius:0 }
    ]},
    options:{ responsive:true, maintainAspectRatio:false, parsing:false, scales:{ x:{ min:0, max:1, title:{display:true,text:'FPR'}}, y:{ min:0, max:1, title:{display:true,text:'TPR'}} } }
  });

  // UI bindings
  $('lr').addEventListener('input', function(){ $('lrVal').textContent=parseFloat(this.value).toFixed(2); });
  $('epochs').addEventListener('input', function(){ $('epVal').textContent=this.value; });
  $('cwPos').addEventListener('input', function(){ $('cwVal').textContent=parseFloat(this.value).toFixed(1); });
  $('gamma').addEventListener('input', function(){ $('gammaVal').textContent=parseFloat(this.value).toFixed(1); });
  $('tgtPos').addEventListener('input', function(){ $('tgtPosVal').textContent=this.value; });
  $('th').addEventListener('input', function(){ $('thVal').textContent=parseFloat(this.value).toFixed(2); updateMetricsAndCurves(); });

  $('btnGen').addEventListener('click', generateData);
  $('btnClear').addEventListener('click', function(){ points=[]; trainIdx=[]; drawAll(); updateMetricsAndCurves(); });
  $('btnApplyResample').addEventListener('click', applyResampling);
  $('btnTrain').addEventListener('click', function(){ trainEpochs(parseInt($('epochs').value)); });
  $('btnTrainMany').addEventListener('click', function(){ trainEpochs(100); });
  $('btnAuto').addEventListener('click', function(){
    if(autoTimer){ clearInterval(autoTimer); autoTimer=null; this.textContent='Auto ⏵'; return; }
    this.textContent='Pause ⏸';
    autoTimer = setInterval(function(){ trainEpochs(10); }, 120);
  });
  $('btnResetW').addEventListener('click', function(){ W={w0:0,w1:0,b:0}; drawAll(); updateMetricsAndCurves(); });

  canvas.addEventListener('click', function(evt){
    var br=canvas.getBoundingClientRect();
    var x=evt.clientX - br.left, y=evt.clientY - br.top;
    var d=toDomain(x,y);
    var cls=parseInt($('classSel').value);
    points.push({x:d.x, y:d.y, c:cls});
    drawAll(); updateMetricsAndCurves();
  });

  function generateData(){
    var nTotal = parseInt($('nTotal').value);
    var posPct = parseInt($('posPct').value)/100;
    var noise = parseFloat($('noise').value);

    points=[];
    var nPos = Math.max(1, Math.round(nTotal*posPct));
    var nNeg = nTotal - nPos;

    for(var i=0;i<nNeg;i++){
      points.push({x: -1.2 + randn()*noise, y: -1.0 + randn()*noise, c:0});
    }
    for(var j=0;j<nPos;j++){
      points.push({x:  1.1 + randn()*noise, y:  1.0 + randn()*noise, c:1});
    }
    trainIdx = points.map(function(_,i){ return i; }); // default all points
    drawAll(); updateMetricsAndCurves();
  }

  function applyResampling(){
    var mode = $('resample').value;
    var tgtPos = parseInt($('tgtPos').value)/100;

    var idxPos = [], idxNeg = [];
    for(var i=0;i<points.length;i++){ if(points[i].c===1) idxPos.push(i); else idxNeg.push(i); }

    if(idxPos.length===0 || idxNeg.length===0){ trainIdx = points.map(function(_,i){return i;}); updateMetricsAndCurves(); return; }

    var n = idxPos.length + idxNeg.length;
    var targetPosCount = Math.max(1, Math.round(n * tgtPos));
    var targetNegCount = Math.max(1, n - targetPosCount);

    if(mode==='none'){
      trainIdx = points.map(function(_,i){return i;});
    } else if(mode==='under'){
      // downsample majority to target
      if(targetPosCount < idxPos.length){
        // undersample positives
        trainIdx = idxNeg.concat(shuffle(idxPos).slice(0, targetPosCount));
      } else {
        // undersample negatives
        trainIdx = idxPos.concat(shuffle(idxNeg).slice(0, targetNegCount));
      }
    } else if(mode==='over'){
      // oversample minority by replication
      var res=[];
      if(targetPosCount > idxPos.length){
        var needed = targetPosCount - idxPos.length;
        var extra = [];
        for(var k=0;k<needed;k++){ extra.push(idxPos[k % idxPos.length]); }
        res = idxNeg.concat(idxPos).concat(extra);
      } else {
        var neededN = targetNegCount - idxNeg.length;
        var extraN = [];
        for(var k2=0;k2<neededN;k2++){ extraN.push(idxNeg[k2 % idxNeg.length]); }
        res = idxPos.concat(idxNeg).concat(extraN);
      }
      trainIdx = res;
    } else {
      // SMOTE for minority
      var minority = (idxPos.length < idxNeg.length) ? idxPos.slice() : idxNeg.slice();
      var majority = (idxPos.length < idxNeg.length) ? idxNeg.slice() : idxPos.slice();
      var neededSmote = (idxPos.length < idxNeg.length) ? (targetPosCount - idxPos.length) : (targetNegCount - idxNeg.length);
      neededSmote = Math.max(0, neededSmote);

      var synth = [];
      if(neededSmote>0){
        // build simple neighbor list (k=5 or all)
        for(var s=0;s<neededSmote;s++){
          var i0 = minority[s % minority.length];
          // choose random other minority neighbor
          var j0 = minority[Math.floor(Math.random()*minority.length)];
          if(j0===i0 && minority.length>1){ j0 = minority[(Math.floor(Math.random()*minority.length-1)+1)%minority.length]; }
          var pA = points[i0], pB = points[j0];
          var t = Math.random();
          var syn = { x: pA.x + t*(pB.x - pA.x), y: pA.y + t*(pB.y - pA.y), c: points[i0].c };
          // append synthetic point to points to be used for training (not for global eval metrics)
          points.push(syn);
          synth.push(points.length-1);
        }
      }
      // combine indices
      trainIdx = majority.concat(minority).concat(synth);
    }
    drawAll(); updateMetricsAndCurves();
  }

  function shuffle(a){ for(var i=a.length-1;i>0;i--){ var j=Math.floor(Math.random()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } return a; }

  // Model & Training
  function predictProba(x,y){
    var z = W.w0*x + W.w1*y + W.b;
    return sigmoid(z);
  }

  function trainEpochs(epochs){
    if(trainIdx.length===0) trainIdx = points.map(function(_,i){return i;});
    var lr = parseFloat($('lr').value);
    var cwPos = parseFloat($('cwPos').value);
    var gamma = parseFloat($('gamma').value);

    for(var ep=0; ep<epochs; ep++){
      for(var t=0; t<trainIdx.length; t++){
        var i = trainIdx[t];
        var p = points[i];
        var x = p.x, y = p.y, c = p.c;
        var z = W.w0*x + W.w1*y + W.b;
        var pr = sigmoid(z);
        var weight = (c===1 ? cwPos : 1);
        // focal modifier (approximate)
        var mod = (c===1) ? Math.pow(1 - pr, gamma) : Math.pow(pr, gamma);
        var err = (pr - c) * weight * mod;

        W.w0 -= lr * err * x;
        W.w1 -= lr * err * y;
        W.b  -= lr * err;
      }
    }
    drawAll(); updateMetricsAndCurves();
  }

  // Metrics & Curves
  function computePR(pointsList){
    // thresholds from sorted unique probabilities
    var probs = [], labels=[];
    for(var i=0;i<pointsList.length;i++){ probs.push(predictProba(pointsList[i].x, pointsList[i].y)); labels.push(pointsList[i].c); }
    var idx = probs.map(function(_,i){return i;}).sort(function(a,b){ return probs[b]-probs[a]; });
    var tp=0, fp=0, fn=labels.reduce(function(s,v){return s+(v===1?1:0);},0), tn=labels.length - fn;
    var prec=[], rec=[], pointsPR=[];
    var last = -1;
    for(var k=0;k<idx.length;k++){
      var i = idx[k];
      var c = labels[i];
      if(c===1){ tp++; fn--; } else { fp++; tn--; }
      var p = tp + fp > 0 ? tp/(tp+fp) : 1;
      var r = tp + fn > 0 ? tp/(tp+fn) : 0;
      if(probs[i]!==last){ pointsPR.push({x:r, y:p}); last=probs[i]; }
    }
    // AUPR
    var ap=0;
    for(var j=1;j<pointsPR.length;j++){
      var x0=pointsPR[j-1].x, y0=pointsPR[j-1].y;
      var x1=pointsPR[j].x,   y1=pointsPR[j].y;
      ap += (x1 - x0) * ((y0 + y1)/2);
    }
    return { pts:pointsPR, ap:ap };
  }

  function computeROC(pointsList){
    var probs = [], labels=[];
    for(var i=0;i<pointsList.length;i++){ probs.push(predictProba(pointsList[i].x, pointsList[i].y)); labels.push(pointsList[i].c); }
    var idx = probs.map(function(_,i){return i;}).sort(function(a,b){ return probs[b]-probs[a]; });
    var tp=0, fp=0, fn=labels.reduce(function(s,v){return s+(v===1?1:0);},0), tn=labels.length - fn;
    var pts=[];
    var last=-1;
    for(var k=0;k<idx.length;k++){
      var i = idx[k];
      if(labels[i]===1){ tp++; fn--; } else { fp++; tn--; }
      var tpr = tp + fn > 0 ? tp/(tp+fn) : 0;
      var fpr = fp + tn > 0 ? fp/(fp+tn) : 0;
      if(probs[i]!==last){ pts.push({x:fpr, y:tpr}); last=probs[i]; }
    }
    // AUROC via trapezoid over sorted FPR
    pts.sort(function(a,b){ return a.x - b.x; });
    var auc=0;
    for(var j=1;j<pts.length;j++){
      var x0=pts[j-1].x, y0=pts[j-1].y;
      var x1=pts[j].x,   y1=pts[j].y;
      auc += (x1 - x0) * ((y0 + y1)/2);
    }
    return { pts:pts, auc:auc };
  }

  function updateMetricsAndCurves(){
    // Metrics at threshold
    var th = parseFloat($('th').value);
    var tp=0, fp=0, tn=0, fn=0;
    for(var i=0;i<points.length;i++){
      var pr = predictProba(points[i].x, points[i].y);
      var pred = pr > th ? 1 : 0;
      if(pred===1 && points[i].c===1) tp++; else
      if(pred===1 && points[i].c===0) fp++; else
      if(pred===0 && points[i].c===1) fn++; else
      if(pred===0 && points[i].c===0) tn++;
    }
    var prec = tp+fp>0 ? tp/(tp+fp) : 1;
    var rec  = tp+fn>0 ? tp/(tp+fn) : 0;
    var f1   = (prec+rec)>0 ? 2*prec*rec/(prec+rec) : 0;

    $('cmTP').textContent=tp; $('cmFP').textContent=fp; $('cmTN').textContent=tn; $('cmFN').textContent=fn;
    $('mPrec').textContent=(prec*100).toFixed(1)+'%';
    $('mRec').textContent =(rec*100).toFixed(1)+'%';
    $('mF1').textContent  =f1.toFixed(3);

    var pr = computePR(points);
    $('mAP').textContent=pr.ap.toFixed(3);
    prChart.data.datasets[0].data = pr.pts;
    prChart.update('none');

    var roc = computeROC(points);
    rocChart.data.datasets[0].data = roc.pts;
    rocChart.update('none');
  }

  // Drawing
  function drawBackground(){
    var step=6;
    for(var y=0;y<canvas.height;y+=step){
      for(var x=0;x<canvas.width;x+=step){
        var d=toDomain(x,y);
        var p = predictProba(d.x, d.y);
        var alpha = Math.abs(p-0.5)*0.35;
        ctx.fillStyle = p>0.5 ? ('rgba(40,167,69,'+alpha+')') : ('rgba(220,53,69,'+alpha+')');
        ctx.fillRect(x,y,step,step);
      }
    }
    // Decision boundary line
    // W.w0*x + W.w1*y + W.b = 0 => y = -(w0/w1)x - b/w1
    if(Math.abs(W.w1)>1e-6){
      var xL = -2, xR = 2;
      var yL = - (W.w0/W.w1)*xL - W.b/W.w1;
      var yR = - (W.w0/W.w1)*xR - W.b/W.w1;
      var cL = toCanvas(xL, yL), cR = toCanvas(xR, yR);
      ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.lineWidth=2;
      ctx.beginPath(); ctx.moveTo(cL.cx, cL.cy); ctx.lineTo(cR.cx, cR.cy); ctx.stroke(); ctx.setLineDash([]);
    }
  }
  function drawPoints(){
    for(var i=0;i<points.length;i++){
      var p=points[i], c=toCanvas(p.x,p.y);
      ctx.beginPath(); ctx.arc(c.cx,c.cy,5,0,Math.PI*2);
      ctx.fillStyle = p.c===1 ? '#28a745' : '#dc3545';
      ctx.fill(); ctx.lineWidth=2; ctx.strokeStyle = p.c===1 ? '#155724' : '#721c24'; ctx.stroke();
    }
  }
  function drawAll(){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    drawBackground();
    drawPoints();
  }

  // Init
  resizeCanvas();
  generateData();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">About Imbalanced Learning</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Why it’s hard</h6>
        <ul class="mb-2">
          <li>Minority class is rare → models bias to predicting majority</li>
          <li>Accuracy can be misleading → prefer PR curves and recall</li>
          <li>Threshold choice matters as much as model choice</li>
        </ul>
        <h6>Techniques</h6>
        <ul class="mb-0">
          <li><strong>Resampling:</strong> Undersample majority, oversample minority, or use SMOTE to synthesize new minority samples</li>
          <li><strong>Class weights:</strong> Penalize mistakes on minority more heavily</li>
          <li><strong>Focal loss:</strong> Down-weight easy examples to focus on hard ones</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>How to evaluate</h6>
        <ul class="mb-2">
          <li><strong>PR curve & AP:</strong> Better for imbalance than ROC</li>
          <li><strong>Confusion matrix at threshold:</strong> Inspect precision/recall trade-offs</li>
          <li><strong>Calibration:</strong> If making probabilistic decisions, calibrate then choose thresholds</li>
        </ul>
        <h6>Workflow tips</h6>
        <ul class="mb-0">
          <li>Try resampling + class weights, then tune threshold by business costs</li>
          <li>Use focal loss if minority still ignored</li>
          <li>Validate with PR AUC and recall at target precision</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- How it works & Visualization Tips -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">How it works and how to visualize effects</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>How it works (pipeline)</h6>
        <ol class="mb-2">
          <li><strong>Generate data:</strong> Set total size, positive percentage, and noise; points are drawn from two clusters.</li>
          <li><strong>Choose resampling:</strong> Applies <em>only</em> to the <strong>training indices</strong> (display shows all points). Options:
            <ul class="mb-0">
              <li>Undersample: reduce majority</li>
              <li>Oversample: replicate minority</li>
              <li>SMOTE: synthesize minority near neighbors</li>
            </ul>
          </li>
          <li><strong>Train model:</strong> Logistic regression updates weights with:
            <ul class="mb-0">
              <li><strong>Class weight (pos):</strong> upweights minority errors</li>
              <li><strong>Focal γ:</strong> emphasizes hard examples (down-weights easy ones)</li>
              <li><strong>LR / Epochs:</strong> controls update magnitude and iterations</li>
            </ul>
          </li>
          <li><strong>Decide:</strong> Threshold converts probabilities to classes → confusion matrix and metrics update live.</li>
          <li><strong>Evaluate:</strong> PR/ROC curves recomputed from model probabilities over all points (not just resampled subset).</li>
        </ol>
        <small class="text-muted">Tip: Resampling shifts training distribution; evaluation remains on the full set to avoid inflated metrics.</small>
      </div>
      <div class="col-md-6">
        <h6>How to see and visualize improvements</h6>
        <ul class="mb-2">
          <li><strong>Baseline vs Resampling:</strong> Generate with low Pos% (e.g., 10–15%). Train baseline (no resampling). Apply SMOTE or Oversample and retrain. Watch recall and PR AUC rise.</li>
          <li><strong>Class weights:</strong> Increase “Class weight (pos)” and observe the decision boundary tilt toward the minority and recall improve (precision may drop).</li>
          <li><strong>Focal loss:</strong> Set γ=2.0 for highly imbalanced/noisy data. Train; hard minority points influence more—recall improves.</li>
          <li><strong>Threshold tuning:</strong> Move the threshold slider:
            <ul class="mb-0">
              <li>Lower threshold → higher recall, more FP</li>
              <li>Higher threshold → higher precision, more FN</li>
            </ul>
          </li>
          <li><strong>PR vs ROC:</strong> Use PR to compare scenarios; it’s more sensitive to improvements in minority detection than ROC on imbalanced sets.</li>
          <li><strong>Stress test:</strong> Increase Noise (σ) to 0.9–1.2; compare “None” vs “SMOTE + class weights” for robustness.</li>
          <li><strong>Visual boundary:</strong> The colored background shows predicted probability; the dashed line is the current decision boundary.</li>
        </ul>
        <h6 class="mt-3">Suggested experiments</h6>
        <ul class="mb-0">
          <li>Pos% = 5–10%, SMOTE to 40% target → train → compare PR AUC and recall</li>
          <li>Keep data fixed; sweep class weight from 1.0 → 5.0 and plot F1 changes</li>
          <li>Combine Oversample + γ=1.5 and compare to SMOTE-only</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (Imbalanced Learning) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>This workshop explores class imbalance strategies: resampling (undersample/oversample), class weights, and threshold tuning. It visualizes confusion matrices, ROC/PR curves, and metrics sensitive to imbalance (F1, MCC).</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Understand why accuracy can be misleading under imbalance.</li>
      <li>Compare class weighting vs sampling; observe PR curve behavior.</li>
      <li>Use MCC/F1/recall@precision as robust alternatives.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>Runs locally with synthetic or provided data; nothing is uploaded.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Imbalanced Learning Workshop",
  "url": "https://8gwifi.org/imbalanced_learning_workshop.jsp",
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
    {"@type":"ListItem","position":2,"name":"Imbalanced Learning Workshop","item":"https://8gwifi.org/imbalanced_learning_workshop.jsp"}
  ]
}
</script>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
