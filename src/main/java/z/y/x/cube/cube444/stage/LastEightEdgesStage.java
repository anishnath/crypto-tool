package z.y.x.cube.cube444.stage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import z.y.x.cube.core.IdaSearchBytes;
import z.y.x.cube.core.MoveSkipMatrix;
import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Bytes;
import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube444.EdgesRecolor;
import z.y.x.cube.lookup.LookupTable;
import z.y.x.cube.lookup.LookupTableLoader;
import z.y.x.cube.lookup.LookupTableRegistry;

/**
 * Phase-4 (last-eight-edges) solver — port of Python's
 * {@code LookupTableIDA444Phase4} restricted to its step42 prune table.
 *
 * Goal key: "10425376--------hgkiljnm" — equivalent to "remaining 8
 * dedges all paired and at their slots".
 *
 * Step42's table is small (20,160 entries, max depth 10), so most
 * scrambles solve via direct lookup.  IDA* fallback handles depth
 * 11+ states (rare).
 *
 * Legal moves are very restrictive — only quarter-turns of U / D plus
 * a small set of squared moves.  16 legal total.
 */
public final class LastEightEdgesStage {

    public static final String GOAL_EDGES   = "10425376--------hgkiljnm";
    public static final String GOAL_CENTRES = "UUUULLLLFFFFRRRRBBBBDDDD";

    /** Backwards-compat alias for callers checking edges-only goal. */
    public static final String GOAL = GOAL_EDGES;

    private static final int HORIZON_PLUS_ONE_EDGES   = 11;   // step42 covers 0..10
    private static final int HORIZON_PLUS_ONE_CENTRES = 8;    // step41 covers 0..7

    /** Minimum lower-bound on cost to fix a 4×4 PLL/OLL parity state.
     *  Step42's encoder can't distinguish "fully reduced" from
     *  "two paired-dedges swapped" — both produce the same key.
     *  When the table-lookup fast-path says depth=0 but the cube isn't
     *  actually reduced, we need a non-zero h so IDA* keeps searching.
     *  PLL parity fixes are typically 12+ moves; OLL parity 12+. */
    private static final int PARITY_FIX_LOWER_BOUND = 12;

    private static final int MAX_DEPTH = 16;       // tractable now that IDA* uses
                                                   // iterative byte[] state mutation
                                                   // (no per-node String allocation)

    public static final List<String> LEGAL_MOVES;
    static {
        Set<String> illegal = new HashSet<>(Arrays.asList(
            "Uw", "Uw'", "Lw", "Lw'", "Fw", "Fw'",
            "Rw", "Rw'", "Bw", "Bw'", "Dw", "Dw'",
            "L",  "L'",  "R",  "R'",
            "Uw2", "Dw2",
            "F",  "F'",  "B",  "B'"
        ));
        List<String> ms = new ArrayList<>(16);
        for (String m : Cube444Moves.ALL_MOVES) if (!illegal.contains(m)) ms.add(m);
        LEGAL_MOVES = Collections.unmodifiableList(ms);
    }

    private static final MoveSkipMatrix SKIP = new MoveSkipMatrix(LEGAL_MOVES);

    private static volatile LookupTable EDGES_TABLE   = null;
    private static volatile LookupTable CENTRES_TABLE = null;

    public static synchronized void ensureReady() throws IOException {
        if (EDGES_TABLE == null) {
            EDGES_TABLE = LookupTableLoader.fetch(LookupTableRegistry.CUBE444_LAST_EIGHT_EDGES);
        }
        if (CENTRES_TABLE == null) {
            CENTRES_TABLE = LookupTableLoader.fetch(LookupTableRegistry.CUBE444_PHASE4_CENTRES);
        }
    }
    public static boolean isReady() { return EDGES_TABLE != null && CENTRES_TABLE != null; }

    /** Phase4 is solved iff edges + centres at goal AND cube is genuinely
     *  reduced (no PLL/OLL parity defect — every wing matches face colour).
     *  The structural-encoder check alone is insufficient because step42
     *  can't tell two-paired-dedges-swapped from fully-paired. */
    public static boolean isSolved(String state) {
        if (!GOAL_EDGES.equals(EdgesRecolor.step42StateOf(state))) return false;
        if (!GOAL_CENTRES.equals(EdgesRecolor.step41StateOf(state))) return false;
        return isReduced(state);
    }

    /** True iff every face's 12 non-corner stickers (centres + wings) match
     *  that face's colour.  Corner stickers can still be permuted — those
     *  are Kociemba's job. */
    static boolean isReduced(String state) {
        for (char f : Cube444.FACES) {
            int off = Cube444.faceOffset(f);
            // centres
            for (int p : Cube444.CENTRE_POS) {
                if (state.charAt(off + p) != f) return false;
            }
            // wings (non-corner non-centre)
            for (int p : new int[] {1, 2, 4, 7, 8, 11, 13, 14}) {
                if (state.charAt(off + p) != f) return false;
            }
        }
        return true;
    }

    public static final class Result {
        public final List<String> moves;
        public final String state;
        public final int depth;
        public final boolean usedIda;
        Result(List<String> moves, String state, int depth, boolean usedIda) {
            this.moves = Collections.unmodifiableList(moves);
            this.state = state;
            this.depth = depth;
            this.usedIda = usedIda;
        }
    }

    public static Result solve(String state) throws IOException {
        ensureReady();
        if (isSolved(state)) return new Result(new ArrayList<String>(), state, 0, false);

        // Fast path: byte[] iterative IDA*.  4-5× faster per-node than
        // the legacy String-based recursive search.
        byte[] startBytes = Cube444Bytes.fromString(state);
        BytesDomain bytesDomain = new BytesDomain();
        List<String> moves = IdaSearchBytes.find(startBytes, bytesDomain, MAX_DEPTH);
        if (moves == null) {
            throw new IllegalStateException(
                "phase4 IDA* exhausted depth " + MAX_DEPTH + " without solution"
                + " — edges=" + EdgesRecolor.step42StateOf(state)
                + " centres=" + EdgesRecolor.step41StateOf(state));
        }
        return new Result(moves, Cube444Moves.applyMoves(state, moves), moves.size(), true);
    }

    /** Distance estimate from the given table.  Returns
     *  {@code horizonPlusOne} if the state isn't in the table. */
    private static int distanceFromTable(LookupTable table, String key, String goal,
                                         int horizonPlusOne) {
        if (goal.equals(key)) return 0;
        String soln = table.lookup(key);
        if (soln == null) return horizonPlusOne;
        if (soln.isEmpty()) return 0;
        int n = 1;
        for (int i = 0; i < soln.length(); i++) if (soln.charAt(i) == ' ') n++;
        return n;
    }

    /**
     * High-performance domain for {@link IdaSearchBytes}.  Uses byte[]
     * cube state, pre-cached byte[] perms, and allocation-free centres
     * heuristic via {@link LookupTable#lookupDistance(byte[])}.
     *
     * Edges heuristic (step42) still allocates because the recolour
     * algorithm is HashMap-based — left as a future optimisation; the
     * dominant cost is the centres heuristic which now runs flat-out.
     */
    private static final byte[][] LEGAL_PERMS;
    static {
        LEGAL_PERMS = new byte[LEGAL_MOVES.size()][];
        for (int i = 0; i < LEGAL_MOVES.size(); i++) {
            LEGAL_PERMS[i] = Cube444Moves.permFor(LEGAL_MOVES.get(i));
        }
    }

    private static final class BytesDomain implements IdaSearchBytes.Domain {
        // Per-call scratch buffers — reused across every heuristic call,
        // never allocated in the IDA* hot loop.
        private final byte[] centresKey = new byte[24];

        @Override public int    stateWidth() { return Cube444.TOTAL_STICKERS; }
        @Override public int    moveCount()  { return LEGAL_MOVES.size(); }
        @Override public byte[] permFor(int moveIdx)   { return LEGAL_PERMS[moveIdx]; }
        @Override public String moveLabel(int moveIdx) { return LEGAL_MOVES.get(moveIdx); }
        @Override public boolean shouldSkip(int prev, int curr) { return SKIP.shouldSkip(prev, curr); }

        @Override public int heuristic(byte[] state) {
            // Centres heuristic — fast path, allocation-free.
            EdgesRecolor.step41StateOfBytes(state, centresKey);
            int hC = CENTRES_TABLE.lookupDistance(centresKey);
            if (hC < 0) hC = HORIZON_PLUS_ONE_CENTRES;

            // Edges heuristic — convert to String for recolour (slower
            // path; can be optimised later by porting recolour to byte[]).
            String s = Cube444Bytes.toString(state);
            String edgesKey = EdgesRecolor.step42StateOf(s);
            int hE = GOAL_EDGES.equals(edgesKey) ? 0
                : distanceFromTable(EDGES_TABLE, edgesKey, GOAL_EDGES, HORIZON_PLUS_ONE_EDGES);

            int h = Math.max(hC, hE);
            if (h == 0 && !isReducedBytes(state)) return PARITY_FIX_LOWER_BOUND;
            return h;
        }

        /** byte[] version of {@link #isReduced(String)}. */
        private static boolean isReducedBytes(byte[] state) {
            for (char f : Cube444.FACES) {
                int off = Cube444.faceOffset(f);
                for (int p : Cube444.CENTRE_POS) {
                    if (state[off + p] != (byte) f) return false;
                }
                for (int p : new int[] {1, 2, 4, 7, 8, 11, 13, 14}) {
                    if (state[off + p] != (byte) f) return false;
                }
            }
            return true;
        }
    }

    private LastEightEdgesStage() {}
}
