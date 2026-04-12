/**
 * Lens & Mirror Calculator - Export Module
 * LaTeX copy, share URLs, PNG export
 */
(function() {
'use strict';

var R = window.LensMirrorRender;

// ==================== LaTeX ====================

function buildLatex(result, mode) {
    if (!result || result.error) return '';
    var lines = [];
    lines.push('\\text{Thin Lens Equation: } \\frac{1}{f} = \\frac{1}{v} - \\frac{1}{u}');
    if (mode === 'find-v') {
        lines.push('\\frac{1}{v} = \\frac{1}{' + R.fmt(result.f) + '} + \\frac{1}{' + R.fmt(result.u) + '} \\Rightarrow v = ' + R.fmt(result.v) + '\\text{ cm}');
    } else if (mode === 'find-u') {
        lines.push('\\frac{1}{u} = \\frac{1}{' + R.fmt(result.v) + '} - \\frac{1}{' + R.fmt(result.f) + '} \\Rightarrow u = ' + R.fmt(result.u) + '\\text{ cm}');
    } else {
        lines.push('\\frac{1}{f} = \\frac{1}{' + R.fmt(result.v) + '} - \\frac{1}{' + R.fmt(result.u) + '} \\Rightarrow f = ' + R.fmt(result.f) + '\\text{ cm}');
    }
    lines.push('m = \\frac{v}{u} = ' + R.fmt(result.m));
    lines.push("h' = m \\times h = " + R.fmt(result.h_prime) + '\\text{ cm}');
    lines.push('P = \\frac{1}{f_m} = ' + R.fmt(result.power) + '\\text{ D}');
    return lines.join(' \\\\\n');
}

function copyLatex(result, mode) {
    var latex = buildLatex(result, mode);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = {
        t: state.opticalType,
        m: state.calcMode,
        f: state.f,
        u: state.u,
        v: state.v,
        h: state.h
    };
    var encoded = btoa(JSON.stringify(data));
    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (!d) return null;
    try { return JSON.parse(atob(d)); } catch (e) { return null; }
}

function copyShareUrl(state) {
    var url = buildShareUrl(state);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url);
    }
}

// ==================== PNG Export ====================

function savePNG(canvas, result, opticalTypeLabel) {
    if (!canvas || !result || result.error) return;
    var fmtN = function (x) {
        if (x === Infinity || x === -Infinity) return '\u221E';
        if (typeof x === 'number' && isFinite(x)) return x.toFixed(2);
        return String(x);
    };
    var fmtM = function (x) {
        if (x === Infinity || x === -Infinity) return '\u221E';
        if (typeof x === 'number' && isFinite(x)) return x.toFixed(3);
        return String(x);
    };

    var tempCanvas = document.createElement('canvas');
    var w = canvas.width;
    var extraHeight = 220;
    tempCanvas.width = w;
    tempCanvas.height = canvas.height + extraHeight;
    var ctx = tempCanvas.getContext('2d');

    // White background
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

    // Copy ray diagram
    ctx.drawImage(canvas, 0, 0);

    // Border below diagram
    ctx.strokeStyle = '#e5e7eb';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, canvas.height);
    ctx.lineTo(w, canvas.height);
    ctx.stroke();

    var yPos = canvas.height + 20;
    var leftX = 20;
    var rightX = w / 2 + 10;

    // Title
    ctx.fillStyle = '#1e293b';
    ctx.font = 'bold 16px sans-serif';
    ctx.fillText('Lens & Mirror Calculator - Ray Diagram', leftX, yPos);
    yPos += 30;

    // Left column - Inputs
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('Inputs:', leftX, yPos);
    yPos += 5;

    ctx.fillStyle = '#1e293b';
    ctx.font = '12px sans-serif';
    ctx.fillText('Type: ' + opticalTypeLabel, leftX, yPos += 20);
    ctx.fillText('Focal Length (f): ' + result.f.toFixed(2) + ' cm', leftX, yPos += 18);
    ctx.fillText('Object Distance (u): ' + result.u.toFixed(2) + ' cm', leftX, yPos += 18);
    ctx.fillText('Object Height (h): ' + result.h.toFixed(2) + ' cm', leftX, yPos += 18);

    // Right column - Results
    yPos = canvas.height + 50;
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('Results:', rightX, yPos);
    yPos += 5;

    ctx.fillStyle = '#1e293b';
    ctx.font = '12px sans-serif';
    ctx.fillText('Image Distance (v): ' + (result.imageAtInfinity ? '\u221E (parallel rays)' : fmtN(result.v) + ' cm'), rightX, yPos += 20);
    ctx.fillText('Magnification (m): ' + fmtM(result.m), rightX, yPos += 18);
    ctx.fillText("Image Height (h'): " + fmtN(result.h_prime) + (result.imageAtInfinity ? '' : ' cm'), rightX, yPos += 18);
    ctx.fillText('Lens Power (P): ' + result.power.toFixed(2) + ' D', rightX, yPos += 18);

    yPos += 10;
    ctx.fillStyle = '#e11d48';
    ctx.font = 'bold 11px sans-serif';
    ctx.fillText(result.imageType + '  |  ' + result.orientation + '  |  ' + result.size, rightX, yPos += 18);

    // Watermark
    ctx.fillStyle = '#94a3b8';
    ctx.font = '10px sans-serif';
    ctx.fillText('Generated by 8gwifi.org/lens-mirror-calculator.jsp', leftX, canvas.height + extraHeight - 15);

    // Download
    var link = document.createElement('a');
    link.download = 'lens-mirror-' + Date.now() + '.png';
    link.href = tempCanvas.toDataURL();
    link.click();
}

// ==================== Export ====================

window.LensMirrorExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    savePNG: savePNG
};

})();
