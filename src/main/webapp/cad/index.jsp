<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="CAD and 3D Design Tools - Free Online Parametric Modeling" />
        <jsp:param name="toolCategory" value="CAD & 3D Design" />
        <jsp:param name="toolDescription" value="Free online CAD and 3D design tools. Parametric 3D modeling with JavaScript, export to STL for 3D printing. Boolean CSG, extrusions, and built-in presets. No signup required." />
        <jsp:param name="toolUrl" value="cad/" />
        <jsp:param name="toolKeywords" value="cad tools, 3d design, parametric modeling, stl export, 3d printing, jscad, free cad, online 3d modeler" />
        <jsp:param name="toolFeatures" value="Parametric 3D modeling with JavaScript,Export STL OBJ DXF for 3D printing,Boolean CSG operations,Built-in presets with sliders,Free no signup required" />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "CAD & 3D Design Tools",
      "description": "Free online CAD and 3D design tools for parametric modeling and 3D printing.",
      "url": "https://8gwifi.org/cad/",
      "mainEntity": {
        "@type": "ItemList",
        "numberOfItems": 1,
        "itemListElement": [
          {"@type": "ListItem", "position": 1, "name": "3D CAD Modeler (JSCAD)", "url": "https://8gwifi.org/cad/3d-modeler/"}
        ]
      }
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    </noscript>

    <style>
        .cad-idx-bc { padding: calc(var(--header-height-desktop, 72px) + 0.5rem) 2rem 0.5rem; font-size: 0.8125rem; color: #94a3b8; }
        .cad-idx-bc a { color: #64748b; text-decoration: none; }
        .cad-idx-bc a:hover { color: #0f172a; text-decoration: underline; }
        .cad-idx-bc .sep { margin: 0 0.375rem; color: #cbd5e1; }
        .cad-idx-bc .current { color: #0f172a; font-weight: 500; }

        .cad-idx-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 40%, #312e81 100%);
            padding: 4rem 2rem;
            text-align: center;
        }
        .cad-idx-hero h1 { font-size: clamp(1.75rem, 4vw, 2.5rem); font-weight: 800; color: #fff; margin-bottom: 0.75rem; letter-spacing: -0.02em; }
        .cad-idx-hero p { font-size: 1.0625rem; color: #cbd5e1; max-width: 600px; margin: 0 auto; line-height: 1.6; }

        .cad-idx-tools { max-width: 900px; margin: 0 auto; padding: 3rem 2rem 4rem; display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; }
        .cad-idx-card {
            background: #fff; border: 1px solid #e2e8f0; border-radius: 0.75rem;
            padding: 2rem 1.5rem; text-decoration: none; transition: transform 0.15s, box-shadow 0.15s, border-color 0.15s;
            display: flex; flex-direction: column; gap: 0.75rem;
        }
        .cad-idx-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(99,102,241,0.12); border-color: #a5b4fc; }
        .cad-idx-card-icon { width: 48px; height: 48px; border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #6366f1, #8b5cf6); }
        .cad-idx-card h2 { font-size: 1.25rem; font-weight: 700; color: #0f172a; margin: 0; }
        .cad-idx-card p { font-size: 0.875rem; color: #64748b; line-height: 1.6; margin: 0; flex: 1; }
        .cad-idx-tags { display: flex; flex-wrap: wrap; gap: 0.375rem; }
        .cad-idx-tag { font-size: 0.6875rem; font-weight: 500; padding: 0.25rem 0.625rem; border-radius: 9999px; background: #f1f5f9; color: #475569; }
        .cad-idx-cta { font-size: 0.8125rem; font-weight: 600; color: #6366f1; }

        [data-theme="dark"] .cad-idx-bc a { color: #94a3b8; }
        [data-theme="dark"] .cad-idx-bc .current { color: #e2e8f0; }
        [data-theme="dark"] .cad-idx-card { background: #1e293b; border-color: rgba(255,255,255,0.08); }
        [data-theme="dark"] .cad-idx-card:hover { border-color: #6366f1; }
        [data-theme="dark"] .cad-idx-card h2 { color: #f1f5f9; }
        [data-theme="dark"] .cad-idx-card p { color: #94a3b8; }
        [data-theme="dark"] .cad-idx-tag { background: rgba(255,255,255,0.06); color: #cbd5e1; }
    </style>
</head>
<body>

    <%@ include file="../modern/components/nav-header.jsp" %>

    <nav class="cad-idx-bc" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
        <span class="sep">/</span>
        <span class="current">CAD &amp; 3D Design</span>
    </nav>

    <div class="cad-idx-hero">
        <h1>CAD &amp; 3D Design Tools</h1>
        <p>Parametric 3D modeling in your browser. Design, preview, and export models for 3D printing and CNC. No signup required.</p>
    </div>

    <div class="cad-idx-tools">
        <a href="<%=request.getContextPath()%>/cad/3d-modeler/" class="cad-idx-card">
            <div class="cad-idx-card-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M12 2L2 7l10 5 10-5-10-5z" stroke="#fff" stroke-width="2" stroke-linejoin="round"/><path d="M2 17l10 5 10-5" stroke="#fff" stroke-width="2" stroke-linejoin="round"/><path d="M2 12l10 5 10-5" stroke="#fff" stroke-width="2" stroke-linejoin="round"/></svg>
            </div>
            <h2>3D CAD Modeler</h2>
            <p>Parametric 3D modeling with JavaScript (JSCAD). Boolean CSG, extrusions, 15+ primitives. Built-in presets for gears, enclosures, and more. Export to STL, OBJ, DXF.</p>
            <div class="cad-idx-tags">
                <span class="cad-idx-tag">JSCAD</span>
                <span class="cad-idx-tag">STL Export</span>
                <span class="cad-idx-tag">Parametric</span>
                <span class="cad-idx-tag">3D Printing</span>
            </div>
            <span class="cad-idx-cta">Open 3D Modeler &rarr;</span>
        </a>
    </div>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>

</body>
</html>
