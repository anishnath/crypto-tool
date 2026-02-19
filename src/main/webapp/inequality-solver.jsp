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
            --tool-primary:#059669;--tool-primary-dark:#047857;--tool-gradient:linear-gradient(135deg,#059669 0%,#10b981 100%);--tool-light:#ecfdf5
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(5,150,105,0.15)}
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
        @media(max-width:991px){
            .modern-nav{height:var(--header-height-mobile,64px)}
            .nav-container{padding:0 var(--space-3,0.75rem)}
            .nav-search,.nav-items{display:none}
            .nav-actions{gap:var(--space-2,0.5rem)}
            .btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}
            .mobile-menu-toggle,.mobile-search-toggle{display:flex}
            .btn-nav .nav-text{display:none}
        }

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
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{min-width:0;display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{min-width:0;display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}

        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:1rem;transition:opacity .15s,transform .15s}

        .tool-result-card{min-width:0;overflow:hidden;display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{min-width:0;flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions.visible{display:flex}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}

        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}

        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary,#cbd5e1)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(5,150,105,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}

        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Inequality Solver - Solve Inequalities Step by Step Free" />
        <jsp:param name="toolDescription" value="Free online inequality solver with step-by-step solutions and sign chart. Solve linear, quadratic, polynomial, rational, and absolute value inequalities. Shows interval notation, set-builder notation, number line graph. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="inequality-solver.jsp" />
        <jsp:param name="toolKeywords" value="inequality solver, solve inequalities online, inequality calculator with steps, quadratic inequality solver, polynomial inequality calculator, rational inequality solver, absolute value inequality, interval notation calculator, sign chart method, inequality graphing calculator, solve inequalities step by step free" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step sign chart method,Linear and quadratic inequalities,Polynomial inequality solver,Rational inequality solver,Absolute value inequalities,Compound inequalities,Interval notation output,Set-builder notation,Interactive number line,Function graph with solution shading,Download PDF,Copy LaTeX,Share via URL,Python SymPy compiler,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What types of inequalities can this solver handle?" />
        <jsp:param name="faq1a" value="This solver handles linear inequalities (2x+3>7), quadratic inequalities (x^2-4>=0), polynomial inequalities (x^3-x<0), rational inequalities ((x-1)/(x+2)>0), absolute value inequalities (|x-3|<5), and compound inequalities (1<2x+3<7). It finds all solutions using the sign chart method and presents results in interval notation and set-builder notation." />
        <jsp:param name="faq2q" value="How does the sign chart method work?" />
        <jsp:param name="faq2a" value="The sign chart method works by: (1) moving all terms to one side to get f(x)>0, (2) finding critical points where f(x)=0 or is undefined, (3) testing the sign of f(x) in each interval between critical points, (4) selecting intervals where the sign satisfies the inequality. This method works for all polynomial and rational inequalities." />
        <jsp:param name="faq3q" value="What is interval notation?" />
        <jsp:param name="faq3a" value="Interval notation uses parentheses () for excluded endpoints (strict inequalities) and brackets [] for included endpoints (non-strict). For example, (-2,3] means all numbers greater than -2 and up to 3. Union symbol U combines disjoint intervals: (-inf,-2) U (2,inf). The empty set is shown as {} and all real numbers as (-inf,inf)." />
        <jsp:param name="faq4q" value="What is the difference between < and ≤?" />
        <jsp:param name="faq4a" value="The less-than symbol (<) is a strict inequality excluding the endpoint, shown with open circles on the number line and parentheses in interval notation. The less-than-or-equal symbol (≤) is non-strict and includes the endpoint, shown with closed/filled circles and brackets. For example, x<2 gives (-inf,2) while x≤2 gives (-inf,2]." />
        <jsp:param name="faq5q" value="Can I download or share my solution?" />
        <jsp:param name="faq5a" value="Yes. After solving an inequality you can: (1) Download as PDF with the original inequality, solution, sign chart, and steps, (2) Copy as LaTeX for papers and documents, (3) Copy as plain text, or (4) Generate a shareable URL. The PDF includes a watermark and date." />
        <jsp:param name="faq6q" value="Is this inequality solver free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no signup, no account, and no limits. All computation runs client-side in your browser using the sign chart method. You get step-by-step solutions, interactive number line, function graph, PDF download, LaTeX export, and a Python SymPy compiler." />
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
        .tool-input{width:100%;padding:0.625rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.875rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);transition:border-color var(--transition-fast)}
        .tool-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(5,150,105,0.1)}
        .tool-input-mono{font-family:var(--font-mono);font-size:0.9375rem;letter-spacing:-0.02em}
        .tool-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);cursor:pointer}
        [data-theme="dark"] .tool-input,[data-theme="dark"] .tool-select{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        [data-theme="dark"] .tool-input:focus{box-shadow:0 0 0 3px rgba(5,150,105,0.25)}

        .iq-preview{background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);padding:0.75rem 1rem;min-height:48px;display:flex;align-items:center;justify-content:center;overflow-x:auto;font-size:1.1rem}
        .iq-preview .katex-display{margin:0}
        [data-theme="dark"] .iq-preview{background:var(--bg-tertiary);border-color:var(--border)}

        .iq-examples{display:flex;flex-wrap:wrap;gap:0.375rem}
        .iq-example-chip{padding:0.3rem 0.625rem;font-size:0.75rem;font-family:var(--font-mono);background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);cursor:pointer;transition:all 0.15s;color:var(--text-secondary);white-space:nowrap}
        .iq-example-chip:hover{background:var(--tool-primary);color:#fff;border-color:var(--tool-primary)}
        [data-theme="dark"] .iq-example-chip{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-secondary)}
        [data-theme="dark"] .iq-example-chip:hover{background:var(--tool-primary);color:#fff}

        .iq-syntax-toggle{display:flex;align-items:center;justify-content:space-between;cursor:pointer;padding:0.5rem 0;font-size:0.8125rem;font-weight:600;color:var(--text-secondary);border:none;background:none;width:100%;font-family:var(--font-sans)}
        .iq-syntax-content{display:none;font-size:0.75rem;font-family:var(--font-mono);color:var(--text-secondary);line-height:1.8;padding-bottom:0.5rem}
        .iq-syntax-content.open{display:block}
        .iq-syntax-chevron{transition:transform 0.2s;width:14px;height:14px;flex-shrink:0}

        .iq-output-tabs{display:flex;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);overflow:hidden}
        .iq-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.75rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all 0.15s;font-family:var(--font-sans);text-align:center}
        .iq-output-tab.active{background:var(--tool-gradient);color:#fff}
        .iq-output-tab:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .iq-output-tab{background:var(--bg-tertiary)}
        [data-theme="dark"] .iq-output-tab.active{background:var(--tool-gradient);color:#fff}
        [data-theme="dark"] .iq-output-tab:hover:not(.active){background:rgba(255,255,255,0.08)}

        .iq-panel{display:none;flex:1;min-height:0}
        .iq-panel.active{display:flex;flex-direction:column}
        #iq-panel-result .tool-result-card{flex:1}
        #iq-panel-numberline{min-height:300px}
        #iq-panel-graph{min-height:480px}
        #iq-panel-python{min-height:540px}

        .iq-result-math{padding:1.5rem;text-align:center;overflow-x:auto;max-width:100%}
        .iq-result-math .katex-display{margin:0.5rem 0;overflow-x:auto;overflow-y:hidden}
        .iq-result-label{font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted);margin-bottom:0.25rem}
        .iq-result-main{font-size:1.3rem;padding:1rem 0}
        .iq-result-solution{background:var(--tool-gradient);color:#fff;padding:1rem;border-radius:var(--radius-md);text-align:center;font-size:1.25rem;font-weight:700;margin:0.75rem 0}

        .iq-error{background:#fef3c7;border:1px solid #fbbf24;border-radius:var(--radius-md);padding:1.25rem;color:#92400e}
        .iq-error h4{margin:0 0 0.5rem;font-size:0.9375rem;font-weight:700}
        .iq-error ul{margin:0.5rem 0 0;padding-left:1.25rem;font-size:0.8125rem;line-height:1.7}
        [data-theme="dark"] .iq-error{background:rgba(251,191,36,0.15);border-color:rgba(251,191,36,0.3);color:#fbbf24}

        #iq-graph-container{width:100%;min-height:440px;border-radius:var(--radius-md)}
        .js-plotly-plot .plotly .modebar{top:4px!important;right:4px!important}

        .iq-sign-chart{width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem}
        .iq-sign-chart th,.iq-sign-chart td{padding:0.5rem 0.75rem;text-align:center;border:1px solid var(--border,#e2e8f0)}
        .iq-sign-chart th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary)}
        .iq-sign-chart td.positive{color:#059669;font-weight:600}
        .iq-sign-chart td.negative{color:#ef4444;font-weight:600}
        .iq-sign-chart td.zero{color:#3b82f6;font-weight:600}
        .iq-sign-chart td.in-solution{background:rgba(5,150,105,0.08)}
        [data-theme="dark"] .iq-sign-chart th{background:var(--bg-tertiary)}
        [data-theme="dark"] .iq-sign-chart th,[data-theme="dark"] .iq-sign-chart td{border-color:var(--border)}

        .iq-sep{border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.75rem 0}

        .iq-edu-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1rem;margin-top:1rem}
        .iq-edu-card{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:1.25rem}
        .iq-edu-card h4{font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem}
        .iq-edu-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        [data-theme="dark"] .iq-edu-card{background:var(--bg-tertiary);border-color:var(--border)}
        .iq-rules-table{width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem}
        .iq-rules-table th,.iq-rules-table td{padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border)}
        .iq-rules-table th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary)}
        .iq-rules-table td{color:var(--text-secondary);font-family:var(--font-mono);font-size:0.75rem}
        [data-theme="dark"] .iq-rules-table th{background:var(--bg-tertiary)}
        .iq-diagram{max-width:100%;height:auto;display:block;margin:1rem auto}

        .iq-steps-btn{display:inline-flex;align-items:center;gap:0.375rem;padding:0.5rem 1rem;font-size:0.8125rem;font-weight:600;font-family:var(--font-sans);border:1.5px solid var(--tool-primary);border-radius:var(--radius-full);background:transparent;color:var(--tool-primary);cursor:pointer;transition:all 0.15s;margin-top:0.75rem}
        .iq-steps-btn:hover{background:var(--tool-primary);color:#fff}
        .iq-steps-container{margin-top:1rem;border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
        .iq-steps-header{display:flex;align-items:center;gap:0.5rem;padding:0.625rem 1rem;background:var(--tool-light);border-bottom:1px solid var(--border);font-size:0.8125rem;font-weight:600;color:var(--tool-primary)}
        .iq-step{padding:0.75rem 1rem;border-bottom:1px solid var(--border-light);display:flex;gap:0.75rem;align-items:flex-start}
        .iq-step:last-child{border-bottom:none}
        .iq-step-num{flex-shrink:0;width:24px;height:24px;border-radius:50%;background:var(--tool-gradient);color:#fff;font-size:0.6875rem;font-weight:700;display:flex;align-items:center;justify-content:center}
        .iq-step-body{flex:1;min-width:0}
        .iq-step-title{font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem}
        .iq-step-math{font-size:1rem;overflow-x:auto}
        .iq-step-math .katex-display{margin:0;overflow-x:auto;overflow-y:hidden}
        [data-theme="dark"] .iq-steps-container{border-color:var(--border)}
        [data-theme="dark"] .iq-steps-header{background:var(--tool-light);border-bottom-color:var(--border)}
        [data-theme="dark"] .iq-step{border-bottom-color:var(--border)}

        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Inequality Solver</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math-tools">Math Tools</a> /
                    Inequality Solver
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">Sign Chart</span>
                <span class="tool-badge">PDF Export</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Solve linear, quadratic, polynomial, rational, and absolute value inequalities with <strong>detailed step-by-step solutions</strong> using the sign chart method. Shows <strong>interval notation</strong>, set-builder notation, interactive number line, and function graph. Includes <strong>PDF download</strong>, LaTeX export, and Python SymPy compiler. Free, instant, no signup.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;"><line x1="5" y1="9" x2="19" y2="9"/><line x1="5" y1="15" x2="19" y2="15"/><polyline points="15 5 19 9 15 13" fill="none"/></svg>
                    Inequality Solver
                </div>
                <div class="tool-card-body">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="iq-expr">Inequality</label>
                        <input type="text" class="tool-input tool-input-mono" id="iq-expr" placeholder="e.g. x^2 - 4 >= 0" autocomplete="off" spellcheck="false">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Live Preview</label>
                        <div class="iq-preview" id="iq-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Type an inequality above&hellip;</span></div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="iq-var">Variable</label>
                        <select class="tool-select" id="iq-var"><option value="x" selected>x</option><option value="y">y</option><option value="t">t</option><option value="n">n</option></select>
                    </div>
                    <button type="button" class="tool-action-btn" id="iq-solve-btn">Solve Inequality</button>
                    <hr class="iq-sep">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="iq-examples" id="iq-examples">
                            <button type="button" class="iq-example-chip" data-expr="2x+3>7">2x+3&gt;7</button>
                            <button type="button" class="iq-example-chip" data-expr="x^2-4>=0">x&sup2;-4&ge;0</button>
                            <button type="button" class="iq-example-chip" data-expr="x^2+x-6<0">x&sup2;+x-6&lt;0</button>
                            <button type="button" class="iq-example-chip" data-expr="(x-1)/(x+2)>0">(x-1)/(x+2)&gt;0</button>
                            <button type="button" class="iq-example-chip" data-expr="|x-3|<5">|x-3|&lt;5</button>
                            <button type="button" class="iq-example-chip" data-expr="x^3-x<=0">x&sup3;-x&le;0</button>
                            <button type="button" class="iq-example-chip" data-expr="x^2-5x+6>0">x&sup2;-5x+6&gt;0</button>
                            <button type="button" class="iq-example-chip" data-expr="1<2x+3<7">1&lt;2x+3&lt;7</button>
                        </div>
                    </div>
                    <hr class="iq-sep">
                    <div id="iq-syntax-wrap">
                        <button type="button" class="iq-syntax-toggle" id="iq-syntax-btn">Syntax Help <svg class="iq-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="iq-syntax-content" id="iq-syntax-content">&gt; &nbsp; &gt;= &nbsp; &lt; &nbsp; &lt;= &nbsp; operators<br>x^2 &rarr; power &nbsp; sqrt(x) &rarr; square root<br>abs(x) or |x| &rarr; absolute value<br>(num)/(den) &rarr; rational &nbsp; pi &nbsp; e &nbsp; constants</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="iq-output-tabs">
                <button type="button" class="iq-output-tab active" data-panel="result">Result</button>
                <button type="button" class="iq-output-tab" data-panel="numberline">Number Line</button>
                <button type="button" class="iq-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="iq-output-tab" data-panel="python">Python</button>
            </div>

            <div class="iq-panel active" id="iq-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="iq-result-content">
                        <div class="tool-empty-state" id="iq-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8823;</div>
                            <h3>Enter an inequality and click Solve</h3>
                            <p>Supports linear, quadratic, polynomial, rational, and absolute value inequalities.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="iq-result-actions">
                        <button type="button" class="tool-action-btn" id="iq-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="iq-copy-text-btn">&#128196; Copy Text</button>
                        <button type="button" class="tool-action-btn" id="iq-share-btn">&#128279; Share</button>
                        <button type="button" class="tool-action-btn" id="iq-download-pdf-btn">&#128196; PDF</button>
                    </div>
                </div>
            </div>

            <div class="iq-panel" id="iq-panel-numberline">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="2" y1="12" x2="22" y2="12"/><circle cx="8" cy="12" r="2"/><circle cx="16" cy="12" r="2"/></svg>
                        <h4>Number Line</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="iq-numberline-container"></div>
                        <p id="iq-numberline-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve an inequality to see the number line.</p>
                    </div>
                </div>
            </div>

            <div class="iq-panel" id="iq-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Interactive Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="iq-graph-container"></div>
                        <p id="iq-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve an inequality to see the graph.</p>
                    </div>
                </div>
            </div>

            <div class="iq-panel" id="iq-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                        <select id="iq-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="sympy-solve">SymPy solve_univariate</option>
                            <option value="sympy-reduce">SymPy reduce_inequalities</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="iq-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="inequality-solver.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is an Inequality?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>mathematical inequality</strong> compares two expressions using &gt;, &lt;, &ge;, or &le;. Unlike equations, inequalities describe a <strong>range of values</strong>. Solving an inequality means finding the complete set of values for which the statement is true, expressed in <strong>interval notation</strong> or on a <strong>number line</strong>.</p>
            <svg class="iq-diagram" viewBox="0 0 500 100" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
                <line x1="40" y1="50" x2="460" y2="50" stroke="#94a3b8" stroke-width="1.5"/>
                <line x1="80" y1="42" x2="80" y2="58" stroke="#94a3b8" stroke-width="1"/><text x="80" y="75" font-size="12" fill="#94a3b8" text-anchor="middle">-1</text>
                <line x1="140" y1="42" x2="140" y2="58" stroke="#94a3b8" stroke-width="1"/><text x="140" y="75" font-size="12" fill="#94a3b8" text-anchor="middle">0</text>
                <line x1="200" y1="42" x2="200" y2="58" stroke="#94a3b8" stroke-width="1"/><text x="200" y="75" font-size="12" fill="#94a3b8" text-anchor="middle">1</text>
                <line x1="260" y1="42" x2="260" y2="58" stroke="#94a3b8" stroke-width="1"/><text x="260" y="75" font-size="12" fill="#059669" font-weight="600" text-anchor="middle">2</text>
                <line x1="320" y1="42" x2="320" y2="58" stroke="#94a3b8" stroke-width="1"/><text x="320" y="75" font-size="12" fill="#94a3b8" text-anchor="middle">3</text>
                <line x1="380" y1="42" x2="380" y2="58" stroke="#94a3b8" stroke-width="1"/><text x="380" y="75" font-size="12" fill="#94a3b8" text-anchor="middle">4</text>
                <line x1="260" y1="50" x2="455" y2="50" stroke="#059669" stroke-width="4" stroke-linecap="round"/>
                <polygon points="460,50 448,44 448,56" fill="#059669"/>
                <circle cx="260" cy="50" r="6" fill="var(--bg-primary,#ffffff)" stroke="#059669" stroke-width="2.5"/>
                <text x="260" y="22" font-size="13" fill="#059669" font-weight="600" text-anchor="middle">x &gt; 2</text>
            </svg>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Types of Inequalities</h2>
            <div class="iq-edu-grid">
                <div class="iq-edu-card" style="border-left:3px solid #059669;"><h4>Linear</h4><p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">ax + b &gt; c</p><p>Solved by isolating x. Flip the inequality sign when multiplying or dividing by a negative number.</p></div>
                <div class="iq-edu-card" style="border-left:3px solid #10b981;"><h4>Quadratic</h4><p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">ax&sup2; + bx + c &gt; 0</p><p>Use the sign chart method with roots from the quadratic formula to determine solution intervals.</p></div>
                <div class="iq-edu-card" style="border-left:3px solid #34d399;"><h4>Rational</h4><p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">f(x)/g(x) &gt; 0</p><p>Critical points include zeros of both the numerator and denominator. Test each interval separately.</p></div>
                <div class="iq-edu-card" style="border-left:3px solid #6ee7b7;"><h4>Absolute Value</h4><p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">|f(x)| &lt; a</p><p>Splits into a compound inequality: -a &lt; f(x) &lt; a. For |f(x)| &gt; a, use f(x) &lt; -a or f(x) &gt; a.</p></div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The Sign Chart Method</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The sign chart method works in four steps: (1) Move all terms to one side so the other side is zero. (2) Factor the expression and find critical points. (3) Place critical points on a number line, dividing it into intervals. (4) Test a value from each interval to determine the sign, then select intervals that satisfy the inequality.</p>
            <svg class="iq-diagram" viewBox="0 0 500 150" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
                <text x="250" y="20" font-size="13" fill="#059669" font-weight="600" text-anchor="middle">Sign chart for x&#178; &#8722; 4 &gt; 0</text>
                <line x1="40" y1="70" x2="460" y2="70" stroke="#94a3b8" stroke-width="1.5"/>
                <circle cx="160" cy="70" r="5" fill="var(--bg-primary,#fff)" stroke="#059669" stroke-width="2"/>
                <text x="160" y="95" font-size="12" fill="#059669" font-weight="600" text-anchor="middle">-2</text>
                <circle cx="340" cy="70" r="5" fill="var(--bg-primary,#fff)" stroke="#059669" stroke-width="2"/>
                <text x="340" y="95" font-size="12" fill="#059669" font-weight="600" text-anchor="middle">2</text>
                <text x="80" y="55" font-size="16" fill="#059669" font-weight="700" text-anchor="middle">+</text>
                <text x="250" y="55" font-size="16" fill="#ef4444" font-weight="700" text-anchor="middle">&#8722;</text>
                <text x="420" y="55" font-size="16" fill="#059669" font-weight="700" text-anchor="middle">+</text>
                <line x1="40" y1="130" x2="155" y2="130" stroke="#059669" stroke-width="4" stroke-linecap="round"/>
                <line x1="345" y1="130" x2="460" y2="130" stroke="#059669" stroke-width="4" stroke-linecap="round"/>
                <text x="250" y="145" font-size="11" fill="#059669" font-weight="600" text-anchor="middle">Solution: (-&#8734;, -2) &#8746; (2, &#8734;)</text>
            </svg>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Interval Notation Guide</h2>
            <table class="iq-rules-table">
                <thead><tr><th style="width:25%;">Notation</th><th style="width:35%;">Meaning</th><th>Number Line</th></tr></thead>
                <tbody>
                    <tr><td>(a, b)</td><td>a &lt; x &lt; b</td><td>Open both ends</td></tr>
                    <tr><td>[a, b]</td><td>a &le; x &le; b</td><td>Closed both ends</td></tr>
                    <tr><td>[a, b)</td><td>a &le; x &lt; b</td><td>Closed-open</td></tr>
                    <tr><td>(-&#8734;, a)</td><td>x &lt; a</td><td>Arrow left</td></tr>
                    <tr><td>(a, &#8734;)</td><td>x &gt; a</td><td>Arrow right</td></tr>
                    <tr><td>A &#8746; B</td><td>A union B</td><td>Combined regions</td></tr>
                    <tr><td>&#8709;</td><td>Empty set</td><td>No solution</td></tr>
                </tbody>
            </table>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Applications of Inequalities</h2>
            <div class="iq-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
                <div class="iq-edu-card" style="text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128202;</div><h4>Optimization</h4><p>Find maximum/minimum values subject to constraints.</p></div>
                <div class="iq-edu-card" style="text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128290;</div><h4>Domain &amp; Range</h4><p>Determine where functions are defined or produce real outputs.</p></div>
                <div class="iq-edu-card" style="text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div><h4>Physics Constraints</h4><p>Model physical limits: velocity bounds, energy thresholds.</p></div>
                <div class="iq-edu-card" style="text-align:center;"><div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128176;</div><h4>Economics</h4><p>Budget constraints, profit margins, break-even analysis.</p></div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What types of inequalities can this solver handle?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">This solver handles linear (ax+b&gt;c), quadratic (ax&sup2;+bx+c&ge;0), polynomial (x&sup3;-x&lt;0), rational ((x-1)/(x+2)&gt;0), absolute value (|x-3|&lt;5), and compound (1&lt;2x+3&lt;7) inequalities. It uses the sign chart method and presents results in interval notation and set-builder notation.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How does the sign chart method work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The sign chart method: (1) Rearrange so one side is zero. (2) Find all roots and undefined points. (3) Plot critical values on a number line, dividing it into intervals. (4) Test a point from each interval and select intervals where the sign satisfies the inequality.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is interval notation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Interval notation uses parentheses ( ) for excluded endpoints and brackets [ ] for included endpoints. For example, (2, 5] means all numbers greater than 2 and up to 5. Infinity always uses parentheses. The union symbol &#8746; combines disjoint intervals.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the difference between &lt; and &le;?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The symbol &lt; means &ldquo;strictly less than&rdquo; (open circle, parenthesis). The symbol &le; means &ldquo;less than or equal to&rdquo; (filled circle, bracket). For example, x&lt;3 gives (-&#8734;, 3) while x&le;3 gives (-&#8734;, 3].</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Can I download or share my solution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes. Download as PDF, copy as LaTeX or plain text, or generate a shareable URL. The PDF includes the inequality, solution, sign chart, and steps.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Is this inequality solver free?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes, completely free with no signup. All computation runs client-side. You get step-by-step solutions, interactive number line, graph, PDF download, LaTeX export, and a Python SymPy compiler.</div></div>
        </div>
    </section>

    <section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:1.5rem 2rem;">
            <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);"><span style="font-size:1.3rem;">&#128293;</span> Explore More Math</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
                <a href="<%=request.getContextPath()%>/exams/quick-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''"><div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#d97706);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#9889;</div><div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quick Math</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">150+ mental math tricks and Vedic math shortcuts</p></div></a>
                <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''"><div style="width:3rem;height:3rem;background:linear-gradient(135deg,#8b5cf6,#7c3aed);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#128202;</div><div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Visual Math Lab</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">35 interactive visualizations for algebra and calculus</p></div></a>
                <a href="<%=request.getContextPath()%>/exams/math-memory/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''"><div style="width:3rem;height:3rem;background:linear-gradient(135deg,#10b981,#059669);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#129504;</div><div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Math Memory Games</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">16 free brain training games</p></div></a>
            </div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>
    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a><a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a></div></div></footer>
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.js"></script>
    <script>
    var __plotlyLoaded=false;
    function loadPlotly(cb){if(__plotlyLoaded){if(cb)cb();return;}var s=document.createElement('script');s.src='https://cdn.plot.ly/plotly-2.27.0.min.js';s.onload=function(){__plotlyLoaded=true;if(cb)cb();};document.head.appendChild(s);}
    </script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
    (function() {
    'use strict';

    var exprInput = document.getElementById('iq-expr');
    var previewEl = document.getElementById('iq-preview');
    var varSelect = document.getElementById('iq-var');
    var solveBtn = document.getElementById('iq-solve-btn');
    var resultContent = document.getElementById('iq-result-content');
    var resultActions = document.getElementById('iq-result-actions');
    var graphHint = document.getElementById('iq-graph-hint');
    var numberlineHint = document.getElementById('iq-numberline-hint');

    var lastResultLatex = '', lastResultText = '', compilerLoaded = false;
    var pendingGraph = null, pendingNumberline = null, lastSolveContext = null;

    window.toggleFaq = function(btn) { btn.parentElement.classList.toggle('open'); };

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.iq-output-tab');
    var panels = document.querySelectorAll('.iq-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('iq-panel-' + panel).classList.add('active');
            if (panel === 'numberline' && pendingNumberline) { renderNumberLine(pendingNumberline); pendingNumberline = null; }
            if (panel === 'graph' && pendingGraph) { loadPlotly(function() { renderGraph(pendingGraph); }); pendingGraph = null; }
            if (panel === 'python' && !compilerLoaded) { loadCompilerWithTemplate(); compilerLoaded = true; }
        });
    });

    // ========== Syntax Help ==========
    document.getElementById('iq-syntax-btn').addEventListener('click', function() {
        var c = document.getElementById('iq-syntax-content');
        c.classList.toggle('open');
        this.querySelector('.iq-syntax-chevron').style.transform = c.classList.contains('open') ? 'rotate(180deg)' : '';
    });

    // ========== Quick Examples ==========
    document.getElementById('iq-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.iq-example-chip');
        if (!chip) return;
        exprInput.value = chip.getAttribute('data-expr');
        updatePreview();
        exprInput.focus();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    exprInput.addEventListener('input', function() { clearTimeout(previewTimer); previewTimer = setTimeout(updatePreview, 200); });
    varSelect.addEventListener('change', updatePreview);

    function updatePreview() {
        var raw = exprInput.value.trim();
        if (!raw) { previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Type an inequality above\u2026</span>'; return; }
        try {
            var latex = inequalityToLatex(raw);
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch(e) { previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>'; }
    }

    function inequalityToLatex(raw) {
        // Handle compound: a < expr < b
        var compoundMatch = raw.match(/^(.+?)\s*(<=?)\s*(.+?)\s*(<=?)\s*(.+)$/);
        if (compoundMatch && !compoundMatch[3].match(/[<>=]/)) {
            var l = exprToLatex(compoundMatch[1]);
            var op1 = compoundMatch[2] === '<=' ? '\\leq' : '<';
            var mid = exprToLatex(compoundMatch[3]);
            var op2 = compoundMatch[4] === '<=' ? '\\leq' : '<';
            var r = exprToLatex(compoundMatch[5]);
            return l + ' ' + op1 + ' ' + mid + ' ' + op2 + ' ' + r;
        }
        var parts = raw.split(/(>=|<=|>|<)/);
        if (parts.length >= 3) {
            var lhs = exprToLatex(parts[0].trim());
            var op = parts[1] === '>=' ? '\\geq' : parts[1] === '<=' ? '\\leq' : parts[1] === '>' ? '>' : '<';
            var rhs = exprToLatex(parts.slice(2).join('').trim());
            return lhs + ' ' + op + ' ' + rhs;
        }
        return exprToLatex(raw);
    }

    function exprToLatex(expr) {
        var e = expr.replace(/\|([^|]+)\|/g, 'abs($1)');
        try { return nerdamer(e).toTeX(); } catch(err) {
            return e.replace(/\*/g, ' \\cdot ').replace(/abs\(([^)]+)\)/g, '|$1|');
        }
    }

    function escapeHtml(s) { var d = document.createElement('div'); d.appendChild(document.createTextNode(s)); return d.innerHTML; }

    // ========== Core: Parse Inequality ==========
    function parseInequality(input) {
        var raw = input.trim();

        // Absolute value: |expr| op val
        var absMatch = raw.match(/^\|([^|]+)\|\s*(>=?|<=?)\s*(.+)$/);
        if (absMatch) {
            var inner = absMatch[1], aop = absMatch[2], aval = absMatch[3].trim();
            if (aop === '<' || aop === '<=') {
                // |f| < a => -a < f < a
                return { type: 'compound', parts: [
                    { type: 'standard', expr: '(' + inner + ')-(' + aval + ')', op: aop, origLhs: inner, origRhs: aval },
                    { type: 'standard', expr: '(-(' + aval + '))-(' + inner + ')', op: aop, origLhs: '-' + aval, origRhs: inner }
                ], absInner: inner, absOp: aop, absVal: aval };
            } else {
                // |f| > a => f > a OR f < -a
                return { type: 'union', parts: [
                    { type: 'standard', expr: '(' + inner + ')-(' + aval + ')', op: aop === '>=' ? '>=' : '>', origLhs: inner, origRhs: aval },
                    { type: 'standard', expr: '(-(' + aval + '))-(' + inner + ')', op: aop === '>=' ? '>=' : '>', origLhs: '-' + aval, origRhs: inner }
                ], absInner: inner, absOp: aop, absVal: aval };
            }
        }

        // abs(expr) op val
        var absFnMatch = raw.match(/^abs\(([^)]+)\)\s*(>=?|<=?)\s*(.+)$/);
        if (absFnMatch) return parseInequality('|' + absFnMatch[1] + '|' + absFnMatch[2] + absFnMatch[3]);

        // Compound: a < expr < b
        var cMatch = raw.match(/^(.+?)\s*(<=?)\s*(.+?)\s*(<=?)\s*(.+)$/);
        if (cMatch) {
            var cLeft = cMatch[1].trim(), cOp1 = cMatch[2], cMid = cMatch[3].trim(), cOp2 = cMatch[4], cRight = cMatch[5].trim();
            // Check mid doesn't contain operators (to avoid false matches)
            if (!/[<>=]/.test(cMid)) {
                return { type: 'compound', parts: [
                    { type: 'standard', expr: '(' + cMid + ')-(' + cLeft + ')', op: cOp1 === '<=' ? '>=' : '>', origLhs: cMid, origRhs: cLeft },
                    { type: 'standard', expr: '(' + cMid + ')-(' + cRight + ')', op: cOp2 === '<=' ? '<=' : '<', origLhs: cMid, origRhs: cRight }
                ], compoundLeft: cLeft, compoundMid: cMid, compoundRight: cRight, compoundOp1: cOp1, compoundOp2: cOp2 };
            }
        }

        // Standard: lhs op rhs
        var opMatch = raw.match(/^(.*?)(>=|<=|>|<)(.*)$/);
        if (!opMatch) throw new Error('No inequality operator found. Use >, >=, <, or <=');
        var lhs = opMatch[1].trim(), op = opMatch[2], rhs = opMatch[3].trim();
        if (!lhs) throw new Error('Missing left-hand side');
        if (!rhs) rhs = '0';
        // Normalize: move rhs to left => expr = lhs - rhs
        lhs = lhs.replace(/\|([^|]+)\|/g, 'abs($1)');
        rhs = rhs.replace(/\|([^|]+)\|/g, 'abs($1)');
        var expr;
        if (rhs === '0') { expr = lhs; } else { expr = '(' + lhs + ')-(' + rhs + ')'; }
        return { type: 'standard', expr: expr, op: op, origLhs: lhs, origRhs: rhs };
    }

    // ========== Core: Solve ==========
    function solveStandard(expr, op, v) {
        var roots = [], denomZeros = [];
        // Find roots
        try {
            var sols = nerdamer.solve(expr, v);
            var solText = sols.text();
            roots = parseSolutions(solText);
        } catch(e) { /* no roots found */ }

        // Detect rational: try to find denominator zeros
        // Method 1: Check original expression for / at top level
        var denomExpr = extractDenominator(expr);
        if (denomExpr) {
            try {
                var denomSols = nerdamer.solve(denomExpr, v);
                denomZeros = parseSolutions(denomSols.text());
            } catch(e2) {}
        }
        // Method 2: Check nerdamer simplified form for ^(-1) or /
        if (denomZeros.length === 0) {
            try {
                var texRepr = nerdamer(expr).text();
                var negExpMatch = texRepr.match(/\(([^)]+)\)\^(?:\(-1\)|-1)/);
                if (negExpMatch) {
                    try {
                        var ds = nerdamer.solve(negExpMatch[1], v);
                        denomZeros = parseSolutions(ds.text());
                    } catch(e3) {}
                } else if (texRepr.indexOf('/') !== -1) {
                    var slParts = texRepr.match(/^(.+?)\/(.+)$/);
                    if (slParts) {
                        try {
                            var ds2 = nerdamer.solve(slParts[2], v);
                            denomZeros = parseSolutions(ds2.text());
                        } catch(e4) {}
                    }
                }
            } catch(e) {}
        }

        // Combine and sort critical points
        var allCritical = roots.concat(denomZeros);
        allCritical = uniqueSorted(allCritical);

        // Build intervals
        var intervals = [];
        if (allCritical.length === 0) {
            intervals.push({ left: -Infinity, right: Infinity, testPoint: 0 });
        } else {
            intervals.push({ left: -Infinity, right: allCritical[0], testPoint: allCritical[0] - 1 });
            for (var i = 0; i < allCritical.length - 1; i++) {
                intervals.push({ left: allCritical[i], right: allCritical[i+1], testPoint: (allCritical[i] + allCritical[i+1]) / 2 });
            }
            intervals.push({ left: allCritical[allCritical.length-1], right: Infinity, testPoint: allCritical[allCritical.length-1] + 1 });
        }

        // Test each interval
        var signChart = [];
        for (var j = 0; j < intervals.length; j++) {
            var sign = evaluateSign(expr, v, intervals[j].testPoint);
            var inSol = checkSign(sign, op);
            signChart.push({ interval: intervals[j], testPoint: intervals[j].testPoint, sign: sign, inSolution: inSol });
        }

        // Build solution intervals
        var includeEndpoints = (op === '>=' || op === '<=');
        var solutionIntervals = [];
        for (var k = 0; k < signChart.length; k++) {
            if (!signChart[k].inSolution) continue;
            var intv = signChart[k].interval;
            var li = (intv.left === -Infinity) ? false : (includeEndpoints && !isDenomZero(intv.left, denomZeros));
            var ri = (intv.right === Infinity) ? false : (includeEndpoints && !isDenomZero(intv.right, denomZeros));
            solutionIntervals.push({ left: intv.left, right: intv.right, leftInclusive: li, rightInclusive: ri });
        }

        // Merge adjacent
        solutionIntervals = mergeIntervals(solutionIntervals);

        var isAllReals = solutionIntervals.length === 1 && solutionIntervals[0].left === -Infinity && solutionIntervals[0].right === Infinity;
        return { criticalPoints: allCritical, denomZeros: denomZeros, roots: roots, signChart: signChart, intervals: solutionIntervals, expression: expr, op: op, isEmpty: solutionIntervals.length === 0, isAllReals: isAllReals };
    }

    function solveInequality(parsed, v) {
        if (parsed.type === 'standard') return solveStandard(parsed.expr, parsed.op, v);
        if (parsed.type === 'compound') {
            var s1 = solveStandard(parsed.parts[0].expr, parsed.parts[0].op, v);
            var s2 = solveStandard(parsed.parts[1].expr, parsed.parts[1].op, v);
            return { type: 'compound', sol1: s1, sol2: s2, intervals: intersectIntervals(s1.intervals, s2.intervals),
                     criticalPoints: uniqueSorted(s1.criticalPoints.concat(s2.criticalPoints)),
                     signChart: s1.signChart.concat(s2.signChart),
                     isEmpty: false, isAllReals: false, expression: parsed.parts[0].expr, op: parsed.parts[0].op };
        }
        if (parsed.type === 'union') {
            var u1 = solveStandard(parsed.parts[0].expr, parsed.parts[0].op, v);
            var u2 = solveStandard(parsed.parts[1].expr, parsed.parts[1].op, v);
            return { type: 'union', sol1: u1, sol2: u2, intervals: unionIntervals(u1.intervals, u2.intervals),
                     criticalPoints: uniqueSorted(u1.criticalPoints.concat(u2.criticalPoints)),
                     signChart: u1.signChart, isEmpty: false, isAllReals: false, expression: parsed.parts[0].expr, op: parsed.parts[0].op };
        }
        throw new Error('Unknown parsed type');
    }

    // ========== Helpers ==========
    function extractDenominator(expr) {
        // Find top-level '/' in original expression string
        var depth = 0;
        for (var i = 0; i < expr.length; i++) {
            if (expr[i] === '(') depth++;
            else if (expr[i] === ')') depth--;
            else if (expr[i] === '/' && depth === 0) {
                var denom = expr.substring(i + 1).trim();
                if (denom[0] === '(' && denom[denom.length - 1] === ')') {
                    denom = denom.substring(1, denom.length - 1);
                }
                return denom;
            }
        }
        return null;
    }

    function parseSolutions(text) {
        if (!text || text === '[]') return [];
        var inner = text.replace(/^\[/, '').replace(/\]$/, '');
        if (!inner.trim()) return [];
        var parts = inner.split(',');
        var result = [];
        for (var i = 0; i < parts.length; i++) {
            var p = parts[i].trim();
            if (p.indexOf('i') !== -1) continue; // skip complex
            try {
                var val = parseFloat(nerdamer(p).text('decimals'));
                if (isFinite(val)) result.push(val);
            } catch(e) {
                var n = parseFloat(p);
                if (isFinite(n)) result.push(n);
            }
        }
        return result;
    }

    function uniqueSorted(arr) {
        var seen = {}, result = [];
        for (var i = 0; i < arr.length; i++) {
            var key = arr[i].toFixed(10);
            if (!seen[key]) { seen[key] = true; result.push(arr[i]); }
        }
        return result.sort(function(a,b) { return a - b; });
    }

    function evaluateSign(expr, v, val) {
        try {
            var obj = {}; obj[v] = val;
            var result = nerdamer(expr, obj).text('decimals');
            var num = parseFloat(result);
            if (isNaN(num)) return '?';
            if (Math.abs(num) < 1e-10) return '0';
            return num > 0 ? '+' : '-';
        } catch(e) { return '?'; }
    }

    function checkSign(sign, op) {
        if (op === '>' || op === '>=') return sign === '+';
        if (op === '<' || op === '<=') return sign === '-';
        return false;
    }

    function isDenomZero(val, denomZeros) {
        for (var i = 0; i < denomZeros.length; i++) {
            if (Math.abs(val - denomZeros[i]) < 1e-10) return true;
        }
        return false;
    }

    function mergeIntervals(intervals) {
        if (intervals.length <= 1) return intervals;
        var merged = [intervals[0]];
        for (var i = 1; i < intervals.length; i++) {
            var last = merged[merged.length - 1];
            var cur = intervals[i];
            if (Math.abs(last.right - cur.left) < 1e-10 && (last.rightInclusive || cur.leftInclusive)) {
                last.right = cur.right;
                last.rightInclusive = cur.rightInclusive;
            } else {
                merged.push(cur);
            }
        }
        return merged;
    }

    function intersectIntervals(a, b) {
        var result = [];
        for (var i = 0; i < a.length; i++) {
            for (var j = 0; j < b.length; j++) {
                var left = Math.max(a[i].left, b[j].left);
                var right = Math.min(a[i].right, b[j].right);
                if (left < right || (left === right && a[i].leftInclusive && b[j].leftInclusive)) {
                    var li = (left === a[i].left ? a[i].leftInclusive : b[j].leftInclusive);
                    if (left === a[i].left && left === b[j].left) li = a[i].leftInclusive && b[j].leftInclusive;
                    var ri = (right === a[i].right ? a[i].rightInclusive : b[j].rightInclusive);
                    if (right === a[i].right && right === b[j].right) ri = a[i].rightInclusive && b[j].rightInclusive;
                    result.push({ left: left, right: right, leftInclusive: li, rightInclusive: ri });
                }
            }
        }
        return result;
    }

    function unionIntervals(a, b) {
        return mergeIntervals(a.concat(b).sort(function(x,y) { return x.left - y.left; }));
    }

    function formatInterval(intervals) {
        if (intervals.length === 0) return '\u2205';
        return intervals.map(function(iv) {
            var l = iv.left === -Infinity ? '(-\u221E' : (iv.leftInclusive ? '[' : '(') + formatNum(iv.left);
            var r = iv.right === Infinity ? '\u221E)' : formatNum(iv.right) + (iv.rightInclusive ? ']' : ')');
            return l + ', ' + r;
        }).join(' \u222A ');
    }

    function formatIntervalLatex(intervals) {
        if (intervals.length === 0) return '\\emptyset';
        return intervals.map(function(iv) {
            var l = iv.left === -Infinity ? '(-\\infty' : (iv.leftInclusive ? '[' : '(') + formatNum(iv.left);
            var r = iv.right === Infinity ? '\\infty)' : formatNum(iv.right) + (iv.rightInclusive ? ']' : ')');
            return l + ', ' + r;
        }).join(' \\cup ');
    }

    function formatNum(n) { return Number.isInteger(n) ? String(n) : n.toFixed(4).replace(/0+$/, '').replace(/\.$/, ''); }

    function formatSetBuilder(v, intervals) {
        if (intervals.length === 0) return '\\emptyset';
        var intervalLatex = formatIntervalLatex(intervals);
        return '\\{' + v + ' \\in \\mathbb{R} \\mid ' + v + ' \\in ' + intervalLatex + '\\}';
    }

    // ========== Main Solve ==========
    solveBtn.addEventListener('click', doSolve);
    exprInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doSolve(); });
    document.addEventListener('keydown', function(e) { if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') doSolve(); });

    function doSolve() {
        var raw = exprInput.value.trim();
        var v = varSelect.value;
        if (!raw) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter an inequality.', 2000, 'warning'); return; }

        try {
            var parsed = parseInequality(raw);
            var solution = solveInequality(parsed, v);

            // Fix isEmpty/isAllReals for compound/union
            if (solution.intervals) {
                solution.isEmpty = solution.intervals.length === 0;
                solution.isAllReals = solution.intervals.length === 1 && solution.intervals[0].left === -Infinity && solution.intervals[0].right === Infinity;
            }

            lastSolveContext = { raw: raw, parsed: parsed, solution: solution, v: v };
            lastResultLatex = formatIntervalLatex(solution.intervals);
            lastResultText = formatInterval(solution.intervals);

            showResult(raw, parsed, solution, v);
            resultActions.classList.add('visible');

            // Prepare number line and graph data
            pendingNumberline = solution;
            pendingGraph = { solution: solution, expr: parsed.type === 'standard' ? parsed.expr : (parsed.parts ? parsed.parts[0].expr : '0'), v: v };

            // Auto-render if tabs already active
            if (document.getElementById('iq-panel-numberline').classList.contains('active')) { renderNumberLine(pendingNumberline); pendingNumberline = null; }
            if (document.getElementById('iq-panel-graph').classList.contains('active') && pendingGraph) { loadPlotly(function() { renderGraph(pendingGraph); }); pendingGraph = null; }
            if (numberlineHint) numberlineHint.style.display = 'none';
            if (graphHint) graphHint.style.display = 'none';
        } catch(err) {
            showError(raw, err.message);
        }
    }

    // ========== Display Result ==========
    function showResult(raw, parsed, solution, v) {
        var html = '<div class="iq-result-math">';
        html += '<div class="iq-result-label">Inequality</div>';
        html += '<div id="iq-r-original"></div>';
        html += '<div class="iq-result-label" style="margin-top:1rem;">Solution (Interval Notation)</div>';
        if (solution.isEmpty) {
            html += '<div class="iq-result-solution" style="background:#ef4444;">\u2205 &nbsp; No Solution</div>';
        } else if (solution.isAllReals) {
            html += '<div class="iq-result-solution">(-\u221E, \u221E) &nbsp; All Real Numbers</div>';
        } else {
            html += '<div class="iq-result-solution" id="iq-r-interval"></div>';
        }
        html += '<div class="iq-result-label" style="margin-top:0.75rem;">Set-Builder Notation</div>';
        html += '<div id="iq-r-setbuilder" style="font-size:1rem;padding:0.5rem 0;"></div>';

        // Sign chart table (only for standard or first part)
        var sc = solution.signChart || (solution.sol1 ? solution.sol1.signChart : []);
        if (sc.length > 0) {
            html += '<div class="iq-result-label" style="margin-top:1rem;">Sign Chart</div>';
            html += '<table class="iq-sign-chart"><thead><tr><th>Interval</th><th>Test Point</th><th>Sign</th><th>In Solution?</th></tr></thead><tbody>';
            for (var i = 0; i < sc.length; i++) {
                var iv = sc[i].interval;
                var ivStr = (iv.left === -Infinity ? '(-\u221E' : '(' + formatNum(iv.left)) + ', ' + (iv.right === Infinity ? '\u221E)' : formatNum(iv.right) + ')');
                var signClass = sc[i].sign === '+' ? 'positive' : sc[i].sign === '-' ? 'negative' : 'zero';
                var inSolClass = sc[i].inSolution ? ' in-solution' : '';
                html += '<tr><td>' + escapeHtml(ivStr) + '</td><td>' + formatNum(sc[i].testPoint) + '</td>';
                html += '<td class="' + signClass + '">' + sc[i].sign + '</td>';
                html += '<td class="' + signClass + inSolClass + '">' + (sc[i].inSolution ? '\u2713 Yes' : '\u2717 No') + '</td></tr>';
            }
            html += '</tbody></table>';
        }

        html += '<button type="button" class="iq-steps-btn" id="iq-steps-btn" onclick="showSteps()">\u{1F4DD} Show Steps</button>';
        html += '<div id="iq-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        // Render KaTeX
        try { katex.render(inequalityToLatex(raw), document.getElementById('iq-r-original'), { displayMode: true, throwOnError: false }); } catch(e) {}
        if (!solution.isEmpty && !solution.isAllReals) {
            try { katex.render(formatIntervalLatex(solution.intervals), document.getElementById('iq-r-interval'), { displayMode: true, throwOnError: false }); } catch(e) {}
        }
        try { katex.render(formatSetBuilder(v, solution.intervals), document.getElementById('iq-r-setbuilder'), { displayMode: true, throwOnError: false }); } catch(e) {}
    }

    // ========== Steps ==========
    window.showSteps = function() {
        if (!lastSolveContext) return;
        var ctx = lastSolveContext;
        var v = ctx.v, parsed = ctx.parsed, solution = ctx.solution, raw = ctx.raw;
        var area = document.getElementById('iq-steps-area');
        if (area.children.length > 0) { area.innerHTML = ''; return; }

        var steps = [];
        steps.push({ title: 'Write the inequality', latex: inequalityToLatex(raw) });

        var mainExpr = parsed.type === 'standard' ? parsed.expr : (parsed.parts ? parsed.parts[0].expr : raw);
        var mainOp = parsed.type === 'standard' ? parsed.op : (parsed.parts ? parsed.parts[0].op : '>');
        var opLatex = mainOp === '>=' ? '\\geq' : mainOp === '<=' ? '\\leq' : mainOp === '>' ? '>' : '<';
        steps.push({ title: 'Move all terms to one side', latex: exprToLatex(mainExpr) + ' ' + opLatex + ' 0' });

        // Try to factor
        try {
            var factored = nerdamer('factor(' + mainExpr + ')').toTeX();
            if (factored !== exprToLatex(mainExpr)) {
                steps.push({ title: 'Factor the expression', latex: factored + ' ' + opLatex + ' 0' });
            }
        } catch(e) {}

        // Critical points
        var cps = solution.criticalPoints || [];
        if (cps.length > 0) {
            var cpLatex = cps.map(function(cp) { return v + ' = ' + formatNum(cp); }).join(', \\quad ');
            steps.push({ title: 'Find critical points', latex: cpLatex });
        } else {
            steps.push({ title: 'Find critical points', latex: '\\text{No real critical points found}' });
        }

        steps.push({ title: 'Build sign chart and test intervals', latex: '\\text{Test a point from each interval to determine the sign of } f(' + v + ')' });

        // Solution
        steps.push({ title: 'Identify solution intervals', latex: '\\text{Solution: } ' + formatIntervalLatex(solution.intervals) });
        steps.push({ title: 'Write in interval notation', latex: formatIntervalLatex(solution.intervals) });

        var html = '<div class="iq-steps-container"><div class="iq-steps-header">\u{1F4DD} Step-by-Step Solution</div>';
        for (var i = 0; i < steps.length; i++) {
            html += '<div class="iq-step"><div class="iq-step-num">' + (i+1) + '</div><div class="iq-step-body">';
            html += '<div class="iq-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="iq-step-math" id="iq-step-math-' + i + '"></div></div></div>';
        }
        html += '</div>';
        area.innerHTML = html;
        for (var j = 0; j < steps.length; j++) {
            try { katex.render(steps[j].latex, document.getElementById('iq-step-math-' + j), { displayMode: true, throwOnError: false }); } catch(e) {}
        }
    };

    // ========== Error ==========
    function showError(expr, msg) {
        resultActions.classList.remove('visible');
        resultContent.innerHTML = '<div class="iq-error"><h4>Could Not Solve</h4><p>The inequality <strong>' + escapeHtml(expr) + '</strong> could not be solved.' + (msg ? ' (' + escapeHtml(msg) + ')' : '') + '</p><ul><li>Check syntax (see Syntax Help)</li><li>Use explicit multiplication: 2*x not 2x</li><li>Try a simpler form</li></ul></div>';
    }

    // ========== Number Line ==========
    function renderNumberLine(solution) {
        var container = document.getElementById('iq-numberline-container');
        var intervals = solution.intervals || [];
        var cps = solution.criticalPoints || [];

        // Determine range
        var min = -5, max = 5;
        if (cps.length > 0) { min = cps[0] - 2; max = cps[cps.length-1] + 2; }
        var range = max - min || 10;
        var W = 600, H = 100, pad = 50;
        var scale = function(v) { return pad + (v - min) / range * (W - 2*pad); };

        var svg = '<svg viewBox="0 0 ' + W + ' ' + H + '" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:600px;display:block;margin:0 auto;">';
        // Axis
        svg += '<line x1="' + pad + '" y1="50" x2="' + (W-pad) + '" y2="50" stroke="#94a3b8" stroke-width="1.5"/>';
        svg += '<polygon points="' + (W-pad+5) + ',50 ' + (W-pad-5) + ',44 ' + (W-pad-5) + ',56" fill="#94a3b8"/>';
        svg += '<polygon points="' + (pad-5) + ',50 ' + (pad+5) + ',44 ' + (pad+5) + ',56" fill="#94a3b8"/>';

        // Tick marks for critical points
        for (var i = 0; i < cps.length; i++) {
            var cx = scale(cps[i]);
            svg += '<line x1="' + cx + '" y1="42" x2="' + cx + '" y2="58" stroke="#94a3b8" stroke-width="1"/>';
            svg += '<text x="' + cx + '" y="75" font-size="12" fill="#059669" font-weight="600" text-anchor="middle">' + formatNum(cps[i]) + '</text>';
        }

        // Solution intervals (shading)
        for (var j = 0; j < intervals.length; j++) {
            var iv = intervals[j];
            var x1 = iv.left === -Infinity ? pad : scale(iv.left);
            var x2 = iv.right === Infinity ? (W-pad) : scale(iv.right);
            svg += '<line x1="' + x1 + '" y1="50" x2="' + x2 + '" y2="50" stroke="#059669" stroke-width="5" stroke-linecap="round"/>';
            // Arrows for infinity
            if (iv.left === -Infinity) svg += '<polygon points="' + (pad-3) + ',50 ' + (pad+7) + ',44 ' + (pad+7) + ',56" fill="#059669"/>';
            if (iv.right === Infinity) svg += '<polygon points="' + (W-pad+3) + ',50 ' + (W-pad-7) + ',44 ' + (W-pad-7) + ',56" fill="#059669"/>';
        }

        // Circles at critical points
        for (var k = 0; k < cps.length; k++) {
            var px = scale(cps[k]);
            var filled = isEndpointIncluded(cps[k], intervals);
            if (filled) {
                svg += '<circle cx="' + px + '" cy="50" r="5" fill="#059669" stroke="#059669" stroke-width="2"/>';
            } else {
                svg += '<circle cx="' + px + '" cy="50" r="5" fill="var(--bg-primary,#fff)" stroke="#059669" stroke-width="2.5"/>';
            }
        }

        svg += '</svg>';
        container.innerHTML = svg;
    }

    function isEndpointIncluded(val, intervals) {
        for (var i = 0; i < intervals.length; i++) {
            if (Math.abs(intervals[i].left - val) < 1e-10 && intervals[i].leftInclusive) return true;
            if (Math.abs(intervals[i].right - val) < 1e-10 && intervals[i].rightInclusive) return true;
        }
        return false;
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly) return;
        var expr = cfg.expr, v = cfg.v, solution = cfg.solution;
        var cps = solution.criticalPoints || [];
        var min = -5, max = 5;
        if (cps.length > 0) { min = cps[0] - 3; max = cps[cps.length-1] + 3; }

        var xs = [], ys = [];
        var step = (max - min) / 300;
        for (var x = min; x <= max; x += step) {
            xs.push(x);
            try {
                var obj = {}; obj[v] = x;
                var val = parseFloat(nerdamer(expr, obj).text('decimals'));
                ys.push(isFinite(val) ? val : null);
            } catch(e) { ys.push(null); }
        }

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var traces = [{
            x: xs, y: ys, type: 'scatter', mode: 'lines',
            line: { color: '#059669', width: 2.5 }, name: 'f(' + v + ')'
        }];

        // Highlight solution regions on x-axis
        var shapes = [];
        var intervals = solution.intervals || [];
        for (var i = 0; i < intervals.length; i++) {
            var iv = intervals[i];
            shapes.push({
                type: 'rect', xref: 'x', yref: 'paper',
                x0: iv.left === -Infinity ? min - 1 : iv.left,
                x1: iv.right === Infinity ? max + 1 : iv.right,
                y0: 0, y1: 1,
                fillcolor: 'rgba(5,150,105,0.1)', line: { width: 0 }
            });
        }

        // Critical point dots
        if (cps.length > 0) {
            var cpYs = [];
            for (var j = 0; j < cps.length; j++) {
                try {
                    var obj2 = {}; obj2[v] = cps[j];
                    cpYs.push(parseFloat(nerdamer(expr, obj2).text('decimals')));
                } catch(e) { cpYs.push(0); }
            }
            traces.push({
                x: cps, y: cpYs, type: 'scatter', mode: 'markers',
                marker: { color: '#059669', size: 8, line: { color: '#fff', width: 2 } }, name: 'Critical Points'
            });
        }

        // Zero line
        traces.push({
            x: [min, max], y: [0, 0], type: 'scatter', mode: 'lines',
            line: { color: '#94a3b8', width: 1, dash: 'dash' }, showlegend: false
        });

        var layout = {
            paper_bgcolor: isDark ? '#1e293b' : '#fff',
            plot_bgcolor: isDark ? '#1e293b' : '#fff',
            font: { family: 'Inter, sans-serif', color: isDark ? '#f1f5f9' : '#0f172a' },
            margin: { t: 20, r: 20, b: 40, l: 50 },
            xaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: '#94a3b8' },
            yaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: '#94a3b8' },
            shapes: shapes, showlegend: false
        };

        Plotly.newPlot('iq-graph-container', traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function loadCompilerWithTemplate() {
        var template = document.getElementById('iq-compiler-template').value;
        var raw = exprInput.value.trim() || 'x^2 - 4 >= 0';
        var v = varSelect.value;
        var parsed;
        try { parsed = parseInequality(raw); } catch(e) { parsed = { type: 'standard', expr: 'x**2 - 4', op: '>=' }; }
        var expr = (parsed.type === 'standard' ? parsed.expr : (parsed.parts ? parsed.parts[0].expr : 'x**2-4')).replace(/\^/g, '**');
        var opStr = parsed.type === 'standard' ? parsed.op : (parsed.parts ? parsed.parts[0].op : '>=');
        var pyOp = opStr === '>=' ? '>=' : opStr === '<=' ? '<=' : opStr === '>' ? '>' : '<';
        var code;
        if (template === 'sympy-solve') {
            code = 'from sympy import symbols, solve_univariate_inequality, S, oo\nfrom sympy.parsing.sympy_parser import parse_expr\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = parse_expr(\'' + expr.replace(/'/g, "\\'") + '\')\n\nresult = solve_univariate_inequality(expr ' + pyOp + ' 0, ' + v + ', relational=False)\nprint(f"Solution: {result}")';
        } else {
            code = 'from sympy import symbols, reduce_inequalities\n\n' + v + ' = symbols(\'' + v + '\')\n\nresult = reduce_inequalities([\'' + expr + ' ' + pyOp + ' 0\'], ' + v + ')\nprint(f"Solution: {result}")';
        }
        var b64 = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64 });
        document.getElementById('iq-compiler-iframe').src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }
    document.getElementById('iq-compiler-template').addEventListener('change', function() { loadCompilerWithTemplate(); });

    // ========== Actions ==========
    document.getElementById('iq-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        else navigator.clipboard.writeText(lastResultLatex);
    });
    document.getElementById('iq-copy-text-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') ToolUtils.copyToClipboard(lastResultText, 'Copied!');
        else navigator.clipboard.writeText(lastResultText);
    });
    document.getElementById('iq-share-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl({ expr: exprInput.value, 'var': varSelect.value }, { toolName: 'Inequality Solver' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });
    document.getElementById('iq-download-pdf-btn').addEventListener('click', function() {
        if (!lastSolveContext) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning'); return; }
        downloadResultPdf();
    });

    function downloadResultPdf() {
        var ctx = lastSolveContext;

        // Build off-screen container for capture
        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        // Title
        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#059669;';
        title.textContent = 'Inequality Solver \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#059669,#10b981,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        // Inequality
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = 'Inequality';
        container.appendChild(qLabel);

        var qMath = document.createElement('div');
        qMath.style.cssText = 'font-size:20px;margin-bottom:24px;';
        container.appendChild(qMath);
        try { katex.render(inequalityToLatex(ctx.raw), qMath, { displayMode: true, throwOnError: false }); } catch(e) { qMath.textContent = ctx.raw; }

        // Solution
        var aLabel = document.createElement('div');
        aLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent = 'Solution (Interval Notation)';
        container.appendChild(aLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#ecfdf5;border-radius:8px;';
        container.appendChild(aMath);
        try { katex.render(lastResultLatex, aMath, { displayMode: true, throwOnError: false }); } catch(e) { aMath.textContent = lastResultText; }

        // Plain text version
        var textDiv = document.createElement('div');
        textDiv.style.cssText = 'font-size:14px;color:#334155;margin-bottom:20px;font-family:monospace;';
        textDiv.textContent = lastResultText;
        container.appendChild(textDiv);

        // Include steps if rendered
        var stepsArea = document.getElementById('iq-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.iq-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#059669;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.iq-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.iq-step-math');
                if (mathEl) {
                    var sMath = document.createElement('div');
                    sMath.style.cssText = 'font-size:16px;';
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
        footer.innerHTML = '<span>Generated by 8gwifi.org Inequality Solver</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        // Capture and generate PDF
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

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

            var usableHeight = pageHeight - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }

            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);

            var filename = 'inequality-' + ctx.raw.replace(/[^a-zA-Z0-9]/g, '_').substring(0, 30) + '.pdf';
            pdf.save(filename);

            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed', 3000, 'error');
        });
    }

    // ========== Load from URL ==========
    (function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var expr = params.get('expr');
        var v = params.get('var');
        if (v) varSelect.value = v;
        if (expr) {
            exprInput.value = decodeURIComponent(expr);
            updatePreview();
            setTimeout(doSolve, 300);
        }
    })();

    })();
    </script>
</body>
</html>
