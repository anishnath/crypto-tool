package z.y.x.cube.kociemba;

/**
 * Enums shared by the Kociemba two-phase solver — port of
 * {@code color.h}, {@code corner.h}, {@code edge.h}, {@code facelet.h}
 * from {@code github.com/dwalton76/kociemba/ckociemba}.
 *
 * Kociemba's algorithm operates on three views of cube state:
 *   1. Facelet:   54 stickers in fixed positions (URFDLB face order).
 *   2. Cubie:     8 corner cubies + 12 edge cubies, each with permutation
 *                 (where it is) + orientation (which way it's twisted).
 *   3. Coord:     compressed integer coordinates over the cubie state,
 *                 used for fast IDA* lookup against precomputed tables.
 *
 * This file holds the shared enum constants.  The bulk of the work
 * (FaceCube, CubieCube, CoordCube, Search) lives in adjacent files.
 *
 * Java enums vs C int constants: we use {@code public static final int}
 * because the surrounding algorithms use these as array indices.
 * Stronger Java enums would force {@code .ordinal()} calls on every
 * use and slow down the hot path.
 */
public final class KEnums {

    private KEnums() {}

    /* ─── Color (face) ─────────────────────────────────── */

    public static final int U = 0;
    public static final int R = 1;
    public static final int F = 2;
    public static final int D = 3;
    public static final int L = 4;
    public static final int B = 5;
    public static final int COLOR_COUNT = 6;

    /* ─── Corner positions (8) ─────────────────────────── */

    public static final int URF = 0;
    public static final int UFL = 1;
    public static final int ULB = 2;
    public static final int UBR = 3;
    public static final int DFR = 4;
    public static final int DLF = 5;
    public static final int DBL = 6;
    public static final int DRB = 7;
    public static final int CORNER_COUNT = 8;

    /* ─── Edge positions (12) ──────────────────────────── */

    public static final int UR = 0;
    public static final int UF = 1;
    public static final int UL = 2;
    public static final int UB = 3;
    public static final int DR = 4;
    public static final int DF = 5;
    public static final int DL = 6;
    public static final int DB = 7;
    public static final int FR = 8;
    public static final int FL = 9;
    public static final int BL = 10;
    public static final int BR = 11;
    public static final int EDGE_COUNT = 12;

    /* ─── Facelet positions (54) ───────────────────────── */

    public static final int U1 = 0,  U2 = 1,  U3 = 2,  U4 = 3,  U5 = 4,  U6 = 5,  U7 = 6,  U8 = 7,  U9 = 8;
    public static final int R1 = 9,  R2 = 10, R3 = 11, R4 = 12, R5 = 13, R6 = 14, R7 = 15, R8 = 16, R9 = 17;
    public static final int F1 = 18, F2 = 19, F3 = 20, F4 = 21, F5 = 22, F6 = 23, F7 = 24, F8 = 25, F9 = 26;
    public static final int D1 = 27, D2 = 28, D3 = 29, D4 = 30, D5 = 31, D6 = 32, D7 = 33, D8 = 34, D9 = 35;
    public static final int L1 = 36, L2 = 37, L3 = 38, L4 = 39, L5 = 40, L6 = 41, L7 = 42, L8 = 43, L9 = 44;
    public static final int B1 = 45, B2 = 46, B3 = 47, B4 = 48, B5 = 49, B6 = 50, B7 = 51, B8 = 52, B9 = 53;
    public static final int FACELET_COUNT = 54;

    /** Map enum int → ASCII char (for readable diagnostics). */
    public static char colorChar(int c) {
        switch (c) {
            case U: return 'U';
            case R: return 'R';
            case F: return 'F';
            case D: return 'D';
            case L: return 'L';
            case B: return 'B';
            default: throw new IllegalArgumentException("bad color " + c);
        }
    }

    public static int charToColor(char ch) {
        switch (ch) {
            case 'U': return U;
            case 'R': return R;
            case 'F': return F;
            case 'D': return D;
            case 'L': return L;
            case 'B': return B;
            default: throw new IllegalArgumentException("bad color char '" + ch + "'");
        }
    }
}
