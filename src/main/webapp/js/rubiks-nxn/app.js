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

// 5×5
import {
    SOLVED_STATE as SOLVED_5,
    FACES as FACES_5,
} from '../rubiks5/cube.js';
import {
    applyMoves as apply5sync,
    ALL_MOVES as ALL_MOVES_5,
} from '../rubiks5/moves.js';
import { mountCubeNet as mountNet5 } from '../rubiks5/cube-net.js';

// 6×6
import {
    SOLVED_STATE as SOLVED_6,
    FACES as FACES_6,
} from '../rubiks6/cube.js';
import {
    applyMoves as apply6sync,
    ALL_MOVES as ALL_MOVES_6,
} from '../rubiks6/moves.js';
import { mountCubeNet as mountNet6 } from '../rubiks6/cube-net.js';

// 7×7
import {
    SOLVED_STATE as SOLVED_7,
    FACES as FACES_7,
} from '../rubiks7/cube.js';
import {
    applyMoves as apply7sync,
    ALL_MOVES as ALL_MOVES_7,
} from '../rubiks7/moves.js';
import { mountCubeNet as mountNet7 } from '../rubiks7/cube-net.js';

// 8×8
import {
    SOLVED_STATE as SOLVED_8,
    FACES as FACES_8,
} from '../rubiks8/cube.js';
import {
    applyMoves as apply8sync,
    ALL_MOVES as ALL_MOVES_8,
} from '../rubiks8/moves.js';
import { mountCubeNet as mountNet8 } from '../rubiks8/cube-net.js';

// 9×9
import {
    SOLVED_STATE as SOLVED_9,
    FACES as FACES_9,
} from '../rubiks9/cube.js';
import {
    applyMoves as apply9sync,
    ALL_MOVES as ALL_MOVES_9,
} from '../rubiks9/moves.js';
import { mountCubeNet as mountNet9 } from '../rubiks9/cube-net.js';

// 10×10
import {
    SOLVED_STATE as SOLVED_10,
    FACES as FACES_10,
} from '../rubiks10/cube.js';
import {
    applyMoves as apply10sync,
    ALL_MOVES as ALL_MOVES_10,
} from '../rubiks10/moves.js';
import { mountCubeNet as mountNet10 } from '../rubiks10/cube-net.js';

// Generic 3D + image parser
import { mountCubeNxN } from './cube-3d-nxn.js';
import { mountTrefoil } from './cube-trefoil-nxn.js';
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

/** Build a random scramble using single-face moves (no consecutive same-face,
 *  WCA-style).  Returns the move list — caller applies them one-at-a-time
 *  for animation. */
function buildRandomMoves(allMoves, n) {
    const moves = [];
    let lastFace = '';
    for (let i = 0; i < n; i++) {
        let mv;
        // Avoid same-face consecutives so the scramble looks meaningful.
        do {
            mv = allMoves[Math.floor(Math.random() * allMoves.length)];
        } while (mv[0] === lastFace);
        lastFace = mv[0];
        moves.push(mv);
    }
    return moves;
}

// Map from our WCA notation to cubejs's accepted alphabet.  cubejs
// (the 3×3 backend) refuses uppercase wide ("Rw") and digit-prefix
// wide ("2Rw") — it only takes lowercase wide ("r") for those.  And
// for SiGN single-inner-slice notation ("2R" = middle layer in R
// direction), cubejs has no equivalent so we translate to the
// matching M/E/S move (with sign flipped for axes whose middle slice
// follows the opposite face's direction).
const CUBEJS_SLICE_MAP = {
    '2R':  "M'",  "2R'": 'M',   '2R2': 'M2',
    '2L':  'M',   "2L'": "M'",  '2L2': 'M2',
    '2U':  "E'",  "2U'": 'E',   '2U2': 'E2',
    '2D':  'E',   "2D'": "E'",  '2D2': 'E2',
    '2F':  'S',   "2F'": "S'",  '2F2': 'S2',
    '2B':  "S'",  "2B'": 'S',   '2B2': 'S2',
};
function cubejsNormalize(moves) {
    const arr = Array.isArray(moves) ? moves : [moves];
    return arr.map(m => {
        if (CUBEJS_SLICE_MAP[m]) return CUBEJS_SLICE_MAP[m];
        // Strip explicit n=2 prefix on wide turns (2Rw == Rw).
        let s = m.replace(/^2([URFDLB]w(?:['2])?)$/, '$1');
        // Convert uppercase wide to cubejs's lowercase shorthand.
        s = s.replace(/^([URFDLB])w/, (_, f) => f.toLowerCase());
        return s;
    });
}

const sizeAdapters = {
    3: {
        SOLVED:   SOLVED_3,
        validate: (s) => validateRelaxed(s, FACES_3, 9),
        apply:    (state, moves) => apply3cubejs(state, cubejsNormalize(moves)),
        random:   () => random3cubejs(),
        // Generate a scramble move list (for animated play); fallback for 3×3
        // is to compute via cubejs randomState then derive — too complex,
        // so we synthesise from a fixed move alphabet.
        randomMoves: () => buildRandomMoves(
            ['U',"U'",'U2','R',"R'",'R2','F',"F'",'F2','D',"D'",'D2','L',"L'",'L2','B',"B'",'B2'],
            20),
        mount:    mountNet3,
    },
    4: {
        SOLVED:   SOLVED_4,
        validate: (s) => validateRelaxed(s, FACES_4, 16),
        apply:    async (state, moves) => apply4sync(state, moves),
        random:   async () => {
            return apply4sync(SOLVED_4, buildRandomMoves(ALL_MOVES_4, 30));
        },
        randomMoves: () => buildRandomMoves(ALL_MOVES_4, 20),
        mount:    mountNet4,
    },
    5: {
        SOLVED:   SOLVED_5,
        validate: (s) => validateRelaxed(s, FACES_5, 25),
        apply:    async (state, moves) => apply5sync(state, moves),
        random:   async () => {
            // Smaller scramble for 5×5 since the server-side IDA*
            // gets exponentially slower with scramble length.
            return apply5sync(SOLVED_5, buildRandomMoves(ALL_MOVES_5, 8));
        },
        randomMoves: () => buildRandomMoves(ALL_MOVES_5, 8),
        mount:    mountNet5,
    },
    6: {
        SOLVED:   SOLVED_6,
        validate: (s) => validateRelaxed(s, FACES_6, 36),
        apply:    async (state, moves) => apply6sync(state, moves),
        random:   async () => apply6sync(SOLVED_6, buildRandomMoves(ALL_MOVES_6, 8)),
        randomMoves: () => buildRandomMoves(ALL_MOVES_6, 8),
        mount:    mountNet6,
    },
    7: {
        SOLVED:   SOLVED_7,
        validate: (s) => validateRelaxed(s, FACES_7, 49),
        apply:    async (state, moves) => apply7sync(state, moves),
        random:   async () => apply7sync(SOLVED_7, buildRandomMoves(ALL_MOVES_7, 8)),
        randomMoves: () => buildRandomMoves(ALL_MOVES_7, 8),
        mount:    mountNet7,
    },
    8: {
        SOLVED:   SOLVED_8,
        validate: (s) => validateRelaxed(s, FACES_8, 64),
        apply:    async (state, moves) => apply8sync(state, moves),
        random:   async () => apply8sync(SOLVED_8, buildRandomMoves(ALL_MOVES_8, 8)),
        randomMoves: () => buildRandomMoves(ALL_MOVES_8, 8),
        mount:    mountNet8,
    },
    9: {
        SOLVED:   SOLVED_9,
        validate: (s) => validateRelaxed(s, FACES_9, 81),
        apply:    async (state, moves) => apply9sync(state, moves),
        random:   async () => apply9sync(SOLVED_9, buildRandomMoves(ALL_MOVES_9, 8)),
        randomMoves: () => buildRandomMoves(ALL_MOVES_9, 8),
        mount:    mountNet9,
    },
    10: {
        SOLVED:   SOLVED_10,
        validate: (s) => validateRelaxed(s, FACES_10, 100),
        apply:    async (state, moves) => apply10sync(state, moves),
        random:   async () => apply10sync(SOLVED_10, buildRandomMoves(ALL_MOVES_10, 8)),
        randomMoves: () => buildRandomMoves(ALL_MOVES_10, 8),
        mount:    mountNet10,
    },
};

export function bootstrap(ctx) {
    const ui = {
        sizeBtns:       Array.from(document.querySelectorAll('.rk-size-btn')),
        netHost:        ctx.netHost,
        cube3dHost:     ctx.cube3dHost,
        trefoilHost:    ctx.trefoilHost,
        fileInput:      ctx.fileInput,
        uploadBtn:      ctx.uploadBtn,
        sampleBtn:      ctx.sampleBtn,
        editToggle:     ctx.editToggle,
        statusEl:       ctx.statusEl,
        busyCard:       ctx.busyCard,
        busyTitle:      ctx.busyTitle,
        busySub:        ctx.busySub,
        busyElapsed:    ctx.busyElapsed,
        validation:     ctx.validation,
        scrambleBtn:    ctx.scrambleBtn,
        resetBtn:       ctx.resetBtn,
        shareBtn:       ctx.shareBtn,
        solveBtn:       ctx.solveBtn,
        movesPanel:     ctx.movesPanel,
        progressFill:   ctx.progressFill,
        movesList:      ctx.movesList,
        notationLine:   ctx.notationLine,
        scrambleInput:  ctx.scrambleInput,
        scrambleApply:  ctx.scrambleApply,
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
        tbSpeed:        ctx.tbSpeed,
        // GIF recording
        recordBtn:      ctx.recordBtn,
        recordStatus:   ctx.recordStatus,
        // PDF report download
        pdfBtn:         ctx.pdfBtn,
    };

    let size = 3;
    let adapter = sizeAdapters[size];
    let originalState = adapter.SOLVED;        // state when Solve was clicked
    let state = adapter.SOLVED;
    let net = null;
    let cube3d = null;
    let cube3dPending = false;                 // mountCubeNxN is async — gate concurrent mounts
    let trefoil = null;                        // 2-D trefoil projection (third view)
    let solution = null;                       // {moves, breakdown, meta, elapsedMs}
    let stepIdx = 0;                           // moves applied to `state` from `originalState`
    let playing = false;
    let editMode = false;
    let wasComplete = false;                   // playback reached the final move (gates the one-shot celebration)
    let busyTimer = null;                      // live elapsed-time ticker while a solve is in flight

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
            if (ui.busyElapsed) {
                const t0 = performance.now();
                ui.busyElapsed.textContent = '';
                clearInterval(busyTimer);
                busyTimer = setInterval(() => {
                    ui.busyElapsed.textContent =
                        'Elapsed ' + ((performance.now() - t0) / 1000).toFixed(1) + ' s';
                }, 100);
            }
        } else {
            clearInterval(busyTimer);
            busyTimer = null;
            if (ui.busyElapsed) ui.busyElapsed.textContent = '';
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
                // Orbit the 3-D cube to the face that was just edited, so it's
                // obvious which part of the cube the net sticker maps to.
                const f = ['U', 'R', 'F', 'D', 'L', 'B'][Math.floor(idx / (size * size))];
                if (cube3d && cube3d.showFace && f) cube3d.showFace(f);
            },
            highlightIndices: [],
        });
    }

    function refreshEditable() {
        if (net) net.update({ editable: editMode });
        if (ui.editToggle) {
            ui.editToggle.classList.toggle('active', editMode);
            ui.editToggle.setAttribute('aria-pressed', String(editMode));
            // Update only the tooltip label's text — DON'T replace the
            // whole button content (would clobber the SVG icon + span
            // structure that the .rk-btn-icon style depends on).
            const label = ui.editToggle.querySelector('.rk-label');
            if (label) label.textContent = editMode ? 'Editing — click stickers' : 'Edit stickers';
            // Also update the title attribute so the native browser
            // tooltip stays in sync with the active state.
            ui.editToggle.setAttribute('title',
                editMode ? 'Editing — click stickers to cycle colours' : 'Toggle sticker editing');
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
            // `state` may have changed while the (async) mount was in flight —
            // e.g. a shared cube applied from the URL on load.  Re-sync so the
            // 3-D cube matches the net/trefoil instead of showing the stale
            // state captured when mountCubeNxN was called.
            cube3d.setState(state);
            if (cube3d.setOnMove) {
                cube3d.setOnMove((move) => {
                    clearSolution();
                    applyOne(move);
                });
            }
        } catch (err) {
            console.error('3D mount failed:', err);
            ui.cube3dHost.innerHTML =
                '<div style="padding:1rem;color:var(--ms-muted);font:0.85rem var(--ms-font-sans);">' +
                '3D preview unavailable: ' + (err.message || err) + '</div>';
        } finally {
            cube3dPending = false;
        }
    }

    // Mount (or remount) the 2-D trefoil projection.  Synchronous (pure SVG),
    // so unlike mount3D it needs no pending-gate.
    function mountTref() {
        if (!ui.trefoilHost) return;
        if (trefoil) { trefoil.dispose(); trefoil = null; }
        try {
            trefoil = mountTrefoil(ui.trefoilHost, size, state);
        } catch (err) {
            console.error('Trefoil mount failed:', err);
            ui.trefoilHost.innerHTML =
                '<div style="padding:1rem;color:var(--ms-muted);font:0.85rem var(--ms-font-sans);">' +
                'Trefoil view unavailable: ' + (err.message || err) + '</div>';
        }
    }

    function paintNet() {
        if (net) net.update({ state, highlightIndices: [] });
        if (cube3d) cube3d.setState(state);
        if (trefoil) trefoil.setState(state);
    }

    // Animation speed multiplier (1× = 220 ms baseline).  Driven by the
    // toolbar dropdown; persisted across moves until the user changes it.
    let playSpeed = 1;
    const BASE_DURATION_MS = 220;

    /** Net snap + 3D animated face-turn for a single move. */
    async function paintWithMove(move) {
        if (net) net.update({ state, highlightIndices: [] });
        const dur = BASE_DURATION_MS / playSpeed;
        // Animate the 3-D cube and the 2-D trefoil in lock-step (both ride the
        // same move + post-move state), then await whichever takes longer.
        const anims = [];
        if (cube3d && cube3d.animateMove) anims.push(cube3d.animateMove(move, state, dur));
        else if (cube3d) cube3d.setState(state);
        if (trefoil) anims.push(trefoil.animateMove(move, state, dur));
        if (anims.length) await Promise.all(anims);
    }

    function clearSolution() {
        solution = null;
        stepIdx = 0;
        playing = false;
        wasComplete = false;
        if (ui.progressFill) ui.progressFill.style.width = '0%';
        ui.movesPanel.style.display = 'none';
        ui.movesList.innerHTML = '';
        if (ui.playPlay) ui.playPlay.textContent = '▶ Play';
        if (ui.tbPlayback) ui.tbPlayback.style.display = 'none';
        if (ui.tbPlayLabel) ui.tbPlayLabel.textContent = 'Play';
        if (ui.notationLine) {
            ui.notationLine.classList.remove('active');
            ui.notationLine.innerHTML = '';
        }
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
        mountTref();
        refreshEditable();
        // Enable/disable wide-turn buttons based on size.
        //   3×3        — no wide of any kind
        //   4×4 / 5×5  — 2-layer wide only
        //   6×6 / 7×7  — 2-layer + 3-layer wide
        const allowWide  = size >= 4;
        const allowWide3 = size >= 6;
        document.querySelectorAll('.rk-twist-btn[data-wide="1"]').forEach((b) => {
            b.disabled = !allowWide;
            b.title = allowWide ? b.dataset.move : 'Wide turns require 4×4 or larger';
        });
        document.querySelectorAll('.rk-twist-btn[data-wide3="1"]').forEach((b) => {
            b.disabled = !allowWide3;
            b.title = allowWide3 ? b.dataset.move : '3-layer wide turns require 6×6 or larger';
        });
        setStatus(size === 3 ? 'Ready · 3×3 (browser)' : `Ready · ${size}×${size} (server)`, 'ready');
        setBanner(`Cube reset (${size}×${size}). Click Edit stickers to match your real cube on the net — or scramble, twist, or upload a photo — then click Solve.`, 'ok');
    }

    /**
     * Infer the minimum (and likely) cube size from the scramble tokens.
     *   - has any "3Xw"   → 6×6 minimum; if >90 tokens, probably a 7×7 scramble
     *   - has any "Xw"    → 4×4 minimum; if >50 tokens, probably a 5×5 scramble
     *   - only outer      → keep current size (3×3 if currently 3, else 3 — but
     *                       we don't auto-downgrade away from a bigger cube
     *                       since the user might be doing a 4×4 alg drill on
     *                       the 4×4 view)
     * Returns the recommended size, or null if no change is needed.
     */
    function inferSizeFromScramble(tokens) {
        // Per WCA Article 12a, n in nFw must satisfy 1 < n < N.  So the
        // largest n we see places a HARD lower bound on N (N ≥ n + 1).
        // Same logic for inner-slice nF (single-layer SiGN): the layer
        // index n means there must be at least n layers from that face,
        // so N ≥ 2n - 1.
        let minN = 0;
        for (const t of tokens) {
            // nXw form (wide)
            const w = /^(\d)[URFDLB]w/.exec(t);
            if (w) {
                const n = +w[1];
                if (n + 1 > minN) minN = n + 1;
                continue;
            }
            // nX form (single inner slice)
            const s = /^(\d)[URFDLB]/.exec(t);
            if (s) {
                const n = +s[1];
                if (2 * n - 1 > minN) minN = 2 * n - 1;
                continue;
            }
            // plain Xw (default wide-2) requires N ≥ 4
            if (/[URFDLB]w/.test(t) && minN < 4) minN = 4;
        }
        if (minN >= 10) return 10;
        if (minN >= 9) return 9;
        if (minN >= 8) return 8;
        if (minN >= 7) return 7;
        if (minN >= 6) return 6;
        if (minN >= 5) return 5;
        if (minN >= 4) return 4;
        // Only outer turns / cube rotations — fits any cube. Stay on
        // the user's current size.
        return null;
    }

    /**
     * Tokenise a WCA scramble string.  Handles BOTH formats:
     *   - whitespace-separated:   "R U R' U' F R F'"
     *   - no spaces (smushed):    "RUR'U'FRF'"
     *   - mixed:                  "Rw'D2  3Uw F2"
     *
     * WCA notation is unambiguous greedy.  Tokens accepted:
     *   - outer/wide:    {@code [URFDLB]w?['2]?}
     *   - 3-layer wide:  {@code 3[URFDLB]w['2]?}
     *   - inner-slice:   {@code \d+[URFDLB]['2]?}  (e.g. 2R, 3L, 4U' — only
     *                    valid for cubes large enough to contain that layer)
     *   - 3×3 middle:    {@code [MES]['2]?}  (M, E, S, M', S2, …)
     * Lowercase r/u/f slice shorthand is NOT supported.
     *
     * Returns the array of tokens, or {@code {error, atIndex}} if the
     * string can't be fully consumed.
     */
    /**
     * Self-heal a pasted scramble string before tokenizing.  Cleans up
     * the messy reality of how scrambles get copied around the web:
     *
     *  - Unicode prime variants (U+2019 right-quote, U+2032 prime,
     *    backtick, acute accent, …) → ASCII apostrophe `'`
     *  - Various unicode dashes / non-breaking spaces (already handled
     *    by `\s`) collapsed to plain whitespace
     *  - Stray punctuation (commas, semicolons, periods, brackets,
     *    quotes, ellipsis, bullets, "→", etc.) treated as separators
     *  - Numbered list markers ("1.", "1)", "1:") stripped
     *  - Lowercase wide shorthand: u → Uw, r → Rw, f → Fw, …
     *  - Modifier-order normalisation: R'2 / R2' → R2 (both mean 180°)
     *  - Double-prime cancellation: R'' → R, R''' → R', …
     *
     * Returns the cleaned, whitespace-stripped string ready for the
     * greedy token regex.
     */
    function normalizeScrambleInput(raw) {
        let s = raw;
        // 1. Unicode prime / smart-quote variants → ASCII single quote.
        s = s.replace(/[‘’‚‛′‵´`]/g, "'");
        // 2. Unicode dashes / minus → plain ASCII hyphen (then to space).
        s = s.replace(/[‐-―−]/g, '-');
        // 3. Numbered list markers ("1.", "12)", "3:") → space.
        s = s.replace(/\b\d+[\.\)\:]\s*/g, ' ');
        // 4. Stray decorations / punctuation → space.
        s = s.replace(/[,;\.\:·•…\[\]\(\)\{\}<>|\/\\\!@#\$%\^&\*=\+~\?"\-]/g, ' ');
        // 5. Collapse whitespace.
        s = s.replace(/\s+/g, ' ').trim();
        // 6. Lowercase wide-turn shorthand → uppercase + "w" (u → Uw, rw → Rw, …).
        s = s.replace(/([urfdlb])w?/g, (_, c) => c.toUpperCase() + 'w');
        // 7. Reversed modifier order: R'2 or R2' → R2 (180° turns are
        //    direction-symmetric, so both writings mean the same thing).
        s = s.replace(/'2/g, '2').replace(/2'/g, '2');
        // 8. Double-prime cancellation: pairs of '' cancel out.
        s = s.replace(/''/g, '');
        // NOTE: whitespace is intentionally preserved here so the
        // tokenizer can use it as a token barrier — disambiguates
        // inputs like "3Rw 2L" that would otherwise smush into
        // "3Rw2L" and resolve greedily as "3Rw2 L" (wrong).
        return s.trim();
    }

    function tokenizeScramble(raw) {
        const clean = normalizeScrambleInput(raw);
        if (clean.length === 0) return { error: 'empty', atIndex: 0 };

        // Greedy within each whitespace-bounded chunk.  A token cannot
        // span a space — so user-supplied spacing always wins over
        // greedy aggregation.
        // Token alternatives, longest-prefix first within each chunk:
        //   nXw['2]?   any-layer wide turn (e.g. 2Rw, 3Rw2, 5Lw')
        //   nX['2]?    single inner slice (SiGN, e.g. 2R, 3L)
        //   Xw?['2]?   outer / default-wide (R, Rw, R2, Rw')
        //   [MES]['2]? 3×3 middle slice
        //   [xyz]['2]? whole-cube rotation
        const TOKEN_RE = /\d[URFDLB]w['2]?|\d[URFDLB]['2]?|[URFDLB]w?['2]?|[MES]['2]?|[xyz]['2]?/g;
        const chunks = clean.split(/\s+/).filter(Boolean);
        const tokens = [];
        for (const chunk of chunks) {
            let cursor = 0, m;
            TOKEN_RE.lastIndex = 0;
            while (cursor < chunk.length && (m = TOKEN_RE.exec(chunk)) !== null) {
                if (m.index !== cursor) {
                    return { error: `unexpected "${chunk[cursor]}" in "${chunk}"`, atIndex: cursor };
                }
                tokens.push(m[0]);
                cursor = TOKEN_RE.lastIndex;
            }
            if (cursor !== chunk.length) {
                return { error: `unexpected "${chunk[cursor]}" in "${chunk}"`, atIndex: cursor };
            }
        }
        return tokens;
    }

    /**
     * Detect whether the input is a CUBE STATE STRING rather than a
     * scramble in WCA notation.  States are pure [URFDLB] of length
     * 6*N² for N in {3..10}; we can recognise them by character set
     * + length.  Returns the inferred cube size, or 0 if not a state.
     */
    function detectStateInput(raw) {
        const clean = raw.replace(/\s+/g, '');
        if (!/^[URFDLB]+$/.test(clean)) return 0;     // contains non-state chars
        for (let n = 3; n <= 10; n++) {
            if (clean.length === 6 * n * n) return n;
        }
        return 0;
    }

    /** Apply a pasted cube state directly: validate, auto-switch size,
     *  and paint without animation (states aren't sequences of moves). */
    async function applyStateString(raw, n) {
        clearSolution();
        const clean = raw.replace(/\s+/g, '');
        // Auto-switch to the size implied by the state length.
        if (n !== size) {
            setSize(n);
        }
        const v = adapter.validate(clean);
        if (!v.ok) {
            if (ui.scrambleInput) ui.scrambleInput.classList.add('invalid');
            setBanner(`Invalid ${n}×${n} state: ${v.reason}`, 'bad');
            return;
        }
        state = clean;
        originalState = state;
        paintNet();
        if (ui.scrambleInput) ui.scrambleInput.classList.remove('invalid');
        setBanner(`Loaded ${n}×${n} state (${clean.length} stickers). Click Solve.`, 'ok');
        setStatus(size === 3 ? 'Ready · 3×3 (browser)' : `Ready · ${size}×${size} (server)`, 'ready');
    }

    // ── Share / restore the cube state via a URL ──────────────────────────────
    // The whole sticker state is just URFDLB letters, so it rides safely in the
    // URL hash.  Anyone opening (or pasting) the link gets the exact cube.
    function shareLinkForState(s) {
        // Use a query param, NOT the hash — the cubing-guide tabs own the hash
        // (#tab=…) and rewrite it on load, which would wipe a #s= link.
        return location.origin + location.pathname + '?s=' + s + (location.hash || '');
    }

    async function shareState() {
        const link = shareLinkForState(state);
        // Reflect it in the address bar so the page itself is now shareable too.
        try { history.replaceState(null, '', '?s=' + state + (location.hash || '')); } catch (e) {}
        try {
            await navigator.clipboard.writeText(link);
            setBanner('Shareable link copied — open it (or paste it above) to load this exact cube.', 'ok');
        } catch (e) {
            // Clipboard unavailable (non-secure context / denied): surface the
            // link in the paste box so the user can copy it by hand.
            if (ui.scrambleInput) {
                ui.scrambleInput.value = link;
                ui.scrambleInput.focus();
                ui.scrambleInput.select();
            }
            setBanner('Copy this link to share this cube: ' + link, 'info');
        }
    }

    // Pull a state out of a share link (…#s=<state>) or return a bare pasted
    // state, upper-cased.  Returns '' worth of garbage if neither.
    function extractStateCandidate(text) {
        const m = String(text || '').match(/[#?&]s=([URFDLBurfdlb]+)/);
        return (m ? m[1] : String(text || '').trim()).toUpperCase();
    }

    // Restore a shared cube (called once on load).  Prefer the value captured
    // by the inline <head> script (taken before the cubing-guide tab script
    // rewrites the hash); fall back to the live query string / hash.
    function applyStateFromUrl() {
        let raw = ((typeof window !== 'undefined' && window.__RK_SHARE) || '').toUpperCase();
        if (detectStateInput(raw) === 0) raw = extractStateCandidate(location.search);
        if (detectStateInput(raw) === 0) raw = extractStateCandidate(location.hash);
        const n = detectStateInput(raw);
        if (n > 0) {
            applyStateString(raw, n);
            setBanner(`Loaded a shared ${n}×${n} cube from the link. Click Solve.`, 'ok');
        }
    }

    /**
     * Parse a pasted/typed scramble string (with or without whitespace),
     * AUTO-DETECT whether it's a CUBE STATE or WCA NOTATION, switch
     * cube size if needed, then either load the state directly or apply
     * each move sequentially with animation.
     */
    async function applyScrambleString(raw) {
        clearSolution();
        if (!raw || !raw.trim()) {
            setBanner('Type or paste a scramble (e.g. "R U R\' U F2 D Lw") OR a full cube state (96 chars for 4×4).', 'info');
            if (ui.scrambleInput) ui.scrambleInput.focus();
            return;
        }

        // Accept a pasted SHARE LINK (…#s=<state>) — pull the state out of it.
        const linkMatch = raw.match(/[#?&]s=([URFDLBurfdlb]+)/);
        if (linkMatch) raw = linkMatch[1].toUpperCase();

        // First check if input is a cube state (pure URFDLB letters at
        // a recognised length).  States are common — cubers paste them
        // from solver chains, scramble generators that emit state, etc.
        const stateSize = detectStateInput(raw);
        if (stateSize > 0) {
            return applyStateString(raw, stateSize);
        }

        const parsed = tokenizeScramble(raw);
        if (!Array.isArray(parsed)) {
            // Tokenizer returned an error object.
            if (ui.scrambleInput) ui.scrambleInput.classList.add('invalid');
            setBanner(`Could not parse scramble: ${parsed.error}. Use WCA notation: U R F D L B (+ optional w / ' / 2). Examples: Rw' 3Uw2 4Rw 2L M' S2 x y' z2.`, 'bad');
            return;
        }
        const tokens = parsed;
        if (tokens.length === 0) {
            setBanner('No moves found in the input.', 'bad');
            return;
        }

        // Auto-detect cube size from notation.  Switch sizes if needed
        // BEFORE applying the scramble so the moves go through the
        // correct adapter (and the cube net + 3D scene rebuild for the
        // new size).
        const inferredSize = inferSizeFromScramble(tokens);
        if (inferredSize && inferredSize !== size) {
            // Don't auto-downgrade.  If the user is on 5×5 and pastes
            // a 4×4 scramble, the 4×4 scramble plays fine on 5×5 too
            // (only outer + Uw moves).  Only upgrade.
            if (inferredSize > size) {
                setBanner(`Auto-selected ${inferredSize}×${inferredSize} (the smallest cube that supports "${tokens.find(t => /3|w/.test(t)) || tokens[0]}").`, 'info');
                setSize(inferredSize);
            }
        }
        // Re-check size-specific constraints AFTER any auto-switch.
        const sizeErr = validateTokensForCurrentSize(tokens);
        if (sizeErr) {
            if (ui.scrambleInput) ui.scrambleInput.classList.add('invalid');
            setBanner(sizeErr, 'bad');
            return;
        }

        // Apply the moves ON TOP of the current cube (cumulative), matching the
        // manual twist buttons — so re-applying advances the cube each time
        // instead of restarting from solved.  (Pasting a full scramble onto a
        // solved cube behaves the same as before.)
        setStatus('Applying scramble', 'busy');
        try {
            const ANIMATE_LIMIT = 25;     // generous; typical WCA scrambles are 20-25 moves
            for (let i = 0; i < tokens.length; i++) {
                state = await adapter.apply(state, [tokens[i]]);
                if (i < ANIMATE_LIMIT) await paintWithMove(tokens[i]);
            }
            if (tokens.length > ANIMATE_LIMIT) paintNet();
            originalState = state;
            setBanner(`Applied ${tokens.length} move${tokens.length === 1 ? '' : 's'}. Click Solve.`, 'ok');
            setStatus(size === 3 ? 'Ready · 3×3 (browser)' : `Ready · ${size}×${size} (server)`, 'ready');
            if (ui.scrambleInput) ui.scrambleInput.classList.remove('invalid');
        } catch (err) {
            if (ui.scrambleInput) ui.scrambleInput.classList.add('invalid');
            setBanner('Apply failed: ' + (err.message || err), 'bad');
            setStatus('Idle', 'idle');
        }
    }

    async function scramble() {
        clearSolution();
        setStatus('Scrambling', 'busy');
        try {
            // Generate the move list, then animate each move on the 3D
            // scene + net.  For long scrambles (>15 moves) snap the rest
            // after the first 12 to keep the UI snappy.
            const moves = adapter.randomMoves
                ? adapter.randomMoves()
                : null;
            if (moves && moves.length) {
                state = adapter.SOLVED;
                paintNet();   // start from solved
                const ANIMATE_LIMIT = 15;
                for (let i = 0; i < moves.length; i++) {
                    state = await adapter.apply(state, [moves[i]]);
                    if (i < ANIMATE_LIMIT) {
                        await paintWithMove(moves[i]);    // animate
                    }
                }
                if (moves.length > ANIMATE_LIMIT) paintNet();   // final snap for any tail
            } else {
                // Fallback: synchronous (3×3 cubejs path returns final state directly)
                state = await adapter.random();
                paintNet();
            }
            originalState = state;
            setBanner(`Scrambled ${size}×${size} with ${moves ? moves.length : '?'} moves. Click Solve.`, 'ok');
            setStatus(size === 3 ? 'Ready · 3×3 (browser)'
                    : size === 4 ? 'Ready · 4×4 (server)'
                    : 'Ready · 5×5 (server)', 'ready');
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
        setBanner(`Cube reset (${size}×${size}). Click Edit stickers to match your real cube, then Solve.`, 'ok');
    }

    function renderMoves(moves, breakdown, meta, phases) {
        // Map each move index to its pipeline phase — only when the per-phase
        // counts add up to the full move list (i.e. json.moves really is the
        // concatenation of the phase move lists).  Otherwise fall back to the
        // plain untinted rendering.
        let phaseOfMove = null;
        const phasesValid = Array.isArray(phases) && phases.length > 0 &&
            phases.reduce((a, p) => a + p.count, 0) === moves.length;
        if (phasesValid) {
            phaseOfMove = [];
            phases.forEach((p, pi) => {
                for (let k = 0; k < p.count; k++) phaseOfMove.push(pi);
            });
        }

        ui.movesList.innerHTML = '';
        moves.forEach((m, i) => {
            const span = document.createElement('span');
            span.className = 'rk-move' + (phaseOfMove ? ' rk-phase-' + (phaseOfMove[i] % 8) : '');
            if (phaseOfMove) span.title = phases[phaseOfMove[i]].label;
            span.dataset.idx = String(i);
            span.textContent = m;
            span.addEventListener('click', () => jumpTo(i + 1));
            ui.movesList.appendChild(span);
        });
        if (ui.movesMeta) ui.movesMeta.textContent = meta;
        if (ui.movesBreakdown) {
            if (phasesValid) {
                // Interactive legend: each phase piece carries its colour dot
                // and clicking it jumps playback to that phase's first move.
                ui.movesBreakdown.innerHTML = '';
                let offset = 0;
                phases.forEach((p, pi) => {
                    const start = offset;
                    const piece = document.createElement('span');
                    piece.className = 'rk-piece rk-piece-btn';
                    piece.innerHTML =
                        `<span class="rk-piece-dot rk-dot-${pi % 8}"></span>` +
                        `${escapeHtml(p.label)}: <strong>${p.count}</strong>`;
                    piece.title = `Jump to ${p.label} (moves ${start + 1}–${start + p.count})`;
                    piece.addEventListener('click', () => jumpTo(start));
                    ui.movesBreakdown.appendChild(piece);
                    offset += p.count;
                });
            } else {
                ui.movesBreakdown.innerHTML = breakdown || '';
            }
        }
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
        // Keep the current chip visible inside the scrolling move list.
        const cur = ui.movesList.querySelector('.rk-move.current');
        if (cur && cur.scrollIntoView) cur.scrollIntoView({ block: 'nearest' });
        if (solution) {
            const total = solution.moves.length;
            const txt = `${stepIdx} / ${total}`;
            if (ui.playStep) ui.playStep.textContent = `Step ${txt}`;
            if (ui.tbStep) ui.tbStep.textContent = txt;
            if (ui.progressFill) {
                ui.progressFill.style.width = total ? (stepIdx / total * 100) + '%' : '0%';
            }
            updateNotationLine();
            const complete = total > 0 && stepIdx === total;
            if (complete && !wasComplete) celebrate();
            wasComplete = complete;
        }
    }

    /** One-shot green glow on the stage when playback reaches the solved state. */
    function celebrate() {
        const card = ui.cube3dHost && ui.cube3dHost.closest('.rk-stage-card');
        if (!card) return;
        card.classList.remove('rk-celebrate');
        void card.offsetWidth;   // restart the animation if it's mid-flight
        card.classList.add('rk-celebrate');
        setTimeout(() => card.classList.remove('rk-celebrate'), 1600);
    }

    /** Update the notation-explainer line above the playback strip with
     *  the current move's notation + plain-English description.  Helps
     *  cubers still learning WCA notation. */
    function updateNotationLine() {
        if (!ui.notationLine) return;
        if (!solution || stepIdx === 0 || stepIdx > solution.moves.length) {
            ui.notationLine.classList.remove('active');
            ui.notationLine.innerHTML = '';
            return;
        }
        // Show the move JUST APPLIED (stepIdx-1) and its description.
        const mv = solution.moves[stepIdx - 1];
        ui.notationLine.classList.add('active');
        ui.notationLine.innerHTML =
            `Step ${stepIdx} of ${solution.moves.length} — ` +
            `<code>${escapeHtml(mv)}</code>` +
            `<span class="rk-notation-desc">${escapeHtml(describeMove(mv))}</span>` +
            (stepIdx === solution.moves.length
                ? '<span class="rk-solved-badge">&#10003; Solved</span>'
                : '');
    }

    /** Plain-English description of a WCA move token.  Generic for any
     *  cube size — the syntax is the same. */
    function describeMove(token) {
        const m = /^(3?)([URFDLB])(w?)(['2]?)$/.exec(token || '');
        if (!m) return '(unknown move)';
        const layers = m[1] === '3' ? '3 layers' : (m[3] === 'w' ? '2 layers' : '1 layer');
        const faceName = { U: 'Up', R: 'Right', F: 'Front', D: 'Down', L: 'Left', B: 'Back' }[m[2]];
        const dir = m[4] === "'" ? '90° counter-clockwise'
                  : m[4] === '2' ? '180°'
                  : '90° clockwise';
        return `${faceName} face — ${dir}, ${layers}`;
    }

    function escapeHtml(s) {
        return String(s).replace(/[&<>"']/g, c => ({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
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
            phases: [{ label: 'Kociemba', count: moves.length }],
            meta: `Solved in ${moves.length} moves · ${dt} ms · cubejs (browser)`,
        };
    }

    async function solve4x4() {
        setStatus('Solving', 'busy');
        setBusy(true, 'Solving 4×4',
            'Forwarded to the Rubik solver service. Adversarial scrambles can take 5–40 seconds.');
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
        const phases = [];
        const tally = (label, arr) => {
            if (arr && arr.length) {
                parts.push(`<span class="rk-piece">${label}: <strong>${arr.length}</strong></span>`);
                phases.push({ label, count: arr.length });
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
            phases,
            meta: `Solved in ${moves.length} moves · ${elapsedMs} ms · server pipeline`,
        };
    }

    /** Generic server-side solve (sizes 4-7 all hit the same API now). */
    async function solveServerSide(sz, busyTitle, busySub) {
        setStatus('Solving', 'busy');
        setBusy(true, busyTitle, busySub);
        const t0 = performance.now();
        const ctxPath = (document.querySelector('meta[name="ctx"]') || {}).content || '';
        const url = ctxPath + '/CubeSolverFunctionality?action=solve&size=' + sz;
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
            throw new Error('Solver gave up: ' + (json.stoppedAt || json.detail || 'unknown'));
        }
        const moves = json.moves || [];
        const elapsedMs = json.elapsedMs || dt;
        const parts = [];
        const phases = [];
        const tally = (label, arr) => {
            if (arr && arr.length) {
                parts.push(`<span class="rk-piece">${label}: <strong>${arr.length}</strong></span>`);
                phases.push({ label, count: arr.length });
            }
        };
        tally('LR',      json.lrMoves);
        tally('FB',      json.fbMoves);
        tally('EO',      json.eoMoves);
        tally('Phase 4', json.phase4Moves);
        tally('Phase 5', json.phase5Moves);
        tally('Phase 6', json.phase6Moves);
        tally('Kociemba',json.reduceMoves);
        return {
            moves,
            elapsedMs,
            breakdown: parts.join(' '),
            phases,
            meta: `Solved in ${moves.length} moves · ${elapsedMs} ms · server`,
        };
    }

    async function solve5x5() {
        setStatus('Solving', 'busy');
        setBusy(true, 'Solving 5×5',
            'Forwarded to the Rubik solver service. Typically a few seconds; harder scrambles can take longer.');
        const t0 = performance.now();
        const ctxPath = (document.querySelector('meta[name="ctx"]') || {}).content || '';
        const url = ctxPath + '/CubeSolverFunctionality?action=solve&size=5';
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
        const phases = [];
        const tally = (label, arr) => {
            if (arr && arr.length) {
                parts.push(`<span class="rk-piece">${label}: <strong>${arr.length}</strong></span>`);
                phases.push({ label, count: arr.length });
            }
        };
        tally('LR',      json.lrMoves);
        tally('FB',      json.fbMoves);
        tally('EO',      json.eoMoves);
        tally('Phase 4', json.phase4Moves);
        tally('Phase 5', json.phase5Moves);
        tally('Phase 6', json.phase6Moves);
        tally('Kociemba',json.reduceMoves);
        return {
            moves,
            elapsedMs,
            breakdown: parts.join(' '),
            phases,
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
            const r = size === 3 ? await solve3x3()
                    : size === 4 ? await solve4x4()
                    : size === 5 ? await solve5x5()
                    : size === 6 ? await solveServerSide(6, 'Solving 6×6', 'Forwarded to the Rubik solver service.')
                    : size === 7 ? await solveServerSide(7, 'Solving 7×7', 'Forwarded to the Rubik solver service.')
                    : await solveServerSide(size, 'Solving ' + size + '×' + size, 'Forwarded to the Rubik solver service.');
            solution = r;
            stepIdx = 0;
            renderMoves(r.moves, r.breakdown, r.meta, r.phases);
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

    /**
     * Snapshot any of the live view SVGs (net or trefoil) to a Canvas at the
     * requested height, on a dark card background.  `inkColor`, when given,
     * resolves the trefoil ring guides (stroke="currentColor") to a visible
     * tint on the dark backdrop.
     */
    async function rasterizeSvgHost(host, targetH, inkColor) {
        const svg = host && host.querySelector('svg');
        if (!svg) return null;
        const cloned = svg.cloneNode(true);
        cloned.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        const vb = (cloned.getAttribute('viewBox') || '0 0 200 200').split(/\s+/).map(Number);
        const x0 = vb[0], y0 = vb[1], w = vb[2], h = vb[3];
        // Pin an explicit pixel size so the SVG rasterises regardless of its
        // width/height="100%" layout attributes.
        cloned.setAttribute('width', String(w));
        cloned.setAttribute('height', String(h));
        if (inkColor) cloned.style.color = inkColor;
        const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
        // Cover the full viewBox — the trefoil's origin is negative.
        bg.setAttribute('x', String(x0)); bg.setAttribute('y', String(y0));
        bg.setAttribute('width', String(w)); bg.setAttribute('height', String(h));
        bg.setAttribute('fill', '#0f172a');
        cloned.insertBefore(bg, cloned.firstChild);
        const xml = new XMLSerializer().serializeToString(cloned);
        const url = URL.createObjectURL(new Blob([xml], { type: 'image/svg+xml;charset=utf-8' }));
        try {
            const img = await new Promise((res, rej) => {
                const i = new Image();
                i.onload = () => res(i);
                i.onerror = () => rej(new Error('SVG rasterise failed'));
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
    const rasterizeNet     = (targetH) => rasterizeSvgHost(ui.netHost, targetH, null);
    const rasterizeTrefoil = (targetH) => rasterizeSvgHost(ui.trefoilHost, targetH, '#94a3b8');

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
        // Composite all three views (3D | trefoil | net) — matches the on-page
        // canvas.  Panel widths are constant (same viewBox + height each frame).
        const trefoilProbe = await rasterizeTrefoil(cubeH);
        const netProbe = await rasterizeNet(cubeH);
        const trefW = trefoilProbe ? trefoilProbe.width : 0;
        const netW = netProbe ? netProbe.width : 0;
        const GAP = 24, PAD = 16;
        const frameW = cubeW + (trefW ? GAP + trefW : 0) + (netW ? GAP + netW : 0) + PAD * 2;
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
                const liveTref = trefW ? await rasterizeTrefoil(cubeH) : null;
                const liveNet  = netW  ? await rasterizeNet(cubeH)     : null;
                fctx.fillStyle = '#0f172a';
                fctx.fillRect(0, 0, frameCanvas.width, frameCanvas.height);
                let x = PAD;
                fctx.drawImage(cubeCanvas, x, PAD); x += cubeW + GAP;
                if (liveTref) { fctx.drawImage(liveTref, x, PAD); x += trefW + GAP; }
                if (liveNet)  { fctx.drawImage(liveNet, x, PAD); }
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

    /**
     * Build a step-by-step PDF solve report and trigger download.
     *
     * Pages produced:
     *   1. Cover  — site branding, cube size, total moves, generation
     *               timestamp, and the initial scrambled state as a
     *               full-width cube net image.
     *   2..N-1.   — Step grid (2 cols × 3 rows = 6 steps per page).
     *               Each cell is a cube net image of the state AFTER
     *               that move, with the move name and step number.
     *   N.        — Solved state confirmation + summary.
     *
     * jsPDF is loaded on demand from esm.sh — the library is ~150 KB
     * minified and only paid for when the user actually clicks PDF.
     *
     * Cube nets are rendered by mounting an off-screen instance of the
     * size's mountCubeNet, updating its state for each step, then
     * serialising the SVG to a high-res JPEG and embedding it.
     */
    let exportingPdf = false;
    async function exportPdf() {
        if (exportingPdf) return;
        if (!solution || !solution.moves.length) {
            setBanner('No solution to export. Click Solve first.', 'info');
            return;
        }
        exportingPdf = true;
        setRecordStatus('Loading PDF library…');

        let jsPDF;
        try {
            const mod = await import('https://esm.sh/jspdf@2.5.1');
            jsPDF = mod.jsPDF || (mod.default && mod.default.jsPDF) || mod.default;
            if (!jsPDF) throw new Error('jsPDF export missing');
        } catch (err) {
            exportingPdf = false;
            setRecordStatus(null);
            setBanner('PDF library load failed: ' + (err.message || err), 'bad');
            return;
        }

        // Mount an off-screen net for snapshot rendering.
        const offHost = document.createElement('div');
        offHost.style.cssText = 'position:fixed;left:-9999px;top:0;width:600px;background:white;padding:8px;';
        document.body.appendChild(offHost);
        const offNet = adapter.mount(offHost, { state: originalState });

        // Snapshot helper: render the off-screen SVG to a JPEG dataURL.
        async function snapshotState(stateStr) {
            offNet.update({ state: stateStr });
            await new Promise(r => requestAnimationFrame(r));
            const svg = offHost.querySelector('svg');
            if (!svg) return null;
            const cloned = svg.cloneNode(true);
            cloned.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
            const vb = (cloned.getAttribute('viewBox') || '0 0 200 200').split(/\s+/).map(Number);
            const w = vb[2], h = vb[3];
            // White background for print friendliness.
            const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            bg.setAttribute('x', '0'); bg.setAttribute('y', '0');
            bg.setAttribute('width', String(w)); bg.setAttribute('height', String(h));
            bg.setAttribute('fill', '#ffffff');
            cloned.insertBefore(bg, cloned.firstChild);
            const xml = new XMLSerializer().serializeToString(cloned);
            const url = URL.createObjectURL(new Blob([xml], { type: 'image/svg+xml;charset=utf-8' }));
            try {
                const img = await new Promise((res, rej) => {
                    const i = new Image();
                    i.onload = () => res(i);
                    i.onerror = () => rej(new Error('snapshot failed'));
                    i.src = url;
                });
                // Render at 3× the SVG size for crisp print resolution.
                const scale = 3;
                const c = document.createElement('canvas');
                c.width = Math.round(w * scale);
                c.height = Math.round(h * scale);
                const cctx = c.getContext('2d');
                cctx.fillStyle = '#ffffff';
                cctx.fillRect(0, 0, c.width, c.height);
                cctx.drawImage(img, 0, 0, c.width, c.height);
                return c.toDataURL('image/jpeg', 0.92);
            } finally {
                URL.revokeObjectURL(url);
            }
        }

        // Plain-English explainer for ANY notation form (handles wide,
        // inner-slice, middle-slice, cube-rotation — broader than the
        // notation-line version above).
        function describeMoveLong(token) {
            if (!token) return '';
            if (/^[xyz]['2]?$/.test(token)) {
                const ax = { x: 'R-axis', y: 'U-axis', z: 'F-axis' }[token[0]];
                const dir = token.slice(1) === "'" ? 'reverse' : token.slice(1) === '2' ? '180°' : 'forward';
                return `Whole-cube rotation around ${ax} (${dir})`;
            }
            if (/^[MES]['2]?$/.test(token)) {
                const slice = { M: 'middle (M)', E: 'equatorial (E)', S: 'standing (S)' }[token[0]];
                const dir = token.slice(1) === "'" ? 'reverse' : token.slice(1) === '2' ? '180°' : 'CW';
                return `${slice} slice ${dir}`;
            }
            const m = /^(\d?)([URFDLB])(w?)(['2]?)$/.exec(token);
            if (!m) return '';
            const n = m[1] ? parseInt(m[1], 10) : (m[3] === 'w' ? 2 : 1);
            const wide = m[3] === 'w';
            const layers = wide ? `${n}-layer wide` : (n > 1 ? `inner layer ${n}` : 'outer');
            const faceName = { U: 'Up', R: 'Right', F: 'Front', D: 'Down', L: 'Left', B: 'Back' }[m[2]];
            const dir = m[4] === "'" ? '90° CCW' : m[4] === '2' ? '180°' : '90° CW';
            return `${faceName} ${layers} — ${dir}`;
        }

        const BRAND_TITLE  = "Rubik's Cube Solution Report";
        const BRAND_FOOTER = '8gwifi.org/math/rubik-nxn-solver.jsp';
        const PAGE_W = 210, PAGE_H = 297;     // A4 mm
        const MARGIN = 15;
        const HEADER_Y = 12;
        const FOOTER_Y = PAGE_H - 8;

        const doc = new jsPDF({ unit: 'mm', format: 'a4' });

        function drawHeader() {
            doc.setFont('helvetica', 'bold');
            doc.setFontSize(11);
            doc.setTextColor(99, 102, 241);     // accent purple
            doc.text(BRAND_TITLE, MARGIN, HEADER_Y);
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(9);
            doc.setTextColor(120, 120, 120);
            doc.text(`${size}×${size} cube · ${solution.moves.length} moves`,
                     PAGE_W - MARGIN, HEADER_Y, { align: 'right' });
            doc.setDrawColor(220, 220, 220);
            doc.line(MARGIN, HEADER_Y + 2, PAGE_W - MARGIN, HEADER_Y + 2);
        }
        function drawFooter(pageNum, totalPages) {
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(8);
            doc.setTextColor(140, 140, 140);
            doc.text(BRAND_FOOTER, MARGIN, FOOTER_Y);
            doc.text(`Page ${pageNum} of ${totalPages}`,
                     PAGE_W - MARGIN, FOOTER_Y, { align: 'right' });
        }

        try {
            setRecordStatus('Rendering cover…');
            // Cover page
            drawHeader();
            doc.setFont('helvetica', 'bold');
            doc.setFontSize(20);
            doc.setTextColor(20, 20, 20);
            doc.text(BRAND_TITLE, PAGE_W / 2, 32, { align: 'center' });
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(11);
            doc.setTextColor(80, 80, 80);
            doc.text(`${size}×${size} cube — solved in ${solution.moves.length} moves`,
                     PAGE_W / 2, 41, { align: 'center' });
            doc.setFontSize(9);
            doc.setTextColor(140, 140, 140);
            doc.text(`Generated ${new Date().toLocaleString()}`,
                     PAGE_W / 2, 48, { align: 'center' });

            // Initial scramble image (large, centered)
            const initImg = await snapshotState(originalState);
            if (initImg) {
                const imgW = 140;
                const svgVB = offHost.querySelector('svg').getAttribute('viewBox').split(/\s+/).map(Number);
                const aspect = svgVB[3] / svgVB[2];
                const imgH = imgW * aspect;
                doc.addImage(initImg, 'JPEG', (PAGE_W - imgW) / 2, 60, imgW, imgH);
                doc.setFont('helvetica', 'bold');
                doc.setFontSize(11);
                doc.setTextColor(40, 40, 40);
                doc.text('Initial scrambled state', PAGE_W / 2, 65 + imgH + 5, { align: 'center' });
            }

            // Compute total page count: 1 cover + ceil(moves/6) step pages + 1 final
            const STEPS_PER_PAGE = 6;
            const stepPages = Math.ceil(solution.moves.length / STEPS_PER_PAGE);
            const totalPages = 1 + stepPages + 1;
            drawFooter(1, totalPages);

            // Step pages — 2 cols × 3 rows grid
            let s = originalState;
            let onPage = 0;
            let pageIdx = 1;
            const cellW = (PAGE_W - 2 * MARGIN - 5) / 2;     // 2 cols, 5mm gutter
            const cellH = (PAGE_H - 30 - 15) / 3;            // 3 rows, header + footer space
            for (let i = 0; i < solution.moves.length; i++) {
                if (onPage === 0) {
                    doc.addPage();
                    pageIdx++;
                    drawHeader();
                    setRecordStatus(`Rendering step page ${pageIdx - 1}/${stepPages}…`);
                }
                const move = solution.moves[i];
                s = await adapter.apply(s, [move]);
                const img = await snapshotState(s);

                const col = onPage % 2;
                const row = Math.floor(onPage / 2);
                const x = MARGIN + col * (cellW + 5);
                const y = 22 + row * cellH;

                if (img) {
                    // Fit the image into the cell preserving aspect ratio.
                    const svgVB = offHost.querySelector('svg').getAttribute('viewBox').split(/\s+/).map(Number);
                    const aspect = svgVB[3] / svgVB[2];
                    const imgH = Math.min(cellH - 18, cellW * aspect);
                    const imgW = imgH / aspect;
                    doc.addImage(img, 'JPEG', x + (cellW - imgW) / 2, y, imgW, imgH);
                }
                // Step caption
                const capY = y + cellH - 14;
                doc.setFont('helvetica', 'bold');
                doc.setFontSize(11);
                doc.setTextColor(20, 20, 20);
                doc.text(`Step ${i + 1}:  ${move}`, x + cellW / 2, capY, { align: 'center' });
                doc.setFont('helvetica', 'normal');
                doc.setFontSize(8);
                doc.setTextColor(110, 110, 110);
                doc.text(describeMoveLong(move), x + cellW / 2, capY + 5, { align: 'center' });

                onPage++;
                if (onPage === STEPS_PER_PAGE) {
                    drawFooter(pageIdx, totalPages);
                    onPage = 0;
                }
            }
            // If the last step page wasn't full, draw its footer now.
            if (onPage > 0) drawFooter(pageIdx, totalPages);

            // Final page — solved state
            doc.addPage();
            pageIdx++;
            drawHeader();
            doc.setFont('helvetica', 'bold');
            doc.setFontSize(18);
            doc.setTextColor(20, 20, 20);
            doc.text('Solved!', PAGE_W / 2, 32, { align: 'center' });
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(11);
            doc.setTextColor(80, 80, 80);
            doc.text(`${solution.moves.length} moves applied — every face uniform.`,
                     PAGE_W / 2, 41, { align: 'center' });
            const finalImg = await snapshotState(s);
            if (finalImg) {
                const imgW = 140;
                const svgVB = offHost.querySelector('svg').getAttribute('viewBox').split(/\s+/).map(Number);
                const aspect = svgVB[3] / svgVB[2];
                const imgH = imgW * aspect;
                doc.addImage(finalImg, 'JPEG', (PAGE_W - imgW) / 2, 55, imgW, imgH);
            }
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(10);
            doc.setTextColor(80, 80, 80);
            doc.text('Print this report or share it with someone learning to cube.',
                     PAGE_W / 2, PAGE_H - 30, { align: 'center' });
            doc.setFontSize(9);
            doc.setTextColor(99, 102, 241);
            doc.textWithLink('Solve another scramble at ' + BRAND_FOOTER,
                             PAGE_W / 2, PAGE_H - 23,
                             { align: 'center', url: 'https://' + BRAND_FOOTER });
            drawFooter(pageIdx, totalPages);

            setRecordStatus('Saving…');
            doc.save(`rubiks-${size}x${size}-solution-${Date.now()}.pdf`);
            setBanner('PDF saved to your Downloads folder.', 'ok');
        } catch (err) {
            setBanner('PDF export failed: ' + (err.message || err), 'bad');
        } finally {
            document.body.removeChild(offHost);
            exportingPdf = false;
            setRecordStatus(null);
        }
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
    if (ui.scrambleApply) ui.scrambleApply.addEventListener('click', () => applyScrambleString(ui.scrambleInput && ui.scrambleInput.value));
    if (ui.scrambleInput) {
        ui.scrambleInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyScrambleString(ui.scrambleInput.value);
            }
        });
        ui.scrambleInput.addEventListener('input', () => {
            ui.scrambleInput.classList.remove('invalid');
        });
        // Paste a share link OR a full state into the box → it fills normally,
        // then auto-applies (no Apply click needed). Scrambles are left for the
        // user to Apply/Enter as before.
        ui.scrambleInput.addEventListener('paste', () => {
            setTimeout(() => {
                const candidate = extractStateCandidate(ui.scrambleInput.value || '');
                if (detectStateInput(candidate) > 0) {
                    ui.scrambleInput.value = candidate;   // normalise to the clean state
                    applyScrambleString(candidate);
                }
            }, 0);
        });
    }
    if (ui.resetBtn)    ui.resetBtn.addEventListener('click', reset);
    if (ui.shareBtn)    ui.shareBtn.addEventListener('click', shareState);
    if (ui.solveBtn)    ui.solveBtn.addEventListener('click', solve);
    if (ui.playPrev)    ui.playPrev.addEventListener('click', () => step(-1));
    if (ui.playNext)    ui.playNext.addEventListener('click', () => step(+1));
    if (ui.playPlay)    ui.playPlay.addEventListener('click', togglePlay);
    if (ui.tbPrev)      ui.tbPrev.addEventListener('click', () => step(-1));
    if (ui.tbNext)      ui.tbNext.addEventListener('click', () => step(+1));
    if (ui.tbPlay)      ui.tbPlay.addEventListener('click', togglePlay);
    if (ui.tbSpeed)     ui.tbSpeed.addEventListener('change', (e) => {
        const v = parseFloat(e.target.value);
        if (Number.isFinite(v) && v > 0) playSpeed = v;
    });

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
    if (ui.pdfBtn)    ui.pdfBtn.addEventListener('click', exportPdf);
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
        const cd = e.clipboardData;
        if (!cd) return;
        // 1) Pasted net image.
        for (const it of (cd.items || [])) {
            if (it.kind === 'file' && /^image\//.test(it.type)) {
                const f = it.getAsFile();
                if (f) { e.preventDefault(); handleImageFile(f); return; }
            }
        }
        // 2) Pasted SHARE LINK (…#s=<state>) or a bare state string anywhere on
        //    the page → apply it.  The scramble box has its own paste handler
        //    (below), so let it fill normally instead of intercepting here.
        if (e.target === ui.scrambleInput) return;
        const text = cd.getData && cd.getData('text');
        if (text) {
            const candidate = extractStateCandidate(text);
            if (detectStateInput(candidate) > 0) {
                e.preventDefault();
                if (ui.scrambleInput) ui.scrambleInput.value = candidate;
                applyScrambleString(candidate);
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
        if (ev.key === 'Home' && solution) { ev.preventDefault(); jumpTo(0); }
        if (ev.key === 'End'  && solution) { ev.preventDefault(); jumpTo(solution.moves.length); }
    });

    setSize(3);
    applyStateFromUrl();   // restore a shared cube if the link carries one

    /** @returns {string|null} Human-readable error, or null if valid for current size. */
    function validateTokensForCurrentSize(tokens) {
        for (const t of tokens) {
            const w = /^(\d)[URFDLB]w/.exec(t);
            if (w && +w[1] + 1 > size) {
                return `"${t}" needs ${+w[1] + 1}×${+w[1] + 1} or larger. Switch size or remove it.`;
            }
            const s = /^(\d)[URFDLB]/.exec(t);
            if (s && !w && 2 * +s[1] - 1 > size) {
                return `Inner slice "${t}" needs ${2 * +s[1] - 1}×${2 * +s[1] - 1} or larger. Switch size or remove it.`;
            }
            if (size === 3 && /[URFDLB]w/.test(t)) {
                const w3 = /^(\d)[URFDLB]w/.exec(t);
                const n = w3 ? +w3[1] : 2;
                if (n > 2) {
                    return `"${t}" (n=${n}) needs ${n + 1}×${n + 1} or larger. Switch size or remove it.`;
                }
            }
            if (size > 3 && /^[MES]/.test(t)) {
                return `Middle slice "${t}" is only defined for 3×3. Use "${t.replace('M', '2L').replace('E', '2D').replace('S', '2F')}" or switch to 3×3.`;
            }
        }
        return null;
    }

    /**
     * Apply a WCA move sequence for AI teaching demos (never used for solves).
     * @param {string} raw
     * @param {{ fromSolved?: boolean, maxMoves?: number }} [opts]
     */
    async function applyTeachingMoves(raw, opts = {}) {
        const maxMoves = opts.maxMoves ?? 50;
        const fromSolved = opts.fromSolved !== false;

        clearSolution();
        if (!raw || !String(raw).trim()) {
            throw new Error('No moves to apply.');
        }

        if (fromSolved) {
            state = adapter.SOLVED;
            originalState = state;
            paintNet();
        }

        const parsed = tokenizeScramble(raw);
        if (!Array.isArray(parsed)) {
            throw new Error(parsed.error || 'Could not parse WCA notation.');
        }
        const tokens = parsed;
        if (tokens.length === 0) {
            throw new Error('No moves found in the sequence.');
        }
        if (tokens.length > maxMoves) {
            throw new Error(`Sequence too long (${tokens.length} moves; max ${maxMoves}).`);
        }

        const inferredSize = inferSizeFromScramble(tokens);
        if (inferredSize && inferredSize > size) {
            setSize(inferredSize);
        }

        const sizeErr = validateTokensForCurrentSize(tokens);
        if (sizeErr) {
            throw new Error(sizeErr);
        }

        setStatus('Applying demo', 'busy');
        try {
            const ANIMATE_LIMIT = 25;
            for (let i = 0; i < tokens.length; i++) {
                state = await adapter.apply(state, [tokens[i]]);
                if (i < ANIMATE_LIMIT) await paintWithMove(tokens[i]);
            }
            if (tokens.length > ANIMATE_LIMIT) paintNet();
            originalState = state;
            setBanner(`Coach demo: ${tokens.length} move${tokens.length === 1 ? '' : 's'} applied on the cube.`, 'ok');
            setStatus(size === 3 ? 'Ready · 3×3 (browser)' : `Ready · ${size}×${size} (server)`, 'ready');
            return { applied: true, moveCount: tokens.length };
        } catch (err) {
            setStatus('Idle', 'idle');
            throw err;
        }
    }

    function getCoachContext() {
        const guideTab = document.querySelector('.cg-tab.active');
        return {
            size,
            sizeLabel: `${size}×${size}`,
            status: ui.statusEl?.textContent?.trim() || '',
            banner: ui.validation?.textContent?.trim() || '',
            scrambleInput: ui.scrambleInput?.value?.trim() || '',
            editMode: !!editMode,
            hasSolution: !!(solution && solution.moves?.length),
            solutionMoveCount: solution?.moves?.length || 0,
            playbackStep: stepIdx,
            playbackTotal: solution?.moves?.length || 0,
            activeGuideTab: guideTab?.dataset?.tab || null,
        };
    }

    return {
        getCoachContext,
        applyTeachingMoves,
        resetToSolved: reset,
        setCubeSize: setSize,
    };
}
