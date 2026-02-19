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
        /* Mode toggle pills */
        .od-mode-toggle{display:flex;gap:0.375rem;flex-wrap:wrap;margin-top:0.25rem}
        .od-mode-btn{padding:0.375rem 0.75rem;border:1.5px solid var(--border);border-radius:9999px;background:var(--bg-primary);cursor:pointer;font-weight:600;color:var(--text-secondary);font-size:0.75rem;transition:all 0.15s;font-family:var(--font-sans)}
        .od-mode-btn:hover{border-color:var(--tool-primary)}
        .od-mode-btn.active{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .od-mode-btn{background:var(--bg-tertiary);border-color:var(--border)}
        [data-theme="dark"] .od-mode-btn.active{background:var(--tool-light);color:var(--tool-primary);border-color:var(--tool-primary)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Outlier Detection Calculator Online - IQR Z-Score MAD Free" />
        <jsp:param name="toolDescription" value="Detect outliers using IQR method Z-score and Modified Z-score MAD. Compare all methods identify consensus outliers with interactive scatter plot and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="outlier-detection-calculator.jsp" />
        <jsp:param name="toolKeywords" value="outlier detection calculator, outlier calculator, IQR method, z-score outliers, modified z-score, MAD, Tukey fences, box plot outliers, anomaly detection, outlier analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="IQR method with configurable Tukey fence multiplier,Z-score outlier detection with threshold selection,Modified Z-score using median absolute deviation,Compare all three methods with consensus detection,Interactive Plotly scatter plot with outliers highlighted,Data summary statistics with interpretation,Python numpy outlier detection code generation" />
        <jsp:param name="teaches" value="Outlier detection, IQR method, Tukey fences, Z-score, modified Z-score, MAD, robust statistics, data quality" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Method|Select IQR Z-score Modified Z or Compare All,Set Threshold|Adjust sensitivity with method-specific thresholds,Click Detect|Identify outliers with detailed analysis,View Scatter Plot|See data points with outliers highlighted in red,Export Code|Run Python numpy outlier detection code" />
        <jsp:param name="faq1q" value="Which outlier detection method should I use?" />
        <jsp:param name="faq1a" value="Use IQR with k equals 1.5 for general purpose robust detection. Use Z-score for normally distributed data. Use Modified Z-score MAD for small samples or when you suspect many outliers. Use Compare All to see consensus across methods." />
        <jsp:param name="faq2q" value="What is the IQR method for outlier detection?" />
        <jsp:param name="faq2a" value="The IQR method uses Tukey fences. Values below Q1 minus k times IQR or above Q3 plus k times IQR are outliers. With k equals 1.5 these are mild outliers and k equals 3.0 identifies extreme outliers only." />
        <jsp:param name="faq3q" value="Should I always remove outliers from my data?" />
        <jsp:param name="faq3a" value="No. First investigate whether outliers are data entry errors measurement errors or genuine extreme values. Only remove if they are clearly erroneous. For genuine outliers consider robust statistical methods or analyze with and without them." />
        <jsp:param name="faq4q" value="What is the Modified Z-score and why use it?" />
        <jsp:param name="faq4a" value="The Modified Z-score uses median and MAD instead of mean and standard deviation. The formula is 0.6745 times x minus median divided by MAD. It is more robust because outliers do not affect the median or MAD as they affect the mean and SD." />
        <jsp:param name="faq5q" value="What are common thresholds for outlier detection?" />
        <jsp:param name="faq5a" value="For IQR method k equals 1.5 is standard for mild outliers and 3.0 for extreme. For Z-score an absolute value greater than 3 is typical. For Modified Z-score the recommended threshold is 3.5 by Iglewicz and Hoaglin." />
        <jsp:param name="faq6q" value="How does the Compare All method work?" />
        <jsp:param name="faq6a" value="Compare All runs IQR Z-score and Modified Z-score simultaneously with default thresholds. Consensus outliers are values flagged by all three methods making them strong candidates for investigation or removal." />
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
                <h1 class="tool-page-title">Outlier Detection Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Outlier Detection Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">IQR &amp; Z-Score</span>
                <span class="tool-badge">Modified Z (MAD)</span>
                <span class="tool-badge">Compare All</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>outlier detection calculator</strong> using <strong>IQR</strong>, <strong>Z-score</strong>, and <strong>Modified Z-score (MAD)</strong>. Compare all methods, identify consensus outliers, visualize with interactive scatter plot, and export Python numpy code.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    Outlier Detection
                </div>
                <div class="tool-card-body">
                    <!-- Data Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="od-data-input">Data</label>
                        <textarea class="stat-input-text" id="od-data-input" rows="6" style="font-family:var(--font-mono);resize:vertical;">10, 12, 15, 18, 20, 22, 25, 28, 30, 95</textarea>
                        <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                    </div>

                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Detection Method</label>
                        <div class="od-mode-toggle">
                            <button type="button" class="od-mode-btn active" data-mode="iqr">IQR Method</button>
                            <button type="button" class="od-mode-btn" data-mode="zscore">Z-Score</button>
                            <button type="button" class="od-mode-btn" data-mode="modified">Modified Z</button>
                            <button type="button" class="od-mode-btn" data-mode="all">Compare All</button>
                        </div>
                    </div>

                    <!-- IQR Options -->
                    <div id="od-options-iqr">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="od-iqr-k">IQR Multiplier (k)</label>
                            <select class="stat-input-text" id="od-iqr-k" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="1.5" selected>1.5 (Standard &mdash; Mild Outliers)</option>
                                <option value="3.0">3.0 (Extreme Outliers Only)</option>
                                <option value="2.0">2.0 (Moderate)</option>
                                <option value="1.0">1.0 (Very Sensitive)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Z-Score Options -->
                    <div id="od-options-zscore" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="od-z-threshold">Z-Score Threshold</label>
                            <select class="stat-input-text" id="od-z-threshold" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="2.0">2.0 (Moderate)</option>
                                <option value="2.5">2.5</option>
                                <option value="3.0" selected>3.0 (Standard)</option>
                                <option value="3.5">3.5 (Conservative)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Modified Z Options -->
                    <div id="od-options-modified" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="od-mad-threshold">Modified Z-Score Threshold</label>
                            <select class="stat-input-text" id="od-mad-threshold" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="2.5">2.5 (Moderate)</option>
                                <option value="3.0">3.0 (Standard)</option>
                                <option value="3.5" selected>3.5 (Conservative &mdash; Recommended)</option>
                                <option value="4.0">4.0 (Very Conservative)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="od-calc-btn">Detect Outliers</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="od-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-od-example="test-scores">Test Scores</button>
                            <button type="button" class="stat-example-chip" data-od-example="temperatures">Temperatures</button>
                            <button type="button" class="stat-example-chip" data-od-example="salaries">Salaries</button>
                            <button type="button" class="stat-example-chip" data-od-example="clean-data">Clean Data</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="od-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="od-graph-panel">Scatter Plot</button>
                <button type="button" class="stat-output-tab" data-tab="od-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="od-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="od-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F50D;</div>
                            <h3>Enter data and click Detect Outliers</h3>
                            <p>Identify outliers using IQR, Z-score, or Modified Z-score methods.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="od-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="od-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>Scatter Plot</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="od-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="od-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="od-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="outlier-detection-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is an Outlier? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is an Outlier?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">An <strong>outlier</strong> is a data point that differs significantly from other observations. Outliers can arise from measurement errors, data entry mistakes, or genuine extreme values. Detecting them is critical for data quality and accurate statistical analysis.</p>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4CA;</div>
                    <h4>Data Quality</h4>
                    <p>Outliers can skew means, inflate standard deviations, and distort regression models. Identifying them improves the reliability of your analysis.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x26A0;&#xFE0F;</div>
                    <h4>Error Detection</h4>
                    <p>Many outliers result from typos, sensor malfunctions, or recording errors. Flagging them helps catch mistakes before they propagate.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2B50;</div>
                    <h4>Genuine Extremes</h4>
                    <p>Some outliers are real &mdash; record temperatures, viral posts, or rare events. These may be the most interesting data points to study.</p>
                </div>
            </div>
        </div>

        <!-- 2. IQR Method (Tukey's Fences) -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">IQR Method (Tukey&rsquo;s Fences)</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Lower Fence</strong> = Q1 &minus; k &times; IQR &nbsp;&nbsp;&nbsp; <strong>Upper Fence</strong> = Q3 + k &times; IQR
            </div>
            <div class="stat-formula-box" style="margin-bottom:1rem;">
                <strong>IQR</strong> = Q3 &minus; Q1 &nbsp;&nbsp;(Interquartile Range)
            </div>

            <div class="stat-worked-example" style="margin-bottom:1rem;">
                <strong>Worked Example:</strong> Data: 2, 4, 5, 7, 8, 9, 10, 12, 50 with k = 1.5
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    Q1 = 4.5, Q3 = 10.5, IQR = 6.0<br>
                    Lower Fence = 4.5 &minus; 1.5 &times; 6 = &minus;4.5<br>
                    Upper Fence = 10.5 + 1.5 &times; 6 = 19.5<br>
                    Outlier: <strong>50</strong> (above upper fence of 19.5)
                </div>
            </div>

            <p style="color:var(--text-secondary);font-size:0.875rem;line-height:1.7;margin-bottom:1rem;"><strong>Advantages:</strong> Distribution-free (no normality assumption), robust to extreme values, widely used in exploratory data analysis and box plots.</p>

            <!-- SVG: Box Plot Diagram -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 440 120" style="max-width:440px;width:100%;" aria-label="Box plot diagram showing Q1, Q2, Q3, whiskers, and outlier points">
                    <!-- Axis -->
                    <line x1="20" y1="90" x2="420" y2="90" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                    <!-- Whisker left -->
                    <line x1="60" y1="50" x2="130" y2="50" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                    <line x1="60" y1="40" x2="60" y2="60" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                    <!-- Box -->
                    <rect x="130" y="35" width="120" height="30" fill="var(--tool-light)" stroke="#e11d48" stroke-width="2" rx="3"/>
                    <!-- Median line -->
                    <line x1="190" y1="35" x2="190" y2="65" stroke="#e11d48" stroke-width="3"/>
                    <!-- Whisker right -->
                    <line x1="250" y1="50" x2="320" y2="50" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                    <line x1="320" y1="40" x2="320" y2="60" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                    <!-- Outlier points -->
                    <circle cx="370" cy="50" r="6" fill="none" stroke="#ef4444" stroke-width="2"/>
                    <circle cx="395" cy="50" r="6" fill="none" stroke="#ef4444" stroke-width="2"/>
                    <!-- Labels -->
                    <text x="60" y="80" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">Min</text>
                    <text x="130" y="80" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)" font-weight="600">Q1</text>
                    <text x="190" y="80" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">Q2</text>
                    <text x="250" y="80" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)" font-weight="600">Q3</text>
                    <text x="320" y="80" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">Max</text>
                    <text x="382" y="30" text-anchor="middle" font-size="10" fill="#ef4444" font-weight="600">Outliers</text>
                    <!-- Fence labels -->
                    <text x="40" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">Lower Fence</text>
                    <text x="340" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">Upper Fence</text>
                </svg>
            </div>
        </div>

        <!-- 3. Z-Score Method -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Z-Score Method</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Z-Score:</strong>&nbsp; Z = (x &minus; &mu;) / &sigma; &nbsp;&nbsp;&nbsp; Outlier if |Z| &gt; threshold
            </div>

            <p style="color:var(--text-secondary);font-size:0.875rem;line-height:1.7;margin-bottom:0.75rem;">The Z-score measures how many standard deviations a data point is from the mean. A common threshold is |Z| &gt; 3, meaning the value is more than 3 standard deviations away from the average.</p>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-top:1rem;">
                <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--success);">
                    <p style="margin:0;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                        <strong style="color:var(--success);">Pros:</strong> Simple, intuitive, works well for normally distributed data. Easy to interpret &mdash; Z = 2.5 means 2.5 standard deviations from the mean.
                    </p>
                </div>
                <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--error);">
                    <p style="margin:0;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                        <strong style="color:var(--error);">Cons:</strong> Sensitive to outliers themselves (masking effect). The mean and SD are pulled toward outliers, making them harder to detect.
                    </p>
                </div>
            </div>
        </div>

        <!-- 4. Modified Z-Score (MAD) -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Modified Z-Score (MAD)</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Modified Z-Score:</strong>&nbsp; M = 0.6745 &times; (x &minus; median) / MAD
            </div>
            <div class="stat-formula-box" style="margin-bottom:1rem;">
                <strong>MAD</strong> = median(|x<sub>i</sub> &minus; median(x)|) &nbsp;&nbsp;(Median Absolute Deviation)
            </div>

            <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);margin-bottom:1rem;">
                <p style="margin:0;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Why 0.6745?</strong> This constant is the 0.75th quantile of the standard normal distribution. It scales the MAD so that it is a consistent estimator of the standard deviation for normally distributed data, making the modified Z-score comparable to the regular Z-score.
                </p>
            </div>

            <p style="color:var(--text-secondary);font-size:0.875rem;line-height:1.7;"><strong>Advantages:</strong> Very robust &mdash; the median and MAD are not affected by outliers (unlike mean and SD). Works well with small samples, skewed distributions, and datasets with many outliers. Recommended threshold: 3.5 (Iglewicz &amp; Hoaglin).</p>
        </div>

        <!-- 5. Which Method to Choose? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Which Method to Choose?</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Scenario</th><th>Recommended Method</th></tr></thead>
                <tbody>
                    <tr><td>General purpose</td><td style="font-weight:600;">IQR (k = 1.5)</td></tr>
                    <tr><td>Normal distribution assumed</td><td style="font-weight:600;">Z-Score (threshold = 3)</td></tr>
                    <tr><td>Skewed data</td><td style="font-weight:600;">IQR or Modified Z-Score</td></tr>
                    <tr><td>Small sample size</td><td style="font-weight:600;">Modified Z-Score (MAD)</td></tr>
                    <tr><td>Many outliers suspected</td><td style="font-weight:600;">Modified Z-Score (MAD)</td></tr>
                    <tr><td>Conservative detection</td><td style="font-weight:600;">IQR (k = 3.0)</td></tr>
                </tbody>
            </table>

            <div style="margin-top:1.25rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0 0 0.5rem;font-size:0.875rem;font-weight:600;color:var(--text-primary);">What to Do with Outliers</p>
                <ul style="margin:0;padding-left:1.25rem;font-size:0.8125rem;color:var(--text-secondary);line-height:1.8;">
                    <li><strong>Investigate:</strong> Determine why the value is extreme before taking action</li>
                    <li><strong>Correct:</strong> Fix data entry or measurement errors</li>
                    <li><strong>Remove:</strong> Delete only if clearly erroneous</li>
                    <li><strong>Transform:</strong> Apply log or winsorization to reduce impact</li>
                    <li><strong>Keep:</strong> Retain genuine extreme values and use robust methods</li>
                    <li><strong>Separate Analysis:</strong> Analyze with and without outliers to assess their influence</li>
                </ul>
            </div>
        </div>

        <!-- 6. Frequently Asked Questions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">Which outlier detection method should I use?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use IQR with k = 1.5 for general-purpose robust detection. Use Z-score for normally distributed data. Use Modified Z-score (MAD) for small samples or when you suspect many outliers. Use Compare All to see consensus across all three methods.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the IQR method for outlier detection?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The IQR method uses Tukey fences. Values below Q1 &minus; k &times; IQR or above Q3 + k &times; IQR are classified as outliers. With k = 1.5, these are mild outliers; with k = 3.0, only extreme outliers are flagged.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Should I always remove outliers from my data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">No. First investigate whether outliers are data entry errors, measurement errors, or genuine extreme values. Only remove if they are clearly erroneous. For genuine outliers, consider robust statistical methods or analyze with and without them.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the Modified Z-score and why use it?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The Modified Z-score uses the median and MAD instead of the mean and standard deviation. The formula is 0.6745 &times; (x &minus; median) / MAD. It is more robust because outliers do not affect the median or MAD the way they affect the mean and SD.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are common thresholds for outlier detection?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">For the IQR method, k = 1.5 is standard for mild outliers and k = 3.0 for extreme. For Z-score, |Z| &gt; 3 is typical. For Modified Z-score, the recommended threshold is 3.5 (Iglewicz &amp; Hoaglin).</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How does the Compare All method work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Compare All runs IQR, Z-score, and Modified Z-score simultaneously with their default thresholds. Consensus outliers are values flagged by all three methods, making them strong candidates for investigation or removal.</div>
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
    <script src="<%=request.getContextPath()%>/js/outlier-detection-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>