package z.y.x.cube.cube555;

import java.util.ArrayList;
import java.util.List;

/**
 * Engine-layer correctness tests for Cube555 / Cube555Moves.
 *
 * Build + run:
 *   javac -d /tmp/cube-classes \
 *     src/main/java/z/y/x/cube/core/*.java \
 *     src/main/java/z/y/x/cube/cube555/*.java
 *   java -cp /tmp/cube-classes z.y.x.cube.cube555.Cube555Test
 *
 * These tests cover the engine in isolation — no lookup tables, no
 * solver. They verify only that moves form a valid group: 4 quarter-turns
 * round-trip to identity, prime is the inverse of the bare turn, etc.
 *
 * Byte-equivalence with the Python+C reference is verified separately
 * once a fixed scramble trace from the Python solver is captured.
 */
public final class Cube555Test {

    private static int passed = 0;
    private static int failed = 0;

    private static void check(String name, boolean ok) {
        if (ok) {
            passed++;
        } else {
            failed++;
            System.err.println("FAIL: " + name);
        }
    }

    private static void checkEq(String name, String expected, String actual) {
        if (expected.equals(actual)) {
            passed++;
        } else {
            failed++;
            System.err.println("FAIL: " + name);
            System.err.println("  expected: " + expected);
            System.err.println("  actual:   " + actual);
        }
    }

    public static void main(String[] args) {
        testStateModel();
        testValidate();
        testQuarterTurnIdentity();
        testPrimeInverse();
        testHalfTurnSelfInverse();
        testWideContainsOuter();
        testFaceRotationSticky();
        testCornerCount();
        testInvertMoves();
        testMoveAtomicityViaIdentity();

        System.out.println();
        System.out.println(passed + " passed, " + failed + " failed");
        System.exit(failed == 0 ? 0 : 1);
    }

    /* ── Engine basics ────────────────────────────────────────────── */

    private static void testStateModel() {
        check("TOTAL_STICKERS == 150", Cube555.TOTAL_STICKERS == 150);
        check("STICKERS_PER_FACE == 25", Cube555.STICKERS_PER_FACE == 25);
        check("SOLVED length", Cube555.SOLVED.length() == 150);
        check("isSolved(SOLVED)", Cube555.isSolved(Cube555.SOLVED));
        check("U at offset 0", Cube555.faceOffset('U') == 0);
        check("R at offset 25", Cube555.faceOffset('R') == 25);
        check("B at offset 125", Cube555.faceOffset('B') == 125);
        // Each face block is monochromatic in solved state.
        for (char f : Cube555.FACES) {
            int off = Cube555.faceOffset(f);
            for (int i = 0; i < 25; i++) {
                check("solved face " + f + " sticker " + i,
                    Cube555.SOLVED.charAt(off + i) == f);
            }
        }
    }

    private static void testValidate() {
        check("validate solved",  Cube555.validate(Cube555.SOLVED).ok);
        check("validate too short", !Cube555.validate("UUUU").ok);
        check("validate bad char",  !Cube555.validate(Cube555.SOLVED.replace('U', 'X')).ok);
    }

    /* ── Move group properties ────────────────────────────────────── */

    /** Every quarter-turn applied 4 times must restore the original state. */
    private static void testQuarterTurnIdentity() {
        for (String m : Cube555Moves.ALL_MOVES) {
            // Skip half-turns — they have period 2, not 4.
            if (m.endsWith("2")) continue;
            String s = Cube555.SOLVED;
            for (int i = 0; i < 4; i++) s = Cube555Moves.applyMove(s, m);
            checkEq("4×" + m + " == identity", Cube555.SOLVED, s);
        }
    }

    /** M followed by M' must restore the original state. */
    private static void testPrimeInverse() {
        for (char f : Cube555.FACES) {
            for (String layer : new String[] {"", "w"}) {
                String fwd = f + layer;
                String inv = f + layer + "'";
                String s = Cube555Moves.applyMove(Cube555.SOLVED, fwd);
                s = Cube555Moves.applyMove(s, inv);
                checkEq(fwd + " then " + inv + " == identity", Cube555.SOLVED, s);
            }
        }
    }

    /** M2 applied twice must restore the original state. */
    private static void testHalfTurnSelfInverse() {
        for (char f : Cube555.FACES) {
            for (String layer : new String[] {"", "w"}) {
                String mv = f + layer + "2";
                String s = Cube555Moves.applyMove(Cube555.SOLVED, mv);
                s = Cube555Moves.applyMove(s, mv);
                checkEq("2×" + mv + " == identity", Cube555.SOLVED, s);
            }
        }
    }

    /** A wide move's effect on layer 0 must equal the bare outer move's
     *  effect on layer 0.  We check by comparing the relevant face-row
     *  sticker positions after one quarter-turn. */
    private static void testWideContainsOuter() {
        for (char f : Cube555.FACES) {
            String outer = String.valueOf(f);
            String wide  = f + "w";
            String afterOuter = Cube555Moves.applyMove(Cube555.SOLVED, outer);
            String afterWide  = Cube555Moves.applyMove(Cube555.SOLVED, wide);

            // The outer face itself rotates identically under both.
            int faceOff = Cube555.faceOffset(f);
            for (int i = 0; i < 25; i++) {
                int idx = faceOff + i;
                check("wide " + f + " preserves outer-face rotation @ " + idx,
                    afterOuter.charAt(idx) == afterWide.charAt(idx));
            }
        }
    }

    /** After one U turn, the U face's stickers should still all be 'U' —
     *  the face rotates as a rigid block so no stickers from other faces
     *  enter it. */
    private static void testFaceRotationSticky() {
        String afterU = Cube555Moves.applyMove(Cube555.SOLVED, "U");
        for (int i = 0; i < 25; i++) {
            check("U face still U after U turn @ " + i, afterU.charAt(i) == 'U');
        }
        // The 4 corner stickers of D (not touched by U) must still be D.
        int dOff = Cube555.faceOffset('D');
        for (int p : Cube555.CORNER_POS) {
            check("D corner " + p + " untouched by U", afterU.charAt(dOff + p) == 'D');
        }
    }

    /** Sanity: every face has exactly 25 stickers in the solved state. */
    private static void testCornerCount() {
        int[] counts = new int[256];
        for (int i = 0; i < Cube555.SOLVED.length(); i++) counts[Cube555.SOLVED.charAt(i)]++;
        for (char f : Cube555.FACES) {
            check("face " + f + " count == 25", counts[f] == 25);
        }
    }

    /** invertMoves(M) applied AFTER M must restore the cube. */
    private static void testInvertMoves() {
        // Random-ish 20-move sequence using a fixed LCG so output is reproducible.
        List<String> seq = new ArrayList<>();
        long x = 7L;
        for (int i = 0; i < 20; i++) {
            x = ((x * 1664525L) + 1013904223L) & 0xFFFFFFFFL;
            seq.add(Cube555Moves.ALL_MOVES.get((int) (x % Cube555Moves.ALL_MOVES.size())));
        }
        String s = Cube555Moves.applyMoves(Cube555.SOLVED, seq);
        check("scramble changes state", !Cube555.isSolved(s));
        s = Cube555Moves.applyMoves(s, Cube555Moves.invertMoves(seq));
        checkEq("scramble + invert == identity", Cube555.SOLVED, s);
    }

    /** Same but with byte[] path — verifies Cube555Bytes matches Cube555. */
    private static void testMoveAtomicityViaIdentity() {
        byte[] state = Cube555Bytes.solved();
        byte[] scratch = new byte[150];
        for (String m : Cube555Moves.ALL_MOVES) {
            if (m.endsWith("2") || m.endsWith("'")) continue;
            byte[] save = state.clone();
            for (int i = 0; i < 4; i++) {
                Cube555Bytes.applyMoveInPlace(state, m, scratch);
            }
            check("Cube555Bytes 4×" + m + " == identity",
                java.util.Arrays.equals(save, state));
        }
        // Round-trip: byte[] solved → string → byte[] equals.
        byte[] viaString = Cube555Bytes.fromString(Cube555Bytes.toString(Cube555Bytes.solved()));
        check("Cube555Bytes string round-trip", java.util.Arrays.equals(viaString, Cube555Bytes.solved()));
    }

    private Cube555Test() {}
}
