package z.y.x.cube.core;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Generic Iterative-Deepening A* search — Java port of the algorithmic
 * core of {@code ida_search_via_graph.c}.
 *
 * Caller provides:
 *   - the start state (whatever opaque cube-state object suits the stage)
 *   - {@link Domain#applyMove(Object, int)} — produce next state
 *   - {@link Domain#heuristic(Object)} — admissible lower bound on
 *     remaining moves; 0 means the state is a goal
 *   - {@link Domain#moveCount()} and {@link Domain#moveLabel(int)} —
 *     the legal-move set, indexed 0..n-1
 *   - {@link Domain#dontFollow(int)} — optional move-cancellation hints
 *
 * Returns a list of move labels leading from start to a goal state, or
 * {@code null} if the depth ceiling is exceeded.
 *
 * Memory: O(maxDepth) — pure recursion stack, no per-node heap.  This
 * is what lets a phase-4 IDA* search run at depth 13 without OOMing.
 */
public final class IdaSearch {

    public interface Domain<S> {
        S applyMove(S state, int moveIdx);
        int heuristic(S state);
        int moveCount();
        String moveLabel(int moveIdx);

        /** Move indices that should NOT immediately follow {@code prev}.
         *  Default: no pruning.  Stages should override to provide
         *  {@link MovePruning}-strength pruning. */
        default Set<Integer> dontFollow(int prev) { return null; }

        /** Stronger pruning hook: should the move {@code curr} be skipped
         *  given the immediately-preceding move was {@code prev}?  Called
         *  per-pair per-node; must be cheap.  Default delegates to
         *  {@link #dontFollow(int)} for backwards compat. */
        default boolean shouldSkip(int prev, int curr) {
            Set<Integer> s = dontFollow(prev);
            return s != null && s.contains(curr);
        }
    }

    /** Sentinel returned by the recursive helper when a goal is found.
     *  Chosen so it can never collide with a real f-value (which is
     *  non-negative). */
    private static final int FOUND = Integer.MIN_VALUE;

    private IdaSearch() {}

    /**
     * Search for a goal-reaching move sequence.  The IDA* threshold
     * starts at {@code heuristic(start)} and grows by the smallest
     * f-value above the previous threshold until either a goal is
     * found or the threshold exceeds {@code maxDepth}.
     */
    public static <S> List<String> find(S start, Domain<S> domain, int maxDepth) {
        int h0 = domain.heuristic(start);
        if (h0 == 0) return new ArrayList<>();          // already at goal
        if (h0 > maxDepth) return null;                 // unsolvable within ceiling

        int[] path = new int[maxDepth + 1];
        int threshold = h0;

        while (threshold <= maxDepth) {
            int next = recurse(start, domain, 0, threshold, -1, path);
            if (next == FOUND) {
                int len = path[maxDepth];               // we stash the depth in the sentinel slot
                List<String> out = new ArrayList<>(len);
                for (int i = 0; i < len; i++) out.add(domain.moveLabel(path[i]));
                return out;
            }
            if (next == Integer.MAX_VALUE) return null; // exhausted at this threshold
            if (next > maxDepth) return null;
            threshold = next;
        }
        return null;
    }

    private static <S> int recurse(S state, Domain<S> domain, int depth, int threshold,
                                   int lastMove, int[] path) {
        int h = domain.heuristic(state);
        int f = depth + h;
        if (f > threshold) return f;
        if (h == 0) {
            // Goal: write the depth into the sentinel slot at path[end] so
            // find() can recover it.  All real moves live at path[0..depth-1].
            path[path.length - 1] = depth;
            return FOUND;
        }

        int min = Integer.MAX_VALUE;
        int n = domain.moveCount();
        for (int m = 0; m < n; m++) {
            if (lastMove >= 0 && domain.shouldSkip(lastMove, m)) continue;
            S next = domain.applyMove(state, m);
            path[depth] = m;
            int r = recurse(next, domain, depth + 1, threshold, m, path);
            if (r == FOUND) return FOUND;
            if (r < min) min = r;
        }
        return min;
    }
}
