package z.y.x.cube.lookup;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.zip.GZIPInputStream;

/**
 * Lazy loader / cache for {@link LookupTable} files.
 *
 *   LookupTable t = LookupTableLoader.fetch("lookup-table-4x4x4-step42-last-eight-edges.txt");
 *
 * On first call:
 *   1. Check the cache directory for a decompressed copy.
 *   2. If absent, download {@code <baseUrl>/<name>.gz}, gunzip, and write
 *      it atomically into the cache directory.
 *   3. Open it as a {@link LookupTable} and remember in memory.
 *
 * Subsequent calls return the same instance without disk or network I/O.
 *
 * ─── Configuration ────────────────────────────────────────────────────
 *
 *   System property              Default
 *   cube.lookup.baseUrl          https://rubiks-cube-lookup-tables.s3.amazonaws.com/
 *   cube.lookup.cacheDir         ${user.home}/.cube-lookup-tables/
 *
 * Both can be overridden in {@code catalina.properties}, JAVA_OPTS, or
 * a servlet init parameter (read once at first {@code fetch()}).
 *
 * Mirror your own copy on a CDN you control by overriding {@code baseUrl}.
 * The reference data is a one-time copy of the Python solver's S3 bucket
 * — content is stable.
 */
public final class LookupTableLoader {

    private static final String DEFAULT_BASE_URL =
        "https://rubiks-cube-lookup-tables.s3.amazonaws.com/";

    private static final String DEFAULT_CACHE_DIR =
        Paths.get(System.getProperty("user.home", "/tmp"), ".cube-lookup-tables").toString();

    private static final ConcurrentMap<String, LookupTable> CACHE = new ConcurrentHashMap<>();

    private LookupTableLoader() {}

    private static String baseUrl() {
        String v = System.getProperty("cube.lookup.baseUrl");
        if (v == null || v.isEmpty()) v = DEFAULT_BASE_URL;
        return v.endsWith("/") ? v : v + "/";
    }

    private static Path cacheDir() {
        String v = System.getProperty("cube.lookup.cacheDir");
        if (v == null || v.isEmpty()) v = DEFAULT_CACHE_DIR;
        return Paths.get(v);
    }

    /** Path where the decompressed {@code name} would live in the cache. */
    public static Path cachePath(String name) {
        return cacheDir().resolve(name);
    }

    /** True iff the decompressed table is already on disk. */
    public static boolean isCached(String name) {
        Path p = cachePath(name);
        try { return Files.size(p) > 0; }
        catch (IOException e) { return false; }
    }

    /**
     * Resolve a lookup table by name.  Downloads + decompresses on first
     * call if needed.  Thread-safe — concurrent fetches of the same name
     * collapse to a single download.
     */
    public static LookupTable fetch(String name) throws IOException {
        LookupTable cached = CACHE.get(name);
        if (cached != null) return cached;

        synchronized (LookupTableLoader.class) {
            cached = CACHE.get(name);
            if (cached != null) return cached;

            Path target = cachePath(name);
            if (!Files.exists(target)) {
                downloadAndDecompress(name, target);
            }
            LookupTable t = LookupTable.open(target);
            CACHE.put(name, t);
            return t;
        }
    }

    /**
     * Fetch a state-indexed binary lookup table — both the {@code .bin}
     * and the {@code .state_index} file, downloaded and decompressed
     * if not yet cached.  Returns the opened {@link BinLookupTable}.
     *
     * @param baseName  filename without {@code .bin} suffix, e.g.
     *                  {@code "lookup-table-4x4x4-step41-centers"}.
     * @param moveCount number of legal moves in the .bin's row layout.
     */
    public static BinLookupTable fetchBin(String baseName, int moveCount) throws IOException {
        BinLookupTable cached = BIN_CACHE.get(baseName);
        if (cached != null) return cached;

        synchronized (LookupTableLoader.class) {
            cached = BIN_CACHE.get(baseName);
            if (cached != null) return cached;

            String binName = baseName + ".bin";
            String idxName = baseName + ".state_index";
            Path binPath = cachePath(binName);
            Path idxPath = cachePath(idxName);

            if (!Files.exists(binPath)) downloadAndDecompress(binName, binPath);
            if (!Files.exists(idxPath)) downloadAndDecompress(idxName, idxPath);

            BinLookupTable t = BinLookupTable.open(binPath, idxPath, moveCount);
            BIN_CACHE.put(baseName, t);
            return t;
        }
    }

    private static final ConcurrentMap<String, BinLookupTable> BIN_CACHE = new ConcurrentHashMap<>();

    /** Force a re-download (e.g. after a cache corruption).  Closes the
     *  in-memory handle if one exists. */
    public static void invalidate(String name) throws IOException {
        synchronized (LookupTableLoader.class) {
            LookupTable t = CACHE.remove(name);
            if (t != null) t.close();
            Path p = cachePath(name);
            Files.deleteIfExists(p);
        }
    }

    /* ─────────────────────────────────────────────────────────────────
     *  Download + decompress
     * ──────────────────────────────────────────────────────────────── */

    private static void downloadAndDecompress(String name, Path target) throws IOException {
        Files.createDirectories(target.getParent());

        String url = baseUrl() + name + ".gz";
        Path tmp = target.resolveSibling(target.getFileName().toString() + ".part");

        URL u = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) u.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(15_000);
        conn.setReadTimeout(120_000);
        conn.setRequestProperty("Accept-Encoding", "identity");  // we'll gunzip ourselves
        conn.setInstanceFollowRedirects(true);

        int code = conn.getResponseCode();
        if (code != 200) {
            String msg = code + " " + conn.getResponseMessage();
            try (InputStream errBody = conn.getErrorStream()) {
                // best-effort drain
                if (errBody != null) {
                    byte[] buf = new byte[1024]; while (errBody.read(buf) > 0) { /* ignore */ }
                }
            }
            throw new IOException("download " + url + " failed: " + msg);
        }

        try (InputStream in = conn.getInputStream();
             GZIPInputStream gz = new GZIPInputStream(in);
             OutputStream out = Files.newOutputStream(tmp)) {
            byte[] buf = new byte[64 * 1024];
            int n;
            while ((n = gz.read(buf)) > 0) out.write(buf, 0, n);
        } catch (IOException ex) {
            try { Files.deleteIfExists(tmp); } catch (IOException ignore) {}
            throw ex;
        }

        // Atomic rename only after full success.
        Files.move(tmp, target,
            StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);
    }
}
