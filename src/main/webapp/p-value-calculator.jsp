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
        /* Significance level pills */
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
        <jsp:param name="toolName" value="P-Value Calculator Online - Z T Chi-Square F Test Free" />
        <jsp:param name="toolDescription" value="Calculate p-values from Z-score t-statistic chi-square and F-test statistics. One-tailed and two-tailed tests with distribution visualization and Python export." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="p-value-calculator.jsp" />
        <jsp:param name="toolKeywords" value="p-value calculator, p value, statistical significance, z-score to p-value, t-test p-value, chi-square p-value, f-test p-value, hypothesis testing, one-tailed test, two-tailed test" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Z-test p-value from Z-score,T-test p-value with degrees of freedom,Chi-square test p-value,F-test p-value with numerator and denominator df,Left-tailed right-tailed and two-tailed tests,Significance level classification,Interactive Plotly distribution visualization,Python scipy code generation" />
        <jsp:param name="teaches" value="P-values, statistical significance, hypothesis testing, Z-distribution, t-distribution, chi-square distribution, F-distribution, one-tailed vs two-tailed tests" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Test Type|Select Z-test T-test Chi-square or F-test,Set Tail Type|Pick left-tailed two-tailed or right-tailed test,Enter Test Statistic|Input your Z t chi-square or F value and degrees of freedom,Click Calculate|Get instant p-value with significance classification,View Distribution|See the distribution curve with shaded rejection region,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is a p-value and how do I interpret it?" />
        <jsp:param name="faq1a" value="A p-value is the probability of observing results at least as extreme as the data assuming the null hypothesis is true. A small p-value like less than 0.05 provides evidence against the null hypothesis. It is NOT the probability that the null hypothesis is true." />
        <jsp:param name="faq2q" value="When should I use one-tailed versus two-tailed test?" />
        <jsp:param name="faq2a" value="Use a one-tailed test when you have a directional hypothesis like the mean is greater than a value. Use two-tailed when you test for any difference in either direction. The choice must be made before looking at the data." />
        <jsp:param name="faq3q" value="Which distribution should I use for my test?" />
        <jsp:param name="faq3a" value="Use Z for large samples with known sigma. Use t for small samples with unknown sigma. Use chi-square for goodness of fit and independence tests. Use F for comparing variances or ANOVA." />
        <jsp:param name="faq4q" value="What are common significance levels?" />
        <jsp:param name="faq4a" value="The most common is alpha equals 0.05 or 95 percent confidence. For high stakes decisions use 0.01. For exploratory research 0.10 is sometimes used. The threshold should be chosen before conducting the test." />
        <jsp:param name="faq5q" value="Does a small p-value prove practical significance?" />
        <jsp:param name="faq5a" value="No. Statistical significance does not equal practical significance. A large sample can produce a tiny p-value for a trivially small effect. Always report effect sizes alongside p-values to assess real-world importance." />
        <jsp:param name="faq6q" value="What are common misconceptions about p-values?" />
        <jsp:param name="faq6a" value="Common mistakes include thinking p is the probability H0 is true or that 1 minus p is the probability H1 is true or that a non-significant result proves no effect exists. The p-value only measures evidence against H0 under the assumption H0 is true." />
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
                <h1 class="tool-page-title">P-Value Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    P-Value Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Z &amp; T Tests</span>
                <span class="tool-badge">Chi-Square &amp; F</span>
                <span class="tool-badge">One &amp; Two-Tailed</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>p-value calculator</strong> for <strong>Z-test</strong>, <strong>T-test</strong>, <strong>Chi-square</strong>, and <strong>F-test</strong>. One-tailed and two-tailed tests with significance classification, interactive distribution curve, and Python scipy export.</p>
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
                    P-Value Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Test Type Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Test Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" data-mode="z" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Z-Test</button>
                            <button type="button" class="stat-mode-btn" data-mode="t" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">T-Test</button>
                            <button type="button" class="stat-mode-btn" data-mode="chi" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Chi-Square</button>
                            <button type="button" class="stat-mode-btn" data-mode="f" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">F-Test</button>
                        </div>
                    </div>

                    <!-- Tail Type Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Tail Type</label>
                        <div class="stat-mode-toggle" style="display:flex;">
                            <button type="button" class="stat-mode-btn" data-tail="left" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Left</button>
                            <button type="button" class="stat-mode-btn active" data-tail="two" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Two-Tailed</button>
                            <button type="button" class="stat-mode-btn" data-tail="right" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Right</button>
                        </div>
                    </div>

                    <!-- Z-Test inputs -->
                    <div id="pv-input-z">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-z-score">Z-Score</label>
                            <input type="number" class="stat-input-text" id="pv-z-score" value="1.96" step="0.01">
                            <div class="tool-form-hint">Standard normal test statistic</div>
                        </div>
                    </div>

                    <!-- T-Test inputs -->
                    <div id="pv-input-t" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-t-stat">T-Statistic</label>
                            <input type="number" class="stat-input-text" id="pv-t-stat" value="2.5" step="0.01">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-t-df">Degrees of Freedom</label>
                            <input type="number" class="stat-input-text" id="pv-t-df" value="20" step="1" min="1">
                            <div class="tool-form-hint">Typically n &minus; 1 for one-sample t-test</div>
                        </div>
                    </div>

                    <!-- Chi-Square inputs -->
                    <div id="pv-input-chi" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-chi-stat">&chi;&sup2; Statistic</label>
                            <input type="number" class="stat-input-text" id="pv-chi-stat" value="5.99" step="0.01" min="0">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-chi-df">Degrees of Freedom</label>
                            <input type="number" class="stat-input-text" id="pv-chi-df" value="2" step="1" min="1">
                            <div class="tool-form-hint">Number of categories minus 1</div>
                        </div>
                    </div>

                    <!-- F-Test inputs -->
                    <div id="pv-input-f" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-f-stat">F-Statistic</label>
                            <input type="number" class="stat-input-text" id="pv-f-stat" value="3.5" step="0.01" min="0">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-f-df1">DF Numerator</label>
                            <input type="number" class="stat-input-text" id="pv-f-df1" value="3" step="1" min="1">
                            <div class="tool-form-hint">Between-group degrees of freedom</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pv-f-df2">DF Denominator</label>
                            <input type="number" class="stat-input-text" id="pv-f-df2" value="20" step="1" min="1">
                            <div class="tool-form-hint">Within-group degrees of freedom</div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="pv-calc-btn">Calculate P-Value</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="pv-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group" id="pv-examples">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="z-critical">Z = 1.96</button>
                            <button type="button" class="stat-example-chip" data-example="t-small">T-Test (df=20)</button>
                            <button type="button" class="stat-example-chip" data-example="chi-gof">Chi-Square GOF</button>
                            <button type="button" class="stat-example-chip" data-example="f-anova">F-Test (ANOVA)</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="pv-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="pv-graph-panel">Distribution</button>
                <button type="button" class="stat-output-tab" data-tab="pv-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="pv-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="pv-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter parameters and click Calculate</h3>
                            <p>Compute p-values for Z, T, Chi-square, or F test statistics.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="pv-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="pv-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>Distribution Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="pv-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="pv-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="pv-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="p-value-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is a P-Value? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a P-Value?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>p-value</strong> is the probability of observing a test statistic at least as extreme as the one computed from sample data, assuming the null hypothesis (H&#8320;) is true. It is a fundamental concept in <strong>hypothesis testing</strong> and helps researchers decide whether to reject H&#8320;.</p>

            <!-- Animated SVG: Bell curve with shaded tails -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 120" style="max-width:420px;width:100%;" aria-label="Bell curve with shaded rejection region">
                    <!-- Axis -->
                    <line x1="20" y1="100" x2="380" y2="100" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                    <!-- Bell curve -->
                    <path d="M20,100 Q60,98 100,90 Q140,60 160,35 Q180,12 200,8 Q220,12 240,35 Q260,60 300,90 Q340,98 380,100" fill="none" stroke="var(--text-secondary,#475569)" stroke-width="2.5" class="stat-anim stat-anim-d1"/>
                    <!-- Right tail shading -->
                    <path d="M300,90 Q340,98 380,100 L380,100 L300,100 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                    <!-- Left tail shading -->
                    <path d="M20,100 Q60,98 100,90 L100,100 L20,100 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                    <!-- Critical value markers -->
                    <line x1="100" y1="90" x2="100" y2="105" stroke="#e11d48" stroke-width="2" stroke-dasharray="3,2" class="stat-anim stat-anim-d3"/>
                    <line x1="300" y1="90" x2="300" y2="105" stroke="#e11d48" stroke-width="2" stroke-dasharray="3,2" class="stat-anim stat-anim-d3"/>
                    <!-- Labels -->
                    <text x="200" y="75" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">Fail to reject H&#8320;</text>
                    <text x="55" y="88" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">p/2</text>
                    <text x="345" y="88" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">p/2</text>
                    <text x="100" y="116" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">&minus;z*</text>
                    <text x="300" y="116" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">+z*</text>
                    <text x="200" y="116" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">0</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Probability Measure</h4>
                    <p>The p-value quantifies how likely observed data (or more extreme) would occur if H&#8320; were true. Ranges from 0 to 1.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                    <h4>Evidence Against H&#8320;</h4>
                    <p>A smaller p-value provides stronger evidence against the null hypothesis. It does NOT measure the probability that H&#8320; is true.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Decision Tool</h4>
                    <p>Compare p-value to significance level &alpha;. If p &le; &alpha;, reject H&#8320;. Common thresholds: 0.05, 0.01, 0.10.</p>
                </div>
            </div>
        </div>

        <!-- 2. P-Value Interpretation Guide -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">P-Value Interpretation Guide</h2>
            <p style="color:var(--text-secondary);margin-bottom:1.25rem;line-height:1.7;">The significance of a p-value depends on the chosen &alpha; level. Below are commonly used thresholds and their interpretations.</p>

            <div class="stat-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
                <div class="stat-feature-card stat-anim stat-anim-d1" style="border-left:4px solid #10b981;">
                    <h4 style="color:#10b981;">p &lt; 0.001</h4>
                    <p><strong>Highly Significant</strong> &mdash; Very strong evidence against the null hypothesis. Often denoted with *** in research papers.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2" style="border-left:4px solid #3b82f6;">
                    <h4 style="color:#3b82f6;">p &lt; 0.05</h4>
                    <p><strong>Significant</strong> &mdash; Sufficient evidence to reject H&#8320; at the standard 5% level. The most common threshold in science.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3" style="border-left:4px solid #f59e0b;">
                    <h4 style="color:#f59e0b;">p &lt; 0.10</h4>
                    <p><strong>Marginal</strong> &mdash; Weak evidence against H&#8320;. Sometimes called &ldquo;trending toward significance.&rdquo; Use with caution.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d4" style="border-left:4px solid #94a3b8;">
                    <h4 style="color:#94a3b8;">p &ge; 0.10</h4>
                    <p><strong>Not Significant</strong> &mdash; Insufficient evidence to reject H&#8320;. Does not prove H&#8320; is true, only that data is consistent with it.</p>
                </div>
            </div>
        </div>

        <!-- 3. Test Distributions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Test Distributions</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Z-Test:</strong>&nbsp; p = P(Z &ge; |z|) for standard normal. Used when &sigma; is known or n is large (&ge;30).
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>T-Test:</strong>&nbsp; p = P(T &ge; |t|) with df = n &minus; 1. Used when &sigma; is unknown and sample is small.
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Chi-Square:</strong>&nbsp; p = P(&chi;&sup2; &ge; x&sup2;) with df = k &minus; 1. Used for goodness-of-fit and independence tests.
            </div>
            <div class="stat-formula-box">
                <strong>F-Test:</strong>&nbsp; p = P(F &ge; f) with df&#8321; and df&#8322;. Used for ANOVA and comparing two variances.
            </div>

            <table class="stat-ops-table" style="margin-top:1.25rem;">
                <thead><tr><th>Distribution</th><th>Parameters</th><th>Common Use</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Z (Normal)</td><td>None (standard)</td><td>Large samples, known &sigma;, proportions</td></tr>
                    <tr><td style="font-weight:600;">t (Student&rsquo;s)</td><td>df = n &minus; 1</td><td>Small samples, unknown &sigma;</td></tr>
                    <tr><td style="font-weight:600;">&chi;&sup2; (Chi-square)</td><td>df = k &minus; 1</td><td>Categorical data, goodness-of-fit</td></tr>
                    <tr><td style="font-weight:600;">F (Fisher)</td><td>df&#8321;, df&#8322;</td><td>ANOVA, variance comparison</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. One-Tailed vs Two-Tailed Tests -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">One-Tailed vs Two-Tailed Tests</h2>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;margin:1.5rem 0;">
                <!-- One-Tailed SVG -->
                <div style="text-align:center;">
                    <svg viewBox="0 0 200 100" style="max-width:200px;width:100%;" aria-label="One-tailed test with right tail shaded">
                        <line x1="10" y1="85" x2="190" y2="85" stroke="var(--border-dark,#cbd5e1)" stroke-width="1"/>
                        <path d="M10,85 Q30,83 55,75 Q80,50 90,30 Q95,15 100,10 Q105,15 110,30 Q120,50 145,75 Q170,83 190,85" fill="none" stroke="var(--text-secondary,#475569)" stroke-width="2" class="stat-anim stat-anim-d1"/>
                        <path d="M145,75 Q170,83 190,85 L190,85 L145,85 Z" fill="#e11d48" opacity="0.35" class="stat-anim stat-anim-d2"/>
                        <text x="100" y="98" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">One-Tailed (right)</text>
                        <text x="168" y="72" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">&alpha;</text>
                    </svg>
                </div>
                <!-- Two-Tailed SVG -->
                <div style="text-align:center;">
                    <svg viewBox="0 0 200 100" style="max-width:200px;width:100%;" aria-label="Two-tailed test with both tails shaded">
                        <line x1="10" y1="85" x2="190" y2="85" stroke="var(--border-dark,#cbd5e1)" stroke-width="1"/>
                        <path d="M10,85 Q30,83 55,75 Q80,50 90,30 Q95,15 100,10 Q105,15 110,30 Q120,50 145,75 Q170,83 190,85" fill="none" stroke="var(--text-secondary,#475569)" stroke-width="2" class="stat-anim stat-anim-d1"/>
                        <path d="M145,75 Q170,83 190,85 L190,85 L145,85 Z" fill="#e11d48" opacity="0.35" class="stat-anim stat-anim-d2"/>
                        <path d="M10,85 Q30,83 55,75 L55,85 L10,85 Z" fill="#e11d48" opacity="0.35" class="stat-anim stat-anim-d2"/>
                        <text x="100" y="98" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">Two-Tailed</text>
                        <text x="32" y="72" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">&alpha;/2</text>
                        <text x="168" y="72" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">&alpha;/2</text>
                    </svg>
                </div>
            </div>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>One-Tailed (Directional)</h4>
                    <p>Tests for an effect in a <em>specific direction</em> (e.g., mean is <strong>greater than</strong> or <strong>less than</strong> a value). All &alpha; is concentrated in one tail, giving more power for that direction.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Two-Tailed (Non-directional)</h4>
                    <p>Tests for any difference in <em>either direction</em>. The &alpha; is split between both tails (&alpha;/2 each). More conservative but appropriate when the direction is not pre-specified.</p>
                </div>
            </div>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Important:</strong> The choice between one-tailed and two-tailed tests must be made <em>before</em> looking at the data. Choosing after seeing results inflates the false positive rate.
                </p>
            </div>
        </div>

        <!-- 5. Common Misconceptions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Misconceptions About P-Values</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x274C; &ldquo;P is the probability H&#8320; is true&rdquo;</h4>
                    <p><strong>Incorrect.</strong> The p-value is the probability of the <em>data</em> (or more extreme) given H&#8320; is true. It is P(data | H&#8320;), not P(H&#8320; | data). Bayesian methods are needed for the latter.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x274C; &ldquo;1 &minus; p = probability H&#8321; is true&rdquo;</h4>
                    <p><strong>Incorrect.</strong> A p-value of 0.03 does not mean there is a 97% chance the alternative is true. The p-value tells you about the data under H&#8320;, not the probability of any hypothesis.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x274C; &ldquo;Not significant = no effect&rdquo;</h4>
                    <p><strong>Incorrect.</strong> Failure to reject H&#8320; does not prove H&#8320;. It may simply mean the sample size was too small to detect the effect. &ldquo;Absence of evidence is not evidence of absence.&rdquo;</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>&#x2705; Correct Interpretation</h4>
                    <p><strong>Correct:</strong> &ldquo;Assuming H&#8320; is true, the probability of observing a test statistic as extreme as or more extreme than the one observed is p.&rdquo; Always interpret in context.</p>
                </div>
            </div>
        </div>

        <!-- 6. Frequently Asked Questions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is a p-value and how do I interpret it?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A p-value is the probability of observing results at least as extreme as the data, assuming the null hypothesis is true. A small p-value (e.g., less than 0.05) provides evidence against the null hypothesis. It is <em>not</em> the probability that the null hypothesis is true.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When should I use one-tailed versus two-tailed test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use a one-tailed test when you have a directional hypothesis (e.g., the mean is greater than a value). Use two-tailed when you test for any difference in either direction. The choice must be made before looking at the data.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Which distribution should I use for my test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use Z for large samples with known &sigma;. Use t for small samples with unknown &sigma;. Use chi-square for goodness-of-fit and independence tests. Use F for comparing variances or ANOVA.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are common significance levels?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The most common is &alpha; = 0.05 (95% confidence). For high-stakes decisions, use 0.01. For exploratory research, 0.10 is sometimes used. The threshold should be chosen before conducting the test.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Does a small p-value prove practical significance?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">No. Statistical significance does not equal practical significance. A large sample can produce a tiny p-value for a trivially small effect. Always report effect sizes alongside p-values to assess real-world importance.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are common misconceptions about p-values?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Common mistakes include thinking p is the probability H&#8320; is true, or that 1 &minus; p is the probability H&#8321; is true, or that a non-significant result proves no effect exists. The p-value only measures evidence against H&#8320; under the assumption H&#8320; is true.</div>
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
    <script src="<%=request.getContextPath()%>/js/p-value-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>