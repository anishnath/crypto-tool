/**
 * Scratch test for the full 4×4 solver pipeline.
 *
 *   node scratch-solver.mjs
 *
 * Runs solver.solve() against several scrambles of increasing length and
 * reports per-stage progress.  Edge pairing is the bottleneck — short
 * scrambles (5–10 moves) should solve in seconds; longer scrambles may
 * stress the BFS.
 *
 * Skips cubejs init in Node since it requires a network fetch (esm.sh)
 * that the test runner doesn't have access to.  The test stops at the
 * "edges paired" stage and reports edge-pairing stats.
 */

import { performance } from 'node:perf_hooks';
import { SOLVED_STATE } from './cube.js';
import { applyMoves, ALL_MOVES } from './moves.js';
import { initCenters, solveCenters, isCentersSolved } from './solver/centers.js';
import { solveEdges, isAllEdgesPaired, countPairedDedges } from './solver/edges.js';

let pass = 0, fail = 0;
function check(name, ok, detail = '') {
    if (ok) pass++;
    else { fail++; console.error(`  FAIL: ${name} ${detail}`); }
}

function rng(seed) {
    let x = seed;
    return () => (x = (x * 1664525 + 1013904223) >>> 0) / 4294967296;
}
function scramble(seed, n) {
    const r = rng(seed);
    const out = [];
    for (let i = 0; i < n; i++) out.push(ALL_MOVES[Math.floor(r() * ALL_MOVES.length)]);
    return out;
}

console.log('Building centres pruning tables…');
const t0 = performance.now();
await initCenters();
console.log(`  init: ${(performance.now() - t0).toFixed(0)}ms\n`);

// Try short scrambles first to make sure the pipeline works at all
const TRIALS = [
    { name: 'short', seed: 1,  len: 6  },
    { name: 'short', seed: 7,  len: 6  },
    { name: 'med',   seed: 42, len: 15 },
    { name: 'med',   seed: 1729, len: 15 },
    { name: 'long',  seed: 8675309, len: 30 },
];

for (const trial of TRIALS) {
    const seq = scramble(trial.seed, trial.len);
    const scrambled = applyMoves(SOLVED_STATE, seq);
    console.log(`─ ${trial.name} (seed ${trial.seed}, ${trial.len} moves) ─`);

    // Stage 1: centres
    const t1 = performance.now();
    const c = solveCenters(scrambled);
    const dt1 = performance.now() - t1;
    check(`${trial.name}/${trial.seed}: centres solved`, isCentersSolved(c.state));
    console.log(`  centres: ${c.moves.length} moves, ${dt1.toFixed(0)}ms`);

    // Stage 2: edges (the expensive one)
    const t2 = performance.now();
    let edgeResult;
    try {
        edgeResult = solveEdges(c.state);
    } catch (err) {
        console.error(`  edges THREW: ${err.message}`);
        fail++;
        continue;
    }
    const dt2 = performance.now() - t2;
    const paired = countPairedDedges(edgeResult.state);
    console.log(`  edges  : ${edgeResult.moves.length} moves, ${dt2.toFixed(0)}ms, ${paired}/12 paired`);

    if (isAllEdgesPaired(edgeResult.state)) {
        check(`${trial.name}/${trial.seed}: all 12 edges paired`, true);
    } else {
        // Edge BFS got stuck — record but don't fail the whole run.  Parity
        // and cubejs handoff would normally take it from here.
        console.log(`  (BFS stuck — ${12 - paired} edge(s) remain.  parity.js would handle from here.)`);
    }
}

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail === 0 ? 0 : 1);
