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
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Interactive Ray Diagram Maker - Lens & Mirror Simulator Free" />
        <jsp:param name="toolDescription" value="Free interactive ray diagram tool. Visualize image formation for 7 optical elements — biconvex, biconcave, plano-convex, plano-concave lenses, concave, convex, and plane mirrors. Real-time sliders, step-by-step solutions, and Canvas ray diagrams." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="exams/visual-physics/lens-ray-diagram.jsp" />
        <jsp:param name="toolKeywords" value="ray diagram maker, lens ray diagram, mirror ray diagram, convex lens simulator, concave mirror simulator, image formation, focal length, magnification, optics simulator, interactive physics tool, thin lens equation" />
        <jsp:param name="toolFeatures" value="7 optical elements with real-time ray diagrams,Interactive sliders for instant updates,3 principal rays with virtual extensions,Step-by-step KaTeX solutions,Magnification and image classification,PNG export and shareable URLs,Dark mode support,Free no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose optical element|Select from 7 types including lenses and mirrors,Adjust sliders|Move focal length and object distance sliders to see ray diagram update in real-time,Read results|View image properties magnification and step-by-step solution below the diagram" />
        <jsp:param name="faq1q" value="What optical elements are supported?" />
        <jsp:param name="faq1a" value="7 types: biconvex lens, biconcave lens, plano-convex lens, plano-concave lens, concave mirror, convex mirror, and plane mirror." />
        <jsp:param name="faq2q" value="Is it free?" />
        <jsp:param name="faq2a" value="Yes, completely free with no signup. All calculations and ray diagrams run in your browser." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-physics/css/vp-lens.css?v=<%=cacheVersion%>">

    <%@ include file="../../modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--lm-gradient) !important; }
        .tool-badge { background: var(--lm-light); color: var(--lm-tool); }
    </style>
</head>
<body>
<%@ include file="../../modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Interactive Ray Diagram Maker</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/exams/">Exams</a> /
                <a href="<%=request.getContextPath()%>/exams/visual-physics/">Visual Physics</a> /
                Ray Diagram Maker
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">7 Optical Elements</span>
            <span class="tool-badge">Real-Time</span>
            <span class="tool-badge">Ray Diagrams</span>
            <span class="tool-badge">Step-by-Step</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--lm-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Interactive <strong>ray diagram maker</strong> with <strong>real-time sliders</strong>. Supports <strong>7 optical elements</strong> &mdash; lenses and mirrors. Drag sliders to see how image formation changes instantly. Step-by-step solutions with KaTeX math.</p>
        </div>
        <div class="tool-description-ad">
            <%@ include file="../../modern/ads/ad-in-content-top.jsp" %>
        </div>
    </div>
</section>

<main class="tool-page-container lm-layout">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--lm-gradient);">Ray Diagram Controls</div>
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

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="lm-input-label">Quick Examples</label>
                    <div class="lm-examples">
                        <button type="button" class="lm-example-chip" data-example="conv-real">Real Image</button>
                        <button type="button" class="lm-example-chip" data-example="conv-virtual">Virtual Image</button>
                        <button type="button" class="lm-example-chip" data-example="magnifying">Magnifier</button>
                        <button type="button" class="lm-example-chip" data-example="div-basic">Diverging</button>
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
                <div class="tool-empty-state" id="lm-empty-state" style="display:none;">
                    <h3>Adjust sliders to see results</h3>
                </div>
                <div id="lm-results-container"></div>
            </div>
            <div class="tool-result-actions" id="lm-result-actions" style="display:none;gap:0.5rem;padding:0.75rem 1rem;border-top:1px solid var(--border)">
                <button type="button" class="tool-action-btn" id="lm-share-btn" style="flex:1">Share Link</button>
                <button type="button" class="tool-action-btn" id="lm-save-png-btn" style="flex:1;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Save PNG</button>
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
        <%@ include file="../../modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Advanced Optics Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            <span style="font-size:1.3rem;">&#128300;</span> Advanced Optics Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/physics/ray-optics-simulator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#6366f1,#8b5cf6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&#128171;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Ray Optics Simulator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Full ray tracing simulation with multiple lenses, mirrors, prisms, and light sources on an interactive canvas</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/physics/optical-designer.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&#128208;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Optical System Designer</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Design multi-element optical systems with aberration analysis, MTF curves, and lens optimization</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Related Tools -->
<jsp:include page="/modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="exams/visual-physics/lens-ray-diagram.jsp"/>
    <jsp:param name="keyword" value="physics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<%@ include file="../../modern/components/support-section.jsp" %>

<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
        </div>
    </div>
</footer>

<%@ include file="../../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../../modern/components/analytics.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>

<!-- Lens-Mirror Calculator core (same as lens-mirror-calculator.jsp) -->
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-lens-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-lens-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-lens-core.js?v=<%=cacheVersion%>"></script>

</body>
</html>
