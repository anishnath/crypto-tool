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
        .nav-logo{display:flex;align-items:center;gap:var(--space-3,0.75rem);text-decoration:none;font-weight:700;font-size:var(--text-lg,1.125rem)}.nav-logo img{width:32px;height:32px;border-radius:var(--radius-md,0.5rem)}.nav-logo span{background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-weight:700;letter-spacing:-0.02em}[data-theme="dark"] .nav-logo span{background:linear-gradient(135deg,#818cf8 0%,#a78bfa 50%,#f472b6 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .nav-items{display:flex;align-items:center;gap:var(--space-6,1.5rem);list-style:none;margin:0;padding:0}.nav-link{color:var(--text-secondary,#475569);text-decoration:none;font-weight:500;font-size:var(--text-base,1rem);padding:var(--space-2,0.5rem) var(--space-3,0.75rem);border-radius:var(--radius-md,0.5rem);display:flex;align-items:center;gap:var(--space-2,0.5rem)}
        .nav-actions{display:flex;align-items:center;gap:var(--space-3,0.75rem)}.btn-nav{padding:var(--space-2,0.5rem) var(--space-4,1rem);border-radius:var(--radius-md,0.5rem);font-size:var(--text-sm,0.875rem);font-weight:500;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:var(--space-2,0.5rem);font-family:var(--font-sans)}.btn-nav-primary{background:var(--primary,#6366f1);color:#fff}.btn-nav-secondary{background:var(--bg-secondary,#f8fafc);color:var(--text-secondary,#475569);border:1px solid var(--border,#e2e8f0)}
        .mobile-menu-toggle,.mobile-search-toggle{display:none;background:none;border:none;padding:var(--space-2,0.5rem);cursor:pointer;color:var(--text-primary)}.mobile-menu-toggle{font-size:var(--text-xl,1.25rem);width:40px;height:40px;align-items:center;justify-content:center;border-radius:var(--radius-md,0.5rem)}
        .nav-search{position:relative;flex:1;max-width:500px;margin:0 var(--space-6,1.5rem)}.search-input{width:100%;padding:var(--space-2,0.5rem) var(--space-10,2.5rem) var(--space-2,0.5rem) var(--space-4,1rem);border:2px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);font-size:var(--text-sm,0.875rem);background:var(--bg-secondary,#f8fafc);font-family:var(--font-sans)}.search-icon{position:absolute;right:var(--space-4,1rem);top:50%;transform:translateY(-50%);color:var(--text-muted,#94a3b8);pointer-events:none}
        @media(max-width:991px){.modern-nav{height:var(--header-height-mobile,64px)}.nav-container{padding:0 var(--space-3,0.75rem)}.nav-search,.nav-items{display:none}.nav-actions{gap:var(--space-2,0.5rem)}.btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}.mobile-menu-toggle,.mobile-search-toggle{display:flex}.btn-nav .nav-text{display:none}}
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}.tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}.tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}.tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}.tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}.tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}.tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}.tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}.tool-description-content{flex:1}.tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}@media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}@media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}@media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}.tool-output-column{display:flex;flex-direction:column;gap:1rem}.tool-ads-column{height:fit-content}
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}.tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}.tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}.tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}.tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:0.5rem;transition:opacity .15s,transform .15s}.tool-action-btn:hover{opacity:0.9}
        .tool-result-card{display:flex;flex-direction:column;height:100%}.tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}.tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}.tool-result-content{flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}.tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}.tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}.tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}[data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}[data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}[data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(225,29,72,0.3)}[data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}[data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}[data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}[data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}.faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}.faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}.faq-item.open .faq-answer{display:block}.faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
        /* Two-column textarea layout */
        .corr-data-grid{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem}
        @media(max-width:480px){.corr-data-grid{grid-template-columns:1fr}}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Correlation Calculator Online - Pearson Spearman R-Squared Free" />
        <jsp:param name="toolDescription" value="Calculate Pearson and Spearman correlation coefficients with R-squared p-value significance test interactive scatter plot and Python export. Free online correlation analysis tool." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="correlation-calculator.jsp" />
        <jsp:param name="toolKeywords" value="correlation calculator, pearson correlation, spearman correlation, r squared calculator, correlation coefficient, scatter plot, p-value correlation, statistical correlation, rank correlation, data analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Pearson linear correlation coefficient,Spearman rank correlation coefficient,Compare Pearson and Spearman side by side,R-squared coefficient of determination,Statistical significance p-value,Interactive Plotly scatter plot with trend line,Step-by-step KaTeX formulas,Python scipy code generation" />
        <jsp:param name="teaches" value="Correlation analysis, Pearson correlation, Spearman rank correlation, coefficient of determination, statistical significance, scatter plots, data relationships" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Method|Select Pearson or Spearman or compare both,Enter X Data|Type or paste values for variable X one per line,Enter Y Data|Type or paste matching Y values one per line,Click Calculate|Get instant correlation coefficient with steps,View Scatter Plot|See the interactive Plotly chart with trend line,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is the difference between Pearson and Spearman correlation?" />
        <jsp:param name="faq1a" value="Pearson measures linear relationships between continuous variables. Spearman measures monotonic relationships using ranks and is more robust to outliers and non-normal distributions." />
        <jsp:param name="faq2q" value="How do I interpret the correlation coefficient r?" />
        <jsp:param name="faq2a" value="r ranges from -1 to +1. The sign shows direction and the magnitude shows strength. Values above 0.8 are very strong while values below 0.2 are very weak. Always visualize with a scatter plot." />
        <jsp:param name="faq3q" value="Does correlation imply causation?" />
        <jsp:param name="faq3a" value="No. A strong correlation does not prove that one variable causes the other. There could be confounding variables reverse causation or coincidence. Causation requires controlled experiments." />
        <jsp:param name="faq4q" value="What does R-squared tell me?" />
        <jsp:param name="faq4a" value="R-squared is the proportion of variance in Y explained by X. If r equals 0.8 then R-squared equals 0.64 meaning 64 percent of the variation in Y can be attributed to its linear relationship with X." />
        <jsp:param name="faq5q" value="When is a correlation statistically significant?" />
        <jsp:param name="faq5a" value="Significance depends on both the correlation magnitude and sample size. A p-value below 0.05 is the standard threshold. Large samples can make even small correlations statistically significant." />
        <jsp:param name="faq6q" value="What if my data has outliers?" />
        <jsp:param name="faq6a" value="Outliers can dramatically affect Pearson correlation. Use Spearman rank correlation which is robust to outliers or consider removing extreme values after careful investigation." />
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
                <h1 class="tool-page-title">Correlation Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Correlation Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Pearson &amp; Spearman</span>
                <span class="tool-badge">Scatter Plot</span>
                <span class="tool-badge">p-Value</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>correlation calculator</strong> for <strong>Pearson</strong> and <strong>Spearman</strong> coefficients. Get R&sup2;, p-value significance test, interactive scatter plot with trend line, step-by-step KaTeX formulas, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <circle cx="7.5" cy="7.5" r="2"/><circle cx="16.5" cy="16.5" r="2"/><circle cx="5" cy="17" r="1.5"/><circle cx="18" cy="6" r="1.5"/><circle cx="12" cy="12" r="1.5"/>
                    </svg>
                    Correlation Analysis
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Method</label>
                        <div class="stat-mode-toggle">
                            <button type="button" class="stat-mode-btn active" id="corr-mode-pearson">Pearson</button>
                            <button type="button" class="stat-mode-btn" id="corr-mode-spearman">Spearman</button>
                            <button type="button" class="stat-mode-btn" id="corr-mode-both">Both</button>
                        </div>
                    </div>

                    <!-- Data inputs -->
                    <div class="corr-data-grid">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="corr-x-data">Variable X</label>
                            <textarea class="stat-input-text corr-input" id="corr-x-data" rows="6" placeholder="One value per line&#10;e.g.&#10;10&#10;20&#10;30"></textarea>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="corr-y-data">Variable Y</label>
                            <textarea class="stat-input-text corr-input" id="corr-y-data" rows="6" placeholder="One value per line&#10;e.g.&#10;15&#10;28&#10;35"></textarea>
                        </div>
                    </div>
                    <div class="tool-form-hint">Enter paired data &mdash; X and Y must have the same number of values (min 3)</div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="corr-calc-btn">Calculate Correlation</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="corr-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-corr-example="positive-strong">Strong +</button>
                            <button type="button" class="stat-example-chip" data-corr-example="negative-strong">Strong &minus;</button>
                            <button type="button" class="stat-example-chip" data-corr-example="weak">Weak</button>
                            <button type="button" class="stat-example-chip" data-corr-example="nonlinear">Non-Linear</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="corr-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="corr-graph-panel">Scatter Plot</button>
                <button type="button" class="stat-output-tab" data-tab="corr-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="corr-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="corr-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4C8;</div>
                            <h3>Enter paired data and click Calculate</h3>
                            <p>Compute Pearson or Spearman correlation with significance testing.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="corr-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="corr-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><circle cx="7.5" cy="7.5" r="2"/><circle cx="16.5" cy="16.5" r="2"/><line x1="3" y1="21" x2="21" y2="3" stroke-dasharray="4"/></svg>
                        <h4>Scatter Plot</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:350px;">
                        <div id="corr-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="corr-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="corr-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="correlation-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Correlation? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Correlation?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Correlation</strong> measures the strength and direction of the relationship between two variables. The correlation coefficient (r) ranges from &minus;1 to +1.</p>
            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x2197;&#xFE0F;</div>
                    <h4>Positive (r &gt; 0)</h4>
                    <p>As X increases, Y tends to increase. Example: study hours and exam scores.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2198;&#xFE0F;</div>
                    <h4>Negative (r &lt; 0)</h4>
                    <p>As X increases, Y tends to decrease. Example: price and demand.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2B55;</div>
                    <h4>Zero (r &asymp; 0)</h4>
                    <p>No linear relationship between X and Y. Points are scattered randomly.</p>
                </div>
            </div>
        </div>

        <!-- 2. Pearson vs Spearman -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Pearson vs. Spearman Correlation</h2>
            <table class="stat-ops-table">
                <thead><tr><th>Property</th><th>Pearson (r)</th><th>Spearman (&rho;)</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Measures</td><td>Linear relationship</td><td>Monotonic relationship</td></tr>
                    <tr><td style="font-weight:600;">Data type</td><td>Continuous, interval/ratio</td><td>Ordinal or continuous</td></tr>
                    <tr><td style="font-weight:600;">Assumptions</td><td>Normal distribution, no outliers</td><td>No distribution assumption</td></tr>
                    <tr><td style="font-weight:600;">Outlier sensitivity</td><td>High &mdash; easily distorted</td><td>Low &mdash; uses ranks</td></tr>
                    <tr><td style="font-weight:600;">Best for</td><td>Linear, well-behaved data</td><td>Ranked data, curves, outliers</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 3. Strength Table -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Correlation Strength Guide</h2>
            <table class="stat-ops-table">
                <thead><tr><th>|r| Value</th><th>Strength</th><th>Meaning</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">0.8 &ndash; 1.0</td><td>Very Strong</td><td>Highly predictive relationship</td></tr>
                    <tr><td style="font-weight:600;">0.6 &ndash; 0.79</td><td>Strong</td><td>Notable, meaningful relationship</td></tr>
                    <tr><td style="font-weight:600;">0.4 &ndash; 0.59</td><td>Moderate</td><td>Clear but not dominant</td></tr>
                    <tr><td style="font-weight:600;">0.2 &ndash; 0.39</td><td>Weak</td><td>Minor relationship</td></tr>
                    <tr><td style="font-weight:600;">0.0 &ndash; 0.19</td><td>Very Weak</td><td>Little to no relationship</td></tr>
                </tbody>
            </table>
            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--error);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Correlation &ne; Causation:</strong> A strong correlation does not prove that one variable causes the other. There may be confounding variables, reverse causation, or coincidence. Always consider context.
                </p>
            </div>
        </div>

        <!-- 4. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is the difference between Pearson and Spearman correlation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Pearson measures linear relationships between continuous variables. Spearman measures monotonic relationships using ranks and is more robust to outliers and non-normal distributions.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret the correlation coefficient r?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">r ranges from &minus;1 to +1. The sign shows direction (positive or negative) and the magnitude shows strength. Always visualize with a scatter plot to check for non-linearity or outliers.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Does correlation imply causation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">No. Correlation shows that two variables move together, but does not prove one causes the other. Confounding variables, reverse causation, or coincidence can all create spurious correlations.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What does R-squared tell me?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">R&sup2; is the proportion of variance in Y explained by X. If r = 0.8, then R&sup2; = 0.64, meaning 64% of the variation in Y can be attributed to its linear relationship with X.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When is a correlation statistically significant?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Significance depends on both correlation magnitude and sample size. A p-value below 0.05 is the standard threshold, but large samples can make even small correlations significant &mdash; consider effect size.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What if my data has outliers?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Outliers can dramatically affect Pearson correlation. Use Spearman rank correlation which is robust to outliers, or consider removing extreme values after careful investigation of whether they are genuine data points.</div>
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
    <script src="<%=request.getContextPath()%>/js/correlation-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
