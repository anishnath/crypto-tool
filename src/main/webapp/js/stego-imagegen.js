/**
 * Steganography Tool - Image Generator Module
 * Auto-generate cover images via Canvas 2D for LSB steganography
 */
(function() {
'use strict';

var TYPES = [
    { id: 'gradient', name: 'Gradient Mesh', icon: 'gradient' },
    { id: 'geometric', name: 'Geometric', icon: 'geometric' },
    { id: 'noise', name: 'Noise Pattern', icon: 'noise' },
    { id: 'waves', name: 'Abstract Waves', icon: 'waves' }
];

/**
 * Generate a random color as [r, g, b].
 */
function randColor() {
    return [
        Math.floor(Math.random() * 256),
        Math.floor(Math.random() * 256),
        Math.floor(Math.random() * 256)
    ];
}

/**
 * Generate gradient mesh: 5-8 overlapping radial gradients.
 */
function generateGradient(ctx, w, h) {
    // Base fill
    var base = randColor();
    ctx.fillStyle = 'rgb(' + base[0] + ',' + base[1] + ',' + base[2] + ')';
    ctx.fillRect(0, 0, w, h);

    var count = 5 + Math.floor(Math.random() * 4);
    for (var i = 0; i < count; i++) {
        var cx = Math.random() * w;
        var cy = Math.random() * h;
        var radius = Math.max(w, h) * (0.2 + Math.random() * 0.5);
        var c = randColor();
        var grad = ctx.createRadialGradient(cx, cy, 0, cx, cy, radius);
        grad.addColorStop(0, 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',0.7)');
        grad.addColorStop(1, 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',0)');
        ctx.fillStyle = grad;
        ctx.fillRect(0, 0, w, h);
    }
}

/**
 * Generate geometric shapes: circles, rectangles, lines on gradient bg.
 */
function generateGeometric(ctx, w, h) {
    // Gradient background
    var bg1 = randColor();
    var bg2 = randColor();
    var bgGrad = ctx.createLinearGradient(0, 0, w, h);
    bgGrad.addColorStop(0, 'rgb(' + bg1[0] + ',' + bg1[1] + ',' + bg1[2] + ')');
    bgGrad.addColorStop(1, 'rgb(' + bg2[0] + ',' + bg2[1] + ',' + bg2[2] + ')');
    ctx.fillStyle = bgGrad;
    ctx.fillRect(0, 0, w, h);

    var shapes = 30 + Math.floor(Math.random() * 40);
    for (var i = 0; i < shapes; i++) {
        var c = randColor();
        var alpha = 0.1 + Math.random() * 0.5;
        ctx.fillStyle = 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + alpha + ')';
        ctx.strokeStyle = 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + (alpha + 0.2) + ')';
        ctx.lineWidth = 1 + Math.random() * 3;

        var type = Math.floor(Math.random() * 3);
        if (type === 0) {
            // Circle
            ctx.beginPath();
            ctx.arc(Math.random() * w, Math.random() * h, 10 + Math.random() * 80, 0, Math.PI * 2);
            Math.random() > 0.5 ? ctx.fill() : ctx.stroke();
        } else if (type === 1) {
            // Rectangle
            var rw = 20 + Math.random() * 120;
            var rh = 20 + Math.random() * 80;
            ctx.save();
            ctx.translate(Math.random() * w, Math.random() * h);
            ctx.rotate(Math.random() * Math.PI);
            Math.random() > 0.5 ? ctx.fillRect(-rw/2, -rh/2, rw, rh) : ctx.strokeRect(-rw/2, -rh/2, rw, rh);
            ctx.restore();
        } else {
            // Line
            ctx.beginPath();
            ctx.moveTo(Math.random() * w, Math.random() * h);
            ctx.lineTo(Math.random() * w, Math.random() * h);
            ctx.stroke();
        }
    }
}

/**
 * Simple hash for noise generation.
 */
function hash(x, y, seed) {
    var n = x * 374761393 + y * 668265263 + seed;
    n = (n ^ (n >> 13)) * 1274126177;
    n = n ^ (n >> 16);
    return (n & 0x7fffffff) / 0x7fffffff;
}

/**
 * Generate value noise pattern mapped to color gradient.
 */
function generateNoise(ctx, w, h) {
    var imageData = ctx.createImageData(w, h);
    var d = imageData.data;
    var seed = Math.floor(Math.random() * 100000);
    var scale = 4 + Math.floor(Math.random() * 8);

    // Random color palette (3 colors for gradient mapping)
    var c1 = randColor();
    var c2 = randColor();
    var c3 = randColor();

    for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
            // Bilinear interpolated value noise
            var sx = x / scale;
            var sy = y / scale;
            var ix = Math.floor(sx);
            var iy = Math.floor(sy);
            var fx = sx - ix;
            var fy = sy - iy;

            var v00 = hash(ix, iy, seed);
            var v10 = hash(ix + 1, iy, seed);
            var v01 = hash(ix, iy + 1, seed);
            var v11 = hash(ix + 1, iy + 1, seed);

            var top = v00 + (v10 - v00) * fx;
            var bot = v01 + (v11 - v01) * fx;
            var val = top + (bot - top) * fy;

            // Map to color
            var r, g, b;
            if (val < 0.5) {
                var t = val * 2;
                r = c1[0] + (c2[0] - c1[0]) * t;
                g = c1[1] + (c2[1] - c1[1]) * t;
                b = c1[2] + (c2[2] - c1[2]) * t;
            } else {
                var t = (val - 0.5) * 2;
                r = c2[0] + (c3[0] - c2[0]) * t;
                g = c2[1] + (c3[1] - c2[1]) * t;
                b = c2[2] + (c3[2] - c2[2]) * t;
            }

            var idx = (y * w + x) * 4;
            d[idx] = Math.round(r);
            d[idx + 1] = Math.round(g);
            d[idx + 2] = Math.round(b);
            d[idx + 3] = 255;
        }
    }
    ctx.putImageData(imageData, 0, 0);
}

/**
 * Generate abstract waves: layered sine waves with color fills.
 */
function generateWaves(ctx, w, h) {
    // Background
    var bg = randColor();
    ctx.fillStyle = 'rgb(' + bg[0] + ',' + bg[1] + ',' + bg[2] + ')';
    ctx.fillRect(0, 0, w, h);

    var layers = 5 + Math.floor(Math.random() * 4);
    for (var l = 0; l < layers; l++) {
        var c = randColor();
        var alpha = 0.15 + Math.random() * 0.35;
        ctx.fillStyle = 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + alpha + ')';

        var freq = 0.005 + Math.random() * 0.02;
        var amp = 30 + Math.random() * 80;
        var phase = Math.random() * Math.PI * 2;
        var yOffset = (l / layers) * h * 0.7 + h * 0.15;
        var freq2 = 0.002 + Math.random() * 0.01;
        var amp2 = 10 + Math.random() * 30;

        ctx.beginPath();
        ctx.moveTo(0, h);
        for (var x = 0; x <= w; x++) {
            var y = yOffset + Math.sin(x * freq + phase) * amp + Math.sin(x * freq2 + phase * 1.5) * amp2;
            ctx.lineTo(x, y);
        }
        ctx.lineTo(w, h);
        ctx.closePath();
        ctx.fill();
    }
}

/**
 * Generate a cover image of the specified type and size.
 * Returns { canvas, imageData, dataUrl }
 */
function generate(type, width, height) {
    width = width || 800;
    height = height || 600;

    var canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var ctx = canvas.getContext('2d');

    switch (type) {
        case 'gradient':
            generateGradient(ctx, width, height);
            break;
        case 'geometric':
            generateGeometric(ctx, width, height);
            break;
        case 'noise':
            generateNoise(ctx, width, height);
            break;
        case 'waves':
            generateWaves(ctx, width, height);
            break;
        default:
            generateGradient(ctx, width, height);
    }

    var imageData = ctx.getImageData(0, 0, width, height);
    var dataUrl = canvas.toDataURL('image/png');

    return {
        canvas: canvas,
        imageData: imageData,
        dataUrl: dataUrl
    };
}

/**
 * Return available generator types.
 */
function getTypes() {
    return TYPES.slice();
}

// Export
window.StegoImageGen = {
    generate: generate,
    getTypes: getTypes
};

})();
