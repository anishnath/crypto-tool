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

    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Optical Designer &amp; Ray Tracing Tool" />
        <jsp:param name="toolDescription" value="Free online lens design tool with real-time ray tracing. Build achromatic doublets, Cooke triplets, and Petzval lenses. Spot diagrams, ABCD matrix, chromatic aberration analysis. No signup." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="physics/optical-designer.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="physics" />
        <jsp:param name="toolKeywords" value="optical designer, lens design tool, free ray tracing software, online lens design, optics calculator, spot diagram tool, ABCD matrix calculator, Sellmeier equation calculator, achromatic doublet design, Cooke triplet designer, Petzval lens calculator, chromatic aberration calculator, focal length calculator, optical engineering tool, aspherical lens design, refractive index calculator, lens aberration analysis, optical system simulator" />
        <jsp:param name="toolImage" value="optical-designer.svg" />
        <jsp:param name="toolFeatures" value="Multi-surface sequential ray tracing,Sellmeier refractive index for 15+ materials,ABCD paraxial matrix analysis,Spot diagram with RMS and Airy disk,Ray aberration plots,Chromatic aberration analysis,6 preset designs (singlet to 13-surface),Conic surfaces (sphere parabola hyperbola ellipse),Autofocus (paraxial and marginal),JSON import/export and PNG export,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose a preset or build from scratch|Select a preset like Achromatic Doublet or Cooke Triplet to start with or add surfaces manually,Edit the surface table|Set radius of curvature aperture thickness material and conic constant for each surface in the interactive table,Adjust environment|Set beam radius field of view wavelengths and autofocus mode to match your design requirements,Analyze results|Switch between cross-section spot diagram ray aberration and chromatic views to evaluate your design" />
        <jsp:param name="educationalLevel" value="Undergraduate, Graduate, Professional" />
        <jsp:param name="teaches" value="Optical design, sequential ray tracing, Sellmeier equation, ABCD matrix, chromatic aberration, spot diagrams, conic sections in optics" />
        <jsp:param name="faq1q" value="How do I design a lens system online for free?" />
        <jsp:param name="faq1a" value="Use this Optical Designer tool: choose a preset (achromatic doublet, Cooke triplet, Petzval lens) or add surfaces manually. Set radius, aperture, thickness, and glass material for each surface. The tool instantly traces rays and shows focal length, spot diagram, and aberrations. No download or signup needed." />
        <jsp:param name="faq2q" value="What is ray tracing in optics and how does this tool do it?" />
        <jsp:param name="faq2a" value="Ray tracing follows light rays surface-by-surface through lenses using Snell's law. This tool uses sequential ray tracing with exact ray-conic intersection math, supporting spheres, parabolas, and aspherical surfaces. It traces up to 13 surfaces in real time, showing 2D cross-section diagrams, spot diagrams, and ray aberration plots." />
        <jsp:param name="faq3q" value="How do I calculate focal length of a multi-element lens?" />
        <jsp:param name="faq3a" value="This tool calculates focal length automatically using the ABCD ray transfer matrix method. Each surface contributes a refraction matrix and each air gap a transfer matrix. The system focal length equals 1 divided by the B element of the combined matrix. Results update in real time as you edit surface parameters." />
        <jsp:param name="faq4q" value="What is chromatic aberration and how do I reduce it?" />
        <jsp:param name="faq4a" value="Chromatic aberration occurs because glass bends different wavelengths by different amounts, causing color fringing. To reduce it, pair a low-dispersion crown glass (N-BK7) with a high-dispersion flint glass (N-SF2) in an achromatic doublet. This tool shows chromatic aberration at three wavelengths and includes a preset achromatic doublet design." />
        <jsp:param name="faq5q" value="What is a spot diagram and how do I read one?" />
        <jsp:param name="faq5a" value="A spot diagram shows where rays from a point source land on the image plane. A tight cluster means low aberration. The RMS spot radius measures the spread. If the RMS is smaller than the Airy disk (1.22 times wavelength times f-number), the lens is diffraction-limited — the best possible performance. Switch to Spot Diagram view in this tool to see yours." />
        <jsp:param name="faq6q" value="What glass materials are available in this optical designer?" />
        <jsp:param name="faq6a" value="This tool includes 15+ optical materials with Sellmeier dispersion data: Schott glasses (N-BK7, N-SF11, N-SF2, F2, N-FK51A, N-LAK9), fused silica, crystals (CaF2, BaF2, MgF2, sapphire, diamond), and plastics (PMMA, polycarbonate). Each material uses the 3-term Sellmeier equation for accurate wavelength-dependent refractive index calculation." />
        <jsp:param name="faq7q" value="Is this optical designer free to use for students and engineers?" />
        <jsp:param name="faq7a" value="Yes, completely free with no signup or download required. It runs entirely in your browser. Students can learn lens design with presets and step-by-step ray tracing. Engineers can prototype multi-element systems, analyze aberrations, and export designs as JSON or PNG. Suitable for undergraduate optics courses through professional optical engineering." />
        <jsp:param name="faq8q" value="How does this compare to Zemax or Oslo for lens design?" />
        <jsp:param name="faq8a" value="This is a free browser-based alternative for sequential ray tracing fundamentals. It covers Sellmeier materials, conic surfaces, spot diagrams, ABCD matrix, and chromatic analysis — ideal for learning, quick prototyping, and homework. Professional tools like Zemax add tolerancing, MTF, coating design, and non-sequential tracing for production work." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/optical-designer.css?v=<%=cacheVersion%>">

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<!-- ===== H1 ===== -->
<h1 style="font-size:1.25rem;font-weight:700;text-align:center;margin:0;padding:4.5rem 0 0.25rem;color:var(--text-primary);">Free Online Optical Designer &amp; Ray Tracing Simulator</h1>
<p style="text-align:center;font-size:0.8125rem;color:var(--text-secondary);margin:0 auto 0.75rem;max-width:680px;">Design multi-element lens systems with real-time sequential ray tracing, 15+ Sellmeier glass materials, spot diagrams, ABCD matrix analysis, and chromatic aberration evaluation. No signup required.</p>

<%@ include file="../modern/ads/ad-hero-banner.jsp" %>

<!-- ===== 3-COLUMN LAYOUT ===== -->
<div class="tool-page-container od-layout">

    <!-- ===== INPUT COLUMN ===== -->
    <div class="tool-column-input" style="position:sticky;top:70px;align-self:start;max-height:calc(100vh - 80px);overflow-y:auto;">
        <div class="tool-card">
            <div class="tool-card-header">Optical System</div>
            <div class="tool-card-body">

                <!-- Preset + Actions -->
                <div class="od-toolbar">
                    <select id="od-preset-select" class="od-select" style="flex:1;">
                        <option value="">-- Load Preset --</option>
                        <option value="Plano-Convex Singlet">Plano-Convex Singlet</option>
                        <option value="Symmetric Biconvex">Symmetric Biconvex</option>
                        <option value="Achromatic Doublet" selected>Achromatic Doublet</option>
                        <option value="Cooke Triplet">Cooke Triplet</option>
                        <option value="Petzval Lens">Petzval Lens</option>
                        <option value="Plastic Camera Lens">Plastic Camera (13 surf)</option>
                    </select>
                </div>
                <div class="od-toolbar">
                    <button class="od-toolbar-btn od-toolbar-btn-primary" id="od-add-surface" title="Add surface after selection">+ Add</button>
                    <button class="od-toolbar-btn od-toolbar-btn-danger" id="od-remove-surface" title="Remove selected surface">- Remove</button>
                    <div style="flex:1;"></div>
                    <button class="od-toolbar-btn" id="od-export-json" title="Save design as JSON">Export</button>
                    <button class="od-toolbar-btn" id="od-import-json" title="Load design from JSON">Import</button>
                    <input type="file" id="od-import-file" class="od-hidden" accept=".json">
                </div>

                <!-- Surface Table -->
                <div class="od-table-wrap">
                    <table class="od-table" id="od-surface-table">
                        <thead>
                            <tr>
                                <th class="od-th">#</th>
                                <th class="od-th">R (mm)</th>
                                <th class="od-th">Aper</th>
                                <th class="od-th">Thick</th>
                                <th class="od-th">Material</th>
                                <th class="od-th">K</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

                <hr class="od-divider">

                <!-- Environment Controls -->
                <div class="tool-card-header" style="padding:0 0 0.25rem;border:none;font-size:0.6875rem;">Environment</div>

                <div class="od-env-grid">
                    <label class="od-env-lbl">Beam R</label>
                    <input class="od-input od-env-inp" id="od-beam-radius" type="number" step="0.5" min="0.1">
                    <label class="od-env-lbl">Rays</label>
                    <input class="od-input od-env-inp" id="od-rays-per-beam" type="number" step="2" min="3" max="51">
                    <label class="od-env-lbl">FOV &deg;</label>
                    <input class="od-input od-env-inp" id="od-fov-angle" type="number" step="1" min="0" max="90">
                    <label class="od-env-lbl">Obj D</label>
                    <input class="od-input od-env-inp" id="od-object-dist" type="text" value="Inf" title="Object distance in mm (Inf = collimated)">
                    <label class="od-env-lbl">Img R</label>
                    <input class="od-input od-env-inp" id="od-image-radius" type="number" step="1" min="1">
                    <label class="od-env-lbl">&lambda;c</label>
                    <input class="od-input od-env-inp" id="od-wl-center" type="number" step="0.01" min="0.3" max="2">
                    <label class="od-env-lbl">&lambda;s</label>
                    <input class="od-input od-env-inp" id="od-wl-short" type="number" step="0.01" min="0.3" max="2">
                    <label class="od-env-lbl">&lambda;l</label>
                    <input class="od-input od-env-inp" id="od-wl-long" type="number" step="0.01" min="0.3" max="2">
                    <label class="od-env-lbl">Focus</label>
                    <select class="od-select od-env-inp" id="od-autofocus">
                        <option value="off">Off</option>
                        <option value="paraxial">Paraxial</option>
                        <option value="marginal">Marginal</option>
                    </select>
                </div>
                <div style="margin-top:0.3rem;">
                    <label class="od-toggle-row">
                        <input type="checkbox" id="od-sym-beams">
                        Symmetric Beams
                    </label>
                </div>

            </div>
        </div>
    </div>

    <!-- ===== OUTPUT COLUMN ===== -->
    <div class="tool-column-output">

        <!-- Canvas -->
        <div class="tool-card">
            <div class="tool-card-body" style="padding:0;">
                <div class="od-canvas-wrap">
                    <div class="od-canvas-toolbar">
                        <select id="od-view-select" class="od-select">
                            <option value="cross-section">2D Cross Section</option>
                            <option value="spot">Spot Diagram</option>
                            <option value="aberration">Ray Aberration</option>
                            <option value="chromatic">Chromatic Aberration</option>
                        </select>
                        <div style="flex:1;"></div>
                        <button class="od-toolbar-btn" id="od-export-svg" title="Download as SVG">SVG</button>
                        <button class="od-toolbar-btn" id="od-export-png" title="Download as PNG">PNG</button>
                        <button class="od-toolbar-btn" id="od-share-btn" title="Share design URL">Share</button>
                    </div>
                    <canvas id="od-canvas"></canvas>
                </div>
            </div>
        </div>

        <!-- Metrics -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-card-header">System Metrics</div>
            <div class="tool-card-body">
                <div class="od-metrics-grid">
                    <div class="od-metric-card">
                        <div class="od-metric-label">Focal Length</div>
                        <div class="od-metric-value" id="od-metric-fl">—</div>
                    </div>
                    <div class="od-metric-card">
                        <div class="od-metric-label">f-Number</div>
                        <div class="od-metric-value" id="od-metric-fnum">—</div>
                    </div>
                    <div class="od-metric-card">
                        <div class="od-metric-label">NA</div>
                        <div class="od-metric-value" id="od-metric-na">—</div>
                    </div>
                    <div class="od-metric-card">
                        <div class="od-metric-label">Total Length</div>
                        <div class="od-metric-value" id="od-metric-len">—</div>
                    </div>
                    <div class="od-metric-card">
                        <div class="od-metric-label">Power</div>
                        <div class="od-metric-value" id="od-metric-power">—</div>
                    </div>
                </div>

                <!-- Chromatic table (shown when chromatic view active) -->
                <div id="od-chrom-container" class="od-chrom-wrap"></div>
            </div>
        </div>

        <!-- Educational Content -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-card-header">Optical Design Concepts</div>
            <div class="tool-card-body">
                <div class="od-edu-grid">
                    <div class="od-edu-card">
                        <h4>Sequential Ray Tracing</h4>
                        <p>Rays are traced surface-by-surface using the exact ray-conic intersection equation. At each interface, Snell's law in vector form computes the refracted direction. This handles spherical, parabolic, hyperbolic, and elliptical surfaces via the conic constant K.</p>
                    </div>
                    <div class="od-edu-card">
                        <h4>Sellmeier Equation</h4>
                        <p>Refractive index varies with wavelength: n&sup2;(&lambda;) = 1 + &Sigma; B<sub>i</sub>&lambda;&sup2; / (&lambda;&sup2; &minus; C<sub>i</sub>). Each glass type (N-BK7, N-SF11, F2, etc.) has unique B,C coefficients from measured dispersion curves. This is essential for chromatic aberration analysis.</p>
                    </div>
                    <div class="od-edu-card">
                        <h4>ABCD Matrix Method</h4>
                        <p>The system matrix multiplies refraction and transfer matrices for each surface. The equivalent focal length is 1/B where B is the top-right element. This paraxial approximation gives quick focal length, principal planes, and the condition for imaging.</p>
                    </div>
                    <div class="od-edu-card">
                        <h4>Spot Diagram &amp; Aberrations</h4>
                        <p>A grid of rays across the entrance pupil is traced to the image plane. The scatter pattern reveals aberration types: spherical (symmetric ring), coma (comet tail), astigmatism (two line foci). RMS spot size compared to the Airy disk indicates diffraction-limited performance.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sign Convention Reference -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-card-header">Sign Convention &amp; Surface Properties</div>
            <div class="tool-card-body">
                <div class="od-edu-grid">
                    <div class="od-edu-card">
                        <h4>Radius of Curvature (R)</h4>
                        <p><strong>R &gt; 0</strong>: Center of curvature to the right (convex to incoming light).<br>
                        <strong>R &lt; 0</strong>: Center of curvature to the left (concave).<br>
                        <strong>R = Inf</strong>: Flat (plane) surface.<br>
                        Measured in millimeters.</p>
                    </div>
                    <div class="od-edu-card">
                        <h4>Conic Constant (K)</h4>
                        <p><strong>K = 0</strong>: Sphere<br>
                        <strong>K = &minus;1</strong>: Paraboloid<br>
                        <strong>K &lt; &minus;1</strong>: Hyperboloid<br>
                        <strong>&minus;1 &lt; K &lt; 0</strong>: Prolate ellipsoid<br>
                        <strong>K &gt; 0</strong>: Oblate ellipsoid</p>
                    </div>
                    <div class="od-edu-card">
                        <h4>Thickness</h4>
                        <p>Axial distance from this surface vertex to the next surface vertex (mm). The last surface's thickness is the back focal distance — the gap from the last surface to the image plane. Autofocus adjusts this automatically.</p>
                    </div>
                    <div class="od-edu-card">
                        <h4>Material</h4>
                        <p>The medium <em>after</em> this surface. Set to a glass type (N-BK7, F2, etc.) for the first surface of a lens element, then Air for the last surface of that element. This defines which medium the refraction goes into.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- FAQ Section (visible, indexable content for SEO + dwell time) -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-card-header">Frequently Asked Questions</div>
            <div class="tool-card-body">
                <div class="od-faq-list">
                    <details class="od-faq-item">
                        <summary class="od-faq-q">How do I design a lens system online for free?</summary>
                        <p class="od-faq-a">Use this Optical Designer: choose a preset (achromatic doublet, Cooke triplet, Petzval lens) or add surfaces manually. Set radius, aperture, thickness, and glass material for each surface. The tool instantly traces rays and shows focal length, spot diagram, and aberrations. No download or signup needed.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">What is ray tracing in optics and how does this tool do it?</summary>
                        <p class="od-faq-a">Ray tracing follows light rays surface-by-surface through lenses using Snell's law. This tool uses sequential ray tracing with exact ray-conic intersection math, supporting spheres, parabolas, and aspherical surfaces. It traces up to 13 surfaces in real time, showing 2D cross-section diagrams, spot diagrams, and ray aberration plots.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">How do I calculate focal length of a multi-element lens?</summary>
                        <p class="od-faq-a">This tool calculates focal length automatically using the ABCD ray transfer matrix method. Each surface contributes a refraction matrix and each air gap a transfer matrix. The system focal length equals 1/B of the combined matrix. Results update in real time as you edit surface parameters.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">What is chromatic aberration and how do I reduce it?</summary>
                        <p class="od-faq-a">Chromatic aberration occurs because glass bends different wavelengths by different amounts, causing color fringing. Pair a low-dispersion crown glass (N-BK7) with a high-dispersion flint glass (N-SF2) in an achromatic doublet. Switch to the Chromatic Aberration view to see EFL at three wavelengths and axial CA.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">What is a spot diagram and how do I read one?</summary>
                        <p class="od-faq-a">A spot diagram shows where rays from a point source land on the image plane. A tight cluster means low aberration. The RMS spot radius measures the spread. If RMS is smaller than the Airy disk (1.22 &times; &lambda; &times; f/#), the lens is diffraction-limited. Switch to Spot Diagram view to analyze your design.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">What glass materials are available?</summary>
                        <p class="od-faq-a">15+ optical materials with Sellmeier dispersion: Schott glasses (N-BK7, N-SF11, N-SF2, F2, N-FK51A, N-LAK9), fused silica, crystals (CaF&#8322;, BaF&#8322;, MgF&#8322;, sapphire, diamond), and plastics (PMMA, polycarbonate). Each uses the 3-term Sellmeier equation for accurate wavelength-dependent refractive index.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">Is this free for students and engineers?</summary>
                        <p class="od-faq-a">Yes, completely free with no signup. Runs entirely in your browser. Students can learn lens design with presets. Engineers can prototype systems, analyze aberrations, and export as JSON or PNG. Covers undergraduate optics through professional engineering.</p>
                    </details>
                    <details class="od-faq-item">
                        <summary class="od-faq-q">How does this compare to Zemax or Oslo?</summary>
                        <p class="od-faq-a">This is a free browser-based alternative for sequential ray tracing fundamentals: Sellmeier materials, conic surfaces, spot diagrams, ABCD matrix, chromatic analysis. Ideal for learning and quick prototyping. Zemax/Oslo add tolerancing, MTF, coating design, and non-sequential tracing for production work.</p>
                    </details>
                </div>
            </div>
        </div>

        <!-- Related Tools -->
        <div class="tool-card" style="margin-top:1rem;">
            <div class="tool-card-header">Related Tools</div>
            <div class="tool-card-body">
                <div class="od-edu-grid">
                    <a href="<%=request.getContextPath()%>/physics/lens-calculator.jsp" style="text-decoration:none;">
                        <div class="od-edu-card" style="cursor:pointer;transition:border-color 0.15s;">
                            <h4>Lens Maker Calculator</h4>
                            <p>Single lens focal length from R1, R2, and refractive index. Combined and double lens systems.</p>
                        </div>
                    </a>
                    <a href="<%=request.getContextPath()%>/lens-mirror-calculator.jsp" style="text-decoration:none;">
                        <div class="od-edu-card" style="cursor:pointer;transition:border-color 0.15s;">
                            <h4>Lens &amp; Mirror Calculator</h4>
                            <p>Thin lens / mirror equation solver with interactive ray diagrams for 7 optical element types.</p>
                        </div>
                    </a>
                    <a href="<%=request.getContextPath()%>/physics/refraction.jsp" style="text-decoration:none;">
                        <div class="od-edu-card" style="cursor:pointer;transition:border-color 0.15s;">
                            <h4>Snell's Law &amp; Prism</h4>
                            <p>Refraction calculator with Snell's law, critical angle, prism deviation, and interactive diagrams.</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== ADS COLUMN ===== -->
    <div class="tool-ads-column" style="height:auto;align-self:start;position:sticky;top:70px;">
        <jsp:include page="../modern/ads/ad-in-content-mid.jsp" />
    </div>
</div>

<!-- ===== FOOTER ===== -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>
<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>

<!-- ===== SCRIPTS ===== -->
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/optical-designer-model.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/optical-designer-trace.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/optical-designer-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/optical-designer-ui.js?v=<%=cacheVersion%>"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    ODUI.init({
        canvasId: 'od-canvas',
        tableId: 'od-surface-table'
    });

    var canvas = document.getElementById('od-canvas');
    var TU = window.ToolUtils;

    /* ---- Download PNG via ToolUtils ---- */
    var pngBtn = document.getElementById('od-export-png');
    if (pngBtn && TU) {
        pngBtn.addEventListener('click', function () {
            TU.downloadCanvasAsImage(canvas, 'optical-design.png', {
                toolName: 'Optical Designer',
                showToast: true,
                showSupportPopup: true
            });
        });
    }

    /* ---- Download SVG ---- */
    var svgBtn = document.getElementById('od-export-svg');
    if (svgBtn) {
        svgBtn.addEventListener('click', function () {
            var w = canvas.width, h = canvas.height;
            var dpr = window.devicePixelRatio || 1;
            var cw = Math.round(w / dpr), ch = Math.round(h / dpr);
            var dataUrl = canvas.toDataURL('image/png');
            var svg = '<svg xmlns="http://www.w3.org/2000/svg" width="' + cw + '" height="' + ch + '">' +
                '<image href="' + dataUrl + '" width="' + cw + '" height="' + ch + '"/>' +
                '<text x="' + (cw - 6) + '" y="' + (ch - 6) + '" text-anchor="end" font-size="10" fill="rgba(0,0,0,0.35)" font-family="sans-serif">8gwifi.org</text>' +
                '</svg>';
            if (TU) {
                TU.downloadAsFile(svg, 'optical-design.svg', {
                    toolName: 'Optical Designer',
                    showToast: true,
                    showSupportPopup: true
                });
            } else {
                var blob = new Blob([svg], { type: 'image/svg+xml' });
                var a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = 'optical-design.svg';
                a.click();
                URL.revokeObjectURL(a.href);
            }
        });
    }

    /* ---- Share design URL ---- */
    var shareBtn = document.getElementById('od-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function () {
            var design = ODUI.getDesign();
            if (!design) return;
            var json = design.toJSON();
            if (TU) {
                TU.shareResult(json, {
                    paramName: 'design',
                    encode: true,
                    copyToClipboard: true,
                    showSupportPopup: true,
                    toolName: 'Optical Designer'
                });
            }
        });
    }

    /* ---- Load shared design from URL ---- */
    if (TU && TU.loadSharedResult) {
        var shared = TU.loadSharedResult('design');
        if (shared) {
            try {
                var d = ODModel.Design.fromJSON(shared);
                // Overwrite with shared design
                ODUI.getDesign && (function () {
                    var current = ODUI.getDesign();
                    current.surfaces = d.surfaces;
                    current.beamRadius = d.beamRadius;
                    current.raysPerBeam = d.raysPerBeam;
                    current.fovAngle = d.fovAngle;
                    current.symBeams = d.symBeams;
                    current.wavelengthCenter = d.wavelengthCenter;
                    current.wavelengthShort = d.wavelengthShort;
                    current.wavelengthLong = d.wavelengthLong;
                    current.imageRadius = d.imageRadius;
                    current.autofocus = d.autofocus;
                    current.objectDistance = d.objectDistance;
                    ODUI.refreshAll();
                })();
            } catch (e) {
                console.warn('Invalid shared design:', e);
            }
        }
    }
});
</script>

<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
