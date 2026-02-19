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
            --tool-primary:#ec4899;--tool-primary-dark:#be185d;--tool-gradient:linear-gradient(135deg,#ec4899 0%,#be185d 100%);--tool-light:#fce7f3
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(236,72,153,0.15)}
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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(236,72,153,0.3)}

        /* Utility */
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Magic Square Generator - Free Online Tool" />
        <jsp:param name="toolDescription" value="Free magic square generator for sizes 3x3 to 9x9 with animated construction, interactive sum verification, and step-by-step method explanations. Explore Siamese, Strachey, and Conway LUX algorithms instantly in your browser." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="magic-square-generator.jsp" />
        <jsp:param name="toolKeywords" value="magic square generator, magic square calculator, create magic square, 3x3 magic square, 5x5 magic square, magic square solver, magic constant, siamese method, strachey method, conway lux, lo shu square, recreational math" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Generate magic squares 3x3 to 9x9,Multiple construction methods (Siamese/Strachey/Conway),Animated cell-by-cell construction,Row/column/diagonal sum verification,Custom starting number,Magic constant calculation,Interactive cell highlighting,Educational method explanations" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a magic square?" />
        <jsp:param name="faq1a" value="A magic square is an arrangement of distinct numbers in a square grid where every row, column, and both main diagonals all sum to the same value, called the magic constant. The magic constant for an n x n square starting at 1 is M = n(n squared + 1) / 2." />
        <jsp:param name="faq2q" value="How are magic squares constructed?" />
        <jsp:param name="faq2a" value="Different methods are used depending on the size: the Siamese (de la Loubere) method for odd-order squares, the doubly-even diagonal-swap method for sizes divisible by 4, and the Strachey or Conway LUX method for singly-even squares like 6x6." />
        <jsp:param name="faq3q" value="What is the magic constant formula?" />
        <jsp:param name="faq3a" value="For an n x n magic square using consecutive integers starting at 1, the magic constant is M = n(n squared + 1) / 2. For example, a 3x3 square has M = 15, a 5x5 square has M = 65, and a 7x7 square has M = 175." />
        <jsp:param name="faq4q" value="What is the Siamese method for magic squares?" />
        <jsp:param name="faq4a" value="The Siamese method (also called de la Loubere method) works for odd-order magic squares. Start at the top center cell, then move diagonally up and right for each successive number. When blocked by an occupied cell or going off the grid, move down one row instead." />
        <jsp:param name="faq5q" value="What is the Lo Shu square?" />
        <jsp:param name="faq5a" value="The Lo Shu square is the unique 3x3 magic square using numbers 1 through 9, with a magic constant of 15. It is one of the oldest known magic squares, originating in ancient China around 2200 BCE, and holds cultural significance in feng shui and Chinese numerology." />
        <jsp:param name="faq6q" value="Can I create a magic square with custom starting numbers?" />
        <jsp:param name="faq6a" value="Yes. This generator lets you set any starting number. The magic constant adjusts accordingly: for a starting number s and size n, the constant becomes M = n(2s + n squared - 1) / 2. For example, a 3x3 square starting at 5 has M = 3(10+8)/2 = 27." />
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
        /* Magic Square Tool - overrides on three-column-tool.css */
        :root {
            --tool-primary: #ec4899;
            --tool-primary-dark: #be185d;
            --tool-gradient: linear-gradient(135deg, #ec4899 0%, #be185d 100%);
            --tool-light: #fce7f3;
            --square-secondary: #f472b6;
            --square-accent: #8b5cf6;
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

        /* Hint text */
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
            box-shadow: 0 0 0 3px rgba(236, 72, 153, 0.15);
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
            box-shadow: 0 0 0 3px rgba(236, 72, 153, 0.25);
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

        /* ========== Magic Square Specific Styles ========== */

        .magic-square-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 1rem 0;
        }

        .magic-square {
            display: inline-grid;
            gap: 4px;
            padding: 1.5rem;
            background: linear-gradient(135deg, var(--tool-light), var(--bg-primary, #fff));
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .square-cell {
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-primary, #fff);
            border: 3px solid var(--square-secondary);
            border-radius: 8px;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--tool-primary-dark);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .square-cell::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, var(--tool-primary), var(--square-accent));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .square-cell span {
            position: relative;
            z-index: 1;
        }

        .square-cell:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(236, 72, 153, 0.4);
        }

        .square-cell.highlighted {
            animation: highlight 0.6s ease-out;
        }

        .square-cell.highlighted::before {
            opacity: 0.2;
        }

        @keyframes highlight {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.15); }
        }

        .square-cell.build-animate {
            animation: buildCell 0.5s ease-out;
        }

        @keyframes buildCell {
            0% {
                opacity: 0;
                transform: scale(0) rotate(180deg);
            }
            70% {
                transform: scale(1.2) rotate(-10deg);
            }
            100% {
                opacity: 1;
                transform: scale(1) rotate(0);
            }
        }

        .info-panel {
            max-width: 100%;
            margin: 1.5rem 0;
            background: var(--bg-secondary, #f9fafb);
            border-radius: 15px;
            padding: 1rem;
            border: 2px solid var(--square-secondary);
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            margin: 0.4rem 0;
            background: var(--bg-primary, #fff);
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .info-row:hover {
            transform: translateX(5px);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .info-label {
            font-weight: 600;
            color: var(--text-primary, #374151);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }

        .info-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--tool-primary);
        }

        .verify-buttons {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin: 1.5rem 0;
        }

        .verify-btn {
            background: linear-gradient(135deg, var(--square-accent), #7c3aed);
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 10px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(139, 92, 246, 0.3);
        }

        .verify-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 92, 246, 0.5);
        }

        .verify-btn:active {
            transform: translateY(0);
        }

        .explanation-box {
            background: var(--bg-primary, #fff);
            border-left: 5px solid var(--tool-primary);
            border-radius: 10px;
            padding: 1.25rem;
            margin: 1.5rem 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .explanation-box h3 {
            color: var(--tool-primary-dark);
            margin-top: 0;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1rem;
        }

        .explanation-box p {
            color: var(--text-secondary, #4b5563);
            line-height: 1.7;
            margin: 0.5rem 0;
            font-size: 0.875rem;
        }

        .explanation-box .formula {
            background: var(--tool-light);
            padding: 0.75rem;
            border-radius: 8px;
            font-family: var(--font-mono);
            margin: 0.75rem 0;
            text-align: center;
            font-size: 1rem;
            font-weight: 600;
            color: var(--tool-primary-dark);
        }

        .pattern-indicator {
            text-align: center;
            margin: 1rem 0;
            font-size: 0.95rem;
            color: var(--text-muted, #6b7280);
            font-style: italic;
        }

        .success-message {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.75rem;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            font-size: 0.875rem;
            margin: 0.75rem 0;
            animation: successPop 0.5s ease-out;
        }

        @keyframes successPop {
            0% {
                opacity: 0;
                transform: scale(0.8);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        /* Size adjustments for different grid sizes */
        .magic-square.size-3 .square-cell { width: 80px; height: 80px; font-size: 2rem; }
        .magic-square.size-4 .square-cell { width: 70px; height: 70px; font-size: 1.7rem; }
        .magic-square.size-5 .square-cell { width: 60px; height: 60px; font-size: 1.5rem; }
        .magic-square.size-6 .square-cell { width: 50px; height: 50px; font-size: 1.3rem; }
        .magic-square.size-7 .square-cell { width: 45px; height: 45px; font-size: 1.2rem; }
        .magic-square.size-8 .square-cell { width: 40px; height: 40px; font-size: 1.1rem; }
        .magic-square.size-9 .square-cell { width: 38px; height: 38px; font-size: 1rem; }

        /* Learn tab styling */
        .learn-section {
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
            line-height: 1.7;
        }

        .learn-section h3 {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin: 1.25rem 0 0.5rem;
        }

        .learn-section h3:first-child {
            margin-top: 0;
        }

        .learn-section p {
            margin: 0.4rem 0;
        }

        .learn-formula {
            background: var(--tool-light);
            padding: 0.75rem;
            border-radius: 8px;
            font-family: var(--font-mono);
            text-align: center;
            font-size: 1rem;
            font-weight: 600;
            color: var(--tool-primary-dark);
            margin: 0.75rem 0;
        }

        .learn-method {
            background: var(--bg-secondary, #f8fafc);
            border-left: 3px solid var(--tool-primary);
            border-radius: 0.375rem;
            padding: 0.75rem;
            margin: 0.5rem 0;
        }

        .learn-method strong {
            color: var(--text-primary, #0f172a);
        }

        [data-theme="dark"] .learn-section h3 {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .learn-method {
            background: rgba(255,255,255,0.05);
        }

        [data-theme="dark"] .learn-method strong {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .learn-formula {
            background: rgba(236,72,153,0.15);
        }

        /* Dark mode for magic square elements */
        [data-theme="dark"] .magic-square {
            background: rgba(255,255,255,0.05);
        }

        [data-theme="dark"] .square-cell {
            background: var(--bg-secondary);
            border-color: rgba(236,72,153,0.3);
            color: #f9a8d4;
        }

        [data-theme="dark"] .info-panel {
            background: var(--bg-secondary);
            border-color: rgba(236,72,153,0.3);
        }

        [data-theme="dark"] .info-row {
            background: var(--bg-tertiary);
        }

        [data-theme="dark"] .explanation-box {
            background: var(--bg-secondary);
            border-left-color: #ec4899;
        }

        [data-theme="dark"] .explanation-box h3 {
            color: #f9a8d4;
        }

        [data-theme="dark"] .explanation-box p {
            color: var(--text-secondary, #cbd5e1);
        }

        [data-theme="dark"] .explanation-box .formula {
            background: rgba(236,72,153,0.15);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .magic-square.size-3 .square-cell { width: 70px; height: 70px; font-size: 1.8rem; }
            .magic-square.size-4 .square-cell { width: 60px; height: 60px; font-size: 1.5rem; }
            .magic-square.size-5 .square-cell { width: 50px; height: 50px; font-size: 1.3rem; }
            .magic-square.size-6 .square-cell { width: 42px; height: 42px; font-size: 1.1rem; }
            .magic-square.size-7 .square-cell { width: 36px; height: 36px; font-size: 1rem; }
            .magic-square.size-8 .square-cell { width: 32px; height: 32px; font-size: 0.9rem; }
            .magic-square.size-9 .square-cell { width: 30px; height: 30px; font-size: 0.85rem; }

            .verify-buttons {
                flex-direction: column;
            }

            .verify-btn {
                width: 100%;
            }

            .tool-result-actions {
                flex-direction: column;
            }

            .tool-result-actions .tool-action-btn {
                width: 100%;
            }
        }

        /* ========== Animation Styles ========== */
        .square-cell.anim-current { background: linear-gradient(135deg, #10b981, #059669); color: white; transform: scale(1.15); border-color: #059669; z-index: 2; }
        .square-cell.anim-previous { background: linear-gradient(135deg, #60a5fa, #3b82f6); color: white; border-color: #3b82f6; }
        .square-cell.anim-empty { background: var(--bg-tertiary); border-style: dashed; color: transparent; }
        .playback-controls { display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap; }
        .playback-btn {
            background: linear-gradient(135deg, var(--square-accent), #7c3aed);
            color: white; border: none; padding: 0.5rem 1rem; border-radius: 8px;
            font-size: 0.8rem; font-weight: 600; cursor: pointer;
            transition: all 0.2s; box-shadow: 0 2px 8px rgba(139,92,246,0.3);
        }
        .playback-btn:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(139,92,246,0.4); }
        .playback-btn:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
        .speed-slider { width: 100%; accent-color: var(--tool-primary); }
        .step-log { font-family: var(--font-mono); font-size: 0.8rem; max-height: 120px; overflow-y: auto; padding: 0.75rem; background: var(--bg-tertiary); border-radius: 8px; margin-top: 0.75rem; }
        .step-log-entry { padding: 2px 0; border-bottom: 1px solid var(--border); }
        .step-log-entry.current { color: var(--tool-primary); font-weight: 600; }

        /* ========== Checker Styles ========== */
        .checker-grid { display: inline-grid; gap: 3px; padding: 1rem; }
        .checker-input { width: 50px; height: 50px; text-align: center; font-size: 1.2rem; font-weight: 600; border: 2px solid var(--border); border-radius: 6px; background: var(--bg-primary); color: var(--text-primary); font-family: var(--font-sans); }
        .checker-input:focus { border-color: var(--tool-primary); outline: none; box-shadow: 0 0 0 3px rgba(236,72,153,0.2); }
        .checker-input.valid { border-color: #10b981; background: rgba(16,185,129,0.1); }
        .checker-input.invalid { border-color: #ef4444; background: rgba(239,68,68,0.1); }
        .sum-label { font-size: 0.8rem; font-weight: 600; padding: 4px 8px; border-radius: 4px; display: inline-block; }
        .sum-label.correct { background: #dcfce7; color: #166534; }
        .sum-label.incorrect { background: #fef2f2; color: #991b1b; }
        .checker-verdict { padding: 1rem; border-radius: 10px; font-weight: 600; text-align: center; margin-top: 1rem; font-size: 0.95rem; }
        .checker-verdict.valid { background: linear-gradient(135deg, #10b981, #059669); color: white; }
        .checker-verdict.invalid { background: linear-gradient(135deg, #ef4444, #dc2626); color: white; }
        .checker-actions { display: flex; gap: 0.5rem; flex-wrap: wrap; margin-top: 1rem; }
        .checker-actions .tool-action-btn { flex: 1; min-width: 80px; margin-top: 0; font-size: 0.8rem; padding: 0.6rem; }

        /* ========== Heatmap Styles ========== */
        .square-cell.heatmap { border-color: transparent !important; }
        .heatmap-legend { display: flex; align-items: center; gap: 0.5rem; margin: 0.75rem auto; padding: 0.5rem; max-width: 300px; }
        .heatmap-bar { height: 12px; flex: 1; border-radius: 6px; background: linear-gradient(90deg, #3b82f6, #06b6d4, #10b981, #eab308, #ef4444); }
        .heatmap-label { font-size: 0.75rem; color: var(--text-secondary); font-weight: 500; }
        .verify-btn.heatmap-toggle { background: linear-gradient(135deg, #f59e0b, #d97706); box-shadow: 0 3px 10px rgba(245,158,11,0.3); }
        .verify-btn.heatmap-toggle.active { background: linear-gradient(135deg, #10b981, #059669); box-shadow: 0 3px 10px rgba(16,185,129,0.4); }

        /* ========== Print Styles ========== */
        @media print {
            body * { visibility: hidden !important; }
            #printArea, #printArea * { visibility: visible !important; }
            #printArea { position: absolute; top: 0; left: 0; width: 100%; }
        }
        .print-grid { border-collapse: collapse; margin: 1rem auto; }
        .print-grid td { border: 2px solid #000; width: 50px; height: 50px; text-align: center; font-size: 1.2rem; font-weight: 600; }
        .print-title { text-align: center; font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem; }
        .print-info { text-align: center; color: #666; margin-bottom: 1rem; }
        .print-exercise { margin-top: 1.5rem; padding: 1rem; border: 1px solid #ccc; border-radius: 8px; }
        .print-exercise-blank { display: inline-block; width: 40px; border-bottom: 1px solid #000; margin: 0 4px; }
        .print-footer { text-align: center; color: #999; font-size: 0.8rem; margin-top: 2rem; }

        /* ========== Dark Mode for New Features ========== */
        [data-theme="dark"] .step-log { background: var(--bg-tertiary); }
        [data-theme="dark"] .step-log-entry { border-bottom-color: var(--border-light); }
        [data-theme="dark"] .checker-input { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); color: var(--text-primary); }
        [data-theme="dark"] .checker-input.valid { border-color: #10b981; background: rgba(16,185,129,0.15); }
        [data-theme="dark"] .checker-input.invalid { border-color: #ef4444; background: rgba(239,68,68,0.15); }
        [data-theme="dark"] .sum-label.correct { background: rgba(16,185,129,0.2); color: #6ee7b7; }
        [data-theme="dark"] .sum-label.incorrect { background: rgba(239,68,68,0.2); color: #fca5a5; }
        [data-theme="dark"] .square-cell.anim-empty { background: var(--bg-tertiary); }
        [data-theme="dark"] .square-cell.anim-current { background: linear-gradient(135deg, #10b981, #059669); color: white; }
        [data-theme="dark"] .square-cell.anim-previous { background: linear-gradient(135deg, #60a5fa, #3b82f6); color: white; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Magic Square Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math">Math Tools</a> /
                    Magic Square Generator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Recreational Math</span>
                <span class="tool-badge">Number Patterns</span>
                <span class="tool-badge">Interactive</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate magic squares from 3x3 to 9x9 with animated construction. Verify row, column, and diagonal sums with visual highlighting. Learn the Siamese, Strachey, and Conway LUX construction methods.</p>
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
                    <button type="button" class="tool-tab active" data-tab="generate" role="tab">
                        <span>&#9881;</span> Generate
                    </button>
                    <button type="button" class="tool-tab" data-tab="learn" role="tab">
                        <span>&#128218;</span> Learn
                    </button>
                    <button type="button" class="tool-tab" data-tab="animate" role="tab">
                        <span>&#9654;</span> Animate
                    </button>
                    <button type="button" class="tool-tab" data-tab="check" role="tab">
                        <span>&#9989;</span> Check
                    </button>
                </div>

                <!-- ========== Tab 1: Generate ========== -->
                <div id="generateSection" class="tool-form-section active">
                    <div class="tool-form-group">
                        <label class="tool-label" for="squareSize">Square Size</label>
                        <select id="squareSize" class="tool-select" onchange="updateMethodInfo()">
                            <option value="3">3x3 (Odd)</option>
                            <option value="4">4x4 (Doubly Even)</option>
                            <option value="5" selected>5x5 (Odd)</option>
                            <option value="6">6x6 (Singly Even)</option>
                            <option value="7">7x7 (Odd)</option>
                            <option value="8">8x8 (Doubly Even)</option>
                            <option value="9">9x9 (Odd)</option>
                        </select>
                        <p class="tool-hint">Odd, doubly-even (4k), and singly-even sizes use different algorithms</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="method">Construction Method</label>
                        <select id="method" class="tool-select">
                            <option value="siamese">Siamese Method (Odd)</option>
                            <option value="strachey">Strachey Method (Doubly Even)</option>
                            <option value="conway">Conway LUX Method (Singly Even)</option>
                        </select>
                        <p class="tool-hint">Auto-selected based on size; override to explore methods</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="startNumber">Starting Number</label>
                        <input type="number" id="startNumber" class="tool-input" value="1" min="0" max="100" style="max-width:120px;">
                        <p class="tool-hint">First number in the sequence (default: 1)</p>
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" onclick="generateMagicSquare()">
                            Generate Magic Square
                        </button>
                    </div>
                </div>

                <!-- ========== Tab 2: Learn ========== -->
                <div id="learnSection" class="tool-form-section">
                    <div class="learn-section">
                        <h3>Magic Constant Formula</h3>
                        <p>For an n x n magic square starting at 1, every row, column, and diagonal sums to:</p>
                        <div class="learn-formula">M = n(n&sup2; + 1) / 2</div>
                        <p>Example: 3x3 &rarr; M = 15, 5x5 &rarr; M = 65, 7x7 &rarr; M = 175</p>

                        <h3>Siamese Method (Odd Orders)</h3>
                        <div class="learn-method">
                            <strong>For 3x3, 5x5, 7x7, 9x9.</strong>
                            Start at the top center cell. Move diagonally up-right, wrapping around edges. When the target cell is occupied, move down one row instead. Discovered by Simon de la Loub&egrave;re in 1688.
                        </div>

                        <h3>Strachey Method (Doubly Even)</h3>
                        <div class="learn-method">
                            <strong>For 4x4, 8x8 (sizes divisible by 4).</strong>
                            Fill the grid with numbers 1 to n&sup2; in order, then swap numbers that lie on the diagonals of each 4x4 sub-block with their complement (n&sup2; + 1 &minus; value).
                        </div>

                        <h3>Conway LUX Method (Singly Even)</h3>
                        <div class="learn-method">
                            <strong>For 6x6 (sizes = 4k + 2).</strong>
                            Build four smaller odd-order magic sub-squares and combine them with specific row and column swaps to achieve the magic property.
                        </div>

                        <h3>History</h3>
                        <p>Magic squares have been studied for over 4,000 years. The earliest known example is the Lo Shu square (3x3) from ancient China, circa 2200 BCE. They appear in Indian, Arabic, and European mathematical traditions and remain a rich area of recreational and combinatorial mathematics.</p>
                    </div>
                </div>

                <!-- ========== Tab 3: Animate ========== -->
                <div id="animateSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label" for="animSize">Square Size</label>
                        <select id="animSize" class="tool-select">
                            <option value="3">3x3 (Odd)</option>
                            <option value="4">4x4 (Doubly Even)</option>
                            <option value="5" selected>5x5 (Odd)</option>
                            <option value="6">6x6 (Singly Even)</option>
                            <option value="7">7x7 (Odd)</option>
                            <option value="8">8x8 (Doubly Even)</option>
                            <option value="9">9x9 (Odd)</option>
                        </select>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label" for="animSpeed">Speed: <span id="speedLabel">Medium (400ms)</span></label>
                        <input type="range" id="animSpeed" class="speed-slider" min="50" max="1000" value="400" step="50" oninput="updateSpeedLabel()">
                        <p class="tool-hint">Drag left for faster, right for slower</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Playback Controls</label>
                        <div class="playback-controls">
                            <button type="button" class="playback-btn" id="animPlayBtn" onclick="startAnimation()">&#9654; Play</button>
                            <button type="button" class="playback-btn" id="animPauseBtn" onclick="pauseAnimation()" disabled>&#10074;&#10074; Pause</button>
                            <button type="button" class="playback-btn" onclick="stepAnimation()">&#9654;&#124; Step</button>
                            <button type="button" class="playback-btn" onclick="resetAnimation()">&#8634; Reset</button>
                        </div>
                    </div>
                </div>

                <!-- ========== Tab 4: Check ========== -->
                <div id="checkSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label" for="checkerSize">Square Size</label>
                        <select id="checkerSize" class="tool-select">
                            <option value="3">3x3</option>
                            <option value="4">4x4</option>
                            <option value="5" selected>5x5</option>
                            <option value="6">6x6</option>
                            <option value="7">7x7</option>
                            <option value="8">8x8</option>
                            <option value="9">9x9</option>
                        </select>
                    </div>

                    <div class="tool-form-actions" style="margin-top:0.75rem;">
                        <button type="button" class="tool-action-btn" onclick="buildCheckerGrid()">Build Grid</button>
                    </div>

                    <div id="checkerGridContainer" style="text-align:center;margin-top:1rem;"></div>

                    <div class="checker-actions" id="checkerActions" style="display:none;">
                        <button type="button" class="tool-action-btn" onclick="checkMagicSquare()">Check Square</button>
                        <button type="button" class="tool-action-btn" onclick="autoFillChecker()" style="background:linear-gradient(135deg,#8b5cf6,#7c3aed);">Auto-fill</button>
                        <button type="button" class="tool-action-btn" onclick="clearChecker()" style="background:linear-gradient(135deg,#64748b,#475569);">Clear</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <span>&#128203;</span>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="displaySection">
                    <div class="tool-empty-state" id="emptyState">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;margin-bottom:0.75rem;opacity:0.4;">
                            <rect x="3" y="3" width="7" height="7" rx="1"/>
                            <rect x="14" y="3" width="7" height="7" rx="1"/>
                            <rect x="3" y="14" width="7" height="7" rx="1"/>
                            <rect x="14" y="14" width="7" height="7" rx="1"/>
                        </svg>
                        <h3>Magic Square</h3>
                        <p>Select a size and click Generate to create your magic square.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="resultActions">
                    <button type="button" class="tool-action-btn" id="copyResultBtn">
                        <span>&#128203;</span> Copy Text
                    </button>
                    <button type="button" class="tool-action-btn" id="downloadPngBtn">
                        <span>&#128247;</span> Download PNG
                    </button>
                    <button type="button" class="tool-action-btn" id="shareUrlBtn">
                        <span>&#128279;</span> Share URL
                    </button>
                    <button type="button" class="tool-action-btn" id="printWorksheetBtn" onclick="printWorksheet()" style="background:linear-gradient(135deg,#64748b,#475569);">
                        <span>&#128424;</span> Print Worksheet
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
        <jsp:param name="currentToolUrl" value="magic-square-generator.jsp"/>
        <jsp:param name="keyword" value="math"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Explore More Math: Quick Math, Visual Math, Math Memory -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 1.5rem 2rem;">
            <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
                <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
            </h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
                <a href="<%=request.getContextPath()%>/exams/quick-math/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#9889;</div>
                    <div>
                        <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Quick Math</h4>
                        <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">150+ mental math tricks and Vedic math shortcuts for speed calculation</p>
                    </div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #8b5cf6, #7c3aed); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#128202;</div>
                    <div>
                        <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Visual Math Lab</h4>
                        <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">35 interactive visualizations for algebra, calculus, trigonometry and statistics</p>
                    </div>
                </a>
                <a href="<%=request.getContextPath()%>/exams/math-memory/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #10b981, #059669); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#129504;</div>
                    <div>
                        <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Math Memory Games</h4>
                        <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">16 free brain training games to improve memory and mental calculation</p>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <!-- ========== EDUCATIONAL CONTENT (below-the-fold, SEO-visible) ========== -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

        <!-- What Are Magic Squares -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">What Is a Magic Square?</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">A <strong>magic square</strong> is an arrangement of distinct integers in a square grid where the numbers in each row, each column, and both main diagonals all add up to the same value. This value is called the <strong>magic constant</strong> (or magic sum). Magic squares are one of the oldest and most studied objects in recreational mathematics.</p>

            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 8px; padding: 1rem 1.25rem; margin-bottom: 1rem; text-align: center;">
                <p style="font-family: 'JetBrains Mono', monospace; font-size: 1.1rem; font-weight: 600; color: var(--text-primary);">
                    Magic Constant: M = n(n&sup2; + 1) &divide; 2
                </p>
            </div>

            <p style="color: var(--text-secondary); margin-bottom: 1rem;">For example, the classic 3&times;3 magic square (the <strong>Lo Shu square</strong>) uses the numbers 1&ndash;9 and has a magic constant of 15. A 5&times;5 square has a constant of 65, and a 7&times;7 square sums to 175.</p>

            <h3 style="font-size: 1.05rem; margin: 1.5rem 0 0.75rem;">Types of Magic Squares by Order</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-bottom: 1rem;">
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem; color: var(--tool-primary);">Odd Order (3, 5, 7, 9)</h4>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Constructed using the <strong>Siamese method</strong> (de la Loub&egrave;re, 1688). Start at the top center and move diagonally up-right, wrapping around edges. When blocked, move down instead.</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem; color: var(--tool-primary);">Doubly Even Order (4, 8)</h4>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Sizes divisible by 4. Fill sequentially, then swap numbers on the diagonals of each 4&times;4 sub-block with their complement (n&sup2; + 1 &minus; value) to produce the magic property.</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem; color: var(--tool-primary);">Singly Even Order (6)</h4>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Sizes of the form 4k+2. The most complex to construct. Uses the <strong>Strachey</strong> or <strong>Conway LUX</strong> method: build four odd-order sub-squares and combine with careful row/column swaps.</p>
                </div>
            </div>
        </div>

        <!-- History & Applications -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">History &amp; Applications of Magic Squares</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">Magic squares have fascinated mathematicians and mystics for over 4,000 years:</p>
            <ul style="margin-left: 1.5rem; color: var(--text-secondary); margin-bottom: 1rem;">
                <li style="margin-bottom: 0.4rem;"><strong>Lo Shu Square (~2200 BCE):</strong> The earliest known 3&times;3 magic square from ancient China, said to have been discovered on a turtle shell. It remains culturally significant in feng shui and Chinese numerology.</li>
                <li style="margin-bottom: 0.4rem;"><strong>Indian Mathematics (~1st century CE):</strong> The Jain mathematician Nagarjuna described 4&times;4 magic squares. The Chautisa Yantra, found at the Parshvanatha temple in Khajuraho, is a famous 4&times;4 example dating to the 10th&ndash;11th century.</li>
                <li style="margin-bottom: 0.4rem;"><strong>D&uuml;rer&rsquo;s Magic Square (1514):</strong> Albrecht D&uuml;rer included a 4&times;4 magic square in his engraving <em>Melancholia I</em>, with the bottom row containing the year 1514.</li>
                <li style="margin-bottom: 0.4rem;"><strong>Benjamin Franklin (18th century):</strong> Constructed remarkable 8&times;8 and 16&times;16 magic squares with additional properties beyond the standard row/column/diagonal sums.</li>
                <li style="margin-bottom: 0.4rem;"><strong>Modern Applications:</strong> Magic squares appear in experimental design (Latin squares), error-correcting codes, cryptography, puzzle design, and combinatorial optimization.</li>
            </ul>
        </div>

        <!-- Visible FAQ Section (matches structured data) -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Frequently Asked Questions</h2>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What is a magic square?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">A magic square is an arrangement of distinct numbers in a square grid where every row, column, and both main diagonals all sum to the same value, called the magic constant. The magic constant for an n &times; n square starting at 1 is M = n(n&sup2; + 1) / 2.</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">How are magic squares constructed?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Different methods are used depending on the size: the Siamese (de la Loub&egrave;re) method for odd-order squares, the doubly-even diagonal-swap method for sizes divisible by 4, and the Strachey or Conway LUX method for singly-even squares like 6&times;6.</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What is the magic constant formula?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">For an n &times; n magic square using consecutive integers starting at 1, the magic constant is M = n(n&sup2; + 1) / 2. For example, a 3&times;3 square has M = 15, a 5&times;5 square has M = 65, and a 7&times;7 square has M = 175.</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What is the Siamese method for magic squares?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">The Siamese method (also called de la Loub&egrave;re method) works for odd-order magic squares. Start at the top center cell, then move diagonally up and right for each successive number. When blocked by an occupied cell or going off the grid, move down one row instead.</p>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">What is the Lo Shu square?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">The Lo Shu square is the unique 3&times;3 magic square using numbers 1 through 9, with a magic constant of 15. It is one of the oldest known magic squares, originating in ancient China around 2200 BCE, and holds cultural significance in feng shui and Chinese numerology.</p>
            </div>

            <div style="margin-bottom: 0;">
                <h3 style="font-size: 1rem; margin-bottom: 0.5rem; color: var(--text-primary);">Can I create a magic square with custom starting numbers?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Yes. This generator lets you set any starting number. The magic constant adjusts accordingly: for a starting number s and size n, the constant becomes M = n(2s + n&sup2; &minus; 1) / 2. For example, a 3&times;3 square starting at 5 has M = 3(10+8)/2 = 27.</p>
            </div>
        </div>

        <!-- E-E-A-T: About This Tool -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">About This Magic Square Tool &amp; Methodology</h2>
            <p style="margin-bottom: 1rem; color: var(--text-secondary);">This Magic Square Generator uses classical construction algorithms to build verified magic squares for any size from 3&times;3 to 9&times;9. All calculations and animations run entirely in your browser for instant, interactive results.</p>

            <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">How Magic Square Generation Works:</h3>
            <ol style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.5rem;"><strong>Classify the order:</strong> Determine if the size is odd, doubly even (divisible by 4), or singly even (4k+2)</li>
                <li style="margin-bottom: 0.5rem;"><strong>Select algorithm:</strong> Siamese method for odd, diagonal-swap for doubly even, sub-square composition for singly even</li>
                <li style="margin-bottom: 0.5rem;"><strong>Construct the square:</strong> Place numbers algorithmically to guarantee the magic property</li>
                <li style="margin-bottom: 0.5rem;"><strong>Calculate magic constant:</strong> Verify that M = n(n&sup2; + 1) / 2 adjusted for the starting number</li>
                <li><strong>Visual verification:</strong> Highlight rows, columns, and diagonals to confirm all sums match</li>
            </ol>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship &amp; Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--tool-primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Science and engineering education tools</li>
                        <li><strong>Covers:</strong> 3&times;3 through 9&times;9 squares, three construction methods</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Tool Details</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Visualization:</strong> Animated cell-by-cell construction with CSS grid</li>
                        <li><strong>Privacy:</strong> All calculations run entirely in your browser &mdash; nothing is sent to a server</li>
                        <li><strong>Verification:</strong> Interactive row, column, and diagonal sum checking with visual highlighting</li>
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
        });
    });

    // ========== Constants ==========
    var TOOL_NAME = 'Magic Square Generator';

    // ========== Magic Square Logic ==========
    let currentSquare = [];
    let currentSize = 3;
    let magicConstant = 0;

    function updateMethodInfo() {
        const size = parseInt(document.getElementById('squareSize').value);
        const methodSelect = document.getElementById('method');

        // Auto-select appropriate method based on size
        if (size % 2 === 1) {
            // Odd
            methodSelect.value = 'siamese';
        } else if (size % 4 === 0) {
            // Doubly even
            methodSelect.value = 'strachey';
        } else {
            // Singly even
            methodSelect.value = 'conway';
        }
    }

    function generateMagicSquare() {
        const size = parseInt(document.getElementById('squareSize').value);
        const method = document.getElementById('method').value;
        const startNum = parseInt(document.getElementById('startNumber').value);

        currentSize = size;

        // Generate the magic square
        if (size % 2 === 1) {
            currentSquare = generateSiameseSquare(size, startNum);
        } else if (size % 4 === 0) {
            currentSquare = generateDoublyEvenSquare(size, startNum);
        } else {
            currentSquare = generateSinglyEvenSquare(size, startNum);
        }

        // Calculate magic constant
        magicConstant = (startNum + startNum + size * size - 1) * size / 2;

        displayMagicSquare();

        // Show result actions
        var actions = document.getElementById('resultActions');
        if (actions) actions.classList.add('visible');
    }

    function generateSiameseSquare(n, start) {
        const square = Array(n).fill().map(() => Array(n).fill(0));
        let row = 0;
        let col = Math.floor(n / 2);

        for (let num = start; num < start + n * n; num++) {
            square[row][col] = num;

            const newRow = (row - 1 + n) % n;
            const newCol = (col + 1) % n;

            if (square[newRow][newCol] !== 0) {
                row = (row + 1) % n;
            } else {
                row = newRow;
                col = newCol;
            }
        }

        return square;
    }

    function generateDoublyEvenSquare(n, start) {
        const square = Array(n).fill().map(() => Array(n).fill(0));

        // Fill naturally
        let num = start;
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                square[i][j] = num++;
            }
        }

        // Swap diagonals
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                const inMainDiag = (i % 4 === j % 4);
                const inAntiDiag = ((i % 4) + (j % 4) === 3);

                if (inMainDiag || inAntiDiag) {
                    square[i][j] = start + (n * n - 1) - (square[i][j] - start);
                }
            }
        }

        return square;
    }

    function generateSinglyEvenSquare(n, start) {
        // Simplified version for singly even
        const half = n / 2;
        const subSquare = generateSiameseSquare(half, 0);
        const square = Array(n).fill().map(() => Array(n).fill(0));

        // Place four sub-squares
        const offsets = [0, 2 * half * half, 3 * half * half, half * half];
        const positions = [[0, 0], [0, half], [half, 0], [half, half]];

        for (let q = 0; q < 4; q++) {
            for (let i = 0; i < half; i++) {
                for (let j = 0; j < half; j++) {
                    square[positions[q][0] + i][positions[q][1] + j] =
                        subSquare[i][j] * 4 + offsets[q] + start;
                }
            }
        }

        return square;
    }

    function displayMagicSquare() {
        const displaySection = document.getElementById('displaySection');

        let html = '<div class="magic-square-container">';
        html += '<div class="magic-square size-' + currentSize + '" style="grid-template-columns: repeat(' + currentSize + ', 1fr);">';

        for (let i = 0; i < currentSize; i++) {
            for (let j = 0; j < currentSize; j++) {
                html += '<div class="square-cell build-animate" style="animation-delay: ' + ((i * currentSize + j) * 0.05) + 's"'
                      + ' data-row="' + i + '" data-col="' + j + '"'
                      + ' onclick="highlightCell(' + i + ', ' + j + ')">'
                      + '<span>' + currentSquare[i][j] + '</span>'
                      + '</div>';
            }
        }

        html += '</div></div>';

        // Info panel
        html += '<div class="info-panel">';
        html += '<div class="info-row">';
        html += '<div class="info-label"><strong>Magic Constant</strong></div>';
        html += '<div class="info-value">' + magicConstant + '</div>';
        html += '</div>';
        html += '<div class="info-row">';
        html += '<div class="info-label"><strong>Square Size</strong></div>';
        html += '<div class="info-value">' + currentSize + 'x' + currentSize + '</div>';
        html += '</div>';
        html += '<div class="info-row">';
        html += '<div class="info-label"><strong>Number Range</strong></div>';
        var start = parseInt(document.getElementById('startNumber').value);
        html += '<div class="info-value">' + start + ' - ' + (start + currentSize * currentSize - 1) + '</div>';
        html += '</div>';
        html += '</div>';

        // Verify buttons
        html += '<div class="verify-buttons">';
        html += '<button class="verify-btn" onclick="verifyRows()">Verify Rows</button>';
        html += '<button class="verify-btn" onclick="verifyColumns()">Verify Columns</button>';
        html += '<button class="verify-btn" onclick="verifyDiagonals()">Verify Diagonals</button>';
        html += '<button class="verify-btn" onclick="verifyAll()">Verify All</button>';
        html += '<button class="verify-btn heatmap-toggle' + (heatmapActive ? ' active' : '') + '" id="heatmapToggleBtn" onclick="toggleHeatmap()">' + (heatmapActive ? 'Heatmap ON' : 'Heatmap') + '</button>';
        html += '</div>';

        // Explanation
        html += '<div class="explanation-box">';
        html += '<h3>How Magic Squares Work</h3>';
        html += '<p>A <strong>magic square</strong> is an arrangement of numbers in a square grid where:</p>';
        html += '<p>&bull; Every <strong>row</strong> sums to the magic constant<br>';
        html += '&bull; Every <strong>column</strong> sums to the magic constant<br>';
        html += '&bull; Both <strong>diagonals</strong> sum to the magic constant</p>';
        html += '<div class="formula">Magic Constant = n(n&sup2; + 1) / 2</div>';
        html += '<p>For a ' + currentSize + 'x' + currentSize + ' square starting at ' + document.getElementById('startNumber').value + ', ';
        html += 'all rows, columns, and diagonals sum to <strong>' + magicConstant + '</strong>!</p>';

        // Construction method explanation
        var method = document.getElementById('method').value;
        if (method === 'siamese') {
            html += '<p><strong>Siamese Method:</strong> Start at the top center. Move up and right, wrapping around edges. When blocked, move down one cell instead.</p>';
        } else if (method === 'strachey') {
            html += '<p><strong>Strachey Method:</strong> Fill naturally, then swap numbers along specific diagonal patterns to create the magic property.</p>';
        } else if (method === 'conway') {
            html += '<p><strong>Conway LUX Method:</strong> Build four odd magic squares and arrange them with specific swapping rules to create a singly-even magic square.</p>';
        }

        html += '</div>';

        displaySection.innerHTML = html;

        // Re-apply heatmap if active
        if (heatmapActive) {
            setTimeout(function() { applyHeatmap(); }, 100);
        }
    }

    function highlightCell(row, col) {
        const cell = document.querySelector('[data-row="' + row + '"][data-col="' + col + '"]');
        cell.classList.add('highlighted');
        setTimeout(function() { cell.classList.remove('highlighted'); }, 600);
    }

    function verifyRows() {
        clearHighlights();
        let allCorrect = true;

        for (let i = 0; i < currentSize; i++) {
            let sum = 0;
            for (let j = 0; j < currentSize; j++) {
                sum += currentSquare[i][j];
                (function(ri, ci) {
                    setTimeout(function() {
                        const cell = document.querySelector('[data-row="' + ri + '"][data-col="' + ci + '"]');
                        if (cell) cell.classList.add('highlighted');
                    }, (ri * currentSize + ci) * 50);
                })(i, j);
            }
            if (sum !== magicConstant) allCorrect = false;
        }

        setTimeout(function() {
            showResult(allCorrect, 'rows');
            clearHighlights();
        }, currentSize * currentSize * 50 + 500);
    }

    function verifyColumns() {
        clearHighlights();
        let allCorrect = true;

        for (let j = 0; j < currentSize; j++) {
            let sum = 0;
            for (let i = 0; i < currentSize; i++) {
                sum += currentSquare[i][j];
                (function(ri, ci) {
                    setTimeout(function() {
                        const cell = document.querySelector('[data-row="' + ri + '"][data-col="' + ci + '"]');
                        if (cell) cell.classList.add('highlighted');
                    }, (ci * currentSize + ri) * 50);
                })(i, j);
            }
            if (sum !== magicConstant) allCorrect = false;
        }

        setTimeout(function() {
            showResult(allCorrect, 'columns');
            clearHighlights();
        }, currentSize * currentSize * 50 + 500);
    }

    function verifyDiagonals() {
        clearHighlights();
        let sum1 = 0, sum2 = 0;

        // Main diagonal
        for (let i = 0; i < currentSize; i++) {
            sum1 += currentSquare[i][i];
            (function(idx) {
                setTimeout(function() {
                    const cell = document.querySelector('[data-row="' + idx + '"][data-col="' + idx + '"]');
                    if (cell) cell.classList.add('highlighted');
                }, idx * 100);
            })(i);
        }

        // Anti-diagonal
        setTimeout(function() {
            for (let i = 0; i < currentSize; i++) {
                sum2 += currentSquare[i][currentSize - 1 - i];
                (function(idx) {
                    setTimeout(function() {
                        const cell = document.querySelector('[data-row="' + idx + '"][data-col="' + (currentSize - 1 - idx) + '"]');
                        if (cell) cell.classList.add('highlighted');
                    }, idx * 100);
                })(i);
            }
        }, currentSize * 100);

        setTimeout(function() {
            const allCorrect = (sum1 === magicConstant && sum2 === magicConstant);
            showResult(allCorrect, 'diagonals');
            clearHighlights();
        }, currentSize * 200 + 500);
    }

    function verifyAll() {
        clearHighlights();

        // Quick verification without animation
        let allCorrect = true;

        // Check rows
        for (let i = 0; i < currentSize; i++) {
            let sum = currentSquare[i].reduce(function(a, b) { return a + b; }, 0);
            if (sum !== magicConstant) allCorrect = false;
        }

        // Check columns
        for (let j = 0; j < currentSize; j++) {
            let sum = 0;
            for (let i = 0; i < currentSize; i++) {
                sum += currentSquare[i][j];
            }
            if (sum !== magicConstant) allCorrect = false;
        }

        // Check diagonals
        let sum1 = 0, sum2 = 0;
        for (let i = 0; i < currentSize; i++) {
            sum1 += currentSquare[i][i];
            sum2 += currentSquare[i][currentSize - 1 - i];
        }
        if (sum1 !== magicConstant || sum2 !== magicConstant) allCorrect = false;

        // Flash all cells
        for (let i = 0; i < currentSize; i++) {
            for (let j = 0; j < currentSize; j++) {
                (function(ri, ci) {
                    setTimeout(function() {
                        const cell = document.querySelector('[data-row="' + ri + '"][data-col="' + ci + '"]');
                        if (cell) cell.classList.add('highlighted');
                    }, (ri * currentSize + ci) * 30);
                })(i, j);
            }
        }

        setTimeout(function() {
            showResult(allCorrect, 'everything');
            clearHighlights();
        }, currentSize * currentSize * 30 + 500);
    }

    function showResult(success, type) {
        const displaySection = document.getElementById('displaySection');
        const existingMsg = displaySection.querySelector('.success-message');
        if (existingMsg) existingMsg.remove();

        const msg = document.createElement('div');
        msg.className = 'success-message';

        if (success) {
            var successText = 'Perfect! All ' + type + ' sum to ' + magicConstant + '!';
            msg.textContent = successText;
            msg.style.background = 'linear-gradient(135deg, #10b981, #059669)';
            ToolUtils.showToast(successText, 2000, 'success');
        } else {
            var errorText = 'Error in ' + type + ' verification';
            msg.textContent = errorText;
            msg.style.background = 'linear-gradient(135deg, #ef4444, #dc2626)';
            ToolUtils.showToast(errorText, 3000, 'error');
        }

        const container = displaySection.querySelector('.magic-square-container');
        if (container) {
            container.parentNode.insertBefore(msg, container.nextSibling);
        }

        setTimeout(function() { msg.remove(); }, 3000);
    }

    function clearHighlights() {
        document.querySelectorAll('.square-cell').forEach(function(cell) {
            cell.classList.remove('highlighted');
        });
    }

    // ========== RESULT ACTIONS (using ToolUtils) ==========
    document.getElementById('copyResultBtn').addEventListener('click', function() {
        if (!currentSquare.length) {
            ToolUtils.showToast('Generate a magic square first', 2000, 'warning');
            return;
        }

        // Build aligned text grid
        var maxNum = parseInt(document.getElementById('startNumber').value) + currentSize * currentSize - 1;
        var maxLen = String(maxNum).length;
        var lines = [];
        for (var i = 0; i < currentSize; i++) {
            var row = [];
            for (var j = 0; j < currentSize; j++) {
                var s = String(currentSquare[i][j]);
                while (s.length < maxLen) s = ' ' + s;
                row.push(s);
            }
            lines.push(row.join('  '));
        }
        var text = lines.join('\n') + '\n\nMagic Constant: ' + magicConstant + '\nSize: ' + currentSize + 'x' + currentSize;

        ToolUtils.copyToClipboard(text, {
            showToast: true,
            toastMessage: 'Magic square copied!',
            showSupportPopup: true,
            toolName: TOOL_NAME
        });
    });

    document.getElementById('downloadPngBtn').addEventListener('click', function() {
        if (!currentSquare.length) {
            ToolUtils.showToast('Generate a magic square first', 2000, 'warning');
            return;
        }

        var squareEl = document.querySelector('.magic-square-container');
        if (!squareEl) {
            ToolUtils.showToast('No magic square to download', 2000, 'warning');
            return;
        }

        // Strip build animations so captured image shows final state
        var animCells = squareEl.querySelectorAll('.build-animate');
        animCells.forEach(function(c) { c.classList.remove('build-animate'); c.style.animation = 'none'; });

        var filename = 'magic-square-' + currentSize + 'x' + currentSize + '.png';
        ToolUtils.downloadCanvasAsImage(squareEl, filename, {
            scale: 2,
            backgroundColor: document.documentElement.getAttribute('data-theme') === 'dark' ? '#1e293b' : '#ffffff',
            padding: 30,
            showToast: true,
            toastMessage: 'Magic square PNG downloaded!',
            showSupportPopup: true,
            toolName: TOOL_NAME
        });
    });

    document.getElementById('shareUrlBtn').addEventListener('click', function() {
        var size = document.getElementById('squareSize').value;
        var start = document.getElementById('startNumber').value;

        if (!currentSquare.length) {
            ToolUtils.showToast('Generate a magic square first to share', 2000, 'warning');
            return;
        }

        var shareUrl = ToolUtils.generateShareUrl({
            size: size,
            start: start
        }, {
            showSupportPopup: true,
            toolName: TOOL_NAME
        });

        ToolUtils.copyToClipboard(shareUrl, {
            showToast: true,
            toastMessage: 'Share URL copied to clipboard!',
            showSupportPopup: false
        });
    });

    // ========== URL parameter support & init ==========
    document.addEventListener('DOMContentLoaded', function() {
        var loaded = ToolUtils.loadFromUrl({
            size: 'squareSize',
            start: 'startNumber'
        });

        // Validate size range
        if (loaded.size) {
            var sizeVal = parseInt(loaded.size);
            if (sizeVal < 3 || sizeVal > 9) {
                document.getElementById('squareSize').value = 3;
            }
        }

        updateMethodInfo();

        // Auto-generate if URL params provided
        if (loaded.size) {
            generateMagicSquare();
        }
    });

    // ========== HEATMAP ==========
    let heatmapActive = false;

    function heatmapColor(t) {
        var stops = [
            { t: 0, r: 59, g: 130, b: 246 },
            { t: 0.25, r: 6, g: 182, b: 212 },
            { t: 0.5, r: 16, g: 185, b: 129 },
            { t: 0.75, r: 234, g: 179, b: 8 },
            { t: 1, r: 239, g: 68, b: 68 }
        ];
        var i = 0;
        for (i = 0; i < stops.length - 1; i++) {
            if (t <= stops[i + 1].t) break;
        }
        var s0 = stops[i], s1 = stops[Math.min(i + 1, stops.length - 1)];
        var localT = (s1.t === s0.t) ? 0 : (t - s0.t) / (s1.t - s0.t);
        var r = Math.round(s0.r + (s1.r - s0.r) * localT);
        var g = Math.round(s0.g + (s1.g - s0.g) * localT);
        var b = Math.round(s0.b + (s1.b - s0.b) * localT);
        return 'rgb(' + r + ',' + g + ',' + b + ')';
    }

    function applyHeatmap() {
        if (!currentSquare.length) return;
        var cells = document.querySelectorAll('.magic-square .square-cell');
        if (!cells.length) return;
        var min = Infinity, max = -Infinity;
        for (var i = 0; i < currentSize; i++) {
            for (var j = 0; j < currentSize; j++) {
                min = Math.min(min, currentSquare[i][j]);
                max = Math.max(max, currentSquare[i][j]);
            }
        }
        cells.forEach(function(cell) {
            var row = parseInt(cell.dataset.row);
            var col = parseInt(cell.dataset.col);
            var val = currentSquare[row][col];
            var t = (max === min) ? 0.5 : (val - min) / (max - min);
            cell.style.background = heatmapColor(t);
            cell.style.color = (t > 0.3 && t < 0.7) ? '#000' : '#fff';
            cell.classList.add('heatmap');
        });
        var container = document.querySelector('.magic-square-container');
        if (container && !document.getElementById('heatmapLegend')) {
            var legend = document.createElement('div');
            legend.id = 'heatmapLegend';
            legend.className = 'heatmap-legend';
            legend.innerHTML = '<span class="heatmap-label">' + min + '</span>'
                + '<div class="heatmap-bar"></div>'
                + '<span class="heatmap-label">' + max + '</span>';
            container.parentNode.insertBefore(legend, container.nextSibling);
        }
    }

    function removeHeatmap() {
        document.querySelectorAll('.magic-square .square-cell').forEach(function(cell) {
            cell.style.background = '';
            cell.style.color = '';
            cell.classList.remove('heatmap');
        });
        var legend = document.getElementById('heatmapLegend');
        if (legend) legend.remove();
    }

    function toggleHeatmap() {
        heatmapActive = !heatmapActive;
        var btn = document.getElementById('heatmapToggleBtn');
        if (btn) {
            btn.classList.toggle('active', heatmapActive);
            btn.textContent = heatmapActive ? 'Heatmap ON' : 'Heatmap';
        }
        if (heatmapActive) {
            applyHeatmap();
        } else {
            removeHeatmap();
        }
    }

    // ========== PRINT WORKSHEET ==========
    function printWorksheet() {
        // Determine data source: generated square or checker result
        var grid = null;
        var n = 0;
        var mc = 0;
        var subtitle = '';

        if (currentSquare.length) {
            grid = currentSquare;
            n = currentSize;
            mc = magicConstant;
            var method = document.getElementById('method').value;
            var methodNames = { siamese: 'Siamese Method', strachey: 'Strachey Method', conway: 'Conway LUX Method' };
            subtitle = 'Construction Method: ' + (methodNames[method] || method);
        } else if (lastCheckResult && lastCheckResult.grid) {
            grid = lastCheckResult.grid;
            n = grid.length;
            mc = lastCheckResult.magicConstant;
            subtitle = lastCheckResult.valid ? 'Verified: Valid Magic Square' : 'Verified: Not a Magic Square';
        }

        if (!grid) {
            ToolUtils.showToast('Generate or check a square first', 2000, 'warning');
            return;
        }

        var tableHtml = '<table class="print-grid">';
        for (var i = 0; i < n; i++) {
            tableHtml += '<tr>';
            for (var j = 0; j < n; j++) {
                tableHtml += '<td>' + grid[i][j] + '</td>';
            }
            tableHtml += '</tr>';
        }
        tableHtml += '</table>';

        var exerciseHtml = '<div class="print-exercise">';
        exerciseHtml += '<h3 style="margin:0 0 0.75rem;font-size:1.1rem;">Verification Exercise</h3>';
        exerciseHtml += '<p style="margin-bottom:0.75rem;">Fill in the sums for each row, column, and diagonal. Do they all equal <strong>' + mc + '</strong>?</p>';
        for (var ri = 0; ri < n; ri++) {
            exerciseHtml += 'Row ' + (ri + 1) + ': <span class="print-exercise-blank"></span>&nbsp;&nbsp;';
            if ((ri + 1) % 4 === 0) exerciseHtml += '<br>';
        }
        exerciseHtml += '<br>';
        for (var ci = 0; ci < n; ci++) {
            exerciseHtml += 'Col ' + (ci + 1) + ': <span class="print-exercise-blank"></span>&nbsp;&nbsp;';
            if ((ci + 1) % 4 === 0) exerciseHtml += '<br>';
        }
        exerciseHtml += '<br>Main diagonal: <span class="print-exercise-blank"></span>&nbsp;&nbsp;';
        exerciseHtml += 'Anti-diagonal: <span class="print-exercise-blank"></span>';
        exerciseHtml += '</div>';

        var printArea = document.createElement('div');
        printArea.id = 'printArea';
        printArea.innerHTML = '<div class="print-title">Magic Square Worksheet</div>'
            + '<div class="print-info">Size: ' + n + 'x' + n + ' &nbsp;|&nbsp; Magic Constant: ' + mc + '</div>'
            + tableHtml
            + exerciseHtml
            + '<div class="print-footer">' + subtitle + '<br>Generated by 8gwifi.org</div>';

        document.body.appendChild(printArea);
        window.print();
        setTimeout(function() { printArea.remove(); }, 1000);
    }

    // ========== CHECKER ==========
    let checkerSize = 5;
    let lastCheckResult = null;

    function buildCheckerGrid(n) {
        if (!n) n = parseInt(document.getElementById('checkerSize').value);
        checkerSize = n;
        var container = document.getElementById('checkerGridContainer');
        var html = '<div class="checker-grid" style="grid-template-columns: repeat(' + n + ', 1fr);">';
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n; j++) {
                html += '<input type="number" class="checker-input" id="ci_' + i + '_' + j + '" data-row="' + i + '" data-col="' + j + '">';
            }
        }
        html += '</div>';
        container.innerHTML = html;

        // Show checker action buttons
        document.getElementById('checkerActions').style.display = 'flex';

        // Add keyboard navigation
        container.querySelectorAll('.checker-input').forEach(function(inp) {
            inp.addEventListener('keydown', function(e) {
                var r = parseInt(this.dataset.row);
                var c = parseInt(this.dataset.col);
                var nr = r, nc = c;
                if (e.key === 'ArrowUp') nr = Math.max(0, r - 1);
                else if (e.key === 'ArrowDown') nr = Math.min(n - 1, r + 1);
                else if (e.key === 'ArrowLeft') nc = Math.max(0, c - 1);
                else if (e.key === 'ArrowRight') nc = Math.min(n - 1, c + 1);
                else return;
                e.preventDefault();
                var target = document.getElementById('ci_' + nr + '_' + nc);
                if (target) target.focus();
            });
        });
    }

    function checkMagicSquare() {
        var n = checkerSize;
        var grid = [];
        var hasEmpty = false;

        for (var i = 0; i < n; i++) {
            grid[i] = [];
            for (var j = 0; j < n; j++) {
                var inp = document.getElementById('ci_' + i + '_' + j);
                var val = inp ? parseInt(inp.value) : NaN;
                if (isNaN(val)) hasEmpty = true;
                grid[i][j] = isNaN(val) ? 0 : val;
            }
        }

        if (hasEmpty) {
            ToolUtils.showToast('Please fill in all cells', 2000, 'warning');
            return;
        }

        var expectedConstant = grid[0].reduce(function(a, b) { return a + b; }, 0);
        var rowSums = [], colSums = [];
        var failedRows = [], failedCols = [], failedDiags = [];

        for (var ri = 0; ri < n; ri++) {
            rowSums[ri] = grid[ri].reduce(function(a, b) { return a + b; }, 0);
            if (rowSums[ri] !== expectedConstant) failedRows.push(ri);
        }

        for (var cj = 0; cj < n; cj++) {
            var colSum = 0;
            for (var ci = 0; ci < n; ci++) colSum += grid[ci][cj];
            colSums[cj] = colSum;
            if (colSum !== expectedConstant) failedCols.push(cj);
        }

        var mainDiagSum = 0, antiDiagSum = 0;
        for (var di = 0; di < n; di++) {
            mainDiagSum += grid[di][di];
            antiDiagSum += grid[di][n - 1 - di];
        }
        if (mainDiagSum !== expectedConstant) failedDiags.push('main');
        if (antiDiagSum !== expectedConstant) failedDiags.push('anti');

        var valid = failedRows.length === 0 && failedCols.length === 0 && failedDiags.length === 0;

        displayCheckResult({
            valid: valid,
            magicConstant: expectedConstant,
            grid: grid,
            rowSums: rowSums,
            colSums: colSums,
            mainDiagSum: mainDiagSum,
            antiDiagSum: antiDiagSum,
            failedRows: failedRows,
            failedCols: failedCols,
            failedDiags: failedDiags
        });
    }

    function displayCheckResult(result) {
        lastCheckResult = result;
        var displaySection = document.getElementById('displaySection');
        var n = result.grid.length;

        var html = '<div style="text-align:center;margin-bottom:1rem;"><strong>Expected Magic Constant (Row 1 sum): ' + result.magicConstant + '</strong></div>';

        html += '<div style="overflow-x:auto;"><table style="border-collapse:separate;border-spacing:3px;margin:0 auto;">';
        for (var i = 0; i < n; i++) {
            html += '<tr>';
            var rowFailed = result.failedRows.indexOf(i) !== -1;
            for (var j = 0; j < n; j++) {
                var colFailed = result.failedCols.indexOf(j) !== -1;
                var cls = (rowFailed || colFailed) ? 'invalid' : 'valid';
                html += '<td class="checker-input ' + cls + '" style="width:50px;height:50px;text-align:center;font-size:1.2rem;font-weight:600;padding:4px;">'
                    + result.grid[i][j] + '</td>';
            }
            var rowCls = rowFailed ? 'incorrect' : 'correct';
            html += '<td style="padding-left:8px;"><span class="sum-label ' + rowCls + '">' + result.rowSums[i] + '</span></td>';
            html += '</tr>';
        }

        html += '<tr>';
        for (var cj = 0; cj < n; cj++) {
            var colCls2 = result.failedCols.indexOf(cj) !== -1 ? 'incorrect' : 'correct';
            html += '<td style="padding-top:8px;text-align:center;"><span class="sum-label ' + colCls2 + '">' + result.colSums[cj] + '</span></td>';
        }
        html += '<td></td></tr>';
        html += '</table></div>';

        html += '<div style="display:flex;justify-content:center;gap:1.5rem;margin-top:0.75rem;">';
        var mainCls = result.failedDiags.indexOf('main') !== -1 ? 'incorrect' : 'correct';
        var antiCls = result.failedDiags.indexOf('anti') !== -1 ? 'incorrect' : 'correct';
        html += '<span class="sum-label ' + mainCls + '">Main diag: ' + result.mainDiagSum + '</span>';
        html += '<span class="sum-label ' + antiCls + '">Anti diag: ' + result.antiDiagSum + '</span>';
        html += '</div>';

        if (result.valid) {
            html += '<div class="checker-verdict valid">Valid Magic Square!</div>';
            ToolUtils.showToast('Valid Magic Square!', 2000, 'success');
        } else {
            var issues = [];
            if (result.failedRows.length) issues.push(result.failedRows.length + ' row' + (result.failedRows.length > 1 ? 's' : ''));
            if (result.failedCols.length) issues.push(result.failedCols.length + ' column' + (result.failedCols.length > 1 ? 's' : ''));
            if (result.failedDiags.length) issues.push(result.failedDiags.length + ' diagonal' + (result.failedDiags.length > 1 ? 's' : ''));
            html += '<div class="checker-verdict invalid">Not a Magic Square &mdash; ' + issues.join(' and ') + ' have incorrect sums</div>';
        }

        displaySection.innerHTML = html;
        document.getElementById('resultActions').classList.add('visible');
    }

    function autoFillChecker() {
        var n = checkerSize;
        var container = document.getElementById('checkerGridContainer');
        if (!container.querySelector('.checker-input')) {
            buildCheckerGrid(n);
        }
        var sq;
        if (n % 2 === 1) {
            sq = generateSiameseSquare(n, 1);
        } else if (n % 4 === 0) {
            sq = generateDoublyEvenSquare(n, 1);
        } else {
            sq = generateSinglyEvenSquare(n, 1);
        }
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n; j++) {
                var inp = document.getElementById('ci_' + i + '_' + j);
                if (inp) inp.value = sq[i][j];
            }
        }
        ToolUtils.showToast('Grid filled with a valid magic square', 2000, 'success');
    }

    function clearChecker() {
        var n = checkerSize;
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n; j++) {
                var inp = document.getElementById('ci_' + i + '_' + j);
                if (inp) inp.value = '';
            }
        }
    }

    // ========== ANIMATION ==========
    var animState = {
        isRunning: false,
        isPaused: false,
        speed: 400,
        stepNum: 0,
        grid: [],
        stepLog: [],
        stepResolve: null
    };

    function sleep(ms) {
        return new Promise(function(resolve) { setTimeout(resolve, ms); });
    }

    function updateSpeedLabel() {
        var val = parseInt(document.getElementById('animSpeed').value);
        var label = val <= 150 ? 'Fast' : val <= 500 ? 'Medium' : 'Slow';
        document.getElementById('speedLabel').textContent = label + ' (' + val + 'ms)';
        animState.speed = val;
    }

    function displayAnimGrid(n) {
        var displaySection = document.getElementById('displaySection');
        var html = '<div class="magic-square-container">';
        html += '<div class="magic-square size-' + n + '" id="animGrid" style="grid-template-columns: repeat(' + n + ', 1fr);">';
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n; j++) {
                html += '<div class="square-cell anim-empty" id="ac_' + i + '_' + j + '" data-row="' + i + '" data-col="' + j + '"><span></span></div>';
            }
        }
        html += '</div></div>';
        html += '<div id="animStepDesc" class="pattern-indicator" style="min-height:1.5em;"></div>';
        html += '<div id="animStepLog" class="step-log"></div>';
        displaySection.innerHTML = html;
        document.getElementById('resultActions').classList.remove('visible');
    }

    function updateAnimCell(row, col, value, className) {
        var cell = document.getElementById('ac_' + row + '_' + col);
        if (!cell) return;
        cell.querySelector('span').textContent = value;
        cell.className = 'square-cell ' + (className || '');
    }

    function addStepLog(text) {
        var log = document.getElementById('animStepLog');
        var desc = document.getElementById('animStepDesc');
        if (desc) desc.textContent = text;
        if (log) {
            log.querySelectorAll('.current').forEach(function(el) { el.classList.remove('current'); });
            var entry = document.createElement('div');
            entry.className = 'step-log-entry current';
            entry.textContent = text;
            log.appendChild(entry);
            log.scrollTop = log.scrollHeight;
        }
        animState.stepLog.push(text);
    }

    async function animateSiamese(n, start) {
        animState.grid = Array(n).fill(null).map(function() { return Array(n).fill(0); });
        displayAnimGrid(n);

        var row = 0, col = Math.floor(n / 2);

        for (var num = start; num < start + n * n; num++) {
            while (animState.isPaused) {
                await sleep(100);
                if (!animState.isRunning) return;
            }
            if (!animState.isRunning) return;

            if (animState.stepResolve === 'waiting') {
                await new Promise(function(resolve) { animState.stepResolve = resolve; });
                if (!animState.isRunning) return;
            }

            animState.stepNum++;
            animState.grid[row][col] = num;

            document.querySelectorAll('#animGrid .anim-current').forEach(function(c) {
                c.classList.remove('anim-current');
                c.classList.add('anim-previous');
            });

            updateAnimCell(row, col, num, 'anim-current build-animate');

            var newRow = (row - 1 + n) % n;
            var newCol = (col + 1) % n;
            var moveDesc;

            if (num < start + n * n - 1) {
                if (animState.grid[newRow][newCol] !== 0) {
                    moveDesc = 'Step ' + animState.stepNum + ': Place ' + num + ' at (' + row + ',' + col + '). Blocked! Moving down.';
                    var blockCell = document.getElementById('ac_' + newRow + '_' + newCol);
                    if (blockCell) {
                        blockCell.style.boxShadow = '0 0 10px rgba(239,68,68,0.6)';
                        setTimeout(function() { blockCell.style.boxShadow = ''; }, 300);
                    }
                    row = (row + 1) % n;
                } else {
                    moveDesc = 'Step ' + animState.stepNum + ': Place ' + num + ' at (' + row + ',' + col + '). Move up-right.';
                    row = newRow;
                    col = newCol;
                }
            } else {
                moveDesc = 'Step ' + animState.stepNum + ': Place ' + num + ' at (' + row + ',' + col + '). Done!';
            }

            addStepLog(moveDesc);
            await sleep(animState.speed);
        }

        if (animState.isRunning) {
            addStepLog('Animation complete!');
            ToolUtils.showToast('Animation complete!', 2000, 'success');
            animState.isRunning = false;
            updatePlaybackButtons();
        }
    }

    async function animateDoublyEven(n, start) {
        animState.grid = Array(n).fill(null).map(function() { return Array(n).fill(0); });
        displayAnimGrid(n);

        addStepLog('Phase 1: Fill grid sequentially...');

        var num = start;
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n; j++) {
                while (animState.isPaused) {
                    await sleep(100);
                    if (!animState.isRunning) return;
                }
                if (!animState.isRunning) return;

                if (animState.stepResolve === 'waiting') {
                    await new Promise(function(resolve) { animState.stepResolve = resolve; });
                    if (!animState.isRunning) return;
                }

                animState.grid[i][j] = num;
                document.querySelectorAll('#animGrid .anim-current').forEach(function(c) {
                    c.classList.remove('anim-current');
                    c.classList.add('anim-previous');
                });
                updateAnimCell(i, j, num, 'anim-current');
                animState.stepNum++;
                num++;
                await sleep(Math.max(animState.speed / 4, 30));
            }
        }

        addStepLog('Phase 2: Swap diagonal elements...');
        await sleep(animState.speed);

        document.querySelectorAll('#animGrid .square-cell').forEach(function(c) {
            c.className = 'square-cell anim-previous';
        });

        for (var si = 0; si < n; si++) {
            for (var sj = 0; sj < n; sj++) {
                var inMainDiag = (si % 4 === sj % 4);
                var inAntiDiag = ((si % 4) + (sj % 4) === 3);

                if (inMainDiag || inAntiDiag) {
                    while (animState.isPaused) {
                        await sleep(100);
                        if (!animState.isRunning) return;
                    }
                    if (!animState.isRunning) return;

                    if (animState.stepResolve === 'waiting') {
                        await new Promise(function(resolve) { animState.stepResolve = resolve; });
                        if (!animState.isRunning) return;
                    }

                    var oldVal = animState.grid[si][sj];
                    var newVal = start + (n * n - 1) - (oldVal - start);
                    animState.grid[si][sj] = newVal;
                    animState.stepNum++;

                    updateAnimCell(si, sj, newVal, 'anim-current build-animate');
                    addStepLog('Step ' + animState.stepNum + ': Swap (' + si + ',' + sj + ') ' + oldVal + ' \u2192 ' + newVal);

                    await sleep(animState.speed / 2);

                    var swapCell = document.getElementById('ac_' + si + '_' + sj);
                    if (swapCell) swapCell.classList.remove('anim-current');
                }
            }
        }

        if (animState.isRunning) {
            addStepLog('Animation complete!');
            ToolUtils.showToast('Animation complete!', 2000, 'success');
            animState.isRunning = false;
            updatePlaybackButtons();
        }
    }

    async function animateSinglyEven(n, start) {
        animState.grid = Array(n).fill(null).map(function() { return Array(n).fill(0); });
        displayAnimGrid(n);

        var half = n / 2;
        addStepLog('Building ' + n + 'x' + n + ' from four ' + half + 'x' + half + ' sub-squares...');

        var subSquare = generateSiameseSquare(half, 0);
        var offsets = [0, 2 * half * half, 3 * half * half, half * half];
        var positions = [[0, 0], [0, half], [half, 0], [half, half]];
        var quadNames = ['Top-Left (A)', 'Top-Right (B)', 'Bottom-Left (C)', 'Bottom-Right (D)'];

        for (var q = 0; q < 4; q++) {
            addStepLog('Filling quadrant: ' + quadNames[q]);
            await sleep(animState.speed);

            for (var qi = 0; qi < half; qi++) {
                for (var qj = 0; qj < half; qj++) {
                    while (animState.isPaused) {
                        await sleep(100);
                        if (!animState.isRunning) return;
                    }
                    if (!animState.isRunning) return;

                    if (animState.stepResolve === 'waiting') {
                        await new Promise(function(resolve) { animState.stepResolve = resolve; });
                        if (!animState.isRunning) return;
                    }

                    var r = positions[q][0] + qi;
                    var c = positions[q][1] + qj;
                    var val = subSquare[qi][qj] * 4 + offsets[q] + start;
                    animState.grid[r][c] = val;
                    animState.stepNum++;

                    document.querySelectorAll('#animGrid .anim-current').forEach(function(cell) {
                        cell.classList.remove('anim-current');
                        cell.classList.add('anim-previous');
                    });

                    updateAnimCell(r, c, val, 'anim-current build-animate');
                    await sleep(Math.max(animState.speed / 3, 40));
                }
            }
        }

        if (animState.isRunning) {
            addStepLog('Animation complete!');
            ToolUtils.showToast('Animation complete!', 2000, 'success');
            animState.isRunning = false;
            updatePlaybackButtons();
        }
    }

    function updatePlaybackButtons() {
        var playBtn = document.getElementById('animPlayBtn');
        var pauseBtn = document.getElementById('animPauseBtn');
        if (playBtn) playBtn.disabled = animState.isRunning && !animState.isPaused;
        if (pauseBtn) pauseBtn.disabled = !animState.isRunning || animState.isPaused;
    }

    function startAnimation() {
        // If already running but paused, just resume
        if (animState.isRunning && animState.isPaused) {
            resumeAnimation();
            return;
        }

        var n = parseInt(document.getElementById('animSize').value);
        var start = parseInt(document.getElementById('startNumber').value) || 1;

        animState.isRunning = true;
        animState.isPaused = false;
        animState.stepNum = 0;
        animState.stepLog = [];
        animState.stepResolve = null;
        animState.speed = parseInt(document.getElementById('animSpeed').value) || 400;

        updatePlaybackButtons();

        if (n % 2 === 1) {
            animateSiamese(n, start);
        } else if (n % 4 === 0) {
            animateDoublyEven(n, start);
        } else {
            animateSinglyEven(n, start);
        }
    }

    function pauseAnimation() {
        animState.isPaused = true;
        updatePlaybackButtons();
    }

    function resumeAnimation() {
        animState.isPaused = false;
        updatePlaybackButtons();
    }

    function stepAnimation() {
        if (!animState.isRunning) {
            startAnimation();
            animState.isPaused = true;
            setTimeout(function() {
                animState.stepResolve = 'waiting';
            }, 50);
            return;
        }

        if (animState.stepResolve && typeof animState.stepResolve === 'function') {
            var resolve = animState.stepResolve;
            animState.stepResolve = 'waiting';
            animState.isPaused = false;
            resolve();
            setTimeout(function() {
                animState.isPaused = true;
                animState.stepResolve = 'waiting';
                updatePlaybackButtons();
            }, animState.speed + 50);
        } else {
            animState.stepResolve = 'waiting';
            animState.isPaused = false;
            setTimeout(function() {
                animState.isPaused = true;
                updatePlaybackButtons();
            }, animState.speed + 50);
        }
    }

    function resetAnimation() {
        animState.isRunning = false;
        animState.isPaused = false;
        animState.stepNum = 0;
        animState.stepLog = [];
        if (animState.stepResolve && typeof animState.stepResolve === 'function') {
            animState.stepResolve();
        }
        animState.stepResolve = null;

        var n = parseInt(document.getElementById('animSize').value);
        displayAnimGrid(n);
        updatePlaybackButtons();
    }
    </script>
</body>
</html>
