/* hexdump-render.js — DOM rendering with virtual scrolling
   Exposes: window.HexRender
   Depends: window.HexEngine */
(function() {
    'use strict';

    var E = window.HexEngine;
    var HexRender = {};

    var ROW_HEIGHT = 22; // px — matches .hx-hex-line height (1.375rem)
    var BUFFER_ROWS = 20; // extra rows above/below viewport

    /**
     * Render hex dump with virtual scrolling.
     * @param {HTMLElement} container - .hx-hex-display element
     * @param {Uint8Array} data
     * @param {Object} options - { format, bytesPerLine, grouping, showAscii, showOffset }
     */
    HexRender.renderHexDump = function(container, data, options) {
        if (!data || data.length === 0) {
            container.innerHTML = '<div class="hx-hex-empty"><div class="hx-hex-empty-icon">&#128196;</div><div class="hx-hex-empty-text">Open a file or paste data to begin</div><div class="hx-hex-empty-hint">Drag &amp; drop anywhere, press Ctrl+O, or use the toolbar buttons</div></div>';
            return;
        }

        var format = options.format || 'hex';
        var bpl = options.bytesPerLine || 16;
        var grouping = options.grouping || 1;
        var showAscii = options.showAscii !== false;
        var showOffset = options.showOffset !== false;

        var totalRows = Math.ceil(data.length / bpl);
        var totalHeight = totalRows * ROW_HEIGHT;

        // Build structure
        container.innerHTML = '';
        var scrollEl = document.createElement('div');
        scrollEl.className = 'hx-hex-scroll';

        var spacer = document.createElement('div');
        spacer.className = 'hx-hex-spacer';
        spacer.style.height = totalHeight + 'px';

        var viewport = document.createElement('div');
        viewport.className = 'hx-hex-viewport';

        spacer.appendChild(viewport);
        scrollEl.appendChild(spacer);
        container.appendChild(scrollEl);

        // Store render context on container for later use
        container._hxCtx = {
            data: data,
            format: format,
            bpl: bpl,
            grouping: grouping,
            showAscii: showAscii,
            showOffset: showOffset,
            totalRows: totalRows,
            viewport: viewport,
            scrollEl: scrollEl,
            lastStart: -1,
            lastEnd: -1,
            modifiedSet: options.modifiedSet || null,
            regionMap: options.regionMap || null
        };

        // Initial render
        renderVisibleRows(container);

        // Scroll handler
        var ticking = false;
        scrollEl.addEventListener('scroll', function() {
            if (!ticking) {
                requestAnimationFrame(function() {
                    renderVisibleRows(container);
                    ticking = false;
                });
                ticking = true;
            }
        });
    };

    function renderVisibleRows(container) {
        var ctx = container._hxCtx;
        if (!ctx) return;

        var scrollTop = ctx.scrollEl.scrollTop;
        var viewportHeight = ctx.scrollEl.clientHeight;

        var startRow = Math.max(0, Math.floor(scrollTop / ROW_HEIGHT) - BUFFER_ROWS);
        var endRow = Math.min(ctx.totalRows, Math.ceil((scrollTop + viewportHeight) / ROW_HEIGHT) + BUFFER_ROWS);

        // Skip if same range
        if (startRow === ctx.lastStart && endRow === ctx.lastEnd) return;
        ctx.lastStart = startRow;
        ctx.lastEnd = endRow;

        var html = [];
        for (var row = startRow; row < endRow; row++) {
            var offset = row * ctx.bpl;
            html.push(buildRowHTML(ctx, offset));
        }

        ctx.viewport.style.transform = 'translateY(' + (startRow * ROW_HEIGHT) + 'px)';
        ctx.viewport.innerHTML = html.join('');
    }

    function buildRowHTML(ctx, offset) {
        var data = ctx.data;
        var bpl = ctx.bpl;
        var format = ctx.format;
        var grouping = ctx.grouping;
        var regionMap = ctx.regionMap;

        var line = '<div class="hx-hex-line">';

        // Offset
        if (ctx.showOffset) {
            line += '<span class="hx-offset">' + E.formatOffset(offset, data.length) + '</span>';
        }

        // Bytes
        line += '<span class="hx-bytes">';
        for (var j = 0; j < bpl; j++) {
            var idx = offset + j;
            if (idx < data.length) {
                var modCls = (ctx.modifiedSet && ctx.modifiedSet.has(idx)) ? ' modified' : '';
                var regionCls = '';
                var titleAttr = '';
                if (regionMap) {
                    var reg = regionMap.get(idx);
                    if (reg && reg.color && reg.color !== 'data') {
                        regionCls = ' hx-region-' + reg.color;
                        var tipText = reg.label;
                        if (reg.description) tipText += ' \u2014 ' + reg.description;
                        titleAttr = ' title="' + tipText.replace(/"/g, '&quot;') + '"';
                    }
                }
                line += '<span class="hx-byte' + modCls + regionCls + '" data-index="' + idx + '"' + titleAttr + '>' + E.formatByte(data[idx], format) + '</span>';
            } else {
                // Padding for incomplete last line
                var padLen = (format === 'bin') ? 8 : (format === 'hex' ? 2 : 3);
                var pad = '';
                for (var p = 0; p < padLen; p++) pad += ' ';
                line += '<span class="hx-byte">' + pad + '</span>';
            }
            if (grouping > 0 && (j + 1) % grouping === 0 && j < bpl - 1) {
                line += '<span class="hx-byte-group-space"></span>';
            }
        }
        line += '</span>';

        // ASCII
        if (ctx.showAscii) {
            line += '<span class="hx-ascii">';
            for (var k = 0; k < bpl; k++) {
                var idx2 = offset + k;
                if (idx2 < data.length) {
                    line += E.getAsciiChar(data[idx2]);
                }
            }
            line += '</span>';
        }

        line += '</div>';
        return line;
    }

    /**
     * Render compact byte info for the inspector panel.
     * @param {HTMLElement} container - #hx-byte-info-panel
     * @param {number} byte
     * @param {number} index
     */
    HexRender.renderInspectorByteInfo = function(container, byte, index) {
        var info = E.getByteInfo(byte);
        var offsetHex = ('00000000' + index.toString(16).toUpperCase()).slice(-8);

        var html = '<div class="hx-inspector-title">Byte Inspector</div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Offset</span><span class="hx-inspector-value">0x' + offsetHex + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Hex</span><span class="hx-inspector-value">' + info.hex + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Dec</span><span class="hx-inspector-value">' + info.dec + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Oct</span><span class="hx-inspector-value">' + info.oct + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Bin</span><span class="hx-inspector-value">' + info.bin + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Char</span><span class="hx-inspector-value">' + info.char + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Signed</span><span class="hx-inspector-value">' + info.signed + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Unsigned</span><span class="hx-inspector-value">' + info.unsigned + '</span></div>';

        container.innerHTML = html;
    };

    /**
     * Render compact statistics for the inspector panel.
     * @param {HTMLElement} container - #hx-stats-panel
     * @param {Object} stats - from HexEngine.calculateStats
     */
    HexRender.renderInspectorStats = function(container, stats) {
        var pct = stats.totalBytes > 0 ? ((stats.printable / stats.totalBytes) * 100).toFixed(1) : '0.0';
        var nullPct = stats.totalBytes > 0 ? ((stats.nullBytes / stats.totalBytes) * 100).toFixed(1) : '0.0';

        var html = '<div class="hx-inspector-title">Statistics</div>';
        html += inspectorRow('Total Bytes', stats.totalBytes.toLocaleString());
        html += inspectorRow('Entropy', stats.entropy.toFixed(4) + ' bits');
        html += inspectorRow('Printable', pct + '%');
        html += inspectorRow('Null Bytes', nullPct + '%');
        html += inspectorRow('Unique', stats.uniqueBytes + ' / 256');

        // Top bytes section
        html += '<div style="margin-top:0.75rem;"><div class="hx-inspector-title">Top Bytes</div>';

        var pairs = [];
        for (var i = 0; i < 256; i++) {
            if (stats.byteFreq[i] > 0) pairs.push({ byte: i, count: stats.byteFreq[i] });
        }
        pairs.sort(function(a, b) { return b.count - a.count; });
        var top = pairs.slice(0, 10);
        var maxCount = top.length > 0 ? top[0].count : 1;

        for (var t = 0; t < top.length; t++) {
            var pctBar = ((top[t].count / maxCount) * 100).toFixed(1);
            var label = '0x' + ('0' + top[t].byte.toString(16).toUpperCase()).slice(-2);
            html += '<div class="hx-inspector-bar-row">';
            html += '<span class="hx-inspector-bar-label">' + label + '</span>';
            html += '<div class="hx-inspector-bar-bg"><div class="hx-inspector-bar" style="width:' + pctBar + '%"></div></div>';
            html += '<span class="hx-inspector-bar-count">' + top[t].count + '</span>';
            html += '</div>';
        }
        html += '</div>';

        container.innerHTML = html;
    };

    function inspectorRow(label, value) {
        return '<div class="hx-inspector-row"><span class="hx-inspector-label">' + label + '</span><span class="hx-inspector-value">' + value + '</span></div>';
    }

    /**
     * Render statistics (legacy, delegates to renderInspectorStats).
     * @param {HTMLElement} container
     * @param {Object} stats
     */
    HexRender.renderStats = function(container, stats) {
        HexRender.renderInspectorStats(container, stats);
    };

    /**
     * Render byte info panel (legacy, delegates to renderInspectorByteInfo).
     * @param {HTMLElement} container
     * @param {number} byte
     * @param {number} index
     */
    HexRender.renderByteInfo = function(container, byte, index) {
        HexRender.renderInspectorByteInfo(container, byte, index);
    };

    /**
     * Highlight matched bytes by adding 'highlighted' class.
     * @param {HTMLElement} container
     * @param {Array<number>} matchIndices - start indices
     * @param {number} patternLen
     */
    HexRender.highlightBytes = function(container, matchIndices, patternLen) {
        HexRender.clearHighlights(container);
        for (var m = 0; m < matchIndices.length; m++) {
            for (var j = 0; j < patternLen; j++) {
                var idx = matchIndices[m] + j;
                var el = container.querySelector('.hx-byte[data-index="' + idx + '"]');
                if (el) el.classList.add('highlighted');
            }
        }
    };

    /**
     * Remove all highlights.
     * @param {HTMLElement} container
     */
    HexRender.clearHighlights = function(container) {
        var els = container.querySelectorAll('.hx-byte.highlighted');
        for (var i = 0; i < els.length; i++) {
            els[i].classList.remove('highlighted');
        }
    };

    /**
     * Scroll to a specific byte offset.
     * @param {HTMLElement} container
     * @param {number} offset - byte offset
     * @param {number} bytesPerLine
     */
    HexRender.scrollToOffset = function(container, offset, bytesPerLine) {
        var row = Math.floor(offset / bytesPerLine);
        var scrollEl = container.querySelector('.hx-hex-scroll');
        if (scrollEl) {
            scrollEl.scrollTop = row * ROW_HEIGHT;
        }
    };

    /**
     * Force re-render visible rows (e.g. after edit).
     * @param {HTMLElement} container
     */
    HexRender.refreshVisibleRows = function(container) {
        var ctx = container._hxCtx;
        if (!ctx) return;
        // Reset last range to force re-render
        ctx.lastStart = -1;
        ctx.lastEnd = -1;
        renderVisibleRows(container);
    };

    /**
     * Update the render context data reference (after insert/delete changes length).
     * @param {HTMLElement} container
     * @param {Uint8Array} newData
     * @param {Set} modifiedSet
     */
    HexRender.updateData = function(container, newData, modifiedSet) {
        var ctx = container._hxCtx;
        if (!ctx) return;
        ctx.data = newData;
        ctx.modifiedSet = modifiedSet || null;
        ctx.totalRows = Math.ceil(newData.length / ctx.bpl);
        // Update spacer height
        var spacer = ctx.scrollEl.querySelector('.hx-hex-spacer');
        if (spacer) spacer.style.height = (ctx.totalRows * ROW_HEIGHT) + 'px';
        // Force re-render
        ctx.lastStart = -1;
        ctx.lastEnd = -1;
        renderVisibleRows(container);
    };

    window.HexRender = HexRender;
})();
