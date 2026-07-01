/**
 * Prime Number Calculator — DOM/UI (Miller-Rabin, sieve, factorization, charts).
 * Requires: tool-utils.js (optional toast)
 */
(function(){
    'use strict';

    // ========== BigInt / Math Algorithms (unchanged) ==========
    function toBigInt(s){ try{ return BigInt(s.trim()); } catch(e){ return null; } }

    function modPow(base, exp, mod){
        base %= mod; var res = 1n;
        while (exp > 0n){
            if (exp & 1n) res = (res * base) % mod;
            base = (base * base) % mod; exp >>= 1n;
        }
        return res;
    }

    function isProbablePrime(n){
        if (n === null) return false;
        if (n < 2n) return false;
        var small = [2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n];
        for (var i=0;i<small.length;i++){ if (n === small[i]) return true; if (n % small[i] === 0n) return false; }
        var d = n - 1n, s = 0n;
        while ((d & 1n) === 0n){ d >>= 1n; s++; }
        var bases = [2n, 325n, 9375n, 28178n, 450775n, 9780504n, 1795265022n];
        for (var b=0;b<bases.length;b++){
            var a = bases[b];
            if (a % n === 0n) continue;
            var x = modPow(a, d, n);
            if (x === 1n || x === n - 1n) continue;
            var cont = false;
            for (var r = 1n; r < s; r++){
                x = (x * x) % n;
                if (x === n - 1n){ cont = true; break; }
            }
            if (!cont) return false;
        }
        return true;
    }

    function sieve(limit){
        limit = Math.max(2, limit|0);
        var mark = new Uint8Array(limit + 1);
        var primes = [];
        for (var i=2;i*i<=limit;i++){
            if (!mark[i]) for (var j=i*i;j<=limit;j+=i) mark[j]=1;
        }
        for (var k=2;k<=limit;k++) if (!mark[k]) primes.push(k);
        return primes;
    }

    function segmentedSieve(low, high){
        if (high < 2) return [];
        low = Math.max(low|0, 2);
        high = high|0;
        var size = high - low + 1;
        var mark = new Uint8Array(size);
        var base = sieve(Math.floor(Math.sqrt(high)) + 1);
        for (var i=0;i<base.length;i++){
            var p = base[i];
            var start = Math.max(p*p, Math.ceil(low/p)*p);
            for (var x=start; x<=high; x+=p) mark[x-low]=1;
        }
        var res = [];
        for (var k=0;k<size;k++) if(!mark[k]) res.push(low+k);
        return res;
    }

    function factorizeBig(n){
        if (n < 2n) return [];
        var f = [];
        while (n % 2n === 0n){ f.push(2n); n/=2n; }
        while (n % 3n === 0n){ f.push(3n); n/=3n; }
        var i=5n, step=2n;
        while (i*i <= n){
            while (n % i === 0n){ f.push(i); n/=i; }
            i += step; step = 6n - step;
        }
        if (n > 1n) f.push(n);
        return f;
    }

    // ========== DOM ==========
    var hero = document.getElementById('pn-hero');
    var checkInput = document.getElementById('pn-check-input');
    var checkOutput = document.getElementById('pn-check-output');
    var limitInput = document.getElementById('pn-limit-input');
    var rangeA = document.getElementById('pn-range-a');
    var rangeB = document.getElementById('pn-range-b');
    var primesList = document.getElementById('pn-primes-list');
    var twinToggle = document.getElementById('pn-twin-toggle');
    var listControls = document.getElementById('pn-list-controls');
    var lastPrimeSet = null;

    function setHero(text, cls) {
        hero.textContent = text;
        hero.className = 'pn-hero' + (cls ? ' ' + cls : '');
    }

    // Clear ALL stale output from every section
    var allOutputIds = ['pn-check-output', 'pn-nth-output', 'pn-nearest-output', 'pn-goldbach-output', 'pn-gcd-output'];
    function clearAllOutputs() {
        for (var i = 0; i < allOutputIds.length; i++) {
            var el = document.getElementById(allOutputIds[i]);
            if (el) el.textContent = '';
        }
        primesList.style.display = 'none';
        primesList.innerHTML = '';
        listControls.style.display = 'none';
        document.getElementById('pn-gap-card').style.display = 'none';
        document.getElementById('pn-density-card').style.display = 'none';
    }

    // ========== Check ==========
    document.getElementById('pn-btn-check').addEventListener('click', function(){
        var bi = toBigInt(checkInput.value);
        if (bi === null){ setHero('\u2014'); checkOutput.textContent='Enter a valid integer.'; clearAllOutputs(); return; }
        var prime = isProbablePrime(bi);
        setHero((prime ? 'Prime' : 'Composite') + ' \u2014 ' + checkInput.value.trim(), prime ? 'prime' : 'composite');
        checkOutput.textContent = prime
            ? 'Passes deterministic Miller-Rabin for 64-bit (probable prime for BigInt).'
            : 'Failed Miller-Rabin witness test \u2014 number is composite.';
        clearAllOutputs();
    });

    // ========== Factorize ==========
    document.getElementById('pn-btn-factor').addEventListener('click', function(){
        var bi = toBigInt(checkInput.value);
        if (bi === null){ checkOutput.textContent='Enter a valid integer.'; return; }
        var fac = factorizeBig(bi).map(String);
        checkOutput.textContent = fac.length ? ('Factorization: ' + fac.join(' \u00d7 ')) : 'No factors (n < 2).';
        if (fac.length) setHero(checkInput.value.trim() + ' = ' + fac.join(' \u00d7 '), 'info');
        clearAllOutputs();
    });

    // ========== Generate up to N ==========
    document.getElementById('pn-btn-upto').addEventListener('click', function(){
        clearAllOutputs();
        var n = parseInt(limitInput.value, 10);
        if (!(n > 1)) return;
        if (n > 2000000){ setHero('Limit too large', 'composite'); renderPrimes([]); return; }
        var ps = sieve(n);
        renderPrimes(ps);
        setHero('Found ' + ps.length.toLocaleString() + ' primes \u2264 ' + n.toLocaleString(), 'info');
        checkOutput.textContent = '';
    });

    // ========== Generate range ==========
    document.getElementById('pn-btn-range').addEventListener('click', function(){
        clearAllOutputs();
        var a = parseInt(rangeA.value, 10), b = parseInt(rangeB.value, 10);
        if (!isFinite(a) || !isFinite(b)) return;
        var low = Math.min(a,b), high = Math.max(a,b);
        if (high - low > 2000000){ setHero('Range too wide', 'composite'); renderPrimes([]); return; }
        var ps = segmentedSieve(low, high);
        renderPrimes(ps);
        setHero('Found ' + ps.length.toLocaleString() + ' primes in [' + low.toLocaleString() + ', ' + high.toLocaleString() + ']', 'info');
        checkOutput.textContent = '';
    });

    // ========== NEW: Nth Prime ==========
    // Upper bound estimate: n * (ln(n) + ln(ln(n))) for n >= 6
    function nthPrime(n) {
        if (n < 1) return null;
        if (n <= 6) return [2,3,5,7,11,13][n-1];
        var ln = Math.log(n), lnln = Math.log(ln);
        var upper = Math.ceil(n * (ln + lnln + 2));
        upper = Math.min(upper, 20000000); // safety cap
        var ps = sieve(upper);
        return ps.length >= n ? ps[n-1] : null;
    }

    document.getElementById('pn-btn-nth').addEventListener('click', function(){
        clearAllOutputs();
        var n = parseInt(document.getElementById('pn-nth-input').value, 10);
        var out = document.getElementById('pn-nth-output');
        if (!(n > 0) || n > 1300000) { out.textContent = n > 1300000 ? 'Max supported: 1,300,000' : 'Enter a positive integer.'; return; }
        var p = nthPrime(n);
        if (p !== null) {
            out.textContent = 'The ' + n.toLocaleString() + ordSuffix(n) + ' prime is ' + p.toLocaleString();
            setHero('P(' + n.toLocaleString() + ') = ' + p.toLocaleString(), 'prime');
        } else {
            out.textContent = 'Could not compute.';
        }
    });

    function ordSuffix(n) {
        var s = ['th','st','nd','rd'], v = n % 100;
        return (s[(v-20)%10]||s[v]||s[0]);
    }

    // ========== NEW: Nearest Prime ==========
    function nearestPrime(n) {
        var bi = toBigInt(String(n));
        if (bi === null || bi < 2n) return { below: null, above: '2' };
        var below = null, above = null;
        for (var d = 0n; d < 1000n; d++) {
            if (below === null && bi - d >= 2n && isProbablePrime(bi - d)) below = String(bi - d);
            if (above === null && isProbablePrime(bi + d)) above = String(bi + d);
            if (below !== null && above !== null) break;
        }
        return { below: below, above: above };
    }

    document.getElementById('pn-btn-nearest').addEventListener('click', function(){
        clearAllOutputs();
        var val = document.getElementById('pn-nearest-input').value.trim();
        var out = document.getElementById('pn-nearest-output');
        if (!val) { out.textContent = 'Enter a non-negative integer.'; return; }
        var r = nearestPrime(val);
        if (r.below === val) {
            // N itself is prime
            out.textContent = val + ' is prime!';
            setHero(val + ' is prime!', 'prime');
        } else {
            var belowStr = r.below !== null ? r.below : 'none';
            var aboveStr = r.above !== null ? r.above : 'none';
            out.textContent = 'Below: ' + belowStr + '  |  Above: ' + aboveStr;
            setHero(belowStr + ' \u2190 ' + val + ' \u2192 ' + aboveStr, 'info');
        }
    });

    // ========== NEW: Goldbach Partition ==========
    // Uses sieve for fast lookup instead of per-candidate Miller-Rabin
    function goldbach(n) {
        if (n <= 2 || n % 2 !== 0) return null;
        var ps = sieve(n);
        var primeSet = new Uint8Array(n + 1);
        for (var i = 0; i < ps.length; i++) primeSet[ps[i]] = 1;
        for (var j = 0; j < ps.length; j++) {
            var p = ps[j];
            if (p > n / 2) break;
            if (primeSet[n - p]) return [p, n - p];
        }
        return null;
    }

    document.getElementById('pn-btn-goldbach').addEventListener('click', function(){
        clearAllOutputs();
        var n = parseInt(document.getElementById('pn-goldbach-input').value, 10);
        var out = document.getElementById('pn-goldbach-output');
        if (!isFinite(n) || n <= 2 || n % 2 !== 0) { out.textContent = 'Enter an even integer greater than 2.'; return; }
        if (n > 10000000) { out.textContent = 'Max supported: 10,000,000'; return; }
        var pair = goldbach(n);
        if (pair) {
            out.textContent = n.toLocaleString() + ' = ' + pair[0].toLocaleString() + ' + ' + pair[1].toLocaleString();
            setHero(n.toLocaleString() + ' = ' + pair[0].toLocaleString() + ' + ' + pair[1].toLocaleString(), 'info');
        } else {
            out.textContent = 'No partition found (should not happen for even n > 2).';
        }
    });

    // ========== NEW: Coprimality & GCD ==========
    function gcdBig(a, b) {
        a = a < 0n ? -a : a;
        b = b < 0n ? -b : b;
        while (b > 0n) { var t = b; b = a % b; a = t; }
        return a;
    }

    document.getElementById('pn-btn-gcd').addEventListener('click', function(){
        clearAllOutputs();
        var aVal = toBigInt(document.getElementById('pn-gcd-a').value);
        var bVal = toBigInt(document.getElementById('pn-gcd-b').value);
        var out = document.getElementById('pn-gcd-output');
        if (aVal === null || bVal === null) { out.textContent = 'Enter two integers.'; return; }
        var g = gcdBig(aVal, bVal);
        var coprime = (g === 1n);
        out.textContent = 'GCD(' + aVal + ', ' + bVal + ') = ' + g + (coprime ? ' \u2014 Coprime!' : '');
        setHero('GCD = ' + g + (coprime ? ' (coprime)' : ''), coprime ? 'prime' : 'info');
    });

    // ========== Twin Prime Toggle ==========
    function renderPrimesWithTwin(ps, highlight) {
        if (!ps.length) { primesList.style.display='none'; primesList.innerHTML=''; listControls.style.display='none'; return; }
        primesList.style.display = '';
        listControls.style.display = '';
        var twinSet = {};
        if (highlight && ps.length > 1) {
            for (var t = 0; t < ps.length - 1; t++) {
                if (ps[t+1] - ps[t] === 2) { twinSet[ps[t]] = 1; twinSet[ps[t+1]] = 1; }
            }
        }
        var html = '';
        var lim = Math.min(ps.length, 500);
        for (var i = 0; i < lim; i++) {
            var cls = 'pn-chip';
            if (highlight && twinSet[ps[i]]) cls += ' twin';
            else if (highlight) cls += ' twin-dim';
            html += '<span class="' + cls + '">' + ps[i] + '</span>';
        }
        if (ps.length > 500) html += '<span class="pn-overflow">... +' + (ps.length - 500) + ' more</span>';
        primesList.innerHTML = html;
    }

    twinToggle.addEventListener('change', function(){
        if (lastPrimeSet) renderPrimesWithTwin(lastPrimeSet, this.checked);
    });

    // Override renderPrimes to store + respect twin toggle
    function renderPrimes(ps){
        lastPrimeSet = ps;
        renderPrimesWithTwin(ps, twinToggle.checked);
        if (ps.length > 1) drawGapChart(ps);
        if (ps.length > 10) drawDensityChart(ps);
    }

    // ========== Prime Gap Chart (Canvas) ==========
    function drawGapChart(primes) {
        var card = document.getElementById('pn-gap-card');
        var canvas = document.getElementById('pn-gap-canvas');
        if (!card || !canvas || primes.length < 2) { if (card) card.style.display='none'; return; }
        card.style.display = '';
        var ctx = canvas.getContext('2d');
        var dpr = window.devicePixelRatio || 1;
        var w = canvas.clientWidth;
        var h = 180;
        canvas.width = w * dpr;
        canvas.height = h * dpr;
        ctx.scale(dpr, dpr);

        var gaps = [];
        var maxG = 0;
        var limit = Math.min(primes.length - 1, 300); // cap bars for readability
        for (var i = 0; i < limit; i++) {
            var g = primes[i+1] - primes[i];
            gaps.push(g);
            if (g > maxG) maxG = g;
        }
        if (maxG === 0) maxG = 1;

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        ctx.clearRect(0, 0, w, h);
        var barW = Math.max(1, (w - 20) / gaps.length);
        var pad = 10;

        for (var j = 0; j < gaps.length; j++) {
            var barH = (gaps[j] / maxG) * (h - 20);
            var x = pad + j * barW;
            var y = h - 10 - barH;
            ctx.fillStyle = gaps[j] === 2 ? (isDark ? '#fbbf24' : '#f59e0b') : (isDark ? '#34d399' : '#10b981');
            ctx.fillRect(x, y, Math.max(1, barW - 1), barH);
        }
        // Axis label
        ctx.fillStyle = isDark ? '#94a3b8' : '#64748b';
        ctx.font = '10px Inter, sans-serif';
        ctx.fillText('max gap: ' + maxG, pad, 12);
        ctx.fillText('twin gaps (2) highlighted', w - 130, 12);
    }

    // ========== Prime Density Chart (Canvas) ==========
    function drawDensityChart(primes) {
        var card = document.getElementById('pn-density-card');
        var canvas = document.getElementById('pn-density-canvas');
        if (!card || !canvas || primes.length < 10) { if (card) card.style.display='none'; return; }
        card.style.display = '';
        var ctx = canvas.getContext('2d');
        var dpr = window.devicePixelRatio || 1;
        var w = canvas.clientWidth;
        var h = 180;
        canvas.width = w * dpr;
        canvas.height = h * dpr;
        ctx.scale(dpr, dpr);

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        ctx.clearRect(0, 0, w, h);

        // Sample points: for each prime, compute pi(x)/x and 1/ln(x)
        var maxX = primes[primes.length - 1];
        var samples = 200;
        var step = Math.max(1, Math.floor(primes.length / samples));
        var pts_actual = []; // pi(x)/x
        var pts_theory = []; // 1/ln(x)
        var pad = 30;
        var plotW = w - pad - 10;
        var plotH = h - 30;

        for (var i = step; i < primes.length; i += step) {
            var x = primes[i];
            if (x < 3) continue;
            var piX = i + 1; // number of primes up to primes[i]
            pts_actual.push({ x: x, y: piX / x });
            pts_theory.push({ x: x, y: 1 / Math.log(x) });
        }

        if (!pts_actual.length) { card.style.display='none'; return; }

        var maxY = 0;
        for (var k = 0; k < pts_actual.length; k++) {
            if (pts_actual[k].y > maxY) maxY = pts_actual[k].y;
            if (pts_theory[k].y > maxY) maxY = pts_theory[k].y;
        }
        if (maxY === 0) maxY = 1;

        function mapX(v) { return pad + (v / maxX) * plotW; }
        function mapY(v) { return h - 15 - (v / maxY) * plotH; }

        // Draw theory line (1/ln(x))
        ctx.beginPath();
        ctx.strokeStyle = isDark ? '#a78bfa' : '#8b5cf6';
        ctx.lineWidth = 2;
        for (var t = 0; t < pts_theory.length; t++) {
            var tx = mapX(pts_theory[t].x), ty = mapY(pts_theory[t].y);
            t === 0 ? ctx.moveTo(tx, ty) : ctx.lineTo(tx, ty);
        }
        ctx.stroke();

        // Draw actual line (pi(x)/x)
        ctx.beginPath();
        ctx.strokeStyle = isDark ? '#34d399' : '#10b981';
        ctx.lineWidth = 2;
        for (var a = 0; a < pts_actual.length; a++) {
            var ax = mapX(pts_actual[a].x), ay = mapY(pts_actual[a].y);
            a === 0 ? ctx.moveTo(ax, ay) : ctx.lineTo(ax, ay);
        }
        ctx.stroke();

        // Legend
        ctx.font = '10px Inter, sans-serif';
        ctx.fillStyle = isDark ? '#34d399' : '#10b981';
        ctx.fillText('\u03C0(x)/x (actual)', pad + 4, 14);
        ctx.fillStyle = isDark ? '#a78bfa' : '#8b5cf6';
        ctx.fillText('1/ln(x) (PNT)', pad + 100, 14);

        // Axes
        ctx.strokeStyle = isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.08)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad, h - 15);
        ctx.lineTo(w - 10, h - 15);
        ctx.stroke();
    }

    // Enter key handlers
    checkInput.addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-check').click();
    });
    limitInput.addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-upto').click();
    });
    rangeB.addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-range').click();
    });
    document.getElementById('pn-nth-input').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-nth').click();
    });
    document.getElementById('pn-nearest-input').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-nearest').click();
    });
    document.getElementById('pn-goldbach-input').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-goldbach').click();
    });
    document.getElementById('pn-gcd-b').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-gcd').click();
    });
})();
