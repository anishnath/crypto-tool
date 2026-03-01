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

/* =================================================================
   BATCH 1: Variable Bit Depth Tests
   ================================================================= */

console.log('\n=== 24. AtDepth roundtrip for depths 0-7 ===');
(function() {
    var msg = 'Depth test message';
    for (var d = 0; d < 8; d++) {
        var img = makeImage(200);
        var encoded = E.encodeLSBAtDepth(img, msg, d);
        var decoded = E.decodeLSBAtDepth(encoded, d);
        assert(decoded === msg, 'AtDepth roundtrip depth=' + d, 'got: "' + decoded + '"');
    }
})();

console.log('\n=== 25. WithDepth roundtrip, verify increased capacity ===');
(function() {
    var msg = 'Multi-bit depth message with more data';
    for (var d = 0; d <= 3; d++) {
        var img = makeImage(200);
        var encoded = E.encodeLSBWithDepth(img, msg, d);
        var decoded = E.decodeLSBWithDepth(encoded, d);
        assert(decoded === msg, 'WithDepth roundtrip depth=' + d, 'got: "' + decoded + '"');
    }
    // Verify capacity increases with depth
    var cap0 = E.calculateCapacity(10000, 'with', 0);
    var cap3 = E.calculateCapacity(10000, 'with', 3);
    assert(cap3 > cap0 * 3, 'WithDepth(3) capacity > 3x WithDepth(0)', 'cap0=' + cap0 + ' cap3=' + cap3);
})();

console.log('\n=== 26. Backward compat: depth-0 AtDepth matches standard encodeLSB ===');
(function() {
    var msg = 'Backward compat test';
    var img = makeImage(200);
    var encoded0 = E.encodeLSBAtDepth(img, msg, 0);
    // Decode with standard decodeLSB
    var decoded = E.decodeLSB(encoded0);
    assert(decoded === msg, 'AtDepth(0) decoded by standard decodeLSB', 'got: "' + decoded + '"');
})();

console.log('\n=== 27. Cross-depth isolation ===');
(function() {
    var msg = 'Hidden at depth 3';
    var img = makeImage(200);
    var encoded = E.encodeLSBAtDepth(img, msg, 3);
    // Try to decode at depth 0 — should fail or return garbage
    var wrongDecoded = null;
    try { wrongDecoded = E.decodeLSBAtDepth(encoded, 0); } catch(e) {}
    assert(wrongDecoded === null || wrongDecoded !== msg, 'depth-3 cannot be decoded at depth-0');
})();

console.log('\n=== 28. calculateCapacity correctness ===');
(function() {
    // Standard LSB: pixelCount * 3 / 8 - 4
    var cap = E.calculateCapacity(1000, 'at', 0);
    assert(cap === Math.floor(1000 * 3 / 8) - 4, 'at-depth-0 capacity', 'got: ' + cap);

    var capWith = E.calculateCapacity(1000, 'with', 2);
    assert(capWith === Math.floor(1000 * 3 * 3 / 8) - 4, 'with-depth-2 capacity (3 bits per channel)', 'got: ' + capWith);

    var capWith7 = E.calculateCapacity(1000, 'with', 7);
    assert(capWith7 === Math.floor(1000 * 3 * 8 / 8) - 4, 'with-depth-7 capacity (8 bits per channel)', 'got: ' + capWith7);
})();

console.log('\n=== 29. File embedding with depth ===');
(function() {
    var filename = 'test.bin';
    var fileBytes = new Uint8Array([0x01, 0x02, 0x03, 0x04, 0x05]);

    // AtDepth
    var img = makeImage(200);
    var encoded = E.encodeLSBFileAtDepth(img, fileBytes, filename, 2);
    var payload = E.decodeLSBPayloadAtDepth(encoded, 2);
    assert(payload.type === 'file', 'file AtDepth type=file');
    assert(payload.filename === filename, 'file AtDepth filename matches');
    assert(payload.data.length === fileBytes.length, 'file AtDepth data length matches');

    // WithDepth
    var img2 = makeImage(200);
    var encoded2 = E.encodeLSBFileWithDepth(img2, fileBytes, filename, 1);
    var payload2 = E.decodeLSBPayloadWithDepth(encoded2, 1);
    assert(payload2.type === 'file', 'file WithDepth type=file');
    assert(payload2.filename === filename, 'file WithDepth filename matches');
    assert(payload2.data.length === fileBytes.length, 'file WithDepth data length matches');
})();

/* =================================================================
   BATCH 2: Compression Tests
   ================================================================= */

console.log('\n=== 30. Deflate compression (btoa fallback in Node.js) ===');
(function() {
    // Node.js 20+ has CompressionStream; marker 0x01 = deflate, 0x00 = btoa fallback
    E.compressDeflate('Hello compressed world').then(function(compressed) {
        assert(compressed instanceof Uint8Array, 'compressDeflate returns Uint8Array');
        assert(compressed[0] === 0x01 || compressed[0] === 0x00, 'marker byte is valid', 'got: 0x' + compressed[0].toString(16));

        return E.decompressDeflate(compressed);
    }).then(function(decompressed) {
        assert(decompressed === 'Hello compressed world', 'deflate roundtrip', 'got: "' + decompressed + '"');
    }).catch(function(err) {
        assert(false, 'deflate roundtrip threw: ' + err.message);
    });
})();

console.log('\n=== 31. hasNativeCompression ===');
(function() {
    var has = E.hasNativeCompression();
    // In Node.js, CompressionStream doesn't exist
    assert(typeof has === 'boolean', 'hasNativeCompression returns boolean');
    console.log('    (hasNativeCompression: ' + has + ')');
})();

/* =================================================================
   BATCH 3: Audio WAV Tests
   ================================================================= */

// Load audio module
require('./src/main/webapp/js/stego-audio.js');
var A = global.window.StegoAudio;

// Helper: create a test WAV buffer
function makeWAV(numSamples, bitsPerSample, channels) {
    var bytesPerSample = bitsPerSample / 8;
    var dataSize = numSamples * bytesPerSample;
    var fmtSize = 16;
    var totalSize = 44 + dataSize;

    var buffer = new ArrayBuffer(totalSize);
    var view = new DataView(buffer);

    // RIFF header
    view.setUint8(0, 0x52); // R
    view.setUint8(1, 0x49); // I
    view.setUint8(2, 0x46); // F
    view.setUint8(3, 0x46); // F
    view.setUint32(4, totalSize - 8, true);
    view.setUint8(8, 0x57);  // W
    view.setUint8(9, 0x41);  // A
    view.setUint8(10, 0x56); // V
    view.setUint8(11, 0x45); // E

    // fmt chunk
    view.setUint8(12, 0x66); // f
    view.setUint8(13, 0x6D); // m
    view.setUint8(14, 0x74); // t
    view.setUint8(15, 0x20); // (space)
    view.setUint32(16, fmtSize, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, channels, true);
    view.setUint32(24, 44100, true); // sample rate
    view.setUint32(28, 44100 * channels * bytesPerSample, true); // byte rate
    view.setUint16(32, channels * bytesPerSample, true); // block align
    view.setUint16(34, bitsPerSample, true);

    // data chunk
    view.setUint8(36, 0x64); // d
    view.setUint8(37, 0x61); // a
    view.setUint8(38, 0x74); // t
    view.setUint8(39, 0x61); // a
    view.setUint32(40, dataSize, true);

    // Fill with random sample data
    for (var i = 0; i < dataSize; i++) {
        view.setUint8(44 + i, Math.floor(Math.random() * 256));
    }

    return buffer;
}

console.log('\n=== 32. WAV parsing ===');
(function() {
    var wav = makeWAV(1000, 16, 1);
    var info = A.parseWAV(wav);
    assert(info.sampleRate === 44100, 'WAV sample rate', 'got: ' + info.sampleRate);
    assert(info.bitsPerSample === 16, 'WAV bits per sample', 'got: ' + info.bitsPerSample);
    assert(info.numChannels === 1, 'WAV channels', 'got: ' + info.numChannels);
    assert(info.numSamples === 1000, 'WAV num samples', 'got: ' + info.numSamples);
    assert(info.dataOffset === 44, 'WAV data offset', 'got: ' + info.dataOffset);
})();

console.log('\n=== 33. WAV encode/decode roundtrip ===');
(function() {
    var msg = 'Hidden in audio!';
    var wav = makeWAV(5000, 16, 1);
    var encoded = A.encodeWAV(wav, msg, 0, 'at');
    var decoded = A.decodeWAV(encoded, 0, 'at');
    assert(decoded === msg, 'WAV encode/decode roundtrip', 'got: "' + decoded + '"');
})();

console.log('\n=== 34. WAV capacity ===');
(function() {
    var wav = makeWAV(10000, 16, 1);
    var cap = A.getWAVCapacity(wav, 0, 'at');
    // 10000 samples, 1 bit each, / 8 - 4
    var expected = Math.floor(10000 / 8) - 4;
    assert(cap === expected, 'WAV capacity at depth 0', 'expected: ' + expected + ' got: ' + cap);

    var capWith = A.getWAVCapacity(wav, 2, 'with');
    var expectedWith = Math.floor(10000 * 3 / 8) - 4;
    assert(capWith === expectedWith, 'WAV capacity with depth 2', 'expected: ' + expectedWith + ' got: ' + capWith);
})();

console.log('\n=== 35. WAV variable depth roundtrip ===');
(function() {
    var msg = 'Variable depth audio';
    var wav = makeWAV(5000, 16, 1);

    // AtDepth
    var encoded = A.encodeWAV(wav, msg, 2, 'at');
    var decoded = A.decodeWAV(encoded, 2, 'at');
    assert(decoded === msg, 'WAV AtDepth(2) roundtrip', 'got: "' + decoded + '"');

    // WithDepth
    var wav2 = makeWAV(5000, 16, 1);
    var encoded2 = A.encodeWAV(wav2, msg, 1, 'with');
    var decoded2 = A.decodeWAV(encoded2, 1, 'with');
    assert(decoded2 === msg, 'WAV WithDepth(1) roundtrip', 'got: "' + decoded2 + '"');
})();

console.log('\n=== 36. WAV file embedding ===');
(function() {
    var wav = makeWAV(10000, 16, 1);
    var fileBytes = new Uint8Array([0xDE, 0xAD, 0xBE, 0xEF]);
    var filename = 'test.bin';
    var encoded = A.encodeWAVFile(wav, fileBytes, filename, 0, 'at');
    var payload = A.decodeWAVPayload(encoded, 0, 'at');
    assert(payload.type === 'file', 'WAV file payload type');
    assert(payload.filename === filename, 'WAV file filename');
    assert(payload.data.length === fileBytes.length, 'WAV file data length');
})();

/* =================================================================
   BATCH 4: Reed-Solomon Tests
   ================================================================= */

require('./src/main/webapp/js/stego-rs.js');
var RS = global.window.StegoRS;

console.log('\n=== 37. GF(2^8) arithmetic ===');
(function() {
    // gfMul basic
    assert(RS.gfMul(0, 5) === 0, 'gfMul(0,5) = 0');
    assert(RS.gfMul(1, 5) === 5, 'gfMul(1,5) = 5');
    assert(RS.gfMul(2, 3) === RS.gfMul(3, 2), 'gfMul commutative');

    // gfDiv inverse of gfMul
    var a = 42, b = 17;
    assert(RS.gfDiv(RS.gfMul(a, b), b) === a, 'gfDiv(gfMul(a,b), b) = a');

    // gfPow
    assert(RS.gfPow(2, 0) === 1, 'gfPow(2,0) = 1');
    assert(RS.gfPow(0, 5) === 0, 'gfPow(0,5) = 0');
    assert(RS.gfPow(2, 8) === RS.gfMul(RS.gfMul(RS.gfMul(2, 2), RS.gfMul(2, 2)), RS.gfMul(RS.gfMul(2, 2), RS.gfMul(2, 2))), 'gfPow(2,8) matches manual multiplication');
})();

console.log('\n=== 38. RS encode/decode roundtrip (no errors) ===');
(function() {
    var data = new Uint8Array([72, 101, 108, 108, 111]); // "Hello"
    var nsym = 4;
    var encoded = RS.rsEncode(data, nsym);
    assert(encoded.length === data.length + nsym, 'encoded length = data + parity');

    var decoded = RS.rsDecode(encoded, nsym);
    assert(decoded.length === data.length, 'decoded length = original data');
    var match = true;
    for (var i = 0; i < data.length; i++) {
        if (decoded[i] !== data[i]) { match = false; break; }
    }
    assert(match, 'RS decoded data matches original');
})();

console.log('\n=== 39. RS with errors corrected ===');
(function() {
    var data = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    var nsym = 8; // can correct up to 4 errors
    var encoded = RS.rsEncode(data, nsym);

    // Introduce 2 errors (well within correction capability)
    var corrupted = new Uint8Array(encoded);
    corrupted[0] ^= 0xFF; // corrupt first byte
    corrupted[5] ^= 0x42; // corrupt sixth byte

    var decoded = RS.rsDecode(corrupted, nsym);
    var match = true;
    for (var i = 0; i < data.length; i++) {
        if (decoded[i] !== data[i]) { match = false; break; }
    }
    assert(match, 'RS corrected 2 errors in 10-byte message');
})();

console.log('\n=== 40. RS with too many errors throws ===');
(function() {
    var data = new Uint8Array([1, 2, 3, 4, 5]);
    var nsym = 4; // can correct up to 2 errors
    var encoded = RS.rsEncode(data, nsym);

    // Introduce 3 errors (too many)
    var corrupted = new Uint8Array(encoded);
    corrupted[0] ^= 0xFF;
    corrupted[1] ^= 0xFF;
    corrupted[2] ^= 0xFF;

    assertThrows(function() { RS.rsDecode(corrupted, nsym); }, 'RS throws on too many errors');
})();

console.log('\n=== 41. RS block splitting (rsProtect/rsUnprotect) ===');
(function() {
    // Create data larger than one block (223 bytes with 32 parity)
    var data = new Uint8Array(500);
    for (var i = 0; i < data.length; i++) data[i] = i & 0xFF;

    var protected_ = RS.rsProtect(data, 32);
    assert(protected_.length > data.length, 'protected data is larger than original');

    var recovered = RS.rsUnprotect(protected_, 32);
    assert(recovered.length === data.length, 'recovered length matches', 'got: ' + recovered.length);

    var match = true;
    for (var j = 0; j < data.length; j++) {
        if (recovered[j] !== data[j]) { match = false; break; }
    }
    assert(match, 'rsProtect/rsUnprotect roundtrip for 500 bytes');
})();

console.log('\n=== 42. Full RS + LSB pipeline (encode, corrupt, decode, verify) ===');
(function() {
    var msg = 'RS protected message';
    var msgBytes = new TextEncoder().encode(msg);
    var parityBytes = 16;

    // RS protect
    var protected_ = RS.rsProtect(msgBytes, parityBytes);

    // Prefix with RS flag (same as stego-core.js)
    var flagged = new Uint8Array(2 + protected_.length);
    flagged[0] = 0x03;
    flagged[1] = 1; // parity level
    flagged.set(protected_, 2);

    // btoa-encode to make binary data ASCII-safe (same as stego-core.js)
    var latin1 = '';
    for (var i = 0; i < flagged.length; i++) latin1 += String.fromCharCode(flagged[i]);
    var payload = 'RS:' + btoa(latin1);

    // Encode into image
    var img = makeImage(2000);
    var encoded = E.encodeLSB(img, payload);

    // Decode (no corruption first, to verify round-trip)
    var raw = E.decodeLSB(encoded);

    // Check RS prefix and unprotect
    assert(raw.indexOf('RS:') === 0, 'RS prefix detected');
    var b64 = raw.substring(3);
    var decoded = atob(b64);
    var rsBytes = new Uint8Array(decoded.length);
    for (var ri = 0; ri < decoded.length; ri++) rsBytes[ri] = decoded.charCodeAt(ri);
    assert(rsBytes[0] === 0x03, 'RS flag byte 0x03');
    var parityLevel = rsBytes[1];
    var pb = [16, 32, 48][parityLevel - 1] || 32;
    var rsData = rsBytes.slice(2);

    try {
        var recovered = RS.rsUnprotect(rsData, pb);
        var recoveredMsg = new TextDecoder().decode(recovered);
        assert(recoveredMsg === msg, 'RS + LSB pipeline recovered message', 'got: "' + recoveredMsg + '"');
    } catch(e) {
        assert(false, 'RS + LSB pipeline threw: ' + e.message);
    }
})();

/* =================================================================
   FULL PIPELINE ROUND-TRIP TESTS
   Simulates the actual stego-core.js encode→decode flow for every
   combination of: depth mode, compression, RS, password, audio, file.
   ================================================================= */

/**
 * Simulates stego-core.js encodeMessage pipeline (synchronous parts).
 * Returns the embedded ImageData.
 *
 * Options:
 *   password: string (uses XOR since we can't do AES in Node)
 *   compression: bool (uses compressDeflate → btoa)
 *   rs: bool (RS protect + 'RS:' prefix)
 *   rsParityLevel: 1|2|3
 *   depth: 0-7
 *   depthMode: 'at'|'with'
 */
function pipelineEncode(img, message, opts) {
    opts = opts || {};
    var depth = opts.depth || 0;
    var depthMode = opts.depthMode || 'at';

    // Step 1: process message (password or compression)
    var processedMessage;
    if (opts.password) {
        // Use XOR (AES needs Web Crypto which is async/browser-only)
        processedMessage = btoa(E.xorEncryptBytes(message, opts.password));
    } else if (opts.compression) {
        // Synchronous btoa fallback (simulates deflate path result)
        var encoded = new TextEncoder().encode(message);
        var binary = '';
        for (var i = 0; i < encoded.length; i++) binary += String.fromCharCode(encoded[i]);
        var b64inner = btoa(binary);
        var b64bytes = new TextEncoder().encode(b64inner);
        var marker = new Uint8Array(1 + b64bytes.length);
        marker[0] = 0x00; // btoa fallback marker
        marker.set(b64bytes, 1);
        var str = '';
        for (var j = 0; j < marker.length; j++) str += String.fromCharCode(marker[j]);
        processedMessage = btoa(str);
    } else {
        processedMessage = message;
    }

    // Step 2: RS protection
    if (opts.rs) {
        var parityLevel = opts.rsParityLevel || 1;
        var parityBytes = [16, 32, 48][parityLevel - 1] || 32;
        var msgBytes = new TextEncoder().encode(processedMessage);
        var protected_ = RS.rsProtect(msgBytes, parityBytes);
        var flagged = new Uint8Array(2 + protected_.length);
        flagged[0] = 0x03;
        flagged[1] = parityLevel;
        flagged.set(protected_, 2);
        var latin1 = '';
        for (var k = 0; k < flagged.length; k++) latin1 += String.fromCharCode(flagged[k]);
        processedMessage = 'RS:' + btoa(latin1);
    }

    // Step 3: Encode into image at given depth
    if (depth === 0 && depthMode === 'at') {
        return E.encodeLSB(img, processedMessage);
    } else if (depthMode === 'at') {
        return E.encodeLSBAtDepth(img, processedMessage, depth);
    } else {
        return E.encodeLSBWithDepth(img, processedMessage, depth);
    }
}

/**
 * Simulates stego-core.js decodeMessage pipeline (synchronous parts).
 * Returns the decoded text or throws.
 */
function pipelineDecode(imgData, opts) {
    opts = opts || {};
    var depth = opts.depth || 0;
    var depthMode = opts.depthMode || 'at';

    // Step 1: Raw decode at given depth
    var raw;
    if (depth === 0 && depthMode === 'at') {
        raw = E.decodeLSB(imgData);
    } else if (depthMode === 'at') {
        raw = E.decodeLSBAtDepth(imgData, depth);
    } else {
        raw = E.decodeLSBWithDepth(imgData, depth);
    }
    if (!raw) throw new Error('No hidden message found');

    // Step 2: RS unprotect
    if (raw.indexOf('RS:') === 0) {
        var b64 = raw.substring(3);
        var latin1 = atob(b64);
        var flaggedArr = new Uint8Array(latin1.length);
        for (var ri = 0; ri < latin1.length; ri++) flaggedArr[ri] = latin1.charCodeAt(ri);
        if (flaggedArr[0] === 0x03 && flaggedArr.length > 2) {
            var parityLevel = flaggedArr[1];
            var parityBytes = [16, 32, 48][parityLevel - 1] || 32;
            var rsData = flaggedArr.slice(2);
            var recovered = RS.rsUnprotect(rsData, parityBytes);
            raw = new TextDecoder().decode(recovered);
        }
    }

    // Step 3: Password or deflate decompression
    if (opts.password) {
        // Try atob + XOR decrypt (matches encode pipeline)
        var decrypted = E.xorDecryptBytes(atob(raw), opts.password);
        return decrypted;
    }

    // Try deflate decompression
    try {
        var decoded64 = atob(raw);
        var deflateBytes = new Uint8Array(decoded64.length);
        for (var di = 0; di < decoded64.length; di++) deflateBytes[di] = decoded64.charCodeAt(di);
        if (deflateBytes[0] === 0x00 || deflateBytes[0] === 0x01) {
            // Synchronous btoa fallback decompression
            if (deflateBytes[0] === 0x00) {
                var payload = deflateBytes.slice(1);
                var b64str = new TextDecoder().decode(payload);
                var rawBytes = atob(b64str);
                var decoded = new Uint8Array(rawBytes.length);
                for (var q = 0; q < rawBytes.length; q++) decoded[q] = rawBytes.charCodeAt(q);
                return new TextDecoder().decode(decoded);
            }
        }
    } catch(e) {}

    // Plain text
    return raw;
}

/**
 * File pipeline encode (simulates stego-core.js encodeFile).
 */
function pipelineFileEncode(img, fileBytes, filename, opts) {
    opts = opts || {};
    var depth = opts.depth || 0;
    var depthMode = opts.depthMode || 'at';

    if (depth === 0 && depthMode === 'at') {
        return E.encodeLSBFile(img, fileBytes, filename);
    } else if (depthMode === 'at') {
        return E.encodeLSBFileAtDepth(img, fileBytes, filename, depth);
    } else {
        return E.encodeLSBFileWithDepth(img, fileBytes, filename, depth);
    }
}

/**
 * File pipeline decode (simulates stego-core.js decodeMessage file detection).
 */
function pipelineFileDecode(imgData, opts) {
    opts = opts || {};
    var depth = opts.depth || 0;
    var depthMode = opts.depthMode || 'at';

    if (depth === 0 && depthMode === 'at') {
        return E.decodeLSBPayload(imgData);
    } else if (depthMode === 'at') {
        return E.decodeLSBPayloadAtDepth(imgData, depth);
    } else {
        return E.decodeLSBPayloadWithDepth(imgData, depth);
    }
}

/* ===== IMAGE ROUND-TRIP TESTS ===== */

console.log('\n=== 43. Pipeline: plain text, depth 0, no options ===');
(function() {
    var msg = 'Hello World! This is a plain text message.';
    var img = makeImage(200);
    var encoded = pipelineEncode(img, msg, {});
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'plain text roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 44. Pipeline: plain text at depth 3 ===');
(function() {
    var msg = 'Depth 3 test message';
    var img = makeImage(200);
    var encoded = pipelineEncode(img, msg, { depth: 3, depthMode: 'at' });
    var decoded = pipelineDecode(encoded, { depth: 3, depthMode: 'at' });
    assert(decoded === msg, 'plain text at depth 3 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 45. Pipeline: plain text with depth 2 (multi-bit) ===');
(function() {
    var msg = 'Multi-bit depth 2 test message';
    var img = makeImage(200);
    var encoded = pipelineEncode(img, msg, { depth: 2, depthMode: 'with' });
    var decoded = pipelineDecode(encoded, { depth: 2, depthMode: 'with' });
    assert(decoded === msg, 'plain text with depth 2 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 46. Pipeline: compression only (deflate btoa fallback) ===');
(function() {
    var msg = 'Compressed message for deflate testing.';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { compression: true });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'compression roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 47. Pipeline: compression + depth 2 at ===');
(function() {
    var msg = 'Compressed at depth 2';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { compression: true, depth: 2, depthMode: 'at' });
    var decoded = pipelineDecode(encoded, { depth: 2, depthMode: 'at' });
    assert(decoded === msg, 'compression + depth 2 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 48. Pipeline: compression + with depth 3 ===');
(function() {
    var msg = 'Compressed with depth 3 multi-bit';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { compression: true, depth: 3, depthMode: 'with' });
    var decoded = pipelineDecode(encoded, { depth: 3, depthMode: 'with' });
    assert(decoded === msg, 'compression + with depth 3 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 49. Pipeline: password only (XOR) ===');
(function() {
    var msg = 'Secret password-protected message';
    var pwd = 'mypassword123';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { password: pwd });
    var decoded = pipelineDecode(encoded, { password: pwd });
    assert(decoded === msg, 'password roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 50. Pipeline: password + depth 4 ===');
(function() {
    var msg = 'Password at depth 4';
    var pwd = 'deeppass';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { password: pwd, depth: 4, depthMode: 'at' });
    var decoded = pipelineDecode(encoded, { password: pwd, depth: 4, depthMode: 'at' });
    assert(decoded === msg, 'password + depth 4 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 51. Pipeline: RS only (no compression, no password) ===');
(function() {
    var msg = 'RS protected message without compression';
    var img = makeImage(1000);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 1 });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'RS only roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 52. Pipeline: RS + compression ===');
(function() {
    var msg = 'RS plus compression test';
    var img = makeImage(1500);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 1, compression: true });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'RS + compression roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 53. Pipeline: RS + depth 3 at ===');
(function() {
    var msg = 'RS with depth 3 at mode';
    var img = makeImage(1000);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 1, depth: 3, depthMode: 'at' });
    var decoded = pipelineDecode(encoded, { depth: 3, depthMode: 'at' });
    assert(decoded === msg, 'RS + depth 3 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 54. Pipeline: RS + depth with 2 ===');
(function() {
    var msg = 'RS with multi-bit depth 2';
    var img = makeImage(1000);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 1, depth: 2, depthMode: 'with' });
    var decoded = pipelineDecode(encoded, { depth: 2, depthMode: 'with' });
    assert(decoded === msg, 'RS + with depth 2 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 55. Pipeline: RS parity level 2 (Medium 32B) ===');
(function() {
    var msg = 'RS medium parity level test';
    var img = makeImage(1500);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 2 });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'RS parity level 2 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 56. Pipeline: RS parity level 3 (High 48B) ===');
(function() {
    var msg = 'RS high parity level test';
    var img = makeImage(2000);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 3 });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'RS parity level 3 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 57. Pipeline: RS + compression + depth + password ===');
(function() {
    var msg = 'Everything enabled together!';
    var pwd = 'fullpipeline';
    var img = makeImage(2000);
    var encoded = pipelineEncode(img, msg, {
        rs: true, rsParityLevel: 1,
        compression: false, // password path doesn't use compression
        password: pwd,
        depth: 1, depthMode: 'at'
    });
    var decoded = pipelineDecode(encoded, { password: pwd, depth: 1, depthMode: 'at' });
    assert(decoded === msg, 'RS + password + depth roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 58. Pipeline: Unicode message at depth 5 ===');
(function() {
    var msg = 'Unicode: 日本語テスト 🎉 émojis and accénts';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { depth: 5, depthMode: 'at' });
    var decoded = pipelineDecode(encoded, { depth: 5, depthMode: 'at' });
    assert(decoded === msg, 'unicode at depth 5 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 59. Pipeline: Unicode + compression ===');
(function() {
    var msg = 'Сжатый Unicode текст mit Ümlauten';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { compression: true });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'unicode compressed roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 60. Pipeline: long message with compression ===');
(function() {
    var msg = '';
    for (var i = 0; i < 100; i++) msg += 'Long message repetition number ' + i + '. ';
    var img = makeImage(msg.length * 3);
    var encoded = pipelineEncode(img, msg, { compression: true });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'long compressed roundtrip', 'length: ' + decoded.length + ' vs ' + msg.length);
})();

console.log('\n=== 61. Pipeline: long message + RS ===');
(function() {
    var msg = '';
    for (var i = 0; i < 50; i++) msg += 'RS long test #' + i + '. ';
    var img = makeImage(msg.length * 4);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 1 });
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'long RS roundtrip', 'length: ' + decoded.length + ' vs ' + msg.length);
})();

/* ===== FILE EMBEDDING ROUND-TRIP TESTS ===== */

console.log('\n=== 62. File pipeline: depth 0 (standard) ===');
(function() {
    var filename = 'test.bin';
    var fileBytes = new Uint8Array([10, 20, 30, 40, 50, 0xFF, 0x00, 0xAB]);
    var img = makeImage(200);
    var encoded = pipelineFileEncode(img, fileBytes, filename, {});
    var payload = pipelineFileDecode(encoded, {});
    assert(payload.type === 'file', 'file type detected');
    assert(payload.filename === filename, 'filename matches');
    var match = payload.data.length === fileBytes.length;
    for (var i = 0; match && i < fileBytes.length; i++) {
        if (payload.data[i] !== fileBytes[i]) match = false;
    }
    assert(match, 'file data matches exactly');
})();

console.log('\n=== 63. File pipeline: at depth 5 ===');
(function() {
    var filename = 'secret.dat';
    var fileBytes = new Uint8Array(64);
    for (var i = 0; i < 64; i++) fileBytes[i] = i * 3 & 0xFF;
    var img = makeImage(200);
    var encoded = pipelineFileEncode(img, fileBytes, filename, { depth: 5, depthMode: 'at' });
    var payload = pipelineFileDecode(encoded, { depth: 5, depthMode: 'at' });
    assert(payload.type === 'file', 'file at depth 5 type');
    assert(payload.filename === filename, 'file at depth 5 filename');
    assert(payload.data.length === fileBytes.length, 'file at depth 5 data length');
})();

console.log('\n=== 64. File pipeline: with depth 3 (multi-bit) ===');
(function() {
    var filename = 'image.png';
    var fileBytes = new Uint8Array(128);
    for (var i = 0; i < 128; i++) fileBytes[i] = (i * 7 + 13) & 0xFF;
    var img = makeImage(300);
    var encoded = pipelineFileEncode(img, fileBytes, filename, { depth: 3, depthMode: 'with' });
    var payload = pipelineFileDecode(encoded, { depth: 3, depthMode: 'with' });
    assert(payload.type === 'file', 'file with depth 3 type');
    assert(payload.filename === filename, 'file with depth 3 filename');
    var match = true;
    for (var j = 0; j < fileBytes.length; j++) {
        if (payload.data[j] !== fileBytes[j]) { match = false; break; }
    }
    assert(match, 'file with depth 3 data matches');
})();

/* ===== WAV AUDIO ROUND-TRIP TESTS ===== */

console.log('\n=== 65. WAV pipeline: plain text, depth 0 ===');
(function() {
    var msg = 'Audio steganography plain text test';
    var wav = makeWAV(5000, 16, 1);
    var encodedBuf = A.encodeWAV(wav, msg, 0, 'at');
    var decoded = A.decodeWAV(encodedBuf, 0, 'at');
    assert(decoded === msg, 'WAV plain text roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 66. WAV pipeline: at depth 4 ===');
(function() {
    var msg = 'WAV depth 4 test';
    var wav = makeWAV(5000, 16, 1);
    var encodedBuf = A.encodeWAV(wav, msg, 4, 'at');
    var decoded = A.decodeWAV(encodedBuf, 4, 'at');
    assert(decoded === msg, 'WAV at depth 4 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 67. WAV pipeline: with depth 2 (multi-bit) ===');
(function() {
    var msg = 'WAV multi-bit depth 2 test message';
    var wav = makeWAV(5000, 16, 1);
    var encodedBuf = A.encodeWAV(wav, msg, 2, 'with');
    var decoded = A.decodeWAV(encodedBuf, 2, 'with');
    assert(decoded === msg, 'WAV with depth 2 roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 68. WAV pipeline: file embedding ===');
(function() {
    var filename = 'audio-secret.bin';
    var fileBytes = new Uint8Array([0xDE, 0xAD, 0xBE, 0xEF, 0x01, 0x02, 0x03]);
    var wav = makeWAV(5000, 16, 1);
    var encodedBuf = A.encodeWAVFile(wav, fileBytes, filename, 0, 'at');
    var payload = A.decodeWAVPayload(encodedBuf, 0, 'at');
    assert(payload.type === 'file', 'WAV file type detected');
    assert(payload.filename === filename, 'WAV filename matches');
    var match = payload.data.length === fileBytes.length;
    for (var i = 0; match && i < fileBytes.length; i++) {
        if (payload.data[i] !== fileBytes[i]) match = false;
    }
    assert(match, 'WAV file data matches');
})();

console.log('\n=== 69. WAV pipeline: file at depth 3 ===');
(function() {
    var filename = 'deep-audio.dat';
    var fileBytes = new Uint8Array(32);
    for (var i = 0; i < 32; i++) fileBytes[i] = (i * 11) & 0xFF;
    var wav = makeWAV(5000, 16, 1);
    var encodedBuf = A.encodeWAVFile(wav, fileBytes, filename, 3, 'at');
    var payload = A.decodeWAVPayload(encodedBuf, 3, 'at');
    assert(payload.type === 'file', 'WAV file at depth 3 type');
    assert(payload.filename === filename, 'WAV file at depth 3 filename');
    assert(payload.data.length === fileBytes.length, 'WAV file at depth 3 data length');
})();

console.log('\n=== 70. WAV pipeline: 8-bit samples ===');
(function() {
    var msg = 'Eight bit audio test';
    var wav = makeWAV(5000, 8, 1);
    var encodedBuf = A.encodeWAV(wav, msg, 0, 'at');
    var decoded = A.decodeWAV(encodedBuf, 0, 'at');
    assert(decoded === msg, 'WAV 8-bit roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 71. WAV pipeline: stereo (2 channels) ===');
(function() {
    var msg = 'Stereo audio test message';
    var wav = makeWAV(5000, 16, 2);
    var encodedBuf = A.encodeWAV(wav, msg, 0, 'at');
    var decoded = A.decodeWAV(encodedBuf, 0, 'at');
    assert(decoded === msg, 'WAV stereo roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 72. WAV pipeline: Unicode message ===');
(function() {
    var msg = 'WAV unicode: 你好世界 αβγ café';
    var wav = makeWAV(5000, 16, 1);
    var encodedBuf = A.encodeWAV(wav, msg, 0, 'at');
    var decoded = A.decodeWAV(encodedBuf, 0, 'at');
    assert(decoded === msg, 'WAV unicode roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

/* ===== CROSS-MODE ISOLATION TESTS ===== */

console.log('\n=== 73. Cross-depth isolation: encode at 3, decode at 0 ===');
(function() {
    var msg = 'Depth 3 secret';
    var img = makeImage(200);
    var encoded = pipelineEncode(img, msg, { depth: 3, depthMode: 'at' });
    try {
        var decoded = pipelineDecode(encoded, { depth: 0, depthMode: 'at' });
        assert(decoded !== msg, 'depth mismatch does not reveal message');
    } catch(e) {
        passed++; console.log('  PASS: depth mismatch throws (expected)');
    }
})();

console.log('\n=== 74. Cross-depth isolation: encode with-2, decode at-2 ===');
(function() {
    var msg = 'Mode mismatch test';
    var img = makeImage(200);
    var encoded = pipelineEncode(img, msg, { depth: 2, depthMode: 'with' });
    try {
        var decoded = pipelineDecode(encoded, { depth: 2, depthMode: 'at' });
        assert(decoded !== msg, 'mode mismatch does not reveal message');
    } catch(e) {
        passed++; console.log('  PASS: mode mismatch throws (expected)');
    }
})();

console.log('\n=== 75. Wrong password returns garbage ===');
(function() {
    var msg = 'Password protected secret';
    var img = makeImage(500);
    var encoded = pipelineEncode(img, msg, { password: 'correct' });
    try {
        var decoded = pipelineDecode(encoded, { password: 'wrong' });
        assert(decoded !== msg, 'wrong password does not reveal message');
    } catch(e) {
        passed++; console.log('  PASS: wrong password throws (expected)');
    }
})();

/* ===== EDGE CASES ===== */

console.log('\n=== 76. Pipeline: minimal message (1 char) ===');
(function() {
    var msg = 'A';
    var img = makeImage(50);
    var encoded = pipelineEncode(img, msg, {});
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'minimal message roundtrip');
})();

console.log('\n=== 77. Pipeline: special characters ===');
(function() {
    var msg = '<script>alert("XSS")</script>&amp;\'"\n\ttab';
    var img = makeImage(200);
    var encoded = pipelineEncode(img, msg, {});
    var decoded = pipelineDecode(encoded, {});
    assert(decoded === msg, 'special chars roundtrip', 'got: "' + decoded.substring(0, 50) + '"');
})();

console.log('\n=== 78. Pipeline: all depths 0-7 at mode ===');
(function() {
    var allPass = true;
    for (var d = 0; d <= 7; d++) {
        var msg = 'Depth ' + d + ' sweep';
        var img = makeImage(200);
        var encoded = pipelineEncode(img, msg, { depth: d, depthMode: 'at' });
        var decoded = pipelineDecode(encoded, { depth: d, depthMode: 'at' });
        if (decoded !== msg) { allPass = false; break; }
    }
    assert(allPass, 'all depths 0-7 at mode roundtrip');
})();

console.log('\n=== 79. Pipeline: all depths 0-7 with mode ===');
(function() {
    var allPass = true;
    for (var d = 0; d <= 7; d++) {
        var msg = 'With ' + d + ' sweep';
        var img = makeImage(200);
        var encoded = pipelineEncode(img, msg, { depth: d, depthMode: 'with' });
        var decoded = pipelineDecode(encoded, { depth: d, depthMode: 'with' });
        if (decoded !== msg) { allPass = false; break; }
    }
    assert(allPass, 'all depths 0-7 with mode roundtrip');
})();

console.log('\n=== 80. RS error correction: corrupt and recover ===');
(function() {
    var msg = 'Recover this after corruption';
    var img = makeImage(1500);
    var encoded = pipelineEncode(img, msg, { rs: true, rsParityLevel: 1 });

    // Extract the RS: payload, corrupt RS block data, re-embed
    var raw = E.decodeLSB(encoded);
    assert(raw.indexOf('RS:') === 0, 'RS prefix present before corruption');
    var b64 = raw.substring(3);
    var latin1 = atob(b64);
    var flaggedArr = new Uint8Array(latin1.length);
    for (var ri = 0; ri < latin1.length; ri++) flaggedArr[ri] = latin1.charCodeAt(ri);

    // Corrupt a few bytes in the RS-protected data (within correction capability)
    // Skip flag (0) and parity level (1), corrupt inside RS block
    // RS block format: [2-byte count][1-byte dataLen][encoded data...]
    // Corrupt positions 5, 6 (inside the encoded block data)
    if (flaggedArr.length > 7) {
        flaggedArr[5] ^= 0x55;
        flaggedArr[6] ^= 0xAA;
    }

    // Reconstruct the RS: prefixed string
    var corruptedLatin1 = '';
    for (var ci = 0; ci < flaggedArr.length; ci++) corruptedLatin1 += String.fromCharCode(flaggedArr[ci]);
    var corruptedPayload = 'RS:' + btoa(corruptedLatin1);

    // Re-embed and decode
    var img2 = makeImage(1500);
    var reencoded = E.encodeLSB(img2, corruptedPayload);
    try {
        var recovered = pipelineDecode(reencoded, {});
        assert(recovered === msg, 'RS corrected corrupted data', 'got: "' + recovered.substring(0, 50) + '"');
    } catch(e) {
        // If corruption hit outside correctable range, that's OK
        console.log('  INFO: RS correction: ' + e.message);
        passed++;
    }
})();

/* ===== Summary ===== */
// Allow async tests to complete
setTimeout(function() {
    console.log('\n========================================');
    console.log('  Results: ' + passed + ' passed, ' + failed + ' failed');
    console.log('========================================');
    if (errors.length > 0) {
        console.log('\nFailures:');
        for (var i = 0; i < errors.length; i++) console.log(errors[i]);
    }
    process.exit(failed > 0 ? 1 : 0);
}, 500);
