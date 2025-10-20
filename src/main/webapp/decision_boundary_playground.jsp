<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Decision Boundary Playground - Interactive decision boundary visualization for Logistic Regression, SVM, kNN, and Decision Tree on classic datasets (blobs, moons, circles).">
<meta name="keywords" content="decision boundary visualization, SVM interactive demo, machine learning classifiers comparison, logistic regression, kNN, decision tree, kernels, RBF, linear SVM">
<title>Decision Boundary Playground</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Decision Boundary Playground",
  "description": "Interactive tool to compare decision boundaries for Logistic Regression, SVM (linear/RBF), kNN, and Decision Trees on blobs, moons, and circles datasets.",
  "url": "https://8gwifi.org/decision_boundary_playground.jsp",
  "keywords": "decision boundary visualization, SVM interactive demo, machine learning classifiers comparison, logistic regression, kNN, decision tree, kernels"
}
</script>

<style>
  .dbp { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  #dbCanvas { width: 100%; height: 100%; background: #ffffff; border: 2px solid #e9ecef; border-radius: 6px; cursor: crosshair; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .control-section { background: #fff; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .metric-card { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; border-radius: 8px; padding: 14px; text-align: center; margin-bottom: 10px; }
  .metric-label { font-size: 12px; opacity: 0.9; margin-bottom: 5px; }
  .metric-value { font-size: 22px; font-weight: bold; font-family: 'Courier New', monospace; }
  .legend-dot { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
  .dot-red { background:#dc3545; border:1px solid #721c24; }
  .dot-green { background:#28a745; border:1px solid #155724; }
  .quick-access .btn { margin-right: 6px; margin-bottom: 6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .small-note { font-size:12px; color:#6c757d; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🎨 Decision Boundary Playground</h1>
<p>Compare decision boundaries for Logistic Regression, SVM (linear/RBF), kNN, and Decision Tree on classic datasets. Click on the canvas to add points, adjust hyperparameters, and watch the boundary change live.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="dbp">
  <div class="row">
    <!-- Left: Visualization -->
    <div class="col-lg-8 mb-4">
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Dataset & Decision Boundary</h5>
          <div class="small">
            <span class="legend-dot dot-green"></span>Class 1
            <span class="legend-dot dot-red ms-3"></span>Class 0
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="dbCanvas"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Boundary is shaded toward predicted class; darker means stronger confidence. Dashed line (when applicable) shows estimated boundary contour.</small>
          <div class="row mt-3">
            <div class="col-md-4">
              <div class="metric-card">
                <div class="metric-label">Accuracy</div>
                <div class="metric-value" id="mAcc">—</div>
              </div>
            </div>
            <div class="col-md-8 small-note">
              Click to add data points. Use the right panel to switch dataset/classifier and adjust hyperparameters.
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset -->
      <div class="control-section">
        <h6>📦 Dataset</h6>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnBlobs">Blobs</button>
          <button class="btn btn-outline-secondary" id="btnMoons">Moons</button>
          <button class="btn btn-outline-secondary" id="btnCircles">Circles</button>
        </div>
        <div class="row g-2">
          <div class="col">
            <label class="form-label small">Noise (σ)</label>
            <input type="number" id="dsNoise" class="form-control form-control-sm" value="0.35" step="0.05" min="0" max="2">
          </div>
          <div class="col">
            <label class="form-label small">Add class</label>
            <select id="classSel" class="form-select form-select-sm">
              <option value="1">Class 1 (Green)</option>
              <option value="0">Class 0 (Red)</option>
            </select>
          </div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnGen">Generate</button></div>
          <div class="col"><button class="btn btn-danger btn-sm w-100" id="btnClear">Clear</button></div>
        </div>
      </div>

      <!-- Classifier -->
      <div class="control-section">
        <h6>🤖 Classifier</h6>
        <div class="mb-2">
          <select id="clf" class="form-select form-select-sm">
            <option value="logistic" selected>Logistic Regression</option>
            <option value="svm">SVM</option>
            <option value="knn">kNN</option>
            <option value="tree">Decision Tree</option>
          </select>
        </div>

        <!-- Logistic -->
        <div id="secLogistic">
          <div class="slider-label"><span>LR</span><strong id="lrVal">0.10</strong></div>
          <input type="range" id="lr" min="0.001" max="1" step="0.001" value="0.10" class="form-range">
          <div class="slider-label"><span>Reg (C)</span><strong id="cLogVal">1.0</strong></div>
          <input type="range" id="cLog" min="0.1" max="10" step="0.1" value="1.0" class="form-range">
          <div class="slider-label"><span>Epochs/Step</span><strong id="epVal">20</strong></div>
          <input type="range" id="epochs" min="1" max="200" step="1" value="20" class="form-range">
          <div class="row g-2 mt-2">
            <div class="col"><button class="btn btn-success btn-sm w-100" id="btnTrainLog">Train Step</button></div>
            <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnResetLog">Reset</button></div>
          </div>
          <small class="text-muted d-block mt-1">Logistic requires training steps. Press Train Step after changing LR/C/epochs.</small>
        </div>

        <!-- SVM -->
        <div id="secSVM" style="display:none;">
          <div class="slider-label"><span>C</span><strong id="cSvmVal">1.0</strong></div>
          <input type="range" id="cSvm" min="0.1" max="10" step="0.1" value="1.0" class="form-range">
          <div class="mb-2">
            <label class="form-label small">Kernel</label>
            <select id="kernel" class="form-select form-select-sm">
              <option value="linear" selected>Linear</option>
              <option value="rbf">RBF</option>
            </select>
          </div>
          <div id="rowGamma">
            <div class="slider-label"><span>Gamma</span><strong id="gammaVal">1.0</strong></div>
            <input type="range" id="gamma" min="0.2" max="5" step="0.1" value="1.0" class="form-range">
          </div>
          <div class="slider-label"><span>LR</span><strong id="lrSvmVal">0.10</strong></div>
          <input type="range" id="lrSvm" min="0.001" max="1" step="0.001" value="0.10" class="form-range">
          <div class="slider-label"><span>Epochs/Step</span><strong id="epSvmVal">20</strong></div>
          <input type="range" id="epochsSvm" min="1" max="200" step="1" value="20" class="form-range">
          <div class="row g-2 mt-2">
            <div class="col"><button class="btn btn成功 btn-sm w-100" id="btnTrainSvm">Train Step</button></div>
            <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnResetSvm">Reset</button></div>
          </div>
          <small class="text-muted d-block mt-1">SVM requires training steps. For non‑linear boundaries, switch to RBF and adjust C/Gamma.</small>
        </div>

        <!-- kNN -->
        <div id="secKNN" style="display:none;">
          <div class="slider-label"><span>k (neighbors)</span><strong id="kVal">5</strong></div>
          <input type="range" id="k" min="1" max="25" step="1" value="5" class="form-range">
          <small class="text-muted d-block mt-1">kNN updates immediately when you change k (no training needed).</small>
        </div>

        <!-- Decision Tree -->
        <div id="secTree" style="display:none;">
          <div class="slider-label"><span>max_depth</span><strong id="depthVal">5</strong></div>
          <input type="range" id="maxDepth" min="1" max="12" step="1" value="5" class="form-range">
          <div class="slider-label"><span>min_leaf</span><strong id="minLeafVal">2</strong></div>
          <input type="range" id="minLeaf" min="1" max="20" step="1" value="2" class="form-range">
          <small class="text-muted d-block mt-1">Tree updates immediately when you change depth/leaf (no training button).</small>
        </div>

        <div class="row g-2 mt-3">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnRepaint">Repaint Boundary</button></div>
          <div class="col"><button class="btn btn-outline-primary btn-sm w-100" id="btnAcc">Compute Accuracy</button></div>
        </div>
      </div>

      <!-- Notes -->
      <div class="control-section">
        <h6>ℹ️ Notes</h6>
        <div class="small-note">
          Logistic and linear SVM are linear separators; RBF SVM bends the boundary using kernel features. kNN adapts to local neighborhoods; trees carve axis-aligned regions.
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
  var canvas=$('dbCanvas'), ctx=canvas.getContext('2d');
  function resizeCanvas(){ var p=canvas.parentElement; canvas.width=Math.max(320, p.clientWidth-4); canvas.height=Math.max(260, p.clientHeight-4); drawAll(); }
  window.addEventListener('resize', resizeCanvas);

  // Domain mapping [-2,2]
  function toCanvas(x,y){ var W=canvas.width,H=canvas.height; var nx=(x+2)/4, ny=(y+2)/4; return {cx:nx*W, cy:(1-ny)*H}; }
  function toDomain(cx,cy){ var W=canvas.width,H=canvas.height; var nx=cx/W, ny=1-(cy/H); return {x:nx*4-2, y:ny*4-2}; }

  // Data
  var points=[]; // {x,y,c}

  // CLF state
  var clfType='logistic';
  var Wlog = {w0:0, w1:0, b:0};
  var Wsvm = {w:[], b:0, rff:null}; // w over features
  var Wtree = null;
  var knnK = 5;

  // UI switches
  $('clf').addEventListener('change', function(){
    clfType=this.value;
    $('secLogistic').style.display = (clfType==='logistic')?'block':'none';
    $('secSVM').style.display      = (clfType==='svm')?'block':'none';
    $('secKNN').style.display      = (clfType==='knn')?'block':'none';
    $('secTree').style.display     = (clfType==='tree')?'block':'none';
    drawAll();
  });

  // Dataset generators
  function genBlobs(){
    points=[]; var s=parseFloat($('dsNoise').value);
    for(var i=0;i<120;i++) points.push({x:-1.2+randn()*s, y:-1.0+randn()*s, c:0});
    for(var j=0;j<120;j++) points.push({x: 1.2+randn()*s, y: 1.0+randn()*s, c:1});
    resetModels(); drawAll();
  }
  function genMoons(){
    points=[]; var s=parseFloat($('dsNoise').value);
    for(var i=0;i<100;i++){ var t=i/100*Math.PI; points.push({x:Math.cos(t)+randn()*s, y:Math.sin(t)+randn()*s, c:0}); }
    for(var j=0;j<100;j++){ var t2=j/100*Math.PI; points.push({x:Math.cos(t2)+0.9+randn()*s, y:-Math.sin(t2)+0.3+randn()*s, c:1}); }
    resetModels(); drawAll();
  }
  function genCircles(){
    points=[]; var s=parseFloat($('dsNoise').value);
    for(var i=0;i<120;i++){ var r=0.6+randn()*s*0.2; var t=2*Math.PI*Math.random(); points.push({x:r*Math.cos(t), y:r*Math.sin(t), c:0}); }
    for(var j=0;j<120;j++){ var r2=1.2+randn()*s*0.25; var t2=2*Math.PI*Math.random(); points.push({x:r2*Math.cos(t2), y:r2*Math.sin(t2), c:1}); }
    resetModels(); drawAll();
  }

  // Tiny toast for feedback
  function makeToast(){
    var t=document.createElement('div');
    Object.assign(t.style,{position:'fixed',right:'16px',bottom:'16px',padding:'8px 10px',background:'rgba(0,0,0,.7)',color:'#fff',borderRadius:'8px',fontSize:'12px',opacity:'0',transition:'opacity .2s',zIndex:9999});
    document.body.appendChild(t);
    return function(msg){ t.textContent=msg; t.style.opacity='1'; setTimeout(function(){t.style.opacity='0';},1000); };
  }
  var ping = makeToast();

  // Dataset selection state
  var currentDataset='blobs';
  function setDataset(ds){ currentDataset=ds; }

  $('btnBlobs').addEventListener('click', function(){ setDataset('blobs'); genBlobs(); ping('Blobs generated'); });
  $('btnMoons').addEventListener('click', function(){ setDataset('moons'); genMoons(); ping('Moons generated'); });
  $('btnCircles').addEventListener('click', function(){ setDataset('circles'); genCircles(); ping('Circles generated'); });
  $('btnGen').addEventListener('click', function(){
    if(currentDataset==='blobs') genBlobs();
    if(currentDataset==='moons') genMoons();
    if(currentDataset==='circles') genCircles();
    ping('Dataset regenerated: ' + currentDataset);
  });
  $('btnClear').addEventListener('click', function(){ points=[]; drawAll(); updateAcc(); ping('Cleared points'); });

  // Add point
  canvas.addEventListener('click', function(evt){
    var br=canvas.getBoundingClientRect();
    var x=evt.clientX - br.left, y=evt.clientY - br.top;
    var d=toDomain(x,y);
    var cls=parseInt($('classSel').value);
    points.push({x:d.x, y:d.y, c:cls});
    drawAll(); updateAcc();
  });

  // Logistic Regression
  $('lr').addEventListener('input', function(){ $('lrVal').textContent=parseFloat(this.value).toFixed(2); });
  $('cLog').addEventListener('input', function(){ $('cLogVal').textContent=parseFloat(this.value).toFixed(1); });
  $('epochs').addEventListener('input', function(){ $('epVal').textContent=this.value; });

  $('btnTrainLog').addEventListener('click', function(){
    if(points.length===0){ ping('Generate data first'); return; }
    var ep = parseInt($('epochs').value);
    trainLogistic(ep);
    ping('Trained ' + ep + ' epochs (Logistic)');
  });
  $('btnResetLog').addEventListener('click', function(){ Wlog={w0:0,w1:0,b:0}; drawAll(); updateAcc(); ping('Logistic reset'); });

  function trainLogistic(epochs){
    var lr=parseFloat($('lr').value), C=parseFloat($('cLog').value);
    var lambda = 1/Math.max(1e-6, C);
    for(var ep=0;ep<epochs;ep++){
      for(var i=0;i<points.length;i++){
        var p=points[i];
        var z = Wlog.w0*p.x + Wlog.w1*p.y + Wlog.b;
        var pr = sigmoid(z);
        var err = (pr - p.c);
        Wlog.w0 -= lr * (err*p.x + lambda*Wlog.w0);
        Wlog.w1 -= lr * (err*p.y + lambda*Wlog.w1);
        Wlog.b  -= lr * err;
      }
    }
    drawAll(); updateAcc();
  }
  function predictLog(x,y){
    var z=Wlog.w0*x + Wlog.w1*y + Wlog.b;
    return sigmoid(z);
  }

  // SVM (Linear; RBF via Random Fourier Features)
  $('cSvm').addEventListener('input', function(){ $('cSvmVal').textContent=parseFloat(this.value).toFixed(1); });
  $('lrSvm').addEventListener('input', function(){ $('lrSvmVal').textContent=parseFloat(this.value).toFixed(2); });
  $('epochsSvm').addEventListener('input', function(){ $('epSvmVal').textContent=this.value; });
  $('kernel').addEventListener('change', updateKernelVisibility);
  $('gamma').addEventListener('input', function(){ $('gammaVal').textContent=parseFloat(this.value).toFixed(1); });

  function updateKernelVisibility(){
    var k=$('kernel').value;
    $('rowGamma').style.display = (k==='rbf') ? 'block':'none';
    resetSvm();
  }
  function resetSvm(){ Wsvm={w:[], b:0, rff:null}; drawAll(); updateAcc(); }
  function resetModels(){
    // Reset all classifier parameters to defaults
    Wlog = { w0:0, w1:0, b:0 };
    Wsvm = { w:[], b:0, rff:null };
    Wtree = null;
    updateAcc();
  }

  $('btnTrainSvm').addEventListener('click', function(){
    if(points.length===0){ ping('Generate data first'); return; }
    var ep = parseInt($('epochsSvm').value);
    trainSvm(ep);
    ping('Trained ' + ep + ' epochs (SVM)');
  });
  $('btnResetSvm').addEventListener('click', function(){ resetSvm(); ping('SVM reset'); });

  function makeRFF(gamma, D){
    var W=[], b=[];
    for(var i=0;i<D;i++){
      var theta = Math.random()*2*Math.PI;
      var rx = randn()*Math.sqrt(2*gamma);
      var ry = randn()*Math.sqrt(2*gamma);
      W.push({x:rx, y:ry}); b.push(theta);
    }
    return {W:W, b:b, D:D, gamma:gamma};
  }
  function phiRFF(rff, x, y){
    var z=new Array(rff.D);
    for(var i=0;i<rff.D;i++){
      var proj = rff.W[i].x*x + rff.W[i].y*y + rff.b[i];
      z[i] = Math.sqrt(2/rff.D) * Math.cos(proj);
    }
    return z;
  }

  function trainSvm(epochs){
    var C=parseFloat($('cSvm').value), lr=parseFloat($('lrSvm').value), kernel=$('kernel').value;
    var useRbf = (kernel==='rbf');
    if(useRbf && !Wsvm.rff){ Wsvm.rff = makeRFF(parseFloat($('gamma').value), 100); Wsvm.w=new Array(100).fill(0); Wsvm.b=0; }
    if(!useRbf && Wsvm.w.length===0){ Wsvm.w=[0,0]; Wsvm.b=0; }

    for(var ep=0; ep<epochs; ep++){
      for(var i=0;i<points.length;i++){
        var p=points[i], y = (p.c===1?1:-1);
        var feat, margin;
        if(useRbf){
          feat = phiRFF(Wsvm.rff, p.x, p.y);
          margin = dot(Wsvm.w, feat) + Wsvm.b;
          if(y*margin < 1){
            // w := w - lr*(w - C*y*feat), b := b + lr*C*y
            Wsvm.w = wSub(Wsvm.w, wAdd(scale(Wsvm.w,1), scale(feat,-C*y)).map(function(v){ return lr*v; }));
            Wsvm.b += lr * C * y;
          } else {
            Wsvm.w = scale(Wsvm.w, (1 - lr)); // regularize
          }
        } else {
          feat = [p.x, p.y];
          margin = dot(Wsvm.w, feat) + Wsvm.b;
          if(y*margin < 1){
            Wsvm.w[0] -= lr*(Wsvm.w[0] - C*y*feat[0]);
            Wsvm.w[1] -= lr*(Wsvm.w[1] - C*y*feat[1]);
            Wsvm.b   += lr*C*y;
          } else {
            Wsvm.w[0] -= lr*Wsvm.w[0];
            Wsvm.w[1] -= lr*Wsvm.w[1];
          }
        }
      }
    }
    drawAll(); updateAcc();
  }
  function predictSvm(x,y){
    if($('kernel').value==='rbf'){
      if(!Wsvm.rff) return 0.5;
      var z=phiRFF(Wsvm.rff, x, y);
      var s=dot(Wsvm.w, z) + Wsvm.b;
      return 1/(1+Math.exp(-s)); // squash for visualization
    } else {
      if(Wsvm.w.length===0) return 0.5;
      var s=Wsvm.w[0]*x + Wsvm.w[1]*y + Wsvm.b;
      return 1/(1+Math.exp(-s));
    }
  }
  function dot(a,b){ var s=0; for(var i=0;i<a.length;i++) s+=a[i]*b[i]; return s; }
  function scale(a,k){ var z=[]; for(var i=0;i<a.length;i++) z.push(a[i]*k); return z; }
  function wAdd(a,b){ var z=[]; for(var i=0;i<a.length;i++) z.push(a[i]+b[i]); return z; }
  function wSub(a,b){ var z=[]; for(var i=0;i<a.length;i++) z.push(a[i]-b[i]); return z; }

  // kNN
  $('k').addEventListener('input', function(){ $('kVal').textContent=this.value; knnK=parseInt(this.value); drawAll(); updateAcc(); });
  function predictKNN(x,y){
    if(points.length===0) return 0.5;
    var dists=[];
    for(var i=0;i<points.length;i++){
      var dx=points[i].x-x, dy=points[i].y-y;
      dists.push({d:dx*dx+dy*dy, c:points[i].c});
    }
    dists.sort(function(a,b){ return a.d-b.d; });
    var k=Math.min(knnK, dists.length);
    var vote=0;
    for(var j=0;j<k;j++){ vote += (dists[j].c===1?1:0); }
    return vote/k;
  }

  // Decision Tree (simple axis-aligned)
  $('maxDepth').addEventListener('input', function(){ $('depthVal').textContent=this.value; Wtree=null; drawAll(); updateAcc(); });
  $('minLeaf').addEventListener('input', function(){ $('minLeafVal').textContent=this.value; Wtree=null; drawAll(); updateAcc(); });

  function impurity(labels){
    var n=labels.length; if(n===0) return 0;
    var c1=0; for(var i=0;i<n;i++) if(labels[i]===1) c1++;
    var p1=c1/n, p0=1-p1;
    return 1 - (p0*p0 + p1*p1);
  }
  function bestSplitIdx(idx, minLeaf){
    if(idx.length < 2*minLeaf) return null;
    var y = idx.map(function(i){ return points[i].c; });
    var base = impurity(y), best={gain:0};
    for(var ax=0; ax<2; ax++){
      var sorted = idx.slice().sort(function(a,b){ return (ax===0?points[a].x:points[a].y) - (ax===0?points[b].x:points[b].y); });
      for(var k=minLeaf; k<sorted.length-minLeaf; k++){
        var thr = ((ax===0?points[sorted[k-1]].x:points[sorted[k-1]].y) + (ax===0?points[sorted[k]].x:points[sorted[k]].y))/2;
        var left=[], right=[];
        for(var s=0;s<sorted.length;s++){
          var val=(ax===0?points[sorted[s]].x:points[sorted[s]].y);
          if(val<=thr) left.push(sorted[s]); else right.push(sorted[s]);
        }
        if(left.length<minLeaf || right.length<minLeaf) continue;
        var imp = (left.length/idx.length)*impurity(left.map(function(i){return points[i].c;})) + (right.length/idx.length)*impurity(right.map(function(i){return points[i].c;}));
        var gain = base - imp;
        if(gain>best.gain){ best={axis:ax,thr:thr,left:left,right:right,gain:gain}; }
      }
    }
    if(best.gain<=0) return null; return best;
  }
  function buildTreeIdx(idx, depth, maxDepth, minLeaf){
    var n=idx.length, c1=0; for(var i=0;i<n;i++) if(points[idx[i]].c===1) c1++;
    var maj=(c1*2>=n)?1:0;
    var node={leaf:false, axis:null, thr:null, left:null, right:null, pred:maj, pos:c1, neg:n-c1};
    if(depth>=maxDepth || c1===0 || c1===n || n<2*minLeaf){ node.leaf=true; return node; }
    var split = bestSplitIdx(idx, minLeaf);
    if(!split){ node.leaf=true; return node; }
    node.axis=split.axis; node.thr=split.thr;
    node.left = buildTreeIdx(split.left, depth+1, maxDepth, minLeaf);
    node.right= buildTreeIdx(split.right, depth+1, maxDepth, minLeaf);
    return node;
  }
  function ensureTree(){
    if(Wtree) return;
    var allIdx=[]; for(var i=0;i<points.length;i++) allIdx.push(i);
    Wtree = buildTreeIdx(allIdx, 0, parseInt($('maxDepth').value), parseInt($('minLeaf').value));
  }
  function predictTree(x,y){
    ensureTree();
    var node=Wtree;
    while(!node.leaf){
      var v=(node.axis===0?x:y);
      if(v<=node.thr) node=node.left; else node=node.right;
    }
    var tot=node.pos+node.neg; return tot>0 ? node.pos/tot : 0.5;
  }

  // Boundary rendering and metrics
  $('btnRepaint').addEventListener('click', function(){ drawAll(); });
  $('btnAcc').addEventListener('click', function(){ updateAcc(); });

  function updateAcc(){
    if(points.length===0){ $('mAcc').textContent='—'; return; }
    var correct=0;
    for(var i=0;i<points.length;i++){
      var p=points[i];
      var pr = predict(p.x,p.y);
      var pred = pr>0.5?1:0;
      if(pred===p.c) correct++;
    }
    $('mAcc').textContent = (100*correct/points.length).toFixed(1) + '%';
  }

  function predict(x,y){
    if(clfType==='logistic') return predictLog(x,y);
    if(clfType==='svm') return predictSvm(x,y);
    if(clfType==='knn') return predictKNN(x,y);
    // tree
    return predictTree(x,y);
  }

  function drawBoundary(){
    var step=6;
    for(var y=0;y<canvas.height;y+=step){
      for(var x=0;x<canvas.width;x+=step){
        var d=toDomain(x,y);
        var p = predict(d.x, d.y);
        var alpha = Math.abs(p-0.5)*0.35;
        ctx.fillStyle = p>0.5 ? ('rgba(40,167,69,'+alpha+')') : ('rgba(220,53,69,'+alpha+')');
        ctx.fillRect(x,y,step,step);
      }
    }
    // If linear models, draw a dashed boundary line approximation
    if(clfType==='logistic'){
      if(Math.abs(Wlog.w1)>1e-6){
        var xL=-2, xR=2;
        var yL=-(Wlog.w0/Wlog.w1)*xL - Wlog.b/Wlog.w1;
        var yR=-(Wlog.w0/Wlog.w1)*xR - Wlog.b/Wlog.w1;
        var cL=toCanvas(xL,yL), cR=toCanvas(xR,yR);
        ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(cL.cx,cL.cy); ctx.lineTo(cR.cx,cR.cy); ctx.stroke(); ctx.setLineDash([]);
      }
    } else if(clfType==='svm' && $('kernel').value==='linear' && Wsvm.w.length===2){
      if(Math.abs(Wsvm.w[1])>1e-6){
        var xL2=-2, xR2=2;
        var yL2=-(Wsvm.w[0]/Wsvm.w[1])*xL2 - Wsvm.b/Wsvm.w[1];
        var yR2=-(Wsvm.w[0]/Wsvm.w[1])*xR2 - Wsvm.b/Wsvm.w[1];
        var cL2=toCanvas(xL2,yL2), cR2=toCanvas(xR2,yR2);
        ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(cL2.cx,cL2.cy); ctx.lineTo(cR2.cx,cR2.cy); ctx.stroke(); ctx.setLineDash([]);
      }
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
    if(!canvas.width) resizeCanvas();
    ctx.clearRect(0,0,canvas.width,canvas.height);
    drawBoundary();
    drawPoints();
  }

  // Init
  resizeCanvas();
  genBlobs();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">How to use & What to observe</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Quick start</h6>
        <ol class="mb-2">
          <li>Click a dataset (Blobs/Moons/Circles) → Generate.</li>
          <li>Pick a classifier. For Logistic/SVM press <strong>Train Step</strong> after changing sliders. kNN/Tree update immediately.</li>
          <li>Watch the boundary color: green/red regions = predicted class; darker = higher confidence.</li>
          <li>Click on the canvas to add points and see the model adapt.</li>
        </ol>
        <h6>What to compare</h6>
        <ul class="mb-0">
          <li><strong>Linear vs non‑linear:</strong> Circles with Linear SVM vs RBF SVM.</li>
          <li><strong>Local vs global:</strong> kNN (local) vs Logistic/SVM (global) on Moons.</li>
          <li><strong>Simplicity vs fit:</strong> Tree depth small vs large on Blobs.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Troubleshooting</h6>
        <ul class="mb-2">
          <li>No change on Train Step? Generate data first, then train.</li>
          <li>Boundary unchanged? Increase epochs or learning rate (Logistic/SVM) or adjust C/Gamma.</li>
          <li>Too jagged (overfit)? Increase k (kNN) or decrease depth (Tree).</li>
        </ul>
        <div class="small text-muted">Goal: build intuition for how algorithms shape decision boundaries and how hyperparameters change that shape.</div>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
