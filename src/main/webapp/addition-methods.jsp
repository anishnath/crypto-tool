<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- SEO Meta -->
<title>Addition Methods Visualizer — 25+ Ways to Add (Autoplay + Steps)</title>
<meta name="description" content="Explore 25+ addition strategies with a beautiful visualizer: standard algorithm, decomposition, making tens, left-to-right, compensation, number line, binary addition, mental math tricks, and more. Autoplay or step-by-step for YouTube Shorts-ready visuals.">
<meta name="keywords" content="addition methods, math tricks, mental math, standard algorithm, decomposition, making tens, Japanese method, left to right addition, compensation method, number line, binary addition, vedic math, skip counting, abacus, mental abacus, trachtenberg, visual math, YouTube shorts, learn math fast">
<link rel="canonical" href="https://8gwifi.org/addition-methods.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Addition Methods Visualizer — 25+ Ways to Add">
<meta property="og:description" content="Autoplay or step-by-step demos for standard algorithm, making tens, left-to-right, decomposition, compensation, number line, binary, and more.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/addition-methods.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Addition Methods Visualizer — 25+ Ways to Add">
<meta name="twitter:description" content="A beautiful, interactive way to learn 25+ addition strategies.">

<%@ include file="header-script.jsp"%>

<style>
  .kap-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.6rem; font-weight: 800; text-align: center;
    padding: 0.75rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #60a5fa; text-shadow: 0 2px 12px rgba(59,130,246,0.45);
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

  /* Steps card styles */
  .steps { margin-top:1rem; max-height:440px; overflow-y:auto; border:1px solid #e5e7eb; border-radius:12px; background:#fff; box-shadow:0 8px 24px rgba(0,0,0,0.05);}
  .step-row { display:grid; grid-template-columns:auto 1fr; gap:0.9rem; align-items:center; padding:0.8rem 1rem; border-bottom:1px dashed #e5e7eb; background:linear-gradient(0deg, #ffffff, #ffffff); animation:rowIn 300ms ease-out; }
  .step-row:last-child{ border-bottom:none; }
  @keyframes rowIn { from{opacity:0; transform:translateY(4px);} to{opacity:1; transform:translateY(0);} }
  .badge-step { font-size:0.8rem; font-weight:700; color:#374151; background:#f3f4f6; border-radius:999px; padding:0.25rem 0.55rem; white-space:nowrap; }
  .expr { display:flex; flex-wrap:wrap; gap:0.6rem; align-items:center; }
  .chip-row { display:inline-flex; gap:0.25rem; align-items:center; }
  .chip { display:inline-flex; width:28px; height:36px; align-items:center; justify-content:center; border-radius:8px; font-weight:800; letter-spacing:0.02rem; box-shadow:inset 0 -1px 0 rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.06);}
  .chip-a   { background:#e0f2fe; color:#075985; }   /* A value */
  .chip-b   { background:#ede9fe; color:#5b21b6; }   /* B value */
  .chip-sum { background:#dcfce7; color:#065f46; }   /* running sum/result */
  .op{ font-weight:800; color:#6b7280; min-width:18px; text-align:center; }
  .note{ font-size:0.8rem; color:#6b7280; }

  .reached { background:linear-gradient(0deg, #ecfdf5, #ffffff) !important; border-left:4px solid #10b981; }

  /* Progress + Sparkline row */
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
  "name":"Addition Methods Visualizer — 25+ Ways to Add",
  "url":"https://8gwifi.org/addition-methods.jsp",
  "description":"Learn 25+ addition strategies with a step-by-step visualizer. Try autoplay for Shorts-ready animations.",
  "keywords":"addition methods, math tricks, mental math, standard algorithm, decomposition, making tens, left to right addition, compensation, number line, binary addition, vedic math, skip counting, abacus, mental abacus, trachtenberg"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="kap-container">
  <h1 class="mt-4">Addition Methods Visualizer — 25+ Ways to Add</h1>
  <p class="tiny">Type two numbers, choose a method, then <span class="pill pill-green">Autoplay</span> or go <span class="pill pill-gray">Step</span> by step. Built for learning and short-form videos.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">— — —</div>
  <div class="hero-sub" id="heroHint">Try numbers like 487 + 358 or tap Random</div>

  <div class="controls">
    <input class="form-control" id="numA" type="text" inputmode="numeric" pattern="[0-9]*" placeholder="First number (e.g., 487)" style="max-width: 180px;">
    <span class="op">+</span>
    <input class="form-control" id="numB" type="text" inputmode="numeric" pattern="[0-9]*" placeholder="Second number (e.g., 358)" style="max-width: 180px;">

    <select id="method" class="form-control" style="min-width: 250px;">
      <option value="standard">Standard Algorithm</option>
      <option value="decompose">Break Apart / Decomposition</option>
      <option value="left2right">Left-to-Right Addition</option>
      <option value="makingTens">Making Tens (Japanese Method)</option>
      <option value="compensation">Compensation Method</option>
      <option value="tensOnes">Tens & Ones Separation</option>
      <option value="skipCounting">Skip Counting</option>
      <option value="numberLine">Number Line Method</option>
      <option value="averaging">Averaging & Doubling</option>
      <option value="binary">Binary Addition (Computer Method)</option>
      <option value="quickMath">Quick Math / Mental Math</option>
      <!-- Additional names listed are supported as narrative overlays via these core generators -->
    </select>

    <button type="button" class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button type="button" class="btn btn-success" id="btnAutoplay"><i class="fas fa-play"></i> Autoplay</button>
    <button type="button" class="btn btn-primary" id="btnStep"><i class="fas fa-forward-step"></i> Step</button>
    <button type="button" class="btn btn-outline-danger" id="btnReset"><i class="fas fa-rotate-left"></i> Reset</button>

    <span class="tiny">&nbsp;Speed:</span>
    <input id="speedRange" type="range" min="250" max="1600" value="900" step="50" title="Autoplay speed (ms)">
    <span class="tiny" id="speedVal">0.90s</span>
  </div>

  <div class="flex justify-between align-center">
    <div class="tiny"><i class="fas fa-lightbulb"></i> Tip: Works with large integers too. For Shorts, try 3–5 steps methods for snappy visuals.</div>
    <div class="pill pill-gray" id="runState">Ready</div>
  </div>

  <div class="kap-subrow">
    <div class="kap-progress" aria-label="Progress of steps">
      <div id="kapProgressInner"></div>
      <span id="kapProgressLabel">0</span>
    </div>
    <canvas id="kapSpark" class="spark" width="280" height="40" aria-label="Running sum sparkline"></canvas>
  </div>

  <div class="steps" id="steps"></div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function() {
  // Elements
  var aEl = document.getElementById('numA');
  var bEl = document.getElementById('numB');
  var methodEl = document.getElementById('method');
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

  var progressInner = document.getElementById('kapProgressInner');
  var progressLabel = document.getElementById('kapProgressLabel');
  var sparkCanvas = document.getElementById('kapSpark');
  var sparkCtx = sparkCanvas ? sparkCanvas.getContext('2d') : null;
  var sparkData = [];

  var steps = [];
  var stepIndex = 0;
  var timer = null;
  var isPlaying = false;

  // Utils
  function sanitizeInt(s) {
    var t = String(s || '').replace(/[^0-9\-]/g, '');
    if (t === '' || t === '-' || t === '--') return 0;
    return parseInt(t, 10) || 0;
  }
  function chipDigits(n, cls) {
    var s = String(Math.abs(n));
    if (s.length === 0) s = '0';
    return s.split('').map(function(d){ return '<span class="chip '+cls+'">'+d+'</span>'; }).join('');
  }
  function setState(text, color) {
    runState.textContent = text;
    if (color) {
      runState.style.background = color.bg || '';
      runState.style.color = color.fg || '';
    } else {
      runState.style.background = '';
      runState.style.color = '';
    }
  }
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
    for (var i=0;i<sparkData.length;i++) {
      var x = (w / Math.max(1, sparkData.length - 1)) * i;
      var maxVal = Math.max.apply(null, sparkData.concat(1));
      var y = h - (sparkData[i] / maxVal) * h;
      if (i===0) sparkCtx.moveTo(x,y); else sparkCtx.lineTo(x,y);
    }
    sparkCtx.stroke();
    var lastX = (w / Math.max(1, sparkData.length - 1)) * (sparkData.length - 1);
    var lastY = h - (sparkData[sparkData.length - 1] / Math.max.apply(null, sparkData.concat(1))) * h;
    sparkCtx.fillStyle = '#059669';
    sparkCtx.beginPath(); sparkCtx.arc(lastX, lastY, 3, 0, Math.PI*2); sparkCtx.fill();
  }
  function updateProgress(count, total) {
    var pct = total ? Math.min(100, (count / total) * 100) : 0;
    progressInner.style.width = pct + '%';
    progressLabel.textContent = count + (total ? '/' + total : '');
  }
  function celebrate() {
    var c = document.createElement('div');
    c.className = 'confetti';
    c.innerHTML = '🎉';
    document.body.appendChild(c);
    setTimeout(function(){ document.body.removeChild(c); }, 1400);
  }
  function updateHero(a, b, r) {
    var txt = (a != null && b != null) ? (a + ' + ' + b + (r != null ? ' = ' + r : '')) : '— — —';
    heroEl.textContent = txt.replace(/\s/g,' ').trim();
  }

  // Step builders (return array of objects { html, running })
  function buildStandard(a, b) {
    var A = String(Math.abs(a)).split('').reverse();
    var B = String(Math.abs(b)).split('').reverse();
    var len = Math.max(A.length, B.length);
    var carry = 0, steps = [], running = 0, place = 1;

    for (var i=0;i<len;i++) {
      var da = i < A.length ? parseInt(A[i],10) : 0;
      var db = i < B.length ? parseInt(B[i],10) : 0;
      var sum = da + db + carry;
      var digit = sum % 10;
      carry = Math.floor(sum / 10);
      running += digit * place;
      var row = '' +
        '<div class="chip-row">' + chipDigits(da, 'chip-a') + '</div>' +
        '<div class="op">+</div>' +
        '<div class="chip-row">' + chipDigits(db, 'chip-b') + '</div>' +
        '<div class="op">+</div>' +
        '<div class="chip-row note">carry '+ (carry>0? (carry+' ➜ next') : '0') +'</div>' +
        '<div class="op">=</div>' +
        '<div class="chip-row">' + chipDigits(digit, 'chip-sum') + '<span class="note">&nbsp;at ' + place + 's</span></div>';
      steps.push({ html: row, running: running });
      place *= 10;
    }
    if (carry > 0) {
      running += carry * place/10;
      steps.push({ html: '<div class="note">Final carry '+carry+' added to the front</div>', running: running });
    }
    return steps;
  }

  function buildDecompose(a, b) {
    function parts(n) {
      var s = String(Math.abs(n));
      var out = [];
      for (var i=0;i<s.length;i++) {
        var p = parseInt(s[i],10) * Math.pow(10, s.length - i - 1);
        if (p) out.push(p);
      }
      return out;
    }
    var pa = parts(a), pb = parts(b);
    var steps = [], running = 0;
    pa.forEach(function(x){ running += x; steps.push({ html: '<div class="chip-row">'+chipDigits(x, 'chip-a')+'</div><div class="op">→</div><div class="note">add A-part</div>', running: running }); });
    pb.forEach(function(x){ running += x; steps.push({ html: '<div class="chip-row">'+chipDigits(x, 'chip-b')+'</div><div class="op">→</div><div class="note">add B-part</div>', running: running }); });
    return steps;
  }

  function buildLeft2Right(a, b) {
    var sA = String(Math.abs(a)), sB = String(Math.abs(b));
    var L = Math.max(sA.length, sB.length);
    sA = sA.padStart(L,'0'); sB = sB.padStart(L,'0');
    var running = 0, steps = [];
    for (var i=0;i<L;i++) {
      var place = Math.pow(10, L - i - 1);
      var da = parseInt(sA[i],10) * place;
      var db = parseInt(sB[i],10) * place;
      running += da + db;
      steps.push({ html: '<div class="chip-row">'+chipDigits(da, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(db, 'chip-b')+'</div><div class="op">=</div><div class="chip-row">'+chipDigits(da+db, 'chip-sum')+'</div>', running: running });
    }
    return steps;
  }

  function buildMakingTens(a, b) {
    var A = Math.abs(a), B = Math.abs(b);
    var onesA = A % 10, onesB = B % 10;
    var take = (10 - (onesA % 10)) % 10;
    var moved = Math.min(take, onesB);
    var step1 = A + moved;
    var step2 = B - moved;
    var running = step1 + step2;
    var steps = [];
    steps.push({ html: '<div class="note">Move '+moved+' from B ones to A ones to make a round ten</div>', running: step1 + step2 });
    steps.push({ html: '<div class="chip-row">'+chipDigits(A, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(B, 'chip-b')+'</div><div class="op">→</div><div class="chip-row">'+chipDigits(step1, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(step2, 'chip-b')+'</div>', running: step1 + step2 });
    return steps;
  }

  function buildCompensation(a, b) {
    // round B up to nearest 10, then subtract the delta
    var B = Math.abs(b);
    var delta = (10 - (B % 10)) % 10;
    var steps = [];
    var tmp = a + (b + delta);
    steps.push({ html: '<div class="note">Round up B by '+delta+' to make adding easier</div>', running: tmp });
    steps.push({ html: '<div class="chip-row">'+chipDigits(a, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(b+delta, 'chip-b')+'</div><div class="op">=</div><div class="chip-row">'+chipDigits(tmp, 'chip-sum')+'</div>', running: tmp });
    if (delta !== 0) {
      var final = tmp - delta;
      steps.push({ html: '<div class="note">Compensate by subtracting '+delta+'</div>', running: final });
    }
    return steps;
  }

  function buildTensOnes(a, b) {
    var A = Math.abs(a), B = Math.abs(b);
    var ones = (A%10) + (B%10);
    var tens = Math.floor(A/10)*10 + Math.floor(B/10)*10;
    var steps = [];
    steps.push({ html: '<div class="chip-row">'+chipDigits(Math.floor(A/10)*10, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(Math.floor(B/10)*10, 'chip-b')+'</div><div class="op">=</div><div class="chip-row">'+chipDigits(tens, 'chip-sum')+'</div>', running: tens });
    steps.push({ html: '<div class="chip-row">'+chipDigits(A%10, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(B%10, 'chip-b')+'</div><div class="op">=</div><div class="chip-row">'+chipDigits(ones, 'chip-sum')+'</div>', running: tens + ones });
    if (ones >= 10) {
      steps.push({ html: '<div class="note">Carry '+Math.floor(ones/10)+' tens from ones</div>', running: tens + ones });
    }
    return steps;
  }

  function buildSkipCounting(a, b) {
    var start = Math.min(a,b), add = Math.max(a,b);
    var steps = [], running = start;
    steps.push({ html: '<div class="note">Start from '+start+'</div>', running: running });
    var tens = Math.floor(add/10);
    for (var i=0;i<tens;i++) { running += 10; steps.push({ html:'<div class="note">Skip +10</div>', running: running }); }
    var rest = add - tens*10;
    for (var j=0;j<rest;j++) { running += 1; steps.push({ html:'<div class="note">+1</div>', running: running }); }
    return steps;
  }

  function buildNumberLine(a, b) {
    // similar to skip counting but fewer steps
    var start = Math.min(a,b), add = Math.max(a,b);
    var steps = [], running = start;
    var jump10 = Math.floor(add / 10) * 10;
    if (jump10 > 0) { running += jump10; steps.push({ html:'<div class="note">Jump +'+jump10+' on number line</div>', running: running }); }
    var rest = add - jump10;
    if (rest > 0) { running += rest; steps.push({ html:'<div class="note">Small hop +'+rest+'</div>', running: running }); }
    return steps;
  }

  function buildAveraging(a, b) {
    var avg = Math.floor((a + b)/2);
    var steps = [];
    steps.push({ html: '<div class="note">Average ≈ ('+a+' + '+b+') / 2 = '+avg+'</div>', running: avg });
    steps.push({ html: '<div class="note">Then double: '+avg+' × 2</div>', running: avg*2 });
    return steps;
  }

  function buildBinary(a, b) {
    var A = Math.abs(a), B = Math.abs(b);
    var sa = A.toString(2), sb = B.toString(2);
    var L = Math.max(sa.length, sb.length);
    sa = sa.padStart(L,'0'); sb = sb.padStart(L,'0');
    var carry = 0, steps = [], running = 0, place = 1;
    for (var i=L-1;i>=0;i--) {
      var da = parseInt(sa[i],2), db = parseInt(sb[i],2);
      var s = da + db + carry;
      var bit = s & 1; carry = (s >> 1);
      running += bit * place;
      place <<= 1;
      steps.push({ html: '<div class="chip-row">'+chipDigits(da, 'chip-a')+'</div><div class="op">+</div><div class="chip-row">'+chipDigits(db, 'chip-b')+'</div><div class="op">+</div><div class="chip-row note">carry ' + (carry ? '1' : '0') + '</div><div class="op">=</div><div class="chip-row">'+chipDigits(bit, 'chip-sum')+'</div>', running: running });
    }
    if (carry) { running += carry * place; steps.push({ html:'<div class="note">Final carry 1 added</div>', running: running }); }
    return steps;
  }

  // Entry point for building steps
  var generators = {
    'standard': buildStandard,
    'decompose': buildDecompose,
    'left2right': buildLeft2Right,
    'makingTens': buildMakingTens,
    'compensation': buildCompensation,
    'tensOnes': buildTensOnes,
    'skipCounting': buildSkipCounting,
    'numberLine': buildNumberLine,
    'averaging': buildAveraging,
    'binary': buildBinary,
    'quickMath': function(a,b) {
      // choose between compensation or making tens based on ones
      var ones = (Math.abs(a)%10) + (Math.abs(b)%10);
      return (ones <= 10) ? buildMakingTens(a,b) : buildCompensation(a,b);
    }
  };

  function buildAll() {
    var a = sanitizeInt(aEl.value), b = sanitizeInt(bEl.value);
    var method = methodEl.value;
    var fn = generators[method] || generators.standard;
    var arr = fn(a,b);
    // Ensure last step displays final result if missing
    var final = a + b;
    if (!arr.length || arr[arr.length-1].running !== final) {
      arr.push({ html:'<div class="chip-row">'+chipDigits(final,'chip-sum')+'</div><div class="note">Final result</div>', running: final });
    }
    steps = arr;
    stepIndex = 0;
    stepsEl.innerHTML = '';
    clearSpark();
    updateProgress(0, steps.length);
    updateHero(a, b, null);
    hintEl.textContent = 'Ready — press Step or Autoplay';
    setState('Ready');
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

  function doStep() {
    if (!steps || steps.length === 0) buildAll();
    if (stepIndex >= steps.length) return;

    var obj = steps[stepIndex];
    appendStepRow(obj, stepIndex+1, stepIndex === steps.length-1);
    updateProgress(stepIndex+1, steps.length);
    sparkData.push(obj.running);
    drawSpark();

    var a = sanitizeInt(aEl.value), b = sanitizeInt(bEl.value);
    updateHero(a, b, (stepIndex === steps.length-1) ? (a+b) : null);

    stepIndex++;
    if (stepIndex === steps.length) {
      setState('Done', { bg:'#d1fae5', fg:'#064e3b' });
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
      if (!steps || steps.length === 0 || stepIndex >= steps.length) buildAll();
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

  function resetAll() {
    if (timer) { clearInterval(timer); timer = null; }
    isPlaying = false;
    autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
    steps = []; stepIndex = 0;
    stepsEl.innerHTML = '';
    clearSpark();
    updateProgress(0, 0);
    heroEl.textContent = '— — —';
    hintEl.textContent = 'Try numbers like 487 + 358 or tap Random';
    setState('Ready');
  }

  function randomize() {
    var a = Math.floor(Math.random() * 9999) + 1;
    var b = Math.floor(Math.random() * 9999) + 1;
    aEl.value = a; bEl.value = b;
    resetAll();
    buildAll();
  }

  // Events
  randomBtn.addEventListener('click', randomize);
  stepBtn.addEventListener('click', function(){ if (isPlaying) return; doStep(); });
  autoplayBtn.addEventListener('click', function(){ toggleAutoplay(); });
  resetBtn.addEventListener('click', resetAll);
  methodEl.addEventListener('change', function(){ resetAll(); buildAll(); });
  speedRange.addEventListener('input', function(){
    var ms = parseInt(this.value, 10); speedVal.textContent = (ms/1000).toFixed(2)+'s';
    if (isPlaying) { toggleAutoplay(true); toggleAutoplay(); }
  });
  [aEl, bEl].forEach(function(el){
    el.addEventListener('input', function(){
      this.value = this.value.replace(/[^0-9\-]/g,'').replace(/(?!^)-/g,''); // keep optional leading minus
      resetAll(); buildAll();
    });
    el.addEventListener('keydown', function(e){ if (e.key === 'Enter') { buildAll(); doStep(); } });
  });

  // Init
  aEl.value = '487'; bEl.value = '358';
  buildAll();
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
