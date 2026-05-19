/*
 * biology/js/dna-page.js
 *
 * Page controller for biology/dna-viewer.jsp. Wires the form (sequence
 * input, presets) and toolbar to the three.js scene module (DnaScene),
 * manages the right-rail base-pair details, and handles the lazy load
 * of 3Dmol.js for the "Real Structure (PDB)" tab.
 *
 * Kept vanilla so it can drop into any JSP without a build step.
 */
(function () {
    "use strict";

    // ---------- Biology metadata for base pairs ----------
    var BASE_INFO = {
        A: {
            name: "Adenine",
            type: "Purine",
            pairsWith: "T",
            bonds: 2,
            note: "A purine — fused two-ring nitrogenous base. Adenine pairs with thymine via two hydrogen bonds, making A-T pairs slightly less stable than G-C pairs.",
            fact: "Adenine also appears in ATP, ADP, and AMP — the cell's main energy currency."
        },
        T: {
            name: "Thymine",
            type: "Pyrimidine",
            pairsWith: "A",
            bonds: 2,
            note: "A pyrimidine — single six-membered ring. Thymine pairs only with adenine via two hydrogen bonds. RNA replaces thymine with uracil.",
            fact: "Thymine is the only DNA base that's not also found in RNA — RNA uses uracil instead."
        },
        G: {
            name: "Guanine",
            type: "Purine",
            pairsWith: "C",
            bonds: 3,
            note: "A purine like adenine. Guanine pairs with cytosine via three hydrogen bonds, which is why GC-rich DNA regions have higher melting temperatures.",
            fact: "Guanine's name comes from guano (bird droppings) — where it was first isolated in 1844."
        },
        C: {
            name: "Cytosine",
            type: "Pyrimidine",
            pairsWith: "G",
            bonds: 3,
            note: "A pyrimidine. Cytosine pairs with guanine via three hydrogen bonds. It can also be methylated to 5-methylcytosine — the most common epigenetic modification.",
            fact: "Spontaneous deamination of cytosine produces uracil — one of the most common sources of mutation, and the reason DNA uses thymine instead of uracil."
        },
        U: {
            name: "Uracil",
            type: "Pyrimidine (RNA)",
            pairsWith: "A",
            bonds: 2,
            note: "Uracil replaces thymine in RNA. Pairs with adenine via 2 H-bonds, just like T does. Lacks the methyl group T has on its 5' carbon — that single difference makes RNA chemically distinct from DNA.",
            fact: "Uracil's structural simplicity (relative to thymine) is thought to be why early life used RNA before DNA evolved."
        },
        N: {
            name: "Any base (N)",
            type: "IUPAC ambiguity",
            pairsWith: "N",
            bonds: 2,
            note: "N is the IUPAC code for an unknown or unspecified base — could be A, T, G, or C. Common in shotgun sequencing reads where the basecaller wasn't confident.",
            fact: "Reference genomes still contain stretches of Ns where the sequence couldn't be resolved — even the human genome has ~30 Mb of N gaps."
        },
        R: { name: "Purine (R)",     type: "IUPAC: A or G", pairsWith: "Y", bonds: 2, note: "R = puRine. Either adenine or guanine — both 2-ring structures.", fact: "All life uses just two purines (A, G) and two pyrimidines (C, T/U) — a coincidence that's never been fully explained." },
        Y: { name: "Pyrimidine (Y)", type: "IUPAC: C or T", pairsWith: "R", bonds: 2, note: "Y = pYrimidine. Either cytosine or thymine — both single-ring structures.", fact: "C-to-T transitions (Y class) are the most common substitution mutation in mammalian genomes." },
        S: { name: "Strong (S)",     type: "IUPAC: G or C", pairsWith: "S", bonds: 3, note: "S = Strong pair (G-C, 3 H-bonds). GC-rich regions resist melting.", fact: "Mycobacterium tuberculosis has ~65% GC content — one of the most S-rich genomes known." },
        W: { name: "Weak (W)",       type: "IUPAC: A or T", pairsWith: "W", bonds: 2, note: "W = Weak pair (A-T, 2 H-bonds). AT-rich regions denature first.", fact: "Plasmodium falciparum (malaria) genome is ~80% AT — one of the most W-rich known." },
        K: { name: "Keto (K)",       type: "IUPAC: G or T", pairsWith: "M", bonds: 2, note: "K = Keto bases (both G and T have a keto group at C2).", fact: "" },
        M: { name: "Amino (M)",      type: "IUPAC: A or C", pairsWith: "K", bonds: 2, note: "M = aMino bases (both A and C have an amino group at C4/C6).", fact: "" },
        B: { name: "Not A (B)",      type: "IUPAC: C, G, or T", pairsWith: "V", bonds: 2, note: "B = anything except A.", fact: "" },
        D: { name: "Not C (D)",      type: "IUPAC: A, G, or T", pairsWith: "H", bonds: 2, note: "D = anything except C.", fact: "" },
        H: { name: "Not G (H)",      type: "IUPAC: A, C, or T", pairsWith: "D", bonds: 2, note: "H = anything except G.", fact: "" },
        V: { name: "Not T (V)",      type: "IUPAC: A, C, or G", pairsWith: "B", bonds: 2, note: "V = anything except T.", fact: "" }
    };

    // Pull context path from the <meta name="ctx"> tag so endpoint URLs
    // work under any servlet context (root, /mywebapp2, etc.).
    var CTX = (function () {
        var m = document.querySelector('meta[name="ctx"]');
        return (m && m.content) ? m.content : "";
    })();
    var TUTOR_ENDPOINT = CTX + "/ai";

    // ---------- Element refs ----------
    function $(id) { return document.getElementById(id); }
    var canvas      = $("dnaCanvas");
    var seqInput    = $("dnaSeqInput");
    var seqStats    = $("dnaSeqStats");
    var stageTitle  = $("dnaStageTitle");
    var stageInfo   = $("dnaStageInfo");
    var rotateBtn   = $("dnaRotateBtn");
    var labelsBtn   = $("dnaLabelsBtn");
    var isolateBtn  = $("dnaIsolateBtn");
    var resetBtn    = $("dnaResetBtn");
    var screenshotBtn = $("dnaScreenshotBtn");
    var shareBtn    = $("dnaShareBtn");
    var printBtn    = $("dnaPrintBtn");
    var legendEl    = $("dnaLegend");
    var bpOrb       = $("dnaBpOrb");
    var bpName      = $("dnaBpName");
    var bpSubtitle  = $("dnaBpSubtitle");
    var bpAttrs     = $("dnaBpAttrs");
    var bpNote      = $("dnaBpNote");
    var bpFact      = $("dnaBpFact");
    var tabStudio   = $("dnaTabStudio");
    var tabLinear   = $("dnaTabLinear");
    var studioGrid  = $("dnaStudio");
    var linearGrid  = $("dnaLinear");

    // Tutor
    var tutorOutput = $("dnaTutorOutput");
    var tutorMeta   = $("dnaTutorMeta");
    var tutorBody   = $("dnaTutorBody");
    var tutorForm   = $("dnaTutorForm");
    var tutorInput  = $("dnaTutorInput");
    var promptList  = $("dnaPromptList");

    // Analysis panel
    var motifInput   = $("dnaMotifInput");
    var motifClear   = $("dnaMotifClear");
    var motifStatus  = $("dnaMotifStatus");
    var mismatchRow  = $("dnaMismatchRow");
    var mismatchBtn  = $("dnaMismatchBtn");
    var mismatchInfo = $("dnaMismatchInfo");
    var compareHint  = $("dnaCompareHint");
    var statsList    = $("dnaStatsList");

    /* ---------- Workbench tab switcher (Input/Stats/Search/Compare) ----------
       Mirrors Benchling-style tabbed sidebar: only one analysis context
       visible at a time. Active tab persists in localStorage. */
    var RAIL_TAB_KEY = "biology.dna.railTab";
    function railTabStorage() {
        try { return localStorage.getItem(RAIL_TAB_KEY) || "input"; } catch (e) { return "input"; }
    }
    function saveRailTab(t) {
        try { localStorage.setItem(RAIL_TAB_KEY, t); } catch (e) {}
    }
    function showRailTab(name) {
        document.querySelectorAll('.dna-rail-tab').forEach(function (b) {
            var match = b.getAttribute('data-rail-tab') === name;
            b.classList.toggle('is-active', match);
            b.setAttribute('aria-selected', match ? 'true' : 'false');
        });
        document.querySelectorAll('.dna-rail-tab-content').forEach(function (c) {
            c.hidden = c.getAttribute('data-rail-tab') !== name;
        });
        saveRailTab(name);
        // Focus the search input when the Search tab opens, so the user
        // can type immediately.
        if (name === 'search' && motifInput) {
            setTimeout(function () { motifInput.focus(); }, 50);
        }
    }
    document.querySelectorAll('.dna-rail-tab').forEach(function (btn) {
        btn.addEventListener('click', function () {
            showRailTab(btn.getAttribute('data-rail-tab'));
        });
    });

    // ---------- State ----------
    // `raw` is the verbatim textarea contents (preserves user newlines /
    // formatting for the share URL). `sequences` is the parsed, sanitized
    // array of A/T/G/C strings fed to the scene. activeKey is either
    // null or "s{seqIndex}-bp{bpIndex}".
    var state = {
        raw: "ATCGATCGATGCATGCATCG",
        sequences: ["ATCGATCGATGCATGCATCG"],
        activeKey: null,
        viewMode: "mesh",
        labelsVisible: false,
        // Auto-rotate ON by default — gives first-paint visual feedback
        // that the helix is 3D and interactive. Auto-pauses on the
        // first base-pair click so the user can read details without
        // the helix moving (see onPick handler).
        autoRotate: true,
        motif: "",                  // current substring to find
        showMismatches: false       // toggle (only meaningful when all seqs same length)
    };

    /* parseActiveKey — "s2-bp7" → {seq:2, bp:7}; null on miss. */
    function parseActiveKey(key) {
        if (!key) return null;
        var m = /^s(\d+)-bp(\d+)$/.exec(key);
        if (!m) return null;
        return { seq: parseInt(m[1], 10), bp: parseInt(m[2], 10) };
    }

    /* ---------- Sequence analysis primitives ----------
       Full IUPAC + RNA + gap support. Canonical bases get their colors
       and Watson-Crick complements; ambiguity codes (N/R/Y/...) get the
       neutral gray; U (RNA) is treated as T for codon lookup / GC /
       complement; gap characters (- and .) are preserved through
       revcomp but ignored by translate / gc / tm. */
    var COMPLEMENT = {
        A: "T", T: "A", G: "C", C: "G", U: "A",
        R: "Y", Y: "R", S: "S", W: "W", K: "M", M: "K",
        B: "V", V: "B", D: "H", H: "D", N: "N",
        "-": "-", ".": "."
    };

    // Standard genetic code (table 1) — DNA codons → 1-letter amino acid.
    // Stop codons render as '*'. T-flavor for DNA, U-flavor would be RNA.
    var CODON_TABLE = {
        TTT:"F",TTC:"F",TTA:"L",TTG:"L", TCT:"S",TCC:"S",TCA:"S",TCG:"S",
        TAT:"Y",TAC:"Y",TAA:"*",TAG:"*", TGT:"C",TGC:"C",TGA:"*",TGG:"W",
        CTT:"L",CTC:"L",CTA:"L",CTG:"L", CCT:"P",CCC:"P",CCA:"P",CCG:"P",
        CAT:"H",CAC:"H",CAA:"Q",CAG:"Q", CGT:"R",CGC:"R",CGA:"R",CGG:"R",
        ATT:"I",ATC:"I",ATA:"I",ATG:"M", ACT:"T",ACC:"T",ACA:"T",ACG:"T",
        AAT:"N",AAC:"N",AAA:"K",AAG:"K", AGT:"S",AGC:"S",AGA:"R",AGG:"R",
        GTT:"V",GTC:"V",GTA:"V",GTG:"V", GCT:"A",GCC:"A",GCA:"A",GCG:"A",
        GAT:"D",GAC:"D",GAA:"E",GAG:"E", GGT:"G",GGC:"G",GGA:"G",GGG:"G"
    };

    function reverseComplement(seq) {
        var out = "";
        for (var i = seq.length - 1; i >= 0; i--) {
            out += (COMPLEMENT[seq[i]] || "N");
        }
        return out;
    }

    /* translate — handles RNA (U→T conversion done inline) and skips
       gap characters. Ambiguous codes that would produce a codon with
       any non-ATGC base render as '?'. Trailing 1-2 nt are dropped. */
    function translate(seq) {
        // Strip gaps first so the reading frame is preserved across them.
        var noGap = seq.replace(/[-.]/g, "");
        // RNA → DNA for codon lookup.
        var dna = noGap.replace(/U/g, "T");
        var out = "";
        for (var i = 0; i + 3 <= dna.length; i += 3) {
            out += CODON_TABLE[dna.substr(i, 3)] || "?";
        }
        return out;
    }

    /* gcOf — GC% computed over canonical bases only. Ambiguity codes
       and gaps are excluded from the denominator (so a sequence of
       NNNN gives 0% with no NaN). S (strong = G/C) counts as GC; W
       (weak = A/T) doesn't. */
    function gcOf(seq) {
        var gc = 0, atgc = 0;
        for (var i = 0; i < seq.length; i++) {
            var c = seq[i];
            if (c === "G" || c === "C" || c === "S") { gc++; atgc++; }
            else if (c === "A" || c === "T" || c === "U" || c === "W") { atgc++; }
        }
        return atgc === 0 ? 0 : Math.round((gc / atgc) * 100);
    }

    /* Tm — melting temperature.
     *   ≤13 nt:  Wallace rule  Tm = 4(G+C) + 2(A+T)
     *   >13 nt:  Howley formula Tm = 64.9 + 41*(GC - 16.4)/N
     * Both give a reasonable single-number estimate without a lookup
     * table. For research-grade nearest-neighbor Tm, the lazy `bioseq`
     * loader (below) will eventually swap this in. */
    function tmOf(seq) {
        if (!seq.length) return 0;
        // Only canonical bases contribute. U is treated as T (RNA = DNA
        // for Tm purposes here, close enough for visualization).
        var gc = 0, at = 0;
        for (var i = 0; i < seq.length; i++) {
            var c = seq[i];
            if (c === "G" || c === "C") gc++;
            else if (c === "A" || c === "T" || c === "U") at++;
        }
        var n = gc + at;
        if (n === 0) return 0;
        if (n <= 13) return 4 * gc + 2 * at;
        return Math.round(64.9 + 41 * (gc - 16.4) / n);
    }

    /* findMotifHits — case-sensitive exact-substring search. Returns
     * array of { seq, start, end } where end is exclusive. */
    function findMotifHits(motif, sequences) {
        if (!motif) return [];
        motif = motif.toUpperCase();
        var hits = [];
        for (var s = 0; s < sequences.length; s++) {
            var seq = sequences[s];
            var i = 0;
            while ((i = seq.indexOf(motif, i)) !== -1) {
                hits.push({ seq: s, start: i, end: i + motif.length });
                i += 1;  // allow overlapping matches
            }
        }
        return hits;
    }

    /* findOrfs — locates Open Reading Frames in all three forward frames.
     * An ORF runs from an ATG (start codon) to the next in-frame stop
     * codon (TAA, TAG, TGA). Returns ORFs whose length meets minCodons.
     * Used to draw "ORF 1/2/3" feature bars in the seqviz linear view,
     * matching the reference demo's auto-detected ORF strip. */
    function findOrfs(seq, minCodons) {
        minCodons = minCodons || 20;
        var orfs = [];
        var dna = seq.toUpperCase().replace(/U/g, "T").replace(/[^ATGC]/g, "");
        for (var frame = 0; frame < 3; frame++) {
            var orfStart = -1;
            for (var i = frame; i + 3 <= dna.length; i += 3) {
                var codon = dna.substr(i, 3);
                if (codon === "ATG" && orfStart === -1) {
                    orfStart = i;
                } else if (orfStart !== -1 && (codon === "TAA" || codon === "TAG" || codon === "TGA")) {
                    if ((i - orfStart) / 3 >= minCodons) {
                        orfs.push({ start: orfStart, end: i + 3, frame: frame + 1 });
                    }
                    orfStart = -1;
                }
            }
        }
        return orfs;
    }

    /* findMismatches — only meaningful when all sequences have the same
     * length. Returns array of { seq, pos } for every position that
     * isn't identical across all sequences. Empty if sequences differ
     * in length (mismatch highlighting is disabled in that case). */
    function findMismatches(sequences) {
        if (sequences.length < 2) return [];
        var len = sequences[0].length;
        for (var i = 1; i < sequences.length; i++) {
            if (sequences[i].length !== len) return [];
        }
        var out = [];
        for (var p = 0; p < len; p++) {
            var ref = sequences[0][p];
            var allMatch = true;
            for (var s = 1; s < sequences.length; s++) {
                if (sequences[s][p] !== ref) { allMatch = false; break; }
            }
            if (!allMatch) {
                for (var s2 = 0; s2 < sequences.length; s2++) out.push({ seq: s2, pos: p });
            }
        }
        return out;
    }

    var sceneController = null;

    // ---------- Presets ----------
    // Each preset returns the raw textarea string. Multi-line strings
    // produce multiple side-by-side helices.
    var PRESETS = {
        random: function () {
            var bases = "ATGC";
            var s = "";
            var len = 20;
            for (var i = 0; i < len; i++) s += bases[Math.floor(Math.random() * 4)];
            return s;
        },
        tata: function () {
            return "CGCGTATAAAAGGGCGCG";
        },
        palindrome: function () {
            return "GCGCGAATTCGCGC";
        },
        pair: function () {
            // Wild-type vs. mutant comparison — same length, single
            // SNP at position 11 (T → A). Two helices side-by-side.
            return ">wild-type\nATCGATCGATTGCATGCATCG\n>mutant\nATCGATCGAATGCATGCATCG";
        },
        trio: function () {
            // Three short helices to demonstrate the multi-sequence layout.
            return ">seq-1\nATCGATCG\n>seq-2\nGGGGCCCC\n>seq-3\nTATATATA";
        },
        clear: function () { return ""; }
    };

    // ---------- Sequence parsing + render ----------
    function parseSeqs(raw) {
        return window.DnaScene.parseSequences(raw, { maxBpPerSeq: 64, maxSeqs: 6 });
    }

    function gcContent(seq) {
        if (!seq.length) return 0;
        var gc = 0;
        for (var i = 0; i < seq.length; i++) {
            if (seq[i] === "G" || seq[i] === "C") gc++;
        }
        return Math.round((gc / seq.length) * 100);
    }

    function totalBp() {
        var total = 0;
        for (var i = 0; i < state.sequences.length; i++) {
            total += state.sequences[i].length;
        }
        return total;
    }
    function totalGc() {
        var gc = 0, total = 0;
        for (var i = 0; i < state.sequences.length; i++) {
            var seq = state.sequences[i];
            total += seq.length;
            for (var j = 0; j < seq.length; j++) {
                if (seq[j] === "G" || seq[j] === "C") gc++;
            }
        }
        return total === 0 ? 0 : Math.round((gc / total) * 100);
    }

    function updateSeqStats() {
        if (!seqStats) return;
        var bp = totalBp();
        if (bp === 0) {
            seqStats.textContent = "Empty — paste A/T/G/C (one sequence per line).";
            updateNonCanonicalBanner();
            return;
        }
        var n = state.sequences.length;
        var parts = [
            n + " sequence" + (n === 1 ? "" : "s"),
            bp + " position" + (bp === 1 ? "" : "s") + " total",
            totalGc() + "% GC"
        ];
        seqStats.textContent = parts.join(" · ");
        updateNonCanonicalBanner();
    }

    /* Show a small explainer when the user pasted IUPAC ambiguity codes,
       RNA (U), or alignment gaps. Stays hidden for plain ATGC. */
    function updateNonCanonicalBanner() {
        var bannerEl = $("dnaSeqNonCanonical");
        if (!bannerEl) return;
        var stats = window.DnaScene.sequenceStats(state.sequences.join(""));
        var notes = [];
        if (stats.rna > 0)       notes.push(stats.rna + " U (RNA) treated as T");
        if (stats.ambiguous > 0) notes.push(stats.ambiguous + " ambiguous (N/R/Y/&hellip;) rendered gray");
        if (stats.gap > 0)       notes.push(stats.gap + " gap" + (stats.gap === 1 ? "" : "s") + " shown as break" + (stats.gap === 1 ? "" : "s"));
        if (notes.length === 0) {
            bannerEl.hidden = true;
            bannerEl.innerHTML = "";
        } else {
            bannerEl.hidden = false;
            bannerEl.innerHTML = "<strong>Non-canonical input:</strong> " + notes.join(" · ");
        }
    }

    function pushSceneState() {
        if (!sceneController) return;
        sceneController.update({
            sequences: state.sequences,
            activeKey: state.activeKey,
            viewMode: state.viewMode,
            labelsVisible: state.labelsVisible,
            autoRotate: state.autoRotate,
            highlightSet: computeHighlightSet()
        });
    }

    function setRawInput(raw) {
        state.raw = raw == null ? "" : String(raw);
        state.sequences = parseSeqs(state.raw);
        // If the active base pair points past the end of its sequence
        // (e.g., user shortened the line), clear it.
        var ak = parseActiveKey(state.activeKey);
        if (ak) {
            var seq = state.sequences[ak.seq];
            if (!seq || ak.bp >= seq.length) state.activeKey = null;
        }
        if (seqInput && seqInput.value !== state.raw) seqInput.value = state.raw;
        updateSeqStats();
        renderLegend();
        renderAnalysis();
        renderActiveBp();
        pushSceneState();
        updateUrlState();
        // If the Linear tab is open, keep seqviz in sync with the new input.
        if (linearGrid && !linearGrid.hidden) refreshSeqviz();
    }

    // ---------- Right rail: active base-pair details ----------
    function renderActiveBp() {
        if (!bpName) return;
        var ak = parseActiveKey(state.activeKey);
        var seq = ak ? state.sequences[ak.seq] : null;
        if (!ak || !seq || ak.bp >= seq.length) {
            bpOrb.style.background = "var(--ca-muted)";
            bpName.textContent = "Pick a base pair";
            bpSubtitle.textContent = "Click any rung in the helix to inspect it.";
            bpAttrs.innerHTML = "";
            bpNote.textContent = "";
            bpFact.textContent = "";
            return;
        }
        var letter = seq[ak.bp];
        // Gaps shouldn't be clickable (we skip rung meshes), but guard anyway.
        if (letter === "-" || letter === ".") {
            bpName.textContent = "Gap at position " + (ak.bp + 1);
            bpSubtitle.textContent = "Alignment gap — no base present.";
            bpAttrs.innerHTML = "";
            bpNote.textContent = "";
            bpFact.textContent = "";
            return;
        }
        var info = BASE_INFO[letter] || BASE_INFO["N"];
        var color = window.DnaScene.BASE_COLOR[letter] || window.DnaScene.AMBIGUOUS_COLOR;
        var pairsWithInfo = BASE_INFO[info.pairsWith] || BASE_INFO["N"];
        var seqLabel = "Seq " + (ak.seq + 1);
        bpOrb.style.background = color;
        bpName.textContent = seqLabel + " · Base Pair #" + (ak.bp + 1) +
                             " — " + info.name + " (" + letter + ")";
        bpSubtitle.textContent = info.type + " · pairs with " + pairsWithInfo.name +
                                 " (" + info.pairsWith + ") via " + info.bonds + " H-bonds";
        bpAttrs.innerHTML =
            '<div><dt>Sequence</dt><dd>' + seqLabel + ' (' + seq.length + ' bp)</dd></div>' +
            '<div><dt>Position</dt><dd>' + (ak.bp + 1) + ' of ' + seq.length + '</dd></div>' +
            '<div><dt>Type</dt><dd>' + info.type + '</dd></div>' +
            '<div><dt>Pairs with</dt><dd>' + info.pairsWith + ' (' + pairsWithInfo.name + ')</dd></div>' +
            '<div><dt>H-bonds</dt><dd>' + info.bonds + '</dd></div>' +
            '<div><dt>Stability</dt><dd>' + (info.bonds === 3 ? "Higher (GC)" : "Lower (AT)") + '</dd></div>';
        bpNote.textContent = info.note;
        bpFact.textContent = "Fun fact: " + info.fact;
        renderTutorPrompts();
    }

    // ---------- Legend (numbered chips) ----------
    // Multi-sequence: render each helix's chips inline, prefixed with
    // "Seq N:" so the user can map each chip back to a helix.
    function renderLegend() {
        if (!legendEl) return;
        var html = "";
        for (var s = 0; s < state.sequences.length; s++) {
            var seq = state.sequences[s];
            if (!seq.length) continue;
            if (state.sequences.length > 1) {
                html += '<span class="dna-legend-seq-label">Seq ' + (s + 1) + ':</span>';
            }
            for (var i = 0; i < seq.length; i++) {
                var letter = seq[i];
                // Gap positions have no mesh and aren't clickable — render
                // a passive break-marker chip instead of a button.
                if (letter === '-' || letter === '.') {
                    html += '<span class="ca-legend-item ca-legend-gap" title="Gap at position ' + (i + 1) + '">' +
                            '<span class="ca-legend-num ca-legend-num-gap">' + (i + 1) + '</span>' +
                            '<span class="ca-legend-name">&minus;</span></span>';
                    continue;
                }
                var color = window.DnaScene.BASE_COLOR[letter] || window.DnaScene.AMBIGUOUS_COLOR;
                var key = "s" + s + "-bp" + i;
                var active = (key === state.activeKey);
                html += '<button type="button" class="ca-legend-item' + (active ? ' is-active' : '') +
                        '" data-bp-key="' + key + '" title="Seq ' + (s + 1) + ', Base ' + (i + 1) + ': ' + letter + '">' +
                        '<span class="ca-legend-num" style="background:' + color + '">' + (i + 1) + '</span>' +
                        '<span class="ca-legend-name">' + letter + '</span></button>';
            }
        }
        legendEl.innerHTML = html;
        legendEl.hidden = !state.labelsVisible;
    }

    // ---------- Analysis panel rendering ----------

    /* renderAnalysis — rebuilds the stats table + mismatch row + motif
       status whenever the sequences change. Builds a stats card per
       sequence with length / GC / Tm / RevComp button / Translation. */
    function renderAnalysis() {
        if (!statsList) return;

        // Per-sequence stats cards
        var html = "";
        if (state.sequences.length === 0) {
            html = '<p class="dna-stats-empty">No sequences loaded.</p>';
        } else {
            for (var s = 0; s < state.sequences.length; s++) {
                var seq = state.sequences[s];
                var len = seq.length;
                var gc  = gcOf(seq);
                var tm  = tmOf(seq);
                var protein = translate(seq);
                var proteinHtml = protein.length
                    ? '<code>' + escapeHtml(protein) + '</code>'
                    : '<em>(too short to translate)</em>';
                html += '<div class="dna-stats-card">' +
                          '<div class="dna-stats-card-head">' +
                            '<span class="dna-stats-card-name">Seq ' + (s + 1) + '</span>' +
                            '<button type="button" class="dna-mini-btn dna-revcomp-btn" data-seq-idx="' + s +
                            '" title="Add reverse complement as a new sequence">' +
                              '&#x21BA; RevComp' +
                            '</button>' +
                          '</div>' +
                          '<dl class="dna-stats-card-attrs">' +
                            '<div><dt>Length</dt><dd>' + len + ' bp</dd></div>' +
                            '<div><dt>GC%</dt><dd>' + gc + '%</dd></div>' +
                            '<div><dt>Tm</dt><dd>' + (len ? (tm + '°C') : '—') +
                            (len > 13 ? ' <small>(Howley)</small>' : ' <small>(Wallace)</small>') +
                            '</dd></div>' +
                          '</dl>' +
                          '<div class="dna-stats-card-protein">' +
                            '<span class="dna-stats-card-label">5′ → 3′ protein:</span> ' +
                            proteinHtml +
                          '</div>' +
                        '</div>';
            }
        }
        statsList.innerHTML = html;

        // Mismatch toggle — Compare tab keeps the button visible but
        // disables it when sequences aren't all the same length.
        var mismatches = findMismatches(state.sequences);
        var sameLen = state.sequences.length >= 2 &&
                      state.sequences.every(function (s) { return s.length === state.sequences[0].length; });
        if (mismatchBtn) {
            mismatchBtn.disabled = !sameLen;
            mismatchBtn.classList.toggle('is-active', state.showMismatches && sameLen);
        }
        if (mismatchInfo) {
            if (!sameLen) {
                mismatchInfo.textContent = "";
            } else {
                var uniquePositions = {};
                mismatches.forEach(function (m) { uniquePositions[m.pos] = true; });
                var posCount = Object.keys(uniquePositions).length;
                mismatchInfo.textContent = posCount === 0
                    ? "Sequences are identical — no mismatches."
                    : posCount + " differing position" + (posCount === 1 ? "" : "s") + " across " +
                      state.sequences.length + " sequence" + (state.sequences.length === 1 ? "" : "s") + ".";
            }
        }
        if (compareHint) compareHint.hidden = sameLen;
        // If a mismatch toggle was on but sequences are no longer same-length, drop it.
        if (!sameLen && state.showMismatches) state.showMismatches = false;

        // Motif status — show count + locations
        if (motifStatus) {
            var hits = findMotifHits(state.motif, state.sequences);
            if (!state.motif) {
                motifStatus.textContent = "";
            } else if (hits.length === 0) {
                motifStatus.textContent = "0 matches for \"" + state.motif.toUpperCase() + "\".";
            } else {
                var byseq = {};
                hits.forEach(function (h) {
                    byseq[h.seq] = byseq[h.seq] || [];
                    byseq[h.seq].push(h.start + 1);
                });
                var parts = Object.keys(byseq).map(function (s) {
                    return "Seq " + (parseInt(s, 10) + 1) + ": " + byseq[s].join(", ");
                });
                motifStatus.textContent = hits.length + " match" + (hits.length === 1 ? "" : "es") +
                                          " · " + parts.join(" · ");
            }
        }
        if (motifClear) motifClear.hidden = !state.motif;
    }

    function escapeHtml(s) {
        return String(s == null ? "" : s)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;").replace(/'/g, "&#39;");
    }

    /* computeHighlightSet — returns the union of motif-match positions
       and mismatch positions (if their toggles are on), expressed as a
       Set of compound keys "s{i}-bp{j}". The scene paints these as
       emphasised (full opacity + emissive halo) and dims everything
       else so the highlights pop. */
    function computeHighlightSet() {
        var set = {};
        if (state.motif) {
            findMotifHits(state.motif, state.sequences).forEach(function (h) {
                for (var p = h.start; p < h.end; p++) {
                    set["s" + h.seq + "-bp" + p] = true;
                }
            });
        }
        if (state.showMismatches) {
            findMismatches(state.sequences).forEach(function (m) {
                set["s" + m.seq + "-bp" + m.pos] = true;
            });
        }
        return set;
    }

    /* Reverse-complement click — appends the revcomp as a new line to
       the textarea so it renders as a new helix beside the original. */
    if (statsList) {
        statsList.addEventListener('click', function (e) {
            var btn = e.target.closest('.dna-revcomp-btn');
            if (!btn) return;
            var idx = parseInt(btn.getAttribute('data-seq-idx'), 10);
            if (isNaN(idx) || !state.sequences[idx]) return;
            var rc = reverseComplement(state.sequences[idx]);
            var newRaw = (state.raw.replace(/\s+$/, "")) + "\n>seq" + (state.sequences.length + 1) +
                         "_revcomp_of_seq" + (idx + 1) + "\n" + rc;
            setRawInput(newRaw);
        });
    }

    /* Motif input — live search. Also refreshes seqviz if Linear tab is
       active so the highlight stays in sync between Studio and Linear. */
    function syncSeqvizIfActive() {
        if (linearGrid && !linearGrid.hidden) refreshSeqviz();
    }
    if (motifInput) {
        motifInput.addEventListener('input', function () {
            var clean = (motifInput.value || "").toUpperCase().replace(/[^ATGC]/g, "");
            if (clean !== motifInput.value) motifInput.value = clean;
            state.motif = clean;
            renderAnalysis();
            pushSceneState();
            syncSeqvizIfActive();
        });
    }
    if (motifClear) {
        motifClear.addEventListener('click', function () {
            state.motif = "";
            if (motifInput) motifInput.value = "";
            renderAnalysis();
            pushSceneState();
            syncSeqvizIfActive();
        });
    }
    /* Common-motif preset chips → fill the motif input. */
    document.querySelectorAll('[data-motif]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var m = btn.getAttribute('data-motif') || "";
            state.motif = m.toUpperCase();
            if (motifInput) motifInput.value = state.motif;
            renderAnalysis();
            pushSceneState();
            syncSeqvizIfActive();
        });
    });

    /* Mismatch toggle. */
    if (mismatchBtn) {
        mismatchBtn.addEventListener('click', function () {
            state.showMismatches = !state.showMismatches;
            renderAnalysis();
            pushSceneState();
            syncSeqvizIfActive();
        });
    }

    // ---------- AI Tutor (mirrors cell-atlas pattern) ----------
    var tutorAbort = null;
    function renderTutorPrompts() {
        if (!promptList) return;
        var prompts = [
            "Explain the chemistry of this base pair",
            "Why does GC have 3 bonds and AT only 2?",
            "What's the difference between purines and pyrimidines?",
            "How does the antiparallel-strand setup affect replication?"
        ];
        var html = "";
        prompts.forEach(function (p) {
            html += '<button type="button" data-prompt="' + p.replace(/"/g, '&quot;') + '">' + p + '</button>';
        });
        promptList.innerHTML = html;
    }
    function showTutorState(state) {
        if (tutorOutput) tutorOutput.setAttribute('data-state', state);
    }
    function setTutorPlaceholder(msg) {
        if (tutorBody) tutorBody.innerHTML = '<p class="ca-tutor-placeholder">' + msg + '</p>';
    }
    function askTutor(question) {
        if (!question || !question.trim()) return;
        if (tutorAbort) tutorAbort.abort();
        tutorAbort = new AbortController();
        showTutorState('loading');
        tutorMeta.textContent = "Tutor usually replies in 2–3 seconds";
        setTutorPlaceholder("Thinking...");

        var ctx = "DNA Viewer tool. ";
        var ak = parseActiveKey(state.activeKey);
        var seq = ak ? state.sequences[ak.seq] : null;
        if (ak && seq && ak.bp < seq.length) {
            var letter = seq[ak.bp];
            var info = BASE_INFO[letter];
            ctx += "The user is viewing " + state.sequences.length + " DNA sequence(s); the active base is " +
                   "position " + (ak.bp + 1) + " of " + seq.length + " in sequence #" + (ak.seq + 1) +
                   " (\"" + seq + "\"). This base is " + info.name + " (" + letter + "), a " +
                   info.type + " that pairs with " + info.pairsWith + " via " + info.bonds + " H-bonds. ";
        } else {
            ctx += "The user is viewing " + state.sequences.length + " DNA sequence(s): " +
                   state.sequences.map(function (s, i) { return "Seq " + (i + 1) + "=\"" + s + "\""; }).join(", ") + ". ";
        }
        ctx += "Answer in 2–3 short paragraphs of plain text. Be concrete.";

        // Match the cell-atlas request shape: a single `messages` array
        // with the system prompt as the first role, no separate `system`
        // field. AIProxyServlet expects this.
        var body = JSON.stringify({
            stream: true,
            messages: [
                { role: "system", content: ctx },
                { role: "user",   content: question }
            ]
        });

        fetch(TUTOR_ENDPOINT, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: body,
            signal: tutorAbort.signal
        }).then(function (resp) {
            if (resp.status === 429) {
                var wait = resp.headers.get('Retry-After') || '60';
                throw new Error('Rate limit reached — try again in ' + wait + 's.');
            }
            if (!resp.ok || !resp.body) throw new Error("Tutor request failed: " + resp.status);
            var reader = resp.body.getReader();
            var decoder = new TextDecoder();
            var acc = "";
            var buffer = "";
            tutorBody.innerHTML = '';
            tutorMeta.textContent = "Streaming…";
            // Ollama NDJSON: each line is {"message":{"content":"..."},"done":false}.
            // Match the cell-atlas parser to handle the same chunks reliably.
            function pump() {
                return reader.read().then(function (chunk) {
                    if (chunk.done) {
                        tutorMeta.textContent = "Reply complete.";
                        showTutorState('ready');
                        return;
                    }
                    buffer += decoder.decode(chunk.value, { stream: true });
                    var lines = buffer.split('\n');
                    buffer = lines.pop();
                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i].trim();
                        if (!line) continue;
                        try {
                            var obj = JSON.parse(line);
                            if (obj.error) throw new Error(obj.error);
                            var delta = (obj.message && obj.message.content) ||
                                        (typeof obj.response === 'string' ? obj.response : '');
                            if (delta) {
                                acc += delta;
                                tutorBody.textContent = acc;
                            }
                        } catch (e) { /* partial / malformed line — skip */ }
                    }
                    return pump();
                });
            }
            return pump();
        }).catch(function (err) {
            if (err.name === 'AbortError') return;
            tutorMeta.textContent = "Tutor error.";
            setTutorPlaceholder("Couldn't reach the tutor: " + err.message);
            showTutorState('error');
        });
    }

    if (promptList) {
        promptList.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-prompt]');
            if (!btn) return;
            askTutor(btn.getAttribute('data-prompt'));
        });
    }
    if (tutorForm) {
        tutorForm.addEventListener('submit', function (e) {
            e.preventDefault();
            var q = (tutorInput.value || '').trim();
            if (q) {
                askTutor(q);
                tutorInput.value = '';
            }
        });
    }

    // ---------- Toolbar ----------
    if (rotateBtn) {
        rotateBtn.addEventListener('click', function () {
            state.autoRotate = !state.autoRotate;
            rotateBtn.classList.toggle('is-active', state.autoRotate);
            pushSceneState();
            updateUrlState();
        });
    }
    function setLabelsVisible(on) {
        state.labelsVisible = !!on;
        if (labelsBtn) labelsBtn.classList.toggle('is-active', state.labelsVisible);
        if (legendEl) legendEl.hidden = !state.labelsVisible;
        pushSceneState();
    }
    if (labelsBtn) {
        labelsBtn.addEventListener('click', function () {
            setLabelsVisible(!state.labelsVisible);
            updateUrlState();
        });
    }
    if (isolateBtn) {
        isolateBtn.addEventListener('click', function () {
            state.viewMode = (state.viewMode === 'focus') ? 'mesh' : 'focus';
            pushSceneState();
            updateUrlState();
        });
    }
    if (resetBtn) {
        resetBtn.addEventListener('click', function () {
            state.viewMode = 'mesh';
            state.activeKey = null;
            renderActiveBp();
            renderLegend();
            pushSceneState();
            if (sceneController) sceneController.reset();
            updateUrlState();
        });
    }
    if (screenshotBtn) {
        screenshotBtn.addEventListener('click', function () {
            if (!sceneController) return;
            var url = sceneController.screenshot('image/png');
            var a = document.createElement('a');
            a.href = url;
            a.download = 'dna-helix.png';
            a.click();
        });
    }
    if (shareBtn) {
        shareBtn.addEventListener('click', function () {
            try {
                navigator.clipboard.writeText(buildShareUrl()).then(function () {
                    shareBtn.textContent = '✓ Copied';
                    setTimeout(function () { shareBtn.innerHTML = '&#128279; Share'; }, 1400);
                });
            } catch (e) {}
        });
    }
    /* renderPrintView — builds a static, data-driven handout from the
       current sequences. WebGL would print blank, so the printer gets a
       structured analysis page with per-sequence stats, the full
       sequence in FASTA-style line wrapping, protein translation, and
       reverse complement. Hidden onscreen via CSS; only @media print
       reveals it. */
    function renderPrintView() {
        var view = document.getElementById("dnaPrintView");
        if (!view) return;
        var html = "";
        var now = new Date();
        var stamp = now.toLocaleDateString(undefined, { year: 'numeric', month: 'long', day: 'numeric' });

        html += '<header class="dna-print-header">' +
                  '<h1>DNA Sequence Analysis</h1>' +
                  '<p>Generated ' + stamp + '</p>' +
                '</header>';

        var n = state.sequences.length;
        var totalBp = 0;
        state.sequences.forEach(function (s) { totalBp += s.length; });
        var gc = totalGc();
        html += '<section class="dna-print-summary">' +
                  '<p>' + n + ' sequence' + (n === 1 ? '' : 's') +
                  ' &middot; ' + totalBp + ' position' + (totalBp === 1 ? '' : 's') + ' total' +
                  ' &middot; ' + gc + '% GC overall</p>' +
                '</section>';

        /* 3D helix screenshot — captured fresh via sceneController.screenshot().
           The screenshot function re-renders the scene before toDataURL()
           which works around the default preserveDrawingBuffer:false.
           Returns a base64 PNG data URL we can inline as an <img>. */
        if (sceneController && sceneController.screenshot) {
            try {
                // Force 1100×700 capture — works even when the Studio tab is
                // hidden (e.g. user is on Linear View) since the screenshot
                // function temporarily resizes the renderer.
                var dataUrl = sceneController.screenshot('image/png', 1100, 700);
                if (dataUrl && dataUrl.length > 100) {
                    html += '<figure class="dna-print-helix-img">' +
                              '<img src="' + dataUrl + '" alt="3D DNA helix">' +
                              '<figcaption>3D Helix view — color-coded base pairs (A=red, T=yellow, G=green, C=blue)</figcaption>' +
                            '</figure>';
                }
            } catch (e) {
                console.warn("Helix screenshot failed:", e);
            }
        }

        /* Concentric multi-sequence view — only if currently rendered.
           Serialize the live SVG into the print directly (no need to
           rasterize; SVG prints crisply at any resolution). */
        var concentricSvg = document.querySelector('.dna-circular-wrap svg');
        if (concentricSvg && state.sequences.length > 1) {
            html += '<figure class="dna-print-concentric">' +
                      concentricSvg.outerHTML +
                      '<figcaption>Concentric view — Seq 1 outermost, color-coded by base</figcaption>' +
                    '</figure>';
        }

        if (state.sequences.length === 0) {
            html += '<p class="dna-print-empty">No sequences loaded.</p>';
        } else {
            state.sequences.forEach(function (seq, i) {
                var len  = seq.length;
                var sgc  = gcOf(seq);
                var stm  = tmOf(seq);
                var prot = translate(seq);
                var rc   = reverseComplement(seq);
                // FASTA-style line wrap at 60 chars with position labels.
                var wrapped = "";
                for (var p = 0; p < seq.length; p += 60) {
                    var line = seq.substr(p, 60);
                    // Group into blocks of 10 for readability.
                    var grouped = line.match(/.{1,10}/g) || [];
                    var prefix = String(p + 1).padStart(5, ' ');
                    wrapped += prefix + '  ' + grouped.join(' ') + '\n';
                }

                html += '<section class="dna-print-seq">' +
                          '<header>' +
                            '<h2>Sequence ' + (i + 1) + '</h2>' +
                            '<dl>' +
                              '<div><dt>Length</dt><dd>' + len + ' bp</dd></div>' +
                              '<div><dt>GC%</dt><dd>' + sgc + '%</dd></div>' +
                              '<div><dt>Tm</dt><dd>' + (len ? (stm + '°C') : '—') +
                                ' <small>(' + (len > 13 ? 'Howley' : 'Wallace') + ')</small></dd></div>' +
                            '</dl>' +
                          '</header>' +
                          '<h3>Sequence (5′ → 3′)</h3>' +
                          '<pre class="dna-print-seq-text">' + escapeHtml(wrapped.trimEnd()) + '</pre>';

                if (prot.length > 0) {
                    html += '<h3>Protein translation (5′ → 3′, frame 1)</h3>' +
                            '<pre class="dna-print-protein">' + escapeHtml(prot) + '</pre>';
                }
                html += '<h3>Reverse complement (3′ → 5′)</h3>' +
                        '<pre class="dna-print-rc">' + escapeHtml(rc) + '</pre>';

                html += '</section>';
            });
        }

        // Active motif results, if any.
        if (state.motif) {
            var hits = findMotifHits(state.motif, state.sequences);
            html += '<section class="dna-print-motif">' +
                      '<h2>Motif search: <code>' + escapeHtml(state.motif) + '</code></h2>';
            if (hits.length === 0) {
                html += '<p>No matches across loaded sequences.</p>';
            } else {
                var byseq = {};
                hits.forEach(function (h) {
                    byseq[h.seq] = byseq[h.seq] || [];
                    byseq[h.seq].push(h.start + 1);
                });
                html += '<ul>';
                Object.keys(byseq).forEach(function (s) {
                    html += '<li>Sequence ' + (parseInt(s, 10) + 1) + ': position ' +
                            byseq[s].join(', ') + '</li>';
                });
                html += '</ul>';
            }
            html += '</section>';
        }

        // Mismatch results, if applicable (same-length sequences).
        if (state.sequences.length >= 2) {
            var mismatches = findMismatches(state.sequences);
            if (mismatches.length > 0) {
                var uniq = {};
                mismatches.forEach(function (m) { uniq[m.pos] = true; });
                var positions = Object.keys(uniq).map(function (k) { return parseInt(k, 10) + 1; });
                positions.sort(function (a, b) { return a - b; });
                html += '<section class="dna-print-mismatch">' +
                          '<h2>Mismatch positions</h2>' +
                          '<p>' + positions.length + ' position' +
                          (positions.length === 1 ? '' : 's') +
                          ' differ across ' + state.sequences.length + ' aligned sequences: ' +
                          positions.join(', ') + '</p>' +
                        '</section>';
            }
        }

        html += '<footer class="dna-print-footer">' +
                  '<p>From 8gwifi.org · DNA Viewer 3D</p>' +
                '</footer>';

        view.innerHTML = html;
    }

    if (printBtn) {
        printBtn.addEventListener('click', function () {
            renderPrintView();
            // One extra rAF so the new DOM is laid out before the print
            // preview snapshots it.
            requestAnimationFrame(function () { window.print(); });
        });
    }

    /* ---------- Help overlay + keyboard shortcuts ---------- */
    var helpBtn     = $("dnaHelpBtn");
    var helpOverlay = $("dnaHelpOverlay");
    var helpClose   = $("dnaHelpClose");
    function openHelp()  { if (helpOverlay) helpOverlay.classList.add('is-open'); }
    function closeHelp() { if (helpOverlay) helpOverlay.classList.remove('is-open'); }
    if (helpBtn)   helpBtn.addEventListener('click', openHelp);
    if (helpClose) helpClose.addEventListener('click', closeHelp);
    if (helpOverlay) {
        helpOverlay.addEventListener('click', function (e) {
            if (e.target === helpOverlay) closeHelp();
        });
    }

    /* Cycle the active base pair within the currently-active sequence. */
    function cycleBp(delta) {
        var ak = parseActiveKey(state.activeKey);
        var seqIdx = ak ? ak.seq : 0;
        var seq = state.sequences[seqIdx];
        if (!seq || seq.length === 0) return;
        var current = ak ? ak.bp : -1;
        // Walk to the next non-gap position so we don't land on a gap.
        var next = current;
        for (var n = 0; n < seq.length; n++) {
            next = (next + delta + seq.length) % seq.length;
            if (seq[next] !== '-' && seq[next] !== '.') break;
        }
        activateBp("s" + seqIdx + "-bp" + next);
    }

    /* Document-level shortcuts. Skipped while typing in inputs/textareas. */
    document.addEventListener('keydown', function (e) {
        // Don't hijack typing in form fields.
        var t = e.target;
        if (t && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable)) return;
        var key = e.key;
        // Modal-aware: while help is open, Esc closes it; other shortcuts pass through.
        if (key === 'Escape') {
            if (helpOverlay && helpOverlay.classList.contains('is-open')) {
                closeHelp(); e.preventDefault(); return;
            }
        }
        if (key === '?') { openHelp(); e.preventDefault(); return; }
        if (key === 'r' || key === 'R') {
            state.autoRotate = !state.autoRotate;
            if (rotateBtn) rotateBtn.classList.toggle('is-active', state.autoRotate);
            pushSceneState(); updateUrlState(); e.preventDefault(); return;
        }
        if (key === 'l' || key === 'L') {
            setLabelsVisible(!state.labelsVisible);
            updateUrlState(); e.preventDefault(); return;
        }
        if (key === 'f' || key === 'F') {
            state.viewMode = (state.viewMode === 'focus') ? 'mesh' : 'focus';
            pushSceneState(); updateUrlState(); e.preventDefault(); return;
        }
        if (key === 's' || key === 'S') {
            if (screenshotBtn) screenshotBtn.click(); e.preventDefault(); return;
        }
        if (key === 'c' || key === 'C') {
            if (shareBtn) shareBtn.click(); e.preventDefault(); return;
        }
        if (key === '[') { cycleBp(-1); e.preventDefault(); return; }
        if (key === ']') { cycleBp( 1); e.preventDefault(); return; }
        if (key === '1') { switchToTab('studio'); e.preventDefault(); return; }
        if (key === '2') { switchToTab('linear'); e.preventDefault(); return; }
    });

    // ---------- Sequence input + presets ----------
    if (seqInput) {
        seqInput.value = state.raw;
        seqInput.addEventListener('input', function () {
            setRawInput(seqInput.value);
        });
    }
    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = btn.getAttribute('data-preset');
            var fn = PRESETS[key];
            if (fn) setRawInput(fn());
        });
    });

    // ---------- Legend click → activate base pair ----------
    if (legendEl) {
        legendEl.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-bp-key]');
            if (!btn) return;
            var key = btn.getAttribute('data-bp-key');
            if (key) activateBp(key);
        });
    }

    /* activateBp accepts a compound key "s{seqIdx}-bp{bpIdx}". */
    function activateBp(key) {
        if (state.autoRotate) {
            state.autoRotate = false;
            if (rotateBtn) rotateBtn.classList.remove('is-active');
        }
        revealDetailsPanel();
        state.activeKey = key;
        renderActiveBp();
        renderLegend();
        pushSceneState();
        updateUrlState();
    }

    // ---------- URL share/restore ----------
    // `s` carries the raw textarea (multi-line). Encode newlines as '|'
    // so URLSearchParams doesn't HTML-encode them awkwardly.
    function buildShareUrl() {
        var params = new URLSearchParams();
        if (state.raw) params.set('s', state.raw.replace(/\n/g, '|'));
        if (state.activeKey) params.set('k', state.activeKey);
        if (state.viewMode !== 'mesh') params.set('m', state.viewMode === 'focus' ? 'f' : 'h');
        if (state.labelsVisible) params.set('l', '1');
        if (state.autoRotate) params.set('r', '1');
        return window.location.origin + window.location.pathname + '?' + params.toString();
    }
    function updateUrlState() {
        try {
            var url = window.location.pathname + '?' + new URL(buildShareUrl()).search.slice(1);
            window.history.replaceState(null, '', url);
        } catch (e) {}
    }
    function restoreFromUrl() {
        var p = new URLSearchParams(window.location.search);
        if (p.has('s')) {
            var raw = (p.get('s') || '').replace(/\|/g, '\n');
            state.raw = raw;
            state.sequences = parseSeqs(raw);
        }
        if (p.has('k')) state.activeKey = p.get('k');
        var m = p.get('m');
        if (m === 'f') state.viewMode = 'focus';
        else if (m === 'h') state.viewMode = 'hide';
        if (p.get('l') === '1') state.labelsVisible = true;
        if (p.get('r') === '1') state.autoRotate = true;
    }

    /* Global error swallower for seqviz uncaught errors. seqviz renders
       on a separate React tick, so errors can fire outside our try/catch.
       Without this, a single bad sequence spams the console with stack
       traces. We swallow the specific error class and let everything
       else through. */
    window.addEventListener('error', function (e) {
        if (e && e.filename && e.filename.indexOf('seqviz') !== -1) {
            console.warn('[seqviz] suppressed:', e.message || e);
            e.preventDefault();
            return true;
        }
    });

    // ---------- Linear (seqviz) tab — lazy CDN load ----------
    var seqvizBoot = null;
    var seqvizViewers = [];       // one viewer instance per loaded sequence
    var seqvizView = "both";      // "linear" | "circular" | "both" — Both shows the most context by default

    /* showSeqvizSelection — surfaces seqviz's onSelection callback as
       a small info strip. Without a callback wired, seqviz doesn't
       always render selection feedback, and the user gets the
       impression that drag-to-select is broken. */
    function showSeqvizSelection(sel) {
        var el = document.getElementById("dnaSeqvizSelection");
        if (!el) return;
        if (!sel || sel.start == null || sel.end == null || sel.start === sel.end) {
            el.hidden = true;
            el.textContent = "";
            return;
        }
        var start = Math.min(sel.start, sel.end) + 1;
        var end   = Math.max(sel.start, sel.end);
        var len   = end - start + 1;
        el.hidden = false;
        el.textContent = "Selected: " + start + "–" + end + " · " + len + " bp" +
                         (sel.clockwise === false ? " (reverse strand)" : "");
    }
    var seqvizShowComplement   = true;
    var seqvizShowIndex        = true;
    var seqvizShowTranslation  = true;
    var seqvizShowAnnotations  = true;
    var seqvizEnzymes          = [];  // user-picked restriction enzymes

    function loadSeqvizOnce() {
        if (seqvizBoot) return seqvizBoot;
        var booting = new Promise(function (resolve, reject) {
            if (window.seqviz) { resolve(window.seqviz); return; }
            var s = document.createElement('script');
            // Pin to a specific stable version. The bare `seqviz` tag on
            // jsDelivr serves whatever's latest, and the API has shifted
            // between major releases (3.x → vanilla, 4.x → React-only,
            // 5.x → vanilla again). 3.10.x has the simplest vanilla API
            // and the widest reach via the official demo.
            s.src = "https://cdn.jsdelivr.net/npm/seqviz@3.10.7/dist/seqviz.min.js";
            s.async = true;
            s.onload = function () {
                if (window.seqviz) resolve(window.seqviz);
                else reject(new Error("seqviz loaded but no global 'seqviz' found"));
            };
            s.onerror = function () { reject(new Error("Failed to load seqviz from CDN")); };
            document.head.appendChild(s);
        });
        seqvizBoot = booting;
        booting.catch(function () { if (seqvizBoot === booting) seqvizBoot = null; });
        return booting;
    }

    /* refreshSeqviz — rebuilds the Linear View.
       Single-sequence:  use seqviz natively (rich rendering).
       Multi-sequence:   use the custom DnaCircular SVG for the circular
                         portion, plus stacked seqviz linear strips for
                         the linear portion when view is "both". For pure
                         "linear" mode with multiple sequences, fall back
                         to stacked seqviz views (since linear-only stacks
                         clearly anyway). */
    function refreshSeqviz() {
        var mounts = $("dnaSeqvizMounts");
        if (!mounts) return;

        var multi = state.sequences.length > 1;
        var wantCircular = (seqvizView === "circular" || seqvizView === "both");

        // Multi-sequence + circular/both → custom concentric renderer
        // (skip seqviz for the circular portion).
        if (multi && wantCircular && window.DnaCircular) {
            // Clear and build a wrapping container.
            mounts.innerHTML = "";

            // Build the mismatch map for the renderer.
            var mismatchPositions = {};
            if (state.showMismatches) {
                findMismatches(state.sequences).forEach(function (m) {
                    (mismatchPositions[m.seq] = mismatchPositions[m.seq] || []).push(m.pos);
                });
            }

            // Layout: for "both" view, side-by-side concentric + linear stack.
            // For "circular" alone, just the concentric SVG centered.
            var layout = document.createElement("div");
            layout.className = "dna-multi-layout" + (seqvizView === "both" ? " is-both" : "");
            mounts.appendChild(layout);

            var circWrap = document.createElement("div");
            circWrap.className = "dna-circular-wrap";
            layout.appendChild(circWrap);

            window.DnaCircular.render(circWrap, {
                sequences: state.sequences,
                motif: state.motif,
                mismatchPositions: mismatchPositions,
                activeKey: state.activeKey,
                onPick: function (key) { activateBp(key); }
            });

            // For "both", also render stacked linear seqviz views alongside.
            if (seqvizView === "both") {
                var linearWrap = document.createElement("div");
                linearWrap.className = "dna-linear-stack";
                layout.appendChild(linearWrap);
                renderSeqvizLinearOnly(linearWrap);
            }
            return;
        }

        // Single-sequence OR pure-linear multi-sequence → original
        // stacked-seqviz path.
        loadSeqvizOnce().then(function (seqviz) {
            // Tear down old viewer DOM; seqviz instances don't expose
            // a destroy() API so we just clear and rebuild.
            seqvizViewers = [];
            mounts.innerHTML = "";

            if (state.sequences.length === 0) {
                mounts.innerHTML = '<p class="dna-seqviz-empty">No sequences loaded. Switch to the Studio tab and use the Workbench → Input tab.</p>';
                return;
            }

            var Viewer = (seqviz.Viewer || seqviz.viewer || seqviz.SeqViz);
            if (!Viewer) {
                mounts.innerHTML = '<p class="dna-error">seqviz API not recognised. Library may have changed.</p>';
                return;
            }

            // Pre-compute mismatch positions once across the whole set,
            // grouped by sequence — so each viewer can highlight its own.
            var allMismatches = state.showMismatches ? findMismatches(state.sequences) : [];
            var mismatchBySeq = {};
            allMismatches.forEach(function (m) {
                (mismatchBySeq[m.seq] = mismatchBySeq[m.seq] || []).push(m.pos);
            });

            // seqviz's internal base-color map covers ATGCU but breaks on
            // gap characters and some IUPAC codes (it does `char in map`
            // which throws if the map is undefined for that char in some
            // code paths). Strip gaps before passing in; gaps don't have
            // a 2D linear representation anyway. Map U → T so RNA renders
            // consistently with the rest of the tool.
            function prepForSeqviz(s) {
                return s.replace(/[-.]/g, "").replace(/U/g, "T");
            }

            // Explicit base color map. Passing this defensively means
            // seqviz won't fall back to an internal lookup that may differ
            // across versions.
            var BP_COLORS = {
                A: "#e74c3c", T: "#f1c40f", G: "#2ecc71", C: "#3498db",
                a: "#e74c3c", t: "#f1c40f", g: "#2ecc71", c: "#3498db"
            };

            state.sequences.forEach(function (seq, i) {
                var wrapper = document.createElement("div");
                wrapper.className = "dna-seqviz-mount";
                wrapper.id = "dnaSeqvizMount_" + i;
                mounts.appendChild(wrapper);

                var seqForViz = prepForSeqviz(seq);
                if (seqForViz.length === 0) {
                    wrapper.innerHTML = '<p class="dna-seqviz-empty">Seq ' + (i + 1) +
                                        ' has no renderable bases (all gaps or empty).</p>';
                    return;
                }

                // Annotations: render motif matches as gold feature bars
                // above the sequence, plus auto-detected ORFs as pink
                // bands (matches the reference seqviz demo).
                var annotations = [];
                if (seqvizShowAnnotations) {
                    if (state.motif) {
                        findMotifHits(state.motif, [seqForViz]).forEach(function (h, idx) {
                            annotations.push({
                                id: "motif-" + i + "-" + idx,
                                name: state.motif,
                                start: h.start,
                                end: h.end,
                                direction: 1,
                                color: "#f1c40f"
                            });
                        });
                    }
                    // ORF auto-detection — adds "ORF 1/2/3" bands wherever a
                    // 20+ codon open reading frame is found, just like the
                    // reference demo's plasmid view.
                    findOrfs(seqForViz, 20).forEach(function (orf, idx) {
                        annotations.push({
                            id: "orf-" + i + "-" + idx,
                            name: "ORF " + orf.frame,
                            start: orf.start,
                            end: orf.end,
                            direction: 1,
                            color: "#f5c3cc"
                        });
                    });
                }

                // Highlights: paint mismatch positions red. Map positions
                // through the gap-stripping so they land on the correct
                // base in the stripped seqviz input.
                var highlights = [];
                (mismatchBySeq[i] || []).forEach(function (pos) {
                    // Translate the original-sequence position to the
                    // stripped-sequence position by counting non-gaps up
                    // to pos. If the position itself is a gap, skip it
                    // (it has no rendering in seqviz).
                    if (seq[pos] === '-' || seq[pos] === '.') return;
                    var stripped = 0;
                    for (var p = 0; p < pos; p++) {
                        if (seq[p] !== '-' && seq[p] !== '.') stripped++;
                    }
                    highlights.push({ start: stripped, end: stripped + 1, color: "#e74c3c" });
                });

                // Translation: codon-aligned amino acids beneath the sequence.
                var translations = [];
                if (seqvizShowTranslation && seqForViz.length >= 3) {
                    translations.push({ start: 0, end: seqForViz.length, direction: 1 });
                }

                var opts = {
                    name: "Seq " + (i + 1) + " · " + seqForViz.length + " bp",
                    seq: seqForViz,
                    viewer: seqvizView,
                    showComplement: seqvizShowComplement,
                    showIndex: seqvizShowIndex,
                    showAnnotations: seqvizShowAnnotations,
                    annotations: annotations,
                    highlights: highlights,
                    translations: translations,
                    enzymes: seqvizEnzymes.slice(),
                    bpColors: BP_COLORS,
                    // Bigger height so 'Both' mode has room for the
                    // circular plasmid + linear strip side-by-side, like
                    // the reference seqviz demo screenshot.
                    style: { height: 520, width: "100%" }
                };
                if (state.motif) {
                    opts.search = { query: state.motif, mismatch: 0 };
                }
                // Surface seqviz's click-drag selection. Without this
                // callback the selection still happens internally but
                // the user gets no visible feedback in the linear strip.
                opts.onSelection = function (sel) { showSeqvizSelection(sel); };
                try {
                    var instance = Viewer(wrapper, opts);
                    if (instance && instance.render) instance.render();
                    seqvizViewers.push(instance);
                } catch (e) {
                    wrapper.innerHTML = '<p class="dna-error">Sequence view failed: ' +
                                        (e.message || e) + '</p>';
                    console.error("[seqviz] render error on seq " + (i + 1) + ":", e);
                }
            });
        }).catch(function (err) {
            mounts.innerHTML = '<p class="dna-error">' + (err.message || err) + '</p>';
        });
    }

    /* renderSeqvizLinearOnly — stacks linear-only seqviz viewers into a
       container. Used by the multi-sequence "both" layout: concentric
       circles on the left, this linear stack on the right. Shares the
       same options / motif / mismatch logic as the full refresh path. */
    function renderSeqvizLinearOnly(mounts) {
        loadSeqvizOnce().then(function (seqviz) {
            mounts.innerHTML = "";
            var Viewer = (seqviz.Viewer || seqviz.viewer || seqviz.SeqViz);
            if (!Viewer) return;

            var BP_COLORS = {
                A: "#e74c3c", T: "#f1c40f", G: "#2ecc71", C: "#3498db",
                a: "#e74c3c", t: "#f1c40f", g: "#2ecc71", c: "#3498db"
            };
            function prepForSeqviz(s) {
                return s.replace(/[-.]/g, "").replace(/U/g, "T");
            }

            var allMismatches = state.showMismatches ? findMismatches(state.sequences) : [];
            var mismatchBySeq = {};
            allMismatches.forEach(function (m) {
                (mismatchBySeq[m.seq] = mismatchBySeq[m.seq] || []).push(m.pos);
            });

            state.sequences.forEach(function (seq, i) {
                var wrapper = document.createElement("div");
                wrapper.className = "dna-seqviz-mount dna-seqviz-mount-compact";
                mounts.appendChild(wrapper);
                var seqForViz = prepForSeqviz(seq);
                if (seqForViz.length === 0) {
                    wrapper.innerHTML = '<p class="dna-seqviz-empty">Seq ' + (i + 1) + ': no renderable bases.</p>';
                    return;
                }
                var annotations = [];
                if (seqvizShowAnnotations && state.motif) {
                    findMotifHits(state.motif, [seqForViz]).forEach(function (h, idx) {
                        annotations.push({
                            id: "motif-" + i + "-" + idx,
                            name: state.motif,
                            start: h.start, end: h.end, direction: 1,
                            color: "#f1c40f"
                        });
                    });
                }
                if (seqvizShowAnnotations) {
                    findOrfs(seqForViz, 20).forEach(function (orf, idx) {
                        annotations.push({
                            id: "orf-" + i + "-" + idx,
                            name: "ORF " + orf.frame,
                            start: orf.start, end: orf.end, direction: 1,
                            color: "#f5c3cc"
                        });
                    });
                }
                var highlights = [];
                (mismatchBySeq[i] || []).forEach(function (pos) {
                    if (seq[pos] === '-' || seq[pos] === '.') return;
                    var stripped = 0;
                    for (var p = 0; p < pos; p++) {
                        if (seq[p] !== '-' && seq[p] !== '.') stripped++;
                    }
                    highlights.push({ start: stripped, end: stripped + 1, color: "#e74c3c" });
                });
                var translations = [];
                if (seqvizShowTranslation && seqForViz.length >= 3) {
                    translations.push({ start: 0, end: seqForViz.length, direction: 1 });
                }
                var opts = {
                    name: "Seq " + (i + 1),
                    seq: seqForViz,
                    viewer: "linear",
                    showComplement: seqvizShowComplement,
                    showIndex: seqvizShowIndex,
                    showAnnotations: seqvizShowAnnotations,
                    annotations: annotations,
                    highlights: highlights,
                    translations: translations,
                    enzymes: seqvizEnzymes.slice(),
                    bpColors: BP_COLORS,
                    style: { height: 220, width: "100%" }
                };
                if (state.motif) opts.search = { query: state.motif, mismatch: 0 };
                opts.onSelection = function (sel) { showSeqvizSelection(sel); };
                try {
                    var instance = Viewer(wrapper, opts);
                    if (instance && instance.render) instance.render();
                } catch (e) {
                    wrapper.innerHTML = '<p class="dna-error">Render failed: ' + (e.message || e) + '</p>';
                }
            });
        }).catch(function (err) {
            mounts.innerHTML = '<p class="dna-error">' + (err.message || err) + '</p>';
        });
    }

    /* View toggle (Linear / Circular / Both). */
    document.querySelectorAll('[data-seqviz-view]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('[data-seqviz-view]').forEach(function (b) {
                b.classList.remove('is-active');
            });
            btn.classList.add('is-active');
            seqvizView = btn.getAttribute('data-seqviz-view');
            refreshSeqviz();
        });
    });
    var seqvizCompCheck   = $("dnaSeqvizComplement");
    var seqvizIndexCheck  = $("dnaSeqvizIndex");
    var seqvizTransCheck  = $("dnaSeqvizTranslation");
    var seqvizAnnotCheck  = $("dnaSeqvizAnnotations");
    var seqvizEnzymeCount = $("dnaSeqvizEnzymeCount");

    if (seqvizCompCheck)  seqvizCompCheck.addEventListener('change',  function () { seqvizShowComplement   = seqvizCompCheck.checked;  refreshSeqviz(); });
    if (seqvizIndexCheck) seqvizIndexCheck.addEventListener('change', function () { seqvizShowIndex        = seqvizIndexCheck.checked; refreshSeqviz(); });
    if (seqvizTransCheck) seqvizTransCheck.addEventListener('change', function () { seqvizShowTranslation  = seqvizTransCheck.checked; refreshSeqviz(); });
    if (seqvizAnnotCheck) seqvizAnnotCheck.addEventListener('change', function () { seqvizShowAnnotations  = seqvizAnnotCheck.checked; refreshSeqviz(); });

    /* Enzyme picker — collect checked values into seqvizEnzymes. */
    function updateEnzymeCount() {
        if (seqvizEnzymeCount) {
            seqvizEnzymeCount.textContent = seqvizEnzymes.length
                ? "(" + seqvizEnzymes.length + ")"
                : "";
        }
    }
    document.querySelectorAll('[data-enzyme]').forEach(function (cb) {
        cb.addEventListener('change', function () {
            seqvizEnzymes = Array.prototype.slice.call(
                document.querySelectorAll('[data-enzyme]:checked')
            ).map(function (el) { return el.value; });
            updateEnzymeCount();
            refreshSeqviz();
        });
    });

    // ---------- View-tab routing (3D Helix / Linear View) ----------
    var VIEW_TAB_KEY = "biology.dna.viewTab";
    function persistViewTab(t) { try { localStorage.setItem(VIEW_TAB_KEY, t); } catch (e) {} }
    function getPersistedViewTab() {
        // Linear View is the default — it's the actual analysis surface
        // that matches how DNA is worked with in industry (SnapGene,
        // Benchling, etc.). 3D Helix is the visual alternative.
        // Honor explicit 'studio' preference for returning users.
        try {
            var v = localStorage.getItem(VIEW_TAB_KEY);
            return v === 'studio' ? 'studio' : 'linear';
        } catch (e) { return 'linear'; }
    }

    function switchToTab(tab) {
        if (tab !== 'studio' && tab !== 'linear') tab = 'studio';
        var tabs = { studio: tabStudio, linear: tabLinear };
        Object.keys(tabs).forEach(function (k) {
            if (!tabs[k]) return;
            var on = (k === tab);
            tabs[k].classList.toggle('is-active', on);
            tabs[k].setAttribute('aria-selected', on ? 'true' : 'false');
        });
        if (studioGrid) studioGrid.hidden = (tab !== 'studio');
        if (linearGrid) linearGrid.hidden = (tab !== 'linear');
        if (tab === 'linear') refreshSeqviz();
        persistViewTab(tab);

        // Auto-focus: scroll the active grid into view (helpful on
        // narrow viewports). Deferred two rAFs so the hidden→visible
        // reflow lands before we measure.
        var activeGrid = tab === 'studio' ? studioGrid : linearGrid;
        if (activeGrid && activeGrid.scrollIntoView) {
            requestAnimationFrame(function () {
                requestAnimationFrame(function () {
                    try {
                        activeGrid.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    } catch (e) {
                        activeGrid.scrollIntoView();
                    }
                });
            });
        }
    }
    if (tabStudio) tabStudio.addEventListener('click', function () { switchToTab('studio'); });
    if (tabLinear) tabLinear.addEventListener('click', function () { switchToTab('linear'); });

    /* ---------- Rail collapse (left + right) ----------
       Mirrors the Cell Atlas pattern. Right rail is HIDDEN by default
       to maximise stage real-estate on first load (only shows when the
       user explicitly opens it via the show-tab or auto-reveal on pick).
       Left rail stays visible; user can collapse it via the chevron in
       the Sequence panel header. State persists in localStorage. */
    var DNA_LEFT_HIDDEN_KEY  = 'biology.dna.leftHidden';
    var DNA_RIGHT_HIDDEN_KEY = 'biology.dna.rightHidden';

    var storage = (window.ToolUtils && window.ToolUtils.Storage) ? {
        get:  function (k)    { return window.ToolUtils.Storage.get(k); },
        save: function (k, v) { window.ToolUtils.Storage.save(k, v); }
    } : {
        get:  function (k)    { try { return localStorage.getItem(k); } catch (e) { return null; } },
        save: function (k, v) { try { localStorage.setItem(k, v); }     catch (e) {} }
    };

    var studioEl       = $('dnaStudio');
    var railHideBtn    = $('dnaRailHideBtn');
    var railShowTab    = $('dnaRailShowTab');
    var railHideBtnRt  = $('dnaRailHideBtnRight');
    var railShowTabRt  = $('dnaRailShowTabRight');

    function applyRailHidden(side, hidden) {
        if (!studioEl) return;
        var cls = side === 'right' ? 'is-right-hidden' : 'is-left-hidden';
        studioEl.classList.toggle(cls, !!hidden);
    }
    function toggleRail(side, hide) {
        applyRailHidden(side, hide);
        storage.save(side === 'right' ? DNA_RIGHT_HIDDEN_KEY : DNA_LEFT_HIDDEN_KEY,
                     hide ? '1' : '0');
    }
    function initRailDefaults() {
        // Left: visible by default; only hide if user previously stored '1'.
        if (storage.get(DNA_LEFT_HIDDEN_KEY) === '1') applyRailHidden('left', true);
        // Right: hidden by default; only show if user previously stored '0'.
        if (storage.get(DNA_RIGHT_HIDDEN_KEY) !== '0') applyRailHidden('right', true);
    }
    if (railHideBtn)   railHideBtn.addEventListener('click',   function () { toggleRail('left',  true);  });
    if (railShowTab)   railShowTab.addEventListener('click',   function () { toggleRail('left',  false); });
    if (railHideBtnRt) railHideBtnRt.addEventListener('click', function () { toggleRail('right', true);  });
    if (railShowTabRt) railShowTabRt.addEventListener('click', function () { toggleRail('right', false); });

    /* revealDetailsPanel — called from activateBp() when the user clicks a
       base pair. Auto-expands the right rail if it's currently collapsed,
       so the user sees their selection's details without needing to hunt
       for the show-tab. Same pattern as Cell Atlas's revealTutorPanel. */
    function revealDetailsPanel() {
        if (!studioEl) return;
        if (studioEl.classList.contains('is-right-hidden')) {
            toggleRail('right', false);
        }
        // On mobile (single-column stack), scroll the details panel into
        // view since it now sits below the stage rather than beside it.
        if (window.innerWidth < 1100) {
            var panel = document.querySelector('.ca-right-rail .ca-panel');
            if (panel) {
                requestAnimationFrame(function () {
                    requestAnimationFrame(function () {
                        try { panel.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
                        catch (e) { panel.scrollIntoView(); }
                    });
                });
            }
        }
    }

    // ---------- Boot ----------
    function boot() {
        initRailDefaults();
        // Restore previously-active workbench tab.
        showRailTab(railTabStorage());
        // Make sure state.sequences is in sync with state.raw before
        // anything renders (so the default ATCG... string parses correctly).
        state.sequences = parseSeqs(state.raw);
        restoreFromUrl();
        if (seqInput) seqInput.value = state.raw;
        updateSeqStats();

        // Wait for DnaScene module (it loads via type=module so it may
        // boot AFTER this script). Poll with a small timeout.
        var tries = 0;
        function waitForScene() {
            if (window.DnaScene && canvas) {
                sceneController = window.DnaScene.mount(canvas, {
                    onPick: function (id) {
                        // Scene emits compound keys like "s0-bp3".
                        if (typeof id !== 'string' || !/^s\d+-bp\d+$/.test(id)) return;
                        activateBp(id);
                    }
                });
                pushSceneState();
                renderActiveBp();
                renderLegend();
                renderAnalysis();
                renderTutorPrompts();
                if (state.labelsVisible && labelsBtn) labelsBtn.classList.add('is-active');
                if (state.autoRotate && rotateBtn)    rotateBtn.classList.add('is-active');
                // Restore previously-active view-mode tab. JSP starts
                // with Linear active (new default); switch only if the
                // user explicitly saved 'studio' from a previous session.
                // Otherwise call switchToTab('linear') so the seqviz
                // lazy-load fires properly for the default landing.
                var savedTab = getPersistedViewTab();
                switchToTab(savedTab);
                return;
            }
            tries++;
            if (tries < 60) setTimeout(waitForScene, 50);
        }
        waitForScene();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
