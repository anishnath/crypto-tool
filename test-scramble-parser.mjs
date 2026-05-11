/**
 * Scramble parser + WCA-notation regression tests.
 *
 * Run with:  node test-scramble-parser.mjs
 *
 * Covers two sources of correctness:
 *   1. The scramble normalizer + tokenizer in
 *      src/main/webapp/js/rubiks-nxn/app.js — verified against pasted
 *      strings cubers commonly produce (commas, smart quotes, lowercase
 *      shorthand, smushed input, etc.).
 *   2. The WCA-compliant move engine in
 *      src/main/webapp/js/rubiks-nxn/moves-builder.js — verified by
 *      round-tripping every alphabet entry: X then X' returns to solved,
 *      and X four times returns to solved.
 *
 * Keep this file at the repo root (NOT in /tmp) so it stays around for
 * future regression checks.  Add new test cases here whenever a parser
 * bug is reported or a new notation form is added.
 */

import { buildMoveSet } from './src/main/webapp/js/rubiks-nxn/moves-builder.js';

// ── 1. Scramble normalizer + tokenizer ────────────────────────────────
// Mirror of normalizeScrambleInput / tokenizeScramble in app.js.
// (app.js lives inside an IIFE so the helpers aren't importable directly.)

function normalizeScrambleInput(raw) {
    let s = raw;
    s = s.replace(/[‘’‚‛′‵´`]/g, "'");
    s = s.replace(/[‐-―−]/g, '-');
    s = s.replace(/\b\d+[\.\)\:]\s*/g, ' ');
    s = s.replace(/[,;\.\:·•…\[\]\(\)\{\}<>|\/\\\!@#\$%\^&\*=\+~\?"\-]/g, ' ');
    s = s.replace(/\s+/g, ' ').trim();
    s = s.replace(/([urfdlb])w?/g, (_, c) => c.toUpperCase() + 'w');
    s = s.replace(/'2/g, '2').replace(/2'/g, '2');
    s = s.replace(/''/g, '');
    return s.trim();
}

const TOKEN_RE = /\d[URFDLB]w['2]?|\d[URFDLB]['2]?|[URFDLB]w?['2]?|[MES]['2]?|[xyz]['2]?/g;

function tokenize(raw) {
    const clean = normalizeScrambleInput(raw);
    if (clean.length === 0) return { error: 'empty', clean };
    const chunks = clean.split(/\s+/).filter(Boolean);
    const tokens = [];
    for (const chunk of chunks) {
        let cursor = 0, m;
        TOKEN_RE.lastIndex = 0;
        while (cursor < chunk.length && (m = TOKEN_RE.exec(chunk)) !== null) {
            if (m.index !== cursor) return { clean, error: `unexpected '${chunk[cursor]}' in '${chunk}'` };
            tokens.push(m[0]);
            cursor = TOKEN_RE.lastIndex;
        }
        if (cursor !== chunk.length) return { clean, error: `unexpected '${chunk[cursor]}' in '${chunk}'` };
    }
    return { clean, tokens };
}

const PARSER_CASES = [
    [`R, U, R', U2`,                 ['R','U',"R'",'U2'],          'comma-separated'],
    [`R—U—R' U R'`,                  ['R','U',"R'",'U',"R'"],       'em-dash'],
    [`R’ U' R'' U2 R’`,              ["R'","U'",'R','U2',"R'"],     'unicode prime + double prime'],
    [`R'2 U2' R2'`,                  ['R2','U2','R2'],              'reversed modifier order'],
    [`1. R 2. U 3. R'`,              ['R','U',"R'"],                'numbered list'],
    [`1) R 2) U 3) R'`,              ['R','U',"R'"],                'numbered with parens'],
    [`R u r' f2 lw`,                 ['R','Uw',"Rw'",'Fw2','Lw'],   'lowercase wide shorthand'],
    [`[R U R'] (U R' U R U2 R')`,    ['R','U',"R'",'U',"R'",'U','R','U2',"R'"], 'brackets'],
    [`R U R'`,             ['R','U',"R'"],                'non-breaking spaces'],
    [`RUR'U'F2D'`,                   ['R','U',"R'","U'",'F2',"D'"], 'no spaces (smushed)'],
    [`Rw Uw' 3Rw 2L 3R`,             ['Rw',"Uw'",'3Rw','2L','3R'], 'mixed wide + inner (spaced)'],
    [`3Rw 2L`,                       ['3Rw','2L'],                  'disambig: 3Rw + 2L (not 3Rw2 L)'],
    [`R...U...R'`,                   ['R','U',"R'"],                'ellipsis'],
    [`R; U; R'`,                     ['R','U',"R'"],                'semicolons'],
    // WCA-compliance gap closures:
    [`2Rw 4Rw 2Lw2`,                 ['2Rw','4Rw','2Lw2'],          'explicit-prefix wide turns'],
    [`x y z x' y2 z'`,               ['x','y','z',"x'",'y2',"z'"],  'cube rotations'],
    [`x R U R' x'`,                  ['x','R','U',"R'","x'"],       'rotation interleaved'],
    [`R2Uw3Rw'`,                     ['R2','Uw',"3Rw'"],            'smushed wide-n'],
];

let pass = 0, fail = 0;
console.log('── Parser tests ─────────────────────────────────');
for (const [input, expected, label] of PARSER_CASES) {
    const r = tokenize(input);
    const actual = r.tokens || `ERROR: ${r.error}`;
    const ok = Array.isArray(actual)
        && actual.length === expected.length
        && actual.every((t, i) => t === expected[i]);
    if (ok) {
        pass++;
        console.log(`  ✓ ${label.padEnd(36)} ${actual.join(' ')}`);
    } else {
        fail++;
        console.log(`  ✗ ${label}`);
        console.log(`      expected: ${JSON.stringify(expected)}`);
        console.log(`      actual:   ${JSON.stringify(actual)}`);
    }
}

// ── 2. Move-engine round-trip + alphabet coverage ─────────────────────

console.log('\n── Move engine WCA coverage ─────────────────────');
function solvedState(N) {
    return 'U'.repeat(N*N) + 'R'.repeat(N*N) + 'F'.repeat(N*N)
         + 'D'.repeat(N*N) + 'L'.repeat(N*N) + 'B'.repeat(N*N);
}

for (const N of [3, 4, 5, 6, 7, 8, 9, 10]) {
    const ms = buildMoveSet(N);
    const solved = solvedState(N);

    // Pick a representative subset to round-trip per N.
    const probes = ['R', "R'", 'R2', 'Rw', "Rw'", 'Rw2', 'x', "y'", 'z2'];
    if (N >= 4) probes.push('2Rw', "2Rw'", '2Rw2');
    if (N >= 5) probes.push('3Rw', "3Rw'", '3Rw2', '4Rw');
    if (N >= 6) probes.push('5Rw');
    if (N >= 7) probes.push('6Rw');
    if (N >= 8) probes.push('7Rw');
    if (N >= 9) probes.push('8Rw', '5R', '5L');
    if (N >= 10) probes.push('9Rw');
    probes.push('2R', '2L');
    if (N >= 5) probes.push('3R', '3L');
    if (N >= 7) probes.push('4R', '4L');
    // 3×3 middle slices and lowercase wide aliases were added so the
    // cubing-guide page can compute "after" states for any algorithm
    // it shows.  Verify both work for N=3.
    if (N === 3) probes.push('M', "M'", 'M2', 'E', "E'", 'S', 'S2');
    probes.push('r', "r'", 'r2', 'u', 'f');

    const invert = (mv) =>
        mv.endsWith("'") ? mv.slice(0, -1)
      : mv.endsWith('2') ? mv
      : mv + "'";

    let nFail = 0;
    for (const mv of probes) {
        if (!ms.permFor(mv)) { console.log(`  ✗ N=${N} ${mv}: perm missing`); nFail++; continue; }
        const after2 = ms.applyMoves(solved, [mv, invert(mv)]);
        const after4 = ms.applyMoves(solved, [mv, mv, mv, mv]);
        if (after2 !== solved) { console.log(`  ✗ N=${N} ${mv}: X·X' ≠ identity`); nFail++; }
        if (after4 !== solved) { console.log(`  ✗ N=${N} ${mv}: X^4 ≠ identity`); nFail++; }
    }
    if (nFail === 0) {
        console.log(`  ✓ N=${N}: ${probes.length} probes all round-trip`);
        pass++;
    } else {
        fail += nFail;
    }
}

// ── 3. Equivalence checks: 2Rw == Rw, 3R == 3L' on odd N ──────────────

console.log('\n── Equivalence checks ────────────────────────────');
const EQ_CASES = [
    [4, '2Rw', 'Rw',   'WCA: explicit-prefix wide-2 == default wide'],
    [5, '2Uw', 'Uw',   'WCA: explicit-prefix wide-2 == default wide (5x5)'],
    [5, '3R',  "3L'",  'SiGN: middle layer reachable from either side'],
    [5, '3U',  "3D'",  'SiGN: middle layer reachable from either side (Y)'],
    [7, '4R',  "4L'",  'SiGN: middle layer reachable from either side (7x7)'],
];
for (const [N, a, b, label] of EQ_CASES) {
    const ms = buildMoveSet(N);
    const solved = solvedState(N);
    const sa = ms.applyMoves(solved, [a]);
    const sb = ms.applyMoves(solved, [b]);
    if (sa === sb) { pass++; console.log(`  ✓ N=${N} ${a} ≡ ${b}  (${label})`); }
    else { fail++; console.log(`  ✗ N=${N} ${a} ≠ ${b}  (${label})`); }
}

// ── 4. Cube-rotation correctness ──────────────────────────────────────
// x rotation matches R-direction.  Verified empirically on this code-
// base: R cycles stickers U → B → D → F → U (this is correct WCA: when
// you stand on the +X side and look at R-face, "up" goes "right", and
// "right from that vantage" = back of cube).  So x must do the same
// globally: after one x, every face that previously held color C now
// holds the color from the face that cycles INTO it.
//   New U = old F  (F → U)
//   New F = old D  (D → F)
//   New D = old B  (B → D)
//   New B = old U  (U → B)
// moves-builder isn't used on 3×3 (cubejs handles that), so probe N ≥ 4.
console.log('\n── Cube rotation (x) sticker cycling ────────────');
for (const N of [4, 5, 6, 7, 8, 9, 10]) {
    const ms = buildMoveSet(N);
    const solved = solvedState(N);
    const after = ms.applyMoves(solved, ['x']);
    const FF = N * N;
    const newU = after.slice(0, FF);
    const newF = after.slice(2 * FF, 3 * FF);
    const newD = after.slice(3 * FF, 4 * FF);
    const newB = after.slice(5 * FF, 6 * FF);
    const ok = newU.split('').every(c => c === 'F')
            && newF.split('').every(c => c === 'D')
            && newD.split('').every(c => c === 'B')
            && newB.split('').every(c => c === 'U');
    if (ok) { pass++; console.log(`  ✓ N=${N} x cycles U←F←D←B←U`); }
    else { fail++; console.log(`  ✗ N=${N} x cycle wrong: U=${newU.slice(0,5)}… F=${newF.slice(0,5)}…`); }
}

// And the L and R faces should still be all-L and all-R after x (they
// stay in place; only their orientation changes).
console.log('\n── Cube rotation (x) preserves R/L sticker counts ─');
for (const N of [4, 5, 6, 7, 8, 9, 10]) {
    const ms = buildMoveSet(N);
    const solved = solvedState(N);
    const after = ms.applyMoves(solved, ['x']);
    const FF = N * N;
    const newR = after.slice(1 * FF, 2 * FF);
    const newL = after.slice(4 * FF, 5 * FF);
    const ok = newR.split('').every(c => c === 'R') && newL.split('').every(c => c === 'L');
    if (ok) { pass++; console.log(`  ✓ N=${N} x preserves R-face=R, L-face=L`); }
    else { fail++; console.log(`  ✗ N=${N} x leaks colors onto R/L: R=${newR.slice(0,4)} L=${newL.slice(0,4)}`); }
}

// ── 5. Per-size adapter fallback (rubiks4/5 + moves-builder) ──────────
// rubiks4/moves.js and rubiks5/moves.js are hand-rolled and have their
// own MOVE_RE that doesn't accept "2Rw" / "x" / etc.  They now fall
// back to moves-builder for those.  Verify the fallback fires.

console.log('\n── Per-size adapter fallback (rubiks4/5) ─────────');
const r4 = await import('./src/main/webapp/js/rubiks4/moves.js');
const r5 = await import('./src/main/webapp/js/rubiks5/moves.js');

for (const [name, mod, N] of [['rubiks4', r4, 4], ['rubiks5', r5, 5]]) {
    const solved = solvedState(N);
    let nFail = 0;
    // These all hit the MOVES_BUILDER fallback path (legacy regex rejects them):
    const fallbacks = ['2Rw', '2Rw2', "2Rw'", '2R', "2L'", 'x', "y'", 'z2'];
    if (N === 5) fallbacks.push('3R', '3U', "3R'");
    for (const mv of fallbacks) {
        const inv = mv.endsWith("'") ? mv.slice(0, -1)
                  : mv.endsWith('2') ? mv : mv + "'";
        try {
            const after2 = mod.applyMoves(solved, [mv, inv]);
            const after4 = mod.applyMoves(solved, [mv, mv, mv, mv]);
            if (after2 !== solved || after4 !== solved) {
                console.log(`  ✗ ${name} ${mv}: round-trip mismatch`);
                nFail++;
            }
        } catch (e) {
            console.log(`  ✗ ${name} ${mv}: threw ${e.message}`);
            nFail++;
        }
    }
    if (nFail === 0) {
        pass++;
        console.log(`  ✓ ${name}: ${fallbacks.length} fallback moves all round-trip`);
    } else {
        fail += nFail;
    }
}

// ── 6. cubejs normalization (3×3 only) ────────────────────────────────
// cubejs accepts: outer URFDLB, lowercase wide (u r f d l b), M/E/S, x/y/z.
// It REJECTS: Rw, 2Rw, 2R.  Our 3×3 adapter must normalize before
// passing through.  Verify the mapping table is right.
console.log('\n── cubejs normalization (3×3) ────────────────────');
const CUBEJS_SLICE_MAP = {
    '2R':  "M'",  "2R'": 'M',   '2R2': 'M2',
    '2L':  'M',   "2L'": "M'",  '2L2': 'M2',
    '2U':  "E'",  "2U'": 'E',   '2U2': 'E2',
    '2D':  'E',   "2D'": "E'",  '2D2': 'E2',
    '2F':  'S',   "2F'": "S'",  '2F2': 'S2',
    '2B':  "S'",  "2B'": 'S',   '2B2': 'S2',
};
function cubejsNormalize(moves) {
    const arr = Array.isArray(moves) ? moves : [moves];
    return arr.map(m => {
        if (CUBEJS_SLICE_MAP[m]) return CUBEJS_SLICE_MAP[m];
        let s = m.replace(/^2([URFDLB]w(?:['2])?)$/, '$1');
        s = s.replace(/^([URFDLB])w/, (_, f) => f.toLowerCase());
        return s;
    });
}
const NORM_CASES = [
    ['Rw',     'r'],
    ['Rw2',    'r2'],
    ["Rw'",    "r'"],
    ['2Rw',    'r'],
    ['2Rw2',   'r2'],
    ["2Rw'",   "r'"],
    ['Uw',     'u'],
    ['Fw2',    'f2'],
    ['2R',     "M'"],
    ["2R'",    'M'],
    ['2L',     'M'],
    ['2U',     "E'"],
    ['R',      'R'],     // outer unchanged
    ['M',      'M'],     // already cubejs-valid
    ['x',      'x'],
];
for (const [input, expected] of NORM_CASES) {
    const got = cubejsNormalize([input])[0];
    if (got === expected) {
        pass++;
        console.log(`  ✓ ${input.padEnd(6)} → ${got}`);
    } else {
        fail++;
        console.log(`  ✗ ${input.padEnd(6)} → ${got}  (expected ${expected})`);
    }
}

console.log(`\n── Summary: ${pass} pass, ${fail} fail ──────────`);
process.exit(fail === 0 ? 0 : 1);
