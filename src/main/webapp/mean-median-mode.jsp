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
        <jsp:param name="toolName" value="Mean Median Mode Calculator Online - Instant Results Free" />
        <jsp:param name="toolDescription" value="Paste your data to instantly calculate mean, median, and mode with outlier detection, sorted values, interactive histogram, box plot, and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="mean-median-mode.jsp" />
        <jsp:param name="toolKeywords" value="mean median mode calculator, average calculator online, central tendency calculator, outlier detection, IQR calculator, histogram maker, descriptive statistics, mode finder, median calculator, free statistics tool" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Mean median and mode calculation,Step-by-step KaTeX formula display,Sorted values with color-coded highlights,IQR-based outlier detection,Interactive Plotly histogram and box plot,Python numpy and scipy code generation,LaTeX export and share URL,Handles bimodal and multimodal data" />
        <jsp:param name="teaches" value="Central tendency, mean vs median vs mode, outlier detection, IQR method, frequency distribution, data analysis basics" />
        <jsp:param name="educationalLevel" value="Middle School, High School, College" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Click Calculate|Get instant mean median and mode results,Review Steps|See step-by-step formulas with KaTeX rendering,Check Outliers|View IQR-based outlier detection with fences,Explore Charts|See interactive histogram and box plot,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="When should I use the mean vs the median?" />
        <jsp:param name="faq1a" value="Use the mean for symmetric data without outliers since it uses all values efficiently. Use the median for skewed data or data with outliers since it is resistant to extreme values. For example, median household income is preferred over mean because a few billionaires skew the average upward." />
        <jsp:param name="faq2q" value="What if there are multiple modes?" />
        <jsp:param name="faq2a" value="Data can be bimodal (two modes) or multimodal (many modes). Our calculator reports all values that share the highest frequency. If every value appears equally often there is no mode. Bimodal data often suggests two distinct groups in your dataset." />
        <jsp:param name="faq3q" value="How do outliers affect mean median and mode?" />
        <jsp:param name="faq3a" value="Outliers strongly pull the mean toward extreme values but have limited impact on the median and no effect on the mode. This is why the median is preferred for skewed distributions. The IQR method flags values below Q1 minus 1.5 times IQR or above Q3 plus 1.5 times IQR as outliers." />
        <jsp:param name="faq4q" value="What is the difference between mean median and mode?" />
        <jsp:param name="faq4a" value="The mean is the arithmetic average (sum divided by count). The median is the middle value when data is sorted. The mode is the most frequently occurring value. For symmetric data all three are similar. For skewed data they diverge with the mean pulled toward the tail." />
        <jsp:param name="faq5q" value="Can a dataset have no mode?" />
        <jsp:param name="faq5a" value="Yes. If every value in the dataset appears exactly once or all values appear with equal frequency then there is no mode. This is common with continuous data or small samples where repeats are unlikely." />
        <jsp:param name="faq6q" value="How are quartiles calculated?" />
        <jsp:param name="faq6a" value="Sort the data then split into two halves. Q1 is the median of the lower half and Q3 is the median of the upper half. The IQR (interquartile range) is Q3 minus Q1 and represents the spread of the middle 50 percent of your data." />
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
                <h1 class="tool-page-title">Mean, Median, Mode Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Mean, Median, Mode Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Outlier Detection</span>
                <span class="tool-badge">Histogram + Box Plot</span>
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>mean, median, mode calculator</strong> with instant results. Paste your data to compute all three <strong>measures of central tendency</strong>, detect <strong>outliers</strong> using the IQR method, view <strong>sorted values</strong> with color-coded highlights, and explore interactive <strong>histogram</strong> and <strong>box plot</strong>.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <circle cx="12" cy="12" r="10"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="12" y1="8" x2="12" y2="16"/>
                    </svg>
                    Mean, Median, Mode
                </div>
                <div class="tool-card-body">
                    <!-- Data Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="mmm-data-input">Data Input</label>
                        <textarea class="stat-input-text" id="mmm-data-input" rows="7" placeholder="12, 15, 15, 21, 28, 35, 35, 35, 42" spellcheck="false">72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79, 85, 90, 85</textarea>
                        <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                    </div>

                    <!-- Preview -->
                    <div class="tool-form-group">
                        <div class="stat-preview" id="mmm-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="mmm-calc-btn">Calculate Mean, Median, Mode</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="mmm-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                        <button type="button" class="tool-action-btn" id="mmm-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="test-scores">Test Scores</button>
                            <button type="button" class="stat-example-chip" data-example="shoe-sizes">Shoe Sizes</button>
                            <button type="button" class="stat-example-chip" data-example="temperatures">Temperatures</button>
                            <button type="button" class="stat-example-chip" data-example="dice-rolls">Dice Rolls</button>
                            <button type="button" class="stat-example-chip" data-example="with-outliers">With Outliers</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-panel="result">Result</button>
                <button type="button" class="stat-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="stat-output-tab" data-panel="python">Python Compiler</button>
            </div>

            <!-- Result Panel -->
            <div class="stat-panel active" id="mmm-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="mmm-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter data and click Calculate</h3>
                            <p>Paste numbers to find mean, median, mode with step-by-step solution.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="mmm-result-actions"></div>
                </div>
            </div>

            <!-- Graph Panel -->
            <div class="stat-panel" id="mmm-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Histogram &amp; Box Plot</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="mmm-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see histogram and box plot.</p></div>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="stat-panel" id="mmm-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="mmm-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="mean-median-mode.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Are Mean, Median, and Mode? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Mean, Median, and Mode?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Mean, median, and mode are the three <strong>measures of central tendency</strong> &mdash; they each describe the &ldquo;center&rdquo; of a dataset in different ways. Understanding when to use each one is a fundamental skill in statistics.</p>

            <div class="stat-edu-grid">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x2795;</div>
                    <h4>Mean (Average)</h4>
                    <p>Sum all values, divide by count. Uses every data point. Sensitive to outliers.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Median (Middle)</h4>
                    <p>Sort data, pick the middle value. Robust to outliers. Best for skewed data.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4CA;</div>
                    <h4>Mode (Most Frequent)</h4>
                    <p>The value that appears most often. Works for categorical data too. May not be unique.</p>
                </div>
            </div>
        </div>

        <!-- 2. Formulas & Definitions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Formulas &amp; Definitions</h2>

            <div class="stat-formula-box">
                <strong>Mean:</strong>&nbsp; x&#772; = &Sigma;x<sub>i</sub> / n
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">The <strong>arithmetic mean</strong> sums all values and divides by the count. It is the balance point of the data and uses every value in the calculation.</p>

            <div class="stat-formula-box">
                <strong>Median:</strong>&nbsp; Middle value of sorted data; for even n, average of two middle values
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">Sort the data from smallest to largest. If n is odd, the median is x<sub>((n+1)/2)</sub>. If n is even, it is the average of x<sub>(n/2)</sub> and x<sub>(n/2+1)</sub>.</p>

            <div class="stat-formula-box">
                <strong>Mode:</strong>&nbsp; Value(s) with the highest frequency
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 1rem;line-height:1.7;">Count how often each value appears. The mode is the one with the highest count. Data can be <strong>unimodal</strong> (one mode), <strong>bimodal</strong> (two), <strong>multimodal</strong> (many), or have <strong>no mode</strong> (all equally frequent).</p>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example</h3>
            <div class="stat-worked-example">
                <strong>Data:</strong> [3, 7, 7, 12, 15, 20, 25]<br>
                <strong>Mean:</strong> (3+7+7+12+15+20+25)/7 = 89/7 = <span style="color:var(--stat-tool);font-weight:700;">12.714</span><br>
                <strong>Median:</strong> 7 values &rarr; middle = x<sub>4</sub> = <span style="color:var(--stat-tool);font-weight:700;">12</span><br>
                <strong>Mode:</strong> 7 appears twice (most frequent) &rarr; <span style="color:var(--stat-tool);font-weight:700;">7</span>
            </div>
        </div>

        <!-- 3. When to Use Which -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">When to Use Which Measure</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Measure</th><th>Best For</th><th>Weakness</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Mean</td><td>Symmetric data, no outliers</td><td>Pulled by extreme values</td><td>Average test score in a class</td></tr>
                    <tr><td style="font-weight:600;">Median</td><td>Skewed data, outliers present</td><td>Ignores actual extreme values</td><td>Median household income</td></tr>
                    <tr><td style="font-weight:600;">Mode</td><td>Categorical data, finding peaks</td><td>May not exist or be unique</td><td>Most popular shoe size</td></tr>
                </tbody>
            </table>

            <!-- Visual: effect of outlier on mean vs median -->
            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">How Outliers Affect the Mean</h3>
            <svg viewBox="0 0 560 100" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:0.5rem 0;">
                <rect x="0" y="0" width="560" height="100" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <!-- Number line -->
                <line x1="40" y1="50" x2="520" y2="50" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                <!-- Data points (clustered) -->
                <circle cx="120" cy="50" r="5" fill="#e11d48"/><circle cx="145" cy="50" r="5" fill="#e11d48"/>
                <circle cx="160" cy="50" r="5" fill="#e11d48"/><circle cx="180" cy="50" r="5" fill="#e11d48"/>
                <circle cx="195" cy="50" r="5" fill="#e11d48"/><circle cx="210" cy="50" r="5" fill="#e11d48"/>
                <!-- Outlier -->
                <circle cx="480" cy="50" r="6" fill="none" stroke="#ef4444" stroke-width="2"/>
                <text x="480" y="30" text-anchor="middle" font-size="9" fill="#ef4444" font-weight="600">Outlier</text>
                <!-- Median marker -->
                <line x1="170" y1="60" x2="170" y2="80" stroke="#10b981" stroke-width="2"/>
                <text x="170" y="93" text-anchor="middle" font-size="9" fill="#10b981" font-weight="600">Median</text>
                <!-- Mean marker (pulled right by outlier) -->
                <line x1="250" y1="60" x2="250" y2="80" stroke="#f59e0b" stroke-width="2"/>
                <text x="250" y="93" text-anchor="middle" font-size="9" fill="#f59e0b" font-weight="600">Mean &rarr;</text>
            </svg>
            <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;">The outlier pulls the <span style="color:#f59e0b;font-weight:600;">mean</span> to the right, while the <span style="color:#10b981;font-weight:600;">median</span> stays near the cluster of data points.</p>
        </div>

        <!-- 4. Understanding Outliers -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding Outlier Detection</h2>

            <div class="stat-formula-box">
                <strong>IQR Method:</strong>&nbsp; Outlier if value &lt; Q1 &minus; 1.5&times;IQR &nbsp;or&nbsp; value &gt; Q3 + 1.5&times;IQR
            </div>

            <p style="color:var(--text-secondary);margin:0.75rem 0;line-height:1.7;">The <strong>IQR (Interquartile Range)</strong> method is the most common approach for outlier detection. It uses the spread of the middle 50% of data (Q1 to Q3) to define &ldquo;fences&rdquo; beyond which values are considered unusually extreme.</p>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Don&rsquo;t Auto-Remove</h4>
                    <p>Outliers may be real data (e.g., a CEO&rsquo;s salary). Always investigate before removing them.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Report Both Measures</h4>
                    <p>When outliers exist, report both mean and median to give a complete picture of the data.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Alternative Methods</h4>
                    <p>Z-score method (|z| &gt; 2 or 3), modified Z-score, Grubbs&rsquo; test, or visual inspection with box plots.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">When should I use the mean vs the median?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the mean for symmetric data without outliers &mdash; it uses all values efficiently. Use the median for skewed data or data with outliers &mdash; it is resistant to extreme values. For example, median household income is preferred over mean income because a few billionaires skew the average upward.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What if there are multiple modes?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Data can be bimodal (two modes) or multimodal (many modes). Our calculator reports all values that share the highest frequency. If every value appears equally often, there is no mode. Bimodal data often suggests two distinct groups in your dataset.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do outliers affect mean, median, and mode?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Outliers strongly pull the mean toward extreme values but have limited impact on the median and no effect on the mode. This is why the median is preferred for skewed distributions. The IQR method flags values below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR as outliers.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between mean, median, and mode?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The mean is the arithmetic average (sum divided by count). The median is the middle value when data is sorted. The mode is the most frequently occurring value. For symmetric data all three are similar. For skewed data they diverge, with the mean pulled toward the tail.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Can a dataset have no mode?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Yes. If every value in the dataset appears exactly once, or all values appear with equal frequency, then there is no mode. This is common with continuous data or small samples where repeats are unlikely.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How are quartiles calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Sort the data, then split into two halves. Q1 is the median of the lower half and Q3 is the median of the upper half. The IQR (interquartile range) is Q3 &minus; Q1 and represents the spread of the middle 50% of your data.</div>
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
    <script src="<%=request.getContextPath()%>/js/mean-median-mode-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
