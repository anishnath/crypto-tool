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
    // 3-layer wide moves (3Uw, 3Rw, etc.) — only meaningful for N≥6
    // (on N=4/5 there aren't 3 layers to rotate before hitting the
    // opposite face).  Notation matches the cuber convention.
    if (N >= 6) {
        for (const f of FACES) {
            const cw3 = buildCwPerm(f, 3);
            PERMS['3' + f + 'w']   = cw3;
            PERMS['3' + f + "w'"]  = compose(compose(cw3, cw3, TOTAL_STICKERS), cw3, TOTAL_STICKERS);
            PERMS['3' + f + 'w2']  = compose(cw3, cw3, TOTAL_STICKERS);
        }
    }

    const ALL_MOVES = [];
    for (const f of FACES) {
        for (const w of ['', 'w']) {
            for (const s of ['', "'", '2']) ALL_MOVES.push(f + w + s);
        }
    }
    if (N >= 6) {
        for (const f of FACES) {
            for (const s of ['', "'", '2']) ALL_MOVES.push('3' + f + 'w' + s);
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
