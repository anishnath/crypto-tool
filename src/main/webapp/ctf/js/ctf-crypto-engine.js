/**
 * CTF Crypto Challenge Engine
 * Generates crypto-only CTF challenges (ciphertext output, no file embedding).
 * Depends on: ctf-steps.js (CTFSteps), ctf-engine.js (CTFEngine).
 *
 * Challenge types:
 *   - standard:       Single pipeline producing one ciphertext
 *   - multiPart:      Flag split into N parts, each encoded differently
 *   - cribDrag:       Two plaintexts XOR'd with the same key
 *   - hashCrack:      SHA-256 hash of the flag — find the preimage
 *   - cipherIdentify: Identify the cipher from the ciphertext (multiple choice)
 *   - keyReuse:       Same Vigenère/XOR key on two messages
 */
(function(global) {
'use strict';

var Engine = global.CTFEngine;
var steps  = global.CTFSteps || {};

if (!Engine) throw new Error('CTFEngine not loaded. Load ctf-engine.js before ctf-crypto-engine.js');

/* ===== Seeded PRNG (local copy for independence) ===== */
function mulberry32(seed) {
    var s = seed >>> 0;
    return function() {
        s = (s + 0x6D2B79F5) >>> 0;
        var t = Math.imul(s ^ (s >>> 15), s | 1);
        t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
        return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
}
function createRng(seed) {
    return (seed != null) ? mulberry32(seed) : Math.random;
}

/* ===== PARAM_RANGES for ALL crypto steps (covers every step used in pipelines) ===== */
var CRYPTO_PARAM_RANGES = {
    // Phase 1 encodings
    a1z26:    { separator: ['-', ' ', '.', ','] },
    ascii85:  {},
    nato:     {},
    phoneKeypad: {},
    tapCode:  {},
    urlEncode: {},

    // Phase 2 classical
    affine:   { a: [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25], b: [1, 25] },
    playfair: { key: ['CRYPTO', 'PLAYFAIR', 'MONARCHY', 'KEYWORD', 'CIPHER', 'ENIGMA', 'SECURITY', 'ZEBRAS', 'REPUBLIC'] },
    beaufort: { key: ['SECRET', 'CIPHER', 'BRAVO', 'ENIGMA', 'FOXTROT', 'KRYPTON', 'VORTEX'] },
    autokey:  { key: ['KEY', 'AUTO', 'CIPHER', 'SECRET', 'DELTA', 'GAMMA', 'ALPHA'] },
    bifid:    {},
    otp:      { key: ['alpha1', 'bravo2', 'charlie3', 'delta4', 'echo55', 'foxtrot6', 'golf77', 'hotel8'] },
    nihilist: { key: ['KEY', 'NIHILIST', 'CIPHER', 'RUSSIAN', 'SECRET', 'MOSCOW', 'ENIGMA'] },

    // Phase 3 modern
    rc4:      { key: ['rc4key', 'stream', 'cipher', 'crypto', 'keystream', 'arcfour', 'rivest', 'prga'] },
    hillCipher: { matrix: [[3,3,2,5], [5,8,17,3], [6,24,1,13], [2,4,5,9], [9,4,5,7], [7,8,11,11]] },
    rsaTextbook: { p: [61, 67, 71, 73, 89, 97], q: [53, 59, 79, 83, 101, 103], e: [17, 19, 23, 29, 37] },
    adfgvx:   { key: ['CIPHER', 'GERMAN', 'ATTACK', 'SECRET', 'STRIKE', 'FRANCE'], gridKey: ['FIELD', 'BATTLE', '', 'TRENCH', 'FRONT'] },

    // Steps that previously had NO param variety
    xor:      { key: ['xorkey', 'secret', 'ctf2024', 'hidden', 'crypto', 'flag_xor', 'deadbeef', 'keyXOR'] },
    encrypt:  { password: ['aes_pass', 'ctf_secret', 'encrypted!', 'p@ssw0rd', 'challenge1', 'crypto_key'] },
    polybius: {},
    bacon:    {},
    morse:    {},
    binary:   {},
    base64:   {},
    hex:      {},
    base32:   {},
    octal:    {},
    decimal:  {},
    rot13:    {},
    rot47:    {},
    atbash:   {},
    reverse:  {},
    compress: {}
};

/**
 * Randomize params for crypto-specific steps (supplements Engine.randomizeParams).
 * Covers all steps including xor keys, encrypt passwords, etc.
 */
function randomizeCryptoParams(pipeline, options) {
    options = options || {};
    var rng = createRng(options.seed);
    var out = JSON.parse(JSON.stringify(pipeline));

    for (var i = 0; i < out.length; i++) {
        var s = out[i];
        var ranges = CRYPTO_PARAM_RANGES[s.id] || Engine.PARAM_RANGES[s.id];
        if (!ranges) continue;
        s.params = s.params || {};

        for (var key in ranges) {
            var val = ranges[key];
            if (!Array.isArray(val) || val.length === 0) continue;
            if (s.params[key] != null && key !== 'a' && key !== 'b') continue;
            if (typeof val[0] === 'number' && val.length === 2 && !Array.isArray(val[0])) {
                var lo = val[0], hi = val[1];
                s.params[key] = Math.floor(rng() * (hi - lo + 1)) + lo;
            } else if (Array.isArray(val[0])) {
                s.params[key] = JSON.parse(JSON.stringify(val[Math.floor(rng() * val.length)]));
            } else {
                s.params[key] = val[Math.floor(rng() * val.length)];
            }
        }
    }
    return out;
}

/* ================================================================
 *  CRYPTO PIPELINE POOL — expanded with all new steps
 * ================================================================ */
var CRYPTO_PIPELINE_POOL = {
    easy: [
        [{ id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'rot13', params: {} }, { id: 'output', params: {} }],
        [{ id: 'morse', params: {} }, { id: 'output', params: {} }],
        [{ id: 'binary', params: {} }, { id: 'output', params: {} }],
        [{ id: 'atbash', params: {} }, { id: 'output', params: {} }],
        [{ id: 'a1z26', params: {} }, { id: 'output', params: {} }],
        [{ id: 'nato', params: {} }, { id: 'output', params: {} }],
        [{ id: 'phoneKeypad', params: {} }, { id: 'output', params: {} }],
        [{ id: 'tapCode', params: {} }, { id: 'output', params: {} }],
        [{ id: 'urlEncode', params: {} }, { id: 'output', params: {} }],
        [{ id: 'ascii85', params: {} }, { id: 'output', params: {} }],
        [{ id: 'octal', params: {} }, { id: 'output', params: {} }],
        [{ id: 'decimal', params: {} }, { id: 'output', params: {} }],
        [{ id: 'base32', params: {} }, { id: 'output', params: {} }],
        [{ id: 'rot47', params: {} }, { id: 'output', params: {} }]
    ],
    medium: [
        [{ id: 'base64', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'caesar', params: { shift: 7 } }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'vigenere', params: { key: 'CTF' } }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'atbash', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'railFence', params: { rails: 4 } }, { id: 'base32', params: {} }, { id: 'output', params: {} }],
        [{ id: 'rot47', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'bacon', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'reverse', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'affine', params: { a: 5, b: 8 } }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'beaufort', params: { key: 'CIPHER' } }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'autokey', params: { key: 'SECRET' } }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'a1z26', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'nato', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'phoneKeypad', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'tapCode', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'nihilist', params: { key: 'KEY' } }, { id: 'base64', params: {} }, { id: 'output', params: {} }]
    ],
    hard: [
        [{ id: 'xor', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'compress', params: {} }, { id: 'base64', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'vigenere', params: {} }, { id: 'atbash', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'columnarTransposition', params: {} }, { id: 'base32', params: {} }, { id: 'output', params: {} }],
        [{ id: 'polybius', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'decoy', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'substitution', params: {} }, { id: 'octal', params: {} }, { id: 'output', params: {} }],
        [{ id: 'railFence', params: {} }, { id: 'binary', params: {} }, { id: 'output', params: {} }],
        [{ id: 'playfair', params: { key: 'CRYPTO' } }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'bifid', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'rc4', params: { key: 'stream' } }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'otp', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'adfgvx', params: { key: 'GERMAN' } }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'nihilist', params: {} }, { id: 'hex', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'affine', params: {} }, { id: 'railFence', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'hillCipher', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }]
    ],
    pro: [
        [{ id: 'encrypt', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'compress', params: {} }, { id: 'encrypt', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'xor', params: {} }, { id: 'base32', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'vigenere', params: {} }, { id: 'caesar', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'substitution', params: {} }, { id: 'columnarTransposition', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'encrypt', params: {} }, { id: 'hex', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'rsaTextbook', params: { p: 61, q: 53, e: 17 } }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'rc4', params: {} }, { id: 'compress', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'playfair', params: {} }, { id: 'adfgvx', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'hillCipher', params: {} }, { id: 'vigenere', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }],
        [{ id: 'beaufort', params: {} }, { id: 'bifid', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        [{ id: 'autokey', params: {} }, { id: 'affine', params: {} }, { id: 'hex', params: {} }, { id: 'output', params: {} }]
    ]
};

/* ===== Hint map for new crypto steps ===== */
var CRYPTO_HINT_MAP = {
    a1z26:    'A=1, B=2, ..., Z=26 encoding. Look for dash-separated numbers 1-26.',
    affine:   'Affine cipher: E(x) = (ax + b) mod 26. a must be coprime with 26.',
    ascii85:  'ASCII85 / Base85 encoding. Look for <~ ... ~> delimiters.',
    nato:     'NATO phonetic alphabet. Alpha=A, Bravo=B, Charlie=C, etc.',
    phoneKeypad: 'Phone keypad multi-tap: 2=A, 22=B, 222=C, 3=D, 33=E, etc.',
    tapCode:  'Tap code: 5×5 grid with K=C. Pairs like 2.3 = row 2, column 3.',
    urlEncode: 'URL encoding: %xx hex values for each character.',
    playfair: 'Playfair cipher: digraph substitution using a 5×5 grid. J→I.',
    beaufort: 'Beaufort cipher: Ci = (Ki − Pi) mod 26. Self-reciprocal.',
    autokey:  'Autokey cipher: Vigenère variant where plaintext extends the key.',
    bifid:    'Bifid cipher: Polybius coordinates transposed then recombined.',
    otp:      'One-time pad (XOR). Key must be as long as the message.',
    rc4:      'RC4 stream cipher. Needs the key to generate the keystream.',
    hillCipher: 'Hill cipher: 2×2 matrix multiplication mod 26. Need the matrix.',
    rsaTextbook: 'Textbook RSA. Factor N into p×q to compute private key d.',
    adfgvx:   'ADFGVX cipher (WW1). Polybius fractionation + columnar transposition.',
    nihilist: 'Nihilist cipher: Polybius numbers added with keyword numbers.'
};

/* ===== Helper: merge hint maps ===== */
function getCryptoHint(stepId) {
    return CRYPTO_HINT_MAP[stepId] || null;
}

/**
 * Generate hints for a crypto pipeline, using both base and crypto hint maps.
 */
function generateCryptoHints(pipeline, options) {
    options = options || {};
    var count = (options.count != null) ? options.count : 5;
    var baseHints = Engine.generateHints(pipeline, { count: count, includeKeys: false });
    var hints = [];
    var seen = {};

    for (var i = 0; i < baseHints.length; i++) {
        if (baseHints[i].indexOf('Work backwards') < 0) {
            hints.push(baseHints[i]);
            seen[baseHints[i]] = true;
        }
    }

    var termIdx = -1;
    for (var t = 0; t < pipeline.length; t++) {
        if (pipeline[t].id === 'output') { termIdx = t; break; }
    }
    var pre = pipeline.slice(0, termIdx >= 0 ? termIdx : pipeline.length);
    for (var j = pre.length - 1; j >= 0 && hints.length < count; j--) {
        var h = getCryptoHint(pre[j].id);
        if (h && !seen[h]) {
            hints.push((hints.length + 1) + '. ' + h);
            seen[h] = true;
        }
    }

    while (hints.length < count) {
        hints.push((hints.length + 1) + '. Work backwards: each layer decodes before the next.');
    }
    return hints.slice(0, count);
}

/**
 * Extract keys needed for decode from pipeline + options.
 */
function extractKeysFromPipeline(pipeline, options) {
    var keys = {};
    for (var i = 0; i < pipeline.length; i++) {
        var s = pipeline[i];
        var p = s.params || {};
        if (s.id === 'encrypt' && (p.password || options.password || options.key)) keys.password = p.password || options.password || options.key;
        if (s.id === 'xor' && (p.key || options.key || options.password)) keys.xorKey = p.key || options.key || options.password;
        if (s.id === 'vigenere' && (p.key || options.key)) keys.vigenereKey = p.key || options.key;
        if (s.id === 'columnarTransposition' && (p.key || options.key)) keys.columnarKey = p.key || options.key;
        if (s.id === 'caesar' && p.shift != null) keys.caesarShift = p.shift;
        if (s.id === 'affine' && p.a != null) { keys.affineA = p.a; keys.affineB = p.b; }
        if (s.id === 'playfair' && p.key) keys.playfairKey = p.key;
        if (s.id === 'beaufort' && p.key) keys.beaufortKey = p.key;
        if (s.id === 'autokey' && p.key) keys.autokeyKey = p.key;
        if (s.id === 'otp' && p.key) keys.otpKey = p.key;
        if (s.id === 'rc4' && p.key) keys.rc4Key = p.key;
        if (s.id === 'hillCipher' && p.matrix) keys.hillMatrix = p.matrix;
        if (s.id === 'rsaTextbook') { keys.rsaP = p.p; keys.rsaQ = p.q; keys.rsaE = p.e; }
        if (s.id === 'adfgvx') { if (p.key) keys.adfgvxKey = p.key; if (p.gridKey) keys.adfgvxGridKey = p.gridKey; }
        if (s.id === 'nihilist' && p.key) keys.nihilistKey = p.key;
        if (s.id === 'railFence' && p.rails != null) keys.railFenceRails = p.rails;
        if (s.id === 'substitution' && p.alphabet) keys.substitutionAlphabet = p.alphabet;
        if (s.id === 'decoy' && p.marker) keys.decoyMarker = p.marker;
    }
    return keys;
}

/**
 * Get a random crypto pipeline from the pool.
 */
function getRandomCryptoPipeline(difficulty, options) {
    options = options || {};
    var pool = CRYPTO_PIPELINE_POOL[difficulty] || CRYPTO_PIPELINE_POOL.medium;
    var rng = createRng(options.seed);
    var pipeline = JSON.parse(JSON.stringify(pool[Math.floor(rng() * pool.length)]));

    pipeline = randomizeCryptoParams(pipeline, { seed: options.seed != null ? options.seed + 1 : undefined });

    if (options.randomizeParams !== false) {
        pipeline = Engine.randomizeParams(pipeline, { seed: options.seed != null ? options.seed + 2 : undefined });
    }
    return pipeline;
}

/* ================================================================
 *  DYNAMIC PIPELINE COMPOSER — build pipelines on the fly
 *  Instead of fixed templates, randomly combine compatible steps.
 * ================================================================ */

var STEP_CATEGORIES = {
    simpleEncoding: ['base64', 'hex', 'base32', 'octal', 'decimal', 'binary', 'ascii85', 'urlEncode'],
    humanReadable:  ['morse', 'nato', 'phoneKeypad', 'tapCode', 'a1z26', 'bacon'],
    selfInverse:    ['rot13', 'rot47', 'atbash', 'reverse'],
    keyedClassical: ['caesar', 'vigenere', 'affine', 'beaufort', 'autokey', 'railFence', 'columnarTransposition', 'substitution', 'nihilist'],
    gridCipher:     ['playfair', 'polybius', 'bifid', 'adfgvx', 'hillCipher'],
    keyedModern:    ['xor', 'otp', 'rc4', 'encrypt'],
    asymmetric:     ['rsaTextbook'],
    container:      ['decoy', 'compress']
};

// Steps that only accept/produce uppercase alpha (lose non-alpha, case, specials).
// These should only appear as the FIRST step in a composed pipeline.
var ALPHA_ONLY_STEPS = ['playfair', 'bifid', 'bacon', 'polybius', 'hillCipher', 'adfgvx', 'nihilist', 'morse', 'a1z26', 'tapCode', 'nato', 'phoneKeypad'];

// Steps that produce binary/base64 output (not raw text).
var BINARY_OUTPUT_STEPS = ['xor', 'otp', 'rc4', 'encrypt', 'compress'];

// Steps that are lossy in the middle of a chain (padding, truncation, etc.)
var FIRST_ONLY_STEPS = ['playfair', 'bifid', 'hillCipher', 'adfgvx', 'bacon', 'polybius', 'nihilist', 'morse', 'a1z26', 'tapCode', 'nato', 'phoneKeypad'];

/**
 * Check if step A's output is compatible as input to step B.
 */
function isCompatible(stepA, stepB) {
    if (BINARY_OUTPUT_STEPS.indexOf(stepA) >= 0) {
        return ALPHA_ONLY_STEPS.indexOf(stepB) < 0;
    }
    return true;
}

/**
 * Compose a random pipeline dynamically.
 * @param {string} difficulty - easy, medium, hard, pro
 * @param {object} options - { seed?: number }
 * @returns {Array} Pipeline ending with { id: 'output' }
 */
function composePipeline(difficulty, options) {
    options = options || {};
    var rng = createRng(options.seed);

    function pick(arr) { return arr[Math.floor(rng() * arr.length)]; }
    function pickN(arr, n) {
        var copy = arr.slice();
        var result = [];
        for (var i = 0; i < n && copy.length > 0; i++) {
            var idx = Math.floor(rng() * copy.length);
            result.push(copy[idx]);
            copy.splice(idx, 1);
        }
        return result;
    }

    var pipeline = [];
    var cat = STEP_CATEGORIES;

    // Safe steps for non-first positions (no lossy alpha-only steps)
    var safeClassical = cat.keyedClassical.filter(function(id) { return FIRST_ONLY_STEPS.indexOf(id) < 0; });
    var safeModern = cat.keyedModern;

    if (difficulty === 'easy') {
        var allEasy = cat.simpleEncoding.concat(cat.humanReadable, cat.selfInverse);
        pipeline.push({ id: pick(allEasy), params: {} });
    } else if (difficulty === 'medium') {
        var pattern = rng();
        if (pattern < 0.3) {
            pipeline.push({ id: pick(cat.keyedClassical), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else if (pattern < 0.5) {
            pipeline.push({ id: pick(cat.selfInverse), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else if (pattern < 0.7) {
            pipeline.push({ id: pick(cat.humanReadable), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else {
            pipeline.push({ id: pick(cat.gridCipher), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        }
    } else if (difficulty === 'hard') {
        var pattern2 = rng();
        if (pattern2 < 0.25) {
            pipeline.push({ id: pick(cat.keyedModern), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else if (pattern2 < 0.5) {
            pipeline.push({ id: pick(cat.gridCipher), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else if (pattern2 < 0.75) {
            pipeline.push({ id: pick(safeClassical), params: {} });
            pipeline.push({ id: pick(safeClassical), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else {
            pipeline.push({ id: pick(cat.container), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        }
    } else {
        var pattern3 = rng();
        if (pattern3 < 0.25) {
            pipeline.push({ id: pick(cat.keyedModern), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else if (pattern3 < 0.5) {
            pipeline.push({ id: pick(cat.gridCipher), params: {} });
            pipeline.push({ id: pick(safeClassical), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else if (pattern3 < 0.75) {
            pipeline.push({ id: pick(cat.asymmetric), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        } else {
            pipeline.push({ id: pick(safeClassical), params: {} });
            pipeline.push({ id: pick(safeModern), params: {} });
            pipeline.push({ id: pick(cat.simpleEncoding), params: {} });
        }
    }

    // Validate compatibility; swap incompatible pairs
    for (var i = 0; i < pipeline.length - 1; i++) {
        if (!isCompatible(pipeline[i].id, pipeline[i + 1].id)) {
            var bridge = { id: 'base64', params: {} };
            pipeline.splice(i + 1, 0, bridge);
        }
    }

    // Ensure no duplicate step ids (swap duplicates)
    var seen = {};
    for (var j = 0; j < pipeline.length; j++) {
        if (seen[pipeline[j].id]) {
            var alternatives = cat.simpleEncoding.filter(function(id) { return !seen[id]; });
            if (alternatives.length > 0) pipeline[j] = { id: pick(alternatives), params: {} };
        }
        seen[pipeline[j].id] = true;
    }

    pipeline.push({ id: 'output', params: {} });

    // Randomize params
    pipeline = randomizeCryptoParams(pipeline, { seed: options.seed != null ? options.seed + 10 : undefined });
    pipeline = Engine.randomizeParams(pipeline, { seed: options.seed != null ? options.seed + 20 : undefined });

    return pipeline;
}

/* ================================================================
 *  CHALLENGE GENERATORS
 * ================================================================ */

/**
 * Standard crypto challenge: single pipeline → ciphertext.
 * options.compose = true  → dynamic pipeline (huge variety)
 * options.compose = false → pick from fixed pool (default)
 */
function generateCryptoChallenge(message, difficulty, options) {
    options = options || {};
    var pipeline;
    if (options.pipeline && Array.isArray(options.pipeline)) {
        pipeline = JSON.parse(JSON.stringify(options.pipeline));
    } else if (options.compose) {
        pipeline = composePipeline(difficulty, { seed: options.seed });
    } else {
        pipeline = getRandomCryptoPipeline(difficulty, { seed: options.seed, randomizeParams: true });
    }

    var encOpts = Object.assign({}, options);
    if (pipeline.some(function(s) { return s.id === 'encrypt'; })) {
        encOpts.password = encOpts.password || encOpts.key || 'ctf_password_' + (options.seed || Date.now());
    }
    _injectKeysIntoOptions(pipeline, encOpts);

    return Engine.encode(pipeline, message, null, encOpts).then(function(result) {
        var ciphertext = typeof result === 'string' ? result : (result && result.payload) ? result.payload : '';
        return Engine.resultToBase64(result).then(function(challengeData) {
            return Engine.flagVerify(message).then(function(hash) {
                var keys = extractKeysFromPipeline(pipeline, encOpts);
                var hints = generateCryptoHints(pipeline, { count: options.hintCount || 5 });
                return {
                    meta: _meta(difficulty, 'crypto'),
                    challenge: {
                        ciphertext: ciphertext,
                        format: (challengeData && challengeData.format) || 'text',
                        data: challengeData ? challengeData.data : null,
                        mimeType: challengeData ? challengeData.mimeType : null,
                        filename: 'challenge.txt',
                        note: 'Decode the ciphertext to recover the flag.'
                    },
                    solution: {
                        flag: message,
                        pipeline: pipeline,
                        keys: Object.keys(keys).length > 0 ? keys : undefined,
                        hash: hash
                    },
                    hints: hints
                };
            });
        });
    });
}

/**
 * Multi-part challenge: flag split into N parts, each encoded separately.
 */
function generateMultiPartChallenge(message, difficulty, options) {
    options = options || {};
    var parts = (options.parts != null) ? options.parts : 3;
    var rng = createRng(options.seed);
    var partSize = Math.ceil(message.length / parts);
    var fragments = [];
    for (var i = 0; i < parts; i++) {
        fragments.push(message.slice(i * partSize, (i + 1) * partSize));
    }

    var promises = fragments.map(function(frag, idx) {
        var partSeed = options.seed != null ? options.seed + idx * 100 : undefined;
        return generateCryptoChallenge(frag, difficulty, {
            seed: partSeed,
            password: options.password,
            key: options.key,
            hintCount: 3
        });
    });

    return Promise.all(promises).then(function(bundles) {
        return Engine.flagVerify(message).then(function(hash) {
            return {
                meta: _meta(difficulty, 'multiPart'),
                challenge: {
                    parts: bundles.map(function(b, idx) {
                        return {
                            partIndex: idx + 1,
                            totalParts: parts,
                            ciphertext: b.challenge.ciphertext,
                            format: b.challenge.format,
                            hints: b.hints
                        };
                    }),
                    note: 'The flag has been split into ' + parts + ' parts. Decode each part and concatenate.'
                },
                solution: {
                    flag: message,
                    parts: bundles.map(function(b) { return b.solution; }),
                    hash: hash
                },
                hints: ['The flag is split into ' + parts + ' parts.', 'Each part uses a different cipher.', 'Concatenate the decoded parts in order.']
            };
        });
    });
}

/**
 * Crib-drag challenge: two plaintexts XOR'd with the same key.
 */
function generateCribDragChallenge(message, options) {
    options = options || {};
    var rng = createRng(options.seed);

    var KNOWN_TEXTS = [
        'The quick brown fox jumps over the lazy dog',
        'Hello World this is a known plaintext message',
        'In cryptography a crib is a known piece of text',
        'The flag is hidden in one of these two ciphertexts',
        'XOR with the same key reveals patterns when combined'
    ];
    var knownText = options.knownText || KNOWN_TEXTS[Math.floor(rng() * KNOWN_TEXTS.length)];

    var maxLen = Math.max(message.length, knownText.length);
    var padMsg = message;
    while (padMsg.length < maxLen) padMsg += ' ';
    var padKnown = knownText;
    while (padKnown.length < maxLen) padKnown += ' ';

    var keyLen = maxLen;
    var keyBytes = new Uint8Array(keyLen);
    for (var i = 0; i < keyLen; i++) keyBytes[i] = Math.floor(rng() * 256);

    var msgBytes = new TextEncoder().encode(padMsg);
    var knownBytes = new TextEncoder().encode(padKnown);
    var c1 = new Uint8Array(maxLen);
    var c2 = new Uint8Array(maxLen);
    for (var j = 0; j < maxLen; j++) {
        c1[j] = (j < msgBytes.length ? msgBytes[j] : 32) ^ keyBytes[j];
        c2[j] = (j < knownBytes.length ? knownBytes[j] : 32) ^ keyBytes[j];
    }

    function toHex(arr) {
        var s = '';
        for (var i = 0; i < arr.length; i++) {
            var h = arr[i].toString(16);
            s += (h.length === 1 ? '0' : '') + h;
        }
        return s;
    }

    return Engine.flagVerify(message).then(function(hash) {
        return {
            meta: _meta('hard', 'cribDrag'),
            challenge: {
                ciphertext1: toHex(c1),
                ciphertext2: toHex(c2),
                knownPlaintextHint: 'One of these messages is a well-known English sentence.',
                format: 'hex',
                note: 'Two messages encrypted with the same XOR key. Use crib dragging to recover the flag.'
            },
            solution: {
                flag: message,
                knownText: knownText,
                keyHex: toHex(keyBytes),
                hash: hash
            },
            hints: [
                '1. Both ciphertexts use the same XOR key.',
                '2. XOR the two ciphertexts together to eliminate the key.',
                '3. c1 ⊕ c2 = m1 ⊕ m2. Crib-drag a known phrase to recover the other.',
                '4. One message is an English sentence — try common phrases.',
                '5. The flag format starts with a recognizable prefix.'
            ]
        };
    });
}

/**
 * Hash-crack challenge: given SHA-256 hash, find the flag.
 */
function generateHashCrackChallenge(message, options) {
    options = options || {};
    var rng = createRng(options.seed);

    var WORDLIST_THEMES = {
        crypto: ['cipher', 'encrypt', 'decrypt', 'key', 'hash', 'aes', 'rsa', 'xor', 'salt', 'nonce', 'block', 'stream', 'padding', 'iv'],
        animals: ['cat', 'dog', 'fox', 'owl', 'bat', 'ant', 'bee', 'cow', 'emu', 'elk', 'hen', 'jay', 'ram', 'yak'],
        colors:  ['red', 'blue', 'green', 'cyan', 'gray', 'pink', 'gold', 'lime', 'navy', 'teal', 'plum', 'ruby']
    };

    var theme = options.theme || ['crypto', 'animals', 'colors'][Math.floor(rng() * 3)];
    var wordlist = WORDLIST_THEMES[theme] || WORDLIST_THEMES.crypto;
    if (wordlist.indexOf(message) < 0) wordlist.push(message);
    wordlist.sort(function() { return rng() - 0.5; });

    return Engine.flagVerify(message).then(function(hash) {
        return {
            meta: _meta('medium', 'hashCrack'),
            challenge: {
                hash: hash,
                algorithm: 'SHA-256',
                wordlist: options.includeWordlist !== false ? wordlist : undefined,
                note: 'Find the plaintext that produces this SHA-256 hash.'
            },
            solution: {
                flag: message,
                hash: hash
            },
            hints: [
                '1. The hash is SHA-256 (64 hex characters).',
                '2. Try each word in the wordlist.',
                '3. Hash each candidate and compare.',
                options.includeWordlist !== false ? '4. The flag is one of the ' + wordlist.length + ' words provided.' : '4. Think about common ' + theme + '-related words.',
                '5. No salt — straightforward comparison.'
            ]
        };
    });
}

/**
 * Cipher-identification challenge: recognize the cipher from ciphertext.
 */
function generateCipherIdentifyChallenge(message, options) {
    options = options || {};
    var rng = createRng(options.seed);

    var CIPHERS = [
        { id: 'base64',  label: 'Base64' },
        { id: 'hex',     label: 'Hexadecimal' },
        { id: 'morse',   label: 'Morse Code' },
        { id: 'binary',  label: 'Binary (8-bit)' },
        { id: 'rot13',   label: 'ROT13' },
        { id: 'base32',  label: 'Base32' },
        { id: 'a1z26',   label: 'A1Z26 (letter-number)' },
        { id: 'nato',    label: 'NATO Phonetic Alphabet' },
        { id: 'bacon',   label: "Bacon's Cipher" },
        { id: 'ascii85', label: 'ASCII85 / Base85' },
        { id: 'tapCode', label: 'Tap Code' },
        { id: 'phoneKeypad', label: 'Phone Keypad (T9)' },
        { id: 'octal',   label: 'Octal' },
        { id: 'decimal', label: 'Decimal ASCII' },
        { id: 'atbash',  label: 'Atbash Cipher' }
    ];

    var correctIdx = Math.floor(rng() * CIPHERS.length);
    var correct = CIPHERS[correctIdx];
    var impl = steps[correct.id];
    if (!impl || !impl.encode) {
        correct = CIPHERS[0];
        impl = steps[correct.id];
    }

    var encoded = impl.encode(message, {});

    var distractors = CIPHERS.filter(function(c) { return c.id !== correct.id; });
    distractors.sort(function() { return rng() - 0.5; });
    var choices = [correct].concat(distractors.slice(0, 3));
    choices.sort(function() { return rng() - 0.5; });

    return Engine.flagVerify(message).then(function(hash) {
        return {
            meta: _meta('easy', 'cipherIdentify'),
            challenge: {
                ciphertext: typeof encoded === 'string' ? encoded : String(encoded),
                question: 'What encoding/cipher was used to produce this ciphertext?',
                choices: choices.map(function(c) { return { id: c.id, label: c.label }; }),
                format: 'multipleChoice',
                note: 'Identify the cipher, then decode to get the flag.'
            },
            solution: {
                flag: message,
                cipherId: correct.id,
                cipherLabel: correct.label,
                hash: hash
            },
            hints: [
                '1. Look at the character set used in the ciphertext.',
                '2. ' + (getCryptoHint(correct.id) || 'Analyze the output pattern.'),
                '3. Each encoding has a distinctive format.',
                '4. Try decoding with the correct cipher to verify.',
                '5. The answer reveals the flag directly when decoded.'
            ]
        };
    });
}

/**
 * Key-reuse challenge: same key used on two different messages (Vigenère or XOR).
 */
function generateKeyReuseChallenge(message, options) {
    options = options || {};
    var rng = createRng(options.seed);

    var KNOWN_MESSAGES = [
        'THE QUICK BROWN FOX',
        'ATTACK AT DAWN',
        'MEET ME AT THE BRIDGE',
        'THE PASSWORD IS HIDDEN',
        'SEND REINFORCEMENTS'
    ];
    var knownMsg = options.knownMessage || KNOWN_MESSAGES[Math.floor(rng() * KNOWN_MESSAGES.length)];

    var cipherType = options.cipherType || (rng() > 0.5 ? 'vigenere' : 'xor');
    var key;
    if (cipherType === 'vigenere') {
        var KEYS = ['CRYPTO', 'SECRET', 'HIDDEN', 'ENIGMA', 'CIPHER'];
        key = options.key || KEYS[Math.floor(rng() * KEYS.length)];
    } else {
        key = options.key || 'xorkey' + Math.floor(rng() * 1000);
    }

    var impl = steps[cipherType];
    var params = cipherType === 'xor' ? { key: key } : { key: key };
    var ciphertext1 = impl.encode(message.toUpperCase(), params);
    var ciphertext2 = impl.encode(knownMsg, params);

    return Engine.flagVerify(message).then(function(hash) {
        return {
            meta: _meta('hard', 'keyReuse'),
            challenge: {
                ciphertext1: ciphertext1,
                ciphertext2: ciphertext2,
                knownPlaintext: knownMsg,
                cipherType: cipherType === 'vigenere' ? 'Vigenère' : 'XOR',
                format: 'text',
                note: 'Both ciphertexts were encrypted with the same ' + (cipherType === 'vigenere' ? 'Vigenère' : 'XOR') + ' key. The second plaintext is known. Recover the key, then decrypt the first message.'
            },
            solution: {
                flag: message,
                key: key,
                cipherType: cipherType,
                hash: hash
            },
            hints: [
                '1. Both messages use the same ' + (cipherType === 'vigenere' ? 'Vigenère' : 'XOR') + ' key.',
                '2. You have one plaintext and its corresponding ciphertext.',
                '3. Derive the key from the known plaintext-ciphertext pair.',
                '4. Apply the recovered key to decrypt the unknown ciphertext.',
                '5. The key length is ' + key.length + ' characters.'
            ]
        };
    });
}

/* ===== Helpers ===== */

function _meta(difficulty, type) {
    return {
        generator: '8gwifi.org CTF Crypto Challenge Generator',
        version: '1.0',
        url: 'https://8gwifi.org/ctf/crypto-ctf-generator.jsp',
        created: new Date().toISOString(),
        difficulty: difficulty,
        type: type
    };
}

/**
 * Inject keys into options ONLY for steps that lack them in params.
 * Avoids setting a global opts.key that would override different keys
 * in other steps via Object.assign in Engine.encode.
 */
function _injectKeysIntoOptions(pipeline, opts) {
    var keyedSteps = [];
    for (var i = 0; i < pipeline.length; i++) {
        var s = pipeline[i];
        var p = s.params || {};
        var needsKey = (s.id === 'xor' || s.id === 'otp' || s.id === 'rc4' ||
                        s.id === 'vigenere' || s.id === 'beaufort' || s.id === 'autokey' ||
                        s.id === 'columnarTransposition');
        if (needsKey && p.key) keyedSteps.push(s.id);
        if (s.id === 'encrypt' && p.password) keyedSteps.push(s.id);
    }
    // Only inject global opts.key if exactly ONE step needs it
    // (multiple keyed steps must rely on their own params)
    if (keyedSteps.length <= 1) {
        for (var j = 0; j < pipeline.length; j++) {
            var s2 = pipeline[j];
            var p2 = s2.params || {};
            if ((s2.id === 'xor' || s2.id === 'otp' || s2.id === 'rc4') && p2.key) {
                opts.key = opts.key || p2.key;
            }
            if ((s2.id === 'vigenere' || s2.id === 'beaufort' || s2.id === 'autokey') && p2.key) {
                opts.key = opts.key || p2.key;
            }
            if (s2.id === 'columnarTransposition' && p2.key) opts.key = opts.key || p2.key;
        }
    }
    // Always inject password for encrypt (uses separate option name)
    for (var k = 0; k < pipeline.length; k++) {
        if (pipeline[k].id === 'encrypt') {
            var ep = pipeline[k].params || {};
            opts.password = opts.password || ep.password;
        }
    }
}

/* ===== Exports ===== */

global.CTFCryptoEngine = {
    generateCryptoChallenge: generateCryptoChallenge,
    generateMultiPartChallenge: generateMultiPartChallenge,
    generateCribDragChallenge: generateCribDragChallenge,
    generateHashCrackChallenge: generateHashCrackChallenge,
    generateCipherIdentifyChallenge: generateCipherIdentifyChallenge,
    generateKeyReuseChallenge: generateKeyReuseChallenge,

    getRandomCryptoPipeline: getRandomCryptoPipeline,
    composePipeline: composePipeline,
    randomizeCryptoParams: randomizeCryptoParams,
    generateCryptoHints: generateCryptoHints,
    extractKeysFromPipeline: extractKeysFromPipeline,

    CRYPTO_PIPELINE_POOL: CRYPTO_PIPELINE_POOL,
    CRYPTO_PARAM_RANGES: CRYPTO_PARAM_RANGES,
    CRYPTO_HINT_MAP: CRYPTO_HINT_MAP,
    STEP_CATEGORIES: STEP_CATEGORIES
};

})(typeof window !== 'undefined' ? window : (typeof global !== 'undefined' ? global : this));
