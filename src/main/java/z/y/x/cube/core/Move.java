package z.y.x.cube.core;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Parsed cube-move literal.
 *
 * Notation accepted:
 *   {U|R|F|D|L|B}{w?}{'|2}?
 *
 *   U      → outer Up, 90° clockwise
 *   U'     → outer Up, 90° counter-clockwise
 *   U2     → outer Up, 180°
 *   Uw     → wide Up (top two layers, 4×4) 90° CW
 *   Uw'    → wide Up CCW
 *   Uw2    → wide Up 180°
 *
 * Slice-only notation ("M", "E", "S", "2U" etc.) is intentionally not
 * supported — every move can be expressed as outer or wide, which is
 * sufficient for solving up to 4×4.  Larger cubes will need extending
 * this class with a `depth` field.
 *
 * Immutable.  Equality + hashCode are well-defined so {@code Move} can
 * be used as a Map key.
 */
public final class Move {

    private static final Pattern RE = Pattern.compile("^([URFDLB])(w?)(['2]?)$");

    public final char face;       // 'U' | 'R' | 'F' | 'D' | 'L' | 'B'
    public final boolean wide;
    public final int turns;       // 1 = CW, -1 = CCW, 2 = 180°

    private final String raw;

    private Move(String raw, char face, boolean wide, int turns) {
        this.raw   = raw;
        this.face  = face;
        this.wide  = wide;
        this.turns = turns;
    }

    /** Parse a move string. Returns null if the string is malformed. */
    public static Move parse(String s) {
        if (s == null) return null;
        Matcher m = RE.matcher(s);
        if (!m.matches()) return null;
        char face = m.group(1).charAt(0);
        boolean wide = "w".equals(m.group(2));
        String suf = m.group(3);
        int turns = "'".equals(suf) ? -1 : "2".equals(suf) ? 2 : 1;
        return new Move(s, face, wide, turns);
    }

    public Move inverse() {
        if (turns == 2) return this;
        char[] buf = new char[3];
        int n = 0;
        buf[n++] = face;
        if (wide) buf[n++] = 'w';
        if (turns == 1) buf[n++] = '\'';
        return parse(new String(buf, 0, n));
    }

    @Override
    public String toString() { return raw; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Move)) return false;
        Move m = (Move) o;
        return face == m.face && wide == m.wide && turns == m.turns;
    }

    @Override
    public int hashCode() {
        return ((face * 31 + (wide ? 1 : 0)) * 31 + turns);
    }
}
