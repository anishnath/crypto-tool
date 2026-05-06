/**
 * Rubik N×N Solver — single-page bootstrap supporting 3×3 and 4×4 cubes.
 *
 *   3×3 → solved client-side via cubejs (Kociemba two-phase, ~50 ms).
 *         Move application also goes through cubejs (the 3×3 module
 *         doesn't ship its own permutations).
 *   4×4 → solved server-side via /CubeSolverFunctionality (full Java
 *         pipeline: centres + edges + reduce + Kociemba; ~5–40 s).
 *         Move application uses the local rubiks4/moves.js permutations.
 */

// 3×3
import { SOLVED_STATE as SOLVED_3, FACES as FACES_3 } from '../rubiks/cube.js';
import {
    initSolver,
    solve as solve3cubejs,
    applyMoves as apply3cubejs,
    randomState as random3cubejs,
} from '../rubiks/solver.js';
import { mountCubeNet as mountNet3 } from '../rubiks/cube-net.js';

// 4×4
import {
    SOLVED_STATE as SOLVED_4,
    FACES as FACES_4,
} from '../rubiks4/cube.js';
import {
    applyMoves as apply4sync,
    ALL_MOVES as ALL_MOVES_4,
} from '../rubiks4/moves.js';
import { mountCubeNet as mountNet4 } from '../rubiks4/cube-net.js';

// Generic 3D + image parser
import { mountCubeNxN } from './cube-3d-nxn.js';
import { loadImageToBuffer, parseNet } from './parser.js';

const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];
function setSticker(state, index, face) {
    return state.slice(0, index) + face + state.slice(index + 1);
}
function cycleSticker(state, index) {
    const cur = state[index];
    const next = FACES[(FACES.indexOf(cur) + 1) % FACES.length];
    return setSticker(state, index, next);
}

/**
 * Relaxed validator: length + per-face sticker counts only.
 *
 * The strict "centres must be monochromatic" check that rubiks4/cube.js
 * exports is wrong for scrambled cubes — real 4×4 scrambles disperse the
 * centre stickers across faces.  The Java side accepts any state whose
 * sticker counts add up; we mirror that.
 */
function validateRelaxed(state, faces, perFace) {
    const total = faces.length * perFace;
    if (typeof state !== 'string' || state.length !== total) {
        return { ok: false, reason: `Expected ${total} stickers, got ${state ? state.length : 0}` };
    }
    const counts = {};
    for (const ch of state) {
        if (faces.indexOf(ch) < 0) {
            return { ok: false, reason: `Invalid sticker '${ch}'` };
        }
        counts[ch] = (counts[ch] || 0) + 1;
    }
    for (const f of faces) {
        if (counts[f] !== perFace) {
            return { ok: false, reason: `Expected ${perFace} '${f}' stickers, got ${counts[f] || 0}` };
        }
    }
    return { ok: true };
}

const sizeAdapters = {
    3: {
        SOLVED:   SOLVED_3,
        validate: (s) => validateRelaxed(s, FACES_3, 9),
        apply:    (state, moves) => apply3cubejs(state, moves),
        random:   () => random3cubejs(),
        mount:    mountNet3,
    },
    4: {
        SOLVED:   SOLVED_4,
        validate: (s) => validateRelaxed(s, FACES_4, 16),
        apply:    async (state, moves) => apply4sync(state, moves),
        random:   async () => {
            const moves = [];
            for (let i = 0; i < 30; i++) {
                moves.push(ALL_MOVES_4[Math.floor(Math.random() * ALL_MOVES_4.length)]);
            }
            return apply4sync(SOLVED_4, moves);
        },
        mount:    mountNet4,
    },
};

export function bootstrap(ctx) {
    const ui = {
        sizeBtns:       Array.from(document.querySelectorAll('.rk-size-btn')),
        netHost:        ctx.netHost,
        cube3dHost:     ctx.cube3dHost,
        fileInput:      ctx.fileInput,
        uploadBtn:      ctx.uploadBtn,
        sampleBtn:      ctx.sampleBtn,
        editToggle:     ctx.editToggle,
        statusEl:       ctx.statusEl,
        busyCard:       ctx.busyCard,
        busyTitle:      ctx.busyTitle,
        busySub:        ctx.busySub,
        validation:     ctx.validation,
        scrambleBtn:    ctx.scrambleBtn,
        resetBtn:       ctx.resetBtn,
        solveBtn:       ctx.solveBtn,
        movesPanel:     ctx.movesPanel,
        movesList:      ctx.movesList,
        movesMeta:      ctx.movesMeta,
        movesBreakdown: ctx.movesBreakdown,
        playPrev:       ctx.playPrev,
        playPlay:       ctx.playPlay,
        playNext:       ctx.playNext,
        playStep:       ctx.playStep,
        // Toolbar-strip mirrors of the playback controls (visible right
        // next to Solve so the user doesn't have to scroll to play).
        tbPlayback:     ctx.tbPlayback,
        tbPrev:         ctx.tbPrev,
        tbPlay:         ctx.tbPlay,
        tbPlayLabel:    ctx.tbPlayLabel,
        tbNext:         ctx.tbNext,
        tbStep:         ctx.tbStep,
        // GIF recording
        recordBtn:      ctx.recordBtn,
        recordStatus:   ctx.recordStatus,
    };

    let size = 3;
    let adapter = sizeAdapters[size];
    let originalState = adapter.SOLVED;        // state when Solve was clicked
    let state = adapter.SOLVED;
    let net = null;
    let cube3d = null;
    let cube3dPending = false;                 // mountCubeNxN is async — gate concurrent mounts
    let solution = null;                       // {moves, breakdown, meta, elapsedMs}
    let stepIdx = 0;                           // moves applied to `state` from `originalState`
    let playing = false;
    let editMode = false;

    function setStatus(text, kind) {
        if (!ui.statusEl) return;
        ui.statusEl.textContent = text;
        ui.statusEl.dataset.state = kind || 'idle';
    }

    function setBusy(on, title, sub) {
        if (!ui.busyCard) return;
        ui.busyCard.classList.toggle('active', !!on);
        if (on) {
            if (ui.busyTitle) {
                ui.busyTitle.innerHTML = '';
                ui.busyTitle.appendChild(document.createTextNode(title || 'Thinking'));
                const dots = document.createElement('span');
                dots.className = 'rk-dots';
                ui.busyTitle.appendChild(dots);
            }
            if (ui.busySub) ui.busySub.textContent = sub || '';
        }
    }

    function setBanner(text, kind) {
        if (!ui.validation) return;
        ui.validation.textContent = text;
        ui.validation.className = 'rk-banner rk-banner-' + (kind || 'ok');
    }

    function mountNet() {
        net = adapter.mount(ui.netHost, {
            state,
            editable: editMode,
            onChange: (idx, nextFace) => {
                state = setSticker(state, idx, nextFace);
                originalState = state;
                clearSolution();
                paintNet();
                validateBanner();
            },
            highlightIndices: [],
        });
    }

    function refreshEditable() {
        if (net) net.update({ editable: editMode });
        if (ui.editToggle) {
            ui.editToggle.classList.toggle('active', editMode);
            ui.editToggle.setAttribute('aria-pressed', String(editMode));
            ui.editToggle.textContent = editMode ? '✏ Editing — click stickers' : '✏ Edit stickers';
        }
    }

    function validateBanner() {
        const v = adapter.validate(state);
        if (!v.ok) { setBanner('Invalid: ' + v.reason, 'bad'); return false; }
        if (state === adapter.SOLVED) {
            setBanner(`${size}×${size} cube is solved.`, 'info');
        } else {
            setBanner(`Valid ${size}×${size} state. ${editMode ? 'Click stickers to fix colours, then click Solve.' : 'Click Solve to compute a solution.'}`, 'ok');
        }
        return true;
    }

    async function mount3D() {
        if (!ui.cube3dHost || cube3dPending) return;
        cube3dPending = true;
        try {
            if (cube3d) { cube3d.dispose(); cube3d = null; }
            cube3d = await mountCubeNxN(ui.cube3dHost, size, state);
        } catch (err) {
            console.error('3D mount failed:', err);
            ui.cube3dHost.innerHTML =
                '<div style="padding:1rem;color:var(--ms-muted);font:0.85rem var(--ms-font-sans);">' +
                '3D preview unavailable: ' + (err.message || err) + '</div>';
        } finally {
            cube3dPending = false;
        }
    }

    function paintNet() {
        if (net) net.update({ state, highlightIndices: [] });
        if (cube3d) cube3d.setState(state);
    }

    /** Net snap + 3D animated face-turn for a single move. */
    async function paintWithMove(move) {
        if (net) net.update({ state, highlightIndices: [] });
        if (cube3d && cube3d.animateMove) {
            await cube3d.animateMove(move, state);
        } else if (cube3d) {
            cube3d.setState(state);
        }
    }

    function clearSolution() {
        solution = null;
        stepIdx = 0;
        playing = false;
        ui.movesPanel.style.display = 'none';
        ui.movesList.innerHTML = '';
        if (ui.playPlay) ui.playPlay.textContent = '▶ Play';
        if (ui.tbPlayback) ui.tbPlayback.style.display = 'none';
        if (ui.tbPlayLabel) ui.tbPlayLabel.textContent = 'Play';
    }

    function setSize(newSize) {
        if (newSize === size && net) return;
        size = newSize;
        adapter = sizeAdapters[size];
        for (const b of ui.sizeBtns) {
            b.classList.toggle('active', Number(b.dataset.size) === size);
        }
        state = adapter.SOLVED;
        originalState = state;
        clearSolution();
        editMode = false;
        mountNet();
        mount3D();
        refreshEditable();
        setStatus(size === 3 ? 'Ready · 3×3 (browser)' : 'Ready · 4×4 (server)', 'ready');
        setBanner(`Cube reset (${size}×${size}). Scramble, upload a net image, or twist — then click Solve.`, 'ok');
    }

    async function scramble() {
        clearSolution();
        setStatus('Scrambling…', 'busy');
        try {
            state = await adapter.random();
            originalState = state;
            paintNet();
            setBanner(`Scrambled ${size}×${size}. Click Solve.`, 'ok');
            setStatus(size === 3 ? 'Ready · 3×3 (browser)' : 'Ready · 4×4 (server)', 'ready');
        } catch (err) {
            setBanner('Scramble failed: ' + (err.message || err), 'bad');
            setStatus('Idle', 'idle');
        }
    }

    function reset() {
        state = adapter.SOLVED;
        originalState = state;
        clearSolution();
        paintNet();
        setBanner(`Cube reset (${size}×${size}).`, 'ok');
    }

    function renderMoves(moves, breakdown, meta) {
        ui.movesList.innerHTML = '';
        moves.forEach((m, i) => {
            const span = document.createElement('span');
            span.className = 'rk-move';
            span.dataset.idx = String(i);
            span.textContent = m;
            span.addEventListener('click', () => jumpTo(i + 1));
            ui.movesList.appendChild(span);
        });
        if (ui.movesMeta) ui.movesMeta.textContent = meta;
        if (ui.movesBreakdown) ui.movesBreakdown.innerHTML = breakdown || '';
        ui.movesPanel.style.display = 'block';
        if (ui.tbPlayback) ui.tbPlayback.style.display = 'inline-flex';
        highlightStep();
    }

    function highlightStep() {
        const cells = ui.movesList.querySelectorAll('.rk-move');
        cells.forEach((c, i) => {
            c.classList.toggle('done', i < stepIdx);
            c.classList.toggle('current', i === stepIdx);
        });
        if (solution) {
            const txt = `${stepIdx} / ${solution.moves.length}`;
            if (ui.playStep) ui.playStep.textContent = `Step ${txt}`;
            if (ui.tbStep) ui.tbStep.textContent = txt;
        }
    }

    async function jumpTo(idx) {
        if (!solution) return;
        idx = Math.max(0, Math.min(solution.moves.length, idx));
        try {
            state = await adapter.apply(originalState, solution.moves.slice(0, idx));
        } catch (err) {
            setBanner('Move replay failed: ' + (err.message || err), 'bad');
            return;
        }
        stepIdx = idx;
        paintNet();
        highlightStep();
    }

    /** Animated single-step forward / backward (used by Prev / Next / Play). */
    async function step(delta) {
        if (!solution) return;
        const target = Math.max(0, Math.min(solution.moves.length, stepIdx + delta));
        if (target === stepIdx) return;
        if (delta === 1 && stepIdx < solution.moves.length) {
            const move = solution.moves[stepIdx];
            try {
                state = await adapter.apply(state, [move]);
            } catch (err) {
                setBanner('Move failed: ' + (err.message || err), 'bad');
                return;
            }
            stepIdx++;
            await paintWithMove(move);
            highlightStep();
        } else if (delta === -1 && stepIdx > 0) {
            // Reverse the previous move (animate the inverse).
            const move = solution.moves[stepIdx - 1];
            const inverse = move.endsWith("'") ? move.slice(0, -1)
                          : move.endsWith('2') ? move
                          : move + "'";
            try {
                state = await adapter.apply(state, [inverse]);
            } catch (err) {
                setBanner('Move failed: ' + (err.message || err), 'bad');
                return;
            }
            stepIdx--;
            await paintWithMove(inverse);
            highlightStep();
        } else {
            // Larger jumps (e.g. Play resuming after end-of-list) — snap.
            jumpTo(target);
        }
    }

    function setPlayLabel(label) {
        if (ui.playPlay) ui.playPlay.textContent = label === 'play' ? '▶ Play' : '⏸ Pause';
        if (ui.tbPlayLabel) ui.tbPlayLabel.textContent = label === 'play' ? 'Play' : 'Pause';
    }
    async function togglePlay() {
        if (!solution) return;
        if (playing) {
            playing = false;
            setPlayLabel('play');
            return;
        }
        if (stepIdx >= solution.moves.length) await jumpTo(0);
        playing = true;
        setPlayLabel('pause');
        while (playing && solution && stepIdx < solution.moves.length) {
            await step(+1);
            await new Promise((r) => setTimeout(r, 80));
        }
        playing = false;
        setPlayLabel('play');
    }

    async function solve3x3() {
        setStatus('Initialising', 'busy');
        setBusy(true, 'Initialising cubejs',
            'First-time pruning-table build (~3 s). Subsequent solves are sub-millisecond.');
        await initSolver();
        setStatus('Solving', 'busy');
        setBusy(true, 'Solving 3×3',
            'Kociemba two-phase algorithm — typically returns 20–22 moves in <50 ms.');
        const t0 = performance.now();
        const moves = await solve3cubejs(state);
        const dt = Math.round(performance.now() - t0);
        return {
            moves,
            elapsedMs: dt,
            breakdown: `<span class="rk-piece">Kociemba: <strong>${moves.length}</strong> moves in ${dt} ms</span>`,
            meta: `Solved in ${moves.length} moves · ${dt} ms · cubejs (browser)`,
        };
    }

    async function solve4x4() {
        setStatus('Solving', 'busy');
        setBusy(true, 'Solving 4×4 on server',
            'Pipeline: centres → orient → phase 3 → phase 4 → reduce → Kociemba. Adversarial scrambles can take 5–40 seconds.');
        const t0 = performance.now();
        const ctxPath = (document.querySelector('meta[name="ctx"]') || {}).content || '';
        const url = ctxPath + '/CubeSolverFunctionality?action=solve&size=4';
        const resp = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ state }),
        });
        const json = await resp.json().catch(() => ({}));
        const dt = Math.round(performance.now() - t0);
        if (!resp.ok || json.error) {
            throw new Error(json.error || ('HTTP ' + resp.status));
        }
        if (!json.solved) {
            throw new Error('Solver gave up: ' + (json.stoppedAt || 'unknown'));
        }
        const moves = json.moves || [];
        const elapsedMs = json.elapsedMs || dt;
        const parts = [];
        const tally = (label, arr) => {
            if (arr && arr.length) {
                parts.push(`<span class="rk-piece">${label}: <strong>${arr.length}</strong></span>`);
            }
        };
        tally('Centres',  json.centresMoves);
        tally('Orient',   json.orientMoves);
        tally('Phase 3',  json.phase3Moves);
        tally('Phase 4',  json.phase4Moves);
        tally('Kociemba', json.reduceMoves);
        return {
            moves,
            elapsedMs,
            breakdown: parts.join(' '),
            meta: `Solved in ${moves.length} moves · ${elapsedMs} ms · server pipeline`,
        };
    }

    async function solve() {
        const v = adapter.validate(state);
        if (!v.ok) { setBanner('Invalid state: ' + v.reason, 'bad'); return; }
        if (state === adapter.SOLVED) {
            setBanner('Cube is already solved.', 'info');
            return;
        }
        ui.solveBtn.disabled = true;
        clearSolution();
        originalState = state;
        try {
            const r = size === 3 ? await solve3x3() : await solve4x4();
            solution = r;
            stepIdx = 0;
            renderMoves(r.moves, r.breakdown, r.meta);
            setStatus(`${size}×${size} solved · ${r.moves.length} moves · ${r.elapsedMs} ms`, 'ready');
            setBanner('Solution ready. Use Prev / Play / Next or click any move.', 'ok');
        } catch (err) {
            console.error(err);
            setBanner('Solve failed: ' + (err.message || err), 'bad');
            setStatus('Idle', 'idle');
        } finally {
            ui.solveBtn.disabled = false;
            setBusy(false);
        }
    }

    async function applyOne(move) {
        try {
            state = await adapter.apply(state, [move]);
            await paintWithMove(move);
        } catch (err) {
            setBanner('Move failed: ' + (err.message || err), 'bad');
        }
    }

    /**
     * Render a sample unfolded-net image of the solved cube for the current
     * size and download it as a PNG.  Built from a fresh SVG (independent of
     * the live #rk-net-host) so the file is always pristine and predictable.
     *
     * Useful so users know exactly what input the parser expects.  The
     * solved net is the canonical "valid format" template — they can scribble
     * over it in any editor or compare against camera output.
     */
    /**
     * Record solution playback as an animated GIF.
     *
     * Loads gif.js on demand from esm.sh.  The Worker constructor refuses
     * cross-origin script URLs even with permissive CORS, so we fetch the
     * worker source and hand it back as a same-origin blob URL.
     *
     * Frame composition: 3D cube canvas | unfolded net (rasterised from
     * the live SVG), with a watermark of the page URL across the bottom.
     */
    let recording = false;
    function setRecordStatus(text) {
        if (!ui.recordStatus) return;
        if (text) {
            ui.recordStatus.style.display = '';
            ui.recordStatus.textContent = text;
        } else {
            ui.recordStatus.style.display = 'none';
            ui.recordStatus.textContent = '';
        }
        if (ui.recordBtn) {
            ui.recordBtn.disabled = recording;
            const lbl = ui.recordBtn.querySelector('span');
            if (lbl) lbl.textContent = recording ? 'Recording…' : 'Record GIF';
        }
    }

    async function rasterizeNet(targetH) {
        // Snapshot the current net SVG to a Canvas at the requested height.
        const svg = ui.netHost && ui.netHost.querySelector('svg');
        if (!svg) return null;
        const cloned = svg.cloneNode(true);
        cloned.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        const vb = (cloned.getAttribute('viewBox') || '0 0 200 200').split(/\s+/).map(Number);
        const w = vb[2], h = vb[3];
        const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
        bg.setAttribute('x', '0'); bg.setAttribute('y', '0');
        bg.setAttribute('width', String(w)); bg.setAttribute('height', String(h));
        bg.setAttribute('fill', '#0f172a');
        cloned.insertBefore(bg, cloned.firstChild);
        const xml = new XMLSerializer().serializeToString(cloned);
        const url = URL.createObjectURL(new Blob([xml], { type: 'image/svg+xml;charset=utf-8' }));
        try {
            const img = await new Promise((res, rej) => {
                const i = new Image();
                i.onload = () => res(i);
                i.onerror = () => rej(new Error('Net rasterise failed'));
                i.src = url;
            });
            const scale = targetH / h;
            const c = document.createElement('canvas');
            c.width = Math.round(w * scale);
            c.height = Math.round(targetH);
            c.getContext('2d').drawImage(img, 0, 0, c.width, c.height);
            return c;
        } finally {
            URL.revokeObjectURL(url);
        }
    }

    function drawWatermark(ctx, w, h) {
        const mark = '8gwifi.org/math/rubik-nxn-solver.jsp';
        ctx.save();
        ctx.font = '500 12px monospace';
        ctx.textAlign = 'right';
        ctx.textBaseline = 'bottom';
        const tw = ctx.measureText(mark).width;
        ctx.fillStyle = 'rgba(0,0,0,0.45)';
        ctx.fillRect(w - tw - 16, h - 22, tw + 12, 18);
        ctx.fillStyle = '#ffffff';
        ctx.fillText(mark, w - 10, h - 8);
        ctx.restore();
    }

    async function recordGif() {
        if (recording) return;
        if (!solution || !solution.moves.length) {
            setBanner('No solution to record. Click Solve first.', 'info');
            return;
        }
        if (!cube3d || !cube3d.canvas) {
            setBanner('3D preview not ready — cannot record.', 'bad');
            return;
        }
        recording = true;
        setRecordStatus('Loading encoder…');

        let GIF, workerUrl;
        try {
            const mod = await import('https://esm.sh/gif.js@0.2.0');
            GIF = mod.default || mod.GIF || mod;
            const r = await fetch('https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.worker.js');
            workerUrl = URL.createObjectURL(await r.blob());
        } catch (err) {
            recording = false;
            setRecordStatus(null);
            setBanner('GIF encoder load failed: ' + (err.message || err), 'bad');
            return;
        }

        // Rewind to step 0 so the recording starts from the scrambled state.
        await jumpTo(0);
        await new Promise((r) => setTimeout(r, 150));

        const cubeCanvas = cube3d.canvas;
        const cubeW = cubeCanvas.width, cubeH = cubeCanvas.height;
        const netCanvas = await rasterizeNet(cubeH);
        const netW = netCanvas ? netCanvas.width : 0;
        const GAP = 24, PAD = 16;
        const frameW = cubeW + GAP + netW + PAD * 2;
        const frameH = cubeH + PAD * 2;

        const gif = new GIF({
            workers: 2, quality: 10,
            width: Math.round(frameW), height: Math.round(frameH),
            workerScript: workerUrl,
        });

        const frameCanvas = document.createElement('canvas');
        frameCanvas.width = Math.round(frameW);
        frameCanvas.height = Math.round(frameH);
        const fctx = frameCanvas.getContext('2d');

        let captureAlive = true;
        const captureLoop = (async () => {
            while (captureAlive) {
                const liveNet = await rasterizeNet(cubeH);
                fctx.fillStyle = '#0f172a';
                fctx.fillRect(0, 0, frameCanvas.width, frameCanvas.height);
                fctx.drawImage(cubeCanvas, PAD, PAD);
                if (liveNet) fctx.drawImage(liveNet, PAD + cubeW + GAP, PAD);
                drawWatermark(fctx, frameCanvas.width, frameCanvas.height);
                gif.addFrame(fctx, { delay: 60, copy: true });
                await new Promise((r) => setTimeout(r, 60));
            }
        })();

        setRecordStatus('Capturing frames…');
        // Drive playback at a fast cadence.
        playing = true;
        setPlayLabel('pause');
        while (playing && solution && stepIdx < solution.moves.length) {
            await step(+1);
        }
        playing = false;
        setPlayLabel('play');
        await new Promise((r) => setTimeout(r, 500));   // hold the final frame
        captureAlive = false;
        await captureLoop;

        setRecordStatus('Encoding GIF…');
        gif.on('progress', (p) => setRecordStatus(`Encoding GIF… ${Math.round(p * 100)}%`));
        gif.on('finished', (blob) => {
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `rubiks-${size}x${size}-solution-${Date.now()}.gif`;
            document.body.appendChild(a);
            a.click();
            a.remove();
            setTimeout(() => URL.revokeObjectURL(url), 2000);
            URL.revokeObjectURL(workerUrl);
            recording = false;
            setRecordStatus(null);
            setBanner('GIF saved to your Downloads folder.', 'ok');
        });
        gif.render();
    }

    async function downloadSampleNet() {
        // Mount a temporary off-screen renderer of the SOLVED state for `size`.
        const offHost = document.createElement('div');
        offHost.style.position = 'fixed';
        offHost.style.left = '-9999px';
        offHost.style.top = '0';
        document.body.appendChild(offHost);
        try {
            adapter.mount(offHost, { state: adapter.SOLVED, editable: false, highlightIndices: [] });
            const svg = offHost.querySelector('svg');
            if (!svg) throw new Error('Sample SVG not generated');
            // Inline a white background so PNG looks right in any viewer.
            const cloned = svg.cloneNode(true);
            cloned.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
            const vb = (cloned.getAttribute('viewBox') || '0 0 200 200').split(/\s+/).map(Number);
            const w = vb[2], h = vb[3];
            const pad = 20;
            const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            bg.setAttribute('x', '0'); bg.setAttribute('y', '0');
            bg.setAttribute('width', String(w)); bg.setAttribute('height', String(h));
            bg.setAttribute('fill', '#ffffff');
            cloned.insertBefore(bg, cloned.firstChild);

            const xml = new XMLSerializer().serializeToString(cloned);
            const svgBlob = new Blob([xml], { type: 'image/svg+xml;charset=utf-8' });
            const svgUrl = URL.createObjectURL(svgBlob);

            const SCALE = 4;     // crisp 4× raster
            const canvas = document.createElement('canvas');
            canvas.width  = (w + pad * 2) * SCALE;
            canvas.height = (h + pad * 2) * SCALE;
            const cctx = canvas.getContext('2d');
            cctx.fillStyle = '#ffffff';
            cctx.fillRect(0, 0, canvas.width, canvas.height);

            const img = await new Promise((resolve, reject) => {
                const i = new Image();
                i.onload = () => resolve(i);
                i.onerror = (e) => reject(new Error('Sample SVG failed to rasterize'));
                i.src = svgUrl;
            });
            cctx.drawImage(img, pad * SCALE, pad * SCALE, w * SCALE, h * SCALE);
            URL.revokeObjectURL(svgUrl);

            const png = canvas.toDataURL('image/png');
            const a = document.createElement('a');
            a.href = png;
            a.download = `rubiks-${size}x${size}-net-sample.png`;
            document.body.appendChild(a);
            a.click();
            a.remove();
            setBanner(`Downloaded sample net image for ${size}×${size}. Use it as a template for your own uploads.`, 'info');
        } catch (err) {
            setBanner('Sample download failed: ' + (err.message || err), 'bad');
        } finally {
            document.body.removeChild(offHost);
        }
    }

    async function handleImageFile(file) {
        if (!file) return;
        setStatus('Parsing image…', 'busy');
        try {
            const buf = await loadImageToBuffer(file);
            const r = parseNet(buf, size);
            if (!r.ok) { setBanner('Image parse failed: ' + r.reason, 'bad'); setStatus('Idle', 'idle'); return; }
            state = r.state;
            originalState = state;
            clearSolution();
            paintNet();
            // Enter edit mode automatically — parsers misclassify edges all
            // the time and this is the natural moment to fix them.
            editMode = true;
            refreshEditable();
            setStatus(`Parsed ${size}×${size} from image`, 'ready');
            validateBanner();
        } catch (err) {
            setBanner('Image parse error: ' + (err.message || err), 'bad');
            setStatus('Idle', 'idle');
        }
    }

    // ── wire up ────────────────────────────────────────────────────
    for (const b of ui.sizeBtns) {
        b.addEventListener('click', () => setSize(Number(b.dataset.size)));
    }
    if (ui.scrambleBtn) ui.scrambleBtn.addEventListener('click', scramble);
    if (ui.resetBtn)    ui.resetBtn.addEventListener('click', reset);
    if (ui.solveBtn)    ui.solveBtn.addEventListener('click', solve);
    if (ui.playPrev)    ui.playPrev.addEventListener('click', () => step(-1));
    if (ui.playNext)    ui.playNext.addEventListener('click', () => step(+1));
    if (ui.playPlay)    ui.playPlay.addEventListener('click', togglePlay);
    if (ui.tbPrev)      ui.tbPrev.addEventListener('click', () => step(-1));
    if (ui.tbNext)      ui.tbNext.addEventListener('click', () => step(+1));
    if (ui.tbPlay)      ui.tbPlay.addEventListener('click', togglePlay);

    if (ui.uploadBtn && ui.fileInput) {
        ui.uploadBtn.addEventListener('click', () => ui.fileInput.click());
        ui.fileInput.addEventListener('change', (e) => {
            const f = e.target.files && e.target.files[0];
            if (f) handleImageFile(f);
            e.target.value = '';   // allow re-uploading the same file
        });
    }
    if (ui.sampleBtn) ui.sampleBtn.addEventListener('click', downloadSampleNet);
    if (ui.recordBtn) ui.recordBtn.addEventListener('click', recordGif);
    if (ui.editToggle) {
        ui.editToggle.addEventListener('click', () => {
            editMode = !editMode;
            refreshEditable();
            validateBanner();
        });
    }
    // Drag-and-drop + paste for net images, anywhere on the page.
    document.addEventListener('dragover', (e) => { e.preventDefault(); });
    document.addEventListener('drop', (e) => {
        const f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
        if (f && /^image\//.test(f.type)) { e.preventDefault(); handleImageFile(f); }
    });
    document.addEventListener('paste', (e) => {
        const items = e.clipboardData && e.clipboardData.items;
        if (!items) return;
        for (const it of items) {
            if (it.kind === 'file' && /^image\//.test(it.type)) {
                const f = it.getAsFile();
                if (f) { e.preventDefault(); handleImageFile(f); break; }
            }
        }
    });

    document.querySelectorAll('.rk-twist-btn').forEach((btn) => {
        btn.addEventListener('click', async () => {
            const move = btn.dataset.move;
            await applyOne(move);
            clearSolution();
            originalState = state;
            setBanner(`Applied ${move}. Solution cleared — click Solve to re-solve.`, 'info');
        });
    });

    document.addEventListener('keydown', (ev) => {
        const t = ev.target;
        if (t && t.matches && t.matches('input, textarea')) return;
        if (ev.key === 'ArrowLeft')  { ev.preventDefault(); step(-1); }
        if (ev.key === 'ArrowRight') { ev.preventDefault(); step(+1); }
        if (ev.key === ' ')          { ev.preventDefault(); togglePlay(); }
    });

    setSize(3);
}
