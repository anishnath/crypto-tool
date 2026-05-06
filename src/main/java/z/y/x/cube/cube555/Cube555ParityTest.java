package z.y.x.cube.cube555;

/**
 * Byte-equivalence verification: scramble Java's {@link Cube555} the same
 * way the Python+C reference (rubikscubennnsolver) would, and assert the
 * resulting state matches Python's output exactly.
 *
 * <p>This is the same defence used on the 4×4 port — every encoder, every
 * stage, every prune-table generator must agree byte-for-byte with the
 * reference, otherwise the ULFRBD↔URFDLB index trap silently corrupts
 * downstream search.  Catching divergence here is dramatically cheaper
 * than chasing a half-million-node IDA* false summit later.
 *
 * <h2>How the expected values were generated</h2>
 *
 * The Python script in {@code Cube555ParityTestNotes.md} (or rerun via
 * {@code python3} on the {@code rubikscubennnsolver} package) applies the
 * same LCG-driven scramble to {@code solved_555} via {@code swaps_555}
 * and translates the resulting ULFRBD-1-indexed string into Java URFDLB
 * 0-indexed form using:
 *
 * <pre>{@code
 * javaToPy(j) = j           if j ∈ [0, 25)    // U
 *             = j + 50      if j ∈ [25, 50)   // R ← Python R (offset 75)
 *             = j           if j ∈ [50, 75)   // F
 *             = j + 50      if j ∈ [75, 100)  // D ← Python D (offset 125)
 *             = j - 75      if j ∈ [100, 125) // L ← Python L (offset 25)
 *             = j - 25      if j ∈ [125, 150) // B ← Python B (offset 100)
 * }</pre>
 *
 * <h2>Run</h2>
 *
 * <pre>
 *   javac -d /tmp/cube555-classes \
 *     src/main/java/z/y/x/cube/core/*.java \
 *     src/main/java/z/y/x/cube/cube555/*.java
 *   java -cp /tmp/cube555-classes z.y.x.cube.cube555.Cube555ParityTest
 * </pre>
 */
public final class Cube555ParityTest {

    private static int passed = 0;
    private static int failed = 0;

    /** LCG matching Cube444SolveAllTest and the Python verification script. */
    private static long lcg(long x) { return ((x * 1664525L) + 1013904223L) & 0xFFFFFFFFL; }

    /** Reproduce Python's scramble: pick {@code n} moves from
     *  {@link Cube555Moves#ALL_MOVES} using the same LCG sequence. */
    private static String scrambleFor(long seed, int n) {
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

    private static void check(String label, String expected, String actual) {
        if (expected.equals(actual)) {
            passed++;
            System.out.println("PASS: " + label);
            return;
        }
        failed++;
        System.err.println("FAIL: " + label);
        System.err.println("  expected: " + expected);
        System.err.println("  actual:   " + actual);
        // Diff hint: first mismatch position.
        int n = Math.min(expected.length(), actual.length());
        for (int i = 0; i < n; i++) {
            if (expected.charAt(i) != actual.charAt(i)) {
                int faceIdx = i / 25;
                char face = "URFDLB".charAt(faceIdx);
                int facePos = i % 25;
                System.err.println("  first diff @ " + i + " (face " + face
                    + ", facePos " + facePos + "): expected '"
                    + expected.charAt(i) + "', got '" + actual.charAt(i) + "'");
                break;
            }
        }
    }

    public static void main(String[] args) {
        // ── Expected URFDLB outputs from Python's swaps_555-driven solver,
        //    pre-translated.  Don't edit by hand — regenerate via the
        //    Python script if move tables ever change.

        // seed=1, 30-move LCG scramble.
        check("seed 1 final state",
            "UUDDBUFURULFULUBDRFBLURFFDLRRRFUBLDBLRDFUDUBFRLRRUBBFULBFDLUBFFULLUDBLBLDLFLDBDDRUFDFLBDRBRBFFDURUDRFRULUDLLBRDLLRUFRRRUFFDBDDBFBLBDDLFLBBBRLUURRBFFDR",
            Cube555Moves.applyMoves(Cube555.SOLVED, scrambleFor(1, 30)));

        // seed=7, 30-move LCG scramble.
        check("seed 7 final state",
            "LLFFDURUBBURUDLFFFLUULRRRDBBRFUDBULFLRULFBLUUBBBFUFBBDFLRFLFRUFUDUUBRDURBDRBDUFDLDRFDFDDFDUFDDLFBULBDRLRLFFBUDDLLRUBBDBBRRLURLURFBDLBRRDFBRRLLLDDLBFRU",
            Cube555Moves.applyMoves(Cube555.SOLVED, scrambleFor(7, 30)));

        // seed=42, 30-move LCG scramble.
        check("seed 42 final state",
            "LDRFDDDDRBFLUDFFUFLURUDDUBRLURRFRRULRRDFDRUDFFLRLDFLLLRRBBBBBFFBBLFLDFBBBRUUURBLLLLUFLFDDUDRUFDDFDUBFRDDUDDRFFFFLLUFBBLBLRUBLFLDBDRLUBBUUBRRUUBUURLBRB",
            Cube555Moves.applyMoves(Cube555.SOLVED, scrambleFor(42, 30)));

        // Sanity: each individual move maps SOLVED to a state with the
        // right counts and the dead centres unchanged.  This catches
        // gross perm bugs that the round-trip tests in Cube555Test miss
        // (e.g. a move that accidentally swaps two stickers of the same
        // colour would still round-trip but be wrong).
        for (String mv : Cube555Moves.ALL_MOVES) {
            String afterMove = Cube555Moves.applyMove(Cube555.SOLVED, mv);
            // Sticker counts unchanged (every face still has 25).
            int[] counts = new int[256];
            for (int i = 0; i < afterMove.length(); i++) counts[afterMove.charAt(i)]++;
            boolean ok = true;
            for (char f : Cube555.FACES) ok &= counts[f] == 25;
            if (ok) {
                passed++;
            } else {
                failed++;
                System.err.println("FAIL: counts after " + mv);
            }
            // Dead centre never moves on 5×5.
            for (char f : Cube555.FACES) {
                int idx = Cube555.faceOffset(f) + Cube555.DEAD_CENTRE_POS;
                if (afterMove.charAt(idx) != f) {
                    failed++;
                    System.err.println("FAIL: dead centre " + f + " moved by " + mv);
                } else {
                    passed++;
                }
            }
        }

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555ParityTest() {}
}
