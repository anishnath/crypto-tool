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
 * Phase 5 of 5×5 solving — pair the four target edges (the
 * {@code wing_strs} chosen during phase 4) and align LFRB centres into
 * one of {@link Cube555Phase5Encoders#encodeLFRBCenters phase5-centres goal patterns}.
 *
 * <p>Mirrors Python's {@code LookupTableIDA555Phase5}.  Combines four
 * prune tables under IDA* with {@code h = max(c1,c2,c3,c4)}:
 * <ul>
 *   <li>step51 phase5-centres (LFRB, 36-char key)</li>
 *   <li>step53 phase5-high-edge-and-midge (36-char key, '-' fillers)</li>
 *   <li>step54 phase5-low-edge-and-midge (36-char key)</li>
 *   <li>step56 phase5-fb-centres (FB only, 18-char key)</li>
 * </ul>
 *
 * <p>16 legal moves only — single-turn wides, U/D singles and L/R singles
 * are illegal (they'd undo earlier centre staging or EO).  Legal:
 * {@code F F' F2 B B' B2 L2 R2 U2 D2 Uw2 Dw2 Fw2 Bw2 Lw2 Rw2}.
 */
public final class Cube555Phase5Stage {

    private static volatile BinLookupTable CENTERS_TABLE;          // step51
    private static volatile BinLookupTable HIGH_EDGE_TABLE;        // step53
    private static volatile BinLookupTable LOW_EDGE_TABLE;         // step54
    private static volatile BinLookupTable FB_CENTERS_TABLE;       // step56
    private static final Object LOAD_LOCK = new Object();

    private static final Set<String> ILLEGAL = new HashSet<>(Arrays.asList(
        "Uw", "Uw'", "Dw", "Dw'", "Fw", "Fw'", "Bw", "Bw'",
        "Lw", "Lw'", "Rw", "Rw'", "L", "L'", "R", "R'",
        "U", "U'", "D", "D'"));

    private static final List<String> LEGAL_MOVES = buildLegal();
    private static List<String> buildLegal() {
        List<String> out = new ArrayList<>();
        for (String mv : Cube555Moves.ALL_MOVES) if (!ILLEGAL.contains(mv)) out.add(mv);
        return Collections.unmodifiableList(out);
    }

    private static final String[] MOVE_LABELS = LEGAL_MOVES.toArray(new String[0]);
    private static final byte[][] MOVE_PERMS  = buildPerms(MOVE_LABELS);
    public  static final int      MOVE_COUNT  = MOVE_LABELS.length;   // 16

    private static byte[][] buildPerms(String[] labels) {
        byte[][] p = new byte[labels.length][];
        for (int i = 0; i < labels.length; i++) p[i] = Cube555Moves.permFor(labels[i]);
        return p;
    }

    private Cube555Phase5Stage() {}

    public static void ensureReady() throws IOException {
        if (CENTERS_TABLE != null && HIGH_EDGE_TABLE != null
            && LOW_EDGE_TABLE != null && FB_CENTERS_TABLE != null) return;
        synchronized (LOAD_LOCK) {
            if (CENTERS_TABLE == null) {
                CENTERS_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step51-phase5-centers", MOVE_COUNT);
            }
            if (HIGH_EDGE_TABLE == null) {
                HIGH_EDGE_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step53-phase5-high-edge-and-midge", MOVE_COUNT);
            }
            if (LOW_EDGE_TABLE == null) {
                LOW_EDGE_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step54-phase5-low-edge-and-midge", MOVE_COUNT);
            }
            if (FB_CENTERS_TABLE == null) {
                FB_CENTERS_TABLE = LookupTableLoader.fetchBin(
                    "lookup-table-5x5x5-step56-phase5-fb-centers", MOVE_COUNT);
            }
        }
    }

    /**
     * Solve phase 5 with the given {@code wingStrs} (4 canonical edges).
     * Caller must have already done LR/FB centres + EO + phase 4 with
     * the SAME {@code wingStrs}.
     */
    public static List<String> solve(String state, String[] wingStrs, int maxDepth)
            throws IOException {
        ensureReady();
        byte[] start = Cube555Bytes.fromString(state);
        Set<String> wingSet = new HashSet<>(Arrays.asList(wingStrs));
        Domain dom = new Domain(wingSet);
        if (dom.heuristic(start) == 0) return Collections.emptyList();

        List<String> result = IdaSearchBytes.find(start, dom, maxDepth);
        if (result == null) {
            throw new IllegalStateException(
                "phase 5 IDA* exhausted depth " + maxDepth
                + " for wing_strs " + Arrays.toString(wingStrs));
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
            int c1 = lookup(CENTERS_TABLE,    Cube555Phase5Encoders.encodeLFRBCenters(s));
            int c2 = lookup(HIGH_EDGE_TABLE,  Cube555Phase5Encoders.encodeHighEdgeMidge(s, wingSet));
            int c3 = lookup(LOW_EDGE_TABLE,   Cube555Phase5Encoders.encodeLowEdgeMidge(s, wingSet));
            int c4 = lookup(FB_CENTERS_TABLE, Cube555Phase5Encoders.encodeFBCenters(s));
            return Math.max(Math.max(c1, c2), Math.max(c3, c4));
        }

        private static int lookup(BinLookupTable t, String key) {
            int idx = t.indexOf(key);
            // Misses → return a high cost (max_depth+1 from Python).
            // For phase5 max_depth ranges 7..10 across tables; 12 is a
            // safe miss cost that's still admissible.
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
