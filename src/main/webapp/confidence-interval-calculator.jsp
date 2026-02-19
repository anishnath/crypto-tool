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
        <jsp:param name="toolName" value="Confidence Interval Calculator Online - Mean Proportion Free" />
        <jsp:param name="toolDescription" value="Calculate confidence intervals for means proportions and differences. One-sample and two-sample CIs with t-distribution z-score margin of error interactive chart and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="confidence-interval-calculator.jsp" />
        <jsp:param name="toolKeywords" value="confidence interval calculator, CI calculator, mean confidence interval, proportion confidence interval, 95% confidence interval, margin of error calculator, t-distribution CI, two-sample CI, difference in means, difference in proportions, Welch t-test" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="One-sample mean confidence interval with t-distribution,Proportion CI with normal approximation,Two-sample mean difference with Welch degrees of freedom,Two-sample proportion difference CI,90% 95% 99% and custom confidence levels,Step-by-step KaTeX formulas,Interactive Plotly CI chart,Python scipy code generation" />
        <jsp:param name="teaches" value="Confidence intervals, margin of error, standard error, t-distribution, z-score, Welch approximation, proportion estimation, hypothesis testing" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose CI Type|Select one-sample mean or proportion or two-sample comparison,Set Confidence Level|Pick 90% or 95% or 99% or enter a custom level,Enter Parameters|Input sample mean SD size or successes and sample size,Click Calculate|Get instant confidence interval with step-by-step formulas,View Chart|See the CI visualized on an interactive Plotly chart,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What does a 95% confidence interval mean?" />
        <jsp:param name="faq1a" value="A 95% CI means that if you repeated the sampling process many times 95% of the resulting intervals would contain the true population parameter. It does not mean there is a 95% probability the true value lies in this specific interval." />
        <jsp:param name="faq2q" value="When should I use t-distribution versus z-score?" />
        <jsp:param name="faq2a" value="Use the t-distribution for means when the population standard deviation is unknown which is almost always. The z-score is used for proportions and when n is very large. For small samples the t-distribution has heavier tails giving wider intervals." />
        <jsp:param name="faq3q" value="How does sample size affect the confidence interval?" />
        <jsp:param name="faq3a" value="Larger samples reduce the standard error which narrows the confidence interval. The standard error decreases proportionally to the square root of n so quadrupling the sample size halves the interval width." />
        <jsp:param name="faq4q" value="What is the difference between one-sample and two-sample CI?" />
        <jsp:param name="faq4a" value="A one-sample CI estimates a single population parameter like the mean or proportion. A two-sample CI estimates the difference between two population parameters which is useful for comparing groups like treatment versus control." />
        <jsp:param name="faq5q" value="What is the Welch degrees of freedom approximation?" />
        <jsp:param name="faq5a" value="The Welch-Satterthwaite formula calculates effective degrees of freedom when comparing two means with unequal variances. It gives a more accurate t-critical value than the conservative minimum of n1-1 and n2-1." />
        <jsp:param name="faq6q" value="How do I interpret a CI that contains zero for a difference?" />
        <jsp:param name="faq6a" value="If a CI for the difference between two means or proportions includes zero it means the difference is not statistically significant at that confidence level. The data is consistent with no real difference between the groups." />
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
                <h1 class="tool-page-title">Confidence Interval Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Confidence Interval Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Mean &amp; Proportion</span>
                <span class="tool-badge">Two-Sample</span>
                <span class="tool-badge">t-Distribution</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>confidence interval calculator</strong> for <strong>means</strong> and <strong>proportions</strong>. Compute one-sample and two-sample CIs with t-distribution or z-score, margin of error, step-by-step KaTeX formulas, interactive Plotly chart, and Python scipy export.</p>
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
                    Confidence Interval
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">CI Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="ci-mode-mean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Mean</button>
                            <button type="button" class="stat-mode-btn" id="ci-mode-proportion" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Proportion</button>
                            <button type="button" class="stat-mode-btn" id="ci-mode-twomean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">2-Mean</button>
                            <button type="button" class="stat-mode-btn" id="ci-mode-twoprop" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">2-Prop</button>
                        </div>
                    </div>

                    <!-- Confidence Level -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Confidence Level</label>
                        <div class="ci-conf-pills">
                            <button type="button" class="ci-conf-pill" data-conf="90">90%</button>
                            <button type="button" class="ci-conf-pill active" data-conf="95">95%</button>
                            <button type="button" class="ci-conf-pill" data-conf="99">99%</button>
                            <button type="button" class="ci-conf-pill" data-conf="custom">Custom
                                <input type="number" class="ci-custom-input" id="ci-custom-conf" value="95" min="50" max="99.99" step="0.1" style="display:none;">
                            </button>
                        </div>
                    </div>

                    <!-- One-Sample Mean inputs -->
                    <div id="ci-input-mean">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ci-mean">Sample Mean (x&#772;)</label>
                            <input type="number" class="stat-input-text ci-input" id="ci-mean" value="50" step="0.01">
                            <div class="tool-form-hint">Average of your sample data</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ci-sd">Standard Deviation (s)</label>
                            <input type="number" class="stat-input-text ci-input" id="ci-sd" value="10" step="0.01" min="0">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ci-n">Sample Size (n)</label>
                            <input type="number" class="stat-input-text ci-input" id="ci-n" value="30" step="1" min="2">
                            <div class="tool-form-hint">Uses t-distribution with n&minus;1 degrees of freedom</div>
                        </div>
                    </div>

                    <!-- Proportion inputs -->
                    <div id="ci-input-proportion" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ci-successes">Number of Successes (x)</label>
                            <input type="number" class="stat-input-text ci-input" id="ci-successes" value="45" step="1" min="0">
                            <div class="tool-form-hint">Count of favorable outcomes</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ci-n-prop">Sample Size (n)</label>
                            <input type="number" class="stat-input-text ci-input" id="ci-n-prop" value="100" step="1" min="1">
                            <div class="tool-form-hint">Uses z-score (normal approximation)</div>
                        </div>
                    </div>

                    <!-- Two-Sample Mean inputs -->
                    <div id="ci-input-twomean" style="display:none;">
                        <div class="ci-two-sample">
                            <div class="ci-sample-group">
                                <h5>Sample 1</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-mean1">Mean (x&#772;&#8321;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-mean1" value="50" step="0.01">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-sd1">SD (s&#8321;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-sd1" value="10" step="0.01" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-n1">Size (n&#8321;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-n1" value="30" step="1" min="2">
                                </div>
                            </div>
                            <div class="ci-sample-group">
                                <h5>Sample 2</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-mean2">Mean (x&#772;&#8322;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-mean2" value="55" step="0.01">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-sd2">SD (s&#8322;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-sd2" value="12" step="0.01" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-n2">Size (n&#8322;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-n2" value="30" step="1" min="2">
                                </div>
                            </div>
                        </div>
                        <div class="tool-form-hint" style="margin-top:0.25rem;">Welch&rsquo;s t-test (unequal variances)</div>
                    </div>

                    <!-- Two-Sample Proportion inputs -->
                    <div id="ci-input-twoprop" style="display:none;">
                        <div class="ci-two-sample">
                            <div class="ci-sample-group">
                                <h5>Sample 1</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-x1">Successes (x&#8321;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-x1" value="45" step="1" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-np1">Size (n&#8321;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-np1" value="100" step="1" min="1">
                                </div>
                            </div>
                            <div class="ci-sample-group">
                                <h5>Sample 2</h5>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-x2">Successes (x&#8322;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-x2" value="60" step="1" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="ci-np2">Size (n&#8322;)</label>
                                    <input type="number" class="stat-input-text ci-input" id="ci-np2" value="100" step="1" min="1">
                                </div>
                            </div>
                        </div>
                        <div class="tool-form-hint" style="margin-top:0.25rem;">Normal approximation (z-score)</div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="ci-calc-btn">Calculate Confidence Interval</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="ci-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-ci-example="exam-scores">Exam Scores</button>
                            <button type="button" class="stat-example-chip" data-ci-example="poll">Election Poll</button>
                            <button type="button" class="stat-example-chip" data-ci-example="treatment">Treatment Effect</button>
                            <button type="button" class="stat-example-chip" data-ci-example="ab-test">A/B Test</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="ci-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="ci-graph-panel">CI Chart</button>
                <button type="button" class="stat-output-tab" data-tab="ci-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="ci-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="ci-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter parameters and click Calculate</h3>
                            <p>Compute confidence intervals for means, proportions, or differences.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="ci-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="ci-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>CI Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="ci-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="ci-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="ci-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="confidence-interval-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is a Confidence Interval? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a Confidence Interval?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>confidence interval</strong> (CI) is a range of values that likely contains the true population parameter. It quantifies the uncertainty in a sample estimate and is fundamental to statistical inference.</p>

            <!-- Animated SVG: CI on number line -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 80" style="max-width:400px;width:100%;" aria-label="Confidence interval on a number line">
                    <line x1="30" y1="40" x2="370" y2="40" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                    <line x1="110" y1="30" x2="110" y2="50" stroke="#e11d48" stroke-width="3" class="stat-anim stat-anim-d1"/>
                    <line x1="290" y1="30" x2="290" y2="50" stroke="#e11d48" stroke-width="3" class="stat-anim stat-anim-d2"/>
                    <line x1="110" y1="40" x2="290" y2="40" stroke="#e11d48" stroke-width="4" opacity="0.3" class="stat-anim stat-anim-d1"/>
                    <circle cx="200" cy="40" r="6" fill="#ef4444" class="stat-anim stat-anim-d3"/>
                    <text x="110" y="65" text-anchor="middle" font-size="11" fill="var(--text-secondary,#475569)">Lower</text>
                    <text x="200" y="65" text-anchor="middle" font-size="11" fill="#ef4444" font-weight="600">x&#772;</text>
                    <text x="290" y="65" text-anchor="middle" font-size="11" fill="var(--text-secondary,#475569)">Upper</text>
                    <text x="200" y="22" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">95% Confidence Interval</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Point Estimate</h4>
                    <p>The sample statistic (mean or proportion) is our best single guess for the population parameter.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2194;&#xFE0F;</div>
                    <h4>Margin of Error</h4>
                    <p>How far the interval extends from the point estimate. Depends on confidence level, variability, and sample size.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Interval Width</h4>
                    <p>Narrower = more precise. Increase sample size or decrease confidence level for a tighter interval.</p>
                </div>
            </div>
        </div>

        <!-- 2. Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Confidence Interval Formulas</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Mean (one-sample):</strong>&nbsp; CI = x&#772; &plusmn; t<sub>&alpha;/2, n&minus;1</sub> &times; s / &radic;n
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Proportion:</strong>&nbsp; CI = p&#770; &plusmn; z<sub>&alpha;/2</sub> &times; &radic;(p&#770;(1&minus;p&#770;) / n)
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Difference in means:</strong>&nbsp; CI = (x&#772;<sub>1</sub> &minus; x&#772;<sub>2</sub>) &plusmn; t &times; &radic;(s<sub>1</sub>&sup2;/n<sub>1</sub> + s<sub>2</sub>&sup2;/n<sub>2</sub>)
            </div>
            <div class="stat-formula-box">
                <strong>Difference in proportions:</strong>&nbsp; CI = (p&#770;<sub>1</sub> &minus; p&#770;<sub>2</sub>) &plusmn; z &times; &radic;(p&#770;<sub>1</sub>(1&minus;p&#770;<sub>1</sub>)/n<sub>1</sub> + p&#770;<sub>2</sub>(1&minus;p&#770;<sub>2</sub>)/n<sub>2</sub>)
            </div>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> A sample of n=25 students has mean score x&#772;=78 and s=8. Find the 95% CI for the population mean.
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    SE = 8 / &radic;25 = 1.6<br>
                    df = 24, t<sub>0.025, 24</sub> = 2.064<br>
                    MoE = 2.064 &times; 1.6 = 3.30<br>
                    95% CI = [78 &minus; 3.30, 78 + 3.30] = <strong>[74.70, 81.30]</strong>
                </div>
            </div>
        </div>

        <!-- 3. Common Confidence Levels -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Confidence Levels</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Level</th><th>z* Critical Value</th><th>Use Case</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">90%</td><td>1.645</td><td>Quick estimates, exploratory analysis</td></tr>
                    <tr><td style="font-weight:600;">95%</td><td>1.960</td><td>Standard for most research and publications</td></tr>
                    <tr><td style="font-weight:600;">99%</td><td>2.576</td><td>High-stakes decisions, critical applications</td></tr>
                </tbody>
            </table>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Trade-off:</strong> Higher confidence level &rarr; wider interval (more certainty, less precision). Larger sample size &rarr; narrower interval (more precision without sacrificing certainty).
                </p>
            </div>
        </div>

        <!-- 4. Interpreting Confidence Intervals -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpreting Confidence Intervals</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x2705; Correct Interpretation</h4>
                    <p>&ldquo;We are 95% confident that the true population mean lies between 45 and 55.&rdquo; This refers to the <em>procedure</em>, not this specific interval.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x274C; Common Mistake</h4>
                    <p>&ldquo;There is a 95% probability the true mean is in this interval.&rdquo; The true mean is fixed &mdash; it either is or isn&rsquo;t in the interval.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x1F50D; Two-Sample CIs</h4>
                    <p>If a CI for a difference contains 0, the difference is not statistically significant. If it excludes 0, the groups differ significantly.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>&#x26A0;&#xFE0F; Overlapping CIs</h4>
                    <p>Two overlapping CIs do <em>not</em> necessarily mean no significant difference. Always use a proper two-sample test or CI.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What does a 95% confidence interval mean?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A 95% CI means that if you repeated the sampling process many times, 95% of the resulting intervals would contain the true population parameter. It does <em>not</em> mean there is a 95% probability this specific interval contains the true value.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When should I use t-distribution versus z-score?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the t-distribution for means when the population standard deviation is unknown (almost always). The z-score is used for proportions and when n is very large. For small samples, the t-distribution has heavier tails, giving wider intervals.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How does sample size affect the confidence interval?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Larger samples reduce the standard error, which narrows the CI. The standard error decreases proportionally to &radic;n, so quadrupling the sample size halves the interval width.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between one-sample and two-sample CI?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A one-sample CI estimates a single population parameter (mean or proportion). A two-sample CI estimates the <em>difference</em> between two population parameters &mdash; useful for comparing groups like treatment vs. control.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the Welch degrees of freedom approximation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The Welch-Satterthwaite formula calculates effective degrees of freedom when comparing two means with unequal variances. It gives a more accurate t-critical value than the conservative min(n<sub>1</sub>&minus;1, n<sub>2</sub>&minus;1).</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret a CI that contains zero for a difference?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">If a CI for the difference between two means or proportions includes zero, the difference is not statistically significant at that confidence level. The data is consistent with no real difference between the groups.</div>
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
    <script src="<%=request.getContextPath()%>/js/confidence-interval-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
