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
        /* 2x2 contingency table for OR/RR */
        .es-table-2x2{width:100%;border-collapse:collapse;font-size:0.8125rem;margin:0.5rem 0}
        .es-table-2x2 th,.es-table-2x2 td{padding:0.375rem 0.5rem;border:1px solid var(--border);text-align:center}
        .es-table-2x2 th{background:var(--tool-light);color:var(--tool-primary);font-weight:600;font-size:0.75rem}
        .es-table-2x2 input{width:60px;padding:0.25rem;border:1.5px solid var(--border);border-radius:0.375rem;text-align:center;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary)}
        .es-table-2x2 input:focus{outline:none;border-color:var(--tool-primary)}
        [data-theme="dark"] .es-table-2x2 th{background:var(--tool-light)}
        [data-theme="dark"] .es-table-2x2 input{background:var(--bg-tertiary);border-color:var(--border)}
        /* Two-column group grid */
        .es-two-group{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem}
        .es-group-label{font-size:0.75rem;font-weight:600;color:var(--tool-primary);margin-bottom:0.5rem}
        @media(max-width:480px){.es-two-group{grid-template-columns:1fr}}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Effect Size Calculator Online - Cohen d Pearson r Eta Squared Free" />
        <jsp:param name="toolDescription" value="Calculate effect sizes including Cohen d Pearson r Eta-squared Odds Ratio and Risk Ratio with confidence intervals interpretation guidelines and visualization." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="effect-size-calculator.jsp" />
        <jsp:param name="toolKeywords" value="effect size calculator, cohen d calculator, pearson r effect size, eta squared calculator, odds ratio calculator, risk ratio calculator, hedges g, statistical effect size, meta-analysis, practical significance" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Cohen d for standardized mean difference,Pearson r from correlation or t-statistic,Eta-squared for ANOVA effect size,Odds Ratio with confidence interval,Risk Ratio with confidence interval,Small medium large interpretation,Interactive Plotly visualization,Python scipy code generation" />
        <jsp:param name="teaches" value="Effect size, Cohen d, Pearson r, Eta-squared, Odds Ratio, Risk Ratio, practical significance, meta-analysis" />
        <jsp:param name="educationalLevel" value="College, University, Graduate" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Effect Size Type|Select Cohen d or Pearson r or Eta-squared or Odds/Risk Ratio,Enter Data|Input group means and SDs or correlation or F-statistic or 2x2 table,Set Confidence Level|Choose 90% or 95% or 99% for confidence interval,Click Calculate|Get effect size with CI interpretation and guidelines,View Visualization|See effect size displayed as overlapping curves or forest plot,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="Which effect size should I use?" />
        <jsp:param name="faq1a" value="Use Cohen d for comparing two group means. Use Pearson r for correlations. Use Eta-squared for ANOVA with multiple groups. Use Odds or Risk Ratio for categorical outcomes in 2x2 tables." />
        <jsp:param name="faq2q" value="What is considered a small medium or large effect?" />
        <jsp:param name="faq2a" value="For Cohen d small is 0.2 medium is 0.5 and large is 0.8. For Pearson r small is 0.1 medium is 0.3 and large is 0.5. For Eta-squared small is 0.01 medium is 0.06 and large is 0.14. These are Cohen 1988 benchmarks." />
        <jsp:param name="faq3q" value="Why is effect size important beyond p-value?" />
        <jsp:param name="faq3a" value="P-values only tell you if an effect exists but not how large it is. A tiny effect can be statistically significant with a large enough sample. Effect size quantifies practical significance and allows comparison across studies." />
        <jsp:param name="faq4q" value="What is the difference between Cohen d and Hedges g?" />
        <jsp:param name="faq4a" value="Hedges g applies a small-sample bias correction to Cohen d. For samples larger than about 20 per group the difference is negligible. Use Hedges g when reporting in meta-analyses or with small samples." />
        <jsp:param name="faq5q" value="How do I interpret an Odds Ratio confidence interval?" />
        <jsp:param name="faq5a" value="If the 95% CI for an OR includes 1.0 the association is not statistically significant. An OR of 2.5 with CI 1.2 to 5.2 means the odds are significantly 2.5 times higher in the exposed group." />
        <jsp:param name="faq6q" value="Can I convert between effect size measures?" />
        <jsp:param name="faq6a" value="Yes. Cohen d can be converted to r using r = d divided by the square root of d squared plus 4. Eta-squared can be derived from d using eta squared = d squared divided by d squared plus 4." />
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
                <h1 class="tool-page-title">Effect Size Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Effect Size Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Cohen's d</span>
                <span class="tool-badge">Pearson's r</span>
                <span class="tool-badge">Eta-squared</span>
                <span class="tool-badge">OR &amp; RR</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>effect size calculator</strong> for <strong>Cohen's d</strong>, <strong>Pearson's r</strong>, <strong>Eta-squared</strong>, <strong>Odds Ratio</strong>, and <strong>Risk Ratio</strong>. Get confidence intervals, interpretation guidelines, interactive visualizations, and Python scipy code.</p>
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
                    Effect Size
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Effect Size Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="es-mode-cohend" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Cohen's d</button>
                            <button type="button" class="stat-mode-btn" id="es-mode-pearsonr" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Pearson's r</button>
                            <button type="button" class="stat-mode-btn" id="es-mode-eta" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">&eta;&sup2; (ANOVA)</button>
                            <button type="button" class="stat-mode-btn" id="es-mode-odds" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Odds/Risk</button>
                        </div>
                    </div>

                    <!-- Confidence Level -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="es-confidence">Confidence Level</label>
                        <select class="stat-input-text" id="es-confidence" style="width:100%;">
                            <option value="90">90%</option>
                            <option value="95" selected>95%</option>
                            <option value="99">99%</option>
                        </select>
                    </div>

                    <!-- Cohen's d inputs -->
                    <div id="es-input-cohend">
                        <div class="es-two-group">
                            <div>
                                <div class="es-group-label">Group 1</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="es-m1">Mean</label>
                                    <input type="number" class="stat-input-text" id="es-m1" value="50" step="0.01">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="es-sd1">SD</label>
                                    <input type="number" class="stat-input-text" id="es-sd1" value="10" step="0.01" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="es-n1">Size</label>
                                    <input type="number" class="stat-input-text" id="es-n1" value="30" step="1" min="2">
                                </div>
                            </div>
                            <div>
                                <div class="es-group-label">Group 2</div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="es-m2">Mean</label>
                                    <input type="number" class="stat-input-text" id="es-m2" value="55" step="0.01">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="es-sd2">SD</label>
                                    <input type="number" class="stat-input-text" id="es-sd2" value="10" step="0.01" min="0">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="es-n2">Size</label>
                                    <input type="number" class="stat-input-text" id="es-n2" value="30" step="1" min="2">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pearson's r inputs -->
                    <div id="es-input-pearsonr" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="es-r-method">Method</label>
                            <select class="stat-input-text" id="es-r-method" style="width:100%;">
                                <option value="direct">Direct r value</option>
                                <option value="ttest">From t-statistic</option>
                            </select>
                        </div>
                        <div id="es-r-direct-panel">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-r">Correlation (r)</label>
                                <input type="number" class="stat-input-text" id="es-r" value="0.5" step="0.01" min="-1" max="1">
                                <div class="tool-form-hint">Value between &minus;1 and 1</div>
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-r-n">Sample Size (n)</label>
                                <input type="number" class="stat-input-text" id="es-r-n" value="50" step="1" min="4">
                            </div>
                        </div>
                        <div id="es-r-ttest-panel" style="display:none;">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-r-t">t-statistic</label>
                                <input type="number" class="stat-input-text" id="es-r-t" value="3.5" step="0.01">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-r-df">Degrees of Freedom (df)</label>
                                <input type="number" class="stat-input-text" id="es-r-df" value="48" step="1" min="1">
                            </div>
                        </div>
                    </div>

                    <!-- Eta-squared inputs -->
                    <div id="es-input-eta" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="es-eta-method">Method</label>
                            <select class="stat-input-text" id="es-eta-method" style="width:100%;">
                                <option value="fstat">From F-statistic</option>
                                <option value="ss">From SS values</option>
                            </select>
                        </div>
                        <div id="es-eta-fstat-panel">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-eta-f">F-statistic</label>
                                <input type="number" class="stat-input-text" id="es-eta-f" value="5.2" step="0.01" min="0">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-eta-df-between">df Between Groups</label>
                                <input type="number" class="stat-input-text" id="es-eta-df-between" value="2" step="1" min="1">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-eta-df-within">df Within Groups</label>
                                <input type="number" class="stat-input-text" id="es-eta-df-within" value="57" step="1" min="1">
                            </div>
                        </div>
                        <div id="es-eta-direct-panel" style="display:none;">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-eta-ss-between">SS Between (SS<sub>B</sub>)</label>
                                <input type="number" class="stat-input-text" id="es-eta-ss-between" value="250" step="0.01" min="0">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="es-eta-ss-total">SS Total (SS<sub>T</sub>)</label>
                                <input type="number" class="stat-input-text" id="es-eta-ss-total" value="800" step="0.01" min="0">
                            </div>
                        </div>
                    </div>

                    <!-- Odds/Risk Ratio inputs -->
                    <div id="es-input-odds" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="es-or-type">Type</label>
                            <select class="stat-input-text" id="es-or-type" style="width:100%;">
                                <option value="or">Odds Ratio (OR)</option>
                                <option value="rr">Risk Ratio (RR)</option>
                            </select>
                        </div>
                        <table class="es-table-2x2">
                            <thead>
                                <tr><th></th><th>Exposed</th><th>Not Exposed</th></tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>Disease</th>
                                    <td><input type="number" id="es-or-a" value="20" min="0" step="1"></td>
                                    <td><input type="number" id="es-or-b" value="10" min="0" step="1"></td>
                                </tr>
                                <tr>
                                    <th>No Disease</th>
                                    <td><input type="number" id="es-or-c" value="30" min="0" step="1"></td>
                                    <td><input type="number" id="es-or-d" value="40" min="0" step="1"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="es-calc-btn">Calculate Effect Size</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="es-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group" id="es-examples">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="treatment-effect">Treatment Effect</button>
                            <button type="button" class="stat-example-chip" data-example="study-correlation">Study Correlation</button>
                            <button type="button" class="stat-example-chip" data-example="anova-groups">ANOVA Groups</button>
                            <button type="button" class="stat-example-chip" data-example="clinical-exposure">Clinical Exposure</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="es-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="es-graph-panel">Visualization</button>
                <button type="button" class="stat-output-tab" data-tab="es-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="es-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="es-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter parameters and click Calculate</h3>
                            <p>Compute effect sizes for Cohen's d, Pearson's r, Eta-squared, or Odds/Risk Ratio.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="es-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="es-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>Effect Size Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="es-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="es-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="es-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="effect-size-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Effect Size? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Effect Size?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Effect size</strong> is a quantitative measure of the magnitude of a phenomenon. Unlike p-values which only indicate whether an effect exists, effect size tells you <em>how large</em> the effect is &mdash; making it essential for practical significance, meta-analysis, and power analysis.</p>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Practical Significance</h4>
                    <p>Effect size quantifies how meaningful a result is in practice, beyond statistical significance alone.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F4DA;</div>
                    <h4>Meta-Analysis</h4>
                    <p>Effect sizes allow combining and comparing results across different studies with different scales and sample sizes.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F50B;</div>
                    <h4>Power Planning</h4>
                    <p>Knowing the expected effect size is essential for calculating the sample size needed to detect it reliably.</p>
                </div>
            </div>
        </div>

        <!-- 2. Effect Size Measures & Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Effect Size Measures &amp; Formulas</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Cohen's d:</strong>&nbsp; d = (M&#8321; &minus; M&#8322;) / SD<sub>pooled</sub>
                <div class="tool-form-hint">Standardized mean difference between two groups</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Pearson's r:</strong>&nbsp; r = t / &radic;(t&sup2; + df)
                <div class="tool-form-hint">Correlation coefficient or converted from t-statistic</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Eta-squared:</strong>&nbsp; &eta;&sup2; = SS<sub>B</sub> / SS<sub>T</sub>
                <div class="tool-form-hint">Proportion of variance explained in ANOVA</div>
            </div>
            <div class="stat-formula-box">
                <strong>Odds Ratio:</strong>&nbsp; OR = (a &times; d) / (b &times; c) &nbsp;&nbsp;|&nbsp;&nbsp; <strong>Risk Ratio:</strong>&nbsp; RR = (a/(a+b)) / (c/(c+d))
                <div class="tool-form-hint">Association measures for 2&times;2 contingency tables</div>
            </div>
        </div>

        <!-- 3. Interpretation Guidelines -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpretation Guidelines</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Measure</th><th>Small</th><th>Medium</th><th>Large</th><th>Very Large</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Cohen's d</td><td>0.2</td><td>0.5</td><td>0.8</td><td>1.2</td></tr>
                    <tr><td style="font-weight:600;">Pearson's r</td><td>0.1</td><td>0.3</td><td>0.5</td><td>0.7</td></tr>
                    <tr><td style="font-weight:600;">Eta-squared (&eta;&sup2;)</td><td>0.01</td><td>0.06</td><td>0.14</td><td>0.20</td></tr>
                    <tr><td style="font-weight:600;">Odds Ratio</td><td>1.5</td><td>2.5</td><td>4.3</td><td>10+</td></tr>
                </tbody>
            </table>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Note:</strong> These benchmarks are from Cohen (1988) and are general guidelines. The practical significance of an effect size depends on the research context. A &ldquo;small&rdquo; effect can be highly meaningful in some domains.
                </p>
            </div>
        </div>

        <!-- 4. Why Effect Size Matters -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Why Effect Size Matters</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x1F4C9; Beyond p-values</h4>
                    <p>A statistically significant p-value with a tiny effect size means the result is real but practically meaningless. Effect size tells you whether it matters.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x1F4DD; Publication Standards</h4>
                    <p>APA, CONSORT, and major journals now require effect sizes. Reporting only p-values is increasingly seen as incomplete statistical practice.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x1F50D; Cross-Study Comparison</h4>
                    <p>Effect sizes allow you to compare findings across studies that used different scales, measures, or sample sizes &mdash; essential for systematic reviews.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>&#x1F4CB; Sample Size Planning</h4>
                    <p>Power analysis requires an expected effect size. Knowing whether you expect a small or large effect determines how many participants you need.</p>
                </div>
            </div>
        </div>

        <!-- 5. Converting Between Measures -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Converting Between Measures</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>d &rarr; r:</strong>&nbsp; r = d / &radic;(d&sup2; + 4)
                <div class="tool-form-hint">Convert Cohen's d to Pearson's r</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>r &rarr; d:</strong>&nbsp; d = 2r / &radic;(1 &minus; r&sup2;)
                <div class="tool-form-hint">Convert Pearson's r to Cohen's d</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>d &rarr; &eta;&sup2;:</strong>&nbsp; &eta;&sup2; = d&sup2; / (d&sup2; + 4)
                <div class="tool-form-hint">Approximate eta-squared from Cohen's d (equal groups)</div>
            </div>
            <div class="stat-formula-box">
                <strong>OR &rarr; d:</strong>&nbsp; d = ln(OR) &times; &radic;3 / &pi;
                <div class="tool-form-hint">Convert log Odds Ratio to Cohen's d (Hasselblad &amp; Hedges)</div>
            </div>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> Convert Cohen's d = 0.5 to Pearson's r.
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    r = 0.5 / &radic;(0.5&sup2; + 4)<br>
                    r = 0.5 / &radic;(0.25 + 4)<br>
                    r = 0.5 / &radic;4.25<br>
                    r = 0.5 / 2.062 = <strong>0.243</strong>
                </div>
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">Which effect size should I use?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use <strong>Cohen's d</strong> for comparing two group means. Use <strong>Pearson's r</strong> for correlations. Use <strong>Eta-squared</strong> for ANOVA with multiple groups. Use <strong>Odds or Risk Ratio</strong> for categorical outcomes in 2&times;2 tables.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is considered a small, medium, or large effect?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">For Cohen's d: small is 0.2, medium is 0.5, and large is 0.8. For Pearson's r: small is 0.1, medium is 0.3, and large is 0.5. For Eta-squared: small is 0.01, medium is 0.06, and large is 0.14. These are Cohen (1988) benchmarks.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Why is effect size important beyond p-value?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">P-values only tell you if an effect exists, but not how large it is. A tiny effect can be statistically significant with a large enough sample. Effect size quantifies practical significance and allows comparison across studies.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between Cohen's d and Hedges' g?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Hedges' g applies a small-sample bias correction to Cohen's d. For samples larger than about 20 per group, the difference is negligible. Use Hedges' g when reporting in meta-analyses or with small samples.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret an Odds Ratio confidence interval?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">If the 95% CI for an OR includes 1.0, the association is not statistically significant. An OR of 2.5 with CI [1.2, 5.2] means the odds are significantly 2.5 times higher in the exposed group.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Can I convert between effect size measures?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Yes. Cohen's d can be converted to r using r = d / &radic;(d&sup2; + 4). Eta-squared can be derived from d using &eta;&sup2; = d&sup2; / (d&sup2; + 4). Odds Ratio can be converted to d using d = ln(OR) &times; &radic;3 / &pi;.</div>
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
    <script src="<%=request.getContextPath()%>/js/effect-size-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
