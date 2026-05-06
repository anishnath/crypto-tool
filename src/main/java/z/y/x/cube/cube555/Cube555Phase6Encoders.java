package z.y.x.cube.cube555;

import java.util.Set;

/**
 * Phase 6 prune-table state encoders.  Mirrors Python's
 * {@code LookupTable555Phase6Centers.state} (step61) and the high/low
 * edge encoders (step62, step63).
 *
 * <p>The high/low edge encoders share the same logic as phase 5's but
 * use a different default {@code wing_strs} (the 8 U/D edges instead
 * of the 4 LR edges) — they reuse {@link Cube555Phase5Encoders}'s
 * methods directly.
 */
public final class Cube555Phase6Encoders {

    private Cube555Phase6Encoders() {}

    private static int py(int p) {
        p -= 1;
        if (p < 25)  return p;
        if (p < 50)  return p + 75;
        if (p < 75)  return p;
        if (p < 100) return p - 50;
        if (p < 125) return p + 25;
        return p - 50;
    }

    /** {@code centers_555} — all 54 centre positions (9 × 6 faces).
     *  The phase 6 centres encoder reads all of them in U-L-F-R-B-D
     *  order (Python's), producing a 54-char goal state {@code
     *  "UUUUUUUUULLLLLLLLLFFFFFFFFFRRRRRRRRRBBBBBBBBBDDDDDDDDD"}. */
    public static final int[] CENTERS = build();

    private static int[] build() {
        int[] out = new int[54];
        int i = 0;
        // Python's centers_555 is in ULFRBD order, so iterate in that order.
        char[] py_faces = {'U', 'L', 'F', 'R', 'B', 'D'};
        // Python centres are facePos 7,8,9,12,13,14,17,18,19 (1-indexed within face).
        int[][] pyCentres = {
            { 7,  8,  9, 12, 13, 14, 17, 18, 19},   // U: positions 7-19 within U face
            {32, 33, 34, 37, 38, 39, 42, 43, 44},   // L: 32-44
            {57, 58, 59, 62, 63, 64, 67, 68, 69},   // F: 57-69
            {82, 83, 84, 87, 88, 89, 92, 93, 94},   // R: 82-94
            {107,108,109,112,113,114,117,118,119},  // B: 107-119
            {132,133,134,137,138,139,142,143,144},  // D: 132-144
        };
        void_unused(py_faces);
        for (int[] face : pyCentres) for (int p : face) out[i++] = py(p);
        return out;
    }
    private static void void_unused(Object x) { /* keep py_faces as documentation */ }

    /** Encode the step61 phase6-centres key (54 chars in ULFRBD order). */
    public static String encodeCenters(String state) {
        StringBuilder sb = new StringBuilder(54);
        for (int p : CENTERS) sb.append(state.charAt(p));
        return sb.toString();
    }

    public static String encodeCentersBytes(byte[] state) {
        char[] out = new char[CENTERS.length];
        for (int i = 0; i < CENTERS.length; i++) out[i] = (char) (state[CENTERS[i]] & 0xFF);
        return new String(out);
    }

    /** High-edge-midge encoder — same as phase 5's but for 8 wings.
     *  Goal for default wing_strs (UB,UL,UR,UF,DB,DL,DR,DF):
     *  {@code "OO--PPQQ--RR------------WW--XXYY--ZZ"}. */
    public static String encodeHighEdgeMidge(String state, Set<String> wingStrs) {
        return Cube555Phase5Encoders.encodeHighEdgeMidge(state, wingStrs);
    }

    /** Low-edge-midge encoder — same as phase 5's but for 8 wings.
     *  Goal: {@code "-OopP--QqrR--------------WwxX--YyzZ-"}. */
    public static String encodeLowEdgeMidge(String state, Set<String> wingStrs) {
        return Cube555Phase5Encoders.encodeLowEdgeMidge(state, wingStrs);
    }
}
