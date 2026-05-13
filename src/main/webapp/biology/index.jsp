<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="3D Biology Tools — 12 Cells, Every Organelle Clickable (Free)" />
        <jsp:param name="toolCategory" value="Biology Tools" />
        <jsp:param name="toolDescription" value="Click any organelle, in 3D. 12 cells — plant, animal, neuron, sperm, virus + 7 more — with real microscopy, AI tutor, and cross-section slicer. Free, browser-only, no signup." />
        <jsp:param name="toolUrl" value="biology/" />
        <jsp:param name="toolKeywords" value="3d cell viewer, interactive biology, online biology tools, cell atlas 3d, organelle viewer, plant cell 3d, animal cell 3d, neuron 3d, bacteria cell 3d, sperm cell 3d, yeast cell, virus particle 3d, cardiomyocyte, red blood cell, cell biology interactive, free biology learning, click organelle, microscopy photos, nih 3d, cell anatomy" />
        <jsp:param name="toolImage" value="biology-studio-og.png" />
        <jsp:param name="toolFeatures" value="3D cell viewer,Per-organelle highlight + cross-section,12 cell specimens,NIH 3D GLB models,Comparative cell view,Step-by-step biological notes,Mobile responsive,100% free" />
        <jsp:param name="teaches" value="Cell biology, organelle function, prokaryote vs eukaryote, plant vs animal cell differences, 3D anatomy" />
        <jsp:param name="educationalLevel" value="Middle School, High School, Undergraduate" />
        <jsp:param name="faq1q" value="What biology tools are available here?" />
        <jsp:param name="faq1a" value="Currently the Cell Atlas 3D — a 3D interactive viewer for twelve cell types: plant, animal, neuron, bacteria, white blood, red blood, epithelial, muscle, cardiomyocyte (heart muscle), sperm, yeast (fungal), and a virus particle. More biology tools (DNA viewer, mitosis walkthrough, Punnett square, Hardy-Weinberg, food web, codon table) are planned and listed in the sidebar." />
        <jsp:param name="faq2q" value="Are the biology tools free?" />
        <jsp:param name="faq2a" value="Yes — every tool here is free, browser-only, and requires no signup. The 3D models load once and run on your device using WebGL." />
        <jsp:param name="faq3q" value="Where do the 3D cell models come from?" />
        <jsp:param name="faq3a" value="Three of the cells (Animal, Neuron, Bacteria Wall) use real GLB models from the NIH 3D Print Exchange under their CC BY-NC-SA 4.0 license. The other four (plant, white-blood, epithelial, muscle) use procedural Three.js geometry tuned to each cell type's characteristic shape." />
        <jsp:param name="faq4q" value="Do these biology tools work on mobile?" />
        <jsp:param name="faq4a" value="Yes. The sidebar collapses into a drawer on narrow screens, the three-column tool layout stacks vertically, and the 3D viewer accepts touch gestures (rotate, pan, pinch-zoom)." />
    </jsp:include>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "CollectionPage",
        "name": "Biology Tools",
        "description": "Free interactive biology tools — 3D cell architecture, organelle viewer, and more.",
        "url": "https://8gwifi.org/biology/",
        "mainEntity": {
            "@type": "ItemList",
            "numberOfItems": 1,
            "itemListElement": [
                {"@type": "ListItem", "position": 1, "name": "Cell Atlas 3D", "url": "https://8gwifi.org/biology/cell-atlas.jsp"}
            ]
        }
    }
    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/biology/css/biology-studio.css?v=<%=v%>">

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

    <% request.setAttribute("activeService", "home"); %>
    <jsp:include page="/biology/partials/sidebar.jsp" />

    <section class="bs-workspace">

        <div class="bs-hero-banner">
            <h1>A quiet place for <em>biology</em>.</h1>
            <p>3D interactive cells, organelle-aware notes, and a growing set of learning tools. KaTeX-free for now &mdash; browser-only, no signup.</p>
            <div class="bs-hero-stats">
                <div class="bs-hero-stat"><strong>12</strong>cell specimens</div>
                <div class="bs-hero-stat"><strong>3</strong>NIH 3D models</div>
                <div class="bs-hero-stat"><strong>free</strong>no signup</div>
            </div>
        </div>

        <!-- Featured tool -->
        <div style="background: var(--bs-panel-bg); border:1px solid var(--bs-line); border-radius: var(--bs-radius); padding:1.5rem; box-shadow: var(--bs-shadow-sm);">
            <h2 class="bs-section-title">Featured</h2>
            <div class="bs-tool-grid">
                <a href="<%=request.getContextPath()%>/biology/cell-atlas.jsp" class="bs-tool-card">
                    <span class="bs-tool-card-icon">&#9678;</span>
                    <span>
                        <span class="bs-tool-card-title">Cell Atlas 3D</span>
                        <span class="bs-tool-card-sub">12 cells, organelle-aware 3D</span>
                    </span>
                </a>
            </div>
        </div>

        <!-- Coming soon -->
        <div style="background: var(--bs-panel-bg); border:1px solid var(--bs-line); border-radius: var(--bs-radius); padding:1.5rem; box-shadow: var(--bs-shadow-sm);">
            <h2 class="bs-section-title">Coming soon</h2>
            <p style="color: var(--bs-muted); margin: 0 0 0.85rem; font-size: 0.9rem;">
                More biology tools on the roadmap. Have a request? Drop it on
                <a href="https://github.com/anishnath/anishnath.github.io/issues" target="_blank" rel="noopener" style="color: var(--bs-accent);">GitHub</a>.
            </p>
            <div class="bs-tool-grid">
                <span class="bs-tool-card is-stub">
                    <span class="bs-tool-card-icon">DNA</span>
                    <span><span class="bs-tool-card-title">DNA Viewer</span>
                          <span class="bs-tool-card-sub">Double-helix + base pairs</span></span>
                </span>
                <span class="bs-tool-card is-stub">
                    <span class="bs-tool-card-icon">&#10070;</span>
                    <span><span class="bs-tool-card-title">Mitosis</span>
                          <span class="bs-tool-card-sub">Phase-by-phase walkthrough</span></span>
                </span>
                <span class="bs-tool-card is-stub">
                    <span class="bs-tool-card-icon">G&#x1d63;</span>
                    <span><span class="bs-tool-card-title">Punnett Square</span>
                          <span class="bs-tool-card-sub">Monohybrid + dihybrid crosses</span></span>
                </span>
                <span class="bs-tool-card is-stub">
                    <span class="bs-tool-card-icon">aa</span>
                    <span><span class="bs-tool-card-title">Codon Table</span>
                          <span class="bs-tool-card-sub">mRNA &rarr; amino acid</span></span>
                </span>
                <span class="bs-tool-card is-stub">
                    <span class="bs-tool-card-icon">&#x1d4d7;</span>
                    <span><span class="bs-tool-card-title">Hardy-Weinberg</span>
                          <span class="bs-tool-card-sub">Allele frequencies</span></span>
                </span>
                <span class="bs-tool-card is-stub">
                    <span class="bs-tool-card-icon">&#x1f33f;</span>
                    <span><span class="bs-tool-card-title">Food Web</span>
                          <span class="bs-tool-card-sub">Trophic level simulator</span></span>
                </span>
            </div>
        </div>

        <%-- In-content ad. --%>
        <div class="bs-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- FAQ -->
        <section class="bs-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="bs-faq-title" id="faqs">Frequently asked</h2>
            <div class="bs-faq" aria-label="Biology tools FAQ">
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        What biology tools are available here?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Currently the <strong>Cell Atlas 3D</strong> &mdash; a 3D interactive viewer for twelve cell types (plant, animal, neuron, bacteria, white blood, red blood, epithelial, muscle, cardiomyocyte, sperm, yeast, virus). More tools (DNA viewer, mitosis, Punnett square, Hardy-Weinberg, food web, codon table) are planned and listed in the sidebar.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        Are these tools free?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Yes. Every tool here is free, browser-only, and requires no signup. The 3D models load once and run on your device using WebGL.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        Where do the 3D cell models come from?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Three cells (Animal, Neuron, Bacteria) use real GLB models from the <a href="https://3d.nih.gov" target="_blank" rel="noopener">NIH 3D Print Exchange</a> under their CC BY-NC-SA 4.0 license. The other four use procedural Three.js geometry tuned per cell type.</div>
                </div>
                <div class="bs-faq-item">
                    <button class="bs-faq-q" type="button">
                        Do the tools work on mobile?
                        <svg class="bs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="bs-faq-a">Yes. The sidebar collapses into a drawer on narrow screens, the tool's interior layout stacks vertically, and OrbitControls accepts one-finger rotate / two-finger pan / pinch-zoom.</div>
                </div>
            </div>
        </section>

    </section>
</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>

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
