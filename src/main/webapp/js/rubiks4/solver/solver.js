/**
 * 4×4 solver orchestrator.
 *
 * Pipeline:
 *   1. Solve centres (centers.js — three staged BFS).
 *   2. Pair edges (edges.js — per-edge BFS).
 *   3. Apply parity fix-ups if needed (parity.js).
 *   4. Reduce to a 3×3 representation, hand off to cubejs (the existing
 *      js/rubiks/solver.js).
 *   5. Translate the 3×3 solution moves back to 4×4 outer-only moves.
 *
 * Init cost: ~1–3 s for centres pruning tables + cubejs warm-up.
 * Solve cost: variable — centres + parity are sub-millisecond after init,
 * but edges BFS can take 5–60 s on hard scrambles.
 */

import { FACES, FACE_INDEX_OFFSETS, SOLVED_STATE } from '../cube.js';
import { applyMoves } from '../moves.js';
import { initCenters, solveCenters, isCentersSolved } from './centers.js';
import { solveEdges, isAllEdgesPaired } from './edges.js';
import { applyParityFixes } from './parity.js';

// Re-use the 3×3 cubejs solver from the existing rubiks/ module.
import { initSolver as initCubejs, solve as cubejsSolve } from '../../rubiks/solver.js';

/* ─────────────────────────────────────────────────────────────────────
 *  Init
 * ──────────────────────────────────────────────────────────────────── */

export async function initSolver() {
    await Promise.all([initCenters(), initCubejs()]);
}

/* ─────────────────────────────────────────────────────────────────────
 *  4×4 → 3×3 reduction
 *
 *  Once centres are solved and edges paired, the 4×4 visually matches
 *  a 3×3.  We extract a 54-character 3×3 state by sampling representative
 *  stickers from each 4×4 face:
 *
 *     3×3 position 0 (corner)   ← 4×4 position 0
 *     3×3 position 1 (edge)     ← 4×4 position 1   (one of two wings — should match its partner at position 2)
 *     3×3 position 2 (corner)   ← 4×4 position 3
 *     3×3 position 3 (edge)     ← 4×4 position 4   (one wing of the L-edge)
 *     3×3 position 4 (centre)   ← 4×4 position 5   (any of the 4 inner stickers — they're monochromatic post-centres)
 *     3×3 position 5 (edge)     ← 4×4 position 7   (one wing of the R-edge)
 *     3×3 position 6 (corner)   ← 4×4 position 12
 *     3×3 position 7 (edge)     ← 4×4 position 13
 *     3×3 position 8 (corner)   ← 4×4 position 15
 *
 *  This sampling gives 54 chars in URFDLB face order — exactly what
 *  cubejs.fromString() expects.
 * ──────────────────────────────────────────────────────────────────── */

const REDUCE_SAMPLE_POSITIONS = [0, 1, 3, 4, 5, 7, 12, 13, 15];

export function reduceTo3x3(state4) {
    if (state4.length !== 96) {
        throw new Error(`expected 96-char 4×4 state, got ${state4.length}`);
    }
    let out = '';
    for (const f of FACES) {
        const off = FACE_INDEX_OFFSETS[f];
        for (const p of REDUCE_SAMPLE_POSITIONS) {
            out += state4[off + p];
        }
    }
    return out;
}

/** Translate a cubejs 3×3 solution string ("R U R' U' …") into a
 *  4×4-compatible move array.  Since 3×3 moves are a subset of our
 *  4×4 outer moves, this is just a tokenize. */
function translate3x3MovesTo4x4(soln3) {
    if (!soln3 || soln3.trim().length === 0) return [];
    return soln3.trim().split(/\s+/);
}

/* ─────────────────────────────────────────────────────────────────────
 *  solve()
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Solve a scrambled 4×4.  Returns { moves, stages, finalState }.
 *
 *   moves      – flat list of 4×4 moves to apply to `state` to fully solve
 *   stages     – per-stage breakdown for diagnostics
 *   finalState – state after applying every move (should equal SOLVED_STATE)
 */
export async function solve(state) {
    const stages = {};

    // ── Centres ────────────────────────────────
    const centres = solveCenters(state);
    stages.centres = { moves: centres.moves };
    let s = centres.state;
    if (!isCentersSolved(s)) throw new Error('centres stage failed to solve');

    // ── Edges ─────────────────────────────────
    const edges = solveEdges(s);
    stages.edges = { moves: edges.moves, stuck: edges.unpaired };
    s = edges.state;

    // ── Parity (best-effort) ───────────────────
    let parityMoves = [];
    if (!isAllEdgesPaired(s)) {
        const p = applyParityFixes(s);
        parityMoves = p.moves;
        s = p.state;
        stages.parity = { moves: parityMoves, succeeded: isAllEdgesPaired(s) };
        if (!isAllEdgesPaired(s)) {
            throw new Error(
                'edges still unpaired after parity fix-ups — '
                + 'this 4×4 needs a scramble-specific parity sequence we don\'t implement yet'
            );
        }
    } else {
        stages.parity = { moves: [], succeeded: true };
    }

    // ── 3×3 reduction + cubejs ─────────────────
    const state3 = reduceTo3x3(s);
    const cubejsResult = await cubejsSolve(state3);
    const reduceMoves = translate3x3MovesTo4x4(cubejsResult.solution);
    stages.reduce = { state3, moves: reduceMoves };
    s = applyMoves(s, reduceMoves);

    if (s !== SOLVED_STATE) {
        throw new Error(
            'final state is not SOLVED_STATE — likely a parity issue or '
            + 'a sticker-orientation bug in the reduction sampling'
        );
    }

    const moves = [
        ...centres.moves,
        ...edges.moves,
        ...parityMoves,
        ...reduceMoves,
    ];
    return { moves, stages, finalState: s };
}
