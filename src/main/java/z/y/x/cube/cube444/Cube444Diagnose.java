package z.y.x.cube.cube444;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.core.IdaSearchBytes;
import z.y.x.cube.cube444.stage.CentresStage;
import z.y.x.cube.cube444.stage.EdgeOrientationStage;
import z.y.x.cube.cube444.stage.FirstFourEdgesStage;
import z.y.x.cube.cube444.stage.LastEightEdgesStage;

/**
 * Diagnostic harness — print actual IDA* behaviour stage-by-stage so
 * we can see where convergence breaks (heuristic always returning 0?
 * search exploring billions of nodes?  goal never recognised?).
 */
public final class Cube444Diagnose {

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

    public static void main(String[] args) throws IOException {
        System.out.println("Warming…");
        long w0 = System.currentTimeMillis();
        CentresStage.ensureReady();
        EdgeOrientationStage.ensureReady();
        FirstFourEdgesStage.ensureReady();
        LastEightEdgesStage.ensureReady();
        System.out.println("  ready in " + (System.currentTimeMillis() - w0) + "ms\n");

        long seed = 1;
        String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 30));

        System.out.println("== Phase 1: centres staging (UD + LR) ==");
        long t = System.currentTimeMillis();
        List<String> ud = CentresStage.solveUDStage(scrambled);
        String s1 = Cube444Moves.applyMoves(scrambled, ud);
        List<String> lr = CentresStage.solveLRStage(s1);
        String s2 = Cube444Moves.applyMoves(s1, lr);
        System.out.printf("  UD %d moves + LR %d moves in %d ms%n%n",
            ud.size(), lr.size(), System.currentTimeMillis() - t);

        System.out.println("== Phase 2: orient edges (step21+22) ==");
        t = System.currentTimeMillis();
        IdaSearchBytes.DEBUG = false;
        EdgeOrientationStage.OrientationResult o = EdgeOrientationStage.solve(s2);
        System.out.printf("  %d moves in %d ms%n%n", o.moves.size(), System.currentTimeMillis() - t);

        System.out.println("== Phase 3: enumerate up to 50 phase3 solutions ==");
        IdaSearchBytes.DEBUG = false;
        long mt = System.currentTimeMillis();
        java.util.List<java.util.List<String>> phase3Many = FirstFourEdgesStage.solveMany(o.state, 50);
        System.out.printf("  found %d phase3 candidates in %d ms%n%n",
            phase3Many.size(), System.currentTimeMillis() - mt);

        System.out.println("== Phase 4: try each phase3 candidate, find one that works ==");
        IdaSearchBytes.DEBUG = false;
        int succeeded = 0;
        long phase4Total = 0;
        for (int i = 0; i < phase3Many.size(); i++) {
            java.util.List<String> p3 = phase3Many.get(i);
            String afterP3 = Cube444Moves.applyMoves(o.state, p3);
            long t4 = System.currentTimeMillis();
            try {
                LastEightEdgesStage.Result e2 = LastEightEdgesStage.solve(afterP3);
                long dt4 = System.currentTimeMillis() - t4;
                phase4Total += dt4;
                succeeded++;
                System.out.printf("  candidate %d: phase3 %d moves + phase4 %d moves SOLVED in %d ms (total: %d moves)%n",
                    i, p3.size(), e2.moves.size(), dt4, p3.size() + e2.moves.size());
                if (succeeded >= 3) break;       // stop after 3 successes — proves it works
            } catch (Exception ex) {
                long dt4 = System.currentTimeMillis() - t4;
                phase4Total += dt4;
                if (i < 5 || i % 10 == 0) {
                    System.out.printf("  candidate %d: phase4 stuck (%d ms)%n", i, dt4);
                }
            }
        }
        System.out.printf("%n== Summary: %d/%d phase3 candidates yielded phase4-solvable state, %d ms total ==%n",
            succeeded, phase3Many.size(), phase4Total);
    }

    private Cube444Diagnose() {}
}
