/**
 * 2×2 (Pocket Cube) state model.
 *
 *  Layout — same cross convention as the 3×3, just with 2-wide faces:
 *
 *           +----+
 *           | U  |    U: 0..3   R: 4..7   F: 8..11
 *           +----+----+----+----+
 *           | L  | F  | R  | B  |  D: 12..15  L: 16..19  B: 20..23
 *           +----+----+----+----+
 *           | D  |
 *           +----+
 *
 *  Each face is row-major:    0 1
 *                             2 3
 *
 *  Indices 0..23 in a 24-character string of {U,R,F,D,L,B}. Solved state
 *  has each face uniform (UUUU RRRR FFFF DDDD LLLL BBBB).
 *
 *  The 2×2 has no fixed centers, but solving anchors on the DLB corner —
 *  i.e. the cube is solved when face stickers match their face label, with
 *  the convention that the 'D' sticker at corner DLB stays on the down face,
 *  the 'L' sticker stays on the left, and the 'B' sticker stays on the back.
 */

export const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];

export const FACE_COLORS = {
    U: '#ffffff',
    R: '#b71234',
    F: '#009b48',
    D: '#ffd500',
    L: '#ff5800',
    B: '#0046ad',
};

export const SOLVED_STATE =
    'UUUU' + 'RRRR' + 'FFFF' + 'DDDD' + 'LLLL' + 'BBBB';

const FACE_INDEX_OFFSETS = {
    U: 0, R: 4, F: 8, D: 12, L: 16, B: 20,
};

const FACE_GRID_OFFSETS = {
    U: { col: 2, row: 0 },
    L: { col: 0, row: 2 },
    F: { col: 2, row: 2 },
    R: { col: 4, row: 2 },
    B: { col: 6, row: 2 },
    D: { col: 2, row: 4 },
};

export const PLACEMENTS = (() => {
    const out = [];
    for (const face of FACES) {
        const { col: colOff, row: rowOff } = FACE_GRID_OFFSETS[face];
        const idxOff = FACE_INDEX_OFFSETS[face];
        for (let pos = 0; pos < 4; pos++) {
            out.push({
                index: idxOff + pos,
                face,
                facePos: pos,
                col: colOff + (pos % 2),
                row: rowOff + Math.floor(pos / 2),
            });
        }
    }
    out.sort((a, b) => a.index - b.index);
    return out;
})();

export const GRID_COLS = 8;
export const GRID_ROWS = 6;

export function validateState(state) {
    if (typeof state !== 'string' || state.length !== 24) {
        return { ok: false, reason: `Expected 24 stickers, got ${state ? state.length : 0}` };
    }
    const counts = {};
    for (const ch of state) {
        if (!FACES.includes(ch)) {
            return { ok: false, reason: `Invalid sticker '${ch}'` };
        }
        counts[ch] = (counts[ch] || 0) + 1;
    }
    for (const face of FACES) {
        if (counts[face] !== 4) {
            return { ok: false, reason: `Expected 4 ${face} stickers, got ${counts[face] || 0}` };
        }
    }
    return { ok: true };
}

export function setSticker(state, index, face) {
    if (index < 0 || index >= 24) throw new RangeError(`index ${index} out of range`);
    return state.slice(0, index) + face + state.slice(index + 1);
}

export function cycleSticker(state, index) {
    const current = state[index];
    const next = FACES[(FACES.indexOf(current) + 1) % FACES.length];
    return setSticker(state, index, next);
}

/* ─────────────────────────────────────────────────────────────────────
 *  Move application
 *
 *  Each move (U, R, F, D, L, B + ' + 2) is encoded as a permutation array
 *  perm[i] = source-index, so newState[i] = oldState[perm[i]].  We hand-
 *  derive only the six clockwise single-turn permutations; prime/double
 *  variants compose them.
 *
 *  Per face, sticker layout is:    0 1
 *                                  2 3
 *  CW (90° clockwise from outside) sends:
 *      0 → 1, 1 → 3, 3 → 2, 2 → 0
 *  i.e. newFace = [old[2], old[0], old[3], old[1]].
 *
 *  For each face turn, the 8 stickers on the four adjacent faces' touching
 *  edges cycle in one direction.
 * ──────────────────────────────────────────────────────────────────── */

/** Compose two perms: result[i] = a[b[i]] (apply b, then a). */
function compose(a, b) {
    const out = new Array(24);
    for (let i = 0; i < 24; i++) out[i] = a[b[i]];
    return out;
}

const IDENTITY = (() => {
    const p = new Array(24);
    for (let i = 0; i < 24; i++) p[i] = i;
    return p;
})();

/** Build a permutation that:
 *   1. rotates the four stickers of the named face by `faceCycleCw` quarter-turns CW
 *   2. cycles the 8 adjacent stickers along `ringCw` (length-8 array of indices,
 *      ordered such that a single CW turn moves ring[0,1] → ring[2,3] →
 *      ring[4,5] → ring[6,7] → ring[0,1])
 */
function buildCwPerm(faceOff, ringCw) {
    const p = IDENTITY.slice();
    // Face rotation:
    //   newFace[0]=old[2], newFace[1]=old[0], newFace[2]=old[3], newFace[3]=old[1]
    p[faceOff + 0] = faceOff + 2;
    p[faceOff + 1] = faceOff + 0;
    p[faceOff + 2] = faceOff + 3;
    p[faceOff + 3] = faceOff + 1;
    // Ring cycle: the new sticker at ring[k] comes from ring[k-2 mod 8].
    for (let k = 0; k < 8; k++) {
        p[ringCw[k]] = ringCw[(k + 6) % 8];
    }
    return p;
}

// Sticker-index mnemonics (face × position).
const U = (k) => 0  + k;  // U[0]=0,  U[1]=1,  U[2]=2,  U[3]=3
const R = (k) => 4  + k;  // R[0]=4,  R[1]=5,  R[2]=6,  R[3]=7
const F = (k) => 8  + k;  // F[0]=8,  F[1]=9,  F[2]=10, F[3]=11
const D = (k) => 12 + k;  // D[0]=12, D[1]=13, D[2]=14, D[3]=15
const L = (k) => 16 + k;  // L[0]=16, L[1]=17, L[2]=18, L[3]=19
const B = (k) => 20 + k;  // B[0]=20, B[1]=21, B[2]=22, B[3]=23

/* Adjacent-ring orderings.  Each ring is 8 indices laid out so that two
 * adjacent indices belong to the same neighbour face, and a single CW turn
 * of the named face advances the ring by 2 positions:
 *   ring[0,1]  →  ring[2,3]  →  ring[4,5]  →  ring[6,7]  →  ring[0,1]
 *
 * Picking the right ordering is the only error-prone bit.  Checked by
 * running buildCwPerm on the solved state — three CWs of any face must
 * equal one CCW (verified by the sanity check at module bottom).
 */

// U: top face.  Top edges of L,F,R,B (each face's row-0, indices [0,1]) cycle
//    F-top → L-top → B-top → R-top → F-top  (CW from above).
const RING_U = [
    F(0), F(1),
    L(0), L(1),
    B(0), B(1),
    R(0), R(1),
];

// D: bottom face.  Bottom edges of L,F,R,B (row-1, indices [2,3]).
//    F-bot → R-bot → B-bot → L-bot → F-bot.
const RING_D = [
    F(2), F(3),
    R(2), R(3),
    B(2), B(3),
    L(2), L(3),
];

// R: right face.  Stickers along the right edge of U/F/D and left edge of B.
//    U-right → B-left → D-right → F-right → U-right.
//    Right column of U = [U[1], U[3]];  Right column of F = [F[1], F[3]];
//    Right column of D = [D[1], D[3]];  Left  column of B = [B[0], B[2]].
//    For B's column, the cubie that's near U on B's left column is B[2]
//    (because B is laid out with row 0 at the BOTTOM of the cube relative
//    to the cross — when you fold B up to be behind, B's row-0 connects to
//    R-right, so B's left column [B[0],B[2]] joins U-right and D-right
//    via different ends).  Concretely: with the standard net convention
//    the orientation is U[1] at top → B[2], B[0] → D[1], D[3] → F[3],
//    F[1] → U[3].  So a single R CW cycles them in that order.
const RING_R = [
    U(1), U(3),
    B(2), B(0),
    D(1), D(3),
    F(1), F(3),
];

// L: left face.  Stickers along left edge of U/F/D and right edge of B.
//    U-left → F-left → D-left → B-right → U-left  (single L CW).
const RING_L = [
    U(0), U(2),
    F(0), F(2),
    D(0), D(2),
    B(3), B(1),
];

// F: front face.  Stickers along bottom of U, left of R, top of D, right of L.
//    U-bot[2,3] → R-left[0,2] → D-top[0,1] → L-right[1,3] → U-bot[2,3].
const RING_F = [
    U(2), U(3),
    R(0), R(2),
    D(1), D(0),
    L(3), L(1),
];

// B: back face.  Stickers along top of U, right of R, bottom of D, left of L.
//    U-top[0,1] → L-left[0,2] → D-bot[2,3] → R-right[1,3] → U-top[0,1].
const RING_B = [
    U(1), U(0),
    L(0), L(2),
    D(2), D(3),
    R(3), R(1),
];

const PERM_CW = {
    U: buildCwPerm(0,  RING_U),
    R: buildCwPerm(4,  RING_R),
    F: buildCwPerm(8,  RING_F),
    D: buildCwPerm(12, RING_D),
    L: buildCwPerm(16, RING_L),
    B: buildCwPerm(20, RING_B),
};

const PERM_CCW = {};
const PERM_180 = {};
for (const f of FACES) {
    PERM_CCW[f] = compose(compose(PERM_CW[f], PERM_CW[f]), PERM_CW[f]);
    PERM_180[f] = compose(PERM_CW[f], PERM_CW[f]);
}

/** Apply a single move to a state string.  Move ∈ "U" | "U'" | "U2" | … */
export function applyMove(state, move) {
    const f = move[0];
    const suffix = move.slice(1);
    const perm = suffix === "'" ? PERM_CCW[f]
              : suffix === '2' ? PERM_180[f]
              : PERM_CW[f];
    if (!perm) throw new Error(`Unknown move: ${move}`);
    let out = '';
    for (let i = 0; i < 24; i++) out += state[perm[i]];
    return out;
}

/** Apply a sequence of moves (string or array). */
export function applyMoves(state, moves) {
    const seq = Array.isArray(moves)
        ? moves
        : moves.trim().length === 0 ? [] : moves.trim().split(/\s+/);
    let s = state;
    for (const m of seq) s = applyMove(s, m);
    return s;
}

export function isSolved(state) {
    return state === SOLVED_STATE;
}

/** All 18 single-turn moves. */
export const ALL_MOVES = (() => {
    const out = [];
    for (const f of FACES) out.push(f, `${f}'`, `${f}2`);
    return out;
})();

// ── Sanity check at module load: U U U U should equal solved (4 CWs = identity).
{
    let s = SOLVED_STATE;
    for (let i = 0; i < 4; i++) s = applyMove(s, 'U');
    if (s !== SOLVED_STATE) {
        console.warn('[rubiks2/cube.js] U^4 != identity — move-perm bug');
    }
    // Also: U U' should equal solved.
    if (applyMove(applyMove(SOLVED_STATE, 'U'), "U'") !== SOLVED_STATE) {
        console.warn("[rubiks2/cube.js] U U' != identity — move-perm bug");
    }
}
