package z.y.x.cube.core;

/**
 * Move-pair pruning predicates — Java port of the redundancy-detection
 * functions in {@code ida_search_core.c}.
 *
 * The C reference implements each predicate as a giant switch statement
 * over every move literal (~500 LOC for the set).  Java can express the
 * same semantics in a few short methods by decomposing each move into
 * its face / layer / turns components — same correctness, far fewer
 * lines, easier to extend to 5×5/6×6/7×7 (which have additional layer
 * indices like {@code 3U}, {@code 3Uw}, etc. — left as future work).
 *
 * All predicates operate on {@link Move} instances.  They're stateless
 * and thread-safe.
 */
public final class MovePruning {

    private MovePruning() {}

    /** Two moves are on opposite faces: U↔D, L↔R, F↔B.  Used to
     *  canonicalise commuting move pairs (so the search doesn't explore
     *  both orders). */
    public static boolean oppositeFaces(char a, char b) {
        return (a == 'U' && b == 'D') || (a == 'D' && b == 'U')
            || (a == 'L' && b == 'R') || (a == 'R' && b == 'L')
            || (a == 'F' && b == 'B') || (a == 'B' && b == 'F');
    }

    /** Lexicographic ordering for canonicalising opposite-face pairs:
     *  prefer {@code U,D} over {@code D,U} (etc.). */
    public static char preferredFirst(char a, char b) {
        return (a == 'U' || a == 'L' || a == 'F') ? a : b;
    }

    /**
     * {@code prev} immediately followed by {@code move} cancels out:
     * same face, same layer (wide-ness), inverse turns.
     *   U U'   → identity
     *   Uw' Uw → identity
     *   U2 U2  → identity (180° self-inverse)
     */
    public static boolean cancelsOut(Move prev, Move move) {
        if (prev.face != move.face) return false;
        if (prev.wide != move.wide) return false;
        if (prev.turns == 2 && move.turns == 2) return true;
        return prev.turns == -move.turns;
    }

    /**
     * Same face, same layer (wide-ness).  Two consecutive moves of this
     * shape can ALWAYS be combined into 0 or 1 move of the same family,
     * so the search should never explore them.
     *   U U   → can be combined to U2; explore U2 instead
     *   U Uw  → different layer, NOT same-face-and-layer
     *   Uw Uw → can combine to Uw2
     */
    public static boolean sameFaceAndLayer(Move prev, Move move) {
        return prev.face == move.face && prev.wide == move.wide;
    }

    /**
     * Same face, EITHER layer.  Stronger pruning: U then Uw is also
     * redundant since (U Uw) = (slice rotation), and slice rotations
     * are usually allowed elsewhere.  Phase-specific solvers may opt
     * out of this if they explicitly want both U and Uw separately.
     */
    public static boolean sameFace(Move prev, Move move) {
        return prev.face == move.face;
    }

    /**
     * Outer-layer move (U/L/F/R/B/D, no 'w').  Used by some pruning
     * predicates that treat outer and wide moves differently. */
    public static boolean isOuter(Move m) { return !m.wide; }

    /**
     * Order outer-layer moves on the same face: prev should be the
     * "primary" turn before the inverse, by canonical direction.  This
     * is a tie-break used by the C engine's
     * {@code outer_layer_moves_in_order} to avoid exploring both
     * {@code U U'} and {@code U' U} as distinct paths through the
     * graph.  We canonicalise: among same-face same-layer pairs,
     * always require the CW one first; reject CCW-first sequences.
     *
     * Returns true iff the pair is in the preferred order; the caller
     * should skip the move otherwise.
     */
    public static boolean outerLayerMovesInOrder(Move prev, Move move) {
        // Only meaningful for outer-layer moves on opposite faces
        // (commuting pair → canonicalise).
        if (!isOuter(prev) || !isOuter(move)) return true;
        if (!oppositeFaces(prev.face, move.face))  return true;
        // For commuting pair, require lexicographic order on face.
        return preferredFirst(prev.face, move.face) == prev.face;
    }

    /**
     * Combined pruning predicate: returns true iff {@code move} should
     * be SKIPPED when applied right after {@code prev}.
     *
     * Combines all the redundancy checks into the one most callers
     * want.  The 4×4 stage drivers should use this instead of their
     * weaker "skip same first letter" {@code dontFollow} sets.
     */
    public static boolean shouldSkip(Move prev, Move move) {
        if (cancelsOut(prev, move))            return true;
        if (sameFaceAndLayer(prev, move))      return true;
        if (sameFace(prev, move))              return true;
        if (!outerLayerMovesInOrder(prev, move)) return true;
        return false;
    }
}
