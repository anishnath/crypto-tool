package z.y.x.cube.cube444.stage;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * 4×4-specific parity recovery.
 *
 * After the cube is fully reduced (centres + edges + corners look like
 * a 3×3), it can still be in one of two states a 3×3 solver rejects:
 *
 *  - **OLL parity**: a single dedge is "flipped" — its two stickers are
 *    swapped relative to a real 3×3 edge.  Detected when the reduced
 *    3×3 has an odd number of edge orientations.  Fix: a 12-move
 *    sequence applied with the bad dedge at UF.
 *
 *  - **PLL parity**: two dedges are SWAPPED — their colors match each
 *    other but at the wrong slot positions.  This is what hits hard
 *    scrambles repeatedly.  Fix: a 6-move "Rw2 U2 Rw2 Uw2 Rw2 Uw2"
 *    sequence applied with the swapped pair at UF↔UB.
 *
 * Both algorithms preserve everything else about the cube.  They're
 * canonical; copy-pasted from any 4×4 method guide.
 *
 * The detection logic is tricky because we don't know upfront WHERE
 * the parity defect is — it may need to be rotated to the canonical
 * position before applying the alg.  This class implements the simple
 * cases (parity already at UF / UF-UB).  More general detection is
 * handled by trying multiple cube reorientations and seeing which one
 * makes the cube solve cleanly via Kociemba.
 */
public final class Parity {

    private Parity() {}

    /** PLL parity — swap UF and UB dedges in place.  6 moves. */
    public static final List<String> PLL_PARITY = Collections.unmodifiableList(
        Arrays.asList("Rw2", "U2", "Rw2", "Uw2", "Rw2", "Uw2"));

    /** OLL parity — flip the UF dedge in place.  12 moves. */
    public static final List<String> OLL_PARITY = Collections.unmodifiableList(
        Arrays.asList("Rw", "U2", "Rw'", "U2", "Rw", "U2", "Rw", "U2",
                      "Rw'", "U2", "Rw'", "U2"));

    /** Both parities (= OLL then PLL).  Some defects need both algs. */
    public static final List<String> DOUBLE_PARITY;
    static {
        java.util.List<String> both = new java.util.ArrayList<>(OLL_PARITY.size() + PLL_PARITY.size());
        both.addAll(OLL_PARITY);
        both.addAll(PLL_PARITY);
        DOUBLE_PARITY = Collections.unmodifiableList(both);
    }
}
