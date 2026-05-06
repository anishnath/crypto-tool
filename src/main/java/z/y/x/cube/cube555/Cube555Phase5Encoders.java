package z.y.x.cube.cube555;

/**
 * Phase 5 prune-table state encoders.  Mirrors Python's
 * {@code LookupTable555Phase5Centers.state} (step51) and
 * {@code LookupTable555Phase5FBCenters.state} (step56).
 *
 * <p>This file currently covers the two centre-only encoders — the
 * straightforward ones.  The high-edge-midge (step53) and
 * low-edge-midge (step54) encoders depend on
 * {@code edges_recolor_pattern_555} and the
 * {@link HighLowEdges555} table; they live in a separate file added
 * alongside the phase 5 IDA* domain.
 *
 * <p>All position arrays below are translated from Python ULFRBD
 * 1-indexed to Java URFDLB 0-indexed via the standard mapping in
 * {@link #py(int)}.
 */
public final class Cube555Phase5Encoders {

    private Cube555Phase5Encoders() {}

    private static int py(int p) {
        p -= 1;
        if (p < 25)  return p;
        if (p < 50)  return p + 75;
        if (p < 75)  return p;
        if (p < 100) return p - 50;
        if (p < 125) return p + 25;
        return p - 50;
    }

    private static int[] arr(int... pyPositions) {
        int[] out = new int[pyPositions.length];
        for (int i = 0; i < pyPositions.length; i++) out[i] = py(pyPositions[i]);
        return out;
    }

    /** {@code LFRB_centers_555} — 36 positions (9 inner-3×3 stickers per
     *  L, F, R, B face).  Used by the step51 phase5-centres encoder. */
    public static final int[] LFRB_CENTERS = arr(
        32, 33, 34, 37, 38, 39, 42, 43, 44,
        57, 58, 59, 62, 63, 64, 67, 68, 69,
        82, 83, 84, 87, 88, 89, 92, 93, 94,
        107, 108, 109, 112, 113, 114, 117, 118, 119);

    /** {@code FB_centers_555} — 18 positions (9 inner-3×3 stickers per
     *  F, B face).  Used by the step56 phase5-fb-centres encoder. */
    public static final int[] FB_CENTERS = arr(
        57, 58, 59, 62, 63, 64, 67, 68, 69,
        107, 108, 109, 112, 113, 114, 117, 118, 119);

    /** Encode the step51 phase5-centres key — 36 chars from L/F/R/B
     *  inner stickers in Python's order. */
    public static String encodeLFRBCenters(String state) {
        StringBuilder sb = new StringBuilder(36);
        for (int p : LFRB_CENTERS) sb.append(state.charAt(p));
        return sb.toString();
    }

    public static String encodeLFRBCentersBytes(byte[] state) {
        char[] out = new char[LFRB_CENTERS.length];
        for (int i = 0; i < LFRB_CENTERS.length; i++) out[i] = (char) (state[LFRB_CENTERS[i]] & 0xFF);
        return new String(out);
    }

    /** Encode the step56 phase5-fb-centres key — 18 chars from F/B
     *  inner stickers in Python's order. */
    public static String encodeFBCenters(String state) {
        StringBuilder sb = new StringBuilder(18);
        for (int p : FB_CENTERS) sb.append(state.charAt(p));
        return sb.toString();
    }

    public static String encodeFBCentersBytes(byte[] state) {
        char[] out = new char[FB_CENTERS.length];
        for (int i = 0; i < FB_CENTERS.length; i++) out[i] = (char) (state[FB_CENTERS[i]] & 0xFF);
        return new String(out);
    }

    /* ── High/low edge-midge encoders (step53 / step54) ──────────── */

    /** {@code wings_for_edges_pattern_555} — 36 wing positions in
     *  Python's order, used as the projection for the high/low encoders. */
    public static final int[] WINGS_FOR_PATTERN = arr(
        2, 3, 4, 6, 11, 16, 10, 15, 20, 22, 23, 24,
        31, 36, 41, 35, 40, 45,
        81, 86, 91, 85, 90, 95,
        127, 128, 129, 131, 136, 141, 135, 140, 145, 147, 148, 149);

    /** {@code high_wings_and_midges_555} — 24 positions identifying
     *  wings + midges on the "high" side of each edge cubie. */
    public static final int[] HIGH_WINGS_AND_MIDGES = arr(
        2, 3, 11, 16, 10, 15, 23, 24,
        36, 41, 35, 40,
        86, 91, 85, 90,
        127, 128, 136, 141, 135, 140, 148, 149);

    /** {@code low_wings_and_midges_555} — 24 positions identifying
     *  wings + midges on the "low" side of each edge cubie. */
    public static final int[] LOW_WINGS_AND_MIDGES = arr(
        3, 4, 6, 11, 15, 20, 22, 23,
        31, 36, 40, 45,
        81, 86, 90, 95,
        128, 129, 131, 136, 140, 145, 147, 148);

    private static final java.util.Set<Integer> HIGH_SET = toSet(HIGH_WINGS_AND_MIDGES);
    private static final java.util.Set<Integer> LOW_SET  = toSet(LOW_WINGS_AND_MIDGES);

    private static java.util.Set<Integer> toSet(int[] xs) {
        java.util.Set<Integer> s = new java.util.HashSet<>(xs.length * 2);
        for (int x : xs) s.add(x);
        return s;
    }

    /**
     * Encode the step53 phase5-high-edge-and-midge key.
     *
     * <p>Recolour the cube's edges (filtering by {@code wingStrs}) then
     * project to {@link #WINGS_FOR_PATTERN} positions: emit '-' for any
     * position not in {@link #HIGH_WINGS_AND_MIDGES} OR whose recoloured
     * value is '.'; otherwise emit the recoloured letter.
     *
     * <p>Goal for default {@code wingStrs = {LB,LF,RB,RF}}:
     * {@code "-------------SSTT--UUVV-------------"}.
     */
    public static String encodeHighEdgeMidge(String state, java.util.Set<String> wingStrs) {
        char[] r = Cube555EdgeRecolor.recolor(state, wingStrs);
        char[] out = new char[WINGS_FOR_PATTERN.length];
        for (int i = 0; i < WINGS_FOR_PATTERN.length; i++) {
            int p = WINGS_FOR_PATTERN[i];
            char c = r[p];
            out[i] = (c == '.' || !HIGH_SET.contains(p)) ? '-' : c;
        }
        return new String(out);
    }

    /**
     * Encode the step54 phase5-low-edge-and-midge key.
     *
     * <p>Same as {@link #encodeHighEdgeMidge} but projects to
     * {@link #LOW_WINGS_AND_MIDGES} positions.
     */
    public static String encodeLowEdgeMidge(String state, java.util.Set<String> wingStrs) {
        char[] r = Cube555EdgeRecolor.recolor(state, wingStrs);
        char[] out = new char[WINGS_FOR_PATTERN.length];
        for (int i = 0; i < WINGS_FOR_PATTERN.length; i++) {
            int p = WINGS_FOR_PATTERN[i];
            char c = r[p];
            out[i] = (c == '.' || !LOW_SET.contains(p)) ? '-' : c;
        }
        return new String(out);
    }

    public static String encodeHighEdgeMidgeBytes(byte[] state, java.util.Set<String> wingStrs) {
        return encodeHighEdgeMidge(Cube555Bytes.toString(state), wingStrs);
    }

    public static String encodeLowEdgeMidgeBytes(byte[] state, java.util.Set<String> wingStrs) {
        return encodeLowEdgeMidge(Cube555Bytes.toString(state), wingStrs);
    }
}
