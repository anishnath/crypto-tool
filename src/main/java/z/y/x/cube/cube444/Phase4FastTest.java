package z.y.x.cube.cube444;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.cube444.stage.CentresStage;
import z.y.x.cube.cube444.stage.EdgeOrientationStage;
import z.y.x.cube.cube444.stage.FirstFourEdgesStage;
import z.y.x.cube.cube444.stage.Phase4Fast;

/**
 * Focused test: scramble → centres-staging → orient → first-four
 * edges, then call the new state-indexed Phase4Fast.  Goal: verify
 * the .bin / .state_index port actually solves where our previous
 * String-based phase4 hung.
 */
public final class Phase4FastTest {

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
        long t0 = System.currentTimeMillis();
        CentresStage.ensureReady();
        EdgeOrientationStage.ensureReady();
        FirstFourEdgesStage.ensureReady();
        Phase4Fast.ensureReady();   // downloads ~800 KB of .bin + .state_index
        System.out.println("  ready in " + (System.currentTimeMillis() - t0) + "ms\n");

        long[] seeds = {1, 7, 42, 1729, 8675309};
        int succeeded = 0;
        for (long seed : seeds) {
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 30));
            List<String> ud = CentresStage.solveUDStage(scrambled);
            String s1 = Cube444Moves.applyMoves(scrambled, ud);
            List<String> lr = CentresStage.solveLRStage(s1);
            String s2 = Cube444Moves.applyMoves(s1, lr);
            EdgeOrientationStage.OrientationResult o = EdgeOrientationStage.solve(s2);

            // Try multiple phase3 candidates until one yields a phase4-reachable state.
            List<List<String>> phase3Candidates = FirstFourEdgesStage.solveMany(o.state, 100);

            int chosenP3 = -1;
            Phase4Fast.Result e2 = null;
            int p3Len = 0;
            long phase4Total = 0;
            for (int i = 0; i < phase3Candidates.size(); i++) {
                List<String> p3 = phase3Candidates.get(i);
                String afterP3 = Cube444Moves.applyMoves(o.state, p3);
                try {
                    e2 = Phase4Fast.solve(afterP3);
                    chosenP3 = i;
                    p3Len = p3.size();
                    phase4Total += Phase4Fast.lastSolveDurationMs;
                    break;
                } catch (Exception ex) {
                    phase4Total += Phase4Fast.lastSolveDurationMs;
                }
            }

            if (e2 == null) {
                System.out.printf("seed %4d:  ALL %d phase3 candidates UNREACHABLE for phase4%n",
                    seed, phase3Candidates.size());
                continue;
            }

            int total = ud.size() + lr.size() + o.moves.size() + p3Len + e2.moves.size();
            System.out.printf("seed %4d:  centres %d+%d  orient %d  phase3 %d (cand %d/%d)  phase4 %d  TOTAL %d moves  (%d ms phase4)%n",
                seed, ud.size(), lr.size(), o.moves.size(), p3Len, chosenP3 + 1, phase3Candidates.size(),
                e2.moves.size(), total, phase4Total);
            succeeded++;
        }
        System.out.println("\n" + succeeded + "/" + seeds.length + " scrambles solved through phase4");
        System.exit(succeeded == seeds.length ? 0 : 1);
    }

    private Phase4FastTest() {}
}
