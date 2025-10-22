<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Degrees ↔ Radians Converter + Arc Length</title>
<meta name="description" content="Convert between degrees and radians instantly, plus compute arc length from radius and angle.">
<link rel="canonical" href="https://8gwifi.org/degree-radian.jsp">
<%@ include file="header-script.jsp"%>
<style>
  .dr-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(3, minmax(160px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .cards{ display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr;} .cards{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="dr-container">
  <h1 class="mt-4">Degrees ↔ Radians + Arc Length</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="deg" class="form-control" placeholder="Degrees" inputmode="decimal">
    <input id="rad" class="form-control" placeholder="Radians" inputmode="decimal">
    <input id="radius" class="form-control" placeholder="Radius (for arc length)" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnConvert"><i class="fas fa-arrows-rotate"></i> Convert</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><div class="big">Radians: <span id="oRad">—</span></div></div>
    <div class="cardx"><div class="big">Degrees: <span id="oDeg">—</span></div></div>
    <div class="cardx"><div class="big">Arc length s: <span id="oArc">—</span></div><div class="tiny">s = rθ (θ in radians)</div></div>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;} function round(n,p){var f=Math.pow(10,p||6);return Math.round(n*f)/f;}
  var deg=el('deg'),rad=el('rad'),radius=el('radius'); var oRad=el('oRad'),oDeg=el('oDeg'),oArc=el('oArc');

  function convert(){
    var d=num(deg.value), r=num(rad.value), R=num(radius.value);
    if(isFinite(d)){ r=d*Math.PI/180; }
    if(isFinite(rad.value) && !isFinite(d)) { d=r*180/Math.PI; }
    oRad.textContent=isFinite(r)?round(r):'—'; oDeg.textContent=isFinite(d)?round(d):'—';
    oArc.textContent=(isFinite(R)&&isFinite(r))?round(R*r):'—';
  }
  function randomize(){ deg.value=String(Math.floor(Math.random()*360)); rad.value=''; radius.value=String(Math.floor(Math.random()*20)+5); convert(); }

  document.getElementById('btnConvert').addEventListener('click', convert);
  document.getElementById('btnReset').addEventListener('click', function(){ deg.value=rad.value=radius.value=''; oRad.textContent=oDeg.textContent=oArc.textContent='—'; });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
