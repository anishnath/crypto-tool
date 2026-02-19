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
        /* Z-score specific: select styling */
        .zs-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.875rem;background:var(--bg-primary);color:var(--text-primary);font-family:var(--font-sans)}
        .zs-select:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(225,29,72,0.1)}
        [data-theme="dark"] .zs-select{background:var(--bg-tertiary);border-color:var(--border)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Z-Score Calculator Online - Percentile &amp; Probability Free" />
        <jsp:param name="toolDescription" value="Convert raw scores to Z-scores, find probabilities and percentiles on the standard normal distribution. Interactive normal curve, step-by-step formulas, and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="z-score-calculator.jsp" />
        <jsp:param name="toolKeywords" value="z-score calculator, standard score calculator, z score to percentile, normal distribution calculator, z-table calculator, standard normal, percentile to z-score, probability calculator, standardization, inverse normal" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Raw score to Z-score conversion,Z-score to probability with area types,Percentile to Z-score inverse normal,Z-score to raw score denormalization,Interactive Plotly normal curve,Step-by-step KaTeX formulas,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Z-scores, standard normal distribution, standardization, percentiles, cumulative probability, inverse normal function" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select Score to Z or Z to Probability or Percentile to Z or Z to Score,Enter Values|Input your raw score mean and standard deviation or Z-score,Click Calculate|Get instant Z-score percentile and probability results,Review Steps|See step-by-step KaTeX formula derivation,View Normal Curve|Explore the interactive shaded normal distribution,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is a Z-score and how is it calculated?" />
        <jsp:param name="faq1a" value="A Z-score measures how many standard deviations a value is from the mean. The formula is Z equals x minus mu divided by sigma. A positive Z-score means the value is above the mean and a negative Z-score means it is below the mean. Z equals zero means the value equals the mean." />
        <jsp:param name="faq2q" value="How do I convert a Z-score to a percentile?" />
        <jsp:param name="faq2a" value="Use the standard normal cumulative distribution function. The percentile equals Phi of z times 100 percent where Phi is the CDF. For example Z equals 1.96 corresponds to the 97.5th percentile. This calculator does the lookup automatically." />
        <jsp:param name="faq3q" value="What is the 68-95-99.7 rule?" />
        <jsp:param name="faq3a" value="For normal distributions approximately 68 percent of data falls within plus or minus 1 standard deviation of the mean, 95 percent within plus or minus 2, and 99.7 percent within plus or minus 3. These correspond to Z-score ranges of negative 1 to 1, negative 2 to 2, and negative 3 to 3." />
        <jsp:param name="faq4q" value="What is the difference between left tail and right tail probability?" />
        <jsp:param name="faq4a" value="Left tail probability P of Z less than or equal to z is the area under the normal curve to the left of z. Right tail probability P of Z greater than or equal to z is the area to the right. They always sum to 1. Between plus or minus z gives the central area and outside gives the two tails combined." />
        <jsp:param name="faq5q" value="When should I use Z-scores versus t-scores?" />
        <jsp:param name="faq5a" value="Use Z-scores when the population standard deviation is known or the sample size is large, typically n greater than 30. Use t-scores when the population standard deviation is unknown and the sample is small. The t-distribution has heavier tails and approaches the normal as n increases." />
        <jsp:param name="faq6q" value="Can I use Z-scores with non-normal data?" />
        <jsp:param name="faq6a" value="You can always calculate Z-scores for any data but the probability and percentile interpretations assume normality. For non-normal data consider transforming the data first using log or Box-Cox transformations. The Central Limit Theorem helps when working with sample means of large samples." />
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
                <h1 class="tool-page-title">Z-Score Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Z-Score Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Score &harr; Z</span>
                <span class="tool-badge">Probability</span>
                <span class="tool-badge">Normal Curve</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>Z-score calculator</strong> with four modes: convert <strong>raw scores to Z-scores</strong>, find <strong>probabilities</strong> from Z, look up <strong>Z from percentile</strong>, or convert <strong>Z back to raw score</strong>. Interactive normal curve visualization, step-by-step KaTeX formulas, and Python scipy export.</p>
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
                    Z-Score Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Calculation Mode</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="zs-mode-score" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Score&rarr;Z</button>
                            <button type="button" class="stat-mode-btn" id="zs-mode-prob" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Z&rarr;Prob</button>
                            <button type="button" class="stat-mode-btn" id="zs-mode-percentile" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Pctl&rarr;Z</button>
                            <button type="button" class="stat-mode-btn" id="zs-mode-reverse" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Z&rarr;Score</button>
                        </div>
                    </div>

                    <!-- Score → Z inputs -->
                    <div id="zs-input-score">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-raw-score">Raw Score (x)</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-raw-score" value="85" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">The value you want to standardize</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-mean">Mean (&mu;)</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-mean" value="75" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-stddev">Standard Deviation (&sigma;)</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-stddev" value="10" step="any" min="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                    </div>

                    <!-- Z → Probability inputs -->
                    <div id="zs-input-prob" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-z-prob">Z-Score</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-z-prob" value="1.96" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-area-type">Area Type</label>
                            <select class="zs-select zs-input" id="zs-area-type">
                                <option value="left">Left tail P(Z &le; z)</option>
                                <option value="right">Right tail P(Z &ge; z)</option>
                                <option value="between">Between &plusmn;z</option>
                                <option value="outside">Outside &plusmn;z</option>
                            </select>
                        </div>
                    </div>

                    <!-- Percentile → Z inputs -->
                    <div id="zs-input-percentile" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-percentile">Percentile (%)</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-percentile" value="95" step="any" min="0.01" max="99.99" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">e.g. 95 for the 95th percentile</div>
                        </div>
                    </div>

                    <!-- Z → Score inputs -->
                    <div id="zs-input-reverse" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-z-reverse">Z-Score</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-z-reverse" value="1.5" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-mean-reverse">Mean (&mu;)</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-mean-reverse" value="100" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="zs-stddev-reverse">Standard Deviation (&sigma;)</label>
                            <input type="number" class="stat-input-text zs-input" id="zs-stddev-reverse" value="15" step="any" min="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="zs-calc-btn">Calculate Z-Score</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="zs-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-zs-example="sat">SAT Score</button>
                            <button type="button" class="stat-example-chip" data-zs-example="iq">IQ Score</button>
                            <button type="button" class="stat-example-chip" data-zs-example="95ci">95% CI</button>
                            <button type="button" class="stat-example-chip" data-zs-example="top5">Top 5%</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="zs-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="zs-graph-panel">Normal Curve</button>
                <button type="button" class="stat-output-tab" data-tab="zs-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="zs-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="zs-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter values and click Calculate</h3>
                            <p>Convert scores to Z-scores, find probabilities, percentiles, and more.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="zs-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="zs-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                        <h4>Normal Distribution Curve</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="zs-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the normal curve.</p></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="zs-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="zs-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="z-score-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is a Z-Score? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a Z-Score?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>Z-score</strong> (standard score) measures how many standard deviations a data point is from the mean. It standardizes values from different distributions onto a common scale, making comparisons possible.</p>

            <div class="stat-formula-box">
                <strong>Z-Score Formula:</strong>&nbsp; Z = (x &minus; &mu;) / &sigma;
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x2795;</div>
                    <h4>Positive Z</h4>
                    <p>Value is above the mean. Z = 1.5 means 1.5 standard deviations above average.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2796;</div>
                    <h4>Negative Z</h4>
                    <p>Value is below the mean. Z = &minus;2.0 means 2 standard deviations below average.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Zero Z</h4>
                    <p>Value equals the mean exactly. The 50th percentile on a normal distribution.</p>
                </div>
            </div>
        </div>

        <!-- 2. The 68-95-99.7 Rule -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The 68-95-99.7 Rule (Empirical Rule)</h2>

            <!-- Animated SVG Bell Curve -->
            <div style="text-align:center;margin-bottom:1.5rem;" class="stat-anim stat-anim-d1">
                <svg viewBox="0 0 500 200" style="max-width:500px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                    <!-- Bell curve path -->
                    <path d="M 30,170 C 60,170 80,168 110,160 C 140,148 160,120 180,80 C 200,45 220,20 250,15 C 280,20 300,45 320,80 C 340,120 360,148 390,160 C 420,168 440,170 470,170" fill="none" stroke="#e11d48" stroke-width="2.5" class="stat-bell-animated"/>
                    <!-- 68% region -->
                    <rect x="180" y="70" width="140" height="100" fill="rgba(225,29,72,0.08)" rx="2"/>
                    <text x="250" y="135" text-anchor="middle" fill="#e11d48" font-size="13" font-weight="600" font-family="Inter,sans-serif">68%</text>
                    <!-- 95% region -->
                    <rect x="110" y="140" width="280" height="20" fill="rgba(225,29,72,0.05)" rx="2"/>
                    <text x="250" y="155" text-anchor="middle" fill="#be123c" font-size="11" font-family="Inter,sans-serif">95%</text>
                    <!-- 99.7% region -->
                    <rect x="60" y="162" width="380" height="8" fill="rgba(225,29,72,0.03)" rx="1"/>
                    <!-- Labels -->
                    <text x="110" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&minus;2&sigma;</text>
                    <text x="180" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&minus;1&sigma;</text>
                    <text x="250" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-weight="600" font-family="Inter,sans-serif">&mu;</text>
                    <text x="320" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">+1&sigma;</text>
                    <text x="390" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">+2&sigma;</text>
                </svg>
            </div>

            <table class="stat-ops-table">
                <thead><tr><th>Range</th><th>Z-Score</th><th>% of Data</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">&mu; &plusmn; 1&sigma;</td><td>|Z| &le; 1</td><td>68.27%</td><td>Most values (typical)</td></tr>
                    <tr><td style="font-weight:600;">&mu; &plusmn; 2&sigma;</td><td>|Z| &le; 2</td><td>95.45%</td><td>Nearly all values</td></tr>
                    <tr><td style="font-weight:600;">&mu; &plusmn; 3&sigma;</td><td>|Z| &le; 3</td><td>99.73%</td><td>Virtually all values</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 3. Common Z-Scores Reference -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Z-Scores &amp; Percentiles</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Z-Score</th><th>Percentile</th><th>Interpretation</th></tr></thead>
                <tbody>
                    <tr><td>&minus;3.0</td><td>0.13%</td><td>Extremely low</td></tr>
                    <tr><td>&minus;2.0</td><td>2.28%</td><td>Significantly low</td></tr>
                    <tr><td>&minus;1.0</td><td>15.87%</td><td>Below average</td></tr>
                    <tr><td style="font-weight:700;">0.0</td><td style="font-weight:700;">50.00%</td><td style="font-weight:700;">Mean / Average</td></tr>
                    <tr><td>+1.0</td><td>84.13%</td><td>Above average</td></tr>
                    <tr><td>+1.645</td><td>95.00%</td><td>90% CI critical value</td></tr>
                    <tr><td>+1.960</td><td>97.50%</td><td>95% CI critical value</td></tr>
                    <tr><td>+2.0</td><td>97.72%</td><td>Significantly high</td></tr>
                    <tr><td>+2.576</td><td>99.50%</td><td>99% CI critical value</td></tr>
                    <tr><td>+3.0</td><td>99.87%</td><td>Extremely high</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Real-World Applications -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Standardized Testing</h4>
                    <p>SAT, ACT, and IQ scores use Z-scores to rank test-takers against the population and set percentile-based cutoffs.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Quality Control</h4>
                    <p>Manufacturing uses Six Sigma (Z = &plusmn;6) to maintain defect rates below 3.4 per million.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Finance &amp; Risk</h4>
                    <p>Stock returns are standardized for risk comparison. Value-at-Risk (VaR) models use Z-scores for tail risk estimation.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>Medical Research</h4>
                    <p>Growth charts, lab results, and BMI use Z-scores to compare patients against age/sex-matched reference populations.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is a Z-score and how is it calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A Z-score measures how many standard deviations a value is from the mean. The formula is Z = (x &minus; &mu;) / &sigma;. A positive Z means above the mean, negative means below, and zero means exactly at the mean.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I convert a Z-score to a percentile?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the standard normal CDF: Percentile = &Phi;(z) &times; 100%. For example, Z = 1.96 corresponds to the 97.5th percentile. This calculator performs the lookup automatically using jStat.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the 68-95-99.7 rule?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">For normal distributions: 68% of data falls within &plusmn;1&sigma;, 95% within &plusmn;2&sigma;, and 99.7% within &plusmn;3&sigma;. These correspond to Z-score ranges of &minus;1 to 1, &minus;2 to 2, and &minus;3 to 3.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between left and right tail probability?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Left tail P(Z &le; z) is the area under the curve to the left of z. Right tail P(Z &ge; z) is the area to the right. They always sum to 1. &ldquo;Between &plusmn;z&rdquo; gives the central area, and &ldquo;Outside &plusmn;z&rdquo; gives the combined two-tail area.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When should I use Z-scores versus t-scores?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use Z-scores when the population standard deviation is known or n &gt; 30. Use t-scores when &sigma; is unknown and the sample is small. The t-distribution has heavier tails but approaches the normal as n increases.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Can I use Z-scores with non-normal data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">You can calculate Z-scores for any data, but the probability and percentile interpretations assume normality. For non-normal data, consider log or Box-Cox transformations first. The Central Limit Theorem helps when working with sample means of large samples.</div>
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
    <script src="<%=request.getContextPath()%>/js/z-score-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
