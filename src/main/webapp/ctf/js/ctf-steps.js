/**
 * CTF Steganography Engine - Step Implementations
 * Each step has encode(input, params) and decode(input, params).
 * Input/output: string (UTF-8 text or base64/latin1 for binary).
 */
(function(global) {
'use strict';

var steps = {};

/* ========== base64 ========== */
steps.base64 = {
    encode: function(input, params) {
        if (typeof input !== 'string') input = new TextDecoder().decode(input);
        var bytes = new TextEncoder().encode(input);
        var binary = '';
        for (var i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);
        return btoa(binary);
    },
    decode: function(input, params) {
        try {
            var binary = atob(input);
            var bytes = new Uint8Array(binary.length);
            for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
            return new TextDecoder().decode(bytes);
        } catch (e) {
            throw new Error('base64 decode failed: ' + e.message);
        }
    }
};

/* ========== hex ========== */
function bytesToHex(bytes) {
    if (typeof bytes === 'string') bytes = new TextEncoder().encode(bytes);
    var hex = '';
    for (var i = 0; i < bytes.length; i++) {
        var h = bytes[i].toString(16);
        hex += (h.length === 1 ? '0' : '') + h;
    }
    return hex;
}

function hexToBytes(hex) {
    hex = hex.replace(/\s/g, '');
    if (hex.length % 2 !== 0) throw new Error('Invalid hex length');
    var bytes = new Uint8Array(hex.length / 2);
    for (var i = 0; i < bytes.length; i++) {
        bytes[i] = parseInt(hex.substr(i * 2, 2), 16);
    }
    return bytes;
}

steps.hex = {
    encode: function(input, params) {
        if (typeof input !== 'string') input = new TextDecoder().decode(input);
        var bytes = new TextEncoder().encode(input);
        return bytesToHex(bytes);
    },
    decode: function(input, params) {
        var bytes = hexToBytes(input);
        return new TextDecoder().decode(bytes);
    }
};

/* ========== doubleBase64 ========== */
steps.doubleBase64 = {
    encode: function(input, params) {
        return steps.base64.encode(steps.base64.encode(input, params), params);
    },
    decode: function(input, params) {
        return steps.base64.decode(steps.base64.decode(input, params), params);
    }
};

/* ========== doubleHex ========== */
steps.doubleHex = {
    encode: function(input, params) {
        return steps.hex.encode(steps.hex.encode(input, params), params);
    },
    decode: function(input, params) {
        return steps.hex.decode(steps.hex.decode(input, params), params);
    }
};

/* ========== base64Hex (base64 then hex) ========== */
steps.base64Hex = {
    encode: function(input, params) {
        return steps.hex.encode(steps.base64.encode(input, params), params);
    },
    decode: function(input, params) {
        return steps.base64.decode(steps.hex.decode(input, params), params);
    }
};

/* ========== hexBase64 (hex then base64) ========== */
steps.hexBase64 = {
    encode: function(input, params) {
        return steps.base64.encode(steps.hex.encode(input, params), params);
    },
    decode: function(input, params) {
        return steps.hex.decode(steps.base64.decode(input, params), params);
    }
};

/* ========== xor ========== */
steps.xor = {
    encode: function(input, params) {
        var key = (params && params.key) || '';
        if (!key) return input;
        if (typeof input !== 'string') input = new TextDecoder().decode(input);
        var bytes = new TextEncoder().encode(input);
        var keyBytes = new TextEncoder().encode(key);
        var out = new Uint8Array(bytes.length);
        for (var i = 0; i < bytes.length; i++) {
            out[i] = bytes[i] ^ keyBytes[i % keyBytes.length];
        }
        var binary = '';
        for (var j = 0; j < out.length; j++) binary += String.fromCharCode(out[j]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var key = (params && params.key) || '';
        if (!key) return input;
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var keyBytes = new TextEncoder().encode(key);
        var out = new Uint8Array(bytes.length);
        for (var j = 0; j < bytes.length; j++) {
            out[j] = bytes[j] ^ keyBytes[j % keyBytes.length];
        }
        return new TextDecoder().decode(out);
    }
};

/* ========== reverse ========== */
steps.reverse = {
    encode: function(input, params) {
        if (typeof input !== 'string') input = new TextDecoder().decode(input);
        var bytes = new TextEncoder().encode(input);
        var out = new Uint8Array(bytes.length);
        for (var i = 0; i < bytes.length; i++) out[i] = bytes[bytes.length - 1 - i];
        var binary = '';
        for (var j = 0; j < out.length; j++) binary += String.fromCharCode(out[j]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var out = new Uint8Array(bytes.length);
        for (var j = 0; j < bytes.length; j++) out[j] = bytes[bytes.length - 1 - j];
        return new TextDecoder().decode(out);
    }
};

/* ========== rot13 ========== */
steps.rot13 = {
    encode: function(input, params) {
        var s = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) c = ((c - 65 + 13) % 26) + 65;
            else if (c >= 97 && c <= 122) c = ((c - 97 + 13) % 26) + 97;
            s += String.fromCharCode(c);
        }
        return s;
    },
    decode: function(input, params) {
        return steps.rot13.encode(input, params);
    }
};

/* ========== rot47 - ROT13 extended to printable ASCII 33-126 ========== */
steps.rot47 = {
    encode: function(input, params) {
        var s = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 33 && c <= 126) c = ((c - 33 + 47) % 94) + 33;
            s += String.fromCharCode(c);
        }
        return s;
    },
    decode: function(input, params) {
        return steps.rot47.encode(input, params);
    }
};

/* ========== base32 (RFC 4648) ========== */
var B32_ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
steps.base32 = {
    encode: function(input, params) {
        var bytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var out = '', bits = 0, value = 0;
        for (var i = 0; i < bytes.length; i++) {
            value = (value << 8) | bytes[i];
            bits += 8;
            while (bits >= 5) {
                bits -= 5;
                out += B32_ALPHA[(value >>> bits) & 31];
            }
        }
        if (bits > 0) out += B32_ALPHA[(value << (5 - bits)) & 31];
        while (out.length % 8 !== 0) out += '=';
        return out;
    },
    decode: function(input, params) {
        var str = input.replace(/=+$/, '').toUpperCase();
        var bits = 0, value = 0, bytes = [];
        for (var i = 0; i < str.length; i++) {
            var idx = B32_ALPHA.indexOf(str[i]);
            if (idx < 0) continue;
            value = (value << 5) | idx;
            bits += 5;
            if (bits >= 8) {
                bits -= 8;
                bytes.push((value >>> bits) & 0xFF);
            }
        }
        return new TextDecoder().decode(new Uint8Array(bytes));
    }
};

/* ========== octal - ASCII as octal values ========== */
steps.octal = {
    encode: function(input, params) {
        var bytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var out = [];
        for (var i = 0; i < bytes.length; i++) out.push(bytes[i].toString(8));
        return out.join(' ');
    },
    decode: function(input, params) {
        var groups = input.trim().split(/\s+/);
        var bytes = new Uint8Array(groups.length);
        for (var i = 0; i < groups.length; i++) bytes[i] = parseInt(groups[i], 8);
        return new TextDecoder().decode(bytes);
    }
};

/* ========== decimal - ASCII as decimal values ========== */
steps.decimal = {
    encode: function(input, params) {
        var bytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var out = [];
        for (var i = 0; i < bytes.length; i++) out.push(bytes[i].toString(10));
        return out.join(' ');
    },
    decode: function(input, params) {
        var groups = input.trim().split(/\s+/);
        var bytes = new Uint8Array(groups.length);
        for (var i = 0; i < groups.length; i++) bytes[i] = parseInt(groups[i], 10);
        return new TextDecoder().decode(bytes);
    }
};

/* ========== bacon - Bacon's cipher (A=aaaaa, B=aaaab, ...) ========== */
var BACON_MAP = {};
var BACON_REV = {};
(function() {
    var alpha = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
    for (var i = 0; i < 25; i++) {
        var code = '';
        for (var b = 4; b >= 0; b--) code += ((i >> b) & 1) ? 'b' : 'a';
        BACON_MAP[alpha[i]] = code;
        BACON_REV[code] = alpha[i];
    }
    BACON_MAP['J'] = BACON_MAP['I'];
})();

steps.bacon = {
    encode: function(input, params) {
        var s = input.toUpperCase();
        var out = [];
        for (var i = 0; i < s.length; i++) {
            var ch = s[i];
            if (BACON_MAP[ch]) out.push(BACON_MAP[ch]);
            else if (ch === ' ') out.push(' ');
        }
        return out.join(' ');
    },
    decode: function(input, params) {
        var clean = input.replace(/[^abAB ]/g, '').toLowerCase();
        var groups = clean.split(/\s+/).filter(function(g) { return g.length === 5; });
        var out = '';
        for (var i = 0; i < groups.length; i++) {
            out += BACON_REV[groups[i]] || '?';
        }
        return out;
    }
};

/* ========== polybius - Polybius square (letters → digit pairs) ========== */
steps.polybius = {
    encode: function(input, params) {
        var grid = (params && params.grid) || 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
        var s = input.toUpperCase().replace(/J/g, 'I');
        var out = [];
        for (var i = 0; i < s.length; i++) {
            var idx = grid.indexOf(s[i]);
            if (idx >= 0) {
                out.push('' + (Math.floor(idx / 5) + 1) + ((idx % 5) + 1));
            } else if (s[i] === ' ') {
                out.push(' ');
            }
        }
        return out.join(' ');
    },
    decode: function(input, params) {
        var grid = (params && params.grid) || 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
        var tokens = input.trim().split(/\s+/);
        var out = '';
        for (var i = 0; i < tokens.length; i++) {
            var t = tokens[i];
            if (t.length === 2) {
                var r = parseInt(t[0], 10) - 1;
                var c = parseInt(t[1], 10) - 1;
                if (r >= 0 && r < 5 && c >= 0 && c < 5) out += grid[r * 5 + c];
            } else if (t === '') {
                out += ' ';
            }
        }
        return out;
    }
};

/* ========== columnarTransposition - reorder columns by keyword ========== */
steps.columnarTransposition = {
    encode: function(input, params) {
        var key = ((params && params.key) || 'CRYPTO').toUpperCase();
        var order = _colOrder(key);
        var cols = key.length;
        var rows = Math.ceil(input.length / cols);
        var padded = input;
        while (padded.length < rows * cols) padded += '\x00';
        var grid = [];
        for (var r = 0; r < rows; r++) grid.push(padded.substring(r * cols, (r + 1) * cols));
        var out = '';
        for (var c = 0; c < cols; c++) {
            var srcCol = order.indexOf(c);
            for (var r = 0; r < rows; r++) out += grid[r][srcCol];
        }
        return out;
    },
    decode: function(input, params) {
        var key = ((params && params.key) || 'CRYPTO').toUpperCase();
        var order = _colOrder(key);
        var cols = key.length;
        var rows = Math.ceil(input.length / cols);
        var colData = [];
        var pos = 0;
        for (var c = 0; c < cols; c++) {
            colData[c] = input.substring(pos, pos + rows);
            pos += rows;
        }
        var out = '';
        for (var r = 0; r < rows; r++) {
            for (var c = 0; c < cols; c++) {
                var srcCol = order[c];
                out += colData[srcCol][r] || '';
            }
        }
        return out.replace(/\x00+$/, '');
    }
};

function _colOrder(key) {
    var indexed = [];
    for (var i = 0; i < key.length; i++) indexed.push({ ch: key[i], i: i });
    indexed.sort(function(a, b) { return a.ch < b.ch ? -1 : a.ch > b.ch ? 1 : a.i - b.i; });
    var order = new Array(key.length);
    for (var i = 0; i < indexed.length; i++) order[indexed[i].i] = i;
    return order;
}

/* ========== substitution - general monoalphabetic substitution cipher ========== */
steps.substitution = {
    encode: function(input, params) {
        var key = ((params && params.alphabet) || 'QWERTYUIOPASDFGHJKLZXCVBNM').toUpperCase();
        if (key.length !== 26) throw new Error('substitution key must be 26 unique letters');
        var s = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) s += key[c - 65];
            else if (c >= 97 && c <= 122) s += key[c - 97].toLowerCase();
            else s += input[i];
        }
        return s;
    },
    decode: function(input, params) {
        var key = ((params && params.alphabet) || 'QWERTYUIOPASDFGHJKLZXCVBNM').toUpperCase();
        if (key.length !== 26) throw new Error('substitution key must be 26 unique letters');
        var s = '';
        for (var i = 0; i < input.length; i++) {
            var c = input[i].toUpperCase();
            var idx = key.indexOf(c);
            if (idx >= 0) {
                var plain = String.fromCharCode(65 + idx);
                s += (input[i] === input[i].toLowerCase()) ? plain.toLowerCase() : plain;
            } else {
                s += input[i];
            }
        }
        return s;
    }
};

/* ========== zipWrap - wrap payload in a minimal ZIP archive ========== */
steps.zipWrap = {
    encode: function(input, params) {
        var filename = (params && params.filename) || 'flag.txt';
        var payloadBytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var fnBytes = new TextEncoder().encode(filename);
        var fnLen = fnBytes.length;
        var dataLen = payloadBytes.length;
        var crc = _crc32zip(payloadBytes);
        var localHeaderSize = 30 + fnLen;
        var centralHeaderSize = 46 + fnLen;
        var eocdSize = 22;
        var totalSize = localHeaderSize + dataLen + centralHeaderSize + eocdSize;
        var zip = new Uint8Array(totalSize);
        var v = new DataView(zip.buffer);
        var pos = 0;
        v.setUint32(pos, 0x04034b50, true); pos += 4;
        v.setUint16(pos, 20, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint32(pos, crc, true); pos += 4;
        v.setUint32(pos, dataLen, true); pos += 4;
        v.setUint32(pos, dataLen, true); pos += 4;
        v.setUint16(pos, fnLen, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        zip.set(fnBytes, pos); pos += fnLen;
        zip.set(payloadBytes, pos); pos += dataLen;
        var centralStart = pos;
        v.setUint32(pos, 0x02014b50, true); pos += 4;
        v.setUint16(pos, 20, true); pos += 2;
        v.setUint16(pos, 20, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint32(pos, crc, true); pos += 4;
        v.setUint32(pos, dataLen, true); pos += 4;
        v.setUint32(pos, dataLen, true); pos += 4;
        v.setUint16(pos, fnLen, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint32(pos, 32, true); pos += 4;
        v.setUint32(pos, 0, true); pos += 4;
        zip.set(fnBytes, pos); pos += fnLen;
        v.setUint32(pos, 0x06054b50, true); pos += 4;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 0, true); pos += 2;
        v.setUint16(pos, 1, true); pos += 2;
        v.setUint16(pos, 1, true); pos += 2;
        v.setUint32(pos, centralHeaderSize, true); pos += 4;
        v.setUint32(pos, centralStart, true); pos += 4;
        v.setUint16(pos, 0, true);
        var binary = '';
        for (var i = 0; i < zip.length; i++) binary += String.fromCharCode(zip[i]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var v = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
        if (v.getUint32(0, true) !== 0x04034b50) throw new Error('Not a valid ZIP archive');
        var fnLen = v.getUint16(26, true);
        var extraLen = v.getUint16(28, true);
        var compSize = v.getUint32(18, true);
        var dataStart = 30 + fnLen + extraLen;
        var payload = bytes.subarray(dataStart, dataStart + compSize);
        return new TextDecoder().decode(payload);
    }
};

function _crc32zip(data) {
    var table = [];
    for (var n = 0; n < 256; n++) {
        var c = n;
        for (var k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
        table[n] = c >>> 0;
    }
    var crc = 0xFFFFFFFF;
    for (var i = 0; i < data.length; i++) crc = table[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
    return (crc ^ 0xFFFFFFFF) >>> 0;
}

/* ========== stringsHide - bury payload among random binary garbage ========== */
steps.stringsHide = {
    encode: function(input, params) {
        var chunkCount = (params && params.chunkCount) || 8;
        var marker = (params && params.marker) || 'STEG_FLAG';
        var payloadBytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var blocks = [];
        for (var i = 0; i < chunkCount; i++) {
            var garbageLen = 40 + Math.floor(Math.random() * 80);
            var garbage = new Uint8Array(garbageLen);
            for (var j = 0; j < garbageLen; j++) {
                garbage[j] = (Math.random() < 0.15) ? (32 + Math.floor(Math.random() * 94)) : Math.floor(Math.random() * 256);
            }
            blocks.push(garbage);
        }
        var tagged = new TextEncoder().encode(marker + ':' + input + ':' + marker);
        var insertIdx = Math.floor(Math.random() * (blocks.length + 1));
        blocks.splice(insertIdx, 0, tagged);
        var totalLen = 0;
        for (var i = 0; i < blocks.length; i++) totalLen += blocks[i].length + 1;
        var out = new Uint8Array(totalLen);
        var pos = 0;
        for (var i = 0; i < blocks.length; i++) {
            out.set(blocks[i], pos);
            pos += blocks[i].length;
            out[pos++] = 0;
        }
        var binary = '';
        for (var i = 0; i < out.length; i++) binary += String.fromCharCode(out[i]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var marker = (params && params.marker) || 'STEG_FLAG';
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var text = new TextDecoder('utf-8', { fatal: false }).decode(bytes);
        var re = new RegExp(marker.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ':(.+?):' + marker.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
        var match = text.match(re);
        if (!match) throw new Error('stringsHide: payload marker not found (run `strings` on the binary)');
        return match[1];
    }
};

/* ========== morse ========== */
var MORSE_TABLE = {
    'A':'.-','B':'-...','C':'-.-.','D':'-..','E':'.','F':'..-.','G':'--.','H':'....',
    'I':'..','J':'.---','K':'-.-','L':'.-..','M':'--','N':'-.','O':'---','P':'.--.',
    'Q':'--.-','R':'.-.','S':'...','T':'-','U':'..-','V':'...-','W':'.--','X':'-..-',
    'Y':'-.--','Z':'--..','0':'-----','1':'.----','2':'..---','3':'...--','4':'....-',
    '5':'.....','6':'-....','7':'--...','8':'---..','9':'----.','!':'-.-.--','.':'.-.-.-',
    ',':'--..--','?':'..--..','\'':'.----.','!':'-.-.--','/':'-..-.','(':'-.--.',
    ')':'-.--.-','&':'.-...',':':'---...',';':'-.-.-.','=':'-...-','+':'.-.-.',
    '-':'-....-','_':'..--.-','"':'.-..-.','$':'...-..-','@':'.--.-.','#':'..--.-',
    '{':'-.--.', '}':'-.--.-', ' ':' '
};
var MORSE_REV = {};
(function() {
    for (var k in MORSE_TABLE) MORSE_REV[MORSE_TABLE[k]] = k;
})();

steps.morse = {
    encode: function(input, params) {
        if (typeof input !== 'string') input = new TextDecoder().decode(input);
        return input.toUpperCase().split('').map(function(ch) {
            if (ch === ' ') return '/';
            return MORSE_TABLE[ch] || '';
        }).filter(Boolean).join(' ');
    },
    decode: function(input, params) {
        return input.split(' / ').map(function(word) {
            return word.split(' ').map(function(code) {
                return MORSE_REV[code] || '';
            }).join('');
        }).join(' ');
    }
};

/* ========== binary - ASCII as 8-bit binary ========== */
steps.binary = {
    encode: function(input, params) {
        if (typeof input !== 'string') input = new TextDecoder().decode(input);
        var bytes = new TextEncoder().encode(input);
        var out = [];
        for (var i = 0; i < bytes.length; i++) {
            var b = bytes[i].toString(2);
            out.push('00000000'.substring(b.length) + b);
        }
        return out.join(' ');
    },
    decode: function(input, params) {
        var groups = input.trim().split(/\s+/);
        var bytes = new Uint8Array(groups.length);
        for (var i = 0; i < groups.length; i++) {
            bytes[i] = parseInt(groups[i], 2);
        }
        return new TextDecoder().decode(bytes);
    }
};

/* ========== atbash - mirror alphabet (A↔Z, B↔Y, ...) ========== */
steps.atbash = {
    encode: function(input, params) {
        var s = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) s += String.fromCharCode(155 - c);
            else if (c >= 97 && c <= 122) s += String.fromCharCode(219 - c);
            else s += input[i];
        }
        return s;
    },
    decode: function(input, params) {
        return steps.atbash.encode(input, params);
    }
};

/* ========== caesar - shift cipher (params.shift, default 13) ========== */
steps.caesar = {
    encode: function(input, params) {
        var shift = (params && params.shift != null) ? ((params.shift % 26) + 26) % 26 : 13;
        var s = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) c = ((c - 65 + shift) % 26) + 65;
            else if (c >= 97 && c <= 122) c = ((c - 97 + shift) % 26) + 97;
            s += String.fromCharCode(c);
        }
        return s;
    },
    decode: function(input, params) {
        var shift = (params && params.shift != null) ? ((params.shift % 26) + 26) % 26 : 13;
        return steps.caesar.encode(input, { shift: 26 - shift });
    }
};

/* ========== vigenere - polyalphabetic substitution (params.key required) ========== */
steps.vigenere = {
    encode: function(input, params) {
        var key = ((params && params.key) || 'CRYPTO').toUpperCase();
        var s = '', ki = 0;
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            var shift = key.charCodeAt(ki % key.length) - 65;
            if (c >= 65 && c <= 90) { s += String.fromCharCode(((c - 65 + shift) % 26) + 65); ki++; }
            else if (c >= 97 && c <= 122) { s += String.fromCharCode(((c - 97 + shift) % 26) + 97); ki++; }
            else s += input[i];
        }
        return s;
    },
    decode: function(input, params) {
        var key = ((params && params.key) || 'CRYPTO').toUpperCase();
        var s = '', ki = 0;
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            var shift = key.charCodeAt(ki % key.length) - 65;
            if (c >= 65 && c <= 90) { s += String.fromCharCode(((c - 65 - shift + 26) % 26) + 65); ki++; }
            else if (c >= 97 && c <= 122) { s += String.fromCharCode(((c - 97 - shift + 26) % 26) + 97); ki++; }
            else s += input[i];
        }
        return s;
    }
};

/* ========== railFence - transposition cipher (params.rails, default 3) ========== */
steps.railFence = {
    encode: function(input, params) {
        var rails = (params && params.rails) || 3;
        if (rails < 2) rails = 2;
        var fence = [];
        for (var r = 0; r < rails; r++) fence.push([]);
        var rail = 0, dir = 1;
        for (var i = 0; i < input.length; i++) {
            fence[rail].push(input[i]);
            if (rail === 0) dir = 1;
            else if (rail === rails - 1) dir = -1;
            rail += dir;
        }
        return fence.map(function(r) { return r.join(''); }).join('');
    },
    decode: function(input, params) {
        var rails = (params && params.rails) || 3;
        if (rails < 2) rails = 2;
        var n = input.length;
        var pattern = [];
        var rail = 0, dir = 1;
        for (var i = 0; i < n; i++) {
            pattern.push(rail);
            if (rail === 0) dir = 1;
            else if (rail === rails - 1) dir = -1;
            rail += dir;
        }
        var lengths = new Array(rails);
        for (var r = 0; r < rails; r++) lengths[r] = 0;
        for (var i = 0; i < n; i++) lengths[pattern[i]]++;
        var offsets = new Array(rails);
        offsets[0] = 0;
        for (var r = 1; r < rails; r++) offsets[r] = offsets[r - 1] + lengths[r - 1];
        var cursors = offsets.slice();
        var out = new Array(n);
        for (var i = 0; i < n; i++) {
            out[i] = input[cursors[pattern[i]]++];
        }
        return out.join('');
    }
};

/* ========== tarWrap - wrap payload in a minimal USTAR tar archive ========== */
steps.tarWrap = {
    encode: function(input, params) {
        var filename = (params && params.filename) || 'secret.txt';
        var payloadBytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var headerSize = 512;
        var dataBlocks = Math.ceil(payloadBytes.length / 512);
        var totalSize = headerSize + dataBlocks * 512 + 1024;
        var tar = new Uint8Array(totalSize);
        for (var i = 0; i < filename.length && i < 100; i++) tar[i] = filename.charCodeAt(i);
        var sizeOctal = payloadBytes.length.toString(8);
        sizeOctal = '00000000000'.substring(sizeOctal.length) + sizeOctal;
        for (var i = 0; i < 11; i++) tar[124 + i] = sizeOctal.charCodeAt(i);
        var mtime = Math.floor(Date.now() / 1000).toString(8);
        mtime = '00000000000'.substring(mtime.length) + mtime;
        for (var i = 0; i < 11; i++) tar[136 + i] = mtime.charCodeAt(i);
        tar[156] = 0x30;
        var ustar = 'ustar\x0000';
        for (var i = 0; i < ustar.length; i++) tar[257 + i] = ustar.charCodeAt(i);
        var mode = '0000644\x00';
        for (var i = 0; i < mode.length; i++) tar[100 + i] = mode.charCodeAt(i);
        for (var i = 0; i < 8; i++) tar[148 + i] = 0x20;
        var checksum = 0;
        for (var i = 0; i < 512; i++) checksum += tar[i];
        var csOctal = checksum.toString(8);
        csOctal = '000000'.substring(csOctal.length) + csOctal;
        for (var i = 0; i < 6; i++) tar[148 + i] = csOctal.charCodeAt(i);
        tar[154] = 0; tar[155] = 0x20;
        tar.set(payloadBytes, 512);
        var binary = '';
        for (var i = 0; i < tar.length; i++) binary += String.fromCharCode(tar[i]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        if (bytes.length < 512) throw new Error('Not a valid tar archive');
        var sizeStr = '';
        for (var i = 124; i < 135; i++) {
            if (bytes[i] === 0) break;
            sizeStr += String.fromCharCode(bytes[i]);
        }
        var fileSize = parseInt(sizeStr, 8);
        if (isNaN(fileSize) || fileSize <= 0) throw new Error('Invalid tar file size');
        var payload = bytes.subarray(512, 512 + fileSize);
        return new TextDecoder().decode(payload);
    }
};

/* ========== innerEmbed - creates a small stego image, outputs base64 pixel data (image-in-image) ========== */
steps.innerEmbed = {
    encode: function(input, params) {
        var E = global.StegoEngine;
        var IG = global.StegoImageGen;
        if (!E) throw new Error('StegoEngine not available for innerEmbed');
        var w = (params && params.innerWidth) || 200;
        var h = (params && params.innerHeight) || 150;
        var coverType = (params && params.innerCoverType) || 'noise';
        var depth = (params && params.innerBitDepth) != null ? params.innerBitDepth : 0;
        var imageData;
        if (IG && IG.generate) {
            var seed = (params && params.innerSeed != null) ? params.innerSeed : undefined;
            var gen = IG.generate(coverType, w, h, seed != null ? { seed: seed } : undefined);
            imageData = gen.imageData;
        } else {
            throw new Error('StegoImageGen not available for innerEmbed');
        }
        var encodedData = (depth === 0)
            ? E.encodeLSB(imageData, input)
            : E.encodeLSBAtDepth(imageData, input, depth);
        var meta = w + ':' + h + ':';
        var headerBytes = new TextEncoder().encode(meta);
        var rgba = new Uint8Array(encodedData.data);
        var combined = new Uint8Array(headerBytes.length + rgba.length);
        combined.set(headerBytes, 0);
        combined.set(rgba, headerBytes.length);
        var binary = '';
        for (var i = 0; i < combined.length; i++) binary += String.fromCharCode(combined[i]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var E = global.StegoEngine;
        if (!E) throw new Error('StegoEngine not available for innerEmbed decode');
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var colonCount = 0, headerEnd = 0;
        for (var i = 0; i < Math.min(bytes.length, 20); i++) {
            if (bytes[i] === 0x3A) colonCount++;
            if (colonCount === 2) { headerEnd = i + 1; break; }
        }
        var meta = new TextDecoder().decode(bytes.subarray(0, headerEnd));
        var parts = meta.split(':');
        var w = parseInt(parts[0], 10);
        var h = parseInt(parts[1], 10);
        var rgba = bytes.subarray(headerEnd);
        if (rgba.length < w * h * 4) throw new Error('innerEmbed: pixel data too short');
        var imgData = new (global.ImageData || function(d,w,h){ this.data=d; this.width=w; this.height=h; })(
            new Uint8ClampedArray(rgba.buffer, rgba.byteOffset, w * h * 4), w, h
        );
        var depth = (params && params.innerBitDepth) != null ? params.innerBitDepth : 0;
        return (depth === 0) ? E.decodeLSB(imgData) : E.decodeLSBAtDepth(imgData, depth);
    }
};

/* ========== decoy - adds red-herring data around the real payload ========== */
var DECOY_TEXTS = [
    'VGhpcyBpcyBub3QgdGhlIGZsYWc=',
    'dHJ5IGhhcmRlci4uLg==',
    'bG9va2luZyBpbiB0aGUgd3JvbmcgcGxhY2U=',
    'bmljZSB0cnkgYnV0IG5vcGU=',
    'ZG8geW91IGV2ZW4gQ1RGPw==',
    'aGludDogbm90IGhlcmU=',
    'UkVEIEhFUlJJTkc='
];

steps.decoy = {
    encode: function(input, params) {
        var count = (params && params.decoyCount) || 3;
        var marker = (params && params.marker) || '<<<REAL>>>';
        var blocks = [];
        for (var i = 0; i < count; i++) {
            blocks.push('<<<DECOY_' + i + '>>>' + DECOY_TEXTS[i % DECOY_TEXTS.length]);
        }
        var insertIdx = Math.floor(Math.random() * (blocks.length + 1));
        blocks.splice(insertIdx, 0, marker + input);
        return blocks.join('\n---\n');
    },
    decode: function(input, params) {
        var marker = (params && params.marker) || '<<<REAL>>>';
        var lines = input.split('\n---\n');
        for (var i = 0; i < lines.length; i++) {
            if (lines[i].indexOf(marker) === 0) {
                return lines[i].substring(marker.length);
            }
        }
        throw new Error('decoy: real payload not found (marker: ' + marker + ')');
    }
};

/* ========== compress - delegates to StegoEngine.compressDeflate ========== */
steps.compress = {
    encode: function(input, params) {
        var E = global.StegoEngine;
        if (!E || !E.compressDeflate) throw new Error('StegoEngine.compressDeflate not available');
        return E.compressDeflate(input).then(function(compressed) {
            var binary = '';
            for (var i = 0; i < compressed.length; i++) binary += String.fromCharCode(compressed[i]);
            return btoa(binary);
        });
    },
    decode: function(input, params) {
        var E = global.StegoEngine;
        if (!E || !E.decompressDeflate) throw new Error('StegoEngine.decompressDeflate not available');
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        return E.decompressDeflate(bytes);
    }
};

/* ========== encrypt - delegates to StegoEngine.encryptAES ========== */
steps.encrypt = {
    encode: function(input, params) {
        var E = global.StegoEngine;
        if (!E || !E.encryptAES) throw new Error('StegoEngine.encryptAES not available');
        var password = (params && params.password) || (params && params.key) || '';
        if (!password) throw new Error('encrypt step requires password or key param');
        return E.encryptAES(input, password);
    },
    decode: function(input, params) {
        var E = global.StegoEngine;
        if (!E || !E.decryptAES) throw new Error('StegoEngine.decryptAES not available');
        var password = (params && params.password) || (params && params.key) || '';
        if (!password) throw new Error('encrypt step requires password or key param');
        return E.decryptAES(input, password);
    }
};

/* ========== rsProtect - delegates to StegoRS ========== */
steps.rsProtect = {
    encode: function(input, params) {
        var RS = global.StegoRS;
        if (!RS || !RS.rsProtect) throw new Error('StegoRS not available');
        var parityLevel = (params && params.parityLevel) != null ? params.parityLevel : 2;
        var parity = [16, 32, 48][parityLevel - 1] || 32;
        var bytes = typeof input === 'string' ? new TextEncoder().encode(input) : new Uint8Array(input);
        var protected_ = RS.rsProtect(bytes, parity);
        var flagged = new Uint8Array(2 + protected_.length);
        flagged[0] = 0x03;
        flagged[1] = parityLevel;
        flagged.set(protected_, 2);
        var latin1 = '';
        for (var i = 0; i < flagged.length; i++) latin1 += String.fromCharCode(flagged[i]);
        return 'RS:' + btoa(latin1);
    },
    decode: function(input, params) {
        if (input.indexOf('RS:') !== 0) throw new Error('Not RS-protected payload');
        var RS = global.StegoRS;
        if (!RS || !RS.rsUnprotect) throw new Error('StegoRS.rsUnprotect not available');
        var b64 = input.substring(3);
        var binary = atob(b64);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var parityLevel = bytes[1];
        var parityBytes = [16, 32, 48][parityLevel - 1] || 32;
        var payload = bytes.slice(2);
        var recovered = RS.rsUnprotect(payload, parityBytes);
        return new TextDecoder().decode(recovered);
    }
};

/* ========== embed - special step: (payload, cover, params) => stego ========== */
steps.embed = {
    encode: function(payload, cover, params) {
        var E = global.StegoEngine;
        var IG = global.StegoImageGen;
        if (!E) throw new Error('StegoEngine not available');

        var medium = (params && params.medium) || 'image';
        var depth = (params && params.bitDepth) != null ? params.bitDepth : (params && params.depth) != null ? params.depth : 0;
        var depthMode = (params && params.bitDepthMode) || (params && params.depthMode) || 'at';
        var channel = (params && params.channel) != null ? params.channel : null;
        var plane = (params && params.plane) != null ? params.plane : null;

        if (medium === 'audio') {
            var A = global.StegoAudio;
            var AG = global.StegoAudioGen;
            if (!A) throw new Error('StegoAudio not available');
            var audioBuffer = cover && (cover.buffer || cover.byteLength != null ? cover : null);
            if (!audioBuffer && AG && AG.generate) {
                var audioType = (params && params.audioCoverType) || 'tone';
                var duration = (params && params.audioDuration) || 3;
                var sr = (params && params.sampleRate) || 44100;
                var audioOpts = (params && params.coverSeed != null) ? { seed: params.coverSeed } : undefined;
                var gen = AG.generate(audioType, duration, sr, audioOpts);
                audioBuffer = gen.buffer;
            }
            if (!audioBuffer) throw new Error('Audio cover required (upload WAV or use audioCoverType for generation)');
            var encodedBuffer = A.encodeWAV(audioBuffer, payload, depth, depthMode);
            return { type: 'audio', blob: typeof Blob !== 'undefined' ? new Blob([encodedBuffer], { type: 'audio/wav' }) : encodedBuffer };
        }

        var imageData = cover;
        if (!imageData || !imageData.data) {
            var coverType = (params && params.coverType) || 'gradient';
            var w = (params && params.width) || 400;
            var h = (params && params.height) || 300;
            if (IG && IG.generate) {
                var imgOpts = (params && params.coverSeed != null) ? { seed: params.coverSeed } : undefined;
                var gen = IG.generate(coverType, w, h, imgOpts);
                imageData = gen.imageData;
            } else {
                throw new Error('StegoImageGen not available for cover generation');
            }
        }

        var encodedData;
        if (channel != null && E.encodeLSBChannel) {
            encodedData = E.encodeLSBChannel(imageData, payload, channel, plane != null ? plane : 0);
        } else if (depth === 0 && depthMode === 'at') {
            encodedData = E.encodeLSB(imageData, payload);
        } else if (depthMode === 'at') {
            encodedData = E.encodeLSBAtDepth(imageData, payload, depth);
        } else {
            encodedData = E.encodeLSBWithDepth(imageData, payload, depth);
        }

        if (typeof document === 'undefined' || !document.createElement) {
            return { type: 'image', imageData: encodedData };
        }
        var canvas = document.createElement('canvas');
        canvas.width = encodedData.width;
        canvas.height = encodedData.height;
        canvas.getContext('2d').putImageData(encodedData, 0, 0);
        return {
            type: 'image',
            imageData: encodedData,
            canvas: canvas
        };
    }
};

/* ========== appendEof - append payload after PNG IEND, JPEG FFD9, or WAV data (binwalk-style) ========== */
steps.appendEof = {
    encode: function(payload, cover, params) {
        var fileBytes = (params && params.coverBytes) || (cover && (cover.byteLength != null ? cover : cover.buffer));
        if (!fileBytes) throw new Error('appendEof requires coverBytes (ArrayBuffer/Uint8Array) or cover');
        if (fileBytes.buffer) fileBytes = new Uint8Array(fileBytes);
        else if (!(fileBytes instanceof Uint8Array)) fileBytes = new Uint8Array(fileBytes);

        var payloadBytes = typeof payload === 'string' ? new TextEncoder().encode(payload) : new Uint8Array(payload);
        var eofOffset = null;

        if (fileBytes.length >= 12 && fileBytes[0] === 0x52 && fileBytes[1] === 0x49 && fileBytes[2] === 0x46 && fileBytes[3] === 0x46 &&
            fileBytes[8] === 0x57 && fileBytes[9] === 0x41 && fileBytes[10] === 0x56 && fileBytes[11] === 0x45) {
            var offset = 12;
            while (offset + 8 <= fileBytes.length) {
                var chunkSize = (fileBytes[offset + 4] | (fileBytes[offset + 5] << 8) | (fileBytes[offset + 6] << 16) | (fileBytes[offset + 7] << 24)) >>> 0;
                eofOffset = offset + 8 + chunkSize;
                if (chunkSize % 2 !== 0) eofOffset++;
                offset = eofOffset;
            }
        }

        if (eofOffset == null) {
            var iend = [0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82];
            for (var i = 0; i <= fileBytes.length - iend.length; i++) {
                var match = true;
                for (var j = 0; j < iend.length; j++) {
                    if (fileBytes[i + j] !== iend[j]) { match = false; break; }
                }
                if (match) { eofOffset = i + iend.length; break; }
            }
        }
        if (eofOffset == null) {
            for (var k = 0; k <= fileBytes.length - 2; k++) {
                if (fileBytes[k] === 0xFF && fileBytes[k + 1] === 0xD9) {
                    eofOffset = k + 2;
                    break;
                }
            }
        }
        if (eofOffset == null) eofOffset = fileBytes.length;

        var out = new Uint8Array(eofOffset + payloadBytes.length);
        out.set(fileBytes.subarray(0, eofOffset), 0);
        out.set(payloadBytes, eofOffset);
        return { type: 'eofAppend', bytes: out };
    }
};

/* ========== embedSpectrogram - encode text as audio frequencies (Sonic Visualiser, Audacity) ========== */
steps.embedSpectrogram = {
    encode: function(payload, cover, params) {
        var sampleRate = (params && params.sampleRate) || 44100;
        var durationPerChar = (params && params.durationPerChar) || 0.08;
        var baseFreq = (params && params.baseFreq) || 200;
        var bytes = typeof payload === 'string' ? new TextEncoder().encode(payload) : new Uint8Array(payload);
        var numSamples = Math.ceil(sampleRate * durationPerChar * (bytes.length + 1));
        var buffer = new ArrayBuffer(44 + numSamples * 2);
        var view = new DataView(buffer);
        var header = 'RIFF';
        for (var h = 0; h < 4; h++) view.setUint8(h, header.charCodeAt(h));
        view.setUint32(4, 36 + numSamples * 2, true);
        header = 'WAVEfmt ';
        for (var h = 0; h < 8; h++) view.setUint8(8 + h, header.charCodeAt(h));
        view.setUint32(16, 16, true);
        view.setUint16(20, 1, true);
        view.setUint16(22, 1, true);
        view.setUint32(24, sampleRate, true);
        view.setUint32(28, sampleRate * 2, true);
        view.setUint16(32, 2, true);
        view.setUint16(34, 16, true);
        header = 'data';
        for (var h = 0; h < 4; h++) view.setUint8(36 + h, header.charCodeAt(h));
        view.setUint32(40, numSamples * 2, true);

        var samplesPerChar = Math.floor(sampleRate * durationPerChar);
        for (var i = 0; i < bytes.length + 1; i++) {
            var byteVal = i < bytes.length ? bytes[i] : 0;
            var freq = baseFreq + byteVal * 2;
            var start = 44 + i * samplesPerChar * 2;
            var end = Math.min(start + samplesPerChar * 2, 44 + numSamples * 2);
            for (var s = start; s < end; s += 2) {
                var t = (s - start) / 2 / sampleRate;
                var sample = Math.sin(2 * Math.PI * freq * t) * 0.5 * 32767;
                view.setInt16(s, Math.max(-32768, Math.min(32767, sample)), true);
            }
        }
        return { type: 'audio', blob: typeof Blob !== 'undefined' ? new Blob([buffer], { type: 'audio/wav' }) : buffer };
    }
};

/* ========== embedOverlay - nearly invisible text (low opacity 1-5%) ========== */
steps.embedOverlay = {
    encode: function(payload, cover, params) {
        if (typeof document === 'undefined' || !document.createElement) {
            return { type: 'image', imageData: cover && cover.data ? cover : null };
        }
        var opacity = (params && params.opacity) != null ? params.opacity : 0.03;
        var imageData = cover;
        var IG = global.StegoImageGen;
        if (!imageData || !imageData.data) {
            var coverType = (params && params.coverType) || 'gradient';
            var w = (params && params.width) || 400;
            var h = (params && params.height) || 300;
            if (IG && IG.generate) {
                imageData = IG.generate(coverType, w, h).imageData;
            } else {
                throw new Error('StegoImageGen not available');
            }
        }
        var canvas = document.createElement('canvas');
        canvas.width = imageData.width;
        canvas.height = imageData.height;
        var ctx = canvas.getContext('2d');
        ctx.putImageData(imageData, 0, 0);
        ctx.fillStyle = 'rgba(0,0,0,' + opacity + ')';
        ctx.font = (params && params.fontSize) || '16px sans-serif';
        ctx.fillText(payload, 10, 20);
        return { type: 'image', canvas: canvas, imageData: ctx.getImageData(0, 0, canvas.width, canvas.height) };
    }
};

/* CRC32 for PNG chunks */
function crc32(data) {
    var table = [];
    for (var n = 0; n < 256; n++) {
        var c = n;
        for (var k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
        table[n] = c >>> 0;
    }
    var crc = 0 ^ (-1);
    for (var i = 0; i < data.length; i++) {
        crc = table[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
    }
    return (crc ^ (-1)) >>> 0;
}

/* ========== embedPngText - embed in PNG tEXt chunk (EXIF/comment style) ========== */
steps.embedPngText = {
    encode: function(payload, cover, params) {
        var imageBytes = (params && params.coverBytes) || (cover && (cover.byteLength != null ? cover : cover.buffer));
        if (!imageBytes) throw new Error('embedPngText requires coverBytes');
        if (imageBytes.buffer) imageBytes = new Uint8Array(imageBytes);
        else if (!(imageBytes instanceof Uint8Array)) imageBytes = new Uint8Array(imageBytes);

        var keyword = (params && params.keyword) || 'Comment';
        var kwBytes = new TextEncoder().encode(keyword);
        if (kwBytes.length > 79) kwBytes = kwBytes.subarray(0, 79);
        var payloadBytes = typeof payload === 'string' ? new TextEncoder().encode(payload) : new Uint8Array(payload);
        var chunkData = new Uint8Array(kwBytes.length + 1 + payloadBytes.length);
        chunkData.set(kwBytes, 0);
        chunkData[kwBytes.length] = 0;
        chunkData.set(payloadBytes, kwBytes.length + 1);
        var chunkLen = 4;
        var chunkType = [0x74, 0x45, 0x58, 0x74];
        var lenArr = new Uint8Array(4);
        lenArr[0] = (chunkData.length >>> 24) & 0xFF;
        lenArr[1] = (chunkData.length >>> 16) & 0xFF;
        lenArr[2] = (chunkData.length >>> 8) & 0xFF;
        lenArr[3] = chunkData.length & 0xFF;
        var crcInput = new Uint8Array(4 + chunkData.length);
        crcInput.set(chunkType, 0);
        crcInput.set(chunkData, 4);
        var crcVal = crc32(crcInput);
        var iendSig = [0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82];
        var iendPos = -1;
        for (var i = 0; i <= imageBytes.length - 12; i++) {
            var ok = true;
            for (var j = 0; j < 12; j++) if (imageBytes[i + j] !== iendSig[j]) { ok = false; break; }
            if (ok) { iendPos = i; break; }
        }
        if (iendPos < 0) throw new Error('PNG IEND not found');
        var out = new Uint8Array(iendPos + 12 + 4 + 4 + chunkData.length + 4);
        out.set(imageBytes.subarray(0, iendPos), 0);
        var pos = iendPos;
        out.set(lenArr, pos); pos += 4;
        out.set(chunkType, pos); pos += 4;
        out.set(chunkData, pos); pos += chunkData.length;
        out[pos] = (crcVal >>> 24) & 0xFF; out[pos + 1] = (crcVal >>> 16) & 0xFF;
        out[pos + 2] = (crcVal >>> 8) & 0xFF; out[pos + 3] = crcVal & 0xFF; pos += 4;
        out.set(new Uint8Array(iendSig), pos);
        return { type: 'eofAppend', bytes: out };
    }
};

/* Zero-width Unicode: 200B=bit0, 200C=bit1, 200D=bit2 (stegsnow-style, 3 bits per space) */
var ZW_BITS = [0x200B, 0x200C, 0x200D];

/* ========== snow - zero-width character encoding (stegsnow style) ========== */
steps.snow = {
    encode: function(payload, cover, params) {
        var p = params || {};
        var coverText = p.coverText || (cover && (typeof cover === 'string' ? cover : cover.coverText)) || '';
        if (!coverText) coverText = 'Lorem ipsum dolor sit amet consectetur adipiscing elit. ';
        var bytes = typeof payload === 'string' ? new TextEncoder().encode(payload) : new Uint8Array(payload);
        var bits = [];
        for (var i = 0; i < bytes.length; i++) {
            for (var b = 7; b >= 0; b--) bits.push((bytes[i] >> b) & 1);
        }
        for (var j = 0; j < 8; j++) bits.push(0);
        var result = '';
        var bitIdx = 0;
        for (var k = 0; k < coverText.length; k++) {
            result += coverText[k];
            if (bitIdx < bits.length && (coverText[k] === ' ' || coverText[k] === '\n')) {
                for (var n = 0; n < 3 && bitIdx < bits.length; n++) {
                    if (bits[bitIdx++]) result += String.fromCharCode(ZW_BITS[n]);
                }
            }
        }
        if (k < coverText.length) result += coverText.substring(k);
        return result;
    },
    decode: function(input, params) {
        var bits = [];
        for (var p = 0; p < input.length; p++) {
            if (input[p] === ' ' || input[p] === '\n') {
                var slots = [0, 0, 0];
                for (var q = p + 1; q < input.length; q++) {
                    var ch = input.charCodeAt(q);
                    if (ch === 0x200B) slots[0] = 1;
                    else if (ch === 0x200C) slots[1] = 1;
                    else if (ch === 0x200D) slots[2] = 1;
                    else if (ch === 0xFEFF) slots[0] = 1;
                    else break;
                }
                bits.push(slots[0], slots[1], slots[2]);
            }
        }
        var bytes = [];
        for (var r = 0; r + 8 <= bits.length; r += 8) {
            var byte = 0;
            for (var s = 0; s < 8; s++) byte = (byte << 1) | (bits[r + s] || 0);
            if (byte === 0) break;
            bytes.push(byte);
        }
        return new TextDecoder().decode(new Uint8Array(bytes));
    }
};

/* ========== scatterEmbed - key-based pseudo-random pixel LSB placement ========== */
function _scatterPrng(seed) {
    var s = seed >>> 0;
    return function() {
        s = (s + 0x6D2B79F5) >>> 0;
        var t = Math.imul(s ^ (s >>> 15), s | 1);
        t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
        return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
}

function _scatterHashKey(key) {
    var h = 5381;
    for (var i = 0; i < key.length; i++) h = ((h << 5) + h + key.charCodeAt(i)) >>> 0;
    return h;
}

steps.scatterEmbed = {
    encode: function(payload, cover, params) {
        var IG = global.StegoImageGen;
        var scatterKey = (params && params.scatterKey) || (params && params.key) || 'defaultkey';
        var w = (params && params.width) || 500;
        var h = (params && params.height) || 400;
        var imageData = cover;
        if (!imageData || !imageData.data) {
            var coverType = (params && params.coverType) || 'noise';
            if (IG && IG.generate) {
                var seed = (params && params.coverSeed != null) ? params.coverSeed : undefined;
                imageData = IG.generate(coverType, w, h, seed != null ? { seed: seed } : undefined).imageData;
            } else {
                throw new Error('StegoImageGen not available for scatterEmbed');
            }
        }
        w = imageData.width;
        h = imageData.height;
        var totalPixels = w * h;
        var data = imageData.data;
        var payloadBytes = typeof payload === 'string' ? new TextEncoder().encode(payload) : new Uint8Array(payload);
        var bits = [];
        var lenBytes = [(payloadBytes.length >>> 24) & 0xFF, (payloadBytes.length >>> 16) & 0xFF,
                        (payloadBytes.length >>> 8) & 0xFF, payloadBytes.length & 0xFF];
        for (var i = 0; i < 4; i++)
            for (var b = 7; b >= 0; b--) bits.push((lenBytes[i] >> b) & 1);
        for (var i = 0; i < payloadBytes.length; i++)
            for (var b = 7; b >= 0; b--) bits.push((payloadBytes[i] >> b) & 1);
        if (bits.length > totalPixels * 3) throw new Error('scatterEmbed: payload too large for image');
        var rng = _scatterPrng(_scatterHashKey(scatterKey));
        var indices = [];
        for (var i = 0; i < totalPixels; i++) indices.push(i);
        for (var i = indices.length - 1; i > 0; i--) {
            var j = Math.floor(rng() * (i + 1));
            var tmp = indices[i]; indices[i] = indices[j]; indices[j] = tmp;
        }
        for (var i = 0; i < bits.length; i++) {
            var pixIdx = indices[i];
            var channel = i % 3;
            var byteIdx = pixIdx * 4 + channel;
            data[byteIdx] = (data[byteIdx] & 0xFE) | bits[i];
        }
        if (typeof document === 'undefined' || !document.createElement) {
            return { type: 'image', imageData: imageData };
        }
        var canvas = document.createElement('canvas');
        canvas.width = w;
        canvas.height = h;
        canvas.getContext('2d').putImageData(imageData, 0, 0);
        return { type: 'image', imageData: imageData, canvas: canvas };
    }
};

/* ========== output - text terminal for crypto-only pipelines ========== */
steps.output = {
    encode: function(payload, cover, params) {
        if (typeof payload !== 'string') payload = new TextDecoder().decode(payload);
        return payload;
    }
};

/* ================================================================
 *  CRYPTO CTF STEPS — Phase 1: Common CTF encodings/ciphers
 * ================================================================ */

/* ========== a1z26 (A=1, B=2, ..., Z=26) ========== */
steps.a1z26 = {
    encode: function(input, params) {
        var sep = (params && params.separator) || '-';
        var parts = [];
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) parts.push(c - 64);
            else if (c >= 97 && c <= 122) parts.push(c - 96);
            else if (c === 32) parts.push(0);
            else parts.push(input[i]);
        }
        return parts.join(sep);
    },
    decode: function(input, params) {
        var sep = (params && params.separator) || '-';
        var parts = input.split(sep);
        var out = '';
        for (var i = 0; i < parts.length; i++) {
            var n = parseInt(parts[i], 10);
            if (n === 0) out += ' ';
            else if (n >= 1 && n <= 26) out += String.fromCharCode(64 + n);
            else out += parts[i];
        }
        return out;
    }
};

/* ========== affine cipher (E(x) = (ax + b) mod 26) ========== */
steps.affine = {
    _COPRIMES: [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25],
    _modInverse: function(a, m) {
        a = ((a % m) + m) % m;
        for (var x = 1; x < m; x++) {
            if ((a * x) % m === 1) return x;
        }
        return 1;
    },
    encode: function(input, params) {
        var a = (params && params.a) || 5;
        var b = (params && params.b != null) ? params.b : 8;
        var out = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) out += String.fromCharCode(((a * (c - 65) + b) % 26) + 65);
            else if (c >= 97 && c <= 122) out += String.fromCharCode(((a * (c - 97) + b) % 26) + 97);
            else out += input[i];
        }
        return out;
    },
    decode: function(input, params) {
        var a = (params && params.a) || 5;
        var b = (params && params.b != null) ? params.b : 8;
        var aInv = this._modInverse(a, 26);
        var out = '';
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) out += String.fromCharCode((((aInv * ((c - 65) - b + 260)) % 26) + 26) % 26 + 65);
            else if (c >= 97 && c <= 122) out += String.fromCharCode((((aInv * ((c - 97) - b + 260)) % 26) + 26) % 26 + 97);
            else out += input[i];
        }
        return out;
    }
};

/* ========== ascii85 (Base85) ========== */
steps.ascii85 = {
    _CHARS: '!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstu',
    encode: function(input, params) {
        var bytes = new TextEncoder().encode(input);
        var pad = (4 - (bytes.length % 4)) % 4;
        var padded = new Uint8Array(bytes.length + pad);
        padded.set(bytes);
        var chars = this._CHARS;
        var out = '<~';
        for (var i = 0; i < padded.length; i += 4) {
            var val = ((padded[i] << 24) | (padded[i+1] << 16) | (padded[i+2] << 8) | padded[i+3]) >>> 0;
            if (val === 0 && i + 4 <= bytes.length) { out += 'z'; continue; }
            var block = '';
            for (var j = 4; j >= 0; j--) {
                block = chars[val % 85] + block;
                val = Math.floor(val / 85);
            }
            out += block;
        }
        if (pad > 0) out = out.slice(0, -(pad));
        return out + '~>';
    },
    decode: function(input, params) {
        var s = input.replace(/^<~/, '').replace(/~>$/, '').replace(/\s/g, '');
        var chars = this._CHARS;
        var bytes = [];
        var i = 0;
        while (i < s.length) {
            if (s[i] === 'z') { bytes.push(0, 0, 0, 0); i++; continue; }
            var chunk = s.slice(i, i + 5);
            var pad = 5 - chunk.length;
            while (chunk.length < 5) chunk += 'u';
            var val = 0;
            for (var j = 0; j < 5; j++) {
                val = val * 85 + chars.indexOf(chunk[j]);
            }
            bytes.push((val >>> 24) & 0xFF, (val >>> 16) & 0xFF, (val >>> 8) & 0xFF, val & 0xFF);
            if (pad > 0) bytes.splice(bytes.length - pad, pad);
            i += 5 - pad;
        }
        return new TextDecoder().decode(new Uint8Array(bytes));
    }
};

/* ========== nato phonetic alphabet ========== */
steps.nato = {
    _MAP: {
        A:'Alpha',B:'Bravo',C:'Charlie',D:'Delta',E:'Echo',F:'Foxtrot',G:'Golf',
        H:'Hotel',I:'India',J:'Juliet',K:'Kilo',L:'Lima',M:'Mike',N:'November',
        O:'Oscar',P:'Papa',Q:'Quebec',R:'Romeo',S:'Sierra',T:'Tango',U:'Uniform',
        V:'Victor',W:'Whiskey',X:'Xray',Y:'Yankee',Z:'Zulu',
        '0':'Zero','1':'One','2':'Two','3':'Three','4':'Four',
        '5':'Five','6':'Six','7':'Seven','8':'Eight','9':'Nine'
    },
    _REV: null,
    _buildRev: function() {
        if (this._REV) return this._REV;
        this._REV = {};
        for (var k in this._MAP) this._REV[this._MAP[k].toUpperCase()] = k;
        return this._REV;
    },
    encode: function(input, params) {
        var map = this._MAP;
        var words = [];
        for (var i = 0; i < input.length; i++) {
            var c = input[i].toUpperCase();
            if (map[c]) words.push(map[c]);
            else if (c === ' ') words.push('/');
            else words.push(c);
        }
        return words.join(' ');
    },
    decode: function(input, params) {
        var rev = this._buildRev();
        var tokens = input.split(/\s+/);
        var out = '';
        for (var i = 0; i < tokens.length; i++) {
            var t = tokens[i].toUpperCase();
            if (t === '/') out += ' ';
            else if (rev[t]) out += rev[t];
            else out += tokens[i];
        }
        return out;
    }
};

/* ========== phone/T9 keypad multi-tap ========== */
steps.phoneKeypad = {
    _KEYS: {
        A:'2',B:'22',C:'222',D:'3',E:'33',F:'333',G:'4',H:'44',I:'444',
        J:'5',K:'55',L:'555',M:'6',N:'66',O:'666',P:'7',Q:'77',R:'777',S:'7777',
        T:'8',U:'88',V:'888',W:'9',X:'99',Y:'999',Z:'9999',
        '0':'0','1':'1',' ':' '
    },
    _REV: null,
    _buildRev: function() {
        if (this._REV) return this._REV;
        this._REV = {};
        for (var k in this._KEYS) this._REV[this._KEYS[k]] = k;
        return this._REV;
    },
    encode: function(input, params) {
        var keys = this._KEYS;
        var parts = [];
        for (var i = 0; i < input.length; i++) {
            var c = input[i].toUpperCase();
            parts.push(keys[c] || c);
        }
        return parts.join('-');
    },
    decode: function(input, params) {
        var rev = this._buildRev();
        var parts = input.split('-');
        var out = '';
        for (var i = 0; i < parts.length; i++) {
            out += rev[parts[i]] || parts[i];
        }
        return out;
    }
};

/* ========== tap code (5x5 grid, K=C) ========== */
steps.tapCode = {
    _GRID: 'ABCDEFGHILMNOPQRSTUVWXYZ',
    encode: function(input, params) {
        var grid = this._GRID;
        var parts = [];
        for (var i = 0; i < input.length; i++) {
            var c = input[i].toUpperCase();
            if (c === 'K') c = 'C';
            if (c === ' ') { parts.push('/'); continue; }
            var idx = grid.indexOf(c);
            if (idx < 0) { parts.push(c); continue; }
            var row = Math.floor(idx / 5) + 1;
            var col = (idx % 5) + 1;
            parts.push(row + '.' + col);
        }
        return parts.join(' ');
    },
    decode: function(input, params) {
        var grid = this._GRID;
        var tokens = input.split(/\s+/);
        var out = '';
        for (var i = 0; i < tokens.length; i++) {
            if (tokens[i] === '/') { out += ' '; continue; }
            var m = tokens[i].match(/^(\d)\.(\d)$/);
            if (m) {
                var idx = (parseInt(m[1], 10) - 1) * 5 + (parseInt(m[2], 10) - 1);
                out += (idx >= 0 && idx < grid.length) ? grid[idx] : tokens[i];
            } else {
                out += tokens[i];
            }
        }
        return out;
    }
};

/* ========== URL encoding ========== */
steps.urlEncode = {
    encode: function(input, params) {
        return encodeURIComponent(input);
    },
    decode: function(input, params) {
        return decodeURIComponent(input);
    }
};

/* ================================================================
 *  CRYPTO CTF STEPS — Phase 2: Classical ciphers
 * ================================================================ */

/* ========== playfair cipher ========== */
steps.playfair = {
    _buildGrid: function(key) {
        key = (key || 'PLAYFAIR').toUpperCase().replace(/J/g, 'I');
        var seen = {};
        var grid = '';
        var src = key + 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
        for (var i = 0; i < src.length; i++) {
            var c = src[i];
            if (c >= 'A' && c <= 'Z' && !seen[c]) { grid += c; seen[c] = true; }
        }
        return grid;
    },
    _findPos: function(grid, c) {
        var idx = grid.indexOf(c);
        return [Math.floor(idx / 5), idx % 5];
    },
    encode: function(input, params) {
        var grid = this._buildGrid(params && params.key);
        var text = input.toUpperCase().replace(/J/g, 'I').replace(/[^A-Z]/g, '');
        var pairs = [];
        var i = 0;
        while (i < text.length) {
            var a = text[i];
            var b = (i + 1 < text.length && text[i + 1] !== a) ? text[++i] : 'X';
            i++;
            pairs.push([a, b]);
        }
        var out = '';
        for (var p = 0; p < pairs.length; p++) {
            var pa = this._findPos(grid, pairs[p][0]);
            var pb = this._findPos(grid, pairs[p][1]);
            if (pa[0] === pb[0]) {
                out += grid[pa[0] * 5 + (pa[1] + 1) % 5];
                out += grid[pb[0] * 5 + (pb[1] + 1) % 5];
            } else if (pa[1] === pb[1]) {
                out += grid[((pa[0] + 1) % 5) * 5 + pa[1]];
                out += grid[((pb[0] + 1) % 5) * 5 + pb[1]];
            } else {
                out += grid[pa[0] * 5 + pb[1]];
                out += grid[pb[0] * 5 + pa[1]];
            }
        }
        return out;
    },
    decode: function(input, params) {
        var grid = this._buildGrid(params && params.key);
        var text = input.toUpperCase().replace(/[^A-Z]/g, '');
        var out = '';
        for (var i = 0; i < text.length; i += 2) {
            var pa = this._findPos(grid, text[i]);
            var pb = this._findPos(grid, text[i + 1]);
            if (pa[0] === pb[0]) {
                out += grid[pa[0] * 5 + (pa[1] + 4) % 5];
                out += grid[pb[0] * 5 + (pb[1] + 4) % 5];
            } else if (pa[1] === pb[1]) {
                out += grid[((pa[0] + 4) % 5) * 5 + pa[1]];
                out += grid[((pb[0] + 4) % 5) * 5 + pb[1]];
            } else {
                out += grid[pa[0] * 5 + pb[1]];
                out += grid[pb[0] * 5 + pa[1]];
            }
        }
        return out;
    }
};

/* ========== beaufort cipher (variant of Vigenère: Ci = (Ki - Pi) mod 26) ========== */
steps.beaufort = {
    encode: function(input, params) {
        var key = ((params && params.key) || 'SECRET').toUpperCase();
        var out = '';
        var ki = 0;
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) {
                out += String.fromCharCode(((key.charCodeAt(ki % key.length) - 65 - (c - 65) + 26) % 26) + 65);
                ki++;
            } else if (c >= 97 && c <= 122) {
                out += String.fromCharCode(((key.charCodeAt(ki % key.length) - 65 - (c - 97) + 26) % 26) + 97);
                ki++;
            } else {
                out += input[i];
            }
        }
        return out;
    },
    decode: function(input, params) {
        return this.encode(input, params);
    }
};

/* ========== autokey cipher (Vigenère variant: key extends with plaintext) ========== */
steps.autokey = {
    encode: function(input, params) {
        var key = ((params && params.key) || 'KEY').toUpperCase();
        var out = '';
        var fullKey = key;
        var ki = 0;
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) {
                var k = fullKey.charCodeAt(ki) - 65;
                out += String.fromCharCode(((c - 65 + k) % 26) + 65);
                fullKey += String.fromCharCode(c);
                ki++;
            } else if (c >= 97 && c <= 122) {
                var k2 = fullKey.charCodeAt(ki) - 65;
                out += String.fromCharCode(((c - 97 + k2) % 26) + 97);
                fullKey += String.fromCharCode(c - 32);
                ki++;
            } else {
                out += input[i];
            }
        }
        return out;
    },
    decode: function(input, params) {
        var key = ((params && params.key) || 'KEY').toUpperCase();
        var out = '';
        var fullKey = key;
        var ki = 0;
        for (var i = 0; i < input.length; i++) {
            var c = input.charCodeAt(i);
            if (c >= 65 && c <= 90) {
                var k = fullKey.charCodeAt(ki) - 65;
                var plain = ((c - 65 - k + 26) % 26) + 65;
                out += String.fromCharCode(plain);
                fullKey += String.fromCharCode(plain);
                ki++;
            } else if (c >= 97 && c <= 122) {
                var k2 = fullKey.charCodeAt(ki) - 65;
                var plain2 = ((c - 97 - k2 + 26) % 26) + 97;
                out += String.fromCharCode(plain2);
                fullKey += String.fromCharCode(plain2 - 32);
                ki++;
            } else {
                out += input[i];
            }
        }
        return out;
    }
};

/* ========== bifid cipher (Polybius + transposition) ========== */
steps.bifid = {
    _GRID: 'ABCDEFGHIKLMNOPQRSTUVWXYZ',
    encode: function(input, params) {
        var grid = this._GRID;
        var text = input.toUpperCase().replace(/J/g, 'I').replace(/[^A-Z]/g, '');
        var rows = [], cols = [];
        for (var i = 0; i < text.length; i++) {
            var idx = grid.indexOf(text[i]);
            rows.push(Math.floor(idx / 5));
            cols.push(idx % 5);
        }
        var combined = rows.concat(cols);
        var out = '';
        for (var j = 0; j < combined.length; j += 2) {
            out += grid[combined[j] * 5 + combined[j + 1]];
        }
        return out;
    },
    decode: function(input, params) {
        var grid = this._GRID;
        var text = input.toUpperCase().replace(/[^A-Z]/g, '');
        var coords = [];
        for (var i = 0; i < text.length; i++) {
            var idx = grid.indexOf(text[i]);
            coords.push(Math.floor(idx / 5));
            coords.push(idx % 5);
        }
        var half = coords.length / 2;
        var rows = coords.slice(0, half);
        var cols = coords.slice(half);
        var out = '';
        for (var j = 0; j < rows.length; j++) {
            out += grid[rows[j] * 5 + cols[j]];
        }
        return out;
    }
};

/* ========== one-time pad (XOR with key matching message length) ========== */
steps.otp = {
    encode: function(input, params) {
        var key = (params && params.key) || '';
        if (!key) return input;
        var bytes = new TextEncoder().encode(input);
        var keyBytes = new TextEncoder().encode(key);
        var out = new Uint8Array(bytes.length);
        for (var i = 0; i < bytes.length; i++) {
            out[i] = bytes[i] ^ keyBytes[i % keyBytes.length];
        }
        var binary = '';
        for (var j = 0; j < out.length; j++) binary += String.fromCharCode(out[j]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var key = (params && params.key) || '';
        if (!key) return input;
        var binary = atob(input);
        var bytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
        var keyBytes = new TextEncoder().encode(key);
        var out = new Uint8Array(bytes.length);
        for (var j = 0; j < bytes.length; j++) {
            out[j] = bytes[j] ^ keyBytes[j % keyBytes.length];
        }
        return new TextDecoder().decode(out);
    }
};

/* ================================================================
 *  CRYPTO CTF STEPS — Phase 3: Modern / advanced
 * ================================================================ */

/* ========== RC4 stream cipher ========== */
steps.rc4 = {
    _ksa: function(key) {
        var S = new Uint8Array(256);
        for (var i = 0; i < 256; i++) S[i] = i;
        var j = 0;
        for (var i2 = 0; i2 < 256; i2++) {
            j = (j + S[i2] + key[i2 % key.length]) & 0xFF;
            var t = S[i2]; S[i2] = S[j]; S[j] = t;
        }
        return S;
    },
    _prga: function(S, len) {
        var i = 0, j = 0;
        var out = new Uint8Array(len);
        for (var n = 0; n < len; n++) {
            i = (i + 1) & 0xFF;
            j = (j + S[i]) & 0xFF;
            var t = S[i]; S[i] = S[j]; S[j] = t;
            out[n] = S[(S[i] + S[j]) & 0xFF];
        }
        return out;
    },
    encode: function(input, params) {
        var key = (params && params.key) || 'rc4key';
        var keyBytes = new TextEncoder().encode(key);
        var plainBytes = new TextEncoder().encode(input);
        var S = this._ksa(keyBytes);
        var keystream = this._prga(S, plainBytes.length);
        var cipher = new Uint8Array(plainBytes.length);
        for (var i = 0; i < plainBytes.length; i++) cipher[i] = plainBytes[i] ^ keystream[i];
        var binary = '';
        for (var j = 0; j < cipher.length; j++) binary += String.fromCharCode(cipher[j]);
        return btoa(binary);
    },
    decode: function(input, params) {
        var key = (params && params.key) || 'rc4key';
        var keyBytes = new TextEncoder().encode(key);
        var binary = atob(input);
        var cipherBytes = new Uint8Array(binary.length);
        for (var i = 0; i < binary.length; i++) cipherBytes[i] = binary.charCodeAt(i);
        var S = this._ksa(keyBytes);
        var keystream = this._prga(S, cipherBytes.length);
        var plain = new Uint8Array(cipherBytes.length);
        for (var j = 0; j < cipherBytes.length; j++) plain[j] = cipherBytes[j] ^ keystream[j];
        return new TextDecoder().decode(plain);
    }
};

/* ========== Hill cipher (2x2 matrix mod 26) ========== */
steps.hillCipher = {
    _modInverse: function(a, m) {
        a = ((a % m) + m) % m;
        for (var x = 1; x < m; x++) {
            if ((a * x) % m === 1) return x;
        }
        return -1;
    },
    encode: function(input, params) {
        var matrix = (params && params.matrix) || [3, 3, 2, 5];
        var text = input.toUpperCase().replace(/[^A-Z]/g, '');
        if (text.length % 2 !== 0) text += 'X';
        var out = '';
        for (var i = 0; i < text.length; i += 2) {
            var p0 = text.charCodeAt(i) - 65;
            var p1 = text.charCodeAt(i + 1) - 65;
            out += String.fromCharCode(((matrix[0] * p0 + matrix[1] * p1) % 26 + 26) % 26 + 65);
            out += String.fromCharCode(((matrix[2] * p0 + matrix[3] * p1) % 26 + 26) % 26 + 65);
        }
        return out;
    },
    decode: function(input, params) {
        var matrix = (params && params.matrix) || [3, 3, 2, 5];
        var det = (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % 26;
        det = ((det % 26) + 26) % 26;
        var detInv = this._modInverse(det, 26);
        if (detInv < 0) return input;
        var inv = [
            ((matrix[3] * detInv) % 26 + 26) % 26,
            ((-matrix[1] * detInv) % 26 + 26) % 26,
            ((-matrix[2] * detInv) % 26 + 26) % 26,
            ((matrix[0] * detInv) % 26 + 26) % 26
        ];
        var text = input.toUpperCase().replace(/[^A-Z]/g, '');
        var out = '';
        for (var i = 0; i < text.length; i += 2) {
            var c0 = text.charCodeAt(i) - 65;
            var c1 = text.charCodeAt(i + 1) - 65;
            out += String.fromCharCode(((inv[0] * c0 + inv[1] * c1) % 26 + 26) % 26 + 65);
            out += String.fromCharCode(((inv[2] * c0 + inv[3] * c1) % 26 + 26) % 26 + 65);
        }
        return out;
    }
};

/* ========== RSA textbook (small primes, educational) ========== */
steps.rsaTextbook = {
    _modPow: function(base, exp, mod) {
        var result = 1n;
        base = base % mod;
        while (exp > 0n) {
            if (exp % 2n === 1n) result = (result * base) % mod;
            exp = exp / 2n;
            base = (base * base) % mod;
        }
        return result;
    },
    _modInverse: function(e, phi) {
        var a = e, b = phi, x0 = 0n, x1 = 1n;
        while (a > 1n) {
            var q = a / b;
            var t = b;
            b = a % b;
            a = t;
            t = x0;
            x0 = x1 - q * x0;
            x1 = t;
        }
        return x1 < 0n ? x1 + phi : x1;
    },
    encode: function(input, params) {
        var p = BigInt((params && params.p) || 61);
        var q = BigInt((params && params.q) || 53);
        var e = BigInt((params && params.e) || 17);
        var n = p * q;
        var self = this;
        var bytes = new TextEncoder().encode(input);
        var parts = [];
        for (var i = 0; i < bytes.length; i++) {
            parts.push(self._modPow(BigInt(bytes[i]), e, n).toString());
        }
        return parts.join(',') + '|' + n.toString() + '|' + e.toString();
    },
    decode: function(input, params) {
        var mainParts = input.split('|');
        var cipherParts = mainParts[0].split(',');
        var n = BigInt(mainParts[1]);
        var e = BigInt(mainParts[2]);
        var p = BigInt((params && params.p) || 61);
        var q = BigInt((params && params.q) || 53);
        var phi = (p - 1n) * (q - 1n);
        var d = this._modInverse(e, phi);
        var self = this;
        var bytes = new Uint8Array(cipherParts.length);
        for (var i = 0; i < cipherParts.length; i++) {
            bytes[i] = Number(self._modPow(BigInt(cipherParts[i]), d, n));
        }
        return new TextDecoder().decode(bytes);
    }
};

/* ========== ADFGVX cipher (WW1 fractionation) ========== */
steps.adfgvx = {
    _LABELS: ['A', 'D', 'F', 'G', 'V', 'X'],
    _GRID: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    _buildGrid: function(key) {
        key = (key || '').toUpperCase().replace(/[^A-Z0-9]/g, '');
        var seen = {};
        var grid = '';
        var src = key + this._GRID;
        for (var i = 0; i < src.length; i++) {
            if (!seen[src[i]]) { grid += src[i]; seen[src[i]] = true; }
        }
        return grid;
    },
    encode: function(input, params) {
        var grid = this._buildGrid(params && params.gridKey);
        var transKey = ((params && params.key) || 'CIPHER').toUpperCase();
        var labels = this._LABELS;
        var text = input.toUpperCase().replace(/[^A-Z0-9]/g, '');
        var fractionated = '';
        for (var i = 0; i < text.length; i++) {
            var idx = grid.indexOf(text[i]);
            if (idx < 0) continue;
            fractionated += labels[Math.floor(idx / 6)] + labels[idx % 6];
        }
        var cols = transKey.length;
        var rows = Math.ceil(fractionated.length / cols);
        var order = [];
        for (var c = 0; c < cols; c++) order.push({ ch: transKey[c], idx: c });
        order.sort(function(a, b) { return a.ch < b.ch ? -1 : a.ch > b.ch ? 1 : a.idx - b.idx; });
        var out = '';
        for (var k = 0; k < order.length; k++) {
            var col = order[k].idx;
            for (var r = 0; r < rows; r++) {
                var pos = r * cols + col;
                out += pos < fractionated.length ? fractionated[pos] : '';
            }
            out += ' ';
        }
        return out.trim();
    },
    decode: function(input, params) {
        var grid = this._buildGrid(params && params.gridKey);
        var transKey = ((params && params.key) || 'CIPHER').toUpperCase();
        var labels = this._LABELS;
        var cipherChars = input.replace(/\s+/g, '').split('');
        var cols = transKey.length;
        var totalLen = cipherChars.length;
        var rows = Math.ceil(totalLen / cols);
        var remainder = totalLen % cols || cols;
        var order = [];
        for (var c = 0; c < cols; c++) order.push({ ch: transKey[c], idx: c });
        order.sort(function(a, b) { return a.ch < b.ch ? -1 : a.ch > b.ch ? 1 : a.idx - b.idx; });
        var table = [];
        for (var r = 0; r < rows; r++) { table.push(new Array(cols).fill('')); }
        var pos = 0;
        for (var k = 0; k < order.length; k++) {
            var col = order[k].idx;
            var colLen = col < remainder ? rows : rows - 1;
            for (var r2 = 0; r2 < colLen && pos < totalLen; r2++) {
                table[r2][col] = cipherChars[pos++];
            }
        }
        var fractionated = '';
        for (var r3 = 0; r3 < rows; r3++) {
            for (var c2 = 0; c2 < cols; c2++) fractionated += table[r3][c2];
        }
        var out = '';
        for (var i = 0; i < fractionated.length; i += 2) {
            var ri = labels.indexOf(fractionated[i]);
            var ci = labels.indexOf(fractionated[i + 1]);
            if (ri >= 0 && ci >= 0) out += grid[ri * 6 + ci];
        }
        return out;
    }
};

/* ========== Nihilist cipher (Polybius + modular addition) ========== */
steps.nihilist = {
    _GRID: 'ABCDEFGHIKLMNOPQRSTUVWXYZ',
    _toNum: function(grid, c) {
        c = c.toUpperCase();
        if (c === 'J') c = 'I';
        var idx = grid.indexOf(c);
        if (idx < 0) return -1;
        return (Math.floor(idx / 5) + 1) * 10 + (idx % 5) + 1;
    },
    _fromNum: function(grid, n) {
        var row = Math.floor(n / 10) - 1;
        var col = (n % 10) - 1;
        if (row < 0 || row > 4 || col < 0 || col > 4) return '';
        return grid[row * 5 + col];
    },
    encode: function(input, params) {
        var grid = this._GRID;
        var key = ((params && params.key) || 'KEY').toUpperCase();
        var text = input.toUpperCase().replace(/J/g, 'I').replace(/[^A-Z]/g, '');
        var keyNums = [];
        for (var k = 0; k < key.length; k++) keyNums.push(this._toNum(grid, key[k]));
        var parts = [];
        for (var i = 0; i < text.length; i++) {
            parts.push(this._toNum(grid, text[i]) + keyNums[i % keyNums.length]);
        }
        return parts.join(' ');
    },
    decode: function(input, params) {
        var grid = this._GRID;
        var key = ((params && params.key) || 'KEY').toUpperCase();
        var keyNums = [];
        for (var k = 0; k < key.length; k++) keyNums.push(this._toNum(grid, key[k]));
        var parts = input.trim().split(/\s+/);
        var out = '';
        for (var i = 0; i < parts.length; i++) {
            var val = parseInt(parts[i], 10) - keyNums[i % keyNums.length];
            out += this._fromNum(grid, val);
        }
        return out;
    }
};

global.CTFSteps = steps;

})(typeof window !== 'undefined' ? window : (typeof global !== 'undefined' ? global : this));
