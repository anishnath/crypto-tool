<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Heron’s Formula — Triangle Area from 3 Sides</title>
<meta name="description" content="Compute the area of any triangle from the three sides using Heron's formula. Includes semiperimeter and a compact diagram.">
<link rel="canonical" href="https://8gwifi.org/heron-area.jsp">
<%@ include file="header-script.jsp"%>
<style>
  .he-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(3, minmax(160px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .cards{ display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #triCanvas{ width:100%; height:220px; display:block; }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr;} .cards{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="he-container">
  <h1 class="mt-4">Heron’s Formula — Triangle Area</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="a" class="form-control" placeholder="Side a" inputmode="decimal">
    <input id="b" class="form-control" placeholder="Side b" inputmode="decimal">
    <input id="c" class="form-control" placeholder="Side c" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnCalc"><i class="fas fa-calculator"></i> Calculate</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><div class="big">s (semiperimeter): <span id="os">—</span></div></div>
    <div class="cardx"><div class="big">Area: <span id="oA">—</span></div></div>
    <div class="cardx"><div class="big">Perimeter: <span id="oP">—</span></div></div>
  </div>

  <div class="panel">
    <h5>Diagram</h5>
    <canvas id="triCanvas" height="220"></canvas>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;} function round(n,p){var f=Math.pow(10,p||4);return Math.round(n*f)/f;}
  var a=el('a'),b=el('b'),c=el('c'); var os=el('os'),oA=el('oA'),oP=el('oP'); var canvas=el('triCanvas'),ctx=canvas.getContext('2d');

  function calc(){
    var A=num(a.value),B=num(b.value),C=num(c.value); if(!(A>0&&B>0&&C>0)) return resetOut();
    if(A+B<=C||A+C<=B||B+C<=A){ resetOut(); return; }
    var s=(A+B+C)/2; var area=Math.sqrt(Math.max(0,s*(s-A)*(s-B)*(s-C)));
    os.textContent=round(s,6); oA.textContent=round(area,6); oP.textContent=round(A+B+C,6);
    draw(A,B,C);
  }
  function resetOut(){ os.textContent=oA.textContent=oP.textContent='—'; ctx.clearRect(0,0,canvas.width,canvas.height); }
  function randomize(){ a.value=5; b.value=7; c.value=9; calc(); }

  function draw(A,B,C){
    canvas.width=canvas.clientWidth; canvas.height=220; var W=canvas.width,H=canvas.height,p=28;
    ctx.clearRect(0,0,W,H);
    // place base C, compute vertex via Law of Cosines
    var s=(A+B+C)/2;
    var x0=p, y0=H-p, x1=W-p, y1=y0;
    var baseLen = (x1-x0);
    var scale = baseLen / C;
    var x2 = x0 + (B*B + C*C - A*A)/(2*C) * scale;
    var h = Math.sqrt(Math.max(0,B*B - Math.pow((B*B + C*C - A*A)/(2*C),2))) * scale;
    var y2 = y0 - h;
    ctx.beginPath(); ctx.moveTo(x0,y0); ctx.lineTo(x1,y1); ctx.lineTo(x2,y2); ctx.closePath();
    ctx.fillStyle='rgba(245,158,11,.12)'; ctx.fill(); ctx.strokeStyle='#f59e0b'; ctx.lineWidth=2; ctx.stroke();
  }

  document.getElementById('btnCalc').addEventListener('click', calc);
  document.getElementById('btnReset').addEventListener('click', function(){ a.value=b.value=c.value=''; resetOut(); });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
