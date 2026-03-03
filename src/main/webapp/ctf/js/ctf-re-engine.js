/**
 * ctf-re-engine.js — Reverse Engineering CTF challenge generators.
 * Obfuscated code, logic gates, encoded algorithms, binary puzzles.
 * Depends: ctf-steps.js (for base64, hex). 100% client-side.
 *
 * Exports: window.CTFREEngine
 */
(function(global) {
'use strict';

var steps = global.CTFSteps || {};
var ENGINE_URL = 'https://8gwifi.org/ctf/re-ctf-generator.jsp';
var VERSION = '1.0';

function createRng(seed) {
    if (seed != null && seed === seed) {
        var s = (seed >>> 0);
        return function() {
            s = (s + 0x6D2B79F5) >>> 0;
            var t = Math.imul(s ^ (s >>> 15), s | 1);
            t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
            return ((t ^ (s >>> 14)) >>> 0) / 4294967296;
        };
    }
    return Math.random;
}

function flagHash(flag) {
    var C = global.crypto || (typeof require === 'function' ? require('crypto').webcrypto : null);
    if (C && C.subtle && C.subtle.digest) {
        var bytes = new TextEncoder().encode(flag);
        return C.subtle.digest('SHA-256', bytes).then(function(buf) {
            var h = '';
            var arr = new Uint8Array(buf);
            for (var i = 0; i < arr.length; i++) h += ('0' + arr[i].toString(16)).slice(-2);
            return h;
        });
    }
    if (typeof require === 'function') {
        var crypto = require('crypto');
        return Promise.resolve(crypto.createHash('sha256').update(flag).digest('hex'));
    }
    return Promise.reject(new Error('SHA-256 not available'));
}

function makeMeta(type, difficulty) {
    return {
        generator: '8gwifi.org Reverse Engineering CTF Generator',
        version: VERSION,
        url: ENGINE_URL,
        created: new Date().toISOString(),
        difficulty: difficulty || 'medium',
        type: type
    };
}

function bytesToB64(arr) {
    var binary = '';
    for (var i = 0; i < arr.length; i++) binary += String.fromCharCode(arr[i]);
    return btoa(binary);
}

/* ===== 1: Obfuscated string encoding (base64/hex, renamed vars) ===== */
function generateObfuscatedString(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var useBase64 = rng() < 0.5;
    var varNames = ['_0x4a2b', '_x1c3d', 's3cr3t', 'd4t4', 'p4yl04d', 'r3sult', 'k3y'];
    var v = varNames[Math.floor(rng() * varNames.length)];
    var encoded = useBase64 ? btoa(unescape(encodeURIComponent(flag))) : Array.from(new TextEncoder().encode(flag)).map(function(b) { return ('0' + b.toString(16)).slice(-2); }).join('');
    var decHint = useBase64 ? 'atob' : 'hex to bytes then decode';
    var code = useBase64
        ? 'var ' + v + '="' + encoded + '";function check(x){return atob(x)===decodeURIComponent(escape(atob(' + v + ')))? "Correct":"Wrong";}'
        : 'var ' + v + '="' + encoded + '";function check(x){var b=[];for(var i=0;i<' + v + '.length;i+=2)b.push(parseInt(' + v + '.substr(i,2),16));return new TextDecoder().decode(new Uint8Array(b))===x?"Correct":"Wrong";}';
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('obfuscatedString', 'beginner'),
            challenge: {
                data: bytesToB64(new TextEncoder().encode(code)),
                format: 'code',
                filename: 'puzzle.js',
                mimeType: 'application/javascript',
                note: 'Analyze the code. The variable contains an encoded string. Decode it to get the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'Decode the encoded variable (' + decHint + ')' },
            hints: [
                '1. Look at the variable that holds a long string.',
                '2. It is either base64 or hex encoded.',
                '3. Decode it to get plain text.',
                '4. The check function reveals the comparison logic.',
                '5. Flag format: flag{...}'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 2: Control flow obfuscation (switch/state) ===== */
function generateObfuscatedControlFlow(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var chars = flag.split('');
    var states = chars.map(function(c, i) { return 's' + i; });
    var code = '(function(){var st=0,out="";var t="' + chars.join('') + '";';
    code += 'while(st<' + chars.length + '){switch(st){';
    for (var i = 0; i < chars.length; i++) {
        var esc = chars[i].replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        code += 'case ' + i + ':out+="' + esc + '";st++;break;';
    }
    code += '}}return out;})()';
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('obfuscatedControlFlow', 'medium'),
            challenge: {
                code: code,
                format: 'code',
                filename: 'puzzle.js',
                mimeType: 'application/javascript',
                note: 'Trace the state machine. Each case appends one character. Run it or manually trace to get the output.'
            },
            solution: { flag: flag, hash: hash, method: 'Execute in console or trace switch cases' },
            hints: [
                '1. It is a state machine with a switch.',
                '2. Each case appends one character to out.',
                '3. Run the IIFE in a JS console to get output.',
                '4. Or trace: case 0 adds first char, case 1 adds second, etc.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 3: Logic gate — output bits encode flag ===== */
function generateLogicGateOutput(flag, opts) {
    opts = opts || {};
    var bytes = new TextEncoder().encode(flag);
    var bits = [];
    for (var i = 0; i < bytes.length; i++) {
        for (var b = 7; b >= 0; b--) bits.push((bytes[i] >> b) & 1);
    }
    var simplified = bits.join('');
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('logicGateOutput', 'medium'),
            challenge: {
                outputBits: simplified,
                format: 'logic',
                note: 'Output bits (0/1) encode the flag as ASCII. Each 8 bits = one character. Convert binary to bytes to string.',
                preview: simplified.substring(0, 48) + (simplified.length > 48 ? '...' : '')
            },
            solution: { flag: flag, hash: hash, method: 'Group bits into bytes (8 each), convert to ASCII' },
            hints: [
                '1. The output is a binary string of 0s and 1s.',
                '2. Each 8 bits form one ASCII character.',
                '3. Convert binary to bytes, then to string.',
                '4. Flag format: flag{...}'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 4: Logic gate truth table ===== */
function generateLogicGateTruthTable(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var chars = flag.split('');
    var table = [];
    for (var i = 0; i < chars.length; i++) {
        var c = chars[i].charCodeAt(0);
        var a = (c >> 4) & 0xF;
        var b = c & 0xF;
        table.push({ a: a, b: b, out: (a ^ b) });
    }
    var missing = table.map(function(row, i) { return { i: i, a: row.a, b: row.b }; });
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('logicGateTruthTable', 'medium'),
            challenge: {
                table: missing,
                formula: 'out = a XOR b (nibbles)',
                format: 'logic',
                note: 'Complete the truth table. out = a XOR b. Each (a,b,out) forms a nibble pair; two nibbles = one ASCII byte. Reconstruct the flag.',
                decoderHint: 'Row i: out_i = a_i XOR b_i. Byte i = (a_i<<4)|b_i or similar — the output nibbles encode the char.'
            },
            solution: { flag: flag, hash: hash, method: 'Compute out = a XOR b, combine nibbles to bytes' },
            hints: [
                '1. out = a XOR b for each row.',
                '2. Each row gives you 4-bit nibbles.',
                '3. Combine nibbles to form bytes (ASCII).',
                '4. The table length = flag length.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 5: State machine flag ===== */
function generateStateMachineFlag(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var chars = flag.split('');
    var transitions = chars.map(function(c, i) {
        return { from: 'q' + i, read: c, to: 'q' + (i + 1) };
    });
    var acceptState = 'q' + chars.length;
    var desc = 'FSM accepts the string that forms the flag. Start at q0, follow transitions. The sequence of "read" chars is the flag.';
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('stateMachineFlag', 'medium'),
            challenge: {
                start: 'q0',
                accept: acceptState,
                transitions: transitions,
                format: 'fsm',
                note: 'Trace the FSM from q0. The sequence of characters that leads to the accept state is the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'Follow transitions: read chars in order' },
            hints: [
                '1. Start at q0.',
                '2. Each transition reads one character.',
                '3. Follow the path to the accept state.',
                '4. Concatenate the read chars.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 6: XOR chain / bitwise decode ===== */
function generateBitwiseXorChain(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var key = Math.floor(rng() * 256);
    var bytes = new TextEncoder().encode(flag);
    var encoded = Array.from(bytes).map(function(b) { return b ^ key; });
    var hex = encoded.map(function(b) { return ('0' + b.toString(16)).slice(-2); }).join('');
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('bitwiseXorChain', 'beginner'),
            challenge: {
                encodedHex: hex,
                format: 'encode',
                note: 'Single-byte XOR cipher. Key is one byte. XOR each byte of the decoded hex with the key to get the flag.',
                hint: 'Key is between 0-255. Brute force or frequency analysis.'
            },
            solution: { flag: flag, hash: hash, xorKey: key, method: 'XOR each byte with key ' + key },
            hints: [
                '1. Hex decode the string to get bytes.',
                '2. Each byte is XORed with a single-byte key.',
                '3. Try keys 0-255; look for flag{',
                '4. Common keys: 0x20, 0x41, etc.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 7: Hex dump carve ===== */
function generateHexDumpCarve(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var preamble = [];
    for (var i = 0; i < 32 + Math.floor(rng() * 32); i++) preamble.push(Math.floor(rng() * 256));
    var flagBytes = new TextEncoder().encode(flag);
    var postamble = [];
    for (var i = 0; i < 16 + Math.floor(rng() * 32); i++) postamble.push(Math.floor(rng() * 256));
    var all = preamble.concat(Array.from(flagBytes), postamble);
    function toHex(b) { return ('0' + b.toString(16)).slice(-2); }
    var hexLines = [];
    for (var j = 0; j < all.length; j += 16) {
        var line = ('0000' + j.toString(16)).slice(-4) + ': ';
        for (var k = 0; k < 16 && j + k < all.length; k++) line += toHex(all[j + k]) + ' ';
        hexLines.push(line.trim());
    }
    var hexDump = hexLines.join('\n');
    var dataB64 = bytesToB64(all);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('hexDumpCarve', 'beginner'),
            challenge: {
                data: dataB64,
                hexDump: hexDump,
                format: 'binary',
                filename: 'dump.bin',
                mimeType: 'application/octet-stream',
                note: 'The hex dump contains an embedded ASCII string. Find and extract it.'
            },
            solution: { flag: flag, hash: hash, method: 'Carve printable ASCII from the hex dump' },
            hints: [
                '1. Look for runs of printable ASCII (0x20-0x7E).',
                '2. Flag format starts with flag{',
                '3. Use a hex editor or parse the dump.',
                '4. The string may be surrounded by random bytes.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 8: Struct layout parse ===== */
function generateStructLayoutParse(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var magic = 0x5245;
    var flagBytes = new TextEncoder().encode(flag);
    var arr = [];
    arr.push(magic & 0xFF, (magic >> 8) & 0xFF);
    arr.push(0, 0);
    for (var i = 0; i < 8; i++) arr.push(i < 3 ? 0x43 + i : 0);
    arr.push(flagBytes.length & 0xFF, (flagBytes.length >> 8) & 0xFF);
    for (var j = 0; j < flagBytes.length; j++) arr.push(flagBytes[j]);
    var dataB64 = bytesToB64(arr);
    var spec = 'struct { uint16_t magic; /* 0x5245 "RE" */ char pad[8]; uint16_t len; char data[len]; }';
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('structLayoutParse', 'medium'),
            challenge: {
                data: dataB64,
                spec: spec,
                format: 'binary',
                filename: 'struct.bin',
                mimeType: 'application/octet-stream',
                note: 'Parse the binary according to the struct. Magic=0x5245, then 8 bytes padding, then 16-bit length (LE), then data.'
            },
            solution: { flag: flag, hash: hash, method: 'Parse struct: offset 12 = length (LE), offset 14 = data' },
            hints: [
                '1. First 2 bytes: magic 0x5245 (LE: 45 52).',
                '2. Bytes 2-9: padding.',
                '3. Bytes 10-11: length (little-endian).',
                '4. Remaining bytes: the flag string.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 9: Endian swap ===== */
function generateEndianSwap(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var bytes = new TextEncoder().encode(flag);
    var swapped = [];
    for (var i = 0; i < bytes.length; i += 2) {
        if (i + 1 < bytes.length) {
            swapped.push(bytes[i + 1]);
            swapped.push(bytes[i]);
        } else {
            swapped.push(bytes[i]);
        }
    }
    var hex = swapped.map(function(b) { return ('0' + b.toString(16)).slice(-2); }).join(' ');
    var dataB64 = bytesToB64(swapped);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('endianSwap', 'beginner'),
            challenge: {
                data: dataB64,
                hex: hex,
                format: 'binary',
                filename: 'bytes.bin',
                mimeType: 'application/octet-stream',
                note: 'Bytes are paired and swapped (big-endian to little-endian or vice versa). Unswap each pair to get the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'Swap adjacent byte pairs, decode as UTF-8' },
            hints: [
                '1. Data is UTF-8 with byte pairs swapped.',
                '2. Swap bytes 0↔1, 2↔3, 4↔5, etc.',
                '3. Then interpret as UTF-8 string.',
                '4. Odd length: last byte stays.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 10: Static binary assets (native .bin from Docker) ===== */
var STATIC_BINARY_TYPES = {
    nativeElfStrings: { assetId: 'native-elf-1', flag: 'flag{elf_strings_master}' },
    nativeElfSymbols: { assetId: 'native-elf-2', flag: 'flag{readelf_dynsym}' }
};

function generateStaticBinary(type, flag, opts) {
    opts = opts || {};
    var meta = STATIC_BINARY_TYPES[type] || STATIC_BINARY_TYPES.nativeElfStrings;
    if (!meta) meta = { assetId: 'native-elf-1', flag: 'flag{elf_strings_master}' };
    var assetPath = '/ctf/assets/re/' + meta.assetId + '.bin';
    return flagHash(meta.flag).then(function(hash) {
        return {
            meta: makeMeta(type, 'hard'),
            challenge: {
                assetUrl: assetPath,
                format: 'binary',
                filename: meta.assetId + '.bin',
                mimeType: 'application/octet-stream',
                note: type === 'nativeElfSymbols' ? 'Use readelf or objdump. Check dynamic symbols.' : 'Run strings on this ELF binary. The flag is embedded.',
                staticAsset: true
            },
            solution: { flag: meta.flag, hash: hash, method: 'strings, readelf, objdump' },
            hints: [
                '1. Download the binary from ' + assetPath + '.',
                '2. Tools: strings, readelf, objdump.',
                '3. Flag is embedded or in symbols.',
                '4. Built as minimal ELF in Docker.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== Type registry ===== */
var GENERATORS = {
    obfuscatedString:      { fn: generateObfuscatedString,      difficulty: 'beginner' },
    obfuscatedControlFlow: { fn: generateObfuscatedControlFlow, difficulty: 'medium' },
    logicGateOutput:       { fn: generateLogicGateOutput,        difficulty: 'medium' },
    logicGateTruthTable:   { fn: generateLogicGateTruthTable,    difficulty: 'medium' },
    stateMachineFlag:      { fn: generateStateMachineFlag,       difficulty: 'medium' },
    bitwiseXorChain:       { fn: generateBitwiseXorChain,         difficulty: 'beginner' },
    hexDumpCarve:          { fn: generateHexDumpCarve,            difficulty: 'beginner' },
    structLayoutParse:     { fn: generateStructLayoutParse,       difficulty: 'medium' },
    endianSwap:            { fn: generateEndianSwap,              difficulty: 'beginner' },
    nativeElfStrings:     { fn: function(f,o){ return generateStaticBinary('nativeElfStrings',f,o); }, difficulty: 'hard', staticAsset: true },
    nativeElfSymbols:     { fn: function(f,o){ return generateStaticBinary('nativeElfSymbols',f,o); }, difficulty: 'hard', staticAsset: true }
};

function listTypes() {
    var list = [];
    for (var k in GENERATORS) list.push({ id: k, difficulty: GENERATORS[k].difficulty });
    return list;
}

function generate(type, flag, options) {
    options = options || {};
    var gen = GENERATORS[type];
    if (!gen) throw new Error('Unknown RE type: ' + type);
    return gen.fn(flag, options);
}

function generateRandom(flag, options) {
    options = options || {};
    var rng = createRng(options.seed);
    var ids = Object.keys(GENERATORS).filter(function(k) { return !GENERATORS[k].staticAsset; });
    if (ids.length === 0) ids = Object.keys(GENERATORS);
    var type = ids[Math.floor(rng() * ids.length)];
    return generate(type, flag, Object.assign({}, options, { seed: options.seed }));
}

var api = {
    listTypes: listTypes,
    generate: generate,
    generateRandom: generateRandom,
    GENERATORS: GENERATORS
};
if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
} else {
    global.CTFREEngine = api;
}
})(typeof global !== 'undefined' ? global : typeof window !== 'undefined' ? window : this);
