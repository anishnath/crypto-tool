package z.y.x.cube.kociemba;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import z.y.x.cube.core.Kociemba3x3;

/**
 * Pure-Java Kociemba 3×3 solver — adapter implementing
 * {@link Kociemba3x3}.  All compute, no subprocess.
 *
 * Register at boot:
 *   {@code Kociemba3x3.set(new Kociemba());}
 *
 * After registration, anyone calling {@link Kociemba3x3#get()}.solve()
 * gets this implementation.  Used by the 4×4 solver pipeline at the
 * final 3×3-reduction step.
 *
 * First call triggers ~3–6 s init while CoordCube builds prune tables.
 * After that, typical solve is &lt; 100 ms.
 */
public final class Kociemba implements Kociemba3x3 {

    private final int maxDepth;
    private final long timeOutSec;
    private final boolean useSeparator;

    public Kociemba() { this(24, 30, false); }

    public Kociemba(int maxDepth, long timeOutSec, boolean useSeparator) {
        this.maxDepth = maxDepth;
        this.timeOutSec = timeOutSec;
        this.useSeparator = useSeparator;
    }

    private static final String SOLVED_3x3 =
        "UUUUUUUUU" + "RRRRRRRRR" + "FFFFFFFFF"
      + "DDDDDDDDD" + "LLLLLLLLL" + "BBBBBBBBB";

    @Override
    public List<String> solve(String state54) throws Exception {
        if (state54.length() != 54) {
            throw new IllegalArgumentException("expected 54-char state, got " + state54.length());
        }
        if (SOLVED_3x3.equals(state54)) return Collections.emptyList();
        Search s = new Search();
        String soln = s.solve(state54, maxDepth, timeOutSec, useSeparator);
        if (soln == null) {
            throw new Exception("Kociemba could not solve state");
        }
        // Tokenise the move-list (separator '.' is just a phase marker;
        // we discard it — the move sequence is the same).
        List<String> out = new ArrayList<>();
        for (String tok : soln.trim().split("\\s+")) {
            if (tok.isEmpty() || ".".equals(tok)) continue;
            out.add(tok);
        }
        return Collections.unmodifiableList(out);
    }

    @Override
    public String implName() { return "Kociemba (Java port of dwalton76/kociemba)"; }
}
