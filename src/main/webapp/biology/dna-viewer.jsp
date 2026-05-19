<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        DNA Viewer 3D — biology-studio shell.

        Two view modes, both driven by the user's typed sequence:
        · 3D Helix — procedural three.js double helix with color-coded
          base pairs, numbered labels, click-to-inspect, AI tutor.
        · Linear View — annotated 2D map via seqviz (lazy-loaded from
          CDN) with restriction-enzyme cuts, codon translation, motif
          highlighting.
    --%>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="3D DNA Viewer — Free Online Sequence Analyzer, Translate, Reverse Complement, Find Restriction Sites" />
        <jsp:param name="toolCategory" value="Biology Tools" />
        <jsp:param name="toolDescription" value="Free online DNA viewer. Paste any sequence to render a rotating 3D double helix, translate DNA to protein, compute reverse complement, GC content and melting temperature (Tm), find restriction-enzyme cut sites (EcoRI, BamHI, HindIII + 9 more), search motifs, detect open reading frames (ORFs), and compare multiple sequences side-by-side. No signup, no install, works in any browser." />
        <jsp:param name="toolUrl" value="biology/dna-viewer.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="biology/" />
        <jsp:param name="toolKeywords" value="3d dna viewer, dna double helix 3d, interactive dna model, online dna sequence visualizer, dna helix 3d, dna structure 3d, free dna viewer, reverse complement online, dna to protein translator, translate dna to amino acid, codon translator online, gc content calculator, primer melting temperature, tm calculator, restriction enzyme finder, ecori cut site, bamhi cut site, hindiii finder, find orf online, open reading frame finder, motif search dna, compare dna sequences, dna alignment online, online plasmid viewer, plasmid map free, free sequence analysis tool, online sequence editor, snapgene alternative, benchling alternative, free dna analysis, fasta viewer online, watson crick base pair, adenine thymine guanine cytosine, purine pyrimidine, antiparallel dna strands, base pair viewer, iupac dna, ambiguity codes, no signup dna tool, free biology tool" />
        <jsp:param name="toolImage" value="dna-viewer-og.png" />
        <jsp:param name="toolFeatures" value="3D procedural double helix from any sequence,Color-coded A T G C base pairs,Click any base pair for biological details,AI biology tutor on demand,Annotated 2D linear map with codon translation,Restriction-enzyme cut-site mapping (EcoRI BamHI HindIII +9 more),Motif search with inline highlights,Reverse-complement and per-sequence stats,Multi-sequence side-by-side comparison,IUPAC and RNA support,100% free no signup" />
        <jsp:param name="teaches" value="DNA structure, Watson-Crick base pairing, purine vs pyrimidine, major minor groove, antiparallel strands, hydrogen bonding" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="faq1q" value="How do I view a DNA sequence in 3D for free?" />
        <jsp:param name="faq1a" value="Paste any DNA sequence (A, T, G, C — multiple sequences on separate lines for comparison) into the input box. The viewer renders a rotating, color-coded 3D double helix immediately. Free, runs entirely in your browser, no signup, no installation. Click any base pair to see its biology in the side panel, or use the Linear View tab for an annotated 2D map." />
        <jsp:param name="faq2q" value="How do I translate DNA to protein and find ORFs (open reading frames)?" />
        <jsp:param name="faq2a" value="The Workbench Stats tab translates each sequence into its 5'→3' amino-acid sequence using the standard genetic code, with stop codons shown as *. The Linear View also overlays a codon-by-codon protein strip directly under the sequence. Open reading frames are auto-detected — any ATG start codon followed by 20+ codons before a stop codon shows up as a pink 'ORF' annotation band on the sequence." />
        <jsp:param name="faq3q" value="How do I find restriction enzyme cut sites online?" />
        <jsp:param name="faq3a" value="Switch to the Linear View tab and click the 'Enzymes' dropdown. Tick any of 12 common restriction enzymes (EcoRI, BamHI, HindIII, NotI, XhoI, SalI, PstI, NdeI, KpnI, SacI, SmaI, XbaI) — cut-site markers appear inline on the sequence wherever the recognition site occurs. The 3D Helix tab also highlights the same positions if you type the recognition sequence (e.g., GAATTC for EcoRI) into the Workbench Search box." />
        <jsp:param name="faq4q" value="How do I compare two or more DNA sequences side by side?" />
        <jsp:param name="faq4a" value="Paste each sequence on its own line in the input box. The viewer renders them as side-by-side 3D helices (Studio tab) and as concentric rings in the Linear View's Circular or Both mode. For equal-length sequences, the Compare tab highlights every position that differs — perfect for visualizing point mutations like wild-type vs. mutant. Try the built-in 'Pair (WT/mut)' or 'Trio' presets to see this immediately." />
        <jsp:param name="faq5q" value="Is this a free alternative to SnapGene, Benchling, or other commercial DNA tools?" />
        <jsp:param name="faq5a" value="Yes — for visualization, codon translation, reverse complement, GC%, melting temperature (Tm), restriction-enzyme cut-site finding, motif/pattern search, ORF detection, and side-by-side sequence comparison, this tool is fully free and browser-based with no signup or account required. Built for students learning DNA structure, teachers preparing visual aids, and researchers needing fast sequence checks. The 3D helix view in particular isn't offered by most commercial sequence editors. Accepts FASTA from NCBI/Ensembl including IUPAC ambiguity codes (N, R, Y, S, W, K, M, B, D, H, V) and RNA (U)." />
    </jsp:include>

    <%-- SoftwareApplication schema for SERP "Free / Educational" badge. --%>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "DNA Viewer 3D",
      "url": "https://8gwifi.org/biology/dna-viewer.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any (browser)",
      "offers": { "@type": "Offer", "price": "0.00", "priceCurrency": "USD", "availability": "https://schema.org/InStock" },
      "browserRequirements": "Requires modern browser with WebGL and ES modules.",
      "isAccessibleForFree": true,
      "featureList": [
        "Procedural 3D double helix from any A/T/G/C sequence",
        "Color-coded Watson-Crick base pairs",
        "Click-to-inspect base pair biology",
        "Annotated 2D linear map with restriction enzymes and codon translation",
        "Motif search and per-sequence stats (GC%, Tm, reverse complement)",
        "Browser-only, no signup"
      ],
      "creator": { "@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org" }
    }
    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://unpkg.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/biology/css/biology-studio.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/biology/css/dna-viewer.css?v=<%=v%>">

    <%-- Three.js import map (resolves the bare 'three' specifier used by addons). --%>
    <script type="importmap">
    {
        "imports": {
            "three":         "https://unpkg.com/three@0.160.0/build/three.module.js",
            "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/"
        }
    }
    </script>

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="bs-body">

<jsp:include page="../modern/components/nav-header.jsp" />

<div class="bs-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="bs-main">

    <button type="button" id="bsSidebarToggle" class="bs-sidebar-toggle" aria-label="Open biology tools menu">
        &#9776; Biology tools
    </button>

    <% request.setAttribute("activeService", "dna-viewer"); %>
    <jsp:include page="/biology/partials/sidebar.jsp" />

    <section class="bs-workspace">

        <div class="ca-tool-root" id="dnaRoot">

            <header class="ca-tool-head">
                <div>
                    <h1>DNA Viewer 3D</h1>
                    <p>Paste a sequence &mdash; the double helix builds itself, color-coded by base.</p>
                </div>
            </header>

            <%-- View mode tabs — Linear View is the default (analysis surface);
                 3D Helix is the visual alternative. --%>
            <div class="dna-tabs" role="tablist">
                <button type="button" role="tab" id="dnaTabLinear" class="dna-tab is-active" aria-selected="true">
                    Linear View
                </button>
                <button type="button" role="tab" id="dnaTabStudio" class="dna-tab" aria-selected="false">
                    3D Helix
                </button>
            </div>

            <%-- ─────────── STUDIO MODE ─────────── --%>
            <div class="dna-grid ca-cell-grid" id="dnaStudio" hidden>

                <%-- Floating show-tabs — only visible when the matching rail is hidden.
                     Same pattern as Cell Atlas: position:absolute inside the grid,
                     stuck to the left or right edge of the stage. --%>
                <button type="button" class="ca-rail-show-tab is-left" id="dnaRailShowTab" aria-label="Show sequence editor">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <polyline points="9 6 15 12 9 18"></polyline>
                    </svg>
                    <span>Sequence</span>
                </button>
                <button type="button" class="ca-rail-show-tab is-right" id="dnaRailShowTabRight" aria-label="Show base-pair details">
                    <span>Details</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <polyline points="15 6 9 12 15 18"></polyline>
                    </svg>
                </button>

                <%-- Left rail: single tabbed panel (Benchling-style).
                     Tabs: Input | Stats | Search | Compare. Only one
                     visible at a time so the user focuses on one task. --%>
                <aside class="ca-left-rail">

                    <section class="ca-panel dna-rail-panel">
                        <div class="ca-panel-heading">
                            <span>Workbench</span>
                            <button type="button" class="ca-rail-collapse-btn" id="dnaRailHideBtn"
                                    aria-label="Hide workbench to widen the stage" title="Hide workbench">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <polyline points="15 6 9 12 15 18"></polyline>
                                </svg>
                            </button>
                        </div>

                        <%-- Tab nav --%>
                        <nav class="dna-rail-tabs" role="tablist" aria-label="Workbench tabs">
                            <button type="button" class="dna-rail-tab is-active" data-rail-tab="input"   role="tab" aria-selected="true">Input</button>
                            <button type="button" class="dna-rail-tab" data-rail-tab="stats"   role="tab" aria-selected="false">Stats</button>
                            <button type="button" class="dna-rail-tab" data-rail-tab="search"  role="tab" aria-selected="false">Search</button>
                            <button type="button" class="dna-rail-tab" data-rail-tab="compare" role="tab" aria-selected="false">Compare</button>
                        </nav>

                        <%-- INPUT TAB ───────────────────────────── --%>
                        <div class="dna-rail-tab-content" data-rail-tab="input" role="tabpanel">
                            <p class="dna-hint">
                                A, T, G, C, U (RNA), IUPAC ambiguity codes (N, R, Y, S, W, K, M, B, D, H, V) and gaps (<code>-</code> <code>.</code>) all accepted.
                                <strong>One sequence per line.</strong> FASTA <code>&gt;header</code> lines are skipped.
                            </p>
                            <textarea id="dnaSeqInput"
                                      class="dna-seq-input"
                                      rows="6"
                                      spellcheck="false"
                                      autocomplete="off"
                                      aria-label="DNA sequence input"
                                      placeholder=">seq1&#10;ATCGATCG&#10;>seq2&#10;GGGGCCCC"></textarea>
                            <div class="dna-seq-actions">
                                <button type="button" class="dna-mini-btn" data-preset="random">Random</button>
                                <button type="button" class="dna-mini-btn" data-preset="tata">TATA</button>
                                <button type="button" class="dna-mini-btn" data-preset="palindrome">Palindrome</button>
                                <button type="button" class="dna-mini-btn" data-preset="pair">Pair (WT/mut)</button>
                                <button type="button" class="dna-mini-btn" data-preset="trio">Trio</button>
                                <button type="button" class="dna-mini-btn" data-preset="clear">Clear</button>
                            </div>
                            <p class="dna-seq-stats" id="dnaSeqStats">&mdash;</p>
                            <%-- Non-canonical reporter — only shown when sequences contain
                                 RNA, IUPAC ambiguity codes, or gaps. Tells the user exactly
                                 what got accepted and how it's being rendered. --%>
                            <p class="dna-seq-noncanonical" id="dnaSeqNonCanonical" hidden></p>

                            <%-- Inline base-pair color key. Canonical bases first, then
                                 a separator, then the ambiguity and gap renderings so
                                 advanced users discover the broader alphabet. --%>
                            <div class="dna-bp-legend-inline" aria-label="Base color key">
                                <span class="dna-bp-chip" style="--bp:#e74c3c" title="Adenine"><b>A</b></span>
                                <span class="dna-bp-chip" style="--bp:#f1c40f" title="Thymine (DNA) / Uracil (RNA)"><b>T/U</b></span>
                                <span class="dna-bp-chip" style="--bp:#2ecc71" title="Guanine"><b>G</b></span>
                                <span class="dna-bp-chip" style="--bp:#3498db" title="Cytosine"><b>C</b></span>
                                <span class="dna-bp-legend-divider" aria-hidden="true"></span>
                                <span class="dna-bp-chip" style="--bp:#9aa0a6" title="IUPAC ambiguity codes (N, R, Y, S, W, K, M, B, D, H, V) render gray"><b>N</b></span>
                                <span class="dna-bp-chip dna-bp-chip-gap" title="Gap (- or .) — backbone runs through, no base-pair rung"><b>&minus;</b></span>
                            </div>
                        </div>

                        <%-- STATS TAB ───────────────────────────── --%>
                        <div class="dna-rail-tab-content" data-rail-tab="stats" role="tabpanel" hidden>
                            <p class="dna-hint">Length, GC content, melting temp, and 5′→3′ protein translation for each sequence.</p>
                            <div class="dna-stats" id="dnaStatsList"></div>
                        </div>

                        <%-- SEARCH TAB ──────────────────────────── --%>
                        <div class="dna-rail-tab-content" data-rail-tab="search" role="tabpanel" hidden>
                            <p class="dna-hint">Find a substring in any of your loaded sequences. Matches highlight in the 3D scene.</p>
                            <div class="dna-motif-row">
                                <label for="dnaMotifInput" class="dna-motif-label">Motif</label>
                                <input type="text" id="dnaMotifInput"
                                       class="dna-motif-input"
                                       placeholder="e.g., GAATTC"
                                       spellcheck="false"
                                       autocomplete="off"
                                       aria-label="Motif to search for">
                                <button type="button" id="dnaMotifClear" class="dna-motif-clear" hidden title="Clear motif">&times;</button>
                            </div>
                            <%-- Quick-pick motif chips for common biology sites. --%>
                            <div class="dna-motif-presets">
                                <span class="dna-motif-presets-label">Common:</span>
                                <button type="button" class="dna-mini-btn" data-motif="GAATTC" title="EcoRI restriction site">GAATTC</button>
                                <button type="button" class="dna-mini-btn" data-motif="GGATCC" title="BamHI restriction site">GGATCC</button>
                                <button type="button" class="dna-mini-btn" data-motif="ATG"    title="Start codon">ATG</button>
                                <button type="button" class="dna-mini-btn" data-motif="TATAAA" title="TATA box">TATAAA</button>
                            </div>
                            <p class="dna-motif-status" id="dnaMotifStatus"></p>
                        </div>

                        <%-- COMPARE TAB ─────────────────────────── --%>
                        <div class="dna-rail-tab-content" data-rail-tab="compare" role="tabpanel" hidden>
                            <p class="dna-hint">Highlight positions that differ between aligned sequences. Requires two or more sequences of <strong>equal length</strong>.</p>
                            <div class="dna-mismatch-row" id="dnaMismatchRow">
                                <button type="button" id="dnaMismatchBtn" class="dna-mini-btn">
                                    <span aria-hidden="true">&#9788;</span> Highlight mismatches
                                </button>
                            </div>
                            <p class="dna-mismatch-info" id="dnaMismatchInfo"></p>
                            <p class="dna-hint dna-compare-hint" id="dnaCompareHint" hidden>
                                Load two sequences of the same length to enable mismatch highlighting. Try the <em>Pair (WT/mut)</em> preset.
                            </p>
                        </div>
                    </section>
                </aside>

                <%-- Center: 3D stage --%>
                <section class="ca-stage-panel">
                    <div class="ca-stage-title">
                        <h2 id="dnaStageTitle">Double Helix</h2>
                        <p id="dnaStageInfo">B-DNA, 5&prime; &rarr; 3&prime;</p>
                    </div>

                    <div class="ca-canvas-wrap" id="dnaCanvasWrap">
                        <canvas id="dnaCanvas" aria-label="DNA double helix 3D viewer"></canvas>

                        <div class="ca-loader is-hidden" id="dnaLoader" aria-hidden="true">
                            <div class="ca-loader-card">
                                <strong id="dnaLoaderName">Building helix&hellip;</strong>
                                <span class="ca-loader-bar"><span class="ca-loader-fill" id="dnaLoaderBar"></span></span>
                                <em id="dnaLoaderPct">0%</em>
                            </div>
                        </div>
                    </div>

                    <div class="ca-stage-toolbar">
                        <button type="button" id="dnaRotateBtn" title="Toggle auto-rotation (R)">&#8635; Rotate</button>
                        <button type="button" id="dnaLabelsBtn" title="Show numbered base-pair pucks (L)">&#127991;&#65039; Labels</button>
                        <button type="button" id="dnaIsolateBtn" title="Dim non-active base pairs (F)">&#9678; Isolate</button>
                        <button type="button" id="dnaResetBtn" title="Reset camera + view mode">&#8634; Reset View</button>
                    </div>

                    <div class="ca-export-toolbar">
                        <button type="button" id="dnaScreenshotBtn" title="Save the current view as PNG (S)">&#128247; Screenshot</button>
                        <button type="button" id="dnaShareBtn" title="Copy a URL that reproduces this exact view">&#128279; Share</button>
                        <button type="button" id="dnaPrintBtn" title="Open the printer-friendly view">&#128424; Print</button>
                        <button type="button" id="dnaHelpBtn" title="Keyboard shortcuts (press ?)">&#9072; Shortcuts</button>
                    </div>

                    <div class="ca-organelle-legend" id="dnaLegend" hidden></div>
                </section>

                <%-- Right rail: selected-base-pair details + AI tutor --%>
                <aside class="ca-right-rail">
                    <section class="ca-panel">
                        <div class="ca-panel-heading">
                            <span>Base Pair Details</span>
                            <button type="button" class="ca-rail-collapse-btn" id="dnaRailHideBtnRight"
                                    aria-label="Hide details panel to widen the stage" title="Hide details panel">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <polyline points="9 6 15 12 9 18"></polyline>
                                </svg>
                            </button>
                        </div>
                        <div class="ca-detail-hero">
                            <span class="ca-organelle-orb" id="dnaBpOrb"></span>
                            <div>
                                <h3 id="dnaBpName">Pick a base pair</h3>
                                <p id="dnaBpSubtitle">Click any rung in the helix to inspect it.</p>
                            </div>
                        </div>
                        <dl class="ca-detail-attrs" id="dnaBpAttrs"></dl>
                        <p class="ca-detail-note" id="dnaBpNote"></p>
                        <p class="ca-detail-fact" id="dnaBpFact"></p>
                    </section>

                    <section class="ca-panel" id="dnaTutorPanel">
                        <div class="ca-panel-heading"><span>&#129504; AI Tutor</span></div>

                        <div class="ca-tutor-output" id="dnaTutorOutput" data-state="idle">
                            <div class="ca-tutor-output-head">
                                <span>&#128172; Tutor reply</span>
                                <span class="ca-tutor-meta" id="dnaTutorMeta">Pick a prompt below or type a question.</span>
                            </div>
                            <div class="ca-tutor-body" id="dnaTutorBody">
                                <p class="ca-tutor-placeholder">Replies appear here.</p>
                            </div>
                        </div>

                        <div class="ca-prompt-list" id="dnaPromptList"></div>

                        <form class="ca-tutor-form" id="dnaTutorForm">
                            <input type="text" id="dnaTutorInput" autocomplete="off"
                                   placeholder="Ask about this base pair or the helix&hellip;"
                                   aria-label="Custom question for the AI tutor">
                            <button type="submit" id="dnaTutorSubmit" title="Send (Enter)">Ask</button>
                            <button type="button" id="dnaTutorClearBtn" class="ca-tutor-clear"
                                    title="Clear conversation history" hidden>Clear</button>
                        </form>
                    </section>
                </aside>
            </div>

            <%-- ─────────── LINEAR (seqviz) MODE ─────────── --%>
            <div class="dna-grid dna-linear-grid" id="dnaLinear">
                <section class="ca-stage-panel dna-linear-panel">
                    <div class="ca-stage-title">
                        <h2>Linear DNA Map</h2>
                        <p id="dnaLinearInfo">Annotated 2D map &mdash; find motifs, see codon translation, mark restriction-enzyme cuts.</p>
                    </div>

                    <div class="dna-seqviz-controls">
                        <span class="dna-seqviz-controls-label">View:</span>
                        <button type="button" class="dna-mini-btn"           data-seqviz-view="linear">Linear</button>
                        <button type="button" class="dna-mini-btn"           data-seqviz-view="circular">Circular</button>
                        <button type="button" class="dna-mini-btn is-active" data-seqviz-view="both">Both</button>

                        <span class="dna-seqviz-controls-spacer"></span>

                        <label class="dna-seqviz-controls-check">
                            <input type="checkbox" id="dnaSeqvizComplement" checked> Complement
                        </label>
                        <label class="dna-seqviz-controls-check">
                            <input type="checkbox" id="dnaSeqvizIndex" checked> Ruler
                        </label>
                        <label class="dna-seqviz-controls-check">
                            <input type="checkbox" id="dnaSeqvizTranslation" checked> Translation
                        </label>
                        <label class="dna-seqviz-controls-check">
                            <input type="checkbox" id="dnaSeqvizAnnotations" checked> Annotations
                        </label>

                        <%-- Restriction-enzyme picker — collapsed dropdown to keep the
                             toolbar compact. Each common enzyme has a built-in seqviz
                             entry that draws cut-site markers when toggled on. --%>
                        <details class="dna-seqviz-enzymes">
                            <summary>Enzymes <span id="dnaSeqvizEnzymeCount" class="dna-seqviz-enzyme-count"></span></summary>
                            <div class="dna-seqviz-enzymes-grid" id="dnaSeqvizEnzymesGrid">
                                <label><input type="checkbox" value="EcoRI"  data-enzyme> EcoRI</label>
                                <label><input type="checkbox" value="BamHI"  data-enzyme> BamHI</label>
                                <label><input type="checkbox" value="HindIII" data-enzyme> HindIII</label>
                                <label><input type="checkbox" value="NotI"   data-enzyme> NotI</label>
                                <label><input type="checkbox" value="XhoI"   data-enzyme> XhoI</label>
                                <label><input type="checkbox" value="SalI"   data-enzyme> SalI</label>
                                <label><input type="checkbox" value="PstI"   data-enzyme> PstI</label>
                                <label><input type="checkbox" value="NdeI"   data-enzyme> NdeI</label>
                                <label><input type="checkbox" value="KpnI"   data-enzyme> KpnI</label>
                                <label><input type="checkbox" value="SacI"   data-enzyme> SacI</label>
                                <label><input type="checkbox" value="SmaI"   data-enzyme> SmaI</label>
                                <label><input type="checkbox" value="XbaI"   data-enzyme> XbaI</label>
                            </div>
                        </details>
                    </div>

                    <%-- Selection-info strip — shows when user click-drags
                         to select a range in any seqviz viewer. Surfaces
                         seqviz's onSelection callback output. --%>
                    <p class="dna-seqviz-selection" id="dnaSeqvizSelection" hidden></p>

                    <div class="dna-seqviz-mount-list" id="dnaSeqvizMounts" aria-label="Linear sequence viewers"></div>

                    <p class="dna-seqviz-credit">
                        Shares the sequence with the 3D Helix view. Use the <strong>Search</strong>
                        tab in the Workbench to highlight a motif here too.
                        <span class="dna-seqviz-credit-fineprint">Rendering by <a href="https://github.com/Lattice-Automation/seqviz" target="_blank" rel="noopener">seqviz</a> (MIT).</span>
                    </p>
                </section>
            </div>

        </div>

        <%-- In-content ad --%>
        <div class="bs-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- FAQ — visible block matching the JSON-LD set above for SEO compliance. -->
        <section class="bs-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="bs-faq-title" id="faqs">Frequently asked</h2>
            <div class="bs-faq" aria-label="DNA Viewer 3D FAQ">
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        How do I view a DNA sequence in 3D for free?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Paste any DNA sequence (A, T, G, C &mdash; multiple sequences on separate lines for comparison) into the input box. The viewer renders a rotating, color-coded 3D double helix immediately. Free, runs entirely in your browser, no signup, no installation. Click any base pair to see its biology in the side panel, or use the Linear View tab for an annotated 2D map.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        How do I translate DNA to protein and find ORFs?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">The Workbench &rarr; Stats tab translates each sequence into its 5&prime;&rarr;3&prime; amino-acid sequence using the standard genetic code, with stop codons shown as <code>*</code>. The Linear View also overlays a codon-by-codon protein strip directly under the sequence. Open reading frames are auto-detected &mdash; any <code>ATG</code> followed by 20+ codons before a stop codon shows up as a pink &lsquo;ORF&rsquo; annotation band.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        How do I find restriction enzyme cut sites?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Switch to the Linear View tab and click the &lsquo;Enzymes&rsquo; dropdown. Tick any of 12 common restriction enzymes (EcoRI, BamHI, HindIII, NotI, XhoI, SalI, PstI, NdeI, KpnI, SacI, SmaI, XbaI) &mdash; cut-site markers appear inline on the sequence. The 3D Helix tab also highlights the same positions if you type the recognition site (e.g., <code>GAATTC</code> for EcoRI) into the Workbench Search box.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        How do I compare two or more DNA sequences side by side?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Paste each sequence on its own line. The viewer renders them as side-by-side 3D helices (Studio tab) and as concentric rings (Linear View, Circular or Both mode). For equal-length sequences, the Compare tab highlights every position that differs &mdash; perfect for visualizing point mutations like wild-type vs.&nbsp;mutant. Try the built-in <em>Pair (WT/mut)</em> or <em>Trio</em> presets to see this immediately.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        Is this a free alternative to commercial DNA tools (SnapGene, Benchling)?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Yes &mdash; for visualization, codon translation, reverse complement, GC%, Tm, restriction-enzyme cut-site finding, motif/pattern search, ORF detection, and side-by-side sequence comparison, this tool is fully free and browser-based with no signup or account. Built for students learning DNA structure, teachers preparing visual aids, and researchers doing quick sequence checks. The 3D helix view in particular isn't offered by most commercial sequence editors. Accepts FASTA from NCBI/Ensembl including IUPAC ambiguity codes (<code>N, R, Y, S, W, K, M, B, D, H, V</code>) and RNA (<code>U</code>).</div>
                </div>
            </div>
        </section>

    </section>
</main>

<%-- Print handout — hidden onscreen, visible only in @media print.
     The Print button calls renderPrintView() to populate this from the
     current state before invoking window.print(). WebGL canvases print
     blank, so we hand the printer a data-driven sequence-analysis sheet
     instead. --%>
<aside class="dna-print-view" id="dnaPrintView" aria-hidden="true"></aside>

<%-- Keyboard shortcuts help overlay. Same pattern as Cell Atlas. --%>
<div class="ca-help-overlay" id="dnaHelpOverlay" role="dialog" aria-modal="true" aria-labelledby="dnaHelpTitle">
    <div class="ca-help-modal">
        <button type="button" class="ca-help-close" id="dnaHelpClose" aria-label="Close shortcuts">Close</button>
        <h3 id="dnaHelpTitle">Keyboard shortcuts</h3>
        <p>Click a base pair in any view to inspect it.</p>
        <dl>
            <div><dt>R</dt><dd>Toggle auto-rotation (3D Helix only)</dd></div>
            <div><dt>L</dt><dd>Toggle numbered base-pair labels</dd></div>
            <div><dt>F</dt><dd>Isolate mode &mdash; dim non-active base pairs</dd></div>
            <div><dt>S</dt><dd>Screenshot (save 3D scene as PNG)</dd></div>
            <div><dt>C</dt><dd>Copy share URL</dd></div>
            <div><dt>[ &nbsp; ]</dt><dd>Previous / next base pair</dd></div>
            <div><dt>1 &nbsp; 2</dt><dd>Switch view: 3D Helix / Linear View</dd></div>
            <div><dt>Esc</dt><dd>Close any open dialog</dd></div>
            <div><dt>?</dt><dd>Toggle this help</dd></div>
        </dl>
    </div>
</div>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<%-- Page script --%>
<script type="module" src="<%=request.getContextPath()%>/biology/js/dna-scene.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/biology/js/dna-circular.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/biology/js/dna-page.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%-- seqviz is lazy-loaded by dna-page.js on first Linear View tab click. --%>

<%-- FAQ toggle — matches biology/index.jsp behavior. --%>
<script>
(function () {
    document.querySelectorAll('.bs-faq-q').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var item = btn.closest('.bs-faq-item');
            if (item) item.classList.toggle('open');
        });
    });
})();
</script>

</body>
</html>
