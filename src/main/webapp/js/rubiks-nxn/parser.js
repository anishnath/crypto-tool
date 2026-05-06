/**
 * Generic N×N net image parser — supports any N (3, 4, …).
 *
 * Adapted from js/rubiks/parser.js (which is hard-coded to 12×9 / N=3).
 *
 * Pipeline:
 *  1. (optional) auto-crop to non-background bbox using corner pixels
 *  2. divide cropped image into a (4N) × (3N) sticker grid (the standard
 *     unfolded-cross net layout)
 *  3. sample a small patch at each sticker's geometric center
 *  4. (default) calibrate from the inner stickers per face — for N=3
 *     that's the single centre, for N=4 it's the 4 inner stickers
 *     averaged.  Brute-force optimal 6-way assignment in CIE Lab.
 */

const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];
const FACE_COLORS = {
    U: '#ffffff', R: '#b71234', F: '#009b48',
    D: '#ffd500', L: '#ff5800', B: '#0046ad',
};

/* ── colour space helpers (identical to rubiks/parser.js) ──────── */
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
    const lr = srgbToLinear(r);
    const lg = srgbToLinear(g);
    const lb = srgbToLinear(b);
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
    const corners = [[0,0], [img.width-1,0], [0,img.height-1], [img.width-1,img.height-1]];
    let bgR = 0, bgG = 0, bgB = 0;
    for (const [x, y] of corners) {
        const i = (y * img.width + x) * 4;
        bgR += img.data[i]; bgG += img.data[i+1]; bgB += img.data[i+2];
    }
    bgR /= 4; bgG /= 4; bgB /= 4;
    let x0 = img.width, y0 = img.height, x1 = -1, y1 = -1;
    const tol2 = tolerance * tolerance;
    for (let y = 0; y < img.height; y++) {
        for (let x = 0; x < img.width; x++) {
            const i = (y * img.width + x) * 4;
            const dr = img.data[i] - bgR, dg = img.data[i+1] - bgG, db = img.data[i+2] - bgB;
            if (dr*dr + dg*dg + db*db > tol2) {
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
            const s = ((y0 + y) * img.width + (x0 + x)) * 4;
            const d = (y * w + x) * 4;
            data[d] = img.data[s]; data[d+1] = img.data[s+1];
            data[d+2] = img.data[s+2]; data[d+3] = img.data[s+3];
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
        const d = ctx.getImageData(0, 0, canvas.width, canvas.height);
        return { width: d.width, height: d.height, data: d.data };
    } finally {
        URL.revokeObjectURL(url);
    }
}

/** Per-face grid offsets in the unfolded cross. */
function faceGridOffsets(N) {
    return {
        U: { col: N,     row: 0     },
        L: { col: 0,     row: N     },
        F: { col: N,     row: N     },
        R: { col: 2 * N, row: N     },
        B: { col: 3 * N, row: N     },
        D: { col: N,     row: 2 * N },
    };
}
/** Sticker placements for an N-cube unfolded net.
 *  index = face_offset + facePos, where facePos = row*N + col within the face. */
function buildPlacements(N) {
    const offs = faceGridOffsets(N);
    const perFace = N * N;
    const faceIdx = { U: 0, R: perFace, F: 2*perFace, D: 3*perFace, L: 4*perFace, B: 5*perFace };
    const out = [];
    for (const face of FACES) {
        const { col: oc, row: orw } = offs[face];
        for (let r = 0; r < N; r++) {
            for (let c = 0; c < N; c++) {
                out.push({
                    index: faceIdx[face] + r * N + c,
                    face,
                    facePos: r * N + c,
                    col: oc + c,
                    row: orw + r,
                });
            }
        }
    }
    return out;
}

/** Inner-sticker indices per face — used for centre-calibration.
 *  N=3 → the unique centre at facePos=4.
 *  N=4 → the 4 inner stickers at facePos ∈ {5, 6, 9, 10}. */
function innerIndices(N) {
    const out = {};
    const perFace = N * N;
    const faceIdx = { U: 0, R: perFace, F: 2*perFace, D: 3*perFace, L: 4*perFace, B: 5*perFace };
    const inset = (N - 2) / 2;     // 0.5 for N=3, 1 for N=4
    const positions = [];
    if (N === 3) {
        positions.push(4);
    } else {
        // All facePos that aren't on the outer frame.
        for (let r = 0; r < N; r++) {
            for (let c = 0; c < N; c++) {
                if (r > 0 && r < N - 1 && c > 0 && c < N - 1) positions.push(r * N + c);
            }
        }
    }
    void inset;
    for (const f of FACES) out[f] = positions.map((p) => faceIdx[f] + p);
    return out;
}

/**
 * @param {{width:number,height:number,data:Uint8ClampedArray}} img
 * @param {number} N
 * @param {{ sampleHalfWidth?:number, calibrateFromCenters?:boolean,
 *           autoCrop?:boolean, backgroundTolerance?:number }} [options]
 * @returns {{ ok:true, state:string } | { ok:false, reason:string }}
 */
export function parseNet(img, N, options = {}) {
    const sampleHalfWidth = options.sampleHalfWidth ?? Math.max(2, Math.floor(28 / N));
    const calibrate       = options.calibrateFromCenters ?? true;
    const autoCrop        = options.autoCrop ?? true;
    const bgTol           = options.backgroundTolerance ?? 16;

    const GRID_COLS = 4 * N;
    const GRID_ROWS = 3 * N;
    const PLACEMENTS = buildPlacements(N);
    const TOTAL = 6 * N * N;
    const INNER = innerIndices(N);

    let work = img;
    if (autoCrop) {
        const b = findContentBounds(img, bgTol);
        if (!b) return { ok: false, reason: 'Image appears to be entirely background' };
        work = cropImage(img, b.x0, b.y0, b.x1 - b.x0 + 1, b.y1 - b.y0 + 1);
    }

    const stickerW = work.width / GRID_COLS;
    const stickerH = work.height / GRID_ROWS;
    const aspectMismatch = Math.abs(stickerW - stickerH) / Math.max(stickerW, stickerH);
    if (aspectMismatch > 0.12) {
        return {
            ok: false,
            reason: `Image aspect doesn't match a ${GRID_COLS}×${GRID_ROWS} grid `
                  + `(sticker ${stickerW.toFixed(1)} × ${stickerH.toFixed(1)}). `
                  + `Make sure you uploaded an unfolded cross net for an ${N}×${N} cube.`,
        };
    }

    // Sample every sticker.
    const samples = new Array(TOTAL);
    for (const p of PLACEMENTS) {
        const cx = Math.floor((p.col + 0.5) * stickerW);
        const cy = Math.floor((p.row + 0.5) * stickerH);
        samples[p.index] = sampleAverage(work, cx, cy, sampleHalfWidth);
    }

    const wcaLab = {};
    for (const f of FACES) wcaLab[f] = rgbToLab(hexToRgb(FACE_COLORS[f]));

    function nearestFace(lab, refs) {
        let best = FACES[0], bestD = Infinity;
        for (const f of FACES) {
            const d = labDistance(lab, refs[f]);
            if (d < bestD) { bestD = d; best = f; }
        }
        return best;
    }

    const out = new Array(TOTAL);

    if (calibrate) {
        // Average the inner stickers per face → calibration anchor.
        const centerLab = {};
        for (const f of FACES) {
            const idxs = INNER[f];
            let r = 0, g = 0, b = 0;
            for (const i of idxs) { r += samples[i][0]; g += samples[i][1]; b += samples[i][2]; }
            centerLab[f] = rgbToLab([r / idxs.length, g / idxs.length, b / idxs.length]);
        }

        // Brute-force the optimal 6-way assignment over all 720 perms.
        let bestPerm = null, bestTotal = Infinity;
        (function permute(arr, start) {
            if (start === arr.length) {
                let total = 0;
                for (let i = 0; i < FACES.length; i++) {
                    total += labDistance(centerLab[FACES[i]], wcaLab[arr[i]]);
                }
                if (total < bestTotal) { bestTotal = total; bestPerm = arr.slice(); }
                return;
            }
            for (let i = start; i < arr.length; i++) {
                [arr[start], arr[i]] = [arr[i], arr[start]];
                permute(arr, start + 1);
                [arr[start], arr[i]] = [arr[i], arr[start]];
            }
        })(FACES.slice(), 0);

        const detectedToWca = {};
        for (let i = 0; i < FACES.length; i++) detectedToWca[FACES[i]] = bestPerm[i];

        for (const p of PLACEMENTS) {
            const detected = nearestFace(rgbToLab(samples[p.index]), centerLab);
            out[p.index] = detectedToWca[detected];
        }
        return { ok: true, state: out.join('') };
    }

    for (const p of PLACEMENTS) out[p.index] = nearestFace(rgbToLab(samples[p.index]), wcaLab);
    return { ok: true, state: out.join('') };
}
