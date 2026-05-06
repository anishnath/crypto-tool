package z.y.x.cube.cube555;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import z.y.x.cube.core.Kociemba3x3;

/**
 * 5×5 solver orchestrator — chains all 6 stages plus reduce-to-3×3 and
 * Kociemba.  Pure Java end-to-end (no subprocess).  Public entry point
 * for the {@code CubeSolverServlet}.
 *
 * <p>Pipeline:
 * <ol>
 *   <li>{@link Cube555LRStage} — stage L+R centres on L+R faces</li>
 *   <li>{@link Cube555FBStage} — stage F+B centres on F+B faces</li>
 *   <li>{@link Cube555EOStage} — orient all 24 wings + 12 midges</li>
 *   <li>{@link Cube555Phase4Stage} — stage 4 specific edges (multi-candidate
 *       wing_strs iteration)</li>
 *   <li>{@link Cube555Phase5Stage} — pair the 4 edges + LFRB centres</li>
 *   <li>{@link Cube555Phase6Stage} — pair last 8 edges + solve all centres</li>
 *   <li>{@link Reduce555To333} → {@link Kociemba3x3} — final 3×3 solve</li>
 * </ol>
 *
 * <p>For pragmatic reasons phase 4 currently uses the first wing_strs
 * candidate that survives ({@code Cube555Phase4Stage.solveFirst}) — full
 * multi-candidate retry across all phases is a future optimisation.
 */
public final class Cube555Solver {

    public static final class Result {
        public final boolean solved;
        public final List<String> moves;
        public final List<String> lrMoves, fbMoves, eoMoves, p4Moves, p5Moves, p6Moves, reduceMoves;
        public final String finalState;
        public final long elapsedMs;
        public final String stoppedAt;

        Result(boolean solved, List<String> moves,
               List<String> lr, List<String> fb, List<String> eo,
               List<String> p4, List<String> p5, List<String> p6,
               List<String> reduce,
               String finalState, long elapsedMs, String stoppedAt) {
            this.solved      = solved;
            this.moves       = Collections.unmodifiableList(moves);
            this.lrMoves     = ro(lr);
            this.fbMoves     = ro(fb);
            this.eoMoves     = ro(eo);
            this.p4Moves     = ro(p4);
            this.p5Moves     = ro(p5);
            this.p6Moves     = ro(p6);
            this.reduceMoves = ro(reduce);
            this.finalState  = finalState;
            this.elapsedMs   = elapsedMs;
            this.stoppedAt   = stoppedAt;
        }
        private static List<String> ro(List<String> x) {
            return x == null ? Collections.<String>emptyList() : Collections.unmodifiableList(x);
        }
    }

    private Cube555Solver() {}

    /** Eagerly load all 5×5 lookup tables.  Called at servlet init().
     *  First run downloads ~1.5 GB across the various stage tables. */
    public static void warmUp() {
        try {
            Cube555LRStage.ensureReady();
            Cube555FBStage.ensureReady();
            Cube555EOStage.ensureReady();
            Cube555Phase4Stage.ensureReady();
            Cube555Phase5Stage.ensureReady();
            Cube555Phase6Stage.ensureReady();
            // Kociemba is shared with the 4×4 path — make sure it's registered.
            if (!Kociemba3x3.isRegistered()) {
                Kociemba3x3.set(new z.y.x.cube.kociemba.Kociemba());
            }
        } catch (Exception e) {
            throw new RuntimeException("Cube555Solver warmUp failed", e);
        }
    }

    public static Result solve(String state) throws IOException {
        Cube555.Validation v = Cube555.validate(state);
        if (!v.ok) throw new IllegalArgumentException(v.reason);

        long t0 = System.currentTimeMillis();
        if (Cube555.isSolved(state)) {
            return new Result(true, empty(), empty(), empty(), empty(), empty(),
                empty(), empty(), empty(), state, 0L, null);
        }

        warmUp();   // idempotent; fast after first call

        try {
            // Stage 1: LR centres (deterministic — single solve).
            List<String> lr = Cube555LRStage.solve(state);
            String s1 = Cube555Moves.applyMoves(state, lr);

            // Stage 2: FB centres.
            List<String> fb = Cube555FBStage.solve(s1);
            String s2 = Cube555Moves.applyMoves(s1, fb);

            // Stage 3: edge orientation.
            List<String> eo = Cube555EOStage.solve(s2);
            String s3 = Cube555Moves.applyMoves(s2, eo);

            // Stages 4-6 + Kociemba: try each wing_strs candidate; the first
            // one that gets all the way through Kociemba and produces a
            // solved cube wins.  This mirrors Python's pair_edges logic and
            // is what makes the solver robust to parity edge cases.
            String lastStop = "no wing_strs candidate succeeded";
            for (String[] wings : Cube555Phase4Stage.COMMON_WING_STRS) {
                List<String> p4, p5, p6, kMoves;
                String s4, s5, s6, state3, finalState;
                try {
                    p4 = Cube555Phase4Stage.solveWith(s3, wings, 16);
                    s4 = Cube555Moves.applyMoves(s3, p4);
                    p5 = Cube555Phase5Stage.solve(s4, wings, 24);
                    s5 = Cube555Moves.applyMoves(s4, p5);
                    p6 = Cube555Phase6Stage.solve(s5, 24);
                    s6 = Cube555Moves.applyMoves(s5, p6);
                    state3 = Reduce555To333.to3x3(s6);
                    kMoves = Kociemba3x3.get().solve(state3);
                    finalState = Cube555Moves.applyMoves(s6, kMoves);
                } catch (Exception ex) {
                    lastStop = "wings " + java.util.Arrays.toString(wings)
                        + " failed: " + ex.getMessage();
                    continue;
                }
                if (Cube555.isSolved(finalState)) {
                    List<String> all = merge(lr, fb, eo, p4, p5, p6, kMoves);
                    return new Result(true, all, lr, fb, eo, p4, p5, p6, kMoves,
                        finalState, System.currentTimeMillis() - t0, null);
                }
                lastStop = "wings " + java.util.Arrays.toString(wings)
                    + " produced unsolved final state";
            }

            // All candidates exhausted.
            return new Result(false, empty(), lr, fb, eo, empty(), empty(), empty(),
                empty(), state, System.currentTimeMillis() - t0, lastStop);
        } catch (Exception ex) {
            return new Result(false, empty(), empty(), empty(), empty(), empty(),
                empty(), empty(), empty(), state, System.currentTimeMillis() - t0,
                "solver exception: " + ex.getMessage());
        }
    }

    private static List<String> empty() { return new ArrayList<>(); }

    @SafeVarargs
    private static List<String> merge(List<String>... lists) {
        List<String> out = new ArrayList<>();
        for (List<String> l : lists) if (l != null) out.addAll(l);
        return out;
    }
}
