package z.y.x.cube.cube555;

import java.util.List;

/**
 * End-to-end test: scramble a 5×5, run {@link Cube555LRStage#solve}, and
 * verify the resulting state has all L stickers on the L face's centre
 * positions (any arrangement) and all R stickers on R face's centres.
 *
 * <h2>Run</h2>
 *
 * <pre>
 *   javac -d /tmp/cube555-classes \
 *     src/main/java/z/y/x/cube/core/*.java \
 *     src/main/java/z/y/x/cube/lookup/TextLookupTable.java \
 *     src/main/java/z/y/x/cube/cube555/*.java
 *   java -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *        -cp /tmp/cube555-classes z.y.x.cube.cube555.Cube555LRStageTest
 * </pre>
 */
public final class Cube555LRStageTest {

    private static int passed = 0;
    private static int failed = 0;

    private static void check(String name, boolean ok) {
        if (ok) { passed++; System.out.println("PASS: " + name); }
        else    { failed++; System.err.println("FAIL: " + name); }
    }

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

    /**
     * STAGING (not solving) — every centre position on L and R faces
     * must hold an L OR R sticker (in any arrangement), and no L/R
     * stickers may be on any other face.  This is the goal state of
     * the step11+step12 IDA* search.  Solving the LR centres into
     * specific arrangements is a later phase.
     */
    private static boolean isLRStaged(String state) {
        int lOff = Cube555.faceOffset('L');
        int rOff = Cube555.faceOffset('R');
        // L+R faces' centres must contain only L or R stickers.
        for (int p : Cube555.CENTRE_POS) {
            char l = state.charAt(lOff + p);
            char r = state.charAt(rOff + p);
            if (l != 'L' && l != 'R') return false;
            if (r != 'L' && r != 'R') return false;
        }
        // No L/R stickers on any other face's centres.
        for (char f : new char[] {'U', 'F', 'D', 'B'}) {
            int off = Cube555.faceOffset(f);
            for (int p : Cube555.CENTRE_POS) {
                char c = state.charAt(off + p);
                if (c == 'L' || c == 'R') return false;
            }
        }
        return true;
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Warming up LR centre staging tables (downloading on first run)...");
        long t0 = System.currentTimeMillis();
        Cube555LRStage.ensureReady();
        System.out.println("  warm in " + (System.currentTimeMillis() - t0) + " ms\n");

        // Trivial case: solved cube → empty solution.
        List<String> sol0 = Cube555LRStage.solve(Cube555.SOLVED);
        check("solved → empty solution", sol0.isEmpty());

        // Real scrambles — small ones first, then bigger.  Each must
        // converge quickly given the near-tight heuristic.
        int[] scrambleLengths = {5, 10, 15, 20};
        long[] seeds = {1, 7, 42, 1729, 8675309};

        for (int n : scrambleLengths) {
            for (long seed : seeds) {
                String scr = scramble(seed, n);
                String state = Cube555Moves.applyMoves(Cube555.SOLVED, scr);

                long st = System.currentTimeMillis();
                List<String> sol;
                try {
                    sol = Cube555LRStage.solve(state);
                } catch (Exception ex) {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d threw: %s%n", seed, n, ex.getMessage());
                    continue;
                }
                long dt = System.currentTimeMillis() - st;

                String after = Cube555Moves.applyMoves(state, sol);
                boolean staged = isLRStaged(after);
                if (staged) {
                    passed++;
                    System.out.printf("PASS: seed=%-8d scrambleLen=%d → solveLen=%-2d in %4d ms%n",
                        seed, n, sol.size(), dt);
                } else {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d → solveLen=%d but state NOT staged%n",
                        seed, n, sol.size());
                }
            }
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555LRStageTest() {}
}
