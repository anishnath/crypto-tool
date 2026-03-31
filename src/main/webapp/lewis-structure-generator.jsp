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

        /* FAQ */
        .faq-item{border:1px solid var(--border,#e2e8f0);border-radius:0.5rem;margin-bottom:0.5rem;overflow:hidden}
        .faq-question{padding:0.75rem 1rem;font-weight:600;font-size:0.875rem;color:var(--text-primary,#0f172a);background:var(--bg-secondary,#f8fafc);border:none;width:100%;cursor:pointer;display:flex;align-items:center;justify-content:space-between;gap:0.75rem;font-family:inherit;text-align:left}
        .faq-answer{display:none;padding:0.75rem 1rem;font-size:0.875rem;color:var(--text-secondary,#475569);line-height:1.6;border-top:1px solid var(--border,#e2e8f0)}
        .faq-item.open .faq-answer{display:block}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}
        [data-theme="dark"] .faq-question{background:var(--bg-tertiary,#334155);color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .faq-answer{color:var(--text-secondary,#cbd5e1);border-top-color:var(--border,#334155)}
        [data-theme="dark"] .faq-item{border-color:var(--border,#334155)}

        /* Utility */
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Lewis Structure Generator & VSEPR Calculator | 8gwifi.org" />
        <jsp:param name="toolDescription" value="Free Lewis Structure Generator with VSEPR theory, molecular geometry, bond angles, and polarity predictions. Printable practice worksheet for teachers and students. Draw Lewis dot structures, calculate formal charges, and visualize 3D molecular shapes." />
        <jsp:param name="toolCategory" value="Chemistry" />
        <jsp:param name="toolUrl" value="lewis-structure-generator.jsp" />
        <jsp:param name="toolKeywords" value="lewis structure, lewis dot structure, lewis structure worksheet, lewis structure practice sheet, lewis structure worksheet printable, vsepr theory, molecular geometry, electron geometry, bond angles, formal charge calculator, octet rule, valence electrons, molecular shape, polarity, chemistry worksheet for teachers" />
        <jsp:param name="toolImage" value="lewis-structure-og.png" />
        <jsp:param name="toolFeatures" value="Printable practice worksheet with answer key,Lewis structure generation,VSEPR geometry prediction,Formal charge calculation,Bond angle determination,Molecular polarity analysis,Interactive molecular visualization,Electron domain geometry,Octet rule validation" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Count valence electrons|Add up all valence electrons from each atom. For ions add for negative or subtract for positive charge,Arrange atoms|Place least electronegative atom in center. Hydrogen is always terminal,Draw single bonds|Connect atoms with single bonds. Each bond uses 2 electrons,Complete octets|Distribute remaining electrons as lone pairs for octet rule,Form multiple bonds|Convert lone pairs to double or triple bonds if central atom lacks octet,Check formal charges|Calculate formal charges. Best structure has charges closest to zero" />
        <jsp:param name="faq1q" value="What is a Lewis structure?" />
        <jsp:param name="faq1a" value="A Lewis structure (or Lewis dot diagram) is a representation of a molecule showing all valence electrons as dots or lines (bonds). It helps visualize bonding patterns, lone pairs, and formal charges in molecules." />
        <jsp:param name="faq2q" value="What is VSEPR theory?" />
        <jsp:param name="faq2a" value="VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on electron pair repulsion. Electron domains (bonds and lone pairs) arrange themselves to minimize repulsion, determining the 3D shape of molecules." />
        <jsp:param name="faq3q" value="How do you calculate formal charge?" />
        <jsp:param name="faq3a" value="Formal charge = (Valence electrons) - (Non-bonding electrons) - (Bonding electrons/2). The most stable Lewis structure has formal charges closest to zero, with negative charges on more electronegative atoms." />
        <jsp:param name="faq4q" value="Where can I get a free Lewis structure practice worksheet?" />
        <jsp:param name="faq4a" value="Click Practice Sheet on this page to generate a printable Lewis structure worksheet. Each click randomly selects 12 molecules from a pool of 80+ (H2O, CO2, NH3, O2, N2, SO2, XeF2, IF5, and more). Answer key with valence electrons, geometry, and bond angles included for teachers. Download as PDF. No signup required." />
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
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }
        .tool-form-actions .tool-action-btn {
            flex: 1 1 auto;
            min-width: 140px;
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
        .tool-result-actions-practice {
            display: flex;
            gap: 0.5rem;
            padding: 1rem 1.25rem;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
            flex-wrap: wrap;
        }

        .tool-result-actions {
            display: none;
            gap: 0.5rem;
            padding: 0 1.25rem 1rem 1.25rem;
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0 0 0.75rem 0.75rem;
            flex-wrap: wrap;
        }

        .tool-result-actions.visible { display: flex; }

        .tool-result-actions-practice .tool-action-btn,
        .tool-result-actions .tool-action-btn {
            flex: 1 1 auto;
            width: auto;
            min-width: 80px;
            margin-top: 0;
            padding: 0.6rem 0.5rem;
            font-size: 0.8rem;
        }

        /* Tool result card */
        .tool-result-card {
            display: flex;
            flex-direction: column;
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

            .tool-result-actions-practice,
            .tool-result-actions {
                flex-direction: column;
            }

            .tool-result-actions-practice .tool-action-btn,
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
            <p>Generate Lewis dot structures, predict molecular geometry using VSEPR theory, calculate bond angles, and analyze molecular polarity. <strong>Free printable practice worksheet</strong>—each click generates a random 12-molecule sheet from 80+ options (H&#8322;O, CO&#8322;, NH&#8323;, O&#8322;, N&#8322;, XeF&#8322;, IF&#8325;, and more). Drawing boxes and answer blanks included. No signup required.</p>
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
                    <button type="button" class="tool-action-btn" id="practiceSheetBtn" title="Generate a printable practice worksheet">
                        <span>&#128218;</span> Practice Sheet
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

                <a href="<%=request.getContextPath()%>/molecular-geometry-calculator.jsp" class="lewis-related-link" style="display:flex;align-items:center;gap:0.75rem;margin-top:1rem;padding:0.75rem 1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;text-decoration:none;color:var(--text-primary);font-size:0.875rem;transition:all 0.2s;" onmouseover="this.style.background='var(--bg-hover)'" onmouseout="this.style.background='var(--bg-secondary)'">
                    <span style="width:2rem;height:2rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.375rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1rem;color:#fff;">3D</span>
                    <div>
                        <strong>3D Molecular Geometry Calculator</strong>
                        <p style="margin:0.25rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">Interactive 3D models, PubChem coordinates, rotate & zoom molecules</p>
                    </div>
                </a>
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
                <button type="button" class="tool-action-btn" id="downloadPdfBtn">
                    <span>&#128196;</span> Download PDF
                </button>
                <button type="button" class="tool-action-btn" id="downloadPngBtn">
                    <span>&#8681;</span> Download PNG
                </button>
                <button type="button" class="tool-action-btn" id="copyResultBtn" style="background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border);">
                    <span>&#128203;</span> Copy
                </button>
                <button type="button" class="tool-action-btn" id="shareUrlBtn" style="background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border);">
                    <span>&#128279;</span> Share
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

    <!-- Free Lewis Structure Practice Worksheet -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem; border: 2px solid var(--tool-primary); background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.75rem; color: var(--text-primary);">Free Lewis Structure Practice Worksheet</h2>
        <p style="color: var(--text-secondary); line-height: 1.7; margin-bottom: 1rem;">
            Teachers and students: generate a <strong>printable practice worksheet</strong> with one click. Each click randomly picks 12 molecules from a pool of 80+ (H&#8322;O, CO&#8322;, NH&#8323;, O&#8322;, N&#8322;, SO&#8322;, XeF&#8322;, IF&#8325;, and more). <strong>Answer key</strong> with valence electrons, geometry, and bond angles included for teachers. Download as PDF—no signup required.
        </p>
    </div>

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

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a Lewis structure?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A Lewis structure (or Lewis dot diagram) is a representation of a molecule showing all valence electrons as dots or lines (bonds). It helps visualize bonding patterns, lone pairs, and formal charges in molecules.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is VSEPR theory?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on electron pair repulsion. Electron domains (bonds and lone pairs) arrange themselves to minimize repulsion, determining the 3D shape of molecules.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you calculate formal charge?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Formal charge = (Valence electrons) &minus; (Non-bonding electrons) &minus; (Bonding electrons/2). The most stable Lewis structure has formal charges closest to zero, with negative charges on more electronegative atoms.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Where can I get a free Lewis structure practice worksheet?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Click <strong>Practice Sheet</strong> on this page to generate a printable Lewis structure worksheet. Each click randomly selects 12 molecules from 80+ options. <strong>Answer key</strong> with valence electrons, geometry, and bond angles included for teachers. Download as PDF. No signup required.</div>
        </div>
    </div>

</section>

<!-- Molecular Structure Tools -->
<div style="max-width:1200px;margin:1.5rem auto;padding:0 1rem;display:flex;gap:10px;flex-wrap:wrap;">
  <span style="font-size:0.8rem;color:var(--text-secondary,#64748b);align-self:center;font-weight:600;">Also try &rarr;</span>
  <a href="<%=request.getContextPath()%>/chemistry/molecule-draw.jsp" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;background:var(--bg-secondary,#f1f5f9);border:1px solid var(--border-color,#e2e8f0);border-radius:8px;text-decoration:none;font-size:0.82rem;font-weight:600;color:var(--text-primary,#1e293b);transition:all 0.2s;" onmouseover="this.style.borderColor='#10b981';this.style.boxShadow='0 2px 8px rgba(16,185,129,0.15)'" onmouseout="this.style.borderColor='';this.style.boxShadow=''"><span style="background:linear-gradient(135deg,#10b981,#06b6d4);color:#fff;width:22px;height:22px;border-radius:5px;display:inline-flex;align-items:center;justify-content:center;font-size:0.75rem;">&#x270D;</span> Molecule Draw <span style="font-size:0.6rem;font-weight:700;background:#d946ef;color:#fff;padding:1px 5px;border-radius:3px;">NEW</span></a>
  <a href="<%=request.getContextPath()%>/molecular-geometry-calculator.jsp" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;background:var(--bg-secondary,#f1f5f9);border:1px solid var(--border-color,#e2e8f0);border-radius:8px;text-decoration:none;font-size:0.82rem;font-weight:600;color:var(--text-primary,#1e293b);transition:all 0.2s;" onmouseover="this.style.borderColor='#4f46e5';this.style.boxShadow='0 2px 8px rgba(79,70,229,0.15)'" onmouseout="this.style.borderColor='';this.style.boxShadow=''"><span style="background:linear-gradient(135deg,#4f46e5,#6366f1);color:#fff;width:22px;height:22px;border-radius:5px;display:inline-flex;align-items:center;justify-content:center;font-size:0.75rem;">&#x1F4D0;</span> 3D Molecular Geometry</a>
</div>

<!-- Related Chemistry Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="lewis-structure-generator.jsp"/>
    <jsp:param name="keyword" value="chemistry"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- Practice NCERT Problems -->
<section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 1.5rem;">
        <h2 style="font-size: 1.125rem; margin-bottom: 0.75rem;">Practice NCERT Problems</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1rem;">Apply your Lewis structure knowledge to NCERT chemistry and physics problems:</p>
        <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 0.75rem;">
            <li><a href="exams/books/ncert/class-11/physics-part-1/index.jsp" style="display: inline-block; padding: 0.5rem 1rem; background: var(--bg-secondary, #f1f5f9); border-radius: 0.5rem; color: var(--text-primary); text-decoration: none; font-size: 0.875rem; border: 1px solid var(--border, #e2e8f0);">Class 11 Physics Part 1</a></li>
            <li><a href="exams/books/ncert/class-12/physics-part-1/index.jsp" style="display: inline-block; padding: 0.5rem 1rem; background: var(--bg-secondary, #f1f5f9); border-radius: 0.5rem; color: var(--text-primary); text-decoration: none; font-size: 0.875rem; border: 1px solid var(--border, #e2e8f0);">Class 12 Physics Part 1</a></li>
        </ul>
    </div>
</section>

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

    // Preserve user-entered connectivity style for display (e.g., CH3OCH3 vs C2H6O).
    function normalizeFormulaForDisplay(formula) {
        var f = formula || '';
        f = f.replace(/[\u2080-\u2089]/g, function(ch) {
            return String(ch.charCodeAt(0) - 0x2080);
        });
        f = f.replace(/[\u2070\u00B9\u00B2\u00B3\u2074-\u2079]/g, function(ch) {
            var map = {'\u2070':'0','\u00B9':'1','\u00B2':'2','\u00B3':'3',
                '\u2074':'4','\u2075':'5','\u2076':'6','\u2077':'7',
                '\u2078':'8','\u2079':'9'};
            return map[ch] || ch;
        });
        f = f.replace(/[\u207A\u207B\u2212+\-]+$/, '');
        return f.replace(/\s+/g, '');
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
        // Remove any existing canvas or spinner content
        var existingCanvas = container.querySelector('canvas');
        if (existingCanvas) existingCanvas.remove();
        // Clear non-canvas children (e.g. loading spinner)
        var nonCanvas = container.querySelectorAll(':scope > div:not(.tool-empty-state)');
        for (var i = 0; i < nonCanvas.length; i++) nonCanvas[i].remove();
    }

    function isDarkMode() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    // ========== BONDING ANALYSIS ==========
    // Determines bond orders and lone pairs for accurate Lewis structures

    function analyzeBonding(atoms, centralAtom, totalValence) {
        // Special-case NO2 radical: one N=O and one N-O with an unpaired electron on N.
        if (centralAtom === 'N' &&
            (atoms['N'] || 0) === 1 &&
            (atoms['O'] || 0) === 2 &&
            Object.keys(atoms).length === 2 &&
            totalValence === 17) {
            return {
                peripherals: ['O', 'O'],
                bondOrders: [2, 1],
                peripheralLonePairs: [2, 3],
                centralLonePairs: 0,
                hasResonance: true,
                isRadical: true,
                unpairedElectrons: 1
            };
        }

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
        // Electron-deficient atoms (B, Be, Al) are stable with fewer than 8 electrons
        var electronDeficient = ['B', 'Be', 'Al'];
        var centralTarget = (centralAtom === 'H') ? 2 :
            (electronDeficient.indexOf(centralAtom) !== -1) ? centralE : 8;

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

    // ========== OXYACID BONDING ANALYSIS ==========
    function analyzeOxyacidBonding(atoms, centralAtom, totalValence) {
        var numH = atoms['H'] || 0;
        var numO = atoms['O'] || 0;

        // In oxyacids, H bonds to O (forming OH groups)
        // Remaining O forms double bonds with central atom
        var ohGroups = Math.min(numH, numO); // Number of O-H groups
        var doubleO = numO - ohGroups;        // Remaining O atoms (double bonded)

        // Build peripheral atoms: OH groups + double-bonded O
        var peripherals = [];
        var bondOrders = [];
        var peripheralLonePairs = [];

        // Add OH groups (single bond to central)
        for (var i = 0; i < ohGroups; i++) {
            peripherals.push('O');
            bondOrders.push(1);
            peripheralLonePairs.push(2); // O in OH has 2 lone pairs
        }

        // Add double-bonded O
        for (var i = 0; i < doubleO; i++) {
            peripherals.push('O');
            bondOrders.push(2);
            peripheralLonePairs.push(2); // O in =O has 2 lone pairs
        }

        // Calculate central atom lone pairs
        var centralE = 0;
        for (var i = 0; i < bondOrders.length; i++) {
            centralE += bondOrders[i] * 2;
        }

        var centralTarget = 8; // Most central atoms want octet
        var remaining = totalValence - centralE - (ohGroups * 2) - (numO * 4); // Account for O lone pairs and O-H bonds
        var centralLonePairs = Math.max(0, Math.floor((centralTarget - centralE) / 2));

        return {
            peripherals: peripherals,
            bondOrders: bondOrders,
            peripheralLonePairs: peripheralLonePairs,
            centralLonePairs: centralLonePairs,
            hasResonance: doubleO > 1, // Multiple double bonds = resonance
            isRadical: false,
            unpairedElectrons: 0,
            ohGroups: ohGroups,
            doubleO: doubleO
        };
    }

    // ========== RING BONDING ANALYSIS ==========
    function analyzeRingBonding(backbone, termsPerAtom, totalValence) {
        // For rings, all backbone bonds are single bonds initially
        var bbBonds = backbone.length; // Ring has same number of bonds as atoms
        var termBonds = 0;
        for (var i = 0; i < termsPerAtom.length; i++) {
            termBonds += termsPerAtom[i].length;
        }

        var remaining = totalValence - (bbBonds + termBonds) * 2;

        // Terminal atom lone pairs
        var termLonePairs = [];
        for (var i = 0; i < termsPerAtom.length; i++) {
            termLonePairs[i] = [];
            for (var j = 0; j < termsPerAtom[i].length; j++) {
                var term = termsPerAtom[i][j];
                if (term === 'H') {
                    termLonePairs[i].push(0);
                } else {
                    var need = 3; // Non-H terminal needs 3 pairs for octet
                    var canGive = Math.min(need, Math.floor(remaining / 2));
                    termLonePairs[i].push(canGive);
                    remaining -= canGive * 2;
                }
            }
        }

        // Backbone lone pairs
        var bbLonePairs = [];
        for (var i = 0; i < backbone.length; i++) {
            var bbBondCount = 2 + termsPerAtom[i].length; // 2 ring bonds + terminals
            var atomE = bbBondCount * 2;
            var target = 8;
            var need = Math.max(0, (target - atomE) / 2);
            var canGive = Math.min(need, Math.floor(remaining / 2));
            bbLonePairs[i] = canGive;
            remaining -= canGive * 2;
        }

        // Bond orders (all single for simple rings, or alternate for benzene)
        var bbBondOrders = [];
        var isBenzene = backbone.length === 6;

        // Check if it's benzene-like (6 carbons with few H)
        var totalH = 0;
        for (var i = 0; i < termsPerAtom.length; i++) {
            for (var j = 0; j < termsPerAtom[i].length; j++) {
                if (termsPerAtom[i][j] === 'H') totalH++;
            }
        }
        isBenzene = isBenzene && totalH === 6;

        for (var i = 0; i < backbone.length; i++) {
            if (isBenzene) {
                // Alternate single/double for benzene
                bbBondOrders.push(i % 2 === 0 ? 1 : 2);
            } else {
                bbBondOrders.push(1);
            }
        }

        return {
            bbBondOrders: bbBondOrders,
            bbLonePairs: bbLonePairs,
            termLonePairs: termLonePairs,
            isRing: true
        };
    }

    function analyzeChainBonding(backbone, termsPerAtom, totalValence) {
        var bbBonds = backbone.length - 1;
        var termBonds = 0;
        for (var i = 0; i < termsPerAtom.length; i++) termBonds += termsPerAtom[i].length;
        var remaining = totalValence - (bbBonds + termBonds) * 2;

        var termBondOrders = [];
        for (var i = 0; i < termsPerAtom.length; i++) {
            var arr = [];
            for (var t = 0; t < termsPerAtom[i].length; t++) arr.push(1);
            termBondOrders.push(arr);
        }

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
                for (var ti = 0; ti < termBondOrders[i].length; ti++) myBondE += termBondOrders[i][ti] * 2;
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
                    // Try upgrading a terminal bond attached to this atom (e.g., C=O).
                    if (!increased) {
                        for (var ti = 0; ti < termsPerAtom[i].length; ti++) {
                            var maxTermBond = getMaxBonds(termsPerAtom[i][ti]);
                            if (termsPerAtom[i][ti] !== 'H' &&
                                termLonePairs[i][ti] > 0 &&
                                termBondOrders[i][ti] < maxTermBond) {
                                termLonePairs[i][ti]--;
                                termBondOrders[i][ti]++;
                                atomE += 2;
                                increased = true;
                                break;
                            }
                        }
                    }
                    if (!increased) break;
                }
            }
        }

        // If adjacent backbone atoms are both electron-deficient, promote their bond order.
        function atomTarget(idx) {
            return (backbone[idx] === 'H') ? 2 : 8;
        }
        function atomElectronCount(idx) {
            var e = bbLonePairs[idx] * 2;
            if (idx > 0) e += bbBondOrders[idx - 1] * 2;
            if (idx < backbone.length - 1) e += bbBondOrders[idx] * 2;
            for (var ti = 0; ti < termBondOrders[idx].length; ti++) e += termBondOrders[idx][ti] * 2;
            return e;
        }
        var changed = true;
        var guard = 0;
        while (changed && guard < 8) {
            changed = false;
            guard++;
            for (var bi = 0; bi < bbBondOrders.length; bi++) {
                if (bbBondOrders[bi] >= 3) continue;
                var leftE = atomElectronCount(bi);
                var rightE = atomElectronCount(bi + 1);
                if (leftE < atomTarget(bi) && rightE < atomTarget(bi + 1)) {
                    bbBondOrders[bi]++;
                    changed = true;
                }
            }
        }

        return {
            bbBondOrders: bbBondOrders,
            bbLonePairs: bbLonePairs,
            termLonePairs: termLonePairs,
            termBondOrders: termBondOrders
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

    // Choose 2D bond angles for Lewis star-style sketches using VSEPR cues.
    function getLewisPeripheralAngles(peripheralCount, centralLonePairs, unpairedElectrons) {
        var n = peripheralCount || 0;
        if (n <= 0) return [];
        if (n === 1) return [0];

        var cLp = centralLonePairs || 0;
        var u = unpairedElectrons || 0;
        var effectiveLone = cLp + (u > 0 ? 1 : 0);
        var steric = n + effectiveLone;
        var key = steric + '-' + effectiveLone;
        var molecular = (vseprData[key] && vseprData[key].molecular) ? vseprData[key].molecular : '';

        if (n === 2) {
            var isLinearAX2 = molecular === 'Linear' || ((cLp >= 3) && u === 0);
            if (isLinearAX2) return [Math.PI, 0];

            var bondAngleDeg;
            if (cLp >= 2) bondAngleDeg = 104.5;
            else if (cLp === 1) bondAngleDeg = 118;
            else bondAngleDeg = 134; // odd-electron AX2 radicals such as NO2

            var half = (bondAngleDeg * Math.PI / 180) / 2;
            var bisector = Math.PI / 2; // Open downward; keep LP/radical dot above.
            return [bisector - half, bisector + half];
        }

        if (n === 3 && molecular === 'T-shaped') {
            return [Math.PI, 0, Math.PI / 2];
        }
        if (n === 3 && molecular === 'Trigonal Pyramidal') {
            return [-Math.PI / 2, Math.PI / 5, 4 * Math.PI / 5];
        }
        if (n === 3 && molecular === 'Trigonal Planar') {
            return [-Math.PI / 2, Math.PI / 6, 5 * Math.PI / 6];
        }

        if (n === 4 && molecular === 'Seesaw') {
            return [-Math.PI / 2, Math.PI / 2, -Math.PI / 6, 5 * Math.PI / 6];
        }
        if (n === 4 && molecular === 'Square Planar') {
            return [-Math.PI / 2, 0, Math.PI / 2, Math.PI];
        }
        if (n === 4 && molecular === 'Tetrahedral') {
            // Slightly skewed 2D projection so tetrahedral is not shown as perfect square-planar.
            return [-Math.PI / 2, -Math.PI / 8, 5 * Math.PI / 8, 9 * Math.PI / 8];
        }

        if (n === 5 && molecular === 'Trigonal Bipyramidal') {
            return [-Math.PI / 2, Math.PI / 2, 0, 2 * Math.PI / 3, -2 * Math.PI / 3];
        }
        if (n === 5 && molecular === 'Square Pyramidal') {
            return [-Math.PI / 2, 0, Math.PI / 2, Math.PI, -Math.PI / 4];
        }

        if (n === 6 && molecular === 'Octahedral') {
            return [-Math.PI / 2, Math.PI / 2, 0, Math.PI, -Math.PI / 4, 3 * Math.PI / 4];
        }

        var angles = [];
        for (var i = 0; i < n; i++) {
            angles.push((2 * Math.PI * i) / n - Math.PI / 2);
        }
        return angles;
    }

    // ========== p5.js: Lewis Structure Sketch ==========
    function createLewisSketch(atoms, centralAtom, totalValence, charge, bonding, formulaLabel) {
        destroyCurrentSketch();

        var container = document.getElementById('lewisCanvasContainer');
        var w = container.clientWidth || 400;
        var h = Math.max(320, container.clientHeight || 320);

        currentP5 = new p5(function(p) {
            var peripheralAtoms = bonding.peripherals;
            var bondOrders = bonding.bondOrders;
            var pLonePairs = bonding.peripheralLonePairs;
            var centralLonePairs = bonding.centralLonePairs;
            var unpairedElectrons = bonding.unpairedElectrons || 0;

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
                var pAngles = getLewisPeripheralAngles(peripheralAtoms.length, centralLonePairs, unpairedElectrons);
                var pPositions = [];
                for (var i = 0; i < peripheralAtoms.length; i++) {
                    var angle = (pAngles[i] !== undefined)
                        ? pAngles[i]
                        : ((2 * Math.PI * i) / peripheralAtoms.length - Math.PI / 2);
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
                    } else if (peripheralAtoms.length === 2) {
                        // Keep lone pairs on the opposite side of bent AX2 bonds (top side in this layout).
                        if (centralLonePairs === 1) {
                            lpAngles.push(-Math.PI / 2);
                        } else if (centralLonePairs === 2) {
                            lpAngles.push(-Math.PI / 2 - Math.PI / 6);
                            lpAngles.push(-Math.PI / 2 + Math.PI / 6);
                        } else if (centralLonePairs === 3) {
                            lpAngles.push(Math.PI);
                            lpAngles.push(-Math.PI / 2 - Math.PI / 5);
                            lpAngles.push(-Math.PI / 2 + Math.PI / 5);
                        } else if (centralLonePairs > 3) {
                            for (var lp = 0; lp < centralLonePairs; lp++) {
                                lpAngles.push(-Math.PI / 2 + (lp - (centralLonePairs - 1) / 2) * (Math.PI / 8));
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

                // Draw unpaired electron(s) on central atom for radicals.
                if (unpairedElectrons > 0) {
                    var maxDots = Math.min(unpairedElectrons, 3);
                    var baseAngle = -Math.PI / 2;
                    for (var ue = 0; ue < maxDots; ue++) {
                        var ueAngle = baseAngle + (ue - (maxDots - 1) / 2) * (Math.PI / 7);
                        var ux = cx + Math.cos(ueAngle) * (bondLen * 0.32);
                        var uy = cy + Math.sin(ueAngle) * (bondLen * 0.32);
                        p.fill(lonePairCol);
                        p.noStroke();
                        p.ellipse(ux, uy, 7, 7);
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
                var shownFormula = formulaLabel || Object.entries(atoms).map(function(e){ return e[0] + (e[1] > 1 ? e[1] : ''); }).join('');
                p.text('Lewis Structure: ' + formatFormulaText(shownFormula) + (charge !== 0 ? ' (' + (charge > 0 ? '+' : '') + charge + ')' : ''), w/2, 10);
            };
        }, container);
    }

    // ========== p5.js: Oxyacid Lewis Structure Sketch ==========
    function createOxyacidLewisSketch(atoms, centralAtom, totalValence, charge, bonding, formulaStr) {
        destroyCurrentSketch();

        var container = document.getElementById('lewisCanvasContainer');
        var w = container.clientWidth || 400;
        var h = Math.max(320, container.clientHeight || 320);

        currentP5 = new p5(function(p) {
            var peripherals = bonding.peripherals;
            var bondOrders = bonding.bondOrders;
            var pLonePairs = bonding.peripheralLonePairs;
            var centralLonePairs = bonding.centralLonePairs;
            var ohGroups = bonding.ohGroups;
            var doubleO = bonding.doubleO;

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

                // Compute peripheral O positions
                var pAngles = getLewisPeripheralAngles(peripherals.length, centralLonePairs, 0);
                var pPositions = [];
                for (var i = 0; i < peripherals.length; i++) {
                    var angle = (pAngles[i] !== undefined)
                        ? pAngles[i]
                        : ((2 * Math.PI * i) / peripherals.length - Math.PI / 2);
                    pPositions.push({
                        x: cx + Math.cos(angle) * bondLen,
                        y: cy + Math.sin(angle) * bondLen,
                        angle: angle
                    });
                }

                // Draw bonds from central to O atoms
                for (var i = 0; i < peripherals.length; i++) {
                    drawMultiBond(p, cx, cy, pPositions[i].x, pPositions[i].y,
                        bondOrders[i], bondCol, 3);
                }

                // Draw H atoms bonded to OH group oxygens
                var numH = atoms['H'] || 0;
                for (var i = 0; i < ohGroups && i < pPositions.length; i++) {
                    var oPos = pPositions[i];
                    var hAngle = oPos.angle; // H extends further out
                    var hx = oPos.x + Math.cos(hAngle) * 35;
                    var hy = oPos.y + Math.sin(hAngle) * 35;

                    // Draw O-H bond
                    p.stroke(bondCol);
                    p.strokeWeight(2.5);
                    p.line(oPos.x, oPos.y, hx, hy);

                    // Draw H atom
                    var hColor = elementColors['H'] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(1.5);
                    p.fill(hColor[0], hColor[1], hColor[2], dark ? 200 : 230);
                    p.ellipse(hx, hy, 30, 30);

                    p.fill(dark ? 20 : 30);
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text('H', hx, hy);
                }

                // Draw lone pairs on O atoms
                for (var i = 0; i < peripherals.length; i++) {
                    if (pLonePairs[i] > 0) {
                        var farAngle = pPositions[i].angle;
                        // For OH groups, lone pairs go to sides
                        // For =O, lone pairs go to sides
                        var lpDist = 22;
                        var angleOffset = (i < ohGroups) ? Math.PI / 3 : Math.PI / 2.5;

                        for (var lp = 0; lp < Math.min(pLonePairs[i], 2); lp++) {
                            var spreadAngle = farAngle + (lp === 0 ? angleOffset : -angleOffset);
                            drawLonePairDots(p, pPositions[i].x, pPositions[i].y,
                                spreadAngle, lpDist, lonePairCol);
                        }
                    }
                }

                // Draw O atom circles
                for (var i = 0; i < peripherals.length; i++) {
                    var elColor = elementColors['O'] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(1.5);
                    p.fill(elColor[0], elColor[1], elColor[2], dark ? 200 : 230);
                    p.ellipse(pPositions[i].x, pPositions[i].y, 36, 36);

                    p.fill(255);
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('O', pPositions[i].x, pPositions[i].y);
                }

                // Draw central atom circle
                var centerColor = elementColors[centralAtom] || elementColors['default'];
                p.stroke(dark ? 100 : 60);
                p.strokeWeight(2);
                p.fill(centerColor[0], centerColor[1], centerColor[2], dark ? 220 : 240);
                p.ellipse(cx, cy, 44, 44);

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
                p.text('Lewis Structure: ' + formatFormulaText(formulaStr) +
                    (charge !== 0 ? ' (' + (charge > 0 ? '+' : '') + charge + ')' : ''), w/2, 10);
            };
        }, container);
    }

    // ========== p5.js: Ring Lewis Structure Sketch ==========
    function createRingLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding) {
        destroyCurrentSketch();

        var container = document.getElementById('lewisCanvasContainer');
        var w = container.clientWidth || 400;
        var h = Math.max(320, container.clientHeight || 320);

        currentP5 = new p5(function(p) {
            var n = backbone.length;
            var radius = Math.min(w, h) * 0.28;
            var cx = w / 2;
            var cy = h / 2;
            var termBondLen = 50;

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

                // Calculate positions for ring atoms
                var ringPositions = [];
                for (var i = 0; i < n; i++) {
                    var angle = (2 * Math.PI * i) / n - Math.PI / 2;
                    ringPositions.push({
                        x: cx + Math.cos(angle) * radius,
                        y: cy + Math.sin(angle) * radius,
                        angle: angle
                    });
                }

                // Draw ring bonds
                var bbOrders = chainBonding.bbBondOrders;
                for (var i = 0; i < n; i++) {
                    var next = (i + 1) % n;
                    var order = bbOrders[i] || 1;
                    drawMultiBond(p, ringPositions[i].x, ringPositions[i].y,
                        ringPositions[next].x, ringPositions[next].y,
                        order, bondCol, 2.5);
                }

                // Draw terminal atoms and bonds
                for (var i = 0; i < n; i++) {
                    var terms = termsPerAtom[i] || [];
                    for (var t = 0; t < terms.length; t++) {
                        var termEl = terms[t];
                        var baseAngle = ringPositions[i].angle;
                        var spreadAngle = baseAngle;
                        if (terms.length > 1) {
                            spreadAngle = baseAngle + (t - (terms.length - 1) / 2) * 0.3;
                        }

                        var tx = ringPositions[i].x + Math.cos(spreadAngle) * termBondLen;
                        var ty = ringPositions[i].y + Math.sin(spreadAngle) * termBondLen;

                        // Draw bond
                        p.stroke(bondCol);
                        p.strokeWeight(2);
                        p.line(ringPositions[i].x, ringPositions[i].y, tx, ty);

                        // Draw terminal atom
                        var termColor = elementColors[termEl] || elementColors['default'];
                        p.stroke(dark ? 100 : 60);
                        p.strokeWeight(1.5);
                        p.fill(termColor[0], termColor[1], termColor[2], dark ? 200 : 230);
                        p.ellipse(tx, ty, 32, 32);

                        var isLight = elementTextDark(termColor);
                        p.fill(isLight ? (dark ? 20 : 30) : (dark ? 240 : 255));
                        p.noStroke();
                        p.textAlign(p.CENTER, p.CENTER);
                        p.textSize(12);
                        p.textStyle(p.BOLD);
                        p.text(termEl, tx, ty);
                    }
                }

                // Draw ring atom circles
                for (var i = 0; i < n; i++) {
                    var atomColor = elementColors[backbone[i]] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(1.5);
                    p.fill(atomColor[0], atomColor[1], atomColor[2], dark ? 210 : 235);
                    p.ellipse(ringPositions[i].x, ringPositions[i].y, 38, 38);

                    var isLight = elementTextDark(atomColor);
                    p.fill(isLight ? (dark ? 20 : 30) : (dark ? 240 : 255));
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text(backbone[i], ringPositions[i].x, ringPositions[i].y);
                }

                // Title
                p.fill(dark ? p.color(148, 163, 184) : p.color(100, 116, 139));
                p.textSize(11);
                p.textStyle(p.NORMAL);
                p.textAlign(p.CENTER, p.TOP);
                p.text('Lewis Structure (Ring): ' + formatFormulaText(formulaStr) +
                    (charge !== 0 ? ' (' + (charge > 0 ? '+' : '') + charge + ')' : ''), w/2, 10);
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
        var expanded = {
            'P': 5, 'S': 6, 'Cl': 7, 'Br': 7, 'I': 7,
            'Xe': 8, 'Se': 6, 'Te': 6, 'As': 5
        };
        if (expanded[el] !== undefined) return expanded[el];
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
    function createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding, termAttachedHydrogens) {
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
            var termAttachedH = termAttachedHydrogens ||
                (chainBonding && chainBonding.termAttachedHydrogens) || [];

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
                            parent: i,
                            termIndex: t,
                            hAttached: (termAttachedH[i] && termAttachedH[i][t]) ? termAttachedH[i][t] : 0
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

                // Draw terminal bonds (single/double/triple from analysis)
                var termOrders = chainBonding ? chainBonding.termBondOrders : null;
                for (var t = 0; t < termPos.length; t++) {
                    var tOrder = 1;
                    if (termOrders &&
                        termOrders[termPos[t].parent] &&
                        termOrders[termPos[t].parent][termPos[t].termIndex] !== undefined) {
                        tOrder = termOrders[termPos[t].parent][termPos[t].termIndex];
                    }
                    drawMultiBond(p, bbPos[termPos[t].parent].x, bbPos[termPos[t].parent].y,
                        termPos[t].x, termPos[t].y, tOrder, bondCol, 2.5);
                }

                // Draw hydrogens attached to terminal atoms (e.g., O-H in carboxylic acids).
                var attachedHPos = [];
                for (var t = 0; t < termPos.length; t++) {
                    var hCount = termPos[t].hAttached || 0;
                    if (hCount <= 0) continue;
                    var baseAngle = Math.atan2(
                        termPos[t].y - bbPos[termPos[t].parent].y,
                        termPos[t].x - bbPos[termPos[t].parent].x
                    );
                    for (var h = 0; h < hCount; h++) {
                        var hAngle = baseAngle + (hCount === 1 ? 0 : (h - (hCount - 1) / 2) * Math.PI / 8);
                        var hx = termPos[t].x + Math.cos(hAngle) * 42;
                        var hy = termPos[t].y + Math.sin(hAngle) * 42;
                        drawMultiBond(p, termPos[t].x, termPos[t].y, hx, hy, 1, bondCol, 2);
                        attachedHPos.push({x: hx, y: hy});
                    }
                }

                // Draw lone pairs on terminal atoms (from analysis or fallback)
                var tLonePairs = chainBonding ? chainBonding.termLonePairs : null;
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
                        var tp = null;
                        for (var k = 0; k < termPos.length; k++) {
                            if (termPos[k].parent === i && termPos[k].termIndex === t) {
                                tp = termPos[k];
                                break;
                            }
                        }
                        if (!tp) continue;
                        if (lpCount > 0) {
                            var lpAngle = Math.atan2(tp.y - bbPos[i].y, tp.x - bbPos[i].x);
                            for (var lp = 0; lp < Math.min(lpCount, 3); lp++) {
                                var spreadAngle;
                                if (lpCount === 1) {
                                    spreadAngle = lpAngle;
                                } else if (lpCount === 2) {
                                    spreadAngle = lpAngle + (lp === 0 ? -Math.PI / 5 : Math.PI / 5);
                                } else {
                                    spreadAngle = lpAngle + (lp - 1) * Math.PI / 4;
                                }
                                drawLonePairDots(p, tp.x, tp.y, spreadAngle, 22, lonePairCol);
                            }
                        }
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

                // Draw attached hydrogen atom circles/labels (for O-H groups).
                for (var h = 0; h < attachedHPos.length; h++) {
                    var hColor = elementColors['H'] || elementColors['default'];
                    p.stroke(dark ? 100 : 60);
                    p.strokeWeight(1.5);
                    p.fill(hColor[0], hColor[1], hColor[2], dark ? 200 : 230);
                    p.ellipse(attachedHPos[h].x, attachedHPos[h].y, 30, 30);
                    p.fill(dark ? 30 : 40);
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text('H', attachedHPos[h].x, attachedHPos[h].y);
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
    function generateChainNotation(backbone, termsPerAtom, termAttachedHydrogens) {
        var parts = [];
        for (var i = 0; i < backbone.length; i++) {
            var grouped = {};
            (termsPerAtom[i] || []).forEach(function(el, tIdx) {
                var token = el;
                var hAttached = (termAttachedHydrogens &&
                    termAttachedHydrogens[i] &&
                    termAttachedHydrogens[i][tIdx]) ? termAttachedHydrogens[i][tIdx] : 0;
                if (el === 'O' && hAttached > 0) token = 'OH';
                grouped[token] = (grouped[token] || 0) + 1;
            });
            var termStr = '';
            if (grouped['OH'] === 1 && grouped['O'] === 1 && Object.keys(grouped).length === 2) {
                // Carboxyl group notation around carbon.
                termStr = (i === 0) ? 'HOO' : 'OOH';
            } else {
                for (var el in grouped) { termStr += el + (grouped[el] > 1 ? grouped[el] : ''); }
            }
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

    // ========== PATTERN DETECTION FUNCTIONS ==========

    function canonicalFormulaKey(atoms, charge) {
        // Hill-system ordering: C, H, then alphabetical others.
        var keys = Object.keys(atoms);
        keys.sort(function(a, b) {
            if (a === 'C') return -1;
            if (b === 'C') return 1;
            if (a === 'H' && keys.indexOf('C') !== -1 && b !== 'C') return -1;
            if (b === 'H' && keys.indexOf('C') !== -1 && a !== 'C') return 1;
            return a.localeCompare(b);
        });
        var f = '';
        for (var i = 0; i < keys.length; i++) {
            var el = keys[i];
            f += el + (atoms[el] > 1 ? atoms[el] : '');
        }
        return f + '|' + charge;
    }

    var predefinedLewisTemplates = null;

    function getPredefinedLewisTemplate(atoms, charge) {
        var key = canonicalFormulaKey(atoms, charge);

        function buildOxoanionTemplate(centralAtom, oxygenBondOrders, ionCharge, label) {
            var lonePairs = oxygenBondOrders.map(function(order) {
                if (order >= 3) return 1;
                if (order === 2) return 2;
                return 3;
            });
            var totalValence = (valenceElectrons[centralAtom] || 0) +
                oxygenBondOrders.length * (valenceElectrons['O'] || 6) -
                (ionCharge || 0);
            var bondElectrons = oxygenBondOrders.reduce(function(sum, order) {
                return sum + order * 2;
            }, 0);
            var peripheralLonePairElectrons = lonePairs.reduce(function(sum, lp) {
                return sum + lp * 2;
            }, 0);
            var remaining = totalValence - bondElectrons - peripheralLonePairElectrons;
            if (remaining < 0) remaining = 0;
            var centralLonePairs = Math.floor(remaining / 2);
            var unpairedElectrons = remaining % 2;
            return {
                centralAtom: centralAtom,
                bonding: {
                    peripherals: oxygenBondOrders.map(function() { return 'O'; }),
                    bondOrders: oxygenBondOrders.slice(),
                    peripheralLonePairs: lonePairs,
                    centralLonePairs: centralLonePairs,
                    hasResonance: true,
                    isRadical: unpairedElectrons > 0,
                    unpairedElectrons: unpairedElectrons
                },
                isResonanceTemplate: true,
                note: 'Predefined ' + label + ' resonance template applied.'
            };
        }

        function buildGenericTemplate(centralAtom, peripheralAtom, count, label) {
            var bondOrders = [];
            var pLonePairs = [];
            for (var i = 0; i < count; i++) {
                bondOrders.push(1);
                if (peripheralAtom === 'R' || peripheralAtom === 'H') pLonePairs.push(0);
                else if (peripheralAtom === 'N') pLonePairs.push(2);
                else pLonePairs.push(3);
            }
            return {
                centralAtom: centralAtom,
                bonding: {
                    peripherals: bondOrders.map(function() { return peripheralAtom; }),
                    bondOrders: bondOrders,
                    peripheralLonePairs: pLonePairs,
                    centralLonePairs: 0,
                    hasResonance: false,
                    isRadical: false,
                    unpairedElectrons: 0
                },
                isResonanceTemplate: false,
                note: 'Predefined generic template (' + label + ') applied.'
            };
        }

        function buildChainTemplate(backbone, termsPerAtom, chainBonding, label, termAttachedHydrogens) {
            return {
                kind: 'chain',
                backbone: backbone,
                termsPerAtom: termsPerAtom,
                chainBonding: chainBonding,
                termAttachedHydrogens: termAttachedHydrogens || null,
                note: 'Predefined ' + label + ' template applied.'
            };
        }

        if (!predefinedLewisTemplates) {
            var templates = {
                // Common resonance-heavy ions: use predefined textbook contributors.
                'NO3|-1': buildOxoanionTemplate('N', [2, 1, 1], -1, 'nitrate'),
                'NO2|-1': buildOxoanionTemplate('N', [2, 1], -1, 'nitrite'),
                'CO3|-2': buildOxoanionTemplate('C', [2, 1, 1], -2, 'carbonate'),
                'O3S|-2': buildOxoanionTemplate('S', [2, 1, 1], -2, 'sulfite'),
                'O4S|-2': buildOxoanionTemplate('S', [2, 2, 1, 1], -2, 'sulfate'),
                'O3P|-3': buildOxoanionTemplate('P', [2, 1, 1], -3, 'phosphite'),
                'O4P|-3': buildOxoanionTemplate('P', [2, 1, 1, 1], -3, 'phosphate'),
                'ClO2|-1': buildOxoanionTemplate('Cl', [2, 1], -1, 'chlorite'),
                'ClO3|-1': buildOxoanionTemplate('Cl', [2, 1, 1], -1, 'chlorate'),
                'ClO4|-1': buildOxoanionTemplate('Cl', [2, 1, 1, 1], -1, 'perchlorate'),
                'BrO3|-1': buildOxoanionTemplate('Br', [2, 1, 1], -1, 'bromate'),
                'IO3|-1': buildOxoanionTemplate('I', [2, 1, 1], -1, 'iodate'),
                'CrO4|-2': buildOxoanionTemplate('Cr', [2, 2, 1, 1], -2, 'chromate'),
                'MnO4|-1': buildOxoanionTemplate('Mn', [2, 2, 2, 1], -1, 'permanganate'),
                'Cl3OP|0': {
                    centralAtom: 'P',
                    bonding: {
                        peripherals: ['O', 'Cl', 'Cl', 'Cl'],
                        bondOrders: [2, 1, 1, 1],
                        peripheralLonePairs: [2, 3, 3, 3],
                        centralLonePairs: 0,
                        hasResonance: false,
                        isRadical: false,
                        unpairedElectrons: 0
                    },
                    isResonanceTemplate: false,
                    note: 'Predefined phosphoryl chloride structure applied.'
                },
                'C2H4O2|0': buildChainTemplate(
                    ['C', 'C'],
                    [['H', 'H', 'H'], ['O', 'O']],
                    {
                        bbBondOrders: [1],
                        bbLonePairs: [0, 0],
                        termLonePairs: [[0, 0, 0], [2, 2]],
                        termBondOrders: [[1, 1, 1], [1, 2]],
                        termAttachedHydrogens: [[0, 0, 0], [1, 0]]
                    },
                    'acetic-acid-style',
                    [[0, 0, 0], [1, 0]]
                ),
                'C2H2O4|0': buildChainTemplate(
                    ['C', 'C'],
                    [['O', 'O'], ['O', 'O']],
                    {
                        bbBondOrders: [1],
                        bbLonePairs: [0, 0],
                        termLonePairs: [[2, 2], [2, 2]],
                        termBondOrders: [[1, 2], [1, 2]],
                        termAttachedHydrogens: [[1, 0], [1, 0]]
                    },
                    'oxalic-acid-style',
                    [[1, 0], [1, 0]]
                ),
                // Acetone (C3H6O): CH3-C(=O)-CH3
                'C3H6O|0': buildChainTemplate(
                    ['C', 'C', 'C'],
                    [['H', 'H', 'H'], ['O'], ['H', 'H', 'H']],
                    {
                        bbBondOrders: [1, 1],
                        bbLonePairs: [0, 0, 0],
                        termLonePairs: [[0, 0, 0], [2], [0, 0, 0]],
                        termBondOrders: [[1, 1, 1], [2], [1, 1, 1]]
                    },
                    'acetone'
                ),
                // Acetaldehyde (C2H4O): CH3-CHO
                'C2H4O|0': buildChainTemplate(
                    ['C', 'C'],
                    [['H', 'H', 'H'], ['O', 'H']],
                    {
                        bbBondOrders: [1],
                        bbLonePairs: [0, 0],
                        termLonePairs: [[0, 0, 0], [2, 0]],
                        termBondOrders: [[1, 1, 1], [2, 1]]
                    },
                    'acetaldehyde'
                ),
                // Methylamine (CH5N): CH3-NH2
                'CH5N|0': buildChainTemplate(
                    ['C', 'N'],
                    [['H', 'H', 'H'], ['H', 'H']],
                    {
                        bbBondOrders: [1],
                        bbLonePairs: [0, 1],
                        termLonePairs: [[0, 0, 0], [0, 0]],
                        termBondOrders: [[1, 1, 1], [1, 1]]
                    },
                    'methylamine'
                ),
                // Dichlorine monoxide (Cl2O): Cl-O-Cl with O central
                'Cl2O|0': {
                    centralAtom: 'O',
                    bonding: {
                        peripherals: ['Cl', 'Cl'],
                        bondOrders: [1, 1],
                        peripheralLonePairs: [3, 3],
                        centralLonePairs: 2,
                        hasResonance: false,
                        isRadical: false,
                        unpairedElectrons: 0
                    },
                    isResonanceTemplate: false,
                    note: 'Predefined dichlorine monoxide structure applied.'
                }
            };

            function addGeneratedTemplate(central, peripheral, count, charge, label, allowOddValence) {
                if (count < 1) return;
                var fAtoms = {};
                fAtoms[central] = 1;
                fAtoms[peripheral] = count;
                var fKey = canonicalFormulaKey(fAtoms, charge || 0);
                if (!templates[fKey]) {
                    var t = buildGenericTemplate(central, peripheral, count, label);
                    if (allowOddValence) t.allowOddValence = true;
                    templates[fKey] = t;
                }
            }

            // Generic-symbol templates for deterministic educational rendering.
            // Keep auto-generated coverage on generic symbols only so real chemistry
            // still flows through bonding analysis.
            var genericCentrals = genericSymbols.slice();
            var genericPeripherals = genericSymbols.slice();
            for (var gc = 0; gc < genericCentrals.length; gc++) {
                for (var gp = 0; gp < genericPeripherals.length; gp++) {
                    if (genericCentrals[gc] === genericPeripherals[gp]) continue;
                    for (var n = 1; n <= 8; n++) {
                        addGeneratedTemplate(
                            genericCentrals[gc],
                            genericPeripherals[gp],
                            n,
                            0,
                            genericCentrals[gc] + genericPeripherals[gp] + n,
                            true
                        );
                    }
                }
            }

            predefinedLewisTemplates = templates;
        }

        var tpl = predefinedLewisTemplates[key] || null;
        if (!tpl) return null;

        // Guardrail: odd-electron species should use logic (radical handling)
        // unless explicitly added as an odd-electron predefined template.
        var totalValence = 0;
        for (var el in atoms) {
            totalValence += (valenceElectrons[el] || 0) * atoms[el];
        }
        totalValence -= charge;
        if ((totalValence % 2 !== 0) && !tpl.allowOddValence) {
            return null;
        }

        return tpl;
    }

    // Detect oxyacid pattern: H + O + central atom (e.g., H2SO4, H3PO4, HNO3)
    function detectOxyacid(atoms, centralAtom) {
        var oxyacidCenters = ['N', 'P', 'S', 'Cl', 'Br', 'I', 'Se', 'Te', 'As', 'C'];
        var numH = atoms['H'] || 0;
        var numO = atoms['O'] || 0;
        var nonHOFCenters = Object.keys(atoms).filter(function(el) {
            return el !== 'H' && el !== 'O' && el !== 'F' && (atoms[el] || 0) > 0;
        });
        return numH >= 1 && numO >= 2 &&
            centralAtom !== 'H' && centralAtom !== 'O' && centralAtom !== 'F' &&
            (atoms[centralAtom] || 0) === 1 &&
            nonHOFCenters.length === 1 &&
            oxyacidCenters.indexOf(centralAtom) !== -1 &&
            numH <= numO; // H attached through O in typical oxyacids
    }

    // Detect alcohol pattern: C + O + H where C>1 and O=1 (e.g., CH3OH, C2H5OH)
    function detectAlcohol(atoms) {
        var c = atoms['C'] || 0;
        var h = atoms['H'] || 0;
        var o = atoms['O'] || 0;
        return c >= 1 && o === 1 && h >= 1 &&
            (atoms['C'] || 0) >= 1 && (atoms['O'] || 0) === 1 &&
            Object.keys(atoms).length === 3 &&
            h === (2 * c + 2); // CnH(2n+2)O (alcohol/ether formula family)
    }

    // Detect explicit ether connectivity in raw formula text (e.g., CH3OCH3, C2H5OC2H5).
    function detectEther(formulaRaw) {
        if (!formulaRaw) return false;
        var normalized = formulaRaw.replace(/\s+/g, '');
        normalized = normalized.replace(/[\u2080-\u2089]/g, function(ch) {
            return String(ch.charCodeAt(0) - 0x2080);
        });
        normalized = normalized.replace(/[\u207A\u207B\u2212+\-]+$/, '');
        // Match C-O-C ether connectivity. Require digits or H between first C and O
        // so bare "CO" (carbonyl) doesn't match (e.g., CH3COCH3 is ketone not ether).
        // Use negative lookahead after trailing C to avoid two-letter elements (Cl, Cr, etc.)
        return /C[0-9H]+O[0-9H]*C(?![a-z])/.test(normalized);
    }

    // Detect ring structure: Formula suggests cyclic (e.g., C6H6, C5H10, C6H12)
    function detectRing(atoms) {
        if (!atoms['C']) return false;
        // Only pure hydrocarbons — non-C/H atoms mean the CnH2n ratio
        // is coincidental (e.g. C3H6O is acetone, not cyclopropane)
        var elementKeys = Object.keys(atoms).filter(function(el) { return atoms[el] > 0; });
        for (var i = 0; i < elementKeys.length; i++) {
            if (elementKeys[i] !== 'C' && elementKeys[i] !== 'H') return false;
        }
        var numC = atoms['C'] || 0;
        var numH = atoms['H'] || 0;

        // Common ring patterns:
        // Benzene: C6H6 (2n)
        // Cycloalkane: CnH2n
        // Cycloalkene: CnH(2n-2)
        return (numC >= 3 && numH === 2 * numC) || // Cycloalkane
            (numC >= 6 && numH === numC) ||      // Benzene-like
            (numC >= 3 && numH === 2 * numC - 2); // Cycloalkene
    }

    // ========== PUBCHEM SDF INTEGRATION ==========
    // Minimal SDF parser (mirrors molecular-geometry-render.js parseSDF)
    var pubchemLewisCache = {};

    function lewisParseSDF(sdf) {
        var lines = sdf.split('\n');
        var countsIdx = -1;
        for (var i = 0; i < Math.min(lines.length, 10); i++) {
            if (lines[i].indexOf('V2000') !== -1 || lines[i].indexOf('V3000') !== -1) {
                countsIdx = i; break;
            }
        }
        if (countsIdx === -1) return null;
        var countsParts = lines[countsIdx].trim().split(/\s+/);
        var numAtoms = parseInt(countsParts[0]);
        var numBonds = parseInt(countsParts[1]);
        if (isNaN(numAtoms) || isNaN(numBonds) || numAtoms < 1) return null;
        var atoms = [];
        for (var a = 0; a < numAtoms; a++) {
            var line = lines[countsIdx + 1 + a];
            if (!line) continue;
            var parts = line.trim().split(/\s+/);
            if (parts.length < 4) continue;
            atoms.push({ elem: parts[3], idx: a });
        }
        var bonds = [];
        for (var b = 0; b < numBonds; b++) {
            var bline = lines[countsIdx + 1 + numAtoms + b];
            if (!bline) continue;
            var bparts = bline.trim().split(/\s+/);
            if (bparts.length < 3) continue;
            bonds.push({ from: parseInt(bparts[0]) - 1, to: parseInt(bparts[1]) - 1,
                order: parseInt(bparts[2]) });
        }
        return { atoms: atoms, bonds: bonds };
    }

    function lewisFetchPubChem(query) {
        var clean = query.replace(/\s+/g, '').replace(/\(\d*[+-]\)$/, '').replace(/[+-]$/, '');
        if (!clean) return Promise.resolve(null);
        if (pubchemLewisCache[clean.toUpperCase()]) {
            return Promise.resolve(pubchemLewisCache[clean.toUpperCase()]);
        }
        // Try formula first, then name
        var cidUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/formula/' +
            encodeURIComponent(clean) + '/cids/JSON?MaxRecords=1';
        var nameUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/' +
            encodeURIComponent(clean) + '/cids/JSON?MaxRecords=1';

        function fetchCIDFromUrl(url) {
            return fetch(url).then(function(resp) {
                if (!resp.ok) return null;
                return resp.json();
            }).then(function(data) {
                if (data && data.IdentifierList && data.IdentifierList.CID &&
                    data.IdentifierList.CID.length > 0) {
                    return data.IdentifierList.CID[0];
                }
                if (data && data.Waiting) {
                    var listKey = data.Waiting.ListKey;
                    return new Promise(function(r) { setTimeout(r, 2000); }).then(function() {
                        return fetch('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/listkey/' +
                            listKey + '/cids/JSON?MaxRecords=1');
                    }).then(function(r) { return r.ok ? r.json() : null; }).then(function(d) {
                        if (d && d.IdentifierList && d.IdentifierList.CID && d.IdentifierList.CID.length > 0) {
                            return d.IdentifierList.CID[0];
                        }
                        return null;
                    });
                }
                return null;
            }).catch(function() { return null; });
        }

        return fetchCIDFromUrl(cidUrl).then(function(cid) {
            if (cid) return cid;
            return fetchCIDFromUrl(nameUrl);
        }).then(function(cid) {
            if (!cid) return null;
            // Fetch 3D SDF, fallback to 2D
            return fetch('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' +
                cid + '/SDF?record_type=3d').then(function(resp) {
                if (resp.ok) return resp.text();
                return fetch('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' +
                    cid + '/SDF').then(function(r) { return r.ok ? r.text() : null; });
            }).then(function(sdf) {
                if (!sdf) return null;
                var result = { sdf: sdf, cid: cid };
                pubchemLewisCache[clean.toUpperCase()] = result;
                return result;
            });
        }).catch(function() { return null; });
    }

    /**
     * Convert parsed SDF bond graph into Lewis structure format.
     * Returns { backbone, termsPerAtom, chainBonding } or null.
     */
    function sdfToLewisStructure(parsed, totalValence) {
        if (!parsed || !parsed.atoms || !parsed.bonds) return null;

        // Build adjacency list
        var adj = [];
        for (var i = 0; i < parsed.atoms.length; i++) adj.push([]);
        for (var b = 0; b < parsed.bonds.length; b++) {
            var bond = parsed.bonds[b];
            adj[bond.from].push({ neighbor: bond.to, order: bond.order });
            adj[bond.to].push({ neighbor: bond.from, order: bond.order });
        }

        // Identify heavy atoms (non-H) and H atoms
        var heavyIndices = [];
        var hIndices = [];
        for (var i = 0; i < parsed.atoms.length; i++) {
            if (parsed.atoms[i].elem === 'H') hIndices.push(i);
            else heavyIndices.push(i);
        }

        // Single heavy atom → star structure
        if (heavyIndices.length === 1) {
            var ci = heavyIndices[0];
            var centralAtom = parsed.atoms[ci].elem;
            var peripherals = [];
            var bondOrders = [];
            for (var b = 0; b < adj[ci].length; b++) {
                peripherals.push(parsed.atoms[adj[ci][b].neighbor].elem);
                bondOrders.push(adj[ci][b].order);
            }
            // Compute lone pairs from remaining electrons
            var bondE = bondOrders.reduce(function(s, o) { return s + o * 2; }, 0);
            var remaining = totalValence - bondE;
            var pLonePairs = peripherals.map(function(el, pi) {
                if (el === 'H') return 0;
                var need = 3;
                var canGive = Math.min(need, Math.floor(remaining / 2));
                remaining -= canGive * 2;
                return canGive;
            });
            var centralTarget = (centralAtom === 'H') ? 2 : 8;
            var cLonePairs = Math.max(0, Math.floor((centralTarget - bondE) / 2));
            if (cLonePairs * 2 > remaining) cLonePairs = Math.floor(remaining / 2);

            return {
                type: 'star',
                centralAtom: centralAtom,
                bonding: {
                    peripherals: peripherals, bondOrders: bondOrders,
                    peripheralLonePairs: pLonePairs, centralLonePairs: cLonePairs,
                    hasResonance: false, isRadical: (totalValence % 2 !== 0),
                    unpairedElectrons: 0
                }
            };
        }

        // Multi-heavy-atom: build backbone from heavy atom connectivity
        // Find the longest chain of heavy atoms (simple DFS)
        var heavyAdj = {};
        for (var i = 0; i < heavyIndices.length; i++) heavyAdj[heavyIndices[i]] = [];
        for (var b = 0; b < parsed.bonds.length; b++) {
            var bond = parsed.bonds[b];
            if (parsed.atoms[bond.from].elem !== 'H' && parsed.atoms[bond.to].elem !== 'H') {
                heavyAdj[bond.from].push({ neighbor: bond.to, order: bond.order });
                heavyAdj[bond.to].push({ neighbor: bond.from, order: bond.order });
            }
        }

        // Check for ring: if any heavy atom has a cycle
        var isRing = false;
        if (heavyIndices.length >= 3) {
            // Ring if edges >= vertices among heavy atoms
            var heavyBondCount = 0;
            for (var b = 0; b < parsed.bonds.length; b++) {
                var bond = parsed.bonds[b];
                if (parsed.atoms[bond.from].elem !== 'H' && parsed.atoms[bond.to].elem !== 'H') {
                    heavyBondCount++;
                }
            }
            isRing = heavyBondCount >= heavyIndices.length;
        }

        if (isRing) {
            // For now, fall back to heuristic for rings
            return null;
        }

        // Find longest path (backbone) via DFS from each endpoint
        function findLongestPath() {
            var best = [];
            // Start from degree-1 heavy atoms (endpoints)
            var endpoints = heavyIndices.filter(function(hi) {
                return heavyAdj[hi].length === 1;
            });
            if (endpoints.length === 0) endpoints = [heavyIndices[0]];

            for (var ei = 0; ei < endpoints.length; ei++) {
                var stack = [[endpoints[ei], [endpoints[ei]]]];
                var visited = {};
                while (stack.length > 0) {
                    var item = stack.pop();
                    var node = item[0], path = item[1];
                    if (path.length > best.length) best = path.slice();
                    visited[node] = true;
                    var neighbors = heavyAdj[node] || [];
                    for (var ni = 0; ni < neighbors.length; ni++) {
                        var next = neighbors[ni].neighbor;
                        if (!visited[next] && path.indexOf(next) === -1) {
                            stack.push([next, path.concat(next)]);
                        }
                    }
                }
            }
            return best;
        }

        var backbonePath = findLongestPath();
        var backboneSet = {};
        for (var i = 0; i < backbonePath.length; i++) backboneSet[backbonePath[i]] = i;

        var backbone = backbonePath.map(function(idx) { return parsed.atoms[idx].elem; });

        // Backbone bond orders
        var bbBondOrders = [];
        for (var i = 0; i < backbonePath.length - 1; i++) {
            var fromIdx = backbonePath[i];
            var toIdx = backbonePath[i + 1];
            var order = 1;
            for (var b = 0; b < parsed.bonds.length; b++) {
                if ((parsed.bonds[b].from === fromIdx && parsed.bonds[b].to === toIdx) ||
                    (parsed.bonds[b].from === toIdx && parsed.bonds[b].to === fromIdx)) {
                    order = parsed.bonds[b].order;
                    break;
                }
            }
            bbBondOrders.push(order);
        }

        // Terminal atoms: everything bonded to backbone atoms that's not on the backbone
        var termsPerAtom = [];
        var termBondOrders = [];
        var termLonePairs = [];
        var termAttachedHydrogens = [];

        for (var bi = 0; bi < backbonePath.length; bi++) {
            var bbIdx = backbonePath[bi];
            var terms = [];
            var tOrders = [];
            var tLP = [];
            var tAttH = [];

            for (var ni = 0; ni < adj[bbIdx].length; ni++) {
                var nb = adj[bbIdx][ni];
                if (backboneSet[nb.neighbor] !== undefined) continue; // skip backbone neighbors
                var nbElem = parsed.atoms[nb.neighbor].elem;

                if (nbElem === 'H') {
                    terms.push('H');
                    tOrders.push(1);
                    tLP.push(0);
                    tAttH.push(0);
                } else {
                    // Non-H terminal (branch atom): collect its H neighbors
                    terms.push(nbElem);
                    tOrders.push(nb.order);
                    // Lone pairs: (8 - bond_order*2) / 2 for non-H
                    var termTarget = 8;
                    var termBondE = nb.order * 2;
                    // Count H bonded to this terminal atom
                    var termH = 0;
                    for (var ti = 0; ti < adj[nb.neighbor].length; ti++) {
                        var termNb = adj[nb.neighbor][ti];
                        if (termNb.neighbor !== bbIdx && parsed.atoms[termNb.neighbor].elem === 'H') {
                            termH++;
                            termBondE += 2;
                        }
                    }
                    tLP.push(Math.max(0, Math.floor((termTarget - termBondE) / 2)));
                    tAttH.push(termH);
                }
            }
            termsPerAtom.push(terms);
            termBondOrders.push(tOrders);
            termLonePairs.push(tLP);
            termAttachedHydrogens.push(tAttH);
        }

        // Backbone lone pairs
        var bbLonePairs = [];
        for (var bi = 0; bi < backbone.length; bi++) {
            var atomE = 0;
            if (bi > 0) atomE += bbBondOrders[bi - 1] * 2;
            if (bi < backbone.length - 1) atomE += bbBondOrders[bi] * 2;
            for (var ti = 0; ti < termBondOrders[bi].length; ti++) {
                atomE += termBondOrders[bi][ti] * 2;
            }
            var target = (backbone[bi] === 'H') ? 2 : 8;
            bbLonePairs.push(Math.max(0, Math.floor((target - atomE) / 2)));
        }

        // Check if any termAttachedHydrogens are non-zero
        var hasTermAttachedH = false;
        for (var bi = 0; bi < termAttachedHydrogens.length; bi++) {
            for (var ti = 0; ti < termAttachedHydrogens[bi].length; ti++) {
                if (termAttachedHydrogens[bi][ti] > 0) { hasTermAttachedH = true; break; }
            }
            if (hasTermAttachedH) break;
        }

        return {
            type: 'chain',
            backbone: backbone,
            termsPerAtom: termsPerAtom,
            chainBonding: {
                bbBondOrders: bbBondOrders,
                bbLonePairs: bbLonePairs,
                termLonePairs: termLonePairs,
                termBondOrders: termBondOrders,
                termAttachedHydrogens: hasTermAttachedH ? termAttachedHydrogens : undefined
            },
            termAttachedHydrogens: hasTermAttachedH ? termAttachedHydrogens : null
        };
    }

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

            var formulaStr = normalizeFormulaForDisplay(formula);

            // ========== PATTERN DETECTION AND ROUTING ==========
            var centralCount = atoms[centralAtom] || 0;
            var predefinedTemplate = getPredefinedLewisTemplate(atoms, charge);
            var isOxyacid = detectOxyacid(atoms, centralAtom);
            var isEther = detectEther(formula);
            var isAlcohol = !isEther && detectAlcohol(atoms);
            var isRing = detectRing(atoms);
            var isChain = !isOxyacid && !isAlcohol && !isEther && !isRing && centralCount >= 2;

            var backbone, termsPerAtom, bonding, chainBonding;
            var termAttachedHydrogens = null;
            var predefinedChain = false;

            if (predefinedTemplate && predefinedTemplate.kind === 'chain') {
                predefinedChain = true;
                backbone = predefinedTemplate.backbone.slice();
                termsPerAtom = predefinedTemplate.termsPerAtom.map(function(arr) { return arr.slice(); });
                chainBonding = predefinedTemplate.chainBonding;
                termAttachedHydrogens = predefinedTemplate.termAttachedHydrogens || chainBonding.termAttachedHydrogens || null;
                createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding, termAttachedHydrogens);

            } else if (predefinedTemplate) {
                centralAtom = predefinedTemplate.centralAtom;
                bonding = predefinedTemplate.bonding;
                createLewisSketch(atoms, centralAtom, totalValence, charge, bonding, formulaStr);

            } else if (isOxyacid) {
                // Handle oxyacids: H bonds to O, O bonds to central (e.g., H2SO4)
                bonding = analyzeOxyacidBonding(atoms, centralAtom, totalValence);
                createOxyacidLewisSketch(atoms, centralAtom, totalValence, charge, bonding, formulaStr);

            } else if (isAlcohol) {
                // Handle alcohols: C-C-...-C-OH (e.g., CH3OH, C2H5OH)
                backbone = [];
                var numC = atoms['C'] || 0;
                for (var k = 0; k < numC; k++) backbone.push('C');
                backbone.push('O'); // O at the end

                // H atoms distribute: some to O (1 H), rest to C atoms
                termsPerAtom = [];
                for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);

                var numH = atoms['H'] || 0;
                // Last position (O) gets 1 H
                termsPerAtom[backbone.length - 1].push('H');
                numH--;

                // Distribute remaining H to carbons
                for (var k = 0; k < numC && numH > 0; k++) {
                    var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
                    var maxH = 4 - bbBonds;
                    var give = Math.min(maxH, numH);
                    for (var h = 0; h < give; h++) termsPerAtom[k].push('H');
                    numH -= give;
                }

                chainBonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);
                createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding, termAttachedHydrogens);

            } else if (isEther) {
                // Handle ethers: C-O-C (e.g., CH3OCH3)
                var numC = atoms['C'] || 0;
                var halfC = Math.floor(numC / 2);

                backbone = [];
                for (var k = 0; k < halfC; k++) backbone.push('C');
                backbone.push('O');
                for (var k = 0; k < numC - halfC; k++) backbone.push('C');

                // Distribute H atoms to C atoms
                termsPerAtom = [];
                for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);

                var numH = atoms['H'] || 0;
                for (var k = 0; k < backbone.length && numH > 0; k++) {
                    if (backbone[k] === 'O') continue; // O gets no H in simple ether
                    var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
                    var maxH = 4 - bbBonds;
                    var give = Math.min(maxH, numH);
                    for (var h = 0; h < give; h++) termsPerAtom[k].push('H');
                    numH -= give;
                }

                chainBonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);
                createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding, termAttachedHydrogens);

            } else if (isRing) {
                // Handle rings: Connect carbons in a circle
                var numC = atoms['C'] || 0;
                backbone = [];
                for (var k = 0; k < numC; k++) backbone.push('C');

                // Distribute H atoms
                termsPerAtom = [];
                for (var k = 0; k < numC; k++) termsPerAtom.push([]);

                var numH = atoms['H'] || 0;
                var hPerC = Math.floor(numH / numC);
                var extraH = numH % numC;

                for (var k = 0; k < numC; k++) {
                    var give = hPerC + (k < extraH ? 1 : 0);
                    for (var h = 0; h < give; h++) termsPerAtom[k].push('H');
                }

                chainBonding = analyzeRingBonding(backbone, termsPerAtom, totalValence);
                createRingLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding);

            } else if (isChain) {
                // Original chain handling for homogeneous backbones
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
                var capacities = [];
                for (var k = 0; k < backbone.length; k++) {
                    var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
                    capacities[k] = Math.max(0, getMaxBonds(backbone[k]) - bbBonds);
                }

                // Round-robin terminal placement avoids overloading the first backbone atom.
                var idx = 0;
                while (remaining.length > 0) {
                    var assigned = false;
                    for (var tries = 0; tries < backbone.length; tries++) {
                        var target = (idx + tries) % backbone.length;
                        if (capacities[target] > 0) {
                            termsPerAtom[target].push(remaining.shift());
                            capacities[target]--;
                            idx = (target + 1) % backbone.length;
                            assigned = true;
                            break;
                        }
                    }
                    if (!assigned) break;
                }

                // Overflow goes to last atom (expanded octet or fallback).
                if (remaining.length > 0) {
                    termsPerAtom[backbone.length - 1] = termsPerAtom[backbone.length - 1].concat(remaining);
                }

                chainBonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);
                createChainLewisSketch(backbone, termsPerAtom, totalValence, charge, formulaStr, chainBonding, termAttachedHydrogens);

            } else {
                // Star structure: single central atom with peripherals
                bonding = analyzeBonding(atoms, centralAtom, totalValence);

                var centralBondOrderSum = bonding.bondOrders.reduce(function(sum, o) { return sum + o; }, 0);
                var centralMaxBonds = getMaxBonds(centralAtom);
                var invalidStar = centralBondOrderSum > centralMaxBonds;
                if (!invalidStar) {
                    for (var pi = 0; pi < bonding.peripherals.length; pi++) {
                        if (bonding.bondOrders[pi] > getMaxBonds(bonding.peripherals[pi])) {
                            invalidStar = true;
                            break;
                        }
                    }
                }
                if (invalidStar) {
                    // Star structure invalid — try real connectivity lookup
                    // Show spinner in canvas area
                    destroyCurrentSketch();
                    var spinnerContainer = document.getElementById('lewisCanvasContainer');
                    var emptyS = document.getElementById('emptyState');
                    if (emptyS) emptyS.style.display = 'none';
                    spinnerContainer.innerHTML = '<div style="display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;min-height:200px;gap:12px;">' +
                        '<div style="width:36px;height:36px;border:3px solid var(--border-color,#e2e8f0);border-top-color:var(--primary,#6366f1);border-radius:50%;animation:lewis-spin 0.8s linear infinite;"></div>' +
                        '<span style="color:var(--text-secondary,#64748b);font-size:0.875rem;">Analyzing structure\u2026</span></div>';
                    // Add spin animation if not already present
                    if (!document.getElementById('lewis-spin-style')) {
                        var styleEl = document.createElement('style');
                        styleEl.id = 'lewis-spin-style';
                        styleEl.textContent = '@keyframes lewis-spin{to{transform:rotate(360deg)}}';
                        document.head.appendChild(styleEl);
                    }
                    lewisFetchPubChem(formulaStr).then(function(pubData) {
                        if (!pubData || !pubData.sdf) {
                            spinnerContainer.innerHTML = '';
                            ToolUtils.showToast(
                                'Formula is ambiguous. Try a structural formula (e.g., CH3OH or CH3COOH).',
                                4500, 'warning');
                            return;
                        }
                        var parsed = lewisParseSDF(pubData.sdf);
                        var sdfResult = parsed ? sdfToLewisStructure(parsed, totalValence) : null;
                        if (!sdfResult) {
                            spinnerContainer.innerHTML = '';
                            ToolUtils.showToast(
                                'Could not determine structure. Try a structural formula.',
                                4500, 'warning');
                            return;
                        }
                        if (sdfResult.type === 'star') {
                            createLewisSketch(atoms, sdfResult.centralAtom, totalValence, charge,
                                sdfResult.bonding, formulaStr);
                        } else {
                            createChainLewisSketch(sdfResult.backbone, sdfResult.termsPerAtom,
                                totalValence, charge, formulaStr, sdfResult.chainBonding,
                                sdfResult.termAttachedHydrogens);
                        }

                        // Build result info panel (same as other paths)
                        var pubHtml = '';
                        pubHtml += buildMoleculeHeader(formulaStr, charge);
                        pubHtml += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#6366f1;">' +
                            '\u2139\ufe0f <strong>Structure resolved from database.</strong> ' +
                            'Real connectivity data used for accurate bond placement.</div>';

                        // Electron summary
                        var pubBondE = 0;
                        if (sdfResult.type === 'star') {
                            for (var si = 0; si < sdfResult.bonding.bondOrders.length; si++) pubBondE += sdfResult.bonding.bondOrders[si] * 2;
                        } else {
                            var cb = sdfResult.chainBonding;
                            for (var si = 0; si < cb.bbBondOrders.length; si++) pubBondE += cb.bbBondOrders[si] * 2;
                            for (var bi = 0; bi < cb.termBondOrders.length; bi++) {
                                for (var ti = 0; ti < cb.termBondOrders[bi].length; ti++) pubBondE += cb.termBondOrders[bi][ti] * 2;
                            }
                            if (cb.termAttachedHydrogens) {
                                for (var bi = 0; bi < cb.termAttachedHydrogens.length; bi++) {
                                    for (var ti = 0; ti < (cb.termAttachedHydrogens[bi] || []).length; ti++) {
                                        pubBondE += (cb.termAttachedHydrogens[bi][ti] || 0) * 2;
                                    }
                                }
                            }
                        }
                        pubHtml += '<div class="lewis-info-grid">';
                        pubHtml += '<div class="lewis-info-card"><strong>Total Valence e\u207b</strong><span>' + totalValence + '</span></div>';
                        pubHtml += '<div class="lewis-info-card"><strong>Bonding e\u207b</strong><span>' + pubBondE + '</span></div>';
                        pubHtml += '<div class="lewis-info-card"><strong>Remaining e\u207b</strong><span>' + (totalValence - pubBondE) + '</span></div>';
                        pubHtml += '</div>';

                        if (sdfResult.type === 'star') {
                            var sb = sdfResult.bonding;
                            pubHtml += '<div class="lewis-result-label">Central Atom</div>';
                            pubHtml += '<div class="lewis-result-value"><span class="lewis-chem">' + sdfResult.centralAtom + '</span>' +
                                (sb.centralLonePairs > 0 ? ' (' + sb.centralLonePairs + ' lone pair' + (sb.centralLonePairs !== 1 ? 's' : '') + ')' : ' (no lone pairs)') + '</div>';
                            pubHtml += '<div class="lewis-result-label">Bond Types</div>';
                            pubHtml += '<div class="lewis-result-value">' + describeBondOrders(sb.bondOrders) + '</div>';
                        } else {
                            var cb = sdfResult.chainBonding;
                            var bb = sdfResult.backbone;
                            pubHtml += '<div class="lewis-result-label">Backbone Chain</div>';
                            pubHtml += '<div class="lewis-result-value"><span class="lewis-chem">';
                            for (var bi = 0; bi < bb.length; bi++) {
                                pubHtml += bb[bi];
                                if (bi < bb.length - 1) {
                                    var bo = cb.bbBondOrders[bi] || 1;
                                    pubHtml += (bo === 3 ? ' \u2261 ' : bo === 2 ? ' = ' : ' \u2014 ');
                                }
                            }
                            pubHtml += '</span></div>';

                            pubHtml += '<div class="lewis-result-label">Bond Types</div>';
                            var allPubOrders = cb.bbBondOrders.slice();
                            for (var bi = 0; bi < sdfResult.termsPerAtom.length; bi++) {
                                for (var ti = 0; ti < sdfResult.termsPerAtom[bi].length; ti++) {
                                    var tbo = (cb.termBondOrders && cb.termBondOrders[bi] && cb.termBondOrders[bi][ti] !== undefined) ?
                                        cb.termBondOrders[bi][ti] : 1;
                                    allPubOrders.push(tbo);
                                }
                            }
                            if (cb.termAttachedHydrogens) {
                                for (var bi = 0; bi < cb.termAttachedHydrogens.length; bi++) {
                                    for (var ti = 0; ti < (cb.termAttachedHydrogens[bi] || []).length; ti++) {
                                        for (var h = 0; h < (cb.termAttachedHydrogens[bi][ti] || 0); h++) allPubOrders.push(1);
                                    }
                                }
                            }
                            pubHtml += '<div class="lewis-result-value">' + describeBondOrders(allPubOrders) + '</div>';

                            // Backbone lone pairs
                            var hasAnyLP = false;
                            for (var bi = 0; bi < cb.bbLonePairs.length; bi++) { if (cb.bbLonePairs[bi] > 0) hasAnyLP = true; }
                            if (hasAnyLP) {
                                pubHtml += '<div class="lewis-result-label">Backbone Lone Pairs</div>';
                                pubHtml += '<div class="lewis-result-value">';
                                for (var bi = 0; bi < bb.length; bi++) {
                                    if (cb.bbLonePairs[bi] > 0) pubHtml += bb[bi] + (bi+1) + ': ' + cb.bbLonePairs[bi] + ' pair' + (cb.bbLonePairs[bi] !== 1 ? 's' : '') + '  ';
                                }
                                pubHtml += '</div>';
                            }
                        }

                        document.getElementById('resultDisplay').innerHTML = pubHtml;
                        document.getElementById('resultActions').classList.add('visible');

                        // Build text result for copying
                        currentResultText = 'Lewis Structure: ' + formatFormulaText(formulaStr) +
                            '\nTotal Valence Electrons: ' + totalValence +
                            '\nBonding Electrons: ' + pubBondE +
                            '\nType: ' + sdfResult.type;

                        ToolUtils.showToast('Structure resolved successfully', 2000);
                    });
                    return;
                }
                createLewisSketch(atoms, centralAtom, totalValence, charge, bonding, formulaStr);
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

            function bondOrderLabel(order) {
                return order === 3 ? 'triple' : order === 2 ? 'double' : 'single';
            }

            // Keep info cards consistent with the actually generated structure (chain/ring/star/predefined/oxyacid).
            var displayBondingElectrons = bondingElectrons;
            if (predefinedTemplate && !predefinedChain) {
                displayBondingElectrons = bonding.bondOrders.reduce(function(sum, o) { return sum + o * 2; }, 0);
            } else if (isOxyacid) {
                var centralOBondE = bonding.bondOrders.reduce(function(sum, o) { return sum + o * 2; }, 0);
                var ohBondE = (atoms['H'] || 0) * 2; // O-H bonds in oxyacids
                displayBondingElectrons = centralOBondE + ohBondE;
            } else if ((isRing || isAlcohol || isEther || isChain) && chainBonding && backbone && termsPerAtom) {
                var bbOrdersForCalc = chainBonding.bbBondOrders || [];
                var bbBondE = bbOrdersForCalc.reduce(function(sum, o) { return sum + o * 2; }, 0);
                var termBondE = 0;
                for (var bi = 0; bi < termsPerAtom.length; bi++) {
                    for (var ti = 0; ti < termsPerAtom[bi].length; ti++) {
                        var tbo = 1;
                        if (chainBonding.termBondOrders &&
                            chainBonding.termBondOrders[bi] &&
                            chainBonding.termBondOrders[bi][ti] !== undefined) {
                            tbo = chainBonding.termBondOrders[bi][ti];
                        }
                        termBondE += tbo * 2;
                    }
                }
                if (termAttachedHydrogens) {
                    for (var bi = 0; bi < termAttachedHydrogens.length; bi++) {
                        for (var ti = 0; ti < (termAttachedHydrogens[bi] || []).length; ti++) {
                            termBondE += ((termAttachedHydrogens[bi][ti] || 0) * 2);
                        }
                    }
                }
                displayBondingElectrons = bbBondE + termBondE;
            } else if (bonding && bonding.bondOrders) {
                displayBondingElectrons = bonding.bondOrders.reduce(function(sum, o) { return sum + o * 2; }, 0);
            }
            var displayRemainingElectrons = totalValence - displayBondingElectrons;

            // Build result HTML
            var html = '';
            html += buildMoleculeHeader(formulaStr, charge);

            if (hasGenericSymbol) {
                html += '<div class="lewis-alert lewis-alert-warning" style="margin-bottom:0.75rem;">Generic notation detected. Using textbook values (M=4e\u207b, A=4e\u207b, X=7e\u207b, L=7e\u207b, E=6e\u207b, R=1e\u207b, G=8e\u207b).</div>';
            }

            // Radical warning
            if (totalValence % 2 !== 0) {
                html += '<div class="lewis-alert lewis-alert-warning" style="margin-bottom:0.75rem;">\u26a0\ufe0f <strong>Radical species:</strong> ' + totalValence + ' valence electrons (odd count). One or more electrons remain unpaired.</div>';
            }

            // Pattern-specific notes
            if (predefinedTemplate && !predefinedChain && predefinedTemplate.isResonanceTemplate) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#6366f1;">' +
                    '\u2139\ufe0f <strong>Resonance structure:</strong> Showing one valid Lewis form. ' +
                    'Actual electrons are delocalized across equivalent bonds.' +
                    '</div>';
            } else if (predefinedTemplate && !predefinedChain) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#10b981;">' +
                    '\u2705 <strong>Valid structure selected:</strong> Showing a common Lewis structure that satisfies valence and octet rules.' +
                    '</div>';
            } else if (predefinedChain) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#10b981;">' +
                    '\u2705 <strong>Valid connectivity selected:</strong> Showing one common structure that satisfies valence and octet rules.' +
                    '</div>';
            } else if (isOxyacid) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#10b981;">\u2705 <strong>Oxyacid structure detected:</strong> H atoms are bonded to O atoms (forming O\u2013H groups), which then bond to ' + centralAtom + '. Some O atoms may form double bonds with the central atom.</div>';
            } else if (isAlcohol) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#10b981;">\u2705 <strong>Alcohol structure detected:</strong> Structure shows \u2013OH hydroxyl group bonded to carbon chain.</div>';
            } else if (isEther) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#10b981;">\u2705 <strong>Ether structure detected:</strong> Oxygen bridges two carbon chains (C\u2013O\u2013C).</div>';
            } else if (isRing) {
                html += '<div class="lewis-alert" style="margin-bottom:0.75rem;border-left-color:#10b981;">\u2705 <strong>Cyclic structure detected:</strong> Carbon atoms form a ring structure.</div>';
            }

            html += '<div class="lewis-info-grid">';
            html += '<div class="lewis-info-card"><strong>Total Valence e\u207b</strong><span>' + totalValence + '</span></div>';
            html += '<div class="lewis-info-card"><strong>Bonding e\u207b</strong><span>' + displayBondingElectrons + '</span></div>';
            html += '<div class="lewis-info-card"><strong>Remaining e\u207b</strong><span>' + displayRemainingElectrons + '</span></div>';
            html += '</div>';

            if (isOxyacid) {
                // Oxyacid-specific results
                html += '<div class="lewis-result-label">Central Atom</div>';
                html += '<div class="lewis-result-value"><span class="lewis-chem">' + centralAtom + '</span></div>';

                html += '<div class="lewis-result-label">Oxygen Atoms</div>';
                html += '<div class="lewis-result-value">' +
                    bonding.ohGroups + ' O in \u2013OH groups, ' +
                    bonding.doubleO + ' O in =' + centralAtom + '=O double bonds</div>';

                html += '<div class="lewis-result-label">Structure Type</div>';
                html += '<div class="lewis-result-value">Oxyacid with ' + (atoms['H'] || 0) + ' acidic hydrogen' +
                    ((atoms['H'] || 0) !== 1 ? 's' : '') + '</div>';

            } else if (isRing) {
                // Ring-specific results
                var chainNotation = generateChainNotation(backbone, termsPerAtom, termAttachedHydrogens);
                var bbOrders = chainBonding.bbBondOrders;

                html += '<div class="lewis-result-label">Ring Structure</div>';
                html += '<div class="lewis-result-value"><span class="lewis-chem">';
                for (var bi = 0; bi < backbone.length; bi++) {
                    html += backbone[bi];
                    if (bi < backbone.length - 1) {
                        var bo = bbOrders[bi] || 1;
                        html += (bo === 3 ? ' \u2261 ' : bo === 2 ? ' = ' : ' \u2014 ');
                    } else {
                        // Close the ring
                    var bo = bbOrders[backbone.length - 1] || 1;
                    html += (bo === 3 ? ' \u2261 ' : bo === 2 ? ' = ' : ' \u2014 ');
                }
                }
                html += backbone[0]; // Close ring
                html += '</span> (' + backbone.length + '-membered ring)</div>';

                var isBenzene = backbone.length === 6;
                var totalH = 0;
                for (var i = 0; i < termsPerAtom.length; i++) {
                    for (var j = 0; j < termsPerAtom[i].length; j++) {
                        if (termsPerAtom[i][j] === 'H') totalH++;
                    }
                }
                if (isBenzene && totalH === 6) {
                    html += '<div class="lewis-result-label">Aromatic Character</div>';
                    html += '<div class="lewis-result-value">Benzene ring with alternating single/double bonds (resonance)</div>';
                }

            } else if (isAlcohol || isEther || isChain) {
                // Chain-specific results
                var chainNotation = generateChainNotation(backbone, termsPerAtom, termAttachedHydrogens);
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
                    for (var ti = 0; ti < termsPerAtom[bi].length; ti++) {
                        var tbo = 1;
                        if (chainBonding.termBondOrders &&
                            chainBonding.termBondOrders[bi] &&
                            chainBonding.termBondOrders[bi][ti] !== undefined) {
                            tbo = chainBonding.termBondOrders[bi][ti];
                        }
                        allChainOrders.push(tbo);
                    }
                }
                if (termAttachedHydrogens) {
                    for (var bi = 0; bi < termAttachedHydrogens.length; bi++) {
                        for (var ti = 0; ti < (termAttachedHydrogens[bi] || []).length; ti++) {
                            for (var h = 0; h < (termAttachedHydrogens[bi][ti] || 0); h++) allChainOrders.push(1);
                        }
                    }
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

                if (bonding.unpairedElectrons && bonding.unpairedElectrons > 0) {
                    html += '<div class="lewis-result-label">Unpaired Electrons</div>';
                    html += '<div class="lewis-result-value">' + bonding.unpairedElectrons + '</div>';
                }

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

            // Build text result for copying
            var formulaWithChargeText = formatFormulaText(formulaStr) +
                (charge !== 0 ? ' (' + (charge > 0 ? '+' : '') + charge + ')' : '');
            if (predefinedTemplate && !predefinedChain && predefinedTemplate.isResonanceTemplate) {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nType: Resonance molecule' +
                    '\nCentral Atom: ' + centralAtom +
                    '\nOne valid resonance form: ' + describeBondOrders(bonding.bondOrders) +
                    '\nNote: Actual electrons are delocalized across equivalent bonds.';
            } else if (predefinedTemplate && !predefinedChain) {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nType: Selected valid structure' +
                    '\nCentral Atom: ' + centralAtom +
                    '\nBonds: ' + describeBondOrders(bonding.bondOrders);
            } else if (isOxyacid) {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nType: Oxyacid' +
                    '\nCentral Atom: ' + centralAtom +
                    '\nOH groups: ' + bonding.ohGroups +
                    '\nDouble-bonded O: ' + bonding.doubleO;
            } else if (isRing) {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nType: Cyclic (' + backbone.length + '-membered ring)' +
                    '\nBackbone: ' + backbone.join('-') + '-' + backbone[0];
            } else if (isAlcohol) {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nType: Alcohol (contains -OH group)' +
                    '\nBackbone: ' + formatFormulaText(generateChainNotation(backbone, termsPerAtom, termAttachedHydrogens));
            } else if (isEther) {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nType: Ether (C-O-C linkage)' +
                    '\nBackbone: ' + formatFormulaText(generateChainNotation(backbone, termsPerAtom, termAttachedHydrogens));
            } else if (isChain || (chainBonding && backbone)) {
                var terminalBondLabels = [];
                for (var bi = 0; bi < termsPerAtom.length; bi++) {
                    for (var ti = 0; ti < termsPerAtom[bi].length; ti++) {
                        var to = 1;
                        if (chainBonding.termBondOrders &&
                            chainBonding.termBondOrders[bi] &&
                            chainBonding.termBondOrders[bi][ti] !== undefined) {
                            to = chainBonding.termBondOrders[bi][ti];
                        }
                        terminalBondLabels.push(bondOrderLabel(to));
                    }
                }
                if (termAttachedHydrogens) {
                    for (var bi = 0; bi < termAttachedHydrogens.length; bi++) {
                        for (var ti = 0; ti < (termAttachedHydrogens[bi] || []).length; ti++) {
                            for (var h = 0; h < (termAttachedHydrogens[bi][ti] || 0); h++) terminalBondLabels.push('single');
                        }
                    }
                }
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nCondensed: ' + formatFormulaText(generateChainNotation(backbone, termsPerAtom, termAttachedHydrogens)) +
                    '\nBackbone bonds: ' + chainBonding.bbBondOrders.map(function(o) { return bondOrderLabel(o); }).join(', ') +
                    '\nTerminal bonds: ' + (terminalBondLabels.length > 0 ? terminalBondLabels.join(', ') : 'none');
            } else {
                currentResultText = 'Lewis Structure: ' + formulaWithChargeText +
                    '\nTotal Valence Electrons: ' + totalValence +
                    '\nCentral Atom: ' + centralAtom + ' (' + bonding.centralLonePairs + ' lone pairs)' +
                    (bonding.unpairedElectrons > 0 ? '\nUnpaired electrons: ' + bonding.unpairedElectrons : '') +
                    '\nBonds: ' + describeBondOrders(bonding.bondOrders);
            }

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
            var f = document.getElementById('molecularFormula').value.trim() || 'molecule';
            canvas.toBlob(function(blob) {
                var url = URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = url;
                a.download = 'lewis-structure-' + f.replace(/[^a-zA-Z0-9]/g, '_') + '.png';
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

    // ========== DOWNLOAD PDF ==========
    document.getElementById('downloadPdfBtn').addEventListener('click', function() {
        var canvas = document.querySelector('#lewisCanvasContainer canvas');
        if (!canvas) {
            ToolUtils.showToast('No Lewis structure to download. Generate one first.', 2000, 'warning');
            return;
        }
        var formula = document.getElementById('molecularFormula').value.trim() || 'molecule';
        ToolUtils.showToast('Generating PDF...', 1500, 'info');

        // Build styled off-screen container
        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:750px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        // Title
        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:6px;color:#2563eb;';
        title.textContent = 'Lewis Structure \u2014 8gwifi.org';
        container.appendChild(title);
        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#2563eb,#60a5fa,transparent);margin-bottom:20px;';
        container.appendChild(divider);

        // Formula label
        var formulaLabel = document.createElement('div');
        formulaLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:4px;';
        formulaLabel.textContent = 'Molecule';
        container.appendChild(formulaLabel);
        var formulaEl = document.createElement('div');
        formulaEl.style.cssText = 'font-size:24px;font-weight:700;color:#0f172a;margin-bottom:20px;font-family:JetBrains Mono,monospace;';
        formulaEl.textContent = formula;
        container.appendChild(formulaEl);

        // Canvas image
        var imgEl = document.createElement('img');
        imgEl.src = canvas.toDataURL('image/png');
        imgEl.style.cssText = 'display:block;max-width:100%;margin:0 auto 20px;border:1px solid #e2e8f0;border-radius:8px;';
        container.appendChild(imgEl);

        // Result text
        var resultEl = document.getElementById('resultDisplay');
        if (resultEl && resultEl.innerHTML) {
            var infoLabel = document.createElement('div');
            infoLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;border-top:1px solid #e2e8f0;padding-top:16px;';
            infoLabel.textContent = 'Analysis';
            container.appendChild(infoLabel);
            var infoClone = document.createElement('div');
            infoClone.style.cssText = 'font-size:13px;color:#334155;line-height:1.7;';
            infoClone.textContent = currentResultText;
            container.appendChild(infoClone);
        }

        // Footer
        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org Lewis Structure Generator</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        // Render PDF
        var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve() : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
        loadHtml2Canvas
            .then(function() { return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js'); })
            .then(function() { return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false }); })
            .then(function(c) {
                document.body.removeChild(container);
                var imgData = c.toDataURL('image/png');
                var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
                var pw = pdf.internal.pageSize.getWidth(), margin = 10, uw = pw - margin * 2;
                var iw = uw, ih = (c.height * uw) / c.width;
                var uh = pdf.internal.pageSize.getHeight() - margin * 2;
                if (ih > uh) { ih = uh; iw = (c.width * uh) / c.height; }
                pdf.addImage(imgData, 'PNG', (pw - iw) / 2, margin, iw, ih);
                var fname = 'lewis-structure-' + formula.replace(/[^a-zA-Z0-9]/g, '_') + '.pdf';
                pdf.save(fname);
                ToolUtils.showToast('PDF downloaded!', 2000, 'success');
                setTimeout(function() { ToolUtils.showSupportPopup(TOOL_NAME, 'Downloaded: ' + fname); }, 500);
            })
            .catch(function(err) {
                if (container.parentNode) document.body.removeChild(container);
                ToolUtils.showToast('PDF generation failed: ' + (err.message || ''), 3000, 'error');
            });
    });

    // ========== PRACTICE SHEET ANSWER CALCULATOR ==========
    // Uses the same logic as the Lewis generator: parseMolecularFormula, valenceElectrons, bonding analysis, vseprData
    function computeWorksheetAnswer(formula) {
        try {
            var formulaNorm = normalizeFormulaForDisplay(formula);
            var atoms = parseMolecularFormula(formula);
            var charge = 0;
            var totalValence = 0;
            for (var el in atoms) {
                if (!valenceElectrons[el]) return null;
                totalValence += valenceElectrons[el] * atoms[el];
            }
            totalValence -= charge;

            var atomKeys = Object.keys(atoms);
            var centralAtom = atomKeys.find(function(a) { return a !== 'H' && a !== 'F'; }) || atomKeys[0];

            var bonding = null;
            var centralCount = atoms[centralAtom] || 0;
            var isChain = !detectOxyacid(atoms, centralAtom) && !detectAlcohol(atoms) && !detectEther(formulaNorm) && !detectRing(atoms) && centralCount >= 2;
            if (detectOxyacid(atoms, centralAtom)) {
                bonding = analyzeOxyacidBonding(atoms, centralAtom, totalValence);
            } else if (detectAlcohol(atoms) || detectEther(formulaNorm) || detectRing(atoms) || isChain) {
                return { valence: totalValence, geometry: null, angle: null };
            } else {
                var tpl = getPredefinedLewisTemplate(atoms, charge);
                if (tpl && tpl.bonding && !tpl.kind) {
                    bonding = tpl.bonding;
                }
                if (!bonding) {
                    bonding = analyzeBonding(atoms, centralAtom, totalValence);
                }
            }
            if (!bonding || !bonding.peripherals) return { valence: totalValence, geometry: null, angle: null };

            var bonds = bonding.peripherals.length;
            var lone = (bonding.centralLonePairs || 0) + (bonding.unpairedElectrons > 0 ? 1 : 0);
            var steric = bonds + lone;
            var key = steric + '-' + lone;
            var geom = vseprData[key];
            if (!geom) return { valence: totalValence, geometry: null, angle: null };
            return { valence: totalValence, geometry: geom.molecular, angle: geom.angle };
        } catch (e) {
            return null;
        }
    }

    // Render Lewis structure for a formula, return image data URL (uses main container)
    function renderLewisToImage(formula) {
        var molInput = document.getElementById('molecularFormula');
        var chargeInput = document.getElementById('molecularCharge');
        if (!molInput) return null;
        var formulaNorm = normalizeFormulaForDisplay(formula);
        molInput.value = formulaNorm;
        chargeInput.value = '0';
        try {
            generateLewis();
        } catch (e) {
            return null;
        }
        var canvas = document.querySelector('#lewisCanvasContainer canvas');
        return canvas ? canvas.toDataURL('image/png') : null;
    }

    // ========== PRACTICE SHEET ==========
    document.getElementById('practiceSheetBtn').addEventListener('click', function() {
        var savedFormula = (document.getElementById('molecularFormula') || {}).value || '';
        var savedCharge = (document.getElementById('molecularCharge') || {}).value || '0';
        ToolUtils.showToast('Generating Lewis diagrams...', 2000, 'info');

        var fullMoleculePool = [
            { formula: 'H\u2082O', name: 'Water', hint: '2 bonds, 2 lone pairs on O' },
            { formula: 'CO\u2082', name: 'Carbon Dioxide', hint: 'Double bonds to each O' },
            { formula: 'NH\u2083', name: 'Ammonia', hint: '3 bonds, 1 lone pair on N' },
            { formula: 'CH\u2084', name: 'Methane', hint: '4 single bonds, no lone pairs' },
            { formula: 'O\u2082', name: 'Oxygen', hint: 'Double bond between O atoms' },
            { formula: 'N\u2082', name: 'Nitrogen', hint: 'Triple bond between N atoms' },
            { formula: 'HCN', name: 'Hydrogen Cyanide', hint: 'Triple bond between C and N' },
            { formula: 'SO\u2082', name: 'Sulfur Dioxide', hint: 'Lone pair on S, resonance' },
            { formula: 'CCl\u2084', name: 'Carbon Tetrachloride', hint: '4 single bonds' },
            { formula: 'BF\u2083', name: 'Boron Trifluoride', hint: 'B has only 6 electrons' },
            { formula: 'PCl\u2085', name: 'Phosphorus Pentachloride', hint: 'Expanded octet' },
            { formula: 'SF\u2086', name: 'Sulfur Hexafluoride', hint: 'Expanded octet, 6 bonds' },
            { formula: 'F\u2082', name: 'Fluorine', hint: 'Single bond between F atoms' },
            { formula: 'Cl\u2082', name: 'Chlorine', hint: 'Single bond between Cl atoms' },
            { formula: 'HCl', name: 'Hydrogen Chloride', hint: 'Single bond, 3 lone pairs on Cl' },
            { formula: 'HF', name: 'Hydrogen Fluoride', hint: 'Single bond, 3 lone pairs on F' },
            { formula: 'H\u2082S', name: 'Hydrogen Sulfide', hint: '2 bonds, 2 lone pairs on S' },
            { formula: 'BeCl\u2082', name: 'Beryllium Chloride', hint: 'Linear, Be has only 4 electrons' },
            { formula: 'O\u2083', name: 'Ozone', hint: 'Resonance, bent geometry' },
            { formula: 'C\u2082H\u2082', name: 'Acetylene', hint: 'Triple bond between C atoms' },
            { formula: 'C\u2082H\u2084', name: 'Ethene', hint: 'Double bond between C atoms' },
            { formula: 'C\u2082H\u2086', name: 'Ethane', hint: 'Single bonds, sp\u00b3 carbons' },
            { formula: 'PCl\u2083', name: 'Phosphorus Trichloride', hint: '3 bonds, 1 lone pair on P' },
            { formula: 'SO\u2083', name: 'Sulfur Trioxide', hint: 'Resonance, trigonal planar' },
            { formula: 'NO\u2082', name: 'Nitrogen Dioxide', hint: 'Odd electron, bent' },
            { formula: 'N\u2082O', name: 'Nitrous Oxide', hint: 'N-N-O or N-O-N resonance' },
            { formula: 'XeF\u2082', name: 'Xenon Difluoride', hint: 'Linear, 3 lone pairs on Xe' },
            { formula: 'XeF\u2084', name: 'Xenon Tetrafluoride', hint: 'Square planar, 2 lone pairs' },
            { formula: 'BrF\u2083', name: 'Bromine Trifluoride', hint: 'T-shaped, expanded octet' },
            { formula: 'ClF\u2083', name: 'Chlorine Trifluoride', hint: 'T-shaped, 2 lone pairs' },
            { formula: 'SF\u2084', name: 'Sulfur Tetrafluoride', hint: 'Seesaw, 1 lone pair' },
            { formula: 'H\u2082CO', name: 'Formaldehyde', hint: 'Double bond C=O, H on C' },
            { formula: 'CH\u2083OH', name: 'Methanol', hint: 'O-H bond, 2 lone pairs on O' },
            { formula: 'CO', name: 'Carbon Monoxide', hint: 'Triple bond, formal charges' },
            { formula: 'NF\u2083', name: 'Nitrogen Trifluoride', hint: '3 bonds, 1 lone pair on N' },
            { formula: 'COCl\u2082', name: 'Phosgene', hint: 'C=O, 2 C-Cl bonds' },
            { formula: 'C\u2083H\u2088', name: 'Propane', hint: '3 carbons in a chain' },
            { formula: 'H\u2082', name: 'Hydrogen', hint: 'Single bond between H atoms' },
            { formula: 'Br\u2082', name: 'Bromine', hint: 'Single bond between Br atoms' },
            { formula: 'I\u2082', name: 'Iodine', hint: 'Single bond between I atoms' },
            { formula: 'HBr', name: 'Hydrogen Bromide', hint: 'Single bond, 3 lone pairs on Br' },
            { formula: 'CF\u2084', name: 'Carbon Tetrafluoride', hint: '4 single bonds, no lone pairs' },
            { formula: 'CBr\u2084', name: 'Carbon Tetrabromide', hint: '4 single bonds' },
            { formula: 'SiH\u2084', name: 'Silane', hint: '4 single bonds, tetrahedral' },
            { formula: 'PH\u2083', name: 'Phosphine', hint: '3 bonds, 1 lone pair on P' },
            { formula: 'CS\u2082', name: 'Carbon Disulfide', hint: 'Double bonds S=C=S linear' },
            { formula: 'H\u2082O\u2082', name: 'Hydrogen Peroxide', hint: 'O-O bond, bent' },
            { formula: 'N\u2082H\u2084', name: 'Hydrazine', hint: 'N-N bond, 2 lone pairs' },
            { formula: 'NO', name: 'Nitric Oxide', hint: 'Odd electron, triple bond' },
            { formula: 'OF\u2082', name: 'Oxygen Difluoride', hint: '2 bonds, 2 lone pairs on O' },
            { formula: 'ClO\u2082', name: 'Chlorine Dioxide', hint: 'Odd electron, bent' },
            { formula: 'IF\u2085', name: 'Iodine Pentafluoride', hint: 'Square pyramidal' },
            { formula: 'IF\u2087', name: 'Iodine Heptafluoride', hint: 'Pentagonal bipyramidal' },
            { formula: 'SbCl\u2085', name: 'Antimony Pentachloride', hint: 'Trigonal bipyramidal' },
            { formula: 'SeF\u2086', name: 'Selenium Hexafluoride', hint: 'Octahedral' },
            { formula: 'TeF\u2086', name: 'Tellurium Hexafluoride', hint: 'Octahedral' },
            { formula: 'KrF\u2082', name: 'Krypton Difluoride', hint: 'Linear, noble gas compound' },
            { formula: 'C\u2084H\u2081\u2080', name: 'Butane', hint: '4 carbons chain' },
            { formula: 'C\u2082H\u2085OH', name: 'Ethanol', hint: 'O-H, 2 lone pairs on O' },
            { formula: 'CH\u2083CHO', name: 'Acetaldehyde', hint: 'C=O, C-H bonds' },
            { formula: 'CH\u2083NH\u2082', name: 'Methylamine', hint: 'N has 1 lone pair' },
            { formula: 'C\u2082H\u2085Cl', name: 'Chloroethane', hint: 'Cl substituent on C chain' },
            { formula: 'CH\u2082F\u2082', name: 'Difluoromethane', hint: '2 F, 2 H on C' },
            { formula: 'CHF\u2083', name: 'Fluoroform', hint: '3 F, 1 H on C' },
            { formula: 'CH\u2083F', name: 'Methyl Fluoride', hint: '1 F on C' },
            { formula: 'B\u2082H\u2086', name: 'Diborane', hint: 'Bridged structure, 3c-2e bonds' },
            { formula: 'HN\u2083', name: 'Hydrazoic Acid', hint: 'N=N=N linear' },
            { formula: 'C\u2082H\u2083F\u2083', name: 'Trifluoroethane', hint: '3 F on carbons' },
            { formula: 'H\u2082SO\u2084', name: 'Sulfuric Acid', hint: '2 OH, 2 double-bond O on S' },
            { formula: 'NOF', name: 'Nitrosyl Fluoride', hint: 'N=O, N-F bond' },
            { formula: 'ClF', name: 'Chlorine Monofluoride', hint: 'Single bond' },
            { formula: 'BrF\u2085', name: 'Bromine Pentafluoride', hint: 'Square pyramidal' },
            { formula: 'ICl\u2083', name: 'Iodine Trichloride', hint: 'T-shaped' },
            { formula: 'AsF\u2085', name: 'Arsenic Pentafluoride', hint: 'Trigonal bipyramidal' },
            { formula: 'SbF\u2085', name: 'Antimony Pentafluoride', hint: 'Trigonal bipyramidal' },
            { formula: 'NCl\u2083', name: 'Nitrogen Trichloride', hint: '3 bonds, 1 lone pair' },
            { formula: 'Cl\u2082O', name: 'Dichlorine Monoxide', hint: 'O central, bent' },
            { formula: 'C\u2085H\u2081\u2082', name: 'Pentane', hint: '5 carbons chain' },
            { formula: 'CH\u2083COCH\u2083', name: 'Acetone', hint: 'C=O between 2 methyl groups' },
            { formula: 'HCOOH', name: 'Formic Acid', hint: 'C=O, O-H, C-H' },
            { formula: 'CH\u2083COOH', name: 'Acetic Acid', hint: 'C=O, O-H on carbonyl' },
        ];

        function shuffleArray(arr) {
            var a = arr.slice();
            for (var i = a.length - 1; i > 0; i--) {
                var j = Math.floor(Math.random() * (i + 1));
                var t = a[i]; a[i] = a[j]; a[j] = t;
            }
            return a;
        }
        var practiceProblems = shuffleArray(fullMoleculePool).slice(0, 12);

        function delay(ms) { return new Promise(function(r) { setTimeout(r, ms); }); }

        function generateLewisImagesAsync() {
            var lewisImages = [];
            var idx = 0;
            function next() {
                if (idx >= practiceProblems.length) return Promise.resolve(lewisImages);
                var dataUrl = renderLewisToImage(practiceProblems[idx].formula);
                lewisImages.push(dataUrl);
                idx++;
                return delay(350).then(next);
            }
            return next();
        }

        generateLewisImagesAsync().then(function(lewisImages) {
            var molInput = document.getElementById('molecularFormula');
            var chargeInput = document.getElementById('molecularCharge');
            if (molInput) molInput.value = savedFormula;
            if (chargeInput) chargeInput.value = savedCharge;
            if (savedFormula) try { generateLewis(); } catch (e) {}

            var baseStyle = 'position:absolute;left:-9999px;top:0;width:750px;padding:30px 40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';

            // Page 1: Problems only
            var page1 = document.createElement('div');
            page1.style.cssText = baseStyle;
            document.body.appendChild(page1);

            var header = document.createElement('div');
            header.style.cssText = 'text-align:center;margin-bottom:4px;';
            header.innerHTML = '<div style="font-size:22px;font-weight:700;color:#2563eb;">Lewis Structure Practice Worksheet</div>';
            page1.appendChild(header);
            var subtitle = document.createElement('div');
            subtitle.style.cssText = 'text-align:center;font-size:12px;color:#64748b;margin-bottom:4px;';
            subtitle.textContent = '8gwifi.org \u2014 Chemistry Tools';
            page1.appendChild(subtitle);
            var studentLine = document.createElement('div');
            studentLine.style.cssText = 'display:flex;gap:24px;margin-bottom:6px;padding:8px 0;border-bottom:2px solid #2563eb;';
            studentLine.innerHTML = '<div style="flex:1;font-size:12px;color:#64748b;">Name: ___________________________</div>' +
                '<div style="font-size:12px;color:#64748b;">Date: ______________</div>' +
                '<div style="font-size:12px;color:#64748b;">Score: ______ / ' + practiceProblems.length + '</div>';
            page1.appendChild(studentLine);
            var instr = document.createElement('div');
            instr.style.cssText = 'padding:8px 12px;background:#eff6ff;border-left:3px solid #2563eb;border-radius:4px;margin-bottom:10px;font-size:11px;color:#1e40af;line-height:1.5;';
            instr.innerHTML = '<strong>Instructions:</strong> For each molecule below, draw the complete Lewis structure in the box provided. ' +
                'Show all bonding pairs as lines and lone pairs as dots. Then fill in the blanks for valence electrons, molecular geometry, and bond angle.';
            page1.appendChild(instr);
            var grid = document.createElement('div');
            grid.style.cssText = 'display:grid;grid-template-columns:1fr 1fr;gap:8px;';
            for (var i = 0; i < practiceProblems.length; i++) {
                var p = practiceProblems[i];
                var card = document.createElement('div');
                card.style.cssText = 'border:1.5px solid #cbd5e1;border-radius:6px;padding:8px 10px;page-break-inside:avoid;';
                card.innerHTML = '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:4px;">' +
                    '<div style="display:flex;align-items:center;gap:6px;">' +
                    '<span style="display:inline-flex;align-items:center;justify-content:center;width:20px;height:20px;border-radius:50%;background:#2563eb;color:#fff;font-size:10px;font-weight:700;">' + (i + 1) + '</span>' +
                    '<span style="font-size:15px;font-weight:700;font-family:JetBrains Mono,monospace;">' + p.formula + '</span></div>' +
                    '<span style="font-size:10px;color:#94a3b8;font-style:italic;">' + p.name + '</span></div>' +
                    '<div style="width:100%;height:100px;border:1px dashed #cbd5e1;border-radius:4px;background:#fafbfc;margin-bottom:6px;display:flex;align-items:center;justify-content:center;">' +
                    '<span style="font-size:10px;color:#cbd5e1;">Draw Lewis Structure Here</span></div>' +
                    '<div style="font-size:10px;color:#475569;line-height:1.8;">Total Valence e\u207b: ________&nbsp;&nbsp;&nbsp;&nbsp;Geometry: ________________&nbsp;&nbsp;&nbsp;&nbsp;Bond Angle: ________</div>' +
                    '<div style="font-size:9px;color:#94a3b8;font-style:italic;margin-top:2px;">Hint: ' + p.hint + '</div>';
                grid.appendChild(card);
            }
            page1.appendChild(grid);
            var footer1 = document.createElement('div');
            footer1.style.cssText = 'margin-top:10px;padding-top:8px;border-top:1px solid #e2e8f0;font-size:10px;color:#94a3b8;';
            footer1.textContent = 'Generated by 8gwifi.org Lewis Structure Generator \u2014 ' + new Date().toLocaleDateString();
            page1.appendChild(footer1);

            // Page 2: Answer Key with Lewis diagrams
            var page2 = document.createElement('div');
            page2.style.cssText = baseStyle;
            document.body.appendChild(page2);
            var akHeader = document.createElement('div');
            akHeader.style.cssText = 'font-size:18px;font-weight:700;color:#2563eb;margin-bottom:4px;';
            akHeader.textContent = 'Answer Key (Teacher Use)';
            page2.appendChild(akHeader);
            var akNote = document.createElement('div');
            akNote.style.cssText = 'font-size:10px;color:#64748b;margin-bottom:12px;';
            akNote.textContent = 'Computed by same logic as the Lewis Structure Generator. Valence e\u207b = total valence electrons; Geometry = molecular geometry; Angle = bond angle around central atom.';
            page2.appendChild(akNote);
            var akGrid = document.createElement('div');
            akGrid.style.cssText = 'display:grid;grid-template-columns:1fr 1fr;gap:12px 20px;';
            for (var k = 0; k < practiceProblems.length; k++) {
                var pk = practiceProblems[k];
                var ans = computeWorksheetAnswer(pk.formula);
                var v = (ans && ans.valence != null) ? ans.valence : '?';
                var g = (ans && ans.geometry) ? ans.geometry : '?';
                var a = (ans && ans.angle) ? ans.angle : '?';
                var cell = document.createElement('div');
                cell.style.cssText = 'border:1px solid #e2e8f0;border-radius:6px;padding:8px;display:flex;flex-direction:column;align-items:center;gap:4px;';
                var imgSrc = lewisImages[k];
                if (imgSrc) {
                    var img = document.createElement('img');
                    img.src = imgSrc;
                    img.style.cssText = 'max-width:120px;max-height:80px;object-fit:contain;';
                    img.alt = 'Lewis structure for ' + pk.formula;
                    cell.appendChild(img);
                } else {
                    var plc = document.createElement('span');
                    plc.style.cssText = 'font-size:10px;color:#94a3b8;';
                    plc.textContent = '[Structure]';
                    cell.appendChild(plc);
                }
                var txt = document.createElement('div');
                txt.style.cssText = 'font-size:11px;font-family:JetBrains Mono,monospace;text-align:center;';
                txt.innerHTML = '<span style="font-weight:700;">' + (k + 1) + '. ' + pk.formula + '</span> &mdash; Valence: ' + v + ', ' + g + ', ' + a;
                cell.appendChild(txt);
                akGrid.appendChild(cell);
            }
            page2.appendChild(akGrid);
            var footer2 = document.createElement('div');
            footer2.style.cssText = 'margin-top:10px;padding-top:8px;border-top:1px solid #e2e8f0;font-size:10px;color:#94a3b8;';
            footer2.textContent = 'Generated by 8gwifi.org Lewis Structure Generator \u2014 ' + new Date().toLocaleDateString();
            page2.appendChild(footer2);

            var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve() : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
            var opts = { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false };
            loadHtml2Canvas
                .then(function() { return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js'); })
                .then(function() { return html2canvas(page1, opts); })
                .then(function(c1) {
                    var img1 = c1.toDataURL('image/png');
                    return html2canvas(page2, opts).then(function(c2) {
                        return { img1: img1, c1: c1, img2: c2.toDataURL('image/png'), c2: c2 };
                    });
                })
                .then(function(data) {
                    document.body.removeChild(page1);
                    document.body.removeChild(page2);
                    var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
                    var pw = pdf.internal.pageSize.getWidth();
                    var ph = pdf.internal.pageSize.getHeight();
                    var margin = 8, uw = pw - margin * 2, uh = ph - margin * 2;

                    function addPageImage(imgData, canvas, isFirst) {
                        var iw = uw, ih = (canvas.height * uw) / canvas.width;
                        if (ih > uh) { ih = uh; iw = (canvas.width * uh) / canvas.height; }
                        var x = (pw - iw) / 2, y = margin;
                        pdf.addImage(imgData, 'PNG', x, y, iw, ih);
                    }
                    addPageImage(data.img1, data.c1, true);
                    pdf.addPage();
                    addPageImage(data.img2, data.c2, false);
                    pdf.save('lewis-structure-practice-sheet.pdf');
                    ToolUtils.showToast('Practice sheet downloaded!', 2000, 'success');
                    setTimeout(function() { ToolUtils.showSupportPopup(TOOL_NAME, 'Downloaded practice worksheet'); }, 500);
                })
                .catch(function(err) {
                    if (page1.parentNode) document.body.removeChild(page1);
                    if (page2.parentNode) document.body.removeChild(page2);
                    ToolUtils.showToast('Practice sheet generation failed: ' + (err.message || ''), 3000, 'error');
                });
        });
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
<!-- Insert into Document (Math Editor integration) -->
<button id="insertIntoDocBtn" style="display:none;position:fixed;bottom:20px;right:20px;z-index:9999;padding:10px 20px;background:#2563EB;color:#fff;border:none;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;box-shadow:0 4px 12px rgba(0,0,0,.15);" title="Send to Math Editor">&#x2934; Insert into Document</button>
<script>
(function() {
    var params = new URLSearchParams(window.location.search);
    if (params.get('returnTo') !== 'editor') return;
    var btn = document.getElementById('insertIntoDocBtn');
    if (!btn) return;
    btn.style.display = '';

    btn.addEventListener('click', function() {
        if (!window.opener) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No parent editor window found', 2000, 'error'); return; }

        // Capture the Lewis structure canvas as PNG
        var canvasEl = document.querySelector('#lewisCanvasContainer canvas');
        if (!canvasEl) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generate a Lewis structure first', 2000, 'warning'); return; }

        var imageData = '';
        try { imageData = canvasEl.toDataURL('image/png'); } catch(e) {}
        if (!imageData) { if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Could not capture image', 2000, 'error'); return; }

        // Get formula and geometry info
        var formula = (document.getElementById('molecularFormula') || {}).value || '';
        var geomEl = document.getElementById('geomLabel') || document.querySelector('.lewis-geometry-label');
        var geometry = geomEl ? geomEl.textContent : '';

        window.opener.postMessage({
            type: 'molecule-insert',
            svg: null,
            imageDataUrl: imageData,
            smiles: '',
            formula: formula + (geometry ? ' \u2014 ' + geometry : ''),
            weight: '',
            name: 'Lewis Structure: ' + formula
        }, '*');

        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Inserted into document', 1500);
    });
})();
</script>
</body>
</html>
