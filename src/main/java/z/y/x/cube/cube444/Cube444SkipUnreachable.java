package z.y.x.cube.cube444;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.cube444.stage.CentresStage;
import z.y.x.cube.cube444.stage.EdgeOrientationStage;
import z.y.x.cube.cube444.stage.FirstFourEdgesStage;
import z.y.x.cube.cube444.stage.Phase4Fast;
import z.y.x.cube.lookup.BinLookupTable;
import z.y.x.cube.lookup.LookupTableLoader;

/**
 * Diagnostic: when phase3 produces a state phase4 can't reach, try
 * MORE phase3 solutions and filter to ones whose edge state is
 * actually in step42's index.  Python's "--solution-count" with
 * filtering is essentially this.
 */
public final class Cube444SkipUnreachable {

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
        CentresStage.ensureReady();
        EdgeOrientationStage.ensureReady();
        FirstFourEdgesStage.ensureReady();
        Phase4Fast.ensureReady();

        // Pre-fetch table refs for the reachability filter.
        BinLookupTable centresTbl = LookupTableLoader.fetchBin(
            "lookup-table-4x4x4-step41-centers", Phase4Fast.LEGAL_MOVES.size());
        BinLookupTable edgesTbl   = LookupTableLoader.fetchBin(
            "lookup-table-4x4x4-step42-last-eight-edges", Phase4Fast.LEGAL_MOVES.size());

        long[] seeds = {1, 7, 42, 1729, 8675309};
        int succeeded = 0;
        for (long seed : seeds) {
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 30));
            List<String> ud = CentresStage.solveUDStage(scrambled);
            String s1 = Cube444Moves.applyMoves(scrambled, ud);
            List<String> lr = CentresStage.solveLRStage(s1);
            String s2 = Cube444Moves.applyMoves(s1, lr);
            EdgeOrientationStage.OrientationResult o = EdgeOrientationStage.solve(s2);

            // Generate many phase3 candidates, filter to ones whose
            // post-phase3 state is actually phase4-reachable (BOTH centres
            // AND edges keys are present in the step41+step42 tables).
            int candidatesGenerated = 0;
            int candidatesReachable = 0;

            long t0 = System.currentTimeMillis();
            int totalRequest = 500;
            List<List<String>> phase3Candidates = FirstFourEdgesStage.solveMany(o.state, totalRequest);
            candidatesGenerated = phase3Candidates.size();

            Phase4Fast.Result e2 = null;
            int chosenP3Len = 0;
            int chosenIdx = -1;
            List<String> reorient = new ArrayList<>();
            // Cube reorientations to try if direct path fails.  Each is a
            // sequence using only our 36 base moves but achieves a
            // whole-cube rotation, putting the cube in an equivalent but
            // differently-labeled state that may now be in phase4's tables.
            String[][] reorientCandidates = {
                {},                                // no reorientation (try first)
                {"Rw2", "L2"},                     // x2 — swaps U↔D, F↔B
                {"Uw2", "D2"},                     // y2 — swaps L↔R, F↔B
                {"Fw2", "B2"},                     // z2 — swaps U↔D, L↔R
            };

            outer:
            for (int rIdx = 0; rIdx < reorientCandidates.length; rIdx++) {
                String[] reorientMoves = reorientCandidates[rIdx];
                for (int i = 0; i < phase3Candidates.size(); i++) {
                    List<String> p3 = phase3Candidates.get(i);
                    String afterP3 = Cube444Moves.applyMoves(o.state, p3);
                    String afterReorient = afterP3;
                    for (String m : reorientMoves) {
                        afterReorient = Cube444Moves.applyMove(afterReorient, m);
                    }
                    String cKey = EdgesRecolor.step41StateOf(afterReorient);
                    String eKey = EdgesRecolor.step42StateOf(afterReorient);
                    if (centresTbl.indexOf(cKey) < 0 || edgesTbl.indexOf(eKey) < 0) continue;
                    candidatesReachable++;
                    try {
                        e2 = Phase4Fast.solve(afterReorient);
                        chosenP3Len = p3.size();
                        chosenIdx = i;
                        for (String m : reorientMoves) reorient.add(m);
                        break outer;
                    } catch (Exception ex) {
                        // edge case
                    }
                }
            }
            long elapsed = System.currentTimeMillis() - t0;

            if (e2 == null) {
                System.out.printf("seed %4d: %d phase3 generated, %d phase4-reachable, NO solution found in %d ms%n",
                    seed, candidatesGenerated, candidatesReachable, elapsed);
                continue;
            }

            int total = ud.size() + lr.size() + o.moves.size() + chosenP3Len + reorient.size() + e2.moves.size();
            System.out.printf("seed %4d:  c %d+%d  o %d  p3 %d (%d/%d, %d reach)  reorient %d  p4 %d  TOTAL %d  (%d ms)%n",
                seed, ud.size(), lr.size(), o.moves.size(), chosenP3Len,
                chosenIdx + 1, candidatesGenerated, candidatesReachable,
                reorient.size(), e2.moves.size(), total, elapsed);
            succeeded++;
        }
        System.out.println("\n" + succeeded + "/" + seeds.length + " scrambles solved through phase4");
    }

    private Cube444SkipUnreachable() {}
}
