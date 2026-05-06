package z.y.x.cube.cube555;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * High/Low edge-orientation lookup for 5×5 — sister of {@code HighLowEdges}
 * in cube444.
 *
 * <p>For each (sticker_a_idx, sticker_b_idx, colour_a, colour_b) entry,
 * the table holds 'U' (high orientation) or 'D' (low orientation).
 *
 * <p>Loaded once at class-load time from
 * {@code z/y/x/cube/cube555/highlow-edge-values-555.tsv} (1,728 entries,
 * generated from Python's {@code highlow_edge_values_555} dict by the
 * extraction script under the cube555 source).  Keys are already
 * translated from Python ULFRBD 1-indexed into Java URFDLB 0-indexed.
 */
public final class HighLowEdges555 {

    private HighLowEdges555() {}

    /** Pack (a, b, colA, colB) into one int for HashMap keys.
     *  Sticker indices fit in 8 bits (0..149); face letters fit in 8 bits. */
    private static int packKey(int a, int b, char ca, char cb) {
        return ((a & 0xFF) << 24)
             | ((b & 0xFF) << 16)
             | ((ca & 0xFF) << 8)
             |  (cb & 0xFF);
    }

    private static final Map<Integer, Character> HIGHLOW = loadResource();

    private static Map<Integer, Character> loadResource() {
        Map<Integer, Character> m = new HashMap<>(2000);
        InputStream in = HighLowEdges555.class.getResourceAsStream(
            "/z/y/x/cube/cube555/highlow-edge-values-555.tsv");
        if (in == null) {
            throw new IllegalStateException(
                "highlow-edge-values-555.tsv resource not found on classpath");
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
                int a = Integer.parseInt(f[0]);
                int b = Integer.parseInt(f[1]);
                char ca = f[2].charAt(0);
                char cb = f[3].charAt(0);
                char hl = f[4].charAt(0);                // 'U' or 'D'
                m.put(packKey(a, b, ca, cb), hl);
            }
        } catch (IOException e) {
            throw new IllegalStateException("failed reading highlow-555 resource", e);
        }
        return m;
    }

    public static int loadedEntryCount() { return HIGHLOW.size(); }

    /** Look up the high/low orientation for one wing or midge.  Returns
     *  '.' if no entry exists (caller decides how to handle — typically
     *  during partial-cube searches some pairs aren't yet meaningful). */
    public static char lookup(int a, int b, char ca, char cb) {
        Character c = HIGHLOW.get(packKey(a, b, ca, cb));
        return c == null ? '.' : c;
    }
}
