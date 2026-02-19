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
            --tool-primary:#d97706;--tool-primary-dark:#b45309;--tool-gradient:linear-gradient(135deg,#f59e0b 0%,#d97706 100%);--tool-light:#fffbeb
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(217,119,6,0.15)}
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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(217,119,6,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Derivative Calculator with Steps | Free Derivative Solver" />
        <jsp:param name="toolDescription" value="Free derivative calculator with step-by-step solutions. Find derivatives using power, product, quotient, and chain rules. Interactive graph, LaTeX export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="derivative-calculator.jsp" />
        <jsp:param name="toolKeywords" value="derivative calculator, derivative calculator with steps, derivative calculator online free, differentiation calculator, derivative solver, how to find derivative, second derivative calculator, implicit differentiation calculator, partial derivative calculator, power rule calculator, product rule calculator, quotient rule calculator, chain rule calculator, nth derivative calculator, find derivative of a function, tangent line calculator, critical points calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step with rule identification,1st through 5th derivatives,Live KaTeX preview,Interactive Plotly graph,Critical points detection,Point evaluation f prime(a),Download PDF,Copy LaTeX,Share URL,Python SymPy compiler,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a derivative in calculus?" />
        <jsp:param name="faq1a" value="A derivative measures the instantaneous rate of change of a function. Geometrically, f'(a) equals the slope of the tangent line to y = f(x) at the point (a, f(a)). The derivative is defined as f'(x) = lim(h to 0) [f(x+h) - f(x)] / h. Derivatives are fundamental to calculus, physics, engineering, and optimization." />
        <jsp:param name="faq2q" value="How do you find the derivative of a function step by step?" />
        <jsp:param name="faq2a" value="To find a derivative step by step: (1) Identify the function type - polynomial, trigonometric, exponential, or composite. (2) Apply the matching rule - power rule for x^n, product rule for f*g, quotient rule for f/g, or chain rule for f(g(x)). (3) Simplify the result. (4) Verify by checking at specific points." />
        <jsp:param name="faq3q" value="What is the chain rule and when do you use it?" />
        <jsp:param name="faq3a" value="The chain rule states d/dx[f(g(x))] = f'(g(x)) * g'(x). Use it when differentiating composite functions - a function inside another function. For example, d/dx[sin(x^2)] = cos(x^2) * 2x. The outer function is sin and the inner function is x^2. The chain rule is the most frequently used differentiation rule in calculus." />
        <jsp:param name="faq4q" value="What is the difference between first and second derivative?" />
        <jsp:param name="faq4a" value="The first derivative f'(x) gives the rate of change and slope of the tangent line. The second derivative f''(x) measures how the rate of change itself is changing - it determines concavity. If f''(x) > 0, the graph is concave up. If f''(x) < 0, it is concave down. In physics, if f is position, f' is velocity and f'' is acceleration." />
        <jsp:param name="faq5q" value="How do you find critical points using derivatives?" />
        <jsp:param name="faq5a" value="To find critical points: (1) Compute f'(x). (2) Set f'(x) = 0 and solve for x. (3) Also check where f'(x) is undefined. These x-values are critical points. Use the second derivative test: if f''(c) > 0 the critical point is a local minimum, if f''(c) < 0 it is a local maximum, if f''(c) = 0 the test is inconclusive." />
        <jsp:param name="faq6q" value="What are the basic rules of differentiation?" />
        <jsp:param name="faq6a" value="The five basic differentiation rules are: Power Rule d/dx[x^n] = nx^(n-1), Product Rule d/dx[fg] = f'g + fg', Quotient Rule d/dx[f/g] = (f'g - fg')/g^2, Chain Rule d/dx[f(g(x))] = f'(g(x))g'(x), and Sum Rule d/dx[f+g] = f'+g'. Most derivatives can be computed by combining these rules." />
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
        .tool-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(217,119,6,0.1)}
        .tool-input-mono{font-family:var(--font-mono);font-size:0.9375rem;letter-spacing:-0.02em}
        .tool-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);cursor:pointer}
        [data-theme="dark"] .tool-input,[data-theme="dark"] .tool-select{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        [data-theme="dark"] .tool-input:focus{box-shadow:0 0 0 3px rgba(217,119,6,0.25)}
        .dc-order-toggle{display:flex;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);overflow:hidden}
        .dc-order-btn{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all 0.15s;font-family:var(--font-sans);text-align:center}
        .dc-order-btn.active{background:var(--tool-gradient);color:#fff}
        .dc-order-btn:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .dc-order-btn{background:var(--bg-tertiary)}[data-theme="dark"] .dc-order-btn.active{background:var(--tool-gradient);color:#fff}[data-theme="dark"] .dc-order-btn:hover:not(.active){background:rgba(255,255,255,0.08)}
        .dc-preview{background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);padding:0.75rem 1rem;min-height:48px;display:flex;align-items:center;justify-content:center;overflow-x:auto;font-size:1.1rem}
        .dc-preview .katex-display{margin:0}
        [data-theme="dark"] .dc-preview{background:var(--bg-tertiary);border-color:var(--border)}
        .dc-examples{display:flex;flex-wrap:wrap;gap:0.375rem}
        .dc-example-chip{padding:0.3rem 0.625rem;font-size:0.75rem;font-family:var(--font-mono);background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);cursor:pointer;transition:all 0.15s;color:var(--text-secondary);white-space:nowrap}
        .dc-example-chip:hover{background:var(--tool-primary);color:#fff;border-color:var(--tool-primary)}
        [data-theme="dark"] .dc-example-chip{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-secondary)}[data-theme="dark"] .dc-example-chip:hover{background:var(--tool-primary);color:#fff}
        .dc-syntax-toggle{display:flex;align-items:center;justify-content:space-between;cursor:pointer;padding:0.5rem 0;font-size:0.8125rem;font-weight:600;color:var(--text-secondary);border:none;background:none;width:100%;font-family:var(--font-sans)}
        .dc-syntax-content{display:none;font-size:0.75rem;font-family:var(--font-mono);color:var(--text-secondary);line-height:1.8;padding-bottom:0.5rem}
        .dc-syntax-content.open{display:block}
        .dc-syntax-chevron{transition:transform 0.2s;width:14px;height:14px;flex-shrink:0}
        .dc-output-tabs{display:flex;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);overflow:hidden}
        .dc-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all 0.15s;font-family:var(--font-sans);text-align:center}
        .dc-output-tab.active{background:var(--tool-gradient);color:#fff}
        .dc-output-tab:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .dc-output-tab{background:var(--bg-tertiary)}[data-theme="dark"] .dc-output-tab.active{background:var(--tool-gradient);color:#fff}[data-theme="dark"] .dc-output-tab:hover:not(.active){background:rgba(255,255,255,0.08)}
        .dc-panel{display:none;flex:1;min-height:0}.dc-panel.active{display:flex;flex-direction:column}
        #dc-panel-result .tool-result-card{flex:1}#dc-panel-graph{min-height:480px}#dc-panel-python{min-height:540px}
        .dc-result-math{padding:1.5rem;text-align:center;overflow-x:auto;max-width:100%}.dc-result-math .katex-display{margin:0.5rem 0;overflow-x:auto;overflow-y:hidden}
        .dc-result-label{font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted);margin-bottom:0.25rem}
        .dc-result-main{font-size:1.3rem;padding:1rem 0}
        .dc-result-numeric{background:var(--tool-gradient);color:#fff;padding:1rem;border-radius:var(--radius-md);text-align:center;font-size:1.25rem;font-weight:700;margin:0.75rem 0}
        .dc-result-detail{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:0.75rem 1rem;margin-top:0.75rem;font-size:0.8125rem;color:var(--text-secondary)}
        [data-theme="dark"] .dc-result-detail{background:var(--bg-tertiary);border-color:var(--border)}
        .dc-method-badge{display:inline-block;background:var(--tool-light);color:var(--tool-primary);padding:0.2rem 0.625rem;border-radius:9999px;font-size:0.6875rem;font-weight:600}
        .dc-intermediate{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:0.75rem 1rem;margin-top:0.5rem;text-align:center}
        .dc-intermediate-label{font-size:0.6875rem;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.04em;margin-bottom:0.25rem}
        [data-theme="dark"] .dc-intermediate{background:var(--bg-tertiary);border-color:var(--border)}
        .dc-error{background:#fef3c7;border:1px solid #fbbf24;border-radius:var(--radius-md);padding:1.25rem;color:#92400e}
        .dc-error h4{margin:0 0 0.5rem;font-size:0.9375rem;font-weight:700}
        .dc-error ul{margin:0.5rem 0 0;padding-left:1.25rem;font-size:0.8125rem;line-height:1.7}
        [data-theme="dark"] .dc-error{background:rgba(251,191,36,0.15);border-color:rgba(251,191,36,0.3);color:#fbbf24}
        #dc-graph-container{width:100%;min-height:440px;border-radius:var(--radius-md)}
        .js-plotly-plot .plotly .modebar{top:4px!important;right:4px!important}
        .dc-sep{border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.75rem 0}
        .dc-edu-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1rem;margin-top:1rem}
        .dc-edu-card{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:1.25rem}
        .dc-edu-card h4{font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem}
        .dc-edu-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        [data-theme="dark"] .dc-edu-card{background:var(--bg-tertiary);border-color:var(--border)}
        .dc-rules-table{width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem}
        .dc-rules-table th,.dc-rules-table td{padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border)}
        .dc-rules-table th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary)}
        .dc-rules-table td{color:var(--text-secondary);font-family:var(--font-mono);font-size:0.75rem}
        [data-theme="dark"] .dc-rules-table th{background:var(--bg-tertiary)}
        .dc-diagram{max-width:100%;height:auto;display:block;margin:1rem auto}
        .dc-steps-btn{display:inline-flex;align-items:center;gap:0.375rem;padding:0.5rem 1rem;font-size:0.8125rem;font-weight:600;font-family:var(--font-sans);border:1.5px solid var(--tool-primary);border-radius:var(--radius-full);background:transparent;color:var(--tool-primary);cursor:pointer;transition:all 0.15s;margin-top:0.75rem}
        .dc-steps-btn:hover{background:var(--tool-primary);color:#fff}
        .dc-steps-btn.loading{opacity:0.7;pointer-events:none}
        .dc-steps-container{margin-top:1rem;border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
        .dc-steps-header{display:flex;align-items:center;gap:0.5rem;padding:0.625rem 1rem;background:var(--tool-light);border-bottom:1px solid var(--border);font-size:0.8125rem;font-weight:600;color:var(--tool-primary)}
        .dc-step{padding:0.75rem 1rem;border-bottom:1px solid var(--border-light);display:flex;gap:0.75rem;align-items:flex-start}
        .dc-step:last-child{border-bottom:none}
        .dc-step-num{flex-shrink:0;width:24px;height:24px;border-radius:50%;background:var(--tool-gradient);color:#fff;font-size:0.6875rem;font-weight:700;display:flex;align-items:center;justify-content:center}
        .dc-step-body{flex:1;min-width:0}
        .dc-step-title{font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem}
        .dc-step-math{font-size:1rem;overflow-x:auto}.dc-step-math .katex-display{margin:0;overflow-x:auto;overflow-y:hidden}
        [data-theme="dark"] .dc-steps-container{border-color:var(--border)}[data-theme="dark"] .dc-steps-header{background:var(--tool-light);border-bottom-color:var(--border)}[data-theme="dark"] .dc-step{border-bottom-color:var(--border)}
        @keyframes dc-spin{to{transform:rotate(360deg)}}
        .dc-spinner{width:14px;height:14px;border:2px solid var(--border);border-top-color:var(--tool-primary);border-radius:50%;animation:dc-spin 0.6s linear infinite}
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
                <h1 class="tool-page-title">Derivative Calculator - Find Derivatives with Steps</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math-tools">Math Tools</a> /
                    Derivative Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">1st-5th Order</span>
                <span class="tool-badge">PDF Export</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>derivative calculator</strong> that shows <strong>step-by-step solutions</strong> with rule identification. Find first through fifth order derivatives of polynomials, trig, exponential, logarithmic, and composite functions using the power rule, product rule, quotient rule, and chain rule. Includes <strong>interactive graph</strong> with critical points, PDF download, LaTeX export, and Python compiler.</p>
            </div>
        </div>
    </section>
    <main class="tool-page-container">
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <text x="2" y="18" font-size="16" font-weight="700" fill="currentColor" font-family="serif" stroke="none">d/dx</text>
                    </svg>
                    Derivative Calculator
                </div>
                <div class="tool-card-body">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="dc-expr">Function f(x)</label>
                        <input type="text" class="tool-input tool-input-mono" id="dc-expr" placeholder="e.g. sin(3*x), x^3+2*x, e^x" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Both sin3x and sin(3*x) work</span>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Live Preview</label>
                        <div class="dc-preview" id="dc-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above&hellip;</span></div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="dc-var">Variable</label>
                        <select class="tool-select" id="dc-var">
                            <option value="x" selected>x</option><option value="y">y</option><option value="t">t</option><option value="u">u</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Derivative Order</label>
                        <div class="dc-order-toggle" id="dc-order-toggle">
                            <button type="button" class="dc-order-btn active" data-order="1">1st</button>
                            <button type="button" class="dc-order-btn" data-order="2">2nd</button>
                            <button type="button" class="dc-order-btn" data-order="3">3rd</button>
                            <button type="button" class="dc-order-btn" data-order="4">4th</button>
                            <button type="button" class="dc-order-btn" data-order="5">5th</button>
                        </div>
                    </div>
                    <div class="tool-form-group" style="padding-top:0.5rem;">
                        <label class="tool-form-label" for="dc-eval-point">Evaluate at point (optional)</label>
                        <input type="text" class="tool-input tool-input-mono" id="dc-eval-point" placeholder="e.g. 2" autocomplete="off" spellcheck="false">
                        <div class="tool-form-hint">Compute f'(a) at a specific value</div>
                    </div>
                    <button type="button" class="tool-action-btn" id="dc-differentiate-btn">Differentiate</button>
                    <hr class="dc-sep">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="dc-examples" id="dc-examples">
                            <button type="button" class="dc-example-chip" data-expr="x^3+2*x">x&sup3;+2x</button>
                            <button type="button" class="dc-example-chip" data-expr="sin(x)*cos(x)">sin&middot;cos</button>
                            <button type="button" class="dc-example-chip" data-expr="e^(x^2)">e^(x&sup2;)</button>
                            <button type="button" class="dc-example-chip" data-expr="log(x)/x">ln(x)/x</button>
                            <button type="button" class="dc-example-chip" data-expr="sqrt(x^2+1)">&radic;(x&sup2;+1)</button>
                            <button type="button" class="dc-example-chip" data-expr="tan(x)">tan(x)</button>
                            <button type="button" class="dc-example-chip" data-expr="x*e^x">x&middot;e^x</button>
                            <button type="button" class="dc-example-chip" data-expr="(x^2+1)/(x-1)">(x&sup2;+1)/(x-1)</button>
                        </div>
                    </div>
                    <hr class="dc-sep">
                    <div id="dc-syntax-wrap">
                        <button type="button" class="dc-syntax-toggle" id="dc-syntax-btn">Syntax Help <svg class="dc-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="dc-syntax-content" id="dc-syntax-content">
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
        <div class="tool-output-column">
            <div class="dc-output-tabs">
                <button type="button" class="dc-output-tab active" data-panel="result">Result</button>
                <button type="button" class="dc-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="dc-output-tab" data-panel="python">Python Compiler</button>
            </div>
            <div class="dc-panel active" id="dc-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="dc-result-content">
                        <div class="tool-empty-state" id="dc-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">d/dx</div>
                            <h3>Enter a function and click Differentiate</h3>
                            <p>Supports polynomials, trig, exponential, logarithmic, and rational functions.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="dc-result-actions">
                        <button type="button" class="tool-action-btn" id="dc-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="dc-copy-text-btn">&#128196; Copy Text</button>
                        <button type="button" class="tool-action-btn" id="dc-share-btn">&#128279; Share</button>
                        <button type="button" class="tool-action-btn" id="dc-download-pdf-btn">&#128196; Download PDF</button>
                    </div>
                </div>
            </div>
            <div class="dc-panel" id="dc-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Interactive Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="dc-graph-container"></div>
                        <p id="dc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Differentiate a function to see its graph.</p>
                    </div>
                </div>
            </div>
            <div class="dc-panel" id="dc-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                        <select id="dc-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="sympy-diff">SymPy Derivative</option>
                            <option value="sympy-nth">SymPy Nth Derivative</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="dc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>
    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="derivative-calculator.jsp"/>
        <jsp:param name="keyword" value="calculus"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is a Derivative in Calculus?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>derivative</strong> of a function f(x) measures the instantaneous rate of change of f with respect to x. Geometrically, f'(a) is the slope of the tangent line to the curve y = f(x) at the point (a, f(a)). The derivative is defined as the limit: f'(x) = lim(h&rarr;0) [f(x+h) - f(x)] / h.</p>
            <p style="color:var(--text-secondary);margin-bottom:0;line-height:1.7;">In physics, velocity is the derivative of position, and acceleration is the derivative of velocity. In economics, marginal cost is the derivative of total cost. Derivatives are fundamental to optimization, linear approximation, and modeling change.</p>
            <svg class="dc-diagram" viewBox="0 0 500 220" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
                <defs><linearGradient id="tanGrad" x1="0" y1="0" x2="1" y2="0"><stop offset="0%" stop-color="#d97706" stop-opacity="0.1"/><stop offset="100%" stop-color="#d97706" stop-opacity="0.05"/></linearGradient></defs>
                <line x1="50" y1="180" x2="470" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
                <line x1="50" y1="20" x2="50" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
                <path d="M60,160 C100,140 140,100 200,70 C260,40 320,50 380,90 C420,110 450,140 470,155" fill="none" stroke="#d97706" stroke-width="2.5" stroke-linecap="round"/>
                <line x1="130" y1="140" x2="330" y2="30" stroke="#b45309" stroke-width="1.5" stroke-dasharray="6,4"/>
                <circle cx="230" cy="57" r="5" fill="#d97706"/>
                <line x1="230" y1="57" x2="230" y2="180" stroke="#b45309" stroke-width="1" stroke-dasharray="3,3"/>
                <text x="225" y="198" font-size="13" fill="#b45309" font-weight="600" text-anchor="middle">a</text>
                <text x="340" y="35" font-size="11" fill="#b45309" font-weight="600">tangent line</text>
                <text x="310" y="50" font-size="11" fill="#b45309">slope = f'(a)</text>
                <text x="460" y="145" font-size="12" fill="#94a3b8" font-style="italic">f(x)</text>
                <text x="480" y="185" font-size="12" fill="#94a3b8">x</text>
                <text x="40" y="25" font-size="12" fill="#94a3b8">y</text>
            </svg>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Find the Derivative Step by Step</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Follow these steps to find the derivative of any function:</p>
            <ol style="color:var(--text-secondary);line-height:2;padding-left:1.25rem;margin:0;">
                <li><strong>Identify the function type</strong> &mdash; Is it a polynomial, trigonometric, exponential, logarithmic, or composite function?</li>
                <li><strong>Choose the correct differentiation rule</strong> &mdash; Power rule for x<sup>n</sup>, product rule for f&middot;g, quotient rule for f/g, chain rule for f(g(x)).</li>
                <li><strong>Apply the rule</strong> &mdash; Write out each step of the differentiation, showing the rule being used.</li>
                <li><strong>Simplify the result</strong> &mdash; Combine like terms, factor where possible, and reduce fractions.</li>
                <li><strong>Verify your answer</strong> &mdash; Check by evaluating the derivative at a specific point or using numerical approximation.</li>
            </ol>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">How to Differentiate - Rules of Differentiation</h2>
            <table class="dc-rules-table">
                <thead><tr><th style="width:35%;">Rule</th><th style="width:35%;">Formula</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Power Rule</td><td>d/dx[x^n] = n&middot;x^(n-1)</td><td>d/dx[x&sup3;] = 3x&sup2;</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Constant Multiple</td><td>d/dx[c&middot;f] = c&middot;f'</td><td>d/dx[5x&sup2;] = 10x</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Sum Rule</td><td>d/dx[f+g] = f'+g'</td><td>d/dx[x&sup2;+x] = 2x+1</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Product Rule</td><td>d/dx[f&middot;g] = f'g+fg'</td><td>d/dx[x&middot;sin(x)] = sin(x)+x&middot;cos(x)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Quotient Rule</td><td>d/dx[f/g] = (f'g-fg')/g&sup2;</td><td>d/dx[x/(x+1)]</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Chain Rule</td><td>d/dx[f(g(x))] = f'(g(x))&middot;g'(x)</td><td>d/dx[sin(x&sup2;)] = 2x&middot;cos(x&sup2;)</td></tr>
                </tbody>
            </table>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Common Derivatives Every Calculus Student Should Know</h2>
            <table class="dc-rules-table">
                <thead><tr><th style="width:40%;">Function</th><th>Derivative</th></tr></thead>
                <tbody>
                    <tr><td>sin(x)</td><td>cos(x)</td></tr>
                    <tr><td>cos(x)</td><td>-sin(x)</td></tr>
                    <tr><td>tan(x)</td><td>sec&sup2;(x)</td></tr>
                    <tr><td>e^x</td><td>e^x</td></tr>
                    <tr><td>ln(x)</td><td>1/x</td></tr>
                    <tr><td>sqrt(x)</td><td>1/(2&middot;sqrt(x))</td></tr>
                    <tr><td>arcsin(x)</td><td>1/sqrt(1-x&sup2;)</td></tr>
                    <tr><td>arccos(x)</td><td>-1/sqrt(1-x&sup2;)</td></tr>
                    <tr><td>arctan(x)</td><td>1/(1+x&sup2;)</td></tr>
                </tbody>
            </table>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Applications of Derivatives in Real Life</h2>
            <div class="dc-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
                <div class="dc-edu-card" style="text-align:center;border-left:3px solid #d97706;">
                    <h4>Velocity &amp; Acceleration</h4>
                    <p>v(t) = s'(t) gives velocity; a(t) = v'(t) gives acceleration from a position function.</p>
                </div>
                <div class="dc-edu-card" style="text-align:center;border-left:3px solid #f59e0b;">
                    <h4>Optimization</h4>
                    <p>Find maxima and minima by setting f'(x) = 0 and testing with f''(x).</p>
                </div>
                <div class="dc-edu-card" style="text-align:center;border-left:3px solid #b45309;">
                    <h4>Related Rates</h4>
                    <p>Use the chain rule to find how rates of change are related in connected quantities.</p>
                </div>
                <div class="dc-edu-card" style="text-align:center;border-left:3px solid #92400e;">
                    <h4>Linear Approximation</h4>
                    <p>f(x) &asymp; f(a) + f'(a)(x-a) approximates f near x = a using the tangent line.</p>
                </div>
            </div>
        </div>
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is a derivative in calculus?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">A derivative measures the instantaneous rate of change of a function. Geometrically, f'(a) equals the slope of the tangent line to y = f(x) at the point (a, f(a)). The derivative is defined as f'(x) = lim(h&rarr;0) [f(x+h) - f(x)] / h. Derivatives are fundamental to calculus, physics, engineering, and optimization.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you find the derivative of a function step by step?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To find a derivative step by step: (1) Identify the function type &mdash; polynomial, trigonometric, exponential, or composite. (2) Apply the matching rule &mdash; power rule for x^n, product rule for f&middot;g, quotient rule for f/g, or chain rule for f(g(x)). (3) Simplify the result. (4) Verify by checking at specific points.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the chain rule and when do you use it?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The chain rule states d/dx[f(g(x))] = f'(g(x)) &middot; g'(x). Use it when differentiating composite functions &mdash; a function inside another function. For example, d/dx[sin(x&sup2;)] = cos(x&sup2;) &middot; 2x. The outer function is sin and the inner function is x&sup2;. The chain rule is the most frequently used differentiation rule in calculus.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the difference between first and second derivative?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The first derivative f'(x) gives the rate of change and slope of the tangent line. The second derivative f''(x) measures how the rate of change itself is changing &mdash; it determines concavity. If f''(x) &gt; 0, the graph is concave up. If f''(x) &lt; 0, it is concave down. In physics, if f is position, f' is velocity and f'' is acceleration.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you find critical points using derivatives?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To find critical points: (1) Compute f'(x). (2) Set f'(x) = 0 and solve for x. (3) Also check where f'(x) is undefined. These x-values are critical points. Use the second derivative test: if f''(c) &gt; 0 the critical point is a local minimum, if f''(c) &lt; 0 it is a local maximum, if f''(c) = 0 the test is inconclusive.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What are the basic rules of differentiation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The five basic differentiation rules are: Power Rule d/dx[x^n] = nx^(n-1), Product Rule d/dx[fg] = f'g + fg', Quotient Rule d/dx[f/g] = (f'g - fg')/g&sup2;, Chain Rule d/dx[f(g(x))] = f'(g(x))g'(x), and Sum Rule d/dx[f+g] = f'+g'. Most derivatives can be computed by combining these rules.</div></div>
        </div>
    </section>
    <section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:1.5rem 2rem;">
            <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">&#128293; Explore More Math</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
                <a href="<%=request.getContextPath()%>/exams/quick-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(217,119,6,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#d97706);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#9889;</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quick Math</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">150+ mental math tricks and Vedic math shortcuts for speed calculation</p></div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(217,119,6,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#8b5cf6,#7c3aed);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#128202;</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Visual Math Lab</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">35 interactive visualizations for algebra, calculus, trigonometry and statistics</p></div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/math-memory/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(217,119,6,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#10b981,#059669);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#129504;</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Math Memory Games</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">16 free brain training games to improve memory and mental calculation</p></div>
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
    <script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/derivative-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script>
    var __plotlyLoaded=false;
    function loadPlotly(cb){if(__plotlyLoaded){if(cb)cb();return;}var s=document.createElement('script');s.src='https://cdn.plot.ly/plotly-2.27.0.min.js';s.onload=function(){__plotlyLoaded=true;if(cb)cb();};document.head.appendChild(s);}
    </script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script>
    (function(){
    'use strict';
    var normalizeExpr=(typeof DerivativeCalculatorCore!=='undefined'&&DerivativeCalculatorCore.normalizeExpr)?DerivativeCalculatorCore.normalizeExpr:function(e){return(e&&e.trim)?e.trim():'';};
    var exprInput=document.getElementById('dc-expr');
    var previewEl=document.getElementById('dc-preview');
    var varSelect=document.getElementById('dc-var');
    var evalPointInput=document.getElementById('dc-eval-point');
    var diffBtn=document.getElementById('dc-differentiate-btn');
    var resultContent=document.getElementById('dc-result-content');
    var resultActions=document.getElementById('dc-result-actions');
    var emptyState=document.getElementById('dc-empty-state');
    var graphHint=document.getElementById('dc-graph-hint');
    var currentOrder=1;
    var lastResultLatex='';
    var lastResultText='';
    var compilerLoaded=false;
    var pendingGraph=null;
    var lastDiffContext=null;

    window.toggleFaq=function(btn){btn.parentElement.classList.toggle('open');};

    // Order toggle
    var orderBtns=document.querySelectorAll('.dc-order-btn');
    orderBtns.forEach(function(btn){
        btn.addEventListener('click',function(){
            var order=parseInt(this.getAttribute('data-order'));
            if(order===currentOrder)return;
            currentOrder=order;
            orderBtns.forEach(function(b){b.classList.remove('active');});
            this.classList.add('active');
            updatePreview();
        });
    });

    // Output tabs
    var tabBtns=document.querySelectorAll('.dc-output-tab');
    var panels=document.querySelectorAll('.dc-panel');
    tabBtns.forEach(function(btn){
        btn.addEventListener('click',function(){
            var panel=this.getAttribute('data-panel');
            tabBtns.forEach(function(b){b.classList.remove('active');});
            panels.forEach(function(p){p.classList.remove('active');});
            this.classList.add('active');
            document.getElementById('dc-panel-'+panel).classList.add('active');
            if(panel==='graph'&&pendingGraph){loadPlotly(function(){renderGraph(pendingGraph);});}
            if(panel==='python'&&!compilerLoaded){loadCompilerWithTemplate();compilerLoaded=true;}
        });
    });

    // Syntax help
    var syntaxBtn=document.getElementById('dc-syntax-btn');
    var syntaxContent=document.getElementById('dc-syntax-content');
    syntaxBtn.addEventListener('click',function(){
        syntaxContent.classList.toggle('open');
        var chev=syntaxBtn.querySelector('.dc-syntax-chevron');
        chev.style.transform=syntaxContent.classList.contains('open')?'rotate(180deg)':'';
    });

    // Quick examples
    document.getElementById('dc-examples').addEventListener('click',function(e){
        var chip=e.target.closest('.dc-example-chip');
        if(!chip)return;
        exprInput.value=chip.getAttribute('data-expr');
        updatePreview();
        exprInput.focus();
    });

    // Live preview
    var previewTimer=null;
    exprInput.addEventListener('input',function(){clearTimeout(previewTimer);previewTimer=setTimeout(updatePreview,200);});
    varSelect.addEventListener('change',updatePreview);

    function updatePreview(){
        var raw=exprInput.value.trim();
        var v=varSelect.value;
        if(!raw){previewEl.innerHTML='<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above\u2026</span>';return;}
        try{
            var expr=normalizeExpr(raw);
            var latex=exprToLatex(expr);
            var derivLatex;
            if(currentOrder===1){derivLatex='\\frac{d}{d'+v+'}\\left['+latex+'\\right]';}
            else{derivLatex='\\frac{d^{'+currentOrder+'}}{d'+v+'^{'+currentOrder+'}}\\left['+latex+'\\right]';}
            katex.render(derivLatex,previewEl,{displayMode:true,throwOnError:false});
        }catch(e){
            previewEl.innerHTML='<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    function exprToLatex(expr){
        try{return nerdamer(expr).toTeX();}catch(e){
            return expr.replace(/\*/g,' \\cdot ').replace(/sqrt\(/g,'\\sqrt{').replace(/\)/g,'}').replace(/\^(\w)/g,'^{$1}');
        }
    }

    // Differentiation
    diffBtn.addEventListener('click',doDifferentiate);
    exprInput.addEventListener('keydown',function(e){if(e.key==='Enter')doDifferentiate();});

    function doDifferentiate(){
        var raw=exprInput.value.trim();
        var v=varSelect.value;
        if(!raw){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Please enter a function.',2000,'warning');return;}
        try{
            var expr=normalizeExpr(raw);
            var intermediates=[];
            var current=expr;
            for(var i=0;i<currentOrder;i++){
                var result=nerdamer('diff('+current+','+v+')');
                intermediates.push({order:i+1,tex:result.toTeX(),text:result.text()});
                current=result.text();
            }
            var finalResult=intermediates[intermediates.length-1];
            var method=identifyDiffMethod(expr);
            var evalResult=null;
            var evalPt=evalPointInput.value.trim();
            if(evalPt){
                try{
                    var scope={};scope[v]=parseFloat(evalPt);
                    var numVal=parseFloat(nerdamer(finalResult.text).evaluate(scope).text('decimals'));
                    if(isFinite(numVal))evalResult={point:evalPt,value:numVal};
                }catch(ex){}
            }
            showResult(expr,v,intermediates,method,evalResult);
            prepareGraph(expr,v,finalResult.text,evalPt,evalResult);
            resultActions.classList.add('visible');
            if(emptyState)emptyState.style.display='none';
        }catch(err){
            showError(raw,err.message);
        }
    }

    function identifyDiffMethod(expr){
        var e=expr.trim();
        // Check for quotient (f/g at top level)
        if(hasTopLevelDiv(e))return 'Quotient Rule';
        // Check for product (f*g at top level)
        if(hasTopLevelMul(e))return 'Product Rule';
        // Check for composition (function of function)
        if(/\w+\([^)]*[a-z]\^|[a-z]\*/.test(e))return 'Chain Rule';
        if(/(sin|cos|tan|sec|csc|cot)\(/.test(e))return 'Trigonometric';
        if(/e\^|exp\(/.test(e))return 'Exponential';
        if(/log\(|ln\(/.test(e))return 'Logarithmic';
        if(/sqrt\(/.test(e))return 'Chain Rule';
        if(/^\s*[\d.]*\*?[a-z]\^[\d]+/.test(e)||/^\s*[a-z]\^/.test(e))return 'Power Rule';
        if(/^[\d.]+$/.test(e))return 'Constant';
        return 'Symbolic Differentiation';
    }

    function hasTopLevelDiv(expr){
        var depth=0;
        for(var i=0;i<expr.length;i++){
            if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
            if(depth===0&&expr[i]==='/'&&i>0&&i<expr.length-1)return true;
        }
        return false;
    }
    function hasTopLevelMul(expr){
        var depth=0;
        for(var i=0;i<expr.length;i++){
            if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
            if(depth===0&&expr[i]==='*'&&i>0&&i<expr.length-1)return true;
        }
        return false;
    }

    function orderLabel(n){
        var primes='';for(var i=0;i<n&&i<3;i++)primes+="'";
        if(n>3)return 'f^{('+n+')}';
        return "f"+primes;
    }
    function orderLabelText(n){
        if(n===1)return "f'";if(n===2)return "f''";if(n===3)return "f'''";
        return 'f^('+n+')';
    }

    function showResult(expr,v,intermediates,method,evalResult){
        var exprTeX=exprToLatex(expr);
        var finalR=intermediates[intermediates.length-1];
        lastResultLatex=finalR.tex;
        lastResultText=finalR.text;
        lastDiffContext={expr:expr,v:v,intermediates:intermediates,method:method,evalResult:evalResult,order:currentOrder};

        var html='<div class="dc-result-math">';
        html+='<div class="dc-result-label">Function</div>';
        html+='<div id="dc-r-fn"></div>';
        html+='<div class="dc-result-label" style="margin-top:1rem;">'+orderLabelText(currentOrder)+'('+v+') =</div>';
        html+='<div class="dc-result-main" id="dc-r-result"></div>';
        html+='<div class="dc-result-detail"><span class="dc-method-badge">'+escapeHtml(method)+'</span></div>';

        // Intermediate derivatives for order > 1
        if(currentOrder>1){
            html+='<div style="margin-top:1rem;">';
            html+='<div class="dc-result-label">Intermediate Derivatives</div>';
            for(var i=0;i<intermediates.length-1;i++){
                html+='<div class="dc-intermediate"><div class="dc-intermediate-label">'+orderLabelText(intermediates[i].order)+'('+v+')</div>';
                html+='<div id="dc-r-inter-'+i+'"></div></div>';
            }
            html+='</div>';
        }

        // Point evaluation
        if(evalResult){
            html+='<div class="dc-result-numeric">'+orderLabelText(currentOrder)+'('+escapeHtml(evalResult.point)+') = '+evalResult.value.toFixed(6)+'</div>';
        }

        html+='<button type="button" class="dc-steps-btn" id="dc-steps-btn" onclick="showSteps()">&#128221; Show Steps</button>';
        html+='<div id="dc-steps-area"></div>';
        html+='</div>';
        resultContent.innerHTML=html;

        // Render KaTeX
        var derivNotation=currentOrder===1?'\\frac{d}{d'+v+'}':'\\frac{d^{'+currentOrder+'}}{d'+v+'^{'+currentOrder+'}}';
        katex.render('f('+v+') = '+exprTeX,document.getElementById('dc-r-fn'),{displayMode:true,throwOnError:false});
        katex.render(finalR.tex,document.getElementById('dc-r-result'),{displayMode:true,throwOnError:false});
        if(currentOrder>1){
            for(var j=0;j<intermediates.length-1;j++){
                var el=document.getElementById('dc-r-inter-'+j);
                if(el)katex.render(intermediates[j].tex,el,{displayMode:true,throwOnError:false});
            }
        }
    }

    function showError(expr,msg){
        resultActions.classList.remove('visible');
        var html='<div class="dc-error"><h4>Could Not Differentiate</h4>';
        html+='<p>The expression <strong>'+escapeHtml(expr)+'</strong> could not be differentiated.'+(msg?' ('+escapeHtml(msg)+')':'')+'</p>';
        html+='<ul><li>Check syntax (see Syntax Help)</li><li>Simplify the expression</li><li>Ensure parentheses are balanced</li></ul></div>';
        resultContent.innerHTML=html;
        if(emptyState)emptyState.style.display='none';
    }

    // Step-by-step
    window.showSteps=function(){
        if(!lastDiffContext)return;
        var ctx=lastDiffContext;
        var stepsBtn=document.getElementById('dc-steps-btn');
        var steps=generateDiffSteps(ctx.expr,ctx.v,ctx.intermediates[0].tex,ctx.method);
        if(steps&&steps.length>0){
            renderSteps(steps,ctx.method);
            if(stepsBtn)stepsBtn.style.display='none';
            return;
        }
        // AI fallback
        if(stepsBtn){stepsBtn.classList.add('loading');stepsBtn.innerHTML='<span class="dc-spinner"></span> Generating steps\u2026';}
        var payload={operation:'differentiate',expression:ctx.expr,variable:ctx.v,answer:ctx.intermediates[0].text};
        fetch('<%=request.getContextPath()%>/CFExamMarkerFunctionality?action=math_steps',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)})
        .then(function(r){return r.json();})
        .then(function(data){
            if(data.success&&data.steps&&data.steps.length>0){renderSteps(data.steps,data.method||ctx.method);}
            else{renderStepsError(data.error||'Could not generate steps');}
            if(stepsBtn)stepsBtn.style.display='none';
        })
        .catch(function(){
            renderStepsError('Network error. Please try again.');
            if(stepsBtn){stepsBtn.classList.remove('loading');stepsBtn.innerHTML='\u{1F4DD} Show Steps';}
        });
    };

    function generateDiffSteps(expr,v,resultTeX,method){
        var steps=[];var e=expr.trim();
        // Power rule: x^n or c*x^n
        var pwrMatch=e.match(/^(\d+\*?)?([a-z])\^(\d+)$/);
        if(pwrMatch){
            var c=pwrMatch[1]?parseInt(pwrMatch[1]):1;var n=parseInt(pwrMatch[3]);var nm1=n-1;
            steps.push({title:'Apply Power Rule: d/d'+v+'['+v+'^n] = n'+v+'^(n-1)',latex:'\\frac{d}{d'+v+'}\\left['+(c>1?c:'')+ v+'^{'+n+'}\\right] = '+(c>1?c+'\\cdot ':'')+n+v+'^{'+(nm1)+'}'});
            if(c>1){steps.push({title:'Simplify coefficient',latex:'= '+(c*n)+v+'^{'+(nm1)+'}'});}
            return steps;
        }
        // Basic known derivatives
        var normalized=e.replace(new RegExp(v,'g'),'x');
        var basicDerivs={'sin(x)':[{title:'Standard trigonometric derivative',latex:'\\frac{d}{d'+v+'}[\\sin('+v+')] = \\cos('+v+')'}],
            'cos(x)':[{title:'Standard trigonometric derivative',latex:'\\frac{d}{d'+v+'}[\\cos('+v+')] = -\\sin('+v+')'}],
            'tan(x)':[{title:'Standard trigonometric derivative',latex:'\\frac{d}{d'+v+'}[\\tan('+v+')] = \\sec^2('+v+')'}],
            'e^x':[{title:'Exponential rule',latex:'\\frac{d}{d'+v+'}[e^{'+v+'}] = e^{'+v+'}'}],
            'log(x)':[{title:'Logarithmic rule',latex:'\\frac{d}{d'+v+'}[\\ln('+v+')] = \\frac{1}{'+v+'}'}],
            '1/x':[{title:'Power rule with n=-1',latex:'\\frac{d}{d'+v+'}['+v+'^{-1}] = -'+v+'^{-2} = -\\frac{1}{'+v+'^2}'}]};
        if(basicDerivs[normalized])return basicDerivs[normalized];

        // Sum/difference: split terms
        var terms=splitTerms(e);
        if(terms&&terms.length>1){
            steps.push({title:'Apply Sum Rule: d/d'+v+'[f+g] = f\'+g\'',latex:'\\frac{d}{d'+v+'}\\left['+exprToLatex(e)+'\\right] = '+terms.map(function(t){return '\\frac{d}{d'+v+'}\\left['+exprToLatex(t.trim())+'\\right]';}).join(' + ')});
            var allOk=true;var partResults=[];
            for(var i=0;i<terms.length;i++){
                try{var r=nerdamer('diff('+terms[i]+','+v+')');partResults.push(r.toTeX());}
                catch(ex){allOk=false;break;}
            }
            if(allOk&&partResults.length===terms.length){
                for(var j=0;j<terms.length;j++){
                    steps.push({title:'Differentiate term '+(j+1),latex:'\\frac{d}{d'+v+'}\\left['+exprToLatex(terms[j].trim())+'\\right] = '+partResults[j]});
                }
                steps.push({title:'Combine',latex:'= '+resultTeX});
                return steps;
            }
        }

        // Constant multiple: c*f(x)
        var constMatch=e.match(/^(\d+)\*(.+)$/);
        if(constMatch){
            var cc=constMatch[1];var inner=constMatch[2];
            steps.push({title:'Factor out constant',latex:'\\frac{d}{d'+v+'}\\left['+cc+'\\cdot '+exprToLatex(inner)+'\\right] = '+cc+'\\cdot \\frac{d}{d'+v+'}\\left['+exprToLatex(inner)+'\\right]'});
            try{var innerR=nerdamer('diff('+inner+','+v+')');
                steps.push({title:'Differentiate inner function',latex:'= '+cc+' \\cdot \\left('+innerR.toTeX()+'\\right)'});
                steps.push({title:'Simplify',latex:'= '+resultTeX});
                return steps;
            }catch(ex){}
        }

        // Product rule: f*g at top level
        if(hasTopLevelMul(e)){
            var mulParts=splitAtTopLevel(e,'*');
            if(mulParts&&mulParts.length===2){
                var fTex=exprToLatex(mulParts[0]);var gTex=exprToLatex(mulParts[1]);
                steps.push({title:'Apply Product Rule: (fg)\' = f\'g + fg\'',latex:'\\frac{d}{d'+v+'}\\left['+fTex+'\\cdot '+gTex+'\\right]'});
                try{
                    var fp=nerdamer('diff('+mulParts[0]+','+v+')');var gp=nerdamer('diff('+mulParts[1]+','+v+')');
                    steps.push({title:'Find f\'('+v+') and g\'('+v+')',latex:"f'="+fp.toTeX()+",\\quad g'="+gp.toTeX()});
                    steps.push({title:'Apply formula',latex:'= '+fp.toTeX()+'\\cdot '+gTex+' + '+fTex+'\\cdot '+gp.toTeX()});
                    steps.push({title:'Simplify',latex:'= '+resultTeX});
                    return steps;
                }catch(ex){}
            }
        }

        // Quotient rule: f/g at top level
        if(hasTopLevelDiv(e)){
            var divParts=splitAtTopLevel(e,'/');
            if(divParts&&divParts.length===2){
                var fTex2=exprToLatex(divParts[0]);var gTex2=exprToLatex(divParts[1]);
                steps.push({title:'Apply Quotient Rule: (f/g)\' = (f\'g - fg\')/g\u00B2',latex:'\\frac{d}{d'+v+'}\\left[\\frac{'+fTex2+'}{'+gTex2+'}\\right]'});
                try{
                    var fp2=nerdamer('diff('+divParts[0]+','+v+')');var gp2=nerdamer('diff('+divParts[1]+','+v+')');
                    steps.push({title:'Find f\'('+v+') and g\'('+v+')',latex:"f'="+fp2.toTeX()+",\\quad g'="+gp2.toTeX()});
                    steps.push({title:'Apply formula',latex:'= \\frac{'+fp2.toTeX()+'\\cdot '+gTex2+' - '+fTex2+'\\cdot '+gp2.toTeX()+'}{\\left('+gTex2+'\\right)^2}'});
                    steps.push({title:'Simplify',latex:'= '+resultTeX});
                    return steps;
                }catch(ex){}
            }
        }

        // Chain rule: f(g(x)) where f is a known outer function
        var chainPatterns=[
            {re:/^sin\((.+)\)$/,name:'sin',outerDeriv:'\\cos',outerDerivText:'cos'},
            {re:/^cos\((.+)\)$/,name:'cos',outerDeriv:'-\\sin',outerDerivText:'-sin'},
            {re:/^tan\((.+)\)$/,name:'tan',outerDeriv:'\\sec^2',outerDerivText:'sec^2'},
            {re:/^log\((.+)\)$/,name:'ln',outerDeriv:'\\frac{1}{\\Box}',outerDerivText:'1/u'},
            {re:/^sqrt\((.+)\)$/,name:'sqrt',outerDeriv:'\\frac{1}{2\\sqrt{\\Box}}',outerDerivText:'1/(2*sqrt(u))'},
            {re:/^asin\((.+)\)$/,name:'arcsin',outerDeriv:'\\frac{1}{\\sqrt{1-\\Box^2}}',outerDerivText:'1/sqrt(1-u^2)'},
            {re:/^acos\((.+)\)$/,name:'arccos',outerDeriv:'\\frac{-1}{\\sqrt{1-\\Box^2}}',outerDerivText:'-1/sqrt(1-u^2)'},
            {re:/^atan\((.+)\)$/,name:'arctan',outerDeriv:'\\frac{1}{1+\\Box^2}',outerDerivText:'1/(1+u^2)'},
            {re:/^sinh\((.+)\)$/,name:'sinh',outerDeriv:'\\cosh',outerDerivText:'cosh'},
            {re:/^cosh\((.+)\)$/,name:'cosh',outerDeriv:'\\sinh',outerDerivText:'sinh'},
            {re:/^tanh\((.+)\)$/,name:'tanh',outerDeriv:'\\text{sech}^2',outerDerivText:'sech^2'}
        ];
        for(var ci=0;ci<chainPatterns.length;ci++){
            var cp=chainPatterns[ci];var cm=e.match(cp.re);
            if(cm){
                var innerExpr=cm[1];
                // Only apply chain rule if inner is not just the variable
                var innerNorm=innerExpr.replace(new RegExp(v,'g'),'x');
                if(innerNorm!=='x'){
                    var innerTeX=exprToLatex(innerExpr);
                    try{
                        var gPrime=nerdamer('diff('+innerExpr+','+v+')');var gPrimeTex=gPrime.toTeX();
                        steps.push({title:'Identify composite function (Chain Rule)',latex:'\\text{Let } u = '+innerTeX+', \\quad \\text{outer function } f(u) = \\'+cp.name+'(u)'});
                        var outerStep=cp.outerDeriv.replace(/\\Box/g,innerTeX);
                        steps.push({title:"Outer derivative: f'(u)",latex:"f'(u) = "+outerStep});
                        steps.push({title:"Inner derivative: g'("+v+')',latex:"g'("+v+') = '+gPrimeTex});
                        steps.push({title:'Apply Chain Rule: f\'(g('+v+')) \\cdot g\'('+v+')',latex:'= '+outerStep+' \\cdot '+gPrimeTex});
                        steps.push({title:'Simplify',latex:'= '+resultTeX});
                        return steps;
                    }catch(ex){}
                }
            }
        }
        // Chain rule for e^(g(x))
        var expMatch=e.match(/^e\^\((.+)\)$/);
        if(expMatch){
            var innerExp=expMatch[1];var innerExpNorm=innerExp.replace(new RegExp(v,'g'),'x');
            if(innerExpNorm!=='x'){
                var innerExpTeX=exprToLatex(innerExp);
                try{
                    var gPrimeExp=nerdamer('diff('+innerExp+','+v+')');var gPrimeExpTex=gPrimeExp.toTeX();
                    steps.push({title:'Identify composite function (Chain Rule)',latex:'\\text{Let } u = '+innerExpTeX+', \\quad f(u) = e^u'});
                    steps.push({title:"Outer derivative: f'(u) = e^u",latex:"f'(u) = e^{"+innerExpTeX+'}'});
                    steps.push({title:"Inner derivative: g'("+v+')',latex:"g'("+v+') = '+gPrimeExpTex});
                    steps.push({title:'Apply Chain Rule',latex:'= e^{'+innerExpTeX+'} \\cdot '+gPrimeExpTex});
                    steps.push({title:'Simplify',latex:'= '+resultTeX});
                    return steps;
                }catch(ex){}
            }
        }
        // Chain rule for (g(x))^n  e.g. (x^2+1)^3
        var powCompMatch=e.match(/^\((.+)\)\^(\d+)$/);
        if(powCompMatch){
            var innerPow=powCompMatch[1];var nPow=parseInt(powCompMatch[2]);
            var innerPowTeX=exprToLatex(innerPow);
            try{
                var gPrimePow=nerdamer('diff('+innerPow+','+v+')');var gPrimePowTex=gPrimePow.toTeX();
                steps.push({title:'Identify composite function (Chain Rule + Power Rule)',latex:'\\text{Let } u = '+innerPowTeX+', \\quad f(u) = u^{'+nPow+'}'});
                steps.push({title:"Outer derivative (Power Rule): f'(u) = "+nPow+'u^{'+(nPow-1)+'}',latex:"f'(u) = "+nPow+'\\left('+innerPowTeX+'\\right)^{'+(nPow-1)+'}'});
                steps.push({title:"Inner derivative: g'("+v+')',latex:"g'("+v+') = '+gPrimePowTex});
                steps.push({title:'Apply Chain Rule',latex:'= '+nPow+'\\left('+innerPowTeX+'\\right)^{'+(nPow-1)+'} \\cdot '+gPrimePowTex});
                steps.push({title:'Simplify',latex:'= '+resultTeX});
                return steps;
            }catch(ex){}
        }

        return null;
    }

    function splitTerms(expr){
        var terms=[];var depth=0;var current='';
        for(var i=0;i<expr.length;i++){
            var ch=expr[i];
            if(ch==='('||ch==='[')depth++;else if(ch===')'||ch===']')depth--;
            if(depth===0&&(ch==='+'||(ch==='-'&&i>0&&current.trim()))){terms.push(current.trim());current=ch==='-'?'-':'';
            }else{current+=ch;}
        }
        if(current.trim())terms.push(current.trim());
        return terms.length>1?terms:null;
    }

    function splitAtTopLevel(expr,op){
        var depth=0;
        for(var i=0;i<expr.length;i++){
            if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
            if(depth===0&&expr[i]===op&&i>0&&i<expr.length-1){
                return[expr.substring(0,i),expr.substring(i+1)];
            }
        }
        return null;
    }

    function renderSteps(steps,method){
        var container=document.getElementById('dc-steps-area');
        if(!container)return;
        var html='<div class="dc-steps-container"><div class="dc-steps-header">';
        html+='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html+='Solution Steps</div>';
        for(var i=0;i<steps.length;i++){
            html+='<div class="dc-step"><span class="dc-step-num">'+(i+1)+'</span><div class="dc-step-body">';
            html+='<div class="dc-step-title">'+escapeHtml(steps[i].title)+'</div>';
            html+='<div class="dc-step-math" id="dc-step-math-'+i+'"></div></div></div>';
        }
        html+='</div>';container.innerHTML=html;
        for(var j=0;j<steps.length;j++){
            var el=document.getElementById('dc-step-math-'+j);
            if(el&&steps[j].latex){try{katex.render(steps[j].latex,el,{displayMode:true,throwOnError:false});}catch(e2){el.textContent=steps[j].latex;}}
        }
    }

    function renderStepsError(msg){
        var container=document.getElementById('dc-steps-area');
        if(!container)return;
        container.innerHTML='<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">'+escapeHtml(msg)+'</div>';
    }

    // Graph
    function prepareGraph(exprStr,v,derivStr,evalPt,evalResult){
        pendingGraph={expr:exprStr,v:v,deriv:derivStr,evalPt:evalPt,evalResult:evalResult};
        if(graphHint)graphHint.style.display='none';
        var graphPanel=document.getElementById('dc-panel-graph');
        if(graphPanel.classList.contains('active')){loadPlotly(function(){renderGraph(pendingGraph);});}
    }

    function renderGraph(cfg){
        if(!window.Plotly)return;
        var container=document.getElementById('dc-graph-container');
        var xMin=-10,xMax=10,n=500;
        var xs=[],ysFx=[],ysDeriv=[];
        var step=(xMax-xMin)/n;
        for(var i=0;i<=n;i++){
            var xVal=xMin+i*step;xs.push(xVal);
            ysFx.push(evalAtPoint(cfg.expr,cfg.v,xVal));
            ysDeriv.push(evalAtPoint(cfg.deriv,cfg.v,xVal));
        }
        var traces=[];
        traces.push({x:xs,y:ysFx,type:'scatter',mode:'lines',name:'f('+cfg.v+')',line:{color:'#d97706',width:2.5}});
        traces.push({x:xs,y:ysDeriv,type:'scatter',mode:'lines',name:"f'("+cfg.v+')',line:{color:'#b45309',width:2,dash:'dash'}});

        // Critical points where f'(x) = 0
        var critX=[],critY=[];
        for(var j=1;j<ysDeriv.length-1;j++){
            if(ysDeriv[j]!==null&&ysDeriv[j-1]!==null&&ysDeriv[j+1]!==null){
                if((ysDeriv[j-1]>0&&ysDeriv[j+1]<0)||(ysDeriv[j-1]<0&&ysDeriv[j+1]>0)){
                    critX.push(xs[j]);critY.push(ysFx[j]);
                }
            }
        }
        if(critX.length>0){
            traces.push({x:critX,y:critY,type:'scatter',mode:'markers',name:'Critical Points',marker:{color:'#ef4444',symbol:'diamond',size:10}});
        }

        // Tangent line at evaluated point
        if(cfg.evalResult&&cfg.evalPt){
            var a=parseFloat(cfg.evalPt);
            var fa=evalAtPoint(cfg.expr,cfg.v,a);
            var slope=cfg.evalResult.value;
            if(isFinite(fa)&&isFinite(slope)){
                var tanXs=[a-3,a+3];
                var tanYs=[fa+slope*(-3),fa+slope*(3)];
                traces.push({x:tanXs,y:tanYs,type:'scatter',mode:'lines',name:'Tangent at '+cfg.evalPt,line:{color:'#3b82f6',width:1.5,dash:'dot'}});
                traces.push({x:[a],y:[fa],type:'scatter',mode:'markers',name:'Point ('+cfg.evalPt+', '+fa.toFixed(2)+')',marker:{color:'#3b82f6',size:8}});
            }
        }

        var isDark=document.documentElement.getAttribute('data-theme')==='dark';
        var layout={
            margin:{t:30,r:20,b:40,l:50},
            xaxis:{title:cfg.v,gridcolor:isDark?'#334155':'#e2e8f0',zerolinecolor:isDark?'#475569':'#cbd5e1',color:isDark?'#cbd5e1':'#475569'},
            yaxis:{gridcolor:isDark?'#334155':'#e2e8f0',zerolinecolor:isDark?'#475569':'#cbd5e1',color:isDark?'#cbd5e1':'#475569'},
            paper_bgcolor:isDark?'#1e293b':'#fff',plot_bgcolor:isDark?'#1e293b':'#fff',
            font:{family:'Inter, sans-serif',size:12,color:isDark?'#cbd5e1':'#475569'},
            legend:{x:0,y:1.12,orientation:'h',font:{size:11}},showlegend:true
        };
        Plotly.newPlot(container,traces,layout,{responsive:true,displayModeBar:true,modeBarButtonsToRemove:['lasso2d','select2d']});
    }

    function evalAtPoint(exprStr,v,xVal){
        try{var scope={};scope[v]=xVal;var val=parseFloat(nerdamer(exprStr).evaluate(scope).text('decimals'));
            if(!isFinite(val)||Math.abs(val)>1e6)return null;return val;}catch(e){return null;}
    }

    // Python compiler
    function nerdamerToPython(expr){
        return expr.replace(/e\^(\([^)]+\))/g,'exp$1').replace(/e\^([a-zA-Z0-9_]+)/g,'exp($1)').replace(/\^/g,'**');
    }

    function buildCompilerCode(template){
        var expr=exprInput.value.trim()||'x**3';
        var pyExpr=nerdamerToPython(expr);var v=varSelect.value;
        if(template==='sympy-diff'){
            return 'from sympy import *\n\n'+v+' = symbols(\''+v+'\')\nexpr = '+pyExpr+'\n\nresult = diff(expr, '+v+')\nprint("Derivative:")\npprint(result)\nprint("\\nLaTeX:", latex(result))';
        }else{
            return 'from sympy import *\n\n'+v+' = symbols(\''+v+'\')\nexpr = '+pyExpr+'\nn = '+currentOrder+'\n\nresult = diff(expr, '+v+', n)\nprint(f"Derivative of order {n}:")\npprint(result)\nprint("\\nLaTeX:", latex(result))';
        }
    }

    function loadCompilerWithTemplate(){
        var template=document.getElementById('dc-compiler-template').value;
        var code=buildCompilerCode(template);
        var b64Code=btoa(unescape(encodeURIComponent(code)));
        var config=JSON.stringify({lang:'python',code:b64Code});
        document.getElementById('dc-compiler-iframe').src='<%=request.getContextPath()%>/onecompiler-embed.jsp?c='+encodeURIComponent(config);
    }
    document.getElementById('dc-compiler-template').addEventListener('change',function(){loadCompilerWithTemplate();});

    // Copy / Share
    document.getElementById('dc-copy-latex-btn').addEventListener('click',function(){
        if(typeof ToolUtils!=='undefined'){ToolUtils.copyToClipboard(lastResultLatex,'LaTeX copied!');}
        else{navigator.clipboard.writeText(lastResultLatex);}
    });
    document.getElementById('dc-copy-text-btn').addEventListener('click',function(){
        if(typeof ToolUtils!=='undefined'){ToolUtils.copyToClipboard(lastResultText,'Result copied!');}
        else{navigator.clipboard.writeText(lastResultText);}
    });
    document.getElementById('dc-share-btn').addEventListener('click',function(){
        var params={expr:exprInput.value,v:varSelect.value,order:currentOrder};
        var pt=evalPointInput.value.trim();if(pt)params.pt=pt;
        if(typeof ToolUtils!=='undefined'){
            var url=ToolUtils.generateShareUrl(params,{toolName:'Derivative Calculator'});
            ToolUtils.copyToClipboard(url,'Share URL copied!');
        }
    });

    // Download PDF
    document.getElementById('dc-download-pdf-btn').addEventListener('click',downloadResultPdf);

    function downloadResultPdf(){
        if(!lastDiffContext){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('No result to download',2000,'warning');return;}
        var ctx=lastDiffContext;var exprTeX=exprToLatex(ctx.expr);
        var container=document.createElement('div');
        container.style.cssText='position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);
        var title=document.createElement('div');title.style.cssText='font-size:22px;font-weight:700;margin-bottom:8px;color:#d97706;';
        title.textContent='Derivative Calculator \u2014 8gwifi.org';container.appendChild(title);
        var divider=document.createElement('div');divider.style.cssText='height:2px;background:linear-gradient(90deg,#d97706,#f59e0b,transparent);margin-bottom:24px;';
        container.appendChild(divider);
        var qLabel=document.createElement('div');qLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent=orderLabelText(ctx.order)+' Derivative';container.appendChild(qLabel);
        var qMath=document.createElement('div');qMath.style.cssText='font-size:20px;margin-bottom:24px;';container.appendChild(qMath);
        var derivNotation=ctx.order===1?'\\frac{d}{d'+ctx.v+'}':'\\frac{d^{'+ctx.order+'}}{d'+ctx.v+'^{'+ctx.order+'}}';
        katex.render(derivNotation+'\\left['+exprTeX+'\\right]',qMath,{displayMode:true,throwOnError:false});
        var aLabel=document.createElement('div');aLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        aLabel.textContent='Result';container.appendChild(aLabel);
        var aMath=document.createElement('div');aMath.style.cssText='font-size:22px;margin-bottom:16px;padding:16px;background:#fffbeb;border-radius:8px;';container.appendChild(aMath);
        katex.render(ctx.intermediates[ctx.intermediates.length-1].tex,aMath,{displayMode:true,throwOnError:false});
        var methodDiv=document.createElement('div');methodDiv.style.cssText='font-size:13px;color:#64748b;margin-bottom:20px;';
        methodDiv.textContent='Method: '+ctx.method;container.appendChild(methodDiv);
        if(ctx.evalResult){
            var evalDiv=document.createElement('div');evalDiv.style.cssText='font-size:16px;margin-bottom:16px;padding:12px;background:#d97706;color:#fff;border-radius:8px;text-align:center;font-weight:700;';
            evalDiv.textContent=orderLabelText(ctx.order)+'('+ctx.evalResult.point+') = '+ctx.evalResult.value.toFixed(6);container.appendChild(evalDiv);
        }
        // Steps if rendered
        var stepsArea=document.getElementById('dc-steps-area');
        if(stepsArea&&stepsArea.children.length>0){
            var stepsLabel=document.createElement('div');stepsLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent='Step-by-Step Solution';container.appendChild(stepsLabel);
            var stepEls=stepsArea.querySelectorAll('.dc-step');
            for(var i=0;i<stepEls.length;i++){
                var stepRow=document.createElement('div');stepRow.style.cssText='display:flex;gap:12px;margin-bottom:12px;';
                var stepNum=document.createElement('div');stepNum.style.cssText='width:24px;height:24px;background:#d97706;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent=(i+1);stepRow.appendChild(stepNum);
                var stepBody=document.createElement('div');stepBody.style.cssText='flex:1;';
                var titleEl=stepEls[i].querySelector('.dc-step-title');
                if(titleEl){var sTitle=document.createElement('div');sTitle.style.cssText='font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';sTitle.textContent=titleEl.textContent;stepBody.appendChild(sTitle);}
                var mathEl=stepEls[i].querySelector('.dc-step-math');
                if(mathEl){var sMath=document.createElement('div');sMath.style.cssText='font-size:16px;';
                    var annotation=mathEl.querySelector('annotation');
                    if(annotation){katex.render(annotation.textContent,sMath,{displayMode:true,throwOnError:false});}
                    else{sMath.innerHTML=mathEl.innerHTML;}
                    stepBody.appendChild(sMath);}
                stepRow.appendChild(stepBody);container.appendChild(stepRow);
            }
        }
        var footer=document.createElement('div');footer.style.cssText='margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML='<span>Generated by 8gwifi.org Derivative Calculator</span><span>'+new Date().toLocaleDateString()+'</span>';
        container.appendChild(footer);
        if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Generating PDF...',1500,'info');
        var loadHtml2Canvas=(typeof html2canvas!=='undefined')?Promise.resolve():ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
        loadHtml2Canvas.then(function(){return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');})
        .then(function(){return html2canvas(container,{scale:2,backgroundColor:'#ffffff',useCORS:true,logging:false});})
        .then(function(canvas){
            document.body.removeChild(container);
            var imgData=canvas.toDataURL('image/png');
            var pdf=new jspdf.jsPDF({orientation:'portrait',unit:'mm',format:'a4'});
            var pageWidth=pdf.internal.pageSize.getWidth();var margin=10;var usableWidth=pageWidth-margin*2;
            var imgWidth=usableWidth;var imgHeight=(canvas.height*usableWidth)/canvas.width;
            var usableHeight=pdf.internal.pageSize.getHeight()-margin*2;
            if(imgHeight>usableHeight){imgHeight=usableHeight;imgWidth=(canvas.width*usableHeight)/canvas.height;}
            var x=(pageWidth-imgWidth)/2;
            pdf.addImage(imgData,'PNG',x,margin,imgWidth,imgHeight);
            pdf.save('derivative-'+ctx.expr.replace(/[^a-zA-Z0-9]/g,'_').substring(0,30)+'.pdf');
            if(typeof ToolUtils!=='undefined')ToolUtils.showToast('PDF downloaded!',2000,'success');
        }).catch(function(err){
            console.error('PDF generation failed:',err);
            if(container.parentNode)document.body.removeChild(container);
            if(typeof ToolUtils!=='undefined')ToolUtils.showToast('PDF generation failed: '+err.message,3000,'error');
        });
    }

    // Load from URL
    function loadFromUrl(){
        var p=new URLSearchParams(window.location.search);
        var expr=p.get('expr');var v=p.get('v');var order=p.get('order');var pt=p.get('pt');
        if(expr)exprInput.value=decodeURIComponent(expr);
        if(v)varSelect.value=v;
        if(order){
            var o=parseInt(order);if(o>=1&&o<=5){
                currentOrder=o;
                orderBtns.forEach(function(b){b.classList.toggle('active',parseInt(b.getAttribute('data-order'))===o);});
            }
        }
        if(pt)evalPointInput.value=decodeURIComponent(pt);
        if(expr){updatePreview();setTimeout(doDifferentiate,300);}
    }

    function escapeHtml(str){var div=document.createElement('div');div.appendChild(document.createTextNode(str));return div.innerHTML;}

    loadFromUrl();
    })();
    </script>
</body>
</html>
