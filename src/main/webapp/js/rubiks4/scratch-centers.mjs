/**
 * Scratch test for the full centres solver (stages 1+2+3 + orchestrator).
 *
 *   node scratch-centers.mjs
 *
 * Builds all three pruning tables, then for several random scrambled cubes
 * runs solveCenters() and verifies:
 *   - each per-stage solve actually staged the relevant axis
 *   - the final state has all six faces monochromatic and matching their face label
 */

import { performance } from 'node:perf_hooks';
import { SOLVED_STATE } from './cube.js';
import { applyMoves, ALL_MOVES } from './moves.js';
import {
    initCenters,
    solveUDStage, isUDStageSolved,
    solveLRStage, isLRStageSolved,
    solveFineStage,
    solveCenters, isCentersSolved,
    udStateOf, lrStateOf, fineStateOf,
} from './solver/centers.js';

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

console.log('Building all three pruning tables…');
const t0 = performance.now();
const init = await initCenters();
const tInit = performance.now() - t0;
console.log(`  total init: ${tInit.toFixed(0)}ms`);
console.log(`  UD   : depth ${init.ud.depth}, ${init.ud.visited} states`);
console.log(`  LR   : depth ${init.lr.depth}, ${init.lr.visited} states`);
console.log(`  fine : depth ${init.fine.depth}, ${init.fine.visited} states`);

check('UD reachable count = 735471', init.ud.visited === 735471,
    `(got ${init.ud.visited})`);
check('LR reachable count = 12870',  init.lr.visited === 12870,
    `(got ${init.lr.visited})`);
// Stage 3 reachable count is implementation-determined; just record it.

console.log('\nSolving full centres from random scrambles…');
const SEEDS = [1, 7, 42, 1729, 8675309, 271828, 31415, 161803];
const totals = [];
const stage1Lengths = [];
const stage2Lengths = [];
const stage3Lengths = [];
const solveTimes = [];

for (const seed of SEEDS) {
    const seq = scramble(seed, 60);
    const scrambled = applyMoves(SOLVED_STATE, seq);

    const t1 = performance.now();
    // Stage by stage so we can inspect lengths and verify each stage
    const m1 = solveUDStage(scrambled);
    const s1 = applyMoves(scrambled, m1);
    check(`seed ${seed}: stage 1 stages UD`, isUDStageSolved(s1));

    const m2 = solveLRStage(s1);
    const s2 = applyMoves(s1, m2);
    check(`seed ${seed}: stage 2 stages LR (UD preserved)`,
        isLRStageSolved(s2) && isUDStageSolved(s2));

    const m3 = solveFineStage(s2);
    const s3 = applyMoves(s2, m3);
    check(`seed ${seed}: stage 3 fully solves centres`,
        isCentersSolved(s3) && isUDStageSolved(s3) && isLRStageSolved(s3));

    const tSolve = performance.now() - t1;
    const total = m1.length + m2.length + m3.length;
    totals.push(total);
    stage1Lengths.push(m1.length);
    stage2Lengths.push(m2.length);
    stage3Lengths.push(m3.length);
    solveTimes.push(tSolve);

    console.log(
        `  seed ${String(seed).padStart(8)}: ${m1.length}+${m2.length}+${m3.length}=${total} moves`
        + ` in ${tSolve.toFixed(2)}ms`
    );
}

const avg = (xs) => xs.reduce((a, b) => a + b, 0) / xs.length;
console.log(
    `\nAvg lengths — stage1: ${avg(stage1Lengths).toFixed(1)},`
    + ` stage2: ${avg(stage2Lengths).toFixed(1)},`
    + ` stage3: ${avg(stage3Lengths).toFixed(1)},`
    + ` total: ${avg(totals).toFixed(1)}  (max ${Math.max(...totals)})`
);
console.log(`Avg solve time (post-init): ${avg(solveTimes).toFixed(2)}ms`);

console.log('\nFull orchestrator round-trip…');
for (const seed of SEEDS) {
    const seq = scramble(seed, 60);
    const scrambled = applyMoves(SOLVED_STATE, seq);
    const { moves, state: solved } = solveCenters(scrambled);
    check(`seed ${seed}: solveCenters() result is fully solved`,
        isCentersSolved(solved),
        `(${moves.length} moves)`);
    check(`seed ${seed}: applyMoves(scrambled, moves) reproduces result`,
        applyMoves(scrambled, moves) === solved);
}

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail === 0 ? 0 : 1);
