package z.y.x.cube.cube444;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.cube444.stage.CentresStage;
import z.y.x.cube.cube444.stage.EdgeOrientationStage;
import z.y.x.cube.cube444.stage.FirstFourEdgesStage;
import z.y.x.cube.cube444.stage.LastEightEdgesStage;

/**
 * End-to-end pipeline test for the Java port:
 *
 *   scramble  →  centres staging (UD + LR)
 *             →  phase 2 orientation (step21)
 *             →  phase 3 first-four edges (step32)
 *             →  phase 4 last-eight edges (step42)
 *
 * After phase 4, the cube is fully reduced to a 3×3 — every face is
 * monochromatic and every dedge is paired.  Kociemba handoff happens
 * in a separate file (TODO).
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/**.java
 *   java  -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *         -cp /tmp/cube-classes:src/main/resources \
 *         z.y.x.cube.cube444.Cube444PipelineTest
 *
 * On first run downloads the four needed lookup tables (step21, step32,
 * step42 — total ~100 MB compressed).  Subsequent runs reuse the cache.
 */
public final class Cube444PipelineTest {

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else { fail++;
            System.err.println("  FAIL: " + name);
            if (!detail.isEmpty()) System.err.println("        " + detail);
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

    /** True iff every face's 16 stickers are that face's colour, EXCLUDING
     *  corner positions (since corners aren't touched by our pipeline yet —
     *  Kociemba handles them).  In a fully-reduced 4×4, edges + centres
     *  match the face label; corners can still be permuted. */
    private static boolean isReduced(String state) {
        // Each face must have its 4 centres and 8 wing stickers in matching
        // colour.  Corner stickers (positions 0, 3, 12, 15) can differ.
        int[] checkPositions = {1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14};
        for (char f : Cube444.FACES) {
            int off = Cube444.faceOffset(f);
            for (int p : checkPositions) {
                if (state.charAt(off + p) != f) return false;
            }
        }
        return true;
    }

    public static void main(String[] args) throws IOException {
        System.out.println("Warming up centres pruning tables…");
        long w0 = System.currentTimeMillis();
        CentresStage.ensureReady();
        System.out.println("  centres ready in " + (System.currentTimeMillis() - w0) + "ms");

        System.out.println("Fetching lookup tables…");
        long t0 = System.currentTimeMillis();
        try {
            EdgeOrientationStage.ensureReady();
            FirstFourEdgesStage.ensureReady();
            LastEightEdgesStage.ensureReady();
        } catch (IOException ex) {
            System.err.println("  lookup-table fetch failed: " + ex.getMessage());
            System.exit(1);
        }
        System.out.println("  all 3 tables ready in " + (System.currentTimeMillis() - t0) + "ms");

        long[] seeds = {1, 7, 42, 1729, 8675309};
        int totalMoves = 0, maxMoves = 0;

        for (long seed : seeds) {
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 30));

            // ─ Stage 1: centres staging (UD + LR) ─
            List<String> ud = CentresStage.solveUDStage(scrambled);
            String s1 = Cube444Moves.applyMoves(scrambled, ud);
            List<String> lr = CentresStage.solveLRStage(s1);
            String s2 = Cube444Moves.applyMoves(s1, lr);

            // ─ Stage 2: orient edges ─
            EdgeOrientationStage.OrientationResult o = EdgeOrientationStage.solve(s2);

            // ─ Stage 3: first four edges ─
            FirstFourEdgesStage.Result e1 = FirstFourEdgesStage.solve(o.state);

            // ─ Stage 4: last eight edges ─
            LastEightEdgesStage.Result e2;
            try {
                e2 = LastEightEdgesStage.solve(e1.state);
            } catch (Exception ex) {
                check("seed " + seed + ": phase4 succeeds", false, ex.getMessage());
                continue;
            }

            int total = ud.size() + lr.size() + o.moves.size() + e1.moves.size() + e2.moves.size();
            totalMoves += total;
            if (total > maxMoves) maxMoves = total;

            check("seed " + seed + ": phase4 reaches step42 goal",
                LastEightEdgesStage.isSolved(e2.state));
            check("seed " + seed + ": cube is reduced (centres + edges all matching)",
                isReduced(e2.state),
                "final state: " + e2.state);

            System.out.println("  seed " + String.format("%8d", seed) + ": "
                + ud.size() + "+" + lr.size()
                + "+" + o.moves.size() + "+" + e1.moves.size() + "+" + e2.moves.size()
                + "=" + total + " moves");
        }

        System.out.println();
        System.out.println("Avg total: " + (totalMoves / seeds.length) + " moves, max " + maxMoves);
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private Cube444PipelineTest() {}
}
