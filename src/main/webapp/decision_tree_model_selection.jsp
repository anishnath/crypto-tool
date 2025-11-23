<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Decision Tree Model Selection Lab - Cross-validation, validation curves, pruning, and grid search with live decision regions.">
<meta name="keywords" content="decision tree, model selection, cross validation, validation curve, pruning, grid search, gini, entropy">
<title>Decision Tree Model Selection Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Decision Tree Model Selection Lab",
  "description": "Interactive lab for selecting decision tree hyperparameters with k-fold cross-validation, validation curves, pruning, and grid search. Visualize decision regions and splits.",
  "url": "https://8gwifi.org/decision_tree_model_selection.jsp",
  "keywords": "decision tree, cross-validation, pruning, validation curve, grid search, gini, entropy"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .dtms-lab { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }

  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:240px; }

  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }

  #dtmsCanvas { width:100%; height:100%; background:#ffffff; border:2px solid #e9ecef; border-radius:6px; cursor:crosshair; }
  #heatCanvas { width:100%; height:100%; background:#ffffff; border:2px solid #e9ecef; border-radius:6px; }

  .metric-card { background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.green { background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%); }
  .metric-card.pink { background:linear-gradient(135deg,#f093fb 0%,#f5576c 100%); }
  .metric-label { font-size:12px; opacity:0.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }

  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }

  .legend-dot { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
  .dot-red { background:#dc3545; border:1px solid #721c24; }
  .dot-green { background:#28a745; border:1px solid #155724; }

  .small-note { font-size:12px; color:#6c757d; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🧪 Decision Tree Model Selection Lab</h1>
<p>Choose the best decision tree using cross-validation, validation curves, pruning, and a simple grid search. Watch decision regions and splits in real time.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#valcurve" class="btn btn-outline-primary">Validation Curve</a>
    <a href="#grid" class="btn btn-outline-primary">Grid Search</a>
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
      <li><strong>Generate dataset</strong> (Balanced/Overlap/XOR/Moons/Circles) then click <strong>Run CV & Recommend</strong>.</li>
      <li>Use the <strong>Validation Curve</strong> to sweep <em>max_depth</em> and see train vs CV score (over/underfitting).</li>
      <li>Try the <strong>Grid Search</strong> on <em>max_depth × min_samples_leaf</em> and pick a stable, simpler model.</li>
    </ol>
    <div class="small-note">Tip: Prefer models with high CV mean and low std; tie‑break in favor of smaller depth.</div>
  </div>
</div>

<div class="dtms-lab">
  <div class="row">
    <!-- Left column -->
    <div class="col-lg-8 mb-4">
      <!-- Visualization -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Dataset & Decision Regions</h5>
          <div class="small">
            <span class="legend-dot dot-green"></span>Class 1
            <span class="legend-dot dot-red ms-3"></span>Class 0
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="dtmsCanvas"></canvas>
          </div>
          <div class="form-check form-switch mt-2">
            <input class="form-check-input" type="checkbox" id="chkSplits" checked>
            <label class="form-check-label small" for="chkSplits">Show split lines</label>
          </div>
          <small class="text-muted d-block mt-2">Decision regions are colored softly by the predicted class; dashed lines show tree thresholds.</small>
        </div>
      </div>

      <!-- Validation Curve -->
      <div class="card mb-4" id="valcurve">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Validation Curve</h5>
          <div class="small">
            <label class="form-label small mb-0 me-2">Sweep</label>
            <select id="sweepParam" class="form-select form-select-sm" style="width:auto; display:inline-block;">
              <option value="maxDepth" selected>max_depth</option>
              <option value="minLeaf">min_samples_leaf</option>
              <option value="alpha">ccp_alpha</option>
            </select>
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="valChart"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Train vs CV score across the selected hyperparameter. Overfitting shows as high train and low CV.</small>
        </div>
      </div>

      <!-- Grid Search Heatmap -->
      <div class="card mb-4" id="grid">
        <div class="card-header">
          <h5 class="mb-0">Grid Search (max_depth × min_samples_leaf)</h5>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="heatCanvas"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Cells colored by CV score (darker = better). Click a cell to apply those hyperparameters.</small>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset -->
      <div class="control-section">
        <h6>📦 Dataset</h6>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnBalanced">Balanced</button>
          <button class="btn btn-outline-secondary" id="btnOverlap">Overlap</button>
        </div>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnXOR">XOR</button>
          <button class="btn btn-outline-secondary" id="btnMoons">Moons</button>
          <button class="btn btn-outline-secondary" id="btnCircles">Circles</button>
        </div>
        <div class="row g-2">
          <div class="col">
            <select id="classSel" class="form-select form-select-sm">
              <option value="1">Class 1 (Green)</option>
              <option value="0">Class 0 (Red)</option>
            </select>
          </div>
          <div class="col">
            <button class="btn btn-danger btn-sm w-100" id="btnClear">Clear Points</button>
          </div>
        </div>
        <small class="text-muted d-block mt-2">Click the canvas to add points for the selected class.</small>
      </div>

      <!-- Model Selection -->
      <div class="control-section">
        <h6>⚙️ Model Selection</h6>
        <div class="mb-2">
          <label class="form-label small">Criterion</label>
          <select id="criterion" class="form-select form-select-sm">
            <option value="gini" selected>Gini</option>
            <option value="entropy">Entropy</option>
          </select>
        </div>
        <div class="slider-label"><span>max_depth</span><strong id="depthVal">5</strong></div>
        <input type="range" id="maxDepth" min="1" max="12" step="1" value="5" class="form-range">

        <div class="slider-label"><span>min_samples_split</span><strong id="minSplitVal">4</strong></div>
        <input type="range" id="minSplit" min="2" max="20" step="1" value="4" class="form-range">

        <div class="slider-label"><span>min_samples_leaf</span><strong id="minLeafVal">2</strong></div>
        <input type="range" id="minLeaf" min="1" max="20" step="1" value="2" class="form-range">

        <div class="slider-label"><span>max_features</span><strong id="mfeatVal">2</strong></div>
        <input type="range" id="maxFeatures" min="1" max="2" step="1" value="2" class="form-range">

        <div class="slider-label"><span>ccp_alpha</span><strong id="alphaVal">0.00</strong></div>
        <input type="range" id="alpha" min="0" max="0.05" step="0.005" value="0.00" class="form-range">

        <div class="slider-label"><span>K-folds</span><strong id="kVal">5</strong></div>
        <input type="range" id="kfolds" min="3" max="10" step="1" value="5" class="form-range">

        <div class="mb-2">
          <label class="form-label small">Score metric</label>
          <select id="metric" class="form-select form-select-sm">
            <option value="accuracy" selected>Accuracy</option>
            <option value="f1">F1</option>
            <option value="balanced">Balanced Accuracy</option>
            <option value="prauc">PR AUC</option>
            <option value="cost">Cost-based</option>
          </select>
        </div>

        <div class="mb-2">
          <label class="form-label small">Validation strategy</label>
          <select id="valStrategy" class="form-select form-select-sm">
            <option value="random" selected>Random K-Fold</option>
            <option value="forward">Forward-Chaining</option>
          </select>
        </div>
        <small class="text-muted d-block mb-2">Random assumes i.i.d.; Forward‑Chaining respects time order and is preferred when data drifts or is temporal.</small>

        <div class="slider-label"><span>Cost FP</span><strong id="costFPVal">1.0</strong></div>
        <input type="range" id="costFP" min="0" max="10" step="0.5" value="1.0" class="form-range">

        <div class="slider-label"><span>Cost FN</span><strong id="costFNVal">5.0</strong></div>
        <input type="range" id="costFN" min="0" max="10" step="0.5" value="5.0" class="form-range">
        <small class="text-muted d-block mb-2">Cost-based CV chooses the threshold that minimizes FP/FN cost on each validation fold and reports a normalized score (higher is better).</small>

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnRunCV">Run CV & Recommend</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnValCurve">Compute Curve</button></div>
        </div>
      </div>

      <!-- CV Metrics -->
      <div class="control-section">
        <h6>📊 CV Metrics</h6>
        <div class="small">
          <div>CV Mean: <strong id="cvMean">—</strong></div>
          <div>CV Std: <strong id="cvStd">—</strong></div>
          <div>Recommended: <strong id="recParams">—</strong></div>
        </div>
      </div>

      <!-- Final Test (Hold-out) -->
      <div class="control-section">
        <h6>🧪 Final Test (Hold-out)</h6>
        <div class="small">Create a final test set not used during model selection and evaluate once.</div>
        <div class="row g-2 mt-2">
          <div class="col-6">
            <label class="form-label small">Test %</label>
            <input type="number" id="testPct" class="form-control form-control-sm" value="20" min="5" max="50" step="5">
          </div>
          <div class="col-6">
            <button class="btn btn-outline-primary btn-sm w-100" id="btnMakeTest">Create Final Test</button>
          </div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col">
            <button class="btn btn-primary btn-sm w-100" id="btnEvalTest">Evaluate on Final Test</button>
          </div>
        </div>
        <div class="small mt-2">Final Test Score: <strong id="testScore">—</strong></div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function() {
  function $(id){ return document.getElementById(id); }
  function randn(){ var u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }

  // Canvas
  var canvas=$('dtmsCanvas'), ctx=canvas.getContext('2d');
  function resizeCanvas(){ var p=canvas.parentElement; canvas.width=Math.max(320, p.clientWidth-4); canvas.height=Math.max(260, p.clientHeight-4); drawAll(); }
  window.addEventListener('resize', resizeCanvas);

  // Heatmap canvas
  var heat=$('heatCanvas'), hctx=heat.getContext('2d');
  function resizeHeat(){ var p=heat.parentElement; heat.width=Math.max(320, p.clientWidth-4); heat.height=Math.max(200, p.clientHeight-4); drawHeatmap(); }
  window.addEventListener('resize', resizeHeat);

  // Domain mapping [-2,2]
  function toCanvas(x,y){ var W=canvas.width,H=canvas.height; var nx=(x+2)/4, ny=(y+2)/4; return {cx:nx*W, cy:(1-ny)*H}; }
  function toDomain(cx,cy){ var W=canvas.width,H=canvas.height; var nx=cx/W, ny=1-(cy/H); return {x:nx*4-2, y:ny*4-2}; }

  // Data
  var points=[]; // {x,y,c}
  var showSplits=true;

  // Tree model
  var tree=null;

  // Charts
  var valChart = new Chart($('valChart'), {
    type:'line',
    data:{ labels:[], datasets:[
      { label:'Train', data:[], borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.1)', tension:0.2 },
      { label:'CV',    data:[], borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.1)', tension:0.2 }
    ]},
    options:{ responsive:true, maintainAspectRatio:false, scales:{ x:{ title:{display:true,text:'Hyperparameter'}}, y:{ min:0, max:1, title:{display:true,text:'Score'} } }, plugins:{ legend:{ display:true } } }
  });

  // Impurity
  function impurityGini(labels){ var n=labels.length; if(n===0) return 0; var c1=0; for(var i=0;i<n;i++) if(labels[i]===1) c1++; var p1=c1/n, p0=1-p1; return 1 - (p0*p0 + p1*p1); }
  function impurityEntropy(labels){ var n=labels.length; if(n===0) return 0; var c1=0; for(var i=0;i<n;i++) if(labels[i]===1) c1++; var p1=c1/n, p0=1-p1; function H(p){ return p<=0?0: -p*Math.log2(p); } return H(p0)+H(p1); }
  function criterionImp(labels){ return ($('criterion').value==='gini') ? impurityGini(labels) : impurityEntropy(labels); }

  // Best split with ccp_alpha gain threshold and feature subset
  function bestSplit(samples, minLeaf, maxFeatures, alpha){
    if(samples.length < 2*minLeaf) return null;
    var features=[0,1];
    if(maxFeatures===1){ features = [ Math.random()<0.5 ? 0 : 1 ]; }
    var y = samples.map(function(i){ return points[i].c; });
    var base = criterionImp(y);
    var best = {gain:0};
    for(var fi=0; fi<features.length; fi++){
      var ax = features[fi];
      var sorted = samples.slice().sort(function(a,b){ return (ax===0?points[a].x:points[a].y) - (ax===0?points[b].x:points[b].y); });
      for(var k=minLeaf; k<sorted.length-minLeaf; k++){
        var v1 = (ax===0?points[sorted[k-1]].x:points[sorted[k-1]].y);
        var v2 = (ax===0?points[sorted[k]].x:points[sorted[k]].y);
        var thr = (v1+v2)/2;
        var left=[], right=[];
        for(var s=0;s<sorted.length;s++){
          var vv = (ax===0?points[sorted[s]].x:points[sorted[s]].y);
          if(vv<=thr) left.push(sorted[s]); else right.push(sorted[s]);
        }
        if(left.length<minLeaf || right.length<minLeaf) continue;
        var yL=left.map(function(i){return points[i].c;});
        var yR=right.map(function(i){return points[i].c;});
        var imp = (left.length/samples.length)*criterionImp(yL) + (right.length/samples.length)*criterionImp(yR);
        var gain = base - imp;
        if(gain > best.gain){ best = {axis:ax, thr:thr, gain:gain, left:left, right:right}; }
      }
    }
    if(best.gain <= alpha) return null;
    return best;
  }

  function buildTree(samples, depth, maxDepth, minSplit, minLeaf, maxFeatures, alpha){
    var y = samples.map(function(i){ return points[i].c; });
    var n = samples.length;
    var node = { leaf:false, axis:null, thr:null, left:null, right:null, pred:null, depth:depth, leaves:1, n:n, pos:0, neg:0 };
    var c1=0; for(var i=0;i<n;i++) if(points[samples[i]].c===1) c1++;
    var maj = (c1*2>=n) ? 1 : 0;
    if(depth>=maxDepth || n<minSplit || c1===0 || c1===n){
      node.leaf=true; node.pred=maj; node.pos=c1; node.neg=n-c1; return node;
    }
    var split = bestSplit(samples, minLeaf, maxFeatures, alpha);
    if(!split){ node.leaf=true; node.pred=maj; node.pos=c1; node.neg=n-c1; return node; }
    node.axis=split.axis; node.thr=split.thr;
    node.left = buildTree(split.left, depth+1, maxDepth, minSplit, minLeaf, maxFeatures, alpha);
    node.right= buildTree(split.right,depth+1, maxDepth, minSplit, minLeaf, maxFeatures, alpha);
    node.depth = Math.max(node.left.depth, node.right.depth);
    node.leaves = (node.left.leaf?1:node.left.leaves) + (node.right.leaf?1:node.right.leaves);
    node.pos = (node.left.pos||0) + (node.right.pos||0);
    node.neg = (node.left.neg||0) + (node.right.neg||0);
    return node;
  }

  function predictTree(node, x, y){
    while(!node.leaf){
      var v = node.axis===0 ? x : y;
      if(v<=node.thr) node=node.left; else node=node.right;
    }
    return node.pred;
  }

  // Metrics
  function accuracyOnIdx(modelTree, idx){
    if(idx.length===0) return 0;
    var correct=0;
    for(var i=0;i<idx.length;i++){ var p=points[idx[i]]; if(predictTree(modelTree,p.x,p.y)===p.c) correct++; }
    return correct/idx.length;
  }
  function f1OnIdx(modelTree, idx){
    var tp=0, fp=0, fn=0, tn=0;
    for(var i=0;i<idx.length;i++){
      var p=points[idx[i]], pred=predictTree(modelTree,p.x,p.y);
      if(pred===1 && p.c===1) tp++; else
      if(pred===1 && p.c===0) fp++; else
      if(pred===0 && p.c===1) fn++; else tn++;
    }
    var prec = tp+fp>0 ? tp/(tp+fp) : 1;
    var rec  = tp+fn>0 ? tp/(tp+fn) : 0;
    return (prec+rec)>0 ? 2*prec*rec/(prec+rec) : 0;
  }
  function balancedAccOnIdx(modelTree, idx){
    var tp=0, fp=0, fn=0, tn=0;
    for(var i=0;i<idx.length;i++){
      var p=points[idx[i]], pred=predictTree(modelTree,p.x,p.y);
      if(pred===1 && p.c===1) tp++; else
      if(pred===1 && p.c===0) fp++; else
      if(pred===0 && p.c===1) fn++; else tn++;
    }
    var tpr = tp+fn>0 ? tp/(tp+fn) : 0;
    var tnr = tn+fp>0 ? tn/(tn+fp) : 0;
    return (tpr + tnr)/2;
  }
  function predictProbaTree(node, x, y){
    while(!node.leaf){
      var v = node.axis===0 ? x : y;
      if(v<=node.thr) node=node.left; else node=node.right;
    }
    var tot = (node.pos||0) + (node.neg||0);
    return tot>0 ? (node.pos||0)/tot : 0.5;
  }

  function prAucOnIdx(modelTree, idx){
    if(idx.length===0) return 0;
    var probs=[], labels=[];
    for(var i=0;i<idx.length;i++){ var p=points[idx[i]]; probs.push(predictProbaTree(modelTree,p.x,p.y)); labels.push(p.c); }
    var order = probs.map(function(_,i){return i;}).sort(function(a,b){ return probs[b]-probs[a]; });
    var tp=0, fp=0, fn=0, tn=0, P=0, N=0;
    for(var j=0;j<labels.length;j++){ if(labels[j]===1) P++; else N++; }
    fn=P; tn=N;
    var curve=[{x:0,y:1}]; var last=-1;
    for(var k=0;k<order.length;k++){
      var i = order[k];
      if(labels[i]===1){ tp++; fn--; } else { fp++; tn--; }
      var rec = P>0 ? tp/P : 0;
      var prec = (tp+fp)>0 ? tp/(tp+fp) : 1;
      if(probs[i]!==last){ curve.push({x:rec, y:prec}); last=probs[i]; }
    }
    // trapezoidal approx over recall (x)
    var ap=0;
    curve.sort(function(a,b){ return a.x - b.x; });
    for(var t=1;t<curve.length;t++){
      var x0=curve[t-1].x, y0=curve[t-1].y, x1=curve[t].x, y1=curve[t].y;
      ap += (x1-x0) * ((y0+y1)/2);
    }
    return Math.max(0, Math.min(1, ap));
  }

  function costScoreOnIdx(modelTree, idx, cFP, cFN){
    if(idx.length===0) return 0;
    var probs=[], labels=[];
    for(var i=0;i<idx.length;i++){ var p=points[idx[i]]; probs.push(predictProbaTree(modelTree,p.x,p.y)); labels.push(p.c); }
    var order = probs.map(function(_,i){return i;}).sort(function(a,b){ return probs[b]-probs[a]; });
    var bestCost=Infinity;
    var P=0,N=0; for(var j=0;j<labels.length;j++){ if(labels[j]===1) P++; else N++; }
    var tp=0, fp=0, fn=P, tn=N, last=-1;
    for(var k=0;k<order.length;k++){
      var i=order[k];
      if(labels[i]===1){ tp++; fn--; } else { fp++; tn--; }
      if(probs[i]!==last){
        var cost = cFP*fp + cFN*fn;
        if(cost<bestCost) bestCost=cost;
        last=probs[i];
      }
    }
    var denom = cFN*P + cFP*N;
    var score = denom>0 ? 1 - (bestCost/denom) : 0;
    return Math.max(0, Math.min(1, score));
  }

  function scoreOnIdx(modelTree, idx){
    var m = $('metric').value;
    if(m==='accuracy') return accuracyOnIdx(modelTree, idx);
    if(m==='f1') return f1OnIdx(modelTree, idx);
    if(m==='balanced') return balancedAccOnIdx(modelTree, idx);
    if(m==='prauc') return prAucOnIdx(modelTree, idx);
    if(m==='cost'){
      var cFP=parseFloat($('costFP').value), cFN=parseFloat($('costFN').value);
      return costScoreOnIdx(modelTree, idx, cFP, cFN);
    }
    return accuracyOnIdx(modelTree, idx);
  }

  // K-fold indices (random)
  function kFoldIndices(n, k){
    var idx=[]; for(var i=0;i<n;i++) idx.push(i);
    idx = shuffle(idx);
    var folds=[]; var size=Math.floor(n/k);
    var start=0;
    for(var f=0; f<k-1; f++){ folds.push(idx.slice(start,start+size)); start+=size; }
    folds.push(idx.slice(start));
    return folds;
  }

  // Forward-chaining folds: sequential windows; validate on fold f, train on all previous
  function forwardFolds(n, k){
    var idx=[]; for(var i=0;i<n;i++) idx.push(i);
    var size=Math.floor(n/k);
    var folds=[];
    var start=0;
    for(var f=0; f<k-1; f++){ folds.push(idx.slice(start,start+size)); start+=size; }
    folds.push(idx.slice(start));
    return folds;
  }
  function shuffle(a){ for(var i=a.length-1;i>0;i--){ var j=Math.floor(Math.random()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } return a; }

  // CV run
  function runCV(params){
    var k = parseInt($('kfolds').value);
    var strategy = $('valStrategy').value; // 'random' or 'forward'
    var scores=[], trainScores=[], depths=[];
    if(strategy==='forward'){
      var folds = forwardFolds(points.length, k);
      for(var f=1; f<k; f++){ // start from 1 to ensure training has previous data
        var valIdx = folds[f];
        var trainIdx=[];
        for(var g=0; g<f; g++){ trainIdx = trainIdx.concat(folds[g]); }
        if(trainIdx.length===0 || valIdx.length===0) continue;
        var t = buildTree(trainIdx, 0, params.maxDepth, params.minSplit, params.minLeaf, params.maxFeatures, params.alpha);
        var sVal = scoreOnIdx(t, valIdx);
        var sTr  = scoreOnIdx(t, trainIdx);
        scores.push(sVal); trainScores.push(sTr); depths.push(t.depth);
      }
    } else {
      var folds = kFoldIndices(points.length, k);
      for(var f=0; f<k; f++){
        var valIdx = folds[f];
        var trainIdx=[];
        for(var g=0; g<k; g++){ if(g!==f) trainIdx = trainIdx.concat(folds[g]); }
        if(trainIdx.length===0 || valIdx.length===0) continue;
        var t = buildTree(trainIdx, 0, params.maxDepth, params.minSplit, params.minLeaf, params.maxFeatures, params.alpha);
        var sVal = scoreOnIdx(t, valIdx);
        var sTr  = scoreOnIdx(t, trainIdx);
        scores.push(sVal); trainScores.push(sTr); depths.push(t.depth);
      }
    }
    var mean = meanArr(scores), std = stdArr(scores, mean);
    return { mean:mean, std:std, train:meanArr(trainScores), depth:meanArr(depths) };
  }
  function meanArr(a){ if(a.length===0) return 0; var s=0; for(var i=0;i<a.length;i++) s+=a[i]; return s/a.length; }
  function stdArr(a, m){ if(a.length===0) return 0; var s=0; for(var i=0;i<a.length;i++){ var d=a[i]-m; s+=d*d; } return Math.sqrt(s/a.length); }

  // Validation curve sweep
  function computeValCurve(){
    var sweep = $('sweepParam').value;
    var base = getParams();
    var xs=[], tr=[], cv=[];
    var grid=[];
    if(sweep==='maxDepth'){
      for(var d=1; d<=12; d++){
        base.maxDepth=d;
        var r=runCV(base);
        xs.push(''+d); tr.push(r.train); cv.push(r.mean);
      }
    } else if(sweep==='minLeaf'){
      for(var ml=1; ml<=20; ml+=1){
        base.minLeaf=ml;
        var r2=runCV(base);
        xs.push(''+ml); tr.push(r2.train); cv.push(r2.mean);
      }
    } else {
      for(var a=0; a<=0.05; a+=0.005){
        base.alpha=parseFloat(a.toFixed(3));
        var r3=runCV(base);
        xs.push((''+a.toFixed(3))); tr.push(r3.train); cv.push(r3.mean);
      }
    }
    valChart.data.labels=xs;
    valChart.data.datasets[0].data=tr;
    valChart.data.datasets[1].data=cv;
    valChart.update('none');
  }

  // Grid search heatmap over max_depth × min_samples_leaf
  var heatData={ xs:[], ys:[], mat:[] };
  function computeHeatmap(){
    var base = getParams();
    var depths=[2,4,6,8,10,12];
    var leaves=[1,2,3,4,5,8,12,16,20];
    heatData={ xs:depths, ys:leaves, mat:[] };
    for(var yi=0; yi<leaves.length; yi++){
      var row=[];
      for(var xi=0; xi<depths.length; xi++){
        base.maxDepth=depths[xi];
        base.minLeaf=leaves[yi];
        var r=runCV(base);
        row.push(r.mean);
      }
      heatData.mat.push(row);
    }
    drawHeatmap();
  }
  function drawHeatmap(){
    var W=heat.width, H=heat.height;
    hctx.clearRect(0,0,W,H);
    if(!heatData.mat || heatData.mat.length===0) return;
    var rows=heatData.mat.length, cols=heatData.mat[0].length;
    var cw=W/cols, ch=H/rows;
    var min=1, max=0;
    for(var r=0;r<rows;r++){ for(var c=0;c<cols;c++){ var v=heatData.mat[r][c]; if(v<min) min=v; if(v>max) max=v; } }
    function color(v){
      var t = (v - min) / (Math.max(1e-9, (max-min)));
      var r = Math.floor(255 * (1 - t));
      var g = Math.floor(200 * t + 30);
      var b = Math.floor(80  * (1 - t) + 50);
      return 'rgb(' + r + ',' + g + ',' + b + ')';
    }
    for(var r2=0;r2<rows;r2++){
      for(var c2=0;c2<cols;c2++){
        hctx.fillStyle=color(heatData.mat[r2][c2]);
        hctx.fillRect(c2*cw, r2*ch, cw-1, ch-1);
      }
    }
    // axes labels
    hctx.fillStyle='#212529';
    hctx.font='12px sans-serif';
    for(var c3=0;c3<cols;c3++){
      var label='d=' + heatData.xs[c3];
      hctx.fillText(label, c3*cw+4, 12);
    }
    for(var r3=0;r3<rows;r3++){
      var label2='leaf=' + heatData.ys[r3];
      hctx.fillText(label2, 4, r3*ch+ch-4);
    }
  }

  // Visualization drawing
  function drawRegions(){
    var step=6;
    for(var y=0;y<canvas.height;y+=step){
      for(var x=0;x<canvas.width;x+=step){
        var d=toDomain(x,y);
        var pred = tree ? predictTree(tree, d.x, d.y) : -1;
        var alpha=0.12;
        if(pred===-1){ ctx.fillStyle='rgba(0,0,0,0)'; }
        else ctx.fillStyle = pred===1 ? ('rgba(40,167,69,'+alpha+')') : ('rgba(220,53,69,'+alpha+')');
        ctx.fillRect(x,y,step,step);
      }
    }
  }
  function drawSplits(node, rect){
    if(!showSplits || !node || node.leaf) return;
    if(node.axis===0){
      var sx=node.thr;
      var a=toCanvas(sx,rect.ymin), b=toCanvas(sx,rect.ymax);
      ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.beginPath(); ctx.moveTo(a.cx,a.cy); ctx.lineTo(b.cx,b.cy); ctx.stroke(); ctx.setLineDash([]);
      drawSplits(node.left, {xmin:rect.xmin, xmax:sx, ymin:rect.ymin, ymax:rect.ymax});
      drawSplits(node.right,{xmin:sx, xmax:rect.xmax, ymin:rect.ymin, ymax:rect.ymax});
    } else {
      var sy=node.thr;
      var c=toCanvas(rect.xmin,sy), d=toCanvas(rect.xmax,sy);
      ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.beginPath(); ctx.moveTo(c.cx,c.cy); ctx.lineTo(d.cx,d.cy); ctx.stroke(); ctx.setLineDash([]);
      drawSplits(node.left, {xmin:rect.xmin, xmax:rect.xmax, ymin:rect.ymin, ymax:sy});
      drawSplits(node.right,{xmin:rect.xmin, xmax:rect.xmax, ymin:sy, ymax:rect.ymax});
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
    drawRegions();
    if(tree && showSplits) drawSplits(tree, {xmin:-2,xmax:2,ymin:-2,ymax:2});
    drawPoints();
  }

  // Apply selected params and train on full data for visualization
  function fitOnAll(params){
    var idx=[]; for(var i=0;i<points.length;i++) idx.push(i);
    return buildTree(idx, 0, params.maxDepth, params.minSplit, params.minLeaf, params.maxFeatures, params.alpha);
  }

  function getParams(){
    return {
      maxDepth: parseInt($('maxDepth').value),
      minSplit: parseInt($('minSplit').value),
      minLeaf:  parseInt($('minLeaf').value),
      maxFeatures: parseInt($('maxFeatures').value),
      alpha: parseFloat($('alpha').value)
    };
  }

  // Events: dataset
  $('btnBalanced').addEventListener('click', genBalanced);
  $('btnOverlap').addEventListener('click', genOverlap);
  $('btnXOR').addEventListener('click', genXOR);
  $('btnMoons').addEventListener('click', genMoons);
  $('btnCircles').addEventListener('click', genCircles);
  $('btnClear').addEventListener('click', function(){ points=[]; tree=null; drawAll(); });

  canvas.addEventListener('click', function(evt){
    var br=canvas.getBoundingClientRect();
    var x=evt.clientX - br.left, y=evt.clientY - br.top;
    var d=toDomain(x,y);
    var cls=parseInt($('classSel').value);
    points.push({x:d.x, y:d.y, c:cls});
    drawAll();
  });

  // Events: controls
  $('maxDepth').addEventListener('input', function(){ $('depthVal').textContent=this.value; tree = fitOnAll(getParams()); drawAll(); });
  $('minSplit').addEventListener('input', function(){ $('minSplitVal').textContent=this.value; tree = fitOnAll(getParams()); drawAll(); });
  $('minLeaf').addEventListener('input', function(){ $('minLeafVal').textContent=this.value; tree = fitOnAll(getParams()); drawAll(); });
  $('maxFeatures').addEventListener('input', function(){ $('mfeatVal').textContent=this.value; tree = fitOnAll(getParams()); drawAll(); });
  $('alpha').addEventListener('input', function(){ $('alphaVal').textContent=parseFloat(this.value).toFixed(3); tree = fitOnAll(getParams()); drawAll(); });
  $('chkSplits').addEventListener('change', function(){ showSplits=this.checked; drawAll(); });

  $('btnValCurve').addEventListener('click', computeValCurve);
  $('sweepParam').addEventListener('change', function(){ computeValCurve(); });

  // Display slider values for costs
  $('costFP').addEventListener('input', function(){ $('costFPVal').textContent=parseFloat(this.value).toFixed(1); });
  $('costFN').addEventListener('input', function(){ $('costFNVal').textContent=parseFloat(this.value).toFixed(1); });

  $('btnRunCV').addEventListener('click', function(){
    var p=getParams();
    var r=runCV(p);
    $('cvMean').textContent = r.mean.toFixed(3);
    $('cvStd').textContent  = r.std.toFixed(3);
    // Recommend: perform a small local search around current params for stability
    var best={ score:-1, params:null };
    for(var d=Math.max(1,p.maxDepth-2); d<=Math.min(12,p.maxDepth+2); d++){
      for(var ml=Math.max(1,p.minLeaf-2); ml<=Math.min(20,p.minLeaf+2); ml++){
        var trial = { maxDepth:d, minSplit:p.minSplit, minLeaf:ml, maxFeatures:p.maxFeatures, alpha:p.alpha };
        var rr=runCV(trial);
        var tieBetter = (rr.mean===best.score) ? (d < (best.params?best.params.maxDepth:999)) : false;
        if(rr.mean>best.score || tieBetter){ best={ score:rr.mean, params:trial }; }
      }
    }
    if(best.params){
      $('recParams').textContent = 'depth=' + best.params.maxDepth + ', leaf=' + best.params.minLeaf + ', score=' + best.score.toFixed(3);
      // apply recommended to visualization
      tree = fitOnAll(best.params);
      drawAll();
    }
    // also refresh validation curve & heatmap
    computeValCurve();
    computeHeatmap();
  });

  // Final Test (Hold-out)
  var testIdx = [];
  function makeFinalTestSplit(pct){
    var n = points.length;
    var cut = Math.max(1, Math.floor(n*(1 - pct/100)));
    testIdx = [];
    for(var i=cut; i<n; i++){ testIdx.push(i); }
  }
  function evaluateOnFinalTest(){
    if(testIdx.length===0) { $('testScore').textContent='—'; return; }
    var p=getParams();
    // train on non-test indices
    var trainIdx=[];
    var testSet = testIdx.slice(0);
    for(var i=0;i<points.length;i++){
      if(testSet.indexOf(i)===-1) trainIdx.push(i);
    }
    var t = buildTree(trainIdx, 0, p.maxDepth, p.minSplit, p.minLeaf, p.maxFeatures, p.alpha);
    var m = $('metric').value;
    var score;
    if(m==='prauc') score = prAucOnIdx(t, testIdx);
    else if(m==='cost') score = costScoreOnIdx(t, testIdx, parseFloat($('costFP').value), parseFloat($('costFN').value));
    else if(m==='balanced') score = balancedAccOnIdx(t, testIdx);
    else if(m==='f1') score = f1OnIdx(t, testIdx);
    else score = accuracyOnIdx(t, testIdx);
    $('testScore').textContent = score.toFixed(3);
  }
  $('btnMakeTest').addEventListener('click', function(){ var pct=parseInt($('testPct').value); makeFinalTestSplit(pct); $('testScore').textContent='—'; });
  $('btnEvalTest').addEventListener('click', function(){ evaluateOnFinalTest(); });

  function genBalanced(){
    points=[];
    for(var i=0;i<90;i++) points.push({x:-1.2+randn()*0.5, y:-1.0+randn()*0.5, c:0});
    for(var j=0;j<90;j++) points.push({x: 1.2+randn()*0.5, y: 1.0+randn()*0.5, c:1});
    tree = fitOnAll(getParams()); drawAll();
  }
  function genOverlap(){
    points=[];
    for(var i=0;i<90;i++) points.push({x:-0.7+randn()*1.0, y:-0.7+randn()*1.0, c:0});
    for(var j=0;j<90;j++) points.push({x: 0.7+randn()*1.0, y: 0.7+randn()*1.0, c:1});
    tree = fitOnAll(getParams()); drawAll();
  }
  function genXOR(){
    points=[]; var s=0.45, n=60;
    for(var i=0;i<n;i++) points.push({x: 1.3+randn()*s, y: 1.3+randn()*s, c:0});
    for(var i2=0;i2<n;i2++) points.push({x:-1.3+randn()*s, y:-1.3+randn()*s, c:0});
    for(var j=0;j<n;j++) points.push({x: 1.3+randn()*s, y:-1.3+randn()*s, c:1});
    for(var j2=0;j2<n;j2++) points.push({x:-1.3+randn()*s, y: 1.3+randn()*s, c:1});
    tree = fitOnAll(getParams()); drawAll();
  }
  function genMoons(){
    points=[];
    for(var i=0;i<80;i++){ var t=i/80*Math.PI; points.push({x:Math.cos(t)+randn()*0.1, y:Math.sin(t)+randn()*0.1, c:0}); }
    for(var j=0;j<80;j++){ var t2=j/80*Math.PI; points.push({x:Math.cos(t2)+0.9+randn()*0.1, y:-Math.sin(t2)+0.2+randn()*0.1, c:1}); }
    tree = fitOnAll(getParams()); drawAll();
  }
  function genCircles(){
    points=[];
    for(var i=0;i<120;i++){ var r=0.6+randn()*0.06; var t=2*Math.PI*Math.random(); points.push({x:r*Math.cos(t), y:r*Math.sin(t), c:0}); }
    for(var j=0;j<120;j++){ var r2=1.2+randn()*0.08; var t2=2*Math.PI*Math.random(); points.push({x:r2*Math.cos(t2), y:r2*Math.sin(t2), c:1}); }
    tree = fitOnAll(getParams()); drawAll();
  }

  // Init
  resizeCanvas(); resizeHeat();
  genBalanced();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">What to learn on this page</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Validation curves</h6>
        <ul class="mb-2">
          <li><strong>max_depth:</strong> too small → underfit (both low); too large → overfit (train high, CV low)</li>
          <li><strong>min_samples_leaf:</strong> higher values reduce variance, often improving CV stability</li>
          <li><strong>ccp_alpha:</strong> pruning threshold; larger values prune more (less variance, more bias)</li>
        </ul>
        <h6>Grid search</h6>
        <ul class="mb-0">
          <li>Use the heatmap to find stable regions of good CV performance</li>
          <li>Prefer simple models in a plateau over spiky maxima</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Practical tips</h6>
        <ul class="mb-2">
          <li>Pick the smallest depth with near‑best CV score to reduce overfitting</li>
          <li>Increase <em>min_samples_leaf</em> if small leaves appear noisy</li>
          <li>Use <em>balanced accuracy</em> or <em>F1</em> when classes are imbalanced</li>
        </ul>
        <h6>How the visuals help</h6>
        <ul class="mb-0">
          <li>Decision regions show model complexity; splits indicate where the tree decided</li>
          <li>Validation curve reveals bias–variance behavior</li>
          <li>Heatmap shows robust hyperparameter zones</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- At a glance: what's going on -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">At a glance: what’s going on</h5>
  </div>
  <div class="card-body">
    <ul class="mb-2">
      <li><strong>Cross‑validation (CV):</strong> The data is split into K folds; the tree trains on K−1 folds and validates on the remaining one. CV Mean/Std summarize performance stability.</li>
      <li><strong>Validation curve:</strong> We sweep a hyperparameter (e.g., max_depth) and plot Train vs CV scores to reveal under/overfitting.</li>
      <li><strong>Pruning (ccp_alpha):</strong> Acts like a penalty on complexity; higher values prune more, often reducing variance at the cost of bias.</li>
      <li><strong>Grid search heatmap:</strong> Tests pairs (max_depth × min_samples_leaf); darker cells mean better CV score. Click a cell to apply those settings.</li>
      <li><strong>Decision regions:</strong> The canvas shows the fitted tree on all points; color indicates predicted class, dashed lines show split thresholds.</li>
      <li><strong>Recommend button:</strong> Runs CV around your current settings and suggests a robust, simpler model when scores are similar.</li>
    </ul>
    <div class="small text-muted">
      Goal: Pick the simplest tree that achieves near‑best CV performance and shows stable behavior across nearby settings.
    </div>
  </div>
</div>

<!-- Why validation strategy matters -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">Why validation strategy matters</h5>
  </div>
  <div class="card-body">
    <ul class="mb-2">
      <li><strong>Mirror production:</strong> If your model scores future data, validation should reflect that. Forward‑Chaining trains on earlier points and validates on later ones.</li>
      <li><strong>Avoid optimistic bias:</strong> Random K‑Fold can leak temporal information when data drifts; forward splits reduce this risk.</li>
      <li><strong>Match the objective:</strong> Pick metrics aligned with the use case (e.g., PR AUC or cost‑based for imbalance) and, if using cost, choose threshold per fold to minimize cost.</li>
      <li><strong>Keep a final test:</strong> Hold out a final set untouched during tuning; report that score separately after selecting the model.</li>
      <li><strong>Prefer stability and simplicity:</strong> Favor settings with high CV mean and low CV std; when tied, pick the smaller depth/min leaf.</li>
    </ul>
    <div class="small text-muted">Rule of thumb: Use Forward‑Chaining for time‑ordered data; use Random K‑Fold for i.i.d. data. Always validate with the metric that reflects your real deployment goals.</div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (Decision Trees) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>This tool builds decision trees with tunable hyperparameters (max_depth, min_samples, impurity criteria) and compares models via validation scores. Visualizations show splits and feature importance where supported.</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Understand overfitting/underfitting through depth and min split controls.</li>
      <li>Compare Gini vs entropy and their effects on splits.</li>
      <li>Use validation curves to choose hyperparameters.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>Runs fully in your browser using demo or user datasets.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Decision Tree Model Selection",
  "url": "https://8gwifi.org/decision_tree_model_selection.jsp",
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
    {"@type":"ListItem","position":2,"name":"Decision Tree Model Selection","item":"https://8gwifi.org/decision_tree_model_selection.jsp"}
  ]
}
</script>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
