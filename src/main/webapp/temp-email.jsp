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
    <link rel="dns-prefetch" href="https://api.procmail.xyz">
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
        <jsp:param name="toolName" value="Temporary Email Online - Free Disposable Inbox" />
        <jsp:param name="toolDescription" value="Generate a free disposable email address instantly and receive mail in a real-time inbox. No registration, no password, auto-refresh every 30 seconds. Perfect for sign-ups, testing, and privacy." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="temp-email.jsp" />
        <jsp:param name="toolKeywords" value="temporary email, temp email, disposable email, fake email, throwaway email, temp mail, disposable inbox, anonymous email, temp email generator, free temp email" />
        <jsp:param name="toolImage" value="temp-email-og.png" />
        <jsp:param name="toolFeatures" value="Instant disposable email generation,Real-time inbox with auto-refresh,Custom local-part selection,View plain text and HTML body,No registration or password,Anonymous and private,Copy address to clipboard,Free with no limits" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Generate address|A disposable address is created automatically when the page loads. Customize the name before @goodbanners.xyz if you like.,Copy your address|Click Copy to put the temp email on your clipboard, then paste it into any sign-up form.,Receive mail|Incoming messages appear in the inbox automatically — it auto-refreshes every 30 seconds.,Read messages|Click any message to expand and read both the plain-text and HTML versions." />
        <jsp:param name="faq1q" value="What is a temporary email address?" />
        <jsp:param name="faq1a" value="A temporary (disposable) email address is a short-term inbox you can use to receive mail without revealing your real email. Ideal for sign-ups, testing, and avoiding spam. No registration or password required." />
        <jsp:param name="faq2q" value="How long does the temporary email last?" />
        <jsp:param name="faq2a" value="The address stays active for your session and receives mail in real time with auto-refresh every 30 seconds. Bookmark the page with your chosen address to keep using it." />
        <jsp:param name="faq3q" value="Is this temporary email service free?" />
        <jsp:param name="faq3a" value="Yes — completely free with no registration, login, or payment. Generate unlimited disposable addresses with no time limits." />
        <jsp:param name="faq4q" value="Can I choose my own temp email address?" />
        <jsp:param name="faq4a" value="Yes. Type any name you want before @goodbanners.xyz. The system generates one for you, but you can change the local part to anything you prefer." />
        <jsp:param name="faq5q" value="Is this temporary email anonymous and private?" />
        <jsp:param name="faq5a" value="Temporary addresses require no personal information, registration, or verification. Note that they are not suitable for sensitive communications — anyone with the address can read its inbox." />
        <jsp:param name="faq6q" value="What can I use temporary email for?" />
        <jsp:param name="faq6a" value="Website sign-ups, avoiding spam, downloads that need email verification, one-time registrations, and development or testing. Not recommended for important accounts or sensitive data." />
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
        /* Temp-Email tool accent — a fresh teal identity over the shared design system */
        :root {
            --tool-primary: oklch(0.585 0.118 195.0);
            --tool-primary-dark: oklch(0.480 0.110 200.0);
            --tool-gradient: linear-gradient(135deg, oklch(0.585 0.118 195.0) 0%, oklch(0.480 0.110 200.0) 100%);
            --tool-light: oklch(0.960 0.030 195.0);
            --tool-ring: oklch(0.585 0.118 195.0);
        }
        .dark, [data-theme="dark"] {
            --tool-primary: oklch(0.800 0.110 192.0);
            --tool-primary-dark: oklch(0.700 0.110 196.0);
            --tool-gradient: linear-gradient(135deg, oklch(0.800 0.110 192.0) 0%, oklch(0.700 0.110 196.0) 100%);
            --tool-light: oklch(0.446 0.037 164.7 / 55%);
        }

        /* ---- Compact page header (mirrors reference layout) ---- */
        .tool-page-header {
            padding: 0.5rem 1rem !important;
            min-height: 0 !important;
            background: linear-gradient(135deg, oklch(0.993 0.002 145.6) 0%, oklch(0.982 0.006 137.8) 100%);
            border-bottom: 1px solid var(--border);
        }
        .tool-page-header-inner {
            display: flex !important; align-items: center !important;
            gap: 0.75rem; flex-wrap: wrap;
            padding: 0 !important; margin: 0 auto !important; max-width: 1400px;
        }
        .tool-page-header-inner > div:first-child {
            display: flex; align-items: baseline; gap: 0.75rem; flex-wrap: wrap; min-width: 0;
        }
        .tool-page-title {
            font-size: 1.05rem !important; font-weight: 700 !important;
            margin: 0 !important; line-height: 1.25 !important;
            letter-spacing: -0.01em; color: var(--foreground);
        }
        .tool-breadcrumbs { font-size: 0.72rem !important; line-height: 1.25 !important; margin: 0 !important; color: var(--text-secondary); }
        .tool-breadcrumbs a { color: var(--tool-primary); text-decoration: none; }
        .tool-breadcrumbs a:hover { text-decoration: underline; }
        .tool-header-pitch {
            font-size: 0.72rem; line-height: 1.25; color: var(--text-secondary);
            padding-left: 0.6rem; margin-left: 0.6rem; border-left: 1px solid var(--border); white-space: nowrap;
        }
        .tool-header-pitch a { color: var(--tool-primary); font-weight: 600; text-decoration: none; margin-left: 0.25rem; }
        .tool-header-pitch a:hover { text-decoration: underline; }
        .tool-page-badges { display: flex; gap: 0.3rem; margin-left: auto; flex-wrap: wrap; }
        .tool-badge {
            padding: 0.12rem 0.45rem !important; font-size: 0.68rem !important; line-height: 1.3 !important;
            border-radius: 9999px !important; display: inline-flex; align-items: center; gap: 0.25rem;
            background: var(--tool-light); color: var(--tool-primary-dark);
            border: 1px solid oklch(0.585 0.118 195.0 / 22%); font-weight: 600;
        }
        .dark .tool-badge, [data-theme="dark"] .tool-badge {
            background: oklch(0.800 0.110 192.0 / 15%); color: var(--tool-primary);
            border-color: oklch(0.800 0.110 192.0 / 30%);
        }
        .tool-badge svg { width: 11px; height: 11px; }
        @media (max-width: 640px) {
            .tool-header-pitch { display: block; padding-left: 0; margin-left: 0; border-left: none; white-space: normal; margin-top: 0.15rem; }
            .tool-page-title { font-size: 0.95rem !important; }
            .tool-page-badges { margin-left: 0; }
        }
        .tool-description-section { padding: 0.5rem 1rem !important; }

        /* ---- Address card ---- */
        .te-address-row {
            display: flex; align-items: stretch; gap: 0;
            border: 1px solid var(--border); border-radius: 0.6rem; overflow: hidden;
            background: var(--bg-primary); margin: 1rem; box-shadow: 0 1px 2px rgba(0,0,0,0.04);
        }
        .te-address-row:focus-within { border-color: var(--tool-primary); box-shadow: 0 0 0 3px oklch(0.585 0.118 195.0 / 18%); }
        #local {
            flex: 1; min-width: 0; border: none; outline: none; background: transparent;
            font-family: 'JetBrains Mono', monospace; font-size: 0.95rem; font-weight: 600;
            padding: 0.7rem 0.85rem; color: var(--text-primary); text-align: right;
        }
        .te-domain {
            display: flex; align-items: center; padding: 0 0.85rem;
            font-family: 'JetBrains Mono', monospace; font-size: 0.92rem;
            color: var(--tool-primary-dark); background: var(--tool-light);
            border-left: 1px solid var(--border); white-space: nowrap;
        }
        .dark .te-domain, [data-theme="dark"] .te-domain { color: var(--tool-primary); }
        .te-hint { padding: 0 1rem 0.5rem; font-size: 0.75rem; color: var(--text-muted); }
        .te-hint code {
            background: oklch(0.585 0.118 195.0 / 12%); color: var(--tool-primary-dark);
            padding: 0.06rem 0.3rem; border-radius: 0.25rem; font-size: 0.72rem;
        }

        /* Trust chips — replaces the old four-card trust banner */
        .te-chips { display: flex; flex-wrap: wrap; gap: 0.4rem; padding: 0 1rem 1rem; }
        .te-chip {
            display: inline-flex; align-items: center; gap: 0.35rem;
            font-size: 0.72rem; font-weight: 500; color: var(--text-secondary);
            background: var(--bg-tertiary); border: 1px solid var(--border);
            border-radius: 9999px; padding: 0.25rem 0.6rem;
        }
        .te-chip svg { width: 12px; height: 12px; color: var(--tool-primary); }

        /* ---- Inbox messages (custom collapsible, no Bootstrap) ---- */
        #inbox { position: relative; padding: 0.75rem; min-height: 220px; }
        .te-spinner-wrap { position: absolute; top: 0.9rem; right: 0.9rem; display: none; }
        .te-spinner-wrap.show { display: block; }
        .te-spinner {
            width: 22px; height: 22px; border: 2.5px solid var(--border);
            border-top-color: var(--tool-primary); border-radius: 50%;
            animation: teSpin 0.8s linear infinite;
        }
        @keyframes teSpin { to { transform: rotate(360deg); } }

        .te-empty {
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            gap: 0.6rem; padding: 2.5rem 1rem; text-align: center; color: var(--text-muted);
        }
        .te-empty svg { width: 42px; height: 42px; color: var(--tool-primary); opacity: 0.55; }
        .te-empty p { font-size: 0.85rem; margin: 0; }
        .te-empty .te-empty-sub { font-size: 0.75rem; color: var(--text-muted); }

        .te-msg {
            border: 1px solid var(--border); border-radius: 0.6rem;
            background: var(--bg-primary); margin-bottom: 0.6rem; overflow: hidden;
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        .te-msg.open { border-color: var(--tool-primary); box-shadow: 0 2px 10px oklch(0.585 0.118 195.0 / 14%); }
        .te-msg-head {
            display: flex; align-items: center; gap: 0.7rem; width: 100%;
            padding: 0.7rem 0.85rem; background: none; border: none; cursor: pointer; text-align: left;
            font-family: inherit; color: var(--text-primary);
        }
        .te-msg-head:hover { background: var(--bg-tertiary); }
        .te-avatar {
            flex-shrink: 0; width: 34px; height: 34px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.85rem; color: #fff; background: var(--tool-gradient);
        }
        .te-msg-meta { flex: 1; min-width: 0; }
        .te-msg-from { font-size: 0.82rem; font-weight: 600; color: var(--text-primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .te-msg-subject { font-size: 0.8rem; color: var(--text-secondary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .te-msg-time { flex-shrink: 0; font-size: 0.68rem; color: var(--text-muted); white-space: nowrap; }
        .te-caret { flex-shrink: 0; transition: transform 0.2s; color: var(--text-muted); }
        .te-msg.open .te-caret { transform: rotate(180deg); }

        .te-msg-body { max-height: 0; overflow: hidden; transition: max-height 0.25s ease; }
        .te-msg.open .te-msg-body { max-height: 4000px; }
        .te-msg-body-inner { padding: 0.25rem 0.95rem 0.95rem; border-top: 1px dashed var(--border); }
        .te-field { font-size: 0.78rem; margin: 0.5rem 0 0; color: var(--text-secondary); }
        .te-field b { color: var(--text-primary); font-weight: 600; }
        .te-divider { border: none; border-top: 1px solid var(--border); margin: 0.75rem 0; }
        .te-section-label { font-size: 0.68rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--tool-primary-dark); margin: 0.75rem 0 0.35rem; }
        .dark .te-section-label, [data-theme="dark"] .te-section-label { color: var(--tool-primary); }
        .te-plain {
            white-space: pre-wrap; word-break: break-word; font-family: 'JetBrains Mono', monospace;
            font-size: 0.75rem; background: var(--bg-tertiary); border: 1px solid var(--border);
            border-radius: 0.4rem; padding: 0.6rem; color: var(--text-primary); margin: 0;
        }
        .te-html {
            border: 1px solid var(--border); border-radius: 0.4rem; padding: 0.6rem;
            background: #fff; color: #1e293b; overflow-x: auto; font-size: 0.82rem;
        }

        /* ---- Content section (single compact About card replaces 5 cards) ---- */
        .tool-content-section { padding: 2rem 1.5rem; max-width: 1200px; margin: 0 auto; }
        .tool-content-container { max-width: 900px; margin: 0 auto; }
        .tool-content-section .tool-card {
            background: var(--bg-primary); border: 1px solid var(--border);
            border-radius: 1rem; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .tool-content-section .tool-card-header {
            background: var(--tool-gradient); color: #fff; padding: 1rem 1.5rem;
            display: flex; align-items: center; gap: 0.5rem; font-weight: 600; font-size: 1.1rem;
        }
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
        .tool-highlight-box {
            background: var(--tool-light); border-left: 4px solid var(--tool-primary);
            padding: 1rem 1.25rem; border-radius: 0.5rem; margin-top: 1.5rem; color: var(--text-secondary);
        }
        .tool-highlight-box strong { color: var(--tool-primary-dark); }
        .dark .tool-highlight-box, [data-theme="dark"] .tool-highlight-box { background: oklch(0.800 0.110 192.0 / 15%); }
        .dark .tool-highlight-box strong, [data-theme="dark"] .tool-highlight-box strong { color: var(--tool-primary); }
        .tool-content-section p { color: var(--text-secondary); line-height: 1.6; }
        .tool-content-section code {
            background: oklch(0.585 0.118 195.0 / 12%); padding: 0.125rem 0.375rem;
            border-radius: 0.25rem; font-size: 0.875rem; color: var(--tool-primary-dark);
        }
        .dark .tool-content-section .tool-card, [data-theme="dark"] .tool-content-section .tool-card {
            background: var(--card); border-color: var(--border);
        }
        [data-theme="dark"] .tool-section-title,
        [data-theme="dark"] .tool-subsection-title,
        [data-theme="dark"] .tool-feature-list li strong,
        [data-theme="dark"] .tool-steps-list li strong { color: var(--text-primary); }
        [data-theme="dark"] .tool-feature-list li,
        [data-theme="dark"] .tool-steps-list li,
        [data-theme="dark"] .tool-use-cases-grid li,
        [data-theme="dark"] .tool-content-section p,
        [data-theme="dark"] .tool-highlight-box { color: var(--text-secondary); }

        .tool-actions-divider { width: 1px; height: 20px; background: var(--border); margin: 0 0.25rem; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Temporary Email</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <span>Temp Email</span>
                </nav>
                <span class="tool-header-pitch">
                    Powered by
                    <a href="https://procmail.xyz" target="_blank" rel="noopener noreferrer">procmail.xyz &rarr;</a>
                </span>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">
                    <svg viewBox="0 0 16 16" fill="currentColor"><path d="M16 4.5a.5.5 0 0 1-.5.5h-15a.5.5 0 0 1 0-1h15a.5.5 0 0 1 .5.5zm0 3a.5.5 0 0 1-.5.5h-15a.5.5 0 0 1 0-1h15a.5.5 0 0 1 .5.5z"/></svg>
                    No signup
                </span>
                <span class="tool-badge">
                    <svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 1a7 7 0 1 0 0 14A7 7 0 0 0 8 1zM0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8z"/><path d="M8 3.5a.5.5 0 0 1 .5.5v3.793l2.354 2.353a.5.5 0 0 1-.708.708l-2.5-2.5A.5.5 0 0 1 7.5 8V4a.5.5 0 0 1 .5-.5z"/></svg>
                    Auto-refresh 30s
                </span>
                <span class="tool-badge">
                    <svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/></svg>
                    Private
                </span>
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

    <!-- Three-Column Layout: Address (controls) | Inbox (output) | Ads -->
    <main class="tool-page-container">

        <!-- INPUT COLUMN: Your temporary address -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2zm13 2.383-4.708 2.825L15 11.105V5.383zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741zM1 11.105l4.708-2.897L1 5.383v5.722z"/></svg>
                    Your Temporary Email
                </div>

                <div class="te-address-row">
                    <input type="text" id="local" placeholder="local-part" spellcheck="false"
                           autocomplete="off" aria-label="Temporary email local part">
                    <span class="te-domain" id="domain">@goodbanners.xyz</span>
                </div>

                <p class="te-hint">Pick any name before <code>@goodbanners.xyz</code> — that becomes your inbox.</p>

                <!-- Actions -->
                <div class="tool-actions-bar">
                    <button class="tool-btn tool-btn-primary" type="button" id="copyBtn" aria-label="Copy email address">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/><path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/></svg>
                        Copy
                    </button>
                    <button class="tool-btn" type="button" id="generateNewBtn" aria-label="Generate new email">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/><path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/></svg>
                        New
                    </button>
                </div>

                <div class="te-chips">
                    <span class="te-chip"><svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/></svg> No registration</span>
                    <span class="te-chip"><svg viewBox="0 0 16 16" fill="currentColor"><path d="M11.251.068a.5.5 0 0 1 .227.58L9.677 6.5H13a.5.5 0 0 1 .364.843l-8 8.5a.5.5 0 0 1-.842-.49L6.323 9.5H3a.5.5 0 0 1-.364-.843l8-8.5a.5.5 0 0 1 .615-.09z"/></svg> Real-time</span>
                    <span class="te-chip"><svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 0c-.69 0-1.843.265-2.928.56-1.11.3-2.229.655-2.887.87a1.54 1.54 0 0 0-1.044 1.262c-.596 4.477.787 7.795 2.465 9.99a11.777 11.777 0 0 0 2.517 2.453c.386.273.744.482 1.048.625.28.132.581.24.829.24s.548-.108.829-.24a7.159 7.159 0 0 0 1.048-.625 11.775 11.775 0 0 0 2.517-2.453c1.678-2.195 3.061-5.513 2.465-9.99a1.541 1.541 0 0 0-1.044-1.263 62.467 62.467 0 0 0-2.887-.87C9.843.266 8.69 0 8 0z"/></svg> Anonymous</span>
                    <span class="te-chip"><svg viewBox="0 0 16 16" fill="currentColor"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/><path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8zM1.173 8a13.133 13.133 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13.133 13.133 0 0 1 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5c-2.12 0-3.879-1.168-5.168-2.457A13.134 13.134 0 0 1 1.172 8z"/></svg> Free forever</span>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN: Inbox -->
        <div class="tool-output-column">
            <div class="tool-card" style="flex:1;display:flex;flex-direction:column;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/></svg>
                    Inbox
                    <div class="tool-live-indicator" style="margin-left:auto;display:flex;align-items:center;gap:0.4rem;">
                        <span class="tool-live-dot"></span> <span id="countdown">Next refresh: 30s</span>
                    </div>
                </div>

                <!-- Toolbar -->
                <div class="tool-actions-bar">
                    <button class="tool-btn tool-btn-sm tool-btn-primary" type="button" id="manualRefreshBtn" aria-label="Refresh inbox now">
                        <svg width="13" height="13" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/><path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/></svg>
                        Refresh
                    </button>
                    <div class="tool-actions-spacer"></div>
                    <span id="msgCount" class="te-chip" style="border:none;background:transparent;color:var(--text-muted);">0 messages</span>
                </div>

                <!-- Inbox body -->
                <div class="tool-card-body" style="padding:0;flex:1;">
                    <div id="inbox">
                        <div class="te-spinner-wrap" id="spinner"><div class="te-spinner" role="status" aria-label="Loading"></div></div>
                        <div id="messageList"></div>
                        <div id="emptyMsg" class="te-empty">
                            <svg viewBox="0 0 16 16" fill="currentColor"><path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/></svg>
                            <p>Loading your inbox…</p>
                            <span class="te-empty-sub">Messages sent to your temp address appear here automatically.</span>
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
        <jsp:param name="currentToolUrl" value="temp-email.jsp"/>
        <jsp:param name="category" value="Developer Tools"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- About (single compact section replaces the old 5 SEO cards) -->
    <section class="tool-content-section">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                    About Temporary Email
                </div>
                <div class="tool-card-body">
                    <h2 class="tool-section-title">Free Disposable Email, Instantly</h2>
                    <p>Generate a disposable email address the moment this page loads and receive messages in a real-time inbox — no registration, no password, nothing to install. Use it for sign-ups, downloads, testing, and anywhere you'd rather not hand over your real address.</p>

                    <h3 class="tool-subsection-title">Key Features</h3>
                    <ul class="tool-feature-list">
                        <li><strong>Instant generation:</strong> a fresh <code>@goodbanners.xyz</code> address is ready on page load — or pick your own local part</li>
                        <li><strong>Real-time inbox:</strong> incoming mail appears automatically, with auto-refresh every 30 seconds</li>
                        <li><strong>Full message view:</strong> read both plain-text and HTML bodies, with sender and timestamp</li>
                        <li><strong>No account:</strong> no sign-up, no password, no tracking required</li>
                        <li><strong>Free with no limits:</strong> generate as many disposable addresses as you need</li>
                    </ul>

                    <h3 class="tool-subsection-title">Common Use Cases</h3>
                    <div class="tool-use-cases-grid">
                        <ul>
                            <li>Website sign-ups and trial accounts</li>
                            <li>Spam prevention for untrusted services</li>
                            <li>File downloads that require verification</li>
                        </ul>
                        <ul>
                            <li>Email functionality testing in development</li>
                            <li>One-time registration codes</li>
                            <li>Staying anonymous online</li>
                        </ul>
                    </div>

                    <h3 class="tool-subsection-title">How to Use</h3>
                    <ol class="tool-steps-list">
                        <li><strong>Generate:</strong> an address is created automatically — customize the name before <code>@goodbanners.xyz</code> or click <strong>New</strong></li>
                        <li><strong>Copy:</strong> click <strong>Copy</strong> and paste the address into any sign-up form</li>
                        <li><strong>Receive:</strong> messages arrive in the inbox automatically every 30 seconds</li>
                        <li><strong>Read:</strong> click any message to expand its plain-text and HTML content</li>
                    </ol>

                    <p class="tool-highlight-box"><strong>Heads up:</strong> temporary inboxes are public to anyone who knows the address. Don't use them for banking, work, or sensitive accounts — they're built for throwaway, low-stakes mail only.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Tool Utilities -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

    <!-- Temp Email logic -->
    <script>
    (function () {
        const FETCH_INTERVAL = 30;
        const DOMAIN = '@goodbanners.xyz';
        const API = 'https://api.procmail.xyz';

        let countdown = FETCH_INTERVAL;
        let countdownInterval = null;
        let fetchTimer = null;

        const $ = (id) => document.getElementById(id);
        const localEl = $('local');

        function escapeHtml(s) {
            return String(s == null ? '' : s)
                .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
        }

        function getEmail() { return localEl.value.trim() + DOMAIN; }

        async function generateEmail() {
            try {
                const res = await fetch(API + '/generate');
                const fullEmail = (await res.text()).trim();
                localEl.value = fullEmail.split('@')[0];
            } catch (e) {
                // Fallback: random local part if the API is unreachable
                localEl.value = 'temp' + Math.floor(Math.random() * 1e6).toString(36);
            }
        }

        // RFC 2047 MIME encoded-word decoding for subject/sender display
        function decodeMIMEWord(str) {
            if (!str) return str;
            return str.replace(/=\?([^?]+)\?([BQbq])\?([^?]*)\?=/g, (m, charset, enc, txt) => {
                try {
                    if (enc.toUpperCase() === 'Q') {
                        let d = txt.replace(/_/g, ' ').replace(/=([0-9A-F]{2})/gi, (x, h) => String.fromCharCode(parseInt(h, 16)));
                        try { return decodeURIComponent(escape(d)); } catch (e) { return d; }
                    }
                    const d = atob(txt);
                    try { return decodeURIComponent(escape(d)); } catch (e) { return d; }
                } catch (e) { return m; }
            });
        }

        function initials(name, email) {
            const src = (name || email || '?').trim();
            const parts = src.replace(/[<>"]/g, '').split(/[\s@.]+/).filter(Boolean);
            if (!parts.length) return '?';
            return (parts[0][0] + (parts[1] ? parts[1][0] : '')).toUpperCase();
        }

        function fmtTime(s) {
            if (!s) return '';
            const d = new Date(s);
            if (isNaN(d)) return escapeHtml(s);
            return d.toLocaleString(undefined, { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
        }

        function renderMessages(messages) {
            const list = $('messageList');
            messages.sort((a, b) => new Date(b.ReceivedAt) - new Date(a.ReceivedAt));
            const html = messages.map((msg, idx) => {
                const m = String(msg.Sender || '').match(/^(.*)<([^>]+)>/);
                const name = m ? m[1].trim().replace(/^"|"$/g, '') : (msg.Sender || 'Unknown');
                const email = m ? m[2].trim() : '';
                const subject = decodeMIMEWord(msg.Subject) || '(no subject)';
                return ''
                    + '<div class="te-msg' + (idx === 0 ? ' open' : '') + '">'
                    +   '<button class="te-msg-head" type="button" data-idx="' + idx + '">'
                    +     '<span class="te-avatar">' + escapeHtml(initials(name, email)) + '</span>'
                    +     '<span class="te-msg-meta">'
                    +       '<span class="te-msg-from">' + escapeHtml(name) + '</span>'
                    +       '<span class="te-msg-subject">' + escapeHtml(subject) + '</span>'
                    +     '</span>'
                    +     '<span class="te-msg-time">' + fmtTime(msg.ReceivedAt) + '</span>'
                    +     '<svg class="te-caret" width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z"/></svg>'
                    +   '</button>'
                    +   '<div class="te-msg-body"><div class="te-msg-body-inner">'
                    +     '<p class="te-field"><b>From:</b> ' + escapeHtml(name) + (email ? ' &lt;' + escapeHtml(email) + '&gt;' : '') + '</p>'
                    +     '<p class="te-field"><b>Subject:</b> ' + escapeHtml(subject) + '</p>'
                    +     '<p class="te-field"><b>Received:</b> ' + escapeHtml(msg.ReceivedAt || '') + '</p>'
                    +     '<hr class="te-divider">'
                    +     (msg.PlainTextBody ? '<div class="te-section-label">Plain text</div><pre class="te-plain">' + escapeHtml(msg.PlainTextBody) + '</pre>' : '')
                    +     (msg.HTMLBody ? '<div class="te-section-label">HTML</div><div class="te-html">' + msg.HTMLBody + '</div>' : '')
                    +   '</div></div>'
                    + '</div>';
            }).join('');
            list.innerHTML = html;
            list.querySelectorAll('.te-msg-head').forEach((btn) => {
                btn.addEventListener('click', () => btn.closest('.te-msg').classList.toggle('open'));
            });
            $('msgCount').textContent = messages.length + (messages.length === 1 ? ' message' : ' messages');
        }

        function showEmpty(text, sub) {
            $('messageList').innerHTML = '';
            const empty = $('emptyMsg');
            empty.style.display = 'flex';
            empty.querySelector('p').textContent = text;
            const subEl = empty.querySelector('.te-empty-sub');
            if (subEl) subEl.textContent = sub || '';
            $('msgCount').textContent = '0 messages';
        }

        async function fetchInbox() {
            const spinner = $('spinner');
            spinner.classList.add('show');
            try {
                const res = await fetch(API + '/inbox/' + encodeURIComponent(getEmail()));
                const data = await res.json();
                if (!data || data.length === 0) {
                    showEmpty('No messages yet', 'Mail sent to your temp address shows up here automatically.');
                } else {
                    $('emptyMsg').style.display = 'none';
                    renderMessages(data);
                }
            } catch (e) {
                showEmpty('Could not reach inbox', e.message);
            } finally {
                spinner.classList.remove('show');
            }
        }

        function startCountdown() {
            const el = $('countdown');
            clearInterval(countdownInterval);
            countdown = FETCH_INTERVAL;
            el.textContent = 'Next refresh: ' + countdown + 's';
            countdownInterval = setInterval(() => {
                countdown--;
                el.textContent = countdown > 0 ? 'Next refresh: ' + countdown + 's' : 'Refreshing…';
                if (countdown <= 0) clearInterval(countdownInterval);
            }, 1000);
        }

        async function scheduleFetch() {
            startCountdown();
            await fetchInbox();
            clearTimeout(fetchTimer);
            fetchTimer = setTimeout(scheduleFetch, FETCH_INTERVAL * 1000);
        }

        function flashBtn(btn, label) {
            const original = btn.innerHTML;
            btn.innerHTML = label;
            btn.disabled = true;
            setTimeout(() => { btn.innerHTML = original; btn.disabled = false; }, 1500);
        }

        function setup() {
            $('copyBtn').addEventListener('click', () => {
                navigator.clipboard.writeText(getEmail()).then(() => {
                    flashBtn($('copyBtn'), '<svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z"/></svg> Copied!');
                });
            });

            $('generateNewBtn').addEventListener('click', async () => {
                const btn = $('generateNewBtn');
                const original = btn.innerHTML;
                btn.disabled = true;
                btn.innerHTML = '<div class="te-spinner" style="width:14px;height:14px;border-width:2px;display:inline-block;vertical-align:middle;"></div> …';
                await generateEmail();
                btn.innerHTML = original;
                btn.disabled = false;
                scheduleFetch();
            });

            $('manualRefreshBtn').addEventListener('click', async () => {
                const btn = $('manualRefreshBtn');
                btn.disabled = true;
                await fetchInbox();
                startCountdown();
                clearTimeout(fetchTimer);
                fetchTimer = setTimeout(scheduleFetch, FETCH_INTERVAL * 1000);
                btn.disabled = false;
            });

            // Refetch when the user edits the local part (debounced)
            let editTimer = null;
            localEl.addEventListener('input', () => {
                clearTimeout(editTimer);
                editTimer = setTimeout(() => { scheduleFetch(); }, 600);
            });
        }

        document.addEventListener('DOMContentLoaded', async () => {
            setup();
            await generateEmail();
            scheduleFetch();
        });
    })();
    </script>
</body>
</html>
