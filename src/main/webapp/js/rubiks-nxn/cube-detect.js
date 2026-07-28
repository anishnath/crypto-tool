/**
 * cube-detect.js — lazy OpenCV.js auto-detection of a cube face.
 *
 * Ports the proven contour pipeline from dwalton76/rubiks-cube-tracker and
 * kkoomen/qbr: grayscale → blur → Canny → dilate → findContours →
 * approxPolyDP square test → area/squareness filter → snap to an N×N grid.
 *
 * Because the app already knows the cube size N, we don't infer it from
 * neighbour counts (dwalton76's harder, error-prone step) — we just require
 * N² square candidates and assign them to an N×N grid by position.  That makes
 * detection much more robust.
 *
 * OpenCV.js is ~10 MB, so it's loaded ON DEMAND (first time the user turns on
 * Auto) and cached.  Everything else (colour resolution) stays in cube-scan.js.
 *
 * Mat lifecycle: OpenCV.js leaks unless every Mat is .delete()'d, and this runs
 * per frame — so every allocation here is released in the same call.
 */

const OPENCV_URL = 'https://docs.opencv.org/4.x/opencv.js';
let _cvPromise = null;

/** Lazily load + initialise OpenCV.js.  Resolves with the `cv` namespace. */
export function loadOpenCV() {
    if (_cvPromise) return _cvPromise;
    _cvPromise = new Promise((resolve, reject) => {
        if (window.cv && window.cv.Mat) { resolve(window.cv); return; }
        const script = document.createElement('script');
        script.src = OPENCV_URL;
        script.async = true;
        script.onload = () => {
            const cv = window.cv;
            if (!cv) { reject(new Error('OpenCV.js loaded but `cv` is missing')); return; }
            if (typeof cv.then === 'function') {        // newer promise form
                cv.then(resolve).catch(reject);
            } else if (cv.Mat) {                         // already initialised
                resolve(cv);
            } else {                                     // classic wasm callback
                cv.onRuntimeInitialized = () => resolve(cv);
            }
        };
        script.onerror = () => { _cvPromise = null; reject(new Error('Could not download OpenCV.js')); };
        document.head.appendChild(script);
    });
    return _cvPromise;
}

/**
 * Detect an N×N grid of sticker squares in an ImageData.
 *
 * @returns {null | {cx:number,cy:number}[]}  N² centroids in net facePos
 *          (row-major) order, or null if a clean grid wasn't found.
 */
export function detectFaceGrid(cv, imgData, N) {
    const need = N * N;
    const imgArea = imgData.width * imgData.height;
    const src = cv.matFromImageData(imgData);
    const gray = new cv.Mat(), blur = new cv.Mat(), canny = new cv.Mat(), dil = new cv.Mat();
    const contours = new cv.MatVector(), hier = new cv.Mat();
    let kernel = null;
    const cands = [];
    try {
        cv.cvtColor(src, gray, cv.COLOR_RGBA2GRAY);
        cv.GaussianBlur(gray, blur, new cv.Size(5, 5), 0);
        cv.Canny(blur, canny, 30, 60);
        kernel = cv.Mat.ones(5, 5, cv.CV_8U);
        cv.dilate(canny, dil, kernel, new cv.Point(-1, -1), 2);
        cv.findContours(dil, contours, hier, cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE);

        for (let i = 0; i < contours.size(); i++) {
            const cnt = contours.get(i);
            const peri = cv.arcLength(cnt, true);
            const approx = new cv.Mat();
            cv.approxPolyDP(cnt, approx, 0.08 * peri, true);
            if (approx.rows === 4) {
                const area = cv.contourArea(approx);
                if (area > imgArea * 0.0008 && area < imgArea * 0.25) {
                    const r = cv.boundingRect(approx);
                    const ar = r.width / r.height;
                    if (ar > 0.7 && ar < 1.4) {
                        cands.push({ cx: r.x + r.width / 2, cy: r.y + r.height / 2, w: r.width, h: r.height, area });
                    }
                }
            }
            approx.delete();
            cnt.delete();
        }
    } finally {
        src.delete(); gray.delete(); blur.delete(); canny.delete(); dil.delete();
        contours.delete(); hier.delete();
        if (kernel) kernel.delete();
    }

    if (cands.length < need) return null;

    // Drop dwarves/giants relative to the median square area.
    cands.sort((a, b) => a.area - b.area);
    const medArea = cands[Math.floor(cands.length / 2)].area;
    const kept = cands.filter((c) => c.area > medArea * 0.4 && c.area < medArea * 2.5);
    if (kept.length < need) return null;

    return snapToGrid(kept, N);
}

/** Assign candidates to an N×N grid by position; return N² centroids in
 *  row-major order, or null if a full axis-aligned grid wasn't found.
 *
 *  Robust to extra/outlier candidates: we estimate the grid PITCH from the
 *  median nearest-neighbour distance, then try each candidate as the top-left
 *  origin and keep the placement that fills all N² cells (a Hough-style vote).
 *  Assumes the face is held roughly upright (no large rotation) — fine for a
 *  guided scan.  Exported for unit tests. */
export function snapToGrid(cands, N) {
    if (cands.length < N * N) return null;
    if (N === 1) return [{ cx: cands[0].cx, cy: cands[0].cy }];

    // Build an axis-aligned grid from origin (ox,oy) with the given pitch; fill
    // each cell with the nearest unused candidate inside `tol`.  Returns the N²
    // centroids row-major, or null if any cell is empty.
    function tryGrid(ox, oy, pitch) {
        const tol = pitch * 0.4, tol2 = tol * tol;
        const used = new Set();
        const out = new Array(N * N);
        for (let r = 0; r < N; r++) {
            for (let c = 0; c < N; c++) {
                const tx = ox + c * pitch, ty = oy + r * pitch;
                let best = -1, bestD = tol2;
                for (let i = 0; i < cands.length; i++) {
                    if (used.has(i)) continue;
                    const dx = cands[i].cx - tx, dy = cands[i].cy - ty;
                    const d = dx * dx + dy * dy;
                    if (d < bestD) { bestD = d; best = i; }
                }
                if (best < 0) return null;
                used.add(best);
                out[r * N + c] = { cx: cands[best].cx, cy: cands[best].cy };
            }
        }
        return out;
    }

    // Hypothesise the pitch from PAIRS: each candidate as the top-left origin,
    // paired with every plausible same-row right-neighbour as cell (0,1).  This
    // avoids a fragile global pitch estimate (junk between stickers deflates a
    // nearest-neighbour median and breaks the far corners).
    for (const o of cands) {
        for (const a of cands) {
            const dx = a.cx - o.cx, dy = a.cy - o.cy;
            if (dx <= 2) continue;                   // must be to the right
            if (Math.abs(dy) > dx * 0.35) continue;  // ~same row (near-upright)
            const grid = tryGrid(o.cx, o.cy, dx);
            if (grid) return grid;
        }
    }
    return null;
}
