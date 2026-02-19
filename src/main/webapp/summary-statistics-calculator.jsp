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
        <jsp:param name="toolName" value="Summary Statistics Calculator Online - Instant Results Free" />
        <jsp:param name="toolDescription" value="Paste your data for instant mean, median, mode, standard deviation, variance, quartiles, skewness and kurtosis. Interactive histogram and box plot included." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="summary-statistics-calculator.jsp" />
        <jsp:param name="toolKeywords" value="summary statistics calculator, descriptive statistics calculator, mean median mode calculator, standard deviation calculator online, variance calculator, quartiles calculator, IQR calculator, skewness kurtosis, data analysis tool, free statistics calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Mean median mode calculation,Standard deviation and variance (sample and population),Quartiles IQR five-number summary,Skewness and kurtosis with interpretation,Frequency distribution table,Interactive Plotly histogram and box plot,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Descriptive statistics, measures of central tendency, measures of dispersion, distribution shape analysis, box plot interpretation, outlier detection" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Options|Toggle histogram box plot and frequency table,Click Calculate|Get instant descriptive statistics,Review Results|See mean median mode SD variance quartiles,Explore Graph|View interactive histogram and box plot,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is the difference between sample and population standard deviation?" />
        <jsp:param name="faq1a" value="Sample standard deviation divides by n-1 (Bessel correction) because a sample underestimates variability. Population standard deviation divides by n because you have all data points. Use sample SD when analyzing a subset; use population SD when you have the entire dataset." />
        <jsp:param name="faq2q" value="How do I interpret skewness and kurtosis?" />
        <jsp:param name="faq2a" value="Skewness measures asymmetry: 0 means symmetric, positive means right-skewed (long right tail), negative means left-skewed. Kurtosis measures tail weight: 0 (excess) is normal, positive means heavier tails (leptokurtic), negative means lighter tails (platykurtic). Values between -0.5 and 0.5 are approximately symmetric or normal." />
        <jsp:param name="faq3q" value="What are quartiles and how are they calculated?" />
        <jsp:param name="faq3a" value="Quartiles divide sorted data into four equal parts. Q1 (25th percentile) has 25 percent of data below it. Q2 is the median. Q3 (75th percentile) has 75 percent below. The IQR (Q3 minus Q1) measures the spread of the middle 50 percent and is used for outlier detection." />
        <jsp:param name="faq4q" value="When should I use mean vs median?" />
        <jsp:param name="faq4a" value="Use the mean for symmetric data without outliers since it uses all values efficiently. Use the median for skewed data or data with outliers since it is resistant to extreme values. For example, median income is preferred over mean income because a few billionaires skew the mean upward." />
        <jsp:param name="faq5q" value="What does coefficient of variation tell you?" />
        <jsp:param name="faq5a" value="The coefficient of variation (CV) is the standard deviation divided by the mean, expressed as a percentage. It measures relative variability, allowing you to compare spread between datasets with different units or scales. A CV below 15 percent generally indicates low variability." />
        <jsp:param name="faq6q" value="How do I identify outliers in my data?" />
        <jsp:param name="faq6a" value="The IQR method flags values below Q1 minus 1.5 times IQR or above Q3 plus 1.5 times IQR as outliers. The z-score method flags values more than 2 or 3 standard deviations from the mean. Always investigate outliers before removing them as they may represent real phenomena." />
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
                <h1 class="tool-page-title">Summary Statistics Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Summary Statistics Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Instant Results</span>
                <span class="tool-badge">Histogram + Box Plot</span>
                <span class="tool-badge">Python Export</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>summary statistics calculator</strong> with instant results. Paste your data to compute <strong>mean, median, mode, standard deviation, variance, quartiles, skewness</strong> and <strong>kurtosis</strong>. Includes interactive <strong>histogram</strong> and <strong>box plot</strong>, frequency distribution table, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    Summary Statistics
                </div>
                <div class="tool-card-body">
                    <!-- Data Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="stat-data-input">Data Input</label>
                        <textarea class="stat-input-text" id="stat-data-input" rows="8" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86" spellcheck="false">85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86</textarea>
                        <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                    </div>

                    <!-- Preview -->
                    <div class="tool-form-group">
                        <div class="stat-preview" id="stat-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                    </div>

                    <!-- Options -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Display Options</label>
                        <div class="stat-checkbox-group">
                            <label class="stat-checkbox">
                                <input type="checkbox" id="stat-chk-histogram" checked>
                                Show Histogram
                            </label>
                            <label class="stat-checkbox">
                                <input type="checkbox" id="stat-chk-boxplot" checked>
                                Show Box Plot
                            </label>
                            <label class="stat-checkbox">
                                <input type="checkbox" id="stat-chk-frequency" checked>
                                Show Frequency Table
                            </label>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="stat-calc-btn">Calculate Statistics</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="stat-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                        <button type="button" class="tool-action-btn" id="stat-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="test-scores">Test Scores</button>
                            <button type="button" class="stat-example-chip" data-example="heights">Heights (cm)</button>
                            <button type="button" class="stat-example-chip" data-example="temperatures">Temperatures</button>
                            <button type="button" class="stat-example-chip" data-example="stock-returns">Stock Returns</button>
                            <button type="button" class="stat-example-chip" data-example="survey">Survey Data</button>
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
            <div class="stat-panel active" id="stat-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="stat-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter data and click Calculate</h3>
                            <p>Paste numbers separated by commas, spaces, or newlines for instant descriptive statistics.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="stat-result-actions">
                        <button type="button" class="tool-action-btn" id="stat-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="stat-share-btn">&#128279; Share</button>
                    </div>
                </div>
            </div>

            <!-- Graph Panel -->
            <div class="stat-panel" id="stat-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Interactive Charts</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="stat-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate statistics to see interactive charts.</p></div>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="stat-panel" id="stat-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="stat-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="summary-statistics-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Are Summary Statistics? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Summary Statistics?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Summary statistics (also called <strong>descriptive statistics</strong>) condense a dataset into a handful of meaningful numbers. Instead of looking at hundreds of raw values, you get three key aspects: <em>where</em> the data centers, <em>how spread out</em> it is, and <em>what shape</em> the distribution takes.</p>

            <!-- Animated SVG: Data funnel -->
            <svg viewBox="0 0 560 120" xmlns="http://www.w3.org/2000/svg" class="stat-data-flow" style="max-width:540px;width:100%;margin:1rem 0;">
                <rect x="0" y="0" width="560" height="120" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <!-- Data dots flowing in -->
                <circle class="data-dot" cx="60" cy="30" r="4" fill="#e11d48" style="animation-delay:0s;"/>
                <circle class="data-dot" cx="100" cy="50" r="4" fill="#e11d48" style="animation-delay:0.3s;"/>
                <circle class="data-dot" cx="80" cy="70" r="4" fill="#e11d48" style="animation-delay:0.6s;"/>
                <circle class="data-dot" cx="120" cy="40" r="4" fill="#e11d48" style="animation-delay:0.9s;"/>
                <circle class="data-dot" cx="50" cy="85" r="4" fill="#e11d48" style="animation-delay:1.2s;"/>
                <!-- Funnel -->
                <polygon points="160,15 280,15 250,105 190,105" fill="none" stroke="#e11d48" stroke-width="2"/>
                <text x="220" y="65" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">Analysis</text>
                <!-- Output labels -->
                <text x="340" y="35" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">Mean = 85.67</text>
                <text x="340" y="58" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">SD = 5.46</text>
                <text x="340" y="81" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">Q1, Q2, Q3</text>
                <text x="340" y="104" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">Skew = &minus;0.12</text>
            </svg>

            <div class="stat-edu-grid">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Central Tendency</h4>
                    <p>Mean, median, and mode tell you where the &ldquo;center&rdquo; of your data lies &mdash; the typical or representative value.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2194;&#xFE0F;</div>
                    <h4>Dispersion</h4>
                    <p>Range, variance, standard deviation, and IQR measure how spread out values are around the center.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4C8;</div>
                    <h4>Distribution Shape</h4>
                    <p>Skewness and kurtosis reveal whether data is symmetric, skewed, or has heavy/light tails.</p>
                </div>
            </div>
        </div>

        <!-- 2. Measures of Central Tendency -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Measures of Central Tendency</h2>

            <div class="stat-formula-box">
                <strong>Mean:</strong>&nbsp; x&#772; = &Sigma;x<sub>i</sub> / n
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">The <strong>arithmetic mean</strong> sums all values and divides by the count. It uses every data point, making it sensitive to outliers.</p>

            <div class="stat-formula-box">
                <strong>Median:</strong>&nbsp; Middle value when data is sorted
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">The <strong>median</strong> is the middle value of sorted data. For even n, it averages the two middle values. Resistant to outliers.</p>

            <div class="stat-formula-box">
                <strong>Mode:</strong>&nbsp; Most frequently occurring value(s)
            </div>
            <p style="color:var(--text-secondary);margin:0.5rem 0 1rem;line-height:1.7;">The <strong>mode</strong> is the value that appears most often. Data can be unimodal, bimodal, multimodal, or have no mode.</p>

            <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">When to Use Each Measure</h3>
            <table class="stat-ops-table">
                <thead><tr><th>Measure</th><th>Best For</th><th>Limitation</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Mean</td><td>Symmetric data, no outliers</td><td>Distorted by extreme values</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Median</td><td>Skewed data, outliers present</td><td>Ignores actual values of extremes</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Mode</td><td>Categorical data, finding peaks</td><td>May not exist or be unique</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 3. Measures of Dispersion -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Measures of Dispersion</h2>

            <div class="stat-formula-box">
                <strong>Variance:</strong>&nbsp; s&sup2; = &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2; / (n &minus; 1)
            </div>
            <div class="stat-formula-box">
                <strong>Standard Deviation:</strong>&nbsp; s = &radic;s&sup2;
            </div>
            <div class="stat-formula-box">
                <strong>Range:</strong>&nbsp; max &minus; min &nbsp;&nbsp; | &nbsp;&nbsp; <strong>IQR:</strong>&nbsp; Q3 &minus; Q1
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example</h3>
            <div class="stat-worked-example">
                <strong>Data:</strong> [2, 4, 4, 4, 5, 5, 7, 9]<br>
                <strong>Step 1:</strong> Mean = (2+4+4+4+5+5+7+9)/8 = 40/8 = <span style="color:var(--stat-tool);font-weight:700;">5</span><br>
                <strong>Step 2:</strong> Deviations from mean: &minus;3, &minus;1, &minus;1, &minus;1, 0, 0, 2, 4<br>
                <strong>Step 3:</strong> Squared deviations: 9, 1, 1, 1, 0, 0, 4, 16<br>
                <strong>Step 4:</strong> Sum of squares = 32<br>
                <strong>Step 5:</strong> Variance (sample) = 32/(8&minus;1) = <span style="color:var(--stat-tool);font-weight:700;">4.5714</span><br>
                <strong>Step 6:</strong> SD = &radic;4.5714 = <span style="color:var(--stat-tool);font-weight:700;">2.1381</span>
            </div>

            <!-- Animated bell curve with sigma markers -->
            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">The 68&ndash;95&ndash;99.7 Rule (Empirical Rule)</h3>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">For normally distributed data:</p>
            <svg viewBox="0 0 560 180" xmlns="http://www.w3.org/2000/svg" class="stat-bell-animated" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                <rect x="0" y="0" width="560" height="180" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <!-- Bell curve path -->
                <path class="bell-path" d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150" fill="none" stroke="#e11d48" stroke-width="2.5"/>
                <!-- Fill under curve -->
                <path d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150 Z" fill="rgba(225,29,72,0.08)"/>
                <!-- Sigma lines -->
                <line x1="280" y1="15" x2="280" y2="155" stroke="#94a3b8" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="180" y1="80" x2="180" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="380" y1="80" x2="380" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="100" y1="142" x2="100" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                <line x1="460" y1="142" x2="460" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                <!-- Labels -->
                <text x="280" y="172" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">&mu;</text>
                <text x="180" y="172" text-anchor="middle" font-size="9" fill="#10b981">&minus;1&sigma;</text>
                <text x="380" y="172" text-anchor="middle" font-size="9" fill="#10b981">+1&sigma;</text>
                <text x="100" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">&minus;2&sigma;</text>
                <text x="460" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">+2&sigma;</text>
                <!-- Percentage brackets -->
                <text x="280" y="98" text-anchor="middle" font-size="11" fill="#10b981" font-weight="600">68.3%</text>
                <text x="280" y="130" text-anchor="middle" font-size="10" fill="#f59e0b" font-weight="500">95.4%</text>
            </svg>
        </div>

        <!-- 4. Understanding Distribution Shape -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding Distribution Shape</h2>

            <h3 style="font-size:1rem;margin:0 0 0.75rem;color:var(--text-primary);">Skewness</h3>
            <svg viewBox="0 0 560 140" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                <rect x="0" y="0" width="560" height="140" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <!-- Left-skewed -->
                <path d="M 20,110 C 20,110 40,108 60,95 C 80,75 100,30 130,18 C 145,22 155,50 165,80 C 170,95 175,108 180,110 Z" fill="rgba(225,29,72,0.15)" stroke="#e11d48" stroke-width="1.5"/>
                <text x="100" y="130" text-anchor="middle" font-size="10" fill="var(--text-primary,#0f172a)" font-weight="600">Left-Skewed</text>
                <text x="100" y="10" text-anchor="middle" font-size="8" fill="var(--text-muted,#94a3b8)">skew &lt; 0</text>
                <!-- Symmetric -->
                <path d="M 210,110 C 210,110 240,105 260,70 C 270,45 275,22 280,18 C 285,22 290,45 300,70 C 320,105 350,110 350,110 Z" fill="rgba(16,185,129,0.15)" stroke="#10b981" stroke-width="1.5"/>
                <text x="280" y="130" text-anchor="middle" font-size="10" fill="var(--text-primary,#0f172a)" font-weight="600">Symmetric</text>
                <text x="280" y="10" text-anchor="middle" font-size="8" fill="var(--text-muted,#94a3b8)">skew &asymp; 0</text>
                <!-- Right-skewed -->
                <path d="M 380,110 C 385,108 390,95 395,80 C 400,50 410,22 430,18 C 460,30 480,75 500,95 C 520,108 540,110 540,110 Z" fill="rgba(245,158,11,0.15)" stroke="#f59e0b" stroke-width="1.5"/>
                <text x="460" y="130" text-anchor="middle" font-size="10" fill="var(--text-primary,#0f172a)" font-weight="600">Right-Skewed</text>
                <text x="460" y="10" text-anchor="middle" font-size="8" fill="var(--text-muted,#94a3b8)">skew &gt; 0</text>
            </svg>

            <table class="stat-ops-table">
                <thead><tr><th>|Skewness|</th><th>Interpretation</th></tr></thead>
                <tbody>
                    <tr><td>&lt; 0.5</td><td style="font-family:var(--font-sans);">Approximately symmetric</td></tr>
                    <tr><td>0.5 &ndash; 1.0</td><td style="font-family:var(--font-sans);">Moderately skewed</td></tr>
                    <tr><td>&gt; 1.0</td><td style="font-family:var(--font-sans);">Highly skewed</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.75rem;color:var(--text-primary);">Kurtosis</h3>
            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Mesokurtic (k &asymp; 0)</h4>
                    <p>Normal distribution shape. Tails contain roughly the expected proportion of data.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Leptokurtic (k &gt; 0)</h4>
                    <p>Peaked with heavy tails. More extreme values (outliers) than normal. Example: stock returns.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Platykurtic (k &lt; 0)</h4>
                    <p>Flat with light tails. Fewer extreme values than normal. Example: uniform-like data.</p>
                </div>
            </div>
        </div>

        <!-- 5. Quartiles & Box Plots -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Quartiles &amp; Box Plots</h2>

            <!-- Box plot diagram SVG -->
            <svg viewBox="0 0 560 140" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                <rect x="0" y="0" width="560" height="140" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <!-- Whiskers -->
                <line x1="80" y1="60" x2="160" y2="60" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                <line x1="400" y1="60" x2="480" y2="60" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                <!-- Whisker caps -->
                <line x1="80" y1="45" x2="80" y2="75" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                <line x1="480" y1="45" x2="480" y2="75" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                <!-- Box -->
                <rect x="160" y="35" width="240" height="50" fill="rgba(225,29,72,0.15)" stroke="#e11d48" stroke-width="2" rx="3"/>
                <!-- Median line -->
                <line x1="280" y1="35" x2="280" y2="85" stroke="#e11d48" stroke-width="2.5"/>
                <!-- Outlier -->
                <circle cx="520" cy="60" r="4" fill="none" stroke="#ef4444" stroke-width="1.5"/>
                <!-- Labels -->
                <text x="80" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)" font-weight="500">Min</text>
                <text x="160" y="105" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">Q1</text>
                <text x="280" y="105" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">Q2 (Median)</text>
                <text x="400" y="105" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">Q3</text>
                <text x="480" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)" font-weight="500">Max</text>
                <text x="520" y="105" text-anchor="middle" font-size="9" fill="#ef4444" font-weight="500">Outlier</text>
                <!-- IQR bracket -->
                <line x1="160" y1="120" x2="400" y2="120" stroke="#e11d48" stroke-width="1"/>
                <line x1="160" y1="116" x2="160" y2="124" stroke="#e11d48" stroke-width="1"/>
                <line x1="400" y1="116" x2="400" y2="124" stroke="#e11d48" stroke-width="1"/>
                <text x="280" y="134" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">IQR = Q3 &minus; Q1</text>
            </svg>

            <div class="stat-formula-box">
                <strong>Five-Number Summary:</strong>&nbsp; Min, Q1, Median, Q3, Max
            </div>
            <div class="stat-formula-box">
                <strong>Outlier Detection:</strong>&nbsp; value &lt; Q1 &minus; 1.5&times;IQR &nbsp;or&nbsp; value &gt; Q3 + 1.5&times;IQR
            </div>

            <p style="color:var(--text-secondary);margin:0.75rem 0;line-height:1.7;">The <strong>box plot</strong> (box-and-whisker) visualizes the five-number summary. The box spans Q1 to Q3 (the middle 50% of data), the line inside marks the median, and whiskers extend to the most extreme non-outlier values. Points beyond the fences appear as individual dots.</p>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is the difference between sample and population standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Sample standard deviation divides by n&minus;1 (Bessel&rsquo;s correction) because a sample underestimates variability. Population standard deviation divides by n because you have all data points. Use sample SD (s) when analyzing a subset of a larger population; use population SD (&sigma;) when you have the entire dataset. Our calculator shows both.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret skewness and kurtosis?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Skewness measures asymmetry: 0 means symmetric, positive means right-skewed (long right tail), negative means left-skewed. Kurtosis (excess) measures tail weight: 0 is normal, positive means heavier tails (leptokurtic), negative means lighter tails (platykurtic). Values between &minus;0.5 and 0.5 are approximately symmetric or normal.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are quartiles and how are they calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Quartiles divide sorted data into four equal parts. Q1 (25th percentile) has 25% of data below it. Q2 is the median. Q3 (75th percentile) has 75% below. The IQR (Q3 &minus; Q1) measures the spread of the middle 50% and is used for outlier detection: any value below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR is flagged.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When should I use mean vs median?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the mean for symmetric data without outliers &mdash; it uses all values efficiently. Use the median for skewed data or data with outliers &mdash; it is resistant to extreme values. For example, median income is preferred over mean income because a few billionaires skew the mean upward significantly.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What does coefficient of variation tell you?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The coefficient of variation (CV) is the standard deviation divided by the mean, expressed as a percentage. It measures relative variability, allowing you to compare spread between datasets with different units or scales. A CV below 15% generally indicates low variability; above 30% indicates high variability.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I identify outliers in my data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The IQR method flags values below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR as outliers (the same rule used in box plots). The z-score method flags values more than 2 or 3 standard deviations from the mean. Always investigate outliers before removing them &mdash; they may represent real phenomena or data entry errors.</div>
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
    <script src="<%=request.getContextPath()%>/js/summary-statistics-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
