package z.y.x.cube.cube555;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Java port of Python's {@code edges_recolor_pattern_555}.
 *
 * <p>Recolours a 150-char cube state by replacing each edge sticker
 * with a single-letter ID derived from the edge's identity + high/low
 * orientation:
 * <ul>
 *   <li>Each of 12 cube edges (UB, UL, UR, UF, LB, LF, RF, RB, DB, DL,
 *       DR, DF) gets a unique letter (o-z lowercase).</li>
 *   <li>High-orientation stickers get UPPERCASE; low-orientation get
 *       lowercase.</li>
 *   <li>If {@code onlyColors} is non-null, edges whose canonical
 *       identity isn't in the set are recoloured to '-' instead.</li>
 * </ul>
 *
 * <p>Position arrays and the wing→letter mapping all translate cleanly
 * from Python's ULFRBD-1-indexed source via the standard URFDLB-0-indexed
 * mapping.
 */
public final class Cube555EdgeRecolor {

    private Cube555EdgeRecolor() {}

    private static int py(int p) {
        p -= 1;
        if (p < 25)  return p;
        if (p < 50)  return p + 75;
        if (p < 75)  return p;
        if (p < 100) return p - 50;
        if (p < 125) return p + 25;
        return p - 50;
    }

    /** {@code midges_recolor_tuples_555} — 12 entries: (letter, midgeSticker1,
     *  midgeSticker2).  Each midge gets a unique lowercase letter that
     *  becomes the encoded ID for that edge (uppercase = high orientation). */
    public static final Object[][] MIDGE_TUPLES = {
        {'o', py(3),   py(103)},   // UB
        {'p', py(11),  py(28)},    // UL
        {'q', py(15),  py(78)},    // UR
        {'r', py(23),  py(53)},    // UF
        {'s', py(36),  py(115)},   // LB
        {'t', py(40),  py(61)},    // LF
        {'u', py(86),  py(65)},    // RF
        {'v', py(90),  py(111)},   // RB
        {'w', py(128), py(73)},    // DB
        {'x', py(136), py(48)},    // DL
        {'y', py(140), py(98)},    // DR
        {'z', py(148), py(123)},   // DF
    };

    /** {@code edges_recolor_tuples_555} — 24 wing pairs: (square, partner).
     *  We omit Python's per-wing letter ID — we use the midge's letter for
     *  the wing's canonical edge identity. */
    public static final int[][] WING_TUPLES = {
        {py(2),   py(104)}, {py(4),   py(102)}, {py(6),   py(27)},  {py(10),  py(79)},
        {py(16),  py(29)},  {py(20),  py(77)},  {py(22),  py(52)},  {py(24),  py(54)},
        {py(31),  py(110)}, {py(35),  py(56)},  {py(41),  py(120)}, {py(45),  py(66)},
        {py(81),  py(60)},  {py(85),  py(106)}, {py(91),  py(70)},  {py(95),  py(116)},
        {py(127), py(72)},  {py(129), py(74)},  {py(131), py(49)},  {py(135), py(97)},
        {py(141), py(47)},  {py(145), py(99)},  {py(147), py(124)}, {py(149), py(122)},
    };

    /** Canonical wing-identity lookup: {@code "UB" -> "UB"}, {@code "BU" -> "UB"}, etc.
     *  Handles all 12 valid edges in either direction.  '--' maps to '--'
     *  (placeholder for partial cube exploration). */
    private static final Map<String, String> WING_STR_MAP = buildWingStrMap();

    private static Map<String, String> buildWingStrMap() {
        Map<String, String> m = new HashMap<>(28);
        String[] canonical = { "UB", "UL", "UR", "UF",
                               "LB", "LF", "RB", "RF",
                               "DB", "DL", "DR", "DF" };
        for (String s : canonical) {
            m.put(s, s);
            m.put("" + s.charAt(1) + s.charAt(0), s);
        }
        m.put("--", "--");
        return m;
    }

    /**
     * Recolour {@code state} as Python's {@code edges_recolor_pattern_555}
     * does.  Returns a fresh 150-char string with edge stickers replaced
     * by single-letter IDs (or '-' for filtered-out wings).
     *
     * <p>Centres + corners are passed through unchanged.
     *
     * @param state       150-char Java URFDLB cube state
     * @param onlyColors  if non-null, only edges whose canonical identity
     *                    is in this set keep their letter (others → '-')
     */
    public static char[] recolor(String state, Set<String> onlyColors) {
        char[] s = state.toCharArray();

        // Pass 1: midges.  Populate midgeLetters as we go — wings will
        // need this mapping to know which letter to use for their edge
        // identity in pass 2.
        Map<String, Character> midgeLetters = new HashMap<>(16);
        for (Object[] tup : MIDGE_TUPLES) {
            char letter = (Character) tup[0];
            int sq = (Integer) tup[1];
            int pt = (Integer) tup[2];
            recolorOne(s, sq, pt, letter, midgeLetters, onlyColors, /*useMap=*/false);
        }
        // Pass 2: wings.  Use midgeLetters to find the right letter.
        for (int[] tup : WING_TUPLES) {
            int sq = tup[0], pt = tup[1];
            recolorOne(s, sq, pt, '?', midgeLetters, onlyColors, /*useMap=*/true);
        }
        return s;
    }

    /** Recolour one edge cubie (midge or wing).  Mirrors the inner loop
     *  of Python's edges_recolor_pattern_555. */
    private static void recolorOne(char[] s, int sq, int pt,
                                   char midgeLetter,
                                   Map<String, Character> midgeLetters,
                                   Set<String> onlyColors,
                                   boolean useMap) {
        char a = s[sq], b = s[pt];
        // Python's early-out conditions.
        if (a == '-' || b == '-') return;
        if (a == '.' && b == '.') return;

        String pair = "" + a + b;
        String wingStr = WING_STR_MAP.get(pair);
        if (wingStr == null || wingStr.equals("--")) return;

        if (!useMap) {
            midgeLetters.put(wingStr, midgeLetter);
        }
        if (onlyColors != null && !onlyColors.contains(wingStr)) {
            s[sq] = '-';
            s[pt] = '-';
            return;
        }
        char letter = useMap ? midgeLetters.getOrDefault(wingStr, '?') : midgeLetter;
        if (letter == '?') return;     // wing's midge wasn't processed (shouldn't happen)

        char highLow = HighLowEdges555.lookup(sq, pt, a, b);
        char marker = (highLow == 'U') ? Character.toUpperCase(letter) : letter;
        s[sq] = marker;
        s[pt] = marker;
    }

    /* ── Convenience static set membership helpers ──────────────── */

    static Set<String> setOf(String... items) {
        Set<String> out = new HashSet<>(items.length * 2);
        for (String s : items) out.add(s);
        return out;
    }
}
