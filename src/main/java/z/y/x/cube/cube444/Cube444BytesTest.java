package z.y.x.cube.cube444;

import java.util.ArrayList;
import java.util.List;

/**
 * Verifies {@link Cube444Bytes} produces byte-equivalent results to the
 * String-based {@link Cube444Moves}, plus a microbenchmark showing the
 * actual per-move speedup.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/**.java
 *   java  -cp /tmp/cube-classes z.y.x.cube.cube444.Cube444BytesTest
 */
public final class Cube444BytesTest {

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok) {
        if (ok) pass++;
        else { fail++; System.err.println("  FAIL: " + name); }
    }

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

    public static void main(String[] args) {
        // ─── Round-trip: solved-state correctness ────────────────────
        byte[] solvedB = Cube444Bytes.solved();
        check("solved() length", solvedB.length == Cube444.TOTAL_STICKERS);
        check("solved() round-trips through String",
            Cube444.SOLVED.equals(Cube444Bytes.toString(solvedB)));
        check("fromString(SOLVED) byte-equal to solved()",
            java.util.Arrays.equals(Cube444Bytes.fromString(Cube444.SOLVED), solvedB));

        // ─── Equivalence on every base move ─────────────────────────
        byte[] scratch = new byte[Cube444.TOTAL_STICKERS];
        for (String m : Cube444Moves.ALL_MOVES) {
            String wantStr = Cube444Moves.applyMove(Cube444.SOLVED, m);
            byte[] gotBytes = Cube444Bytes.fromString(Cube444.SOLVED);
            Cube444Bytes.applyMoveInPlace(gotBytes, m, scratch);
            check("byte applyMove(" + m + ") == String applyMove",
                wantStr.equals(Cube444Bytes.toString(gotBytes)));
        }

        // ─── Equivalence on long random scrambles ───────────────────
        for (long seed : new long[] {1, 7, 42, 1729, 8675309}) {
            List<String> seq = scramble(seed, 80);

            String wantStr = Cube444Moves.applyMoves(Cube444.SOLVED, seq);

            byte[] gotBytes = Cube444Bytes.solved();
            for (String m : seq) Cube444Bytes.applyMoveInPlace(gotBytes, m, scratch);

            check("byte vs String, seed " + seed + ", 80 moves",
                wantStr.equals(Cube444Bytes.toString(gotBytes)));
        }

        // ─── Microbenchmark: byte[] applyMove vs String applyMove ──
        System.out.println("\n─ Microbenchmark ─");
        List<String> moves = scramble(42, 10_000);
        byte[][] perms = new byte[moves.size()][];
        for (int i = 0; i < moves.size(); i++) perms[i] = Cube444Moves.permFor(moves.get(i));

        // Warm up (let JIT compile the hot loop).
        runByteBench(perms, scratch, 200_000);
        runStringBench(moves, 50_000);

        long b0 = System.nanoTime();
        runByteBench(perms, scratch, 1_000_000);
        long byteNs = System.nanoTime() - b0;

        long s0 = System.nanoTime();
        runStringBench(moves, 200_000);
        long stringNs = System.nanoTime() - s0;
        // Scale up to 1M for fair comparison
        stringNs = stringNs * 5;

        double byteUsPerMove = byteNs / 1_000_000.0 / 1_000.0;
        double stringUsPerMove = stringNs / 1_000_000.0 / 1_000.0;

        System.out.printf("  byte[] applyMove: %,d ns/move  (~%.3f µs/move)%n",
            byteNs / 1_000_000, byteUsPerMove);
        System.out.printf("  String applyMove: %,d ns/move  (~%.3f µs/move)%n",
            stringNs / 1_000_000, stringUsPerMove);
        System.out.printf("  speedup: %.1fx faster%n", stringUsPerMove / byteUsPerMove);

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    /** Hot-path benchmark — mutate state in place, no allocation. */
    private static void runByteBench(byte[][] perms, byte[] scratch, int iterations) {
        byte[] state = Cube444Bytes.solved();
        int permIdx = 0;
        for (int i = 0; i < iterations; i++) {
            Cube444Bytes.applyPermInPlace(state, perms[permIdx], scratch);
            permIdx++;
            if (permIdx >= perms.length) permIdx = 0;
        }
    }

    /** Reference: same iterations, but using immutable String. */
    private static void runStringBench(List<String> moves, int iterations) {
        String state = Cube444.SOLVED;
        int idx = 0;
        for (int i = 0; i < iterations; i++) {
            state = Cube444Moves.applyMove(state, moves.get(idx));
            idx++;
            if (idx >= moves.size()) idx = 0;
        }
        // Prevent JIT from optimising the loop away.
        if (state.length() != 96) throw new AssertionError();
    }

    private Cube444BytesTest() {}
}
