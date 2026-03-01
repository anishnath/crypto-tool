/**
 * Steganography Forensic Scanner Tests
 * Run: node test-stego-forensic.cjs
 *
 * Tests the forensic scanner covering:
 *  - extractBits with BE32 length-prefixed (own tool format)
 *  - extractBits with null terminator
 *  - extractBits with multi-char delimiters (=====, #&#, etc.)
 *  - extractBits with LE32 length-prefixed (ragibson format)
 *  - extractBits with LE16 length-prefixed (RobinDavid BGR LSB)
 *  - extractBits full-scan / strip-nulls mode
 *  - extractBits LSB bit order
 *  - extractBits higher bit plane
 *  - extractBits magic signature match/reject
 *  - scoreResult scoring function
 *  - getConfigLabel label generation
 *  - runForensicScan integration (finds own-tool encoded message)
 *  - runForensicScan on clean image (no results)
 *  - runForensicScan deduplication
 */

/* ===== Browser API polyfills for Node ===== */
var util = require('util');
global.TextEncoder = util.TextEncoder;
global.TextDecoder = util.TextDecoder;

global.btoa = function(str) {
    return Buffer.from(str, 'binary').toString('base64');
};
global.atob = function(b64) {
    return Buffer.from(b64, 'base64').toString('binary');
};

function FakeImageData(dataOrWidth, widthOrHeight, height) {
    if (typeof dataOrWidth === 'number') {
        this.width = dataOrWidth;
        this.height = widthOrHeight;
        this.data = new Uint8ClampedArray(dataOrWidth * widthOrHeight * 4);
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

// setTimeout polyfill for synchronous test execution
global.setTimeout = function(fn) { fn(); };

/* ===== Load modules ===== */
global.window = {};
require('./src/main/webapp/js/stego-engine.js');
require('./src/main/webapp/js/stego-forensic.js');
var E = global.window.StegoEngine;
var F = global.window.StegoForensic;

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

/* ===== Helpers ===== */

function makeImage(w, h) {
    return new FakeImageData(w, h);
}

/**
 * Embed bytes into image pixel data using given config parameters.
 * This simulates what various external tools do when encoding.
 */
function embedBits(imageData, bytesArray, config) {
    var data = imageData.data;
    var channelOrder = config.channelOrder;
    var bitsPerChannel = config.bitsPerChannel;
    var bitPlane = config.bitPlane;
    var isMsb = config.bitOrder === 'msb';
    var totalPixels = imageData.width * imageData.height;
    var channelsPerPixel = channelOrder.length * bitsPerChannel;

    var slot = 0;
    for (var i = 0; i < bytesArray.length; i++) {
        var byte = bytesArray[i];
        if (isMsb) {
            for (var b = 7; b >= 0; b--) {
                var bitVal = (byte >> b) & 1;
                var pixelIdx = Math.floor(slot / channelsPerPixel);
                var remainder = slot % channelsPerPixel;
                var channelIdx = Math.floor(remainder / bitsPerChannel);
                var bitIdx = remainder % bitsPerChannel;
                var dataOffset = pixelIdx * 4 + channelOrder[channelIdx];
                var plane = bitPlane + bitIdx;
                // Clear the target bit and set it
                data[dataOffset] = (data[dataOffset] & ~(1 << plane)) | (bitVal << plane);
                slot++;
            }
        } else {
            for (var b = 0; b < 8; b++) {
                var bitVal = (byte >> b) & 1;
                var pixelIdx = Math.floor(slot / channelsPerPixel);
                var remainder = slot % channelsPerPixel;
                var channelIdx = Math.floor(remainder / bitsPerChannel);
                var bitIdx = remainder % bitsPerChannel;
                var dataOffset = pixelIdx * 4 + channelOrder[channelIdx];
                var plane = bitPlane + bitIdx;
                data[dataOffset] = (data[dataOffset] & ~(1 << plane)) | (bitVal << plane);
                slot++;
            }
        }
    }
}

/** Convert string to array of byte values */
function strToBytes(str) {
    var enc = new TextEncoder().encode(str);
    var arr = [];
    for (var i = 0; i < enc.length; i++) arr.push(enc[i]);
    return arr;
}

/** Build a BE32 length header + message bytes */
function be32Message(msg) {
    var msgBytes = strToBytes(msg);
    var len = msgBytes.length;
    return [
        (len >>> 24) & 0xFF,
        (len >>> 16) & 0xFF,
        (len >>> 8) & 0xFF,
        len & 0xFF
    ].concat(msgBytes);
}

/** Build a LE32 length header + message bytes */
function le32Message(msg) {
    var msgBytes = strToBytes(msg);
    var len = msgBytes.length;
    return [
        len & 0xFF,
        (len >>> 8) & 0xFF,
        (len >>> 16) & 0xFF,
        (len >>> 24) & 0xFF
    ].concat(msgBytes);
}

/** Build a LE16 length header + message bytes */
function le16Message(msg) {
    var msgBytes = strToBytes(msg);
    var len = msgBytes.length;
    return [
        len & 0xFF,
        (len >>> 8) & 0xFF
    ].concat(msgBytes);
}

/** Build message bytes + terminator */
function terminatedMessage(msg, terminator) {
    var msgBytes = strToBytes(msg);
    var termBytes = strToBytes(terminator);
    return msgBytes.concat(termBytes);
}

/** Build null-terminated message bytes */
function nullTerminatedMessage(msg) {
    var msgBytes = strToBytes(msg);
    msgBytes.push(0);
    return msgBytes;
}

/** Find a config by id */
function findConfig(id) {
    for (var i = 0; i < F.CONFIGS.length; i++) {
        if (F.CONFIGS[i].id === id) return F.CONFIGS[i];
    }
    return null;
}

/* =================================================================
   TEST SUITES
   ================================================================= */

console.log('\n=== 1. extractBits — BE32 length-prefixed (own tool format) ===');
(function() {
    var msg = 'Hello from our own tool';
    var config = findConfig('own-be32');
    var img = makeImage(100, 100);
    var bytes = be32Message(msg);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'BE32 extraction returns result');
    assert(result === msg, 'BE32 extracted text matches', 'got: "' + result + '"');
})();

console.log('\n=== 2. extractBits — null terminator ===');
(function() {
    var msg = 'Secret null-terminated message';
    var config = findConfig('python-null');
    var img = makeImage(100, 100);
    var bytes = nullTerminatedMessage(msg);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'null-terminated extraction returns result');
    assert(result === msg, 'null-terminated text matches', 'got: "' + result + '"');
})();

console.log('\n=== 3. extractBits — multi-char delimiters ===');
(function() {
    var delimiters = [
        { id: 'python-equals', term: '=====' },
        { id: 'python-hash', term: '#####' },
        { id: 'python-star', term: '*****' },
        { id: 'python-steg0', term: '$t3g0' },
        { id: 'python-end', term: '!END!' },
        { id: 'own-delimiter', term: '#&#' }
    ];
    for (var d = 0; d < delimiters.length; d++) {
        var msg = 'Delimiter test message number ' + (d + 1);
        var config = findConfig(delimiters[d].id);
        var img = makeImage(100, 100);
        var bytes = terminatedMessage(msg, delimiters[d].term);
        embedBits(img, bytes, config);
        var result = F.extractBits(img, config);
        assert(result !== null, delimiters[d].id + ' extraction returns result');
        assert(result === msg, delimiters[d].id + ' text matches', 'got: "' + result + '"');
    }
})();

console.log('\n=== 4. extractBits — LE32 length-prefixed (ragibson 1-bit) ===');
(function() {
    var msg = 'Message from ragibson stego-lsb';
    var config = findConfig('ragibson-1bit');
    var img = makeImage(100, 100);
    var bytes = le32Message(msg);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'LE32 1-bit extraction returns result');
    assert(result === msg, 'LE32 1-bit text matches', 'got: "' + result + '"');
})();

console.log('\n=== 5. extractBits — LE16 length-prefixed (RobinDavid BGR LSB) ===');
(function() {
    var msg = 'RobinDavid BGR LSB message';
    var config = findConfig('robindavid');
    var img = makeImage(100, 100);
    var bytes = le16Message(msg);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'LE16 BGR LSB extraction returns result');
    assert(result === msg, 'LE16 BGR LSB text matches', 'got: "' + result + '"');
})();

console.log('\n=== 6. extractBits — full scan / strip-nulls mode ===');
(function() {
    var msg = 'Printable text for full scan mode';
    var config = findConfig('generic-rgb-msb');
    var img = makeImage(100, 100);
    var msgBytes = strToBytes(msg);
    // Add some null bytes after message to test strip
    var bytes = msgBytes.concat([0, 0, 0, 0, 0]);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'full-scan extraction returns result');
    assert(result.indexOf(msg) === 0, 'full-scan text starts with expected message', 'got: "' + (result ? result.substring(0, 50) : '') + '"');
})();

console.log('\n=== 7. extractBits — LSB bit order ===');
(function() {
    var msg = 'LSB bit order test message here';
    var config = findConfig('steganojs');
    var img = makeImage(100, 100);
    // SteganoJS is full-scan LSB, embed printable text terminated by non-printable
    var msgBytes = strToBytes(msg);
    // Add consecutive non-printable bytes to trigger the scan stop
    var bytes = msgBytes.concat([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'LSB full-scan extraction returns result');
    assert(result === msg, 'LSB text matches', 'got: "' + result + '"');
})();

console.log('\n=== 8. extractBits — higher bit plane ===');
(function() {
    var msg = 'Higher bit plane test data';
    var config = findConfig('rgb-msb-bp1');
    var img = makeImage(100, 100);
    var msgBytes = strToBytes(msg);
    var bytes = msgBytes.concat([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'bit plane 1 extraction returns result');
    assert(result === msg, 'bit plane 1 text matches', 'got: "' + result + '"');
})();

console.log('\n=== 9. extractBits — magic signature reject ===');
(function() {
    var config = findConfig('openstego');
    var img = makeImage(100, 100);
    // Don't embed any magic — should return null
    var result = F.extractBits(img, config);
    assert(result === null, 'no-magic image correctly rejected by OpenStego config');
})();

console.log('\n=== 10. extractBits — magic signature match (OpenStego simulation) ===');
(function() {
    var config = findConfig('openstego');
    var msg = 'Hidden by OpenStego';
    var msgBytes = strToBytes(msg);
    var msgLen = msgBytes.length;

    // Build OpenStego-like header: 9-byte magic "OPENSTEGO" + 1 byte + LE32 length at offset 10 + padding to 26 bytes + data
    var magic = [79, 80, 69, 78, 83, 84, 69, 71, 79]; // "OPENSTEGO"
    var header = magic.concat([0]); // byte at offset 9
    // LE32 length at offset 10
    header.push(msgLen & 0xFF);
    header.push((msgLen >>> 8) & 0xFF);
    header.push((msgLen >>> 16) & 0xFF);
    header.push((msgLen >>> 24) & 0xFF);
    // Pad remaining header to 26 bytes total
    while (header.length < 26) header.push(0);
    // Append message data
    var fullData = header.concat(Array.from(msgBytes));

    var img = makeImage(100, 100);
    embedBits(img, fullData, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'OpenStego magic extraction returns result');
    assert(result === msg, 'OpenStego extracted text matches', 'got: "' + result + '"');
})();

console.log('\n=== 11. scoreResult — scoring function ===');
(function() {
    // Good readable text with spaces should score high
    var highScore = F.scoreResult('This is a perfectly readable sentence with many words');
    assert(highScore > 0.8, 'readable sentence scores > 0.8', 'score: ' + highScore.toFixed(3));

    // Short text still above threshold
    var shortScore = F.scoreResult('Hello world');
    assert(shortScore > 0.5, 'short readable text scores > 0.5', 'score: ' + shortScore.toFixed(3));

    // Too short (< 4 chars) scores 0
    var tinyScore = F.scoreResult('Hi');
    assert(tinyScore === 0, 'text < 4 chars scores 0');

    // Empty/null scores 0
    assert(F.scoreResult('') === 0, 'empty string scores 0');
    assert(F.scoreResult(null) === 0, 'null scores 0');

    // Gibberish text with no spaces should score lower
    var noSpaceScore = F.scoreResult('abcdefghijklmnopqrstuvwxyzabcdef');
    assert(noSpaceScore < highScore, 'no-space text scores lower than spaced text',
        'noSpace: ' + noSpaceScore.toFixed(3) + ' vs high: ' + highScore.toFixed(3));

    // Longer text gets length bonus
    var longText = 'The quick brown fox jumps over the lazy dog and this goes on for a while to test length scoring';
    var longScore = F.scoreResult(longText);
    assert(longScore > shortScore, 'longer text scores higher than shorter text',
        'long: ' + longScore.toFixed(3) + ' vs short: ' + shortScore.toFixed(3));
})();

console.log('\n=== 12. getConfigLabel — label generation ===');
(function() {
    var config1 = findConfig('own-be32');
    var label1 = F.getConfigLabel(config1);
    assert(label1.indexOf('RGB') >= 0, 'own-be32 label contains RGB');
    assert(label1.indexOf('MSB') >= 0, 'own-be32 label contains MSB');
    assert(label1.indexOf('be32') >= 0, 'own-be32 label contains be32');

    var config2 = findConfig('robindavid');
    var label2 = F.getConfigLabel(config2);
    assert(label2.indexOf('BGR') >= 0, 'robindavid label contains BGR');
    assert(label2.indexOf('LSB') >= 0, 'robindavid label contains LSB');
    assert(label2.indexOf('le16') >= 0, 'robindavid label contains le16');

    var config3 = findConfig('python-null');
    var label3 = F.getConfigLabel(config3);
    assert(label3.indexOf('\\0') >= 0, 'python-null label contains \\0 terminator');

    var config4 = findConfig('openstego');
    var label4 = F.getConfigLabel(config4);
    assert(label4.indexOf('signature') >= 0, 'openstego label mentions signature');

    var config5 = findConfig('rgb-msb-bp1');
    var label5 = F.getConfigLabel(config5);
    assert(label5.indexOf('plane 1') >= 0, 'bp1 label mentions plane 1');

    var config6 = findConfig('ragibson-2bit');
    var label6 = F.getConfigLabel(config6);
    assert(label6.indexOf('2 bits/ch') >= 0, 'ragibson-2bit label mentions 2 bits/ch');
})();

console.log('\n=== 13. runForensicScan — finds own-tool encoded message ===');
(function() {
    var msg = 'Forensic scan should find this message easily';
    var img = makeImage(100, 100);
    // Encode using our own tool's encodeLSB (BE32 header, RGB, MSB)
    var encoded = E.encodeLSB(img, msg);

    var scanResults = null;
    var scanMs = 0;
    var progressCalls = 0;

    F.runForensicScan(
        encoded,
        function onProgress(current, total, found) {
            progressCalls++;
        },
        function onComplete(results, elapsedMs) {
            scanResults = results;
            scanMs = elapsedMs;
        }
    );

    assert(scanResults !== null, 'forensic scan completed');
    assert(scanResults.length > 0, 'forensic scan found at least one result', 'found: ' + (scanResults ? scanResults.length : 0));
    assert(progressCalls > 0, 'progress callback was called', 'calls: ' + progressCalls);

    // The top result should contain our message
    if (scanResults && scanResults.length > 0) {
        var topResult = scanResults[0];
        assert(topResult.text === msg, 'top result text matches encoded message',
            'got: "' + topResult.text.substring(0, 60) + '"');
        assert(topResult.score > 0.7, 'top result has high confidence',
            'score: ' + topResult.score.toFixed(3));
        assert(topResult.config.id === 'own-be32', 'top result identified as own-be32 config',
            'config: ' + topResult.config.id);
    }
})();

console.log('\n=== 14. runForensicScan — clean image (no results) ===');
(function() {
    // Use a very small image with random data — unlikely to produce readable text
    var img = makeImage(4, 4);

    var scanResults = null;
    F.runForensicScan(
        img,
        function() {},
        function onComplete(results) {
            scanResults = results;
        }
    );

    assert(scanResults !== null, 'forensic scan completed on clean image');
    // A tiny random image should produce no high-scoring results
    // (though it's technically possible for random data to look like text)
    console.log('    (clean image results: ' + scanResults.length + ')');
})();

console.log('\n=== 15. runForensicScan — deduplication ===');
(function() {
    // Encode a message using our tool — it should be found by multiple configs
    // (own-be32 reads via length, generic-rgb-msb reads via scan, python-null reads via null-term)
    // If they find the same text, they should be deduplicated
    var msg = 'Dedup test message with spaces for scoring';
    var img = makeImage(100, 100);
    var encoded = E.encodeLSB(img, msg);

    var scanResults = null;
    F.runForensicScan(
        encoded,
        function() {},
        function onComplete(results) {
            scanResults = results;
        }
    );

    // Check that no two results have identical text
    if (scanResults && scanResults.length > 1) {
        var texts = {};
        var hasDuplicate = false;
        for (var i = 0; i < scanResults.length; i++) {
            if (texts[scanResults[i].text]) {
                hasDuplicate = true;
                break;
            }
            texts[scanResults[i].text] = true;
        }
        assert(!hasDuplicate, 'no duplicate texts in results');

        // Check that alsoMatches is populated for deduplicated results
        var primaryResult = null;
        for (var j = 0; j < scanResults.length; j++) {
            if (scanResults[j].text === msg) {
                primaryResult = scanResults[j];
                break;
            }
        }
        if (primaryResult && primaryResult.alsoMatches.length > 0) {
            assert(true, 'deduped result has alsoMatches entries: ' + primaryResult.alsoMatches.join(', '));
        } else {
            console.log('    (no dedup merging occurred — configs may have extracted different substrings)');
        }
    } else {
        console.log('    (only ' + (scanResults ? scanResults.length : 0) + ' result — dedup test inconclusive)');
    }
})();

console.log('\n=== 16. extractBits — invalid length rejected ===');
(function() {
    var config = findConfig('own-be32');
    var img = makeImage(10, 10);
    // Embed an absurdly large length value (0xFFFFFFFF)
    var bytes = [0xFF, 0xFF, 0xFF, 0xFF];
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result === null, 'absurd BE32 length correctly rejected');

    // Embed zero length
    var config2 = findConfig('ragibson-1bit');
    var img2 = makeImage(10, 10);
    var bytes2 = [0, 0, 0, 0];
    embedBits(img2, bytes2, config2);
    var result2 = F.extractBits(img2, config2);
    assert(result2 === null, 'zero LE32 length correctly rejected');
})();

console.log('\n=== 17. extractBits — empty message from delimiter ===');
(function() {
    // Embed just the delimiter with no preceding message
    var config = findConfig('python-equals');
    var img = makeImage(100, 100);
    var bytes = strToBytes('=====');
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result === null, 'empty delimiter-terminated message returns null');
})();

console.log('\n=== 18. extractBits — LE32 2-bit per channel (ragibson-2bit) ===');
(function() {
    var msg = 'Two bits per channel test';
    var config = findConfig('ragibson-2bit');
    var img = makeImage(100, 100);
    var bytes = le32Message(msg);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'ragibson 2-bit extraction returns result');
    assert(result === msg, 'ragibson 2-bit text matches', 'got: "' + result + '"');
})();

console.log('\n=== 19. CONFIGS array integrity ===');
(function() {
    assert(F.CONFIGS.length === 18, 'exactly 18 configs defined', 'got: ' + F.CONFIGS.length);

    // All configs have required fields
    var allValid = true;
    for (var i = 0; i < F.CONFIGS.length; i++) {
        var c = F.CONFIGS[i];
        if (!c.id || !c.label || !c.channelOrder || !c.bitOrder || c.bitPlane === undefined ||
            !c.lengthType || c.maxScanBytes === undefined || c.bitsPerChannel === undefined) {
            allValid = false;
            console.log('    Invalid config at index ' + i + ': ' + c.id);
        }
    }
    assert(allValid, 'all configs have required fields');

    // All config IDs are unique
    var ids = {};
    var uniqueIds = true;
    for (var j = 0; j < F.CONFIGS.length; j++) {
        if (ids[F.CONFIGS[j].id]) { uniqueIds = false; break; }
        ids[F.CONFIGS[j].id] = true;
    }
    assert(uniqueIds, 'all config IDs are unique');
})();

console.log('\n=== 20. runForensicScan — results sorted by score descending ===');
(function() {
    var msg = 'Sorting test message with many words for good score';
    var img = makeImage(100, 100);
    var encoded = E.encodeLSB(img, msg);

    var scanResults = null;
    F.runForensicScan(
        encoded,
        function() {},
        function onComplete(results) {
            scanResults = results;
        }
    );

    if (scanResults && scanResults.length > 1) {
        var sorted = true;
        for (var i = 1; i < scanResults.length; i++) {
            if (scanResults[i].score > scanResults[i - 1].score) {
                sorted = false;
                break;
            }
        }
        assert(sorted, 'results are sorted by score descending');
    } else {
        assert(true, 'sorting check skipped (< 2 results)');
    }
})();

console.log('\n=== 21. extractBits — BGR channel order ===');
(function() {
    var msg = 'BGR channel order test here';
    var config = findConfig('generic-bgr-lsb');
    var img = makeImage(100, 100);
    var msgBytes = strToBytes(msg);
    var bytes = msgBytes.concat([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    embedBits(img, bytes, config);
    var result = F.extractBits(img, config);
    assert(result !== null, 'BGR LSB full-scan returns result');
    assert(result === msg, 'BGR LSB text matches', 'got: "' + result + '"');
})();

console.log('\n=== 22. Cross-format isolation — BGR config does not read RGB data ===');
(function() {
    // Encode with RGB MSB (our tool), then try to read with BGR LSB
    var msg = 'Cross format isolation test message';
    var img = makeImage(100, 100);
    var encoded = E.encodeLSB(img, msg);

    var bgrConfig = findConfig('generic-bgr-lsb');
    var bgrResult = F.extractBits(encoded, bgrConfig);

    // BGR should NOT find the exact same message (different channel order + bit order)
    if (bgrResult !== null) {
        assert(bgrResult !== msg, 'BGR config does not accidentally read RGB MSB data');
    } else {
        assert(true, 'BGR config correctly returned null for RGB-encoded data');
    }
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
