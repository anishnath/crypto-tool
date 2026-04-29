<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Vector Calculus Calculator — fifth tool migrated to math-studio shell.
        Pragmatic minimal-shell migration: wraps existing vc-* markup
        verbatim. No MathLive — vc has 3 separate inputs (Fx, Fy, Fz)
        for vector field components, which doesn't fit the single
        math-field ic-* contract.

        Build contract:
          · SEO params: ported VERBATIM from vector-calculus-calculator.jsp
            (17 schema entries incl. 6 FAQ pairs)
          · Sidebar tree, ms-rail, matter-bg backdrop
          · Visible FAQ accordion mirroring faqNq/faqNa params
          · All vc-* IDs preserved so vector-calculus-calculator.js works
            unchanged

        See math/MIGRATION_TEMPLATE.md.
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Vector Calculus Calculator - Gradient, Divergence, Curl with Steps" />
        <jsp:param name="toolDescription" value="Free online vector calculus calculator. Compute gradient, divergence, and curl of scalar and vector fields with detailed step-by-step solutions. Features 3D vector field visualization, LaTeX output, built-in Python compiler, and 1500+ printable practice problems covering vectors, dot product, cross product, vector functions, derivatives, and integrals. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="vector-calculus-calculator.jsp" />
        <jsp:param name="toolKeywords" value="vector calculus calculator, gradient calculator, divergence calculator, curl calculator, nabla operator, del operator, vector field calculator, partial derivatives, multivariable calculus, vector calculus practice problems, dot product worksheet, cross product practice, vector calculus worksheet, step by step vector calculus, 3D vector visualization" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Gradient of scalar fields with steps,Divergence of vector fields with steps,Curl of vector fields with steps,1500+ printable practice problems (18 types),3D cone plot visualization,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the gradient of a scalar field?" />
        <jsp:param name="faq1a" value="The gradient of a scalar field f(x,y,z) is a vector field that points in the direction of the greatest rate of increase of f. It is computed as nabla f = (df/dx, df/dy, df/dz). For example, the gradient of f = x^2 + y^2 + z^2 is (2x, 2y, 2z)." />
        <jsp:param name="faq2q" value="What is the divergence of a vector field?" />
        <jsp:param name="faq2a" value="The divergence of a vector field F = (Fx, Fy, Fz) is a scalar that measures the rate at which the field spreads out from a point. It is computed as nabla dot F = dFx/dx + dFy/dy + dFz/dz. A positive divergence indicates a source, negative indicates a sink." />
        <jsp:param name="faq3q" value="What is the curl of a vector field?" />
        <jsp:param name="faq3a" value="The curl of a vector field F measures its tendency to rotate around a point. It is computed using the determinant formula involving partial derivatives. If curl F = 0, the field is conservative (irrotational). For example, curl(-y, x, 0) = (0, 0, 2), indicating uniform rotation." />
        <jsp:param name="faq4q" value="How do I enter expressions into this calculator?" />
        <jsp:param name="faq4a" value="Use standard math notation: x^2 for x squared, sin(x) for sine, e^z for exponential, sqrt(x) for square root, x*y for multiplication. The calculator supports polynomials, trigonometric, exponential, logarithmic, and hyperbolic functions. A live KaTeX preview shows your expression as rendered math." />
        <jsp:param name="faq5q" value="Does this calculator show step-by-step solutions?" />
        <jsp:param name="faq5a" value="Yes. After computing a result, click Show Steps to see a detailed solution showing each partial derivative computation, simplification, and final assembly of the result vector. Steps are rendered with full LaTeX math notation." />
        <jsp:param name="faq6q" value="Does this tool have practice worksheets?" />
        <jsp:param name="faq6a" value="Yes. Click Print Worksheet to generate a printable practice sheet from a bank of 1500+ problems across 18 types: vectors from points, dot product, cross product, unit vectors, vector projections, direction cosines, angle between vectors, vector function derivatives, integrals, limits, and more. Each worksheet includes an answer key." />
    </jsp:include>

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">

    <!-- Math shell -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=cacheVersion%>">

    <!-- Tool-specific CSS (vc-* mode toggle, vector field inputs, edu cards) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/vector-calculus-calculator.css?v=<%=cacheVersion%>">

    <!-- KaTeX + MathLive + image-to-math -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=cacheVersion%>">

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

        <% request.setAttribute("activeService", "vector-calculus"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Vector Calculus</span>
                </nav>
                <h1>Vector Calculus Calculator</h1>
            </header>

            <%-- Two-column input/output grid (no separate ads column — rail handles ads). --%>
            <div class="tool-page-container" style="grid-template-columns:minmax(300px,400px) minmax(0,1fr); max-width:none; padding:0; margin:0; min-height:0;">

                <!-- ========== INPUT COLUMN ========== -->
                <div class="tool-input-column">
                    <div class="tool-card">
                        <div class="tool-card-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                                <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                                <path d="M2 17l10 5 10-5"/>
                                <path d="M2 12l10 5 10-5"/>
                            </svg>
                            Vector Calculus
                        </div>
                        <div class="tool-card-body">
                            <!-- Mode toggle -->
                            <div class="vc-mode-toggle">
                                <button type="button" class="vc-mode-btn active" data-mode="gradient">Gradient</button>
                                <button type="button" class="vc-mode-btn" data-mode="divergence">Divergence</button>
                                <button type="button" class="vc-mode-btn" data-mode="curl">Curl</button>
                            </div>

                            <!-- Visual/Text mode toggle + Scan button — shared across scalar AND Fx/Fy/Fz -->
                            <div style="display:flex;align-items:center;justify-content:space-between;gap:0.5rem;margin-bottom:0.5rem;flex-wrap:wrap;">
                                <span class="tool-form-label" style="margin-bottom:0;">Input</span>
                                <div style="display:flex;gap:0.5rem;align-items:center;">
                                    <div class="ic-input-mode-toggle" data-mml-toggle role="radiogroup" aria-label="Input mode" style="display:inline-flex;border:1px solid var(--border);border-radius:9999px;padding:2px;background:var(--bg-secondary);">
                                        <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually" style="padding:0.2rem 0.6rem;border:none;background:transparent;font-size:0.7rem;font-weight:600;cursor:pointer;border-radius:9999px;">&fnof; Visual</button>
                                        <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type plain text" style="padding:0.2rem 0.6rem;border:none;background:transparent;font-size:0.7rem;font-weight:600;cursor:pointer;border-radius:9999px;font-family:var(--font-mono);">&lt;/&gt; Text</button>
                                    </div>
                                    <button type="button" id="vc-image-btn" title="Scan vector calculus problems from image or PDF" style="padding:0.25rem 0.625rem;border-radius:9999px;border:1.5px solid var(--primary);background:transparent;color:var(--primary);font-size:0.75rem;font-weight:600;cursor:pointer;">&#128247; Scan</button>
                                </div>
                            </div>

                            <!-- Scalar field input (gradient mode) — MathLive Visual + Text -->
                            <div id="vc-scalar-wrap">
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="vc-scalar-expr">Scalar field f(x, y, z)</label>
                                    <div class="mml-pair">
                                        <math-field class="mml-mathfield" aria-label="Scalar field for gradient"
                                                    placeholder="x^2+y^2+z^2"
                                                    smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                                        <input type="text" class="tool-input tool-input-mono mml-text" id="vc-scalar-expr" placeholder="e.g. x^2 + y^2 + z^2" autocomplete="off" spellcheck="false">
                                    </div>
                                    <span class="tool-form-hint">Enter a function of x, y, z</span>
                                </div>
                            </div>

                            <!-- Vector field inputs (divergence/curl mode) — three MathLive pairs -->
                            <div id="vc-vector-wrap" style="display:none;">
                                <div class="vc-vector-fields">
                                    <div class="vc-vector-field-group">
                                        <span class="vc-vector-field-label">F<sub>x</sub></span>
                                        <div class="mml-pair">
                                            <math-field class="mml-mathfield" aria-label="Fx component"
                                                        placeholder="x^2 y"
                                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                                            <input type="text" class="tool-input tool-input-mono mml-text" id="vc-fx" placeholder="e.g. x^2*y" autocomplete="off" spellcheck="false">
                                        </div>
                                    </div>
                                    <div class="vc-vector-field-group">
                                        <span class="vc-vector-field-label">F<sub>y</sub></span>
                                        <div class="mml-pair">
                                            <math-field class="mml-mathfield" aria-label="Fy component"
                                                        placeholder="y z"
                                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                                            <input type="text" class="tool-input tool-input-mono mml-text" id="vc-fy" placeholder="e.g. y*z" autocomplete="off" spellcheck="false">
                                        </div>
                                    </div>
                                    <div class="vc-vector-field-group">
                                        <span class="vc-vector-field-label">F<sub>z</sub></span>
                                        <div class="mml-pair">
                                            <math-field class="mml-mathfield" aria-label="Fz component"
                                                        placeholder="x z^2"
                                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                                            <input type="text" class="tool-input tool-input-mono mml-text" id="vc-fz" placeholder="e.g. x*z^2" autocomplete="off" spellcheck="false">
                                        </div>
                                    </div>
                                </div>
                                <span class="tool-form-hint" style="display:block;margin-top:0.25rem;">Enter components of vector field <strong>F</strong> = F<sub>x</sub><strong>i</strong> + F<sub>y</sub><strong>j</strong> + F<sub>z</sub><strong>k</strong></span>
                            </div>

                            <!-- Live preview -->
                            <div class="tool-form-group" style="margin-top:0.875rem;">
                                <label class="tool-form-label">Live Preview</label>
                                <div class="vc-preview" id="vc-preview">
                                    <span style="color:var(--text-muted);font-size:0.8125rem;">Type a scalar field above&hellip;</span>
                                </div>
                            </div>

                            <!-- Action buttons -->
                            <div class="vc-action-row">
                                <button type="button" class="tool-action-btn vc-compute-btn" id="vc-compute-btn" data-mml-submit>Compute</button>
                                <button type="button" class="vc-random-btn" id="vc-random-btn" title="Random example">&#127922; Random</button>
                            </div>

                            <hr class="vc-sep">

                            <!-- Quick examples -->
                            <div class="tool-form-group">
                                <label class="tool-form-label">Quick Examples</label>
                                <div class="vc-examples" id="vc-examples"></div>
                            </div>

                            <hr class="vc-sep">

                            <!-- Syntax help (collapsible) -->
                            <div id="vc-syntax-wrap">
                                <button type="button" class="vc-syntax-toggle" id="vc-syntax-btn">
                                    Syntax Help
                                    <svg class="vc-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                                </button>
                                <div class="vc-syntax-content" id="vc-syntax-content">
                                    x^2 &nbsp;&nbsp; y^3 &nbsp;&nbsp; z^2<br>
                                    sin(x) &nbsp;&nbsp; cos(y) &nbsp;&nbsp; tan(z)<br>
                                    e^x &nbsp;&nbsp; e^(x*y) &nbsp;&nbsp; exp(z)<br>
                                    log(x) = ln(x) &nbsp;&nbsp; sqrt(x)<br>
                                    x*y &nbsp;&nbsp; x*y*z &nbsp;&nbsp; 3*x^2<br>
                                    <strong>Multiplication:</strong> Use * explicitly: <code>x*y</code> not <code>xy</code><br>
                                    <strong>Powers:</strong> <code>x^2</code> or <code>x^(2/3)</code><br>
                                    <strong>Constants:</strong> pi, e
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ========== OUTPUT COLUMN ========== -->
                <div class="tool-output-column">
                    <!-- Tab bar -->
                    <div class="vc-output-tabs">
                        <button type="button" class="vc-output-tab active" data-panel="result">Result</button>
                        <button type="button" class="vc-output-tab" data-panel="graph">3D Graph</button>
                        <button type="button" class="vc-output-tab" data-panel="python">Python Compiler</button>
                    </div>

                    <!-- Result Panel -->
                    <div class="vc-panel active" id="vc-panel-result">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-header">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                                </svg>
                                <h4>Result</h4>
                            </div>
                            <div class="tool-result-content" id="vc-result-content">
                                <div class="tool-empty-state" id="vc-empty-state">
                                    <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8711;</div>
                                    <h3>Enter a field and click Compute</h3>
                                    <p>Compute gradient, divergence, or curl with step-by-step solutions.</p>
                                </div>
                            </div>
                            <div class="tool-result-actions" id="vc-result-actions">
                                <button type="button" class="tool-action-btn" id="vc-copy-latex-btn">
                                    <span>&#128203;</span> Copy LaTeX
                                </button>
                                <button type="button" class="tool-action-btn" id="vc-download-pdf-btn">
                                    <span>&#128196;</span> Download PDF
                                </button>
                                <button type="button" class="tool-action-btn" id="vc-share-btn">
                                    <span>&#128279;</span> Share
                                </button>
                                <button type="button" class="tool-action-btn" id="vc-worksheet-btn">
                                    <span>&#128218;</span> Print Worksheet
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Graph Panel -->
                    <div class="vc-panel" id="vc-panel-graph">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                            <div class="tool-result-header">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                                    <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                                </svg>
                                <h4>3D Vector Field</h4>
                            </div>
                            <div style="flex:1;min-height:0;padding:0.75rem;">
                                <div id="vc-graph-container"></div>
                                <p id="vc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a gradient or curl to see its 3D vector field.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Python Compiler Panel -->
                    <div class="vc-panel" id="vc-panel-python">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                            <div class="tool-result-header">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                                    <polygon points="5 3 19 12 5 21 5 3"/>
                                </svg>
                                <h4>Python Compiler</h4>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="vc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
            <section class="tool-expertise-section" style="margin:2rem 0;">

                <!-- What is Vector Calculus? -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is Vector Calculus?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Vector calculus extends single-variable calculus to fields in two and three dimensions. The three fundamental operations are the <strong>gradient</strong>, <strong>divergence</strong>, and <strong>curl</strong>, all defined using the del operator &nabla;.</p>
                    <p style="color:var(--text-secondary);margin-bottom:0;line-height:1.7;">These operations are essential in physics (electromagnetism, fluid dynamics, thermodynamics) and engineering (signal processing, computer graphics, robotics).</p>
                </div>

                <!-- Operations Summary -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">The Three Operations</h2>
                    <table style="width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem;">
                        <thead>
                        <tr style="background:var(--bg-secondary);"><th style="padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border);font-weight:600;color:var(--text-primary);">Operation</th><th style="padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border);font-weight:600;color:var(--text-primary);">Input</th><th style="padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border);font-weight:600;color:var(--text-primary);">Output</th><th style="padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border);font-weight:600;color:var(--text-primary);">Formula</th></tr>
                        </thead>
                        <tbody>
                        <tr><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);font-weight:500;">Gradient &nabla;f</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);">Scalar field</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);">Vector field</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);font-family:var(--font-mono);font-size:0.75rem;">(&part;f/&part;x, &part;f/&part;y, &part;f/&part;z)</td></tr>
                        <tr><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);font-weight:500;">Divergence &nabla;&middot;F</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);">Vector field</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);">Scalar</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);font-family:var(--font-mono);font-size:0.75rem;">&part;F<sub>x</sub>/&part;x + &part;F<sub>y</sub>/&part;y + &part;F<sub>z</sub>/&part;z</td></tr>
                        <tr><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);font-weight:500;">Curl &nabla;&times;F</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);">Vector field</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);">Vector field</td><td style="padding:0.5rem 0.75rem;border-bottom:1px solid var(--border);color:var(--text-secondary);font-family:var(--font-mono);font-size:0.75rem;">det[i,j,k; &part;x,&part;y,&part;z; Fx,Fy,Fz]</td></tr>
                        </tbody>
                    </table>
                </div>

                <!-- Key Identities -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Vector Calculus Identities</h2>
                    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1rem;margin-top:1rem;">
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;border-left:3px solid #4f46e5;"><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Curl of Gradient = 0</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">&nabla; &times; (&nabla;f) = <strong>0</strong> for any smooth scalar field f. Gradient fields are always irrotational.</p></div>
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;border-left:3px solid #6366f1;"><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Divergence of Curl = 0</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">&nabla; &middot; (&nabla; &times; F) = <strong>0</strong> for any smooth vector field F. Curl fields are always solenoidal.</p></div>
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;border-left:3px solid #818cf8;"><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Laplacian</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">&nabla;&sup2;f = &nabla; &middot; (&nabla;f) = &part;&sup2;f/&part;x&sup2; + &part;&sup2;f/&part;y&sup2; + &part;&sup2;f/&part;z&sup2;. The divergence of the gradient.</p></div>
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;border-left:3px solid #a5b4fc;"><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Divergence Theorem</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">&oiint; F &middot; dS = &oiiint; (&nabla; &middot; F) dV. Relates surface integral to volume integral.</p></div>
                    </div>
                </div>

                <!-- Applications -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Applications</h2>
                    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1rem;">
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Electromagnetism</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">Maxwell's equations use gradient, divergence, and curl to describe electric and magnetic fields.</p></div>
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127754;</div><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Fluid Dynamics</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">Divergence measures fluid expansion/compression. Curl measures fluid rotation (vorticity).</p></div>
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127777;</div><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Heat Transfer</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">The gradient of temperature gives the direction of heat flow. Fourier's law: q = -k&nabla;T.</p></div>
                        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1.25rem;text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div><h4 style="font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem;">Optimization</h4><p style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0;">The gradient points in the direction of steepest ascent. Gradient descent finds minima of cost functions.</p></div>
                    </div>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params above. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Vector calculus calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the gradient of a scalar field?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>gradient</strong> of a scalar field <em>f(x,y,z)</em> is a vector field that points in the direction of the greatest rate of increase of <em>f</em>. It is computed as <em>&nabla;f = (&part;f/&part;x, &part;f/&part;y, &part;f/&part;z)</em>. For example, the gradient of <em>f = x&sup2; + y&sup2; + z&sup2;</em> is <em>(2x, 2y, 2z)</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the divergence of a vector field?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>divergence</strong> of a vector field <em>F = (F<sub>x</sub>, F<sub>y</sub>, F<sub>z</sub>)</em> is a scalar measuring the rate at which the field spreads out from a point: <em>&nabla;&middot;F = &part;F<sub>x</sub>/&part;x + &part;F<sub>y</sub>/&part;y + &part;F<sub>z</sub>/&part;z</em>. Positive divergence indicates a source; negative indicates a sink.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the curl of a vector field?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>curl</strong> of a vector field <em>F</em> measures its tendency to rotate around a point. It is computed using the determinant formula involving partial derivatives. If <em>curl F = 0</em> the field is <em>conservative</em> (irrotational). For example, <em>curl(&minus;y, x, 0) = (0, 0, 2)</em>, indicating uniform rotation.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do I enter expressions into this calculator?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Use standard math notation: <code>x^2</code> for squared, <code>sin(x)</code>, <code>e^z</code>, <code>sqrt(x)</code>, <code>x*y</code> for multiplication. Polynomials, trig, exponential, log, and hyperbolic functions all work. A live KaTeX preview shows your expression as rendered math.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this calculator show step-by-step solutions?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; after computing a result, click <strong>Show Steps</strong> for a detailed solution showing each partial derivative, simplification, and final assembly of the result vector. Steps are rendered with full LaTeX math notation.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this tool have practice worksheets?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click <strong>Print Worksheet</strong> for a printable practice sheet from a bank of <strong>1,500+ problems</strong> across 18 types: vectors from points, dot product, cross product, unit vectors, vector projections, direction cosines, angle between vectors, vector function derivatives, integrals, limits, and more. Each worksheet includes an answer key.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

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

    <%--
        Canonical 3-partial load order:
          1. math-libs                          — CDN deps (KaTeX, nerdamer, plotly loader, image-to-math)
          2. vector-calculus-calculator-scripts — worksheet, main controller, image-scan init
          3. math-input-multi                   — MathLive ES module + multi-pair Visual/Text toggle
                                                  (4 pairs: scalar + Fx + Fy + Fz)
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/vector-calculus-calculator-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-multi.jsp" />

    <script>
    // FAQ accordion
    (function () {
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () {
                q.closest('.ms-faq-item').classList.toggle('open');
            });
        });
    })();
    </script>
</body>
</html>
