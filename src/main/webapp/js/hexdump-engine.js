/* hexdump-engine.js — Pure computation module (no DOM)
   Exposes: window.HexEngine */
(function() {
    'use strict';

    var HexEngine = {};

    /**
     * Format a single byte in the given base.
     * @param {number} byte - 0..255
     * @param {string} format - 'hex' | 'dec' | 'oct' | 'bin'
     * @returns {string}
     */
    HexEngine.formatByte = function(byte, format) {
        switch (format) {
            case 'dec': return ('  ' + byte.toString(10)).slice(-3);
            case 'oct': return ('00' + byte.toString(8)).slice(-3);
            case 'bin': return ('0000000' + byte.toString(2)).slice(-8);
            default:    return ('0' + byte.toString(16).toUpperCase()).slice(-2);
        }
    };

    /**
     * Format an offset address (8-char hex).
     * @param {number} offset
     * @param {number} totalLen - total data length (unused, reserved)
     * @returns {string}
     */
    HexEngine.formatOffset = function(offset, totalLen) {
        var s = offset.toString(16).toUpperCase();
        while (s.length < 8) s = '0' + s;
        return s;
    };

    /**
     * Get the printable ASCII character or '.'.
     * @param {number} byte
     * @returns {string}
     */
    HexEngine.getAsciiChar = function(byte) {
        return (byte >= 32 && byte <= 126) ? String.fromCharCode(byte) : '.';
    };

    /**
     * Calculate file statistics.
     * @param {Uint8Array} data
     * @returns {Object} stats
     */
    HexEngine.calculateStats = function(data) {
        var totalBytes = data.length;
        var printable = 0;
        var nullBytes = 0;
        var byteFreq = new Array(256);
        var i;

        for (i = 0; i < 256; i++) byteFreq[i] = 0;

        for (i = 0; i < totalBytes; i++) {
            var b = data[i];
            byteFreq[b]++;
            if (b >= 32 && b <= 126) printable++;
            if (b === 0) nullBytes++;
        }

        var uniqueBytes = 0;
        for (i = 0; i < 256; i++) {
            if (byteFreq[i] > 0) uniqueBytes++;
        }

        // Shannon entropy
        var entropy = 0;
        for (i = 0; i < 256; i++) {
            if (byteFreq[i] > 0) {
                var p = byteFreq[i] / totalBytes;
                entropy -= p * (Math.log(p) / Math.LN2);
            }
        }

        return {
            totalBytes: totalBytes,
            printable: printable,
            nullBytes: nullBytes,
            uniqueBytes: uniqueBytes,
            entropy: entropy,
            byteFreq: byteFreq
        };
    };

    /**
     * Search for a byte pattern in data.
     * @param {Uint8Array} data
     * @param {Array<number>} patternBytes
     * @returns {Array<number>} array of match start indices
     */
    HexEngine.searchPattern = function(data, patternBytes) {
        var matches = [];
        if (!patternBytes || patternBytes.length === 0 || !data || data.length === 0) return matches;

        var pLen = patternBytes.length;
        for (var i = 0; i <= data.length - pLen; i++) {
            var match = true;
            for (var j = 0; j < pLen; j++) {
                if (data[i + j] !== patternBytes[j]) {
                    match = false;
                    break;
                }
            }
            if (match) matches.push(i);
        }
        return matches;
    };

    /**
     * Parse a hex input string like "48 65 6C 6C 6F" into Uint8Array.
     * @param {string} str
     * @returns {Uint8Array}
     */
    HexEngine.parseHexInput = function(str) {
        var cleaned = str.replace(/[^0-9a-fA-F\s]/g, '').trim();
        if (!cleaned) return new Uint8Array(0);

        var tokens = cleaned.split(/\s+/);
        var bytes = [];
        for (var i = 0; i < tokens.length; i++) {
            var token = tokens[i];
            // If token is more than 2 chars, split into pairs
            if (token.length > 2) {
                for (var j = 0; j < token.length; j += 2) {
                    var pair = token.substring(j, Math.min(j + 2, token.length));
                    var val = parseInt(pair, 16);
                    if (!isNaN(val)) bytes.push(val);
                }
            } else {
                var val2 = parseInt(token, 16);
                if (!isNaN(val2)) bytes.push(val2);
            }
        }
        return new Uint8Array(bytes);
    };

    /**
     * Export data as a C array string.
     * @param {Uint8Array} data
     * @param {string} name - variable name
     * @returns {string}
     */
    HexEngine.exportAsC = function(data, name) {
        var safeName = (name || 'data').replace(/[^a-zA-Z0-9_]/g, '_');
        var lines = ['unsigned char ' + safeName + '[] = {'];
        var perLine = 12;
        for (var i = 0; i < data.length; i += perLine) {
            var chunk = [];
            for (var j = i; j < Math.min(i + perLine, data.length); j++) {
                chunk.push('0x' + ('0' + data[j].toString(16).toUpperCase()).slice(-2));
            }
            var comma = (i + perLine < data.length) ? ',' : '';
            lines.push('    ' + chunk.join(', ') + comma);
        }
        lines.push('};');
        lines.push('unsigned int ' + safeName + '_len = ' + data.length + ';');
        return lines.join('\n');
    };

    /**
     * Export data as Python bytes.
     * @param {Uint8Array} data
     * @param {string} name
     * @returns {string}
     */
    HexEngine.exportAsPython = function(data, name) {
        var safeName = (name || 'data').replace(/[^a-zA-Z0-9_]/g, '_');
        var lines = [safeName + ' = bytes(['];
        var perLine = 12;
        for (var i = 0; i < data.length; i += perLine) {
            var chunk = [];
            for (var j = i; j < Math.min(i + perLine, data.length); j++) {
                chunk.push('0x' + ('0' + data[j].toString(16).toUpperCase()).slice(-2));
            }
            var comma = (i + perLine < data.length) ? ',' : '';
            lines.push('    ' + chunk.join(', ') + comma);
        }
        lines.push('])');
        lines.push('# Length: ' + data.length + ' bytes');
        return lines.join('\n');
    };

    /**
     * Export data as Go byte slice.
     * @param {Uint8Array} data
     * @param {string} name
     * @returns {string}
     */
    HexEngine.exportAsGo = function(data, name) {
        var safeName = (name || 'data').replace(/[^a-zA-Z0-9_]/g, '_');
        // Capitalize first letter for Go export
        var goName = safeName.charAt(0).toUpperCase() + safeName.slice(1);
        var lines = ['var ' + goName + ' = []byte{'];
        var perLine = 12;
        for (var i = 0; i < data.length; i += perLine) {
            var chunk = [];
            for (var j = i; j < Math.min(i + perLine, data.length); j++) {
                chunk.push('0x' + ('0' + data[j].toString(16).toUpperCase()).slice(-2));
            }
            lines.push('\t' + chunk.join(', ') + ',');
        }
        lines.push('}');
        lines.push('// Length: ' + data.length + ' bytes');
        return lines.join('\n');
    };

    /**
     * Export data as Rust byte slice.
     * @param {Uint8Array} data
     * @param {string} name
     * @returns {string}
     */
    HexEngine.exportAsRust = function(data, name) {
        var safeName = (name || 'data').replace(/[^a-zA-Z0-9_]/g, '_').toUpperCase();
        var lines = ['const ' + safeName + ': &[u8] = &['];
        var perLine = 12;
        for (var i = 0; i < data.length; i += perLine) {
            var chunk = [];
            for (var j = i; j < Math.min(i + perLine, data.length); j++) {
                chunk.push('0x' + ('0' + data[j].toString(16).toUpperCase()).slice(-2));
            }
            var comma = (i + perLine < data.length) ? ',' : '';
            lines.push('    ' + chunk.join(', ') + comma);
        }
        lines.push('];');
        lines.push('// Length: ' + data.length + ' bytes');
        return lines.join('\n');
    };

    /**
     * Get all representations of a byte.
     * @param {number} byte
     * @returns {Object}
     */
    HexEngine.getByteInfo = function(byte) {
        var signed = byte > 127 ? byte - 256 : byte;
        var ch = (byte >= 32 && byte <= 126) ? String.fromCharCode(byte) : 'N/A';
        var charName = '';
        if (byte === 0) charName = 'NUL';
        else if (byte === 9) charName = 'TAB';
        else if (byte === 10) charName = 'LF (\\n)';
        else if (byte === 13) charName = 'CR (\\r)';
        else if (byte === 32) charName = 'SPACE';
        else if (byte === 127) charName = 'DEL';
        else if (byte < 32) charName = 'CTRL-' + String.fromCharCode(64 + byte);
        else charName = ch;

        return {
            dec: byte.toString(10),
            hex: '0x' + ('0' + byte.toString(16).toUpperCase()).slice(-2),
            oct: '0o' + ('00' + byte.toString(8)).slice(-3),
            bin: ('0000000' + byte.toString(2)).slice(-8),
            char: charName,
            signed: signed.toString(10),
            unsigned: byte.toString(10)
        };
    };

    /**
     * Format file size for display.
     * @param {number} bytes
     * @returns {string}
     */
    HexEngine.formatFileSize = function(bytes) {
        if (bytes < 1024) return bytes + ' B';
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
        return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
    };

    window.HexEngine = HexEngine;
})();
