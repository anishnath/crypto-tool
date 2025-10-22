<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<title>Triangle Solver — SSS, SAS, ASA/AAS (Law of Sines & Cosines)</title>
<meta name="description" content="Solve any triangle from SSS, SAS, or ASA/AAS. Computes missing sides/angles with Law of Sines and Cosines, plus area and a compact diagram.">
<link rel="canonical" href="https://8gwifi.org/triangle-solver.jsp">
<meta name="keywords" content="triangle calculator, law of sines, law of cosines, SSS, SAS, ASA, AAS">

<%@ include file="header-script.jsp"%>

<style>
  .tri-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.2rem; font-weight: 800; text-align: center;
    padding: .6rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937); color: #f59e0b;
  }
  .tiny { font-size: .85rem; color: #6b7280; }
  .controls { display:flex; flex-wrap:wrap; gap:.5rem; align-items:center; margin:1rem 0; }
  .input-grid { display:grid; grid-template-columns: repeat(6, minmax(120px, 1fr)); gap:.5rem; }
  .cards { display:grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }
  .cardx { border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .cardx h6 { margin:0 0 6px 0; color:#374151; font-weight:700; }
  .big { font-size:1.2rem; font-weight:800; color:#111827; }
  .panel { border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #triCanvas { width:100%; height:220px; display:block; }
  .math-block { font-family: ui-monospace, Menlo, Consolas, monospace; background:#f9fafb; border:1px dashed #e5e7eb; padding:10px 12px; border-radius:8px; margin-top:8px; color:#111827; }
  @media (max-width: 992px) { .input-grid{ grid-template-columns: repeat(3, 1fr);} .cards{ grid-template-columns: repeat(2, 1fr);} }
  @media (max-width: 576px) { .input-grid{ grid-template-columns: 1fr; } }
</style>

<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Triangle Solver — SSS, SAS, ASA/AAS",
  "url":"https://8gwifi.org/triangle-solver.jsp",
  "description":"Solve any triangle from SSS, SAS, or ASA/AAS with Law of Sines and Cosines. Diagram and area included.",
  "keywords":"triangle calculator, law of sines, law of cosines, SSS, SAS, ASA, AAS"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="tri-container">
  <h1 class="mt-4">Triangle Solver — Law of Sines & Cosines</h1>
  <p class="tiny">Enter known values, pick a mode, and Solve. Angles in degrees. Sides are a, b, c opposite angles A, B, C respectively.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="hero">—</div>

  <div class="controls">
    <select id="mode" class="form-control" style="max-width:240px;">
      <option value="SSS">SSS (3 sides)</option>
      <option value="SAS">SAS (two sides + included angle)</option>
      <option value="ASA">ASA/AAS (two angles + a side)</option>
    </select>
    <button class="btn btn-success" id="btnSolve"><i class="fas fa-calculator"></i> Solve</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
    <div class="ml-auto tiny">Note: For ASA/AAS, provide any side with two angles.</div>
  </div>

  <div class="input-grid">
    <div><label class="tiny">Side a</label><input id="a" class="form-control" placeholder="e.g., 7" inputmode="decimal"></div>
    <div><label class="tiny">Side b</label><input id="b" class="form-control" placeholder="e.g., 9" inputmode="decimal"></div>
    <div><label class="tiny">Side c</label><input id="c" class="form-control" placeholder="e.g., 12" inputmode="decimal"></div>
    <div><label class="tiny">Angle A (°)</label><input id="A" class="form-control" placeholder="e.g., 35" inputmode="decimal"></div>
    <div><label class="tiny">Angle B (°)</label><input id="B" class="form-control" placeholder="e.g., 60" inputmode="decimal"></div>
    <div><label class="tiny">Angle C (°)</label><input id="C" class="form-control" placeholder="e.g., 85" inputmode="decimal"></div>
  </div>

  <div class="cards" style="margin-top:.75rem;">
    <div class="cardx">
      <h6>Sides</h6>
      <div class="big">a=<span id="oa">—</span>, b=<span id="ob">—</span>, c=<span id="oc">—</span></div>
    </div>
    <div class="cardx">
      <h6>Angles</h6>
      <div class="big">A=<span id="oA">—</span>°, B=<span id="oB">—</span>°, C=<span id="oC">—</span>°</div>
    </div>
    <div class="cardx">
      <h6>Area</h6>
      <div class="big" id="oArea">—</div>
    </div>
    <div class="cardx">
      <h6>Perimeter</h6>
      <div class="big" id="oPerim">—</div>
    </div>
  </div>

  <div class="panel">
    <h5>Triangle Diagram</h5>
    <canvas id="triCanvas" height="220"></canvas>
    <div class="tiny">Scaled schematic. Labels correspond to standard notation (a opposite A, etc.).</div>
  </div>

  <div class="panel">
    <h5>Calculations</h5>
    <div id="f1" class="math-block"></div>
    <div id="f2" class="math-block"></div>
    <div id="f3" class="math-block"></div>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  function num(v){ var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,'')); return isFinite(n)?n:NaN; }
  function rad(d){ return d*Math.PI/180; } function deg(r){ return r*180/Math.PI; }
  function round(n,p){ var f=Math.pow(10,p||4); return Math.round(n*f)/f; }

  var el = function(id){ return document.getElementById(id); };
  var aE=el('a'), bE=el('b'), cE=el('c'), AE=el('A'), BE=el('B'), CE=el('C');
  var oa=el('oa'), ob=el('ob'), oc=el('oc'), oA=el('oA'), oB=el('oB'), oC=el('oC');
  var oArea=el('oArea'), oPerim=el('oPerim'), hero=el('hero');
  var f1=el('f1'), f2=el('f2'), f3=el('f3');
  var modeE=el('mode');
  var canvas=el('triCanvas'), ctx=canvas.getContext('2d');

  function solve(){
    var mode=modeE.value;
    var a=num(aE.value), b=num(bE.value), c=num(cE.value);
    var A=num(AE.value), B=num(BE.value), C=num(CE.value);

    var f1s='',f2s='',f3s='';
    if(mode==='SSS'){
      if(!(a>0&&b>0&&c>0)) return outClear('Provide three sides.');
      A=deg(Math.acos((b*b+c*c-a*a)/(2*b*c)));
      B=deg(Math.acos((a*a+c*c-b*b)/(2*a*c)));
      C=180-A-B;
      f1s='Law of Cosines: A=acos((b²+c²−a²)/(2bc)), etc.';
    } else if(mode==='SAS'){
      // Assume known a,c and included angle B OR similar; detect included angle
      if(isFinite(A)&&isFinite(b)&&isFinite(c)){ a=Math.sqrt(b*b+c*c-2*b*c*Math.cos(rad(A))); }
      else if(isFinite(B)&&isFinite(a)&&isFinite(c)){ b=Math.sqrt(a*a+c*c-2*a*c*Math.cos(rad(B))); }
      else if(isFinite(C)&&isFinite(a)&&isFinite(b)){ c=Math.sqrt(a*a+b*b-2*a*b*Math.cos(rad(C))); }
      else return outClear('Provide two sides and the included angle.');
      // find remaining with Law of Sines
      if(!isFinite(A)) A=deg(Math.asin(a*Math.sin(rad(C||B||A||0))/(c||b||a))); // heuristic
      if(!isFinite(B)) B=deg(Math.asin(b*Math.sin(rad(A||C||B||0))/(a||c||b)));
      if(!isFinite(C)) C=180-A-B;
      f1s='Law of Cosines for included angle; Law of Sines for the rest.';
    } else { // ASA/AAS
      var sum=(isFinite(A)?A:0)+(isFinite(B)?B:0)+(isFinite(C)?C:0);
      if(!(sum>0)) return outClear('Provide two angles + one side.');
      if(!isFinite(A)) A=180-(B+C);
      if(!isFinite(B)) B=180-(A+C);
      if(!isFinite(C)) C=180-(A+B);
      var side = isFinite(a)?a : (isFinite(b)?b : c);
      if(!isFinite(side)) return outClear('Provide at least one side with two angles.');
      if(isFinite(a)) { b = a*Math.sin(rad(B))/Math.sin(rad(A)); c = a*Math.sin(rad(C))/Math.sin(rad(A)); }
      else if(isFinite(b)) { a = b*Math.sin(rad(A))/Math.sin(rad(B)); c = b*Math.sin(rad(C))/Math.sin(rad(B)); }
      else { a = c*Math.sin(rad(A))/Math.sin(rad(C)); b = c*Math.sin(rad(B))/Math.sin(rad(C)); }
      f1s='Angle sum C=180°−(A+B); Law of Sines to scale sides.';
    }

    var area = 0.5*a*b*Math.sin(rad(C));
    var perim = a+b+c;
    oa.textContent=round(a,6); ob.textContent=round(b,6); oc.textContent=round(c,6);
    oA.textContent=round(A,4); oB.textContent=round(B,4); oC.textContent=round(C,4);
    oArea.textContent=round(area,6); oPerim.textContent=round(perim,6);
    hero.textContent='Solved: a='+round(a,3)+', b='+round(b,3)+', c='+round(c,3);

    f2s='Law of Sines: a/sin A = b/sin B = c/sin C';
    f3s='Area = 1/2 ab sin C';
    f1.innerHTML=f1s; f2.innerHTML=f2s; f3.innerHTML=f3s;
    draw(a,b,c);
  }
  function outClear(msg){ hero.textContent=msg||'—'; oa.textContent=ob.textContent=oc.textContent='—'; oA.textContent=oB.textContent=oC.textContent='—'; oArea.textContent=oPerim.textContent='—'; draw(0,0,0); f1.innerHTML=f2.innerHTML=f3.innerHTML=''; }

  function draw(a,b,C){
    canvas.width=canvas.clientWidth; canvas.height=220; var W=canvas.width,H=canvas.height;
    var pad=28; var s=1;
    ctx.clearRect(0,0,W,H);
    if(!(a>0&&b>0&&C>0)) return;
    var base=b; var height=a*Math.sin(rad(90)); // not used; we construct using b and included C at left
    // Place triangle with side b on bottom, angle C at left
    var x0=pad, y0=H-pad, x1=W-pad, y1=y0; // base along bottom
    var baseLen=(x1-x0);
    s=baseLen/b;
    var x2=x0 + Math.cos(rad(C))*a*s;
    var y2=y0 - Math.sin(rad(C))*a*s;

    ctx.beginPath(); ctx.moveTo(x0,y0); ctx.lineTo(x1,y1); ctx.lineTo(x2,y2); ctx.closePath();
    ctx.fillStyle='rgba(59,130,246,.12)'; ctx.fill();
    ctx.lineWidth=2; ctx.strokeStyle='#3b82f6'; ctx.stroke();

    ctx.fillStyle='#111827'; ctx.font='12px system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial';
    ctx.fillText('b', (x0+x1)/2, y0+14);
    ctx.fillText('a', (x2+x1)/2, (y2+y1)/2 - 6);
    ctx.fillText('c', (x0+x2)/2 - 10, (y0+y2)/2);
  }

  function randomCase(){
    var choice=Math.random();
    if(choice<0.34){
      modeE.value='SSS'; aE.value=7; bE.value=9; cE.value=12; AE.value=''; BE.value=''; CE.value='';
    } else if(choice<0.67){
      modeE.value='SAS'; aE.value=8; cE.value=11; BE.value=50; bE.value=''; AE.value=''; CE.value='';
    } else {
      modeE.value='ASA'; AE.value=50; BE.value=60; CE.value=''; aE.value=10; bE.value=''; cE.value='';
    }
    solve();
  }
  function resetAll(){ [aE,bE,cE,AE,BE,CE].forEach(function(e){ e.value=''; }); outClear('—'); }

  document.getElementById('btnSolve').addEventListener('click', solve);
  document.getElementById('btnRandom').addEventListener('click', randomCase);
  document.getElementById('btnReset').addEventListener('click', resetAll);
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
