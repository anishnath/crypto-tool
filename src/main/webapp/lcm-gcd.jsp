<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<title>LCM/GCD Finder — Multiple Numbers + Fraction Simplifier</title>
<meta name="description" content="Paste or type numbers to compute GCD (Euclidean algorithm) and LCM. Includes fraction simplifier and step-by-step Euclidean work.">
<meta name="keywords" content="lcm calculator, gcd calculator, greatest common divisor, least common multiple, euclidean algorithm, simplify fraction">
<link rel="canonical" href="https://8gwifi.org/lcm-gcd.jsp">

<%@ include file="header-script.jsp"%>

<style>
  .lg-container{ margin-top:1rem; }
  .tiny{ font-size:.85rem; color:#6b7280; }
  .data-area{ width:100%; min-height:110px; }
  .cards{ display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap:12px; margin-top:.75rem; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; word-break: break-word; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:12px; }
  .mono{ font-family: ui-monospace, Menlo, Consolas, monospace; }
  @media (max-width: 992px){ .cards{ grid-template-columns: 1fr; } }
</style>

<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"LCM/GCD Finder",
  "url":"https://8gwifi.org/lcm-gcd.jsp",
  "description":"Compute GCD and LCM of multiple numbers with Euclidean steps and fraction simplifier.",
  "keywords":"lcm calculator, gcd calculator, euclidean algorithm, simplify fraction"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="lg-container">
  <h1 class="mt-4">LCM/GCD Finder</h1>
  <p class="tiny">Paste integers (commas/spaces/new lines). We’ll compute <strong>GCD</strong> and <strong>LCM</strong>, and simplify the first pair as a fraction.</p>

  <%@ include file="footer_adsense.jsp"%>

  <textarea class="form-control data-area" id="numsArea" placeholder="e.g., 12, 18, 30, 45"></textarea>
  <div class="controls" style="margin: .5rem 0;">
    <button class="btn btn-success" id="btnCalc"><i class="fas fa-calculator"></i> Calculate</button>
    <button class="btn btn-secondary" id="btnSample"><i class="fas fa-dice"></i> Sample</button>
    <button class="btn btn-outline-danger" id="btnClear"><i class="fas fa-eraser"></i> Clear</button>
  </div>

  <div class="cards">
    <div class="cardx"><h6>GCD</h6><div class="big" id="outGcd">—</div></div>
    <div class="cardx"><h6>LCM</h6><div class="big" id="outLcm">—</div></div>
    <div class="cardx"><h6>Simplified Fraction (first two)</h6><div class="big" id="outFrac">—</div></div>
  </div>

  <div class="panel">
    <h5>Euclidean Algorithm (first two numbers)</h5>
    <pre class="mono" id="euclidSteps" style="margin:0;"></pre>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  function parseNums(t){
    var m = String(t||'').match(/-?\d+/g);
    return m ? m.map(function(s){ return parseInt(s,10); }) : [];
  }
  function gcd(a,b){
    a=Math.abs(a); b=Math.abs(b);
    while(b){ var t=a%b; a=b; b=t; }
    return a;
  }
  function gcdBig(a,b){
    a = BigInt(a); b = BigInt(b);
    if (a < 0n) a = -a; if (b < 0n) b = -b;
    while (b){ var t=a%b; a=b; b=t; }
    return a;
  }
  function lcmBig(a,b){
    if (a===0 || b===0) return 0n;
    return (BigInt(a)/gcdBig(a,b))*BigInt(b);
  }

  var area = document.getElementById('numsArea');
  var outG = document.getElementById('outGcd');
  var outL = document.getElementById('outLcm');
  var outF = document.getElementById('outFrac');
  var steps = document.getElementById('euclidSteps');

  function calc(){
    var arr = parseNums(area.value);
    if (arr.length === 0){
      outG.textContent=outL.textContent=outF.textContent='—'; steps.textContent=''; return;
    }
    // GCD/LCM across all
    var g = arr.reduce(function(a,b){ return gcd(a,b); });
    var l = arr.reduce(function(a,b){ return lcmBig(a,b); }, 1n);
    outG.textContent = String(g);
    outL.textContent = l.toString();

    if (arr.length >= 2){
      var a = arr[0], b = arr[1];
      var A = Math.abs(a), B = Math.abs(b);
      var s = [];
      while (B){ s.push(A+' = '+B+' × '+Math.floor(A/B)+' + '+(A%B)); var t=A%B; A=B; B=t; }
      var g2 = A;
      var na = a/g2, nb = b/g2;
      outF.textContent = a + '/' + b + ' = ' + na + '/' + nb;
      steps.textContent = s.join('\n') + (s.length?'\n':'') + 'gcd = ' + g2;
    } else {
      outF.textContent = 'Need at least two numbers';
      steps.textContent = '';
    }
  }

  function sample(){
    area.value = '12, 18, 30, 45, 60';
    calc();
  }
  function clearAll(){ area.value=''; outG.textContent=outL.textContent=outF.textContent='—'; steps.textContent=''; }

  document.getElementById('btnCalc').addEventListener('click', calc);
  document.getElementById('btnSample').addEventListener('click', sample);
  document.getElementById('btnClear').addEventListener('click', clearAll);
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
