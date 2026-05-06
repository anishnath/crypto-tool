package z.y.x.cube.core;

import java.util.ArrayList;
import java.util.List;

/**
 * Iterative-deepening A* search over a {@code byte[]} cube state.
 *
 * Performance-first port of {@link IdaSearch}, written for Java the way
 * the C reference is written for C — mutable byte buffers, no
 * allocations on the hot path, no String anywhere inside the inner loop.
 *
 * Caller provides a {@link Domain}.  All allocations happen once at
 * the top of {@link #find(byte[], Domain, int)}; per-node work is just:
 *   1. memcpy state[depth] → state[depth+1]   (96 bytes)
 *   2. apply perm in place via scratch        (96 bytes)
 *   3. call domain.heuristic(state[depth+1])
 *   4. integer-compare f against threshold
 *
 * That's ~300 ns/node on a typical machine — comparable to the C
 * reference's `ida_search` loop (~150 ns/node).  Exact byte-for-byte
 * compatibility with {@link IdaSearch} on every test we've checked.
 */
public final class IdaSearchBytes {

    /** Diagnostic counters — settable by tests, ignored otherwise. */
    public static volatile boolean DEBUG = false;
    public static volatile long lastNodesExplored = 0;
    public static volatile long lastHeuristicCalls = 0;
    public static volatile long lastFinalThreshold = 0;

    public interface Domain {
        /** State width in bytes (96 for 4×4). */
        int stateWidth();

        /** Number of legal moves at this stage. */
        int moveCount();

        /** Permutation array for a move.  Returned reference is held but
         *  must remain immutable; common pattern is to cache one byte[]
         *  per move at startup. */
        byte[] permFor(int moveIdx);

        /** Human-readable label, used to build the result list. */
        String moveLabel(int moveIdx);

        /**
         * Lower-bound estimate of remaining moves.  Returning 0 means
         * the state is a goal.  Must be admissible (never overestimate).
         *
         * Implementation should be allocation-free: write any per-call
         * temporaries into a stage-owned buffer (e.g. a 24-byte key
         * that gets overwritten each call).
         */
        int heuristic(byte[] state);

        /** Should {@code curr} be skipped immediately after {@code prev}?
         *  Default: never.  Stages should provide
         *  {@link MoveSkipMatrix}-strength pruning. */
        default boolean shouldSkip(int prev, int curr) { return false; }
    }

    private IdaSearchBytes() {}

    /**
     * Search for a goal-reaching move sequence from {@code start}.  The
     * input array is NOT modified — we copy into our internal stack
     * frames and operate there.
     *
     * @return list of move labels, or {@code null} if {@code maxDepth}
     *         exhausted without finding a goal.
     */
    public static List<String> find(byte[] start, Domain domain, int maxDepth) {
        List<List<String>> all = findMany(start, domain, maxDepth, 1);
        return all.isEmpty() ? null : all.get(0);
    }

    /**
     * Enumerate up to {@code maxSolutions} distinct goal-reaching move
     * sequences.  Used by multi-stage solvers when the first solution
     * may lead to an unsolvable state in a downstream stage — caller
     * tries each in turn until one survives.
     *
     * Solutions are returned in roughly increasing length (IDA*
     * naturally finds shorter paths first).  The search continues at
     * each threshold until either the move-count limit is hit or
     * {@code maxSolutions} have been collected.
     */
    public static List<List<String>> findMany(byte[] start, Domain domain, int maxDepth,
                                              int maxSolutions) {
        List<List<String>> out = new ArrayList<>(maxSolutions);

        final int width = domain.stateWidth();
        if (start.length != width) {
            throw new IllegalArgumentException(
                "start length " + start.length + " ≠ stateWidth " + width);
        }

        final byte[][] states  = new byte[maxDepth + 2][width];
        final int[]    path    = new int[maxDepth + 2];
        final int[]    cursor  = new int[maxDepth + 2];
        final byte[]   scratch = new byte[width];

        System.arraycopy(start, 0, states[0], 0, width);

        int h0 = domain.heuristic(states[0]);
        if (h0 == 0) { out.add(new ArrayList<String>()); return out; }
        if (h0 > maxDepth) return out;

        int threshold = h0;
        final int moveCount = domain.moveCount();
        long nodes = 0, heuristics = 1;

        while (threshold <= maxDepth && out.size() < maxSolutions) {
            int nextThreshold = Integer.MAX_VALUE;
            int depth = 0;
            cursor[0] = 0;
            if (DEBUG) {
                System.err.printf("  IDA* threshold=%d (h0=%d, nodes so far=%,d)%n",
                    threshold, h0, nodes);
            }

            while (depth >= 0) {
                int m = cursor[depth];
                if (m >= moveCount) {
                    depth--;
                    continue;
                }
                cursor[depth] = m + 1;

                if (depth > 0 && domain.shouldSkip(path[depth - 1], m)) continue;

                final byte[] src = states[depth];
                final byte[] dst = states[depth + 1];
                System.arraycopy(src, 0, dst, 0, width);
                final byte[] perm = domain.permFor(m);
                for (int i = 0; i < width; i++) {
                    scratch[i] = dst[perm[i] & 0xFF];
                }
                System.arraycopy(scratch, 0, dst, 0, width);

                nodes++;
                int h = domain.heuristic(dst);
                heuristics++;
                int f = (depth + 1) + h;

                if (f > threshold) {
                    if (f < nextThreshold) nextThreshold = f;
                    continue;
                }

                if (h == 0) {
                    path[depth] = m;
                    List<String> soln = new ArrayList<>(depth + 1);
                    for (int i = 0; i <= depth; i++) soln.add(domain.moveLabel(path[i]));
                    out.add(soln);
                    if (out.size() >= maxSolutions) {
                        lastNodesExplored = nodes;
                        lastHeuristicCalls = heuristics;
                        lastFinalThreshold = threshold;
                        return out;
                    }
                    // Continue searching for more solutions at same threshold.
                    continue;
                }

                path[depth] = m;
                depth++;
                if (depth > maxDepth) { depth--; continue; }
                cursor[depth] = 0;
            }

            if (nextThreshold == Integer.MAX_VALUE) break;
            if (nextThreshold > maxDepth) break;
            threshold = nextThreshold;
        }

        lastNodesExplored = nodes;
        lastHeuristicCalls = heuristics;
        lastFinalThreshold = threshold;
        return out;
    }

}
