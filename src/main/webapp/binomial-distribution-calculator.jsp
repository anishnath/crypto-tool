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
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
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
        <jsp:param name="toolName" value="Binomial Distribution Calculator Online - PMF, CDF &amp; Visualization Free" />
        <jsp:param name="toolDescription" value="Calculate binomial probabilities P(X=k), cumulative P(X le k), and range probabilities. Interactive PMF bar chart, step-by-step formulas, and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="binomial-distribution-calculator.jsp" />
        <jsp:param name="toolKeywords" value="binomial distribution calculator, binomial probability calculator, PMF calculator, CDF calculator, binomial coefficient, bernoulli trials, success probability, number of trials, discrete probability, binomial theorem" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Exact probability P(X equals k),Cumulative probability P(X le k),Range probability P(a le X le b),Interactive Plotly PMF bar chart,Step-by-step KaTeX formulas,Mean variance and standard deviation,Python scipy code generation,Quick example presets" />
        <jsp:param name="teaches" value="Binomial distribution, Bernoulli trials, probability mass function, cumulative distribution, binomial coefficient, discrete probability" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Set Parameters|Enter number of trials n and success probability p,Choose Mode|Select Exact or Cumulative or Range probability,Enter k Values|Input the number of successes to evaluate,Click Calculate|Get instant probability with step-by-step formulas,View PMF Chart|Explore the interactive probability mass function,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is a binomial distribution?" />
        <jsp:param name="faq1a" value="A binomial distribution models the number of successes in n independent Bernoulli trials each with success probability p. It is a discrete probability distribution where outcomes are counted as whole numbers from 0 to n." />
        <jsp:param name="faq2q" value="How do I calculate binomial probability P(X equals k)?" />
        <jsp:param name="faq2a" value="Use the formula P(X equals k) equals C(n k) times p to the k times (1 minus p) to the (n minus k). C(n k) is the binomial coefficient n factorial divided by k factorial times (n minus k) factorial. This calculator computes it automatically." />
        <jsp:param name="faq3q" value="What is the difference between PMF and CDF?" />
        <jsp:param name="faq3a" value="PMF gives the probability of exactly k successes P(X equals k). CDF gives the cumulative probability of at most k successes P(X less than or equal to k) which is the sum of PMF values from 0 to k. Use CDF for at most or at least questions." />
        <jsp:param name="faq4q" value="When can I use the normal approximation to binomial?" />
        <jsp:param name="faq4a" value="When np is at least 5 and n(1 minus p) is at least 5 the binomial distribution can be approximated by a normal distribution with mean np and variance np(1 minus p). Apply continuity correction by adding or subtracting 0.5 for better accuracy." />
        <jsp:param name="faq5q" value="What are the mean and variance of a binomial distribution?" />
        <jsp:param name="faq5a" value="Mean equals n times p. Variance equals n times p times (1 minus p). Standard deviation equals the square root of variance. Skewness equals (1 minus 2p) divided by the square root of n times p times (1 minus p)." />
        <jsp:param name="faq6q" value="What are real-world examples of binomial distributions?" />
        <jsp:param name="faq6a" value="Common examples include coin flips, quality control defect counts, survey yes or no responses, clinical trial outcomes, free throw success rates in basketball, and genetics where offspring inherit traits with fixed probability." />
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
                <h1 class="tool-page-title">Binomial Distribution Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Binomial Distribution Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">P(X = k)</span>
                <span class="tool-badge">PMF &amp; CDF</span>
                <span class="tool-badge">Bar Chart</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>binomial distribution calculator</strong>: compute <strong>exact P(X = k)</strong>, <strong>cumulative P(X &le; k)</strong>, or <strong>range P(a &le; X &le; b)</strong> probabilities for any number of trials <em>n</em> and success probability <em>p</em>. Interactive Plotly PMF chart, step-by-step KaTeX formulas, and Python scipy export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                    </svg>
                    Binomial Distribution Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Distribution Parameters (always visible) -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bd-n">Number of Trials (n)</label>
                        <input type="number" class="stat-input-text bd-input" id="bd-n" value="10" min="1" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                        <div class="tool-form-hint">Number of independent Bernoulli trials</div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bd-p">Probability of Success (p)</label>
                        <input type="number" class="stat-input-text bd-input" id="bd-p" value="0.5" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                        <div class="tool-form-hint">Probability on each trial (0 to 1)</div>
                    </div>

                    <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0;">

                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Calculation Mode</label>
                        <div class="stat-mode-toggle">
                            <button type="button" class="stat-mode-btn active" id="bd-mode-exact">P(X=k)</button>
                            <button type="button" class="stat-mode-btn" id="bd-mode-cumulative">P(X&le;k)</button>
                            <button type="button" class="stat-mode-btn" id="bd-mode-range">Range</button>
                        </div>
                    </div>

                    <!-- Exact P(X = k) inputs -->
                    <div id="bd-input-exact">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="bd-k-exact">Number of Successes (k)</label>
                            <input type="number" class="stat-input-text bd-input" id="bd-k-exact" value="5" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">Exactly k successes out of n trials</div>
                        </div>
                    </div>

                    <!-- Cumulative P(X ≤ k) inputs -->
                    <div id="bd-input-cumulative" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="bd-k-cumulative">At Most Successes (k)</label>
                            <input type="number" class="stat-input-text bd-input" id="bd-k-cumulative" value="5" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">P(X &le; k) = sum of P(X = 0) to P(X = k)</div>
                        </div>
                    </div>

                    <!-- Range inputs -->
                    <div id="bd-input-range" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="bd-range-a">Minimum Successes (a)</label>
                            <input type="number" class="stat-input-text bd-input" id="bd-range-a" value="3" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="bd-range-b">Maximum Successes (b)</label>
                            <input type="number" class="stat-input-text bd-input" id="bd-range-b" value="7" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">P(a &le; X &le; b)</div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="bd-calc-btn">Calculate</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="bd-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-bd-example="coin">Coin Flip</button>
                            <button type="button" class="stat-example-chip" data-bd-example="defect">Quality Control</button>
                            <button type="button" class="stat-example-chip" data-bd-example="survey">Survey</button>
                            <button type="button" class="stat-example-chip" data-bd-example="medical">Clinical Trial</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="bd-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="bd-graph-panel">PMF Chart</button>
                <button type="button" class="stat-output-tab" data-tab="bd-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="bd-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="bd-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F3B2;</div>
                            <h3>Enter values and click Calculate</h3>
                            <p>Find binomial probabilities for your parameters.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="bd-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="bd-graph-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><rect x="3" y="12" width="4" height="9" rx="1"/><rect x="10" y="6" width="4" height="15" rx="1"/><rect x="17" y="2" width="4" height="19" rx="1"/></svg>
                        <h4>Probability Mass Function</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="bd-graph-content">
                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4CA;</div><h3>No chart yet</h3><p>Calculate to see the PMF bar chart.</p></div>
                    </div>
                </div>
            </div>

            <div class="stat-panel" id="bd-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="bd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="binomial-distribution-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What Is Binomial Distribution? -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is the Binomial Distribution?</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The <strong>binomial distribution</strong> models the number of successes in <em>n</em> independent Bernoulli trials, each with the same success probability <em>p</em>. It answers questions like &ldquo;If I flip a coin 10 times, what&rsquo;s the probability of getting exactly 6 heads?&rdquo;</p>

            <div class="stat-formula-box">
                <strong>PMF:</strong>&nbsp; P(X = k) = C(n, k) &times; p<sup>k</sup> &times; (1 &minus; p)<sup>n&minus;k</sup>
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3AF;</div>
                    <h4>Fixed Trials</h4>
                    <p>The number of trials <em>n</em> is fixed in advance. Each trial is independent of the others.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                    <h4>Two Outcomes</h4>
                    <p>Each trial has exactly two outcomes: success (probability <em>p</em>) or failure (probability 1 &minus; <em>p</em>).</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x1F4CF;</div>
                    <h4>Constant Probability</h4>
                    <p>The probability of success <em>p</em> remains the same for every trial.</p>
                </div>
            </div>
        </div>

        <!-- 2. Key Formulas -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Formulas &amp; Statistics</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Binomial Coefficient:</strong>&nbsp; C(n, k) = n! / (k! &times; (n &minus; k)!)
            </div>

            <table class="stat-ops-table">
                <thead><tr><th>Statistic</th><th>Formula</th><th>Example (n=10, p=0.5)</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Mean (&mu;)</td><td>n &times; p</td><td>5.0</td></tr>
                    <tr><td style="font-weight:600;">Variance (&sigma;&sup2;)</td><td>n &times; p &times; (1 &minus; p)</td><td>2.5</td></tr>
                    <tr><td style="font-weight:600;">Std Dev (&sigma;)</td><td>&radic;(n &times; p &times; (1 &minus; p))</td><td>1.5811</td></tr>
                    <tr><td style="font-weight:600;">Skewness</td><td>(1 &minus; 2p) / &sigma;</td><td>0.0 (symmetric)</td></tr>
                </tbody>
            </table>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Worked Example:</strong> Flip a fair coin 10 times. What is P(X = 6)?
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    C(10, 6) = 210<br>
                    P(X = 6) = 210 &times; 0.5<sup>6</sup> &times; 0.5<sup>4</sup> = 210 &times; 0.015625 &times; 0.0625 = <strong>0.2051</strong>
                </div>
            </div>
        </div>

        <!-- 3. Normal Approximation -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Normal Approximation to Binomial</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">When <em>n</em> is large enough, the binomial distribution can be approximated by a normal distribution. This is useful for quick calculations without summing many PMF values.</p>

            <div class="stat-formula-box">
                <strong>Approximation:</strong>&nbsp; X ~ N(np, np(1 &minus; p)) &nbsp; when np &ge; 5 and n(1 &minus; p) &ge; 5
            </div>

            <p style="color:var(--text-secondary);margin-top:0.75rem;font-size:0.875rem;line-height:1.7;">Apply a <strong>continuity correction</strong> of &plusmn;0.5 for better accuracy. For example, P(X &le; k) &asymp; &Phi;((k + 0.5 &minus; np) / &radic;(np(1 &minus; p))).</p>

            <!-- Animated SVG: PMF approaching normal curve -->
            <div style="text-align:center;margin-top:1rem;" class="stat-anim stat-anim-d1">
                <svg viewBox="0 0 400 140" style="max-width:400px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                    <!-- Bars representing binomial PMF -->
                    <rect x="40" y="120" width="15" height="5" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="60" y="108" width="15" height="17" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="80" y="88" width="15" height="37" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="100" y="62" width="15" height="63" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="120" y="38" width="15" height="87" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="140" y="20" width="15" height="105" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="160" y="12" width="15" height="113" fill="rgba(225,29,72,0.6)" rx="1"/>
                    <rect x="180" y="8" width="15" height="117" fill="rgba(225,29,72,0.6)" rx="1"/>
                    <rect x="200" y="12" width="15" height="113" fill="rgba(225,29,72,0.6)" rx="1"/>
                    <rect x="220" y="20" width="15" height="105" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="240" y="38" width="15" height="87" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="260" y="62" width="15" height="63" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="280" y="88" width="15" height="37" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="300" y="108" width="15" height="17" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <rect x="320" y="120" width="15" height="5" fill="rgba(225,29,72,0.4)" rx="1"/>
                    <!-- Normal curve overlay -->
                    <path d="M 40,122 C 70,118 100,95 130,55 C 150,30 165,15 190,8 C 215,15 230,30 250,55 C 280,95 310,118 340,122" fill="none" stroke="#e11d48" stroke-width="2" stroke-dasharray="4,3" class="stat-bell-animated"/>
                    <text x="190" y="138" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">n = 30, p = 0.5</text>
                </svg>
            </div>
        </div>

        <!-- 4. Real-World Applications -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Quality Control</h4>
                    <p>Number of defective items in a batch. If defect rate is 5%, what is the probability of finding 0&ndash;2 defects in 100 items?</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Medicine &amp; Clinical Trials</h4>
                    <p>Number of patients responding to treatment. If a drug has 70% efficacy, what is P(at least 15 of 20 respond)?</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Survey &amp; Polling</h4>
                    <p>Number of &ldquo;yes&rdquo; responses in a sample. If 30% of voters support a policy, how many in a sample of 50?</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>Sports &amp; Games</h4>
                    <p>Free throw success rates, coin tosses, dice outcomes. Classic probability scenarios modeled by binomial.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is a binomial distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">A binomial distribution models the number of successes in <em>n</em> independent Bernoulli trials, each with the same success probability <em>p</em>. It is a discrete probability distribution where outcomes are counted as whole numbers from 0 to n.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I calculate P(X = k)?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the formula P(X = k) = C(n, k) &times; p<sup>k</sup> &times; (1 &minus; p)<sup>n&minus;k</sup>, where C(n, k) is the binomial coefficient &ldquo;n choose k&rdquo;. This calculator computes it automatically with step-by-step formulas.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is the difference between PMF and CDF?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">PMF (probability mass function) gives the probability of <em>exactly</em> k successes: P(X = k). CDF (cumulative distribution function) gives the probability of <em>at most</em> k successes: P(X &le; k), which is the sum of PMF values from 0 to k.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">When can I use the normal approximation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">When np &ge; 5 and n(1 &minus; p) &ge; 5, the binomial can be approximated by N(np, np(1&minus;p)). Apply a continuity correction of &plusmn;0.5 for better accuracy.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are the mean and variance?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Mean = n &times; p. Variance = n &times; p &times; (1 &minus; p). Standard deviation = &radic;(variance). Skewness = (1 &minus; 2p) / &radic;(np(1&minus;p)). When p = 0.5, the distribution is symmetric.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are real-world examples of binomial distributions?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Common examples include coin flips, quality control defect counts, survey yes/no responses, clinical trial outcomes, free throw success rates in basketball, and genetics where offspring inherit traits with fixed probability.</div>
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
    <script src="<%=request.getContextPath()%>/js/binomial-distribution-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
