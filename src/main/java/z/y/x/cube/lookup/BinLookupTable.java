package z.y.x.cube.lookup;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.MappedByteBuffer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

/**
 * State-indexed lookup table — Java port of the {@code .bin} format the
 * reference C engine uses.
 *
 * Each prune table comes as TWO files:
 *
 *   {@code <name>.state_index}  — text, lines of {@code <state>:<index>}.
 *      Loaded into a HashMap once.  Used to convert the start cube
 *      state into an integer state ID (one-time cost per IDA* call).
 *
 *   {@code <name>.bin}          — binary, fixed-width rows.  Each row
 *      encodes the cost-to-goal of one state PLUS, for each legal move,
 *      the next-state ID and that next state's cost-to-goal.
 *
 *      Row layout ({@code ROW_LENGTH = 1 + (4+1)*moveCount}):
 *        offset 0:               1 byte  — cost-to-goal of THIS state
 *        offset 1+5*m+0..3:      4 bytes — next state ID after move m
 *        offset 1+5*m+4:         1 byte  — cost-to-goal of that next state
 *
 *      Multibytes are little-endian (matches the C compiler's native
 *      layout on x86_64 / arm64).
 *
 * Why this is fast: the IDA* hot loop becomes pure byte reads.  No
 * applyMove (the next-state IDs are precomputed), no encoder (we never
 * convert an ID back to a state string during search), no String, no
 * allocation.  This is what brings Java to within ~2× of the C engine.
 */
public final class BinLookupTable {

    public static final int COST_LEN  = 1;
    public static final int STATE_LEN = 4;

    /** Bytes per row in the {@code .bin} file. */
    public final int rowLength;
    /** Number of legal moves this table was built for. */
    public final int moveCount;
    /** Number of states in the table. */
    public final int stateCount;

    private final MappedByteBuffer bin;
    private final Map<String, Integer> stateIndex;
    private final java.io.RandomAccessFile binFile;

    private BinLookupTable(MappedByteBuffer bin,
                           java.io.RandomAccessFile binFile,
                           Map<String, Integer> stateIndex,
                           int rowLength,
                           int moveCount,
                           int stateCount) {
        this.bin = bin;
        this.binFile = binFile;
        this.stateIndex = stateIndex;
        this.rowLength = rowLength;
        this.moveCount = moveCount;
        this.stateCount = stateCount;
    }

    /**
     * Open a state-indexed lookup table.
     *
     * @param binPath          path to the decompressed {@code .bin} file
     * @param stateIndexPath   path to the decompressed {@code .state_index}
     * @param moveCount        number of legal moves in the .bin's row layout
     */
    public static BinLookupTable open(Path binPath, Path stateIndexPath, int moveCount)
            throws IOException {
        int rowLen = COST_LEN + (STATE_LEN + COST_LEN) * moveCount;
        long binSize = Files.size(binPath);
        if (binSize % rowLen != 0) {
            throw new IOException(
                "bin file " + binPath + " size " + binSize
                + " not a multiple of expected row length " + rowLen);
        }
        int stateCount = (int) (binSize / rowLen);

        java.io.RandomAccessFile raf = new java.io.RandomAccessFile(binPath.toFile(), "r");
        java.nio.channels.FileChannel ch = raf.getChannel();
        MappedByteBuffer mmap = ch.map(java.nio.channels.FileChannel.MapMode.READ_ONLY, 0, binSize);
        mmap.order(java.nio.ByteOrder.LITTLE_ENDIAN);

        // Load state_index file into a HashMap.
        Map<String, Integer> idx = new HashMap<>(stateCount * 2);
        try (BufferedReader r = Files.newBufferedReader(stateIndexPath, StandardCharsets.US_ASCII)) {
            String line;
            while ((line = r.readLine()) != null) {
                if (line.isEmpty()) continue;
                int colon = line.indexOf(':');
                if (colon < 0) continue;
                String state = line.substring(0, colon);
                // Trim trailing whitespace from the index part (.state_index
                // files are padded to fixed width with spaces).
                String idxStr = line.substring(colon + 1).trim();
                if (idxStr.isEmpty()) continue;
                idx.put(state.trim(), Integer.parseInt(idxStr));
            }
        }

        return new BinLookupTable(mmap, raf, idx, rowLen, moveCount, stateCount);
    }

    /** Resolve a state encoding to its integer ID, or -1 if not in table. */
    public int indexOf(String state) {
        Integer i = stateIndex.get(state);
        return i == null ? -1 : i;
    }

    /** Cost-to-goal of the state at {@code stateIdx}.  O(1) byte read. */
    public int costAt(int stateIdx) {
        return bin.get(stateIdx * rowLength) & 0xFF;
    }

    /** Next-state ID after applying {@code moveIdx} from state {@code stateIdx}. */
    public int nextStateAt(int stateIdx, int moveIdx) {
        int off = stateIdx * rowLength + COST_LEN + (STATE_LEN + COST_LEN) * moveIdx;
        return bin.getInt(off);
    }

    /** Cost-to-goal of the next state (combined read with {@link #nextStateAt}). */
    public int nextCostAt(int stateIdx, int moveIdx) {
        int off = stateIdx * rowLength + COST_LEN + (STATE_LEN + COST_LEN) * moveIdx + STATE_LEN;
        return bin.get(off) & 0xFF;
    }

    /** Sticker count for diagnostics. */
    public int loadedStateIndexEntries() { return stateIndex.size(); }

    public void close() throws IOException { binFile.close(); }
}
