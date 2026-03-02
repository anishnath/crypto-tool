/**
 * CTF Steganography Engine - Node.js Tests
 * Run: node test-ctf-engine.cjs
 *
 * Tests the CTF rules engine: step roundtrips, pipeline encode/decode.
 * Uses polyfills for browser APIs. Skips real embed (needs DOM).
 */

/* ===== Polyfills ===== */
var util = require('util');
global.TextEncoder = util.TextEncoder;
global.TextDecoder = util.TextDecoder;

global.btoa = function(str) {
    return Buffer.from(str, 'binary').toString('base64');
};
global.atob = function(b64) {
    return Buffer.from(b64, 'base64').toString('binary');
};

global.crypto = require('crypto').webcrypto;

global.window = global;

function FakeCanvasCtx(width, height) {
    this._imageData = null;
    this._width = width;
    this._height = height;
}
FakeCanvasCtx.prototype.createImageData = function(w, h) { return new FakeImageData(w, h); };
FakeCanvasCtx.prototype.getImageData = function(x, y, w, h) {
    return this._imageData || new FakeImageData(w, h);
};
FakeCanvasCtx.prototype.putImageData = function(id) { this._imageData = id; };
FakeCanvasCtx.prototype.fillRect = function() {};
FakeCanvasCtx.prototype.clearRect = function() {};
FakeCanvasCtx.prototype.beginPath = function() {};
FakeCanvasCtx.prototype.arc = function() {};
FakeCanvasCtx.prototype.fill = function() {};
FakeCanvasCtx.prototype.moveTo = function() {};
FakeCanvasCtx.prototype.lineTo = function() {};
FakeCanvasCtx.prototype.stroke = function() {};
FakeCanvasCtx.prototype.fillText = function() {};
Object.defineProperty(FakeCanvasCtx.prototype, 'fillStyle', { set: function() {}, get: function() { return '#000'; } });
Object.defineProperty(FakeCanvasCtx.prototype, 'strokeStyle', { set: function() {}, get: function() { return '#000'; } });
Object.defineProperty(FakeCanvasCtx.prototype, 'lineWidth', { set: function() {}, get: function() { return 1; } });
Object.defineProperty(FakeCanvasCtx.prototype, 'font', { set: function() {}, get: function() { return '16px sans-serif'; } });
Object.defineProperty(FakeCanvasCtx.prototype, 'globalAlpha', { set: function() {}, get: function() { return 1; } });

function FakeCanvas(w, h) {
    this.width = w || 100;
    this.height = h || 100;
    this._ctx = new FakeCanvasCtx(this.width, this.height);
}
FakeCanvas.prototype.getContext = function() { return this._ctx; };
FakeCanvas.prototype.toDataURL = function() { return 'data:image/png;base64,'; };

global.document = {
    createElement: function(tag) {
        if (tag === 'canvas') return new FakeCanvas(100, 100);
        return {};
    }
};

function FakeImageData(w, h, h2) {
    if (typeof w === 'number') {
        this.width = w;
        this.height = h;
        this.data = new Uint8ClampedArray(w * h * 4);
        for (var i = 0; i < this.data.length; i++) this.data[i] = (i % 4 === 3) ? 255 : 128;
    } else {
        this.data = new Uint8ClampedArray(w);
        this.width = h;
        this.height = h2;
    }
}
global.ImageData = FakeImageData;

/* ===== Load modules ===== */
require('./src/main/webapp/js/stego-engine.js');
require('./src/main/webapp/js/stego-rs.js');
require('./src/main/webapp/js/stego-imagegen.js');
require('./src/main/webapp/ctf/js/ctf-steps.js');
require('./src/main/webapp/ctf/js/ctf-engine.js');
require('./src/main/webapp/ctf/js/ctf-crypto-engine.js');

var Steps = global.CTFSteps;
var Engine = global.CTFEngine;
var CryptoEngine = global.CTFCryptoEngine;

/* ===== Test harness ===== */
var passed = 0;
var failed = 0;

function assert(condition, name, detail) {
    if (condition) {
        passed++;
        console.log('  PASS: ' + name);
    } else {
        failed++;
        console.log('  FAIL: ' + name + (detail ? ' — ' + detail : ''));
    }
}

function assertThrows(fn, name) {
    try {
        fn();
        failed++;
        console.log('  FAIL: ' + name + ' — expected error, none thrown');
    } catch (e) {
        passed++;
        console.log('  PASS: ' + name + ' (threw: ' + e.message.slice(0, 50) + ')');
    }
}

/* ===== Step unit tests ===== */
console.log('\n=== CTF Steps (sync) ===');

assert(Steps.base64.decode(Steps.base64.encode('Hello', {}), {}) === 'Hello', 'base64 roundtrip');
assert(Steps.hex.decode(Steps.hex.encode('Hi', {}), {}) === 'Hi', 'hex roundtrip');
assert(Steps.doubleBase64.decode(Steps.doubleBase64.encode('flag', {}), {}) === 'flag', 'doubleBase64 roundtrip');
assert(Steps.doubleHex.decode(Steps.doubleHex.encode('test', {}), {}) === 'test', 'doubleHex roundtrip');
assert(Steps.base64Hex.decode(Steps.base64Hex.encode('abc', {}), {}) === 'abc', 'base64Hex roundtrip');
assert(Steps.hexBase64.decode(Steps.hexBase64.encode('xyz', {}), {}) === 'xyz', 'hexBase64 roundtrip');
assert(Steps.xor.decode(Steps.xor.encode('secret', { key: 'key123' }), { key: 'key123' }) === 'secret', 'xor roundtrip');
assert(Steps.reverse.decode(Steps.reverse.encode('reversed', {}), {}) === 'reversed', 'reverse roundtrip');
assert(Steps.rot13.decode(Steps.rot13.encode('Hello', {}), {}) === 'Hello', 'rot13 roundtrip');

console.log('\n=== CTF Steps (encodings) ===');

assert(Steps.rot47.decode(Steps.rot47.encode('Hello, World! 123', {}), {}) === 'Hello, World! 123', 'rot47 roundtrip');
assert(Steps.rot47.encode('The Quick Brown Fox Jumps Over The Lazy Dog') !== 'The Quick Brown Fox Jumps Over The Lazy Dog', 'rot47 changes input');

assert(Steps.base32.decode(Steps.base32.encode('flag{b32}', {}), {}) === 'flag{b32}', 'base32 roundtrip');
assert(Steps.base32.encode('f', {}) === 'MY======', 'base32 encode f');

assert(Steps.octal.decode(Steps.octal.encode('hi', {}), {}) === 'hi', 'octal roundtrip');
assert(Steps.octal.encode('A', {}) === '101', 'octal encode A');

assert(Steps.decimal.decode(Steps.decimal.encode('hi', {}), {}) === 'hi', 'decimal roundtrip');
assert(Steps.decimal.encode('A', {}) === '65', 'decimal encode A');

console.log('\n=== CTF Steps (classical ciphers) ===');

assert(Steps.morse.decode(Steps.morse.encode('HELLO WORLD', {}), {}) === 'HELLO WORLD', 'morse roundtrip');
assert(Steps.morse.encode('SOS', {}) === '... --- ...', 'morse encode SOS');

assert(Steps.binary.decode(Steps.binary.encode('Hi', {}), {}) === 'Hi', 'binary roundtrip');
assert(Steps.binary.encode('A', {}) === '01000001', 'binary encode A');

assert(Steps.atbash.decode(Steps.atbash.encode('Hello', {}), {}) === 'Hello', 'atbash roundtrip');
assert(Steps.atbash.encode('ABC', {}) === 'ZYX', 'atbash ABC→ZYX');

assert(Steps.caesar.decode(Steps.caesar.encode('Hello', { shift: 3 }), { shift: 3 }) === 'Hello', 'caesar roundtrip shift=3');
assert(Steps.caesar.encode('ABC', { shift: 1 }) === 'BCD', 'caesar shift=1 ABC→BCD');

assert(Steps.vigenere.decode(Steps.vigenere.encode('HELLO', { key: 'KEY' }), { key: 'KEY' }) === 'HELLO', 'vigenere roundtrip');

assert(Steps.railFence.decode(Steps.railFence.encode('WEAREDISCOVERED', { rails: 3 }), { rails: 3 }) === 'WEAREDISCOVERED', 'railFence roundtrip rails=3');
assert(Steps.railFence.decode(Steps.railFence.encode('flag{rail}', { rails: 4 }), { rails: 4 }) === 'flag{rail}', 'railFence roundtrip rails=4');

assert(Steps.bacon.encode('AB', {}).indexOf('aaaaa') === 0, 'bacon encode A starts with aaaaa');
assert(Steps.bacon.decode(Steps.bacon.encode('HELLO', {}), {}) === 'HELLO', 'bacon roundtrip');

assert(Steps.polybius.decode(Steps.polybius.encode('HELLO', {}), {}) === 'HELLO', 'polybius roundtrip');
assert(Steps.polybius.encode('A', {}) === '11', 'polybius encode A → 11');

assert(Steps.columnarTransposition.decode(Steps.columnarTransposition.encode('ATTACKATDAWN', { key: 'HACK' }), { key: 'HACK' }) === 'ATTACKATDAWN', 'columnarTransposition roundtrip');
assert(Steps.columnarTransposition.decode(Steps.columnarTransposition.encode('flag{columnar}', { key: 'KEY' }), { key: 'KEY' }) === 'flag{columnar}', 'columnarTransposition roundtrip 2');

assert(Steps.substitution.decode(Steps.substitution.encode('Hello World', { alphabet: 'QWERTYUIOPASDFGHJKLZXCVBNM' }), { alphabet: 'QWERTYUIOPASDFGHJKLZXCVBNM' }) === 'Hello World', 'substitution roundtrip');

console.log('\n=== CTF Steps (containers) ===');

assert((function() {
    var enc = Steps.tarWrap.encode('flag{tar_wrapped}', { filename: 'secret.txt' });
    var dec = Steps.tarWrap.decode(enc, {});
    return dec === 'flag{tar_wrapped}';
})(), 'tarWrap roundtrip');

assert((function() {
    var enc = Steps.innerEmbed.encode('flag{nested}', { innerWidth: 100, innerHeight: 80 });
    var dec = Steps.innerEmbed.decode(enc, {});
    return dec === 'flag{nested}';
})(), 'innerEmbed roundtrip (image-in-image)');

assert((function() {
    var enc = Steps.decoy.encode('flag{real_one}', { decoyCount: 3, marker: '<<<REAL>>>' });
    var dec = Steps.decoy.decode(enc, { marker: '<<<REAL>>>' });
    return dec === 'flag{real_one}';
})(), 'decoy roundtrip');

assert((function() {
    var enc = Steps.decoy.encode('secret', { decoyCount: 5 });
    return enc.indexOf('<<<DECOY_') >= 0 && enc.indexOf('<<<REAL>>>') >= 0;
})(), 'decoy contains decoy markers and real marker');

assert((function() {
    var enc = Steps.zipWrap.encode('flag{zipped}', { filename: 'flag.txt' });
    var dec = Steps.zipWrap.decode(enc, {});
    return dec === 'flag{zipped}';
})(), 'zipWrap roundtrip');

assert((function() {
    var enc = Steps.stringsHide.encode('flag{strings}', { chunkCount: 5, marker: 'STEG_FLAG' });
    var dec = Steps.stringsHide.decode(enc, { marker: 'STEG_FLAG' });
    return dec === 'flag{strings}';
})(), 'stringsHide roundtrip');

assert((function() {
    var img = new global.ImageData(200, 150);
    for (var i = 0; i < img.data.length; i++) img.data[i] = (i % 4 === 3) ? 255 : 128;
    var result = Steps.scatterEmbed.encode('flag{scatter}', img, { scatterKey: 'testkey' });
    return result && result.type === 'image' && result.imageData;
})(), 'scatterEmbed produces output');

console.log('\n=== CTF Steps (rsProtect) ===');
assert((function() {
    var enc = Steps.rsProtect.encode('RS test message', { parityLevel: 1 });
    if (enc.indexOf('RS:') !== 0) return false;
    var dec = Steps.rsProtect.decode(enc, {});
    return dec === 'RS test message';
})(), 'rsProtect roundtrip');

console.log('\n=== CTF Steps (classic) ===');
assert((function() {
    var cover = 'The quick brown fox jumps over the lazy dog. A B C D E F G H I J K L M N O P Q R S T U. ';
    var enc = Steps.snow.encode('flag{snow}', { coverText: cover });
    var dec = Steps.snow.decode(enc, {});
    return dec === 'flag{snow}';
})(), 'snow roundtrip');

var minimalPng = Buffer.from([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
    0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41,
    0x54, 0x08, 0xD7, 0x63, 0xF8, 0xFF, 0xFF, 0x3F,
    0x00, 0x05, 0xFE, 0x02, 0xFE, 0xDC, 0xCC, 0x59,
    0xE7, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E,
    0x44, 0xAE, 0x42, 0x60, 0x82
]);
assert((function() {
    var result = Steps.appendEof.encode('flag{appended}', null, { coverBytes: minimalPng });
    return result && result.type === 'eofAppend' && result.bytes && result.bytes.length > minimalPng.length;
})(), 'appendEof produces output');

assert((function() {
    var E = global.StegoEngine;
    if (!E || !E.encodeLSBChannel || !E.decodeLSBChannel) return false;
    var img = new global.ImageData(100, 100);
    for (var i = 0; i < img.data.length; i++) img.data[i] = (i % 4 === 3) ? 255 : 128;
    var enc = E.encodeLSBChannel(img, 'X', 0, 0);
    var dec = E.decodeLSBChannel(enc, 0, 0);
    return dec === 'X';
})(), 'encodeLSBChannel/decodeLSBChannel (red plane 0)');

/* ===== Async steps (compress, encrypt) ===== */
console.log('\n=== CTF Steps (async) ===');

Steps.compress.encode('compress me', {}).then(function(enc) {
    return Steps.compress.decode(enc, {});
}).then(function(dec) {
    assert(dec === 'compress me', 'compress roundtrip');
}).catch(function(e) {
    assert(false, 'compress roundtrip', e.message);
}).then(function() {
    return Steps.encrypt.encode('secret msg', { password: 'testpass' });
}).then(function(enc) {
    return Steps.encrypt.decode(enc, { password: 'testpass' });
}).then(function(dec) {
    assert(dec === 'secret msg', 'encrypt roundtrip');
}).catch(function(e) {
    assert(false, 'encrypt roundtrip', e.message);
}).then(function() {
    runEngineTests();
});

/* ===== Engine tests ===== */
function runEngineTests() {
    console.log('\n=== Engine: decode pipeline ===');

    var pipeline = [
        { id: 'base64', params: {} },
        { id: 'embed', params: {} }
    ];
    var extracted = btoa('plain text');
    Engine.decode(pipeline, extracted, {}).then(function(decoded) {
        assert(decoded === 'plain text', 'Engine.decode base64->embed');
        return runDecodeMultiStep();
    }).catch(function(e) {
        assert(false, 'Engine.decode base64', e.message);
        runDecodeMultiStep();
    });
}

function runDecodeMultiStep() {
    var pipeline = [
        { id: 'hex', params: {} },
        { id: 'base64', params: {} },
        { id: 'embed', params: {} }
    ];
    var hexOfHello = Steps.hex.encode('hello', {});
    var payload = Steps.base64.encode(hexOfHello, {});
    Engine.decode(pipeline, payload, {}).then(function(decoded) {
        assert(decoded === 'hello', 'Engine.decode hex->base64');
        return runDecodeWithXor();
    }).catch(function(e) {
        assert(false, 'Engine.decode hex->base64', e.message);
        runDecodeWithXor();
    });
}

function runDecodeWithXor() {
    var pipeline = [
        { id: 'xor', params: { key: 'ctfkey' } },
        { id: 'base64', params: {} },
        { id: 'embed', params: {} }
    ];
    var xored = Steps.xor.encode('xored message', { key: 'ctfkey' });
    var payload = Steps.base64.encode(xored, {});
    Engine.decode(pipeline, payload, { key: 'ctfkey' }).then(function(decoded) {
        assert(decoded === 'xored message', 'Engine.decode xor->base64');
        return runEncodeWithMockEmbed();
    }).catch(function(e) {
        assert(false, 'Engine.decode xor->base64', e.message);
        runEncodeWithMockEmbed();
    });
}

function runEncodeWithMockEmbed() {
    console.log('\n=== Engine: encode pipeline (mock embed) ===');

    Engine.registerStep('embed', {
        encode: function(payload, cover, params) {
            return { type: 'mock', payload: payload };
        }
    });

    var pipeline = [
        { id: 'base64', params: {} },
        { id: 'hex', params: {} },
        { id: 'embed', params: {} }
    ];

    Engine.encode(pipeline, 'flag{encoded}', null, {}).then(function(result) {
        var expectedHex = Steps.hex.encode(Steps.base64.encode('flag{encoded}', {}), {});
        assert(result && result.type === 'mock' && result.payload === expectedHex, 'Engine.encode base64->hex->mockEmbed');
        return runEncodeAsyncPipeline();
    }).catch(function(e) {
        assert(false, 'Engine.encode base64->hex', e.message);
        runEncodeAsyncPipeline();
    });
}

function runEncodeAsyncPipeline() {
    var pipeline = [
        { id: 'compress', params: {} },
        { id: 'base64', params: {} },
        { id: 'embed', params: {} }
    ];

    Engine.encode(pipeline, 'compressed payload', null, {}).then(function(result) {
        assert(result && result.type === 'mock', 'Engine.encode compress->base64->mockEmbed');
        var inner = Steps.base64.decode(result.payload, {});
        return Steps.compress.decode(inner, {});
    }).then(function(decoded) {
        assert(decoded === 'compressed payload', 'Engine full async pipeline roundtrip');
    }).catch(function(e) {
        assert(false, 'Engine.encode async pipeline', e.message);
    }).then(function() {
        runPresetTest();
    });
}

function runPresetTest() {
    console.log('\n=== Engine: presets ===');

    assert(Engine.getPipeline('easy').length >= 1, 'getPipeline(easy)');
    assert(Engine.getPipeline('medium').some(function(s) { return s.id === 'base64'; }), 'getPipeline(medium) has base64');
    assert(Engine.getPipeline('hard').some(function(s) { return s.id === 'compress'; }), 'getPipeline(hard) has compress');
    assert(Engine.getPipeline('pro').some(function(s) { return s.id === 'encrypt'; }), 'getPipeline(pro) has encrypt');

    var stepIds = Engine.getStepIds();
    assert(stepIds.indexOf('base64') >= 0 && stepIds.indexOf('hex') >= 0, 'getStepIds');

    console.log('\n=== Engine: robustness ===');

    var v = Engine.validatePipeline([{ id: 'embed', params: {} }]);
    assert(v.valid === true && v.errors.length === 0, 'validatePipeline valid');

    v = Engine.validatePipeline([{ id: 'base64' }]);
    assert(v.valid === false && v.errors.some(function(e) { return e.indexOf('terminal') >= 0; }), 'validatePipeline missing terminal');

    v = Engine.validatePipeline([{ id: 'nonexistent' }, { id: 'embed' }]);
    assert(v.valid === false, 'validatePipeline unknown step');

    var cap = Engine.estimateCapacity([{ id: 'embed', params: { width: 100, height: 100 } }]);
    assert(cap != null && cap > 0, 'estimateCapacity image');

    console.log('\n=== Engine: randomness ===');

    var pool = Engine.PIPELINE_POOL;
    assert(pool && pool.easy && pool.medium && pool.hard && pool.pro, 'PIPELINE_POOL exists');
    assert(pool.medium.length >= 2, 'PIPELINE_POOL.medium has variants');

    var pipe1 = Engine.getRandomPipeline('medium', { seed: 42 });
    var pipe2 = Engine.getRandomPipeline('medium', { seed: 42 });
    assert(JSON.stringify(pipe1) === JSON.stringify(pipe2), 'getRandomPipeline is deterministic with seed');

    var rnd = Engine.randomizeParams([{ id: 'embed', params: { bitDepth: 0 } }], { seed: 123 });
    assert(rnd && rnd[0] && rnd[0].params, 'randomizeParams produces params');
    assert(rnd[0].params.coverSeed != null, 'randomizeParams sets coverSeed for embed');

    assert(pool.forensic && pool.forensic.length >= 2, 'PIPELINE_POOL.forensic exists');
    assert(pool.pro.length >= 4, 'PIPELINE_POOL.pro has many variants');

    assert(Engine.normalizePayload('hi') === 'hi', 'normalizePayload string');
    assert(Engine.normalizePayload(new Uint8Array([104, 105])) === 'hi', 'normalizePayload bytes');

    var eofResult = Steps.appendEof.encode('flag', null, { coverBytes: minimalPng });
    var outBytes = Engine.getOutputBytes(eofResult);
    assert(outBytes != null && outBytes.length > minimalPng.length, 'getOutputBytes');

    runMultiLayerTests();
}

function runMultiLayerTests() {
    console.log('\n=== Engine: multi-layer pipeline decode ===');

    var morsePipe = [
        { id: 'morse', params: {} },
        { id: 'base64', params: {} },
        { id: 'embed', params: {} }
    ];
    var morseEncoded = Steps.base64.encode(Steps.morse.encode('TEST', {}), {});
    Engine.decode(morsePipe, morseEncoded, {}).then(function(decoded) {
        assert(decoded === 'TEST', 'Engine.decode morse→base64 pipeline');

        var caesarPipe = [
            { id: 'caesar', params: { shift: 5 } },
            { id: 'hex', params: {} },
            { id: 'embed', params: {} }
        ];
        var caesarEncoded = Steps.hex.encode(Steps.caesar.encode('FLAG', { shift: 5 }), {});
        return Engine.decode(caesarPipe, caesarEncoded, {});
    }).then(function(decoded) {
        assert(decoded === 'FLAG', 'Engine.decode caesar→hex pipeline');

        var tarPipe = [
            { id: 'tarWrap', params: { filename: 'flag.txt' } },
            { id: 'base64', params: {} },
            { id: 'embed', params: {} }
        ];
        var tarEncoded = Steps.base64.encode(Steps.tarWrap.encode('flag{tar}', { filename: 'flag.txt' }), {});
        return Engine.decode(tarPipe, tarEncoded, {});
    }).then(function(decoded) {
        assert(decoded === 'flag{tar}', 'Engine.decode tarWrap→base64 pipeline');

        var innerPipe = [
            { id: 'innerEmbed', params: { innerWidth: 100, innerHeight: 80 } },
            { id: 'embed', params: {} }
        ];
        return Engine.encode(innerPipe, 'flag{imageception}', null, {});
    }).then(function(result) {
        assert(result && result.type === 'mock', 'Engine.encode innerEmbed→mockEmbed produces result');
        var decoded = Steps.innerEmbed.decode(result.payload, { innerWidth: 100, innerHeight: 80 });
        assert(decoded === 'flag{imageception}', 'Engine innerEmbed roundtrip through pipeline');

        var vigPipe = [
            { id: 'vigenere', params: { key: 'STEGO' } },
            { id: 'binary', params: {} },
            { id: 'embed', params: {} }
        ];
        return Engine.encode(vigPipe, 'flag{vigenere_binary}', null, {});
    }).then(function(result) {
        assert(result && result.type === 'mock', 'Engine.encode vigenere→binary→mockEmbed');
        var inner = Steps.binary.decode(result.payload, {});
        var plain = Steps.vigenere.decode(inner, { key: 'STEGO' });
        assert(plain === 'flag{vigenere_binary}', 'Engine vigenere→binary full roundtrip');

        var decoyPipe = [
            { id: 'decoy', params: { decoyCount: 3 } },
            { id: 'base64', params: {} },
            { id: 'embed', params: {} }
        ];
        return Engine.encode(decoyPipe, 'flag{decoy_test}', null, {});
    }).then(function(result) {
        assert(result && result.type === 'mock', 'Engine.encode decoy→base64→mockEmbed');
        var inner = Steps.base64.decode(result.payload, {});
        var plain = Steps.decoy.decode(inner, {});
        assert(plain === 'flag{decoy_test}', 'Engine decoy→base64 full roundtrip');
    }).then(function() {
        // generateChallenge returns full JSON bundle
        return Engine.generateChallenge('flag{challenge_test}', 'medium', null, { seed: 999, hintCount: 4 });
    }).then(function(bundle) {
        assert(bundle && bundle.challenge && bundle.solution && bundle.hints, 'generateChallenge returns challenge, solution, hints');
        assert(bundle.solution.flag === 'flag{challenge_test}', 'solution.flag is correct');
        assert(bundle.solution.pipeline && Array.isArray(bundle.solution.pipeline), 'solution.pipeline is array');
        assert(bundle.solution.hash && bundle.solution.hash.length === 64, 'solution.hash is sha256 hex');
        assert(Array.isArray(bundle.hints) && bundle.hints.length >= 1 && bundle.hints.length <= 5, 'hints array length 1-5');
        assert(bundle.challenge.format, 'challenge has format');
        return Engine.checkFlag('flag{challenge_test}', bundle.solution.hash);
    }).then(function(check) {
        assert(check.correct === true, 'checkFlag verifies solution');
        return Engine.generateHints([{ id: 'base64', params: {} }, { id: 'embed', params: {} }], { count: 3 });
    }).then(function(hints) {
        assert(hints.length <= 3, 'generateHints respects count');
        assert(hints.some(function(h) { return h.indexOf('base64') >= 0 || h.indexOf('LSB') >= 0; }), 'hints mention relevant steps');
    }).then(function() {
        // base32 → scatterEmbed encode test (mock)
        var scatterPipe = [
            { id: 'base32', params: {} },
            { id: 'scatterEmbed', params: { scatterKey: 'testkey', width: 200, height: 150 } }
        ];
        return Engine.encode(scatterPipe, 'flag{scatter_pipe}', null, {});
    }).then(function(result) {
        assert(result && result.type === 'image', 'Engine.encode base32→scatterEmbed produces image');

        // zipWrap pipeline
        var zipPipe = [
            { id: 'hex', params: {} },
            { id: 'zipWrap', params: { filename: 'data.txt' } },
            { id: 'embed', params: {} }
        ];
        return Engine.encode(zipPipe, 'flag{zip}', null, {});
    }).then(function(result) {
        assert(result && result.type === 'mock', 'Engine.encode hex→zipWrap→mockEmbed');
        var inner = Steps.zipWrap.decode(result.payload, {});
        var plain = Steps.hex.decode(inner, {});
        assert(plain === 'flag{zip}', 'Engine hex→zipWrap full roundtrip');

        // stringsHide pipeline
        var stringsPipe = [
            { id: 'stringsHide', params: { chunkCount: 4 } },
            { id: 'base64', params: {} },
            { id: 'embed', params: {} }
        ];
        return Engine.encode(stringsPipe, 'flag{strings_pipe}', null, {});
    }).then(function(result) {
        assert(result && result.type === 'mock', 'Engine.encode stringsHide→base64→mockEmbed');

        // flagVerify
        return Engine.flagVerify('flag{test}');
    }).then(function(hash) {
        assert(typeof hash === 'string' && hash.length === 64, 'flagVerify produces sha256 hex');

        return Engine.checkFlag('flag{test}', hash);
    }).then(function(check) {
        assert(check.correct === true, 'checkFlag correct match');

        return Engine.checkFlag('wrong_flag', check.hash);
    }).then(function(check) {
        assert(check.correct === false, 'checkFlag incorrect mismatch');
        return runCryptoTests();
    }).catch(function(e) {
        assert(false, 'Multi-layer pipeline test', e.message);
    }).then(function() {
        console.log('\n=== Summary ===');
        console.log('Passed: ' + passed + ', Failed: ' + failed);
        process.exit(failed > 0 ? 1 : 0);
    });
}

function runCryptoTests() {
    console.log('\n=== New cipher steps (Phase 1) ===');

    assert(Steps.a1z26.decode(Steps.a1z26.encode('HELLO', {}), {}) === 'HELLO', 'a1z26 roundtrip');
    assert(Steps.a1z26.encode('ABC', {}) === '1-2-3', 'a1z26 encode ABC');
    assert(Steps.affine.decode(Steps.affine.encode('HELLO', { a: 5, b: 8 }), { a: 5, b: 8 }) === 'HELLO', 'affine roundtrip');
    assert(Steps.affine.encode('A', { a: 5, b: 8 }) === 'I', 'affine encode A (5*0+8=8 → I)');
    assert(Steps.ascii85.decode(Steps.ascii85.encode('Hello', {}), {}) === 'Hello', 'ascii85 roundtrip');
    assert(Steps.ascii85.encode('Hello').indexOf('<~') === 0, 'ascii85 starts with <~');
    assert(Steps.nato.decode(Steps.nato.encode('AB', {}), {}) === 'AB', 'nato roundtrip');
    assert(Steps.nato.encode('A', {}) === 'Alpha', 'nato A→Alpha');
    assert(Steps.phoneKeypad.decode(Steps.phoneKeypad.encode('HI', {}), {}) === 'HI', 'phoneKeypad roundtrip');
    assert(Steps.tapCode.decode(Steps.tapCode.encode('HELLO', {}), {}) === 'HELLO', 'tapCode roundtrip');
    assert(Steps.tapCode.encode('A', {}) === '1.1', 'tapCode A→1.1');
    assert(Steps.urlEncode.decode(Steps.urlEncode.encode('hello world!', {}), {}) === 'hello world!', 'urlEncode roundtrip');
    assert(Steps.urlEncode.encode(' ', {}) === '%20', 'urlEncode space→%20');

    console.log('\n=== New cipher steps (Phase 2) ===');

    assert(Steps.playfair.decode(Steps.playfair.encode('HELLO', { key: 'MONARCHY' }), { key: 'MONARCHY' }).indexOf('HE') === 0, 'playfair roundtrip (digraph)');
    assert(Steps.beaufort.decode(Steps.beaufort.encode('HELLO', { key: 'SECRET' }), { key: 'SECRET' }) === 'HELLO', 'beaufort roundtrip');
    assert(Steps.autokey.decode(Steps.autokey.encode('HELLO', { key: 'KEY' }), { key: 'KEY' }) === 'HELLO', 'autokey roundtrip');
    assert(Steps.bifid.decode(Steps.bifid.encode('HELLO', {}), {}) === 'HELLO', 'bifid roundtrip');
    assert(Steps.otp.decode(Steps.otp.encode('hello', { key: 'xyzab' }), { key: 'xyzab' }) === 'hello', 'otp roundtrip');

    console.log('\n=== New cipher steps (Phase 3) ===');

    assert(Steps.rc4.decode(Steps.rc4.encode('flag{rc4}', { key: 'mykey' }), { key: 'mykey' }) === 'flag{rc4}', 'rc4 roundtrip');
    assert(Steps.hillCipher.decode(Steps.hillCipher.encode('HELLO', { matrix: [3,3,2,5] }), { matrix: [3,3,2,5] }).indexOf('HE') === 0, 'hillCipher roundtrip');
    assert(Steps.rsaTextbook.decode(Steps.rsaTextbook.encode('Hi', { p: 61, q: 53, e: 17 }), { p: 61, q: 53, e: 17 }) === 'Hi', 'rsaTextbook roundtrip');
    assert(Steps.adfgvx.decode(Steps.adfgvx.encode('HELLO', { key: 'CIPHER' }), { key: 'CIPHER' }) === 'HELLO', 'adfgvx roundtrip');
    assert(Steps.nihilist.decode(Steps.nihilist.encode('HELLO', { key: 'KEY' }), { key: 'KEY' }) === 'HELLO', 'nihilist roundtrip');

    console.log('\n=== Crypto Engine (output terminal) ===');

    var outPipe = [{ id: 'base64', params: {} }, { id: 'output', params: {} }];
    var cryptoPipe = [
        { id: 'hex', params: {} },
        { id: 'base64', params: {} },
        { id: 'output', params: {} }
    ];
    var xorPipe = [
        { id: 'xor', params: { key: 'secret' } },
        { id: 'base64', params: {} },
        { id: 'output', params: {} }
    ];

    return Engine.encode(outPipe, 'flag{output_test}', null, {}).then(function(result) {
        assert(typeof result === 'string', 'output pipeline returns string');
        assert(result === Steps.base64.encode('flag{output_test}', {}), 'output pipeline returns transformed payload');
        return Engine.decode(outPipe, result, {});
    }).then(function(decoded) {
        assert(decoded === 'flag{output_test}', 'Engine.decode output pipeline roundtrip');
        return Engine.encode(cryptoPipe, 'flag{multi}', null, {});
    }).then(function(ciphertext) {
        assert(typeof ciphertext === 'string' && ciphertext.length > 0, 'multi-step output returns string');
        return Engine.decode(cryptoPipe, ciphertext, {});
    }).then(function(decoded) {
        assert(decoded === 'flag{multi}', 'Engine.decode multi-step output roundtrip');
        return Engine.encode(xorPipe, 'flag{xor_crypto}', null, { key: 'secret' });
    }).then(function(ciphertext) {
        return Engine.decode(xorPipe, ciphertext, { key: 'secret' });
    }).then(function(decoded) {
        assert(decoded === 'flag{xor_crypto}', 'Engine.decode xor+output roundtrip');

        console.log('\n=== CTFCryptoEngine: generateCryptoChallenge ===');
        return CryptoEngine.generateCryptoChallenge('flag{crypto_challenge}', 'easy', { seed: 777 });
    }).then(function(bundle) {
        assert(bundle && bundle.meta && bundle.meta.type === 'crypto', 'generateCryptoChallenge meta.type');
        assert(bundle.challenge && bundle.challenge.format === 'text', 'challenge.format is text');
        assert(typeof bundle.challenge.ciphertext === 'string', 'challenge.ciphertext is string');
        assert(bundle.solution && bundle.solution.flag === 'flag{crypto_challenge}', 'solution.flag correct');
        assert(bundle.solution.pipeline && bundle.solution.pipeline.length >= 1, 'solution.pipeline exists');
        var lastStep = bundle.solution.pipeline[bundle.solution.pipeline.length - 1];
        assert(lastStep.id === 'output', 'pipeline ends with output');
        return Engine.decode(bundle.solution.pipeline, bundle.challenge.ciphertext, bundle.solution.keys || {});
    }).then(function(decoded) {
        assert(decoded === 'flag{crypto_challenge}', 'generateCryptoChallenge decode roundtrip');

        var cryptoPool = CryptoEngine.CRYPTO_PIPELINE_POOL;
        assert(cryptoPool && cryptoPool.easy && cryptoPool.medium && cryptoPool.hard && cryptoPool.pro, 'CRYPTO_PIPELINE_POOL exists');
        assert(cryptoPool.easy.length >= 12, 'CRYPTO_PIPELINE_POOL.easy has new steps');
        var pipe1 = CryptoEngine.getRandomCryptoPipeline('medium', { seed: 100 });
        var pipe2 = CryptoEngine.getRandomCryptoPipeline('medium', { seed: 100 });
        assert(JSON.stringify(pipe1) === JSON.stringify(pipe2), 'getRandomCryptoPipeline deterministic with seed');
        assert(pipe1.length >= 2 && pipe1[pipe1.length - 1].id === 'output', 'getRandomCryptoPipeline ends with output');

        return CryptoEngine.generateCryptoChallenge('FLAGMEDIUMCRYPTO', 'medium', { seed: 555 });
    }).then(function(bundle) {
        return Engine.decode(bundle.solution.pipeline, bundle.challenge.ciphertext, bundle.solution.keys || {});
    }).then(function(decoded) {
        assert(decoded === 'FLAGMEDIUMCRYPTO', 'generateCryptoChallenge medium roundtrip');

        console.log('\n=== CTFCryptoEngine: multiPart challenge ===');
        return CryptoEngine.generateMultiPartChallenge('flag{split_into_parts}', 'easy', { seed: 300, parts: 3 });
    }).then(function(bundle) {
        assert(bundle.meta.type === 'multiPart', 'multiPart meta.type');
        assert(bundle.challenge.parts && bundle.challenge.parts.length === 3, 'multiPart has 3 parts');
        assert(bundle.solution.flag === 'flag{split_into_parts}', 'multiPart solution.flag');
        assert(bundle.solution.parts.length === 3, 'multiPart solution has 3 part solutions');

        console.log('\n=== CTFCryptoEngine: hashCrack challenge ===');
        return CryptoEngine.generateHashCrackChallenge('cipher', { seed: 400 });
    }).then(function(bundle) {
        assert(bundle.meta.type === 'hashCrack', 'hashCrack meta.type');
        assert(bundle.challenge.hash && bundle.challenge.hash.length === 64, 'hashCrack hash is sha256');
        assert(bundle.challenge.algorithm === 'SHA-256', 'hashCrack algorithm');
        assert(Array.isArray(bundle.challenge.wordlist), 'hashCrack has wordlist');
        assert(bundle.challenge.wordlist.indexOf('cipher') >= 0, 'hashCrack wordlist contains flag');
        return Engine.checkFlag('cipher', bundle.solution.hash);
    }).then(function(check) {
        assert(check.correct === true, 'hashCrack flag verifies');

        console.log('\n=== CTFCryptoEngine: cipherIdentify challenge ===');
        return CryptoEngine.generateCipherIdentifyChallenge('HELLO', { seed: 500 });
    }).then(function(bundle) {
        assert(bundle.meta.type === 'cipherIdentify', 'cipherIdentify meta.type');
        assert(bundle.challenge.format === 'multipleChoice', 'cipherIdentify is multipleChoice');
        assert(Array.isArray(bundle.challenge.choices) && bundle.challenge.choices.length === 4, 'cipherIdentify 4 choices');
        assert(bundle.challenge.choices.some(function(c) { return c.id === bundle.solution.cipherId; }), 'correct answer in choices');
        assert(typeof bundle.challenge.ciphertext === 'string' && bundle.challenge.ciphertext.length > 0, 'cipherIdentify has ciphertext');

        console.log('\n=== CTFCryptoEngine: cribDrag challenge ===');
        return CryptoEngine.generateCribDragChallenge('flag{crib}', { seed: 600 });
    }).then(function(bundle) {
        assert(bundle.meta.type === 'cribDrag', 'cribDrag meta.type');
        assert(typeof bundle.challenge.ciphertext1 === 'string', 'cribDrag has ciphertext1');
        assert(typeof bundle.challenge.ciphertext2 === 'string', 'cribDrag has ciphertext2');
        assert(bundle.solution.flag === 'flag{crib}', 'cribDrag solution.flag');

        console.log('\n=== CTFCryptoEngine: keyReuse challenge ===');
        return CryptoEngine.generateKeyReuseChallenge('FLAGSECRET', { seed: 700, cipherType: 'vigenere' });
    }).then(function(bundle) {
        assert(bundle.meta.type === 'keyReuse', 'keyReuse meta.type');
        assert(typeof bundle.challenge.ciphertext1 === 'string', 'keyReuse has ciphertext1');
        assert(typeof bundle.challenge.ciphertext2 === 'string', 'keyReuse has ciphertext2');
        assert(typeof bundle.challenge.knownPlaintext === 'string', 'keyReuse has knownPlaintext');
        assert(bundle.solution.key, 'keyReuse solution has key');
        var impl = Steps[bundle.solution.cipherType];
        var decrypted = impl.decode(bundle.challenge.ciphertext1, { key: bundle.solution.key });
        assert(decrypted === 'FLAGSECRET', 'keyReuse: decrypt ciphertext1 with recovered key');

        console.log('\n=== CTFCryptoEngine: new pipelines ===');
        var affinePipe = [{ id: 'affine', params: { a: 7, b: 3 } }, { id: 'base64', params: {} }, { id: 'output', params: {} }];
        return Engine.encode(affinePipe, 'AFFINETEST', null, {});
    }).then(function(ct) {
        return Engine.decode([{ id: 'affine', params: { a: 7, b: 3 } }, { id: 'base64', params: {} }, { id: 'output', params: {} }], ct, {});
    }).then(function(decoded) {
        assert(decoded === 'AFFINETEST', 'affine+base64+output roundtrip');

        var rc4Pipe = [{ id: 'rc4', params: { key: 'test' } }, { id: 'hex', params: {} }, { id: 'output', params: {} }];
        return Engine.encode(rc4Pipe, 'flag{rc4pipe}', null, { key: 'test' });
    }).then(function(ct) {
        return Engine.decode([{ id: 'rc4', params: { key: 'test' } }, { id: 'hex', params: {} }, { id: 'output', params: {} }], ct, { key: 'test' });
    }).then(function(decoded) {
        assert(decoded === 'flag{rc4pipe}', 'rc4+hex+output roundtrip');
        return runComposerTests();
    }).catch(function(e) {
        assert(false, 'Crypto CTF tests', e.message + '\n' + e.stack);
    });
}

function runComposerTests() {
    console.log('\n=== Dynamic Pipeline Composer ===');

    // composePipeline returns valid pipelines
    var easyPipe = CryptoEngine.composePipeline('easy', { seed: 1 });
    assert(easyPipe.length >= 2, 'compose easy: at least 2 steps (1 + output)');
    assert(easyPipe[easyPipe.length - 1].id === 'output', 'compose easy: ends with output');

    var medPipe = CryptoEngine.composePipeline('medium', { seed: 2 });
    assert(medPipe.length >= 3, 'compose medium: at least 3 steps (2 + output)');
    assert(medPipe[medPipe.length - 1].id === 'output', 'compose medium: ends with output');

    var hardPipe = CryptoEngine.composePipeline('hard', { seed: 3 });
    assert(hardPipe.length >= 3, 'compose hard: at least 3 steps');
    assert(hardPipe[hardPipe.length - 1].id === 'output', 'compose hard: ends with output');

    var proPipe = CryptoEngine.composePipeline('pro', { seed: 4 });
    assert(proPipe.length >= 3, 'compose pro: at least 3 steps');
    assert(proPipe[proPipe.length - 1].id === 'output', 'compose pro: ends with output');

    // deterministic with same seed
    var p1 = CryptoEngine.composePipeline('hard', { seed: 42 });
    var p2 = CryptoEngine.composePipeline('hard', { seed: 42 });
    assert(JSON.stringify(p1) === JSON.stringify(p2), 'compose: deterministic with seed');

    // different seeds produce different pipelines
    var p3 = CryptoEngine.composePipeline('hard', { seed: 43 });
    assert(JSON.stringify(p1) !== JSON.stringify(p3), 'compose: different seeds → different pipelines');

    // variety: 20 composed medium pipelines should have many unique combos
    var uniqueIds = {};
    for (var i = 0; i < 20; i++) {
        var pipe = CryptoEngine.composePipeline('medium', { seed: i * 13 });
        var key = pipe.map(function(s) { return s.id; }).join(',');
        uniqueIds[key] = true;
    }
    var uniqueCount = Object.keys(uniqueIds).length;
    assert(uniqueCount >= 8, 'compose medium: 20 seeds produce ' + uniqueCount + ' unique combos (>=8)');

    // variety: 20 composed hard pipelines
    var uniqueHard = {};
    for (var j = 0; j < 20; j++) {
        var pipe2 = CryptoEngine.composePipeline('hard', { seed: j * 17 });
        var key2 = pipe2.map(function(s) { return s.id; }).join(',');
        uniqueHard[key2] = true;
    }
    assert(Object.keys(uniqueHard).length >= 8, 'compose hard: 20 seeds produce ' + Object.keys(uniqueHard).length + ' unique combos (>=8)');

    console.log('\n=== Param Randomization (xor, encrypt get keys) ===');

    // xor should get random key from CRYPTO_PARAM_RANGES
    var xorPipe = CryptoEngine.randomizeCryptoParams(
        [{ id: 'xor', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        { seed: 99 }
    );
    assert(xorPipe[0].params.key && xorPipe[0].params.key.length > 0, 'xor gets random key: ' + xorPipe[0].params.key);

    // encrypt should get random password
    var encPipe = CryptoEngine.randomizeCryptoParams(
        [{ id: 'encrypt', params: {} }, { id: 'base64', params: {} }, { id: 'output', params: {} }],
        { seed: 88 }
    );
    assert(encPipe[0].params.password && encPipe[0].params.password.length > 0, 'encrypt gets random password: ' + encPipe[0].params.password);

    // different seeds → different keys
    var xorPipe2 = CryptoEngine.randomizeCryptoParams(
        [{ id: 'xor', params: {} }, { id: 'output', params: {} }],
        { seed: 100 }
    );
    var xorPipe3 = CryptoEngine.randomizeCryptoParams(
        [{ id: 'xor', params: {} }, { id: 'output', params: {} }],
        { seed: 200 }
    );
    assert(xorPipe2[0].params.key !== xorPipe3[0].params.key, 'xor: different seeds → different keys');

    console.log('\n=== compose + generate roundtrip ===');

    // Generate with compose=true and verify decode roundtrip
    return CryptoEngine.generateCryptoChallenge('COMPOSEDTEST', 'easy', { seed: 900, compose: true }).then(function(bundle) {
        assert(bundle.meta.type === 'crypto', 'compose+generate: meta.type');
        assert(bundle.solution.pipeline.length >= 2, 'compose+generate: has pipeline');
        return Engine.decode(bundle.solution.pipeline, bundle.challenge.ciphertext, bundle.solution.keys || {});
    }).then(function(decoded) {
        assert(decoded === 'COMPOSEDTEST', 'compose+generate: easy roundtrip');
        return CryptoEngine.generateCryptoChallenge('HARDCOMPOSED', 'hard', { seed: 901, compose: true });
    }).then(function(bundle) {
        return Engine.decode(bundle.solution.pipeline, bundle.challenge.ciphertext, bundle.solution.keys || {});
    }).then(function(decoded) {
        assert(decoded === 'HARDCOMPOSED', 'compose+generate: hard roundtrip');
        return CryptoEngine.generateCryptoChallenge('PROCOMPOSED', 'pro', { seed: 902, compose: true });
    }).then(function(bundle) {
        return Engine.decode(bundle.solution.pipeline, bundle.challenge.ciphertext, bundle.solution.keys || {});
    }).then(function(decoded) {
        assert(decoded === 'PROCOMPOSED', 'compose+generate: pro roundtrip');
    });
}
