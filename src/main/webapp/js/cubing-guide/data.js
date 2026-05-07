/**
 * Cubing-guide content data.
 *
 * All sections of the guide pull from these tables.  Keeping content here
 * (instead of inline in JSP scriptlets) makes the data:
 *   - searchable / filterable client-side without a server roundtrip
 *   - testable in isolation
 *   - easy to extend (add a new alg = one row in ALG_LIBRARY)
 *
 * The cube state for the "after" thumbnail of an algorithm is computed
 * client-side via moves-builder.applyMoves(SOLVED, alg.notation).  No
 * pre-baked images.
 */

// ── Notation cheat sheet ──────────────────────────────────────────────
// Each entry renders as one row in the Notation tab table.
//   move:    the WCA token (also the anchor link target → "#move-Rw")
//   meaning: short plain-English description (NOT WCA regulations text)
//   sizes:   which cube sizes this notation applies to
//   group:   for filter chips
//   alias:   alternate spellings to mention (e.g. "u" == "Uw" lowercase)

export const NOTATION = [
    // ── Outer face turns ──
    { move: 'R',   meaning: 'Right face — turn 90° clockwise (looking at it from the right side)', sizes: '3+', group: 'face' },
    { move: "R'",  meaning: 'Right face — turn 90° counter-clockwise',                              sizes: '3+', group: 'face' },
    { move: 'R2',  meaning: 'Right face — turn 180° (direction does not matter for half-turns)',    sizes: '3+', group: 'face' },
    { move: 'L',   meaning: 'Left face — 90° clockwise from the left side',                          sizes: '3+', group: 'face' },
    { move: 'U',   meaning: 'Up face — 90° clockwise from above',                                    sizes: '3+', group: 'face' },
    { move: 'D',   meaning: 'Down face — 90° clockwise from below',                                  sizes: '3+', group: 'face' },
    { move: 'F',   meaning: 'Front face — 90° clockwise from the front',                             sizes: '3+', group: 'face' },
    { move: 'B',   meaning: 'Back face — 90° clockwise from the back',                               sizes: '3+', group: 'face' },

    // ── Wide turns (2 layers) ──
    { move: 'Rw',  meaning: 'Wide R — turn the right face PLUS the slice next to it (2 layers)',    sizes: '4+', group: 'wide', alias: 'r (lowercase) or 2Rw' },
    { move: "Rw'", meaning: 'Wide R counter-clockwise (2 layers)',                                   sizes: '4+', group: 'wide' },
    { move: 'Rw2', meaning: 'Wide R 180° (2 layers)',                                                sizes: '4+', group: 'wide' },
    { move: 'Uw',  meaning: 'Wide U — top face plus the slice below it (2 layers)',                  sizes: '4+', group: 'wide', alias: 'u (lowercase) or 2Uw' },
    { move: 'Fw',  meaning: 'Wide F — front face plus the slice behind it (2 layers)',               sizes: '4+', group: 'wide', alias: 'f (lowercase)' },

    // ── Multi-layer wide ──
    { move: '3Rw', meaning: 'Wide R turn including 3 layers from the right',                         sizes: '4+', group: 'wide' },
    { move: '3Uw', meaning: 'Wide U turn including 3 layers from the top',                           sizes: '4+', group: 'wide' },
    { move: '4Rw', meaning: 'Wide R including 4 layers',                                             sizes: '5+', group: 'wide' },
    { move: '5Rw', meaning: 'Wide R including 5 layers',                                             sizes: '6+', group: 'wide' },
    { move: '6Rw', meaning: 'Wide R including 6 layers',                                             sizes: '7+', group: 'wide' },

    // ── Inner-slice (SiGN) ──
    { move: '2R',  meaning: 'Single inner slice — only the 2nd layer from the right (does NOT move the outer R face)', sizes: '4+', group: 'inner' },
    { move: '2L',  meaning: 'Single 2nd layer from the left',                                        sizes: '4+', group: 'inner' },
    { move: '3R',  meaning: 'Single 3rd layer from the right (the middle slice on a 5×5)',           sizes: '5+', group: 'inner' },
    { move: '3U',  meaning: 'Single 3rd layer from the top',                                         sizes: '5+', group: 'inner' },
    { move: '4R',  meaning: 'Single 4th layer from the right (the middle slice on a 7×7)',           sizes: '7+', group: 'inner' },

    // ── 3×3 middle slices ──
    { move: 'M',   meaning: 'Middle slice between L and R — turns in the same direction as L',       sizes: '3',  group: 'middle' },
    { move: "M'",  meaning: 'Middle slice opposite of M — same direction as R',                      sizes: '3',  group: 'middle' },
    { move: 'E',   meaning: 'Equatorial slice between U and D — turns in the same direction as D',   sizes: '3',  group: 'middle' },
    { move: 'S',   meaning: 'Standing slice between F and B — turns in the same direction as F',     sizes: '3',  group: 'middle' },

    // ── Cube rotations ──
    { move: 'x',   meaning: 'Rotate the WHOLE cube around the R-axis (in the R direction). The cube itself is just reoriented — useful inside algorithms.', sizes: '3+', group: 'rotation' },
    { move: "x'",  meaning: 'Rotate the whole cube opposite of x',                                   sizes: '3+', group: 'rotation' },
    { move: 'y',   meaning: 'Rotate the whole cube around the U-axis (in the U direction)',          sizes: '3+', group: 'rotation' },
    { move: "y'",  meaning: 'Rotate the whole cube opposite of y',                                   sizes: '3+', group: 'rotation' },
    { move: 'z',   meaning: 'Rotate the whole cube around the F-axis (in the F direction)',          sizes: '3+', group: 'rotation' },
];

// ── Algorithm library ─────────────────────────────────────────────────
// Each algorithm gets:
//   name:   common cuber name
//   alg:    the move sequence in WCA notation (whitespace-separated)
//   purpose: what it does (one short sentence)
//   tags:   for filtering (PLL, OLL, F2L, beginner, trigger, …)

export const ALG_LIBRARY = [
    // ── Triggers (basic patterns every cuber memorises) ──
    { name: 'Sexy Move',         alg: "R U R' U'",                                             purpose: '4-move trigger that cycles 3 corners. Building block for hundreds of algorithms.',                  tags: ['trigger', 'beginner'] },
    { name: 'Sledgehammer',      alg: "R' F R F'",                                             purpose: 'Mirror of sexy — useful for orienting edges and many F2L cases.',                                    tags: ['trigger'] },
    { name: 'Hedgeslammer',      alg: "F R' F' R",                                             purpose: 'Inverse of sledgehammer.',                                                                            tags: ['trigger'] },

    // ── Beginner OLL (2-look) ──
    { name: 'Cross OLL — Dot',   alg: "F R U R' U' F' f R U R' U' f'",                        purpose: 'Form the yellow cross when no edges are oriented (dot pattern).',                                    tags: ['OLL', 'beginner'] },
    { name: 'Cross OLL — L',     alg: "F R U R' U' F'",                                        purpose: 'Form the yellow cross from an L-shape of two oriented edges.',                                       tags: ['OLL', 'beginner'] },
    { name: 'Cross OLL — Bar',   alg: "f R U R' U' f'",                                        purpose: 'Form the yellow cross from a horizontal bar of two oriented edges.',                                tags: ['OLL', 'beginner'] },
    { name: 'Sune',              alg: "R U R' U R U2 R'",                                      purpose: 'Orients 3 last-layer corners. Most-recognised OLL case.',                                            tags: ['OLL', 'beginner'] },
    { name: 'Anti-Sune',         alg: "R U2 R' U' R U' R'",                                    purpose: 'Mirror of Sune — orients 3 corners the other way.',                                                  tags: ['OLL', 'beginner'] },
    { name: 'Pi',                alg: "R U2 R2 U' R2 U' R2 U2 R",                              purpose: 'Two corners twisted CW + two CCW (P-shape pattern).',                                                tags: ['OLL'] },
    { name: 'H',                 alg: "R U R' U R U' R' U R U2 R'",                            purpose: 'All four corners twisted, opposite pairs match.',                                                    tags: ['OLL'] },

    // ── Beginner PLL ──
    { name: 'T Perm',            alg: "R U R' U' R' F R2 U' R' U' R U R' F'",                 purpose: 'Swaps two adjacent corners + two adjacent edges. Most common PLL.',                                  tags: ['PLL', 'beginner'] },
    { name: 'Y Perm',            alg: "F R U' R' U' R U R' F' R U R' U' R' F R F'",           purpose: 'Swaps two diagonal corners + two adjacent edges.',                                                  tags: ['PLL', 'beginner'] },
    { name: 'Ja Perm',           alg: "R' U L' U2 R U' R' U2 R L",                             purpose: 'Cycles 3 corners + 3 edges (one direction).',                                                       tags: ['PLL'] },
    { name: 'Jb Perm',           alg: "R U R' F' R U R' U' R' F R2 U' R' U'",                 purpose: 'Cycles 3 corners + 3 edges (the other direction).',                                                 tags: ['PLL'] },
    { name: 'Aa Perm',           alg: "x R' U R' D2 R U' R' D2 R2 x'",                         purpose: 'Cycles 3 corners (clockwise) — leaves all edges fixed.',                                            tags: ['PLL'] },
    { name: 'Ab Perm',           alg: "x' R U' R D2 R' U R D2 R2 x",                           purpose: 'Cycles 3 corners (counter-clockwise) — leaves edges fixed.',                                        tags: ['PLL'] },
    { name: 'Ua Perm',           alg: "R U' R U R U R U' R' U' R2",                            purpose: 'Cycles 3 last-layer edges (clockwise) — corners unchanged.',                                        tags: ['PLL', 'beginner'] },
    { name: 'Ub Perm',           alg: "R2 U R U R' U' R' U' R' U R'",                          purpose: 'Cycles 3 last-layer edges (counter-clockwise).',                                                    tags: ['PLL', 'beginner'] },
    { name: 'H Perm',            alg: "M2 U M2 U2 M2 U M2",                                    purpose: 'Swaps the 4 last-layer edges in two opposite pairs. Very short via M-slices.',                       tags: ['PLL'] },
    { name: 'Z Perm',            alg: "M2 U M2 U M' U2 M2 U2 M' U2",                           purpose: 'Swaps the 4 last-layer edges in two adjacent pairs.',                                              tags: ['PLL'] },

    // ── Big-cube parity ──
    { name: 'OLL Parity (4×4)',  alg: "Rw U2 Rw U2 Rw U2 Rw U2 Rw U2 Rw",                      purpose: 'Flips a single edge on a 4×4. Can\'t happen on a 3×3 — caused by edge-pairing during reduction.',  tags: ['parity', 'big'] },
    { name: 'PLL Parity (4×4)',  alg: "2R2 U2 2R2 Uw2 2R2 Uw2",                                purpose: 'Swaps two edges on a 4×4. Solved 3×3 looks like a single PLL swap that 3×3 algs can\'t fix.',     tags: ['parity', 'big'] },

    // ── F2L examples ──
    { name: 'F2L — basic insert', alg: "U R U' R'",                                            purpose: 'Insert a corner-edge pair from the top into the front-right slot.',                                  tags: ['F2L', 'beginner'] },
    { name: 'F2L — back insert',  alg: "U' L' U L",                                            purpose: 'Insert into the front-left slot from the top.',                                                     tags: ['F2L', 'beginner'] },
];

// ── Beginner LBL stages ───────────────────────────────────────────────
// Each stage describes one major step of the layer-by-layer method.
// The "goalState" is the cube state after that stage is complete; we
// generate the cube net automatically.

export const LBL_STAGES = [
    {
        name: '1. White Cross',
        goal: 'Form a + shape on the bottom (we use white) with each cross-edge matching the centre of its side face.',
        tip: 'Solve the white edges one at a time. Look at the white center, find each white edge, get its non-white sticker matching the side colour, then bring it down.',
        algs: [],
    },
    {
        name: '2. White Corners (First Layer)',
        goal: 'Place all 4 white corners — completes the first layer.',
        tip: 'Find a white corner in the top layer, put it directly above where it belongs, then use the trigger R U R\' U\' (or its mirror) until the corner drops in correctly.',
        algs: [{ name: 'Right insert', alg: "R U R' U'" }, { name: 'Left insert', alg: "L' U' L U" }],
    },
    {
        name: '3. Middle-Layer Edges',
        goal: 'Solve the 4 edges of the middle layer — completes the first two layers (F2L).',
        tip: 'Find a top-layer edge with NO yellow on it. Match its top sticker to its side centre, then send it RIGHT (URUR\' U\' F\' U\' F) or LEFT (U\' L\' U\' L U F U F\').',
        algs: [
            { name: 'Edge → right slot', alg: "U R U' R' U' F' U F" },
            { name: 'Edge → left slot',  alg: "U' L' U L U F U' F'" },
        ],
    },
    {
        name: '4. Yellow Cross (OLL Edges)',
        goal: 'Make a yellow + on top — only the edges have to be oriented (corners can be twisted).',
        tip: 'There are 3 starting cases: dot (no edges), L (2 adjacent edges), bar (2 opposite edges). Apply F R U R\' U\' F\' the right number of times.',
        algs: [{ name: 'OLL edges trigger', alg: "F R U R' U' F'" }],
    },
    {
        name: '5. Orient Yellow Corners',
        goal: 'Get all 4 last-layer corners showing yellow on top (corners may be in wrong positions — fixed in step 7).',
        tip: 'Hold a yellow-top corner at front-left, then repeat R\' D\' R D until that one corner is yellow-up. Rotate top to bring the next non-yellow corner to front-left, repeat.',
        algs: [{ name: 'Twist corner', alg: "R' D' R D" }],
    },
    {
        name: '6. Permute Yellow Corners (PLL Corners)',
        goal: 'Move the 4 last-layer corners to their correct positions (all 4 corners now in place).',
        tip: 'Find a corner that\'s already in the right spot (any orientation). Hold it at back-right. Apply the corner cycle until they all match. If no corner is correct, run the alg from any face — one will land.',
        algs: [{ name: 'Corner cycle (Aa)', alg: "x R' U R' D2 R U' R' D2 R2 x'" }],
    },
    {
        name: '7. Permute Yellow Edges (PLL Edges)',
        goal: 'Cycle the 4 last-layer edges into their final positions — solved!',
        tip: 'If 1 edge is already correct, hold it at the back and apply Ua or Ub. If no edges are correct, apply either Ua/Ub once from any face — one edge will line up, then re-check.',
        algs: [
            { name: 'Ua (CW edge cycle)',  alg: "R U' R U R U R U' R' U' R2" },
            { name: 'Ub (CCW edge cycle)', alg: "R2 U R U R' U' R' U' R' U R'" },
        ],
    },
];

// ── Speedcubing / CFOP overview ───────────────────────────────────────

export const CFOP_PHASES = [
    {
        name: 'Cross',
        goal: 'Solve all 4 white edges intuitively in 7 moves or fewer (no algorithms — pure visualisation).',
        tip: 'Plan the entire cross during inspection (15 seconds at competitions). Aim to do it on the bottom (white at D) so you can immediately see your F2L pairs.',
    },
    {
        name: 'F2L (First Two Layers)',
        goal: 'Solve corner-edge pairs into their slots — 4 pairs, ideally one alg each. 41 cases total but you only need to recognise the patterns.',
        tip: 'Start by drilling the "easy" cases (corner+edge already paired). The "trigger" cases — where you can sledgehammer or sexy-move them in — are the highest-value to memorise.',
    },
    {
        name: 'OLL (Orient Last Layer)',
        goal: 'Make all of the last layer\'s top stickers match the top colour. 57 cases in full OLL; 10 cases in 2-look OLL.',
        tip: 'Beginners learn 2-look OLL (10 algs total: 3 for edges, 7 for corners). Sub-20 solvers move to full 1-look OLL (57 algs).',
    },
    {
        name: 'PLL (Permute Last Layer)',
        goal: 'Cycle the last layer\'s pieces into their solved positions. 21 cases in full PLL; 6 cases in 2-look PLL.',
        tip: 'PLL recognition is mostly about spotting headlights (pairs of matching corner stickers) and bars (3-in-a-row). Drill recognition separately from execution.',
    },
];

// ── Big cubes / reduction method ──────────────────────────────────────

export const BIG_CUBE_STAGES = [
    {
        name: '1. Centres',
        goal: 'Solve the 4 centre-stickers of each face into a solid block (e.g. all white centres on top).',
        tip: 'Start with two opposite centres (e.g. white + yellow). Then build the remaining 4 in a "belt". Common moves: r U r\' (centre commutator).',
    },
    {
        name: '2. Edge Pairing',
        goal: 'Pair each pair of adjacent edge-pieces into a single 3×3-style edge (24 stickers → 12 logical edges).',
        tip: 'Use the "slice & flip" technique: bring two matching wing-edges to opposite slots, slice (Uw), undo, then slice back. The "freeslice" method pairs multiple edges at once.',
    },
    {
        name: '3. Reduce to 3×3',
        goal: 'After centres + edges are done, the cube behaves like a 3×3 — solve with normal CFOP/LBL.',
        tip: 'You CAN encounter parity (next stage). Don\'t use wide turns from this point on or you\'ll mess up the centres/edges.',
    },
    {
        name: '4. OLL Parity',
        goal: 'When solving the 3×3 stage, you may get a single flipped edge — impossible on a real 3×3 but happens on 4×4+ because edge-pairing can mis-orient one pair.',
        tip: 'Recognise: yellow OLL with one edge flipped (looks like dot OLL but the L-shape is impossible). Apply: Rw U2 Rw U2 Rw U2 Rw U2 Rw U2 Rw.',
    },
    {
        name: '5. PLL Parity',
        goal: 'Two edges swapped at the end — looks like an impossible 3×3 PLL.',
        tip: 'Recognise: looks like the start of a J-perm but two edges are swapped. Apply: 2R2 U2 2R2 Uw2 2R2 Uw2 (4×4 specific).',
    },
];

// ── Glossary ──────────────────────────────────────────────────────────

export const GLOSSARY = [
    { term: 'WCA',     def: 'World Cube Association — sets official rules and notation.' },
    { term: 'CFOP',    def: 'Cross / F2L / OLL / PLL — the dominant speedsolving method (also called Fridrich after Jessica Fridrich).' },
    { term: 'LBL',     def: 'Layer By Layer — beginner method that solves the cube one layer at a time.' },
    { term: 'F2L',     def: 'First Two Layers — pairing and inserting corner-edge pairs simultaneously (CFOP\'s second stage).' },
    { term: 'OLL',     def: 'Orient Last Layer — making the top face all one colour. 57 cases full / 10 cases 2-look.' },
    { term: 'PLL',     def: 'Permute Last Layer — moving last-layer pieces to their solved positions. 21 cases full / 6 cases 2-look.' },
    { term: 'COLL',    def: 'Corners of the Last Layer — orient AND permute the corners in one step (42 algs).' },
    { term: 'ZBLL',    def: 'Zborowski-Bruchem Last Layer — solve LL in one step after EO (493 algs).' },
    { term: 'Roux',    def: 'Method built around two 1×2×3 blocks + CMLL + L6E (alternative to CFOP).' },
    { term: 'ZZ',      def: 'Method that orients all edges before solving F2L (alternative to CFOP).' },
    { term: 'EO',      def: 'Edge Orientation — pre-orienting edges so all later moves can be done with R, U, L moves only.' },
    { term: 'BLD',     def: 'Blindfolded — solve the cube without looking after memorising it.' },
    { term: 'OH',      def: 'One-Handed — only one hand allowed; separate WCA event.' },
    { term: 'FMC',     def: 'Fewest Moves Count — solve with the SHORTEST move sequence in 1 hour.' },
    { term: 'AUF',     def: 'Adjust Upper Face — a free U-turn at the end of an alg to align the last layer.' },
    { term: 'sub-X',   def: 'Averaging UNDER X seconds (e.g. "sub-20" = average under 20 s).' },
    { term: 'AO5/AO12', def: 'Average of 5 / 12 — drop the best and worst, mean of the rest. Standard WCA result format.' },
    { term: 'PB',      def: 'Personal Best.' },
    { term: 'WR',      def: 'World Record.' },
    { term: 'DNF',     def: 'Did Not Finish — a botched solve (penalty in WCA).' },
    { term: '+2',      def: '2-second penalty (e.g. cube dropped, last move not aligned).' },
    { term: 'Reduction', def: 'Big-cube technique: solve centres + pair edges, then treat as a 3×3.' },
    { term: 'Parity',  def: 'Big-cube edge case where the cube ends in a state impossible on a 3×3 — needs a special alg.' },
    { term: 'Trigger', def: 'Short combo (3-4 moves) that\'s memorised as one chunk — e.g. "sexy" = R U R\' U\'.' },
    { term: 'Headlights', def: 'Pair of matching corner stickers on the same side of the last layer — key PLL recognition cue.' },
    { term: 'Inspection', def: 'The 15-second pre-solve look in WCA competitions.' },
    { term: 'God\'s Number', def: '20 — proved in 2010 as the maximum number of face-turns needed to solve any 3×3 state.' },
    { term: 'Fingertricks', def: 'Efficient finger-flicks (often using thumbs and index fingers) for fast alg execution.' },
    { term: 'Magnets', def: 'Modern speedcubes have small magnets in each piece for tactile alignment feedback.' },
];

// ── Color schemes ─────────────────────────────────────────────────────

export const COLOR_SCHEMES = [
    {
        name: 'Western (BOY)',
        common: 'Most common worldwide. Standard for WCA cubes shipped from speedcube vendors.',
        layout: { U: 'White', D: 'Yellow', F: 'Green', B: 'Blue', R: 'Red', L: 'Orange' },
        mnemonic: 'BOY = Blue, Orange, Yellow are arranged clockwise around one corner. Equivalently: Yellow opposite White, Green opposite Blue, Red opposite Orange.',
    },
    {
        name: 'Japanese',
        common: 'Older standard. Some Japanese cubes still ship with this; rare in competitive play.',
        layout: { U: 'White', D: 'Blue', F: 'Green', B: 'Yellow', R: 'Red', L: 'Orange' },
        mnemonic: 'White opposite Blue, Green opposite Yellow.',
    },
    {
        name: 'Stickerless',
        common: 'Modern speedcubes have coloured plastic instead of stickers — never peel or fade. Same colour layout as Western (BOY).',
        layout: { U: 'White', D: 'Yellow', F: 'Green', B: 'Blue', R: 'Red', L: 'Orange' },
        mnemonic: 'Same as Western — but the colour IS the plastic, not a sticker on top.',
    },
];
