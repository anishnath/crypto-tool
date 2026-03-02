/**
 * Steganography Tool - Audio WAV Module
 * WAV PCM steganography: hide data in LSBs of audio samples
 */
(function() {
'use strict';

/**
 * Parse WAV file buffer, extract header info and PCM data offset.
 * Returns { sampleRate, bitsPerSample, numChannels, numSamples, dataOffset, dataSize, duration }
 */
function parseWAV(buffer) {
    var view = new DataView(buffer);
    if (buffer.byteLength < 44) throw new Error('File too small to be a valid WAV');

    // RIFF header
    var riff = String.fromCharCode(view.getUint8(0), view.getUint8(1), view.getUint8(2), view.getUint8(3));
    if (riff !== 'RIFF') throw new Error('Not a RIFF file');
    var wave = String.fromCharCode(view.getUint8(8), view.getUint8(9), view.getUint8(10), view.getUint8(11));
    if (wave !== 'WAVE') throw new Error('Not a WAVE file');

    // Find fmt and data chunks
    var offset = 12;
    var fmtFound = false;
    var audioFormat, numChannels, sampleRate, bitsPerSample;
    var dataOffset = 0, dataSize = 0;

    while (offset < buffer.byteLength - 8) {
        var chunkId = String.fromCharCode(view.getUint8(offset), view.getUint8(offset + 1), view.getUint8(offset + 2), view.getUint8(offset + 3));
        var chunkSize = view.getUint32(offset + 4, true);

        if (chunkId === 'fmt ') {
            audioFormat = view.getUint16(offset + 8, true);
            numChannels = view.getUint16(offset + 10, true);
            sampleRate = view.getUint32(offset + 12, true);
            bitsPerSample = view.getUint16(offset + 22, true);
            fmtFound = true;
        } else if (chunkId === 'data') {
            dataOffset = offset + 8;
            dataSize = chunkSize;
        }

        offset += 8 + chunkSize;
        if (chunkSize % 2 !== 0) offset++; // padding byte
    }

    if (!fmtFound) throw new Error('No fmt chunk found');
    if (dataOffset === 0) throw new Error('No data chunk found');
    if (audioFormat !== 1) throw new Error('Not PCM format (format: ' + audioFormat + ')');

    var bytesPerSample = bitsPerSample / 8;
    var numSamples = Math.floor(dataSize / bytesPerSample);
    var duration = numSamples / (sampleRate * numChannels);

    return {
        sampleRate: sampleRate,
        bitsPerSample: bitsPerSample,
        numChannels: numChannels,
        numSamples: numSamples,
        dataOffset: dataOffset,
        dataSize: dataSize,
        duration: duration,
        bytesPerSample: bytesPerSample
    };
}

/**
 * Calculate capacity for WAV steganography.
 */
function getWAVCapacity(wavBuffer, depth, depthMode) {
    var info = parseWAV(wavBuffer);
    var bitsPerSample = (depthMode === 'with') ? (depth + 1) : 1;
    return Math.floor((info.numSamples * bitsPerSample) / 8) - 4;
}

/**
 * Read a sample value from WAV data at given sample index.
 */
function readSample(view, info, sampleIndex) {
    var byteOffset = info.dataOffset + sampleIndex * info.bytesPerSample;
    if (info.bitsPerSample === 8) {
        return view.getUint8(byteOffset);
    } else if (info.bitsPerSample === 16) {
        return view.getInt16(byteOffset, true);
    } else if (info.bitsPerSample === 24) {
        var b0 = view.getUint8(byteOffset);
        var b1 = view.getUint8(byteOffset + 1);
        var b2 = view.getUint8(byteOffset + 2);
        var val = b0 | (b1 << 8) | (b2 << 16);
        if (val & 0x800000) val |= 0xFF000000; // sign extend
        return val;
    } else if (info.bitsPerSample === 32) {
        return view.getInt32(byteOffset, true);
    }
    throw new Error('Unsupported bits per sample: ' + info.bitsPerSample);
}

/**
 * Write a sample value to WAV data at given sample index.
 */
function writeSample(view, info, sampleIndex, value) {
    var byteOffset = info.dataOffset + sampleIndex * info.bytesPerSample;
    if (info.bitsPerSample === 8) {
        view.setUint8(byteOffset, value & 0xFF);
    } else if (info.bitsPerSample === 16) {
        view.setInt16(byteOffset, value, true);
    } else if (info.bitsPerSample === 24) {
        view.setUint8(byteOffset, value & 0xFF);
        view.setUint8(byteOffset + 1, (value >> 8) & 0xFF);
        view.setUint8(byteOffset + 2, (value >> 16) & 0xFF);
    } else if (info.bitsPerSample === 32) {
        view.setInt32(byteOffset, value, true);
    }
}

/**
 * Encode a text message into WAV PCM samples.
 */
function encodeWAV(wavBuffer, message, depth, depthMode) {
    var info = parseWAV(wavBuffer);
    var encoded = new TextEncoder().encode(message);
    var msgLength = encoded.length;
    var capacity = getWAVCapacity(wavBuffer, depth, depthMode);
    if (msgLength > capacity) {
        throw new Error('Message too large: ' + msgLength + ' bytes exceeds WAV capacity of ' + capacity + ' bytes');
    }

    // Build header + message bytes
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

    // Flatten to bits
    var bits = [];
    for (i = 0; i < fullMessage.length; i++) {
        for (var b = 7; b >= 0; b--) {
            bits.push((fullMessage[i] >> b) & 1);
        }
    }

    // Copy buffer
    var outBuffer = wavBuffer.slice(0);
    var view = new DataView(outBuffer);
    var bitPos = 0;

    if (depthMode === 'with') {
        // Multi-bit: bits depth down to 0
        for (var si = 0; si < info.numSamples && bitPos < bits.length; si++) {
            var sample = readSample(view, info, si);
            for (var curbit = depth; curbit >= 0 && bitPos < bits.length; curbit--) {
                var mask = ~(1 << curbit);
                sample = (sample & mask) | (bits[bitPos] << curbit);
                bitPos++;
            }
            writeSample(view, info, si, sample);
        }
    } else {
        // Single bit at depth
        var smask = ~(1 << depth);
        for (var sj = 0; sj < info.numSamples && bitPos < bits.length; sj++) {
            var samp = readSample(view, info, sj);
            samp = (samp & smask) | (bits[bitPos] << depth);
            writeSample(view, info, sj, samp);
            bitPos++;
        }
    }

    return outBuffer;
}

/**
 * Decode a text message from WAV PCM samples.
 */
function decodeWAV(wavBuffer, depth, depthMode) {
    var info = parseWAV(wavBuffer);
    var view = new DataView(wavBuffer);

    // Extract bits
    var bits = [];
    var maxBits = (4 + 500000) * 8;

    if (depthMode === 'with') {
        for (var si = 0; si < info.numSamples && bits.length < maxBits; si++) {
            var sample = readSample(view, info, si);
            for (var curbit = depth; curbit >= 0 && bits.length < maxBits; curbit--) {
                bits.push((sample >> curbit) & 1);
            }
        }
    } else {
        for (var sj = 0; sj < info.numSamples && bits.length < maxBits; sj++) {
            var samp = readSample(view, info, sj);
            bits.push((samp >> depth) & 1);
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

    var capacity = getWAVCapacity(wavBuffer, depth, depthMode);
    if (msgLength === 0 || msgLength > capacity || msgLength > 500000) {
        throw new Error('Invalid message length: ' + msgLength);
    }

    var bytes = [];
    for (var j = 0; j < msgLength; j++) {
        bytes.push(readByteAt((4 + j) * 8));
    }
    return new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(bytes));
}

/**
 * Encode a file into WAV PCM samples.
 */
function encodeWAVFile(wavBuffer, fileBytes, filename, depth, depthMode) {
    var filenameBytes = new TextEncoder().encode(filename);
    if (filenameBytes.length > 255) filenameBytes = filenameBytes.slice(0, 255);
    var payloadLength = 1 + 1 + filenameBytes.length + fileBytes.length;
    var capacity = getWAVCapacity(wavBuffer, depth, depthMode);
    if (payloadLength > capacity) {
        throw new Error('File too large for WAV capacity');
    }

    // Build payload: [header][0x01][filenameLen][filename][fileBytes]
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

    var info = parseWAV(wavBuffer);
    var outBuffer = wavBuffer.slice(0);
    var view = new DataView(outBuffer);
    var bitPos = 0;

    if (depthMode === 'with') {
        for (var si = 0; si < info.numSamples && bitPos < bits.length; si++) {
            var sample = readSample(view, info, si);
            for (var curbit = depth; curbit >= 0 && bitPos < bits.length; curbit--) {
                sample = (sample & ~(1 << curbit)) | (bits[bitPos] << curbit);
                bitPos++;
            }
            writeSample(view, info, si, sample);
        }
    } else {
        var smask = ~(1 << depth);
        for (var sj = 0; sj < info.numSamples && bitPos < bits.length; sj++) {
            var samp = readSample(view, info, sj);
            samp = (samp & smask) | (bits[bitPos] << depth);
            writeSample(view, info, sj, samp);
            bitPos++;
        }
    }

    return outBuffer;
}

/**
 * Decode payload from WAV with type detection (text or file).
 */
function decodeWAVPayload(wavBuffer, depth, depthMode) {
    var info = parseWAV(wavBuffer);
    var view = new DataView(wavBuffer);

    var bits = [];
    var maxBits = (4 + 5000000) * 8;

    if (depthMode === 'with') {
        for (var si = 0; si < info.numSamples && bits.length < maxBits; si++) {
            var sample = readSample(view, info, si);
            for (var curbit = depth; curbit >= 0 && bits.length < maxBits; curbit--) {
                bits.push((sample >> curbit) & 1);
            }
        }
    } else {
        for (var sj = 0; sj < info.numSamples && bits.length < maxBits; sj++) {
            bits.push((readSample(view, info, sj) >> depth) & 1);
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

    var capacity = getWAVCapacity(wavBuffer, depth, depthMode);
    if (payloadLength === 0 || payloadLength > capacity || payloadLength > 5000000) {
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

    return { type: 'text', data: new TextDecoder('utf-8', { fatal: false }).decode(payload), filename: null };
}

// Export
window.StegoAudio = {
    parseWAV: parseWAV,
    encodeWAV: encodeWAV,
    decodeWAV: decodeWAV,
    getWAVCapacity: getWAVCapacity,
    encodeWAVFile: encodeWAVFile,
    decodeWAVPayload: decodeWAVPayload
};

})();
