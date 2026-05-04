<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Series Calculator — fourth tool migrated to math-studio shell.
        Pragmatic minimal-shell migration: wraps existing sc-* markup
        verbatim (no MathLive — the function input has its own palette
        + autocomplete that don't fit the ic-* contract).

        Build contract:
          · SEO params: ported VERBATIM from series-calculator.jsp
            (29 schema entries incl. 8 FAQ pairs)
          · Sidebar tree, ms-rail, matter-bg backdrop
          · Visible FAQ accordion mirroring faqNq/faqNa params
          · All sc-* IDs preserved so series-calculator-core.js works
            unchanged

        See math/MIGRATION_TEMPLATE.md.
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Taylor Series Calculator &bull; Steps" />
        <jsp:param name="toolDescription" value="Free Taylor and Maclaurin series calculator with step-by-step derivatives, interactive convergence graph, and printable practice worksheets with 1000+ problems and answer keys." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="series-calculator.jsp" />
        <jsp:param name="toolKeywords" value="taylor series calculator, maclaurin series calculator, taylor series expansion calculator, power series calculator, taylor polynomial calculator, radius of convergence calculator, interval of convergence calculator, maclaurin series formula, taylor series formula, series approximation calculator, step by step taylor series, taylor series examples, taylor series worksheet, taylor series practice problems, taylor series practice problems with answers, maclaurin series worksheet, maclaurin series practice problems, taylor polynomial practice problems, calculus series worksheet with answer key, taylor series exam questions, AP calculus taylor series practice, infinite series calculator, convergence test calculator, taylor remainder theorem calculator, lagrange error bound, approximate integral taylor series, evaluate limits taylor series, maclaurin series e^x, taylor series sin x" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Taylor series expansion around any point,Maclaurin series centered at zero,Step-by-step derivative calculations with KaTeX,Interactive Plotly convergence graph,Term slider for real-time approximation,Radius of convergence analysis,Lagrange remainder error bound calculator,Definite integral approximation via Taylor polynomials,Limit evaluation using Taylor series substitution,Printable worksheet generator with 1000+ practice problems,Filter by question type and difficulty level,Answer key with KaTeX-rendered solutions,Built-in Python compiler,LaTeX export and shareable URLs,7 common function presets,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="College, AP Calculus, University" />
        <jsp:param name="teaches" value="Calculus, Taylor series, Maclaurin series, power series expansion, radius of convergence, Lagrange error bound, series approximation" />
        <jsp:param name="howToSteps" value="Enter your function|Type a function like e^x or sin(x) into the input field or select from autocomplete suggestions,Choose series type and terms|Select Maclaurin (a=0) or Taylor (custom center) and set the number of terms,Click Calculate Series|Press the Calculate button or hit Enter to compute the expansion,Review step-by-step solution|See each derivative evaluated at the center point with full LaTeX rendering,Explore the convergence graph|Switch to the Graph tab and use the term slider to see how the approximation improves,Generate a practice worksheet|Click Print Worksheet to create a randomized problem set with answer key filtered by type and difficulty" />
        <jsp:param name="faq1q" value="What is the difference between Taylor and Maclaurin series?" />
        <jsp:param name="faq1a" value="A Taylor series expands a function f(x) around any point a using the formula f(x) = sum of f^(n)(a)/n! times (x-a)^n. A Maclaurin series is the special case where a = 0, so f(x) = sum of f^(n)(0)/n! times x^n. Both represent functions as infinite polynomial sums. This calculator supports both types." />
        <jsp:param name="faq2q" value="How many terms do I need for a good approximation?" />
        <jsp:param name="faq2a" value="It depends on the function and how far from the center you evaluate. Near the center, 5 to 7 terms often give excellent accuracy. For points farther away, or for functions with small convergence radii, you may need 15 to 20 terms. Use the interactive graph with the term slider to see convergence in real time." />
        <jsp:param name="faq3q" value="What is the radius of convergence?" />
        <jsp:param name="faq3a" value="The radius of convergence R is the distance from the center point within which the series converges to the actual function. For |x-a| less than R, adding more terms gets closer to the true value. For |x-a| greater than R, the series diverges. Common values: e^x has R = infinity, ln(1+x) has R = 1, tan(x) has R = pi/2." />
        <jsp:param name="faq4q" value="How do you use Taylor series to approximate definite integrals?" />
        <jsp:param name="faq4a" value="Replace the integrand with its Taylor polynomial, then integrate term-by-term. For example, to approximate the integral from 0 to 1 of e^(-x^2) dx, expand e^(-x^2) as 1 - x^2 + x^4/2! - ... and integrate each power of x. This gives 1 - 1/3 + 1/10 - ... which is approximately 0.7468. Use the Integral Approx mode to compute this automatically with error comparison." />
        <jsp:param name="faq5q" value="What is the Lagrange remainder (error bound) for a Taylor polynomial?" />
        <jsp:param name="faq5a" value="The Lagrange remainder Rn(x) = f^(n+1)(c)/(n+1)! times (x-a)^(n+1) bounds the error between f(x) and its nth-degree Taylor polynomial, where c is some value between a and x. To get an upper bound, find the maximum of |f^(n+1)| on the interval. Use the Error Bound mode in this calculator to compute the bound automatically." />
        <jsp:param name="faq6q" value="Does this calculator generate practice worksheets?" />
        <jsp:param name="faq6a" value="Yes. Click the Print Worksheet button to access 1000+ practice problems covering 6 question types: expansion, binomial series, nth derivative, limits, integral approximation, and error bounds. Filter by type and difficulty (basic, medium, hard, scholar), choose how many questions you want, and generate a randomized worksheet with a full answer key. Perfect for exam prep and classroom use." />
        <jsp:param name="faq7q" value="What types of practice problems are included in the worksheet?" />
        <jsp:param name="faq7a" value="The worksheet bank contains 1000+ problems in 6 categories: series expansion (find the Taylor or Maclaurin polynomial), binomial series, nth derivative via series, limit evaluation using series substitution, definite integral approximation, and Lagrange error bound calculations. Each problem has 4 difficulty levels from basic to scholar-level, with full LaTeX-rendered answers." />
        <jsp:param name="faq8q" value="Is this Taylor series calculator really free?" />
        <jsp:param name="faq8a" value="Yes, 100 percent free with no signup or limits. Features include step-by-step derivative calculations, interactive convergence graph with term slider, radius of convergence analysis, printable practice worksheets with answer keys, a Python compiler, LaTeX copy, and shareable URLs. All computation runs in your browser with no server calls." />
    </jsp:include>

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

    <!-- Tool-specific CSS (sc-* widgets, mode toggles, palettes, edu cards) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/series-calculator.css?v=<%=cacheVersion%>">

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

        <% request.setAttribute("activeService", "series"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Series</span>
                </nav>
                <h1>Taylor &amp; Maclaurin Series Calculator</h1>
            </header>

            <%-- Two-column input/output grid (no separate ads column — rail handles ads). --%>
            <div class="tool-page-container" style="grid-template-columns:minmax(300px,400px) minmax(0,1fr); max-width:none; padding:0; margin:0; min-height:0;">

                <!-- ==================== INPUT COLUMN ==================== -->
                <div class="tool-input-column">
                    <div class="tool-card">
                        <div class="tool-card-header" style="background:var(--sc-gradient);">Series Expansion</div>
                        <div class="tool-card-body">

                            <!-- Mode Toggle -->
                            <div class="tool-form-group" style="margin-bottom:0.75rem;">
                                <label class="tool-form-label">Mode</label>
                                <div class="sc-mode-toggle" id="sc-mode-toggle">
                                    <button type="button" class="sc-mode-btn active" data-mode="expansion">Series Expansion</button>
                                    <button type="button" class="sc-mode-btn" data-mode="remainder">Error Bound</button>
                                    <button type="button" class="sc-mode-btn" data-mode="integral">Integral Approx</button>
                                    <button type="button" class="sc-mode-btn" data-mode="limit">Limit Eval</button>
                                </div>
                            </div>

                            <!-- Series Type Toggle -->
                            <div class="tool-form-group" style="margin-bottom:0.5rem;" id="sc-type-toggle-group">
                                <label class="tool-form-label">Series Type</label>
                                <div class="sc-type-toggle">
                                    <button type="button" class="sc-type-btn active" data-type="maclaurin">Maclaurin (a=0)</button>
                                    <button type="button" class="sc-type-btn" data-type="taylor">Taylor (custom a)</button>
                                </div>
                            </div>

                            <!-- Function Input — MathLive Visual + Text fallback -->
                            <div class="tool-form-group">
                                <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:0.5rem;">
                                    <label class="tool-form-label" for="sc-func-input" style="margin-bottom:0;">Function f(x)</label>
                                    <div style="display:flex;gap:0.5rem;align-items:center;">
                                        <div class="ic-input-mode-toggle" data-mml-toggle role="radiogroup" aria-label="Input mode" style="display:inline-flex;border:1px solid var(--border);border-radius:9999px;padding:2px;background:var(--bg-secondary);">
                                            <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually" style="padding:0.2rem 0.6rem;border:none;background:transparent;font-size:0.7rem;font-weight:600;cursor:pointer;border-radius:9999px;">&fnof; Visual</button>
                                            <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type plain text" style="padding:0.2rem 0.6rem;border:none;background:transparent;font-size:0.7rem;font-weight:600;cursor:pointer;border-radius:9999px;font-family:var(--font-mono);">&lt;/&gt; Text</button>
                                        </div>
                                        <button type="button" id="sc-image-btn" title="Scan series problems from image or PDF" style="padding:0.25rem 0.625rem;border-radius:9999px;border:1.5px solid var(--primary);background:transparent;color:var(--primary);font-size:0.75rem;font-weight:600;cursor:pointer;">&#128247; Scan</button>
                                    </div>
                                </div>
                                <div class="sc-func-input-wrap mml-pair">
                                    <math-field class="mml-mathfield" aria-label="Function for series expansion"
                                                placeholder="e^x"
                                                smart-mode="on" smart-fence="on" smart-superscript="on"
                                                remove-extraneous-parentheses="on"></math-field>
                                    <input type="text" class="sc-func-input mml-text" id="sc-func-input" placeholder="e.g., e^x, sin(x), cos(x), ln(1+x)" value="e^x" autocomplete="off" spellcheck="false">
                                    <div class="sc-func-autocomplete mml-text-extra" id="sc-func-autocomplete"></div>
                                </div>
                                <!-- Function Palette -->
                                <div class="sc-func-palette" id="sc-func-palette">
                                    <button type="button" class="sc-palette-btn" data-insert="sin(" title="sine">sin</button>
                                    <button type="button" class="sc-palette-btn" data-insert="cos(" title="cosine">cos</button>
                                    <button type="button" class="sc-palette-btn" data-insert="tan(" title="tangent">tan</button>
                                    <button type="button" class="sc-palette-btn" data-insert="e^(" title="exponential">e<sup>x</sup></button>
                                    <button type="button" class="sc-palette-btn" data-insert="ln(" title="natural log">ln</button>
                                    <button type="button" class="sc-palette-btn" data-insert="log(" title="logarithm">log</button>
                                    <button type="button" class="sc-palette-btn" data-insert="sqrt(" title="square root">&radic;</button>
                                    <button type="button" class="sc-palette-btn" data-insert="^" title="power">x<sup>n</sup></button>
                                    <button type="button" class="sc-palette-btn" data-insert="pi" title="pi">&pi;</button>
                                    <button type="button" class="sc-palette-btn" data-insert="(" title="open paren">(</button>
                                    <button type="button" class="sc-palette-btn" data-insert=")" title="close paren">)</button>
                                    <button type="button" class="sc-palette-btn" data-insert="1/(" title="reciprocal">1/x</button>
                                </div>
                                <div class="tool-form-hint">Click buttons above or type directly. Use ^ for powers, e.g. x^2</div>
                                <!-- Quick Examples -->
                                <div class="sc-examples" style="margin-top:0.375rem;">
                                    <button type="button" class="sc-example-chip" data-example="exp">e^x</button>
                                    <button type="button" class="sc-example-chip" data-example="sin">sin(x)</button>
                                    <button type="button" class="sc-example-chip" data-example="cos">cos(x)</button>
                                    <button type="button" class="sc-example-chip" data-example="ln">ln(1+x)</button>
                                    <button type="button" class="sc-example-chip" data-example="geo">1/(1-x)</button>
                                    <button type="button" class="sc-example-chip" data-example="sqrt">&radic;(1+x)</button>
                                    <button type="button" class="sc-example-chip" data-example="tan">tan(x)</button>
                                    <button type="button" class="sc-example-chip" data-example="taylor">sin(x) @ &pi;</button>
                                </div>
                            </div>

                            <!-- Parameters -->
                            <div class="sc-param-row">
                                <div class="sc-param-group" id="sc-center-group" style="display:none;">
                                    <label class="sc-param-label" for="sc-center-point">Center (a)</label>
                                    <input type="text" class="sc-param-input" id="sc-center-point" placeholder="e.g., 0, 1, pi" value="0">
                                </div>
                                <div class="sc-param-group">
                                    <label class="sc-param-label" for="sc-num-terms">Terms (n)</label>
                                    <input type="number" class="sc-param-input" id="sc-num-terms" min="1" max="20" value="5">
                                </div>
                            </div>

                            <!-- Remainder Mode Inputs -->
                            <div class="sc-mode-inputs" id="sc-remainder-inputs" style="display:none">
                                <div class="sc-param-row">
                                    <div class="sc-param-group">
                                        <label class="sc-param-label" for="sc-eval-point">Evaluate at x =</label>
                                        <input type="text" class="sc-param-input" id="sc-eval-point" placeholder="e.g., 0.5, 1, pi/4" value="0.5">
                                    </div>
                                </div>
                                <div class="tool-form-hint">Computes the Lagrange remainder bound |R<sub>n</sub>(x)| for the Taylor polynomial.</div>
                            </div>

                            <!-- Integral Mode Inputs -->
                            <div class="sc-mode-inputs" id="sc-integral-inputs" style="display:none">
                                <div class="sc-param-row">
                                    <div class="sc-param-group">
                                        <label class="sc-param-label" for="sc-int-lower">Lower bound</label>
                                        <input type="text" class="sc-param-input" id="sc-int-lower" placeholder="e.g., 0" value="0">
                                    </div>
                                    <div class="sc-param-group">
                                        <label class="sc-param-label" for="sc-int-upper">Upper bound</label>
                                        <input type="text" class="sc-param-input" id="sc-int-upper" placeholder="e.g., 1" value="1">
                                    </div>
                                </div>
                                <div class="tool-form-hint">Approximates &int;f(x)dx by integrating the Taylor polynomial term-by-term.</div>
                            </div>

                            <!-- Limit Mode Inputs -->
                            <div class="sc-mode-inputs" id="sc-limit-inputs" style="display:none">
                                <div class="sc-param-row">
                                    <div class="sc-param-group">
                                        <label class="sc-param-label" for="sc-limit-expr">Full expression</label>
                                        <input type="text" class="sc-func-input" id="sc-limit-expr" placeholder="e.g., sin(x)/x, (e^x-1)/x" value="sin(x)/x" autocomplete="off" spellcheck="false">
                                    </div>
                                    <div class="sc-param-group">
                                        <label class="sc-param-label" for="sc-limit-point">x &rarr;</label>
                                        <input type="text" class="sc-param-input" id="sc-limit-point" placeholder="e.g., 0, inf" value="0">
                                    </div>
                                </div>
                                <div class="tool-form-hint">Evaluates limits by substituting Taylor expansions and simplifying.</div>
                            </div>

                            <!-- Live Preview -->
                            <div class="tool-form-group" style="margin-top:0.75rem;">
                                <label class="tool-form-label">Series Preview</label>
                                <div class="sc-preview" id="sc-preview"></div>
                            </div>

                            <!-- Action Buttons -->
                            <div style="display:flex;gap:0.5rem;">
                                <button type="button" class="tool-action-btn" id="sc-solve-btn" data-mml-submit style="flex:1">Calculate Series</button>
                                <button type="button" class="tool-action-btn" id="sc-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                            </div>

                            <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                            <!-- Worksheet Generator -->
                            <div>
                                <label class="tool-form-label">Worksheet Generator</label>
                                <p style="font-size:0.75rem;color:var(--text-muted);margin:0 0 0.5rem;">
                                    Generate a printable practice worksheet with random questions and answer key.
                                </p>
                                <button type="button" class="sc-worksheet-btn" id="sc-worksheet-btn">
                                    Print Worksheet
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ==================== OUTPUT COLUMN ==================== -->
                <div class="tool-output-column">
                    <!-- Tab bar -->
                    <div class="sc-output-tabs">
                        <button type="button" class="sc-output-tab active" data-panel="result">Result</button>
                        <button type="button" class="sc-output-tab" data-panel="graph">Graph</button>
                        <button type="button" class="sc-output-tab" data-panel="python">Python Compiler</button>
                    </div>

                    <!-- Result Panel -->
                    <div class="sc-panel active" id="sc-panel-result">
                        <div class="sc-result-scroll-container">
                            <div class="tool-card tool-result-card">
                                <div class="tool-result-header">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sc-tool);">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                                    </svg>
                                    <h4>Series Expansion</h4>
                                </div>
                                <div class="tool-result-content" id="sc-result-content">
                                    <div class="tool-empty-state" id="sc-empty-state">
                                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&Sigma;</div>
                                        <h3>Enter a function</h3>
                                        <p>Calculate Taylor or Maclaurin series expansion with step-by-step solutions.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Step-by-Step CTA Button -->
                            <div id="sc-steps-cta" style="display:none;margin-top:1rem;">
                                <button type="button" class="sc-steps-toggle-btn" id="sc-steps-toggle-btn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;">
                                        <path d="M9 5l7 7-7 7"/>
                                    </svg>
                                    Show Step-by-Step Solution
                                </button>
                            </div>
                            <div id="sc-steps-area" style="margin-top:1rem;display:none;"></div>
                            <div id="sc-convergence-area" style="margin-top:0.5rem"></div>
                        </div>

                        <!-- Sticky action toolbar -->
                        <div class="sc-result-toolbar" id="sc-result-actions" style="display:none">
                            <div class="sc-toolbar-group">
                                <button type="button" class="sc-toolbar-btn" id="sc-download-pdf-btn" title="Download as PDF">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    PDF
                                </button>
                            </div>
                            <div class="sc-toolbar-sep"></div>
                            <div class="sc-toolbar-group">
                                <button type="button" class="sc-toolbar-btn" id="sc-share-btn" title="Copy share link">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                                    Share
                                </button>
                            </div>
                            <div class="sc-toolbar-sep"></div>
                            <div class="sc-toolbar-group">
                                <button type="button" class="sc-toolbar-btn" id="sc-toolbar-worksheet-btn" title="Generate practice worksheet">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                    Worksheet
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Graph Panel -->
                    <div class="sc-panel" id="sc-panel-graph">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                            <div class="tool-result-header">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sc-tool);">
                                    <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                                </svg>
                                <h4>Convergence Graph</h4>
                            </div>
                            <div style="flex:1;min-height:0;padding:0.75rem;">
                                <div id="sc-graph-container"></div>
                                <p id="sc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate a series to see the function vs approximation graph.</p>

                                <!-- Term Slider -->
                                <div class="sc-slider-group">
                                    <span class="sc-slider-label">Terms:</span>
                                    <input type="range" class="sc-slider" id="sc-term-slider" min="1" max="20" value="5">
                                    <span class="sc-slider-value" id="sc-term-slider-value">5</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Python Compiler Panel -->
                    <div class="sc-panel" id="sc-panel-python">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                            <div class="tool-result-header">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sc-tool);">
                                    <polygon points="5 3 19 12 5 21 5 3"/>
                                </svg>
                                <h4>Python Compiler</h4>
                                <select id="sc-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                                    <option value="sympy-series">Series Expansion</option>
                                    <option value="numpy-approx">Numeric Approximation</option>
                                    <option value="sympy-convergence">Convergence Analysis</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="sc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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

                <!-- ===== 1. WHAT IS A TAYLOR SERIES? ===== -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What is a Taylor Series?</h2>
                    <p class="sc-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
                        A <strong>Taylor series</strong> represents a function as an infinite sum of polynomial terms calculated from the function's <strong>derivatives at a single point</strong>. It is one of the most powerful tools in calculus &mdash; enabling us to approximate complex functions like sin(x), e<sup>x</sup>, and ln(x) using simple polynomials.
                    </p>

                    <!-- Taylor Series Formula Breakdown -->
                    <div class="sc-concept-hero">
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-fn">f(x)</div><div class="sc-concept-label sc-c-fn">Function</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-eq">=</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-eq">&Sigma;</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-deriv">f<sup>(n)</sup>(a)</div><div class="sc-concept-label sc-c-deriv">nth Derivative</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-eq">/</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-fact">n!</div><div class="sc-concept-label sc-c-fact">Factorial</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-eq">&middot;</div></div>
                        <div class="sc-concept-block"><div class="sc-concept-symbol sc-c-power">(x&minus;a)<sup>n</sup></div><div class="sc-concept-label sc-c-power">Power Term</div></div>
                    </div>

                    <div class="sc-callout sc-callout-insight sc-anim sc-anim-d2">
                        <span class="sc-callout-icon">&#128161;</span>
                        <div class="sc-callout-text">
                            <strong>Why does it work?</strong>
                            Each term matches one more derivative of the original function at the center point. With enough terms, the polynomial approximation becomes indistinguishable from the original function &mdash; at least within the <strong>radius of convergence</strong>.
                        </div>
                    </div>
                </div>

                <!-- ===== 2. COMMON SERIES ===== -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Common Maclaurin Series</h2>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.5rem;">
                        These series are used so frequently in mathematics and physics that they are worth memorizing.
                    </p>

                    <div class="sc-series-grid">
                        <div class="sc-series-card sc-anim sc-anim-d1" style="border-left-color:#2563eb;"><h4><span style="color:#2563eb;">&#9679;</span> Exponential</h4><p>e<sup>x</sup> = 1 + x + x&sup2;/2! + x&sup3;/3! + &hellip;</p><p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = &infin;</p></div>
                        <div class="sc-series-card sc-anim sc-anim-d2" style="border-left-color:#dc2626;"><h4><span style="color:#dc2626;">&#9679;</span> Sine</h4><p>sin(x) = x &minus; x&sup3;/3! + x<sup>5</sup>/5! &minus; &hellip;</p><p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = &infin;</p></div>
                        <div class="sc-series-card sc-anim sc-anim-d3" style="border-left-color:#059669;"><h4><span style="color:#059669;">&#9679;</span> Cosine</h4><p>cos(x) = 1 &minus; x&sup2;/2! + x<sup>4</sup>/4! &minus; &hellip;</p><p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = &infin;</p></div>
                        <div class="sc-series-card sc-anim sc-anim-d4" style="border-left-color:#d97706;"><h4><span style="color:#d97706;">&#9679;</span> Natural Log</h4><p>ln(1+x) = x &minus; x&sup2;/2 + x&sup3;/3 &minus; &hellip;</p><p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = 1</p></div>
                        <div class="sc-series-card sc-anim sc-anim-d5" style="border-left-color:#7c3aed;"><h4><span style="color:#7c3aed;">&#9679;</span> Geometric</h4><p>1/(1&minus;x) = 1 + x + x&sup2; + x&sup3; + &hellip;</p><p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = 1</p></div>
                        <div class="sc-series-card sc-anim sc-anim-d5" style="border-left-color:#0891b2;"><h4><span style="color:#0891b2;">&#9679;</span> Square Root</h4><p>&radic;(1+x) = 1 + x/2 &minus; x&sup2;/8 + &hellip;</p><p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = 1</p></div>
                    </div>
                </div>

                <!-- ===== 3. CONVERGENCE EXPLAINED ===== -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">Understanding Convergence</h2>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
                        Not every Taylor series converges everywhere. The <strong>radius of convergence R</strong> tells you how far from the center point the series reliably approximates the function.
                    </p>

                    <div class="sc-edu-grid">
                        <div class="sc-edu-card sc-anim sc-anim-d1" style="border-left:3px solid #22c55e;"><h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#22c55e;">&#9679;</span> R = &infin;</h4><p>Functions like e<sup>x</sup>, sin(x), and cos(x) converge for all real x. Their series approximation works everywhere.</p></div>
                        <div class="sc-edu-card sc-anim sc-anim-d2" style="border-left:3px solid #f59e0b;"><h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#f59e0b;">&#9679;</span> Finite R</h4><p>Functions like ln(1+x) and 1/(1&minus;x) only converge within a limited interval around the center. Beyond that, the series diverges.</p></div>
                        <div class="sc-edu-card sc-anim sc-anim-d3" style="border-left:3px solid #ef4444;"><h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#ef4444;">&#9679;</span> Singularities</h4><p>The radius of convergence equals the distance to the nearest singularity (point where the function is undefined), even in the complex plane.</p></div>
                    </div>

                    <div class="sc-callout sc-callout-tip sc-anim sc-anim-d4">
                        <span class="sc-callout-icon">&#128073;</span>
                        <div class="sc-callout-text">
                            <strong>Try it!</strong> Enter <code style="background:var(--bg-tertiary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;">ln(1+x)</code> and increase terms to 15. Watch how the graph matches well for |x| &lt; 1 but diverges wildly beyond x = 1.
                        </div>
                    </div>
                </div>

                <!-- ===== 4. APPLICATIONS ===== -->
                <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Real-World Applications</h2>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
                        Taylor series aren&rsquo;t just theoretical &mdash; they power real technology and science every day.
                    </p>
                    <div class="sc-edu-grid">
                        <div class="sc-edu-card" style="border-left:3px solid #2563eb;"><h4>Calculator Chips</h4><p>Your calculator computes sin(x) and cos(x) using polynomial approximations derived from Taylor series. Hardware implements these as fast multiplications and additions.</p></div>
                        <div class="sc-edu-card" style="border-left:3px solid #7c3aed;"><h4>Physics Approximations</h4><p>sin(&theta;) &approx; &theta; for small angles simplifies pendulum equations. Many physics formulas are first-order Taylor approximations.</p></div>
                        <div class="sc-edu-card" style="border-left:3px solid #059669;"><h4>Machine Learning</h4><p>Gradient descent uses first-order Taylor approximation. Newton&rsquo;s method uses second-order. Higher-order optimization uses more terms.</p></div>
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
        <div class="ms-faq" aria-label="Series calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the difference between Taylor and Maclaurin series?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">A <strong>Taylor series</strong> expands a function <em>f(x)</em> around any point <em>a</em> using <em>f(x) = &Sigma; f<sup>(n)</sup>(a)/n! &middot; (x&minus;a)<sup>n</sup></em>. A <strong>Maclaurin series</strong> is the special case where <em>a = 0</em>, so <em>f(x) = &Sigma; f<sup>(n)</sup>(0)/n! &middot; x<sup>n</sup></em>. Both represent functions as infinite polynomial sums &mdash; this calculator supports both.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How many terms do I need for a good approximation?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Depends on the function and how far from the center you evaluate. Near the center, <strong>5&ndash;7 terms</strong> often give excellent accuracy. Farther away &mdash; or for functions with small convergence radii &mdash; you may need <strong>15&ndash;20 terms</strong>. Use the interactive graph with the term slider to watch convergence in real time.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the radius of convergence?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>radius of convergence R</strong> is the distance from the center within which the series converges to the actual function. For <em>|x&minus;a| &lt; R</em>, more terms get closer to the true value; for <em>|x&minus;a| &gt; R</em> the series diverges. Common values: <em>e<sup>x</sup></em> has <em>R = &infin;</em>, <em>ln(1+x)</em> has <em>R = 1</em>, <em>tan(x)</em> has <em>R = &pi;/2</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you use Taylor series to approximate definite integrals?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Replace the integrand with its Taylor polynomial, then integrate term-by-term. For example, <em>&int;<sub>0</sub><sup>1</sup> e<sup>&minus;x&sup2;</sup> dx</em> &asymp; <em>1 &minus; 1/3 + 1/10 &minus; &hellip; &asymp; 0.7468</em>. Use <strong>Integral Approx</strong> mode for automatic computation with error comparison.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the Lagrange remainder (error bound)?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>Lagrange remainder</strong> <em>R<sub>n</sub>(x) = f<sup>(n+1)</sup>(c)/(n+1)! &middot; (x&minus;a)<sup>n+1</sup></em> bounds the error between <em>f(x)</em> and its <em>n</em>th-degree Taylor polynomial, where <em>c</em> is some value between <em>a</em> and <em>x</em>. To get an upper bound, find the maximum of <em>|f<sup>(n+1)</sup>|</em> on the interval. Use <strong>Error Bound</strong> mode to compute it automatically.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this calculator generate practice worksheets?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click <strong>Print Worksheet</strong> for <strong>1,000+ practice problems</strong> across 6 question types: expansion, binomial series, nth derivative, limits, integral approximation, and error bounds. Filter by type and difficulty (basic, medium, hard, scholar). Each worksheet is randomly generated with a full answer key &mdash; ideal for exam prep and classroom use.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What types of practice problems are in the worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">6 categories: series expansion (Taylor / Maclaurin polynomial), binomial series, <em>n</em>th derivative via series, limit evaluation by series substitution, definite integral approximation, and Lagrange error bound. Each problem has 4 difficulty levels from basic to scholar-level, with full LaTeX-rendered answers.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this Taylor series calculator really free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; <strong>100% free, no signup, no limits</strong>. Step-by-step derivative calculations, interactive convergence graph with term slider, radius of convergence analysis, printable practice worksheets with answer keys, Python compiler, LaTeX copy, and shareable URLs. All computation runs in your browser.</div>
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
          1. math-libs                  — CDN deps (KaTeX, nerdamer, plotly loader, image-to-math)
          2. series-calculator-scripts  — render/graph/export, worksheet, core, image-scan init
          3. math-input-multi           — MathLive ES module + Visual/Text mode toggle (reads DOM)
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/series-calculator-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-multi.jsp" />

    <!-- Scroll-triggered animations for sc-anim educational cards -->
    <script>
    (function(){
        var els = document.querySelectorAll('.sc-anim');
        if (!els.length) return;
        if (!('IntersectionObserver' in window)) {
            els.forEach(function(el){ el.classList.add('sc-visible'); });
            return;
        }
        var obs = new IntersectionObserver(function(entries){
            entries.forEach(function(e){
                if (e.isIntersecting) {
                    e.target.classList.add('sc-visible');
                    obs.unobserve(e.target);
                }
            });
        }, { threshold: 0.15 });
        els.forEach(function(el){ obs.observe(el); });
    })();

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
