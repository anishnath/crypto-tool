package z.y.x.cube.lookup;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Mmap-based binary-search reader for fixed-width sorted text lookup
 * tables — used for Python+C reference tables that ship as plain
 * {@code .txt.gz} (no {@code .bin} mirror).
 *
 * <p>Specifically built for {@code lookup-table-5x5x5-step40-phase4.txt}
 * but generic for any table whose lines are:
 *
 * <pre>
 *   &lt;fixed-width key&gt;:&lt;padded solution moves&gt;\n
 * </pre>
 *
 * with all lines exactly the same byte width and the file sorted by key.
 *
 * <h2>Why this shape</h2>
 *
 * <p>step40 has 32M entries and the .bin/.state_index mirror doesn't
 * exist on S3.  A naive {@code HashMap<String,Integer>} would burn
 * 4+ GB heap.  Binary search on a mmap'd 960 MB text file uses O(1)
 * heap + O(log₂ 32M) = ~25 page reads per lookup (most served from
 * page cache after warm-up).
 *
 * <h2>Usage</h2>
 *
 * <pre>
 *   BinarySearchedTextTable t = BinarySearchedTextTable.fetch(
 *       "lookup-table-5x5x5-step40-phase4.txt", 18);
 *   int cost = t.costFor("0547a89f014108300e");
 *   //   returns the count of moves in the solution, or t.maxCostMiss() if absent
 * </pre>
 */
public final class BinarySearchedTextTable {

    /** Decompressed file backing this table. */
    private final Path file;
    /** Bytes per line (key + ':' + padded solution + '\n'). */
    public final int lineWidth;
    /** Number of bytes in the key (= the search prefix). */
    public final int keyWidth;
    /** Total number of lines in the file. */
    public final int lineCount;
    /** Cost returned for keys not found in the table — defaults to a large
     *  sentinel; callers should set this to {@code maxDepth + 1} for
     *  Python-compatible heuristics. */
    public final int missCost;

    private final MappedByteBuffer mmap;
    private final RandomAccessFile raf;

    private BinarySearchedTextTable(Path file, MappedByteBuffer mmap,
                                    RandomAccessFile raf,
                                    int lineWidth, int keyWidth,
                                    int lineCount, int missCost) {
        this.file = file;
        this.mmap = mmap;
        this.raf = raf;
        this.lineWidth = lineWidth;
        this.keyWidth = keyWidth;
        this.lineCount = lineCount;
        this.missCost = missCost;
    }

    /**
     * Open and mmap the cached decompressed table.
     *
     * @param fileName  e.g. {@code "lookup-table-5x5x5-step40-phase4.txt"}.
     * @param keyWidth  number of bytes in the key prefix (e.g. 18 for an
     *                  18-hex-char encoder).
     * @param missCost  cost returned by {@link #costFor(String)} when the
     *                  key isn't in the table — typically
     *                  {@code maxDepth + 1} for IDA* heuristics.
     */
    public static BinarySearchedTextTable fetch(String fileName, int keyWidth, int missCost)
            throws IOException {
        Path target = LookupTableLoader.cachePath(fileName);
        if (!Files.exists(target)) {
            // Reuse LookupTableLoader's package-private downloader by
            // doing a one-off LookupTable.fetch() which performs the
            // download as a side effect; we don't actually use the
            // returned in-memory representation.
            // (Keeps caching + atomic-rename behaviour consistent with
            // the rest of the lookup infrastructure.)
            try {
                LookupTableLoader.fetch(fileName);
            } catch (Exception ex) {
                // It's possible LookupTable can't open this file because
                // its TextLookupTable would explode on 32M entries.  If
                // the file exists on disk after the download, that's all
                // we need.
                if (!Files.exists(target)) throw ex;
            }
        }
        return open(target, keyWidth, missCost);
    }

    /**
     * Open an already-decompressed file by absolute path.  Does the
     * line-width detection from the first line.
     */
    public static BinarySearchedTextTable open(Path file, int keyWidth, int missCost)
            throws IOException {
        long size = Files.size(file);
        if (size == 0) throw new IOException("empty table file: " + file);

        RandomAccessFile raf = new RandomAccessFile(file.toFile(), "r");
        try {
            // Detect line width from the first line: read enough bytes to
            // find the first '\n', then lineWidth is offset+1.
            byte[] head = new byte[4096];
            int n = raf.read(head, 0, Math.min(head.length, (int) Math.min(size, head.length)));
            int newline = -1;
            for (int i = 0; i < n; i++) if (head[i] == '\n') { newline = i; break; }
            if (newline < 0) {
                throw new IOException("no newline in first " + n + " bytes of " + file);
            }
            int lineWidth = newline + 1;
            if (size % lineWidth != 0) {
                throw new IOException("file size " + size + " not a multiple of line width "
                    + lineWidth + " for " + file);
            }
            int lineCount = (int) (size / lineWidth);

            // Mmap the entire file read-only.  On 64-bit JVMs this is fine
            // even for 1 GB+ files — the OS pages it in lazily.
            FileChannel ch = raf.getChannel();
            MappedByteBuffer mmap = ch.map(FileChannel.MapMode.READ_ONLY, 0, size);
            return new BinarySearchedTextTable(file, mmap, raf, lineWidth, keyWidth,
                                                lineCount, missCost);
        } catch (IOException ex) {
            raf.close();
            throw ex;
        }
    }

    /**
     * Look up the cost for a key (= number of space-separated tokens in
     * the line's solution field).  Returns {@link #missCost} if not
     * found.  O(log₂ lineCount) page accesses.
     */
    public int costFor(String key) {
        if (key.length() != keyWidth) {
            throw new IllegalArgumentException(
                "key length " + key.length() + " ≠ keyWidth " + keyWidth);
        }
        // Convert key to ASCII bytes once, outside the hot loop.
        byte[] keyBytes = new byte[keyWidth];
        for (int i = 0; i < keyWidth; i++) keyBytes[i] = (byte) key.charAt(i);

        int lo = 0, hi = lineCount - 1;
        while (lo <= hi) {
            int mid = (lo + hi) >>> 1;
            int cmp = compareLineKeyAt(mid, keyBytes);
            if (cmp == 0) return countSolutionTokens(mid);
            if (cmp < 0) lo = mid + 1;
            else         hi = mid - 1;
        }
        return missCost;
    }

    /** True iff the key is in the table (regardless of cost). */
    public boolean contains(String key) {
        if (key.length() != keyWidth) return false;
        byte[] keyBytes = new byte[keyWidth];
        for (int i = 0; i < keyWidth; i++) keyBytes[i] = (byte) key.charAt(i);
        int lo = 0, hi = lineCount - 1;
        while (lo <= hi) {
            int mid = (lo + hi) >>> 1;
            int cmp = compareLineKeyAt(mid, keyBytes);
            if (cmp == 0) return true;
            if (cmp < 0) lo = mid + 1;
            else         hi = mid - 1;
        }
        return false;
    }

    /** Read the solution field of line {@code idx} as a {@code String}. */
    public String solutionAt(int idx) {
        int base = idx * lineWidth + keyWidth + 1;     // skip key + ':'
        int end = idx * lineWidth + lineWidth - 1;     // before '\n'
        int len = end - base;
        byte[] buf = new byte[len];
        for (int i = 0; i < len; i++) buf[i] = mmap.get(base + i);
        return new String(buf, java.nio.charset.StandardCharsets.US_ASCII).trim();
    }

    public Path file() { return file; }

    public void close() throws IOException { raf.close(); }

    /* ── helpers ─────────────────────────────────────────────────── */

    /**
     * Compare {@code keyBytes} to the key prefix of line {@code idx}.
     * Returns negative if line's key &lt; keyBytes, 0 if equal, positive
     * if line's key &gt; keyBytes.  (Note inverted sign vs. the
     * standard memcmp convention because callers want "is target
     * AFTER mid".)
     */
    private int compareLineKeyAt(int idx, byte[] keyBytes) {
        int base = idx * lineWidth;
        for (int i = 0; i < keyWidth; i++) {
            int a = mmap.get(base + i) & 0xFF;
            int b = keyBytes[i] & 0xFF;
            if (a < b) return -1;
            if (a > b) return 1;
        }
        return 0;
    }

    /**
     * Count the space-separated tokens in line {@code idx}'s solution
     * field (between the ':' at offset keyWidth and the trailing
     * newline).  Empty (all-spaces) → 0.
     */
    private int countSolutionTokens(int idx) {
        int base = idx * lineWidth + keyWidth + 1;     // skip key + ':'
        int end  = idx * lineWidth + lineWidth - 1;    // before '\n'
        int n = 0;
        boolean inTok = false;
        for (int i = base; i < end; i++) {
            byte b = mmap.get(i);
            boolean ws = (b == ' ' || b == '\t');
            if (!ws && !inTok) { n++; inTok = true; }
            else if (ws) inTok = false;
        }
        return n;
    }
}
