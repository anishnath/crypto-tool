package z.y.x.cube.cube444;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Edge recolouring + state encoders for step32 / step42 — Java port of
 * {@code edges_recolor_pattern_444} from {@code RubiksCube444.py}.
 *
 * The recolour step replaces each wing's two stickers with a symbolic
 * "edge id" character indicating which OTHER wing of the same dedge
 * type is its partner.  After recolouring, identical dedge-types share
 * matching ids → pairing detection becomes a string match.
 *
 * For step32, only wings whose dedge type is in {LB, LF, RB, RF} are
 * recoloured; everything else is replaced with '-' (don't-care).  The
 * resulting 96-character state is then sampled at the 24
 * {@link Cube444WingMapping#STEP32_WING_POSITIONS} indices to produce
 * the lookup-table key.
 */
public final class EdgesRecolor {

    private EdgesRecolor() {}

    /** Default first-four-edges set used by step32 in the Python source. */
    public static final Set<String> FIRST_FOUR_EDGES = setOf("LB", "LF", "RB", "RF");

    /** Default last-eight-edges set used by step42 (the complement). */
    public static final Set<String> LAST_EIGHT_EDGES =
        setOf("UB", "UL", "UR", "UF", "DB", "DL", "DR", "DF");

    private static Set<String> setOf(String... xs) {
        Set<String> s = new HashSet<>();
        for (String x : xs) s.add(x);
        return s;
    }

    /**
     * Recolour the wings of {@code state} using the algorithm in
     * {@code edges_recolor_pattern_444}.
     *
     * @param state       96-character cube state (URFDLB).
     * @param onlyColors  set of dedge names to keep ("UF", "LB", …).
     *                    Wings not in this set are stamped with '-'.
     *                    Pass {@code null} for "all wings".
     * @return            96-character recoloured state.
     */
    public static String recolour(String state, Set<String> onlyColors) {
        char[] s = state.toCharArray();
        Map<String, List<Character>> edgeMap = buildDedgeMap();

        // Pass 1: classify each wing by its dedge identity, record the
        // edge ids that belong to each dedge.
        for (int i = 0; i < 24; i++) {
            char id = Cube444WingMapping.EDGE_IDS[i];
            int a = Cube444WingMapping.STICKER_A[i];
            int b = Cube444WingMapping.STICKER_B[i];
            String key = "" + s[a] + s[b];
            String wing = Cube444WingMapping.WING_STR_MAP.get(key);
            if (wing == null) {
                throw new IllegalStateException(
                    "unknown wing colour pair '" + key + "' at sticker positions ("
                    + a + ", " + b + ")");
            }
            edgeMap.get(wing).add(id);
        }

        // Pass 2: rewrite each wing's stickers with the partner's edge id
        // (the other entry in edgeMap[wing] that isn't this one).
        // If onlyColors filter excludes this wing, stamp '-' instead.
        for (int i = 0; i < 24; i++) {
            char id = Cube444WingMapping.EDGE_IDS[i];
            int a = Cube444WingMapping.STICKER_A[i];
            int b = Cube444WingMapping.STICKER_B[i];
            String key = "" + s[a] + s[b];
            String wing = Cube444WingMapping.WING_STR_MAP.get(key);

            if ((onlyColors != null && !onlyColors.contains(wing)) || "--".equals(wing)) {
                s[a] = '-';
                s[b] = '-';
                continue;
            }

            char partnerId = 0;
            for (Character cand : edgeMap.get(wing)) {
                if (cand.charValue() != id) { partnerId = cand; break; }
            }
            if (partnerId == 0) {
                throw new IllegalStateException(
                    "could not find partner for wing " + wing + " edge id " + id);
            }
            s[a] = partnerId;
            s[b] = partnerId;
        }
        return new String(s);
    }

    private static Map<String, List<Character>> buildDedgeMap() {
        Map<String, List<Character>> m = new HashMap<>(16);
        String[] keys = {"UB","UL","UR","UF","LB","LF","RB","RF","DB","DL","DR","DF","--"};
        for (String k : keys) m.put(k, new ArrayList<Character>(2));
        return m;
    }

    /**
     * Compute the 24-character step32 lookup key.  Port of
     * {@code LookupTable444Reduce333FirstFourEdges.state()}.
     */
    public static String step32StateOf(String state) {
        return sampleAtWings(recolour(state, FIRST_FOUR_EDGES));
    }

    /**
     * Compute the 24-character step42 lookup key.  Port of
     * {@code LookupTable444Reduce333LastEightEdges.state()}.  Same as
     * step32 but with the complement edge set.
     */
    public static String step42StateOf(String state) {
        return sampleAtWings(recolour(state, LAST_EIGHT_EDGES));
    }

    private static String sampleAtWings(String recoloured) {
        int[] pos = Cube444WingMapping.STEP32_WING_POSITIONS;
        char[] out = new char[pos.length];
        for (int i = 0; i < pos.length; i++) out[i] = recoloured.charAt(pos[i]);
        return new String(out);
    }

    /** Centre-positions in Python ULFRBD face order — port of
     *  {@code centers_444}.  Used by step41 (and step22). */
    public static final int[] CENTERS_ULFRBD;
    static {
        // Python ULFRBD positions (1-indexed): U=6,7,10,11  L=22,23,26,27
        // F=38,39,42,43  R=54,55,58,59  B=70,71,74,75  D=86,87,90,91
        int[] py = {
             6,  7, 10, 11,
            22, 23, 26, 27,
            38, 39, 42, 43,
            54, 55, 58, 59,
            70, 71, 74, 75,
            86, 87, 90, 91,
        };
        CENTERS_ULFRBD = new int[py.length];
        for (int i = 0; i < py.length; i++) {
            CENTERS_ULFRBD[i] = Cube444Edges.pyUlfrbdToJavaUrfdlb(py[i]);
        }
    }

    /** Step41 centres-state encoder.  Reads the 24 centre stickers in
     *  Python ULFRBD order and concatenates — port of
     *  {@code LookupTable444Reduce333Centers.state()}. */
    public static String step41StateOf(String state) {
        char[] out = new char[CENTERS_ULFRBD.length];
        for (int i = 0; i < out.length; i++) {
            out[i] = state.charAt(CENTERS_ULFRBD[i]);
        }
        return new String(out);
    }

    /**
     * Allocation-free variant of {@link #step41StateOf(String)} — writes
     * the 24-byte key into the provided buffer (which must be at least
     * 24 bytes long).  Used by the byte[] IDA* heuristic.
     */
    public static void step41StateOfBytes(byte[] state, byte[] keyOut) {
        for (int i = 0; i < CENTERS_ULFRBD.length; i++) {
            keyOut[i] = state[CENTERS_ULFRBD[i]];
        }
    }

    /** LFRB centre positions in Python ULFRBD order — port of
     *  {@code LFRB_centers_444}.  Used by step31. */
    public static final int[] LFRB_CENTERS_ULFRBD;
    static {
        int[] py = {
            22, 23, 26, 27,
            38, 39, 42, 43,
            54, 55, 58, 59,
            70, 71, 74, 75,
        };
        LFRB_CENTERS_ULFRBD = new int[py.length];
        for (int i = 0; i < py.length; i++) {
            LFRB_CENTERS_ULFRBD[i] = Cube444Edges.pyUlfrbdToJavaUrfdlb(py[i]);
        }
    }

    /** Step31 LFRB-centres encoder — port of
     *  {@code LookupTable444Reduce333FirstTwoCenters.state()}. */
    public static String step31StateOf(String state) {
        char[] out = new char[LFRB_CENTERS_ULFRBD.length];
        for (int i = 0; i < out.length; i++) {
            out[i] = state.charAt(LFRB_CENTERS_ULFRBD[i]);
        }
        return new String(out);
    }

    /** Step22 centres-state encoder for phase2 — port of
     *  {@code LookupTable444HighLowEdgesCenters.state()}.
     *  Maps each centre sticker:
     *    L or R  →  L / R as-is
     *    U or D  →  "U"  (collapsed)
     *    F or B  →  "x"  (don't-care)
     */
    public static String step22StateOf(String state) {
        char[] out = new char[CENTERS_ULFRBD.length];
        for (int i = 0; i < out.length; i++) {
            char c = state.charAt(CENTERS_ULFRBD[i]);
            if (c == 'L' || c == 'R')      out[i] = c;
            else if (c == 'U' || c == 'D') out[i] = 'U';
            else                            out[i] = 'x';
        }
        return new String(out);
    }
}
