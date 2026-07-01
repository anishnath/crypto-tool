<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String v = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Vector Calculator - Dot Product, Cross Product &amp; Magnitude" />
        <jsp:param name="toolDescription" value="Free vector calculator with step-by-step solutions. Dot product, cross product, magnitude, unit vector, projection &amp; angle for 2D and 3D vectors. Math AI tutor + chat solver." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="vector-calculator.jsp" />
        <jsp:param name="toolKeywords" value="vector calculator, dot product calculator, cross product calculator, vector magnitude, angle between vectors, vector projection, unit vector calculator, vector addition, scalar multiplication, linear algebra calculator, 3D vector calculator" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Add subtract and scale vectors,Dot product with step-by-step solution,Cross product using determinant method,Magnitude and unit vector computation,Angle between vectors,Vector projection and rejection,Parallelogram area calculation,Triple scalar product,Linear independence check,2D and 3D mode toggle,Interactive Plotly graph,Python NumPy code generation,Math AI tutor in chat" />
        <jsp:param name="teaches" value="Vector arithmetic, dot product, cross product, vector projection, linear independence, parallelogram area, triple scalar product" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose dimension|Select 2D or 3D mode depending on your vectors,Select operation|Pick from 13 operations like Add Dot Product Cross Product Magnitude Projection,Enter vector components|Type x y and z values for each vector in the input fields,Click Calculate|Click Calculate to see the step-by-step solution with LaTeX rendering,View graph|Switch to Graph tab for interactive 2D or 3D visualization of your vectors,Export result|Copy LaTeX or generate NumPy Python code for your computation" />
        <jsp:param name="faq1q" value="What is the dot product of two vectors?" />
        <jsp:param name="faq1a" value="The dot product of vectors a and b is the sum of the products of their corresponding components: a dot b = a1*b1 + a2*b2 + a3*b3. It returns a scalar. If the dot product is zero the vectors are perpendicular (orthogonal). The dot product also equals |a||b|cos(theta) where theta is the angle between them." />
        <jsp:param name="faq2q" value="How do you compute the cross product?" />
        <jsp:param name="faq2a" value="The cross product a x b is computed using the determinant of a 3x3 matrix with unit vectors i j k in the first row and the components of a and b in the second and third rows. The result is a new vector perpendicular to both a and b. The cross product is only defined for 3D vectors." />
        <jsp:param name="faq3q" value="What is vector projection?" />
        <jsp:param name="faq3a" value="The projection of vector b onto vector a gives the component of b in the direction of a. The formula is proj_a(b) = (a dot b)/(a dot a) times a. The rejection is the complementary component: rej_a(b) = b minus proj_a(b). Together projection plus rejection reconstruct the original vector b." />
        <jsp:param name="faq4q" value="How do you find the angle between two vectors?" />
        <jsp:param name="faq4a" value="Use the formula theta = arccos((a dot b) / (|a| * |b|)). First compute the dot product and the magnitudes of both vectors then divide and take the inverse cosine. The result is in radians. Multiply by 180/pi to convert to degrees. Our calculator shows every step." />
        <jsp:param name="faq5q" value="What does it mean for vectors to be linearly independent?" />
        <jsp:param name="faq5a" value="Two vectors are linearly independent if neither is a scalar multiple of the other. In 2D check if the determinant of the matrix formed by the vectors is nonzero. In 3D check if their cross product is nonzero. Linearly independent vectors span the full space and form a basis." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/vector-calculator.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/vector-calculator-studio.css?v=<%=v%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>
    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<%@ include file="modern/components/nav-header.jsp" %>
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "vector"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Vector Calculator</span>
            </nav>
            <h1>Vector Calculator with Steps</h1>
            <p class="ms-subtitle">Dot &middot; cross &middot; magnitude &middot; projection &middot; 13 ops &middot; 2D/3D graph &middot; NumPy export</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact vc-hero" id="vc-hero-card">
                <div class="vc-hero-top">
                    <div class="vc-hero-badges">
                        <span class="vc-badge">13 Operations</span>
                        <span class="vc-badge">2D &amp; 3D</span>
                        <span class="vc-badge">Step-by-Step</span>
                        <span class="vc-badge">Plotly Graph</span>
                    </div>
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — vector tutor + dot/cross solver in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>

                <div class="vc-hero-row">
                    <div class="tool-form-group" style="margin:0;">
                        <label class="tool-form-label">Dimension</label>
                        <div class="vc-dim-toggle">
                            <button type="button" class="vc-dim-btn" data-dim="2">2D</button>
                            <button type="button" class="vc-dim-btn active" data-dim="3">3D</button>
                        </div>
                    </div>
                </div>

                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">Operation</label>
                    <div class="vc-mode-toggle">
                        <button type="button" class="vc-mode-btn active" data-mode="add">Add</button>
                        <button type="button" class="vc-mode-btn" data-mode="subtract">Sub</button>
                        <button type="button" class="vc-mode-btn" data-mode="scalar_multiply">Scale</button>
                        <button type="button" class="vc-mode-btn" data-mode="dot_product">Dot</button>
                        <button type="button" class="vc-mode-btn" data-mode="cross_product">Cross</button>
                        <button type="button" class="vc-mode-btn" data-mode="magnitude">|v|</button>
                        <button type="button" class="vc-mode-btn" data-mode="unit_vector">Unit</button>
                        <button type="button" class="vc-mode-btn" data-mode="angle">Angle</button>
                        <button type="button" class="vc-mode-btn" data-mode="projection">Proj</button>
                        <button type="button" class="vc-mode-btn" data-mode="rejection">Rej</button>
                        <button type="button" class="vc-mode-btn" data-mode="area">Area</button>
                        <button type="button" class="vc-mode-btn" data-mode="triple_scalar">Triple</button>
                        <button type="button" class="vc-mode-btn" data-mode="linear_independence">Indep</button>
                    </div>
                </div>

                <div class="vc-vector-input">
                    <label class="vc-vector-label">Vector a</label>
                    <div class="vc-vector-row">
                        <span class="vc-comp-label">x</span>
                        <input type="number" id="vc-ax" value="1" step="any" autocomplete="off">
                        <span class="vc-comp-label">y</span>
                        <input type="number" id="vc-ay" value="2" step="any" autocomplete="off">
                        <span class="vc-comp-label vc-z-field">z</span>
                        <input type="number" id="vc-az" value="3" step="any" autocomplete="off" class="vc-z-field">
                    </div>
                </div>

                <div class="vc-vector-input" id="vc-vecb-group">
                    <label class="vc-vector-label">Vector b</label>
                    <div class="vc-vector-row">
                        <span class="vc-comp-label">x</span>
                        <input type="number" id="vc-bx" value="4" step="any" autocomplete="off">
                        <span class="vc-comp-label">y</span>
                        <input type="number" id="vc-by" value="-1" step="any" autocomplete="off">
                        <span class="vc-comp-label vc-z-field">z</span>
                        <input type="number" id="vc-bz" value="2" step="any" autocomplete="off" class="vc-z-field">
                    </div>
                </div>

                <div class="vc-vector-input" id="vc-vecc-group" style="display:none;">
                    <label class="vc-vector-label">Vector c</label>
                    <div class="vc-vector-row">
                        <span class="vc-comp-label">x</span>
                        <input type="number" id="vc-cx" value="0" step="any" autocomplete="off">
                        <span class="vc-comp-label">y</span>
                        <input type="number" id="vc-cy" value="0" step="any" autocomplete="off">
                        <span class="vc-comp-label vc-z-field">z</span>
                        <input type="number" id="vc-cz" value="0" step="any" autocomplete="off" class="vc-z-field">
                    </div>
                </div>

                <div class="vc-scalar-input" id="vc-scalar-group" style="display:none;">
                    <label class="vc-vector-label">Scalar k</label>
                    <input type="number" id="vc-scalar" value="2" step="any" autocomplete="off">
                </div>

                <div class="tool-form-group" style="margin:0;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="vc-preview" id="vc-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Enter vector components above&hellip;</span></div>
                </div>

                <div class="vc-hero-row">
                    <div class="vc-hero-actions">
                        <button type="button" class="vc-btn vc-btn-primary" id="vc-calc-btn">Calculate</button>
                        <button type="button" class="vc-btn vc-btn-secondary" id="vc-clear-btn">Clear</button>
                    </div>
                </div>

                <div class="tool-form-group" style="margin:0;">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="vc-examples">
                        <button type="button" class="vc-example-chip" data-example="add-3d">Add 3D</button>
                        <button type="button" class="vc-example-chip" data-example="dot-3d">Dot Product</button>
                        <button type="button" class="vc-example-chip" data-example="cross-3d">Cross Product</button>
                        <button type="button" class="vc-example-chip" data-example="mag-2d">|&lt;3,4&gt;|=5</button>
                        <button type="button" class="vc-example-chip" data-example="angle-2d">90&deg; Angle</button>
                        <button type="button" class="vc-example-chip" data-example="proj-2d">Projection</button>
                        <button type="button" class="vc-example-chip" data-example="unit-3d">Unit Vector</button>
                        <button type="button" class="vc-example-chip" data-example="triple-3d">Triple Scalar</button>
                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="vc-output-tabs">
                    <button type="button" class="vc-output-tab active" data-panel="result">Result</button>
                    <button type="button" class="vc-output-tab" data-panel="graph">Graph</button>
                    <button type="button" class="vc-output-tab" data-panel="python">Python</button>
                </div>

                <div class="vc-panel active" id="vc-panel-result">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--vc-tool);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                            <h4>Result</h4>
                        </div>
                        <div class="tool-result-content" id="vc-result-content">
                            <div class="tool-empty-state" id="vc-empty-state">
                                <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&rarr;</div>
                                <h3>Enter vectors and click Calculate</h3>
                                <p>Supports 13 vector operations including dot product, cross product, projection, and more.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="vc-result-actions">
                            <button type="button" class="tool-action-btn" id="vc-copy-latex-btn">&#128203; Copy LaTeX</button>
                            <button type="button" class="tool-action-btn" id="vc-share-btn">&#128279; Share</button>
                        </div>
                    </div>
                </div>

                <div class="vc-panel" id="vc-panel-graph">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                        <div class="tool-result-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--vc-tool);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                            <h4>Interactive Graph</h4>
                        </div>
                        <div style="flex:1;min-height:0;padding:0.75rem;">
                            <div id="vc-graph-container"></div>
                            <p id="vc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate vectors to see the graph.</p>
                        </div>
                    </div>
                </div>

                <div class="vc-panel" id="vc-panel-python">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                        <div class="tool-result-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--vc-tool);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                            <h4>Python (NumPy)</h4>
                        </div>
                        <div style="flex:1;min-height:0;">
                            <iframe id="vc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                        </div>
                    </div>
                </div>
            </div>

            <section class="ic-learn" aria-label="Vector facts">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Dot product</span>
                    <code class="ic-learn-formula">a &middot; b = &sum; a<sub>i</sub>b<sub>i</sub> = |a||b|cos&theta;</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Cross product</span>
                    <code class="ic-learn-formula">a &times; b &perp; a, b &nbsp;|a&times;b| = area</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Projection</span>
                    <code class="ic-learn-formula">proj<sub>a</sub>(b) = [(a&middot;b)/(a&middot;a)] a</code>
                </article>
            </section>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <section class="ms-card" style="padding:1.5rem 1.75rem;">
                <h2 style="font:500 1.25rem var(--ms-font-serif);margin:0 0 0.75rem;">About this vector calculator</h2>
                <p style="font:0.95rem/1.65 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0 0 1rem;">
                    Compute <strong>dot product</strong>, <strong>cross product</strong>, <strong>magnitude</strong>, <strong>unit vector</strong>,
                    <strong>angle</strong>, <strong>projection</strong>, <strong>rejection</strong>, parallelogram <strong>area</strong>,
                    <strong>triple scalar product</strong>, and <strong>linear independence</strong> for 2D and 3D vectors with full LaTeX steps.
                    Use <strong>Math AI</strong> for tutoring or to solve vector problems in chat via <code>```vector```</code> blocks (Solve / Steps chips).
                </p>
                <table class="vc-ops-table">
                    <thead><tr><th>Operation</th><th>Formula</th><th>Returns</th><th>Dim</th></tr></thead>
                    <tbody>
                        <tr><td>Addition</td><td>a + b = (a<sub>i</sub>+b<sub>i</sub>)</td><td>Vector</td><td>2D/3D</td></tr>
                        <tr><td>Dot Product</td><td>&sum; a<sub>i</sub>b<sub>i</sub></td><td>Scalar</td><td>2D/3D</td></tr>
                        <tr><td>Cross Product</td><td>det[&icirc; &jcirc; k&#770;; a; b]</td><td>Vector</td><td>3D</td></tr>
                        <tr><td>Projection</td><td>(a&middot;b/a&middot;a)&middot;a</td><td>Vector</td><td>2D/3D</td></tr>
                        <tr><td>Triple Scalar</td><td>a &middot; (b &times; c)</td><td>Scalar</td><td>3D</td></tr>
                    </tbody>
                </table>
            </section>

            <section class="ms-card" style="padding:1.5rem 1.75rem;margin-top:1.25rem;">
                <h3 style="font:500 1.1rem var(--ms-font-serif);margin:0 0 1rem;">FAQ</h3>
                <div class="ms-faq">
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">What is the dot product of two vectors?</div>
                        <div class="ms-faq-a">The sum of products of corresponding components. Zero means orthogonal. Also equals |a||b|cos(&theta;).</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">How do you compute the cross product?</div>
                        <div class="ms-faq-a">Use the 3&times;3 determinant with &icirc;, &jcirc;, k&#770; in the first row. Result is perpendicular to both inputs (3D only).</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">What is vector projection?</div>
                        <div class="ms-faq-a">proj<sub>a</sub>(b) = (a&middot;b)/(a&middot;a) &times; a gives the component of b along a; rejection is the orthogonal remainder.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">How do you find the angle between two vectors?</div>
                        <div class="ms-faq-a">&theta; = arccos((a&middot;b)/(|a||b|)). The calculator shows radians and degrees.</div>
                    </div>
                </div>
            </section>

        </div>
    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/js/vector-calculator-graph.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/js/vector-calculator-export.js?v=<%=v%>"></script>
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<script src="<%=request.getContextPath()%>/js/vector-calculator-core.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js?v=<%=v%>" defer></script>

<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureVectorMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>

<script>
(function(){
    document.querySelectorAll('.ms-faq-q').forEach(function(q){
        q.addEventListener('click', function(){ this.parentElement.classList.toggle('open'); });
    });
})();
</script>
</body>
</html>
