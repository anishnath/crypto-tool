/**
 * 2×2 Pocket Cube — top-level UI orchestrator.
 *
 * Same shape as rubiks/app.js but smaller: no 3D in v1, no async solver init
 * (the BFS solver runs synchronously in <100 ms), no separate worker.
 */

import {
    SOLVED_STATE, FACES, validateState, setSticker, applyMoves, ALL_MOVES,
} from './cube.js';
import { mountCubeNet } from './cube-net.js';
import { mountCube3D } from './cube-3d.js';
import { loadImageToBuffer, parseNet } from './parser.js';
import { solve, randomState } from './solver.js';

const SPEED_MS = { slow: 1500, normal: 700, fast: 300 };
const FACE_NAMES = { U: 'Up', D: 'Down', L: 'Left', R: 'Right', F: 'Front', B: 'Back' };

const ui = {
    state: SOLVED_STATE,
    moves: null,
    stepIndex: 0,
    autoPlay: false,
    playSpeed: 'normal',
    solveBusy: false,
    solveError: null,
    parseError: null,
    shareFeedback: null,
    /** Manual move history — array of { move, prevState }.  Each entry is one
     *  user-initiated twist (button click or keyboard).  Solve / step playback
     *  / random scramble do NOT push to history; they replace it via setStateAndClearMoves. */
    history: [],
    /** GIF recording state. */
    recording: false,
    recordingStatus: null,
};

const dom = {
    net: null,
    cube3d: null,
    netHost: null,
    cube3dHost: null,
    fileInput: null,
    validationEl: null,
    parseErrorEl: null,
    solveErrorEl: null,
    shareFeedbackEl: null,
    solveBtn: null,
    movesPanel: null,
    movesHeader: null,
    movesList: null,
    movesStatus: null,
    prevBtn: null,
    nextBtn: null,
    playBtn: null,
    speedBtns: {},
    uploadBtn: null,
    scrambleBtn: null,
    resetBtn: null,
    shareBtn: null,
    // History strip for manual twists.
    historyStrip: null,
    historyList: null,
    undoBtn: null,
    // GIF recording.
    recordBtn: null,
    recordStatus: null,
    playbackStrip: null,
    tbSummary: null,
    tbStep: null,
    tbPrevBtn: null,
    tbNextBtn: null,
    tbPlayBtn: null,
};

function parseMove(raw) {
    const m = /^([URFDLB])(['2]?)$/.exec(raw);
    if (!m) return null;
    return { raw, face: m[1], turns: m[2] === "'" ? -1 : m[2] === '2' ? 2 : 1 };
}

function describeMove(move) {
    const name = FACE_NAMES[move.face];
    if (move.turns === 1)  return `${name} face — 90° clockwise`;
    if (move.turns === -1) return `${name} face — 90° counter-clockwise`;
    return `${name} face — 180°`;
}

function stickerIndicesForFace(face) {
    const offsets = { U: 0, R: 4, F: 8, D: 12, L: 16, B: 20 };
    const off = offsets[face];
    return [off, off + 1, off + 2, off + 3];
}

function shareUrl(state) {
    return window.location.origin + window.location.pathname + '#state=' + state;
}

function decodeStateFromHash(hash) {
    if (!hash) return null;
    const fragment = hash.startsWith('#') ? hash.slice(1) : hash;
    for (const part of fragment.split('&')) {
        const eq = part.indexOf('=');
        if (eq === -1) continue;
        if (part.slice(0, eq) === 'state') {
            const v = decodeURIComponent(part.slice(eq + 1));
            if (validateState(v).ok) return v;
        }
    }
    return null;
}

function paint() {
    const validation = validateState(ui.state);

    let displayState = ui.state;
    if (ui.moves && ui.stepIndex > 0) {
        displayState = applyMoves(ui.state, ui.moves.slice(0, ui.stepIndex));
    }

    const upcoming = ui.moves && ui.stepIndex < ui.moves.length
        ? parseMove(ui.moves[ui.stepIndex]) : null;
    const highlight = upcoming ? stickerIndicesForFace(upcoming.face) : [];

    dom.net.update({
        state: displayState,
        editable: !ui.moves && !ui.solveBusy,
        highlightIndices: highlight,
    });
    if (dom.cube3d) dom.cube3d.setState(displayState);

    if (dom.validationEl) {
        if (ui.moves || ui.solveBusy) {
            dom.validationEl.style.display = 'none';
        } else {
            dom.validationEl.style.display = '';
            if (validation.ok) {
                dom.validationEl.textContent =
                    'Valid 2×2 cube state — click any sticker to fix a wrong color. ' +
                    'Tip: paste (⌘V) or drop a net image anywhere on the page.';
                dom.validationEl.className = 'rk-banner rk-banner-ok';
            } else {
                dom.validationEl.textContent = `Invalid: ${validation.reason}`;
                dom.validationEl.className = 'rk-banner rk-banner-bad';
            }
        }
    }

    if (dom.parseErrorEl) {
        dom.parseErrorEl.style.display = ui.parseError ? '' : 'none';
        dom.parseErrorEl.textContent = ui.parseError ? `Image parse error: ${ui.parseError}` : '';
    }
    if (dom.solveErrorEl) {
        dom.solveErrorEl.style.display = ui.solveError ? '' : 'none';
        dom.solveErrorEl.textContent = ui.solveError || '';
    }
    if (dom.shareFeedbackEl) {
        dom.shareFeedbackEl.style.display = ui.shareFeedback ? '' : 'none';
        dom.shareFeedbackEl.textContent = ui.shareFeedback || '';
    }

    const canSolve = validation.ok && !ui.solveBusy;
    if (dom.solveBtn) {
        dom.solveBtn.disabled = !canSolve;
        dom.solveBtn.textContent = ui.solveBusy ? 'Solving…' : 'Solve';
        dom.solveBtn.title = !canSolve && !validation.ok ? validation.reason : '';
    }

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

    // GIF record status pill.
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

    if (dom.movesPanel) {
        if (!ui.moves) {
            dom.movesPanel.style.display = 'none';
        } else {
            dom.movesPanel.style.display = '';
            renderMovesPanel();
        }
    }
    if (dom.playbackStrip) {
        if (!ui.moves) {
            dom.playbackStrip.style.display = 'none';
        } else {
            dom.playbackStrip.style.display = '';
            renderPlaybackStrip();
        }
    }
}

function renderMovesPanel() {
    const moves = ui.moves || [];
    const completed = ui.stepIndex >= moves.length;
    const upcoming = !completed ? parseMove(moves[ui.stepIndex]) : null;

    if (dom.movesHeader) {
        dom.movesHeader.textContent = moves.length === 0
            ? 'Already solved — no moves needed.'
            : `Solution: ${moves.length} ${moves.length === 1 ? 'move' : 'moves'}`;
    }
    if (dom.movesList) {
        dom.movesList.innerHTML = '';
        moves.forEach((m, i) => {
            const span = document.createElement('span');
            span.className = 'rk-move' + (i < ui.stepIndex ? ' done' : i === ui.stepIndex ? ' current' : '');
            span.textContent = m;
            span.addEventListener('click', () => {
                ui.autoPlay = false;
                ui.stepIndex = i;
                paint();
            });
            dom.movesList.appendChild(span);
        });
    }
    if (dom.movesStatus) {
        if (completed) dom.movesStatus.textContent = `Solved! All ${moves.length} moves applied.`;
        else {
            const detail = upcoming ? ` — ${describeMove(upcoming)}` : '';
            dom.movesStatus.textContent = `Move ${ui.stepIndex + 1} of ${moves.length}${detail}`;
        }
    }
    if (dom.prevBtn) dom.prevBtn.disabled = ui.stepIndex === 0;
    if (dom.nextBtn) dom.nextBtn.disabled = ui.stepIndex >= moves.length;
    if (dom.playBtn) {
        dom.playBtn.disabled = completed || moves.length === 0;
        dom.playBtn.textContent = ui.autoPlay ? '⏸ Pause' : '▶ Play';
    }
    for (const [k, btn] of Object.entries(dom.speedBtns)) {
        btn.classList.toggle('active', k === ui.playSpeed);
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
        dom.tbSummary.textContent = moves.length === 0 ? '✓ Already solved'
            : `Solution: ${moves.length} ${moves.length === 1 ? 'move' : 'moves'}`;
    }
    if (dom.tbStep) {
        dom.tbStep.textContent = moves.length === 0 ? ''
            : completed ? `All ${moves.length} applied`
            : `Step ${ui.stepIndex + 1} / ${moves.length}`;
    }
    if (dom.tbPrevBtn) dom.tbPrevBtn.disabled = ui.stepIndex === 0;
    if (dom.tbNextBtn) dom.tbNextBtn.disabled = ui.stepIndex >= moves.length;
    if (dom.tbPlayBtn) {
        dom.tbPlayBtn.disabled = completed || moves.length === 0;
        dom.tbPlayBtn.textContent = ui.autoPlay ? '⏸ Pause' : '▶ Play';
    }
}

function setStateAndClearMoves(next, opts = {}) {
    ui.state = next;
    ui.moves = null;
    ui.stepIndex = 0;
    ui.autoPlay = false;
    ui.solveError = null;
    // Bulk state changes (scramble / reset / upload / hash deeplink) wipe the
    // manual-twist history; only handleManualMove() preserves and appends.
    if (!opts.preserveHistory) ui.history = [];
    paint();
}

/** Undo the last manual twist.  No-op if history is empty or a solve is busy. */
function undo() {
    if (ui.solveBusy || ui.history.length === 0) return;
    const { prevState } = ui.history.pop();
    // Preserve history (we just popped one entry, the rest remains).
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

function handleSolve() {
    ui.solveError = null;
    ui.moves = null;
    ui.stepIndex = 0;
    ui.autoPlay = false;
    ui.solveBusy = true;
    paint();
    // Defer to next tick so the "Solving…" UI repaints before we block.
    setTimeout(() => {
        const requestState = ui.state;
        try {
            const result = solve(requestState);
            if (ui.state !== requestState) return;
            if (result === null) {
                ui.solveError = 'No solution found within 14 search depth — this state may not be reachable.';
            } else {
                ui.moves = result;
            }
        } catch (err) {
            ui.solveError = err && err.message ? err.message : String(err);
        } finally {
            ui.solveBusy = false;
            paint();
        }
    }, 30);
}

function handleScramble() {
    setStateAndClearMoves(randomState());
}

function handleReset() {
    setStateAndClearMoves(SOLVED_STATE);
}

async function handleShare() {
    const url = shareUrl(ui.state);
    try { await navigator.clipboard.writeText(url); ui.shareFeedback = 'Link copied!'; }
    catch { ui.shareFeedback = url; }
    paint();
    setTimeout(() => { ui.shareFeedback = null; paint(); }, 2500);
}

function handleManualMove(move) {
    if (ui.solveBusy) return;
    try {
        const prevState = ui.state;
        const next = applyMoves(prevState, move);
        // Record this twist before clobbering state so undo can pop back.
        ui.history.push({ move, prevState });
        setStateAndClearMoves(next, { preserveHistory: true });
    } catch (err) {
        console.warn('Manual move failed:', move, err);
    }
}

let autoPlayTimer = null;
function maybeStartAutoPlay() {
    if (autoPlayTimer) { clearTimeout(autoPlayTimer); autoPlayTimer = null; }
    if (!ui.autoPlay || !ui.moves) return;
    if (ui.stepIndex >= ui.moves.length) { ui.autoPlay = false; paint(); return; }
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

/**
 * Record the solution playback as an animated GIF using gif.js.
 *
 * Flow: rewind to step 0, start a frame-capture interval (20 fps) reading
 * pixels from the 3D canvas, force-fast playback, wait for completion,
 * encode, trigger a browser download.  Total time ≈ 2 s playback +
 * 1-3 s encode for a typical 8-move solve.
 *
 * Requires the WebGLRenderer to have been created with
 * `preserveDrawingBuffer: true` (cube-3d.js does this).
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
    try {
        const mod = await import('https://esm.sh/gif.js@0.2.0');
        GIF = mod.default || mod.GIF || mod;
    } catch (err) {
        console.error('gif.js load failed:', err);
        ui.recording = false;
        ui.recordingStatus = null;
        ui.solveError = 'Could not load GIF encoder. Check your network and try again.';
        paint();
        return;
    }

    const canvas = dom.cube3d.el;
    const gif = new GIF({
        workers: 2,
        quality: 10,
        width: canvas.width,
        height: canvas.height,
        // Cross-origin worker — both unpkg and jsdelivr serve gif.worker.js
        // with permissive CORS headers, so this just works.
        workerScript: 'https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.worker.js',
    });

    // Rewind to start of solution and force a fast playback so the recording
    // is short (~2-3 seconds for a typical 8-move solve at fast = 300ms/step).
    const savedSpeed = ui.playSpeed;
    ui.stepIndex = 0;
    ui.autoPlay = false;
    ui.playSpeed = 'fast';
    paint();

    // Let the cube render the start state before grabbing the first frame.
    await new Promise((r) => setTimeout(r, 200));

    // Capture frames at 20 fps for the duration of playback.
    ui.recordingStatus = 'Capturing frames…';
    paint();
    const captureInterval = setInterval(() => {
        gif.addFrame(canvas, { delay: 50, copy: true });
    }, 50);

    // Start auto-playback.
    ui.autoPlay = true;
    paint();
    maybeStartAutoPlay();

    // Wait for stepIndex to reach the end.
    await new Promise((resolve) => {
        const tick = setInterval(() => {
            if (!ui.moves || ui.stepIndex >= ui.moves.length) {
                clearInterval(tick);
                resolve();
            }
        }, 80);
    });
    // Capture an extra ~500 ms of the final solved state so the GIF doesn't
    // cut off mid-animation.
    await new Promise((r) => setTimeout(r, 500));
    clearInterval(captureInterval);

    // Encode.  gif.on('progress') fires repeatedly; 'finished' once with the blob.
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
        a.download = `pocket-cube-solution-${Date.now()}.gif`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        setTimeout(() => URL.revokeObjectURL(url), 2000);

        ui.recording = false;
        ui.recordingStatus = null;
        ui.playSpeed = savedSpeed;
        paint();
    });

    gif.render();
}

export async function bootstrap(refs) {
    Object.assign(dom, refs);

    const hashState = decodeStateFromHash(window.location.hash);
    if (hashState) ui.state = hashState;
    /** Auto-scramble on first load only (no hash deeplink, never been touched).
     *  Gives users something to interact with the moment the page lands —
     *  otherwise it boots solved and there's nothing to do but click. */
    const wantsAutoScramble = !hashState;

    dom.net = mountCubeNet(dom.netHost, {
        state: ui.state,
        editable: true,
        onChange: handleStickerChange,
    });

    if (dom.uploadBtn)   dom.uploadBtn.addEventListener('click', () => dom.fileInput?.click());
    if (dom.fileInput) {
        dom.fileInput.addEventListener('change', (e) => {
            const file = e.target.files && e.target.files[0];
            if (file) handleFile(file);
            e.target.value = '';
        });
    }
    if (dom.scrambleBtn) dom.scrambleBtn.addEventListener('click', handleScramble);
    if (dom.resetBtn)    dom.resetBtn.addEventListener('click', handleReset);
    if (dom.shareBtn)    dom.shareBtn.addEventListener('click', handleShare);
    if (dom.solveBtn)    dom.solveBtn.addEventListener('click', handleSolve);
    if (dom.prevBtn)     dom.prevBtn.addEventListener('click', () => step(-1));
    if (dom.nextBtn)     dom.nextBtn.addEventListener('click', () => step(+1));
    if (dom.playBtn)     dom.playBtn.addEventListener('click', togglePlay);
    if (dom.tbPrevBtn)   dom.tbPrevBtn.addEventListener('click', () => step(-1));
    if (dom.tbNextBtn)   dom.tbNextBtn.addEventListener('click', () => step(+1));
    if (dom.tbPlayBtn)   dom.tbPlayBtn.addEventListener('click', togglePlay);
    if (dom.undoBtn)     dom.undoBtn.addEventListener('click', undo);
    if (dom.recordBtn)   dom.recordBtn.addEventListener('click', recordGif);

    document.querySelectorAll('[data-move]').forEach((btn) => {
        btn.addEventListener('click', () => handleManualMove(btn.getAttribute('data-move')));
    });

    for (const [k, btn] of Object.entries(dom.speedBtns)) {
        if (!btn) continue;
        btn.addEventListener('click', () => {
            ui.playSpeed = k;
            paint();
            if (ui.autoPlay) maybeStartAutoPlay();
        });
    }

    window.addEventListener('paste', (e) => {
        const items = e.clipboardData && e.clipboardData.items;
        if (!items) return;
        for (let i = 0; i < items.length; i++) {
            if (items[i].type.startsWith('image/')) {
                const file = items[i].getAsFile();
                if (file) { e.preventDefault(); handleFile(file); return; }
            }
        }
    });
    window.addEventListener('dragover', (e) => {
        if (e.dataTransfer && e.dataTransfer.types && e.dataTransfer.types.indexOf('Files') !== -1) e.preventDefault();
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

        // Undo (Ctrl/Cmd-Z).
        if ((e.ctrlKey || e.metaKey) && (e.key === 'z' || e.key === 'Z')) {
            e.preventDefault();
            undo();
            return;
        }

        // Twist shortcuts: U/R/F/D/L/B = CW, Shift+letter = CCW.  Don't fire
        // during a busy solve or active recording — the buttons are disabled
        // visually and we want the keyboard to match.
        if (ui.solveBusy || ui.recording) return;
        const key = e.key.toUpperCase();
        if ('URFDLB'.indexOf(key) !== -1) {
            e.preventDefault();
            const move = e.shiftKey ? `${key}'` : key;
            handleManualMove(move);
        }
    });

    if (wantsAutoScramble) {
        // Randomise *before* mounting 3D so the cube comes up scrambled,
        // not solved-then-snap.  paint() runs once below.
        ui.state = randomState();
    }
    paint();

    // Mount 3D cube — best-effort.  If Three.js fails to load (e.g. import
    // map missing or browser too old), fall back to a placeholder.
    if (dom.cube3dHost) {
        try {
            dom.cube3d = await mountCube3D(dom.cube3dHost, ui.state);
            paint();
        } catch (err) {
            console.warn('2×2 3D cube failed to mount:', err);
            dom.cube3dHost.innerHTML =
                '<div style="padding:1rem;color:var(--ms-muted,#78716c);text-align:center;font:0.85rem var(--ms-font-sans);">' +
                '3D preview unavailable in this browser.</div>';
        }
    }
}
