/**
 * ctf-rsa-engine.js — 14 RSA CTF challenge type generators.
 * Depends on: ctf-rsa-math.js (RSAMath)
 *
 * Exports: window.CTFRSAEngine
 */
(function(global) {
'use strict';

var M = global.RSAMath;
if (!M) throw new Error('ctf-rsa-math.js must be loaded before ctf-rsa-engine.js');

var ENGINE_URL = 'https://8gwifi.org/ctf/rsa-ctf-generator.jsp';
var VERSION = '1.0';

function makeMeta(type, difficulty) {
    return {
        generator: '8gwifi.org RSA CTF Challenge Generator',
        version: VERSION,
        url: ENGINE_URL,
        created: new Date().toISOString(),
        difficulty: difficulty || 'medium',
        type: type
    };
}

function flagHash(flag) {
    return M.sha256hex(flag);
}

// ─── Type 1: Even Modulus N ─────────────────────────────────────────

function generateEvenModulus(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var q = M.randomPrime(bits - 1);
    var p = 2n;
    var e = 65537n;
    var n = p * q;
    var phi = (p - 1n) * (q - 1n);
    if (M.gcd(e, phi) !== 1n) e = 257n;
    var d = M.modInverse(e, phi);
    var m = M.textToNumber(flag);
    if (m >= n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, e, n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. Look carefully at the modulus n. Is it odd or even?',
        '2. If n is even, then 2 divides n.',
        '3. One of the prime factors is 2. Compute q = n / 2.',
        '4. With p=2 and q known, compute phi = (p-1)*(q-1).',
        '5. Compute d = modInverse(e, phi), then decrypt: m = c^d mod n.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_evenModulus', 'easy'),
            challenge: {
                n: n.toString(),
                e: e.toString(),
                c: c.toString(),
                note: 'Standard RSA. Decrypt c to recover the flag. Hint: examine n closely.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: d.toString(), phi: phi.toString(),
                method: 'Even Modulus — p=2, trivial factorization'
            },
            hints: hints
        };
    });
}

// ─── Type 2: Smooth Primes / Pollard p-1 ────────────────────────────

function generateSmoothPrime(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var smoothBound = opts.smoothBound || 10000;
    var p = M.generateSmoothPrime(Math.floor(bits / 2), smoothBound);
    var q = M.randomPrime(Math.ceil(bits / 2));
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. Try factoring n. Standard methods may be slow.',
        '2. One prime has a special property — its p-1 is very smooth.',
        '3. Pollard\'s p-1 algorithm works well when p-1 has only small factors.',
        '4. Use a smoothness bound of ' + smoothBound + ' for Pollard\'s p-1.',
        '5. Once you find p, compute q = n/p, then phi and d.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_smoothPrime', 'medium'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                note: 'Decrypt the ciphertext. The primes were generated carelessly.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                smoothBound: smoothBound,
                method: 'Pollard p-1 — one prime has B-smooth p-1'
            },
            hints: hints
        };
    });
}

// ─── Type 3: Wiener's Attack ────────────────────────────────────────

function generateWienerAttack(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    if (p < q) { var tmp = p; p = q; q = tmp; }
    var n = p * q;
    var phi = (p - 1n) * (q - 1n);

    // d must be small: d < n^0.25 ≈ 2^(bits/4)
    var dBits = Math.floor(bits / 4) - 2;
    if (dBits < 8) dBits = 8;
    var d, e;
    var attempts = 0;
    while (attempts < 1000) {
        d = M.randomPrime(dBits);
        if (M.gcd(d, phi) !== 1n) { attempts++; continue; }
        e = M.modInverse(d, phi);
        if (e !== null && e > 1n) break;
        attempts++;
    }
    if (!e || e <= 1n) throw new Error('Failed to generate Wiener-vulnerable key');

    var m = M.textToNumber(flag);
    if (m >= n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, e, n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. Notice that e is unusually large (close to n).',
        '2. A very large e implies a very small d.',
        '3. Wiener\'s attack exploits small d using continued fractions of e/n.',
        '4. Compute the continued fraction expansion of e/n and check each convergent.',
        '5. For each convergent k/d, check if d decrypts correctly: m = c^d mod n.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_wienerAttack', 'medium'),
            challenge: {
                n: n.toString(), e: e.toString(), c: c.toString(),
                note: 'The public exponent seems unusually large...'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: d.toString(), phi: phi.toString(),
                method: 'Wiener\'s Attack — d is small, use continued fractions of e/n'
            },
            hints: hints
        };
    });
}

// ─── Type 4: Partial Key Leak ───────────────────────────────────────

function generatePartialKeyLeak(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    // Variation: leakTarget = 'p_msb' (default), 'p_lsb', or 'd_msb'
    var variants = ['p_msb', 'p_lsb', 'd_msb'];
    var leakTarget = opts.leakTarget || variants[Math.floor(Math.random() * variants.length)];
    var leakPercent = opts.leakPercent || 70;

    var targetBin, leakedBits, maskedBits, partial, leakLabel;

    if (leakTarget === 'd_msb') {
        targetBin = key.d.toString(2);
        leakedBits = Math.floor(targetBin.length * leakPercent / 100);
        maskedBits = targetBin.length - leakedBits;
        partial = targetBin.substring(0, leakedBits) + '?'.repeat(maskedBits);
        leakLabel = 'd (private exponent)';
    } else if (leakTarget === 'p_lsb') {
        targetBin = p.toString(2);
        leakedBits = Math.floor(targetBin.length * leakPercent / 100);
        maskedBits = targetBin.length - leakedBits;
        partial = '?'.repeat(maskedBits) + targetBin.substring(maskedBits);
        leakLabel = 'p (LSBs known)';
    } else {
        targetBin = p.toString(2);
        leakedBits = Math.floor(targetBin.length * leakPercent / 100);
        maskedBits = targetBin.length - leakedBits;
        partial = targetBin.substring(0, leakedBits) + '?'.repeat(maskedBits);
        leakLabel = 'p (MSBs known)';
    }

    var hintCount = opts.hintCount || 5;
    var hints;
    if (leakTarget === 'd_msb') {
        hints = [
            '1. You have a partial leak of the private exponent d (' + leakedBits + ' of ' + targetBin.length + ' bits).',
            '2. The known MSBs of d constrain the search space significantly.',
            '3. Only ' + maskedBits + ' bits are unknown — brute-force is feasible.',
            '4. For each candidate d, verify: pow(2, e*d, n) == 2.',
            '5. Once d is recovered, decrypt: m = pow(c, d, n).'
        ].slice(0, hintCount);
    } else if (leakTarget === 'p_lsb') {
        hints = [
            '1. You have the low bits (LSBs) of prime p (' + leakedBits + ' of ' + targetBin.length + ' bits).',
            '2. Coppersmith\'s method can recover the remaining high bits when enough LSBs are known.',
            '3. Only ' + maskedBits + ' MSBs are unknown — brute-force from the top.',
            '4. For each candidate prefix, combine with known LSBs and check if n % p == 0.',
            '5. Once p is found: q = n/p, phi = (p-1)(q-1), d = e^{-1} mod phi.'
        ].slice(0, hintCount);
    } else {
        hints = [
            '1. You have the high bits (MSBs) of prime p (' + leakedBits + ' of ' + targetBin.length + ' bits).',
            '2. The known MSBs narrow the search space to 2^' + maskedBits + ' candidates.',
            '3. Only ' + maskedBits + ' bits are unknown — brute-force is feasible.',
            '4. For each candidate p, check if n % p == 0.',
            '5. Once p is found: q = n/p, phi = (p-1)(q-1), d = e^{-1} mod phi.'
        ].slice(0, hintCount);
    }

    return flagHash(flag).then(function(hash) {
        var challenge = {
            n: key.n.toString(), e: key.e.toString(), c: c.toString(),
            leaked_bits: leakedBits,
            total_bits: targetBin.length,
            leak_type: leakTarget,
            note: 'A memory dump leaked partial bits of ' + leakLabel + '. Recover the full value to decrypt.'
        };
        if (leakTarget === 'd_msb') {
            challenge.partial_d = partial;
        } else {
            challenge.partial_p = partial;
        }

        return {
            meta: makeMeta('rsa_partialKeyLeak', 'hard'),
            challenge: challenge,
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                method: 'Partial key leak (' + leakTarget + ') — brute-force ' + maskedBits + ' unknown bits'
            },
            hints: hints
        };
    });
}

// ─── Type 5: Partial PEM Leak ───────────────────────────────────────

function generatePartialPEM(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var pem = M.buildPEM(key);
    var lines = pem.split('\n');
    var totalLines = lines.length;
    var keepLines = Math.ceil(totalLines * 0.55);
    var corruptedLines = lines.slice(0, keepLines);
    corruptedLines.push('[... ' + (totalLines - keepLines - 1) + ' lines corrupted ...]');
    corruptedLines.push(lines[lines.length - 1]);
    var partialPEM = corruptedLines.join('\n');

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. You have a partial RSA private key in PEM format.',
        '2. PEM is base64-encoded DER (ASN.1). Decode the visible bytes.',
        '3. The DER structure contains: version, n, e, d, p, q, dp, dq, qInv.',
        '4. Even partial information about d or p can be enough to reconstruct the full key.',
        '5. Try decoding the ASN.1 structure from the available base64 lines.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_partialPEM', 'hard'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                partial_pem: partialPEM,
                note: 'A corrupted private key file was recovered from disk. Enough data may remain to reconstruct the key.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                full_pem: pem,
                method: 'Partial PEM recovery — decode ASN.1 DER to extract key components'
            },
            hints: hints
        };
    });
}

// ─── Type 6: ROCA-Style Weak Primes ─────────────────────────────────

function generateROCA(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var smallPrimes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43];
    var M_val = 1n;
    for (var i = 0; i < smallPrimes.length; i++) M_val *= BigInt(smallPrimes[i]);
    // M = primorial(43) = 2*3*5*...*43

    // Generate ROCA-style prime: p = k*M + (65537^a mod M)
    var e_base = 65537n;
    var p, a_val;
    var attempts = 0;
    while (attempts < 5000) {
        a_val = M.randomBigIntRange(2n, M_val - 1n);
        var residue = M.modPow(e_base, a_val, M_val);
        var k = M.randomBigIntRange(1n, 1n << BigInt(halfBits - M.bitLength(M_val)));
        p = k * M_val + residue;
        if (M.bitLength(p) === halfBits && M.isProbablePrime(p)) break;
        attempts++;
    }
    if (!M.isProbablePrime(p)) throw new Error('Failed to generate ROCA-style prime');

    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var msg = M.textToNumber(flag);
    if (msg >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(msg, key.e, key.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The primes were generated using a flawed algorithm (similar to ROCA vulnerability CVE-2017-15361).',
        '2. ROCA primes have the form p = k*M + (65537^a mod M) where M is a primorial.',
        '3. Check p mod M for each small primorial M to detect the pattern.',
        '4. M = 2*3*5*7*11*13*17*19*23*29*31*37*41*43 (primorial of 43).',
        '5. Once you know p ≡ 65537^a mod M, search over k values to reconstruct p.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_rocaWeak', 'hard'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                primorial_hint: 'M = primorial(43)',
                note: 'These keys were generated by a device with a known firmware vulnerability.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                roca_a: a_val.toString(),
                method: 'ROCA — primes have form p = k*M + 65537^a mod M'
            },
            hints: hints
        };
    });
}

// ─── Type 7: Franklin-Reiter Related Messages ───────────────────────

function generateFranklinReiter(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var e = 3n;
    var n = p * q;
    var phi = (p - 1n) * (q - 1n);
    while (M.gcd(e, phi) !== 1n) { e += 2n; }

    var m = M.textToNumber(flag);
    var delta = M.randomBigIntRange(1n, 1000n);
    var m2 = m + delta;
    if (m2 >= n) throw new Error('Flag too long for key size');

    var c1 = M.rsaEncrypt(m, e, n);
    var c2 = M.rsaEncrypt(m2, e, n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. Two ciphertexts were encrypted with the same public key (n, e=' + e.toString() + ').',
        '2. The two plaintexts are related: m2 = m1 + delta.',
        '3. This is the Franklin-Reiter related message attack.',
        '4. With e=3 and known delta, compute GCD of polynomials x^3 - c1 and (x+delta)^3 - c2 over Z/nZ.',
        '5. The GCD yields a linear factor whose root is the message m.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_franklinReiter', 'hard'),
            challenge: {
                n: n.toString(), e: e.toString(),
                c1: c1.toString(), c2: c2.toString(),
                delta: delta.toString(),
                note: 'Two related messages encrypted with the same key. The second message is the first plus a known offset.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                m1: m.toString(), m2: m2.toString(),
                method: 'Franklin-Reiter — GCD of related polynomials recovers m'
            },
            hints: hints
        };
    });
}

// ─── Type 8: Small Factor q ─────────────────────────────────────────

function generateSmallFactor(flag, opts) {
    opts = opts || {};
    var largeBits = opts.largeBits || 256;
    var smallBits = opts.smallBits || 32;

    var p = M.randomPrime(largeBits);
    var q = M.randomPrime(smallBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The modulus n has an unusual factorization.',
        '2. One prime factor is much smaller than the other.',
        '3. Try trial division with small primes up to 2^' + smallBits + '.',
        '4. Pollard\'s rho algorithm will find the small factor quickly.',
        '5. Once q is found: p = n/q, phi = (p-1)(q-1), d = e^{-1} mod phi.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_smallFactor', 'easy'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                note: 'Standard RSA encryption. Factor n to find the private key.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                method: 'Small factor — q is only ' + smallBits + ' bits, trivial to find'
            },
            hints: hints
        };
    });
}

// ─── Type 9: Padding Oracle (Bleichenbacher) ────────────────────────

function generatePaddingOracle(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');

    // PKCS#1 v1.5 padding: 0x00 0x02 [random non-zero bytes] 0x00 [message]
    var nBytes = M.bigIntToBytes(key.n).length;
    var mBytes = M.bigIntToBytes(m);
    var padLen = nBytes - mBytes.length - 3;
    if (padLen < 8) throw new Error('Flag too long for PKCS#1 padding');

    var padded = [0x00, 0x02];
    for (var i = 0; i < padLen; i++) {
        padded.push(Math.floor(Math.random() * 254) + 1); // non-zero random bytes
    }
    padded.push(0x00);
    padded = padded.concat(mBytes);
    var paddedNum = M.bytesToBigInt(padded);
    var c = M.rsaEncrypt(paddedNum, key.e, key.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The ciphertext was encrypted with PKCS#1 v1.5 padding.',
        '2. An oracle endpoint tells you if a ciphertext has valid padding after decryption.',
        '3. This is the Bleichenbacher (BB98) padding oracle attack.',
        '4. Multiply c by r^e mod n and query the oracle to narrow the plaintext range.',
        '5. Use the RSA homomorphic property: Dec(c * r^e) = m * r mod n.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_paddingOracle', 'pro'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                padding: 'PKCS#1 v1.5',
                oracle_endpoint: '/RSAFunctionality',
                oracle_params: {
                    methodName: 'CALCULATE_RSA',
                    encryptdecryptparameter: 'decrypt'
                },
                note: 'The server decrypts ciphertext and rejects invalid PKCS#1 v1.5 padding. Use this oracle to recover the flag.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                private_key_pem: M.buildPEM(key),
                method: 'Bleichenbacher padding oracle — adaptive chosen-ciphertext attack'
            },
            hints: hints
        };
    });
}

// ─── Type 10: Multi-Prime RSA ───────────────────────────────────────

function generateMultiPrime(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var numPrimes = opts.numPrimes || 3;
    var primeBits = Math.floor(bits / numPrimes);

    var primes = [];
    for (var i = 0; i < numPrimes; i++) {
        // Make the first prime small so ECM or trial division can find it
        var pb = (i === 0) ? Math.max(primeBits - 20, 16) : primeBits + Math.floor(20 / (numPrimes - 1));
        primes.push(M.randomPrime(pb));
    }

    var key = M.rsaKeyFromMultiPrime(primes);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. This is not standard two-prime RSA.',
        '2. The modulus n has ' + numPrimes + ' prime factors (multi-prime RSA).',
        '3. One factor is smaller than the others — try Pollard\'s rho or trial division.',
        '4. phi(n) = (p1-1)(p2-1)...(pk-1) for multi-prime RSA.',
        '5. Factor n completely, compute phi, then d = e^{-1} mod phi.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_multiPrime', 'medium'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                num_factors_hint: numPrimes,
                note: 'The modulus n may have more than 2 prime factors.'
            },
            solution: {
                flag: flag, hash: hash,
                primes: primes.map(function(p) { return p.toString(); }),
                d: key.d.toString(), phi: key.phi.toString(),
                method: 'Multi-prime RSA — n has ' + numPrimes + ' factors'
            },
            hints: hints
        };
    });
}

// ─── Type 11: Known phi / p+q Leak ──────────────────────────────────

function generateKnownPhiLeak(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var sum_pq = p + q;
    var leakType = (opts.leakType === 'phi') ? 'phi' : 'sum';

    var hintCount = opts.hintCount || 5;
    var hints;
    if (leakType === 'phi') {
        hints = [
            '1. You have both n and phi(n).',
            '2. phi(n) = (p-1)(q-1) = n - p - q + 1, so p+q = n - phi + 1.',
            '3. With s = p+q and n = p*q, solve the quadratic: x^2 - s*x + n = 0.',
            '4. The discriminant is s^2 - 4n. Take the integer square root.',
            '5. p = (s + sqrt(s^2-4n))/2, q = (s - sqrt(s^2-4n))/2.'
        ].slice(0, hintCount);
    } else {
        hints = [
            '1. You have n = p*q and the sum s = p + q.',
            '2. p and q are roots of the quadratic x^2 - s*x + n = 0.',
            '3. Discriminant = s^2 - 4*n. Compute its integer square root.',
            '4. p = (s + sqrt(s^2-4n))/2, q = (s - sqrt(s^2-4n))/2.',
            '5. With p,q known, compute phi=(p-1)(q-1), d=e^{-1} mod phi.'
        ].slice(0, hintCount);
    }

    return flagHash(flag).then(function(hash) {
        var challenge = {
            n: key.n.toString(), e: key.e.toString(), c: c.toString(),
            note: leakType === 'phi'
                ? 'A side-channel leak revealed phi(n). Use it to recover the private key.'
                : 'A side-channel leak revealed p + q. Use it to factor n.'
        };
        if (leakType === 'phi') {
            challenge.phi = key.phi.toString();
        } else {
            challenge.sum_pq = sum_pq.toString();
        }

        return {
            meta: makeMeta('rsa_knownPhiLeak', 'easy'),
            challenge: challenge,
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                sum_pq: sum_pq.toString(),
                method: leakType === 'phi'
                    ? 'Known phi(n) — compute p+q = n - phi + 1, solve quadratic'
                    : 'Known p+q — solve quadratic x^2 - (p+q)x + n = 0'
            },
            hints: hints
        };
    });
}

// ─── Type 12: Side-Channel Hint (d bit pattern) ─────────────────────

function generateSideChannel(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var dBin = key.d.toString(2);
    var maskPercent = opts.maskPercent || 20;
    var maskedCount = Math.floor(dBin.length * maskPercent / 100);
    var indices = [];
    for (var i = 0; i < dBin.length; i++) indices.push(i);
    // Shuffle and pick maskedCount indices to mask
    for (var i = indices.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = indices[i]; indices[i] = indices[j]; indices[j] = tmp;
    }
    var maskSet = {};
    for (var i = 0; i < maskedCount; i++) maskSet[indices[i]] = true;

    var dPattern = '';
    for (var i = 0; i < dBin.length; i++) {
        dPattern += maskSet[i] ? '?' : dBin[i];
    }

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. A power analysis side-channel leaked the bit pattern of the private exponent d.',
        '2. ' + maskedCount + ' of ' + dBin.length + ' bits are unknown (marked with ?).',
        '3. Brute-force the ' + maskedCount + ' unknown bits (2^' + maskedCount + ' candidates).',
        '4. For each candidate d, test: m^e mod n should equal c (encrypt a known value).',
        '5. Alternatively: decrypt c with each candidate d and check for readable text.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_sideChannel', 'medium'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                d_bits: dPattern,
                unknown_bits: maskedCount,
                total_bits: dBin.length,
                note: 'A power analysis attack leaked most bits of d. Recover the full private exponent.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                method: 'Side-channel — brute-force ' + maskedCount + ' unknown bits of d'
            },
            hints: hints
        };
    });
}

// ─── Type 13: Hastad Broadcast Attack ───────────────────────────────

function generateHastadBroadcast(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);
    // Variation: e can be 3, 5, or 7
    var eChoices = [3n, 5n, 7n];
    var e = opts.exponent ? BigInt(opts.exponent) : eChoices[Math.floor(Math.random() * eChoices.length)];
    var numRecipients = opts.numRecipients || Number(e);
    if (BigInt(numRecipients) < e) numRecipients = Number(e);

    var keys = [];
    var ciphertexts = [];
    var m = M.textToNumber(flag);

    for (var i = 0; i < numRecipients; i++) {
        var p, q, n, phi;
        var attempts = 0;
        while (attempts < 100) {
            p = M.randomPrime(halfBits);
            q = M.randomPrime(halfBits);
            n = p * q;
            phi = (p - 1n) * (q - 1n);
            if (M.gcd(e, phi) === 1n && m < n) break;
            attempts++;
        }
        keys.push({ n: n, e: e, p: p, q: q });
        ciphertexts.push(M.rsaEncrypt(m, e, n));
    }

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The same message was encrypted with e=' + e.toString() + ' to ' + numRecipients + ' different recipients.',
        '2. This is Hastad\'s broadcast attack.',
        '3. Use the Chinese Remainder Theorem (CRT) on the ciphertexts and moduli.',
        '4. CRT gives you m^' + e.toString() + ' mod (n1*n2*...*n' + numRecipients + ').',
        '5. Since m^' + e.toString() + ' < n1*n2*...*n' + numRecipients + ', take the integer ' + e.toString() + '-th root to recover m.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        var recipients = [];
        for (var i = 0; i < numRecipients; i++) {
            recipients.push({
                n: keys[i].n.toString(),
                e: keys[i].e.toString(),
                c: ciphertexts[i].toString()
            });
        }

        return {
            meta: makeMeta('rsa_hastadBroadcast', 'medium'),
            challenge: {
                e: e.toString(),
                recipients: recipients,
                note: 'The same plaintext was encrypted with e=' + e.toString() + ' to ' + numRecipients + ' different recipients.'
            },
            solution: {
                flag: flag, hash: hash,
                m: m.toString(),
                keys: keys.map(function(k) {
                    return { p: k.p.toString(), q: k.q.toString() };
                }),
                method: 'Hastad broadcast — CRT + integer e-th root'
            },
            hints: hints
        };
    });
}

// ─── Type 14: Common Factor (Batch GCD) ─────────────────────────────

function generateCommonFactor(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);
    var numKeys = opts.numKeys || 8;

    // Generate a shared prime
    var sharedP = M.randomPrime(halfBits);

    var allKeys = [];
    var vulnerableIndices = [];

    // Pick 2 random positions that will share the prime
    var idx1 = Math.floor(Math.random() * numKeys);
    var idx2;
    do { idx2 = Math.floor(Math.random() * numKeys); } while (idx2 === idx1);
    var sharedSet = {};
    sharedSet[idx1] = true;
    sharedSet[idx2] = true;
    vulnerableIndices = [idx1, idx2];

    for (var i = 0; i < numKeys; i++) {
        var p, q;
        if (sharedSet[i]) {
            p = sharedP;
            q = M.randomPrime(halfBits);
        } else {
            p = M.randomPrime(halfBits);
            q = M.randomPrime(halfBits);
        }
        var key = M.rsaKeyFromPQ(p, q);
        allKeys.push({ n: key.n, e: key.e, p: p, q: q, d: key.d });
    }

    // Encrypt the flag with the first vulnerable key
    var targetIdx = idx1;
    var targetKey = allKeys[targetIdx];
    var m = M.textToNumber(flag);
    if (m >= targetKey.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, targetKey.e, targetKey.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. You have ' + numKeys + ' public keys. The flag is encrypted with key #' + (targetIdx + 1) + '.',
        '2. Some keys may share a common prime factor (lazy key generation).',
        '3. Compute pairwise GCDs: gcd(n_i, n_j) for all pairs.',
        '4. If gcd(n_i, n_j) > 1, you have found a shared prime factor.',
        '5. Use the shared factor to compute the private key and decrypt.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        var pubKeys = allKeys.map(function(k, i) {
            return { id: i + 1, n: k.n.toString(), e: k.e.toString() };
        });

        return {
            meta: makeMeta('rsa_commonFactor', 'easy'),
            challenge: {
                target_key: targetIdx + 1,
                c: c.toString(),
                public_keys: pubKeys,
                note: 'The flag was encrypted with key #' + (targetIdx + 1) + '. These keys were generated by a batch process with a flawed RNG.'
            },
            solution: {
                flag: flag, hash: hash,
                shared_prime: sharedP.toString(),
                vulnerable_keys: vulnerableIndices.map(function(i) { return i + 1; }),
                target_d: targetKey.d.toString(),
                method: 'Batch GCD — keys #' + (idx1+1) + ' and #' + (idx2+1) + ' share prime ' + sharedP.toString().substring(0,20) + '...'
            },
            hints: hints
        };
    });
}

// ─── Type 15: Low Exponent / Cube Root ──────────────────────────────

function generateCubeRoot(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 512;
    var halfBits = Math.floor(bits / 2);
    var e = opts.exponent ? BigInt(opts.exponent) : 3n;

    var m = M.textToNumber(flag);
    var mBits = M.bitLength(m);

    // n must be larger than m^e so cube root works directly
    var minNBits = mBits * Number(e) + 10;
    var actualBits = Math.max(bits, minNBits);
    var actualHalf = Math.floor(actualBits / 2);

    var p, q, n, phi;
    var attempts = 0;
    while (attempts < 100) {
        p = M.randomPrime(actualHalf);
        q = M.randomPrime(actualHalf);
        n = p * q;
        phi = (p - 1n) * (q - 1n);
        if (M.gcd(e, phi) === 1n && m < n) break;
        attempts++;
    }

    var c = M.rsaEncrypt(m, e, n);

    // Verify: m^e < n (so integer e-th root works)
    var me = M.modPow(m, e, n + 1n); // compute m^e mod (n+1) — if m^e < n this equals m^e
    if (me !== c) {
        // m^e >= n, need bigger key
        throw new Error('m^e >= n, increase key size');
    }

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. Notice the public exponent is very small: e=' + e.toString() + '.',
        '2. If the message m is small enough, m^' + e.toString() + ' < n.',
        '3. When m^e < n, the modular reduction does nothing: c = m^' + e.toString() + '.',
        '4. Simply compute the integer ' + e.toString() + '-th root of c.',
        '5. In Python: m = gmpy2.iroot(c, ' + e.toString() + ')[0] or int(c ** (1/' + e.toString() + ')).'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_cubeRoot', 'easy'),
            challenge: {
                n: n.toString(), e: e.toString(), c: c.toString(),
                note: 'Standard RSA encryption with a very small public exponent.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                m: m.toString(),
                method: 'Low exponent — m^' + e.toString() + ' < n, take integer ' + e.toString() + '-th root of c'
            },
            hints: hints
        };
    });
}

// ─── Type 16: Common Modulus Attack ─────────────────────────────────

function generateCommonModulus(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var n = p * q;
    var phi = (p - 1n) * (q - 1n);

    // Two coprime exponents
    var e1, e2;
    var attempts = 0;
    while (attempts < 100) {
        e1 = M.randomPrime(16);
        e2 = M.randomPrime(16);
        if (e1 !== e2 && M.gcd(e1, phi) === 1n && M.gcd(e2, phi) === 1n && M.gcd(e1, e2) === 1n) break;
        attempts++;
    }

    var m = M.textToNumber(flag);
    if (m >= n) throw new Error('Flag too long for key size');
    var c1 = M.rsaEncrypt(m, e1, n);
    var c2 = M.rsaEncrypt(m, e2, n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The same message was encrypted with the same modulus n but two different exponents.',
        '2. This is the common modulus attack (also called "same-n" attack).',
        '3. Since gcd(e1, e2) = 1, find integers a, b such that a*e1 + b*e2 = 1 (extended GCD).',
        '4. Then m = c1^a * c2^b mod n. Handle negative exponents with modular inverse.',
        '5. In Python: a, b = extended_gcd(e1, e2); m = pow(c1, a, n) * pow(c2, b, n) % n.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_commonModulus', 'easy'),
            challenge: {
                n: n.toString(),
                e1: e1.toString(), c1: c1.toString(),
                e2: e2.toString(), c2: c2.toString(),
                note: 'The same plaintext was encrypted twice with the same n but different exponents.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                method: 'Common modulus — Bezout coefficients: a*e1 + b*e2 = 1, then m = c1^a * c2^b mod n'
            },
            hints: hints
        };
    });
}

// ─── Type 17: Fermat Factorization (close primes) ───────────────────

function generateFermat(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;

    var primes = M.generateClosePrimes(bits);
    var p = primes.p, q = primes.q;
    if (p > q) { var tmp = p; p = q; q = tmp; }
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var diff = q - p;

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The primes p and q are suspiciously close together.',
        '2. When |p - q| is small, Fermat factorization is very efficient.',
        '3. Start with a = ceil(sqrt(n)), compute b^2 = a^2 - n, check if b^2 is a perfect square.',
        '4. If b^2 is a perfect square, then n = (a-b)(a+b), giving p = a-b, q = a+b.',
        '5. In Python: a = isqrt(n) + 1; while not is_square(a*a - n): a += 1; b = isqrt(a*a-n); p,q = a-b, a+b.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_fermat', 'medium'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                note: 'Standard RSA. The key generation process may have a subtle weakness.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                prime_difference: diff.toString(),
                method: 'Fermat factorization — |p-q| = ' + diff.toString() + ' (very small)'
            },
            hints: hints
        };
    });
}

// ─── Type 18: dp Leak (CRT Exponent) ────────────────────────────────

function generateDpLeak(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    var p = M.randomPrime(halfBits);
    var q = M.randomPrime(halfBits);
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var dp = key.d % (p - 1n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. You have dp = d mod (p-1), the CRT exponent for prime p.',
        '2. For any integer x: x^(e*dp) ≡ x mod p (by Fermat\'s little theorem).',
        '3. So gcd(pow(2, e*dp, n) - 2, n) reveals p (with high probability).',
        '4. Once p is found: q = n/p, phi = (p-1)(q-1), d = e^{-1} mod phi.',
        '5. In Python: p = gcd(pow(2, e*dp, n) - 2, n); assert n % p == 0.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_dpLeak', 'medium'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                dp: dp.toString(),
                note: 'A side-channel attack leaked the CRT exponent dp = d mod (p-1).'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                dp: dp.toString(), dq: key.dq.toString(),
                method: 'dp leak — compute gcd(2^(e*dp) - 2, n) to recover p'
            },
            hints: hints
        };
    });
}

// ─── Type 19: Rabin Cryptosystem (e=2) ──────────────────────────────

function generateRabin(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;
    var halfBits = Math.floor(bits / 2);

    // Rabin requires p ≡ q ≡ 3 mod 4 for easy square root computation
    var p, q;
    var attempts = 0;
    while (attempts < 10000) {
        p = M.randomPrime(halfBits);
        if (p % 4n === 3n) break;
        attempts++;
    }
    attempts = 0;
    while (attempts < 10000) {
        q = M.randomPrime(halfBits);
        if (q % 4n === 3n && q !== p) break;
        attempts++;
    }

    var n = p * q;
    var m = M.textToNumber(flag);
    if (m >= n) throw new Error('Flag too long for key size');

    // e = 2 (Rabin encryption is squaring)
    var c = (m * m) % n;

    // Four square roots mod n using CRT
    var mp = M.modPow(c, (p + 1n) / 4n, p);
    var mq = M.modPow(c, (q + 1n) / 4n, q);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The public exponent is e=2. This is the Rabin cryptosystem, not standard RSA.',
        '2. Encryption: c = m^2 mod n. Decryption requires computing square roots mod n.',
        '3. If you can factor n, compute sqrt(c) mod p and sqrt(c) mod q separately.',
        '4. Use CRT to combine — you get 4 candidate plaintexts. The real flag is the readable one.',
        '5. For p ≡ 3 mod 4: sqrt(c) mod p = c^((p+1)/4) mod p.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_rabin', 'medium'),
            challenge: {
                n: n.toString(), e: '2', c: c.toString(),
                note: 'The public exponent is 2. This is not standard RSA — think about what encryption with e=2 means.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                sqrt_mod_p: mp.toString(), sqrt_mod_q: mq.toString(),
                method: 'Rabin cryptosystem — factor n, compute square roots mod p and q, combine with CRT'
            },
            hints: hints
        };
    });
}

// ─── Type 20: Twin Primes ───────────────────────────────────────────

function generateTwinPrimes(flag, opts) {
    opts = opts || {};
    var bits = opts.bits || 256;

    var twins = M.generateTwinPrimes(bits);
    var p = twins.p, q = twins.q;
    var key = M.rsaKeyFromPQ(p, q);
    var m = M.textToNumber(flag);
    if (m >= key.n) throw new Error('Flag too long for key size');
    var c = M.rsaEncrypt(m, key.e, key.n);

    var hintCount = opts.hintCount || 5;
    var hints = [
        '1. The two primes are very special — they differ by exactly 2.',
        '2. Twin primes: q = p + 2. So n = p(p+2) = p^2 + 2p.',
        '3. Rearrange: p^2 + 2p - n = 0. Solve with the quadratic formula.',
        '4. p = (-2 + sqrt(4 + 4n)) / 2 = sqrt(n + 1) - 1.',
        '5. In Python: p = isqrt(n + 1) - 1; assert n % p == 0.'
    ].slice(0, hintCount);

    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rsa_twinPrimes', 'easy'),
            challenge: {
                n: key.n.toString(), e: key.e.toString(), c: c.toString(),
                note: 'These primes have a very special mathematical relationship.'
            },
            solution: {
                flag: flag, hash: hash,
                p: p.toString(), q: q.toString(),
                d: key.d.toString(), phi: key.phi.toString(),
                method: 'Twin primes — q = p + 2, solve p = sqrt(n+1) - 1'
            },
            hints: hints
        };
    });
}

// ─── Public API ─────────────────────────────────────────────────────

var GENERATORS = {
    // Easy
    evenModulus:      { fn: generateEvenModulus,      label: 'Even Modulus N',            difficulty: 'easy'   },
    smallFactor:      { fn: generateSmallFactor,       label: 'Small Factor q',            difficulty: 'easy'   },
    knownPhiLeak:     { fn: generateKnownPhiLeak,      label: 'Known phi(n) / p+q Leak',  difficulty: 'easy'   },
    commonFactor:     { fn: generateCommonFactor,      label: 'Common Factor (Batch GCD)', difficulty: 'easy'   },
    cubeRoot:         { fn: generateCubeRoot,           label: 'Low Exponent (Cube Root)',  difficulty: 'easy'   },
    commonModulus:    { fn: generateCommonModulus,      label: 'Common Modulus Attack',     difficulty: 'easy'   },
    twinPrimes:       { fn: generateTwinPrimes,         label: 'Twin Primes',               difficulty: 'easy'   },
    // Medium
    smoothPrime:      { fn: generateSmoothPrime,      label: 'Pollard p-1 (Smooth Prime)',difficulty: 'medium' },
    wienerAttack:     { fn: generateWienerAttack,     label: 'Wiener\'s Attack',          difficulty: 'medium' },
    multiPrime:       { fn: generateMultiPrime,        label: 'Multi-Prime RSA',           difficulty: 'medium' },
    sideChannel:      { fn: generateSideChannel,       label: 'Side-Channel Hint',         difficulty: 'medium' },
    hastadBroadcast:  { fn: generateHastadBroadcast,   label: 'Hastad Broadcast',          difficulty: 'medium' },
    fermat:           { fn: generateFermat,             label: 'Fermat Factorization',      difficulty: 'medium' },
    dpLeak:           { fn: generateDpLeak,             label: 'dp Leak (CRT Exponent)',    difficulty: 'medium' },
    rabin:            { fn: generateRabin,              label: 'Rabin Cryptosystem (e=2)',   difficulty: 'medium' },
    // Hard
    partialKeyLeak:   { fn: generatePartialKeyLeak,   label: 'Partial Key Leak',          difficulty: 'hard'   },
    partialPEM:       { fn: generatePartialPEM,        label: 'Partial PEM Leak',          difficulty: 'hard'   },
    rocaWeak:         { fn: generateROCA,              label: 'ROCA-Style Weak Primes',    difficulty: 'hard'   },
    franklinReiter:   { fn: generateFranklinReiter,    label: 'Franklin-Reiter',           difficulty: 'hard'   },
    // Pro
    paddingOracle:    { fn: generatePaddingOracle,     label: 'Padding Oracle',            difficulty: 'pro'    }
};

var Engine = {
    GENERATORS: GENERATORS,

    generate: function(type, flag, opts) {
        var gen = GENERATORS[type];
        if (!gen) return Promise.reject(new Error('Unknown RSA challenge type: ' + type));
        return gen.fn(flag, opts).then(function(bundle) {
            bundle.note = 'Generated by 8gwifi.org RSA CTF Generator \u2014 ' + ENGINE_URL;
            return bundle;
        });
    },

    listTypes: function() {
        var list = [];
        for (var id in GENERATORS) {
            list.push({ id: id, label: GENERATORS[id].label, difficulty: GENERATORS[id].difficulty });
        }
        return list;
    },

    generateRandom: function(flag, difficulty, opts) {
        var candidates = [];
        for (var id in GENERATORS) {
            if (!difficulty || GENERATORS[id].difficulty === difficulty) {
                candidates.push(id);
            }
        }
        if (candidates.length === 0) return Promise.reject(new Error('No generators for difficulty: ' + difficulty));
        var pick = candidates[Math.floor(Math.random() * candidates.length)];
        return Engine.generate(pick, flag, opts);
    }
};

global.CTFRSAEngine = Engine;

})(typeof window !== 'undefined' ? window : (typeof global !== 'undefined' ? global : this));
