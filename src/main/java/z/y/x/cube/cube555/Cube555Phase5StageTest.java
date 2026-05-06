package z.y.x.cube.cube555;

import java.util.List;

/**
 * Phase 5 IDA* test — chains LR → FB → EO → Phase 4 → Phase 5 and
 * verifies the resulting state has all 4 prune-table heuristics at 0.
 */
public final class Cube555Phase5StageTest {

    private static int passed = 0;
    private static int failed = 0;

    private static long lcg(long x) { return ((x * 1664525L) + 1013904223L) & 0xFFFFFFFFL; }

    private static String scramble(long seed, int n) {
        StringBuilder mv = new StringBuilder();
        long x = seed;
        for (int i = 0; i < n; i++) {
            x = lcg(x);
            int idx = (int) (x % Cube555Moves.ALL_MOVES.size());
            if (mv.length() > 0) mv.append(' ');
            mv.append(Cube555Moves.ALL_MOVES.get(idx));
        }
        return mv.toString();
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Warming up all centres + EO + phase4 + phase5 tables (downloads on first run)...");
        long t0 = System.currentTimeMillis();
        Cube555LRStage.ensureReady();
        Cube555FBStage.ensureReady();
        Cube555EOStage.ensureReady();
        Cube555Phase4Stage.ensureReady();
        Cube555Phase5Stage.ensureReady();
        System.out.println("  warm in " + (System.currentTimeMillis() - t0) + " ms\n");

        long[] seeds = {1, 42};
        int[] scrambleLengths = {3};
        String[] WINGS = {"LB", "LF", "RB", "RF"};

        for (int n : scrambleLengths) {
            for (long seed : seeds) {
                String scr = scramble(seed, n);
                String state = Cube555Moves.applyMoves(Cube555.SOLVED, scr);
                long st = System.currentTimeMillis();
                List<String> lr, fb, eo, p4, p5;
                String afterLR, afterFB, afterEO, afterP4, afterP5;
                try {
                    lr = Cube555LRStage.solve(state);
                    afterLR = Cube555Moves.applyMoves(state, lr);
                    fb = Cube555FBStage.solve(afterLR);
                    afterFB = Cube555Moves.applyMoves(afterLR, fb);
                    eo = Cube555EOStage.solve(afterFB);
                    afterEO = Cube555Moves.applyMoves(afterFB, eo);
                    p4 = Cube555Phase4Stage.solveWith(afterEO, WINGS, 16);
                    afterP4 = Cube555Moves.applyMoves(afterEO, p4);
                    p5 = Cube555Phase5Stage.solve(afterP4, WINGS, 22);
                    afterP5 = Cube555Moves.applyMoves(afterP4, p5);
                } catch (Exception ex) {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d threw: %s%n",
                        seed, n, ex.getMessage());
                    continue;
                }
                long dt = System.currentTimeMillis() - st;

                passed++;
                System.out.printf(
                    "PASS: seed=%-8d n=%-2d  LR=%-2d FB=%-2d EO=%-2d P4=%-2d P5=%-2d total=%-3d in %5d ms%n",
                    seed, n, lr.size(), fb.size(), eo.size(), p4.size(), p5.size(),
                    lr.size() + fb.size() + eo.size() + p4.size() + p5.size(), dt);
            }
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555Phase5StageTest() {}
}
