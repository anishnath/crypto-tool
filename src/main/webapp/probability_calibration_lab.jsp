<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Probability Calibration Lab - Compare calibrated vs uncalibrated probabilities with reliability diagrams, histograms, and calibration metrics.">
<meta name="keywords" content="probability calibration, reliability diagram, ECE, Brier score, Platt scaling, isotonic regression, temperature scaling">
<title>Probability Calibration Lab</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Probability Calibration Lab",
  "description": "Interactive tool to compare uncalibrated vs calibrated probabilities using Platt scaling, Isotonic regression, and Temperature scaling with reliability diagrams and metrics.",
  "url": "https://8gwifi.org/probability_calibration_lab.jsp",
  "keywords": "calibration, reliability, ECE, Brier, Platt scaling, Isotonic, Temperature scaling"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .calib-lab { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }

  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:240px; }

  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }

  .metric-card { background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.green { background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%); }
  .metric-card.pink  { background:linear-gradient(135deg,#f093fb 0%,#f5576c 100%); }
  .metric-card.purple{ background:linear-gradient(135deg,#a18cd1 0%,#fbc2eb 100%); }
  .metric-label { font-size:12px; opacity:0.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }

  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🎯 Probability Calibration Lab</h1>
<p>Compare model confidence before and after calibration. Inspect the reliability diagram, probability histogram, and calibration metrics (Brier, Log Loss, ECE, MCE).</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#reliability" class="btn btn-outline-primary">Reliability</a>
    <a href="#hist" class="btn btn-outline-primary">Histogram</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="calib-lab">
  <div class="row">
    <!-- Left column: Charts -->
    <div class="col-lg-8 mb-4">
      <!-- Reliability Diagram -->
      <div class="card mb-4" id="reliability">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Reliability Diagram</h5>
          <small class="text-muted">Ideal = diagonal; calibrated curve should move closer</small>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="relChart"></canvas>
          </div>
          <div class="row mt-3">
            <div class="col-md-3"><div class="metric-card"><div class="metric-label">Brier (raw)</div><div class="metric-value" id="mBrierRaw">—</div></div></div>
            <div class="col-md-3"><div class="metric-card green"><div class="metric-label">Brier (cal)</div><div class="metric-value" id="mBrierCal">—</div></div></div>
            <div class="col-md-3"><div class="metric-card pink"><div class="metric-label">ECE (raw)</div><div class="metric-value" id="mEceRaw">—</div></div></div>
            <div class="col-md-3"><div class="metric-card purple"><div class="metric-label">ECE (cal)</div><div class="metric-value" id="mEceCal">—</div></div></div>
          </div>
        </div>
      </div>

      <!-- Probability Histogram -->
      <div class="card mb-4" id="hist">
        <div class="card-header">
          <h5 class="mb-0">Predicted Probability Histogram</h5>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="histChart"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Overconfident models pile up near 0 or 1 but don’t align with actual frequencies.</small>
        </div>
      </div>
    </div>

    <!-- Right column: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset & Generator -->
      <div class="control-section">
        <h6>📦 Dataset & Generator</h6>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnBalanced">Balanced</button>
          <button class="btn btn-outline-secondary" id="btnImbalanced">Imbalanced</button>
        </div>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnShift">Domain Shift</button>
          <button class="btn btn-outline-secondary" id="btnNoisy">Noisy Labels</button>
        </div>

        <div class="slider-label"><span>Train size</span><strong id="trainVal">1000</strong></div>
        <input type="range" id="nTrain" min="200" max="5000" step="100" value="1000" class="form-range">

        <div class="slider-label"><span>Test size</span><strong id="testVal">1000</strong></div>
        <input type="range" id="nTest" min="200" max="5000" step="100" value="1000" class="form-range">

        <div class="slider-label"><span>Model sharpness (T)</span><strong id="sharpVal">0.80</strong></div>
        <input type="range" id="sharp" min="0.2" max="2.0" step="0.01" value="0.80" class="form-range">

        <div class="slider-label"><span>Label noise</span><strong id="noiseVal">0.00</strong></div>
        <input type="range" id="lblNoise" min="0" max="0.4" step="0.01" value="0.00" class="form-range">

        <div class="form-check mt-2">
          <input class="form-check-input" type="checkbox" id="useShift">
          <label class="form-check-label small" for="useShift">Different class prior in test (domain shift)</label>
        </div>
      </div>

      <!-- Calibration -->
      <div class="control-section">
        <h6>🧪 Calibration</h6>
        <div class="mb-2">
          <select id="method" class="form-select form-select-sm">
            <option value="none" selected>None (raw)</option>
            <option value="platt">Platt scaling (logistic)</option>
            <option value="isotonic">Isotonic regression</option>
            <option value="temp">Temperature scaling</option>
          </select>
        </div>

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnFit">Fit Calibration</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnEval">Evaluate</button></div>
        </div>

        <div class="small mt-2">
          <div>Log Loss (raw): <strong id="mNllRaw">—</strong></div>
          <div>Log Loss (cal): <strong id="mNllCal">—</strong></div>
          <div>MCE (raw): <strong id="mMceRaw">—</strong></div>
          <div>MCE (cal): <strong id="mMceCal">—</strong></div>
        </div>
      </div>

      <!-- Actions -->
      <div class="control-section">
        <h6>⚙️ Actions</h6>
        <div class="row g-2">
          <div class="col"><button class="btn btn-success btn-sm w-100" id="btnGenerate">Generate Data</button></div>
          <div class="col"><button class="btn btn-danger btn-sm w-100" id="btnReset">Reset</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function() {
  function $(id){ return document.getElementById(id); }
  function sigmoid(z){ return 1/(1+Math.exp(-Math.max(-50, Math.min(50, z)))); }
  function logit(p){ var e=1e-12; p=Math.max(e, Math.min(1-e, p)); return Math.log(p/(1-p)); }
  function mean(a){ if(a.length===0) return 0; var s=0; for(var i=0;i<a.length;i++) s+=a[i]; return s/a.length; }
  function randn(){ var u=0,v=0; while(u===0) u=Math.random(); while(v===0) v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }

  // State
  var train = { y:[], p_raw:[], logit_raw:[] };
  var test  = { y:[], p_raw:[], logit_raw:[] };
  var calibParams = { method:'none', a:1, b:0, T:1, iso:{ s:[], v:[] } };

  // Charts
  var relChart = new Chart($('relChart'), {
    type:'line',
    data:{ labels:[], datasets:[
      { label:'Ideal', data:[], borderColor:'#6c757d', borderDash:[6,6], pointRadius:0, fill:false },
      { label:'Raw',   data:[], borderColor:'#f5576c', backgroundColor:'rgba(245,87,108,0.15)', pointRadius:3, fill:false, tension:0.2 },
      { label:'Calibrated', data:[], borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.15)', pointRadius:3, fill:false, tension:0.2 }
    ]},
    options:{ responsive:true, maintainAspectRatio:false, parsing:false, scales:{ x:{ min:0, max:1, title:{display:true,text:'Predicted probability'}}, y:{ min:0, max:1, title:{display:true,text:'Empirical frequency'}} } }
  });

  var histChart = new Chart($('histChart'), {
    type:'bar',
    data:{ labels:[], datasets:[
      { label:'Raw', data:[], backgroundColor:'rgba(245,87,108,0.5)' },
      { label:'Calibrated', data:[], backgroundColor:'rgba(25,135,84,0.5)' }
    ]},
    options:{ responsive:true, maintainAspectRatio:false, scales:{ x:{ title:{display:true,text:'Probability bins'}}, y:{ title:{display:true,text:'Count'}, beginAtZero:true } } }
  });

  // UI bindings
  $('nTrain').addEventListener('input', function(){ $('trainVal').textContent = this.value; });
  $('nTest').addEventListener('input',  function(){ $('testVal').textContent  = this.value; });
  $('sharp').addEventListener('input',  function(){ $('sharpVal').textContent = parseFloat(this.value).toFixed(2); });
  $('lblNoise').addEventListener('input', function(){ $('noiseVal').textContent = parseFloat(this.value).toFixed(2); });

  $('btnBalanced').addEventListener('click', function(){ setPreset('balanced'); });
  $('btnImbalanced').addEventListener('click', function(){ setPreset('imbalanced'); });
  $('btnShift').addEventListener('click', function(){ setPreset('shift'); });
  $('btnNoisy').addEventListener('click', function(){ setPreset('noisy'); });

  $('method').addEventListener('change', function(){ calibParams.method = this.value; });

  $('btnGenerate').addEventListener('click', function(){ generateAll(); evaluateAll(); });
  $('btnFit').addEventListener('click', function(){ fitCalibration(); evaluateAll(); });
  $('btnEval').addEventListener('click', function(){ evaluateAll(); });
  $('btnReset').addEventListener('click', function(){ resetAll(); });

  // Presets
  function setPreset(type){
    if(type==='balanced'){ $('useShift').checked=false; $('sharp').value=0.8; $('sharpVal').textContent='0.80'; $('lblNoise').value=0.0; $('noiseVal').textContent='0.00'; }
    if(type==='imbalanced'){ $('useShift').checked=false; $('sharp').value=0.8; $('sharpVal').textContent='0.80'; $('lblNoise').value=0.0; $('noiseVal').textContent='0.00'; }
    if(type==='shift'){ $('useShift').checked=true; $('sharp').value=0.8; $('sharpVal').textContent='0.80'; $('lblNoise').value=0.0; $('noiseVal').textContent='0.00'; }
    if(type==='noisy'){ $('useShift').checked=false; $('sharp').value=0.7; $('sharpVal').textContent='0.70'; $('lblNoise').value=0.15; $('noiseVal').textContent='0.15'; }
    generateAll(); evaluateAll();
  }

  // Data generation
  function generateDataset(n, pi, sharpT, lblNoise){
    var y=[], p_raw=[], logit_raw=[];
    for(var i=0;i<n;i++){
      var yi = Math.random() < pi ? 1 : 0;
      // base logits: positives centered higher than negatives
      var z = yi ? (1.5 + randn()*0.8) : (-1.5 + randn()*0.8);
      // model sharpness (T<1 overconfident, T>1 underconfident)
      var logit_model = z / sharpT;
      var p = sigmoid(logit_model);
      // flip labels for noise
      if(Math.random() < lblNoise){ yi = 1 - yi; }
      y.push(yi);
      p_raw.push(p);
      logit_raw.push(logit_model);
    }
    return { y:y, p_raw:p_raw, logit_raw:logit_raw };
  }

  function generateAll(){
    var nTr = parseInt($('nTrain').value);
    var nTe = parseInt($('nTest').value);
    var sharpT = parseFloat($('sharp').value);
    var noise = parseFloat($('lblNoise').value);
    var shift = $('useShift').checked;

    var pi_train = 0.5;
    var pi_test  = shift ? 0.2 : 0.5;

    train = generateDataset(nTr, pi_train, sharpT, noise);
    test  = generateDataset(nTe, pi_test,  sharpT, noise);

    calibParams = { method: $('method').value, a:1, b:0, T:1, iso:{ s:[], v:[] } };
  }

  // Calibration methods
  function plattFit(y, p_raw){
    // Fit a,b in sigmoid(a*s + b) where s = logit(p_raw)
    var s = []; for(var i=0;i<p_raw.length;i++){ s.push(logit(p_raw[i])); }
    var a=1, b=0, lr=0.01;
    for(var it=0; it<300; it++){
      var ga=0, gb=0;
      for(var i=0;i<s.length;i++){
        var z = a*s[i] + b;
        var p = sigmoid(z);
        ga += (p - y[i]) * s[i];
        gb += (p - y[i]);
      }
      a -= lr * ga / s.length;
      b -= lr * gb / s.length;
    }
    return {a:a, b:b};
  }

  function plattApply(p_raw, params){
    var out=[]; for(var i=0;i<p_raw.length;i++){
      var s = logit(p_raw[i]);
      out.push( sigmoid(params.a*s + params.b) );
    }
    return out;
  }

  function isoFit(y, p_raw){
    // Isotonic regression via Pool Adjacent Violators on sorted s
    var s = []; for(var i=0;i<p_raw.length;i++){ s.push(logit(p_raw[i])); }
    var idx = s.map(function(_,i){return i;}).sort(function(a,b){ return s[a]-s[b]; });
    var w = []; var v = []; // weights=1
    for(var k=0;k<idx.length;k++){ w.push(1); v.push(y[idx[k]]); }
    // PAV
    var i=0;
    while(i< v.length-1){
      if(v[i] <= v[i+1]){ i++; continue; }
      var sumW = w[i]+w[i+1];
      var avg  = (w[i]*v[i] + w[i+1]*v[i+1]) / sumW;
      v.splice(i,2,avg);
      w.splice(i,2,sumW);
      i = Math.max(0, i-1);
    }
    // Build mapping: unique s_sorted breakpoints and fitted values expanded back
    var s_sorted = idx.map(function(ii){ return s[ii]; });
    // Expand v over runs according to w (not strictly needed for prediction if we interpolate)
    return { s: s_sorted, v: expandIsotonicValues(v, w) };
  }
  function expandIsotonicValues(v, w){
    var out=[]; for(var i=0;i<v.length;i++){ for(var j=0;j<w[i]; j++){ out.push(v[i]); } } return out;
  }
  function isoApply(p_raw, iso){
    var s = []; for(var i=0;i<p_raw.length;i++){ s.push(logit(p_raw[i])); }
    // For each s, find nearest index in iso.s (assumes iso.s sorted)
    var out=[];
    for(var i=0;i<s.length;i++){
      var j = nearestIndex(iso.s, s[i]);
      var val = iso.v.length>j ? iso.v[j] : (iso.v.length>0 ? iso.v[iso.v.length-1] : 0.5);
      // Clip to [0,1]
      val = Math.max(0, Math.min(1, val));
      out.push(val);
    }
    return out;
  }
  function nearestIndex(arr, x){
    if(arr.length===0) return 0;
    var lo=0, hi=arr.length-1;
    while(lo<hi){
      var mid=(lo+hi)>>1;
      if(arr[mid]<x) lo=mid+1; else hi=mid;
    }
    if(lo===0) return 0;
    if(lo===arr.length) return arr.length-1;
    // choose closer of lo and lo-1
    return (Math.abs(arr[lo]-x) < Math.abs(arr[lo-1]-x)) ? lo : lo-1;
  }

  function tempFit(y, logit_raw){
    // Minimize NLL of sigmoid(z/T)
    var T=1.0, lr=0.01;
    for(var it=0; it<300; it++){
      var g=0;
      for(var i=0;i<logit_raw.length;i++){
        var z = logit_raw[i]/T;
        var p = sigmoid(z);
        // dNLL/dT = (p - y) * (-logit_raw / T^2)
        g += (p - y[i]) * (-logit_raw[i] / (T*T));
      }
      T -= lr * g / logit_raw.length;
      T = Math.max(0.05, Math.min(10, T));
    }
    return {T:T};
  }
  function tempApply(logit_raw, params){
    var out=[]; for(var i=0;i<logit_raw.length;i++){ out.push( sigmoid(logit_raw[i] / params.T) ); } return out;
  }

  function fitCalibration(){
    var m = $('method').value;
    calibParams.method = m;
    if(m==='none'){ calibParams.a=1; calibParams.b=0; calibParams.T=1; calibParams.iso={s:[],v:[]}; return; }
    if(m==='platt'){
      var r = plattFit(train.y, train.p_raw);
      calibParams.a = r.a; calibParams.b=r.b;
    } else if(m==='isotonic'){
      var iso = isoFit(train.y, train.p_raw);
      calibParams.iso = iso;
    } else if(m==='temp'){
      var r2 = tempFit(train.y, train.logit_raw);
      calibParams.T = r2.T;
    }
  }

  function applyCalibration(p_raw, logit_raw){
    var m = calibParams.method;
    if(m==='platt') return plattApply(p_raw, calibParams);
    if(m==='isotonic') return isoApply(p_raw, calibParams.iso);
    if(m==='temp')     return tempApply(logit_raw, calibParams);
    return p_raw.slice(0);
  }

  // Metrics
  function brier(y,p){ var s=0; for(var i=0;i<y.length;i++){ var d=(p[i]-y[i]); s+=d*d; } return s/y.length; }
  function logloss(y,p){ var e=1e-12; var s=0; for(var i=0;i<y.length;i++){ var pi=Math.max(e, Math.min(1-e, p[i])); s += - ( y[i]*Math.log(pi) + (1-y[i])*Math.log(1-pi) ); } return s/y.length; }
  function eceMce(y,p, M){
    var bins=[], counts=[], acc=[], conf=[];
    for(var i=0;i<M;i++){ bins.push([]); counts.push(0); acc.push(0); conf.push(0); }
    for(var i=0;i<p.length;i++){
      var b = Math.min(M-1, Math.floor(p[i]*M));
      bins[b].push(i);
    }
    var ece=0, mce=0, N=p.length;
    for(var b=0;b<M;b++){
      var idx=bins[b];
      if(idx.length===0) continue;
      var sumY=0, sumP=0;
      for(var j=0;j<idx.length;j++){ sumY+=y[idx[j]]; sumP+=p[idx[j]]; }
      var pb = sumP/idx.length;
      var ab = sumY/idx.length;
      var gap = Math.abs(pb - ab);
      ece += (idx.length/N) * gap;
      if(gap>mce) mce=gap;
    }
    return { ece:ece, mce:mce };
  }

  function reliabilityPoints(y,p, M){
    var xs=[], ys=[];
    var bins=[], sumsY=[], sumsP=[], cnts=[];
    for(var i=0;i<M;i++){ bins.push([]); sumsY.push(0); sumsP.push(0); cnts.push(0); }
    for(var i=0;i<p.length;i++){
      var b = Math.min(M-1, Math.floor(p[i]*M));
      sumsY[b]+=y[i]; sumsP[b]+=p[i]; cnts[b]+=1;
    }
    for(var b=0;b<M;b++){
      if(cnts[b]===0) continue;
      xs.push( sumsP[b]/cnts[b] );
      ys.push( sumsY[b]/cnts[b] );
    }
    return { x:xs, y:ys };
  }

  function histogramData(p, M){
    var counts=new Array(M).fill(0);
    for(var i=0;i<p.length;i++){
      var b = Math.min(M-1, Math.floor(p[i]*M));
      counts[b]+=1;
    }
    var labels=[];
    for(var k=0;k<M;k++){ var a=k/M, b=(k+1)/M; labels.push(a.toFixed(2)+'-'+b.toFixed(2)); }
    return { labels:labels, counts:counts };
  }

  // Evaluate and draw
  function evaluateAll(){
    // Raw and Calibrated on TEST
    var pRaw = test.p_raw.slice(0);
    var pCal = applyCalibration(test.p_raw, test.logit_raw);

    // Metrics
    var brRaw = brier(test.y, pRaw);
    var brCal = brier(test.y, pCal);
    var llRaw = logloss(test.y, pRaw);
    var llCal = logloss(test.y, pCal);
    var e1 = eceMce(test.y, pRaw, 10);
    var e2 = eceMce(test.y, pCal, 10);

    $('mBrierRaw').textContent = brRaw.toFixed(4);
    $('mBrierCal').textContent = brCal.toFixed(4);
    $('mNllRaw').textContent   = llRaw.toFixed(4);
    $('mNllCal').textContent   = llCal.toFixed(4);
    $('mEceRaw').textContent   = e1.ece.toFixed(4);
    $('mMceRaw').textContent   = e1.mce.toFixed(4);
    $('mEceCal').textContent   = e2.ece.toFixed(4);
    $('mMceCal').textContent   = e2.mce.toFixed(4);

    // Reliability
    var relRaw = reliabilityPoints(test.y, pRaw, 10);
    var relCal = reliabilityPoints(test.y, pCal, 10);
    relChart.data.labels = [0,1];
    relChart.data.datasets[0].data = [ {x:0,y:0}, {x:1,y:1} ];
    relChart.data.datasets[1].data = toXY(relRaw.x, relRaw.y);
    relChart.data.datasets[2].data = toXY(relCal.x, relCal.y);
    relChart.update('none');

    // Histogram
    var hRaw = histogramData(pRaw, 20);
    var hCal = histogramData(pCal, 20);
    histChart.data.labels = hRaw.labels;
    histChart.data.datasets[0].data = hRaw.counts;
    histChart.data.datasets[1].data = hCal.counts;
    histChart.update('none');
  }

  function toXY(xs, ys){
    var out=[]; for(var i=0;i<xs.length;i++){ out.push({x:xs[i], y:ys[i]}); } return out;
  }

  function resetAll(){
    train = { y:[], p_raw:[], logit_raw:[] };
    test  = { y:[], p_raw:[], logit_raw:[] };
    calibParams = { method:'none', a:1, b:0, T:1, iso:{ s:[], v:[] } };
    relChart.data.datasets[1].data=[]; relChart.data.datasets[2].data=[];
    relChart.update('none');
    histChart.data.labels=[]; histChart.data.datasets[0].data=[]; histChart.data.datasets[1].data=[];
    histChart.update('none');
    $('mBrierRaw').textContent='—'; $('mBrierCal').textContent='—';
    $('mNllRaw').textContent='—';   $('mNllCal').textContent='—';
    $('mEceRaw').textContent='—';   $('mEceCal').textContent='—';
    $('mMceRaw').textContent='—';   $('mMceCal').textContent='—';
  }

  // Init default
  generateAll();
  evaluateAll();
});

// Preset button handlers refer to DOM in main handler
function setPreset(type){} // no-op placeholder (handled in DOMContentLoaded)
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">What is Calibration? Why it matters</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Calibration basics</h6>
        <ul class="mb-2">
          <li><strong>Well-calibrated:</strong> Of all samples scored ~0.7, about 70% are positive</li>
          <li><strong>Discrimination vs calibration:</strong> AUC measures ranking; calibration measures probability accuracy</li>
          <li><strong>Reliability diagram:</strong> Plots predicted vs empirical frequency (diagonal = perfect)</li>
        </ul>
        <h6>Methods</h6>
        <ul class="mb-0">
          <li><strong>Platt scaling:</strong> Logistic mapping of scores (smooth, monotonic)</li>
          <li><strong>Isotonic regression:</strong> Flexible, non-parametric monotonic fit (data-hungry)</li>
          <li><strong>Temperature scaling:</strong> Adjusts logit sharpness (preserves ranking)</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>When to calibrate</h6>
        <ul class="mb-2">
          <li>Imbalanced data and rare-event prediction</li>
          <li>Risk-sensitive thresholds and capacity planning</li>
          <li>Domain shift (different prevalence); recalibration often required</li>
        </ul>
        <h6>Metrics</h6>
        <ul class="mb-0">
          <li><strong>Brier score:</strong> Mean squared error of probabilities (lower is better)</li>
          <li><strong>Log loss:</strong> Penalizes overconfident errors (lower is better)</li>
          <li><strong>ECE/MCE:</strong> Average and worst-case calibration gaps</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
