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
            --tool-primary:#8b5cf6;--tool-primary-dark:#7c3aed;--tool-gradient:linear-gradient(135deg,#a78bfa 0%,#8b5cf6 100%);--tool-light:#f5f3ff
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(139,92,246,0.15)}
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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(139,92,246,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Limit Calculator with Steps | Free Online Limit Solver" />
        <jsp:param name="toolDescription" value="Free limit calculator with step-by-step solutions. Solve one-sided, two-sided, and infinity limits using L'Hopital's rule, factoring, and squeeze theorem." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="limit-calculator.jsp" />
        <jsp:param name="toolKeywords" value="limit calculator, limit calculator with steps, limit solver, limit calculator online free, calculus limit calculator, l'hopital rule calculator, evaluate limit calculator, one sided limit calculator, two sided limit calculator, limit at infinity calculator, indeterminate form calculator, find limit calculator, limit finder, squeeze theorem calculator, how to find limit of a function, left hand limit calculator, right hand limit calculator, 0/0 limit" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step solutions,Direct substitution,L'Hopital's Rule,Factoring and cancellation,One-sided limits (left and right),Two-sided limits,Limits at infinity,Indeterminate form detection (0/0 and infinity/infinity),Numerical approximation table,Squeeze theorem,Live KaTeX math preview,Interactive Plotly graph,Download PDF,Copy LaTeX,Share URL,Python SymPy compiler,Dark mode,Free with no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a limit in calculus?" />
        <jsp:param name="faq1a" value="A limit describes the value a function f(x) approaches as x gets closer to a specific point. Written as lim(x approaches a) f(x) = L, limits are the foundation of calculus used to define derivatives, integrals, and continuity. For example, lim(x approaches 0) sin(x)/x = 1." />
        <jsp:param name="faq2q" value="How to find the limit of a function step by step?" />
        <jsp:param name="faq2a" value="To find a limit step by step: 1) Try direct substitution by plugging in the value. 2) If you get an indeterminate form like 0/0, try factoring and canceling common factors. 3) If factoring fails, apply L'Hopital's Rule by differentiating the numerator and denominator separately. 4) For limits at infinity, divide by the highest power of x. This calculator automates all these steps." />
        <jsp:param name="faq3q" value="What is L'Hopital's Rule and when do you use it?" />
        <jsp:param name="faq3a" value="L'Hopital's Rule states that for indeterminate forms 0/0 or infinity/infinity, lim f(x)/g(x) = lim f'(x)/g'(x). Use it when direct substitution gives 0/0 or infinity/infinity. Differentiate the numerator and denominator separately (not using the quotient rule), then re-evaluate. You can apply it repeatedly if the result is still indeterminate." />
        <jsp:param name="faq4q" value="What are the seven indeterminate forms?" />
        <jsp:param name="faq4a" value="The seven indeterminate forms are: 0/0, infinity/infinity, 0 times infinity, infinity minus infinity, 0^0, 1^infinity, and infinity^0. Each requires a special technique to resolve. For 0/0 and infinity/infinity use L'Hopital's Rule or factoring. For 0 times infinity, rewrite as a fraction. For exponential forms (0^0, 1^infinity, infinity^0), take the natural logarithm first." />
        <jsp:param name="faq5q" value="How to calculate one-sided limits?" />
        <jsp:param name="faq5a" value="A one-sided limit evaluates a function as x approaches a value from only one direction. The left-hand limit (x approaches a from the left, written a-minus) uses values slightly less than a. The right-hand limit (x approaches a from the right, written a-plus) uses values slightly greater than a. A two-sided limit exists only if both one-sided limits are equal. Use the direction toggle in this calculator to choose left, right, or two-sided." />
        <jsp:param name="faq6q" value="How to evaluate limits at infinity?" />
        <jsp:param name="faq6a" value="To evaluate limits at infinity for rational functions: divide every term by the highest power of x in the denominator. If the degree of the numerator equals the denominator, the limit is the ratio of leading coefficients. If the numerator degree is less, the limit is 0. If greater, the limit is infinity. For exponential functions like e^x, the limit as x approaches infinity is infinity. Type infinity or -infinity as the limit point in this calculator." />
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
    <style>
        .tool-input{width:100%;padding:0.625rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.875rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);transition:border-color var(--transition-fast)}
        .tool-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(139,92,246,0.1)}
        .tool-input-mono{font-family:var(--font-mono);font-size:0.9375rem;letter-spacing:-0.02em}
        .tool-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);cursor:pointer}
        [data-theme="dark"] .tool-input,[data-theme="dark"] .tool-select{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        [data-theme="dark"] .tool-input:focus{box-shadow:0 0 0 3px rgba(139,92,246,0.25)}
        .lc-dir-toggle{display:flex;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);overflow:hidden}
        .lc-dir-btn{flex:1;padding:0.5rem;font-weight:600;font-size:0.75rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all 0.15s;font-family:var(--font-sans);text-align:center}
        .lc-dir-btn.active{background:var(--tool-gradient);color:#fff}
        .lc-dir-btn:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .lc-dir-btn{background:var(--bg-tertiary)}[data-theme="dark"] .lc-dir-btn.active{background:var(--tool-gradient);color:#fff}[data-theme="dark"] .lc-dir-btn:hover:not(.active){background:rgba(255,255,255,0.08)}
        .lc-preview{background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);padding:0.75rem 1rem;min-height:48px;display:flex;align-items:center;justify-content:center;overflow-x:auto;font-size:1.1rem}
        .lc-preview .katex-display{margin:0}
        [data-theme="dark"] .lc-preview{background:var(--bg-tertiary);border-color:var(--border)}
        .lc-examples{display:flex;flex-wrap:wrap;gap:0.375rem}
        .lc-example-chip{padding:0.3rem 0.625rem;font-size:0.75rem;font-family:var(--font-mono);background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);cursor:pointer;transition:all 0.15s;color:var(--text-secondary);white-space:nowrap}
        .lc-example-chip:hover{background:var(--tool-primary);color:#fff;border-color:var(--tool-primary)}
        [data-theme="dark"] .lc-example-chip{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-secondary)}[data-theme="dark"] .lc-example-chip:hover{background:var(--tool-primary);color:#fff}
        .lc-syntax-toggle{display:flex;align-items:center;justify-content:space-between;cursor:pointer;padding:0.5rem 0;font-size:0.8125rem;font-weight:600;color:var(--text-secondary);border:none;background:none;width:100%;font-family:var(--font-sans)}
        .lc-syntax-content{display:none;font-size:0.75rem;font-family:var(--font-mono);color:var(--text-secondary);line-height:1.8;padding-bottom:0.5rem}
        .lc-syntax-content.open{display:block}
        .lc-syntax-chevron{transition:transform 0.2s;width:14px;height:14px;flex-shrink:0}
        .lc-output-tabs{display:flex;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);overflow:hidden}
        .lc-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all 0.15s;font-family:var(--font-sans);text-align:center}
        .lc-output-tab.active{background:var(--tool-gradient);color:#fff}
        .lc-output-tab:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .lc-output-tab{background:var(--bg-tertiary)}[data-theme="dark"] .lc-output-tab.active{background:var(--tool-gradient);color:#fff}[data-theme="dark"] .lc-output-tab:hover:not(.active){background:rgba(255,255,255,0.08)}
        .lc-panel{display:none;flex:1;min-height:0}.lc-panel.active{display:flex;flex-direction:column}
        #lc-panel-result .tool-result-card{flex:1}#lc-panel-graph{min-height:480px}#lc-panel-python{min-height:540px}
        .lc-result-math{padding:1.5rem;text-align:center;overflow-x:auto;max-width:100%}.lc-result-math .katex-display{margin:0.5rem 0;overflow-x:auto;overflow-y:hidden}
        .lc-result-label{font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted);margin-bottom:0.25rem}
        .lc-result-main{font-size:1.3rem;padding:1rem 0}
        .lc-result-value{background:var(--tool-gradient);color:#fff;padding:1rem;border-radius:var(--radius-md);text-align:center;font-size:1.25rem;font-weight:700;margin:0.75rem 0}
        .lc-result-detail{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:0.75rem 1rem;margin-top:0.75rem;font-size:0.8125rem;color:var(--text-secondary)}
        [data-theme="dark"] .lc-result-detail{background:var(--bg-tertiary);border-color:var(--border)}
        .lc-method-badge{display:inline-block;background:var(--tool-light);color:var(--tool-primary);padding:0.2rem 0.625rem;border-radius:9999px;font-size:0.6875rem;font-weight:600;margin-right:0.375rem}
        .lc-form-badge{display:inline-block;background:#fef3c7;color:#92400e;padding:0.2rem 0.625rem;border-radius:9999px;font-size:0.6875rem;font-weight:600}
        [data-theme="dark"] .lc-form-badge{background:rgba(251,191,36,0.15);color:#fbbf24}
        .lc-approx-table{width:100%;border-collapse:collapse;font-size:0.75rem;margin-top:0.75rem}
        .lc-approx-table th,.lc-approx-table td{padding:0.375rem 0.5rem;text-align:center;border-bottom:1px solid var(--border)}
        .lc-approx-table th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary);font-size:0.6875rem;text-transform:uppercase;letter-spacing:0.04em}
        .lc-approx-table td{color:var(--text-secondary);font-family:var(--font-mono)}
        [data-theme="dark"] .lc-approx-table th{background:var(--bg-tertiary)}
        .lc-error{background:#fef3c7;border:1px solid #fbbf24;border-radius:var(--radius-md);padding:1.25rem;color:#92400e}
        .lc-error h4{margin:0 0 0.5rem;font-size:0.9375rem;font-weight:700}
        .lc-error ul{margin:0.5rem 0 0;padding-left:1.25rem;font-size:0.8125rem;line-height:1.7}
        [data-theme="dark"] .lc-error{background:rgba(251,191,36,0.15);border-color:rgba(251,191,36,0.3);color:#fbbf24}
        #lc-graph-container{width:100%;min-height:440px;border-radius:var(--radius-md)}
        .js-plotly-plot .plotly .modebar{top:4px!important;right:4px!important}
        .lc-sep{border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.75rem 0}
        .lc-edu-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1rem;margin-top:1rem}
        .lc-edu-card{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:1.25rem}
        .lc-edu-card h4{font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem}
        .lc-edu-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        [data-theme="dark"] .lc-edu-card{background:var(--bg-tertiary);border-color:var(--border)}
        .lc-rules-table{width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem}
        .lc-rules-table th,.lc-rules-table td{padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border)}
        .lc-rules-table th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary)}
        .lc-rules-table td{color:var(--text-secondary);font-family:var(--font-mono);font-size:0.75rem}
        [data-theme="dark"] .lc-rules-table th{background:var(--bg-tertiary)}
        .lc-steps-btn{display:inline-flex;align-items:center;gap:0.375rem;padding:0.5rem 1rem;font-size:0.8125rem;font-weight:600;font-family:var(--font-sans);border:1.5px solid var(--tool-primary);border-radius:var(--radius-full);background:transparent;color:var(--tool-primary);cursor:pointer;transition:all 0.15s;margin-top:0.75rem}
        .lc-steps-btn:hover{background:var(--tool-primary);color:#fff}
        .lc-steps-btn.loading{opacity:0.7;pointer-events:none}
        .lc-steps-container{margin-top:1rem;border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
        .lc-steps-header{display:flex;align-items:center;gap:0.5rem;padding:0.625rem 1rem;background:var(--tool-light);border-bottom:1px solid var(--border);font-size:0.8125rem;font-weight:600;color:var(--tool-primary)}
        .lc-step{padding:0.75rem 1rem;border-bottom:1px solid var(--border-light);display:flex;gap:0.75rem;align-items:flex-start}
        .lc-step:last-child{border-bottom:none}
        .lc-step-num{flex-shrink:0;width:24px;height:24px;border-radius:50%;background:var(--tool-gradient);color:#fff;font-size:0.6875rem;font-weight:700;display:flex;align-items:center;justify-content:center}
        .lc-step-body{flex:1;min-width:0}
        .lc-step-title{font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem}
        .lc-step-math{font-size:1rem;overflow-x:auto}.lc-step-math .katex-display{margin:0;overflow-x:auto;overflow-y:hidden}
        [data-theme="dark"] .lc-steps-container{border-color:var(--border)}[data-theme="dark"] .lc-steps-header{background:var(--tool-light);border-bottom-color:var(--border)}[data-theme="dark"] .lc-step{border-bottom-color:var(--border)}
        @keyframes lc-spin{to{transform:rotate(360deg)}}
        .lc-spinner{width:14px;height:14px;border:2px solid var(--border);border-top-color:var(--tool-primary);border-radius:50%;animation:lc-spin 0.6s linear infinite}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Limit Calculator - Solve Limits with Steps</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math-tools">Math Tools</a> /
                    Limit Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">L'H&ocirc;pital's Rule</span>
                <span class="tool-badge">One-Sided</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>limit calculator</strong> that shows <strong>step-by-step solutions</strong> for every problem. Solve limits using direct substitution, factoring, <strong>L'H&ocirc;pital's Rule</strong>, and the squeeze theorem. Calculate <strong>one-sided limits</strong> (left-hand and right-hand), two-sided limits, and <strong>limits at infinity</strong>. Automatically detects <strong>indeterminate forms</strong> (0/0, &infin;/&infin;). Includes interactive graph, numerical approximation table, PDF download, LaTeX export, and Python SymPy compiler. Free, instant, no signup.</p>
            </div>
        </div>
    </section>
    <main class="tool-page-container">
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <text x="1" y="17" font-size="14" font-weight="700" fill="currentColor" font-family="serif" stroke="none">lim</text>
                    </svg>
                    Limit Calculator
                </div>
                <div class="tool-card-body">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="lc-expr">Function f(x)</label>
                        <input type="text" class="tool-input tool-input-mono" id="lc-expr" placeholder="e.g. (x^2-1)/(x-1)" autocomplete="off" spellcheck="false">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Live Preview</label>
                        <div class="lc-preview" id="lc-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above&hellip;</span></div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="lc-var">Variable</label>
                        <select class="tool-select" id="lc-var">
                            <option value="x" selected>x</option><option value="y">y</option><option value="t">t</option><option value="u">u</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="lc-point">Limit Point</label>
                        <input type="text" class="tool-input tool-input-mono" id="lc-point" placeholder="e.g. 1, 0, infinity, -infinity, pi" autocomplete="off" spellcheck="false">
                        <div class="tool-form-hint">Enter a number, infinity, -infinity, pi, or e</div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Direction</label>
                        <div class="lc-dir-toggle" id="lc-dir-toggle">
                            <button type="button" class="lc-dir-btn active" data-dir="two-sided">Two-sided</button>
                            <button type="button" class="lc-dir-btn" data-dir="left">Left (x&rarr;a&supmin;)</button>
                            <button type="button" class="lc-dir-btn" data-dir="right">Right (x&rarr;a&supplus;)</button>
                        </div>
                    </div>
                    <button type="button" class="tool-action-btn" id="lc-calculate-btn">Calculate Limit</button>
                    <hr class="lc-sep">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="lc-examples" id="lc-examples">
                            <button type="button" class="lc-example-chip" data-expr="(x^2-1)/(x-1)" data-point="1" data-dir="two-sided">(x&sup2;-1)/(x-1)&rarr;1</button>
                            <button type="button" class="lc-example-chip" data-expr="sin(x)/x" data-point="0" data-dir="two-sided">sin(x)/x&rarr;0</button>
                            <button type="button" class="lc-example-chip" data-expr="(e^x-1)/x" data-point="0" data-dir="two-sided">(e^x-1)/x&rarr;0</button>
                            <button type="button" class="lc-example-chip" data-expr="(1+1/x)^x" data-point="infinity" data-dir="two-sided">(1+1/x)^x&rarr;&infin;</button>
                            <button type="button" class="lc-example-chip" data-expr="x*log(x)" data-point="0" data-dir="right">x&middot;ln(x)&rarr;0&supplus;</button>
                            <button type="button" class="lc-example-chip" data-expr="(1-cos(x))/x^2" data-point="0" data-dir="two-sided">(1-cos)/x&sup2;&rarr;0</button>
                            <button type="button" class="lc-example-chip" data-expr="(x^3-8)/(x^2-4)" data-point="2" data-dir="two-sided">(x&sup3;-8)/(x&sup2;-4)&rarr;2</button>
                            <button type="button" class="lc-example-chip" data-expr="tan(x)/x" data-point="0" data-dir="two-sided">tan(x)/x&rarr;0</button>
                        </div>
                    </div>
                    <hr class="lc-sep">
                    <div id="lc-syntax-wrap">
                        <button type="button" class="lc-syntax-toggle" id="lc-syntax-btn">Syntax Help <svg class="lc-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="lc-syntax-content" id="lc-syntax-content">
                            x^2 &rarr; x&sup2; &nbsp;&nbsp; sin(x) &nbsp;&nbsp; cos(x) &nbsp;&nbsp; tan(x)<br>
                            e^x &nbsp;&nbsp; log(x) = ln(x) &nbsp;&nbsp; sqrt(x)<br>
                            sec(x) &nbsp;&nbsp; csc(x) &nbsp;&nbsp; cot(x)<br>
                            sinh(x) &nbsp;&nbsp; cosh(x) &nbsp;&nbsp; tanh(x)<br>
                            asin(x) &nbsp;&nbsp; acos(x) &nbsp;&nbsp; atan(x)<br>
                            pi &nbsp;&nbsp; e &nbsp;&nbsp; abs(x) &nbsp;&nbsp; infinity &nbsp;&nbsp; -infinity
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="tool-output-column">
            <div class="lc-output-tabs">
                <button type="button" class="lc-output-tab active" data-panel="result">Result</button>
                <button type="button" class="lc-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="lc-output-tab" data-panel="python">Python Compiler</button>
            </div>
            <div class="lc-panel active" id="lc-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="lc-result-content">
                        <div class="tool-empty-state" id="lc-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">lim</div>
                            <h3>Enter a function and click Calculate Limit</h3>
                            <p>Supports direct substitution, factoring, L'H&ocirc;pital's Rule, and numerical approximation.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="lc-result-actions">
                        <button type="button" class="tool-action-btn" id="lc-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="lc-copy-text-btn">&#128196; Copy Text</button>
                        <button type="button" class="tool-action-btn" id="lc-share-btn">&#128279; Share</button>
                        <button type="button" class="tool-action-btn" id="lc-download-pdf-btn">&#128196; Download PDF</button>
                    </div>
                </div>
            </div>
            <div class="lc-panel" id="lc-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Interactive Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="lc-graph-container"></div>
                        <p id="lc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate a limit to see its graph.</p>
                    </div>
                </div>
            </div>
            <div class="lc-panel" id="lc-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                        <select id="lc-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="sympy-limit">SymPy Limit</option>
                            <option value="sympy-onesided">SymPy One-Sided</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="lc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>
    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="limit-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is a Limit in Calculus?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>limit in calculus</strong> describes the value a function f(x) approaches as the variable x gets closer to a specific point. The notation lim(x&rarr;a) f(x) = L means that f(x) gets arbitrarily close to L as x approaches a, even if f(a) itself is undefined. Limits are used to <strong>find the derivative of a function</strong>, define integrals, and determine continuity.</p>
            <p style="color:var(--text-secondary);margin-bottom:0;line-height:1.7;">Limits are the <strong>foundation of calculus</strong>. They define derivatives (instantaneous rates of change), integrals (accumulated quantities), and continuity. Understanding how to <strong>find the limit of a function</strong> is essential for analyzing function behavior near points of interest, including asymptotes and removable discontinuities.</p>
            <svg style="max-width:460px;width:100%;height:auto;display:block;margin:1rem auto;" viewBox="0 0 500 220" xmlns="http://www.w3.org/2000/svg">
                <defs><linearGradient id="limGrad" x1="0" y1="0" x2="1" y2="0"><stop offset="0%" stop-color="#8b5cf6" stop-opacity="0.1"/><stop offset="100%" stop-color="#8b5cf6" stop-opacity="0.05"/></linearGradient></defs>
                <line x1="50" y1="180" x2="470" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
                <line x1="50" y1="20" x2="50" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
                <path d="M60,155 C120,140 180,90 220,65" fill="none" stroke="#8b5cf6" stroke-width="2.5" stroke-linecap="round"/>
                <path d="M240,55 C280,40 340,70 400,100 C440,120 460,140 470,150" fill="none" stroke="#8b5cf6" stroke-width="2.5" stroke-linecap="round"/>
                <circle cx="230" cy="60" r="5" fill="none" stroke="#8b5cf6" stroke-width="2"/>
                <line x1="50" y1="60" x2="220" y2="60" stroke="#7c3aed" stroke-width="1" stroke-dasharray="4,4"/>
                <line x1="230" y1="60" x2="230" y2="180" stroke="#7c3aed" stroke-width="1" stroke-dasharray="3,3"/>
                <text x="225" y="198" font-size="13" fill="#7c3aed" font-weight="600" text-anchor="middle">a</text>
                <text x="35" y="64" font-size="12" fill="#7c3aed" font-weight="600" text-anchor="end">L</text>
                <path d="M160,100 L200,75" fill="none" stroke="#a78bfa" stroke-width="1.5" marker-end="url(#arrowLeft)"/>
                <path d="M300,70 L260,60" fill="none" stroke="#a78bfa" stroke-width="1.5" marker-end="url(#arrowRight)"/>
                <defs><marker id="arrowLeft" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#a78bfa"/></marker><marker id="arrowRight" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#a78bfa"/></marker></defs>
                <text x="130" y="95" font-size="11" fill="#a78bfa" font-weight="500">from left</text>
                <text x="295" y="60" font-size="11" fill="#a78bfa" font-weight="500">from right</text>
                <text x="460" y="145" font-size="12" fill="#94a3b8" font-style="italic">f(x)</text>
                <text x="480" y="185" font-size="12" fill="#94a3b8">x</text>
                <text x="40" y="25" font-size="12" fill="#94a3b8">y</text>
            </svg>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Calculate Limits Step by Step</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Follow this systematic approach to <strong>evaluate any limit</strong>. This is the exact algorithm our <strong>limit calculator</strong> uses to solve limits with steps:</p>
            <div style="display:flex;flex-direction:column;gap:0.75rem;">
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">1</span>
                    <div><strong style="color:var(--text-primary);">Try Direct Substitution</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Plug the limit point directly into the function. If f(a) is a finite number, that is your limit. Example: lim(x&rarr;3) (x&sup2;+1) = 3&sup2;+1 = 10.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">2</span>
                    <div><strong style="color:var(--text-primary);">Check for Indeterminate Forms</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">If substitution gives 0/0, &infin;/&infin;, or another indeterminate form, you need a different technique. Identify which of the seven forms you have.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">3</span>
                    <div><strong style="color:var(--text-primary);">Factor and Cancel (for 0/0)</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">For 0/0 forms with polynomials, factor the numerator and denominator. Cancel the common factor (x-a), then substitute again. Example: (x&sup2;-1)/(x-1) = (x+1)(x-1)/(x-1) = x+1, so the limit as x&rarr;1 is 2.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">4</span>
                    <div><strong style="color:var(--text-primary);">Apply L'H&ocirc;pital's Rule (for 0/0 or &infin;/&infin;)</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">If you still have 0/0 or &infin;/&infin;, differentiate the numerator and denominator separately: lim f(x)/g(x) = lim f'(x)/g'(x). Repeat if necessary (up to 3 times).</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">5</span>
                    <div><strong style="color:var(--text-primary);">Numerical Verification</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Verify by approaching from both sides numerically. For x&rarr;a, evaluate at a-0.001, a-0.0001 (left) and a+0.001, a+0.0001 (right). If both sides converge to the same value, the limit exists.</p></div>
                </div>
            </div>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">The Seven Indeterminate Forms in Calculus</h2>
            <table class="lc-rules-table">
                <thead><tr><th style="width:20%;">Form</th><th style="width:40%;">Example</th><th>Resolution Technique</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">0/0</td><td>(x&sup2;-1)/(x-1) as x&rarr;1</td><td style="font-family:var(--font-sans);">Factor, L'H&ocirc;pital, simplify</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">&infin;/&infin;</td><td>(2x+1)/(3x-1) as x&rarr;&infin;</td><td style="font-family:var(--font-sans);">Divide by highest power, L'H&ocirc;pital</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">0 &middot; &infin;</td><td>x&middot;ln(x) as x&rarr;0&supplus;</td><td style="font-family:var(--font-sans);">Rewrite as 0/0 or &infin;/&infin;</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">&infin; - &infin;</td><td>1/x - 1/sin(x) as x&rarr;0</td><td style="font-family:var(--font-sans);">Common denominator, combine</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">0&sup0;</td><td>x^x as x&rarr;0&supplus;</td><td style="font-family:var(--font-sans);">Take ln, use L'H&ocirc;pital</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">1^&infin;</td><td>(1+1/x)^x as x&rarr;&infin;</td><td style="font-family:var(--font-sans);">Take ln, use L'H&ocirc;pital</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">&infin;&sup0;</td><td>x^(1/x) as x&rarr;&infin;</td><td style="font-family:var(--font-sans);">Take ln, use L'H&ocirc;pital</td></tr>
                </tbody>
            </table>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Find the Limit of a Function</h2>
            <div class="lc-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
                <div class="lc-edu-card" style="text-align:center;border-left:3px solid #8b5cf6;">
                    <h4>Direct Substitution</h4>
                    <p>If f(a) is defined and finite, then lim(x&rarr;a) f(x) = f(a). Always try this first.</p>
                </div>
                <div class="lc-edu-card" style="text-align:center;border-left:3px solid #a78bfa;">
                    <h4>Factoring &amp; Cancellation</h4>
                    <p>For 0/0 forms, factor numerator and denominator, cancel common (x-a) factors, then substitute.</p>
                </div>
                <div class="lc-edu-card" style="text-align:center;border-left:3px solid #7c3aed;">
                    <h4>L'H&ocirc;pital's Rule</h4>
                    <p>For 0/0 or &infin;/&infin;: lim f(x)/g(x) = lim f'(x)/g'(x). Differentiate top and bottom separately.</p>
                </div>
                <div class="lc-edu-card" style="text-align:center;border-left:3px solid #6d28d9;">
                    <h4>Squeeze Theorem</h4>
                    <p>If g(x) &le; f(x) &le; h(x) and lim g = lim h = L, then lim f = L. Used for sin(x)/x = 1.</p>
                </div>
            </div>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Common Limits Every Calculus Student Should Know</h2>
            <table class="lc-rules-table">
                <thead><tr><th style="width:50%;">Limit</th><th>Value</th></tr></thead>
                <tbody>
                    <tr><td>lim(x&rarr;0) sin(x)/x</td><td>1</td></tr>
                    <tr><td>lim(x&rarr;0) (e^x - 1)/x</td><td>1</td></tr>
                    <tr><td>lim(x&rarr;0) (1 - cos(x))/x&sup2;</td><td>1/2</td></tr>
                    <tr><td>lim(x&rarr;0) tan(x)/x</td><td>1</td></tr>
                    <tr><td>lim(x&rarr;&infin;) (1 + 1/x)^x</td><td>e &asymp; 2.71828</td></tr>
                    <tr><td>lim(x&rarr;0&supplus;) x&middot;ln(x)</td><td>0</td></tr>
                    <tr><td>lim(x&rarr;&infin;) (1 + a/x)^(bx)</td><td>e^(ab)</td></tr>
                    <tr><td>lim(x&rarr;0) (a^x - 1)/x</td><td>ln(a)</td></tr>
                </tbody>
            </table>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is a limit in calculus?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">A limit describes the value a function f(x) approaches as x gets closer to a specific point. Written as lim(x&rarr;a) f(x) = L, limits are the foundation of calculus used to define derivatives, integrals, and continuity. For example, lim(x&rarr;0) sin(x)/x = 1, even though sin(0)/0 is undefined.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How to find the limit of a function step by step?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To find a limit step by step: 1) Try direct substitution by plugging in the value. 2) If you get an indeterminate form like 0/0, try factoring and canceling common factors. 3) If factoring fails, apply L'H&ocirc;pital's Rule by differentiating the numerator and denominator separately. 4) For limits at infinity, divide by the highest power of x. This calculator automates all these steps.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is L'H&ocirc;pital's Rule and when do you use it?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">L'H&ocirc;pital's Rule states that for indeterminate forms 0/0 or &infin;/&infin;, lim f(x)/g(x) = lim f'(x)/g'(x). Use it when direct substitution gives 0/0 or &infin;/&infin;. Differentiate the numerator and denominator separately (not using the quotient rule), then re-evaluate. You can apply it repeatedly if the result is still indeterminate.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What are the seven indeterminate forms?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The seven indeterminate forms are 0/0, &infin;/&infin;, 0&middot;&infin;, &infin;-&infin;, 0^0, 1^&infin;, and &infin;^0. For 0/0 and &infin;/&infin; use L'H&ocirc;pital's Rule or factoring. For 0&middot;&infin;, rewrite as a fraction. For exponential forms (0^0, 1^&infin;, &infin;^0), take the natural logarithm first, then apply L'H&ocirc;pital's Rule.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How to calculate one-sided limits?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">A one-sided limit evaluates a function as x approaches a value from only one direction. The left-hand limit (x&rarr;a&supmin;) uses values slightly less than a. The right-hand limit (x&rarr;a&supplus;) uses values slightly greater than a. A two-sided limit exists only if both one-sided limits are equal. Use the direction toggle in this calculator to choose left, right, or two-sided.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How to evaluate limits at infinity?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To evaluate limits at infinity for rational functions: divide every term by the highest power of x in the denominator. If the degree of the numerator equals the denominator, the limit is the ratio of leading coefficients. If the numerator degree is less, the limit is 0. If greater, the limit is infinity. Type &ldquo;infinity&rdquo; or &ldquo;-infinity&rdquo; as the limit point in this calculator.</div></div>
        </div>
    </section>
    <section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:1.5rem 2rem;">
            <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">&#128293; Explore More Math</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
                <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(139,92,246,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#d97706);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">d/dx</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Derivative Calculator</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Step-by-step differentiation with rule identification and interactive graphs</p></div>
                </a>
                <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(139,92,246,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#3b82f6,#2563eb);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&int;</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Integral Calculator</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Definite and indefinite integrals with step-by-step technique identification</p></div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(139,92,246,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#8b5cf6,#7c3aed);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#128202;</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Visual Math Lab</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">35 interactive visualizations for algebra, calculus, trigonometry and statistics</p></div>
                </a>
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
    <script>
    var __plotlyLoaded=false;
    function loadPlotly(cb){if(__plotlyLoaded){if(cb)cb();return;}var s=document.createElement('script');s.src='https://cdn.plot.ly/plotly-2.27.0.min.js';s.onload=function(){__plotlyLoaded=true;if(cb)cb();};document.head.appendChild(s);}
    </script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script>window.__LC_CTX='<%=request.getContextPath()%>';</script>
    <script src="<%=request.getContextPath()%>/js/limit-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
