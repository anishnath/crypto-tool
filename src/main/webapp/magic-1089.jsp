<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- SEO Meta -->
<title>Magic 1089 Math Trick — Interactive Demo (Autoplay + Steps)</title>
<meta name="description" content="Experience the Magic 1089 math trick interactively. Pick a 3-digit number, follow reverse-subtract-reverse-add, and watch it reach 1089. Autoplay or step-by-step with beautiful visuals.">
<meta name="keywords" content="Magic 1089, 1089 trick, math trick, reverse subtract reverse add, numerical curiosity, viral math, YouTube short, interactive demo, mental math">
<link rel="canonical" href="https://8gwifi.org/magic-1089.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Magic 1089 Math Trick — Interactive Demo">
<meta property="og:description" content="Enter a 3-digit number and watch it reach 1089 via reverse-subtract-reverse-add. Autoplay or step-by-step.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/magic-1089.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Magic 1089 Math Trick — Interactive Demo">
<meta name="twitter:description" content="A beautiful, interactive way to learn the 1089 math trick.">

<%@ include file="header-script.jsp"%>

<style>
  .kap-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.8rem; font-weight: 800; text-align: center;
    padding: 0.9rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #fbbf24; text-shadow: 0 2px 12px rgba(251,191,36,0.45);
    letter-spacing: 0.25rem;
  }
  .hero-sub { text-align: center; margin-top: 0.5rem; color: #6b7280; }

  .controls { display:flex; flex-wrap:wrap; gap:0.5rem; align-items:center; margin:1rem 0; }
  .controls > * { margin-bottom:0.25rem; }
  .tiny { font-size:0.85rem; color:#6b7280; }
  .pill { display:inline-block; padding:0.35rem 0.6rem; border-radius:999px; font-size:0.9rem; }
  .pill-green{ background:#10b981; color:#0b1f17; font-weight:700; }
  .pill-gray{ background:#e5e7eb; color:#374151; font-weight:600; }
  .flex{ display:flex; } .justify-between{ justify-content:space-between; } .align-center{ align-items:center; }

  /* Steps visuals */
  .steps { margin-top:1rem; max-height:440px; overflow-y:auto; border:1px solid #e5e7eb; border-radius:12px; background:#fff; box-shadow:0 8px 24px rgba(0,0,0,0.05);}
  .step-row { display:grid; grid-template-columns:auto 1fr; gap:0.9rem; align-items:center; padding:0.8rem 1rem; border-bottom:1px dashed #e5e7eb; background:linear-gradient(0deg, #ffffff, #ffffff); animation:rowIn 300ms ease-out; }
  .step-row:last-child{ border-bottom:none; }
  @keyframes rowIn { from{opacity:0; transform:translateY(4px);} to{opacity:1; transform:translateY(0);} }
  .badge-step { font-size:0.8rem; font-weight:700; color:#374151; background:#f3f4f6; border-radius:999px; padding:0.25rem 0.55rem; white-space:nowrap; }
  .expr { display:flex; flex-wrap:wrap; gap:0.6rem; align-items:center; }
  .chip-row { display:inline-flex; gap:0.25rem; align-items:center; }
  .chip { display:inline-flex; width:30px; height:38px; align-items:center; justify-content:center; border-radius:8px; font-weight:800; letter-spacing:0.02rem; box-shadow:inset 0 -1px 0 rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.06);}
  .chip-a   { background:#e0f2fe; color:#075985; }   /* original / larger */
  .chip-b   { background:#ede9fe; color:#5b21b6; }   /* reverse / smaller */
  .chip-sum { background:#dcfce7; color:#065f46; }   /* results */
  .op{ font-weight:800; color:#6b7280; min-width:18px; text-align:center; }
  .note{ font-size:0.82rem; color:#6b7280; }

  .reached { background:linear-gradient(0deg, #ecfdf5, #ffffff) !important; border-left:4px solid #10b981; }

  /* Progress + Sparkline */
  .kap-subrow{ display:flex; gap:1rem; align-items:center; justify-content:space-between; margin-top:0.5rem; }
  .kap-progress{ position:relative; height:10px; background:#e5e7eb; border-radius:999px; overflow:hidden; flex:1; min-width:160px; }
  .kap-progress > div{ height:100%; width:0%; background:linear-gradient(90deg, #60a5fa, #10b981); transition: width 300ms ease-in-out; }
  .kap-progress > span{ position:absolute; top:-22px; right:0; font-size:0.8rem; color:#6b7280; }
  .spark { background:#ffffff; border:1px solid #e5e7eb; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.04); }

  .confetti{ position:fixed; left:50%; top:15%; transform:translateX(-50%); z-index:1000; pointer-events:none; font-size:1.75rem; opacity:0; animation:pop 1.2s ease-out forwards;}
  @keyframes pop{0%{opacity:0; transform:translate(-50%,-10px) scale(0.9);} 25%{opacity:1; transform:translate(-50%,0) scale(1.1);} 100%{opacity:0; transform:translate(-50%,10px) scale(0.9);} }

  @media (max-width:576px){ .hero-number{ font-size:2.2rem; letter-spacing:0.25rem;} .step-row{ grid-template-columns:1fr; } .badge-step{ margin-bottom:0.25rem;} }
</style>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Magic 1089 Math Trick — Interactive Demo",
  "url":"https://8gwifi.org/magic-1089.jsp",
  "description":"Interactive 1089 math trick with autoplay and step-by-step visuals: reverse, subtract, reverse, add to reach 1089.",
  "keywords":"Magic 1089, 1089 trick, math trick, reverse subtract, reverse add, viral math, YouTube short, interactive math"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="kap-container">
  <h1 class="mt-4">Magic 1089 — Reverse. Subtract. Reverse. Add.</h1>
  <p class="tiny">Pick a 3‑digit number where the first and last digits differ by at least 2. Reverse it, subtract the smaller from the larger, reverse the result, then add. You'll land on <span class="pill pill-green">1089</span>!</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">— — —</div>
  <div class="hero-sub" id="heroHint">Enter a number like 532 or tap Random</div>

  <div class="controls">
    <input class="form-control" id="userNumber" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="3" placeholder="3-digit number (e.g., 532)" style="max-width: 220px;">
    <button type="button" class="btn btn-outline-secondary" id="btnFix"><i class="fas fa-wand-magic-sparkles"></i> Make Valid</button>

    <button type="button" class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button type="button" class="btn btn-success" id="btnAutoplay"><i class="fas fa-play"></i> Autoplay</button>
    <button type="button" class="btn btn-primary" id="btnStep"><i class="fas fa-forward-step"></i> Step</button>
    <button type="button" class="btn btn-outline-danger" id="btnReset"><i class="fas fa-rotate-left"></i> Reset</button>

    <span class="tiny">&nbsp;Speed:</span>
    <input id="speedRange" type="range" min="250" max="1600" value="900" step="50" title="Autoplay speed (ms)">
    <span class="tiny" id="speedVal">0.90s</span>
  </div>

  <div class="flex justify-between align-center">
    <div class="tiny"><i class="fas fa-lightbulb"></i> Rule: 100–999, and |hundreds − ones| ≥ 2. Not valid? Tap “Make Valid”.</div>
    <div class="pill pill-gray" id="runState">Ready</div>
  </div>

  <div class="kap-subrow">
    <div class="kap-progress" aria-label="Progress">
      <div id="kapProgressInner"></div>
      <span id="kapProgressLabel">0/4</span>
    </div>
    <canvas id="kapSpark" class="spark" width="280" height="40" aria-label="1089 trick sparkline"></canvas>
  </div>

  <div class="steps" id="steps"></div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function() {
  var inputEl = document.getElementById('userNumber');
  var heroEl = document.getElementById('heroNumber');
  var hintEl = document.getElementById('heroHint');
  var stepsEl = document.getElementById('steps');
  var autoplayBtn = document.getElementById('btnAutoplay');
  var stepBtn = document.getElementById('btnStep');
  var resetBtn = document.getElementById('btnReset');
  var randomBtn = document.getElementById('btnRandom');
  var fixBtn = document.getElementById('btnFix');
  var speedRange = document.getElementById('speedRange');
  var speedVal = document.getElementById('speedVal');
  var runState = document.getElementById('runState');

  var progressInner = document.getElementById('kapProgressInner');
  var progressLabel = document.getElementById('kapProgressLabel');
  var sparkCanvas = document.getElementById('kapSpark');
  var sparkCtx = sparkCanvas ? sparkCanvas.getContext('2d') : null;
  var sparkData = [];

  var steps = [];
  var stepIndex = 0;
  var timer = null;
  var isPlaying = false;

  function setState(text, color) {
    runState.textContent = text;
    runState.style.background = color && color.bg ? color.bg : '';
    runState.style.color = color && color.fg ? color.fg : '';
  }

  function celebrate() {
    var c = document.createElement('div');
    c.className = 'confetti';
    c.innerHTML = '🎉 1 0 8 9 🎉';
    document.body.appendChild(c);
    setTimeout(function(){ document.body.removeChild(c); }, 1400);
  }

  // Visual helpers
  function chipDigits(str, cls) {
    var s = String(str);
    if (s.length === 1) s = '00' + s;
    else if (s.length === 2) s = '0' + s;
    return s.split('').map(function(d){ return '<span class="chip '+cls+'">'+d+'</span>'; }).join('');
  }
  function updateHero(txt) { heroEl.textContent = txt; }
  function clearSpark() {
    sparkData = [];
    if (sparkCtx && sparkCanvas) sparkCtx.clearRect(0,0,sparkCanvas.width, sparkCanvas.height);
  }
  function drawSpark() {
    if (!sparkCtx || !sparkCanvas || sparkData.length < 2) return;
    var w = sparkCanvas.width, h = sparkCanvas.height;
    sparkCtx.clearRect(0,0,w,h);
    sparkCtx.strokeStyle = '#10b981';
    sparkCtx.lineWidth = 2;
    sparkCtx.beginPath();
    var maxVal = Math.max.apply(null, sparkData.concat(1));
    for (var i=0;i<sparkData.length;i++) {
      var x = (w / Math.max(1, sparkData.length - 1)) * i;
      var y = h - (sparkData[i] / maxVal) * h;
      if (i===0) sparkCtx.moveTo(x,y); else sparkCtx.lineTo(x,y);
    }
    sparkCtx.stroke();
    var lastX = (w / Math.max(1, sparkData.length - 1)) * (sparkData.length - 1);
    var lastY = h - (sparkData[sparkData.length - 1] / maxVal) * h;
    sparkCtx.fillStyle = '#059669';
    sparkCtx.beginPath(); sparkCtx.arc(lastX, lastY, 3, 0, Math.PI*2); sparkCtx.fill();
  }
  function updateProgress(idx, total) {
    var pct = total ? Math.min(100, (idx / total) * 100) : 0;
    progressInner.style.width = pct + '%';
    progressLabel.textContent = idx + '/' + total;
  }

  // Trick helpers
  function pad3(n) { n = Math.abs(parseInt(n,10) || 0); var s = String(n); return s.length===1 ? '00'+s : (s.length===2 ? '0'+s : s); }
  function reverse3(n) { return pad3(n).split('').reverse().join(''); }
  function parse3(s) { return parseInt(pad3(s), 10); }

  function isValid(n) {
    n = parseInt(n, 10);
    if (!isFinite(n)) return false;
    if (n < 100 || n > 999) return false;
    var s = String(n);
    var h = parseInt(s[0],10), u = parseInt(s[2],10);
    return Math.abs(h - u) >= 2;
  }

  function nearestValid(n) {
    // Adjust to meet |hundreds - ones| >= 2 and 100..999
    n = Math.min(999, Math.max(100, parseInt(n,10) || 532));
    var s = String(n);
    var h = parseInt(s[0],10), m = parseInt(s[1],10), u = parseInt(s[2],10);
    if (Math.abs(h - u) >= 2) return n;
    // Nudge ones digit away from hundreds within 0..9
    if (h <= 7) u = Math.min(9, h + 2);
    else u = Math.max(0, h - 2);
    return parseInt('' + h + m + u, 10);
  }

  function generateValidRandom() {
    var n;
    do {
      n = 100 + Math.floor(Math.random() * 900);
    } while (!isValid(n));
    return n;
  }

  // Build the 1089 steps
  function buildSteps(n) {
    var N = parseInt(pad3(n), 10);
    var R = parseInt(reverse3(N), 10);
    var big = Math.max(N, R), small = Math.min(N, R);
    var D = big - small; var Dp = pad3(D);
    var E = parseInt(reverse3(D), 10);
    var S = D + E; // should be 1089

    var arr = [];
    arr.push({ html:'<div class="note">Start</div><div class="chip-row">'+chipDigits(pad3(N), 'chip-a')+'</div><div class="op">↔</div><div class="chip-row">'+chipDigits(pad3(R), 'chip-b')+'</div>', value: N });
    arr.push({ html:'<div class="chip-row">'+chipDigits(pad3(big), 'chip-a')+'</div><div class="op">−</div><div class="chip-row">'+chipDigits(pad3(small), 'chip-b')+'</div><div class="op">=</div><div class="chip-row">'+chipDigits(Dp, 'chip-sum')+'</div>', value: D });
    arr.push({ html:'<div class="note">Reverse the result</div><div class="chip-row">'+chipDigits(Dp, 'chip-b')+'</div><div class="op">↔</div><div class="chip-row">'+chipDigits(pad3(E), 'chip-a')+'</div>', value: E });
    arr.push({ html:'<div class="chip-row">'+chipDigits(Dp, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(pad3(E), 'chip-b')+'</div><div class="op">=</div><div class="chip-row">'+chipDigits(pad3(S), 'chip-sum')+'</div>', value: S });
    return arr;
  }

  function appendStepRow(obj, idx, isFinal) {
    var row = document.createElement('div');
    row.className = 'step-row' + (isFinal ? ' reached' : '');
    var left = document.createElement('div');
    left.className = 'badge-step';
    left.textContent = 'Step ' + idx;
    var right = document.createElement('div');
    right.className = 'expr';
    right.innerHTML = obj.html;
    row.appendChild(left); row.appendChild(right);
    stepsEl.appendChild(row);
    stepsEl.scrollTop = stepsEl.scrollHeight;
  }

  function resetAll() {
    if (timer) { clearInterval(timer); timer = null; }
    isPlaying = false;
    autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
    steps = []; stepIndex = 0;
    stepsEl.innerHTML = '';
    clearSpark();
    updateProgress(0, 4);
    updateHero('— — —');
    hintEl.textContent = 'Enter a number like 532 or tap Random';
    setState('Ready');
  }

  function rebuild() {
    var val = inputEl.value.replace(/\D/g,'').slice(0,3);
    inputEl.value = val;
    if (val.length !== 3) { resetAll(); return; }
    if (!isValid(val)) {
      setState('Not valid: ensure |hundreds − ones| ≥ 2', { bg: '#fef3c7', fg: '#78350f' });
    } else {
      setState('Ready');
    }
    steps = buildSteps(val);
    stepIndex = 0;
    stepsEl.innerHTML = '';
    clearSpark();
    updateProgress(0, steps.length);
    updateHero(val);
    hintEl.textContent = 'Press Step or Autoplay';
  }

  function doStep() {
    if (!steps || steps.length === 0) { rebuild(); if (!steps || steps.length === 0) return; }
    if (stepIndex >= steps.length) return;

    var obj = steps[stepIndex];
    appendStepRow(obj, stepIndex+1, stepIndex === steps.length-1);
    updateProgress(stepIndex+1, steps.length);
    sparkData.push(obj.value);
    drawSpark();

    if (stepIndex === steps.length - 1) {
      updateHero('1089');
      setState('Reached 1089!', { bg:'#d1fae5', fg:'#064e3b' });
      celebrate();
      if (isPlaying) toggleAutoplay(true);
    } else {
      setState('Running…');
    }
    stepIndex++;
  }

  function toggleAutoplay(forceOff) {
    if (forceOff === true) {
      if (timer) clearInterval(timer);
      isPlaying = false;
      autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
      return;
    }
    if (!isPlaying) {
      if (!steps || steps.length === 0 || stepIndex >= steps.length) rebuild();
      var delay = parseInt(speedRange.value, 10) || 900;
      timer = setInterval(function() {
        doStep();
        if (stepIndex >= steps.length) { clearInterval(timer); isPlaying = false; autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay'; }
      }, delay);
      isPlaying = true;
      autoplayBtn.innerHTML = '<i class="fas fa-pause"></i> Pause';
      setState('Autoplay');
    } else {
      clearInterval(timer);
      isPlaying = false;
      autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
      setState('Paused', { bg:'#e5e7eb', fg:'#374151' });
    }
  }

  // Events
  inputEl.addEventListener('input', function(){ if (timer) toggleAutoplay(true); rebuild(); });
  inputEl.addEventListener('keydown', function(e){ if (e.key === 'Enter') { rebuild(); doStep(); } });
  randomBtn.addEventListener('click', function() {
    var r = generateValidRandom();
    inputEl.value = String(r);
    resetAll();
    rebuild();
  });
  fixBtn.addEventListener('click', function() {
    var nv = nearestValid(inputEl.value);
    inputEl.value = String(nv);
    resetAll();
    rebuild();
  });
  stepBtn.addEventListener('click', function(){ if (isPlaying) return; doStep(); });
  autoplayBtn.addEventListener('click', function(){ toggleAutoplay(); });
  resetBtn.addEventListener('click', resetAll);
  speedRange.addEventListener('input', function(){
    var ms = parseInt(this.value, 10); speedVal.textContent = (ms/1000).toFixed(2)+'s';
    if (isPlaying) { toggleAutoplay(true); toggleAutoplay(); }
  });

  // Init
  inputEl.value = '532';
  rebuild();
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
