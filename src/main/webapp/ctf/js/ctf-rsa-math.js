/**
 * ctf-rsa-math.js — BigInt math library for RSA CTF challenges.
 * Provides prime generation, factoring algorithms, continued fractions,
 * and core RSA primitives. Uses native BigInt throughout.
 *
 * Exports: window.RSAMath
 */
(function(global) {
'use strict';

var M = {};

// ─── Core Arithmetic ────────────────────────────────────────────────

M.modPow = function(base, exp, mod) {
    if (mod === 1n) return 0n;
    var result = 1n;
    base = ((base % mod) + mod) % mod;
    while (exp > 0n) {
        if (exp & 1n) result = (result * base) % mod;
        exp >>= 1n;
        base = (base * base) % mod;
    }
    return result;
};

M.modInverse = function(a, m) {
    a = ((a % m) + m) % m;
    var g = m, x0 = 0n, x1 = 1n;
    if (m === 1n) return 0n;
    while (a > 1n) {
        if (g === 0n) return null;
        var q = a / g;
        var t = g;
        g = a % g;
        a = t;
        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }
    return x1 < 0n ? x1 + m : x1;
};

M.gcd = function(a, b) {
    a = a < 0n ? -a : a;
    b = b < 0n ? -b : b;
    while (b > 0n) { var t = b; b = a % b; a = t; }
    return a;
};

M.lcm = function(a, b) {
    if (a === 0n || b === 0n) return 0n;
    var aa = a < 0n ? -a : a;
    var bb = b < 0n ? -b : b;
    return (aa / M.gcd(aa, bb)) * bb;
};

M.abs = function(n) { return n < 0n ? -n : n; };

M.bitLength = function(n) {
    if (n <= 0n) return 0;
    var bits = 0;
    while (n > 0n) { bits++; n >>= 1n; }
    return bits;
};

M.isqrt = function(n) {
    if (n < 0n) throw new Error('sqrt of negative');
    if (n < 2n) return n;
    var x = n;
    var y = (x + 1n) / 2n;
    while (y < x) {
        x = y;
        y = (x + n / x) / 2n;
    }
    return x;
};

M.iCbrt = function(n) {
    if (n < 0n) return -M.iCbrt(-n);
    if (n < 2n) return n;
    var lo = 1n, hi = n;
    while (lo <= hi) {
        var mid = (lo + hi) / 2n;
        var cube = mid * mid * mid;
        if (cube === n) return mid;
        if (cube < n) lo = mid + 1n; else hi = mid - 1n;
    }
    return hi;
};

// ─── Random Number Generation ───────────────────────────────────────

M.randomBigInt = function(bits) {
    if (bits <= 0) return 0n;
    var bytes = Math.ceil(bits / 8);
    var arr = new Uint8Array(bytes);
    crypto.getRandomValues(arr);
    var extraBits = bytes * 8 - bits;
    if (extraBits > 0) arr[0] &= (0xFF >> extraBits);
    var hex = '';
    for (var i = 0; i < arr.length; i++) {
        hex += ('0' + arr[i].toString(16)).slice(-2);
    }
    return BigInt('0x' + (hex || '0'));
};

M.randomBigIntRange = function(min, max) {
    var range = max - min;
    if (range <= 0n) return min;
    var bits = M.bitLength(range);
    var r;
    do { r = M.randomBigInt(bits); } while (r > range);
    return min + r;
};

// ─── Primality Testing ──────────────────────────────────────────────

var SMALL_PRIMES = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97];

M.isProbablePrime = function(n, rounds) {
    if (typeof n === 'number') n = BigInt(n);
    if (n < 2n) return false;
    for (var i = 0; i < SMALL_PRIMES.length; i++) {
        var sp = BigInt(SMALL_PRIMES[i]);
        if (n === sp) return true;
        if (n % sp === 0n) return false;
    }
    rounds = rounds || 20;
    var d = n - 1n;
    var s = 0n;
    while (d % 2n === 0n) { d /= 2n; s++; }

    for (var r = 0; r < rounds; r++) {
        var a = M.randomBigIntRange(2n, n - 2n);
        var x = M.modPow(a, d, n);
        if (x === 1n || x === n - 1n) continue;
        var composite = true;
        for (var j = 0n; j < s - 1n; j++) {
            x = M.modPow(x, 2n, n);
            if (x === n - 1n) { composite = false; break; }
        }
        if (composite) return false;
    }
    return true;
};

// ─── Prime Generation ───────────────────────────────────────────────

M.randomPrime = function(bits) {
    if (bits < 2) return 2n;
    var attempts = 0;
    while (attempts < 10000) {
        var n = M.randomBigInt(bits);
        n |= (1n << BigInt(bits - 1));  // ensure top bit set (correct bit length)
        n |= 1n;                         // ensure odd
        if (M.isProbablePrime(n)) return n;
        attempts++;
    }
    throw new Error('Failed to generate prime of ' + bits + ' bits');
};

M.randomSafePrime = function(bits) {
    var attempts = 0;
    while (attempts < 50000) {
        var q = M.randomPrime(bits - 1);
        var p = 2n * q + 1n;
        if (M.isProbablePrime(p)) return p;
        attempts++;
    }
    throw new Error('Failed to generate safe prime');
};

M.generateSmoothPrime = function(bits, smoothBound) {
    smoothBound = smoothBound || 10000;
    var primes = M.smallPrimesList(smoothBound);
    var attempts = 0;
    while (attempts < 30000) {
        // Build p-1 as product of distinct primes (each used once)
        // This ensures Pollard p-1 with bound=smoothBound will always work
        var shuffled = primes.slice();
        for (var i = shuffled.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var t = shuffled[i]; shuffled[i] = shuffled[j]; shuffled[j] = t;
        }
        var pm1 = 2n;
        for (var i = 0; i < shuffled.length; i++) {
            var next = pm1 * BigInt(shuffled[i]);
            if (M.bitLength(next + 1n) > bits) break;
            pm1 = next;
        }
        var p = pm1 + 1n;
        if (M.bitLength(p) >= bits - 2 && M.bitLength(p) <= bits && M.isProbablePrime(p)) return p;
        attempts++;
    }
    throw new Error('Failed to generate smooth prime');
};

M.smallPrimesList = function(limit) {
    var sieve = new Uint8Array(limit + 1);
    var primes = [];
    for (var i = 2; i <= limit; i++) {
        if (!sieve[i]) {
            primes.push(i);
            for (var j = i * i; j <= limit; j += i) sieve[j] = 1;
        }
    }
    return primes;
};

// ─── Factoring Algorithms ───────────────────────────────────────────

M.factorTrialDivision = function(n, limit) {
    limit = limit || 1000000;
    if (n < 2n) return null;
    if (n % 2n === 0n) return 2n;
    for (var i = 3n; i <= BigInt(limit) && i * i <= n; i += 2n) {
        if (n % i === 0n) return i;
    }
    return null;
};

M.factorPollardRho = function(n) {
    if (n % 2n === 0n) return 2n;
    if (M.isProbablePrime(n)) return n;
    for (var attempt = 0; attempt < 50; attempt++) {
        var x = M.randomBigIntRange(2n, n - 1n);
        var y = x;
        var c = M.randomBigIntRange(1n, n - 1n);
        var d = 1n;
        while (d === 1n) {
            x = (x * x + c) % n;
            y = (y * y + c) % n;
            y = (y * y + c) % n;
            d = M.gcd(M.abs(x - y), n);
        }
        if (d !== n) return d;
    }
    return null;
};

M.factorPollardPminus1 = function(n, bound) {
    bound = bound || 100000;
    var a = 2n;
    var primes = M.smallPrimesList(bound);
    for (var i = 0; i < primes.length; i++) {
        var pp = BigInt(primes[i]);
        var pk = pp;
        while (pk * pp <= BigInt(bound)) pk *= pp;
        a = M.modPow(a, pk, n);
        var d = M.gcd(a - 1n, n);
        if (d > 1n && d < n) return d;
    }
    return null;
};

// ─── Continued Fractions (for Wiener Attack) ────────────────────────

M.continuedFraction = function(num, den) {
    var cf = [];
    while (den > 0n) {
        var q = num / den;
        cf.push(q);
        var r = num % den;
        num = den;
        den = r;
    }
    return cf;
};

M.convergents = function(cf) {
    var convs = [];
    var h_prev = 0n, h_curr = 1n;
    var k_prev = 1n, k_curr = 0n;
    for (var i = 0; i < cf.length; i++) {
        var a = cf[i];
        var h_next = a * h_curr + h_prev;
        var k_next = a * k_curr + k_prev;
        convs.push({ num: h_next, den: k_next });
        h_prev = h_curr;
        h_curr = h_next;
        k_prev = k_curr;
        k_curr = k_next;
    }
    return convs;
};

// ─── CRT (Chinese Remainder Theorem) ───────────────────────────────

M.crt = function(remainders, moduli) {
    var N = 1n;
    for (var i = 0; i < moduli.length; i++) N *= moduli[i];
    var result = 0n;
    for (var i = 0; i < moduli.length; i++) {
        var ni = N / moduli[i];
        var xi = M.modInverse(ni, moduli[i]);
        result = (result + remainders[i] * ni * xi) % N;
    }
    return ((result % N) + N) % N;
};

// ─── Text <-> BigInt Conversion ─────────────────────────────────────

M.textToNumber = function(str) {
    var bytes = new TextEncoder().encode(str);
    var hex = '';
    for (var i = 0; i < bytes.length; i++) {
        hex += ('0' + bytes[i].toString(16)).slice(-2);
    }
    return BigInt('0x' + hex);
};

M.numberToText = function(n) {
    if (n <= 0n) return '';
    var hex = n.toString(16);
    if (hex.length % 2) hex = '0' + hex;
    var bytes = new Uint8Array(hex.length / 2);
    for (var i = 0; i < bytes.length; i++) {
        bytes[i] = parseInt(hex.substr(i * 2, 2), 16);
    }
    return new TextDecoder().decode(bytes);
};

// ─── RSA Primitives ─────────────────────────────────────────────────

M.rsaEncrypt = function(m, e, n) {
    return M.modPow(m, e, n);
};

M.rsaDecrypt = function(c, d, n) {
    return M.modPow(c, d, n);
};

M.rsaKeyFromPQ = function(p, q, e) {
    e = e || 65537n;
    var n = p * q;
    var phi = (p - 1n) * (q - 1n);
    if (M.gcd(e, phi) !== 1n) {
        var candidates = [65537n, 257n, 17n, 3n];
        for (var i = 0; i < candidates.length; i++) {
            if (M.gcd(candidates[i], phi) === 1n) { e = candidates[i]; break; }
        }
    }
    var d = M.modInverse(e, phi);
    var dp = d % (p - 1n);
    var dq = d % (q - 1n);
    var qinv = M.modInverse(q, p);
    return { n: n, e: e, d: d, p: p, q: q, phi: phi, dp: dp, dq: dq, qinv: qinv };
};

M.rsaKeyFromMultiPrime = function(primes, e) {
    e = e || 65537n;
    var n = 1n;
    var phi = 1n;
    for (var i = 0; i < primes.length; i++) {
        n *= primes[i];
        phi *= (primes[i] - 1n);
    }
    if (M.gcd(e, phi) !== 1n) {
        e = 257n;
        if (M.gcd(e, phi) !== 1n) e = 17n;
    }
    var d = M.modInverse(e, phi);
    return { n: n, e: e, d: d, primes: primes, phi: phi };
};

// ─── PEM Encoding Helpers ───────────────────────────────────────────

M.bigIntToBytes = function(n) {
    var hex = n.toString(16);
    if (hex.length % 2) hex = '0' + hex;
    var bytes = [];
    for (var i = 0; i < hex.length; i += 2) {
        bytes.push(parseInt(hex.substr(i, 2), 16));
    }
    return bytes;
};

M.bytesToBigInt = function(bytes) {
    var hex = '';
    for (var i = 0; i < bytes.length; i++) {
        hex += ('0' + bytes[i].toString(16)).slice(-2);
    }
    return hex.length ? BigInt('0x' + hex) : 0n;
};

M.encodeDERInteger = function(n) {
    var bytes = M.bigIntToBytes(n);
    if (bytes[0] >= 0x80) bytes.unshift(0x00);
    var lenBytes = M._derLength(bytes.length);
    return [0x02].concat(lenBytes, bytes);
};

M._derLength = function(len) {
    if (len < 128) return [len];
    var bytes = [];
    var tmp = len;
    while (tmp > 0) { bytes.unshift(tmp & 0xFF); tmp >>= 8; }
    bytes.unshift(0x80 | bytes.length);
    return bytes;
};

M.buildPrivateKeyDER = function(key) {
    var seq = [];
    seq = seq.concat(M.encodeDERInteger(0n));       // version
    seq = seq.concat(M.encodeDERInteger(key.n));
    seq = seq.concat(M.encodeDERInteger(key.e));
    seq = seq.concat(M.encodeDERInteger(key.d));
    seq = seq.concat(M.encodeDERInteger(key.p));
    seq = seq.concat(M.encodeDERInteger(key.q));
    seq = seq.concat(M.encodeDERInteger(key.dp));
    seq = seq.concat(M.encodeDERInteger(key.dq));
    seq = seq.concat(M.encodeDERInteger(key.qinv));
    var lenBytes = M._derLength(seq.length);
    return [0x30].concat(lenBytes, seq);
};

M.derToBase64 = function(derBytes) {
    var binary = '';
    for (var i = 0; i < derBytes.length; i++) {
        binary += String.fromCharCode(derBytes[i]);
    }
    return btoa(binary);
};

M.buildPEM = function(key) {
    var der = M.buildPrivateKeyDER(key);
    var b64 = M.derToBase64(der);
    var lines = [];
    for (var i = 0; i < b64.length; i += 64) {
        lines.push(b64.substring(i, i + 64));
    }
    return '-----BEGIN RSA PRIVATE KEY-----\n' + lines.join('\n') + '\n-----END RSA PRIVATE KEY-----';
};

// ─── Fermat Factorization ────────────────────────────────────────────

M.factorFermat = function(n, maxIter) {
    maxIter = maxIter || 100000;
    var a = M.isqrt(n);
    if (a * a === n) return a;
    a += 1n;
    for (var i = 0; i < maxIter; i++) {
        var b2 = a * a - n;
        var b = M.isqrt(b2);
        if (b * b === b2) return a - b;
        a += 1n;
    }
    return null;
};

// ─── Modular Square Root (Tonelli-Shanks, for Rabin) ────────────────

M.modSqrt = function(a, p) {
    if (a === 0n) return 0n;
    if (p === 2n) return a % 2n;
    if (M.modPow(a, (p - 1n) / 2n, p) !== 1n) return null;

    if (p % 4n === 3n) return M.modPow(a, (p + 1n) / 4n, p);

    var s = 0n, q = p - 1n;
    while (q % 2n === 0n) { q /= 2n; s++; }
    var z = 2n;
    while (M.modPow(z, (p - 1n) / 2n, p) !== p - 1n) z++;
    var m = s, c = M.modPow(z, q, p);
    var t = M.modPow(a, q, p), r = M.modPow(a, (q + 1n) / 2n, p);
    while (true) {
        if (t === 1n) return r;
        var i = 1n;
        var tmp = (t * t) % p;
        while (tmp !== 1n) { tmp = (tmp * tmp) % p; i++; }
        var b = c;
        for (var j = 0n; j < m - i - 1n; j++) b = (b * b) % p;
        m = i; c = (b * b) % p; t = (t * c) % p; r = (r * b) % p;
    }
};

// ─── Generate close primes (for Fermat factorization challenges) ────

M.generateClosePrimes = function(bits) {
    var halfBits = Math.floor(bits / 2);
    var base = M.randomPrime(halfBits);
    var offset = M.randomBigIntRange(2n, 1n << BigInt(Math.max(4, Math.floor(halfBits / 8))));
    if (offset % 2n === 1n) offset += 1n;
    var q = base + offset;
    while (!M.isProbablePrime(q)) q += 2n;
    return { p: base, q: q };
};

// ─── Generate twin primes ───────────────────────────────────────────

M.generateTwinPrimes = function(bits) {
    var halfBits = Math.floor(bits / 2);
    var attempts = 0;
    while (attempts < 50000) {
        var p = M.randomPrime(halfBits);
        if (M.isProbablePrime(p + 2n)) return { p: p, q: p + 2n };
        if (M.isProbablePrime(p - 2n) && p - 2n > 2n) return { p: p - 2n, q: p };
        attempts++;
    }
    throw new Error('Failed to generate twin primes');
};

// ─── SHA-256 helper (delegates to SubtleCrypto) ─────────────────────

M.sha256hex = function(str) {
    var data = new TextEncoder().encode(str);
    return crypto.subtle.digest('SHA-256', data).then(function(buf) {
        var arr = new Uint8Array(buf);
        var hex = '';
        for (var i = 0; i < arr.length; i++) hex += ('0' + arr[i].toString(16)).slice(-2);
        return hex;
    });
};

// ─── Seeded PRNG (Mulberry32) for reproducible output ───────────────

M.seededRng = function(seed) {
    var s = seed | 0;
    return function() {
        s = (s + 0x6D2B79F5) | 0;
        var t = Math.imul(s ^ (s >>> 15), 1 | s);
        t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
        return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
};

M.seededRandomBigInt = function(bits, rng) {
    if (bits <= 0) return 0n;
    var result = 0n;
    for (var i = 0; i < bits; i++) {
        if (rng() < 0.5) result |= (1n << BigInt(i));
    }
    result |= (1n << BigInt(bits - 1));
    return result;
};

M.seededRandomPrime = function(bits, rng) {
    var attempts = 0;
    while (attempts < 10000) {
        var n = M.seededRandomBigInt(bits, rng);
        n |= 1n;
        if (M.isProbablePrime(n)) return n;
        attempts++;
    }
    throw new Error('Seeded prime generation failed');
};

global.RSAMath = M;

})(typeof window !== 'undefined' ? window : (typeof global !== 'undefined' ? global : this));
