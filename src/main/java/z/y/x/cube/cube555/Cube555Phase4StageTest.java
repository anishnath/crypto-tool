package z.y.x.cube.cube555;

import java.util.List;

/**
 * Phase 4 IDA* test — runs LR → FB → EO → Phase 4 chain and verifies
 * the chosen wings end up correctly placed in the M-slice (= the table
 * lookup says cost 0).
 *
 * <p>First run downloads the 184 MB step40 .txt.gz — be patient (~30s
 * over a fast connection).  Subsequent runs use the cached file with
 * mmap'd binary search, so per-solve cost is dominated by IDA*.
 */
public final class Cube555Phase4StageTest {

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
        System.out.println("Warming up centres + EO + phase4 tables (downloads on first run)...");
        long t0 = System.currentTimeMillis();
        Cube555LRStage.ensureReady();
        Cube555FBStage.ensureReady();
        Cube555EOStage.ensureReady();
        Cube555Phase4Stage.ensureReady();
        System.out.println("  warm in " + (System.currentTimeMillis() - t0) + " ms\n");

        // Spot-check the binary search reader directly with the
        // Python-verified ground-truth keys + costs (from
        // Cube555Phase4EncoderTest):
        // seed=1  → 0547a89f014108300e, Python-reported cost 4
        // seed=7  → cb8201020e4560618b, Python-reported cost 4
        // seed=42 → a0402c8510a2b46233, Python-reported cost 3
        spotCheck("0547a89f014108300e", 4);
        spotCheck("cb8201020e4560618b", 4);
        spotCheck("a0402c8510a2b46233", 3);

        // SOLVED state is at cost 0 for AT LEAST ONE wing_strs choice
        // (the specific orientation that matches how the cube is laid
        // out).  Different wing_strs choices target different M-slices,
        // so most return non-zero cost from SOLVED — that just means
        // SOLVED isn't in those particular target sub-goals.
        boolean anyZero = false;
        for (String[] wings : Cube555Phase4Stage.COMMON_WING_STRS) {
            int c = Cube555Phase4Stage.costFor(Cube555.SOLVED, wings);
            System.out.println("       SOLVED + " + java.util.Arrays.toString(wings) + " cost = " + c);
            if (c == 0) anyZero = true;
        }
        if (anyZero) {
            passed++;
            System.out.println("PASS: at least one wing_strs choice has SOLVED at cost 0");
        } else {
            failed++;
            System.err.println("FAIL: NO wing_strs choice puts SOLVED at cost 0");
        }

        // Real chained solve — on small scrambles, get LR + FB + EO done,
        // then run phase 4 with default wing_strs.  Verify the encoded
        // state ends at cost 0.
        long[] seeds = {1, 7, 42};
        int[] scrambleLengths = {5, 10};
        String[] DEFAULT_WINGS = {"LB", "LF", "RB", "RF"};

        for (int n : scrambleLengths) {
            for (long seed : seeds) {
                String scr = scramble(seed, n);
                String state = Cube555Moves.applyMoves(Cube555.SOLVED, scr);

                long st = System.currentTimeMillis();
                List<String> lr, fb, eo, p4;
                String afterLR, afterFB, afterEO, afterP4;
                try {
                    lr = Cube555LRStage.solve(state);
                    afterLR = Cube555Moves.applyMoves(state, lr);
                    fb = Cube555FBStage.solve(afterLR);
                    afterFB = Cube555Moves.applyMoves(afterLR, fb);
                    eo = Cube555EOStage.solve(afterFB);
                    afterEO = Cube555Moves.applyMoves(afterFB, eo);
                    p4 = Cube555Phase4Stage.solveWith(afterEO, DEFAULT_WINGS, 16);
                    afterP4 = Cube555Moves.applyMoves(afterEO, p4);
                } catch (Exception ex) {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d threw: %s%n",
                        seed, n, ex.getMessage());
                    continue;
                }
                long dt = System.currentTimeMillis() - st;

                int finalCost = Cube555Phase4Stage.costFor(afterP4, DEFAULT_WINGS);
                if (finalCost == 0) {
                    passed++;
                    System.out.printf(
                        "PASS: seed=%-8d n=%-2d  LR=%-2d FB=%-2d EO=%-2d P4=%-2d total=%-3d in %5d ms%n",
                        seed, n, lr.size(), fb.size(), eo.size(), p4.size(),
                        lr.size() + fb.size() + eo.size() + p4.size(), dt);
                } else {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d → P4 final cost %d (expected 0)%n",
                        seed, n, finalCost);
                }
            }
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private static void spotCheck(String key, int expectedCost) throws java.io.IOException {
        Cube555Phase4Stage.ensureReady();
        // Use any wings — we're only testing the table lookup itself.
        // costFor() takes a state, not a key directly, so we exercise
        // the IDA* domain's encoder + table path with a SOLVED cube
        // and the known wing_strs (because the test's known costs come
        // from the Python encoder using {LB,LF,RB,RF}).
        // For direct key lookup, use the table reflectively:
        try {
            java.lang.reflect.Field f = Cube555Phase4Stage.class.getDeclaredField("TABLE");
            f.setAccessible(true);
            Object t = f.get(null);
            int got = (Integer) t.getClass().getMethod("costFor", String.class).invoke(t, key);
            if (got == expectedCost) {
                passed++;
                System.out.println("PASS: table[" + key + "] cost = " + got);
            } else {
                failed++;
                System.err.println("FAIL: table[" + key + "] got " + got + ", expected " + expectedCost);
            }
        } catch (Exception ex) {
            failed++;
            System.err.println("FAIL: spotCheck reflection: " + ex.getMessage());
        }
    }

    private Cube555Phase4StageTest() {}
}
