<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Activation Function Explorer - Visualize Sigmoid, Tanh, ReLU, Leaky ReLU, ELU, and GELU with derivative overlays and parameter controls.">
<meta name="keywords" content="activation functions explained visually, sigmoid vs tanh vs relu graph, leaky relu elu gelu, deep learning activation visualization">
<title>Activation Function Explorer Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Activation Function Explorer",
  "description": "Interactive visualization of activation functions (Sigmoid, Tanh, ReLU, Leaky ReLU, ELU, GELU) with derivative overlays and parameter controls.",
  "url": "https://8gwifi.org/activation_function_explorer.jsp",
  "keywords": "activation functions, sigmoid vs tanh vs relu graph, activation visualization, leaky relu, elu, gelu, deep learning"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .afe { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-lg { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:420px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .small-note { font-size:12px; color:#6c757d; }
  .legend-chip { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Activation Function Explorer</h1>
<p>Compare activation functions used in deep learning. Plot Sigmoid, Tanh, ReLU, Leaky ReLU, ELU, and GELU on the same chart; toggle derivatives and tune parameters interactively.</p>

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

<div class="afe">
  <div class="row">
    <!-- Left: Plot -->
    <div class="col-lg-8 mb-4">
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Activation Curves</h5>
          <div class="small">
            <span class="legend-chip" style="background:#0d6efd;"></span>Sigmoid
            <span class="legend-chip" style="background:#198754;"></span>Tanh
            <span class="legend-chip" style="background:#dc3545;"></span>ReLU
            <span class="legend-chip" style="background:#fd7e14;"></span>Leaky ReLU
            <span class="legend-chip" style="background:#6f42c1;"></span>ELU
            <span class="legend-chip" style="background:#20c997;"></span>GELU
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-lg">
            <canvas id="actChart"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Solid lines: activation f(x). If enabled, dashed lines: derivative f′(x). Adjust domain and parameters on the right.</small>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Functions -->
      <div class="control-section">
        <h6>Functions</h6>
        <div class="form-check"><input class="form-check-input" type="checkbox" id="chkSigmoid" checked><label class="form-check-label" for="chkSigmoid">Sigmoid</label></div>
        <div class="form-check"><input class="form-check-input" type="checkbox" id="chkTanh" checked><label class="form-check-label" for="chkTanh">Tanh</label></div>
        <div class="form-check"><input class="form-check-input" type="checkbox" id="chkReLU" checked><label class="form-check-label" for="chkReLU">ReLU</label></div>
        <div class="form-check"><input class="form-check-input" type="checkbox" id="chkLeaky" checked><label class="form-check-label" for="chkLeaky">Leaky ReLU</label></div>
        <div class="form-check"><input class="form-check-input" type="checkbox" id="chkELU"><label class="form-check-label" for="chkELU">ELU</label></div>
        <div class="form-check"><input class="form-check-input" type="checkbox" id="chkGELU"><label class="form-check-label" for="chkGELU">GELU</label></div>
        <div class="form-check mt-2"><input class="form-check-input" type="checkbox" id="chkDeriv"><label class="form-check-label" for="chkDeriv">Show derivatives</label></div>
      </div>

      <!-- Parameters -->
      <div class="control-section">
        <h6>Parameters</h6>
        <div class="slider-label"><span>Leaky α</span><strong id="leakLbl">0.01</strong></div>
        <input type="range" id="leak" min="0.001" max="0.3" step="0.001" value="0.01" class="form-range">

        <div class="slider-label"><span>ELU α</span><strong id="eluLbl">1.00</strong></div>
        <input type="range" id="elu" min="0.1" max="5" step="0.1" value="1.0" class="form-range">

        <div class="mb-2">
          <label class="form-label small">GELU approximation</label>
          <select id="geluMode" class="form-select form-select-sm">
            <option value="exact" selected>Exact (erf)</option>
            <option value="tanh">Tanh approximation</option>
          </select>
        </div>
      </div>

      <!-- Domain -->
      <div class="control-section">
        <h6>Domain</h6>
        <div class="slider-label"><span>x min</span><strong id="xminLbl">-6.0</strong></div>
        <input type="range" id="xmin" min="-12" max="0" step="0.1" value="-6.0" class="form-range">

        <div class="slider-label"><span>x max</span><strong id="xmaxLbl">6.0</strong></div>
        <input type="range" id="xmax" min="0" max="12" step="0.1" value="6.0" class="form-range">

        <div class="slider-label"><span>Samples</span><strong id="samplesLbl">400</strong></div>
        <input type="range" id="samples" min="100" max="1000" step="50" value="400" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnUpdate">Update Plot</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnReset">Reset</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function(){
  function $(id){ return document.getElementById(id); }

  // Activations
  function sigmoid(x){ return 1/(1+Math.exp(-Math.max(-60, Math.min(60, x)))); }
  function dSigmoid(x){ var s=sigmoid(x); return s*(1-s); }

  function tanhAct(x){ return Math.tanh(x); }
  function dTanh(x){ var t=Math.tanh(x); return 1 - t*t; }

  function relu(x){ return x>0?x:0; }
  function dReLU(x){ return x>0?1:0; }

  function leaky(x,a){ return x>0?x:a*x; }
  function dLeaky(x,a){ return x>0?1:a; }

  function elu(x,a){ return x>=0?x: a*(Math.exp(x)-1); }
  function dELU(x,a){ return x>=0?1: a*Math.exp(x); }

  function geluExact(x){ return 0.5*x*(1+erf(x/Math.SQRT2)); }
  function geluTanh(x){
    var c = Math.sqrt(2/Math.PI);
    var y = x + 0.044715*Math.pow(x,3);
    return 0.5*x*(1+Math.tanh(c*y));
  }
  function erf(z){
    // Abramowitz & Stegun formula 7.1.26
    var sign = z >= 0 ? 1 : -1;
    z = Math.abs(z);
    var t = 1/(1 + 0.3275911*z);
    var a1=0.254829592, a2=-0.284496736, a3=1.421413741, a4=-1.453152027, a5=1.061405429;
    var y = 1 - (((((a5*t + a4)*t + a3)*t + a2)*t + a1)*t)*Math.exp(-z*z);
    return sign * y;
  }
  function dGELU(x, mode){
    // use numerical derivative for robustness
    var h=1e-3;
    var f = (mode==='tanh')?geluTanh:geluExact;
    return (f(x+h)-f(x-h))/(2*h);
  }

  // Chart
  var ctx = $('actChart').getContext('2d');
  var chart = new Chart(ctx, {
    type:'line',
    data:{ labels:[], datasets:[] },
    options:{
      responsive:true, maintainAspectRatio:false,
      interaction:{ mode:'nearest', intersect:false },
      scales:{ x:{ title:{display:true,text:'x'}}, y:{ title:{display:true,text:'y / f′(x)'}, min:-2, max:2 } },
      plugins:{ legend:{ display:true } }
    }
  });

  // Colors and styles
  var series = {
    sigmoid: { color:'#0d6efd' },
    tanh:    { color:'#198754' },
    relu:    { color:'#dc3545' },
    leaky:   { color:'#fd7e14' },
    elu:     { color:'#6f42c1' },
    gelu:    { color:'#20c997' }
  };

  function buildData(){
    var xmin=parseFloat($('xmin').value), xmax=parseFloat($('xmax').value), N=parseInt($('samples').value);
    var leak=parseFloat($('leak').value), eluA=parseFloat($('elu').value), gMode=$('geluMode').value;
    var showD=$('chkDeriv').checked;

    var xs=new Array(N);
    for(var i=0;i<N;i++){ xs[i]= xmin + (xmax-xmin)*i/(N-1); }
    chart.data.labels = xs.map(function(v){ return v; });

    var dsets=[];

    function addCurve(name, f, df, color){
      // Map logical names to checkbox ids used in the DOM
      var idMap = {
        sigmoid: 'chkSigmoid',
        tanh:    'chkTanh',
        relu:    'chkReLU',
        leaky:   'chkLeaky',
        elu:     'chkELU',
        gelu:    'chkGELU'
      };
      var el = $(idMap[name]);
      if(!el) return; // safety guard if element is missing
      var on = el.checked;
      if(!on) return;

      var ys = xs.map(function(x){ 
        if(name==='leaky') return f(x, leak);
        if(name==='elu')   return f(x, eluA);
        if(name==='gelu')  return (gMode==='tanh'?geluTanh(x):geluExact(x));
        return f(x);
      });
      dsets.push({ label:name.toUpperCase(), data:ys, borderColor:color, borderWidth:2, pointRadius:0 });

      if(showD){
        var ysd = xs.map(function(x){
          if(name==='leaky') return df(x, leak);
          if(name==='elu')   return df(x, eluA);
          if(name==='gelu')  return dGELU(x, gMode);
          return df(x);
        });
        dsets.push({ label:name.toUpperCase() + " ′", data:ysd, borderColor:color, borderDash:[6,6], borderWidth:1.5, pointRadius:0 });
      }
    }

    addCurve('sigmoid', sigmoid, dSigmoid, series.sigmoid.color);
    addCurve('tanh', tanhAct, dTanh, series.tanh.color);
    addCurve('relu', relu, dReLU, series.relu.color);
    addCurve('leaky', leaky, dLeaky, series.leaky.color);
    addCurve('elu', elu, dELU, series.elu.color);
    addCurve('gelu', geluExact, function(x){ return dGELU(x, $('geluMode').value); }, series.gelu.color);

    chart.data.datasets = dsets;
    chart.update('none');

    // labels next to sliders
    $('leakLbl').textContent = leak.toFixed(3);
    $('eluLbl').textContent = eluA.toFixed(2);
    $('xminLbl').textContent = xmin.toFixed(1);
    $('xmaxLbl').textContent = xmax.toFixed(1);
    $('samplesLbl').textContent = N;
  }

  // Bindings
  ['chkSigmoid','chkTanh','chkReLU','chkLeaky','chkELU','chkGELU','chkDeriv',
   'leak','elu','geluMode','xmin','xmax','samples'].forEach(function(id){
     $(id).addEventListener('input', buildData);
  });

  $('btnUpdate').addEventListener('click', buildData);
  $('btnReset').addEventListener('click', function(){
    $('chkSigmoid').checked = true;
    $('chkTanh').checked = true;
    $('chkReLU').checked = true;
    $('chkLeaky').checked = true;
    $('chkELU').checked = false;
    $('chkGELU').checked = false;
    $('chkDeriv').checked = false;
    $('leak').value = 0.01; $('elu').value = 1.0; $('geluMode').value='exact';
    $('xmin').value=-6.0; $('xmax').value=6.0; $('samples').value=400;
    buildData();
  });

  // Init
  buildData();
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
        <ul class="mb-2">
          <li>Toggle functions (left) and derivatives (′) to compare shapes and slopes.</li>
          <li>Adjust domain (x min/max) to zoom in around 0 where most differences matter.</li>
          <li>Tune parameters: Leaky α (negative slope), ELU α (negative saturation), GELU exact vs tanh approximation.</li>
        </ul>
        <h6>Key differences</h6>
        <ul class="mb-0">
          <li><strong>Sigmoid:</strong> outputs (0,1); saturated ends → vanishing gradients.</li>
          <li><strong>Tanh:</strong> outputs (−1,1); zero-centered but still saturates.</li>
          <li><strong>ReLU:</strong> 0 for x&lt;0, linear for x≥0; no saturation for positives but “dead” for negatives.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Variants</h6>
        <ul class="mb-2">
          <li><strong>Leaky ReLU:</strong> lets a small negative slope (α) to avoid dead units.</li>
          <li><strong>ELU:</strong> smooth negative saturation controlled by α.</li>
          <li><strong>GELU:</strong> smooth, probabilistic gating; exact (erf) vs fast tanh approximation.</li>
        </ul>
        <div class="small-note">Search terms: “sigmoid vs tanh vs relu graph”, “activation functions explained visually”.</div>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: Expertise, Experience, Authoritativeness, Trustworthiness -->
<section class="container my-4">
  <div class="row">
    <div class="col-lg-12">
      <div class="card">
        <div class="card-body">
          <h2 class="h6 mb-2">About This Tool & Methodology</h2>
          <p>This explorer computes activation values and derivatives directly in your browser and plots them using Chart.js. Functions include Sigmoid, Tanh, ReLU, Leaky ReLU (α configurable), ELU (α configurable) and GELU (exact and tanh approximation). Inputs are clamped to avoid overflow in exp‑based functions for numerical stability.</p>

          <h3 class="h6 mt-3">Learning Outcomes</h3>
          <ul class="mb-2">
            <li>Recognize activation shapes and ranges (e.g., Sigmoid/Tanh saturation vs ReLU sparsity).</li>
            <li>Relate derivatives to gradient flow and vanishing gradients.</li>
            <li>Compare Leaky/ELU/GELU as remedies for dead ReLUs and improved learning dynamics.</li>
            <li>Understand how α (leak/ELU) shifts curvature and affects optimization.</li>
          </ul>

          <div class="row mt-2">
            <div class="col-md-6">
              <h4 class="h6">Authorship & Review</h4>
              <ul>
                <li><strong>Author:</strong> 8gwifi.org engineering team</li>
                <li><strong>Reviewed by:</strong> Anish Nath (tools maintainer)</li>
                <li><strong>Last updated:</strong> 2025-11-19</li>
              </ul>
            </div>
            <div class="col-md-6">
              <h4 class="h6">Trust & Privacy</h4>
              <ul>
                <li>All calculations and plots run locally in your browser (no data upload).</li>
                <li>Share links, if any, only encode selected options; remove parameters to keep sessions private.</li>
              </ul>
            </div>
          </div>

          <h4 class="h6 mt-2">Sources & References</h4>
          <ul class="mb-0">
            <li><a href="https://paperswithcode.com/method/gelu" target="_blank" rel="nofollow noopener">GELU (Gaussian Error Linear Unit)</a></li>
            <li><a href="https://en.wikipedia.org/wiki/Activation_function" target="_blank" rel="nofollow noopener">Activation function (overview)</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- WebPage JSON-LD + Breadcrumbs for E-E-A-T -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Activation Function Explorer",
  "url": "https://8gwifi.org/activation_function_explorer.jsp",
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
    {"@type":"ListItem","position":2,"name":"Activation Function Explorer","item":"https://8gwifi.org/activation_function_explorer.jsp"}
  ]
}
</script>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
