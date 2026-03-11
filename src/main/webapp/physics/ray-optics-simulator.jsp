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
        <jsp:param name="toolName" value="Free Ray Optics Simulator &amp; 2D Ray Tracing Tool" />
        <jsp:param name="toolDescription" value="Free online 2D ray optics simulator with real-time ray tracing. Build optical scenes with mirrors, lenses, prisms, beam splitters, diffraction gratings, and GRIN media. Snell's law, Fresnel equations, dispersion, and total internal reflection. No signup." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="physics/ray-optics-simulator.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="physics" />
        <jsp:param name="toolKeywords" value="ray optics simulator, 2D ray tracing, online optics tool, mirror simulator, lens simulator, prism rainbow, Snell's law calculator, Fresnel equations, total internal reflection, beam splitter, diffraction grating, GRIN lens, optical bench, light simulator, refraction simulator, reflection simulator" />
        <jsp:param name="toolImage" value="ray-optics-simulator.svg" />
        <jsp:param name="toolFeatures" value="Freeform 2D ray tracing with drag-and-drop objects,19 optical elements: mirrors lenses prisms beam splitters gratings,Snell's law refraction with total internal reflection,Fresnel partial reflection for realistic beam splitting,Cauchy dispersion for rainbow and chromatic effects,Diffraction grating with multiple orders,GRIN gradient-index media simulation,Extended ray and image point detection,Pan zoom and rotate with mouse or touch,22 built-in presets including telescope microscope prism rainbow retroreflector and camera obscura,Dark mode support,Export as PNG" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose a preset or start blank|Select from 22 presets like Prism Rainbow Telescope Microscope Retroreflector or Camera Obscura or build from scratch,Add optical elements|Use the Add dropdown to place mirrors lenses prisms beam splitters gratings blockers and light sources,Arrange the scene|Drag objects to position them and rotate by dragging the rotation handle. Edit properties in the bar below the canvas,Adjust settings|Toggle Fresnel reflections enable the grid change ray mode to see extended rays and image points,Analyze and export|Pan and zoom to explore your optical system then export as PNG to save your design" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="Geometric optics, reflection, refraction, Snell's law, total internal reflection, Fresnel equations, dispersion, diffraction, beam splitting, gradient-index optics" />
        <jsp:param name="faq1q" value="How do I simulate ray optics online for free?" />
        <jsp:param name="faq1a" value="Use this Ray Optics Simulator: choose a preset or add optical elements (mirrors, lenses, prisms, beam splitters) from the toolbar. Drag objects to position them and the simulator traces rays in real time using Snell's law. No download or signup needed." />
        <jsp:param name="faq2q" value="What is Snell's law and how does this simulator use it?" />
        <jsp:param name="faq2a" value="Snell's law states n1 sin(theta1) = n2 sin(theta2) where n1 and n2 are refractive indices of two media. This simulator applies Snell's law at every ray-surface intersection to compute the refracted ray direction. When sin(theta2) would exceed 1, total internal reflection occurs automatically." />
        <jsp:param name="faq3q" value="What are Fresnel equations and why do they matter?" />
        <jsp:param name="faq3a" value="Fresnel equations calculate how much light is reflected vs transmitted at an interface. At steep angles more light reflects. This simulator optionally applies Fresnel reflectance to split rays into reflected and transmitted components with correct brightness ratios, giving realistic beam splitting behavior." />
        <jsp:param name="faq4q" value="How does a prism create a rainbow?" />
        <jsp:param name="faq4a" value="Different wavelengths of light bend by different amounts (dispersion). Red light bends less than violet. When white light enters a prism, Snell's law applied with wavelength-dependent refractive index (Cauchy equation) separates the colors. Load the Prism Rainbow preset to see this in action." />
        <jsp:param name="faq5q" value="What optical elements are available in this simulator?" />
        <jsp:param name="faq5a" value="19 elements: light sources (point source, parallel beam, single ray), mirrors (flat, curved, parabolic, ideal), refractive elements (glass slab, prism, circle lens, spherical lens, ideal lens), beam splitter with dichroic option, diffraction grating, GRIN lens, and blockers (flat, aperture, circle). Each has editable properties." />
        <jsp:param name="faq6q" value="What is total internal reflection (TIR)?" />
        <jsp:param name="faq6a" value="TIR occurs when light travels from a denser medium (like glass, n=1.5) to a less dense medium (like air, n=1) at an angle greater than the critical angle. The critical angle is arcsin(n2/n1). Beyond this angle, 100% of light reflects back. The simulator shows TIR automatically with prisms and glass slabs." />
        <jsp:param name="faq7q" value="Can I simulate a telescope or other optical instruments?" />
        <jsp:param name="faq7a" value="Yes. Load the Telescope preset which uses two ideal lenses to form a simple refracting telescope. You can also build compound instruments by placing multiple lenses, mirrors, and apertures. Drag and adjust focal lengths and positions to see how the optical system behaves." />
        <jsp:param name="faq8q" value="Is this simulator free for students and teachers?" />
        <jsp:param name="faq8a" value="Yes, completely free with no signup. Runs entirely in your browser. Ideal for physics courses covering geometric optics, Snell's law, mirrors, lenses, and prisms. Students can experiment with presets and build custom scenes. Teachers can use the PNG export for presentations and worksheets." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ray-optics-simulator.css?v=<%=cacheVersion%>">

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<!-- ===== H1 ===== -->
<h1 style="font-size:1.25rem;font-weight:700;text-align:center;margin:0;padding:4.5rem 0 0.25rem;color:var(--text-primary);">Free Online Ray Optics Simulator &amp; 2D Ray Tracing Tool</h1>
<p style="text-align:center;font-size:0.8125rem;color:var(--text-secondary);margin:0 auto 0.75rem;max-width:680px;">Build optical scenes with mirrors, lenses, prisms, beam splitters, and gratings. Real-time ray tracing with Snell's law, Fresnel reflections, dispersion, and total internal reflection. No signup required.</p>

<%@ include file="../modern/ads/ad-hero-banner.jsp" %>

<!-- ===== TWO-COLUMN LAYOUT ===== -->
<div class="rs-layout">

    <!-- ===== MAIN COLUMN ===== -->
    <div class="rs-main">

        <!-- Canvas Card -->
        <div class="rs-canvas-card">

            <!-- Toolbar -->
            <div class="rs-toolbar">
                <select id="rs-preset-select" class="rs-select">
                    <option value="">-- Preset --</option>
                    <optgroup label="Basic">
                        <option value="Empty Scene">Empty Scene</option>
                        <option value="Plane Mirror">Plane Mirror</option>
                        <option value="Concave Mirror">Concave Mirror</option>
                        <option value="Convex Lens">Convex Lens</option>
                        <option value="Spherical Lens">Spherical Lens</option>
                    </optgroup>
                    <optgroup label="Classic Optics">
                        <option value="Prism Rainbow">Prism Rainbow</option>
                        <option value="Total Internal Reflection">Total Internal Reflection</option>
                        <option value="Rainbow (Dispersion)">Rainbow (Dispersion)</option>
                        <option value="Parabolic Dish">Parabolic Dish</option>
                        <option value="Concave + Convex Mirrors">Concave + Convex</option>
                    </optgroup>
                    <optgroup label="Instruments">
                        <option value="Telescope">Telescope</option>
                        <option value="Compound Microscope">Compound Microscope</option>
                        <option value="Periscope">Periscope</option>
                        <option value="Camera Obscura">Camera Obscura</option>
                    </optgroup>
                    <optgroup label="Patterns">
                        <option value="Retroreflector">Retroreflector</option>
                        <option value="Kaleidoscope">Kaleidoscope</option>
                        <option value="Optical Cavity">Optical Cavity</option>
                        <option value="Fiber Optic">Fiber Optic</option>
                        <option value="Two-Way Mirror">Two-Way Mirror</option>
                    </optgroup>
                    <optgroup label="Advanced">
                        <option value="Beam Splitter">Beam Splitter</option>
                        <option value="Diffraction Grating">Diffraction Grating</option>
                        <option value="Fresnel Lens">Fresnel Lens</option>
                        <option value="GRIN Lens Focus">GRIN Lens Focus</option>
                    </optgroup>
                </select>

                <div class="rs-toolbar-sep"></div>

                <select id="rs-add-select" class="rs-select">
                    <option value="">+ Add...</option>
                    <optgroup label="Sources">
                        <option value="PointSource">Point Source</option>
                        <option value="ParallelBeam">Parallel Beam</option>
                        <option value="SingleRay">Single Ray</option>
                    </optgroup>
                    <optgroup label="Mirrors">
                        <option value="FlatMirror">Flat Mirror</option>
                        <option value="CurvedMirror">Curved Mirror</option>
                        <option value="ParabolicMirror">Parabolic Mirror</option>
                        <option value="IdealMirror">Ideal Mirror</option>
                    </optgroup>
                    <optgroup label="Refractors">
                        <option value="GlassSlab">Glass Slab</option>
                        <option value="Prism">Prism</option>
                        <option value="CircleLens">Circle Lens</option>
                        <option value="SphericalLens">Spherical Lens</option>
                        <option value="IdealLens">Ideal Lens</option>
                    </optgroup>
                    <optgroup label="Special">
                        <option value="BeamSplitter">Beam Splitter</option>
                        <option value="DiffractionGrating">Diffraction Grating</option>
                        <option value="GrinLens">GRIN Lens</option>
                    </optgroup>
                    <optgroup label="Blockers">
                        <option value="Blocker">Blocker</option>
                        <option value="Aperture">Aperture</option>
                        <option value="CircleBlocker">Circle Blocker</option>
                    </optgroup>
                    <optgroup label="Detector">
                        <option value="Observer">Observer</option>
                    </optgroup>
                </select>

                <div class="rs-toolbar-sep"></div>

                <button id="rs-remove-btn" class="rs-btn rs-btn-danger" title="Remove selected (Del)">Remove</button>
                <button id="rs-clear-btn" class="rs-btn rs-btn-danger" title="Clear all objects">Clear</button>

                <div class="rs-toolbar-sep"></div>

                <button id="rs-undo-btn" class="rs-btn" title="Undo (Ctrl+Z)">&#x21A9;</button>
                <button id="rs-redo-btn" class="rs-btn" title="Redo (Ctrl+Shift+Z)">&#x21AA;</button>

                <div style="flex:1;"></div>

                <button id="rs-import-btn" class="rs-btn" title="Import scene from JSON">Import</button>
                <button id="rs-export-json" class="rs-btn" title="Export scene as JSON">Export</button>
                <input type="file" id="rs-import-file" accept=".json" style="display:none;">
                <button id="rs-export-png" class="rs-btn" title="Download as PNG">PNG</button>
                <button id="rs-share-btn" class="rs-btn" title="Share scene URL">Share</button>
            </div>

            <!-- Canvas -->
            <div class="rs-canvas-wrap" id="rs-canvas-wrap">
                <canvas id="rs-canvas"></canvas>
                <!-- Context Menu (hidden by default) -->
                <div id="rs-ctx-menu" class="rs-ctx-menu" style="display:none;">
                    <button class="rs-ctx-item" data-action="duplicate">Duplicate <span class="rs-ctx-key">Ctrl+D</span></button>
                    <button class="rs-ctx-item" data-action="lock">Lock / Unlock</button>
                    <button class="rs-ctx-item" data-action="front">Bring to Front</button>
                    <hr class="rs-ctx-sep">
                    <button class="rs-ctx-item rs-ctx-danger" data-action="delete">Delete <span class="rs-ctx-key">Del</span></button>
                </div>
            </div>

            <!-- Object Bar -->
            <div class="rs-objbar" id="rs-objbar">
                <span class="rs-objbar-empty">Click an object to select &middot; Drag to move &middot; Del to remove</span>
            </div>

            <!-- Controls Row -->
            <div class="rs-controls">
                <label class="rs-label">Mode</label>
                <select id="rs-ray-mode" class="rs-select">
                    <option value="rays">Rays</option>
                    <option value="extended">Extended</option>
                    <option value="images">Images</option>
                </select>

                <div class="rs-toolbar-sep"></div>

                <label class="rs-toggle">
                    <input type="checkbox" id="rs-fresnel">
                    Fresnel
                </label>

                <div class="rs-toolbar-sep"></div>

                <label class="rs-toggle">
                    <input type="checkbox" id="rs-grid">
                    Grid
                </label>
                <label class="rs-label">size</label>
                <input id="rs-grid-size" class="rs-prop-inp" type="number" value="50" min="10" max="200" step="10" style="width:40px;">

                <div class="rs-toolbar-sep"></div>

                <label class="rs-label">bg n</label>
                <input id="rs-bg-n" class="rs-prop-inp" type="number" value="1" min="1" max="3" step="0.01" style="width:45px;">
            </div>
        </div>

        <!-- ===== Educational Content ===== -->
        <div class="rs-card">
            <div class="rs-card-header">Ray Optics Concepts</div>
            <div class="rs-card-body">
                <div class="rs-edu-grid">
                    <div class="rs-edu-card">
                        <h4>Reflection &amp; Mirrors</h4>
                        <p>The law of reflection states that the angle of incidence equals the angle of reflection. Curved mirrors focus parallel rays to a focal point (concave) or appear to diverge from one (convex). Parabolic mirrors eliminate spherical aberration.</p>
                    </div>
                    <div class="rs-edu-card">
                        <h4>Snell's Law &amp; Refraction</h4>
                        <p>When light crosses a boundary between media: n<sub>1</sub> sin &theta;<sub>1</sub> = n<sub>2</sub> sin &theta;<sub>2</sub>. Glass (n &approx; 1.5) bends light toward the normal on entry. When the internal angle exceeds the critical angle, total internal reflection occurs.</p>
                    </div>
                    <div class="rs-edu-card">
                        <h4>Fresnel Equations</h4>
                        <p>At every interface, some light reflects and some transmits. The Fresnel equations give the exact ratio depending on angle and polarization. At normal incidence on glass, about 4% reflects. At grazing angles, reflection approaches 100%.</p>
                    </div>
                    <div class="rs-edu-card">
                        <h4>Dispersion &amp; Prisms</h4>
                        <p>Refractive index varies with wavelength: n(&lambda;) = A + B/&lambda;&sup2; (Cauchy equation). Shorter wavelengths (blue/violet) bend more than longer ones (red). A prism separates white light into a spectrum. This is chromatic dispersion.</p>
                    </div>
                    <div class="rs-edu-card">
                        <h4>Thin Lens Equation</h4>
                        <p>For ideal lenses: 1/f = 1/v &minus; 1/u, where f is focal length, v is image distance, u is object distance. Converging lenses (f > 0) form real images when the object is beyond the focal point. The simulator's ideal lens uses this equation directly.</p>
                    </div>
                    <div class="rs-edu-card">
                        <h4>Diffraction Gratings</h4>
                        <p>A grating with line spacing d diffracts light according to d(sin &theta;<sub>out</sub> &minus; sin &theta;<sub>in</sub>) = m&lambda;, where m is the order number. Different wavelengths diffract to different angles, producing a spectrum similar to a prism but with sharper separation.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== FAQ ===== -->
        <div class="rs-card">
            <div class="rs-card-header">Frequently Asked Questions</div>
            <div class="rs-card-body">
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">How do I simulate ray optics online for free?</summary>
                    <p class="rs-faq-a">Use this Ray Optics Simulator: choose a preset or add optical elements (mirrors, lenses, prisms, beam splitters) from the toolbar. Drag objects to position them and the simulator traces rays in real time using Snell's law. No download or signup needed.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">What is total internal reflection (TIR)?</summary>
                    <p class="rs-faq-a">TIR occurs when light travels from a denser medium (glass, n=1.5) to a less dense medium (air, n=1) at an angle exceeding the critical angle, arcsin(n<sub>2</sub>/n<sub>1</sub>). Beyond this angle, 100% of light reflects. Try it with the Glass Slab or Prism presets.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">How does a prism create a rainbow?</summary>
                    <p class="rs-faq-a">Different wavelengths bend by different amounts (dispersion). Red bends less, violet bends more. When white light enters a prism, Snell's law with wavelength-dependent refractive index separates the colors. Load the "Prism Rainbow" preset to see this.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">What are Fresnel equations?</summary>
                    <p class="rs-faq-a">Fresnel equations calculate reflected vs. transmitted light fractions at an interface. Enable the "Fresnel" toggle in the controls row to see partial reflections at glass surfaces &mdash; some light reflects while the rest transmits, with brightness proportional to the Fresnel coefficients.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">What optical elements are available?</summary>
                    <p class="rs-faq-a">19 elements: sources (point, parallel beam, single ray), mirrors (flat, curved, parabolic, ideal), refractors (glass slab, prism, circle lens, spherical lens, ideal lens), beam splitter (with dichroic option), diffraction grating, GRIN lens, blockers (flat, aperture, circle), and observer.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">Can I build a telescope or microscope?</summary>
                    <p class="rs-faq-a">Yes. Load the Telescope preset for a two-lens refracting telescope. For a microscope, place two converging lenses with appropriate focal lengths and spacing. Add light sources and apertures to complete the optical system.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">What is a GRIN lens?</summary>
                    <p class="rs-faq-a">GRIN (Gradient-Index) lenses have a refractive index that varies across the material, typically decreasing from center to edge. This bends rays continuously inside the lens without curved surfaces. The simulator uses Euler step integration to trace rays through GRIN media.</p>
                </details>
                <details class="rs-faq-item">
                    <summary class="rs-faq-q">Is this free for students and teachers?</summary>
                    <p class="rs-faq-a">Yes, completely free with no signup. Runs entirely in your browser. Ideal for physics courses covering geometric optics. Students can experiment with presets and build custom scenes. Teachers can export as PNG for presentations and worksheets.</p>
                </details>
            </div>
        </div>

<%--        <jsp:include page="../modern/ads/ad-in-content-mid.jsp" />--%>

        <!-- ===== Related Tools ===== -->
        <div class="rs-card">
            <div class="rs-card-header">Related Tools</div>
            <div class="rs-card-body">
                <div class="rs-edu-grid">
                    <a href="<%=request.getContextPath()%>/physics/optical-designer.jsp" style="text-decoration:none;">
                        <div class="rs-edu-card" style="cursor:pointer;transition:border-color 0.15s;">
                            <h4>Optical Designer</h4>
                            <p>Sequential multi-surface lens design with Sellmeier materials, spot diagrams, ABCD matrix, and chromatic aberration analysis.</p>
                        </div>
                    </a>
                    <a href="<%=request.getContextPath()%>/physics/lens-calculator.jsp" style="text-decoration:none;">
                        <div class="rs-edu-card" style="cursor:pointer;transition:border-color 0.15s;">
                            <h4>Lens Maker Calculator</h4>
                            <p>Single lens focal length from R1, R2, and refractive index. Combined and double lens systems.</p>
                        </div>
                    </a>
                    <a href="<%=request.getContextPath()%>/physics/refraction.jsp" style="text-decoration:none;">
                        <div class="rs-edu-card" style="cursor:pointer;transition:border-color 0.15s;">
                            <h4>Snell's Law &amp; Prism</h4>
                            <p>Refraction calculator with Snell's law, critical angle, prism deviation, and interactive diagrams.</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== ADS COLUMN ===== -->
    <div class="rs-ads-col">
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
<script src="<%=request.getContextPath()%>/physics/js/ray-sim-scene.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/ray-sim-engine.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/ray-sim-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/physics/js/ray-sim-ui.js?v=<%=cacheVersion%>"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    RayUI.init({
        canvasId: 'rs-canvas',
        preset: 'Convex Lens'
    });

    /* ---- Load shared scene from URL ---- */
    var TU = window.ToolUtils;
    if (TU && TU.loadSharedResult) {
        var shared = TU.loadSharedResult('scene');
        if (shared) {
            try {
                var data = JSON.parse(shared);
                var sc = RayUI.getScene();
                if (sc && data.objects) {
                    sc.objects = [];
                    for (var i = 0; i < data.objects.length; i++) {
                        var obj = RayScene.createObject(data.objects[i]);
                        if (obj) sc.addObject(obj);
                    }
                    if (data.props) {
                        sc.rayMode = data.props.rayMode || 'rays';
                        sc.fresnelEnabled = !!data.props.fresnelEnabled;
                        sc.backgroundN = data.props.backgroundN || 1;
                    }
                    RayUI.refreshAll();
                }
            } catch (e) {
                console.warn('Invalid shared scene:', e);
            }
        }
    }
});
</script>

<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
