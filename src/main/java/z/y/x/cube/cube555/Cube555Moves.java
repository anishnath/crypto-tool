package z.y.x.cube.cube555;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import z.y.x.cube.core.Permutation;

/**
 * 5×5 move application — Java sister of {@link z.y.x.cube.cube444.Cube444Moves}.
 *
 * 12 base CW quarter-turn permutations:
 *   outer:  U  R  F  D  L  B    (rotates one face slice)
 *   wide:   Uw Rw Fw Dw Lw Bw   (rotates the outer slice + the next inner slice;
 *                                standard WCA convention for N≥4)
 *
 * Plus 24 derived (primes via cube-of-CW, doubles via square).  Total 36
 * named moves — same set as 4×4.
 *
 * Slice-only notation (3Uw, M, E, S) is intentionally not supported — the
 * Python reference solver doesn't use them either, and every cube state
 * reachable on a 5×5 is reachable using just outer + wide moves.
 *
 * Ring derivation (ports the verified 4×4 ring conventions, just widening
 * each segment from 4 stickers to 5):
 *   - For each face F, ring_layer_k contains 4 segments of N stickers
 *     each, in CW order around F when viewed from outside.
 *   - Layer 0 is the outermost slice (the face's outermost adjacent row
 *     on each side face).  Layer 1 is the next inner slice.
 *   - Wide moves rotate layers 0 and 1 together.
 */
public final class Cube555Moves {

    private Cube555Moves() {}

    private static int U(int k) { return Cube555.faceOffset('U') + k; }
    private static int R(int k) { return Cube555.faceOffset('R') + k; }
    private static int F(int k) { return Cube555.faceOffset('F') + k; }
    private static int D(int k) { return Cube555.faceOffset('D') + k; }
    private static int L(int k) { return Cube555.faceOffset('L') + k; }
    private static int B(int k) { return Cube555.faceOffset('B') + k; }

    /* ─────────────────────────────────────────────────────────────────
     *  Ring tables — 20 indices each, organised as 4 segments of 5.
     *  A CW turn shifts each segment forward by one segment:
     *     ring[0..4] → ring[5..9] → ring[10..14] → ring[15..19] → ring[0..4]
     * ──────────────────────────────────────────────────────────────── */

    // U turn — F-top → L-top → B-top → R-top → F-top.  Top row of side
    // faces is row 0 (positions 0..4 within that face).
    private static final int[] RING_U_OUTER = {
        F(0),  F(1),  F(2),  F(3),  F(4),
        L(0),  L(1),  L(2),  L(3),  L(4),
        B(0),  B(1),  B(2),  B(3),  B(4),
        R(0),  R(1),  R(2),  R(3),  R(4),
    };
    // Uw — adds row 1 of side faces (positions 5..9).
    private static final int[] RING_U_INNER = {
        F(5),  F(6),  F(7),  F(8),  F(9),
        L(5),  L(6),  L(7),  L(8),  L(9),
        B(5),  B(6),  B(7),  B(8),  B(9),
        R(5),  R(6),  R(7),  R(8),  R(9),
    };

    // D turn — F-bot → R-bot → B-bot → L-bot → F-bot.  Bottom row of
    // side faces is row 4 (positions 20..24).
    private static final int[] RING_D_OUTER = {
        F(20), F(21), F(22), F(23), F(24),
        R(20), R(21), R(22), R(23), R(24),
        B(20), B(21), B(22), B(23), B(24),
        L(20), L(21), L(22), L(23), L(24),
    };
    // Dw — adds row 3 (positions 15..19).
    private static final int[] RING_D_INNER = {
        F(15), F(16), F(17), F(18), F(19),
        R(15), R(16), R(17), R(18), R(19),
        B(15), B(16), B(17), B(18), B(19),
        L(15), L(16), L(17), L(18), L(19),
    };

    // R turn — U-right → B-left(reversed) → D-right → F-right → U-right.
    // Right column on a 5×5 face is positions 4, 9, 14, 19, 24 (col 4).
    // B's left column reversed = positions 20, 15, 10, 5, 0.
    private static final int[] RING_R_OUTER = {
        U(4),  U(9),  U(14), U(19), U(24),
        B(20), B(15), B(10), B(5),  B(0),
        D(4),  D(9),  D(14), D(19), D(24),
        F(4),  F(9),  F(14), F(19), F(24),
    };
    // Rw — adds col 3 (positions 3, 8, 13, 18, 23) on U/D/F and col 1
    // reversed (positions 21, 16, 11, 6, 1) on B.
    private static final int[] RING_R_INNER = {
        U(3),  U(8),  U(13), U(18), U(23),
        B(21), B(16), B(11), B(6),  B(1),
        D(3),  D(8),  D(13), D(18), D(23),
        F(3),  F(8),  F(13), F(18), F(23),
    };

    // L turn — U-left → F-left → D-left → B-right(reversed) → U-left.
    // Left col = positions 0, 5, 10, 15, 20 (col 0).
    // B's right col reversed = positions 24, 19, 14, 9, 4.
    private static final int[] RING_L_OUTER = {
        U(0),  U(5),  U(10), U(15), U(20),
        F(0),  F(5),  F(10), F(15), F(20),
        D(0),  D(5),  D(10), D(15), D(20),
        B(24), B(19), B(14), B(9),  B(4),
    };
    // Lw — adds col 1 (positions 1, 6, 11, 16, 21) and B's col 3
    // reversed (positions 23, 18, 13, 8, 3).
    private static final int[] RING_L_INNER = {
        U(1),  U(6),  U(11), U(16), U(21),
        F(1),  F(6),  F(11), F(16), F(21),
        D(1),  D(6),  D(11), D(16), D(21),
        B(23), B(18), B(13), B(8),  B(3),
    };

    // F turn — U-bot → R-left → D-top(reversed) → L-right(reversed) → U-bot.
    // U bottom row = 20..24; R left col = 0, 5, 10, 15, 20.
    // D top row reversed = 4, 3, 2, 1, 0; L right col reversed = 24, 19, 14, 9, 4.
    private static final int[] RING_F_OUTER = {
        U(20), U(21), U(22), U(23), U(24),
        R(0),  R(5),  R(10), R(15), R(20),
        D(4),  D(3),  D(2),  D(1),  D(0),
        L(24), L(19), L(14), L(9),  L(4),
    };
    // Fw — adds U row 3 (15..19), R col 1 (1, 6, 11, 16, 21),
    // D row 1 reversed (9, 8, 7, 6, 5), L col 3 reversed (23, 18, 13, 8, 3).
    private static final int[] RING_F_INNER = {
        U(15), U(16), U(17), U(18), U(19),
        R(1),  R(6),  R(11), R(16), R(21),
        D(9),  D(8),  D(7),  D(6),  D(5),
        L(23), L(18), L(13), L(8),  L(3),
    };

    // B turn — U-top(reversed) → L-left → D-bot → R-right(reversed) → U-top.
    // U top row reversed = 4, 3, 2, 1, 0; L left col = 0, 5, 10, 15, 20.
    // D bottom row = 20..24; R right col reversed = 24, 19, 14, 9, 4.
    private static final int[] RING_B_OUTER = {
        U(4),  U(3),  U(2),  U(1),  U(0),
        L(0),  L(5),  L(10), L(15), L(20),
        D(20), D(21), D(22), D(23), D(24),
        R(24), R(19), R(14), R(9),  R(4),
    };
    // Bw — adds U row 1 reversed (9, 8, 7, 6, 5), L col 1 (1, 6, 11, 16, 21),
    // D row 3 (15..19), R col 3 reversed (23, 18, 13, 8, 3).
    private static final int[] RING_B_INNER = {
        U(9),  U(8),  U(7),  U(6),  U(5),
        L(1),  L(6),  L(11), L(16), L(21),
        D(15), D(16), D(17), D(18), D(19),
        R(23), R(18), R(13), R(8),  R(3),
    };

    /* ─────────────────────────────────────────────────────────────────
     *  Permutation construction
     * ──────────────────────────────────────────────────────────────── */

    /**
     * Write the CW face rotation (90° clockwise viewed from outside) of a
     * 5×5 face into {@code perm}, given the face's offset.
     *
     *   newFace[r,c] = oldFace[N-1-c, r]    (row-major index = r*N+c)
     */
    private static void applyFaceCw(byte[] perm, int faceOff) {
        for (int r = 0; r < Cube555.N; r++) {
            for (int c = 0; c < Cube555.N; c++) {
                int dst = faceOff + r * Cube555.N + c;
                int src = faceOff + (Cube555.N - 1 - c) * Cube555.N + r;
                perm[dst] = (byte) src;
            }
        }
    }

    /**
     * Cycle a ring by one segment forward.  newState[ring[k]] equals the
     * old value at ring[k − segLen mod len].  segLen = len/4.
     */
    private static void applyRing(byte[] perm, int[] ring) {
        int len = ring.length;
        int seg = len / 4;
        for (int k = 0; k < len; k++) {
            int dst = ring[k];
            int src = ring[(k + len - seg) % len];
            perm[dst] = (byte) src;
        }
    }

    private static byte[] buildCwPerm(int faceOff, int[]... rings) {
        byte[] p = Permutation.identity(Cube555.TOTAL_STICKERS);
        applyFaceCw(p, faceOff);
        for (int[] ring : rings) applyRing(p, ring);
        return p;
    }

    /* ─────────────────────────────────────────────────────────────────
     *  Per-face CW perms (outer + wide)
     * ──────────────────────────────────────────────────────────────── */

    private static final byte[] CW_U_OUTER = buildCwPerm(Cube555.faceOffset('U'), RING_U_OUTER);
    private static final byte[] CW_U_WIDE  = buildCwPerm(Cube555.faceOffset('U'), RING_U_OUTER, RING_U_INNER);
    private static final byte[] CW_R_OUTER = buildCwPerm(Cube555.faceOffset('R'), RING_R_OUTER);
    private static final byte[] CW_R_WIDE  = buildCwPerm(Cube555.faceOffset('R'), RING_R_OUTER, RING_R_INNER);
    private static final byte[] CW_F_OUTER = buildCwPerm(Cube555.faceOffset('F'), RING_F_OUTER);
    private static final byte[] CW_F_WIDE  = buildCwPerm(Cube555.faceOffset('F'), RING_F_OUTER, RING_F_INNER);
    private static final byte[] CW_D_OUTER = buildCwPerm(Cube555.faceOffset('D'), RING_D_OUTER);
    private static final byte[] CW_D_WIDE  = buildCwPerm(Cube555.faceOffset('D'), RING_D_OUTER, RING_D_INNER);
    private static final byte[] CW_L_OUTER = buildCwPerm(Cube555.faceOffset('L'), RING_L_OUTER);
    private static final byte[] CW_L_WIDE  = buildCwPerm(Cube555.faceOffset('L'), RING_L_OUTER, RING_L_INNER);
    private static final byte[] CW_B_OUTER = buildCwPerm(Cube555.faceOffset('B'), RING_B_OUTER);
    private static final byte[] CW_B_WIDE  = buildCwPerm(Cube555.faceOffset('B'), RING_B_OUTER, RING_B_INNER);

    /** All 36 base move strings (face × layer × turns). */
    public static final List<String> ALL_MOVES;
    static {
        List<String> all = new ArrayList<>(36);
        for (char f : Cube555.FACES) {
            for (String w : new String[] {"", "w"}) {
                for (String s : new String[] {"", "'", "2"}) {
                    all.add(f + w + s);
                }
            }
        }
        ALL_MOVES = Collections.unmodifiableList(all);
    }

    /** Permutation table: move-string → 150-element byte[] perm. */
    private static final Map<String, byte[]> PERMS = buildAllPerms();

    private static Map<String, byte[]> buildAllPerms() {
        Map<String, byte[]> m = new HashMap<>(40);
        addFaceFamily(m, 'U', CW_U_OUTER, CW_U_WIDE);
        addFaceFamily(m, 'R', CW_R_OUTER, CW_R_WIDE);
        addFaceFamily(m, 'F', CW_F_OUTER, CW_F_WIDE);
        addFaceFamily(m, 'D', CW_D_OUTER, CW_D_WIDE);
        addFaceFamily(m, 'L', CW_L_OUTER, CW_L_WIDE);
        addFaceFamily(m, 'B', CW_B_OUTER, CW_B_WIDE);
        return Collections.unmodifiableMap(m);
    }

    private static void addFaceFamily(Map<String, byte[]> m, char face,
                                      byte[] cwOuter, byte[] cwWide) {
        String f = String.valueOf(face);
        m.put(f,        cwOuter);
        m.put(f + "'",  Permutation.cube(cwOuter));
        m.put(f + "2",  Permutation.square(cwOuter));
        m.put(f + "w",  cwWide);
        m.put(f + "w'", Permutation.cube(cwWide));
        m.put(f + "w2", Permutation.square(cwWide));
    }

    /** Lookup the 150-element permutation for a move string.  Throws on
     *  unrecognised input. */
    public static byte[] permFor(String moveStr) {
        byte[] p = PERMS.get(moveStr);
        if (p == null) {
            throw new IllegalArgumentException("unknown move: " + moveStr);
        }
        return p;
    }

    /** Apply a single move to a state string. */
    public static String applyMove(String state, String moveStr) {
        return Permutation.apply(state, permFor(moveStr));
    }

    /** Apply a sequence of moves.  Accepts space-separated string or an
     *  iterable of strings. */
    public static String applyMoves(String state, String moves) {
        if (moves == null) return state;
        String trimmed = moves.trim();
        if (trimmed.isEmpty()) return state;
        for (String m : trimmed.split("\\s+")) state = applyMove(state, m);
        return state;
    }

    public static String applyMoves(String state, Iterable<String> moves) {
        if (moves == null) return state;
        for (String m : moves) state = applyMove(state, m);
        return state;
    }

    /** Returns the inverse of a move sequence (reverse order, each move
     *  inverted).  U → U', U' → U, U2 → U2; same for wide variants. */
    public static List<String> invertMoves(List<String> moves) {
        List<String> out = new ArrayList<>(moves.size());
        for (int i = moves.size() - 1; i >= 0; i--) out.add(invertMove(moves.get(i)));
        return out;
    }

    private static String invertMove(String raw) {
        if (raw.endsWith("2")) return raw;                          // 180° self-inverse
        if (raw.endsWith("'")) return raw.substring(0, raw.length() - 1);
        return raw + "'";
    }
}
