package z.y.x.cube.lookup;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.GZIPInputStream;

/**
 * In-memory text lookup table — used for the 5×5 (and larger) stage
 * tables that the upstream {@code rubikscubennnsolver} hosts only as
 * {@code .txt.gz} files (no {@code .bin} mirror exists).
 *
 * <p>Each line of the underlying file is:
 * <pre>
 *   &lt;state-string&gt; : &lt;solution-moves padded with spaces&gt;
 * </pre>
 * where {@code state-string} is the encoder's output for some sub-cube
 * state, and {@code solution-moves} is the optimal move sequence to
 * reach the goal state(s) from this state under the table's restricted
 * move set.
 *
 * <p>For our usage the table behaves like a (state → cost) pruning table
 * — the cost is just {@code split(' ').length}.  We also keep the actual
 * move list so that small "perfect-hash" tables (those whose entire BFS
 * graph is enumerated, like 5×5 step23) can serve as direct solvers
 * without an IDA* layer on top.
 *
 * <h2>Memory</h2>
 *
 * Tables are loaded fully into a {@link HashMap} on first access.  Sizes
 * we expect to use this for:
 * <ul>
 *   <li>step23 LR-centre-stage: 4,900 entries → ~1 MB heap</li>
 *   <li>step11/12 LR T/X-centre-stage: 735K entries → ~30 MB heap each</li>
 *   <li>step40 phase4: 32M entries → ~1 GB heap (DEFER — needs .bin format)</li>
 * </ul>
 *
 * For the small/medium tables this is fine.  Phase4 needs a different
 * strategy (mmap'd .bin or on-disk binary search) — addressed when we
 * port that phase.
 *
 * <h2>Caching</h2>
 *
 * First access downloads {@code <baseUrl>/<filename>.gz} into
 * {@code <cacheDir>/<filename>.gz}, decompresses it lazily into the
 * heap.  Subsequent JVM lifetimes reuse the cached file.
 */
public final class TextLookupTable {

    /** state → solution moves (space-separated, trimmed of trailing pad). */
    private final Map<String, String> entries;

    /** All goal-state strings (cost-0 entries).  Stored as a quick set
     *  for {@link #isGoal(String)} checks. */
    private final java.util.Set<String> goals;

    /** File-name (without .gz) — for diagnostics. */
    private final String filename;

    private TextLookupTable(String filename, Map<String, String> entries,
                            java.util.Set<String> goals) {
        this.filename = filename;
        this.entries  = Collections.unmodifiableMap(entries);
        this.goals    = Collections.unmodifiableSet(goals);
    }

    /** Number of entries in the table. */
    public int size() { return entries.size(); }

    /** Source filename (sans .gz suffix). */
    public String filename() { return filename; }

    /** Returns the optimal solution for {@code state} as a space-
     *  separated move string ("" for goal states), or {@code null} if
     *  the state is not in the table. */
    public String solutionFor(String state) {
        return entries.get(state);
    }

    /** Distance (number of moves) to a goal state, or {@code -1} if the
     *  state is not in the table. */
    public int costFor(String state) {
        String s = entries.get(state);
        if (s == null) return -1;
        if (s.isEmpty()) return 0;
        // Count whitespace-separated tokens.
        int n = 0;
        int len = s.length();
        boolean inTok = false;
        for (int i = 0; i < len; i++) {
            boolean ws = Character.isWhitespace(s.charAt(i));
            if (!ws && !inTok) { n++; inTok = true; }
            else if (ws) inTok = false;
        }
        return n;
    }

    /** True iff {@code state} is one of the goal states for this table. */
    public boolean isGoal(String state) { return goals.contains(state); }

    /**
     * Load the table named {@code filename} (e.g.
     * {@code "lookup-table-5x5x5-step23-LR-center-stage.txt"}) from the
     * configured base URL, caching to disk on first access.
     */
    public static TextLookupTable fetch(String filename) throws IOException {
        Path cached = ensureCachedGz(filename);
        return parse(filename, cached);
    }

    /* ── helpers ─────────────────────────────────────────────────── */

    private static Path ensureCachedGz(String filename) throws IOException {
        String cacheDir = System.getProperty("cube.lookup.cacheDir");
        Path dir;
        if (cacheDir != null && !cacheDir.isEmpty()) {
            dir = Paths.get(cacheDir);
        } else {
            dir = Paths.get(System.getProperty("java.io.tmpdir"), "cube-lookup-cache");
        }
        Files.createDirectories(dir);
        Path gz = dir.resolve(filename + ".gz");
        if (Files.exists(gz) && Files.size(gz) > 0) return gz;

        String base = System.getProperty("cube.lookup.baseUrl");
        if (base == null || base.isEmpty()) {
            base = "https://rubiks-cube-lookup-tables.s3.amazonaws.com/";
        }
        if (!base.endsWith("/")) base = base + "/";
        URL url = new URL(base + filename + ".gz");

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(15_000);
        conn.setReadTimeout(120_000);
        conn.setRequestProperty("User-Agent", "crypto-tool-cube-solver/1.0");
        try (InputStream in = conn.getInputStream()) {
            Path tmp = Files.createTempFile(dir, filename + ".", ".gz.tmp");
            Files.copy(in, tmp, StandardCopyOption.REPLACE_EXISTING);
            Files.move(tmp, gz, StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING);
        } finally {
            conn.disconnect();
        }
        return gz;
    }

    private static TextLookupTable parse(String filename, Path gz) throws IOException {
        Map<String, String> map = new HashMap<>();
        java.util.Set<String> goals = new java.util.HashSet<>();
        try (InputStream fileIn = Files.newInputStream(gz);
             GZIPInputStream gzIn = new GZIPInputStream(fileIn);
             BufferedReader reader = new BufferedReader(
                 new InputStreamReader(gzIn, StandardCharsets.US_ASCII))) {
            String line;
            while ((line = reader.readLine()) != null) {
                int colon = line.indexOf(':');
                if (colon < 0) continue;
                String state = line.substring(0, colon);
                String soln = line.substring(colon + 1).trim();
                map.put(state, soln);
                if (soln.isEmpty()) goals.add(state);
            }
        }
        return new TextLookupTable(filename, map, goals);
    }

    @Override
    public String toString() {
        return "TextLookupTable[" + filename + ", " + entries.size()
            + " entries, " + goals.size() + " goals]";
    }
}
