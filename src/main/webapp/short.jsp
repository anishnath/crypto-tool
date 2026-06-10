<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://ai-inference.xyz">
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">

    <!-- Critical CSS — Wildflower Meadow design system base -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:oklch(0.292 0.046 164.9);background:oklch(0.982 0.006 137.8);margin:0}

        :root {
            --background: oklch(0.982 0.006 137.8);
            --foreground: oklch(0.292 0.046 164.9);
            --card: oklch(1.000 0.000 89.9);
            --card-foreground: oklch(0.292 0.046 164.9);
            --popover: oklch(1.000 0.000 89.9);
            --popover-foreground: oklch(0.292 0.046 164.9);
            --primary: oklch(0.605 0.215 27.7);
            --primary-foreground: oklch(0.982 0.006 137.8);
            --secondary: oklch(0.993 0.003 128.5);
            --secondary-foreground: oklch(0.292 0.046 164.9);
            --muted: oklch(0.996 0.003 128.5);
            --muted-foreground: oklch(0.292 0.046 164.9);
            --accent: oklch(0.536 0.190 259.9);
            --accent-foreground: oklch(0.292 0.046 164.9);
            --destructive: oklch(0.605 0.215 27.7);
            --border: oklch(0.922 0.004 134.8);
            --input: oklch(0.922 0.004 134.8);
            --ring: oklch(0.876 0.171 91.7);
            --radius: 0.5rem;

            --primary-dark: oklch(0.486 0.190 27.7);
            --bg-primary: var(--card);
            --bg-secondary: var(--background);
            --bg-tertiary: var(--muted);
            --text-primary: var(--foreground);
            --text-secondary: oklch(0.446 0.037 164.7);
            --text-muted: oklch(0.560 0.040 164.7);
        }

        .dark,
        [data-theme="dark"] {
            --background: oklch(0.292 0.046 164.9);
            --foreground: oklch(0.982 0.006 137.8);
            --card: oklch(0.292 0.046 164.9);
            --card-foreground: oklch(0.982 0.006 137.8);
            --popover: oklch(0.292 0.046 164.9);
            --popover-foreground: oklch(0.982 0.006 137.8);
            --primary: oklch(0.876 0.171 91.7);
            --primary-foreground: oklch(0.292 0.046 164.9);
            --secondary: oklch(0.446 0.037 164.7);
            --secondary-foreground: oklch(0.982 0.006 137.8);
            --muted: oklch(0.446 0.037 164.7);
            --muted-foreground: oklch(0.959 0.009 134.9);
            --accent: oklch(0.536 0.190 259.9);
            --destructive: oklch(0.605 0.215 27.7);
            --border: oklch(1 0 0 / 12%);
            --input: oklch(1 0 0 / 16%);
            --ring: oklch(0.876 0.171 91.7);
            --radius: 0.5rem;

            --primary-dark: oklch(0.760 0.171 91.7);
            --bg-primary: var(--card);
            --bg-secondary: var(--background);
            --bg-tertiary: var(--muted);
            --text-primary: var(--foreground);
            --text-secondary: oklch(0.959 0.009 134.9);
            --text-muted: oklch(0.820 0.020 134.9);
        }
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="URL Shortener & Link Analytics (QR) - Free" />
        <jsp:param name="toolDescription" value="Free URL shortener to create short links and track clicks. Link analytics with daily charts, top countries, referrers, and automatic QR codes. No login required." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="short.jsp" />
        <jsp:param name="toolKeywords" value="url shortener, free url shortener, link shortener, create short link, short url, shorten url online, qr code short link, link analytics, track link clicks, link tracker, unique visitors, top countries, top referrers" />
        <jsp:param name="toolImage" value="short-og.png" />
        <jsp:param name="toolFeatures" value="Shorten long URLs instantly,Automatic QR code generation,Real-time click tracking,30-day analytics with daily breakdown,Top countries by clicks,Top referrers analysis,Unique visitor tracking,No registration required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Paste URL|Enter a long link that starts with http:// or https:// into the input field.,Shorten|Click Shorten URL to create a short link and an automatic QR code.,Copy or share|Copy the short link, scan or download the QR code, or share it directly.,Track|Enter the short code in the Analytics panel to view clicks by day, top countries, and referrers." />
        <jsp:param name="faq1q" value="How do I shorten a URL?" />
        <jsp:param name="faq1a" value="Paste your long link (starting with http:// or https://) into the input field and click Shorten URL. You'll instantly get a short link, a QR code, and the ability to copy or share it." />
        <jsp:param name="faq2q" value="Is this URL shortener free?" />
        <jsp:param name="faq2a" value="Yes, completely free with no registration required. There are no hidden fees or premium tiers — all features are available to everyone." />
        <jsp:param name="faq3q" value="Can I track clicks for my short link?" />
        <jsp:param name="faq3a" value="Yes. Enter the short code in the Analytics panel to see all-time clicks, a 30-day daily breakdown chart, top countries, top referrers, and unique visitor statistics." />
        <jsp:param name="faq4q" value="Do you provide QR codes?" />
        <jsp:param name="faq4a" value="Yes, a QR code is generated automatically for every short link, so you can share it offline via posters, flyers, business cards, or presentations." />
        <jsp:param name="faq5q" value="Do short links expire?" />
        <jsp:param name="faq5a" value="Short links are permanent and do not expire. They keep working indefinitely unless manually deleted." />
        <jsp:param name="faq6q" value="What analytics are available?" />
        <jsp:param name="faq6a" value="All-time click count, creation date, a 30-day daily clicks chart, unique visitors, top countries by clicks, and top referrer sources — all free with no limits." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* URL-shortener tool accent — a confident "link" blue over the shared system */
        :root {
            --tool-primary: oklch(0.555 0.165 252.0);
            --tool-primary-dark: oklch(0.460 0.160 256.0);
            --tool-gradient: linear-gradient(135deg, oklch(0.555 0.165 252.0) 0%, oklch(0.460 0.160 256.0) 100%);
            --tool-light: oklch(0.955 0.028 252.0);
            --tool-accent2: oklch(0.700 0.120 200.0);
        }
        .dark, [data-theme="dark"] {
            --tool-primary: oklch(0.720 0.140 250.0);
            --tool-primary-dark: oklch(0.640 0.140 254.0);
            --tool-gradient: linear-gradient(135deg, oklch(0.720 0.140 250.0) 0%, oklch(0.640 0.140 254.0) 100%);
            --tool-light: oklch(0.446 0.037 164.7 / 55%);
            --tool-accent2: oklch(0.760 0.110 200.0);
        }

        /* ---- Compact page header ---- */
        .tool-page-header {
            padding: 0.5rem 1rem !important; min-height: 0 !important;
            background: linear-gradient(135deg, oklch(0.993 0.002 145.6) 0%, oklch(0.982 0.006 137.8) 100%);
            border-bottom: 1px solid var(--border);
        }
        .tool-page-header-inner {
            display: flex !important; align-items: center !important; gap: 0.75rem; flex-wrap: wrap;
            padding: 0 !important; margin: 0 auto !important; max-width: 1400px;
        }
        .tool-page-header-inner > div:first-child { display: flex; align-items: baseline; gap: 0.75rem; flex-wrap: wrap; min-width: 0; }
        .tool-page-title { font-size: 1.05rem !important; font-weight: 700 !important; margin: 0 !important; line-height: 1.25 !important; letter-spacing: -0.01em; color: var(--foreground); }
        .tool-breadcrumbs { font-size: 0.72rem !important; line-height: 1.25 !important; margin: 0 !important; color: var(--text-secondary); }
        .tool-breadcrumbs a { color: var(--tool-primary); text-decoration: none; }
        .tool-breadcrumbs a:hover { text-decoration: underline; }
        .tool-header-pitch { font-size: 0.72rem; line-height: 1.25; color: var(--text-secondary); padding-left: 0.6rem; margin-left: 0.6rem; border-left: 1px solid var(--border); white-space: nowrap; }
        .tool-header-pitch a { color: var(--tool-primary); font-weight: 600; text-decoration: none; margin-left: 0.25rem; }
        .tool-header-pitch a:hover { text-decoration: underline; }
        .tool-page-badges { display: flex; gap: 0.3rem; margin-left: auto; flex-wrap: wrap; }
        .tool-badge {
            padding: 0.12rem 0.45rem !important; font-size: 0.68rem !important; line-height: 1.3 !important;
            border-radius: 9999px !important; display: inline-flex; align-items: center; gap: 0.25rem;
            background: var(--tool-light); color: var(--tool-primary-dark);
            border: 1px solid oklch(0.555 0.165 252.0 / 22%); font-weight: 600;
        }
        .dark .tool-badge, [data-theme="dark"] .tool-badge {
            background: oklch(0.720 0.140 250.0 / 15%); color: var(--tool-primary); border-color: oklch(0.720 0.140 250.0 / 30%);
        }
        .tool-badge svg { width: 11px; height: 11px; }
        @media (max-width: 640px) {
            .tool-header-pitch { display: block; padding-left: 0; margin-left: 0; border-left: none; white-space: normal; margin-top: 0.15rem; }
            .tool-page-title { font-size: 0.95rem !important; }
            .tool-page-badges { margin-left: 0; }
        }
        .tool-description-section { padding: 0.5rem 1rem !important; }

        /* ---- Inputs ---- */
        .su-group { margin-bottom: 0.9rem; }
        .su-label { display: block; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.04em; text-transform: uppercase; color: var(--text-muted); margin-bottom: 0.35rem; }
        .su-inputwrap { display: flex; align-items: stretch; border: 1px solid var(--border); border-radius: 0.55rem; overflow: hidden; background: var(--bg-primary); transition: border-color 0.15s, box-shadow 0.15s; }
        .su-inputwrap:focus-within { border-color: var(--tool-primary); box-shadow: 0 0 0 3px oklch(0.555 0.165 252.0 / 16%); }
        .su-prefix { display: flex; align-items: center; padding: 0 0.7rem; background: var(--bg-tertiary); color: var(--text-muted); border-right: 1px solid var(--border); }
        .su-prefix svg { width: 15px; height: 15px; }
        .su-input { flex: 1; min-width: 0; border: none; outline: none; background: transparent; color: var(--text-primary); font-size: 0.9rem; padding: 0.6rem 0.7rem; font-family: 'JetBrains Mono', monospace; }
        .su-input::placeholder { font-family: 'Inter', sans-serif; color: var(--text-muted); }
        .su-hint { font-size: 0.72rem; color: var(--text-muted); margin-top: 0.3rem; }
        .su-grid3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.6rem; }
        .su-grid3 .su-input { text-align: center; font-family: 'JetBrains Mono', monospace; }

        /* ---- Shorten result ---- */
        .su-result { display: none; margin-top: 1rem; padding: 0.85rem; border: 1px solid var(--border); border-radius: 0.6rem; background: var(--bg-tertiary); }
        .su-result.show { display: block; }
        .su-result-top { display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap; }
        .su-shortlink {
            flex: 1; min-width: 0; font-family: 'JetBrains Mono', monospace; font-size: 0.92rem; font-weight: 600;
            color: var(--tool-primary-dark); text-decoration: none; word-break: break-all;
        }
        .dark .su-shortlink, [data-theme="dark"] .su-shortlink { color: var(--tool-primary); }
        .su-shortlink:hover { text-decoration: underline; }
        .su-btnrow { display: flex; gap: 0.4rem; flex-wrap: wrap; margin-top: 0.7rem; }
        .su-qr { margin-top: 0.85rem; display: flex; align-items: flex-start; gap: 0.85rem; }
        .su-qr #qrcode { line-height: 0; flex-shrink: 0; }
        .su-qr #qrcode canvas, .su-qr #qrcode img { border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.10); background: #fff; padding: 4px; }
        .su-qr-side { display: flex; flex-direction: column; gap: 0.55rem; align-items: flex-start; }
        .su-qr-note { font-size: 0.72rem; color: var(--text-muted); line-height: 1.5; }

        /* ---- Error box ---- */
        .su-error { display: none; margin-top: 0.85rem; padding: 0.6rem 0.85rem; border-radius: 0.5rem; font-size: 0.8rem; font-weight: 500;
            background: oklch(0.605 0.215 27.7 / 10%); border: 1px solid oklch(0.605 0.215 27.7 / 30%); color: oklch(0.520 0.200 27.7); }
        .dark .su-error, [data-theme="dark"] .su-error { color: oklch(0.800 0.130 27.7); }

        /* ---- KPI cards ---- */
        .su-kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.7rem; }
        @media (max-width: 560px) { .su-kpis { grid-template-columns: 1fr 1fr; } }
        .su-kpi { border: 1px solid var(--border); border-radius: 0.6rem; background: var(--bg-primary); padding: 0.75rem 0.85rem; overflow: hidden; position: relative; }
        .su-kpi::before { content: ""; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--tool-primary), var(--tool-accent2)); }
        .su-kpi-label { font-size: 0.68rem; font-weight: 600; letter-spacing: 0.03em; text-transform: uppercase; color: var(--text-muted); margin: 0.25rem 0 0.2rem; }
        .su-kpi-val { font-size: 1.15rem; font-weight: 700; color: var(--text-primary); font-family: 'JetBrains Mono', monospace; line-height: 1.2; word-break: break-word; }

        /* ---- Chart + tables ---- */
        .su-block-title { font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: var(--tool-primary-dark); margin: 1.25rem 0 0.5rem; }
        .dark .su-block-title, [data-theme="dark"] .su-block-title { color: var(--tool-primary); }
        .su-chart-wrap { border: 1px solid var(--border); border-radius: 0.6rem; background: var(--bg-primary); padding: 0.85rem; }
        .su-tables { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        @media (max-width: 640px) { .su-tables { grid-template-columns: 1fr; } }
        .su-table { width: 100%; border-collapse: collapse; font-size: 0.82rem; }
        .su-table th { text-align: left; font-weight: 600; color: var(--text-secondary); padding: 0.45rem 0.6rem; border-bottom: 2px solid var(--border); font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.03em; }
        .su-table td { padding: 0.45rem 0.6rem; border-bottom: 1px solid var(--border); color: var(--text-primary); }
        .su-table td:last-child { text-align: right; font-family: 'JetBrains Mono', monospace; font-weight: 600; color: var(--tool-primary-dark); }
        .dark .su-table td:last-child, [data-theme="dark"] .su-table td:last-child { color: var(--tool-primary); }
        .su-table .su-nodata { color: var(--text-muted); font-style: italic; }

        /* ---- About content section ---- */
        .tool-content-section { padding: 2rem 1.5rem; max-width: 1200px; margin: 0 auto; }
        .tool-content-container { max-width: 900px; margin: 0 auto; }
        .tool-content-section .tool-card { background: var(--bg-primary); border: 1px solid var(--border); border-radius: 1rem; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .tool-content-section .tool-card-header { background: var(--tool-gradient); color: #fff; padding: 1rem 1.5rem; display: flex; align-items: center; gap: 0.5rem; font-weight: 600; font-size: 1.1rem; }
        .tool-content-section .tool-card-body { padding: 1.5rem; }
        .tool-section-title { font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-bottom: 1rem; }
        .tool-subsection-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin: 1.5rem 0 0.75rem; }
        .tool-feature-list, .tool-steps-list { padding-left: 1.25rem; margin-bottom: 1rem; }
        .tool-feature-list li, .tool-steps-list li { margin-bottom: 0.5rem; color: var(--text-secondary); line-height: 1.6; }
        .tool-feature-list li strong, .tool-steps-list li strong { color: var(--text-primary); }
        .tool-use-cases-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        @media (max-width: 600px) { .tool-use-cases-grid { grid-template-columns: 1fr; } }
        .tool-use-cases-grid ul { padding-left: 1.25rem; margin: 0; }
        .tool-use-cases-grid li { color: var(--text-secondary); margin-bottom: 0.375rem; }
        .tool-highlight-box { background: var(--tool-light); border-left: 4px solid var(--tool-primary); padding: 1rem 1.25rem; border-radius: 0.5rem; margin-top: 1.5rem; color: var(--text-secondary); }
        .tool-highlight-box strong { color: var(--tool-primary-dark); }
        .dark .tool-highlight-box, [data-theme="dark"] .tool-highlight-box { background: oklch(0.720 0.140 250.0 / 15%); }
        .dark .tool-highlight-box strong, [data-theme="dark"] .tool-highlight-box strong { color: var(--tool-primary); }
        .tool-content-section p { color: var(--text-secondary); line-height: 1.6; }
        .tool-content-section code { background: oklch(0.555 0.165 252.0 / 12%); padding: 0.125rem 0.375rem; border-radius: 0.25rem; font-size: 0.875rem; color: var(--tool-primary-dark); }
        .dark .tool-content-section .tool-card, [data-theme="dark"] .tool-content-section .tool-card { background: var(--card); border-color: var(--border); }
        [data-theme="dark"] .tool-section-title,
        [data-theme="dark"] .tool-subsection-title,
        [data-theme="dark"] .tool-feature-list li strong,
        [data-theme="dark"] .tool-steps-list li strong { color: var(--text-primary); }
        [data-theme="dark"] .tool-feature-list li,
        [data-theme="dark"] .tool-steps-list li,
        [data-theme="dark"] .tool-use-cases-grid li,
        [data-theme="dark"] .tool-content-section p,
        [data-theme="dark"] .tool-highlight-box { color: var(--text-secondary); }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">URL Shortener &amp; Link Analytics</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <span>URL Shortener</span>
                </nav>
                <span class="tool-header-pitch">
                    Short links + click analytics &amp; QR — <a href="#about">how it works &rarr;</a>
                </span>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Free forever</span>
                <span class="tool-badge">Real-time analytics</span>
                <span class="tool-badge">Auto QR</span>
                <span class="tool-badge">No signup</span>
            </div>
        </div>
    </header>

    <!-- Top Ad Slot -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-ad" style="width:100%;">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Three-Column Layout: Controls | Analytics dashboard | Ads -->
    <main class="tool-page-container">

        <!-- INPUT COLUMN -->
        <div class="tool-input-column">
            <!-- Shorten card -->
            <div class="tool-card" style="margin-bottom:1rem;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M4.715 6.542 3.343 7.914a3 3 0 1 0 4.243 4.243l1.828-1.829A3 3 0 0 0 8.586 5.5L8 6.086a1 1 0 0 0-.154.199 2 2 0 0 1 .861 3.337L6.88 11.45a2 2 0 1 1-2.83-2.83l.793-.792a4 4 0 0 1-.128-1.287z"/><path d="M6.586 4.672A3 3 0 0 0 7.414 9.5l.775-.776a2 2 0 0 1-.896-3.346L9.12 3.55a2 2 0 1 1 2.83 2.83l-.793.792c.112.42.155.855.128 1.287l1.372-1.372a3 3 0 1 0-4.243-4.243L6.586 4.672z"/></svg>
                    Shorten a URL
                </div>
                <div class="tool-card-body">
                    <div class="su-group">
                        <label class="su-label" for="longUrl">Long URL</label>
                        <div class="su-inputwrap">
                            <span class="su-prefix"><svg viewBox="0 0 16 16" fill="currentColor"><path d="M6.354 5.5H4a3 3 0 0 0 0 6h3a3 3 0 0 0 2.83-4H9c-.086 0-.17.01-.25.031A2 2 0 0 1 7 10.5H4a2 2 0 1 1 0-4h1.535c.218-.376.495-.714.82-1z"/><path d="M9 5.5a3 3 0 0 0-2.83 4h1.098A2 2 0 0 1 9 6.5h3a2 2 0 1 1 0 4h-1.535a4.02 4.02 0 0 1-.82 1H12a3 3 0 1 0 0-6H9z"/></svg></span>
                            <input type="url" class="su-input" id="longUrl" placeholder="https://example.com/very/long/link" spellcheck="false" autocomplete="off">
                        </div>
                        <p class="su-hint">Must start with <code style="font-family:'JetBrains Mono',monospace;">http://</code> or <code style="font-family:'JetBrains Mono',monospace;">https://</code></p>
                    </div>

                    <button id="btnShorten" type="button" class="tool-btn tool-btn-primary" style="width:100%;justify-content:center;">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M4.715 6.542 3.343 7.914a3 3 0 1 0 4.243 4.243l1.828-1.829A3 3 0 0 0 8.586 5.5L8 6.086a1 1 0 0 0-.154.199 2 2 0 0 1 .861 3.337L6.88 11.45a2 2 0 1 1-2.83-2.83l.793-.792a4 4 0 0 1-.128-1.287z"/><path d="M6.586 4.672A3 3 0 0 0 7.414 9.5l.775-.776a2 2 0 0 1-.896-3.346L9.12 3.55a2 2 0 1 1 2.83 2.83l-.793.792c.112.42.155.855.128 1.287l1.372-1.372a3 3 0 1 0-4.243-4.243L6.586 4.672z"/></svg>
                        Shorten URL
                    </button>

                    <div id="shortResult" class="su-result">
                        <div class="su-result-top">
                            <a id="shortLink" class="su-shortlink" href="#" target="_blank" rel="noopener"></a>
                        </div>
                        <div class="su-btnrow">
                            <button id="btnCopy" type="button" class="tool-btn tool-btn-sm">Copy</button>
                            <button id="btnOpen" type="button" class="tool-btn tool-btn-sm">Open</button>
                            <button id="btnShare" type="button" class="tool-btn tool-btn-sm">Share</button>
                        </div>
                        <div class="su-qr">
                            <div id="qrcode"></div>
                            <div class="su-qr-side">
                                <span class="su-qr-note">Scan or share offline. Short code auto-filled into Analytics.</span>
                                <button id="btnDownloadQr" type="button" class="tool-btn tool-btn-sm">
                                    <svg width="13" height="13" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                                    Download QR
                                </button>
                            </div>
                        </div>
                    </div>

                    <div id="shortErr" class="su-error" role="alert"></div>
                </div>
            </div>

            <!-- Analytics query card -->
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M0 0h1v15h15v1H0V0Zm14.817 3.113a.5.5 0 0 1 .07.704l-4.5 5.5a.5.5 0 0 1-.74.037L7.06 6.767l-3.656 5.027a.5.5 0 0 1-.808-.588l4-5.5a.5.5 0 0 1 .758-.06l2.609 2.61 4.15-5.073a.5.5 0 0 1 .704-.07Z"/></svg>
                    Link Analytics
                </div>
                <div class="tool-card-body">
                    <div class="su-group">
                        <label class="su-label" for="shortCode">Short Code</label>
                        <div class="su-inputwrap">
                            <span class="su-prefix" style="font-family:'JetBrains Mono',monospace;font-weight:700;">#</span>
                            <input id="shortCode" type="text" class="su-input" placeholder="e.g. abc1234" spellcheck="false" autocomplete="off">
                        </div>
                    </div>
                    <div class="su-group">
                        <div class="su-grid3">
                            <div>
                                <label class="su-label" for="days">Days</label>
                                <div class="su-inputwrap"><input id="days" type="number" class="su-input" value="30" min="1" max="365"></div>
                            </div>
                            <div>
                                <label class="su-label" for="topCountries">Countries</label>
                                <div class="su-inputwrap"><input id="topCountries" type="number" class="su-input" value="5" min="0" max="20"></div>
                            </div>
                            <div>
                                <label class="su-label" for="topReferrers">Referrers</label>
                                <div class="su-inputwrap"><input id="topReferrers" type="number" class="su-input" value="5" min="0" max="20"></div>
                            </div>
                        </div>
                    </div>
                    <button id="btnFetch" type="button" class="tool-btn tool-btn-primary" style="width:100%;justify-content:center;">Fetch Analytics</button>
                    <div id="anaErr" class="su-error" role="alert"></div>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN: Analytics dashboard -->
        <div class="tool-output-column">
            <div class="tool-card" style="flex:1;display:flex;flex-direction:column;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M4 11H2v3h2v-3zm5-4H7v7h2V7zm5-5v12h-2V2h2zm-2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1h-2zM6 7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7zm-5 4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1v-3z"/></svg>
                    Analytics Dashboard
                    <span class="tool-live-indicator" style="margin-left:auto;display:flex;align-items:center;gap:0.4rem;font-size:0.72rem;font-weight:500;">
                        <span class="tool-live-dot"></span> 30-day window
                    </span>
                </div>
                <div class="tool-card-body">
                    <!-- KPIs -->
                    <div class="su-kpis">
                        <div class="su-kpi"><div class="su-kpi-label">All-time Clicks</div><div id="kpiTotal" class="su-kpi-val">—</div></div>
                        <div class="su-kpi"><div class="su-kpi-label">Created At</div><div id="kpiCreated" class="su-kpi-val">—</div></div>
                        <div class="su-kpi"><div class="su-kpi-label">Window Clicks</div><div id="kpiWinClicks" class="su-kpi-val">—</div></div>
                        <div class="su-kpi"><div class="su-kpi-label">Window Uniques</div><div id="kpiWinUniques" class="su-kpi-val">—</div></div>
                    </div>

                    <!-- Chart -->
                    <div class="su-block-title">Clicks Over Time</div>
                    <div class="su-chart-wrap"><canvas id="seriesChart" height="120"></canvas></div>

                    <!-- Tables -->
                    <div class="su-tables">
                        <div>
                            <div class="su-block-title">Top Countries</div>
                            <table class="su-table"><thead><tr><th>Country</th><th>Clicks</th></tr></thead><tbody id="tblCountries"><tr><td colspan="2" class="su-nodata">Fetch a short code to see data</td></tr></tbody></table>
                        </div>
                        <div>
                            <div class="su-block-title">Top Referrers</div>
                            <table class="su-table"><thead><tr><th>Referrer</th><th>Clicks</th></tr></thead><tbody id="tblReferrers"><tr><td colspan="2" class="su-nodata">Fetch a short code to see data</td></tr></tbody></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <aside class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </aside>

    </main>

    <!-- Mobile Ad -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="short.jsp"/>
        <jsp:param name="category" value="Developer Tools"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- About -->
    <section class="tool-content-section" id="about">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                    About the URL Shortener
                </div>
                <div class="tool-card-body">
                    <h2 class="tool-section-title">Free Short Links with Built-in Analytics</h2>
                    <p>Turn long, messy URLs into clean short links in seconds — then track how they perform. Every link gets an automatic QR code and a full analytics view: daily clicks, unique visitors, top countries, and top referrers. No account, no limits.</p>

                    <h3 class="tool-subsection-title">Key Features</h3>
                    <ul class="tool-feature-list">
                        <li><strong>Instant shortening:</strong> paste an <code>http(s)</code> URL and get a short link immediately</li>
                        <li><strong>Automatic QR codes:</strong> every link gets a scannable QR for offline sharing</li>
                        <li><strong>Real-time analytics:</strong> all-time clicks plus a 30-day daily breakdown chart</li>
                        <li><strong>Audience insight:</strong> top countries, top referrers, and unique-visitor counts</li>
                        <li><strong>Permanent &amp; free:</strong> links never expire and there's no registration</li>
                    </ul>

                    <h3 class="tool-subsection-title">Common Use Cases</h3>
                    <div class="tool-use-cases-grid">
                        <ul>
                            <li>Social media posts on X, Instagram, LinkedIn</li>
                            <li>Marketing campaigns with click tracking</li>
                            <li>QR codes for posters, flyers, business cards</li>
                        </ul>
                        <ul>
                            <li>Cleaner links in email newsletters</li>
                            <li>Measuring traffic by country and referrer</li>
                            <li>Sharing professional-looking short URLs</li>
                        </ul>
                    </div>

                    <h3 class="tool-subsection-title">How It Works</h3>
                    <ol class="tool-steps-list">
                        <li><strong>Paste URL:</strong> enter your long link (<code>http://</code> or <code>https://</code>)</li>
                        <li><strong>Shorten:</strong> click <strong>Shorten URL</strong> to create the link and QR code</li>
                        <li><strong>Copy &amp; share:</strong> copy the link, scan the QR, or share directly</li>
                        <li><strong>Track:</strong> the short code auto-fills into <strong>Link Analytics</strong> — click <strong>Fetch Analytics</strong> to view clicks, countries, and referrers</li>
                    </ol>

                    <p class="tool-highlight-box"><strong>Tip:</strong> A normal browser visit (GET) follows the redirect and counts as a click; a HEAD request follows it without counting — handy for link checkers and previews.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>

    <!-- Tool Utilities -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

    <!-- URL shortener + analytics logic -->
    <script>
    (function () {
        var BASE = 'https://ai-inference.xyz';
        var serChart = null;

        function $(id) { return document.getElementById(id); }
        function showErr(id, msg) { var el = $(id); el.textContent = msg; el.style.display = msg ? 'block' : 'none'; }
        function clearErr(id) { showErr(id, ''); }
        function isHttpUrl(u) { return /^https?:\/\//i.test(u || ''); }
        function setKpi(id, v) { $(id).textContent = v; }

        function shorten() {
            clearErr('shortErr');
            var url = $('longUrl').value.trim();
            if (!isHttpUrl(url)) { showErr('shortErr', 'Provide a valid http(s) URL'); return; }
            var btn = $('btnShorten');
            btn.disabled = true;
            fetch(BASE + '/api/shorten', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ url: url }) })
                .then(function (res) { return res.json().catch(function () { return {}; }).then(function (body) { return { status: res.status, body: body }; }); })
                .then(function (resp) {
                    if (resp.status === 201 && resp.body && resp.body.short_url) {
                        var a = $('shortLink');
                        a.textContent = resp.body.short_url; a.href = resp.body.short_url;
                        $('shortResult').classList.add('show');
                        var qrWrap = $('qrcode'); qrWrap.innerHTML = '';
                        new QRCode(qrWrap, { text: resp.body.short_url, width: 96, height: 96 });
                        try {
                            var u = document.createElement('a');
                            u.href = resp.body.short_url;
                            var parts = (u.pathname || '').split('/');
                            var code = parts.pop() || parts.pop();
                            $('shortCode').value = code;
                        } catch (e) {}
                    } else {
                        showErr('shortErr', resp.body && resp.body.error ? resp.body.error : 'Shorten failed');
                    }
                })
                .catch(function () { showErr('shortErr', 'Network error'); })
                .finally(function () { btn.disabled = false; });
        }

        function fillTable(tbodyId, rows, key, val) {
            var tb = $(tbodyId); tb.innerHTML = '';
            if (!rows || !rows.length) { tb.innerHTML = '<tr><td colspan="2" class="su-nodata">No data</td></tr>'; return; }
            rows.forEach(function (r) {
                var tr = document.createElement('tr');
                var c1 = document.createElement('td'); c1.textContent = r[key] || '';
                var c2 = document.createElement('td'); c2.textContent = r[val] || 0;
                tr.appendChild(c1); tr.appendChild(c2); tb.appendChild(tr);
            });
        }

        function fetchAnalytics() {
            clearErr('anaErr');
            var code = ($('shortCode').value || '').trim();
            var days = parseInt($('days').value || '30', 10);
            var tc = parseInt($('topCountries').value || '5', 10);
            var tr = parseInt($('topReferrers').value || '5', 10);
            if (!/^[A-Za-z0-9]{4,12}$/.test(code)) { showErr('anaErr', 'Enter a valid short code [A-Za-z0-9]{4,12}'); return; }
            var btn = $('btnFetch');
            btn.disabled = true;
            var url = BASE + '/api/analytics/' + encodeURIComponent(code) + '?days=' + days + '&top_countries=' + tc + '&top_referrers=' + tr;
            fetch(url, { method: 'GET' })
                .then(function (res) { return res.json().catch(function () { return {}; }).then(function (body) { return { ok: res.ok, body: body }; }); })
                .then(function (resp) {
                    if (resp.ok) {
                        var body = resp.body || {};
                        setKpi('kpiTotal', body.click_count != null ? body.click_count : '—');
                        setKpi('kpiCreated', body.created_at || '—');
                        setKpi('kpiWinClicks', body.total_clicks != null ? body.total_clicks : '—');
                        setKpi('kpiWinUniques', body.total_unique_clicks != null ? body.total_unique_clicks : '0');
                        try {
                            var labels = (body.series || []).map(function (p) { return p.day; });
                            var clicks = (body.series || []).map(function (p) { return p.clicks; });
                            var uniques = (body.series || []).map(function (p) { return p.unique_clicks || 0; });
                            if (serChart) serChart.destroy();
                            var ctx = $('seriesChart').getContext('2d');
                            serChart = new Chart(ctx, {
                                type: 'line',
                                data: {
                                    labels: labels,
                                    datasets: [
                                        { label: 'Clicks', data: clicks, borderColor: '#2563eb', backgroundColor: 'rgba(37,99,235,0.10)', fill: true, tension: 0.25, pointRadius: 2 },
                                        { label: 'Uniques', data: uniques, borderColor: '#0891b2', backgroundColor: 'rgba(8,145,178,0.10)', fill: true, tension: 0.25, pointRadius: 2 }
                                    ]
                                },
                                options: { responsive: true, plugins: { legend: { position: 'top' } }, scales: { y: { beginAtZero: true } } }
                            });
                        } catch (e) {}
                        fillTable('tblCountries', body.top_countries, 'country', 'clicks');
                        fillTable('tblReferrers', body.top_referrers, 'referrer', 'clicks');
                    } else {
                        showErr('anaErr', resp.body && resp.body.error ? resp.body.error : 'Analytics fetch failed');
                    }
                })
                .catch(function () { showErr('anaErr', 'Network error'); })
                .finally(function () { btn.disabled = false; });
        }

        $('btnShorten').addEventListener('click', shorten);
        $('longUrl').addEventListener('keydown', function (e) { if (e.key === 'Enter') shorten(); });
        $('btnOpen').addEventListener('click', function () { var a = $('shortLink'); if (a && a.href) window.open(a.href, '_blank'); });
        $('btnCopy').addEventListener('click', function () {
            var a = $('shortLink');
            if (a && a.href && navigator.clipboard) {
                navigator.clipboard.writeText(a.href).then(function () {
                    var b = $('btnCopy'); var t = b.textContent; b.textContent = 'Copied!';
                    setTimeout(function () { b.textContent = t; }, 1500);
                });
            }
        });
        $('btnShare').addEventListener('click', function () {
            var a = $('shortLink');
            var link = a && a.href ? a.href : '';
            if (!link) { showErr('shortErr', 'Shorten a link first'); return; }
            if (navigator.share) {
                navigator.share({ title: 'Short link', text: 'Check this short link', url: link }).catch(function () {});
            } else if (navigator.clipboard) {
                navigator.clipboard.writeText(link);
            }
        });
        function downloadQR() {
            var wrap = $('qrcode');
            var canvas = wrap.querySelector('canvas');
            var img = wrap.querySelector('img');
            // qrcodejs renders a canvas (and an <img> data-URL fallback) — use whichever is available.
            var dataUrl = canvas ? canvas.toDataURL('image/png') : (img && img.src ? img.src : '');
            if (!dataUrl) { showErr('shortErr', 'Shorten a link first'); return; }
            var code = ($('shortCode').value || 'qr').trim() || 'qr';
            var a = document.createElement('a');
            a.href = dataUrl;
            a.download = 'qr-' + code + '.png';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }

        $('btnDownloadQr').addEventListener('click', downloadQR);
        $('btnFetch').addEventListener('click', fetchAnalytics);
        $('shortCode').addEventListener('keydown', function (e) { if (e.key === 'Enter') fetchAnalytics(); });
    })();
    </script>
</body>
</html>
