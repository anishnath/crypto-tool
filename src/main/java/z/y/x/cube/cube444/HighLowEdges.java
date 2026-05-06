package z.y.x.cube.cube444;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * High/Low edge-orientation encoder — Java port of
 * {@code RubiksCube444.highlow_edges_state} (and the supporting
 * {@code highlow_edge_values_444} dict from
 * {@code RubiksCubeHighLow.py}).
 *
 * For each wing (= one entry in {@link Cube444Edges#ORIENT_EDGE_PAIRS}),
 * the orientation is determined by:
 *   1. Looking up (sticker_a_idx, sticker_b_idx, colour_a, colour_b)
 *      in the static {@code HIGHLOW} map.
 *   2. The map's value, 'U' or 'D', is the wing's high/low identity.
 *
 * The map is populated once at class-load time from the resource
 * {@code highlow-edge-values-444.tsv}, which is a direct extract of
 * the Python dict (1152 entries, ~30 KB on disk).
 *
 * The result is a 48-character string (one char per wing side, 24
 * wings × 2 sides each) — the canonical key for the step21 lookup
 * table.
 */
public final class HighLowEdges {

    private HighLowEdges() {}

    /** Map key: pack (sticker_a, sticker_b, colour_a, colour_b) into one int.
     *  - sticker_a, sticker_b: 0-95 → 7 bits each (use 8 for headroom)
     *  - colour_a, colour_b: 6 distinct chars → 4 bits each (use 8)
     *
     * Layout (32 bits):  [a 8b][b 8b][colourA 8b][colourB 8b]
     */
    private static int packKey(int a, int b, char ca, char cb) {
        return ((a & 0xFF) << 24)
             | ((b & 0xFF) << 16)
             | ((ca & 0xFF) << 8)
             |  (cb & 0xFF);
    }

    /** sticker positions in the TSV are 1-indexed (Python source); convert. */
    private static final Map<Integer, Character> HIGHLOW = loadResource();

    private static Map<Integer, Character> loadResource() {
        Map<Integer, Character> m = new HashMap<>(1300);
        // Resource path is relative to this class's package on the classpath.
        InputStream in = HighLowEdges.class.getResourceAsStream(
            "/z/y/x/cube/cube444/highlow-edge-values-444.tsv");
        if (in == null) {
            throw new IllegalStateException(
                "highlow-edge-values-444.tsv resource not found on classpath — "
                + "is src/main/resources/z/y/x/cube/cube444/ being packaged?");
        }
        try (BufferedReader r = new BufferedReader(
                new InputStreamReader(in, StandardCharsets.US_ASCII))) {
            String line;
            while ((line = r.readLine()) != null) {
                if (line.isEmpty()) continue;
                String[] f = line.split("\t");
                if (f.length != 5) {
                    throw new IllegalStateException("malformed line: " + line);
                }
                // TSV is already 0-indexed in Java URFDLB layout — the
                // python-extract step (scripts/extract-highlow.py)
                // translates from Python's 1-indexed ULFRBD numbering.
                int a = Integer.parseInt(f[0]);
                int b = Integer.parseInt(f[1]);
                char ca = f[2].charAt(0);
                char cb = f[3].charAt(0);
                char hl = f[4].charAt(0);                // 'U' or 'D'
                m.put(packKey(a, b, ca, cb), hl);
            }
        } catch (IOException e) {
            throw new IllegalStateException("failed reading highlow resource", e);
        }
        return m;
    }

    /** True iff the orientation lookup map has been populated.  Always
     *  returns true once {@link HighLowEdges} is class-loaded; useful
     *  for diagnostics. */
    public static int loadedEntryCount() { return HIGHLOW.size(); }

    /**
     * Compute the 48-character "high/low" orientation state for a 4×4
     * cube state.  Each character is 'U' (high) or 'D' (low).
     *
     * Equivalent to {@code RubiksCube444.highlow_edges_state(None)}
     * (no edges flipped) when {@code edgesToFlip} is null/empty.
     *
     * @param state         96-character cube state
     * @param edgesToFlip   currently unused — placeholder for the
     *                      "what if we flip these wings first" overload
     *                      used by the IDA* search; pass null for now.
     */
    public static String stateOf(String state, Object edgesToFlip) {
        if (state.length() != Cube444.TOTAL_STICKERS) {
            throw new IllegalArgumentException(
                "state length " + state.length() + " ≠ 96");
        }
        int[] pairs = Cube444Edges.ORIENT_EDGE_PAIRS;
        int n = Cube444Edges.ORIENT_PAIR_COUNT;
        char[] out = new char[n];
        for (int k = 0; k < n; k++) {
            int a = pairs[2 * k];
            int b = pairs[2 * k + 1];
            char ca = state.charAt(a);
            char cb = state.charAt(b);
            Character hl = HIGHLOW.get(packKey(a, b, ca, cb));
            if (hl == null) {
                throw new IllegalStateException(
                    "no orientation entry for (a=" + a + " b=" + b
                    + " ca=" + ca + " cb=" + cb + ")");
            }
            out[k] = hl;
        }
        return new String(out);
    }

    /** Convenience overload — no edge-flip override, the common case. */
    public static String stateOf(String state) {
        return stateOf(state, null);
    }
}
