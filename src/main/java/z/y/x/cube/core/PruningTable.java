package z.y.x.cube.core;

import java.util.ArrayList;
import java.util.List;

/**
 * BFS-built distance table for staged cube solving.
 *
 * State is a packed integer (up to 24 bits today, 32 in principle).
 * Each move is a {@link BitPerm} that maps an old state to a new state
 * by permuting bits (newBit[i] = oldBit[perm[i]]).
 *
 * The table records, for each reachable state, the minimum number of
 * moves needed to reach it from the goal.  An unreachable state is
 * marked with {@link #UNREACHED} (0xFF).
 *
 * Solving from a scrambled state walks the table down by trying every
 * move and following the one whose result has depth-1.  This is the
 * same shape used by every staged BFS in {@code js/rubiks4/solver/centers.js}.
 */
public final class PruningTable {

    public static final byte UNREACHED = (byte) 0xFF;

    /** Bit permutation: {@code newBits} <- old bit at perm[i] copied to bit i.
     *  perm.length is the state's bit count (16, 24, etc.).  Sizes <= 24
     *  fit comfortably in a JS or Java int. */
    public static final class BitPerm {
        public final byte[] perm;
        public final String label;     // for diagnostics / move-name lookup
        public BitPerm(byte[] perm, String label) {
            this.perm = perm;
            this.label = label;
        }
        public int apply(int bits) {
            int out = 0;
            for (int i = 0; i < perm.length; i++) {
                out |= ((bits >>> (perm[i] & 0xFF)) & 1) << i;
            }
            return out;
        }
    }

    public final byte[] table;            // length 1<<stateBits
    public final int stateBits;
    public final int goal;
    public final int reachableStates;
    public final int maxDepth;
    public final BitPerm[] perms;

    private PruningTable(byte[] table, int stateBits, int goal, int reachable, int maxDepth, BitPerm[] perms) {
        this.table = table;
        this.stateBits = stateBits;
        this.goal = goal;
        this.reachableStates = reachable;
        this.maxDepth = maxDepth;
        this.perms = perms;
    }

    /**
     * Build a pruning table by BFS from {@code goal}, expanding via
     * {@code perms}.  The table size is {@code 1 << stateBits} bytes.
     *
     * For 24-bit states this is 16 MB.  For 16-bit, 64 KB.  Caller is
     * responsible for ensuring the heap has room.
     */
    public static PruningTable build(int stateBits, int goal, BitPerm[] perms) {
        int size = 1 << stateBits;
        byte[] table = new byte[size];
        java.util.Arrays.fill(table, UNREACHED);
        table[goal] = 0;

        List<Integer> frontier = new ArrayList<>();
        frontier.add(goal);
        int depth = 0;
        int reachable = 1;

        while (!frontier.isEmpty()) {
            depth++;
            List<Integer> next = new ArrayList<>(Math.max(16, frontier.size()));
            for (int s : frontier) {
                for (int mi = 0; mi < perms.length; mi++) {
                    int t = perms[mi].apply(s);
                    if (table[t] == UNREACHED) {
                        table[t] = (byte) depth;
                        next.add(t);
                        reachable++;
                    }
                }
            }
            frontier = next;
        }
        return new PruningTable(table, stateBits, goal, reachable, depth - 1, perms);
    }

    /** True iff {@code state} is reachable from the goal (i.e. solvable). */
    public boolean isReachable(int state) {
        return (table[state] & 0xFF) != 0xFF;
    }

    /** Walk the table from {@code start} to {@code goal}, returning the
     *  list of move labels applied.  Throws if the table is inconsistent. */
    public List<String> descend(int start) {
        if (table[start] == UNREACHED) {
            throw new IllegalStateException(
                "state 0x" + Integer.toHexString(start) + " unreachable");
        }
        List<String> out = new ArrayList<>();
        int bits = start;
        while (bits != goal) {
            int target = (table[bits] & 0xFF) - 1;
            boolean found = false;
            for (BitPerm p : perms) {
                int cand = p.apply(bits);
                if ((table[cand] & 0xFF) == target) {
                    out.add(p.label);
                    bits = cand;
                    found = true;
                    break;
                }
            }
            if (!found) {
                throw new IllegalStateException(
                    "descent stuck at 0x" + Integer.toHexString(bits)
                    + " — table inconsistency");
            }
        }
        return out;
    }
}
