package z.y.x.cube.cube444;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import z.y.x.cube.core.Kociemba3x3;
import z.y.x.cube.cube444.stage.CentresStage;
import z.y.x.cube.cube444.stage.EdgeOrientationStage;
import z.y.x.cube.cube444.stage.FirstFourEdgesStage;
import z.y.x.cube.cube444.stage.Parity;
import z.y.x.cube.cube444.stage.Phase4Fast;
import z.y.x.cube.kociemba.Kociemba;
import z.y.x.cube.lookup.BinLookupTable;
import z.y.x.cube.lookup.LookupTableLoader;

/**
 * 4×4 solver orchestrator.  Full pipeline:
 *
 *   1. Centres staging        (UD + LR axis, our BFS pruning tables)
 *   2. Edge orientation       (phase2, step21 + step22 lookup)
 *   3. First four dedges      (phase3, step31 + step32 lookup) — multi-
 *                              candidate enumeration filtered by phase4
 *                              reachability.
 *   4. Last eight dedges      (phase4, step41 + step42 .bin tables,
 *                              state-indexed IDA*).
 *   5. Reduce to 3×3          ({@link Reduce333}).
 *   6. Solve 3×3              (Java Kociemba, registered via
 *                              {@link Kociemba3x3#set}).
 *
 * After steps 1–5 the cube is fully reduced (centres + edges look like a
 * 3×3); step 6 finishes corners.  Final move list is returned in
 * application order.
 *
 * Lazy first-call init: ~5 s total to download lookup tables (if not
 * cached) and build Kociemba prune tables.  Subsequent calls are sub-
 * second on most scrambles.
 */
public final class Cube444Solver {

    public static final class Result {
        public final List<String> moves;
        public final List<String> centresMoves;
        public final List<String> orientMoves;
        public final List<String> phase3Moves;
        public final List<String> phase4Moves;
        public final List<String> reduceMoves;
        public final String finalState;
        public final long elapsedMs;
        public final boolean solved;
        public final String stoppedAt;

        Result(List<String> moves,
               List<String> centresMoves,
               List<String> orientMoves,
               List<String> phase3Moves,
               List<String> phase4Moves,
               List<String> reduceMoves,
               String finalState, long elapsedMs, boolean solved, String stoppedAt) {
            this.moves         = Collections.unmodifiableList(moves);
            this.centresMoves  = Collections.unmodifiableList(centresMoves);
            this.orientMoves   = Collections.unmodifiableList(orientMoves);
            this.phase3Moves   = Collections.unmodifiableList(phase3Moves);
            this.phase4Moves   = Collections.unmodifiableList(phase4Moves);
            this.reduceMoves   = Collections.unmodifiableList(reduceMoves);
            this.finalState    = finalState;
            this.elapsedMs     = elapsedMs;
            this.solved        = solved;
            this.stoppedAt     = stoppedAt;
        }
    }

    private Cube444Solver() {}

    /** How many phase3 candidates to enumerate per scramble before
     *  giving up.  Each candidate is filtered by phase4 reachability;
     *  Python's reference uses 50 by default. */
    private static final int PHASE3_CANDIDATES = 200;

    /** Eagerly load every prune table + Kociemba init.  Call once at
     *  servlet init() to pay the ~5 s warm-up off the request path. */
    public static void warmUp() {
        try {
            CentresStage.ensureReady();
            EdgeOrientationStage.ensureReady();
            FirstFourEdgesStage.ensureReady();
            Phase4Fast.ensureReady();
            ensureKociembaRegistered();
            // Trigger Kociemba prune-table build now (else it blocks
            // the first solve request).
            Kociemba3x3.get().solve(
                "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB");
        } catch (Exception e) {
            throw new RuntimeException("Cube444Solver warmUp failed", e);
        }
    }

    private static synchronized void ensureKociembaRegistered() {
        if (!Kociemba3x3.isRegistered()) Kociemba3x3.set(new Kociemba());
    }

    /**
     * Solve a scrambled 4×4 cube.  Throws {@link IllegalArgumentException}
     * if {@code state} is not a valid 96-character cube state.  Returns
     * a {@link Result} with {@code solved=true} on success or
     * {@code solved=false} with {@code stoppedAt} indicating where the
     * pipeline gave up (for diagnostics).
     */
    public static Result solve(String state) throws IOException {
        Cube444.Validation v = Cube444.validate(state);
        if (!v.ok) throw new IllegalArgumentException(v.reason);

        long t0 = System.currentTimeMillis();
        List<String> empty = new ArrayList<>();

        if (Cube444.isSolved(state)) {
            return new Result(empty, empty, empty, empty, empty, empty,
                state, System.currentTimeMillis() - t0, true, null);
        }

        ensureKociembaRegistered();
        CentresStage.ensureReady();
        EdgeOrientationStage.ensureReady();
        FirstFourEdgesStage.ensureReady();
        Phase4Fast.ensureReady();

        // ── Stage 1: centres staging (UD + LR only — fine done by phase4).
        List<String> centresMoves = new ArrayList<>();
        List<String> ud = CentresStage.solveUDStage(state);
        centresMoves.addAll(ud);
        String s1 = Cube444Moves.applyMoves(state, ud);
        List<String> lr = CentresStage.solveLRStage(s1);
        centresMoves.addAll(lr);
        String s2 = Cube444Moves.applyMoves(s1, lr);

        // ── Stage 2: orient edges.
        EdgeOrientationStage.OrientationResult o = EdgeOrientationStage.solve(s2);

        // ── Stage 3 + 4: enumerate phase3 candidates, retry phase4 until
        //                 one yields a fully reduced cube.  Phase4 is
        //                 fast (ms each) so we can afford many tries.
        BinLookupTable centresTbl = LookupTableLoader.fetchBin(
            "lookup-table-4x4x4-step41-centers", Phase4Fast.LEGAL_MOVES.size());
        BinLookupTable edgesTbl = LookupTableLoader.fetchBin(
            "lookup-table-4x4x4-step42-last-eight-edges", Phase4Fast.LEGAL_MOVES.size());

        List<List<String>> p3Candidates =
            FirstFourEdgesStage.solveManyReachable(o.state, PHASE3_CANDIDATES,
                PHASE3_CANDIDATES * 5, centresTbl, edgesTbl);

        if (p3Candidates.isEmpty()) {
            return new Result(merge(centresMoves, o.moves), centresMoves, o.moves,
                empty, empty, empty,
                o.state, System.currentTimeMillis() - t0, false,
                "phase3 produced no phase4-reachable candidate");
        }

        List<String> phase3Moves = null;
        Phase4Fast.Result phase4Res = null;
        String afterPhase4 = null;

        // Strategy: try each phase3 candidate, run phase4, then attempt
        // Kociemba on the reduced 3×3 view.  Apply Kociemba's moves to
        // the FULL 4×4 state and check whether ALL 96 stickers are
        // solved.  If not (Kociemba moves only fixed the sampled-by-
        // Reduce333 positions), try the next phase3 candidate.  This is
        // the same retry-until-solved pattern Python uses with multi-
        // solution counts.
        List<String> chosenKociemba = null;

        outer:
        for (List<String> p3 : p3Candidates) {
            String afterP3 = Cube444Moves.applyMoves(o.state, p3);
            Phase4Fast.Result r;
            try {
                r = Phase4Fast.solve(afterP3);
            } catch (Exception ex) {
                continue;
            }

            String state3 = Reduce333.to3x3(r.state);
            List<String> kMoves;
            try {
                kMoves = Kociemba3x3.get().solve(state3);
            } catch (Exception ex) {
                continue;
            }

            String trial = Cube444Moves.applyMoves(r.state, kMoves);
            if (Cube444.isSolved(trial)) {
                phase3Moves = p3;
                phase4Res = r;
                afterPhase4 = r.state;
                chosenKociemba = kMoves;
                break outer;
            }
        }

        if (afterPhase4 == null) {
            return new Result(merge(centresMoves, o.moves), centresMoves, o.moves,
                empty, empty, empty,
                o.state, System.currentTimeMillis() - t0, false,
                "no phase3 candidate yields a Kociemba-solvable cube");
        }

        // Apply chosen Kociemba moves to verify and produce final state.
        String finalState = Cube444Moves.applyMoves(afterPhase4, chosenKociemba);
        boolean solved = Cube444.isSolved(finalState);

        List<String> all = merge(centresMoves, o.moves, phase3Moves, phase4Res.moves, chosenKociemba);
        return new Result(all, centresMoves, o.moves, phase3Moves,
            phase4Res.moves, chosenKociemba,
            finalState, System.currentTimeMillis() - t0, solved,
            solved ? null : "post-kociemba state not solved");
    }

    @SafeVarargs
    private static List<String> merge(List<String>... lists) {
        List<String> out = new ArrayList<>();
        for (List<String> l : lists) if (l != null) out.addAll(l);
        return out;
    }

    /** True iff every face's 12 non-corner stickers (centres + wings)
     *  match that face's colour.  Corner stickers may still be permuted
     *  — Kociemba handles those. */
    private static boolean isFullyReduced(String state) {
        int[] checkPositions = {1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14};
        for (char f : Cube444.FACES) {
            int off = Cube444.faceOffset(f);
            for (int p : checkPositions) {
                if (state.charAt(off + p) != f) return false;
            }
        }
        return true;
    }
}
