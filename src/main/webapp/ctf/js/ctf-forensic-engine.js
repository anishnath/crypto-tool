/**
 * ctf-forensic-engine.js — Forensic CTF challenge generators.
 * Depends on: ctf-steps.js (CTFSteps), ctf-engine.js (CTFEngine) for flagVerify when available.
 *
 * Exports: window.CTFForensicEngine
 */
(function(global) {
'use strict';

var steps = global.CTFSteps || {};
var Engine = global.CTFEngine;
var ENGINE_URL = 'https://8gwifi.org/ctf/forensic-ctf-generator.jsp';
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
        generator: '8gwifi.org Forensic CTF Challenge Generator',
        version: VERSION,
        url: ENGINE_URL,
        created: new Date().toISOString(),
        difficulty: difficulty || 'medium',
        type: type
    };
}

/* ===== Helpers: minimal file formats ===== */
var PNG_SIG = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
var ZIP_SIG = [0x50, 0x4B, 0x03, 0x04];
var IEND = [0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82];

function crc32(data) {
    var table = [];
    for (var n = 0; n < 256; n++) {
        var c = n;
        for (var k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
        table[n] = c >>> 0;
    }
    var crc = 0 ^ (-1);
    for (var i = 0; i < data.length; i++) crc = table[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
    return (crc ^ (-1)) >>> 0;
}

var MINIMAL_PNG_B64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKMIQQAAAABJRU5ErkJggg==';

function createMinimalPng() {
    var bin = atob(MINIMAL_PNG_B64);
    var out = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
}

function createPngWithSize(width, height) {
    if (typeof require === 'function') {
        try {
            var zlib = require('zlib');
            var rawLen = 1 + width * height * 4;
            var raw = Buffer.alloc(rawLen, 0);
            raw[0] = 0;
            var deflated = zlib.deflateSync(raw, { level: 9 });
            var ihdr = Buffer.alloc(13);
            ihdr.writeUInt32BE(width, 0);
            ihdr.writeUInt32BE(height, 4);
            ihdr[8] = 8; ihdr[9] = 2; ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
            var crcIn = Buffer.concat([Buffer.from([0x49, 0x48, 0x44, 0x52]), ihdr]);
            var crcVal = crc32(new Uint8Array(crcIn));
            var sig = Buffer.from(PNG_SIG);
            var ihdrChunk = Buffer.alloc(25);
            ihdrChunk.writeUInt32BE(13, 0);
            ihdrChunk.set(Buffer.from([0x49, 0x48, 0x44, 0x52]), 4);
            ihdrChunk.set(ihdr, 8);
            ihdrChunk.writeUInt32BE(crcVal, 21);
            var idatCrcIn = Buffer.concat([Buffer.from([0x49, 0x44, 0x41, 0x54]), deflated]);
            var idatCrc = crc32(new Uint8Array(idatCrcIn));
            var idatChunk = Buffer.alloc(12 + deflated.length);
            idatChunk.writeUInt32BE(deflated.length, 0);
            idatChunk.set(Buffer.from([0x49, 0x44, 0x41, 0x54]), 4);
            deflated.copy(idatChunk, 8);
            idatChunk.writeUInt32BE(idatCrc, 8 + deflated.length);
            return new Uint8Array(Buffer.concat([sig, ihdrChunk, idatChunk, Buffer.from(IEND)]));
        } catch (e) {}
    }
    return createMinimalPng();
}

function createMinimalWav(durationSec) {
    var sampleRate = 44100;
    var numSamples = Math.floor(sampleRate * (durationSec || 1));
    var dataLen = numSamples * 2;
    var buf = new ArrayBuffer(44 + dataLen);
    var v = new DataView(buf);
    v.setUint8(0, 0x52); v.setUint8(1, 0x49); v.setUint8(2, 0x46); v.setUint8(3, 0x46);
    v.setUint32(4, 36 + dataLen, true);
    v.setUint8(8, 0x57); v.setUint8(9, 0x41); v.setUint8(10, 0x56); v.setUint8(11, 0x45);
    v.setUint8(12, 0x66); v.setUint8(13, 0x6D); v.setUint8(14, 0x74); v.setUint8(15, 0x20);
    v.setUint32(16, 16, true);
    v.setUint16(20, 1, true);
    v.setUint16(22, 1, true);
    v.setUint32(24, sampleRate, true);
    v.setUint32(28, sampleRate * 2, true);
    v.setUint16(32, 2, true);
    v.setUint16(34, 16, true);
    v.setUint8(36, 0x64); v.setUint8(37, 0x61); v.setUint8(38, 0x74); v.setUint8(39, 0x61);
    v.setUint32(40, dataLen, true);
    return new Uint8Array(buf);
}

function randomBytes(len, rng) {
    rng = rng || Math.random;
    var out = new Uint8Array(len);
    for (var i = 0; i < len; i++) out[i] = Math.floor(rng() * 256);
    return out;
}

/* ===== 1: magicByteCarve ===== */
function generateMagicByteCarve(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var stepsObj = steps;
    if (!stepsObj.zipWrap) throw new Error('CTFSteps.zipWrap required');
    var zipB64 = stepsObj.zipWrap.encode(flag, { filename: opts.filename || 'flag.txt' });
    var zipBin = atob(zipB64);
    var zipBytes = new Uint8Array(zipBin.length);
    for (var i = 0; i < zipBin.length; i++) zipBytes[i] = zipBin.charCodeAt(i);
    var prefixLen = 64 + Math.floor(rng() * 256);
    var suffixLen = 64 + Math.floor(rng() * 256);
    var prefix = randomBytes(prefixLen, rng);
    var suffix = randomBytes(suffixLen, rng);
    var blob = new Uint8Array(prefixLen + zipBytes.length + suffixLen);
    blob.set(prefix, 0);
    blob.set(zipBytes, prefixLen);
    blob.set(suffix, prefixLen + zipBytes.length);
    var dataB64 = '';
    for (var j = 0; j < blob.length; j++) dataB64 += String.fromCharCode(blob[j]);
    dataB64 = btoa(dataB64);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('magicByteCarve', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'carve_me.bin',
                mimeType: 'application/octet-stream',
                note: 'Extract the embedded file from this binary blob. Look for magic bytes.'
            },
            solution: { flag: flag, hash: hash, method: 'Find PK (ZIP magic), carve ZIP, extract flag.txt' },
            hints: [
                '1. The blob contains an embedded file. Identify its type by magic bytes.',
                '2. ZIP files start with 50 4B 03 04 (PK..).',
                '3. Use binwalk -e, foremost, or a hex editor to extract.',
                '4. The flag is in a text file inside the archive.',
                '5. Search for the offset of the local file header.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 2: wrongExtension ===== */
function generateWrongExtension(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.zipWrap) throw new Error('CTFSteps.zipWrap required');
    var zipB64 = stepsObj.zipWrap.encode(flag, { params: { filename: 'flag.txt' } });
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('wrongExtension', 'beginner'),
            challenge: {
                data: zipB64,
                format: 'base64',
                filename: 'readme.txt',
                realType: 'zip',
                mimeType: 'application/zip',
                note: 'This file has the wrong extension. Identify its true type and extract the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'file is ZIP; rename to .zip and extract' },
            hints: [
                '1. The extension does not match the file content.',
                '2. Check the magic bytes at the start of the file.',
                '3. ZIP magic: 50 4B 03 04. Rename to .zip and unzip.',
                '4. The flag is in a text file inside.',
                '5. On Linux: file readme.txt reveals the type.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 3: corruptedPngMagic ===== */
function generateCorruptedPngMagic(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var png = createMinimalPng();
    var stepsObj = steps;
    if (!stepsObj.embedPngText) throw new Error('CTFSteps.embedPngText required');
    var result = stepsObj.embedPngText.encode(flag, null, { coverBytes: png, keyword: 'Comment' });
    var goodPng = result.bytes;
    var corrupted = new Uint8Array(goodPng.length);
    corrupted.set(goodPng, 0);
    corrupted[0] = 0x00;
    corrupted[1] = 0x00;
    corrupted[2] = 0x00;
    corrupted[3] = 0x00;
    var dataB64 = '';
    for (var i = 0; i < corrupted.length; i++) dataB64 += String.fromCharCode(corrupted[i]);
    dataB64 = btoa(dataB64);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('corruptedPngMagic', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'broken.png',
                mimeType: 'application/octet-stream',
                note: 'This image will not open. Fix the header to view it and recover the flag.'
            },
            solution: { flag: flag, hash: hash, fix: 'First 8 bytes must be 89 50 4E 47 0D 0A 1A 0A', method: 'Fix PNG signature, then extract tEXt chunk' },
            hints: [
                '1. The file claims to be a PNG but has a corrupted header.',
                '2. A valid PNG starts with: 89 50 4E 47 0D 0A 1A 0A.',
                '3. Edit the first 8 bytes in a hex editor.',
                '4. After fixing, the image opens. Check metadata (tEXt chunks).',
                '5. exiftool or pngcheck can extract text from PNG.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 4: pngMetadataFlag ===== */
function generatePngMetadataFlag(flag, opts) {
    opts = opts || {};
    var png = createMinimalPng();
    var stepsObj = steps;
    if (!stepsObj.embedPngText) throw new Error('CTFSteps.embedPngText required');
    var kw = opts.keyword || ['Comment', 'Description', 'Artist'][Math.floor(Math.random() * 3)];
    var result = stepsObj.embedPngText.encode(flag, null, { coverBytes: png, keyword: kw });
    var dataB64 = '';
    for (var i = 0; i < result.bytes.length; i++) dataB64 += String.fromCharCode(result.bytes[i]);
    dataB64 = btoa(dataB64);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('pngMetadataFlag', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'image.png',
                mimeType: 'image/png',
                note: 'The flag is hidden in the image metadata.'
            },
            solution: { flag: flag, hash: hash, keyword: kw, method: 'Extract tEXt chunk from PNG' },
            hints: [
                '1. Check the image metadata. PNG supports tEXt chunks.',
                '2. Use exiftool image.png or pngcheck -v image.png.',
                '3. The flag is in plain text in a metadata field.',
                '4. Common keywords: Comment, Description, Artist, Software.',
                '5. No decoding needed — just read the metadata.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 5: stringsExtract ===== */
function generateStringsExtract(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.stringsHide) throw new Error('CTFSteps.stringsHide required');
    var marker = opts.marker || 'FLAG_HERE';
    var encoded = stepsObj.stringsHide.encode(flag, { chunkCount: 6, marker: marker });
    var bin = atob(encoded);
    var bytes = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    var dataB64 = btoa(String.fromCharCode.apply(null, bytes));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('stringsExtract', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'binary.bin',
                mimeType: 'application/octet-stream',
                note: 'Run strings on this binary to find the flag.'
            },
            solution: { flag: flag, hash: hash, marker: marker, method: 'strings binary.bin' },
            hints: [
                '1. The file contains binary garbage and readable text.',
                '2. Run: strings binary.bin (or strings -n 5 binary.bin).',
                '3. Look for a marker followed by the flag format.',
                '4. The flag is surrounded by a distinctive marker.',
                '5. strings extracts sequences of printable ASCII.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 6: base64InMetadata ===== */
function generateBase64InMetadata(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.base64 || !stepsObj.embedPngText) throw new Error('CTFSteps.base64 and embedPngText required');
    var encoded = stepsObj.base64.encode(flag, {});
    var png = createMinimalPng();
    var result = stepsObj.embedPngText.encode(encoded, null, { coverBytes: png, keyword: 'Comment' });
    var dataB64 = '';
    for (var i = 0; i < result.bytes.length; i++) dataB64 += String.fromCharCode(result.bytes[i]);
    dataB64 = btoa(dataB64);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('base64InMetadata', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'photo.png',
                mimeType: 'image/png',
                note: 'Extract and decode the metadata to find the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'Extract tEXt chunk, base64 decode' },
            hints: [
                '1. The flag is in PNG metadata, but encoded.',
                '2. exiftool or pngcheck to extract metadata.',
                '3. The metadata value looks like base64 (A-Za-z0-9+/=).',
                '4. Decode the base64 string to get the flag.',
                '5. base64 -d or an online decoder.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 7: truncatedPngHeight ===== */
function generateTruncatedPngHeight(flag, opts) {
    opts = opts || {};
    var w = 10, h = 20;
    var png = createPngWithSize(w, h);
    if (png.length < 50) return generatePngMetadataFlag(flag, opts);
    var stepsObj = steps;
    if (!stepsObj.embedPngText) throw new Error('CTFSteps.embedPngText required');
    var result = stepsObj.embedPngText.encode(flag, null, { coverBytes: png, keyword: 'Description' });
    var bytes = new Uint8Array(result.bytes);
    var truncatedHeight = Math.floor(h / 2);
    var ihdrDataOff = 16;
    bytes[ihdrDataOff + 4] = (truncatedHeight >>> 24) & 0xFF;
    bytes[ihdrDataOff + 5] = (truncatedHeight >>> 16) & 0xFF;
    bytes[ihdrDataOff + 6] = (truncatedHeight >>> 8) & 0xFF;
    bytes[ihdrDataOff + 7] = truncatedHeight & 0xFF;
    var ihdrData = bytes.subarray(ihdrDataOff, ihdrDataOff + 13);
    var crcInput = new Uint8Array(4 + 13);
    crcInput[0] = 0x49; crcInput[1] = 0x48; crcInput[2] = 0x44; crcInput[3] = 0x52;
    for (var i = 0; i < 13; i++) crcInput[4 + i] = ihdrData[i];
    var c = crc32(crcInput);
    bytes[ihdrDataOff + 13] = (c >>> 24) & 0xFF;
    bytes[ihdrDataOff + 14] = (c >>> 16) & 0xFF;
    bytes[ihdrDataOff + 15] = (c >>> 8) & 0xFF;
    bytes[ihdrDataOff + 16] = c & 0xFF;
    var dataB64 = '';
    for (var j = 0; j < bytes.length; j++) dataB64 += String.fromCharCode(bytes[j]);
    dataB64 = btoa(dataB64);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('truncatedPngHeight', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'cropped.png',
                mimeType: 'image/png',
                note: 'The image height is wrong. Fix it to reveal the full image with the flag.'
            },
            solution: { flag: flag, hash: hash, realHeight: h, method: 'Fix IHDR height + CRC, extract tEXt' },
            hints: [
                '1. The PNG declares a smaller height than the actual data.',
                '2. IHDR chunk (bytes 12-24) contains width and height (4 bytes each, big-endian).',
                '3. Fix the height value and recalculate the IHDR CRC32.',
                '4. After fixing, the full image displays. Check metadata.',
                '5. pngcheck -v shows chunk structure and may report CRC errors.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 8: appendEofZip ===== */
function generateAppendEofZip(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.zipWrap || !stepsObj.appendEof) throw new Error('CTFSteps.zipWrap and appendEof required');
    var zipB64 = stepsObj.zipWrap.encode(flag, { params: { filename: 'flag.txt' } });
    var zipBin = atob(zipB64);
    var zipBytes = new Uint8Array(zipBin.length);
    for (var i = 0; i < zipBin.length; i++) zipBytes[i] = zipBin.charCodeAt(i);
    var cover = createMinimalWav(0.5);
    var result = stepsObj.appendEof.encode(zipBytes, null, { coverBytes: cover });
    var dataB64 = '';
    for (var j = 0; j < result.bytes.length; j++) dataB64 += String.fromCharCode(result.bytes[j]);
    dataB64 = btoa(dataB64);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('appendEofZip', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'audio.wav',
                mimeType: 'audio/wav',
                note: 'Data has been appended after the end of this file. Extract it.'
            },
            solution: { flag: flag, hash: hash, method: 'binwalk -e or read after WAV data' },
            hints: [
                '1. The file is longer than its format suggests.',
                '2. Use binwalk -e audio.wav to extract embedded data.',
                '3. Data appended after the RIFF/WAV end is a ZIP archive.',
                '4. Extract the ZIP and read the text file inside.',
                '5. In hex editor: find end of WAV chunks, bytes after are the payload.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 9: nestedContainers ===== */
function generateNestedContainers(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.tarWrap || !stepsObj.zipWrap) throw new Error('CTFSteps.tarWrap and zipWrap required');
    var tarB64 = stepsObj.tarWrap.encode(flag, { filename: '.flag' });
    var zipPayload = stepsObj.zipWrap.encode(tarB64, { filename: 'archive.b64' });
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('nestedContainers', 'medium'),
            challenge: {
                data: zipPayload,
                format: 'base64',
                filename: 'data.zip',
                mimeType: 'application/zip',
                layers: ['ZIP', 'TAR'],
                note: 'Extract the ZIP. The file inside is base64-encoded. Decode and extract the TAR to find the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'unzip -> base64 -d archive.b64 > archive.tar -> tar -xf archive.tar -> read .flag' },
            hints: [
                '1. Extract the ZIP. It contains a .b64 file.',
                '2. The .b64 file is base64-encoded TAR data.',
                '3. base64 -d archive.b64 > archive.tar, then tar -xf archive.tar.',
                '4. Look for hidden files (names starting with a dot).',
                '5. The flag is in a file named .flag or similar.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 10: decoyBlocks ===== */
function generateDecoyBlocks(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.decoy) throw new Error('CTFSteps.decoy required');
    var marker = '<<<REAL_' + (opts.seed || 0) + '>>>';
    var encoded = stepsObj.decoy.encode(flag, { decoyCount: 4, marker: marker });
    var encBytes = new TextEncoder().encode(encoded);
    var dataB64 = btoa(String.fromCharCode.apply(null, encBytes));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('decoyBlocks', 'medium'),
            challenge: {
                data: dataB64,
                format: 'text',
                filename: 'blocks.txt',
                mimeType: 'text/plain',
                note: 'One block contains the real flag. Find it among the decoys.'
            },
            solution: { flag: flag, hash: hash, marker: marker, method: 'Find block with marker, extract payload' },
            hints: [
                '1. Multiple blocks are separated by ---. Only one has the flag.',
                '2. The real block is marked with a distinctive string.',
                '3. Look for a marker like <<<REAL>>> or similar.',
                '4. Decoy blocks contain base64 that decodes to fake messages.',
                '5. Scan each block and identify the one with the flag format.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 11: xorMaskedRegion ===== */
function generateXorMaskedRegion(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var key = Math.floor(rng() * 256);
    var flagBytes = new TextEncoder().encode(flag);
    var xorBytes = new Uint8Array(flagBytes.length);
    for (var i = 0; i < flagBytes.length; i++) xorBytes[i] = flagBytes[i] ^ key;
    var prefix = randomBytes(32 + Math.floor(rng() * 64), rng);
    var suffix = randomBytes(32 + Math.floor(rng() * 64), rng);
    var blob = new Uint8Array(prefix.length + xorBytes.length + suffix.length);
    blob.set(prefix, 0);
    blob.set(xorBytes, prefix.length);
    blob.set(suffix, prefix.length + xorBytes.length);
    var dataB64 = btoa(String.fromCharCode.apply(null, blob));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('xorMaskedRegion', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'xor.bin',
                mimeType: 'application/octet-stream',
                offset: prefix.length,
                length: xorBytes.length,
                note: 'A region of this file is XOR-encrypted. Find and decrypt it.'
            },
            solution: { flag: flag, hash: hash, xorKey: key, offset: prefix.length, method: 'XOR each byte in region with key' },
            hints: [
                '1. Part of the file is XOR\'d with a single-byte key.',
                '2. Try XOR values 0-255 on the non-garbage region.',
                '3. The flag format helps: XOR until you see flag{.',
                '4. The encrypted region is in the middle of the file.',
                '5. Single-byte XOR: m XOR k. Bruteforce k by checking output.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 12: reversedBinary ===== */
function generateReversedBinary(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.reverse) throw new Error('CTFSteps.reverse required');
    var enc = stepsObj.reverse.encode(flag, {});
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('reversedBinary', 'beginner'),
            challenge: {
                data: enc,
                format: 'base64',
                filename: 'reversed.bin',
                mimeType: 'application/octet-stream',
                note: 'The bytes of this file are in reverse order. Restore and decode.'
            },
            solution: { flag: flag, hash: hash, method: 'Reverse bytes, base64 decode' },
            hints: [
                '1. The file content is byte-reversed.',
                '2. Reverse the byte order: first byte last, last byte first.',
                '3. The reversed data is base64 encoded.',
                '4. After reversing, decode base64 to get plain text.',
                '5. xxd and tac, or a simple script: bytes[::-1].'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 13: hexDumpHunt ===== */
function generateHexDumpHunt(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var flagBytes = new TextEncoder().encode(flag);
    var lines = [];
    var pos = 0;
    while (pos < flagBytes.length) {
        var chunk = flagBytes.subarray(pos, Math.min(pos + 16, flagBytes.length));
        var hex = '';
        for (var i = 0; i < 16; i++) {
            if (i < chunk.length) {
                var h = chunk[i].toString(16);
                hex += (h.length === 1 ? '0' : '') + h + ' ';
            } else hex += '   ';
        }
        var ascii = '';
        for (var j = 0; j < chunk.length; j++) ascii += (chunk[j] >= 32 && chunk[j] < 127) ? String.fromCharCode(chunk[j]) : '.';
        lines.push(('0000000' + pos.toString(16)).slice(-8) + '  ' + hex.trim() + '  |' + ascii + '|');
        pos += 16;
    }
    var dump = lines.join('\n');
    var junkBefore = Array(20 + Math.floor(rng() * 30)).fill(0).map(function() {
        var o = Math.floor(rng() * 0x1000);
        return ('0000000' + o.toString(16)).slice(-8) + '  ' + Array(16).fill(0).map(function() { return ('0' + Math.floor(rng() * 256).toString(16)).slice(-2); }).join(' ') + '  |' + '................|';
    }).join('\n');
    var junkAfter = Array(15 + Math.floor(rng() * 20)).fill(0).map(function() {
        var o2 = 0x2000 + Math.floor(rng() * 0x1000);
        return ('0000000' + o2.toString(16)).slice(-8) + '  ' + Array(16).fill(0).map(function() { return ('0' + Math.floor(rng() * 256).toString(16)).slice(-2); }).join(' ') + '  |' + '................|';
    }).join('\n');
    var full = junkBefore + '\n' + dump + '\n' + junkAfter;
    var dataB64 = btoa(full);
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('hexDumpHunt', 'medium'),
            challenge: {
                data: dataB64,
                format: 'text',
                filename: 'dump.txt',
                mimeType: 'text/plain',
                note: 'This is a hex dump. Find the hidden flag in the output.'
            },
            solution: { flag: flag, hash: hash, method: 'Find readable ASCII column, extract flag' },
            hints: [
                '1. This is hex dump format (offset  hex_bytes  ascii).',
                '2. Look at the ASCII column on the right for readable text.',
                '3. The flag is embedded among other lines.',
                '4. Filter lines where the ASCII column looks like text.',
                '5. The flag format flag{...} is readable in the dump.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 14: multiFileCarve ===== */
function generateMultiFileCarve(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var stepsObj = steps;
    if (!stepsObj.zipWrap) throw new Error('CTFSteps.zipWrap required');
    var decoys = ['Nothing here', 'Try another file', 'Wrong one!', 'Keep looking'];
    var insertIdx = Math.floor(rng() * 5);
    var blobs = [];
    for (var i = 0; i < 4; i++) {
        if (i === insertIdx) {
            var zipB64 = stepsObj.zipWrap.encode(flag, { filename: 'flag.txt' });
            var zipBin = atob(zipB64);
            var zipBytes = new Uint8Array(zipBin.length);
            for (var k = 0; k < zipBin.length; k++) zipBytes[k] = zipBin.charCodeAt(k);
            blobs.push(zipBytes);
        } else {
            var decoyZip = stepsObj.zipWrap.encode(decoys[i], { filename: 'hint' + i + '.txt' });
            var decoyBin = atob(decoyZip);
            var decoyBytes = new Uint8Array(decoyBin.length);
            for (var d = 0; d < decoyBin.length; d++) decoyBytes[d] = decoyBin.charCodeAt(d);
            blobs.push(decoyBytes);
        }
    }
    var sep = randomBytes(128 + Math.floor(rng() * 128), rng);
    var parts = [sep];
    for (var b = 0; b < blobs.length; b++) {
        parts.push(blobs[b]);
        parts.push(sep);
    }
    var totalLen = parts.reduce(function(s, p) { return s + p.length; }, 0);
    var out = new Uint8Array(totalLen);
    var offset = 0;
    for (var t = 0; t < parts.length; t++) {
        out.set(parts[t], offset);
        offset += parts[t].length;
    }
    var dataB64 = btoa(String.fromCharCode.apply(null, out));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('multiFileCarve', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'mixed.bin',
                mimeType: 'application/octet-stream',
                fileCount: 4,
                note: 'This blob contains multiple embedded files. Carve and extract the one with the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'Carve all ZIPs, check each for flag' },
            hints: [
                '1. Multiple files are concatenated with junk in between.',
                '2. Each file starts with its magic bytes (ZIP: 50 4B 03 04).',
                '3. Use binwalk -e or carve each ZIP manually.',
                '4. Extract all archives and check the contents.',
                '5. Only one contains the flag — others are decoys.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 15: hiddenDotFile ===== */
function generateHiddenDotFile(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.tarWrap) throw new Error('CTFSteps.tarWrap required');
    var tarB64 = stepsObj.tarWrap.encode(flag, { filename: '.hidden_flag' });
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('hiddenDotFile', 'medium'),
            challenge: {
                data: tarB64,
                format: 'base64',
                filename: 'archive.tar',
                mimeType: 'application/x-tar',
                note: 'Extract this TAR archive. The flag is in a hidden file.'
            },
            solution: { flag: flag, hash: hash, filename: '.hidden_flag', method: 'tar -xf, list -la to see .hidden_flag' },
            hints: [
                '1. Extract the TAR: tar -xf archive.tar.',
                '2. List all files including hidden: ls -la or tar -tvf.',
                '3. Hidden files start with a dot (.).',
                '4. The flag is in a file like .hidden_flag or .flag.',
                '5. cat .hidden_flag to read.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 16: base64HexChain ===== */
function generateBase64HexChain(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.base64Hex || !stepsObj.base64Hex.encode) throw new Error('CTFSteps.base64Hex required');
    var enc = stepsObj.base64Hex.encode(flag, {});
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('base64HexChain', 'medium'),
            challenge: {
                ciphertext: enc,
                format: 'text',
                filename: 'encoded.txt',
                mimeType: 'text/plain',
                note: 'Decode the nested encoding to recover the flag.'
            },
            solution: { flag: flag, hash: hash, pipeline: ['hex', 'base64'], method: 'Hex decode, then base64 decode' },
            hints: [
                '1. The encoding has two layers.',
                '2. First layer: hexadecimal (0-9, a-f pairs).',
                '3. hex decode yields base64-looking string.',
                '4. Second layer: base64 decode.',
                '5. Order: hex first, then base64.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 18: polyglotPngZip ===== */
function generatePolyglotPngZip(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.zipWrap) throw new Error('CTFSteps.zipWrap required');
    var png = createMinimalPng();
    var zipB64 = stepsObj.zipWrap.encode(flag, { filename: 'flag.txt' });
    var zipBin = atob(zipB64);
    var zipBytes = new Uint8Array(zipBin.length);
    for (var i = 0; i < zipBin.length; i++) zipBytes[i] = zipBin.charCodeAt(i);
    var out = new Uint8Array(png.length + zipBytes.length);
    out.set(png, 0);
    out.set(zipBytes, png.length);
    var dataB64 = btoa(String.fromCharCode.apply(null, out));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('polyglotPngZip', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'image.png',
                mimeType: 'image/png',
                note: 'This file is both a valid PNG and contains a ZIP. Rename to .zip or use unzip to extract the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'unzip image.png or rename to .zip' },
            hints: [
                '1. The file opens as a PNG image.',
                '2. Data is appended after the PNG IEND chunk.',
                '3. The appended data is a ZIP archive.',
                '4. Use unzip image.png or rename to .zip and extract.',
                '5. binwalk -e reveals the embedded ZIP.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 19: jpegExif ===== */
var MINIMAL_JPEG_B64 = '/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBEQACEQD/ALgA/9k=';
function generateJpegExif(flag, opts) {
    opts = opts || {};
    var jpegBin = atob(MINIMAL_JPEG_B64);
    var jpegBytes = new Uint8Array(jpegBin.length);
    for (var i = 0; i < jpegBin.length; i++) jpegBytes[i] = jpegBin.charCodeAt(i);
    var eoiPos = -1;
    for (var k = 0; k < jpegBytes.length - 1; k++) {
        if (jpegBytes[k] === 0xFF && jpegBytes[k + 1] === 0xD9) { eoiPos = k; break; }
    }
    if (eoiPos < 0) return generatePngMetadataFlag(flag, opts);
    var flagBytes = new TextEncoder().encode(flag);
    var comLen = 2 + flagBytes.length;
    var comChunk = new Uint8Array(4 + flagBytes.length);
    comChunk[0] = 0xFF; comChunk[1] = 0xFE;
    comChunk[2] = (comLen >> 8) & 0xFF; comChunk[3] = comLen & 0xFF;
    comChunk.set(flagBytes, 4);
    var out = new Uint8Array(eoiPos + comChunk.length + 2);
    out.set(jpegBytes.subarray(0, eoiPos), 0);
    out.set(comChunk, eoiPos);
    out[eoiPos + comChunk.length] = 0xFF; out[eoiPos + comChunk.length + 1] = 0xD9;
    var dataB64 = btoa(String.fromCharCode.apply(null, out));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('jpegExif', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'photo.jpg',
                mimeType: 'image/jpeg',
                note: 'The flag is in the JPEG metadata. Use exiftool or strings.'
            },
            solution: { flag: flag, hash: hash, method: 'exiftool -a -G1 photo.jpg or strings' },
            hints: [
                '1. JPEG files can store comments in COM markers.',
                '2. Use exiftool -a -G1 photo.jpg to dump all metadata.',
                '3. Or run strings photo.jpg and look for the flag.',
                '4. The flag is in plain text in a comment segment.',
                '5. FF FE marks a JPEG comment segment.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 20: multiHeaderBlob ===== */
function generateMultiHeaderBlob(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var stepsObj = steps;
    if (!stepsObj.zipWrap) throw new Error('CTFSteps.zipWrap required');
    var zipB64 = stepsObj.zipWrap.encode(flag, { filename: 'flag.txt' });
    var zipBin = atob(zipB64);
    var zipBytes = new Uint8Array(zipBin.length);
    for (var i = 0; i < zipBin.length; i++) zipBytes[i] = zipBin.charCodeAt(i);
    var gifHeader = [0x47, 0x49, 0x46, 0x38, 0x39, 0x61];
    var pdfHeader = [0x25, 0x50, 0x44, 0x46, 0x2D];
    var pngHeader = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    var junk = randomBytes(32 + Math.floor(rng() * 48), rng);
    var parts = [junk, new Uint8Array(gifHeader), junk, new Uint8Array(pdfHeader), junk, new Uint8Array(pngHeader), junk, zipBytes, randomBytes(32, rng)];
    var total = parts.reduce(function(s, x) { return s + x.length; }, 0);
    var out = new Uint8Array(total);
    var pos = 0;
    for (var t = 0; t < parts.length; t++) { out.set(parts[t], pos); pos += parts[t].length; }
    var dataB64 = btoa(String.fromCharCode.apply(null, out));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('multiHeaderBlob', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'mixed.bin',
                mimeType: 'application/octet-stream',
                note: 'This blob contains multiple file headers. Find and extract the one with the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'Find PK (ZIP), carve, extract' },
            hints: [
                '1. The blob has GIF89a, PDF%, and PNG headers — decoys.',
                '2. One format is a full valid file: look for 50 4B 03 04 (ZIP).',
                '3. binwalk -e or foremost to carve embedded files.',
                '4. Only the ZIP contains the flag.',
                '5. Ignore the fake headers; carve the real archive.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 21: pcapHttp ===== */
function buildPcapPacket(ethPayload) {
    var magic = [0xa1, 0xb2, 0xc3, 0xd4];
    var version = [0x02, 0x00, 0x04, 0x00];
    var snaplen = [0x00, 0x00, 0x06, 0x00];
    var linktype = [0x01, 0x00, 0x00, 0x00];
    var gheader = new Uint8Array(24);
    for (var i = 0; i < 4; i++) gheader[i] = magic[i];
    for (var j = 0; j < 4; j++) gheader[4 + j] = version[j];
    for (var k = 0; k < 8; k++) gheader[8 + k] = 0;
    for (var m = 0; m < 4; m++) gheader[16 + m] = snaplen[m];
    for (var n = 0; n < 4; n++) gheader[20 + n] = linktype[n];
    var ts = Math.floor(Date.now() / 1000);
    var pheader = new Uint8Array(16);
    pheader[0] = (ts >>> 24) & 0xFF; pheader[1] = (ts >>> 16) & 0xFF; pheader[2] = (ts >>> 8) & 0xFF; pheader[3] = ts & 0xFF;
    for (var u = 4; u < 8; u++) pheader[u] = 0;
    var incl = ethPayload.length;
    pheader[8] = (incl >>> 24) & 0xFF; pheader[9] = (incl >>> 16) & 0xFF; pheader[10] = (incl >>> 8) & 0xFF; pheader[11] = incl & 0xFF;
    pheader[12] = pheader[8]; pheader[13] = pheader[9]; pheader[14] = pheader[10]; pheader[15] = pheader[11];
    return { gheader: gheader, pheader: pheader, payload: ethPayload };
}

function buildEthernetTcpHttp(flag) {
    var httpBody = 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\nContent-Length: ' + flag.length + '\r\n\r\n' + flag;
    var dstMac = [0x00, 0x0c, 0x29, 0x12, 0x34, 0x56];
    var srcMac = [0x00, 0x50, 0x56, 0xc0, 0x00, 0x01];
    var ethType = [0x08, 0x00];
    var ipv = [0x45, 0x00];
    var totalLen = 20 + 20 + httpBody.length;
    var ipHeader = new Uint8Array(20);
    ipHeader[0] = 0x45; ipHeader[1] = 0x00;
    ipHeader[2] = (totalLen >> 8) & 0xFF; ipHeader[3] = totalLen & 0xFF;
    ipHeader[4] = 0x00; ipHeader[5] = 0x00; ipHeader[6] = 0x40; ipHeader[7] = 0x00;
    ipHeader[8] = 0x40; ipHeader[9] = 0x06;
    ipHeader[10] = 0; ipHeader[11] = 0;
    ipHeader[12] = 0xc0; ipHeader[13] = 0xa8; ipHeader[14] = 0x01; ipHeader[15] = 0x01;
    ipHeader[16] = 0xc0; ipHeader[17] = 0xa8; ipHeader[18] = 0x01; ipHeader[19] = 0x02;
    var tcpHeader = new Uint8Array(20);
    tcpHeader[0] = 0x12; tcpHeader[1] = 0x34;
    tcpHeader[2] = 0x00; tcpHeader[3] = 0x50;
    tcpHeader[4] = 0x00; tcpHeader[5] = 0x00; tcpHeader[6] = 0x00; tcpHeader[7] = 0x01;
    tcpHeader[8] = 0x00; tcpHeader[9] = 0x00; tcpHeader[10] = 0x00; tcpHeader[11] = 0x01;
    tcpHeader[12] = 0x50; tcpHeader[13] = 0x10;
    tcpHeader[14] = 0xff; tcpHeader[15] = 0xff;
    tcpHeader[16] = 0; tcpHeader[17] = 0; tcpHeader[18] = 0; tcpHeader[19] = 0;
    var httpBytes = new TextEncoder().encode(httpBody);
    var eth = new Uint8Array(14 + ipHeader.length + tcpHeader.length + httpBytes.length);
    eth.set(dstMac, 0); eth.set(srcMac, 6); eth.set(ethType, 12);
    eth.set(ipHeader, 14); eth.set(tcpHeader, 34); eth.set(httpBytes, 54);
    return eth;
}

function generatePcapHttp(flag, opts) {
    opts = opts || {};
    var ethPayload = buildEthernetTcpHttp(flag);
    var pcap = buildPcapPacket(ethPayload);
    var out = new Uint8Array(pcap.gheader.length + pcap.pheader.length + pcap.payload.length);
    out.set(pcap.gheader, 0);
    out.set(pcap.pheader, pcap.gheader.length);
    out.set(pcap.payload, pcap.gheader.length + pcap.pheader.length);
    var dataB64 = btoa(String.fromCharCode.apply(null, out));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('pcapHttp', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'capture.pcap',
                mimeType: 'application/vnd.tcpdump.pcap',
                note: 'Analyze this packet capture. The flag is in an HTTP response.'
            },
            solution: { flag: flag, hash: hash, method: 'Wireshark: Follow TCP Stream, or tshark -Y http' },
            hints: [
                '1. Open the file in Wireshark or tshark.',
                '2. Right-click a packet → Follow → TCP Stream.',
                '3. Or filter: tshark -r capture.pcap -Y http -T fields -e text.',
                '4. The flag is in the HTTP response body.',
                '5. Look for HTTP/1.0 200 OK and the body that follows.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 22: pcapDnsExfil ===== */

function generatePcapDnsExfil(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    var enc = stepsObj && stepsObj.base32 ? stepsObj.base32.encode(flag, {}) : flag;
    var chunkLen = 20;
    var labels = [];
    for (var i = 0; i < enc.length; i += chunkLen) labels.push(enc.substring(i, Math.min(i + chunkLen, enc.length)).replace(/\./g, '-'));
    var subdomain = labels.join('.') + '.exfil.local';
    var httpHint = 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nDNS subdomains (base32): ' + subdomain;
    var ethPayload = buildEthernetTcpHttp(httpHint);
    var pcap = buildPcapPacket(ethPayload);
    var out = new Uint8Array(pcap.gheader.length + pcap.pheader.length + pcap.payload.length);
    out.set(pcap.gheader, 0);
    out.set(pcap.pheader, pcap.gheader.length);
    out.set(pcap.payload, pcap.gheader.length + pcap.pheader.length);
    var dataB64 = btoa(String.fromCharCode.apply(null, out));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('pcapDnsExfil', 'hard'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'dns_capture.pcap',
                mimeType: 'application/vnd.tcpdump.pcap',
                note: 'This capture contains a hint about DNS exfiltration. Decode the subdomain to get the flag.'
            },
            solution: { flag: flag, hash: hash, encoded: enc, method: 'Follow TCP stream, extract base32 from subdomain, decode' },
            hints: [
                '1. Open in Wireshark, Follow TCP Stream.',
                '2. The HTTP body describes DNS subdomains.',
                '3. The subdomain contains base32-encoded data.',
                '4. Extract the base32 string (replace - with nothing if needed).',
                '5. base32 -d to decode.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 23: magicByteCarvePng ===== */
function generateMagicByteCarvePng(flag, opts) {
    opts = opts || {};
    var rng = createRng(opts.seed);
    var stepsObj = steps;
    if (!stepsObj.embedPngText) throw new Error('CTFSteps.embedPngText required');
    var png = createMinimalPng();
    var result = stepsObj.embedPngText.encode(flag, null, { coverBytes: png, keyword: 'Comment' });
    var pngBytes = result.bytes;
    var prefixLen = 64 + Math.floor(rng() * 128);
    var suffixLen = 64 + Math.floor(rng() * 128);
    var prefix = randomBytes(prefixLen, rng);
    var suffix = randomBytes(suffixLen, rng);
    var blob = new Uint8Array(prefixLen + pngBytes.length + suffixLen);
    blob.set(prefix, 0);
    blob.set(pngBytes, prefixLen);
    blob.set(suffix, prefixLen + pngBytes.length);
    var dataB64 = btoa(String.fromCharCode.apply(null, blob));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('magicByteCarvePng', 'beginner'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'carve_me.bin',
                mimeType: 'application/octet-stream',
                note: 'Carve the embedded PNG from this blob. The flag is in the PNG metadata.'
            },
            solution: { flag: flag, hash: hash, method: 'Find 89 50 4E 47, carve PNG, exiftool/pngcheck' },
            hints: [
                '1. PNG magic bytes: 89 50 4E 47 0D 0A 1A 0A.',
                '2. Use binwalk -e or foremost to carve.',
                '3. Extract the PNG, then check metadata (tEXt chunk).',
                '4. exiftool or pngcheck -v on the carved image.',
                '5. The flag is in the Comment field.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== Static-asset types (useStaticAsset: true) ===== */
/* Each type has multiple asset variants; one is chosen at random (or by seed). */
var STATIC_ASSET_VARIANTS = {
    volatilityMemDump: [
        { assetId: 'mem-dump-1', flag: 'flag{volatility_master}' },
        { assetId: 'mem-dump-2', flag: 'flag{memory_carve_dump}' },
        { assetId: 'mem-dump-3', flag: 'flag{volatility_cmd_inject}' }
    ],
    ntfsArtifacts: [
        { assetId: 'ntfs-mft-1', flag: 'flag{ntfs_forensic_master}' },
        { assetId: 'ntfs-mft-2', flag: 'flag{mft_record_carve}' },
        { assetId: 'ntfs-mft-3', flag: 'flag{deleted_ntfs_recover}' }
    ],
    firmwareHidden: [
        { assetId: 'firmware-router-1', flag: 'flag{firmware_carve_master}' },
        { assetId: 'firmware-router-2', flag: 'flag{hidden_squashfs_partition}' }
    ],
    recycleBin: [
        { assetId: 'recycle-bin-1', flag: 'flag{recycle_bin_master}' },
        { assetId: 'recycle-bin-2', flag: 'flag{trash_forensics}' }
    ],
    wpaHandshake: [
        { assetId: 'wpa-handshake-1', flag: 'flag{wpa_crack_master}' },
        { assetId: 'wpa-handshake-2', flag: 'flag{aircrack_pwned}' }
    ]
};
var STATIC_ASSET_NOTES = {
    volatilityMemDump: 'Analyze this memory dump with Volatility. Find the suspicious process and extract the flag.',
    ntfsArtifacts: 'Parse NTFS $MFT to recover the deleted file containing the flag.',
    firmwareHidden: 'Extract the hidden partition from this router firmware dump.',
    recycleBin: 'Parse $Recycle.Bin to recover the deleted file and its contents.',
    wpaHandshake: 'Crack the WPA2 handshake to decrypt the traffic and find the flag.'
};

function generateStaticAsset(type, flag, opts) {
    opts = opts || {};
    var variants = STATIC_ASSET_VARIANTS[type];
    if (!variants || variants.length === 0) throw new Error('Unknown static asset type: ' + type);
    var rng = createRng(opts.seed);
    var idx = Math.floor(rng() * variants.length);
    var chosen = variants[idx];
    var assetPath = '/ctf/assets/forensic/' + chosen.assetId + '.bin';
    var difficulty = type === 'recycleBin' ? 'medium' : 'hard';
    return flagHash(chosen.flag || '').then(function(hash) {
        return {
            meta: makeMeta(type, difficulty),
            challenge: {
                assetUrl: assetPath,
                format: 'binary',
                filename: chosen.assetId + '.bin',
                mimeType: 'application/octet-stream',
                note: STATIC_ASSET_NOTES[type] || 'Use the appropriate forensic tool.',
                staticAsset: true
            },
            solution: { flag: chosen.flag, hash: hash, method: 'Use tool specified in note' },
            hints: [
                '1. Download the static asset from ' + assetPath + '.',
                '2. Use the appropriate forensic tool for this file type.',
                '3. The asset is pre-generated; solution is in MANIFEST.json.',
                '4. Tools: Volatility, sleuthkit, binwalk, aircrack-ng, etc.',
                '5. Each asset has a fixed, documented solution.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== 17: rot13InBinary ===== */
function generateRot13InBinary(flag, opts) {
    opts = opts || {};
    var stepsObj = steps;
    if (!stepsObj.rot13) throw new Error('CTFSteps.rot13 required');
    var rot = stepsObj.rot13.encode(flag, {});
    var stepsObj2 = steps;
    if (!stepsObj2.stringsHide) throw new Error('CTFSteps.stringsHide required');
    var encoded = stepsObj2.stringsHide.encode(rot, { chunkCount: 4, marker: 'ROT13' });
    var bin = atob(encoded);
    var bytes = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    var dataB64 = btoa(String.fromCharCode.apply(null, bytes));
    return flagHash(flag).then(function(hash) {
        return {
            meta: makeMeta('rot13InBinary', 'medium'),
            challenge: {
                data: dataB64,
                format: 'binary',
                filename: 'data.bin',
                mimeType: 'application/octet-stream',
                note: 'Run strings and decode to find the flag.'
            },
            solution: { flag: flag, hash: hash, method: 'strings, find ROT13:..., rot13 decode' },
            hints: [
                '1. Run strings on the binary.',
                '2. One string is ROT13-encoded.',
                '3. ROT13: A↔N, B↔O, etc. Apply to the string after the marker.',
                '4. Decode and you get the flag.',
                '5. The marker helps locate the right string.'
            ].slice(0, opts.hintCount || 5)
        };
    });
}

/* ===== Type registry and generate ===== */
var GENERATORS = {
    magicByteCarve:      { fn: generateMagicByteCarve,      difficulty: 'beginner' },
    wrongExtension:      { fn: generateWrongExtension,      difficulty: 'beginner' },
    corruptedPngMagic:   { fn: generateCorruptedPngMagic,   difficulty: 'beginner' },
    pngMetadataFlag:     { fn: generatePngMetadataFlag,     difficulty: 'beginner' },
    stringsExtract:     { fn: generateStringsExtract,      difficulty: 'beginner' },
    base64InMetadata:   { fn: generateBase64InMetadata,   difficulty: 'beginner' },
    reversedBinary:     { fn: generateReversedBinary,      difficulty: 'beginner' },
    jpegExif:            { fn: generateJpegExif,            difficulty: 'beginner' },
    magicByteCarvePng:   { fn: generateMagicByteCarvePng,   difficulty: 'beginner' },
    truncatedPngHeight:  { fn: generateTruncatedPngHeight,  difficulty: 'medium' },
    appendEofZip:        { fn: generateAppendEofZip,        difficulty: 'medium' },
    nestedContainers:    { fn: generateNestedContainers,    difficulty: 'medium' },
    decoyBlocks:         { fn: generateDecoyBlocks,        difficulty: 'medium' },
    xorMaskedRegion:     { fn: generateXorMaskedRegion,     difficulty: 'medium' },
    hexDumpHunt:         { fn: generateHexDumpHunt,         difficulty: 'medium' },
    multiFileCarve:      { fn: generateMultiFileCarve,     difficulty: 'medium' },
    hiddenDotFile:      { fn: generateHiddenDotFile,      difficulty: 'medium' },
    base64HexChain:      { fn: generateBase64HexChain,      difficulty: 'medium' },
    rot13InBinary:       { fn: generateRot13InBinary,       difficulty: 'medium' },
    polyglotPngZip:      { fn: generatePolyglotPngZip,      difficulty: 'medium' },
    multiHeaderBlob:     { fn: generateMultiHeaderBlob,     difficulty: 'medium' },
    pcapHttp:            { fn: generatePcapHttp,            difficulty: 'medium' },
    pcapDnsExfil:        { fn: generatePcapDnsExfil,        difficulty: 'hard' },
    volatilityMemDump:   { fn: function(f,o){ return generateStaticAsset('volatilityMemDump',f,o); }, difficulty: 'hard',   staticAsset: true },
    ntfsArtifacts:       { fn: function(f,o){ return generateStaticAsset('ntfsArtifacts',f,o); },       difficulty: 'hard',   staticAsset: true },
    firmwareHidden:      { fn: function(f,o){ return generateStaticAsset('firmwareHidden',f,o); },      difficulty: 'hard',   staticAsset: true },
    recycleBin:          { fn: function(f,o){ return generateStaticAsset('recycleBin',f,o); },          difficulty: 'medium', staticAsset: true },
    wpaHandshake:        { fn: function(f,o){ return generateStaticAsset('wpaHandshake',f,o); },        difficulty: 'hard',   staticAsset: true }
};

function listTypes() {
    var list = [];
    for (var k in GENERATORS) list.push({ id: k, difficulty: GENERATORS[k].difficulty });
    return list;
}

function generate(type, flag, options) {
    options = options || {};
    var gen = GENERATORS[type];
    if (!gen) throw new Error('Unknown forensic type: ' + type);
    return gen.fn(flag, options);
}

function generateRandom(flag, options) {
    options = options || {};
    var rng = createRng(options.seed);
    var ids = Object.keys(GENERATORS);
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
    global.CTFForensicEngine = api;
}
})(typeof global !== 'undefined' ? global : typeof window !== 'undefined' ? window : this);
