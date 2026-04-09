/* NN-SVG Export — Download SVG/PNG from the canvas */

'use strict';

var NNExport = (function() {

    var WATERMARK = '8gwifi.org/ml/nn-viz.jsp';

    function stamp() {
        var d = new Date();
        return d.getFullYear() + '' +
            ('0' + (d.getMonth() + 1)).slice(-2) +
            ('0' + d.getDate()).slice(-2) + '-' +
            ('0' + d.getHours()).slice(-2) +
            ('0' + d.getMinutes()).slice(-2) +
            ('0' + d.getSeconds()).slice(-2);
    }

    function makeFilename(label, ext) {
        return '8gwifi-' + label + '-' + stamp() + '.' + ext;
    }

    function addSVGWatermark(svgClone) {
        var w = parseFloat(svgClone.getAttribute('width')) || 800;
        var h = parseFloat(svgClone.getAttribute('height')) || 600;

        var text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        text.setAttribute('x', w - 8);
        text.setAttribute('y', h - 8);
        text.setAttribute('text-anchor', 'end');
        text.setAttribute('font-family', 'Inter, -apple-system, sans-serif');
        text.setAttribute('font-size', '11');
        text.setAttribute('font-weight', '500');
        text.setAttribute('fill', '#94a3b8');
        text.setAttribute('opacity', '0.6');
        text.textContent = WATERMARK;
        svgClone.appendChild(text);
    }

    function addCanvasWatermark(ctx, w, h) {
        ctx.save();
        ctx.font = '500 11px Inter, -apple-system, sans-serif';
        ctx.textAlign = 'right';
        ctx.textBaseline = 'bottom';
        ctx.fillStyle = 'rgba(148, 163, 184, 0.6)';
        ctx.fillText(WATERMARK, w - 8, h - 8);
        ctx.restore();
    }

    function downloadSVG(containerEl, filename) {
        filename = filename || makeFilename('nn-svg', 'svg');
        var svgEl = containerEl.querySelector('svg');
        if (!svgEl) { alert('No SVG found to export.'); return; }

        var clone = svgEl.cloneNode(true);
        clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');

        // Inline computed styles for portability
        var allEls = clone.querySelectorAll('*');
        var origEls = svgEl.querySelectorAll('*');
        for (var i = 0; i < allEls.length; i++) {
            var cs = window.getComputedStyle(origEls[i]);
            var style = '';
            ['fill', 'stroke', 'stroke-width', 'stroke-opacity', 'opacity', 'font-size', 'font-family'].forEach(function(prop) {
                var val = cs.getPropertyValue(prop);
                if (val) style += prop + ':' + val + ';';
            });
            if (style) allEls[i].setAttribute('style', style);
        }

        // Add watermark
        addSVGWatermark(clone);

        var data = new XMLSerializer().serializeToString(clone);
        var blob = new Blob([data], {type: 'image/svg+xml;charset=utf-8'});
        triggerDownload(blob, filename);
    }

    function downloadPNG(containerEl, filename) {
        filename = filename || makeFilename('nn-png', 'png');
        var canvas = containerEl.querySelector('canvas');
        if (!canvas) { alert('No canvas found to export.'); return; }

        // Create a copy with watermark
        var tempCanvas = document.createElement('canvas');
        tempCanvas.width = canvas.width;
        tempCanvas.height = canvas.height;
        var ctx = tempCanvas.getContext('2d');
        ctx.drawImage(canvas, 0, 0);
        addCanvasWatermark(ctx, tempCanvas.width, tempCanvas.height);

        tempCanvas.toBlob(function(blob) {
            triggerDownload(blob, filename);
        }, 'image/png');
    }

    function triggerDownload(blob, filename) {
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    return {
        downloadSVG: downloadSVG,
        downloadPNG: downloadPNG,
        addCanvasWatermark: addCanvasWatermark,
        makeFilename: makeFilename
    };

})();
