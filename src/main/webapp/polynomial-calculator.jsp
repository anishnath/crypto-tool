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
        <jsp:param name="toolName" value="Polynomial Calculator with Steps - Factor, Roots, Division" />
        <jsp:param name="toolDescription" value="Free polynomial calculator with step-by-step solutions. Add, subtract, multiply, divide, factor, find roots of any degree polynomial." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="polynomial-calculator.jsp" />
        <jsp:param name="toolKeywords" value="polynomial calculator, polynomial calculator with steps, factor polynomial, polynomial long division calculator, find roots of polynomial, polynomial addition calculator, polynomial multiplication, polynomial solver, polynomial graphing calculator, algebra calculator, polynomial division with remainder" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Add subtract multiply divide polynomials,Step-by-step solutions with LaTeX rendering,Factor polynomials of any degree,Find all real and complex roots,Polynomial long division with remainder,Interactive graph with Plotly,Python code generation,LaTeX and share URL export" />
        <jsp:param name="teaches" value="Polynomial arithmetic, polynomial long division, polynomial factoring, root finding, Rational Root Theorem, synthetic division" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter polynomial P(x)|Type your polynomial expression like x^3+2x^2-5x+3 in the P(x) input field,Choose operation|Select an operation: Add Subtract Multiply Divide Factor Roots or Evaluate,Enter Q(x) if needed|For two-polynomial operations enter the second polynomial Q(x),Click Calculate|Click the Calculate button to see the step-by-step solution with LaTeX rendering,View graph|Switch to the Graph tab to see an interactive plot of your polynomial with roots marked,Export result|Copy the LaTeX formula or share your calculation via URL" />
        <jsp:param name="faq1q" value="How do you add and subtract polynomials?" />
        <jsp:param name="faq1a" value="To add polynomials, align like terms (same power of x) and add their coefficients. Example: (x^3+2x^2-5x+3) + (x^2-4) = x^3+3x^2-5x-1. To subtract, distribute the negative sign across the second polynomial first, then combine like terms. Our calculator shows each step." />
        <jsp:param name="faq2q" value="How does polynomial long division work?" />
        <jsp:param name="faq2a" value="Polynomial long division follows the same algorithm as numerical long division. Divide the leading term of the dividend by the leading term of the divisor to get the first quotient term. Multiply the entire divisor by that term, subtract from the dividend, then repeat with the remainder. Continue until the remainder degree is less than the divisor degree." />
        <jsp:param name="faq3q" value="How do you factor a polynomial?" />
        <jsp:param name="faq3a" value="Start by factoring out the greatest common factor (GCF). For quadratics, find two numbers that multiply to ac and add to b, or use the quadratic formula. For higher degrees, try the Rational Root Theorem, synthetic division, or special patterns like difference of squares a^2-b^2=(a+b)(a-b) and sum/difference of cubes." />
        <jsp:param name="faq4q" value="Can this calculator find complex roots?" />
        <jsp:param name="faq4a" value="Yes. The Fundamental Theorem of Algebra guarantees a degree-n polynomial has exactly n roots (counted with multiplicity) over the complex numbers. Our calculator uses the Nerdamer algebra engine to find both real and complex roots. For example, x^2+1=0 returns the roots i and -i." />
        <jsp:param name="faq5q" value="What is the Rational Root Theorem?" />
        <jsp:param name="faq5a" value="The Rational Root Theorem states that any rational root p/q of a polynomial with integer coefficients must have p dividing the constant term and q dividing the leading coefficient. For x^3-6x^2+11x-6, possible rational roots are plus or minus 1, 2, 3, 6. Testing these finds roots at x=1, x=2, and x=3." />
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
                <h1 class="tool-page-title">Polynomial Calculator with Steps - Factor, Roots & Division</h1>
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

        <!-- 1. What is a Polynomial -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is a Polynomial?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>polynomial</strong> is an expression built from a variable (usually <em>x</em>), constants called <strong>coefficients</strong>, and non-negative integer exponents, joined by addition and subtraction. The general form is:</p>
            <div style="background:var(--bg-secondary);border-left:3px solid var(--poly-tool,#0d9488);padding:0.75rem 1rem;border-radius:0 0.375rem 0.375rem 0;margin:0.75rem 0;font-family:var(--font-mono);font-size:0.9375rem;color:var(--text-primary);overflow-x:auto;">
                P(x) = a<sub>n</sub>x<sup>n</sup> + a<sub>n-1</sub>x<sup>n-1</sup> + &hellip; + a<sub>1</sub>x + a<sub>0</sub>
            </div>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">where <strong>a<sub>n</sub></strong> is the <em>leading coefficient</em> (must be &ne; 0), <strong>n</strong> is the <em>degree</em>, and <strong>a<sub>0</sub></strong> is the <em>constant term</em>. For example, 3x<sup>4</sup> &minus; 2x<sup>2</sup> + 7x &minus; 5 has degree 4, leading coefficient 3, and constant term &minus;5.</p>

            <!-- Anatomy SVG diagram -->
            <svg viewBox="0 0 560 130" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:1rem 0 0.5rem;">
                <rect x="0" y="0" width="560" height="130" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <!-- polynomial text -->
                <text x="280" y="52" text-anchor="middle" font-size="22" font-weight="600" fill="var(--text-primary,#0f172a)" font-family="monospace">3x<tspan baseline-shift="super" font-size="14">4</tspan> &minus; 2x<tspan baseline-shift="super" font-size="14">2</tspan> + 7x &minus; 5</text>
                <!-- arrows and labels -->
                <line x1="95" y1="60" x2="95" y2="90" stroke="#0d9488" stroke-width="1.5"/>
                <text x="95" y="106" text-anchor="middle" font-size="10" fill="#0d9488" font-weight="600">Leading</text>
                <text x="95" y="118" text-anchor="middle" font-size="10" fill="#0d9488" font-weight="600">Coefficient (3)</text>
                <line x1="135" y1="30" x2="135" y2="16" stroke="#b45309" stroke-width="1.5"/>
                <text x="135" y="12" text-anchor="middle" font-size="10" fill="#b45309" font-weight="600">Degree (4)</text>
                <line x1="480" y1="60" x2="480" y2="90" stroke="#7c3aed" stroke-width="1.5"/>
                <text x="480" y="106" text-anchor="middle" font-size="10" fill="#7c3aed" font-weight="600">Constant</text>
                <text x="480" y="118" text-anchor="middle" font-size="10" fill="#7c3aed" font-weight="600">Term (&minus;5)</text>
                <line x1="280" y1="60" x2="280" y2="85" stroke="#94a3b8" stroke-width="1"/>
                <text x="280" y="98" text-anchor="middle" font-size="9.5" fill="#94a3b8" font-weight="500">4 terms = polynomial</text>
            </svg>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Classification by Degree</h3>
            <table class="poly-ops-table">
                <thead><tr><th>Degree</th><th>Name</th><th>General Form</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td>0</td><td style="font-family:var(--font-sans);font-weight:500;">Constant</td><td>a<sub>0</sub></td><td>7</td></tr>
                    <tr><td>1</td><td style="font-family:var(--font-sans);font-weight:500;">Linear</td><td>ax + b</td><td>2x + 3</td></tr>
                    <tr><td>2</td><td style="font-family:var(--font-sans);font-weight:500;">Quadratic</td><td>ax&sup2; + bx + c</td><td>x&sup2; &minus; 5x + 6</td></tr>
                    <tr><td>3</td><td style="font-family:var(--font-sans);font-weight:500;">Cubic</td><td>ax&sup3; + bx&sup2; + cx + d</td><td>x&sup3; &minus; 6x&sup2; + 11x &minus; 6</td></tr>
                    <tr><td>4</td><td style="font-family:var(--font-sans);font-weight:500;">Quartic</td><td>ax<sup>4</sup> + &hellip;</td><td>x<sup>4</sup> &minus; 1</td></tr>
                    <tr><td>5</td><td style="font-family:var(--font-sans);font-weight:500;">Quintic</td><td>ax<sup>5</sup> + &hellip;</td><td>x<sup>5</sup> &minus; x &minus; 1</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Classification by Number of Terms</h3>
            <div class="poly-edu-grid">
                <div class="poly-edu-card">
                    <h4>Monomial (1 term)</h4>
                    <p>A single term: 5x&sup3;, &minus;2x, 7. No addition or subtraction involved.</p>
                </div>
                <div class="poly-edu-card">
                    <h4>Binomial (2 terms)</h4>
                    <p>Two terms: x&sup2; &minus; 4, 3x + 1. The difference of squares a&sup2; &minus; b&sup2; is always a binomial.</p>
                </div>
                <div class="poly-edu-card">
                    <h4>Trinomial (3 terms)</h4>
                    <p>Three terms: x&sup2; &minus; 5x + 6. Standard quadratics ax&sup2; + bx + c are trinomials.</p>
                </div>
            </div>
        </div>

        <!-- 2. How to Add and Subtract Polynomials -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Add and Subtract Polynomials</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Adding and subtracting polynomials means <strong>combining like terms</strong> &mdash; terms with the same variable raised to the same power. The key rule: you can only add or subtract coefficients of matching degree terms.</p>

            <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">Addition: Step-by-Step</h3>
            <ol style="color:var(--text-secondary);line-height:2;padding-left:1.25rem;margin:0 0 0.75rem;">
                <li><strong>Write both polynomials in standard form</strong> (descending powers).</li>
                <li><strong>Align like terms</strong> vertically &mdash; match x&sup3; with x&sup3;, x&sup2; with x&sup2;, etc.</li>
                <li><strong>Add the coefficients</strong> of each group of like terms.</li>
                <li><strong>Write the result</strong> in standard form, dropping any zero-coefficient terms.</li>
            </ol>
            <div style="background:var(--bg-secondary);padding:1rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:1.9;overflow-x:auto;color:var(--text-primary);">
                &nbsp;&nbsp;(x&sup3; + 2x&sup2; &minus; 5x + 3)<br>
                + (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; x&sup2; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&minus; 4)<br>
                <span style="border-top:1px solid var(--border);display:inline-block;width:100%;margin:0.125rem 0;"></span>
                = x&sup3; + 3x&sup2; &minus; 5x &minus; 1
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Subtraction: Step-by-Step</h3>
            <p style="color:var(--text-secondary);margin-bottom:0.5rem;line-height:1.7;">Subtraction has one extra step: <strong>distribute the negative sign</strong> to every term of the second polynomial before combining like terms.</p>
            <div style="background:var(--bg-secondary);padding:1rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:1.9;overflow-x:auto;color:var(--text-primary);">
                (3x&sup3; &minus; x&sup2; + 4) &minus; (x&sup3; + 2x &minus; 1)<br>
                = 3x&sup3; &minus; x&sup2; + 4 <span style="color:var(--poly-tool,#0d9488);font-weight:600;">&minus; x&sup3; &minus; 2x + 1</span> &nbsp;&larr; distribute the negative<br>
                = 2x&sup3; &minus; x&sup2; &minus; 2x + 5
            </div>
        </div>

        <!-- 3. How to Multiply Polynomials -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Multiply Polynomials</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">To multiply polynomials, <strong>distribute each term</strong> of the first polynomial across every term of the second, then combine like terms. For two binomials, this is called the <strong>FOIL method</strong> (First, Outer, Inner, Last).</p>

            <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">FOIL Method for Binomials</h3>
            <div style="background:var(--bg-secondary);padding:1rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:1.9;overflow-x:auto;color:var(--text-primary);">
                (x + 3)(x &minus; 2)<br>
                = x&middot;x + x&middot;(&minus;2) + 3&middot;x + 3&middot;(&minus;2) &nbsp;&larr; <span style="color:var(--text-muted);">F + O + I + L</span><br>
                = x&sup2; &minus; 2x + 3x &minus; 6<br>
                = x&sup2; + x &minus; 6
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">General Distribution</h3>
            <p style="color:var(--text-secondary);margin-bottom:0.5rem;line-height:1.7;">For polynomials with more than two terms, distribute every term of the first polynomial to every term of the second. The degree of the result equals the sum of the two input degrees.</p>
            <div style="background:var(--bg-secondary);padding:1rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:1.9;overflow-x:auto;color:var(--text-primary);">
                (x&sup2; + 2x + 1)(x &minus; 3)<br>
                = x&sup2;&middot;x + x&sup2;&middot;(&minus;3) + 2x&middot;x + 2x&middot;(&minus;3) + 1&middot;x + 1&middot;(&minus;3)<br>
                = x&sup3; &minus; 3x&sup2; + 2x&sup2; &minus; 6x + x &minus; 3<br>
                = x&sup3; &minus; x&sup2; &minus; 5x &minus; 3
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Special Products to Memorize</h3>
            <table class="poly-ops-table">
                <thead><tr><th>Pattern</th><th>Formula</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Perfect Square</td><td>(a + b)&sup2; = a&sup2; + 2ab + b&sup2;</td><td>(x + 3)&sup2; = x&sup2; + 6x + 9</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Perfect Square</td><td>(a &minus; b)&sup2; = a&sup2; &minus; 2ab + b&sup2;</td><td>(x &minus; 4)&sup2; = x&sup2; &minus; 8x + 16</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Difference of Squares</td><td>(a + b)(a &minus; b) = a&sup2; &minus; b&sup2;</td><td>(x + 5)(x &minus; 5) = x&sup2; &minus; 25</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Sum of Cubes</td><td>a&sup3; + b&sup3; = (a + b)(a&sup2; &minus; ab + b&sup2;)</td><td>x&sup3; + 8 = (x + 2)(x&sup2; &minus; 2x + 4)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Diff. of Cubes</td><td>a&sup3; &minus; b&sup3; = (a &minus; b)(a&sup2; + ab + b&sup2;)</td><td>x&sup3; &minus; 1 = (x &minus; 1)(x&sup2; + x + 1)</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Polynomial Long Division -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Polynomial Long Division &mdash; Step by Step</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Polynomial long division works exactly like the long division you learned with numbers. It divides a polynomial <strong>P(x)</strong> (dividend) by another polynomial <strong>D(x)</strong> (divisor) to produce a <strong>quotient Q(x)</strong> and a <strong>remainder R(x)</strong> such that:</p>
            <div style="background:var(--bg-secondary);border-left:3px solid var(--poly-tool,#0d9488);padding:0.75rem 1rem;border-radius:0 0.375rem 0.375rem 0;margin:0.75rem 0;font-family:var(--font-mono);font-size:0.9375rem;color:var(--text-primary);overflow-x:auto;">
                P(x) = D(x) &middot; Q(x) + R(x), &nbsp; where deg(R) &lt; deg(D)
            </div>

            <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">Algorithm</h3>
            <ol style="color:var(--text-secondary);line-height:2;padding-left:1.25rem;margin:0 0 0.75rem;">
                <li><strong>Divide</strong> the leading term of the dividend by the leading term of the divisor. This gives the first term of the quotient.</li>
                <li><strong>Multiply</strong> the entire divisor by that quotient term.</li>
                <li><strong>Subtract</strong> the result from the dividend to get a new (reduced) polynomial.</li>
                <li><strong>Repeat</strong> steps 1&ndash;3 using the new polynomial as the dividend, until the degree of the remainder is less than the degree of the divisor.</li>
            </ol>

            <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">Worked Example: (x&sup3; + 2x&sup2; &minus; 5x + 3) &div; (x &minus; 1)</h3>
            <div style="background:var(--bg-secondary);padding:1rem 1.25rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:2.2;overflow-x:auto;color:var(--text-primary);">
                <strong>Step 1:</strong> x&sup3; &div; x = x&sup2;. &nbsp; Multiply: x&sup2;(x &minus; 1) = x&sup3; &minus; x&sup2;. &nbsp; Subtract: 3x&sup2; &minus; 5x + 3<br>
                <strong>Step 2:</strong> 3x&sup2; &div; x = 3x. &nbsp; Multiply: 3x(x &minus; 1) = 3x&sup2; &minus; 3x. &nbsp; Subtract: &minus;2x + 3<br>
                <strong>Step 3:</strong> &minus;2x &div; x = &minus;2. &nbsp; Multiply: &minus;2(x &minus; 1) = &minus;2x + 2. &nbsp; Subtract: 1<br>
                <span style="border-top:1px solid var(--border);display:inline-block;width:100%;margin:0.25rem 0;"></span>
                <strong>Result:</strong> Q(x) = x&sup2; + 3x &minus; 2, &nbsp; R(x) = 1<br>
                <strong>Check:</strong> (x &minus; 1)(x&sup2; + 3x &minus; 2) + 1 = x&sup3; + 2x&sup2; &minus; 5x + 3 &nbsp; &#10003;
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Synthetic Division (Shortcut)</h3>
            <p style="color:var(--text-secondary);line-height:1.7;">When dividing by a <strong>linear divisor</strong> of the form (x &minus; c), you can use <strong>synthetic division</strong> instead. Write only the coefficients of the dividend, bring down the first coefficient, multiply by c, add to the next coefficient, and repeat. The last number is the remainder. Synthetic division is faster but only works when the divisor is linear.</p>
        </div>

        <!-- 5. How to Factor Polynomials -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Factor Polynomials</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Factoring means writing a polynomial as a <strong>product of simpler polynomials</strong>. It is the reverse of multiplication. Factoring is essential for solving polynomial equations, simplifying rational expressions, and finding roots.</p>

            <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary);">Factoring Strategy (in order)</h3>
            <ol style="color:var(--text-secondary);line-height:2;padding-left:1.25rem;margin:0 0 1rem;">
                <li><strong>Factor out the GCF</strong> (Greatest Common Factor). Always do this first. Example: 6x&sup3; &minus; 9x&sup2; = 3x&sup2;(2x &minus; 3).</li>
                <li><strong>Count the terms:</strong>
                    <ul style="margin:0.25rem 0 0.25rem 1rem;line-height:2;">
                        <li><em>2 terms</em> &rarr; Check difference of squares, sum/difference of cubes.</li>
                        <li><em>3 terms</em> &rarr; Try trinomial factoring (find two numbers that multiply to ac and add to b), or use the quadratic formula.</li>
                        <li><em>4+ terms</em> &rarr; Try factoring by grouping.</li>
                    </ul>
                </li>
                <li><strong>Check each factor</strong> to see if it can be factored further.</li>
                <li><strong>Verify</strong> by multiplying the factors back together.</li>
            </ol>

            <h3 style="font-size:1rem;margin:0.5rem 0 0.5rem;color:var(--text-primary);">Factoring Formulas Reference</h3>
            <table class="poly-ops-table">
                <thead><tr><th style="width:40%;">Pattern</th><th>Factored Form</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Difference of Squares</td><td>a&sup2; &minus; b&sup2; = (a + b)(a &minus; b)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Perfect Square Trinomial</td><td>a&sup2; + 2ab + b&sup2; = (a + b)&sup2;</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Sum of Cubes</td><td>a&sup3; + b&sup3; = (a + b)(a&sup2; &minus; ab + b&sup2;)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Difference of Cubes</td><td>a&sup3; &minus; b&sup3; = (a &minus; b)(a&sup2; + ab + b&sup2;)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Trinomial (a=1)</td><td>x&sup2; + bx + c = (x + p)(x + q) where pq = c, p+q = b</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Grouping (4 terms)</td><td>ax + ay + bx + by = (a + b)(x + y)</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example: Factor x&sup3; &minus; 6x&sup2; + 11x &minus; 6</h3>
            <div style="background:var(--bg-secondary);padding:1rem 1.25rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:2.2;overflow-x:auto;color:var(--text-primary);">
                <strong>1.</strong> Possible rational roots (p/q): &plusmn;1, &plusmn;2, &plusmn;3, &plusmn;6<br>
                <strong>2.</strong> Test x = 1: &nbsp; 1 &minus; 6 + 11 &minus; 6 = 0 &nbsp; &#10003; &nbsp; So (x &minus; 1) is a factor<br>
                <strong>3.</strong> Divide out: (x&sup3; &minus; 6x&sup2; + 11x &minus; 6) &div; (x &minus; 1) = x&sup2; &minus; 5x + 6<br>
                <strong>4.</strong> Factor the quadratic: x&sup2; &minus; 5x + 6 = (x &minus; 2)(x &minus; 3)<br>
                <span style="border-top:1px solid var(--border);display:inline-block;width:100%;margin:0.25rem 0;"></span>
                <strong>Result:</strong> x&sup3; &minus; 6x&sup2; + 11x &minus; 6 = (x &minus; 1)(x &minus; 2)(x &minus; 3)
            </div>
        </div>

        <!-- 6. Finding Roots of Polynomials -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Find the Roots of a Polynomial</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>roots</strong> (or zeros) of a polynomial P(x) are the values of x where P(x) = 0. Graphically, roots are the x-intercepts of the polynomial curve. Finding roots is one of the most important problems in algebra.</p>

            <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">Methods by Degree</h3>
            <table class="poly-ops-table">
                <thead><tr><th>Degree</th><th>Method</th><th>Formula / Technique</th></tr></thead>
                <tbody>
                    <tr><td>1 (Linear)</td><td style="font-family:var(--font-sans);font-weight:500;">Isolate x</td><td>ax + b = 0 &rarr; x = &minus;b/a</td></tr>
                    <tr><td>2 (Quadratic)</td><td style="font-family:var(--font-sans);font-weight:500;">Quadratic Formula</td><td>x = (&minus;b &plusmn; &radic;(b&sup2; &minus; 4ac)) / 2a</td></tr>
                    <tr><td>3+ (Higher)</td><td style="font-family:var(--font-sans);font-weight:500;">Rational Root Theorem + Synthetic Division</td><td>Test p/q candidates, factor out found roots, reduce degree</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">The Rational Root Theorem</h3>
            <p style="color:var(--text-secondary);margin-bottom:0.5rem;line-height:1.7;">For a polynomial with <strong>integer coefficients</strong>, any rational root p/q (in lowest terms) must satisfy: <strong>p divides the constant term</strong> and <strong>q divides the leading coefficient</strong>. This gives a finite list of candidates to test.</p>
            <div style="background:var(--bg-secondary);padding:1rem 1.25rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:2;overflow-x:auto;color:var(--text-primary);">
                <strong>Example:</strong> 2x&sup3; &minus; 3x&sup2; &minus; 8x + 12<br>
                Constant term = 12 &rarr; divisors of 12: &plusmn;1, &plusmn;2, &plusmn;3, &plusmn;4, &plusmn;6, &plusmn;12<br>
                Leading coefficient = 2 &rarr; divisors of 2: &plusmn;1, &plusmn;2<br>
                Candidates (p/q): &plusmn;1, &plusmn;2, &plusmn;3, &plusmn;4, &plusmn;6, &plusmn;12, &plusmn;1/2, &plusmn;3/2
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">The Discriminant (Quadratic)</h3>
            <p style="color:var(--text-secondary);line-height:1.7;">For a quadratic ax&sup2; + bx + c, the discriminant <strong>&Delta; = b&sup2; &minus; 4ac</strong> determines the nature of roots: if &Delta; &gt; 0, two distinct real roots; if &Delta; = 0, one repeated real root; if &Delta; &lt; 0, two complex conjugate roots.</p>
        </div>

        <!-- 7. Fundamental Theorem of Algebra -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The Fundamental Theorem of Algebra</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>Fundamental Theorem of Algebra</strong> states that every non-constant polynomial with complex coefficients has at least one complex root. The key consequence: a polynomial of degree <em>n</em> has <strong>exactly n roots</strong> when counted with multiplicity (over the complex numbers).</p>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">This means any degree-n polynomial can be completely factored into n linear factors:</p>
            <div style="background:var(--bg-secondary);border-left:3px solid var(--poly-tool,#0d9488);padding:0.75rem 1rem;border-radius:0 0.375rem 0.375rem 0;margin:0.75rem 0;font-family:var(--font-mono);font-size:0.9375rem;color:var(--text-primary);overflow-x:auto;">
                P(x) = a<sub>n</sub>(x &minus; r<sub>1</sub>)(x &minus; r<sub>2</sub>) &hellip; (x &minus; r<sub>n</sub>)
            </div>
            <p style="color:var(--text-secondary);margin-bottom:0;line-height:1.7;"><strong>Example:</strong> x&sup3; &minus; 1 has exactly 3 roots: x = 1 (real), x = &minus;1/2 + (&radic;3/2)i, and x = &minus;1/2 &minus; (&radic;3/2)i (complex conjugate pair). Complex roots of real-coefficient polynomials always come in conjugate pairs.</p>
        </div>

        <!-- 8. Polynomial Operations Reference (quick table) -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Polynomial Operations Quick Reference</h2>
            <table class="poly-ops-table">
                <thead><tr><th style="width:20%;">Operation</th><th style="width:35%;">Rule</th><th style="width:25%;">Example</th><th>Result Degree</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Addition</td><td>Combine like terms</td><td>(x&sup2;+3x) + (2x&sup2;&minus;x)</td><td>max(deg P, deg Q)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Subtraction</td><td>Distribute negative, combine</td><td>(x&sup2;+3x) &minus; (2x&sup2;&minus;x)</td><td>max(deg P, deg Q)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Multiplication</td><td>Distribute each term (FOIL)</td><td>(x+1)(x&minus;2)</td><td>deg P + deg Q</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Division</td><td>Long division algorithm</td><td>(x&sup3;&minus;1) &div; (x&minus;1)</td><td>deg P &minus; deg Q</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Factoring</td><td>GCF, grouping, formulas</td><td>x&sup2;&minus;5x+6</td><td>&mdash;</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Roots</td><td>Solve P(x) = 0</td><td>x&sup2;&minus;4 = 0</td><td>n roots (deg n)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Evaluate</td><td>Substitute x = a</td><td>P(2) where P = x&sup2;+1</td><td>scalar</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 9. FAQ -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you add and subtract polynomials?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To add polynomials, align like terms (same power of x) and add their coefficients. Example: (x&sup3;+2x&sup2;&minus;5x+3) + (x&sup2;&minus;4) = x&sup3;+3x&sup2;&minus;5x&minus;1. To subtract, distribute the negative sign across the second polynomial first, then combine like terms. Our calculator shows each step.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How does polynomial long division work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Polynomial long division follows the same algorithm as numerical long division. Divide the leading term of the dividend by the leading term of the divisor to get the first quotient term. Multiply the entire divisor by that term, subtract from the dividend, then repeat. Continue until the remainder degree is less than the divisor degree. The result is P(x) = D(x)&middot;Q(x) + R(x).</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you factor a polynomial?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Start by factoring out the greatest common factor (GCF). For quadratics, find two numbers that multiply to ac and add to b, or use the quadratic formula. For higher degrees, try the Rational Root Theorem to find rational roots, then use synthetic division to reduce the degree. Special patterns include difference of squares a&sup2;&minus;b&sup2;=(a+b)(a&minus;b) and sum/difference of cubes.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Can this calculator find complex roots?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes. The Fundamental Theorem of Algebra guarantees a degree-n polynomial has exactly n roots (counted with multiplicity) over the complex numbers. Our calculator uses the Nerdamer algebra engine to find both real and complex roots. For example, x&sup2;+1=0 returns the roots i and &minus;i. Complex roots of real-coefficient polynomials always come in conjugate pairs.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the Rational Root Theorem?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The Rational Root Theorem states that any rational root p/q of a polynomial with integer coefficients must have p dividing the constant term and q dividing the leading coefficient. For x&sup3;&minus;6x&sup2;+11x&minus;6, possible rational roots are &plusmn;1, &plusmn;2, &plusmn;3, &plusmn;6. Testing these finds roots at x=1, x=2, and x=3.</div></div>
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
