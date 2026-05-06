package z.y.x.cube.cube555;

/**
 * Verifies the phase 5 centre encoders byte-equivalent with Python's
 * {@code LookupTable555Phase5Centers.state} (step51) and
 * {@code LookupTable555Phase5FBCenters.state} (step56) on three
 * deterministic 15-move scrambles.
 */
public final class Cube555Phase5EncodersTest {

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
            System.out.println("PASS: " + name);
        } else {
            failed++;
            System.err.println("FAIL: " + name);
            System.err.println("  expected: " + expected);
            System.err.println("  actual:   " + actual);
        }
    }

    public static void main(String[] args) {
        if (Cube555Phase5Encoders.LFRB_CENTERS.length == 36) passed++;
        else { failed++; System.err.println("FAIL: LFRB_CENTERS size != 36"); }

        if (Cube555Phase5Encoders.FB_CENTERS.length == 18) passed++;
        else { failed++; System.err.println("FAIL: FB_CENTERS size != 18"); }

        // 3 scrambles × 2 encoders each.  Python ground truth from
        // RubiksCube555 with the corresponding phase 5 lookup tables'
        // state() method.
        String s1 = Cube555Moves.applyMoves(Cube555.SOLVED, scramble(1, 15));
        check("seed=1 LFRB36",  "DLUDLRDLRBBUDFFDFFLRRLRRRBLFUUFBUBBU",
            Cube555Phase5Encoders.encodeLFRBCenters(s1));
        check("seed=1 FB18",    "BBUDFFDFFFUUFBUBBU",
            Cube555Phase5Encoders.encodeFBCenters(s1));

        String s7 = Cube555Moves.applyMoves(Cube555.SOLVED, scramble(7, 15));
        check("seed=7 LFRB36",  "BLFBLFBLFRBDUFFULLFFFRRRBBBDBRDBRLLU",
            Cube555Phase5Encoders.encodeLFRBCenters(s7));
        check("seed=7 FB18",    "RBDUFFULLDBRDBRLLU",
            Cube555Phase5Encoders.encodeFBCenters(s7));

        String s42 = Cube555Moves.applyMoves(Cube555.SOLVED, scramble(42, 15));
        check("seed=42 LFRB36", "BBRFLUFRRLBUDFLULLRRFRRFFDDBFLUBBUFF",
            Cube555Phase5Encoders.encodeLFRBCenters(s42));
        check("seed=42 FB18",   "LBUDFLULLBFLUBBUFF",
            Cube555Phase5Encoders.encodeFBCenters(s42));

        // SOLVED → LFRB36 = 9 L's + 9 F's + 9 R's + 9 B's; FB18 = 9 F + 9 B.
        check("SOLVED LFRB36", "LLLLLLLLLFFFFFFFFFRRRRRRRRRBBBBBBBBB",
            Cube555Phase5Encoders.encodeLFRBCenters(Cube555.SOLVED));
        check("SOLVED FB18",   "FFFFFFFFFBBBBBBBBB",
            Cube555Phase5Encoders.encodeFBCenters(Cube555.SOLVED));

        // byte[] path matches String path
        byte[] bs = Cube555Bytes.fromString(s7);
        check("byte LFRB == string LFRB",
            Cube555Phase5Encoders.encodeLFRBCenters(s7),
            Cube555Phase5Encoders.encodeLFRBCentersBytes(bs));
        check("byte FB == string FB",
            Cube555Phase5Encoders.encodeFBCenters(s7),
            Cube555Phase5Encoders.encodeFBCentersBytes(bs));

        // ── High/Low edge encoders ──────────────────────────────────
        java.util.Set<String> defaultWings = Cube555EdgeRecolor.setOf("LB", "LF", "RB", "RF");

        // Python ground truth, default wing_strs (LB,LF,RB,RF).
        check("seed=1 high36",  "----pp---------tt--U--------------Z-",
            Cube555Phase5Encoders.encodeHighEdgeMidge(s1, defaultWings));
        check("seed=1 low36",   "----p----Z--P---tTuU------------UzZ-",
            Cube555Phase5Encoders.encodeLowEdgeMidge(s1, defaultWings));

        check("seed=7 high36",  "Uo---zQQ-----------U----------o---ZZ",
            Cube555Phase5Encoders.encodeHighEdgeMidge(s7, defaultWings));
        check("seed=7 low36",   "-o-----Qq----------U-------u----O-Z-",
            Cube555Phase5Encoders.encodeLowEdgeMidge(s7, defaultWings));

        check("seed=42 high36", "y---------------T----vv------V-y--ZZ",
            Cube555Phase5Encoders.encodeHighEdgeMidge(s42, defaultWings));
        check("seed=42 low36",  "--z------T------Tt----v---Y----y--Z-",
            Cube555Phase5Encoders.encodeLowEdgeMidge(s42, defaultWings));

        check("SOLVED high36", "-------------SSTT--UUVV-------------",
            Cube555Phase5Encoders.encodeHighEdgeMidge(Cube555.SOLVED, defaultWings));
        check("SOLVED low36",  "------------sS--TtuU--Vv------------",
            Cube555Phase5Encoders.encodeLowEdgeMidge(Cube555.SOLVED, defaultWings));

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    private Cube555Phase5EncodersTest() {}
}
