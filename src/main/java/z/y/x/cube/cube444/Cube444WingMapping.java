package z.y.x.cube.cube444;

import java.util.HashMap;
import java.util.Map;

/**
 * Wing labelling tables for step32 / step42 — port of
 * {@code wings_for_edges_recolor_pattern_444} +
 * {@code wing_str_map} + {@code wings_444} from the Python source.
 *
 * The reference solver assigns each of the 24 wing pairs a single-
 * character "edge id" (0-9, a-n).  When two wings have the same
 * underlying dedge identity (e.g. both are UR-type), the recoloured
 * state replaces both stickers of one wing with the *other* wing's
 * edge id — that's how it encodes "which two wings should pair up"
 * as a 24-character lookup key.
 */
public final class Cube444WingMapping {

    private Cube444WingMapping() {}

    /**
     * 24 wings with their assigned edge id and 0-indexed Java URFDLB
     * sticker positions.  Order matches Python's
     * {@code wings_for_edges_recolor_pattern_444} for parity.
     */
    public static final char[]   EDGE_IDS;
    public static final int[]    STICKER_A;
    public static final int[]    STICKER_B;
    static {
        Object[][] raw = new Object[][] {
            // (edge_id, py_sticker_a, py_sticker_b)
            {'0',  2, 67},  // Upper
            {'1',  3, 66},
            {'2',  5, 18},
            {'3',  8, 51},
            {'4',  9, 19},
            {'5', 12, 50},
            {'6', 14, 34},
            {'7', 15, 35},
            {'8', 21, 72},  // Left
            {'9', 24, 37},
            {'a', 25, 76},
            {'b', 28, 41},
            {'c', 53, 40},  // Right
            {'d', 56, 69},
            {'e', 57, 44},
            {'f', 60, 73},
            {'g', 82, 46},  // Down
            {'h', 83, 47},
            {'i', 85, 31},
            {'j', 88, 62},
            {'k', 89, 30},
            {'l', 92, 63},
            {'m', 94, 79},
            {'n', 95, 78},
        };
        EDGE_IDS  = new char[24];
        STICKER_A = new int[24];
        STICKER_B = new int[24];
        for (int i = 0; i < 24; i++) {
            EDGE_IDS[i]  = (char) raw[i][0];
            STICKER_A[i] = Cube444Edges.pyUlfrbdToJavaUrfdlb((Integer) raw[i][1]);
            STICKER_B[i] = Cube444Edges.pyUlfrbdToJavaUrfdlb((Integer) raw[i][2]);
        }
    }

    /** Map (colour_a, colour_b) → canonical wing string (e.g. "UF").
     *  "FU" maps to "UF" too — order doesn't matter for identity. */
    public static final Map<String, String> WING_STR_MAP = buildWingStrMap();

    private static Map<String, String> buildWingStrMap() {
        Map<String, String> m = new HashMap<>(32);
        String[] canon = {
            "UB", "UL", "UR", "UF",
            "LB", "LF", "RB", "RF",
            "DB", "DL", "DR", "DF",
        };
        for (String s : canon) {
            m.put(s, s);
            m.put("" + s.charAt(1) + s.charAt(0), s);
        }
        m.put("--", "--");
        return m;
    }

    /**
     * Sticker positions read by the step32 state extractor, in order.
     * Port of {@code wings_444} (24 entries).
     */
    public static final int[] STEP32_WING_POSITIONS;
    static {
        int[] pyIndices = {
            // Upper
             2,  3,  5,  9,  8, 12, 14, 15,
            // Left
            21, 25, 24, 28,
            // Right
            53, 57, 56, 60,
            // Back
            82, 83, 85, 89, 88, 92, 94, 95,
        };
        STEP32_WING_POSITIONS = new int[pyIndices.length];
        for (int i = 0; i < pyIndices.length; i++) {
            STEP32_WING_POSITIONS[i] = Cube444Edges.pyUlfrbdToJavaUrfdlb(pyIndices[i]);
        }
    }
}
