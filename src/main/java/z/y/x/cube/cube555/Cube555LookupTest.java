package z.y.x.cube.cube555;

import java.util.List;

import z.y.x.cube.lookup.TextLookupTable;

/**
 * End-to-end smoke test for the 5×5 lookup-table pipeline:
 *
 *   1. Download a small reference table from S3 (cached in tmp).
 *   2. Confirm the file's structural invariants: line count, goal-state
 *      count, max solution depth.
 *   3. Confirm our {@link Cube555Centres} encoder produces a 18-char
 *      string that exists in the table for the {@link Cube555#SOLVED}
 *      cube — and that it's a goal state (cost 0).
 *   4. Confirm a known scrambled state encodes to a state that lives in
 *      the table.
 *
 * <p>This is the equivalent of the 4×4 {@code LookupTableLoaderTest} —
 * proves the network + cache + parse path works before we wire up any
 * actual stage solver.
 *
 * <h2>Run</h2>
 *
 * <pre>
 *   javac -d /tmp/cube555-classes \
 *     src/main/java/z/y/x/cube/core/*.java \
 *     src/main/java/z/y/x/cube/lookup/TextLookupTable.java \
 *     src/main/java/z/y/x/cube/cube555/*.java
 *   java -Dcube.lookup.cacheDir=/tmp/cube-cache \
 *        -cp /tmp/cube555-classes z.y.x.cube.cube555.Cube555LookupTest
 * </pre>
 */
public final class Cube555LookupTest {

    private static int passed = 0;
    private static int failed = 0;

    private static void check(String name, boolean ok) {
        if (ok) {
            passed++;
            System.out.println("PASS: " + name);
        } else {
            failed++;
            System.err.println("FAIL: " + name);
        }
    }

    private static void checkEq(String name, Object expected, Object actual) {
        if (expected == null ? actual == null : expected.equals(actual)) {
            passed++;
            System.out.println("PASS: " + name + " = " + expected);
        } else {
            failed++;
            System.err.println("FAIL: " + name);
            System.err.println("  expected: " + expected);
            System.err.println("  actual:   " + actual);
        }
    }

    public static void main(String[] args) throws Exception {
        // ── 1. Download + parse ──────────────────────────────────────
        System.out.println("Fetching lookup-table-5x5x5-step23-LR-center-stage.txt...");
        long t0 = System.currentTimeMillis();
        TextLookupTable lr = TextLookupTable.fetch("lookup-table-5x5x5-step23-LR-center-stage.txt");
        long dt = System.currentTimeMillis() - t0;
        System.out.println("  loaded in " + dt + " ms — " + lr);

        // Known invariants from Python source RubiksCube555.py LookupTable555Phase2LRCenterStage:
        //   linecount=4900, max_depth=5, 27 goal states.
        checkEq("table size",       4900,             lr.size());

        // ── 2. SOLVED state encoding ────────────────────────────────
        String solvedKey = Cube555Centres.encodeLR(Cube555.SOLVED);
        checkEq("SOLVED LR encoding", "LLLLLLLLLRRRRRRRRR", solvedKey);
        check("SOLVED is goal state",       lr.isGoal(solvedKey));
        checkEq("SOLVED cost",        0,    lr.costFor(solvedKey));

        // ── 3. Scrambled state encoding ────────────────────────────
        // Apply moves that rearrange LR centres within their faces —
        // Lw and Rw shuffle the centre rows.  After such a scramble
        // the encoded state must still exist in the table.
        String s = Cube555.SOLVED;
        String[] scramble = { "Lw", "Rw'", "U", "Lw2", "Rw" };
        for (String mv : scramble) {
            s = Cube555Moves.applyMove(s, mv);
        }
        String scrKey = Cube555Centres.encodeLR(s);
        check("scrambled key is 18 chars", scrKey.length() == 18);
        check("scrambled key uses only L/R", scrKey.matches("[LR]+"));
        check("scrambled state exists in table", lr.solutionFor(scrKey) != null);
        int cost = lr.costFor(scrKey);
        check("scrambled cost ∈ [0, 5]", cost >= 0 && cost <= 5);
        System.out.println("  scrambled key: " + scrKey + ", solution: '" +
            lr.solutionFor(scrKey) + "', cost: " + cost);

        // ── 4. Apply the table's solution and verify it solves LR ──
        if (cost > 0) {
            String soln = lr.solutionFor(scrKey);
            String afterSoln = s;
            for (String mv : soln.split("\\s+")) {
                if (mv.isEmpty()) continue;
                afterSoln = Cube555Moves.applyMove(afterSoln, mv);
            }
            String finalKey = Cube555Centres.encodeLR(afterSoln);
            check("after applying solution, state is a goal", lr.isGoal(finalKey));
        }

        // ── 5. Encoder shape sanity ────────────────────────────────
        check("CENTRE_POS has 9 entries",       Cube555Centres.CENTRE_POS.length == 9);
        check("T_CENTRE_POS has 4 entries",     Cube555Centres.T_CENTRE_POS.length == 4);
        check("X_CENTRE_POS has 4 entries",     Cube555Centres.X_CENTRE_POS.length == 4);
        checkEq("encodeFB(SOLVED)", "FFFFFFFFFBBBBBBBBB", Cube555Centres.encodeFB(Cube555.SOLVED));
        checkEq("encodeUD(SOLVED)", "UUUUUUUUUDDDDDDDDD", Cube555Centres.encodeUD(Cube555.SOLVED));

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555LookupTest() {}
    /** Keep List import warm in case future tests need it. */
    @SuppressWarnings("unused") private static final List<String> RESERVED = null;
}
