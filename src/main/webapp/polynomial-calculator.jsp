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
            --tool-primary:#0d9488;--tool-primary-dark:#0f766e;--tool-gradient:linear-gradient(135deg,#0d9488 0%,#14b8a6 100%);--tool-light:#ccfbf1
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(13,148,136,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed,1030);background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);box-shadow:var(--shadow-sm);height:var(--header-height-desktop,72px)}
        .nav-container{max-width:1400px;margin:0 auto;padding:0 var(--space-4,1rem);display:flex;align-items:center;justify-content:space-between;height:100%}
        .nav-logo{display:flex;align-items:center;gap:var(--space-3,0.75rem);text-decoration:none;font-weight:700;font-size:var(--text-lg,1.125rem)}
        .nav-logo img{width:32px;height:32px;border-radius:var(--radius-md,0.5rem)}
        .nav-logo span{background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-weight:700;letter-spacing:-0.02em}
        [data-theme="dark"] .nav-logo span{background:linear-gradient(135deg,#818cf8 0%,#a78bfa 50%,#f472b6 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .nav-items{display:flex;align-items:center;gap:var(--space-6,1.5rem);list-style:none;margin:0;padding:0}
        .nav-link{color:var(--text-secondary,#475569);text-decoration:none;font-weight:500;font-size:var(--text-base,1rem);padding:var(--space-2,0.5rem) var(--space-3,0.75rem);border-radius:var(--radius-md,0.5rem);display:flex;align-items:center;gap:var(--space-2,0.5rem)}
        .nav-actions{display:flex;align-items:center;gap:var(--space-3,0.75rem)}
        .btn-nav{padding:var(--space-2,0.5rem) var(--space-4,1rem);border-radius:var(--radius-md,0.5rem);font-size:var(--text-sm,0.875rem);font-weight:500;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:var(--space-2,0.5rem);font-family:var(--font-sans)}
        .btn-nav-primary{background:var(--primary,#6366f1);color:#fff}
        .btn-nav-secondary{background:var(--bg-secondary,#f8fafc);color:var(--text-secondary,#475569);border:1px solid var(--border,#e2e8f0)}
        .mobile-menu-toggle,.mobile-search-toggle{display:none;background:none;border:none;padding:var(--space-2,0.5rem);cursor:pointer;color:var(--text-primary)}
        .mobile-menu-toggle{font-size:var(--text-xl,1.25rem);width:40px;height:40px;align-items:center;justify-content:center;border-radius:var(--radius-md,0.5rem)}
        .nav-search{position:relative;flex:1;max-width:500px;margin:0 var(--space-6,1.5rem)}
        .search-input{width:100%;padding:var(--space-2,0.5rem) var(--space-10,2.5rem) var(--space-2,0.5rem) var(--space-4,1rem);border:2px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);font-size:var(--text-sm,0.875rem);background:var(--bg-secondary,#f8fafc);font-family:var(--font-sans)}
        .search-icon{position:absolute;right:var(--space-4,1rem);top:50%;transform:translateY(-50%);color:var(--text-muted,#94a3b8);pointer-events:none}
        @media(max-width:991px){.modern-nav{height:var(--header-height-mobile,64px)}.nav-container{padding:0 var(--space-3,0.75rem)}.nav-search,.nav-items{display:none}.nav-actions{gap:var(--space-2,0.5rem)}.btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}.mobile-menu-toggle,.mobile-search-toggle{display:flex}.btn-nav .nav-text{display:none}}
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}
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
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(13,148,136,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Polynomial Calculator - Add Subtract Multiply Divide Free Online" />
        <jsp:param name="toolDescription" value="Free polynomial calculator with step-by-step solutions. Add, subtract, multiply, divide polynomials, find roots, factor any degree. Graph + Python code." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="polynomial-calculator.jsp" />
        <jsp:param name="toolKeywords" value="polynomial calculator, polynomial addition, polynomial subtraction, polynomial multiplication, polynomial division, polynomial long division, factor polynomial, polynomial roots, polynomial solver, polynomial graph, polynomial operations, algebra calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="7 polynomial operations,Step-by-step KaTeX solutions,Interactive Plotly graph,Polynomial long division,Root finding,Factoring,Python compiler,LaTeX export,Share URL,Dark mode" />
        <jsp:param name="teaches" value="Polynomial arithmetic, long division, factoring, root finding" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How do you add and subtract polynomials?" />
        <jsp:param name="faq1a" value="To add polynomials, combine like terms by adding their coefficients. For example (x^3+2x^2-5x+3) + (x^2-4) = x^3+3x^2-5x-1. To subtract, distribute the negative sign to the second polynomial first, then combine like terms." />
        <jsp:param name="faq2q" value="How does polynomial long division work?" />
        <jsp:param name="faq2a" value="Polynomial long division works like numerical long division. Divide the leading term of the dividend by the leading term of the divisor to get the first term of the quotient. Multiply the divisor by this term, subtract from the dividend, and repeat with the remainder until the remainder has lower degree than the divisor." />
        <jsp:param name="faq3q" value="How do you factor a polynomial?" />
        <jsp:param name="faq3a" value="Common factoring methods include: extracting the greatest common factor (GCF), grouping, using special patterns like difference of squares (a^2-b^2 = (a+b)(a-b)), sum/difference of cubes, and for quadratics finding two numbers that multiply to ac and add to b." />
        <jsp:param name="faq4q" value="What is the Fundamental Theorem of Algebra?" />
        <jsp:param name="faq4a" value="The Fundamental Theorem of Algebra states that every non-constant polynomial with complex coefficients has at least one complex root. A polynomial of degree n has exactly n roots when counted with multiplicity. This means x^3-1 has exactly 3 roots: one real root (x=1) and two complex roots." />
        <jsp:param name="faq5q" value="How do you find the roots of a polynomial?" />
        <jsp:param name="faq5a" value="For quadratics use the quadratic formula. For higher degrees try the Rational Root Theorem to find integer or rational roots, then use synthetic division to reduce the degree. Factor out known roots and repeat. Some polynomials require numerical methods for irrational or complex roots." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/polynomial-calculator.css?v=<%=cacheVersion%>">
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Polynomial Calculator - Add, Subtract, Multiply, Divide with Steps</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Polynomial Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">7 Operations</span>
                <span class="tool-badge">Graph</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>polynomial calculator</strong> with <strong>step-by-step solutions</strong>. Add, subtract, multiply, and divide polynomials. Factor any polynomial, find all roots (real and complex), and evaluate at any point. Includes <strong>interactive graph</strong>, LaTeX export, and Python compiler.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <text x="2" y="18" font-size="14" font-weight="700" fill="currentColor" font-family="serif" stroke="none">P(x)</text>
                    </svg>
                    Polynomial Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Operation</label>
                        <div class="poly-mode-toggle">
                            <button type="button" class="poly-mode-btn active" data-mode="add">Add</button>
                            <button type="button" class="poly-mode-btn" data-mode="subtract">Subtract</button>
                            <button type="button" class="poly-mode-btn" data-mode="multiply">Multiply</button>
                            <button type="button" class="poly-mode-btn" data-mode="divide">Divide</button>
                            <button type="button" class="poly-mode-btn" data-mode="factor">Factor</button>
                            <button type="button" class="poly-mode-btn" data-mode="roots">Roots</button>
                            <button type="button" class="poly-mode-btn" data-mode="evaluate">Evaluate</button>
                        </div>
                    </div>

                    <!-- P(x) Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="poly-p1">P(x) &mdash; First Polynomial</label>
                        <input type="text" class="poly-input-text" id="poly-p1" value="x^3+2*x^2-5*x+3" autocomplete="off" spellcheck="false" placeholder="e.g. x^3+2*x^2-5*x+3">
                        <div class="tool-form-hint">Use ^ for powers, * for multiplication</div>
                    </div>

                    <!-- Q(x) Input -->
                    <div class="tool-form-group" id="poly-p2-group">
                        <label class="tool-form-label" for="poly-p2">Q(x) &mdash; Second Polynomial</label>
                        <input type="text" class="poly-input-text" id="poly-p2" value="x^2-4" autocomplete="off" spellcheck="false" placeholder="e.g. x^2-4">
                    </div>

                    <!-- Evaluate x input -->
                    <div class="tool-form-group" id="poly-eval-x-group" style="display:none;">
                        <label class="tool-form-label" for="poly-eval-x">Evaluate at x =</label>
                        <input type="text" class="poly-input-small" id="poly-eval-x" value="2" autocomplete="off" spellcheck="false" placeholder="e.g. 2">
                    </div>

                    <!-- Variable selector -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="poly-var">Variable</label>
                        <select class="poly-input-small" id="poly-var" style="cursor:pointer;">
                            <option value="x" selected>x</option>
                            <option value="y">y</option>
                            <option value="t">t</option>
                        </select>
                    </div>

                    <!-- Live Preview -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Live Preview</label>
                        <div class="poly-preview" id="poly-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Enter a polynomial above&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="poly-calc-btn">Calculate</button>
                    <button type="button" class="tool-action-btn" id="poly-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);margin-top:0.5rem;">Clear</button>

                    <hr class="poly-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="poly-examples">
                            <button type="button" class="poly-example-chip" data-example="add-basic">Add</button>
                            <button type="button" class="poly-example-chip" data-example="sub-basic">Subtract</button>
                            <button type="button" class="poly-example-chip" data-example="mul-binomial">(x+1)(x-2)</button>
                            <button type="button" class="poly-example-chip" data-example="div-cubic">(x&sup3;-1)/(x-1)</button>
                            <button type="button" class="poly-example-chip" data-example="factor-quad">Factor</button>
                            <button type="button" class="poly-example-chip" data-example="roots-cubic">Roots</button>
                            <button type="button" class="poly-example-chip" data-example="eval-quad">Evaluate</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="poly-output-tabs">
                <button type="button" class="poly-output-tab active" data-panel="result">Result</button>
                <button type="button" class="poly-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="poly-output-tab" data-panel="python">Python Compiler</button>
            </div>

            <!-- Result Panel -->
            <div class="poly-panel active" id="poly-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="poly-result-content">
                        <div class="tool-empty-state" id="poly-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">P(x)</div>
                            <h3>Enter polynomials and click Calculate</h3>
                            <p>Supports addition, subtraction, multiplication, division, factoring, root finding, and evaluation.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="poly-result-actions">
                        <button type="button" class="tool-action-btn" id="poly-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="poly-share-btn">&#128279; Share</button>
                    </div>
                </div>
            </div>

            <!-- Graph Panel -->
            <div class="poly-panel" id="poly-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Interactive Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="poly-graph-container"></div>
                        <p id="poly-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate a polynomial to see its graph.</p>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="poly-panel" id="poly-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                        <select id="poly-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="sympy-basic">SymPy Operations</option>
                            <option value="numpy-roots">NumPy Roots</option>
                            <option value="long-division">Long Division</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="poly-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="polynomial-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What are Polynomials?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>polynomial</strong> is a mathematical expression consisting of variables, coefficients, and non-negative integer exponents, combined using addition, subtraction, and multiplication. For example, 3x<sup>4</sup> - 2x<sup>2</sup> + 7x - 5 is a polynomial of degree 4.</p>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Polynomials are classified by <strong>degree</strong> (highest exponent): constant (0), linear (1), quadratic (2), cubic (3), quartic (4), quintic (5), etc. They are also classified by the number of <strong>terms</strong>: monomial (1 term), binomial (2 terms), trinomial (3 terms).</p>
            <div class="poly-edu-grid">
                <div class="poly-edu-card">
                    <h4>Degree</h4>
                    <p>The degree of a polynomial is the highest power of the variable. The degree of 3x<sup>4</sup> - x + 5 is 4.</p>
                </div>
                <div class="poly-edu-card">
                    <h4>Leading Coefficient</h4>
                    <p>The coefficient of the highest-degree term. In 3x<sup>4</sup> - x + 5, the leading coefficient is 3.</p>
                </div>
                <div class="poly-edu-card">
                    <h4>Constant Term</h4>
                    <p>The term with no variable. In 3x<sup>4</sup> - x + 5, the constant term is 5.</p>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Polynomial Operations Reference</h2>
            <table class="poly-ops-table">
                <thead><tr><th style="width:25%;">Operation</th><th style="width:40%;">Rule</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Addition</td><td>Combine like terms</td><td>(x&sup2;+3x) + (2x&sup2;-x) = 3x&sup2;+2x</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Subtraction</td><td>Distribute negative, combine</td><td>(x&sup2;+3x) - (2x&sup2;-x) = -x&sup2;+4x</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Multiplication</td><td>FOIL / distribute each term</td><td>(x+1)(x-2) = x&sup2;-x-2</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Division</td><td>Long division algorithm</td><td>(x&sup3;-1)/(x-1) = x&sup2;+x+1</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Factoring</td><td>GCF, grouping, special patterns</td><td>x&sup2;-5x+6 = (x-2)(x-3)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Root Finding</td><td>Solve P(x) = 0</td><td>x&sup2;-4 = 0 &rarr; x = &plusmn;2</td></tr>
                </tbody>
            </table>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Fundamental Theorem of Algebra</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>Fundamental Theorem of Algebra</strong> states that every non-constant polynomial with complex coefficients has at least one complex root. As a corollary, a polynomial of degree <em>n</em> has exactly <em>n</em> roots when counted with multiplicity (in the complex numbers).</p>
            <p style="color:var(--text-secondary);line-height:1.7;">This means that x<sup>3</sup> - 1 has exactly 3 roots: x = 1 (real) and x = -1/2 &plusmn; (&radic;3/2)i (complex). Our calculator finds all real and complex roots using algebraic methods.</p>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you add and subtract polynomials?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To add polynomials, combine like terms by adding their coefficients. For example (x&sup3;+2x&sup2;-5x+3) + (x&sup2;-4) = x&sup3;+3x&sup2;-5x-1. To subtract, distribute the negative sign to the second polynomial first, then combine like terms.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How does polynomial long division work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Polynomial long division works like numerical long division. Divide the leading term of the dividend by the leading term of the divisor to get the first term of the quotient. Multiply the divisor by this term, subtract from the dividend, and repeat with the remainder until the remainder has lower degree than the divisor.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you factor a polynomial?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Common factoring methods include: extracting the greatest common factor (GCF), grouping, using special patterns like difference of squares (a&sup2;-b&sup2; = (a+b)(a-b)), sum/difference of cubes, and for quadratics finding two numbers that multiply to ac and add to b.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the Fundamental Theorem of Algebra?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The Fundamental Theorem of Algebra states that every non-constant polynomial with complex coefficients has at least one complex root. A polynomial of degree n has exactly n roots when counted with multiplicity. This means x&sup3;-1 has exactly 3 roots: one real root (x=1) and two complex roots.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you find the roots of a polynomial?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">For quadratics use the quadratic formula. For higher degrees try the Rational Root Theorem to find integer or rational roots, then use synthetic division to reduce the degree. Factor out known roots and repeat. Some polynomials require numerical methods for irrational or complex roots.</div></div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a><a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a></div></div></footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/polynomial-calculator-render.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/polynomial-calculator-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/polynomial-calculator-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/polynomial-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
