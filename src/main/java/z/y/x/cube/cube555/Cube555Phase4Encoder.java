package z.y.x.cube.cube555;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Encoder for 5×5 phase 4 — "stage 4 specific edges".
 *
 * <p>Given the cube state and a 4-tuple of {@code wing_strs} (canonical
 * edge identities like "LB", "RF"), produce the 18-character hex key
 * used by the {@code lookup-table-5x5x5-step40-phase4.txt} table.
 *
 * <p>Algorithm (mirrors Python's {@code LookupTable555Phase4.ida_heuristic}):
 * <ol>
 *   <li>For each of 36 wing positions in {@link #WINGS_FOR_PATTERN}:
 *     <ul>
 *       <li>Read the wing's two stickers (this position + its partner).</li>
 *       <li>Look up the canonical edge identity in {@link #WING_STR_MAP}.</li>
 *       <li>Mark both stickers 'L' if the identity is in {@code wingStrs},
 *           else 'x'.</li>
 *     </ul>
 *   </li>
 *   <li>Build a 72-bit string by reading {@link #EDGES_555} positions:
 *       1 if 'L', 0 otherwise.</li>
 *   <li>Format as 18-char zero-padded lowercase hex.</li>
 * </ol>
 *
 * <p>All position constants are translated from Python ULFRBD 1-indexed
 * to Java URFDLB 0-indexed.
 */
public final class Cube555Phase4Encoder {

    private Cube555Phase4Encoder() {}

    /** Translate Python 1-indexed ULFRBD position to Java 0-indexed URFDLB. */
    private static int py(int p) {
        p -= 1;
        if (p < 25)  return p;
        if (p < 50)  return p + 75;
        if (p < 75)  return p;
        if (p < 100) return p - 50;
        if (p < 125) return p + 25;
        return p - 50;
    }

    /** {@code wings_for_edges_pattern_555} — 36 wing-sticker positions
     *  (one per wing).  Translated to Java URFDLB 0-indexed. */
    public static final int[] WINGS_FOR_PATTERN = pyArr(
        2, 3, 4, 6, 11, 16, 10, 15, 20, 22, 23, 24,
        31, 36, 41, 35, 40, 45,
        81, 86, 91, 85, 90, 95,
        127, 128, 129, 131, 136, 141, 135, 140, 145, 147, 148, 149);

    /** {@code edges_555} — 72 edge sticker positions used to encode
     *  the 72-bit phase 4 state.  Translated to Java URFDLB 0-indexed. */
    public static final int[] EDGES_555 = pyArr(
        2, 3, 4, 6, 10, 11, 15, 16, 20, 22, 23, 24,
        27, 28, 29, 31, 35, 36, 40, 41, 45, 47, 48, 49,
        52, 53, 54, 56, 60, 61, 65, 66, 70, 72, 73, 74,
        77, 78, 79, 81, 85, 86, 90, 91, 95, 97, 98, 99,
        102, 103, 104, 106, 110, 111, 115, 116, 120, 122, 123, 124,
        127, 128, 129, 131, 135, 136, 140, 141, 145, 147, 148, 149);

    /** {@code edges_partner_555} — for each edge sticker position,
     *  the position of its other half (on the adjacent face).
     *  Java URFDLB 0-indexed.  Stored as a flat array indexed by
     *  position (size 150, holds -1 for non-edge positions). */
    public static final int[] EDGES_PARTNER = buildPartnerArray();

    private static int[] buildPartnerArray() {
        int[] partner = new int[Cube555.TOTAL_STICKERS];
        Arrays.fill(partner, -1);
        // Python edges_partner_555 dict — translated to Java.
        int[][] pairs = {
            {2,104}, {3,103}, {4,102}, {6,27}, {10,79}, {11,28},
            {15,78}, {16,29}, {20,77}, {22,52}, {23,53}, {24,54},
            {27,6}, {28,11}, {29,16}, {31,110}, {35,56}, {36,115},
            {40,61}, {41,120}, {45,66}, {47,141}, {48,136}, {49,131},
            {52,22}, {53,23}, {54,24}, {56,35}, {60,81}, {61,40},
            {65,86}, {66,45}, {70,91}, {72,127}, {73,128}, {74,129},
            {77,20}, {78,15}, {79,10}, {81,60}, {85,106}, {86,65},
            {90,111}, {91,70}, {95,116}, {97,135}, {98,140}, {99,145},
            {102,4}, {103,3}, {104,2}, {106,85}, {110,31}, {111,90},
            {115,36}, {116,95}, {120,41}, {122,149}, {123,148}, {124,147},
            {127,72}, {128,73}, {129,74}, {131,49}, {135,97}, {136,48},
            {140,98}, {141,47}, {145,99}, {147,124}, {148,123}, {149,122},
        };
        for (int[] p : pairs) partner[py(p[0])] = py(p[1]);
        return partner;
    }

    /** {@code wing_str_map} — canonical name lookup for any 2-letter
     *  wing colour-pair (UB == BU == "UB").  Sentinel "xx" maps to "xx"
     *  (used during partial cube exploration).  ASCII-keyed for fast
     *  lookup. */
    private static final Map<String, String> WING_STR_MAP = buildWingStrMap();

    private static Map<String, String> buildWingStrMap() {
        Map<String, String> m = new HashMap<>(28);
        String[] canonical = { "UB", "UL", "UR", "UF",
                               "LB", "LF", "RB", "RF",
                               "DB", "DL", "DR", "DF" };
        for (String s : canonical) {
            m.put(s, s);
            m.put("" + s.charAt(1) + s.charAt(0), s);   // reversed → canonical
        }
        m.put("xx", "xx");
        return m;
    }

    /** Lookup the canonical edge identity for a 2-letter colour pair, or
     *  {@code null} if the pair isn't a valid edge (impossible cube state). */
    public static String canonicalWing(char a, char b) {
        return WING_STR_MAP.get("" + a + b);
    }

    /**
     * Encode the phase 4 state for the given cube + 4-tuple of target
     * wings.
     *
     * @param state    150-char URFDLB cube state
     * @param wingStrs the 4 canonical wing identities to "stage" (e.g.
     *                 {@code {"LB", "LF", "RB", "RF"}}).
     * @return 18-character lowercase hex key
     */
    public static String encode(String state, String[] wingStrs) {
        Set<String> targets = new HashSet<>(Arrays.asList(wingStrs));

        // Per-wing recolour: 'L' if its canonical identity is in targets,
        // else 'x'.  We keep a parallel char[] of length 150 (start as
        // a copy of the original state), modify wing positions only,
        // then read out the 72 edges_555 positions as bits.
        char[] recoloured = state.toCharArray();
        for (int pos : WINGS_FOR_PATTERN) {
            int partner = EDGES_PARTNER[pos];
            char a = recoloured[pos];
            char b = recoloured[partner];
            String pair = "" + a + b;
            // Python skips 'LL' / 'xx' early — for us, those map cleanly
            // through wing_str_map (or are never present in real cubes).
            if (pair.equals("LL") || pair.equals("xx")) continue;
            String canon = WING_STR_MAP.get(pair);
            char marker = (canon != null && targets.contains(canon)) ? 'L' : 'x';
            recoloured[pos]     = marker;
            recoloured[partner] = marker;
        }

        // Build 72-bit string from EDGES_555 positions, MSB first.
        long[] bits = new long[2];   // 72 bits = 64 + 8
        // Use simple per-bit accumulation across two 64-bit halves:
        // bits[0] holds bits 0..63 (MSB at bit 71), bits[1] holds bits 64..71.
        // To avoid the split, just build the full 18-hex string char by char.
        char[] out = new char[18];
        int nibble = 0;
        int nibBit = 0;     // bits accumulated into current nibble (0..3)
        int outIdx = 0;
        for (int i = 0; i < EDGES_555.length; i++) {
            int b = recoloured[EDGES_555[i]] == 'L' ? 1 : 0;
            nibble = (nibble << 1) | b;
            nibBit++;
            if (nibBit == 4) {
                out[outIdx++] = (char) (nibble < 10 ? ('0' + nibble) : ('a' + nibble - 10));
                nibble = 0;
                nibBit = 0;
            }
        }
        return new String(out);
    }

    public static String encodeBytes(byte[] state, String[] wingStrs) {
        return encode(Cube555Bytes.toString(state), wingStrs);
    }

    /* ── helpers ─────────────────────────────────────────────────── */

    private static int[] pyArr(int... pyPositions) {
        int[] out = new int[pyPositions.length];
        for (int i = 0; i < pyPositions.length; i++) out[i] = py(pyPositions[i]);
        return out;
    }
}
