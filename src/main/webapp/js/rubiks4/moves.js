/**
 * 4×4×4 move application.
 *
 * 12 base CW quarter-turns:
 *   outer:  U  R  F  D  L  B    (rotate one face slice)
 *   wide:   Uw Rw Fw Dw Lw Bw   (rotate two slices: outer + adjacent inner)
 *
 *   ' suffix → 270° CW (= 90° CCW)
 *   2 suffix → 180°
 *
 *   Slice-only notation (M E S, or lowercase u r f …) is intentionally not
 *   supported — every move can be expressed as a quarter-turn of an outer
 *   or wide layer, which is enough for the reduction-method solver.
 *
 * Each base CW perm is encoded as an Int8Array P of length 96 with
 * newState[i] = oldState[P[i]].  Composition: (a∘b)[i] = a[b[i]].
 *
 * Sticker-coordinate sanity:
 *   Each face is row-major 4×4.  Looking at face-from-outside, row 0 = top of
 *   that view, col 0 = viewer's left.  Specifically:
 *     U:  row 0 = back edge, col 0 = left edge
 *     D:  row 0 = front edge, col 0 = left edge
 *     F:  row 0 = top, col 0 = left
 *     B:  row 0 = top, col 0 = right-of-cube (B viewed from behind, viewer's
 *         left is +x)
 *     R:  row 0 = top, col 0 = front (viewer at +x looking -x, viewer's left = +z)
 *     L:  row 0 = top, col 0 = back  (viewer at -x looking +x, viewer's left = -z)
 *
 * The ring orderings below were derived by carrying over the 2×2 module's
 * RING_* patterns (which are orientation-checked and shipping) and just
 * widening from 2 stickers per face to 4.  Plus, for each wide move, the
 * adjacent inner-slice column/row is added as a second ring with the same
 * cycle direction.
 */

import { FACE_INDEX_OFFSETS, TOTAL_STICKERS, FACES } from './cube.js';

const FACE_NAMES = {
    U: 'Up', D: 'Down', L: 'Left', R: 'Right', F: 'Front', B: 'Back',
};

/** Move literal regex. Captures face, optional 'w' (wide), optional ' or 2. */
const MOVE_RE = /^([URFDLB])(w?)(['2]?)$/;

/** Parse "U", "Uw'", "F2", "Lw" → {raw, face, wide, turns} or null. */
export function parseMove(raw) {
    const m = MOVE_RE.exec(raw);
    if (!m) return null;
    const face = m[1];
    const wide = m[2] === 'w';
    const suffix = m[3];
    const turns = suffix === "'" ? -1 : suffix === '2' ? 2 : 1;
    return { raw, face, wide, turns };
}

export function describeMove(move) {
    const layer = move.wide ? 'two layers' : 'one layer';
    const name = FACE_NAMES[move.face];
    const dir = move.turns === 1 ? '90° clockwise'
              : move.turns === -1 ? '90° counter-clockwise'
              : '180°';
    return `${name} ${layer} — ${dir}`;
}

/* ─────────────────────────────────────────────────────────────────────
 *  Permutation construction
 * ──────────────────────────────────────────────────────────────────── */

function identityPerm() {
    const p = new Int8Array(TOTAL_STICKERS);
    for (let i = 0; i < TOTAL_STICKERS; i++) p[i] = i;
    return p;
}

/** result[i] = a[b[i]] — apply b first, then a. */
function compose(a, b) {
    const out = new Int8Array(TOTAL_STICKERS);
    for (let i = 0; i < TOTAL_STICKERS; i++) out[i] = a[b[i]];
    return out;
}

/** Sticker-index helpers, one per face. faceIdx('U', 5) === 0 + 5. */
const U = (k) => FACE_INDEX_OFFSETS.U + k;
const R = (k) => FACE_INDEX_OFFSETS.R + k;
const F = (k) => FACE_INDEX_OFFSETS.F + k;
const D = (k) => FACE_INDEX_OFFSETS.D + k;
const L = (k) => FACE_INDEX_OFFSETS.L + k;
const B = (k) => FACE_INDEX_OFFSETS.B + k;

/**
 * Apply a CW rotation of a single 4×4 face's 16 stickers in-place to a
 * permutation array.  The face is the one given by faceOff.
 *
 * For row-major indexing, CW (90° from outside) sends:
 *   newFace[r,c] = oldFace[3-c, r]
 *
 * Example: index 0 (r=0,c=0) ← oldFace[(3,0)] = index 12.
 */
function applyFaceCw(perm, faceOff) {
    for (let r = 0; r < 4; r++) {
        for (let c = 0; c < 4; c++) {
            const dst = faceOff + r * 4 + c;
            const src = faceOff + (3 - c) * 4 + r;
            perm[dst] = src;
        }
    }
}

/**
 * Apply one ring cycle to a permutation.  `ring` is 16 indices laid out
 * such that one CW turn shifts each segment of 4 forward by one segment:
 *   ring[0..3]   → ring[4..7]   → ring[8..11]   → ring[12..15]   → ring[0..3]
 *
 * Concretely: newState[ring[k]] = oldState[ring[k - 4 mod 16]].
 */
function applyRing(perm, ring) {
    const len = ring.length;
    const seg = len / 4;
    for (let k = 0; k < len; k++) {
        perm[ring[k]] = ring[(k + len - seg) % len];
    }
}

/**
 * Build a CW perm from a face rotation + one or more side rings.  Wide
 * moves pass two rings (outer + inner slice); outer moves pass just one.
 */
function buildCwPerm(faceOff, rings) {
    const p = identityPerm();
    applyFaceCw(p, faceOff);
    for (const ring of rings) applyRing(p, ring);
    return p;
}

/* ─────────────────────────────────────────────────────────────────────
 *  Ring tables — orientations carried over from 2×2 RING_* and widened.
 *
 *  Each ring is 16 indices: 4 stickers from each of 4 side-faces, in
 *  CW order around the rotating face when viewed from outside.
 *  For wide moves, *_INNER is the next ring inward.
 * ──────────────────────────────────────────────────────────────────── */

// U turn — ring around top of cube. F-top → L-top → B-top → R-top → F-top.
const RING_U_OUTER = [
    F(0),  F(1),  F(2),  F(3),
    L(0),  L(1),  L(2),  L(3),
    B(0),  B(1),  B(2),  B(3),
    R(0),  R(1),  R(2),  R(3),
];
const RING_U_INNER = [
    F(4),  F(5),  F(6),  F(7),
    L(4),  L(5),  L(6),  L(7),
    B(4),  B(5),  B(6),  B(7),
    R(4),  R(5),  R(6),  R(7),
];

// D turn — ring around bottom.  F-bot → R-bot → B-bot → L-bot → F-bot.
const RING_D_OUTER = [
    F(12), F(13), F(14), F(15),
    R(12), R(13), R(14), R(15),
    B(12), B(13), B(14), B(15),
    L(12), L(13), L(14), L(15),
];
const RING_D_INNER = [
    F(8),  F(9),  F(10), F(11),
    R(8),  R(9),  R(10), R(11),
    B(8),  B(9),  B(10), B(11),
    L(8),  L(9),  L(10), L(11),
];

// R turn — ring around right.  U-right → B-left(rev) → D-right → F-right → U-right.
const RING_R_OUTER = [
    U(3),  U(7),  U(11), U(15),
    B(12), B(8),  B(4),  B(0),
    D(3),  D(7),  D(11), D(15),
    F(3),  F(7),  F(11), F(15),
];
const RING_R_INNER = [
    U(2),  U(6),  U(10), U(14),
    B(13), B(9),  B(5),  B(1),
    D(2),  D(6),  D(10), D(14),
    F(2),  F(6),  F(10), F(14),
];

// L turn — ring around left.  U-left → F-left → D-left → B-right(rev) → U-left.
const RING_L_OUTER = [
    U(0),  U(4),  U(8),  U(12),
    F(0),  F(4),  F(8),  F(12),
    D(0),  D(4),  D(8),  D(12),
    B(15), B(11), B(7),  B(3),
];
const RING_L_INNER = [
    U(1),  U(5),  U(9),  U(13),
    F(1),  F(5),  F(9),  F(13),
    D(1),  D(5),  D(9),  D(13),
    B(14), B(10), B(6),  B(2),
];

// F turn — ring around front.  U-bot → R-left → D-top(rev) → L-right(rev) → U-bot.
const RING_F_OUTER = [
    U(12), U(13), U(14), U(15),
    R(0),  R(4),  R(8),  R(12),
    D(3),  D(2),  D(1),  D(0),
    L(15), L(11), L(7),  L(3),
];
const RING_F_INNER = [
    U(8),  U(9),  U(10), U(11),
    R(1),  R(5),  R(9),  R(13),
    D(7),  D(6),  D(5),  D(4),
    L(14), L(10), L(6),  L(2),
];

// B turn — ring around back.  U-top(rev) → L-left → D-bot → R-right(rev) → U-top.
const RING_B_OUTER = [
    U(3),  U(2),  U(1),  U(0),
    L(0),  L(4),  L(8),  L(12),
    D(12), D(13), D(14), D(15),
    R(15), R(11), R(7),  R(3),
];
const RING_B_INNER = [
    U(7),  U(6),  U(5),  U(4),
    L(1),  L(5),  L(9),  L(13),
    D(8),  D(9),  D(10), D(11),
    R(14), R(10), R(6),  R(2),
];

/* ─────────────────────────────────────────────────────────────────────
 *  Permutation tables
 * ──────────────────────────────────────────────────────────────────── */

const OUTER_RINGS = {
    U: [RING_U_OUTER],
    R: [RING_R_OUTER],
    F: [RING_F_OUTER],
    D: [RING_D_OUTER],
    L: [RING_L_OUTER],
    B: [RING_B_OUTER],
};

const WIDE_RINGS = {
    U: [RING_U_OUTER, RING_U_INNER],
    R: [RING_R_OUTER, RING_R_INNER],
    F: [RING_F_OUTER, RING_F_INNER],
    D: [RING_D_OUTER, RING_D_INNER],
    L: [RING_L_OUTER, RING_L_INNER],
    B: [RING_B_OUTER, RING_B_INNER],
};

const CW = {};
const CCW = {};
const HALF = {};

for (const f of FACES) {
    const off = FACE_INDEX_OFFSETS[f];
    CW[f]  = { outer: buildCwPerm(off, OUTER_RINGS[f]), wide: buildCwPerm(off, WIDE_RINGS[f]) };
    CCW[f] = { outer: compose(compose(CW[f].outer, CW[f].outer), CW[f].outer),
               wide:  compose(compose(CW[f].wide,  CW[f].wide),  CW[f].wide)  };
    HALF[f] = { outer: compose(CW[f].outer, CW[f].outer),
                wide:  compose(CW[f].wide,  CW[f].wide)  };
}

/* ─────────────────────────────────────────────────────────────────────
 *  Apply
 * ──────────────────────────────────────────────────────────────────── */

/** Lookup the 96-element sticker permutation for a move. Used by the
 *  centers/edges solvers to derive smaller per-stage perms. */
export function permFor(move) {
    const m = typeof move === 'string' ? parseMove(move) : move;
    if (!m) return null;
    const layer = m.wide ? 'wide' : 'outer';
    const table = m.turns === 1 ? CW : m.turns === -1 ? CCW : HALF;
    return table[m.face][layer];
}

/** Apply a single move to a state string. */
export function applyMove(state, move) {
    const p = permFor(move);
    if (!p) throw new Error(`Unknown move: ${move}`);
    const out = new Array(TOTAL_STICKERS);
    for (let i = 0; i < TOTAL_STICKERS; i++) out[i] = state[p[i]];
    return out.join('');
}

/** Apply a sequence of moves (string "U R Uw'" or array). */
export function applyMoves(state, moves) {
    const seq = typeof moves === 'string'
        ? moves.trim().split(/\s+/).filter(Boolean)
        : moves;
    let s = state;
    for (const m of seq) s = applyMove(s, m);
    return s;
}

/** Inverse of a move sequence: reverse order, invert each. */
export function invertMoves(moves) {
    const seq = typeof moves === 'string'
        ? moves.trim().split(/\s+/).filter(Boolean)
        : moves;
    return seq.slice().reverse().map(invertMove);
}

function invertMove(raw) {
    const m = parseMove(raw);
    if (!m) throw new Error(`Unknown move: ${raw}`);
    if (m.turns === 2) return raw;             // 180° is self-inverse
    const w = m.wide ? 'w' : '';
    const inverted = m.turns === 1 ? "'" : '';  // '' → 1, "'" → -1, swap
    return `${m.face}${w}${inverted}`;
}

/** All 36 base moves (6 faces × {outer,wide} × {1, -1, 2}). Useful for BFS. */
export const ALL_MOVES = (() => {
    const out = [];
    for (const f of FACES) {
        for (const w of ['', 'w']) {
            for (const suf of ['', "'", '2']) {
                out.push(`${f}${w}${suf}`);
            }
        }
    }
    return out;
})();
