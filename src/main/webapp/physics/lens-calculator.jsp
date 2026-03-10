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
        <jsp:param name="toolName" value="Lens Maker Calculator - Combined &amp; Double Lens System" />
        <jsp:param name="toolDescription" value="Free lens maker equation calculator. Find focal length from refractive index and radii of curvature. Combined lenses, double lens system with ray tracing. Step-by-step solutions." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="physics/lens-calculator.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="physics" />
        <jsp:param name="toolKeywords" value="lens maker equation calculator, lensmaker formula, combined lenses calculator, double lens system, equivalent focal length, refractive index, radius of curvature, diopters calculator, achromatic doublet, lens power, separated lenses, lenses in contact, ray tracing two lenses" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Lens maker equation solver,Combined lenses (contact and separated),Double lens system with full ray tracing,Material presets (Crown Flint BK7 Diamond Water Polycarbonate),6 lens shape presets,Step-by-step KaTeX solutions,Canvas diagrams with dark mode,Power in diopters" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose calculation mode|Select Lens Maker to find focal length from physical properties or Combined Lenses for equivalent focal length or Double Lens System for full ray tracing,Enter parameters|For Lens Maker: enter refractive index and radii of curvature. For Combined: enter focal lengths and separation. For Double Lens: enter focal lengths separation and object distance,Click Calculate|Press Calculate to see the diagram step-by-step solution and all results,Review results|Check focal length power magnification image properties and classification" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="Lens maker equation, combined lenses, double lens system, equivalent focal length, refractive index, diopters" />
        <jsp:param name="faq1q" value="What is the lens maker equation?" />
        <jsp:param name="faq1a" value="The lens maker equation is 1/f = (mu-1)(1/R1 - 1/R2), where f is focal length, mu is the refractive index of the lens material, R1 is the radius of curvature of the first surface, and R2 is the radius of the second surface. It calculates focal length from the physical properties of the lens." />
        <jsp:param name="faq2q" value="How do you find the equivalent focal length of two lenses in contact?" />
        <jsp:param name="faq2a" value="For two thin lenses in contact, the equivalent focal length F is given by 1/F = 1/f1 + 1/f2, or equivalently P = P1 + P2 in diopters. For example, a +10D and +5D lens in contact give +15D total, or F = 6.67 cm." />
        <jsp:param name="faq3q" value="What is the formula for separated lenses?" />
        <jsp:param name="faq3a" value="For two lenses separated by distance d: 1/F = 1/f1 + 1/f2 - d/(f1*f2). In terms of power: P = P1 + P2 - d*P1*P2. The separation changes the effective power of the system and is used in telescope and microscope design." />
        <jsp:param name="faq4q" value="How does a double lens system work?" />
        <jsp:param name="faq4a" value="In a double lens system, the image formed by the first lens becomes the object for the second lens. You solve the thin lens equation twice: first for lens 1 to find the intermediate image, then use that to find the object distance for lens 2 and solve again. Total magnification is m1 times m2." />
        <jsp:param name="faq5q" value="What is an achromatic doublet?" />
        <jsp:param name="faq5a" value="An achromatic doublet combines a converging lens (crown glass, low dispersion) with a diverging lens (flint glass, high dispersion) to minimize chromatic aberration. The net power is positive (converging) but dispersion effects cancel. The condition is P1/v1 + P2/v2 = 0, where v is the Abbe number." />
        <jsp:param name="faq6q" value="How does refractive index of the surrounding medium affect focal length?" />
        <jsp:param name="faq6a" value="The generalized lens maker equation uses relative refractive index: 1/f = (mu_lens/mu_medium - 1)(1/R1 - 1/R2). A glass lens (mu=1.5) in water (mu=1.33) has a longer focal length than in air (mu=1) because the relative refractive index is smaller. This is why underwater vision is blurry without goggles." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/lens-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--lc-gradient) !important; }
        .tool-badge { background: var(--lc-light); color: var(--lc-tool); }
    </style>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Lens Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/physics">Physics Tools</a> /
                Lens Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Lens Maker</span>
            <span class="tool-badge">Combined Lenses</span>
            <span class="tool-badge">Double Lens System</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--lc-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>lens maker equation calculator</strong> with <strong>combined lenses</strong> and <strong>double lens system</strong> ray tracing. Calculate focal length from refractive index &amp; radii of curvature, find equivalent focal length for lens combinations, or trace rays through a two-lens system with step-by-step solutions.</p>
        </div>
        <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
    </div>
</section>

<main class="tool-page-container lc-layout">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--lc-gradient);">Lens Calculator</div>
            <div class="tool-card-body">

                <!-- Mode Toggle -->
                <div class="tool-form-group" style="margin-bottom:0.75rem;">
                    <label class="lc-input-label">Calculation Mode</label>
                    <div class="lc-mode-toggle">
                        <button type="button" class="lc-mode-btn active" data-mode="lensmaker">Lens Maker</button>
                        <button type="button" class="lc-mode-btn" data-mode="combined">Combined</button>
                        <button type="button" class="lc-mode-btn" data-mode="doublelens">Double Lens</button>
                    </div>
                </div>

                <!-- ===== LENS MAKER INPUTS ===== -->
                <div id="lc-lensmaker-inputs">
                    <!-- Material + Medium row -->
                    <div class="lc-2col" style="margin-bottom:0.5rem;">
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-mu">Lens &mu;</label>
                            <input type="number" class="lc-input" id="lc-mu" value="1.5" min="1" max="4" step="0.01">
                        </div>
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-medium-select">Medium</label>
                            <select class="lc-select" id="lc-medium-select">
                                <option value="1" selected>Air (1.00)</option>
                                <option value="1.33">Water (1.33)</option>
                                <option value="1.47">Oil (1.47)</option>
                                <option value="1.52">Glass (1.52)</option>
                                <option value="custom">Custom...</option>
                            </select>
                        </div>
                    </div>
                    <input type="number" class="lc-input" id="lc-medium-mu" value="1" min="1" max="3" step="0.01" style="display:none;margin-bottom:0.5rem;">
                    <div class="lc-chip-row" style="margin-bottom:0.5rem;">
                        <button type="button" class="lc-chip lc-mat-chip" data-mu="1.52">Crown</button>
                        <button type="button" class="lc-chip lc-mat-chip" data-mu="1.62">Flint</button>
                        <button type="button" class="lc-chip lc-mat-chip" data-mu="1.5168">BK7</button>
                        <button type="button" class="lc-chip lc-mat-chip" data-mu="2.42">Diamond</button>
                        <button type="button" class="lc-chip lc-mat-chip" data-mu="1.586">Polycarb</button>
                    </div>

                    <!-- Shape presets + R1/R2 side by side -->
                    <div class="tool-form-group" style="margin-bottom:0.35rem;">
                        <label class="lc-input-label">Shape</label>
                        <div class="lc-chip-row">
                            <button type="button" class="lc-shape-chip" data-r1="20" data-r2="-20">)(</button>
                            <button type="button" class="lc-shape-chip" data-r1="-20" data-r2="20">()</button>
                            <button type="button" class="lc-shape-chip" data-r1="99999" data-r2="-25">|)</button>
                            <button type="button" class="lc-shape-chip" data-r1="99999" data-r2="25">|(</button>
                            <button type="button" class="lc-shape-chip" data-r1="20" data-r2="40">))</button>
                            <button type="button" class="lc-shape-chip" data-r1="-40" data-r2="-20">((</button>
                        </div>
                    </div>
                    <div class="lc-2col" style="margin-bottom:0.5rem;">
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-r1">R&#8321; (cm)</label>
                            <input type="number" class="lc-input" id="lc-r1" value="20" step="0.5">
                            <input type="range" class="lc-slider" id="lc-r1-slider" min="-100" max="100" step="0.5" value="20" style="margin-top:0.25rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-r2">R&#8322; (cm)</label>
                            <input type="number" class="lc-input" id="lc-r2" value="-20" step="0.5">
                            <input type="range" class="lc-slider" id="lc-r2-slider" min="-100" max="100" step="0.5" value="-20" style="margin-top:0.25rem;">
                        </div>
                    </div>
                    <div class="lc-hint" style="margin-bottom:0.5rem;">+ = convex, &minus; = concave, 99999 = flat (&infin;)</div>

                    <!-- Thick Lens Toggle -->
                    <div class="tool-form-group" style="margin-bottom:0.5rem;">
                        <label class="lc-toggle-row">
                            <input type="checkbox" id="lc-thick-toggle"> <span class="lc-input-label" style="display:inline;margin:0;">Thick lens (add thickness)</span>
                        </label>
                        <div id="lc-thick-section" style="display:none;margin-top:0.35rem;">
                            <label class="lc-input-label" for="lc-thickness">Thickness t (cm)</label>
                            <input type="number" class="lc-input" id="lc-thickness" value="1" min="0.1" step="0.1">
                        </div>
                    </div>
                </div>

                <!-- ===== COMBINED LENSES INPUTS ===== -->
                <div id="lc-combined-inputs" style="display:none;">
                    <div class="lc-2col" style="margin-bottom:0.5rem;">
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-f1">f&#8321; (cm)</label>
                            <input type="number" class="lc-input" id="lc-f1" value="10" step="0.5">
                        </div>
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-f2">f&#8322; (cm)</label>
                            <input type="number" class="lc-input" id="lc-f2" value="15" step="0.5">
                        </div>
                    </div>
                    <div class="tool-form-group" style="margin-bottom:0.5rem;">
                        <label class="lc-input-label" for="lc-separation">Separation d (cm)</label>
                        <input type="number" class="lc-input" id="lc-separation" value="0" min="0" step="0.5">
                        <div class="lc-hint">d = 0 for lenses in contact</div>
                    </div>
                </div>

                <!-- ===== DOUBLE LENS SYSTEM INPUTS ===== -->
                <div id="lc-doublelens-inputs" style="display:none;">
                    <div class="lc-2col" style="margin-bottom:0.5rem;">
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-dl-f1">f&#8321; (cm)</label>
                            <input type="number" class="lc-input" id="lc-dl-f1" value="10" step="0.5">
                        </div>
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-dl-f2">f&#8322; (cm)</label>
                            <input type="number" class="lc-input" id="lc-dl-f2" value="15" step="0.5">
                        </div>
                    </div>
                    <div class="lc-2col" style="margin-bottom:0.5rem;">
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-dl-d">Separation d (cm)</label>
                            <input type="number" class="lc-input" id="lc-dl-d" value="25" min="0" step="0.5">
                        </div>
                        <div class="tool-form-group">
                            <label class="lc-input-label" for="lc-dl-u">Object u (cm)</label>
                            <input type="number" class="lc-input" id="lc-dl-u" value="25" min="0.1" step="0.5">
                        </div>
                    </div>
                    <div class="tool-form-group" style="margin-bottom:0.5rem;">
                        <label class="lc-input-label" for="lc-dl-h">Object Height h (cm)</label>
                        <input type="number" class="lc-input" id="lc-dl-h" value="5" min="0.1" step="0.5">
                    </div>
                </div>

                <!-- Calculate Button -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="lc-solve-btn" style="flex:1">Calculate</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0">

                <!-- Quick Examples - grouped by mode -->
                <div class="tool-form-group">
                    <label class="lc-input-label">Examples</label>
                    <div class="lc-example-group" id="lc-ex-lensmaker">
                        <div class="lc-examples">
                            <button type="button" class="lc-example-chip" data-example="crown-biconvex">Crown Biconvex</button>
                            <button type="button" class="lc-example-chip" data-example="flint-biconcave">Flint Biconcave</button>
                            <button type="button" class="lc-example-chip" data-example="bk7-planoconvex">BK7 Plano-Cvx</button>
                            <button type="button" class="lc-example-chip" data-example="diamond">Diamond</button>
                            <button type="button" class="lc-example-chip" data-example="water-lens">In Water</button>
                            <button type="button" class="lc-example-chip" data-example="meniscus">Meniscus</button>
                        </div>
                    </div>
                    <div class="lc-example-group" id="lc-ex-combined" style="display:none;">
                        <div class="lc-examples">
                            <button type="button" class="lc-example-chip" data-example="contact-conv">+10D +20D Contact</button>
                            <button type="button" class="lc-example-chip" data-example="contact-achro">Achromatic Doublet</button>
                            <button type="button" class="lc-example-chip" data-example="separated">Separated 5cm</button>
                            <button type="button" class="lc-example-chip" data-example="telescope">Telescope</button>
                        </div>
                    </div>
                    <div class="lc-example-group" id="lc-ex-doublelens" style="display:none;">
                        <div class="lc-examples">
                            <button type="button" class="lc-example-chip" data-example="microscope">Microscope</button>
                            <button type="button" class="lc-example-chip" data-example="projector">Projector</button>
                            <button type="button" class="lc-example-chip" data-example="relay">Relay Lens</button>
                            <button type="button" class="lc-example-chip" data-example="telephoto">Telephoto</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Canvas Diagram -->
        <div class="tool-card" style="margin-bottom:1rem;">
            <div class="tool-result-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--lc-tool);">
                    <circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
                </svg>
                <h4>Lens Diagram</h4>
            </div>
            <div class="lc-diagram-wrap">
                <canvas id="lc-diagram" width="900" height="450"></canvas>
            </div>
        </div>

        <!-- Results -->
        <div class="tool-card" style="margin-bottom:1rem;">
            <div class="tool-result-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--lc-tool);">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                </svg>
                <h4>Results</h4>
            </div>
            <div class="tool-result-content" id="lc-result-content">
                <div class="tool-empty-state" id="lc-empty-state">
                    <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">1/f = (&mu;&minus;1)(1/R&#8321; &minus; 1/R&#8322;)</div>
                    <h3>Enter values to calculate</h3>
                    <p>Lens maker equation, combined lenses, or double lens system.</p>
                </div>
                <div id="lc-results-container"></div>
            </div>
        </div>

        <!-- Steps -->
        <div class="tool-card">
            <div class="tool-result-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--lc-tool);">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>
                </svg>
                <h4>Step-by-Step Solution</h4>
            </div>
            <div class="tool-result-content" style="padding:1rem;">
                <div id="lc-steps-container"></div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="../modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="physics/lens-calculator.jsp"/>
    <jsp:param name="keyword" value="physics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- In-Content Ad -->
<div style="max-width:1200px;margin:1.5rem auto;padding:0 1rem;">
    <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
</div>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- 1. Lens Maker's Equation -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">The Lens Maker's Equation</h2>
        <p class="lc-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            The <strong>lens maker's equation</strong> relates the focal length of a lens to the <strong>refractive index</strong> of the material and the <strong>radii of curvature</strong> of its two surfaces: <strong>1/f = (&mu; &minus; 1)(1/R&#8321; &minus; 1/R&#8322;)</strong>. For a lens immersed in a medium other than air, the generalized form uses &mu;&#8321;/&mu;&#8322; (relative refractive index).
        </p>
        <div class="lc-callout lc-callout-insight lc-anim lc-anim-d2">
            <span class="lc-callout-icon">&#128161;</span>
            <div class="lc-callout-text">
                <strong>Sign Convention for Radii:</strong> R is positive when the center of curvature is on the right side of the surface (convex toward incoming light), negative when on the left (concave toward incoming light). A flat surface has R = &infin;.
            </div>
        </div>
    </div>

    <!-- 2. Types of Lens Combinations -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Types of Lens Combinations</h2>
        <div class="lc-edu-grid">
            <div class="lc-edu-card lc-anim lc-anim-d1" style="border-left:3px solid #6366f1;">
                <h4>Lenses in Contact</h4>
                <p>When two thin lenses are placed in contact (d = 0), their powers add directly: P = P&#8321; + P&#8322;. Equivalent focal length: 1/F = 1/f&#8321; + 1/f&#8322;. Used in compound eyepieces and corrective lenses.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d1" style="border-left:3px solid #8b5cf6;">
                <h4>Separated Lenses</h4>
                <p>When lenses are separated by distance d: 1/F = 1/f&#8321; + 1/f&#8322; &minus; d/(f&#8321;&middot;f&#8322;). The separation term changes the effective power. Telescopes and microscopes rely on precise lens spacing.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d2" style="border-left:3px solid #ec4899;">
                <h4>Achromatic Doublet</h4>
                <p>A converging crown glass lens paired with a diverging flint glass lens. Net effect is converging but chromatic aberration is minimized. Essential in camera lenses and telescopes.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d2" style="border-left:3px solid #f59e0b;">
                <h4>Double Lens System</h4>
                <p>Image from lens 1 becomes the object for lens 2. Requires solving the thin lens equation twice. Total magnification = m&#8321; &times; m&#8322;. Used in microscopes, projectors, and relay optics.</p>
            </div>
        </div>
    </div>

    <!-- 3. Lens Shapes -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Lens Shapes &amp; Sign Conventions</h2>
        <div class="lc-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
            <div class="lc-edu-card lc-anim lc-anim-d1" style="border-left:3px solid #6366f1;">
                <h4>Biconvex</h4>
                <p>R&#8321; &gt; 0, R&#8322; &lt; 0. Always converging (f &gt; 0). Most common lens shape.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d1" style="border-left:3px solid #8b5cf6;">
                <h4>Biconcave</h4>
                <p>R&#8321; &lt; 0, R&#8322; &gt; 0. Always diverging (f &lt; 0). Used in myopia correction.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d1" style="border-left:3px solid #ec4899;">
                <h4>Plano-Convex</h4>
                <p>R&#8321; = &infin;, R&#8322; &lt; 0. Converging. Common in laser optics and condensers.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d2" style="border-left:3px solid #f59e0b;">
                <h4>Plano-Concave</h4>
                <p>R&#8321; = &infin;, R&#8322; &gt; 0. Diverging. Used in beam expanders.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d2" style="border-left:3px solid #10b981;">
                <h4>Converging Meniscus</h4>
                <p>Both surfaces curve same way, R&#8321; &gt; 0, R&#8322; &gt; 0 (R&#8321; &lt; R&#8322;). Net converging. Used in eyeglasses.</p>
            </div>
            <div class="lc-edu-card lc-anim lc-anim-d2" style="border-left:3px solid #3b82f6;">
                <h4>Diverging Meniscus</h4>
                <p>Both surfaces curve same way, R&#8321; &lt; 0, R&#8322; &lt; 0. Net diverging. Less common.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the lens maker equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The lens maker equation is 1/f = (&mu;&minus;1)(1/R&#8321; &minus; 1/R&#8322;), where f is focal length, &mu; is the refractive index, R&#8321; is the radius of curvature of the first surface, and R&#8322; is the radius of the second surface. It calculates focal length from the physical properties of the lens.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you find the equivalent focal length of two lenses in contact?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">For two thin lenses in contact: 1/F = 1/f&#8321; + 1/f&#8322;, or P = P&#8321; + P&#8322; in diopters. For example, a +10D and +5D lens in contact give P = +15D total, with F = 100/15 = 6.67 cm.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the formula for separated lenses?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">For two lenses separated by distance d: 1/F = 1/f&#8321; + 1/f&#8322; &minus; d/(f&#8321;&middot;f&#8322;). In terms of power: P = P&#8321; + P&#8322; &minus; d&middot;P&#8321;&middot;P&#8322;. The separation changes the effective power of the system.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does a double lens system work?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The image formed by lens 1 becomes the object for lens 2. Solve the thin lens equation for lens 1 to get v&#8321; (intermediate image), then compute u&#8322; = &minus;(d &minus; v&#8321;) and solve again for lens 2. Total magnification is m&#8321; &times; m&#8322;.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is an achromatic doublet?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">An achromatic doublet combines a converging lens (crown glass, low dispersion) with a diverging lens (flint glass, high dispersion) to minimize chromatic aberration. The net power is positive but dispersion effects cancel. Essential in quality optics.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does the surrounding medium affect focal length?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The generalized form uses relative refractive index: 1/f = (&mu;&#8321;/&mu;&#8322; &minus; 1)(1/R&#8321; &minus; 1/R&#8322;). A glass lens (&mu;=1.5) in water (&mu;=1.33) has a longer focal length than in air because the relative index is smaller (1.5/1.33 vs 1.5/1).</div>
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
            <a href="<%=request.getContextPath()%>/lens-mirror-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#e11d48,#f43f5e);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.3rem;">&#128269;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Lens &amp; Mirror Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Thin lens equation for 7 optical elements with ray diagrams</p>
                </div>
            </a>
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
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="../modern/components/support-section.jsp" %>

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

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.lc-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('lc-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('lc-visible');
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
<script src="<%=request.getContextPath()%>/physics/js/lens-calculator.js?v=<%=cacheVersion%>"></script>

<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
