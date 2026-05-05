/**
 * Cube state model — port of cube.ts.
 *
 *  Layout (cubejs facelet order):
 *           +--------+
 *           | U      |     U: 0..8    R: 9..17    F: 18..26
 *           +--------+--------+--------+--------+
 *           | L      | F      | R      | B      |     D: 27..35   L: 36..44   B: 45..53
 *           +--------+--------+--------+--------+
 *           | D      |
 *           +--------+
 *
 *  State is a 54-character string of {U,R,F,D,L,B}.
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

export const SOLVED_STATE =
    'UUUUUUUUU' + 'RRRRRRRRR' + 'FFFFFFFFF' +
    'DDDDDDDDD' + 'LLLLLLLLL' + 'BBBBBBBBB';

const FACE_GRID_OFFSETS = {
    U: { col: 3, row: 0 },
    L: { col: 0, row: 3 },
    F: { col: 3, row: 3 },
    R: { col: 6, row: 3 },
    B: { col: 9, row: 3 },
    D: { col: 3, row: 6 },
};

const FACE_INDEX_OFFSETS = {
    U: 0, R: 9, F: 18, D: 27, L: 36, B: 45,
};

export const PLACEMENTS = (() => {
    const out = [];
    for (const face of FACES) {
        const { col: colOff, row: rowOff } = FACE_GRID_OFFSETS[face];
        const idxOff = FACE_INDEX_OFFSETS[face];
        for (let pos = 0; pos < 9; pos++) {
            out.push({
                index: idxOff + pos,
                face,
                facePos: pos,
                col: colOff + (pos % 3),
                row: rowOff + Math.floor(pos / 3),
            });
        }
    }
    out.sort((a, b) => a.index - b.index);
    return out;
})();

export const GRID_COLS = 12;
export const GRID_ROWS = 9;

export const CENTER_INDICES = {
    U: 4, R: 13, F: 22, D: 31, L: 40, B: 49,
};

/** Returns {ok:true} or {ok:false, reason}. */
export function validateState(state) {
    if (typeof state !== 'string' || state.length !== 54) {
        return { ok: false, reason: `Expected 54 stickers, got ${state ? state.length : 0}` };
    }
    const counts = {};
    for (const ch of state) {
        if (!FACES.includes(ch)) {
            return { ok: false, reason: `Invalid sticker '${ch}' (must be one of ${FACES.join(', ')})` };
        }
        counts[ch] = (counts[ch] || 0) + 1;
    }
    for (const face of FACES) {
        if (counts[face] !== 9) {
            return { ok: false, reason: `Expected 9 ${face} stickers, got ${counts[face] || 0}` };
        }
    }
    const centers = FACES.map((f) => state[CENTER_INDICES[f]]);
    if (new Set(centers).size !== 6) {
        return { ok: false, reason: 'Center stickers must be 6 distinct colors' };
    }
    return { ok: true };
}

/**
 * Permute face letters so centers land in canonical positions (U letter at U
 * center, etc.) — collapses any of the cube's 24 rotational orientations to
 * the canonical one. Required because cubejs expects centers in canonical
 * positions, but a parsed image can be in any orientation. Solver moves stay
 * valid because Rubik's notation is relative to whatever orientation the
 * cube is in physically.
 */
export function canonicalizeOrientation(state) {
    const subst = {};
    for (const face of FACES) {
        const currentLetter = state[CENTER_INDICES[face]];
        subst[currentLetter] = face;
    }
    let out = '';
    for (const ch of state) out += subst[ch];
    return out;
}

export function setSticker(state, index, face) {
    if (index < 0 || index >= 54) throw new RangeError(`index ${index} out of range`);
    return state.slice(0, index) + face + state.slice(index + 1);
}

export function cycleSticker(state, index) {
    const current = state[index];
    const next = FACES[(FACES.indexOf(current) + 1) % FACES.length];
    return setSticker(state, index, next);
}
