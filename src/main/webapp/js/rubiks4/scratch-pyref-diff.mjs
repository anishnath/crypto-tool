/**
 * Diff our applyMove against the Python reference solver's sticker trace.
 *
 *   1. (in another terminal)  python3 scratch-pyref.py > pyref-trace.json
 *   2.                        node   scratch-pyref-diff.mjs
 *
 * Reads pyref-trace.json (a list of {scramble, state} pairs computed by
 * rubikscubennnsolver/RubiksCube444), replays each scramble through our
 * applyMoves, and reports any 96-char string that doesn't match.  This is
 * the directional-correctness check our pure structural tests can't make.
 */

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

import { SOLVED_STATE } from './cube.js';
import { applyMoves } from './moves.js';

const __dirname = dirname(fileURLToPath(import.meta.url));
const TRACE_PATH = join(__dirname, 'pyref-trace.json');

const trace = JSON.parse(readFileSync(TRACE_PATH, 'utf8'));

let pass = 0;
let fail = 0;

for (const { scramble, state: expected } of trace.scrambles) {
    const got = applyMoves(SOLVED_STATE, scramble);
    if (got === expected) {
        pass++;
        continue;
    }
    fail++;
    console.error(`FAIL  scramble="${scramble}"`);
    // Highlight the first mismatched face for fast localisation.
    const FACE_NAMES = ['U', 'R', 'F', 'D', 'L', 'B'];
    for (let f = 0; f < 6; f++) {
        const lo = f * 16, hi = lo + 16;
        const a = expected.slice(lo, hi);
        const b = got.slice(lo, hi);
        if (a !== b) {
            console.error(`        ${FACE_NAMES[f]}-face`);
            console.error(`           expect: ${a}`);
            console.error(`           got   : ${b}`);
            // Per-position diff
            const marks = [];
            for (let i = 0; i < 16; i++) marks.push(a[i] === b[i] ? ' ' : '^');
            console.error(`           diff  : ${marks.join('')}`);
        }
    }
    if (fail >= 3) {
        console.error(`(stopping after ${fail} failures)`);
        break;
    }
}

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail === 0 ? 0 : 1);
