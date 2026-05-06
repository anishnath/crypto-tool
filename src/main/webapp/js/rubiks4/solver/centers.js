/**
 * 4×4 centres solver — three staged BFS passes.
 *
 *   stage 1 (UD-axis):     "UD-coloured stickers live on U+D faces"
 *                          C(24, 8) = 735 471 states, 36 moves.
 *   stage 2 (LR-axis):     "LR-coloured stickers live on L+R faces,
 *                           given UD already staged"
 *                          C(16, 8) = 12 870 states, 28 moves
 *                          (excludes wide singles on non-UD axes
 *                           since those would un-stage UD).
 *   stage 3 (fine):        "every face has its own colour"
 *                          70³ = 343 000 reachable patterns, 24 moves
 *                          (outer + wide-squared — the only moves
 *                           that preserve both axis-stagings).
 *
 * After all three: each face's inner 2×2 holds 4 same-coloured stickers
 * matching the face label.  This is what edge pairing + 3×3 reduction
 * later need.
 *
 * Each stage builds its pruning table by BFS from the goal.  Solving any
 * scrambled state is O(depth) — descend the table by trying every move
 * and following the one whose result has depth-1.
 *
 * Memory budget: 16 MB (UD) + 64 KB (LR) + 16 MB (fine) ≈ 32 MB total.
 * Init: ~1-3 seconds total on first call (one-time, like cubejs's warm-up).
 */

import { FACES, FACE_INDEX_OFFSETS, SOLVED_STATE } from '../cube.js';
import { permFor, applyMoves } from '../moves.js';

/* ─────────────────────────────────────────────────────────────────────
 *  Centre-position registry — shared by every stage
 * ──────────────────────────────────────────────────────────────────── */

const FACE_CENTRE_POS = [5, 6, 9, 10];

/** Sticker indices of the 24 centre positions, in URFDLB face order.
 *  Index range per face:
 *     U  → 0..3      D  → 12..15
 *     R  → 4..7      L  → 16..19
 *     F  → 8..11     B  → 20..23
 */
export const CENTER_POSITIONS = (() => {
    const out = [];
    for (const f of FACES) {
        const off = FACE_INDEX_OFFSETS[f];
        for (const p of FACE_CENTRE_POS) out.push(off + p);
    }
    return out;
})();

const CENTRE_INDEX_OF = new Map();
for (let i = 0; i < CENTER_POSITIONS.length; i++) {
    CENTRE_INDEX_OF.set(CENTER_POSITIONS[i], i);
}

/** Full 36-move roster (outer + wide × 3 modifiers per face). */
export const CENTER_MOVES = (() => {
    const out = [];
    for (const f of FACES) {
        for (const w of ['', 'w']) {
            for (const suf of ['', "'", '2']) out.push(`${f}${w}${suf}`);
        }
    }
    return out;
})();

/** Per-move 24-element centre permutation:
 *   newCentres[i] = oldCentres[CENTER_PERMS[m][i]]
 * Centres are closed under cube moves, so this is always well-defined.
 */
const CENTER_PERMS = CENTER_MOVES.map((move) => {
    const fullPerm = permFor(move);
    const cp = new Int8Array(24);
    for (let i = 0; i < 24; i++) {
        const dst = CENTER_POSITIONS[i];
        const src = fullPerm[dst];
        const j = CENTRE_INDEX_OF.get(src);
        if (j === undefined) {
            throw new Error(`move ${move} sends centre ${i}→non-centre ${src}`);
        }
        cp[i] = j;
    }
    return cp;
});

/* ─────────────────────────────────────────────────────────────────────
 *  BFS / lookup helpers used by every stage
 * ──────────────────────────────────────────────────────────────────── */

/** Bit-permutation: out's bit i comes from bits's bit perm[i]. */
function applyBitPerm(bits, perm) {
    let out = 0;
    for (let i = 0; i < perm.length; i++) {
        out |= ((bits >>> perm[i]) & 1) << i;
    }
    return out;
}

/**
 * Generic BFS: build a depth table for stateBitsCount-bit states starting
 * from `goal`, expanding via `perms` (any-shape Int8Array per move).  Yields
 * to the event loop between depth layers so the page stays responsive.
 */
async function buildPruningTable(stateBitsCount, goal, perms) {
    const table = new Uint8Array(1 << stateBitsCount);
    table.fill(0xFF);
    table[goal] = 0;

    let frontier = [goal];
    let depth = 0;
    let visited = 1;

    while (frontier.length > 0) {
        const next = [];
        depth++;
        for (const s of frontier) {
            for (let mi = 0; mi < perms.length; mi++) {
                const t = applyBitPerm(s, perms[mi]);
                if (table[t] === 0xFF) {
                    table[t] = depth;
                    next.push(t);
                    visited++;
                }
            }
        }
        await new Promise((r) => setTimeout(r, 0));
        frontier = next;
    }
    return { table, depth, visited };
}

/** Walk down a pruning table from the current state to the goal. */
function descendPruning(table, perms, moves, goal, startBits) {
    if (table[startBits] === 0xFF) {
        throw new Error(`unreachable state 0x${startBits.toString(16)}`);
    }
    const out = [];
    let bits = startBits;
    while (bits !== goal) {
        const target = table[bits] - 1;
        let found = false;
        for (let mi = 0; mi < perms.length; mi++) {
            const cand = applyBitPerm(bits, perms[mi]);
            if (table[cand] === target) {
                out.push(moves[mi]);
                bits = cand;
                found = true;
                break;
            }
        }
        if (!found) throw new Error('pruning descent stuck — table inconsistency');
    }
    return out;
}

/* ─────────────────────────────────────────────────────────────────────
 *  Stage 1: UD-axis
 * ──────────────────────────────────────────────────────────────────── */

/** 24-bit state: bit i = 1 iff CENTER_POSITIONS[i] currently holds U or D. */
export function udStateOf(state) {
    let bits = 0;
    for (let i = 0; i < 24; i++) {
        const ch = state[CENTER_POSITIONS[i]];
        if (ch === 'U' || ch === 'D') bits |= 1 << i;
    }
    return bits;
}

const UD_GOAL = udStateOf(SOLVED_STATE);

let UD_TABLE = null;
let UD_INIT = null;
export function initUDStage() {
    if (UD_TABLE) return Promise.resolve({ depth: 0, visited: 0 });
    if (UD_INIT) return UD_INIT;
    UD_INIT = (async () => {
        const r = await buildPruningTable(24, UD_GOAL, CENTER_PERMS);
        UD_TABLE = r.table;
        return { depth: r.depth, visited: r.visited };
    })();
    return UD_INIT;
}
export function isUDStageReady() { return UD_TABLE !== null; }
export function isUDStageSolved(state) { return udStateOf(state) === UD_GOAL; }

export function solveUDStage(state) {
    if (!UD_TABLE) throw new Error('UD pruning table not ready — call await initUDStage() first');
    return descendPruning(UD_TABLE, CENTER_PERMS, CENTER_MOVES, UD_GOAL, udStateOf(state));
}

/* ─────────────────────────────────────────────────────────────────────
 *  Stage 2: LR-axis (assumes UD already staged)
 *
 *  State encoded over the 16 non-UD-axis centre positions only.
 *  Move set excludes wide singles on non-UD axes (Rw, Lw, Fw, Bw and
 *  their primes), since those slip a UD sticker off its axis.
 * ──────────────────────────────────────────────────────────────────── */

/** The 16 non-UD-axis centre indices into CENTER_POSITIONS. */
const NON_UD_INDICES = [
    4, 5, 6, 7,        // R
    8, 9, 10, 11,      // F
    16, 17, 18, 19,    // L
    20, 21, 22, 23,    // B
];

const LR_POSITIONS = NON_UD_INDICES.map((i) => CENTER_POSITIONS[i]);
const LR_INDEX_OF = new Map();
for (let i = 0; i < LR_POSITIONS.length; i++) LR_INDEX_OF.set(LR_POSITIONS[i], i);

/** 28 moves that preserve UD-stage:
 *    18 outer + Uw/Dw × {1,', 2} (6) + Rw2/Lw2/Fw2/Bw2 (4). */
const LR_MOVES = (() => {
    const out = [];
    for (const f of FACES) {
        for (const suf of ['', "'", '2']) out.push(`${f}${suf}`);
    }
    for (const f of ['U', 'D']) {
        for (const suf of ['', "'", '2']) out.push(`${f}w${suf}`);
    }
    for (const f of ['R', 'L', 'F', 'B']) out.push(`${f}w2`);
    return out;
})();

/** 16-element perms for the LR_MOVES move set. */
const LR_PERMS = LR_MOVES.map((move) => {
    const fullPerm = permFor(move);
    const cp = new Int8Array(16);
    for (let i = 0; i < 16; i++) {
        const dst = LR_POSITIONS[i];
        const src = fullPerm[dst];
        const j = LR_INDEX_OF.get(src);
        if (j === undefined) {
            throw new Error(`move ${move} sends LR-position ${i}→off-axis ${src}`);
        }
        cp[i] = j;
    }
    return cp;
});

/** 16-bit state: bit i = 1 iff LR_POSITIONS[i] holds L or R. */
export function lrStateOf(state) {
    let bits = 0;
    for (let i = 0; i < 16; i++) {
        const ch = state[LR_POSITIONS[i]];
        if (ch === 'L' || ch === 'R') bits |= 1 << i;
    }
    return bits;
}

const LR_GOAL = lrStateOf(SOLVED_STATE);

let LR_TABLE = null;
let LR_INIT = null;
export function initLRStage() {
    if (LR_TABLE) return Promise.resolve({ depth: 0, visited: 0 });
    if (LR_INIT) return LR_INIT;
    LR_INIT = (async () => {
        const r = await buildPruningTable(16, LR_GOAL, LR_PERMS);
        LR_TABLE = r.table;
        return { depth: r.depth, visited: r.visited };
    })();
    return LR_INIT;
}
export function isLRStageReady() { return LR_TABLE !== null; }
export function isLRStageSolved(state) { return lrStateOf(state) === LR_GOAL; }

export function solveLRStage(state) {
    if (!LR_TABLE) throw new Error('LR pruning table not ready — call await initLRStage() first');
    return descendPruning(LR_TABLE, LR_PERMS, LR_MOVES, LR_GOAL, lrStateOf(state));
}

/* ─────────────────────────────────────────────────────────────────────
 *  Stage 3: within-axis (fine) — assumes UD + LR already staged
 *
 *  State is 24 bits, one per centre position.  The bit's meaning depends
 *  on the position's axis:
 *     UD-axis position → bit set iff sticker is 'U'  (else 'D')
 *     LR-axis position → bit set iff sticker is 'L'  (else 'R')
 *     FB-axis position → bit set iff sticker is 'F'  (else 'B')
 *
 *  Move set: outer (18) + wide-squared (6) — anything else would shuffle
 *  a sticker between two different axes and break the prior stages.  Under
 *  this restricted set, every move's CENTER_PERM stays inside the same
 *  axis for each position, so the bit interpretation remains consistent
 *  during BFS (new bit at i = old bit at perm[i]).
 * ──────────────────────────────────────────────────────────────────── */

/** True for centre indices on the U or D face. */
function isUDIndex(i)  { return (i >= 0 && i < 4)   || (i >= 12 && i < 16); }
/** True for centre indices on the L or R face. */
function isLRIndex(i)  { return (i >= 4 && i < 8)   || (i >= 16 && i < 20); }
/** True for centre indices on the F or B face. */
function isFBIndex(i)  { return (i >= 8 && i < 12)  || (i >= 20 && i < 24); }

/** 24-bit fine state. */
export function fineStateOf(state) {
    let bits = 0;
    for (let i = 0; i < 24; i++) {
        const ch = state[CENTER_POSITIONS[i]];
        let on = false;
        if (isUDIndex(i))  on = (ch === 'U');
        else if (isLRIndex(i)) on = (ch === 'L');
        else if (isFBIndex(i)) on = (ch === 'F');
        if (on) bits |= 1 << i;
    }
    return bits;
}

const FINE_GOAL = fineStateOf(SOLVED_STATE);

/** Indices into CENTER_MOVES of the 24 stage-3 moves: outer (no 'w') and
 *  wide-squared (ends in 'w2').  Computed once. */
const FINE_MOVE_INDICES = (() => {
    const out = [];
    for (let i = 0; i < CENTER_MOVES.length; i++) {
        const m = CENTER_MOVES[i];
        const isWide = m.includes('w');
        const isSquared = m.endsWith('2');
        if (!isWide || isSquared) out.push(i);
    }
    return out;
})();

const FINE_MOVES = FINE_MOVE_INDICES.map((i) => CENTER_MOVES[i]);
const FINE_PERMS = FINE_MOVE_INDICES.map((i) => CENTER_PERMS[i]);

let FINE_TABLE = null;
let FINE_INIT = null;
export function initFineStage() {
    if (FINE_TABLE) return Promise.resolve({ depth: 0, visited: 0 });
    if (FINE_INIT) return FINE_INIT;
    FINE_INIT = (async () => {
        const r = await buildPruningTable(24, FINE_GOAL, FINE_PERMS);
        FINE_TABLE = r.table;
        return { depth: r.depth, visited: r.visited };
    })();
    return FINE_INIT;
}
export function isFineStageReady() { return FINE_TABLE !== null; }

export function solveFineStage(state) {
    if (!FINE_TABLE) throw new Error('fine pruning table not ready — call await initFineStage() first');
    return descendPruning(FINE_TABLE, FINE_PERMS, FINE_MOVES, FINE_GOAL, fineStateOf(state));
}

/* ─────────────────────────────────────────────────────────────────────
 *  Orchestrator
 * ──────────────────────────────────────────────────────────────────── */

/** Warm all three pruning tables.  Idempotent.  ~1-3 s on first call. */
export async function initCenters() {
    const ud = await initUDStage();
    const lr = await initLRStage();
    const fine = await initFineStage();
    return { ud, lr, fine };
}

/** Fully solve centres of a 4×4 cube.  Returns the move sequence and the
 *  resulting state.  Caller must `await initCenters()` once at start-up. */
export function solveCenters(state) {
    const m1 = solveUDStage(state);
    let s = applyMoves(state, m1);
    const m2 = solveLRStage(s);
    s = applyMoves(s, m2);
    const m3 = solveFineStage(s);
    s = applyMoves(s, m3);
    return { moves: [...m1, ...m2, ...m3], state: s };
}

/** True iff every face's inner 2×2 holds 4 stickers of that face's colour. */
export function isCentersSolved(state) {
    for (const f of FACES) {
        const off = FACE_INDEX_OFFSETS[f];
        for (const p of FACE_CENTRE_POS) {
            if (state[off + p] !== f) return false;
        }
    }
    return true;
}
