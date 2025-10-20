<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Diffusion Process Visualizer - Add noise forward and denoise backward on a clean image. See β-schedules and a 2D latent trajectory.">
<meta name="keywords" content="diffusion model explained, denoising diffusion visualization, latent diffusion tutorial, stable diffusion, noise schedule">
<title>Diffusion Process Visualizer</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Diffusion Process Visualizer",
  "description": "Interactive visualization of forward (noising) and reverse (denoising) diffusion with β-schedules and a toy latent trajectory.",
  "url": "https://8gwifi.org/diffusion_process_visualizer.jsp",
  "keywords": "diffusion model explained, denoising diffusion visualization, latent diffusion tutorial, stable diffusion"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .diff { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:260px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  #imgWrap { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:10px; }
  #imgCanvas { width:100%; max-width:480px; height:auto; border:1px solid #ccc; border-radius:6px; display:block; }
  .small-note { font-size:12px; color:#6c757d; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Diffusion Process Visualizer</h1>
<p>Start from a clean synthetic image, add Gaussian noise step-by-step (forward diffusion), then reverse it with a toy denoiser (reverse process). Explore β-schedules and a simple 2D latent trajectory.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#schedule" class="btn btn-outline-primary">β-Schedule</a>
    <a href="#latent" class="btn btn-outline-primary">Latent 2D</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="diff">
  <div class="row">
    <!-- Left column -->
    <div class="col-lg-8 mb-4">
      <!-- Image & Diffusion -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Image Diffusion</h5>
          <div class="small text-muted">Use the right panel to choose t, T, schedule, and strength.</div>
        </div>
        <div class="card-body">
          <div id="imgWrap">
            <canvas id="imgCanvas" width="384" height="384"></canvas>
          </div>
          <div class="row mt-3">
            <div class="col-md-4">
              <button id="btnPlayFwd" class="btn btn-primary btn-sm w-100">Play Forward ▶</button>
            </div>
            <div class="col-md-4">
              <button id="btnPlayRev" class="btn btn-success btn-sm w-100">Play Reverse ◀</button>
            </div>
            <div class="col-md-4">
              <button id="btnStop" class="btn btn-outline-secondary btn-sm w-100">Stop ⏸</button>
            </div>
          </div>
          <small class="small-note d-block mt-2">Forward: x<sub>t</sub> = √ᾱ<sub>t</sub>·x<sub>0</sub> + √(1−ᾱ<sub>t</sub>)·ε. Reverse (toy): blend toward x<sub>t−1</sub> computed with same ε (oracle), scaled by strength.</small>
        </div>
      </div>

      <!-- Schedule -->
      <div class="card mb-4" id="schedule">
        <div class="card-header">
          <h5 class="mb-0">β-Schedule</h5>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="betaChart"></canvas>
          </div>
          <small class="small-note d-block mt-2">α<sub>t</sub> = 1−β<sub>t</sub>, ᾱ<sub>t</sub> = ∏<sub>s=1..t</sub> α<sub>s</sub>. The schedule controls how fast noise is added.</small>
        </div>
      </div>

      <!-- Latent 2D -->
      <div class="card" id="latent">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Latent 2D Trajectory (toy)</h5>
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" id="showLatent" checked>
            <label class="form-check-label small" for="showLatent">Show latent</label>
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-sm">
            <canvas id="latentChart"></canvas>
          </div>
          <small class="small-note d-block mt-2">A 2D sample diffused with the same schedule: forward adds noise, reverse removes it.</small>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="col-lg-4 mb-4">
      <!-- Controls -->
      <div class="control-section">
        <h6>Controls</h6>
        <div class="slider-label"><span>Total steps T</span><strong id="TLbl">100</strong></div>
        <input type="range" id="T" min="10" max="500" step="10" value="100" class="form-range">

        <div class="slider-label"><span>Step t</span><strong id="tLbl">0</strong></div>
        <input type="range" id="t" min="0" max="100" step="1" value="0" class="form-range">

        <div class="mb-2">
          <label class="form-label small">β-schedule</label>
          <select id="scheduleType" class="form-select form-select-sm">
            <option value="linear" selected>Linear</option>
            <option value="cosine">Cosine</option>
          </select>
        </div>

        <div class="slider-label"><span>Denoise strength</span><strong id="strLbl">0.50</strong></div>
        <input type="range" id="strength" min="0" max="1" step="0.01" value="0.50" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col-6">
            <button class="btn btn-outline-primary btn-sm w-100" id="btnSeed">Randomize Seed</button>
          </div>
          <div class="col-6">
            <button class="btn btn-outline-secondary btn-sm w-100" id="btnNewImg">New Base Image</button>
          </div>
        </div>
      </div>

      <!-- Notes -->
      <div class="control-section">
        <h6>Base Image (synthetic)</h6>
        <div class="small-note">Generates simple shapes (smiley, checkerboard, stripes) for a clear noise/denoise effect.</div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function(){
  function $(id){ return document.getElementById(id); }

  // Canvas and context
  var canvas = $('imgCanvas'), ctx = canvas.getContext('2d');

  // State
  var seed = 12345;
  var T = 100, t = 0;
  var scheduleType = 'linear';
  var beta = [], alpha = [], alphaBar = [];
  var playTimer = null;
  var baseImg = null;           // Float [H][W][3] in 0..1
  var noiseImg = null;          // Fixed ε per pixel [H][W][3] in N(0,1)
  var forwardCache = {};        // map t -> image floats
  var latent = [];              // latent 2D forward/reverse trajectory
  var latentChart, betaChart;

  // Utils
  function mulberry32(a){ return function(){ var t=a+=0x6D2B79F5; t=Math.imul(t^t>>>15, t|1); t^=t+Math.imul(t^t>>>7, t|61); return ((t^t>>>14)>>>0)/4294967296; }; }
  function randnGen(rng){ var u=0,v=0; while(u===0)u=rng(); while(v===0)v=rng(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }
  function clamp01(x){ return Math.max(0, Math.min(1, x)); }

  function setSchedule(){
    T = parseInt($('T').value);
    beta = new Array(T);
    if(scheduleType==='linear'){
      var b0=1e-4, b1=0.02;
      for(var i=0;i<T;i++){ beta[i] = b0 + (b1-b0)*i/(T-1); }
    } else {
      // cosine schedule approximation
      var s=0.008;
      function f(x){ return Math.cos((x/T + s)/(1+s) * Math.PI/2); }
      var alBar = [];
      for(var i=0;i<=T;i++){ alBar[i]=f(i)*f(i); }
      beta[0] = 1 - alBar[1]/alBar[0];
      for(var i=1;i<T;i++){ beta[i] = 1 - alBar[i+1]/alBar[i]; }
      for(var i2=0;i2<T;i2++){ beta[i2] = Math.max(1e-6, Math.min(0.999, beta[i2])); }
    }
    alpha = beta.map(function(b){ return 1-b; });
    alphaBar = new Array(T);
    var prod=1;
    for(var i3=0;i3<T;i3++){ prod*=alpha[i3]; alphaBar[i3]=prod; }
    drawBeta();
  }

  function makeBaseImage(){
    // Create synthetic image on a temporary canvas
    var w=canvas.width, h=canvas.height;
    var tmp = document.createElement('canvas'); tmp.width=w; tmp.height=h;
    var c2 = tmp.getContext('2d');
    // random simple scene
    c2.fillStyle='#ffffff'; c2.fillRect(0,0,w,h);
    var rng = mulberry32(seed);
    var choice = Math.floor(rng()*3);
    if(choice===0){ // smiley
      c2.fillStyle='#ffeb99'; c2.beginPath(); c2.arc(w/2,h/2,120,0,2*Math.PI); c2.fill();
      c2.fillStyle='#212529'; c2.beginPath(); c2.arc(w/2-45,h/2-30,15,0,2*Math.PI); c2.fill();
      c2.beginPath(); c2.arc(w/2+45,h/2-30,15,0,2*Math.PI); c2.fill();
      c2.lineWidth=10; c2.strokeStyle='#212529'; c2.beginPath(); c2.arc(w/2,h/2+10,70,0,Math.PI); c2.stroke();
    } else if(choice===1){ // checker
      var s=32;
      for(var y=0;y<h;y+=s){ for(var x=0;x<w;x+=s){
        var dark = ((x+y)/s)%2<1;
        c2.fillStyle = dark ? '#343a40' : '#ced4da';
        c2.fillRect(x,y,s,s);
      } }
    } else { // stripes
      for(var y2=0;y2<h;y2+=16){
        c2.fillStyle = (Math.floor(y2/16)%2===0) ? '#74c0fc' : '#ffa8a8';
        c2.fillRect(0,y2,w,16);
      }
      c2.fillStyle='#212529'; c2.font='bold 48px sans-serif'; c2.fillText('Diffusion', 20, 60);
    }
    // read floats
    var img = c2.getImageData(0,0,w,h);
    baseImg = toFloat(img);
  }

  function toFloat(imgData){
    var w=imgData.width, h=imgData.height, d=imgData.data;
    var out=new Array(h);
    for(var y=0;y<h;y++){
      var row=new Array(w);
      for(var x=0;x<w;x++){
        var i=(y*w+x)*4;
        row[x]=[d[i]/255, d[i+1]/255, d[i+2]/255];
      }
      out[y]=row;
    }
    return out;
  }
  function toImageData(floatImg){
    var h=floatImg.length, w=floatImg[0].length;
    var imgData = ctx.createImageData(w,h);
    var d=imgData.data, idx=0;
    for(var y=0;y<h;y++){
      for(var x=0;x<w;x++){
        var px=floatImg[y][x];
        d[idx++] = Math.round(clamp01(px[0])*255);
        d[idx++] = Math.round(clamp01(px[1])*255);
        d[idx++] = Math.round(clamp01(px[2])*255);
        d[idx++] = 255;
      }
    }
    return imgData;
  }

  function makeNoise(){
    var w=canvas.width, h=canvas.height;
    noiseImg=new Array(h);
    var rng=mulberry32(seed+999);
    for(var y=0;y<h;y++){
      var row=new Array(w);
      for(var x=0;x<w;x++){
        row[x]=[randnGen(rng), randnGen(rng), randnGen(rng)];
      }
      noiseImg[y]=row;
    }
  }

  function mixForward(tStep){
    if(tStep<=0){ return baseImg; }
    var ab = alphaBar[Math.min(tStep-1, alphaBar.length-1)];
    var s1=Math.sqrt(ab), s2=Math.sqrt(Math.max(0,1-ab));
    var h=baseImg.length, w=baseImg[0].length;
    var out=new Array(h);
    for(var y=0;y<h;y++){
      var row=new Array(w);
      for(var x=0;x<w;x++){
        var b=baseImg[y][x], n=noiseImg[y][x];
        row[x]=[ s1*b[0] + s2*n[0], s1*b[1] + s2*n[1], s1*b[2] + s2*n[2] ];
      }
      out[y]=row;
    }
    return out;
  }

  function forwardTo(tStep){
    if(forwardCache[tStep]) return forwardCache[tStep];
    var img = mixForward(tStep);
    forwardCache[tStep]=img;
    return img;
  }

  function drawAt(tStep){
    var img = forwardTo(tStep);
    ctx.putImageData(toImageData(img), 0, 0);
  }

  function reverseStep(tStep, strength){
    // toy reverse: blend current x_t toward oracle x_{t-1} computed with same ε (uses true x0)
    if(tStep<=0) return forwardTo(0);
    var cur = forwardTo(tStep);
    var prev = forwardTo(tStep-1);
    var h=cur.length, w=cur[0].length;
    var out=new Array(h);
    for(var y=0;y<h;y++){
      var row=new Array(w);
      for(var x=0;x<w;x++){
        var c=cur[y][x], p=prev[y][x];
        row[x]=[
          c[0] + strength*(p[0]-c[0]),
          c[1] + strength*(p[1]-c[1]),
          c[2] + strength*(p[2]-c[2])
        ];
      }
      out[y]=row;
    }
    return out;
  }

  function drawReverse(tStep, strength){
    var img = reverseStep(tStep, strength);
    ctx.putImageData(toImageData(img), 0, 0);
  }

  // Latent 2D trajectory
  var latentCtx=null;
  function setupCharts(){
    // β chart
    betaChart = new Chart(document.getElementById('betaChart'), {
      type:'line',
      data:{ labels: beta.map(function(_,i){return i+1;}), datasets:[
        { label:'β_t', data: beta, borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.1)', tension:0.2 }
      ]},
      options:{ responsive:true, maintainAspectRatio:false, scales:{ x:{ title:{display:true,text:'t'}}, y:{ title:{display:true,text:'β'}, min:0 } } }
    });
    // latent chart
    latentCtx = new Chart(document.getElementById('latentChart'), {
      type:'line',
      data:{ datasets:[
        { label:'Forward', data:[], borderColor:'#fd7e14', backgroundColor:'rgba(253,126,20,0.15)', tension:0.2, pointRadius:2 },
        { label:'Reverse', data:[], borderColor:'#20c997', backgroundColor:'rgba(32,201,151,0.15)', tension:0.2, pointRadius:2 }
      ]},
      options:{ responsive:true, maintainAspectRatio:false, parsing:false,
        scales:{ x:{ title:{display:true,text:'z1'}}, y:{ title:{display:true,text:'z2'}} } }
    });
  }

  function drawBeta(){
    if(betaChart){
      betaChart.data.labels = beta.map(function(_,i){return i+1;});
      betaChart.data.datasets[0].data = beta;
      betaChart.update('none');
    }
  }

  function buildLatent(){
    var rng = mulberry32(seed+2024);
    var z0=[rng()*2-1, rng()*2-1]; // base latent
    var fwd=[], rev=[];
    var ab=0;
    for(var i=0;i<=T;i++){
      if(i===0){ fwd.push({x:z0[0], y:z0[1]}); continue; }
      var n=[randnGen(rng), randnGen(rng)];
      var ab_i=alphaBar[i-1];
      var s1=Math.sqrt(ab_i), s2=Math.sqrt(Math.max(0,1-ab_i));
      var z=[ s1*z0[0]+s2*n[0], s1*z0[1]+s2*n[1] ];
      fwd.push({x:z[0], y:z[1]});
    }
    // reverse using oracle previous
    for(var j=T;j>=0;j--){
      rev.push({x:fwd[j].x, y:fwd[j].y});
    }
    if(latentCtx){
      latentCtx.data.datasets[0].data = fwd;
      latentCtx.data.datasets[1].data = rev;
      latentCtx.update('none');
    }
  }

  function refreshAll(){
    // recompute schedule and caches, redraw everything consistent with controls
    scheduleType = $('scheduleType').value;
    setSchedule();
    forwardCache = {};
    drawAt(t);
    buildLatent();
  }

  // Bindings
  $('T').addEventListener('input', function(){ $('TLbl').textContent=this.value; $('t').max=this.value; refreshAll(); });
  $('t').addEventListener('input', function(){ t=parseInt(this.value); $('tLbl').textContent=this.value; drawAt(t); });
  $('scheduleType').addEventListener('change', function(){ refreshAll(); });
  $('strength').addEventListener('input', function(){ $('strLbl').textContent=parseFloat(this.value).toFixed(2); drawReverse(t, parseFloat(this.value)); });

  $('btnSeed').addEventListener('click', function(){ seed = Math.floor(Math.random()*100000); makeBaseImage(); makeNoise(); forwardCache={}; drawAt(t); buildLatent(); });
  $('btnNewImg').addEventListener('click', function(){ seed = Math.floor(Math.random()*100000); makeBaseImage(); forwardCache={}; drawAt(t); });

  $('btnPlayFwd').addEventListener('click', function(){
    if(playTimer) clearInterval(playTimer);
    playTimer = setInterval(function(){
      if(t>=T){ clearInterval(playTimer); playTimer=null; return; }
      t++; $('t').value=t; $('tLbl').textContent=t; drawAt(t);
    }, 60);
  });
  $('btnPlayRev').addEventListener('click', function(){
    if(playTimer) clearInterval(playTimer);
    playTimer = setInterval(function(){
      if(t<=0){ clearInterval(playTimer); playTimer=null; return; }
      drawReverse(t, parseFloat($('strength').value));
      t--; $('t').value=t; $('tLbl').textContent=t;
    }, 60);
  });
  $('btnStop').addEventListener('click', function(){ if(playTimer){ clearInterval(playTimer); playTimer=null; } });

  // Init
  setSchedule();
  makeBaseImage();
  makeNoise();
  setupCharts();
  drawAt(0);
  buildLatent();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">What’s happening — and why it matters</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>The diffusion idea</h6>
        <ul class="mb-2">
          <li><strong>Forward process (q):</strong> Gradually add Gaussian noise to a clean sample x<sub>0</sub>, producing x<sub>t</sub> until it becomes nearly pure noise.</li>
          <li><strong>Reverse process (p<sub>θ</sub>):</strong> A learned model predicts noise (or x<sub>0</sub>) at each step so we can denoise from x<sub>T</sub> → x<sub>0</sub>.</li>
          <li><strong>β‑schedule:</strong> Controls how fast noise grows. Linear is simple; cosine is gentler at the start and often helps quality.</li>
        </ul>
        <h6>This demo</h6>
        <ul class="mb-0">
          <li>Forward diffusion is exact: x<sub>t</sub> = √ᾱ<sub>t</sub>·x<sub>0</sub> + √(1−ᾱ<sub>t</sub>)·ε with a fixed ε.</li>
          <li>Reverse is a <em>toy</em> visualization: we blend toward the oracle x<sub>t−1</sub> (uses the same ε) to show the denoising trajectory.</li>
          <li>The 2D latent shows the same schedule in a simple space: forward adds noise, reverse removes it.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Why this matters</h6>
        <ul class="mb-2">
          <li><strong>Intuition:</strong> “Noise in → structure out” is at the heart of modern generative models (e.g., Stable Diffusion).</li>
          <li><strong>Design choices:</strong> β‑schedules, steps T, and denoising strength affect quality/speed and failure modes.</li>
          <li><strong>Education & debugging:</strong> Visualizing forward noise growth and reverse trajectories makes the math tangible and helps spot schedule or strength issues.</li>
          <li><strong>Latent diffusion:</strong> Real systems run diffusion in a compact latent space for efficiency; the 2D view hints at this idea.</li>
        </ul>
        <div class="small-note">Search terms: diffusion model explained • denoising diffusion visualization • latent diffusion tutorial.</div>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
