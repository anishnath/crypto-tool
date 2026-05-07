/**
 * 5×5 move application — port of Java {@code Cube555Moves}.
 *
 * 12 base CW quarter-turn permutations:
 *   outer:  U R F D L B
 *   wide:   Uw Rw Fw Dw Lw Bw
 *
 * Plus 24 derived (primes via cube of CW, doubles via square).  Total 36.
 *
 * Each perm is an Int8Array of length 150 with newState[i] = oldState[P[i]].
 */

import { FACE_INDEX_OFFSETS, TOTAL_STICKERS, FACES } from './cube.js';
import { buildMoveSet } from '../rubiks-nxn/moves-builder.js';

// Generic engine fallback for digit-prefix wide ("2Rw"), single inner-
// slice ("2R", "3R"), and cube rotations ("x"/"y"/"z") — anything the
// legacy regex rejects.  Verified to match this file's hand-rolled
// tables for every notation already supported.
const _builderSet = buildMoveSet(5);

const FACE_NAMES = { U: 'Up', D: 'Down', L: 'Left', R: 'Right', F: 'Front', B: 'Back' };

const MOVE_RE = /^([URFDLB])(w?)(['2]?)$/;

export function parseMove(raw) {
    const m = MOVE_RE.exec(raw);
    if (!m) return null;
    return { raw, face: m[1], wide: m[2] === 'w', turns: m[3] === "'" ? -1 : m[3] === '2' ? 2 : 1 };
}
export function describeMove(move) {
    const layer = move.wide ? 'two layers' : 'one layer';
    const dir = move.turns === 1 ? '90° clockwise' : move.turns === -1 ? '90° counter-clockwise' : '180°';
    return `${FACE_NAMES[move.face]} ${layer} — ${dir}`;
}

const U = (k) => FACE_INDEX_OFFSETS.U + k;
const R = (k) => FACE_INDEX_OFFSETS.R + k;
const F = (k) => FACE_INDEX_OFFSETS.F + k;
const D = (k) => FACE_INDEX_OFFSETS.D + k;
const L = (k) => FACE_INDEX_OFFSETS.L + k;
const B = (k) => FACE_INDEX_OFFSETS.B + k;

/* ─── Ring tables — 20 indices each, ported from Cube555Moves.java ─── */

const RING_U_OUTER = [
    F(0),F(1),F(2),F(3),F(4),
    L(0),L(1),L(2),L(3),L(4),
    B(0),B(1),B(2),B(3),B(4),
    R(0),R(1),R(2),R(3),R(4),
];
const RING_U_INNER = [
    F(5),F(6),F(7),F(8),F(9),
    L(5),L(6),L(7),L(8),L(9),
    B(5),B(6),B(7),B(8),B(9),
    R(5),R(6),R(7),R(8),R(9),
];
const RING_D_OUTER = [
    F(20),F(21),F(22),F(23),F(24),
    R(20),R(21),R(22),R(23),R(24),
    B(20),B(21),B(22),B(23),B(24),
    L(20),L(21),L(22),L(23),L(24),
];
const RING_D_INNER = [
    F(15),F(16),F(17),F(18),F(19),
    R(15),R(16),R(17),R(18),R(19),
    B(15),B(16),B(17),B(18),B(19),
    L(15),L(16),L(17),L(18),L(19),
];
const RING_R_OUTER = [
    U(4),U(9),U(14),U(19),U(24),
    B(20),B(15),B(10),B(5),B(0),
    D(4),D(9),D(14),D(19),D(24),
    F(4),F(9),F(14),F(19),F(24),
];
const RING_R_INNER = [
    U(3),U(8),U(13),U(18),U(23),
    B(21),B(16),B(11),B(6),B(1),
    D(3),D(8),D(13),D(18),D(23),
    F(3),F(8),F(13),F(18),F(23),
];
const RING_L_OUTER = [
    U(0),U(5),U(10),U(15),U(20),
    F(0),F(5),F(10),F(15),F(20),
    D(0),D(5),D(10),D(15),D(20),
    B(24),B(19),B(14),B(9),B(4),
];
const RING_L_INNER = [
    U(1),U(6),U(11),U(16),U(21),
    F(1),F(6),F(11),F(16),F(21),
    D(1),D(6),D(11),D(16),D(21),
    B(23),B(18),B(13),B(8),B(3),
];
const RING_F_OUTER = [
    U(20),U(21),U(22),U(23),U(24),
    R(0),R(5),R(10),R(15),R(20),
    D(4),D(3),D(2),D(1),D(0),
    L(24),L(19),L(14),L(9),L(4),
];
const RING_F_INNER = [
    U(15),U(16),U(17),U(18),U(19),
    R(1),R(6),R(11),R(16),R(21),
    D(9),D(8),D(7),D(6),D(5),
    L(23),L(18),L(13),L(8),L(3),
];
const RING_B_OUTER = [
    U(4),U(3),U(2),U(1),U(0),
    L(0),L(5),L(10),L(15),L(20),
    D(20),D(21),D(22),D(23),D(24),
    R(24),R(19),R(14),R(9),R(4),
];
const RING_B_INNER = [
    U(9),U(8),U(7),U(6),U(5),
    L(1),L(6),L(11),L(16),L(21),
    D(15),D(16),D(17),D(18),D(19),
    R(23),R(18),R(13),R(8),R(3),
];

/* ─── Permutation construction ─── */

function identityPerm() {
    const p = new Int32Array(TOTAL_STICKERS);
    for (let i = 0; i < TOTAL_STICKERS; i++) p[i] = i;
    return p;
}
function compose(a, b) {
    const out = new Int32Array(TOTAL_STICKERS);
    for (let i = 0; i < TOTAL_STICKERS; i++) out[i] = a[b[i]];
    return out;
}
function applyFaceCw(perm, faceOff) {
    const N = 5;
    for (let r = 0; r < N; r++) {
        for (let c = 0; c < N; c++) {
            const dst = faceOff + r * N + c;
            const src = faceOff + (N - 1 - c) * N + r;
            perm[dst] = src;
        }
    }
}
function applyRing(perm, ring) {
    const len = ring.length;
    const seg = len / 4;
    for (let k = 0; k < len; k++) {
        perm[ring[k]] = ring[(k + len - seg) % len];
    }
}
function buildCwPerm(faceOff, ...rings) {
    const p = identityPerm();
    applyFaceCw(p, faceOff);
    for (const ring of rings) applyRing(p, ring);
    return p;
}

const CW_U_OUTER = buildCwPerm(FACE_INDEX_OFFSETS.U, RING_U_OUTER);
const CW_U_WIDE  = buildCwPerm(FACE_INDEX_OFFSETS.U, RING_U_OUTER, RING_U_INNER);
const CW_R_OUTER = buildCwPerm(FACE_INDEX_OFFSETS.R, RING_R_OUTER);
const CW_R_WIDE  = buildCwPerm(FACE_INDEX_OFFSETS.R, RING_R_OUTER, RING_R_INNER);
const CW_F_OUTER = buildCwPerm(FACE_INDEX_OFFSETS.F, RING_F_OUTER);
const CW_F_WIDE  = buildCwPerm(FACE_INDEX_OFFSETS.F, RING_F_OUTER, RING_F_INNER);
const CW_D_OUTER = buildCwPerm(FACE_INDEX_OFFSETS.D, RING_D_OUTER);
const CW_D_WIDE  = buildCwPerm(FACE_INDEX_OFFSETS.D, RING_D_OUTER, RING_D_INNER);
const CW_L_OUTER = buildCwPerm(FACE_INDEX_OFFSETS.L, RING_L_OUTER);
const CW_L_WIDE  = buildCwPerm(FACE_INDEX_OFFSETS.L, RING_L_OUTER, RING_L_INNER);
const CW_B_OUTER = buildCwPerm(FACE_INDEX_OFFSETS.B, RING_B_OUTER);
const CW_B_WIDE  = buildCwPerm(FACE_INDEX_OFFSETS.B, RING_B_OUTER, RING_B_INNER);

const PERMS = {};
function add(face, cwOuter, cwWide) {
    PERMS[face]        = cwOuter;
    PERMS[face + "'"]  = compose(compose(cwOuter, cwOuter), cwOuter);
    PERMS[face + '2']  = compose(cwOuter, cwOuter);
    PERMS[face + 'w']        = cwWide;
    PERMS[face + "w'"]  = compose(compose(cwWide, cwWide), cwWide);
    PERMS[face + 'w2']  = compose(cwWide, cwWide);
}
add('U', CW_U_OUTER, CW_U_WIDE);
add('R', CW_R_OUTER, CW_R_WIDE);
add('F', CW_F_OUTER, CW_F_WIDE);
add('D', CW_D_OUTER, CW_D_WIDE);
add('L', CW_L_OUTER, CW_L_WIDE);
add('B', CW_B_OUTER, CW_B_WIDE);

export function permFor(move) {
    const p = PERMS[typeof move === 'string' ? move : move.raw];
    if (p) return p;
    // Fallback to the generic engine for "2Rw", "3R", "x", etc.
    return typeof move === 'string' ? _builderSet.permFor(move) : null;
}

export function applyMove(state, move) {
    const p = permFor(move);
    if (!p) throw new Error(`Unknown move: ${move}`);
    const out = new Array(TOTAL_STICKERS);
    for (let i = 0; i < TOTAL_STICKERS; i++) out[i] = state[p[i]];
    return out.join('');
}

export function applyMoves(state, moves) {
    const seq = typeof moves === 'string'
        ? moves.trim().split(/\s+/).filter(Boolean)
        : moves;
    let s = state;
    for (const m of seq) s = applyMove(s, m);
    return s;
}

export const ALL_MOVES = (() => {
    const out = [];
    for (const f of FACES) for (const w of ['', 'w']) for (const s of ['', "'", '2']) out.push(f + w + s);
    return out;
})();
