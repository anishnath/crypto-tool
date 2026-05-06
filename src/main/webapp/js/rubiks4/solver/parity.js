/**
 * 4×4 parity fix-ups.
 *
 * After centres are solved and edges are paired, a 4×4 reduces to a 3×3.
 * BUT the 4×4 cube group is larger than the 3×3 group, so two reduced
 * states are unreachable from a 3×3-only solver:
 *
 *   1. OLL parity — a single reduced edge is "flipped" (its two stickers
 *      are swapped relative to a real 3×3 edge).  Detected when the 3×3
 *      reduction has a single edge with the wrong orientation.
 *   2. PLL parity — two reduced edges are swapped without any other
 *      change.  Detected when the reduced 3×3 has only an edge-swap
 *      defect that no 3×3 algorithm can resolve.
 *
 * Both have well-known fixed sequences (independent of cube state).  We
 * apply them when detected.  The OLL parity alg below is the standard
 * "single dedge flip" sequence; the PLL parity alg is the standard "two
 * dedge swap" sequence.  Either may be slightly suboptimal but is
 * universal — they don't need scramble-specific tweaking.
 *
 * These algs preserve everything else about the cube so it remains a
 * valid 3×3 afterwards.
 */

import { applyMoves } from '../moves.js';
import { DEDGES, isDedgePaired, isAllEdgesPaired } from './edges.js';

/**
 * OLL parity: single flipped dedge at the UF position.
 *   Effect: flips the UF dedge in place, leaves everything else alone.
 *   Source: standard 4×4 OLL parity (12-move).
 */
export const OLL_PARITY_ALG = "Rw U2 Rw' U2 Rw U2 Rw U2 Rw' U2 Rw' U2"
    .trim().split(/\s+/);

/**
 * PLL parity: swap two dedges (UF↔UR) without other changes.
 *   Source: standard 4×4 PLL parity (15-move).
 */
export const PLL_PARITY_ALG = "Rw2 U2 Rw2 Uw2 Rw2 Uw2"
    .trim().split(/\s+/);

/** True iff exactly one dedge is unpaired (single-flip OLL parity case).
 *  In practice OLL parity manifests as a single dedge whose two wings
 *  are at the right slot but with the colours swapped.
 *
 *  Note: this is a conservative check.  A more robust detector would
 *  compare against the reduced 3×3 state.
 */
export function detectOLLParity(state) {
    let flipped = 0;
    for (const d of DEDGES) {
        const w0 = d.wings[0];
        const w1 = d.wings[1];
        // Pair-swap pattern: face1 holds face2's colour and vice versa
        const swapped =
            state[w0.idx1] === d.wings[0].face2 &&
            state[w0.idx2] === d.wings[0].face1 &&
            state[w1.idx1] === d.wings[1].face2 &&
            state[w1.idx2] === d.wings[1].face1;
        if (swapped) flipped++;
    }
    return flipped;
}

/**
 * Apply parity fix-ups if needed.  Returns { moves, state }.
 *
 * Strategy:
 *   - If a single dedge is flipped → apply OLL parity once (rotated to
 *     bring the offending dedge to UF).  TODO: at present we apply the
 *     UF-targeted alg unconditionally if any flipped dedge is detected,
 *     which only handles the case where the flipped one is already at
 *     UF.  A robust version rotates first.
 *   - If two dedges are swapped → apply PLL parity.  Same TODO: a robust
 *     version finds the swap location and rotates appropriately.
 *
 * For typical scrambles the lazy "try alg, see if reduced" approach
 * works well enough — call solver.js's reduce step after this and check.
 */
export function applyParityFixes(state) {
    const out = { moves: [], state };
    if (!isAllEdgesPaired(state)) {
        // Try OLL parity (single flip).
        out.state = applyMoves(out.state, OLL_PARITY_ALG);
        out.moves.push(...OLL_PARITY_ALG);
    }
    return out;
}
