/** Move parsing — port of moves.ts. */

import { PLACEMENTS } from './cube.js';

const FACE_NAMES = {
    U: 'Up', D: 'Down', L: 'Left', R: 'Right', F: 'Front', B: 'Back',
};

/** Parse "U", "R'", "F2" → {raw, face, turns: 1|-1|2}. */
export function parseMove(raw) {
    const m = /^([URFDLB])(['2]?)$/.exec(raw);
    if (!m) return null;
    const face = m[1];
    const suffix = m[2];
    const turns = suffix === "'" ? -1 : suffix === '2' ? 2 : 1;
    return { raw, face, turns };
}

export function describeMove(move) {
    const name = FACE_NAMES[move.face];
    if (move.turns === 1)  return `${name} face — 90° clockwise`;
    if (move.turns === -1) return `${name} face — 90° counter-clockwise`;
    return `${name} face — 180°`;
}

/** The 9 sticker indices on the given face. */
export function stickerIndicesForFace(face) {
    return PLACEMENTS.filter((p) => p.face === face).map((p) => p.index);
}
