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
    <meta name="context-path" content="<%=request.getContextPath()%>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        *:focus-visible{outline:2px solid var(--primary);outline-offset:2px}
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
        :root,:root[data-theme="light"]{
            --primary:#6366f1;--primary-dark:#4f46e5;--primary-light:#818cf8;--primary-50:#eef2ff;--primary-100:#e0e7ff;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;--bg-hover:#f8fafc;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;--text-inverse:#fff;
            --border:#e2e8f0;--border-light:#f1f5f9;--border-dark:#cbd5e1;
            --success:#10b981;--warning:#f59e0b;--error:#ef4444;--info:#3b82f6;
            --font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code','SF Mono',Consolas,monospace;
            --text-xs:0.75rem;--text-sm:0.875rem;--text-base:1rem;--text-lg:1.125rem;--text-xl:1.25rem;--text-2xl:1.5rem;
            --leading-tight:1.25;--leading-normal:1.5;
            --font-normal:400;--font-medium:500;--font-semibold:600;--font-bold:700;
            --space-1:0.25rem;--space-2:0.5rem;--space-3:0.75rem;--space-4:1rem;--space-5:1.25rem;--space-6:1.5rem;--space-8:2rem;--space-10:2.5rem;--space-12:3rem;
            --shadow-sm:0 1px 2px 0 rgba(0,0,0,0.05);--shadow-md:0 4px 6px -1px rgba(0,0,0,0.1),0 2px 4px -2px rgba(0,0,0,0.1);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1),0 4px 6px -4px rgba(0,0,0,0.1);
            --radius-sm:0.375rem;--radius-md:0.5rem;--radius-lg:0.75rem;--radius-xl:1rem;--radius-full:9999px;
            --z-dropdown:1000;--z-sticky:1020;--z-fixed:1030;--z-modal-backdrop:1040;--z-modal:1050;
            --transition-fast:150ms ease-in-out;--transition-base:200ms ease-in-out;--transition-slow:300ms ease-in-out;
            --header-height-mobile:64px;--header-height-desktop:72px;--container-max-width:1280px;
            --tool-primary:#7c3aed;--tool-primary-dark:#6d28d9;--tool-gradient:linear-gradient(135deg,#7c3aed 0%,#a78bfa 100%);--tool-light:#ede9fe
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(124,58,237,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed,1030);background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);box-shadow:var(--shadow-sm);height:var(--header-height-desktop,72px)}
        .nav-container{max-width:1400px;margin:0 auto;padding:0 var(--space-4,1rem);display:flex;align-items:center;justify-content:space-between;height:100%}
        .nav-logo{display:flex;align-items:center;gap:var(--space-3,0.75rem);text-decoration:none;font-weight:700;font-size:var(--text-lg,1.125rem)}
        .nav-logo img{width:32px;height:32px;border-radius:var(--radius-md,0.5rem)}
        .nav-logo span{background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-weight:700;letter-spacing:-0.02em}
        [data-theme="dark"] .nav-logo span{background:linear-gradient(135deg,#818cf8 0%,#a78bfa 50%,#f472b6 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:0.5rem;transition:opacity .15s,transform .15s}
        .tool-action-btn:hover{opacity:0.9}
        .tool-result-card{display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Trigonometric Identity Calculator - Prove & Verify Step by Step" />
        <jsp:param name="toolDescription" value="Free trig identity calculator with AI-powered step-by-step proofs. Browse all Pythagorean, double angle, sum-to-product identities. Verify or disprove any trigonometric identity online." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="trigonometric-identity-calculator.jsp" />
        <jsp:param name="toolKeywords" value="trigonometric identity calculator, prove trig identity, trig identity solver, Pythagorean identity, double angle formula, half angle formula, sum to product formula, product to sum, verify trig identity, trig identity list" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Browse 8 identity categories with LaTeX formulas,Pythagorean and reciprocal identities,Double angle and half angle formulas,Sum-to-product and product-to-sum conversions,AI-powered identity proofs with step-by-step work,Automatic verification of identity validity,Identity reference cards with descriptions,Python SymPy code generation" />
        <jsp:param name="teaches" value="Trigonometric identities, Pythagorean identities, double angle formulas, half angle formulas, sum-to-product conversions, proving identities, identity verification" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select Identities to browse identity formulas or Prove to verify an identity,Select Category or Enter Sides|In Identities mode choose a category like Pythagorean or Double Angle and in Prove mode enter the LHS and RHS expressions,Click Calculate|Press Calculate to display identity formulas or start the AI-powered step-by-step proof,Review Steps|Each proof step shows the identity used and the algebraic transformation with LaTeX rendering,View Graph|Switch to Graph tab to see both sides of the identity plotted to visually verify equality,Export Code|Switch to Python tab to get SymPy code for symbolic verification" />
        <jsp:param name="faq1q" value="What trigonometric identities are available?" />
        <jsp:param name="faq1a" value="We cover 8 complete categories: Pythagorean, sum and difference, double angle, half angle, negative angle, sum-to-product, product-to-sum, and cofunction identities. Each category shows all formulas with rendered LaTeX." />
        <jsp:param name="faq2q" value="How does the identity prover work?" />
        <jsp:param name="faq2a" value="Enter the left-hand side (LHS) and right-hand side (RHS) of the identity you want to prove. Our AI verifies the identity first, then works one side step-by-step using known identities until it matches the other side. If the identity is false, it provides a counterexample." />
        <jsp:param name="faq3q" value="Can it detect false identities?" />
        <jsp:param name="faq3a" value="Yes. The prover first checks if both sides are actually equal by simplifying independently. If the identity is false, it clearly states Not a valid identity and shows a specific counterexample angle with numeric values for both sides." />
        <jsp:param name="faq4q" value="What is the Pythagorean identity?" />
        <jsp:param name="faq4a" value="The fundamental Pythagorean identity is sin squared theta plus cos squared theta equals 1. It derives from the Pythagorean theorem on the unit circle. Two related forms are 1 plus tan squared theta equals sec squared theta, and 1 plus cot squared theta equals csc squared theta." />
        <jsp:param name="faq5q" value="What are double angle formulas used for?" />
        <jsp:param name="faq5a" value="Double angle formulas express trig functions of 2 theta in terms of theta. sin(2A)=2sinAcosA, cos(2A)=cos2A-sin2A (three forms), tan(2A)=2tanA/(1-tan2A). They are used to simplify expressions, solve equations, and integrate trig functions." />
        <jsp:param name="faq6q" value="How do I prove a trig identity manually?" />
        <jsp:param name="faq6a" value="Work on one side only, usually the more complex side. Convert everything to sine and cosine. Apply Pythagorean identities to simplify. Factor or combine fractions. Use double angle or sum-to-product formulas when needed. Never cross the equals sign to move terms between sides." />
    </jsp:include>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/trigonometry-calculator.css?v=<%=cacheVersion%>">
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Trigonometric Identity Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Trig Identity Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">2 Modes</span>
                <span class="tool-badge">Prove</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>trig identity calculator</strong> with <strong>step-by-step solutions</strong>. Browse <strong>Pythagorean</strong>, <strong>double angle</strong>, <strong>sum-to-product</strong> identities and more. <strong>Prove trig identities</strong> by entering both sides and see each transformation explained.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <text x="3" y="17" font-size="16" font-weight="700" fill="currentColor" font-family="serif" stroke="none">&equiv;</text>
                    </svg>
                    Trig Identity Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Mode</label>
                        <div class="trig-mode-toggle">
                            <button type="button" class="trig-mode-btn active" data-mode="identity">Identities</button>
                            <button type="button" class="trig-mode-btn" data-mode="prove">Prove</button>
                        </div>
                    </div>

                    <!-- Identity Mode Inputs -->
                    <div id="trig-identity-group">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="trig-identity-type">Identity Category</label>
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

                    <!-- Optional Expression -->
                    <div class="tool-form-group" id="trig-expr-group">
                        <label class="tool-form-label" for="trig-expr">Expression (Optional)</label>
                        <input type="text" class="trig-input-text" id="trig-expr" value="" autocomplete="off" spellcheck="false" placeholder="e.g. sin(x)^2 + cos(x)^2 (optional)">
                        <div class="tool-form-hint">Optional: apply identity to a specific expression</div>
                    </div>

                    <!-- Prove Mode Inputs -->
                    <div id="trig-prove-group" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="trig-lhs">Left-Hand Side (LHS)</label>
                            <input type="text" class="trig-input-text" id="trig-lhs" value="" autocomplete="off" spellcheck="false" placeholder="e.g. tan(x)^2 - sin(x)^2">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="trig-rhs">Right-Hand Side (RHS)</label>
                            <input type="text" class="trig-input-text" id="trig-rhs" value="" autocomplete="off" spellcheck="false" placeholder="e.g. tan(x)^2 * sin(x)^2">
                        </div>
                        <div class="tool-form-hint">Enter both sides of the identity to prove</div>
                    </div>

                    <!-- Live Preview -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Preview</label>
                        <div class="trig-preview" id="trig-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Select a category or enter an expression&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="trig-calc-btn">Calculate</button>
                    <button type="button" class="tool-action-btn" id="trig-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);margin-top:0.5rem;">Clear</button>

                    <hr class="trig-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="trig-examples">
                            <button type="button" class="trig-example-chip" data-example="id-pythagorean">Pythagorean</button>
                            <button type="button" class="trig-example-chip" data-example="id-double">Double Angle</button>
                            <button type="button" class="trig-example-chip" data-example="id-sum2prod">Sum&rarr;Product</button>
                            <button type="button" class="trig-example-chip" data-example="prove-tansin">Prove tan&sup2;&minus;sin&sup2;</button>
                            <button type="button" class="trig-example-chip" data-example="prove-cos2x">Prove (1-cos2x)/sin2x</button>
                        </div>
                    </div>

                    <!-- Related Tools -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Related Tools</label>
                        <div class="trig-related">
                            <a href="<%=request.getContextPath()%>/trigonometric-function-calculator.jsp" class="trig-related-link">Trig Functions</a>
                            <a href="<%=request.getContextPath()%>/trigonometric-equation-solver.jsp" class="trig-related-link">Trig Equations</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="trig-output-tabs">
                <button type="button" class="trig-output-tab active" data-panel="result">Result</button>
                <button type="button" class="trig-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="trig-output-tab" data-panel="python">Python</button>
            </div>

            <div class="trig-panel active" id="trig-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="trig-result-content">
                        <div class="tool-empty-state" id="trig-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&equiv;</div>
                            <h3>Select an identity category or prove an identity</h3>
                            <p>Browse identity formulas or enter both sides to prove an identity step-by-step.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="trig-result-actions">
                        <button type="button" class="tool-action-btn" id="trig-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="trig-share-btn">&#128279; Share</button>
                    </div>
                </div>
            </div>

            <div class="trig-panel" id="trig-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><circle cx="12" cy="12" r="10"/><line x1="12" y1="2" x2="12" y2="22"/><line x1="2" y1="12" x2="22" y2="12"/></svg>
                        <h4>Function Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="trig-graph-container"></div>
                        <p id="trig-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate to see the graph.</p>
                    </div>
                </div>
            </div>

            <div class="trig-panel" id="trig-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="trig-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Are Trig Identities -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Trigonometric Identities?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Trigonometric identities are equations involving trig functions that hold true for <strong>all values</strong> of the variable where both sides are defined. Unlike trig <em>equations</em> (which are true only for specific angles), identities are <strong>universal truths</strong>. They are essential tools for simplifying expressions, solving equations, evaluating integrals, and proving new results in mathematics, physics, and engineering.</p>

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

        <!-- 2. The Pythagorean Identities -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The Pythagorean Identities &mdash; The Foundation</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The Pythagorean identities are derived directly from the <strong>Pythagorean theorem</strong> applied to the unit circle. Since any point on the unit circle satisfies x&sup2; + y&sup2; = 1, and x = cos &theta;, y = sin &theta;, we get the fundamental identity and its two derived forms:</p>

            <div class="trig-formula-box" style="text-align:center;font-size:1.0625rem;">
                sin&sup2;&theta; + cos&sup2;&theta; = 1
            </div>
            <div class="trig-formula-box" style="text-align:center;font-size:0.875rem;margin-top:0.5rem;">
                1 + tan&sup2;&theta; = sec&sup2;&theta; &nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp; 1 + cot&sup2;&theta; = csc&sup2;&theta;
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">How They Connect</h3>
            <p style="color:var(--text-secondary);line-height:1.7;">Divide sin&sup2;&theta; + cos&sup2;&theta; = 1 by <strong>cos&sup2;&theta;</strong> to get the tangent-secant form. Divide by <strong>sin&sup2;&theta;</strong> to get the cotangent-cosecant form. These three identities are the most frequently used in all of trigonometry.</p>
        </div>

        <!-- 3. Double Angle & Sum/Difference -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Double Angle &amp; Sum/Difference Formulas</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">These formulas let you express trig functions of <strong>combined angles</strong> (A+B, A&minus;B, 2A) in terms of functions of individual angles. They are critical for calculus integration, Fourier analysis, and solving complex trig equations.</p>

            <h3 style="font-size:1rem;margin:0.75rem 0 0.5rem;color:var(--text-primary);">Sum &amp; Difference</h3>
            <table class="trig-ops-table">
                <thead><tr><th style="width:40%;">Identity</th><th>Formula</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">sin(A &plusmn; B)</td><td>sin A cos B &plusmn; cos A sin B</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">cos(A &plusmn; B)</td><td>cos A cos B &mp; sin A sin B</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">tan(A &plusmn; B)</td><td>(tan A &plusmn; tan B) / (1 &mp; tan A tan B)</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Double Angle (set B = A above)</h3>
            <table class="trig-ops-table">
                <thead><tr><th style="width:40%;">Identity</th><th>Formula</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">sin(2A)</td><td>2 sin A cos A</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">cos(2A)</td><td>cos&sup2;A &minus; sin&sup2;A = 2cos&sup2;A &minus; 1 = 1 &minus; 2sin&sup2;A</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">tan(2A)</td><td>2 tan A / (1 &minus; tan&sup2;A)</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. How to Prove Identities -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Prove Trigonometric Identities &mdash; Step-by-Step Strategy</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Proving trig identities is one of the most common skills tested in precalculus and calculus. The goal is to transform one side of the equation until it looks exactly like the other side, using only known identities and algebra.</p>

            <ol style="color:var(--text-secondary);line-height:2.2;padding-left:1.25rem;margin:0 0 1rem;">
                <li><strong>Work on ONE side only</strong> &mdash; pick the more complex side. Never move terms across the equals sign.</li>
                <li><strong>Convert to sin and cos</strong> &mdash; replace tan, cot, sec, csc with their definitions. This often reveals simplifications.</li>
                <li><strong>Apply Pythagorean identities</strong> &mdash; replace sin&sup2; + cos&sup2; with 1, or 1 + tan&sup2; with sec&sup2;.</li>
                <li><strong>Factor and simplify</strong> &mdash; factor common terms, combine fractions over a common denominator.</li>
                <li><strong>Use double angle / sum formulas</strong> &mdash; when you see 2A, A+B, or A&minus;B patterns.</li>
                <li><strong>Verify with a value</strong> &mdash; plug in a specific angle (like &pi;/4) to check both sides give the same number.</li>
            </ol>

            <h3 style="font-size:1rem;margin:0.5rem 0 0.5rem;color:var(--text-primary);">Worked Example: Prove tan&sup2;x &minus; sin&sup2;x = tan&sup2;x &middot; sin&sup2;x</h3>
            <div class="trig-worked-example">
                <strong>LHS:</strong> tan&sup2;x &minus; sin&sup2;x<br>
                <strong>1.</strong> = sin&sup2;x/cos&sup2;x &minus; sin&sup2;x &nbsp;&larr; <span style="color:var(--trig-tool);">convert tan to sin/cos</span><br>
                <strong>2.</strong> = sin&sup2;x &middot; (1/cos&sup2;x &minus; 1) &nbsp;&larr; <span style="color:var(--trig-tool);">factor out sin&sup2;x</span><br>
                <strong>3.</strong> = sin&sup2;x &middot; (1 &minus; cos&sup2;x)/cos&sup2;x &nbsp;&larr; <span style="color:var(--trig-tool);">common denominator</span><br>
                <strong>4.</strong> = sin&sup2;x &middot; sin&sup2;x/cos&sup2;x &nbsp;&larr; <span style="color:var(--trig-tool);">Pythagorean: 1 &minus; cos&sup2;x = sin&sup2;x</span><br>
                <strong>5.</strong> = sin&sup2;x &middot; tan&sup2;x = <strong>RHS</strong> &nbsp; &#10003;
            </div>
        </div>

        <!-- 5. Complete Identity Reference -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Complete Trig Identity Quick Reference</h2>
            <table class="trig-ops-table">
                <thead><tr><th>Category</th><th>Key Formula</th><th>Common Use</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Pythagorean</td><td>sin&sup2;&theta; + cos&sup2;&theta; = 1</td><td>Simplification, substitution</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Double Angle</td><td>sin(2&theta;) = 2 sin&theta; cos&theta;</td><td>Expanding, integration</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Half Angle</td><td>sin(&theta;/2) = &plusmn;&radic;((1&minus;cos&theta;)/2)</td><td>Exact values, integration</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Sum to Product</td><td>sinA + sinB = 2sin((A+B)/2)cos((A&minus;B)/2)</td><td>Factoring, signal processing</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Product to Sum</td><td>sinA cosB = &frac12;[sin(A+B) + sin(A&minus;B)]</td><td>Integration, Fourier</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Negative Angle</td><td>sin(&minus;&theta;) = &minus;sin&theta;</td><td>Symmetry, simplification</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Cofunction</td><td>sin(&pi;/2 &minus; &theta;) = cos&theta;</td><td>Complementary angles</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What trigonometric identities are available?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">We cover 8 complete categories: Pythagorean, sum &amp; difference, double angle, half angle, negative angle, sum-to-product, product-to-sum, and cofunction identities. Each category shows all formulas with rendered LaTeX and descriptions of when each is useful.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How does the identity prover work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Enter the left-hand side (LHS) and right-hand side (RHS) of the identity you want to prove. Our AI first verifies whether the identity is actually true, then works one side step-by-step using known identities until it matches the other side, naming each identity used.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Can it detect false identities?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes. The prover first checks if both sides are actually equal by simplifying independently. If the identity is false, it clearly states &ldquo;Not a valid identity&rdquo; and shows a specific counterexample angle (like &pi;/4) with numeric values for both sides demonstrating they differ.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the Pythagorean identity and why is it important?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The fundamental Pythagorean identity is sin&sup2;&theta; + cos&sup2;&theta; = 1, derived from the Pythagorean theorem on the unit circle. It&rsquo;s the most-used identity in trigonometry, enabling substitutions like sin&sup2;&theta; = 1 &minus; cos&sup2;&theta; that simplify countless expressions and proofs.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What are double angle formulas used for?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Double angle formulas express trig functions of 2&theta; in terms of &theta;. Key formulas: sin(2A) = 2sinAcosA, cos(2A) = cos&sup2;A &minus; sin&sup2;A (three forms), tan(2A) = 2tanA/(1&minus;tan&sup2;A). They are used in simplification, equation solving, and calculus integration of trig powers.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do I prove a trig identity manually?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Work on one side only (the more complex one). Convert everything to sin and cos. Apply Pythagorean identities (sin&sup2; + cos&sup2; = 1). Factor or combine fractions. Use double angle or sum-to-product formulas when needed. Never move terms across the equals sign &mdash; transform one side until it matches the other.</div></div>
        </div>
    </section>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="trigonometric-identity-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2026 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a></div></div></footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script>
    function toggleFaq(btn){var i=btn.parentElement;var a=i.querySelector('.faq-answer');i.classList.toggle('open');}
    </script>
    <script>
    (function(){var els=document.querySelectorAll('.trig-anim');if(!els.length)return;var io=new IntersectionObserver(function(entries){entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add('trig-visible');io.unobserve(e.target);}});},{threshold:0.15});els.forEach(function(el){io.observe(el);});})();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-common.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-identity-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
