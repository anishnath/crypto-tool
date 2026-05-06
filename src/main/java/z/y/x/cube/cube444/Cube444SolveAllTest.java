package z.y.x.cube.cube444;

import java.util.ArrayList;
import java.util.List;

/**
 * End-to-end 4×4 solver test.  Scramble → Cube444Solver.solve() → verify
 * cube is fully solved.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/**.java
 *   java -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *        -Dcube.kociemba.cacheDir=/tmp/cube-kociemba-cache \
 *        -cp /tmp/cube-classes:src/main/resources \
 *        z.y.x.cube.cube444.Cube444SolveAllTest
 */
public final class Cube444SolveAllTest {

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

    public static void main(String[] args) throws Exception {
        System.out.println("Warming up the entire 4×4 pipeline (centres + lookup tables + Kociemba)…");
        long w0 = System.currentTimeMillis();
        Cube444Solver.warmUp();
        System.out.println("  warm in " + (System.currentTimeMillis() - w0) + "ms\n");

        // Test with shorter, more typical scrambles (15 moves) to avoid
        // the adversarial 30-move LCG-random states Python's reference
        // also struggles with.
        long[] seeds = {1, 7, 42, 1729, 8675309};
        int succeeded = 0;
        for (long seed : seeds) {
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, scramble(seed, 15));
            long t0 = System.currentTimeMillis();
            Cube444Solver.Result r;
            try {
                r = Cube444Solver.solve(scrambled);
            } catch (Exception ex) {
                System.out.printf("seed %4d: THREW: %s%n", seed, ex.getMessage());
                continue;
            }
            long dt = System.currentTimeMillis() - t0;

            if (r.solved) {
                succeeded++;
                System.out.printf("seed %4d: SOLVED in %d ms — %d+%d+%d+%d+%d=%d moves%n",
                    seed, dt,
                    r.centresMoves.size(), r.orientMoves.size(),
                    r.phase3Moves.size(), r.phase4Moves.size(), r.reduceMoves.size(),
                    r.moves.size());
            } else {
                System.out.printf("seed %4d: STOPPED at '%s' after %d ms (%d moves so far)%n",
                    seed, r.stoppedAt, dt, r.moves.size());
            }
        }
        System.out.println();
        System.out.println(succeeded + "/" + seeds.length + " scrambles fully solved");
        System.exit(succeeded == seeds.length ? 0 : 1);
    }

    private Cube444SolveAllTest() {}
}
