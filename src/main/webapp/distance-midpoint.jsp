<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Distance & Midpoint Calculator — 2D Points</title>
<meta name="description" content="Compute distance, midpoint, slope, and line equation from two points. Includes a compact XY diagram.">
<link rel="canonical" href="https://8gwifi.org/distance-midpoint.jsp">
<%@ include file="header-script.jsp"%>
<style>
  .dm-container{ margin-top:1rem; }
  .tiny{ font-size:.85rem; color:#6b7280; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .grid{ display:grid; grid-template-columns: repeat(4, minmax(140px,1fr)); gap:.5rem; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  .cards{ display:grid; grid-template-columns: repeat(4, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  #lineCanvas{ width:100%; height:220px; display:block; }
  @media (max-width:992px){ .grid{ grid-template-columns: repeat(2,1fr);} .cards{ grid-template-columns: repeat(2,1fr);} }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr;} .cards{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="dm-container">
  <h1 class="mt-4">Distance & Midpoint Calculator</h1>
  <p class="tiny">Enter coordinates of two points (x1, y1) and (x2, y2). We’ll compute distance, midpoint, slope, and line equation.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="x1" class="form-control" placeholder="x1" inputmode="decimal">
    <input id="y1" class="form-control" placeholder="y1" inputmode="decimal">
    <input id="x2" class="form-control" placeholder="x2" inputmode="decimal">
    <input id="y2" class="form-control" placeholder="y2" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnCalc"><i class="fas fa-calculator"></i> Calculate</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><div class="big">Distance: <span id="od">—</span></div><div class="tiny">d = √[(x2−x1)² + (y2−y1)²]</div></div>
    <div class="cardx"><div class="big">Midpoint: <span id="om">—</span></div><div class="tiny">M = ((x1+x2)/2, (y1+y2)/2)</div></div>
    <div class="cardx"><div class="big">Slope: <span id="ok">—</span></div><div class="tiny">m = (y2−y1)/(x2−x1)</div></div>
    <div class="cardx"><div class="big">Line: <span id="oline">—</span></div><div class="tiny">y = mx + b</div></div>
  </div>

  <div class="panel">
    <h5>Diagram</h5>
    <canvas id="lineCanvas" height="220"></canvas>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;}
  var x1=el('x1'),y1=el('y1'),x2=el('x2'),y2=el('y2');
  var od=el('od'),om=el('om'),ok=el('ok'),oline=el('oline');
  var canvas=el('lineCanvas'),ctx=canvas.getContext('2d');

  function calc(){
    var X1=num(x1.value),Y1=num(y1.value),X2=num(x2.value),Y2=num(y2.value);
    if(![X1,Y1,X2,Y2].every(isFinite)){ resetOut(); return; }
    var dx=X2-X1, dy=Y2-Y1;
    var d=Math.sqrt(dx*dx+dy*dy), m=dx!==0?dy/dx:Infinity;
    var b=(m!==Infinity)?(Y1 - m*X1):NaN;
    od.textContent=round(d,6); om.textContent='('+round((X1+X2)/2,6)+', '+round((Y1+Y2)/2,6)+')';
    ok.textContent=(m===Infinity?'∞':round(m,6));
    oline.textContent=(m===Infinity)?('x = '+round(X1,6)) : ('y = '+round(m,6)+'x + '+round(b,6));
    draw(X1,Y1,X2,Y2);
  }
  function round(n,p){var f=Math.pow(10,p||4);return Math.round(n*f)/f;}
  function resetOut(){ od.textContent=om.textContent=ok.textContent=oline.textContent='—'; ctx.clearRect(0,0,canvas.width,canvas.height); }
  function randomize(){ x1.value=Math.floor(Math.random()*20-10); y1.value=Math.floor(Math.random()*20-10); x2.value=Math.floor(Math.random()*20-10); y2.value=Math.floor(Math.random()*20-10); calc(); }

  function draw(X1,Y1,X2,Y2){
    canvas.width=canvas.clientWidth; canvas.height=220; var W=canvas.width,H=canvas.height;
    ctx.clearRect(0,0,W,H);
    var p=30, sx=(W-2*p)/20, sy=(H-2*p)/20;
    function mapX(x){return p+(x+10)*sx;} function mapY(y){return H-p-(y+10)*sy;}
    // Axes
    ctx.strokeStyle='#e5e7eb'; ctx.lineWidth=1;
    ctx.beginPath(); ctx.moveTo(p,mapY(0)); ctx.lineTo(W-p,mapY(0)); ctx.moveTo(mapX(0),p); ctx.lineTo(mapX(0),H-p); ctx.stroke();
    // Segment
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2;
    ctx.beginPath(); ctx.moveTo(mapX(X1),mapY(Y1)); ctx.lineTo(mapX(X2),mapY(Y2)); ctx.stroke();
    // Points
    ctx.fillStyle='#ef4444'; ctx.beginPath(); ctx.arc(mapX(X1),mapY(Y1),4,0,Math.PI*2); ctx.fill();
    ctx.fillStyle='#10b981'; ctx.beginPath(); ctx.arc(mapX(X2),mapY(Y2),4,0,Math.PI*2); ctx.fill();
  }

  document.getElementById('btnCalc').addEventListener('click', calc);
  document.getElementById('btnReset').addEventListener('click', function(){ x1.value=y1.value=x2.value=y2.value=''; resetOut(); });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
