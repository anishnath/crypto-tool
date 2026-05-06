package z.y.x.cube.lookup;

/**
 * Canonical filenames of the rubikscubennnsolver lookup tables we use.
 *
 * Splitting this out keeps the magic strings in one place and lets the
 * stage solvers stay agnostic about hosting / URL layout — they go
 * through {@link LookupTableLoader#fetch(String)} which uses these
 * names verbatim.
 *
 * Sizes given are compressed (.txt.gz) on the reference S3 bucket —
 * useful when budgeting cache disk.
 *
 *   4×4 set total ≈ 115 MB compressed (~500 MB – 1 GB decompressed).
 *
 * To mirror onto your own CDN: copy these files from
 * {@code https://rubiks-cube-lookup-tables.s3.amazonaws.com/<name>.gz}
 * and set {@code -Dcube.lookup.baseUrl=https://yourcdn/...}.
 */
public final class LookupTableRegistry {

    private LookupTableRegistry() {}

    /* ─── 4×4 ──────────────────────────────────────────────────── */

    /** UD-centres staging.  We already build this in-memory via BFS, so
     *  this constant is provided for parity with the reference solver
     *  but isn't required by our pipeline. */
    public static final String CUBE444_UD_CENTRES_STAGE =
        "lookup-table-4x4x4-step11-UD-centers-stage.txt";          // 5.9 MB

    public static final String CUBE444_LR_CENTRES_STAGE =
        "lookup-table-4x4x4-step12-LR-centers-stage.txt";          // 5.9 MB

    /** Edge orientation (high/low) — combined with step22 below. */
    public static final String CUBE444_HIGHLOW_EDGES_EDGES =
        "lookup-table-4x4x4-step21-highlow-edges-edges.txt";        // 30 MB

    public static final String CUBE444_HIGHLOW_EDGES_CENTRES =
        "lookup-table-4x4x4-step22-highlow-edges-centers.txt";      // 6.7 MB

    /** Pair the first 4 dedges. */
    public static final String CUBE444_FIRST_FOUR_EDGES =
        "lookup-table-4x4x4-step32-first-four-edges.txt";           // 66 MB ← biggest

    /** Pair the last 8 dedges. */
    public static final String CUBE444_LAST_EIGHT_EDGES =
        "lookup-table-4x4x4-step42-last-eight-edges.txt";           // 232 KB

    public static final String CUBE444_FINE_CENTRES =
        "lookup-table-4x4x4-step31-centers.txt";                    // 4.5 KB

    /** Step41 — full centres state used as a phase-4 prune table. */
    public static final String CUBE444_PHASE4_CENTRES =
        "lookup-table-4x4x4-step41-centers.txt";                    // 16 KB
}
