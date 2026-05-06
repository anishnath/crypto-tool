package z.y.x.cube.cube555;

import java.util.List;

/**
 * End-to-end test: scramble a 5×5, run LR-stage → FB-stage → EO-stage,
 * verify centres remain staged AND every wing/midge ends up oriented.
 *
 * <h2>Run</h2>
 *
 * <pre>
 *   javac -d /tmp/cube555-classes \
 *     $(ls src/main/java/z/y/x/cube/core/*.java | grep -v MovePruningTest) \
 *     src/main/java/z/y/x/cube/lookup/*.java \
 *     src/main/java/z/y/x/cube/cube555/*.java
 *   java -Dcube.lookup.cacheDir=$HOME/.cube-lookup-tables \
 *        -cp /tmp/cube555-classes:src/main/resources \
 *        z.y.x.cube.cube555.Cube555EOStageTest
 * </pre>
 *
 * <p>First run will download ~33 MB for step902 — cached after.
 */
public final class Cube555EOStageTest {

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

    private static boolean isCentresStaged(String state) {
        // L+R faces: only L/R stickers; F+B: only F/B; U+D: only U/D.
        char[][] groups = { {'L','R'}, {'F','B'}, {'U','D'} };
        char[][] faces  = { {'L','R'}, {'F','B'}, {'U','D'} };
        for (int g = 0; g < 3; g++) {
            for (char f : faces[g]) {
                int off = Cube555.faceOffset(f);
                for (int p : Cube555.CENTRE_POS) {
                    char c = state.charAt(off + p);
                    boolean inGroup = false;
                    for (char gc : groups[g]) if (c == gc) inGroup = true;
                    if (!inGroup) return false;
                }
            }
        }
        return true;
    }

    /** EO done = both encoded states equal their goal. */
    private static boolean isEOSolved(String state) {
        String outer = Cube555Edges.encodeEOOuter(state);
        String inner = Cube555Edges.encodeEOInner(state);
        // Goal for outer: same as Python's "UDDUUDDUDUDUUDUDDUUDDUUDDUDUUDUDDUUDDUUDUDDUUDDU"
        // — the canonical EO outer pattern of a fully oriented cube.
        // We don't check against the literal goal here (it depends on
        // the encoding's bit layout); instead, both inner+outer must
        // contain only U's (cost-0 from the prune table's perspective).
        // The Python step903 goal is "UUUUUUUUUUUUUUUUUUUUUUUU" — all U.
        // step902's goal pattern is more nuanced but BinLookupTable's
        // costAt() will return 0 iff we're at the canonical goal.
        for (int i = 0; i < inner.length(); i++) if (inner.charAt(i) != 'U') return false;
        // For outer, check the goal pattern matches Python's:
        String OUTER_GOAL = "UDDUUDDUDUDUUDUDDUUDDUUDDUDUUDUDDUUDDUUDUDDUUDDU";
        return outer.equals(OUTER_GOAL);
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Warming up centres + EO tables (downloads on first run)...");
        long t0 = System.currentTimeMillis();
        Cube555LRStage.ensureReady();
        Cube555FBStage.ensureReady();
        Cube555EOStage.ensureReady();
        System.out.println("  warm in " + (System.currentTimeMillis() - t0) + " ms\n");

        // Solved cube → empty solution from each stage.
        if (Cube555EOStage.solve(Cube555.SOLVED).isEmpty()) {
            passed++; System.out.println("PASS: solved → empty EO solution");
        } else {
            failed++; System.err.println("FAIL: solved → non-empty EO solution");
        }

        // Real scrambles.  EO is more expensive than centres; cap at
        // small lengths first.
        long[] seeds = {1, 7, 42};
        int[] scrambleLengths = {5, 10};

        for (int n : scrambleLengths) {
            for (long seed : seeds) {
                String scr = scramble(seed, n);
                String state = Cube555Moves.applyMoves(Cube555.SOLVED, scr);

                long st = System.currentTimeMillis();
                List<String> lr, fb, eo;
                String afterLR, afterFB, afterEO;
                try {
                    lr = Cube555LRStage.solve(state);
                    afterLR = Cube555Moves.applyMoves(state, lr);
                    fb = Cube555FBStage.solve(afterLR);
                    afterFB = Cube555Moves.applyMoves(afterLR, fb);
                    eo = Cube555EOStage.solve(afterFB);
                    afterEO = Cube555Moves.applyMoves(afterFB, eo);
                } catch (Exception ex) {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d threw: %s%n",
                        seed, n, ex.getMessage());
                    continue;
                }
                long dt = System.currentTimeMillis() - st;

                boolean centres = isCentresStaged(afterEO);
                boolean eoOk    = isEOSolved(afterEO);
                if (centres && eoOk) {
                    passed++;
                    System.out.printf(
                        "PASS: seed=%-8d n=%-2d  LR=%-2d  FB=%-2d  EO=%-2d  total=%-2d  in %5d ms%n",
                        seed, n, lr.size(), fb.size(), eo.size(),
                        lr.size() + fb.size() + eo.size(), dt);
                } else {
                    failed++;
                    System.err.printf("FAIL: seed=%d n=%d  centres-staged=%s  EO-solved=%s%n",
                        seed, n, centres, eoOk);
                }
            }
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555EOStageTest() {}
}
