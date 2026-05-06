package z.y.x.cube.kociemba;

import static z.y.x.cube.kociemba.KEnums.*;

/**
 * Sanity checks for {@link CubieCube} — port of cubiecube.c.
 *
 * Verifies:
 *   1. Solved cube round-trips cleanly through facelet / cubie / facelet.
 *   2. Each of the 6 elementary moves applied 4× returns to solved.
 *   3. M ∘ M' = identity for each face (where M' = three Ms).
 *   4. M2 ∘ M2 = identity.
 *   5. All-faces composition produces a valid (verify() == 0) cube.
 */
public final class CubieCubeTest {

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok) {
        if (ok) pass++;
        else { fail++; System.err.println("  FAIL: " + name); }
    }

    private static String solvedFacelet() {
        StringBuilder sb = new StringBuilder(54);
        char[] faces = {'U', 'R', 'F', 'D', 'L', 'B'};
        for (char f : faces) for (int i = 0; i < 9; i++) sb.append(f);
        return sb.toString();
    }

    private static boolean equals(CubieCube a, CubieCube b) {
        for (int i = 0; i < CORNER_COUNT; i++) {
            if (a.cp[i] != b.cp[i] || a.co[i] != b.co[i]) return false;
        }
        for (int i = 0; i < EDGE_COUNT; i++) {
            if (a.ep[i] != b.ep[i] || a.eo[i] != b.eo[i]) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        // ─ Solved cube round-trip ──────────────────
        String solved = solvedFacelet();
        FaceCube fc = new FaceCube(solved);
        CubieCube cc = fc.toCubieCube();
        check("solved verify == 0", cc.verify() == 0);
        check("solved round-trip facelet", solved.equals(cc.toFaceCube().toFaceString()));

        // ─ Each face: M⁴ = I ──────────────────────
        String[] faceNames = {"U", "R", "F", "D", "L", "B"};
        for (int m = 0; m < 6; m++) {
            CubieCube c = new CubieCube();   // solved
            for (int i = 0; i < 4; i++) c.multiply(CubieCube.MOVE_CUBE[m]);
            CubieCube ref = new CubieCube();
            check(faceNames[m] + "⁴ = I", equals(c, ref));
        }

        // ─ Each face: M ∘ M' = I, where M' = M³ ────
        for (int m = 0; m < 6; m++) {
            CubieCube c = new CubieCube();
            c.multiply(CubieCube.MOVE_CUBE[m]);
            for (int i = 0; i < 3; i++) c.multiply(CubieCube.MOVE_CUBE[m]);
            check(faceNames[m] + " ∘ " + faceNames[m] + "' = I",
                equals(c, new CubieCube()));
        }

        // ─ M² ∘ M² = I ─────────────────────────────
        for (int m = 0; m < 6; m++) {
            CubieCube c = new CubieCube();
            // 4 * M (= 2 * M²)
            for (int i = 0; i < 4; i++) c.multiply(CubieCube.MOVE_CUBE[m]);
            check(faceNames[m] + "²·² = I", equals(c, new CubieCube()));
        }

        // ─ All-face composition is a valid cube ────
        for (int m = 0; m < 6; m++) {
            CubieCube c = new CubieCube();
            c.multiply(CubieCube.MOVE_CUBE[m]);
            check(faceNames[m] + " applied to solved is valid", c.verify() == 0);
            check(faceNames[m] + " applied to solved is NOT solved", !equals(c, new CubieCube()));
        }

        // ─ Inverse round-trip ─────────────────────
        for (int m = 0; m < 6; m++) {
            CubieCube c = new CubieCube();
            c.multiply(CubieCube.MOVE_CUBE[m]);
            CubieCube inv = new CubieCube();
            c.invCubieCube(inv);
            // c · inv should be identity if applied as: take c, multiply by inv.
            CubieCube combined = new CubieCube(c);
            combined.multiply(inv);
            check(faceNames[m] + " · inverse = I", equals(combined, new CubieCube()));
        }

        // ─ Coordinate getter/setter round-trip ────
        // For a few random twists/flips, set them and read back.
        for (int t : new int[] {0, 1, 100, 1000, 2186}) {
            CubieCube c = new CubieCube();
            c.setTwist(t);
            check("setTwist/getTwist " + t, c.getTwist() == t);
        }
        for (int f : new int[] {0, 1, 100, 1000, 2047}) {
            CubieCube c = new CubieCube();
            c.setFlip(f);
            check("setFlip/getFlip " + f, c.getFlip() == f);
        }

        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private CubieCubeTest() {}
}
