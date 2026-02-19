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
        /* Two-sample grid */
        .ci-two-sample{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem}
        .ci-sample-group h5{font-size:0.75rem;font-weight:600;color:var(--tool-primary);margin-bottom:0.5rem}
        @media(max-width:480px){.ci-two-sample{grid-template-columns:1fr}}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Hypothesis Test Calculator Online - Z-Test T-Test Proportion Free" />
        <jsp:param name="toolDescription" value="Perform hypothesis tests for means and proportions. Z-test T-test one-proportion and two-proportion tests with p-value critical value decision and Python export." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="hypothesis-test-calculator.jsp" />
        <jsp:param name="toolKeywords" value="hypothesis test calculator, z-test calculator, t-test calculator, proportion test, statistical significance, p-value, null hypothesis, alternative hypothesis, two-tailed test, one-tailed test" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Z-test for mean with known population sigma,T-test for mean with sample standard deviation,One-proportion Z-test,Two-proportion Z-test with pooled estimate,One-tailed and two-tailed alternative hypotheses,Automatic reject or fail to reject decision,Step-by-step KaTeX formulas,Interactive Plotly distribution with rejection region,Python scipy code generation" />
        <jsp:param name="teaches" value="Hypothesis testing, null hypothesis, alternative hypothesis, test statistic, p-value, significance level, Type I error, Type II error, statistical power" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Test Type|Select Z-test for mean or T-test or proportion test,Set Hypotheses|Enter null hypothesis value and choose alternative direction,Enter Sample Data|Input sample mean SD size or successes and total,Set Alpha|Choose significance level 0.01 or 0.05 or 0.10,Click Test|Get p-value critical value and automatic decision,View Distribution|See rejection region on the distribution curve" />
        <jsp:param name="faq1q" value="What is the difference between Z-test and T-test?" />
        <jsp:param name="faq1a" value="Use Z-test when the population standard deviation sigma is known or the sample size is large n greater than 30. Use T-test when sigma is unknown and you use the sample standard deviation s. The T-distribution has heavier tails especially for small samples." />
        <jsp:param name="faq2q" value="How do I choose between one-tailed and two-tailed test?" />
        <jsp:param name="faq2a" value="Choose one-tailed if you predict a specific direction like the new treatment is better. Choose two-tailed if you test for any difference in either direction. This decision must be made before collecting data." />
        <jsp:param name="faq3q" value="What does reject H0 mean?" />
        <jsp:param name="faq3a" value="Rejecting H0 means the data provides sufficient evidence that the null hypothesis is unlikely. It does not prove H1 is true. It means that if H0 were true the probability of seeing results this extreme is less than alpha." />
        <jsp:param name="faq4q" value="What is the difference between Type I and Type II error?" />
        <jsp:param name="faq4a" value="Type I error alpha is rejecting H0 when it is actually true which is a false positive. Type II error beta is failing to reject H0 when it is actually false which is a false negative. Alpha is controlled by the significance level." />
        <jsp:param name="faq5q" value="When should I use a proportion test?" />
        <jsp:param name="faq5a" value="Use a proportion test when your data is categorical like yes or no pass or fail. One-proportion tests compare a sample proportion to a claimed value. Two-proportion tests compare proportions from two independent groups." />
        <jsp:param name="faq6q" value="What assumptions must be met for these tests?" />
        <jsp:param name="faq6a" value="Z-test assumes known sigma and normal population or large n. T-test assumes normal population or large n. Proportion tests need np and n times 1 minus p both at least 5. All tests assume random independent samples." />
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
                <h1 class="tool-page-title">Hypothesis Test Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Hypothesis Test Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Z-Test &amp; T-Test</span>
                <span class="tool-badge">Proportion Tests</span>
                <span class="tool-badge">Auto Decision</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>hypothesis test calculator</strong> for <strong>means</strong> and <strong>proportions</strong>. Perform Z-tests, T-tests, one-proportion and two-proportion tests with automatic reject/fail-to-reject decision, step-by-step KaTeX formulas, and Python scipy export.</p>
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
                    Hypothesis Test
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Test Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" data-mode="zmean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Z-Test (Mean)</button>
                            <button type="button" class="stat-mode-btn" data-mode="tmean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">T-Test (Mean)</button>
                            <button type="button" class="stat-mode-btn" data-mode="zprop" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Proportion</button>
                            <button type="button" class="stat-mode-btn" data-mode="twoprop" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Two-Prop</button>
                        </div>
                    </div>

                    <!-- Z-Test for Mean inputs -->
                    <div id="ht-input-zmean">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zm-xbar">Sample Mean (x&#772;)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zm-xbar" value="105" step="0.01">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zm-mu0">Population Mean (&mu;&#8320;)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zm-mu0" value="100" step="0.01">
                            <div class="tool-form-hint">Null hypothesis value</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zm-sigma">Population SD (&sigma;)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zm-sigma" value="15" step="0.01" min="0.01">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zm-n">Sample Size (n)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zm-n" value="36" step="1" min="1">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zm-alpha">Significance Level (&alpha;)</label>
                            <select class="stat-input-text ht-input" id="ht-zm-alpha" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="0.01">0.01</option>
                                <option value="0.05" selected>0.05</option>
                                <option value="0.10">0.10</option>
                            </select>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zm-alt">Alternative Hypothesis</label>
                            <select class="stat-input-text ht-input" id="ht-zm-alt" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="two" selected>Two-tailed (&mu; &ne; &mu;&#8320;)</option>
                                <option value="right">Right-tailed (&mu; &gt; &mu;&#8320;)</option>
                                <option value="left">Left-tailed (&mu; &lt; &mu;&#8320;)</option>
                            </select>
                        </div>
                    </div>

                    <!-- T-Test for Mean inputs -->
                    <div id="ht-input-tmean" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tm-xbar">Sample Mean (x&#772;)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-tm-xbar" value="105" step="0.01">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tm-mu0">Population Mean (&mu;&#8320;)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-tm-mu0" value="100" step="0.01">
                            <div class="tool-form-hint">Null hypothesis value</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tm-s">Sample SD (s)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-tm-s" value="12" step="0.01" min="0.01">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tm-n">Sample Size (n)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-tm-n" value="16" step="1" min="2">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tm-alpha">Significance Level (&alpha;)</label>
                            <select class="stat-input-text ht-input" id="ht-tm-alpha" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="0.01">0.01</option>
                                <option value="0.05" selected>0.05</option>
                                <option value="0.10">0.10</option>
                            </select>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tm-alt">Alternative Hypothesis</label>
                            <select class="stat-input-text ht-input" id="ht-tm-alt" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="two" selected>Two-tailed (&mu; &ne; &mu;&#8320;)</option>
                                <option value="right">Right-tailed (&mu; &gt; &mu;&#8320;)</option>
                                <option value="left">Left-tailed (&mu; &lt; &mu;&#8320;)</option>
                            </select>
                        </div>
                    </div>

                    <!-- One-Proportion Z-Test inputs -->
                    <div id="ht-input-zprop" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zp-x">Successes (x)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zp-x" value="55" step="1" min="0">
                            <div class="tool-form-hint">Count of favorable outcomes</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zp-n">Sample Size (n)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zp-n" value="100" step="1" min="1">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zp-p0">Claimed Proportion (p&#8320;)</label>
                            <input type="number" class="stat-input-text ht-input" id="ht-zp-p0" value="0.50" step="0.01" min="0" max="1">
                            <div class="tool-form-hint">Null hypothesis proportion</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zp-alpha">Significance Level (&alpha;)</label>
                            <select class="stat-input-text ht-input" id="ht-zp-alpha" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="0.01">0.01</option>
                                <option value="0.05" selected>0.05</option>
                                <option value="0.10">0.10</option>
                            </select>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-zp-alt">Alternative Hypothesis</label>
                            <select class="stat-input-text ht-input" id="ht-zp-alt" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="two" selected>Two-tailed (p &ne; p&#8320;)</option>
                                <option value="right">Right-tailed (p &gt; p&#8320;)</option>
                                <option value="left">Left-tailed (p &lt; p&#8320;)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Two-Proportion Z-Test inputs -->
                    <div id="ht-input-twoprop" style="display:none;">
                        <div class="ci-two-sample">
                            <div class="ci-sample-group">
                                <h5>Sample 1</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ht-tp-x1">Successes (x&#8321;)</label>
                                    <input type="number" class="stat-input-text ht-input" id="ht-tp-x1" value="45" step="1" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ht-tp-n1">Size (n&#8321;)</label>
                                    <input type="number" class="stat-input-text ht-input" id="ht-tp-n1" value="100" step="1" min="1">
                                </div>
                            </div>
                            <div class="ci-sample-group">
                                <h5>Sample 2</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ht-tp-x2">Successes (x&#8322;)</label>
                                    <input type="number" class="stat-input-text ht-input" id="ht-tp-x2" value="60" step="1" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ht-tp-n2">Size (n&#8322;)</label>
                                    <input type="number" class="stat-input-text ht-input" id="ht-tp-n2" value="120" step="1" min="1">
                                </div>
                            </div>
                        </div>
                        <div class="tool-form-group" style="margin-top:0.75rem;">
                            <label class="tool-form-label" for="ht-tp-alpha">Significance Level (&alpha;)</label>
                            <select class="stat-input-text ht-input" id="ht-tp-alpha" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="0.01">0.01</option>
                                <option value="0.05" selected>0.05</option>
                                <option value="0.10">0.10</option>
                            </select>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ht-tp-alt">Alternative Hypothesis</label>
                            <select class="stat-input-text ht-input" id="ht-tp-alt" style="min-height:auto;padding:0.5rem 0.75rem;">
                                <option value="two" selected>Two-tailed (p&#8321; &ne; p&#8322;)</option>
                                <option value="right">Right-tailed (p&#8321; &gt; p&#8322;)</option>
                                <option value="left">Left-tailed (p&#8321; &lt; p&#8322;)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="ht-calc-btn">Perform Test</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="ht-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-ht-example="iq-test">IQ Test (Z)</button>
                            <button type="button" class="stat-example-chip" data-ht-example="drug-trial">Drug Trial (T)</button>
                            <button type="button" class="stat-example-chip" data-ht-example="coin-flip">Fair Coin</button>
                            <button type="button" class="stat-example-chip" data-ht-example="ab-test">A/B Test</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="ht-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="ht-graph-panel">Distribution</button>
                <button type="button" class="stat-output-tab" data-tab="ht-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="ht-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="ht-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F9EA;</div>
                            <h3>Enter parameters and click Perform Test</h3>
                            <p>Run hypothesis tests for means, proportions, or group comparisons.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="ht-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="ht-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>Distribution Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="ht-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="ht-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="ht-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="hypothesis-test-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Hypothesis Testing? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Hypothesis Testing?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Hypothesis testing</strong> is a statistical procedure used to determine whether sample data provides sufficient evidence to reject a claim (the null hypothesis) about a population parameter. It is fundamental to scientific research, quality control, and data-driven decision making.</p>

            <!-- Animated SVG: Hypothesis testing flowchart -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 500 120" style="max-width:500px;width:100%;" aria-label="Hypothesis testing 5-step flowchart">
                    <defs><marker id="ht-arrow" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><path d="M0,0 L6,3 L0,6 Z" fill="var(--border-dark,#cbd5e1)"/></marker></defs>
                    <!-- Step 1 -->
                    <rect x="5" y="35" width="80" height="50" rx="8" fill="var(--tool-light)" stroke="#e11d48" stroke-width="1.5" class="stat-anim stat-anim-d1"/>
                    <text x="45" y="57" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">1. State</text>
                    <text x="45" y="70" text-anchor="middle" font-size="7" fill="var(--text-secondary,#475569)">H&#8320; &amp; H&#8321;</text>
                    <line x1="87" y1="60" x2="103" y2="60" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5" marker-end="url(#ht-arrow)"/>
                    <!-- Step 2 -->
                    <rect x="105" y="35" width="80" height="50" rx="8" fill="var(--tool-light)" stroke="#e11d48" stroke-width="1.5" class="stat-anim stat-anim-d2"/>
                    <text x="145" y="57" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">2. Choose</text>
                    <text x="145" y="70" text-anchor="middle" font-size="7" fill="var(--text-secondary,#475569)">&alpha; level</text>
                    <line x1="187" y1="60" x2="203" y2="60" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5" marker-end="url(#ht-arrow)"/>
                    <!-- Step 3 -->
                    <rect x="205" y="35" width="80" height="50" rx="8" fill="var(--tool-light)" stroke="#e11d48" stroke-width="1.5" class="stat-anim stat-anim-d3"/>
                    <text x="245" y="57" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">3. Compute</text>
                    <text x="245" y="70" text-anchor="middle" font-size="7" fill="var(--text-secondary,#475569)">Test stat</text>
                    <line x1="287" y1="60" x2="303" y2="60" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5" marker-end="url(#ht-arrow)"/>
                    <!-- Step 4 -->
                    <rect x="305" y="35" width="80" height="50" rx="8" fill="var(--tool-light)" stroke="#e11d48" stroke-width="1.5" class="stat-anim stat-anim-d4"/>
                    <text x="345" y="57" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">4. Find</text>
                    <text x="345" y="70" text-anchor="middle" font-size="7" fill="var(--text-secondary,#475569)">p-value</text>
                    <line x1="387" y1="60" x2="403" y2="60" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5" marker-end="url(#ht-arrow)"/>
                    <!-- Step 5 -->
                    <rect x="405" y="35" width="85" height="50" rx="8" fill="#e11d48" stroke="#e11d48" stroke-width="1.5" class="stat-anim stat-anim-d5"/>
                    <text x="447" y="57" text-anchor="middle" font-size="8" fill="#fff" font-weight="600">5. Decide</text>
                    <text x="447" y="70" text-anchor="middle" font-size="7" fill="rgba(255,255,255,0.85)">Reject?</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4DD;</div>
                    <h4>State Hypotheses</h4>
                    <p>Define H&#8320; (null &mdash; no effect) and H&#8321; (alternative &mdash; the claim you want to test). H&#8320; always contains the equality.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F4CA;</div>
                    <h4>Calculate Evidence</h4>
                    <p>Compute a test statistic that measures how far the sample result is from the null hypothesis value in standard-error units.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                    <h4>Make Decision</h4>
                    <p>Compare the p-value to &alpha;. If p &le; &alpha;, reject H&#8320;. Otherwise, fail to reject H&#8320;. Never &ldquo;accept&rdquo; H&#8320;.</p>
                </div>
            </div>
        </div>

        <!-- 2. Test Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Test Formulas</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Z-test for mean (&sigma; known):</strong>&nbsp; z = (x&#772; &minus; &mu;&#8320;) / (&sigma; / &radic;n)
                <div class="tool-form-hint" style="margin-top:0.25rem;">Use when the population standard deviation is known or n is very large.</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>T-test for mean (&sigma; unknown):</strong>&nbsp; t = (x&#772; &minus; &mu;&#8320;) / (s / &radic;n), &nbsp;df = n &minus; 1
                <div class="tool-form-hint" style="margin-top:0.25rem;">Use when the population SD is unknown. Uses sample SD s with t-distribution.</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>One-proportion Z-test:</strong>&nbsp; z = (p&#770; &minus; p&#8320;) / &radic;(p&#8320;(1&minus;p&#8320;) / n)
                <div class="tool-form-hint" style="margin-top:0.25rem;">Tests a sample proportion against a claimed population proportion.</div>
            </div>
            <div class="stat-formula-box">
                <strong>Two-proportion Z-test:</strong>&nbsp; z = (p&#770;&#8321; &minus; p&#770;&#8322;) / &radic;(p&#770;(1&minus;p&#770;)(1/n&#8321; + 1/n&#8322;))
                <div class="tool-form-hint" style="margin-top:0.25rem;">Pooled p&#770; = (x&#8321; + x&#8322;) / (n&#8321; + n&#8322;). Tests if two population proportions are equal.</div>
            </div>
        </div>

        <!-- 3. Decision Making -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Decision Making</h2>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:1.25rem;">
                <div style="padding:1rem;background:rgba(239,68,68,0.08);border-radius:0.5rem;border-left:3px solid var(--error);">
                    <p style="margin:0;font-size:0.875rem;color:var(--text-primary);font-weight:600;">If p-value &le; &alpha;</p>
                    <p style="margin:0.25rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">Reject H&#8320;. The result is statistically significant. There is sufficient evidence to support H&#8321;.</p>
                </div>
                <div style="padding:1rem;background:rgba(16,185,129,0.08);border-radius:0.5rem;border-left:3px solid var(--success);">
                    <p style="margin:0;font-size:0.875rem;color:var(--text-primary);font-weight:600;">If p-value &gt; &alpha;</p>
                    <p style="margin:0.25rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">Fail to reject H&#8320;. The result is not statistically significant. Insufficient evidence to support H&#8321;.</p>
                </div>
            </div>

            <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary);">Common Significance Levels</h3>
            <table class="stat-ops-table">
                <thead><tr><th>&alpha;</th><th>Confidence</th><th>z* (two-tailed)</th><th>Use Case</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">0.10</td><td>90%</td><td>&plusmn;1.645</td><td>Exploratory analysis, social science</td></tr>
                    <tr><td style="font-weight:600;">0.05</td><td>95%</td><td>&plusmn;1.960</td><td>Standard for most research</td></tr>
                    <tr><td style="font-weight:600;">0.01</td><td>99%</td><td>&plusmn;2.576</td><td>High-stakes, medical trials</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Type I and Type II Errors -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Type I and Type II Errors</h2>

            <div class="stat-edu-grid" style="grid-template-columns:1fr 1fr;">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4 style="color:var(--error);">&#x274C; Type I Error (&alpha;)</h4>
                    <p><strong>False positive.</strong> Rejecting H&#8320; when it is actually true. The probability is controlled by &alpha; (significance level).</p>
                    <p style="font-size:0.8125rem;margin-top:0.5rem;color:var(--text-muted);">Example: Concluding a drug works when it does not.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4 style="color:var(--warning);">&#x26A0;&#xFE0F; Type II Error (&beta;)</h4>
                    <p><strong>False negative.</strong> Failing to reject H&#8320; when it is actually false. Related to sample size and effect size.</p>
                    <p style="font-size:0.8125rem;margin-top:0.5rem;color:var(--text-muted);">Example: Missing a real drug effect due to small sample.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x2705; Correct: Reject true H&#8321;</h4>
                    <p>H&#8320; is false and we correctly reject it. This is the desired outcome of a well-powered test.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>&#x2705; Correct: Fail to reject true H&#8320;</h4>
                    <p>H&#8320; is true and we correctly fail to reject it. No false alarm.</p>
                </div>
            </div>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Statistical Power = 1 &minus; &beta;</strong> &mdash; the probability of correctly rejecting a false H&#8320;. Increase power by increasing sample size, using a larger &alpha;, or when the true effect size is large.
                </p>
            </div>
        </div>

        <!-- 5. When to Use Each Test -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">When to Use Each Test</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Test</th><th>Data Type</th><th>When to Use</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Z-test (mean)</td><td>Continuous</td><td>&sigma; is known, or n &gt; 30 with known population SD</td></tr>
                    <tr><td style="font-weight:600;">T-test (mean)</td><td>Continuous</td><td>&sigma; is unknown (use sample s). Works for any n with normal population</td></tr>
                    <tr><td style="font-weight:600;">One-proportion Z</td><td>Categorical</td><td>Compare sample proportion to a claimed value. Need np&#8320; &ge; 5 and n(1&minus;p&#8320;) &ge; 5</td></tr>
                    <tr><td style="font-weight:600;">Two-proportion Z</td><td>Categorical</td><td>Compare proportions from two independent groups. Uses pooled proportion under H&#8320;</td></tr>
                </tbody>
            </table>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Tip:</strong> In practice, the population &sigma; is almost never known, so the <strong>T-test</strong> is the most commonly used test for means. The Z-test is primarily used for proportions and in textbook problems.
                </p>
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is the difference between Z-test and T-test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the Z-test when the population standard deviation (&sigma;) is known or the sample size is very large. Use the T-test when &sigma; is unknown and you rely on the sample standard deviation (s). The T-distribution has heavier tails, especially for small samples, giving more conservative results.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I choose between one-tailed and two-tailed test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Choose a one-tailed test if you predict a specific direction (e.g., the new treatment is <em>better</em>). Choose a two-tailed test if you are testing for any difference in either direction. This decision must be made before collecting data to avoid bias.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What does &ldquo;reject H&#8320;&rdquo; mean?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Rejecting H&#8320; means the data provides sufficient evidence that the null hypothesis is unlikely. It does <em>not</em> prove H&#8321; is true. It means that if H&#8320; were true, the probability of seeing results this extreme is less than &alpha;.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between Type I and Type II error?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Type I error (&alpha;) is rejecting H&#8320; when it is actually true (false positive). Type II error (&beta;) is failing to reject H&#8320; when it is actually false (false negative). Alpha is controlled by the significance level you choose.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When should I use a proportion test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use a proportion test when your data is categorical (yes/no, pass/fail). A one-proportion test compares a sample proportion to a claimed value. A two-proportion test compares proportions from two independent groups, such as treatment vs. control conversion rates.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What assumptions must be met for these tests?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Z-test assumes known &sigma; and a normal population (or large n). T-test assumes a normal population (or large n). Proportion tests need np&#8320; and n(1&minus;p&#8320;) both at least 5. All tests assume random, independent samples.</div>
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
    <script src="<%=request.getContextPath()%>/js/hypothesis-test-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
