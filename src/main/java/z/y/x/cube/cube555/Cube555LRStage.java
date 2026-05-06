package z.y.x.cube.cube555;

import java.io.IOException;
import java.util.List;

import z.y.x.cube.core.IdaSearchBytes;
import z.y.x.cube.lookup.TextLookupTable;

/**
 * Phase 1 of 5×5 solving — stage L+R coloured stickers onto the L and R
 * faces (in any arrangement, fine-tuning is later phases).
 *
 * <p>Mirrors Python's {@code LookupTableIDA555LRCenterStage}: combine
 * two perfect-hash prune tables — step11 (T-centres) + step12 (X-centres)
 * — under IDA* with the heuristic {@code h = max(t_cost, x_cost)}.
 *
 * <p>Both tables hold all 735,471 reachable states for their orbit, so
 * the heuristic is always finite (we throw if not — that catches encoder
 * bugs, never a real cube state).  Goal: both encoded states equal
 * {@code "0f0f00"}.
 *
 * <h2>Performance expectations</h2>
 *
 * <p>From Python's documented depth distribution, average solution
 * length is ~7 moves, max ~8.  With max(T, X) heuristic the IDA* should
 * converge in milliseconds on most scrambles — the tables make the
 * heuristic nearly tight.
 *
 * <h2>Memory</h2>
 *
 * <p>~60 MB heap for the two HashMaps (loaded lazily on first call).
 * One-time cost; held for the JVM lifetime.
 */
public final class Cube555LRStage {

    private static volatile TextLookupTable T_TABLE;     // step11
    private static volatile TextLookupTable X_TABLE;     // step12
    private static final Object LOAD_LOCK = new Object();

    private Cube555LRStage() {}

    /** Eagerly load the two LR-staging tables.  Call once at servlet
     *  init() to avoid the multi-second download/parse on the first
     *  user request. */
    public static void ensureReady() throws IOException {
        if (T_TABLE != null && X_TABLE != null) return;
        synchronized (LOAD_LOCK) {
            if (T_TABLE == null) {
                T_TABLE = TextLookupTable.fetch(
                    "lookup-table-5x5x5-step11-LR-centers-stage-t-center-only.txt");
            }
            if (X_TABLE == null) {
                X_TABLE = TextLookupTable.fetch(
                    "lookup-table-5x5x5-step12-LR-centers-stage-x-center-only.txt");
            }
        }
    }

    /**
     * Solve the LR-centres stage for {@code state}.  Returns the move
     * sequence that brings {@code state} to a state whose LR T-centres
     * AND X-centres are all on the L and R faces.
     *
     * @throws IOException if the tables can't be downloaded/parsed
     * @throws IllegalStateException if the search fails (max depth reached
     *         — should never happen for a real cube)
     */
    public static List<String> solve(String state) throws IOException {
        ensureReady();
        byte[] start = Cube555Bytes.fromString(state);
        Domain dom = new Domain();
        if (dom.heuristic(start) == 0) return java.util.Collections.emptyList();

        // 16 is comfortably above Python's documented max-depth (8 for T,
        // 8 for X — combined max is bounded by the sum, in practice <12).
        List<String> result = IdaSearchBytes.find(start, dom, 16);
        if (result == null) {
            throw new IllegalStateException(
                "LR centres stage IDA* exhausted depth 16 — encoder bug?");
        }
        return result;
    }

    /* ── IDA* domain ────────────────────────────────────────────── */

    /** Cached perms + labels for the 36 5×5 base moves, indexed by
     *  {@link Cube555Moves#ALL_MOVES} ordinal. */
    private static final String[] MOVE_LABELS = Cube555Moves.ALL_MOVES.toArray(new String[0]);
    private static final byte[][] MOVE_PERMS  = buildPerms(MOVE_LABELS);

    private static byte[][] buildPerms(String[] labels) {
        byte[][] perms = new byte[labels.length][];
        for (int i = 0; i < labels.length; i++) perms[i] = Cube555Moves.permFor(labels[i]);
        return perms;
    }

    private static final class Domain implements IdaSearchBytes.Domain {
        @Override public int stateWidth() { return Cube555.TOTAL_STICKERS; }
        @Override public int moveCount()  { return MOVE_PERMS.length; }
        @Override public byte[] permFor(int i) { return MOVE_PERMS[i]; }
        @Override public String moveLabel(int i) { return MOVE_LABELS[i]; }

        @Override
        public int heuristic(byte[] state) {
            String tKey = Cube555Centres.encodeLRTStagingBytes(state);
            String xKey = Cube555Centres.encodeLRXStagingBytes(state);
            int tc = T_TABLE.costFor(tKey);
            int xc = X_TABLE.costFor(xKey);
            if (tc < 0 || xc < 0) {
                throw new IllegalStateException(
                    "unreachable LR-staging encoded state — encoder bug? "
                    + "tKey=" + tKey + " xKey=" + xKey);
            }
            return Math.max(tc, xc);
        }

        /** Move-pair pruning rule:  the second of two consecutive moves
         *  on the SAME face is redundant (e.g. U then U' just cancels;
         *  U then U2 == U'). Skip those.  This is the cheapest skip
         *  rule that meaningfully prunes the search tree. */
        @Override
        public boolean shouldSkip(int prev, int curr) {
            if (prev < 0) return false;
            // Same face & layer (both outer or both wide of the same face)?
            String a = MOVE_LABELS[prev];
            String b = MOVE_LABELS[curr];
            return faceLayer(a).equals(faceLayer(b));
        }

        /** Returns the face+layer prefix: "U" for U/U'/U2, "Uw" for Uw/Uw'/Uw2. */
        private static String faceLayer(String mv) {
            int len = mv.length();
            if (len >= 2 && mv.charAt(1) == 'w') return mv.substring(0, 2);
            return mv.substring(0, 1);
        }
    }
}
