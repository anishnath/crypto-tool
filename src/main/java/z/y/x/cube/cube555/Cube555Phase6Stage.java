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
 * Phase 6 — solve all centres + pair the remaining 8 edges (the U/D
 * plane edges).  Final IDA* stage before reduce-to-3×3 + Kociemba.
 *
 * <p>Mirrors Python's {@code LookupTableIDA555Phase6}.  3 prune tables:
 * <ul>
 *   <li>step61 phase6-centres (54-char key, all 6 face centres)</li>
 *   <li>step62 phase6-high-edge-midge (36-char, 8 target wings)</li>
 *   <li>step63 phase6-low-edge-midge (36-char, 8 target wings)</li>
 * </ul>
 *
 * <p>14 legal moves only (most restricted of all phases): U/U'/U2,
 * D/D'/D2, L2, R2, F2, B2, Lw2, Rw2, Fw2, Bw2.  Note: no F/F' or B/B'
 * because those would un-pair phase-5 edges.
 */
public final class Cube555Phase6Stage {

    /** Default phase 6 wing_strs: the 8 U/D-plane edges. */
    public static final String[] DEFAULT_WINGS = {
        "UB", "UL", "UR", "UF", "DB", "DL", "DR", "DF"
    };

    private static volatile BinLookupTable CENTERS_TABLE;          // step61
    private static volatile BinLookupTable HIGH_EDGE_TABLE;        // step62
    private static volatile BinLookupTable LOW_EDGE_TABLE;         // step63
    private static final Object LOAD_LOCK = new Object();

    private static final Set<String> ILLEGAL = new HashSet<>(Arrays.asList(
        "Uw", "Uw'", "Uw2", "Dw", "Dw'", "Dw2",
        "Fw", "Fw'", "Bw", "Bw'",
        "Lw", "Lw'", "Rw", "Rw'",
        "L", "L'", "R", "R'",
        "F", "F'", "B", "B'"));

    private static final List<String> LEGAL_MOVES = buildLegal();
    private static List<String> buildLegal() {
        List<String> out = new ArrayList<>();
        for (String mv : Cube555Moves.ALL_MOVES) if (!ILLEGAL.contains(mv)) out.add(mv);
        return Collections.unmodifiableList(out);
    }

    private static final String[] MOVE_LABELS = LEGAL_MOVES.toArray(new String[0]);
    private static final byte[][] MOVE_PERMS  = buildPerms(MOVE_LABELS);
    public  static final int      MOVE_COUNT  = MOVE_LABELS.length;   // 14

    private static byte[][] buildPerms(String[] labels) {
        byte[][] p = new byte[labels.length][];
        for (int i = 0; i < labels.length; i++) p[i] = Cube555Moves.permFor(labels[i]);
        return p;
    }

    private Cube555Phase6Stage() {}

    public static void ensureReady() throws IOException {
        if (CENTERS_TABLE != null && HIGH_EDGE_TABLE != null && LOW_EDGE_TABLE != null) return;
        synchronized (LOAD_LOCK) {
            if (CENTERS_TABLE == null) {
                CENTERS_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step61-phase6-centers", MOVE_COUNT);
            }
            if (HIGH_EDGE_TABLE == null) {
                HIGH_EDGE_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step62-phase6-high-edge-midge", MOVE_COUNT);
            }
            if (LOW_EDGE_TABLE == null) {
                LOW_EDGE_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step63-phase6-low-edge-midge", MOVE_COUNT);
            }
        }
    }

    public static List<String> solve(String state, int maxDepth) throws IOException {
        ensureReady();
        byte[] start = Cube555Bytes.fromString(state);
        Set<String> wingSet = new HashSet<>(Arrays.asList(DEFAULT_WINGS));
        Domain dom = new Domain(wingSet);
        if (dom.heuristic(start) == 0) return Collections.emptyList();

        List<String> result = IdaSearchBytes.find(start, dom, maxDepth);
        if (result == null) {
            throw new IllegalStateException(
                "phase 6 IDA* exhausted depth " + maxDepth);
        }
        return result;
    }

    public static List<String> legalMoves() { return LEGAL_MOVES; }

    private static final class Domain implements IdaSearchBytes.Domain {
        private final Set<String> wingSet;

        Domain(Set<String> wingSet) { this.wingSet = wingSet; }

        @Override public int stateWidth() { return Cube555.TOTAL_STICKERS; }
        @Override public int moveCount()  { return MOVE_PERMS.length; }
        @Override public byte[] permFor(int i) { return MOVE_PERMS[i]; }
        @Override public String moveLabel(int i) { return MOVE_LABELS[i]; }

        @Override
        public int heuristic(byte[] state) {
            String s = Cube555Bytes.toString(state);
            int c1 = lookup(CENTERS_TABLE,    Cube555Phase6Encoders.encodeCenters(s));
            int c2 = lookup(HIGH_EDGE_TABLE,  Cube555Phase6Encoders.encodeHighEdgeMidge(s, wingSet));
            int c3 = lookup(LOW_EDGE_TABLE,   Cube555Phase6Encoders.encodeLowEdgeMidge(s, wingSet));
            return Math.max(c1, Math.max(c2, c3));
        }

        private static int lookup(BinLookupTable t, String key) {
            int idx = t.indexOf(key);
            return idx < 0 ? 12 : t.costAt(idx);
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
