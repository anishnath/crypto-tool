package z.y.x.cube.cube555;

import java.util.List;

/**
 * End-to-end test for FB-centres staging.  Chains LR-stage → FB-stage
 * and verifies BOTH remain staged afterwards (FB-stage's restricted
 * move set is supposed to preserve LR).
 *
 * <h2>Run</h2>
 *
 * <pre>
 *   javac -d /tmp/cube555-classes \
 *     $(ls src/main/java/z/y/x/cube/core/*.java | grep -v MovePruningTest) \
 *     src/main/java/z/y/x/cube/lookup/TextLookupTable.java \
 *     src/main/java/z/y/x/cube/cube555/*.java
 *   java -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *        -cp /tmp/cube555-classes z.y.x.cube.cube555.Cube555FBStageTest
 * </pre>
 */
public final class Cube555FBStageTest {

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

    private static boolean isLRStaged(String state) {
        int lOff = Cube555.faceOffset('L');
        int rOff = Cube555.faceOffset('R');
        for (int p : Cube555.CENTRE_POS) {
            char l = state.charAt(lOff + p);
            char r = state.charAt(rOff + p);
            if (l != 'L' && l != 'R') return false;
            if (r != 'L' && r != 'R') return false;
        }
        for (char f : new char[] {'U', 'F', 'D', 'B'}) {
            int off = Cube555.faceOffset(f);
            for (int p : Cube555.CENTRE_POS) {
                char c = state.charAt(off + p);
                if (c == 'L' || c == 'R') return false;
            }
        }
        return true;
    }

    private static boolean isFBStaged(String state) {
        int fOff = Cube555.faceOffset('F');
        int bOff = Cube555.faceOffset('B');
        for (int p : Cube555.CENTRE_POS) {
            char f = state.charAt(fOff + p);
            char b = state.charAt(bOff + p);
            if (f != 'F' && f != 'B') return false;
            if (b != 'F' && b != 'B') return false;
        }
        for (char ff : new char[] {'U', 'L', 'R', 'D'}) {
            int off = Cube555.faceOffset(ff);
            for (int p : Cube555.CENTRE_POS) {
                char c = state.charAt(off + p);
                if (c == 'F' || c == 'B') return false;
            }
        }
        return true;
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Warming up LR + FB centre staging tables...");
        long t0 = System.currentTimeMillis();
        Cube555LRStage.ensureReady();
        Cube555FBStage.ensureReady();
        System.out.println("  warm in " + (System.currentTimeMillis() - t0) + " ms\n");

        // Trivial: solved cube → empty solution.
        if (Cube555FBStage.solve(Cube555.SOLVED).isEmpty()) {
            passed++; System.out.println("PASS: solved → empty FB solution");
        } else {
            failed++; System.err.println("FAIL: solved → non-empty FB solution");
        }

        long[] seeds = {1, 7, 42, 1729, 8675309};
        int[] scrambleLengths = {5, 10, 15, 20};

        for (int n : scrambleLengths) {
            for (long seed : seeds) {
                String scr = scramble(seed, n);
                String state = Cube555Moves.applyMoves(Cube555.SOLVED, scr);

                long st = System.currentTimeMillis();
                List<String> lrMoves;
                List<String> fbMoves;
                String afterLR;
                String afterFB;
                try {
                    lrMoves = Cube555LRStage.solve(state);
                    afterLR = Cube555Moves.applyMoves(state, lrMoves);
                    fbMoves = Cube555FBStage.solve(afterLR);
                    afterFB = Cube555Moves.applyMoves(afterLR, fbMoves);
                } catch (Exception ex) {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d threw: %s%n", seed, n, ex.getMessage());
                    continue;
                }
                long dt = System.currentTimeMillis() - st;

                boolean lr = isLRStaged(afterFB);
                boolean fb = isFBStaged(afterFB);
                if (lr && fb) {
                    passed++;
                    System.out.printf("PASS: seed=%-8d n=%-2d  LR=%-2d  FB=%-2d  total=%-2d  in %5d ms%n",
                        seed, n, lrMoves.size(), fbMoves.size(),
                        lrMoves.size() + fbMoves.size(), dt);
                } else {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d  LR-staged=%s  FB-staged=%s%n",
                        seed, n, lr, fb);
                }
            }
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555FBStageTest() {}
}
