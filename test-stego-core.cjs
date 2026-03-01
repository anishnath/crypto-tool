/**
 * Steganography Core Logic Tests
 * Run: node test-stego-core.js
 *
 * Tests the encode/decode pipeline covering:
 *  - Plain text (no password, no compression)
 *  - Compression only
 *  - Password only (byte-XOR)
 *  - Password + compression
 *  - Non-ASCII / Unicode messages
 *  - Wrong password detection (garbage check)
 *  - Legacy XOR backward compatibility
 *  - Edge cases: empty, max capacity, boundary lengths
 */

/* ===== Browser API polyfills for Node ===== */
var util = require('util');
global.TextEncoder = util.TextEncoder;
global.TextDecoder = util.TextDecoder;

// btoa / atob
global.btoa = function(str) {
    return Buffer.from(str, 'binary').toString('base64');
};
global.atob = function(b64) {
    return Buffer.from(b64, 'base64').toString('binary');
};

// Minimal ImageData polyfill
function FakeImageData(dataOrWidth, widthOrHeight, height) {
    if (typeof dataOrWidth === 'number') {
        this.width = dataOrWidth;
        this.height = widthOrHeight;
        this.data = new Uint8ClampedArray(dataOrWidth * widthOrHeight * 4);
        // Fill with random-ish pixel data so LSB extraction isn't all zeros
        for (var i = 0; i < this.data.length; i++) {
            this.data[i] = (i % 4 === 3) ? 255 : Math.floor(Math.random() * 256);
        }
    } else {
        this.data = new Uint8ClampedArray(dataOrWidth);
        this.width = widthOrHeight;
        this.height = height;
    }
}
global.ImageData = FakeImageData;

/* ===== Load engine (IIFE sets window.StegoEngine) ===== */
global.window = {};
require('./src/main/webapp/js/stego-engine.js');
var E = global.window.StegoEngine;

/* ===== Test harness ===== */
var passed = 0;
var failed = 0;
var errors = [];

function assert(condition, name, detail) {
    if (condition) {
        passed++;
        console.log('  PASS: ' + name);
    } else {
        failed++;
        var msg = '  FAIL: ' + name + (detail ? ' — ' + detail : '');
        console.log(msg);
        errors.push(msg);
    }
}

function assertThrows(fn, name) {
    try {
        fn();
        failed++;
        console.log('  FAIL: ' + name + ' — expected error, none thrown');
        errors.push(name);
    } catch (e) {
        passed++;
        console.log('  PASS: ' + name + ' (threw: ' + e.message.slice(0, 60) + ')');
    }
}

/* ===== Replicate stego-core.js encode/decode strategy logic ===== */

function encodePipeline(imageData, message, password, useCompression) {
    var processed = message;
    if (password) processed = E.xorEncryptBytes(message, password);
    if (useCompression) processed = btoa(processed);
    return E.encodeLSB(imageData, processed);
}

function tryDecodeStrategy(raw, useAtob, password, useByteXor) {
    try {
        var step1 = raw;
        if (useAtob) step1 = atob(raw);
        var step2 = step1;
        if (password) {
            step2 = useByteXor
                ? E.xorDecryptBytes(step1, password)
                : E.xorEncrypt(step1, password);
        }
        var ratio = E.printableRatio(step2);
        return { text: step2, ratio: ratio };
    } catch (e) {
        return null;
    }
}

function decodePipeline(imageData, password) {
    var raw = E.decodeLSB(imageData);
    var candidates = [];
    var r;

    if (password) {
        r = tryDecodeStrategy(raw, true, password, true);
        if (r) candidates.push(r);
        r = tryDecodeStrategy(raw, true, password, false);
        if (r) candidates.push(r);
        r = tryDecodeStrategy(raw, false, password, true);
        if (r) candidates.push(r);
        r = tryDecodeStrategy(raw, false, password, false);
        if (r) candidates.push(r);
    }
    r = tryDecodeStrategy(raw, true, '', false);
    if (r) candidates.push(r);
    r = tryDecodeStrategy(raw, false, '', false);
    if (r) candidates.push(r);

    var best = null;
    for (var i = 0; i < candidates.length; i++) {
        if (!best || candidates[i].ratio > best.ratio) best = candidates[i];
    }
    return best;
}

/* ===== Helper: create image large enough for a message ===== */
function makeImage(msgByteLen) {
    // Need (msgByteLen + 4) * 8 bits, each uses 1 of 3 RGB channels per pixel
    var bitsNeeded = (msgByteLen + 4 + 16) * 8; // +16 headroom
    var pixelsNeeded = Math.ceil(bitsNeeded / 3);
    var side = Math.ceil(Math.sqrt(pixelsNeeded));
    return new FakeImageData(side, side);
}

/* =================================================================
   TEST SUITES
   ================================================================= */

console.log('\n=== 1. Plain text (no password, no compression) ===');
(function() {
    var msg = 'Hello, World!';
    var img = makeImage(msg.length + 20);
    var encoded = encodePipeline(img, msg, '', false);
    var result = decodePipeline(encoded, '');
    assert(result !== null, 'decode returns a result');
    assert(result.text === msg, 'decoded text matches', 'got: "' + (result ? result.text : '') + '"');
    assert(result.ratio > 0.9, 'high printable ratio', 'ratio: ' + (result ? result.ratio : 0));
})();

console.log('\n=== 2. Compression only (no password) ===');
(function() {
    var msg = 'This message is compressed with base64 encoding.';
    var img = makeImage(200);
    var encoded = encodePipeline(img, msg, '', true);
    var result = decodePipeline(encoded, '');
    assert(result !== null, 'decode returns a result');
    assert(result.text === msg, 'decoded text matches', 'got: "' + (result ? result.text : '') + '"');
})();

console.log('\n=== 3. Password only (byte-XOR, no compression) ===');
(function() {
    var msg = 'Secret password-protected message';
    var pwd = 'myP@ssw0rd';
    var img = makeImage(200);
    var encoded = encodePipeline(img, msg, pwd, false);

    // Decode with correct password
    var result = decodePipeline(encoded, pwd);
    assert(result !== null, 'decode with correct password returns result');
    assert(result.text === msg, 'decoded text matches', 'got: "' + (result ? result.text : '') + '"');
    assert(result.ratio > 0.9, 'high printable ratio');
})();

console.log('\n=== 4. Password + compression (standard pipeline) ===');
(function() {
    var msg = 'Full pipeline: password + compression together';
    var pwd = 'strongKey123!';
    var img = makeImage(300);
    var encoded = encodePipeline(img, msg, pwd, true);

    var result = decodePipeline(encoded, pwd);
    assert(result !== null, 'decode returns result');
    assert(result.text === msg, 'decoded text matches', 'got: "' + (result ? result.text : '') + '"');
    assert(result.ratio > 0.9, 'high printable ratio');
})();

console.log('\n=== 5. Unicode / non-ASCII messages ===');
(function() {
    var msg = 'Hello 世界! Привет! 🚀 café résumé';
    var img = makeImage(300);

    // Without password
    var encoded = encodePipeline(img, msg, '', false);
    var result = decodePipeline(encoded, '');
    assert(result !== null, 'unicode no-password decode');
    assert(result.text === msg, 'unicode text matches (no pwd)', 'got: "' + (result ? result.text : '') + '"');

    // With password
    var img2 = makeImage(300);
    var encoded2 = encodePipeline(img2, msg, 'unicodePwd', true);
    var result2 = decodePipeline(encoded2, 'unicodePwd');
    assert(result2 !== null, 'unicode with-password decode');
    assert(result2.text === msg, 'unicode text matches (with pwd)', 'got: "' + (result2 ? result2.text : '') + '"');
})();

console.log('\n=== 6. Wrong password detection ===');
(function() {
    var msg = 'This should be unreadable with wrong password';
    var pwd = 'correctPassword';
    var img = makeImage(300);
    var encoded = encodePipeline(img, msg, pwd, true);

    // Decode with wrong password
    var result = decodePipeline(encoded, 'wrongPassword');
    assert(result !== null, 'wrong password returns a result');
    assert(result.text !== msg, 'wrong password does not return original message');
    // The best candidate might still have low ratio (garbage from wrong XOR)
    // or it might pick the raw/compressed-only candidate which is also not the original
    console.log('    (wrong pwd best ratio: ' + (result ? result.ratio.toFixed(3) : 'null') + ')');

    // Decode with no password at all
    var result2 = decodePipeline(encoded, '');
    assert(result2 !== null, 'no-password decode of password-protected image');
    assert(result2.text !== msg, 'no-password does not reveal original');
})();

console.log('\n=== 7. Legacy XOR backward compatibility ===');
(function() {
    // Simulate encoding done with old xorEncrypt (UTF-16 code unit XOR)
    var msg = 'Legacy encoded message';
    var pwd = 'oldPwd';
    var img = makeImage(200);

    // Old pipeline: xorEncrypt + btoa
    var processed = E.xorEncrypt(msg, pwd);
    processed = btoa(processed);
    var encoded = E.encodeLSB(img, processed);

    // New decode pipeline should still recover it via legacy XOR candidate
    var result = decodePipeline(encoded, pwd);
    assert(result !== null, 'legacy decode returns result');
    assert(result.text === msg, 'legacy decoded text matches', 'got: "' + (result ? result.text : '') + '"');
})();

console.log('\n=== 8. Direct engine functions ===');
(function() {
    // encodeLSB / decodeLSB roundtrip
    var msg = 'Direct engine test';
    var img = makeImage(100);
    var encoded = E.encodeLSB(img, msg);
    var decoded = E.decodeLSB(encoded);
    assert(decoded === msg, 'encodeLSB/decodeLSB roundtrip');

    // decodeWithLengthHeader specifically
    var decoded2 = E.decodeWithLengthHeader(encoded);
    assert(decoded2 === msg, 'decodeWithLengthHeader roundtrip');
})();

console.log('\n=== 9. XOR byte-safe roundtrip ===');
(function() {
    var msg = 'Test XOR: café 日本語 🎉';
    var pwd = 'xorKey!';

    var encrypted = E.xorEncryptBytes(msg, pwd);
    var decrypted = E.xorDecryptBytes(encrypted, pwd);
    assert(decrypted === msg, 'xorEncryptBytes/xorDecryptBytes roundtrip', 'got: "' + decrypted + '"');

    // Verify encrypted is Latin-1 safe (all char codes 0-255) for btoa
    var safe = true;
    for (var i = 0; i < encrypted.length; i++) {
        if (encrypted.charCodeAt(i) > 255) { safe = false; break; }
    }
    assert(safe, 'xorEncryptBytes output is Latin-1 safe for btoa');

    // btoa roundtrip
    var b64 = btoa(encrypted);
    var fromB64 = atob(b64);
    var final = E.xorDecryptBytes(fromB64, pwd);
    assert(final === msg, 'btoa(xorEncryptBytes) roundtrip', 'got: "' + final + '"');
})();

console.log('\n=== 10. printableRatio ===');
(function() {
    assert(E.printableRatio('Hello World') === 1.0, 'pure ASCII = 1.0');
    assert(E.printableRatio('') === 0, 'empty string = 0');
    assert(E.printableRatio('abc\x01\x02\x03') === 0.5, '50% printable');
    // Unicode chars >= 160 count as printable
    assert(E.printableRatio('café') > 0.9, 'accented chars are printable');
})();

console.log('\n=== 11. Capacity limits ===');
(function() {
    // Small image: 4x4 = 16 pixels = 48 RGB channels = 6 bytes capacity - 4 header = 2 bytes
    var tiny = new FakeImageData(4, 4);
    var maxCap = Math.floor((tiny.data.length / 4) * 3 / 8) - 4;
    console.log('    4x4 image capacity: ' + maxCap + ' bytes');

    // Should succeed with small message
    var shortMsg = 'AB';
    if (shortMsg.length <= maxCap) {
        var enc = E.encodeLSB(tiny, shortMsg);
        var dec = E.decodeLSB(enc);
        assert(dec === shortMsg, 'encode tiny message in small image');
    }

    // Should throw on oversized message
    var longMsg = 'A'.repeat(maxCap + 1);
    assertThrows(function() { E.encodeLSB(tiny, longMsg); }, 'reject message exceeding capacity');
})();

console.log('\n=== 12. formatBytes / escapeHtml ===');
(function() {
    assert(E.formatBytes(0) === '0 B', 'formatBytes(0)');
    assert(E.formatBytes(1024) === '1 KB', 'formatBytes(1024)');
    assert(E.formatBytes(1536) === '1.5 KB', 'formatBytes(1536)');
    assert(E.escapeHtml('<script>alert("xss")</script>') === '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;', 'escapeHtml XSS');
    assert(E.escapeHtml("it's & fun") === "it&#039;s &amp; fun", 'escapeHtml quotes & amp');
})();

console.log('\n=== 13. Multi-byte length header correctness ===');
(function() {
    // Encode a string where UTF-8 byte length != JS string length
    // "日本" = 2 chars but 6 UTF-8 bytes
    var msg = '日本';
    var byteLen = new TextEncoder().encode(msg).length;
    assert(byteLen === 6, 'verify "日本" is 6 UTF-8 bytes', 'got: ' + byteLen);

    var img = makeImage(100);
    var encoded = E.encodeLSB(img, msg);
    var decoded = E.decodeLSB(encoded);
    assert(decoded === msg, 'multi-byte header encode/decode roundtrip', 'got: "' + decoded + '"');
})();

console.log('\n=== 14. Long message stress test ===');
(function() {
    var msg = '';
    for (var i = 0; i < 500; i++) msg += 'Line ' + i + ': The quick brown fox jumps over the lazy dog.\n';
    // btoa expands ~33%, XOR+btoa can be larger; allocate generously
    var compressedSize = Math.ceil(new TextEncoder().encode(msg).length * 1.5) + 200;
    var img = makeImage(compressedSize);
    var encoded = encodePipeline(img, msg, 'stressKey', true);
    var result = decodePipeline(encoded, 'stressKey');
    assert(result !== null, 'long message decode');
    assert(result.text === msg, 'long message text matches', 'lengths: expected=' + msg.length + ' got=' + (result ? result.text.length : 0));
    assert(result.ratio > 0.95, 'long message printable ratio');
})();

console.log('\n=== 15. File embedding (encodeLSBFile / decodeLSBPayload) ===');
(function() {
    // Encode a file
    var filename = 'test-document.pdf';
    var fileBytes = new Uint8Array([0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34]); // %PDF-1.4
    var img = makeImage(200);
    var encoded = E.encodeLSBFile(img, fileBytes, filename);

    // Decode and verify it comes back as a file
    var payload = E.decodeLSBPayload(encoded);
    assert(payload !== null, 'file payload decoded');
    assert(payload.type === 'file', 'payload type is file', 'got: ' + (payload ? payload.type : ''));
    assert(payload.filename === filename, 'filename matches', 'got: "' + (payload ? payload.filename : '') + '"');
    assert(payload.data.length === fileBytes.length, 'file data length matches', 'expected: ' + fileBytes.length + ' got: ' + (payload ? payload.data.length : 0));

    // Verify byte content
    var bytesMatch = true;
    if (payload && payload.data) {
        for (var i = 0; i < fileBytes.length; i++) {
            if (payload.data[i] !== fileBytes[i]) { bytesMatch = false; break; }
        }
    } else {
        bytesMatch = false;
    }
    assert(bytesMatch, 'file bytes match exactly');
})();

console.log('\n=== 16. File embedding — capacity error ===');
(function() {
    var tiny = new FakeImageData(4, 4);
    var bigFile = new Uint8Array(100); // Way too big for 4x4
    assertThrows(function() { E.encodeLSBFile(tiny, bigFile, 'big.bin'); }, 'file too large throws error');
})();

console.log('\n=== 17. decodeLSBPayload — legacy text (no type byte) ===');
(function() {
    // Standard text encode via encodeLSB should be decoded as legacy text
    var msg = 'Legacy text message test';
    var img = makeImage(200);
    var encoded = E.encodeLSB(img, msg);
    var payload = E.decodeLSBPayload(encoded);
    assert(payload !== null, 'legacy text payload decoded');
    assert(payload.type === 'text', 'legacy payload type is text', 'got: ' + (payload ? payload.type : ''));
    assert(payload.data === msg, 'legacy text matches', 'got: "' + (payload ? payload.data : '') + '"');
})();

console.log('\n=== 18. extractBitPlane ===');
(function() {
    // Create a small image with known pixel values
    var w = 4, h = 4;
    var img = new FakeImageData(w, h);
    // Set pixel 0 to R=255 (all bits set), G=0, B=0
    img.data[0] = 255; img.data[1] = 0; img.data[2] = 0; img.data[3] = 255;

    // Extract R channel, plane 0 (LSB) — pixel 0 R=255 has bit 0 set
    var bp = E.extractBitPlane(img, 0, 0);
    assert(bp.data[0] === 255, 'R=255 bit plane 0 is white (255)', 'got: ' + bp.data[0]);
    assert(bp.data[4] !== undefined, 'output has correct length');

    // G channel plane 0 of pixel 0: G=0, bit 0 = 0 → black
    var bpG = E.extractBitPlane(img, 1, 0);
    assert(bpG.data[0] === 0, 'G=0 bit plane 0 is black (0)', 'got: ' + bpG.data[0]);

    // All channels mode
    var bpAll = E.extractBitPlane(img, 3, 0);
    assert(bpAll.data[0] === 255, 'All mode: R bit is red channel');
    assert(bpAll.data[1] === 0, 'All mode: G bit is green channel');
    assert(bpAll.data[2] === 0, 'All mode: B bit is blue channel');
})();

console.log('\n=== 19. extractBitPlane — higher planes ===');
(function() {
    var w = 2, h = 2;
    var img = new FakeImageData(w, h);
    // R=128 = 10000000, so bit plane 7 = 1, bit plane 0 = 0
    img.data[0] = 128; img.data[1] = 0; img.data[2] = 0; img.data[3] = 255;

    var bp7 = E.extractBitPlane(img, 0, 7);
    assert(bp7.data[0] === 255, 'R=128 plane 7 is white', 'got: ' + bp7.data[0]);

    var bp0 = E.extractBitPlane(img, 0, 0);
    assert(bp0.data[0] === 0, 'R=128 plane 0 is black', 'got: ' + bp0.data[0]);
})();

console.log('\n=== 20. calculateRequiredDimensions — already sufficient ===');
(function() {
    var dims = E.calculateRequiredDimensions(100, 200, 200);
    assert(dims.width === 200 && dims.height === 200, 'returns original dims when capacity is sufficient', 'got: ' + dims.width + 'x' + dims.height);
})();

console.log('\n=== 21. calculateRequiredDimensions — needs upscale ===');
(function() {
    // 10x10 image: capacity = floor(10*10*3/8) - 4 = floor(37.5) - 4 = 33 bytes
    var dims = E.calculateRequiredDimensions(5000, 10, 10);
    assert(dims.width > 10, 'width increased', 'got: ' + dims.width);
    assert(dims.height > 10, 'height increased', 'got: ' + dims.height);
    // Verify the new dimensions have enough capacity
    var newCapacity = Math.floor((dims.width * dims.height * 3) / 8) - 4;
    assert(newCapacity >= 5000, 'new capacity >= 5000', 'got: ' + newCapacity);
    // Verify aspect ratio maintained (should be square since original is square)
    assert(dims.width === dims.height, 'aspect ratio maintained (square)', dims.width + 'x' + dims.height);
})();

console.log('\n=== 22. calculateRequiredDimensions — rectangular image ===');
(function() {
    // 20x10 image (2:1 aspect ratio)
    var dims = E.calculateRequiredDimensions(10000, 20, 10);
    assert(dims.width > 20, 'width increased');
    assert(dims.height > 10, 'height increased');
    // Scale factor is integer, so ratio w/h should still be 2:1
    assert(dims.width / dims.height === 2, 'aspect ratio preserved at 2:1', 'got: ' + dims.width + 'x' + dims.height);
    var newCapacity = Math.floor((dims.width * dims.height * 3) / 8) - 4;
    assert(newCapacity >= 10000, 'new capacity >= 10000', 'got: ' + newCapacity);
})();

console.log('\n=== 23. File encoding with auto-upscale dimensions ===');
(function() {
    // Create a small 10x10 image (capacity ~33 bytes) and try to embed a 500-byte file
    var tiny = new FakeImageData(10, 10);
    var bigFile = new Uint8Array(500);
    for (var i = 0; i < bigFile.length; i++) bigFile[i] = i & 0xFF;
    var filename = 'test.bin';

    // Compute upscaled dimensions
    var filenameBytes = new TextEncoder().encode(filename).length;
    var neededBytes = 1 + 1 + filenameBytes + bigFile.length;
    var dims = E.calculateRequiredDimensions(neededBytes, 10, 10);
    assert(dims.width > 10, 'upscale needed for 500-byte file in 10x10 image');

    // Create upscaled image and encode
    var upscaled = new FakeImageData(dims.width, dims.height);
    var encoded = E.encodeLSBFile(upscaled, bigFile, filename);
    var payload = E.decodeLSBPayload(encoded);
    assert(payload.type === 'file', 'decoded as file after upscale');
    assert(payload.filename === filename, 'filename preserved after upscale');
    assert(payload.data.length === 500, 'file data length preserved', 'got: ' + payload.data.length);

    // Verify byte content
    var match = true;
    for (var j = 0; j < bigFile.length; j++) {
        if (payload.data[j] !== bigFile[j]) { match = false; break; }
    }
    assert(match, 'file bytes match exactly after upscale encoding');
})();

/* ===== Summary ===== */
console.log('\n========================================');
console.log('  Results: ' + passed + ' passed, ' + failed + ' failed');
console.log('========================================');
if (errors.length > 0) {
    console.log('\nFailures:');
    for (var i = 0; i < errors.length; i++) console.log(errors[i]);
}
process.exit(failed > 0 ? 1 : 0);
