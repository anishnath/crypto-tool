package z.y.x.cube.cube555;

/**
 * End-to-end orchestrator smoke test for the pure-Java 5×5 solver.
 *
 * <p>Uses a tiny scramble (3 moves) to keep IDA* runtimes manageable
 * — the encoders allocate per node so longer scrambles are slow until
 * we optimise that hot path.  The point of THIS test is just: does the
 * full pipeline LR → FB → EO → P4 → P5 → P6 → reduce → Kociemba run
 * end-to-end and solve the cube?
 */
public final class Cube555SolverTest {

    public static void main(String[] args) throws Exception {
        // Tiny scramble: U, R only.
        String state = Cube555Moves.applyMoves(Cube555.SOLVED, "U R");
        System.out.println("Scramble: U R");
        System.out.println("Initial state length: " + state.length());

        long t0 = System.currentTimeMillis();
        Cube555Solver.Result r = Cube555Solver.solve(state);
        long dt = System.currentTimeMillis() - t0;

        System.out.println();
        System.out.println("Backend: pure Java");
        System.out.println("Stages: LR=" + r.lrMoves.size()
            + " FB=" + r.fbMoves.size()
            + " EO=" + r.eoMoves.size()
            + " P4=" + r.p4Moves.size()
            + " P5=" + r.p5Moves.size()
            + " P6=" + r.p6Moves.size()
            + " K=" + r.reduceMoves.size());
        System.out.println("Total moves: " + r.moves.size());
        System.out.println("Time: " + dt + " ms");
        System.out.println("Solved: " + r.solved);
        if (r.stoppedAt != null) {
            System.out.println("Stopped at: " + r.stoppedAt);
        }
        System.out.println("Final state: " + r.finalState);
        System.exit(r.solved ? 0 : 1);
    }

    private Cube555SolverTest() {}
}
