package z.y.x.cube.cube444.stage;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube444.HighLowEdges;

/**
 * End-to-end test: scramble → centres → edge orientation.
 *
 *   javac -d /tmp/cube-classes \
 *       src/main/java/z/y/x/cube/core/*.java \
 *       src/main/java/z/y/x/cube/cube444/*.java \
 *       src/main/java/z/y/x/cube/cube444/stage/*.java \
 *       src/main/java/z/y/x/cube/lookup/*.java
 *   java -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *        -cp /tmp/cube-classes:src/main/resources \
 *        z.y.x.cube.cube444.stage.EdgeOrientationStageTest
 *
 * On first run this downloads the 30 MB step21 lookup table from S3
 * (or the configured {@code -Dcube.lookup.baseUrl}) — takes 30-60 s.
 * Subsequent runs use the cached file (~1 s startup).
 *
 * Verifies that for several random scrambles, the orientation stage
 * produces a state whose {@code highlow_edges_state} equals the
 * solved-cube goal pattern.  This is the same correctness criterion
 * Python's phase-2 enforces.
 */
public final class EdgeOrientationStageTest {

    private static int pass = 0, fail = 0;

    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else {
            fail++;
            System.err.println("  FAIL: " + name);
            if (!detail.isEmpty()) System.err.println("        " + detail);
        }
    }

    private static void check(String name, boolean ok) { check(name, ok, ""); }

    private static long lcg(long x) { return ((x * 1664525L) + 1013904223L) & 0xFFFFFFFFL; }
    private static List<String> scramble(long seed, int n) {
        List<String> out = new ArrayList<>(n);
        long x = seed;
        for (int i = 0; i < n; i++) {
            x = lcg(x);
            int idx = (int) ((x >>> 0) % Cube444Moves.ALL_MOVES.size());
            out.add(Cube444Moves.ALL_MOVES.get(idx));
        }
        return out;
    }

    public static void main(String[] args) throws IOException {
        System.out.println("Goal orientation: " + EdgeOrientationStage.GOAL);
        check("GOAL constant matches HighLowEdges.stateOf(SOLVED)",
            EdgeOrientationStage.GOAL.equals(HighLowEdges.stateOf(Cube444.SOLVED)),
            "GOAL=" + EdgeOrientationStage.GOAL);

        check("solved cube reports orientation solved",
            EdgeOrientationStage.isOrientationSolved(Cube444.SOLVED));

        check("LEGAL_MOVES has 28 entries (Python phase2 illegal-move count)",
            EdgeOrientationStage.LEGAL_MOVES.size() == 28,
            "got " + EdgeOrientationStage.LEGAL_MOVES.size());

        // Loading the step21 table downloads ~30 MB on first run.
        System.out.println("\nFetching step21 lookup table…");
        long t0 = System.currentTimeMillis();
        try {
            EdgeOrientationStage.ensureReady();
        } catch (IOException ex) {
            System.err.println("  download failed: " + ex.getMessage());
            System.err.println("  (skipping orient-from-scramble tests)");
            System.out.println("\n" + pass + " passed, " + fail + " failed");
            System.exit(fail == 0 ? 0 : 1);
        }
        long dt = System.currentTimeMillis() - t0;
        System.out.println("  ready in " + dt + "ms");
        check("step21 table loaded", EdgeOrientationStage.isReady());

        // For each scramble, run centres-staging (UD + LR only — NOT fine,
        // because phase2 expects to be able to reshuffle centres within
        // axes), then orientation, then verify orientation reached goal.
        long[] seeds = {1, 7, 42, 1729};
        for (long seed : seeds) {
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 30));

            // UD + LR staging only — skip fine.  phase2's allowed move set
            // (Lw/Rw included) deliberately reshuffles centres within axes,
            // so doing fine here would just be undone.
            List<String> udMoves = CentresStage.solveUDStage(scrambled);
            String s1 = Cube444Moves.applyMoves(scrambled, udMoves);
            List<String> lrMoves = CentresStage.solveLRStage(s1);
            String c_state = Cube444Moves.applyMoves(s1, lrMoves);

            // Sanity: axes are staged but fine isn't required.
            if (CentresStage.udStateOf(c_state) != CentresStage.udStateOf(Cube444.SOLVED)
             || CentresStage.lrStateOf(c_state) != CentresStage.lrStateOf(Cube444.SOLVED)) {
                check("seed " + seed + ": axes staged before phase2", false, "");
                continue;
            }
            // Use a placeholder result-style object so the rest of the test
            // body keeps reading naturally.
            final String preState = c_state;

            // Edge orientation.
            long et0 = System.currentTimeMillis();
            EdgeOrientationStage.OrientationResult r = EdgeOrientationStage.solve(preState);
            long et = System.currentTimeMillis() - et0;

            check("seed " + seed + ": orientation reaches goal",
                EdgeOrientationStage.isOrientationSolved(r.state),
                "got " + HighLowEdges.stateOf(r.state));
            check("seed " + seed + ": applyMoves(state, moves) matches reported state",
                Cube444Moves.applyMoves(preState, r.moves).equals(r.state));

            String tag = r.usedIda ? " (IDA*)" : " (direct)";
            System.out.println("  seed " + String.format("%4d", seed) + ": "
                + r.moves.size() + " moves" + tag + " in " + et + "ms");
        }

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private EdgeOrientationStageTest() {}
}
