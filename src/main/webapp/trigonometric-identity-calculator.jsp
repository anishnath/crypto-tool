<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Trig Identity Calculator — math-studio shell (matches integral /
        ODE / PDE / matrix / trig-function / trig-equation calculators).
        Wraps existing trig-* markup verbatim so /js/trig-common.js +
        /js/trig-identity-core.js + /js/trig-graph.js + /js/trig-export.js
        continue to work without modification (every trig-* id and class
        preserved).

        New on top of the legacy page:
          · math-studio shell (sidebar, ms-rail, matter-bg, ic-stack)
          · MathLive Visual/Text on three inputs — trig-expr (Identities
            optional), trig-lhs (Prove LHS), trig-rhs (Prove RHS) — wired
            via math-input-multi (mml-pair).
          · AI photo scan with a trig-identity-specific extraction prompt
          · ".is-busy" spinner lock on the primary CTA
          · Friendlier "Calculate &rarr;" / "Prove &rarr;" copy
          · Headline example chips inline (above the legacy "More examples")
          · Mode-aware show/hide of the Identities select vs Prove inputs
            preserved (#trig-identity-group / #trig-expr-group /
            #trig-prove-group), driven by the existing controller.
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Trig Identity Calculator with Steps + AI Photo Scan" />
        <jsp:param name="toolDescription" value="Free AI trig identity calculator with step-by-step proofs and photo scan. Browse Pythagorean, double angle, sum-to-product identities. Verify or prove any trigonometric identity. Snap a textbook problem or type both sides. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="trigonometric-identity-calculator.jsp" />
        <jsp:param name="toolKeywords" value="trigonometric identity calculator, prove trig identity, trig identity solver, Pythagorean identity, double angle formula, half angle formula, sum to product formula, product to sum, verify trig identity, trig identity list, AI trig identity prover, trig identity scan image, MathLive trig editor" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI photo scan with step-by-step prover,MathLive visual trig editor (Visual / Text toggle),Browse 8 identity categories with LaTeX formulas,Pythagorean and reciprocal identities,Double angle and half angle formulas,Sum-to-product and product-to-sum conversions,AI-powered identity proofs with step-by-step work,Automatic verification of identity validity,Counterexample detection for false identities,Identity reference cards with descriptions,Python SymPy code generation,LaTeX export Dark mode no signup free" />
        <jsp:param name="teaches" value="Trigonometric identities, Pythagorean identities, double angle formulas, half angle formulas, sum-to-product conversions, proving identities, identity verification" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Snap a photo OR type the identity|Click the camera button to scan a problem from a photo OR type the LHS and RHS using the MathLive visual editor.,Pick a mode|Select Identities to browse identity formulas OR Prove to verify an identity step-by-step.,Select category or enter sides|In Identities mode choose a category like Pythagorean OR Double Angle. In Prove mode enter the LHS and RHS expressions.,Click Calculate|Press Calculate to display formulas or start the AI-powered step-by-step proof.,Review steps|Each proof step shows the identity used and the algebraic transformation with LaTeX rendering.,View graph|Switch to Graph tab to see both sides plotted to visually verify equality." />
        <jsp:param name="faq1q" value="Can I scan a trig identity problem from a photo?" />
        <jsp:param name="faq1a" value="Yes. Click the green Scan button next to the LHS input, upload a photo or PDF of your homework, and our AI extracts every trig identity on the page along with both sides. Pick one to fill the form and prove. Works on textbook pages, exam papers, and handwritten work." />
        <jsp:param name="faq2q" value="What trigonometric identities are available?" />
        <jsp:param name="faq2a" value="We cover 8 complete categories: Pythagorean, sum and difference, double angle, half angle, negative angle, sum-to-product, product-to-sum, and cofunction identities. Each category shows all formulas with rendered LaTeX." />
        <jsp:param name="faq3q" value="How does the identity prover work?" />
        <jsp:param name="faq3a" value="Enter the left-hand side (LHS) and right-hand side (RHS) of the identity you want to prove. Our AI verifies the identity first, then works one side step-by-step using known identities until it matches the other side. If the identity is false, it provides a counterexample." />
        <jsp:param name="faq4q" value="Can it detect false identities?" />
        <jsp:param name="faq4a" value="Yes. The prover first checks if both sides are actually equal by simplifying independently. If the identity is false, it clearly states Not a valid identity and shows a specific counterexample angle with numeric values for both sides." />
        <jsp:param name="faq5q" value="What is the Pythagorean identity?" />
        <jsp:param name="faq5a" value="The fundamental Pythagorean identity is sin squared theta plus cos squared theta equals 1. It derives from the Pythagorean theorem on the unit circle. Two related forms are 1 plus tan squared theta equals sec squared theta, and 1 plus cot squared theta equals csc squared theta." />
        <jsp:param name="faq6q" value="What are double angle formulas used for?" />
        <jsp:param name="faq6a" value="Double angle formulas express trig functions of 2 theta in terms of theta. sin(2A)=2sinAcosA, cos(2A)=cos2A-sin2A (three forms), tan(2A)=2tanA/(1-tan2A). They are used to simplify expressions, solve equations, and integrate trig functions." />
        <jsp:param name="faq7q" value="How do I prove a trig identity manually?" />
        <jsp:param name="faq7a" value="Work on one side only, usually the more complex side. Convert everything to sine and cosine. Apply Pythagorean identities to simplify. Factor or combine fractions. Use double angle or sum-to-product formulas when needed. Never cross the equals sign to move terms between sides." />
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

    <!-- Tool-specific CSS (trig-* mode toggles, examples, ops table, etc.) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/trigonometry-calculator.css?v=<%=cacheVersion%>">

    <!-- KaTeX + MathLive + image-to-math -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=cacheVersion%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>

    <style>
    /* Busy-spinner for the primary CTA */
    .ic-hero-cta.is-busy {
        opacity: 0.65;
        cursor: progress;
        pointer-events: none;
    }
    .ic-hero-cta.is-busy::after {
        content: '';
        display: inline-block;
        margin-left: 0.6rem;
        width: 12px; height: 12px;
        border: 2px solid rgba(255,255,255,0.4);
        border-top-color: #fff;
        border-radius: 50%;
        animation: trig-cta-spin 0.7s linear infinite;
        vertical-align: middle;
    }
    @keyframes trig-cta-spin { to { transform: rotate(360deg); } }
    /* Identity-type select — same look as the trig-input-text inputs */
    .trig-identity-select {
        width: 100%;
        padding: 0.6rem 0.7rem;
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
        font-family: var(--font-sans);
        font-size: 0.875rem;
        cursor: pointer;
    }
    [data-theme="dark"] .trig-identity-select {
        background: var(--ms-surface-2, #1e293b);
        border-color: var(--ms-border, #334155);
        color: var(--ms-ink, #f1f5f9);
    }
    /* Compact two-column layout for the LHS / RHS pair on wide screens. */
    .trig-prove-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.7rem;
    }
    @media (max-width: 720px) { .trig-prove-grid { grid-template-columns: 1fr; } }
    .trig-prove-side > .ic-expr-label {
        font-size: 0.78rem;
        font-weight: 600;
        color: var(--ms-ink-soft, #475569);
        margin-bottom: 0.25rem;
        display: block;
    }
    .ic-hero .math-ai-tab-btn {
        display: inline-flex; align-items: center; gap: 0.35rem;
        padding: 0.35rem 0.75rem; border-radius: 999px; border: 1px solid rgba(124,58,237,0.35);
        background: rgba(124,58,237,0.08); color: var(--ms-text, #1e1b4b); font-size: 0.8125rem;
        font-weight: 600; cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
        white-space: nowrap;
    }
    .ic-hero .math-ai-tab-btn:hover {
        background: rgba(124,58,237,0.18); transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(124,58,237,0.15);
    }
    .ic-hero .math-ai-tab-btn[aria-busy="true"] { opacity: 0.75; cursor: wait; }
    </style>

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

        <% request.setAttribute("activeService", "trig-id"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Trig Identities</span>
                </nav>
                <h1>Trigonometric Identity Calculator</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="trig-hero" data-input-mode="visual">

                    <!-- Top row: mode toggle + Visual/Text + Scan -->
                    <div class="ic-hero-top">
                        <div class="ic-mode-toggle trig-mode-toggle" role="radiogroup" aria-label="Trig identity mode">
                            <button type="button" class="ic-mode-btn trig-mode-btn active" data-mode="identity" role="radio" aria-checked="true"  title="Browse trig identity formulas">Identities</button>
                            <button type="button" class="ic-mode-btn trig-mode-btn"        data-mode="prove"    role="radio" aria-checked="false" title="Prove an identity LHS = RHS">Prove</button>
                        </div>
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;">
                            <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — trig identity tutor + Solve / graph in chat (Ctrl+Shift+A)">&#10024; AI</button>
                            <div class="ic-input-mode-toggle" data-mml-toggle role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text expression">
                                    <span aria-hidden="true" style="font-family:var(--font-mono,monospace);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="trig-scan-btn" title="Scan trig identities from image or PDF">&#128247; Scan</button>
                        </div>
                    </div>

                    <!-- Identity Mode — category select + optional expression -->
                    <div id="trig-identity-group">
                        <div class="ic-hero-params" style="grid-template-columns:auto 1fr;align-items:center;gap:0.6rem;">
                            <label class="tool-form-label" for="trig-identity-type" style="margin:0;">Category</label>
                            <select id="trig-identity-type" class="trig-identity-select">
                                <option value="pythagorean">Pythagorean Identities</option>
                                <option value="sum_difference">Sum &amp; Difference</option>
                                <option value="double_angle">Double Angle</option>
                                <option value="half_angle">Half Angle</option>
                                <option value="negative_angle">Negative Angle</option>
                                <option value="sum_to_product">Sum to Product</option>
                                <option value="product_to_sum">Product to Sum</option>
                                <option value="cofunction">Cofunction</option>
                            </select>
                        </div>
                    </div>

                    <!-- Optional expression (Identities mode) — MathLive Visual / Text pair -->
                    <div id="trig-expr-group" style="margin-top:0.6rem;">
                        <div class="ic-expr-wrap mml-pair" id="trig-expr-wrap">
                            <math-field class="ic-mathfield mml-mathfield" aria-label="Optional expression"
                                        placeholder="\sin^2(x)+\cos^2(x)"
                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                            <input type="text" class="trig-input-text mml-text" id="trig-expr"
                                   value="" placeholder="Optional: apply identity to e.g. sin(x)^2 + cos(x)^2"
                                   autocomplete="off" spellcheck="false" aria-label="Optional expression text">
                            <span class="tool-form-hint ic-expr-hint">
                                <span class="ic-hint-visual">Optional &mdash; pick a category above to browse formulas, or paste an expression to apply the identity to.</span>
                                <span class="ic-hint-text">Optional: e.g. <code>sin(x)^2 + cos(x)^2</code></span>
                            </span>
                        </div>
                    </div>

                    <!-- Prove Mode — LHS + RHS as side-by-side mml-pairs -->
                    <div id="trig-prove-group" style="display:none;margin-top:0.4rem;">
                        <div class="trig-prove-grid">
                            <div class="trig-prove-side">
                                <span class="ic-expr-label">Left-hand side (LHS)</span>
                                <div class="ic-expr-wrap mml-pair" id="trig-lhs-wrap">
                                    <math-field class="ic-mathfield mml-mathfield" aria-label="LHS"
                                                placeholder="\tan^2(x)-\sin^2(x)"
                                                smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                                    <input type="text" class="trig-input-text mml-text" id="trig-lhs"
                                           value="" placeholder="e.g. tan(x)^2 - sin(x)^2"
                                           autocomplete="off" spellcheck="false" aria-label="LHS text">
                                </div>
                            </div>
                            <div class="trig-prove-side">
                                <span class="ic-expr-label">Right-hand side (RHS)</span>
                                <div class="ic-expr-wrap mml-pair" id="trig-rhs-wrap">
                                    <math-field class="ic-mathfield mml-mathfield" aria-label="RHS"
                                                placeholder="\tan^2(x)\,\sin^2(x)"
                                                smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                                    <input type="text" class="trig-input-text mml-text" id="trig-rhs"
                                           value="" placeholder="e.g. tan(x)^2 * sin(x)^2"
                                           autocomplete="off" spellcheck="false" aria-label="RHS text">
                                </div>
                            </div>
                        </div>
                        <span class="tool-form-hint" style="display:block;margin-top:0.3rem;">Enter both sides of the identity to prove. Use <code>^2</code> for squared, <code>*</code> for multiply, <code>pi</code> for &pi;.</span>
                    </div>

                    <!-- Live preview strip -->
                    <div class="ic-preview-strip" style="margin-top:0.6rem;">
                        <span class="ic-preview-label">Preview</span>
                        <span class="ic-preview trig-preview" id="trig-preview">select a category or enter an identity&hellip;</span>
                    </div>

                    <!-- Primary CTA -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="trig-calc-btn" data-mml-submit>Calculate &amp; explain &rarr;</button>
                        <button type="button" class="ode-random-btn" id="trig-clear-btn" title="Clear input">&#128465; Clear</button>
                    </div>

                    <!-- Headline examples — one row of starting points.
                         Identity chips also seed the optional expression
                         input with a representative formula so the user
                         sees something concrete in the input area, not
                         just a category-select change. -->
                    <div class="ic-method-row" style="margin:0.4rem 0 0.2rem;">
                        <span class="ic-method-label">Try one</span>
                        <button type="button" class="ic-example-chip" data-headline data-mode="identity" data-cat="pythagorean"    data-expr="sin(x)^2 + cos(x)^2"           title="Browse Pythagorean identities (and apply to sin²x+cos²x)">Pythagorean</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="identity" data-cat="double_angle"   data-expr="sin(2*x)"                       title="Browse double-angle formulas (and apply to sin(2x))">Double Angle</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="identity" data-cat="sum_to_product" data-expr="sin(A) + sin(B)"                title="Browse sum-to-product formulas (and apply to sin A + sin B)">Sum&rarr;Product</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="prove" data-lhs="tan(x)^2 - sin(x)^2" data-rhs="tan(x)^2 * sin(x)^2" title="Prove tan²x − sin²x = tan²x · sin²x">Prove tan&sup2;&minus;sin&sup2;</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="prove" data-lhs="(1 - cos(2*x))/sin(2*x)" data-rhs="tan(x)" title="Prove (1−cos2x)/sin2x = tan x">Prove (1&minus;cos2x)/sin2x</button>
                    </div>
                    <!-- Hidden anchor for legacy share-URL / deep-link
                         hooks that may still reference #trig-examples. -->
                    <div class="trig-examples" id="trig-examples" style="display:none;" aria-hidden="true"></div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs trig-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab trig-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab trig-output-tab"        data-panel="graph"  role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab trig-output-tab"        data-panel="python" role="tab" aria-selected="false">Python</button>
                    </div>

                    <div class="ic-panel trig-panel active" id="trig-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="trig-result-content">
                                <div class="tool-empty-state ic-empty-state" id="trig-empty-state">
                                    <div class="ic-empty-illustration">&equiv;</div>
                                    <h3>Ready when you are</h3>
                                    <p>Pick an identity category above, or switch to <strong>Prove</strong> and enter both sides.</p>
                                </div>
                            </div>
                            <div class="tool-result-actions" id="trig-result-actions">
                                <button type="button" class="tool-action-btn" id="trig-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="trig-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="trig-worksheet-btn-toolbar">Worksheet</button>
                            </div>

                            <!-- Practice worksheet CTA — 1,500-problem CAS-verified
                                 trigonometry bank with NCERT word problems and
                                 IIT-JEE classics. Shared across all 3 trig calcs. -->
                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="trig-worksheet-btn">
                                    Practice Worksheet &mdash; 1,500+ trig problems with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel trig-panel" id="trig-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="trig-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="trig-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Calculate to see both sides plotted (Prove mode).</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel trig-panel" id="trig-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:0;">
                                <iframe id="trig-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ════════════ EDUCATIONAL CONTENT (preserved for SEO) ════════════ -->
            <section class="tool-expertise-section" style="margin:2rem 0;">

                <!-- 1. What Are Trig Identities -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">What Are Trigonometric Identities?</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">Trigonometric identities are equations involving trig functions that hold true for <strong>all values</strong> of the variable where both sides are defined. Unlike trig <em>equations</em> (true only for specific angles), identities are <strong>universal truths</strong>. They are essential for simplifying expressions, solving equations, evaluating integrals, and proving new results in mathematics, physics, and engineering.</p>

                    <div class="trig-feature-grid">
                        <div class="trig-feature-card trig-anim trig-anim-d1">
                            <h4>Identity vs Equation</h4>
                            <p><strong>Identity:</strong> sin&sup2;&theta; + cos&sup2;&theta; = 1 (true for ALL &theta;)<br><strong>Equation:</strong> sin &theta; = 1/2 (true only for &theta; = 30&deg;, 150&deg;, &hellip;)</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d2">
                            <h4>Why They Matter</h4>
                            <p>Simplify complex expressions, solve trig equations, evaluate calculus integrals, model wave interference, and prove mathematical theorems.</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d3">
                            <h4>Our 8 Categories</h4>
                            <p>Pythagorean, Sum &amp; Difference, Double Angle, Half Angle, Negative Angle, Sum-to-Product, Product-to-Sum, Cofunction.</p>
                        </div>
                    </div>
                </div>

                <!-- 2. Pythagorean -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">The Pythagorean Identities &mdash; The Foundation</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">The Pythagorean identities derive directly from the Pythagorean theorem applied to the unit circle. Since any point on the unit circle satisfies x&sup2; + y&sup2; = 1, with x = cos&theta; and y = sin&theta;:</p>

                    <div class="trig-formula-box" style="text-align:center;font-size:1.0625rem;">
                        sin&sup2;&theta; + cos&sup2;&theta; = 1
                    </div>
                    <div class="trig-formula-box" style="text-align:center;font-size:0.875rem;margin-top:0.5rem;">
                        1 + tan&sup2;&theta; = sec&sup2;&theta; &nbsp;&nbsp;|&nbsp;&nbsp; 1 + cot&sup2;&theta; = csc&sup2;&theta;
                    </div>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-top:0.75rem;font-size:0.9rem;">Divide sin&sup2;&theta; + cos&sup2;&theta; = 1 by <strong>cos&sup2;&theta;</strong> for the tangent-secant form, by <strong>sin&sup2;&theta;</strong> for the cotangent-cosecant form. These three are the most-used identities in all of trigonometry.</p>
                </div>

                <!-- 3. Sum/Difference + Double Angle -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Double Angle &amp; Sum/Difference Formulas</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">These let you express trig functions of <strong>combined angles</strong> (A+B, A&minus;B, 2A) in terms of functions of individual angles &mdash; critical for calculus integration, Fourier analysis, and solving complex trig equations.</p>

                    <h3 style="font-size:1rem;margin:0.5rem 0;">Sum &amp; Difference</h3>
                    <table class="trig-ops-table">
                        <thead><tr><th style="width:40%;">Identity</th><th>Formula</th></tr></thead>
                        <tbody>
                            <tr><td>sin(A &plusmn; B)</td><td>sin A cos B &plusmn; cos A sin B</td></tr>
                            <tr><td>cos(A &plusmn; B)</td><td>cos A cos B &mp; sin A sin B</td></tr>
                            <tr><td>tan(A &plusmn; B)</td><td>(tan A &plusmn; tan B) / (1 &mp; tan A tan B)</td></tr>
                        </tbody>
                    </table>

                    <h3 style="font-size:1rem;margin:1rem 0 0.5rem;">Double Angle (set B = A above)</h3>
                    <table class="trig-ops-table">
                        <thead><tr><th style="width:40%;">Identity</th><th>Formula</th></tr></thead>
                        <tbody>
                            <tr><td>sin(2A)</td><td>2 sin A cos A</td></tr>
                            <tr><td>cos(2A)</td><td>cos&sup2;A &minus; sin&sup2;A = 2cos&sup2;A &minus; 1 = 1 &minus; 2sin&sup2;A</td></tr>
                            <tr><td>tan(2A)</td><td>2 tan A / (1 &minus; tan&sup2;A)</td></tr>
                        </tbody>
                    </table>
                </div>

                <!-- 4. How to Prove -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">How to Prove Trig Identities &mdash; Strategy</h2>
                    <ol style="color:var(--ms-ink-soft,#475569);line-height:2;padding-left:1.25rem;margin:0 0 0.75rem;">
                        <li><strong>Work on ONE side only</strong> &mdash; pick the more complex side. Never move terms across the equals sign.</li>
                        <li><strong>Convert to sin and cos</strong> &mdash; replace tan, cot, sec, csc with their definitions.</li>
                        <li><strong>Apply Pythagorean identities</strong> &mdash; replace sin&sup2; + cos&sup2; with 1, or 1 + tan&sup2; with sec&sup2;.</li>
                        <li><strong>Factor and combine fractions</strong> over a common denominator.</li>
                        <li><strong>Use double angle / sum formulas</strong> when you see 2A, A+B, or A&minus;B patterns.</li>
                        <li><strong>Verify with a value</strong> &mdash; plug in a specific angle to check both sides agree.</li>
                    </ol>

                    <div class="trig-worked-example">
                        <strong>Prove tan&sup2;x &minus; sin&sup2;x = tan&sup2;x &middot; sin&sup2;x</strong><br>
                        1. LHS = sin&sup2;x/cos&sup2;x &minus; sin&sup2;x &nbsp;&larr; convert tan to sin/cos<br>
                        2. = sin&sup2;x &middot; (1/cos&sup2;x &minus; 1)<br>
                        3. = sin&sup2;x &middot; (1 &minus; cos&sup2;x)/cos&sup2;x &nbsp;&larr; common denominator<br>
                        4. = sin&sup2;x &middot; sin&sup2;x/cos&sup2;x &nbsp;&larr; Pythagorean: 1 &minus; cos&sup2;x = sin&sup2;x<br>
                        5. = sin&sup2;x &middot; tan&sup2;x = RHS &nbsp;&#10003;
                    </div>
                </div>

                <!-- 5. Quick Reference -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Complete Identity Quick Reference</h2>
                    <table class="trig-ops-table">
                        <thead><tr><th>Category</th><th>Key Formula</th><th>Common Use</th></tr></thead>
                        <tbody>
                            <tr><td>Pythagorean</td><td>sin&sup2;&theta; + cos&sup2;&theta; = 1</td><td>Simplification, substitution</td></tr>
                            <tr><td>Double Angle</td><td>sin(2&theta;) = 2 sin&theta; cos&theta;</td><td>Expanding, integration</td></tr>
                            <tr><td>Half Angle</td><td>sin(&theta;/2) = &plusmn;&radic;((1&minus;cos&theta;)/2)</td><td>Exact values, integration</td></tr>
                            <tr><td>Sum to Product</td><td>sinA + sinB = 2sin((A+B)/2)cos((A&minus;B)/2)</td><td>Factoring, signal processing</td></tr>
                            <tr><td>Product to Sum</td><td>sinA cosB = &frac12;[sin(A+B) + sin(A&minus;B)]</td><td>Integration, Fourier</td></tr>
                            <tr><td>Negative Angle</td><td>sin(&minus;&theta;) = &minus;sin&theta;</td><td>Symmetry, simplification</td></tr>
                            <tr><td>Cofunction</td><td>sin(&pi;/2 &minus; &theta;) = cos&theta;</td><td>Complementary angles</td></tr>
                        </tbody>
                    </table>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ (mirrors faqNq/faqNa above) ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Trig identity calculator FAQ">
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can I scan a trig identity from a photo?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes. Click <strong>&#128247; Scan</strong>, upload a photo or PDF of your homework, and our AI extracts every trig identity along with both sides. Pick one to fill the form and prove.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What trigonometric identities are available?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Eight complete categories: Pythagorean, sum &amp; difference, double angle, half angle, negative angle, sum-to-product, product-to-sum, and cofunction identities &mdash; each with rendered LaTeX formulas.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How does the identity prover work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Enter the LHS and RHS of the identity. Our AI verifies the identity first, then transforms one side step-by-step using known identities until it matches the other side. If false, it provides a counterexample.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can it detect false identities?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes. The prover simplifies both sides independently first. If they differ, it reports &ldquo;Not a valid identity&rdquo; and shows a specific counterexample angle with numeric values for each side.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the Pythagorean identity?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">sin&sup2;&theta; + cos&sup2;&theta; = 1, derived from the Pythagorean theorem on the unit circle. Two related forms: 1 + tan&sup2;&theta; = sec&sup2;&theta; and 1 + cot&sup2;&theta; = csc&sup2;&theta;.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are double angle formulas used for?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">They express trig functions of 2&theta; in terms of &theta;. sin(2A)=2sinAcosA; cos(2A) has three forms; tan(2A)=2tanA/(1&minus;tan&sup2;A). Used for simplification, equation solving, and integration.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do I prove a trig identity manually?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Work on one side only (the more complex one). Convert to sin and cos. Apply Pythagorean identities. Factor or combine fractions. Use double-angle or sum-to-product formulas as needed. Never cross the equals sign.</div></div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2026 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%--
        Script load order:
          1. math-libs                  — KaTeX, plotly loader, image-to-math, tool-utils, dark-mode, search
          2. trig-* JS                  — existing controller stack (unchanged; reads trig-* IDs)
          3. math-input-multi           — MathLive Visual/Text on each .mml-pair (trig-expr, trig-lhs, trig-rhs)
          4. inline scan + busy-lock + headline-chip + mode-aware-show + FAQ accordion
    --%>
    <%@ include file="/modern/components/math-tool-engine-boot.inc.jsp" %>
    <script>window.TRIG_CALC_CTX = "<%=request.getContextPath()%>";</script>

    <script src="<%=request.getContextPath()%>/js/trig-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-identity-core.js?v=<%=cacheVersion%>"></script>

    <%-- SymPy fast path — exposes window.TrigBackend.compute so Prove
         mode can verify identities deterministically before falling
         through to the LLM for narrative steps. --%>
        <jsp:include page="/math/partials/math-input-multi.jsp" />

<script>
    // ─────────────────────────────────────────────────────────────────────
    //  Note: identity vs prove group visibility is owned by the controller
    //  (trig-identity-core.js → switchMode). The first-paint state is
    //  already correct: #trig-prove-group has inline display:none, the
    //  other two have no inline display so they render visibly — matches
    //  the default mode="identity".
    // ─────────────────────────────────────────────────────────────────────

    // ─────────────────────────────────────────────────────────────────────
    //  Headline example chips
    //
    //  Identity chips: data-mode="identity" + data-cat="<category-key>"
    //  Prove chips:    data-mode="prove" + data-lhs / data-rhs
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        document.querySelectorAll('.ic-example-chip[data-headline]').forEach(function (chip) {
            chip.addEventListener('click', function () {
                var apply = function () {
                    var mode = chip.getAttribute('data-mode') || 'identity';
                    var modeBtn = document.querySelector('.trig-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    if (mode === 'identity') {
                        var cat = chip.getAttribute('data-cat');
                        if (cat) {
                            var sel = document.getElementById('trig-identity-type');
                            if (sel) {
                                sel.value = cat;
                                sel.dispatchEvent(new Event('change', { bubbles: true }));
                            }
                        }
                        // Seed the optional expression input so the user
                        // sees a concrete formula land in the input area
                        // (not just a hidden state change in the select).
                        var seed = chip.getAttribute('data-expr');
                        if (seed) {
                            var ex = document.getElementById('trig-expr');
                            if (ex) {
                                ex.value = seed;
                                ex.dispatchEvent(new Event('input', { bubbles: true }));
                            }
                        }
                    } else if (mode === 'prove') {
                        var lhs = chip.getAttribute('data-lhs') || '';
                        var rhs = chip.getAttribute('data-rhs') || '';
                        var lhsEl = document.getElementById('trig-lhs');
                        var rhsEl = document.getElementById('trig-rhs');
                        if (lhsEl) { lhsEl.value = lhs; lhsEl.dispatchEvent(new Event('input', { bubbles: true })); }
                        if (rhsEl) { rhsEl.value = rhs; rhsEl.dispatchEvent(new Event('input', { bubbles: true })); }
                    }
                    setTimeout(function () {
                        var b = document.getElementById('trig-calc-btn'); if (b) b.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else { apply(); }
            });
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  .is-busy spinner lock on Calculate
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var btn = document.getElementById('trig-calc-btn');
        var resultContent = document.getElementById('trig-result-content');
        if (!btn || !resultContent) return;
        var resultObserver = null, safetyTimer = null;
        function unlock() {
            btn.classList.remove('is-busy');
            if (resultObserver) { resultObserver.disconnect(); resultObserver = null; }
            if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
        }
        function lock() {
            if (btn.classList.contains('is-busy')) return;
            btn.classList.add('is-busy');
            if ('MutationObserver' in window) {
                resultObserver = new MutationObserver(function () { unlock(); });
                resultObserver.observe(resultContent, { childList: true, subtree: true, characterData: true });
            }
            safetyTimer = setTimeout(unlock, 30000);
        }
        btn.addEventListener('click', lock);
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  AI photo scan — trig-identity-specific extraction prompt
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        if (typeof ImageToMath === 'undefined') return;
        var CTX = window.TRIG_CALC_CTX || '';
        ImageToMath.init({
            buttonId: 'trig-scan-btn',
            aiUrl: CTX + '/ai',
            toolName: 'Trig Identity Calculator',
            extractionPrompt:
                'You are a math problem extractor for a trig identity calculator. The calculator has 2 modes: identity (browse), prove.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "mode": "prove" | "identity"\n' +
                '  - "lhs": (prove only) left-hand side in calculator syntax\n' +
                '  - "rhs": (prove only) right-hand side in calculator syntax\n' +
                '  - "category": (identity only) one of pythagorean | sum_difference | double_angle | half_angle | negative_angle | sum_to_product | product_to_sum | cofunction\n' +
                '  - "display": full problem in LaTeX for the card heading\n' +
                'Use sin/cos/tan/csc/sec/cot, pi, * for multiplication, ^ for power.\n' +
                'Mapping rules:\n' +
                '  · "Prove sin^2 x + cos^2 x = 1" → mode="prove", lhs="sin(x)^2 + cos(x)^2", rhs="1"\n' +
                '  · "Verify (1-cos2x)/sin2x = tan x" → mode="prove"\n' +
                '  · "List the Pythagorean identities" → mode="identity", category="pythagorean"\n' +
                '  · "What are the double-angle formulas" → mode="identity", category="double_angle"\n' +
                'CRITICAL: Return ONLY valid JSON, no fences. If no problem found, return [].\n' +
                'Example: "Prove tan^2 x − sin^2 x = tan^2 x · sin^2 x" → [{"mode":"prove","lhs":"tan(x)^2 - sin(x)^2","rhs":"tan(x)^2 * sin(x)^2","display":"\\\\tan^2 x - \\\\sin^2 x = \\\\tan^2 x \\\\cdot \\\\sin^2 x"}]',
            onSelect: function (problem) {
                var apply = function () {
                    var mode = problem.mode || 'identity';
                    var modeBtn = document.querySelector('.trig-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    if (mode === 'prove') {
                        var lhsEl = document.getElementById('trig-lhs');
                        var rhsEl = document.getElementById('trig-rhs');
                        if (lhsEl) { lhsEl.value = problem.lhs || ''; lhsEl.dispatchEvent(new Event('input', { bubbles: true })); }
                        if (rhsEl) { rhsEl.value = problem.rhs || ''; rhsEl.dispatchEvent(new Event('input', { bubbles: true })); }
                    } else {
                        if (problem.category) {
                            var sel = document.getElementById('trig-identity-type');
                            if (sel) {
                                sel.value = problem.category;
                                sel.dispatchEvent(new Event('change', { bubbles: true }));
                            }
                        }
                    }
                    setTimeout(function () {
                        var b = document.getElementById('trig-calc-btn'); if (b) b.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else { apply(); }
            }
        });
    })();

    // ── FAQ accordion + scroll-anim ──
    (function () {
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () { q.closest('.ms-faq-item').classList.toggle('open'); });
        });
        var els = document.querySelectorAll('.trig-anim');
        if (els.length && 'IntersectionObserver' in window) {
            var io = new IntersectionObserver(function (entries) {
                entries.forEach(function (e) {
                    if (e.isIntersecting) { e.target.classList.add('trig-visible'); io.unobserve(e.target); }
                });
            }, { threshold: 0.15 });
            els.forEach(function (el) { io.observe(el); });
        }
    })();
    </script>

        <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configureTrigIdentityMathShell");
    %>
    <%@ include file="modern/components/math-ai-boot.inc.jsp" %>

    <!-- ─── Trigonometry practice worksheet (shared across all 3 trig calcs) ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
    <script>
    (function () {
        function openTrigWorksheet() {
            if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                    ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
                }
                return;
            }
            window.WorksheetEngine.open({
                jsonUrl: '<%=request.getContextPath()%>/worksheet/math/trigonometry/trigonometry.json',
                title: 'Trigonometry',
                accentColor: '#15803d',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        }
        function whenReady(fn) {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', fn);
            } else { fn(); }
        }
        whenReady(function () {
            var primary = document.getElementById('trig-worksheet-btn');
            if (primary) primary.addEventListener('click', openTrigWorksheet);
            var toolbar = document.getElementById('trig-worksheet-btn-toolbar');
            if (toolbar) toolbar.addEventListener('click', openTrigWorksheet);
        });
    })();
    </script>
</body>
</html>
