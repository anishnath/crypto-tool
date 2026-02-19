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
            --tool-primary:#e11d48;--tool-primary-dark:#be123c;--tool-gradient:linear-gradient(135deg,#e11d48 0%,#f43f5e 100%);--tool-light:#fff1f2
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(225,29,72,0.15)}
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
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(225,29,72,0.3)}
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
        /* Normal distribution specific: select styling */
        .nd-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.875rem;background:var(--bg-primary);color:var(--text-primary);font-family:var(--font-sans)}
        .nd-select:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(225,29,72,0.1)}
        [data-theme="dark"] .nd-select{background:var(--bg-tertiary);border-color:var(--border)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Normal Distribution Calculator Online - Probability &amp; Percentile Free" />
        <jsp:param name="toolDescription" value="Calculate probabilities, Z-scores, and percentiles for any normal distribution with custom mean and standard deviation. Interactive bell curve, step-by-step formulas, and Python export." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="normal-distribution-calculator.jsp" />
        <jsp:param name="toolKeywords" value="normal distribution calculator, gaussian distribution calculator, bell curve calculator, normal probability calculator, z-score calculator, percentile calculator, standard deviation, inverse normal, range probability, CDF calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="X to probability with left and right tail,Percentile to X inverse normal,Range probability P(a le X le b),Custom mean and standard deviation,Interactive Plotly bell curve,Step-by-step KaTeX formulas,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Normal distribution, Gaussian distribution, bell curve, probability density, cumulative distribution, inverse normal, Z-scores" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Set Parameters|Enter the mean and standard deviation for your distribution,Choose Mode|Select X to Probability or Percentile to X or Range,Enter Values|Input X value or percentile or range bounds,Click Calculate|Get instant probability Z-score and percentile results,View Bell Curve|Explore the interactive shaded normal distribution,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is a normal distribution?" />
        <jsp:param name="faq1a" value="A normal distribution is a symmetric bell-shaped probability distribution defined by its mean mu and standard deviation sigma. It is the most common distribution in statistics because many natural phenomena follow it due to the Central Limit Theorem." />
        <jsp:param name="faq2q" value="How do I calculate P(X le x) for a normal distribution?" />
        <jsp:param name="faq2a" value="First standardize by computing Z equals x minus mu divided by sigma. Then look up the cumulative distribution function Phi of Z. This gives the left tail probability. For right tail subtract from 1." />
        <jsp:param name="faq3q" value="What is the inverse normal function?" />
        <jsp:param name="faq3a" value="The inverse normal function Phi inverse of p gives the X value such that P of X less than or equal to x equals p. It converts a probability or percentile back to a value on the distribution. For example the 95th percentile of N(100, 15) is about 124.67." />
        <jsp:param name="faq4q" value="How do I find the probability between two values?" />
        <jsp:param name="faq4a" value="Use P of a le X le b equals Phi of Z_b minus Phi of Z_a where Z_a and Z_b are the standardized values. This calculator computes this automatically in Range mode." />
        <jsp:param name="faq5q" value="What is the relationship between normal distribution and Z-scores?" />
        <jsp:param name="faq5a" value="Z-scores standardize any normal distribution to the standard normal N(0, 1). The formula Z equals X minus mu divided by sigma transforms values so they can be compared across different distributions. A Z-score of 2 always means 2 standard deviations above the mean regardless of the original scale." />
        <jsp:param name="faq6q" value="When can I assume data follows a normal distribution?" />
        <jsp:param name="faq6a" value="Data often follows a normal distribution when it results from many small independent effects. Common examples include heights, measurement errors, and test scores. Use normality tests like Shapiro-Wilk or Q-Q plots to verify. The Central Limit Theorem guarantees sample means are approximately normal for large samples." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/statistics-calculator.css?v=<%=cacheVersion%>">
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Normal Distribution Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Normal Distribution Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">X &harr; Probability</span>
                <span class="tool-badge">Bell Curve</span>
                <span class="tool-badge">Custom &mu; &sigma;</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>normal distribution calculator</strong> for any <strong>&mu;</strong> and <strong>&sigma;</strong>: compute <strong>P(X &le; x)</strong> probabilities, find <strong>X from percentile</strong> (inverse normal), or calculate <strong>P(a &le; X &le; b)</strong> range probability. Interactive Plotly bell curve, step-by-step KaTeX formulas, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                    </svg>
                    Normal Distribution Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Distribution Parameters (always visible) -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="nd-mean">Mean (&mu;)</label>
                        <input type="number" class="stat-input-text nd-input" id="nd-mean" value="100" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="nd-stddev">Standard Deviation (&sigma;)</label>
                        <input type="number" class="stat-input-text nd-input" id="nd-stddev" value="15" step="any" min="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                    </div>

                    <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0;">

                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Calculation Mode</label>
                        <div class="stat-mode-toggle">
                            <button type="button" class="stat-mode-btn active" id="nd-mode-prob">X&rarr;Prob</button>
                            <button type="button" class="stat-mode-btn" id="nd-mode-percentile">Pctl&rarr;X</button>
                            <button type="button" class="stat-mode-btn" id="nd-mode-range">Range</button>
                        </div>
                    </div>

                    <!-- X → Probability inputs -->
                    <div id="nd-input-prob">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="nd-x-value">X Value</label>
                            <input type="number" class="stat-input-text nd-input" id="nd-x-value" value="115" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">Find the probability for this value</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="nd-prob-type">Tail Type</label>
                            <select class="nd-select nd-input" id="nd-prob-type">
                                <option value="left">Left tail P(X &le; x)</option>
                                <option value="right">Right tail P(X &ge; x)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Percentile → X inputs -->
                    <div id="nd-input-percentile" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="nd-percentile">Percentile (%)</label>
                            <input type="number" class="stat-input-text nd-input" id="nd-percentile" value="90" step="any" min="0.01" max="99.99" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">e.g. 90 for the 90th percentile</div>
                        </div>
                    </div>

                    <!-- Range inputs -->
                    <div id="nd-input-range" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="nd-range-a">Lower Bound (a)</label>
                            <input type="number" class="stat-input-text nd-input" id="nd-range-a" value="85" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="nd-range-b">Upper Bound (b)</label>
                            <input type="number" class="stat-input-text nd-input" id="nd-range-b" value="115" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">P(a &le; X &le; b)</div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="nd-calc-btn">Calculate</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="nd-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-nd-example="iq">IQ Score</button>
                            <button type="button" class="stat-example-chip" data-nd-example="sat">SAT Score</button>
                            <button type="button" class="stat-example-chip" data-nd-example="height">Height Range</button>
                            <button type="button" class="stat-example-chip" data-nd-example="top10">Top 10%</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="nd-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="nd-graph-panel">Normal Curve</button>
                <button type="button" class="stat-output-tab" data-tab="nd-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="nd-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="nd-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter values and click Calculate</h3>
                            <p>Find probabilities, percentiles, and Z-scores for your normal distribution.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="nd-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="nd-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                        <h4>Normal Distribution Curve</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="nd-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the bell curve.</p></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="nd-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="nd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="normal-distribution-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Normal Distribution? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is the Normal Distribution?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The <strong>normal distribution</strong> (Gaussian distribution) is a symmetric, bell-shaped probability distribution defined by two parameters: the mean (&mu;) and standard deviation (&sigma;). It is the most important distribution in statistics because many natural phenomena follow it.</p>

            <div class="stat-formula-box">
                <strong>Probability Density Function:</strong>&nbsp; f(x) = (1 / &sigma;&radic;(2&pi;)) &times; e<sup>&minus;(x&minus;&mu;)&sup2; / (2&sigma;&sup2;)</sup>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Symmetric</h4>
                    <p>Perfectly symmetric about the mean. Mean = median = mode, all at the center.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Defined by &mu; and &sigma;</h4>
                    <p>&mu; sets the center, &sigma; controls the spread. Larger &sigma; means a flatter, wider bell.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x267E;&#xFE0F;</div>
                    <h4>Asymptotic</h4>
                    <p>Tails extend infinitely but approach zero. Total area under the curve equals 1.</p>
                </div>
            </div>
        </div>

        <!-- 2. The 68-95-99.7 Rule -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The 68-95-99.7 Rule (Empirical Rule)</h2>

            <!-- Animated SVG Bell Curve -->
            <div style="text-align:center;margin-bottom:1.5rem;" class="stat-anim stat-anim-d1">
                <svg viewBox="0 0 500 200" style="max-width:500px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                    <path d="M 30,170 C 60,170 80,168 110,160 C 140,148 160,120 180,80 C 200,45 220,20 250,15 C 280,20 300,45 320,80 C 340,120 360,148 390,160 C 420,168 440,170 470,170" fill="none" stroke="#e11d48" stroke-width="2.5" class="stat-bell-animated"/>
                    <rect x="180" y="70" width="140" height="100" fill="rgba(225,29,72,0.08)" rx="2"/>
                    <text x="250" y="135" text-anchor="middle" fill="#e11d48" font-size="13" font-weight="600" font-family="Inter,sans-serif">68%</text>
                    <rect x="110" y="140" width="280" height="20" fill="rgba(225,29,72,0.05)" rx="2"/>
                    <text x="250" y="155" text-anchor="middle" fill="#be123c" font-size="11" font-family="Inter,sans-serif">95%</text>
                    <rect x="60" y="162" width="380" height="8" fill="rgba(225,29,72,0.03)" rx="1"/>
                    <text x="110" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;&minus;2&sigma;</text>
                    <text x="180" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;&minus;1&sigma;</text>
                    <text x="250" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-weight="600" font-family="Inter,sans-serif">&mu;</text>
                    <text x="320" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;+1&sigma;</text>
                    <text x="390" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;+2&sigma;</text>
                </svg>
            </div>

            <table class="stat-ops-table">
                <thead><tr><th>Range</th><th>Probability</th><th>Example (IQ: &mu;=100, &sigma;=15)</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">&mu; &plusmn; 1&sigma;</td><td>68.27%</td><td>IQ 85 &ndash; 115</td></tr>
                    <tr><td style="font-weight:600;">&mu; &plusmn; 2&sigma;</td><td>95.45%</td><td>IQ 70 &ndash; 130</td></tr>
                    <tr><td style="font-weight:600;">&mu; &plusmn; 3&sigma;</td><td>99.73%</td><td>IQ 55 &ndash; 145</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 3. Standardization & Z-Scores -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Standardization &amp; Z-Scores</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Any normal distribution N(&mu;, &sigma;) can be converted to the <strong>standard normal</strong> N(0, 1) by computing the Z-score:</p>

            <div class="stat-formula-box">
                <strong>Z = (X &minus; &mu;) / &sigma;</strong>
            </div>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> IQ scores follow N(100, 15). What Z-score corresponds to IQ = 130?
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    Z = (130 &minus; 100) / 15 = 30 / 15 = <strong>2.0</strong><br>
                    &Phi;(2.0) = 0.9772 &rarr; IQ 130 is at the <strong>97.7th percentile</strong>
                </div>
            </div>

            <table class="stat-ops-table" style="margin-top:1rem;">
                <thead><tr><th>Z-Score</th><th>Left Tail P(Z &le; z)</th><th>Percentile</th></tr></thead>
                <tbody>
                    <tr><td>&minus;2.326</td><td>0.0100</td><td>1st</td></tr>
                    <tr><td>&minus;1.645</td><td>0.0500</td><td>5th</td></tr>
                    <tr><td>0.000</td><td>0.5000</td><td>50th</td></tr>
                    <tr><td>+1.645</td><td>0.9500</td><td>95th</td></tr>
                    <tr><td>+1.960</td><td>0.9750</td><td>97.5th</td></tr>
                    <tr><td>+2.326</td><td>0.9900</td><td>99th</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Real-World Applications -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>IQ &amp; Standardized Testing</h4>
                    <p>IQ scores follow N(100, 15). SAT scores approximate N(1060, 195). Z-scores enable comparison across different tests.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Quality Control</h4>
                    <p>Manufacturing uses normal distribution to set tolerance limits. Six Sigma targets Z = &plusmn;6 for defect rates below 3.4 per million.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Biological Measurements</h4>
                    <p>Heights, weights, blood pressure, and many biological variables are approximately normally distributed in populations.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>Central Limit Theorem</h4>
                    <p>Sample means approach a normal distribution as n increases, regardless of the population shape. This is the foundation of inferential statistics.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is a normal distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A normal distribution (Gaussian distribution) is a symmetric, bell-shaped probability distribution defined by its mean &mu; and standard deviation &sigma;. It is the most common distribution in statistics because many natural phenomena follow it due to the Central Limit Theorem.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I calculate P(X &le; x) for a normal distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">First standardize by computing Z = (x &minus; &mu;) / &sigma;. Then look up the cumulative distribution function &Phi;(Z). This gives the left-tail probability. For the right tail, subtract from 1: P(X &ge; x) = 1 &minus; &Phi;(Z).</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the inverse normal function?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The inverse normal function &Phi;<sup>&minus;1</sup>(p) returns the X value such that P(X &le; x) = p. It converts a probability or percentile back to a value on the distribution. For example, the 95th percentile of N(100, 15) is about 124.67.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I find the probability between two values?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use P(a &le; X &le; b) = &Phi;(Z<sub>b</sub>) &minus; &Phi;(Z<sub>a</sub>), where Z<sub>a</sub> and Z<sub>b</sub> are the standardized values. This calculator computes it automatically in Range mode.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the relationship between normal distribution and Z-scores?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Z-scores standardize any normal distribution to the standard normal N(0, 1). The formula Z = (X &minus; &mu;) / &sigma; transforms values so they can be compared across different distributions. A Z-score of 2 always means 2 standard deviations above the mean, regardless of the original scale.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When can I assume data follows a normal distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Data often follows a normal distribution when it results from many small, independent effects. Common examples include heights, measurement errors, and test scores. Use normality tests like Shapiro-Wilk or Q-Q plots to verify. The Central Limit Theorem guarantees sample means are approximately normal for large samples.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a><a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a></div></div></footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stats-common.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stats-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stats-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/normal-distribution-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
