<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Decision Trees & Random Forest Visualizer - Interactive splits, ensembles, and feature importance on 2D datasets.">
<meta name="keywords" content="decision tree, random forest, gini, entropy, feature importance, ensemble, machine learning visualization">
<title>Decision Trees & Random Forest Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Decision Trees & Random Forest Visualizer",
  "description": "Interactive visualization of decision trees and random forests with live splits, ensemble predictions, and feature importance.",
  "url": "https://8gwifi.org/decision_trees_random_forest.jsp",
  "keywords": "decision tree, random forest, feature importance, gini impurity, entropy, ensemble learning"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .dt-viz { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }

  /* Containers */
  .chart-container-md { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; height: 360px; }
  .chart-container-sm { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; height: 240px; }
  .control-section { background: white; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
  .control-section h6 { color: #495057; font-weight: 600; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 2px solid #e9ecef; }

  /* Canvas */
  #dtCanvas { width: 100%; height: 100%; background: #ffffff; border: 2px solid #e9ecef; border-radius: 6px; cursor: crosshair; }

  /* Buttons & sliders */
  .btn-wide { width: 100%; }
  .slider-label { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 13px; font-weight: 500; }

  /* Metrics */
  .metric-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.blue { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
  .metric-card.green { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
  .metric-card.orange { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
  .metric-label { font-size: 12px; opacity: 0.9; margin-bottom: 5px; }
  .metric-value { font-size: 22px; font-weight: bold; font-family: 'Courier New', monospace; }

  /* Quick access */
  .quick-access .btn { margin-right: 6px; margin-bottom: 6px; }

  /* Legend dots */
  .legend-dot { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
  .dot-red { background:#dc3545; border:1px solid #721c24; }
  .dot-green { background:#28a745; border:1px solid #155724; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🌳 Decision Trees & Random Forest</h1>
<p>Explore how trees split the space and how forests improve generalization. Add points, train a tree or an ensemble, and watch the decision regions and feature importance update live.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#dataset" class="btn btn-outline-primary">Dataset & Model</a>
    <a href="#importance" class="btn btn-outline-primary">Feature Importance</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="dt-viz">
  <div class="row">
    <!-- Left column: Visualization + Importance -->
    <div class="col-lg-8 mb-4">
      <!-- Dataset & Model -->
      <div class="card mb-4" id="dataset">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Dataset & Model</h5>
          <div class="small">
            <span class="legend-dot dot-green"></span>Class 1
            <span class="legend-dot dot-red ms-3"></span>Class 0
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="dtCanvas"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Tip: Click on the plot to add a point of the selected class. Toggle class in Dataset controls.</small>
          <div class="row mt-3">
            <div class="col-md-3"><div class="metric-card blue"><div class="metric-label">Train Acc</div><div class="metric-value" id="mTrain">—</div></div></div>
            <div class="col-md-3"><div class="metric-card green"><div class="metric-label">Test Acc</div><div class="metric-value" id="mTest">—</div></div></div>
            <div class="col-md-3"><div class="metric-card orange"><div class="metric-label">Depth</div><div class="metric-value" id="mDepth">—</div></div></div>
            <div class="col-md-3"><div class="metric-card" style="background:linear-gradient(135deg,#ffd86f 0%, #fc6262 100%);"><div class="metric-label">Leaves</div><div class="metric-value" id="mLeaves">—</div></div></div>
          </div>
        </div>
      </div>

      <!-- Feature Importance -->
      <div class="card mb-4" id="importance">
        <div class="card-header">
          <h5 class="mb-0">Feature Importance</h5>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="fiChart"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Importance is computed as total impurity reduction contributed by each feature (averaged across trees for forests).</small>
        </div>
      </div>
    </div>

    <!-- Right column: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset Controls -->
      <div class="control-section">
        <h6>📦 Dataset</h6>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnBalanced">Balanced</button>
          <button class="btn btn-outline-secondary" id="btnOverlap">Overlap</button>
        </div>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnImbalance">Imbalanced</button>
          <button class="btn btn-outline-secondary" id="btnXOR">XOR</button>
        </div>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
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
            <button class="btn btn-danger btn-sm btn-wide" id="btnClear">Clear points</button>
          </div>
        </div>
        <div class="mt-2">
          <div class="slider-label"><span>Train/Test Split</span><strong id="splitLbl">80/20</strong></div>
          <input type="range" id="split" min="50" max="90" step="5" value="80" class="form-range">
        </div>
      </div>

      <!-- Tree Controls -->
      <div class="control-section">
        <h6>🌲 Decision Tree</h6>
        <div class="mb-2">
          <label class="form-label small">Criterion</label>
          <select id="criterion" class="form-select form-select-sm">
            <option value="gini" selected>Gini</option>
            <option value="entropy">Entropy</option>
          </select>
        </div>
        <div class="slider-label"><span>Max Depth</span><strong id="depthVal">5</strong></div>
        <input type="range" id="maxDepth" min="1" max="12" step="1" value="5" class="form-range">

        <div class="slider-label"><span>Min Samples Split</span><strong id="minSplitVal">4</strong></div>
        <input type="range" id="minSplit" min="2" max="20" step="1" value="4" class="form-range">

        <div class="slider-label"><span>Min Leaf</span><strong id="minLeafVal">2</strong></div>
        <input type="range" id="minLeaf" min="1" max="20" step="1" value="2" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm btn-wide" id="btnTrainTree">Train Tree</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm btn-wide" id="btnShowSplits">Toggle Splits</button></div>
        </div>
      </div>

      <!-- Forest Controls -->
      <div class="control-section">
        <h6>🌳 Random Forest</h6>
        <div class="slider-label"><span># Trees</span><strong id="treesVal">15</strong></div>
        <input type="range" id="nTrees" min="1" max="50" step="1" value="15" class="form-range">

        <div class="slider-label"><span>Max Features (per split)</span><strong id="mfeatVal">1</strong></div>
        <input type="range" id="maxFeatures" min="1" max="2" step="1" value="1" class="form-range">

        <div class="form-check mt-2">
          <input class="form-check-input" type="checkbox" id="bootstrap" checked>
          <label class="form-check-label small" for="bootstrap">Bootstrap samples</label>
        </div>

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-success btn-sm btn-wide" id="btnTrainForest">Train Forest</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm btn-wide" id="btnClearForest">Clear Forest</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function() {
  // Helpers
  function $(id){ return document.getElementById(id); }
  function randn(){ var u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }
  function shuffle(a){ for(var i=a.length-1;i>0;i--){ var j=Math.floor(Math.random()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } return a; }

  // Canvas setup
  var canvas = $('dtCanvas'), ctx = canvas.getContext('2d');
  function resizeCanvas(){
    var parent = canvas.parentElement;
    canvas.width = Math.max(300, parent.clientWidth - 4);
    canvas.height = Math.max(260, parent.clientHeight - 4);
    drawAll();
  }
  window.addEventListener('resize', resizeCanvas);

  // Data
  var points = []; // {x,y,c}
  var showSplits = true;

  // Train/Test split ratio
  var splitRatio = 0.8;

  // Models
  var tree = null;
  var forest = [];

  // Feature importance
  var importance = [0,0]; // for x,y

  // Charts
  var fiChart = new Chart($('fiChart'), {
    type: 'bar',
    data: { labels: ['x','y'], datasets: [{ label:'Importance', data:[0,0], backgroundColor:['rgba(13,110,253,0.7)','rgba(25,135,84,0.7)'] }] },
    options: { responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true, max:1 }}, plugins:{ legend:{ display:false } } }
  });

  // Dataset generators
  function genBalanced(){
    points=[];
    for(var i=0;i<90;i++) points.push({x: -1.3 + randn()*0.5, y: -1.0 + randn()*0.5, c:0});
    for(var j=0;j<90;j++) points.push({x:  1.3 + randn()*0.5, y:  1.0 + randn()*0.5, c:1});
    drawAll(); resetModels();
  }
  function genOverlap(){
    points=[];
    for(var i=0;i<90;i++) points.push({x: -0.7 + randn()*1.0, y: -0.7 + randn()*1.0, c:0});
    for(var j=0;j<90;j++) points.push({x:  0.7 + randn()*1.0, y:  0.7 + randn()*1.0, c:1});
    drawAll(); resetModels();
  }
  function genImbalance(){
    points=[];
    for(var i=0;i<150;i++) points.push({x: -1.0 + randn()*0.7, y: -0.9 + randn()*0.7, c:0});
    for(var j=0;j<30;j++)  points.push({x:  1.1 + randn()*0.5, y:  1.0 + randn()*0.5, c:1});
    drawAll(); resetModels();
  }
  function genXOR(){
    points=[]; var s=0.45, n=60;
    for(var i=0;i<n;i++) points.push({x:  1.3 + randn()*s, y:  1.3 + randn()*s, c:0});
    for(var i2=0;i2<n;i2++) points.push({x: -1.3 + randn()*s, y: -1.3 + randn()*s, c:0});
    for(var j=0;j<n;j++) points.push({x:  1.3 + randn()*s, y: -1.3 + randn()*s, c:1});
    for(var j2=0;j2<n;j2++) points.push({x: -1.3 + randn()*s, y:  1.3 + randn()*s, c:1});
    drawAll(); resetModels();
  }
  function genMoons(){
    points=[];
    for(var i=0;i<80;i++){ var t=i/80*Math.PI; points.push({x: Math.cos(t)+randn()*0.1, y: Math.sin(t)+randn()*0.1, c:0}); }
    for(var j=0;j<80;j++){ var t2=j/80*Math.PI; points.push({x: Math.cos(t2)+0.5+randn()*0.1, y: -Math.sin(t2)+0.2+randn()*0.1, c:1}); }
    drawAll(); resetModels();
  }
  function genCircles(){
    points=[];
    for(var i=0;i<120;i++){ var r=0.5+Math.random()*0.15; var t=2*Math.PI*Math.random(); points.push({x:r*Math.cos(t), y:r*Math.sin(t), c:0}); }
    for(var j=0;j<120;j++){ var r2=1.0+Math.random()*0.2; var t2=2*Math.PI*Math.random(); points.push({x:r2*Math.cos(t2), y:r2*Math.sin(t2), c:1}); }
    drawAll(); resetModels();
  }

  // Coordinate transforms (model domain -2..2 mapped to canvas)
  function toCanvas(x,y){
    var W=canvas.width, H=canvas.height;
    var nx = (x + 2) / 4; var ny = (y + 2) / 4;
    return { cx: nx*W, cy: (1-ny)*H };
  }
  function toDomain(cx,cy){
    var W=canvas.width, H=canvas.height;
    var nx = cx/W; var ny = 1-cy/H;
    return { x: nx*4-2, y: ny*4-2 };
  }

  // Drawing
  function drawBackgroundPrediction(){
    if(points.length===0) return;
    var step=5;
    for(var y=0;y<canvas.height;y+=step){
      for(var x=0;x<canvas.width;x+=step){
        var d=toDomain(x,y);
        var p = predictProb(d.x,d.y); // 0..1 prob of class 1
        var alpha = Math.abs(p-0.5)*0.35;
        ctx.fillStyle = p>0.5 ? ('rgba(40,167,69,'+alpha+')') : ('rgba(220,53,69,'+alpha+')');
        ctx.fillRect(x,y,step,step);
      }
    }
  }
  function drawSplits(node, rect){
    if(!showSplits || !node || node.leaf) return;
    // rect: {xmin,xmax,ymin,ymax} in domain coords
    if(node.axis===0){
      var sx = node.thr;
      var a = toCanvas(sx, rect.ymin), b = toCanvas(sx, rect.ymax);
      ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.beginPath(); ctx.moveTo(a.cx,a.cy); ctx.lineTo(b.cx,b.cy); ctx.stroke(); ctx.setLineDash([]);
      var leftRect = { xmin:rect.xmin, xmax:sx, ymin:rect.ymin, ymax:rect.ymax };
      var rightRect= { xmin:sx, xmax:rect.xmax, ymin:rect.ymin, ymax:rect.ymax };
      drawSplits(node.left, leftRect); drawSplits(node.right, rightRect);
    } else {
      var sy = node.thr;
      var c = toCanvas(rect.xmin, sy), d = toCanvas(rect.xmax, sy);
      ctx.strokeStyle='#0d6efd'; ctx.setLineDash([6,6]); ctx.beginPath(); ctx.moveTo(c.cx,c.cy); ctx.lineTo(d.cx,d.cy); ctx.stroke(); ctx.setLineDash([]);
      var lowRect =  { xmin:rect.xmin, xmax:rect.xmax, ymin:rect.ymin, ymax:sy };
      var highRect = { xmin:rect.xmin, xmax:rect.xmax, ymin:sy,      ymax:rect.ymax };
      drawSplits(node.left, lowRect); drawSplits(node.right, highRect);
    }
  }
  function drawPoints(){
    for(var i=0;i<points.length;i++){
      var p=points[i], c=toCanvas(p.x,p.y);
      ctx.beginPath(); ctx.arc(c.cx,c.cy,5,0,Math.PI*2);
      ctx.fillStyle = p.c===1 ? '#28a745' : '#dc3545';
      ctx.fill(); ctx.lineWidth=2; ctx.strokeStyle= p.c===1 ? '#155724' : '#721c24'; ctx.stroke();
    }
  }
  function drawAll(){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    drawBackgroundPrediction();
    if(showSplits && tree){ drawSplits(tree, {xmin:-2,xmax:2,ymin:-2,ymax:2}); }
    drawPoints();
  }

  // Tree structures
  function impurityGini(labels){
    var n=labels.length; if(n===0) return 0;
    var c1=0; for(var i=0;i<n;i++) if(labels[i]===1) c1++;
    var p1=c1/n, p0=1-p1;
    return 1 - (p0*p0 + p1*p1);
  }
  function impurityEntropy(labels){
    var n=labels.length; if(n===0) return 0;
    var c1=0; for(var i=0;i<n;i++) if(labels[i]===1) c1++;
    var p1=c1/n, p0=1-p1;
    function H(p){ return p<=0?0: -p*Math.log2(p); }
    return H(p0)+H(p1);
  }
  function criterionImp(labels){
    return ($('criterion').value==='gini') ? impurityGini(labels) : impurityEntropy(labels);
  }

  function bestSplit(samples, minLeaf, maxFeatures){
    // samples: indexes into points
    // returns {axis, thr, gain, leftIdx, rightIdx} or null
    if(samples.length < 2*minLeaf) return null;
    var features=[0,1]; // 0:x,1:y
    if(maxFeatures===1){
      // pick random feature
      features = [ Math.random()<0.5 ? 0 : 1 ];
    }
    // baseline impurity
    var y = samples.map(function(i){ return points[i].c; });
    var base = criterionImp(y);
    var best = {gain:0};
    for(var fi=0;fi<features.length;fi++){
      var ax = features[fi];
      // get sorted unique thresholds
      var sorted = samples.slice().sort(function(a,b){ return (ax===0?points[a].x:points[a].y) - (ax===0?points[b].x:points[b].y); });
      for(var k=minLeaf; k<sorted.length-minLeaf; k++){
        var v1 = (ax===0?points[sorted[k-1]].x:points[sorted[k-1]].y);
        var v2 = (ax===0?points[sorted[k]].x:points[sorted[k]].y);
        var thr = (v1+v2)/2;
        var left = [], right=[];
        for(var s=0;s<sorted.length;s++){
          var v = (ax===0?points[sorted[s]].x:points[sorted[s]].y);
          if(v<=thr) left.push(sorted[s]); else right.push(sorted[s]);
        }
        if(left.length<minLeaf || right.length<minLeaf) continue;
        var yL = left.map(function(i){return points[i].c;});
        var yR = right.map(function(i){return points[i].c;});
        var imp = (left.length/samples.length)*criterionImp(yL) + (right.length/samples.length)*criterionImp(yR);
        var gain = base - imp;
        if(gain > best.gain){
          best = {axis:ax, thr:thr, gain:gain, leftIdx:left, rightIdx:right};
        }
      }
    }
    if(best.gain<=0) return null;
    return best;
  }

  function buildTree(samples, depth, maxDepth, minSplit, minLeaf, importAcc){
    var y = samples.map(function(i){ return points[i].c; });
    var n = samples.length;
    var node = { leaf:false, axis:null, thr:null, left:null, right:null, pred:null, n:n };
    var c1=0; for(var i=0;i<n;i++) if(points[samples[i]].c===1) c1++;
    var maj = (c1*2>=n) ? 1 : 0;
    // stopping conditions
    if(depth>=maxDepth || n<minSplit || c1===0 || c1===n){
      node.leaf=true; node.pred=maj; node.depth=depth; node.leaves=1; return node;
    }
    var split = bestSplit(samples, minLeaf, 2);
    if(!split){
      node.leaf=true; node.pred=maj; node.depth=depth; node.leaves=1; return node;
    }
    // accumulate importance: impurity reduction * samples
    if(importAcc){
      importance[split.axis] += split.gain * n;
    }
    node.axis=split.axis; node.thr=split.thr;
    node.left = buildTree(split.leftIdx, depth+1, maxDepth, minSplit, minLeaf, importAcc);
    node.right= buildTree(split.rightIdx, depth+1, maxDepth, minSplit, minLeaf, importAcc);
    node.depth = Math.max(node.left.depth, node.right.depth);
    node.leaves = node.left.leaves + node.right.leaves;
    return node;
  }

  function predictTree(node, x, y){
    while(!node.leaf){
      var v = node.axis===0 ? x : y;
      if(v<=node.thr) node=node.left; else node=node.right;
    }
    return node.pred;
  }

  function predictProb(x,y){
    if(forest.length>0){
      var vote=0;
      for(var i=0;i<forest.length;i++){
        vote += predictTree(forest[i].tree, x, y);
      }
      return vote / forest.length;
    } else if(tree){
      return predictTree(tree, x, y);
    } else {
      return 0.5;
    }
  }

  function accuracyOnIdx(modelTree, idx){
    var correct=0;
    for(var i=0;i<idx.length;i++){
      var p = points[idx[i]];
      if(predictTree(modelTree, p.x, p.y)===p.c) correct++;
    }
    return correct/idx.length;
  }

  // Forest training
  function trainForest(nTrees, maxDepth, minSplit, minLeaf, maxFeatures, bootstrap){
    forest=[]; importance=[0,0];
    var n = points.length; if(n===0) return;
    for(var t=0;t<nTrees;t++){
      var sampleIdx=[];
      if(bootstrap){
        for(var i=0;i<n;i++){ sampleIdx.push( Math.floor(Math.random()*n) ); }
      } else {
        sampleIdx = shuffle(Array.apply(null,{length:n}).map(function(_,i){return i;})).slice(0,n);
      }
      buildTree(sampleIdx, 0, maxDepth, minSplit, minLeaf, true); // accumulate importance
      // re-build with chosen maxFeatures at split time
      // We incorporate maxFeatures by temporarily overriding bestSplit:
      // For simplicity here, we reuse bestSplit with maxFeatures argument.
      var savedImportance = importance.slice(0);
      var tnode = buildTreeWithMaxFeatures(sampleIdx, 0, maxDepth, minSplit, minLeaf, maxFeatures);
      importance = savedImportance; // keep importance from first call
      forest.push({ tree: tnode });
    }
    // normalize importance
    var sumImp = importance[0]+importance[1];
    if(sumImp>0){ importance=[importance[0]/sumImp, importance[1]/sumImp]; } else { importance=[0,0]; }
    updateFIChart();
  }

  function buildTreeWithMaxFeatures(samples, depth, maxDepth, minSplit, minLeaf, maxFeatures){
    var y = samples.map(function(i){ return points[i].c; });
    var n = samples.length;
    var node = { leaf:false, axis:null, thr:null, left:null, right:null, pred:null, n:n };
    var c1=0; for(var i=0;i<n;i++) if(points[samples[i]].c===1) c1++;
    var maj = (c1*2>=n) ? 1 : 0;
    if(depth>=maxDepth || n<minSplit || c1===0 || c1===n){
      node.leaf=true; node.pred=maj; node.depth=depth; node.leaves=1; return node;
    }
    var split = bestSplitWithMaxFeatures(samples, minLeaf, maxFeatures);
    if(!split){
      node.leaf=true; node.pred=maj; node.depth=depth; node.leaves=1; return node;
    }
    node.axis=split.axis; node.thr=split.thr;
    node.left = buildTreeWithMaxFeatures(split.leftIdx, depth+1, maxDepth, minSplit, minLeaf, maxFeatures);
    node.right= buildTreeWithMaxFeatures(split.rightIdx, depth+1, maxDepth, minSplit, minLeaf, maxFeatures);
    node.depth = Math.max(node.left.depth, node.right.depth);
    node.leaves = node.left.leaves + node.right.leaves;
    return node;
  }
  function bestSplitWithMaxFeatures(samples, minLeaf, maxFeatures){
    if(samples.length < 2*minLeaf) return null;
    var chosen = (maxFeatures===1) ? [ (Math.random()<0.5?0:1) ] : [0,1];
    var y = samples.map(function(i){ return points[i].c; });
    var base = criterionImp(y);
    var best = {gain:0};
    for(var fi=0;fi<chosen.length;fi++){
      var ax = chosen[fi];
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
        var yL = left.map(function(i){return points[i].c;});
        var yR = right.map(function(i){return points[i].c;});
        var imp = (left.length/samples.length)*criterionImp(yL) + (right.length/samples.length)*criterionImp(yR);
        var gain = base - imp;
        if(gain>best.gain){
          best = {axis:ax, thr:thr, gain:gain, leftIdx:left, rightIdx:right};
        }
      }
    }
    if(best.gain<=0) return null;
    return best;
  }

  // Training entry points
  function trainTreeNow(){
    importance=[0,0];
    if(points.length===0) return;
    var idx = points.map(function(_,i){return i;});
    var maxDepth = parseInt($('maxDepth').value);
    var minSplit = parseInt($('minSplit').value);
    var minLeaf  = parseInt($('minLeaf').value);
    // accumulate importance while building
    tree = buildTree(idx, 0, maxDepth, minSplit, minLeaf, true);
    // normalize importance
    var sumImp=importance[0]+importance[1];
    if(sumImp>0){ importance=[importance[0]/sumImp, importance[1]/sumImp]; }
    else { importance=[0,0]; }
    forest=[]; // clear forest
    updateAllMetrics();
    updateFIChart();
    drawAll();
  }

  function updateFIChart(){
    fiChart.data.datasets[0].data = [importance[0], importance[1]];
    fiChart.update('none');
  }

  function resetModels(){
    tree=null; forest=[]; importance=[0,0];
    $('mTrain').textContent='—'; $('mTest').textContent='—'; $('mDepth').textContent='—'; $('mLeaves').textContent='—';
    updateFIChart(); drawAll();
  }

  // Accuracy and metrics
  function splitTrainTest(){
    var n=points.length; var idx = points.map(function(_,i){return i;});
    idx = shuffle(idx);
    var cut = Math.floor(n*splitRatio);
    return { train: idx.slice(0,cut), test: idx.slice(cut) };
  }

  function predictModel(x,y){
    if(forest.length>0){
      var v=0;
      for(var i=0;i<forest.length;i++) v+= predictTree(forest[i].tree, x,y);
      return (v*2 >= forest.length) ? 1 : 0;
    } else if(tree){
      return predictTree(tree, x, y);
    }
    return 0;
  }

  function accuracyOn(modelTree, idx){
    var correct=0;
    for(var i=0;i<idx.length;i++){
      var p=points[idx[i]];
      if(predictTree(modelTree, p.x, p.y)===p.c) correct++;
    }
    return idx.length>0 ? correct/idx.length : 0;
  }

  function computeMetrics(){
    var sp = splitTrainTest();
    var mt='—', mte='—', depth='—', leaves='—';
    if(tree){
      mt = accuracyOn(tree, sp.train);
      mte= accuracyOn(tree, sp.test);
      depth = tree.depth;
      leaves= tree.leaves;
    } else if(forest.length>0){
      // approximate accuracy by majority vote among trees
      var correctTrain=0, correctTest=0;
      for(var i=0;i<sp.train.length;i++){
        var p=points[sp.train[i]];
        if(predictModel(p.x,p.y)===p.c) correctTrain++;
      }
      for(var j=0;j<sp.test.length;j++){
        var q=points[sp.test[j]];
        if(predictModel(q.x,q.y)===q.c) correctTest++;
      }
      mt  = sp.train.length>0 ? correctTrain/sp.train.length : 0;
      mte = sp.test.length>0  ? correctTest/sp.test.length  : 0;
      // forest depth/leaves are not single values; show average
      var sumD=0,sumL=0;
      for(var t=0;t<forest.length;t++){ sumD+=forest[t].tree.depth; sumL+=forest[t].tree.leaves; }
      depth = Math.round(sumD/forest.length);
      leaves= Math.round(sumL/forest.length);
    }
    $('mTrain').textContent = (typeof mt==='number') ? (mt*100).toFixed(1)+'%' : mt;
    $('mTest').textContent  = (typeof mte==='number') ? (mte*100).toFixed(1)+'%' : mte;
    $('mDepth').textContent = depth;
    $('mLeaves').textContent= leaves;
  }

  function updateAllMetrics(){ computeMetrics(); }

  // Events
  $('btnBalanced').addEventListener('click', genBalanced);
  $('btnOverlap').addEventListener('click', genOverlap);
  $('btnImbalance').addEventListener('click', genImbalance);
  $('btnXOR').addEventListener('click', genXOR);
  $('btnMoons').addEventListener('click', genMoons);
  $('btnCircles').addEventListener('click', genCircles);
  $('btnClear').addEventListener('click', function(){ points=[]; resetModels(); });

  $('split').addEventListener('input', function(){ splitRatio = parseInt(this.value)/100; $('splitLbl').textContent = this.value + '/' + (100-this.value); updateAllMetrics(); });

  $('maxDepth').addEventListener('input', function(){ $('depthVal').textContent=this.value; });
  $('minSplit').addEventListener('input', function(){ $('minSplitVal').textContent=this.value; });
  $('minLeaf').addEventListener('input', function(){ $('minLeafVal').textContent=this.value; });
  $('nTrees').addEventListener('input', function(){ $('treesVal').textContent=this.value; });
  $('maxFeatures').addEventListener('input', function(){ $('mfeatVal').textContent=this.value; });

  $('btnTrainTree').addEventListener('click', function(){ trainTreeNow(); });
  $('btnShowSplits').addEventListener('click', function(){ showSplits=!showSplits; drawAll(); });
  $('btnClearForest').addEventListener('click', function(){ forest=[]; drawAll(); updateAllMetrics(); });

  $('btnTrainForest').addEventListener('click', function(){
    if(points.length===0) return;
    var nTrees = parseInt($('nTrees').value);
    var maxDepth = parseInt($('maxDepth').value);
    var minSplit = parseInt($('minSplit').value);
    var minLeaf  = parseInt($('minLeaf').value);
    var maxFeatures = parseInt($('maxFeatures').value);
    var bootstrap = $('bootstrap').checked;
    trainForest(nTrees, maxDepth, minSplit, minLeaf, maxFeatures, bootstrap);
    tree=null;
    updateAllMetrics(); drawAll();
  });

  // Click to add point
  canvas.addEventListener('click', function(evt){
    var br = canvas.getBoundingClientRect();
    var x = evt.clientX - br.left, y = evt.clientY - br.top;
    var d = toDomain(x,y);
    var cls = parseInt($('classSel').value);
    points.push({x:d.x, y:d.y, c:cls});
    drawAll(); updateAllMetrics();
  });

  // Init
  resizeCanvas();
  genBalanced();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">About this Visualizer</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>What is a Decision Tree?</h6>
        <ul class="mb-2">
          <li><strong>Axis-aligned splits:</strong> Recursively partition the space with x or y thresholds</li>
          <li><strong>Leaves:</strong> Each leaf predicts the majority class of points in that region</li>
          <li><strong>Impurity:</strong> Gini or Entropy guide how to split (lower is better)</li>
          <li><strong>Complexity:</strong> Max depth, min samples, and min leaf prevent overfitting</li>
        </ul>
        <h6>Why Random Forest?</h6>
        <ul class="mb-0">
          <li><strong>Ensemble:</strong> Averages many trees to reduce variance</li>
          <li><strong>Bagging:</strong> Trains each tree on bootstrap samples</li>
          <li><strong>Random features:</strong> Uses a random subset of features for each split</li>
          <li><strong>Robustness:</strong> Typically generalizes better than a single tree</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Interpreting Results</h6>
        <ul class="mb-2">
          <li><strong>Decision regions:</strong> Red vs Green areas indicate predicted classes</li>
          <li><strong>Splits:</strong> Dashed blue lines show tree thresholds</li>
          <li><strong>Accuracy:</strong> Computed from a random train/test split</li>
          <li><strong>Feature importance:</strong> Total impurity reduction per feature</li>
        </ul>
        <h6>Troubleshooting</h6>
        <ul class="mb-0">
          <li><strong>Underfitting:</strong> Increase max depth or decrease min samples</li>
          <li><strong>Overfitting:</strong> Decrease max depth or increase min samples</li>
          <li><strong>Noisy boundaries:</strong> Use more trees, enable bootstrap, limit features</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (Trees & Random Forest) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>Compares a single decision tree with an ensemble random forest. Demonstrates bagging, feature subsampling, out‑of‑bag intuition, and aggregated feature importance (where supported).</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>See variance reduction from ensembling vs a single deep tree.</li>
      <li>Interpret feature importance cautiously (correlated features caveat).</li>
      <li>Relate hyperparameters (n_estimators, max_features) to bias–variance trade‑off.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>All computations run locally; datasets are not uploaded.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Decision Trees & Random Forest",
  "url": "https://8gwifi.org/decision_trees_random_forest.jsp",
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
    {"@type":"ListItem","position":2,"name":"Decision Trees & Random Forest","item":"https://8gwifi.org/decision_trees_random_forest.jsp"}
  ]
}
</script>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
