package z.y.x.cube.cube444;

/**
 * High-performance byte[]-based 4×4 cube state — the variant the IDA*
 * search uses internally.
 *
 * Why a separate class from {@link Cube444}: that one stores state as
 * an immutable {@link String}.  String works for end-user APIs (servlet
 * input, JSON payloads, stable equality semantics), but it allocates a
 * fresh 96-char object on every move — death by GC inside an IDA* loop
 * exploring millions of nodes.
 *
 * This class instead stores state as a flat 96-byte array of ASCII
 * face-letter codes (U=85, R=82, F=70, D=68, L=76, B=66) and mutates
 * it in place via {@link #applyMove(byte[], byte[])}.  Allocations
 * during search drop to zero in the inner loop — GC pressure becomes
 * irrelevant and HotSpot can JIT-compile the move loop to tight native
 * code.
 *
 * The byte representation is byte-equivalent to the String form's UTF-8
 * encoding, so {@link #toString(byte[])} / {@link #fromString(String)}
 * are O(96) memcpy-class operations.
 */
public final class Cube444Bytes {

    private Cube444Bytes() {}

    public static byte[] solved() {
        byte[] s = new byte[Cube444.TOTAL_STICKERS];
        java.util.Arrays.fill(s,  0, 16, (byte) 'U');
        java.util.Arrays.fill(s, 16, 32, (byte) 'R');
        java.util.Arrays.fill(s, 32, 48, (byte) 'F');
        java.util.Arrays.fill(s, 48, 64, (byte) 'D');
        java.util.Arrays.fill(s, 64, 80, (byte) 'L');
        java.util.Arrays.fill(s, 80, 96, (byte) 'B');
        return s;
    }

    /** O(96) round-trip with String form (used at servlet boundaries
     *  and for equality testing — never called inside the IDA* loop). */
    public static byte[] fromString(String s) {
        if (s.length() != Cube444.TOTAL_STICKERS) {
            throw new IllegalArgumentException("expected 96-char state, got " + s.length());
        }
        byte[] out = new byte[Cube444.TOTAL_STICKERS];
        for (int i = 0; i < Cube444.TOTAL_STICKERS; i++) out[i] = (byte) s.charAt(i);
        return out;
    }

    public static String toString(byte[] state) {
        char[] c = new char[state.length];
        for (int i = 0; i < state.length; i++) c[i] = (char) (state[i] & 0xFF);
        return new String(c);
    }

    public static byte[] copy(byte[] state) {
        return state.clone();
    }

    /**
     * Apply a permutation to {@code state} in place using a scratch
     * buffer of the same length.  This is THE inner-loop hot spot —
     * IDA* calls it millions of times per solve.  Single tight loop,
     * no allocation, no boxing, no method dispatch.
     *
     * Caller MUST pass {@code scratch} with {@code length == state.length}.
     * Reusing one scratch across many calls is the entire point.
     */
    public static void applyPermInPlace(byte[] state, byte[] perm, byte[] scratch) {
        // newState[i] = oldState[perm[i] & 0xFF]
        for (int i = 0; i < state.length; i++) {
            scratch[i] = state[perm[i] & 0xFF];
        }
        // Copy scratch back into state.
        System.arraycopy(scratch, 0, state, 0, state.length);
    }

    /** Convenience for tests / one-off uses where allocating a fresh
     *  scratch is fine.  DO NOT call this from search hot paths. */
    public static byte[] applyPerm(byte[] state, byte[] perm) {
        byte[] out = new byte[state.length];
        for (int i = 0; i < state.length; i++) {
            out[i] = state[perm[i] & 0xFF];
        }
        return out;
    }

    /** Apply a single move (string label) to a state.  Resolves the
     *  perm via {@link Cube444Moves#permFor(String)} — caller may
     *  cache the result for hot-path reuse. */
    public static void applyMoveInPlace(byte[] state, String moveLabel, byte[] scratch) {
        applyPermInPlace(state, Cube444Moves.permFor(moveLabel), scratch);
    }
}
