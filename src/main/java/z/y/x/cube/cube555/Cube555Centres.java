package z.y.x.cube.cube555;

/**
 * Encoders for 5×5 centre-state lookup-table keys.  Each method extracts
 * the relevant subset of stickers into the exact string format that the
 * Python+C reference's lookup tables use, so we can hash-lookup states
 * directly without any post-processing.
 *
 * <h2>Encoder definitions (Python source mirror)</h2>
 *
 * <pre>
 *   step23 LR-centre-stage      LR_centers_555 → 9 L-face + 9 R-face inner stickers
 *   step11 LR T-centre-only      LR_t_centers   → 4 T-centres × 2 faces = 8 stickers
 *   step12 LR X-centre-only      LR_x_centers   → 4 X-centres × 2 faces = 8 stickers
 *   step21 FB T-centre stage     FB_t_centers   → 4 T-centres × (F + B) = 8 stickers
 *   step22 FB X-centre stage     FB_x_centers   → 4 X-centres × (F + B) = 8 stickers
 * </pre>
 *
 * Position mapping: the Python {@code centers_555} tuple uses 1-indexed
 * ULFRBD positions; we translate once via the standard URFDLB face
 * offsets and then index into the 0-indexed 150-char Java state.
 *
 * <p>For the LR-centre table the expected goal string format is
 * {@code <9 L-face stickers><9 R-face stickers>} (9 + 9 = 18 chars).
 * The "solved" states have the L stickers all on the L face and R
 * stickers all on R, in any of 27 valid arrangements (because the dead
 * centre's position is fixed but the surrounding 8 are free).
 */
public final class Cube555Centres {

    private Cube555Centres() {}

    /** Inner 3×3 grid (centre stickers) on every face: 9 positions
     *  including the dead-centre at facePos 12.  Same as
     *  {@link Cube555#CENTRE_POS}. */
    public static final int[] CENTRE_POS = Cube555.CENTRE_POS;

    /** T-centres (edge-adjacent inner stickers): facePos 7, 11, 13, 17. */
    public static final int[] T_CENTRE_POS = Cube555.T_CENTRE_POS;

    /** X-centres (corner-adjacent inner stickers): facePos 6, 8, 16, 18. */
    public static final int[] X_CENTRE_POS = Cube555.X_CENTRE_POS;

    /**
     * Encode the LR-centre-stage state — the 18-char string the
     * {@code lookup-table-5x5x5-step23-LR-center-stage.txt} table is
     * keyed on.
     *
     * <p>Format: 9 stickers from the L face's centre 3×3 (in row-major
     * order: facePos 6, 7, 8, 11, 12, 13, 16, 17, 18) followed by 9
     * stickers from the R face's centre 3×3 in the same order.
     *
     * @param state full 150-char Java URFDLB state
     * @return 18-character key suitable for {@link
     *     z.y.x.cube.lookup.TextLookupTable#solutionFor(String)}
     */
    public static String encodeLR(String state) {
        StringBuilder sb = new StringBuilder(18);
        appendCentres(sb, state, 'L');
        appendCentres(sb, state, 'R');
        return sb.toString();
    }

    /** As {@link #encodeLR} but for FB centres (F face then B face). */
    public static String encodeFB(String state) {
        StringBuilder sb = new StringBuilder(18);
        appendCentres(sb, state, 'F');
        appendCentres(sb, state, 'B');
        return sb.toString();
    }

    /** As {@link #encodeLR} but for UD centres (U face then D face). */
    public static String encodeUD(String state) {
        StringBuilder sb = new StringBuilder(18);
        appendCentres(sb, state, 'U');
        appendCentres(sb, state, 'D');
        return sb.toString();
    }

    /** Encode just the T-centres of two faces (8-char key). */
    public static String encodeTCentres(String state, char faceA, char faceB) {
        StringBuilder sb = new StringBuilder(8);
        appendPositions(sb, state, faceA, T_CENTRE_POS);
        appendPositions(sb, state, faceB, T_CENTRE_POS);
        return sb.toString();
    }

    /** Encode just the X-centres of two faces (8-char key). */
    public static String encodeXCentres(String state, char faceA, char faceB) {
        StringBuilder sb = new StringBuilder(8);
        appendPositions(sb, state, faceA, X_CENTRE_POS);
        appendPositions(sb, state, faceB, X_CENTRE_POS);
        return sb.toString();
    }

    /* ─────────────────────────────────────────────────────────────────
     *  6-hex staging encoders — match the Python LookupTable555*Stage
     *  bit layout exactly, so the keys index directly into the
     *  step11 / step12 / step21 / step22 lookup tables.
     *
     *  Each encoder reads 4 face-positions × 6 faces (24 stickers) in
     *  Python's ULFRBD face order and emits a 6-hex string where each
     *  bit is 1 iff the sticker is one of the two "target" colours
     *  (e.g. L or R for the LR-staging tables).  Goal value is 0x0f0f00
     *  (bits set on faces 1 and 3 in U-L-F-R-B-D order).
     * ──────────────────────────────────────────────────────────────── */

    /** Python's ULFRBD face order — required for LR-staging table-key
     *  compatibility (24-bit encoder over all 6 faces). */
    private static final char[] PY_FACES_ULFRBD = {'U', 'L', 'F', 'R', 'B', 'D'};

    /** Python's UFBD face order for FB-staging — only 4 faces because LR
     *  is already staged and skipped (16-bit encoder, goal {@code 0ff0}). */
    private static final char[] PY_FACES_UFBD   = {'U', 'F', 'B', 'D'};

    /** Goal hex for LR-staging lookup tables — 24 bits, bits set on faces
     *  1 and 3 of ULFRBD order (= L and R). */
    public static final String LR_STAGE_GOAL_HEX = "0f0f00";

    /** Goal hex for FB-staging lookup tables — 16 bits, bits set on faces
     *  1 and 2 of UFBD order (= F and B). */
    public static final String FB_STAGE_GOAL_HEX = "0ff0";

    /* ── LR-staging encoders (24-bit, ULFRBD face order, 6 hex chars) ── */

    public static String encodeLRTStaging(String state) {
        return stagingHex(state, PY_FACES_ULFRBD, T_CENTRE_POS, 'L', 'R', 6);
    }
    public static String encodeLRTStagingBytes(byte[] state) {
        return stagingHexBytes(state, PY_FACES_ULFRBD, T_CENTRE_POS, (byte) 'L', (byte) 'R', 6);
    }
    public static String encodeLRXStaging(String state) {
        return stagingHex(state, PY_FACES_ULFRBD, X_CENTRE_POS, 'L', 'R', 6);
    }
    public static String encodeLRXStagingBytes(byte[] state) {
        return stagingHexBytes(state, PY_FACES_ULFRBD, X_CENTRE_POS, (byte) 'L', (byte) 'R', 6);
    }

    /* ── FB-staging encoders (16-bit, UFBD face order, 4 hex chars) ──
     *
     * These intentionally skip the L+R faces because LR is already
     * staged.  Goal: F+B coloured stickers on F+B faces only.
     */

    public static String encodeFBTStaging(String state) {
        return stagingHex(state, PY_FACES_UFBD, T_CENTRE_POS, 'F', 'B', 4);
    }
    public static String encodeFBTStagingBytes(byte[] state) {
        return stagingHexBytes(state, PY_FACES_UFBD, T_CENTRE_POS, (byte) 'F', (byte) 'B', 4);
    }
    public static String encodeFBXStaging(String state) {
        return stagingHex(state, PY_FACES_UFBD, X_CENTRE_POS, 'F', 'B', 4);
    }
    public static String encodeFBXStagingBytes(byte[] state) {
        return stagingHexBytes(state, PY_FACES_UFBD, X_CENTRE_POS, (byte) 'F', (byte) 'B', 4);
    }

    /** Build a hex staging key from {@code state} given the face order,
     *  per-face positions, two target colours, and hex digit count. */
    private static String stagingHex(String state, char[] faces, int[] positions,
                                     char colA, char colB, int hexDigits) {
        int bits = 0;
        for (char f : faces) {
            int off = Cube555.faceOffset(f);
            for (int p : positions) {
                char ch = state.charAt(off + p);
                bits = (bits << 1) | ((ch == colA || ch == colB) ? 1 : 0);
            }
        }
        return toHex(bits, hexDigits);
    }

    private static String stagingHexBytes(byte[] state, char[] faces, int[] positions,
                                          byte colA, byte colB, int hexDigits) {
        int bits = 0;
        for (char f : faces) {
            int off = Cube555.faceOffset(f);
            for (int p : positions) {
                byte b = state[off + p];
                bits = (bits << 1) | ((b == colA || b == colB) ? 1 : 0);
            }
        }
        return toHex(bits, hexDigits);
    }

    /** Format an integer as zero-padded lowercase hex of the given width. */
    private static String toHex(int bits, int width) {
        char[] out = new char[width];
        for (int i = width - 1; i >= 0; i--) {
            int nib = bits & 0xf;
            out[i] = (char) (nib < 10 ? ('0' + nib) : ('a' + nib - 10));
            bits >>>= 4;
        }
        return new String(out);
    }

    private static void appendCentres(StringBuilder sb, String state, char face) {
        int off = Cube555.faceOffset(face);
        for (int p : CENTRE_POS) sb.append(state.charAt(off + p));
    }

    private static void appendPositions(StringBuilder sb, String state, char face, int[] positions) {
        int off = Cube555.faceOffset(face);
        for (int p : positions) sb.append(state.charAt(off + p));
    }
}
