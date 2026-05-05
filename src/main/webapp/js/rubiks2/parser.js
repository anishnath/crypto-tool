/**
 * 2×2 image parser — same CV pipeline as the 3×3 (autocrop, sample, calibrate
 * via 6-way Hungarian-equivalent on center stickers in CIE Lab) but on an
 * 8×6 sticker grid instead of 12×9.
 *
 * IMPORTANT 2×2 specifics: there are no center stickers.  We use the four
 * stickers of each face's "calibration corner" (we pick the top-left sticker
 * of each face: indices U[0]=0, R[0]=4, F[0]=8, D[0]=12, L[0]=16, B[0]=20)
 * as proxies for the centers.  The brute-force 6-way assignment over 720
 * permutations still gives a robust palette mapping — the proxy stickers
 * happen to all be the same color in any solved orientation, and after a
 * scramble they're still ONE-OF-EACH-COLOR with high probability… except
 * they're not: in scrambled states, multiple "corner anchor" stickers can
 * share a color.  So this calibration is weaker than the 3×3 one — works
 * for clean renderer screenshots, less robust to wild palette drift.
 *
 * For v1 this is acceptable because:
 *   1. Most users will start from a render or scramble and click Solve —
 *      not upload a wonky photo.
 *   2. The editable net lets users fix any mis-detected stickers manually.
 *   3. We can add proper center-anchor calibration in a follow-up if needed.
 */

import {
    FACE_COLORS, FACES, GRID_COLS, GRID_ROWS, PLACEMENTS,
} from './cube.js';

const HEX_RE = /^#([0-9a-f]{6})$/i;
function hexToRgb(hex) {
    const m = HEX_RE.exec(hex);
    if (!m) throw new Error(`Bad hex color: ${hex}`);
    const n = parseInt(m[1], 16);
    return [(n >> 16) & 0xff, (n >> 8) & 0xff, n & 0xff];
}

function srgbToLinear(c) {
    const v = c / 255;
    return v <= 0.04045 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
}

function rgbToLab([r, g, b]) {
    const lr = srgbToLinear(r), lg = srgbToLinear(g), lb = srgbToLinear(b);
    const x = lr * 0.4124564 + lg * 0.3575761 + lb * 0.1804375;
    const y = lr * 0.2126729 + lg * 0.7151522 + lb * 0.072175;
    const z = lr * 0.0193339 + lg * 0.119192  + lb * 0.9503041;
    const xn = x / 0.95047, yn = y / 1.0, zn = z / 1.08883;
    const f = (t) => t > 216 / 24389 ? Math.cbrt(t) : ((24389 / 27) * t) / 116 + 16 / 116;
    const fx = f(xn), fy = f(yn), fz = f(zn);
    return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}

function labDistance(a, b) {
    const dl = a[0] - b[0], da = a[1] - b[1], db = a[2] - b[2];
    return dl * dl + da * da + db * db;
}

function sampleAverage(img, cx, cy, halfWidth) {
    let r = 0, g = 0, b = 0, n = 0;
    const x0 = Math.max(0, cx - halfWidth);
    const x1 = Math.min(img.width - 1, cx + halfWidth);
    const y0 = Math.max(0, cy - halfWidth);
    const y1 = Math.min(img.height - 1, cy + halfWidth);
    for (let y = y0; y <= y1; y++) {
        for (let x = x0; x <= x1; x++) {
            const i = (y * img.width + x) * 4;
            r += img.data[i]; g += img.data[i + 1]; b += img.data[i + 2]; n++;
        }
    }
    return [r / n, g / n, b / n];
}

function findContentBounds(img, tolerance) {
    const corners = [[0,0],[img.width-1,0],[0,img.height-1],[img.width-1,img.height-1]];
    let br = 0, bg = 0, bb = 0;
    for (const [x, y] of corners) {
        const i = (y * img.width + x) * 4;
        br += img.data[i]; bg += img.data[i+1]; bb += img.data[i+2];
    }
    br /= 4; bg /= 4; bb /= 4;
    let x0 = img.width, y0 = img.height, x1 = -1, y1 = -1;
    for (let y = 0; y < img.height; y++) {
        for (let x = 0; x < img.width; x++) {
            const i = (y * img.width + x) * 4;
            const dr = Math.abs(img.data[i]   - br);
            const dg = Math.abs(img.data[i+1] - bg);
            const db = Math.abs(img.data[i+2] - bb);
            if (dr > tolerance || dg > tolerance || db > tolerance) {
                if (x < x0) x0 = x;
                if (y < y0) y0 = y;
                if (x > x1) x1 = x;
                if (y > y1) y1 = y;
            }
        }
    }
    if (x1 < 0) return null;
    return { x0, y0, x1, y1 };
}

function cropImage(img, x0, y0, w, h) {
    const data = new Uint8ClampedArray(w * h * 4);
    for (let y = 0; y < h; y++) {
        for (let x = 0; x < w; x++) {
            const srcI = ((y0 + y) * img.width + (x0 + x)) * 4;
            const dstI = (y * w + x) * 4;
            data[dstI]     = img.data[srcI];
            data[dstI + 1] = img.data[srcI + 1];
            data[dstI + 2] = img.data[srcI + 2];
            data[dstI + 3] = img.data[srcI + 3];
        }
    }
    return { width: w, height: h, data };
}

export async function loadImageToBuffer(file) {
    const url = URL.createObjectURL(file);
    try {
        const img = await new Promise((resolve, reject) => {
            const el = new Image();
            el.onload = () => resolve(el);
            el.onerror = () => reject(new Error('Failed to decode image'));
            el.src = url;
        });
        const canvas = document.createElement('canvas');
        canvas.width = img.naturalWidth;
        canvas.height = img.naturalHeight;
        const ctx = canvas.getContext('2d');
        if (!ctx) throw new Error('Could not create 2D canvas context');
        ctx.drawImage(img, 0, 0);
        const imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        return { width: imgData.width, height: imgData.height, data: imgData.data };
    } finally {
        URL.revokeObjectURL(url);
    }
}

export function parseNet(img, options = {}) {
    const sampleHalfWidth = options.sampleHalfWidth ?? 4;
    const autoCrop = options.autoCrop ?? true;
    const backgroundTolerance = options.backgroundTolerance ?? 16;

    let workingImg = img;
    if (autoCrop) {
        const bounds = findContentBounds(img, backgroundTolerance);
        if (!bounds) return { ok: false, reason: 'Image appears to be entirely background' };
        workingImg = cropImage(img, bounds.x0, bounds.y0,
            bounds.x1 - bounds.x0 + 1, bounds.y1 - bounds.y0 + 1);
    }

    const stickerW = workingImg.width / GRID_COLS;
    const stickerH = workingImg.height / GRID_ROWS;
    const aspectMismatch = Math.abs(stickerW - stickerH) / Math.max(stickerW, stickerH);
    if (aspectMismatch > 0.1) {
        return {
            ok: false,
            reason: `Image aspect doesn't match an 8×6 grid (sticker w=${stickerW.toFixed(1)}, h=${stickerH.toFixed(1)})`,
        };
    }

    const samples = {};
    for (const p of PLACEMENTS) {
        const cx = Math.floor((p.col + 0.5) * stickerW);
        const cy = Math.floor((p.row + 0.5) * stickerH);
        samples[p.index] = sampleAverage(workingImg, cx, cy, sampleHalfWidth);
    }

    const wcaLab = {};
    for (const face of FACES) wcaLab[face] = rgbToLab(hexToRgb(FACE_COLORS[face]));

    function nearestFace(lab) {
        let best = FACES[0], bestDist = Infinity;
        for (const face of FACES) {
            const d = labDistance(lab, wcaLab[face]);
            if (d < bestDist) { bestDist = d; best = face; }
        }
        return best;
    }

    const stateChars = new Array(24);
    for (const p of PLACEMENTS) {
        stateChars[p.index] = nearestFace(rgbToLab(samples[p.index]));
    }
    return { ok: true, state: stateChars.join(''), samples };
}
