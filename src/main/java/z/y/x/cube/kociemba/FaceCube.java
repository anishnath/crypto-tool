package z.y.x.cube.kociemba;

import static z.y.x.cube.kociemba.KEnums.*;

/**
 * 54-facelet cube state — port of {@code facecube.c}.
 *
 * Input parser for Kociemba's two-phase: takes a 54-character string
 * in URFDLB face order and converts to facelet ints, then from there
 * to a {@link CubieCube} for the actual algorithm.
 *
 * Cube definition string format (matches the Kociemba C reference):
 *   "UUUUUUUUU" + "RRRRRRRRR" + "FFFFFFFFF"
 * + "DDDDDDDDD" + "LLLLLLLLL" + "BBBBBBBBB"  → solved cube
 *
 * Each character is the COLOR (= face label) of the sticker at that
 * facelet position.  See {@link KEnums} for the facelet numbering.
 */
public final class FaceCube {

    /* Cubie-corner / cubie-edge constituent facelet positions.  Order
     * within each cubie matters: corner row 0 is the U/D facelet,
     * row 1 is "next clockwise", row 2 is "two clockwise".  Edge row 0
     * is the higher-priority face. */
    public static final int[][] cornerFacelet = {
        {U9, R1, F3}, {U7, F1, L3}, {U1, L1, B3}, {U3, B1, R3},
        {D3, F9, R7}, {D1, L9, F7}, {D7, B9, L7}, {D9, R9, B7},
    };
    public static final int[][] edgeFacelet = {
        {U6, R2}, {U8, F2}, {U4, L2}, {U2, B2},
        {D6, R8}, {D2, F8}, {D4, L8}, {D8, B8},
        {F6, R4}, {F4, L6}, {B6, L4}, {B4, R6},
    };
    public static final int[][] cornerColor = {
        {U, R, F}, {U, F, L}, {U, L, B}, {U, B, R},
        {D, F, R}, {D, L, F}, {D, B, L}, {D, R, B},
    };
    public static final int[][] edgeColor = {
        {U, R}, {U, F}, {U, L}, {U, B},
        {D, R}, {D, F}, {D, L}, {D, B},
        {F, R}, {F, L}, {B, L}, {B, R},
    };

    /** 54 facelet color values. */
    public final int[] f = new int[FACELET_COUNT];

    /** Construct the solved-cube state. */
    public FaceCube() {
        int[] solved = {
            U, U, U, U, U, U, U, U, U,
            R, R, R, R, R, R, R, R, R,
            F, F, F, F, F, F, F, F, F,
            D, D, D, D, D, D, D, D, D,
            L, L, L, L, L, L, L, L, L,
            B, B, B, B, B, B, B, B, B,
        };
        System.arraycopy(solved, 0, this.f, 0, FACELET_COUNT);
    }

    /** Parse a 54-char URFDLB face string into a FaceCube. */
    public FaceCube(String cubeString) {
        if (cubeString.length() != FACELET_COUNT) {
            throw new IllegalArgumentException(
                "expected 54 chars, got " + cubeString.length());
        }
        for (int i = 0; i < FACELET_COUNT; i++) {
            f[i] = charToColor(cubeString.charAt(i));
        }
    }

    /** Render as the same 54-char string format. */
    public String toFaceString() {
        char[] out = new char[FACELET_COUNT];
        for (int i = 0; i < FACELET_COUNT; i++) out[i] = colorChar(f[i]);
        return new String(out);
    }

    /**
     * Convert this facelet view to the cubie view used by the algorithm.
     * For each corner / edge cubie POSITION (one of 8 / 12), figure out
     * which CUBIE PIECE is there + its orientation, by matching colors.
     *
     * If the input cube isn't a valid colour-set, some cp/ep slots will
     * remain at their initial sentinel values (URF / UR).  CubieCube's
     * verify() catches that.
     */
    public CubieCube toCubieCube() {
        CubieCube cc = new CubieCube();
        // Sentinels indicating "not yet identified".
        for (int i = 0; i < CORNER_COUNT; i++) cc.cp[i] = URF;
        for (int i = 0; i < EDGE_COUNT;   i++) cc.ep[i] = UR;

        for (int i = 0; i < CORNER_COUNT; i++) {
            // Find which of the 3 corner facelets is U or D — that's
            // the orientation reference.
            int ori;
            for (ori = 0; ori < 3; ori++) {
                int facelet = f[cornerFacelet[i][ori]];
                if (facelet == U || facelet == D) break;
            }
            int col1 = f[cornerFacelet[i][(ori + 1) % 3]];
            int col2 = f[cornerFacelet[i][(ori + 2) % 3]];
            for (int j = 0; j < CORNER_COUNT; j++) {
                if (col1 == cornerColor[j][1] && col2 == cornerColor[j][2]) {
                    cc.cp[i] = (byte) j;
                    cc.co[i] = (byte) (ori % 3);
                    break;
                }
            }
        }

        for (int i = 0; i < EDGE_COUNT; i++) {
            for (int j = 0; j < EDGE_COUNT; j++) {
                int e0 = f[edgeFacelet[i][0]];
                int e1 = f[edgeFacelet[i][1]];
                if (e0 == edgeColor[j][0] && e1 == edgeColor[j][1]) {
                    cc.ep[i] = (byte) j;
                    cc.eo[i] = (byte) 0;
                    break;
                }
                if (e0 == edgeColor[j][1] && e1 == edgeColor[j][0]) {
                    cc.ep[i] = (byte) j;
                    cc.eo[i] = (byte) 1;
                    break;
                }
            }
        }
        return cc;
    }
}
