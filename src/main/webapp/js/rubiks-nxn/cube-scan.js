/**
 * cube-scan.js — webcam cube scanner (browser-only, no backend).
 *
 * Approach mirrors the well-proven open-source scanners (kkoomen/qbr,
 * dwalton76/rubiks-cube-tracker): a guided per-face capture, then colours
 * resolved in CIE Lab space against the six face *centres* as anchors.  We do
 * NOT try to auto-detect the cube in a busy frame — the user lines the face up
 * inside a fixed N×N guide overlay, which is what makes simple scanners
 * reliable.  Vision's only job is to emit the 54-char (or 6·N²) URFDLB state
 * string; the existing validate / solve pipeline takes it from there.
 *
 * Orientation: the user is told to present each face in the SAME orientation as
 * the standard unfolded-cross net (the layout parser.js already reads), so the
 * on-screen grid cell (row r, col c) maps directly to net facePos = r*N + c.
 * Because we prompt which face is which, the centre of each captured face
 * directly anchors that face's colour — no 720-perm search needed.
 */

import { rgbToLab, labDistance, sampleAverage, WCA_FACE_COLORS } from './parser.js';
import { loadOpenCV, detectFaceGrid } from './cube-detect.js';

const HEX = (h) => [parseInt(h.slice(1,3),16), parseInt(h.slice(3,5),16), parseInt(h.slice(5,7),16)];

const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];
const FACE_OFFSET = (N) => ({ U: 0, R: N*N, F: 2*N*N, D: 3*N*N, L: 4*N*N, B: 5*N*N });

// Capture order + guidance.  `hint` is the usual Western-scheme colour (just a
// hint — the real identity comes from the captured centre).  `hold` tells the
// user how to orient the face so its on-screen view matches the net.
const STEPS = [
    { face: 'F', hint: 'green',  hold: 'Front face to the camera, white/top side UP.' },
    { face: 'R', hint: 'red',    hold: 'Turn the cube LEFT 90° (right face now to camera), top still UP.' },
    { face: 'B', hint: 'blue',   hold: 'Turn LEFT 90° again (back face to camera), top still UP.' },
    { face: 'L', hint: 'orange', hold: 'Turn LEFT 90° again (left face to camera), top still UP.' },
    { face: 'U', hint: 'white',  hold: 'Back to Front, then tilt the TOP toward the camera (the side that faced you ends at the BOTTOM of the frame).' },
    { face: 'D', hint: 'yellow', hold: 'Tilt the BOTTOM toward the camera (the side that faced you ends at the TOP of the frame).' },
];

/** Inner-sticker facePos for a face — the centre (N odd) or inner block (N even).
 *  Averaging these gives a stable colour anchor for the face. */
function innerFacePositions(N) {
    if (N % 2 === 1) return [((N - 1) / 2) * N + (N - 1) / 2];   // single centre
    const out = [];
    for (let r = 1; r < N - 1; r++) for (let c = 1; c < N - 1; c++) out.push(r * N + c);
    return out.length ? out : [0];
}

/**
 * Resolve a full scan into a cube-state string.  PURE — unit-testable.
 *
 * @param {Object<string, number[][]>} faceSamples  per-face array of N²
 *        [r,g,b] samples, indexed by net facePos = r*N + c.
 * @param {number} N
 * @returns {{ok:true, state:string} | {ok:false, reason:string}}
 */
export function resolveScan(faceSamples, N) {
    const perFace = N * N;
    for (const f of FACES) {
        const a = faceSamples[f];
        if (!Array.isArray(a) || a.length !== perFace) {
            return { ok: false, reason: `Face ${f} not captured (need ${perFace} samples).` };
        }
    }

    // Anchor Lab per face.  ODD cubes have FIXED centres — the captured centre
    // of each scanned face is that face's true colour, lighting-calibrated and
    // robust.  EVEN cubes have no fixed centre (every inner sticker moves when
    // scrambled), so there's nothing to calibrate from — fall back to the
    // standard WCA reference colours (assumes a standard-scheme cube, the
    // common case).  This is why webcam scanners are most reliable on 3×3.
    const anchorLab = {};
    if (N % 2 === 1) {
        const c = ((N - 1) / 2) * N + (N - 1) / 2;     // single fixed centre
        for (const f of FACES) anchorLab[f] = rgbToLab(faceSamples[f][c]);
    } else {
        for (const f of FACES) anchorLab[f] = rgbToLab(HEX(WCA_FACE_COLORS[f]));
    }

    // CAPACITY-CONSTRAINED assignment.  A legal cube has exactly N² of each
    // colour, so we don't classify stickers independently (that flips
    // red↔orange / white↔yellow under uneven light and breaks the counts).
    // Instead: every sticker ranks the 6 anchors by Lab distance; we assign the
    // most *confident* stickers first (largest gap between best and 2nd-best),
    // and once a colour is full the sticker falls to its nearest still-open
    // colour.  This is the approach dwalton76's rubiks-color-resolver uses.
    const off = FACE_OFFSET(N);
    const stickers = [];               // { idx, dists:{face:d}, best, margin }
    for (const f of FACES) {
        for (let p = 0; p < perFace; p++) {
            const lab = rgbToLab(faceSamples[f][p]);
            const dists = {};
            let best = FACES[0], bestD = Infinity, second = Infinity;
            for (const g of FACES) {
                const d = labDistance(lab, anchorLab[g]);
                dists[g] = d;
                if (d < bestD) { second = bestD; bestD = d; best = g; }
                else if (d < second) { second = d; }
            }
            stickers.push({ idx: off[f] + p, dists, best, margin: second - bestD });
        }
    }
    // Most confident first.
    stickers.sort((a, b) => b.margin - a.margin);

    const cap = {}; for (const f of FACES) cap[f] = perFace;
    const out = new Array(6 * perFace);
    for (const s of stickers) {
        let chosen = null, chosenD = Infinity;
        for (const g of FACES) {
            if (cap[g] > 0 && s.dists[g] < chosenD) { chosenD = s.dists[g]; chosen = g; }
        }
        out[s.idx] = chosen;
        cap[chosen]--;
    }
    // With fixed capacities this always lands exactly N² per colour; only a
    // degenerate (all-anchors-identical) scan could fail, so guard anyway.
    const counts = {};
    for (const ch of out) counts[ch] = (counts[ch] || 0) + 1;
    const bad = FACES.filter((f) => counts[f] !== perFace);
    if (bad.length) {
        return {
            ok: false,
            reason: `Could not resolve colours (${bad.map((f) => `${f}:${counts[f] || 0}`).join(', ')}). `
                  + `Re-scan under even lighting, or fix stickers on the net in Edit mode.`,
            state: out.join(''),
        };
    }
    return { ok: true, state: out.join('') };
}

/**
 * Mount the camera-scanner UI inside `host`.
 *
 * @param {HTMLElement} host  empty container (shown/hidden by the caller).
 * @param {{ size:number, onComplete:(state:string)=>void, onCancel?:()=>void,
 *           onPartial?:(state:string,reason:string)=>void }} opts
 * @returns {{ close:()=>void }}
 */
export function mountScanner(host, opts) {
    const N = opts.size;
    const perFace = N * N;
    let stream = null;
    let stepIdx = 0;
    const captured = {};               // face -> N² [r,g,b]

    host.innerHTML = '';
    const root = el('div', 'rk-scan');

    const stage = el('div', 'rk-scan-stage');
    const video = document.createElement('video');
    video.autoplay = true; video.playsInline = true; video.muted = true;
    video.setAttribute('playsinline', '');     // iOS
    const grid = el('div', 'rk-scan-grid');
    grid.style.gridTemplateColumns = `repeat(${N}, 1fr)`;
    grid.style.gridTemplateRows = `repeat(${N}, 1fr)`;
    for (let i = 0; i < perFace; i++) grid.appendChild(el('div', 'rk-scan-cell'));
    const detectCanvas = document.createElement('canvas');   // auto-detect overlay
    detectCanvas.className = 'rk-scan-detect';
    detectCanvas.style.display = 'none';
    stage.appendChild(video);
    stage.appendChild(grid);
    stage.appendChild(detectCanvas);

    const side = el('div', 'rk-scan-side');
    const prog = el('p', 'rk-scan-prog');
    const cross = buildCross();
    const instr = el('p', 'rk-scan-instr');
    const msg = el('p', 'rk-scan-msg');
    const autoLabel = el('label', 'rk-scan-auto');
    const autoChk = document.createElement('input');
    autoChk.type = 'checkbox';
    autoLabel.append(autoChk, document.createTextNode(' Auto-detect (point the cube — captures itself)'));
    const btnRow = el('div', 'rk-scan-btns');
    const captureBtn = button('Capture face', 'rk-btn rk-btn-primary');
    const backBtn = button('← Back', 'rk-btn');
    const cancelBtn = button('Cancel', 'rk-btn');
    backBtn.style.display = 'none';
    btnRow.append(backBtn, captureBtn, cancelBtn);
    side.append(prog, cross.svg, instr, autoLabel, msg, btnRow);

    root.append(stage, side);
    host.appendChild(root);

    function setStep(i) {
        stepIdx = i;
        const step = STEPS[i];
        prog.textContent = `Face ${i + 1} of 6 — scanning ${step.face} (usually ${step.hint})`;
        instr.textContent = step.hold;
        msg.textContent = '';
        cross.highlight(step.face);
        backBtn.style.display = i > 0 ? '' : 'none';
        captureBtn.textContent = i === 5 ? 'Capture & finish' : 'Capture face';
    }

    // Grab the centred square crop of the current frame (matches the square
    // stage with object-fit:cover, so crop coords map 1:1 to display).
    let _cropCnv = null;
    function cropFrame() {
        const vw = video.videoWidth, vh = video.videoHeight;
        if (!vw || !vh) return null;
        const side0 = Math.min(vw, vh);
        const sx = (vw - side0) / 2, sy = (vh - side0) / 2;
        if (!_cropCnv) _cropCnv = document.createElement('canvas');
        _cropCnv.width = side0; _cropCnv.height = side0;
        const cx = _cropCnv.getContext('2d', { willReadFrequently: true });
        cx.drawImage(video, sx, sy, side0, side0, 0, 0, side0, side0);
        return { img: cx.getImageData(0, 0, side0, side0), side0 };
    }

    // Manual sample: N² fixed grid points under the guide overlay.
    function sampleFrame() {
        const f = cropFrame();
        if (!f) return null;
        const cell = f.side0 / N;
        const half = Math.max(2, Math.floor(cell * 0.22));
        const out = [];
        for (let r = 0; r < N; r++) {
            for (let c = 0; c < N; c++) {
                out[r * N + c] = sampleAverage(f.img, Math.floor((c + 0.5) * cell), Math.floor((r + 0.5) * cell), half);
            }
        }
        return out;
    }

    // Sample colours at detected centroids (auto mode).
    function sampleAt(img, centroids) {
        // patch size from grid pitch (distance between first two cells)
        let pitch = img.width / N;
        if (centroids.length > 1) pitch = Math.hypot(centroids[1].cx - centroids[0].cx, centroids[1].cy - centroids[0].cy) || pitch;
        const half = Math.max(2, Math.floor(pitch * 0.22));
        return centroids.map((p) => sampleAverage(img, Math.floor(p.cx), Math.floor(p.cy), half));
    }

    function commitFace(samples) {
        const face = STEPS[stepIdx].face;
        captured[face] = samples;
        cross.setColor(face, samples[innerFacePositions(N)[0]]);
        if (stepIdx < 5) setStep(stepIdx + 1); else finish();
    }

    function doCapture() {
        const samples = sampleFrame();
        if (!samples) { msg.textContent = 'Camera not ready yet…'; return; }
        commitFace(samples);
    }
    captureBtn.onclick = doCapture;

    backBtn.addEventListener('click', () => { if (stepIdx > 0) setStep(stepIdx - 1); });
    cancelBtn.addEventListener('click', () => { close(); opts.onCancel && opts.onCancel(); });

    function finish() {
        const res = resolveScan(captured, N);
        if (res.ok) {
            close();
            opts.onComplete(res.state);
            return;
        }
        // Counts off — keep the camera open and let the user re-scan.
        msg.textContent = res.reason;
        if (res.state && opts.onPartial) opts.onPartial(res.state, res.reason);
        captureBtn.textContent = 'Re-scan from face 1';
        captureBtn.onclick = () => {
            for (const k of FACES) delete captured[k];
            captureBtn.onclick = doCapture;
            setStep(0);
        };
    }

    // ── Auto-detect (OpenCV.js, lazy) ─────────────────────────────────────────
    let cv = null;
    let detectTimer = 0;
    let lastGrid = null, stableCount = 0, armed = true;
    const STABLE_NEEDED = 4;          // consecutive stable detections → capture
    const dctx = detectCanvas.getContext('2d');

    function stopDetect() {
        if (detectTimer) { clearInterval(detectTimer); detectTimer = 0; }
        lastGrid = null; stableCount = 0; armed = true;
        dctx && dctx.clearRect(0, 0, detectCanvas.width, detectCanvas.height);
    }

    function gridMoved(a, b) {                 // mean centroid displacement
        let s = 0;
        for (let i = 0; i < a.length; i++) s += Math.hypot(a[i].cx - b[i].cx, a[i].cy - b[i].cy);
        return s / a.length;
    }

    function drawDetect(grid, side0) {
        const W = stage.clientWidth || side0;
        detectCanvas.width = W; detectCanvas.height = W;
        const k = W / side0;
        dctx.clearRect(0, 0, W, W);
        dctx.lineWidth = 2; dctx.strokeStyle = '#22d3ee';
        const r = (side0 / N) * 0.32 * k;
        for (const p of grid) {
            dctx.beginPath();
            dctx.rect(p.cx * k - r, p.cy * k - r, r * 2, r * 2);
            dctx.stroke();
        }
    }

    function detectTick() {
        if (!cv) return;
        const f = cropFrame();
        if (!f) return;
        let grid = null;
        try { grid = detectFaceGrid(cv, f.img, N); } catch (e) { grid = null; }
        if (!grid) {
            // Face left the view (e.g. user is rotating) → re-arm for next capture.
            lastGrid = null; stableCount = 0; armed = true;
            dctx.clearRect(0, 0, detectCanvas.width, detectCanvas.height);
            return;
        }
        drawDetect(grid, f.side0);
        if (!armed) { msg.textContent = 'Captured — rotate to the next face.'; lastGrid = grid; return; }
        const pitch = grid.length > 1 ? Math.hypot(grid[1].cx - grid[0].cx, grid[1].cy - grid[0].cy) : f.side0 / N;
        if (lastGrid && gridMoved(grid, lastGrid) < pitch * 0.08) stableCount++;
        else stableCount = 0;
        lastGrid = grid;
        msg.textContent = `Detected — hold steady (${Math.min(stableCount, STABLE_NEEDED)}/${STABLE_NEEDED})`;
        if (stableCount >= STABLE_NEEDED) {
            stableCount = 0;
            armed = false;                          // require the face to leave before next capture
            commitFace(sampleAt(f.img, grid));      // auto-capture this face
        }
    }

    async function enableAuto() {
        msg.textContent = 'Loading detector (one-time ~10 MB)…';
        grid.style.display = 'none';
        detectCanvas.style.display = '';
        try {
            cv = await loadOpenCV();
        } catch (err) {
            msg.textContent = 'Auto-detect unavailable: ' + (err.message || err) + '. Using manual capture.';
            autoChk.checked = false; disableAuto();
            return;
        }
        if (!autoChk.checked) return;        // user toggled back while loading
        msg.textContent = 'Point the cube face at the camera…';
        detectTimer = setInterval(detectTick, 180);
    }
    function disableAuto() {
        stopDetect();
        detectCanvas.style.display = 'none';
        grid.style.display = '';
        if (!captureBtn.disabled) msg.textContent = '';
    }
    autoChk.addEventListener('change', () => { autoChk.checked ? enableAuto() : disableAuto(); });

    function close() {
        stopDetect();
        if (stream) { stream.getTracks().forEach((t) => t.stop()); stream = null; }
        host.innerHTML = '';
    }

    // Kick off the camera.
    (async () => {
        // getUserMedia needs a secure context (https or localhost).  Over a
        // plain-http LAN IP, navigator.mediaDevices is undefined.
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            failCamera(
                'Camera needs a secure page (https:// or http://localhost). '
              + 'You appear to be on plain http — open the site over https or via localhost, '
              + 'or use Upload net / Edit instead.'
            );
            return;
        }
        try {
            stream = await navigator.mediaDevices.getUserMedia({
                video: { facingMode: { ideal: 'environment' }, width: { ideal: 1280 }, height: { ideal: 720 } },
                audio: false,
            });
            video.srcObject = stream;
            setStep(0);
        } catch (err) {
            failCamera(explainCameraError(err));
        }
    })();

    function failCamera(text) {
        instr.textContent = '';
        msg.textContent = text;
        captureBtn.disabled = true;
    }

    return { close };
}

// Turn a getUserMedia error into something actionable.  The most confusing one
// is macOS "Permission denied by system": the SITE prompt was accepted, but the
// OS blocks the BROWSER from the camera (per-app gate above the browser).
function explainCameraError(err) {
    const name = err && err.name || '';
    const m = (err && err.message || '').toLowerCase();
    if (name === 'NotAllowedError' && m.includes('system')) {
        return 'Your operating system is blocking the browser from the camera (you allowed the site, '
             + 'but the OS still needs to allow the browser app). On macOS: System Settings → Privacy & '
             + 'Security → Camera → turn ON for your browser, then fully quit and reopen the browser. '
             + 'On Windows: Settings → Privacy → Camera → allow desktop apps.';
    }
    if (name === 'NotAllowedError') {
        return 'Camera permission was denied. Click the camera icon in the address bar (or site settings) '
             + 'to allow it, then reopen Scan. Meanwhile you can Upload net or Edit.';
    }
    if (name === 'NotFoundError' || name === 'OverconstrainedError') {
        return 'No camera was found on this device. Use Upload net or Edit instead.';
    }
    if (name === 'NotReadableError') {
        return 'The camera is in use by another app (Zoom, Photo Booth, etc.). Close it and reopen Scan.';
    }
    return 'Camera unavailable: ' + (err && err.message || err) + '. Use Upload net or Edit instead.';
}

/* ── tiny DOM + cross-diagram helpers ─────────────────────────────────────── */
function el(tag, cls) { const e = document.createElement(tag); if (cls) e.className = cls; return e; }
function button(text, cls) { const b = el('button', cls); b.type = 'button'; b.textContent = text; return b; }

// A small unfolded-cross diagram: shows which face to scan + fills captured
// centre colours so the user sees progress.
function buildCross() {
    const NS = 'http://www.w3.org/2000/svg';
    const svg = document.createElementNS(NS, 'svg');
    svg.setAttribute('viewBox', '0 0 120 90');
    svg.setAttribute('class', 'rk-scan-cross');
    // cross cell positions (col,row) in a 4×3 grid of 30px cells
    const pos = { U: [1, 0], L: [0, 1], F: [1, 1], R: [2, 1], B: [3, 1], D: [1, 2] };
    const cells = {};
    for (const f of FACES) {
        const [cx, ry] = pos[f];
        const rect = document.createElementNS(NS, 'rect');
        rect.setAttribute('x', cx * 30 + 1); rect.setAttribute('y', ry * 30 + 1);
        rect.setAttribute('width', 28); rect.setAttribute('height', 28);
        rect.setAttribute('rx', 4);
        rect.setAttribute('fill', '#1e293b');
        rect.setAttribute('stroke', '#475569');
        rect.setAttribute('stroke-width', 1.5);
        svg.appendChild(rect);
        const label = document.createElementNS(NS, 'text');
        label.setAttribute('x', cx * 30 + 15); label.setAttribute('y', ry * 30 + 19);
        label.setAttribute('text-anchor', 'middle');
        label.setAttribute('font-size', '12');
        label.setAttribute('font-family', 'monospace');
        label.setAttribute('fill', '#e2e8f0');
        label.textContent = f;
        svg.appendChild(label);
        cells[f] = { rect, label };
    }
    function highlight(face) {
        for (const f of FACES) {
            cells[f].rect.setAttribute('stroke', f === face ? '#fbbf24' : '#475569');
            cells[f].rect.setAttribute('stroke-width', f === face ? 3 : 1.5);
        }
    }
    function setColor(face, rgb) {
        const hex = '#' + rgb.map((v) => Math.round(v).toString(16).padStart(2, '0')).join('');
        cells[face].rect.setAttribute('fill', hex);
        // dark text on light fills, light on dark
        const lum = 0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2];
        cells[face].label.setAttribute('fill', lum > 140 ? '#0f172a' : '#e2e8f0');
    }
    return { svg, highlight, setColor };
}
