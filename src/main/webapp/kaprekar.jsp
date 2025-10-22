<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  Created by IntelliJ IDEA.
  Page: Kaprekar's Constant (6174) Interactive Demo
  This page follows the layout pattern used by other pages in the app.
--%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- Meta Tags for SEO -->
<meta name="description" content="Kaprekar's constant 6174 explained with an interactive demo. Enter a 4‑digit number or pick a random one, then watch the mesmerizing 6174 trick with autoplay or step-by-step mode. Perfect for math lovers and YouTube Shorts.">
<meta name="keywords" content="Kaprekar's constant, 6174, math trick, number trick, viral math, YouTube short, numerical curiosity, descending ascending digits, math magic, interactive demo">
<link rel="canonical" href="https://8gwifi.org/kaprekar.jsp">
<title>Kaprekar's Constant 6174 — Interactive Trick Demo (Autoplay + Steps)</title>

<!-- Open Graph / Twitter for better social previews -->
<meta property="og:title" content="Kaprekar's Constant 6174 — Interactive Trick Demo">
<meta property="og:description" content="Enter a 4‑digit number or pick a random one and see how it reaches 6174. Autoplay or step-by-step. A perfect math short!">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/kaprekar.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Kaprekar's Constant 6174 — Interactive Trick Demo">
<meta name="twitter:description" content="Watch the 6174 magic unfold in autoplay or step-by-step mode.">

<%@ include file="header-script.jsp"%>

<style>
  /* Responsive, bold visuals for short-form content */
  .kap-container {
    margin-top: 1rem;
  }
  .hero-number {
    font-size: 3rem;
    font-weight: 800;
    letter-spacing: 0.4rem;
    text-align: center;
    padding: 0.75rem 0;
    border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #10b981;
    text-shadow: 0 2px 12px rgba(16,185,129,0.45);
  }
  .hero-sub {
    text-align: center;
    margin-top: 0.5rem;
    color: #6b7280;
  }
  .controls {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    align-items: center;
    margin: 1rem 0;
  }
  .controls > * {
    margin-bottom: 0.25rem;
  }
  .badge-tip {
    font-size: 0.85rem;
    color: #374151;
  }
  .steps {
    margin-top: 1rem;
    max-height: 420px;
    overflow-y: auto;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
  }

  /* Fancy step row with subtle entrance animation */
  .step-row {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 0.9rem;
    align-items: center;
    padding: 0.8rem 1rem;
    border-bottom: 1px dashed #e5e7eb;
    background: linear-gradient(0deg, #ffffff, #ffffff);
    animation: rowIn 300ms ease-out;
  }
  .step-row:last-child { border-bottom: none; }
  @keyframes rowIn {
    from { opacity: 0; transform: translateY(4px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  .badge-step {
    font-size: 0.8rem;
    font-weight: 700;
    color: #374151;
    background: #f3f4f6;
    border-radius: 999px;
    padding: 0.25rem 0.55rem;
    white-space: nowrap;
  }

  .expr {
    display: flex;
    flex-wrap: wrap;
    gap: 0.6rem;
    align-items: center;
    justify-content: flex-start;
  }

  .chip-row {
    display: inline-flex;
    gap: 0.25rem;
    align-items: center;
  }

  .chip {
    display: inline-flex;
    width: 28px;
    height: 36px;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    font-weight: 800;
    letter-spacing: 0.02rem;
    box-shadow: inset 0 -1px 0 rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.06);
  }
  .chip-desc { background: #e0f2fe; color: #075985; }
  .chip-asc  { background: #ede9fe; color: #5b21b6; }
  .chip-res  { background: #dcfce7; color: #065f46; }

  .op {
    font-weight: 800;
    color: #6b7280;
    min-width: 18px;
    text-align: center;
  }

  .reached {
    background: linear-gradient(0deg, #ecfdf5, #ffffff) !important;
    border-left: 4px solid #10b981;
  }

  .tiny {
    font-size: 0.85rem;
    color: #6b7280;
  }
  .pill {
    display: inline-block;
    padding: 0.35rem 0.6rem;
    border-radius: 999px;
    font-size: 0.9rem;
  }
  .pill-green {
    background: #10b981; color: #0b1f17; font-weight: 700;
  }
  .pill-gray {
    background: #e5e7eb; color: #374151; font-weight: 600;
  }
  .flex { display: flex; }
  .gap-2 { gap: 0.5rem; }
  .align-center { align-items: center; }
  .justify-between { justify-content: space-between; }

  /* Progress + Sparkline row */
  .kap-subrow {
    display: flex;
    gap: 1rem;
    align-items: center;
    justify-content: space-between;
    margin-top: 0.5rem;
  }
  .kap-progress {
    position: relative;
    height: 10px;
    background: #e5e7eb;
    border-radius: 999px;
    overflow: hidden;
    flex: 1;
    min-width: 160px;
  }
  .kap-progress > div {
    height: 100%;
    width: 0%;
    background: linear-gradient(90deg, #60a5fa, #10b981);
    transition: width 300ms ease-in-out;
  }
  .kap-progress > span {
    position: absolute;
    top: -22px;
    right: 0;
    font-size: 0.8rem;
    color: #6b7280;
  }
  .spark {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  }

  /* Mobile tweaks */
  @media (max-width: 576px) {
    .hero-number { font-size: 2.2rem; letter-spacing: 0.25rem; }
    .step-row { grid-template-columns: 1fr; }
    .badge-step { margin-bottom: 0.25rem; }
  }

  /* Simple confetti flare for celebration */
  .confetti {
    position: fixed;
    left: 50%;
    top: 15%;
    transform: translateX(-50%);
    z-index: 1000;
    pointer-events: none;
    font-size: 1.75rem;
    opacity: 0;
    animation: pop 1.2s ease-out forwards;
  }
  @keyframes pop {
    0% { opacity: 0; transform: translate(-50%, -10px) scale(0.9); }
    25% { opacity: 1; transform: translate(-50%, 0) scale(1.1); }
    100% { opacity: 0; transform: translate(-50%, 10px) scale(0.9); }
  }

  /* Mobile tweaks */
  @media (max-width: 576px) {
    .hero-number { font-size: 2.2rem; letter-spacing: 0.25rem; }
    .step-row { grid-template-columns: 1fr; text-align: center; }
    .eq { display: none; }
  }
</style>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Kaprekar's Constant 6174 — Interactive Trick Demo",
  "description": "See how any 4-digit number (with at least two distinct digits) reaches 6174. Try autoplay or step-by-step mode. Great for math lovers and YouTube shorts.",
  "url": "https://8gwifi.org/kaprekar.jsp",
  "keywords": "Kaprekar's constant, 6174, math trick, number trick, viral math, YouTube short, numerical curiosity, descending ascending digits, math magic, interactive demo"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="kap-container">
  <h1 class="mt-4">Kaprekar's Constant 6174 — Watch the Magic</h1>
  <p class="tiny">Pick any 4‑digit number with at least two different digits. Sort digits descending and ascending, subtract, and repeat. You will land on <span class="pill pill-green">6174</span> in at most 7 steps!</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">— — — —</div>
  <div class="hero-sub" id="heroHint">Enter a number like 3524 or tap Random</div>

  <div class="controls">
    <input class="form-control" id="userNumber" type="text" maxlength="4" placeholder="Enter 4-digit number (e.g., 3524)" style="max-width: 260px;">
    <button type="button" class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>

    <button type="button" class="btn btn-success" id="btnAutoplay"><i class="fas fa-play"></i> Autoplay</button>
    <button type="button" class="btn btn-primary" id="btnStep"><i class="fas fa-forward-step"></i> Step</button>
    <button type="button" class="btn btn-outline-danger" id="btnReset"><i class="fas fa-rotate-left"></i> Reset</button>

    <span class="badge-tip">&nbsp;Speed:</span>
    <input id="speedRange" type="range" min="250" max="1600" value="900" step="50" title="Autoplay speed (ms)">
    <span class="tiny" id="speedVal">0.9s</span>
  </div>

  <div class="flex justify-between align-center">
    <div class="tiny"><i class="fas fa-lightbulb"></i> Tip: Numbers like 1000 will be padded as 1000 (leading zeros matter when sorting).</div>
    <div class="pill pill-gray" id="runState">Ready</div>
  </div>

  <div class="kap-subrow">
    <div class="kap-progress" aria-label="Progress to 6174">
      <div id="kapProgressInner"></div>
      <span id="kapProgressLabel">0/7</span>
    </div>
    <canvas id="kapSpark" class="spark" width="280" height="40" aria-label="Kaprekar progression sparkline"></canvas>
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
  var speedRange = document.getElementById('speedRange');
  var speedVal = document.getElementById('speedVal');
  var runState = document.getElementById('runState');

  // Progress + sparkline elements
  var progressInner = document.getElementById('kapProgressInner');
  var progressLabel = document.getElementById('kapProgressLabel');
  var sparkCanvas = document.getElementById('kapSpark');
  var sparkCtx = sparkCanvas ? sparkCanvas.getContext('2d') : null;
  var sparkData = [];

  var current = null;
  var seen = new Set();
  var timer = null;
  var isPlaying = false;

  function pad4(n) {
    var s = String(n).replace(/\D/g, '');
    return ('0000' + s).slice(-4);
  }
  function hasAtLeastTwoDistinctDigits(s) {
    return new Set(s.split('')).size >= 2;
  }
  function sortDigits(s, desc) {
    var arr = s.split('').sort();
    if (desc) arr.reverse();
    return arr.join('');
  }
  function stepKaprekar(nStr) {
    var a = sortDigits(nStr, true);
    var b = sortDigits(nStr, false);
    var diff = (parseInt(a, 10) - parseInt(b, 10)).toString();
    var result = pad4(diff);
    return { a: a, b: b, result: result };
  }
  function updateHero(nStr) {
    heroEl.textContent = nStr.split('').join(' ');
  }
  function setState(text, color) {
    runState.textContent = text;
    if (color) {
      runState.style.background = color.bg || '';
      runState.style.color = color.fg || '';
    }
  }
  function celebrate() {
    var c = document.createElement('div');
    c.className = 'confetti';
    c.innerHTML = '🎉 6 1 7 4 🎉';
    document.body.appendChild(c);
    setTimeout(function() { document.body.removeChild(c); }, 1400);
  }

  function makeDigitChips(str, cls) {
    return '<span class="chip ' + cls + '">' + str[0] + '</span>' +
           '<span class="chip ' + cls + '">' + str[1] + '</span>' +
           '<span class="chip ' + cls + '">' + str[2] + '</span>' +
           '<span class="chip ' + cls + '">' + str[3] + '</span>';
  }

  function updateProgress(stepCount) {
    var pct = Math.max(0, Math.min(100, (stepCount / 7) * 100));
    if (progressInner) progressInner.style.width = pct + '%';
    if (progressLabel) progressLabel.textContent = stepCount + '/7';
  }

  function clearSparkline() {
    sparkData = [];
    if (!sparkCtx || !sparkCanvas) return;
    sparkCtx.clearRect(0, 0, sparkCanvas.width, sparkCanvas.height);
  }

  function drawSparkline() {
    if (!sparkCtx || !sparkCanvas) return;
    var w = sparkCanvas.width, h = sparkCanvas.height;
    sparkCtx.clearRect(0, 0, w, h);
    if (sparkData.length < 2) return;

    // Normalize to 0..9999 for a simple trend line
    sparkCtx.strokeStyle = '#10b981';
    sparkCtx.lineWidth = 2;
    sparkCtx.beginPath();
    for (var i = 0; i < sparkData.length; i++) {
      var x = (w / Math.max(1, (sparkData.length - 1))) * i;
      var y = h - (sparkData[i] / 9999) * h;
      if (i === 0) sparkCtx.moveTo(x, y);
      else sparkCtx.lineTo(x, y);
    }
    sparkCtx.stroke();

    // Dot for last point
    var lastX = (w / Math.max(1, (sparkData.length - 1))) * (sparkData.length - 1);
    var lastY = h - (sparkData[sparkData.length - 1] / 9999) * h;
    sparkCtx.fillStyle = '#059669';
    sparkCtx.beginPath();
    sparkCtx.arc(lastX, lastY, 3, 0, Math.PI * 2);
    sparkCtx.fill();
  }
  function appendStepRow(obj, idx) {
    var row = document.createElement('div');
    row.className = 'step-row' + (obj.result === '6174' ? ' reached' : '');

    var left = document.createElement('div');
    left.className = 'badge-step';
    left.textContent = 'Step ' + idx;

    var right = document.createElement('div');
    right.className = 'expr';
    right.innerHTML =
      '<div class="chip-row">' + makeDigitChips(obj.a, 'chip-desc') + '</div>' +
      '<div class="op">−</div>' +
      '<div class="chip-row">' + makeDigitChips(obj.b, 'chip-asc') + '</div>' +
      '<div class="op">=</div>' +
      '<div class="chip-row">' + makeDigitChips(obj.result, 'chip-res') + '</div>';

    row.appendChild(left);
    row.appendChild(right);
    stepsEl.appendChild(row);
    stepsEl.scrollTop = stepsEl.scrollHeight;
  }
  function resetAll() {
    if (timer) { clearInterval(timer); timer = null; }
    isPlaying = false;
    autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
    seen.clear();
    stepsEl.innerHTML = '';
    current = null;
    updateHero('— — — —');
    hintEl.textContent = 'Enter a number like 3524 or tap Random';
    setState('Ready');

    // Reset visuals
    updateProgress(0);
    clearSparkline();
  }
  function doStep() {
    if (!current) {
      var inputVal = pad4(inputEl.value);
      if (inputVal === '0000') {
        setState('Enter a valid number', { bg: '#fee2e2', fg: '#7f1d1d' });
        return;
      }
      if (!hasAtLeastTwoDistinctDigits(inputVal)) {
        setState('Use at least 2 distinct digits', { bg: '#fef3c7', fg: '#78350f' });
        return;
      }
      current = inputVal;
      hintEl.textContent = 'Working…';
      updateHero(current);
    }
    // Detect loop (though 6174 is the attractor for valid input)
    if (seen.has(current)) {
      setState('Loop detected. Try another number.', { bg: '#fee2e2', fg: '#7f1d1d' });
      if (isPlaying) toggleAutoplay(false);
      return;
    }
    seen.add(current);

    var obj = stepKaprekar(current);
    var nextIndex = stepsEl.children.length + 1;
    appendStepRow(obj, nextIndex);
    current = obj.result;
    updateHero(current);

    // Update progress and sparkline with the new result
    updateProgress(nextIndex);
    sparkData.push(parseInt(current, 10));
    drawSparkline();

    if (current === '6174') {
      setState('Reached 6174!', { bg: '#d1fae5', fg: '#064e3b' });
      celebrate();
      if (isPlaying) toggleAutoplay(false);
    } else {
      setState('Running…');
    }
  }
  function toggleAutoplay(forceOff) {
    if (forceOff === true) {
      if (timer) clearInterval(timer);
      isPlaying = false;
      autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
      return;
    }
    if (!isPlaying) {
      if (!current) {
        // initialize from input
        var v = pad4(inputEl.value);
        if (v === '0000' || !hasAtLeastTwoDistinctDigits(v)) {
          // try generate a valid random if input invalid
          v = generateValidRandom();
          inputEl.value = v;
        }
        current = v;
        updateHero(current);
        hintEl.textContent = 'Autoplay in progress…';
        stepsEl.innerHTML = '';
        seen.clear();
      }
      var delay = parseInt(speedRange.value, 10) || 900;
      timer = setInterval(function() {
        doStep();
        if (current === '6174') {
          clearInterval(timer);
          isPlaying = false;
          autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
        }
      }, delay);
      isPlaying = true;
      autoplayBtn.innerHTML = '<i class="fas fa-pause"></i> Pause';
      setState('Autoplay');
    } else {
      clearInterval(timer);
      isPlaying = false;
      autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
      setState('Paused', { bg: '#e5e7eb', fg: '#374151' });
    }
  }
  function generateValidRandom() {
    var s = '';
    do {
      var n = Math.floor(Math.random() * 10000);
      s = pad4(n);
    } while (!hasAtLeastTwoDistinctDigits(s));
    return s;
  }

  // Event bindings
  randomBtn.addEventListener('click', function() {
    var r = generateValidRandom();
    inputEl.value = r;
    resetAll();
    // Don't lock current here; let Step/Autoplay initialize from input
    current = null;
    updateHero(r);
    hintEl.textContent = 'Ready to Step or Autoplay';
  });
  stepBtn.addEventListener('click', function() {
    if (isPlaying) return;
    doStep();
  });
  autoplayBtn.addEventListener('click', function() {
    toggleAutoplay();
  });
  resetBtn.addEventListener('click', function() {
    resetAll();
  });
  inputEl.addEventListener('input', function() {
    // keep only digits
    var sanitized = this.value.replace(/\D/g, '').slice(0,4);
    if (sanitized !== this.value) this.value = sanitized;

    // User changed input: reset state so next Step/Autoplay uses their number
    if (timer) { clearInterval(timer); timer = null; }
    isPlaying = false;
    autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
    seen.clear();
    stepsEl.innerHTML = '';
    current = null;
    updateHero('— — — —');
    hintEl.textContent = 'Ready to Step or Autoplay';
    setState('Ready');
  });
  inputEl.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
      doStep();
    }
  });
  speedRange.addEventListener('input', function() {
    var ms = parseInt(this.value, 10);
    speedVal.textContent = (ms / 1000).toFixed(2) + 's';
    if (isPlaying) {
      // restart timer with new speed
      toggleAutoplay(true);
      toggleAutoplay();
    }
  });

  // init
  resetAll();
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
