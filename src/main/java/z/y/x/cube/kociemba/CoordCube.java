package z.y.x.cube.kociemba;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Coordinate-level cube representation — port of {@code coordcube.c}.
 *
 * Holds the 8 integer coordinates Kociemba's two-phase IDA* searches over,
 * plus the 7 move tables and 4 pruning tables that encode "what's the new
 * coordinate after move M" and "lower bound on remaining moves" respectively.
 *
 * The tables are computed once at class-load (~3–6 seconds) and cached to
 * disk under {@code -Dcube.kociemba.cacheDir=…} (default
 * {@code ${user.home}/.cube-kociemba/}).  Subsequent loads are O(file read).
 *
 * Total heap: ~4.5 MB across all tables.  Disk cache: ~3.5 MB.
 *
 * Threading: tables are static finals populated by {@link #initPruning()}.
 * That method is synchronized.  Once populated, all reads are concurrent-safe.
 */
public final class CoordCube {

    public static final int N_TWIST     = 2187;
    public static final int N_FLIP      = 2048;
    public static final int N_SLICE1    = 495;
    public static final int N_SLICE2    = 24;
    public static final int N_PARITY    = 2;
    public static final int N_URFtoDLF  = 20160;
    public static final int N_FRtoBR    = 11880;
    public static final int N_URtoUL    = 1320;
    public static final int N_UBtoDF    = 1320;
    public static final int N_URtoDF    = 20160;
    public static final int N_URFtoDLB  = 40320;
    public static final int N_MOVE      = 18;

    /* ─── Coordinates of this cube ─────────────────── */

    public short twist;
    public short flip;
    public short parity;
    public short FRtoBR;
    public short URFtoDLF;
    public short URtoUL;
    public short UBtoDF;
    public int   URtoDF;

    /* ─── Static move tables ─────────────────────── */

    public static final short[][] twistMove    = new short[N_TWIST][N_MOVE];
    public static final short[][] flipMove     = new short[N_FLIP][N_MOVE];
    public static final short[][] FRtoBR_Move  = new short[N_FRtoBR][N_MOVE];
    public static final short[][] URFtoDLF_Move = new short[N_URFtoDLF][N_MOVE];
    public static final short[][] URtoDF_Move  = new short[N_URtoDF][N_MOVE];
    public static final short[][] URtoUL_Move  = new short[N_URtoUL][N_MOVE];
    public static final short[][] UBtoDF_Move  = new short[N_UBtoDF][N_MOVE];
    public static final short[][] MergeURtoULandUBtoDF = new short[336][336];

    public static final short[][] parityMove = {
        {1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1},
        {0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0},
    };

    /* ─── Static pruning tables ─────────────────── */

    public static final byte[] Slice_URFtoDLF_Parity_Prun = new byte[N_SLICE2 * N_URFtoDLF * N_PARITY / 2];
    public static final byte[] Slice_URtoDF_Parity_Prun   = new byte[N_SLICE2 * N_URtoDF   * N_PARITY / 2];
    public static final byte[] Slice_Twist_Prun           = new byte[N_SLICE1 * N_TWIST / 2 + 1];
    public static final byte[] Slice_Flip_Prun            = new byte[N_SLICE1 * N_FLIP  / 2];

    private static volatile boolean PRUNING_INITED = false;

    private CoordCube() {}

    /** Build a CoordCube from a CubieCube. */
    public static CoordCube fromCubie(CubieCube c) {
        CoordCube r = new CoordCube();
        r.twist    = c.getTwist();
        r.flip     = c.getFlip();
        r.parity   = c.cornerParity();
        r.FRtoBR   = c.getFRtoBR();
        r.URFtoDLF = c.getURFtoDLF();
        r.URtoUL   = c.getURtoUL();
        r.UBtoDF   = c.getUBtoDF();
        r.URtoDF   = c.getURtoDF();
        return r;
    }

    /** Apply one of the 18 moves to this coord cube in place. */
    public void move(int m) {
        if (!PRUNING_INITED) ensureInited();
        twist    = twistMove[twist][m];
        flip     = flipMove[flip][m];
        parity   = parityMove[parity][m];
        FRtoBR   = FRtoBR_Move[FRtoBR][m];
        URFtoDLF = URFtoDLF_Move[URFtoDLF][m];
        URtoUL   = URtoUL_Move[URtoUL][m];
        UBtoDF   = UBtoDF_Move[UBtoDF][m];
        if ((URtoUL & 0xFFFF) < 336 && (UBtoDF & 0xFFFF) < 336) {
            URtoDF = MergeURtoULandUBtoDF[URtoUL][UBtoDF];
        }
    }

    /* ─── Pruning-table bit packing ──────────────── */

    /** Pack a 4-bit value at index {@code idx} (two values per byte). */
    public static void setPruning(byte[] table, int idx, byte value) {
        if ((idx & 1) == 0) {
            table[idx >> 1] = (byte) ((table[idx >> 1] & 0xF0) | (value & 0x0F));
        } else {
            table[idx >> 1] = (byte) ((table[idx >> 1] & 0x0F) | ((value & 0x0F) << 4));
        }
    }

    public static byte getPruning(byte[] table, int idx) {
        if ((idx & 1) == 0) return (byte) (table[idx >> 1] & 0x0F);
        else                return (byte) ((table[idx >> 1] >> 4) & 0x0F);
    }

    /* ─── Initialization (cache or compute) ─────── */

    public static synchronized void ensureInited() {
        if (PRUNING_INITED) return;
        File cacheDir = resolveCacheDir();
        if (!cacheDir.exists() && !cacheDir.mkdirs()) {
            throw new IllegalStateException("cannot create cache dir: " + cacheDir);
        }
        try {
            initAllTables(cacheDir);
        } catch (IOException e) {
            throw new RuntimeException("failed to initialize Kociemba tables", e);
        }
        PRUNING_INITED = true;
    }

    private static File resolveCacheDir() {
        String prop = System.getProperty("cube.kociemba.cacheDir");
        if (prop != null && !prop.isEmpty()) return new File(prop);
        return new File(System.getProperty("user.home", "/tmp"), ".cube-kociemba");
    }

    /* ─── Table builders ───────────────────────── */

    private static void initAllTables(File cacheDir) throws IOException {
        initShortTable("twistMove",    twistMove,    cacheDir, () -> buildTwistMove());
        initShortTable("flipMove",     flipMove,     cacheDir, () -> buildFlipMove());
        initShortTable("FRtoBR_Move",  FRtoBR_Move,  cacheDir, () -> buildFRtoBRMove());
        initShortTable("URFtoDLF_Move", URFtoDLF_Move, cacheDir, () -> buildURFtoDLFMove());
        initShortTable("URtoDF_Move",  URtoDF_Move,  cacheDir, () -> buildURtoDFMove());
        initShortTable("URtoUL_Move",  URtoUL_Move,  cacheDir, () -> buildURtoULMove());
        initShortTable("UBtoDF_Move",  UBtoDF_Move,  cacheDir, () -> buildUBtoDFMove());
        initShortTable("MergeURtoULandUBtoDF", MergeURtoULandUBtoDF, cacheDir,
            () -> buildMergeURtoULandUBtoDF());

        initBytePruning("Slice_URFtoDLF_Parity_Prun", Slice_URFtoDLF_Parity_Prun, cacheDir,
            () -> buildSliceURFtoDLFParityPrun());
        initBytePruning("Slice_URtoDF_Parity_Prun", Slice_URtoDF_Parity_Prun, cacheDir,
            () -> buildSliceURtoDFParityPrun());
        initBytePruning("Slice_Twist_Prun", Slice_Twist_Prun, cacheDir,
            () -> buildSliceTwistPrun());
        initBytePruning("Slice_Flip_Prun", Slice_Flip_Prun, cacheDir,
            () -> buildSliceFlipPrun());
    }

    private interface BuilderTask { void build(); }

    private static void initShortTable(String name, short[][] table, File cacheDir, BuilderTask builder)
            throws IOException {
        File f = new File(cacheDir, name);
        if (f.exists() && f.length() == (long) table.length * table[0].length * 2) {
            try (DataInputStream in = new DataInputStream(new FileInputStream(f))) {
                for (int i = 0; i < table.length; i++)
                    for (int j = 0; j < table[i].length; j++) table[i][j] = in.readShort();
            }
        } else {
            System.err.println("Computing " + name + " table…");
            long t = System.currentTimeMillis();
            builder.build();
            System.err.println("  " + name + " ready in " + (System.currentTimeMillis() - t) + "ms");
            try (DataOutputStream out = new DataOutputStream(new FileOutputStream(f))) {
                for (short[] row : table) for (short v : row) out.writeShort(v);
            }
        }
    }

    private static void initBytePruning(String name, byte[] table, File cacheDir, BuilderTask builder)
            throws IOException {
        File f = new File(cacheDir, name);
        if (f.exists() && f.length() == table.length) {
            try (DataInputStream in = new DataInputStream(new FileInputStream(f))) {
                in.readFully(table);
            }
        } else {
            System.err.println("Computing " + name + " pruning table…");
            long t = System.currentTimeMillis();
            builder.build();
            System.err.println("  " + name + " ready in " + (System.currentTimeMillis() - t) + "ms");
            try (DataOutputStream out = new DataOutputStream(new FileOutputStream(f))) {
                out.write(table);
            }
        }
    }

    private static void buildTwistMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_TWIST; i++) {
            a.setTwist(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.cornerMultiply(CubieCube.MOVE_CUBE[j]);
                    twistMove[i][3 * j + k] = a.getTwist();
                }
                a.cornerMultiply(CubieCube.MOVE_CUBE[j]);   // 4th turn restores
            }
        }
    }

    private static void buildFlipMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_FLIP; i++) {
            a.setFlip(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
                    flipMove[i][3 * j + k] = a.getFlip();
                }
                a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
            }
        }
    }

    private static void buildFRtoBRMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_FRtoBR; i++) {
            a.setFRtoBR(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
                    FRtoBR_Move[i][3 * j + k] = a.getFRtoBR();
                }
                a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
            }
        }
    }

    private static void buildURFtoDLFMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_URFtoDLF; i++) {
            a.setURFtoDLF(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.cornerMultiply(CubieCube.MOVE_CUBE[j]);
                    URFtoDLF_Move[i][3 * j + k] = a.getURFtoDLF();
                }
                a.cornerMultiply(CubieCube.MOVE_CUBE[j]);
            }
        }
    }

    private static void buildURtoDFMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_URtoDF; i++) {
            a.setURtoDF(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
                    URtoDF_Move[i][3 * j + k] = (short) a.getURtoDF();
                }
                a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
            }
        }
    }

    private static void buildURtoULMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_URtoUL; i++) {
            a.setURtoUL(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
                    URtoUL_Move[i][3 * j + k] = a.getURtoUL();
                }
                a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
            }
        }
    }

    private static void buildUBtoDFMove() {
        CubieCube a = new CubieCube();
        for (int i = 0; i < N_UBtoDF; i++) {
            a.setUBtoDF(i);
            for (int j = 0; j < 6; j++) {
                for (int k = 0; k < 3; k++) {
                    a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
                    UBtoDF_Move[i][3 * j + k] = a.getUBtoDF();
                }
                a.edgeMultiply(CubieCube.MOVE_CUBE[j]);
            }
        }
    }

    private static void buildMergeURtoULandUBtoDF() {
        for (short uRtoUL = 0; uRtoUL < 336; uRtoUL++) {
            for (short uBtoDF = 0; uBtoDF < 336; uBtoDF++) {
                MergeURtoULandUBtoDF[uRtoUL][uBtoDF] = (short) getURtoDF_standalone(uRtoUL, uBtoDF);
            }
        }
    }

    private static int getURtoDF_standalone(short idx1, short idx2) {
        CubieCube a = new CubieCube();
        CubieCube b = new CubieCube();
        a.setURtoUL(idx1);
        b.setUBtoDF(idx2);
        for (int i = 0; i < 8; i++) {
            if ((a.ep[i] & 0xFF) != KEnums.BR) {
                if ((b.ep[i] & 0xFF) != KEnums.BR) return -1;
                else b.ep[i] = a.ep[i];
            }
        }
        return b.getURtoDF();
    }

    private static void buildSliceURFtoDLFParityPrun() {
        for (int i = 0; i < Slice_URFtoDLF_Parity_Prun.length; i++) Slice_URFtoDLF_Parity_Prun[i] = -1;
        setPruning(Slice_URFtoDLF_Parity_Prun, 0, (byte) 0);
        int depth = 0, done = 1;
        int total = N_SLICE2 * N_URFtoDLF * N_PARITY;
        while (done != total) {
            for (int i = 0; i < total; i++) {
                int parity = i % 2;
                int URFtoDLF = (i / 2) / N_SLICE2;
                int slice = (i / 2) % N_SLICE2;
                if (getPruning(Slice_URFtoDLF_Parity_Prun, i) == depth) {
                    for (int j = 0; j < 18; j++) {
                        if (j == 3 || j == 5 || j == 6 || j == 8 || j == 12 || j == 14 || j == 15 || j == 17) continue;
                        int newSlice = FRtoBR_Move[slice][j] & 0xFFFF;
                        int newURFtoDLF = URFtoDLF_Move[URFtoDLF][j] & 0xFFFF;
                        int newParity = parityMove[parity][j];
                        int idx = (N_SLICE2 * newURFtoDLF + newSlice) * 2 + newParity;
                        if (getPruning(Slice_URFtoDLF_Parity_Prun, idx) == 0x0F) {
                            setPruning(Slice_URFtoDLF_Parity_Prun, idx, (byte) (depth + 1));
                            done++;
                        }
                    }
                }
            }
            depth++;
        }
    }

    private static void buildSliceURtoDFParityPrun() {
        for (int i = 0; i < Slice_URtoDF_Parity_Prun.length; i++) Slice_URtoDF_Parity_Prun[i] = -1;
        setPruning(Slice_URtoDF_Parity_Prun, 0, (byte) 0);
        int depth = 0, done = 1;
        int total = N_SLICE2 * N_URtoDF * N_PARITY;
        while (done != total) {
            for (int i = 0; i < total; i++) {
                int parity = i % 2;
                int URtoDF = (i / 2) / N_SLICE2;
                int slice = (i / 2) % N_SLICE2;
                if (getPruning(Slice_URtoDF_Parity_Prun, i) == depth) {
                    for (int j = 0; j < 18; j++) {
                        if (j == 3 || j == 5 || j == 6 || j == 8 || j == 12 || j == 14 || j == 15 || j == 17) continue;
                        int newSlice = FRtoBR_Move[slice][j] & 0xFFFF;
                        int newURtoDF = URtoDF_Move[URtoDF][j] & 0xFFFF;
                        int newParity = parityMove[parity][j];
                        int idx = (N_SLICE2 * newURtoDF + newSlice) * 2 + newParity;
                        if (getPruning(Slice_URtoDF_Parity_Prun, idx) == 0x0F) {
                            setPruning(Slice_URtoDF_Parity_Prun, idx, (byte) (depth + 1));
                            done++;
                        }
                    }
                }
            }
            depth++;
        }
    }

    private static void buildSliceTwistPrun() {
        for (int i = 0; i < Slice_Twist_Prun.length; i++) Slice_Twist_Prun[i] = -1;
        setPruning(Slice_Twist_Prun, 0, (byte) 0);
        int depth = 0, done = 1;
        int total = N_SLICE1 * N_TWIST;
        while (done != total) {
            for (int i = 0; i < total; i++) {
                int twist = i / N_SLICE1, slice = i % N_SLICE1;
                if (getPruning(Slice_Twist_Prun, i) == depth) {
                    for (int j = 0; j < 18; j++) {
                        int newSlice = (FRtoBR_Move[slice * 24][j] & 0xFFFF) / 24;
                        int newTwist = twistMove[twist][j] & 0xFFFF;
                        int idx = N_SLICE1 * newTwist + newSlice;
                        if (getPruning(Slice_Twist_Prun, idx) == 0x0F) {
                            setPruning(Slice_Twist_Prun, idx, (byte) (depth + 1));
                            done++;
                        }
                    }
                }
            }
            depth++;
        }
    }

    private static void buildSliceFlipPrun() {
        for (int i = 0; i < Slice_Flip_Prun.length; i++) Slice_Flip_Prun[i] = -1;
        setPruning(Slice_Flip_Prun, 0, (byte) 0);
        int depth = 0, done = 1;
        int total = N_SLICE1 * N_FLIP;
        while (done != total) {
            for (int i = 0; i < total; i++) {
                int flip = i / N_SLICE1, slice = i % N_SLICE1;
                if (getPruning(Slice_Flip_Prun, i) == depth) {
                    for (int j = 0; j < 18; j++) {
                        int newSlice = (FRtoBR_Move[slice * 24][j] & 0xFFFF) / 24;
                        int newFlip = flipMove[flip][j] & 0xFFFF;
                        int idx = N_SLICE1 * newFlip + newSlice;
                        if (getPruning(Slice_Flip_Prun, idx) == 0x0F) {
                            setPruning(Slice_Flip_Prun, idx, (byte) (depth + 1));
                            done++;
                        }
                    }
                }
            }
            depth++;
        }
    }
}
