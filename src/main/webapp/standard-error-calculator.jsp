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
        /* Confidence level pills */
        .ci-conf-pills{display:flex;gap:0.375rem;flex-wrap:wrap;margin-top:0.25rem}
        .ci-conf-pill{padding:0.375rem 0.75rem;border:1.5px solid var(--border);border-radius:9999px;background:var(--bg-primary);cursor:pointer;font-weight:600;color:var(--text-secondary);font-size:0.75rem;transition:all 0.15s;font-family:var(--font-sans)}
        .ci-conf-pill:hover{border-color:var(--tool-primary)}
        .ci-conf-pill.active{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .ci-conf-pill{background:var(--bg-tertiary);border-color:var(--border)}
        [data-theme="dark"] .ci-conf-pill.active{background:var(--tool-light);color:var(--tool-primary);border-color:var(--tool-primary)}
        .ci-custom-input{width:60px;padding:0.25rem 0.375rem;border:1.5px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);margin-left:0.25rem}
        .ci-custom-input:focus{outline:none;border-color:var(--tool-primary)}
        /* Two-sample grid */
        .ci-two-sample{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem}
        .ci-sample-group h5{font-size:0.75rem;font-weight:600;color:var(--tool-primary);margin-bottom:0.5rem}
        @media(max-width:480px){.ci-two-sample{grid-template-columns:1fr}}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Standard Error Calculator Online - SE Mean Proportion Free" />
        <jsp:param name="toolDescription" value="Calculate standard error for means proportions and differences. SE of mean SE of proportion difference of means and proportions with margin of error confidence intervals and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="standard-error-calculator.jsp" />
        <jsp:param name="toolKeywords" value="standard error calculator, SE calculator, standard error of mean, standard error of proportion, margin of error calculator, confidence interval, sampling error, SE of difference, standard error formula" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="SE of mean with margin of error and CI,SE of proportion with normal approximation CI,SE of difference of means for two independent samples,SE of difference of proportions for two samples,90% 95% 99% confidence levels with critical values,Step-by-step KaTeX formulas,Interactive Plotly CI visualization,Python scipy code generation" />
        <jsp:param name="teaches" value="Standard error, sampling distribution, margin of error, confidence intervals, critical values, standard error vs standard deviation" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose SE Type|Select SE of mean proportion or difference of means or proportions,Set Confidence Level|Pick 90% or 95% or 99% for margin of error,Enter Parameters|Input standard deviation sample size or proportions,Click Calculate|Get instant SE margin of error and confidence interval,View Chart|See the CI visualized on an interactive Plotly chart,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is the difference between standard error and standard deviation?" />
        <jsp:param name="faq1a" value="Standard deviation measures the spread of individual data points around the mean. Standard error measures how much a sample statistic like the mean varies across different samples. SE equals SD divided by the square root of the sample size." />
        <jsp:param name="faq2q" value="How does sample size affect standard error?" />
        <jsp:param name="faq2a" value="Standard error decreases as sample size increases proportional to the square root of n. Quadrupling the sample size halves the SE giving more precise estimates." />
        <jsp:param name="faq3q" value="When should I use SE of proportion versus SE of mean?" />
        <jsp:param name="faq3a" value="Use SE of proportion when your data is categorical like yes or no responses and you are estimating a percentage. Use SE of mean when your data is continuous like heights weights or test scores." />
        <jsp:param name="faq4q" value="What is margin of error and how is it calculated?" />
        <jsp:param name="faq4a" value="Margin of error equals the critical value times the standard error. It defines how far the confidence interval extends from the point estimate. A 95% CI uses z equals 1.96 so ME equals 1.96 times SE." />
        <jsp:param name="faq5q" value="How do I interpret the SE of the difference of two means?" />
        <jsp:param name="faq5a" value="The SE of the difference quantifies uncertainty in comparing two group means. It combines the variability from both samples using SE equals square root of s1 squared over n1 plus s2 squared over n2." />
        <jsp:param name="faq6q" value="Why is SE important in hypothesis testing?" />
        <jsp:param name="faq6a" value="SE is used to calculate test statistics like t and z scores. A smaller SE means the sample estimate is more precise making it easier to detect true differences between groups." />
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
                <h1 class="tool-page-title">Standard Error Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Standard Error Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Mean &amp; Proportion</span>
                <span class="tool-badge">Margin of Error</span>
                <span class="tool-badge">Confidence Intervals</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>standard error calculator</strong> for <strong>means</strong>, <strong>proportions</strong>, and <strong>differences</strong>. Compute SE, margin of error, and confidence intervals with step-by-step KaTeX formulas, interactive Plotly chart, and Python scipy export.</p>
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
                    Standard Error
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">SE Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" data-mode="mean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">SE of Mean</button>
                            <button type="button" class="stat-mode-btn" data-mode="proportion" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">SE of Prop</button>
                            <button type="button" class="stat-mode-btn" data-mode="diffmean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Diff Means</button>
                            <button type="button" class="stat-mode-btn" data-mode="diffprop" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Diff Props</button>
                        </div>
                    </div>

                    <!-- Confidence Level -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Confidence Level</label>
                        <div class="ci-conf-pills">
                            <button type="button" class="se-conf-pill ci-conf-pill" data-conf="90">90%</button>
                            <button type="button" class="se-conf-pill ci-conf-pill active" data-conf="95">95%</button>
                            <button type="button" class="se-conf-pill ci-conf-pill" data-conf="99">99%</button>
                        </div>
                    </div>

                    <!-- SE of Mean inputs -->
                    <div id="se-input-mean">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="se-sd">Standard Deviation (&sigma; or s)</label>
                            <input type="number" class="stat-input-text" id="se-sd" value="15" step="0.01" min="0.01">
                            <div class="tool-form-hint">Population or sample standard deviation</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="se-n">Sample Size (n)</label>
                            <input type="number" class="stat-input-text" id="se-n" value="36" step="1" min="2">
                            <div class="tool-form-hint">Number of observations in the sample</div>
                        </div>
                    </div>

                    <!-- SE of Proportion inputs -->
                    <div id="se-input-proportion" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="se-p">Sample Proportion (p&#770;)</label>
                            <input type="number" class="stat-input-text" id="se-p" value="0.60" step="0.01" min="0" max="1">
                            <div class="tool-form-hint">Proportion between 0 and 1</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="se-n-prop">Sample Size (n)</label>
                            <input type="number" class="stat-input-text" id="se-n-prop" value="100" step="1" min="1">
                        </div>
                    </div>

                    <!-- Diff Means inputs -->
                    <div id="se-input-diffmean" style="display:none;">
                        <div class="ci-two-sample">
                            <div class="ci-sample-group">
                                <h5>Sample 1</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-sd1">Std Dev (s&#8321;)</label>
                                    <input type="number" class="stat-input-text" id="se-sd1" value="10" step="0.01" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-n1">Size (n&#8321;)</label>
                                    <input type="number" class="stat-input-text" id="se-n1" value="30" step="1" min="2">
                                </div>
                            </div>
                            <div class="ci-sample-group">
                                <h5>Sample 2</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-sd2">Std Dev (s&#8322;)</label>
                                    <input type="number" class="stat-input-text" id="se-sd2" value="12" step="0.01" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-n2">Size (n&#8322;)</label>
                                    <input type="number" class="stat-input-text" id="se-n2" value="35" step="1" min="2">
                                </div>
                            </div>
                        </div>
                        <div class="tool-form-hint" style="margin-top:0.25rem;">Two independent samples</div>
                    </div>

                    <!-- Diff Props inputs -->
                    <div id="se-input-diffprop" style="display:none;">
                        <div class="ci-two-sample">
                            <div class="ci-sample-group">
                                <h5>Sample 1</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-p1">Proportion (p&#8321;)</label>
                                    <input type="number" class="stat-input-text" id="se-p1" value="0.55" step="0.01" min="0" max="1">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-n1-prop">Size (n&#8321;)</label>
                                    <input type="number" class="stat-input-text" id="se-n1-prop" value="80" step="1" min="1">
                                </div>
                            </div>
                            <div class="ci-sample-group">
                                <h5>Sample 2</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-p2">Proportion (p&#8322;)</label>
                                    <input type="number" class="stat-input-text" id="se-p2" value="0.45" step="0.01" min="0" max="1">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="se-n2-prop">Size (n&#8322;)</label>
                                    <input type="number" class="stat-input-text" id="se-n2-prop" value="90" step="1" min="1">
                                </div>
                            </div>
                        </div>
                        <div class="tool-form-hint" style="margin-top:0.25rem;">Two independent proportions</div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="se-calc-btn">Calculate Standard Error</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="se-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-se-example="survey-mean">Survey Mean</button>
                            <button type="button" class="stat-example-chip" data-se-example="election-poll">Election Poll</button>
                            <button type="button" class="stat-example-chip" data-se-example="drug-trial">Drug Trial</button>
                            <button type="button" class="stat-example-chip" data-se-example="ab-test">A/B Test</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="se-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="se-graph-panel">CI Chart</button>
                <button type="button" class="stat-output-tab" data-tab="se-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="se-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="se-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter parameters and click Calculate</h3>
                            <p>Compute standard error for means, proportions, or differences.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="se-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="se-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>CI Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="se-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="se-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="se-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="standard-error-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Standard Error? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Standard Error?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The <strong>standard error</strong> (SE) measures the variability of a sample statistic from sample to sample. It tells you how precisely your sample estimate (mean or proportion) approximates the true population parameter. Smaller SE means greater precision.</p>

            <!-- Animated SVG: sample means clustered around population mean -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 100" style="max-width:400px;width:100%;" aria-label="Sample means clustered around population mean">
                    <line x1="30" y1="60" x2="370" y2="60" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                    <!-- Population mean -->
                    <line x1="200" y1="45" x2="200" y2="75" stroke="#e11d48" stroke-width="3"/>
                    <text x="200" y="90" text-anchor="middle" font-size="11" fill="#e11d48" font-weight="600">&mu;</text>
                    <!-- Sample means scattered around mu -->
                    <circle cx="180" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d1"/>
                    <circle cx="210" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d2"/>
                    <circle cx="195" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d1"/>
                    <circle cx="205" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d3"/>
                    <circle cx="188" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d2"/>
                    <circle cx="215" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d3"/>
                    <circle cx="192" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d1"/>
                    <!-- SE bracket -->
                    <line x1="175" y1="35" x2="225" y2="35" stroke="var(--text-muted,#94a3b8)" stroke-width="1" stroke-dasharray="4"/>
                    <text x="200" y="28" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">SE = spread of x&#772; values</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4C9;</div>
                    <h4>Sampling Variability</h4>
                    <p>Different samples from the same population yield different statistics. SE quantifies how much these sample estimates typically vary.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Precision of Estimate</h4>
                    <p>A smaller SE indicates that the sample statistic is a more precise estimate of the population parameter.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Foundation for CI</h4>
                    <p>Confidence intervals are built from the SE. The margin of error equals the critical value times the standard error.</p>
                </div>
            </div>
        </div>

        <!-- 2. Standard Error Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Standard Error Formulas</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>SE of Mean:</strong>&nbsp; SE = &sigma; / &radic;n
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>SE of Proportion:</strong>&nbsp; SE = &radic;(p&#770;(1 &minus; p&#770;) / n)
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>SE of Difference of Means:</strong>&nbsp; SE = &radic;(s&#8321;&sup2; / n&#8321; + s&#8322;&sup2; / n&#8322;)
            </div>
            <div class="stat-formula-box">
                <strong>SE of Difference of Proportions:</strong>&nbsp; SE = &radic;(p&#770;&#8321;(1 &minus; p&#770;&#8321;) / n&#8321; + p&#770;&#8322;(1 &minus; p&#770;&#8322;) / n&#8322;)
            </div>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> A population has SD = 15 and we draw a sample of n = 36. Find the standard error of the mean.
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    SE = &sigma; / &radic;n = 15 / &radic;36 = 15 / 6 = <strong>2.5</strong><br>
                    At 95% confidence (z = 1.96): MoE = 1.96 &times; 2.5 = <strong>4.9</strong>
                </div>
            </div>
        </div>

        <!-- 3. SE vs Standard Deviation -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">SE vs Standard Deviation</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x1F4CA; Standard Deviation (SD)</h4>
                    <p>Measures the spread of <em>individual data points</em> around the sample mean. It describes variability within a single sample. SD does not depend on sample size.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x1F4C9; Standard Error (SE)</h4>
                    <p>Measures the spread of <em>sample statistics</em> (like the mean) across many samples. It describes how precisely the statistic estimates the population parameter. SE decreases with larger n.</p>
                </div>
            </div>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--tool-primary);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Key Relationship:</strong> SE = SD / &radic;n. The standard error is always smaller than the standard deviation (for n &gt; 1). As sample size grows, SE shrinks but SD stays roughly the same.
                </p>
            </div>
        </div>

        <!-- 4. Margin of Error & Confidence Intervals -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Margin of Error &amp; Confidence Intervals</h2>

            <div class="stat-formula-box" style="margin-bottom:1rem;">
                <strong>Margin of Error:</strong>&nbsp; ME = z* &times; SE
            </div>

            <table class="stat-ops-table">
                <thead><tr><th>Confidence Level</th><th>z* Critical Value</th><th>Multiplier Effect</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">90%</td><td>1.645</td><td>Narrower interval, less certainty</td></tr>
                    <tr><td style="font-weight:600;">95%</td><td>1.960</td><td>Standard balance of precision and confidence</td></tr>
                    <tr><td style="font-weight:600;">99%</td><td>2.576</td><td>Wider interval, higher certainty</td></tr>
                </tbody>
            </table>

            <!-- CI on number line SVG -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 80" style="max-width:400px;width:100%;" aria-label="Confidence interval on a number line">
                    <line x1="30" y1="40" x2="370" y2="40" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                    <line x1="120" y1="30" x2="120" y2="50" stroke="#e11d48" stroke-width="3" class="stat-anim stat-anim-d1"/>
                    <line x1="280" y1="30" x2="280" y2="50" stroke="#e11d48" stroke-width="3" class="stat-anim stat-anim-d2"/>
                    <line x1="120" y1="40" x2="280" y2="40" stroke="#e11d48" stroke-width="4" opacity="0.3" class="stat-anim stat-anim-d1"/>
                    <circle cx="200" cy="40" r="6" fill="#ef4444" class="stat-anim stat-anim-d3"/>
                    <text x="80" y="65" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)">x&#772; &minus; ME</text>
                    <text x="200" y="65" text-anchor="middle" font-size="11" fill="#ef4444" font-weight="600">x&#772;</text>
                    <text x="320" y="65" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)">x&#772; + ME</text>
                    <text x="200" y="20" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">CI = x&#772; &plusmn; z* &times; SE</text>
                </svg>
            </div>
        </div>

        <!-- 5. Key Relationships -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Relationships</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x1F4C8; Larger n &rarr; Smaller SE</h4>
                    <p>Increasing sample size reduces the standard error. More data means more precise estimates of the population parameter.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x1F4CA; Higher Variability &rarr; Larger SE</h4>
                    <p>Greater population variability (larger SD) increases the standard error. More spread in the data means less precise sample estimates.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x1F4D0; SE &prop; 1 / &radic;n</h4>
                    <p>Standard error is inversely proportional to the square root of the sample size. This is the law of diminishing returns in sampling.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>&#x00D7;4 Rule</h4>
                    <p>To halve the standard error (double the precision), you need to quadruple the sample size. Going from n=100 to n=400 cuts SE in half.</p>
                </div>
            </div>
        </div>

        <!-- 6. Frequently Asked Questions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is the difference between standard error and standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Standard deviation measures the spread of individual data points around the mean. Standard error measures how much a sample statistic (like the mean) varies across different samples. SE equals SD divided by the square root of the sample size.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How does sample size affect standard error?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Standard error decreases as sample size increases, proportional to the square root of n. Quadrupling the sample size halves the SE, giving more precise estimates.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When should I use SE of proportion versus SE of mean?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use SE of proportion when your data is categorical (like yes/no responses) and you are estimating a percentage. Use SE of mean when your data is continuous, like heights, weights, or test scores.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is margin of error and how is it calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Margin of error equals the critical value times the standard error. It defines how far the confidence interval extends from the point estimate. A 95% CI uses z = 1.96, so ME = 1.96 &times; SE.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret the SE of the difference of two means?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The SE of the difference quantifies uncertainty in comparing two group means. It combines the variability from both samples using SE = &radic;(s<sub>1</sub>&sup2;/n<sub>1</sub> + s<sub>2</sub>&sup2;/n<sub>2</sub>).</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Why is SE important in hypothesis testing?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">SE is used to calculate test statistics like t and z scores. A smaller SE means the sample estimate is more precise, making it easier to detect true differences between groups.</div>
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
    <script src="<%=request.getContextPath()%>/js/standard-error-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
