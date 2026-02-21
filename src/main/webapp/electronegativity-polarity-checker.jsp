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
        <jsp:param name="toolName" value="Electronegativity & Polarity Checker | Bond Dipole Calculator" />
        <jsp:param name="toolDescription" value="Free interactive electronegativity and molecular polarity checker. Enter any formula or molecule name to see EN differences, bond types, polarity verdict with reasoning, and 3D models with EN heatmap and charge coloring. Bond dipole arrows, MMFF94 partial charges, and PDF export." />
        <jsp:param name="toolCategory" value="Chemistry Tools" />
        <jsp:param name="toolUrl" value="electronegativity-polarity-checker.jsp" />
        <jsp:param name="toolKeywords" value="electronegativity calculator, molecular polarity checker, is H2O polar, bond polarity calculator, delta EN calculator, polar vs nonpolar, dipole moment calculator, electronegativity difference, Pauling electronegativity scale, polar covalent bond, ionic vs covalent, bond dipole, molecular dipole, EN heatmap, partial charges, is CO2 polar or nonpolar" />
        <jsp:param name="toolImage" value="electronegativity-polarity.svg" />
        <jsp:param name="toolFeatures" value="Instant polar/nonpolar verdict with reasoning,Bond polarity table with EN values and delta EN,Interactive 3D model with EN heatmap coloring,Partial charge visualization from MMFF94 data,Bond dipole arrows showing charge direction,30-molecule database with dipole moments,Step-by-step polarity analysis,PDF export with 3D model snapshot,Search by formula or molecule name via PubChem,Share results via URL" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter a formula or molecule name|Type a chemical formula like H2O or CHCl3 or a name like Water or Chloroform into the input field,View the polarity verdict|The tool instantly shows POLAR or NONPOLAR with reasoning based on geometry symmetry and EN differences,Examine bond polarity table|See each bond with EN values for both atoms and the delta EN classification as nonpolar covalent polar covalent or ionic,Explore the 3D model|Switch between CPK colors EN heatmap and charge map modes. Toggle bond dipole arrows to see charge direction,Download PDF|Click Download PDF to save the complete analysis with 3D snapshot for study or reference" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="electronegativity, molecular polarity, bond polarity, dipole moments, polar vs nonpolar molecules, Pauling scale, partial charges, VSEPR and polarity" />
        <jsp:param name="faq1q" value="How do you determine if a molecule is polar or nonpolar?" />
        <jsp:param name="faq1a" value="First calculate the electronegativity difference (delta EN) for each bond. If delta EN is less than 0.4 the bond is nonpolar covalent. Between 0.4 and 1.7 is polar covalent. Above 1.7 is ionic. Then check the molecular geometry. If the molecule is symmetric with identical bonds and no lone pairs (like CO2 CH4 SF6) the bond dipoles cancel and the molecule is nonpolar. If there are lone pairs or mixed substituents the dipoles usually do not cancel making the molecule polar." />
        <jsp:param name="faq2q" value="What is the Pauling electronegativity scale?" />
        <jsp:param name="faq2a" value="The Pauling scale is the most widely used electronegativity scale developed by Linus Pauling in 1932. It measures an atoms ability to attract electrons in a chemical bond. Values range from 0.82 for cesium (least electronegative) to 3.98 for fluorine (most electronegative). Electronegativity generally increases left to right across a period and decreases down a group in the periodic table." />
        <jsp:param name="faq3q" value="Why is CO2 nonpolar even though C-O bonds are polar?" />
        <jsp:param name="faq3a" value="CO2 has two polar C=O bonds with delta EN of 0.89 each. However CO2 is linear (180 degrees) so the two bond dipoles point in exactly opposite directions and cancel out completely. The net molecular dipole moment is zero making CO2 nonpolar. This demonstrates that molecular polarity depends on both bond polarity AND molecular geometry." />
        <jsp:param name="faq4q" value="What do the EN heatmap colors mean?" />
        <jsp:param name="faq4a" value="The EN heatmap colors each atom by its Pauling electronegativity value. Blue indicates low EN (electropositive atoms like K at 0.82 Na at 0.93) white indicates middle EN (around 2.4) and red indicates high EN (electronegative atoms like O at 3.44 F at 3.98). This instantly shows where electrons are pulled in the molecule. The charge map mode uses MMFF94 partial charges from PubChem showing actual computed charge distribution." />
        <jsp:param name="faq5q" value="What is the difference between bond polarity and molecular polarity?" />
        <jsp:param name="faq5a" value="Bond polarity refers to the unequal sharing of electrons in a single bond measured by delta EN. Molecular polarity refers to the overall charge distribution of the entire molecule determined by the vector sum of all bond dipoles. A molecule can have polar bonds but still be nonpolar overall if the geometry causes dipoles to cancel. CCl4 has four polar C-Cl bonds but is nonpolar because tetrahedral symmetry cancels all dipoles." />
        <jsp:param name="faq6q" value="How do bond dipole arrows work in the 3D viewer?" />
        <jsp:param name="faq6a" value="Bond dipole arrows point from the less electronegative atom (partial positive delta plus) toward the more electronegative atom (partial negative delta minus). They appear as purple arrows on bonds with delta EN greater than or equal to 0.4. In polar molecules like H2O the arrows do not cancel showing a net dipole. In nonpolar molecules like CCl4 the arrows cancel by symmetry. You can toggle dipole arrows on and off using the Dipoles button." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/electronegativity-polarity.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        .tool-action-btn { background: var(--ep-gradient) !important; }
        .tool-badge { background: var(--ep-light); color: var(--ep-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Electronegativity &amp; Polarity Checker</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp">Chemistry Tools</a> /
                Polarity Checker
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">EN Heatmap</span>
            <span class="tool-badge">3D Viewer</span>
            <span class="tool-badge">30 Molecules</span>
            <span class="tool-badge">Dipole Arrows</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--ep-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>electronegativity &amp; molecular polarity</strong> checker with <strong>3D visualization</strong>. Enter any <strong>chemical formula</strong> or molecule name to see <strong>EN differences</strong>, bond types, and an instant <strong>POLAR / NONPOLAR verdict</strong> with reasoning. Explore <strong>EN heatmaps</strong>, <strong>partial charge maps</strong>, and <strong>bond dipole arrows</strong> on interactive 3D models.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--ep-gradient);">Polarity Analysis</div>
            <div class="tool-card-body">

                <!-- Formula Input -->
                <div class="tool-form-group">
                    <label class="ep-input-label" for="ep-formula">Chemical Formula or Name</label>
                    <input type="text" class="ep-input" id="ep-formula" placeholder="e.g., H2O, CHCl3, Ammonia">
                    <div class="ep-input-hint">Enter a formula (H2O, CCl4, SF6) or molecule name (Water, Chloroform).</div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;margin-top:0.75rem;">
                    <button type="button" class="tool-action-btn" id="ep-solve-btn" style="flex:1">Check Polarity</button>
                    <button type="button" class="tool-action-btn" id="ep-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <!-- Resource Buttons -->
                <div style="display:flex;gap:0.5rem;margin-top:0.75rem;">
                    <button type="button" class="tool-action-btn" id="ep-en-table-btn" style="flex:1;width:auto;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;background:var(--bg-secondary)!important;color:var(--text-primary);border:1px solid var(--border)">&#128202; EN Table</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="ep-examples">
                        <button type="button" class="ep-example-chip" data-formula="H2O">H&#8322;O</button>
                        <button type="button" class="ep-example-chip" data-formula="CO2">CO&#8322;</button>
                        <button type="button" class="ep-example-chip" data-formula="NH3">NH&#8323;</button>
                        <button type="button" class="ep-example-chip" data-formula="CHCl3">CHCl&#8323;</button>
                        <button type="button" class="ep-example-chip" data-formula="HF">HF</button>
                        <button type="button" class="ep-example-chip" data-formula="BF3">BF&#8323;</button>
                        <button type="button" class="ep-example-chip" data-formula="CH4">CH&#8324;</button>
                        <button type="button" class="ep-example-chip" data-formula="SO2">SO&#8322;</button>
                        <button type="button" class="ep-example-chip" data-formula="CCl4">CCl&#8324;</button>
                        <button type="button" class="ep-example-chip" data-formula="SF6">SF&#8326;</button>
                        <button type="button" class="ep-example-chip" data-formula="HCl">HCl</button>
                        <button type="button" class="ep-example-chip" data-formula="XeF4">XeF&#8324;</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="ep-output-tabs">
            <button type="button" class="ep-output-tab active" data-panel="result">Result</button>
            <button type="button" class="ep-output-tab" data-panel="database">Database</button>
            <button type="button" class="ep-output-tab" data-panel="learn">Learn</button>
        </div>

        <!-- Result Panel -->
        <div class="ep-panel active" id="ep-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ep-tool);">
                        <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/>
                    </svg>
                    <h4>Polarity Analysis</h4>
                </div>
                <div class="tool-result-content" id="ep-result-content">
                    <div class="tool-empty-state" id="ep-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#9889;</div>
                        <h3>Enter a molecule</h3>
                        <p>Check electronegativity differences and determine if a molecule is polar or nonpolar.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="ep-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="ep-download-pdf-btn" style="flex:1 1 auto;width:auto;min-width:80px;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;">&#128196; Download PDF</button>
                    <a id="ep-geometry-btn" href="#" target="_blank" class="tool-action-btn" style="flex:1 1 auto;width:auto;min-width:80px;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;text-align:center;text-decoration:none;display:none;">&#9883; VSEPR Analysis</a>
                    <button type="button" class="tool-action-btn" id="ep-share-btn" style="flex:0 0 auto;width:auto;min-width:60px;margin-top:0;font-size:0.8rem;padding:0.6rem 0.5rem;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Share</button>
                </div>
            </div>
        </div>

        <!-- Database Panel -->
        <div class="ep-panel" id="ep-panel-database">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ep-tool);">
                        <ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                    </svg>
                    <h4>Molecule Database (30)</h4>
                </div>
                <div style="padding:0.75rem;">
                    <input type="text" class="ep-search-input" id="ep-search" placeholder="Search by formula, name, polarity, or geometry...">
                    <div class="ep-table-wrap">
                        <table class="ep-table">
                            <thead>
                                <tr>
                                    <th>Formula</th>
                                    <th>Name</th>
                                    <th>Polarity</th>
                                    <th>Dipole</th>
                                    <th>Geometry</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="ep-table-body"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Learn Panel -->
        <div class="ep-panel" id="ep-panel-learn">
            <div class="tool-card" style="padding:1rem;">
                <h4 style="font-size:0.9375rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">Electronegativity &amp; Polarity Guide</h4>

                <h5 style="font-size:0.8125rem;font-weight:600;margin:0.75rem 0 0.375rem;color:var(--ep-tool);">Pauling EN Scale</h5>
                <p style="font-size:0.75rem;color:var(--text-secondary);line-height:1.6;margin:0 0 0.5rem;">Electronegativity measures an atom's ability to attract electrons in a bond. Fluorine (3.98) is the most electronegative; cesium (0.82) is the least.</p>

                <h5 style="font-size:0.8125rem;font-weight:600;margin:0.75rem 0 0.375rem;color:var(--ep-tool);">Bond Types by &#916;EN</h5>
                <div style="font-size:0.75rem;color:var(--text-secondary);line-height:1.8;">
                    <strong>&#916;EN &lt; 0.4</strong> &mdash; Nonpolar Covalent (equal sharing, e.g. C&ndash;H)<br>
                    <strong>0.4 &le; &#916;EN &lt; 1.7</strong> &mdash; Polar Covalent (unequal sharing, e.g. O&ndash;H)<br>
                    <strong>&#916;EN &ge; 1.7</strong> &mdash; Ionic (electron transfer, e.g. Na&ndash;Cl)
                </div>

                <h5 style="font-size:0.8125rem;font-weight:600;margin:0.75rem 0 0.375rem;color:var(--ep-tool);">Molecular Polarity Rules</h5>
                <p style="font-size:0.75rem;color:var(--text-secondary);line-height:1.6;margin:0 0 0.5rem;">A molecule is <strong>nonpolar</strong> if all bond dipoles cancel by symmetry (identical terminal atoms, no lone pairs, and symmetric geometry). A molecule is <strong>polar</strong> if dipoles do not cancel due to asymmetric geometry, lone pairs, or mixed substituents.</p>

                <h5 style="font-size:0.8125rem;font-weight:600;margin:0.75rem 0 0.375rem;color:var(--ep-tool);">Common Examples</h5>
                <div style="font-size:0.75rem;color:var(--text-secondary);line-height:1.8;">
                    <strong>Nonpolar:</strong> CO&#8322; (linear), CH&#8324; (tetrahedral), CCl&#8324; (tetrahedral), SF&#8326; (octahedral), BF&#8323; (trigonal planar)<br>
                    <strong>Polar:</strong> H&#8322;O (bent, 1.85 D), NH&#8323; (pyramidal, 1.47 D), HCl (linear, 1.09 D), CHCl&#8323; (tetrahedral, 1.04 D), SO&#8322; (bent, 1.63 D)
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
    <jsp:param name="currentToolUrl" value="electronegativity-polarity-checker.jsp"/>
    <jsp:param name="keyword" value="chemistry"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT IS ELECTRONEGATIVITY? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">1</span> What is Electronegativity?
        </h2>
        <p class="ep-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            <strong>Electronegativity</strong> is a measure of an atom's ability to <strong>attract shared electrons</strong> in a chemical bond. The most widely used scale is the <strong>Pauling electronegativity scale</strong>, developed by Linus Pauling in 1932. Values range from <strong>0.82</strong> (cesium, least electronegative) to <strong>3.98</strong> (fluorine, most electronegative).
        </p>
        <div class="ep-callout ep-callout-insight ep-anim ep-anim-d1">
            <span class="ep-callout-icon">&#128161;</span>
            <div class="ep-callout-text">
                <strong>Periodic trend:</strong> Electronegativity generally <em>increases</em> from left to right across a period (more protons attract electrons more strongly) and <em>decreases</em> down a group (electrons are farther from the nucleus).
            </div>
        </div>
    </div>

    <!-- ===== 2. PAULING EN SCALE ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">2</span> Pauling Electronegativity Scale
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Key elements colored by their electronegativity value (blue = low, red = high):
        </p>
        <div class="ep-en-scale ep-anim ep-anim-d1">
            <div class="ep-en-element" style="background:rgba(66,133,244,0.2);"><span class="ep-en-symbol" style="color:#4285f4;">K</span><span class="ep-en-value" style="color:#4285f4;">0.82</span></div>
            <div class="ep-en-element" style="background:rgba(66,133,244,0.15);"><span class="ep-en-symbol" style="color:#5a9cf4;">Na</span><span class="ep-en-value" style="color:#5a9cf4;">0.93</span></div>
            <div class="ep-en-element" style="background:rgba(100,160,244,0.15);"><span class="ep-en-symbol" style="color:#6aa0f4;">Li</span><span class="ep-en-value" style="color:#6aa0f4;">0.98</span></div>
            <div class="ep-en-element" style="background:rgba(200,200,240,0.15);"><span class="ep-en-symbol" style="color:#888;">H</span><span class="ep-en-value" style="color:#888;">2.20</span></div>
            <div class="ep-en-element" style="background:rgba(230,230,240,0.15);"><span class="ep-en-symbol" style="color:#666;">C</span><span class="ep-en-value" style="color:#666;">2.55</span></div>
            <div class="ep-en-element" style="background:rgba(244,130,130,0.15);"><span class="ep-en-symbol" style="color:#e04040;">N</span><span class="ep-en-value" style="color:#e04040;">3.04</span></div>
            <div class="ep-en-element" style="background:rgba(244,100,100,0.15);"><span class="ep-en-symbol" style="color:#d03030;">O</span><span class="ep-en-value" style="color:#d03030;">3.44</span></div>
            <div class="ep-en-element" style="background:rgba(244,68,68,0.2);"><span class="ep-en-symbol" style="color:#c02020;">F</span><span class="ep-en-value" style="color:#c02020;">3.98</span></div>
        </div>
    </div>

    <!-- ===== 3. BOND TYPES BY DELTA-EN ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">3</span> Bond Types by &#916;EN
        </h2>
        <div class="ep-bond-type-grid ep-anim ep-anim-d1">
            <div class="ep-bond-type-card" style="background:#ecfdf5;border-color:#a7f3d0;">
                <h4 style="color:#059669;">Nonpolar Covalent</h4>
                <div class="ep-delta" style="color:#059669;">&#916;EN &lt; 0.4</div>
                <p>Equal sharing of electrons. Example: C&ndash;H (&#916;EN = 0.35)</p>
            </div>
            <div class="ep-bond-type-card" style="background:#eef2ff;border-color:#c7d2fe;">
                <h4 style="color:#4f46e5;">Polar Covalent</h4>
                <div class="ep-delta" style="color:#4f46e5;">0.4 &le; &#916;EN &lt; 1.7</div>
                <p>Unequal sharing. Example: O&ndash;H (&#916;EN = 1.24)</p>
            </div>
            <div class="ep-bond-type-card" style="background:#fef2f2;border-color:#fecaca;">
                <h4 style="color:#dc2626;">Ionic</h4>
                <div class="ep-delta" style="color:#dc2626;">&#916;EN &ge; 1.7</div>
                <p>Electron transfer. Example: Na&ndash;Cl (&#916;EN = 2.23)</p>
            </div>
        </div>
    </div>

    <!-- ===== 4. HOW TO DETERMINE MOLECULAR POLARITY ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">4</span> How to Determine Molecular Polarity
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Follow these four steps for any molecule. This is the exact process our checker automates:
        </p>
        <div class="ep-process ep-anim ep-anim-d1">
            <div class="ep-process-step" data-step="1">
                <h4>Calculate &#916;EN for each bond</h4>
                <p>Look up Pauling EN values for both atoms and compute the absolute difference. Classify as nonpolar covalent, polar covalent, or ionic.</p>
            </div>
            <div class="ep-process-step" data-step="2">
                <h4>Determine the molecular geometry</h4>
                <p>Use VSEPR theory to find the 3D shape. Count bonding pairs and lone pairs on the central atom.</p>
            </div>
            <div class="ep-process-step" data-step="3">
                <h4>Draw bond dipole vectors</h4>
                <p>Each polar bond has a dipole vector pointing from &#948;+ to &#948;&minus;. The magnitude is proportional to &#916;EN.</p>
            </div>
            <div class="ep-process-step" data-step="4">
                <h4>Check if dipoles cancel by symmetry</h4>
                <p>If all dipoles cancel (symmetric geometry, identical terminals, no lone pairs) &rarr; <strong>Nonpolar</strong>. Otherwise &rarr; <strong>Polar</strong>.</p>
            </div>
        </div>
    </div>

    <!-- ===== 5. DIPOLE MOMENT DIRECTION ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">5</span> Dipole Moment Direction
        </h2>
        <p class="ep-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            A <strong>dipole moment</strong> is a vector quantity measured in <strong>Debye (D)</strong>. It points from the center of positive charge toward the center of negative charge. For a single bond, it points from the less electronegative atom (&#948;+) to the more electronegative atom (&#948;&minus;). The net molecular dipole moment is the <strong>vector sum</strong> of all individual bond dipoles.
        </p>
        <div class="ep-callout ep-callout-tip ep-anim ep-anim-d1">
            <span class="ep-callout-icon">&#128218;</span>
            <div class="ep-callout-text">
                <strong>Key insight:</strong> NF&#8323; has a much smaller dipole (0.23 D) than NH&#8323; (1.47 D) despite N&ndash;F bonds being more polar than N&ndash;H bonds. This is because the lone pair on nitrogen opposes the N&ndash;F bond dipoles, partially canceling them. In NH&#8323;, the lone pair reinforces the bond dipoles.
            </div>
        </div>
    </div>

    <!-- ===== 6. POLAR vs NONPOLAR EXAMPLES ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">6</span> Polar vs Nonpolar Examples
        </h2>
        <div class="ep-edu-grid ep-anim ep-anim-d1">
            <div class="ep-edu-card" style="border-left:3px solid #4f46e5;">
                <h4 style="color:#4f46e5;">Polar Molecules</h4>
                <p><strong>H&#8322;O</strong> &mdash; Bent, 1.85 D. Two lone pairs create asymmetry.<br>
                <strong>NH&#8323;</strong> &mdash; Pyramidal, 1.47 D. One lone pair, dipoles don't cancel.<br>
                <strong>HCl</strong> &mdash; Linear diatomic, 1.09 D. Single bond dipole.<br>
                <strong>CHCl&#8323;</strong> &mdash; Tetrahedral, 1.04 D. Mixed substituents.</p>
            </div>
            <div class="ep-edu-card" style="border-left:3px solid #059669;">
                <h4 style="color:#059669;">Nonpolar Molecules</h4>
                <p><strong>CO&#8322;</strong> &mdash; Linear, 0 D. Opposing C=O dipoles cancel.<br>
                <strong>CH&#8324;</strong> &mdash; Tetrahedral, 0 D. Perfect symmetry.<br>
                <strong>CCl&#8324;</strong> &mdash; Tetrahedral, 0 D. Identical C&ndash;Cl bonds.<br>
                <strong>SF&#8326;</strong> &mdash; Octahedral, 0 D. Six identical bonds cancel.</p>
            </div>
        </div>
    </div>

    <!-- ===== 7. EN HEATMAP EXPLAINED ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">7</span> Understanding the EN Heatmap
        </h2>
        <p class="ep-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            The <strong>EN Heatmap</strong> mode in the 3D viewer colors each atom by its Pauling electronegativity value using a blue&ndash;white&ndash;red gradient:
        </p>
        <div style="display:flex;align-items:center;gap:0.5rem;margin:1rem 0;flex-wrap:wrap;" class="ep-anim ep-anim-d1">
            <div style="width:3rem;height:2rem;background:#4285f4;border-radius:0.25rem;"></div>
            <span style="font-size:0.75rem;color:var(--text-secondary);">Low EN (K: 0.82)</span>
            <div style="width:3rem;height:2rem;background:#ffffff;border:1px solid var(--border);border-radius:0.25rem;"></div>
            <span style="font-size:0.75rem;color:var(--text-secondary);">Mid EN (~2.4)</span>
            <div style="width:3rem;height:2rem;background:#ff4444;border-radius:0.25rem;"></div>
            <span style="font-size:0.75rem;color:var(--text-secondary);">High EN (F: 3.98)</span>
        </div>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;">
            The <strong>Charge Map</strong> mode uses <strong>MMFF94 partial charges</strong> computed by PubChem. Red atoms carry partial negative charge (&#948;&minus;, electron-rich), blue atoms carry partial positive charge (&#948;+, electron-poor). This shows the actual computed charge distribution, which can differ from simple EN predictions due to resonance and inductive effects.
        </p>
    </div>

    <!-- ===== 8. REAL-WORLD APPLICATIONS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="ep-section-num">8</span> Real-World Applications
        </h2>
        <div class="ep-edu-grid ep-anim ep-anim-d1">
            <div class="ep-edu-card">
                <h4>Boiling Points</h4>
                <p>Polar molecules have stronger intermolecular forces (dipole-dipole, hydrogen bonding), leading to higher boiling points. Water (100&deg;C) vs methane (&minus;161&deg;C).</p>
            </div>
            <div class="ep-edu-card">
                <h4>Solubility</h4>
                <p>"Like dissolves like" &mdash; polar solvents dissolve polar solutes. NaCl dissolves in water but not in hexane. Oil (nonpolar) doesn't mix with water (polar).</p>
            </div>
            <div class="ep-edu-card">
                <h4>Chemical Reactivity</h4>
                <p>Bond polarity determines reaction sites. Nucleophiles attack &#948;+ carbon in carbonyl groups. Electrophiles attack &#948;&minus; oxygen or nitrogen lone pairs.</p>
            </div>
            <div class="ep-edu-card">
                <h4>Biological Systems</h4>
                <p>Cell membranes use nonpolar lipid tails and polar head groups. Drug design requires matching polarity to cross membranes or dissolve in blood.</p>
            </div>
        </div>
    </div>

</section>

<!-- FAQ Section -->
<section class="faq-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:2rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you determine if a molecule is polar or nonpolar?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">First calculate the electronegativity difference (&#916;EN) for each bond. If &#916;EN &lt; 0.4, the bond is nonpolar covalent. Between 0.4 and 1.7 is polar covalent. Above 1.7 is ionic. Then check the molecular geometry: if it's symmetric with identical bonds and no lone pairs (like CO&#8322;, CH&#8324;, SF&#8326;), dipoles cancel &mdash; nonpolar. If there are lone pairs or mixed substituents, dipoles usually don't cancel &mdash; polar.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Pauling electronegativity scale?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Pauling scale measures an atom's ability to attract electrons in a bond, developed by Linus Pauling in 1932. Values range from 0.82 (cesium) to 3.98 (fluorine). EN generally increases left to right across a period and decreases down a group.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Why is CO&#8322; nonpolar even though C&ndash;O bonds are polar?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">CO&#8322; has two polar C=O bonds (&#916;EN = 0.89), but it's linear (180&deg;), so the two dipoles point in opposite directions and cancel. The net dipole is zero, making CO&#8322; nonpolar. This shows that polarity depends on both bond polarity AND geometry.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What do the EN heatmap colors mean in the 3D viewer?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Blue = low EN (electropositive, like K at 0.82), white = middle EN (~2.4), red = high EN (electronegative, like F at 3.98). This instantly shows where electrons are attracted. The charge map mode uses MMFF94 partial charges from PubChem for computed charge distribution.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between bond polarity and molecular polarity?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Bond polarity is the unequal electron sharing in one bond (measured by &#916;EN). Molecular polarity is the overall charge distribution, determined by the vector sum of all bond dipoles. A molecule can have polar bonds but be nonpolar overall if dipoles cancel by symmetry (e.g., CCl&#8324;).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this electronegativity and polarity checker free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, 100% free with no signup. Features include polarity analysis with reasoning, bond EN table, interactive 3D models with EN heatmap and charge map modes, bond dipole arrows, 30-molecule database, step-by-step analysis, PDF export, and shareable URLs. All computation runs in your browser.</div>
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
            <a href="<%=request.getContextPath()%>/molecular-geometry-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;">&#9883;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">3D Molecular Geometry</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">VSEPR shapes with interactive 3D models</p>
                </div>
            </a>
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
        </div>
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
    var els = document.querySelectorAll('.ep-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        els.forEach(function(el){ el.classList.add('ep-visible'); });
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        entries.forEach(function(e){
            if (e.isIntersecting) {
                e.target.classList.add('ep-visible');
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
<script src="<%=request.getContextPath()%>/js/electronegativity-polarity-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/electronegativity-polarity-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
