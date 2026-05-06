package z.y.x.cube.cube555;

/**
 * Reduce a fully-paired, fully-staged 5×5 cube to a 54-character 3×3
 * string suitable for Kociemba's two-phase solver.
 *
 * <p>After phases 1-6, every centre is solved and every edge is paired
 * (each edge's 3 stickers along its length all hold the same colour).
 * The cube behaves like a 3×3.  Sampling 9 positions per face — 4
 * corners + 4 edge-midges + 1 centre — produces the canonical 3×3
 * representation:
 *
 * <pre>
 *      face position 0  1  2  3  4   →  3×3 row 0: cols 0,1,2 = positions 0,2,4
 *                    5  6  7  8  9
 *                   10 11 12 13 14   →  3×3 row 1: cols 0,1,2 = positions 10,12,14
 *                   15 16 17 18 19
 *                   20 21 22 23 24   →  3×3 row 2: cols 0,1,2 = positions 20,22,24
 * </pre>
 *
 * <p>Output is in URFDLB face order, 9 chars per face × 6 faces = 54 chars.
 */
public final class Reduce555To333 {

    private Reduce555To333() {}

    /** 9 sample positions per 25-position face — corners + edge midges + centre. */
    private static final int[] SAMPLE_POSITIONS = {0, 2, 4, 10, 12, 14, 20, 22, 24};

    /** Convert a 150-char URFDLB 5×5 state into the 54-char 3×3 string. */
    public static String to3x3(String state5) {
        if (state5.length() != Cube555.TOTAL_STICKERS) {
            throw new IllegalArgumentException(
                "expected 150-char 5×5 state, got " + state5.length());
        }
        StringBuilder sb = new StringBuilder(54);
        for (char f : Cube555.FACES) {
            int off = Cube555.faceOffset(f);
            for (int p : SAMPLE_POSITIONS) sb.append(state5.charAt(off + p));
        }
        return sb.toString();
    }
}
