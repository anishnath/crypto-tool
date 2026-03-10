/**
 * Pastebin Transforms — baked-in encode/decode/hash/format operations.
 *
 * Operates on the textarea content in-place with undo history.
 * One-way ops (hashes) output to a result strip below the toolbar.
 */
(function() {
    'use strict';

    var $textarea = document.getElementById('pb-content');
    var $toolbar  = document.getElementById('pb-transforms');
    var $output   = document.getElementById('pb-transform-output');
    var $undoBtn  = document.getElementById('pb-transform-undo');

    if (!$textarea || !$toolbar) return;

    // ── Undo history ──
    var history = [];
    var MAX_HISTORY = 30;

    function pushHistory() {
        history.push($textarea.value);
        if (history.length > MAX_HISTORY) history.shift();
        $undoBtn.disabled = false;
    }

    $undoBtn.addEventListener('click', function() {
        if (!history.length) return;
        $textarea.value = history.pop();
        $textarea.dispatchEvent(new Event('input'));
        if (!history.length) $undoBtn.disabled = true;
        showOutput('Undo applied');
    });

    // ── Transform registry ──
    // Each transform: { name, group, fn(input) → string|Promise<string>, outputOnly? }
    // outputOnly=true means result goes to output strip, not textarea
    var transforms = [];

    function register(name, group, fn, opts) {
        transforms.push({ name: name, group: group, fn: fn, outputOnly: (opts && opts.outputOnly) || false, prompt: (opts && opts.prompt) || null });
    }

    // ═══════════════════════════════════════════
    //  ENCODING / DECODING
    // ═══════════════════════════════════════════

    register('Base64 Encode', 'Encode/Decode', function(t) {
        return btoa(unescape(encodeURIComponent(t)));
    });
    register('Base64 Decode', 'Encode/Decode', function(t) {
        try { return decodeURIComponent(escape(atob(t.trim()))); }
        catch(e) { throw new Error('Invalid Base64 input'); }
    });
    register('URL Encode', 'Encode/Decode', function(t) {
        return encodeURIComponent(t);
    });
    register('URL Decode', 'Encode/Decode', function(t) {
        try { return decodeURIComponent(t); }
        catch(e) { throw new Error('Invalid URL-encoded input'); }
    });
    register('HTML Encode', 'Encode/Decode', function(t) {
        var d = document.createElement('div');
        d.textContent = t;
        return d.innerHTML;
    });
    register('HTML Decode', 'Encode/Decode', function(t) {
        var d = document.createElement('div');
        d.innerHTML = t;
        return d.textContent;
    });
    register('Hex Encode', 'Encode/Decode', function(t) {
        var hex = '';
        for (var i = 0; i < t.length; i++) {
            hex += t.charCodeAt(i).toString(16).padStart(2, '0');
        }
        return hex;
    });
    register('Hex Decode', 'Encode/Decode', function(t) {
        var s = t.replace(/\s+/g, '');
        if (!/^[0-9a-fA-F]*$/.test(s) || s.length % 2 !== 0) throw new Error('Invalid hex input');
        var out = '';
        for (var i = 0; i < s.length; i += 2) {
            out += String.fromCharCode(parseInt(s.substr(i, 2), 16));
        }
        return out;
    });
    register('Base32 Encode', 'Encode/Decode', function(t) {
        var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        var bytes = new TextEncoder().encode(t);
        var bits = '';
        bytes.forEach(function(b) { bits += b.toString(2).padStart(8, '0'); });
        while (bits.length % 5) bits += '0';
        var out = '';
        for (var i = 0; i < bits.length; i += 5) {
            out += alphabet[parseInt(bits.substr(i, 5), 2)];
        }
        while (out.length % 8) out += '=';
        return out;
    });
    register('Base32 Decode', 'Encode/Decode', function(t) {
        var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        var s = t.replace(/=+$/, '').toUpperCase();
        var bits = '';
        for (var i = 0; i < s.length; i++) {
            var idx = alphabet.indexOf(s[i]);
            if (idx < 0) throw new Error('Invalid Base32 character: ' + s[i]);
            bits += idx.toString(2).padStart(5, '0');
        }
        var bytes = [];
        for (var j = 0; j + 8 <= bits.length; j += 8) {
            bytes.push(parseInt(bits.substr(j, 8), 2));
        }
        return new TextDecoder().decode(new Uint8Array(bytes));
    });
    register('Hex Dump', 'Encode/Decode', function(t) {
        var bytes = new TextEncoder().encode(t);
        var lines = [];
        for (var i = 0; i < bytes.length; i += 16) {
            var offset = i.toString(16).padStart(8, '0');
            var hexParts = [];
            var ascii = '';
            for (var j = 0; j < 16; j++) {
                if (i + j < bytes.length) {
                    hexParts.push(bytes[i + j].toString(16).padStart(2, '0'));
                    var c = bytes[i + j];
                    ascii += (c >= 32 && c <= 126) ? String.fromCharCode(c) : '.';
                } else {
                    hexParts.push('  ');
                    ascii += ' ';
                }
            }
            var hex = hexParts.slice(0, 8).join(' ') + '  ' + hexParts.slice(8).join(' ');
            lines.push(offset + '  ' + hex + '  |' + ascii + '|');
        }
        return lines.join('\n');
    });
    register('Binary Encode', 'Encode/Decode', function(t) {
        var out = '';
        for (var i = 0; i < t.length; i++) {
            if (i > 0) out += ' ';
            out += t.charCodeAt(i).toString(2).padStart(8, '0');
        }
        return out;
    });
    register('Binary Decode', 'Encode/Decode', function(t) {
        var bytes = t.trim().split(/\s+/);
        var out = '';
        for (var i = 0; i < bytes.length; i++) {
            if (!/^[01]+$/.test(bytes[i])) throw new Error('Invalid binary at position ' + (i + 1));
            out += String.fromCharCode(parseInt(bytes[i], 2));
        }
        return out;
    });
    register('Decimal → Hex', 'Convert', function(t) {
        return t.split('\n').map(function(line) {
            line = line.trim();
            if (!line) return '';
            var n = parseInt(line, 10);
            if (isNaN(n)) return line + ' (not a number)';
            return '0x' + n.toString(16).toUpperCase();
        }).join('\n');
    });
    register('Hex → Decimal', 'Convert', function(t) {
        return t.split('\n').map(function(line) {
            line = line.trim();
            if (!line) return '';
            var hex = line.replace(/^0x/i, '');
            var n = parseInt(hex, 16);
            if (isNaN(n)) return line + ' (not hex)';
            return String(n);
        }).join('\n');
    });
    register('Decimal → Binary', 'Convert', function(t) {
        return t.split('\n').map(function(line) {
            line = line.trim();
            if (!line) return '';
            var n = parseInt(line, 10);
            if (isNaN(n)) return line + ' (not a number)';
            return n.toString(2);
        }).join('\n');
    });
    register('Binary → Decimal', 'Convert', function(t) {
        return t.split('\n').map(function(line) {
            line = line.trim();
            if (!line) return '';
            if (!/^[01]+$/.test(line)) return line + ' (not binary)';
            return String(parseInt(line, 2));
        }).join('\n');
    });
    register('Decimal → Octal', 'Convert', function(t) {
        return t.split('\n').map(function(line) {
            line = line.trim();
            if (!line) return '';
            var n = parseInt(line, 10);
            if (isNaN(n)) return line + ' (not a number)';
            return '0o' + n.toString(8);
        }).join('\n');
    });
    register('Octal → Decimal', 'Convert', function(t) {
        return t.split('\n').map(function(line) {
            line = line.trim();
            if (!line) return '';
            var oct = line.replace(/^0o/i, '');
            var n = parseInt(oct, 8);
            if (isNaN(n)) return line + ' (not octal)';
            return String(n);
        }).join('\n');
    });
    register('Text → Char Codes', 'Convert', function(t) {
        var codes = [];
        for (var i = 0; i < t.length; i++) codes.push(t.charCodeAt(i));
        return codes.join(' ');
    });
    register('Char Codes → Text', 'Convert', function(t) {
        return t.trim().split(/[\s,]+/).map(function(c) {
            var n = parseInt(c, 10);
            if (isNaN(n)) throw new Error('Invalid char code: ' + c);
            return String.fromCharCode(n);
        }).join('');
    });
    register('Unicode Escape', 'Convert', function(t) {
        var out = '';
        for (var i = 0; i < t.length; i++) {
            var code = t.charCodeAt(i);
            if (code > 127) {
                out += '\\u' + code.toString(16).padStart(4, '0');
            } else {
                out += t[i];
            }
        }
        return out;
    });
    register('Unicode Unescape', 'Convert', function(t) {
        return t.replace(/\\u([0-9a-fA-F]{4})/g, function(_, hex) {
            return String.fromCharCode(parseInt(hex, 16));
        });
    });

    // ═══════════════════════════════════════════
    //  HASHING (output only — one-way)
    // ═══════════════════════════════════════════

    function hashFn(algo) {
        return function(t) {
            var buf = new TextEncoder().encode(t);
            return crypto.subtle.digest(algo, buf).then(function(hash) {
                var arr = new Uint8Array(hash);
                var hex = '';
                arr.forEach(function(b) { hex += b.toString(16).padStart(2, '0'); });
                return hex;
            });
        };
    }

    register('MD5', 'Hash', function(t) { return md5(t); }, { outputOnly: true });
    register('SHA-1', 'Hash', hashFn('SHA-1'), { outputOnly: true });
    register('SHA-256', 'Hash', hashFn('SHA-256'), { outputOnly: true });
    register('SHA-512', 'Hash', hashFn('SHA-512'), { outputOnly: true });

    register('HMAC-SHA256', 'Hash', function(t) {
        var key = window._pbTransformPromptValue;
        if (!key) throw new Error('Key is required');
        var enc = new TextEncoder();
        return crypto.subtle.importKey('raw', enc.encode(key), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign'])
            .then(function(k) { return crypto.subtle.sign('HMAC', k, enc.encode(t)); })
            .then(function(sig) {
                var arr = new Uint8Array(sig);
                var hex = '';
                arr.forEach(function(b) { hex += b.toString(16).padStart(2, '0'); });
                return hex;
            });
    }, { outputOnly: true, prompt: 'Enter HMAC key:' });

    register('CRC32', 'Hash', function(t) {
        var table = [];
        for (var i = 0; i < 256; i++) {
            var c = i;
            for (var j = 0; j < 8; j++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
            table[i] = c;
        }
        var crc = 0xFFFFFFFF;
        var bytes = new TextEncoder().encode(t);
        for (var k = 0; k < bytes.length; k++) crc = table[(crc ^ bytes[k]) & 0xFF] ^ (crc >>> 8);
        return ((crc ^ 0xFFFFFFFF) >>> 0).toString(16).padStart(8, '0');
    }, { outputOnly: true });

    // ═══════════════════════════════════════════
    //  FORMATTING
    // ═══════════════════════════════════════════

    register('JSON Prettify', 'Format', function(t) {
        try { return JSON.stringify(JSON.parse(t), null, 2); }
        catch(e) { throw new Error('Invalid JSON'); }
    });
    register('JSON Minify', 'Format', function(t) {
        try { return JSON.stringify(JSON.parse(t)); }
        catch(e) { throw new Error('Invalid JSON'); }
    });
    register('XML Prettify', 'Format', function(t) {
        // Simple XML indenter
        var formatted = '';
        var indent = 0;
        var lines = t.replace(/>\s*</g, '>\n<').split('\n');
        lines.forEach(function(line) {
            line = line.trim();
            if (!line) return;
            if (line.match(/^<\//) ) indent = Math.max(0, indent - 1);
            formatted += '  '.repeat(indent) + line + '\n';
            if (line.match(/^<[^\/!?]/) && !line.match(/\/>$/) && !line.match(/<\/[^>]+>$/)) indent++;
        });
        return formatted.trim();
    });
    register('SQL Format', 'Format', function(t) {
        // Basic SQL formatter
        var keywords = ['SELECT', 'FROM', 'WHERE', 'AND', 'OR', 'JOIN', 'LEFT JOIN',
            'RIGHT JOIN', 'INNER JOIN', 'OUTER JOIN', 'ON', 'GROUP BY', 'ORDER BY',
            'HAVING', 'LIMIT', 'OFFSET', 'INSERT INTO', 'VALUES', 'UPDATE', 'SET',
            'DELETE FROM', 'CREATE TABLE', 'ALTER TABLE', 'DROP TABLE', 'UNION', 'UNION ALL'];
        var result = t;
        keywords.forEach(function(kw) {
            var re = new RegExp('\\b' + kw.replace(/ /g, '\\s+') + '\\b', 'gi');
            result = result.replace(re, '\n' + kw);
        });
        return result.trim();
    });
    register('JSON → YAML', 'Format', function(t) {
        var obj;
        try { obj = JSON.parse(t); } catch(e) { throw new Error('Invalid JSON'); }
        return jsonToYaml(obj, 0);
    });
    register('YAML → JSON', 'Format', function(t) {
        var obj = parseSimpleYaml(t);
        return JSON.stringify(obj, null, 2);
    });
    register('CSV → JSON', 'Format', function(t) {
        var lines = t.trim().split('\n');
        if (lines.length < 2) throw new Error('Need header row + at least one data row');
        var headers = parseCsvLine(lines[0]);
        var result = [];
        for (var i = 1; i < lines.length; i++) {
            if (!lines[i].trim()) continue;
            var vals = parseCsvLine(lines[i]);
            var row = {};
            headers.forEach(function(h, idx) { row[h] = vals[idx] || ''; });
            result.push(row);
        }
        return JSON.stringify(result, null, 2);
    });
    register('JSON → CSV', 'Format', function(t) {
        var arr;
        try { arr = JSON.parse(t); } catch(e) { throw new Error('Invalid JSON'); }
        if (!Array.isArray(arr) || !arr.length) throw new Error('Need a JSON array of objects');
        var keys = Object.keys(arr[0]);
        var lines = [keys.map(csvEscape).join(',')];
        arr.forEach(function(row) {
            lines.push(keys.map(function(k) { return csvEscape(String(row[k] != null ? row[k] : '')); }).join(','));
        });
        return lines.join('\n');
    });
    register('Escape \\n \\t', 'Format', function(t) {
        return t.replace(/\\/g, '\\\\').replace(/\n/g, '\\n').replace(/\t/g, '\\t').replace(/\r/g, '\\r');
    });
    register('Unescape \\n \\t', 'Format', function(t) {
        return t.replace(/\\n/g, '\n').replace(/\\t/g, '\t').replace(/\\r/g, '\r').replace(/\\\\/g, '\\');
    });

    // ═══════════════════════════════════════════
    //  TEXT TRANSFORMS
    // ═══════════════════════════════════════════

    register('UPPERCASE', 'Text', function(t) { return t.toUpperCase(); });
    register('lowercase', 'Text', function(t) { return t.toLowerCase(); });
    register('Title Case', 'Text', function(t) {
        return t.replace(/\w\S*/g, function(w) { return w.charAt(0).toUpperCase() + w.substr(1).toLowerCase(); });
    });
    register('Sort Lines', 'Text', function(t) {
        return t.split('\n').sort().join('\n');
    });
    register('Sort Lines (desc)', 'Text', function(t) {
        return t.split('\n').sort().reverse().join('\n');
    });
    register('Remove Duplicates', 'Text', function(t) {
        var seen = {};
        return t.split('\n').filter(function(line) {
            if (seen[line]) return false;
            seen[line] = true;
            return true;
        }).join('\n');
    });
    register('Trim Lines', 'Text', function(t) {
        return t.split('\n').map(function(l) { return l.trim(); }).join('\n');
    });
    register('Remove Blank Lines', 'Text', function(t) {
        return t.split('\n').filter(function(l) { return l.trim().length > 0; }).join('\n');
    });
    register('Reverse Lines', 'Text', function(t) {
        return t.split('\n').reverse().join('\n');
    });
    register('Reverse Characters', 'Text', function(t) {
        return Array.from(t).reverse().join('');
    });
    register('Add Line Numbers', 'Text', function(t) {
        return t.split('\n').map(function(l, i) { return (i + 1) + '  ' + l; }).join('\n');
    });
    register('Remove Line Numbers', 'Text', function(t) {
        return t.split('\n').map(function(l) { return l.replace(/^\s*\d+[\s.:)\]\-|]+/, ''); }).join('\n');
    });
    register('Tabs → Spaces', 'Text', function(t) {
        var n = parseInt(window._pbTransformPromptValue, 10);
        if (isNaN(n) || n < 1 || n > 16) n = 4;
        return t.replace(/\t/g, ' '.repeat(n));
    }, { prompt: 'Spaces per tab (default 4):' });
    register('Spaces → Tabs', 'Text', function(t) {
        var n = parseInt(window._pbTransformPromptValue, 10);
        if (isNaN(n) || n < 1 || n > 16) n = 4;
        var re = new RegExp(' '.repeat(n), 'g');
        return t.replace(re, '\t');
    }, { prompt: 'Spaces per tab (default 4):' });
    register('Join Lines', 'Text', function(t) {
        var sep = window._pbTransformPromptValue || ' ';
        return t.split('\n').join(sep);
    }, { prompt: 'Separator (default: space):' });
    register('Split to Lines', 'Text', function(t) {
        var sep = window._pbTransformPromptValue || ',';
        return t.split(sep).map(function(s) { return s.trim(); }).join('\n');
    }, { prompt: 'Split on (default: comma):' });
    register('Wrap Lines', 'Text', function(t) {
        var input = window._pbTransformPromptValue || '';
        var parts = input.split('...');
        var prefix = parts[0] || '';
        var suffix = parts[1] || '';
        return t.split('\n').map(function(l) { return prefix + l + suffix; }).join('\n');
    }, { prompt: 'Prefix...Suffix (e.g. "...," or "<li>...</li>"):' });
    register('Regex Replace', 'Text', function(t) {
        var input = window._pbTransformPromptValue || '';
        var sep = input.lastIndexOf(' → ');
        if (sep < 0) sep = input.lastIndexOf('>>>');
        if (sep < 0) throw new Error('Format: pattern → replacement');
        var pattern = input.substring(0, sep).trim();
        var replacement = input.substring(sep + (input.indexOf(' → ') >= 0 ? 3 : 3)).trim();
        try {
            var re = new RegExp(pattern, 'g');
            return t.replace(re, replacement);
        } catch(e) { throw new Error('Invalid regex: ' + e.message); }
    }, { prompt: 'Pattern → Replacement (e.g. "foo → bar"):' });
    register('Count Occurrences', 'Text', function(t) {
        var pattern = window._pbTransformPromptValue;
        if (!pattern) throw new Error('Search text is required');
        var count = 0;
        var idx = -1;
        while ((idx = t.indexOf(pattern, idx + 1)) !== -1) count++;
        return 'Found ' + count + ' occurrence' + (count !== 1 ? 's' : '') + ' of "' + pattern + '"';
    }, { outputOnly: true, prompt: 'Text to count:' });

    // ═══════════════════════════════════════════
    //  EXTRACT (output only)
    // ═══════════════════════════════════════════

    register('Extract URLs', 'Extract', function(t) {
        var urls = t.match(/https?:\/\/[^\s<>"')\]]+/g);
        if (!urls || !urls.length) return '(no URLs found)';
        // Deduplicate
        var unique = urls.filter(function(u, i) { return urls.indexOf(u) === i; });
        return unique.join('\n');
    });
    register('Extract Emails', 'Extract', function(t) {
        var emails = t.match(/[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}/g);
        if (!emails || !emails.length) return '(no emails found)';
        var unique = emails.filter(function(e, i) { return emails.indexOf(e) === i; });
        return unique.join('\n');
    });
    register('Extract IPs', 'Extract', function(t) {
        var ips = t.match(/\b(?:\d{1,3}\.){3}\d{1,3}\b/g);
        if (!ips || !ips.length) return '(no IPs found)';
        var unique = ips.filter(function(ip, i) { return ips.indexOf(ip) === i; });
        return unique.join('\n');
    });
    register('Extract Numbers', 'Extract', function(t) {
        var nums = t.match(/-?\d+\.?\d*/g);
        if (!nums || !nums.length) return '(no numbers found)';
        return nums.join('\n');
    });
    register('Extract JSON Keys', 'Extract', function(t) {
        var obj;
        try { obj = JSON.parse(t); } catch(e) { throw new Error('Invalid JSON'); }
        function getKeys(o, prefix) {
            var result = [];
            for (var k in o) {
                var path = prefix ? prefix + '.' + k : k;
                result.push(path);
                if (typeof o[k] === 'object' && o[k] !== null && !Array.isArray(o[k])) {
                    result = result.concat(getKeys(o[k], path));
                }
            }
            return result;
        }
        return getKeys(obj, '').join('\n');
    });
    register('Extract Hex Colors', 'Extract', function(t) {
        var colors = t.match(/#[0-9a-fA-F]{3,8}\b/g);
        if (!colors || !colors.length) return '(no hex colors found)';
        var unique = colors.filter(function(c, i) { return colors.indexOf(c) === i; });
        return unique.join('\n');
    });

    // ═══════════════════════════════════════════
    //  CRYPTO
    // ═══════════════════════════════════════════

    register('ROT13', 'Crypto', function(t) {
        return t.replace(/[a-zA-Z]/g, function(c) {
            var base = c <= 'Z' ? 65 : 97;
            return String.fromCharCode((c.charCodeAt(0) - base + 13) % 26 + base);
        });
    });
    register('Caesar Cipher', 'Crypto', function(t) {
        var shift = parseInt(window._pbTransformPromptValue, 10);
        if (isNaN(shift)) throw new Error('Shift must be a number');
        shift = ((shift % 26) + 26) % 26;
        return t.replace(/[a-zA-Z]/g, function(c) {
            var base = c <= 'Z' ? 65 : 97;
            return String.fromCharCode((c.charCodeAt(0) - base + shift) % 26 + base);
        });
    }, { prompt: 'Enter shift (1-25):' });
    register('Atbash', 'Crypto', function(t) {
        return t.replace(/[a-zA-Z]/g, function(c) {
            var base = c <= 'Z' ? 65 : 97;
            return String.fromCharCode(base + 25 - (c.charCodeAt(0) - base));
        });
    });
    register('Morse Encode', 'Crypto', function(t) {
        var m = {'A':'.-','B':'-...','C':'-.-.','D':'-..','E':'.','F':'..-.','G':'--.','H':'....','I':'..','J':'.---','K':'-.-','L':'.-..','M':'--','N':'-.','O':'---','P':'.--.','Q':'--.-','R':'.-.','S':'...','T':'-','U':'..-','V':'...-','W':'.--','X':'-..-','Y':'-.--','Z':'--..','0':'-----','1':'.----','2':'..---','3':'...--','4':'....-','5':'.....','6':'-....','7':'--...','8':'---..','9':'----.',' ':' / '};
        return t.toUpperCase().split('').map(function(c) { return m[c] || c; }).join(' ');
    });
    register('Morse Decode', 'Crypto', function(t) {
        var m = {'.-':'A','-...':'B','-.-.':'C','-..':'D','.':'E','..-.':'F','--.':'G','....':'H','..':'I','.---':'J','-.-':'K','.-..':'L','--':'M','-.':'N','---':'O','.--.':'P','--.-':'Q','.-.':'R','...':'S','-':'T','..-':'U','...-':'V','.--':'W','-..-':'X','-.--':'Y','--..':'Z','-----':'0','.----':'1','..---':'2','...--':'3','....-':'4','.....':'5','-....':'6','--...':'7','---..':'8','----.':'9'};
        return t.split(' / ').map(function(word) {
            return word.trim().split(/\s+/).map(function(c) { return m[c] || c; }).join('');
        }).join(' ');
    });
    register('JWT Decode', 'Crypto', function(t) {
        var parts = t.trim().split('.');
        if (parts.length < 2) throw new Error('Not a valid JWT (need at least 2 parts)');
        function b64url(s) {
            s = s.replace(/-/g, '+').replace(/_/g, '/');
            while (s.length % 4) s += '=';
            return decodeURIComponent(escape(atob(s)));
        }
        var header = JSON.parse(b64url(parts[0]));
        var payload = JSON.parse(b64url(parts[1]));
        return JSON.stringify({ header: header, payload: payload }, null, 2);
    });

    // ── AES-GCM Encrypt/Decrypt via Web Crypto API ──

    function deriveKey(passphrase, salt) {
        var enc = new TextEncoder();
        return crypto.subtle.importKey('raw', enc.encode(passphrase), 'PBKDF2', false, ['deriveKey'])
            .then(function(baseKey) {
                return crypto.subtle.deriveKey(
                    { name: 'PBKDF2', salt: salt, iterations: 100000, hash: 'SHA-256' },
                    baseKey,
                    { name: 'AES-GCM', length: 256 },
                    false,
                    ['encrypt', 'decrypt']
                );
            });
    }

    function bufToBase64(buf) {
        var arr = new Uint8Array(buf);
        var bin = '';
        arr.forEach(function(b) { bin += String.fromCharCode(b); });
        return btoa(bin);
    }

    function base64ToBuf(b64) {
        var bin = atob(b64);
        var arr = new Uint8Array(bin.length);
        for (var i = 0; i < bin.length; i++) arr[i] = bin.charCodeAt(i);
        return arr.buffer;
    }

    register('AES-256 Encrypt', 'Crypto', function(t) {
        var passphrase = window._pbTransformPromptValue;
        if (!passphrase) throw new Error('Passphrase is required');
        var enc = new TextEncoder();
        var salt = crypto.getRandomValues(new Uint8Array(16));
        var iv = crypto.getRandomValues(new Uint8Array(12));
        return deriveKey(passphrase, salt)
            .then(function(key) {
                return crypto.subtle.encrypt({ name: 'AES-GCM', iv: iv }, key, enc.encode(t));
            })
            .then(function(ciphertext) {
                // Format: base64(salt):base64(iv):base64(ciphertext)
                return bufToBase64(salt) + ':' + bufToBase64(iv) + ':' + bufToBase64(ciphertext);
            });
    }, { prompt: 'Enter encryption passphrase:' });

    register('AES-256 Decrypt', 'Crypto', function(t) {
        var passphrase = window._pbTransformPromptValue;
        if (!passphrase) throw new Error('Passphrase is required');
        var parts = t.trim().split(':');
        if (parts.length !== 3) throw new Error('Invalid ciphertext format (expected salt:iv:data)');
        var salt, iv, ciphertext;
        try {
            salt = new Uint8Array(base64ToBuf(parts[0]));
            iv = new Uint8Array(base64ToBuf(parts[1]));
            ciphertext = base64ToBuf(parts[2]);
        } catch(e) {
            throw new Error('Invalid Base64 in ciphertext');
        }
        return deriveKey(passphrase, salt)
            .then(function(key) {
                return crypto.subtle.decrypt({ name: 'AES-GCM', iv: iv }, key, ciphertext);
            })
            .then(function(plaintext) {
                return new TextDecoder().decode(plaintext);
            })
            .catch(function(e) {
                if (e.name === 'OperationError') throw new Error('Decryption failed — wrong passphrase or corrupted data');
                throw e;
            });
    }, { prompt: 'Enter decryption passphrase:' });

    // ── RSA Key Pair Generation (output only) ──

    register('RSA Generate Keypair', 'Crypto', function() {
        return crypto.subtle.generateKey(
            { name: 'RSA-OAEP', modulusLength: 2048, publicExponent: new Uint8Array([1, 0, 1]), hash: 'SHA-256' },
            true, ['encrypt', 'decrypt']
        ).then(function(keyPair) {
            return Promise.all([
                crypto.subtle.exportKey('spki', keyPair.publicKey),
                crypto.subtle.exportKey('pkcs8', keyPair.privateKey)
            ]);
        }).then(function(keys) {
            function pemWrap(label, buf) {
                var b64 = bufToBase64(buf);
                var lines = [];
                for (var i = 0; i < b64.length; i += 64) lines.push(b64.substring(i, i + 64));
                return '-----BEGIN ' + label + '-----\n' + lines.join('\n') + '\n-----END ' + label + '-----';
            }
            return pemWrap('PUBLIC KEY', keys[0]) + '\n\n' + pemWrap('PRIVATE KEY', keys[1]);
        });
    });

    // ── ECDSA Key Pair Generation ──

    register('ECDSA Generate Keypair', 'Crypto', function() {
        return crypto.subtle.generateKey(
            { name: 'ECDSA', namedCurve: 'P-256' },
            true, ['sign', 'verify']
        ).then(function(keyPair) {
            return Promise.all([
                crypto.subtle.exportKey('spki', keyPair.publicKey),
                crypto.subtle.exportKey('pkcs8', keyPair.privateKey)
            ]);
        }).then(function(keys) {
            function pemWrap(label, buf) {
                var b64 = bufToBase64(buf);
                var lines = [];
                for (var i = 0; i < b64.length; i += 64) lines.push(b64.substring(i, i + 64));
                return '-----BEGIN ' + label + '-----\n' + lines.join('\n') + '\n-----END ' + label + '-----';
            }
            return pemWrap('PUBLIC KEY', keys[0]) + '\n\n' + pemWrap('PRIVATE KEY', keys[1]);
        });
    });

    // ── Random password/token generation ──

    register('Generate Password', 'Crypto', function() {
        var len = parseInt(window._pbTransformPromptValue, 10);
        if (isNaN(len) || len < 4 || len > 256) throw new Error('Length must be 4-256');
        var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:,.<>?';
        var arr = crypto.getRandomValues(new Uint8Array(len));
        var pwd = '';
        for (var i = 0; i < len; i++) pwd += chars[arr[i] % chars.length];
        return pwd;
    }, { prompt: 'Password length (4-256):' });

    register('Generate UUID', 'Crypto', function() {
        return crypto.randomUUID ? crypto.randomUUID() : (
            // Fallback for older browsers
            'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = crypto.getRandomValues(new Uint8Array(1))[0] % 16;
                return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
            })
        );
    });

    register('Random Hex Token', 'Crypto', function() {
        var len = parseInt(window._pbTransformPromptValue, 10);
        if (isNaN(len) || len < 1 || len > 256) throw new Error('Length must be 1-256 bytes');
        var arr = crypto.getRandomValues(new Uint8Array(len));
        var hex = '';
        arr.forEach(function(b) { hex += b.toString(16).padStart(2, '0'); });
        return hex;
    }, { prompt: 'Token length in bytes (e.g. 32):' });

    // ═══════════════════════════════════════════
    //  ANALYSIS (output only)
    // ═══════════════════════════════════════════

    register('Stats', 'Analyze', function(t) {
        var chars = t.length;
        var words = t.trim() ? t.trim().split(/\s+/).length : 0;
        var lines = t.split('\n').length;
        var bytes = new TextEncoder().encode(t).length;
        return 'Characters: ' + chars.toLocaleString() +
               '  |  Words: ' + words.toLocaleString() +
               '  |  Lines: ' + lines.toLocaleString() +
               '  |  Bytes: ' + formatBytes(bytes);
    }, { outputOnly: true });

    register('Detect Encoding', 'Analyze', function(t) {
        var s = t.trim();
        var results = [];
        // Base64?
        if (/^[A-Za-z0-9+/\n\r]+=*$/.test(s) && s.length > 3 && s.length % 4 === 0) {
            try { atob(s.replace(/\s/g, '')); results.push('Base64'); } catch(e) {}
        }
        // Hex?
        if (/^[0-9a-fA-F\s]+$/.test(s) && s.replace(/\s/g, '').length % 2 === 0 && s.length > 1) results.push('Hex');
        // URL-encoded?
        if (/%[0-9a-fA-F]{2}/.test(s)) results.push('URL-encoded');
        // JWT?
        if (/^eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+/.test(s)) results.push('JWT');
        // JSON?
        try { JSON.parse(s); results.push('JSON'); } catch(e) {}
        // HTML?
        if (/<\/?[a-z][\s\S]*>/i.test(s)) results.push('HTML');
        // XML?
        if (/^<\?xml/i.test(s)) results.push('XML');
        // Binary?
        if (/^[01]{8}(\s+[01]{8})*$/.test(s)) results.push('Binary');
        // YAML?
        if (/^[a-zA-Z_][a-zA-Z0-9_]*\s*:/.test(s) && !/<\/?[a-z]/i.test(s)) results.push('YAML');
        // CSV?
        var csvLines = s.split('\n');
        if (csvLines.length > 1 && csvLines[0].indexOf(',') > -1) {
            var commaCount = (csvLines[0].match(/,/g) || []).length;
            var consistent = csvLines.slice(1, 4).every(function(l) { return l.trim() === '' || (l.match(/,/g) || []).length === commaCount; });
            if (consistent && commaCount > 0) results.push('CSV');
        }
        // Morse?
        if (/^[\.\-\s\/]+$/.test(s) && /[\.\-]{1,6}/.test(s)) results.push('Morse code');

        if (results.length === 0) results.push('Plain text (no encoding detected)');
        return 'Detected: ' + results.join(', ');
    }, { outputOnly: true });

    // ═══════════════════════════════════════════
    //  YAML helpers (simple — covers most common cases)
    // ═══════════════════════════════════════════

    function jsonToYaml(obj, indent) {
        var pad = '  '.repeat(indent);
        if (obj === null) return 'null';
        if (typeof obj === 'boolean') return obj ? 'true' : 'false';
        if (typeof obj === 'number') return String(obj);
        if (typeof obj === 'string') {
            if (/[\n:#{}[\],&*?|>!%@`]/.test(obj) || obj.trim() !== obj || obj === '') {
                return '"' + obj.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n') + '"';
            }
            return obj;
        }
        if (Array.isArray(obj)) {
            if (obj.length === 0) return '[]';
            return obj.map(function(item) {
                var val = jsonToYaml(item, indent + 1);
                if (typeof item === 'object' && item !== null) {
                    return pad + '- ' + val.trim().replace(/^  /, '');
                }
                return pad + '- ' + val;
            }).join('\n');
        }
        var keys = Object.keys(obj);
        if (keys.length === 0) return '{}';
        return keys.map(function(key) {
            var val = obj[key];
            var yamlVal = jsonToYaml(val, indent + 1);
            if (typeof val === 'object' && val !== null && !Array.isArray(val) && Object.keys(val).length > 0) {
                return pad + key + ':\n' + yamlVal;
            }
            if (Array.isArray(val) && val.length > 0) {
                return pad + key + ':\n' + yamlVal;
            }
            return pad + key + ': ' + yamlVal;
        }).join('\n');
    }

    function parseSimpleYaml(text) {
        var lines = text.split('\n');
        var root = {};
        var stack = [{ obj: root, indent: -1 }];

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            if (!line.trim() || line.trim().charAt(0) === '#') continue;

            var indent = line.search(/\S/);
            var content = line.trim();

            // Pop stack to find parent
            while (stack.length > 1 && stack[stack.length - 1].indent >= indent) stack.pop();

            var parent = stack[stack.length - 1];

            // Array item
            if (content.charAt(0) === '-') {
                var arrVal = content.substring(1).trim();
                if (!Array.isArray(parent.obj)) {
                    // Convert parent's last key value to array
                    var lastKey = parent.lastKey;
                    if (lastKey && !Array.isArray(parent.obj[lastKey])) {
                        parent.obj[lastKey] = [];
                    }
                    if (lastKey) {
                        parent.obj[lastKey].push(parseYamlValue(arrVal));
                        stack.push({ obj: parent.obj[lastKey], indent: indent, lastKey: null });
                    }
                } else {
                    parent.obj.push(parseYamlValue(arrVal));
                }
                continue;
            }

            // Key: value
            var colonIdx = content.indexOf(':');
            if (colonIdx > 0) {
                var key = content.substring(0, colonIdx).trim();
                var val = content.substring(colonIdx + 1).trim();
                if (val === '' || val === '|' || val === '>') {
                    // Nested object or block scalar
                    parent.obj[key] = {};
                    stack.push({ obj: parent.obj[key], indent: indent, lastKey: null });
                    parent.lastKey = key;
                } else {
                    parent.obj[key] = parseYamlValue(val);
                    parent.lastKey = key;
                }
            }
        }
        return root;
    }

    function parseYamlValue(s) {
        if (s === 'true') return true;
        if (s === 'false') return false;
        if (s === 'null' || s === '~') return null;
        if (/^-?\d+$/.test(s)) return parseInt(s, 10);
        if (/^-?\d+\.\d+$/.test(s)) return parseFloat(s);
        // Strip quotes
        if ((s.charAt(0) === '"' && s.charAt(s.length - 1) === '"') ||
            (s.charAt(0) === "'" && s.charAt(s.length - 1) === "'")) {
            return s.substring(1, s.length - 1);
        }
        return s;
    }

    // ═══════════════════════════════════════════
    //  CSV helpers
    // ═══════════════════════════════════════════

    function parseCsvLine(line) {
        var result = [];
        var current = '';
        var inQuotes = false;
        for (var i = 0; i < line.length; i++) {
            var c = line[i];
            if (inQuotes) {
                if (c === '"' && line[i + 1] === '"') { current += '"'; i++; }
                else if (c === '"') { inQuotes = false; }
                else { current += c; }
            } else {
                if (c === '"') { inQuotes = true; }
                else if (c === ',') { result.push(current); current = ''; }
                else { current += c; }
            }
        }
        result.push(current);
        return result;
    }

    function csvEscape(s) {
        if (/[",\n\r]/.test(s)) return '"' + s.replace(/"/g, '""') + '"';
        return s;
    }

    // ═══════════════════════════════════════════
    //  MD5 (pure JS — SubtleCrypto doesn't do MD5)
    // ═══════════════════════════════════════════

    function md5(string) {
        function md5cycle(x, k) {
            var a = x[0], b = x[1], c = x[2], d = x[3];
            a = ff(a, b, c, d, k[0], 7, -680876936);  d = ff(d, a, b, c, k[1], 12, -389564586);
            c = ff(c, d, a, b, k[2], 17,  606105819); b = ff(b, c, d, a, k[3], 22, -1044525330);
            a = ff(a, b, c, d, k[4], 7, -176418897);  d = ff(d, a, b, c, k[5], 12,  1200080426);
            c = ff(c, d, a, b, k[6], 17, -1473231341);b = ff(b, c, d, a, k[7], 22, -45705983);
            a = ff(a, b, c, d, k[8], 7,  1770035416); d = ff(d, a, b, c, k[9], 12, -1958414417);
            c = ff(c, d, a, b, k[10], 17, -42063);    b = ff(b, c, d, a, k[11], 22, -1990404162);
            a = ff(a, b, c, d, k[12], 7,  1804603682); d = ff(d, a, b, c, k[13], 12, -40341101);
            c = ff(c, d, a, b, k[14], 17, -1502002290);b = ff(b, c, d, a, k[15], 22, 1236535329);
            a = gg(a, b, c, d, k[1], 5, -165796510); d = gg(d, a, b, c, k[6], 9, -1069501632);
            c = gg(c, d, a, b, k[11], 14, 643717713);b = gg(b, c, d, a, k[0], 20, -373897302);
            a = gg(a, b, c, d, k[5], 5, -701558691); d = gg(d, a, b, c, k[10], 9, 38016083);
            c = gg(c, d, a, b, k[15], 14, -660478335);b = gg(b, c, d, a, k[4], 20, -405537848);
            a = gg(a, b, c, d, k[9], 5, 568446438);  d = gg(d, a, b, c, k[14], 9, -1019803690);
            c = gg(c, d, a, b, k[3], 14, -187363961);b = gg(b, c, d, a, k[8], 20, 1163531501);
            a = gg(a, b, c, d, k[13], 5, -1444681467);d = gg(d, a, b, c, k[2], 9, -51403784);
            c = gg(c, d, a, b, k[7], 14, 1735328473);b = gg(b, c, d, a, k[12], 20, -1926607734);
            a = hh(a, b, c, d, k[5], 4, -378558);    d = hh(d, a, b, c, k[8], 11, -2022574463);
            c = hh(c, d, a, b, k[11], 16, 1839030562);b = hh(b, c, d, a, k[14], 23, -35309556);
            a = hh(a, b, c, d, k[1], 4, -1530992060);d = hh(d, a, b, c, k[4], 11, 1272893353);
            c = hh(c, d, a, b, k[7], 16, -155497632);b = hh(b, c, d, a, k[10], 23, -1094730640);
            a = hh(a, b, c, d, k[13], 4, 681279174); d = hh(d, a, b, c, k[0], 11, -358537222);
            c = hh(c, d, a, b, k[3], 16, -722521979);b = hh(b, c, d, a, k[6], 23, 76029189);
            a = hh(a, b, c, d, k[9], 4, -640364487); d = hh(d, a, b, c, k[12], 11, -421815835);
            c = hh(c, d, a, b, k[15], 16, 530742520);b = hh(b, c, d, a, k[2], 23, -995338651);
            a = ii(a, b, c, d, k[0], 6, -198630844); d = ii(d, a, b, c, k[7], 10, 1126891415);
            c = ii(c, d, a, b, k[14], 15, -1416354905);b = ii(b, c, d, a, k[5], 21, -57434055);
            a = ii(a, b, c, d, k[12], 6, 1700485571);d = ii(d, a, b, c, k[3], 10, -1894986606);
            c = ii(c, d, a, b, k[10], 15, -1051523);  b = ii(b, c, d, a, k[1], 21, -2054922799);
            a = ii(a, b, c, d, k[8], 6, 1873313359); d = ii(d, a, b, c, k[15], 10, -30611744);
            c = ii(c, d, a, b, k[6], 15, -1560198380);b = ii(b, c, d, a, k[13], 21, 1309151649);
            a = ii(a, b, c, d, k[4], 6, -145523070); d = ii(d, a, b, c, k[11], 10, -1120210379);
            c = ii(c, d, a, b, k[2], 15, 718787259);  b = ii(b, c, d, a, k[9], 21, -343485551);
            x[0] = add32(a, x[0]); x[1] = add32(b, x[1]); x[2] = add32(c, x[2]); x[3] = add32(d, x[3]);
        }
        function cmn(q, a, b, x, s, t) { a = add32(add32(a, q), add32(x, t)); return add32((a << s) | (a >>> (32 - s)), b); }
        function ff(a,b,c,d,x,s,t) { return cmn((b & c) | ((~b) & d), a, b, x, s, t); }
        function gg(a,b,c,d,x,s,t) { return cmn((b & d) | (c & (~d)), a, b, x, s, t); }
        function hh(a,b,c,d,x,s,t) { return cmn(b ^ c ^ d, a, b, x, s, t); }
        function ii(a,b,c,d,x,s,t) { return cmn(c ^ (b | (~d)), a, b, x, s, t); }
        function md5blk(s) {
            var md5blks = [], i;
            for (i = 0; i < 64; i += 4) md5blks[i >> 2] = s.charCodeAt(i) + (s.charCodeAt(i+1) << 8) + (s.charCodeAt(i+2) << 16) + (s.charCodeAt(i+3) << 24);
            return md5blks;
        }
        var hex_chr = '0123456789abcdef'.split('');
        function rhex(n) {
            var s = '', j = 0;
            for (; j < 4; j++) s += hex_chr[(n >> (j * 8 + 4)) & 0x0F] + hex_chr[(n >> (j * 8)) & 0x0F];
            return s;
        }
        function hex(x) { for (var i = 0; i < x.length; i++) x[i] = rhex(x[i]); return x.join(''); }
        function add32(a, b) { return (a + b) & 0xFFFFFFFF; }
        function md5str(s) {
            var n = s.length, state = [1732584193, -271733879, -1732584194, 271733878], i;
            for (i = 64; i <= n; i += 64) md5cycle(state, md5blk(s.substring(i - 64, i)));
            s = s.substring(i - 64);
            var tail = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0];
            for (i = 0; i < s.length; i++) tail[i >> 2] |= s.charCodeAt(i) << ((i % 4) << 3);
            tail[i >> 2] |= 0x80 << ((i % 4) << 3);
            if (i > 55) { md5cycle(state, tail); tail = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0]; }
            tail[14] = n * 8;
            md5cycle(state, tail);
            return state;
        }
        return hex(md5str(string));
    }

    function formatBytes(bytes) {
        if (bytes === 0) return '0 B';
        var k = 1024, sizes = ['B', 'KB', 'MB', 'GB'];
        var i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
    }

    // ═══════════════════════════════════════════
    //  BUILD TOOLBAR UI (vertical icon tabs + search)
    // ═══════════════════════════════════════════

    var groups = {};
    transforms.forEach(function(t) {
        if (!groups[t.group]) groups[t.group] = [];
        groups[t.group].push(t);
    });

    var groupOrder = ['Encode/Decode', 'Convert', 'Hash', 'Format', 'Text', 'Extract', 'Crypto', 'Analyze'];
    var $sidebar = document.getElementById('pb-transform-cats');
    var $grid = document.getElementById('pb-transform-grid');
    var $panelTitle = document.getElementById('pb-transform-panel-title');
    var $search = document.getElementById('pb-transform-search');
    var activeGroup = null;
    var allButtons = []; // { btn, transform, group }

    // SVG icons for each category (16x16 viewBox)
    var groupIcons = {
        'Encode/Decode': '<path d="M4.708 5.578L2.061 8.224l2.647 2.646-.708.708L.94 8.224 4 5.164l.708.414zm6.584 0l2.647 2.646-2.647 2.646.708.708L15.06 8.224 12 5.164l-.708.414zM6.854 11.146l1.5-7.5.984.197-1.5 7.5-.984-.197z"/>',
        'Convert':       '<path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 8A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zM8 3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 3zm0 7a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 10zm-5 0a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2A.5.5 0 0 1 3 10z"/>',
        'Hash':          '<path d="M2.5 1a.5.5 0 0 1 .5.5V4h2V1.5a.5.5 0 0 1 1 0V4h2V1.5a.5.5 0 0 1 1 0V4h1.5a.5.5 0 0 1 0 1H10v2h1.5a.5.5 0 0 1 0 1H10v2h1.5a.5.5 0 0 1 0 1H10v2.5a.5.5 0 0 1-1 0V11H7v2.5a.5.5 0 0 1-1 0V11H4v2.5a.5.5 0 0 1-1 0V11H1.5a.5.5 0 0 1 0-1H3V8H1.5a.5.5 0 0 1 0-1H3V5H1.5a.5.5 0 0 1 0-1H3V1.5a.5.5 0 0 1 .5-.5zM4 5v2h2V5H4zm3 0v2h2V5H7zM4 8v2h2V8H4zm3 0v2h2V8H7z"/>',
        'Format':        '<path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M3 4h10v1H3V4zm0 3h7v1H3V7zm0 3h10v1H3v-1z"/>',
        'Text':          '<path d="M2.5 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11zm0 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11zm0 3a.5.5 0 0 0 0 1h7a.5.5 0 0 0 0-1h-7zm0 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11z"/>',
        'Extract':       '<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>',
        'Crypto':        '<path d="M5.338 1.59a61.44 61.44 0 0 0-2.837.856.481.481 0 0 0-.328.39c-.554 4.157.726 7.19 2.253 9.188a10.725 10.725 0 0 0 2.287 2.233c.346.244.652.42.893.533.12.057.218.095.293.118a.55.55 0 0 0 .101.025.615.615 0 0 0 .1-.025c.076-.023.174-.061.294-.118.24-.113.547-.29.893-.533a10.726 10.726 0 0 0 2.287-2.233c1.527-1.997 2.807-5.031 2.253-9.188a.48.48 0 0 0-.328-.39c-.651-.213-1.75-.56-2.837-.855C9.552 1.29 8.531 1.067 8 1.067c-.53 0-1.552.223-2.662.524zM5.072.56C6.157.265 7.31 0 8 0s1.843.265 2.928.56c1.11.3 2.229.655 2.887.87a1.54 1.54 0 0 1 1.044 1.262c.596 4.477-.787 7.795-2.465 9.99a11.775 11.775 0 0 1-2.517 2.453 7.159 7.159 0 0 1-1.048.625c-.28.132-.581.24-.829.24s-.548-.108-.829-.24a7.158 7.158 0 0 1-1.048-.625 11.777 11.777 0 0 1-2.517-2.453C1.928 10.487.545 7.169 1.141 2.692A1.54 1.54 0 0 1 2.185 1.43 62.456 62.456 0 0 1 5.072.56z"/><path d="M8 4.5a.5.5 0 0 1 .5.5v2.5H11a.5.5 0 0 1 0 1H8.5V11a.5.5 0 0 1-1 0V8.5H5a.5.5 0 0 1 0-1h2.5V5a.5.5 0 0 1 .5-.5z"/>',
        'Analyze':       '<path d="M4 11H2v3h2v-3zm5-4H7v7h2V7zm5-5h-2v12h2V2zm-2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1h-2zM6 7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7zm-5 4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1v-3z"/>'
    };

    var groupLabels = {
        'Encode/Decode': 'Encode',
        'Convert': 'Convert',
        'Hash': 'Hash',
        'Format': 'Format',
        'Text': 'Text',
        'Extract': 'Extract',
        'Crypto': 'Crypto',
        'Analyze': 'Analyze'
    };

    // Build vertical icon tabs
    groupOrder.forEach(function(groupName) {
        if (!groups[groupName]) return;
        var $tab = document.createElement('button');
        $tab.type = 'button';
        $tab.className = 'pb-tc';
        $tab.title = groupName + ' (' + groups[groupName].length + ' tools)';
        $tab.dataset.group = groupName;
        $tab.innerHTML =
            '<svg width="15" height="15" fill="currentColor" viewBox="0 0 16 16">' + (groupIcons[groupName] || '') + '</svg>' +
            '<span class="pb-tc-label">' + (groupLabels[groupName] || groupName) + '</span>' +
            '<span class="pb-tc-count">' + groups[groupName].length + '</span>';
        $tab.addEventListener('click', function() { selectGroup(groupName); });
        $sidebar.appendChild($tab);
    });

    // Build all transform buttons
    groupOrder.forEach(function(groupName) {
        if (!groups[groupName]) return;
        groups[groupName].forEach(function(t) {
            var $btn = document.createElement('button');
            $btn.type = 'button';
            $btn.className = 'pb-t-btn pb-t-hidden';
            if (t.outputOnly) $btn.classList.add('pb-t-readonly');
            $btn.textContent = t.name;
            $btn.title = (t.outputOnly ? '[output only] ' : '') + t.name;
            $btn.addEventListener('click', function() { runTransform(t); });
            $grid.appendChild($btn);
            allButtons.push({ btn: $btn, transform: t, group: groupName });
        });
    });

    function selectGroup(groupName) {
        activeGroup = (activeGroup === groupName) ? null : groupName;
        // Update tab active states
        $sidebar.querySelectorAll('.pb-tc').forEach(function(t) {
            t.classList.toggle('active', t.dataset.group === activeGroup);
        });
        // Update panel title
        $panelTitle.textContent = activeGroup || '';
        // Clear search when switching groups
        if (activeGroup && $search.value) {
            $search.value = '';
        }
        renderButtons();
        try { localStorage.setItem('pb_transforms_group', activeGroup || ''); } catch(e) {}
    }

    function renderButtons() {
        var query = ($search.value || '').toLowerCase().trim();
        var isSearching = query.length > 0;
        var hasVisible = false;

        allButtons.forEach(function(item) {
            var groupMatch = isSearching || !activeGroup || item.group === activeGroup;
            var searchMatch = !query || item.transform.name.toLowerCase().indexOf(query) >= 0 ||
                              item.group.toLowerCase().indexOf(query) >= 0;
            var visible = groupMatch && searchMatch;
            item.btn.classList.toggle('pb-t-hidden', !visible);
            if (visible) hasVisible = true;
        });

        // Update panel title during search
        if (isSearching) {
            var count = allButtons.filter(function(b) { return !b.btn.classList.contains('pb-t-hidden'); }).length;
            $panelTitle.textContent = count + ' result' + (count !== 1 ? 's' : '') + ' for "' + query + '"';
        } else if (activeGroup) {
            $panelTitle.textContent = activeGroup;
        } else {
            $panelTitle.textContent = '';
        }

        // Empty state
        var $empty = $grid.querySelector('.pb-transform-empty');
        if (!hasVisible) {
            if (!$empty) {
                $empty = document.createElement('div');
                $empty.className = 'pb-transform-empty';
                $grid.appendChild($empty);
            }
            $empty.textContent = query ? 'No tools match "' + query + '"' : 'Select a category to get started';
        } else if ($empty) {
            $empty.remove();
        }
    }

    // Search
    $search.addEventListener('input', function() {
        var query = this.value.trim();
        if (query) {
            // Deselect group when searching to search across all
            activeGroup = null;
            $sidebar.querySelectorAll('.pb-tc').forEach(function(t) { t.classList.remove('active'); });
        }
        renderButtons();
    });

    // Keyboard: press / to focus search
    document.addEventListener('keydown', function(e) {
        if (e.key === '/' && document.activeElement !== $textarea && document.activeElement !== $search &&
            !document.activeElement.matches('input, textarea, select')) {
            e.preventDefault();
            if ($toolbar.classList.contains('collapsed')) $toolbar.classList.remove('collapsed');
            $search.focus();
        }
        // Esc to blur search
        if (e.key === 'Escape' && document.activeElement === $search) {
            $search.blur();
            $search.value = '';
            renderButtons();
        }
    });

    // Restore saved state
    try {
        var savedGroup = localStorage.getItem('pb_transforms_group');
        if (savedGroup && groups[savedGroup]) {
            activeGroup = savedGroup;
            $sidebar.querySelectorAll('.pb-tc').forEach(function(t) {
                t.classList.toggle('active', t.dataset.group === activeGroup);
            });
            $panelTitle.textContent = activeGroup;
        }
    } catch(e) {}
    renderButtons();

    // ═══════════════════════════════════════════
    //  EXECUTE TRANSFORM
    // ═══════════════════════════════════════════

    function showOutput(msg, isError) {
        $output.textContent = msg;
        $output.className = 'pb-transform-result show' + (isError ? ' error' : '');
        clearTimeout(showOutput._timer);
        showOutput._timer = setTimeout(function() { $output.classList.remove('show'); }, 8000);
    }

    function runTransform(t) {
        var text = $textarea.value;
        if (!text && !t.outputOnly) {
            showOutput('Nothing to transform — textarea is empty', true);
            return;
        }

        // Handle prompt (e.g. HMAC key)
        if (t.prompt) {
            var val = prompt(t.prompt);
            if (val === null) return;
            window._pbTransformPromptValue = val;
        }

        try {
            var result = t.fn(text);

            if (result && typeof result.then === 'function') {
                // Async (hashing, crypto)
                result.then(function(val) {
                    if (t.outputOnly) {
                        showOutput(t.name + ': ' + val);
                    } else {
                        pushHistory();
                        $textarea.value = val;
                        $textarea.dispatchEvent(new Event('input'));
                        showOutput(t.name + ' applied');
                    }
                }).catch(function(err) {
                    showOutput(err.message || 'Transform failed', true);
                });
            } else {
                if (t.outputOnly) {
                    showOutput(t.name + ': ' + result);
                } else {
                    pushHistory();
                    $textarea.value = result;
                    $textarea.dispatchEvent(new Event('input'));
                    showOutput(t.name + ' applied');
                }
            }
        } catch(e) {
            showOutput(e.message || 'Transform failed', true);
        } finally {
            delete window._pbTransformPromptValue;
        }
    }

    // ── Collapse toggle ──
    $toolbar.querySelectorAll('.pb-transform-toggle').forEach(function($toggle) {
        $toggle.addEventListener('click', function(e) {
            // Don't collapse when clicking the search input
            if (e.target === $search) return;
            $toolbar.classList.toggle('collapsed');
            var isCollapsed = $toolbar.classList.contains('collapsed');
            try { localStorage.setItem('pb_transforms_collapsed', isCollapsed ? '1' : '0'); } catch(e) {}
        });
    });
    // Restore collapsed state (default: collapsed)
    try {
        var savedState = localStorage.getItem('pb_transforms_collapsed');
        if (savedState !== '0') {
            $toolbar.classList.add('collapsed');
        }
    } catch(e) {
        $toolbar.classList.add('collapsed');
    }

})();
