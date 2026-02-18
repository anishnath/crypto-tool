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

    <!-- Critical CSS inlined for zero render-blocking -->
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
            --tool-primary:#4f46e5;--tool-primary-dark:#4338ca;--tool-gradient:linear-gradient(135deg,#4f46e5 0%,#6366f1 100%);--tool-light:#eef2ff
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(79,70,229,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}

        /* Nav header */
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
        @media(max-width:991px){
            .modern-nav{height:var(--header-height-mobile,64px)}
            .nav-container{padding:0 var(--space-3,0.75rem)}
            .nav-search,.nav-items{display:none}
            .nav-actions{gap:var(--space-2,0.5rem)}
            .btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}
            .mobile-menu-toggle,.mobile-search-toggle{display:flex}
            .btn-nav .nav-text{display:none}
        }

        /* Page header + breadcrumbs */
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}

        /* Description section */
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}

        /* Three-column grid */
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{min-width:0;display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{min-width:0;display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}

        /* Card + form */
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:1rem;transition:opacity .15s,transform .15s}

        /* Result card */
        .tool-result-card{min-width:0;overflow:hidden;display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{min-width:0;flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions.visible{display:flex}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}

        /* Empty state */
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}

        /* Dark mode above-fold */
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary,#cbd5e1)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(79,70,229,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}

        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Integral Calculator with Steps - Solve Integrals Step by Step Free" />
        <jsp:param name="toolDescription" value="Free online integral calculator with detailed step-by-step solutions. Solve indefinite and definite integrals instantly. Shows full working with AI-powered explanations, interactive graph with shaded area, LaTeX output, and PDF export. Supports polynomials, trigonometric, exponential, logarithmic, rational, and hyperbolic functions. No signup required." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="integral-calculator.jsp" />
        <jsp:param name="toolKeywords" value="integral calculator with steps, integration calculator step by step, antiderivative calculator, definite integral calculator, indefinite integral calculator, symbolic integration, solve integrals online free, calculus calculator with steps, integral solver, how to integrate, integration by parts calculator, u substitution calculator, trig integral calculator, download integral solution pdf" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step solutions with AI explanations,Indefinite and definite integral evaluation,Live LaTeX math preview as you type,Interactive Plotly graph with shaded area,AI-powered detailed solution steps,Download result as PDF,Polynomials and rational functions,Trigonometric and hyperbolic integration,Exponential and logarithmic functions,Integration by parts and substitution,Copy LaTeX or plain text output,Share results via URL,Built-in Python SymPy compiler,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What types of integrals can this calculator solve?" />
        <jsp:param name="faq1a" value="This calculator solves indefinite integrals (antiderivatives) and definite integrals for polynomials, trigonometric functions (sin, cos, tan, sec, csc, cot), exponential functions (e^x), logarithmic functions (ln x), rational functions, hyperbolic functions (sinh, cosh, tanh), inverse trig (arctan, arcsin), and products solved by integration by parts. It handles power rule, u-substitution, partial fractions, and more." />
        <jsp:param name="faq2q" value="Does this integral calculator show step-by-step solutions?" />
        <jsp:param name="faq2a" value="Yes. After computing a result, click the Show Steps button to see a detailed step-by-step solution. For common integrals (power rule, basic trig, exponential), steps are generated instantly. For complex integrals like integration by parts or partial fractions, AI-powered steps explain each algebraic manipulation, substitution, and simplification in 5-8 clear steps with full LaTeX math rendering." />
        <jsp:param name="faq3q" value="Can I download or share my integral solution?" />
        <jsp:param name="faq3a" value="Yes. After computing a result you can: (1) Download as PDF with the question, answer, method, and step-by-step solution beautifully formatted, (2) Copy the result as LaTeX for use in papers and documents, (3) Copy as plain text, or (4) Generate a shareable URL that loads your exact integral with one click. The PDF includes the 8gwifi.org watermark and current date." />
        <jsp:param name="faq4q" value="What is the difference between indefinite and definite integrals?" />
        <jsp:param name="faq4a" value="An indefinite integral finds the antiderivative F(x) + C, a family of functions whose derivative equals f(x). A definite integral evaluates the net signed area under the curve between bounds [a, b] using the Fundamental Theorem of Calculus: F(b) - F(a). This calculator supports both modes with a simple toggle, and the interactive graph shows the shaded area for definite integrals." />
        <jsp:param name="faq5q" value="How do I enter my function into the calculator?" />
        <jsp:param name="faq5a" value="Use standard math notation: x^2 for x squared, sin(x) for sine, e^x for exponential, ln(x) for natural log, sqrt(x) for square root, 1/x for reciprocal, sec(x)^2 for secant squared. Multiplication can be explicit (2*x) or implicit. A live KaTeX preview shows your expression in rendered math notation as you type, so you can verify the input before integrating." />
        <jsp:param name="faq6q" value="Is this integral calculator free? Do I need to sign up?" />
        <jsp:param name="faq6a" value="This integral calculator is completely free with no signup, no account, and no limits. You get symbolic integration, step-by-step solutions, interactive graphs, PDF download, LaTeX export, and a built-in Python compiler with SymPy and SciPy templates. All computation runs in your browser for instant results." />
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

    <!-- Tool-specific styles -->
    <style>
        /* ===== Input styling ===== */
        .tool-input {
            width: 100%;
            padding: 0.625rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: var(--radius-md, 0.5rem);
            font-size: 0.875rem;
            font-family: var(--font-sans);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            transition: border-color var(--transition-fast);
        }
        .tool-input:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }
        .tool-input-mono {
            font-family: var(--font-mono);
            font-size: 0.9375rem;
            letter-spacing: -0.02em;
        }
        .tool-select {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: var(--radius-md, 0.5rem);
            font-size: 0.8125rem;
            font-family: var(--font-sans);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            cursor: pointer;
        }
        [data-theme="dark"] .tool-input,
        [data-theme="dark"] .tool-select {
            background: var(--bg-tertiary);
            border-color: var(--border);
            color: var(--text-primary);
        }
        [data-theme="dark"] .tool-input:focus {
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.25);
        }

        /* ===== Mode toggle ===== */
        .ic-mode-toggle {
            display: flex;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: var(--radius-md, 0.5rem);
            overflow: hidden;
            margin-bottom: 0.875rem;
        }
        .ic-mode-btn {
            flex: 1;
            padding: 0.5rem;
            font-weight: 600;
            font-size: 0.8125rem;
            border: none;
            cursor: pointer;
            background: var(--bg-secondary);
            color: var(--text-secondary);
            transition: all 0.15s;
            font-family: var(--font-sans);
            text-align: center;
        }
        .ic-mode-btn.active {
            background: var(--tool-gradient);
            color: #fff;
        }
        .ic-mode-btn:hover:not(.active) {
            background: var(--bg-tertiary);
        }
        [data-theme="dark"] .ic-mode-btn { background: var(--bg-tertiary); }
        [data-theme="dark"] .ic-mode-btn.active { background: var(--tool-gradient); color: #fff; }
        [data-theme="dark"] .ic-mode-btn:hover:not(.active) { background: rgba(255,255,255,0.08); }

        /* ===== Live preview ===== */
        .ic-preview {
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: var(--radius-md, 0.5rem);
            padding: 0.75rem 1rem;
            min-height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: auto;
            font-size: 1.1rem;
        }
        .ic-preview .katex-display { margin: 0; }
        [data-theme="dark"] .ic-preview {
            background: var(--bg-tertiary);
            border-color: var(--border);
        }

        /* ===== Bounds section ===== */
        .ic-bounds {
            display: none;
            gap: 0.75rem;
            padding-top: 0.5rem;
        }
        .ic-bounds.visible {
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        /* ===== Quick examples ===== */
        .ic-examples {
            display: flex;
            flex-wrap: wrap;
            gap: 0.375rem;
        }
        .ic-example-chip {
            padding: 0.3rem 0.625rem;
            font-size: 0.75rem;
            font-family: var(--font-mono);
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: var(--radius-full, 9999px);
            cursor: pointer;
            transition: all 0.15s;
            color: var(--text-secondary);
            white-space: nowrap;
        }
        .ic-example-chip:hover {
            background: var(--tool-primary);
            color: #fff;
            border-color: var(--tool-primary);
        }
        [data-theme="dark"] .ic-example-chip {
            background: var(--bg-tertiary);
            border-color: var(--border);
            color: var(--text-secondary);
        }
        [data-theme="dark"] .ic-example-chip:hover {
            background: var(--tool-primary);
            color: #fff;
        }

        /* ===== Syntax help ===== */
        .ic-syntax-toggle {
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            padding: 0.5rem 0;
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-secondary);
            border: none;
            background: none;
            width: 100%;
            font-family: var(--font-sans);
        }
        .ic-syntax-content {
            display: none;
            font-size: 0.75rem;
            font-family: var(--font-mono);
            color: var(--text-secondary);
            line-height: 1.8;
            padding-bottom: 0.5rem;
        }
        .ic-syntax-content.open { display: block; }
        .ic-syntax-chevron {
            transition: transform 0.2s;
            width: 14px;
            height: 14px;
            flex-shrink: 0;
        }
        .ic-syntax-content.open ~ .ic-syntax-toggle .ic-syntax-chevron,
        .open > .ic-syntax-toggle .ic-syntax-chevron {
            transform: rotate(180deg);
        }

        /* ===== Output tabs ===== */
        .ic-output-tabs {
            display: flex;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: var(--radius-md, 0.5rem);
            overflow: hidden;
        }
        .ic-output-tab {
            flex: 1;
            padding: 0.5rem;
            font-weight: 600;
            font-size: 0.8125rem;
            border: none;
            cursor: pointer;
            background: var(--bg-secondary);
            color: var(--text-secondary);
            transition: all 0.15s;
            font-family: var(--font-sans);
            text-align: center;
        }
        .ic-output-tab.active {
            background: var(--tool-gradient);
            color: #fff;
        }
        .ic-output-tab:hover:not(.active) {
            background: var(--bg-tertiary);
        }
        [data-theme="dark"] .ic-output-tab { background: var(--bg-tertiary); }
        [data-theme="dark"] .ic-output-tab.active { background: var(--tool-gradient); color: #fff; }
        [data-theme="dark"] .ic-output-tab:hover:not(.active) { background: rgba(255,255,255,0.08); }

        .ic-panel { display: none; flex: 1; min-height: 0; }
        .ic-panel.active { display: flex; flex-direction: column; }
        #ic-panel-result .tool-result-card { flex: 1; }
        #ic-panel-graph { min-height: 480px; }
        #ic-panel-python { min-height: 540px; }

        /* ===== Result display ===== */
        .ic-result-math {
            padding: 1.5rem; overflow-x: auto; max-width: 100%;
            text-align: center;
        }
        .ic-result-math .katex-display { margin: 0.5rem 0; overflow-x: auto; overflow-y: hidden; }
        .ic-result-label {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 0.25rem;
        }
        .ic-result-main {
            font-size: 1.3rem;
            padding: 1rem 0;
        }
        .ic-result-numeric {
            background: var(--tool-gradient);
            color: #fff;
            padding: 1rem;
            border-radius: var(--radius-md);
            text-align: center;
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0.75rem 0;
        }
        .ic-result-detail {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 0.75rem 1rem;
            margin-top: 0.75rem;
            font-size: 0.8125rem;
            color: var(--text-secondary);
        }
        [data-theme="dark"] .ic-result-detail {
            background: var(--bg-tertiary);
            border-color: var(--border);
        }
        .ic-method-badge {
            display: inline-block;
            background: var(--tool-light);
            color: var(--tool-primary);
            padding: 0.2rem 0.625rem;
            border-radius: 9999px;
            font-size: 0.6875rem;
            font-weight: 600;
        }

        /* Error state */
        .ic-error {
            background: #fef3c7;
            border: 1px solid #fbbf24;
            border-radius: var(--radius-md);
            padding: 1.25rem;
            color: #92400e;
        }
        .ic-error h4 {
            margin: 0 0 0.5rem;
            font-size: 0.9375rem;
            font-weight: 700;
        }
        .ic-error ul {
            margin: 0.5rem 0 0;
            padding-left: 1.25rem;
            font-size: 0.8125rem;
            line-height: 1.7;
        }
        [data-theme="dark"] .ic-error {
            background: rgba(251, 191, 36, 0.15);
            border-color: rgba(251, 191, 36, 0.3);
            color: #fbbf24;
        }

        /* ===== Graph ===== */
        #ic-graph-container {
            width: 100%;
            min-height: 440px;
            border-radius: var(--radius-md);
        }
        .js-plotly-plot .plotly .modebar { top: 4px !important; right: 4px !important; }

        /* ===== Separator ===== */
        .ic-sep {
            border: none;
            border-top: 1px solid var(--border, #e2e8f0);
            margin: 0.75rem 0;
        }

        /* ===== Below-fold educational cards ===== */
        .ic-edu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        .ic-edu-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 1.25rem;
        }
        .ic-edu-card h4 {
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.375rem;
        }
        .ic-edu-card p {
            font-size: 0.8125rem;
            color: var(--text-secondary);
            line-height: 1.6;
            margin: 0;
        }
        [data-theme="dark"] .ic-edu-card {
            background: var(--bg-tertiary);
            border-color: var(--border);
        }
        .ic-rules-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.8125rem;
            margin-top: 0.75rem;
        }
        .ic-rules-table th, .ic-rules-table td {
            padding: 0.5rem 0.75rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        .ic-rules-table th {
            font-weight: 600;
            color: var(--text-primary);
            background: var(--bg-secondary);
        }
        .ic-rules-table td {
            color: var(--text-secondary);
            font-family: var(--font-mono);
            font-size: 0.75rem;
        }
        [data-theme="dark"] .ic-rules-table th {
            background: var(--bg-tertiary);
        }

        /* SVG diagram */
        .ic-diagram {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 1rem auto;
        }

        /* ===== Steps ===== */
        .ic-steps-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            padding: 0.5rem 1rem;
            font-size: 0.8125rem;
            font-weight: 600;
            font-family: var(--font-sans);
            border: 1.5px solid var(--tool-primary);
            border-radius: var(--radius-full);
            background: transparent;
            color: var(--tool-primary);
            cursor: pointer;
            transition: all 0.15s;
            margin-top: 0.75rem;
        }
        .ic-steps-btn:hover {
            background: var(--tool-primary);
            color: #fff;
        }
        .ic-steps-btn.loading {
            opacity: 0.7;
            pointer-events: none;
        }
        .ic-steps-container {
            margin-top: 1rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            overflow: hidden;
        }
        .ic-steps-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.625rem 1rem;
            background: var(--tool-light);
            border-bottom: 1px solid var(--border);
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--tool-primary);
        }
        .ic-step {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            gap: 0.75rem;
            align-items: flex-start;
        }
        .ic-step:last-child { border-bottom: none; }
        .ic-step-num {
            flex-shrink: 0;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--tool-gradient);
            color: #fff;
            font-size: 0.6875rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .ic-step-body { flex: 1; min-width: 0; }
        .ic-step-title {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 0.25rem;
        }
        .ic-step-math {
            font-size: 1rem;
            overflow-x: auto;
        }
        .ic-step-math .katex-display { margin: 0; overflow-x: auto; overflow-y: hidden; }
        [data-theme="dark"] .ic-steps-container { border-color: var(--border); }
        [data-theme="dark"] .ic-steps-header { background: var(--tool-light); border-bottom-color: var(--border); }
        [data-theme="dark"] .ic-step { border-bottom-color: var(--border); }
        .ic-steps-ai-badge {
            font-size: 0.625rem;
            font-weight: 500;
            padding: 0.125rem 0.5rem;
            border-radius: 9999px;
            background: var(--bg-secondary);
            color: var(--text-muted);
            margin-left: auto;
        }
        @keyframes ic-spin {
            to { transform: rotate(360deg); }
        }
        .ic-spinner {
            width: 14px;
            height: 14px;
            border: 2px solid var(--border);
            border-top-color: var(--tool-primary);
            border-radius: 50%;
            animation: ic-spin 0.6s linear infinite;
        }

        /* ===== FAQ ===== */
        .faq-item { border-bottom: 1px solid var(--border, #e2e8f0); }
        .faq-item:last-child { border-bottom: none; }
        .faq-question {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            padding: 0.875rem 0;
            background: none;
            border: none;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            cursor: pointer;
            text-align: left;
            font-family: var(--font-sans);
            gap: 0.75rem;
        }
        .faq-answer {
            display: none;
            padding: 0 0 0.875rem;
            font-size: 0.8125rem;
            line-height: 1.7;
            color: var(--text-secondary);
        }
        .faq-item.open .faq-answer { display: block; }
        .faq-chevron { transition: transform 0.2s; flex-shrink: 0; }
        .faq-item.open .faq-chevron { transform: rotate(180deg); }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Integral Calculator with Steps</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math-tools">Math Tools</a> /
                    Integral Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">Symbolic CAS</span>
                <span class="tool-badge">PDF Export</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Solve indefinite and definite integrals with <strong>detailed step-by-step solutions</strong>. Supports polynomials, trig, exponential, logarithmic, hyperbolic, and rational functions. Includes <strong>AI-powered explanations</strong>, interactive graph, <strong>PDF download</strong>, LaTeX export, and a built-in Python SymPy compiler. Free, instant, no signup.</p>
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
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z" stroke="none" fill="none"/>
                        <text x="5" y="18" font-size="16" font-weight="700" fill="currentColor" font-family="serif">&#8747;</text>
                    </svg>
                    Integral Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode toggle -->
                    <div class="ic-mode-toggle">
                        <button type="button" class="ic-mode-btn active" data-mode="indefinite">Indefinite</button>
                        <button type="button" class="ic-mode-btn" data-mode="definite">Definite</button>
                    </div>

                    <!-- Function input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ic-expr">Function f(x)</label>
                        <input type="text" class="tool-input tool-input-mono" id="ic-expr" placeholder="e.g. x^2 + 3*sin(x)" autocomplete="off" spellcheck="false">
                    </div>

                    <!-- Live preview -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Live Preview</label>
                        <div class="ic-preview" id="ic-preview">
                            <span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above&hellip;</span>
                        </div>
                    </div>

                    <!-- Variable -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ic-var">Variable</label>
                        <select class="tool-select" id="ic-var">
                            <option value="x" selected>x</option>
                            <option value="y">y</option>
                            <option value="t">t</option>
                            <option value="u">u</option>
                        </select>
                    </div>

                    <!-- Bounds (definite only) -->
                    <div class="ic-bounds" id="ic-bounds">
                        <div class="tool-form-group" style="margin-bottom:0;">
                            <label class="tool-form-label" for="ic-lower">Lower bound (a)</label>
                            <input type="text" class="tool-input tool-input-mono" id="ic-lower" value="0" placeholder="0">
                        </div>
                        <div class="tool-form-group" style="margin-bottom:0;">
                            <label class="tool-form-label" for="ic-upper">Upper bound (b)</label>
                            <input type="text" class="tool-input tool-input-mono" id="ic-upper" value="1" placeholder="1">
                        </div>
                    </div>

                    <!-- Integrate button -->
                    <button type="button" class="tool-action-btn" id="ic-integrate-btn">Integrate</button>

                    <hr class="ic-sep">

                    <!-- Quick examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="ic-examples" id="ic-examples">
                            <button type="button" class="ic-example-chip" data-expr="x^2+3*x">x&sup2;+3x</button>
                            <button type="button" class="ic-example-chip" data-expr="sin(x)*cos(x)">sin&middot;cos</button>
                            <button type="button" class="ic-example-chip" data-expr="e^x*x^2">e^x&middot;x&sup2;</button>
                            <button type="button" class="ic-example-chip" data-expr="1/(x^2+1)">1/(x&sup2;+1)</button>
                            <button type="button" class="ic-example-chip" data-expr="log(x)">ln(x)</button>
                            <button type="button" class="ic-example-chip" data-expr="sec(x)^2">sec&sup2;(x)</button>
                            <button type="button" class="ic-example-chip" data-expr="x*e^(-x)">x&middot;e^(-x)</button>
                            <button type="button" class="ic-example-chip" data-expr="1/sqrt(1-x^2)">1/&radic;(1-x&sup2;)</button>
                        </div>
                    </div>

                    <hr class="ic-sep">

                    <!-- Syntax help (collapsible) -->
                    <div id="ic-syntax-wrap">
                        <button type="button" class="ic-syntax-toggle" id="ic-syntax-btn">
                            Syntax Help
                            <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                        </button>
                        <div class="ic-syntax-content" id="ic-syntax-content">
                            x^2 &rarr; x&sup2; &nbsp;&nbsp; sin(x) &nbsp;&nbsp; cos(x) &nbsp;&nbsp; tan(x)<br>
                            e^x &nbsp;&nbsp; log(x) = ln(x) &nbsp;&nbsp; sqrt(x)<br>
                            sec(x) &nbsp;&nbsp; csc(x) &nbsp;&nbsp; cot(x)<br>
                            sinh(x) &nbsp;&nbsp; cosh(x) &nbsp;&nbsp; tanh(x)<br>
                            asin(x) &nbsp;&nbsp; acos(x) &nbsp;&nbsp; atan(x)<br>
                            pi &nbsp;&nbsp; e &nbsp;&nbsp; abs(x) &nbsp;&nbsp; 1/x
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Tab bar -->
            <div class="ic-output-tabs">
                <button type="button" class="ic-output-tab active" data-panel="result">Result</button>
                <button type="button" class="ic-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="ic-output-tab" data-panel="python">Python Compiler</button>
            </div>

            <!-- Result Panel -->
            <div class="ic-panel active" id="ic-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                        </svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="ic-result-content">
                        <div class="tool-empty-state" id="ic-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8747;</div>
                            <h3>Enter a function and click Integrate</h3>
                            <p>Supports polynomials, trig, exponential, logarithmic, and rational functions.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="ic-result-actions">
                        <button type="button" class="tool-action-btn" id="ic-copy-latex-btn">
                            <span>&#128203;</span> Copy LaTeX
                        </button>
                        <button type="button" class="tool-action-btn" id="ic-copy-text-btn">
                            <span>&#128196;</span> Copy Text
                        </button>
                        <button type="button" class="tool-action-btn" id="ic-share-btn">
                            <span>&#128279;</span> Share
                        </button>
                        <button type="button" class="tool-action-btn" id="ic-download-pdf-btn">
                            <span>&#128196;</span> Download PDF
                        </button>
                    </div>
                </div>
            </div>

            <!-- Graph Panel -->
            <div class="ic-panel" id="ic-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                        </svg>
                        <h4>Interactive Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="ic-graph-container"></div>
                        <p id="ic-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Integrate a function to see its graph.</p>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="ic-panel" id="ic-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <h4>Python Compiler</h4>
                        <select id="ic-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="sympy-indef">SymPy Indefinite</option>
                            <option value="sympy-def">SymPy Definite</option>
                            <option value="scipy-numerical">SciPy Numerical</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="ic-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
        <jsp:param name="currentToolUrl" value="integral-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

        <!-- What is an Integral? -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is an Integral?</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">An <strong>integral</strong> is the reverse operation of differentiation. The <strong>indefinite integral</strong> (antiderivative) of a function f(x) is a family of functions F(x) + C whose derivative equals f(x). The <strong>definite integral</strong> computes the net signed area under the curve of f(x) between two bounds [a, b].</p>
            <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">In physics, integrals represent accumulation: distance is the integral of velocity, work is the integral of force, and charge is the integral of current. In probability, integrals compute areas under density curves.</p>

            <!-- Area under curve SVG diagram -->
            <svg class="ic-diagram" viewBox="0 0 500 220" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
                <defs>
                    <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#4f46e5" stop-opacity="0.3"/>
                        <stop offset="100%" stop-color="#4f46e5" stop-opacity="0.05"/>
                    </linearGradient>
                </defs>
                <!-- Axes -->
                <line x1="50" y1="180" x2="470" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
                <line x1="50" y1="20" x2="50" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
                <!-- Shaded area -->
                <path d="M120,180 L120,100 C160,60 200,40 240,55 C280,70 320,50 360,80 L360,180 Z" fill="url(#areaGrad)" stroke="none"/>
                <!-- Curve -->
                <path d="M60,140 C80,120 100,105 120,100 C160,60 200,40 240,55 C280,70 320,50 360,80 C400,100 440,130 460,150" fill="none" stroke="#4f46e5" stroke-width="2.5" stroke-linecap="round"/>
                <!-- Bounds -->
                <line x1="120" y1="100" x2="120" y2="180" stroke="#4338ca" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="360" y1="80" x2="360" y2="180" stroke="#4338ca" stroke-width="1" stroke-dasharray="4,3"/>
                <!-- Labels -->
                <text x="116" y="198" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">a</text>
                <text x="356" y="198" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">b</text>
                <text x="240" y="140" font-size="12" fill="#4f46e5" font-weight="600" text-anchor="middle">Area = &#8747; f(x) dx</text>
                <text x="460" y="160" font-size="12" fill="#94a3b8" font-style="italic">f(x)</text>
                <text x="480" y="185" font-size="12" fill="#94a3b8">x</text>
                <text x="40" y="25" font-size="12" fill="#94a3b8">y</text>
            </svg>
        </div>

        <!-- Common Integration Rules -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Common Integration Rules</h2>
            <table class="ic-rules-table">
                <thead>
                    <tr><th style="width:40%;">Rule</th><th style="width:35%;">Formula</th><th>Example</th></tr>
                </thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Power Rule</td><td>&#8747;x^n dx = x^(n+1)/(n+1)+C</td><td>&#8747;x&sup3; dx = x&sup4;/4+C</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Constant</td><td>&#8747;k dx = kx + C</td><td>&#8747;5 dx = 5x + C</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Sine</td><td>&#8747;sin(x) dx = -cos(x)+C</td><td></td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Cosine</td><td>&#8747;cos(x) dx = sin(x)+C</td><td></td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Exponential</td><td>&#8747;e^x dx = e^x + C</td><td></td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Reciprocal</td><td>&#8747;1/x dx = ln|x| + C</td><td></td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Sec&sup2;</td><td>&#8747;sec&sup2;(x) dx = tan(x)+C</td><td></td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Inverse trig</td><td>&#8747;1/(1+x&sup2;) dx = arctan(x)+C</td><td></td></tr>
                </tbody>
            </table>
        </div>

        <!-- Integration Techniques -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Integration Techniques</h2>
            <div class="ic-edu-grid">
                <div class="ic-edu-card" style="border-left: 3px solid #4f46e5;">
                    <h4>U-Substitution</h4>
                    <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">&#8747;f(g(x))&middot;g'(x) dx = &#8747;f(u) du</p>
                    <p>Example: &#8747;2x&middot;cos(x&sup2;) dx &rarr; let u = x&sup2;</p>
                </div>
                <div class="ic-edu-card" style="border-left: 3px solid #6366f1;">
                    <h4>Integration by Parts</h4>
                    <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">&#8747;u dv = uv - &#8747;v du</p>
                    <p>Example: &#8747;x&middot;e^x dx &rarr; u=x, dv=e^x dx</p>
                </div>
                <div class="ic-edu-card" style="border-left: 3px solid #818cf8;">
                    <h4>Partial Fractions</h4>
                    <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">Decompose P(x)/Q(x) into simpler fractions</p>
                    <p>Example: &#8747;1/(x&sup2;-1) dx &rarr; split into A/(x-1) + B/(x+1)</p>
                </div>
                <div class="ic-edu-card" style="border-left: 3px solid #a5b4fc;">
                    <h4>Trig Substitution</h4>
                    <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">Substitute x = a&middot;sin(&theta;), etc.</p>
                    <p>Example: &#8747;1/&radic;(1-x&sup2;) dx &rarr; x=sin(&theta;)</p>
                </div>
            </div>
        </div>

        <!-- Fundamental Theorem of Calculus -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Fundamental Theorem of Calculus</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Fundamental Theorem connects differentiation and integration as inverse operations.</p>
            <div style="background: var(--tool-light); border-left: 3px solid var(--tool-primary); padding: 1rem; border-radius: 0 var(--radius-md) var(--radius-md) 0; margin-bottom: 0.75rem;">
                <p style="color: var(--text-primary); font-weight: 600; margin-bottom: 0.5rem; font-size: 0.875rem;">Part 1: If F(x) = &#8747;<sub>a</sub><sup>x</sup> f(t) dt, then F'(x) = f(x)</p>
                <p style="color: var(--text-primary); font-weight: 600; margin: 0; font-size: 0.875rem;">Part 2: &#8747;<sub>a</sub><sup>b</sup> f(x) dx = F(b) - F(a), where F'(x) = f(x)</p>
            </div>

            <!-- FTC SVG diagram -->
            <svg class="ic-diagram" viewBox="0 0 500 180" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
                <defs>
                    <linearGradient id="ftcGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#6366f1" stop-opacity="0.25"/>
                        <stop offset="100%" stop-color="#6366f1" stop-opacity="0.05"/>
                    </linearGradient>
                </defs>
                <line x1="40" y1="140" x2="460" y2="140" stroke="#94a3b8" stroke-width="1.5"/>
                <line x1="40" y1="10" x2="40" y2="140" stroke="#94a3b8" stroke-width="1.5"/>
                <path d="M100,140 L100,70 Q180,30 260,50 Q340,70 380,60 L380,140 Z" fill="url(#ftcGrad)"/>
                <path d="M50,110 Q100,70 180,40 Q260,50 340,60 Q380,55 440,80" fill="none" stroke="#4f46e5" stroke-width="2.5"/>
                <line x1="100" y1="70" x2="100" y2="140" stroke="#4338ca" stroke-width="1.5" stroke-dasharray="4,3"/>
                <line x1="380" y1="60" x2="380" y2="140" stroke="#4338ca" stroke-width="1.5" stroke-dasharray="4,3"/>
                <text x="100" y="158" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">a</text>
                <text x="380" y="158" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">b</text>
                <!-- F(b) and F(a) labels -->
                <circle cx="100" cy="70" r="4" fill="#4f46e5"/>
                <circle cx="380" cy="60" r="4" fill="#4f46e5"/>
                <text x="75" y="63" font-size="11" fill="#4f46e5" font-weight="600">F(a)</text>
                <text x="388" y="53" font-size="11" fill="#4f46e5" font-weight="600">F(b)</text>
                <text x="240" y="115" font-size="12" fill="#4f46e5" font-weight="600" text-anchor="middle">F(b) - F(a)</text>
            </svg>
            <p style="color: var(--text-secondary); margin: 0; line-height: 1.7; font-size: 0.875rem;">This theorem provides a systematic way to evaluate definite integrals: find any antiderivative F(x) of f(x), then compute F(b) - F(a).</p>
        </div>

        <!-- Applications -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications of Integrals</h2>
            <div class="ic-edu-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
                <div class="ic-edu-card" style="text-align:center;">
                    <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128207;</div>
                    <h4>Area Between Curves</h4>
                    <p>Find the area enclosed between two functions over an interval.</p>
                </div>
                <div class="ic-edu-card" style="text-align:center;">
                    <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127758;</div>
                    <h4>Volume of Revolution</h4>
                    <p>Calculate volumes by rotating curves around axes (disk/shell methods).</p>
                </div>
                <div class="ic-edu-card" style="text-align:center;">
                    <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div>
                    <h4>Work &amp; Energy</h4>
                    <p>Work = &#8747;F&middot;dx. Compute energy in physics problems.</p>
                </div>
                <div class="ic-edu-card" style="text-align:center;">
                    <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div>
                    <h4>Probability</h4>
                    <p>P(a &le; X &le; b) = &#8747; f(x) dx for continuous distributions.</p>
                </div>
            </div>
        </div>

        <!-- FAQ Section -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What types of integrals can this calculator solve?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">This calculator solves indefinite integrals (antiderivatives) and definite integrals for polynomials, trigonometric functions (sin, cos, tan, sec, csc, cot), exponential functions (e^x), logarithmic functions (ln x), rational functions, hyperbolic functions (sinh, cosh, tanh), inverse trig (arctan, arcsin), and products solved by integration by parts. It handles power rule, u-substitution, partial fractions, and more.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Does this integral calculator show step-by-step solutions?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes. After computing a result, click the Show Steps button to see a detailed step-by-step solution. For common integrals (power rule, basic trig, exponential), steps are generated instantly. For complex integrals like integration by parts or partial fractions, AI-powered steps explain each algebraic manipulation, substitution, and simplification in 5-8 clear steps with full LaTeX math rendering.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Can I download or share my integral solution?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes. After computing a result you can: (1) Download as PDF with the question, answer, method, and step-by-step solution beautifully formatted, (2) Copy the result as LaTeX for use in papers and documents, (3) Copy as plain text, or (4) Generate a shareable URL that loads your exact integral with one click. The PDF includes the 8gwifi.org watermark and current date.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the difference between indefinite and definite integrals?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">An indefinite integral finds the antiderivative F(x) + C, a family of functions whose derivative equals f(x). A definite integral evaluates the net signed area under the curve between bounds [a, b] using the Fundamental Theorem of Calculus: F(b) - F(a). This calculator supports both modes with a simple toggle, and the interactive graph shows the shaded area for definite integrals.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I enter my function into the calculator?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Use standard math notation: x^2 for x squared, sin(x) for sine, e^x for exponential, ln(x) for natural log, sqrt(x) for square root, 1/x for reciprocal, sec(x)^2 for secant squared. Multiplication can be explicit (2*x) or implicit. A live KaTeX preview shows your expression in rendered math notation as you type, so you can verify the input before integrating.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is this integral calculator free? Do I need to sign up?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">This integral calculator is completely free with no signup, no account, and no limits. You get symbolic integration, step-by-step solutions, interactive graphs, PDF download, LaTeX export, and a built-in Python compiler with SymPy and SciPy templates. All computation runs in your browser for instant results.</div>
            </div>
        </div>
    </section>

    <!-- Explore More Math: Quick Math, Visual Math, Math Memory -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 1.5rem 2rem;">
            <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
                <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
            </h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
                <a href="<%=request.getContextPath()%>/exams/quick-math/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#9889;</div>
                    <div>
                        <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Quick Math</h4>
                        <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">150+ mental math tricks and Vedic math shortcuts for speed calculation</p>
                    </div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #8b5cf6, #7c3aed); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#128202;</div>
                    <div>
                        <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Visual Math Lab</h4>
                        <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">35 interactive visualizations for algebra, calculus, trigonometry and statistics</p>
                    </div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/math-memory/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #10b981, #059669); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#129504;</div>
                    <div>
                        <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Math Memory Games</h4>
                        <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">16 free brain training games to improve memory and mental calculation</p>
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

    <!-- Nerdamer -->
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>

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

    <script>
    (function() {
    'use strict';

    // ========== DOM References ==========
    var exprInput    = document.getElementById('ic-expr');
    var previewEl    = document.getElementById('ic-preview');
    var varSelect    = document.getElementById('ic-var');
    var boundsWrap   = document.getElementById('ic-bounds');
    var lowerInput   = document.getElementById('ic-lower');
    var upperInput   = document.getElementById('ic-upper');
    var integrateBtn = document.getElementById('ic-integrate-btn');
    var resultContent = document.getElementById('ic-result-content');
    var resultActions = document.getElementById('ic-result-actions');
    var emptyState   = document.getElementById('ic-empty-state');
    var graphHint    = document.getElementById('ic-graph-hint');

    var currentMode = 'indefinite';
    var lastResultLatex = '';
    var lastResultText = '';
    var compilerLoaded = false;
    var pendingGraph = null;

    // ========== FAQ ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Mode Toggle ==========
    var modeBtns = document.querySelectorAll('.ic-mode-btn');
    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            if (mode === 'definite') {
                boundsWrap.classList.add('visible');
            } else {
                boundsWrap.classList.remove('visible');
            }
            updatePreview();
        });
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.ic-output-tab');
    var panels  = document.querySelectorAll('.ic-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('ic-panel-' + panel).classList.add('active');

            if (panel === 'graph' && pendingGraph) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Syntax Help Toggle ==========
    var syntaxBtn = document.getElementById('ic-syntax-btn');
    var syntaxContent = document.getElementById('ic-syntax-content');
    syntaxBtn.addEventListener('click', function() {
        syntaxContent.classList.toggle('open');
        var chevron = syntaxBtn.querySelector('.ic-syntax-chevron');
        if (syntaxContent.classList.contains('open')) {
            chevron.style.transform = 'rotate(180deg)';
        } else {
            chevron.style.transform = '';
        }
    });

    // ========== Quick Examples ==========
    document.getElementById('ic-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.ic-example-chip');
        if (!chip) return;
        exprInput.value = chip.getAttribute('data-expr');
        updatePreview();
        exprInput.focus();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    exprInput.addEventListener('input', function() {
        clearTimeout(previewTimer);
        previewTimer = setTimeout(updatePreview, 200);
    });
    varSelect.addEventListener('change', updatePreview);

    function updatePreview() {
        var expr = exprInput.value.trim();
        var v = varSelect.value;
        if (!expr) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above\u2026</span>';
            return;
        }
        try {
            var latex = exprToLatex(expr);
            var integralLatex;
            if (currentMode === 'definite') {
                var a = lowerInput.value.trim() || 'a';
                var b = upperInput.value.trim() || 'b';
                integralLatex = '\\int_{' + a + '}^{' + b + '} ' + latex + ' \\, d' + v;
            } else {
                integralLatex = '\\int ' + latex + ' \\, d' + v;
            }
            katex.render(integralLatex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    lowerInput.addEventListener('input', function() { clearTimeout(previewTimer); previewTimer = setTimeout(updatePreview, 200); });
    upperInput.addEventListener('input', function() { clearTimeout(previewTimer); previewTimer = setTimeout(updatePreview, 200); });

    function exprToLatex(expr) {
        try {
            var parsed = nerdamer(expr);
            return parsed.toTeX();
        } catch (e) {
            // Fallback: basic manual conversion
            return expr
                .replace(/\*/g, ' \\cdot ')
                .replace(/sqrt\(/g, '\\sqrt{').replace(/\)/g, '}')
                .replace(/\^(\w)/g, '^{$1}');
        }
    }

    // ========== Integration ==========
    integrateBtn.addEventListener('click', doIntegrate);
    exprInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') doIntegrate();
    });

    function doIntegrate() {
        var expr = exprInput.value.trim();
        var v = varSelect.value;
        if (!expr) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a function.', 2000, 'warning');
            return;
        }

        try {
            // Compute indefinite integral
            var result = nerdamer('integrate(' + expr + ', ' + v + ')');
            var failed = false;
            try { failed = result.hasIntegral(); } catch (e) { /* hasIntegral may not exist in some builds */ }

            if (failed) {
                showError(expr);
                return;
            }

            var resultTeX = result.toTeX();
            var resultText = result.text();
            var method = identifyMethod(expr);

            if (currentMode === 'indefinite') {
                showIndefiniteResult(expr, v, resultTeX, resultText, method);
                prepareGraph(expr, v, result.text(), 'indefinite', null, null);
            } else {
                var a = lowerInput.value.trim() || '0';
                var b = upperInput.value.trim() || '1';
                // Compute definite integral
                var defResult;
                var numericVal;
                try {
                    defResult = nerdamer('defint(' + expr + ', ' + a + ', ' + b + ', ' + v + ')');
                    numericVal = parseFloat(defResult.text('decimals'));
                } catch (e2) {
                    // Fallback: evaluate antiderivative at bounds
                    try {
                        var Fb = nerdamer(result.text()).evaluate({ x: b });
                        var Fa = nerdamer(result.text()).evaluate({ x: a });
                        numericVal = parseFloat(Fb.text('decimals')) - parseFloat(Fa.text('decimals'));
                        defResult = nerdamer(Fb.text() + '-(' + Fa.text() + ')');
                    } catch (e3) {
                        numericVal = NaN;
                    }
                }
                var exactText = defResult ? defResult.text() : '';
                showDefiniteResult(expr, v, a, b, resultTeX, resultText, exactText, numericVal, method);
                prepareGraph(expr, v, result.text(), 'definite', a, b);
            }

            resultActions.classList.add('visible');
            if (emptyState) emptyState.style.display = 'none';

        } catch (err) {
            showError(expr, err.message);
        }
    }

    // ========== Method Identification ==========
    function identifyMethod(expr) {
        if (/\*/.test(expr) && /(sin|cos|e\^|exp)/.test(expr)) return 'Integration by Parts';
        if (/\/.*\(/.test(expr) || /\/\(/.test(expr)) return 'Partial Fractions / Substitution';
        if (/sin|cos|tan|sec|csc|cot/.test(expr)) return 'Trigonometric Integration';
        if (/e\^|exp\(/.test(expr)) return 'Exponential Integration';
        if (/log\(|ln\(/.test(expr)) return 'Logarithmic Integration';
        if (/^\s*[\d.]*\*?[a-z]\^[\d]+/.test(expr) || /^\s*[a-z]\^/.test(expr)) return 'Power Rule';
        return 'Symbolic Integration';
    }

    // ========== Result Display: Indefinite ==========
    function showIndefiniteResult(expr, v, resultTeX, resultText, method) {
        var exprTeX = exprToLatex(expr);
        lastResultLatex = resultTeX + ' + C';
        lastResultText = resultText + ' + C';

        lastIntegrationContext = { expr: expr, v: v, resultTeX: resultTeX, resultText: resultText, method: method, mode: 'indefinite', a: null, b: null };

        var html = '<div class="ic-result-math">';
        html += '<div class="ic-result-label">Integral</div>';
        html += '<div id="ic-r-integral"></div>';
        html += '<div class="ic-result-label" style="margin-top:1rem;">Result</div>';
        html += '<div class="ic-result-main" id="ic-r-result"></div>';
        html += '<div class="ic-result-detail">';
        html += '<span class="ic-method-badge">' + escapeHtml(method) + '</span>';
        html += '</div>';
        html += '<button type="button" class="ic-steps-btn" id="ic-steps-btn" onclick="showSteps()">&#128221; Show Steps</button>';
        html += '<div id="ic-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render('\\int ' + exprTeX + ' \\, d' + v + ' =', document.getElementById('ic-r-integral'), { displayMode: true, throwOnError: false });
        katex.render(resultTeX + ' + C', document.getElementById('ic-r-result'), { displayMode: true, throwOnError: false });
    }

    // ========== Result Display: Definite ==========
    function showDefiniteResult(expr, v, a, b, resultTeX, resultText, exactText, numericVal, method) {
        var exprTeX = exprToLatex(expr);
        var numStr = isFinite(numericVal) ? numericVal.toFixed(6) : 'N/A';
        lastResultLatex = '\\int_{' + a + '}^{' + b + '} ' + exprTeX + ' \\, d' + v + ' = ' + (exactText || numStr);
        lastResultText = 'integral from ' + a + ' to ' + b + ' of ' + expr + ' d' + v + ' = ' + (exactText || numStr);

        lastIntegrationContext = { expr: expr, v: v, resultTeX: resultTeX, resultText: resultText + (exactText ? ' = ' + exactText : ''), method: method, mode: 'definite', a: a, b: b };

        var html = '<div class="ic-result-math">';
        html += '<div class="ic-result-label">Definite Integral</div>';
        html += '<div id="ic-r-integral"></div>';

        if (isFinite(numericVal)) {
            html += '<div class="ic-result-numeric">&asymp; ' + escapeHtml(numStr) + (exactText && exactText !== numStr ? '&nbsp;&nbsp;(exact: ' + escapeHtml(exactText) + ')' : '') + '</div>';
        }

        html += '<div class="ic-result-label" style="margin-top:0.75rem;">Antiderivative</div>';
        html += '<div id="ic-r-antideriv"></div>';

        if (isFinite(numericVal)) {
            html += '<div class="ic-result-detail">';
            html += 'F(' + escapeHtml(b) + ') - F(' + escapeHtml(a) + ') = ' + escapeHtml(numStr);
            html += '<br><span class="ic-method-badge" style="margin-top:0.375rem;">' + escapeHtml(method) + '</span>';
            html += '</div>';
        }

        html += '<button type="button" class="ic-steps-btn" id="ic-steps-btn" onclick="showSteps()">&#128221; Show Steps</button>';
        html += '<div id="ic-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        katex.render('\\int_{' + a + '}^{' + b + '} ' + exprTeX + ' \\, d' + v + ' =', document.getElementById('ic-r-integral'), { displayMode: true, throwOnError: false });
        katex.render(resultTeX + ' + C', document.getElementById('ic-r-antideriv'), { displayMode: true, throwOnError: false });
    }

    // ========== Error State ==========
    function showError(expr, msg) {
        resultActions.classList.remove('visible');
        var html = '<div class="ic-error">';
        html += '<h4>Could Not Integrate</h4>';
        html += '<p>The expression <strong>' + escapeHtml(expr) + '</strong> could not be symbolically integrated.' + (msg ? ' (' + escapeHtml(msg) + ')' : '') + '</p>';
        html += '<ul>';
        html += '<li>Simplify the expression</li>';
        html += '<li>Check syntax (see Syntax Help)</li>';
        html += '<li>Use numerical approximation (switch to Definite with bounds)</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Step-by-Step Solutions ==========
    var lastIntegrationContext = null; // stores {expr, v, resultText, method, mode, a, b}

    function generateTemplateSteps(expr, v, resultTeX, method) {
        var steps = [];
        var e = expr.trim();

        // Power rule: x^n or c*x^n
        if (/^(\d+\*?)?[a-z]\^(\d+)$/.test(e)) {
            var m = e.match(/^(\d+\*?)?([a-z])\^(\d+)$/);
            var coeff = m[1] ? parseInt(m[1]) : 1;
            var n = parseInt(m[3]);
            var np1 = n + 1;
            steps.push({ title: 'Apply Power Rule', latex: '\\int ' + (coeff > 1 ? coeff : '') + v + '^{' + n + '} \\, d' + v + ' = ' + (coeff > 1 ? coeff + ' \\cdot ' : '') + '\\frac{' + v + '^{' + np1 + '}}{' + np1 + '}' });
            if (coeff > 1) {
                steps.push({ title: 'Simplify coefficient', latex: '= \\frac{' + coeff + '}{' + np1 + '}' + v + '^{' + np1 + '} + C' });
            } else {
                steps.push({ title: 'Add constant of integration', latex: '= \\frac{' + v + '^{' + np1 + '}}{' + np1 + '} + C' });
            }
            return steps;
        }

        // Simple sin(x), cos(x), e^x, 1/x, sec^2(x)
        var basicIntegrals = {
            'sin(x)':    [{ title: 'Standard trig integral', latex: '\\int \\sin(' + v + ') \\, d' + v + ' = -\\cos(' + v + ') + C' }],
            'cos(x)':    [{ title: 'Standard trig integral', latex: '\\int \\cos(' + v + ') \\, d' + v + ' = \\sin(' + v + ') + C' }],
            'e^x':       [{ title: 'Exponential rule', latex: '\\int e^{' + v + '} \\, d' + v + ' = e^{' + v + '} + C' }],
            '1/x':       [{ title: 'Reciprocal rule', latex: '\\int \\frac{1}{' + v + '} \\, d' + v + ' = \\ln|' + v + '| + C' }],
            'sec(x)^2':  [{ title: 'Standard trig integral', latex: '\\int \\sec^2(' + v + ') \\, d' + v + ' = \\tan(' + v + ') + C' }],
            'tan(x)':    [{ title: 'Standard trig integral', latex: '\\int \\tan(' + v + ') \\, d' + v + ' = -\\ln|\\cos(' + v + ')| + C' }],
            'log(x)':    [{ title: 'Integration by parts (u = ln x, dv = dx)', latex: '\\int \\ln(' + v + ') \\, d' + v + ' = ' + v + '\\ln(' + v + ') - ' + v + ' + C' }]
        };
        // Normalize variable: replace actual var with x for lookup
        var normalized = e.replace(new RegExp(v, 'g'), 'x');
        if (basicIntegrals[normalized]) {
            return basicIntegrals[normalized];
        }

        // Sum of terms: split by + or - at top level
        // e.g. x^2+3*x, sin(x)+cos(x)
        var terms = splitTerms(e);
        if (terms && terms.length > 1) {
            steps.push({ title: 'Split into sum of integrals', latex: '\\int \\left(' + exprToLatex(e) + '\\right) d' + v + ' = ' + terms.map(function(t) { return '\\int ' + exprToLatex(t.trim()) + ' \\, d' + v; }).join(' + ') });
            // Try to get each term's integral
            var allResolved = true;
            var partResults = [];
            for (var i = 0; i < terms.length; i++) {
                try {
                    var r = nerdamer('integrate(' + terms[i] + ', ' + v + ')');
                    if (r.hasIntegral && r.hasIntegral()) { allResolved = false; break; }
                    partResults.push(r.toTeX());
                } catch (ex) { allResolved = false; break; }
            }
            if (allResolved && partResults.length === terms.length) {
                for (var j = 0; j < terms.length; j++) {
                    steps.push({ title: 'Integrate term ' + (j + 1), latex: '\\int ' + exprToLatex(terms[j].trim()) + ' \\, d' + v + ' = ' + partResults[j] });
                }
                steps.push({ title: 'Combine and add constant', latex: '= ' + resultTeX + ' + C' });
                return steps;
            }
        }

        // Constant multiple: c*f(x)
        var constMatch = e.match(/^(\d+)\*(.+)$/);
        if (constMatch) {
            var c = constMatch[1];
            var inner = constMatch[2];
            steps.push({ title: 'Factor out constant', latex: '\\int ' + c + ' \\cdot ' + exprToLatex(inner) + ' \\, d' + v + ' = ' + c + '\\int ' + exprToLatex(inner) + ' \\, d' + v });
            try {
                var innerResult = nerdamer('integrate(' + inner + ', ' + v + ')');
                if (!innerResult.hasIntegral || !innerResult.hasIntegral()) {
                    steps.push({ title: 'Integrate inner function', latex: '= ' + c + ' \\left(' + innerResult.toTeX() + '\\right) + C' });
                    steps.push({ title: 'Simplify', latex: '= ' + resultTeX + ' + C' });
                    return steps;
                }
            } catch (ex) { /* fall through to AI */ }
        }

        // 1/(x^2+1) -> arctan
        if (normalized === '1/(x^2+1)') {
            steps.push({ title: 'Recognize standard form', latex: '\\int \\frac{1}{' + v + '^2 + 1} \\, d' + v + ' \\text{ matches } \\int \\frac{1}{u^2+1} du = \\arctan(u)' });
            steps.push({ title: 'Apply formula', latex: '= \\arctan(' + v + ') + C' });
            return steps;
        }

        // 1/sqrt(1-x^2) -> arcsin
        if (normalized === '1/sqrt(1-x^2)') {
            steps.push({ title: 'Recognize standard form', latex: '\\int \\frac{1}{\\sqrt{1-' + v + '^2}} \\, d' + v + ' \\text{ matches } \\int \\frac{1}{\\sqrt{1-u^2}} du = \\arcsin(u)' });
            steps.push({ title: 'Apply formula', latex: '= \\arcsin(' + v + ') + C' });
            return steps;
        }

        return null; // No template available — needs AI
    }

    function splitTerms(expr) {
        // Split by + or - at top level (not inside parentheses)
        var terms = [];
        var depth = 0;
        var current = '';
        for (var i = 0; i < expr.length; i++) {
            var ch = expr[i];
            if (ch === '(' || ch === '[') depth++;
            else if (ch === ')' || ch === ']') depth--;
            if (depth === 0 && (ch === '+' || (ch === '-' && i > 0 && current.trim()))) {
                terms.push(current.trim());
                current = ch === '-' ? '-' : '';
            } else {
                current += ch;
            }
        }
        if (current.trim()) terms.push(current.trim());
        return terms.length > 1 ? terms : null;
    }

    window.showSteps = function() {
        if (!lastIntegrationContext) return;
        var ctx = lastIntegrationContext;
        var stepsBtn = document.getElementById('ic-steps-btn');

        // Try template steps first
        var templateSteps = generateTemplateSteps(ctx.expr, ctx.v, ctx.resultTeX, ctx.method);

        if (templateSteps && templateSteps.length > 0) {
            renderSteps(templateSteps, ctx.method, false);
            if (stepsBtn) stepsBtn.style.display = 'none';
            return;
        }

        // AI fallback
        if (stepsBtn) {
            stepsBtn.classList.add('loading');
            stepsBtn.innerHTML = '<span class="ic-spinner"></span> Generating steps\u2026';
        }

        var payload = {
            operation: 'integrate',
            expression: ctx.expr,
            variable: ctx.v,
            answer: ctx.resultText
        };
        if (ctx.mode === 'definite' && ctx.a && ctx.b) {
            payload.bounds = { lower: ctx.a, upper: ctx.b };
        }

        fetch('<%=request.getContextPath()%>/CFExamMarkerFunctionality?action=math_steps', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success && data.steps && data.steps.length > 0) {
                renderSteps(data.steps, data.method || ctx.method, true);
            } else {
                renderStepsError(data.error || 'Could not generate steps');
            }
            if (stepsBtn) stepsBtn.style.display = 'none';
        })
        .catch(function(err) {
            renderStepsError('Network error. Please try again.');
            if (stepsBtn) {
                stepsBtn.classList.remove('loading');
                stepsBtn.innerHTML = '\u{1F4DD} Show Steps';
            }
        });
    };

    /** Wrap plain text in \\text{} so KaTeX preserves spaces. In math mode, spaces are collapsed. */
    function prepareLatexForKatex(latex) {
        if (!latex || typeof latex !== 'string') return latex;
        var firstBackslash = latex.indexOf('\\');
        if (firstBackslash === -1) {
            return '\\text{' + latex.replace(/\\/g, '\\\\').replace(/}/g, '\\}') + '}';
        }
        if (firstBackslash === 0) return latex;
        var leading = latex.substring(0, firstBackslash).replace(/\\/g, '\\\\').replace(/}/g, '\\}');
        return '\\text{' + leading + '}' + latex.substring(firstBackslash);
    }

    function renderSteps(steps, method, isAI) {
        var container = document.getElementById('ic-steps-area');
        if (!container) return;

        var html = '<div class="ic-steps-container">';
        html += '<div class="ic-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps';
        if (isAI) {
            html += '<span class="ic-steps-ai-badge">AI Generated</span>';
        }
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="ic-step">';
            html += '<span class="ic-step-num">' + (i + 1) + '</span>';
            html += '<div class="ic-step-body">';
            html += '<div class="ic-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="ic-step-math" id="ic-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        // Render KaTeX for each step (plain text wrapped in \text{} to preserve spacing)
        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('ic-step-math-' + j);
            if (el && steps[j].latex) {
                try {
                    var prepared = prepareLatexForKatex(steps[j].latex);
                    katex.render(prepared, el, { displayMode: true, throwOnError: false });
                } catch (e) {
                    el.textContent = steps[j].latex;
                }
            }
        }
    }

    function renderStepsError(msg) {
        var container = document.getElementById('ic-steps-area');
        if (!container) return;
        container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">' + escapeHtml(msg) + '</div>';
    }

    // ========== Graph ==========
    function prepareGraph(exprStr, v, antiderivStr, mode, a, b) {
        pendingGraph = { expr: exprStr, v: v, antideriv: antiderivStr, mode: mode, a: a, b: b };
        if (graphHint) graphHint.style.display = 'none';

        // If graph tab is already active, render immediately
        var graphPanel = document.getElementById('ic-panel-graph');
        if (graphPanel.classList.contains('active')) {
            loadPlotly(function() { renderGraph(pendingGraph); });
        }
    }

    function renderGraph(cfg) {
        if (!window.Plotly) return;
        var container = document.getElementById('ic-graph-container');

        var xMin, xMax;
        if (cfg.mode === 'definite' && cfg.a !== null && cfg.b !== null) {
            var aNum = evalBound(cfg.a);
            var bNum = evalBound(cfg.b);
            var range = Math.abs(bNum - aNum) || 2;
            xMin = aNum - range * 0.5;
            xMax = bNum + range * 0.5;
        } else {
            xMin = -10;
            xMax = 10;
        }

        var n = 500;
        var xs = [], ysFx = [], ysFxAntideriv = [];
        var step = (xMax - xMin) / n;

        for (var i = 0; i <= n; i++) {
            var xVal = xMin + i * step;
            xs.push(xVal);
            ysFx.push(evalAtPoint(cfg.expr, cfg.v, xVal));
            if (cfg.antideriv) {
                ysFxAntideriv.push(evalAtPoint(cfg.antideriv, cfg.v, xVal));
            }
        }

        var traces = [];

        // f(x) trace
        traces.push({
            x: xs, y: ysFx,
            type: 'scatter', mode: 'lines',
            name: 'f(' + cfg.v + ') = ' + cfg.expr,
            line: { color: '#4f46e5', width: 2.5 }
        });

        if (cfg.mode === 'indefinite' && cfg.antideriv) {
            // F(x) trace
            traces.push({
                x: xs, y: ysFxAntideriv,
                type: 'scatter', mode: 'lines',
                name: 'F(' + cfg.v + ') (antiderivative)',
                line: { color: '#10b981', width: 2, dash: 'dash' }
            });
        }

        if (cfg.mode === 'definite' && cfg.a !== null && cfg.b !== null) {
            // Shaded area
            var aNum = evalBound(cfg.a);
            var bNum = evalBound(cfg.b);
            var fillXs = [], fillYs = [];
            var fillN = 200;
            var fillStep = (bNum - aNum) / fillN;
            for (var j = 0; j <= fillN; j++) {
                var fx = aNum + j * fillStep;
                fillXs.push(fx);
                fillYs.push(evalAtPoint(cfg.expr, cfg.v, fx));
            }
            // Close the area to x-axis
            fillXs.push(bNum); fillYs.push(0);
            fillXs.push(aNum); fillYs.push(0);

            traces.push({
                x: fillXs, y: fillYs,
                type: 'scatter', mode: 'lines',
                fill: 'toself',
                fillcolor: 'rgba(79, 70, 229, 0.15)',
                line: { color: 'rgba(79, 70, 229, 0.3)', width: 0 },
                name: 'Area [' + cfg.a + ', ' + cfg.b + ']',
                showlegend: true
            });
        }

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var layout = {
            margin: { t: 30, r: 20, b: 40, l: 50 },
            xaxis: { title: cfg.v, gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: isDark ? '#475569' : '#cbd5e1', color: isDark ? '#cbd5e1' : '#475569' },
            yaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: isDark ? '#475569' : '#cbd5e1', color: isDark ? '#cbd5e1' : '#475569' },
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#cbd5e1' : '#475569' },
            legend: { x: 0, y: 1.12, orientation: 'h', font: { size: 11 } },
            showlegend: true
        };

        Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    function evalAtPoint(exprStr, v, xVal) {
        try {
            var scope = {};
            scope[v] = xVal;
            var val = parseFloat(nerdamer(exprStr).evaluate(scope).text('decimals'));
            if (!isFinite(val) || Math.abs(val) > 1e6) return null;
            return val;
        } catch (e) {
            return null;
        }
    }

    function evalBound(s) {
        try {
            return parseFloat(nerdamer(s).evaluate().text('decimals'));
        } catch (e) {
            return parseFloat(s) || 0;
        }
    }

    // ========== Python Compiler ==========
    function nerdamerToPython(expr) {
        // Convert e^(...) to exp(...) BEFORE ^ -> ** conversion
        var py = expr
            .replace(/e\^(\([^)]+\))/g, 'exp$1')       // e^(2*x) -> exp(2*x)
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')  // e^x -> exp(x)
            .replace(/\^/g, '**');                         // remaining ^ -> **
        return py;
    }

    function buildCompilerCode(template) {
        var expr = exprInput.value.trim() || 'x**2';
        var pyExpr = nerdamerToPython(expr);
        var v = varSelect.value;
        var a = lowerInput.value.trim() || '0';
        var b = upperInput.value.trim() || '1';

        if (template === 'sympy-indef') {
            // SymPy: exp, sin, cos, log (=ln), sec, csc, cot all available via 'from sympy import *'
            return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr + '\n\nresult = integrate(expr, ' + v + ')\nprint("Integral:")\npprint(result)\nprint("\\nLaTeX:", latex(result))';
        } else if (template === 'sympy-def') {
            return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr + '\n\nresult = integrate(expr, (' + v + ', ' + a + ', ' + b + '))\nprint("Definite integral from ' + a + ' to ' + b + ':")\npprint(result)\nprint("\\nNumeric:", float(result))';
        } else {
            // SciPy: needs math.* prefixes; sec/csc/cot must be expanded
            var scipyExpr = pyExpr
                .replace(/sec\(([^)]+)\)/g, '(1/math.cos($1))')
                .replace(/csc\(([^)]+)\)/g, '(1/math.sin($1))')
                .replace(/cot\(([^)]+)\)/g, '(math.cos($1)/math.sin($1))')
                .replace(/sinh\(/g, 'math.sinh(')
                .replace(/cosh\(/g, 'math.cosh(')
                .replace(/tanh\(/g, 'math.tanh(')
                .replace(/asin\(/g, 'math.asin(')
                .replace(/acos\(/g, 'math.acos(')
                .replace(/atan\(/g, 'math.atan(')
                .replace(/sin\(/g, 'math.sin(')
                .replace(/cos\(/g, 'math.cos(')
                .replace(/tan\(/g, 'math.tan(')
                .replace(/exp\(/g, 'math.exp(')
                .replace(/sqrt\(/g, 'math.sqrt(')
                .replace(/log\(/g, 'math.log(')
                .replace(/abs\(/g, 'math.fabs(')
                .replace(/\bpi\b/g, 'math.pi');
            return 'from scipy.integrate import quad\nimport math\n\ndef f(' + v + '):\n    return ' + scipyExpr + '\n\nresult, error = quad(f, ' + a + ', ' + b + ')\nprint(f"Numerical integral: {result}")\nprint(f"Error estimate: {error}")';
        }
    }

    function loadCompilerWithTemplate() {
        var template = document.getElementById('ic-compiler-template').value;
        var code = buildCompilerCode(template);
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('ic-compiler-iframe');
        iframe.src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    document.getElementById('ic-compiler-template').addEventListener('change', function() {
        loadCompilerWithTemplate();
    });

    // ========== Copy / Share ==========
    document.getElementById('ic-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    document.getElementById('ic-copy-text-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultText, 'Result copied!');
        } else {
            navigator.clipboard.writeText(lastResultText);
        }
    });

    document.getElementById('ic-share-btn').addEventListener('click', function() {
        var params = { expr: exprInput.value, v: varSelect.value, mode: currentMode };
        if (currentMode === 'definite') {
            params.a = lowerInput.value;
            params.b = upperInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'Integral Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== Download PDF ==========
    document.getElementById('ic-download-pdf-btn').addEventListener('click', function() {
        downloadResultPdf();
    });

    function downloadResultPdf() {
        if (!lastIntegrationContext) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
            return;
        }

        var ctx = lastIntegrationContext;
        var exprTeX = exprToLatex(ctx.expr);

        // Build a clean off-screen container for capture
        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        // Title
        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#4f46e5;';
        title.textContent = 'Integral Calculator — 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#4f46e5,#6366f1,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        // Question section
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = ctx.mode === 'definite' ? 'Definite Integral' : 'Indefinite Integral';
        container.appendChild(qLabel);

        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
        container.appendChild(qMath);

        if (ctx.mode === 'definite') {
            katex.render('\\int_{' + ctx.a + '}^{' + ctx.b + '} ' + exprTeX + ' \\, d' + ctx.v, qMath, { displayMode: true, throwOnError: false });
        } else {
            katex.render('\\int ' + exprTeX + ' \\, d' + ctx.v, qMath, { displayMode: true, throwOnError: false });
        }

        // Answer section
        var aLabel = document.createElement('div');
        aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent = 'Result';
        container.appendChild(aLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#eef2ff;border-radius:8px;';
        container.appendChild(aMath);

        if (ctx.mode === 'definite') {
            katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false });
        } else {
            katex.render(ctx.resultTeX + ' + C', aMath, { displayMode: true, throwOnError: false });
        }

        // Method badge
        var methodDiv = document.createElement('div');
        methodDiv.style.cssText = 'font-size:13px;color:#64748b;margin-bottom:20px;';
        methodDiv.textContent = 'Method: ' + ctx.method;
        container.appendChild(methodDiv);

        // Include steps if they've been rendered
        var stepsArea = document.getElementById('ic-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.ic-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#4f46e5;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.ic-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.ic-step-math');
                if (mathEl) {
                    var sMath = document.createElement('div');
                    sMath.style.cssText = 'font-size:16px;';
                    // Re-render KaTeX from the katex source annotation
                    var katexAnnotation = mathEl.querySelector('annotation');
                    if (katexAnnotation) {
                        katex.render(katexAnnotation.textContent, sMath, { displayMode: true, throwOnError: false });
                    } else {
                        sMath.innerHTML = mathEl.innerHTML;
                    }
                    stepBody.appendChild(sMath);
                }

                stepRow.appendChild(stepBody);
                container.appendChild(stepRow);
            }
        }

        // Footer
        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Integral Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        // Capture and generate PDF
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

        // Ensure html2canvas is loaded
        var loadHtml2Canvas = (typeof html2canvas !== 'undefined')
            ? Promise.resolve()
            : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');

        loadHtml2Canvas.then(function() {
            return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
        }).then(function() {
            return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false });
        }).then(function(canvas) {
            document.body.removeChild(container);

            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });

            var pageWidth = pdf.internal.pageSize.getWidth();
            var pageHeight = pdf.internal.pageSize.getHeight();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;

            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;

            // If the image is taller than one page, scale it down to fit
            var usableHeight = pageHeight - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }

            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);

            var filename = 'integral-' + ctx.expr.replace(/[^a-zA-Z0-9]/g, '_').substring(0, 30) + '.pdf';
            pdf.save(filename);

            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Load from URL ==========
    function loadFromUrl() {
        var urlParams = new URLSearchParams(window.location.search);
        var expr = urlParams.get('expr');
        var v = urlParams.get('v');
        var mode = urlParams.get('mode');
        var a = urlParams.get('a');
        var b = urlParams.get('b');

        if (expr) {
            exprInput.value = decodeURIComponent(expr);
        }
        if (v) {
            varSelect.value = v;
        }
        if (mode === 'definite') {
            currentMode = 'definite';
            modeBtns.forEach(function(btn) {
                btn.classList.toggle('active', btn.getAttribute('data-mode') === 'definite');
            });
            boundsWrap.classList.add('visible');
            if (a) lowerInput.value = decodeURIComponent(a);
            if (b) upperInput.value = decodeURIComponent(b);
        }
        if (expr) {
            updatePreview();
            // Auto-integrate after short delay to let nerdamer load
            setTimeout(doIntegrate, 300);
        }
    }

    // ========== Utility ==========
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    // ========== Init ==========
    loadFromUrl();

    })();
    </script>
</body>
</html>
