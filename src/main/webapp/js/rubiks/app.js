/**
 * Top-level UI orchestrator (port of App.tsx, vanilla DOM).
 *
 * Wires the 2D net + 3D cube to a single source-of-truth state string, plus:
 *   - file upload / paste (⌘V) / drag-and-drop image → parser → state
 *   - random scramble + reset + share
 *   - solve → step playback (← / → / space, auto-play with slow/normal/fast)
 *   - sticker click to fix mis-detected colors
 *
 * Mounting: page calls `bootstrap()` once on DOMContentLoaded with refs to
 * its placeholder elements. Element IDs are kept stable so the JSP can
 * style them.
 */

import {
    SOLVED_STATE, FACES, validateState, setSticker,
    FACE_COLORS, PLACEMENTS, GRID_COLS, GRID_ROWS,
} from './cube.js';
import { parseMove, describeMove, stickerIndicesForFace } from './moves.js';
import { decodeStateFromHash, shareUrl } from './share.js';
import { loadImageToBuffer, parseNet } from './parser.js';
import { mountCubeNet } from './cube-net.js';
import { mountCube3D } from './cube-3d.js';
import {
    initSolver, solve, applyMoves, randomState, isSolverReady,
    UnsolvableCubeError,
} from './solver.js';

const SPEED_MS = { slow: 1500, normal: 700, fast: 300 };

/** All UI state lives here. Mutating it triggers paint(). */
const ui = {
    state: SOLVED_STATE,
    moves: null,            // null | string[]
    stepIndex: 0,
    autoPlay: false,
    playSpeed: 'normal',
    solverReady: false,
    solveBusy: false,       // boolean
    solveError: null,       // string | null
    parseError: null,       // string | null
    shareFeedback: null,    // string | null
    /** Manual move history — array of { move, prevState }.  Each entry is one
     *  user-initiated twist (button click or keyboard); solve / step playback
     *  / random scramble do NOT push to history. */
    history: [],
    /** GIF recording state. */
    recording: false,
    recordingStatus: null,
};

/** DOM refs filled in by bootstrap(). */
const dom = {
    net: null,            // SVG net wrapper { update, el }
    cube3d: null,         // 3D wrapper { setState, dispose, el }
    netHost: null,
    cube3dHost: null,
    fileInput: null,
    statusEl: null,
    validationEl: null,
    parseErrorEl: null,
    solveErrorEl: null,
    shareFeedbackEl: null,
    solveBtn: null,
    solveSpinner: null,
    movesList: null,
    movesPanel: null,
    movesHeader: null,
    movesStatus: null,
    prevBtn: null,
    nextBtn: null,
    playBtn: null,
    speedBtns: {},        // {slow, normal, fast}
    // Compact playback strip in the toolbar (mirrors the panel controls).
    playbackStrip: null,
    tbSummary: null,
    tbStep: null,
    tbPrevBtn: null,
    tbNextBtn: null,
    tbPlayBtn: null,
    // History strip + GIF recording.
    historyStrip: null,
    historyList: null,
    undoBtn: null,
    recordBtn: null,
    recordStatus: null,
    uploadBtn: null,
    scrambleBtn: null,
    resetBtn: null,
    shareBtn: null,
};

/* ─────────────────────────────────────────────────────────────────── */

/** Compute derived values + repaint everything. */
async function paint() {
    const validation = validateState(ui.state);

    // Display state = state with first stepIndex moves applied (if a solve
    // has been computed). Need this for both 2D and 3D.
    let displayState = ui.state;
    if (ui.moves && ui.stepIndex > 0) {
        displayState = await applyMoves(ui.state, ui.moves.slice(0, ui.stepIndex));
    }

    const upcomingMove =
        ui.moves && ui.stepIndex < ui.moves.length
            ? parseMove(ui.moves[ui.stepIndex]) : null;
    const highlight = upcomingMove ? stickerIndicesForFace(upcomingMove.face) : [];

    ui.displayState = displayState;
    dom.net.update({
        state: displayState,
        editable: !ui.moves && !ui.solveBusy,
        highlightIndices: highlight,
    });
    if (dom.cube3d) dom.cube3d.setState(displayState);

    // Status pill — only shown while initialising or during a solve / error.
    // Once the solver is ready and idle, the pill provides no signal, so hide it.
    if (dom.statusEl) {
        const showPill = !ui.solverReady || ui.solveBusy;
        dom.statusEl.style.display = showPill ? '' : 'none';
        if (showPill) {
            dom.statusEl.textContent = ui.solveBusy
                ? 'Solving…'
                : (ui.solverReady ? 'Solver: ready' : 'Solver: initializing…');
            dom.statusEl.dataset.state = ui.solverReady ? 'ready' : 'init';
        }
    }

    // Validation banner (only when no moves shown)
    if (dom.validationEl) {
        if (ui.moves || ui.solveBusy) {
            dom.validationEl.style.display = 'none';
        } else {
            dom.validationEl.style.display = '';
            if (validation.ok) {
                dom.validationEl.textContent =
                    'Valid cube state — click any sticker to fix a wrong color. ' +
                    'Tip: paste (⌘V) or drop a net image anywhere on the page.';
                dom.validationEl.className = 'rk-banner rk-banner-ok';
            } else {
                dom.validationEl.textContent = `Invalid: ${validation.reason}`;
                dom.validationEl.className = 'rk-banner rk-banner-bad';
            }
        }
    }

    // Errors
    if (dom.parseErrorEl) {
        dom.parseErrorEl.style.display = ui.parseError ? '' : 'none';
        dom.parseErrorEl.textContent = ui.parseError
            ? `Image parse error: ${ui.parseError}`
            : '';
    }
    if (dom.solveErrorEl) {
        dom.solveErrorEl.style.display = ui.solveError ? '' : 'none';
        dom.solveErrorEl.textContent = ui.solveError || '';
    }
    if (dom.shareFeedbackEl) {
        dom.shareFeedbackEl.style.display = ui.shareFeedback ? '' : 'none';
        dom.shareFeedbackEl.textContent = ui.shareFeedback || '';
    }

    // Solve button
    const canSolve = validation.ok && ui.solverReady && !ui.solveBusy;
    if (dom.solveBtn) {
        dom.solveBtn.disabled = !canSolve;
        dom.solveBtn.textContent = ui.solveBusy ? 'Solving…' : 'Solve';
        dom.solveBtn.title = !canSolve && !validation.ok ? validation.reason : '';
    }

    // Manual twist buttons — disable during a solve or recording.
    document.querySelectorAll('[data-move]').forEach((btn) => {
        btn.disabled = !!ui.solveBusy || !!ui.recording;
    });

    // History strip: visible whenever there are manual twists to undo.
    if (dom.historyStrip) {
        if (ui.history.length === 0) {
            dom.historyStrip.style.display = 'none';
        } else {
            dom.historyStrip.style.display = '';
            renderHistoryStrip();
        }
    }

    // GIF record button + status pill in the solution panel.
    if (dom.recordStatus) {
        if (ui.recordingStatus) {
            dom.recordStatus.style.display = '';
            dom.recordStatus.textContent = ui.recordingStatus;
        } else {
            dom.recordStatus.style.display = 'none';
        }
    }
    if (dom.recordBtn) {
        const can3d = !!dom.cube3d;
        const hasMoves = !!(ui.moves && ui.moves.length > 0);
        dom.recordBtn.disabled = !can3d || !hasMoves || !!ui.recording || !!ui.solveBusy;
        dom.recordBtn.textContent = ui.recording ? 'Recording…' : '🎬 Record GIF';
    }

    // Solution panel
    if (dom.movesPanel) {
        if (!ui.moves) {
            dom.movesPanel.style.display = 'none';
        } else {
            dom.movesPanel.style.display = '';
            renderMovesPanel();
        }
    }

    // Compact toolbar playback strip — mirrors the panel's primary controls.
    if (dom.playbackStrip) {
        if (!ui.moves) {
            dom.playbackStrip.style.display = 'none';
        } else {
            dom.playbackStrip.style.display = '';
            renderPlaybackStrip();
        }
    }
}

function renderHistoryStrip() {
    if (!dom.historyList) return;
    dom.historyList.innerHTML = '';
    ui.history.forEach((entry) => {
        const span = document.createElement('span');
        span.className = 'rk-move';
        span.textContent = entry.move;
        dom.historyList.appendChild(span);
    });
    if (dom.undoBtn) {
        dom.undoBtn.disabled = !!ui.solveBusy || !!ui.recording;
    }
}

function renderPlaybackStrip() {
    const moves = ui.moves || [];
    const completed = ui.stepIndex >= moves.length;

    if (dom.tbSummary) {
        dom.tbSummary.textContent = moves.length === 0
            ? '✓ Already solved'
            : `Solution: ${moves.length} ${moves.length === 1 ? 'move' : 'moves'}`;
    }
    if (dom.tbStep) {
        dom.tbStep.textContent = moves.length === 0
            ? ''
            : completed
                ? `All ${moves.length} applied`
                : `Step ${ui.stepIndex + 1} / ${moves.length}`;
    }
    if (dom.tbPrevBtn) dom.tbPrevBtn.disabled = ui.stepIndex === 0;
    if (dom.tbNextBtn) dom.tbNextBtn.disabled = ui.stepIndex >= moves.length;
    if (dom.tbPlayBtn) {
        dom.tbPlayBtn.disabled = completed || moves.length === 0;
        dom.tbPlayBtn.textContent = ui.autoPlay ? '⏸ Pause' : '▶ Play';
    }
}

function renderMovesPanel() {
    const moves = ui.moves || [];
    const completed = ui.stepIndex >= moves.length;
    const upcoming = !completed ? parseMove(moves[ui.stepIndex]) : null;

    if (dom.movesHeader) {
        if (moves.length === 0) {
            dom.movesHeader.textContent = 'Already solved — no moves needed.';
        } else {
            dom.movesHeader.textContent =
                `Solution: ${moves.length} ${moves.length === 1 ? 'move' : 'moves'}`;
        }
    }

    if (dom.movesList) {
        dom.movesList.innerHTML = '';
        moves.forEach((m, i) => {
            const span = document.createElement('span');
            span.className = 'rk-move' +
                (i < ui.stepIndex ? ' done' :
                 i === ui.stepIndex ? ' current' : '');
            span.textContent = m;
            span.addEventListener('click', () => {
                ui.autoPlay = false;
                ui.stepIndex = i;
                paint();
            });
            dom.movesList.appendChild(span);
        });
    }

    // Status text is unique to the panel (toolbar strip just shows "Step
    // 5/22"; the panel adds the descriptive "Up face — 90° clockwise").
    if (dom.movesStatus) {
        if (completed) {
            dom.movesStatus.textContent = `Solved! All ${moves.length} moves applied.`;
        } else {
            const detail = upcoming ? ` — ${describeMove(upcoming)}` : '';
            dom.movesStatus.textContent =
                `Move ${ui.stepIndex + 1} of ${moves.length}${detail}`;
        }
    }

    // NOTE: Prev / Play / Next buttons used to live in the panel too — those
    // are now toolbar-only to avoid duplicate controls.  See renderPlaybackStrip.

    for (const [k, btn] of Object.entries(dom.speedBtns)) {
        btn.classList.toggle('active', k === ui.playSpeed);
    }
}

/* ─────────────────────────────────────────────────────────────────── */

/** Set state, clear any solve in flight. Called whenever the cube changes. */
function setStateAndClearMoves(next, opts = {}) {
    ui.state = next;
    ui.moves = null;
    ui.stepIndex = 0;
    ui.autoPlay = false;
    ui.solveError = null;
    if (!opts.preserveHistory) ui.history = [];
    paint();
}

/** Undo the most recent manual twist.  Cmd/Ctrl-Z also calls this. */
function undo() {
    if (ui.solveBusy || ui.recording || ui.history.length === 0) return;
    const { prevState } = ui.history.pop();
    setStateAndClearMoves(prevState, { preserveHistory: true });
}

function handleStickerChange(index, nextFace) {
    if (ui.moves || ui.solveBusy) return;
    setStateAndClearMoves(setSticker(ui.state, index, nextFace));
}

async function handleFile(file) {
    ui.parseError = null;
    paint();
    try {
        const img = await loadImageToBuffer(file);
        const result = parseNet(img);
        if (!result.ok) {
            ui.parseError = result.reason;
            paint();
            return;
        }
        setStateAndClearMoves(result.state);
    } catch (err) {
        ui.parseError = err && err.message ? err.message : String(err);
        paint();
    }
}

async function handleSolve() {
    if (ui.solveBusy) return;
    ui.solveError = null;
    ui.moves = null;
    ui.stepIndex = 0;
    ui.autoPlay = false;
    ui.solveBusy = true;
    paint();
    const requestState = ui.state;
    try {
        const result = await solve(requestState);
        if (ui.state !== requestState) return;
        ui.moves = result;
    } catch (err) {
        if (ui.state !== requestState) return;
        const message = err instanceof UnsolvableCubeError
            ? err.message
            : (err && err.message ? err.message : String(err));
        ui.solveError = message;
    } finally {
        ui.solveBusy = false;
        paint();
    }
}

async function handleScramble() {
    setStateAndClearMoves(await randomState());
}

/** Apply a single move (e.g. "U", "R'", "F2") manually.  Clears any active
 *  solution since the cube state no longer matches the moves we computed.
 *  cube-3d.js's setState() detects the single-move delta and animates it. */
async function handleManualMove(move) {
    if (ui.solveBusy || ui.recording) return;
    try {
        const prevState = ui.state;
        const next = await applyMoves(prevState, move);
        ui.history.push({ move, prevState });
        setStateAndClearMoves(next, { preserveHistory: true });
    } catch (err) {
        console.warn('Manual move failed:', move, err);
    }
}

function handleReset() {
    setStateAndClearMoves(SOLVED_STATE);
}

async function handleShare() {
    const url = shareUrl(ui.state);
    try {
        await navigator.clipboard.writeText(url);
        ui.shareFeedback = 'Link copied!';
    } catch {
        ui.shareFeedback = url;
    }
    paint();
    setTimeout(() => { ui.shareFeedback = null; paint(); }, 2500);
}

/* Auto-play tick. */
let autoPlayTimer = null;
function maybeStartAutoPlay() {
    if (autoPlayTimer) {
        clearTimeout(autoPlayTimer);
        autoPlayTimer = null;
    }
    if (!ui.autoPlay || !ui.moves) return;
    if (ui.stepIndex >= ui.moves.length) {
        ui.autoPlay = false;
        paint();
        return;
    }
    autoPlayTimer = setTimeout(() => {
        ui.stepIndex = Math.min(ui.moves.length, ui.stepIndex + 1);
        paint();
        maybeStartAutoPlay();
    }, SPEED_MS[ui.playSpeed]);
}

function step(delta) {
    if (!ui.moves) return;
    ui.autoPlay = false;
    ui.stepIndex = Math.max(0, Math.min(ui.moves.length, ui.stepIndex + delta));
    paint();
}

function togglePlay() {
    if (!ui.moves || ui.stepIndex >= ui.moves.length) return;
    ui.autoPlay = !ui.autoPlay;
    paint();
    maybeStartAutoPlay();
}

// Stroke + fill so the watermark stays readable against any cube color.
function drawWatermark(ctx, w, h) {
    const text = '8gwifi.org/math/rubiks-cube-solver.jsp';
    const fontSize = Math.max(11, Math.round(w / 60));
    ctx.save();
    ctx.font = `600 ${fontSize}px Inter, -apple-system, system-ui, sans-serif`;
    ctx.textAlign = 'right';
    ctx.textBaseline = 'bottom';
    ctx.lineWidth = 3;
    ctx.strokeStyle = 'rgba(0, 0, 0, 0.6)';
    ctx.strokeText(text, w - 10, h - 8);
    ctx.fillStyle = 'rgba(255, 255, 255, 0.92)';
    ctx.fillText(text, w - 10, h - 8);
    ctx.restore();
}

/** Draw the unfolded net into a 2D canvas region using PLACEMENTS + state.
 *  Native net dims are GRID_COLS×GRID_ROWS×NET_STICKER_SIZE; `scale` resizes
 *  to fit the host frame. */
const NET_STICKER_SIZE = 40;
const NET_STICKER_GAP = 2;
const NET_RADIUS = 4;
function drawNet(ctx, state, x, y, scale) {
    if (!state || state.length !== 54) return;
    const stroke = '#1e293b';
    for (const p of PLACEMENTS) {
        const sx = x + (p.col * NET_STICKER_SIZE + NET_STICKER_GAP / 2) * scale;
        const sy = y + (p.row * NET_STICKER_SIZE + NET_STICKER_GAP / 2) * scale;
        const size = (NET_STICKER_SIZE - NET_STICKER_GAP) * scale;
        const r = NET_RADIUS * scale;
        ctx.fillStyle = FACE_COLORS[state[p.index]] || '#888';
        ctx.beginPath();
        ctx.roundRect(sx, sy, size, size, r);
        ctx.fill();
        ctx.lineWidth = Math.max(1, scale * 0.8);
        ctx.strokeStyle = stroke;
        ctx.stroke();
    }
}

/**
 * Record solution playback as an animated GIF using gif.js.  Rewinds to
 * step 0, force-fast playback, captures the 3D canvas at 20 fps, encodes,
 * downloads.  Requires WebGLRenderer({preserveDrawingBuffer:true}) (set
 * in cube-3d.js).
 */
async function recordGif() {
    if (!ui.moves || ui.moves.length === 0) return;
    if (!dom.cube3d || !dom.cube3d.el) {
        ui.solveError = '3D preview is not loaded — cannot record.';
        paint();
        return;
    }
    if (ui.recording) return;

    ui.recording = true;
    ui.recordingStatus = 'Loading encoder…';
    paint();

    let GIF;
    let workerBlobUrl;
    try {
        const mod = await import('https://esm.sh/gif.js@0.2.0');
        GIF = mod.default || mod.GIF || mod;
        // The Worker constructor refuses cross-origin script URLs even when the
        // response has permissive CORS headers, so fetch the worker source and
        // hand it to gif.js as a same-origin blob URL.
        const workerResp = await fetch('https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.worker.js');
        workerBlobUrl = URL.createObjectURL(await workerResp.blob());
    } catch (err) {
        console.error('gif.js load failed:', err);
        ui.recording = false;
        ui.recordingStatus = null;
        ui.solveError = 'Could not load GIF encoder. Check your network and try again.';
        paint();
        return;
    }

    const canvas = dom.cube3d.el;
    // Compose [3D cube | unfolded net] side-by-side. Net is scaled so its
    // native height (GRID_ROWS*NET_STICKER_SIZE) matches the cube canvas
    // height; gap between the two panels is fixed in cube-pixel space.
    const GAP = 24;
    const PAD = 16;
    const netNativeH = GRID_ROWS * NET_STICKER_SIZE;
    const netNativeW = GRID_COLS * NET_STICKER_SIZE;
    const netScale = canvas.height / netNativeH;
    const netW = netNativeW * netScale;
    const frameW = canvas.width + GAP + netW + PAD * 2;
    const frameH = canvas.height + PAD * 2;
    const netOffsetX = PAD + canvas.width + GAP;
    const netOffsetY = PAD;

    const gif = new GIF({
        workers: 2,
        quality: 10,
        width: Math.round(frameW),
        height: Math.round(frameH),
        workerScript: workerBlobUrl,
    });

    const savedSpeed = ui.playSpeed;
    ui.stepIndex = 0;
    ui.autoPlay = false;
    ui.playSpeed = 'fast';
    paint();

    await new Promise((r) => setTimeout(r, 200));

    ui.recordingStatus = 'Capturing frames…';
    paint();
    const frameCanvas = document.createElement('canvas');
    frameCanvas.width = Math.round(frameW);
    frameCanvas.height = Math.round(frameH);
    const frameCtx = frameCanvas.getContext('2d');
    const captureInterval = setInterval(() => {
        frameCtx.fillStyle = '#0f172a';
        frameCtx.fillRect(0, 0, frameCanvas.width, frameCanvas.height);
        frameCtx.drawImage(canvas, PAD, PAD);
        drawNet(frameCtx, ui.displayState, netOffsetX, netOffsetY, netScale);
        drawWatermark(frameCtx, frameCanvas.width, frameCanvas.height);
        gif.addFrame(frameCtx, { delay: 50, copy: true });
    }, 50);

    ui.autoPlay = true;
    paint();
    maybeStartAutoPlay();

    await new Promise((resolve) => {
        const tick = setInterval(() => {
            if (!ui.moves || ui.stepIndex >= ui.moves.length) {
                clearInterval(tick);
                resolve();
            }
        }, 80);
    });
    await new Promise((r) => setTimeout(r, 500));
    clearInterval(captureInterval);

    ui.recordingStatus = 'Encoding GIF…';
    paint();

    gif.on('progress', (p) => {
        ui.recordingStatus = `Encoding GIF… ${Math.round(p * 100)}%`;
        paint();
    });
    gif.on('finished', (blob) => {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `rubiks-cube-solution-${Date.now()}.gif`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        setTimeout(() => URL.revokeObjectURL(url), 2000);
        URL.revokeObjectURL(workerBlobUrl);
        ui.recording = false;
        ui.recordingStatus = null;
        ui.playSpeed = savedSpeed;
        paint();
    });
    gif.render();
}

/* ─────────────────────────────────────────────────────────────────── */

export async function bootstrap(refs) {
    Object.assign(dom, refs);

    // Initial state from URL hash or solved.
    const hashState = decodeStateFromHash(window.location.hash);
    if (hashState) ui.state = hashState;
    /** Auto-scramble on first load when no hash deeplink is present —
     *  gives the user something to interact with the moment the page lands.
     *  Run AFTER the solver init kicks off so users don't have to wait
     *  to see the scrambled state. */
    const wantsAutoScramble = !hashState;

    // 2D net
    dom.net = mountCubeNet(dom.netHost, {
        state: ui.state,
        editable: true,
        onChange: handleStickerChange,
    });

    // Wire up button events.
    if (dom.uploadBtn) {
        dom.uploadBtn.addEventListener('click', () => dom.fileInput?.click());
    }
    if (dom.fileInput) {
        dom.fileInput.addEventListener('change', (e) => {
            const file = e.target.files && e.target.files[0];
            if (file) handleFile(file);
            e.target.value = '';
        });
    }
    if (dom.scrambleBtn) dom.scrambleBtn.addEventListener('click', handleScramble);
    if (dom.resetBtn)    dom.resetBtn.addEventListener('click', handleReset);

    // Manual move buttons — 18 of them, identified by data-move attribute.
    document.querySelectorAll('[data-move]').forEach((btn) => {
        btn.addEventListener('click', () => handleManualMove(btn.getAttribute('data-move')));
    });
    if (dom.shareBtn)    dom.shareBtn.addEventListener('click', handleShare);
    if (dom.solveBtn)    dom.solveBtn.addEventListener('click', handleSolve);
    if (dom.prevBtn)     dom.prevBtn.addEventListener('click', () => step(-1));
    if (dom.nextBtn)     dom.nextBtn.addEventListener('click', () => step(+1));
    if (dom.playBtn)     dom.playBtn.addEventListener('click', togglePlay);
    if (dom.undoBtn)     dom.undoBtn.addEventListener('click', undo);
    if (dom.recordBtn)   dom.recordBtn.addEventListener('click', recordGif);
    if (dom.tbPrevBtn)   dom.tbPrevBtn.addEventListener('click', () => step(-1));
    if (dom.tbNextBtn)   dom.tbNextBtn.addEventListener('click', () => step(+1));
    if (dom.tbPlayBtn)   dom.tbPlayBtn.addEventListener('click', togglePlay);
    for (const [k, btn] of Object.entries(dom.speedBtns)) {
        btn.addEventListener('click', () => {
            ui.playSpeed = k;
            paint();
            if (ui.autoPlay) maybeStartAutoPlay();
        });
    }

    // Global paste / drag-drop / keyboard.
    window.addEventListener('paste', (e) => {
        const items = e.clipboardData && e.clipboardData.items;
        if (!items) return;
        for (let i = 0; i < items.length; i++) {
            if (items[i].type.startsWith('image/')) {
                const file = items[i].getAsFile();
                if (file) {
                    e.preventDefault();
                    handleFile(file);
                    return;
                }
            }
        }
    });
    window.addEventListener('dragover', (e) => {
        if (e.dataTransfer && e.dataTransfer.types && e.dataTransfer.types.indexOf('Files') !== -1) {
            e.preventDefault();
        }
    });
    window.addEventListener('drop', (e) => {
        e.preventDefault();
        const file = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
        if (file && file.type.startsWith('image/')) handleFile(file);
    });
    window.addEventListener('keydown', (e) => {
        const tgt = e.target;
        if (tgt && (tgt.tagName === 'INPUT' || tgt.tagName === 'TEXTAREA' || tgt.isContentEditable)) return;

        // Solution-playback nav (only when a solution is active).
        if (ui.moves) {
            if (e.key === 'ArrowRight') { e.preventDefault(); step(+1); return; }
            if (e.key === 'ArrowLeft')  { e.preventDefault(); step(-1); return; }
            if (e.key === ' ' || e.key === 'Spacebar') { e.preventDefault(); togglePlay(); return; }
        }

        // Undo (Cmd/Ctrl-Z).
        if ((e.ctrlKey || e.metaKey) && (e.key === 'z' || e.key === 'Z')) {
            e.preventDefault();
            undo();
            return;
        }

        // Twist shortcuts: U/R/F/D/L/B = CW, Shift+letter = CCW.
        if (ui.solveBusy || ui.recording) return;
        const key = e.key.toUpperCase();
        if ('URFDLB'.indexOf(key) !== -1) {
            e.preventDefault();
            const move = e.shiftKey ? `${key}'` : key;
            handleManualMove(move);
        }
    });

    // Initial paint.
    await paint();

    // Kick off solver init in the background; flip status pill when ready.
    // Auto-scramble runs once cubejs has loaded (randomState() calls into it).
    initSolver().then(async () => {
        ui.solverReady = true;
        if (wantsAutoScramble) {
            try {
                const scrambled = await randomState();
                // Don't auto-scramble if the user has already done something
                // (manual twist, upload, etc.) while waiting on init.
                if (ui.state === SOLVED_STATE && ui.history.length === 0) {
                    setStateAndClearMoves(scrambled);
                }
            } catch (e) {
                console.warn('Auto-scramble failed:', e);
            }
        }
        paint();
    });

    // 3D cube — best-effort. If Three.js fails to load, fall back gracefully.
    try {
        dom.cube3d = await mountCube3D(dom.cube3dHost, ui.state);
        await paint();
    } catch (err) {
        console.warn('3D cube failed to mount:', err);
        if (dom.cube3dHost) {
            dom.cube3dHost.innerHTML =
                '<div style="padding:1rem;color:var(--ms-muted,#78716c);text-align:center;font:0.85rem var(--ms-font-sans);">' +
                '3D preview unavailable in this browser.</div>';
        }
    }
}
