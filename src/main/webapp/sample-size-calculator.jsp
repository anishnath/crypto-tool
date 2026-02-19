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
        /* Confidence pills */
        .ss-conf-pills{display:flex;gap:0.375rem;flex-wrap:wrap;margin-top:0.25rem}
        .ss-conf-pill{padding:0.375rem 0.75rem;border:1.5px solid var(--border);border-radius:9999px;background:var(--bg-primary);cursor:pointer;font-weight:600;color:var(--text-secondary);font-size:0.75rem;transition:all 0.15s;font-family:var(--font-sans)}
        .ss-conf-pill:hover{border-color:var(--tool-primary)}
        .ss-conf-pill.active{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .ss-conf-pill{background:var(--bg-tertiary);border-color:var(--border)}
        [data-theme="dark"] .ss-conf-pill.active{background:var(--tool-light);color:var(--tool-primary);border-color:var(--tool-primary)}
        .ss-custom-input{width:60px;padding:0.25rem 0.375rem;border:1.5px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);margin-left:0.25rem}
        .ss-custom-input:focus{outline:none;border-color:var(--tool-primary)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Sample Size Calculator Online - Survey A/B Test Research Free" />
        <jsp:param name="toolDescription" value="Calculate required sample size for surveys proportions means A/B tests and comparing groups. Confidence level margin of error power analysis finite population correction with interactive chart and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="sample-size-calculator.jsp" />
        <jsp:param name="toolKeywords" value="sample size calculator, survey sample size, a/b test sample size, statistical power, margin of error, confidence level, research sample size, sample size determination, finite population correction, power analysis calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Survey proportion sample size with finite population correction,Mean estimation sample size,A/B test sample size with power analysis,Two-group mean comparison sample size,Confidence level 90% 95% 99% and custom,Step-by-step KaTeX formulas,Interactive Plotly chart showing size vs margin of error,Python code generation" />
        <jsp:param name="teaches" value="Sample size determination, margin of error, statistical power, confidence intervals, finite population correction, power analysis" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Calculation Type|Select survey or mean estimation or A/B test or comparing means,Set Confidence Level|Pick 90% or 95% or 99% or enter a custom level,Enter Parameters|Input proportion margin of error or effect size and power,Click Calculate|Get required sample size with step-by-step formula,View Chart|See how sample size changes with margin of error or power,Export Code|Run Python code in the embedded compiler" />
        <jsp:param name="faq1q" value="What sample size do I need for a survey?" />
        <jsp:param name="faq1a" value="For a typical survey with 95% confidence and 5% margin of error use p=0.5 for maximum conservatism. This gives about 385 respondents for a large population. Smaller margins need larger samples." />
        <jsp:param name="faq2q" value="Why use p equals 0.5 for proportions?" />
        <jsp:param name="faq2a" value="Using p=0.5 maximizes the product p times 1 minus p which gives the largest possible sample size. This is the most conservative estimate when you do not know the true proportion in advance." />
        <jsp:param name="faq3q" value="Does population size affect sample size?" />
        <jsp:param name="faq3a" value="For large populations sample size depends mainly on confidence and margin of error. Finite population correction matters when sampling more than about 5% of the population reducing the required size." />
        <jsp:param name="faq4q" value="What is statistical power and why does it matter?" />
        <jsp:param name="faq4a" value="Power equals 1 minus beta is the probability of detecting a real effect. 80% power means a 20% chance of missing a true effect. Higher power requires larger samples but gives more reliable results." />
        <jsp:param name="faq5q" value="How do I determine sample size for an A/B test?" />
        <jsp:param name="faq5a" value="You need the baseline conversion rate the minimum detectable effect and desired power. Smaller effects need much larger samples. A 1% improvement from 10% to 11% needs about 15000 per group at 80% power." />
        <jsp:param name="faq6q" value="What if I cannot afford the calculated sample size?" />
        <jsp:param name="faq6a" value="You can accept a wider margin of error lower confidence level or lower power. For A/B tests you can also focus on detecting larger effects only or use sequential testing methods." />
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
                <h1 class="tool-page-title">Sample Size Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Sample Size Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Survey &amp; A/B Test</span>
                <span class="tool-badge">Power Analysis</span>
                <span class="tool-badge">Finite Population</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>sample size calculator</strong> for <strong>surveys</strong>, <strong>A/B tests</strong>, and <strong>research studies</strong>. Compute required sample size with confidence level, margin of error, power analysis, finite population correction, step-by-step formulas, interactive Plotly chart, and Python export.</p>
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
                    Sample Size
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Calculation Type</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="ss-mode-survey" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Survey</button>
                            <button type="button" class="stat-mode-btn" id="ss-mode-mean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Mean</button>
                            <button type="button" class="stat-mode-btn" id="ss-mode-ab" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">A/B Test</button>
                            <button type="button" class="stat-mode-btn" id="ss-mode-compare" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Compare</button>
                        </div>
                    </div>

                    <!-- Confidence Level -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Confidence Level</label>
                        <div class="ss-conf-pills">
                            <button type="button" class="ss-conf-pill" data-conf="90">90%</button>
                            <button type="button" class="ss-conf-pill active" data-conf="95">95%</button>
                            <button type="button" class="ss-conf-pill" data-conf="99">99%</button>
                            <button type="button" class="ss-conf-pill" data-conf="custom">Custom
                                <input type="number" class="ss-custom-input" id="ss-custom-conf" value="95" min="50" max="99.99" step="0.1" style="display:none;">
                            </button>
                        </div>
                    </div>

                    <!-- Survey Proportion inputs (visible by default) -->
                    <div id="ss-input-survey">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-proportion">Expected Proportion (p)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-proportion" value="0.5" step="0.01" min="0" max="1">
                            <div class="tool-form-hint">Use 0.5 for maximum (most conservative)</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-margin-error">Margin of Error (E)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-margin-error" value="0.05" step="0.001" min="0">
                            <div class="tool-form-hint">e.g. &plusmn;5% = 0.05</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-pop-size">Population Size (optional)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-pop-size" step="1" min="1">
                            <div class="tool-form-hint">For finite population correction</div>
                        </div>
                    </div>

                    <!-- Mean Estimation inputs -->
                    <div id="ss-input-mean" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-std-dev">Standard Deviation (&sigma;)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-std-dev" value="15" step="0.01" min="0">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-margin-error-mean">Margin of Error (E)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-margin-error-mean" value="5" step="0.01" min="0">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-pop-size-mean">Population Size (optional)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-pop-size-mean" step="1" min="1">
                        </div>
                    </div>

                    <!-- A/B Test inputs -->
                    <div id="ss-input-ab" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-p1">Baseline Proportion (p&#8321;)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-p1" value="0.10" step="0.01" min="0" max="1">
                            <div class="tool-form-hint">Control group rate</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-p2">Expected Proportion (p&#8322;)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-p2" value="0.15" step="0.01" min="0" max="1">
                            <div class="tool-form-hint">Treatment group rate</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-power">Statistical Power (%)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-power" value="80" step="1" min="50" max="99">
                            <div class="tool-form-hint">Usually 80% or 90%</div>
                        </div>
                    </div>

                    <!-- Compare Means inputs -->
                    <div id="ss-input-compare" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-pooled-sd">Pooled Std Dev (&sigma;)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-pooled-sd" value="10" step="0.01" min="0">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-effect-size">Effect Size (|&mu;&#8321; &minus; &mu;&#8322;|)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-effect-size" value="5" step="0.01" min="0">
                            <div class="tool-form-hint">Minimum detectable difference</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ss-power-means">Statistical Power (%)</label>
                            <input type="number" class="stat-input-text ss-input" id="ss-power-means" value="80" step="1" min="50" max="99">
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="ss-calc-btn">Calculate Sample Size</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="ss-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group" id="ss-examples">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-example="election-poll">Election Poll</button>
                            <button type="button" class="stat-example-chip" data-example="customer-survey">Customer Survey</button>
                            <button type="button" class="stat-example-chip" data-example="ab-conversion">A/B Conversion</button>
                            <button type="button" class="stat-example-chip" data-example="clinical-trial">Clinical Trial</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="ss-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="ss-graph-panel">Chart</button>
                <button type="button" class="stat-output-tab" data-tab="ss-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="ss-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="ss-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                            <h3>Enter parameters and click Calculate</h3>
                            <p>Compute required sample size for surveys, A/B tests, and research studies.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="ss-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="ss-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                        <h4>Sample Size Visualization</h4>
                    </div>
                    <div style="flex:1;padding:1rem;min-height:300px;">
                        <div id="ss-graph-container"></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="ss-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="ss-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="sample-size-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Sample Size? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Sample Size?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Sample size</strong> is the number of observations or respondents needed in a study to draw reliable conclusions about a population. Choosing the right sample size balances statistical rigor with practical constraints like cost and time.</p>

            <!-- Animated SVG: Population to Sample -->
            <div style="text-align:center;margin:1.5rem 0;">
                <svg viewBox="0 0 400 80" style="max-width:400px;width:100%;" aria-label="Population to sample illustration">
                    <ellipse cx="100" cy="40" rx="70" ry="30" fill="none" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                    <text x="100" y="44" text-anchor="middle" font-size="11" fill="var(--text-secondary,#475569)">Population (N)</text>
                    <line x1="175" y1="40" x2="225" y2="40" stroke="#e11d48" stroke-width="2" marker-end="url(#ss-arrow)" class="stat-anim stat-anim-d1"/>
                    <defs><marker id="ss-arrow" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#e11d48"/></marker></defs>
                    <ellipse cx="300" cy="40" rx="55" ry="25" fill="var(--tool-light)" stroke="#e11d48" stroke-width="2" class="stat-anim stat-anim-d2"/>
                    <text x="300" y="44" text-anchor="middle" font-size="11" fill="#e11d48" font-weight="600" class="stat-anim stat-anim-d3">Sample (n)</text>
                </svg>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Precision</h4>
                    <p>Larger samples yield narrower confidence intervals and smaller margins of error, giving more precise estimates.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x26A1;</div>
                    <h4>Power</h4>
                    <p>Adequate sample size ensures enough statistical power to detect real effects and avoid false negatives.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                    <h4>Efficiency</h4>
                    <p>Too large wastes resources; too small produces unreliable results. Proper calculation finds the optimum.</p>
                </div>
            </div>
        </div>

        <!-- 2. Sample Size Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Sample Size Formulas</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Survey (proportion):</strong>&nbsp; n = z&sup2; &times; p(1&minus;p) / E&sup2;
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">z = critical value, p = expected proportion, E = margin of error</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Mean estimation:</strong>&nbsp; n = z&sup2; &times; &sigma;&sup2; / E&sup2;
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">&sigma; = population standard deviation, E = margin of error</div>
            </div>
            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>A/B test (two proportions):</strong>&nbsp; n = (z<sub>&alpha;/2</sub> + z<sub>&beta;</sub>)&sup2; &times; [p&#8321;(1&minus;p&#8321;) + p&#8322;(1&minus;p&#8322;)] / (p&#8321;&minus;p&#8322;)&sup2;
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">Per group. z<sub>&beta;</sub> from desired power (e.g. 0.84 for 80%)</div>
            </div>
            <div class="stat-formula-box">
                <strong>Compare means:</strong>&nbsp; n = 2(z<sub>&alpha;/2</sub> + z<sub>&beta;</sub>)&sup2; &times; &sigma;&sup2; / &delta;&sup2;
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">Per group. &delta; = minimum detectable difference</div>
            </div>
        </div>

        <!-- 3. Key Factors -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Factors Affecting Sample Size</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Factor</th><th>Effect on Sample Size</th><th>Explanation</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Confidence Level</td><td>Higher &rarr; larger n</td><td>99% confidence requires more data than 90% for the same precision</td></tr>
                    <tr><td style="font-weight:600;">Margin of Error</td><td>Smaller &rarr; larger n</td><td>Halving the margin of error quadruples the required sample size</td></tr>
                    <tr><td style="font-weight:600;">Variability</td><td>Higher &rarr; larger n</td><td>More variable populations need larger samples to estimate accurately</td></tr>
                    <tr><td style="font-weight:600;">Power</td><td>Higher &rarr; larger n</td><td>90% power needs about 30% more samples than 80% power</td></tr>
                    <tr><td style="font-weight:600;">Effect Size</td><td>Smaller &rarr; larger n</td><td>Detecting small differences requires substantially more observations</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Statistical Power -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Statistical Power</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Statistical power</strong> (1 &minus; &beta;) is the probability that a study will detect a true effect when one exists. Under-powered studies waste resources because they are unlikely to produce significant results even when the effect is real.</p>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> A/B test with p&#8321;=0.10, p&#8322;=0.12, 95% confidence. Compare 80% vs 90% power.
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    z<sub>0.025</sub> = 1.96<br>
                    80% power: z<sub>&beta;</sub> = 0.842 &rarr; n &asymp; <strong>3,623 per group</strong><br>
                    90% power: z<sub>&beta;</sub> = 1.282 &rarr; n &asymp; <strong>4,862 per group</strong><br>
                    Going from 80% to 90% power increases sample size by ~34%.
                </div>
            </div>

            <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                    <strong>Rule of thumb:</strong> Use 80% power as a minimum for most studies. Use 90% for confirmatory trials or when the cost of a false negative is high.
                </p>
            </div>
        </div>

        <!-- 5. Practical Tips -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Practical Tips</h2>

            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>&#x1F4CB; Surveys</h4>
                    <p>Use p=0.5 when unsure of the true proportion. Apply finite population correction when sampling &gt;5% of the population. Account for expected non-response by inflating the sample size (e.g. divide by expected response rate).</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>&#x1F50D; A/B Tests</h4>
                    <p>Define the minimum detectable effect before starting. Smaller effects need much larger samples. Consider using sequential testing to stop early if the effect is large. Always run the test for the full planned duration.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>&#x1F3E5; Clinical Research</h4>
                    <p>Regulatory agencies typically require 80&ndash;90% power. Account for dropout rates by over-enrolling. Pre-register your sample size calculation. Use interim analyses with appropriate alpha-spending functions.</p>
                </div>
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What sample size do I need for a survey?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">For a typical survey with 95% confidence and 5% margin of error, use p=0.5 for maximum conservatism. This gives about 385 respondents for a large population. Smaller margins need larger samples.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Why use p equals 0.5 for proportions?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Using p=0.5 maximizes the product p&times;(1&minus;p), which gives the largest possible sample size. This is the most conservative estimate when you do not know the true proportion in advance.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Does population size affect sample size?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">For large populations, sample size depends mainly on confidence and margin of error. Finite population correction matters when sampling more than about 5% of the population, reducing the required size.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is statistical power and why does it matter?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Power (1&minus;&beta;) is the probability of detecting a real effect. 80% power means a 20% chance of missing a true effect. Higher power requires larger samples but gives more reliable results.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I determine sample size for an A/B test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">You need the baseline conversion rate, the minimum detectable effect, and desired power. Smaller effects need much larger samples. A 1% improvement from 10% to 11% needs about 15,000 per group at 80% power.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What if I cannot afford the calculated sample size?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">You can accept a wider margin of error, lower confidence level, or lower power. For A/B tests, you can also focus on detecting larger effects only or use sequential testing methods.</div>
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
    <script src="<%=request.getContextPath()%>/js/sample-size-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>