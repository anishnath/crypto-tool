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
        <jsp:param name="toolName" value="Lens Equation Calculator - Ray Diagram & Mirror Formula" />
        <jsp:param name="toolDescription" value="Free lens equation calculator with ray diagrams. Solve 1/f = 1/v − 1/u for 7 optical types: biconvex, plano-convex, concave mirror &amp; more. Step-by-step solutions, magnification, diopters." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="lens-mirror-calculator.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="physics" />
        <jsp:param name="toolKeywords" value="lens equation calculator, thin lens equation solver, mirror formula calculator, ray diagram generator, focal length calculator, magnification calculator, converging lens, diverging lens, plano-convex lens, plano-concave lens, concave mirror, convex mirror, plane mirror, radius of curvature, lens power diopters, image distance calculator, optics calculator" />
        <jsp:param name="toolImage" value="lens-mirror-calculator.svg" />
        <jsp:param name="toolFeatures" value="Thin lens equation solver (1/f = 1/v − 1/u),Interactive canvas ray diagram with 3 principal rays and glow effects,7 optical elements: biconvex biconcave plano-convex plano-concave concave mirror convex mirror plane mirror,Radius of curvature R = 2f for curved mirrors,Magnification and image height calculation,Lens power in diopters,Real vs virtual image detection with badges,Step-by-step KaTeX math solutions,10 preset examples for instant learning,PNG ray diagram export and shareable URLs,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Select optical element|Choose from 7 types: biconvex lens biconcave lens plano-convex plano-concave concave mirror convex mirror or plane mirror,Enter known values|Input focal length (f) object distance (u) and object height (h) in centimeters. Use sliders for quick adjustment,Choose what to solve|Select Find Image (v) Find Object (u) or Find Focal Length (f) using the mode toggle,Click Calculate|Press Calculate to see the ray diagram step-by-step solution magnification and image properties,Export or share|Save the ray diagram as PNG or copy a shareable URL to send to classmates" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="Geometric optics, thin lens equation, mirror formula, ray diagrams, magnification, image formation" />
        <jsp:param name="faq1q" value="What is the thin lens equation and how does it work?" />
        <jsp:param name="faq1a" value="The thin lens equation is 1/f = 1/v − 1/u, where f is the focal length, u is the object distance, and v is the image distance. It predicts where an image forms for any thin lens or spherical mirror. Converging elements (biconvex lens, plano-convex lens, concave mirror) have positive f. Diverging elements (biconcave lens, plano-concave lens, convex mirror) have negative f. A plane mirror has f = infinity." />
        <jsp:param name="faq2q" value="How do you calculate magnification from the lens equation?" />
        <jsp:param name="faq2a" value="Magnification m = v/u, which also equals image height divided by object height (h'/h). When m is negative the image is inverted; when positive it is upright. If |m| > 1 the image is magnified; if |m| < 1 it is diminished. For example, m = -2 means an inverted image twice the object's size. A plane mirror always gives m = 1." />
        <jsp:param name="faq3q" value="What is the difference between real and virtual images?" />
        <jsp:param name="faq3a" value="Real images form where light rays actually converge and can be projected onto a screen (v is positive in our sign convention). Virtual images form where rays only appear to diverge from and cannot be projected (v is negative). Converging lenses and concave mirrors can form both types. Diverging lenses, convex mirrors, and plane mirrors always form virtual images." />
        <jsp:param name="faq4q" value="How is radius of curvature related to focal length?" />
        <jsp:param name="faq4a" value="For spherical mirrors, the radius of curvature R equals twice the focal length: R = 2f. A concave mirror with f = 15 cm has R = 30 cm. This relationship comes from the geometry of reflection at a curved surface. Lenses use a more complex relation involving both surface radii and refractive index (lensmaker's equation)." />
        <jsp:param name="faq5q" value="What is lens power and how is it measured in diopters?" />
        <jsp:param name="faq5a" value="Lens power P is the reciprocal of focal length in meters: P = 1/f(m), measured in diopters (D). A converging lens with f = 50 cm has power +2D. Positive diopters mean converging, negative mean diverging. Optometrists prescribe eyeglasses in diopters. For lenses in contact, total power is P_total = P1 + P2." />
        <jsp:param name="faq6q" value="What happens when the object is at the focal point?" />
        <jsp:param name="faq6a" value="When the object is placed exactly at the focal point (u = -f), the image forms at infinity. The light rays emerge parallel after passing through the lens or reflecting off the mirror. This principle is used in searchlights and collimators. Our calculator shows an error message for this special case since v approaches infinity." />
        <jsp:param name="faq7q" value="What are plano-convex and plano-concave lenses?" />
        <jsp:param name="faq7a" value="Plano-convex lenses have one flat surface and one curved outward surface. They converge light (positive f) and are common in laser optics and condensers. Plano-concave lenses have one flat and one inward-curved surface, diverging light (negative f). Both follow the same thin lens equation as biconvex and biconcave lenses." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/lens-mirror-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--lm-gradient) !important; }
        .tool-badge { background: var(--lm-light); color: var(--lm-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Lens & Mirror Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/physics">Physics Tools</a> /
                Lens & Mirror Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">7 Optical Elements</span>
            <span class="tool-badge">Ray Diagrams</span>
            <span class="tool-badge">Step-by-Step</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--lm-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>lens equation calculator</strong> with <strong>interactive ray diagrams</strong>. Supports <strong>7 optical elements</strong> &mdash; biconvex, biconcave, plano-convex, plano-concave lenses, concave, convex, and plane mirrors. Solve <strong>1/f = 1/v − 1/u</strong> with step-by-step solutions, magnification, diopters, and <strong>radius of curvature</strong>.</p>
        </div>
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>
</section>

<main class="tool-page-container lm-layout">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--lm-gradient);">Lens & Mirror Calculator</div>
            <div class="tool-card-body">

                <!-- Optical Type -->
                <div class="tool-form-group" style="margin-bottom:0.75rem;">
                    <label class="lm-input-label" for="lm-type">Optical Element</label>
                    <select class="lm-select" id="lm-type">
                        <option value="converging" selected>Biconvex Lens (Converging)</option>
                        <option value="diverging">Biconcave Lens (Diverging)</option>
                        <option value="plano-convex">Plano-Convex Lens</option>
                        <option value="plano-concave">Plano-Concave Lens</option>
                        <option value="concave-mirror">Concave Mirror</option>
                        <option value="convex-mirror">Convex Mirror</option>
                        <option value="plane-mirror">Plane Mirror</option>
                    </select>
                </div>

                <!-- Calc Mode Toggle -->
                <div class="tool-form-group" style="margin-bottom:0.75rem;">
                    <label class="lm-input-label">Solve For</label>
                    <div class="lm-mode-toggle">
                        <button type="button" class="lm-mode-btn active" data-mode="find-v">Image (v)</button>
                        <button type="button" class="lm-mode-btn" data-mode="find-u">Object (u)</button>
                        <button type="button" class="lm-mode-btn" data-mode="find-f">Focal (f)</button>
                    </div>
                </div>

                <!-- Focal Length -->
                <div class="tool-form-group" id="lm-group-f" style="margin-bottom:0.75rem;">
                    <label class="lm-input-label" for="lm-focal">Focal Length (f) &mdash; cm</label>
                    <div class="lm-slider-row">
                        <input type="number" class="lm-input" id="lm-focal" value="10" step="0.1">
                        <input type="range" class="lm-slider" id="lm-f-slider" min="-50" max="50" step="0.5" value="10">
                    </div>
                    <div class="lm-hint">Positive = converging, Negative = diverging</div>
                </div>

                <!-- Object Distance -->
                <div class="tool-form-group" id="lm-group-u" style="margin-bottom:0.75rem;">
                    <label class="lm-input-label" for="lm-obj-dist">Object Distance (u) &mdash; cm</label>
                    <div class="lm-slider-row">
                        <input type="number" class="lm-input" id="lm-obj-dist" value="-20" step="0.1">
                        <input type="range" class="lm-slider" id="lm-u-slider" min="-100" max="-1" step="0.5" value="-20">
                    </div>
                    <div class="lm-hint">Negative (object on left, sign convention)</div>
                </div>

                <!-- Image Distance -->
                <div class="tool-form-group" id="lm-group-v" style="display:none;margin-bottom:0.75rem;">
                    <label class="lm-input-label" for="lm-img-dist">Image Distance (v) &mdash; cm</label>
                    <div class="lm-slider-row">
                        <input type="number" class="lm-input" id="lm-img-dist" value="20" step="0.1">
                        <input type="range" class="lm-slider" id="lm-v-slider" min="-100" max="100" step="0.5" value="20">
                    </div>
                    <div class="lm-hint">Positive = real image, Negative = virtual</div>
                </div>

                <!-- Object Height -->
                <div class="tool-form-group" style="margin-bottom:0.75rem;">
                    <label class="lm-input-label" for="lm-obj-height">Object Height (h) &mdash; cm</label>
                    <div class="lm-slider-row">
                        <input type="number" class="lm-input" id="lm-obj-height" value="5" step="0.1">
                        <input type="range" class="lm-slider" id="lm-h-slider" min="1" max="20" step="0.5" value="5">
                    </div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="lm-solve-btn" style="flex:1">Calculate</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="lm-input-label">Quick Examples</label>
                    <div class="lm-examples">
                        <button type="button" class="lm-example-chip" data-example="conv-real">Real Image</button>
                        <button type="button" class="lm-example-chip" data-example="conv-virtual">Virtual Image</button>
                        <button type="button" class="lm-example-chip" data-example="magnifying">Magnifier</button>
                        <button type="button" class="lm-example-chip" data-example="div-basic">Diverging</button>
                        <button type="button" class="lm-example-chip" data-example="eyeglasses">Eyeglasses</button>
                        <button type="button" class="lm-example-chip" data-example="plano-convex">Plano-Convex</button>
                        <button type="button" class="lm-example-chip" data-example="plano-concave">Plano-Concave</button>
                        <button type="button" class="lm-example-chip" data-example="concave-mirror">Concave Mirror</button>
                        <button type="button" class="lm-example-chip" data-example="convex-mirror">Convex Mirror</button>
                        <button type="button" class="lm-example-chip" data-example="plane-mirror">Plane Mirror</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Ray Diagram -->
        <div class="tool-card" style="margin-bottom:1rem;">
            <div class="tool-result-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--lm-tool);">
                    <circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
                </svg>
                <h4>Ray Diagram</h4>
            </div>
            <div class="lm-diagram-wrap">
                <canvas id="lm-diagram" width="900" height="500"></canvas>
            </div>
        </div>

        <!-- Results -->
        <div class="tool-card" style="margin-bottom:1rem;">
            <div class="tool-result-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--lm-tool);">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                </svg>
                <h4>Results</h4>
            </div>
            <div class="tool-result-content" id="lm-result-content">
                <div class="tool-empty-state" id="lm-empty-state">
                    <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">1/f = 1/v − 1/u</div>
                    <h3>Enter values to calculate</h3>
                    <p>Solve lens and mirror equations with interactive ray diagrams.</p>
                </div>
                <div id="lm-results-container"></div>
            </div>
            <div class="tool-result-actions" id="lm-result-actions" style="display:none;gap:0.5rem;padding:0.75rem 1rem;border-top:1px solid var(--border)">
                <button type="button" class="tool-action-btn" id="lm-share-btn" style="flex:1">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px"><path d="M4 12v8a2 2 0 002 2h12a2 2 0 002-2v-8"/><polyline points="16 6 12 2 8 6"/><line x1="12" y1="2" x2="12" y2="15"/></svg>
                    Share Link
                </button>
                <button type="button" class="tool-action-btn" id="lm-save-png-btn" style="flex:1;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                    Save PNG
                </button>
            </div>
        </div>

        <!-- Steps -->
        <div class="tool-card">
            <div class="tool-result-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--lm-tool);">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>
                </svg>
                <h4>Step-by-Step Solution</h4>
            </div>
            <div class="tool-result-content" style="padding:1rem;">
                <div id="lm-steps-container"></div>
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
    <jsp:param name="currentToolUrl" value="lens-mirror-calculator.jsp"/>
    <jsp:param name="keyword" value="physics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- In-Content Ad -->
<div style="max-width:1200px;margin:1.5rem auto;padding:0 1rem;">
    <%@ include file="modern/ads/ad-in-content-top.jsp" %>
</div>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- 1. What is the Thin Lens Equation? -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What is the Thin Lens Equation?</h2>
        <p class="lm-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            The <strong>thin lens equation</strong> 1/f = 1/v − 1/u relates the <strong>focal length</strong> (f), <strong>object distance</strong> (u), and <strong>image distance</strong> (v) for any thin lens or spherical mirror. It is the foundation of geometric optics, used to predict where images form and whether they are real or virtual.
        </p>
        <div class="lm-callout lm-callout-insight lm-anim lm-anim-d2">
            <span class="lm-callout-icon">&#128161;</span>
            <div class="lm-callout-text">
                <strong>Key Insight:</strong> The same equation works for lenses and mirrors &mdash; only the sign conventions differ. Converging elements have positive focal lengths; diverging elements have negative focal lengths.
            </div>
        </div>
    </div>

    <!-- 2. Types of Optical Elements -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Types of Optical Elements</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Understanding the seven optical elements supported by this calculator.
        </p>
        <div class="lm-edu-grid">
            <div class="lm-edu-card lm-anim lm-anim-d1" style="border-left:3px solid #e11d48;">
                <h4>Biconvex Lens (Converging)</h4>
                <p>Both surfaces curve outward. Positive f. Forms real or virtual images. Used in cameras, magnifying glasses, and farsightedness correction.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d1" style="border-left:3px solid #f43f5e;">
                <h4>Biconcave Lens (Diverging)</h4>
                <p>Both surfaces curve inward. Negative f. Always forms virtual, upright, diminished images. Used in nearsightedness correction and peepholes.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d1" style="border-left:3px solid #ec4899;">
                <h4>Plano-Convex Lens</h4>
                <p>One flat surface, one convex. Positive f. Behaves like a converging lens. Common in laser optics, condensers, and imaging systems.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d2" style="border-left:3px solid #f97316;">
                <h4>Plano-Concave Lens</h4>
                <p>One flat surface, one concave. Negative f. Behaves like a diverging lens. Used in beam expanders and to correct spherical aberration.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d2" style="border-left:3px solid #3b82f6;">
                <h4>Concave Mirror</h4>
                <p>Curves inward (R = 2f). Positive f. Forms real or virtual images. Used in telescopes, headlights, and shaving mirrors.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d2" style="border-left:3px solid #f59e0b;">
                <h4>Convex Mirror</h4>
                <p>Curves outward (R = 2f). Negative f. Always forms virtual, upright, diminished images. Used in vehicle side mirrors and security mirrors.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d3" style="border-left:3px solid #8b5cf6;">
                <h4>Plane Mirror</h4>
                <p>Flat reflecting surface. f = &infin;, P = 0 D. Always forms virtual, upright, same-size images at equal distance behind the mirror. The simplest optical element.</p>
            </div>
        </div>
    </div>

    <!-- 3. Real-World Applications -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Real-World Applications</h2>
        <div class="lm-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(260px,1fr));">
            <div class="lm-edu-card lm-anim lm-anim-d1" style="border-left:3px solid #e11d48;">
                <h4>Eyeglasses &amp; Contact Lenses</h4>
                <p>Optometrists prescribe lenses in diopters (P = 1/f). Positive diopters correct farsightedness; negative correct nearsightedness.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d2" style="border-left:3px solid #3b82f6;">
                <h4>Cameras &amp; Telescopes</h4>
                <p>Camera lenses use the thin lens equation to focus light on the sensor. Telescopes combine converging lenses/mirrors for magnification.</p>
            </div>
            <div class="lm-edu-card lm-anim lm-anim-d3" style="border-left:3px solid #10b981;">
                <h4>Microscopes &amp; Projectors</h4>
                <p>Compound microscopes use two converging lenses for extreme magnification. Projectors create enlarged real images on screens.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the thin lens equation and how does it work?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The thin lens equation is 1/f = 1/v − 1/u, where f is the focal length, u is the object distance, and v is the image distance. It predicts where an image forms for any thin lens or spherical mirror. Converging elements (biconvex lens, plano-convex lens, concave mirror) have positive f. Diverging elements (biconcave lens, plano-concave lens, convex mirror) have negative f. A plane mirror has f = infinity.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you calculate magnification from the lens equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Magnification m = v/u, which also equals image height divided by object height (h'/h). When m is negative the image is inverted; when positive it is upright. If |m| > 1 the image is magnified; if |m| < 1 it is diminished. For example, m = -2 means an inverted image twice the object's size. A plane mirror always gives m = 1.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between real and virtual images?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Real images form where light rays actually converge and can be projected onto a screen (v is positive). Virtual images form where rays only appear to diverge from and cannot be projected (v is negative). Converging lenses and concave mirrors can form both types. Diverging lenses, convex mirrors, and plane mirrors always form virtual images.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How is radius of curvature related to focal length?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">For spherical mirrors, the radius of curvature R equals twice the focal length: R = 2f. A concave mirror with f = 15 cm has R = 30 cm. This relationship comes from the geometry of reflection at a curved surface. Lenses use a more complex relation involving both surface radii and refractive index (lensmaker's equation).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is lens power and how is it measured in diopters?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Lens power P is the reciprocal of focal length in meters: P = 1/f(m), measured in diopters (D). A converging lens with f = 50 cm has power +2D. Positive diopters mean converging, negative mean diverging. Optometrists prescribe eyeglasses in diopters. For lenses in contact, total power is P_total = P1 + P2.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What happens when the object is at the focal point?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">When the object is placed exactly at the focal point (u = -f), the image forms at infinity. The light rays emerge parallel after passing through the lens or reflecting off the mirror. This principle is used in searchlights and collimators. Our calculator shows an error message for this special case since v approaches infinity.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are plano-convex and plano-concave lenses?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Plano-convex lenses have one flat surface and one curved outward surface. They converge light (positive f) and are common in laser optics and condensers. Plano-concave lenses have one flat and one inward-curved surface, diverging light (negative f). Both follow the same thin lens equation as biconvex and biconcave lenses.</div>
        </div>
    </div>
</section>

<!-- Explore More Physics Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Physics Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/snells-law-prism.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">n</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Snell's Law Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Light refraction, critical angles, and prism deviation</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/inclined-plane-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#2563eb,#3b82f6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">F</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Inclined Plane Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Forces, friction, and acceleration on inclined planes</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/projectile-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">v</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Projectile Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Projectile motion with trajectory visualization</p>
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
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
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
    var els = document.querySelectorAll('.lm-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('lm-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('lm-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

<!-- Core Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/lens-mirror-calculator-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/lens-mirror-calculator-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/lens-mirror-calculator-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
