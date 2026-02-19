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
        /* T-test two-group grid */
        .tt-two-group{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem}
        .tt-group-label{font-size:0.75rem;font-weight:600;color:var(--tool-primary);margin-bottom:0.5rem}
        @media(max-width:480px){.tt-two-group{grid-template-columns:1fr}}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="T-Test Calculator Online - One Sample Two Sample Paired Welch Free" />
        <jsp:param name="toolDescription" value="Perform one-sample two-sample paired and Welch t-tests. Get t-statistic p-value degrees of freedom critical value confidence interval Cohen d effect size with t-distribution chart and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="t-test-calculator.jsp" />
        <jsp:param name="toolKeywords" value="t-test calculator, student t test, one sample t test, two sample t test, paired t test, welch t test, t statistic, p value calculator, degrees of freedom, critical value, cohen d effect size, hypothesis testing calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="One-sample t-test vs known mean,Two-sample independent t-test with pooled variance,Paired t-test for before/after data,Welch t-test for unequal variances,P-value and critical value calculation,Cohen d effect size,Confidence interval for mean difference,Interactive Plotly t-distribution chart,Python scipy code generation" />
        <jsp:param name="teaches" value="T-tests, hypothesis testing, p-value, statistical significance, degrees of freedom, effect size, t-distribution" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Test Type|Select one-sample or two-sample or paired or Welch t-test,Enter Data|Paste sample data comma or space separated,Set Parameters|Choose significance level and alternative hypothesis direction,Click Calculate|Get t-statistic p-value CI and effect size instantly,View Distribution|See t-distribution curve with rejection regions,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="Which t-test should I use?" />
        <jsp:param name="faq1a" value="Use one-sample to compare a mean to a known value. Use independent two-sample when groups are unrelated with similar variances. Use paired for before/after or matched data. Use Welch when group variances differ or you are unsure about equal variances." />
        <jsp:param name="faq2q" value="What does the p-value tell me?" />
        <jsp:param name="faq2a" value="The p-value is the probability of observing data as extreme as yours if the null hypothesis is true. A small p-value below alpha suggests the data is unlikely under the null so you reject it." />
        <jsp:param name="faq3q" value="What is Cohen d and why does it matter?" />
        <jsp:param name="faq3a" value="Cohen d measures effect size or practical significance. A statistically significant result with tiny d may not be meaningful. Small d is about 0.2 medium about 0.5 and large about 0.8." />
        <jsp:param name="faq4q" value="What are the assumptions of a t-test?" />
        <jsp:param name="faq4a" value="Data should be approximately normal or sample size large enough for CLT. Observations must be independent. Two-sample tests assume equal variances unless using Welch. Paired tests assume the differences are normally distributed." />
        <jsp:param name="faq5q" value="How do I choose between one-tailed and two-tailed?" />
        <jsp:param name="faq5a" value="Use two-tailed when you want to detect a difference in either direction. Use one-tailed only when you have a strong prior hypothesis about the direction of the effect before collecting data." />
        <jsp:param name="faq6q" value="When is a t-test not appropriate?" />
        <jsp:param name="faq6a" value="Avoid t-tests with very small non-normal samples or heavily skewed data. Use non-parametric alternatives like Mann-Whitney U or Wilcoxon signed-rank test. For more than two groups use ANOVA instead." />
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
                <h1 class="tool-page-title">T-Test Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    T-Test Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">One &amp; Two Sample</span>
                <span class="tool-badge">Paired &amp; Welch</span>
                <span class="tool-badge">Cohen&rsquo;s d</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>t-test calculator</strong> for <strong>one-sample</strong>, <strong>two-sample</strong>, <strong>paired</strong>, and <strong>Welch</strong> t-tests. Compute t-statistic, p-value, degrees of freedom, critical value, confidence interval, Cohen&rsquo;s d effect size, interactive t-distribution chart, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/>
                    </svg>
                    T-Test
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Test Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="tt-mode-one" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">One-Sample</button>
                            <button type="button" class="stat-mode-btn" id="tt-mode-two" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Two-Sample</button>
                            <button type="button" class="stat-mode-btn" id="tt-mode-paired" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Paired</button>
                            <button type="button" class="stat-mode-btn" id="tt-mode-welch" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Welch</button>
                        </div>
                    </div>

                    <!-- Shared Controls -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="tt-alpha">Significance Level (&alpha;)</label>
                        <select class="stat-input-text" id="tt-alpha">
                            <option value="0.01">0.01</option>
                            <option value="0.05" selected>0.05</option>
                            <option value="0.10">0.10</option>
                        </select>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label" for="tt-tail">Alternative Hypothesis</label>
                        <select class="stat-input-text" id="tt-tail">
                            <option value="two" selected>Two-tailed</option>
                            <option value="right">Right-tailed</option>
                            <option value="left">Left-tailed</option>
                        </select>
                    </div>

                    <!-- One-Sample inputs -->
                    <div id="tt-input-one">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="tt-one-data">Sample Data (comma or space separated)</label>
                            <textarea class="stat-input-text" id="tt-one-data" rows="3" placeholder="Enter data values">23, 25, 27, 22, 24, 26, 28, 21, 25, 24</textarea>
                            <div class="tool-form-hint">Raw data values</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="tt-one-mu">Population Mean (&mu;&#8320;)</label>
                            <input type="number" class="stat-input-text" id="tt-one-mu" value="25" step="0.01">
                        </div>
                    </div>

                    <!-- Two-Sample inputs -->
                    <div id="tt-input-two" style="display:none;">
                        <div class="tt-two-group">
                            <div>
                                <div class="tt-group-label">Group 1</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="tt-two-data1">Sample Data</label>
                                    <textarea class="stat-input-text" id="tt-two-data1" rows="3" placeholder="Group 1 data">23, 25, 27, 22, 24, 26</textarea>
                                </div>
                            </div>
                            <div>
                                <div class="tt-group-label">Group 2</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="tt-two-data2">Sample Data</label>
                                    <textarea class="stat-input-text" id="tt-two-data2" rows="3" placeholder="Group 2 data">28, 30, 32, 29, 31, 33</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Paired inputs -->
                    <div id="tt-input-paired" style="display:none;">
                        <div class="tt-two-group">
                            <div>
                                <div class="tt-group-label">Before</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="tt-paired-before">Sample Data</label>
                                    <textarea class="stat-input-text" id="tt-paired-before" rows="3" placeholder="Before data">120, 125, 130, 118, 122, 128</textarea>
                                </div>
                            </div>
                            <div>
                                <div class="tt-group-label">After</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="tt-paired-after">Sample Data</label>
                                    <textarea class="stat-input-text" id="tt-paired-after" rows="3" placeholder="After data">115, 120, 125, 113, 118, 123</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Welch inputs -->
                    <div id="tt-input-welch" style="display:none;">
                        <div class="tt-two-group">
                            <div>
                                <div class="tt-group-label">Group 1</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="tt-welch-data1">Sample Data</label>
                                    <textarea class="stat-input-text" id="tt-welch-data1" rows="3" placeholder="Group 1 data">23, 25, 27, 22, 24, 26, 25</textarea>
                                </div>
                            </div>
                            <div>
                                <div class="tt-group-label">Group 2</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="tt-welch-data2">Sample Data</label>
                                    <textarea class="stat-input-text" id="tt-welch-data2" rows="3" placeholder="Group 2 data">28, 30, 32, 29, 31, 33, 30, 31</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="tt-calc-btn">Calculate T-Test</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="tt-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples" id="tt-examples">
                            <button type="button" class="stat-example-chip" data-example="exam-scores">Exam Scores</button>
                            <button type="button" class="stat-example-chip" data-example="drug-trial">Drug Trial</button>
                            <button type="button" class="stat-example-chip" data-example="weight-loss">Weight Loss</button>
                            <button type="button" class="stat-example-chip" data-example="teaching-methods">Teaching Methods</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="tt-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="tt-graph-panel">T-Distribution</button>
                <button type="button" class="stat-output-tab" data-tab="tt-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="tt-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="tt-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter data and click Calculate</h3>
                            <p>Perform one-sample, two-sample, paired, or Welch t-tests with full results.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="tt-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="tt-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>T-Distribution Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="tt-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="tt-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="tt-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="t-test-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is a T-Test? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a T-Test?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>t-test</strong> is a statistical hypothesis test used to determine whether there is a significant difference between the means of one or two groups. It uses the <strong>t-distribution</strong>, which accounts for small sample sizes and unknown population standard deviations.</p>

            <!-- Animated SVG: T-distribution curve -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 100" style="max-width:400px;width:100%;" aria-label="T-distribution curve with rejection regions">
                    <line x1="30" y1="80" x2="370" y2="80" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                    <path d="M30,80 Q80,78 120,70 Q160,45 200,20 Q240,45 280,70 Q320,78 370,80" fill="none" stroke="var(--text-muted,#94a3b8)" stroke-width="2" class="stat-anim stat-anim-d1"/>
                    <path d="M30,80 Q50,79 70,77 L70,80 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                    <path d="M330,77 Q350,79 370,80 L330,80 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                    <line x1="200" y1="20" x2="200" y2="80" stroke="var(--text-muted,#94a3b8)" stroke-width="1" stroke-dasharray="4"/>
                    <line x1="260" y1="55" x2="260" y2="80" stroke="#e11d48" stroke-width="2" class="stat-anim stat-anim-d3"/>
                    <circle cx="260" cy="55" r="4" fill="#e11d48" class="stat-anim stat-anim-d3"/>
                    <text x="200" y="95" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">0</text>
                    <text x="260" y="95" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">t</text>
                    <text x="50" y="70" text-anchor="middle" font-size="9" fill="#e11d48">&alpha;/2</text>
                    <text x="350" y="70" text-anchor="middle" font-size="9" fill="#e11d48">&alpha;/2</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Hypothesis Testing</h4>
                    <p>Compare a sample mean to a known value or compare two group means to determine if the difference is statistically significant.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2705;</div>
                    <h4>Statistical Significance</h4>
                    <p>The p-value tells you the probability of observing your data under the null hypothesis. Small p-values suggest significant results.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Effect Size</h4>
                    <p>Cohen&rsquo;s d measures the practical significance of the difference. A result can be statistically significant but have a small effect.</p>
                </div>
            </div>
        </div>

        <!-- 2. Types of T-Tests -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Types of T-Tests</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>One-Sample T-Test:</strong>&nbsp; t = (x&#772; &minus; &mu;&#8320;) / (s / &radic;n)
                <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Compares a sample mean to a known or hypothesized population mean &mu;&#8320;. Uses n&minus;1 degrees of freedom.</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Two-Sample T-Test (Pooled):</strong>&nbsp; t = (x&#772;<sub>1</sub> &minus; x&#772;<sub>2</sub>) / (s<sub>p</sub> &times; &radic;(1/n<sub>1</sub> + 1/n<sub>2</sub>))
                <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Compares means of two independent groups assuming equal variances. s<sub>p</sub> is the pooled standard deviation with n<sub>1</sub>+n<sub>2</sub>&minus;2 degrees of freedom.</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Paired T-Test:</strong>&nbsp; t = d&#772; / (s<sub>d</sub> / &radic;n)
                <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Tests whether the mean difference d&#772; of paired observations differs from zero. Uses n&minus;1 degrees of freedom where n is the number of pairs.</div>
            </div>
            <div class="stat-formula-box">
                <strong>Welch&rsquo;s T-Test:</strong>&nbsp; t = (x&#772;<sub>1</sub> &minus; x&#772;<sub>2</sub>) / &radic;(s<sub>1</sub>&sup2;/n<sub>1</sub> + s<sub>2</sub>&sup2;/n<sub>2</sub>)
                <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Compares means of two independent groups without assuming equal variances. Uses Welch-Satterthwaite approximation for degrees of freedom.</div>
            </div>
        </div>

        <!-- 3. Choosing the Right T-Test -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Choosing the Right T-Test</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Scenario</th><th>Test Type</th><th>When to Use</th></tr></thead>
                <tbody>
                    <tr><td>Compare sample mean to a known value</td><td style="font-weight:600;">One-Sample</td><td>Testing if a batch mean equals the specification value</td></tr>
                    <tr><td>Compare two independent groups with similar variances</td><td style="font-weight:600;">Two-Sample</td><td>Treatment vs control, males vs females</td></tr>
                    <tr><td>Before and after measurements on same subjects</td><td style="font-weight:600;">Paired</td><td>Pre-test vs post-test, left eye vs right eye</td></tr>
                    <tr><td>Two independent groups with unequal or unknown variances</td><td style="font-weight:600;">Welch</td><td>Default choice when unsure about equal variances</td></tr>
                </tbody>
            </table>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Tip:</strong> When in doubt, use the <strong>Welch t-test</strong>. It is robust to unequal variances and performs well even when variances are actually equal.
                </p>
            </div>
        </div>

        <!-- 4. Interpreting Results -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpreting Results</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x2705; Significant Result</h4>
                    <p>When p &lt; &alpha;, reject the null hypothesis. The observed difference is unlikely due to random chance alone. Report the t-statistic, df, and p-value.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x274C; Not Significant</h4>
                    <p>When p &ge; &alpha;, fail to reject the null hypothesis. There is insufficient evidence of a significant difference. This does <em>not</em> prove the groups are equal.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x1F4CF; Effect Size (Cohen&rsquo;s d)</h4>
                    <p>Small: d &asymp; 0.2, Medium: d &asymp; 0.5, Large: d &asymp; 0.8. A significant p-value with tiny d may lack practical importance.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>&#x2194;&#xFE0F; Confidence Interval</h4>
                    <p>The CI for the mean difference shows the range of plausible values. If it excludes zero, the result is significant at that confidence level.</p>
                </div>
            </div>
        </div>

        <!-- 5. Assumptions & When to Use Alternatives -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions &amp; When to Use Alternatives</h2>

            <div style="margin-bottom:1rem;">
                <ul style="list-style:none;padding:0;">
                    <li style="padding:0.5rem 0;border-bottom:1px solid var(--border);font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                        <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">1.</span>
                        <span><strong>Normality:</strong> Data should be approximately normally distributed, or sample size should be large enough (n &ge; 30) for the Central Limit Theorem to apply.</span>
                    </li>
                    <li style="padding:0.5rem 0;border-bottom:1px solid var(--border);font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                        <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">2.</span>
                        <span><strong>Independence:</strong> Observations must be independent of each other (except in paired tests where pairs are dependent but differences are independent).</span>
                    </li>
                    <li style="padding:0.5rem 0;border-bottom:1px solid var(--border);font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                        <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">3.</span>
                        <span><strong>Equal Variances:</strong> The two-sample t-test assumes equal variances. Use Welch&rsquo;s t-test if this assumption is violated.</span>
                    </li>
                    <li style="padding:0.5rem 0;font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                        <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">4.</span>
                        <span><strong>Continuous Data:</strong> T-tests are designed for continuous (interval or ratio) data, not ordinal or categorical data.</span>
                    </li>
                </ul>
            </div>

            <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Non-parametric alternatives:</strong> If your data violates normality with small samples, consider the <strong>Mann-Whitney U test</strong> (for independent samples) or <strong>Wilcoxon signed-rank test</strong> (for paired samples). For comparing more than two groups, use <strong>ANOVA</strong> instead.
                </p>
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">Which t-test should I use?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use one-sample to compare a mean to a known value. Use independent two-sample when groups are unrelated with similar variances. Use paired for before/after or matched data. Use Welch when group variances differ or you are unsure about equal variances.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What does the p-value tell me?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The p-value is the probability of observing data as extreme as yours if the null hypothesis is true. A small p-value below alpha suggests the data is unlikely under the null, so you reject it.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is Cohen&rsquo;s d and why does it matter?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Cohen&rsquo;s d measures effect size, or practical significance. A statistically significant result with tiny d may not be meaningful. Small d is about 0.2, medium about 0.5, and large about 0.8.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are the assumptions of a t-test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Data should be approximately normal or sample size large enough for CLT. Observations must be independent. Two-sample tests assume equal variances unless using Welch. Paired tests assume the differences are normally distributed.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I choose between one-tailed and two-tailed?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use two-tailed when you want to detect a difference in either direction. Use one-tailed only when you have a strong prior hypothesis about the direction of the effect before collecting data.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When is a t-test not appropriate?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Avoid t-tests with very small non-normal samples or heavily skewed data. Use non-parametric alternatives like Mann-Whitney U or Wilcoxon signed-rank test. For more than two groups, use ANOVA instead.</div>
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
    <script src="<%=request.getContextPath()%>/js/t-test-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
