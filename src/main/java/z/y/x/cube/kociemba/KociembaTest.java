package z.y.x.cube.kociemba;

import java.util.Arrays;
import java.util.List;

/**
 * End-to-end 3×3 solve test.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/kociemba/*.java \
 *       src/main/java/z/y/x/cube/core/Kociemba3x3.java
 *   java  -Dcube.kociemba.cacheDir=/tmp/cube-kociemba-cache \
 *         -cp /tmp/cube-classes z.y.x.cube.kociemba.KociembaTest
 *
 * First run: ~3–6 s while CoordCube builds prune tables (cached to disk).
 * Subsequent runs: instant load from cache, sub-100 ms per solve.
 *
 * For each scramble:
 *   1. Apply moves to a solved cube → produce a 54-char scrambled facelet.
 *   2. Hand to Kociemba.solve() → get back a solution sequence.
 *   3. Apply solution to scrambled cube → must equal solved cube.
 */
public final class KociembaTest {

    private static final String SOLVED =
        "UUUUUUUUU" + "RRRRRRRRR" + "FFFFFFFFF"
      + "DDDDDDDDD" + "LLLLLLLLL" + "BBBBBBBBB";

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else { fail++;
            System.err.println("  FAIL: " + name);
            if (!detail.isEmpty()) System.err.println("        " + detail);
        }
    }

    /** Apply a move string ("R", "U2", "F'", etc.) to a cubie cube. */
    private static void applyMove(CubieCube c, String mv) {
        char face = mv.charAt(0);
        int faceIdx;
        switch (face) {
            case 'U': faceIdx = 0; break;
            case 'R': faceIdx = 1; break;
            case 'F': faceIdx = 2; break;
            case 'D': faceIdx = 3; break;
            case 'L': faceIdx = 4; break;
            case 'B': faceIdx = 5; break;
            default: throw new IllegalArgumentException("bad face " + face);
        }
        int reps = 1;
        if (mv.length() > 1) {
            char suf = mv.charAt(1);
            if (suf == '2') reps = 2;
            else if (suf == '\'') reps = 3;
        }
        for (int i = 0; i < reps; i++) c.multiply(CubieCube.MOVE_CUBE[faceIdx]);
    }

    private static String applyScramble(String scramble) {
        CubieCube c = new CubieCube();
        for (String mv : scramble.trim().split("\\s+")) {
            if (mv.isEmpty()) continue;
            applyMove(c, mv);
        }
        return c.toFaceCube().toFaceString();
    }

    public static void main(String[] args) throws Exception {
        long t0 = System.currentTimeMillis();
        System.out.println("Init Kociemba (first-time prune-table build, may take ~3-6 s)…");
        CoordCube.ensureInited();
        System.out.println("  ready in " + (System.currentTimeMillis() - t0) + "ms\n");

        Kociemba k = new Kociemba();

        // Solved cube → empty solution.
        List<String> emptySoln = k.solve(SOLVED);
        check("solved cube → empty solution", emptySoln.isEmpty(),
            "got " + emptySoln);

        // Try several known scrambles.  For each, apply scramble, solve,
        // verify the solution returns the cube to solved.
        String[] scrambles = {
            "R",                                                    // simplest
            "R U R' U'",                                            // sexy move (cycles)
            "R U2 R'",
            "U R F D L B",
            "F R U R' U' F'",                                       // T-perm-ish setup
            "R U R' U R U2 R'",                                     // sune
            "R U2 D' B D'",
            "L F R B R' L F D L'",                                  // 9-move
            "F R U2 D B' L F2 R' D' B U L2 F' R'",                  // 14-move
            "U R2 F B R B2 R U2 L B2 R U' D' R2 F R' L B2 U2 F2",   // 20-move
        };

        for (String scramble : scrambles) {
            String scrambled = applyScramble(scramble);
            long st = System.currentTimeMillis();
            List<String> soln = k.solve(scrambled);
            long dt = System.currentTimeMillis() - st;

            // Apply solution and verify back to solved.
            CubieCube c = new FaceCube(scrambled).toCubieCube();
            for (String mv : soln) applyMove(c, mv);
            String resultFacelet = c.toFaceCube().toFaceString();
            boolean ok = SOLVED.equals(resultFacelet);
            check("scramble '" + scramble + "' → solves",
                ok,
                "scrambled=" + scrambled + " soln=" + soln + " result=" + resultFacelet);
            System.out.printf("  '%s'%n    scrambled=%s%n    solution=%s (%d moves, %d ms)%n",
                scramble, scrambled, soln, soln.size(), dt);
        }

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private KociembaTest() {}
}
