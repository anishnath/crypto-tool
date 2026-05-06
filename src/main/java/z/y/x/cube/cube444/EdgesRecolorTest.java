package z.y.x.cube.cube444;

/**
 * Parity test for {@link EdgesRecolor#step32StateOf(String)}.
 *
 *   javac -d /tmp/cube-classes \
 *       src/main/java/z/y/x/cube/core/*.java \
 *       src/main/java/z/y/x/cube/cube444/*.java
 *   java -cp /tmp/cube-classes z.y.x.cube.cube444.EdgesRecolorTest
 *
 * Compares Java output against the Python {@code edges_recolor_pattern_444}
 * + {@code wings_444} pipeline on 4 random scrambles plus the solved cube.
 */
public final class EdgesRecolorTest {

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else { fail++;
            System.err.println("  FAIL: " + name);
            System.err.println("        " + detail);
        }
    }

    /** {Java state (96 ch), expected step42 key (24 ch)}. */
    private static final String[][] STEP42_CASES = {
        { "UUDBUFRUBDFBLUFFDLRRFULDUDBFRLRUBBULBFLULUBLBLLFLDDDRUDFRBFDURDRFRLUDLBRFRRUFFBDDBBLBDLFLURRBFDR",
          "6d3-2-0cn--e7b1-hg---ml8" },
        { "LLFDURBBFFLUULRRDBRFUDULFBUUBBFUFBDFLRLFUURDURDRBDFDLDFDUFDLFBLBDRRLFFUDBBBBRRURLUFBDLRRLLDDLBRU",
          "-ck--b-g-jd51h9i7ef2a---" },
        { "LDFDDDRBFULURUDUBRURRFRUDRDFFLLDFLLRRBBBLFDFBBRUUUBLLLUFDRFDDFUBFRDUDDFFFBLBLRBLFLBDRLBBUUUURLRB",
          "8-kegdnl0f---45a3--2-7-6" },
        { "RDDRRLDDLUBBLRLFLUFULLFURRLRUDFBFDFUFDFBRLFDDUBBFLULBDDBUBRUUBFDBFDDBFBURUUFRLLRFFLDRURDBBRULLRB",
          "43-01he-jdl--6a-k5-g89--" },
        { Cube444.SOLVED, "10425376--------hgkiljnm" },
    };

    /** {Java state (96 ch), expected step32 key (24 ch)}. */
    private static final String[][] CASES = {
        // seed=1 (30 LCG moves)
        { "UUDBUFRUBDFBLUFFDLRRFULDUDBFRLRUBBULBFLULUBLBLLFLDDDRUDFRBFDURDRFRLUDLBRFRRUFFBDDBBLBDLFLURRBFDR",
          "---5-4---ki----j--9af---" },
        // seed=7
        { "LLFDURBBFFLUULRRDBRFUDULFBUUBBFUFBDFLRLFUURDURDRBDFDLDFDUFDLFBLBDRRLFFUDBBBBRRURLUFBDLRRLLDDLBRU",
          "l--8m-n-4------------036" },
        // seed=42
        { "LDFDDDRBFULURUDUBRURRFRUDRDFFLLDFLLRRBBBLFDFBBRUUUBLLLUFDRFDDFUBFRDUDDFFFBLBLRBLFLBDRLBBUUUURLRB",
          "-j--------mih----cb-1-9-" },
        // seed=1729
        { "RDDRRLDDLUBBLRLFLUFULLFURRLRUDFBFDFUFDFBRLFDDUBBFLULBDDBUBRUUBFDBFDDBFBURUUFRLLRFFLDRURDBBRULLRB",
          "--b----n---2i--m--c---f7" },
        // solved cube — this is also Python's documented step32 state_targets value
        { Cube444.SOLVED, "--------a8b9ecfd--------" },
    };

    public static void main(String[] args) {
        for (int i = 0; i < CASES.length; i++) {
            String state = CASES[i][0];
            String want  = CASES[i][1];
            String got   = EdgesRecolor.step32StateOf(state);
            check("step32[" + i + "] matches Python",
                want.equals(got),
                "expected " + want + "\n        got      " + got);
        }
        for (int i = 0; i < STEP42_CASES.length; i++) {
            String state = STEP42_CASES[i][0];
            String want  = STEP42_CASES[i][1];
            String got   = EdgesRecolor.step42StateOf(state);
            check("step42[" + i + "] matches Python",
                want.equals(got),
                "expected " + want + "\n        got      " + got);
        }
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private EdgesRecolorTest() {}
}
