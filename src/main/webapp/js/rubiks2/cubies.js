/**
 * 2×2 Pocket Cube — 3D placement table.
 *
 * Identical conventions to the 3×3 (rubiks/cubies.js): cubies live at world
 * coordinates whose components are in {-1, +1} (the 2×2 has no middle layer,
 * so the {0} positions of the 3×3 just don't exist here).  Sticker → cubie
 * + face-normal mapping mirrors the 3×3 layout so a single cube-3d.js
 * shaped after the 3×3 version drops in with only the cubie list changing.
 */

import { FACES } from './cube.js';

const FACE_INDEX_OFFSETS = {
    U: 0, R: 4, F: 8, D: 12, L: 16, B: 20,
};

const FACE_NORMALS = {
    U: [0, 1, 0],
    D: [0, -1, 0],
    F: [0, 0, 1],
    B: [0, 0, -1],
    L: [-1, 0, 0],
    R: [1, 0, 0],
};

/** 2×2 grid coord (0 or 1) → world coord (-1 or +1). */
const W = (g) => (g === 0 ? -1 : 1);

/** (face, col∈{0,1}, row∈{0,1}) → cubie [x,y,z], each ∈ {-1, +1}. */
function cubieFor(face, col, row) {
    const c = W(col);
    const r = W(row);
    switch (face) {
        case 'U': return [c, 1, r];
        case 'D': return [c, -1, -r];
        case 'F': return [c, -r, 1];
        case 'B': return [-c, -r, -1];
        case 'L': return [-1, -r, c];
        case 'R': return [1, -r, -c];
    }
}

export const PLACEMENTS_3D = (() => {
    const out = [];
    for (const face of FACES) {
        for (let row = 0; row < 2; row++) {
            for (let col = 0; col < 2; col++) {
                const facePos = row * 2 + col;
                out.push({
                    index: FACE_INDEX_OFFSETS[face] + facePos,
                    face,
                    facePos,
                    cubie: cubieFor(face, col, row),
                    normal: FACE_NORMALS[face],
                });
            }
        }
    }
    out.sort((a, b) => a.index - b.index);
    return out;
})();

export const STICKERS_BY_CUBIE = (() => {
    const map = {};
    for (const p of PLACEMENTS_3D) {
        const k = p.cubie.join(',');
        (map[k] ||= []).push(p);
    }
    return map;
})();

export function cubieKey(x, y, z) { return `${x},${y},${z}`; }

export function cubieOnFace(face, [x, y, z]) {
    switch (face) {
        case 'U': return y === 1;
        case 'D': return y === -1;
        case 'F': return z === 1;
        case 'B': return z === -1;
        case 'L': return x === -1;
        case 'R': return x === 1;
    }
    return false;
}

export function rotationAxis(face) {
    if (face === 'U' || face === 'D') return 'y';
    if (face === 'L' || face === 'R') return 'x';
    return 'z';
}

export function rotationAngle(face, turns) {
    const sign = (face === 'U' || face === 'R' || face === 'F') ? -1 : 1;
    return sign * turns * (Math.PI / 2);
}
