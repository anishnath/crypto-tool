package z.y.x.cube.cube444.stage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import z.y.x.cube.core.IdaSearch;
import z.y.x.cube.core.MoveSkipMatrix;
import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube444.EdgesRecolor;
import z.y.x.cube.cube444.HighLowEdges;
import z.y.x.cube.lookup.LookupTable;
import z.y.x.cube.lookup.LookupTableLoader;
import z.y.x.cube.lookup.LookupTableRegistry;

/**
 * Phase-2 (edge orientation) solver — port of {@code LookupTableIDA444Phase2}
 * from the Python reference, restricted to its step21 prune table.
 *
 * Approach:
 *   1. Compute the 48-char high/low orientation key via {@link HighLowEdges}.
 *   2. Direct lookup in {@code lookup-table-4x4x4-step21-highlow-edges-edges.txt}
 *      — covers everything within 8 moves of the goal.
 *   3. If that misses (state is at depth > 8), fall back to IDA* using the
 *      same table as the heuristic: {@code h(state) = depth-of-lookup-soln
 *      if found, else 9}.  The search runs to a configurable maxDepth (15
 *      is plenty in practice — Python's phase-2 max observed is ~13).
 *
 * Move set restrictions match the Python source:
 *   illegal: Uw, Uw', Dw, Dw', Fw, Fw', Bw, Bw'  (these would un-stage
 *   the centres pipeline that already ran).
 *
 * Goal: orientation key equals
 *   "UDDUUDDUDUDUUDUDDUUDDUUDDUDUUDUDDUUDDUUDUDDUUDDU"
 * which is the orientation pattern of the solved cube.
 */
public final class EdgeOrientationStage {

    /** Goal orientation string — the value of {@code highlow_edges_state}
     *  on a solved cube, by inspection.  Stored as a constant so we can
     *  short-circuit when the cube is already oriented. */
    public static final String GOAL = HighLowEdges.stateOf(Cube444.SOLVED);

    /** Max IDA* depth before giving up.  Empirically Python's phase-2
     *  finishes in 8-13 moves on typical scrambles. */
    private static final int MAX_DEPTH = 15;

    /** Beyond-table heuristic value.  step21 covers depth 0..8, so any
     *  miss means depth ≥ 9.  Admissible because the table is exact. */
    private static final int HORIZON_PLUS_ONE = 9;

    /** Phase-2 legal move set, in the order Python iterates them.
     *  Excludes Uw/Uw'/Dw/Dw'/Fw/Fw'/Bw/Bw' which would disturb already-
     *  staged centres. */
    public static final List<String> LEGAL_MOVES;
    static {
        Set<String> illegal = new HashSet<>(Arrays.asList(
            "Uw", "Uw'", "Dw", "Dw'", "Fw", "Fw'", "Bw", "Bw'"
        ));
        List<String> ms = new ArrayList<>(28);
        for (String m : Cube444Moves.ALL_MOVES) if (!illegal.contains(m)) ms.add(m);
        LEGAL_MOVES = Collections.unmodifiableList(ms);
    }

    /** Precomputed move-pair pruning matrix using {@link
     *  z.y.x.cube.core.MovePruning} predicates — much stronger than the
     *  prior "skip same-face" heuristic. */
    private static final MoveSkipMatrix SKIP = new MoveSkipMatrix(LEGAL_MOVES);

    private static volatile LookupTable EDGES_TABLE = null;
    private static volatile LookupTable CENTRES_TABLE = null;

    /** Pre-load both phase-2 lookup tables. */
    public static synchronized void ensureReady() throws IOException {
        if (EDGES_TABLE == null) {
            EDGES_TABLE = LookupTableLoader.fetch(LookupTableRegistry.CUBE444_HIGHLOW_EDGES_EDGES);
        }
        if (CENTRES_TABLE == null) {
            CENTRES_TABLE = LookupTableLoader.fetch(LookupTableRegistry.CUBE444_HIGHLOW_EDGES_CENTRES);
        }
    }

    public static boolean isReady() { return EDGES_TABLE != null && CENTRES_TABLE != null; }

    public static boolean isOrientationSolved(String state) {
        return GOAL.equals(HighLowEdges.stateOf(state));
    }

    /** True if step22's centres encoder for {@code state} is in the table
     *  with an empty solution — i.e. matches one of the 12 valid goal
     *  patterns. */
    private static boolean isCentresAxisSolved(String state) {
        if (CENTRES_TABLE == null) return true;       // before init, can't check
        String key = EdgesRecolor.step22StateOf(state);
        String soln = CENTRES_TABLE.lookup(key);
        return soln != null && soln.isEmpty();
    }

    /** True iff phase2 fully complete: edges oriented AND centres still
     *  axis-staged (matches one of step22's 12 goal targets). */
    public static boolean isPhase2Complete(String state) {
        return isOrientationSolved(state) && isCentresAxisSolved(state);
    }

    /* ─────────────────────────────────────────────────────────────────
     *  Solve
     * ──────────────────────────────────────────────────────────────── */

    public static final class OrientationResult {
        public final List<String> moves;
        public final String state;
        public final int depth;
        public final boolean usedIda;
        OrientationResult(List<String> moves, String state, int depth, boolean usedIda) {
            this.moves = Collections.unmodifiableList(moves);
            this.state = state;
            this.depth = depth;
            this.usedIda = usedIda;
        }
    }

    public static OrientationResult solve(String state) throws IOException {
        ensureReady();

        if (isPhase2Complete(state)) {
            return new OrientationResult(new ArrayList<String>(), state, 0, false);
        }

        // Combined IDA* over both step21 (edges) and step22 (centres).
        // Direct-lookup fast path no longer applies — single-table moves
        // can break the OTHER table's goal.  Phase2 goal is reached only
        // when BOTH tables report 0.
        List<String> moves = IdaSearch.find(state, new Domain(), MAX_DEPTH);
        if (moves == null) {
            throw new IllegalStateException(
                "phase2 IDA* exhausted depth " + MAX_DEPTH
                + " — edges=" + HighLowEdges.stateOf(state)
                + " centres=" + EdgesRecolor.step22StateOf(state));
        }
        String after = Cube444Moves.applyMoves(state, moves);
        return new OrientationResult(moves, after, moves.size(), true);
    }

    /** Distance estimate from the given table.  Returns horizonPlusOne
     *  if the state isn't in the table. */
    private static int distance(LookupTable table, String key, int horizon) {
        String soln = table.lookup(key);
        if (soln == null) return horizon;
        if (soln.isEmpty()) return 0;
        int n = 1;
        for (int i = 0; i < soln.length(); i++) if (soln.charAt(i) == ' ') n++;
        return n;
    }

    private static final class Domain implements IdaSearch.Domain<String> {
        @Override public String applyMove(String state, int moveIdx) {
            return Cube444Moves.applyMove(state, LEGAL_MOVES.get(moveIdx));
        }

        @Override public int heuristic(String state) {
            String edgesKey = HighLowEdges.stateOf(state);
            String centresKey = EdgesRecolor.step22StateOf(state);
            int hE = GOAL.equals(edgesKey) ? 0 : distance(EDGES_TABLE, edgesKey, HORIZON_PLUS_ONE);
            int hC = distance(CENTRES_TABLE, centresKey, 9);
            return Math.max(hE, hC);
        }

        @Override public int moveCount() { return LEGAL_MOVES.size(); }
        @Override public String moveLabel(int moveIdx) { return LEGAL_MOVES.get(moveIdx); }
        @Override public boolean shouldSkip(int prev, int curr) { return SKIP.shouldSkip(prev, curr); }
    }

    private EdgeOrientationStage() {}
}
