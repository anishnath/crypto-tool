/**
 * CTF Steganography Rules Engine
 * Executes pipeline of steps in order. Supports sync and async steps.
 * Steps from CTFSteps; embed step integrates with StegoEngine/StegoImageGen/StegoAudio.
 * Robust for CTF challenge generation: validation, capacity estimation, extract API, normalized output.
 */
(function(global) {
'use strict';

var steps = global.CTFSteps || {};

var TERMINAL_IDS = ['embed', 'appendEof', 'embedSpectrogram', 'embedOverlay', 'embedPngText', 'snow', 'scatterEmbed'];

function isTerminalStep(id) {
    return TERMINAL_IDS.indexOf(id) >= 0;
}

function findTerminalStepIndex(pipeline) {
    for (var i = 0; i < pipeline.length; i++) {
        if (isTerminalStep(pipeline[i].id)) return i;
    }
    return -1;
}

function ensureSteps() {
    if (!steps || Object.keys(steps).length === 0) {
        throw new Error('CTFSteps not loaded. Load ctf-steps.js before ctf-engine.js');
    }
}

/**
 * Normalize message to string (accept string or Uint8Array).
 */
function normalizePayload(message) {
    if (message == null) return '';
    if (typeof message === 'string') return message;
    if (message instanceof Uint8Array || (message.buffer && message.byteLength != null)) {
        return new TextDecoder().decode(message);
    }
    return String(message);
}

/**
 * Validate pipeline structure. Returns { valid: boolean, errors: string[] }.
 */
function validatePipeline(pipeline) {
    ensureSteps();
    var errors = [];
    if (!Array.isArray(pipeline) || pipeline.length === 0) {
        errors.push('Pipeline must be a non-empty array');
        return { valid: false, errors: errors };
    }
    var terminalIdx = findTerminalStepIndex(pipeline);
    if (terminalIdx < 0) {
        errors.push('Pipeline must include a terminal step: ' + TERMINAL_IDS.join(', '));
    }
    for (var i = 0; i < pipeline.length; i++) {
        var s = pipeline[i];
        if (!s || typeof s.id !== 'string') {
            errors.push('Step ' + i + ': must have id (string)');
            continue;
        }
        var impl = steps[s.id];
        if (!impl) {
            errors.push('Step ' + i + ' ("' + s.id + '"): unknown step ID');
        } else if (i === terminalIdx) {
            if (!impl.encode) errors.push('Terminal step "' + s.id + '" has no encode');
        } else {
            if (!impl.encode) errors.push('Step "' + s.id + '" has no encode');
        }
    }
    if (terminalIdx >= 0) {
        var term = pipeline[terminalIdx];
        if (term.id === 'encrypt' && !term.params) {
            errors.push('encrypt step requires password (via params or options)');
        }
    }
    return {
        valid: errors.length === 0,
        errors: errors
    };
}

/**
 * Estimate capacity in bytes for a pipeline (approximate, for validation).
 * Returns number or null if unknown. Uses terminal step params for cover dimensions.
 */
function estimateCapacity(pipeline, params) {
    ensureSteps();
    params = params || {};
    var terminalIdx = findTerminalStepIndex(pipeline);
    if (terminalIdx < 0) return null;
    var step = pipeline[terminalIdx];
    var p = Object.assign({}, step.params || {}, params);
    var E = (typeof global !== 'undefined' ? global : (typeof window !== 'undefined' ? window : {})).StegoEngine;

    if (step.id === 'embed') {
        var medium = p.medium || 'image';
        if (medium === 'image') {
            var w = p.width || 400;
            var h = p.height || 300;
            var depth = (p.bitDepth != null) ? p.bitDepth : 0;
            var mode = p.bitDepthMode || p.depthMode || 'at';
            if (E && typeof E.calculateCapacity === 'function') {
                return E.calculateCapacity(w * h, mode, depth);
            }
            var bitsPerPixel = (mode === 'with') ? 3 * (depth + 1) : 3;
            return Math.floor((w * h * bitsPerPixel) / 8) - 4;
        }
        if (medium === 'audio') {
            var duration = p.audioDuration || 3;
            var sr = p.sampleRate || 44100;
            return Math.floor((sr * duration) / 8) - 4;
        }
    }
    if (step.id === 'embedSpectrogram') return 500;
    if (step.id === 'snow') return null;
    if (step.id === 'appendEof' || step.id === 'embedPngText') return null;
    return null;
}

/**
 * Get raw bytes from encode result for download. Handles all terminal output types.
 * @param {object} result - Output from encode()
 * @returns {Uint8Array|null}
 */
function getOutputBytes(result) {
    if (!result) return null;
    if (result.bytes) return result.bytes instanceof Uint8Array ? result.bytes : new Uint8Array(result.bytes);
    if (result.buffer) return new Uint8Array(result.buffer);
    if (result.blob && result.blob.arrayBuffer) {
        return null;
    }
    if (result.type === 'image' && result.imageData) {
        return new Uint8Array(result.imageData.data);
    }
    if (result.canvas) {
        var ctx = result.canvas.getContext('2d');
        var id = ctx.getImageData(0, 0, result.canvas.width, result.canvas.height);
        return new Uint8Array(id.data);
    }
    if (typeof result === 'string') {
        return new TextEncoder().encode(result);
    }
    return null;
}

/**
 * Extract hidden payload from stego bytes (solver API).
 * Detects format, extracts raw payload, runs decode pipeline.
 * @param {Uint8Array|ArrayBuffer} stegoBytes - The stego file bytes
 * @param {Array} pipeline - Same pipeline used for encode
 * @param {object} options - { password, key, etc. }
 * @returns {Promise<{payload: string, format: string}>}
 */
function extract(stegoBytes, pipeline, options) {
    ensureSteps();
    options = options || {};
    if (stegoBytes.buffer) stegoBytes = new Uint8Array(stegoBytes);
    else if (!(stegoBytes instanceof Uint8Array)) stegoBytes = new Uint8Array(stegoBytes);

    var terminalIdx = findTerminalStepIndex(pipeline);
    if (terminalIdx < 0) {
        return Promise.reject(new Error('Pipeline has no terminal step'));
    }
    var term = pipeline[terminalIdx];
    var rawPayload = null;
    var format = term.id;

    if (term.id === 'snow') {
        var str = new TextDecoder().decode(stegoBytes);
        var impl = steps.snow;
        if (!impl || !impl.decode) return Promise.reject(new Error('snow decode not available'));
        rawPayload = impl.decode(str, options);
        return Promise.resolve({ payload: rawPayload, format: 'snow' });
    }

    if (term.id === 'appendEof') {
        var impl = steps.appendEof;
        if (impl && impl.extract) {
            rawPayload = impl.extract(stegoBytes, {});
        } else {
            var eof = findEofOffset(stegoBytes);
            rawPayload = new TextDecoder().decode(stegoBytes.subarray(eof));
        }
        return decode(pipeline, rawPayload, options).then(function(p) {
            return { payload: p, format: 'appendEof' };
        });
    }

    if (term.id === 'embedPngText') {
        var txt = extractPngText(stegoBytes);
        if (txt) rawPayload = txt;
        if (!rawPayload) return Promise.reject(new Error('No tEXt chunk found in PNG'));
        return decode(pipeline, rawPayload, options).then(function(p) {
            return { payload: p, format: 'pngText' };
        });
    }

    if (term.id === 'embed' || term.id === 'embedOverlay') {
        var E = global.StegoEngine;
        if (!E) return Promise.reject(new Error('StegoEngine not available'));
        if (term.id === 'embedOverlay') {
            return Promise.reject(new Error('embedOverlay extraction requires manual inspection (contrast/levels)'));
        }
        return bytesToImageData(stegoBytes).then(function(imgData) {
            if (!imgData) return Promise.reject(new Error('Could not decode image from bytes (browser required)'));
            var p = term.params || {};
            var depth = (p.bitDepth != null) ? p.bitDepth : 0;
            var mode = p.depthMode || p.bitDepthMode || 'at';
            var channel = p.channel;
            var extracted;
            try {
                if (channel != null && E.decodeLSBChannel) {
                    extracted = E.decodeLSBChannel(imgData, channel, (p.plane != null) ? p.plane : 0);
                } else if (depth === 0 && mode === 'at') {
                    extracted = E.decodeLSB(imgData);
                } else if (mode === 'at') {
                    extracted = E.decodeLSBAtDepth(imgData, depth);
                } else {
                    extracted = E.decodeLSBWithDepth(imgData, depth);
                }
            } catch (e) {
                return Promise.reject(new Error('LSB extraction failed: ' + e.message));
            }
            return decode(pipeline, extracted, options).then(function(decoded) {
                return { payload: decoded, format: 'embed' };
            });
        });
    }

    if (term.id === 'embedSpectrogram') {
        return Promise.reject(new Error('Spectrogram extraction requires manual view in Audacity/Sonic Visualiser'));
    }

    return Promise.reject(new Error('Unknown terminal step: ' + term.id));
}

function findEofOffset(bytes) {
    if (bytes.length >= 12 && bytes[0] === 0x52 && bytes[1] === 0x49 && bytes[2] === 0x46 && bytes[3] === 0x46 &&
        bytes[8] === 0x57 && bytes[9] === 0x41 && bytes[10] === 0x56 && bytes[11] === 0x45) {
        var offset = 12;
        while (offset + 8 <= bytes.length) {
            var chunkSize = (bytes[offset + 4] | (bytes[offset + 5] << 8) | (bytes[offset + 6] << 16) | (bytes[offset + 7] << 24)) >>> 0;
            offset = offset + 8 + chunkSize;
            if (chunkSize % 2 !== 0) offset++;
        }
        return offset;
    }
    var iend = [0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82];
    for (var i = 0; i <= bytes.length - iend.length; i++) {
        var match = true;
        for (var j = 0; j < iend.length; j++) {
            if (bytes[i + j] !== iend[j]) { match = false; break; }
        }
        if (match) return i + iend.length;
    }
    for (var k = 0; k <= bytes.length - 2; k++) {
        if (bytes[k] === 0xFF && bytes[k + 1] === 0xD9) return k + 2;
    }
    return bytes.length;
}

function extractPngText(bytes) {
    var offset = 8;
    while (offset + 12 <= bytes.length) {
        var len = (bytes[offset] << 24) | (bytes[offset + 1] << 16) | (bytes[offset + 2] << 8) | bytes[offset + 3];
        var type = String.fromCharCode(bytes[offset + 4], bytes[offset + 5], bytes[offset + 6], bytes[offset + 7]);
        if (type === 'tEXt' && offset + 12 + len <= bytes.length) {
            var data = bytes.subarray(offset + 8, offset + 8 + len);
            var nul = 0;
            for (var i = 0; i < data.length; i++) {
                if (data[i] === 0) { nul = i; break; }
            }
            if (nul > 0) {
                return new TextDecoder().decode(data.subarray(nul + 1));
            }
        }
        offset += 12 + len;
        if (len % 2 !== 0) offset++;
    }
    return null;
}

function bytesToImageData(bytes) {
    if (typeof document === 'undefined' || !document.createElement || typeof Blob === 'undefined') {
        return Promise.resolve(null);
    }
    return new Promise(function(resolve, reject) {
        var img = new Image();
        var blob = new Blob([bytes], { type: 'image/png' });
        var url = URL.createObjectURL(blob);
        img.onload = function() {
            URL.revokeObjectURL(url);
            var c = document.createElement('canvas');
            c.width = img.width;
            c.height = img.height;
            c.getContext('2d').drawImage(img, 0, 0);
            resolve(c.getContext('2d').getImageData(0, 0, c.width, c.height));
        };
        img.onerror = function() {
            URL.revokeObjectURL(url);
            reject(new Error('Failed to load image'));
        };
        img.src = url;
    });
}

/**
 * Resolve a step's output (handle Promise).
 */
function resolve(value) {
    if (value && typeof value.then === 'function') {
        return value;
    }
    return Promise.resolve(value);
}

/**
 * Execute encode pipeline.
 * @param {Array} pipeline - [{ id: 'base64' }, { id: 'hex' }, { id: 'embed', params: {...} }]
 * @param {string} message - Plain text to hide
 * @param {object} cover - ImageData or audio buffer (for embed). Optional if embed params include coverType.
 * @param {object} options - { password, rsParity, etc. } merged into step params where relevant
 * @returns {Promise<{type:'image'|'audio', blob?:Blob, canvas?:HTMLCanvasElement, imageData?:ImageData}>}
 */
function encode(pipeline, message, cover, options) {
    ensureSteps();
    options = options || {};
    var payload = normalizePayload(message);
    var embedStepIndex = -1;
    var embedParams = null;

    embedStepIndex = findTerminalStepIndex(pipeline);
    if (embedStepIndex >= 0) {
        embedParams = pipeline[embedStepIndex].params || {};
    }

    if (embedStepIndex < 0) {
        return Promise.reject(new Error('Pipeline must include a terminal step (embed, appendEof, embedSpectrogram, embedOverlay, embedPngText, snow)'));
    }

    var preEmbedSteps = pipeline.slice(0, embedStepIndex);
    var stepIndex = 0;

    function runNext() {
        if (stepIndex >= preEmbedSteps.length) {
            var step = pipeline[embedStepIndex];
            var stepImpl = steps[step.id];
            if (!stepImpl || !stepImpl.encode) {
                return Promise.reject(new Error('Unknown or invalid embed step: ' + step.id));
            }
            var params = Object.assign({}, embedParams, options);
            return resolve(stepImpl.encode(payload, cover, params));
        }

        var s = preEmbedSteps[stepIndex];
        stepIndex++;
        var impl = steps[s.id];
        if (!impl || !impl.encode) {
            return Promise.reject(new Error('Unknown step: ' + s.id));
        }
        var p = Object.assign({}, s.params || {}, options);
        if (s.id === 'encrypt' && (options.password || options.key)) {
            p.password = p.password || options.password || options.key;
        }
        if (s.id === 'xor' && (options.key || options.password)) {
            p.key = p.key || options.key || options.password;
        }
        if (s.id === 'vigenere' && (options.key || options.password)) {
            p.key = p.key || options.key || options.password;
        }
        if (s.id === 'columnarTransposition' && options.key) {
            p.key = p.key || options.key;
        }
        if (s.id === 'rsProtect' && options.rsParity != null) {
            p.parityLevel = p.parityLevel || options.rsParity;
        }
        return resolve(impl.encode(payload, p)).then(function(result) {
            payload = result;
            return runNext();
        }).catch(function(e) {
            return Promise.reject(new Error('Step "' + s.id + '" encode failed: ' + (e.message || e)));
        });
    }

    return runNext();
}

/**
 * Execute decode pipeline (reverse of encode, excluding embed).
 * Used when extracting from an already-decoded LSB string.
 * @param {Array} pipeline - Same pipeline as encode (without embed for decoding the payload)
 * @param {string} extracted - Raw string extracted from stego (e.g. from StegoEngine.decodeLSB)
 * @param {object} options - { password, etc. }
 * @returns {Promise<string>}
 */
function decode(pipeline, extracted, options) {
    ensureSteps();
    options = options || {};
    var payload = extracted;
    var embedIndex = findTerminalStepIndex(pipeline);
    if (embedIndex < 0) embedIndex = pipeline.length;
    var decodeSteps = pipeline.slice(0, embedIndex).reverse();

    var stepIndex = 0;

    function runNext() {
        if (stepIndex >= decodeSteps.length) {
            return Promise.resolve(payload);
        }
        var s = decodeSteps[stepIndex];
        stepIndex++;
        var impl = steps[s.id];
        if (!impl || !impl.decode) {
            return Promise.reject(new Error('Unknown or non-decodable step: ' + s.id));
        }
        var p = Object.assign({}, s.params || {}, options);
        if (s.id === 'encrypt' && (options.password || options.key)) {
            p.password = p.password || options.password || options.key;
        }
        if (s.id === 'xor' && (options.key || options.password)) {
            p.key = p.key || options.key || options.password;
        }
        if (s.id === 'vigenere' && (options.key || options.password)) {
            p.key = p.key || options.key || options.password;
        }
        if (s.id === 'columnarTransposition' && options.key) {
            p.key = p.key || options.key;
        }
        return resolve(impl.decode(payload, p)).then(function(result) {
            payload = result;
            return runNext();
        }).catch(function(e) {
            return Promise.reject(new Error('Step "' + s.id + '" decode failed: ' + (e.message || e)));
        });
    }

    return runNext();
}

/**
 * Get list of available step IDs.
 */
function getStepIds() {
    ensureSteps();
    return Object.keys(steps).filter(function(k) { return k !== 'embed' || steps[k].encode; });
}

/**
 * Register a custom step.
 */
function registerStep(id, impl) {
    if (impl && (impl.encode || impl.decode)) {
        steps[id] = impl;
    }
}

/**
 * Preset pipelines for difficulty levels (can be overridden by servlet rules).
 */
var PRESETS = {
    easy: {
        label: 'Easy',
        pipeline: [
            { id: 'embed', params: { bitDepth: 0, coverType: 'gradient', width: 400, height: 300 } }
        ]
    },
    medium: {
        label: 'Medium',
        pipeline: [
            { id: 'base64', params: {} },
            { id: 'embed', params: { bitDepth: 0, coverType: 'geometric', width: 500, height: 400 } }
        ]
    },
    hard: {
        label: 'Hard',
        pipeline: [
            { id: 'compress', params: {} },
            { id: 'base64', params: {} },
            { id: 'hex', params: {} },
            { id: 'embed', params: { bitDepth: 1, coverType: 'noise', width: 600, height: 450 } }
        ]
    },
    pro: {
        label: 'Pro',
        pipeline: [
            { id: 'compress', params: {} },
            { id: 'base64', params: {} },
            { id: 'hex', params: {} },
            { id: 'encrypt', params: {} },
            { id: 'rsProtect', params: { parityLevel: 2 } },
            { id: 'embed', params: { bitDepth: 2, coverType: 'waves', width: 800, height: 600 } }
        ]
    },
    easy_audio: {
        label: 'Easy (Audio)',
        pipeline: [
            { id: 'embed', params: { medium: 'audio', bitDepth: 0, audioCoverType: 'tone', audioDuration: 3 } }
        ]
    },
    medium_audio: {
        label: 'Medium (Audio)',
        pipeline: [
            { id: 'base64', params: {} },
            { id: 'embed', params: { medium: 'audio', bitDepth: 0, audioCoverType: 'mixed', audioDuration: 4 } }
        ]
    },
    spectrogram: {
        label: 'Spectrogram',
        pipeline: [
            { id: 'embedSpectrogram', params: { baseFreq: 200, durationPerChar: 0.08 } }
        ]
    },
    hard_audio: {
        label: 'Hard (Audio)',
        pipeline: [
            { id: 'compress', params: {} },
            { id: 'base64', params: {} },
            { id: 'embed', params: { medium: 'audio', bitDepth: 1, audioCoverType: 'noise', audioDuration: 5 } }
        ]
    }
};

/**
 * Get pipeline for a difficulty (or custom).
 */
function getPipeline(difficulty, overrides) {
    var preset = PRESETS[difficulty] || PRESETS.easy;
    var pipeline = JSON.parse(JSON.stringify(preset.pipeline || []));
    if (overrides && overrides.pipeline) {
        pipeline = overrides.pipeline;
    }
    return pipeline;
}

/* ===== Randomness: Seeded PRNG ===== */
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
    if (seed != null && seed === seed) return mulberry32(seed >>> 0);
    return Math.random;
}

/* ===== Param ranges for randomization ===== */
var PARAM_RANGES = {
    embed: {
        bitDepth: [0, 2],
        coverType: ['gradient', 'geometric', 'noise', 'waves'],
        width: [350, 600],
        height: [250, 500],
        audioCoverType: ['tone', 'noise', 'mixed', 'chords'],
        audioDuration: [2.5, 5],
        channel: [0, 1, 2],
        plane: [0, 1, 2, 3]
    },
    rsProtect: { parityLevel: [1, 2, 3] },
    caesar: { shift: [1, 25] },
    vigenere: { key: ['CRYPTO', 'STEGANOGRAPHY', 'HIDDEN', 'PUZZLE', 'ENIGMA', 'CIPHER', 'SHADOW'] },
    railFence: { rails: [3, 6] },
    columnarTransposition: { key: ['CRYPTO', 'HIDDEN', 'PUZZLE', 'SECRET', 'ENIGMA', 'SHADOW', 'MATRIX'] },
    substitution: { alphabet: ['QWERTYUIOPASDFGHJKLZXCVBNM', 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'LGWNAFBOPCEDMHIJKRSTQUVXYZ'] },
    tarWrap: { filename: ['secret.txt', 'flag.dat', 'hidden.bin', 'README', 'key.pem', '.hidden', 'data.enc'] },
    zipWrap: { filename: ['flag.txt', 'secret.dat', 'README.md', 'key.bin', '.password', 'data.txt'] },
    stringsHide: { chunkCount: [5, 12], marker: ['STEG_FLAG', 'CTF_DATA', 'HIDDEN_MSG', 'FLAG_HERE'] },
    innerEmbed: { innerWidth: [150, 300], innerHeight: [100, 250], innerCoverType: ['noise', 'gradient', 'geometric'] },
    decoy: { decoyCount: [2, 5] },
    scatterEmbed: {
        coverType: ['noise', 'gradient', 'geometric', 'waves'],
        width: [400, 700],
        height: [300, 550],
        scatterKey: ['alpha', 'bravo', 'charlie', 'delta', 'echo', 'foxtrot']
    },
    embedSpectrogram: {
        baseFreq: [180, 250],
        durationPerChar: [0.06, 0.12]
    },
    embedOverlay: { opacity: [0.02, 0.06], fontSize: [12, 20] },
    embedPngText: { keyword: ['Comment', 'Description', 'Artist', 'Software'] },
    snow: {}
};

var LOREM_VARIANTS = [
    'Lorem ipsum dolor sit amet consectetur adipiscing elit. Sed do eiusmod tempor. ',
    'The quick brown fox jumps over the lazy dog. Pack my box with five dozen liquors. ',
    'In the beginning God created the heaven and the earth. And the earth was without form. ',
    'It was the best of times it was the worst of times. A tale of two cities. '
];

/**
 * Randomize pipeline parameters within defined ranges.
 * @param {Array} pipeline - Pipeline to mutate (cloned first)
 * @param {object} options - { seed?: number, rng?: () => number, keepKeys?: string[] }
 * @returns {Array} New pipeline with randomized params
 */
function randomizeParams(pipeline, options) {
    options = options || {};
    var rng = createRng(options.seed);
    var out = JSON.parse(JSON.stringify(pipeline));

    for (var i = 0; i < out.length; i++) {
        var s = out[i];
        var ranges = PARAM_RANGES[s.id];
        if (!ranges || !s.params) continue;
        s.params = s.params || {};

        for (var key in ranges) {
            if (options.keepKeys && options.keepKeys.indexOf(key) >= 0) continue;
            var val = ranges[key];
            if (Array.isArray(val) && typeof val[0] === 'number') {
                var lo = val[0];
                var hi = val.length > 1 ? val[1] : val[0];
                s.params[key] = Math.floor(rng() * (hi - lo + 1)) + lo;
            } else if (Array.isArray(val) && val.length > 0) {
                s.params[key] = val[Math.floor(rng() * val.length)];
            }
        }
        if (s.id === 'embed') {
            s.params.coverSeed = Math.floor(rng() * 0xFFFFFFFF);
        }
        if (s.id === 'innerEmbed') {
            s.params.innerSeed = Math.floor(rng() * 0xFFFFFFFF);
        }
        if (s.id === 'scatterEmbed') {
            s.params.coverSeed = Math.floor(rng() * 0xFFFFFFFF);
        }
        if (s.id === 'decoy') {
            s.params.marker = '<<<REAL_' + Math.floor(rng() * 99999) + '>>>';
        }
        if (s.id === 'snow' && ranges) {
            s.params.coverText = LOREM_VARIANTS[Math.floor(rng() * LOREM_VARIANTS.length)];
        }
    }
    return out;
}

/**
 * Pool of equivalent pipelines per difficulty (for random selection).
 */
var PIPELINE_POOL = {
    easy: [
        [{ id: 'embed', params: { bitDepth: 0, coverType: 'gradient' } }],
        [{ id: 'reverse', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'rot13', params: {} }, { id: 'embed', params: { bitDepth: 0 } }]
    ],
    medium: [
        [{ id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'hex', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'base64Hex', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'base32', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'morse', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'binary', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'octal', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'decimal', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'atbash', params: {} }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'caesar', params: { shift: 7 } }, { id: 'hex', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        [{ id: 'rot47', params: {} }, { id: 'base32', params: {} }, { id: 'embed', params: { bitDepth: 0 } }]
    ],
    hard: [
        [{ id: 'compress', params: {} }, { id: 'base64', params: {} }, { id: 'hex', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        [{ id: 'base64', params: {} }, { id: 'hex', params: {} }, { id: 'rsProtect', params: { parityLevel: 2 } }, { id: 'embed', params: { bitDepth: 1 } }],
        [{ id: 'xor', params: {} }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        // morse → tarWrap → base64 → embed (flag is morse'd, wrapped in tar, embedded)
        [{ id: 'morse', params: {} }, { id: 'tarWrap', params: { filename: 'hint.txt' } }, { id: 'embed', params: { bitDepth: 1 } }],
        // railFence → hex → embed (transposition + encoding)
        [{ id: 'railFence', params: { rails: 4 } }, { id: 'hex', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        // vigenere → binary → embed (classical crypto + binary encoding)
        [{ id: 'vigenere', params: { key: 'STEGO' } }, { id: 'binary', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        // decoy → base64 → embed (red herrings!)
        [{ id: 'decoy', params: { decoyCount: 3 } }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        // bacon → base64 → embed (classic stego cipher)
        [{ id: 'bacon', params: {} }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        // polybius → hex → embed (numbers-based)
        [{ id: 'polybius', params: {} }, { id: 'hex', params: {} }, { id: 'embed', params: { bitDepth: 0 } }],
        // columnar → base32 → embed (transposition + encoding)
        [{ id: 'columnarTransposition', params: { key: 'HIDDEN' } }, { id: 'base32', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        // base64 → zipWrap → embed (binwalk reveals zip)
        [{ id: 'base64', params: {} }, { id: 'zipWrap', params: { filename: 'data.txt' } }, { id: 'embed', params: { bitDepth: 1 } }],
        // substitution → octal → embed
        [{ id: 'substitution', params: {} }, { id: 'octal', params: {} }, { id: 'embed', params: { bitDepth: 1 } }],
        // scatter embed: base64 → scatterEmbed (needs key to find the pixels!)
        [{ id: 'base64', params: {} }, { id: 'scatterEmbed', params: { scatterKey: 'ctfkey' } }]
    ],
    pro: [
        [{ id: 'compress', params: {} }, { id: 'base64', params: {} }, { id: 'hex', params: {} }, { id: 'encrypt', params: {} }, { id: 'rsProtect', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        [{ id: 'compress', params: {} }, { id: 'hex', params: {} }, { id: 'base64', params: {} }, { id: 'rsProtect', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        // image-in-image: flag → innerEmbed → base64 → embed (must extract outer, then inner)
        [{ id: 'innerEmbed', params: { innerWidth: 200, innerHeight: 150 } }, { id: 'embed', params: { bitDepth: 1 } }],
        // tar matryoshka: encrypt → tarWrap → compress → base64 → embed
        [{ id: 'encrypt', params: {} }, { id: 'tarWrap', params: { filename: 'payload.enc' } }, { id: 'compress', params: {} }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        // classical cipher chain: vigenere → atbash → hex → compress → embed
        [{ id: 'vigenere', params: { key: 'ENIGMA' } }, { id: 'atbash', params: {} }, { id: 'hex', params: {} }, { id: 'compress', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        // decoy + layers: caesar → decoy → tarWrap → encrypt → embed
        [{ id: 'caesar', params: { shift: 19 } }, { id: 'decoy', params: { decoyCount: 4 } }, { id: 'tarWrap', params: { filename: 'clue.dat' } }, { id: 'encrypt', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        // zipWrap matryoshka: compress → zipWrap → base64 → embed
        [{ id: 'compress', params: {} }, { id: 'zipWrap', params: { filename: 'payload.bin' } }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        // scatter with crypto: encrypt → base32 → scatterEmbed
        [{ id: 'encrypt', params: {} }, { id: 'base32', params: {} }, { id: 'scatterEmbed', params: { scatterKey: 'pro_key' } }],
        // strings forensic: bacon → stringsHide → base64 → embed
        [{ id: 'bacon', params: {} }, { id: 'stringsHide', params: { chunkCount: 10 } }, { id: 'base64', params: {} }, { id: 'embed', params: { bitDepth: 2 } }],
        // columnar + substitution: substitution → columnarTransposition → hex → compress → embed
        [{ id: 'substitution', params: {} }, { id: 'columnarTransposition', params: { key: 'ENIGMA' } }, { id: 'hex', params: {} }, { id: 'compress', params: {} }, { id: 'embed', params: { bitDepth: 2 } }]
    ],
    // Forensic-style: no LSB, uses file-format tricks
    forensic: [
        [{ id: 'base64', params: {} }, { id: 'snow', params: {} }],
        [{ id: 'morse', params: {} }, { id: 'snow', params: {} }],
        [{ id: 'tarWrap', params: { filename: 'flag.txt' } }, { id: 'appendEof', params: {} }],
        [{ id: 'hex', params: {} }, { id: 'embedPngText', params: { keyword: 'Description' } }],
        [{ id: 'zipWrap', params: { filename: 'secret.txt' } }, { id: 'appendEof', params: {} }],
        [{ id: 'stringsHide', params: {} }, { id: 'appendEof', params: {} }],
        [{ id: 'base32', params: {} }, { id: 'embedPngText', params: { keyword: 'Comment' } }]
    ],
    easy_audio: [
        [{ id: 'embed', params: { medium: 'audio', bitDepth: 0, audioCoverType: 'tone' } }]
    ],
    medium_audio: [
        [{ id: 'base64', params: {} }, { id: 'embed', params: { medium: 'audio', bitDepth: 0 } }],
        [{ id: 'hex', params: {} }, { id: 'embed', params: { medium: 'audio', bitDepth: 0 } }],
        [{ id: 'morse', params: {} }, { id: 'embed', params: { medium: 'audio', bitDepth: 0 } }]
    ],
    spectrogram: [
        [{ id: 'embedSpectrogram', params: {} }]
    ]
};

/**
 * Get a random pipeline for a difficulty. Optionally randomize params.
 * @param {string} difficulty - easy, medium, hard, pro, easy_audio, etc.
 * @param {object} options - { seed?: number, randomizeParams?: boolean }
 * @returns {Array} Pipeline
 */
function getRandomPipeline(difficulty, options) {
    options = options || {};
    var pool = PIPELINE_POOL[difficulty];
    var rng = createRng(options.seed);

    var pipeline;
    if (pool && pool.length > 0) {
        pipeline = JSON.parse(JSON.stringify(pool[Math.floor(rng() * pool.length)]));
    } else {
        pipeline = getPipeline(difficulty);
    }

    if (options.randomizeParams !== false) {
        pipeline = randomizeParams(pipeline, { seed: options.seed != null ? options.seed + 1 : undefined });
    }
    return pipeline;
}

/**
 * Encode with random pipeline. Convenience for challenge generation.
 * @param {string} message - Payload to hide
 * @param {string} difficulty - easy, medium, hard, etc.
 * @param {object} cover - Optional cover (image/audio)
 * @param {object} options - { seed?: number, password?: string, key?: string }
 * @returns {Promise<object>} Encode result + metadata { result, pipeline }
 */
function encodeRandom(message, difficulty, cover, options) {
    options = options || {};
    var pipeline = getRandomPipeline(difficulty, { seed: options.seed, randomizeParams: true });
    if (pipeline.some(function(s) { return s.id === 'encrypt'; })) {
        var pw = options.password || options.key;
        if (pw) options.password = pw;
    }
    return encode(pipeline, message, cover, options).then(function(result) {
        return { result: result, pipeline: pipeline };
    });
}

/**
 * Generate a SHA-256 hash of the flag for verification.
 * Returns a promise resolving to the hex digest.
 */
function flagVerify(flag) {
    var C = global.crypto || (typeof require === 'function' ? require('crypto').webcrypto : null);
    if (!C || !C.subtle) return Promise.reject(new Error('crypto.subtle not available'));
    var bytes = new TextEncoder().encode(flag);
    return C.subtle.digest('SHA-256', bytes).then(function(buf) {
        var arr = new Uint8Array(buf);
        var hex = '';
        for (var i = 0; i < arr.length; i++) {
            var h = arr[i].toString(16);
            hex += (h.length === 1 ? '0' : '') + h;
        }
        return hex;
    });
}

/**
 * Check if a candidate matches the expected flag hash.
 */
function checkFlag(candidate, expectedHash) {
    return flagVerify(candidate).then(function(hash) {
        return { correct: hash === expectedHash, hash: hash };
    });
}

/**
 * Convert encode result to base64 for JSON serialization.
 * Handles image (canvas.toDataURL), audio (buffer), bytes, string.
 * @returns {Promise<{format: string, data: string, mimeType?: string}>}
 */
function resultToBase64(result) {
    if (!result) return Promise.resolve(null);
    if (result.bytes) {
        var b = result.bytes instanceof Uint8Array ? result.bytes : new Uint8Array(result.bytes);
        var s = '';
        for (var i = 0; i < b.length; i++) s += String.fromCharCode(b[i]);
        return Promise.resolve({
            format: 'file',
            data: btoa(s),
            mimeType: (result.bytes.length > 4 && result.bytes[0] === 0x89 && result.bytes[1] === 0x50) ? 'image/png' : 'application/octet-stream'
        });
    }
    if (result.buffer) {
        var buf = new Uint8Array(result.buffer);
        var str = '';
        for (var i = 0; i < buf.length; i++) str += String.fromCharCode(buf[i]);
        return Promise.resolve({
            format: 'audio',
            data: btoa(str),
            mimeType: 'audio/wav'
        });
    }
    if (result.canvas && result.canvas.toDataURL) {
        var dataUrl = result.canvas.toDataURL('image/png');
        if (dataUrl && dataUrl.indexOf('base64,') >= 0) {
            return Promise.resolve({
                format: 'image',
                data: dataUrl.split(',')[1],
                mimeType: 'image/png'
            });
        }
    }
    if (result.type === 'image' && result.imageData) {
        var imgBytes = new Uint8Array(result.imageData.data);
        var imgStr = '';
        for (var i = 0; i < imgBytes.length; i++) imgStr += String.fromCharCode(imgBytes[i]);
        return Promise.resolve({
            format: 'image',
            data: btoa(imgStr),
            mimeType: 'application/octet-stream',
            note: 'Raw RGBA pixels; PNG export works in browser with canvas'
        });
    }
    if (typeof result === 'string') {
        var enc = new TextEncoder().encode(result);
        var encStr = '';
        for (var i = 0; i < enc.length; i++) encStr += String.fromCharCode(enc[i]);
        return Promise.resolve({
            format: 'text',
            data: btoa(encStr),
            mimeType: 'text/plain'
        });
    }
    var fallback = getOutputBytes(result);
    if (fallback) {
        var fbStr = '';
        for (var i = 0; i < fallback.length; i++) fbStr += String.fromCharCode(fallback[i]);
        return Promise.resolve({
            format: 'file',
            data: btoa(fbStr),
            mimeType: 'application/octet-stream'
        });
    }
    return Promise.resolve(null);
}

/**
 * Step ID → hint text (for solvers).
 */
var HINT_MAP = {
    embed: 'The message is hidden in the image using LSB steganography. Try extracting least-significant bits from RGB channels.',
    embedOverlay: 'Look for nearly invisible text. Adjust brightness, contrast, or use image filters.',
    scatterEmbed: 'Pixels are shuffled by a key. Sequential LSB extraction will fail—you need the scatter key.',
    appendEof: 'Data may be appended after the file\'s normal end. Try binwalk, or read bytes after PNG IEND / JPEG FFD9 / WAV data.',
    embedPngText: 'Check PNG metadata: tEXt chunks (Comment, Description, Artist). Tools: exiftool, pngcheck.',
    embedSpectrogram: 'View the audio in a spectrogram (Audacity, Sonic Visualiser). Characters are encoded as frequencies.',
    snow: 'Zero-width Unicode characters hide bits in the text. Look for U+200B, U+200C, U+200D after spaces.',
    base64: 'The payload may be base64 encoded.',
    base32: 'The payload may be base32 encoded (A-Z, 2-7).',
    hex: 'Look for hexadecimal encoding (0-9, a-f).',
    octal: 'Numbers might be octal (0-7).',
    decimal: 'Numbers might be decimal byte values.',
    binary: '8-bit binary strings (01001000 01101001).',
    morse: 'Morse code: dots (.) and dashes (-). Slash (/) separates words.',
    rot13: 'ROT13 rotates letters by 13.',
    rot47: 'ROT47 rotates printable ASCII (33-126) by 47.',
    atbash: 'Atbash mirrors the alphabet (A↔Z, B↔Y).',
    caesar: 'Caesar/shift cipher. Try all 25 shifts.',
    vigenere: 'Vigenère cipher needs a keyword. Kasiski or frequency analysis.',
    railFence: 'Rail fence transposition. Try 2-6 rails.',
    bacon: 'Bacon\'s cipher uses 5-letter groups of a/b.',
    polybius: 'Polybius square: digit pairs 11-55 for letters.',
    columnarTransposition: 'Columnar transposition reorders by keyword.',
    substitution: 'Monoalphabetic substitution. Frequency analysis.',
    xor: 'XOR cipher. The key repeats.',
    reverse: 'Try reversing the string.',
    compress: 'Data may be deflate/zlib compressed.',
    encrypt: 'AES encryption. You need the password.',
    rsProtect: 'Payload starts with RS:—Reed-Solomon error correction.',
    tarWrap: 'The payload is wrapped in a tar archive. Extract with tar or 7z.',
    zipWrap: 'The payload is in a ZIP file. binwalk, unzip, or 7z.',
    stringsHide: 'Payload is buried in binary garbage. Run strings on the file.',
    decoy: 'Red herrings present. Find the real payload by its marker.',
    innerEmbed: 'Image inside image: extract outer, decode base64, reconstruct inner image, extract LSB again.'
};

/**
 * Generate progressive hints for solvers from the pipeline.
 * @param {Array} pipeline - The encode pipeline
 * @param {object} options - { count?: number, includeKeys?: boolean }
 * @returns {string[]} Array of hint strings
 */
function generateHints(pipeline, options) {
    options = options || {};
    var count = (options.count != null) ? options.count : 5;
    var hints = [];
    var seen = {};
    var termIdx = findTerminalStepIndex(pipeline);
    if (termIdx >= 0) {
        var term = pipeline[termIdx];
        var h = HINT_MAP[term.id];
        if (h && !seen[term.id]) { hints.push('1. ' + h); seen[term.id] = true; }
    }
    var pre = pipeline.slice(0, termIdx >= 0 ? termIdx : pipeline.length);
    for (var i = pre.length - 1; i >= 0 && hints.length < count; i--) {
        var step = pre[i];
        var sh = HINT_MAP[step.id];
        if (sh && !seen[step.id]) { hints.push((hints.length + 1) + '. ' + sh); seen[step.id] = true; }
    }
    if (hints.length < count && termIdx >= 0) {
        var t = pipeline[termIdx];
        if (t.id === 'embed' && t.params && (t.params.bitDepth != null)) {
            hints.push((hints.length + 1) + '. LSB bit depth: ' + (t.params.bitDepth + 1) + ' bits per channel.');
        }
        if (t.id === 'scatterEmbed' && t.params && t.params.scatterKey) {
            if (options.includeKeys) hints.push((hints.length + 1) + '. Scatter key (if given): ' + t.params.scatterKey);
        }
    }
    while (hints.length < count) {
        hints.push((hints.length + 1) + '. Work backwards: each step decodes before the next.');
    }
    return hints.slice(0, count);
}

/**
 * Build solution.keys from pipeline and options (keys needed for decode).
 */
function extractKeysFromPipeline(pipeline, options) {
    var keys = {};
    for (var i = 0; i < pipeline.length; i++) {
        var s = pipeline[i];
        var p = s.params || {};
        if (s.id === 'encrypt' && (p.password || options.password || options.key)) keys.password = p.password || options.password || options.key;
        if (s.id === 'xor' && (p.key || options.key || options.password)) keys.key = p.key || options.key || options.password;
        if (s.id === 'vigenere' && (p.key || options.key)) keys.vigenereKey = p.key || options.key;
        if (s.id === 'columnarTransposition' && (p.key || options.key)) keys.columnarKey = p.key || options.key;
        if (s.id === 'caesar' && p.shift != null) keys.caesarShift = p.shift;
        if (s.id === 'scatterEmbed' && (p.scatterKey || p.key)) keys.scatterKey = p.scatterKey || p.key;
        if (s.id === 'decoy' && p.marker) keys.decoyMarker = p.marker;
        if (s.id === 'stringsHide' && p.marker) keys.stringsMarker = p.marker;
    }
    return keys;
}

/**
 * Generate a complete challenge bundle for end users.
 * Returns JSON with challenge (downloadable), solution (for verification/decode), and hints (for solvers).
 *
 * @param {string} message - The flag or secret to hide
 * @param {string} difficulty - easy, medium, hard, pro, forensic, etc.
 * @param {object} cover - Optional cover (image/audio)
 * @param {object} options - { seed?: number, password?: string, key?: string, hintCount?: number }
 * @returns {Promise<object>} Full challenge JSON:
 *   {
 *     challenge: { format, data: base64, mimeType, filename },
 *     solution: { flag, pipeline, keys, hash },
 *     hints: string[]
 *   }
 */
function generateChallenge(message, difficulty, cover, options) {
    options = options || {};
    var pipeline = (options.pipeline && Array.isArray(options.pipeline))
        ? JSON.parse(JSON.stringify(options.pipeline))
        : getRandomPipeline(difficulty, { seed: options.seed, randomizeParams: true });
    if (pipeline.some(function(s) { return s.id === 'encrypt'; })) {
        var pw = options.password || options.key;
        if (pw) options.password = pw;
    }
    return encode(pipeline, message, cover, options).then(function(result) {
        return resultToBase64(result).then(function(challengeData) {
            var termIdx = findTerminalStepIndex(pipeline);
            var term = termIdx >= 0 ? pipeline[termIdx] : null;
            var format = (challengeData && challengeData.format) || 'file';
            var ext = format === 'image' ? 'png' : format === 'audio' ? 'wav' : format === 'text' ? 'txt' : 'bin';
            var filename = 'challenge.' + ext;

            return flagVerify(message).then(function(hash) {
                var keys = extractKeysFromPipeline(pipeline, options);
                var hints = generateHints(pipeline, { count: options.hintCount || 5, includeKeys: false });

                return {
                    challenge: {
                        format: format,
                        data: challengeData ? challengeData.data : null,
                        mimeType: challengeData ? challengeData.mimeType : null,
                        filename: filename,
                        note: challengeData && challengeData.note ? challengeData.note : undefined
                    },
                    solution: {
                        flag: message,
                        pipeline: pipeline,
                        keys: Object.keys(keys).length > 0 ? keys : undefined,
                        hash: hash,
                        verify: 'Use CTFEngine.checkFlag(candidate, "' + hash + '") to verify.'
                    },
                    hints: hints
                };
            });
        });
    });
}

global.CTFEngine = {
    encode: encode,
    decode: decode,
    extract: extract,
    flagVerify: flagVerify,
    checkFlag: checkFlag,
    generateChallenge: generateChallenge,
    generateHints: generateHints,
    resultToBase64: resultToBase64,
    validatePipeline: validatePipeline,
    estimateCapacity: estimateCapacity,
    getOutputBytes: getOutputBytes,
    getPipeline: getPipeline,
    getRandomPipeline: getRandomPipeline,
    encodeRandom: encodeRandom,
    randomizeParams: randomizeParams,
    getStepIds: getStepIds,
    registerStep: registerStep,
    normalizePayload: normalizePayload,
    PRESETS: PRESETS,
    PIPELINE_POOL: PIPELINE_POOL,
    PARAM_RANGES: PARAM_RANGES,
    steps: steps,
    TERMINAL_IDS: TERMINAL_IDS
};

})(typeof window !== 'undefined' ? window : (typeof global !== 'undefined' ? global : this));
