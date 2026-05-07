/**
 * 9×9×9 cube state model — sister of {@link js/rubiks8/cube.js} with N=9.
 *
 * 486 stickers, 6 faces × 81 stickers each, indexed row-major within a
 * face.  Per-face offsets:  U=0  R=81  F=162  D=243  L=324  B=405.
 */

export const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];

export const FACE_COLORS = {
    U: '#ffffff', R: '#b71234', F: '#009b48',
    D: '#ffd500', L: '#ff5800', B: '#0046ad',
};

export const N = 9;
export const STICKERS_PER_FACE = N * N;                       // 81
export const TOTAL_STICKERS    = 6 * STICKERS_PER_FACE;       // 486

export const SOLVED_STATE = FACES.map(f => f.repeat(STICKERS_PER_FACE)).join('');

export const FACE_INDEX_OFFSETS = {
    U: 0, R: STICKERS_PER_FACE, F: 2 * STICKERS_PER_FACE,
    D: 3 * STICKERS_PER_FACE, L: 4 * STICKERS_PER_FACE, B: 5 * STICKERS_PER_FACE,
};

const FACE_GRID_OFFSETS = {
    U: { col: N,     row: 0     },
    L: { col: 0,     row: N     },
    F: { col: N,     row: N     },
    R: { col: 2 * N, row: N     },
    B: { col: 3 * N, row: N     },
    D: { col: N,     row: 2 * N },
};

export const GRID_COLS = 4 * N;  // 36
export const GRID_ROWS = 3 * N;  // 27

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

export function validateState(state) {
    if (typeof state !== 'string' || state.length !== TOTAL_STICKERS) {
        return { ok: false, reason: `Expected ${TOTAL_STICKERS} stickers, got ${state ? state.length : 0}` };
    }
    const counts = {};
    for (const ch of state) {
        if (!FACES.includes(ch)) return { ok: false, reason: `Invalid sticker '${ch}'` };
        counts[ch] = (counts[ch] || 0) + 1;
    }
    for (const f of FACES) {
        if (counts[f] !== STICKERS_PER_FACE) {
            return { ok: false, reason: `Expected ${STICKERS_PER_FACE} '${f}' stickers, got ${counts[f] || 0}` };
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
