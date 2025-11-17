<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Circle & Sector Calculator — Radius, Circumference, Arc, Sector Area</title>
<meta name="description" content="Enter radius or diameter and angle (deg/rad) to compute circumference, area, arc length, and sector area. Includes a clean arc diagram.">
<link rel="canonical" href="https://8gwifi.org/circle-sector.jsp">
<%@ include file="header-script.jsp"%>
<style>
  .cs-container{ margin-top:1rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .grid{ display:grid; grid-template-columns: repeat(4, minmax(160px,1fr)); gap:.5rem; }
  .cards{ display:grid; grid-template-columns: repeat(4, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #circleCanvas{ width:100%; height:240px; display:block; }
  @media (max-width:992px){ .grid{ grid-template-columns: repeat(2,1fr);} .cards{ grid-template-columns: repeat(2,1fr);} }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr;} .cards{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="cs-container">
  <h1 class="mt-4">Circle & Sector Calculator</h1>

  <%@ include file="footer_adsense.jsp"%>


  <div class="grid">
    <input id="radius" class="form-control" placeholder="Radius r" inputmode="decimal">
    <input id="diam" class="form-control" placeholder="Diameter d" inputmode="decimal">
    <input id="angleDeg" class="form-control" placeholder="Angle θ (deg)" inputmode="decimal">
    <input id="angleRad" class="form-control" placeholder="Angle θ (rad)" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnCalc"><i class="fas fa-calculator"></i> Calculate</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><div class="big">Circumference: <span id="oC">—</span></div><div class="tiny">C = 2πr</div></div>
    <div class="cardx"><div class="big">Area: <span id="oA">—</span></div><div class="tiny">A = πr²</div></div>
    <div class="cardx"><div class="big">Arc Length: <span id="oArc">—</span></div><div class="tiny">s = rθ (rad)</div></div>
    <div class="cardx"><div class="big">Sector Area: <span id="oSec">—</span></div><div class="tiny">Aₛ = 1/2 r²θ (rad)</div></div>
  </div>

  <div class="panel">
    <h5>Diagram</h5>
    <canvas id="circleCanvas" height="240"></canvas>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;}
  function round(n,p){var f=Math.pow(10,p||4);return Math.round(n*f)/f;}
  var r=el('radius'), d=el('diam'), adeg=el('angleDeg'), arad=el('angleRad');
  var oC=el('oC'), oA=el('oA'), oArc=el('oArc'), oSec=el('oSec'); var canvas=el('circleCanvas'),ctx=canvas.getContext('2d');

  function calc(){
    var R=num(r.value), D=num(d.value), degv=num(adeg.value), radv=num(arad.value);
    if(!(R>0)&&D>0) R=D/2;
    if(!(D>0)&&R>0) D=2*R;
    if(!(radv>0)&&degv>0) radv=degv*Math.PI/180;
    if(!(degv>0)&&radv>0) degv=radv*180/Math.PI;
    if(!(R>0)) return resetOut();

    var C=2*Math.PI*R, A=Math.PI*R*R, s=(radv>0)?R*radv:NaN, As=(radv>0)?0.5*R*R*radv:NaN;
    oC.textContent=round(C,6); oA.textContent=round(A,6);
    oArc.textContent=isFinite(s)?round(s,6):'—'; oSec.textContent=isFinite(As)?round(As,6):'—';
    draw(R, radv||0);
  }
  function resetOut(){ oC.textContent=oA.textContent=oArc.textContent=oSec.textContent='—'; ctx.clearRect(0,0,canvas.width,canvas.height); }
  function randomize(){ r.value=String(Math.floor(Math.random()*20)+5); adeg.value=String(Math.floor(Math.random()*300)+30); d.value=''; arad.value=''; calc(); }

  function draw(R, theta){
    canvas.width=canvas.clientWidth; canvas.height=240; var W=canvas.width,H=canvas.height; var p=20;
    ctx.clearRect(0,0,W,H);
    var rad=Math.min(W,H)/2 - p; var cx=W/2, cy=H/2;
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(cx,cy,rad,0,Math.PI*2); ctx.stroke();
    if(theta>0){
      ctx.fillStyle='rgba(16,185,129,.2)'; ctx.beginPath(); ctx.moveTo(cx,cy); ctx.arc(cx,cy,rad,0,theta,false); ctx.closePath(); ctx.fill();
    }
  }

  document.getElementById('btnCalc').addEventListener('click', calc);
  document.getElementById('btnReset').addEventListener('click', function(){ r.value=d.value=adeg.value=arad.value=''; resetOut(); });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
