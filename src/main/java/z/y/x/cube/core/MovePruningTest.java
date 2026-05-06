package z.y.x.cube.core;

import z.y.x.cube.cube444.Cube444Moves;

/**
 * Standalone test for {@link MovePruning} predicates.
 *
 *   javac -d /tmp/cube-classes src/main/java/z/y/x/cube/**.java
 *   java  -cp /tmp/cube-classes z.y.x.cube.core.MovePruningTest
 *
 * Sanity checks:
 *   - cancelsOut symmetric on every (M, M') pair
 *   - sameFaceAndLayer symmetric, true on (Uw, Uw2) etc.
 *   - sameFace catches (U, Uw)
 *   - shouldSkip rejects U,U / U,U' / U,Uw / U,U2 (all redundant)
 *   - shouldSkip allows U,R / U,F (independent faces, in canonical order)
 *   - shouldSkip rejects D,U as commuting-out-of-order; allows U,D
 */
public final class MovePruningTest {

    private static int pass = 0, fail = 0;
    private static void check(String name, boolean ok) {
        if (ok) pass++;
        else { fail++; System.err.println("  FAIL: " + name); }
    }

    private static Move m(String s) { return Move.parse(s); }

    public static void main(String[] args) {
        // ── cancelsOut ──
        check("cancelsOut(U, U')",  MovePruning.cancelsOut(m("U"),  m("U'")));
        check("cancelsOut(U', U)",  MovePruning.cancelsOut(m("U'"), m("U")));
        check("cancelsOut(U2, U2)", MovePruning.cancelsOut(m("U2"), m("U2")));
        check("cancelsOut(Uw, Uw')", MovePruning.cancelsOut(m("Uw"), m("Uw'")));
        check("!cancelsOut(U, U)",  !MovePruning.cancelsOut(m("U"),  m("U")));
        check("!cancelsOut(U, R)",  !MovePruning.cancelsOut(m("U"),  m("R")));
        check("!cancelsOut(U, Uw')", !MovePruning.cancelsOut(m("U"), m("Uw'")));
        check("!cancelsOut(U2, U)",  !MovePruning.cancelsOut(m("U2"), m("U")));

        // ── sameFaceAndLayer ──
        check("sameFaceAndLayer(U, U')",   MovePruning.sameFaceAndLayer(m("U"),  m("U'")));
        check("sameFaceAndLayer(U, U2)",   MovePruning.sameFaceAndLayer(m("U"),  m("U2")));
        check("sameFaceAndLayer(Uw, Uw2)", MovePruning.sameFaceAndLayer(m("Uw"), m("Uw2")));
        check("!sameFaceAndLayer(U, Uw)",  !MovePruning.sameFaceAndLayer(m("U"),  m("Uw")));
        check("!sameFaceAndLayer(U, R)",   !MovePruning.sameFaceAndLayer(m("U"),  m("R")));

        // ── sameFace ──
        check("sameFace(U, Uw)",   MovePruning.sameFace(m("U"),  m("Uw")));
        check("sameFace(U, U2)",   MovePruning.sameFace(m("U"),  m("U2")));
        check("!sameFace(U, R)",   !MovePruning.sameFace(m("U"),  m("R")));

        // ── oppositeFaces ──
        check("oppositeFaces(U, D)",  MovePruning.oppositeFaces('U', 'D'));
        check("oppositeFaces(L, R)",  MovePruning.oppositeFaces('L', 'R'));
        check("oppositeFaces(F, B)",  MovePruning.oppositeFaces('F', 'B'));
        check("!oppositeFaces(U, R)", !MovePruning.oppositeFaces('U', 'R'));
        check("!oppositeFaces(U, U)", !MovePruning.oppositeFaces('U', 'U'));

        // ── outerLayerMovesInOrder ──
        check("inOrder(U, D)",     MovePruning.outerLayerMovesInOrder(m("U"), m("D")));
        check("!inOrder(D, U)",    !MovePruning.outerLayerMovesInOrder(m("D"), m("U")));
        check("inOrder(L, R)",     MovePruning.outerLayerMovesInOrder(m("L"), m("R")));
        check("!inOrder(R, L)",    !MovePruning.outerLayerMovesInOrder(m("R"), m("L")));
        check("inOrder(U, R)",     MovePruning.outerLayerMovesInOrder(m("U"), m("R")));
        // Wide moves not subject to the ordering rule:
        check("inOrder(D, Uw)",    MovePruning.outerLayerMovesInOrder(m("D"),  m("Uw")));

        // ── shouldSkip — combined check used by stages ──
        check("skip(U, U)",     MovePruning.shouldSkip(m("U"),  m("U")));    // same-layer redundant
        check("skip(U, U')",    MovePruning.shouldSkip(m("U"),  m("U'")));   // cancels
        check("skip(U, U2)",    MovePruning.shouldSkip(m("U"),  m("U2")));   // same-layer
        check("skip(U, Uw)",    MovePruning.shouldSkip(m("U"),  m("Uw")));   // same-face
        check("skip(D, U)",     MovePruning.shouldSkip(m("D"),  m("U")));    // commuting wrong order
        check("!skip(U, D)",    !MovePruning.shouldSkip(m("U"),  m("D")));   // commuting right order
        check("!skip(U, R)",    !MovePruning.shouldSkip(m("U"),  m("R")));   // independent
        check("!skip(U, F)",    !MovePruning.shouldSkip(m("U"),  m("F")));   // independent

        // ── Roster sanity: every move in ALL_MOVES parses, every pair
        //    runs without throwing. ──
        for (String pa : Cube444Moves.ALL_MOVES) {
            for (String pb : Cube444Moves.ALL_MOVES) {
                MovePruning.shouldSkip(m(pa), m(pb));   // throws would surface here
            }
        }
        check("36×36 roster pairs all evaluate", true);

        System.out.println(pass + " passed, " + fail + " failed");
        System.exit(fail == 0 ? 0 : 1);
    }

    private MovePruningTest() {}
}
