<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>3D Distance Calculator — Space Diagonal</title>
<meta name="description" content="Compute 3D distance between two points (x, y, z). Shows the space diagonal formula and a compact isometric sketch.">
<link rel="canonical" href="https://8gwifi.org/distance-3d.jsp">
<%@ include file="header-script.jsp"%>
<style>
  .d3-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(6, minmax(120px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .cards{ display:grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #isoCanvas{ width:100%; height:220px; display:block; }
  @media (max-width:992px){ .grid{ grid-template-columns: repeat(3,1fr);} }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr 1fr; } }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="d3-container">
  <h1 class="mt-4">3D Distance Calculator</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="x1" class="form-control" placeholder="x1" inputmode="decimal">
    <input id="y1" class="form-control" placeholder="y1" inputmode="decimal">
    <input id="z1" class="form-control" placeholder="z1" inputmode="decimal">
    <input id="x2" class="form-control" placeholder="x2" inputmode="decimal">
    <input id="y2" class="form-control" placeholder="y2" inputmode="decimal">
    <input id="z2" class="form-control" placeholder="z2" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnCalc"><i class="fas fa-calculator"></i> Calculate</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><div class="big">Distance: <span id="od">—</span></div><div class="tiny">d = √[(Δx)² + (Δy)² + (Δz)²]</div></div>
    <div class="cardx"><div class="big">Δx=<span id="dx">—</span>, Δy=<span id="dy">—</span>, Δz=<span id="dz">—</span></div></div>
  </div>

  <div class="panel">
    <h5>Isometric Sketch</h5>
    <canvas id="isoCanvas" height="220"></canvas>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;} function round(n,p){var f=Math.pow(10,p||4);return Math.round(n*f)/f;}
  var X1=el('x1'),Y1=el('y1'),Z1=el('z1'),X2=el('x2'),Y2=el('y2'),Z2=el('z2'); var od=el('od'),dxE=el('dx'),dyE=el('dy'),dzE=el('dz');
  var canvas=el('isoCanvas'),ctx=canvas.getContext('2d');

  function calc(){
    var x1=num(X1.value),y1=num(Y1.value),z1=num(Z1.value),x2=num(X2.value),y2=num(Y2.value),z2=num(Z2.value);
    if(![x1,y1,z1,x2,y2,z2].every(isFinite)) return resetOut();
    var dx=x2-x1,dy=y2-y1,dz=z2-z1; var d=Math.sqrt(dx*dx+dy*dy+dz*dz);
    dxE.textContent=round(dx,6); dyE.textContent=round(dy,6); dzE.textContent=round(dz,6); od.textContent=round(d,6);
    draw(x1,y1,z1,x2,y2,z2);
  }
  function resetOut(){ od.textContent=dxE.textContent=dyE.textContent=dzE.textContent='—'; ctx.clearRect(0,0,canvas.width,canvas.height); }
  function randomize(){ X1.value=0; Y1.value=0; Z1.value=0; X2.value=Math.floor(Math.random()*10+3); Y2.value=Math.floor(Math.random()*10+3); Z2.value=Math.floor(Math.random()*10+3); calc(); }

  function proj(x,y,z){ var s=12; var px= x - y; var py= (x + y)/2 - z; return {x:px*s+140, y:py*s+120}; }

  function draw(x1,y1,z1,x2,y2,z2){
    canvas.width=canvas.clientWidth; canvas.height=220; var W=canvas.width,H=canvas.height;
    ctx.clearRect(0,0,W,H);
    var p1=proj(x1,y1,z1), p2=proj(x2,y2,z2);
    ctx.strokeStyle='#e5e7eb'; ctx.strokeRect(20,20,W-40,H-40);
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(p1.x,p1.y); ctx.lineTo(p2.x,p2.y); ctx.stroke();
    ctx.fillStyle='#ef4444'; ctx.beginPath(); ctx.arc(p1.x,p1.y,4,0,Math.PI*2); ctx.fill();
    ctx.fillStyle='#10b981'; ctx.beginPath(); ctx.arc(p2.x,p2.y,4,0,Math.PI*2); ctx.fill();
  }

  document.getElementById('btnCalc').addEventListener('click', calc);
  document.getElementById('btnReset').addEventListener('click', function(){ [X1,Y1,Z1,X2,Y2,Z2].forEach(function(e){e.value='';}); resetOut(); });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
