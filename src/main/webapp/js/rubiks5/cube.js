/**
 * 5×5×5 cube state model — mirror of {@link js/rubiks4/cube.js} with N=5.
 *
 * 150 stickers, 6 faces × 25 stickers each, indexed row-major within a face.
 * Face order matches the rest of the codebase: U R F D L B (Singmaster).
 *
 * Per-face offsets:  U=0  R=25  F=50  D=75  L=100  B=125
 * Per-face layout (row-major):
 *      0  1  2  3  4
 *      5  6  7  8  9
 *     10 11 12 13 14
 *     15 16 17 18 19
 *     20 21 22 23 24
 *
 * Move application lives in moves.js — this file is pure state shape.
 */

export const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];

export const FACE_COLORS = {
    U: '#ffffff', R: '#b71234', F: '#009b48',
    D: '#ffd500', L: '#ff5800', B: '#0046ad',
};

export const N = 5;
export const STICKERS_PER_FACE = N * N;                       // 25
export const TOTAL_STICKERS    = 6 * STICKERS_PER_FACE;       // 150

export const SOLVED_STATE =
    'U'.repeat(STICKERS_PER_FACE) +
    'R'.repeat(STICKERS_PER_FACE) +
    'F'.repeat(STICKERS_PER_FACE) +
    'D'.repeat(STICKERS_PER_FACE) +
    'L'.repeat(STICKERS_PER_FACE) +
    'B'.repeat(STICKERS_PER_FACE);

export const FACE_INDEX_OFFSETS = {
    U: 0,
    R: 1 * STICKERS_PER_FACE,
    F: 2 * STICKERS_PER_FACE,
    D: 3 * STICKERS_PER_FACE,
    L: 4 * STICKERS_PER_FACE,
    B: 5 * STICKERS_PER_FACE,
};

const FACE_GRID_OFFSETS = {
    U: { col: N,     row: 0     },
    L: { col: 0,     row: N     },
    F: { col: N,     row: N     },
    R: { col: 2 * N, row: N     },
    B: { col: 3 * N, row: N     },
    D: { col: N,     row: 2 * N },
};

export const GRID_COLS = 4 * N;  // 20
export const GRID_ROWS = 3 * N;  // 15

/** PLACEMENTS[i].index === i.  Used by SVG cube-net renderer. */
export const PLACEMENTS = (() => {
    const out = [];
    for (const face of FACES) {
        const { col: colOff, row: rowOff } = FACE_GRID_OFFSETS[face];
        const idxOff = FACE_INDEX_OFFSETS[face];
        for (let pos = 0; pos < STICKERS_PER_FACE; pos++) {
            out.push({
                index:   idxOff + pos,
                face,
                facePos: pos,
                col:     colOff + (pos % N),
                row:     rowOff + Math.floor(pos / N),
            });
        }
    }
    out.sort((a, b) => a.index - b.index);
    return out;
})();

/** Centre stickers — inner 3×3 (positions 6, 7, 8, 11, 12, 13, 16, 17, 18). */
export const CENTRE_POS = [6, 7, 8, 11, 12, 13, 16, 17, 18];

/** Returns {ok:true} or {ok:false, reason}.  RELAXED — only checks
 *  length + per-face counts.  Strict centre/edge invariants belong in
 *  the solver itself. */
export function validateState(state) {
    if (typeof state !== 'string' || state.length !== TOTAL_STICKERS) {
        return { ok: false, reason: `Expected ${TOTAL_STICKERS} stickers, got ${state ? state.length : 0}` };
    }
    const counts = {};
    for (const ch of state) {
        if (!FACES.includes(ch)) {
            return { ok: false, reason: `Invalid sticker '${ch}'` };
        }
        counts[ch] = (counts[ch] || 0) + 1;
    }
    for (const face of FACES) {
        if (counts[face] !== STICKERS_PER_FACE) {
            return { ok: false, reason: `Expected ${STICKERS_PER_FACE} '${face}' stickers, got ${counts[face] || 0}` };
        }
    }
    return { ok: true };
}

export function setSticker(state, index, face) {
    return state.slice(0, index) + face + state.slice(index + 1);
}
export function cycleSticker(state, index) {
    const cur = state[index];
    const next = FACES[(FACES.indexOf(cur) + 1) % FACES.length];
    return setSticker(state, index, next);
}
export function isSolved(state) { return state === SOLVED_STATE; }
