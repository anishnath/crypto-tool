/* hexdump-export.js — Export, clipboard, share
   Exposes: window.HexExport */
(function() {
    'use strict';

    var HexExport = {};

    /**
     * Copy text to clipboard with fallback.
     * @param {string} text
     * @param {function} [onDone] - callback(success)
     */
    HexExport.copyToClipboard = function(text, onDone) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).then(function() {
                if (onDone) onDone(true);
            }, function() {
                fallbackCopy(text, onDone);
            });
        } else {
            fallbackCopy(text, onDone);
        }
    };

    function fallbackCopy(text, onDone) {
        var ta = document.createElement('textarea');
        ta.value = text;
        ta.style.position = 'fixed';
        ta.style.opacity = '0';
        document.body.appendChild(ta);
        ta.select();
        var ok = false;
        try { ok = document.execCommand('copy'); } catch (e) { ok = false; }
        document.body.removeChild(ta);
        if (onDone) onDone(ok);
    }

    /**
     * Download content as a file.
     * @param {string} content
     * @param {string} filename
     * @param {string} [mimeType='text/plain']
     */
    HexExport.downloadFile = function(content, filename, mimeType) {
        var blob = new Blob([content], { type: mimeType || 'text/plain' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.style.display = 'none';
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }, 100);
    };

    /**
     * Build a plain-text hex dump for copy/download.
     * @param {Uint8Array} data
     * @param {Object} options - { format, bytesPerLine, grouping, showAscii, showOffset }
     * @returns {string}
     */
    HexExport.buildPlainText = function(data, options) {
        var E = window.HexEngine;
        var bpl = options.bytesPerLine || 16;
        var format = options.format || 'hex';
        var grouping = options.grouping || 1;
        var showAscii = options.showAscii !== false;
        var showOffset = options.showOffset !== false;

        var lines = [];
        for (var i = 0; i < data.length; i += bpl) {
            var parts = [];

            if (showOffset) {
                parts.push(E.formatOffset(i, data.length));
            }

            var bytes = [];
            for (var j = 0; j < bpl; j++) {
                var idx = i + j;
                if (idx < data.length) {
                    bytes.push(E.formatByte(data[idx], format));
                } else {
                    var padLen = (format === 'bin') ? 8 : (format === 'hex' ? 2 : 3);
                    var pad = '';
                    for (var p = 0; p < padLen; p++) pad += ' ';
                    bytes.push(pad);
                }
                if (grouping > 0 && (j + 1) % grouping === 0 && j < bpl - 1) {
                    bytes.push('');
                }
            }
            parts.push(bytes.join(' '));

            if (showAscii) {
                var ascii = '';
                for (var k = 0; k < bpl; k++) {
                    var idx2 = i + k;
                    if (idx2 < data.length) {
                        ascii += E.getAsciiChar(data[idx2]);
                    }
                }
                parts.push('|' + ascii + '|');
            }

            lines.push(parts.join('  '));
        }
        return lines.join('\n');
    };

    /**
     * Build a shareable URL with data encoded.
     * Only for small data (<2KB).
     * @param {Object} state - { data, format, bytesPerLine, ... }
     * @returns {string|null} null if data too large
     */
    HexExport.buildShareUrl = function(state) {
        if (!state.data || state.data.length > 2048) return null;

        var hexStr = '';
        for (var i = 0; i < state.data.length; i++) {
            hexStr += ('0' + state.data[i].toString(16)).slice(-2);
        }

        var params = [];
        params.push('d=' + hexStr);
        if (state.format && state.format !== 'hex') params.push('f=' + state.format);
        if (state.bytesPerLine && state.bytesPerLine !== 16) params.push('bpl=' + state.bytesPerLine);

        var base = window.location.origin + window.location.pathname;
        return base + '?' + params.join('&');
    };

    /**
     * Download binary data as a file.
     * @param {Uint8Array} data
     * @param {string} filename
     */
    HexExport.downloadBinary = function(data, filename) {
        var blob = new Blob([data], { type: 'application/octet-stream' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.style.display = 'none';
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }, 100);
    };

    window.HexExport = HexExport;
})();
