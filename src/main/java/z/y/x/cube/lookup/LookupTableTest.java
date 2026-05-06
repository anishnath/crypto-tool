package z.y.x.cube.lookup;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Standalone smoke test for the lookup-table loader + reader.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/lookup/*.java
 *   java  -cp /tmp/cube-classes z.y.x.cube.lookup.LookupTableTest
 *
 *   # To use a local cache outside ~/.cube-lookup-tables:
 *   java  -Dcube.lookup.cacheDir=/tmp/cube-lookup-cache \
 *         -cp /tmp/cube-classes z.y.x.cube.lookup.LookupTableTest
 *
 * Exercises:
 *   1. Fresh download + gunzip into the cache directory.
 *   2. Auto-detected record / state widths from the file.
 *   3. Binary-search lookup hits and misses.
 *   4. Cache reuse (second fetch is in-memory).
 *
 * Uses {@link LookupTableRegistry#CUBE444_FINE_CENTRES} (840 records,
 * 4.5 KB compressed) so the test runs fast and uses minimal disk.
 */
public final class LookupTableTest {

    private static int pass = 0, fail = 0;

    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else {
            fail++;
            System.err.println("  FAIL: " + name + (detail.isEmpty() ? "" : " (" + detail + ")"));
        }
    }
    private static void check(String name, boolean ok) { check(name, ok, ""); }

    public static void main(String[] args) throws IOException {
        // Use a temp dir so the test doesn't pollute ~/.cube-lookup-tables.
        Path tmp = Files.createTempDirectory("cube-lookup-test-");
        System.setProperty("cube.lookup.cacheDir", tmp.toString());
        System.out.println("Cache dir: " + tmp);

        String name = LookupTableRegistry.CUBE444_FINE_CENTRES;
        Path cached = LookupTableLoader.cachePath(name);
        check("not cached initially", !LookupTableLoader.isCached(name));

        long t0 = System.currentTimeMillis();
        LookupTable t = LookupTableLoader.fetch(name);
        long dt = System.currentTimeMillis() - t0;
        System.out.println("First fetch (download + gunzip + mmap): " + dt + "ms");
        System.out.println("  record count: " + t.recordCount());
        System.out.println("  record len  : " + t.recordLen() + " bytes");
        System.out.println("  state len   : " + t.stateLen() + " bytes");
        System.out.println("  on-disk size: " + Files.size(cached) + " bytes");

        check("on-disk file present after fetch", LookupTableLoader.isCached(name));
        check("record count > 0",  t.recordCount() > 0);
        check("step31 record count = 840", t.recordCount() == 840,
            "(got " + t.recordCount() + ")");
        // step31 stores 16-character cube-centre patterns (LLLL FFFF RRRR BBBB
        // condensed, the per-axis colour identity).
        check("step31 state width = 16", t.stateLen() == 16,
            "(got " + t.stateLen() + ")");

        // Goal pattern (the solved-centres state for step31) is in the
        // file with an empty solution.  From the inspection earlier:
        //   "LLLLBBBBRRRRFFFF:                 "
        String goal = "LLLLBBBBRRRRFFFF";
        String soln = t.lookup(goal);
        check("lookup(goal) returns non-null", soln != null,
            soln == null ? "null" : "got '" + soln + "'");
        check("lookup(goal) is empty (already solved)",
            soln != null && soln.isEmpty(),
            soln == null ? "null" : "got '" + soln + "'");

        // A non-goal entry observed in the inspection earlier:
        //   "LLLLBBBFRRRRFFFB:Lw2 F'"
        String near = "LLLLBBBFRRRRFFFB";
        String nearSoln = t.lookup(near);
        check("lookup(near) returns non-null", nearSoln != null,
            nearSoln == null ? "null" : "got '" + nearSoln + "'");
        check("lookup(near) is non-empty",
            nearSoln != null && !nearSoln.isEmpty(),
            nearSoln == null ? "null" : "got '" + nearSoln + "'");

        check("lookup(garbage) returns null",
            t.lookup("AAAAAAAAAAAAAAAA") == null);

        // Second fetch should hit the in-memory cache and be ~free.
        long t1 = System.nanoTime();
        LookupTable t2 = LookupTableLoader.fetch(name);
        long us = (System.nanoTime() - t1) / 1000;
        check("second fetch returns same instance", t2 == t);
        System.out.println("Second fetch (cache hit): " + us + "µs");

        // Lookup speed micro-benchmark.
        long lt0 = System.nanoTime();
        int hits = 0;
        for (int i = 0; i < 10_000; i++) {
            if (t.lookup(goal) != null) hits++;
        }
        long ltDt = System.nanoTime() - lt0;
        System.out.println("10000 lookups: " + (ltDt / 1_000_000) + "ms ("
            + (ltDt / 10_000) + "ns each), hits=" + hits);
        check("10000 lookups all hit", hits == 10_000);

        t.close();
        // (Don't delete the temp dir — useful for debugging if the test failed.)
        if (fail == 0) {
            try { recursiveDelete(tmp); } catch (IOException ignore) {}
        }

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private static void recursiveDelete(Path p) throws IOException {
        if (Files.isDirectory(p)) {
            try (java.util.stream.Stream<Path> ls = Files.list(p)) {
                ls.forEach(c -> {
                    try { recursiveDelete(c); } catch (IOException e) { /* ignore */ }
                });
            }
        }
        Files.deleteIfExists(p);
    }

    private LookupTableTest() {}
}
