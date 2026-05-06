package z.y.x.cube.lookup;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;
import java.nio.file.Path;

/**
 * Sorted-fixed-width lookup table — read-only, mmap-backed binary search.
 *
 * The reference Python solver stores its 4×4/5×5/… lookup tables as
 * {@code state:solution\n} records padded with spaces to a constant
 * record size, sorted lexicographically by {@code state}.  This class
 * mmaps such a file and answers {@link #lookup(String)} via classic
 * binary search — a few hundred ns per query, near-zero RSS impact.
 *
 * Construction expects a decompressed file (see {@link LookupTableLoader}
 * for the download / gunzip path).  The record size is auto-detected
 * from the first line; the state width is auto-detected from the colon
 * position.
 *
 * Thread-safety: instances are immutable after construction and safe to
 * share across servlet threads.  {@link #close()} releases the mmap.
 */
public final class LookupTable implements AutoCloseable {

    private final Path path;
    private final RandomAccessFile raf;
    private final FileChannel channel;
    private final MappedByteBuffer buf;

    private final long fileLen;
    private final int recordLen;     // bytes per record incl. trailing '\n'
    private final int stateLen;      // bytes before the ':' separator
    private final long recordCount;

    /** Open a decompressed lookup-table file for binary-search reads. */
    public static LookupTable open(Path path) throws IOException {
        return new LookupTable(path);
    }

    private LookupTable(Path path) throws IOException {
        this.path = path;
        this.raf = new RandomAccessFile(path.toFile(), "r");
        this.channel = raf.getChannel();
        this.fileLen = channel.size();
        if (fileLen <= 0) {
            channel.close(); raf.close();
            throw new IOException("empty lookup table: " + path);
        }
        // mmap can't span more than 2 GiB in a single buffer.  4×4 tables
        // top out around 1 GiB decompressed, so this is fine here; the
        // multi-GiB guard belongs to whatever 7×7 wiring lands later.
        if (fileLen > Integer.MAX_VALUE) {
            channel.close(); raf.close();
            throw new IOException(
                "table too large to mmap in one segment: " + path
                + " (" + fileLen + " bytes)");
        }
        this.buf = channel.map(MapMode.READ_ONLY, 0, fileLen);

        // Auto-detect record / state widths from the first line.
        int rl = 0;
        for (int i = 0; i < fileLen && i < 4096; i++) {
            if (buf.get(i) == (byte) '\n') { rl = i + 1; break; }
        }
        if (rl == 0) {
            close();
            throw new IOException("no newline found in first 4 KB of " + path);
        }
        this.recordLen = rl;

        int sl = -1;
        for (int i = 0; i < rl; i++) {
            if (buf.get(i) == (byte) ':') { sl = i; break; }
        }
        if (sl < 0) {
            close();
            throw new IOException("no ':' separator in first record of " + path);
        }
        this.stateLen = sl;

        if (fileLen % recordLen != 0) {
            // Not strictly an error — some sources write a partial trailing
            // record — but flag it for diagnostics.
            System.err.println(
                "warning: lookup table " + path
                + " size " + fileLen + " is not a multiple of record size "
                + recordLen + " — last partial record will be ignored");
        }
        this.recordCount = fileLen / recordLen;
    }

    public long recordCount() { return recordCount; }
    public int  recordLen()   { return recordLen;   }
    public int  stateLen()    { return stateLen;    }

    /** Allocation-free lookup: searches for {@code key} (which must be
     *  exactly {@link #stateLen()} bytes); returns the SOLUTION LENGTH
     *  in moves (= space-count + 1) when found, or -1 when missing.
     *
     *  Used by IDA*'s heuristic where we only need the integer cost,
     *  not the solution string.  This is the heuristic hot-path —
     *  zero allocations, all primitive int work. */
    public int lookupDistance(byte[] key) {
        if (key.length != stateLen) {
            throw new IllegalArgumentException(
                "key length " + key.length + " ≠ table state length " + stateLen);
        }
        long lo = 0, hi = recordCount - 1;
        while (lo <= hi) {
            long mid = (lo + hi) >>> 1;
            int cmp = compareBytesAt(mid, key);
            if (cmp == 0) {
                // Count moves in the solution: spaces+1 (or 0 if empty).
                long base = mid * recordLen;
                int start = (int) base + stateLen + 1;     // skip ':'
                int end   = (int) base + recordLen - 1;    // strip '\n'
                while (end > start && buf.get(end - 1) == (byte) ' ') end--;
                if (end <= start) return 0;                // empty solution → goal
                int spaces = 0;
                for (int i = start; i < end; i++) {
                    if (buf.get(i) == (byte) ' ') spaces++;
                }
                return spaces + 1;
            }
            if (cmp < 0) lo = mid + 1;
            else         hi = mid - 1;
        }
        return -1;
    }

    /** Byte-buffer comparison — same as {@link #compareAt(long, byte[])}
     *  but for a byte-array key directly. */
    private int compareBytesAt(long recIdx, byte[] needle) {
        long base = recIdx * recordLen;
        for (int i = 0; i < stateLen; i++) {
            int a = buf.get((int) (base + i)) & 0xFF;
            int b = needle[i] & 0xFF;
            if (a != b) return a - b;
        }
        return 0;
    }

    /**
     * Look up the solution string for {@code state}.  Returns null if
     * not present.  The returned string is the trimmed solution (trailing
     * spaces stripped, no newline).
     *
     * State must be exactly {@link #stateLen()} bytes (ASCII) — pass the
     * canonical compressed-state representation produced by the relevant
     * stage.
     */
    public String lookup(String state) {
        byte[] needle = state.getBytes(java.nio.charset.StandardCharsets.US_ASCII);
        if (needle.length != stateLen) {
            throw new IllegalArgumentException(
                "lookup key length " + needle.length
                + " ≠ table state length " + stateLen);
        }
        long lo = 0, hi = recordCount - 1;
        while (lo <= hi) {
            long mid = (lo + hi) >>> 1;
            int cmp = compareAt(mid, needle);
            if (cmp == 0) return readSolution(mid);
            if (cmp < 0) lo = mid + 1;
            else         hi = mid - 1;
        }
        return null;
    }

    /** Compare the state portion of record {@code recIdx} with {@code needle}. */
    private int compareAt(long recIdx, byte[] needle) {
        long base = recIdx * recordLen;
        for (int i = 0; i < stateLen; i++) {
            int a = buf.get((int) (base + i)) & 0xFF;
            int b = needle[i] & 0xFF;
            if (a != b) return a - b;
        }
        return 0;
    }

    /** Read the trimmed solution string from record {@code recIdx}. */
    private String readSolution(long recIdx) {
        long base = recIdx * recordLen;
        // Solution starts after stateLen + 1 (skip the ':') and runs to
        // the trailing '\n' minus any padding spaces.
        int start = (int) base + stateLen + 1;
        int end = (int) base + recordLen - 1;     // strip '\n'
        // Trim trailing spaces.
        while (end > start && buf.get(end - 1) == (byte) ' ') end--;
        if (end <= start) return "";
        byte[] out = new byte[end - start];
        for (int i = 0; i < out.length; i++) out[i] = buf.get(start + i);
        return new String(out, java.nio.charset.StandardCharsets.US_ASCII);
    }

    @Override
    public void close() throws IOException {
        try { channel.close(); } finally { raf.close(); }
    }

    @Override
    public String toString() {
        return "LookupTable[" + path
            + " recs=" + recordCount + " recLen=" + recordLen
            + " stateLen=" + stateLen + "]";
    }
}
