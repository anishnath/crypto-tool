/**
 * Collatz Conjecture - Export Module
 * Share URL encoding/decoding
 */
(function() {
'use strict';

// ==================== Share URL ====================

function buildShareUrl(startNumber) {
    var data = { n: startNumber };
    var encoded = btoa(JSON.stringify(data));
    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (d) {
        try {
            return JSON.parse(atob(d));
        } catch (e) {
            return null;
        }
    }
    return null;
}

function copyShareUrl(startNumber) {
    var url = buildShareUrl(startNumber);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url);
    }
}

window.CollatzExport = {
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl
};

})();
