package z.y.x.cube.cube444.stage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube444.EdgesRecolor;

/**
 * End-to-end test for {@link FirstFourEdgesStage}.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/**.java
 *   java  -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *         -cp /tmp/cube-classes:src/main/resources \
 *         z.y.x.cube.cube444.stage.FirstFourEdgesStageTest
 *
 * On first run downloads the 66 MB step32 lookup table from S3 (largest
 * 4×4 table — takes a minute or two on a fast connection, ~500 MB
 * decompressed on disk).  Subsequent runs reuse the cached file.
 */
public final class FirstFourEdgesStageTest {

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else { fail++;
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
        System.out.println("Goal step32 key: " + FirstFourEdgesStage.GOAL);
        check("solved cube reports stage solved",
            FirstFourEdgesStage.isSolved(Cube444.SOLVED));
        check("LEGAL_MOVES has 20 entries",
            FirstFourEdgesStage.LEGAL_MOVES.size() == 20,
            "got " + FirstFourEdgesStage.LEGAL_MOVES.size());

        System.out.println("\nFetching step32 lookup table…");
        long t0 = System.currentTimeMillis();
        try {
            FirstFourEdgesStage.ensureReady();
        } catch (IOException ex) {
            System.err.println("  download failed: " + ex.getMessage());
            System.err.println("  (skipping solve tests)");
            System.out.println("\n" + pass + " passed, " + fail + " failed");
            System.exit(fail == 0 ? 0 : 1);
        }
        long dt = System.currentTimeMillis() - t0;
        System.out.println("  ready in " + dt + "ms");

        // Pipeline: scramble → centres-stage (UD+LR) → orientation → step32.
        long[] seeds = {1, 7, 42, 1729};
        for (long seed : seeds) {
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 30));

            List<String> udMoves = CentresStage.solveUDStage(scrambled);
            String s1 = Cube444Moves.applyMoves(scrambled, udMoves);
            List<String> lrMoves = CentresStage.solveLRStage(s1);
            String s2 = Cube444Moves.applyMoves(s1, lrMoves);

            EdgeOrientationStage.OrientationResult o = EdgeOrientationStage.solve(s2);
            String preStep32 = o.state;

            long et0 = System.currentTimeMillis();
            FirstFourEdgesStage.Result r;
            try {
                r = FirstFourEdgesStage.solve(preStep32);
            } catch (Exception ex) {
                check("seed " + seed + ": step32 solves", false, ex.getMessage());
                continue;
            }
            long et = System.currentTimeMillis() - et0;

            check("seed " + seed + ": step32 reaches goal",
                FirstFourEdgesStage.isSolved(r.state),
                "got " + EdgesRecolor.step32StateOf(r.state));
            check("seed " + seed + ": applyMoves(state, moves) matches reported state",
                Cube444Moves.applyMoves(preStep32, r.moves).equals(r.state));

            String tag = r.usedIda ? " (IDA*)" : " (direct)";
            System.out.println("  seed " + String.format("%4d", seed) + ": "
                + r.moves.size() + " moves" + tag + " in " + et + "ms");
        }

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private FirstFourEdgesStageTest() {}
}
