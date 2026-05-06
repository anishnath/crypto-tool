package z.y.x.cube.cube444;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import z.y.x.cube.core.Move;

/**
 * Standalone test runner for {@link Cube444} + {@link Cube444Moves}.
 *
 *   javac src/main/java/z/y/x/cube/core/*.java src/main/java/z/y/x/cube/cube444/*.java
 *   java  -cp src/main/java z.y.x.cube.cube444.Cube444Test
 *
 * Mirrors the assertions in {@code js/rubiks4/scratch-test.mjs}:
 *   1. Solved-state validation
 *   2. Move parser
 *   3. ALL_MOVES roster (36 entries, all unique, all parseable)
 *   4. Identity composition: M⁴ = I, M ∘ M' = I, M2 ∘ M2 = I
 *   5. M2 == M ∘ M
 *   6. Sticker-colour conservation under random scrambles
 *   7. Inverse round-trip on long scrambles
 *   8. Wide ≠ Outer for every face
 *   9. Centres preserved under outer-only-move sequences
 *
 * Plus one Java-specific check: parity with the JS module's known-good
 * "U" output state.  If anyone changes Cube444Moves' RING tables, this
 * comparison flags it instantly.
 */
public final class Cube444Test {

    private static int pass = 0, fail = 0;

    private static void check(String name, boolean ok, String detail) {
        if (ok) pass++;
        else {
            fail++;
            System.err.println("  FAIL: " + name + (detail.isEmpty() ? "" : " (" + detail + ")"));
        }
    }

    private static void check(String name, boolean ok) { check(name, ok, ""); }

    public static void main(String[] args) {
        runSolvedStateChecks();
        runMoveParserChecks();
        runRosterChecks();
        runIdentityChecks();
        runDoubleEqualsTwiceChecks();
        runStickerConservationChecks();
        runInverseRoundTripChecks();
        runWideNotEqualOuterChecks();
        runCentresPreservedByOuterChecks();
        runJSParityCheck();

        System.out.println();
        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private static void runSolvedStateChecks() {
        System.out.println("─ Solved state ─");
        check("SOLVED length 96", Cube444.SOLVED.length() == 96);
        check("SOLVED is valid", Cube444.validate(Cube444.SOLVED).ok);
        check("isSolved(SOLVED)", Cube444.isSolved(Cube444.SOLVED));
    }

    private static void runMoveParserChecks() {
        System.out.println("─ Move parser ─");
        Object[][] cases = {
            {"U",   'U', false, 1},
            {"U'",  'U', false, -1},
            {"U2",  'U', false, 2},
            {"Uw",  'U', true,  1},
            {"Uw'", 'U', true, -1},
            {"Uw2", 'U', true,  2},
            {"Bw2", 'B', true,  2},
            {"Lw",  'L', true,  1},
        };
        for (Object[] c : cases) {
            String raw = (String) c[0];
            char face  = (Character) c[1];
            boolean wide = (Boolean) c[2];
            int turns = (Integer) c[3];
            Move m = Move.parse(raw);
            check("parseMove(" + raw + ")",
                m != null && m.face == face && m.wide == wide && m.turns == turns,
                m == null ? "null" : m.toString());
        }
        check("parseMove(garbage) → null", Move.parse("Q") == null);
        check("parseMove(empty) → null",   Move.parse("")  == null);
    }

    private static void runRosterChecks() {
        System.out.println("─ ALL_MOVES roster ─");
        check("ALL_MOVES has 36 entries", Cube444Moves.ALL_MOVES.size() == 36,
            "(got " + Cube444Moves.ALL_MOVES.size() + ")");
        Set<String> uniq = new HashSet<>(Cube444Moves.ALL_MOVES);
        check("ALL_MOVES all unique", uniq.size() == Cube444Moves.ALL_MOVES.size());
        boolean allParse = true;
        for (String m : Cube444Moves.ALL_MOVES) if (Move.parse(m) == null) { allParse = false; break; }
        check("every ALL_MOVES parses", allParse);
    }

    private static void runIdentityChecks() {
        System.out.println("─ Identity composition ─");
        for (String m : Cube444Moves.ALL_MOVES) {
            Move parsed = Move.parse(m);
            String s = Cube444.SOLVED;
            if (parsed.turns == 2) {
                String s2 = Cube444Moves.applyMove(Cube444Moves.applyMove(s, m), m);
                check(m + " ∘ " + m + " = I", Cube444.SOLVED.equals(s2));
            } else {
                String s4 = s;
                for (int i = 0; i < 4; i++) s4 = Cube444Moves.applyMove(s4, m);
                check(m + "⁴ = I", Cube444.SOLVED.equals(s4));

                String inv = parsed.inverse().toString();
                String round = Cube444Moves.applyMove(Cube444Moves.applyMove(s, m), inv);
                check(m + " ∘ " + inv + " = I", Cube444.SOLVED.equals(round));
            }
        }
    }

    private static void runDoubleEqualsTwiceChecks() {
        System.out.println("─ M2 equals M ∘ M ─");
        for (char f : Cube444.FACES) {
            for (String w : new String[] {"", "w"}) {
                String m  = "" + f + w;
                String m2 = m + "2";
                String a = Cube444Moves.applyMove(Cube444.SOLVED, m2);
                String b = Cube444Moves.applyMoves(Cube444.SOLVED, m + " " + m);
                check(m2 + " == " + m + " " + m, a.equals(b));
            }
        }
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

    private static void runStickerConservationChecks() {
        System.out.println("─ Sticker conservation ─");
        long[] seeds = {1, 7, 42, 1729, 8675309};
        for (long seed : seeds) {
            List<String> seq = scramble(seed, 50);
            String scrambled = Cube444Moves.applyMoves(Cube444.SOLVED, seq);
            int[] counts = new int[256];
            for (int i = 0; i < scrambled.length(); i++) counts[scrambled.charAt(i)]++;
            boolean ok = true;
            for (char fc : Cube444.FACES) if (counts[fc] != 16) { ok = false; break; }
            check("stickers conserved (seed " + seed + ")", ok);
            check("scrambled length 96 (seed " + seed + ")",
                scrambled.length() == Cube444.TOTAL_STICKERS);
        }
    }

    private static void runInverseRoundTripChecks() {
        System.out.println("─ Inverse round-trip ─");
        long[] seeds = {1, 7, 42, 1729};
        for (long seed : seeds) {
            List<String> seq = scramble(seed, 80);
            List<String> inv = Cube444Moves.invertMoves(seq);
            String state = Cube444Moves.applyMoves(Cube444.SOLVED, seq);
            String round = Cube444Moves.applyMoves(state, inv);
            check("scramble∘inverse = I (seed " + seed + ")", Cube444.SOLVED.equals(round));
        }
    }

    private static void runWideNotEqualOuterChecks() {
        System.out.println("─ Wide ≠ Outer ─");
        for (char f : Cube444.FACES) {
            String a = Cube444Moves.applyMove(Cube444.SOLVED, "" + f);
            String b = Cube444Moves.applyMove(Cube444.SOLVED, "" + f + "w");
            check(f + "w ≠ " + f, !a.equals(b));
        }
    }

    private static void runCentresPreservedByOuterChecks() {
        System.out.println("─ Outer-only preserves centres ─");
        List<String> outerOnly = new ArrayList<>();
        for (String m : Cube444Moves.ALL_MOVES) if (!m.contains("w")) outerOnly.add(m);
        long[] seeds = {1, 7, 42, 1729};
        for (long seed : seeds) {
            List<String> seq = new ArrayList<>(60);
            long x = seed;
            for (int i = 0; i < 60; i++) {
                x = lcg(x);
                seq.add(outerOnly.get((int) ((x >>> 0) % outerOnly.size())));
            }
            String state = Cube444Moves.applyMoves(Cube444.SOLVED, seq);
            String violation = null;
            outer:
            for (char f : Cube444.FACES) {
                int off = Cube444.faceOffset(f);
                for (int p : Cube444.CENTRE_POS) {
                    if (state.charAt(off + p) != f) {
                        violation = f + "@" + p + "=" + state.charAt(off + p);
                        break outer;
                    }
                }
            }
            check("centres preserved under outer-only (seed " + seed + ")",
                violation == null, violation == null ? "" : violation);
        }
    }

    /**
     * Cross-language parity check: applying "U" to SOLVED in our JS module
     * produces a specific 96-char state (recorded below from the
     * pyref-trace.json that we already byte-equality-verified against the
     * Python reference solver).  Java applyMove must produce the identical
     * string.
     */
    private static final String EXPECTED_AFTER_U =
        "UUUUUUUUUUUUUUUU"   // U
      + "BBBBRRRRRRRRRRRR"   // R: top row = old B's top row
      + "RRRRFFFFFFFFFFFF"   // F: top row = old R's top row
      + "DDDDDDDDDDDDDDDD"   // D
      + "FFFFLLLLLLLLLLLL"   // L: top row = old F's top row
      + "LLLLBBBBBBBBBBBB";  // B: top row = old L's top row

    private static void runJSParityCheck() {
        System.out.println("─ JS / Python-reference parity ─");
        String afterU = Cube444Moves.applyMove(Cube444.SOLVED, "U");
        check("applyMove(SOLVED, \"U\") byte-equal to JS/Python reference",
            EXPECTED_AFTER_U.equals(afterU),
            EXPECTED_AFTER_U.equals(afterU) ? "" :
                "expected: " + EXPECTED_AFTER_U + "\n            got:      " + afterU);
    }
}
