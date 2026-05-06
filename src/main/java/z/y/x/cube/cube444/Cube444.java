package z.y.x.cube.cube444;

/**
 * 4×4×4 cube state model — Java mirror of {@code js/rubiks4/cube.js}.
 *
 * 96 stickers in 6 faces × 16 stickers each, indexed row-major within a
 * face.  Face order matches the JS module: U R F D L B (Singmaster).
 *
 *   Per-face offsets:  U=0  R=16  F=32  D=48  L=64  B=80
 *   Per-face layout (row-major):
 *        0  1  2  3
 *        4  5  6  7
 *        8  9 10 11
 *       12 13 14 15
 *
 * Centres are the inner 2×2: positions {5, 6, 9, 10} of every face.
 * Edges (wings) are the 8 non-corner non-centre positions.  Corners
 * are positions {0, 3, 12, 15}.
 *
 * Move application lives in {@link Cube444Moves}; this class is pure
 * state shape + validation.
 */
public final class Cube444 {

    public static final char[] FACES = {'U', 'R', 'F', 'D', 'L', 'B'};
    public static final int N = 4;
    public static final int STICKERS_PER_FACE = N * N;        // 16
    public static final int TOTAL_STICKERS    = 6 * STICKERS_PER_FACE; // 96

    /** Sticker-index offset for each face: U=0, R=16, F=32, D=48, L=64, B=80. */
    public static int faceOffset(char face) {
        switch (face) {
            case 'U': return 0;
            case 'R': return 16;
            case 'F': return 32;
            case 'D': return 48;
            case 'L': return 64;
            case 'B': return 80;
            default: throw new IllegalArgumentException("unknown face '" + face + "'");
        }
    }

    /** The 4 inner positions on every face (centres). */
    public static final int[] CENTRE_POS = {5, 6, 9, 10};
    /** The 4 corner positions on every face. */
    public static final int[] CORNER_POS = {0, 3, 12, 15};

    /** Solved state: U×16 R×16 F×16 D×16 L×16 B×16. */
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
        public static Validation good()                  { return new Validation(true, null); }
        public static Validation bad(String reason)      { return new Validation(false, reason); }
    }

    /**
     * Validate a 96-character state string.  Checks length, alphabet,
     * and per-face sticker counts.  Does NOT require centres to be
     * monochromatic — that's only true for a solved cube.  Real
     * scrambled inputs have centres dispersed across faces.
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
        return Validation.good();
    }

    public static boolean isSolved(String state) {
        return SOLVED.equals(state);
    }

    /** Replace one sticker. */
    public static String setSticker(String state, int index, char face) {
        if (index < 0 || index >= TOTAL_STICKERS) {
            throw new IllegalArgumentException("index " + index + " out of range");
        }
        return state.substring(0, index) + face + state.substring(index + 1);
    }

    private Cube444() {}
}
