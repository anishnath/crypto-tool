<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<title>Fibonacci Sequence Generator — nth Term, Ratios, Spiral</title>
<meta name="description" content="Generate the Fibonacci sequence up to n (BigInt), see ratios approaching the golden ratio φ, and view a compact spiral sketch.">
<meta name="keywords" content="fibonacci calculator, fibonacci sequence, golden ratio, fibonacci spiral, nth fibonacci">
<link rel="canonical" href="https://8gwifi.org/fibonacci.jsp">

<%@ include file="header-script.jsp"%>

<style>
  .fb-container{ margin-top:1rem; }
  .tiny{ font-size:.85rem; color:#6b7280; }
  .controls{ display:flex; flex-wrap:wrap; gap:.5rem; align-items:center; margin:1rem 0; }
  .cards{ display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; word-break:break-word; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  #spiralCanvas{ width:100%; height:240px; display:block; }
  .mono{ font-family: ui-monospace, Menlo, Consolas, monospace; }
  @media (max-width:992px){ .cards{ grid-template-columns: 1fr; } }
</style>

<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Fibonacci Sequence Generator",
  "url":"https://8gwifi.org/fibonacci.jsp",
  "description":"Generate Fibonacci numbers up to n, ratios approaching φ, and a compact spiral sketch.",
  "keywords":"fibonacci calculator, fibonacci sequence, golden ratio, spiral"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="fb-container">
  <h1 class="mt-4">Fibonacci Sequence Generator</h1>
  <p class="tiny">Enter n, get F(n) using BigInt, ratio F(n)/F(n−1), a compact spiral, and a values table.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="controls">
    <input id="n" class="form-control" style="max-width:180px;" placeholder="n (≤ 2000)" inputmode="numeric" pattern="[0-9]*">
    <button class="btn btn-success" id="btnGen"><i class="fas fa-calculator"></i> Generate</button>
    <button class="btn btn-secondary" id="btnSample"><i class="fas fa-dice"></i> Sample</button>
    <button class="btn btn-outline-danger" id="btnClear"><i class="fas fa-eraser"></i> Clear</button>
  </div>

  <div class="cards">
    <div class="cardx"><h6>F(n)</h6><div class="big" id="outFn">—</div></div>
    <div class="cardx"><h6>Ratio F(n)/F(n−1)</h6><div class="big" id="outRatio">—</div><div class="tiny">→ φ ≈ 1.6180339887…</div></div>
    <div class="cardx"><h6>Digits</h6><div class="big" id="outDigits">—</div></div>
  </div>

  <div class="panel">
    <h5>Spiral (compact sketch)</h5>
    <canvas id="spiralCanvas" height="240"></canvas>
  </div>

  <div class="panel">
    <h5>Values Table</h5>
    <div class="tiny">First 50 terms or up to n (whichever is smaller).</div>
    <pre class="mono" id="tableOut" style="margin:0; white-space: pre-wrap;"></pre>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  function fib(n){
    n = n|0;
    if (n <= 0) return 0n;
    if (n === 1) return 1n;
    let a=0n, b=1n;
    for (let i=2;i<=n;i++){ const t=a+b; a=b; b=t; }
    return b;
  }
  function digits(bi){ return bi.toString().length; }

  var nEl=document.getElementById('n');
  var outFn=document.getElementById('outFn');
  var outRatio=document.getElementById('outRatio');
  var outDigits=document.getElementById('outDigits');
  var tableOut=document.getElementById('tableOut');
  var canvas=document.getElementById('spiralCanvas');
  var ctx=canvas.getContext('2d');

  function drawSpiral(n){
    canvas.width=canvas.clientWidth; canvas.height=240;
    ctx.clearRect(0,0,canvas.width,canvas.height);
    // Use last up to 8 squares to fit compactly
    var count = Math.min(Math.max(n,1), 8);
    var seq = [1,1]; while (seq.length < count) seq.push(seq[seq.length-1]+seq[seq.length-2]);
    var size = Math.min(canvas.width, canvas.height) * 0.8;
    var unit = size / seq.reduce((a,b)=>a+b,0); // rough scale
    var x = (canvas.width - size)/2, y = (canvas.height - size)/2;
    var dir = 0; // 0:right,1:down,2:left,3:up
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2;
    for (let k=seq.length-1; k>=0; k--){
      var s = seq[k]*unit;
      ctx.strokeRect(x,y,s,s);
      // arc
      ctx.beginPath();
      if (dir===0) { ctx.arc(x, y+s, s, Math.PI*1.5, Math.PI*2); x += s; }
      else if (dir===1) { ctx.arc(x, y, s, 0, Math.PI*0.5); y += s; }
      else if (dir===2) { ctx.arc(x+s, y, s, Math.PI, Math.PI*1.5); x -= s; }
      else { ctx.arc(x+s, y+s, s, Math.PI*0.5, Math.PI); y -= s; }
      ctx.stroke();
      dir = (dir+1)%4;
    }
  }

  function gen(){
    var n = parseInt(nEl.value,10);
    if (!(n>=0 && n<=2000)) { outFn.textContent=outRatio.textContent=outDigits.textContent='—'; tableOut.textContent=''; ctx.clearRect(0,0,canvas.width,canvas.height); return; }
    var fn = fib(n);
    outFn.textContent = fn.toString();
    outDigits.textContent = String(digits(fn));
    var fn1 = fib(Math.max(1,n-1));
    outRatio.textContent = (n>1) ? (Number(fn)/Number(fn1)).toFixed(12) : '—';

    // table
    var maxT = Math.min(50, n);
    var a=0n,b=1n, lines=[];
    for (var i=0;i<=maxT;i++){
      lines.push('F(' + i + ') = ' + a.toString());
      var t=a+b;a=b;b=t;
    }
    tableOut.textContent = lines.join('\\n');

    drawSpiral(Math.min(n, 8));
  }

  function sample(){ nEl.value = String(Math.floor(Math.random()*40)+10); gen(); }
  function clearAll(){ nEl.value=''; outFn.textContent=outRatio.textContent=outDigits.textContent='—'; tableOut.textContent=''; ctx.clearRect(0,0,canvas.width,canvas.height); }

  document.getElementById('btnGen').addEventListener('click', gen);
  document.getElementById('btnSample').addEventListener('click', sample);
  document.getElementById('btnClear').addEventListener('click', clearAll);
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
