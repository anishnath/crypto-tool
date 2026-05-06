package z.y.x.cube.cube555;

/**
 * High-performance byte[]-based 5×5 cube state — sister of
 * {@link z.y.x.cube.cube444.Cube444Bytes}.
 *
 * Same rationale: {@link Cube555} stores state as an immutable
 * {@link String} for clean API boundaries, but every move allocates a
 * fresh 150-char object — death by GC inside an IDA* loop exploring
 * tens of millions of nodes.
 *
 * This class instead stores state as a flat 150-byte array of ASCII
 * face-letter codes (U=85, R=82, F=70, D=68, L=76, B=66) and mutates
 * it in place via {@link #applyPermInPlace(byte[], byte[], byte[])}.
 *
 * Permutation values fit in a signed byte (max sticker index = 149,
 * needs 8 unsigned bits — &amp; 0xFF on read).
 */
public final class Cube555Bytes {

    private Cube555Bytes() {}

    public static byte[] solved() {
        byte[] s = new byte[Cube555.TOTAL_STICKERS];
        java.util.Arrays.fill(s,   0,  25, (byte) 'U');
        java.util.Arrays.fill(s,  25,  50, (byte) 'R');
        java.util.Arrays.fill(s,  50,  75, (byte) 'F');
        java.util.Arrays.fill(s,  75, 100, (byte) 'D');
        java.util.Arrays.fill(s, 100, 125, (byte) 'L');
        java.util.Arrays.fill(s, 125, 150, (byte) 'B');
        return s;
    }

    public static byte[] fromString(String s) {
        if (s.length() != Cube555.TOTAL_STICKERS) {
            throw new IllegalArgumentException("expected 150-char state, got " + s.length());
        }
        byte[] out = new byte[Cube555.TOTAL_STICKERS];
        for (int i = 0; i < Cube555.TOTAL_STICKERS; i++) out[i] = (byte) s.charAt(i);
        return out;
    }

    public static String toString(byte[] state) {
        char[] c = new char[state.length];
        for (int i = 0; i < state.length; i++) c[i] = (char) (state[i] & 0xFF);
        return new String(c);
    }

    public static byte[] copy(byte[] state) { return state.clone(); }

    /**
     * Apply a permutation in place using a caller-supplied scratch buffer
     * of the same length.  Inner-loop hot spot — IDA* hits this millions
     * of times per solve.  Single tight loop, no allocation, no boxing.
     *
     * Caller MUST pass {@code scratch.length == state.length}.  Reusing
     * one scratch across many calls is the entire point.
     */
    public static void applyPermInPlace(byte[] state, byte[] perm, byte[] scratch) {
        // newState[i] = oldState[perm[i] & 0xFF]
        for (int i = 0; i < state.length; i++) scratch[i] = state[perm[i] & 0xFF];
        System.arraycopy(scratch, 0, state, 0, state.length);
    }

    /** Allocating variant — for tests / one-off use. NOT for hot paths. */
    public static byte[] applyPerm(byte[] state, byte[] perm) {
        byte[] out = new byte[state.length];
        for (int i = 0; i < state.length; i++) out[i] = state[perm[i] & 0xFF];
        return out;
    }

    /** Apply a single move (string label) to a state in place. */
    public static void applyMoveInPlace(byte[] state, String moveLabel, byte[] scratch) {
        applyPermInPlace(state, Cube555Moves.permFor(moveLabel), scratch);
    }
}
