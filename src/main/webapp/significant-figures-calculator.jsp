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

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

    <!-- Critical CSS - inlined for zero render-blocking requests on mobile -->
    <style>
        /* Reset */
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        *:focus-visible{outline:2px solid var(--primary);outline-offset:2px}
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}

        /* Design tokens */
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
            --tool-primary:#3b82f6;--tool-primary-dark:#1d4ed8;--tool-gradient:linear-gradient(135deg,#3b82f6 0%,#1d4ed8 100%);--tool-light:#eff6ff
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(59,130,246,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}

        /* Nav header */
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
        @media(max-width:991px){
            .modern-nav{height:var(--header-height-mobile,64px)}
            .nav-container{padding:0 var(--space-3,0.75rem)}
            .nav-search,.nav-items{display:none}
            .nav-actions{gap:var(--space-2,0.5rem)}
            .btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}
            .mobile-menu-toggle,.mobile-search-toggle{display:flex}
            .btn-nav .nav-text{display:none}
        }

        /* Page header + breadcrumbs */
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}

        /* Description section */
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}

        /* Three-column grid */
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) 1fr 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) 1fr}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}

        /* Card + tabs + form (above-fold) */
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-tabs{display:flex;gap:0.25rem;padding:0.5rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);overflow-x:auto;-webkit-overflow-scrolling:touch}
        .tool-tab{padding:0.5rem 0.75rem;font-size:0.75rem;font-weight:500;border:none;background:transparent;color:var(--text-secondary,#475569);cursor:pointer;border-radius:0.375rem;white-space:nowrap;transition:all .15s}
        .tool-tab.active{background:var(--tool-primary);color:#fff}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:1rem;transition:opacity .15s,transform .15s}

        /* Dark mode (above-fold elements) */
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary,#cbd5e1)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-tabs{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-tab{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-tab.active{background:var(--tool-primary);color:#fff}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(59,130,246,0.3)}

        /* Utility */
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Sig Fig Calculator - Count, Round & Convert" />
        <jsp:param name="toolDescription" value="Free sig fig calculator with step-by-step solutions. Count significant figures, round to N digits, perform arithmetic with proper rules, and convert to scientific notation." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="significant-figures-calculator.jsp" />
        <jsp:param name="toolKeywords" value="significant figures calculator, sig figs calculator, significant digits, sig fig counter, scientific notation, chemistry calculator, rounding sig figs, sig fig rules" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Count significant figures in any number,Addition and subtraction with sig fig rules,Multiplication and division with sig fig rules,Round to any number of sig figs,Convert to scientific notation,Step-by-step explanations for every calculation" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What are significant figures?" />
        <jsp:param name="faq1a" value="Significant figures (sig figs) are the digits in a number that carry meaning contributing to its measurement precision. All non-zero digits are significant, trapped zeros between non-zero digits are significant, leading zeros are not significant, and trailing zeros after a decimal point are significant." />
        <jsp:param name="faq2q" value="How do you count significant figures?" />
        <jsp:param name="faq2a" value="Follow five rules: (1) All non-zero digits are significant. (2) Trapped zeros between non-zero digits are significant. (3) Leading zeros are NOT significant. (4) Trailing zeros after a decimal point ARE significant. (5) Trailing zeros in a whole number without a decimal point are ambiguous." />
        <jsp:param name="faq3q" value="What are the sig fig rules for addition and subtraction?" />
        <jsp:param name="faq3a" value="For addition and subtraction, the result should be rounded to the same number of decimal places as the measurement with the fewest decimal places. For example, 12.34 + 5.6 = 17.9 (rounded to 1 decimal place, matching 5.6)." />
        <jsp:param name="faq4q" value="What are the sig fig rules for multiplication and division?" />
        <jsp:param name="faq4a" value="For multiplication and division, the result should be rounded to the same number of significant figures as the measurement with the fewest sig figs. For example, 12.34 times 5.6 = 69 (2 sig figs, matching 5.6 which has 2 sig figs)." />
        <jsp:param name="faq5q" value="How do trailing zeros affect significant figures?" />
        <jsp:param name="faq5a" value="Trailing zeros after a decimal point are always significant (e.g., 1.200 has 4 sig figs). Trailing zeros in a whole number without a decimal point are ambiguous (e.g., 1200 could have 2, 3, or 4 sig figs). Use scientific notation to clarify: 1.20 times 10 cubed = 3 sig figs." />
        <jsp:param name="faq6q" value="How do you round to a specific number of significant figures?" />
        <jsp:param name="faq6a" value="To round to n significant figures, identify the nth significant digit, look at the digit after it, and round up if it is 5 or greater. For example, 123.456 rounded to 3 sig figs becomes 123, and 0.004567 rounded to 2 sig figs becomes 0.0046." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS - all async (critical styles inlined above) -->
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

    <!-- Tool-specific styles -->
    <style>
        :root {
            --tool-primary: #3b82f6;
            --tool-primary-dark: #1d4ed8;
            --tool-gradient: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --tool-light: #eff6ff;
        }

        /* Labels */
        .tool-label {
            display: block;
            font-weight: 600;
            font-size: 0.8125rem;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.375rem;
            letter-spacing: 0.01em;
        }

        .tool-hint {
            font-size: 0.6875rem;
            color: var(--text-secondary, #64748b);
            margin: 0.25rem 0 0 0;
            line-height: 1.4;
        }

        /* Input / select fields */
        .tool-input,
        .tool-select {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-family: var(--font-sans);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .tool-input:focus,
        .tool-select:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        [data-theme="dark"] .tool-label {
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .tool-hint {
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .tool-input,
        [data-theme="dark"] .tool-select {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .tool-input:focus,
        [data-theme="dark"] .tool-select:focus {
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
        }

        /* Form sections visibility toggle */
        .tool-form-section { display: none; padding: 1.25rem; }
        .tool-form-section.active { display: block; }

        .tool-form-group {
            margin-bottom: 1rem;
        }

        .tool-form-actions {
            margin-top: 1.25rem;
        }

        /* Result card */
        .tool-result-card {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .tool-result-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 1.25rem;
            background: var(--bg-secondary, #f8fafc);
            border-bottom: 1px solid var(--border, #e2e8f0);
            border-radius: 0.75rem 0.75rem 0 0;
        }

        .tool-result-header h4 {
            margin: 0;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
        }

        .tool-result-content {
            flex: 1;
            padding: 1.25rem;
            min-height: 300px;
            overflow-y: auto;
        }

        /* Result actions bar */
        .tool-result-actions {
            display: none;
            gap: 0.5rem;
            padding: 1rem 1.25rem;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0 0 0.75rem 0.75rem;
            flex-wrap: wrap;
        }

        .tool-result-actions.visible { display: flex; }

        .tool-result-actions .tool-action-btn {
            flex: 1;
            min-width: 90px;
            margin-top: 0;
        }

        /* Empty state */
        .tool-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 3rem 1.5rem;
            color: var(--text-muted, #94a3b8);
        }

        .tool-empty-state h3 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-secondary, #475569);
        }

        .tool-empty-state p {
            font-size: 0.875rem;
            max-width: 280px;
        }

        /* ========== Sig Figs Specific Styles ========== */

        /* Example chips */
        .example-chip {
            display: inline-block;
            margin: 3px;
            padding: 5px 10px;
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 9999px;
            cursor: pointer;
            font-size: 0.8rem;
            font-family: var(--font-mono);
            transition: all 0.15s;
            color: var(--text-primary, #0f172a);
        }

        .example-chip:hover {
            background: var(--tool-light);
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        .example-category-label {
            font-weight: 600;
            font-size: 0.75rem;
            color: var(--text-secondary, #475569);
            margin-top: 0.75rem;
            margin-bottom: 0.375rem;
            padding-bottom: 0.25rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .example-category-label:first-child {
            margin-top: 0;
        }

        /* Result badges */
        .result-badge {
            background: var(--success, #10b981);
            color: white;
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.03em;
        }

        .step-badge {
            background: #8b5cf6;
            color: white;
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.03em;
        }

        .sig-badge {
            background: var(--tool-primary);
            color: white;
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.03em;
        }

        /* Number display */
        .number-display {
            font-family: var(--font-mono);
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary, #1f2937);
            background: var(--bg-tertiary, #f3f4f6);
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            margin: 0.75rem 0;
            word-break: break-all;
        }

        .sig-digit {
            color: var(--success, #059669);
            font-weight: 700;
        }

        .non-sig-digit {
            color: var(--text-muted, #9ca3af);
        }

        /* Result & step sections */
        .result-section {
            background: var(--bg-secondary, #f9fafb);
            border-left: 4px solid var(--tool-primary);
            padding: 1rem 1.25rem;
            margin-top: 1rem;
            border-radius: 0 0.5rem 0.5rem 0;
        }

        .result-section h6 {
            margin: 0 0 0.5rem;
        }

        .result-section h4 {
            margin: 0 0 0.75rem;
            color: var(--text-primary, #1f2937);
        }

        .result-section hr {
            border: none;
            border-top: 1px solid var(--border, #e5e7eb);
            margin: 0.75rem 0;
        }

        .result-section p {
            margin: 0.25rem 0;
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
        }

        .step-section {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border, #e5e7eb);
            padding: 0.75rem 1rem;
            margin-top: 0.5rem;
            border-radius: 0.375rem;
        }

        .step-section p {
            margin: 0.25rem 0;
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
        }

        .step-section .indent {
            padding-left: 1rem;
        }

        /* Info & rule boxes */
        .info-box {
            background: var(--tool-light);
            border-left: 4px solid var(--tool-primary);
            padding: 0.75rem 1rem;
            margin: 0.75rem 0;
            border-radius: 0 0.375rem 0.375rem 0;
        }

        .info-box p {
            margin: 0;
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
        }

        .rule-box {
            background: #f0fdf4;
            border-left: 4px solid var(--success, #059669);
            padding: 0.75rem 1rem;
            margin: 0.75rem 0;
            border-radius: 0 0.375rem 0.375rem 0;
        }

        .rule-box p {
            margin: 0.25rem 0;
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
        }

        /* Dark mode overrides for sig fig elements */
        [data-theme="dark"] .example-chip {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .example-chip:hover {
            background: rgba(59,130,246,0.15);
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        [data-theme="dark"] .example-category-label {
            color: var(--text-secondary, #94a3b8);
            border-bottom-color: var(--border, #334155);
        }

        [data-theme="dark"] .number-display {
            background: var(--bg-tertiary, #334155);
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .result-section {
            background: var(--bg-tertiary, #334155);
            border-left-color: var(--tool-primary);
        }

        [data-theme="dark"] .result-section h4 {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .result-section hr {
            border-top-color: var(--border, #475569);
        }

        [data-theme="dark"] .result-section p {
            color: var(--text-secondary, #cbd5e1);
        }

        [data-theme="dark"] .step-section {
            background: rgba(255,255,255,0.05);
            border-color: var(--border, #475569);
        }

        [data-theme="dark"] .step-section p {
            color: var(--text-secondary, #cbd5e1);
        }

        [data-theme="dark"] .info-box {
            background: rgba(59,130,246,0.15);
            border-left-color: var(--tool-primary);
        }

        [data-theme="dark"] .info-box p {
            color: var(--text-secondary, #cbd5e1);
        }

        [data-theme="dark"] .rule-box {
            background: rgba(16,185,129,0.15);
            border-left-color: var(--success, #10b981);
        }

        [data-theme="dark"] .rule-box p {
            color: var(--text-secondary, #cbd5e1);
        }

        [data-theme="dark"] .sig-digit {
            color: #6ee7b7;
        }

        /* Expression input */
        .expr-input {
            width: 100%;
            padding: 0.625rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-size: 1rem;
            font-family: var(--font-mono);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .expr-input:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        [data-theme="dark"] .expr-input {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        /* Practice quiz styles */
        .quiz-question {
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            padding: 0.875rem 1rem;
            margin-bottom: 0.75rem;
        }

        .quiz-question-text {
            font-weight: 600;
            font-size: 0.875rem;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .quiz-number {
            font-family: var(--font-mono);
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--tool-primary);
        }

        .quiz-options {
            display: flex;
            gap: 0.375rem;
            flex-wrap: wrap;
        }

        .quiz-option {
            padding: 0.375rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 9999px;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            font-size: 0.8125rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
        }

        .quiz-option:hover {
            border-color: var(--tool-primary);
            background: var(--tool-light);
        }

        .quiz-option.correct {
            border-color: var(--success, #10b981);
            background: rgba(16, 185, 129, 0.15);
            color: var(--success, #10b981);
            font-weight: 600;
        }

        .quiz-option.wrong {
            border-color: var(--error, #ef4444);
            background: rgba(239, 68, 68, 0.1);
            color: var(--error, #ef4444);
            text-decoration: line-through;
        }

        .quiz-option.disabled {
            pointer-events: none;
            opacity: 0.6;
        }

        .quiz-feedback {
            margin-top: 0.5rem;
            font-size: 0.8125rem;
            font-weight: 500;
            display: none;
        }

        .quiz-feedback.show { display: block; }
        .quiz-feedback.correct-fb { color: var(--success, #10b981); }
        .quiz-feedback.wrong-fb { color: var(--error, #ef4444); }

        .quiz-score {
            text-align: center;
            padding: 0.75rem;
            background: var(--tool-light);
            border-radius: 0.5rem;
            font-weight: 600;
            font-size: 0.9375rem;
            color: var(--tool-primary-dark);
            margin-top: 0.5rem;
        }

        [data-theme="dark"] .quiz-question {
            background: rgba(255,255,255,0.05);
            border-color: var(--border, #334155);
        }

        [data-theme="dark"] .quiz-option {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .quiz-option:hover {
            background: rgba(59,130,246,0.15);
        }

        [data-theme="dark"] .quiz-score {
            background: rgba(59,130,246,0.15);
        }

        [data-theme="dark"] .expr-input:focus {
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .tool-result-actions {
                flex-direction: column;
            }

            .tool-result-actions .tool-action-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Significant Figures Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math">Math Tools</a> /
                    Significant Figures Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Chemistry</span>
                <span class="tool-badge">Science</span>
                <span class="tool-badge">Educational</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Count significant figures, perform arithmetic with proper sig fig rules, round to sig figs, and convert to scientific notation. Step-by-step solutions included.</p>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <!-- Tab Selection -->
                <div class="tool-tabs" role="tablist">
                    <button type="button" class="tool-tab active" data-tab="count" role="tab">
                        <span>&#128290;</span> Count
                    </button>
                    <button type="button" class="tool-tab" data-tab="arithmetic" role="tab">
                        <span>&#10133;</span> Arithmetic
                    </button>
                    <button type="button" class="tool-tab" data-tab="round" role="tab">
                        <span>&#128260;</span> Round
                    </button>
                    <button type="button" class="tool-tab" data-tab="notation" role="tab">
                        <span>&#128300;</span> Scientific
                    </button>
                    <button type="button" class="tool-tab" data-tab="expression" role="tab">
                        <span>&#128221;</span> Expression
                    </button>
                    <button type="button" class="tool-tab" data-tab="practice" role="tab">
                        <span>&#127891;</span> Practice
                    </button>
                </div>

                <!-- ========== Tab 1: Count ========== -->
                <div id="countSection" class="tool-form-section active">
                    <div class="tool-form-group">
                        <label class="tool-label" for="countNumber">Number</label>
                        <input type="text" id="countNumber" class="tool-input" placeholder="e.g., 0.00450, 1200, 3.140">
                        <p class="tool-hint">Enter any number including scientific notation (e.g., 1.23e5)</p>
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="countSigFigs()">
                            Count Significant Figures
                        </button>
                    </div>

                    <div style="margin-top: 1.25rem;">
                        <div class="example-category-label">Leading Zeros</div>
                        <span class="example-chip" onclick="setCountExample('0.00450')">0.00450</span>
                        <span class="example-chip" onclick="setCountExample('0.0123')">0.0123</span>
                        <span class="example-chip" onclick="setCountExample('0.500')">0.500</span>

                        <div class="example-category-label">Trailing Zeros</div>
                        <span class="example-chip" onclick="setCountExample('1200')">1200</span>
                        <span class="example-chip" onclick="setCountExample('1200.')">1200.</span>
                        <span class="example-chip" onclick="setCountExample('1200.0')">1200.0</span>
                        <span class="example-chip" onclick="setCountExample('120')">120</span>

                        <div class="example-category-label">Trapped Zeros</div>
                        <span class="example-chip" onclick="setCountExample('1002')">1002</span>
                        <span class="example-chip" onclick="setCountExample('50.03')">50.03</span>
                        <span class="example-chip" onclick="setCountExample('1.0023')">1.0023</span>

                        <div class="example-category-label">Scientific Notation</div>
                        <span class="example-chip" onclick="setCountExample('1.23e5')">1.23&times;10&#8309;</span>
                        <span class="example-chip" onclick="setCountExample('4.500e-3')">4.500&times;10&#8315;&#179;</span>
                        <span class="example-chip" onclick="setCountExample('6.02e23')">6.02&times;10&#178;&#179;</span>
                    </div>
                </div>

                <!-- ========== Tab 2: Arithmetic ========== -->
                <div id="arithmeticSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label" for="arithmeticOp">Operation</label>
                        <select id="arithmeticOp" class="tool-select">
                            <option value="add">Addition (+)</option>
                            <option value="subtract">Subtraction (&minus;)</option>
                            <option value="multiply">Multiplication (&times;)</option>
                            <option value="divide">Division (&divide;)</option>
                        </select>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="arithmeticNum1">First Number</label>
                        <input type="text" id="arithmeticNum1" class="tool-input" placeholder="e.g., 12.34">
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="arithmeticNum2">Second Number</label>
                        <input type="text" id="arithmeticNum2" class="tool-input" placeholder="e.g., 5.6">
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="calculateArithmetic()">
                            Calculate with Sig Figs
                        </button>
                    </div>

                    <div style="margin-top: 1.25rem;">
                        <div class="example-category-label">Addition</div>
                        <span class="example-chip" onclick="setArithmeticExample('add', '12.34', '5.6')">12.34 + 5.6</span>
                        <span class="example-chip" onclick="setArithmeticExample('add', '100.5', '23.456')">100.5 + 23.456</span>

                        <div class="example-category-label">Subtraction</div>
                        <span class="example-chip" onclick="setArithmeticExample('subtract', '45.67', '12.3')">45.67 &minus; 12.3</span>
                        <span class="example-chip" onclick="setArithmeticExample('subtract', '1000', '5.5')">1000 &minus; 5.5</span>

                        <div class="example-category-label">Multiplication</div>
                        <span class="example-chip" onclick="setArithmeticExample('multiply', '12.34', '5.6')">12.34 &times; 5.6</span>
                        <span class="example-chip" onclick="setArithmeticExample('multiply', '0.0045', '123')">0.0045 &times; 123</span>

                        <div class="example-category-label">Division</div>
                        <span class="example-chip" onclick="setArithmeticExample('divide', '45.67', '12.3')">45.67 &divide; 12.3</span>
                        <span class="example-chip" onclick="setArithmeticExample('divide', '100', '3.0')">100 &divide; 3.0</span>
                    </div>
                </div>

                <!-- ========== Tab 3: Round ========== -->
                <div id="roundSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label" for="roundNumber">Number to Round</label>
                        <input type="text" id="roundNumber" class="tool-input" placeholder="e.g., 123.4567">
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="roundSigFigs">Target Significant Figures</label>
                        <input type="number" id="roundSigFigs" class="tool-input" placeholder="e.g., 3" min="1" max="10">
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="roundToSigFigs()">
                            Round Number
                        </button>
                    </div>

                    <div style="margin-top: 1.25rem;">
                        <div class="example-category-label">Basic</div>
                        <span class="example-chip" onclick="setRoundExample('123.456', 3)">123.456 &rarr; 3</span>
                        <span class="example-chip" onclick="setRoundExample('0.004567', 2)">0.004567 &rarr; 2</span>

                        <div class="example-category-label">Large Numbers</div>
                        <span class="example-chip" onclick="setRoundExample('12345', 3)">12345 &rarr; 3</span>
                        <span class="example-chip" onclick="setRoundExample('98765', 2)">98765 &rarr; 2</span>

                        <div class="example-category-label">Decimal Numbers</div>
                        <span class="example-chip" onclick="setRoundExample('45.678', 4)">45.678 &rarr; 4</span>
                        <span class="example-chip" onclick="setRoundExample('0.123456', 3)">0.123456 &rarr; 3</span>
                    </div>
                </div>

                <!-- ========== Tab 4: Scientific Notation ========== -->
                <div id="notationSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label" for="notationNumber">Number</label>
                        <input type="text" id="notationNumber" class="tool-input" placeholder="e.g., 0.00456 or 1.23e-5">
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="notationSigFigs">Significant Figures (optional)</label>
                        <input type="number" id="notationSigFigs" class="tool-input" placeholder="Leave blank for auto">
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="convertNotation()">
                            Convert to Scientific Notation
                        </button>
                    </div>

                    <div style="margin-top: 1.25rem;">
                        <div class="example-category-label">Small Numbers</div>
                        <span class="example-chip" onclick="setNotationExample('0.00456')">0.00456</span>
                        <span class="example-chip" onclick="setNotationExample('0.0000789')">0.0000789</span>

                        <div class="example-category-label">Large Numbers</div>
                        <span class="example-chip" onclick="setNotationExample('123000')">123000</span>
                        <span class="example-chip" onclick="setNotationExample('6020000000000000000000000')">Avogadro's</span>

                        <div class="example-category-label">Already Scientific</div>
                        <span class="example-chip" onclick="setNotationExample('1.23e5')">1.23&times;10&#8309;</span>
                        <span class="example-chip" onclick="setNotationExample('4.5e-3')">4.5&times;10&#8315;&#179;</span>
                    </div>
                </div>

                <!-- ========== Tab 5: Expression Parser ========== -->
                <div id="expressionSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label" for="exprInput">Math Expression</label>
                        <input type="text" id="exprInput" class="expr-input" placeholder="e.g., (12.34 + 5.6) * 2.1">
                        <p class="tool-hint">Supports +, &minus;, &times;, &divide;, parentheses, and numbers with sig figs</p>
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="evaluateExpression()">
                            Evaluate Expression
                        </button>
                    </div>

                    <div style="margin-top: 1.25rem;">
                        <div class="example-category-label">Multi-step</div>
                        <span class="example-chip" onclick="setExprExample('(12.34 + 5.6) * 2.1')">(12.34 + 5.6) * 2.1</span>
                        <span class="example-chip" onclick="setExprExample('100.5 / 3.0 + 2.45')">100.5 / 3.0 + 2.45</span>

                        <div class="example-category-label">Simple</div>
                        <span class="example-chip" onclick="setExprExample('0.0045 * 123')">0.0045 * 123</span>
                        <span class="example-chip" onclick="setExprExample('45.67 - 12.3')">45.67 - 12.3</span>

                        <div class="example-category-label">Nested</div>
                        <span class="example-chip" onclick="setExprExample('(6.02 * 1.5) / (3.0 + 1.00)')">(6.02*1.5)/(3.0+1.00)</span>
                    </div>
                </div>

                <!-- ========== Tab 6: Practice ========== -->
                <div id="practiceSection" class="tool-form-section">
                    <p class="tool-hint" style="margin-bottom: 1rem; font-size: 0.8125rem; color: var(--text-secondary);">Test your sig fig knowledge. Click an answer for each question.</p>
                    <div id="quizContainer"></div>
                    <div id="quizScore" class="quiz-score" style="display: none;"></div>
                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="generateQuiz()" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                            New Quiz
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <span>&#128202;</span>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="displaySection">
                    <div class="tool-empty-state" id="emptyState">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;margin-bottom:0.75rem;opacity:0.4;">
                            <rect x="4" y="2" width="16" height="20" rx="2"/>
                            <line x1="8" y1="6" x2="16" y2="6"/>
                            <line x1="8" y1="10" x2="16" y2="10"/>
                            <line x1="8" y1="14" x2="12" y2="14"/>
                        </svg>
                        <h3>Sig Fig Calculator</h3>
                        <p>Enter a number and click Calculate to see the result with step-by-step explanation.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="resultActions">
                    <button type="button" class="tool-action-btn" id="copyResultBtn">
                        <span>&#128203;</span> Copy Text
                    </button>
                    <button type="button" class="tool-action-btn" id="shareUrlBtn">
                        <span>&#128279;</span> Share URL
                    </button>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <!-- Mobile Ad Fallback -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Math Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="significant-figures-calculator.jsp"/>
        <jsp:param name="keyword" value="math"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== EDUCATIONAL CONTENT (below-the-fold, SEO-visible) ========== -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

        <!-- What Are Significant Figures -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">What Are Significant Figures?</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;"><strong>Significant figures</strong> (also called significant digits or sig figs) are the digits in a number that carry meaning contributing to its measurement precision. They include all non-zero digits, trapped zeros between non-zero digits, and trailing zeros after a decimal point.</p>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">Understanding significant figures is essential in science, engineering, and chemistry because measurements always have a limited precision. When you perform calculations with measured values, the result can only be as precise as the least precise measurement used.</p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1.25rem;">
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem; text-align: center;">
                    <div style="font-family: var(--font-mono); font-size: 1.1rem; font-weight: 600; color: var(--tool-primary); margin-bottom: 0.5rem;">0.00450</div>
                    <p style="color: var(--text-secondary); font-size: 0.85rem; margin: 0;">3 sig figs</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem; text-align: center;">
                    <div style="font-family: var(--font-mono); font-size: 1.1rem; font-weight: 600; color: var(--tool-primary); margin-bottom: 0.5rem;">1002</div>
                    <p style="color: var(--text-secondary); font-size: 0.85rem; margin: 0;">4 sig figs</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem; text-align: center;">
                    <div style="font-family: var(--font-mono); font-size: 1.1rem; font-weight: 600; color: var(--tool-primary); margin-bottom: 0.5rem;">1200</div>
                    <p style="color: var(--text-secondary); font-size: 0.85rem; margin: 0;">2 sig figs (ambiguous)</p>
                </div>
            </div>
        </div>

        <!-- 5 Rules -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">5 Rules for Counting Significant Figures</h2>
            <ol style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.75rem;">
                    <strong>All non-zero digits are significant</strong>
                    <br><span style="font-size: 0.9rem;">Example: 123 has 3 sig figs</span>
                </li>
                <li style="margin-bottom: 0.75rem;">
                    <strong>Trapped zeros (between non-zero digits) are significant</strong>
                    <br><span style="font-size: 0.9rem;">Example: 1002 has 4 sig figs</span>
                </li>
                <li style="margin-bottom: 0.75rem;">
                    <strong>Leading zeros are NOT significant</strong>
                    <br><span style="font-size: 0.9rem;">Example: 0.0045 has 2 sig figs</span>
                </li>
                <li style="margin-bottom: 0.75rem;">
                    <strong>Trailing zeros after a decimal point ARE significant</strong>
                    <br><span style="font-size: 0.9rem;">Example: 1.200 has 4 sig figs</span>
                </li>
                <li style="margin-bottom: 0;">
                    <strong>Trailing zeros in a whole number without a decimal point are ambiguous</strong>
                    <br><span style="font-size: 0.9rem;">Example: 1200 could have 2, 3, or 4 sig figs &mdash; use scientific notation to clarify</span>
                </li>
            </ol>
        </div>

        <!-- Quick Sig Fig Reference Table (targets "how many sig figs in X?" queries) -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">How Many Significant Figures? &mdash; Quick Reference</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">Common numbers students search for, answered at a glance:</p>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
                    <thead>
                        <tr style="background: var(--bg-secondary); border-bottom: 2px solid var(--border);">
                            <th style="padding: 0.6rem 1rem; text-align: left; color: var(--text-primary); font-weight: 600;">Number</th>
                            <th style="padding: 0.6rem 1rem; text-align: center; color: var(--text-primary); font-weight: 600;">Sig Figs</th>
                            <th style="padding: 0.6rem 1rem; text-align: left; color: var(--text-primary); font-weight: 600;">Rule Applied</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">100</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">1</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Trailing zeros without decimal are ambiguous</td>
                        </tr>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">100.</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">3</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Decimal point makes trailing zeros significant</td>
                        </tr>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">100.00</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">5</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Trailing zeros after decimal ARE significant</td>
                        </tr>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">0.01</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">1</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Leading zeros are NOT significant</td>
                        </tr>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">0.00208</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">3</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Leading zeros not significant; 2, 0, 8 are significant (trapped zero)</td>
                        </tr>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">1200</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">2</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Ambiguous &mdash; use 1.2 &times; 10&sup3; for clarity</td>
                        </tr>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">1200.0</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">5</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Decimal point + trailing zero = all digits significant</td>
                        </tr>
                        <tr>
                            <td style="padding: 0.5rem 1rem; font-family: var(--font-mono); color: var(--tool-primary); font-weight: 600;">6.022 &times; 10&sup2;&sup3;</td>
                            <td style="padding: 0.5rem 1rem; text-align: center; font-weight: 600;">4</td>
                            <td style="padding: 0.5rem 1rem; color: var(--text-secondary);">Scientific notation &mdash; count digits in the coefficient</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Calculation Rules -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Calculation Rules for Significant Figures</h2>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem; color: var(--tool-primary);">Addition &amp; Subtraction</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 0.5rem;">Round the result to the <strong>fewest decimal places</strong> of any input number.</p>
                    <div style="background: var(--bg-secondary); border-radius: 8px; padding: 0.75rem 1rem; font-family: var(--font-mono); font-size: 0.9rem; color: var(--text-primary);">
                        12.34 + 5.6 = 17.94 &rarr; <strong>17.9</strong>
                    </div>
                    <p style="color: var(--text-muted); font-size: 0.8rem; margin-top: 0.5rem;">5.6 has 1 decimal place, so the answer is rounded to 1 decimal place.</p>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem; color: var(--tool-primary);">Multiplication &amp; Division</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 0.5rem;">Round the result to the <strong>fewest significant figures</strong> of any input number.</p>
                    <div style="background: var(--bg-secondary); border-radius: 8px; padding: 0.75rem 1rem; font-family: var(--font-mono); font-size: 0.9rem; color: var(--text-primary);">
                        12.34 &times; 5.6 = 69.104 &rarr; <strong>69</strong>
                    </div>
                    <p style="color: var(--text-muted); font-size: 0.8rem; margin-top: 0.5rem;">5.6 has 2 sig figs, so the answer is rounded to 2 sig figs.</p>
                </div>
            </div>

            <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">Scientific Notation</h3>
            <p style="color: var(--text-secondary); margin-bottom: 0.5rem;">Format: <strong>a &times; 10<sup>n</sup></strong> where 1 &le; |a| &lt; 10. Scientific notation removes ambiguity about trailing zeros.</p>
            <div style="background: var(--bg-secondary); border-radius: 8px; padding: 0.75rem 1rem; font-family: var(--font-mono); font-size: 0.9rem; color: var(--text-primary);">
                1200 = 1.2 &times; 10&sup3; (2 sig figs) &nbsp;|&nbsp; 0.00456 = 4.56 &times; 10&#8315;&sup3; (3 sig figs)
            </div>
        </div>

        <!-- FAQ -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Frequently Asked Questions</h2>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What are significant figures?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Significant figures (sig figs) are the digits in a number that carry meaning contributing to its measurement precision. All non-zero digits are significant, trapped zeros between non-zero digits are significant, leading zeros are not significant, and trailing zeros after a decimal point are significant.</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">How do you count significant figures?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Follow five rules: (1) All non-zero digits are significant. (2) Trapped zeros between non-zero digits are significant. (3) Leading zeros are NOT significant. (4) Trailing zeros after a decimal point ARE significant. (5) Trailing zeros in a whole number without a decimal point are ambiguous.</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What are the sig fig rules for addition and subtraction?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">For addition and subtraction, the result should be rounded to the same number of decimal places as the measurement with the fewest decimal places. For example, 12.34 + 5.6 = 17.9 (rounded to 1 decimal place, matching 5.6).</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What are the sig fig rules for multiplication and division?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">For multiplication and division, the result should be rounded to the same number of significant figures as the measurement with the fewest sig figs. For example, 12.34 &times; 5.6 = 69 (2 sig figs, matching 5.6 which has 2 sig figs).</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">How do trailing zeros affect significant figures?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Trailing zeros after a decimal point are always significant (e.g., 1.200 has 4 sig figs). Trailing zeros in a whole number without a decimal point are ambiguous (e.g., 1200 could have 2, 3, or 4 sig figs). Use scientific notation to clarify: 1.20 &times; 10&sup3; = 3 sig figs.</p>
            </div>

            <div style="margin-bottom: 0;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">How do you round to a specific number of significant figures?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">To round to n significant figures, identify the nth significant digit, look at the digit after it, and round up if it is 5 or greater. For example, 123.456 rounded to 3 sig figs becomes 123, and 0.004567 rounded to 2 sig figs becomes 0.0046.</p>
            </div>
        </div>

        <!-- E-E-A-T: About This Tool -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">About This Significant Figures Tool</h2>
            <p style="margin-bottom: 1rem; color: var(--text-secondary);">This Significant Figures Calculator provides four core functions: counting sig figs, arithmetic with proper rounding rules, rounding to a target number of sig figs, and scientific notation conversion. Each calculation includes step-by-step explanations so you can learn the rules as you use the tool.</p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship &amp; Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--tool-primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Science and engineering education tools</li>
                        <li><strong>Covers:</strong> Sig fig counting, arithmetic rules, rounding, and scientific notation</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Tool Details</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Methodology:</strong> Standard sig fig rules per NIST and chemistry textbook conventions</li>
                        <li><strong>Privacy:</strong> All calculations run entirely in your browser &mdash; nothing is sent to a server</li>
                        <li><strong>Support:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--tool-primary);">@anish2good</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
    // ========== Tab switching ==========
    document.querySelectorAll('.tool-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.tool-tab').forEach(function(t) { t.classList.remove('active'); });
            document.querySelectorAll('.tool-form-section').forEach(function(s) { s.classList.remove('active'); });
            this.classList.add('active');
            var tabName = this.getAttribute('data-tab');
            var sectionId = tabName + 'Section';
            var section = document.getElementById(sectionId);
            if (section) section.classList.add('active');
            if (tabName === 'practice' && document.getElementById('quizContainer').innerHTML === '') {
                generateQuiz();
            }
        });
    });

    // ========== Constants ==========
    var TOOL_NAME = 'Significant Figures Calculator';
    var lastResultText = '';

    // ========== Helper: show result and actions bar ==========
    function showResult(html, plainText) {
        document.getElementById('displaySection').innerHTML = html;
        document.getElementById('resultActions').classList.add('visible');
        lastResultText = plainText || '';
    }

    // ========== Color-coded digit display ==========
    function colorCodeNumber(numStr) {
        var str = numStr.trim();
        var sciMatch = str.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);
        if (sciMatch) {
            return colorCodeNumber(sciMatch[1]) +
                '<span style="font-size:0.85em"> \u00D7 10<sup>' + sciMatch[2] + '</sup></span>';
        }
        var html = '', idx = 0;
        if (str[0] === '+' || str[0] === '-') { html += str[0]; idx = 1; }
        var body = str.substring(idx);
        var dotPos = body.indexOf('.');
        var hasDot = dotPos !== -1;
        var intP = hasDot ? body.substring(0, dotPos) : body;
        var decP = hasDot ? body.substring(dotPos + 1) : '';

        if (hasDot && (intP === '0' || intP === '')) {
            for (var i = 0; i < intP.length; i++) html += '<span class="non-sig-digit">' + intP[i] + '</span>';
            html += '<span class="non-sig-digit">.</span>';
            var nz = false;
            for (var i = 0; i < decP.length; i++) {
                if (!nz && decP[i] !== '0') nz = true;
                html += '<span class="' + (nz ? 'sig-digit' : 'non-sig-digit') + '">' + decP[i] + '</span>';
            }
        } else if (hasDot) {
            for (var i = 0; i < intP.length; i++) html += '<span class="sig-digit">' + intP[i] + '</span>';
            html += '<span class="sig-digit">.</span>';
            for (var i = 0; i < decP.length; i++) html += '<span class="sig-digit">' + decP[i] + '</span>';
        } else {
            var lastNZ = -1;
            for (var i = intP.length - 1; i >= 0; i--) { if (intP[i] !== '0') { lastNZ = i; break; } }
            var started = false;
            for (var i = 0; i < intP.length; i++) {
                if (!started && intP[i] !== '0') started = true;
                if (!started) html += '<span class="non-sig-digit">' + intP[i] + '</span>';
                else if (i <= lastNZ) html += '<span class="sig-digit">' + intP[i] + '</span>';
                else html += '<span class="non-sig-digit">' + intP[i] + '</span>';
            }
        }
        return html;
    }

    // ========== Core: Analyze Significant Figures ==========
    function analyzeSigFigs(numStr) {
        numStr = numStr.trim();

        // Handle scientific notation (e.g., 1.23e5 or 1.23E5)
        var sciMatch = numStr.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);
        if (sciMatch) {
            return analyzeSigFigs(sciMatch[1]);
        }

        // Remove positive sign if present
        numStr = numStr.replace(/^\+/, '');

        // Check if negative
        var isNegative = numStr.startsWith('-');
        if (isNegative) {
            numStr = numStr.substring(1);
        }

        // Split by decimal point
        var parts = numStr.split('.');
        var hasDecimal = parts.length === 2;
        var integerPart = parts[0];
        var decimalPart = parts[1] || '';

        var sigFigs = 0;
        var explanation = [];

        if (hasDecimal) {
            if (integerPart === '0' || integerPart === '') {
                // Number like 0.00450
                var foundNonZero = false;
                for (var i = 0; i < decimalPart.length; i++) {
                    var digit = decimalPart[i];
                    if (!foundNonZero && digit !== '0') {
                        foundNonZero = true;
                    }
                    if (foundNonZero) {
                        sigFigs++;
                    }
                }
                explanation.push('Leading zeros after decimal are NOT significant');
                explanation.push('All digits after the first non-zero digit ARE significant (including trailing zeros)');
            } else {
                // Number like 123.450
                for (var j = 0; j < integerPart.length; j++) {
                    if (integerPart[j] !== '0' || sigFigs > 0) {
                        sigFigs++;
                    }
                }
                sigFigs += decimalPart.length;
                explanation.push('All non-zero digits are significant');
                explanation.push('Trailing zeros after decimal point ARE significant');
            }
        } else {
            // No decimal point (e.g., 1200)
            var foundNZ = false;
            var trailingZeros = 0;

            for (var k = 0; k < integerPart.length; k++) {
                var d = integerPart[k];
                if (d !== '0') {
                    foundNZ = true;
                    sigFigs++;
                    trailingZeros = 0;
                } else if (foundNZ) {
                    if (k < integerPart.length - 1 && integerPart.substring(k + 1).match(/[1-9]/)) {
                        sigFigs++;
                    } else {
                        trailingZeros++;
                    }
                }
            }

            if (trailingZeros > 0) {
                explanation.push('Trailing zeros without decimal point are AMBIGUOUS');
                explanation.push('Assuming ' + sigFigs + ' sig figs (not counting trailing zeros)');
                explanation.push('Use scientific notation to clarify');
            } else {
                explanation.push('All non-zero digits are significant');
                explanation.push('Trapped zeros (between non-zero digits) are significant');
            }
        }

        return {
            sigFigs: sigFigs,
            explanation: explanation,
            original: (isNegative ? '-' : '') + numStr
        };
    }

    // ========== Count Significant Figures ==========
    function countSigFigs() {
        var input = document.getElementById('countNumber').value.trim();
        if (!input) {
            ToolUtils.showToast('Please enter a number', 2000, 'warning');
            return;
        }

        var result = analyzeSigFigs(input);
        displaySigFigCount(result, input);
    }

    function displaySigFigCount(result, original) {
        var html = '<div class="result-section">' +
            '<h6><span class="result-badge">SIGNIFICANT FIGURES</span></h6>' +
            '<div class="number-display">' + colorCodeNumber(original) + '</div>' +
            '<p style="font-size:0.7rem;margin-top:0.375rem;"><span class="sig-digit">\u25CF</span> Significant digit &nbsp;&nbsp; <span class="non-sig-digit">\u25CF</span> Not significant</p>' +
            '<h4>' + result.sigFigs + ' significant figure' + (result.sigFigs !== 1 ? 's' : '') + '</h4>' +
            '<hr>' +
            '<h6><span class="step-badge">EXPLANATION</span></h6>' +
            '<div class="step-section">';

        for (var i = 0; i < result.explanation.length; i++) {
            html += '<p>&bull; ' + result.explanation[i] + '</p>';
        }

        html += '</div></div>';

        var plain = original + ' has ' + result.sigFigs + ' significant figure' + (result.sigFigs !== 1 ? 's' : '');
        showResult(html, plain);
    }

    // ========== Arithmetic with Sig Figs ==========
    function calculateArithmetic() {
        var op = document.getElementById('arithmeticOp').value;
        var num1Str = document.getElementById('arithmeticNum1').value.trim();
        var num2Str = document.getElementById('arithmeticNum2').value.trim();

        if (!num1Str || !num2Str) {
            ToolUtils.showToast('Please enter both numbers', 2000, 'warning');
            return;
        }

        var num1 = parseFloat(num1Str);
        var num2 = parseFloat(num2Str);

        if (isNaN(num1) || isNaN(num2)) {
            ToolUtils.showToast('Please enter valid numbers', 2000, 'warning');
            return;
        }

        var sig1 = analyzeSigFigs(num1Str);
        var sig2 = analyzeSigFigs(num2Str);

        var rawResult, finalResult, rule, steps;

        if (op === 'add' || op === 'subtract') {
            rawResult = op === 'add' ? num1 + num2 : num1 - num2;

            var dec1 = getDecimalPlaces(num1Str);
            var dec2 = getDecimalPlaces(num2Str);
            var minDecimals = Math.min(dec1, dec2);

            finalResult = rawResult.toFixed(minDecimals);
            rule = 'Round to ' + minDecimals + ' decimal place' + (minDecimals !== 1 ? 's' : '') + ' (fewest among inputs)';

            steps = '<p><strong>Input Numbers:</strong></p>' +
                '<p class="indent">' + num1Str + ' (' + dec1 + ' decimal places)</p>' +
                '<p class="indent">' + num2Str + ' (' + dec2 + ' decimal places)</p>' +
                '<p><strong>Raw Result:</strong></p>' +
                '<p class="indent">' + rawResult + '</p>' +
                '<p><strong>Rule for Addition/Subtraction:</strong></p>' +
                '<p class="indent">Round to the fewest decimal places</p>' +
                '<p><strong>Final Result:</strong></p>' +
                '<p class="indent">' + finalResult + ' (' + minDecimals + ' decimal places)</p>';
        } else {
            rawResult = op === 'multiply' ? num1 * num2 : num1 / num2;

            var minSigFigs = Math.min(sig1.sigFigs, sig2.sigFigs);

            finalResult = roundToNSigFigs(rawResult, minSigFigs);
            rule = 'Round to ' + minSigFigs + ' sig fig' + (minSigFigs !== 1 ? 's' : '') + ' (fewest among inputs)';

            steps = '<p><strong>Input Numbers:</strong></p>' +
                '<p class="indent">' + num1Str + ' (' + sig1.sigFigs + ' sig figs)</p>' +
                '<p class="indent">' + num2Str + ' (' + sig2.sigFigs + ' sig figs)</p>' +
                '<p><strong>Raw Result:</strong></p>' +
                '<p class="indent">' + rawResult + '</p>' +
                '<p><strong>Rule for Multiplication/Division:</strong></p>' +
                '<p class="indent">Round to the fewest significant figures</p>' +
                '<p><strong>Final Result:</strong></p>' +
                '<p class="indent">' + finalResult + ' (' + minSigFigs + ' sig figs)</p>';
        }

        var opSymbol = { add: '+', subtract: '\u2212', multiply: '\u00D7', divide: '\u00F7' }[op];

        var html = '<div class="result-section">' +
            '<h6><span class="result-badge">RESULT</span></h6>' +
            '<div class="number-display">' + num1Str + ' ' + opSymbol + ' ' + num2Str + ' = ' + finalResult + '</div>' +
            '<hr>' +
            '<h6><span class="step-badge">CALCULATION STEPS</span></h6>' +
            '<div class="step-section">' + steps + '</div>' +
            '<hr>' +
            '<div class="info-box"><p><strong>Rule Applied:</strong> ' + rule + '</p></div>' +
            '</div>';

        var plain = num1Str + ' ' + opSymbol + ' ' + num2Str + ' = ' + finalResult + ' (' + rule + ')';
        showResult(html, plain);
    }

    function getDecimalPlaces(numStr) {
        var parts = numStr.split('.');
        return parts.length === 2 ? parts[1].length : 0;
    }

    function roundToNSigFigs(num, n) {
        if (num === 0) return '0';

        var d = Math.ceil(Math.log10(Math.abs(num)));
        var power = n - d;

        var magnitude = Math.pow(10, power);
        var shifted = Math.round(num * magnitude);
        var result = shifted / magnitude;

        if (Math.abs(result) >= 1000 || Math.abs(result) < 0.001) {
            return result.toExponential(n - 1);
        } else {
            var str = result.toPrecision(n);
            if (str.indexOf('.') !== -1) {
                str = str.replace(/\.?0+$/, '');
            }
            return str;
        }
    }

    // ========== Round to Sig Figs ==========
    function roundToSigFigs() {
        var numStr = document.getElementById('roundNumber').value.trim();
        var targetSigFigs = parseInt(document.getElementById('roundSigFigs').value);

        if (!numStr || isNaN(targetSigFigs) || targetSigFigs < 1) {
            ToolUtils.showToast('Please enter a valid number and number of sig figs', 2000, 'warning');
            return;
        }

        var num = parseFloat(numStr);
        var original = analyzeSigFigs(numStr);

        var rounded = roundToNSigFigs(num, targetSigFigs);

        var html = '<div class="result-section">' +
            '<h6><span class="result-badge">ROUNDED RESULT</span></h6>' +
            '<div class="number-display">' + rounded + '</div>' +
            '<p>' + targetSigFigs + ' significant figure' + (targetSigFigs !== 1 ? 's' : '') + '</p>' +
            '<hr>' +
            '<h6><span class="step-badge">ORIGINAL NUMBER</span></h6>' +
            '<div class="step-section">' +
            '<p>Number: ' + numStr + '</p>' +
            '<p>Original sig figs: ' + original.sigFigs + '</p>' +
            '</div>' +
            '<hr>' +
            '<div class="info-box"><p><strong>Rounding:</strong> ' +
            (original.sigFigs > targetSigFigs ? 'Decreased' : 'Increased') +
            ' precision from ' + original.sigFigs + ' to ' + targetSigFigs + ' sig figs</p></div>' +
            '</div>';

        var plain = numStr + ' rounded to ' + targetSigFigs + ' sig figs = ' + rounded;
        showResult(html, plain);
    }

    // ========== Scientific Notation ==========
    function convertNotation() {
        var numStr = document.getElementById('notationNumber').value.trim();
        var targetSigFigs = document.getElementById('notationSigFigs').value;

        if (!numStr) {
            ToolUtils.showToast('Please enter a number', 2000, 'warning');
            return;
        }

        var sciMatch = numStr.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);

        var num = parseFloat(numStr);
        var original = analyzeSigFigs(numStr);

        var mantissa, exponent, scientific, standard;

        if (sciMatch) {
            exponent = parseInt(sciMatch[2]);
            mantissa = parseFloat(sciMatch[1]);
            scientific = numStr;
            standard = num.toString();
        } else {
            if (num === 0) {
                scientific = '0';
                standard = '0';
                exponent = 0;
                mantissa = 0;
            } else {
                exponent = Math.floor(Math.log10(Math.abs(num)));
                mantissa = num / Math.pow(10, exponent);

                var sigFigs = targetSigFigs ? parseInt(targetSigFigs) : original.sigFigs;
                var mantissaStr = mantissa.toPrecision(sigFigs);

                scientific = mantissaStr + ' \u00D7 10^' + exponent;
                standard = num.toString();
            }
        }

        var html = '<div class="result-section">' +
            '<h6><span class="sig-badge">SCIENTIFIC NOTATION</span></h6>' +
            '<div class="number-display">' + scientific + '</div>' +
            '<hr>' +
            '<h6><span class="step-badge">CONVERSIONS</span></h6>' +
            '<div class="step-section">' +
            '<p><strong>Standard Form:</strong></p>' +
            '<p class="indent">' + standard + '</p>' +
            '<p><strong>Scientific Notation:</strong></p>' +
            '<p class="indent">' + scientific + '</p>' +
            '<p><strong>Components:</strong></p>' +
            '<p class="indent">Mantissa: ' + mantissa + '</p>' +
            '<p class="indent">Exponent: ' + exponent + '</p>' +
            '</div>' +
            '<hr>' +
            '<div class="info-box"><p><strong>Significant Figures:</strong> ' + original.sigFigs + '</p></div>' +
            '</div>';

        var plain = standard + ' = ' + scientific + ' (' + original.sigFigs + ' sig figs)';
        showResult(html, plain);
    }

    // ========== Expression Parser ==========
    function tokenizeExpr(expr) {
        var tokens = [], i = 0;
        while (i < expr.length) {
            if (expr[i] === ' ') { i++; continue; }
            if (expr[i] === '(' || expr[i] === ')') { tokens.push({ type: expr[i] }); i++; continue; }
            if ('+-*/\u00D7\u00F7'.indexOf(expr[i]) !== -1) {
                if ((expr[i] === '-' || expr[i] === '+') &&
                    (tokens.length === 0 || tokens[tokens.length - 1].type === '(' || tokens[tokens.length - 1].type === 'op')) {
                    var ns = expr[i]; i++;
                    while (i < expr.length && /[\d.]/.test(expr[i])) { ns += expr[i]; i++; }
                    if (i < expr.length && /[eE]/.test(expr[i])) {
                        ns += expr[i]; i++;
                        if (i < expr.length && /[+-]/.test(expr[i])) { ns += expr[i]; i++; }
                        while (i < expr.length && /\d/.test(expr[i])) { ns += expr[i]; i++; }
                    }
                    tokens.push({ type: 'num', str: ns, val: parseFloat(ns) });
                } else {
                    var op = expr[i];
                    if (op === '\u00D7') op = '*';
                    if (op === '\u00F7') op = '/';
                    tokens.push({ type: 'op', value: op }); i++;
                }
                continue;
            }
            if (/[\d.]/.test(expr[i])) {
                var ns = '';
                while (i < expr.length && /[\d.]/.test(expr[i])) { ns += expr[i]; i++; }
                if (i < expr.length && /[eE]/.test(expr[i])) {
                    ns += expr[i]; i++;
                    if (i < expr.length && /[+-]/.test(expr[i])) { ns += expr[i]; i++; }
                    while (i < expr.length && /\d/.test(expr[i])) { ns += expr[i]; i++; }
                }
                tokens.push({ type: 'num', str: ns, val: parseFloat(ns) });
                continue;
            }
            throw new Error('Unexpected character: ' + expr[i]);
        }
        return tokens;
    }

    function parseExprAddSub(tokens, pos, steps) {
        var left = parseExprMulDiv(tokens, pos, steps);
        while (pos.i < tokens.length && tokens[pos.i].type === 'op' &&
               (tokens[pos.i].value === '+' || tokens[pos.i].value === '-')) {
            var op = tokens[pos.i].value; pos.i++;
            var right = parseExprMulDiv(tokens, pos, steps);
            left = combineExprValues(left, right, op, steps);
        }
        return left;
    }

    function parseExprMulDiv(tokens, pos, steps) {
        var left = parseExprAtom(tokens, pos, steps);
        while (pos.i < tokens.length && tokens[pos.i].type === 'op' &&
               (tokens[pos.i].value === '*' || tokens[pos.i].value === '/')) {
            var op = tokens[pos.i].value; pos.i++;
            var right = parseExprAtom(tokens, pos, steps);
            left = combineExprValues(left, right, op, steps);
        }
        return left;
    }

    function parseExprAtom(tokens, pos, steps) {
        if (pos.i >= tokens.length) throw new Error('Unexpected end of expression');
        var tok = tokens[pos.i];
        if (tok.type === '(') {
            pos.i++;
            var result = parseExprAddSub(tokens, pos, steps);
            if (pos.i >= tokens.length || tokens[pos.i].type !== ')') throw new Error('Missing closing parenthesis');
            pos.i++;
            return result;
        }
        if (tok.type === 'num') {
            pos.i++;
            var sf = analyzeSigFigs(tok.str);
            return { val: tok.val, sigFigs: sf.sigFigs, decPlaces: getDecimalPlaces(tok.str), display: tok.str };
        }
        throw new Error('Unexpected token');
    }

    function combineExprValues(a, b, op, steps) {
        var raw, finalVal, finalSF, finalDP, rule, display;
        var opSym = { '+': '+', '-': '\u2212', '*': '\u00D7', '/': '\u00F7' }[op];
        if (op === '/' && b.val === 0) throw new Error('Division by zero');
        if (op === '+' || op === '-') {
            raw = op === '+' ? a.val + b.val : a.val - b.val;
            finalDP = Math.max(0, Math.min(a.decPlaces, b.decPlaces));
            display = raw.toFixed(finalDP);
            finalVal = parseFloat(display);
            finalSF = analyzeSigFigs(display).sigFigs;
            rule = 'Add/Sub: round to ' + finalDP + ' decimal place' + (finalDP !== 1 ? 's' : '');
        } else {
            raw = op === '*' ? a.val * b.val : a.val / b.val;
            finalSF = Math.min(a.sigFigs, b.sigFigs);
            display = roundToNSigFigs(raw, finalSF);
            finalVal = parseFloat(display);
            finalDP = getDecimalPlaces('' + finalVal);
            rule = 'Mul/Div: round to ' + finalSF + ' sig fig' + (finalSF !== 1 ? 's' : '');
        }
        steps.push({
            desc: a.display + ' ' + opSym + ' ' + b.display,
            raw: '' + parseFloat(raw.toPrecision(10)),
            rule: rule,
            rounded: display
        });
        return { val: finalVal, sigFigs: finalSF, decPlaces: finalDP, display: display };
    }

    function evaluateExpression() {
        var expr = document.getElementById('exprInput').value.trim();
        if (!expr) { ToolUtils.showToast('Please enter an expression', 2000, 'warning'); return; }
        try {
            var tokens = tokenizeExpr(expr);
            var pos = { i: 0 };
            var steps = [];
            var result = parseExprAddSub(tokens, pos, steps);
            if (pos.i < tokens.length) throw new Error('Unexpected token after expression');

            var html = '<div class="result-section">' +
                '<h6><span class="result-badge">EXPRESSION RESULT</span></h6>' +
                '<div class="number-display">' + expr + ' = ' + result.display + '</div>' +
                '<p>' + result.sigFigs + ' significant figure' + (result.sigFigs !== 1 ? 's' : '') + '</p>';

            if (steps.length > 0) {
                html += '<hr><h6><span class="step-badge">STEP-BY-STEP</span></h6>';
                for (var s = 0; s < steps.length; s++) {
                    html += '<div class="step-section">' +
                        '<p><strong>Step ' + (s + 1) + ':</strong> ' + steps[s].desc + '</p>' +
                        '<p class="indent">Raw: ' + steps[s].raw + '</p>' +
                        '<p class="indent">Rule: ' + steps[s].rule + '</p>' +
                        '<p class="indent">Result: <strong>' + steps[s].rounded + '</strong></p>' +
                        '</div>';
                }
            }
            html += '</div>';

            var plain = expr + ' = ' + result.display + ' (' + result.sigFigs + ' sig figs)';
            showResult(html, plain);
        } catch (e) {
            ToolUtils.showToast(e.message || 'Invalid expression', 3000, 'warning');
        }
    }

    function setExprExample(expr) {
        document.getElementById('exprInput').value = expr;
    }

    // ========== Practice Quiz ==========
    var quizData = [], quizScore = 0, quizAnswered = 0;

    function generateQuiz() {
        quizData = []; quizScore = 0; quizAnswered = 0;
        var pool = [
            { num: '0.00450', sf: 3 }, { num: '1200', sf: 2 }, { num: '1200.', sf: 4 },
            { num: '100', sf: 1 }, { num: '100.0', sf: 4 }, { num: '0.500', sf: 3 },
            { num: '1002', sf: 4 }, { num: '0.0123', sf: 3 }, { num: '45.00', sf: 4 },
            { num: '8000', sf: 1 }, { num: '8000.', sf: 4 }, { num: '0.070', sf: 2 },
            { num: '30.40', sf: 4 }, { num: '0.0001', sf: 1 }, { num: '50.003', sf: 5 },
            { num: '0.200', sf: 3 }, { num: '120', sf: 2 }, { num: '3.14', sf: 3 },
            { num: '6.022e23', sf: 4 }, { num: '1.00e-5', sf: 3 }, { num: '10.0', sf: 3 },
            { num: '0.00208', sf: 3 }, { num: '4050', sf: 3 }, { num: '90.0', sf: 3 }
        ];
        var shuffled = pool.slice().sort(function() { return Math.random() - 0.5; });
        quizData = shuffled.slice(0, 5);
        var container = document.getElementById('quizContainer');
        var html = '';
        for (var i = 0; i < quizData.length; i++) {
            var q = quizData[i];
            var opts = quizGenOptions(q.sf);
            html += '<div class="quiz-question" id="quiz-q-' + i + '">' +
                '<div class="quiz-question-text">Q' + (i + 1) + '. How many sig figs in <span class="quiz-number">' + q.num + '</span>?</div>' +
                '<div class="quiz-options">';
            for (var j = 0; j < opts.length; j++) {
                html += '<button type="button" class="quiz-option" onclick="checkQuizAnswer(' + i + ',' + opts[j] + ',this)">' + opts[j] + '</button>';
            }
            html += '</div><div class="quiz-feedback" id="quiz-fb-' + i + '"></div></div>';
        }
        container.innerHTML = html;
        document.getElementById('quizScore').style.display = 'none';
    }

    function quizGenOptions(correct) {
        var opts = [correct], cands = [];
        for (var i = 1; i <= 7; i++) { if (i !== correct) cands.push(i); }
        cands.sort(function() { return Math.random() - 0.5; });
        opts.push(cands[0], cands[1], cands[2]);
        opts.sort(function() { return Math.random() - 0.5; });
        return opts;
    }

    function checkQuizAnswer(qIdx, answer, btn) {
        var q = quizData[qIdx];
        var fb = document.getElementById('quiz-fb-' + qIdx);
        if (fb.classList.contains('show')) return;
        quizAnswered++;
        var allBtns = document.getElementById('quiz-q-' + qIdx).querySelectorAll('.quiz-option');
        for (var i = 0; i < allBtns.length; i++) {
            allBtns[i].classList.add('disabled');
            if (parseInt(allBtns[i].textContent) === q.sf) allBtns[i].classList.add('correct');
        }
        if (answer === q.sf) {
            quizScore++;
            btn.classList.add('correct');
            fb.textContent = '\u2713 Correct!';
            fb.className = 'quiz-feedback show correct-fb';
        } else {
            btn.classList.add('wrong');
            fb.textContent = '\u2717 Answer: ' + q.sf + ' sig fig' + (q.sf !== 1 ? 's' : '');
            fb.className = 'quiz-feedback show wrong-fb';
        }
        if (quizAnswered >= quizData.length) {
            var scoreEl = document.getElementById('quizScore');
            var msg = quizScore === quizData.length ? ' \u2014 Perfect!' : quizScore >= 3 ? ' \u2014 Good job!' : ' \u2014 Keep practicing!';
            scoreEl.textContent = 'Score: ' + quizScore + ' / ' + quizData.length + msg;
            scoreEl.style.display = 'block';
        }
    }

    // ========== Example Setters ==========
    function setCountExample(num) {
        document.getElementById('countNumber').value = num;
    }

    function setArithmeticExample(op, num1, num2) {
        document.getElementById('arithmeticOp').value = op;
        document.getElementById('arithmeticNum1').value = num1;
        document.getElementById('arithmeticNum2').value = num2;
    }

    function setRoundExample(num, sigFigs) {
        document.getElementById('roundNumber').value = num;
        document.getElementById('roundSigFigs').value = sigFigs;
    }

    function setNotationExample(num) {
        document.getElementById('notationNumber').value = num;
        document.getElementById('notationSigFigs').value = '';
    }

    // ========== Result Actions ==========
    document.getElementById('copyResultBtn').addEventListener('click', function() {
        if (lastResultText) {
            ToolUtils.copyToClipboard(lastResultText, { toolName: TOOL_NAME });
        }
    });

    document.getElementById('shareUrlBtn').addEventListener('click', function() {
        var activeTab = document.querySelector('.tool-tab.active');
        var tabName = activeTab ? activeTab.getAttribute('data-tab') : 'count';
        var params = { tab: tabName };

        if (tabName === 'count') {
            params.num = document.getElementById('countNumber').value;
        } else if (tabName === 'arithmetic') {
            params.op = document.getElementById('arithmeticOp').value;
            params.num1 = document.getElementById('arithmeticNum1').value;
            params.num2 = document.getElementById('arithmeticNum2').value;
        } else if (tabName === 'round') {
            params.num = document.getElementById('roundNumber').value;
            params.sigfigs = document.getElementById('roundSigFigs').value;
        } else if (tabName === 'notation') {
            params.num = document.getElementById('notationNumber').value;
            params.sigfigs = document.getElementById('notationSigFigs').value;
        } else if (tabName === 'expression') {
            params.expr = document.getElementById('exprInput').value;
        }

        var shareUrl = ToolUtils.generateShareUrl(params, { toolName: TOOL_NAME });
        ToolUtils.copyToClipboard(shareUrl, { toolName: TOOL_NAME, toastMessage: 'Share URL copied!' });
    });

    // ========== DOMContentLoaded: auto-load from URL params ==========
    document.addEventListener('DOMContentLoaded', function() {
        var urlParams = new URLSearchParams(window.location.search);
        var tab = urlParams.get('tab');
        if (!tab) return;

        // Switch to the requested tab
        var tabBtn = document.querySelector('.tool-tab[data-tab="' + tab + '"]');
        if (tabBtn) tabBtn.click();

        if (tab === 'count' && urlParams.get('num')) {
            document.getElementById('countNumber').value = decodeURIComponent(urlParams.get('num'));
            countSigFigs();
        } else if (tab === 'arithmetic' && urlParams.get('num1') && urlParams.get('num2')) {
            if (urlParams.get('op')) document.getElementById('arithmeticOp').value = decodeURIComponent(urlParams.get('op'));
            document.getElementById('arithmeticNum1').value = decodeURIComponent(urlParams.get('num1'));
            document.getElementById('arithmeticNum2').value = decodeURIComponent(urlParams.get('num2'));
            calculateArithmetic();
        } else if (tab === 'round' && urlParams.get('num') && urlParams.get('sigfigs')) {
            document.getElementById('roundNumber').value = decodeURIComponent(urlParams.get('num'));
            document.getElementById('roundSigFigs').value = decodeURIComponent(urlParams.get('sigfigs'));
            roundToSigFigs();
        } else if (tab === 'notation' && urlParams.get('num')) {
            document.getElementById('notationNumber').value = decodeURIComponent(urlParams.get('num'));
            if (urlParams.get('sigfigs')) document.getElementById('notationSigFigs').value = decodeURIComponent(urlParams.get('sigfigs'));
            convertNotation();
        } else if (tab === 'expression' && urlParams.get('expr')) {
            document.getElementById('exprInput').value = decodeURIComponent(urlParams.get('expr'));
            evaluateExpression();
        } else if (tab === 'practice') {
            generateQuiz();
        }
    });
    </script>
</body>
</html>
