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
        <jsp:param name="toolName" value="Percentile Calculator Online - Rank, Quartiles &amp; Box Plot Free" />
        <jsp:param name="toolDescription" value="Find percentile rank of any value, calculate value at any percentile, or get full quartile summary with IQR, outlier detection, and interactive box plot." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="percentile-calculator.jsp" />
        <jsp:param name="toolKeywords" value="percentile calculator, percentile rank calculator, quartile calculator, IQR calculator, box plot generator, five number summary, interquartile range, outlier detection, percentile formula, free statistics calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Find percentile rank of any value,Find value at any percentile,Quartiles Q1 Q2 Q3 and IQR,Five-number summary,Interactive Plotly box plot,Outlier detection via IQR fences,Step-by-step KaTeX formulas,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Percentiles, percentile rank, quartiles, interquartile range, five-number summary, box plots, outlier detection" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Mode|Select Find Rank or Find Value or Full Summary,Set Target|Enter the value or percentile to look up,Click Calculate|Get instant percentile results with steps,View Box Plot|Explore the interactive Plotly box plot,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is the difference between percentile and percentile rank?" />
        <jsp:param name="faq1a" value="A percentile is a value below which a certain percentage of observations fall. For example the 90th percentile is the value below which 90 percent of data lies. Percentile rank is the reverse: given a specific value it tells you what percentage of the dataset falls below that value." />
        <jsp:param name="faq2q" value="How is the value at a percentile calculated?" />
        <jsp:param name="faq2a" value="Data are sorted in ascending order. The position is calculated as L equals n plus 1 times p divided by 100. If L is a whole number use that position value. If L is fractional interpolate linearly between the two adjacent values. Different software may use slightly different interpolation methods." />
        <jsp:param name="faq3q" value="What are quartiles and how do they relate to percentiles?" />
        <jsp:param name="faq3a" value="Quartiles divide sorted data into four equal parts. Q1 is the 25th percentile and 25 percent of data falls below it. Q2 is the 50th percentile which equals the median. Q3 is the 75th percentile. The interquartile range IQR equals Q3 minus Q1 and measures the spread of the middle 50 percent." />
        <jsp:param name="faq4q" value="How are outliers detected using IQR?" />
        <jsp:param name="faq4a" value="The IQR method flags values as potential outliers if they fall below Q1 minus 1.5 times IQR or above Q3 plus 1.5 times IQR. These boundaries are called fences. Values beyond 3 times IQR from the quartiles are considered extreme outliers. Context matters as not all flagged points are errors." />
        <jsp:param name="faq5q" value="What is a five-number summary?" />
        <jsp:param name="faq5a" value="A five-number summary consists of the minimum Q1 median Q3 and maximum. It provides a concise description of data distribution and is the basis for box plot visualization. Together these five values show center spread and symmetry of the data." />
        <jsp:param name="faq6q" value="Where are percentiles commonly used?" />
        <jsp:param name="faq6a" value="Percentiles are used in standardized testing like SAT and GRE scores, salary and income comparisons, pediatric growth charts for height and weight, network performance monitoring for response time SLAs, and quality control to establish tolerance limits in manufacturing." />
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
                <h1 class="tool-page-title">Percentile Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Percentile Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Rank &amp; Value</span>
                <span class="tool-badge">Quartiles &amp; IQR</span>
                <span class="tool-badge">Box Plot</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>percentile calculator</strong> with three modes: find the <strong>percentile rank</strong> of any value, find the <strong>value at any percentile</strong>, or compute a <strong>full summary</strong> with quartiles, IQR, outlier detection, and interactive box plot. Includes step-by-step formulas and Python export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M16 3h5v5"/><path d="M4 20L21 3"/><path d="M21 16v5h-5"/><path d="M15 15l6 6"/><path d="M4 4l5 5"/>
                    </svg>
                    Percentile Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Calculation Mode</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="pct-mode-rank" style="flex:1;min-width:0;">Find Rank</button>
                            <button type="button" class="stat-mode-btn" id="pct-mode-value" style="flex:1;min-width:0;">Find Value</button>
                            <button type="button" class="stat-mode-btn" id="pct-mode-summary" style="flex:1;min-width:0;">Summary</button>
                        </div>
                        <div class="tool-form-hint">Find percentile rank, value at percentile, or full summary</div>
                    </div>

                    <!-- Data Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pct-data-input">Data Input</label>
                        <textarea class="stat-input-text" id="pct-data-input" rows="6" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91" spellcheck="false">85, 90, 78, 92, 88, 76, 95, 82, 87, 91</textarea>
                        <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                    </div>

                    <!-- Target Input -->
                    <div class="tool-form-group" id="pct-target-group">
                        <label class="tool-form-label" id="pct-target-label" for="pct-target-input">Value to find rank for</label>
                        <input type="number" class="stat-input-text" id="pct-target-input" value="88" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                        <div class="tool-form-hint" id="pct-target-hint">What percentile is this value at?</div>
                    </div>

                    <!-- Preview -->
                    <div class="tool-form-group">
                        <div class="stat-preview" id="pct-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="pct-calc-btn">Calculate Percentile</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="pct-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                        <button type="button" class="tool-action-btn" id="pct-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="test-scores">Test Scores</button>
                            <button type="button" class="stat-example-chip" data-example="salaries">Salaries</button>
                            <button type="button" class="stat-example-chip" data-example="heights">Heights (cm)</button>
                            <button type="button" class="stat-example-chip" data-example="response-times">Response Times</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="pct-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="pct-graph-panel">Box Plot</button>
                <button type="button" class="stat-output-tab" data-tab="pct-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="pct-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="pct-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter data and click Calculate</h3>
                            <p>Find percentile rank, value at percentile, or full quartile summary.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="pct-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="pct-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Box Plot</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="pct-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4E6;</div><h3>No graph yet</h3><p>Calculate to see the box plot.</p></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="pct-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="pct-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="percentile-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Are Percentiles? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Percentiles?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>percentile</strong> indicates the value below which a given percentage of observations fall. If you score in the 85th percentile on a test, you performed better than 85% of test-takers. Percentiles are essential for comparing individual values to a larger distribution.</p>

            <div class="stat-edu-grid">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Percentile Rank</h4>
                    <p>Given a specific value, percentile rank tells you what percentage of the dataset falls at or below it.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F50D;</div>
                    <h4>Value at Percentile</h4>
                    <p>Given a target percentile (e.g., 75th), find the data value that separates the lower p% from the upper.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4E6;</div>
                    <h4>Quartiles &amp; Box Plot</h4>
                    <p>Q1, Q2 (median), and Q3 divide data into four equal parts. The box plot visualizes this five-number summary.</p>
                </div>
            </div>
        </div>

        <!-- 2. Percentile Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Percentile Formulas</h2>

            <div class="stat-formula-box">
                <strong>Percentile Rank (midpoint formula):</strong>&nbsp; PR = ((B + 0.5E) / n) &times; 100
            </div>
            <p style="color:var(--text-secondary);font-size:0.875rem;margin:0.5rem 0 1rem;">Where B = values below, E = values equal, n = total count</p>

            <div class="stat-formula-box">
                <strong>Value at Percentile (linear interpolation):</strong>&nbsp; L = (n + 1) &times; p / 100
            </div>
            <p style="color:var(--text-secondary);font-size:0.875rem;margin:0.5rem 0 1rem;">If L is fractional, interpolate between x<sub>&lfloor;L&rfloor;</sub> and x<sub>&lceil;L&rceil;</sub></p>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example</h3>
            <div class="stat-worked-example">
                <strong>Data (sorted):</strong> [12, 15, 18, 22, 25, 28, 30, 35, 40, 45]&ensp;(n=10)<br>
                <strong>Find:</strong> 75th percentile<br>
                <strong>Step 1:</strong> L = (10+1) &times; 75/100 = <span style="color:var(--stat-tool);font-weight:700;">8.25</span><br>
                <strong>Step 2:</strong> x<sub>8</sub> = 35, x<sub>9</sub> = 40<br>
                <strong>Step 3:</strong> Interpolate: 35 + 0.25 &times; (40 &minus; 35) = <span style="color:var(--stat-tool);font-weight:700;">36.25</span><br>
                <strong>Result:</strong> The 75th percentile is 36.25
            </div>
        </div>

        <!-- 3. Quartiles, IQR & Outliers -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Quartiles, IQR &amp; Outlier Detection</h2>

            <!-- Animated SVG Box Plot Diagram -->
            <div style="text-align:center;margin-bottom:1.5rem;" class="stat-anim stat-anim-d1">
                <svg viewBox="0 0 500 120" style="max-width:500px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                    <!-- Whisker lines -->
                    <line x1="60" y1="60" x2="150" y2="60" stroke="#e11d48" stroke-width="2"/>
                    <line x1="350" y1="60" x2="440" y2="60" stroke="#e11d48" stroke-width="2"/>
                    <!-- Whisker caps -->
                    <line x1="60" y1="45" x2="60" y2="75" stroke="#e11d48" stroke-width="2"/>
                    <line x1="440" y1="45" x2="440" y2="75" stroke="#e11d48" stroke-width="2"/>
                    <!-- Box -->
                    <rect x="150" y="35" width="200" height="50" fill="rgba(225,29,72,0.1)" stroke="#e11d48" stroke-width="2" rx="3"/>
                    <!-- Median -->
                    <line x1="250" y1="35" x2="250" y2="85" stroke="#be123c" stroke-width="3"/>
                    <!-- Outlier -->
                    <circle cx="20" cy="60" r="5" fill="#ef4444" stroke="#b91c1c" stroke-width="1.5"/>
                    <!-- Labels -->
                    <text x="60" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-family="Inter,sans-serif">Min</text>
                    <text x="150" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-weight="600" font-family="Inter,sans-serif">Q1</text>
                    <text x="250" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-weight="600" font-family="Inter,sans-serif">Median</text>
                    <text x="350" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-weight="600" font-family="Inter,sans-serif">Q3</text>
                    <text x="440" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-family="Inter,sans-serif">Max</text>
                    <text x="20" y="105" text-anchor="middle" fill="#ef4444" font-size="10" font-family="Inter,sans-serif">Outlier</text>
                    <text x="250" y="22" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">IQR = Q3 &minus; Q1</text>
                    <!-- IQR bracket -->
                    <line x1="150" y1="28" x2="350" y2="28" stroke="var(--text-muted)" stroke-width="1" stroke-dasharray="3,2"/>
                </svg>
            </div>

            <div class="stat-formula-box">
                <strong>IQR:</strong>&nbsp; IQR = Q3 &minus; Q1
            </div>
            <div class="stat-formula-box">
                <strong>Outlier Fences:</strong>&nbsp; Lower = Q1 &minus; 1.5&times;IQR &ensp;|&ensp; Upper = Q3 + 1.5&times;IQR
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Five-Number Summary</h3>
            <table class="stat-ops-table">
                <thead><tr><th>Measure</th><th>Percentile</th><th>Description</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Minimum</td><td>0th</td><td>Smallest value in the dataset</td></tr>
                    <tr><td style="font-weight:600;">Q1</td><td>25th</td><td>25% of data falls below this value</td></tr>
                    <tr><td style="font-weight:600;">Median (Q2)</td><td>50th</td><td>The middle value that splits data in half</td></tr>
                    <tr><td style="font-weight:600;">Q3</td><td>75th</td><td>75% of data falls below this value</td></tr>
                    <tr><td style="font-weight:600;">Maximum</td><td>100th</td><td>Largest value in the dataset</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Common Applications -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Applications of Percentiles</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Standardized Testing</h4>
                    <p>SAT, GRE, and IQ tests report percentile ranks so students can compare performance to the population of test-takers.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Salary &amp; Income</h4>
                    <p>Income percentiles help compare your salary to industry or national benchmarks. The 50th percentile is the median salary.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Growth Charts</h4>
                    <p>Pediatricians use percentile charts to track children&rsquo;s height and weight relative to age-matched populations.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>Performance SLAs</h4>
                    <p>Network engineers use P95 or P99 response times to set service-level agreements that account for tail latency.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is the difference between percentile and percentile rank?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A percentile is a value below which a certain percentage of observations fall. For example, the 90th percentile is the value below which 90% of data lies. Percentile rank is the reverse: given a specific value, it tells you what percentage of the dataset falls below that value.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How is the value at a percentile calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Data are sorted in ascending order. The position is calculated as L = (n+1) &times; p/100. If L is a whole number, use that position&rsquo;s value. If L is fractional, interpolate linearly between the two adjacent values. Different software may use slightly different interpolation methods.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are quartiles and how do they relate to percentiles?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Quartiles divide sorted data into four equal parts. Q1 is the 25th percentile (25% of data falls below it). Q2 is the 50th percentile (the median). Q3 is the 75th percentile. The interquartile range (IQR = Q3 &minus; Q1) measures the spread of the middle 50%.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How are outliers detected using IQR?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The IQR method flags values as potential outliers if they fall below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR. These boundaries are called fences. Values beyond 3&times;IQR from the quartiles are considered extreme outliers. Context matters &mdash; not all flagged points are errors.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is a five-number summary?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A five-number summary consists of the minimum, Q1, median, Q3, and maximum. It provides a concise description of data distribution and is the basis for box plot visualization. Together these five values show center, spread, and symmetry of the data.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Where are percentiles commonly used?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Percentiles are used in standardized testing (SAT, GRE), salary and income comparisons, pediatric growth charts, network performance monitoring (P95/P99 response times), and quality control to establish tolerance limits in manufacturing.</div>
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
    <script src="<%=request.getContextPath()%>/js/percentile-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
