<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- SEO Meta -->
<title>Pythagorean Theorem Solver — Find a, b, or c + Area (Interactive)</title>
<meta name="description" content="Enter any two sides of a right triangle to solve the third and area. Includes an interactive triangle visualizer, step-by-step formula, and perimeter.">
<meta name="keywords" content="pythagorean theorem calculator, right triangle calculator, pythagoras theorem, find hypotenuse, find leg, triangle area, a^2 + b^2 = c^2">
<link rel="canonical" href="https://8gwifi.org/pythagorean.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Pythagorean Theorem Solver — Right Triangle Calculator">
<meta property="og:description" content="Solve for a, b, or c instantly and see the triangle diagram. Step-by-step a² + b² = c² with area and perimeter.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/pythagorean.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Pythagorean Theorem Solver — Right Triangle Calculator">
<meta name="twitter:description" content="Interactive Pythagoras tool with diagram and formulas.">

<%@ include file="header-script.jsp"%>

<style>
  .py-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.4rem; font-weight: 800; text-align: center;
    padding: 0.7rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #f59e0b; text-shadow: 0 2px 12px rgba(245,158,11,0.45);
    letter-spacing: 0.12rem;
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

  .input-pane { display:grid; grid-template-columns: repeat(3, minmax(160px, 1fr)); gap: .5rem; }
  .cards { display:grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin-top: .75rem; }
  .cardx {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px;
  }
  .cardx h6 { margin: 0 0 6px 0; font-weight: 700; color: #374151; }
  .big { font-size: 1.3rem; font-weight: 800; color: #111827; }

  .panel {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px;
    margin-top: 12px;
  }
  .panel h5 { margin: 0 0 8px 0; color:#374151; }

  .math-block {
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    background: #f9fafb;
    border: 1px dashed #e5e7eb;
    padding: 10px 12px;
    border-radius: 8px;
    color: #111827;
    margin-top: 8px;
    line-height: 1.4;
  }

  /* Canvas */
  #triCanvas { width: 100%; height: 220px; display: block; }

  @media (max-width: 992px) { .cards{ grid-template-columns: repeat(2, 1fr); } .input-pane{ grid-template-columns: 1fr 1fr 1fr; } }
  @media (max-width: 576px){ .hero-number{ font-size:2rem; letter-spacing:0.08rem; } .input-pane{ grid-template-columns: 1fr; } }
</style>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Pythagorean Theorem Solver — Right Triangle Calculator",
  "url":"https://8gwifi.org/pythagorean.jsp",
  "description":"Solve a, b, or c of a right triangle with area and perimeter. Interactive diagram and formula breakdown a² + b² = c².",
  "keywords":"pythagorean theorem calculator, right triangle calculator, pythagoras calculator, triangle area"
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="py-container">
  <h1 class="mt-4">Pythagorean Theorem Solver</h1>
  <p class="tiny">Enter any two sides of a right triangle. Leave one blank, and we'll solve it using <span class="pill pill-green">a² + b² = c²</span>. Includes area and perimeter.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">—</div>
  <div class="hero-sub" id="heroHint">Fill two inputs (a, b, c). Try Random for fun triples!</div>

  <div class="input-pane">
    <div>
      <label for="sideA" class="tiny">Leg a</label>
      <input class="form-control" id="sideA" type="text" inputmode="decimal" placeholder="e.g., 3">
    </div>
    <div>
      <label for="sideB" class="tiny">Leg b</label>
      <input class="form-control" id="sideB" type="text" inputmode="decimal" placeholder="e.g., 4">
    </div>
    <div>
      <label for="sideC" class="tiny">Hypotenuse c</label>
      <input class="form-control" id="sideC" type="text" inputmode="decimal" placeholder="e.g., 5">
    </div>
  </div>

  <div class="controls">
    <button type="button" class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button type="button" class="btn btn-success" id="btnSolve"><i class="fas fa-calculator"></i> Solve</button>
    <button type="button" class="btn btn-outline-primary" id="btnSwap"><i class="fas fa-right-left"></i> Swap Legs</button>
    <button type="button" class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
    <div class="ml-auto tiny">Units are generic; results scale linearly.</div>
  </div>

  <div class="cards">
    <div class="cardx">
      <h6>Sides (a, b, c)</h6>
      <div class="big"><span id="outA">—</span>, <span id="outB">—</span>, <span id="outC">—</span></div>
      <div class="tiny" id="validMsg">Right triangle check: —</div>
    </div>
    <div class="cardx">
      <h6>Area</h6>
      <div class="big" id="outArea">—</div>
      <div class="tiny">A = (1/2)·a·b</div>
    </div>
    <div class="cardx">
      <h6>Perimeter</h6>
      <div class="big" id="outPerim">—</div>
      <div class="tiny">P = a + b + c</div>
    </div>
    <div class="cardx">
      <h6>Angles</h6>
      <div class="big"><span id="outAngleA">—</span>°, <span id="outAngleB">—</span>°, 90°</div>
      <div class="tiny">∠A opposite a, ∠B opposite b</div>
    </div>
  </div>

  <div class="panel">
    <h5>Right Triangle Visualizer</h5>
    <canvas id="triCanvas" height="220"></canvas>
    <div class="tiny">Drag sliders below or edit inputs above to change dimensions.</div>
    <div class="controls" style="margin-top:.5rem;">
      <label class="tiny">Scale:</label>
      <input id="scaleRange" type="range" min="0.5" max="3" step="0.1" value="1" style="max-width:200px;">
      <span class="tiny" id="scaleVal">1.0×</span>
    </div>
  </div>

  <div class="panel">
    <h5>Calculations & Formula</h5>
    <div id="formulaMain" class="math-block"></div>
    <div id="formulaArea" class="math-block"></div>
    <div id="formulaAngles" class="math-block"></div>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  var aEl = document.getElementById('sideA');
  var bEl = document.getElementById('sideB');
  var cEl = document.getElementById('sideC');

  var solveBtn = document.getElementById('btnSolve');
  var randomBtn = document.getElementById('btnRandom');
  var swapBtn = document.getElementById('btnSwap');
  var resetBtn = document.getElementById('btnReset');

  var outA = document.getElementById('outA');
  var outB = document.getElementById('outB');
  var outC = document.getElementById('outC');
  var outArea = document.getElementById('outArea');
  var outPerim = document.getElementById('outPerim');
  var outAngleA = document.getElementById('outAngleA');
  var outAngleB = document.getElementById('outAngleB');
  var validMsg = document.getElementById('validMsg');

  var heroEl = document.getElementById('heroNumber');
  var hintEl = document.getElementById('heroHint');

  var fMain = document.getElementById('formulaMain');
  var fArea = document.getElementById('formulaArea');
  var fAngles = document.getElementById('formulaAngles');

  var canvas = document.getElementById('triCanvas');
  var ctx = canvas.getContext('2d');
  var scaleRange = document.getElementById('scaleRange');
  var scaleVal = document.getElementById('scaleVal');

  function toNum(v) {
    var n = parseFloat(String(v).replace(/[^0-9.\\-]/g, ''));
    return isFinite(n) ? n : NaN;
  }
  function round(n, p){ var f = Math.pow(10, p || 4); return Math.round(n * f) / f; }
  function deg(x){ return x * 180 / Math.PI; }

  function randomTriple() {
    // pick two small integers and compute hypotenuse if perfect, else random ints
    var triples = [[3,4,5],[5,12,13],[6,8,10],[7,24,25],[8,15,17]];
    var t = triples[Math.floor(Math.random()*triples.length)];
    aEl.value = t[0]; bEl.value = t[1]; cEl.value = '';
  }

  function swapLegs() {
    var t = aEl.value; aEl.value = bEl.value; bEl.value = t;
    analyze();
  }

  function resetAll() {
    aEl.value = ''; bEl.value = ''; cEl.value = '';
    outA.textContent = '—'; outB.textContent = '—'; outC.textContent = '—';
    outArea.textContent = '—'; outPerim.textContent = '—';
    outAngleA.textContent = '—'; outAngleB.textContent = '—';
    validMsg.textContent = 'Right triangle check: —';
    heroEl.textContent = '—';
    fMain.innerHTML = ''; fArea.innerHTML = ''; fAngles.innerHTML = '';
    draw(0,0,0);
  }

  function analyze() {
    var a = toNum(aEl.value);
    var b = toNum(bEl.value);
    var c = toNum(cEl.value);

    var known = 0;
    if (isFinite(a)) known++; if (isFinite(b)) known++; if (isFinite(c)) known++;

    if (known < 2) {
      heroEl.textContent = '—';
      validMsg.textContent = 'Right triangle check: need any two sides';
      draw(isFinite(a)?a:0, isFinite(b)?b:0, isFinite(c)?c:0);
      return;
    }

    // Solve missing
    if (!isFinite(c)) {
      if (!(isFinite(a) && isFinite(b)) || a <= 0 || b <= 0) {
        validMsg.textContent = 'Provide positive a and b';
        return;
      }
      c = Math.sqrt(a*a + b*b);
      cEl.value = round(c,6);
    } else if (!isFinite(a)) {
      if (!(isFinite(b) && isFinite(c)) || b <= 0 || c <= 0 || c <= b) {
        validMsg.textContent = 'Need c > b > 0';
        return;
      }
      var t = c*c - b*b; if (t < 0) { validMsg.textContent = 'Invalid: c² < b²'; return; }
      a = Math.sqrt(t);
      aEl.value = round(a,6);
    } else if (!isFinite(b)) {
      if (!(isFinite(a) && isFinite(c)) || a <= 0 || c <= 0 || c <= a) {
        validMsg.textContent = 'Need c > a > 0';
        return;
      }
      var t2 = c*c - a*a; if (t2 < 0) { validMsg.textContent = 'Invalid: c² < a²'; return; }
      b = Math.sqrt(t2);
      bEl.value = round(b,6);
    } else {
      // All three given: validate
      var lhs = round(a*a + b*b, 6);
      var rhs = round(c*c, 6);
      if (Math.abs(lhs - rhs) > 1e-6) {
        validMsg.textContent = 'Not right triangle: a² + b² ≠ c²';
      }
    }

    // Compute derived
    var area = 0.5 * a * b;
    var perim = a + b + c;
    var A = deg(Math.atan2(a, b));  // angle at vertex with sides b and c (opposite a)
    var B = deg(Math.atan2(b, a));  // angle opposite b

    outA.textContent = String(round(a,6));
    outB.textContent = String(round(b,6));
    outC.textContent = String(round(c,6));
    outArea.textContent = String(round(area,6));
    outPerim.textContent = String(round(perim,6));
    outAngleA.textContent = String(round(A,3));
    outAngleB.textContent = String(round(B,3));
    validMsg.textContent = 'Right triangle check: a² + b² = c² ✓';

    heroEl.textContent = 'c = ' + round(c,6);

    // Formulas
    fMain.innerHTML = '<strong>Pythagorean Theorem</strong>: a² + b² = c² → ' +
                      round(a,6) + '² + ' + round(b,6) + '² = ' + round(c,6) + '² → ' +
                      round(a*a,6) + ' + ' + round(b*b,6) + ' = ' + round(c*c,6);
    fArea.innerHTML = '<strong>Area</strong>: A = (1/2)·a·b = 0.5 × ' + round(a,6) + ' × ' + round(b,6) +
                      ' = <strong>' + round(area,6) + '</strong>';
    fAngles.innerHTML = '<strong>Angles</strong>: ∠A = arctan(a/b) = ' + round(A,3) + '°, ' +
                        '∠B = arctan(b/a) = ' + round(B,3) + '°, right angle = 90°';

    draw(a,b,c);
  }

  function draw(a,b,c) {
    // Resize canvas to CSS width
    canvas.width = canvas.clientWidth;
    canvas.height = 220;
    var W = canvas.width, H = canvas.height;
    ctx.clearRect(0,0,W,H);

    if (!(a>0 && b>0 && c>0)) return;

    // Scale to fit within padding, respect scale slider
    var pad = 32;
    var s = Math.min((W - 2*pad) / b, (H - 2*pad) / a);
    s *= parseFloat(scaleRange.value || '1');
    scaleVal.textContent = parseFloat(scaleRange.value || '1').toFixed(1) + '×';

    var base = b * s;
    var height = a * s;

    var x0 = pad, y0 = H - pad;          // origin (left-bottom)
    var x1 = x0 + base, y1 = y0;         // base end
    var x2 = x0, y2 = y0 - height;       // vertical end

    // Triangle fill
    ctx.beginPath();
    ctx.moveTo(x0,y0); ctx.lineTo(x1,y1); ctx.lineTo(x2,y2); ctx.closePath();
    ctx.fillStyle = 'rgba(59,130,246,0.12)'; ctx.fill();
    ctx.lineWidth = 2; ctx.strokeStyle = '#3b82f6'; ctx.stroke();

    // Right angle square
    var ra = Math.min(18, Math.min(base, height) * 0.2);
    ctx.beginPath();
    ctx.moveTo(x0,y0);
    ctx.lineTo(x0+ra, y0);
    ctx.lineTo(x0+ra, y0-ra);
    ctx.lineTo(x0, y0-ra);
    ctx.closePath();
    ctx.fillStyle = 'rgba(16,185,129,0.15)'; ctx.fill();
    ctx.strokeStyle = '#10b981'; ctx.stroke();

    // Labels
    ctx.fillStyle = '#111827';
    ctx.font = '12px system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial';
    // c label near hypotenuse midpoint
    ctx.fillText('c = ' + round(c,3), x0 + base*0.5 - 10, y0 - height*0.5 - 6);
    // a label
    ctx.fillText('a = ' + round(a,3), x2 + 6, y2 + (height>40? height/2 : -6));
    // b label
    ctx.fillText('b = ' + round(b,3), x0 + base/2 - 10, y0 + 14);
  }

  function attachLive(el){ el.addEventListener('input', function(){ analyze(); }); }

  // Events
  solveBtn.addEventListener('click', analyze);
  randomBtn.addEventListener('click', function(){ randomTriple(); analyze(); });
  swapBtn.addEventListener('click', swapLegs);
  resetBtn.addEventListener('click', resetAll);
  scaleRange.addEventListener('input', function(){ analyze(); });

  [aEl,bEl,cEl].forEach(attachLive);
  window.addEventListener('resize', analyze);

  // init
  randomTriple();
  analyze();
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
