/**
 * Generic move-set builder — produces { ALL_MOVES, permFor, applyMove,
 * applyMoves } for a cube of any size N.
 *
 * This factories the per-cube-size move tables: same ring formulas the
 * Java {@code Cube{N}{N}{N}Moves} files use, derived programmatically
 * instead of hand-typed.  Used by {@code js/rubiks5/moves.js},
 * {@code js/rubiks6/moves.js}, {@code js/rubiks7/moves.js}, etc.
 *
 * Move alphabet:  6 faces × {outer, wide} × { '', "'", '2' } = 36 moves.
 * Slice / 3-layer wide notation (e.g. {@code 3Uw}) is intentionally
 * not supported — the upstream API doesn't need it for solving.
 */

const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];

/** Ring formula derivation, valid for any N≥3.  layer k=0 is the outermost
 *  slice, k=1 is the next inward, etc.  Returns 4N indices: 4 segments of
 *  N stickers each, in CW order around the rotated face viewed from outside. */
function ringIndicesForFace(face, layer, N, faceOffsets) {
    const k = layer;
    const M = N;
    const off = (f) => faceOffsets[f];
    const ring = [];
    const seg = (f, indices) => indices.forEach(i => ring.push(off(f) + i));

    switch (face) {
        case 'U':
            // Top edge: F-row-k → L-row-k → B-row-k → R-row-k.
            seg('F', range(k * M, k * M + M));
            seg('L', range(k * M, k * M + M));
            seg('B', range(k * M, k * M + M));
            seg('R', range(k * M, k * M + M));
            break;

        case 'D':
            // Bottom edge: F-row-(N-1-k) → R → B → L.
            seg('F', range((M - 1 - k) * M, (M - 1 - k) * M + M));
            seg('R', range((M - 1 - k) * M, (M - 1 - k) * M + M));
            seg('B', range((M - 1 - k) * M, (M - 1 - k) * M + M));
            seg('L', range((M - 1 - k) * M, (M - 1 - k) * M + M));
            break;

        case 'R':
            // Right edge: U-col-(N-1-k) → B-col-k-rev → D-col-(N-1-k) → F-col-(N-1-k).
            seg('U', col(M, M - 1 - k));
            seg('B', colRev(M, k));
            seg('D', col(M, M - 1 - k));
            seg('F', col(M, M - 1 - k));
            break;

        case 'L':
            // Left edge: U-col-k → F-col-k → D-col-k → B-col-(N-1-k)-rev.
            seg('U', col(M, k));
            seg('F', col(M, k));
            seg('D', col(M, k));
            seg('B', colRev(M, M - 1 - k));
            break;

        case 'F':
            // Front edge: U-row-(N-1-k) → R-col-k → D-row-k-rev → L-col-(N-1-k)-rev.
            seg('U', range((M - 1 - k) * M, (M - 1 - k) * M + M));
            seg('R', col(M, k));
            seg('D', rowRev(M, k));
            seg('L', colRev(M, M - 1 - k));
            break;

        case 'B':
            // Back edge: U-row-k-rev → L-col-k → D-row-(N-1-k) → R-col-(N-1-k)-rev.
            seg('U', rowRev(M, k));
            seg('L', col(M, k));
            seg('D', range((M - 1 - k) * M, (M - 1 - k) * M + M));
            seg('R', colRev(M, M - 1 - k));
            break;
    }
    return ring;
}

function range(lo, hi) { const a = []; for (let i = lo; i < hi; i++) a.push(i); return a; }
function col(M, c)     { const a = []; for (let r = 0; r < M; r++) a.push(r * M + c); return a; }
function colRev(M, c)  { const a = []; for (let r = M - 1; r >= 0; r--) a.push(r * M + c); return a; }
function rowRev(M, r)  { const a = []; for (let c = M - 1; c >= 0; c--) a.push(r * M + c); return a; }

/** CW face rotation: dst = (r, c) ← src = (N-1-c, r). */
function applyFaceCwInPlace(perm, faceOff, N) {
    for (let r = 0; r < N; r++) {
        for (let c = 0; c < N; c++) {
            const dst = faceOff + r * N + c;
            const src = faceOff + (N - 1 - c) * N + r;
            perm[dst] = src;
        }
    }
}

/** CCW face rotation (inverse of CW): dst = (r, c) ← src = (c, N-1-r). */
function applyFaceCcwInPlace(perm, faceOff, N) {
    for (let r = 0; r < N; r++) {
        for (let c = 0; c < N; c++) {
            const dst = faceOff + r * N + c;
            const src = faceOff + c * N + (N - 1 - r);
            perm[dst] = src;
        }
    }
}

/** Apply one ring cycle in place: shift each segment forward by one. */
function applyRingInPlace(perm, ring) {
    const len = ring.length;
    const seg = len / 4;
    for (let k = 0; k < len; k++) {
        perm[ring[k]] = ring[(k + len - seg) % len];
    }
}

function identityPerm(total) {
    const p = new Int32Array(total);
    for (let i = 0; i < total; i++) p[i] = i;
    return p;
}

function compose(a, b, total) {
    const out = new Int32Array(total);
    for (let i = 0; i < total; i++) out[i] = a[b[i]];
    return out;
}

/**
 * Build the full move set for a cube of size N.  Returns an object with
 * the public move API used by {@code app.js}.
 *
 * @param {number} N  cube edge length (3..9)
 */
export function buildMoveSet(N) {
    const STICKERS_PER_FACE = N * N;
    const TOTAL_STICKERS    = 6 * STICKERS_PER_FACE;
    const FACE_OFFSETS = {
        U: 0,
        R: 1 * STICKERS_PER_FACE,
        F: 2 * STICKERS_PER_FACE,
        D: 3 * STICKERS_PER_FACE,
        L: 4 * STICKERS_PER_FACE,
        B: 5 * STICKERS_PER_FACE,
    };

    function buildCwPerm(face, layers) {
        const p = identityPerm(TOTAL_STICKERS);
        applyFaceCwInPlace(p, FACE_OFFSETS[face], N);
        for (let k = 0; k < layers; k++) {
            applyRingInPlace(p, ringIndicesForFace(face, k, N, FACE_OFFSETS));
        }
        return p;
    }

    /** Single inner-slice CW perm: rotates ONLY layer `layerIdx` (0 = outer)
     *  around `face`'s axis, leaving the face stickers themselves untouched
     *  (the face only spins for the outer layer turn). */
    function buildSliceCwPerm(face, layerIdx) {
        const p = identityPerm(TOTAL_STICKERS);
        // No applyFaceCwInPlace — inner slices don't rotate the outer face.
        applyRingInPlace(p, ringIndicesForFace(face, layerIdx, N, FACE_OFFSETS));
        return p;
    }

    /** Whole-cube rotation around `face`'s axis (x = R-axis, y = U-axis,
     *  z = F-axis), CW from `face`'s outside view.  Equivalent to spinning
     *  ALL N layers in the face direction, plus rotating the opposite
     *  face's stickers CCW (so its in-plane orientation matches the new
     *  global frame). */
    function buildCubeRotationCw(face) {
        const opp = { U: 'D', D: 'U', R: 'L', L: 'R', F: 'B', B: 'F' }[face];
        const p = identityPerm(TOTAL_STICKERS);
        applyFaceCwInPlace(p,  FACE_OFFSETS[face], N);
        applyFaceCcwInPlace(p, FACE_OFFSETS[opp],  N);
        for (let k = 0; k < N; k++) {
            applyRingInPlace(p, ringIndicesForFace(face, k, N, FACE_OFFSETS));
        }
        return p;
    }

    const PERMS = {};
    for (const f of FACES) {
        const cwOuter = buildCwPerm(f, 1);                    // single layer
        const cwWide  = buildCwPerm(f, 2);                    // two layers
        PERMS[f]         = cwOuter;
        PERMS[f + "'"]   = compose(compose(cwOuter, cwOuter, TOTAL_STICKERS), cwOuter, TOTAL_STICKERS);
        PERMS[f + '2']   = compose(cwOuter, cwOuter, TOTAL_STICKERS);
        PERMS[f + 'w']   = cwWide;
        PERMS[f + "w'"]  = compose(compose(cwWide, cwWide, TOTAL_STICKERS), cwWide, TOTAL_STICKERS);
        PERMS[f + 'w2']  = compose(cwWide, cwWide, TOTAL_STICKERS);
    }
    // Multi-layer wide moves (nFw / nRw / …) for n in 3..N-1, per WCA
    // Article 12a.  n=2 is identical to plain "Fw" (already generated
    // above); we also alias "2Fw" to the same perm for explicit-prefix
    // notation that some scramble generators emit.
    for (const f of FACES) {
        for (let n = 2; n <= N - 1; n++) {
            const cw = buildCwPerm(f, n);
            PERMS[`${n}${f}w`]   = cw;
            PERMS[`${n}${f}w'`]  = compose(compose(cw, cw, TOTAL_STICKERS), cw, TOTAL_STICKERS);
            PERMS[`${n}${f}w2`]  = compose(cw, cw, TOTAL_STICKERS);
        }
    }

    // Inner-slice (single-layer) notation: nF rotates ONLY the n-th layer
    // from face F (1-indexed; n=1 == outer F, redundant with F).  Generated
    // for n = 2 .. ceil(N/2) so each axis-aligned inner layer has at least
    // one canonical name.  On odd N's the middle layer is reachable from
    // either side (e.g. 3R == 3L' on N=5); we generate both.
    //   This is SiGN notation, not strictly WCA — included for cuber
    //   compatibility (and for our own drag-to-turn output).
    const maxInnerN = Math.ceil(N / 2);
    for (let n = 2; n <= maxInnerN; n++) {
        for (const f of FACES) {
            const cw = buildSliceCwPerm(f, n - 1);  // layerIdx is 0-based
            PERMS[`${n}${f}`]   = cw;
            PERMS[`${n}${f}'`]  = compose(compose(cw, cw, TOTAL_STICKERS), cw, TOTAL_STICKERS);
            PERMS[`${n}${f}2`]  = compose(cw, cw, TOTAL_STICKERS);
        }
    }

    // Lowercase wide aliases (u/r/f/d/l/b → Uw/Rw/…) per WCA Article
    // 12a — common in algorithms and what cubejs accepts natively.
    for (const f of FACES) {
        const lf = f.toLowerCase();
        PERMS[lf]         = PERMS[f + 'w'];
        PERMS[lf + "'"]   = PERMS[f + "w'"];
        PERMS[lf + '2']   = PERMS[f + 'w2'];
    }

    // 3×3 middle slices (M, E, S) — only meaningful for N=3 where there
    // is a single unambiguous middle layer.  By convention M follows L
    // (CW from L-view), E follows D, S follows F.
    if (N === 3) {
        const buildMid = (face) => buildSliceCwPerm(face, 1);
        const cubeOf = (cw) => compose(compose(cw, cw, TOTAL_STICKERS), cw, TOTAL_STICKERS);
        const sqOf   = (cw) => compose(cw, cw, TOTAL_STICKERS);
        const M = buildMid('L'),  E = buildMid('D'),  S = buildMid('F');
        PERMS['M']  = M;  PERMS["M'"] = cubeOf(M);  PERMS['M2'] = sqOf(M);
        PERMS['E']  = E;  PERMS["E'"] = cubeOf(E);  PERMS['E2'] = sqOf(E);
        PERMS['S']  = S;  PERMS["S'"] = cubeOf(S);  PERMS['S2'] = sqOf(S);
    }

    // Whole-cube rotations: x (around R), y (around U), z (around F).
    // Per WCA Article 12a4 — direction matches the namesake face turn.
    const ROT_AXIS = { x: 'R', y: 'U', z: 'F' };
    for (const [letter, face] of Object.entries(ROT_AXIS)) {
        const cw = buildCubeRotationCw(face);
        PERMS[letter]        = cw;
        PERMS[`${letter}'`]  = compose(compose(cw, cw, TOTAL_STICKERS), cw, TOTAL_STICKERS);
        PERMS[`${letter}2`]  = compose(cw, cw, TOTAL_STICKERS);
    }

    const ALL_MOVES = [];
    for (const f of FACES) {
        for (const w of ['', 'w']) {
            for (const s of ['', "'", '2']) ALL_MOVES.push(f + w + s);
        }
    }
    // 3-layer-and-deeper wide moves (n=3..N-1) — kept out of ALL_MOVES
    // for n=2 (== plain "Fw"; already in the list).
    for (let n = 3; n <= N - 1; n++) {
        for (const f of FACES) {
            for (const s of ['', "'", '2']) ALL_MOVES.push(`${n}${f}w${s}`);
        }
    }
    for (let n = 2; n <= maxInnerN; n++) {
        for (const f of FACES) {
            for (const s of ['', "'", '2']) ALL_MOVES.push(`${n}${f}${s}`);
        }
    }

    function permFor(move) { return PERMS[typeof move === 'string' ? move : move.raw] || null; }

    function applyMove(state, move) {
        const p = permFor(move);
        if (!p) throw new Error(`Unknown move: ${move}`);
        const out = new Array(TOTAL_STICKERS);
        for (let i = 0; i < TOTAL_STICKERS; i++) out[i] = state[p[i]];
        return out.join('');
    }

    function applyMoves(state, moves) {
        const seq = typeof moves === 'string'
            ? moves.trim().split(/\s+/).filter(Boolean)
            : moves;
        let s = state;
        for (const m of seq) s = applyMove(s, m);
        return s;
    }

    return { ALL_MOVES, permFor, applyMove, applyMoves, N, TOTAL_STICKERS, FACE_OFFSETS };
}
