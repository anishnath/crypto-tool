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
 * Phase-3 (first-four-edges) solver — port of Python's
 * {@code LookupTableIDA444Phase3} restricted to its step32 prune table.
 *
 * Goal key: "--------a8b9ecfd--------" — equivalent to "first four
 * dedges (LB, LF, RB, RF) are paired and at their slots".
 *
 * Algorithm: direct lookup → IDA* fallback (max depth 14, since
 * step32's table covers up to depth 11).
 *
 * Legal moves (matches Python's illegal-set complement):
 *   outer:  U U' U2  D D' D2  F F' F2  B B' B2  L2 R2
 *   wide-2: Uw2 Dw2 Lw2 Rw2 Fw2 Bw2
 * 20 moves total.
 */
public final class FirstFourEdgesStage {

    public static final String GOAL = "--------a8b9ecfd--------";

    /** step32 covers depth 0..11.  Beyond-table heuristic value is 12. */
    private static final int HORIZON_PLUS_ONE = 12;

    /** Max IDA* depth before giving up. */
    private static final int MAX_DEPTH = 14;

    public static final List<String> LEGAL_MOVES;
    static {
        Set<String> illegal = new HashSet<>(Arrays.asList(
            "Uw", "Uw'", "Lw", "Lw'", "Fw", "Fw'",
            "Rw", "Rw'", "Bw", "Bw'", "Dw", "Dw'",
            "L",  "L'",  "R",  "R'"
        ));
        List<String> ms = new ArrayList<>(20);
        for (String m : Cube444Moves.ALL_MOVES) if (!illegal.contains(m)) ms.add(m);
        LEGAL_MOVES = Collections.unmodifiableList(ms);
    }

    /** Precomputed move-pair pruning matrix using {@link
     *  z.y.x.cube.core.MovePruning}. */
    private static final MoveSkipMatrix SKIP = new MoveSkipMatrix(LEGAL_MOVES);

    private static volatile LookupTable EDGES_TABLE   = null;
    private static volatile LookupTable CENTRES_TABLE = null;

    public static synchronized void ensureReady() throws IOException {
        if (EDGES_TABLE == null) {
            EDGES_TABLE = LookupTableLoader.fetch(LookupTableRegistry.CUBE444_FIRST_FOUR_EDGES);
        }
        if (CENTRES_TABLE == null) {
            CENTRES_TABLE = LookupTableLoader.fetch(LookupTableRegistry.CUBE444_FINE_CENTRES);
        }
    }

    public static boolean isReady() { return EDGES_TABLE != null && CENTRES_TABLE != null; }

    /** True iff step31's LFRB-centres state is one of its 36 goal targets. */
    private static boolean isCentresAxisSolved(String state) {
        if (CENTRES_TABLE == null) return true;
        String key = EdgesRecolor.step31StateOf(state);
        String soln = CENTRES_TABLE.lookup(key);
        return soln != null && soln.isEmpty();
    }

    /** True iff edges in step32 goal AND centres in step31 goal. */
    public static boolean isSolved(String state) {
        return GOAL.equals(EdgesRecolor.step32StateOf(state))
            && isCentresAxisSolved(state);
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

        List<String> moves = IdaSearch.find(state, new Domain(), MAX_DEPTH);
        if (moves == null) {
            throw new IllegalStateException(
                "phase3 IDA* exhausted depth " + MAX_DEPTH + " — edges="
                + EdgesRecolor.step32StateOf(state)
                + " centres=" + EdgesRecolor.step31StateOf(state));
        }
        String after = Cube444Moves.applyMoves(state, moves);
        return new Result(moves, after, moves.size(), true);
    }

    /**
     * Enumerate up to {@code maxSolutions} candidate phase3 solutions
     * for {@code state}.  Use this when the caller wants to try several
     * paths in phase4 — Python's {@code --solution-count} feature.
     *
     * Solutions are returned in roughly increasing length.  All
     * solutions reach a state where step31+step32 are both at goal —
     * but the exact within-axis centre arrangement differs between
     * them, which matters for phase4 reachability.
     */
    public static List<List<String>> solveMany(String state, int maxSolutions) throws IOException {
        ensureReady();
        if (isSolved(state)) {
            List<List<String>> out = new ArrayList<>();
            out.add(new ArrayList<String>());
            return out;
        }
        byte[] startBytes = Cube444Bytes.fromString(state);
        return IdaSearchBytes.findMany(startBytes, new BytesDomain(), MAX_DEPTH, maxSolutions);
    }

    /**
     * Same as {@link #solveMany(String, int)} but filters output to ONLY
     * solutions whose post-application cube state is reachable to phase4
     * (both step41 and step42 keys exist in the respective .bin
     * state_index files).  Useful when the caller is the full pipeline:
     * any candidate this returns is guaranteed phase4-enterable.
     *
     * Returns up to {@code maxFiltered} reachable candidates.  May
     * generate substantially more raw candidates internally.
     */
    public static List<List<String>> solveManyReachable(String state,
                                                        int maxFiltered,
                                                        int maxRaw,
                                                        z.y.x.cube.lookup.BinLookupTable centresTbl,
                                                        z.y.x.cube.lookup.BinLookupTable edgesTbl) throws IOException {
        List<List<String>> raw = solveMany(state, maxRaw);
        List<List<String>> filtered = new ArrayList<>();
        for (List<String> cand : raw) {
            String afterP3 = Cube444Moves.applyMoves(state, cand);
            String cKey = EdgesRecolor.step41StateOf(afterP3);
            if (centresTbl.indexOf(cKey) < 0) continue;
            String eKey = EdgesRecolor.step42StateOf(afterP3);
            if (edgesTbl.indexOf(eKey) < 0) continue;
            filtered.add(cand);
            if (filtered.size() >= maxFiltered) break;
        }
        return filtered;
    }

    /** byte[] domain — high-performance variant that mirrors what
     *  {@link Domain} does but with mutable byte state. */
    private static final byte[][] LEGAL_PERMS;
    static {
        LEGAL_PERMS = new byte[LEGAL_MOVES.size()][];
        for (int i = 0; i < LEGAL_MOVES.size(); i++) {
            LEGAL_PERMS[i] = Cube444Moves.permFor(LEGAL_MOVES.get(i));
        }
    }
    private static final class BytesDomain implements IdaSearchBytes.Domain {
        private final byte[] centresKey = new byte[16];
        @Override public int stateWidth() { return Cube444.TOTAL_STICKERS; }
        @Override public int moveCount()  { return LEGAL_MOVES.size(); }
        @Override public byte[] permFor(int idx)   { return LEGAL_PERMS[idx]; }
        @Override public String moveLabel(int idx) { return LEGAL_MOVES.get(idx); }
        @Override public boolean shouldSkip(int prev, int curr) { return SKIP.shouldSkip(prev, curr); }
        @Override public int heuristic(byte[] state) {
            // step31: 16 LFRB centre stickers.
            int[] pos = EdgesRecolor.LFRB_CENTERS_ULFRBD;
            for (int i = 0; i < 16; i++) centresKey[i] = state[pos[i]];
            int hC = CENTRES_TABLE.lookupDistance(centresKey);
            if (hC < 0) hC = 6;
            // step32: still String-based (recolour algorithm).  Acceptable
            // perf cost since solveMany() is called once per scramble.
            String s = Cube444Bytes.toString(state);
            String edgesKey = EdgesRecolor.step32StateOf(s);
            int hE = GOAL.equals(edgesKey) ? 0 : distance(EDGES_TABLE, edgesKey, HORIZON_PLUS_ONE);
            return Math.max(hC, hE);
        }
    }

    private static int distance(LookupTable t, String key, int horizon) {
        String soln = t.lookup(key);
        if (soln == null) return horizon;
        if (soln.isEmpty()) return 0;
        int n = 1;
        for (int i = 0; i < soln.length(); i++) if (soln.charAt(i) == ' ') n++;
        return n;
    }

    /* ─── IDA* domain over String cube states ─────────────────── */

    private static final class Domain implements IdaSearch.Domain<String> {
        @Override public String applyMove(String state, int moveIdx) {
            return Cube444Moves.applyMove(state, LEGAL_MOVES.get(moveIdx));
        }

        @Override public int heuristic(String state) {
            String edgesKey = EdgesRecolor.step32StateOf(state);
            int hE = GOAL.equals(edgesKey) ? 0 : distance(EDGES_TABLE, edgesKey, HORIZON_PLUS_ONE);
            int hC = distance(CENTRES_TABLE, EdgesRecolor.step31StateOf(state), 6);
            return Math.max(hE, hC);
        }

        @Override public int moveCount() { return LEGAL_MOVES.size(); }
        @Override public String moveLabel(int moveIdx) { return LEGAL_MOVES.get(moveIdx); }
        @Override public boolean shouldSkip(int prev, int curr) { return SKIP.shouldSkip(prev, curr); }
    }

    private FirstFourEdgesStage() {}
}
