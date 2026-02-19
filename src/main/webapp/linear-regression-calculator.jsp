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
        /* Prediction section */
        .lr-predict-section{margin-top:0.75rem;padding:0.75rem;background:var(--bg-secondary);border:1.5px dashed var(--tool-primary);border-radius:0.5rem;display:none}
        .lr-predict-section.visible{display:block}
        .lr-predict-row{display:flex;gap:0.5rem;align-items:center;margin-top:0.375rem}
        .lr-predict-result{margin-top:0.375rem;padding:0.5rem 0.75rem;background:var(--tool-light);border-radius:0.375rem;font-weight:600;font-size:0.875rem;color:var(--tool-primary)}
        [data-theme="dark"] .lr-predict-section{background:var(--bg-tertiary);border-color:var(--tool-primary)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Linear Regression Calculator Online - Slope R-Squared Prediction Free" />
        <jsp:param name="toolDescription" value="Calculate linear regression equation slope intercept R-squared correlation and make predictions. Interactive scatter plot with regression line residual analysis and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="linear-regression-calculator.jsp" />
        <jsp:param name="toolKeywords" value="linear regression calculator, regression line calculator, r squared calculator, slope intercept calculator, least squares calculator, prediction calculator, scatter plot regression, residual analysis, correlation regression, standard error estimate" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Regression equation y equals a plus bx,Slope and y-intercept calculation,R-squared coefficient of determination,Correlation coefficient,Standard error of estimate,Residual analysis,Interactive Plotly scatter plot with regression line,Prediction from X value,Step-by-step KaTeX formulas,Python scipy code generation" />
        <jsp:param name="teaches" value="Linear regression, least squares method, slope, intercept, R-squared, correlation, residuals, prediction, scatter plots" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Type X Y pairs one per line separated by comma or space,Click Calculate|Get instant regression equation with step-by-step formulas,Review Results|See slope intercept R-squared correlation and standard error,Make Predictions|Enter any X value to predict Y using the fitted model,View Scatter Plot|See the interactive chart with regression line overlay,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What does R-squared tell me about the regression?" />
        <jsp:param name="faq1a" value="R-squared is the proportion of variance in Y explained by the linear model. R-squared of 0.85 means 85 percent of the variation in Y is explained by X. Higher values indicate better fit but always check residuals." />
        <jsp:param name="faq2q" value="What are the assumptions of linear regression?" />
        <jsp:param name="faq2a" value="Linear regression assumes linearity between X and Y independence of observations constant variance of residuals called homoscedasticity and approximately normal residuals. Inspect residual plots to check these." />
        <jsp:param name="faq3q" value="How do I make predictions with the regression equation?" />
        <jsp:param name="faq3a" value="Plug any X value into the equation y equals intercept plus slope times x. Be cautious about extrapolating far beyond the range of your data as the linear relationship may not hold." />
        <jsp:param name="faq4q" value="What if the relationship is not linear?" />
        <jsp:param name="faq4a" value="If residuals show a pattern the relationship may be curved. Consider polynomial regression logarithmic transformation or other nonlinear models. Always visualize data before fitting a linear model." />
        <jsp:param name="faq5q" value="How do I interpret the slope?" />
        <jsp:param name="faq5a" value="The slope b tells you how much Y changes for each one unit increase in X. A slope of 2.5 means Y increases by 2.5 units on average when X increases by 1 unit." />
        <jsp:param name="faq6q" value="What is the standard error of the estimate?" />
        <jsp:param name="faq6a" value="The standard error of estimate measures the average distance between observed Y values and the regression line predictions. Smaller values indicate predictions are closer to actual data points." />
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
                <h1 class="tool-page-title">Linear Regression Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Linear Regression Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Slope &amp; Intercept</span>
                <span class="tool-badge">R&sup2; &amp; Correlation</span>
                <span class="tool-badge">Predictions</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>linear regression calculator</strong>: compute the <strong>regression equation</strong> (y = a + bx), <strong>R&sup2;</strong>, <strong>correlation</strong>, <strong>standard error</strong>, and make <strong>predictions</strong>. Interactive Plotly scatter plot with regression line, step-by-step KaTeX formulas, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <line x1="3" y1="21" x2="21" y2="3"/><circle cx="7" cy="17" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="17" cy="7" r="2"/>
                    </svg>
                    Linear Regression
                </div>
                <div class="tool-card-body">
                    <!-- Data input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="lr-data-input">X, Y Data Pairs (one per line)</label>
                        <textarea class="stat-input-text lr-input" id="lr-data-input" rows="8" placeholder="Format: x, y&#10;Example:&#10;1, 2&#10;2, 4&#10;3, 5&#10;4, 4&#10;5, 5"></textarea>
                        <div class="tool-form-hint">Separate X and Y with comma or space. Minimum 2 data points.</div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="lr-calc-btn">Calculate Regression</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="lr-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <!-- Prediction section (hidden until first calculation) -->
                    <div class="lr-predict-section" id="lr-predict-section">
                        <label class="tool-form-label">Make a Prediction</label>
                        <div class="lr-predict-row">
                            <span style="font-size:0.8125rem;font-weight:500;white-space:nowrap;">X =</span>
                            <input type="number" class="stat-input-text lr-input" id="lr-predict-x" step="any" placeholder="Enter X">
                            <button type="button" class="tool-action-btn" id="lr-predict-btn" style="width:auto;margin:0;padding:0.5rem 0.75rem;font-size:0.75rem;">Predict</button>
                        </div>
                        <div id="lr-predict-result"></div>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-lr-example="study-hours">Study Hours</button>
                            <button type="button" class="stat-example-chip" data-lr-example="sales">Ad Sales</button>
                            <button type="button" class="stat-example-chip" data-lr-example="temperature">Temperature</button>
                            <button type="button" class="stat-example-chip" data-lr-example="height-weight">Height/Weight</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="lr-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="lr-graph-panel">Scatter Plot</button>
                <button type="button" class="stat-output-tab" data-tab="lr-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="lr-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="lr-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4C9;</div>
                            <h3>Enter data and click Calculate</h3>
                            <p>Compute the regression equation, R&sup2;, correlation, and make predictions.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="lr-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="lr-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="3" y1="21" x2="21" y2="3"/><circle cx="7" cy="17" r="1.5"/><circle cx="12" cy="12" r="1.5"/><circle cx="17" cy="7" r="1.5"/></svg>
                        <h4>Scatter Plot &amp; Regression Line</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:400px;">
                        <div id="lr-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="lr-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="lr-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="linear-regression-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Linear Regression? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Linear Regression?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Linear regression</strong> models the relationship between a dependent variable (Y) and independent variable (X) by fitting the best straight line through the data using the <strong>least squares method</strong>.</p>

            <div class="stat-formula-box">
                <strong>Regression Equation:</strong>&nbsp; y = a + bx
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F4C8;</div>
                    <h4>Slope (b)</h4>
                    <p>How much Y changes for each 1-unit increase in X. Positive = upward trend, negative = downward.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Intercept (a)</h4>
                    <p>The predicted value of Y when X = 0. The starting point of the regression line.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4CA;</div>
                    <h4>R&sup2; (Fit Quality)</h4>
                    <p>Proportion of variance in Y explained by X. Ranges from 0 (no fit) to 1 (perfect fit).</p>
                </div>
            </div>
        </div>

        <!-- 2. Key Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Formulas</h2>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Slope:</strong>&nbsp; b = &Sigma;[(x<sub>i</sub> &minus; x&#772;)(y<sub>i</sub> &minus; y&#772;)] / &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2;
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Intercept:</strong>&nbsp; a = y&#772; &minus; b &times; x&#772;
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>R&sup2;:</strong>&nbsp; R&sup2; = 1 &minus; SS<sub>res</sub> / SS<sub>tot</sub>
            </div>
            <div class="stat-formula-box">
                <strong>Standard Error:</strong>&nbsp; SEE = &radic;[&Sigma;(y<sub>i</sub> &minus; y&#770;<sub>i</sub>)&sup2; / (n &minus; 2)]
            </div>
        </div>

        <!-- 3. R-squared Interpretation -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding R&sup2;</h2>
            <table class="stat-ops-table">
                <thead><tr><th>R&sup2; Range</th><th>Interpretation</th><th>Fit Quality</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">0.90 &ndash; 1.00</td><td>90&ndash;100% of variance explained</td><td style="color:#10b981;font-weight:600;">Excellent</td></tr>
                    <tr><td style="font-weight:600;">0.70 &ndash; 0.89</td><td>70&ndash;89% of variance explained</td><td style="color:#3b82f6;font-weight:600;">Good</td></tr>
                    <tr><td style="font-weight:600;">0.50 &ndash; 0.69</td><td>50&ndash;69% of variance explained</td><td style="color:#f59e0b;font-weight:600;">Moderate</td></tr>
                    <tr><td style="font-weight:600;">0.00 &ndash; 0.49</td><td>Less than 50% explained</td><td style="color:#ef4444;font-weight:600;">Weak</td></tr>
                </tbody>
            </table>
            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Tip:</strong> A high R&sup2; does not guarantee a good model. Always visualize residuals to check for patterns that indicate model violations (non-linearity, heteroscedasticity).
                </p>
            </div>
        </div>

        <!-- 4. Assumptions -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions of Linear Regression</h2>
            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Linearity</h4>
                    <p>The relationship between X and Y is approximately linear. Check with a scatter plot.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Independence</h4>
                    <p>Observations are independent of each other. No autocorrelation in residuals.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Homoscedasticity</h4>
                    <p>Residuals have constant variance across all X values. Fan-shaped patterns indicate violation.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>Normality</h4>
                    <p>Residuals are approximately normally distributed. Less critical for large samples.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What does R-squared tell me about the regression?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">R&sup2; is the proportion of variance in Y explained by the linear model. An R&sup2; of 0.85 means 85% of the variation in Y is captured by the regression line. Higher is better, but always check residual plots.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are the assumptions of linear regression?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Linear regression assumes: linearity (X and Y have a linear relationship), independence of observations, homoscedasticity (constant residual variance), and approximately normal residuals. Inspect residual plots to verify.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I make predictions with the regression equation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Plug any X value into y = a + bx. Be cautious about extrapolating far beyond your data range, as the linear relationship may not hold outside the observed domain.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What if the relationship is not linear?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">If residuals show a curve or pattern, consider polynomial regression, logarithmic transformation, or other nonlinear models. Always visualize your data with a scatter plot first.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I interpret the slope?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The slope (b) tells you how much Y changes for each 1-unit increase in X. A slope of 2.5 means Y increases by 2.5 units on average when X increases by 1 unit.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the standard error of the estimate?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">SEE measures the average distance between observed Y values and predicted values from the regression line. Smaller SEE means the model makes more precise predictions.</div>
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
    <script src="<%=request.getContextPath()%>/js/linear-regression-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
