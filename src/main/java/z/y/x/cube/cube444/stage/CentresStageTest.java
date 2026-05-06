package z.y.x.cube.cube444.stage;

import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;

/**
 * Standalone test runner for {@link CentresStage}, mirroring
 * {@code js/rubiks4/scratch-centers.mjs}.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/core/*.java
 *                              src/main/java/z/y/x/cube/cube444/*.java
 *                              src/main/java/z/y/x/cube/cube444/stage/*.java
 *   java  -cp /tmp/cube-classes z.y.x.cube.cube444.stage.CentresStageTest
 *
 * Asserts:
 *   - All three pruning tables build to the expected reachable counts
 *     (735 471 / 12 870 / 343 000).
 *   - Per-stage solve actually solves the relevant axis.
 *   - Each subsequent stage doesn't undo prior stages.
 *   - Final state has every face's 4 inner stickers monochromatic.
 *   - Orchestrator result is reproducible (applying its moves equals
 *     the reported state).
 */
public final class CentresStageTest {

    private static int pass = 0, fail = 0;

    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else {
            fail++;
            System.err.println("  FAIL: " + name + (detail.isEmpty() ? "" : " (" + detail + ")"));
        }
    }
    private static void check(String name, boolean ok) { check(name, ok, ""); }

    private static long lcg(long x) { return ((x * 1664525L) + 1013904223L) & 0xFFFFFFFFL; }
    private static List<String> scramble(long seed, int n) {
        List<String> out = new ArrayList<>(n);
        long x = seed;
        for (int i = 0; i < n; i++) {
            x = lcg(x);
            int idx = (int) ((x >>> 0) % Cube444Moves.ALL_MOVES.size());
            out.add(Cube444Moves.ALL_MOVES.get(idx));
        }
        return out;
    }

    public static void main(String[] args) {
        System.out.println("Building all three pruning tables…");
        long t0 = System.currentTimeMillis();
        CentresStage.ensureReady();
        long initMs = System.currentTimeMillis() - t0;
        System.out.println("  total init: " + initMs + "ms");
        System.out.println("  UD   : depth " + CentresStage.udMaxDepth()
            + ", " + CentresStage.udReachable() + " states");
        System.out.println("  LR   : depth " + CentresStage.lrMaxDepth()
            + ", " + CentresStage.lrReachable() + " states");
        System.out.println("  fine : depth " + CentresStage.fineMaxDepth()
            + ", " + CentresStage.fineReachable() + " states");

        check("UD reachable count = 735471", CentresStage.udReachable()   == 735471,
            "(got " + CentresStage.udReachable() + ")");
        check("LR reachable count = 12870",  CentresStage.lrReachable()   == 12870,
            "(got " + CentresStage.lrReachable() + ")");
        check("fine reachable count = 343000", CentresStage.fineReachable() == 343000,
            "(got " + CentresStage.fineReachable() + ")");

        System.out.println();
        System.out.println("Solving full centres from random scrambles…");
        long[] seeds = {1, 7, 42, 1729, 8675309, 271828, 31415, 161803};
        long totalSolveMs = 0;
        int totalMoves = 0, maxTotal = 0;

        for (long seed : seeds) {
            List<String> scr = scramble(seed, 60);
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scr);

            long t1 = System.currentTimeMillis();
            List<String> ud = CentresStage.solveUDStage(scrambled);
            String s1 = Cube444Moves.applyMoves(scrambled, ud);
            check("seed " + seed + ": UD staged",
                CentresStage.udStateOf(s1) == CentresStage.udStateOf(Cube444.SOLVED));

            List<String> lr = CentresStage.solveLRStage(s1);
            String s2 = Cube444Moves.applyMoves(s1, lr);
            check("seed " + seed + ": LR staged (UD preserved)",
                CentresStage.lrStateOf(s2)  == CentresStage.lrStateOf(Cube444.SOLVED)
             && CentresStage.udStateOf(s2)  == CentresStage.udStateOf(Cube444.SOLVED));

            List<String> fine = CentresStage.solveFineStage(s2);
            String s3 = Cube444Moves.applyMoves(s2, fine);
            check("seed " + seed + ": centres fully solved",
                CentresStage.isCentresSolved(s3));

            long dt = System.currentTimeMillis() - t1;
            totalSolveMs += dt;
            int total = ud.size() + lr.size() + fine.size();
            totalMoves += total;
            if (total > maxTotal) maxTotal = total;

            System.out.println("  seed " + String.format("%8d", seed) + ": "
                + ud.size() + "+" + lr.size() + "+" + fine.size()
                + "=" + total + " moves in " + dt + "ms");
        }

        System.out.println();
        System.out.println("Avg total: " + (totalMoves / seeds.length) + " moves, max " + maxTotal);
        System.out.println("Avg solve time (post-init): " + (totalSolveMs / seeds.length) + "ms");

        System.out.println();
        System.out.println("Full orchestrator round-trip…");
        for (long seed : seeds) {
            List<String> scr = scramble(seed, 60);
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scr);
            CentresStage.CentresResult r = CentresStage.solveCentres(scrambled);
            check("seed " + seed + ": solveCentres() result fully solves",
                CentresStage.isCentresSolved(r.state));
            check("seed " + seed + ": applyMoves(scrambled, moves) reproduces result",
                Cube444Moves.applyMoves(scrambled, r.moves).equals(r.state));
        }

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private CentresStageTest() {}
}
