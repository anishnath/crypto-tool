package z.y.x.cube.cube444;

/**
 * Edge / wing geometry tables for the 4×4 — direct port of
 * {@code rubikscubennnsolver/RubiksCube444Misc.py} and the
 * {@code reduce333_orient_edges_tuples} field of
 * {@code rubikscubennnsolver/RubiksCube444.py}.
 *
 * The reference uses 1-indexed sticker positions throughout (its state
 * array reserves index 0 for a "dummy" sentinel).  Our Java state
 * strings are 0-indexed.  When porting tables we subtract 1 from every
 * sticker index so the Java values are directly usable as
 * {@code state.charAt(i)}.
 *
 * Origin notes (kept for traceability):
 *
 *   high_edges_444  — wings whose orientation in the solved state is
 *   "U" (high).  Each entry is (wing_id 0-23, sticker_a, sticker_b).
 *   12-23 are high edges, 0-11 are low.
 *
 *   See https://github.com/cs0x7f/TPR-4x4x4-Solver/blob/master/src/FullCube.java
 *   for the underlying convention.
 */
public final class Cube444Edges {

    private Cube444Edges() {}

    /**
     * Translate one Python ULFRBD 1-indexed sticker position to the
     * Java URFDLB 0-indexed equivalent.
     *
     *   Python face order: U L F R B D, each 16 stickers, 1-indexed
     *   Java   face order: U R F D L B, each 16 stickers, 0-indexed
     *
     * U/F faces sit at the same offset in both; L/R and B/D swap.
     */
    public static int pyUlfrbdToJavaUrfdlb(int pyPos) {
        int p = pyPos - 1;                  // 0-indexed
        int face = p / 16;                  // 0=U, 1=L, 2=F, 3=R, 4=B, 5=D
        int sub  = p % 16;
        // Map ULFRBD-face index → Java offset for that face.
        switch (face) {
            case 0: return  0 + sub;        // U
            case 1: return 64 + sub;        // L
            case 2: return 32 + sub;        // F
            case 3: return 16 + sub;        // R
            case 4: return 80 + sub;        // B
            case 5: return 48 + sub;        // D
            default: throw new IllegalArgumentException("bad py pos " + pyPos);
        }
    }

    /** {wing_id, sticker_a, sticker_b} triples for the 12 high edges.
     *  Sticker indices are 0-indexed (translated from Python ULFRBD). */
    public static final int[][] HIGH_EDGES = {
        // Upper
        {14, pyUlfrbdToJavaUrfdlb( 2), pyUlfrbdToJavaUrfdlb(67)},
        {13, pyUlfrbdToJavaUrfdlb( 9), pyUlfrbdToJavaUrfdlb(19)},
        {15, pyUlfrbdToJavaUrfdlb( 8), pyUlfrbdToJavaUrfdlb(51)},
        {12, pyUlfrbdToJavaUrfdlb(15), pyUlfrbdToJavaUrfdlb(35)},
        // Left
        {21, pyUlfrbdToJavaUrfdlb(25), pyUlfrbdToJavaUrfdlb(76)},
        {20, pyUlfrbdToJavaUrfdlb(24), pyUlfrbdToJavaUrfdlb(37)},
        // Right
        {23, pyUlfrbdToJavaUrfdlb(57), pyUlfrbdToJavaUrfdlb(44)},
        {22, pyUlfrbdToJavaUrfdlb(56), pyUlfrbdToJavaUrfdlb(69)},
        // Down
        {18, pyUlfrbdToJavaUrfdlb(82), pyUlfrbdToJavaUrfdlb(46)},
        {17, pyUlfrbdToJavaUrfdlb(89), pyUlfrbdToJavaUrfdlb(30)},
        {19, pyUlfrbdToJavaUrfdlb(88), pyUlfrbdToJavaUrfdlb(62)},
        {16, pyUlfrbdToJavaUrfdlb(95), pyUlfrbdToJavaUrfdlb(78)},
    };

    /** {wing_id, sticker_a, sticker_b} triples for the 12 low edges. */
    public static final int[][] LOW_EDGES = {
        // Upper
        { 2, pyUlfrbdToJavaUrfdlb( 3), pyUlfrbdToJavaUrfdlb(66)},
        { 1, pyUlfrbdToJavaUrfdlb( 5), pyUlfrbdToJavaUrfdlb(18)},
        { 3, pyUlfrbdToJavaUrfdlb(12), pyUlfrbdToJavaUrfdlb(50)},
        { 0, pyUlfrbdToJavaUrfdlb(14), pyUlfrbdToJavaUrfdlb(34)},
        // Left
        { 9, pyUlfrbdToJavaUrfdlb(21), pyUlfrbdToJavaUrfdlb(72)},
        { 8, pyUlfrbdToJavaUrfdlb(28), pyUlfrbdToJavaUrfdlb(41)},
        // Right
        {11, pyUlfrbdToJavaUrfdlb(53), pyUlfrbdToJavaUrfdlb(40)},
        {10, pyUlfrbdToJavaUrfdlb(60), pyUlfrbdToJavaUrfdlb(73)},
        // Down
        { 6, pyUlfrbdToJavaUrfdlb(83), pyUlfrbdToJavaUrfdlb(47)},
        { 5, pyUlfrbdToJavaUrfdlb(85), pyUlfrbdToJavaUrfdlb(31)},
        { 7, pyUlfrbdToJavaUrfdlb(92), pyUlfrbdToJavaUrfdlb(63)},
        { 4, pyUlfrbdToJavaUrfdlb(94), pyUlfrbdToJavaUrfdlb(79)},
    };

    /**
     * 48 (sticker_a, sticker_b) pairs iterated by {@code highlow_edges_state}
     * in the reference solver — port of
     * {@code RubiksCube444.reduce333_orient_edges_tuples}.
     *
     * Each wing contributes two entries (one per sticker side) so the
     * resulting orientation string is 48 characters long.  The order
     * matches the reference exactly so the lookup-table keys we compute
     * are identical.
     *
     * Stored as a flat int[] of length 96 (48 pairs × 2), 0-indexed:
     *   pairs[2*k + 0] = sticker_a (this side)
     *   pairs[2*k + 1] = sticker_b (partner side)
     */
    public static final int[] ORIENT_EDGE_PAIRS = {
        // 48 (sticker_a, sticker_b) pairs.  Already in Java URFDLB 0-indexed
        // — translated by scripts/extract-orient-pairs.py from the Python
        // source's ULFRBD 1-indexed positions.  See pyUlfrbdToJavaUrfdlb().
        //
        // Don't hand-edit; regenerate from the Python source if it changes.
        //
        // Faces in iteration order (Python ULFRBD): U L F R B D.
        //
        //   U-side:                                              L-side:
         1, 82,   2, 81,   4, 65,   7, 18,    8, 66,  11, 17,   13, 33,  14, 34,
        65,  4,  66,  8,  68, 87,  71, 36,   72, 91,  75, 40,   77, 56,  78, 52,
        //   F-side:                                              R-side:
        33, 13,  34, 14,  36, 71,  39, 20,   40, 75,  43, 24,   45, 49,  46, 50,
        17, 11,  18,  7,  20, 39,  23, 84,   24, 43,  27, 88,   29, 55,  30, 59,
        //   B-side:                                              D-side:
        81,  2,  82,  1,  84, 23,  87, 68,   88, 27,  91, 72,   93, 62,  94, 61,
        49, 45,  50, 46,  52, 78,  55, 29,   56, 77,  59, 30,   61, 94,  62, 93,
    };

    /** Number of (a, b) pairs in {@link #ORIENT_EDGE_PAIRS}.  Always 48 for 4×4. */
    public static final int ORIENT_PAIR_COUNT = ORIENT_EDGE_PAIRS.length / 2;
}
