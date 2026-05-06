package z.y.x.cube.cube555;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import z.y.x.cube.core.IdaSearchBytes;
import z.y.x.cube.lookup.BinarySearchedTextTable;

/**
 * Phase 4 of 5×5 solving — stage four chosen edges into the M-slice (the
 * middle layer).  Run iteratively with different {@code wing_strs} choices
 * (which 4 edges to stage) until one survives downstream phases 5/6.
 *
 * <p>Mirrors Python's {@code LookupTable555Phase4} + the {@code wing_strs}
 * iteration logic in {@code RubiksCube555.find_first_four_edges_to_pair}
 * + {@code pair_edges}.  Uses {@link BinarySearchedTextTable} over the
 * 184 MB {@code lookup-table-5x5x5-step40-phase4.txt} (no .bin mirror
 * exists on S3).
 *
 * <h2>Heuristic</h2>
 *
 * <p>Look up the 18-char key from {@link Cube555Phase4Encoder#encode}.
 * If found, cost = number of moves in the table's solution.  If absent
 * (key beyond max_depth=3), return {@link #MISS_COST} = 4 (Python's
 * {@code max_depth + 1} convention).
 *
 * <h2>Move set</h2>
 *
 * <p>All 36 base moves are legal — phase 4 doesn't restrict.
 *
 * <h2>Multi-candidate</h2>
 *
 * <p>The static {@link #COMMON_WING_STRS} array holds the most useful
 * 4-tuples (the same defaults Python tries first).  Caller can supply
 * any 4-tuple via {@link #solveWith(String, String[], int)}.
 */
public final class Cube555Phase4Stage {

    /** {@code max_depth + 1} from Python's LookupTable.heuristic — used
     *  when a key isn't in the (depth-3-truncated) step40 table. */
    public static final int MISS_COST = 4;

    /** Default wing-string 4-tuples to try in multi-candidate search,
     *  ordered by Python's {@code find_first_four_edges_to_pair} priority. */
    public static final String[][] COMMON_WING_STRS = {
        {"LB", "LF", "RB", "RF"},      // x-plane edges
        {"UB", "UL", "UR", "UF"},      // y-plane edges (top)
        {"DB", "DL", "DR", "DF"},      // y-plane edges (bottom)
        {"UB", "DB", "UF", "DF"},      // z-plane edges (front-back)
        {"UL", "UR", "DL", "DR"},      // z-plane edges (left-right)
    };

    private static volatile BinarySearchedTextTable TABLE;
    private static final Object LOAD_LOCK = new Object();

    /** All 36 5×5 moves are legal in phase 4. */
    private static final String[] MOVE_LABELS = Cube555Moves.ALL_MOVES.toArray(new String[0]);
    private static final byte[][] MOVE_PERMS  = buildPerms(MOVE_LABELS);
    public  static final int      MOVE_COUNT  = MOVE_LABELS.length;   // 36

    private static byte[][] buildPerms(String[] labels) {
        byte[][] p = new byte[labels.length][];
        for (int i = 0; i < labels.length; i++) p[i] = Cube555Moves.permFor(labels[i]);
        return p;
    }

    private Cube555Phase4Stage() {}

    /** Eagerly load the step40 table.  ~184 MB download on first run,
     *  ~960 MB on disk decompressed.  Mmap'd → low RSS in steady state. */
    public static void ensureReady() throws IOException {
        if (TABLE != null) return;
        synchronized (LOAD_LOCK) {
            if (TABLE != null) return;
            TABLE = BinarySearchedTextTable.fetch(
                "lookup-table-5x5x5-step40-phase4.txt", 18, MISS_COST);
        }
    }

    /** Look up the cost-to-goal for a state under a given wing_strs choice. */
    public static int costFor(String state, String[] wingStrs) throws IOException {
        ensureReady();
        String key = Cube555Phase4Encoder.encode(state, wingStrs);
        return TABLE.costFor(key);
    }

    /**
     * Solve phase 4 with a specific {@code wing_strs} choice.  Returns
     * the move sequence that brings the chosen 4 edges to their staged
     * positions.  Throws if IDA* exhausts {@code maxDepth}.
     *
     * @param state    150-char URFDLB cube state (must have centres
     *                 staged + EO done by prior phases)
     * @param wingStrs the 4 canonical wings to stage (e.g.
     *                 {@code {"LB","LF","RB","RF"}})
     * @param maxDepth IDA* depth limit; 16 is comfortable for typical
     *                 cubes (typical phase 4 solutions are 0–8 moves).
     */
    public static List<String> solveWith(String state, String[] wingStrs, int maxDepth)
            throws IOException {
        ensureReady();
        byte[] start = Cube555Bytes.fromString(state);
        Domain dom = new Domain(wingStrs);
        if (dom.heuristic(start) == 0) return Collections.emptyList();
        List<String> result = IdaSearchBytes.find(start, dom, maxDepth);
        if (result == null) {
            throw new IllegalStateException(
                "phase 4 IDA* exhausted depth " + maxDepth
                + " for wing_strs " + Arrays.toString(wingStrs));
        }
        return result;
    }

    /**
     * Try multiple wing_strs candidates in {@link #COMMON_WING_STRS}
     * order and return the FIRST one that solves.  Returns {@code null}
     * if no candidate solves within {@code maxDepth}.  Use
     * {@link #solveAllCandidates} when you want to enumerate all
     * candidates and let the caller pick downstream.
     */
    public static List<String> solveFirst(String state, int maxDepth) throws IOException {
        for (String[] wings : COMMON_WING_STRS) {
            try {
                return solveWith(state, wings, maxDepth);
            } catch (RuntimeException ignore) {
                // exhausted depth for this wing_strs — try next
            }
        }
        return null;
    }

    /** Result of one wing_strs candidate. */
    public static final class Candidate {
        public final String[] wingStrs;
        public final List<String> moves;
        public final long elapsedMs;
        public Candidate(String[] wingStrs, List<String> moves, long elapsedMs) {
            this.wingStrs = wingStrs;
            this.moves = moves;
            this.elapsedMs = elapsedMs;
        }
    }

    /**
     * Enumerate all {@link #COMMON_WING_STRS} candidates that solve
     * within {@code maxDepth}, returned in the order they're tried.
     * Used by {@code Cube555Solver} to feed downstream phases.
     */
    public static List<Candidate> solveAllCandidates(String state, int maxDepth)
            throws IOException {
        List<Candidate> out = new ArrayList<>();
        for (String[] wings : COMMON_WING_STRS) {
            long t0 = System.currentTimeMillis();
            try {
                List<String> moves = solveWith(state, wings, maxDepth);
                out.add(new Candidate(wings, moves, System.currentTimeMillis() - t0));
            } catch (RuntimeException ignore) {
                // Skip — no solution for this candidate within depth.
            }
        }
        return out;
    }

    /* ── IDA* domain ────────────────────────────────────────────── */

    private static final class Domain implements IdaSearchBytes.Domain {
        private final String[] wingStrs;
        private final Set<String> wingStrSet;

        Domain(String[] wingStrs) {
            this.wingStrs = wingStrs;
            this.wingStrSet = new HashSet<>(Arrays.asList(wingStrs));
            if (wingStrSet.size() != 4) {
                throw new IllegalArgumentException(
                    "phase 4 needs exactly 4 distinct wings, got "
                    + Arrays.toString(wingStrs));
            }
        }

        @Override public int stateWidth() { return Cube555.TOTAL_STICKERS; }
        @Override public int moveCount()  { return MOVE_PERMS.length; }
        @Override public byte[] permFor(int i) { return MOVE_PERMS[i]; }
        @Override public String moveLabel(int i) { return MOVE_LABELS[i]; }

        @Override
        public int heuristic(byte[] state) {
            String key = Cube555Phase4Encoder.encodeBytes(state, wingStrs);
            return TABLE.costFor(key);
        }

        @Override
        public boolean shouldSkip(int prev, int curr) {
            if (prev < 0) return false;
            return faceLayer(MOVE_LABELS[prev]).equals(faceLayer(MOVE_LABELS[curr]));
        }

        private static String faceLayer(String mv) {
            if (mv.length() >= 2 && mv.charAt(1) == 'w') return mv.substring(0, 2);
            return mv.substring(0, 1);
        }
    }
}
