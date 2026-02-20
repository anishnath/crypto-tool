<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="3D Molecular Geometry Calculator | Interactive VSEPR Visualizer" />
        <jsp:param name="toolDescription" value="Free interactive 3D molecular geometry tool with real PubChem coordinates. Rotate, zoom, and explore any molecule in 3D. VSEPR shapes, bond angles, lone pairs visualized as translucent lobes. Compare molecules side-by-side. 54+ molecule database. PDF export with 3D snapshots." />
        <jsp:param name="toolCategory" value="Chemistry Tools" />
        <jsp:param name="toolUrl" value="molecular-geometry-calculator.jsp" />
        <jsp:param name="toolKeywords" value="3D molecular geometry calculator, VSEPR 3D visualizer, interactive molecule viewer, molecular shape calculator, bond angle calculator, 3D molecule viewer online free, VSEPR theory calculator, molecular geometry of H2O, molecular geometry of CH4 NH3 CO2 SF6, compare molecular geometry, lone pair visualization, hybridization calculator, VSEPR shapes chart, molecular geometry practice worksheet" />
        <jsp:param name="toolImage" value="molecular-geometry-3d.svg" />
        <jsp:param name="toolFeatures" value="Interactive 3D molecular models with rotate and zoom,Real 3D coordinates from PubChem database,Lone pairs shown as translucent golden lobes,Side-by-side molecule comparison with diff table,Search by formula or molecule name (e.g. Water Methane),54-molecule database with instant search,Step-by-step VSEPR analysis,Multi-center molecule support (glucose ethanol benzene),Bond angle measurements on 3D model,PDF export with 3D model snapshot,Printable VSEPR reference chart,Practice worksheet generator for teachers" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter a formula or molecule name|Type a chemical formula like H2O or CH4 or a name like Water or Methane into the formula input field,View the interactive 3D model|The tool fetches real 3D coordinates from PubChem and renders an interactive model you can rotate zoom and pan. Lone pairs appear as golden translucent lobes,Read the VSEPR analysis|Check the molecular shape bond angles hybridization and electron geometry in the results grid with step-by-step explanation,Compare two molecules|Switch to Compare tab and enter two formulas side-by-side to see geometry differences highlighted in a diff table,Export as PDF|Click Download PDF to save results with a 3D model snapshot for homework or reference" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="VSEPR theory, molecular geometry, bond angles, hybridization, electron geometry, lone pair effects, 3D molecular structure" />
        <jsp:param name="faq1q" value="What is VSEPR theory and how does it predict molecular geometry?" />
        <jsp:param name="faq1a" value="VSEPR (Valence Shell Electron Pair Repulsion) theory predicts 3D molecular shapes by assuming electron pairs around a central atom repel each other and arrange to maximize distance. Count bonding pairs and lone pairs, determine the electron geometry, then remove lone pairs to get the molecular geometry. For example, water has 4 electron pairs (2 bonding, 2 lone) giving tetrahedral electron geometry but bent molecular shape with 104.5 degree bond angle." />
        <jsp:param name="faq2q" value="How does the 3D molecular viewer work?" />
        <jsp:param name="faq2a" value="The tool fetches real 3D atomic coordinates from the PubChem database and renders them using WebGL-based 3Dmol.js. You can rotate the model by dragging, zoom with scroll, and pan with right-drag. Lone pairs are shown as translucent golden lobes positioned using VSEPR geometry. Bond angle measurements are displayed directly on the 3D model. If PubChem data is unavailable, the tool falls back to mathematically computed VSEPR positions." />
        <jsp:param name="faq3q" value="What is the difference between electron geometry and molecular geometry?" />
        <jsp:param name="faq3a" value="Electron geometry considers ALL electron pairs (bonding plus lone pairs) around the central atom. Molecular geometry only considers the positions of atoms (bonding pairs). For NH3, electron geometry is tetrahedral (4 electron pairs total) but molecular geometry is trigonal pyramidal (3 bonding pairs visible, 1 lone pair invisible). The 3D viewer shows both: atoms as colored spheres and lone pairs as translucent golden lobes." />
        <jsp:param name="faq4q" value="Can I compare two molecules side by side?" />
        <jsp:param name="faq4a" value="Yes. Click the Compare tab and enter two formulas or molecule names. The tool renders both molecules in interactive 3D viewers side by side and shows a comparison table highlighting matching and differing properties including geometry, bond angle, hybridization, bonding pairs, and lone pairs. Try presets like H2O vs NH3 or CH4 vs CCl4 to see how substituents affect molecular shape." />
        <jsp:param name="faq5q" value="What are the main molecular geometry shapes in VSEPR theory?" />
        <jsp:param name="faq5a" value="The main shapes are: Linear (180 degrees, e.g. CO2), Bent (104-120 degrees, e.g. H2O), Trigonal Planar (120 degrees, e.g. BF3), Trigonal Pyramidal (107 degrees, e.g. NH3), Tetrahedral (109.5 degrees, e.g. CH4), See-Saw (e.g. SF4), T-Shaped (e.g. ClF3), Square Planar (90 degrees, e.g. XeF4), Square Pyramidal (e.g. BrF5), Trigonal Bipyramidal (90 and 120 degrees, e.g. PCl5), and Octahedral (90 degrees, e.g. SF6). All shapes can be explored in interactive 3D on this tool." />
        <jsp:param name="faq6q" value="Can this tool handle complex molecules like glucose or benzene?" />
        <jsp:param name="faq6a" value="Yes. For multi-center molecules like glucose (C6H12O6), ethanol (C2H6O), or benzene (C6H6), the tool fetches the full 3D structure from PubChem and renders it as an interactive model. It also analyzes each atom center individually using VSEPR theory, showing geometry, bond angles, and hybridization per center, plus the Index of Hydrogen Deficiency (IHD) to identify rings and double bonds." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/molecular-geometry.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        .tool-action-btn { background: var(--mg-gradient) !important; }
        .tool-badge { background: var(--mg-light); color: var(--mg-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">3D Molecular Geometry Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp">Chemistry Tools</a> /
                3D Molecular Geometry
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Interactive 3D</span>
            <span class="tool-badge">VSEPR Theory</span>
            <span class="tool-badge">54+ Molecules</span>
            <span class="tool-badge">Compare</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--mg-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>interactive 3D molecular geometry</strong> tool using <strong>VSEPR theory</strong> with real <strong>PubChem coordinates</strong>. Enter any <strong>chemical formula</strong> or molecule name to explore <strong>molecular shapes</strong> in 3D &mdash; rotate, zoom, and see <strong>lone pairs</strong> as translucent lobes. <strong>Compare molecules</strong> side-by-side, download <strong>PDF with 3D snapshots</strong>, and generate <strong>practice worksheets</strong>.</p>
        </div>
    </div>
</section>

<section style="max-width:900px;margin:0 auto;padding:0.75rem 1rem;">
    <img src="<%=request.getContextPath()%>/images/site/molecular-geometry-3d.svg"
         alt="VSEPR molecular geometry shapes diagram showing Linear CO2, Trigonal Planar BF3, Bent H2O with lone pairs, Tetrahedral CH4, Trigonal Pyramidal NH3, Trigonal Bipyramidal PCl5, Octahedral SF6, and See-Saw SF4 with bond angles and hybridization"
         width="1200" height="630" loading="eager" style="width:100%;height:auto;border-radius:0.75rem;" />
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--mg-gradient);">VSEPR Analysis</div>
            <div class="tool-card-body">

                <!-- Mode Toggle -->
                <div class="mg-mode-toggle">
                    <button type="button" class="mg-mode-btn active" data-mode="pairs">By Pairs</button>
                    <button type="button" class="mg-mode-btn" data-mode="formula">By Formula</button>
                </div>

                <!-- By Pairs Form -->
                <div class="mg-mode-form active" id="mg-form-pairs">
                    <div class="mg-input-row">
                        <div class="mg-input-group">
                            <label class="mg-input-label" for="mg-bp">Bonding Pairs (BP)</label>
                            <input type="number" class="mg-input" id="mg-bp" min="1" max="7" value="4">
                        </div>
                        <div class="mg-input-group">
                            <label class="mg-input-label" for="mg-lp">Lone Pairs (LP)</label>
                            <input type="number" class="mg-input" id="mg-lp" min="0" max="4" value="0">
                        </div>
                    </div>
                    <div class="mg-input-hint">Atoms bonded to central atom (BP) and lone electron pairs (LP)</div>
                </div>

                <!-- By Formula Form -->
                <div class="mg-mode-form" id="mg-form-formula">
                    <div class="tool-form-group">
                        <label class="mg-input-label" for="mg-formula">Chemical Formula</label>
                        <input type="text" class="mg-input mg-formula-input" id="mg-formula" placeholder="e.g., CH4, H2O, Methane, Water">
                        <div class="mg-input-hint">Enter a formula (CH4, NH3, SF6, NH4+) or molecule name (Methane, Water, Ammonia).</div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;margin-top:0.75rem;">
                    <button type="button" class="tool-action-btn" id="mg-solve-btn" style="flex:1">Calculate Geometry</button>
                    <button type="button" class="tool-action-btn" id="mg-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <!-- Always-available resource buttons -->
                <div style="display:flex;gap:0.5rem;margin-top:0.75rem;">
                    <button type="button" class="tool-action-btn" id="mg-download-chart-btn" style="flex:1;width:auto;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;background:var(--bg-secondary)!important;color:var(--text-primary);border:1px solid var(--border)">&#128202; VSEPR Chart</button>
                    <button type="button" class="tool-action-btn" id="mg-practice-btn" style="flex:1;width:auto;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;background:var(--bg-secondary)!important;color:var(--text-primary);border:1px solid var(--border)">&#128218; Practice Sheet</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="mg-examples">
                        <button type="button" class="mg-example-chip" data-example="ch4">CH&#8324;</button>
                        <button type="button" class="mg-example-chip" data-example="h2o">H&#8322;O</button>
                        <button type="button" class="mg-example-chip" data-example="nh3">NH&#8323;</button>
                        <button type="button" class="mg-example-chip" data-example="co2">CO&#8322;</button>
                        <button type="button" class="mg-example-chip" data-example="sf6">SF&#8326;</button>
                        <button type="button" class="mg-example-chip" data-example="bf3">BF&#8323;</button>
                        <button type="button" class="mg-example-chip" data-example="xef4">XeF&#8324;</button>
                        <button type="button" class="mg-example-chip" data-example="pcl5">PCl&#8325;</button>
                        <button type="button" class="mg-example-chip" data-example="nh4+">NH&#8324;&#8314;</button>
                        <button type="button" class="mg-example-chip" data-example="sf4">SF&#8324;</button>
                        <button type="button" class="mg-example-chip" data-example="clf3">ClF&#8323;</button>
                        <button type="button" class="mg-example-chip" data-example="if7">IF&#8327;</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="mg-output-tabs">
            <button type="button" class="mg-output-tab active" data-panel="result">Result</button>
            <button type="button" class="mg-output-tab" data-panel="compare">Compare</button>
            <button type="button" class="mg-output-tab" data-panel="database">Database</button>
        </div>

        <!-- Result Panel -->
        <div class="mg-panel active" id="mg-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mg-tool);">
                        <circle cx="12" cy="12" r="3"/><path d="M12 2v4m0 12v4M2 12h4m12 0h4m-3.5-6.5l-2.8 2.8m-7.4 7.4l-2.8 2.8m0-13l2.8 2.8m7.4 7.4l2.8 2.8"/>
                    </svg>
                    <h4>Molecular Geometry</h4>
                </div>
                <div class="tool-result-content" id="mg-result-content">
                    <div class="tool-empty-state" id="mg-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#9883;</div>
                        <h3>Enter molecule details</h3>
                        <p>Determine molecular geometry using VSEPR theory with step-by-step analysis.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="mg-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="mg-download-pdf-btn" style="flex:1 1 auto;width:auto;min-width:80px;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;">&#128196; Download PDF</button>
                    <a id="mg-lewis-btn" href="#" target="_blank" class="tool-action-btn" style="flex:1 1 auto;width:auto;min-width:80px;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;text-align:center;text-decoration:none;display:none;">&#9883; Lewis Structure</a>
                    <button type="button" class="tool-action-btn" id="mg-share-btn" style="flex:0 0 auto;width:auto;min-width:60px;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Share</button>
                </div>
            </div>
        </div>

        <!-- Compare Panel -->
        <div class="mg-panel" id="mg-panel-compare">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mg-tool);">
                        <rect x="2" y="3" width="8" height="18" rx="1"/><rect x="14" y="3" width="8" height="18" rx="1"/>
                    </svg>
                    <h4>Compare Molecules</h4>
                </div>
                <div style="padding:0.75rem;">
                    <!-- Preset comparisons -->
                    <div class="mg-compare-presets">
                        <button type="button" class="mg-compare-preset" data-cmp="H2O,NH3">H&#8322;O vs NH&#8323;</button>
                        <button type="button" class="mg-compare-preset" data-cmp="CH4,CCl4">CH&#8324; vs CCl&#8324;</button>
                        <button type="button" class="mg-compare-preset" data-cmp="CO2,H2O">CO&#8322; vs H&#8322;O</button>
                        <button type="button" class="mg-compare-preset" data-cmp="BF3,NH3">BF&#8323; vs NH&#8323;</button>
                        <button type="button" class="mg-compare-preset" data-cmp="SF6,SF4">SF&#8326; vs SF&#8324;</button>
                        <button type="button" class="mg-compare-preset" data-cmp="PCl5,PCl3">PCl&#8325; vs PCl&#8323;</button>
                    </div>
                    <!-- Inputs -->
                    <div class="mg-compare-container">
                        <div class="mg-compare-side">
                            <div class="mg-compare-input-row">
                                <input type="text" class="mg-compare-input" id="mg-cmp-1" placeholder="e.g., H2O">
                            </div>
                            <div id="mg-cmp-result-1"></div>
                        </div>
                        <div class="mg-compare-side">
                            <div class="mg-compare-input-row">
                                <input type="text" class="mg-compare-input" id="mg-cmp-2" placeholder="e.g., NH3">
                            </div>
                            <div id="mg-cmp-result-2"></div>
                        </div>
                    </div>
                    <!-- Compare button -->
                    <div style="text-align:center;margin:0.5rem 0;">
                        <button type="button" class="mg-compare-go-btn" id="mg-cmp-btn">Compare</button>
                    </div>
                    <!-- Diff table -->
                    <div id="mg-cmp-diff"></div>
                </div>
            </div>
        </div>

        <!-- Database Panel -->
        <div class="mg-panel" id="mg-panel-database">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mg-tool);">
                        <ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                    </svg>
                    <h4>Molecule Database (54)</h4>
                </div>
                <div style="padding:0.75rem;">
                    <input type="text" class="mg-search-input" id="mg-search" placeholder="Search by formula, name, or geometry...">
                    <div class="mg-table-wrap">
                        <table class="mg-table">
                            <thead>
                                <tr>
                                    <th>Formula</th>
                                    <th>Name</th>
                                    <th>BP</th>
                                    <th>LP</th>
                                    <th>Geometry</th>
                                    <th>Angle</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="mg-table-body"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="molecular-geometry-calculator.jsp"/>
    <jsp:param name="keyword" value="chemistry"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT IS VSEPR THEORY? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">1</span> What is VSEPR Theory?
        </h2>
        <p class="mg-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            <strong>VSEPR</strong> (Valence Shell Electron Pair Repulsion) theory states that <strong>electron pairs repel each other</strong> whether they are bonding pairs or lone pairs. They position themselves around a central atom to <strong>minimize repulsion</strong>, which determines the 3D shape of the molecule. An electron group can be a bond pair, lone pair, single unpaired electron, or multiple bond.
        </p>

        <!-- AXnEm Notation Visual -->
        <div class="mg-notation-hero mg-anim mg-anim-d1">
            <div class="mg-notation-block">
                <div class="mg-notation-symbol mg-c-a">A</div>
                <div class="mg-notation-label mg-c-a">Central Atom</div>
            </div>
            <div class="mg-notation-block">
                <div class="mg-notation-symbol mg-c-x">X<sub>n</sub></div>
                <div class="mg-notation-label mg-c-x">Bonding Pairs</div>
            </div>
            <div class="mg-notation-block">
                <div class="mg-notation-symbol mg-c-e">E<sub>m</sub></div>
                <div class="mg-notation-label mg-c-e">Lone Pairs</div>
            </div>
            <div class="mg-notation-block">
                <div class="mg-notation-symbol mg-c-eq">=</div>
                <div class="mg-notation-label mg-c-eq">Shape</div>
            </div>
        </div>

        <div class="mg-callout mg-callout-insight mg-anim mg-anim-d2">
            <span class="mg-callout-icon">&#128161;</span>
            <div class="mg-callout-text">
                <strong>Two critical concepts:</strong> <em>Electron-group geometry</em> is determined solely by the number of electron groups around the central atom. <em>Molecular geometry</em> depends on both electron groups AND how many are lone pairs. They only match when there are zero lone pairs.
            </div>
        </div>
    </div>

    <!-- ===== 2. HOW TO DETERMINE MOLECULAR GEOMETRY ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">2</span> How to Determine Molecular Geometry
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Follow these four steps for any molecule. This is the exact process our calculator automates:
        </p>

        <!-- Visual 4-step walkthrough using H₂O -->
        <div class="mg-visual-steps">

            <!-- Step 1: Lewis Structure -->
            <div class="mg-vstep mg-anim mg-anim-d1">
                <div class="mg-vstep-num">1</div>
                <div class="mg-vstep-body">
                    <h4>Draw the Lewis Structure</h4>
                    <div class="mg-vstep-diagram">
                        <div class="mg-lewis-css">
                            <div class="mg-dots mg-dots-top">
                                <span class="mg-dot"></span><span class="mg-dot"></span>
                            </div>
                            <div class="mg-lewis-row">
                                <span class="mg-atom mg-atom-h">H</span>
                                <span class="mg-bond">&mdash;</span>
                                <span class="mg-atom mg-atom-central">O</span>
                                <span class="mg-bond">&mdash;</span>
                                <span class="mg-atom mg-atom-h">H</span>
                            </div>
                            <div class="mg-dots mg-dots-bottom">
                                <span class="mg-dot"></span><span class="mg-dot"></span>
                            </div>
                        </div>
                        <div class="mg-vstep-labels">
                            <span class="mg-vlabel mg-vlabel-bond">2 bonding pairs</span>
                            <span class="mg-vlabel mg-vlabel-lone">2 lone pairs</span>
                        </div>
                    </div>
                    <p>O is central (6 e&#x207b;), each H has 1 e&#x207b;. Total: 8 valence electrons.</p>
                </div>
            </div>

            <!-- Step 2: Count electron groups -->
            <div class="mg-vstep mg-anim mg-anim-d2">
                <div class="mg-vstep-num">2</div>
                <div class="mg-vstep-body">
                    <h4>Count Electron Groups</h4>
                    <div class="mg-vstep-diagram">
                        <div class="mg-egroups">
                            <div class="mg-egroup mg-egroup-bond"><span class="mg-egroup-icon">&#9135;</span><span>Bond</span></div>
                            <div class="mg-egroup mg-egroup-bond"><span class="mg-egroup-icon">&#9135;</span><span>Bond</span></div>
                            <div class="mg-egroup mg-egroup-lone"><span class="mg-egroup-icon">&#8759;</span><span>LP</span></div>
                            <div class="mg-egroup mg-egroup-lone"><span class="mg-egroup-icon">&#8759;</span><span>LP</span></div>
                        </div>
                        <div class="mg-egroup-total">= <strong>4</strong> electron groups</div>
                    </div>
                    <p>Each bond or lone pair = 1 group. Double/triple bonds count as <strong>one</strong> group.</p>
                </div>
            </div>

            <!-- Step 3: Electron geometry -->
            <div class="mg-vstep mg-anim mg-anim-d3">
                <div class="mg-vstep-num">3</div>
                <div class="mg-vstep-body">
                    <h4>Electron Geometry &rarr; Tetrahedral</h4>
                    <div class="mg-vstep-diagram">
                        <div class="mg-shape-tetra">
                            <div class="mg-shape-node mg-shape-top"><span class="mg-dot"></span><span class="mg-dot"></span></div>
                            <div class="mg-shape-line mg-shape-line-tl"></div>
                            <div class="mg-shape-line mg-shape-line-tr"></div>
                            <div class="mg-shape-center">O</div>
                            <div class="mg-shape-line mg-shape-line-bl"></div>
                            <div class="mg-shape-line mg-shape-line-br"></div>
                            <div class="mg-shape-node mg-shape-left">H</div>
                            <div class="mg-shape-node mg-shape-right">H</div>
                            <div class="mg-shape-node mg-shape-bot"><span class="mg-dot"></span><span class="mg-dot"></span></div>
                        </div>
                        <div class="mg-shape-lookup">
                            <div class="mg-lookup-row"><span>2 groups</span><span>&rarr;</span><span>Linear</span></div>
                            <div class="mg-lookup-row"><span>3 groups</span><span>&rarr;</span><span>Trig. Planar</span></div>
                            <div class="mg-lookup-row mg-lookup-active"><span>4 groups</span><span>&rarr;</span><span>Tetrahedral</span></div>
                            <div class="mg-lookup-row"><span>5 groups</span><span>&rarr;</span><span>Trig. Bipyramidal</span></div>
                            <div class="mg-lookup-row"><span>6 groups</span><span>&rarr;</span><span>Octahedral</span></div>
                        </div>
                    </div>
                    <p>4 electron groups arrange at tetrahedral corners (109.5&deg;).</p>
                </div>
            </div>

            <!-- Step 4: Remove lone pairs → molecular geometry -->
            <div class="mg-vstep mg-anim mg-anim-d4">
                <div class="mg-vstep-num">4</div>
                <div class="mg-vstep-body">
                    <h4>Remove Lone Pairs &rarr; Bent!</h4>
                    <div class="mg-vstep-diagram">
                        <div class="mg-transform">
                            <div class="mg-transform-before">
                                <div class="mg-mini-shape">
                                    <span class="mg-mini-lp">:</span>
                                    <span class="mg-mini-lp">:</span>
                                    <span class="mg-mini-center">O</span>
                                    <span class="mg-mini-bond">H</span>
                                    <span class="mg-mini-bond">H</span>
                                </div>
                                <div class="mg-transform-label">Tetrahedral<br>(electron)</div>
                            </div>
                            <div class="mg-transform-arrow">
                                <span class="mg-cross-lp">&times; LP</span>
                                <span>&rArr;</span>
                            </div>
                            <div class="mg-transform-after">
                                <div class="mg-mini-bent">
                                    <span class="mg-mini-center">O</span>
                                    <div class="mg-bent-arms">
                                        <span class="mg-mini-bond">H</span>
                                        <span class="mg-mini-bond">H</span>
                                    </div>
                                </div>
                                <div class="mg-transform-label mg-transform-result">Bent<br>104.5&deg;</div>
                            </div>
                        </div>
                    </div>
                    <p>AX&#8322;E&#8322; &rarr; <strong>Bent</strong>. Lone pairs compress bond angle from 109.5&deg; to 104.5&deg;.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== 3. ELECTRON VS MOLECULAR GEOMETRY ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">3</span> Electron Geometry vs Molecular Geometry
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            This is the most common point of confusion. Both start from the same electron arrangement, but molecular geometry only shows where atoms sit &mdash; lone pairs are invisible to the eye.
        </p>

        <!-- NH3 comparison -->
        <h3 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:1rem 0 0.5rem;">Example: Ammonia (NH&#8323;) &mdash; AX&#8323;E</h3>
        <div class="mg-compare mg-anim mg-anim-d1">
            <div class="mg-compare-card mg-compare-electron">
                <h4>Electron Geometry</h4>
                <div class="mg-compare-diagram">    :
    |
 H&mdash;N&mdash;H
    |
    H</div>
                <p><strong>Tetrahedral</strong><br>4 electron groups (3 bonds + 1 lone pair) arrange tetrahedrally</p>
            </div>
            <div class="mg-compare-vs">&rarr;</div>
            <div class="mg-compare-card mg-compare-molecular">
                <h4>Molecular Geometry</h4>
                <div class="mg-compare-diagram">
 H&mdash;N&mdash;H
    |
    H</div>
                <p><strong>Trigonal Pyramidal</strong><br>Remove the lone pair &mdash; only 3 atoms remain in a pyramid shape</p>
            </div>
        </div>

        <!-- H2O comparison -->
        <h3 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:1.25rem 0 0.5rem;">Example: Water (H&#8322;O) &mdash; AX&#8322;E&#8322;</h3>
        <div class="mg-compare mg-anim mg-anim-d2">
            <div class="mg-compare-card mg-compare-electron">
                <h4>Electron Geometry</h4>
                <div class="mg-compare-diagram">  : :
   |
H&mdash;O&mdash;H</div>
                <p><strong>Tetrahedral</strong><br>4 electron groups (2 bonds + 2 lone pairs)</p>
            </div>
            <div class="mg-compare-vs">&rarr;</div>
            <div class="mg-compare-card mg-compare-molecular">
                <h4>Molecular Geometry</h4>
                <div class="mg-compare-diagram">
H&mdash;O&mdash;H</div>
                <p><strong>Bent</strong><br>Two lone pairs hidden &mdash; only the V-shape remains at 104.5&deg;</p>
            </div>
        </div>
    </div>

    <!-- ===== 4. COMPLETE VSEPR REFERENCE TABLE ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">4</span> Complete VSEPR Reference Table
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Every electron group count mapped to its electron geometry, molecular geometry, and bond angle. This is the master table used by chemists worldwide.
        </p>

        <div class="mg-ref-wrap mg-anim mg-anim-d1">
            <table class="mg-ref-table">
                <thead>
                    <tr>
                        <th>Groups</th>
                        <th>Electron Geometry</th>
                        <th>LP</th>
                        <th>VSEPR</th>
                        <th>Molecular Shape</th>
                        <th>Bond Angle</th>
                        <th>Example</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="mg-row-group"><td colspan="7">2 Electron Groups</td></tr>
                    <tr><td>2</td><td>Linear</td><td>0</td><td>AX&#8322;</td><td>Linear</td><td>180&deg;</td><td>CO&#8322;, BeCl&#8322;</td></tr>
                    <tr class="mg-row-group"><td colspan="7">3 Electron Groups</td></tr>
                    <tr><td>3</td><td>Trigonal Planar</td><td>0</td><td>AX&#8323;</td><td>Trigonal Planar</td><td>120&deg;</td><td>BF&#8323;, SO&#8323;</td></tr>
                    <tr><td>3</td><td>Trigonal Planar</td><td>1</td><td>AX&#8322;E</td><td>Bent</td><td>~119&deg;</td><td>SO&#8322;, O&#8323;</td></tr>
                    <tr class="mg-row-group"><td colspan="7">4 Electron Groups</td></tr>
                    <tr><td>4</td><td>Tetrahedral</td><td>0</td><td>AX&#8324;</td><td>Tetrahedral</td><td>109.5&deg;</td><td>CH&#8324;, CCl&#8324;</td></tr>
                    <tr><td>4</td><td>Tetrahedral</td><td>1</td><td>AX&#8323;E</td><td>Trigonal Pyramidal</td><td>~107&deg;</td><td>NH&#8323;, PCl&#8323;</td></tr>
                    <tr><td>4</td><td>Tetrahedral</td><td>2</td><td>AX&#8322;E&#8322;</td><td>Bent</td><td>~104.5&deg;</td><td>H&#8322;O, H&#8322;S</td></tr>
                    <tr class="mg-row-group"><td colspan="7">5 Electron Groups</td></tr>
                    <tr><td>5</td><td>Trigonal Bipyramidal</td><td>0</td><td>AX&#8325;</td><td>Trigonal Bipyramidal</td><td>90&deg;, 120&deg;</td><td>PCl&#8325;, PF&#8325;</td></tr>
                    <tr><td>5</td><td>Trigonal Bipyramidal</td><td>1</td><td>AX&#8324;E</td><td>See-Saw</td><td>~102&deg;, ~173&deg;</td><td>SF&#8324;, TeCl&#8324;</td></tr>
                    <tr><td>5</td><td>Trigonal Bipyramidal</td><td>2</td><td>AX&#8323;E&#8322;</td><td>T-Shaped</td><td>~87.5&deg;</td><td>ClF&#8323;, BrF&#8323;</td></tr>
                    <tr><td>5</td><td>Trigonal Bipyramidal</td><td>3</td><td>AX&#8322;E&#8323;</td><td>Linear</td><td>180&deg;</td><td>XeF&#8322;, I&#8323;&#8315;</td></tr>
                    <tr class="mg-row-group"><td colspan="7">6 Electron Groups</td></tr>
                    <tr><td>6</td><td>Octahedral</td><td>0</td><td>AX&#8326;</td><td>Octahedral</td><td>90&deg;</td><td>SF&#8326;, PF&#8326;&#8315;</td></tr>
                    <tr><td>6</td><td>Octahedral</td><td>1</td><td>AX&#8325;E</td><td>Square Pyramidal</td><td>~84&deg;</td><td>BrF&#8325;, IF&#8325;</td></tr>
                    <tr><td>6</td><td>Octahedral</td><td>2</td><td>AX&#8324;E&#8322;</td><td>Square Planar</td><td>90&deg;</td><td>XeF&#8324;, ICl&#8324;&#8315;</td></tr>
                    <tr class="mg-row-group"><td colspan="7">7 Electron Groups</td></tr>
                    <tr><td>7</td><td>Pentagonal Bipyramidal</td><td>0</td><td>AX&#8327;</td><td>Pentagonal Bipyramidal</td><td>72&deg;, 90&deg;</td><td>IF&#8327;</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ===== 5. LONE PAIR EFFECTS ON BOND ANGLES ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">5</span> How Lone Pairs Compress Bond Angles
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Lone pairs are held <strong>closer to the nucleus</strong> than bonding pairs, so they occupy more angular space. This extra repulsion pushes bonding pairs closer together, compressing the bond angle. Each lone pair reduces the angle by roughly 2&ndash;3&deg;.
        </p>

        <p style="font-size:0.75rem;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.5rem;">Tetrahedral family &mdash; bond angle compression</p>
        <div class="mg-anim mg-anim-d1">
            <div class="mg-angle-bar">
                <div class="mg-angle-label">CH&#8324; (0 LP)</div>
                <div class="mg-angle-track">
                    <div class="mg-angle-fill mg-angle-fill-ideal" style="--fill:60.8%;">109.5&deg;</div>
                </div>
                <div class="mg-angle-val">ideal</div>
            </div>
            <div class="mg-angle-bar">
                <div class="mg-angle-label">NH&#8323; (1 LP)</div>
                <div class="mg-angle-track">
                    <div class="mg-angle-fill mg-angle-fill-lp1" style="--fill:59.4%;">107&deg;</div>
                </div>
                <div class="mg-angle-val">&minus;2.5&deg;</div>
            </div>
            <div class="mg-angle-bar">
                <div class="mg-angle-label">H&#8322;O (2 LP)</div>
                <div class="mg-angle-track">
                    <div class="mg-angle-fill mg-angle-fill-lp2" style="--fill:58.1%;">104.5&deg;</div>
                </div>
                <div class="mg-angle-val">&minus;5&deg;</div>
            </div>
        </div>

        <p style="font-size:0.75rem;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin:1.25rem 0 0.5rem;">Repulsion strength order</p>
        <div class="mg-anim mg-anim-d2" style="display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;">
            <span style="padding:0.375rem 0.75rem;background:#dc2626;color:#fff;border-radius:0.375rem;font-size:0.8125rem;font-weight:600;">LP&ndash;LP</span>
            <span style="font-size:1.25rem;color:var(--text-muted);">&gt;</span>
            <span style="padding:0.375rem 0.75rem;background:#d97706;color:#fff;border-radius:0.375rem;font-size:0.8125rem;font-weight:600;">LP&ndash;BP</span>
            <span style="font-size:1.25rem;color:var(--text-muted);">&gt;</span>
            <span style="padding:0.375rem 0.75rem;background:#059669;color:#fff;border-radius:0.375rem;font-size:0.8125rem;font-weight:600;">BP&ndash;BP</span>
            <span style="font-size:0.8125rem;color:var(--text-secondary);margin-left:0.5rem;">(strongest &rarr; weakest)</span>
        </div>

        <div class="mg-callout mg-callout-insight mg-anim mg-anim-d3">
            <span class="mg-callout-icon">&#128161;</span>
            <div class="mg-callout-text">
                <strong>Why this order?</strong> Lone pairs spread out more because they are attracted to only one nucleus (the central atom). Bonding pairs are shared between two nuclei, which keeps them more tightly confined.
            </div>
        </div>
    </div>

    <!-- ===== 6. COMMON GEOMETRIES ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">6</span> Common Molecular Geometries
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.5rem;">
            The six most common shapes you will encounter in chemistry courses:
        </p>

        <div class="mg-geom-grid">
            <div class="mg-edu-card mg-anim mg-anim-d1" style="border-left:3px solid #059669;">
                <h4><span style="color:#059669;">&#9679;</span> Linear (AX&#8322;)</h4>
                <p>180&deg; &bull; sp &bull; CO&#8322;, BeCl&#8322;, HCN</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d2" style="border-left:3px solid #2563eb;">
                <h4><span style="color:#2563eb;">&#9679;</span> Trigonal Planar (AX&#8323;)</h4>
                <p>120&deg; &bull; sp&sup2; &bull; BF&#8323;, SO&#8323;, AlCl&#8323;</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d3" style="border-left:3px solid #7c3aed;">
                <h4><span style="color:#7c3aed;">&#9679;</span> Tetrahedral (AX&#8324;)</h4>
                <p>109.5&deg; &bull; sp&sup3; &bull; CH&#8324;, CCl&#8324;, SiH&#8324;</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d4" style="border-left:3px solid #dc2626;">
                <h4><span style="color:#dc2626;">&#9679;</span> Bent (AX&#8322;E / AX&#8322;E&#8322;)</h4>
                <p>104&ndash;120&deg; &bull; sp&sup2; or sp&sup3; &bull; H&#8322;O, SO&#8322;, O&#8323;</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d5" style="border-left:3px solid #d97706;">
                <h4><span style="color:#d97706;">&#9679;</span> Trigonal Pyramidal (AX&#8323;E)</h4>
                <p>~107&deg; &bull; sp&sup3; &bull; NH&#8323;, PCl&#8323;, AsH&#8323;</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d6" style="border-left:3px solid #0891b2;">
                <h4><span style="color:#0891b2;">&#9679;</span> Octahedral (AX&#8326;)</h4>
                <p>90&deg; &bull; sp&sup3;d&sup2; &bull; SF&#8326;, PF&#8326;&#8315;</p>
            </div>
        </div>
    </div>

    <!-- ===== 7. HYBRIDIZATION EXPLAINED ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">7</span> Understanding Hybridization
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Hybridization describes how atomic orbitals mix to form new hybrid orbitals for bonding. The total number of <strong>electron domains</strong> (bonding + lone pairs) determines the hybridization type.
        </p>

        <div class="mg-geom-grid">
            <div class="mg-edu-card mg-anim mg-anim-d1" style="border-left:3px solid #22c55e;">
                <h4>2 domains &rarr; sp</h4>
                <p>Two hybrid orbitals at 180&deg;. Linear. Examples: CO&#8322;, BeCl&#8322;, HCN.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d2" style="border-left:3px solid #f59e0b;">
                <h4>3 domains &rarr; sp&sup2;</h4>
                <p>Three hybrid orbitals at 120&deg;. Trigonal planar. Examples: BF&#8323;, SO&#8322;, O&#8323;.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d3" style="border-left:3px solid #ef4444;">
                <h4>4 domains &rarr; sp&sup3;</h4>
                <p>Four hybrid orbitals at 109.5&deg;. Tetrahedral. Examples: CH&#8324;, NH&#8323;, H&#8322;O.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d4" style="border-left:3px solid #7c3aed;">
                <h4>5 domains &rarr; sp&sup3;d</h4>
                <p>Five hybrid orbitals at 90&deg; &amp; 120&deg;. Trigonal bipyramidal. Examples: PCl&#8325;, SF&#8324;.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d5" style="border-left:3px solid #0891b2;">
                <h4>6 domains &rarr; sp&sup3;d&sup2;</h4>
                <p>Six hybrid orbitals at 90&deg;. Octahedral. Examples: SF&#8326;, XeF&#8324;.</p>
            </div>
        </div>

        <div class="mg-callout mg-callout-tip mg-anim mg-anim-d6">
            <span class="mg-callout-icon">&#128073;</span>
            <div class="mg-callout-text">
                <strong>Quick rule:</strong> Count the total number of electron pairs (bonding + lone) around the central atom. That count equals the number of hybrid orbitals needed: 2&rarr;sp, 3&rarr;sp&sup2;, 4&rarr;sp&sup3;, 5&rarr;sp&sup3;d, 6&rarr;sp&sup3;d&sup2;.
            </div>
        </div>
    </div>

    <!-- ===== 8. POLARITY & DIPOLE MOMENTS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">8</span> Polarity &amp; Dipole Moments
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Molecular geometry directly determines whether a molecule is polar or nonpolar. When electrons are not distributed equally, the molecule has a <strong>net dipole moment</strong> (&mu; = &delta; &times; d). Electronegativity differences between atoms create partial charges (&delta;+ and &delta;&minus;).
        </p>

        <div class="mg-polar-grid mg-anim mg-anim-d1">
            <div class="mg-polar-card mg-polar-nonpolar">
                <h4>Nonpolar</h4>
                <div class="mg-polar-molecule">O=C=O</div>
                <p><strong>CO&#8322;</strong> is linear &mdash; two equal C=O dipoles point in opposite directions and <strong>cancel out</strong>. Net dipole = 0.</p>
            </div>
            <div class="mg-polar-card mg-polar-polar">
                <h4>Polar</h4>
                <div class="mg-polar-molecule">H&mdash;O&mdash;H</div>
                <p><strong>H&#8322;O</strong> is bent &mdash; the two O&ndash;H dipoles point in similar directions and do <strong>not cancel</strong>. Net dipole &ne; 0.</p>
            </div>
        </div>

        <h3 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:1.25rem 0 0.5rem;">Quick Polarity Rules</h3>
        <div class="mg-anim mg-anim-d2" style="display:grid;gap:0.5rem;">
            <div style="display:flex;gap:0.75rem;align-items:flex-start;padding:0.625rem 0.75rem;background:var(--bg-secondary);border-radius:0.5rem;">
                <span style="background:#059669;color:#fff;border-radius:50%;width:1.5rem;height:1.5rem;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0;">1</span>
                <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.5;">No lone pairs on central atom + all identical terminal atoms = <strong>nonpolar</strong> (e.g., CH&#8324;, BF&#8323;, SF&#8326;)</p>
            </div>
            <div style="display:flex;gap:0.75rem;align-items:flex-start;padding:0.625rem 0.75rem;background:var(--bg-secondary);border-radius:0.5rem;">
                <span style="background:#d97706;color:#fff;border-radius:50%;width:1.5rem;height:1.5rem;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0;">2</span>
                <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.5;">Symmetric geometry can still be nonpolar even with polar bonds &mdash; dipoles cancel by symmetry (e.g., CO&#8322; linear, XeF&#8324; square planar)</p>
            </div>
            <div style="display:flex;gap:0.75rem;align-items:flex-start;padding:0.625rem 0.75rem;background:var(--bg-secondary);border-radius:0.5rem;">
                <span style="background:#dc2626;color:#fff;border-radius:50%;width:1.5rem;height:1.5rem;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0;">3</span>
                <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.5;">Lone pairs on the central atom almost always make the molecule <strong>polar</strong> (e.g., NH&#8323;, H&#8322;O, SF&#8324;)</p>
            </div>
        </div>
    </div>

    <!-- ===== 9. REAL-WORLD APPLICATIONS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mg-section-num">9</span> Why Molecular Geometry Matters
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Molecular shape determines physical and chemical properties, from boiling points to biological activity.
        </p>
        <div class="mg-geom-grid">
            <div class="mg-edu-card mg-anim mg-anim-d1" style="border-left:3px solid #2563eb;">
                <h4>Drug Design</h4>
                <p>Pharmaceutical molecules must have the right 3D shape to bind to protein targets. Geometry determines whether a drug fits its receptor like a key in a lock.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d2" style="border-left:3px solid #7c3aed;">
                <h4>Polarity &amp; Solubility</h4>
                <p>CO&#8322; is linear and nonpolar (dissolves in oil), while H&#8322;O is bent and highly polar (universal solvent). Same atoms, different geometry, different properties.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d3" style="border-left:3px solid #059669;">
                <h4>Material Science</h4>
                <p>Silicon&rsquo;s tetrahedral bonding (sp&sup3;) creates the diamond cubic crystal structure that makes semiconductor chips possible.</p>
            </div>
            <div class="mg-edu-card mg-anim mg-anim-d4" style="border-left:3px solid #d97706;">
                <h4>Biological Activity</h4>
                <p>Enzyme active sites recognize substrates by their exact 3D shape. A single bond angle difference can make a molecule biologically inactive or toxic.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between electron geometry and molecular geometry?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Electron geometry considers all electron pairs (bonding + lone) while molecular geometry only considers atom positions. For example, NH&#8323; has tetrahedral electron geometry (4 total pairs) but trigonal pyramidal molecular geometry (3 visible bonds). They match only when there are zero lone pairs on the central atom.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I find the central atom in a molecule?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The central atom is usually the least electronegative atom (excluding hydrogen, which is always terminal). In most formulas, the central atom is written first: C in CH&#8324;, N in NH&#8323;, S in SF&#8326;. For oxoacids, the non-oxygen non-hydrogen atom is central (S in H&#8322;SO&#8324;).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Why do lone pairs affect bond angles?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Lone pairs are held closer to the nucleus than bonding pairs, so they occupy more angular space. This extra repulsion compresses the bond angles. The repulsion order is: LP&ndash;LP &gt; LP&ndash;BP &gt; BP&ndash;BP. Each lone pair reduces bond angles by roughly 2&ndash;3&deg; from the ideal geometry. That is why water (2 lone pairs) has 104.5&deg; instead of 109.5&deg;.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I determine if a molecule is polar or nonpolar?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">First determine the molecular geometry. If the molecule is perfectly symmetric with identical terminal atoms and no lone pairs (like CH&#8324;, CO&#8322;, SF&#8326;), it is nonpolar because dipoles cancel. If there are lone pairs on the central atom or different terminal atoms, the molecule is usually polar (like H&#8322;O, NH&#8323;, CHCl&#8323;). The key is whether individual bond dipoles cancel by symmetry.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What molecules does this calculator support?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The database contains 54 molecules covering all VSEPR geometries from linear to pentagonal bipyramidal. The dynamic formula parser handles any molecule built from known elements (H through Rn), including multi-center molecules like glucose (C&#8326;H&#8321;&#8322;O&#8326;) and ethanol (C&#8322;H&#8326;O). It supports ions with + or &minus; charge notation (NH4+, SO4(2-)). Enter the central atom first in the formula for best results.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this molecular geometry calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, 100% free with no signup. Features include VSEPR analysis by electron pairs or formula, 54-molecule database, step-by-step analysis, downloadable PDF results, printable VSEPR reference charts, practice worksheets for teachers, multi-center molecule support, and shareable URLs. All computation runs in your browser.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can this handle complex molecules like glucose or ethanol?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. For multi-center molecules like glucose (C&#8326;H&#8321;&#8322;O&#8326;), ethanol (C&#8322;H&#8326;O), or benzene (C&#8326;H&#8326;), the calculator detects multiple atom centers and analyzes each one using VSEPR theory. It shows geometry, bond angles, and hybridization per atom type, plus the Index of Hydrogen Deficiency (IHD) for rings and double bonds.</div>
        </div>
    </div>
</section>

<!-- Explore More Chemistry Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Chemistry Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;">&#9883;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Lewis Structure Generator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Draw Lewis structures with VSEPR shapes</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/chemical-equation-balancer.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">&#8652;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Chemical Equation Balancer</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Balance chemical equations step by step</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/electron-configuration-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#dc2626,#ef4444);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">e&#8315;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Electron Configuration</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Find electron configurations for any element</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Practice NCERT Problems -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem;">
        <h2 style="font-size:1.125rem;margin-bottom:0.75rem;">Practice NCERT Problems</h2>
        <p style="color:var(--text-secondary);margin-bottom:1rem;">Apply your molecular geometry knowledge to NCERT chemistry and physics problems:</p>
        <ul style="list-style:none;padding:0;margin:0;display:flex;flex-wrap:wrap;gap:0.75rem;">
            <li><a href="exams/books/ncert/class-11/physics-part-1/index.jsp" style="display:inline-block;padding:0.5rem 1rem;background:var(--bg-secondary,#f1f5f9);border-radius:0.5rem;color:var(--text-primary);text-decoration:none;font-size:0.875rem;border:1px solid var(--border,#e2e8f0);">Class 11 Physics Part 1</a></li>
            <li><a href="exams/books/ncert/class-12/physics-part-1/index.jsp" style="display:inline-block;padding:0.5rem 1rem;background:var(--bg-secondary,#f1f5f9);border-radius:0.5rem;color:var(--text-primary);text-decoration:none;font-size:0.875rem;border:1px solid var(--border,#e2e8f0);">Class 12 Physics Part 1</a></li>
        </ul>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.mg-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        els.forEach(function(el){ el.classList.add('mg-visible'); });
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        entries.forEach(function(e){
            if (e.isIntersecting) {
                e.target.classList.add('mg-visible');
                obs.unobserve(e.target);
            }
        });
    }, { threshold: 0.15 });
    els.forEach(function(el){ obs.observe(el); });
})();
</script>

<!-- Core Scripts -->
<script src="https://3Dmol.org/build/3Dmol-min.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/molecular-geometry-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/molecular-geometry-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
