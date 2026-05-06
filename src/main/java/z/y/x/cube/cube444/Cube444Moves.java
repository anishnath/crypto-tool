package z.y.x.cube.cube444;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import z.y.x.cube.core.Move;
import z.y.x.cube.core.Permutation;

/**
 * 4×4 move application.  Java port of {@code js/rubiks4/moves.js}.
 *
 * 12 base CW quarter-turn permutations:
 *   outer:  U  R  F  D  L  B
 *   wide:   Uw Rw Fw Dw Lw Bw
 *
 * Plus 24 derived (primes via cube of CW, doubles via square).  Total 36.
 *
 * Each perm is a {@code byte[]} of length 96 with
 * {@code newState[i] = oldState[perm[i] & 0xFF]}.
 *
 * The ring orderings below were carried over from the verified JS module
 * (which was byte-equal-tested against the Python reference solver across
 * 43 scrambles).  Don't change them without re-running that test in Java.
 */
public final class Cube444Moves {

    private Cube444Moves() {}

    private static int U(int k) { return Cube444.faceOffset('U') + k; }
    private static int R(int k) { return Cube444.faceOffset('R') + k; }
    private static int F(int k) { return Cube444.faceOffset('F') + k; }
    private static int D(int k) { return Cube444.faceOffset('D') + k; }
    private static int L(int k) { return Cube444.faceOffset('L') + k; }
    private static int B(int k) { return Cube444.faceOffset('B') + k; }

    /* ─────────────────────────────────────────────────────────────────
     *  Ring tables — 16 indices each, organised as 4 segments of 4.
     *  A CW turn shifts each segment forward by one segment:
     *     ring[0..3] → ring[4..7] → ring[8..11] → ring[12..15] → ring[0..3]
     * ──────────────────────────────────────────────────────────────── */

    private static final int[] RING_U_OUTER = {
        F(0),  F(1),  F(2),  F(3),
        L(0),  L(1),  L(2),  L(3),
        B(0),  B(1),  B(2),  B(3),
        R(0),  R(1),  R(2),  R(3),
    };
    private static final int[] RING_U_INNER = {
        F(4),  F(5),  F(6),  F(7),
        L(4),  L(5),  L(6),  L(7),
        B(4),  B(5),  B(6),  B(7),
        R(4),  R(5),  R(6),  R(7),
    };

    private static final int[] RING_D_OUTER = {
        F(12), F(13), F(14), F(15),
        R(12), R(13), R(14), R(15),
        B(12), B(13), B(14), B(15),
        L(12), L(13), L(14), L(15),
    };
    private static final int[] RING_D_INNER = {
        F(8),  F(9),  F(10), F(11),
        R(8),  R(9),  R(10), R(11),
        B(8),  B(9),  B(10), B(11),
        L(8),  L(9),  L(10), L(11),
    };

    private static final int[] RING_R_OUTER = {
        U(3),  U(7),  U(11), U(15),
        B(12), B(8),  B(4),  B(0),
        D(3),  D(7),  D(11), D(15),
        F(3),  F(7),  F(11), F(15),
    };
    private static final int[] RING_R_INNER = {
        U(2),  U(6),  U(10), U(14),
        B(13), B(9),  B(5),  B(1),
        D(2),  D(6),  D(10), D(14),
        F(2),  F(6),  F(10), F(14),
    };

    private static final int[] RING_L_OUTER = {
        U(0),  U(4),  U(8),  U(12),
        F(0),  F(4),  F(8),  F(12),
        D(0),  D(4),  D(8),  D(12),
        B(15), B(11), B(7),  B(3),
    };
    private static final int[] RING_L_INNER = {
        U(1),  U(5),  U(9),  U(13),
        F(1),  F(5),  F(9),  F(13),
        D(1),  D(5),  D(9),  D(13),
        B(14), B(10), B(6),  B(2),
    };

    private static final int[] RING_F_OUTER = {
        U(12), U(13), U(14), U(15),
        R(0),  R(4),  R(8),  R(12),
        D(3),  D(2),  D(1),  D(0),
        L(15), L(11), L(7),  L(3),
    };
    private static final int[] RING_F_INNER = {
        U(8),  U(9),  U(10), U(11),
        R(1),  R(5),  R(9),  R(13),
        D(7),  D(6),  D(5),  D(4),
        L(14), L(10), L(6),  L(2),
    };

    private static final int[] RING_B_OUTER = {
        U(3),  U(2),  U(1),  U(0),
        L(0),  L(4),  L(8),  L(12),
        D(12), D(13), D(14), D(15),
        R(15), R(11), R(7),  R(3),
    };
    private static final int[] RING_B_INNER = {
        U(7),  U(6),  U(5),  U(4),
        L(1),  L(5),  L(9),  L(13),
        D(8),  D(9),  D(10), D(11),
        R(14), R(10), R(6),  R(2),
    };

    /* ─────────────────────────────────────────────────────────────────
     *  Permutation construction
     * ──────────────────────────────────────────────────────────────── */

    /**
     * In place: write the CW face rotation (90° clockwise viewed from
     * outside) of a 4×4 face onto {@code perm}, given the face's offset.
     *
     *   newFace[r,c] = oldFace[3-c, r]    (row-major index = r*4+c)
     */
    private static void applyFaceCw(byte[] perm, int faceOff) {
        for (int r = 0; r < 4; r++) {
            for (int c = 0; c < 4; c++) {
                int dst = faceOff + r * 4 + c;
                int src = faceOff + (3 - c) * 4 + r;
                perm[dst] = (byte) src;
            }
        }
    }

    /**
     * In place: cycle a ring by one segment forward.
     *   newState[ring[k]] = oldState[ring[k − segLen mod 16]]
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
        byte[] p = Permutation.identity(Cube444.TOTAL_STICKERS);
        applyFaceCw(p, faceOff);
        for (int[] ring : rings) applyRing(p, ring);
        return p;
    }

    /* ─────────────────────────────────────────────────────────────────
     *  Per-face CW perms (outer + wide)
     * ──────────────────────────────────────────────────────────────── */

    private static final byte[] CW_U_OUTER  = buildCwPerm(Cube444.faceOffset('U'), RING_U_OUTER);
    private static final byte[] CW_U_WIDE   = buildCwPerm(Cube444.faceOffset('U'), RING_U_OUTER, RING_U_INNER);
    private static final byte[] CW_R_OUTER  = buildCwPerm(Cube444.faceOffset('R'), RING_R_OUTER);
    private static final byte[] CW_R_WIDE   = buildCwPerm(Cube444.faceOffset('R'), RING_R_OUTER, RING_R_INNER);
    private static final byte[] CW_F_OUTER  = buildCwPerm(Cube444.faceOffset('F'), RING_F_OUTER);
    private static final byte[] CW_F_WIDE   = buildCwPerm(Cube444.faceOffset('F'), RING_F_OUTER, RING_F_INNER);
    private static final byte[] CW_D_OUTER  = buildCwPerm(Cube444.faceOffset('D'), RING_D_OUTER);
    private static final byte[] CW_D_WIDE   = buildCwPerm(Cube444.faceOffset('D'), RING_D_OUTER, RING_D_INNER);
    private static final byte[] CW_L_OUTER  = buildCwPerm(Cube444.faceOffset('L'), RING_L_OUTER);
    private static final byte[] CW_L_WIDE   = buildCwPerm(Cube444.faceOffset('L'), RING_L_OUTER, RING_L_INNER);
    private static final byte[] CW_B_OUTER  = buildCwPerm(Cube444.faceOffset('B'), RING_B_OUTER);
    private static final byte[] CW_B_WIDE   = buildCwPerm(Cube444.faceOffset('B'), RING_B_OUTER, RING_B_INNER);

    /** All 36 base move strings (face × layer × turns). */
    public static final List<String> ALL_MOVES;
    static {
        List<String> all = new ArrayList<>(36);
        for (char f : Cube444.FACES) {
            for (String w : new String[] {"", "w"}) {
                for (String s : new String[] {"", "'", "2"}) {
                    all.add(f + w + s);
                }
            }
        }
        ALL_MOVES = Collections.unmodifiableList(all);
    }

    /** Permutation table: move-string → 96-element byte[] perm. */
    private static final Map<String, byte[]> PERMS = buildAllPerms();

    private static Map<String, byte[]> buildAllPerms() {
        Map<String, byte[]> m = new HashMap<>(40);
        m.put("U",   CW_U_OUTER);
        m.put("U'",  Permutation.cube(CW_U_OUTER));
        m.put("U2",  Permutation.square(CW_U_OUTER));
        m.put("Uw",  CW_U_WIDE);
        m.put("Uw'", Permutation.cube(CW_U_WIDE));
        m.put("Uw2", Permutation.square(CW_U_WIDE));

        m.put("R",   CW_R_OUTER);
        m.put("R'",  Permutation.cube(CW_R_OUTER));
        m.put("R2",  Permutation.square(CW_R_OUTER));
        m.put("Rw",  CW_R_WIDE);
        m.put("Rw'", Permutation.cube(CW_R_WIDE));
        m.put("Rw2", Permutation.square(CW_R_WIDE));

        m.put("F",   CW_F_OUTER);
        m.put("F'",  Permutation.cube(CW_F_OUTER));
        m.put("F2",  Permutation.square(CW_F_OUTER));
        m.put("Fw",  CW_F_WIDE);
        m.put("Fw'", Permutation.cube(CW_F_WIDE));
        m.put("Fw2", Permutation.square(CW_F_WIDE));

        m.put("D",   CW_D_OUTER);
        m.put("D'",  Permutation.cube(CW_D_OUTER));
        m.put("D2",  Permutation.square(CW_D_OUTER));
        m.put("Dw",  CW_D_WIDE);
        m.put("Dw'", Permutation.cube(CW_D_WIDE));
        m.put("Dw2", Permutation.square(CW_D_WIDE));

        m.put("L",   CW_L_OUTER);
        m.put("L'",  Permutation.cube(CW_L_OUTER));
        m.put("L2",  Permutation.square(CW_L_OUTER));
        m.put("Lw",  CW_L_WIDE);
        m.put("Lw'", Permutation.cube(CW_L_WIDE));
        m.put("Lw2", Permutation.square(CW_L_WIDE));

        m.put("B",   CW_B_OUTER);
        m.put("B'",  Permutation.cube(CW_B_OUTER));
        m.put("B2",  Permutation.square(CW_B_OUTER));
        m.put("Bw",  CW_B_WIDE);
        m.put("Bw'", Permutation.cube(CW_B_WIDE));
        m.put("Bw2", Permutation.square(CW_B_WIDE));

        return Collections.unmodifiableMap(m);
    }

    /** Lookup the 96-element permutation for a move string.  Throws on
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
     *  inverted). */
    public static List<String> invertMoves(List<String> moves) {
        List<String> out = new ArrayList<>(moves.size());
        for (int i = moves.size() - 1; i >= 0; i--) {
            out.add(Move.parse(moves.get(i)).inverse().toString());
        }
        return out;
    }
}
