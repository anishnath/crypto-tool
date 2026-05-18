<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Cell Atlas 3D — biology-studio shell.

        Vanilla-JS + Three.js interactive cell viewer. Dependencies are
        loaded as ES modules from CDN (no build step):
          · three.js (+ addons: OrbitControls, GLTFLoader, RoundedBoxGeometry)

        12 specimen cells: plant, white-blood, red-blood, neuron, epithelial,
        bacteria, animal, muscle, cardiomyocyte, sperm, yeast, virus.
        3 are backed by self-hosted NIH 3D GLBs under /biology/assets/models/
        (animal, neuron, bacteria); the other 9 render with procedural
        three.js geometry built in cell-scene.js.
    --%>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Cell Atlas 3D — 12 Interactive Cells, Click Any Organelle (Free)" />
        <jsp:param name="toolCategory" value="Biology Tools" />
        <jsp:param name="toolDescription" value="Click any cell apart, in 3D. 12 specimens (plant, animal, neuron, virus + 8 more), 60+ organelles, a real slicing-plane cross-section, AI tutor, and matched microscopy photos. Free, browser-only, no signup." />
        <jsp:param name="toolUrl" value="biology/cell-atlas.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="biology/" />
        <jsp:param name="toolKeywords" value="3d cell viewer, cell atlas 3d, click organelle, animal cell 3d, plant cell 3d, neuron 3d model, bacteria 3d, virus 3d, sperm cell, yeast cell, cardiomyocyte, red blood cell, white blood cell, mitochondrion, chloroplast, nucleus, golgi, ribosome, endoplasmic reticulum, interactive cell biology, cross-section slicer, ai biology tutor, microscopy photos, nih 3d, free cell anatomy, browser-only biology" />
        <jsp:param name="toolImage" value="cell-atlas-og.png" />
        <jsp:param name="toolFeatures" value="12 cell specimens (plant animal neuron bacteria white-blood red-blood epithelial muscle cardiomyocyte sperm yeast virus),3D models from NIH 3D for animal/neuron/bacteria,Highlight individual organelles,Focus mode + slicing-plane cross-section,Auto-rotate playback,Side-by-side cell comparison,Per-cell biological notes and fun facts,Mobile responsive,100% free no signup" />
        <jsp:param name="teaches" value="Cell biology, organelle function, prokaryote vs eukaryote, plant vs animal cell differences, comparative cell anatomy" />
        <jsp:param name="educationalLevel" value="Middle School, High School, Undergraduate" />
        <jsp:param name="faq1q" value="What cell types can I explore in this 3D viewer?" />
        <jsp:param name="faq1a" value="Twelve distinct cells — plant cell, animal cell, neuron, bacteria, white blood cell, red blood cell, epithelial cell, skeletal muscle, cardiomyocyte (heart muscle), sperm cell, yeast (fungal cell), and a virus particle. Three of them — animal, neuron, and bacteria — render real NIH 3D Print Exchange GLB models for scientific fidelity. The other nine use procedural Three.js geometry tuned to each cell's characteristic shape." />
        <jsp:param name="faq2q" value="Where do the 3D models come from?" />
        <jsp:param name="faq2a" value="The Animal Cell (3DPX-015797), Neuron (3DPX-015796), and Gram Positive Cell Wall / Bacteria (3DPX-010752) GLBs are sourced from the NIH 3D Print Exchange (https://3d.nih.gov), used under their CC BY-NC-SA 4.0 license. They are self-hosted on this site to avoid CORS issues that block browser loading from NIH's CDN. Procedural cells are hand-modelled with Three.js primitives (spheres, capsules, torus rings, Catmull-Rom curve tubes)." />
        <jsp:param name="faq3q" value="How do I highlight a specific organelle?" />
        <jsp:param name="faq3a" value="Pick a cell on the left rail (Cell Types), then click any organelle below (Nucleus, Mitochondrion, Golgi, etc.). The selected organelle glows in the 3D scene and the right-rail Organelle Details panel updates with size, location, and biological notes. Switch the View Mode toggle to 'Focus' to dim every non-active organelle so the highlight stands out, and use Cross Section to make outer membranes semi-transparent." />
        <jsp:param name="faq4q" value="Is this free and does it run in the browser?" />
        <jsp:param name="faq4a" value="Yes — everything runs locally in your browser using WebGL via Three.js. No signup, no server-side compute, no telemetry. The NIH GLBs are loaded once and cached." />
        <jsp:param name="faq5q" value="What's the difference between plant and animal cells in the viewer?" />
        <jsp:param name="faq5a" value="Open Plant Cell to see chloroplasts (light-harvesting green organelles), a large central vacuole, and the rigid cellulose-rich cell wall — none of which appear in animal cells. Animal Cell shows mitochondria, a centrally placed nucleus, and the flat-stacked Golgi apparatus. The 'Open Comparison View' button puts the two side-by-side." />
        <jsp:param name="faq6q" value="Does the viewer work on mobile?" />
        <jsp:param name="faq6a" value="Yes — the three-column layout collapses on narrower screens, the biology sidebar slides in as a drawer, and OrbitControls accepts touch gestures (one-finger rotate, two-finger pan/pinch-to-zoom). 3D model file sizes are small (4-5 MB total) so it works on mobile data." />
    </jsp:include>

    <%-- SoftwareApplication schema — drives "Free / Educational" badge in SERP. --%>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Cell Atlas 3D",
      "url": "https://8gwifi.org/biology/cell-atlas.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any (browser)",
      "offers": { "@type": "Offer", "price": "0.00", "priceCurrency": "USD", "availability": "https://schema.org/InStock" },
      "browserRequirements": "Requires modern browser with WebGL and ES modules.",
      "isAccessibleForFree": true,
      "featureList": [
        "Seven cell specimens (plant, animal, neuron, bacteria, white blood, epithelial, muscle)",
        "Interactive Three.js 3D scene with OrbitControls",
        "Per-organelle focus mode and cross-section toggle",
        "NIH 3D GLB models (CC BY-NC-SA)",
        "Comparative cell view"
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

    <% request.setAttribute("activeService", "cell-atlas"); %>
    <jsp:include page="/biology/partials/sidebar.jsp" />

    <section class="bs-workspace">

        <%--
            The tool's interior layout (left rail / stage / right rail) lives
            inside `.ca-tool-root`. CSS variables on that element retint the
            whole tool when the cell selection changes (set in the page
            script below).
        --%>
        <div class="ca-tool-root" id="caRoot">

            <header class="ca-tool-head">
                <div>
                    <h1>Cell Atlas 3D</h1>
                    <p>Explore life at the microscopic level &mdash; 12 cells, 3D, organelle-aware.</p>
                </div>
            </header>

            <div class="ca-cell-grid" id="caGrid">

                <%-- Floating "show" tabs — invisible until the matching .is-*-hidden class lands on .ca-cell-grid. --%>
                <button type="button" class="ca-rail-show-tab is-left" id="caRailShowTab" aria-label="Show cell list">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <polyline points="9 6 15 12 9 18"></polyline>
                    </svg>
                    <span>Cells</span>
                </button>
                <button type="button" class="ca-rail-show-tab is-right" id="caRailShowTabRight" aria-label="Show tutor panel">
                    <span>Tutor</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <polyline points="15 6 9 12 15 18"></polyline>
                    </svg>
                </button>

                <!-- ─────── Left rail: cell types + organelles ─────── -->
                <aside class="ca-left-rail">
                    <section class="ca-panel">
                        <div class="ca-panel-heading">
                            <span>&#127807; Cell Types</span>
                            <button type="button" class="ca-rail-collapse-btn" id="caRailHideBtn"
                                    aria-label="Hide cell list to widen the stage" title="Hide cell list">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <polyline points="15 6 9 12 15 18"></polyline>
                                </svg>
                            </button>
                        </div>
                        <div class="ca-cell-list" id="caCellList" role="listbox" aria-label="Cell types"></div>
                    </section>

                    <section class="ca-panel">
                        <div class="ca-panel-heading">
                            <span>&#9728; Organelles</span>
                        </div>
                        <div class="ca-organelle-list" id="caOrganelleList" role="listbox" aria-label="Organelles"></div>
                    </section>
                </aside>

                <!-- ─────── Center: stage + bottom panels ─────── -->
                <div class="ca-center-stack">
                    <section class="ca-stage-panel">
                        <div class="ca-stage-title">
                            <div>
                                <h2 id="caStageName">Animal Cell</h2>
                                <p id="caStageType">Eukaryotic Cell</p>
                            </div>

                            <div class="ca-view-card">
                                <span>View Mode</span>
                                <div class="ca-mode-switcher" id="caModeSwitcher">
                                    <button type="button" data-mode="mesh" class="is-active" title="Mesh">&#9633;</button>
                                    <button type="button" data-mode="focus" title="Focus">&#9678;</button>
                                </div>
                                <label class="ca-toggle-line">
                                    <span>Cross Section</span>
                                    <input type="checkbox" id="caCrossSection">
                                    <i></i>
                                </label>
                                <%-- Slicing-plane depth slider; revealed when cross-section is on.
                                     Range -1.5 to 1.5; 0 = clip top half. --%>
                                <label class="ca-clip-slider" id="caClipSliderWrap" hidden>
                                    <span>Slice depth</span>
                                    <input type="range" id="caClipY" min="-1.5" max="1.5" step="0.02" value="0"
                                           aria-label="Cross-section depth">
                                </label>
                            </div>
                        </div>

                        <div class="ca-canvas-wrap" id="caCanvasWrap">
                            <canvas id="caCanvas" aria-label="3D cell scene"></canvas>
                            <div class="ca-model-loader is-hidden" id="caLoader" aria-live="polite">
                                <div>
                                    <span>Loading 3D specimen</span>
                                    <strong id="caLoaderName">Cell</strong>
                                    <i><b id="caLoaderBar" style="width:8%"></b></i>
                                    <em id="caLoaderPct">8%</em>
                                </div>
                            </div>
                        </div>

                        <div class="ca-stage-toolbar">
                            <button type="button" id="caRotateBtn" title="Slowly spin the cell — pauses automatically when you click an organelle (R)">&#8635; Rotate</button>
                            <button type="button" id="caLabelsBtn" title="Show name + color chip next to each organelle (L)">&#127991;&#65039; Labels</button>
                            <button type="button" id="caIsolateBtn" title="Dim non-active organelles">&#9678; Isolate</button>
                            <button type="button" id="caHideBtn" title="Isolate + make outer membrane transparent">&#128065; Hide Others</button>
                            <button type="button" id="caResetBtn" title="Reset camera + view mode">&#8634; Reset View</button>
                        </div>

                        <div class="ca-export-toolbar">
                            <button type="button" id="caScreenshotBtn" title="Save the current view as PNG (S)">&#128247; Screenshot</button>
                            <button type="button" id="caShareBtn" title="Copy a URL that reproduces this exact view">&#128279; Share</button>
                            <button type="button" id="caPrintBtn" title="Open the printer-friendly view">&#128424; Print</button>
                            <button type="button" id="caHelpBtn" title="Keyboard shortcuts (press ?)">&#9072; Shortcuts</button>
                            <button type="button" id="caGlbBtn" title="GLB export coming soon">&#128230; GLB</button>
                        </div>

                        <%-- Numbered organelle legend — paired with the
                             in-scene numbered pucks. Visibility tracks the
                             Labels toolbar toggle. Clicking a legend item
                             activates the matching organelle (same flow as
                             clicking it in the side rail or on the puck). --%>
                        <div class="ca-organelle-legend" id="caLegend" hidden></div>
                    </section>

                    <!-- Bottom row: microscope grid + compare -->
                    <section class="ca-bottom-grid">
                        <div class="ca-panel">
                            <div class="ca-panel-heading"><span>Microscope View</span></div>
                            <div class="ca-micro-card-row" id="caMicroRow"></div>
                        </div>

                        <div class="ca-panel">
                            <div class="ca-panel-heading"><span>Compare Cells</span></div>
                            <div class="ca-compare-row" id="caCompareRow"></div>
                            <button type="button" class="ca-comparison-button" id="caCompareBtn">
                                Open Comparison View &rarr;
                            </button>
                        </div>
                    </section>
                </div>

                <!-- ─────── Right rail: details + notes + tutor + occurrence ─────── -->
                <aside class="ca-right-rail">
                    <section class="ca-panel">
                        <div class="ca-panel-heading">
                            <span>Organelle Details</span>
                            <div style="display:inline-flex; align-items:center; gap:4px;">
                                <button type="button" id="caFavBtn" aria-label="Toggle favorite">&#9825;</button>
                                <button type="button" class="ca-rail-collapse-btn" id="caRailHideBtnRight"
                                        aria-label="Hide tutor panel to widen the stage" title="Hide tutor panel">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <polyline points="9 6 15 12 9 18"></polyline>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="ca-detail-hero">
                            <span class="ca-organelle-orb" id="caOrgOrb"></span>
                            <div>
                                <h3 id="caOrgName">Nucleus</h3>
                                <p id="caOrgSubtitle">The control center</p>
                            </div>
                        </div>

                        <dl class="ca-attribute-list" id="caOrgAttrs"></dl>
                    </section>

                    <section class="ca-panel">
                        <div class="ca-panel-heading"><span>Biological Notes</span></div>
                        <p id="caOrgNote">&mdash;</p>
                        <div class="ca-fun-fact">
                            <span id="caOrgFact">&mdash;</span>
                            <span>&#10024;</span>
                        </div>
                    </section>

                    <section class="ca-panel" id="caTutorPanel">
                        <div class="ca-panel-heading"><span>&#129504; AI Tutor</span></div>

                        <div class="ca-lesson-focus">
                            <span>&#127919; Current lesson focus</span>
                            <p id="caLesson">&mdash;</p>
                        </div>

                        <%--
                            AI tutor output. Streams chunked replies from AIProxyServlet
                            (POST /ai with stream:true). First-token latency is variable
                            on a cold model load, so the loading state surfaces an
                            explicit wait-time hint.
                        --%>
                        <div class="ca-tutor-output" id="caTutorOutput" data-state="idle">
                            <div class="ca-tutor-output-head">
                                <span>&#128172; Tutor reply</span>
                                <span class="ca-tutor-meta" id="caTutorMeta">Pick a prompt below or type a question.</span>
                            </div>
                            <div class="ca-tutor-body" id="caTutorBody">
                                <p class="ca-tutor-placeholder">Replies appear here.</p>
                            </div>
                        </div>

                        <div class="ca-prompt-list" id="caPromptList"></div>

                        <form class="ca-tutor-form" id="caTutorForm">
                            <input type="text" id="caTutorInput" autocomplete="off"
                                   placeholder="Ask the tutor about this cell…"
                                   aria-label="Custom question for the AI tutor">
                            <button type="submit" id="caTutorSubmit" title="Send (Enter)">Ask</button>
                            <button type="button" id="caTutorClearBtn" class="ca-tutor-clear"
                                    title="Clear conversation history" hidden>Clear</button>
                        </form>
                    </section>

                    <section class="ca-panel">
                        <div class="ca-panel-heading"><span>Where It Occurs</span></div>
                        <div class="ca-occurrence-art" id="caOccArt"><span></span><i></i><b></b></div>
                        <h4 id="caOccTitle">&mdash;</h4>
                        <p id="caOccBody">&mdash;</p>
                    </section>
                </aside>

            </div>
        </div>

    </section>
</main>

<%-- Print handout — hidden onscreen, visible only in @media print. The
     Print button calls renderPrintView() to populate this from the
     currently-selected cell's data, then triggers window.print(). The
     WebGL canvas prints blank otherwise (preserveDrawingBuffer:false),
     so we hand the printer a data-driven reference page instead. --%>
<aside class="ca-print-view" id="caPrintView" aria-hidden="true"></aside>

<!-- Comparison modal -->
<div class="ca-modal-layer" id="caModalLayer" role="dialog" aria-modal="true" aria-labelledby="caModalTitle">
    <div class="ca-comparison-modal" id="caModal">
        <button type="button" class="ca-modal-close" id="caModalClose">Close</button>
        <div class="ca-modal-head">
            <h3 id="caModalTitle">Comparison View</h3>
            <p id="caModalSubtitle">&mdash;</p>
        </div>
        <div class="ca-comparison-columns" id="caModalColumns"></div>
    </div>
</div>

<!-- Microscope image lightbox -->
<div class="ca-lightbox" id="caLightbox" role="dialog" aria-modal="true" aria-labelledby="caLightboxCaption">
    <div class="ca-lightbox-inner">
        <button type="button" class="ca-lightbox-close" id="caLightboxClose" aria-label="Close (Esc)">&times;</button>
        <button type="button" class="ca-lightbox-prev"  id="caLightboxPrev"  aria-label="Previous image (←)">&#8249;</button>
        <button type="button" class="ca-lightbox-next"  id="caLightboxNext"  aria-label="Next image (→)">&#8250;</button>
        <div class="ca-lightbox-stage">
            <img id="caLightboxImg" alt="" />
        </div>
        <div class="ca-lightbox-meta">
            <div class="ca-lightbox-caption" id="caLightboxCaption">&mdash;</div>
            <div class="ca-lightbox-credit">
                <a id="caLightboxSource" target="_blank" rel="noopener noreferrer">View source</a>
            </div>
        </div>
    </div>
</div>

<!-- Hidden file picker for the "Add Image" microscope card. -->
<input type="file" id="caAddImageInput" accept="image/*" style="display:none" aria-hidden="true">

<!-- Toast -->
<div class="ca-toast" id="caToast" role="status" aria-live="polite"></div>

<!-- Keyboard shortcuts help overlay -->
<div class="ca-help-overlay" id="caHelpOverlay" role="dialog" aria-modal="true" aria-labelledby="caHelpTitle">
    <div class="ca-help-modal">
        <button type="button" class="ca-help-close" id="caHelpClose" aria-label="Close shortcuts">Close</button>
        <h3 id="caHelpTitle">Keyboard shortcuts</h3>
        <p>Tip: click an organelle directly in the 3D view to select it.</p>
        <dl>
            <div><dt>1 – 7</dt><dd>Select cell</dd></div>
            <div><dt>[ &nbsp; ]</dt><dd>Previous / next organelle</dd></div>
            <div><dt>R</dt><dd>Toggle auto-rotate</dd></div>
            <div><dt>F</dt><dd>Toggle focus mode</dd></div>
            <div><dt>X</dt><dd>Toggle cross-section</dd></div>
            <div><dt>S</dt><dd>Screenshot</dd></div>
            <div><dt>C</dt><dd>Copy share URL</dd></div>
            <div><dt>Esc</dt><dd>Close any popup</dd></div>
            <div><dt>?</dt><dd>This help</dd></div>
        </dl>
    </div>
</div>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>

<script>
    // Tell cells-data.js where the assets live. Swap this URL later to a
    // jsDelivr GitHub-CDN URL once the GLBs/PNGs are mirrored on git.
    window.BIOLOGY_ASSET_BASE = '<%=request.getContextPath()%>/biology/assets';
</script>
<%-- Site-wide helper library: clipboard, URL share, storage, etc. --%>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/biology/js/cells-data.js"></script>

<%--
    cell-scene.js is an ES module that imports `three` and the addons via the
    import map declared above. It registers window.BiologyCellScene on load.
    We can't `await import` inline from a classic script, so the page-script
    polls briefly (cheap, expected within a frame or two).
--%>
<script type="module" src="<%=request.getContextPath()%>/biology/js/cell-scene.js"></script>

<script>
(function () {
    'use strict';

    /* ===== State ===================================================== */
    var cells = window.BIOLOGY_CELLS;
    var getCellById = window.BIOLOGY_getCellById;

    var state = {
        selectedCellId: 'animal',
        activeOrganelle: 'mitochondrion',
        viewMode: 'mesh',
        crossSection: false,
        clipY: 0,
        autoRotate: false,
        labelsVisible: false,
        favorites: new Set(['animal'])
    };

    var sceneController = null;
    var toastTimer = null;

    /* ===== Element refs ============================================== */
    var $ = function (id) { return document.getElementById(id); };
    var root = $('caRoot');
    var cellList = $('caCellList');
    var organelleList = $('caOrganelleList');
    var stageName = $('caStageName');
    var stageType = $('caStageType');
    var canvas = $('caCanvas');
    var canvasWrap = $('caCanvasWrap');
    var loader = $('caLoader');
    var loaderName = $('caLoaderName');
    var loaderBar = $('caLoaderBar');
    var loaderPct = $('caLoaderPct');
    var modeSwitcher = $('caModeSwitcher');
    var crossSectionInput = $('caCrossSection');
    var clipSliderWrap = $('caClipSliderWrap');
    var clipSlider = $('caClipY');
    var rotateBtn = $('caRotateBtn');
    var labelsBtn = $('caLabelsBtn');
    var isolateBtn = $('caIsolateBtn');
    var hideBtn = $('caHideBtn');
    var resetBtn = $('caResetBtn');
    var screenshotBtn = $('caScreenshotBtn');
    var glbBtn = $('caGlbBtn');
    var orgOrb = $('caOrgOrb');
    var orgName = $('caOrgName');
    var orgSubtitle = $('caOrgSubtitle');
    var orgAttrs = $('caOrgAttrs');
    var orgNote = $('caOrgNote');
    var orgFact = $('caOrgFact');
    var favBtn = $('caFavBtn');
    var lessonEl = $('caLesson');
    var tutorOutput = $('caTutorOutput');
    var tutorMeta = $('caTutorMeta');
    var tutorBody = $('caTutorBody');
    var tutorForm = $('caTutorForm');
    var tutorInput = $('caTutorInput');
    var tutorSubmit = $('caTutorSubmit');
    var tutorClearBtn = $('caTutorClearBtn');
    var promptList = $('caPromptList');
    var occArt = $('caOccArt');
    var legendEl = $('caLegend');
    var occTitle = $('caOccTitle');
    var occBody = $('caOccBody');
    var microRow = $('caMicroRow');
    var compareRow = $('caCompareRow');
    var compareBtn = $('caCompareBtn');
    var modalLayer = $('caModalLayer');
    var modalTitle = $('caModalTitle');
    var modalSubtitle = $('caModalSubtitle');
    var modalColumns = $('caModalColumns');
    var modalClose = $('caModalClose');
    var toast = $('caToast');
    var lightbox = $('caLightbox');
    var lightboxImg = $('caLightboxImg');
    var lightboxCaption = $('caLightboxCaption');
    var lightboxSource = $('caLightboxSource');
    var lightboxClose = $('caLightboxClose');
    var lightboxPrev = $('caLightboxPrev');
    var lightboxNext = $('caLightboxNext');
    var grid = $('caGrid');
    var railHideBtn = $('caRailHideBtn');
    var railShowTab = $('caRailShowTab');
    var railHideBtnRight = $('caRailHideBtnRight');
    var railShowTabRight = $('caRailShowTabRight');
    var shareBtn = $('caShareBtn');
    var printBtn = $('caPrintBtn');
    var printView = $('caPrintView');
    var helpBtn = $('caHelpBtn');
    var helpOverlay = $('caHelpOverlay');
    var helpClose = $('caHelpClose');

    /* ===== Helpers ==================================================== */
    function showToast(message) {
        toast.textContent = message;
        toast.classList.add('is-visible');
        if (toastTimer) clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toast.classList.remove('is-visible'); }, 2600);
    }

    function selectedCell() { return getCellById(state.selectedCellId); }
    function activeOrganelle() {
        var cell = selectedCell();
        for (var i = 0; i < cell.organelles.length; i++) {
            if (cell.organelles[i].id === state.activeOrganelle) return cell.organelles[i];
        }
        return cell.organelles[0];
    }

    function buildTutorPrompts(cell, organelle) {
        var comparedName = getCellById(cell.comparison).name;
        return [
            'Explain how ' + organelle.name + ' helps a ' + cell.name + ' stay alive.',
            'Quiz me on the visual differences between ' + cell.name + ' and ' + comparedName + '.',
            'Guide me through finding ' + organelle.name + ' inside the 3D model.'
        ];
    }

    /* ===== Cell-type list (left rail) ================================ */
    function renderCellList() {
        var html = '';
        cells.forEach(function (cell) {
            var isActive = cell.id === state.selectedCellId;
            var isFav = state.favorites.has(cell.id);
            var thumb;
            if (cell.renderImage && cell.renderImage.url) {
                thumb = '<span class="ca-mini-cell has-preview" style="--thumb:' + cell.accent + '">' +
                            '<img src="' + cell.renderImage.url + '" alt="" aria-hidden="true">' +
                        '</span>';
            } else {
                thumb = '<span class="ca-mini-cell ca-mini-cell-' + cell.modelKind +
                        '" style="--thumb:' + cell.accent + '"><span></span><i></i><b></b></span>';
            }
            html += '<button type="button" class="ca-cell-row' + (isActive ? ' is-active' : '') +
                    '" data-cell-id="' + cell.id + '" role="option" aria-selected="' + isActive + '">' +
                    thumb +
                    '<span class="ca-cell-row-copy"><strong>' + cell.name + '</strong>' +
                    '<span>' + cell.type + '</span></span>' +
                    '<span class="ca-favorite-dot' + (isFav ? ' is-on' : '') +
                    '" data-fav-id="' + cell.id +
                    '" role="button" tabindex="0" aria-label="Favorite ' + cell.name + '">' +
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">' +
                    '<path d="M12 17.27l6.18 3.73-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>' +
                    '</svg></span></button>';
        });
        cellList.innerHTML = html;
    }

    /* ===== Organelle list ============================================ */
    function renderOrganelleList() {
        var cell = selectedCell();
        var html = '';
        cell.organelles.forEach(function (org, i) {
            var active = org.id === state.activeOrganelle;
            html += '<button type="button" class="ca-organelle-row' + (active ? ' is-active' : '') +
                    '" data-org-id="' + org.id + '" role="option" aria-selected="' + active + '">' +
                    '<span class="ca-color-dot" style="background:' + org.color + '"></span>' +
                    '<span>' + (i + 1) + '. ' + org.name + '</span></button>';
        });
        organelleList.innerHTML = html;
    }

    /* ===== Organelle legend (numbered pucks reference) ================
       Listed below the stage when Labels toggle is on. Numbers match the
       in-scene pucks (1-based, follows cell.organelles order). Clicking
       an entry activates the matching organelle the same way the side
       rail does. */
    function renderLegend() {
        if (!legendEl) return;
        var cell = selectedCell();
        var html = '';
        cell.organelles.forEach(function (org, i) {
            var active = org.id === state.activeOrganelle;
            html += '<button type="button" class="ca-legend-item' + (active ? ' is-active' : '') +
                    '" data-org-id="' + org.id + '" title="' + org.name + '">' +
                    '<span class="ca-legend-num" style="background:' + org.color + '">' + (i + 1) + '</span>' +
                    '<span class="ca-legend-name">' + org.name + '</span></button>';
        });
        legendEl.innerHTML = html;
        legendEl.hidden = !state.labelsVisible;
    }

    /* ===== Print handout =============================================
       Renders a textbook-style reference page from the selected cell's
       data — pre-rendered hero PNG + numbered organelle entries with
       attributes / notes / facts. The view is hidden onscreen via CSS;
       only @media print exposes it. This avoids the blank-WebGL-canvas
       problem (preserveDrawingBuffer:false clears the GL buffer before
       the print snapshot) and produces something a teacher can hand out. */
    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }
    function renderPrintView() {
        if (!printView) return;
        var cell = selectedCell();
        var html = '';

        html += '<header class="ca-print-header">' +
                '<h1>' + escapeHtml(cell.name) + '</h1>' +
                '<p>' + escapeHtml(cell.type) + '</p>' +
                '</header>';

        html += '<section class="ca-print-hero">';
        if (cell.renderImage && cell.renderImage.url) {
            html += '<img src="' + escapeHtml(cell.renderImage.url) + '" alt="' +
                    escapeHtml(cell.name) + ' render">';
        }
        if (cell.occurrence) {
            html += '<div class="ca-print-occurrence">' +
                    '<h3>' + escapeHtml(cell.occurrence.title || 'Where you find it') + '</h3>' +
                    '<p>' + escapeHtml(cell.occurrence.body || '') + '</p>' +
                    '</div>';
        }
        html += '</section>';

        html += '<section class="ca-print-organelles">' +
                '<h2>Organelle Reference</h2>';
        cell.organelles.forEach(function (org, i) {
            var attrsHtml = '';
            (org.attributes || []).forEach(function (a) {
                attrsHtml += '<div><dt>' + escapeHtml(a.label) +
                             '</dt><dd>' + escapeHtml(a.value) + '</dd></div>';
            });
            html += '<article class="ca-print-organelle">' +
                    '<header>' +
                      '<span class="ca-print-num" style="background:' + escapeHtml(org.color) + '">' +
                        (i + 1) +
                      '</span>' +
                      '<div>' +
                        '<h3>' + escapeHtml(org.name) + '</h3>' +
                        '<p>' + escapeHtml(org.subtitle || '') + '</p>' +
                      '</div>' +
                    '</header>';
            if (attrsHtml) html += '<dl class="ca-print-attrs">' + attrsHtml + '</dl>';
            if (org.note) html += '<p class="ca-print-note">' + escapeHtml(org.note) + '</p>';
            if (org.fact) html += '<p class="ca-print-fact"><strong>Did you know?</strong> ' +
                                  escapeHtml(org.fact) + '</p>';
            html += '</article>';
        });
        html += '</section>';

        html += '<footer class="ca-print-footer">';
        var compareId = cell.comparison;
        if (compareId) {
            var compareCell = getCellById(compareId);
            if (compareCell) {
                html += '<p>Compare with: <strong>' + escapeHtml(compareCell.name) +
                        '</strong></p>';
            }
        }
        html += '<p class="ca-print-source">8gwifi.org · Cell Atlas 3D</p>';
        html += '</footer>';

        printView.innerHTML = html;
    }

    /* ===== Stage title + view-mode controls ========================== */
    function renderStageTitle() {
        var cell = selectedCell();
        stageName.textContent = cell.name;
        stageType.textContent = cell.type;
        // Retint root via CSS vars so panels pick up per-cell accent.
        root.style.setProperty('--accent', cell.accent);
        root.style.setProperty('--accent-soft', cell.accentSoft);
        root.style.setProperty('--cell-color', cell.color);

        modeSwitcher.querySelectorAll('button').forEach(function (btn) {
            btn.classList.toggle('is-active', btn.getAttribute('data-mode') === state.viewMode);
        });
        crossSectionInput.checked = state.crossSection;
        rotateBtn.classList.toggle('is-active', state.autoRotate);
        // Mark canvas wrap when GLB is "native" so we get the saturation boost.
        var native = cell.modelAsset && cell.modelAsset.materialMode === 'native';
        canvasWrap.classList.toggle('is-native-asset', !!native);
    }

    /* ===== Right rail: organelle details ============================= */
    function renderDetails() {
        var cell = selectedCell();
        var org = activeOrganelle();
        orgOrb.style.background = org.color;
        orgName.textContent = org.name;
        orgSubtitle.textContent = org.subtitle;

        var attrsHtml = '';
        org.attributes.forEach(function (a) {
            attrsHtml += '<div><dt>' + a.label + '</dt><dd>' + a.value + '</dd></div>';
        });
        // Label row from the original "Organelle Details" panel.
        attrsHtml += '<div><dt>Label</dt><dd>' +
                     '<span class="ca-mini-toggle"></span>' +
                     '<span class="ca-detail-dot" style="background:' + org.color + '"></span></dd></div>';
        orgAttrs.innerHTML = attrsHtml;

        orgNote.textContent = org.note;
        orgFact.textContent = 'Fun Fact: ' + org.fact;

        favBtn.style.color = state.favorites.has(cell.id) ? cell.accent : '';
        favBtn.innerHTML = state.favorites.has(cell.id) ? '&#9829;' : '&#9825;';
    }

    /* ===== AI tutor =================================================== */
    function renderTutor() {
        var cell = selectedCell();
        var org = activeOrganelle();
        var compared = getCellById(cell.comparison);
        lessonEl.innerHTML = 'Locate <strong>' + org.name +
            '</strong>, explain its role, then compare it with the matching structure in ' +
            compared.name + '.';

        var prompts = buildTutorPrompts(cell, org);
        promptList.innerHTML = prompts.map(function (p) {
            return '<button type="button" data-prompt="' + p.replace(/"/g, '&quot;') + '">' + p + '</button>';
        }).join('');
    }

    /* ===== Occurrence ================================================ */
    function renderOccurrence() {
        var cell = selectedCell();
        occArt.className = 'ca-occurrence-art ca-occurrence-' + cell.occurrence.motif;
        occTitle.textContent = cell.occurrence.title;
        occBody.textContent = cell.occurrence.body;
    }

    /* ===== User-uploaded microscopy image (per cell) =================
       Stored in localStorage as JSON { dataUrl, filename } under a key
       prefixed with USER_IMG_KEY_PREFIX. Images are client-side resized
       to ≤1600px on the longest side and re-encoded as JPEG q≈0.85 so
       a 10 MB phone photo lands at ~300-600 KB before storage. */
    var USER_IMG_KEY_PREFIX = 'biology.ca.userImg.';
    var USER_IMG_MAX_INPUT_BYTES = 10 * 1024 * 1024;  // 10 MB original file cap
    var USER_IMG_RESIZE_PX = 1600;
    var USER_IMG_JPEG_QUALITY = 0.85;

    function getUserImageForCell(cellId) {
        var raw = storage.get(USER_IMG_KEY_PREFIX + cellId);
        if (!raw) return null;
        try { return JSON.parse(raw); } catch (e) { return null; }
    }
    function saveUserImageForCell(cellId, payload) {
        // Bypass the silent storage shim so we know if quota fails.
        try {
            localStorage.setItem(USER_IMG_KEY_PREFIX + cellId, JSON.stringify(payload));
            return true;
        } catch (e) {
            return false;
        }
    }
    function removeUserImageForCell(cellId) {
        storage.remove(USER_IMG_KEY_PREFIX + cellId);
    }

    /* Resize via <canvas> before persisting. JPEG output for size; the
       original microscopy aesthetics survive q=0.85 fine. Returns the
       new data URL via callback(err, dataUrl). */
    function resizeImageFile(file, callback) {
        var reader = new FileReader();
        reader.onload = function (e) {
            var img = new Image();
            img.onload = function () {
                var nW = img.naturalWidth, nH = img.naturalHeight;
                var ratio = Math.min(USER_IMG_RESIZE_PX / nW, USER_IMG_RESIZE_PX / nH, 1);
                var w = Math.max(1, Math.round(nW * ratio));
                var h = Math.max(1, Math.round(nH * ratio));
                var canvas = document.createElement('canvas');
                canvas.width = w; canvas.height = h;
                var ctx = canvas.getContext('2d');
                ctx.fillStyle = '#fff'; // flat background for any transparency
                ctx.fillRect(0, 0, w, h);
                ctx.drawImage(img, 0, 0, w, h);
                try {
                    callback(null, canvas.toDataURL('image/jpeg', USER_IMG_JPEG_QUALITY));
                } catch (err) { callback(err, null); }
            };
            img.onerror = function () { callback(new Error('Could not decode image'), null); };
            img.src = e.target.result;
        };
        reader.onerror = function () { callback(new Error('Could not read file'), null); };
        reader.readAsDataURL(file);
    }

    /* ===== Microscope card row =======================================
       Each curated entry from cells-data.js renders as a thumbnail card.
       The trailing card is either:
         - the user's uploaded image for this cell (if one is saved), with
           a small "×" to remove, or
         - the "+ Add Image" call-to-action that triggers the file picker. */
    function renderMicro() {
        var cell = selectedCell();
        var html = '';
        cell.microscope.forEach(function (m, idx) {
            var hasImg = m.image && m.image.url;
            var preview = hasImg
                ? '<img src="' + escapeHtml(wmThumb(m.image.url, 320)) + '" loading="lazy" decoding="async" ' +
                  'alt="' + escapeHtml(m.image.caption || m.label) + '">'
                : '<span></span>';
            html += '<button type="button" class="ca-micro-card pattern-' + m.pattern +
                    (hasImg ? ' has-image' : '') +
                    '" style="--micro:' + m.tone + '"' +
                    ' data-micro-idx="' + idx + '" data-micro-label="' + escapeHtml(m.label) + '"' +
                    (hasImg ? ' title="Click to enlarge"' : ' title="Image coming soon"') + '>' +
                    preview +
                    '<strong>' + escapeHtml(m.label) + '</strong></button>';
        });

        var userImg = getUserImageForCell(cell.id);
        if (userImg && userImg.dataUrl) {
            html += '<button type="button" class="ca-micro-card ca-micro-user has-image" ' +
                    'data-user-upload="1" title="Click to enlarge — your upload">' +
                    '<img src="' + escapeHtml(userImg.dataUrl) + '" alt="Your upload">' +
                    '<strong>Your upload</strong>' +
                    '<span class="ca-micro-remove" data-remove-upload="1" role="button" ' +
                    'aria-label="Remove your uploaded image" title="Remove">&times;</span>' +
                    '</button>';
        } else {
            html += '<button type="button" class="ca-micro-card ca-add-card" ' +
                    'data-add-image="1" title="Upload your own microscope photo">' +
                    '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>' +
                    '<strong>Add Image</strong></button>';
        }
        microRow.innerHTML = html;
    }

    /* ===== Lightbox state + helpers =================================
       Keeps a snapshot of the current cell's image-bearing microscope
       entries so prev/next navigation skips placeholder cards. */
    var lightboxItems = [];
    var lightboxIdx = 0;

    function openLightbox(cell, label, startAtUser) {
        lightboxItems = [];
        var startIdx = 0;
        (cell.microscope || []).forEach(function (m) {
            if (m.image && m.image.url) {
                if (m.label === label) startIdx = lightboxItems.length;
                lightboxItems.push(m);
            }
        });
        // Append the user's uploaded image (if any) as a virtual entry.
        var userImg = getUserImageForCell(cell.id);
        if (userImg && userImg.dataUrl) {
            lightboxItems.push({
                label: 'Your upload',
                image: {
                    url: userImg.dataUrl,
                    caption: userImg.filename || 'Your microscope image',
                    credit: 'Your upload',
                    source: ''
                }
            });
            if (startAtUser) startIdx = lightboxItems.length - 1;
        }
        if (lightboxItems.length === 0) return;
        lightboxIdx = startIdx;
        renderLightbox();
        lightbox.classList.add('is-open');
    }
    function renderLightbox() {
        var item = lightboxItems[lightboxIdx];
        if (!item || !item.image) return;
        lightboxImg.src = wmThumb(item.image.url, 1280);
        lightboxImg.alt = item.image.caption || item.label;
        lightboxCaption.textContent = item.image.caption || item.label;
        var credit = item.image.credit || '';
        var source = item.image.source || '';
        if (source) {
            lightboxSource.href = source;
            lightboxSource.textContent = credit
                ? credit + ' · Wikimedia Commons'
                : 'Wikimedia Commons';
        } else {
            // No source URL (e.g. user-uploaded image) — drop the href
            // entirely so the CSS strips the link styling and the credit
            // text still renders as plain text.
            lightboxSource.removeAttribute('href');
            lightboxSource.textContent = credit || '';
        }
        lightboxPrev.hidden = lightboxItems.length < 2;
        lightboxNext.hidden = lightboxItems.length < 2;
    }
    function closeLightbox() {
        lightbox.classList.remove('is-open');
        // Free the image so a slow connection isn't downloading a hidden file.
        setTimeout(function () { if (!lightbox.classList.contains('is-open')) lightboxImg.src = ''; }, 220);
    }
    function lightboxStep(delta) {
        if (lightboxItems.length < 2) return;
        lightboxIdx = (lightboxIdx + delta + lightboxItems.length) % lightboxItems.length;
        renderLightbox();
    }

    /* ===== Compare bar =============================================== */
    function renderCompare() {
        var cell = selectedCell();
        var compared = getCellById(cell.comparison);
        function mini(c) {
            if (c.renderImage && c.renderImage.url) {
                return '<span class="ca-mini-cell has-preview" style="--thumb:' + c.accent +
                       '"><img src="' + c.renderImage.url + '" alt="" aria-hidden="true"></span>';
            }
            return '<span class="ca-mini-cell ca-mini-cell-' + c.modelKind +
                   '" style="--thumb:' + c.accent + '"><span></span><i></i><b></b></span>';
        }
        compareRow.innerHTML =
            '<div>' + mini(cell) +
                '<span><strong>' + cell.name + '</strong><em>You are here</em></span>' +
            '</div>' +
            '<b>VS</b>' +
            '<div><span><strong>' + compared.name + '</strong>' +
                '<em>' + compared.type + '</em></span>' + mini(compared) + '</div>';
    }

    /* Sync-rotating compare modal — two mini 3D scenes side-by-side.
       Each gets its own BiologyCellScene controller. Both auto-rotate at
       the same rate (delta*0.1 in the animation loop), so they stay
       roughly synchronised; manual rotation desyncs by design. The mini
       scenes are mounted after the modal becomes visible (one rAF later)
       so the canvases have a non-zero bounding rect for the renderer's
       initial setSize. Disposed in closeCompareModal. */
    var compareControllers = [];
    var COMPARE_LEFT_CANVAS_ID  = 'caCompareLeftCanvas';
    var COMPARE_RIGHT_CANVAS_ID = 'caCompareRightCanvas';

    function buildCompareColumn(item, canvasId, isCurrent) {
        var defOrg = null;
        for (var i = 0; i < item.organelles.length; i++) {
            if (item.organelles[i].id === item.defaultOrganelle) { defOrg = item.organelles[i]; break; }
        }
        if (!defOrg) defOrg = item.organelles[0];

        var switchBtn = isCurrent
            ? '<span class="ca-compare-here">You are here</span>'
            : '<button type="button" class="ca-compare-switch" data-switch-cell="' +
              escapeHtml(item.id) + '">Switch to this cell &rarr;</button>';

        return '<section class="ca-compare-section">' +
               '<div class="ca-compare-canvas-wrap"><canvas id="' + canvasId +
               '" aria-label="3D ' + escapeHtml(item.name) + '"></canvas></div>' +
               '<h4>' + escapeHtml(item.name) + '</h4>' +
               '<p>' + escapeHtml(item.type) + '</p>' +
               '<dl>' +
                   '<div><dt>Default focus</dt><dd>' + escapeHtml(defOrg.name) + '</dd></div>' +
                   '<div><dt>Main note</dt><dd>' + escapeHtml(defOrg.subtitle) + '</dd></div>' +
                   '<div><dt>Occurs in</dt><dd>' + escapeHtml(item.occurrence.title) + '</dd></div>' +
               '</dl>' +
               switchBtn +
               '</section>';
    }

    function mountCompareScenes(leftCell, rightCell) {
        disposeCompareScenes();
        if (!window.BiologyCellScene) return; // scene module not loaded yet
        var leftCanvas  = document.getElementById(COMPARE_LEFT_CANVAS_ID);
        var rightCanvas = document.getElementById(COMPARE_RIGHT_CANVAS_ID);
        if (!leftCanvas || !rightCanvas) return;

        var leftCtrl  = window.BiologyCellScene.mount(leftCanvas,  {});
        var rightCtrl = window.BiologyCellScene.mount(rightCanvas, {});
        compareControllers = [leftCtrl, rightCtrl];

        var baseProps = {
            viewMode: 'mesh',
            crossSection: false,
            clipY: 0,
            autoRotate: true
        };
        leftCtrl.update(Object.assign({}, baseProps,
            { cell: leftCell,  activeOrganelle: leftCell.defaultOrganelle  }));
        rightCtrl.update(Object.assign({}, baseProps,
            { cell: rightCell, activeOrganelle: rightCell.defaultOrganelle }));
    }

    function disposeCompareScenes() {
        for (var i = 0; i < compareControllers.length; i++) {
            try { compareControllers[i].dispose(); } catch (e) {}
        }
        compareControllers = [];
    }

    function renderModal() {
        var cell = selectedCell();
        var compared = getCellById(cell.comparison);
        modalSubtitle.textContent = cell.name + ' compared with ' + compared.name;
        modalColumns.innerHTML =
            buildCompareColumn(cell,     COMPARE_LEFT_CANVAS_ID,  true)  +
            buildCompareColumn(compared, COMPARE_RIGHT_CANVAS_ID, false);
    }

    function openCompareModal() {
        renderModal();
        modalLayer.classList.add('is-open');
        // Wait one frame so the canvases pick up non-zero dimensions
        // before BiologyCellScene reads them in setSize().
        requestAnimationFrame(function () {
            mountCompareScenes(selectedCell(), getCellById(selectedCell().comparison));
        });
    }

    function closeCompareModal() {
        modalLayer.classList.remove('is-open');
        // Defer disposal so the close animation can finish before the
        // canvas elements get unmounted. The 280ms matches the scale-in.
        setTimeout(disposeCompareScenes, 300);
    }

    /* ===== Re-render all UI ========================================== */
    function rerenderAll() {
        renderStageTitle();
        renderCellList();
        renderOrganelleList();
        renderLegend();
        renderDetails();
        renderTutor();
        renderOccurrence();
        renderMicro();
        renderCompare();
        renderPrintView();
    }

    /* ===== Scene wiring ============================================== */
    function pushSceneState() {
        if (!sceneController) return;
        sceneController.update({
            cell: selectedCell(),
            activeOrganelle: state.activeOrganelle,
            viewMode: state.viewMode,
            crossSection: state.crossSection,
            clipY: state.clipY,
            autoRotate: state.autoRotate,
            labelsVisible: state.labelsVisible
        });
    }

    function syncClipSliderVisibility() {
        if (!clipSliderWrap) return;
        clipSliderWrap.hidden = !state.crossSection;
    }

    function onProgress(evt) {
        if (evt.phase === 'loading') {
            loader.classList.remove('is-hidden');
            loaderName.textContent = evt.cell.name;
            loaderBar.style.width = (evt.progress || 8) + '%';
            loaderPct.textContent = (evt.progress || 8) + '%';
        } else if (evt.phase === 'loaded') {
            loader.classList.add('is-hidden');
        } else if (evt.phase === 'error') {
            loader.classList.add('is-hidden');
            showToast('Using procedural fallback for ' + evt.cell.name);
        }
    }

    /* ===== Boot ====================================================== */
    function boot() {
        // Restore any state encoded in the URL before first render so
        // the scene boots straight into the shared view.
        var fromUrl = decodeStateFromUrl();
        if (fromUrl) Object.assign(state, fromUrl);
        // Sync the cross-section checkbox + slider widgets to restored state.
        crossSectionInput.checked = state.crossSection;
        if (clipSlider) clipSlider.value = String(state.clipY);
        syncClipSliderVisibility();
        if (labelsBtn) labelsBtn.classList.toggle('is-active', state.labelsVisible);
        if (rotateBtn) rotateBtn.classList.toggle('is-active', state.autoRotate);

        sceneController = window.BiologyCellScene.mount(canvas, {
            onProgress: onProgress,
            onPick: function (organelleId) {
                // Surface the AI Tutor every click — the Reddit feedback was
                // that users miss the right-rail context when picking parts.
                // Reveal even if the same organelle is re-clicked, so users
                // can jump back to the tutor view anytime.
                revealTutorPanel();
                // Auto-pause rotation on pick. The user is now reading about
                // an organelle; a spinning cell makes labels hard to track
                // and pushes the pick out of view. User can manually re-enable
                // rotation via the Rotate button or `R` key.
                if (state.autoRotate) {
                    state.autoRotate = false;
                    rotateBtn.classList.remove('is-active');
                }
                if (organelleId === state.activeOrganelle) return;
                state.activeOrganelle = organelleId;
                renderOrganelleList();
                renderLegend();
                renderDetails();
                renderTutor();
                pushSceneState();
                updateUrlState();
            }
        });
        rerenderAll();
        pushSceneState();
    }
    // cell-scene.js is an ES module; wait for it.
    function waitForScene() {
        if (window.BiologyCellScene) { boot(); return; }
        setTimeout(waitForScene, 30);
    }
    waitForScene();

    /* ===== Event handlers ============================================ */
    cellList.addEventListener('click', function (e) {
        var favEl = e.target.closest('[data-fav-id]');
        if (favEl) {
            e.preventDefault();
            e.stopPropagation();
            var id = favEl.getAttribute('data-fav-id');
            if (state.favorites.has(id)) state.favorites.delete(id);
            else state.favorites.add(id);
            renderCellList();
            renderDetails();
            return;
        }
        var row = e.target.closest('[data-cell-id]');
        if (!row) return;
        var id = row.getAttribute('data-cell-id');
        if (id === state.selectedCellId) return;
        state.selectedCellId = id;
        state.activeOrganelle = selectedCell().defaultOrganelle;
        // Reference App.tsx:625-628 closes the comparison modal in a
        // useEffect on selectedCell — mirror that here. Also drop any
        // AI conversation since the "current view" context changed.
        closeCompareModal();
        aiConversation = [];
        syncTutorClearBtn();
        rerenderAll();
        pushSceneState();
    });

    organelleList.addEventListener('click', function (e) {
        var row = e.target.closest('[data-org-id]');
        if (!row) return;
        var orgId = row.getAttribute('data-org-id');
        if (orgId === state.activeOrganelle) return;
        state.activeOrganelle = orgId;
        renderOrganelleList();
        renderLegend();
        renderDetails();
        renderTutor();
        pushSceneState();
    });

    /* Legend click — same activation flow as the side rail. Reveals the
       tutor too so clicking a number jumps straight to the explanation. */
    if (legendEl) {
        legendEl.addEventListener('click', function (e) {
            var item = e.target.closest('[data-org-id]');
            if (!item) return;
            var orgId = item.getAttribute('data-org-id');
            revealTutorPanel();
            if (orgId === state.activeOrganelle) return;
            state.activeOrganelle = orgId;
            renderOrganelleList();
            renderLegend();
            renderDetails();
            renderTutor();
            pushSceneState();
            updateUrlState();
        });
    }

    modeSwitcher.addEventListener('click', function (e) {
        var btn = e.target.closest('button[data-mode]');
        if (!btn) return;
        state.viewMode = btn.getAttribute('data-mode');
        renderStageTitle();
        pushSceneState();
    });

    crossSectionInput.addEventListener('change', function () {
        state.crossSection = crossSectionInput.checked;
        syncClipSliderVisibility();
        pushSceneState();
    });

    if (clipSlider) {
        clipSlider.addEventListener('input', function () {
            state.clipY = parseFloat(clipSlider.value) || 0;
            pushSceneState();
            updateUrlState();
        });
    }

    rotateBtn.addEventListener('click', function () {
        state.autoRotate = !state.autoRotate;
        rotateBtn.classList.toggle('is-active', state.autoRotate);
        pushSceneState();
    });

    /* Labels — toggle the in-scene numbered pucks AND the side legend. */
    function setLabelsVisible(on) {
        state.labelsVisible = !!on;
        labelsBtn.classList.toggle('is-active', state.labelsVisible);
        if (legendEl) legendEl.hidden = !state.labelsVisible;
        pushSceneState();
    }
    labelsBtn.addEventListener('click', function () {
        setLabelsVisible(!state.labelsVisible);
        updateUrlState();
    });

    // Isolate = enter focus mode without touching cross-section.
    isolateBtn.addEventListener('click', function () {
        state.viewMode = 'focus';
        renderStageTitle();
        pushSceneState();
    });

    // Hide Others = true hide mode. Non-active organelles drop to
    // node.visible=false in the scene controller — they vanish, no longer
    // raycast targets. Different from Isolate, which only dims them to 18%.
    // Cross-section is no longer forced (was a workaround for translucent
    // walls obscuring the view; with others truly hidden, the active
    // organelle stands alone with nothing in front of it).
    hideBtn.addEventListener('click', function () {
        state.viewMode = 'hide';
        renderStageTitle();
        pushSceneState();
    });

    // Reset = camera reset + return view to mesh mode + drop cross-section.
    resetBtn.addEventListener('click', function () {
        state.viewMode = 'mesh';
        state.crossSection = false;
        state.clipY = 0;
        crossSectionInput.checked = false;
        if (clipSlider) clipSlider.value = '0';
        syncClipSliderVisibility();
        if (sceneController) sceneController.reset();
        renderStageTitle();
        pushSceneState();
        showToast('View reset.');
    });

    // Screenshot — use the controller's screenshot() which forces a render
    // before reading the canvas (default preserveDrawingBuffer=false would
    // otherwise return a blank image).
    screenshotBtn.addEventListener('click', function () {
        try {
            if (!sceneController || !sceneController.screenshot) {
                showToast('Screenshot not ready yet.');
                return;
            }
            var url = sceneController.screenshot('image/png');
            var a = document.createElement('a');
            a.href = url;
            a.download = selectedCell().id + '-cell.png';
            document.body.appendChild(a); a.click(); a.remove();
            showToast('Screenshot saved.');
        } catch (err) {
            showToast('Screenshot failed: ' + err.message);
        }
    });

    glbBtn.addEventListener('click', function () {
        showToast('GLB export is on the roadmap.');
    });

    favBtn.addEventListener('click', function () {
        var id = state.selectedCellId;
        if (state.favorites.has(id)) state.favorites.delete(id);
        else state.favorites.add(id);
        renderCellList();
        renderDetails();
    });

    /* ===== AI tutor — streams from AIProxyServlet ====================
       POST /ai with stream:true. The servlet pipes Ollama's NDJSON
       chunks straight through; we parse each line and append the
       content delta to the tutor body in real time.
       Per project convention, we don't pass a `model` field — the
       server picks the default.
       =============================================================== */
    var AI_URL = '<%=request.getContextPath()%>/ai';
    /* Long timeout: cold model loads + queue waits can take a few min. */
    var AI_TIMEOUT_MS = 360000; // 6 min
    var aiAbort = null;
    var aiBusy = false;

    /* Multi-turn conversation: keep the last MAX_HISTORY messages (3 user
       + 3 assistant) and resend them with each request so follow-ups have
       context. History resets when the user switches cells (the system
       prompt's "current view" changes too much to keep prior turns
       relevant). Pre-flight, we push the user message; on success we
       push the assistant reply; on error we pop the orphan user message
       so retries don't double-send. */
    var aiConversation = [];
    var MAX_HISTORY = 6;

    function setTutorState(s, meta) {
        tutorOutput.setAttribute('data-state', s);
        if (meta != null) tutorMeta.textContent = meta;
    }

    /* Delegate to ToolUtils.escapeHtml when available — same implementation,
       keeps site-wide consistency. Falls back to a local copy so the tool
       still works if tool-utils.js fails to load. */
    var escapeHtml = (window.ToolUtils && ToolUtils.escapeHtml) || function (s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    };

    /* Rewrite a Wikimedia Commons full-resolution URL into a thumbnail URL
       so card previews don't ship multi-megabyte originals. Pattern:
         /commons/x/yz/FILE.ext → /commons/thumb/x/yz/FILE.ext/{W}px-FILE.ext
       Non-Commons URLs and already-thumbed URLs pass through unchanged. */
    function wmThumb(url, width) {
        if (!url) return url;
        var marker = '/commons/';
        var i = url.indexOf(marker);
        if (i < 0) return url;
        if (url.indexOf('/commons/thumb/') >= 0) return url;
        var path = url.substring(i + marker.length); // "x/yz/FILE.ext"
        var slash = path.lastIndexOf('/');
        if (slash < 0) return url;
        var filename = path.substring(slash + 1);
        return url.substring(0, i + marker.length) + 'thumb/' + path +
               '/' + width + 'px-' + filename;
    }

    function showTutorLoading(message) {
        tutorBody.innerHTML =
            '<div class="ca-tutor-loading">' +
                '<span class="ca-tutor-spinner" role="status" aria-label="Loading"></span>' +
                '<span>' + escapeHtml(message) + '</span>' +
            '</div>';
    }

    function showTutorPlaceholder(text) {
        tutorBody.innerHTML = '<p class="ca-tutor-placeholder">' + escapeHtml(text) + '</p>';
    }

    function renderTutorBody(text) {
        var paragraphs = String(text || '').split(/\n\s*\n/);
        tutorBody.innerHTML = paragraphs.map(function (p) {
            return '<p>' + escapeHtml(p) + '</p>';
        }).join('');
        // Auto-scroll to bottom so the freshest tokens stay visible.
        tutorBody.scrollTop = tutorBody.scrollHeight;
    }

    function buildSystemPrompt() {
        var cell = selectedCell();
        var org = activeOrganelle();
        var compared = getCellById(cell.comparison);
        return 'You are a biology tutor helping a student explore a 3D cell viewer. ' +
               'Stay grounded in cell biology and adapt to a middle-school-to-undergraduate ' +
               'level depending on the question.\n\n' +
               'CURRENT VIEW:\n' +
               '- Cell: ' + cell.name + ' (' + cell.type + ')\n' +
               '- Highlighted organelle: ' + org.name + ' — ' + org.subtitle + '\n' +
               '- Companion cell for comparison: ' + compared.name + '\n\n' +
               'FORMATTING:\n' +
               '- Plain text only (no markdown, no #, no **, no bullets).\n' +
               '- Keep responses to 2-4 short paragraphs.\n' +
               '- Separate paragraphs with a blank line.\n' +
               '- Never repeat the question back. Answer directly.';
    }

    /* Pump the chunked NDJSON stream. Returns a promise that resolves
       to the full accumulated text once the upstream signals done. */
    function pumpStream(resp) {
        var reader = resp.body.getReader();
        var decoder = new TextDecoder('utf-8');
        var buffer = '';     // leftover bytes between reads (line may straddle chunks)
        var accumulated = '';
        var sawFirstToken = false;

        function step() {
            return reader.read().then(function (result) {
                if (result.done) return accumulated;
                buffer += decoder.decode(result.value, { stream: true });
                // Split on newlines, keep the last (possibly incomplete) line buffered.
                var lines = buffer.split('\n');
                buffer = lines.pop();
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (!line) continue;
                    var chunk;
                    try { chunk = JSON.parse(line); }
                    catch (e) {
                        // Partial / malformed line — skip; the rest of the
                        // stream is still parseable.
                        continue;
                    }
                    if (chunk.error) {
                        throw new Error(chunk.error);
                    }
                    var delta = (chunk.message && chunk.message.content) ||
                                (typeof chunk.response === 'string' ? chunk.response : '');
                    if (delta) {
                        if (!sawFirstToken) {
                            sawFirstToken = true;
                            setTutorState('streaming', 'Replying');
                        }
                        accumulated += delta;
                        renderTutorBody(accumulated);
                    }
                    if (chunk.done === true) {
                        // Drain the rest just in case more JSON lines follow,
                        // but we can stop pumping.
                        return accumulated;
                    }
                }
                return step();
            });
        }
        return step();
    }

    function syncTutorClearBtn() {
        if (!tutorClearBtn) return;
        tutorClearBtn.hidden = aiConversation.length === 0;
    }

    function askTutor(userPrompt) {
        if (aiBusy) { showToast('Tutor is still replying…'); return; }
        if (!userPrompt || !userPrompt.trim()) return;
        aiBusy = true;
        tutorSubmit.disabled = true;

        setTutorState('loading', 'Connecting…');
        showTutorLoading('Usually takes 2-3 min for a response…');

        if (aiAbort) aiAbort.abort();
        aiAbort = (typeof AbortController !== 'undefined') ? new AbortController() : null;
        var timeoutId = setTimeout(function () {
            if (aiAbort) aiAbort.abort();
        }, AI_TIMEOUT_MS);

        // Append the new question to history; rebuild the system prompt
        // fresh each call so the "current view" reflects any cell/organelle
        // changes made between turns.
        aiConversation.push({ role: 'user', content: userPrompt });
        var messages = [{ role: 'system', content: buildSystemPrompt() }].concat(aiConversation);

        var body = JSON.stringify({
            stream: true,
            messages: messages
        });

        fetch(AI_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: body,
            signal: aiAbort ? aiAbort.signal : undefined
        }).then(function (resp) {
            if (resp.status === 429) {
                var wait = resp.headers.get('Retry-After') || '60';
                throw new Error('Rate limit reached — try again in ' + wait + 's.');
            }
            if (!resp.ok) {
                // Some error responses are JSON {error:...}; read them.
                return resp.text().then(function (txt) {
                    var data; try { data = JSON.parse(txt); } catch (e) { data = null; }
                    throw new Error((data && (data.error || data.message)) || ('HTTP ' + resp.status));
                });
            }
            if (!resp.body || !resp.body.getReader) {
                // Older browsers: fall back to a single-shot text read.
                return resp.text().then(function (txt) {
                    // Could be either NDJSON or a single JSON object —
                    // try to extract the assistant content from either.
                    var joined = '';
                    txt.split('\n').forEach(function (line) {
                        line = line.trim(); if (!line) return;
                        try {
                            var c = JSON.parse(line);
                            joined += (c.message && c.message.content) ||
                                      (typeof c.response === 'string' ? c.response : '');
                        } catch (e) {}
                    });
                    if (!joined) {
                        try {
                            var single = JSON.parse(txt);
                            joined = (single.message && single.message.content) || single.response || '';
                        } catch (e) {}
                    }
                    if (!joined) throw new Error('Empty reply.');
                    setTutorState('streaming', 'Replying');
                    renderTutorBody(joined);
                    return joined;
                });
            }
            return pumpStream(resp);
        }).then(function (fullText) {
            clearTimeout(timeoutId);
            if (!fullText || !String(fullText).trim()) throw new Error('Empty reply.');
            // Commit the assistant turn to history and prune oldest pairs
            // until we're within MAX_HISTORY.
            aiConversation.push({ role: 'assistant', content: String(fullText) });
            while (aiConversation.length > MAX_HISTORY) aiConversation.shift();
            var turns = Math.floor(aiConversation.length / 2);
            var stamp = new Date().toLocaleTimeString();
            setTutorState('idle', 'Replied · ' + stamp +
                          (turns > 1 ? ' · ' + turns + ' turn' + (turns > 1 ? 's' : '') : ''));
            syncTutorClearBtn();
        }).catch(function (err) {
            clearTimeout(timeoutId);
            // Pop the user message we just queued so retry doesn't double-send.
            if (aiConversation.length > 0 &&
                aiConversation[aiConversation.length - 1].role === 'user') {
                aiConversation.pop();
            }
            var msg = (err && err.name === 'AbortError')
                ? 'Request cancelled or timed out.'
                : (err && err.message) ? err.message : 'Request failed.';
            showTutorPlaceholder(msg);
            setTutorState('error', 'Failed');
            syncTutorClearBtn();
        }).finally(function () {
            aiBusy = false;
            tutorSubmit.disabled = false;
        });
    }

    if (tutorClearBtn) {
        tutorClearBtn.addEventListener('click', function () {
            aiConversation = [];
            showTutorPlaceholder('Conversation cleared.');
            setTutorState('idle', 'Pick a prompt below or type a question.');
            syncTutorClearBtn();
        });
    }

    promptList.addEventListener('click', function (e) {
        var btn = e.target.closest('button[data-prompt]');
        if (!btn) return;
        var prompt = btn.getAttribute('data-prompt');
        if (tutorInput) tutorInput.value = prompt;
        askTutor(prompt);
    });

    tutorForm.addEventListener('submit', function (e) {
        e.preventDefault();
        var q = (tutorInput.value || '').trim();
        if (!q) return;
        askTutor(q);
    });

    var addImageInput = $('caAddImageInput');

    microRow.addEventListener('click', function (e) {
        // The "×" is nested inside the user-upload card — check it first
        // so its click doesn't bubble up and trigger a lightbox open.
        var removeBtn = e.target.closest('[data-remove-upload]');
        if (removeBtn) {
            e.preventDefault();
            e.stopPropagation();
            var cellId = selectedCell().id;
            if (typeof confirm === 'function' &&
                !confirm('Remove your uploaded image for ' + selectedCell().name + '?')) return;
            removeUserImageForCell(cellId);
            renderMicro();
            showToast('Upload removed.');
            return;
        }
        // User-uploaded image card — open straight into the lightbox at it.
        if (e.target.closest('[data-user-upload]')) {
            openLightbox(selectedCell(), null, true);
            return;
        }
        // Curated microscopy card.
        var btn = e.target.closest('button[data-micro-idx]');
        if (btn) {
            var cell = selectedCell();
            var idx = parseInt(btn.getAttribute('data-micro-idx'), 10);
            var m = cell.microscope[idx];
            if (m && m.image && m.image.url) {
                openLightbox(cell, m.label);
            } else {
                showToast((m && m.label ? m.label : 'Microscopy') + ' image not yet available.');
            }
            return;
        }
        // Add-image card — trigger the hidden file picker.
        if (e.target.closest('[data-add-image]')) {
            if (addImageInput) addImageInput.click();
        }
    });

    /* Hidden file input — change event runs the upload pipeline. */
    if (addImageInput) {
        addImageInput.addEventListener('change', function () {
            var file = addImageInput.files && addImageInput.files[0];
            // Reset the input so picking the same file again still fires
            // 'change' (browsers debounce identical selections otherwise).
            addImageInput.value = '';
            if (!file) return;
            if (!file.type || file.type.indexOf('image/') !== 0) {
                showToast('Please choose an image file.');
                return;
            }
            if (file.size > USER_IMG_MAX_INPUT_BYTES) {
                showToast('Image too large (max 10 MB).');
                return;
            }
            showToast('Processing image…');
            resizeImageFile(file, function (err, dataUrl) {
                if (err || !dataUrl) {
                    showToast('Could not process image: ' + (err && err.message ? err.message : 'unknown error'));
                    return;
                }
                var cellId = selectedCell().id;
                var ok = saveUserImageForCell(cellId, {
                    dataUrl:  dataUrl,
                    filename: file.name || 'upload.jpg',
                    when:     Date.now()
                });
                if (!ok) {
                    showToast('Browser storage is full — could not save the image.');
                    return;
                }
                renderMicro();
                openLightbox(selectedCell(), null, true);
                showToast('Saved upload for ' + selectedCell().name + '.');
            });
        });
    }

    /* Lightbox controls */
    if (lightboxClose) lightboxClose.addEventListener('click', closeLightbox);
    if (lightboxPrev)  lightboxPrev.addEventListener('click',  function () { lightboxStep(-1); });
    if (lightboxNext)  lightboxNext.addEventListener('click',  function () { lightboxStep( 1); });
    if (lightbox)      lightbox.addEventListener('click', function (e) {
        if (e.target === lightbox) closeLightbox();
    });

    compareBtn.addEventListener('click', openCompareModal);
    modalClose.addEventListener('click', closeCompareModal);
    modalLayer.addEventListener('click', function (e) {
        if (e.target === modalLayer) closeCompareModal();
    });
    // "Switch to this cell" inside the comparison modal — picks the
    // right-side cell and dives in.
    modalColumns.addEventListener('click', function (e) {
        var btn = e.target.closest && e.target.closest('[data-switch-cell]');
        if (!btn) return;
        var id = btn.getAttribute('data-switch-cell');
        closeCompareModal();
        selectCellById(id);
    });

    /* ===== Rail collapse (left + right) =============================
       Persisted in localStorage so each side's choice survives reloads.
       The canvas is sized via ResizeObserver in cell-scene.js, so the
       column-width change is picked up automatically — no manual
       renderer.setSize call needed. */
    var LEFT_HIDDEN_KEY  = 'biology.ca.leftHidden';
    var RIGHT_HIDDEN_KEY = 'biology.ca.rightHidden';

    /* Tiny storage shim — uses ToolUtils.Storage when present (centralised
       prefixing + try/catch), falls back to raw localStorage. */
    var storage = (window.ToolUtils && ToolUtils.Storage) ? {
        get:    function (k)    { return ToolUtils.Storage.get(k); },
        save:   function (k, v) { ToolUtils.Storage.save(k, v); },
        remove: function (k)    { ToolUtils.Storage.remove(k); }
    } : {
        get:    function (k)    { try { return localStorage.getItem(k); }    catch (e) { return null; } },
        save:   function (k, v) { try { localStorage.setItem(k, v); }        catch (e) {} },
        remove: function (k)    { try { localStorage.removeItem(k); }        catch (e) {} }
    };

    function applyRailHidden(side, hidden) {
        var cls = side === 'right' ? 'is-right-hidden' : 'is-left-hidden';
        grid.classList.toggle(cls, !!hidden);
        var btn = side === 'right' ? railHideBtnRight : railHideBtn;
        if (btn) {
            var hideLabel = side === 'right'
                ? 'Hide tutor panel to widen the stage'
                : 'Hide cell list to widen the stage';
            var showLabel = side === 'right' ? 'Show tutor panel' : 'Show cell list';
            btn.setAttribute('aria-label', hidden ? showLabel : hideLabel);
        }
    }

    if (storage.get(LEFT_HIDDEN_KEY)  === '1') applyRailHidden('left',  true);
    // Right rail (AI tutor + organelle details) is HIDDEN BY DEFAULT —
    // maximises stage real-estate on first load. Only show when the
    // user explicitly opened it via the show-tab (stored as '0').
    if (storage.get(RIGHT_HIDDEN_KEY) !== '0') applyRailHidden('right', true);

    function toggleRail(side, hide) {
        applyRailHidden(side, hide);
        storage.save(side === 'right' ? RIGHT_HIDDEN_KEY : LEFT_HIDDEN_KEY, hide ? '1' : '0');
    }

    if (railHideBtn)      railHideBtn.addEventListener('click',      function () { toggleRail('left',  true);  });
    if (railShowTab)      railShowTab.addEventListener('click',      function () { toggleRail('left',  false); });
    if (railHideBtnRight) railHideBtnRight.addEventListener('click', function () { toggleRail('right', true);  });
    if (railShowTabRight) railShowTabRight.addEventListener('click', function () { toggleRail('right', false); });

    /* revealTutorPanel — fired from the 3D scene's onPick. Expands the
       right rail if it's been collapsed; only scrolls on layouts where
       the rail is stacked under the stage (mobile / narrow viewports).
       On desktop the rail sits side-by-side with the stage, so scrolling
       would push the 3D viewer out of view — bad UX when the user is
       picking organelles back-to-back. */
    function revealTutorPanel() {
        var wasHidden = grid.classList.contains('is-right-hidden');
        if (wasHidden) toggleRail('right', false);

        // 1100px matches the grid breakpoint where the layout flips from
        // single-column (stage on top, rails stacked below) to 3-column
        // (rails flanking the stage). Below this, scrolling helps; above
        // it, scrolling hurts — just expanding the rail is enough.
        if (window.innerWidth >= 1100) return;

        var panel = document.getElementById('caTutorPanel');
        if (!panel) return;
        var run = function () {
            try { panel.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
            catch (e) { panel.scrollIntoView(); }
        };
        if (wasHidden) requestAnimationFrame(function () { requestAnimationFrame(run); });
        else run();
    }

    /* ===== URL state ================================================
       Encodes the minimum needed to reproduce a view. `history.replaceState`
       keeps the bar in sync without polluting the back-button history. */
    function encodeStateParams() {
        var p = {
            c: state.selectedCellId,
            o: state.activeOrganelle,
            m: state.viewMode === 'focus' ? 'f' : (state.viewMode === 'hide' ? 'h' : 'm'),
            x: state.crossSection ? '1' : '0',
            r: state.autoRotate ? '1' : '0',
            l: state.labelsVisible ? '1' : '0'
        };
        // Only include slice depth when it's non-default + cross-section is on —
        // keeps unsliced URLs short.
        if (state.crossSection && Math.abs(state.clipY) > 0.001) {
            p.y = state.clipY.toFixed(2);
        }
        return p;
    }
    function decodeStateFromUrl() {
        var params = new URLSearchParams(window.location.search);
        if (!params.has('c')) return null;
        var cellId = params.get('c');
        var hit = null;
        for (var i = 0; i < cells.length; i++) if (cells[i].id === cellId) { hit = cells[i]; break; }
        if (!hit) return null;
        var orgId = params.get('o');
        var orgOk = false;
        if (orgId) for (var j = 0; j < hit.organelles.length; j++) {
            if (hit.organelles[j].id === orgId) { orgOk = true; break; }
        }
        var clipY = parseFloat(params.get('y'));
        if (isNaN(clipY)) clipY = 0;
        clipY = Math.max(-1.5, Math.min(1.5, clipY));
        return {
            selectedCellId: cellId,
            activeOrganelle: orgOk ? orgId : hit.defaultOrganelle,
            viewMode: (function () {
                var m = params.get('m');
                if (m === 'f') return 'focus';
                if (m === 'h') return 'hide';
                return 'mesh';
            })(),
            crossSection: params.get('x') === '1',
            clipY: clipY,
            autoRotate: params.get('r') !== '0',
            labelsVisible: params.get('l') === '1'
        };
    }
    function buildShareUrl() {
        // ToolUtils.generateShareUrl returns origin+pathname+'?'+params.
        // Pass {showSupportPopup:false} — that popup is a crypto-tool
        // monetisation flow that would feel off on a biology viewer.
        if (window.ToolUtils && ToolUtils.generateShareUrl) {
            return ToolUtils.generateShareUrl(encodeStateParams(), { showSupportPopup: false });
        }
        var p = new URLSearchParams();
        var params = encodeStateParams();
        for (var k in params) if (Object.prototype.hasOwnProperty.call(params, k)) {
            p.append(k, params[k]);
        }
        return window.location.origin + window.location.pathname + '?' + p.toString();
    }
    function updateUrlState() {
        try {
            history.replaceState(null, '', buildShareUrl());
        } catch (e) { /* IE / pushState restrictions */ }
    }

    /* ===== Share button — copies the URL via ToolUtils =============== */
    if (shareBtn) {
        shareBtn.addEventListener('click', function () {
            var url = buildShareUrl();
            updateUrlState();
            if (window.ToolUtils && ToolUtils.copyToClipboard) {
                ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied.' });
            } else {
                showToast('Share link: ' + url);
            }
        });
    }

    /* ===== Print button — populate the data-driven handout view, then
       invoke the browser's print flow. The print stylesheet hides the
       live UI and shows #caPrintView; window.print() snapshots that. */
    if (printBtn) {
        printBtn.addEventListener('click', function () {
            renderPrintView();
            // Defer one frame so the print-view DOM is laid out before
            // the browser snapshots it for the print preview.
            requestAnimationFrame(function () { window.print(); });
        });
    }

    /* ===== Help overlay ============================================= */
    function openHelp() { helpOverlay.classList.add('is-open'); }
    function closeHelp() { helpOverlay.classList.remove('is-open'); }
    if (helpBtn)   helpBtn.addEventListener('click', openHelp);
    if (helpClose) helpClose.addEventListener('click', closeHelp);
    if (helpOverlay) helpOverlay.addEventListener('click', function (e) {
        if (e.target === helpOverlay) closeHelp();
    });

    /* ===== Re-route the cell-row + organelle-row handlers through
       small helpers so the keyboard shortcuts can reuse them. ======== */
    function selectCellById(id) {
        if (id === state.selectedCellId) return;
        state.selectedCellId = id;
        state.activeOrganelle = selectedCell().defaultOrganelle;
        // Drop AI conversation history — the system prompt's "current view"
        // changes so prior turns lose their context.
        aiConversation = [];
        syncTutorClearBtn();
        closeCompareModal();
        rerenderAll();
        pushSceneState();
        updateUrlState();
    }
    function cycleOrganelle(delta) {
        var cell = selectedCell();
        var orgs = cell.organelles;
        var idx = 0;
        for (var i = 0; i < orgs.length; i++) if (orgs[i].id === state.activeOrganelle) { idx = i; break; }
        var next = (idx + delta + orgs.length) % orgs.length;
        state.activeOrganelle = orgs[next].id;
        renderOrganelleList();
        renderLegend();
        renderDetails();
        renderTutor();
        pushSceneState();
        updateUrlState();
    }

    /* ===== Global keyboard shortcuts ================================
       Suppressed while the user is typing in a form input or while a
       modifier key (Cmd/Ctrl/Alt) is held — keeps "Cmd-S" save-page
       and "Ctrl-F" find shortcuts working. */
    document.addEventListener('keydown', function (e) {
        var t = e.target;
        if (t && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' ||
                  t.tagName === 'SELECT' || t.isContentEditable)) return;
        if (e.altKey || e.ctrlKey || e.metaKey) return;

        var key = e.key;

        // Lightbox keyboard nav takes precedence when open.
        if (lightbox && lightbox.classList.contains('is-open')) {
            if (key === 'ArrowLeft')  { lightboxStep(-1); e.preventDefault(); return; }
            if (key === 'ArrowRight') { lightboxStep( 1); e.preventDefault(); return; }
            if (key === 'Escape')     { closeLightbox();   e.preventDefault(); return; }
        }

        // 1-7: cell index
        if (key >= '1' && key <= '7') {
            var idx = parseInt(key, 10) - 1;
            if (idx < cells.length) { selectCellById(cells[idx].id); e.preventDefault(); }
            return;
        }

        switch (key) {
            case '[': cycleOrganelle(-1); e.preventDefault(); break;
            case ']': cycleOrganelle( 1); e.preventDefault(); break;
            case 'r': case 'R':
                state.autoRotate = !state.autoRotate;
                rotateBtn.classList.toggle('is-active', state.autoRotate);
                pushSceneState(); updateUrlState(); e.preventDefault();
                break;
            case 'l': case 'L':
                setLabelsVisible(!state.labelsVisible);
                updateUrlState(); e.preventDefault();
                break;
            case 'f': case 'F':
                state.viewMode = state.viewMode === 'focus' ? 'mesh' : 'focus';
                renderStageTitle(); pushSceneState(); updateUrlState();
                e.preventDefault();
                break;
            case 'x': case 'X':
                state.crossSection = !state.crossSection;
                crossSectionInput.checked = state.crossSection;
                pushSceneState(); updateUrlState(); e.preventDefault();
                break;
            case 's': case 'S':
                screenshotBtn.click(); e.preventDefault();
                break;
            case 'c': case 'C':
                if (shareBtn) { shareBtn.click(); e.preventDefault(); }
                break;
            case '?':
                openHelp(); e.preventDefault();
                break;
            case 'Escape':
                if (helpOverlay && helpOverlay.classList.contains('is-open')) { closeHelp(); break; }
                closeCompareModal();
                break;
        }
    });

    /* ===== Sync URL state on every UI-driven state change.
       Boot already restored from URL; from here on, every handler
       calls updateUrlState() so the bar stays current. ============== */
    [modeSwitcher, crossSectionInput, rotateBtn, isolateBtn, hideBtn, resetBtn].forEach(function (el) {
        if (el) el.addEventListener('click', updateUrlState);
        if (el && el === crossSectionInput) el.addEventListener('change', updateUrlState);
    });
    // The cell-row + organelle-row click handlers and the rail-collapse
    // toggles need URL updates too; their existing handlers fire first
    // and we tack a wrapper here.
    cellList.addEventListener('click', function (e) {
        // Defer to the original handler's setTimeout-free path — the
        // state update happens synchronously above this listener thanks
        // to event registration order, so just re-sync the URL.
        setTimeout(updateUrlState, 0);
    });
    organelleList.addEventListener('click', function () { setTimeout(updateUrlState, 0); });

})();
</script>

</body>
</html>
