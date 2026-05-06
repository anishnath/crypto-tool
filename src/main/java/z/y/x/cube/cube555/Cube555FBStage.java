package z.y.x.cube.cube555;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import z.y.x.cube.core.IdaSearchBytes;
import z.y.x.cube.lookup.TextLookupTable;

/**
 * Phase 2 of 5×5 solving — stage F+B coloured stickers onto the F and B
 * faces, WITHOUT disturbing the already-staged L+R centres.
 *
 * <p>Mirrors Python's {@code LookupTableIDA555FBCentersStage}: combine
 * step21 (T-centres) + step22 (X-centres) prune tables under IDA* with
 * the heuristic {@code h = max(t_cost, x_cost)}.
 *
 * <p>Move restriction: {@code Uw, Uw', Fw, Fw', Bw, Bw', Dw, Dw'} are
 * illegal — those moves would carry L/R stickers off the L/R faces and
 * destroy the LR staging done in {@link Cube555LRStage}.  The remaining
 * 28 moves (all outer turns + Lw, Lw', Lw2, Rw, Rw', Rw2, Uw2, Fw2,
 * Bw2, Dw2) suffice to stage FB.
 *
 * <p>Goal: every centre on F+B faces holds an F-or-B sticker, and no
 * F/B sticker is on any other face's centres.  Equivalent to both
 * encoded states being {@code "0ff0"}.
 *
 * <h2>Tables</h2>
 *
 * Each is only 12,870 entries (vs 735K for LR) — the tighter move set
 * keeps the reachable state space small.  ~1 MB heap for both combined.
 */
public final class Cube555FBStage {

    private static volatile TextLookupTable T_TABLE;     // step21
    private static volatile TextLookupTable X_TABLE;     // step22
    private static final Object LOAD_LOCK = new Object();

    /** Moves illegal during FB-staging — they'd undo LR staging. */
    private static final Set<String> ILLEGAL_MOVES = Collections.unmodifiableSet(
        new HashSet<>(Arrays.asList(
            "Uw", "Uw'", "Fw", "Fw'", "Bw", "Bw'", "Dw", "Dw'")));

    /** Subset of {@link Cube555Moves#ALL_MOVES} excluding illegal moves. */
    private static final List<String> LEGAL_MOVES = buildLegalMoves();

    private static List<String> buildLegalMoves() {
        List<String> out = new ArrayList<>(Cube555Moves.ALL_MOVES.size());
        for (String mv : Cube555Moves.ALL_MOVES) {
            if (!ILLEGAL_MOVES.contains(mv)) out.add(mv);
        }
        return Collections.unmodifiableList(out);
    }

    /** Cached perms + labels indexed by ordinal in {@link #LEGAL_MOVES}. */
    private static final String[] MOVE_LABELS = LEGAL_MOVES.toArray(new String[0]);
    private static final byte[][] MOVE_PERMS  = buildPerms(MOVE_LABELS);

    private static byte[][] buildPerms(String[] labels) {
        byte[][] perms = new byte[labels.length][];
        for (int i = 0; i < labels.length; i++) perms[i] = Cube555Moves.permFor(labels[i]);
        return perms;
    }

    private Cube555FBStage() {}

    /** Eagerly load both FB-staging tables.  Call once at servlet
     *  init().  ~50 KB / second per table over a warm S3 connection. */
    public static void ensureReady() throws IOException {
        if (T_TABLE != null && X_TABLE != null) return;
        synchronized (LOAD_LOCK) {
            if (T_TABLE == null) {
                T_TABLE = TextLookupTable.fetch(
                    "lookup-table-5x5x5-step21-FB-t-centers-stage.txt");
            }
            if (X_TABLE == null) {
                X_TABLE = TextLookupTable.fetch(
                    "lookup-table-5x5x5-step22-FB-x-centers-stage.txt");
            }
        }
    }

    /**
     * Solve the FB-centres stage for {@code state}.  Caller must have
     * already run {@link Cube555LRStage#solve} (or the cube must be in
     * an LR-staged state by some other means) — this stage's moves
     * cannot fix LR.
     *
     * @return move sequence that brings {@code state} to F+B-staged
     *         (LR remains untouched)
     */
    public static List<String> solve(String state) throws IOException {
        ensureReady();
        byte[] start = Cube555Bytes.fromString(state);
        Domain dom = new Domain();
        if (dom.heuristic(start) == 0) return Collections.emptyList();

        // 18 covers Python's worst case (max_depth 9 each, combined ~12).
        List<String> result = IdaSearchBytes.find(start, dom, 18);
        if (result == null) {
            throw new IllegalStateException(
                "FB centres stage IDA* exhausted depth 18 — encoder bug "
                + "or input cube was not LR-staged?");
        }
        return result;
    }

    /** Public so callers (Cube555Solver) can introspect the legal set. */
    public static List<String> legalMoves() { return LEGAL_MOVES; }

    /* ── IDA* domain ────────────────────────────────────────────── */

    private static final class Domain implements IdaSearchBytes.Domain {
        @Override public int stateWidth() { return Cube555.TOTAL_STICKERS; }
        @Override public int moveCount()  { return MOVE_PERMS.length; }
        @Override public byte[] permFor(int i) { return MOVE_PERMS[i]; }
        @Override public String moveLabel(int i) { return MOVE_LABELS[i]; }

        @Override
        public int heuristic(byte[] state) {
            String tKey = Cube555Centres.encodeFBTStagingBytes(state);
            String xKey = Cube555Centres.encodeFBXStagingBytes(state);
            int tc = T_TABLE.costFor(tKey);
            int xc = X_TABLE.costFor(xKey);
            if (tc < 0 || xc < 0) {
                throw new IllegalStateException(
                    "unreachable FB-staging encoded state (input not LR-staged?) — "
                    + "tKey=" + tKey + " xKey=" + xKey);
            }
            return Math.max(tc, xc);
        }

        @Override
        public boolean shouldSkip(int prev, int curr) {
            if (prev < 0) return false;
            return faceLayer(MOVE_LABELS[prev]).equals(faceLayer(MOVE_LABELS[curr]));
        }

        private static String faceLayer(String mv) {
            int len = mv.length();
            if (len >= 2 && mv.charAt(1) == 'w') return mv.substring(0, 2);
            return mv.substring(0, 1);
        }
    }
}
