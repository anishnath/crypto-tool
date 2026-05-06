package z.y.x.cube.core;

import java.util.List;

/**
 * Precomputed N×N matrix of {@link MovePruning#shouldSkip(Move, Move)}
 * results for a given move list.  Lets {@link IdaSearch.Domain#shouldSkip}
 * answer in O(1) per call instead of re-running the predicates.
 *
 * Build once per stage at startup; reuse across every IDA* call.
 */
public final class MoveSkipMatrix {

    private final boolean[][] skip;
    private final int n;

    public MoveSkipMatrix(List<String> moveLabels) {
        this.n = moveLabels.size();
        this.skip = new boolean[n][n];
        Move[] parsed = new Move[n];
        for (int i = 0; i < n; i++) parsed[i] = Move.parse(moveLabels.get(i));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                skip[i][j] = MovePruning.shouldSkip(parsed[i], parsed[j]);
            }
        }
    }

    public boolean shouldSkip(int prev, int curr) {
        return prev >= 0 && skip[prev][curr];
    }

    public int size() { return n; }
}
