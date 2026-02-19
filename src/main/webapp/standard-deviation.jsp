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
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}
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
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Standard Deviation Calculator Online - Sample &amp; Population SD Free" />
        <jsp:param name="toolDescription" value="Paste your data to instantly calculate standard deviation, variance, and mean with sample or population toggle. Interactive bell curve, step-by-step formulas, and Python export included." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="standard-deviation.jsp" />
        <jsp:param name="toolKeywords" value="standard deviation calculator, sd calculator online, variance calculator, population standard deviation, sample standard deviation, bell curve calculator, normal distribution, standard deviation formula, 68-95-99.7 rule, free statistics calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Sample and population standard deviation,Variance calculation with Bessel correction,Step-by-step formula breakdown with KaTeX,Interactive Plotly bell curve with sigma markers,68-95-99.7 empirical rule display,Python numpy and scipy code generation,LaTeX export and share URL,Coefficient of variation and SEM" />
        <jsp:param name="teaches" value="Standard deviation, variance, sample vs population statistics, normal distribution, empirical rule, measures of dispersion" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Mode|Toggle between sample (n-1) and population (n),Click Calculate|Get instant standard deviation and variance,Review Steps|See step-by-step formula with KaTeX rendering,View Bell Curve|Explore the interactive normal distribution graph,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is standard deviation?" />
        <jsp:param name="faq1a" value="Standard deviation measures how spread out data values are from the mean. A low SD means data points cluster near the mean while a high SD means they are spread over a wider range. It is the square root of variance and is expressed in the same units as the original data." />
        <jsp:param name="faq2q" value="What is the difference between sample and population standard deviation?" />
        <jsp:param name="faq2a" value="Sample standard deviation (s) divides by n-1 using Bessel correction because a sample underestimates the true variability. Population standard deviation (sigma) divides by n because you have every data point. Use sample SD when analyzing a subset and population SD when you have the complete dataset." />
        <jsp:param name="faq3q" value="What does the 68-95-99.7 rule mean?" />
        <jsp:param name="faq3a" value="For normally distributed data about 68.3 percent falls within one standard deviation of the mean, 95.4 percent within two, and 99.7 percent within three. This empirical rule helps you quickly assess how unusual a value is based on how many standard deviations it is from the mean." />
        <jsp:param name="faq4q" value="How do I interpret a high or low standard deviation?" />
        <jsp:param name="faq4a" value="Standard deviation is relative to your data. Compare it using the coefficient of variation (CV = SD/mean x 100). A CV below 15 percent indicates low variability. A CV above 30 percent indicates high variability. Always consider the context and units of your data when interpreting SD." />
        <jsp:param name="faq5q" value="Why divide by n-1 instead of n for sample standard deviation?" />
        <jsp:param name="faq5a" value="Dividing by n-1 is called Bessel correction. When computing from a sample the mean is estimated from the same data which constrains one degree of freedom. Dividing by n-1 corrects this bias giving an unbiased estimate of the population variance. With large samples the difference is negligible." />
        <jsp:param name="faq6q" value="What is the relationship between variance and standard deviation?" />
        <jsp:param name="faq6a" value="Variance is the average of squared deviations from the mean. Standard deviation is the square root of variance. SD is preferred for interpretation because it has the same units as the data while variance is in squared units. Both measure data spread but SD is more intuitive for most applications." />
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
                <h1 class="tool-page-title">Standard Deviation Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Standard Deviation Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Sample &amp; Population</span>
                <span class="tool-badge">Bell Curve</span>
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>standard deviation calculator</strong> with sample and population modes. Paste your data to compute <strong>standard deviation, variance, mean</strong>, and see the <strong>bell curve</strong> plotted with &sigma; markers. Includes step-by-step formulas, 68&ndash;95&ndash;99.7 rule, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M2 20h20"/><path d="M5 20V10l4-7 3 4 3-4 4 7v10"/>
                    </svg>
                    Standard Deviation
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Mode</label>
                        <div class="stat-mode-toggle">
                            <button type="button" class="stat-mode-btn active" id="sd-mode-sample">Sample (s)</button>
                            <button type="button" class="stat-mode-btn" id="sd-mode-population">Population (&sigma;)</button>
                        </div>
                        <div class="tool-form-hint">Sample divides by n&minus;1 (Bessel correction); population divides by n</div>
                    </div>

                    <!-- Data Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="sd-data-input">Data Input</label>
                        <textarea class="stat-input-text" id="sd-data-input" rows="7" placeholder="72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79" spellcheck="false">72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79</textarea>
                        <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                    </div>

                    <!-- Preview -->
                    <div class="tool-form-group">
                        <div class="stat-preview" id="sd-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="sd-calc-btn">Calculate Standard Deviation</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="sd-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                        <button type="button" class="tool-action-btn" id="sd-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="exam-scores">Exam Scores</button>
                            <button type="button" class="stat-example-chip" data-example="measurements">Measurements</button>
                            <button type="button" class="stat-example-chip" data-example="daily-temps">Daily Temps</button>
                            <button type="button" class="stat-example-chip" data-example="reaction-times">Reaction Times</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-panel="result">Result</button>
                <button type="button" class="stat-output-tab" data-panel="graph">Bell Curve</button>
                <button type="button" class="stat-output-tab" data-panel="python">Python Compiler</button>
            </div>

            <!-- Result Panel -->
            <div class="stat-panel active" id="sd-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="sd-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4C9;</div>
                            <h3>Enter data and click Calculate</h3>
                            <p>Paste numbers to compute standard deviation with step-by-step solution.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="sd-result-actions">
                        <button type="button" class="tool-action-btn" id="sd-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="sd-share-btn">&#128279; Share</button>
                    </div>
                </div>
            </div>

            <!-- Graph Panel -->
            <div class="stat-panel" id="sd-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M2 20h20"/><path d="M5 20V10l4-7 3 4 3-4 4 7v10"/></svg>
                        <h4>Bell Curve (Normal Distribution)</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="sd-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the bell curve.</p></div>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="stat-panel" id="sd-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="sd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="standard-deviation.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Standard Deviation? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Standard Deviation?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Standard deviation</strong> is a measure of how spread out data values are from their mean. A <em>low</em> standard deviation means data points cluster close to the mean, while a <em>high</em> standard deviation means they are spread over a wider range. It is the most commonly used measure of dispersion in statistics.</p>

            <div class="stat-edu-grid">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Same Units as Data</h4>
                    <p>Unlike variance (squared units), SD is in the same units as your data, making it directly interpretable.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F514;</div>
                    <h4>Bell Curve Foundation</h4>
                    <p>SD defines the shape of the normal distribution &mdash; wider curves have larger SD values.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                    <h4>Sample vs Population</h4>
                    <p>Use s (n&minus;1) for samples from a larger group; use &sigma; (n) when you have the complete dataset.</p>
                </div>
            </div>
        </div>

        <!-- 2. The Standard Deviation Formula -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The Standard Deviation Formula</h2>

            <div class="stat-formula-box">
                <strong>Sample SD:</strong>&nbsp; s = &radic;[ &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2; / (n &minus; 1) ]
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">Divides by <strong>n &minus; 1</strong> (Bessel&rsquo;s correction) to give an unbiased estimate of the population variance from a sample.</p>

            <div class="stat-formula-box">
                <strong>Population SD:</strong>&nbsp; &sigma; = &radic;[ &Sigma;(x<sub>i</sub> &minus; &mu;)&sup2; / n ]
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 1rem;line-height:1.7;">Divides by <strong>n</strong> because when you have the entire population, there is no need for correction.</p>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Step-by-Step Worked Example</h3>
            <div class="stat-worked-example">
                <strong>Data:</strong> [4, 8, 6, 5, 3, 7, 8, 1]<br>
                <strong>Step 1:</strong> Mean = (4+8+6+5+3+7+8+1)/8 = 42/8 = <span style="color:var(--stat-tool);font-weight:700;">5.25</span><br>
                <strong>Step 2:</strong> Deviations: &minus;1.25, 2.75, 0.75, &minus;0.25, &minus;2.25, 1.75, 2.75, &minus;3.75<br>
                <strong>Step 3:</strong> Squared: 1.5625, 7.5625, 0.5625, 0.0625, 5.0625, 3.0625, 7.5625, 14.0625<br>
                <strong>Step 4:</strong> Sum of squares = 39.5<br>
                <strong>Step 5 (sample):</strong> s&sup2; = 39.5 / 7 = <span style="color:var(--stat-tool);font-weight:700;">5.6429</span><br>
                <strong>Step 6:</strong> s = &radic;5.6429 = <span style="color:var(--stat-tool);font-weight:700;">2.3755</span>
            </div>
        </div>

        <!-- 3. The 68-95-99.7 Rule -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The 68&ndash;95&ndash;99.7 Rule (Empirical Rule)</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">For <strong>normally distributed</strong> data, the standard deviation determines how much data falls within specific ranges around the mean:</p>

            <svg viewBox="0 0 560 180" xmlns="http://www.w3.org/2000/svg" class="stat-bell-animated" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                <rect x="0" y="0" width="560" height="180" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <path class="bell-path" d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150" fill="none" stroke="#e11d48" stroke-width="2.5"/>
                <path d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150 Z" fill="rgba(225,29,72,0.08)"/>
                <line x1="280" y1="15" x2="280" y2="155" stroke="#94a3b8" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="180" y1="80" x2="180" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="380" y1="80" x2="380" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="100" y1="142" x2="100" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="460" y1="142" x2="460" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="50" y1="149" x2="50" y2="155" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="510" y1="149" x2="510" y2="155" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3"/>
                <text x="280" y="172" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">&mu;</text>
                <text x="180" y="172" text-anchor="middle" font-size="9" fill="#10b981">&minus;1&sigma;</text>
                <text x="380" y="172" text-anchor="middle" font-size="9" fill="#10b981">+1&sigma;</text>
                <text x="100" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">&minus;2&sigma;</text>
                <text x="460" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">+2&sigma;</text>
                <text x="50" y="172" text-anchor="middle" font-size="9" fill="#ef4444">&minus;3&sigma;</text>
                <text x="510" y="172" text-anchor="middle" font-size="9" fill="#ef4444">+3&sigma;</text>
                <text x="280" y="98" text-anchor="middle" font-size="11" fill="#10b981" font-weight="600">68.3%</text>
                <text x="280" y="130" text-anchor="middle" font-size="10" fill="#f59e0b" font-weight="500">95.4%</text>
                <text x="280" y="148" text-anchor="middle" font-size="9" fill="#ef4444" font-weight="500">99.7%</text>
            </svg>

            <table class="stat-ops-table">
                <thead><tr><th>Range</th><th>Coverage</th><th>Meaning</th></tr></thead>
                <tbody>
                    <tr><td>&mu; &plusmn; 1&sigma;</td><td style="font-family:var(--font-sans);font-weight:600;color:var(--stat-tool);">68.3%</td><td>About two-thirds of all values</td></tr>
                    <tr><td>&mu; &plusmn; 2&sigma;</td><td style="font-family:var(--font-sans);font-weight:600;color:var(--stat-tool);">95.4%</td><td>Nearly all values &mdash; outliers are rare</td></tr>
                    <tr><td>&mu; &plusmn; 3&sigma;</td><td style="font-family:var(--font-sans);font-weight:600;color:var(--stat-tool);">99.7%</td><td>Virtually all values &mdash; beyond is extremely rare</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Sample vs Population -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Sample vs Population: When to Use Which</h2>

            <table class="stat-ops-table">
                <thead><tr><th></th><th>Sample</th><th>Population</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Symbol</td><td>s</td><td>&sigma;</td></tr>
                    <tr><td style="font-weight:600;">Divisor</td><td>n &minus; 1</td><td>n</td></tr>
                    <tr><td style="font-weight:600;">Use when</td><td>Analyzing a subset of a larger group</td><td>You have every data point in the group</td></tr>
                    <tr><td style="font-weight:600;">Example</td><td>Survey of 500 voters from millions</td><td>Final grades of all 30 students in a class</td></tr>
                    <tr><td style="font-weight:600;">Bias</td><td>Corrected (unbiased estimate)</td><td>Exact (no estimation needed)</td></tr>
                </tbody>
            </table>

            <p style="color:var(--text-secondary);margin:1rem 0 0;line-height:1.7;"><strong>Bessel&rsquo;s correction</strong> (n&minus;1) exists because the sample mean is calculated from the same data, reducing degrees of freedom by one. This causes the sample variance to underestimate the true variance if you divide by n. Dividing by n&minus;1 corrects this bias. For large samples (n &gt; 30), the difference becomes negligible.</p>
        </div>

        <!-- 5. Interpreting Standard Deviation -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpreting Standard Deviation</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Standard deviation alone doesn&rsquo;t tell you if variability is &ldquo;high&rdquo; or &ldquo;low&rdquo; &mdash; it depends on context. Use the <strong>Coefficient of Variation (CV)</strong> to compare relative spread:</p>

            <div class="stat-formula-box">
                <strong>CV:</strong>&nbsp; CV = (s / x&#772;) &times; 100%
            </div>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Low Variability (CV &lt; 15%)</h4>
                    <p>Data points are tightly clustered around the mean. Common in precise measurements and controlled experiments.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Moderate (15% &le; CV &le; 30%)</h4>
                    <p>Typical spread seen in many natural and social science datasets. Generally acceptable variability.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>High Variability (CV &gt; 30%)</h4>
                    <p>Data is widely spread. Common in financial returns, biological variation, and heterogeneous populations.</p>
                </div>
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Standard deviation measures how spread out data values are from the mean. A low SD means data points cluster near the mean while a high SD means they are spread over a wider range. It is the square root of variance and is expressed in the same units as the original data.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between sample and population standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Sample standard deviation (s) divides by n&minus;1 using Bessel&rsquo;s correction because a sample underestimates the true variability. Population standard deviation (&sigma;) divides by n because you have every data point. Use sample SD when analyzing a subset and population SD when you have the complete dataset.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What does the 68-95-99.7 rule mean?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">For normally distributed data, about 68.3% falls within one standard deviation of the mean, 95.4% within two, and 99.7% within three. This empirical rule helps you quickly assess how unusual a value is based on how many standard deviations it is from the mean.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret a high or low standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Standard deviation is relative to your data. Compare it using the coefficient of variation (CV = SD/mean &times; 100%). A CV below 15% indicates low variability. A CV above 30% indicates high variability. Always consider the context and units of your data when interpreting SD.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Why divide by n&minus;1 instead of n for sample standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Dividing by n&minus;1 is called Bessel&rsquo;s correction. When computing from a sample, the mean is estimated from the same data, which constrains one degree of freedom. Dividing by n&minus;1 corrects this bias, giving an unbiased estimate of the population variance. With large samples (n &gt; 30), the difference is negligible.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the relationship between variance and standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Variance is the average of squared deviations from the mean. Standard deviation is the square root of variance. SD is preferred for interpretation because it has the same units as the data, while variance is in squared units. Both measure data spread, but SD is more intuitive for most applications.</div>
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
    <script src="<%=request.getContextPath()%>/js/standard-deviation-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
