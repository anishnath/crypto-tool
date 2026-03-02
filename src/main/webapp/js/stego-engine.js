/**
 * Steganography Tool - Engine Module
 * Core LSB steganography encoding/decoding logic
 */
(function() {
'use strict';

/**
 * LSB Encoding with 4-byte length header.
 * Embeds message into the least significant bits of RGB channels.
 * Header stores UTF-8 byte count (not JS string length).
 */
function encodeLSB(imageData, message) {
    var data = new Uint8ClampedArray(imageData.data);
    var encoded = new TextEncoder().encode(message);
    var msgLength = encoded.length;
    var maxCapacity = Math.floor((data.length / 4) * 3 / 8) - 4;
    if (msgLength > maxCapacity) {
        throw new Error('Message too large: ' + msgLength + ' bytes exceeds capacity of ' + maxCapacity + ' bytes');
    }
    var header = [
        (msgLength >>> 24) & 0xFF,
        (msgLength >>> 16) & 0xFF,
        (msgLength >>> 8) & 0xFF,
        msgLength & 0xFF
    ];
    var fullMessage = [];
    var i, bit, byte, bitValue, pixelIndex, bitIndex;

    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    for (i = 0; i < encoded.length; i++) fullMessage.push(encoded[i]);

    bitIndex = 0;
    for (i = 0; i < fullMessage.length; i++) {
        byte = fullMessage[i];
        for (bit = 7; bit >= 0; bit--) {
            bitValue = (byte >> bit) & 1;
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            data[pixelIndex] = (data[pixelIndex] & 0xFE) | bitValue;
            bitIndex++;
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * Multi-method LSB decoding. Tries 4 approaches in sequence.
 */
function decodeLSB(imageData) {
    var r;
    try { r = decodeWithLengthHeader(imageData); if (r && r.length > 0) return r; } catch(e) {}
    try { r = decodeNullTerminated(imageData); if (r && r.length > 0) return r; } catch(e) {}
    try { r = decodeWithDelimiter(imageData); if (r && r.length > 0) return r; } catch(e) {}
    try { r = decodePrintableASCII(imageData); if (r && r.length > 0) return r; } catch(e) {}
    throw new Error('No hidden message found or unsupported format');
}

/**
 * Decode using 4-byte length header (standard format).
 * Includes bounds check against actual image capacity.
 */
function decodeWithLengthHeader(imageData) {
    var data = imageData.data;
    var bitIndex = 0;
    var headerBytes = [];
    var i, bit, byte, pixelIndex, msgLength;

    // Read 4-byte length header
    for (i = 0; i < 4; i++) {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) throw new Error('Image too small for header');
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        headerBytes.push(byte);
    }

    // Use unsigned right-shift to avoid sign bit issues
    msgLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;

    // Bounds checks: reject impossible lengths
    var maxCapacity = Math.floor((data.length / 4) * 3 / 8) - 4;
    if (msgLength === 0 || msgLength > maxCapacity || msgLength > 500000) {
        throw new Error('Invalid length: ' + msgLength);
    }

    var bytes = [];
    for (i = 0; i < msgLength; i++) {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) throw new Error('Data truncated at byte ' + i);
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        bytes.push(byte);
    }
    return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes));
}

/**
 * Decode by scanning for null-byte terminator.
 */
function decodeNullTerminated(imageData) {
    var data = imageData.data;
    var bitIndex = 0;
    var bytes = [];
    var i, bit, byte, pixelIndex, text, printable;

    for (i = 0; i < 100000; i++) {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) break;
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        if (byte === 0) break;
        bytes.push(byte);
    }
    if (bytes.length === 0) throw new Error('No message');
    text = new TextDecoder().decode(new Uint8Array(bytes));
    printable = text.split('').filter(function(c) {
        var code = c.charCodeAt(0);
        return (code >= 32 && code <= 126) || code === 10 || code === 13;
    }).length;
    if (printable / text.length < 0.8) throw new Error('Not text');
    return text;
}

/**
 * Decode by scanning for #&# delimiter.
 */
function decodeWithDelimiter(imageData) {
    var data = imageData.data;
    var bitIndex = 0;
    var bytes = [];
    var delimiter = '#&#';
    var i, bit, byte, pixelIndex, tail;

    for (i = 0; i < 100000; i++) {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) break;
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        bytes.push(byte);
        if (bytes.length >= delimiter.length) {
            tail = String.fromCharCode.apply(null, bytes.slice(-delimiter.length));
            if (tail === delimiter) {
                bytes = bytes.slice(0, -delimiter.length);
                break;
            }
        }
    }
    if (bytes.length === 0) throw new Error('No message');
    return new TextDecoder('utf-8', {fatal: false}).decode(new Uint8Array(bytes)).replace(/\0+$/, '');
}

/**
 * Fallback: scan for printable ASCII only.
 */
function decodePrintableASCII(imageData) {
    var data = imageData.data;
    var bitIndex = 0;
    var bytes = [];
    var consecutiveNonPrintable = 0;
    var i, bit, byte, pixelIndex;

    for (i = 0; i < 50000; i++) {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) break;
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        if ((byte >= 32 && byte <= 126) || byte === 10 || byte === 13 || byte === 9) {
            bytes.push(byte);
            consecutiveNonPrintable = 0;
        } else if (byte === 0 && bytes.length > 0) {
            break;
        } else {
            consecutiveNonPrintable++;
            if (consecutiveNonPrintable > 10 && bytes.length > 0) break;
            if (consecutiveNonPrintable > 50) throw new Error('Not text');
        }
    }
    if (bytes.length < 1) throw new Error('No message');
    return new TextDecoder().decode(new Uint8Array(bytes)).trim();
}

/**
 * XOR cipher operating on UTF-8 bytes (safe for all Unicode input).
 * Output is a Latin-1 string (char codes 0-255), safe for btoa().
 */
function xorEncryptBytes(message, password) {
    var msgBytes = new TextEncoder().encode(message);
    var pwdBytes = new TextEncoder().encode(password);
    var result = '';
    for (var i = 0; i < msgBytes.length; i++) {
        result += String.fromCharCode(msgBytes[i] ^ pwdBytes[i % pwdBytes.length]);
    }
    return result;
}

/**
 * XOR decrypt: takes a Latin-1 ciphertext string, returns decoded UTF-8 text.
 */
function xorDecryptBytes(ciphertext, password) {
    var pwdBytes = new TextEncoder().encode(password);
    var bytes = new Uint8Array(ciphertext.length);
    for (var i = 0; i < ciphertext.length; i++) {
        bytes[i] = ciphertext.charCodeAt(i) ^ pwdBytes[i % pwdBytes.length];
    }
    return new TextDecoder('utf-8', { fatal: false }).decode(bytes);
}

/**
 * Legacy XOR cipher (operates on UTF-16 code units).
 * Kept for backward compatibility decoding old images.
 */
function xorEncrypt(message, password) {
    var result = '';
    for (var i = 0; i < message.length; i++) {
        result += String.fromCharCode(message.charCodeAt(i) ^ password.charCodeAt(i % password.length));
    }
    return result;
}

/**
 * AES-256-GCM encryption using Web Crypto API.
 * Password → PBKDF2 (100k iterations, SHA-256) → 256-bit AES key.
 * Output: base64 of [16-byte salt][12-byte IV][ciphertext+tag]
 * Returns a Promise resolving to a base64 string.
 */
function encryptAES(plaintext, password) {
    var enc = new TextEncoder();
    var salt = crypto.getRandomValues(new Uint8Array(16));
    var iv = crypto.getRandomValues(new Uint8Array(12));
    return crypto.subtle.importKey('raw', enc.encode(password), 'PBKDF2', false, ['deriveKey'])
        .then(function(baseKey) {
            return crypto.subtle.deriveKey(
                { name: 'PBKDF2', salt: salt, iterations: 100000, hash: 'SHA-256' },
                baseKey,
                { name: 'AES-GCM', length: 256 },
                false,
                ['encrypt']
            );
        })
        .then(function(aesKey) {
            return crypto.subtle.encrypt({ name: 'AES-GCM', iv: iv }, aesKey, enc.encode(plaintext));
        })
        .then(function(cipherBuf) {
            var cipher = new Uint8Array(cipherBuf);
            var out = new Uint8Array(salt.length + iv.length + cipher.length);
            out.set(salt, 0);
            out.set(iv, salt.length);
            out.set(cipher, salt.length + iv.length);
            // Convert to base64
            var binary = '';
            for (var i = 0; i < out.length; i++) binary += String.fromCharCode(out[i]);
            return btoa(binary);
        });
}

/**
 * AES-256-GCM decryption.
 * Input: base64 string of [16-byte salt][12-byte IV][ciphertext+tag]
 * Returns a Promise resolving to plaintext string.
 * Rejects on wrong password or corrupted data.
 */
function decryptAES(b64data, password) {
    var enc = new TextEncoder();
    var raw = atob(b64data);
    var bytes = new Uint8Array(raw.length);
    for (var i = 0; i < raw.length; i++) bytes[i] = raw.charCodeAt(i);
    if (bytes.length < 29) return Promise.reject(new Error('Data too short for AES'));
    var salt = bytes.slice(0, 16);
    var iv = bytes.slice(16, 28);
    var ciphertext = bytes.slice(28);
    return crypto.subtle.importKey('raw', enc.encode(password), 'PBKDF2', false, ['deriveKey'])
        .then(function(baseKey) {
            return crypto.subtle.deriveKey(
                { name: 'PBKDF2', salt: salt, iterations: 100000, hash: 'SHA-256' },
                baseKey,
                { name: 'AES-GCM', length: 256 },
                false,
                ['decrypt']
            );
        })
        .then(function(aesKey) {
            return crypto.subtle.decrypt({ name: 'AES-GCM', iv: iv }, aesKey, ciphertext);
        })
        .then(function(plainBuf) {
            return new TextDecoder().decode(plainBuf);
        });
}

/**
 * Compute the ratio of printable characters in a string (0.0 to 1.0).
 * Printable = ASCII 32-126, newline, carriage return, tab, and common Unicode (>= 160).
 */
function printableRatio(text) {
    if (!text || text.length === 0) return 0;
    var count = 0;
    for (var i = 0; i < text.length; i++) {
        var c = text.charCodeAt(i);
        if ((c >= 32 && c <= 126) || c === 10 || c === 13 || c === 9 || c >= 160) {
            count++;
        }
    }
    return count / text.length;
}

/**
 * Format byte count to human readable.
 */
function formatBytes(bytes) {
    if (bytes === 0) return '0 B';
    var k = 1024;
    var sizes = ['B', 'KB', 'MB'];
    var i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

/**
 * Escape HTML special characters.
 */
function escapeHtml(text) {
    var map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

/**
 * LSB Encoding for raw byte arrays (file embedding).
 * Format: [BE32 payload-length] [1-byte type: 0x01=file] [1-byte filename-len] [filename UTF-8] [file bytes]
 */
function encodeLSBFile(imageData, fileBytes, filename) {
    var filenameBytes = new TextEncoder().encode(filename);
    if (filenameBytes.length > 255) {
        filenameBytes = filenameBytes.slice(0, 255);
    }
    // payload = type(1) + filenameLen(1) + filename + fileBytes
    var payloadLength = 1 + 1 + filenameBytes.length + fileBytes.length;
    var maxCapacity = Math.floor((imageData.data.length / 4) * 3 / 8) - 4;
    if (payloadLength > maxCapacity) {
        var availableForFile = Math.max(0, maxCapacity - 2 - filenameBytes.length);
        throw new Error('File too large: ' + formatBytes(fileBytes.length) + ' exceeds capacity of ' + formatBytes(availableForFile));
    }
    var header = [
        (payloadLength >>> 24) & 0xFF,
        (payloadLength >>> 16) & 0xFF,
        (payloadLength >>> 8) & 0xFF,
        payloadLength & 0xFF
    ];
    var fullMessage = [];
    var i;
    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    fullMessage.push(0x01); // type = file
    fullMessage.push(filenameBytes.length);
    for (i = 0; i < filenameBytes.length; i++) fullMessage.push(filenameBytes[i]);
    for (i = 0; i < fileBytes.length; i++) fullMessage.push(fileBytes[i]);

    var data = new Uint8ClampedArray(imageData.data);
    var bitIndex = 0;
    for (i = 0; i < fullMessage.length; i++) {
        var byte = fullMessage[i];
        for (var bit = 7; bit >= 0; bit--) {
            var bitValue = (byte >> bit) & 1;
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            data[pixelIndex] = (data[pixelIndex] & 0xFE) | bitValue;
            bitIndex++;
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * Decode LSB payload with type detection.
 * Returns { type: 'text'|'file', data: string|Uint8Array, filename: string|null }
 * Backward compatible: if first byte after length is not 0x00 or 0x01, treats as legacy text.
 */
function decodeLSBPayload(imageData) {
    var data = imageData.data;
    var bitIndex = 0;
    var i, bit, byte, pixelIndex;

    function readByte() {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) throw new Error('Data truncated');
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        return byte;
    }

    // Read 4-byte BE32 length header
    var headerBytes = [];
    for (i = 0; i < 4; i++) headerBytes.push(readByte());
    var payloadLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;

    var maxCapacity = Math.floor((data.length / 4) * 3 / 8) - 4;
    if (payloadLength === 0 || payloadLength > maxCapacity || payloadLength > 5000000) {
        throw new Error('Invalid length: ' + payloadLength);
    }

    // Read all payload bytes
    var payload = new Uint8Array(payloadLength);
    for (i = 0; i < payloadLength; i++) {
        payload[i] = readByte();
    }

    var typeByte = payload[0];

    // New format: type flag 0x01 = file
    if (typeByte === 0x01 && payloadLength >= 3) {
        var filenameLen = payload[1];
        if (filenameLen + 2 > payloadLength) {
            throw new Error('Invalid filename length');
        }
        var filenameBytes = payload.slice(2, 2 + filenameLen);
        var filename = new TextDecoder().decode(filenameBytes);
        var fileData = payload.slice(2 + filenameLen);
        return { type: 'file', data: fileData, filename: filename };
    }

    // New format: type flag 0x00 = text (explicit)
    if (typeByte === 0x00 && payloadLength >= 2) {
        var textBytes = payload.slice(1);
        return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(textBytes), filename: null };
    }

    // Legacy format: entire payload is text (no type byte)
    return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(payload), filename: null };
}

/**
 * Extract a single bit plane from image data for visualization.
 * channel: 0=R, 1=G, 2=B, 3=All (composite)
 * plane: 0-7 (0 = LSB, 7 = MSB)
 * Returns new ImageData with bit=1 → white/color, bit=0 → black.
 */
function extractBitPlane(imageData, channel, plane) {
    var src = imageData.data;
    var w = imageData.width;
    var h = imageData.height;
    var out = new Uint8ClampedArray(src.length);

    for (var i = 0; i < src.length; i += 4) {
        out[i + 3] = 255; // alpha
        if (channel === 3) {
            // All channels mode: R bit → red, G bit → green, B bit → blue
            out[i] = ((src[i] >> plane) & 1) * 255;
            out[i + 1] = ((src[i + 1] >> plane) & 1) * 255;
            out[i + 2] = ((src[i + 2] >> plane) & 1) * 255;
        } else {
            var val = ((src[i + channel] >> plane) & 1) * 255;
            out[i] = val;
            out[i + 1] = val;
            out[i + 2] = val;
        }
    }
    return new ImageData(out, w, h);
}

/**
 * Calculate capacity in bytes for given pixel count and depth settings.
 * depthMode: 'at' = single bit N, 'with' = bits 0..depth
 * depth: 0-7
 */
function calculateCapacity(pixelCount, depthMode, depth) {
    var bitsPerPixel = (depthMode === 'with') ? 3 * (depth + 1) : 3;
    return Math.floor((pixelCount * bitsPerPixel) / 8) - 4;
}

/**
 * LSB encoding at a specific bit depth (single bit N).
 * Embeds message into bit position 'depth' of RGB channels.
 */
function encodeLSBAtDepth(imageData, message, depth) {
    var data = new Uint8ClampedArray(imageData.data);
    var encoded = new TextEncoder().encode(message);
    var msgLength = encoded.length;
    var maxCapacity = calculateCapacity(imageData.width * imageData.height, 'at', depth);
    if (msgLength > maxCapacity) {
        throw new Error('Message too large: ' + msgLength + ' bytes exceeds capacity of ' + maxCapacity + ' bytes');
    }
    var header = [
        (msgLength >>> 24) & 0xFF,
        (msgLength >>> 16) & 0xFF,
        (msgLength >>> 8) & 0xFF,
        msgLength & 0xFF
    ];
    var fullMessage = [];
    var i, bit, byte, bitValue, pixelIndex, bitIndex;
    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    for (i = 0; i < encoded.length; i++) fullMessage.push(encoded[i]);

    var mask = ~(1 << depth) & 0xFF;
    bitIndex = 0;
    for (i = 0; i < fullMessage.length; i++) {
        byte = fullMessage[i];
        for (bit = 7; bit >= 0; bit--) {
            bitValue = (byte >> bit) & 1;
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            data[pixelIndex] = (data[pixelIndex] & mask) | (bitValue << depth);
            bitIndex++;
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * LSB decoding at a specific bit depth (single bit N).
 */
function decodeLSBAtDepth(imageData, depth) {
    var data = imageData.data;
    var bitIndex = 0;
    var i, bit, byte, pixelIndex;

    function readByte() {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) throw new Error('Data truncated');
            byte = (byte << 1) | ((data[pixelIndex] >> depth) & 1);
            bitIndex++;
        }
        return byte;
    }

    var headerBytes = [];
    for (i = 0; i < 4; i++) headerBytes.push(readByte());
    var msgLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;

    var maxCapacity = calculateCapacity(imageData.width * imageData.height, 'at', depth);
    if (msgLength === 0 || msgLength > maxCapacity || msgLength > 500000) {
        throw new Error('Invalid length: ' + msgLength);
    }

    var bytes = [];
    for (i = 0; i < msgLength; i++) bytes.push(readByte());
    return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes));
}

/**
 * LSB encoding using bits 0..depth (multi-bit, capacity = standard x (depth+1)).
 * Per pixel, iterate from curbit=depth down to 0 across R,G,B channels.
 */
function encodeLSBWithDepth(imageData, message, depth) {
    var data = new Uint8ClampedArray(imageData.data);
    var encoded = new TextEncoder().encode(message);
    var msgLength = encoded.length;
    var pixelCount = imageData.width * imageData.height;
    var maxCapacity = calculateCapacity(pixelCount, 'with', depth);
    if (msgLength > maxCapacity) {
        throw new Error('Message too large: ' + msgLength + ' bytes exceeds capacity of ' + maxCapacity + ' bytes');
    }
    var header = [
        (msgLength >>> 24) & 0xFF,
        (msgLength >>> 16) & 0xFF,
        (msgLength >>> 8) & 0xFF,
        msgLength & 0xFF
    ];
    var fullMessage = [];
    var i;
    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    for (i = 0; i < encoded.length; i++) fullMessage.push(encoded[i]);

    // Flatten all bits
    var bits = [];
    for (i = 0; i < fullMessage.length; i++) {
        for (var b = 7; b >= 0; b--) {
            bits.push((fullMessage[i] >> b) & 1);
        }
    }

    // Embed: for each pixel, iterate curbit from depth down to 0, across R,G,B
    var bitPos = 0;
    for (var px = 0; px < pixelCount && bitPos < bits.length; px++) {
        var base = px * 4;
        for (var curbit = depth; curbit >= 0 && bitPos < bits.length; curbit--) {
            for (var ch = 0; ch < 3 && bitPos < bits.length; ch++) {
                var mask = ~(1 << curbit) & 0xFF;
                data[base + ch] = (data[base + ch] & mask) | (bits[bitPos] << curbit);
                bitPos++;
            }
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * LSB decoding using bits 0..depth (multi-bit).
 */
function decodeLSBWithDepth(imageData, depth) {
    var data = imageData.data;
    var pixelCount = imageData.width * imageData.height;

    // Extract bits: per pixel, iterate curbit from depth down to 0 across R,G,B
    var bits = [];
    var maxBits = (4 + 500000) * 8; // cap to prevent runaway
    for (var px = 0; px < pixelCount && bits.length < maxBits; px++) {
        var base = px * 4;
        for (var curbit = depth; curbit >= 0 && bits.length < maxBits; curbit--) {
            for (var ch = 0; ch < 3 && bits.length < maxBits; ch++) {
                bits.push((data[base + ch] >> curbit) & 1);
            }
        }
    }

    function readByteAt(startBit) {
        var byte = 0;
        for (var b = 0; b < 8; b++) {
            byte = (byte << 1) | (bits[startBit + b] || 0);
        }
        return byte;
    }

    // Read 4-byte header
    var headerBytes = [];
    for (var i = 0; i < 4; i++) headerBytes.push(readByteAt(i * 8));
    var msgLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;

    var maxCapacity = calculateCapacity(pixelCount, 'with', depth);
    if (msgLength === 0 || msgLength > maxCapacity || msgLength > 500000) {
        throw new Error('Invalid length: ' + msgLength);
    }

    var bytes = [];
    for (var j = 0; j < msgLength; j++) {
        bytes.push(readByteAt((4 + j) * 8));
    }
    return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes));
}

/**
 * File embedding at a specific bit depth (single bit N).
 */
function encodeLSBFileAtDepth(imageData, fileBytes, filename, depth) {
    var filenameBytes = new TextEncoder().encode(filename);
    if (filenameBytes.length > 255) filenameBytes = filenameBytes.slice(0, 255);
    var payloadLength = 1 + 1 + filenameBytes.length + fileBytes.length;
    var maxCapacity = calculateCapacity(imageData.width * imageData.height, 'at', depth);
    if (payloadLength > maxCapacity) {
        throw new Error('File too large: ' + formatBytes(fileBytes.length) + ' exceeds capacity of ' + formatBytes(maxCapacity));
    }
    var header = [
        (payloadLength >>> 24) & 0xFF,
        (payloadLength >>> 16) & 0xFF,
        (payloadLength >>> 8) & 0xFF,
        payloadLength & 0xFF
    ];
    var fullMessage = [];
    var i;
    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    fullMessage.push(0x01);
    fullMessage.push(filenameBytes.length);
    for (i = 0; i < filenameBytes.length; i++) fullMessage.push(filenameBytes[i]);
    for (i = 0; i < fileBytes.length; i++) fullMessage.push(fileBytes[i]);

    var data = new Uint8ClampedArray(imageData.data);
    var mask = ~(1 << depth) & 0xFF;
    var bitIndex = 0;
    for (i = 0; i < fullMessage.length; i++) {
        var byte = fullMessage[i];
        for (var bit = 7; bit >= 0; bit--) {
            var bitValue = (byte >> bit) & 1;
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            data[pixelIndex] = (data[pixelIndex] & mask) | (bitValue << depth);
            bitIndex++;
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * File embedding using bits 0..depth (multi-bit).
 */
function encodeLSBFileWithDepth(imageData, fileBytes, filename, depth) {
    var filenameBytes = new TextEncoder().encode(filename);
    if (filenameBytes.length > 255) filenameBytes = filenameBytes.slice(0, 255);
    var payloadLength = 1 + 1 + filenameBytes.length + fileBytes.length;
    var pixelCount = imageData.width * imageData.height;
    var maxCapacity = calculateCapacity(pixelCount, 'with', depth);
    if (payloadLength > maxCapacity) {
        throw new Error('File too large: ' + formatBytes(fileBytes.length) + ' exceeds capacity of ' + formatBytes(maxCapacity));
    }
    var header = [
        (payloadLength >>> 24) & 0xFF,
        (payloadLength >>> 16) & 0xFF,
        (payloadLength >>> 8) & 0xFF,
        payloadLength & 0xFF
    ];
    var fullMessage = [];
    var i;
    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    fullMessage.push(0x01);
    fullMessage.push(filenameBytes.length);
    for (i = 0; i < filenameBytes.length; i++) fullMessage.push(filenameBytes[i]);
    for (i = 0; i < fileBytes.length; i++) fullMessage.push(fileBytes[i]);

    var bits = [];
    for (i = 0; i < fullMessage.length; i++) {
        for (var b = 7; b >= 0; b--) {
            bits.push((fullMessage[i] >> b) & 1);
        }
    }

    var data = new Uint8ClampedArray(imageData.data);
    var bitPos = 0;
    for (var px = 0; px < pixelCount && bitPos < bits.length; px++) {
        var base = px * 4;
        for (var curbit = depth; curbit >= 0 && bitPos < bits.length; curbit--) {
            for (var ch = 0; ch < 3 && bitPos < bits.length; ch++) {
                var mask = ~(1 << curbit) & 0xFF;
                data[base + ch] = (data[base + ch] & mask) | (bits[bitPos] << curbit);
                bitPos++;
            }
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * Decode payload with type detection at a specific bit depth.
 */
function decodeLSBPayloadAtDepth(imageData, depth) {
    var data = imageData.data;
    var bitIndex = 0;
    var i, bit, byte, pixelIndex;

    function readByte() {
        byte = 0;
        for (bit = 7; bit >= 0; bit--) {
            pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) throw new Error('Data truncated');
            byte = (byte << 1) | ((data[pixelIndex] >> depth) & 1);
            bitIndex++;
        }
        return byte;
    }

    var headerBytes = [];
    for (i = 0; i < 4; i++) headerBytes.push(readByte());
    var payloadLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;

    var maxCapacity = calculateCapacity(imageData.width * imageData.height, 'at', depth);
    if (payloadLength === 0 || payloadLength > maxCapacity || payloadLength > 5000000) {
        throw new Error('Invalid length: ' + payloadLength);
    }

    var payload = new Uint8Array(payloadLength);
    for (i = 0; i < payloadLength; i++) payload[i] = readByte();

    var typeByte = payload[0];
    if (typeByte === 0x01 && payloadLength >= 3) {
        var filenameLen = payload[1];
        if (filenameLen + 2 > payloadLength) throw new Error('Invalid filename length');
        var filenameBytes = payload.slice(2, 2 + filenameLen);
        var filename = new TextDecoder().decode(filenameBytes);
        var fileData = payload.slice(2 + filenameLen);
        return { type: 'file', data: fileData, filename: filename };
    }
    if (typeByte === 0x00 && payloadLength >= 2) {
        return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(payload.slice(1)), filename: null };
    }
    return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(payload), filename: null };
}

/**
 * Decode payload with type detection using bits 0..depth.
 */
function decodeLSBPayloadWithDepth(imageData, depth) {
    var data = imageData.data;
    var pixelCount = imageData.width * imageData.height;

    var bits = [];
    var maxBits = (4 + 5000000) * 8;
    for (var px = 0; px < pixelCount && bits.length < maxBits; px++) {
        var base = px * 4;
        for (var curbit = depth; curbit >= 0 && bits.length < maxBits; curbit--) {
            for (var ch = 0; ch < 3 && bits.length < maxBits; ch++) {
                bits.push((data[base + ch] >> curbit) & 1);
            }
        }
    }

    function readByteAt(startBit) {
        var byte = 0;
        for (var b = 0; b < 8; b++) {
            byte = (byte << 1) | (bits[startBit + b] || 0);
        }
        return byte;
    }

    var headerBytes = [];
    for (var i = 0; i < 4; i++) headerBytes.push(readByteAt(i * 8));
    var payloadLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;

    var maxCapacity = calculateCapacity(pixelCount, 'with', depth);
    if (payloadLength === 0 || payloadLength > maxCapacity || payloadLength > 5000000) {
        throw new Error('Invalid length: ' + payloadLength);
    }

    var payload = new Uint8Array(payloadLength);
    for (var j = 0; j < payloadLength; j++) payload[j] = readByteAt((4 + j) * 8);

    var typeByte = payload[0];
    if (typeByte === 0x01 && payloadLength >= 3) {
        var filenameLen = payload[1];
        if (filenameLen + 2 > payloadLength) throw new Error('Invalid filename length');
        var filenameBytes = payload.slice(2, 2 + filenameLen);
        var filename = new TextDecoder().decode(filenameBytes);
        var fileData = payload.slice(2 + filenameLen);
        return { type: 'file', data: fileData, filename: filename };
    }
    if (typeByte === 0x00 && payloadLength >= 2) {
        return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(payload.slice(1)), filename: null };
    }
    return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(payload), filename: null };
}

/**
 * Compress text using native CompressionStream (deflate) with marker byte.
 * Returns Promise<Uint8Array> with 0x01 prefix for deflate, 0x00 for btoa fallback.
 */
function compressDeflate(text) {
    var encoded = new TextEncoder().encode(text);
    if (typeof CompressionStream === 'function') {
        var cs = new CompressionStream('deflate');
        var writer = cs.writable.getWriter();
        var reader = cs.readable.getReader();
        writer.write(encoded);
        writer.close();
        var chunks = [];
        return (function pump() {
            return reader.read().then(function(result) {
                if (result.done) {
                    var totalLen = 0;
                    for (var i = 0; i < chunks.length; i++) totalLen += chunks[i].length;
                    var out = new Uint8Array(1 + totalLen);
                    out[0] = 0x01; // deflate marker
                    var offset = 1;
                    for (var j = 0; j < chunks.length; j++) {
                        out.set(chunks[j], offset);
                        offset += chunks[j].length;
                    }
                    return out;
                }
                chunks.push(new Uint8Array(result.value));
                return pump();
            });
        })();
    }
    // Fallback: btoa with 0x00 marker
    var binary = '';
    for (var i = 0; i < encoded.length; i++) binary += String.fromCharCode(encoded[i]);
    var b64 = btoa(binary);
    var b64bytes = new TextEncoder().encode(b64);
    var out = new Uint8Array(1 + b64bytes.length);
    out[0] = 0x00; // btoa marker
    out.set(b64bytes, 1);
    return Promise.resolve(out);
}

/**
 * Decompress bytes produced by compressDeflate.
 * Returns Promise<string>.
 */
function decompressDeflate(bytes) {
    if (!(bytes instanceof Uint8Array)) bytes = new Uint8Array(bytes);
    var marker = bytes[0];
    var payload = bytes.slice(1);
    if (marker === 0x01 && typeof DecompressionStream === 'function') {
        var ds = new DecompressionStream('deflate');
        var writer = ds.writable.getWriter();
        var reader = ds.readable.getReader();
        writer.write(payload);
        writer.close();
        var chunks = [];
        return (function pump() {
            return reader.read().then(function(result) {
                if (result.done) {
                    var totalLen = 0;
                    for (var i = 0; i < chunks.length; i++) totalLen += chunks[i].length;
                    var combined = new Uint8Array(totalLen);
                    var offset = 0;
                    for (var j = 0; j < chunks.length; j++) {
                        combined.set(chunks[j], offset);
                        offset += chunks[j].length;
                    }
                    return new TextDecoder().decode(combined);
                }
                chunks.push(new Uint8Array(result.value));
                return pump();
            });
        })();
    }
    // btoa fallback
    var b64str = new TextDecoder().decode(payload);
    var raw = atob(b64str);
    var decoded = new Uint8Array(raw.length);
    for (var i = 0; i < raw.length; i++) decoded[i] = raw.charCodeAt(i);
    return Promise.resolve(new TextDecoder().decode(decoded));
}

/**
 * Check if native CompressionStream is available.
 */
function hasNativeCompression() {
    return typeof CompressionStream === 'function';
}

/**
 * LSB encoding in a single channel only (Stegsolve-style plane exploration).
 * channel: 0=R, 1=G, 2=B. plane/depth: 0-7.
 */
function encodeLSBChannel(imageData, message, channel, plane) {
    channel = channel || 0;
    plane = (plane != null) ? plane : 0;
    var data = new Uint8ClampedArray(imageData.data);
    var encoded = new TextEncoder().encode(message);
    var msgLength = encoded.length;
    var pixelCount = imageData.width * imageData.height;
    var maxCapacity = Math.floor(pixelCount / 8) - 4;
    if (msgLength > maxCapacity) {
        throw new Error('Message too large: ' + msgLength + ' bytes exceeds channel capacity of ' + maxCapacity + ' bytes');
    }
    var header = [(msgLength >>> 24) & 0xFF, (msgLength >>> 16) & 0xFF, (msgLength >>> 8) & 0xFF, msgLength & 0xFF];
    var fullMessage = [];
    var i, bit, byte, bitValue, pixelIndex, bitIndex;
    for (i = 0; i < header.length; i++) fullMessage.push(header[i]);
    for (i = 0; i < encoded.length; i++) fullMessage.push(encoded[i]);
    var mask = ~(1 << plane) & 0xFF;
    bitIndex = 0;
    for (i = 0; i < fullMessage.length; i++) {
        byte = fullMessage[i];
        for (bit = 7; bit >= 0; bit--) {
            bitValue = (byte >> bit) & 1;
            pixelIndex = Math.floor(bitIndex) * 4 + channel;
            if (pixelIndex < data.length) {
                data[pixelIndex] = (data[pixelIndex] & mask) | (bitValue << plane);
            }
            bitIndex++;
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

/**
 * LSB decoding from single channel.
 */
function decodeLSBChannel(imageData, channel, plane) {
    channel = channel || 0;
    plane = (plane != null) ? plane : 0;
    var data = imageData.data;
    var pixelCount = imageData.width * imageData.height;
    var bitIndex = 0;

    function readByte() {
        var byte = 0;
        for (var b = 7; b >= 0; b--) {
            var pi = Math.floor(bitIndex) * 4 + channel;
            if (pi >= data.length) throw new Error('Data truncated');
            byte = (byte << 1) | ((data[pi] >> plane) & 1);
            bitIndex++;
        }
        return byte;
    }

    var headerBytes = [];
    for (var i = 0; i < 4; i++) headerBytes.push(readByte());
    var msgLength = ((headerBytes[0] << 24) | (headerBytes[1] << 16) | (headerBytes[2] << 8) | headerBytes[3]) >>> 0;
    var maxCapacity = Math.floor(pixelCount / 8) - 4;
    if (msgLength === 0 || msgLength > maxCapacity || msgLength > 500000) {
        throw new Error('Invalid length: ' + msgLength);
    }
    var bytes = [];
    for (var j = 0; j < msgLength; j++) bytes.push(readByte());
    return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes));
}

/**
 * Calculate required dimensions to hold a payload of given byte size.
 * Returns {width, height} maintaining original aspect ratio.
 * If the current dimensions already have enough capacity, returns them unchanged.
 */
function calculateRequiredDimensions(payloadBytes, currentWidth, currentHeight) {
    var currentPixels = currentWidth * currentHeight;
    var currentCapacity = Math.floor((currentPixels * 3) / 8) - 4;
    if (payloadBytes <= currentCapacity) {
        return { width: currentWidth, height: currentHeight };
    }
    // Need (payloadBytes + 4) * 8 bits, each bit uses one RGB channel, 3 channels per pixel
    var requiredPixels = Math.ceil((payloadBytes + 4) * 8 / 3);
    var scaleFactor = Math.ceil(Math.sqrt(requiredPixels / currentPixels));
    return {
        width: currentWidth * scaleFactor,
        height: currentHeight * scaleFactor
    };
}

// Export
window.StegoEngine = {
    encodeLSB: encodeLSB,
    decodeLSB: decodeLSB,
    decodeWithLengthHeader: decodeWithLengthHeader,
    decodeNullTerminated: decodeNullTerminated,
    decodeWithDelimiter: decodeWithDelimiter,
    decodePrintableASCII: decodePrintableASCII,
    xorEncryptBytes: xorEncryptBytes,
    xorDecryptBytes: xorDecryptBytes,
    xorEncrypt: xorEncrypt,
    encryptAES: encryptAES,
    decryptAES: decryptAES,
    encodeLSBFile: encodeLSBFile,
    decodeLSBPayload: decodeLSBPayload,
    extractBitPlane: extractBitPlane,
    printableRatio: printableRatio,
    formatBytes: formatBytes,
    escapeHtml: escapeHtml,
    calculateRequiredDimensions: calculateRequiredDimensions,
    // Batch 1: Variable bit depth
    calculateCapacity: calculateCapacity,
    encodeLSBAtDepth: encodeLSBAtDepth,
    decodeLSBAtDepth: decodeLSBAtDepth,
    encodeLSBWithDepth: encodeLSBWithDepth,
    decodeLSBWithDepth: decodeLSBWithDepth,
    encodeLSBFileAtDepth: encodeLSBFileAtDepth,
    encodeLSBFileWithDepth: encodeLSBFileWithDepth,
    decodeLSBPayloadAtDepth: decodeLSBPayloadAtDepth,
    decodeLSBPayloadWithDepth: decodeLSBPayloadWithDepth,
    encodeLSBChannel: encodeLSBChannel,
    decodeLSBChannel: decodeLSBChannel,
    // Batch 2: Compression
    compressDeflate: compressDeflate,
    decompressDeflate: decompressDeflate,
    hasNativeCompression: hasNativeCompression
};

})();
