/**
 * 4×4 edge pairer.
 *
 * After centres are solved, a 4×4 has 12 "double-edges" (dedges).  Each dedge
 * occupies an edge of the cube and consists of two adjacent "wing" cubies.
 * In the solved state both wings on a dedge show the same two colours.  After
 * scrambling, the 24 wings are mostly mismatched — pairing means rearranging
 * them so each pair of partners ends up on the same edge.
 *
 * ─── Approach ────────────────────────────────────────────────────────
 * We pair *one dedge at a time* using a depth-limited BFS:
 *   1. Pick a not-yet-paired dedge type T.
 *   2. BFS up to depth N looking for a move sequence that pairs T without
 *      un-pairing any dedge already paired.
 *   3. Apply the sequence.
 *   4. Repeat until all 12 dedges are paired (or BFS gets stuck — the
 *      remaining edges are then left to parity.js).
 *
 * BFS depth is adaptive (5 → 8 → 11) so easy edges are paired quickly.
 *
 * ─── Cost / limitations ───────────────────────────────────────────────
 * This is the most expensive stage.  Per-edge BFS at depth 8 explores up
 * to ~30M states (with dedup); ~500 MB peak.  It works for typical cubes
 * in 5–30 seconds total.  Last-2-edges parity cases may fail the BFS and
 * surface a "stuck" error — parity.js handles those after.
 *
 * Without the multi-GB lookup tables of the reference Python solver this
 * is the practical ceiling for pure-JS edge pairing.  Solutions are not
 * optimal — typical cube ~80–150 moves for the edge stage alone.
 */

import { FACES, FACE_INDEX_OFFSETS, TOTAL_STICKERS } from '../cube.js';
import { applyMove, ALL_MOVES, applyMoves } from '../moves.js';

/* ─────────────────────────────────────────────────────────────────────
 *  Wing-position registry
 *
 *  Each wing cubie has two stickers, on two adjacent faces of the cube.
 *  We enumerate them programmatically from a 3-D cubie model so the
 *  table is impossible to mistype.
 *
 *  For each cubie at (x, y, z) with exactly two of {|x|, |y|, |z|} equal
 *  to 1, it is a wing cubie.  The two faces it sits on are the ones
 *  whose normals have absolute value 1.
 * ──────────────────────────────────────────────────────────────────── */

/** Sticker index on `face` for a sticker at cube position (x, y, z),
 *  where exactly one of x/y/z equals ±1 (matching the face normal).
 *  Coordinates are in {-0.75, -0.25, +0.25, +0.75} for the three free
 *  axes; the locked axis is exactly ±1.
 *
 *  Conventions match cube.js / cube-net.js: for each face, row 0 is
 *  the "top" of the outside view and col 0 is the viewer's left. */
function stickerIdx(face, x, y, z) {
    const off = FACE_INDEX_OFFSETS[face];
    let row, col;
    switch (face) {
        case 'U':                              // y = +1
            row = Math.round(2 * z + 1.5);     // z=-0.75 → 0, +0.75 → 3
            col = Math.round(2 * x + 1.5);
            break;
        case 'D':                              // y = -1
            row = Math.round(1.5 - 2 * z);     // z=+0.75 → 0, -0.75 → 3
            col = Math.round(2 * x + 1.5);
            break;
        case 'F':                              // z = +1
            row = Math.round(1.5 - 2 * y);
            col = Math.round(2 * x + 1.5);
            break;
        case 'B':                              // z = -1
            row = Math.round(1.5 - 2 * y);
            col = Math.round(1.5 - 2 * x);    // viewer's left is +x of cube
            break;
        case 'L':                              // x = -1
            row = Math.round(1.5 - 2 * y);
            col = Math.round(2 * z + 1.5);    // viewer's right is +z, col 0 at z=-0.75
            break;
        case 'R':                              // x = +1
            row = Math.round(1.5 - 2 * y);
            col = Math.round(1.5 - 2 * z);    // viewer's right is -z, col 0 at z=+0.75
            break;
        default: throw new Error(`unknown face ${face}`);
    }
    return off + row * 4 + col;
}

const WING_COORDS = [-0.25, +0.25];

/**
 * The 12 dedges of a 4×4, each annotated with its two face-letters and
 * the two wing cubies.  Each wing entry is { face1, idx1, face2, idx2 }
 * giving its two sticker indices.
 */
export const DEDGES = (() => {
    /**
     * Wings on edges parallel to the X axis (top and bottom front/back, plus middle horizontal edges).
     * Edge (face1, face2) where the two faces meet along an X-aligned line.
     */
    function buildEdge(face1, face2, axis, lockedCoord1, lockedCoord2) {
        // axis ∈ 'x' | 'y' | 'z' — the wing varies along this axis at WING_COORDS.
        // lockedCoord1 / lockedCoord2 fix the other two axes to ±1.
        const out = [];
        for (const c of WING_COORDS) {
            let x, y, z;
            if (axis === 'x') { x = c;            y = lockedCoord1; z = lockedCoord2; }
            if (axis === 'y') { x = lockedCoord1; y = c;            z = lockedCoord2; }
            if (axis === 'z') { x = lockedCoord1; y = lockedCoord2; z = c;            }
            out.push({
                face1, idx1: stickerIdx(face1, x, y, z),
                face2, idx2: stickerIdx(face2, x, y, z),
            });
        }
        return out;
    }

    return [
        { name: 'UF', wings: buildEdge('U', 'F', 'x', +1, +1) },
        { name: 'UR', wings: buildEdge('U', 'R', 'z', +1, +1) },
        { name: 'UB', wings: buildEdge('U', 'B', 'x', +1, -1) },
        { name: 'UL', wings: buildEdge('U', 'L', 'z', -1, +1) },
        { name: 'DF', wings: buildEdge('D', 'F', 'x', -1, +1) },
        { name: 'DR', wings: buildEdge('D', 'R', 'z', +1, -1) },
        { name: 'DB', wings: buildEdge('D', 'B', 'x', -1, -1) },
        { name: 'DL', wings: buildEdge('D', 'L', 'z', -1, -1) },
        { name: 'FR', wings: buildEdge('F', 'R', 'y', +1, +1) },
        { name: 'FL', wings: buildEdge('F', 'L', 'y', -1, +1) },
        { name: 'BR', wings: buildEdge('B', 'R', 'y', +1, -1) },
        { name: 'BL', wings: buildEdge('B', 'L', 'y', -1, -1) },
    ];
})();

/* ─────────────────────────────────────────────────────────────────────
 *  Pair detection
 * ──────────────────────────────────────────────────────────────────── */

/** True iff dedge `name` has both its wings holding the right colours.
 *  A wing is "right" if face1's sticker is face1's letter and face2's
 *  sticker is face2's letter.  This requires both wings AND correct
 *  orientation. */
export function isDedgePaired(state, name) {
    const ded = DEDGES.find((d) => d.name === name);
    if (!ded) throw new Error(`unknown dedge ${name}`);
    for (const w of ded.wings) {
        if (state[w.idx1] !== w.face1) return false;
        if (state[w.idx2] !== w.face2) return false;
    }
    return true;
}

/** Bitmask of paired dedges: bit i set iff DEDGES[i] is paired. */
export function pairedMask(state) {
    let m = 0;
    for (let i = 0; i < DEDGES.length; i++) {
        if (isDedgePaired(state, DEDGES[i].name)) m |= 1 << i;
    }
    return m;
}

export function countPairedDedges(state) {
    return popcount(pairedMask(state));
}

function popcount(x) {
    let n = 0;
    while (x) { n += x & 1; x >>>= 1; }
    return n;
}

export function isAllEdgesPaired(state) {
    return pairedMask(state) === (1 << 12) - 1;
}

/* ─────────────────────────────────────────────────────────────────────
 *  Per-edge BFS
 *
 *  For a given start state and target dedge `targetIdx`, find a short
 *  sequence of moves that pairs it without un-pairing any dedge that
 *  was paired in the start state.  Returns the sequence or null.
 * ──────────────────────────────────────────────────────────────────── */

function bfsPairOne(start, targetIdx, maxDepth, memoryBudget = 5_000_000) {
    const requiredMask = pairedMask(start);
    const targetBit = 1 << targetIdx;
    const goalMask = requiredMask | targetBit;

    // BFS with string-based visited set.  We bail if memory budget is hit
    // (caller can retry with a different target).
    const visited = new Set([start]);
    let frontier = [{ s: start, moves: [] }];

    while (frontier.length > 0) {
        const next = [];
        for (const { s, moves } of frontier) {
            if (moves.length >= maxDepth) continue;
            for (const m of ALL_MOVES) {
                // Skip cancellations (M then M').
                if (moves.length > 0) {
                    const prev = moves[moves.length - 1];
                    if (cancels(prev, m)) continue;
                }
                const t = applyMove(s, m);
                if (visited.has(t)) continue;
                visited.add(t);

                const newMask = pairedMask(t);
                const allPriorPaired = (newMask & requiredMask) === requiredMask;
                if (!allPriorPaired) continue;        // un-paired something we needed

                const newMoves = [...moves, m];
                if ((newMask & targetBit) !== 0) return newMoves;
                next.push({ s: t, moves: newMoves });

                if (visited.size > memoryBudget) return null;
            }
        }
        frontier = next;
    }
    return null;
}

/** Returns true if applying `b` immediately after `a` is wasteful: the same
 *  face/layer is being turned twice and could be combined or cancelled. */
function cancels(a, b) {
    // Same face + layer means we should combine (M M' = identity, M M = M2, etc.).
    // Cheap check: same first character + same wide marker.
    if (a[0] !== b[0]) return false;
    const aw = a.includes('w');
    const bw = b.includes('w');
    return aw === bw;
}

/* ─────────────────────────────────────────────────────────────────────
 *  Top-level solver
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Pair every dedge that we can.  Returns { moves, state, unpaired }.
 *
 *   moves:    move sequence applied to the input state.
 *   state:    state after applying `moves`.
 *   unpaired: bitmask of dedges still unpaired (caller should pass to
 *             parity.js for the last-2-edges parity case if non-zero).
 */
export function solveEdges(startState) {
    const moves = [];
    let state = startState;

    // Try increasingly deep BFS limits.  Once 8+ edges are paired most
    // cubes need depth 8+ for the remainders.
    const DEPTHS = [5, 8, 11];

    while (!isAllEdgesPaired(state)) {
        let progressed = false;
        for (let i = 0; i < DEDGES.length && !progressed; i++) {
            if (isDedgePaired(state, DEDGES[i].name)) continue;

            for (const depth of DEPTHS) {
                const seq = bfsPairOne(state, i, depth);
                if (seq) {
                    state = applyMoves(state, seq);
                    moves.push(...seq);
                    progressed = true;
                    break;
                }
            }
        }
        if (!progressed) break;     // stuck — parity probably remaining
    }
    return { moves, state, unpaired: ~pairedMask(state) & ((1 << 12) - 1) };
}
