package z.y.x.cube.cube555;

/**
 * 5×5 edge-orientation tables and encoders.
 *
 * <p>{@link #ORIENT_EDGE_PAIRS} ports Python's
 * {@code reduce333_orient_edges_tuples} (72 (a, b) sticker-index pairs)
 * into Java URFDLB 0-indexed positions.  These are the 24 wings plus
 * 12 midges of a 5×5, each represented by both of its stickers (so 36
 * cubies × 2 = 72 entries; but stored as 72 directional pairs since the
 * Python table has each edge in both directions).
 *
 * <p>{@link #OUTER_ORBIT_INDICES} is a 48-element subset that picks the
 * outer-orbit wing entries from the 72-character {@link #highlowEdges}
 * result — used for the step902 lookup.  The 24 omitted indices are
 * the midge entries (used by step903).
 *
 * <h2>Encoder</h2>
 *
 * {@link #highlowEdges(String)} computes the 72-character orientation
 * string by looking up each {@code (a, b, state[a], state[b])} entry in
 * {@link HighLowEdges555}.  The result is a sequence of 'U' / 'D' (or
 * '.' for stickers that aren't part of a valid edge pair given the
 * current cube state).
 */
public final class Cube555Edges {

    private Cube555Edges() {}

    /** 72 (sticker_a, sticker_b) tuples — translated from Python's
     *  {@code reduce333_orient_edges_tuples} into Java URFDLB indexing. */
    public static final int[][] ORIENT_EDGE_PAIRS = {
        {  1, 128}, {  2, 127}, {  3, 126}, {  5, 101}, {  9,  28}, { 10, 102},
        { 14,  27}, { 15, 103}, { 19,  26}, { 21,  51}, { 22,  52}, { 23,  53},
        {101,   5}, {102,  10}, {103,  15}, {105, 134}, {109,  55}, {110, 139},
        {114,  60}, {115, 144}, {119,  65}, {121,  90}, {122,  85}, {123,  80},
        { 51,  21}, { 52,  22}, { 53,  23}, { 55, 109}, { 59,  30}, { 60, 114},
        { 64,  35}, { 65, 119}, { 69,  40}, { 71,  76}, { 72,  77}, { 73,  78},
        { 26,  19}, { 27,  14}, { 28,   9}, { 30,  59}, { 34, 130}, { 35,  64},
        { 39, 135}, { 40,  69}, { 44, 140}, { 46,  84}, { 47,  89}, { 48,  94},
        {126,   3}, {127,   2}, {128,   1}, {130,  34}, {134, 105}, {135,  39},
        {139, 110}, {140,  44}, {144, 115}, {146,  98}, {147,  97}, {148,  96},
        { 76,  71}, { 77,  72}, { 78,  73}, { 80, 123}, { 84,  46}, { 85, 122},
        { 89,  47}, { 90, 121}, { 94,  48}, { 96, 148}, { 97, 147}, { 98, 146},
    };

    public static final int ORIENT_PAIR_COUNT = ORIENT_EDGE_PAIRS.length;   // 72

    /** Indices into the 72-char highlow string that pick the OUTER orbit
     *  (24 wings × 2 sides = 48 entries).  Used to build the step902 key. */
    public static final int[] OUTER_ORBIT_INDICES = {
         0,  2,  3,  4,  7,  8,  9,
        11, 12, 14, 15, 16, 19, 20,
        21, 23, 24, 26, 27, 28, 31,
        32, 33, 35, 36, 38, 39, 40,
        43, 44, 45, 47, 48, 50, 51,
        52, 55, 56, 57, 59, 60, 62,
        63, 64, 67, 68, 69, 71,
    };

    /** Indices into the 72-char highlow string that pick the INNER orbit
     *  (midges, 24 entries).  Complement of {@link #OUTER_ORBIT_INDICES}. */
    public static final int[] INNER_ORBIT_INDICES = {
         1,  5,  6, 10, 13, 17, 18, 22,
        25, 29, 30, 34, 37, 41, 42, 46,
        49, 53, 54, 58, 61, 65, 66, 70,
    };

    /**
     * Compute the 72-character high/low orientation string for a
     * complete 5×5 cube state.  Mirrors Python's
     * {@code RubiksCube555.highlow_edges_state}.
     */
    public static String highlowEdges(String state) {
        if (state.length() != Cube555.TOTAL_STICKERS) {
            throw new IllegalArgumentException(
                "state length " + state.length() + " ≠ 150");
        }
        char[] out = new char[ORIENT_PAIR_COUNT];
        for (int k = 0; k < ORIENT_PAIR_COUNT; k++) {
            int a = ORIENT_EDGE_PAIRS[k][0];
            int b = ORIENT_EDGE_PAIRS[k][1];
            char ca = state.charAt(a);
            char cb = state.charAt(b);
            out[k] = HighLowEdges555.lookup(a, b, ca, cb);
        }
        return new String(out);
    }

    public static String highlowEdgesBytes(byte[] state) {
        if (state.length != Cube555.TOTAL_STICKERS) {
            throw new IllegalArgumentException(
                "state length " + state.length + " ≠ 150");
        }
        char[] out = new char[ORIENT_PAIR_COUNT];
        for (int k = 0; k < ORIENT_PAIR_COUNT; k++) {
            int a = ORIENT_EDGE_PAIRS[k][0];
            int b = ORIENT_EDGE_PAIRS[k][1];
            char ca = (char) (state[a] & 0xFF);
            char cb = (char) (state[b] & 0xFF);
            out[k] = HighLowEdges555.lookup(a, b, ca, cb);
        }
        return new String(out);
    }

    /** Build the 48-character step902 (EO outer orbit) key. */
    public static String encodeEOOuter(String state) {
        String hl = highlowEdges(state);
        char[] out = new char[OUTER_ORBIT_INDICES.length];
        for (int i = 0; i < OUTER_ORBIT_INDICES.length; i++) out[i] = hl.charAt(OUTER_ORBIT_INDICES[i]);
        return new String(out);
    }

    public static String encodeEOOuterBytes(byte[] state) {
        String hl = highlowEdgesBytes(state);
        char[] out = new char[OUTER_ORBIT_INDICES.length];
        for (int i = 0; i < OUTER_ORBIT_INDICES.length; i++) out[i] = hl.charAt(OUTER_ORBIT_INDICES[i]);
        return new String(out);
    }

    /* ─────────────────────────────────────────────────────────────────
     *  EO inner-orbit (midge) encoder
     *
     *  Mirrors Python's LookupTable555EdgeOrientInnerOrbit.state().
     *
     *  For each of the 12 midges, look up its two-sticker colour pair.
     *  If the unordered pair {colourA, colourB} is one of the 12 valid
     *  cube-edge colour pairs (no opposite-face combinations like UD,
     *  LR, FB), the midge is in a "recognised" orientation → mark both
     *  of its stickers 'U'.  Otherwise → mark both 'D'.
     *
     *  The encoded state is the 24 U/D characters at the 24 midge
     *  sticker positions, in Python's midge_indexes order.
     *
     *  Goal state for step903 lookup table: 24 U's (all midges in
     *  recognised orientation).
     * ──────────────────────────────────────────────────────────────── */

    /** 12 midges, Java URFDLB indexed.  Each entry is one direction of
     *  Python's MIDGE_TUPLES_555 (the second direction is the same midge
     *  with stickers swapped — we don't need it because our orientation
     *  check is unordered).  Faces in U-L-F-R-B-D order. */
    public static final int[][] MIDGE_AB_PAIRS = {
        {  2, 127},     // Upper-Back
        { 10, 102},     // Upper-Left
        { 14,  27},     // Upper-Right
        { 22,  52},     // Upper-Front
        {110, 139},     // Left-Back
        {114,  60},     // Left-Front (paired)
        { 35,  64},     // Right-Front
        { 39, 135},     // Right-Back
        { 77,  72},     // Down-Back? actually Python D-B
        { 85, 122},     // Down-Left? Python D-L
        { 89,  47},     // Down-Right? Python D-R
        { 97, 147},     // Down-Front? Python D-F
    };

    /** 24 midge sticker positions (one per midge sticker, both sides
     *  of all 12 midges) — Python midge_indexes translated to Java
     *  URFDLB.  Order matches Python (U L F R B D blocks). */
    public static final int[] MIDGE_INDICES = {
          2,  10,  14,  22,    // Upper
        102, 110, 114, 122,    // Left  (Python L offset 25 → Java L offset 100)
         52,  60,  64,  72,    // Front
         27,  35,  39,  47,    // Right (Python R offset 75 → Java R offset 25)
        127, 135, 139, 147,    // Back
         77,  85,  89,  97,    // Down  (Python D offset 125 → Java D offset 75)
    };

    /** The 12 canonical cube-edge colour pairs, ORDER-SENSITIVE.  These
     *  are exactly the 12 entries Python's {@code midge_states} dict
     *  treats as "good orientation".  A midge whose ordered pair
     *  {@code state[a] + state[b]} matches one of these is 'U'; the
     *  reversed pair (e.g. "BU" instead of "UB") would mean the midge
     *  is flipped → 'D'. */
    private static boolean isCanonicalMidgePair(char a, char b) {
        // The 12 valid pairs: UB UL UR UF LB LF RB RF DB DL DR DF.
        switch (a) {
            case 'U': return b == 'B' || b == 'L' || b == 'R' || b == 'F';
            case 'L': return b == 'B' || b == 'F';
            case 'R': return b == 'B' || b == 'F';
            case 'D': return b == 'B' || b == 'L' || b == 'R' || b == 'F';
            default:  return false;
        }
    }

    /** Compute the 24-character inner-orbit (midge) encoding. */
    public static String encodeEOInner(String state) {
        char[] out = new char[MIDGE_INDICES.length];
        // Build a position → orientation char map (24 entries).
        // For each midge tuple, compute orientation, fill both positions.
        java.util.Map<Integer, Character> orient = new java.util.HashMap<>(24);
        for (int[] pair : MIDGE_AB_PAIRS) {
            int a = pair[0], b = pair[1];
            char ca = state.charAt(a), cb = state.charAt(b);
            char hl = isCanonicalMidgePair(ca, cb) ? 'U' : 'D';
            orient.put(a, hl);
            orient.put(b, hl);
        }
        for (int i = 0; i < MIDGE_INDICES.length; i++) {
            Character c = orient.get(MIDGE_INDICES[i]);
            out[i] = c == null ? '.' : c;
        }
        return new String(out);
    }

    public static String encodeEOInnerBytes(byte[] state) {
        char[] out = new char[MIDGE_INDICES.length];
        java.util.Map<Integer, Character> orient = new java.util.HashMap<>(24);
        for (int[] pair : MIDGE_AB_PAIRS) {
            int a = pair[0], b = pair[1];
            char ca = (char) (state[a] & 0xFF);
            char cb = (char) (state[b] & 0xFF);
            char hl = isCanonicalMidgePair(ca, cb) ? 'U' : 'D';
            orient.put(a, hl);
            orient.put(b, hl);
        }
        for (int i = 0; i < MIDGE_INDICES.length; i++) {
            Character c = orient.get(MIDGE_INDICES[i]);
            out[i] = c == null ? '.' : c;
        }
        return new String(out);
    }
}
