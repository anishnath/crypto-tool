package z.y.x.cube.cube444;

/**
 * 4×4 → 3×3 reduction.
 *
 * Once centres are solved (each face's 4 inner stickers monochromatic)
 * and edges are paired (each dedge has both wings showing the same two
 * colours), the 4×4 visually IS a 3×3.  This class extracts a 54-char
 * 3×3 state string suitable for handing to a Kociemba-class solver.
 *
 * Sampling strategy: for each face, take 9 representative stickers in
 * 3×3 row-major order:
 *
 *      4×4 face (16 stickers)         3×3 face (9 stickers)
 *      0  1  2  3                     0  1  2
 *      4  5  6  7        →            3  4  5
 *      8  9 10 11                     6  7  8
 *     12 13 14 15
 *
 *   3×3 corner stickers (0, 2, 6, 8) ← 4×4 corner stickers (0, 3, 12, 15)
 *   3×3 edge   stickers (1, 3, 5, 7) ← 4×4 wing stickers     (1, 4, 7, 13)
 *                                       — wing 2 of each pair will match
 *                                         since edges are paired
 *   3×3 centre sticker  (4)          ← 4×4 centre sticker    (5)
 *                                       — any of {5,6,9,10} works
 *
 * Result is in URFDLB face order — what {@code cubejs.fromString()}
 * (and most Kociemba ports) expects.
 *
 * Reverse mapping (3×3 → 4×4 moves) is trivial: cubejs/Kociemba emit
 * outer-only moves which are a strict subset of our 4×4 move set, so
 * the move strings pass through unchanged.
 */
public final class Reduce333 {

    private Reduce333() {}

    /** 4×4 sticker positions sampled into the 3×3 representation. */
    private static final int[] SAMPLE_POSITIONS = {
        0,   1,   3,    // 3×3 row 0
        4,   5,   7,    // 3×3 row 1
        12, 13,  15,    // 3×3 row 2
    };

    /**
     * Convert a 4×4 (96-char) state to a 3×3 (54-char) state.  Caller is
     * responsible for ensuring the 4×4 is fully reduced — otherwise the
     * 3×3 string will be inconsistent and Kociemba will reject it.
     */
    public static String to3x3(String state4) {
        if (state4.length() != Cube444.TOTAL_STICKERS) {
            throw new IllegalArgumentException(
                "expected 96-char state, got " + state4.length());
        }
        StringBuilder sb = new StringBuilder(54);
        for (char f : Cube444.FACES) {
            int off = Cube444.faceOffset(f);
            for (int p : SAMPLE_POSITIONS) sb.append(state4.charAt(off + p));
        }
        return sb.toString();
    }

    /**
     * Translate a 3×3 solver's move output back to 4×4 moves.  Since
     * cubejs/Kociemba emit only {@code U R F D L B} outer-layer moves
     * (with optional ' or 2), they're already valid 4×4 move strings.
     * This is just a tokeniser for code clarity.
     */
    public static java.util.List<String> liftMoves(String soln3x3) {
        java.util.List<String> out = new java.util.ArrayList<>();
        if (soln3x3 == null || soln3x3.trim().isEmpty()) return out;
        for (String m : soln3x3.trim().split("\\s+")) out.add(m);
        return out;
    }
}
