/**
 * Steganography Tool - Render Module
 * UI rendering helpers for image info, capacity meter, results, and states
 */
(function() {
'use strict';

/**
 * Render image info rows (dimensions, capacity, filename).
 */
function renderImageInfo(filename, width, height, capacity) {
    var E = window.StegoEngine;
    var html =
        '<div class="sg-image-info">' +
            '<div class="sg-image-info-row"><span>Filename</span><span>' + E.escapeHtml(filename) + '</span></div>' +
            '<div class="sg-image-info-row"><span>Dimensions</span><span>' + width + ' x ' + height + '</span></div>';
    if (typeof capacity === 'number') {
        html += '<div class="sg-image-info-row"><span>Max capacity</span><span>' + E.formatBytes(capacity) + '</span></div>';
    }
    html += '</div>';
    return html;
}

/**
 * Render capacity meter bar + text.
 * Returns HTML string. Caller inserts into container.
 */
function renderCapacityMeter(used, total) {
    var pct = total > 0 ? Math.min((used / total) * 100, 100) : 0;
    var barClass = 'sg-capacity-bar';
    var detail = pct.toFixed(1) + '% used';
    if (pct > 90) {
        barClass += ' sg-danger';
        detail = 'Warning: Near capacity limit';
    } else if (pct > 70) {
        barClass += ' sg-warn';
    }
    var E = window.StegoEngine;
    return '<div class="sg-capacity-bar-wrap"><div class="' + barClass + '" style="width:' + pct + '%"></div></div>' +
           '<div class="sg-capacity-text"><span>' + E.formatBytes(used) + ' / ' + E.formatBytes(total) + '</span><span>' + detail + '</span></div>';
}

/**
 * Render encode success result.
 */
function renderEncodeSuccess(blobUrl, filename) {
    return '<div class="sg-result-message sg-success sg-fade-in">' +
        '<h5>Message Hidden Successfully</h5>' +
        '<p>Your secret message has been embedded in the image using LSB encoding.</p>' +
    '</div>' +
    '<canvas id="sg-result-canvas" class="sg-image-preview"></canvas>' +
    '<div class="sg-result-actions">' +
        '<button type="button" class="sg-result-btn sg-btn-primary" onclick="StegoCore.downloadResult(\'' + blobUrl + '\',\'' + filename + '\')">' +
            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>' +
            'Download PNG' +
        '</button>' +
        '<button type="button" class="sg-result-btn sg-btn-secondary" onclick="StegoCore.resetEncode()">' +
            'New Encode' +
        '</button>' +
    '</div>';
}

/**
 * Render decode success with extracted message.
 */
function renderDecodeSuccess(message) {
    var E = window.StegoEngine;
    var escaped = E.escapeHtml(message);
    return '<div class="sg-result-message sg-success sg-fade-in">' +
        '<h5>Message Extracted</h5>' +
        '<p>A hidden message was found in the image.</p>' +
    '</div>' +
    '<div class="sg-extracted-msg">' + escaped + '</div>' +
    '<div class="sg-result-actions">' +
        '<button type="button" class="sg-result-btn sg-btn-primary" id="sg-copy-msg-btn">' +
            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>' +
            'Copy Message' +
        '</button>' +
        '<button type="button" class="sg-result-btn sg-btn-secondary" onclick="StegoCore.resetDecode()">' +
            'New Decode' +
        '</button>' +
    '</div>';
}

/**
 * Render error card with suggestions list.
 */
function renderError(title, message, suggestions) {
    var E = window.StegoEngine;
    var html = '<div class="sg-result-message sg-error sg-fade-in">' +
        '<h5>' + E.escapeHtml(title) + '</h5>' +
        '<p>' + E.escapeHtml(message) + '</p>';
    if (suggestions && suggestions.length > 0) {
        html += '<ul class="sg-error-list">';
        for (var i = 0; i < suggestions.length; i++) {
            html += '<li>' + E.escapeHtml(suggestions[i]) + '</li>';
        }
        html += '</ul>';
    }
    html += '</div>';
    return html;
}

/**
 * Show animated "What is Steganography?" visual on page load.
 * A pixel grid with LSB animation, arrow, and hidden message reveal.
 */
function showEmpty(container) {
    // Generate 36 pixel colors (6x6 grid) — muted natural-looking tones
    var palette = [
        '#6ee7b7','#5eead4','#67e8f9','#7dd3fc','#93c5fd','#a5b4fc',
        '#c4b5fd','#d8b4fe','#f0abfc','#f9a8d4','#fda4af','#fecaca',
        '#fed7aa','#fde68a','#fef08a','#d9f99d','#bbf7d0','#a7f3d0',
        '#86efac','#6ee7b7','#5eead4','#67e8f9','#7dd3fc','#93c5fd',
        '#a5b4fc','#c4b5fd','#d8b4fe','#f0abfc','#f9a8d4','#fda4af',
        '#fecaca','#fed7aa','#fde68a','#fef08a','#d9f99d','#bbf7d0'
    ];
    var pixels = '';
    for (var i = 0; i < 36; i++) {
        pixels += '<div class="sg-pixel" style="background:' + palette[i] + '"></div>';
    }

    var bits = '01001000 01100101 01101100 01101100 01101111';
    var bitSpans = '';
    var bitChars = bits.split('');
    for (var j = 0; j < bitChars.length; j++) {
        if (bitChars[j] === ' ') {
            bitSpans += ' ';
        } else {
            bitSpans += '<span>' + bitChars[j] + '</span>';
        }
    }

    container.innerHTML =
        '<div class="sg-hero-visual">' +
            '<h3>What is Steganography?</h3>' +
            '<p>Hide secret messages inside ordinary images by modifying the least significant bit of each pixel. The changes are invisible to the human eye.</p>' +
            '<div class="sg-pixel-demo">' +
                '<div>' +
                    '<div class="sg-pixel-grid sg-encoding">' + pixels + '</div>' +
                    '<div class="sg-bits-stream">' + bitSpans + '</div>' +
                '</div>' +
                '<div class="sg-demo-arrow">' +
                    '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>' +
                    '<span>LSB</span>' +
                '</div>' +
                '<div class="sg-demo-message">' +
                    'Hello,<br>this is a<br>secret msg' +
                '</div>' +
            '</div>' +
            '<div class="sg-hero-steps">' +
                '<div class="sg-hero-step"><span class="sg-hero-step-num">1</span> Choose an image</div>' +
                '<div class="sg-hero-step"><span class="sg-hero-step-num">2</span> Type a message</div>' +
                '<div class="sg-hero-step"><span class="sg-hero-step-num">3</span> Hide &amp; download</div>' +
            '</div>' +
        '</div>';
}

/**
 * Show loading spinner.
 */
function showLoading(container) {
    container.innerHTML =
        '<div class="sg-loading sg-visible">' +
            '<div class="sg-spinner"></div>' +
            '<span class="sg-loading-text">Processing image data...</span>' +
        '</div>';
}

/**
 * Hide loading (replace with empty).
 */
function hideLoading(container) {
    var loading = container.querySelector('.sg-loading');
    if (loading) loading.classList.remove('sg-visible');
}

/**
 * Render forensic scan progress bar.
 */
function renderForensicProgress(current, total, foundCount) {
    var pct = total > 0 ? Math.round((current / total) * 100) : 0;
    var foundText = foundCount > 0 ? (', ' + foundCount + ' result' + (foundCount > 1 ? 's' : '') + ' found') : '';
    return '<div class="sg-forensic-progress sg-fade-in">' +
        '<div class="sg-forensic-progress-label">Scanning... ' + current + '/' + total + ' configs' + foundText + '</div>' +
        '<div class="sg-forensic-progress-track"><div class="sg-forensic-progress-bar" style="width:' + pct + '%"></div></div>' +
    '</div>';
}

/**
 * Render forensic scan results as a ranked list of cards.
 */
function renderForensicResults(results, totalConfigs, elapsedMs) {
    var E = window.StegoEngine;
    var F = window.StegoForensic;

    if (results.length === 0) {
        return '<div class="sg-result-message sg-error sg-fade-in">' +
            '<h5>No Hidden Messages Detected</h5>' +
            '<p>The forensic scanner tried ' + totalConfigs + ' extraction methods in ' + elapsedMs + 'ms but found no readable hidden data.</p>' +
            '<ul class="sg-error-list">' +
                '<li>The image may not contain any steganographic data</li>' +
                '<li>The encoding method may not be supported yet</li>' +
                '<li>The message may be encrypted — try the standard decoder with a password</li>' +
                '<li>The image may have been compressed (JPEG) after encoding, destroying the hidden data</li>' +
            '</ul>' +
        '</div>';
    }

    var html = '<div class="sg-result-message sg-success sg-fade-in">' +
        '<h5>Forensic Scan Complete</h5>' +
        '<p>Found ' + results.length + ' result' + (results.length > 1 ? 's' : '') + ' across ' + totalConfigs + ' configs in ' + elapsedMs + 'ms.</p>' +
    '</div>';

    html += '<div class="sg-forensic-results">';

    for (var i = 0; i < results.length; i++) {
        var r = results[i];
        var pct = Math.round(r.score * 100);
        var confClass = pct >= 80 ? 'sg-conf-high' : (pct >= 60 ? 'sg-conf-mid' : 'sg-conf-low');
        var preview = r.text.length > 200 ? r.text.substring(0, 200) + '...' : r.text;
        var details = F.getConfigLabel(r.config);
        var alsoText = '';
        if (r.alsoMatches.length > 0) {
            alsoText = '<div class="sg-forensic-also">Also matches: ' + E.escapeHtml(r.alsoMatches.join(', ')) + '</div>';
        }

        html += '<div class="sg-forensic-card sg-fade-in" data-index="' + i + '">' +
            '<div class="sg-forensic-card-header">' +
                '<span class="sg-forensic-rank">' + (i + 1) + '</span>' +
                '<span class="sg-forensic-confidence ' + confClass + '">' + pct + '%</span>' +
                '<span class="sg-forensic-tool">' + E.escapeHtml(r.config.label) + '</span>' +
            '</div>' +
            '<div class="sg-forensic-details">' + E.escapeHtml(details) + '</div>' +
            alsoText +
            '<div class="sg-forensic-preview">' + E.escapeHtml(preview) + '</div>' +
            (r.text.length > 200 ? '<div class="sg-forensic-full sg-hidden">' + E.escapeHtml(r.text) + '</div>' : '') +
            '<div class="sg-forensic-card-actions">' +
                '<button type="button" class="sg-result-btn sg-btn-secondary sg-forensic-copy-btn" data-index="' + i + '">' +
                    '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>' +
                    'Copy' +
                '</button>' +
                (r.text.length > 200 ? '<button type="button" class="sg-result-btn sg-btn-secondary sg-forensic-expand-btn" data-index="' + i + '">Expand</button>' : '') +
            '</div>' +
        '</div>';
    }

    html += '</div>';
    return html;
}

/**
 * Render file decode success with download card.
 */
function renderFileDecodeSuccess(filename, size, blobUrl) {
    var E = window.StegoEngine;
    return '<div class="sg-result-message sg-success sg-fade-in">' +
        '<h5>File Extracted</h5>' +
        '<p>A hidden file was found in the image.</p>' +
    '</div>' +
    '<div class="sg-file-download-card">' +
        '<div class="sg-file-download-icon">' +
            '<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>' +
        '</div>' +
        '<div class="sg-file-download-info">' +
            '<div class="sg-file-download-name">' + E.escapeHtml(filename) + '</div>' +
            '<div class="sg-file-download-size">' + E.formatBytes(size) + '</div>' +
        '</div>' +
    '</div>' +
    '<div class="sg-result-actions">' +
        '<a href="' + blobUrl + '" download="' + E.escapeHtml(filename) + '" class="sg-result-btn sg-btn-primary">' +
            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>' +
            'Download File' +
        '</a>' +
        '<button type="button" class="sg-result-btn sg-btn-secondary" onclick="StegoCore.resetDecode()">' +
            'New Decode' +
        '</button>' +
    '</div>';
}

/**
 * Render bit plane analysis result.
 */
function renderBitPlaneResult(channel, plane, width, height) {
    var channelNames = ['Red', 'Green', 'Blue', 'All Channels'];
    var channelName = channelNames[channel] || 'Unknown';
    return '<div class="sg-result-message sg-success sg-fade-in">' +
        '<h5>Bit Plane Analysis</h5>' +
        '<p>' + channelName + ' channel, bit plane ' + plane + ' (' + (plane === 0 ? 'LSB' : (plane === 7 ? 'MSB' : 'plane ' + plane)) + ') &mdash; ' + width + '&times;' + height + '</p>' +
    '</div>' +
    '<canvas id="sg-bitplane-canvas" class="sg-image-preview" style="max-height:none;image-rendering:pixelated;"></canvas>';
}

// Export
window.StegoRender = {
    renderImageInfo: renderImageInfo,
    renderCapacityMeter: renderCapacityMeter,
    renderEncodeSuccess: renderEncodeSuccess,
    renderDecodeSuccess: renderDecodeSuccess,
    renderFileDecodeSuccess: renderFileDecodeSuccess,
    renderBitPlaneResult: renderBitPlaneResult,
    renderError: renderError,
    showEmpty: showEmpty,
    showLoading: showLoading,
    hideLoading: hideLoading,
    renderForensicProgress: renderForensicProgress,
    renderForensicResults: renderForensicResults
};

})();
