<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Right-Triangle Trig Explorer — SOHCAHTOA</title>
<meta name="description" content="Give one acute angle and one side to solve the right triangle using SOHCAHTOA. Interactive diagram with a, b, c and angles.">
<link rel="canonical" href="https://8gwifi.org/right-triangle-trig.jsp">

<%@ include file="header-script.jsp"%>
<style>
  .rt-container{ margin-top:1rem; }
  .hero-number{ font-size:2.2rem; font-weight:800; text-align:center; padding:.6rem 0; border-radius:12px; background:linear-gradient(135deg,#111827,#1f2937); color:#38bdf8; }
  .tiny{ font-size:.85rem; color:#6b7280; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .cards{ display:grid; grid-template-columns: repeat(4,minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .cardx h6{ margin:0 0 6px 0; color:#374151; font-weight:700; }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #triCanvas{ width:100%; height:220px; display:block; }
  @media (max-width:992px){ .cards{ grid-template-columns: repeat(2,1fr);} }
  @media (max-width:576px){ .cards{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="rt-container">
  <h1 class="mt-4">Right-Triangle Trig Explorer (SOHCAHTOA)</h1>
  <p class="tiny">Provide one acute angle (θ) and one side. Choose which side you know (adjacent, opposite, or hypotenuse), then Solve.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="hero">—</div>

  <div class="controls">
    <input id="angle" class="form-control" style="max-width:140px;" placeholder="Angle θ (°)" inputmode="decimal">
    <select id="known" class="form-control" style="max-width:180px;">
      <option value="adj">Known side: adjacent (b)</option>
      <option value="opp">Known side: opposite (a)</option>
      <option value="hyp">Known side: hypotenuse (c)</option>
    </select>
    <input id="value" class="form-control" style="max-width:180px;" placeholder="Value" inputmode="decimal">
    <button class="btn btn-success" id="btnSolve"><i class="fas fa-calculator"></i> Solve</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><h6>Sides</h6><div class="big">a=<span id="oa">—</span>, b=<span id="ob">—</span>, c=<span id="oc">—</span></div></div>
    <div class="cardx"><h6>Angles</h6><div class="big">θ=<span id="oTh">—</span>°, 90°</div></div>
    <div class="cardx"><h6>Area</h6><div class="big" id="oArea">—</div></div>
    <div class="cardx"><h6>Perimeter</h6><div class="big" id="oPerim">—</div></div>
  </div>

  <div class="panel">
    <h5>Diagram</h5>
    <canvas id="triCanvas" height="220"></canvas>
  </div>
</div>

<script>
(function(){
  var ang=document.getElementById('angle'), known=document.getElementById('known'), val=document.getElementById('value');
  var oa=el('oa'), ob=el('ob'), oc=el('oc'), oTh=el('oTh'), oArea=el('oArea'), oPerim=el('oPerim'), hero=el('hero');
  var canvas=el('triCanvas'), ctx=canvas.getContext('2d');
  function el(id){return document.getElementById(id);} function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;}
  function rad(d){return d*Math.PI/180;} function round(n,p){var f=Math.pow(10,p||4);return Math.round(n*f)/f;}

  function solve(){
    var t=num(ang.value), v=num(val.value); if(!(t>0&&t<90&&v>0)) return resetOut();
    var a,b,c;
    if(known.value==='adj'){ b=v; a=Math.tan(rad(t))*b; c=b/Math.cos(rad(t)); }
    else if(known.value==='opp'){ a=v; b=a/Math.tan(rad(t)); c=a/Math.sin(rad(t)); }
    else { c=v; a=c*Math.sin(rad(t)); b=c*Math.cos(rad(t)); }
    oa.textContent=round(a,6); ob.textContent=round(b,6); oc.textContent=round(c,6);
    oTh.textContent=round(t,4); oArea.textContent=round(0.5*a*b,6); oPerim.textContent=round(a+b+c,6);
    hero.textContent='a='+round(a,3)+', b='+round(b,3)+', c='+round(c,3);
    draw(a,b,c);
  }
  function resetOut(){ oa.textContent=ob.textContent=oc.textContent=oArea.textContent=oPerim.textContent='—'; oTh.textContent='—'; draw(0,0,0); hero.textContent='—'; }
  function randomize(){ ang.value=String(Math.floor(Math.random()*60)+15); known.value='adj'; val.value=String(Math.floor(Math.random()*15)+5); solve(); }

  function draw(a,b,c){
    canvas.width=canvas.clientWidth; canvas.height=220; var W=canvas.width,H=canvas.height,p=28; var s=1; var base=b, height=a;
    var maxw=W-2*p, maxh=H-2*p; if(base>0&&height>0){ s=Math.min(maxw/base, maxh/height); }
    var x0=p,y0=H-p, x1=x0+base*s,y1=y0, x2=x0,y2=y0-height*s;
    var ctx2=ctx; ctx2.clearRect(0,0,W,H);
    if(!(a>0&&b>0)){return;}
    ctx2.beginPath(); ctx2.moveTo(x0,y0); ctx2.lineTo(x1,y1); ctx2.lineTo(x2,y2); ctx2.closePath();
    ctx2.fillStyle='rgba(56,189,248,.12)'; ctx2.fill(); ctx2.strokeStyle='#38bdf8'; ctx2.lineWidth=2; ctx2.stroke();
  }

  document.getElementById('btnSolve').addEventListener('click', solve);
  document.getElementById('btnReset').addEventListener('click', function(){ ang.value=''; val.value=''; resetOut(); });
  document.getElementById('btnRandom').addEventListener('click', randomize);
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
