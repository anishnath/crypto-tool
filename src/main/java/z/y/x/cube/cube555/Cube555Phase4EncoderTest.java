package z.y.x.cube.cube555;

/**
 * Verifies {@link Cube555Phase4Encoder#encode} byte-equivalent to
 * Python's {@code LookupTable555Phase4.ida_heuristic} on three
 * deterministic 15-move scrambles with a fixed wing_strs choice.
 *
 * <p>Expected values pulled directly from running the Python solver:
 * <pre>
 *   seed=1  wing_strs=(LB,LF,RB,RF) → 0547a89f014108300e
 *   seed=7  wing_strs=(LB,LF,RB,RF) → cb8201020e4560618b
 *   seed=42 wing_strs=(LB,LF,RB,RF) → a0402c8510a2b46233
 * </pre>
 */
public final class Cube555Phase4EncoderTest {

    private static int passed = 0;
    private static int failed = 0;

    private static long lcg(long x) { return ((x * 1664525L) + 1013904223L) & 0xFFFFFFFFL; }

    private static String scramble(long seed, int n) {
        StringBuilder mv = new StringBuilder();
        long x = seed;
        for (int i = 0; i < n; i++) {
            x = lcg(x);
            int idx = (int) (x % Cube555Moves.ALL_MOVES.size());
            if (mv.length() > 0) mv.append(' ');
            mv.append(Cube555Moves.ALL_MOVES.get(idx));
        }
        return mv.toString();
    }

    private static void check(String name, String expected, String actual) {
        if (expected.equals(actual)) {
            passed++;
            System.out.println("PASS: " + name + " = " + actual);
        } else {
            failed++;
            System.err.println("FAIL: " + name);
            System.err.println("  expected: " + expected);
            System.err.println("  actual:   " + actual);
        }
    }

    public static void main(String[] args) {
        String[] wings = {"LB", "LF", "RB", "RF"};

        // Pre-flight: WINGS_FOR_PATTERN has 36 entries, EDGES_555 has 72.
        if (Cube555Phase4Encoder.WINGS_FOR_PATTERN.length == 36) passed++;
        else { failed++; System.err.println("FAIL: WINGS_FOR_PATTERN size != 36"); }
        if (Cube555Phase4Encoder.EDGES_555.length == 72) passed++;
        else { failed++; System.err.println("FAIL: EDGES_555 size != 72"); }

        // Three scrambles, each 15 moves, with fixed wing_strs.
        String s1 = Cube555Moves.applyMoves(Cube555.SOLVED, scramble(1, 15));
        check("seed=1 phase4 encoding", "0547a89f014108300e",
            Cube555Phase4Encoder.encode(s1, wings));

        String s7 = Cube555Moves.applyMoves(Cube555.SOLVED, scramble(7, 15));
        check("seed=7 phase4 encoding", "cb8201020e4560618b",
            Cube555Phase4Encoder.encode(s7, wings));

        String s42 = Cube555Moves.applyMoves(Cube555.SOLVED, scramble(42, 15));
        check("seed=42 phase4 encoding", "a0402c8510a2b46233",
            Cube555Phase4Encoder.encode(s42, wings));

        // SOLVED state should produce a "goal" encoding (the LB/LF/RB/RF
        // edges are in their solved positions, so all 8 wing stickers
        // for those edges + their midges should be 'L').  We don't
        // hardcode the exact value — just verify it's 18 hex chars.
        String solvedKey = Cube555Phase4Encoder.encode(Cube555.SOLVED, wings);
        if (solvedKey.length() == 18 && solvedKey.matches("[0-9a-f]{18}")) {
            passed++;
            System.out.println("PASS: SOLVED encoding has 18 hex chars: " + solvedKey);
        } else {
            failed++;
            System.err.println("FAIL: SOLVED encoding malformed: " + solvedKey);
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555Phase4EncoderTest() {}
}
