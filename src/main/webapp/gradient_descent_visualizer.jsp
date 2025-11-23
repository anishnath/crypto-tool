<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Interactive Gradient Descent Visualizer - Explore optimization on different loss landscapes with SGD, Momentum, RMSProp, and Adam.">
<meta name="keywords" content="gradient descent, momentum, RMSProp, Adam, optimization, loss landscape, machine learning visualization">
<title>Gradient Descent Visualizer Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Gradient Descent Visualizer",
  "description": "Interactive tool to visualize gradient descent and popular optimizers on different loss landscapes",
  "url": "https://8gwifi.org/gradient_descent_visualizer.jsp",
  "keywords": "gradient descent, momentum, RMSProp, Adam, optimization, loss landscape, machine learning"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .gd-viz { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }

  /* Cards & containers */
  .chart-container-md { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; height: 350px; }
  .chart-container-sm { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; height: 260px; }
  .control-section { background: white; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
  .control-section h6 { color: #495057; font-weight: 600; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 2px solid #e9ecef; }
  .metric-card { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; border-radius: 8px; padding: 15px; text-align: center; margin-bottom: 10px; }
  .metric-label { font-size: 12px; opacity: 0.9; margin-bottom: 5px; }
  .metric-value { font-size: 24px; font-weight: bold; font-family: 'Courier New', monospace; }

  /* Canvas */
  #contourCanvas { width: 100%; height: 100%; background: #ffffff; border: 2px solid #e9ecef; border-radius: 6px; }

  /* Sliders */
  .slider-label { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 13px; font-weight: 500; }
  .form-range, .custom-slider { width: 100%; }

  /* Buttons */
  .btn-wide { width: 100%; }
  .btn-run { background: linear-gradient(135deg, #28a745, #20c997); color: white; border: none; }
  .btn-run:hover { filter: brightness(1.05); }
  .btn-pause { background: linear-gradient(135deg, #ffc107, #ff9800); color: #1f2d3d; border: none; }
  .btn-reset { background: #6c757d; color: white; border: none; }

  /* Quick access */
  .quick-access .btn { margin-right: 6px; margin-bottom: 6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🧭 Gradient Descent Visualizer</h1>
<p>See how different optimizers move across a loss landscape. Adjust learning rate, momentum, and other hyperparameters and observe their effect on convergence.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#loss" class="btn btn-outline-primary">Loss Curve</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="gd-viz">
  <div class="row">
    <!-- Left column: Visualization + Loss -->
    <div class="col-lg-8 mb-4">
      <!-- Contour Visualization -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Loss Landscape (Contour)</h5>
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" id="chkShowPath" checked>
            <label class="form-check-label small" for="chkShowPath">Show path</label>
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="contourCanvas"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Tip: Click on the plot to set a new starting point (w0, w1)</small>
        </div>
      </div>

      <!-- Loss curve -->
      <div class="card mb-4" id="loss">
        <div class="card-header">
          <h5 class="mb-0">Loss Over Steps</h5>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="lossChart"></canvas>
          </div>
          <div class="row mt-3">
            <div class="col-md-4"><div class="metric-card"><div class="metric-label">Step</div><div class="metric-value" id="kStep">0</div></div></div>
            <div class="col-md-4"><div class="metric-card" style="background:linear-gradient(135deg,#f093fb 0%,#f5576c 100%);"><div class="metric-label">Loss</div><div class="metric-value" id="kLoss">—</div></div></div>
            <div class="col-md-4"><div class="metric-card" style="background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%);"><div class="metric-label">||Grad||</div><div class="metric-value" id="kGrad">—</div></div></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right column: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Objective -->
      <div class="control-section">
        <h6>🎯 Objective Function</h6>
        <div class="mb-2">
          <select id="selFunc" class="form-select form-select-sm">
            <option value="quadratic" selected>Quadratic bowl</option>
            <option value="rosenbrock">Rosenbrock</option>
            <option value="saddle">Saddle point</option>
            <option value="plateau">Plateau (flat regions)</option>
          </select>
        </div>
        <div class="small text-muted">
          Domain: w0, w1 in [-3, 3]. You can click the contour to choose a new start.
        </div>
      </div>

      <!-- Optimizer -->
      <div class="control-section">
        <h6>⚙️ Optimizer</h6>
        <div class="mb-2">
          <select id="selOpt" class="form-select form-select-sm">
            <option value="sgd" selected>SGD</option>
            <option value="momentum">Momentum</option>
            <option value="rmsprop">RMSProp</option>
            <option value="adam">Adam</option>
          </select>
        </div>

        <div class="slider-label"><span>Learning rate</span><strong id="lrVal">0.05</strong></div>
        <input type="range" id="lr" min="0.001" max="0.5" step="0.001" value="0.05" class="form-range">

        <div id="rowMomentum" style="display:none;">
          <div class="slider-label"><span>Momentum β</span><strong id="momVal">0.9</strong></div>
          <input type="range" id="mom" min="0.1" max="0.99" step="0.01" value="0.9" class="form-range">
        </div>

        <div id="rowRMS" style="display:none;">
          <div class="slider-label"><span>RMSProp ρ</span><strong id="rhoVal">0.9</strong></div>
          <input type="range" id="rho" min="0.5" max="0.999" step="0.001" value="0.9" class="form-range">
        </div>

        <div id="rowAdam" style="display:none;">
          <div class="slider-label"><span>Adam β1</span><strong id="b1Val">0.9</strong></div>
          <input type="range" id="beta1" min="0.5" max="0.999" step="0.001" value="0.9" class="form-range">

          <div class="slider-label"><span>Adam β2</span><strong id="b2Val">0.999</strong></div>
          <input type="range" id="beta2" min="0.8" max="0.999" step="0.001" value="0.999" class="form-range">
        </div>

        <div class="slider-label"><span>Epsilon ε</span><strong id="epsVal">1e-8</strong></div>
        <input type="range" id="eps" min="1e-9" max="1e-3" step="1e-9" value="0.00000001" class="form-range">
      </div>

      <!-- Initialization -->
      <div class="control-section">
        <h6>🎛️ Initialization</h6>
        <div class="row g-2">
          <div class="col">
            <label class="form-label small">w0</label>
            <input type="number" id="w0" class="form-control form-control-sm" step="0.1" value="-2.0">
          </div>
          <div class="col">
            <label class="form-label small">w1</label>
            <input type="number" id="w1" class="form-control form-control-sm" step="0.1" value="2.0">
          </div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-secondary btn-sm btn-wide" id="btnRandom">Randomize</button></div>
          <div class="col"><button class="btn btn-reset btn-sm btn-wide" id="btnReset">Reset Path</button></div>
        </div>
      </div>

      <!-- Noise & Steps -->
      <div class="control-section">
        <h6>🌪️ Stochasticity & Steps</h6>
        <div class="slider-label"><span>Gradient noise</span><strong id="noiseVal">0.00</strong></div>
        <input type="range" id="noise" min="0" max="0.5" step="0.01" value="0.00" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm btn-wide" id="btnStep">Step</button></div>
          <div class="col"><button class="btn btn-primary btn-sm btn-wide" id="btnStep10">10 Steps</button></div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-run btn-sm btn-wide" id="btnAuto">Run ⏵</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm btn-wide" id="btnCenter">Center View</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function() {
  // Shortcuts
  function $(id){ return document.getElementById(id); }
  function randn(){ var u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }

  // DOM
  var canvas = $('contourCanvas');
  var ctx = canvas.getContext('2d');
  var rect; // canvas rect for coords
  function resizeCanvas() {
    var parent = canvas.parentElement;
    canvas.width = Math.max(300, parent.clientWidth - 4);
    canvas.height = Math.max(240, parent.clientHeight - 4);
    rect = canvas.getBoundingClientRect();
    drawAll();
  }
  window.addEventListener('resize', resizeCanvas);

  // State
  var domain = { min:-3, max:3 }; // same for x/y
  var w = { x: -2.0, y: 2.0 };
  var path = [];
  var showPath = true;
  var stepCount = 0;

  // Optimizer state
  var opt = 'sgd';
  var lr = 0.05, momB=0.9, rho=0.9, beta1=0.9, beta2=0.999, eps=1e-8, noise=0.0;
  var v_momentum = {x:0, y:0};
  var s_rms = {x:0, y:0};
  var m_adam = {x:0, y:0}, v_adam = {x:0, y:0}, t_adam=0;

  // Objective selection
  var func = 'quadratic';

  // Chart
  var lossChart = new Chart($('lossChart'), {
    type:'line',
    data:{ labels:[], datasets:[{ label:'Loss', data:[], borderColor:'#f5576c', backgroundColor:'rgba(245,87,108,0.1)', borderWidth:2, tension:0.25, fill:true }]},
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{ display:false } }, scales:{ x:{ title:{display:true,text:'Step'}}, y:{ title:{display:true, text:'Loss'}, beginAtZero:true } } }
  });

  // Utilities
  function toCanvas(x,y){
    var r = canvas.getBoundingClientRect();
    var W = canvas.width, H = canvas.height;
    var nx = (x - domain.min) / (domain.max - domain.min);
    var ny = (y - domain.min) / (domain.max - domain.min);
    return { cx: nx * W, cy: (1-ny) * H };
  }
  function toDomain(cx,cy){
    var W = canvas.width, H = canvas.height;
    var nx = cx / W;
    var ny = 1 - (cy / H);
    return { x: domain.min + nx * (domain.max - domain.min), y: domain.min + ny * (domain.max - domain.min) };
  }

  function f_quad(x,y){ var a=1.0,b=5.0; return a*x*x + b*y*y; }
  function g_quad(x,y){ var a=1.0,b=5.0; return { gx: 2*a*x, gy: 2*b*y }; }

  function f_ros(x,y){ var a=1.0,b=100.0; var t1=(a - x); var t2=(y - x*x); return t1*t1 + b*t2*t2; }
  function g_ros(x,y){
    var a=1.0,b=100.0;
    var dx = -2*(a - x) - 4*b*x*(y - x*x);
    var dy = 2*b*(y - x*x);
    return { gx: dx, gy: dy };
  }

  function f_sad(x,y){ return x*x - y*y; }
  function g_sad(x,y){ return { gx: 2*x, gy: -2*y }; }

  function f_plt(x,y){ var r2 = x*x + y*y; return Math.log(1 + r2); }
  function g_plt(x,y){ var r2 = x*x + y*y; var d = 1 + r2; return { gx: (2*x)/d, gy: (2*y)/d }; }

  function f(x,y){
    if(func==='quadratic') return f_quad(x,y);
    if(func==='rosenbrock') return f_ros(x,y);
    if(func==='saddle') return f_sad(x,y);
    return f_plt(x,y);
  }
  function grad(x,y){
    if(func==='quadratic') return g_quad(x,y);
    if(func==='rosenbrock') return g_ros(x,y);
    if(func==='saddle') return g_sad(x,y);
    return g_plt(x,y);
  }

  // Drawing
  function drawContour(){
    var W=canvas.width, H=canvas.height;
    var cell=4; // pixel size
    var minLoss=Infinity, maxLoss=-Infinity;
    // sample to find min/max
    for(var cy=0; cy<H; cy+=cell){
      for(var cx=0; cx<W; cx+=cell){
        var d = toDomain(cx, cy);
        var val = f(d.x, d.y);
        if(val<minLoss) minLoss=val;
        if(val>maxLoss) maxLoss=val;
      }
    }
    var span = maxLoss - minLoss + 1e-12;
    for(var ypx=0; ypx<H; ypx+=cell){
      for(var xpx=0; xpx<W; xpx+=cell){
        var dd = toDomain(xpx, ypx);
        var v = (f(dd.x, dd.y) - minLoss)/span; // 0..1
        // blue (low) -> yellow (high)
        var r = Math.floor(255 * Math.min(1, v*1.2));
        var g = Math.floor(255 * Math.min(1, v*0.9 + 0.2));
        var b = Math.floor(255 * (1 - v));
        ctx.fillStyle = 'rgb(' + r + ',' + g + ',' + b + ')';
        ctx.fillRect(xpx, ypx, cell, cell);
      }
    }
  }

  function drawPath(){
    if(!showPath || path.length===0) return;
    ctx.lineWidth = 2;
    ctx.strokeStyle = '#212529';
    ctx.beginPath();
    for(var i=0;i<path.length;i++){
      var p = toCanvas(path[i].x, path[i].y);
      if(i===0) ctx.moveTo(p.cx, p.cy);
      else ctx.lineTo(p.cx, p.cy);
    }
    ctx.stroke();
    // current point
    var pc = toCanvas(w.x, w.y);
    ctx.fillStyle = '#000';
    ctx.beginPath();
    ctx.arc(pc.cx, pc.cy, 4, 0, Math.PI*2);
    ctx.fill();
  }

  function drawAll(){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    drawContour();
    drawPath();
  }

  // Steps
  function stepOnce(){
    var g = grad(w.x, w.y);
    var gx = g.gx + noise*randn();
    var gy = g.gy + noise*randn();

    if(opt==='sgd'){
      w.x -= lr * gx;
      w.y -= lr * gy;
    } else if(opt==='momentum'){
      v_momentum.x = momB * v_momentum.x + (1 - momB) * gx;
      v_momentum.y = momB * v_momentum.y + (1 - momB) * gy;
      w.x -= lr * v_momentum.x;
      w.y -= lr * v_momentum.y;
    } else if(opt==='rmsprop'){
      s_rms.x = rho * s_rms.x + (1 - rho) * gx * gx;
      s_rms.y = rho * s_rms.y + (1 - rho) * gy * gy;
      w.x -= lr * gx / (Math.sqrt(s_rms.x) + eps);
      w.y -= lr * gy / (Math.sqrt(s_rms.y) + eps);
    } else {
      t_adam += 1;
      m_adam.x = beta1 * m_adam.x + (1 - beta1) * gx;
      m_adam.y = beta1 * m_adam.y + (1 - beta1) * gy;
      v_adam.x = beta2 * v_adam.x + (1 - beta2) * gx * gx;
      v_adam.y = beta2 * v_adam.y + (1 - beta2) * gy * gy;
      var mhatx = m_adam.x / (1 - Math.pow(beta1, t_adam));
      var mhaty = m_adam.y / (1 - Math.pow(beta1, t_adam));
      var vhatx = v_adam.x / (1 - Math.pow(beta2, t_adam));
      var vhaty = v_adam.y / (1 - Math.pow(beta2, t_adam));
      w.x -= lr * mhatx / (Math.sqrt(vhatx) + eps);
      w.y -= lr * mhaty / (Math.sqrt(vhaty) + eps);
    }

    // clip to domain
    w.x = Math.max(domain.min, Math.min(domain.max, w.x));
    w.y = Math.max(domain.min, Math.min(domain.max, w.y));

    path.push({x:w.x, y:w.y});
    stepCount += 1;

    var lossVal = f(w.x, w.y);
    var gradNorm = Math.sqrt(gx*gx + gy*gy);
    $('kStep').textContent = stepCount;
    $('kLoss').textContent = lossVal.toFixed(4);
    $('kGrad').textContent = gradNorm.toFixed(3);

    // update loss chart
    lossChart.data.labels.push(stepCount);
    lossChart.data.datasets[0].data.push(lossVal);
    if(lossChart.data.labels.length>200){
      lossChart.data.labels.shift();
      lossChart.data.datasets[0].data.shift();
    }
    lossChart.update('none');

    drawAll();
  }

  var autoTimer = null;

  // Events
  $('selFunc').addEventListener('change', function(){
    func = this.value;
    resetState(false);
  });
  $('selOpt').addEventListener('change', function(){
    opt = this.value;
    updateOptVisibility();
    resetOptStateOnly();
  });

  $('lr').addEventListener('input', function(){ lr = parseFloat(this.value); $('lrVal').textContent = lr.toFixed(3); });
  $('mom').addEventListener('input', function(){ momB = parseFloat(this.value); $('momVal').textContent = momB.toFixed(2); });
  $('rho').addEventListener('input', function(){ rho = parseFloat(this.value); $('rhoVal').textContent = rho.toFixed(3); });
  $('beta1').addEventListener('input', function(){ beta1 = parseFloat(this.value); $('b1Val').textContent = beta1.toFixed(3); });
  $('beta2').addEventListener('input', function(){ beta2 = parseFloat(this.value); $('b2Val').textContent = beta2.toFixed(3); });
  $('eps').addEventListener('input', function(){ eps = parseFloat(this.value); var s = eps.toExponential(0); $('epsVal').textContent = s; });
  $('noise').addEventListener('input', function(){ noise = parseFloat(this.value); $('noiseVal').textContent = noise.toFixed(2); });

  $('w0').addEventListener('change', function(){ w.x = parseFloat(this.value); resetPathOnly(); });
  $('w1').addEventListener('change', function(){ w.y = parseFloat(this.value); resetPathOnly(); });

  $('btnRandom').addEventListener('click', function(e){ e.preventDefault(); w.x = domain.min + Math.random()*(domain.max-domain.min); w.y = domain.min + Math.random()*(domain.max-domain.min); $('w0').value=w.x.toFixed(2); $('w1').value=w.y.toFixed(2); resetPathOnly(); });
  $('btnReset').addEventListener('click', function(e){ e.preventDefault(); resetState(true); });
  $('btnCenter').addEventListener('click', function(e){ e.preventDefault(); drawAll(); });

  $('btnStep').addEventListener('click', function(){ stepOnce(); });
  $('btnStep10').addEventListener('click', function(){ for(var i=0;i<10;i++) stepOnce(); });
  $('btnAuto').addEventListener('click', function(){
    if(autoTimer){ clearInterval(autoTimer); autoTimer=null; this.textContent='Run ⏵'; return; }
    this.textContent='Pause ⏸';
    autoTimer = setInterval(function(){ stepOnce(); }, 80);
  });

  $('chkShowPath').addEventListener('change', function(){
    showPath = this.checked;
    drawAll();
  });

  canvas.addEventListener('click', function(evt){
    var br = canvas.getBoundingClientRect();
    var cx = evt.clientX - br.left;
    var cy = evt.clientY - br.top;
    var d = toDomain(cx, cy);
    w.x = d.x; w.y = d.y;
    $('w0').value = w.x.toFixed(2);
    $('w1').value = w.y.toFixed(2);
    resetPathOnly();
  });

  function updateOptVisibility(){
    $('rowMomentum').style.display = (opt==='momentum') ? 'block' : 'none';
    $('rowRMS').style.display = (opt==='rmsprop') ? 'block' : 'none';
    $('rowAdam').style.display = (opt==='adam') ? 'block' : 'none';
  }

  function resetOptStateOnly(){
    v_momentum = {x:0,y:0};
    s_rms = {x:0,y:0};
    m_adam = {x:0,y:0};
    v_adam = {x:0,y:0};
    t_adam = 0;
  }

  function resetPathOnly(){
    path = [{x:w.x, y:w.y}];
    stepCount = 0;
    lossChart.data.labels = [];
    lossChart.data.datasets[0].data = [];
    lossChart.update('none');
    $('kStep').textContent='0';
    $('kLoss').textContent='—';
    $('kGrad').textContent='—';
    drawAll();
  }

  function resetState(withStart){
    resetOptStateOnly();
    if(withStart){
      w = { x: parseFloat($('w0').value), y: parseFloat($('w1').value) };
    }
    resetPathOnly();
  }

  // Init
  updateOptVisibility();
  resizeCanvas();
  resetState(true);
});
</script>

<hr id="guide">

<!-- What is Gradient Descent? Why it's used -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">What is Gradient Descent? Why it's used</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>What is it?</h6>
        <p class="mb-2">
          Gradient Descent is an iterative method to minimize a loss function by moving parameters in the direction of steepest descent (negative gradient). Each update nudges the parameters toward lower loss.
          <br>
          <span class="small text-muted">Update (conceptual): θ ← θ − η · ∇L(θ)</span>
        </p>
        <ul class="mb-0">
          <li><strong>Loss landscape:</strong> Map of loss values across parameters</li>
          <li><strong>Learning rate (η):</strong> Controls how big each step is</li>
          <li><strong>Path:</strong> The sequence of parameter positions over steps</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Why it's used</h6>
        <ul class="mb-2">
          <li><strong>Versatility:</strong> Trains many models (regression, neural networks, etc.)</li>
          <li><strong>Scalability:</strong> Stochastic variants handle large datasets efficiently</li>
          <li><strong>Practicality:</strong> Extensions (Momentum, RMSProp, Adam) improve stability and speed</li>
          <li><strong>Non-convex optimization:</strong> Navigates valleys, saddles, and plateaus in real problems</li>
        </ul>
        <p class="mb-0 small">
          In convex problems it reaches the global minimum; in non-convex ones it often finds good solutions. Choosing the right learning rate and optimizer is crucial.
        </p>
      </div>
    </div>
  </div>
</div>

<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">About this Visualizer</h5>
  </div>
  <div class="card-body">
    <p class="mb-2">
      This playground shows how optimization algorithms (SGD, Momentum, RMSProp, Adam) follow the gradient to minimize a loss function. The contour plot is a map of the loss: darker/bluer regions are lower values, brighter/yellow regions are higher values.
    </p>
    <div class="row">
      <div class="col-md-6">
        <h6>What you can control</h6>
        <ul class="mb-2">
          <li><strong>Objective:</strong> Choose different surfaces (convex, saddle, tricky valleys)</li>
          <li><strong>Optimizer:</strong> Pick SGD, Momentum, RMSProp, or Adam</li>
          <li><strong>Hyperparameters:</strong> Learning rate and method-specific parameters</li>
          <li><strong>Noise:</strong> Add randomness to emulate stochastic gradients</li>
          <li><strong>Start point:</strong> Click on the plot or type w0/w1</li>
        </ul>
        <h6>Reading the visuals</h6>
        <ul class="mb-0">
          <li><strong>Path:</strong> The polyline shows how parameters move step-by-step</li>
          <li><strong>Loss curve:</strong> Should trend down if optimization is working</li>
          <li><strong>Gradient norm:</strong> Indicates how steep the surface is locally</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Optimizer insights</h6>
        <ul class="mb-2">
          <li><strong>SGD:</strong> Simple and fast; can zig-zag in narrow valleys</li>
          <li><strong>Momentum:</strong> Smooths updates; helps escape shallow regions</li>
          <li><strong>RMSProp:</strong> Adapts step size per-parameter; good on noisy gradients</li>
          <li><strong>Adam:</strong> Momentum + RMSProp; often faster convergence</li>
        </ul>
        <h6>Troubleshooting</h6>
        <ul class="mb-0">
          <li><strong>Diverging:</strong> Lower learning rate</li>
          <li><strong>Slow progress:</strong> Increase learning rate slightly or try Adam</li>
          <li><strong>Saddle stuck:</strong> Add noise or use momentum/Adam</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>This visualizer simulates gradient descent (batch and stochastic variants) on configurable cost surfaces. It computes gradients analytically or numerically and updates parameters with a user‑selected learning rate and momentum. Plots are rendered in your browser.</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>See how learning rate and momentum affect convergence and oscillations.</li>
      <li>Understand local minima, saddle points, and plateau behavior.</li>
      <li>Contrast batch vs stochastic updates and their noise/variance.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>All simulations run locally; no data is uploaded.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Gradient Descent Visualizer",
  "url": "https://8gwifi.org/gradient_descent_visualizer.jsp",
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
    {"@type":"ListItem","position":2,"name":"Gradient Descent Visualizer","item":"https://8gwifi.org/gradient_descent_visualizer.jsp"}
  ]
}
</script>
</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
