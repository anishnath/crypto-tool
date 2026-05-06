package z.y.x.cube.cube444.stage;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import z.y.x.cube.core.PruningTable;
import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;

/**
 * 4×4 centres solver — three staged BFS pruning tables.
 *
 * Direct Java port of {@code js/rubiks4/solver/centers.js}, which was
 * verified end-to-end (42 test assertions covering UD-stage, LR-stage,
 * fine-stage, and full orchestrator round-trip).  Same algorithm, same
 * goal patterns, same state-space sizes:
 *
 *   stage 1 (UD axis):       2²⁴, 735 471 reachable, max depth 9
 *   stage 2 (LR axis):       2¹⁶, 12 870 reachable, max depth 8
 *   stage 3 (fine, U-vs-D, etc.): 2²⁴, 343 000 reachable, max depth 12
 *
 * Memory: 16 MB + 64 KB + 16 MB ≈ 32 MB pinned.  Init: ~1 s.
 *
 * Tables are built lazily on first {@link #ensureReady()} call and
 * shared process-wide (the servlet keeps one instance).
 */
public final class CentresStage {

    /* ─────────────────────────────────────────────────────────────────
     *  Centre-position registry — shared by every stage
     * ──────────────────────────────────────────────────────────────── */

    private static final int[] FACE_CENTRE_POS = Cube444.CENTRE_POS;

    /** Sticker indices of the 24 centre positions, URFDLB face order. */
    public static final int[] CENTER_POSITIONS;
    static {
        CENTER_POSITIONS = new int[24];
        int k = 0;
        for (char f : Cube444.FACES) {
            int off = Cube444.faceOffset(f);
            for (int p : FACE_CENTRE_POS) CENTER_POSITIONS[k++] = off + p;
        }
    }

    private static final Map<Integer, Integer> CENTRE_INDEX_OF;
    static {
        CENTRE_INDEX_OF = new HashMap<>(32);
        for (int i = 0; i < CENTER_POSITIONS.length; i++) {
            CENTRE_INDEX_OF.put(CENTER_POSITIONS[i], i);
        }
    }

    /** Full 36-move roster (face × layer × turns). */
    public static final List<String> CENTER_MOVES;
    static {
        List<String> ms = new ArrayList<>(36);
        for (char f : Cube444.FACES) {
            for (String w : new String[] {"", "w"}) {
                for (String s : new String[] {"", "'", "2"}) {
                    ms.add(f + w + s);
                }
            }
        }
        CENTER_MOVES = Collections.unmodifiableList(ms);
    }

    /** 24-element centre permutation for each move in CENTER_MOVES. */
    private static final PruningTable.BitPerm[] CENTER_PERMS = buildCentrePerms();

    private static PruningTable.BitPerm[] buildCentrePerms() {
        PruningTable.BitPerm[] out = new PruningTable.BitPerm[CENTER_MOVES.size()];
        for (int mi = 0; mi < CENTER_MOVES.size(); mi++) {
            String move = CENTER_MOVES.get(mi);
            byte[] full = Cube444Moves.permFor(move);
            byte[] cp = new byte[24];
            for (int i = 0; i < 24; i++) {
                int dst = CENTER_POSITIONS[i];
                int src = full[dst] & 0xFF;
                Integer j = CENTRE_INDEX_OF.get(src);
                if (j == null) {
                    throw new IllegalStateException(
                        "move " + move + " sends centre " + i + "→non-centre " + src);
                }
                cp[i] = j.byteValue();
            }
            out[mi] = new PruningTable.BitPerm(cp, move);
        }
        return out;
    }

    /* ─────────────────────────────────────────────────────────────────
     *  Stage 1: UD-axis  ("UD-coloured stickers on U+D faces")
     * ──────────────────────────────────────────────────────────────── */

    /** Bit i set iff CENTER_POSITIONS[i] holds U or D. */
    public static int udStateOf(String state) {
        int bits = 0;
        for (int i = 0; i < 24; i++) {
            char c = state.charAt(CENTER_POSITIONS[i]);
            if (c == 'U' || c == 'D') bits |= 1 << i;
        }
        return bits;
    }

    private static final int UD_GOAL = udStateOf(Cube444.SOLVED);
    private static volatile PruningTable UD_TABLE = null;

    /* ─────────────────────────────────────────────────────────────────
     *  Stage 2: LR-axis  ("LR-coloured stickers on L+R faces, given UD staged")
     *
     *  Move set excludes Rw/Rw'/Lw/Lw'/Fw/Fw'/Bw/Bw' which would slip a
     *  UD-coloured sticker off its axis.  28 moves total: 18 outer +
     *  Uw/Dw × {1,', 2} + Rw2/Lw2/Fw2/Bw2.
     * ──────────────────────────────────────────────────────────────── */

    /** The 16 non-UD-axis centre indices into CENTER_POSITIONS. */
    private static final int[] NON_UD_INDICES = {
         4,  5,  6,  7,        // R
         8,  9, 10, 11,        // F
        16, 17, 18, 19,        // L
        20, 21, 22, 23,        // B
    };
    public static final int[] LR_POSITIONS;
    private static final Map<Integer, Integer> LR_INDEX_OF;
    static {
        LR_POSITIONS = new int[16];
        for (int i = 0; i < NON_UD_INDICES.length; i++) {
            LR_POSITIONS[i] = CENTER_POSITIONS[NON_UD_INDICES[i]];
        }
        LR_INDEX_OF = new HashMap<>();
        for (int i = 0; i < LR_POSITIONS.length; i++) LR_INDEX_OF.put(LR_POSITIONS[i], i);
    }

    public static final List<String> LR_MOVES;
    static {
        List<String> ms = new ArrayList<>(28);
        for (char f : Cube444.FACES) {
            for (String s : new String[] {"", "'", "2"}) ms.add("" + f + s);
        }
        for (char f : new char[] {'U', 'D'}) {
            for (String s : new String[] {"", "'", "2"}) ms.add("" + f + "w" + s);
        }
        for (char f : new char[] {'R', 'L', 'F', 'B'}) ms.add("" + f + "w2");
        LR_MOVES = Collections.unmodifiableList(ms);
    }

    private static final PruningTable.BitPerm[] LR_PERMS = buildLRPerms();

    private static PruningTable.BitPerm[] buildLRPerms() {
        PruningTable.BitPerm[] out = new PruningTable.BitPerm[LR_MOVES.size()];
        for (int mi = 0; mi < LR_MOVES.size(); mi++) {
            String move = LR_MOVES.get(mi);
            byte[] full = Cube444Moves.permFor(move);
            byte[] cp = new byte[16];
            for (int i = 0; i < 16; i++) {
                int dst = LR_POSITIONS[i];
                int src = full[dst] & 0xFF;
                Integer j = LR_INDEX_OF.get(src);
                if (j == null) {
                    throw new IllegalStateException(
                        "move " + move + " sends LR-position " + i + "→off-axis " + src);
                }
                cp[i] = j.byteValue();
            }
            out[mi] = new PruningTable.BitPerm(cp, move);
        }
        return out;
    }

    /** Bit i set iff LR_POSITIONS[i] holds L or R. */
    public static int lrStateOf(String state) {
        int bits = 0;
        for (int i = 0; i < 16; i++) {
            char c = state.charAt(LR_POSITIONS[i]);
            if (c == 'L' || c == 'R') bits |= 1 << i;
        }
        return bits;
    }

    private static final int LR_GOAL = lrStateOf(Cube444.SOLVED);
    private static volatile PruningTable LR_TABLE = null;

    /* ─────────────────────────────────────────────────────────────────
     *  Stage 3: fine (within-axis distribution).
     *
     *  Move set: outer (18) + wide-squared (6) — anything else would shuffle
     *  a sticker between two axes and break the prior stages.
     * ──────────────────────────────────────────────────────────────── */

    private static boolean isUDIndex(int i) { return (i >= 0 && i < 4)  || (i >= 12 && i < 16); }
    private static boolean isLRIndex(int i) { return (i >= 4 && i < 8)  || (i >= 16 && i < 20); }
    private static boolean isFBIndex(int i) { return (i >= 8 && i < 12) || (i >= 20 && i < 24); }

    /** 24-bit fine state.  Per centre position i:
     *    UD-axis position → bit set iff sticker is 'U'  (else 'D')
     *    LR-axis position → bit set iff sticker is 'L'  (else 'R')
     *    FB-axis position → bit set iff sticker is 'F'  (else 'B')
     */
    public static int fineStateOf(String state) {
        int bits = 0;
        for (int i = 0; i < 24; i++) {
            char c = state.charAt(CENTER_POSITIONS[i]);
            boolean on = false;
            if (isUDIndex(i))      on = (c == 'U');
            else if (isLRIndex(i)) on = (c == 'L');
            else if (isFBIndex(i)) on = (c == 'F');
            if (on) bits |= 1 << i;
        }
        return bits;
    }

    public static final List<String> FINE_MOVES;
    private static final PruningTable.BitPerm[] FINE_PERMS;
    static {
        List<String> ms = new ArrayList<>(24);
        List<PruningTable.BitPerm> ps = new ArrayList<>(24);
        for (int i = 0; i < CENTER_MOVES.size(); i++) {
            String m = CENTER_MOVES.get(i);
            boolean isWide = m.contains("w");
            boolean isSquared = m.endsWith("2");
            if (!isWide || isSquared) {
                ms.add(m);
                ps.add(CENTER_PERMS[i]);
            }
        }
        FINE_MOVES = Collections.unmodifiableList(ms);
        FINE_PERMS = ps.toArray(new PruningTable.BitPerm[0]);
    }

    private static final int FINE_GOAL = fineStateOf(Cube444.SOLVED);
    private static volatile PruningTable FINE_TABLE = null;

    /* ─────────────────────────────────────────────────────────────────
     *  Lifecycle
     * ──────────────────────────────────────────────────────────────── */

    /** Build all three pruning tables if they aren't built yet.  Idempotent
     *  and thread-safe (double-checked locking). */
    public static synchronized void ensureReady() {
        if (UD_TABLE   == null) UD_TABLE   = PruningTable.build(24, UD_GOAL,   CENTER_PERMS);
        if (LR_TABLE   == null) LR_TABLE   = PruningTable.build(16, LR_GOAL,   LR_PERMS);
        if (FINE_TABLE == null) FINE_TABLE = PruningTable.build(24, FINE_GOAL, FINE_PERMS);
    }

    public static boolean isReady() {
        return UD_TABLE != null && LR_TABLE != null && FINE_TABLE != null;
    }

    public static int udReachable()   { return UD_TABLE   == null ? -1 : UD_TABLE.reachableStates;   }
    public static int lrReachable()   { return LR_TABLE   == null ? -1 : LR_TABLE.reachableStates;   }
    public static int fineReachable() { return FINE_TABLE == null ? -1 : FINE_TABLE.reachableStates; }

    public static int udMaxDepth()   { return UD_TABLE   == null ? -1 : UD_TABLE.maxDepth;   }
    public static int lrMaxDepth()   { return LR_TABLE   == null ? -1 : LR_TABLE.maxDepth;   }
    public static int fineMaxDepth() { return FINE_TABLE == null ? -1 : FINE_TABLE.maxDepth; }

    /* ─────────────────────────────────────────────────────────────────
     *  Per-stage solving + orchestrator
     * ──────────────────────────────────────────────────────────────── */

    public static List<String> solveUDStage(String state) {
        ensureReady();
        return UD_TABLE.descend(udStateOf(state));
    }

    public static List<String> solveLRStage(String state) {
        ensureReady();
        return LR_TABLE.descend(lrStateOf(state));
    }

    public static List<String> solveFineStage(String state) {
        ensureReady();
        return FINE_TABLE.descend(fineStateOf(state));
    }

    /** True iff every face's 4 inner stickers are that face's colour. */
    public static boolean isCentresSolved(String state) {
        for (char f : Cube444.FACES) {
            int off = Cube444.faceOffset(f);
            for (int p : FACE_CENTRE_POS) {
                if (state.charAt(off + p) != f) return false;
            }
        }
        return true;
    }

    public static final class CentresResult {
        public final List<String> moves;
        public final List<String> udMoves;
        public final List<String> lrMoves;
        public final List<String> fineMoves;
        public final String state;
        CentresResult(List<String> moves, List<String> ud, List<String> lr, List<String> fine, String state) {
            this.moves     = Collections.unmodifiableList(moves);
            this.udMoves   = Collections.unmodifiableList(ud);
            this.lrMoves   = Collections.unmodifiableList(lr);
            this.fineMoves = Collections.unmodifiableList(fine);
            this.state     = state;
        }
    }

    /** Fully solve centres of a 4×4 cube.  Tables are built lazily on first
     *  call (~1 s), subsequent calls are sub-millisecond. */
    public static CentresResult solveCentres(String state) {
        ensureReady();

        List<String> ud = UD_TABLE.descend(udStateOf(state));
        String s = Cube444Moves.applyMoves(state, ud);

        List<String> lr = LR_TABLE.descend(lrStateOf(s));
        s = Cube444Moves.applyMoves(s, lr);

        List<String> fine = FINE_TABLE.descend(fineStateOf(s));
        s = Cube444Moves.applyMoves(s, fine);

        List<String> all = new ArrayList<>(ud.size() + lr.size() + fine.size());
        all.addAll(ud); all.addAll(lr); all.addAll(fine);
        return new CentresResult(all, ud, lr, fine, s);
    }

    private CentresStage() {}
}
