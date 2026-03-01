/* hexdump-formats.js — Binary format parsers for structure analysis
   Exposes: window.HexFormats
   Each parser returns Region[]: { start, end, type, label, color, description, fields[] } */
(function() {
    'use strict';

    var HexFormats = {};

    // ===== Helpers =====
    function r(start, end, type, label, color, description, fields) {
        return { start: start, end: end, type: type, label: label, color: color, description: description || '', fields: fields || [] };
    }

    function readU16BE(d, o) { return (d[o] << 8) | d[o + 1]; }
    function readU16LE(d, o) { return d[o] | (d[o + 1] << 8); }
    function readU32BE(d, o) { return ((d[o] << 24) | (d[o + 1] << 16) | (d[o + 2] << 8) | d[o + 3]) >>> 0; }
    function readU32LE(d, o) { return (d[o] | (d[o + 1] << 8) | (d[o + 2] << 16) | (d[o + 3] << 24)) >>> 0; }

    function ascii(d, start, len) {
        var s = '';
        for (var i = 0; i < len && start + i < d.length; i++) {
            var c = d[start + i];
            s += (c >= 0x20 && c <= 0x7e) ? String.fromCharCode(c) : '.';
        }
        return s;
    }

    function hexBytes(d, start, len) {
        var parts = [];
        for (var i = 0; i < len && start + i < d.length; i++) {
            parts.push(('0' + d[start + i].toString(16).toUpperCase()).slice(-2));
        }
        return parts.join(' ');
    }

    // ===== PNG =====
    HexFormats.parsePNG = function(d) {
        var regions = [];
        if (d.length < 8) return regions;

        regions.push(r(0, 7, 'magic', 'PNG Signature', 'magic',
            '89 50 4E 47 0D 0A 1A 0A \u2014 identifies this as a PNG file'));

        var off = 8;
        var chunkNum = 0;
        while (off + 8 <= d.length && chunkNum < 500) {
            var len = readU32BE(d, off);
            var type = ascii(d, off + 4, 4);
            var chunkEnd = Math.min(off + 12 + len - 1, d.length - 1);

            // Chunk length + type
            regions.push(r(off, off + 7, 'header', type + ' Chunk Header', 'header',
                'Chunk type: ' + type + ', Data length: ' + len + ' bytes'));

            // Chunk data
            if (len > 0 && off + 8 < d.length) {
                var dataStart = off + 8;
                var dataEnd = Math.min(off + 8 + len - 1, d.length - 1);

                if (type === 'IHDR' && len >= 13) {
                    var w = readU32BE(d, dataStart);
                    var h = readU32BE(d, dataStart + 4);
                    var depth = d[dataStart + 8];
                    var colorType = d[dataStart + 9];
                    var colorNames = { 0: 'Grayscale', 2: 'RGB', 3: 'Indexed', 4: 'Grayscale+Alpha', 6: 'RGBA' };
                    regions.push(r(dataStart, dataEnd, 'metadata', 'IHDR Data', 'metadata',
                        'Image dimensions and color info', [
                            'Width: ' + w + 'px',
                            'Height: ' + h + 'px',
                            'Bit depth: ' + depth,
                            'Color type: ' + (colorNames[colorType] || colorType),
                            'Compression: ' + d[dataStart + 10],
                            'Filter: ' + d[dataStart + 11],
                            'Interlace: ' + (d[dataStart + 12] ? 'Adam7' : 'None')
                        ]));
                } else if (type === 'IDAT') {
                    regions.push(r(dataStart, dataEnd, 'compressed', 'IDAT Compressed Data', 'compressed',
                        'Compressed pixel data (' + len + ' bytes)'));
                } else if (type === 'PLTE') {
                    regions.push(r(dataStart, dataEnd, 'metadata', 'PLTE Palette', 'metadata',
                        'Color palette: ' + Math.floor(len / 3) + ' entries'));
                } else if (type === 'tEXt' || type === 'iTXt' || type === 'zTXt') {
                    regions.push(r(dataStart, dataEnd, 'string', type + ' Text', 'string',
                        'Embedded text metadata'));
                } else if (type === 'IEND') {
                    // No data
                } else {
                    regions.push(r(dataStart, dataEnd, 'data', type + ' Data', 'data',
                        type + ' chunk data (' + len + ' bytes)'));
                }
            }

            // CRC
            var crcStart = off + 8 + len;
            if (crcStart + 4 <= d.length) {
                regions.push(r(crcStart, crcStart + 3, 'checksum', type + ' CRC', 'checksum',
                    'CRC-32 checksum: 0x' + readU32BE(d, crcStart).toString(16).toUpperCase()));
            }

            off = crcStart + 4;
            chunkNum++;
            if (type === 'IEND') break;
        }
        return regions;
    };

    // ===== JPEG =====
    HexFormats.parseJPEG = function(d) {
        var regions = [];
        if (d.length < 2) return regions;

        regions.push(r(0, 1, 'magic', 'SOI Marker', 'magic', 'FF D8 \u2014 Start of Image'));

        var off = 2;
        var markerNames = {
            0xC0: 'SOF0 (Baseline)', 0xC2: 'SOF2 (Progressive)',
            0xC4: 'DHT (Huffman Table)', 0xDB: 'DQT (Quantization Table)',
            0xDD: 'DRI (Restart Interval)', 0xDA: 'SOS (Start of Scan)',
            0xE0: 'APP0 (JFIF)', 0xE1: 'APP1 (EXIF)',
            0xE2: 'APP2', 0xFE: 'COM (Comment)'
        };

        while (off + 1 < d.length) {
            if (d[off] !== 0xFF) { off++; continue; }
            var marker = d[off + 1];

            if (marker === 0xD9) {
                regions.push(r(off, off + 1, 'magic', 'EOI Marker', 'magic', 'FF D9 \u2014 End of Image'));
                break;
            }

            if (marker === 0xDA) {
                // SOS — rest is scan data until EOI
                var segLen = (off + 3 < d.length) ? readU16BE(d, off + 2) : 2;
                regions.push(r(off, off + 1 + segLen, 'header', 'SOS Header', 'header', 'Start of Scan marker + parameters'));
                var scanStart = off + 2 + segLen;
                // Find EOI
                var eoiPos = d.length - 2;
                for (var s = scanStart; s < d.length - 1; s++) {
                    if (d[s] === 0xFF && d[s + 1] === 0xD9) { eoiPos = s; break; }
                }
                if (scanStart < eoiPos) {
                    regions.push(r(scanStart, eoiPos - 1, 'compressed', 'Scan Data', 'compressed',
                        'Compressed image data (' + (eoiPos - scanStart) + ' bytes)'));
                }
                regions.push(r(eoiPos, eoiPos + 1, 'magic', 'EOI Marker', 'magic', 'FF D9 \u2014 End of Image'));
                break;
            }

            if (marker === 0x00 || (marker >= 0xD0 && marker <= 0xD7)) {
                off += 2;
                continue;
            }

            if (off + 3 >= d.length) break;
            var segmentLen = readU16BE(d, off + 2);
            var name = markerNames[marker] || ('Marker 0x' + marker.toString(16).toUpperCase());

            regions.push(r(off, off + 1, 'header', name + ' Marker', 'header',
                'FF ' + ('0' + marker.toString(16).toUpperCase()).slice(-2)));

            if (segmentLen > 2) {
                var segColor = 'metadata';
                if (marker === 0xC4) segColor = 'data';
                if (marker === 0xDB) segColor = 'data';
                if (marker === 0xFE) segColor = 'string';

                var fields = [];
                if ((marker === 0xC0 || marker === 0xC2) && segmentLen >= 9) {
                    var precision = d[off + 4];
                    var height = readU16BE(d, off + 5);
                    var width = readU16BE(d, off + 7);
                    var components = d[off + 9];
                    fields = ['Precision: ' + precision + ' bits', 'Width: ' + width + 'px', 'Height: ' + height + 'px', 'Components: ' + components];
                }

                regions.push(r(off + 2, off + 1 + segmentLen, segColor, name + ' Data', segColor,
                    name + ' (' + (segmentLen - 2) + ' bytes)', fields));
            }

            off += 2 + segmentLen;
        }
        return regions;
    };

    // ===== PDF =====
    HexFormats.parsePDF = function(d) {
        var regions = [];
        if (d.length < 5) return regions;

        // %PDF-x.y header
        var headerEnd = 4;
        for (var i = 5; i < Math.min(d.length, 20); i++) {
            if (d[i] === 0x0A || d[i] === 0x0D) { headerEnd = i; break; }
        }
        var version = ascii(d, 0, headerEnd + 1);
        regions.push(r(0, headerEnd, 'magic', 'PDF Header', 'magic', version + ' \u2014 PDF version identifier'));

        // Look for %%EOF from the end
        var eofPos = -1;
        for (var e = d.length - 1; e > Math.max(0, d.length - 64); e--) {
            if (d[e] === 0x46 && e >= 4 && ascii(d, e - 4, 5) === '%%EOF') {
                eofPos = e - 4;
                break;
            }
        }

        // Look for xref
        var xrefPos = -1;
        if (eofPos > 0) {
            for (var x = eofPos - 1; x > Math.max(0, eofPos - 128); x--) {
                if (d[x] === 0x78 && ascii(d, x, 4) === 'xref') {
                    xrefPos = x;
                    break;
                }
            }
        }

        // Look for startxref
        var startxrefPos = -1;
        if (eofPos > 0) {
            for (var sx = eofPos - 1; sx > Math.max(0, eofPos - 64); sx--) {
                if (d[sx] === 0x73 && ascii(d, sx, 9) === 'startxref') {
                    startxrefPos = sx;
                    break;
                }
            }
        }

        // Body (between header and xref/startxref/eof)
        var bodyEnd = (xrefPos > 0 ? xrefPos : (startxrefPos > 0 ? startxrefPos : (eofPos > 0 ? eofPos : d.length))) - 1;
        if (headerEnd + 1 < bodyEnd) {
            regions.push(r(headerEnd + 1, bodyEnd, 'data', 'PDF Body', 'data',
                'PDF objects, streams, and content (' + (bodyEnd - headerEnd) + ' bytes)'));
        }

        if (xrefPos > 0 && startxrefPos > 0) {
            regions.push(r(xrefPos, startxrefPos - 1, 'index', 'Cross-Reference Table', 'index',
                'xref table \u2014 maps object numbers to byte offsets'));
        }

        if (startxrefPos > 0 && eofPos > 0) {
            regions.push(r(startxrefPos, eofPos - 1, 'metadata', 'Trailer', 'metadata',
                'startxref + trailer dictionary'));
        }

        if (eofPos > 0) {
            regions.push(r(eofPos, Math.min(eofPos + 4, d.length - 1), 'magic', '%%EOF Marker', 'magic',
                'End of PDF file marker'));
        }

        return regions;
    };

    // ===== ZIP =====
    HexFormats.parseZIP = function(d) {
        var regions = [];
        if (d.length < 4) return regions;

        var off = 0;
        var fileNum = 0;

        // Local file headers
        while (off + 30 <= d.length && fileNum < 500) {
            var sig = readU32LE(d, off);
            if (sig !== 0x04034B50) break;

            var compMethod = readU16LE(d, off + 8);
            var compSize = readU32LE(d, off + 18);
            var uncompSize = readU32LE(d, off + 22);
            var nameLen = readU16LE(d, off + 26);
            var extraLen = readU16LE(d, off + 28);
            var fileName = ascii(d, off + 30, nameLen);

            regions.push(r(off, off + 29, 'header', 'Local File Header #' + (fileNum + 1), 'header',
                'PK\\x03\\x04 \u2014 Local file header for "' + fileName + '"', [
                    'File: ' + fileName,
                    'Compressed: ' + compSize + ' bytes',
                    'Uncompressed: ' + uncompSize + ' bytes',
                    'Method: ' + (compMethod === 8 ? 'Deflate' : compMethod === 0 ? 'Stored' : compMethod)
                ]));

            if (nameLen > 0) {
                regions.push(r(off + 30, off + 29 + nameLen, 'string', 'Filename: ' + fileName, 'string',
                    'Entry filename'));
            }

            if (extraLen > 0) {
                regions.push(r(off + 30 + nameLen, off + 29 + nameLen + extraLen, 'metadata', 'Extra Field', 'metadata',
                    'Extra field data (' + extraLen + ' bytes)'));
            }

            var dataOff = off + 30 + nameLen + extraLen;
            if (compSize > 0 && dataOff < d.length) {
                var dataEnd = Math.min(dataOff + compSize - 1, d.length - 1);
                regions.push(r(dataOff, dataEnd, 'compressed', 'Compressed Data', 'compressed',
                    'Compressed data for "' + fileName + '" (' + compSize + ' bytes)'));
            }

            off = dataOff + compSize;
            fileNum++;
        }

        // Central directory
        var cdStart = off;
        var cdCount = 0;
        while (off + 46 <= d.length) {
            var cdSig = readU32LE(d, off);
            if (cdSig !== 0x02014B50) break;

            var cdNameLen = readU16LE(d, off + 28);
            var cdExtraLen = readU16LE(d, off + 30);
            var cdCommentLen = readU16LE(d, off + 32);
            var cdFileName = ascii(d, off + 46, cdNameLen);
            var entryEnd = off + 45 + cdNameLen + cdExtraLen + cdCommentLen;

            regions.push(r(off, Math.min(entryEnd, d.length - 1), 'index', 'Central Dir: ' + cdFileName, 'index',
                'Central directory entry for "' + cdFileName + '"'));

            off = entryEnd + 1;
            cdCount++;
            if (cdCount > 500) break;
        }

        // EOCD
        if (off + 22 <= d.length && readU32LE(d, off) === 0x06054B50) {
            regions.push(r(off, Math.min(off + 21, d.length - 1), 'header', 'End of Central Directory', 'header',
                'EOCD record \u2014 ' + cdCount + ' entries in archive'));
        }

        return regions;
    };

    // ===== ELF =====
    HexFormats.parseELF = function(d) {
        var regions = [];
        if (d.length < 16) return regions;

        regions.push(r(0, 3, 'magic', 'ELF Magic', 'magic', '7F 45 4C 46 \u2014 ELF file signature'));

        var is64 = d[4] === 2;
        var isLE = d[5] === 1;
        var classNames = { 1: '32-bit', 2: '64-bit' };
        var endianNames = { 1: 'Little-endian', 2: 'Big-endian' };
        var typeNames = { 1: 'Relocatable', 2: 'Executable', 3: 'Shared object', 4: 'Core' };

        var readU16 = isLE ? readU16LE : readU16BE;
        var readU32 = isLE ? readU32LE : readU32BE;

        regions.push(r(4, 15, 'metadata', 'ELF Identification', 'metadata',
            'ELF class, encoding, version, OS/ABI', [
                'Class: ' + (classNames[d[4]] || 'Unknown'),
                'Data: ' + (endianNames[d[5]] || 'Unknown'),
                'Version: ' + d[6],
                'OS/ABI: ' + d[7]
            ]));

        var ehdrSize = is64 ? 64 : 52;
        if (d.length < ehdrSize) return regions;

        var eType = readU16(d, 16);
        var eMachine = readU16(d, 18);

        var machineNames = { 3: 'x86', 0x3E: 'x86-64', 0x28: 'ARM', 0xB7: 'AArch64', 8: 'MIPS', 0xF3: 'RISC-V' };

        regions.push(r(16, ehdrSize - 1, 'header', 'ELF Header', 'header',
            'Main ELF header fields', [
                'Type: ' + (typeNames[eType] || '0x' + eType.toString(16)),
                'Machine: ' + (machineNames[eMachine] || '0x' + eMachine.toString(16))
            ]));

        // Program headers
        var phOff, phSize, phNum;
        if (is64) {
            phOff = readU32(d, 32); // simplified: only lower 32 bits
            phSize = readU16(d, 54);
            phNum = readU16(d, 56);
        } else {
            phOff = readU32(d, 28);
            phSize = readU16(d, 42);
            phNum = readU16(d, 44);
        }

        if (phOff > 0 && phNum > 0 && phOff + phSize * phNum <= d.length) {
            regions.push(r(phOff, phOff + phSize * phNum - 1, 'header', 'Program Headers', 'header',
                phNum + ' program header entries (' + phSize + ' bytes each)'));
        }

        // Section headers
        var shOff, shSize, shNum;
        if (is64) {
            shOff = readU32(d, 40);
            shSize = readU16(d, 58);
            shNum = readU16(d, 60);
        } else {
            shOff = readU32(d, 32);
            shSize = readU16(d, 46);
            shNum = readU16(d, 48);
        }

        if (shOff > 0 && shNum > 0 && shOff + shSize * shNum <= d.length) {
            regions.push(r(shOff, shOff + shSize * shNum - 1, 'index', 'Section Headers', 'index',
                shNum + ' section header entries (' + shSize + ' bytes each)'));
        }

        return regions;
    };

    // ===== PE (Windows EXE/DLL) =====
    HexFormats.parsePE = function(d) {
        var regions = [];
        if (d.length < 64) return regions;

        regions.push(r(0, 1, 'magic', 'MZ Signature', 'magic', '4D 5A \u2014 DOS executable signature'));
        regions.push(r(2, 59, 'header', 'DOS Header', 'header', 'DOS MZ header fields'));

        var peOff = readU32LE(d, 60);
        regions.push(r(60, 63, 'metadata', 'PE Offset', 'metadata', 'Pointer to PE header at 0x' + peOff.toString(16).toUpperCase()));

        if (peOff > 64 && peOff < d.length) {
            regions.push(r(64, peOff - 1, 'data', 'DOS Stub', 'data', 'DOS stub program \u2014 "This program cannot be run in DOS mode"'));
        }

        if (peOff + 4 > d.length) return regions;

        regions.push(r(peOff, peOff + 3, 'magic', 'PE Signature', 'magic', '50 45 00 00 \u2014 PE\\0\\0 signature'));

        if (peOff + 24 > d.length) return regions;

        var machine = readU16LE(d, peOff + 4);
        var numSections = readU16LE(d, peOff + 6);
        var machineNames = { 0x14C: 'i386', 0x8664: 'x86-64', 0xAA64: 'ARM64' };

        regions.push(r(peOff + 4, peOff + 23, 'header', 'COFF Header', 'header',
            'COFF file header', [
                'Machine: ' + (machineNames[machine] || '0x' + machine.toString(16)),
                'Sections: ' + numSections
            ]));

        var optSize = readU16LE(d, peOff + 20);
        if (optSize > 0 && peOff + 24 + optSize <= d.length) {
            var magic = readU16LE(d, peOff + 24);
            var isPE32Plus = magic === 0x20B;
            regions.push(r(peOff + 24, peOff + 23 + optSize, 'metadata', 'Optional Header', 'metadata',
                (isPE32Plus ? 'PE32+' : 'PE32') + ' optional header (' + optSize + ' bytes)'));
        }

        // Section table
        var sectOff = peOff + 24 + optSize;
        for (var s = 0; s < numSections && sectOff + 40 <= d.length; s++) {
            var name = ascii(d, sectOff, 8).replace(/\0/g, '');
            regions.push(r(sectOff, sectOff + 39, 'index', 'Section: ' + name, 'index',
                'Section table entry for "' + name + '"'));
            sectOff += 40;
        }

        return regions;
    };

    // ===== DER (ASN.1) =====
    HexFormats.parseDER = function(d) {
        var regions = [];
        parseDERRecursive(d, 0, d.length, regions, 0);
        return regions;
    };

    function parseDERRecursive(d, offset, end, regions, depth) {
        if (depth > 20) return offset;
        var pos = offset;

        while (pos < end && pos + 2 <= d.length) {
            var tagStart = pos;
            var tag = d[pos++];
            if (pos >= end) break;

            // Length
            var lenByte = d[pos++];
            var len = 0;
            var lenEnd = pos;
            if (lenByte < 0x80) {
                len = lenByte;
            } else {
                var numLenBytes = lenByte & 0x7F;
                if (numLenBytes > 4 || pos + numLenBytes > end) break;
                for (var lb = 0; lb < numLenBytes; lb++) {
                    len = (len << 8) | d[pos++];
                }
                lenEnd = pos;
            }

            if (len < 0 || pos + len > d.length) break;

            var tagClass = (tag >> 6) & 3;
            var constructed = (tag >> 5) & 1;
            var tagNum = tag & 0x1F;

            var tagNames = {
                0x01: 'BOOLEAN', 0x02: 'INTEGER', 0x03: 'BIT STRING', 0x04: 'OCTET STRING',
                0x05: 'NULL', 0x06: 'OID', 0x0C: 'UTF8String', 0x13: 'PrintableString',
                0x16: 'IA5String', 0x17: 'UTCTime', 0x18: 'GeneralizedTime',
                0x30: 'SEQUENCE', 0x31: 'SET'
            };

            var label = tagNames[tag] || (constructed ? 'CONSTRUCTED [' + tagNum + ']' : 'PRIMITIVE [' + tagNum + ']');
            if (tagClass === 2) label = 'CONTEXT [' + tagNum + ']';

            // Tag+Length
            regions.push(r(tagStart, lenEnd - 1, 'header', label + ' (TL)', 'header',
                'Tag: 0x' + tag.toString(16).toUpperCase() + ', Length: ' + len));

            // Value
            if (len > 0) {
                if (constructed || tag === 0x30 || tag === 0x31 || (tagClass === 2 && constructed)) {
                    parseDERRecursive(d, lenEnd, lenEnd + len, regions, depth + 1);
                } else if (tag === 0x06) {
                    // OID
                    regions.push(r(lenEnd, lenEnd + len - 1, 'metadata', 'OID Value', 'metadata',
                        'Object Identifier (' + len + ' bytes)'));
                } else if (tag === 0x02) {
                    regions.push(r(lenEnd, lenEnd + len - 1, 'data', 'INTEGER Value', 'data',
                        'Integer (' + len + ' bytes)'));
                } else if (tag === 0x03) {
                    regions.push(r(lenEnd, lenEnd + len - 1, 'data', 'BIT STRING Value', 'data',
                        'Bit string (' + len + ' bytes)'));
                } else if (tag === 0x04) {
                    // Could contain nested DER
                    if (len > 2 && (d[lenEnd] === 0x30 || d[lenEnd] === 0x31)) {
                        parseDERRecursive(d, lenEnd, lenEnd + len, regions, depth + 1);
                    } else {
                        regions.push(r(lenEnd, lenEnd + len - 1, 'data', 'OCTET STRING Value', 'data',
                            'Octet string (' + len + ' bytes)'));
                    }
                } else if (tag === 0x13 || tag === 0x0C || tag === 0x16) {
                    var strVal = ascii(d, lenEnd, Math.min(len, 64));
                    regions.push(r(lenEnd, lenEnd + len - 1, 'string', label + ': ' + strVal, 'string',
                        'String value: "' + strVal + '"'));
                } else if (tag === 0x17 || tag === 0x18) {
                    var timeVal = ascii(d, lenEnd, len);
                    regions.push(r(lenEnd, lenEnd + len - 1, 'string', 'Time: ' + timeVal, 'string',
                        'Time value: ' + timeVal));
                } else {
                    regions.push(r(lenEnd, lenEnd + len - 1, 'data', label + ' Value', 'data',
                        label + ' value (' + len + ' bytes)'));
                }
            }

            pos = lenEnd + len;
        }
        return pos;
    }

    // ===== PEM =====
    HexFormats.parsePEM = function(d) {
        var regions = [];
        // Use raw conversion (preserve newlines, unlike ascii() which replaces them)
        var text = '';
        for (var ri = 0; ri < d.length; ri++) text += String.fromCharCode(d[ri]);

        // Find -----BEGIN
        var beginIdx = text.indexOf('-----BEGIN');
        if (beginIdx < 0) return regions;

        var beginLineEnd = text.indexOf('\n', beginIdx);
        if (beginLineEnd < 0) beginLineEnd = text.indexOf('\r', beginIdx);
        if (beginLineEnd < 0) beginLineEnd = d.length - 1;

        var beginLabel = text.substring(beginIdx, beginLineEnd).trim();
        regions.push(r(beginIdx, beginLineEnd, 'header', 'PEM Begin', 'header', beginLabel));

        // Find -----END
        var endIdx = text.indexOf('-----END');
        if (endIdx > 0) {
            // Base64 body
            if (beginLineEnd + 1 < endIdx) {
                regions.push(r(beginLineEnd + 1, endIdx - 1, 'string', 'Base64 Body', 'string',
                    'Base64-encoded DER data (' + (endIdx - beginLineEnd - 1) + ' bytes)'));
            }
            var endLineEnd = text.indexOf('\n', endIdx);
            if (endLineEnd < 0) endLineEnd = d.length - 1;
            regions.push(r(endIdx, Math.min(endLineEnd, d.length - 1), 'header', 'PEM End', 'header',
                text.substring(endIdx, endLineEnd + 1).trim()));
        }

        return regions;
    };

    // ===== JKS (Java KeyStore) =====
    HexFormats.parseJKS = function(d) {
        var regions = [];
        if (d.length < 12) return regions;

        regions.push(r(0, 3, 'magic', 'JKS Magic', 'magic', 'FEEDFEED \u2014 Java KeyStore signature'));
        regions.push(r(4, 7, 'metadata', 'JKS Version', 'metadata', 'Version: ' + readU32BE(d, 4)));

        var entryCount = readU32BE(d, 8);
        regions.push(r(8, 11, 'metadata', 'Entry Count', 'metadata', 'Number of entries: ' + entryCount));

        if (d.length > 32) {
            regions.push(r(12, d.length - 21, 'data', 'KeyStore Entries', 'data',
                entryCount + ' key/certificate entries'));
        }

        if (d.length >= 20) {
            regions.push(r(d.length - 20, d.length - 1, 'checksum', 'Store Digest', 'checksum',
                'SHA-1 integrity digest (20 bytes)'));
        }

        return regions;
    };

    // ===== Tier 2: Section-level parsers =====

    // GIF
    HexFormats.parseGIF = function(d) {
        var regions = [];
        if (d.length < 6) return regions;
        var ver = ascii(d, 0, 6);
        regions.push(r(0, 5, 'magic', 'GIF Header', 'magic', ver + ' \u2014 GIF signature'));
        if (d.length >= 13) {
            var w = readU16LE(d, 6);
            var h = readU16LE(d, 8);
            regions.push(r(6, 12, 'metadata', 'Logical Screen Descriptor', 'metadata',
                'Screen dimensions and color info', ['Width: ' + w + 'px', 'Height: ' + h + 'px']));
        }
        if (d.length > 13) {
            regions.push(r(13, d.length - 1, 'data', 'GIF Image Data', 'data', 'Image data and extensions'));
        }
        return regions;
    };

    // BMP
    HexFormats.parseBMP = function(d) {
        var regions = [];
        if (d.length < 14) return regions;
        var fileSize = readU32LE(d, 2);
        var dataOff = readU32LE(d, 10);
        regions.push(r(0, 1, 'magic', 'BMP Signature', 'magic', '42 4D \u2014 BMP file'));
        regions.push(r(2, 13, 'header', 'BMP File Header', 'header', 'File size: ' + fileSize + ' bytes'));
        if (d.length >= 26) {
            var w = readU32LE(d, 18);
            var h = readU32LE(d, 22);
            var headerSize = readU32LE(d, 14);
            regions.push(r(14, Math.min(13 + headerSize, d.length - 1), 'metadata', 'DIB Header', 'metadata',
                'Bitmap info', ['Width: ' + w + 'px', 'Height: ' + h + 'px']));
        }
        if (dataOff < d.length) {
            regions.push(r(dataOff, d.length - 1, 'data', 'Pixel Data', 'data', 'Bitmap pixel data'));
        }
        return regions;
    };

    // GZIP
    HexFormats.parseGZIP = function(d) {
        var regions = [];
        if (d.length < 10) return regions;
        regions.push(r(0, 1, 'magic', 'GZIP Magic', 'magic', '1F 8B \u2014 GZIP signature'));
        regions.push(r(2, 9, 'header', 'GZIP Header', 'header', 'Compression method, flags, timestamp'));
        if (d.length > 10) {
            var compEnd = Math.max(10, d.length - 9);
            regions.push(r(10, compEnd, 'compressed', 'Compressed Data', 'compressed',
                'Deflate compressed data'));
        }
        if (d.length >= 8) {
            regions.push(r(d.length - 8, d.length - 5, 'checksum', 'CRC-32', 'checksum', 'CRC-32 checksum'));
            regions.push(r(d.length - 4, d.length - 1, 'metadata', 'Original Size', 'metadata',
                'Original uncompressed size (mod 2^32)'));
        }
        return regions;
    };

    // SQLite
    HexFormats.parseSQLite = function(d) {
        var regions = [];
        if (d.length < 100) return regions;
        regions.push(r(0, 15, 'magic', 'SQLite Header', 'magic', 'SQLite format 3\\000'));
        var pageSize = readU16BE(d, 16);
        regions.push(r(16, 99, 'header', 'Database Header', 'header',
            'SQLite database header', ['Page size: ' + (pageSize === 1 ? 65536 : pageSize) + ' bytes']));
        if (d.length > 100) {
            regions.push(r(100, d.length - 1, 'data', 'Database Pages', 'data', 'B-tree pages and data'));
        }
        return regions;
    };

    // Java Class
    HexFormats.parseJavaClass = function(d) {
        var regions = [];
        if (d.length < 10) return regions;
        regions.push(r(0, 3, 'magic', 'Java Magic', 'magic', 'CA FE BA BE \u2014 Java class file'));
        var minor = readU16BE(d, 4);
        var major = readU16BE(d, 6);
        var javaVer = major - 44;
        regions.push(r(4, 7, 'metadata', 'Class Version', 'metadata',
            'Java ' + javaVer + ' (major: ' + major + ', minor: ' + minor + ')'));
        var cpCount = readU16BE(d, 8);
        regions.push(r(8, 9, 'metadata', 'Constant Pool Count', 'metadata', cpCount + ' entries'));
        if (d.length > 10) {
            regions.push(r(10, d.length - 1, 'data', 'Class Data', 'data',
                'Constant pool, methods, fields, and attributes'));
        }
        return regions;
    };

    // WASM
    HexFormats.parseWASM = function(d) {
        var regions = [];
        if (d.length < 8) return regions;
        regions.push(r(0, 3, 'magic', 'WASM Magic', 'magic', '00 61 73 6D \u2014 WebAssembly module'));
        regions.push(r(4, 7, 'metadata', 'WASM Version', 'metadata',
            'Version: ' + readU32LE(d, 4)));
        if (d.length > 8) {
            regions.push(r(8, d.length - 1, 'data', 'WASM Sections', 'data', 'Module sections'));
        }
        return regions;
    };

    // RIFF (WAV/AVI)
    HexFormats.parseRIFF = function(d) {
        var regions = [];
        if (d.length < 12) return regions;
        var fileSize = readU32LE(d, 4);
        var form = ascii(d, 8, 4);
        regions.push(r(0, 3, 'magic', 'RIFF Signature', 'magic', 'RIFF container'));
        regions.push(r(4, 7, 'metadata', 'File Size', 'metadata', 'Size: ' + fileSize + ' bytes'));
        regions.push(r(8, 11, 'header', 'RIFF Type: ' + form, 'header', 'Format: ' + form));
        if (d.length > 12) {
            regions.push(r(12, d.length - 1, 'data', form + ' Data', 'data', form + ' chunks'));
        }
        return regions;
    };

    // MP3 (ID3 + frames)
    HexFormats.parseMP3 = function(d) {
        var regions = [];
        if (d.length < 3) return regions;

        if (d[0] === 0x49 && d[1] === 0x44 && d[2] === 0x33) {
            // ID3v2
            if (d.length >= 10) {
                var tagSize = ((d[6] & 0x7F) << 21) | ((d[7] & 0x7F) << 14) | ((d[8] & 0x7F) << 7) | (d[9] & 0x7F);
                regions.push(r(0, 9, 'header', 'ID3v2 Header', 'header',
                    'ID3v2.' + d[3] + '.' + d[4] + ' tag header'));
                if (tagSize > 0 && tagSize + 10 <= d.length) {
                    regions.push(r(10, 9 + tagSize, 'metadata', 'ID3v2 Tag Data', 'metadata',
                        'ID3 metadata (' + tagSize + ' bytes)'));
                }
                var audioStart = 10 + tagSize;
                if (audioStart < d.length) {
                    regions.push(r(audioStart, d.length - 1, 'compressed', 'Audio Frames', 'compressed',
                        'MP3 audio data'));
                }
            }
        } else {
            regions.push(r(0, 2, 'magic', 'MP3 Frame Sync', 'magic', 'MP3 audio frame'));
            if (d.length > 3) {
                regions.push(r(3, d.length - 1, 'compressed', 'Audio Data', 'compressed', 'MP3 audio frames'));
            }
        }
        return regions;
    };

    // MP4/MOV
    HexFormats.parseMP4 = function(d) {
        var regions = [];
        var off = 0;
        var boxNum = 0;

        while (off + 8 <= d.length && boxNum < 100) {
            var size = readU32BE(d, off);
            var type = ascii(d, off + 4, 4);

            if (size === 0) size = d.length - off;
            if (size < 8 || off + size > d.length + 8) break;

            var color = 'data';
            if (type === 'ftyp') color = 'magic';
            else if (type === 'moov' || type === 'trak' || type === 'mdia') color = 'header';
            else if (type === 'mdat') color = 'compressed';
            else if (type === 'meta' || type === 'udta') color = 'metadata';

            var boxEnd = Math.min(off + size - 1, d.length - 1);
            regions.push(r(off, boxEnd, color, type + ' Box', color,
                type + ' atom (' + size + ' bytes)'));

            off += size;
            boxNum++;
        }
        return regions;
    };

    // Mach-O
    HexFormats.parseMachO = function(d) {
        var regions = [];
        if (d.length < 28) return regions;

        var magic = readU32LE(d, 0);
        var is64 = (magic === 0xFEEDFACF || magic === 0xCFFAEDFE);
        var isSwap = (magic === 0xCEFAEDFE || magic === 0xCFFAEDFE);

        regions.push(r(0, 3, 'magic', 'Mach-O Magic', 'magic',
            (is64 ? '64-bit' : '32-bit') + ' Mach-O'));

        var headerSize = is64 ? 32 : 28;
        regions.push(r(4, headerSize - 1, 'header', 'Mach-O Header', 'header', 'CPU type, file type, load commands'));

        if (d.length > headerSize) {
            regions.push(r(headerSize, d.length - 1, 'data', 'Load Commands & Data', 'data', 'Load commands and segments'));
        }
        return regions;
    };

    // PGP
    HexFormats.parsePGP = function(d) {
        var regions = [];
        if (d.length < 2) return regions;

        var tag = (d[0] & 0x3F) >> 2;
        var tagNames = {
            1: 'Public-Key Encrypted Session Key', 2: 'Signature', 3: 'Symmetric-Key Encrypted Session Key',
            4: 'One-Pass Signature', 5: 'Secret Key', 6: 'Public Key', 7: 'Secret Subkey',
            8: 'Compressed Data', 9: 'Symmetrically Encrypted Data', 10: 'Marker',
            11: 'Literal Data', 12: 'Trust', 13: 'User ID', 14: 'Public Subkey',
            17: 'User Attribute', 18: 'Sym. Encrypted Integrity Protected Data',
            19: 'Modification Detection Code'
        };

        var name = tagNames[tag] || 'PGP Packet (tag ' + tag + ')';
        regions.push(r(0, 0, 'magic', 'PGP Packet Tag', 'magic', 'Tag: ' + name));

        if (d.length > 1) {
            regions.push(r(1, d.length - 1, 'data', name + ' Body', 'data', 'PGP packet data'));
        }
        return regions;
    };

    // PKCS#12
    HexFormats.parsePKCS12 = function(d) {
        // PKCS#12 is DER-encoded, delegate to DER parser
        return HexFormats.parseDER(d);
    };

    // TAR
    HexFormats.parseTAR = function(d) {
        var regions = [];
        var off = 0;
        var fileNum = 0;

        while (off + 512 <= d.length && fileNum < 200) {
            // Check if block is all zeros (end of archive)
            var allZero = true;
            for (var z = 0; z < 512 && allZero; z++) {
                if (d[off + z] !== 0) allZero = false;
            }
            if (allZero) {
                regions.push(r(off, off + 511, 'padding', 'End-of-Archive Block', 'padding', 'Zero-filled block'));
                break;
            }

            var name = ascii(d, off, 100).replace(/\0/g, '');
            regions.push(r(off, off + 155, 'header', 'TAR Header: ' + name, 'header', 'File entry header'));

            // Checksum at 148-155
            regions.push(r(off + 148, off + 155, 'checksum', 'Header Checksum', 'checksum', 'Header checksum'));

            // ustar magic at 257-262
            if (ascii(d, off + 257, 5) === 'ustar') {
                regions.push(r(off + 257, off + 262, 'magic', 'ustar Magic', 'magic', 'POSIX ustar format'));
            }

            // Parse file size (octal string at offset 124, 12 bytes)
            var sizeStr = ascii(d, off + 124, 12).replace(/\0/g, '').trim();
            var fileSize = parseInt(sizeStr, 8) || 0;

            var dataStart = off + 512;
            var dataBlocks = Math.ceil(fileSize / 512);
            if (fileSize > 0 && dataStart < d.length) {
                var dataEnd = Math.min(dataStart + dataBlocks * 512 - 1, d.length - 1);
                regions.push(r(dataStart, dataEnd, 'data', 'File Data: ' + name, 'data',
                    'File content (' + fileSize + ' bytes)'));
            }

            off = dataStart + dataBlocks * 512;
            fileNum++;
        }
        return regions;
    };

    // ===== Tier 3: Generic =====
    HexFormats.parseGeneric = function(d) {
        return [];
    };

    window.HexFormats = HexFormats;
})();
