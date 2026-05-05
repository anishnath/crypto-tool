/**
 * Solver wrapper around cubejs.
 *
 * Loaded as ES module from esm.sh. cubejs's pruning-table init takes ~3s on
 * first call — we pay that cost once at module load (lazily, on the first
 * solve request) and then every solve() is sub-millisecond.
 *
 * v1 omits the worker + tightest-mode iterative tightening. The synchronous
 * solver runs on the main thread; for typical scrambles cubejs.solve()
 * returns in <50 ms, well below the perceptual-blocking threshold. Tighter
 * solving (down to God's number) is a planned follow-up that needs a worker
 * because individual cubejs.solve() calls at depth 20 can take seconds.
 */

import { canonicalizeOrientation } from './cube.js';

const CUBEJS_URL = 'https://esm.sh/cubejs@1.3.2';

let CubeCtor = null;
let initialized = false;
let initPromise = null;

export class UnsolvableCubeError extends Error {
    constructor() {
        super(
            "This cube state isn't reachable by twisting a real Rubik's cube — " +
            'the corners, edges, or centers are in a configuration no sequence ' +
            'of face rotations can produce. Click any sticker to fix it, or use ' +
            'Random scramble for a guaranteed-solvable state.',
        );
        this.name = 'UnsolvableCubeError';
    }
}

async function ensureCube() {
    if (CubeCtor) return CubeCtor;
    const mod = await import(/* @vite-ignore */ CUBEJS_URL);
    CubeCtor = mod.default || mod.Cube || mod;
    return CubeCtor;
}

/** Prepare cubejs's pruning tables. Idempotent + concurrent-safe. */
export function initSolver() {
    if (initialized) return Promise.resolve();
    if (initPromise) return initPromise;
    initPromise = (async () => {
        const C = await ensureCube();
        // Run in next microtask so the UI can show "initializing".
        await new Promise((r) => queueMicrotask(r));
        C.initSolver();
        initialized = true;
    })();
    return initPromise;
}

export function isSolverReady() {
    return initialized;
}

/** cubejs.solve(k) probes for k=1..4 catch the "1–4 moves from solved" case
 *  where the default solve() would otherwise return a 9–12 move sandwich. */
const SHORT_PROBE_MAX_K = 4;

function solveCanonical(canonical) {
    const C = CubeCtor;
    const cube = C.fromString(canonical);
    if (cube.asString() !== canonical) throw new UnsolvableCubeError();
    if (cube.isSolved()) return [];

    let algorithm = null;
    for (let k = 1; k <= SHORT_PROBE_MAX_K; k++) {
        try {
            algorithm = cube.solve(k);
            break;
        } catch (_) {
            // No ≤k-move solution exists at this exact bound; try the next.
        }
    }
    if (algorithm === null) algorithm = cube.solve();

    const verifyCube = C.fromString(canonical);
    if (algorithm.trim().length > 0) verifyCube.move(algorithm);
    if (!verifyCube.isSolved()) throw new UnsolvableCubeError();
    return algorithm.split(' ').filter(Boolean);
}

export async function solve(state) {
    await initSolver();
    return solveCanonical(canonicalizeOrientation(state));
}

// Sync utility re-exports — usable without going through the solver init.

export async function applyMoves(state, moves) {
    const C = await ensureCube();
    const cube = C.fromString(state);
    const algorithm = Array.isArray(moves) ? moves.join(' ') : moves;
    if (algorithm.trim().length > 0) cube.move(algorithm);
    return cube.asString();
}

export async function solvedState() {
    const C = await ensureCube();
    return new C().asString();
}

export async function isSolved(state) {
    const C = await ensureCube();
    return C.fromString(state).isSolved();
}

export async function randomState() {
    const C = await ensureCube();
    return C.random().asString();
}
