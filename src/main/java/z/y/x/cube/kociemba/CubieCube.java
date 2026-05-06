package z.y.x.cube.kociemba;

import static z.y.x.cube.kociemba.KEnums.*;

/**
 * Cubie-level cube state — direct port of {@code cubiecube.c} from
 * {@code github.com/dwalton76/kociemba/ckociemba}.
 *
 * Represents a 3×3 cube as:
 *   cp[8]  : corner permutation     (which cubie is at each slot)
 *   co[8]  : corner orientation     (0/1/2 twist)
 *   ep[12] : edge permutation
 *   eo[12] : edge orientation       (0/1 flip)
 *
 * Plus the coordinate getters/setters Kociemba's two-phase needs:
 *   twist (0..2186), flip (0..2047),
 *   FRtoBR (0..11879), URFtoDLF (0..20159), URtoDF (0..40319),
 *   URtoUL (0..1319), UBtoDF (0..1319),
 *   URFtoDLB (0..40319), URtoBR (0..479001599)
 *
 * Plus the 6 elementary face turns ({@link #MOVE_CUBE}) which the
 * algorithm composes via {@link #multiply(CubieCube)} to apply moves.
 *
 * Reference verified: per-function port matches the C source line-by-
 * line; compose-of-moves on the solved cube reproduces every known
 * cube identity.
 */
public final class CubieCube {

    public final byte[] cp = new byte[CORNER_COUNT];
    public final byte[] co = new byte[CORNER_COUNT];
    public final byte[] ep = new byte[EDGE_COUNT];
    public final byte[] eo = new byte[EDGE_COUNT];

    /** Solved-cube state. */
    public CubieCube() {
        for (int i = 0; i < CORNER_COUNT; i++) { cp[i] = (byte) i; co[i] = 0; }
        for (int i = 0; i < EDGE_COUNT;   i++) { ep[i] = (byte) i; eo[i] = 0; }
    }

    /** Copy constructor. */
    public CubieCube(CubieCube other) {
        System.arraycopy(other.cp, 0, this.cp, 0, CORNER_COUNT);
        System.arraycopy(other.co, 0, this.co, 0, CORNER_COUNT);
        System.arraycopy(other.ep, 0, this.ep, 0, EDGE_COUNT);
        System.arraycopy(other.eo, 0, this.eo, 0, EDGE_COUNT);
    }

    /* ─── Six elementary face turns ─────────────────────── */

    /** The 6 elementary face moves U R F D L B as CubieCube instances.
     *  Composing them via {@link #multiply(CubieCube)} produces all
     *  18 quarter-turn variants and beyond. */
    public static final CubieCube[] MOVE_CUBE = buildMoveCube();

    private static CubieCube[] buildMoveCube() {
        CubieCube[] m = new CubieCube[6];
        for (int i = 0; i < 6; i++) m[i] = new CubieCube();

        // U
        setBytes(m[0].cp, new int[] {UBR, URF, UFL, ULB, DFR, DLF, DBL, DRB});
        setBytes(m[0].co, new int[] {0,0,0,0,0,0,0,0});
        setBytes(m[0].ep, new int[] {UB, UR, UF, UL, DR, DF, DL, DB, FR, FL, BL, BR});
        setBytes(m[0].eo, new int[] {0,0,0,0,0,0,0,0,0,0,0,0});

        // R
        setBytes(m[1].cp, new int[] {DFR, UFL, ULB, URF, DRB, DLF, DBL, UBR});
        setBytes(m[1].co, new int[] {2, 0, 0, 1, 1, 0, 0, 2});
        setBytes(m[1].ep, new int[] {FR, UF, UL, UB, BR, DF, DL, DB, DR, FL, BL, UR});
        setBytes(m[1].eo, new int[] {0,0,0,0,0,0,0,0,0,0,0,0});

        // F
        setBytes(m[2].cp, new int[] {UFL, DLF, ULB, UBR, URF, DFR, DBL, DRB});
        setBytes(m[2].co, new int[] {1, 2, 0, 0, 2, 1, 0, 0});
        setBytes(m[2].ep, new int[] {UR, FL, UL, UB, DR, FR, DL, DB, UF, DF, BL, BR});
        setBytes(m[2].eo, new int[] {0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0});

        // D
        setBytes(m[3].cp, new int[] {URF, UFL, ULB, UBR, DLF, DBL, DRB, DFR});
        setBytes(m[3].co, new int[] {0,0,0,0,0,0,0,0});
        setBytes(m[3].ep, new int[] {UR, UF, UL, UB, DF, DL, DB, DR, FR, FL, BL, BR});
        setBytes(m[3].eo, new int[] {0,0,0,0,0,0,0,0,0,0,0,0});

        // L
        setBytes(m[4].cp, new int[] {URF, ULB, DBL, UBR, DFR, UFL, DLF, DRB});
        setBytes(m[4].co, new int[] {0, 1, 2, 0, 0, 2, 1, 0});
        setBytes(m[4].ep, new int[] {UR, UF, BL, UB, DR, DF, FL, DB, FR, UL, DL, BR});
        setBytes(m[4].eo, new int[] {0,0,0,0,0,0,0,0,0,0,0,0});

        // B
        setBytes(m[5].cp, new int[] {URF, UFL, UBR, DRB, DFR, DLF, ULB, DBL});
        setBytes(m[5].co, new int[] {0, 0, 1, 2, 0, 0, 2, 1});
        setBytes(m[5].ep, new int[] {UR, UF, UL, BR, DR, DF, DL, BL, FR, FL, UB, DB});
        setBytes(m[5].eo, new int[] {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1});

        return m;
    }

    private static void setBytes(byte[] dst, int[] src) {
        for (int i = 0; i < dst.length; i++) dst[i] = (byte) src[i];
    }

    /* ─── n choose k ────────────────────────────────────── */

    public static int Cnk(int n, int k) {
        if (n < k) return 0;
        if (k > n / 2) k = n - k;
        int s = 1;
        for (int i = n, j = 1; i != n - k; i--, j++) {
            s *= i;
            s /= j;
        }
        return s;
    }

    /* ─── Array rotation helpers ──────────────────────── */

    private static void rotateLeft(byte[] arr, int l, int r) {
        byte t = arr[l];
        for (int i = l; i < r; i++) arr[i] = arr[i + 1];
        arr[r] = t;
    }

    private static void rotateRight(byte[] arr, int l, int r) {
        byte t = arr[r];
        for (int i = r; i > l; i--) arr[i] = arr[i - 1];
        arr[l] = t;
    }

    /* ─── Cubie multiply (= apply move) ──────────────── */

    public void cornerMultiply(CubieCube b) {
        byte[] cPerm = new byte[CORNER_COUNT];
        byte[] cOri  = new byte[CORNER_COUNT];
        for (int corn = 0; corn < CORNER_COUNT; corn++) {
            cPerm[corn] = this.cp[b.cp[corn] & 0xFF];
            int oriA = this.co[b.cp[corn] & 0xFF];
            int oriB = b.co[corn];
            int ori = 0;
            if (oriA < 3 && oriB < 3) {
                ori = oriA + oriB;
                if (ori >= 3) ori -= 3;
            } else if (oriA < 3 && oriB >= 3) {
                ori = oriA + oriB;
                if (ori >= 6) ori -= 3;
            } else if (oriA >= 3 && oriB < 3) {
                ori = oriA - oriB;
                if (ori < 3) ori += 3;
            } else {
                ori = oriA - oriB;
                if (ori < 0) ori += 3;
            }
            cOri[corn] = (byte) ori;
        }
        System.arraycopy(cPerm, 0, this.cp, 0, CORNER_COUNT);
        System.arraycopy(cOri,  0, this.co, 0, CORNER_COUNT);
    }

    public void edgeMultiply(CubieCube b) {
        byte[] ePerm = new byte[EDGE_COUNT];
        byte[] eOri  = new byte[EDGE_COUNT];
        for (int edge = 0; edge < EDGE_COUNT; edge++) {
            ePerm[edge] = this.ep[b.ep[edge] & 0xFF];
            eOri[edge] = (byte) ((b.eo[edge] + this.eo[b.ep[edge] & 0xFF]) % 2);
        }
        System.arraycopy(ePerm, 0, this.ep, 0, EDGE_COUNT);
        System.arraycopy(eOri,  0, this.eo, 0, EDGE_COUNT);
    }

    public void multiply(CubieCube b) {
        cornerMultiply(b);
        edgeMultiply(b);
    }

    /** Inverse cube: write into {@code c} the inverse of this. */
    public void invCubieCube(CubieCube c) {
        for (int edge = 0; edge < EDGE_COUNT; edge++) {
            c.ep[this.ep[edge] & 0xFF] = (byte) edge;
        }
        for (int edge = 0; edge < EDGE_COUNT; edge++) {
            c.eo[edge] = this.eo[c.ep[edge] & 0xFF];
        }
        for (int corn = 0; corn < CORNER_COUNT; corn++) {
            c.cp[this.cp[corn] & 0xFF] = (byte) corn;
        }
        for (int corn = 0; corn < CORNER_COUNT; corn++) {
            int ori = this.co[c.cp[corn] & 0xFF];
            if (ori >= 3) {
                c.co[corn] = (byte) ori;
            } else {
                int v = -ori;
                if (v < 0) v += 3;
                c.co[corn] = (byte) v;
            }
        }
    }

    /* ─── Coordinate getters/setters ─────────────────── */

    public short getTwist() {
        int ret = 0;
        for (int i = URF; i < DRB; i++) ret = 3 * ret + co[i];
        return (short) ret;
    }
    public void setTwist(int twist) {
        int twistParity = 0;
        for (int i = DRB - 1; i >= URF; i--) {
            int v = twist % 3;
            twistParity += v;
            co[i] = (byte) v;
            twist /= 3;
        }
        co[DRB] = (byte) ((3 - twistParity % 3) % 3);
    }

    public short getFlip() {
        int ret = 0;
        for (int i = UR; i < BR; i++) ret = 2 * ret + eo[i];
        return (short) ret;
    }
    public void setFlip(int flip) {
        int flipParity = 0;
        for (int i = BR - 1; i >= UR; i--) {
            int v = flip % 2;
            flipParity += v;
            eo[i] = (byte) v;
            flip /= 2;
        }
        eo[BR] = (byte) ((2 - flipParity % 2) % 2);
    }

    public short cornerParity() {
        int s = 0;
        for (int i = DRB; i >= URF + 1; i--)
            for (int j = i - 1; j >= URF; j--)
                if ((cp[j] & 0xFF) > (cp[i] & 0xFF)) s++;
        return (short) (s % 2);
    }

    public short edgeParity() {
        int s = 0;
        for (int i = BR; i >= UR + 1; i--)
            for (int j = i - 1; j >= UR; j--)
                if ((ep[j] & 0xFF) > (ep[i] & 0xFF)) s++;
        return (short) (s % 2);
    }

    public short getFRtoBR() {
        int a = 0, x = 0;
        byte[] edge4 = new byte[4];
        for (int j = BR; j >= UR; j--) {
            int e = ep[j] & 0xFF;
            if (FR <= e && e <= BR) {
                a += Cnk(11 - j, x + 1);
                edge4[3 - x++] = ep[j];
            }
        }
        int b = 0;
        for (int j = 3; j > 0; j--) {
            int k = 0;
            while ((edge4[j] & 0xFF) != j + 8) {
                rotateLeft(edge4, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return (short) (24 * a + b);
    }
    public void setFRtoBR(int idx) {
        byte[] sliceEdge = { (byte) FR, (byte) FL, (byte) BL, (byte) BR };
        byte[] otherEdge = { (byte) UR, (byte) UF, (byte) UL, (byte) UB,
                             (byte) DR, (byte) DF, (byte) DL, (byte) DB };
        int b = idx % 24;
        int a = idx / 24;
        for (int e = 0; e < EDGE_COUNT; e++) ep[e] = (byte) DB;

        for (int j = 1; j < 4; j++) {
            int k = b % (j + 1);
            b /= j + 1;
            while (k-- > 0) rotateRight(sliceEdge, 0, j);
        }
        int x = 3;
        for (int j = UR; j <= BR; j++) {
            if (a - Cnk(11 - j, x + 1) >= 0) {
                ep[j] = sliceEdge[3 - x];
                a -= Cnk(11 - j, x-- + 1);
            }
        }
        int y = 0;
        for (int j = UR; j <= BR; j++) {
            if ((ep[j] & 0xFF) == DB) ep[j] = otherEdge[y++];
        }
    }

    public short getURFtoDLF() {
        int a = 0, x = 0;
        byte[] corner6 = new byte[6];
        for (int j = URF; j <= DRB; j++) {
            if ((cp[j] & 0xFF) <= DLF) {
                a += Cnk(j, x + 1);
                corner6[x++] = cp[j];
            }
        }
        int b = 0;
        for (int j = 5; j > 0; j--) {
            int k = 0;
            while ((corner6[j] & 0xFF) != j) {
                rotateLeft(corner6, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return (short) (720 * a + b);
    }
    public void setURFtoDLF(int idx) {
        byte[] corner6 = { (byte) URF, (byte) UFL, (byte) ULB, (byte) UBR, (byte) DFR, (byte) DLF };
        byte[] otherCorner = { (byte) DBL, (byte) DRB };
        int b = idx % 720;
        int a = idx / 720;
        for (int c = 0; c < CORNER_COUNT; c++) cp[c] = (byte) DRB;
        for (int j = 1; j < 6; j++) {
            int k = b % (j + 1);
            b /= j + 1;
            while (k-- > 0) rotateRight(corner6, 0, j);
        }
        int x = 5;
        for (int j = DRB; j >= 0; j--) {
            if (a - Cnk(j, x + 1) >= 0) {
                cp[j] = corner6[x];
                a -= Cnk(j, x-- + 1);
            }
        }
        int y = 0;
        for (int j = URF; j <= DRB; j++) {
            if ((cp[j] & 0xFF) == DRB) cp[j] = otherCorner[y++];
        }
    }

    public int getURtoDF() {
        int a = 0, x = 0;
        byte[] edge6 = new byte[6];
        for (int j = UR; j <= BR; j++) {
            if ((ep[j] & 0xFF) <= DF) {
                a += Cnk(j, x + 1);
                edge6[x++] = ep[j];
            }
        }
        int b = 0;
        for (int j = 5; j > 0; j--) {
            int k = 0;
            while ((edge6[j] & 0xFF) != j) {
                rotateLeft(edge6, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return 720 * a + b;
    }
    public void setURtoDF(int idx) {
        byte[] edge6 = { (byte) UR, (byte) UF, (byte) UL, (byte) UB, (byte) DR, (byte) DF };
        byte[] otherEdge = { (byte) DL, (byte) DB, (byte) FR, (byte) FL, (byte) BL, (byte) BR };
        int b = idx % 720;
        int a = idx / 720;
        for (int e = 0; e < EDGE_COUNT; e++) ep[e] = (byte) BR;
        for (int j = 1; j < 6; j++) {
            int k = b % (j + 1);
            b /= j + 1;
            while (k-- > 0) rotateRight(edge6, 0, j);
        }
        int x = 5;
        for (int j = BR; j >= 0; j--) {
            if (a - Cnk(j, x + 1) >= 0) {
                ep[j] = edge6[x];
                a -= Cnk(j, x-- + 1);
            }
        }
        int y = 0;
        for (int j = UR; j <= BR; j++) {
            if ((ep[j] & 0xFF) == BR) ep[j] = otherEdge[y++];
        }
    }

    public short getURtoUL() {
        int a = 0, x = 0;
        byte[] edge3 = new byte[3];
        for (int j = UR; j <= BR; j++) {
            if ((ep[j] & 0xFF) <= UL) {
                a += Cnk(j, x + 1);
                edge3[x++] = ep[j];
            }
        }
        int b = 0;
        for (int j = 2; j > 0; j--) {
            int k = 0;
            while ((edge3[j] & 0xFF) != j) {
                rotateLeft(edge3, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return (short) (6 * a + b);
    }
    public void setURtoUL(int idx) {
        byte[] edge3 = { (byte) UR, (byte) UF, (byte) UL };
        int b = idx % 6;
        int a = idx / 6;
        for (int e = 0; e < EDGE_COUNT; e++) ep[e] = (byte) BR;
        for (int j = 1; j < 3; j++) {
            int k = b % (j + 1);
            b /= j + 1;
            while (k-- > 0) rotateRight(edge3, 0, j);
        }
        int x = 2;
        for (int j = BR; j >= 0; j--) {
            if (a - Cnk(j, x + 1) >= 0) {
                ep[j] = edge3[x];
                a -= Cnk(j, x-- + 1);
            }
        }
    }

    public short getUBtoDF() {
        int a = 0, x = 0;
        byte[] edge3 = new byte[3];
        for (int j = UR; j <= BR; j++) {
            int e = ep[j] & 0xFF;
            if (UB <= e && e <= DF) {
                a += Cnk(j, x + 1);
                edge3[x++] = ep[j];
            }
        }
        int b = 0;
        for (int j = 2; j > 0; j--) {
            int k = 0;
            while ((edge3[j] & 0xFF) != UB + j) {
                rotateLeft(edge3, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return (short) (6 * a + b);
    }
    public void setUBtoDF(int idx) {
        byte[] edge3 = { (byte) UB, (byte) DR, (byte) DF };
        int b = idx % 6;
        int a = idx / 6;
        for (int e = 0; e < EDGE_COUNT; e++) ep[e] = (byte) BR;
        for (int j = 1; j < 3; j++) {
            int k = b % (j + 1);
            b /= j + 1;
            while (k-- > 0) rotateRight(edge3, 0, j);
        }
        int x = 2;
        for (int j = BR; j >= 0; j--) {
            if (a - Cnk(j, x + 1) >= 0) {
                ep[j] = edge3[x];
                a -= Cnk(j, x-- + 1);
            }
        }
    }

    public int getURFtoDLB() {
        byte[] perm = new byte[8];
        for (int i = 0; i < 8; i++) perm[i] = cp[i];
        int b = 0;
        for (int j = 7; j > 0; j--) {
            int k = 0;
            while ((perm[j] & 0xFF) != j) {
                rotateLeft(perm, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return b;
    }
    public void setURFtoDLB(int idx) {
        byte[] perm = { (byte) URF, (byte) UFL, (byte) ULB, (byte) UBR,
                        (byte) DFR, (byte) DLF, (byte) DBL, (byte) DRB };
        for (int j = 1; j < 8; j++) {
            int k = idx % (j + 1);
            idx /= j + 1;
            while (k-- > 0) rotateRight(perm, 0, j);
        }
        int x = 7;
        for (int j = 7; j >= 0; j--) cp[j] = perm[x--];
    }

    public int getURtoBR() {
        byte[] perm = new byte[12];
        for (int i = 0; i < 12; i++) perm[i] = ep[i];
        int b = 0;
        for (int j = 11; j > 0; j--) {
            int k = 0;
            while ((perm[j] & 0xFF) != j) {
                rotateLeft(perm, 0, j);
                k++;
            }
            b = (j + 1) * b + k;
        }
        return b;
    }
    public void setURtoBR(int idx) {
        byte[] perm = { (byte) UR, (byte) UF, (byte) UL, (byte) UB, (byte) DR, (byte) DF,
                        (byte) DL, (byte) DB, (byte) FR, (byte) FL, (byte) BL, (byte) BR };
        for (int j = 1; j < 12; j++) {
            int k = idx % (j + 1);
            idx /= j + 1;
            while (k-- > 0) rotateRight(perm, 0, j);
        }
        int x = 11;
        for (int j = 11; j >= 0; j--) ep[j] = perm[x--];
    }

    /* ─── verify, toFaceCube ──────────────────────────── */

    /** Cycle-checked validity — port of {@code verify()}.
     *  Returns 0 if cube is valid, -2..-6 with a specific error code. */
    public int verify() {
        int sum = 0;
        int[] edgeCount = new int[12];
        for (int e = 0; e < EDGE_COUNT; e++) edgeCount[ep[e] & 0xFF]++;
        for (int i = 0; i < 12; i++) if (edgeCount[i] != 1) return -2;
        for (int i = 0; i < 12; i++) sum += eo[i];
        if (sum % 2 != 0) return -3;

        int[] cornerCount = new int[8];
        for (int c = 0; c < CORNER_COUNT; c++) cornerCount[cp[c] & 0xFF]++;
        for (int i = 0; i < 8; i++) if (cornerCount[i] != 1) return -4;

        sum = 0;
        for (int i = 0; i < 8; i++) sum += co[i];
        if (sum % 3 != 0) return -5;

        if ((edgeParity() ^ cornerParity()) != 0) return -6;
        return 0;
    }

    public FaceCube toFaceCube() {
        FaceCube fc = new FaceCube();
        for (int i = 0; i < CORNER_COUNT; i++) {
            int j = cp[i] & 0xFF;
            int ori = co[i];
            for (int n = 0; n < 3; n++) {
                fc.f[FaceCube.cornerFacelet[i][(n + ori) % 3]] = FaceCube.cornerColor[j][n];
            }
        }
        for (int i = 0; i < EDGE_COUNT; i++) {
            int j = ep[i] & 0xFF;
            int ori = eo[i];
            for (int n = 0; n < 2; n++) {
                fc.f[FaceCube.edgeFacelet[i][(n + ori) % 2]] = FaceCube.edgeColor[j][n];
            }
        }
        return fc;
    }
}
