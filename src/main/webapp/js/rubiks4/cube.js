/**
 * 4×4×4 cube state model.
 *
 * 96 stickers, 6 faces × 16 stickers each, indexed row-major within a face.
 * Face order matches the 3×3 / 2×2 modules:  U R F D L B  (Singmaster).
 *
 * Per-face offsets:  U=0  R=16  F=32  D=48  L=64  B=80
 * Per-face layout:
 *      0  1  2  3
 *      4  5  6  7
 *      8  9 10 11
 *     12 13 14 15
 *
 * The unfolded net is the standard cross, 16 cols × 12 rows of stickers:
 *
 *               [U×4]
 *      [L×4][F×4][R×4][B×4]
 *               [D×4]
 *
 * Move application lives in moves.js — this file is pure state shape.
 */

export const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];

export const FACE_COLORS = {
    U: '#ffffff', // white
    R: '#b71234', // red
    F: '#009b48', // green
    D: '#ffd500', // yellow
    L: '#ff5800', // orange
    B: '#0046ad', // blue
};

export const N = 4;                 // cube edge length
export const STICKERS_PER_FACE = N * N;
export const TOTAL_STICKERS = 6 * STICKERS_PER_FACE;  // 96

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

/** Net cross, in *sticker* units. Each face occupies an N×N square. */
const FACE_GRID_OFFSETS = {
    U: { col: N,     row: 0     },
    L: { col: 0,     row: N     },
    F: { col: N,     row: N     },
    R: { col: 2 * N, row: N     },
    B: { col: 3 * N, row: N     },
    D: { col: N,     row: 2 * N },
};

export const GRID_COLS = 4 * N;  // 16
export const GRID_ROWS = 3 * N;  // 12

/**
 * Per-sticker descriptor: { index, face, facePos, col, row }.
 *   facePos is 0..15 within the face (row-major).
 *   col/row are 0..GRID_COLS-1 / 0..GRID_ROWS-1, used by the SVG net renderer.
 * Sorted by global index so PLACEMENTS[i].index === i.
 */
export const PLACEMENTS = (() => {
    const out = [];
    for (const face of FACES) {
        const { col: colOff, row: rowOff } = FACE_GRID_OFFSETS[face];
        const idxOff = FACE_INDEX_OFFSETS[face];
        for (let pos = 0; pos < STICKERS_PER_FACE; pos++) {
            out.push({
                index: idxOff + pos,
                face,
                facePos: pos,
                col: colOff + (pos % N),
                row: rowOff + Math.floor(pos / N),
            });
        }
    }
    out.sort((a, b) => a.index - b.index);
    return out;
})();

/**
 * Center stickers for a 4×4 face don't have a single canonical "center" —
 * there are 4 inner stickers per face (positions 5, 6, 9, 10).  These are
 * the stickers that determine which colour belongs on which face.
 */
export const CENTER_INDICES = (() => {
    const out = {};
    const inner = [5, 6, 9, 10];
    for (const face of FACES) {
        out[face] = inner.map((p) => FACE_INDEX_OFFSETS[face] + p);
    }
    return out;
})();

/** Returns {ok:true} or {ok:false, reason}. */
export function validateState(state) {
    if (typeof state !== 'string' || state.length !== TOTAL_STICKERS) {
        return {
            ok: false,
            reason: `Expected ${TOTAL_STICKERS} stickers, got ${state ? state.length : 0}`,
        };
    }
    const counts = {};
    for (const ch of state) {
        if (!FACES.includes(ch)) {
            return { ok: false, reason: `Invalid sticker '${ch}' (must be one of ${FACES.join(', ')})` };
        }
        counts[ch] = (counts[ch] || 0) + 1;
    }
    for (const face of FACES) {
        if (counts[face] !== STICKERS_PER_FACE) {
            return {
                ok: false,
                reason: `Expected ${STICKERS_PER_FACE} ${face} stickers, got ${counts[face] || 0}`,
            };
        }
    }
    // Centers: each face's 4 inner stickers must all be the same colour, and
    // the six face-colours must be distinct (so we can identify which face is
    // which).  Note: this is a *necessary* condition but not sufficient for
    // solvability — a full solvability check requires full edge/corner parity.
    const seenCenter = new Set();
    for (const face of FACES) {
        const innerColours = CENTER_INDICES[face].map((i) => state[i]);
        const first = innerColours[0];
        if (innerColours.some((c) => c !== first)) {
            return {
                ok: false,
                reason: `${face} face: 4 inner stickers must all be the same colour`,
            };
        }
        if (seenCenter.has(first)) {
            return {
                ok: false,
                reason: `Two faces share the same centre colour '${first}'`,
            };
        }
        seenCenter.add(first);
    }
    return { ok: true };
}

export function setSticker(state, index, face) {
    return state.slice(0, index) + face + state.slice(index + 1);
}

export function cycleSticker(state, index) {
    const current = state[index];
    const next = FACES[(FACES.indexOf(current) + 1) % FACES.length];
    return setSticker(state, index, next);
}

export function isSolved(state) {
    return state === SOLVED_STATE;
}
