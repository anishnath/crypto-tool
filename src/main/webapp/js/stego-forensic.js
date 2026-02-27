/**
 * Steganography Tool - Forensic Scanner Module
 * Universal decoder that tries multiple extraction configs to find hidden messages
 */
(function() {
'use strict';

var CONFIGS = [
    // Priority 1 — Signature-based
    {
        id: 'openstego',
        label: 'OpenStego',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'le32',
        lengthOffset: 10,
        terminator: null,
        magic: [79, 80, 69, 78, 83, 84, 69, 71, 79], // "OPENSTEGO"
        magicSkip: 26,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    // Priority 2 — Length-prefixed
    {
        id: 'own-be32',
        label: 'This Tool (BE32 length)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'be32',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'robindavid',
        label: 'RobinDavid (BGR, LSB, LE16)',
        channelOrder: [2, 1, 0],
        bitOrder: 'lsb',
        bitPlane: 0,
        lengthType: 'le16',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'ragibson-1bit',
        label: 'ragibson/stego-lsb (1 bit)',
        channelOrder: [0, 1, 2],
        bitOrder: 'lsb',
        bitPlane: 0,
        lengthType: 'le32',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'ragibson-2bit',
        label: 'ragibson/stego-lsb (2 bit)',
        channelOrder: [0, 1, 2],
        bitOrder: 'lsb',
        bitPlane: 0,
        lengthType: 'le32',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 2
    },
    // Priority 3 — Delimiter-terminated
    {
        id: 'python-null',
        label: 'Python Tutorial (null-terminated)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '\0',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'python-equals',
        label: 'thepythoncode.com (=====)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '=====',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'python-hash',
        label: 'Python Variant (#####)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '#####',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'python-star',
        label: 'Python Variant (*****)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '*****',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'python-steg0',
        label: 'Python Variant ($t3g0)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '$t3g0',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'python-end',
        label: 'Python Variant (!END!)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '!END!',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'own-delimiter',
        label: 'This Tool (#&# delimiter)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: '#&#',
        magic: null,
        magicSkip: 0,
        stripNulls: false,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    // Priority 4 — Full scan + strip nulls
    {
        id: 'steganojs',
        label: 'SteganoJS (RGB, LSB)',
        channelOrder: [0, 1, 2],
        bitOrder: 'lsb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: true,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'generic-rgb-msb',
        label: 'Generic (RGB, MSB)',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: true,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'generic-bgr-lsb',
        label: 'Generic (BGR, LSB)',
        channelOrder: [2, 1, 0],
        bitOrder: 'lsb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: true,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'generic-bgr-msb',
        label: 'Generic (BGR, MSB)',
        channelOrder: [2, 1, 0],
        bitOrder: 'msb',
        bitPlane: 0,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: true,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    // Priority 5 — Higher bit planes
    {
        id: 'rgb-msb-bp1',
        label: 'RGB MSB Bit Plane 1',
        channelOrder: [0, 1, 2],
        bitOrder: 'msb',
        bitPlane: 1,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: true,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    },
    {
        id: 'rgb-lsb-bp1',
        label: 'RGB LSB Bit Plane 1',
        channelOrder: [0, 1, 2],
        bitOrder: 'lsb',
        bitPlane: 1,
        lengthType: 'none',
        lengthOffset: 0,
        terminator: null,
        magic: null,
        magicSkip: 0,
        stripNulls: true,
        maxScanBytes: 50000,
        bitsPerChannel: 1
    }
];

/**
 * Extract a single bit from a pixel channel value at the given bit plane.
 */
function getBit(value, bitPlane) {
    return (value >> bitPlane) & 1;
}

/**
 * Core parameterized bit extraction engine.
 * Returns extracted text or null on failure.
 */
function extractBits(imageData, config) {
    var data = imageData.data;
    var totalPixels = imageData.width * imageData.height;
    var channelOrder = config.channelOrder;
    var bitsPerChannel = config.bitsPerChannel;
    var bitPlane = config.bitPlane;
    var isMsb = config.bitOrder === 'msb';

    // Total available channel slots
    var totalSlots = totalPixels * channelOrder.length * bitsPerChannel;

    // Helper: read bit at slot index
    function readBit(slotIdx) {
        var channelsPerPixel = channelOrder.length * bitsPerChannel;
        var pixelIdx = Math.floor(slotIdx / channelsPerPixel);
        var remainder = slotIdx % channelsPerPixel;
        var channelIdx = Math.floor(remainder / bitsPerChannel);
        var bitIdx = remainder % bitsPerChannel;

        var dataOffset = pixelIdx * 4 + channelOrder[channelIdx];
        if (dataOffset >= data.length) return 0;

        // For multi-bit, extract from bitPlane + bitIdx
        var plane = bitPlane + bitIdx;
        return getBit(data[dataOffset], plane);
    }

    // Read N bytes starting from a slot position
    function readBytes(startSlot, count) {
        var bytes = [];
        var slot = startSlot;
        for (var i = 0; i < count; i++) {
            var byte = 0;
            if (isMsb) {
                for (var b = 7; b >= 0; b--) {
                    if (slot >= totalSlots) return null;
                    byte |= (readBit(slot) << b);
                    slot++;
                }
            } else {
                for (var b = 0; b < 8; b++) {
                    if (slot >= totalSlots) return null;
                    byte |= (readBit(slot) << b);
                    slot++;
                }
            }
            bytes.push(byte);
        }
        return { bytes: bytes, nextSlot: slot };
    }

    var startSlot = 0;

    // Check magic signature if present
    if (config.magic && config.magic.length > 0) {
        var magicResult = readBytes(0, config.magic.length);
        if (!magicResult) return null;
        for (var m = 0; m < config.magic.length; m++) {
            if (magicResult.bytes[m] !== config.magic[m]) return null;
        }
        // Skip past magic + header
        startSlot = config.magicSkip * 8; // magicSkip is in bytes, convert to bit-slots
        // Actually magicSkip is byte count from start, so read that many bytes worth of slots
        startSlot = 0;
        var skipResult = readBytes(0, config.magicSkip);
        if (!skipResult) return null;
        startSlot = skipResult.nextSlot;
    }

    var messageLength = 0;

    // Read length if length-prefixed
    if (config.lengthType !== 'none') {
        // Read past lengthOffset bytes first
        if (config.lengthOffset > 0 && !config.magic) {
            var offsetResult = readBytes(startSlot, config.lengthOffset);
            if (!offsetResult) return null;
            startSlot = offsetResult.nextSlot;
        } else if (config.lengthOffset > 0 && config.magic) {
            // lengthOffset is absolute from magic start, already handled by magicSkip for OpenStego
            // For OpenStego: length is at offset 10 within the header, magicSkip=26 skips everything
            // Since magicSkip already skipped past everything including length, recalculate
            // Actually for OpenStego, we need to re-read: magic(9) + 1 byte + LE32 length
            startSlot = 0;
            var preLen = readBytes(0, config.lengthOffset);
            if (!preLen) return null;
            startSlot = preLen.nextSlot;
        }

        var lenBytes;
        if (config.lengthType === 'be32') {
            var lr = readBytes(startSlot, 4);
            if (!lr) return null;
            messageLength = ((lr.bytes[0] << 24) | (lr.bytes[1] << 16) | (lr.bytes[2] << 8) | lr.bytes[3]) >>> 0;
            startSlot = lr.nextSlot;
        } else if (config.lengthType === 'le32') {
            var lr = readBytes(startSlot, 4);
            if (!lr) return null;
            messageLength = (lr.bytes[0] | (lr.bytes[1] << 8) | (lr.bytes[2] << 16) | (lr.bytes[3] << 24)) >>> 0;
            startSlot = lr.nextSlot;
        } else if (config.lengthType === 'le16') {
            var lr = readBytes(startSlot, 2);
            if (!lr) return null;
            messageLength = lr.bytes[0] | (lr.bytes[1] << 8);
            startSlot = lr.nextSlot;
        }

        // If magic-based, skip to after magicSkip for actual data
        if (config.magic && config.magicSkip > 0) {
            var skipAll = readBytes(0, config.magicSkip);
            if (!skipAll) return null;
            startSlot = skipAll.nextSlot;
        }

        // Validate length
        var maxBytes = Math.floor((totalSlots - startSlot) / 8);
        if (messageLength === 0 || messageLength > config.maxScanBytes || messageLength > maxBytes) {
            return null;
        }

        var msgResult = readBytes(startSlot, messageLength);
        if (!msgResult) return null;

        try {
            return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(msgResult.bytes));
        } catch (e) {
            return null;
        }
    }

    // Delimiter or scan-based extraction
    if (config.terminator) {
        var termBytes = [];
        for (var t = 0; t < config.terminator.length; t++) {
            termBytes.push(config.terminator.charCodeAt(t));
        }

        var bytes = [];
        var slot = startSlot;
        var maxRead = config.maxScanBytes;

        for (var i = 0; i < maxRead; i++) {
            var br = readBytes(slot, 1);
            if (!br) break;
            slot = br.nextSlot;
            var bv = br.bytes[0];

            // Single-byte terminator (null)
            if (config.terminator === '\0' && bv === 0) {
                break;
            }

            bytes.push(bv);

            // Multi-char terminator check
            if (termBytes.length > 1 && bytes.length >= termBytes.length) {
                var match = true;
                for (var ti = 0; ti < termBytes.length; ti++) {
                    if (bytes[bytes.length - termBytes.length + ti] !== termBytes[ti]) {
                        match = false;
                        break;
                    }
                }
                if (match) {
                    bytes = bytes.slice(0, bytes.length - termBytes.length);
                    break;
                }
            }
        }

        if (bytes.length === 0) return null;
        try {
            return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes));
        } catch (e) {
            return null;
        }
    }

    // Full scan mode (no length, no terminator) — scan for printable text
    var bytes = [];
    var slot = startSlot;
    var consecutiveNonPrintable = 0;
    var maxRead = config.maxScanBytes;

    for (var i = 0; i < maxRead; i++) {
        var br = readBytes(slot, 1);
        if (!br) break;
        slot = br.nextSlot;
        var bv = br.bytes[0];

        if ((bv >= 32 && bv <= 126) || bv === 10 || bv === 13 || bv === 9) {
            bytes.push(bv);
            consecutiveNonPrintable = 0;
        } else if (bv === 0 && bytes.length > 0) {
            if (config.stripNulls) continue;
            break;
        } else {
            consecutiveNonPrintable++;
            if (consecutiveNonPrintable > 10 && bytes.length > 0) break;
            if (consecutiveNonPrintable > 50) return null;
        }
    }

    if (bytes.length === 0) return null;
    try {
        var text = new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes)).trim();
        return text.length > 0 ? text : null;
    } catch (e) {
        return null;
    }
}

/**
 * Score extracted text for readability.
 * Returns 0.0 to 1.0.
 */
function scoreResult(text) {
    if (!text || text.length < 4) return 0;

    var E = window.StegoEngine;

    // Printable ratio (weight 0.6)
    var pr = E.printableRatio(text);

    // Word-likeness (weight 0.25) — spaces at reasonable intervals
    var wordScore = 0;
    if (text.length > 3) {
        var spaces = 0;
        for (var i = 0; i < text.length; i++) {
            if (text[i] === ' ') spaces++;
        }
        if (spaces > 0) {
            var avgWordLen = text.length / (spaces + 1);
            // Good word length is 3-10 characters
            if (avgWordLen >= 2 && avgWordLen <= 15) {
                wordScore = 1.0;
            } else if (avgWordLen >= 1 && avgWordLen <= 25) {
                wordScore = 0.5;
            }
        } else {
            // No spaces — could still be valid (short message, code, etc.)
            wordScore = text.length <= 20 ? 0.3 : 0.1;
        }
    }

    // Length bonus (weight 0.15) — longer readable text scores higher
    var lengthScore = Math.min(text.length / 50, 1.0);

    return (pr * 0.6) + (wordScore * 0.25) + (lengthScore * 0.15);
}

/**
 * Get a human-readable description of a config's technical details.
 */
function getConfigLabel(config) {
    var parts = [];
    var channels = config.channelOrder.map(function(c) {
        return ['R','G','B','A'][c] || '?';
    }).join('');
    parts.push(channels);
    parts.push(config.bitOrder.toUpperCase());
    if (config.bitPlane > 0) parts.push('plane ' + config.bitPlane);
    if (config.bitsPerChannel > 1) parts.push(config.bitsPerChannel + ' bits/ch');
    if (config.lengthType !== 'none') parts.push(config.lengthType);
    if (config.terminator) {
        var termDisplay = config.terminator === '\0' ? '\\0' : config.terminator;
        parts.push('term: ' + termDisplay);
    }
    if (config.magic) parts.push('signature');
    return parts.join(', ');
}

/**
 * Run the forensic scan across all configs with async yielding.
 * @param {ImageData} imageData
 * @param {function(current, total, foundCount)} onProgress
 * @param {function(results, elapsedMs)} onComplete
 */
function runForensicScan(imageData, onProgress, onComplete) {
    var results = [];
    var seenTexts = {};
    var startTime = Date.now();
    var idx = 0;

    function processNext() {
        if (idx >= CONFIGS.length) {
            // Sort by score descending
            results.sort(function(a, b) { return b.score - a.score; });
            onComplete(results, Date.now() - startTime);
            return;
        }

        var config = CONFIGS[idx];
        var text = null;

        try {
            text = extractBits(imageData, config);
        } catch (e) {
            // Skip failed configs
        }

        if (text && text.length >= 4) {
            var score = scoreResult(text);
            if (score > 0.5) {
                // Deduplication — merge identical texts
                var trimmed = text.trim();
                if (seenTexts[trimmed]) {
                    seenTexts[trimmed].alsoMatches.push(config.label);
                } else {
                    var entry = {
                        config: config,
                        text: trimmed,
                        score: score,
                        alsoMatches: []
                    };
                    results.push(entry);
                    seenTexts[trimmed] = entry;
                }
            }
        }

        idx++;
        onProgress(idx, CONFIGS.length, results.length);

        // Yield to browser
        setTimeout(processNext, 0);
    }

    onProgress(0, CONFIGS.length, 0);
    setTimeout(processNext, 0);
}

// Export
window.StegoForensic = {
    CONFIGS: CONFIGS,
    extractBits: extractBits,
    scoreResult: scoreResult,
    getConfigLabel: getConfigLabel,
    runForensicScan: runForensicScan
};

})();
