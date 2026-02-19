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
        .prob-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.875rem;background:var(--bg-primary);color:var(--text-primary);font-family:var(--font-sans)}
        .prob-select:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(225,29,72,0.1)}
        [data-theme="dark"] .prob-select{background:var(--bg-tertiary);border-color:var(--border)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Probability Calculator Online - Bayes Theorem &amp; Conditional Free" />
        <jsp:param name="toolDescription" value="Calculate basic probability, conditional probability P(A|B), Bayes theorem posterior, and AND/OR/NOT for multiple events. Step-by-step KaTeX formulas and Python export." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="probability-calculator.jsp" />
        <jsp:param name="toolKeywords" value="probability calculator, bayes theorem calculator, conditional probability calculator, AND OR probability, complement probability, independent events, mutually exclusive, joint probability, posterior probability, odds calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Basic probability favorable over total,Conditional probability P(A given B),Bayes theorem posterior probability,Multiple events AND OR NOT,Independent and mutually exclusive,Step-by-step KaTeX formulas,Python code generation,Odds for and against" />
        <jsp:param name="teaches" value="Probability theory, conditional probability, Bayes theorem, independent events, mutually exclusive events, complement rule, addition rule, multiplication rule" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select Basic or Conditional or Bayes or Multiple Events,Enter Values|Input probabilities or outcome counts,Click Calculate|Get instant results with step-by-step formulas,Review Steps|See KaTeX formula derivation,Read Interpretation|Understand what the result means,Export Code|Run Python code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is the difference between independent and mutually exclusive events?" />
        <jsp:param name="faq1a" value="Independent events do not affect each other so P(A and B) equals P(A) times P(B). Mutually exclusive events cannot both occur so P(A and B) equals 0. Two events can be independent but not mutually exclusive and vice versa." />
        <jsp:param name="faq2q" value="How does Bayes theorem work?" />
        <jsp:param name="faq2a" value="Bayes theorem updates a prior probability P(A) based on new evidence B. The posterior P(A given B) equals P(B given A) times P(A) divided by P(B). It is widely used in medical testing spam filtering and machine learning." />
        <jsp:param name="faq3q" value="What is conditional probability?" />
        <jsp:param name="faq3a" value="Conditional probability P(A given B) is the probability of A occurring given that B has already occurred. The formula is P(A and B) divided by P(B). It narrows the sample space to only outcomes where B is true." />
        <jsp:param name="faq4q" value="How do I calculate P(A OR B)?" />
        <jsp:param name="faq4a" value="Use the addition rule P(A or B) equals P(A) plus P(B) minus P(A and B). For mutually exclusive events P(A and B) is zero so it simplifies to P(A) plus P(B). Always subtract the overlap to avoid double counting." />
        <jsp:param name="faq5q" value="What are odds versus probability?" />
        <jsp:param name="faq5a" value="Probability is favorable outcomes divided by total outcomes ranging from 0 to 1. Odds for are favorable to unfavorable such as 3 to 2. Convert odds to probability by dividing favorable by the sum of favorable plus unfavorable." />
        <jsp:param name="faq6q" value="Why does Bayes theorem give surprising results for medical tests?" />
        <jsp:param name="faq6a" value="When a disease is rare the prior P(A) is very low. Even with a highly accurate test the false positives from the large healthy population can outnumber the true positives. This is the base rate fallacy and Bayes theorem correctly accounts for it." />
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
                <h1 class="tool-page-title">Probability Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Probability Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Bayes&rsquo; Theorem</span>
                <span class="tool-badge">Conditional</span>
                <span class="tool-badge">AND / OR / NOT</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>probability calculator</strong> with four modes: <strong>basic probability</strong> (favorable/total), <strong>conditional P(A|B)</strong>, <strong>Bayes&rsquo; theorem</strong> posterior, and <strong>multiple events</strong> (AND, OR, NOT). Step-by-step KaTeX formulas, interpretation, and Python code export.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>
                    </svg>
                    Probability Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Calculation Mode</label>
                        <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                            <button type="button" class="stat-mode-btn active" id="prob-mode-basic" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Basic</button>
                            <button type="button" class="stat-mode-btn" id="prob-mode-conditional" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Conditional</button>
                            <button type="button" class="stat-mode-btn" id="prob-mode-bayes" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Bayes</button>
                            <button type="button" class="stat-mode-btn" id="prob-mode-multiple" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Multiple</button>
                        </div>
                    </div>

                    <!-- Basic inputs -->
                    <div id="prob-input-basic">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-favorable">Favorable Outcomes</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-favorable" value="3" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-total">Total Outcomes</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-total" value="6" min="1" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">P(A) = favorable / total</div>
                        </div>
                    </div>

                    <!-- Conditional inputs -->
                    <div id="prob-input-conditional" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-a-and-b">P(A &cap; B) &mdash; Joint Probability</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-a-and-b" value="0.15" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-b">P(B) &mdash; Probability of B</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-b" value="0.30" min="0.001" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">P(A|B) = P(A &cap; B) / P(B)</div>
                        </div>
                    </div>

                    <!-- Bayes inputs -->
                    <div id="prob-input-bayes" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-prior-a">P(A) &mdash; Prior Probability</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-prior-a" value="0.01" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">e.g. disease prevalence</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-b-given-a">P(B|A) &mdash; Sensitivity / Likelihood</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-b-given-a" value="0.95" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">Probability of evidence given A is true</div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-b-given-not-a">P(B|&not;A) &mdash; False Positive Rate</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-b-given-not-a" value="0.05" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                            <div class="tool-form-hint">Probability of evidence given A is false</div>
                        </div>
                    </div>

                    <!-- Multiple Events inputs -->
                    <div id="prob-input-multiple" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-pa">P(A)</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-pa" value="0.60" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-pb">P(B)</label>
                            <input type="number" class="stat-input-text prob-input" id="prob-pb" value="0.40" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="prob-relation">Events Relationship</label>
                            <select class="prob-select prob-input" id="prob-relation">
                                <option value="independent">Independent (unrelated)</option>
                                <option value="mutually-exclusive">Mutually Exclusive</option>
                            </select>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="prob-calc-btn">Calculate Probability</button>
                    <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                        <button type="button" class="tool-action-btn" id="prob-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                    </div>

                    <hr class="stat-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="stat-examples">
                            <button type="button" class="stat-example-chip" data-prob-example="dice">Dice Roll</button>
                            <button type="button" class="stat-example-chip" data-prob-example="medical">Medical Test</button>
                            <button type="button" class="stat-example-chip" data-prob-example="cards">Card Draw</button>
                            <button type="button" class="stat-example-chip" data-prob-example="weather">Weather</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="stat-output-tabs">
                <button type="button" class="stat-output-tab active" data-tab="prob-result-panel">Result</button>
                <button type="button" class="stat-output-tab" data-tab="prob-compiler-panel">Python Compiler</button>
            </div>

            <div class="stat-panel active" id="prob-result-panel">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="prob-result-content">
                        <div class="tool-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F3B2;</div>
                            <h3>Enter values and click Calculate</h3>
                            <p>Compute probability using basic rules, conditional probability, or Bayes&rsquo; theorem.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="prob-result-actions"></div>
                </div>
            </div>

            <div class="stat-panel" id="prob-compiler-panel">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="prob-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="probability-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. Probability Fundamentals -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Probability Fundamentals</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Probability</strong> measures the likelihood of an event occurring, expressed as a number between 0 (impossible) and 1 (certain). It is the foundation of statistics, machine learning, and decision-making.</p>

            <div class="stat-formula-box">
                <strong>Basic Probability:</strong>&nbsp; P(A) = Favorable Outcomes / Total Outcomes
            </div>

            <div class="stat-edu-grid" style="margin-top:1rem;">
                <div class="stat-feature-card stat-anim stat-anim-d1">
                    <div style="font-size:1.5rem;">&#x1F3B2;</div>
                    <h4>Complement Rule</h4>
                    <p>P(&not;A) = 1 &minus; P(A). The probability an event does <em>not</em> happen.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d2">
                    <div style="font-size:1.5rem;">&#x2795;</div>
                    <h4>Addition Rule (OR)</h4>
                    <p>P(A &cup; B) = P(A) + P(B) &minus; P(A &cap; B). Subtract the overlap.</p>
                </div>
                <div class="stat-feature-card stat-anim stat-anim-d3">
                    <div style="font-size:1.5rem;">&#x2716;&#xFE0F;</div>
                    <h4>Multiplication Rule (AND)</h4>
                    <p>P(A &cap; B) = P(A) &times; P(B|A). For independent events: P(A) &times; P(B).</p>
                </div>
            </div>
        </div>

        <!-- 2. Conditional Probability & Bayes -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Conditional Probability &amp; Bayes&rsquo; Theorem</h2>

            <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                <strong>Conditional:</strong>&nbsp; P(A|B) = P(A &cap; B) / P(B)
            </div>
            <div class="stat-formula-box">
                <strong>Bayes&rsquo; Theorem:</strong>&nbsp; P(A|B) = P(B|A) &times; P(A) / [P(B|A) &times; P(A) + P(B|&not;A) &times; P(&not;A)]
            </div>

            <div class="stat-worked-example" style="margin-top:1rem;">
                <strong>Medical Test Example:</strong> A disease affects 1% of the population. A test has 95% sensitivity and 5% false positive rate. If you test positive, what is the probability you have the disease?
                <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                    P(Disease) = 0.01, P(+|Disease) = 0.95, P(+|Healthy) = 0.05<br>
                    P(+) = 0.95 &times; 0.01 + 0.05 &times; 0.99 = 0.059<br>
                    P(Disease|+) = (0.95 &times; 0.01) / 0.059 = <strong>0.161 (16.1%)</strong><br>
                    Despite a &ldquo;95% accurate&rdquo; test, there is only a 16% chance of having the disease!
                </div>
            </div>
        </div>

        <!-- 3. Key Concepts -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Independent vs. Mutually Exclusive Events</h2>

            <table class="stat-ops-table">
                <thead><tr><th>Property</th><th>Independent Events</th><th>Mutually Exclusive Events</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Definition</td><td>One event does not affect the other</td><td>Events cannot both occur</td></tr>
                    <tr><td style="font-weight:600;">P(A &cap; B)</td><td>P(A) &times; P(B)</td><td>0</td></tr>
                    <tr><td style="font-weight:600;">P(A &cup; B)</td><td>P(A) + P(B) &minus; P(A)P(B)</td><td>P(A) + P(B)</td></tr>
                    <tr><td style="font-weight:600;">Example</td><td>Coin flip and die roll</td><td>Drawing a red or blue ball</td></tr>
                    <tr><td style="font-weight:600;">Can both occur?</td><td>Yes</td><td>No</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 4. Applications -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
            <div class="stat-edu-grid">
                <div class="stat-edu-card stat-anim stat-anim-d1">
                    <h4>Medical Diagnosis</h4>
                    <p>Bayes&rsquo; theorem updates disease probability after test results, accounting for base rates and test accuracy.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d2">
                    <h4>Spam Filtering</h4>
                    <p>Na&iuml;ve Bayes classifiers compute the probability an email is spam given the words it contains.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d3">
                    <h4>Insurance &amp; Risk</h4>
                    <p>Actuaries use conditional probabilities to assess risk and calculate premium rates.</p>
                </div>
                <div class="stat-edu-card stat-anim stat-anim-d4">
                    <h4>Games &amp; Sports</h4>
                    <p>Poker odds, win probability given the current game state, expected value of bets.</p>
                </div>
            </div>
        </div>

        <!-- 5. FAQ -->
        <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item">
                <button class="faq-question">What is the difference between independent and mutually exclusive events?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Independent events do not affect each other, so P(A &cap; B) = P(A) &times; P(B). Mutually exclusive events cannot both occur, so P(A &cap; B) = 0. These are different concepts: two events can be independent but not mutually exclusive, and vice versa.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How does Bayes&rsquo; theorem work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Bayes&rsquo; theorem updates a prior probability P(A) based on new evidence B. The posterior P(A|B) = P(B|A) &times; P(A) / P(B). It is widely used in medical testing, spam filtering, and machine learning.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What is conditional probability?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Conditional probability P(A|B) is the probability of event A occurring given that B has already occurred. The formula is P(A &cap; B) / P(B). It narrows the sample space to only outcomes where B is true.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">How do I calculate P(A OR B)?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the addition rule: P(A &cup; B) = P(A) + P(B) &minus; P(A &cap; B). For mutually exclusive events, P(A &cap; B) = 0, so it simplifies to P(A) + P(B). Always subtract the overlap to avoid double-counting.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">What are odds versus probability?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Probability is favorable outcomes divided by total outcomes, ranging from 0 to 1. Odds are favorable to unfavorable (e.g., 3:2). Convert odds to probability: p = favorable / (favorable + unfavorable).</div>
            </div>
            <div class="faq-item">
                <button class="faq-question">Why does Bayes&rsquo; theorem give surprising results for medical tests?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">When a disease is rare (low prior), even a highly accurate test produces many false positives from the large healthy population. This is the base rate fallacy. Bayes&rsquo; theorem correctly accounts for it, showing the posterior can be much lower than expected.</div>
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
    <script src="<%=request.getContextPath()%>/js/probability-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
