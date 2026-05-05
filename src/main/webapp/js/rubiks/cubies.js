/** 3D placement table — port of cubies.ts. */

import { FACES } from './cube.js';

const FACE_INDEX_OFFSETS = {
    U: 0, R: 9, F: 18, D: 27, L: 36, B: 45,
};

const FACE_NORMALS = {
    U: [0, 1, 0],
    D: [0, -1, 0],
    F: [0, 0, 1],
    B: [0, 0, -1],
    L: [-1, 0, 0],
    R: [1, 0, 0],
};

/** (face, col, row) → cubie [x,y,z] where each coord ∈ {-1, 0, 1}. */
function cubieFor(face, col, row) {
    const c = col - 1;
    const r = row - 1;
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
        for (let row = 0; row < 3; row++) {
            for (let col = 0; col < 3; col++) {
                const facePos = row * 3 + col;
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

export function cubieKey(x, y, z) {
    return `${x},${y},${z}`;
}

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

/** Rotation angle (radians) for a face turn by `turns` quarter-turns.
 *  Convention: +ve face turn (U/R/F clockwise) = -ve rotation around outward
 *  normal axis using right-hand rule. */
export function rotationAngle(face, turns) {
    const sign = (face === 'U' || face === 'R' || face === 'F') ? -1 : 1;
    return sign * turns * (Math.PI / 2);
}
