<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<title>Prime Number Checker & Generator — Is Prime, Sieve, Factorize</title>
<meta name="description" content="Check if a number is prime (BigInt), generate primes up to N or between X–Y with a fast sieve, and factorize numbers.">
<meta name="keywords" content="prime number calculator, is prime calculator, sieve of Eratosthenes, prime generator, factorization, big integer">
<link rel="canonical" href="https://8gwifi.org/prime-number.jsp">

<meta property="og:title" content="Prime Number Checker & Generator — Is Prime, Sieve, Factorize">
<meta property="og:description" content="BigInt prime check, prime generation up to N or range X–Y, and factorization with clear steps.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/prime-number.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Prime Number Checker & Generator — Is Prime, Sieve, Factorize">
<meta name="twitter:description" content="Interactive prime tools: check, generate, and factorize with optimized algorithms.">

<%@ include file="header-script.jsp"%>

<style>
  .pn-container { margin-top: 1rem; }
  .hero-number {
    font-size: 2.4rem; font-weight: 800; text-align: center;
    padding: 0.7rem 0; border-radius: 12px;
    background: linear-gradient(135deg, #111827, #1f2937);
    color: #22c55e; text-shadow: 0 2px 12px rgba(34,197,94,0.45);
    letter-spacing: 0.12rem;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    cursor: default;
  }
  .tiny { font-size: 0.85rem; color: #6b7280; }
  .controls { display:flex; flex-wrap:wrap; gap:0.5rem; align-items:center; margin:1rem 0; }
  .grid { display:grid; grid-template-columns: repeat(3, minmax(180px, 1fr)); gap: .5rem; }
  .panel {
    border: 1px solid #e5e7eb; border-radius: 12px; background: #ffffff;
    box-shadow: 0 8px 24px rgba(0,0,0,0.05);
    padding: 10px 12px; margin-top: 12px;
  }
  .mono { font-family: ui-monospace, Menlo, Consolas, monospace; }
  .chips { display:flex; flex-wrap: wrap; gap: 6px; }
  .chip { background:#f3f4f6; border:1px solid #e5e7eb; border-radius:999px; padding:4px 8px; font-weight:700; }
  @media (max-width: 768px) { .grid { grid-template-columns: 1fr; } }
</style>

<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"Prime Number Checker & Generator",
  "url":"https://8gwifi.org/prime-number.jsp",
  "description":"Check primality (BigInt), generate primes up to N or between X–Y, and factorize numbers.",
  "keywords":"prime number calculator, is prime calculator, sieve of Eratosthenes, prime generator, factorization"
}
</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="pn-container">
  <h1 class="mt-4">Prime Number Checker & Generator</h1>
  <p class="tiny">Check if a number is prime (BigInt), generate primes up to N or within a range, and factorize numbers.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="hero-number" id="hero">—</div>

  <div class="panel">
    <h5>Check if Prime</h5>
    <div class="grid">
      <input id="checkN" class="form-control" placeholder="Enter integer (supports BigInt)">
      <button id="btnCheck" class="btn btn-success"><i class="fas fa-check"></i> Check</button>
      <button id="btnFactor" class="btn btn-outline-primary"><i class="fas fa-code-branch"></i> Factorize</button>
    </div>
    <div class="tiny mono" id="checkOut" style="margin-top:.5rem;"></div>
  </div>

  <div class="panel">
    <h5>Generate Primes</h5>
    <div class="grid">
      <input id="limitN" class="form-control" placeholder="Generate primes ≤ N (≤ 2,000,000 recommended)">
      <button id="btnGenUpTo" class="btn btn-secondary"><i class="fas fa-list-ol"></i> Up to N</button>
      <input id="rangeA" class="form-control" placeholder="Range start A">
      <input id="rangeB" class="form-control" placeholder="Range end B">
      <button id="btnGenRange" class="btn btn-secondary"><i class="fas fa-arrows-left-right"></i> Range A–B</button>
    </div>
    <div class="tiny" style="margin-top:.5rem;">Note: For large ranges, a segmented sieve is used; keep (B − A) ≤ 2,000,000 for best performance.</div>
    <div class="chips mono" id="listPrimes" style="margin-top:.5rem;"></div>
  </div>

  <div class="panel">
    <h5>How this works</h5>
    <ul class="tiny">
      <li>Primality test uses deterministic Miller–Rabin for 64-bit and probabilistic for BigInt.</li>
      <li>Generation uses the classic Sieve of Eratosthenes (and segmented sieve for ranges).</li>
      <li>Factorization uses trial division by small primes (6k±1 optimization), suitable for moderately large inputs.</li>
    </ul>
  </div>

  <div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="thanks.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
(function(){
  function toBigInt(s){ try{ return BigInt(s.trim()); } catch(e){ return null; } }
  function isEven(n){ return (n & 1n) === 0n; }

  // Miller–Rabin for BigInt
  function modPow(base, exp, mod){
    base %= mod; let res = 1n;
    while (exp > 0n){
      if (exp & 1n) res = (res * base) % mod;
      base = (base * base) % mod; exp >>= 1n;
    }
    return res;
  }
  function isProbablePrime(n){
    if (n === null) return false;
    if (n < 2n) return false;
    const small = [2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n];
    for (let p of small){ if (n === p) return true; if (n % p === 0n) return false; }
    // write n-1 = d * 2^s
    let d = n - 1n, s = 0n; while ((d & 1n) === 0n){ d >>= 1n; s++; }
    const bases = [2n, 325n, 9375n, 28178n, 450775n, 9780504n, 1795265022n]; // deterministic for 64-bit
    for (let a of bases){
      if (a % n === 0n) continue;
      let x = modPow(a, d, n);
      if (x === 1n || x === n - 1n) continue;
      let cont = false;
      for (let r = 1n; r < s; r++){
        x = (x * x) % n;
        if (x === n - 1n){ cont = true; break; }
      }
      if (!cont) return false;
    }
    return true;
  }

  function sieve(limit){
    limit = Math.max(2, limit|0);
    const mark = new Uint8Array(limit + 1);
    const primes = [];
    for (let i=2;i*i<=limit;i++){
      if (!mark[i]){
        for (let j=i*i;j<=limit;j+=i) mark[j]=1;
      }
    }
    for (let i=2;i<=limit;i++) if (!mark[i]) primes.push(i);
    return primes;
  }

  function segmentedSieve(low, high){
    if (high < 2) return [];
    low = Math.max(low|0, 2);
    high = high|0;
    const size = high - low + 1;
    const mark = new Uint8Array(size);
    const base = sieve(Math.floor(Math.sqrt(high)) + 1);
    for (let p of base){
      const start = Math.max(p*p, Math.ceil(low/p)*p);
      for (let x=start; x<=high; x+=p) mark[x-low]=1;
    }
    const res = [];
    for (let i=0;i<size;i++) if(!mark[i]) res.push(low+i);
    return res;
  }

  function factorizeBig(n){
    if (n < 2n) return [];
    const f = [];
    while (n % 2n === 0n){ f.push(2n); n/=2n; }
    while (n % 3n === 0n){ f.push(3n); n/=3n; }
    let i=5n, step=2n;
    while (i*i <= n){
      while (n % i === 0n){ f.push(i); n/=i; }
      i += step; step = 6n - step; // 5,7,11,13,...
    }
    if (n > 1n) f.push(n);
    return f;
  }

  // DOM
  const hero = document.getElementById('hero');
  const checkN = document.getElementById('checkN');
  const btnCheck = document.getElementById('btnCheck');
  const btnFactor = document.getElementById('btnFactor');
  const checkOut = document.getElementById('checkOut');
  const limitN = document.getElementById('limitN');
  const btnGenUpTo = document.getElementById('btnGenUpTo');
  const rangeA = document.getElementById('rangeA');
  const rangeB = document.getElementById('rangeB');
  const btnGenRange = document.getElementById('btnGenRange');
  const listPrimes = document.getElementById('listPrimes');

  btnCheck.addEventListener('click', function(){
    const bi = toBigInt(checkN.value);
    if (bi === null){ hero.textContent='—'; checkOut.textContent='Enter an integer.'; return; }
    const prime = isProbablePrime(bi);
    hero.textContent = (prime ? 'Prime ✅' : 'Composite ❌') + ' — ' + checkN.value.trim();
    checkOut.textContent = prime ? 'Passes Miller–Rabin bases for 64-bit (and probable prime for BigInt).' :
                                   'Failed Miller–Rabin witness; number is composite.';
  });

  btnFactor.addEventListener('click', function(){
    const bi = toBigInt(checkN.value);
    if (bi === null){ checkOut.textContent='Enter an integer.'; return; }
    const fac = factorizeBig(bi).map(String);
    checkOut.textContent = fac.length ? ('Factorization: ' + fac.join(' × ')) : 'No factors (n < 2).';
  });

  btnGenUpTo.addEventListener('click', function(){
    const n = parseInt(limitN.value, 10);
    if (!(n > 1)){ listPrimes.innerHTML=''; return; }
    if (n - 2 > 2000000){ listPrimes.innerHTML = '<span class="tiny">Limit too large (use ≤ 2,000,000)</span>'; return; }
    const ps = sieve(n);
    renderPrimes(ps);
    hero.textContent = 'Found ' + ps.length + ' primes ≤ ' + n;
  });

  btnGenRange.addEventListener('click', function(){
    const a = parseInt(rangeA.value, 10), b = parseInt(rangeB.value, 10);
    if (!isFinite(a) || !isFinite(b)) return;
    const low = Math.min(a,b), high = Math.max(a,b);
    if (high - low > 2000000){ listPrimes.innerHTML = '<span class="tiny">Range too wide (use width ≤ 2,000,000)</span>'; return; }
    const ps = segmentedSieve(low, high);
    renderPrimes(ps);
    hero.textContent = 'Found ' + ps.length + ' primes in [' + low + ', ' + high + ']';
  });

  function renderPrimes(ps){
    if (!ps.length){ listPrimes.innerHTML=''; return; }
    listPrimes.innerHTML = ps.slice(0, 500).map(function(p){ return '<span class="chip mono">'+p+'</span>'; }).join(' ')
      + (ps.length > 500 ? ' <span class="tiny">… +' + (ps.length - 500) + ' more</span>' : '');
  }
})();
</script>

</div>

<%@ include file="body-close.jsp"%>
