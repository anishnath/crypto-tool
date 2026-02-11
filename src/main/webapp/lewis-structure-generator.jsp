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
            --tool-primary:#667eea;--tool-primary-dark:#5a67d8;--tool-gradient:linear-gradient(135deg,#667eea 0%,#5a67d8 100%);--tool-light:#f0f4ff
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(99,102,241,0.15)}
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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(99,102,241,0.3)}

        /* Utility */
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Lewis Structure Generator & VSEPR Calculator | 8gwifi.org" />
        <jsp:param name="toolDescription" value="Free Lewis Structure Generator with VSEPR theory, molecular geometry, bond angles, and polarity predictions. Draw Lewis dot structures, calculate formal charges, and visualize 3D molecular shapes." />
        <jsp:param name="toolCategory" value="Chemistry" />
        <jsp:param name="toolUrl" value="lewis-structure-generator.jsp" />
        <jsp:param name="toolKeywords" value="lewis structure, lewis dot structure, vsepr theory, molecular geometry, electron geometry, bond angles, formal charge calculator, octet rule, valence electrons, molecular shape, polarity" />
        <jsp:param name="toolImage" value="lewis-structure-og.png" />
        <jsp:param name="toolFeatures" value="Lewis structure generation,VSEPR geometry prediction,Formal charge calculation,Bond angle determination,Molecular polarity analysis,Interactive molecular visualization,Electron domain geometry,Octet rule validation" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a Lewis structure?" />
        <jsp:param name="faq1a" value="A Lewis structure (or Lewis dot diagram) is a representation of a molecule showing all valence electrons as dots or lines (bonds). It helps visualize bonding patterns, lone pairs, and formal charges in molecules." />
        <jsp:param name="faq2q" value="What is VSEPR theory?" />
        <jsp:param name="faq2a" value="VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on electron pair repulsion. Electron domains (bonds and lone pairs) arrange themselves to minimize repulsion, determining the 3D shape of molecules." />
        <jsp:param name="faq3q" value="How do you calculate formal charge?" />
        <jsp:param name="faq3a" value="Formal charge = (Valence electrons) - (Non-bonding electrons) - (Bonding electrons/2). The most stable Lewis structure has formal charges closest to zero, with negative charges on more electronegative atoms." />
    </jsp:include>

    <!-- OG, Twitter, canonical, JSON-LD all handled by seo-tool-page.jsp above -->

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

    <!-- jQuery not needed - page uses vanilla JS, tool-utils.js has vanilla fallbacks -->

    <style>
        /* Lewis Structure Tool - Minimal overrides on three-column-tool.css */
        :root {
            --tool-primary: #667eea;
            --tool-primary-dark: #5a67d8;
        }

        /* Labels - distinct from inputs */
        .tool-label {
            display: block;
            font-weight: 600;
            font-size: 0.8125rem;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.375rem;
            letter-spacing: 0.01em;
        }

        /* Hint text below inputs */
        .tool-hint {
            font-size: 0.6875rem;
            color: var(--text-secondary, #64748b);
            margin: 0.25rem 0 0 0;
            line-height: 1.4;
        }

        /* Input fields - clear visual separation from labels */
        .tool-input {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-family: 'JetBrains Mono', 'SF Mono', monospace;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .tool-input:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        }

        .tool-input::placeholder {
            color: #94a3b8;
            font-family: 'Inter', sans-serif;
            font-style: italic;
            font-size: 0.8125rem;
        }

        [data-theme="dark"] .tool-label {
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .tool-hint {
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .tool-input {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .tool-input:focus {
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.25);
        }

        [data-theme="dark"] .tool-input::placeholder {
            color: #64748b;
        }

        /* Form group spacing */
        .tool-form-group {
            margin-bottom: 1rem;
        }

        .tool-form-actions {
            margin-top: 1.25rem;
        }

        /* Form sections visibility toggle */
        .tool-form-section { display: none; padding: 1.25rem; }
        .tool-form-section.active { display: block; }

        /* Quick example pills */
        .lewis-example-pill {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            margin: 0.2rem;
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 1rem;
            cursor: pointer;
            font-size: 0.8125rem;
            font-weight: 500;
            color: var(--text-primary, #0f172a);
            transition: all 0.2s;
        }

        .lewis-example-pill:hover {
            background: var(--tool-primary);
            color: white;
            border-color: var(--tool-primary);
            transform: translateY(-1px);
        }

        .lewis-example-pill.generic {
            border-color: #f59e0b;
            color: #b45309;
        }

        .lewis-example-pill.generic:hover {
            background: #f59e0b;
            color: white;
            border-color: #f59e0b;
        }

        [data-theme="dark"] .lewis-example-pill {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary);
        }

        [data-theme="dark"] .lewis-example-pill:hover {
            background: var(--tool-primary);
            color: white;
        }

        [data-theme="dark"] .lewis-example-pill.generic {
            border-color: rgba(245, 158, 11, 0.5);
            color: #fbbf24;
        }

        /* p5.js canvas wrapper */
        .lewis-canvas-wrapper {
            width: 100%;
            min-height: 320px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-primary, #fff);
            border: 2px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .lewis-canvas-wrapper canvas {
            display: block;
            max-width: 100%;
            height: auto;
        }

        [data-theme="dark"] .lewis-canvas-wrapper {
            background: #1e293b;
            border-color: rgba(255,255,255,0.1);
        }

        /* Molecule heading banner (shown above results) */
        .lewis-molecule-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, rgba(102,126,234,0.08), rgba(118,75,226,0.08));
            border: 1px solid rgba(102,126,234,0.2);
            border-radius: 0.625rem;
        }

        .lewis-molecule-header .lewis-formula {
            font-family: 'JetBrains Mono', 'SF Mono', monospace;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--tool-primary);
            letter-spacing: 0.02em;
        }

        .lewis-molecule-header .lewis-formula sub {
            font-size: 0.7em;
            vertical-align: baseline;
            position: relative;
            bottom: -0.2em;
            color: var(--tool-primary-dark, #5a67d8);
        }

        .lewis-molecule-header .lewis-formula sup {
            font-size: 0.6em;
            vertical-align: baseline;
            position: relative;
            top: -0.55em;
            color: var(--text-secondary, #64748b);
        }

        .lewis-molecule-header .lewis-molecule-meta {
            font-size: 0.8rem;
            color: var(--text-secondary, #64748b);
            line-height: 1.4;
        }

        [data-theme="dark"] .lewis-molecule-header {
            background: linear-gradient(135deg, rgba(102,126,234,0.12), rgba(118,75,226,0.10));
            border-color: rgba(102,126,234,0.25);
        }

        /* Info grid for result cards */
        .lewis-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .lewis-info-card {
            padding: 0.75rem 0.625rem;
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0.5rem;
            border-left: 3px solid var(--tool-primary);
            text-align: center;
            transition: transform 0.15s, box-shadow 0.15s;
        }

        .lewis-info-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(102,126,234,0.12);
        }

        .lewis-info-card strong {
            display: block;
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-secondary, #64748b);
            margin-bottom: 0.3rem;
        }

        .lewis-info-card span {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--tool-primary);
        }

        [data-theme="dark"] .lewis-info-card {
            background: rgba(255,255,255,0.05);
        }

        /* Geometry / chemistry badge */
        .lewis-badge {
            display: inline-block;
            padding: 0.375rem 0.85rem;
            background: linear-gradient(135deg, var(--tool-primary), var(--tool-primary-dark));
            color: white;
            border-radius: 1.5rem;
            font-weight: 600;
            font-size: 0.875rem;
            margin: 0.15rem;
            letter-spacing: 0.02em;
            box-shadow: 0 1px 4px rgba(102,126,234,0.25);
        }

        .lewis-badge.polar { background: linear-gradient(135deg, #ef4444, #dc2626); box-shadow: 0 1px 4px rgba(239,68,68,0.25); }
        .lewis-badge.nonpolar { background: linear-gradient(135deg, #22c55e, #16a34a); box-shadow: 0 1px 4px rgba(34,197,94,0.25); }

        /* Inline formula styling (anywhere in results) */
        .lewis-chem {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            letter-spacing: 0.01em;
        }

        .lewis-chem sub {
            font-size: 0.75em;
            vertical-align: baseline;
            position: relative;
            bottom: -0.15em;
            color: var(--tool-primary);
        }

        .lewis-chem sup {
            font-size: 0.65em;
            vertical-align: baseline;
            position: relative;
            top: -0.5em;
            color: var(--text-secondary, #64748b);
        }

        [data-theme="dark"] .lewis-chem {
            color: var(--text-primary, #e2e8f0);
        }

        /* Result value block */
        .lewis-result-value {
            padding: 0.625rem 0.875rem;
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0.375rem;
            border-left: 3px solid var(--tool-primary);
            font-size: 0.9375rem;
            margin-bottom: 0.75rem;
            color: var(--text-primary);
        }

        .lewis-result-value pre {
            margin: 0;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8125rem;
            white-space: pre;
        }

        [data-theme="dark"] .lewis-result-value {
            background: rgba(255,255,255,0.05);
        }

        /* Result label */
        .lewis-result-label {
            font-weight: 600;
            font-size: 0.75rem;
            color: var(--text-secondary, #64748b);
            margin-bottom: 0.375rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .lewis-result-label::before {
            content: '';
            display: inline-block;
            width: 6px;
            height: 6px;
            background: var(--tool-primary);
            border-radius: 50%;
            margin-right: 0.4rem;
            vertical-align: middle;
        }

        /* Formal charge table */
        .lewis-fc-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0.75rem 0;
            font-size: 0.875rem;
        }

        .lewis-fc-table td {
            padding: 0.5rem 0.75rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }

        .lewis-fc-table td:first-child { font-weight: 600; }

        /* Alert box */
        .lewis-alert {
            padding: 0.75rem 1rem;
            background: #dbeafe;
            border-radius: 0.5rem;
            font-size: 0.8125rem;
            color: #1e40af;
            margin-top: 0.75rem;
        }

        .lewis-alert strong { display: block; margin-bottom: 0.25rem; }

        .lewis-alert ol {
            margin: 0.25rem 0 0 1.25rem;
            padding: 0;
        }

        [data-theme="dark"] .lewis-alert {
            background: rgba(59, 130, 246, 0.15);
            color: #93c5fd;
        }

        .lewis-alert-warning {
            background: #fef3c7;
            color: #92400e;
        }

        [data-theme="dark"] .lewis-alert-warning {
            background: rgba(251, 191, 36, 0.15);
            color: #fcd34d;
        }

        /* Formal charge big number */
        .lewis-fc-result {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            padding: 0.75rem;
            border-radius: 0.5rem;
            margin: 0.75rem 0;
        }

        .lewis-fc-result.neutral { color: #22c55e; background: rgba(34,197,94,0.1); }
        .lewis-fc-result.positive { color: #ef4444; background: rgba(239,68,68,0.1); }
        .lewis-fc-result.negative { color: #3b82f6; background: rgba(59,130,246,0.1); }

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

        /* Tool result card */
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

        /* Responsive */
        @media (max-width: 768px) {
            .lewis-info-grid { grid-template-columns: repeat(2, 1fr); }

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
                <h1 class="tool-page-title">Lewis Structure Generator & VSEPR Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/chemical-equation-balancer.jsp">Chemistry</a> /
                    Lewis Structure Generator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Lewis Dot Diagrams</span>
                <span class="tool-badge">VSEPR Theory</span>
                <span class="tool-badge">Molecular Visualization</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate Lewis dot structures, predict molecular geometry using VSEPR theory, calculate bond angles, and analyze molecular polarity. Visualize molecular structures with interactive diagrams.</p>
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
                    <button type="button" class="tool-tab active" data-tab="lewis" role="tab">
                        <span>&#9883;</span> Lewis Structure
                    </button>
                    <button type="button" class="tool-tab" data-tab="vsepr" role="tab">
                        <span>&#11042;</span> VSEPR Predictor
                    </button>
                    <button type="button" class="tool-tab" data-tab="formal" role="tab">
                        <span>&#9874;</span> Formal Charge
                    </button>
                </div>

                <!-- ========== Tab 1: Lewis Structure ========== -->
                <div id="lewisSection" class="tool-form-section active">
                    <div class="tool-form-group">
                        <label class="tool-label">Molecular Formula</label>
                        <input type="text" class="tool-input" id="molecularFormula" placeholder="e.g., H2O, CO2, NH3, or ML2 (generic)">
                        <p class="tool-hint" style="margin-top:0.25rem;">Enter formula like H2O, CO2, NH3, or generic notation (ML2, AX3, MX4)</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Quick Examples</label>
                        <div style="margin-top:0.25rem;">
                            <span class="lewis-example-pill" data-formula="H2O">H&#8322;O</span>
                            <span class="lewis-example-pill" data-formula="CO2">CO&#8322;</span>
                            <span class="lewis-example-pill" data-formula="NH3">NH&#8323;</span>
                            <span class="lewis-example-pill" data-formula="CH4">CH&#8324;</span>
                            <span class="lewis-example-pill" data-formula="O2">O&#8322;</span>
                            <span class="lewis-example-pill" data-formula="N2">N&#8322;</span>
                            <span class="lewis-example-pill" data-formula="SO2">SO&#8322;</span>
                            <span class="lewis-example-pill" data-formula="HCN">HCN</span>
                            <span class="lewis-example-pill" data-formula="CCl4">CCl&#8324;</span>
                            <span class="lewis-example-pill" data-formula="F2">F&#8322;</span>
                            <span class="lewis-example-pill" data-formula="O3">O&#8323;</span>
                            <span class="lewis-example-pill" data-formula="N2O">N&#8322;O</span>
                            <span class="lewis-example-pill" data-formula="NO2">NO&#8322;</span>
                            <span class="lewis-example-pill" data-formula="PCl3">PCl&#8323;</span>
                            <span class="lewis-example-pill" data-formula="PCl5">PCl&#8325;</span>
                            <span class="lewis-example-pill" data-formula="SF6">SF&#8326;</span>
                            <span class="lewis-example-pill" data-formula="XeF2">XeF&#8322;</span>
                            <span class="lewis-example-pill" data-formula="C2H6">C&#8322;H&#8326;</span>
                            <span class="lewis-example-pill" data-formula="C2H3F3">C&#8322;H&#8323;F&#8323;</span>
                            <span class="lewis-example-pill" data-formula="C3H8">C&#8323;H&#8328;</span>
                            <span class="lewis-example-pill" data-formula="H2SO4">H&#8322;SO&#8324;</span>
                            <span class="lewis-example-pill generic" data-formula="ML2">ML&#8322;</span>
                            <span class="lewis-example-pill generic" data-formula="AX3">AX&#8323;</span>
                            <span class="lewis-example-pill generic" data-formula="MX4">MX&#8324;</span>
                        </div>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Charge (optional)</label>
                        <input type="number" class="tool-input" id="molecularCharge" value="0" placeholder="0" style="max-width:120px;">
                        <p class="tool-hint" style="margin-top:0.25rem;">For ions: +1 for NH&#8324;&#8314;, -1 for CN&#8315;, -2 for CO&#8323;&#178;&#8315;, -3 for PO&#8324;&#179;&#8315;</p>
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" id="generateLewisBtn">
                            &#9883; Generate Lewis Structure
                        </button>
                    </div>
                </div>

                <!-- ========== Tab 2: VSEPR Predictor ========== -->
                <div id="vseprSection" class="tool-form-section">
                    <div class="tool-form-group">
                        <label class="tool-label">Central Atom</label>
                        <input type="text" class="tool-input" id="centralAtom" placeholder="e.g., C, N, O, S" style="max-width:120px;">
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Bonding Electron Pairs (Bonds)</label>
                        <input type="number" class="tool-input" id="bondingPairs" min="1" max="7" value="4" style="max-width:120px;">
                        <p class="tool-hint" style="margin-top:0.25rem;">Count single, double, and triple bonds as 1 bonding region each</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Lone Electron Pairs</label>
                        <input type="number" class="tool-input" id="lonePairs" min="0" max="4" value="0" style="max-width:120px;">
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Quick VSEPR Examples</label>
                        <div style="margin-top:0.25rem;">
                            <span class="lewis-example-pill" data-vsepr="2,0">2B-0LP (Linear)</span>
                            <span class="lewis-example-pill" data-vsepr="3,0">3B-0LP (Trig. Planar)</span>
                            <span class="lewis-example-pill" data-vsepr="2,1">2B-1LP (Bent ~120&deg;)</span>
                            <span class="lewis-example-pill" data-vsepr="4,0">4B-0LP (Tetrahedral)</span>
                            <span class="lewis-example-pill" data-vsepr="3,1">3B-1LP (Trig. Pyramidal)</span>
                            <span class="lewis-example-pill" data-vsepr="2,2">2B-2LP (Bent ~104&deg;)</span>
                            <span class="lewis-example-pill" data-vsepr="5,0">5B-0LP (Trig. Bipyramidal)</span>
                            <span class="lewis-example-pill" data-vsepr="4,1">4B-1LP (Seesaw)</span>
                            <span class="lewis-example-pill" data-vsepr="3,2">3B-2LP (T-shaped)</span>
                            <span class="lewis-example-pill" data-vsepr="2,3">2B-3LP (Linear, XeF&#8322;)</span>
                            <span class="lewis-example-pill" data-vsepr="6,0">6B-0LP (Octahedral)</span>
                            <span class="lewis-example-pill" data-vsepr="5,1">5B-1LP (Square Pyramidal)</span>
                            <span class="lewis-example-pill" data-vsepr="4,2">4B-2LP (Square Planar)</span>
                            <span class="lewis-example-pill" data-vsepr="7,0">7B-0LP (Pent. Bipyramidal)</span>
                        </div>
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" id="predictVSEPRBtn">
                            &#11042; Predict Geometry
                        </button>
                    </div>
                </div>

                <!-- ========== Tab 3: Formal Charge ========== -->
                <div id="formalSection" class="tool-form-section">
                    <div class="lewis-alert" style="margin-bottom:1rem;">
                        <strong>Formula:</strong> Formal Charge = (Valence e&#8315;) - (Non-bonding e&#8315;) - (Bonding e&#8315; / 2)
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Atom</label>
                        <input type="text" class="tool-input" id="formalAtom" placeholder="e.g., C, N, O" style="max-width:120px;">
                        <p class="tool-hint" style="margin-top:0.25rem;">Type an element symbol &mdash; valence electrons auto-fill below</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Valence Electrons</label>
                        <input type="number" class="tool-input" id="formalValence" min="1" max="8" placeholder="auto-filled" style="max-width:120px;">
                        <p class="tool-hint" style="margin-top:0.25rem;">C=4, N=5, O=6, H=1 (auto-filled from atom above)</p>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Non-bonding Electrons (Lone Pairs x 2)</label>
                        <input type="number" class="tool-input" id="formalNonBonding" min="0" placeholder="Number of non-bonding electrons" style="max-width:120px;">
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-label">Bonding Electrons</label>
                        <input type="number" class="tool-input" id="formalBonding" min="0" placeholder="Single=2, Double=4, Triple=6" style="max-width:120px;">
                        <p class="tool-hint" style="margin-top:0.25rem;">Single bond = 2, Double = 4, Triple = 6</p>
                    </div>

                    <div class="tool-form-actions">
                        <button type="button" class="tool-action-btn" id="calcFormalBtn">
                            &#9874; Calculate Formal Charge
                        </button>
                    </div>
                </div>

                <!-- Learn content is in the below-the-fold educational sections -->
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <span>&#128203;</span>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="resultOutput">
                    <!-- Molecular diagram canvas -->
                    <div class="lewis-canvas-wrapper" id="lewisCanvasContainer">
                        <div class="tool-empty-state" id="emptyState">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;margin-bottom:0.75rem;opacity:0.4;">
                                <circle cx="12" cy="12" r="3"/>
                                <circle cx="4" cy="12" r="1.5"/>
                                <circle cx="20" cy="12" r="1.5"/>
                                <circle cx="12" cy="4" r="1.5"/>
                                <line x1="9" y1="12" x2="5.5" y2="12"/>
                                <line x1="14.5" y1="12" x2="18.5" y2="12"/>
                                <line x1="12" y1="9" x2="12" y2="5.5"/>
                            </svg>
                            <h3>Molecular Diagram</h3>
                            <p>Enter a molecular formula or set VSEPR parameters to visualize the structure.</p>
                        </div>
                    </div>

                    <!-- Text result area -->
                    <div id="resultDisplay"></div>
                </div>
                <div class="tool-result-actions" id="resultActions">
                    <button type="button" class="tool-action-btn" id="copyResultBtn">
                        <span>&#128203;</span> Copy
                    </button>
                    <button type="button" class="tool-action-btn" id="downloadPngBtn">
                        <span>&#8681;</span> Download PNG
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

    <!-- ========== EDUCATIONAL CONTENT (below-the-fold, SEO-visible) ========== -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

        <!-- Lewis Structures Guide -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">What Is a Lewis Structure?</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">A <strong>Lewis structure</strong> (also called a <strong>Lewis dot diagram</strong> or <strong>electron dot structure</strong>) is a 2D representation of a molecule that shows how valence electrons are arranged among the atoms. Invented by Gilbert N. Lewis in 1916, these diagrams are fundamental to understanding chemical bonding.</p>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">In a Lewis structure:</p>
            <ul style="margin-left: 1.5rem; color: var(--text-secondary); margin-bottom: 1rem;">
                <li style="margin-bottom: 0.4rem;"><strong>Lines</strong> represent <strong>covalent bonds</strong> (shared electron pairs) &mdash; a single line is a single bond (2 e&#8315;), a double line is a double bond (4 e&#8315;), and a triple line is a triple bond (6 e&#8315;)</li>
                <li style="margin-bottom: 0.4rem;"><strong>Dots</strong> represent <strong>lone pairs</strong> (non-bonding electrons) that belong to a single atom</li>
                <li style="margin-bottom: 0.4rem;">The <strong>octet rule</strong> states most atoms are stable with 8 electrons in their valence shell (hydrogen needs only 2)</li>
            </ul>

            <h3 style="font-size: 1.05rem; margin: 1.5rem 0 0.75rem;">How to Draw a Lewis Structure (Step-by-Step)</h3>
            <ol style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.6rem;"><strong>Count total valence electrons.</strong> Add up the valence electrons for every atom. For ions, add electrons for negative charges or subtract for positive charges. Example: H&#8322;O has 2(1) + 6 = 8 valence electrons.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Identify the central atom.</strong> The least electronegative atom goes in the center. Hydrogen and fluorine are always terminal (outer) atoms. Carbon is almost always central.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Draw single bonds</strong> from the central atom to each surrounding atom. Each bond uses 2 electrons.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Distribute remaining electrons as lone pairs.</strong> Give outer atoms full octets first (start with the most electronegative), then place leftover electrons on the central atom.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Form multiple bonds if needed.</strong> If the central atom has fewer than 8 electrons, convert lone pairs from adjacent atoms into double or triple bonds until the octet is satisfied.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Check formal charges.</strong> The best Lewis structure minimizes formal charges, places negative charges on more electronegative atoms, and avoids same-sign charges on adjacent atoms.</li>
            </ol>
        </div>

        <!-- Formal Charge Guide -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Understanding Formal Charge</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;"><strong>Formal charge (FC)</strong> is a bookkeeping tool that assigns an imaginary charge to each atom in a Lewis structure, assuming all bonding electrons are shared equally. It helps you determine which Lewis structure is the most stable representation of a molecule.</p>

            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 8px; padding: 1rem 1.25rem; margin-bottom: 1rem; text-align: center;">
                <p style="font-family: 'JetBrains Mono', monospace; font-size: 1.1rem; font-weight: 600; color: var(--text-primary);">
                    FC = (Valence e&#8315;) &minus; (Lone pair e&#8315;) &minus; (Bonding e&#8315; &divide; 2)
                </p>
            </div>

            <h3 style="font-size: 1.05rem; margin: 1.25rem 0 0.75rem;">Worked Examples</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem; margin-bottom: 1rem;">
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <p style="font-weight: 600; margin-bottom: 0.5rem;">Oxygen in H&#8322;O</p>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Valence e&#8315; = 6, Lone pair e&#8315; = 4, Bonding e&#8315; = 4</p>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">FC = 6 &minus; 4 &minus; (4&divide;2) = <strong>0</strong> (neutral, ideal)</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <p style="font-weight: 600; margin-bottom: 0.5rem;">Nitrogen in NH&#8324;&#8314;</p>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Valence e&#8315; = 5, Lone pair e&#8315; = 0, Bonding e&#8315; = 8</p>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">FC = 5 &minus; 0 &minus; (8&divide;2) = <strong>+1</strong> (matches ion charge)</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <p style="font-weight: 600; margin-bottom: 0.5rem;">Carbon in CO (carbon monoxide)</p>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Valence e&#8315; = 4, Lone pair e&#8315; = 2, Bonding e&#8315; = 6</p>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">FC = 4 &minus; 2 &minus; (6&divide;2) = <strong>&minus;1</strong></p>
                </div>
            </div>

            <h3 style="font-size: 1.05rem; margin: 1.25rem 0 0.75rem;">Rules for Choosing the Best Lewis Structure</h3>
            <ul style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.4rem;">The structure with formal charges <strong>closest to zero</strong> on all atoms is preferred</li>
                <li style="margin-bottom: 0.4rem;">Negative formal charges should reside on the <strong>more electronegative</strong> atoms (O, F, N)</li>
                <li style="margin-bottom: 0.4rem;">Avoid placing <strong>same-sign charges</strong> on adjacent atoms (like +1 next to +1)</li>
                <li style="margin-bottom: 0.4rem;">Minimize the <strong>total number</strong> of atoms with non-zero formal charges</li>
                <li style="margin-bottom: 0.4rem;">The sum of all formal charges must equal the overall <strong>molecular charge</strong></li>
            </ul>
        </div>

        <!-- VSEPR Theory Guide -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">VSEPR Theory &mdash; Predicting Molecular Shape</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;"><strong>VSEPR</strong> (Valence Shell Electron Pair Repulsion) theory predicts the three-dimensional shape of molecules based on one simple principle: <em>electron groups around a central atom arrange themselves as far apart as possible to minimize repulsion</em>.</p>

            <h3 style="font-size: 1.05rem; margin: 1.25rem 0 0.75rem;">Key Concepts</h3>
            <ul style="margin-left: 1.5rem; color: var(--text-secondary); margin-bottom: 1rem;">
                <li style="margin-bottom: 0.4rem;"><strong>Electron domains</strong> (or steric number) = bonding pairs + lone pairs around the central atom. A double or triple bond counts as <em>one</em> electron domain.</li>
                <li style="margin-bottom: 0.4rem;"><strong>Electron geometry</strong> describes the arrangement of <em>all</em> electron domains (bonds + lone pairs)</li>
                <li style="margin-bottom: 0.4rem;"><strong>Molecular geometry</strong> describes the arrangement of <em>only the atoms</em> (ignoring lone pairs)</li>
                <li style="margin-bottom: 0.4rem;"><strong>Lone pairs</strong> occupy more space than bonding pairs, compressing bond angles below ideal values</li>
            </ul>

            <h3 style="font-size: 1.05rem; margin: 1.25rem 0 0.75rem;">Complete VSEPR Geometry Table</h3>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; font-size: 0.88rem; color: var(--text-secondary);">
                    <thead>
                        <tr style="background: var(--bg-secondary); border-bottom: 2px solid var(--border);">
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Steric #</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Bonds</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Lone Pairs</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Electron Geometry</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Molecular Geometry</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Bond Angle</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Example</th>
                            <th style="padding: 0.6rem 0.5rem; text-align: left;">Polarity</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">2</td><td>2</td><td>0</td><td>Linear</td><td>Linear</td><td>180&#176;</td><td>CO&#8322;, BeCl&#8322;</td><td>Nonpolar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">3</td><td>3</td><td>0</td><td>Trigonal Planar</td><td>Trigonal Planar</td><td>120&#176;</td><td>BF&#8323;, SO&#8323;</td><td>Nonpolar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">3</td><td>2</td><td>1</td><td>Trigonal Planar</td><td>Bent</td><td>&lt;120&#176;</td><td>SO&#8322;, O&#8323;</td><td>Polar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">4</td><td>4</td><td>0</td><td>Tetrahedral</td><td>Tetrahedral</td><td>109.5&#176;</td><td>CH&#8324;, CCl&#8324;</td><td>Nonpolar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">4</td><td>3</td><td>1</td><td>Tetrahedral</td><td>Trigonal Pyramidal</td><td>~107&#176;</td><td>NH&#8323;, PCl&#8323;</td><td>Polar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">4</td><td>2</td><td>2</td><td>Tetrahedral</td><td>Bent</td><td>~104.5&#176;</td><td>H&#8322;O, H&#8322;S</td><td>Polar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">5</td><td>5</td><td>0</td><td>Trigonal Bipyramidal</td><td>Trigonal Bipyramidal</td><td>90&#176;, 120&#176;</td><td>PCl&#8325;</td><td>Nonpolar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">5</td><td>4</td><td>1</td><td>Trigonal Bipyramidal</td><td>Seesaw</td><td>&lt;90&#176;, &lt;120&#176;</td><td>SF&#8324;</td><td>Polar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">5</td><td>3</td><td>2</td><td>Trigonal Bipyramidal</td><td>T-shaped</td><td>&lt;90&#176;</td><td>ClF&#8323;, BrF&#8323;</td><td>Polar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">5</td><td>2</td><td>3</td><td>Trigonal Bipyramidal</td><td>Linear</td><td>180&#176;</td><td>XeF&#8322;, I&#8323;&#8315;</td><td>Nonpolar*</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">6</td><td>6</td><td>0</td><td>Octahedral</td><td>Octahedral</td><td>90&#176;</td><td>SF&#8326;</td><td>Nonpolar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">6</td><td>5</td><td>1</td><td>Octahedral</td><td>Square Pyramidal</td><td>&lt;90&#176;</td><td>BrF&#8325;, IF&#8325;</td><td>Polar</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding:0.5rem;">6</td><td>4</td><td>2</td><td>Octahedral</td><td>Square Planar</td><td>90&#176;</td><td>XeF&#8324;</td><td>Nonpolar*</td></tr>
                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg-secondary);"><td style="padding:0.5rem;">7</td><td>7</td><td>0</td><td>Pentagonal Bipyramidal</td><td>Pentagonal Bipyramidal</td><td>72&#176;, 90&#176;</td><td>IF&#8327;</td><td>Nonpolar</td></tr>
                    </tbody>
                </table>
            </div>
            <p style="color: var(--text-secondary); font-size: 0.82rem; margin-top: 0.5rem;">* Despite having lone pairs, XeF&#8322; (linear) and XeF&#8324; (square planar) are <strong>nonpolar</strong> because their molecular geometries are symmetric &mdash; dipole moments cancel out.</p>

            <h3 style="font-size: 1.05rem; margin: 1.5rem 0 0.75rem;">Polarity and Molecular Shape</h3>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem;">A molecule is <strong>nonpolar</strong> when its molecular geometry is <em>symmetric</em> (with identical ligands) &mdash; the individual bond dipoles cancel. It is <strong>polar</strong> when the geometry is asymmetric, leaving a net dipole moment.</p>
            <ul style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.4rem;"><strong>Always nonpolar</strong> (identical ligands): Linear (2 bonds), Trigonal Planar, Tetrahedral, Square Planar, Octahedral</li>
                <li style="margin-bottom: 0.4rem;"><strong>Always polar:</strong> Bent, Trigonal Pyramidal, Seesaw, T-shaped, Square Pyramidal</li>
                <li style="margin-bottom: 0.4rem;"><strong>Common misconception:</strong> &ldquo;Lone pairs always make a molecule polar&rdquo; &mdash; this is <em>wrong</em>. XeF&#8322; has 3 lone pairs but is nonpolar because the two Xe&ndash;F bonds point in opposite directions</li>
            </ul>
        </div>

        <!-- Exceptions to Octet Rule -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Exceptions to the Octet Rule</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">While the octet rule works for most molecules, there are three important exceptions:</p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem; color: var(--tool-primary);">Incomplete Octets</h4>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Some atoms are stable with <em>fewer</em> than 8 electrons. Hydrogen needs only 2 (duet rule). Beryllium and boron commonly have 4 and 6 electrons respectively. Example: BF&#8323; has only 6 electrons around B.</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem; color: var(--tool-primary);">Expanded Octets</h4>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Elements in Period 3 and beyond can hold <em>more</em> than 8 electrons by using d-orbitals. Examples: PCl&#8325; (10 e&#8315;), SF&#8326; (12 e&#8315;), XeF&#8322; (10 e&#8315;), XeF&#8324; (12 e&#8315;). Common elements: P, S, Cl, Br, I, Xe.</p>
                </div>
                <div style="background: var(--bg-secondary); border-radius: 8px; padding: 1rem;">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem; color: var(--tool-primary);">Odd-Electron (Free Radicals)</h4>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Molecules with an <em>odd</em> number of valence electrons cannot satisfy the octet rule on every atom. Examples: NO (11 e&#8315;), NO&#8322; (17 e&#8315;). The unpaired electron makes these species highly reactive.</p>
                </div>
            </div>
        </div>

        <!-- Resonance Structures -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Resonance Structures</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">When a molecule can be drawn with multiple valid Lewis structures that differ only in the <em>placement of electrons</em> (not atoms), these are called <strong>resonance structures</strong>. The true molecule is a weighted average (resonance hybrid) of all contributing structures.</p>
            <ul style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.4rem;"><strong>O&#8323; (ozone):</strong> One O=O double bond and one O&ndash;O single bond. Two equivalent resonance structures exist where the double bond switches sides. The real bond order is 1.5.</li>
                <li style="margin-bottom: 0.4rem;"><strong>NO&#8323;&#8315; (nitrate):</strong> Three equivalent resonance structures, each with one N=O double bond and two N&ndash;O single bonds. The real bond order is 1.33 for each N&ndash;O bond.</li>
                <li style="margin-bottom: 0.4rem;"><strong>CO&#8323;&#178;&#8315; (carbonate):</strong> Three equivalent resonance structures with a real bond order of 1.33 for each C&ndash;O bond.</li>
                <li style="margin-bottom: 0.4rem;"><strong>Tip:</strong> This tool alerts you when resonance is likely &mdash; look for the &ldquo;Resonance&rdquo; badge in the results when identical atoms have different bond orders.</li>
            </ul>
        </div>

    </section>

    <!-- Related Chemistry Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="lewis-structure-generator.jsp"/>
        <jsp:param name="keyword" value="chemistry"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- E-E-A-T: Experience, Expertise, Authoritativeness, Trustworthiness -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">About This Lewis Structure Tool & Methodology</h2>
            <p style="margin-bottom: 1rem; color: var(--text-secondary);">This Lewis Structure Generator uses valence electron calculations and VSEPR (Valence Shell Electron Pair Repulsion) theory to predict molecular geometry, bond angles, and polarity. All calculations and visualizations run entirely in your browser for instant, interactive molecular diagrams.</p>

            <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">How Lewis Structure Generation Works:</h3>
            <ol style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.5rem;"><strong>Count Valence Electrons:</strong> Sum all valence electrons from each atom, adjusting for molecular charge</li>
                <li style="margin-bottom: 0.5rem;"><strong>Arrange Atoms:</strong> Place the least electronegative atom in the center (hydrogen is always terminal)</li>
                <li style="margin-bottom: 0.5rem;"><strong>Draw Bonds:</strong> Connect atoms with single bonds, then distribute remaining electrons as lone pairs</li>
                <li style="margin-bottom: 0.5rem;"><strong>Form Multiple Bonds:</strong> If the central atom lacks an octet, convert lone pairs to double or triple bonds</li>
                <li><strong>Check Formal Charges:</strong> Calculate formal charges - the best structure minimizes charges</li>
            </ol>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship & Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--tool-primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Science and engineering education tools</li>
                        <li><strong>Covers:</strong> 80+ elements, generic notation, VSEPR steric numbers 1-7</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Tool Details</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Visualization:</strong> Interactive 2D molecular diagrams with element coloring (CPK standard)</li>
                        <li><strong>Privacy:</strong> All calculations run entirely in your browser &mdash; nothing is sent to a server</li>
                        <li><strong>Chemistry Standards:</strong> VSEPR theory, formal charge rules, octet rule, expanded octet support</li>
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

    <!-- p5.js CDN (instance mode, deferred) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js" defer></script>

    <script>
    // ========== DATA: Valence electrons (80+ elements + generic) ==========
    const valenceElectrons = {
        // Period 1
        'H': 1, 'He': 2,
        // Period 2
        'Li': 1, 'Be': 2, 'B': 3, 'C': 4, 'N': 5, 'O': 6, 'F': 7, 'Ne': 8,
        // Period 3
        'Na': 1, 'Mg': 2, 'Al': 3, 'Si': 4, 'P': 5, 'S': 6, 'Cl': 7, 'Ar': 8,
        // Period 4
        'K': 1, 'Ca': 2, 'Sc': 3, 'Ti': 4, 'V': 5, 'Cr': 6, 'Mn': 7, 'Fe': 8,
        'Co': 9, 'Ni': 10, 'Cu': 11, 'Zn': 12, 'Ga': 3, 'Ge': 4, 'As': 5, 'Se': 6, 'Br': 7, 'Kr': 8,
        // Period 5 (selected)
        'Rb': 1, 'Sr': 2, 'Ag': 11, 'Cd': 12, 'In': 3, 'Sn': 4, 'Sb': 5, 'Te': 6, 'I': 7, 'Xe': 8,
        // Period 6 (selected)
        'Cs': 1, 'Ba': 2, 'Au': 11, 'Hg': 12, 'Tl': 3, 'Pb': 4, 'Bi': 5, 'Po': 6, 'At': 7, 'Rn': 8,
        // Generic atom symbols
        'M': 4, 'A': 4, 'X': 7, 'L': 7, 'E': 6, 'R': 1, 'G': 8
    };

    // ========== DATA: VSEPR geometry lookup (steric numbers 1-7) ==========
    const vseprData = {
        '1-0': { electron: 'Linear', molecular: 'Linear', angle: 'N/A', example: 'H, Free radical' },
        '2-0': { electron: 'Linear', molecular: 'Linear', angle: '180\u00b0', example: 'CO\u2082, BeF\u2082, HCN' },
        '3-0': { electron: 'Trigonal Planar', molecular: 'Trigonal Planar', angle: '120\u00b0', example: 'BF\u2083, SO\u2083, NO\u2083\u207b' },
        '3-1': { electron: 'Trigonal Planar', molecular: 'Bent', angle: '<120\u00b0 (~119\u00b0)', example: 'SO\u2082, O\u2083, NO\u2082\u207b' },
        '3-2': { electron: 'Trigonal Planar', molecular: 'Linear', angle: '180\u00b0', example: 'Rare (theoretical, 1 bond + 2 LP in sp\u00b2)' },
        '4-0': { electron: 'Tetrahedral', molecular: 'Tetrahedral', angle: '109.5\u00b0', example: 'CH\u2084, CCl\u2084, SO\u2084\u00b2\u207b' },
        '4-1': { electron: 'Tetrahedral', molecular: 'Trigonal Pyramidal', angle: '<109.5\u00b0 (~107\u00b0)', example: 'NH\u2083, PCl\u2083, H\u2083O\u207a' },
        '4-2': { electron: 'Tetrahedral', molecular: 'Bent', angle: '<109.5\u00b0 (~104.5\u00b0)', example: 'H\u2082O, H\u2082S, OF\u2082' },
        '4-3': { electron: 'Tetrahedral', molecular: 'Linear', angle: '180\u00b0', example: 'HF, HCl (from halogen perspective)' },
        '5-0': { electron: 'Trigonal Bipyramidal', molecular: 'Trigonal Bipyramidal', angle: '90\u00b0, 120\u00b0', example: 'PCl\u2085, PF\u2085' },
        '5-1': { electron: 'Trigonal Bipyramidal', molecular: 'Seesaw', angle: '<90\u00b0, <120\u00b0', example: 'SF\u2084, TeCl\u2084' },
        '5-2': { electron: 'Trigonal Bipyramidal', molecular: 'T-shaped', angle: '<90\u00b0', example: 'ClF\u2083, BrF\u2083' },
        '5-3': { electron: 'Trigonal Bipyramidal', molecular: 'Linear', angle: '180\u00b0', example: 'XeF\u2082, I\u2083\u207b' },
        '6-0': { electron: 'Octahedral', molecular: 'Octahedral', angle: '90\u00b0', example: 'SF\u2086, PF\u2086\u207b' },
        '6-1': { electron: 'Octahedral', molecular: 'Square Pyramidal', angle: '<90\u00b0', example: 'BrF\u2085, IF\u2085' },
        '6-2': { electron: 'Octahedral', molecular: 'Square Planar', angle: '90\u00b0', example: 'XeF\u2084, ICl\u2084\u207b' },
        '6-3': { electron: 'Octahedral', molecular: 'T-shaped', angle: '90\u00b0', example: 'Rare (6 e\u207b domains, 3 LP meridional)' },
        '7-0': { electron: 'Pentagonal Bipyramidal', molecular: 'Pentagonal Bipyramidal', angle: '72\u00b0, 90\u00b0', example: 'IF\u2087' },
        '7-1': { electron: 'Pentagonal Bipyramidal', molecular: 'Pentagonal Pyramidal', angle: '<90\u00b0', example: 'XeOF\u2085\u207b' },
        '7-2': { electron: 'Pentagonal Bipyramidal', molecular: 'Pentagonal Planar', angle: '72\u00b0', example: 'XeF\u2085\u207b' }
    };

    // ========== ELEMENT COLORS for p5.js ==========
    // CPK / Jmol standard element colors
    const elementColors = {
        'H':  [255, 255, 255],   // White
        'He': [217, 255, 255],   // Light cyan
        'Li': [204, 128, 255],   // Violet
        'Be': [194, 255,   0],   // Yellow-green
        'B':  [255, 181, 181],   // Salmon
        'C':  [144, 144, 144],   // Gray
        'N':  [ 48,  80, 248],   // Blue
        'O':  [255,  13,  13],   // Red
        'F':  [144, 224,  80],   // Green
        'Ne': [179, 227, 245],   // Pale blue
        'Na': [171,  92, 242],   // Purple
        'Mg': [138, 255,   0],   // Green
        'Al': [191, 166, 166],   // Gray
        'Si': [240, 200, 160],   // Tan
        'P':  [255, 128,   0],   // Orange
        'S':  [255, 255,  48],   // Yellow
        'Cl': [ 31, 240,  31],   // Green
        'Ar': [128, 209, 227],   // Cyan
        'K':  [143,  64, 212],   // Purple
        'Ca': [ 61, 255,   0],   // Green
        'Ti': [191, 194, 199],   // Silver
        'Fe': [224, 102,  51],   // Orange-brown
        'Cu': [200, 128,  51],   // Copper
        'Zn': [125, 128, 176],   // Slate
        'As': [189, 128, 227],   // Violet
        'Se': [255, 161,   0],   // Deep orange
        'Br': [166,  41,  41],   // Dark red
        'Kr': [ 92, 184, 209],   // Blue
        'I':  [148,   0, 148],   // Dark violet
        'Xe': [ 66, 158, 176],   // Teal
        'Te': [212, 122,   0],   // Brown-orange
        'Pt': [208, 208, 224],   // Silver
        'Au': [255, 209,  35],   // Gold
        'default': [180, 180, 180]
    };
    // Light elements need dark text; dark elements need light text
    function elementTextDark(rgb) {
        return (rgb[0] * 0.299 + rgb[1] * 0.587 + rgb[2] * 0.114) > 150;
    }

    const genericSymbols = ['M', 'A', 'X', 'L', 'E', 'R', 'G'];

    const TOOL_NAME = 'Lewis Structure Generator';
    let currentP5 = null;
    let currentResultText = '';

    // ========== CHEMICAL FORMULA FORMATTING ==========
    // Unicode subscript digits for plain-text contexts (copy, canvas, clipboard)
    var unicodeSubs = {'0':'\u2080','1':'\u2081','2':'\u2082','3':'\u2083','4':'\u2084',
                       '5':'\u2085','6':'\u2086','7':'\u2087','8':'\u2088','9':'\u2089'};

    // "H2O" → "H<sub>2</sub>O"  (for innerHTML)
    function formatFormulaHtml(formula) {
        return formula.replace(/([A-Z][a-z]?)(\d+)/g, function(_, el, num) {
            return el + '<sub>' + num + '</sub>';
        });
    }

    // "H2O" → "H₂O"  (for plain text / clipboard / canvas)
    function formatFormulaText(formula) {
        return formula.replace(/(\d+)/g, function(m) {
            return m.split('').map(function(d){ return unicodeSubs[d] || d; }).join('');
        });
    }

    // Build a molecule header banner:  "H₂O" with optional charge
    function buildMoleculeHeader(formulaStr, charge) {
        var htmlFormula = formatFormulaHtml(formulaStr);
        var chargeHtml = '';
        if (charge && charge !== 0) {
            var chargeLabel = (charge > 0 ? '+' : '') + charge;
            chargeHtml = '<sup>' + chargeLabel + '</sup>';
        }
        return '<div class="lewis-molecule-header">' +
            '<span class="lewis-formula">' + htmlFormula + chargeHtml + '</span>' +
            '<span class="lewis-molecule-meta">Lewis Structure Analysis</span>' +
            '</div>';
    }

    // ========== PARSE MOLECULAR FORMULA ==========
    function parseMolecularFormula(formula) {
        // Normalize Unicode subscripts (₀₁₂…₉) to ASCII digits
        formula = formula.replace(/[\u2080-\u2089]/g, function(ch) {
            return String(ch.charCodeAt(0) - 0x2080);
        });
        // Normalize Unicode superscripts (⁰¹²³⁴⁵⁶⁷⁸⁹) to ASCII digits
        formula = formula.replace(/[\u2070\u00B9\u00B2\u00B3\u2074-\u2079]/g, function(ch) {
            var map = {'\u2070':'0','\u00B9':'1','\u00B2':'2','\u00B3':'3',
                       '\u2074':'4','\u2075':'5','\u2076':'6','\u2077':'7',
                       '\u2078':'8','\u2079':'9'};
            return map[ch] || ch;
        });
        // Strip trailing charge symbols (⁺ ⁻ + - −) so they don't break parsing
        formula = formula.replace(/[\u207A\u207B\u2212+\-]+$/, '');

        const atoms = {};
        const regex = /([A-Z][a-z]?)(\d*)/g;
        let match;
        while ((match = regex.exec(formula)) !== null) {
            const element = match[1];
            const count = match[2] ? parseInt(match[2]) : 1;
            atoms[element] = (atoms[element] || 0) + count;
        }
        return atoms;
    }

    // ========== p5.js SKETCH LIFECYCLE ==========
    function destroyCurrentSketch() {
        if (currentP5) {
            currentP5.remove();
            currentP5 = null;
        }
        var container = document.getElementById('lewisCanvasContainer');
        // Keep empty state hidden after first render
        var emptyState = document.getElementById('emptyState');
        if (emptyState) emptyState.style.display = 'none';
        // Remove any existing canvas
        var existingCanvas = container.querySelector('canvas');
        if (existingCanvas) existingCanvas.remove();
    }

    function isDarkMode() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    // ========== BONDING ANALYSIS ==========
    // Determines bond orders and lone pairs for accurate Lewis structures

    function analyzeBonding(atoms, centralAtom, totalValence) {
        var peripherals = [];
        for (var el in atoms) {
            if (el === centralAtom && atoms[el] === 1) continue;
            var count = (el === centralAtom) ? atoms[el] - 1 : atoms[el];
            for (var i = 0; i < count; i++) peripherals.push(el);
        }

        var bondOrders = [];
        for (var i = 0; i < peripherals.length; i++) bondOrders.push(1);
        var usedE = peripherals.length * 2;
        var remaining = totalValence - usedE;

        // Give peripheral atoms lone pairs to complete octets
        var pLonePairs = [];
        for (var i = 0; i < peripherals.length; i++) pLonePairs.push(0);
        for (var i = 0; i < peripherals.length; i++) {
            var need = (peripherals[i] === 'H') ? 0 : 3;
            var canGive = Math.min(need, Math.floor(remaining / 2));
            pLonePairs[i] = canGive;
            remaining -= canGive * 2;
        }

        // Central atom electron count (from bonds so far)
        var centralE = 0;
        for (var i = 0; i < bondOrders.length; i++) centralE += bondOrders[i] * 2;

        // Give central atom lone pairs from remaining
        var cLonePairs = 0;
        var centralTarget = (centralAtom === 'H') ? 2 : 8;

        while (centralE + cLonePairs * 2 < centralTarget && remaining >= 2) {
            cLonePairs++;
            remaining -= 2;
        }

        var centralTotal = centralE + cLonePairs * 2;

        // If central still doesn't have octet, form multiple bonds
        // by converting peripheral lone pairs into additional shared bonds
        while (centralTotal < centralTarget) {
            var bestIdx = -1;
            var bestPairs = 0;
            for (var i = 0; i < peripherals.length; i++) {
                if (pLonePairs[i] > 0 && peripherals[i] !== 'H' && bondOrders[i] < 3) {
                    if (pLonePairs[i] > bestPairs) {
                        bestPairs = pLonePairs[i];
                        bestIdx = i;
                    }
                }
            }
            if (bestIdx === -1) break;

            pLonePairs[bestIdx]--;
            bondOrders[bestIdx]++;
            centralTotal += 2;
        }

        // For expanded octet elements, extra remaining electrons go on central
        var expandedEls = ['P', 'S', 'Cl', 'Br', 'I', 'Xe', 'Se', 'Te', 'As'];
        if (remaining > 0 && expandedEls.indexOf(centralAtom) !== -1) {
            var extraPairs = Math.floor(remaining / 2);
            cLonePairs += extraPairs;
            remaining -= extraPairs * 2;
        }

        // Detect resonance: identical peripheral atoms with different bond orders
        var hasResonance = false;
        var elOrders = {};
        for (var i = 0; i < peripherals.length; i++) {
            if (!elOrders[peripherals[i]]) elOrders[peripherals[i]] = [];
            elOrders[peripherals[i]].push(bondOrders[i]);
        }
        for (var el in elOrders) {
            var orders = elOrders[el];
            if (orders.length > 1) {
                for (var j = 1; j < orders.length; j++) {
                    if (orders[j] !== orders[0]) { hasResonance = true; break; }
                }
            }
            if (hasResonance) break;
        }

        return {
            peripherals: peripherals,
            bondOrders: bondOrders,
            peripheralLonePairs: pLonePairs,
            centralLonePairs: cLonePairs,
            hasResonance: hasResonance,
            isRadical: (totalValence % 2 !== 0),
            unpairedElectrons: remaining
        };
    }

    function analyzeChainBonding(backbone, termsPerAtom, totalValence) {
        var bbBonds = backbone.length - 1;
        var termBonds = 0;
        for (var i = 0; i < termsPerAtom.length; i++) termBonds += termsPerAtom[i].length;
        var remaining = totalValence - (bbBonds + termBonds) * 2;

        // Terminal atom lone pairs (non-H get up to 3 pairs for octet)
        var termLonePairs = [];
        for (var i = 0; i < termsPerAtom.length; i++) {
            var arr = [];
            for (var t = 0; t < termsPerAtom[i].length; t++) {
                var need = (termsPerAtom[i][t] === 'H') ? 0 : 3;
                var canGive = Math.min(need, Math.floor(remaining / 2));
                arr.push(canGive);
                remaining -= canGive * 2;
            }
            termLonePairs.push(arr);
        }

        // Backbone atom lone pairs
        var bbLonePairs = [];
        for (var i = 0; i < backbone.length; i++) bbLonePairs.push(0);
        for (var i = 0; i < backbone.length; i++) {
            var bondCount = (i > 0 ? 1 : 0) + (i < backbone.length - 1 ? 1 : 0) + termsPerAtom[i].length;
            var atomE = bondCount * 2;
            var target = (backbone[i] === 'H') ? 2 : 8;
            var needed = Math.max(0, Math.floor((target - atomE) / 2));
            var canGive = Math.min(needed, Math.floor(remaining / 2));
            bbLonePairs[i] = canGive;
            remaining -= canGive * 2;
        }

        // For expanded octet backbone atoms, absorb leftover electrons
        // Give to the most-bonded atom first (central atom gets expanded octet)
        var expandedEls = ['P', 'S', 'Cl', 'Br', 'I', 'Xe', 'Se', 'Te', 'As'];
        while (remaining >= 2) {
            var bestIdx = -1, maxBonds = -1;
            for (var i = 0; i < backbone.length; i++) {
                if (expandedEls.indexOf(backbone[i]) === -1) continue;
                var bCnt = (i > 0 ? 1 : 0) + (i < backbone.length - 1 ? 1 : 0) + termsPerAtom[i].length;
                if (bCnt > maxBonds) { maxBonds = bCnt; bestIdx = i; }
            }
            if (bestIdx === -1) break;
            bbLonePairs[bestIdx]++;
            remaining -= 2;
        }

        // Check backbone atoms for octet; increase backbone bond orders if needed
        var bbBondOrders = [];
        for (var i = 0; i < Math.max(0, backbone.length - 1); i++) bbBondOrders.push(1);

        for (var pass = 0; pass < 3; pass++) {
            for (var i = 0; i < backbone.length; i++) {
                var myBondE = 0;
                if (i > 0) myBondE += bbBondOrders[i - 1] * 2;
                if (i < backbone.length - 1) myBondE += bbBondOrders[i] * 2;
                myBondE += termsPerAtom[i].length * 2;
                var atomE = myBondE + bbLonePairs[i] * 2;
                var target = (backbone[i] === 'H') ? 2 : 8;

                while (atomE < target) {
                    var increased = false;
                    // Try left neighbor
                    if (i > 0 && bbLonePairs[i - 1] > 0 && bbBondOrders[i - 1] < 3) {
                        bbLonePairs[i - 1]--;
                        bbBondOrders[i - 1]++;
                        atomE += 2;
                        increased = true;
                    }
                    // Try right neighbor
                    if (!increased && i < backbone.length - 1 && bbLonePairs[i + 1] > 0 && bbBondOrders[i] < 3) {
                        bbLonePairs[i + 1]--;
                        bbBondOrders[i]++;
                        atomE += 2;
                        increased = true;
                    }
                    if (!increased) break;
                }
            }
        }

        return {
            bbBondOrders: bbBondOrders,
            bbLonePairs: bbLonePairs,
            termLonePairs: termLonePairs
        };
    }

    // Draw single / double / triple bond between two points
    function drawMultiBond(p, x1, y1, x2, y2, order, bondCol, weight) {
        p.stroke(bondCol);
        p.strokeWeight(weight || 2.5);
        if (order === 1) {
            p.line(x1, y1, x2, y2);
        } else {
            var dx = x2 - x1;
            var dy = y2 - y1;
            var len = Math.sqrt(dx * dx + dy * dy);
            if (len === 0) return;
            var px = -dy / len;
            var py = dx / len;
            if (order === 2) {
                var off = 3;
                p.line(x1 + px * off, y1 + py * off, x2 + px * off, y2 + py * off);
                p.line(x1 - px * off, y1 - py * off, x2 - px * off, y2 - py * off);
            } else if (order >= 3) {
                var off = 4;
                p.line(x1, y1, x2, y2);
                p.line(x1 + px * off, y1 + py * off, x2 + px * off, y2 + py * off);
                p.line(x1 - px * off, y1 - py * off, x2 - px * off, y2 - py * off);
            }
        }
    }

    // Draw lone pair dots at a given angle from a point
    function drawLonePairDots(p, x, y, angle, dist, color) {
        var dotX = x + Math.cos(angle) * dist;
        var dotY = y + Math.sin(angle) * dist;
        var perpX = Math.cos(angle + Math.PI / 2) * 4;
        var perpY = Math.sin(angle + Math.PI / 2) * 4;
        p.fill(color);
        p.noStroke();
        p.ellipse(dotX - perpX, dotY - perpY, 5, 5);
        p.ellipse(dotX + perpX, dotY + perpY, 5, 5);
    }

    // ========== p5.js: Lewis Structure Sketch ==========
    function createLewisSketch(atoms, centralAtom, totalValence, charge, bonding) {
        destroyCurrentSketch();

        var container = document.getElementById('lewisCanvasContainer');
        var w = container.clientWidth || 400;
        var h = Math.max(320, container.clientHeight || 320);

        currentP5 = new p5(function(p) {
            var peripheralAtoms = bonding.peripherals;
            var bondOrders = bonding.bondOrders;
            var pLonePairs = bonding.peripheralLonePairs;
            var centralLonePairs = bonding.centralLonePairs;

            p.setup = function() {
                var canvas = p.createCanvas(w, h);
                canvas.parent('lewisCanvasContainer');
                p.textFont('Inter, sans-serif');
                p.noLoop();
            };

            p.draw = function() {
                var dark = isDarkMode();
                var bg = dark ? p.color(30, 41, 59) : p.color(255);
                var textCol = dark ? p.color(226, 232, 240) : p.color(15, 23, 42);
                var bondCol = dark ? p.color(148, 163, 184) : p.color(100, 116, 139);
                var lonePairCol = dark ? p.color(129, 230, 217) : p.color(16, 185, 129);

                p.background(bg);

                var cx = w / 2;
                var cy = h / 2;
                var bondLen = Math.min(w, h) * 0.3;

                // Compute peripheral positions
                var pPositions = [];
                for (var i = 0; i < peripheralAtoms.length; i++) {
                    var angle;
                    if (peripheralAtoms.length === 1) {
                        angle = 0;
                    } else if (peripheralAtoms.length === 2) {
                        angle = (i === 0) ? Math.PI : 0;
                    } else {
                        angle = (2 * Math.PI * i) / peripheralAtoms.length - Math.PI / 2;
                    }
                    pPositions.push({
                        x: cx + Math.cos(angle) * bondLen,
                        y: cy + Math.sin(angle) * bondLen,
                        angle: angle
                    });
                }

                // Draw bonds (single / double / triple)
                for (var i = 0; i < peripheralAtoms.length; i++) {
                    drawMultiBond(p, cx, cy, pPositions[i].x, pPositions[i].y,
                        bondOrders[i], bondCol, 3);
                }

                // Draw lone pairs on peripheral atoms (far side from center)
                for (var i = 0; i < peripheralAtoms.length; i++) {
                    if (pLonePairs[i] > 0 && peripheralAtoms[i] !== 'H') {
                        var farAngle = pPositions[i].angle; // points away from center
                        var lpDist = 22;
                        // Draw up to 3 lone pairs around the far side
                        for (var lp = 0; lp < Math.min(pLonePairs[i], 3); lp++) {
                            var spreadAngle;
                            if (pLonePairs[i] === 1) {
                                spreadAngle = farAngle;
                            } else if (pLonePairs[i] === 2) {
                                spreadAngle = farAngle + (lp === 0 ? -Math.PI / 5 : Math.PI / 5);
                            } else {
                                spreadAngle = farAngle + (lp - 1) * Math.PI / 4;
                            }
                            drawLonePairDots(p, pPositions[i].x, pPositions[i].y,
                                spreadAngle, lpDist, lonePairCol);
                        }
                    }
                }

                // Draw peripheral atom circles and labels
                for (var i = 0; i < peripheralAtoms.length; i++) {
                    var elColor = elementColors[peripheralAtoms[i]] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(1.5);
                    p.fill(elColor[0], elColor[1], elColor[2], dark ? 200 : 230);
                    p.ellipse(pPositions[i].x, pPositions[i].y, 36, 36);

                    var isLight = elementTextDark(elColor);
                    p.fill(isLight ? (dark ? 20 : 30) : (dark ? 240 : 255));
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text(peripheralAtoms[i], pPositions[i].x, pPositions[i].y);
                }

                // Draw lone pairs on central atom
                if (centralLonePairs > 0) {
                    var lpStartAngle = peripheralAtoms.length > 0
                        ? (2 * Math.PI * peripheralAtoms.length) / peripheralAtoms.length - Math.PI / 2 + Math.PI / peripheralAtoms.length
                        : 0;
                    if (peripheralAtoms.length === 0) lpStartAngle = 0;

                    var lpAngles = [];
                    // Place lone pairs in the gaps
                    if (peripheralAtoms.length === 0) {
                        for (var lp = 0; lp < centralLonePairs; lp++) {
                            lpAngles.push((2 * Math.PI * lp) / centralLonePairs);
                        }
                    } else if (peripheralAtoms.length === 1) {
                        var baseAngle = Math.PI; // opposite side of the single bond (which is at angle 0)
                        if (centralLonePairs === 1) {
                            lpAngles.push(baseAngle);
                        } else if (centralLonePairs === 2) {
                            lpAngles.push(baseAngle - Math.PI/4);
                            lpAngles.push(baseAngle + Math.PI/4);
                        } else {
                            for (var lp = 0; lp < centralLonePairs; lp++) {
                                lpAngles.push(baseAngle + (lp - (centralLonePairs-1)/2) * Math.PI/4);
                            }
                        }
                    } else {
                        // Place lone pairs evenly between bond positions
                        var gapSize = 2 * Math.PI / (peripheralAtoms.length + centralLonePairs);
                        for (var lp = 0; lp < centralLonePairs; lp++) {
                            var idx = peripheralAtoms.length + lp;
                            lpAngles.push(gapSize * idx - Math.PI / 2);
                        }
                    }

                    for (var lp = 0; lp < lpAngles.length; lp++) {
                        var lpDist = bondLen * 0.45;
                        var lx = cx + Math.cos(lpAngles[lp]) * lpDist;
                        var ly = cy + Math.sin(lpAngles[lp]) * lpDist;

                        // Two dots per lone pair
                        var perpX = Math.cos(lpAngles[lp] + Math.PI/2) * 5;
                        var perpY = Math.sin(lpAngles[lp] + Math.PI/2) * 5;

                        p.fill(lonePairCol);
                        p.noStroke();
                        p.ellipse(lx - perpX, ly - perpY, 7, 7);
                        p.ellipse(lx + perpX, ly + perpY, 7, 7);
                    }
                }

                // Central atom circle
                var centerColor = elementColors[centralAtom] || elementColors['default'];
                p.stroke(dark ? 100 : 60);
                p.strokeWeight(2);
                p.fill(centerColor[0], centerColor[1], centerColor[2], dark ? 220 : 240);
                p.ellipse(cx, cy, 44, 44);

                // Central atom label
                var isCenterLight = elementTextDark(centerColor);
                p.fill(isCenterLight ? (dark ? 20 : 30) : (dark ? 240 : 255));
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(16);
                p.textStyle(p.BOLD);
                p.text(centralAtom, cx, cy);

                // Title
                p.fill(dark ? p.color(148, 163, 184) : p.color(100, 116, 139));
                p.textSize(11);
                p.textStyle(p.NORMAL);
                p.textAlign(p.CENTER, p.TOP);
                var formulaStr = Object.entries(atoms).map(function(e){ return e[0] + (e[1] > 1 ? e[1] : ''); }).join('');
                p.text('Lewis Structure: ' + formatFormulaText(formulaStr) + (charge !== 0 ? ' (' + (charge > 0 ? '+' : '') + charge + ')' : ''), w/2, 10);
            };
        }, container);
    }

    // ========== p5.js: VSEPR Geometry Sketch ==========
    function computeVSEPRPositions(bonds, lone) {
        var steric = bonds + lone;
        var positions = [];

        switch(steric) {
            case 1:
                positions.push({x: 1, y: 0, z: 0, type: 'bond'});
                break;
            case 2:
                positions.push({x: -1, y: 0, z: 0, type: 'bond'});
                positions.push({x: 1, y: 0, z: 0, type: 'bond'});
                break;
            case 3:
                for (var i = 0; i < 3; i++) {
                    var a = (2 * Math.PI * i) / 3;
                    positions.push({x: Math.cos(a), y: Math.sin(a), z: 0, type: 'bond'});
                }
                break;
            case 4:
                // Tetrahedral
                var tetAngle = Math.acos(-1/3);
                positions.push({x: 0, y: -1, z: 0});
                positions.push({x: Math.sin(tetAngle) * Math.cos(0), y: Math.cos(tetAngle), z: Math.sin(tetAngle) * Math.sin(0)});
                positions.push({x: Math.sin(tetAngle) * Math.cos(2*Math.PI/3), y: Math.cos(tetAngle), z: Math.sin(tetAngle) * Math.sin(2*Math.PI/3)});
                positions.push({x: Math.sin(tetAngle) * Math.cos(4*Math.PI/3), y: Math.cos(tetAngle), z: Math.sin(tetAngle) * Math.sin(4*Math.PI/3)});
                break;
            case 5:
                // Trigonal bipyramidal: 3 equatorial + 2 axial
                positions.push({x: 0, y: -1, z: 0}); // axial top
                positions.push({x: 0, y: 1, z: 0});  // axial bottom
                for (var i = 0; i < 3; i++) {
                    var a = (2 * Math.PI * i) / 3;
                    positions.push({x: Math.cos(a), y: 0, z: Math.sin(a)});
                }
                break;
            case 6:
                // Octahedral
                positions.push({x: 0, y: -1, z: 0});
                positions.push({x: 0, y: 1, z: 0});
                positions.push({x: 1, y: 0, z: 0});
                positions.push({x: -1, y: 0, z: 0});
                positions.push({x: 0, y: 0, z: 1});
                positions.push({x: 0, y: 0, z: -1});
                break;
            case 7:
                // Pentagonal bipyramidal: 5 equatorial first, then 2 axial
                // Equatorial-first ordering ensures lone pairs go axial:
                //   7-1 pent pyr: bonds [eq×5,ax1]  lone [ax2] ✓
                //   7-2 pent plan: bonds [eq×5]     lone [ax1,ax2] ✓
                for (var i = 0; i < 5; i++) {
                    var a = (2 * Math.PI * i) / 5;
                    positions.push({x: Math.cos(a), y: 0, z: Math.sin(a)});
                }
                positions.push({x: 0, y: -1, z: 0});
                positions.push({x: 0, y: 1, z: 0});
                break;
            default:
                positions.push({x: 0, y: 0, z: 0});
        }

        // Position ordering is chosen so that the simple rule "first N = bonds, rest = lone"
        // naturally places lone pairs in chemically correct positions:
        //   Steric 5 (TBP): [axial, axial, eq, eq, eq]
        //     5-1 seesaw:  bonds [ax,ax,eq,eq]  lone [eq]       -- lone pair equatorial ✓
        //     5-2 T-shape:  bonds [ax,ax,eq]     lone [eq,eq]    -- both equatorial ✓
        //     5-3 linear:   bonds [ax,ax]        lone [eq,eq,eq] -- all equatorial ✓
        //   Steric 6 (Oct): [+y, -y, +x, -x, +z, -z]
        //     6-1 sq pyr:   bonds [5 of 6]       lone [-z]       -- one axial ✓
        //     6-2 sq plan:  bonds [+y,-y,+x,-x]  lone [+z,-z]   -- trans pair ✓
        //     6-3 T-shape:  bonds [+y,-y,+x]     lone [-x,+z,-z] -- meridional ✓
        //   Steric 7 (PBP): [eq×5, axial, axial]
        //     7-1 pent pyr: bonds [eq×5,ax1]     lone [ax2]      -- axial lone pair ✓
        //     7-2 pent plan: bonds [eq×5]         lone [ax1,ax2]  -- both axial ✓
        for (var i = 0; i < positions.length; i++) {
            if (i < bonds) {
                positions[i].type = 'bond';
            } else {
                positions[i].type = 'lone';
            }
        }

        return positions;
    }

    function createVSEPRSketch(bonds, lone, atom, geometry) {
        destroyCurrentSketch();

        var container = document.getElementById('lewisCanvasContainer');
        var w = container.clientWidth || 400;
        var h = Math.max(320, container.clientHeight || 320);

        currentP5 = new p5(function(p) {
            var positions = computeVSEPRPositions(bonds, lone);
            var rotYAngle = 0.35; // initial Y rotation
            var rotXAngle = 0.25; // fixed X tilt

            p.setup = function() {
                var canvas = p.createCanvas(w, h);
                canvas.parent('lewisCanvasContainer');
                p.textFont('Inter, sans-serif');
                p.frameRate(30); // smooth but lightweight animation
            };

            p.draw = function() {
                var dark = isDarkMode();
                var bg = dark ? p.color(30, 41, 59) : p.color(255);
                var textCol = dark ? p.color(226, 232, 240) : p.color(15, 23, 42);
                var bondCol = dark ? p.color(148, 163, 184) : p.color(100, 116, 139);
                var lonePairCol = dark ? p.color(129, 230, 217) : p.color(16, 185, 129);
                var atomCol = dark ? p.color(129, 140, 248) : p.color(99, 102, 241);
                var bondAtomCol = dark ? p.color(248, 113, 113) : p.color(239, 68, 68);

                p.background(bg);

                var cx = w / 2;
                var cy = h / 2;
                var scale = Math.min(w, h) * 0.28;

                // Gentle auto-rotation around Y axis
                rotYAngle += 0.006;
                var rotY = rotYAngle;
                var rotX = rotXAngle;

                function project(pos) {
                    // Rotate around Y axis
                    var x1 = pos.x * Math.cos(rotY) + pos.z * Math.sin(rotY);
                    var z1 = -pos.x * Math.sin(rotY) + pos.z * Math.cos(rotY);
                    // Rotate around X axis
                    var y1 = pos.y * Math.cos(rotX) - z1 * Math.sin(rotX);
                    var z2 = pos.y * Math.sin(rotX) + z1 * Math.cos(rotX);
                    return { x: cx + x1 * scale, y: cy + y1 * scale, z: z2 };
                }

                // Sort by z for painter's algorithm
                var projected = positions.map(function(pos, idx) {
                    var pr = project(pos);
                    pr.type = pos.type;
                    pr.idx = idx;
                    return pr;
                });
                projected.sort(function(a, b) { return a.z - b.z; });

                // Draw bonds/lone pairs from back to front
                for (var i = 0; i < projected.length; i++) {
                    var pt = projected[i];
                    var depth = p.map(pt.z, -1, 1, 0.4, 1.0);

                    // Bond line from center
                    if (pt.type === 'bond') {
                        p.stroke(bondCol);
                        p.strokeWeight(pt.z < -0.2 ? 1.5 : 3);
                        if (pt.z < -0.3) {
                            // Dashed line for behind
                            drawDashedLine(p, cx, cy, pt.x, pt.y, 6);
                        } else {
                            p.line(cx, cy, pt.x, pt.y);
                        }
                    } else {
                        // Lone pair - dashed line
                        p.stroke(lonePairCol);
                        p.strokeWeight(1.5);
                        drawDashedLine(p, cx, cy, pt.x, pt.y, 5);
                    }
                }

                // Draw atoms/lone pairs from back to front
                for (var i = 0; i < projected.length; i++) {
                    var pt = projected[i];
                    var depth = p.map(pt.z, -1, 1, 0.5, 1.0);

                    if (pt.type === 'bond') {
                        // Bonding atom
                        p.noStroke();
                        var r = bondAtomCol.levels ? bondAtomCol.levels[0] : 239;
                        var g = bondAtomCol.levels ? bondAtomCol.levels[1] : 68;
                        var b = bondAtomCol.levels ? bondAtomCol.levels[2] : 68;
                        p.fill(r, g, b, 255 * depth);
                        var sz = 30 * depth;
                        p.ellipse(pt.x, pt.y, sz, sz);

                        p.fill(textCol);
                        p.textAlign(p.CENTER, p.CENTER);
                        p.textSize(11 * depth);
                        p.textStyle(p.BOLD);
                        p.text('X', pt.x, pt.y);
                    } else {
                        // Lone pair dots
                        p.noStroke();
                        var perpAngle = Math.atan2(pt.y - cy, pt.x - cx) + Math.PI/2;
                        var dotOffset = 5;
                        p.fill(lonePairCol);
                        p.ellipse(pt.x - Math.cos(perpAngle)*dotOffset, pt.y - Math.sin(perpAngle)*dotOffset, 8 * depth, 8 * depth);
                        p.ellipse(pt.x + Math.cos(perpAngle)*dotOffset, pt.y + Math.sin(perpAngle)*dotOffset, 8 * depth, 8 * depth);

                        // LP label
                        p.fill(lonePairCol);
                        p.textSize(9 * depth);
                        p.textAlign(p.CENTER, p.CENTER);
                        p.textStyle(p.NORMAL);
                        var labelDist = 15;
                        var labelAngle = Math.atan2(pt.y - cy, pt.x - cx);
                        p.text('LP', pt.x + Math.cos(labelAngle)*labelDist, pt.y + Math.sin(labelAngle)*labelDist);
                    }
                }

                // Central atom
                p.noStroke();
                p.fill(atomCol);
                p.ellipse(cx, cy, 40, 40);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(15);
                p.textStyle(p.BOLD);
                p.text(atom || 'A', cx, cy);

                // Geometry label & bond angle
                p.fill(dark ? p.color(148, 163, 184) : p.color(100, 116, 139));
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.textAlign(p.CENTER, p.BOTTOM);
                p.text(geometry.molecular, w/2, h - 25);
                p.textSize(10);
                p.textStyle(p.NORMAL);
                p.text('Bond angle: ' + geometry.angle, w/2, h - 10);
            };
        }, container);
    }

    function drawDashedLine(p, x1, y1, x2, y2, dashLen) {
        var dx = x2 - x1;
        var dy = y2 - y1;
        var dist = Math.sqrt(dx*dx + dy*dy);
        var dashes = Math.floor(dist / dashLen);
        var ux = dx / dist;
        var uy = dy / dist;
        for (var i = 0; i < dashes; i += 2) {
            var sx = x1 + ux * i * dashLen;
            var sy = y1 + uy * i * dashLen;
            var ex = x1 + ux * Math.min((i+1) * dashLen, dist);
            var ey = y1 + uy * Math.min((i+1) * dashLen, dist);
            p.line(sx, sy, ex, ey);
        }
    }

    // ========== CHAIN MOLECULE SUPPORT ==========
    // Max bonds an element typically forms (for distributing terminals)
    function getMaxBonds(el) {
        var v = valenceElectrons[el];
        if (!v) return 4;
        if (v <= 4) return v;   // Groups 1-14
        return 8 - v;           // Groups 15-18  (N=3, O=2, F=1)
    }

    // Compute angles for terminal atoms around a backbone atom in a chain
    function getTerminalAngles(count, isFirst, isMiddle, isLast) {
        if (isFirst) {
            // Backbone bond goes RIGHT (0°). Place terminals in left hemisphere.
            switch(count) {
                case 1: return [Math.PI];
                case 2: return [2*Math.PI/3, 4*Math.PI/3];
                case 3: return [Math.PI/2, Math.PI, 3*Math.PI/2];
                default:
                    var a = [];
                    for (var t = 0; t < count; t++) a.push(Math.PI/2 + Math.PI * t / (count - 1));
                    return a;
            }
        }
        if (isLast) {
            // Backbone bond goes LEFT (π). Place terminals in right hemisphere.
            switch(count) {
                case 1: return [0];
                case 2: return [-Math.PI/3, Math.PI/3];
                case 3: return [-Math.PI/2, 0, Math.PI/2];
                default:
                    var a = [];
                    for (var t = 0; t < count; t++) a.push(-Math.PI/2 + Math.PI * t / (count - 1));
                    return a;
            }
        }
        // Middle: backbone at 0° and π. Terminals above/below.
        if (count === 1) return [-Math.PI/2];
        if (count === 2) return [-Math.PI/2, Math.PI/2];
        var a = [];
        for (var t = 0; t < count; t++) {
            a.push(t % 2 === 0 ? (-Math.PI/2 - Math.floor(t/2)*Math.PI/6) : (Math.PI/2 + Math.floor(t/2)*Math.PI/6));
        }
        return a;
    }

    // p5.js sketch for chain / multi-center molecules
    function createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding) {
        destroyCurrentSketch();

        var container = document.getElementById('lewisCanvasContainer');
        var w = container.clientWidth || 400;
        var h = Math.max(320, container.clientHeight || 320);

        currentP5 = new p5(function(p) {
            var n = backbone.length;
            var spacing = Math.min(w / (n + 1), 130);
            var startX = (w - spacing * (n - 1)) / 2;
            var cy = h / 2;
            var bondLen = Math.min(spacing * 0.55, 75);

            p.setup = function() {
                var canvas = p.createCanvas(w, h);
                canvas.parent('lewisCanvasContainer');
                p.textFont('Inter, sans-serif');
                p.noLoop();
            };

            p.draw = function() {
                var dark = isDarkMode();
                var bg = dark ? p.color(30, 41, 59) : p.color(255);
                var textCol = dark ? p.color(226, 232, 240) : p.color(15, 23, 42);
                var bondCol = dark ? p.color(148, 163, 184) : p.color(100, 116, 139);
                var lonePairCol = dark ? p.color(129, 230, 217) : p.color(16, 185, 129);

                p.background(bg);

                // Backbone positions
                var bbPos = [];
                for (var i = 0; i < n; i++) {
                    bbPos.push({ x: startX + spacing * i, y: cy });
                }

                // Terminal positions
                var termPos = [];
                for (var i = 0; i < n; i++) {
                    var terms = termsPerAtom[i];
                    if (!terms || terms.length === 0) continue;

                    var isFirst  = (i === 0);
                    var isLast   = (i === n - 1);
                    var isMiddle = (!isFirst && !isLast);
                    var angles = getTerminalAngles(terms.length, isFirst, isMiddle, isLast);

                    for (var t = 0; t < terms.length; t++) {
                        termPos.push({
                            x: bbPos[i].x + Math.cos(angles[t]) * bondLen,
                            y: bbPos[i].y + Math.sin(angles[t]) * bondLen,
                            el: terms[t],
                            parent: i
                        });
                    }
                }

                // Draw backbone bonds (single / double / triple from analysis)
                var bbOrders = chainBonding ? chainBonding.bbBondOrders : [];
                for (var i = 0; i < n - 1; i++) {
                    var order = (bbOrders[i] || 1);
                    drawMultiBond(p, bbPos[i].x, bbPos[i].y, bbPos[i+1].x, bbPos[i+1].y,
                        order, bondCol, 4);
                }

                // Draw terminal bonds (single)
                for (var t = 0; t < termPos.length; t++) {
                    drawMultiBond(p, bbPos[termPos[t].parent].x, bbPos[termPos[t].parent].y,
                        termPos[t].x, termPos[t].y, 1, bondCol, 2.5);
                }

                // Draw lone pairs on terminal atoms (from analysis or fallback)
                var tLonePairs = chainBonding ? chainBonding.termLonePairs : null;
                var tIdx = 0;
                for (var i = 0; i < n; i++) {
                    var terms = termsPerAtom[i];
                    if (!terms) continue;
                    for (var t = 0; t < terms.length; t++) {
                        var lpCount = 0;
                        if (tLonePairs && tLonePairs[i] && tLonePairs[i][t] !== undefined) {
                            lpCount = tLonePairs[i][t];
                        } else if (terms[t] !== 'H') {
                            var elV = valenceElectrons[terms[t]] || 0;
                            lpCount = (elV > 1) ? Math.floor((elV - 1) / 2) : 0;
                        }
                        // Find this terminal in termPos
                        var tp = null;
                        for (var k = 0; k < termPos.length; k++) {
                            if (termPos[k].parent === i && termPos[k].el === terms[t]) {
                                tp = termPos[k];
                                termPos[k] = {x: tp.x, y: tp.y, el: '_used_', parent: tp.parent};
                                break;
                            }
                        }
                        if (!tp) continue;
                        if (lpCount > 0) {
                            var lpAngle = Math.atan2(tp.y - bbPos[i].y, tp.x - bbPos[i].x);
                            drawLonePairDots(p, tp.x, tp.y, lpAngle, 22, lonePairCol);
                        }
                    }
                }
                // Restore termPos (fix _used_ markers)
                termPos = [];
                for (var i = 0; i < n; i++) {
                    var terms = termsPerAtom[i];
                    if (!terms || terms.length === 0) continue;
                    var isFirst  = (i === 0);
                    var isLast   = (i === n - 1);
                    var isMiddle = (!isFirst && !isLast);
                    var angles = getTerminalAngles(terms.length, isFirst, isMiddle, isLast);
                    for (var t = 0; t < terms.length; t++) {
                        termPos.push({
                            x: bbPos[i].x + Math.cos(angles[t]) * bondLen,
                            y: bbPos[i].y + Math.sin(angles[t]) * bondLen,
                            el: terms[t], parent: i
                        });
                    }
                }

                // Draw lone pairs on backbone atoms
                var bbLP = chainBonding ? chainBonding.bbLonePairs : [];
                for (var i = 0; i < n; i++) {
                    var lpCount = bbLP[i] || 0;
                    if (lpCount > 0) {
                        // Place lone pairs above/below backbone
                        for (var lp = 0; lp < Math.min(lpCount, 3); lp++) {
                            var lpAngle;
                            if (lpCount === 1) {
                                lpAngle = -Math.PI / 2;
                            } else if (lpCount === 2) {
                                lpAngle = (lp === 0) ? -Math.PI / 2 : Math.PI / 2;
                            } else {
                                lpAngle = -Math.PI / 2 + lp * Math.PI / 2;
                            }
                            drawLonePairDots(p, bbPos[i].x, bbPos[i].y, lpAngle, 28, lonePairCol);
                        }
                    }
                }

                // Draw terminal atom circles
                for (var t = 0; t < termPos.length; t++) {
                    var elColor = elementColors[termPos[t].el] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(1.5);
                    p.fill(elColor[0], elColor[1], elColor[2], dark ? 200 : 230);
                    p.ellipse(termPos[t].x, termPos[t].y, 32, 32);

                    var isLight = elementTextDark(elColor);
                    p.fill(isLight ? (dark ? 20 : 30) : (dark ? 240 : 255));
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text(termPos[t].el, termPos[t].x, termPos[t].y);
                }

                // Draw backbone atoms (on top, larger)
                for (var i = 0; i < n; i++) {
                    var elColor = elementColors[backbone[i]] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(2);
                    p.fill(elColor[0], elColor[1], elColor[2], dark ? 220 : 240);
                    p.ellipse(bbPos[i].x, bbPos[i].y, 42, 42);

                    var isBBLight = elementTextDark(elColor);
                    p.fill(isBBLight ? (dark ? 20 : 30) : (dark ? 240 : 255));
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(15);
                    p.textStyle(p.BOLD);
                    p.text(backbone[i], bbPos[i].x, bbPos[i].y);
                }

                // Title
                p.fill(dark ? p.color(148, 163, 184) : p.color(100, 116, 139));
                p.textSize(11);
                p.textStyle(p.NORMAL);
                p.textAlign(p.CENTER, p.TOP);
                p.text('Lewis Structure: ' + formatFormulaText(formulaStr) +
                    (charge !== 0 ? ' (' + (charge > 0 ? '+' : '') + charge + ')' : ''), w/2, 10);
            };
        }, container);
    }

    // Generate condensed notation for chain molecules: "H₃C — CF₃"
    function generateChainNotation(backbone, termsPerAtom) {
        var parts = [];
        for (var i = 0; i < backbone.length; i++) {
            var grouped = {};
            (termsPerAtom[i] || []).forEach(function(el) { grouped[el] = (grouped[el] || 0) + 1; });
            var termStr = '';
            for (var el in grouped) { termStr += el + (grouped[el] > 1 ? grouped[el] : ''); }
            // Convention: first atom gets terminals before symbol, rest after
            parts.push(i === 0 ? termStr + backbone[i] : backbone[i] + termStr);
        }
        return parts.join(' \u2014 ');
    }

    // ========== DARK MODE OBSERVER ==========
    var themeObserver = new MutationObserver(function() {
        if (currentP5) {
            currentP5.redraw();
        }
    });
    themeObserver.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

    // ========== GENERATE LEWIS STRUCTURE ==========
    function generateLewis() {
        var formula = document.getElementById('molecularFormula').value.trim();
        var charge = parseInt(document.getElementById('molecularCharge').value) || 0;

        if (!formula) {
            ToolUtils.showToast('Please enter a molecular formula', 2000, 'warning');
            return;
        }

        try {
            var atoms = parseMolecularFormula(formula);
            var totalValence = 0;
            var hasGenericSymbol = false;

            for (var element in atoms) {
                if (!valenceElectrons[element]) {
                    ToolUtils.showToast('Unknown element: ' + element, 3000, 'error');
                    return;
                }
                if (genericSymbols.indexOf(element) !== -1) {
                    hasGenericSymbol = true;
                }
                totalValence += valenceElectrons[element] * atoms[element];
            }

            totalValence -= charge;

            var atomKeys = Object.keys(atoms);
            var centralAtom = atomKeys.find(function(a) { return a !== 'H' && a !== 'F'; }) || atomKeys[0];

            var totalAtoms = Object.values(atoms).reduce(function(a, b) { return a + b; }, 0);
            var numBonds = totalAtoms - 1;
            var bondingElectrons = numBonds * 2;
            var remainingElectrons = totalValence - bondingElectrons;

            var formulaStr = Object.entries(atoms).map(function(e) { return e[0] + (e[1] > 1 ? e[1] : ''); }).join('');

            // Detect multi-center (chain) molecules: 2+ of the central atom
            var centralCount = atoms[centralAtom] || 0;
            var isChain = centralCount >= 2;
            var backbone, termsPerAtom;

            if (isChain) {
                // Build backbone from central atoms
                backbone = [];
                for (var k = 0; k < centralCount; k++) backbone.push(centralAtom);

                // Everything else is terminal
                var allTerminals = [];
                for (var el in atoms) {
                    if (el === centralAtom) continue;
                    for (var k = 0; k < atoms[el]; k++) allTerminals.push(el);
                }

                // Distribute terminals by valence capacity
                termsPerAtom = [];
                for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);
                var remaining = allTerminals.slice();
                for (var k = 0; k < backbone.length && remaining.length > 0; k++) {
                    var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
                    var maxT = Math.max(0, getMaxBonds(backbone[k]) - bbBonds);
                    termsPerAtom[k] = remaining.splice(0, maxT);
                }
                // Overflow goes to last atom (expanded octet)
                if (remaining.length > 0) {
                    termsPerAtom[backbone.length - 1] = termsPerAtom[backbone.length - 1].concat(remaining);
                }

                var chainBonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);
                createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding);
            } else {
                var bonding = analyzeBonding(atoms, centralAtom, totalValence);
                createLewisSketch(atoms, centralAtom, totalValence, charge, bonding);
            }

            // Helper: describe bond orders as text
            function describeBondOrders(orders) {
                var singles = 0, doubles = 0, triples = 0;
                for (var i = 0; i < orders.length; i++) {
                    if (orders[i] === 1) singles++;
                    else if (orders[i] === 2) doubles++;
                    else if (orders[i] >= 3) triples++;
                }
                var parts = [];
                if (triples > 0) parts.push(triples + ' triple');
                if (doubles > 0) parts.push(doubles + ' double');
                if (singles > 0) parts.push(singles + ' single');
                return parts.join(', ');
            }

            // Build result HTML
            var html = '';
            html += buildMoleculeHeader(formulaStr, charge);

            if (hasGenericSymbol) {
                html += '<div class="lewis-alert lewis-alert-warning" style="margin-bottom:0.75rem;">Generic notation detected. Using textbook values (M=4e\u207b, A=4e\u207b, X=7e\u207b, L=7e\u207b, E=6e\u207b, R=1e\u207b, G=8e\u207b).</div>';
            }

            // Radical warning
            if (totalValence % 2 !== 0) {
                html += '<div class="lewis-alert lewis-alert-warning" style="margin-bottom:0.75rem;">\u26a0\ufe0f <strong>Radical species:</strong> ' + totalValence + ' valence electrons (odd count). One electron remains unpaired on the central atom.</div>';
            }

            // Oxyacid warning: when H and O are both peripherals to a non-H/O/F central atom
            if (!isChain && atoms['H'] && atoms['O'] && centralAtom !== 'H' && centralAtom !== 'O' && centralAtom !== 'F') {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#f59e0b;">\ud83d\udca1 <strong>Note:</strong> In oxyacids like <span class="lewis-chem">' + formatFormulaHtml(formulaStr) + '</span>, H atoms usually bond to O (forming O\u2013H groups), not directly to ' + centralAtom + '. The actual connectivity is more complex than a simple star layout.</div>';
            }

            html += '<div class="lewis-info-grid">';
            html += '<div class="lewis-info-card"><strong>Total Valence e\u207b</strong><span>' + totalValence + '</span></div>';
            html += '<div class="lewis-info-card"><strong>Bonding e\u207b</strong><span>' + bondingElectrons + '</span></div>';
            html += '<div class="lewis-info-card"><strong>Remaining e\u207b</strong><span>' + remainingElectrons + '</span></div>';
            html += '</div>';

            if (isChain) {
                // Chain-specific results
                var chainNotation = generateChainNotation(backbone, termsPerAtom);
                var bbOrders = chainBonding.bbBondOrders;

                html += '<div class="lewis-result-label">Backbone Chain</div>';
                html += '<div class="lewis-result-value"><span class="lewis-chem">';
                for (var bi = 0; bi < backbone.length; bi++) {
                    html += backbone[bi];
                    if (bi < backbone.length - 1) {
                        var bo = bbOrders[bi] || 1;
                        html += (bo === 3 ? ' \u2261 ' : bo === 2 ? ' = ' : ' \u2014 ');
                    }
                }
                html += '</span> (' + backbone.length + ' ' + centralAtom + ' atoms)</div>';

                html += '<div class="lewis-result-label">Condensed Structure</div>';
                html += '<div class="lewis-result-value"><span class="lewis-chem">' + formatFormulaHtml(chainNotation) + '</span></div>';

                html += '<div class="lewis-result-label">Bond Types</div>';
                var allChainOrders = bbOrders.slice();
                for (var bi = 0; bi < termsPerAtom.length; bi++) {
                    for (var ti = 0; ti < termsPerAtom[bi].length; ti++) allChainOrders.push(1);
                }
                html += '<div class="lewis-result-value">' + describeBondOrders(allChainOrders) + ' bond' + (allChainOrders.length !== 1 ? 's' : '') + '</div>';

                // Backbone lone pairs
                var bbLP = chainBonding.bbLonePairs;
                var hasAnyBBLP = false;
                for (var bi = 0; bi < bbLP.length; bi++) { if (bbLP[bi] > 0) hasAnyBBLP = true; }
                if (hasAnyBBLP) {
                    html += '<div class="lewis-result-label">Backbone Lone Pairs</div>';
                    html += '<div class="lewis-result-value">';
                    for (var bi = 0; bi < backbone.length; bi++) {
                        if (bbLP[bi] > 0) html += backbone[bi] + (bi+1) + ': ' + bbLP[bi] + ' pair' + (bbLP[bi] !== 1 ? 's' : '') + '  ';
                    }
                    html += '</div>';
                }
            } else {
                // Single-center results
                html += '<div class="lewis-result-label">Central Atom</div>';
                html += '<div class="lewis-result-value"><span class="lewis-chem">' + centralAtom + '</span>' +
                    (bonding.centralLonePairs > 0 ? ' (' + bonding.centralLonePairs + ' lone pair' + (bonding.centralLonePairs !== 1 ? 's' : '') + ')' : ' (no lone pairs)') + '</div>';

                html += '<div class="lewis-result-label">Bond Types</div>';
                html += '<div class="lewis-result-value">' + describeBondOrders(bonding.bondOrders) + ' bond' + (bonding.peripherals.length !== 1 ? 's' : '') + ' to ' + totalAtoms + ' atom' + (totalAtoms !== 1 ? 's' : '') + '</div>';

                // Show peripheral lone pairs summary
                var pHasLP = false;
                for (var pi = 0; pi < bonding.peripheralLonePairs.length; pi++) { if (bonding.peripheralLonePairs[pi] > 0) pHasLP = true; }
                if (pHasLP) {
                    html += '<div class="lewis-result-label">Peripheral Lone Pairs</div>';
                    html += '<div class="lewis-result-value">';
                    var lpSummary = {};
                    for (var pi = 0; pi < bonding.peripherals.length; pi++) {
                        var pEl = bonding.peripherals[pi];
                        var pLP = bonding.peripheralLonePairs[pi];
                        if (pLP > 0) {
                            if (!lpSummary[pEl + ':' + pLP]) lpSummary[pEl + ':' + pLP] = { el: pEl, lp: pLP, count: 0 };
                            lpSummary[pEl + ':' + pLP].count++;
                        }
                    }
                    var lpParts = [];
                    for (var key in lpSummary) {
                        var s = lpSummary[key];
                        lpParts.push((s.count > 1 ? 'each ' : '') + s.el + ': ' + s.lp + ' pair' + (s.lp !== 1 ? 's' : ''));
                    }
                    html += lpParts.join(', ');
                    html += '</div>';
                }

                // Resonance note
                if (bonding.hasResonance) {
                    html += '<div class="lewis-alert" style="margin-top:0.75rem;border-left-color:#f59e0b;">\u21c4 <strong>Resonance:</strong> Equivalent atoms have different bond orders in this structure. In reality, the electrons are delocalized \u2014 draw all equivalent resonance structures.</div>';
                }
            }

            document.getElementById('resultDisplay').innerHTML = html;
            document.getElementById('resultActions').classList.add('visible');
            currentResultText = 'Lewis Structure: ' + formatFormulaText(formulaStr) +
                '\nTotal Valence Electrons: ' + totalValence +
                (isChain
                    ? '\nCondensed: ' + formatFormulaText(generateChainNotation(backbone, termsPerAtom)) +
                      '\nBackbone bonds: ' + chainBonding.bbBondOrders.map(function(o) { return o === 3 ? 'triple' : o === 2 ? 'double' : 'single'; }).join(', ')
                    : '\nCentral Atom: ' + centralAtom + ' (' + bonding.centralLonePairs + ' lone pairs)' +
                      '\nBonds: ' + describeBondOrders(bonding.bondOrders));

        } catch (error) {
            ToolUtils.showToast('Error: ' + error.message, 3000, 'error');
        }
    }

    function generateLewisNotation(atoms, central) {
        var peripheralAtoms = [];
        for (var element in atoms) {
            if (element === central && atoms[element] === 1) continue;
            var count = (element === central) ? atoms[element] - 1 : atoms[element];
            for (var i = 0; i < count; i++) {
                peripheralAtoms.push(element);
            }
        }

        if (peripheralAtoms.length <= 2) {
            var notation = (peripheralAtoms[0] || '') + ' \u2014 ' + central;
            if (peripheralAtoms[1]) notation += ' \u2014 ' + peripheralAtoms[1];
            return notation;
        } else {
            var notation = '       ' + (peripheralAtoms[0] || '') + '\n';
            notation += '       |\n';
            notation += (peripheralAtoms[2] || '') + ' \u2014 ' + central + ' \u2014 ' + (peripheralAtoms[1] || '') + '\n';
            notation += '       |\n';
            notation += '       ' + (peripheralAtoms[3] || '');
            return notation;
        }
    }

    // ========== PREDICT VSEPR GEOMETRY ==========
    function predictVSEPR() {
        var bonds = parseInt(document.getElementById('bondingPairs').value);
        var lone = parseInt(document.getElementById('lonePairs').value);
        var atom = document.getElementById('centralAtom').value.trim() || 'A';

        if (isNaN(bonds) || bonds < 1) {
            ToolUtils.showToast('Please enter number of bonding pairs', 2000, 'warning');
            return;
        }
        if (isNaN(lone) || lone < 0) {
            ToolUtils.showToast('Please enter number of lone pairs (0 or more)', 2000, 'warning');
            return;
        }

        var stericNumber = bonds + lone;
        var key = stericNumber + '-' + lone;
        var geometry = vseprData[key];

        if (!geometry) {
            ToolUtils.showToast('No VSEPR data for this combination', 3000, 'error');
            return;
        }

        // Polarity — based on molecular geometry symmetry, not lone pair count
        // Symmetric molecular shapes are nonpolar (with identical ligands)
        var symmetricShapes = {
            'Linear': true, 'Trigonal Planar': true, 'Tetrahedral': true,
            'Trigonal Bipyramidal': true, 'Octahedral': true, 'Square Planar': true,
            'Pentagonal Bipyramidal': true, 'Pentagonal Planar': true
        };
        var polarity = 'Unknown';
        var polarityClass = '';
        if (bonds === 1) {
            // Single bond = always polar dipole
            polarity = 'Polar';
            polarityClass = 'polar';
        } else if (symmetricShapes[geometry.molecular]) {
            // Symmetric molecular geometry → nonpolar (if identical ligands)
            polarity = 'Nonpolar (symmetric' + (lone > 0 ? ', despite lone pairs' : '') + ')';
            polarityClass = 'nonpolar';
        } else {
            // Asymmetric molecular geometry → polar
            polarity = 'Polar (asymmetric)';
            polarityClass = 'polar';
        }

        // Generate p5 visualization
        createVSEPRSketch(bonds, lone, atom, geometry);

        // Build result HTML
        var html = '';

        // VSEPR header banner
        html += '<div class="lewis-molecule-header">';
        html += '<span class="lewis-formula">' + (atom || 'A') + 'X<sub>' + bonds + '</sub>E<sub>' + lone + '</sub></span>';
        html += '<span class="lewis-molecule-meta">VSEPR Geometry Prediction</span>';
        html += '</div>';

        html += '<div class="lewis-info-grid">';
        html += '<div class="lewis-info-card"><strong>Bonding Pairs</strong><span>' + bonds + '</span></div>';
        html += '<div class="lewis-info-card"><strong>Lone Pairs</strong><span>' + lone + '</span></div>';
        html += '<div class="lewis-info-card"><strong>Steric Number</strong><span>' + stericNumber + '</span></div>';
        html += '</div>';

        html += '<div class="lewis-result-label">Electron Geometry</div>';
        html += '<div class="lewis-result-value"><span class="lewis-badge">' + geometry.electron + '</span></div>';

        html += '<div class="lewis-result-label">Molecular Geometry</div>';
        html += '<div class="lewis-result-value"><span class="lewis-badge">' + geometry.molecular + '</span></div>';

        html += '<div class="lewis-result-label">Bond Angle</div>';
        html += '<div class="lewis-result-value" style="font-family:\'JetBrains Mono\',monospace;font-weight:600;font-size:1.1rem;">' + geometry.angle + '</div>';

        html += '<div class="lewis-result-label">Polarity</div>';
        html += '<div class="lewis-result-value"><span class="lewis-badge ' + polarityClass + '">' + polarity + '</span></div>';

        html += '<div class="lewis-result-label">Examples</div>';
        html += '<div class="lewis-result-value"><span class="lewis-chem">' + geometry.example + '</span></div>';

        html += '<div class="lewis-alert"><strong>Explanation:</strong> With ' + bonds + ' bonding region' + (bonds !== 1 ? 's' : '') + ' and ' + lone + ' lone pair' + (lone !== 1 ? 's' : '') + ', the steric number is ' + stericNumber + ', giving ' + geometry.electron.toLowerCase() + ' electron geometry. ';
        if (lone === 0) {
            html += 'All positions are bonds, maintaining ideal angles.';
        } else if (polarityClass === 'nonpolar') {
            html += 'Despite having ' + lone + ' lone pair' + (lone !== 1 ? 's' : '') + ', the molecular geometry (' + geometry.molecular + ') is symmetric, so the dipole moments cancel &mdash; making it <strong>nonpolar</strong> (with identical ligands).';
        } else {
            html += 'Lone pairs occupy more space than bonding pairs, compressing bond angles and creating an asymmetric charge distribution &mdash; making it <strong>polar</strong>.';
        }
        html += '</div>';

        document.getElementById('resultDisplay').innerHTML = html;
        document.getElementById('resultActions').classList.add('visible');
        currentResultText = 'VSEPR Prediction: ' + atom + '\nBonds: ' + bonds + ', Lone Pairs: ' + lone + '\nElectron Geometry: ' + geometry.electron + '\nMolecular Geometry: ' + geometry.molecular + '\nBond Angle: ' + geometry.angle + '\nPolarity: ' + polarity;
    }

    // ========== CALCULATE FORMAL CHARGE ==========
    function calculateFormalCharge() {
        var atom = document.getElementById('formalAtom').value.trim();
        var valence = parseInt(document.getElementById('formalValence').value);
        var nonBonding = parseInt(document.getElementById('formalNonBonding').value);
        var bonding = parseInt(document.getElementById('formalBonding').value);

        if (!atom || isNaN(valence) || isNaN(nonBonding) || isNaN(bonding)) {
            ToolUtils.showToast('Please fill in all fields', 2000, 'warning');
            return;
        }

        var formalCharge = valence - nonBonding - (bonding / 2);

        var chargeStr = '';
        if (formalCharge > 0) chargeStr = '+' + formalCharge;
        else if (formalCharge < 0) chargeStr = String(formalCharge);
        else chargeStr = '0 (neutral)';

        var interpretation = '';
        var fcClass = 'neutral';
        if (formalCharge === 0) {
            interpretation = 'This atom has a neutral formal charge, which is ideal.';
        } else if (formalCharge > 0) {
            interpretation = 'Positive formal charge indicates electron deficiency. Consider if resonance structures exist.';
            fcClass = 'positive';
        } else {
            interpretation = 'Negative formal charge indicates excess electrons. This is favorable on electronegative atoms.';
            fcClass = 'negative';
        }

        // No canvas for formal charge - just text results
        destroyCurrentSketch();
        var emptyState = document.getElementById('emptyState');
        if (emptyState) emptyState.style.display = 'none';

        var html = '';

        // Formal charge header
        html += '<div class="lewis-molecule-header">';
        html += '<span class="lewis-formula">' + atom + '</span>';
        html += '<span class="lewis-molecule-meta">Formal Charge Calculation</span>';
        html += '</div>';

        html += '<div class="lewis-result-label">Formula</div>';
        html += '<div class="lewis-result-value"><pre>FC = V \u2212 N \u2212 (B/2)\nFC = ' + valence + ' \u2212 ' + nonBonding + ' \u2212 (' + bonding + '/2)\nFC = ' + valence + ' \u2212 ' + nonBonding + ' \u2212 ' + (bonding/2) + '</pre></div>';

        html += '<div class="lewis-result-label">Formal Charge</div>';
        html += '<div class="lewis-fc-result ' + fcClass + '">' + chargeStr + '</div>';

        html += '<table class="lewis-fc-table">';
        html += '<tr><td>Valence electrons (V):</td><td style="font-family:\'JetBrains Mono\',monospace;font-weight:600;">' + valence + '</td></tr>';
        html += '<tr><td>Non-bonding electrons (N):</td><td style="font-family:\'JetBrains Mono\',monospace;font-weight:600;">' + nonBonding + '</td></tr>';
        html += '<tr><td>Bonding electrons (B):</td><td style="font-family:\'JetBrains Mono\',monospace;font-weight:600;">' + bonding + '</td></tr>';
        html += '<tr><td>Bonding electrons / 2:</td><td style="font-family:\'JetBrains Mono\',monospace;font-weight:600;">' + (bonding/2) + '</td></tr>';
        html += '</table>';

        html += '<div class="lewis-alert"><strong>Interpretation:</strong> ' + interpretation + '</div>';

        document.getElementById('resultDisplay').innerHTML = html;
        document.getElementById('resultActions').classList.add('visible');
        currentResultText = 'Formal Charge for ' + atom + ': ' + chargeStr + '\nV=' + valence + ', N=' + nonBonding + ', B=' + bonding + '\n' + interpretation;
    }

    // ========== TAB SWITCHING ==========
    document.querySelectorAll('.tool-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            var mode = this.getAttribute('data-tab');

            document.querySelectorAll('.tool-tab').forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');

            document.querySelectorAll('.tool-form-section').forEach(function(s) { s.classList.remove('active'); });
            document.getElementById(mode + 'Section').classList.add('active');
        });
    });

    // ========== QUICK EXAMPLE PILLS ==========
    document.querySelectorAll('.lewis-example-pill[data-formula]').forEach(function(pill) {
        pill.addEventListener('click', function() {
            document.getElementById('molecularFormula').value = this.getAttribute('data-formula');
            document.getElementById('molecularCharge').value = 0;
            generateLewis();
        });
    });

    document.querySelectorAll('.lewis-example-pill[data-vsepr]').forEach(function(pill) {
        pill.addEventListener('click', function() {
            var parts = this.getAttribute('data-vsepr').split(',');
            document.getElementById('bondingPairs').value = parts[0];
            document.getElementById('lonePairs').value = parts[1];
            predictVSEPR();
        });
    });

    // ========== FORMAL CHARGE AUTOFILL ==========
    document.getElementById('formalAtom').addEventListener('input', function() {
        var raw = this.value.trim();
        if (!raw) return;
        // Normalize: capitalize first letter, lowercase rest (e.g., "cl" -> "Cl")
        var atom = raw.charAt(0).toUpperCase() + raw.slice(1).toLowerCase();
        if (valenceElectrons[atom] !== undefined) {
            document.getElementById('formalValence').value = valenceElectrons[atom];
        }
    });

    // ========== BUTTON HANDLERS ==========
    document.getElementById('generateLewisBtn').addEventListener('click', generateLewis);
    document.getElementById('predictVSEPRBtn').addEventListener('click', predictVSEPR);
    document.getElementById('calcFormalBtn').addEventListener('click', calculateFormalCharge);

    // ========== RESULT ACTIONS (using ToolUtils) ==========
    document.getElementById('copyResultBtn').addEventListener('click', function() {
        if (currentResultText) {
            ToolUtils.copyToClipboard(currentResultText, {
                showToast: true,
                toastMessage: 'Result copied!',
                showSupportPopup: true,
                toolName: TOOL_NAME
            });
        }
    });

    document.getElementById('downloadPngBtn').addEventListener('click', function() {
        var canvas = document.querySelector('#lewisCanvasContainer canvas');
        if (canvas) {
            canvas.toBlob(function(blob) {
                var url = URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = url;
                a.download = 'lewis-structure.png';
                a.click();
                URL.revokeObjectURL(url);
                ToolUtils.showToast('PNG downloaded!', 2000, 'success');
            });
        } else {
            ToolUtils.showToast('No visualization to download', 2000, 'warning');
        }
    });

    document.getElementById('shareUrlBtn').addEventListener('click', function() {
        var formula = document.getElementById('molecularFormula').value.trim();
        if (formula) {
            ToolUtils.shareResult(formula, {
                paramName: 'formula',
                encode: false,
                copyToClipboard: true,
                showSupportPopup: true,
                toolName: TOOL_NAME
            });
        } else {
            ToolUtils.showToast('Enter a formula first to share', 2000, 'warning');
        }
    });

    // ========== URL PARAMETER LOADING ==========
    window.addEventListener('DOMContentLoaded', function() {
        var urlParams = new URLSearchParams(window.location.search);
        var formula = urlParams.get('formula');
        if (formula) {
            document.getElementById('molecularFormula').value = formula;
            // Wait for p5.js to load
            var checkP5 = setInterval(function() {
                if (typeof p5 !== 'undefined') {
                    clearInterval(checkP5);
                    generateLewis();
                }
            }, 100);
        }
    });
    </script>

    <!-- E-E-A-T JSON-LD Schemas -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Lewis Structure Generator & VSEPR Calculator | 8gwifi.org",
  "url": "https://8gwifi.org/lewis-structure-generator.jsp",
  "description": "Free Lewis Structure Generator with VSEPR theory, molecular geometry, bond angles, and polarity predictions.",
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://x.com/anish2good"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org"
  }
}
    </script>

    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/"},
    {"@type": "ListItem", "position": 2, "name": "Chemistry Tools", "item": "https://8gwifi.org/chemical-equation-balancer.jsp"},
    {"@type": "ListItem", "position": 3, "name": "Lewis Structure Generator", "item": "https://8gwifi.org/lewis-structure-generator.jsp"}
  ]
}
    </script>

    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Draw a Lewis Structure",
  "description": "Step-by-step guide to drawing Lewis dot structures for molecules",
  "step": [
    {"@type": "HowToStep", "position": 1, "name": "Count valence electrons", "text": "Add up all valence electrons from each atom. For ions, add electrons for negative charge or subtract for positive charge."},
    {"@type": "HowToStep", "position": 2, "name": "Arrange atoms", "text": "Place the least electronegative atom in the center (usually the unique atom). Hydrogen is always terminal."},
    {"@type": "HowToStep", "position": 3, "name": "Draw single bonds", "text": "Connect atoms with single bonds. Each bond uses 2 electrons."},
    {"@type": "HowToStep", "position": 4, "name": "Complete octets", "text": "Distribute remaining electrons as lone pairs to satisfy the octet rule (8 electrons for most atoms, 2 for hydrogen)."},
    {"@type": "HowToStep", "position": 5, "name": "Form multiple bonds", "text": "If central atom doesn't have an octet, form double or triple bonds by converting lone pairs from outer atoms."},
    {"@type": "HowToStep", "position": 6, "name": "Check formal charges", "text": "Calculate formal charges. The best structure has formal charges closest to zero."}
  ]
}
    </script>

    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is a Lewis structure?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "A Lewis structure (or Lewis dot diagram) is a representation of a molecule showing all valence electrons as dots or lines (bonds). It helps visualize bonding patterns, lone pairs, and formal charges in molecules."
      }
    },
    {
      "@type": "Question",
      "name": "What is VSEPR theory?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on electron pair repulsion. Electron domains (bonds and lone pairs) arrange themselves to minimize repulsion, determining the 3D shape of molecules."
      }
    },
    {
      "@type": "Question",
      "name": "How do you calculate formal charge?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Formal charge = (Valence electrons) - (Non-bonding electrons) - (Bonding electrons/2). The most stable Lewis structure has formal charges closest to zero, with negative charges on more electronegative atoms."
      }
    }
  ]
}
    </script>
</body>
</html>
