<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Polar ↔ Cartesian Converter</title>
<meta name="description" content="Convert between polar (r, θ) and Cartesian (x, y). Compact XY diagram with point marker.">
<link rel="canonical" href="https://8gwifi.org/polar-cartesian.jsp">
<%@ include file="header-script.jsp"%>
<style>
  .pc-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(4, minmax(160px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #xyCanvas{ width:100%; height:220px; display:block; }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr 1fr; } }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="pc-container">
  <h1 class="mt-4">Polar ↔ Cartesian Converter</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="x" class="form-control" placeholder="x" inputmode="decimal">
    <input id="y" class="form-control" placeholder="y" inputmode="decimal">
    <input id="r" class="form-control" placeholder="r" inputmode="decimal">
    <input id="theta" class="form-control" placeholder="θ (deg)" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnToPolar">to Polar</button>
    <button class="btn btn-success" id="btnToCartesian">to Cartesian</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="panel">
    <h5>Diagram</h5>
    <canvas id="xyCanvas" height="220"></canvas>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;} function round(n,p){var f=Math.pow(10,p||6);return Math.round(n*f)/f;}
  function rad(d){return d*Math.PI/180;} function deg(r){return r*180/Math.PI;}

  var x=el('x'),y=el('y'),r=el('r'),theta=el('theta'); var canvas=el('xyCanvas'),ctx=canvas.getContext('2d');

  function toPolar(){
    var X=num(x.value),Y=num(y.value); if(!(isFinite(X)&&isFinite(Y))) return;
    var R=Math.sqrt(X*X+Y*Y); var T=deg(Math.atan2(Y,X));
    r.value=round(R); theta.value=round(T);
    draw(X,Y);
  }
  function toCartesian(){
    var R=num(r.value), T=num(theta.value); if(!(R>=0&&isFinite(T))) return;
    var X=R*Math.cos(rad(T)), Y=R*Math.sin(rad(T));
    x.value=round(X); y.value=round(Y);
    draw(X,Y);
  }
  function randomize(){ x.value=Math.floor(Math.random()*20-10); y.value=Math.floor(Math.random()*20-10); r.value=''; theta.value=''; toPolar(); }

  function draw(X,Y){
    canvas.width=canvas.clientWidth; canvas.height=220; var W=canvas.width,H=canvas.height,p=30; var sx=(W-2*p)/20, sy=(H-2*p)/20;
    function mx(x){return p+(x+10)*sx;} function my(y){return H-p-(y+10)*sy;}
    ctx.clearRect(0,0,W,H);
    ctx.strokeStyle='#e5e7eb'; ctx.beginPath(); ctx.moveTo(p,my(0)); ctx.lineTo(W-p,my(0)); ctx.moveTo(mx(0),p); ctx.lineTo(mx(0),H-p); ctx.stroke();
    ctx.fillStyle='#111827'; ctx.beginPath(); ctx.arc(mx(X), my(Y), 5, 0, Math.PI*2); ctx.fill();
  }

  document.getElementById('btnToPolar').addEventListener('click', toPolar);
  document.getElementById('btnToCartesian').addEventListener('click', toCartesian);
  document.getElementById('btnReset').addEventListener('click', function(){ x.value=y.value=r.value=theta.value=''; ctx.clearRect(0,0,canvas.width,canvas.height); });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
