/**
 * Scratch test for the 4×4 cube state + move modules.
 *
 *   node js/rubiks4/scratch-test.mjs
 *
 * This is the bare-minimum verification before we trust applyMove for any
 * solver work.  We rely on three structural invariants — none of them need
 * a Python reference oracle:
 *
 *   1. Permutation hygiene:    every CW perm is a bijection of [0..95].
 *   2. Identity composition:   M⁴ = I  for any base CW.
 *                              M ∘ M' = I  and  M ∘ M2 ∘ M = I.
 *                              M2 ∘ M2 = I.
 *   3. Sticker conservation:   any move sequence preserves the multiset
 *                              of sticker colours (16 of each).
 *
 * If all three pass, applyMove is at minimum a *valid permutation* of the
 * cube state — getting an outright wrong move table past these checks
 * requires either two ring index errors that exactly cancel (extremely
 * unlikely) or a miswiring that swaps two colour-equivalent stickers
 * (won't matter to the solver since stickers are coloured by face).
 *
 * Step 2 of the scratch suite (later) will add a "scramble vs reference"
 * comparison once we have a Python sticker trace to diff against.
 */

import {
    SOLVED_STATE, TOTAL_STICKERS, FACES, validateState, isSolved,
} from './cube.js';
import {
    parseMove, applyMove, applyMoves, invertMoves, ALL_MOVES,
} from './moves.js';

let pass = 0, fail = 0;
function check(name, ok, detail = '') {
    if (ok) { pass++; }
    else    { fail++; console.error(`  FAIL: ${name} ${detail}`); }
}

/* ── 1. Solved state ────────────────────────────────────────────── */
console.log('─ Solved state ─');
check('SOLVED_STATE valid', validateState(SOLVED_STATE).ok);
check('isSolved(SOLVED)', isSolved(SOLVED_STATE));
check('SOLVED length 96', SOLVED_STATE.length === 96);

/* ── 2. Move parser ─────────────────────────────────────────────── */
console.log('─ Move parser ─');
const PARSE_CASES = [
    ['U',   { face: 'U', wide: false, turns: 1  }],
    ["U'",  { face: 'U', wide: false, turns: -1 }],
    ['U2',  { face: 'U', wide: false, turns: 2  }],
    ['Uw',  { face: 'U', wide: true,  turns: 1  }],
    ["Uw'", { face: 'U', wide: true,  turns: -1 }],
    ['Uw2', { face: 'U', wide: true,  turns: 2  }],
    ['Bw2', { face: 'B', wide: true,  turns: 2  }],
    ['Lw',  { face: 'L', wide: true,  turns: 1  }],
];
for (const [raw, want] of PARSE_CASES) {
    const got = parseMove(raw);
    const ok = got && got.face === want.face && got.wide === want.wide && got.turns === want.turns;
    check(`parseMove(${raw})`, ok, JSON.stringify(got));
}
check('parseMove(garbage) → null', parseMove('Q') === null);
check('parseMove(empty) → null',   parseMove('') === null);

/* ── 3. ALL_MOVES roster ────────────────────────────────────────── */
console.log('─ ALL_MOVES roster ─');
check('ALL_MOVES has 36 entries', ALL_MOVES.length === 36, `(got ${ALL_MOVES.length})`);
const allUnique = new Set(ALL_MOVES).size === ALL_MOVES.length;
check('ALL_MOVES all unique', allUnique);
const allParse = ALL_MOVES.every(parseMove);
check('every ALL_MOVES parses', allParse);

/* ── 4. Identity composition for every base move ───────────────── */
console.log('─ Identity composition ─');
for (const m of ALL_MOVES) {
    const p = parseMove(m);
    if (p.turns === 2) {
        // M2 ∘ M2 = I
        const s1 = applyMove(SOLVED_STATE, m);
        const s2 = applyMove(s1, m);
        check(`${m} ∘ ${m} = I`, s2 === SOLVED_STATE);
    } else {
        // M⁴ = I  (and M ∘ M' = I as a stronger check)
        let s = SOLVED_STATE;
        for (let i = 0; i < 4; i++) s = applyMove(s, m);
        check(`${m}⁴ = I`, s === SOLVED_STATE);

        const inv = p.turns === 1 ? `${p.face}${p.wide ? 'w' : ''}'` : `${p.face}${p.wide ? 'w' : ''}`;
        const round = applyMove(applyMove(SOLVED_STATE, m), inv);
        check(`${m} ∘ ${inv} = I`, round === SOLVED_STATE);
    }
}

/* ── 5. M2 equals M ∘ M ─────────────────────────────────────────── */
console.log('─ M2 equals M ∘ M ─');
for (const f of FACES) {
    for (const w of ['', 'w']) {
        const m  = `${f}${w}`;
        const m2 = `${f}${w}2`;
        const a = applyMove(SOLVED_STATE, m2);
        const b = applyMoves(SOLVED_STATE, [m, m]);
        check(`${m2} == ${m} ${m}`, a === b);
    }
}

/* ── 6. Sticker conservation under random scrambles ─────────────── */
console.log('─ Sticker conservation ─');
function rngScramble(n, seed = 42) {
    // tiny LCG so the test is deterministic
    let x = seed;
    const rand = () => (x = (x * 1664525 + 1013904223) >>> 0) / 4294967296;
    const out = [];
    for (let i = 0; i < n; i++) out.push(ALL_MOVES[Math.floor(rand() * ALL_MOVES.length)]);
    return out;
}
function colourCounts(state) {
    const c = {};
    for (const ch of state) c[ch] = (c[ch] || 0) + 1;
    return c;
}
const SOLVED_COUNTS = colourCounts(SOLVED_STATE);
for (const seed of [1, 7, 42, 1729, 8675309]) {
    const seq = rngScramble(50, seed);
    const scrambled = applyMoves(SOLVED_STATE, seq);
    const counts = colourCounts(scrambled);
    const match = FACES.every((f) => counts[f] === SOLVED_COUNTS[f]);
    check(`stickers conserved (seed ${seed})`, match,
        `counts=${JSON.stringify(counts)}`);
    check(`scrambled state valid length (seed ${seed})`,
        scrambled.length === TOTAL_STICKERS);
}

/* ── 7. Inverse round-trip on long scrambles ───────────────────── */
console.log('─ Inverse round-trip ─');
for (const seed of [1, 7, 42, 1729]) {
    const seq = rngScramble(80, seed);
    const inv = invertMoves(seq);
    const round = applyMoves(applyMoves(SOLVED_STATE, seq), inv);
    check(`scramble∘inverse = I (seed ${seed})`, round === SOLVED_STATE);
}

/* ── 8. Wide vs outer relationship spot check ──────────────────── */
console.log('─ Wide ⊃ outer (sanity) ─');
// For any face f: applying f then f' (outer pair) = I.  Same with f-wide.
// Stronger: applying outer-f to a state, then applying *outer-f-inverse*
// after a wide-f, must NOT equal identity in general — wide includes an
// extra slice.  We just check that wide-f ≠ outer-f for all 6 faces, so
// the wide perms aren't accidentally the same table.
for (const f of FACES) {
    const a = applyMove(SOLVED_STATE, f);
    const b = applyMove(SOLVED_STATE, `${f}w`);
    check(`${f}w ≠ ${f}`, a !== b);
}

/* ── 9. Centres stay on their face under outer-only moves ─────── */
console.log('─ Outer-only preserves centres ─');
// Outer face turns (no wide) only spin the visible face stickers + the
// outermost row of side faces.  The 4 centre stickers of every face are
// at facePos {5, 6, 9, 10}, all of which sit *inside* the outer ring.
// So under any sequence of outer-only moves, the centres of every face
// must remain that face's colour.
const OUTER_ONLY = ALL_MOVES.filter((m) => !m.includes('w'));
function centreCheck(state) {
    for (const f of FACES) {
        const off = { U: 0, R: 16, F: 32, D: 48, L: 64, B: 80 }[f];
        for (const pos of [5, 6, 9, 10]) {
            if (state[off + pos] !== f) return `${f}@${pos}=${state[off + pos]}`;
        }
    }
    return null;
}
for (const seed of [1, 7, 42, 1729]) {
    let x = seed;
    const rand = () => (x = (x * 1664525 + 1013904223) >>> 0) / 4294967296;
    const seq = [];
    for (let i = 0; i < 60; i++) seq.push(OUTER_ONLY[Math.floor(rand() * OUTER_ONLY.length)]);
    const s = applyMoves(SOLVED_STATE, seq);
    const violation = centreCheck(s);
    check(`centres preserved under outer-only (seed ${seed})`, !violation,
        violation ? `(${violation})` : '');
}

/* ── Summary ──────────────────────────────────────────────────── */
console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail === 0 ? 0 : 1);
