package z.y.x.cube.cube555;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import z.y.x.cube.core.IdaSearchBytes;
import z.y.x.cube.lookup.BinLookupTable;
import z.y.x.cube.lookup.LookupTableLoader;

/**
 * Phase 3 of 5×5 solving — orient all 24 wings + 12 midges so that every
 * edge has its sticker pair in the canonical orientation (forms one of
 * the 12 valid cube edges, in the right direction).
 *
 * <p>Mirrors Python's {@code LookupTableIDA555LRCenterStageEOBothOrbits}
 * (the EO portion only — LR centres are already staged by
 * {@link Cube555LRStage}/{@link Cube555FBStage}).  Combines two prune
 * tables under IDA* with {@code h = max(outer_cost, inner_cost)}:
 *
 * <ul>
 *   <li><b>step902</b> — outer orbit (24 wings × 2 stickers = 48 chars)</li>
 *   <li><b>step903</b> — inner orbit / midges (12 midges × 2 stickers = 24 chars)</li>
 * </ul>
 *
 * <p>Both tables use the {@code .bin} + {@code .state_index} format on
 * S3 and load via the existing {@link BinLookupTable} mmap path — same
 * architecture as the 4×4 phase4 prune tables.
 *
 * <h2>Move restriction</h2>
 *
 * The 12 wide single-turn moves ({@code Uw, Uw', Dw, Dw', Fw, Fw', Bw,
 * Bw', Lw, Lw', Rw, Rw'}) are <em>illegal</em> during EO — they would
 * un-stage the centres done in earlier phases.  The remaining 24 moves
 * (all 18 outer turns + Uw2/Dw2/Fw2/Bw2/Lw2/Rw2) suffice to orient
 * every edge.
 *
 * <h2>Memory</h2>
 *
 * step902's state_index has ~2.7M entries → ~600 MB heap for the
 * HashMap on first load.  The {@code .bin} itself (~330 MB) is mmap'd
 * so its RSS footprint scales with pages actually accessed during
 * search — typically tens of MB.  step903 is tiny (2,048 entries).
 */
public final class Cube555EOStage {

    private static volatile BinLookupTable OUTER_TABLE;     // step902
    private static volatile BinLookupTable INNER_TABLE;     // step903
    private static final Object LOAD_LOCK = new Object();

    /** Moves illegal during EO — they undo centre staging. */
    private static final Set<String> ILLEGAL_MOVES = Collections.unmodifiableSet(
        new HashSet<>(Arrays.asList(
            "Uw", "Uw'", "Dw", "Dw'", "Fw", "Fw'",
            "Bw", "Bw'", "Lw", "Lw'", "Rw", "Rw'")));

    /** 24 legal moves: subset of {@link Cube555Moves#ALL_MOVES} excluding
     *  the 12 single-turn wide moves.  Order matters — must match the
     *  column ordering of the {@code .bin} files (which were built by
     *  the C engine with the same ordering). */
    private static final List<String> LEGAL_MOVES = buildLegalMoves();

    private static List<String> buildLegalMoves() {
        List<String> out = new ArrayList<>(24);
        for (String mv : Cube555Moves.ALL_MOVES) {
            if (!ILLEGAL_MOVES.contains(mv)) out.add(mv);
        }
        return Collections.unmodifiableList(out);
    }

    private static final String[] MOVE_LABELS = LEGAL_MOVES.toArray(new String[0]);
    private static final byte[][] MOVE_PERMS  = buildPerms(MOVE_LABELS);

    private static byte[][] buildPerms(String[] labels) {
        byte[][] perms = new byte[labels.length][];
        for (int i = 0; i < labels.length; i++) perms[i] = Cube555Moves.permFor(labels[i]);
        return perms;
    }

    /** Legal-move count for {@code .bin} row layout — matches the value
     *  the Python+C reference used when building the tables. */
    public static final int MOVE_COUNT = MOVE_LABELS.length;   // 24

    private Cube555EOStage() {}

    /** Eagerly load both EO tables.  Call once at servlet init().
     *  step902 download is ~33 MB compressed; first run takes seconds. */
    public static void ensureReady() throws IOException {
        if (OUTER_TABLE != null && INNER_TABLE != null) return;
        synchronized (LOAD_LOCK) {
            if (OUTER_TABLE == null) {
                OUTER_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step902-EO-outer-orbit", MOVE_COUNT);
            }
            if (INNER_TABLE == null) {
                INNER_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step903-EO-inner-orbit", MOVE_COUNT);
            }
        }
    }

    /** Public for tests / introspection. */
    public static List<String> legalMoves() { return LEGAL_MOVES; }

    /**
     * Solve EO from {@code state}.  Caller must have already staged LR
     * + FB centres — the legal move set here cannot fix centres.
     *
     * @return move sequence that brings every wing + midge to canonical
     *         orientation, leaving centre staging intact.
     */
    public static List<String> solve(String state) throws IOException {
        ensureReady();
        byte[] start = Cube555Bytes.fromString(state);
        Domain dom = new Domain();
        if (dom.heuristic(start) == 0) return Collections.emptyList();

        // Python's tables max out at 10 (outer) + 7 (inner).  Combined
        // worst case is bounded by ~12; 18 is comfortable headroom.
        List<String> result = IdaSearchBytes.find(start, dom, 18);
        if (result == null) {
            throw new IllegalStateException(
                "EO IDA* exhausted depth 18 — encoder bug or input not centre-staged?");
        }
        return result;
    }

    /* ── IDA* domain ────────────────────────────────────────────── */

    private static final class Domain implements IdaSearchBytes.Domain {
        @Override public int stateWidth() { return Cube555.TOTAL_STICKERS; }
        @Override public int moveCount()  { return MOVE_PERMS.length; }
        @Override public byte[] permFor(int i) { return MOVE_PERMS[i]; }
        @Override public String moveLabel(int i) { return MOVE_LABELS[i]; }

        @Override
        public int heuristic(byte[] state) {
            String outerKey = Cube555Edges.encodeEOOuterBytes(state);
            String innerKey = Cube555Edges.encodeEOInnerBytes(state);
            int oIdx = OUTER_TABLE.indexOf(outerKey);
            int iIdx = INNER_TABLE.indexOf(innerKey);
            if (oIdx < 0 || iIdx < 0) {
                throw new IllegalStateException(
                    "EO encoded state not in table (centres not staged?) — "
                    + "outerKey=" + outerKey + " (idx=" + oIdx + "), "
                    + "innerKey=" + innerKey + " (idx=" + iIdx + ")");
            }
            int oc = OUTER_TABLE.costAt(oIdx);
            int ic = INNER_TABLE.costAt(iIdx);
            return Math.max(oc, ic);
        }

        /** Same face+layer move-pair pruning as LR/FB stages. */
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
