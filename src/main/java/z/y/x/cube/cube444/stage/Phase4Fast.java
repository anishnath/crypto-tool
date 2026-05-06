package z.y.x.cube.cube444.stage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube444.EdgesRecolor;
import z.y.x.cube.lookup.BinLookupTable;
import z.y.x.cube.lookup.LookupTableLoader;

/**
 * High-performance phase-4 solver — port of the C engine's IDA* that
 * uses precomputed state-indexed binary tables ({@code .bin} +
 * {@code .state_index}) for O(1) heuristic + O(1) move transition.
 *
 * No string ops, no encoder, no applyMove inside the inner loop.  The
 * IDA* state is just two integer indices (one per prune table); each
 * move is two byte-array reads.  This is the algorithm Python's
 * {@code ida_search_via_graph.c} uses, ported to Java verbatim.
 *
 * Move ordering MUST match Python's {@code moves_444} since the .bin
 * column layout was generated in that order.  Python's order is
 * {@code U R F D L B} → outer 1/'/2 then wide 1/'/2, BUT the face-list
 * iteration in Python is U, L, F, R, B, D (different from our
 * {@link Cube444Moves#ALL_MOVES} which uses U, R, F, D, L, B).
 */
public final class Phase4Fast {

    /** Python's moves_444 — the full 36-move roster, in Python's order. */
    private static final String[] MOVES_444_PY = {
        "U", "U'", "U2", "Uw", "Uw'", "Uw2",
        "L", "L'", "L2", "Lw", "Lw'", "Lw2",
        "F", "F'", "F2", "Fw", "Fw'", "Fw2",
        "R", "R'", "R2", "Rw", "Rw'", "Rw2",
        "B", "B'", "B2", "Bw", "Bw'", "Bw2",
        "D", "D'", "D2", "Dw", "Dw'", "Dw2",
    };

    /** Phase4's illegal-move set (matches Python's
     *  LookupTableIDA444Phase4 specification). */
    private static final java.util.Set<String> ILLEGAL = new java.util.HashSet<>(java.util.Arrays.asList(
        "Uw", "Uw'", "Lw", "Lw'", "Fw", "Fw'",
        "Rw", "Rw'", "Bw", "Bw'", "Dw", "Dw'",
        "L",  "L'",  "R",  "R'",
        "Uw2", "Dw2",
        "F",  "F'",  "B",  "B'"
    ));

    /** Phase4 legal moves in Python order (matching .bin column layout). */
    public static final List<String> LEGAL_MOVES;
    static {
        List<String> ms = new ArrayList<>(14);
        for (String m : MOVES_444_PY) if (!ILLEGAL.contains(m)) ms.add(m);
        LEGAL_MOVES = Collections.unmodifiableList(ms);
    }

    public static final int MAX_DEPTH = 18;

    private static volatile BinLookupTable PT_CENTRES = null;     // step41
    private static volatile BinLookupTable PT_EDGES   = null;     // step42

    public static synchronized void ensureReady() throws IOException {
        if (PT_CENTRES == null) {
            PT_CENTRES = LookupTableLoader.fetchBin(
                "lookup-table-4x4x4-step41-centers", LEGAL_MOVES.size());
        }
        if (PT_EDGES == null) {
            PT_EDGES = LookupTableLoader.fetchBin(
                "lookup-table-4x4x4-step42-last-eight-edges", LEGAL_MOVES.size());
        }
    }

    public static boolean isReady() { return PT_CENTRES != null && PT_EDGES != null; }

    /** Diagnostic: nodes explored on the most recent solve call. */
    public static volatile long lastNodesExplored = 0;
    public static volatile long lastSolveDurationMs = 0;

    public static final class Result {
        public final List<String> moves;
        public final String state;
        public final int depth;
        Result(List<String> moves, String state, int depth) {
            this.moves = Collections.unmodifiableList(moves);
            this.state = state;
            this.depth = depth;
        }
    }

    /**
     * Solve phase 4 using state-indexed IDA*.  Throws if the cube state
     * isn't in the prune tables (i.e. phase 3 left us in an unreachable
     * configuration — the caller should try a different phase 3
     * solution).
     */
    public static Result solve(String state) throws IOException {
        ensureReady();
        long t0 = System.currentTimeMillis();

        // Compute initial state IDs in both prune tables.
        String centresKey = EdgesRecolor.step41StateOf(state);
        String edgesKey   = EdgesRecolor.step42StateOf(state);

        int centresIdx = PT_CENTRES.indexOf(centresKey);
        int edgesIdx   = PT_EDGES.indexOf(edgesKey);

        if (centresIdx < 0) {
            throw new IllegalStateException(
                "phase4 unreachable: centres state '" + centresKey
                + "' not in step41 lookup table");
        }
        if (edgesIdx < 0) {
            throw new IllegalStateException(
                "phase4 unreachable: edges state '" + edgesKey
                + "' not in step42 lookup table");
        }

        int centresCost = PT_CENTRES.costAt(centresIdx);
        int edgesCost   = PT_EDGES.costAt(edgesIdx);

        if (centresCost == 0 && edgesCost == 0) {
            lastSolveDurationMs = System.currentTimeMillis() - t0;
            lastNodesExplored = 0;
            return new Result(new ArrayList<String>(), state, 0);
        }

        // IDA* over (centresIdx, edgesIdx) tuples.  Allocation-free hot path.
        final int moveCount = LEGAL_MOVES.size();
        final int[] pathMove   = new int[MAX_DEPTH + 2];
        final int[] pathCent   = new int[MAX_DEPTH + 2];
        final int[] pathEdges  = new int[MAX_DEPTH + 2];
        final int[] cursor     = new int[MAX_DEPTH + 2];

        pathCent[0]  = centresIdx;
        pathEdges[0] = edgesIdx;

        int threshold = Math.max(centresCost, edgesCost);
        long nodes = 0;

        while (threshold <= MAX_DEPTH) {
            int nextThreshold = Integer.MAX_VALUE;
            int depth = 0;
            cursor[0] = 0;

            while (depth >= 0) {
                int m = cursor[depth];
                if (m >= moveCount) { depth--; continue; }
                cursor[depth] = m + 1;

                if (depth > 0 && shouldSkip(pathMove[depth - 1], m)) continue;

                int parentCent  = pathCent[depth];
                int parentEdges = pathEdges[depth];
                int newCent     = PT_CENTRES.nextStateAt(parentCent, m);
                int newEdges    = PT_EDGES.nextStateAt(parentEdges, m);
                int hC          = PT_CENTRES.costAt(newCent);
                int hE          = PT_EDGES.costAt(newEdges);
                int h           = hC > hE ? hC : hE;
                int f           = (depth + 1) + h;

                nodes++;

                if (f > threshold) {
                    if (f < nextThreshold) nextThreshold = f;
                    continue;
                }

                if (h == 0) {
                    pathMove[depth] = m;
                    List<String> out = new ArrayList<>(depth + 1);
                    for (int i = 0; i <= depth; i++) out.add(LEGAL_MOVES.get(pathMove[i]));
                    String resultState = Cube444Moves.applyMoves(state, out);
                    lastSolveDurationMs = System.currentTimeMillis() - t0;
                    lastNodesExplored = nodes;
                    return new Result(out, resultState, out.size());
                }

                pathMove[depth]    = m;
                depth++;
                if (depth > MAX_DEPTH) { depth--; continue; }
                pathCent[depth]    = newCent;
                pathEdges[depth]   = newEdges;
                cursor[depth]      = 0;
            }

            if (nextThreshold == Integer.MAX_VALUE) break;
            if (nextThreshold > MAX_DEPTH) break;
            threshold = nextThreshold;
        }

        lastSolveDurationMs = System.currentTimeMillis() - t0;
        lastNodesExplored = nodes;
        throw new IllegalStateException(
            "phase4 IDA* exhausted depth " + MAX_DEPTH + " (nodes: " + nodes + ")");
    }

    /** Move-pair pruning by face — same as
     *  {@link z.y.x.cube.core.MovePruning#shouldSkip} but precomputed
     *  for our 14 legal moves to skip the polymorphic dispatch. */
    private static final boolean[][] SKIP = computeSkip();
    private static boolean[][] computeSkip() {
        int n = LEGAL_MOVES.size();
        boolean[][] s = new boolean[n][n];
        for (int i = 0; i < n; i++) {
            char fi = LEGAL_MOVES.get(i).charAt(0);
            for (int j = 0; j < n; j++) {
                char fj = LEGAL_MOVES.get(j).charAt(0);
                // Skip same-face consecutive moves; they can always be combined.
                if (fi == fj) s[i][j] = true;
            }
        }
        return s;
    }
    private static boolean shouldSkip(int prev, int curr) { return SKIP[prev][curr]; }

    private Phase4Fast() {}
}
