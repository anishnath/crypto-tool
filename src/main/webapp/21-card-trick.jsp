<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- SEO Meta -->
<title>21 Card Trick — Interactive Magic Demo (Autoplay + Steps)</title>
<meta name="description" content="Perform the classic 21 Card Trick interactively. Deal 3 columns, pick the column with your card, repeat 3 times, and watch the magic reveal! Autoplay or step-by-step with beautiful visuals.">
<meta name="keywords" content="21 card trick, card magic, math magic, interactive card trick, autoplay, step-by-step, YouTube short, column card trick, reveal card">
<link rel="canonical" href="https://8gwifi.org/21-card-trick.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="21 Card Trick — Interactive Magic Demo">
<meta property="og:description" content="Deal 3 columns, pick your column, repeat, and the card is revealed! Try autoplay or step-by-step with engaging visuals.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/21-card-trick.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="21 Card Trick — Interactive Magic Demo">
<meta name="twitter:description" content="A beautiful, interactive way to experience the 21 Card Trick.">

<%@ include file="header-script.jsp"%>

<style>
  .kap-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.6rem; font-weight: 800; text-align: center;
    padding: 0.75rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #f472b6; text-shadow: 0 2px 12px rgba(236,72,153,0.45);
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
  .gap-2{ gap:.5rem; }

  /* Deck + columns */
  .board {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    margin-top: 1rem;
  }
  .col {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px;
    display: flex; flex-direction: column; align-items: center;
  }
  .col-title { font-weight: 700; color: #374151; margin-bottom: 6px; }
  .stack {
    display: grid; grid-template-columns: 1fr; gap: 8px; width: 100%;
    min-height: 7rem;
  }

  /* Card visuals */
  .cardx {
    background: #fff; border: 2px solid #e5e7eb; border-radius: 10px;
    padding: 6px 10px; text-align: center; font-weight: 800;
    color: #111827;
    box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
    user-select: none;
    cursor: pointer;
  }
  .cardx:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.08); }
  .cardx.selected { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16,185,129,0.2); }
  .cardx.dim { opacity: 0.55; }

  .choose-btn { margin-top: 8px; }

  /* Progress + sparkline */
  .kap-subrow{ display:flex; gap:1rem; align-items:center; justify-content:space-between; margin-top:0.5rem; }
  .kap-progress{ position:relative; height:10px; background:#e5e7eb; border-radius:999px; overflow:hidden; flex:1; min-width:160px; }
  .kap-progress > div{ height:100%; width:0%; background:linear-gradient(90deg, #60a5fa, #10b981); transition: width 300ms ease-in-out; }
  .kap-progress > span{ position:absolute; top:-22px; right:0; font-size:0.8rem; color:#6b7280; }
  .spark { background:#ffffff; border:1px solid #e5e7eb; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.04); }

  /* Confetti */
  .confetti{ position:fixed; left:50%; top:15%; transform:translateX(-50%); z-index:1000; pointer-events:none; font-size:1.75rem; opacity:0; animation:pop 1.2s ease-out forwards;}
  @keyframes pop{0%{opacity:0; transform:translate(-50%,-10px) scale(0.9);} 25%{opacity:1; transform:translate(-50%,0) scale(1.1);} 100%{opacity:0; transform:translate(-50%,10px) scale(0.9);} }

  @media (max-width: 576px) {
    .hero-number{ font-size:2.2rem; letter-spacing:0.25rem;}
    .board { grid-template-columns: 1fr; }
  }
</style>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"21 Card Trick — Interactive Magic Demo",
  "url":"https://8gwifi.org/21-card-trick.jsp",
  "description":"Experience the classic 21 Card Trick with autoplay and step-by-step modes. Deal three columns, pick your column, and watch the reveal.",
  "keywords":"21 card trick, card magic, math magic, interactive card trick, column trick, reveal card, autoplay, step by step"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="kap-container">
  <h1 class="mt-4">21 Card Trick — Pick a Column, Watch the Magic</h1>
  <p class="tiny">Think of one card. Tell which column it's in — three times. Your card is revealed in the middle! Perfect for quick demos and Shorts.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">— — —</div>
  <div class="hero-sub" id="heroHint">Click a card to secretly select it, or use “Secret Pick”. Then Step or Autoplay.</div>

  <div class="controls">
    <button type="button" class="btn btn-secondary" id="btnRandomDeck"><i class="fas fa-shuffle"></i> Random Deck</button>
    <button type="button" class="btn btn-outline-secondary" id="btnSecretPick"><i class="fas fa-user-secret"></i> Secret Pick</button>

    <button type="button" class="btn btn-success" id="btnAutoplay"><i class="fas fa-play"></i> Autoplay</button>
    <button type="button" class="btn btn-primary" id="btnStep"><i class="fas fa-forward-step"></i> Step</button>
    <button type="button" class="btn btn-outline-danger" id="btnReset"><i class="fas fa-rotate-left"></i> Reset</button>

    <span class="tiny">&nbsp;Speed:</span>
    <input id="speedRange" type="range" min="250" max="1600" value="900" step="50" title="Autoplay speed (ms)">
    <span class="tiny" id="speedVal">0.90s</span>
  </div>

  <div class="flex justify-between align-center">
    <div class="tiny"><i class="fas fa-lightbulb"></i> Hint: After each deal, click the button under the column containing your card.</div>
    <div class="pill pill-gray" id="runState">Ready</div>
  </div>

  <div class="kap-subrow">
    <div class="kap-progress" aria-label="Rounds progress">
      <div id="kapProgressInner"></div>
      <span id="kapProgressLabel">0/3</span>
    </div>
    <canvas id="kapSpark" class="spark" width="280" height="40" aria-label="Position trend sparkline"></canvas>
  </div>

  <div class="board" id="board">
    <!-- 3 columns -->
  </div>

  <div class="card my-4" id="how-it-works">
    <h5 class="card-header">How the 21 Card Trick Works</h5>
    <div class="card-body">
      <p>The classic 21 Card Trick is a beautiful blend of showmanship and math. Here’s the flow you’re seeing on this page:</p>
      <ol>
        <li>We deal 21 cards face up into three columns, one-by-one, left to right.</li>
        <li>You identify which column contains your card (without revealing the exact card).</li>
        <li>We gather the cards placing your chosen column in the middle of the stack.</li>
        <li>We repeat the deal → choose column → gather sequence a total of three times.</li>
        <li>After the third time, your card inevitably ends up right in the middle of the stack and is revealed.</li>
      </ol>
      <p><strong>Why it works (intuitive version):</strong> Each time we collect the piles with your pile in the middle, the position of your card is “pulled” toward the center. Re-dealing into three columns and repeating this middle-collection process steadily funnels your card to the exact middle position. After three rounds, it lands at the 11th card every time.</p>
      <p class="mb-1"><strong>Tips for performing:</strong></p>
      <ul>
        <li>Keep a steady rhythm when dealing; it looks cleaner and feels more “magical.”</li>
        <li>Engage the audience by asking them to point to a column, not the specific card.</li>
        <li>For dramatic effect, pause briefly before the final reveal.</li>
      </ul>
      <p class="mb-1"><strong>FAQs</strong></p>
      <ul>
        <li><em>Does the exact card matter?</em> No. Any of the 21 cards will be revealed after three rounds.</li>
        <li><em>What if I make a mistake choosing the column?</em> The method relies on the correct column being placed in the middle each round. If an error happens, just restart with a new deal.</li>
        <li><em>Is this sleight of hand?</em> It’s mainly a positional math principle, not sleight of hand.</li>
      </ul>
      <p class="tiny mb-0">Privacy note: This is an on-page demo. Your selections stay in your browser.</p>
    </div>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  // DOM
  var boardEl = document.getElementById('board');
  var randomDeckBtn = document.getElementById('btnRandomDeck');
  var secretPickBtn = document.getElementById('btnSecretPick');
  var autoplayBtn = document.getElementById('btnAutoplay');
  var stepBtn = document.getElementById('btnStep');
  var resetBtn = document.getElementById('btnReset');
  var speedRange = document.getElementById('speedRange');
  var speedVal = document.getElementById('speedVal');
  var runState = document.getElementById('runState');
  var heroEl = document.getElementById('heroNumber');
  var hintEl = document.getElementById('heroHint');

  var progressInner = document.getElementById('kapProgressInner');
  var progressLabel = document.getElementById('kapProgressLabel');
  var sparkCanvas = document.getElementById('kapSpark');
  var sparkCtx = sparkCanvas ? sparkCanvas.getContext('2d') : null;
  var sparkData = [];

  // State
  var fullDeck = [];
  var deck21 = [];       // flat array of 21 labels
  var cols = [[],[],[]]; // current columns
  var selectedLabel = null; // secret or clicked card label
  var rounds = 0;
  var timer = null;
  var isPlaying = false;

  // Utils
  function setState(text, color) {
    runState.textContent = text;
    runState.style.background = color && color.bg ? color.bg : '';
    runState.style.color = color && color.fg ? color.fg : '';
  }
  function celebrate() {
    var c = document.createElement('div');
    c.className = 'confetti';
    c.innerHTML = '🎉';
    document.body.appendChild(c);
    setTimeout(function(){ document.body.removeChild(c); }, 1400);
  }
  function updateProgress(r) {
    var pct = Math.min(100, (r / 3) * 100);
    progressInner.style.width = pct + '%';
    progressLabel.textContent = r + '/3';
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
    var maxVal = Math.max.apply(null, sparkData.concat(1));
    for (var i=0;i<sparkData.length;i++) {
      var x = (w / Math.max(1, sparkData.length - 1)) * i;
      var y = h - (sparkData[i] / maxVal) * h;
      if (i===0) sparkCtx.moveTo(x,y); else sparkCtx.lineTo(x,y);
    }
    sparkCtx.stroke();
    var lastX = (w / Math.max(1, sparkData.length - 1)) * (sparkData.length - 1);
    var lastY = h - (sparkData[sparkData.length - 1] / Math.max.apply(null, sparkData.concat(1))) * h;
    sparkCtx.fillStyle = '#059669';
    sparkCtx.beginPath(); sparkCtx.arc(lastX, lastY, 3, 0, Math.PI*2); sparkCtx.fill();
  }
  function posOf(label) {
    return deck21.indexOf(label); // 0-based
  }
  function updateHero(text) {
    heroEl.textContent = text;
  }

  // Deck generation
  function buildFullDeck() {
    var ranks = ['A','2','3','4','5','6','7','8','9','10','J','Q','K'];
    var suits = ['♠','♥','♦','♣'];
    var out = [];
    for (var s=0;s<suits.length;s++) for (var r=0;r<ranks.length;r++) out.push(ranks[r]+suits[s]);
    return out;
  }
  function shuffle(arr) {
    for (var i=arr.length-1;i>0;i--) {
      var j = Math.floor(Math.random()*(i+1));
      var t = arr[i]; arr[i]=arr[j]; arr[j]=t;
    }
    return arr;
  }
  function randomizeDeck21() {
    fullDeck = buildFullDeck();
    shuffle(fullDeck);
    deck21 = fullDeck.slice(0,21);
    selectedLabel = null;
    rounds = 0;
    updateProgress(0);
    clearSpark();
    deal();
    render();
    setState('Ready');
    hintEl.textContent = 'Select a card or use Secret Pick, then Step/Autoplay';
    updateHero('— — —');
  }

  // Deal and collect
  function deal() {
    cols = [[],[],[]];
    for (var i=0;i<deck21.length;i++) {
      cols[i % 3].push(deck21[i]);
    }
  }
  function collect(chosenIdx) {
    // Place chosen column in the middle of the stack
    var order = (chosenIdx === 0) ? [1,0,2] : (chosenIdx === 1 ? [0,1,2] : [0,2,1]);
    var stack = [];
    for (var k=0;k<order.length;k++) stack = stack.concat(cols[order[k]]);
    deck21 = stack;
  }

  // Rendering
  function render() {
    boardEl.innerHTML = '';
    for (var c=0;c<3;c++) {
      var colEl = document.createElement('div');
      colEl.className = 'col';
      var title = document.createElement('div');
      title.className = 'col-title';
      title.textContent = 'Column ' + (c+1);
      var stackEl = document.createElement('div');
      stackEl.className = 'stack';

      for (var i=0;i<cols[c].length;i++) {
        var lbl = cols[c][i];
        var card = document.createElement('div');
        card.className = 'cardx' + (selectedLabel === lbl ? ' selected' : '');
        card.textContent = lbl;
        card.dataset.label = lbl;
        card.addEventListener('click', function(ev){
          // User can click to secretly choose their card
          selectedLabel = this.dataset.label;
          updateHero('Picked: ' + selectedLabel);
          // dim others slightly
          var all = boardEl.querySelectorAll('.cardx');
          all.forEach(function(x){
            x.classList.toggle('dim', x.dataset.label !== selectedLabel);
            x.classList.toggle('selected', x.dataset.label === selectedLabel);
          });
        });
        stackEl.appendChild(card);
      }

      var choose = document.createElement('button');
      choose.className = 'btn btn-outline-primary btn-sm choose-btn';
      choose.textContent = 'This Column';
      choose.addEventListener('click', (function(idx){ return function(){
        stepWithColumn(idx);
      };})(c));

      colEl.appendChild(title);
      colEl.appendChild(stackEl);
      colEl.appendChild(choose);
      boardEl.appendChild(colEl);
    }

    // Update sparkline with current position of selected (if any)
    if (selectedLabel) {
      var p = posOf(selectedLabel);
      if (p >= 0) { sparkData.push(p+1); drawSpark(); }
    }
  }

  function stepWithColumn(colIdx) {
    if (rounds >= 3) return;
    collect(colIdx);
    deal();
    rounds++;
    updateProgress(rounds);
    setState('Round ' + rounds);
    render();
    if (rounds === 3) reveal();
  }

  function reveal() {
    // After 3 rounds, the chosen card is at position 11 (0-based 10)
    var predictIdx = 10;
    var predict = deck21[predictIdx];
    updateHero('Reveal: ' + predict);
    setState('Revealed!', { bg:'#d1fae5', fg:'#064e3b' });
    celebrate();
    // highlight the revealed card
    var all = boardEl.querySelectorAll('.cardx');
    all.forEach(function(x){ x.classList.remove('dim','selected'); if (x.textContent !== predict) x.classList.add('dim'); else x.classList.add('selected'); });
  }

  // Step logic + autoplay
  function doStep() {
    if (rounds >= 3) return;
    // Determine which column contains the selected card
    var colIdx = null;
    if (selectedLabel) {
      for (var c=0;c<3;c++) {
        if (cols[c].indexOf(selectedLabel) !== -1) { colIdx = c; break; }
      }
    }
    if (colIdx == null) {
      setState('Pick a column containing your card', { bg:'#fef3c7', fg:'#78350f' });
      return;
    }
    stepWithColumn(colIdx);
  }

  function toggleAutoplay(forceOff) {
    if (forceOff === true) {
      if (timer) clearInterval(timer);
      isPlaying = false;
      autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
      return;
    }
    if (!isPlaying) {
      if (!selectedLabel) {
        // If no selection, pick a secret one
        selectedLabel = deck21[Math.floor(Math.random()*deck21.length)];
        updateHero('Secret card chosen');
      }
      var delay = parseInt(speedRange.value, 10) || 900;
      timer = setInterval(function(){
        doStep();
        if (rounds >= 3) {
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
      setState('Paused', { bg:'#e5e7eb', fg:'#374151' });
    }
  }

  function resetAll() {
    if (timer) { clearInterval(timer); timer = null; }
    isPlaying = false;
    autoplayBtn.innerHTML = '<i class="fas fa-play"></i> Autoplay';
    selectedLabel = null;
    rounds = 0;
    updateProgress(0);
    clearSpark();
    // re-render current columns to clear highlights
    render();
    setState('Ready');
    updateHero('— — —');
    hintEl.textContent = 'Select a card or use Secret Pick, then Step/Autoplay';
  }

  // Events
  randomDeckBtn.addEventListener('click', function(){ randomizeDeck21(); });
  secretPickBtn.addEventListener('click', function(){
    selectedLabel = deck21[Math.floor(Math.random()*deck21.length)];
    updateHero('Secret card chosen');
    // Do not reveal which; keep normal render
  });
  stepBtn.addEventListener('click', function(){ if (isPlaying) return; doStep(); });
  autoplayBtn.addEventListener('click', function(){ toggleAutoplay(); });
  resetBtn.addEventListener('click', resetAll);
  speedRange.addEventListener('input', function(){
    var ms = parseInt(this.value, 10); speedVal.textContent = (ms/1000).toFixed(2)+'s';
    if (isPlaying) { toggleAutoplay(true); toggleAutoplay(); }
  });

  // Init
  randomizeDeck21();
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
