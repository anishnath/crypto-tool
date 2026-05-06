package z.y.x.cube.kociemba;

import static z.y.x.cube.kociemba.CoordCube.*;

/**
 * Two-phase IDA* search — port of {@code search.c}.
 *
 * Phase 1 brings the cube to the H-subgroup (where U/D twist & flip
 * become 0 and the UD-slice is solved).  Phase 2 finishes from there.
 * Each phase runs IDA* with its own pruning tables.  The whole solver
 * is iterative, no recursion — uses {@code ax[]} (axis) and {@code po[]}
 * (power) arrays indexed by depth to track the current path.
 *
 * Constants:
 *  - ax[i]: face index 0..5 (U R F D L B) of the i-th move
 *  - po[i]: power 1..3 (= 90° / 180° / 270°)
 *  - move index = 3 * ax + po - 1, fed into the static move tables
 */
public final class Search {

    private static final int MAX_LEN = 32;

    private final int[] ax = new int[MAX_LEN];
    private final int[] po = new int[MAX_LEN];

    private final short[] flip   = new short[MAX_LEN];
    private final short[] twist  = new short[MAX_LEN];
    private final short[] parity = new short[MAX_LEN];
    private final short[] slice  = new short[MAX_LEN];
    private final short[] URFtoDLF = new short[MAX_LEN];
    private final short[] FRtoBR   = new short[MAX_LEN];
    private final short[] URtoUL   = new short[MAX_LEN];
    private final short[] UBtoDF   = new short[MAX_LEN];
    private final short[] URtoDF   = new short[MAX_LEN];

    private final int[] minDistPhase1 = new int[MAX_LEN];
    private final int[] minDistPhase2 = new int[MAX_LEN];

    /**
     * Solve a 54-character cube state.  Returns the move-string (e.g.
     * {@code "R U R' U' "}) or {@code null} on failure.  The caller
     * tokenises by splitting on whitespace.
     */
    public String solve(String facelets, int maxDepth, long timeOutSec, boolean useSeparator) {
        CoordCube.ensureInited();

        // Validate input.
        int[] count = new int[6];
        for (int i = 0; i < 54; i++) count[KEnums.charToColor(facelets.charAt(i))]++;
        for (int i = 0; i < 6; i++) {
            if (count[i] != 9) return null;
        }
        FaceCube fc = new FaceCube(facelets);
        CubieCube cc = fc.toCubieCube();
        int v = cc.verify();
        if (v == -2 || v == -4 || v == -5) return null;

        CoordCube c = CoordCube.fromCubie(cc);

        po[0] = 0; ax[0] = 0;
        flip[0]   = c.flip;
        twist[0]  = c.twist;
        parity[0] = c.parity;
        slice[0]  = (short) ((c.FRtoBR & 0xFFFF) / 24);
        URFtoDLF[0] = c.URFtoDLF;
        FRtoBR[0]   = c.FRtoBR;
        URtoUL[0]   = c.URtoUL;
        UBtoDF[0]   = c.UBtoDF;

        minDistPhase1[1] = 1;
        int n = 0, mv = 0;
        boolean busy = false;
        int depthPhase1 = 1;
        long tStart = System.currentTimeMillis() / 1000L;

        while (true) {
            do {
                if ((depthPhase1 - n > minDistPhase1[n + 1]) && !busy) {
                    if (ax[n] == 0 || ax[n] == 3) ax[++n] = 1;
                    else ax[++n] = 0;
                    po[n] = 1;
                } else if (++po[n] > 3) {
                    do {
                        if (++ax[n] > 5) {
                            if (System.currentTimeMillis() / 1000L - tStart > timeOutSec) return null;
                            if (n == 0) {
                                if (depthPhase1 >= maxDepth) return null;
                                depthPhase1++;
                                ax[n] = 0; po[n] = 1; busy = false; break;
                            } else { n--; busy = true; break; }
                        } else { po[n] = 1; busy = false; }
                    } while (n != 0 && (ax[n - 1] == ax[n] || ax[n - 1] - 3 == ax[n]));
                } else {
                    busy = false;
                }
            } while (busy);

            // compute new coordinates and minDistPhase1
            mv = 3 * ax[n] + po[n] - 1;
            flip[n + 1]  = twistMoveAt(flipMove, flip[n], mv);
            twist[n + 1] = twistMoveAt(twistMove, twist[n], mv);
            slice[n + 1] = (short) ((FRtoBR_Move[(slice[n] & 0xFFFF) * 24][mv] & 0xFFFF) / 24);
            int p1a = getPruning(Slice_Flip_Prun,
                N_SLICE1 * (flip[n + 1] & 0xFFFF) + (slice[n + 1] & 0xFFFF));
            int p1b = getPruning(Slice_Twist_Prun,
                N_SLICE1 * (twist[n + 1] & 0xFFFF) + (slice[n + 1] & 0xFFFF));
            minDistPhase1[n + 1] = Math.max(p1a, p1b);

            if (minDistPhase1[n + 1] == 0 && n >= depthPhase1 - 5) {
                minDistPhase1[n + 1] = 10;
                int s;
                if (n == depthPhase1 - 1 && (s = totalDepth(depthPhase1, maxDepth)) >= 0) {
                    if (s == depthPhase1
                        || (ax[depthPhase1 - 1] != ax[depthPhase1]
                            && ax[depthPhase1 - 1] != ax[depthPhase1] + 3)) {
                        return solutionToString(s, useSeparator ? depthPhase1 : -1);
                    }
                }
            }
        }
    }

    private static short twistMoveAt(short[][] table, short row, int col) {
        return table[row & 0xFFFF][col];
    }

    private int totalDepth(int depthPhase1, int maxDepth) {
        int mv, d1 = 0, d2 = 0;
        int maxDepthPhase2 = Math.min(10, maxDepth - depthPhase1);

        for (int i = 0; i < depthPhase1; i++) {
            mv = 3 * ax[i] + po[i] - 1;
            URFtoDLF[i + 1] = URFtoDLF_Move[URFtoDLF[i] & 0xFFFF][mv];
            FRtoBR[i + 1]   = FRtoBR_Move[FRtoBR[i] & 0xFFFF][mv];
            parity[i + 1]   = parityMove[parity[i]][mv];
        }
        d1 = getPruning(Slice_URFtoDLF_Parity_Prun,
            (N_SLICE2 * (URFtoDLF[depthPhase1] & 0xFFFF) + (FRtoBR[depthPhase1] & 0xFFFF)) * 2
            + parity[depthPhase1]);
        if (d1 > maxDepthPhase2) return -1;

        for (int i = 0; i < depthPhase1; i++) {
            mv = 3 * ax[i] + po[i] - 1;
            URtoUL[i + 1] = URtoUL_Move[URtoUL[i] & 0xFFFF][mv];
            UBtoDF[i + 1] = UBtoDF_Move[UBtoDF[i] & 0xFFFF][mv];
        }
        URtoDF[depthPhase1] = MergeURtoULandUBtoDF
            [URtoUL[depthPhase1] & 0xFFFF][UBtoDF[depthPhase1] & 0xFFFF];

        d2 = getPruning(Slice_URtoDF_Parity_Prun,
            (N_SLICE2 * (URtoDF[depthPhase1] & 0xFFFF) + (FRtoBR[depthPhase1] & 0xFFFF)) * 2
            + parity[depthPhase1]);
        if (d2 > maxDepthPhase2) return -1;

        if ((minDistPhase2[depthPhase1] = Math.max(d1, d2)) == 0) return depthPhase1;

        int depthPhase2 = 1;
        int n = depthPhase1;
        boolean busy = false;
        po[depthPhase1] = 0; ax[depthPhase1] = 0;
        minDistPhase2[n + 1] = 1;

        while (true) {
            do {
                if ((depthPhase1 + depthPhase2 - n > minDistPhase2[n + 1]) && !busy) {
                    if (ax[n] == 0 || ax[n] == 3) {
                        ax[++n] = 1;
                        po[n] = 2;
                    } else {
                        ax[++n] = 0;
                        po[n] = 1;
                    }
                } else {
                    boolean cond = (ax[n] == 0 || ax[n] == 3)
                        ? (++po[n] > 3)
                        : ((po[n] = po[n] + 2) > 3);
                    if (cond) {
                        do {
                            if (++ax[n] > 5) {
                                if (n == depthPhase1) {
                                    if (depthPhase2 >= maxDepthPhase2) return -1;
                                    depthPhase2++;
                                    ax[n] = 0; po[n] = 1; busy = false; break;
                                } else { n--; busy = true; break; }
                            } else {
                                po[n] = (ax[n] == 0 || ax[n] == 3) ? 1 : 2;
                                busy = false;
                            }
                        } while (n != depthPhase1 && (ax[n - 1] == ax[n] || ax[n - 1] - 3 == ax[n]));
                    } else {
                        busy = false;
                    }
                }
            } while (busy);

            mv = 3 * ax[n] + po[n] - 1;
            URFtoDLF[n + 1] = URFtoDLF_Move[URFtoDLF[n] & 0xFFFF][mv];
            FRtoBR[n + 1]   = FRtoBR_Move[FRtoBR[n] & 0xFFFF][mv];
            parity[n + 1]   = parityMove[parity[n]][mv];
            URtoDF[n + 1]   = URtoDF_Move[URtoDF[n] & 0xFFFF][mv];

            int p2a = getPruning(Slice_URtoDF_Parity_Prun,
                (N_SLICE2 * (URtoDF[n + 1] & 0xFFFF) + (FRtoBR[n + 1] & 0xFFFF)) * 2 + parity[n + 1]);
            int p2b = getPruning(Slice_URFtoDLF_Parity_Prun,
                (N_SLICE2 * (URFtoDLF[n + 1] & 0xFFFF) + (FRtoBR[n + 1] & 0xFFFF)) * 2 + parity[n + 1]);
            minDistPhase2[n + 1] = Math.max(p2a, p2b);

            if (minDistPhase2[n + 1] == 0) return depthPhase1 + depthPhase2;
        }
    }

    private String solutionToString(int length, int depthPhase1) {
        StringBuilder sb = new StringBuilder(length * 3 + 5);
        for (int i = 0; i < length; i++) {
            switch (ax[i]) {
                case 0: sb.append('U'); break;
                case 1: sb.append('R'); break;
                case 2: sb.append('F'); break;
                case 3: sb.append('D'); break;
                case 4: sb.append('L'); break;
                case 5: sb.append('B'); break;
            }
            switch (po[i]) {
                case 1: sb.append(' '); break;
                case 2: sb.append("2 "); break;
                case 3: sb.append("' "); break;
            }
            if (i == depthPhase1 - 1) sb.append(". ");
        }
        return sb.toString();
    }
}
