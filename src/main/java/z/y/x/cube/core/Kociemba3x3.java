package z.y.x.cube.core;

import java.util.List;

/**
 * Pluggable 3×3 solver interface — used at the end of the 4×4 / 5×5 /
 * 6×6 / 7×7 pipelines after reduction.
 *
 * Implementations to consider, in order of preference:
 *
 *   1. **Embedded Kociemba port** (e.g., a Java port of {@code min2phase}).
 *      Self-contained, ~1500 LOC, takes a few seconds to warm prune
 *      tables on first call.  No external deps — drop a class into
 *      this package, point at it.
 *
 *   2. **Maven dep**: {@code cs.min2phase} on Maven Central provides a
 *      well-tested Java implementation.  Add to pom.xml then write a
 *      thin adapter that forwards {@link #solve(String)} to its
 *      {@code Tools.solve()}.
 *
 *   3. **Subprocess to an external solver** (cubejs CLI, Kociemba C
 *      binary).  Last resort — adds a runtime dep and shell-out cost.
 *
 * The 4×4 solver pipeline calls {@link #solve(String)} exactly once at
 * the end, after centres + edges + parity stages produce a fully-reduced
 * cube.  If no implementation has been registered, the pipeline returns
 * the reduced state with empty solution moves and a clear error message
 * — useful state for "ship Java pipeline now, wire Kociemba later".
 */
public interface Kociemba3x3 {

    /**
     * Solve a 54-character 3×3 state.  State convention: 9 stickers per
     * face in URFDLB face order (Kociemba's standard input format).
     *
     * @return list of moves (e.g. {@code ["R", "U2", "F'"]}) that solve
     *         the state.  Empty list if already solved.  Never null.
     * @throws Exception if state is unsolvable or implementation fails.
     */
    List<String> solve(String state54) throws Exception;

    /** Name of this implementation, for diagnostics. */
    default String implName() { return getClass().getSimpleName(); }

    /**
     * Static registry — call {@link #set(Kociemba3x3)} once at boot
     * (e.g. from a servlet's {@code init()}) and the cube pipelines
     * pick it up via {@link #get()}.
     */
    final class Registry {
        private Registry() {}
        private static volatile Kociemba3x3 IMPL = null;
        public static void set(Kociemba3x3 impl) { IMPL = impl; }
        public static Kociemba3x3 get() { return IMPL; }
        public static boolean isRegistered() { return IMPL != null; }
    }

    static void set(Kociemba3x3 impl) { Registry.set(impl); }
    static Kociemba3x3 get()           { return Registry.get(); }
    static boolean isRegistered()      { return Registry.isRegistered(); }
}
