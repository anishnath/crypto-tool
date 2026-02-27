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
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Vector Calculus Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/vector-calculus-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/vector-calculus-calculator.css?v=<%=cacheVersion%>"></noscript>

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

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS - all async -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- KaTeX -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

</head>
<body>
<!-- Navigation -->
<%@ include file="modern/components/nav-header.jsp" %>

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Vector Calculus Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Vector Calculus Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">3D Visualization</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Compute the <strong>gradient</strong>, <strong>divergence</strong>, and <strong>curl</strong> of scalar and vector fields with <strong>detailed step-by-step solutions</strong>. Features 3D vector field visualization, LaTeX output, and a built-in Python compiler. Essential for multivariable calculus, electromagnetism, and fluid dynamics.</p>
        </div>
    </div>
</section>

<!-- Main Content -->
<main class="tool-page-container">
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

                <!-- Scalar field input (gradient mode) -->
                <div id="vc-scalar-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="vc-scalar-expr">Scalar field f(x, y, z)</label>
                        <input type="text" class="tool-input tool-input-mono" id="vc-scalar-expr" placeholder="e.g. x^2 + y^2 + z^2" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of x, y, z</span>
                    </div>
                </div>

                <!-- Vector field inputs (divergence/curl mode) -->
                <div id="vc-vector-wrap" style="display:none;">
                    <div class="vc-vector-fields">
                        <div class="vc-vector-field-group">
                            <span class="vc-vector-field-label">F<sub>x</sub></span>
                            <input type="text" class="tool-input tool-input-mono" id="vc-fx" placeholder="e.g. x^2*y" autocomplete="off" spellcheck="false">
                        </div>
                        <div class="vc-vector-field-group">
                            <span class="vc-vector-field-label">F<sub>y</sub></span>
                            <input type="text" class="tool-input tool-input-mono" id="vc-fy" placeholder="e.g. y*z" autocomplete="off" spellcheck="false">
                        </div>
                        <div class="vc-vector-field-group">
                            <span class="vc-vector-field-label">F<sub>z</sub></span>
                            <input type="text" class="tool-input tool-input-mono" id="vc-fz" placeholder="e.g. x*z^2" autocomplete="off" spellcheck="false">
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
                    <button type="button" class="tool-action-btn vc-compute-btn" id="vc-compute-btn">Compute</button>
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

    <!-- ========== ADS COLUMN ========== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-three-column.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="vector-calculus-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is Vector Calculus? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is Vector Calculus?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">Vector calculus extends single-variable calculus to fields in two and three dimensions. The three fundamental operations are the <strong>gradient</strong>, <strong>divergence</strong>, and <strong>curl</strong>, all defined using the del operator &nabla;.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">These operations are essential in physics (electromagnetism, fluid dynamics, thermodynamics) and engineering (signal processing, computer graphics, robotics).</p>
    </div>

    <!-- Operations Summary -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">The Three Operations</h2>
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
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Key Vector Calculus Identities</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #4f46e5;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Curl of Gradient = 0</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&nabla; &times; (&nabla;f) = <strong>0</strong> for any smooth scalar field f. Gradient fields are always irrotational.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #6366f1;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Divergence of Curl = 0</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&nabla; &middot; (&nabla; &times; F) = <strong>0</strong> for any smooth vector field F. Curl fields are always solenoidal.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #818cf8;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Laplacian</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&nabla;&sup2;f = &nabla; &middot; (&nabla;f) = &part;&sup2;f/&part;x&sup2; + &part;&sup2;f/&part;y&sup2; + &part;&sup2;f/&part;z&sup2;. The divergence of the gradient.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #a5b4fc;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Divergence Theorem</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&oiint; F &middot; dS = &oiiint; (&nabla; &middot; F) dV. Relates surface integral to volume integral.</p>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Electromagnetism</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Maxwell's equations use gradient, divergence, and curl to describe electric and magnetic fields.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127754;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Fluid Dynamics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Divergence measures fluid expansion/compression. Curl measures fluid rotation (vorticity).</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127777;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Heat Transfer</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The gradient of temperature gives the direction of heat flow. Fourier's law: q = -k&nabla;T.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Optimization</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The gradient points in the direction of steepest ascent. Gradient descent finds minima of cost functions.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the gradient of a scalar field?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The gradient of a scalar field f(x,y,z) is a vector field that points in the direction of the greatest rate of increase of f. It is computed as nabla f = (df/dx, df/dy, df/dz). For example, the gradient of f = x^2 + y^2 + z^2 is (2x, 2y, 2z).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the divergence of a vector field?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The divergence of a vector field F = (Fx, Fy, Fz) is a scalar that measures the rate at which the field spreads out from a point. It is computed as nabla dot F = dFx/dx + dFy/dy + dFz/dz. A positive divergence indicates a source, negative indicates a sink.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the curl of a vector field?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The curl of a vector field F measures its tendency to rotate around a point. It is computed using the determinant formula involving partial derivatives. If curl F = 0, the field is conservative (irrotational). For example, curl(-y, x, 0) = (0, 0, 2), indicating uniform rotation.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I enter expressions into this calculator?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Use standard math notation: x^2 for x squared, sin(x) for sine, e^z for exponential, sqrt(x) for square root, x*y for multiplication. The calculator supports polynomials, trigonometric, exponential, logarithmic, and hyperbolic functions. A live KaTeX preview shows your expression as rendered math.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does this calculator show step-by-step solutions?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. After computing a result, click Show Steps to see a detailed solution showing each partial derivative computation, simplification, and final assembly of the result vector. Steps are rendered with full LaTeX math notation.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this vector calculus calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 3D visualizations, LaTeX export, and a built-in Python compiler.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #4f46e5, #6366f1); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8747;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve integrals with step-by-step solutions, graphs, and PDF export</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">d/dx</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Derivative Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Compute derivatives with chain rule, product rule, and more</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/limit-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #10b981, #059669); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.2rem; color: #fff;">lim</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Limit Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Evaluate limits with L'Hopital's rule and step-by-step solutions</p>
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
<%@ include file="modern/components/analytics.jsp" %>

<!-- KaTeX JS -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

<!-- Plotly (deferred until graph tab clicked) -->
<script>
    var __plotlyLoaded = false;
    function loadPlotly(cb) {
        if (__plotlyLoaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=cacheVersion%>"></script>
<script>window.VC_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/vector-calculus-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
