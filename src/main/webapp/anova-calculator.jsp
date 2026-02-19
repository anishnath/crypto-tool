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
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ANOVA Calculator Online - One-Way Analysis of Variance Free" />
        <jsp:param name="toolDescription" value="One-way ANOVA calculator. Compare means of multiple groups with F-statistic p-value ANOVA table eta-squared effect size box plots and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="anova-calculator.jsp" />
        <jsp:param name="toolKeywords" value="anova calculator, analysis of variance, one-way anova, f-test, f-statistic, compare group means, sum of squares, mean square, eta squared, post-hoc test" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="One-way ANOVA with dynamic group management,F-statistic and p-value calculation,Complete ANOVA table with SS df MS,Eta-squared effect size with interpretation,Per-group descriptive statistics,Interactive Plotly box plots and F-distribution,Step-by-step KaTeX formulas,Python scipy f_oneway code generation" />
        <jsp:param name="teaches" value="Analysis of variance, F-test, between-group variance, within-group variance, sum of squares, mean squares, eta-squared, effect size, post-hoc tests" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Group Data|Type or paste numbers for each group separated by commas,Add Groups|Click Add Group to compare more than 3 groups,Set Alpha|Choose significance level 0.01 or 0.05 or 0.10,Click Calculate|Get F-statistic p-value and ANOVA table instantly,View Box Plots|Compare group distributions with interactive charts,Export Code|Run Python scipy f_oneway code in the compiler" />
        <jsp:param name="faq1q" value="What is one-way ANOVA used for?" />
        <jsp:param name="faq1a" value="One-way ANOVA tests whether the means of three or more independent groups are significantly different. It compares between-group variance to within-group variance using the F-statistic. If significant at least one group mean differs from the others." />
        <jsp:param name="faq2q" value="What are the assumptions of ANOVA?" />
        <jsp:param name="faq2a" value="ANOVA assumes independence of observations normal distribution within each group and homogeneity of variances across groups. ANOVA is robust to moderate violations of normality especially with larger sample sizes." />
        <jsp:param name="faq3q" value="What do I do after a significant ANOVA result?" />
        <jsp:param name="faq3a" value="A significant ANOVA tells you at least one group differs but not which ones. Use post-hoc tests like Tukey HSD to find specific pairwise differences while controlling the family-wise error rate." />
        <jsp:param name="faq4q" value="How do I interpret eta-squared?" />
        <jsp:param name="faq4a" value="Eta-squared measures the proportion of total variance explained by group membership. Guidelines are 0.01 is small 0.06 is medium and 0.14 is large. It helps assess practical significance beyond the p-value." />
        <jsp:param name="faq5q" value="What is the difference between one-way and two-way ANOVA?" />
        <jsp:param name="faq5a" value="One-way ANOVA has one independent variable or factor. Two-way ANOVA has two factors and can test for interaction effects between them. This calculator performs one-way ANOVA." />
        <jsp:param name="faq6q" value="What if ANOVA assumptions are violated?" />
        <jsp:param name="faq6a" value="If normality is violated consider the Kruskal-Wallis non-parametric test. If variances are unequal use Welch ANOVA. For small samples consider bootstrapping or exact permutation tests." />
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
                <h1 class="tool-page-title">ANOVA Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    ANOVA Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">One-Way ANOVA</span>
                <span class="tool-badge">F-Test &amp; Effect Size</span>
                <span class="tool-badge">Box Plots</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>one-way ANOVA calculator</strong>. Compare means of <strong>multiple groups</strong> with F-statistic, p-value, complete ANOVA table, eta-squared effect size, interactive box plots, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M3 3v18h18"/><rect x="7" y="10" width="3" height="8" rx="0.5"/><rect x="13" y="6" width="3" height="12" rx="0.5"/><rect x="19" y="3" width="3" height="15" rx="0.5"/>
                    </svg>
                    ANOVA &mdash; Analysis of Variance
                </div>
                <div class="tool-card-body">
                    <!-- Groups Container -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Group Data</label>
                        <div class="tool-form-hint" style="margin-bottom:0.5rem;">Enter numbers separated by commas, spaces, or newlines</div>
                        <div id="av-groups-container">
                            <!-- JS replaces this on init via renderGroupInputs() -->
                            <div class="av-group-box">
                                <div class="av-group-header"><h5>Group 1</h5></div>
                                <textarea class="stat-textarea" id="av-group-0" rows="3" placeholder="Enter values separated by commas or spaces">23, 25, 27, 22, 24</textarea>
                            </div>
                            <div class="av-group-box">
                                <div class="av-group-header"><h5>Group 2</h5></div>
                                <textarea class="stat-textarea" id="av-group-1" rows="3" placeholder="Enter values separated by commas or spaces">28, 30, 32, 29, 31</textarea>
                            </div>
                            <div class="av-group-box">
                                <div class="av-group-header"><h5>Group 3</h5></div>
                                <textarea class="stat-textarea" id="av-group-2" rows="3" placeholder="Enter values separated by commas or spaces">33, 35, 37, 34, 36</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Add Group Button -->
                    <button type="button" id="av-add-group-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);width:100%;padding:0.5rem;border-radius:0.5rem;font-weight:600;font-size:0.8125rem;cursor:pointer;margin-bottom:0.75rem;font-family:var(--font-sans);">+ Add Group</button>

                    <!-- Significance Level -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="av-alpha">Significance Level (&alpha;)</label>
                        <select class="stat-input-text" id="av-alpha" style="min-height:auto;padding:0.5rem 0.75rem;">
                            <option value="0.01">0.01 (99% confidence)</option>
                            <option value="0.05" selected>0.05 (95% confidence)</option>
                            <option value="0.10">0.10 (90% confidence)</option>
                        </select>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="av-calc-btn">Calculate ANOVA</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="av-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group" id="av-examples">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="teaching-methods">Teaching Methods</button>
                            <button type="button" class="stat-example-chip" data-example="fertilizers">Fertilizers</button>
                            <button type="button" class="stat-example-chip" data-example="medications">Medications</button>
                            <button type="button" class="stat-example-chip" data-example="no-difference">No Difference</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="av-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="av-graph-panel">Charts</button>
                <button type="button" class="stat-output-tab" data-tab="av-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="av-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="av-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter group data and click Calculate</h3>
                            <p>Compare means of multiple groups with one-way ANOVA.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="av-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="av-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>Box Plots &amp; F-Distribution</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="av-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="av-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="av-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="anova-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is ANOVA? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is ANOVA?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Analysis of Variance</strong> (ANOVA) is a statistical method that tests whether the means of three or more groups are significantly different. Instead of running multiple t-tests, ANOVA compares the variance <em>between</em> groups to the variance <em>within</em> groups using a single F-test.</p>

            <!-- Animated SVG: Group comparison -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 100" style="max-width:400px;width:100%;" aria-label="Three groups with different means">
                    <line x1="30" y1="80" x2="370" y2="80" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                    <!-- Group 1 -->
                    <circle cx="100" cy="50" r="20" fill="#e11d48" opacity="0.15" class="stat-anim stat-anim-d1"/>
                    <circle cx="100" cy="50" r="4" fill="#e11d48" class="stat-anim stat-anim-d1"/>
                    <text x="100" y="92" text-anchor="middle" font-size="10" fill="var(--text-secondary)">Group 1</text>
                    <!-- Group 2 -->
                    <circle cx="200" cy="40" r="20" fill="#f59e0b" opacity="0.15" class="stat-anim stat-anim-d2"/>
                    <circle cx="200" cy="40" r="4" fill="#f59e0b" class="stat-anim stat-anim-d2"/>
                    <text x="200" y="92" text-anchor="middle" font-size="10" fill="var(--text-secondary)">Group 2</text>
                    <!-- Group 3 -->
                    <circle cx="300" cy="30" r="20" fill="#3b82f6" opacity="0.15" class="stat-anim stat-anim-d3"/>
                    <circle cx="300" cy="30" r="4" fill="#3b82f6" class="stat-anim stat-anim-d3"/>
                    <text x="300" y="92" text-anchor="middle" font-size="10" fill="var(--text-secondary)">Group 3</text>
                    <!-- Grand mean line -->
                    <line x1="60" y1="40" x2="340" y2="40" stroke="var(--text-muted,#94a3b8)" stroke-width="1" stroke-dasharray="4,3"/>
                    <text x="355" y="43" font-size="9" fill="var(--text-muted,#94a3b8)">x&#772;</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4CA;</div>
                    <h4>Compare Multiple Groups</h4>
                    <p>Test whether 3 or more group means differ significantly in a single test, avoiding multiple comparison problems.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F4C8;</div>
                    <h4>F-Statistic</h4>
                    <p>The ratio of between-group variance to within-group variance. A large F indicates the group means are spread apart more than expected by chance.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F504;</div>
                    <h4>Beyond T-Tests</h4>
                    <p>Running multiple t-tests inflates Type I error. ANOVA controls the overall error rate while testing all groups simultaneously.</p>
                </div>
            </div>
        </div>

        <!-- 2. ANOVA Table Explained -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">ANOVA Table Explained</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The ANOVA table summarizes the decomposition of total variance into between-group and within-group components.</p>

            <table class="stat-ops-table">
                <thead>
                    <tr><th>Source</th><th>SS</th><th>df</th><th>MS</th><th>F</th></tr>
                </thead>
                <tbody>
                    <tr><td style="font-weight:600;">Between</td><td>SSB</td><td>k &minus; 1</td><td>MSB</td><td>F = MSB / MSW</td></tr>
                    <tr><td style="font-weight:600;">Within</td><td>SSW</td><td>N &minus; k</td><td>MSW</td><td></td></tr>
                    <tr><td style="font-weight:600;">Total</td><td>SST</td><td>N &minus; 1</td><td></td><td></td></tr>
                </tbody>
            </table>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Key:</strong> k = number of groups, N = total number of observations. SST = SSB + SSW. The F-statistic follows an F-distribution with (k&minus;1, N&minus;k) degrees of freedom.
                </p>
            </div>
        </div>

        <!-- 3. Key Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Formulas</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Sum of Squares Between (SSB):</strong>&nbsp; SSB = &sum; n<sub>i</sub>(x&#772;<sub>i</sub> &minus; x&#772;)<sup>2</sup>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Sum of Squares Within (SSW):</strong>&nbsp; SSW = &sum;&sum; (x<sub>ij</sub> &minus; x&#772;<sub>i</sub>)<sup>2</sup>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Mean Squares:</strong>&nbsp; MSB = SSB / (k &minus; 1) &nbsp;&nbsp;&nbsp; MSW = SSW / (N &minus; k)
            </div>
            <div class="stat-formula-box">
                <strong>F-Statistic:</strong>&nbsp; F = MSB / MSW
            </div>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> Three groups: A = {4, 5, 6}, B = {8, 9, 7}, C = {5, 6, 4}. Grand mean x&#772; = 6.0.
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    x&#772;<sub>A</sub> = 5, x&#772;<sub>B</sub> = 8, x&#772;<sub>C</sub> = 5<br>
                    SSB = 3(5&minus;6)&sup2; + 3(8&minus;6)&sup2; + 3(5&minus;6)&sup2; = 3 + 12 + 3 = <strong>18</strong><br>
                    SSW = (1+0+1) + (0+1+1) + (1+0+1) = <strong>6</strong><br>
                    MSB = 18 / 2 = 9, &nbsp; MSW = 6 / 6 = 1<br>
                    F = 9 / 1 = <strong>9.0</strong>, &nbsp; df = (2, 6), &nbsp; p = 0.0156
                </div>
            </div>
        </div>

        <!-- 4. Effect Size: Eta-Squared -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Effect Size: Eta-Squared</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Eta-squared (&eta;&sup2;) measures how much of the total variance in the data is explained by group membership. It complements the p-value by indicating <em>practical</em> significance.</p>

            <div class="stat-formula-box" style="margin-bottom:1rem;">
                <strong>&eta;&sup2; = SSB / SST</strong> &nbsp;&mdash;&nbsp; proportion of variance explained by between-group differences
            </div>

            <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:0.75rem;margin-bottom:1.25rem;">
                <div style="text-align:center;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border-top:3px solid #10b981;">
                    <div style="font-weight:700;font-size:1rem;color:#10b981;">0.01</div>
                    <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:0.25rem;">Small effect</div>
                </div>
                <div style="text-align:center;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border-top:3px solid #f59e0b;">
                    <div style="font-weight:700;font-size:1rem;color:#f59e0b;">0.06</div>
                    <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:0.25rem;">Medium effect</div>
                </div>
                <div style="text-align:center;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border-top:3px solid #e11d48;">
                    <div style="font-weight:700;font-size:1rem;color:#e11d48;">0.14</div>
                    <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:0.25rem;">Large effect</div>
                </div>
            </div>

            <!-- SVG: Pie chart showing between vs within variance -->
            <div style="text-align:center;margin:1rem 0;">
                <svg viewBox="0 0 200 160" style="max-width:220px;width:100%;" aria-label="Pie chart showing between-group and within-group variance proportions">
                    <!-- Within-group (larger slice) -->
                    <circle cx="100" cy="75" r="55" fill="var(--bg-tertiary,#f1f5f9)" stroke="var(--border,#e2e8f0)" stroke-width="1"/>
                    <!-- Between-group slice (~30%) -->
                    <path d="M100,75 L100,20 A55,55 0 0,1 147.5,101.5 Z" fill="#e11d48" opacity="0.7" class="stat-anim stat-anim-d1"/>
                    <!-- Labels -->
                    <text x="125" y="55" font-size="9" fill="#e11d48" font-weight="600">SSB</text>
                    <text x="68" y="95" font-size="9" fill="var(--text-secondary)" font-weight="600">SSW</text>
                    <!-- Legend -->
                    <rect x="30" y="145" width="10" height="10" rx="2" fill="#e11d48" opacity="0.7"/>
                    <text x="44" y="154" font-size="9" fill="var(--text-secondary)">Between (&eta;&sup2;)</text>
                    <rect x="120" y="145" width="10" height="10" rx="2" fill="var(--bg-tertiary,#f1f5f9)" stroke="var(--border)" stroke-width="0.5"/>
                    <text x="134" y="154" font-size="9" fill="var(--text-secondary)">Within</text>
                </svg>
            </div>
        </div>

        <!-- 5. Assumptions & Alternatives -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions &amp; Alternatives</h2>

            <div class="stat-edu-grid">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F517;</div>
                    <h4>Independence</h4>
                    <p>Observations must be independent within and across groups. Random sampling or random assignment satisfies this.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F4C9;</div>
                    <h4>Normality</h4>
                    <p>Data within each group should be approximately normally distributed. ANOVA is robust to moderate violations, especially with larger samples.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                    <h4>Homogeneity of Variances</h4>
                    <p>Group variances should be roughly equal. Use Levene&rsquo;s test to check. If violated, consider Welch ANOVA.</p>
                </div>
            </div>

            <div style="margin-top:1.25rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;">
                <h4 style="font-size:0.875rem;font-weight:600;color:var(--text-primary);margin-bottom:0.5rem;">Alternatives &amp; Post-Hoc Tests</h4>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.75rem;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                    <div>
                        <strong style="color:var(--text-primary);">Non-parametric:</strong><br>
                        Kruskal-Wallis test (no normality assumption)
                    </div>
                    <div>
                        <strong style="color:var(--text-primary);">Unequal variances:</strong><br>
                        Welch ANOVA (robust to heteroscedasticity)
                    </div>
                    <div>
                        <strong style="color:var(--text-primary);">Pairwise comparisons:</strong><br>
                        Tukey HSD (controls family-wise error rate)
                    </div>
                    <div>
                        <strong style="color:var(--text-primary);">Conservative correction:</strong><br>
                        Bonferroni (&alpha; / number of comparisons)
                    </div>
                </div>
            </div>
        </div>

        <!-- 6. Frequently Asked Questions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is one-way ANOVA used for?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">One-way ANOVA tests whether the means of three or more independent groups are significantly different. It compares between-group variance to within-group variance using the F-statistic. If the result is significant, at least one group mean differs from the others.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are the assumptions of ANOVA?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">ANOVA assumes independence of observations, normal distribution within each group, and homogeneity of variances across groups. ANOVA is robust to moderate violations of normality, especially with larger sample sizes.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What do I do after a significant ANOVA result?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A significant ANOVA tells you at least one group differs, but not which ones. Use post-hoc tests like Tukey HSD to find specific pairwise differences while controlling the family-wise error rate.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret eta-squared?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Eta-squared measures the proportion of total variance explained by group membership. Guidelines: 0.01 is a small effect, 0.06 is medium, and 0.14 is large. It helps assess practical significance beyond the p-value.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between one-way and two-way ANOVA?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">One-way ANOVA has one independent variable (factor). Two-way ANOVA has two factors and can test for interaction effects between them. This calculator performs one-way ANOVA.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What if ANOVA assumptions are violated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">If normality is violated, consider the Kruskal-Wallis non-parametric test. If variances are unequal, use Welch ANOVA. For small samples, consider bootstrapping or exact permutation tests.</div>
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
    <script src="<%=request.getContextPath()%>/js/anova-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>