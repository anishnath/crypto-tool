<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<title>Factorial & Permutation Calculator — n!, nCr, nPr (BigInt)</title>
<meta name="description" content="Compute factorial n!, permutations nPr, and combinations nCr with BigInt precision. Includes digit counts, formatting, and step formulas.">
<meta name="keywords" content="factorial calculator, permutation calculator, combination calculator, nCr, nPr, big integer, big factorial">
<link rel="canonical" href="https://8gwifi.org/factorial-permutation.jsp">

<meta property="og:title" content="Factorial & Permutation Calculator — n!, nCr, nPr (BigInt)">
<meta property="og:description" content="Fast, precise factorial and combinatorics with BigInt: n!, nCr, nPr, plus formulas and digit counts.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/factorial-permutation.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Factorial & Permutation Calculator — n!, nCr, nPr (BigInt)">
<meta name="twitter:description" content="Compute huge factorials and combinations/permutations with BigInt and see the formulas.">

<%@ include file="header-script.jsp"%>

<style>
  .fp-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.4rem; font-weight: 800; text-align: center;
    padding: 0.7rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #f472b6; text-shadow: 0 2px 12px rgba(236,72,153,0.45);
    letter-spacing: 0.12rem;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    cursor: pointer;
  }
  .hero-number.expanded {
    white-space: normal; overflow: auto; text-overflow: clip;
    word-break: break-all; max-height: 260px;
  }
  .hero-sub { text-align: center; margin-top: 0.5rem; color: #6b7280; }

  .controls { display:flex; flex-wrap:wrap; gap:0.5rem; align-items:center; margin:1rem 0; }
  .controls > * { margin-bottom:0.25rem; }
  .tiny { font-size:0.85rem; color:#6b7280; }
  .pill { display:inline-block; padding:0.35rem 0.6rem; border-radius:999px; font-size:0.9rem; }
  .pill-green{ background:#10b981; color:#0b1f17; font-weight:700; }
  .pill-gray{ background:#e5e7eb; color:#374151; font-weight:600; }

  .grid { display:grid; grid-template-columns: repeat(3, minmax(160px, 1fr)); gap: .5rem; }
  .cards { display:grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; margin-top: .75rem; }
  .cardx {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px;
  }
  .cardx h6 { margin: 0 0 6px 0; font-weight: 700; color: #374151; }
  .big { font-size: 1.05rem; font-weight: 800; color: #111827; word-break: break-word; }

  .panel {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px; margin-top: 12px;
  }
  .math-block {
    font-family: ui-monospace, Menlo, Consolas, monospace;
    background: #f9fafb; border: 1px dashed #e5e7eb; padding: 10px 12px;
    border-radius: 8px; margin-top: 8px; color: #111827; line-height: 1.45;
  }

  @media (max-width: 992px) { .grid{ grid-template-columns: repeat(2, 1fr);} .cards{ grid-template-columns: repeat(1, 1fr);} }
  @media (max-width: 576px){ .grid{ grid-template-columns: 1fr; } }
</style>

<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Factorial & Permutation Calculator — n!, nCr, nPr",
  "url":"https://8gwifi.org/factorial-permutation.jsp",
  "description":"Compute factorials, permutations, and combinations with BigInt precision. Includes formulas and digit counts.",
  "keywords":"factorial calculator, permutation calculator, combination calculator, nCr, nPr, big integer"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="fp-container">
  <h1 class="mt-4">Factorial & Permutation Calculator</h1>
  <p class="tiny">Enter n (and r). Get <span class="pill pill-green">n!</span>, <span class="pill pill-green">nPr</span>, <span class="pill pill-green">nCr</span> using BigInt. Perfect for probability puzzles and coding challenges.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="heroNumber">—</div>
  <div class="hero-sub tiny" id="heroHint">Tip: Click the banner to expand/collapse the full value. Use Sample to auto‑generate n and r. Toggle “Group digits” for readability.</div>

  <div class="grid">
    <div>
      <label for="n" class="tiny">n (non‑negative integer)</label>
      <input id="n" class="form-control" inputmode="numeric" pattern="[0-9]*" placeholder="e.g., 50">
    </div>
    <div>
      <label for="r" class="tiny">r (0 ≤ r ≤ n)</label>
      <input id="r" class="form-control" inputmode="numeric" pattern="[0-9]*" placeholder="e.g., 6">
    </div>
    <div class="form-check" style="align-self:end;">
      <input class="form-check-input" type="checkbox" id="chkGroup" checked>
      <label class="form-check-label tiny" for="chkGroup">Group digits with commas</label>
      <br>
      <input class="form-check-input" type="checkbox" id="chkApprox">
      <label class="form-check-label tiny" for="chkApprox">Use Stirling approximation if n is very large</label>
    </div>
  </div>

  <div class="controls">
    <button type="button" class="btn btn-success" id="btnCompute"><i class="fas fa-calculator"></i> Compute</button>
    <button type="button" class="btn btn-secondary" id="btnSample"><i class="fas fa-dice"></i> Sample</button>
    <button type="button" class="btn btn-outline-danger" id="btnClear"><i class="fas fa-eraser"></i> Clear</button>
    <div class="ml-auto tiny">BigInt used for exact results. Approximation available for very large n.</div>
  </div>

  <div class="cards">
    <div class="cardx">
      <h6>n! (Factorial)</h6>
      <div class="big" id="outFact">—</div>
      <div class="tiny" id="outFactMeta">digits: —</div>
    </div>
    <div class="cardx">
      <h6>nPr (Permutations)</h6>
      <div class="big" id="outPerm">—</div>
      <div class="tiny" id="outPermMeta">digits: —</div>
    </div>
    <div class="cardx">
      <h6>nCr (Combinations)</h6>
      <div class="big" id="outComb">—</div>
      <div class="tiny" id="outCombMeta">digits: —</div>
    </div>
  </div>

  <div class="panel">
    <h5>Calculations & Formulas</h5>
    <div id="formulaFact" class="math-block"></div>
    <div id="formulaPerm" class="math-block"></div>
    <div id="formulaComb" class="math-block"></div>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  var nEl = document.getElementById('n');
  var rEl = document.getElementById('r');
  var chkGroup = document.getElementById('chkGroup');
  var chkApprox = document.getElementById('chkApprox');

  var outFact = document.getElementById('outFact');
  var outPerm = document.getElementById('outPerm');
  var outComb = document.getElementById('outComb');
  var outFactMeta = document.getElementById('outFactMeta');
  var outPermMeta = document.getElementById('outPermMeta');
  var outCombMeta = document.getElementById('outCombMeta');
  var heroEl = document.getElementById('heroNumber');
  var heroHint = document.getElementById('heroHint');

  var fFact = document.getElementById('formulaFact');
  var fPerm = document.getElementById('formulaPerm');
  var fComb = document.getElementById('formulaComb');

  function parseIntSafe(s) {
    var v = String(s || '').replace(/[^0-9]/g, '');
    if (v === '') return NaN;
    return parseInt(v, 10);
  }
  function bigComma(str) {
    // group digits every 3 for readability
    return str.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    // BigInt toLocaleString may not be supported everywhere; manual is safer
  }
  function digitsCountFromString(str) {
    return str.replace(/[^0-9]/g, '').length;
  }

  // BigInt math
  function factBig(n) {
    var res = 1n;
    for (var i = 2n; i <= n; i++) res *= i;
    return res;
  }
  function permBig(n, r) {
    var N = BigInt(n);
    var R = BigInt(r);
    if (R < 0n || R > N) return 0n;
    var res = 1n;
    for (var i = N - R + 1n; i <= N; i++) res *= i;
    return res;
  }
  function combBig(n, r) {
    var N = BigInt(n);
    var R = BigInt(r);
    var k = R < (N - R) ? R : (N - R);
    if (k < 0n) return 0n;
    var res = 1n;
    for (var i = 1n; i <= k; i++) {
      res = (res * (N - k + i)) / i;
    }
    return res;
  }

  // Stirling approximation (for very large n)
  function stirlingApprox(n) {
    // log10(n!) ≈ n*log10(n/e) + 0.5*log10(2πn)
    var nn = n;
    var log10 = Math.log10;
    var log10nFact = nn * log10(nn / Math.E) + 0.5 * log10(2 * Math.PI * nn);
    var digits = Math.floor(log10nFact) + 1;
    var mantissa = Math.pow(10, log10nFact - Math.floor(log10nFact));
    return { mantissa: mantissa, exp: Math.floor(log10nFact), digits: digits };
  }

  function formatBigInt(bi) {
    var s = bi.toString();
    return chkGroup.checked ? bigComma(s) : s;
  }

  function compute() {
    var n = parseIntSafe(nEl.value);
    var r = parseIntSafe(rEl.value);
    if (!isFinite(n)) { n = NaN; }
    if (!isFinite(r)) { r = NaN; }

    // validation
    if (!(n >= 0)) {
      heroEl.textContent = '—';
      outFact.textContent = outPerm.textContent = outComb.textContent = '—';
      outFactMeta.textContent = outPermMeta.textContent = outCombMeta.textContent = 'digits: —';
      fFact.innerHTML = fPerm.innerHTML = fComb.innerHTML = '';
      return;
    }
    if (!(r >= 0)) r = 0;
    if (r > n) {
      heroEl.textContent = 'Invalid: r should satisfy 0 ≤ r ≤ n';
      outPerm.textContent = outComb.textContent = '—';
      outPermMeta.textContent = outCombMeta.textContent = 'digits: —';
    }

    // Limits for exact factorial to keep UI responsive
    var EXACT_LIMIT = 5000; // number of multiplications (n). Very large n may be slow/too big.
    var useApprox = chkApprox.checked && n > EXACT_LIMIT;

    var factStr, permStr, combStr, factDigits = '—', permDigits = '—', combDigits = '—';

    if (useApprox) {
      var approx = stirlingApprox(n);
      factStr = approx.mantissa.toFixed(6) + ' × 10^' + approx.exp;
      factDigits = String(approx.digits);
      // For nPr and nCr, provide approximate digits using logs
      if (r <= n) {
        var log10Fact = approx.exp + Math.log10(approx.mantissa);
        var log10FactNminusR = stirlingApprox(n - r);
        var log10P = log10Fact - (log10FactNminusR.exp + Math.log10(log10FactNminusR.mantissa));
        var log10C = log10P - stirlingApprox(r).exp - Math.log10(stirlingApprox(r).mantissa);
        permStr = '≈ 10^' + log10P.toFixed(3);
        combStr = '≈ 10^' + log10C.toFixed(3);
        permDigits = String(Math.floor(log10P) + 1);
        combDigits = String(Math.floor(log10C) + 1);
      } else {
        permStr = combStr = '—';
      }
    } else {
      // Exact BigInt
      try {
        var nBig = BigInt(n);
        var fact = factBig(nBig);
        factStr = formatBigInt(fact);
        factDigits = String(digitsCountFromString(factStr));

        if (r <= n) {
          var perm = permBig(n, r);
          var comb = combBig(n, r);
          permStr = formatBigInt(perm);
          combStr = formatBigInt(comb);
          permDigits = String(digitsCountFromString(permStr));
          combDigits = String(digitsCountFromString(combStr));
        } else {
          permStr = combStr = '—';
        }
      } catch (e) {
        factStr = 'Too large to compute exactly in browser';
        permStr = combStr = '—';
      }
    }

    outFact.textContent = factStr;
    outPerm.textContent = permStr;
    outComb.textContent = combStr;
    outFactMeta.textContent = 'digits: ' + factDigits;
    outPermMeta.textContent = 'digits: ' + permDigits;
    outCombMeta.textContent = 'digits: ' + combDigits;

    // Store full and abbreviated hero text
    fullHero = 'n! = ' + (typeof factStr === 'string' ? factStr : String(factStr));
    setHeroDisplay();

    // formulas
    var k = Math.min(r, n - r);
    fFact.innerHTML = '<strong>Factorial</strong>: n! = 1 × 2 × … × n';
    fPerm.innerHTML = '<strong>Permutations</strong>: nP' + r + ' = n! / (n − ' + r + ')! = ∏<sub>i=' + (n - r + 1) + '</sub><sup>n</sup> i';
    fComb.innerHTML = '<strong>Combinations</strong>: nC' + r + ' = n! / [(n − ' + r + ')! r!] = ∏<sub>i=1</sub><sup>' + k + '</sup> (n − k + i)/i';
  }

  function sample() {
    var n = Math.floor(Math.random() * 70) + 20; // 20..89
    var r = Math.floor(Math.random() * (n + 1));
    nEl.value = n;
    rEl.value = r;
    heroHint.textContent = 'Sample loaded: n=' + n + ', r=' + r + ' — press Compute';
    compute();
  }

  function clearAll() {
    nEl.value = '';
    rEl.value = '';
    outFact.textContent = outPerm.textContent = outComb.textContent = '—';
    outFactMeta.textContent = outPermMeta.textContent = outCombMeta.textContent = 'digits: —';
    fFact.innerHTML = fPerm.innerHTML = fComb.innerHTML = '';
    heroEl.textContent = '—';
  }

  // Hero display helpers
  var fullHero = '';
  var heroExpanded = false;
  function abbreviate(str) {
    if (!str) return '—';
    var plain = String(str);
    // keep prefix/suffix when too long
    if (plain.length > 64) {
      var digits = plain.replace(/\D/g, '').length || plain.length;
      return plain.slice(0, 24) + '…' + plain.slice(-18) + '  (' + digits + ' digits)';
    }
    return plain;
  }
  function setHeroDisplay() {
    if (!fullHero) { heroEl.textContent = '—'; return; }
    if (heroExpanded) {
      heroEl.classList.add('expanded');
      heroEl.textContent = fullHero;
    } else {
      heroEl.classList.remove('expanded');
      heroEl.textContent = abbreviate(fullHero);
    }
  }

  document.getElementById('btnCompute').addEventListener('click', compute);
  document.getElementById('btnSample').addEventListener('click', sample);
  document.getElementById('btnClear').addEventListener('click', clearAll);
  chkGroup.addEventListener('change', compute);
  chkApprox.addEventListener('change', compute);

  // Enter key triggers compute
  [nEl, rEl].forEach(function(el){ el.addEventListener('keydown', function(e){ if (e.key === 'Enter') compute(); }); });

  // Expand/collapse on click; copy full value on double-click
  heroEl.addEventListener('click', function(){ heroExpanded = !heroExpanded; setHeroDisplay(); });
  heroEl.addEventListener('dblclick', function(){
    if (!fullHero) return;
    var toCopy = fullHero.replace(/^n! =\s*/, '');
    if (navigator.clipboard) navigator.clipboard.writeText(toCopy);
  });

  // init
  heroEl.textContent = '—';
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
