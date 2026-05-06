package z.y.x.cube.core;

/**
 * Static helpers for sticker permutations used by all cube sizes.
 *
 * Convention used throughout the cube package:
 *
 *   newState[i] = oldState[perm[i]]
 *
 * That is, perm[i] is the SOURCE index of the sticker that ends up at
 * position {@code i} after the move.  Composition follows the same rule:
 *
 *   (a ∘ b)[i] = a[b[i]]      // apply b first, then a
 *
 * Permutations are stored as {@code byte[]} (signed 8-bit, range
 * −128..127) — sticker indices fit comfortably for cubes up to 5×5
 * (150 stickers).  Sizes 6×6 (216) and 7×7 (294) need {@code short[]};
 * a parallel class will be added when those sizes land.
 */
public final class Permutation {

    private Permutation() {}

    /** Identity permutation of length {@code n}. */
    public static byte[] identity(int n) {
        byte[] p = new byte[n];
        for (int i = 0; i < n; i++) p[i] = (byte) i;
        return p;
    }

    /** Composition: result[i] = a[b[i]] (apply b first, then a). */
    public static byte[] compose(byte[] a, byte[] b) {
        if (a.length != b.length) {
            throw new IllegalArgumentException(
                "compose: length mismatch " + a.length + " vs " + b.length);
        }
        byte[] out = new byte[a.length];
        for (int i = 0; i < a.length; i++) out[i] = a[b[i] & 0xFF];
        return out;
    }

    /** Square: returns {@code p ∘ p}. */
    public static byte[] square(byte[] p) {
        return compose(p, p);
    }

    /** Cube: returns {@code p ∘ p ∘ p} — equivalent to the inverse of a
     *  quarter-turn permutation when {@code p} is a quarter-turn. */
    public static byte[] cube(byte[] p) {
        return compose(compose(p, p), p);
    }

    /**
     * Apply a permutation to a state string in place — returns a new
     * string of the same length where {@code newState.charAt(i) ==
     * oldState.charAt(perm[i])}.
     */
    public static String apply(String state, byte[] perm) {
        if (state.length() != perm.length) {
            throw new IllegalArgumentException(
                "apply: state length " + state.length()
                + " ≠ perm length " + perm.length);
        }
        char[] out = new char[perm.length];
        for (int i = 0; i < perm.length; i++) {
            out[i] = state.charAt(perm[i] & 0xFF);
        }
        return new String(out);
    }
}
