package z.y.x.cube.cube555;

/**
 * 5×5×5 cube state model — sister of {@link z.y.x.cube.cube444.Cube444}.
 *
 * 150 stickers in 6 faces × 25 stickers each, indexed row-major within
 * a face.  Face order matches the rest of the codebase: U R F D L B
 * (Singmaster, Java URFDLB convention).
 *
 *   Per-face offsets:  U=0  R=25  F=50  D=75  L=100  B=125
 *   Per-face layout (row-major):
 *        0  1  2  3  4
 *        5  6  7  8  9
 *       10 11 12 13 14
 *       15 16 17 18 19
 *       20 21 22 23 24
 *
 * Centres: the inner 3×3 grid (positions 6, 7, 8, 11, 12, 13, 16, 17, 18).
 *   - The single dead-centre at facePos 12 is immovable on a 5×5 (it's
 *     the geometric centre of the face).  This makes 5×5 centre-solving
 *     fundamentally different from 4×4 — the dead centres define the
 *     face colour, no need to "stage" centres into the right face
 *     (just align orbits).
 *   - The eight surrounding centre stickers split into two orbits:
 *     the four T-centres (edge-adjacent: positions 7, 11, 13, 17) and
 *     the four X-centres (corner-adjacent: positions 6, 8, 16, 18).
 *
 * Edges (wings + middles): 12 dedges, each of which is 3 stickers wide
 * on a 5×5 → 36 edge stickers per face is wrong; let's restate:
 *   total edge stickers = 12 dedges × 4 stickers each = 48 across the
 *   cube.  Per face: 4 corners + 12 edge stickers + 9 centres = 25. ✓
 *
 * Corners (positions 0, 4, 20, 24): 8 corners × 3 stickers each = 24.
 *
 * Move application lives in {@link Cube555Moves}; this class is pure
 * state shape + validation.
 */
public final class Cube555 {

    public static final char[] FACES = {'U', 'R', 'F', 'D', 'L', 'B'};

    public static final int N = 5;
    public static final int STICKERS_PER_FACE = N * N;          // 25
    public static final int TOTAL_STICKERS    = 6 * STICKERS_PER_FACE; // 150

    /** Sticker-index offset for each face: U=0, R=25, F=50, D=75, L=100, B=125. */
    public static int faceOffset(char face) {
        switch (face) {
            case 'U': return 0;
            case 'R': return 25;
            case 'F': return 50;
            case 'D': return 75;
            case 'L': return 100;
            case 'B': return 125;
            default: throw new IllegalArgumentException("unknown face '" + face + "'");
        }
    }

    /** The 9 inner positions on every face (centres). */
    public static final int[] CENTRE_POS = {6, 7, 8, 11, 12, 13, 16, 17, 18};
    /** The single dead-centre on every face — never moves. */
    public static final int DEAD_CENTRE_POS = 12;
    /** The 4 T-centres on every face (edge-adjacent inner stickers). */
    public static final int[] T_CENTRE_POS = {7, 11, 13, 17};
    /** The 4 X-centres on every face (corner-adjacent inner stickers). */
    public static final int[] X_CENTRE_POS = {6, 8, 16, 18};
    /** The 4 corner positions on every face. */
    public static final int[] CORNER_POS = {0, 4, 20, 24};

    /** Solved state: U×25 R×25 F×25 D×25 L×25 B×25. */
    public static final String SOLVED;
    static {
        StringBuilder sb = new StringBuilder(TOTAL_STICKERS);
        for (char f : FACES) {
            for (int i = 0; i < STICKERS_PER_FACE; i++) sb.append(f);
        }
        SOLVED = sb.toString();
    }

    /** Result of {@link #validate(String)}.  ok=true → {@link #reason} is null. */
    public static final class Validation {
        public final boolean ok;
        public final String reason;
        private Validation(boolean ok, String reason) { this.ok = ok; this.reason = reason; }
        public static Validation good()             { return new Validation(true, null); }
        public static Validation bad(String reason) { return new Validation(false, reason); }
    }

    /**
     * Validate a 150-character state string.  Checks length, alphabet, and
     * per-face sticker counts.  Does NOT require centres to be monochromatic
     * (real scrambles disperse the surrounding 8 centres) but does verify
     * that each face's dead-centre is unique across faces — that's the
     * 5×5 invariant: the dead centre identifies the face colour.
     */
    public static Validation validate(String state) {
        if (state == null || state.length() != TOTAL_STICKERS) {
            int got = state == null ? 0 : state.length();
            return Validation.bad("expected " + TOTAL_STICKERS + " stickers, got " + got);
        }
        int[] counts = new int[256];
        for (int i = 0; i < state.length(); i++) {
            char c = state.charAt(i);
            if ("URFDLB".indexOf(c) < 0) {
                return Validation.bad("invalid sticker '" + c + "' at position " + i);
            }
            counts[c]++;
        }
        for (char f : FACES) {
            if (counts[f] != STICKERS_PER_FACE) {
                return Validation.bad(
                    "expected " + STICKERS_PER_FACE + " " + f + " stickers, got " + counts[f]);
            }
        }
        // Dead-centre invariant (only meaningful for input from a real cube;
        // a freshly-solved state trivially passes).
        boolean[] seen = new boolean[256];
        for (char f : FACES) {
            char dc = state.charAt(faceOffset(f) + DEAD_CENTRE_POS);
            if (seen[dc]) {
                return Validation.bad(
                    "two faces share dead-centre colour '" + dc
                    + "' — physically impossible on a 5×5");
            }
            seen[dc] = true;
        }
        return Validation.good();
    }

    public static boolean isSolved(String state) { return SOLVED.equals(state); }

    /** Replace one sticker. */
    public static String setSticker(String state, int index, char face) {
        if (index < 0 || index >= TOTAL_STICKERS) {
            throw new IllegalArgumentException("index " + index + " out of range");
        }
        return state.substring(0, index) + face + state.substring(index + 1);
    }

    private Cube555() {}
}
