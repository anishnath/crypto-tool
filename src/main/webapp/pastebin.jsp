<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Online Pastebin - Paste &amp; Share Code Securely" />
        <jsp:param name="toolDescription" value="Paste and share text or code online. Supports passphrase encryption, burn-after-read, syntax highlighting, inline code execution for supported languages, file uploads, and auto-expiry. No sign-up needed." />
        <jsp:param name="toolCategory" value="Sharing" />
        <jsp:param name="toolUrl" value="pastebin.jsp" />
        <jsp:param name="toolKeywords" value="pastebin, paste code online, share code snippet, encrypted paste, burn after read, anonymous paste, code sharing tool, paste text online, temporary paste, syntax highlighting paste" />
        <jsp:param name="toolImage" value="pastebin.svg" />
        <jsp:param name="toolFeatures" value="Paste text or upload files,Passphrase-encrypted private pastes,Burn-after-read self-destructing pastes,Auto-detect syntax highlighting,Run code inline for supported languages,80+ built-in transform tools (encode decode hash),Configurable expiry (1h to never),Public unlisted and private visibility,No sign-up required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Paste your content|Type or paste text into the editor or switch to File mode to upload a file,Set options|Choose expiry (1h to never) and visibility (public or unlisted or private with passphrase),Apply transforms (optional)|Use the built-in Tools panel to encode decode hash or format your content before sharing,Create paste|Click Create Paste to get a shareable URL and save the delete token to manage it later,Share the URL|Send the paste URL to your recipient and share the passphrase separately for private pastes" />
        <jsp:param name="faq1q" value="How do I share code online using this pastebin?" />
        <jsp:param name="faq1a" value="Paste or type your code, optionally set a title and syntax language, then click Create Paste. You get a shareable URL instantly. No account required." />
        <jsp:param name="faq2q" value="How does encrypted paste work?" />
        <jsp:param name="faq2a" value="Set visibility to Private and enter a passphrase. The server encrypts your paste with the passphrase. Anyone viewing it must enter the same passphrase to decrypt and read the content." />
        <jsp:param name="faq3q" value="What is burn-after-read?" />
        <jsp:param name="faq3a" value="A burn-after-read paste is permanently deleted from the server after it is viewed once. Ideal for sharing passwords, API keys, or other secrets that should not persist." />
        <jsp:param name="faq4q" value="Can I upload files to this pastebin?" />
        <jsp:param name="faq4a" value="Yes. Switch to File mode, drag and drop or browse to select a file. The file is stored on the server and recipients can download it via the raw URL." />
        <jsp:param name="faq5q" value="Does this pastebin support syntax highlighting?" />
        <jsp:param name="faq5a" value="Yes. The pastebin auto-detects the language of your code using highlight.js plus built-in syntax heuristics. You can also manually select from 20+ languages including JavaScript, TypeScript, Python, Java, PHP, Go, Rust, SQL, and more. Runnable languages also get a Run Code option so you can test snippets before or after sharing." />
        <jsp:param name="faq6q" value="What built-in tools does this pastebin have?" />
        <jsp:param name="faq6a" value="Over 80 built-in transforms: Base64/URL/Hex encode and decode, MD5/SHA-256/SHA-512 hashing, JSON/YAML/CSV formatting, AES-256 encryption, ROT13, JWT decode, regex replace, extract URLs/emails/IPs, UUID generation, and more." />
        <jsp:param name="faq7q" value="How long do pastes last?" />
        <jsp:param name="faq7a" value="You choose the expiry: 1 hour, 24 hours, 7 days, 30 days, or never. After expiry the paste is automatically deleted and cannot be recovered." />
        <jsp:param name="faq8q" value="Is this pastebin free to use?" />
        <jsp:param name="faq8a" value="Completely free with no registration, no ads on paste view pages, and no limits on the number of pastes you can create." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#6366f1;--primary-dark:#4f46e5;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

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

    <!-- Highlight.js (language auto-detection + syntax highlighting) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/github.min.css" media="(prefers-color-scheme: light), (prefers-color-scheme: no-preference)">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/github-dark.min.css" media="(prefers-color-scheme: dark)">
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js"></script>

    <style>
        /* Pastebin Theme */
        :root {
            --tool-primary: #10b981;
            --tool-primary-dark: #059669;
            --tool-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --tool-light: #ecfdf5;
        }

        [data-theme="dark"] {
            --tool-gradient: linear-gradient(135deg, #34d399 0%, #10b981 100%);
            --tool-light: rgba(16, 185, 129, 0.12);
        }

        /* Page header + intro — readable, not cramped */
        .tool-page-header { padding: 0.875rem 1.5rem 0.75rem; }
        .tool-page-title { font-size: 1.35rem; font-weight: 700; letter-spacing: -0.02em; }
        .tool-breadcrumbs { margin-top: 0.25rem; font-size: 0.8125rem; }
        .tool-badge { padding: 0.2rem 0.55rem; font-size: 0.6875rem; }
        .tool-description-section { padding: 0.75rem 1.5rem 1rem; }
        .tool-description-content p { font-size: 0.9375rem; line-height: 1.55; max-width: 65ch; }

        /* Two-column layout: wide content + ad sidebar */
        .pb-layout {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 1.75rem;
            max-width: 1600px;
            margin: 0 auto;
            padding: 1.25rem 1.5rem 2rem;
        }

        @media (max-width: 1024px) {
            .pb-layout {
                grid-template-columns: 1fr;
            }
            .pb-ads-col { display: none; }
        }

        @media (max-width: 768px) {
            .pb-layout { padding: 1rem 1rem 1.5rem; }
        }

        /* Main content column */
        .pb-main-col {
            min-width: 0;
        }

        /* Ads column */
        .pb-ads-col {
            height: fit-content;
            position: sticky;
            top: 90px;
        }

        /* Tabs */
        .pb-tabs {
            display: flex;
            gap: 0;
            border-bottom: 2px solid var(--border, #e2e8f0);
            margin-bottom: 0;
        }

        .pb-tab {
            padding: 0.625rem 1.125rem;
            font-size: 0.9375rem;
            font-weight: 600;
            border: none;
            background: transparent;
            color: var(--text-secondary, #475569);
            cursor: pointer;
            position: relative;
            transition: color 0.2s;
        }

        .pb-tab:hover { color: var(--tool-primary); }

        .pb-tab.active {
            color: var(--tool-primary);
        }

        .pb-tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--tool-primary);
        }

        /* Tab panels */
        .pb-panel { display: none; }
        .pb-panel.active { display: block; }

        /* Create form card */
        .pb-card {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0 0 0.75rem 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .pb-card-top {
            border-radius: 0.75rem;
            overflow: hidden;
            border: 1px solid var(--border, #e2e8f0);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        /* Title input — flush, no wrapping div needed */
        .pb-title-input {
            width: 100%;
            padding: 0.625rem 1rem;
            border: none;
            border-bottom: 1px solid var(--border, #e2e8f0);
            font-size: 0.9375rem;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            outline: none;
            transition: border-color 0.15s;
        }

        .pb-title-input:focus { border-bottom-color: var(--tool-primary); }

        .pb-title-input::placeholder { color: var(--text-secondary, #94a3b8); }

        /* Textarea — no extra wrap padding */
        .pb-textarea {
            width: 100%;
            min-height: 320px;
            padding: 0.875rem 1rem;
            border: none;
            border-bottom: 1px solid var(--border, #e2e8f0);
            font-family: 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
            font-size: 0.9375rem;
            line-height: 1.65;
            resize: vertical;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            outline: none;
        }

        .pb-textarea:focus {
            box-shadow: inset 0 -2px 0 var(--tool-primary);
        }

        .pb-textarea::placeholder { color: #94a3b8; }

        [data-theme="dark"] .pb-textarea {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-title-input {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        /* File upload drop zone */
        .pb-dropzone {
            display: none;
            margin: 0.75rem 1rem;
            padding: 2.5rem 1rem;
            border: 2px dashed var(--border, #e2e8f0);
            border-radius: 0.5rem;
            text-align: center;
            color: var(--text-secondary, #475569);
            cursor: pointer;
            transition: border-color 0.2s, background 0.2s;
        }

        .pb-dropzone.active { display: block; }

        .pb-dropzone:hover,
        .pb-dropzone.dragover {
            border-color: var(--tool-primary);
            background: var(--tool-light);
        }

        .pb-dropzone-icon {
            margin-bottom: 0.5rem;
            opacity: 0.5;
        }

        .pb-dropzone-text {
            font-size: 0.875rem;
            font-weight: 500;
        }

        .pb-dropzone-hint {
            font-size: 0.75rem;
            color: var(--text-secondary, #94a3b8);
            margin-top: 0.25rem;
        }

        .pb-file-selected {
            display: none;
            margin: 0 1rem 0.75rem;
            padding: 0.625rem 0.875rem;
            background: var(--tool-light);
            border-radius: 0.375rem;
            font-size: 0.8125rem;
            align-items: center;
            gap: 0.5rem;
        }

        .pb-file-selected.show {
            display: flex;
        }

        .pb-file-name {
            flex: 1;
            font-weight: 500;
            color: var(--tool-primary);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .pb-file-size {
            color: var(--text-secondary, #475569);
            font-size: 0.75rem;
        }

        .pb-file-remove {
            background: none;
            border: none;
            color: #ef4444;
            cursor: pointer;
            padding: 0.125rem;
            font-size: 1rem;
            line-height: 1;
        }

        /* Compact options row — inline selects */
        .pb-options {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.65rem 1rem;
            flex-wrap: wrap;
            row-gap: 0.5rem;
        }

        .pb-opt-group {
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .pb-opt-group label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary, #475569);
            text-transform: uppercase;
            letter-spacing: 0.02em;
            white-space: nowrap;
        }

        .pb-opt-group select {
            padding: 0.375rem 0.5rem;
            min-height: 2.25rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 6px;
            font-size: 0.875rem;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            outline: none;
        }

        .pb-opt-group select:focus { border-color: var(--tool-primary); }

        [data-theme="dark"] .pb-opt-group select {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        .pb-opt-sep {
            width: 1px;
            height: 16px;
            background: var(--border, #e2e8f0);
            flex-shrink: 0;
        }

        /* Burn checkbox — inline with options */
        .pb-check {
            display: flex;
            align-items: center;
            gap: 0.35rem;
            font-size: 0.875rem;
            cursor: pointer;
            color: var(--text-primary, #0f172a);
            white-space: nowrap;
        }

        .pb-check input {
            accent-color: var(--tool-primary);
            width: 0.85rem;
            height: 0.85rem;
        }

        /* Passphrase field (shown conditionally) */
        .pb-passphrase-wrap {
            display: none;
            padding: 0.35rem 0.75rem;
            background: rgba(239, 68, 68, 0.04);
            border-top: 1px solid var(--border, #e2e8f0);
        }

        .pb-passphrase-wrap.show {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .pb-passphrase-input {
            flex: 1;
            max-width: 280px;
            padding: 0.45rem 0.65rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 6px;
            font-size: 0.875rem;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            outline: none;
        }

        .pb-passphrase-input:focus { border-color: var(--tool-primary); }

        .pb-passphrase-hint {
            font-size: 0.75rem;
            color: var(--text-secondary, #94a3b8);
        }

        .pb-spacer { flex: 1; }

        /* Bottom bar: char count + mode + submit */
        .pb-bottom-bar {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            padding: 0.65rem 1rem;
            background: var(--bg-secondary, #f8fafc);
            border-top: 1px solid var(--border, #e2e8f0);
        }

        .pb-char-count {
            font-size: 0.8125rem;
            color: var(--text-secondary, #94a3b8);
            font-variant-numeric: tabular-nums;
        }

        .pb-mode-toggle {
            display: inline-flex;
            background: var(--border, #e2e8f0);
            border-radius: 6px;
            padding: 2px;
        }

        .pb-mode-btn {
            padding: 0.35rem 0.65rem;
            font-size: 0.8125rem;
            font-weight: 500;
            border: none;
            background: transparent;
            color: var(--text-secondary, #475569);
            cursor: pointer;
            border-radius: 3px;
            transition: all 0.15s;
        }

        .pb-mode-btn.active {
            background: var(--bg-primary, #fff);
            color: var(--tool-primary);
            box-shadow: 0 1px 2px rgba(0,0,0,0.08);
        }

        .pb-submit-btn {
            padding: 0.5rem 1.35rem;
            font-weight: 600;
            font-size: 0.9375rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: var(--tool-gradient);
            color: white;
            transition: opacity 0.15s;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .pb-submit-btn:hover { opacity: 0.9; }

        .pb-submit-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .pb-submit-btn.pb-submit-secondary {
            background: #e2e8f0;
            color: #0f172a;
        }

        .pb-submit-btn.pb-submit-secondary:hover {
            opacity: 1;
            background: #cbd5e1;
        }

        .pb-submit-btn.pb-submit-secondary svg {
            color: currentColor;
        }

        .pb-draft-run {
            display: none;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
        }

        .pb-draft-run.show {
            display: block;
        }

        .pb-draft-run-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: 0.85rem 1rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
        }

        .pb-draft-run-head strong {
            color: var(--text-primary, #0f172a);
        }

        .pb-draft-run pre {
            margin: 0;
            padding: 1rem 1.125rem;
            min-height: 120px;
            max-height: 300px;
            overflow: auto;
            white-space: pre-wrap;
            word-break: break-word;
            font-size: 0.9375rem;
            line-height: 1.65;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            color: var(--text-primary, #0f172a);
            background: var(--bg-primary, #fff);
        }

        .pb-draft-run pre.is-empty {
            color: #64748b;
        }

        .pb-draft-run pre.is-error {
            color: #b91c1c;
        }

        .pb-draft-run pre.is-success {
            color: #065f46;
        }

        [data-theme="dark"] .pb-bottom-bar {
            background: #0f172a;
            border-top-color: #334155;
        }

        [data-theme="dark"] .pb-mode-toggle { background: #334155; }

        [data-theme="dark"] .pb-mode-btn.active { background: #1e293b; }

        [data-theme="dark"] .pb-submit-btn.pb-submit-secondary {
            background: #334155;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-submit-btn.pb-submit-secondary:hover {
            background: #475569;
        }

        [data-theme="dark"] .pb-draft-run {
            background: #0f172a;
            border-top-color: #334155;
        }

        [data-theme="dark"] .pb-draft-run-head {
            border-bottom-color: #334155;
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-draft-run-head strong {
            color: #f1f5f9;
        }

        [data-theme="dark"] .pb-draft-run pre {
            background: #0f172a;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-draft-run pre.is-empty {
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-draft-run pre.is-error {
            color: #fca5a5;
        }

        [data-theme="dark"] .pb-draft-run pre.is-success {
            color: #86efac;
        }

        [data-theme="dark"] .pb-passphrase-wrap {
            background: rgba(239, 68, 68, 0.06);
            border-top-color: #334155;
        }

        /* Success result banner */
        .pb-result {
            display: none;
            margin-top: 1rem;
            background: var(--bg-primary, #fff);
            border: 1px solid #86efac;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            animation: pbSlideIn 0.3s ease;
        }

        .pb-result.show { display: block; }

        @keyframes pbSlideIn {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .pb-result-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.9rem 1.1rem;
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            font-weight: 600;
            font-size: 0.9375rem;
            color: #065f46;
        }

        [data-theme="dark"] .pb-result-header {
            background: rgba(16, 185, 129, 0.15);
            color: #6ee7b7;
        }

        [data-theme="dark"] .pb-result {
            background: var(--bg-secondary, #1e293b);
            border-color: rgba(16, 185, 129, 0.3);
        }

        .pb-result-body {
            padding: 1.1rem 1.15rem;
        }

        .pb-result-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 0;
        }

        .pb-result-row + .pb-result-row {
            border-top: 1px solid var(--border, #e2e8f0);
        }

        .pb-result-label {
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-secondary, #475569);
            text-transform: uppercase;
            letter-spacing: 0.3px;
            min-width: 90px;
            flex-shrink: 0;
        }

        .pb-result-value {
            flex: 1;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.875rem;
            color: var(--text-primary, #0f172a);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .pb-result-value a {
            color: var(--tool-primary);
            text-decoration: none;
        }

        .pb-result-value a:hover { text-decoration: underline; }

        .pb-copy-btn {
            padding: 0.35rem 0.6rem;
            font-size: 0.75rem;
            font-weight: 500;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.25rem;
            background: var(--bg-primary, #fff);
            color: var(--text-secondary, #475569);
            cursor: pointer;
            transition: all 0.15s;
            flex-shrink: 0;
        }

        .pb-copy-btn:hover {
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        .pb-copy-btn.copied {
            border-color: var(--tool-primary);
            color: var(--tool-primary);
            background: var(--tool-light);
        }

        .pb-result-warn {
            margin-top: 0.75rem;
            padding: 0.625rem 0.75rem;
            background: #fef3c7;
            border: 1px solid #fcd34d;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            color: #92400e;
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
        }

        [data-theme="dark"] .pb-result-warn {
            background: rgba(251, 191, 36, 0.12);
            border-color: rgba(251, 191, 36, 0.3);
            color: #fcd34d;
        }

        .pb-result-expire {
            font-size: 0.75rem;
            color: var(--text-secondary, #94a3b8);
            margin-top: 0.5rem;
            font-variant-numeric: tabular-nums;
        }

        /* View paste panel */
        .pb-view-card {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        [data-theme="dark"] .pb-view-card {
            background: var(--bg-secondary, #1e293b);
            border-color: #334155;
        }

        .pb-view-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.125rem;
            background: var(--tool-gradient);
            color: white;
            font-weight: 600;
            font-size: 1rem;
        }

        .pb-view-meta {
            display: flex;
            gap: 1rem;
            padding: 0.75rem 1.125rem;
            background: var(--bg-secondary, #f8fafc);
            border-bottom: 1px solid var(--border, #e2e8f0);
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
            flex-wrap: wrap;
        }

        [data-theme="dark"] .pb-view-meta {
            background: #0f172a;
            border-color: #334155;
        }

        .pb-view-meta span {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .pb-view-content {
            padding: 0;
            margin: 0;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            font-size: 0.9375rem;
            line-height: 1.65;
            overflow: auto;
            max-height: 600px;
            color: var(--text-primary, #0f172a);
            background: var(--bg-primary, #fff);
        }

        .pb-view-content code {
            display: block;
            padding: 1.125rem 1.25rem;
            white-space: pre-wrap;
            word-break: break-word;
        }

        /* Override hljs background to match our theme */
        .pb-view-content code.hljs {
            background: var(--bg-primary, #fff);
        }

        [data-theme="dark"] .pb-view-content {
            background: #1e293b;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-view-content code.hljs {
            background: #1e293b;
        }

        .pb-view-actions {
            display: flex;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
            flex-wrap: wrap;
        }

        [data-theme="dark"] .pb-view-actions {
            background: #0f172a;
            border-top-color: #334155;
        }

        .pb-run-panel {
            display: none;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-primary, #fff);
        }

        .pb-run-panel.show {
            display: block;
        }

        .pb-run-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: 0.875rem 1rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            background: rgba(16, 185, 129, 0.06);
        }

        .pb-run-header strong {
            display: block;
            font-size: 1rem;
            color: var(--text-primary, #0f172a);
        }

        .pb-run-header span {
            display: block;
            margin-top: 0.25rem;
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
        }

        .pb-run-status {
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-secondary, #64748b);
            white-space: nowrap;
        }

        .pb-run-status.running { color: #0f766e; }
        .pb-run-status.success { color: #047857; }
        .pb-run-status.error { color: #b91c1c; }

        .pb-run-body {
            padding: 1rem;
        }

        .pb-run-controls {
            display: grid;
            grid-template-columns: minmax(0, 220px) minmax(0, 1fr);
            gap: 1rem;
            align-items: start;
        }

        .pb-run-field label {
            display: block;
            margin-bottom: 0.4rem;
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-secondary, #475569);
        }

        .pb-run-select,
        .pb-run-input {
            width: 100%;
            border: 1px solid var(--border, #dbe2ea);
            border-radius: 0.5rem;
            padding: 0.65rem 0.85rem;
            font-size: 0.9375rem;
            font-family: inherit;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            outline: none;
        }

        .pb-run-input {
            min-height: 110px;
            resize: vertical;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            line-height: 1.5;
        }

        .pb-run-select:focus,
        .pb-run-input:focus {
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.12);
        }

        .pb-run-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            align-items: center;
            margin-top: 1rem;
        }

        .pb-run-note {
            font-size: 0.8125rem;
            color: var(--text-secondary, #64748b);
        }

        .pb-run-output {
            margin-top: 1rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.75rem;
            overflow: hidden;
            background: var(--bg-secondary, #f8fafc);
        }

        .pb-run-output-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            background: rgba(15, 23, 42, 0.04);
        }

        .pb-run-output-header strong {
            font-size: 0.875rem;
            color: var(--text-primary, #0f172a);
        }

        .pb-run-output-meta {
            font-size: 0.8125rem;
            color: var(--text-secondary, #64748b);
        }

        .pb-run-output pre {
            margin: 0;
            padding: 1rem 1.125rem;
            min-height: 120px;
            max-height: 360px;
            overflow: auto;
            white-space: pre-wrap;
            word-break: break-word;
            font-size: 0.9375rem;
            line-height: 1.65;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            color: var(--text-primary, #0f172a);
            background: var(--bg-primary, #fff);
        }

        .pb-run-output pre.is-empty {
            color: #64748b;
        }

        .pb-run-output pre.is-error {
            color: #b91c1c;
        }

        .pb-run-output pre.is-success {
            color: #065f46;
        }

        @media (max-width: 768px) {
            .pb-run-controls {
                grid-template-columns: 1fr;
            }

            .pb-run-header,
            .pb-run-output-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        [data-theme="dark"] .pb-run-panel {
            background: var(--bg-secondary, #1e293b);
            border-top-color: #334155;
        }

        [data-theme="dark"] .pb-run-header {
            background: rgba(16, 185, 129, 0.1);
            border-bottom-color: #334155;
        }

        [data-theme="dark"] .pb-run-header strong,
        [data-theme="dark"] .pb-run-output-header strong {
            color: #f1f5f9;
        }

        [data-theme="dark"] .pb-run-header span,
        [data-theme="dark"] .pb-run-note,
        [data-theme="dark"] .pb-run-output-meta,
        [data-theme="dark"] .pb-run-field label,
        [data-theme="dark"] .pb-run-status {
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-run-select,
        [data-theme="dark"] .pb-run-input {
            background: #0f172a;
            border-color: #334155;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-run-output {
            background: #0f172a;
            border-color: #334155;
        }

        [data-theme="dark"] .pb-run-output-header {
            background: rgba(15, 23, 42, 0.45);
            border-bottom-color: #334155;
        }

        [data-theme="dark"] .pb-run-output pre {
            background: #0f172a;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-run-output pre.is-empty {
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-run-output pre.is-error {
            color: #fca5a5;
        }

        [data-theme="dark"] .pb-run-output pre.is-success {
            color: #86efac;
        }

        /* Passphrase prompt overlay */
        .pb-passphrase-prompt {
            display: none;
            padding: 3rem 1.5rem;
            text-align: center;
        }

        .pb-passphrase-prompt.show { display: block; }

        .pb-passphrase-prompt h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.5rem;
        }

        .pb-passphrase-prompt p {
            font-size: 0.9375rem;
            color: var(--text-secondary, #475569);
            margin-bottom: 1.25rem;
        }

        .pb-passphrase-prompt input {
            width: 100%;
            max-width: 300px;
            padding: 0.65rem 1rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-size: 0.9375rem;
            outline: none;
            text-align: center;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
        }

        .pb-passphrase-prompt input:focus { border-color: var(--tool-primary); }

        .pb-passphrase-prompt button {
            margin-top: 0.75rem;
            padding: 0.5rem 1.5rem;
            background: var(--tool-gradient);
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
        }

        /* Burn warning */
        .pb-burn-warning {
            display: none;
            padding: 2.5rem 1.5rem;
            text-align: center;
        }

        .pb-burn-warning.show { display: block; }

        .pb-burn-warning-icon {
            width: 48px;
            height: 48px;
            margin: 0 auto 1rem;
            color: #f59e0b;
        }

        .pb-burn-warning h3 {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.5rem;
        }

        .pb-burn-warning p {
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
            margin-bottom: 1.25rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        .pb-burn-warning button {
            padding: 0.625rem 1.5rem;
            background: #f59e0b;
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
        }

        /* My pastes panel */
        .pb-my-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.125rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }

        .pb-my-key-input {
            flex: 1;
            max-width: 280px;
            padding: 0.5rem 0.75rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            font-size: 0.875rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            outline: none;
        }

        .pb-my-key-input:focus { border-color: var(--tool-primary); }

        [data-theme="dark"] .pb-my-key-input {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        /* Pastes table */
        .pb-table-wrap {
            overflow-x: auto;
        }

        .pb-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
        }

        .pb-table th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary, #475569);
            background: var(--bg-secondary, #f8fafc);
            border-bottom: 1px solid var(--border, #e2e8f0);
        }

        .pb-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            color: var(--text-primary, #0f172a);
        }

        .pb-table tr:hover td {
            background: var(--tool-light);
        }

        .pb-table a {
            color: var(--tool-primary);
            text-decoration: none;
            font-weight: 500;
        }

        .pb-table a:hover { text-decoration: underline; }

        [data-theme="dark"] .pb-table th {
            background: #0f172a;
            border-color: #334155;
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-table td {
            border-color: #334155;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-table tr:hover td {
            background: rgba(16, 185, 129, 0.08);
        }

        .pb-table-empty {
            padding: 3rem 1rem;
            text-align: center;
            color: var(--text-secondary, #94a3b8);
            font-size: 0.875rem;
        }

        .pb-pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 0.85rem 1rem;
            border-top: 1px solid var(--border, #e2e8f0);
            font-size: 0.875rem;
            color: var(--text-secondary, #475569);
        }

        .pb-pagination button {
            padding: 0.45rem 0.85rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            cursor: pointer;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .pb-pagination button:hover {
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        .pb-pagination button:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        /* Error / status */
        .pb-error {
            display: none;
            margin: 1rem 0 0;
            padding: 0.85rem 1.1rem;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 0.5rem;
            color: #991b1b;
            font-size: 0.9375rem;
            line-height: 1.5;
        }

        .pb-error.show { display: block; }

        [data-theme="dark"] .pb-error {
            background: rgba(239, 68, 68, 0.12);
            border-color: rgba(239, 68, 68, 0.3);
            color: #fca5a5;
        }

        /* Loading spinner */
        .pb-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: pbSpin 0.6s linear infinite;
        }

        @keyframes pbSpin {
            to { transform: rotate(360deg); }
        }

        /* ── Transforms Toolbar (default collapsed in markup + localStorage) ── */
        .pb-transforms {
            border-top: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            background: #f8fafc;
            overflow: hidden;
        }

        /* Header row: icon + "Tools" + search + collapse chevron */
        .pb-transform-header {
            display: flex;
            align-items: center;
            padding: 0.55rem 0.75rem;
            gap: 0.65rem;
            user-select: none;
            border-bottom: 1px solid transparent;
        }
        .pb-transforms:not(.collapsed) .pb-transform-header {
            border-bottom-color: #e2e8f0;
        }
        .pb-transform-header-left {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            font-size: 0.8125rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            color: #64748b;
            cursor: pointer;
            flex-shrink: 0;
        }
        .pb-transform-header-left svg { color: var(--tool-primary, #10b981); }
        .pb-transform-search {
            flex: 1;
            min-width: 0;
            padding: 0.4rem 0.5rem 0.4rem 1.65rem;
            font-size: 0.8125rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: white url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='11' height='11' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0'/%3E%3C/svg%3E") 0.5rem center no-repeat;
            color: #334155;
            outline: none;
            transition: border-color 0.15s;
        }
        .pb-transform-search:focus { border-color: var(--tool-primary, #10b981); }
        .pb-transform-search::placeholder { color: #b0b8c4; font-size: 0.75rem; }
        .pb-transform-chevron {
            cursor: pointer;
            color: #94a3b8;
            transition: transform 0.2s;
            flex-shrink: 0;
            padding: 2px;
        }
        .pb-transforms.collapsed .pb-transform-chevron { transform: rotate(-90deg); }
        .pb-transforms.collapsed .pb-transform-body { display: none; }
        .pb-transforms.collapsed .pb-transform-search { display: none; }

        /* Body: vertical icon tabs (left) + tools grid (right) */
        .pb-transform-body {
            display: flex;
            min-height: 0;
        }

        /* ── Vertical icon tab strip ── */
        .pb-transform-sidebar {
            display: flex;
            flex-direction: column;
            width: 48px;
            flex-shrink: 0;
            background: #f1f5f9;
            border-right: 1px solid #e2e8f0;
            padding: 0.35rem 0;
            gap: 2px;
        }
        .pb-tc {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 2px;
            padding: 0.45rem 0.15rem;
            border: none;
            background: transparent;
            color: #94a3b8;
            cursor: pointer;
            transition: all 0.12s;
            position: relative;
            border-left: 2px solid transparent;
        }
        .pb-tc svg { width: 16px; height: 16px; flex-shrink: 0; }
        .pb-tc-label {
            font-size: 0.625rem;
            font-weight: 600;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            line-height: 1.15;
            max-width: 44px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .pb-tc:hover {
            color: #475569;
            background: #e2e8f0;
        }
        .pb-tc.active {
            color: var(--tool-primary, #10b981);
            background: #f8fafc;
            border-left-color: var(--tool-primary, #10b981);
        }
        .pb-tc .pb-tc-count {
            position: absolute;
            top: 2px;
            right: 2px;
            font-size: 0.5625rem;
            font-weight: 700;
            color: #94a3b8;
            line-height: 1;
        }
        .pb-tc.active .pb-tc-count { color: var(--tool-primary, #10b981); }

        /* ── Right panel: search results + tools grid ── */
        .pb-transform-main {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
        }
        .pb-transform-panel {
            padding: 0.55rem 0.65rem;
            flex: 1;
        }
        .pb-transform-panel-title {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #94a3b8;
            margin-bottom: 0.4rem;
        }
        .pb-transform-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.4rem;
            min-height: 28px;
        }
        .pb-transform-empty {
            font-size: 0.8125rem;
            color: #94a3b8;
            padding: 0.6rem 0;
            font-style: italic;
        }

        /* ── Tool buttons ── */
        .pb-t-btn {
            padding: 0.35rem 0.6rem;
            font-size: 0.8125rem;
            font-weight: 500;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            background: white;
            color: #475569;
            cursor: pointer;
            transition: all 0.12s ease;
            white-space: nowrap;
            line-height: 1.4;
        }
        .pb-t-btn:hover {
            border-color: var(--tool-primary, #10b981);
            color: var(--tool-primary, #10b981);
            background: rgba(16, 185, 129, 0.06);
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.1);
        }
        .pb-t-btn:active { transform: translateY(0); box-shadow: none; }
        .pb-t-btn.pb-t-readonly { border-style: dashed; }
        .pb-t-btn.pb-t-readonly:hover {
            border-color: #6366f1;
            color: #6366f1;
            background: rgba(99, 102, 241, 0.06);
            box-shadow: 0 2px 4px rgba(99, 102, 241, 0.1);
        }
        .pb-t-btn.pb-t-hidden { display: none; }

        /* ── Footer: undo + result strip ── */
        .pb-transform-footer {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.45rem 0.65rem;
            border-top: 1px solid #e2e8f0;
        }
        .pb-transform-undo {
            padding: 0.35rem 0.55rem;
            font-size: 0.8125rem;
            font-weight: 500;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            background: white;
            color: #475569;
            cursor: pointer;
            transition: all 0.15s;
            display: flex;
            align-items: center;
            gap: 0.25rem;
            flex-shrink: 0;
        }
        .pb-transform-undo:hover:not(:disabled) { border-color: #f59e0b; color: #f59e0b; }
        .pb-transform-undo:disabled { opacity: 0.3; cursor: default; }
        .pb-transform-result {
            font-size: 0.75rem;
            font-family: 'SF Mono', 'Fira Code', monospace;
            color: #10b981;
            padding: 0;
            background: rgba(16, 185, 129, 0.08);
            border-radius: 4px;
            flex: 1;
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            opacity: 0;
            max-height: 0;
            transition: all 0.2s ease;
            cursor: text;
            user-select: all;
        }
        .pb-transform-result.show { opacity: 1; max-height: 48px; padding: 0.35rem 0.6rem; }
        .pb-transform-result.error { color: #ef4444; background: rgba(239, 68, 68, 0.08); }

        /* ── Dark mode ── */
        [data-theme="dark"] .pb-transforms { background: #1e293b; border-color: #334155; }
        [data-theme="dark"] .pb-transforms:not(.collapsed) .pb-transform-header { border-bottom-color: #334155; }
        [data-theme="dark"] .pb-transform-search {
            background-color: #0f172a;
            border-color: #334155;
            color: #e2e8f0;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='11' height='11' fill='%23475569' viewBox='0 0 16 16'%3E%3Cpath d='M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: 0.5rem center;
        }
        [data-theme="dark"] .pb-transform-sidebar { background: #151e2e; border-right-color: #334155; }
        [data-theme="dark"] .pb-tc { color: #64748b; }
        [data-theme="dark"] .pb-tc:hover { color: #cbd5e1; background: #1e293b; }
        [data-theme="dark"] .pb-tc.active { color: var(--tool-primary, #10b981); background: #1e293b; }
        [data-theme="dark"] .pb-t-btn { background: #0f172a; border-color: #334155; color: #cbd5e1; }
        [data-theme="dark"] .pb-t-btn:hover { background: rgba(16, 185, 129, 0.1); }
        [data-theme="dark"] .pb-t-btn.pb-t-readonly:hover { background: rgba(99, 102, 241, 0.1); }
        [data-theme="dark"] .pb-transform-undo { background: #0f172a; border-color: #334155; color: #cbd5e1; }
        [data-theme="dark"] .pb-transform-footer { border-top-color: #334155; }
        [data-theme="dark"] .pb-transform-result { background: rgba(16, 185, 129, 0.12); }
        [data-theme="dark"] .pb-transform-result.error { background: rgba(239, 68, 68, 0.12); }

        /* Toast */
        .pb-toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            padding: 0.75rem 1.25rem;
            background: #1e293b;
            color: white;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            z-index: 9999;
            animation: pbToastIn 0.3s ease;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        @keyframes pbToastIn {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* Dark mode for cards */
        [data-theme="dark"] .pb-card,
        [data-theme="dark"] .pb-card-top {
            background: var(--bg-secondary, #1e293b);
            border-color: #334155;
        }

        [data-theme="dark"] .pb-title-input {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-tabs {
            border-color: #334155;
        }

        [data-theme="dark"] .pb-tab {
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-check {
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-opt-group label {
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-passphrase-input {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-copy-btn {
            background: #1e293b;
            border-color: #334155;
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-result-label {
            color: #94a3b8;
        }

        [data-theme="dark"] .pb-result-value {
            color: #e2e8f0;
        }

        [data-theme="dark"] .pb-result-row + .pb-result-row {
            border-top-color: #334155;
        }

        [data-theme="dark"] .pb-pagination button {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        /* Content sections (SEO write-ups) */
        .pb-content-section {
            padding: 2rem 1.5rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .pb-content-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .pb-content-section .tool-card {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .pb-content-section .tool-card-header {
            background: var(--tool-gradient);
            color: white;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .pb-content-section .tool-card-body {
            padding: 1.5rem;
        }

        .pb-section-title {
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--text-primary, #0f172a);
            margin-bottom: 1rem;
            line-height: 1.35;
        }

        .pb-subsection-title {
            font-size: 1.0625rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin: 1.5rem 0 0.75rem;
        }

        .pb-feature-list {
            padding-left: 1.25rem;
            margin-bottom: 1rem;
        }

        .pb-feature-list li {
            margin-bottom: 0.5rem;
            color: var(--text-secondary, #475569);
            line-height: 1.6;
        }

        .pb-feature-list li strong {
            color: var(--text-primary, #0f172a);
        }

        .pb-highlight-box {
            background: var(--tool-light);
            border-left: 4px solid var(--tool-primary);
            padding: 1rem 1.25rem;
            border-radius: 0.5rem;
            margin-top: 1.5rem;
            color: var(--text-secondary, #475569);
        }

        .pb-highlight-box strong {
            color: var(--tool-primary);
        }

        .pb-steps-list {
            padding-left: 1.25rem;
            margin-bottom: 1rem;
        }

        .pb-steps-list li {
            margin-bottom: 0.5rem;
            color: var(--text-secondary, #475569);
            line-height: 1.6;
        }

        .pb-steps-list li strong {
            color: var(--text-primary, #0f172a);
        }

        /* Visible FAQ */
        .pb-faq-list {
            margin: 0.75rem 0 0;
        }

        .pb-faq-list dt {
            font-weight: 600;
            font-size: 1rem;
            color: var(--text-primary, #0f172a);
            padding: 0.75rem 0 0.35rem;
            border-top: 1px solid var(--border, #e2e8f0);
        }

        .pb-faq-list dt:first-child { border-top: none; padding-top: 0; }

        .pb-faq-list dd {
            margin: 0 0 0.65rem 0;
            font-size: 0.9375rem;
            line-height: 1.65;
            color: var(--text-secondary, #475569);
        }

        [data-theme="dark"] .pb-faq-list dt { color: #f1f5f9; border-top-color: #334155; }
        [data-theme="dark"] .pb-faq-list dd { color: #94a3b8; }

        .pb-use-cases-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        @media (max-width: 600px) {
            .pb-use-cases-grid { grid-template-columns: 1fr; }
        }

        .pb-use-cases-grid ul {
            padding-left: 1.25rem;
            margin: 0;
        }

        .pb-use-cases-grid li {
            color: var(--text-secondary, #475569);
            margin-bottom: 0.375rem;
        }

        .pb-trust-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin: 1rem 0;
        }

        @media (max-width: 600px) {
            .pb-trust-grid { grid-template-columns: 1fr; }
        }

        .pb-trust-block ul {
            padding-left: 1.25rem;
            margin: 0;
        }

        .pb-trust-block li {
            color: var(--text-secondary, #475569);
            margin-bottom: 0.375rem;
        }

        .pb-content-section code {
            background: rgba(16, 185, 129, 0.1);
            padding: 0.125rem 0.375rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
            color: var(--tool-primary);
        }

        [data-theme="dark"] .pb-content-section .tool-card {
            background: var(--bg-secondary, #1e293b);
            border-color: #334155;
        }

        [data-theme="dark"] .pb-highlight-box {
            background: rgba(16, 185, 129, 0.1);
        }

        [data-theme="dark"] .pb-section-title,
        [data-theme="dark"] .pb-subsection-title,
        [data-theme="dark"] .pb-feature-list li strong,
        [data-theme="dark"] .pb-steps-list li strong {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .pb-feature-list li,
        [data-theme="dark"] .pb-steps-list li,
        [data-theme="dark"] .pb-use-cases-grid li,
        [data-theme="dark"] .pb-trust-block li,
        [data-theme="dark"] .pb-highlight-box {
            color: var(--text-secondary, #94a3b8);
        }

        /* Matter.js decorative background — non-interactive, behind content */
        .pb-matter-host {
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            overflow: hidden;
        }
        /* Canvas paints above ::before so bodies stay visible (was ::after on top = invisible) */
        .pb-matter-host canvas {
            display: block;
            position: relative;
            z-index: 1;
        }
        /* Aurora-style wash behind the canvas (physics draws on top of ::before) */
        .pb-matter-host::before {
            content: '';
            position: absolute;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            background:
                radial-gradient(ellipse 90% 55% at 10% 15%, rgba(167, 243, 208, 0.55) 0%, transparent 52%),
                radial-gradient(ellipse 70% 50% at 92% 22%, rgba(199, 210, 254, 0.35) 0%, transparent 48%),
                radial-gradient(ellipse 60% 45% at 50% 95%, rgba(110, 231, 183, 0.25) 0%, transparent 45%),
                linear-gradient(165deg, rgba(248, 250, 252, 0.97) 0%, rgba(236, 253, 245, 0.55) 45%, rgba(248, 250, 252, 0.96) 100%);
        }
        [data-theme="dark"] #pb-matter-host.pb-matter-host::before {
            background:
                radial-gradient(ellipse 85% 50% at 12% 12%, rgba(16, 185, 129, 0.22) 0%, transparent 50%),
                radial-gradient(ellipse 65% 55% at 88% 18%, rgba(99, 102, 241, 0.18) 0%, transparent 48%),
                radial-gradient(ellipse 55% 40% at 48% 100%, rgba(52, 211, 153, 0.12) 0%, transparent 42%),
                linear-gradient(168deg, rgba(15, 23, 42, 0.97) 0%, rgba(30, 41, 59, 0.72) 50%, rgba(15, 23, 42, 0.98) 100%);
        }
        /*
         * Critical: a fixed fullscreen #pb-matter-host (z-index:0) paints above in-flow content
         * unless the whole page sits in a higher stacking layer. Do NOT use body>*{z-index:1}
         * — it overrides .modern-nav (1030) and breaks menus. One wrapper fixes both.
         */
        .pb-page-layer {
            position: relative;
            z-index: 1;
            min-height: 100vh;
        }
    </style>
</head>
<body>
    <div id="pb-matter-host" class="pb-matter-host" aria-hidden="true"></div>
    <div class="pb-page-layer">
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Free Online Pastebin</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#sharing">Sharing Tools</a> /
                    <span>Pastebin</span>
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/></svg> Free &middot; No Login</span>
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M8 0c-.69 0-1.843.265-2.928.56-1.11.3-2.229.655-2.887.87a1.54 1.54 0 0 0-1.044 1.262c-.596 4.477.787 7.795 2.465 9.99a11.777 11.777 0 0 0 2.517 2.453c.386.273.744.482 1.048.625.28.132.581.24.829.24s.548-.108.829-.24a7.159 7.159 0 0 0 1.048-.625 11.775 11.775 0 0 0 2.517-2.453c1.678-2.195 3.061-5.513 2.465-9.99a1.541 1.541 0 0 0-1.044-1.263 62.467 62.467 0 0 0-2.887-.87C9.843.266 8.69 0 8 0z"/></svg> Encrypted</span>
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z"/><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5L9.5 0zM10 1.6l3.4 3.4H10V1.6z"/></svg> 80+ Tools</span>
            </div>
        </div>
    </header>

    <!-- Description + Ad Section -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Paste and share text, code, or files online. Supports passphrase encryption, burn-after-read, syntax highlighting, inline code execution for supported languages, and 80+ built-in transform tools.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Main Layout: Content + Ad Sidebar -->
    <main class="pb-layout">

        <!-- Main Content Column -->
        <div class="pb-main-col">

            <!-- Tabs -->
            <div class="pb-card-top">
                <div class="pb-tabs" role="tablist">
                    <button class="pb-tab active" role="tab" data-tab="create" aria-selected="true">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align:-2px;margin-right:4px"><path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/><path d="M2 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2H2z"/></svg>
                        New Paste
                    </button>
                    <button class="pb-tab" role="tab" data-tab="recent" aria-selected="false">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align:-2px;margin-right:4px"><path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0z"/></svg>
                        Recent
                    </button>
                    <button class="pb-tab" role="tab" data-tab="mypastes" aria-selected="false">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align:-2px;margin-right:4px"><path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zM2.5 2a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zM1 10.5A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3z"/></svg>
                        My Pastes
                    </button>
                </div>

                <!-- ==================== CREATE TAB ==================== -->
                <div class="pb-panel active" id="panel-create">
                    <div class="pb-card">
                        <input type="text" id="pb-title" class="pb-title-input" placeholder="Title (optional)" maxlength="200" autocomplete="off">
                        <textarea id="pb-content" class="pb-textarea" placeholder="Paste or type your content here..." spellcheck="false"></textarea>

                        <!-- Transforms Toolbar -->
                        <div class="pb-transforms collapsed" id="pb-transforms">
                            <!-- Header: label + search + collapse (collapsed by default; expanded state in localStorage) -->
                            <div class="pb-transform-header">
                                <div class="pb-transform-header-left pb-transform-toggle" role="button" tabindex="0" aria-expanded="false" aria-controls="pb-transform-body-wrap" title="Expand tools panel (80+ transforms)">
                                    <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M11.42 15.17l-5.658 3.163a1.106 1.106 0 01-1.605-1.056l.76-6.3L.832 6.7a1.101 1.101 0 01.638-1.898l6.305-.606L10.7.936a1.102 1.102 0 011.598 0l2.924 4.26 6.305.606a1.101 1.101 0 01.638 1.898l-4.075 4.277.76 6.3a1.106 1.106 0 01-1.605 1.056L12 15.17z"/></svg>
                                    Tools
                                </div>
                                <input type="text" class="pb-transform-search" id="pb-transform-search" placeholder="Search 80+ tools..." autocomplete="off" spellcheck="false">
                                <svg class="pb-transform-chevron pb-transform-toggle" width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z"/></svg>
                            </div>
                            <!-- Body: vertical sidebar + tools grid -->
                            <div class="pb-transform-body" id="pb-transform-body-wrap">
                                <!-- Left: vertical icon tabs (built by JS) -->
                                <div class="pb-transform-sidebar" id="pb-transform-cats"></div>
                                <!-- Right: tools panel -->
                                <div class="pb-transform-main">
                                    <div class="pb-transform-panel">
                                        <div class="pb-transform-panel-title" id="pb-transform-panel-title"></div>
                                        <div class="pb-transform-grid" id="pb-transform-grid"></div>
                                    </div>
                                    <div class="pb-transform-footer">
                                        <button type="button" class="pb-transform-undo" id="pb-transform-undo" disabled>
                                            <svg width="10" height="10" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"/><path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"/></svg>
                                            Undo
                                        </button>
                                        <div class="pb-transform-result" id="pb-transform-output"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- File dropzone (file mode) -->
                        <div class="pb-dropzone" id="pb-dropzone">
                            <div class="pb-dropzone-icon">
                                <svg width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"/></svg>
                            </div>
                            <div class="pb-dropzone-text">Drop a file here or click to browse</div>
                            <div class="pb-dropzone-hint">Max file size depends on server configuration</div>
                            <input type="file" id="pb-file-input" style="display:none">
                        </div>

                        <!-- Selected file display -->
                        <div class="pb-file-selected" id="pb-file-selected">
                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M4 0h5.293A1 1 0 0 1 10 .293L13.707 4a1 1 0 0 1 .293.707V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2zm5.5 1.5v2a1 1 0 0 0 1 1h2l-3-3z"/></svg>
                            <span class="pb-file-name" id="pb-file-name"></span>
                            <span class="pb-file-size" id="pb-file-size"></span>
                            <button class="pb-file-remove" id="pb-file-remove" title="Remove file">&times;</button>
                        </div>

                        <!-- Options + Burn (single inline row) -->
                        <div class="pb-options">
                            <div class="pb-opt-group">
                                <label for="pb-expiry">Expiry</label>
                                <select id="pb-expiry">
                                    <option value="1h">1 Hour</option>
                                    <option value="24h" selected>24 Hours</option>
                                    <option value="7d">7 Days</option>
                                    <option value="30d">30 Days</option>
                                    <option value="never">Never</option>
                                </select>
                            </div>
                            <div class="pb-opt-group">
                                <label for="pb-visibility">Visibility</label>
                                <select id="pb-visibility">
                                    <option value="public">Public</option>
                                    <option value="unlisted">Unlisted</option>
                                    <option value="private">Private</option>
                                </select>
                            </div>
                            <div class="pb-opt-group">
                                <label for="pb-syntax">Syntax</label>
                                <select id="pb-syntax">
                                    <option value="plain">Plain</option>
                                    <option value="javascript">JS</option>
                                    <option value="typescript">TypeScript</option>
                                    <option value="python">Python</option>
                                    <option value="java">Java</option>
                                    <option value="php">PHP</option>
                                    <option value="ruby">Ruby</option>
                                    <option value="csharp">C#</option>
                                    <option value="kotlin">Kotlin</option>
                                    <option value="swift">Swift</option>
                                    <option value="scala">Scala</option>
                                    <option value="dart">Dart</option>
                                    <option value="lua">Lua</option>
                                    <option value="html">HTML</option>
                                    <option value="css">CSS</option>
                                    <option value="json">JSON</option>
                                    <option value="xml">XML</option>
                                    <option value="sql">SQL</option>
                                    <option value="bash">Bash</option>
                                    <option value="go">Go</option>
                                    <option value="rust">Rust</option>
                                    <option value="c">C</option>
                                    <option value="cpp">C++</option>
                                    <option value="yaml">YAML</option>
                                    <option value="markdown">MD</option>
                                </select>
                            </div>
                            <div class="pb-opt-sep"></div>
                            <label class="pb-check">
                                <input type="checkbox" id="pb-burn"> Burn after read
                            </label>
                        </div>

                        <!-- Passphrase (shown when private) -->
                        <div class="pb-passphrase-wrap" id="pb-passphrase-wrap">
                            <input type="password" id="pb-passphrase" class="pb-passphrase-input" placeholder="Passphrase">
                            <span class="pb-passphrase-hint">Share separately with recipient</span>
                        </div>

                        <!-- Bottom bar -->
                        <div class="pb-bottom-bar">
                            <span class="pb-char-count" id="pb-char-count">0 characters</span>

                            <div class="pb-mode-toggle">
                                <button class="pb-mode-btn active" data-mode="text">Text</button>
                                <button class="pb-mode-btn" data-mode="file">File</button>
                            </div>

                            <span class="pb-spacer"></span>

                            <button class="pb-submit-btn pb-submit-secondary" id="pb-run-draft" type="button" style="display:none">
                                <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M6.271 3.055a.5.5 0 0 1 .52.03l5.5 4a.5.5 0 0 1 0 .81l-5.5 4A.5.5 0 0 1 6 11.5v-8a.5.5 0 0 1 .271-.445z"/></svg>
                                Run Code
                            </button>

                            <button class="pb-submit-btn" id="pb-submit">
                                <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M15.854.146a.5.5 0 0 1 .11.54l-5.819 14.547a.75.75 0 0 1-1.329.124l-3.178-4.995L.643 7.184a.75.75 0 0 1 .124-1.33L15.314.037a.5.5 0 0 1 .54.11ZM6.636 10.07l2.761 4.338L14.13 2.576 6.636 10.07Zm6.787-8.201L1.591 6.602l4.339 2.76 7.494-7.493Z"/></svg>
                                Create Paste
                            </button>
                        </div>
                        <div class="pb-draft-run" id="pb-draft-run-output-wrap">
                            <div class="pb-draft-run-head">
                                <strong>Draft Run Output</strong>
                                <span id="pb-draft-run-meta">No draft run yet</span>
                            </div>
                            <pre id="pb-draft-run-output" class="is-empty">Select a runnable syntax to test your code before creating the paste.</pre>
                        </div>
                    </div>
                </div>

                <!-- ==================== RECENT PASTES TAB ==================== -->
                <div class="pb-panel" id="panel-recent">
                    <div class="pb-card">
                        <div class="pb-table-wrap">
                            <table class="pb-table" id="pb-recent-table">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Syntax</th>
                                        <th>Size</th>
                                        <th>Views</th>
                                        <th>Created</th>
                                    </tr>
                                </thead>
                                <tbody id="pb-recent-body">
                                    <tr><td colspan="5" class="pb-table-empty pb-table-loading">Loading recent pastes&hellip;</td></tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="pb-pagination" id="pb-recent-pagination" style="display:none">
                            <button id="pb-recent-prev" disabled>&laquo; Prev</button>
                            <span id="pb-recent-page-info">Page 1</span>
                            <button id="pb-recent-next">Next &raquo;</button>
                        </div>
                    </div>
                </div>

                <!-- ==================== MY PASTES TAB ==================== -->
                <div class="pb-panel" id="panel-mypastes">
                    <div class="pb-card">
                        <div class="pb-my-header">
                            <input type="text" class="pb-my-key-input" id="pb-api-key" placeholder="API Key (optional)" autocomplete="off">
                            <button class="tool-btn tool-btn-sm" id="pb-gen-key" title="Generate new API key">Generate Key</button>
                            <span class="pb-spacer"></span>
                            <button class="tool-btn tool-btn-sm tool-btn-primary" id="pb-load-pastes">
                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/><path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/></svg>
                                Load
                            </button>
                        </div>
                        <div class="pb-table-wrap">
                            <table class="pb-table" id="pb-pastes-table">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Type</th>
                                        <th>Size</th>
                                        <th>Created</th>
                                        <th>Expires</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="pb-pastes-body">
                                    <tr><td colspan="6" class="pb-table-empty">Click "Load" to fetch your pastes (uses session cookie or API key)</td></tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="pb-pagination" id="pb-pagination" style="display:none">
                            <button id="pb-prev-page" disabled>&laquo; Prev</button>
                            <span id="pb-page-info">Page 1</span>
                            <button id="pb-next-page">Next &raquo;</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Error display -->
            <div class="pb-error" id="pb-error" role="alert"></div>

            <!-- Success result -->
            <div class="pb-result" id="pb-result">
                <div class="pb-result-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg>
                    Paste Created Successfully
                </div>
                <div class="pb-result-body">
                    <div class="pb-result-row">
                        <span class="pb-result-label">Paste URL</span>
                        <span class="pb-result-value"><a id="pb-res-url" href="#" target="_blank"></a></span>
                        <button class="pb-copy-btn" data-copy="pb-res-url">Copy</button>
                    </div>
                    <div class="pb-result-row">
                        <span class="pb-result-label">Raw URL</span>
                        <span class="pb-result-value"><a id="pb-res-raw" href="#" target="_blank"></a></span>
                        <button class="pb-copy-btn" data-copy="pb-res-raw">Copy</button>
                    </div>
                    <div class="pb-result-row">
                        <span class="pb-result-label">Delete Token</span>
                        <span class="pb-result-value" id="pb-res-token"></span>
                        <button class="pb-copy-btn" data-copy="pb-res-token">Copy</button>
                    </div>
                    <div class="pb-result-warn" id="pb-res-burn-warn" style="display:none">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="flex-shrink:0;margin-top:1px"><path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/></svg>
                        <span>This paste will be <strong>permanently deleted</strong> after it is viewed once.</span>
                    </div>
                    <div class="pb-result-warn" id="pb-res-token-warn">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="flex-shrink:0;margin-top:1px"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                        <span>Save the delete token — it's the only way to delete this paste.</span>
                    </div>
                    <div class="pb-result-expire" id="pb-res-expire"></div>
                </div>
            </div>

            <!-- View Paste (shown when viewing a paste by ID) -->
            <div class="pb-view-card" id="pb-view" style="display:none">
                <!-- Burn-after-read warning -->
                <div class="pb-burn-warning" id="pb-burn-gate">
                    <div class="pb-burn-warning-icon">
                        <svg width="48" height="48" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16c3.314 0 6-2.686 6-6 0-3.172-2.327-5.639-4.5-7.506C8.727 1.834 8 1.166 8 1.166S7.273 1.834 6.5 2.494C4.327 4.361 2 6.828 2 10c0 3.314 2.686 6 6 6zm0-1c-2.761 0-5-2.239-5-5 0-2.652 1.952-4.733 3.884-6.413.622-.54 1.116-.944 1.116-.944s.494.404 1.116.944C11.048 5.267 13 7.348 13 10c0 2.761-2.239 5-5 5z"/></svg>
                    </div>
                    <h3>Burn After Read</h3>
                    <p>This paste will be <strong>permanently deleted</strong> after you view it. Are you sure you want to continue?</p>
                    <button id="pb-burn-reveal">View & Destroy</button>
                </div>

                <!-- Passphrase prompt -->
                <div class="pb-passphrase-prompt" id="pb-view-passphrase">
                    <h3>This paste is private</h3>
                    <p>Enter the passphrase to decrypt and view this paste.</p>
                    <input type="password" id="pb-view-pass-input" placeholder="Passphrase">
                    <br>
                    <button id="pb-view-pass-submit">Unlock</button>
                </div>

                <!-- Paste content view -->
                <div id="pb-view-container" style="display:none">
                    <div class="pb-view-header">
                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z"/><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5L9.5 0zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5z"/></svg>
                        <span id="pb-view-title">Untitled Paste</span>
                    </div>
                    <div class="pb-view-meta" id="pb-view-meta"></div>
                    <pre class="pb-view-content" id="pb-view-content"><code id="pb-view-code"></code></pre>
                    <div class="pb-view-actions">
                        <button class="tool-btn tool-btn-sm" id="pb-view-copy">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/><path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/></svg>
                            Copy
                        </button>
                        <a class="tool-btn tool-btn-sm" id="pb-view-raw" href="#" target="_blank">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M10.478 1.647a.5.5 0 1 0-.956-.294l-4 13a.5.5 0 0 0 .956.294l4-13zM4.854 4.146a.5.5 0 0 1 0 .708L1.707 8l3.147 3.146a.5.5 0 0 1-.708.708l-3.5-3.5a.5.5 0 0 1 0-.708l3.5-3.5a.5.5 0 0 1 .708 0zm6.292 0a.5.5 0 0 0 0 .708L14.293 8l-3.147 3.146a.5.5 0 0 0 .708.708l3.5-3.5a.5.5 0 0 0 0-.708l-3.5-3.5a.5.5 0 0 0-.708 0z"/></svg>
                            Raw
                        </a>
                        <button class="tool-btn tool-btn-sm" id="pb-view-download">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                            Download
                        </button>
                        <span class="pb-spacer"></span>
                        <button class="tool-btn tool-btn-sm" id="pb-view-back">
                            &larr; New Paste
                        </button>
                    </div>
                    <section class="pb-run-panel" id="pb-run-panel">
                        <div class="pb-run-header">
                            <div>
                                <strong>Run Code</strong>
                                <span>Execute this paste in the existing OneCompiler sandbox. Execution output is shown below and is not saved back into the paste.</span>
                            </div>
                            <div class="pb-run-status" id="pb-run-status">Idle</div>
                        </div>
                        <div class="pb-run-body">
                            <div class="pb-run-controls">
                                <div class="pb-run-field">
                                    <label for="pb-run-language">Language</label>
                                    <select id="pb-run-language" class="pb-run-select">
                                        <option value="">Select a runnable language</option>
                                    </select>
                                </div>
                                <div class="pb-run-field">
                                    <label for="pb-run-input">Program input (stdin)</label>
                                    <textarea id="pb-run-input" class="pb-run-input" placeholder="Optional stdin passed to the program"></textarea>
                                </div>
                            </div>
                            <div class="pb-run-actions">
                                <button class="tool-btn tool-btn-sm tool-btn-primary" id="pb-run-execute" disabled>Run Code</button>
                                <button class="tool-btn tool-btn-sm" id="pb-run-clear" type="button">Clear Output</button>
                                <span class="pb-run-note" id="pb-run-note">Choose a language to execute this paste.</span>
                            </div>
                            <div class="pb-run-output">
                                <div class="pb-run-output-header">
                                    <strong>Execution Output</strong>
                                    <span class="pb-run-output-meta" id="pb-run-output-meta">No run yet</span>
                                </div>
                                <pre id="pb-run-output" class="is-empty">Run output will appear here.</pre>
                            </div>
                        </div>
                    </section>
                </div>
            </div>

        </div>

        <!-- Ads Column -->
        <aside class="pb-ads-col">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </aside>

    </main>

    <!-- Mobile Ad -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- About Section -->
    <section class="pb-content-section">
        <div class="pb-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                    About This Pastebin
                </div>
                <div class="tool-card-body">
                    <h2 class="pb-section-title">Paste &amp; Share Code, Text, or Files Online</h2>
                    <p>Create and share text snippets, code, or files with this free online pastebin. Passphrase encryption keeps sensitive content secure. Burn-after-read ensures one-time viewing. Run supported languages inline to test code before or after sharing, and use 80+ built-in transform tools to encode, decode, hash, format, and analyze content directly in the editor.</p>

                    <h3 class="pb-subsection-title">Key Features</h3>
                    <ul class="pb-feature-list">
                        <li><strong>Text &amp; File Pastes:</strong> Paste text directly or upload files of any type</li>
                        <li><strong>Passphrase Encryption:</strong> Set visibility to Private and protect your paste with a passphrase</li>
                        <li><strong>Burn After Read:</strong> Paste is permanently deleted after the first view</li>
                        <li><strong>Configurable Expiry:</strong> Choose 1 hour, 24 hours, 7 days, 30 days, or never</li>
                        <li><strong>Syntax Highlighting:</strong> Auto-detects language with manual override for 20+ languages</li>
                        <li><strong>Run Code Inline:</strong> Supported languages show a Run Code action so you can test snippets without leaving the pastebin</li>
                        <li><strong>80+ Built-in Tools:</strong> Base64, URL, Hex encode/decode, MD5/SHA hashing, JSON/YAML formatting, AES-256 encryption, JWT decode, and more</li>
                        <li><strong>My Pastes Dashboard:</strong> Track and manage your pastes with session cookies or API keys</li>
                    </ul>

                    <h3 class="pb-subsection-title">Popular Use Cases</h3>
                    <div class="pb-use-cases-grid">
                        <ul>
                            <li>Sharing code snippets with colleagues</li>
                            <li>Sending configuration files or logs</li>
                            <li>Sharing API responses for debugging</li>
                            <li>Quick temporary note sharing</li>
                        </ul>
                        <ul>
                            <li>Sending passwords or API keys securely</li>
                            <li>Sharing build outputs and error traces</li>
                            <li>Anonymous text publishing</li>
                            <li>One-time secret sharing (burn mode)</li>
                        </ul>
                    </div>

                    <h3 class="pb-subsection-title">How to Use</h3>
                    <ol class="pb-steps-list">
                        <li><strong>Enter Content:</strong> Type or paste text, or switch to File mode to upload a file</li>
                        <li><strong>Configure Options:</strong> Set title, expiry, visibility, and syntax highlighting</li>
                        <li><strong>Run Code (optional):</strong> If the selected syntax is runnable, click Run Code to test the snippet before sharing</li>
                        <li><strong>Create Paste:</strong> Click "Create Paste" to get a shareable URL and delete token</li>
                        <li><strong>Share:</strong> Send the paste URL. If private, share the passphrase separately</li>
                    </ol>

                    <h3 class="pb-subsection-title">Frequently Asked Questions</h3>
                    <dl class="pb-faq-list">
                        <dt>How do I share code online using this pastebin?</dt>
                        <dd>Paste or type your code, optionally set a title and syntax language, then click Create Paste. You get a shareable URL instantly. No account required.</dd>
                        <dt>How does encrypted paste work?</dt>
                        <dd>Set visibility to Private and enter a passphrase. The server encrypts your paste. Anyone viewing it must enter the same passphrase to decrypt and read the content.</dd>
                        <dt>What is burn-after-read?</dt>
                        <dd>A burn-after-read paste is permanently deleted from the server after it is viewed once. Ideal for sharing passwords, API keys, or other secrets that should not persist.</dd>
                        <dt>Can I upload files to this pastebin?</dt>
                        <dd>Yes. Switch to File mode, drag and drop or browse to select a file. The file is stored on the server and recipients can download it via the raw URL.</dd>
                        <dt>Does this pastebin support syntax highlighting?</dt>
                        <dd>Yes. The pastebin auto-detects the language of your code using highlight.js plus built-in syntax heuristics. You can also manually select from 20+ languages including JavaScript, TypeScript, Python, Java, PHP, Go, Rust, SQL, and more. Runnable languages also get a Run Code option so you can test snippets before or after sharing.</dd>
                        <dt>What built-in tools does this pastebin have?</dt>
                        <dd>Over 80 built-in transforms: Base64/URL/Hex encode and decode, MD5/SHA-256/SHA-512 hashing, JSON/YAML/CSV formatting, AES-256 encryption, ROT13, JWT decode, regex replace, extract URLs/emails/IPs, UUID generation, and more.</dd>
                        <dt>How long do pastes last?</dt>
                        <dd>You choose the expiry: 1 hour, 24 hours, 7 days, 30 days, or never. After expiry the paste is automatically deleted and cannot be recovered.</dd>
                        <dt>Is this pastebin free to use?</dt>
                        <dd>Completely free with no registration, no ads on paste view pages, and no limits on the number of pastes you can create.</dd>
                    </dl>

                    <div class="pb-highlight-box"><strong>Privacy First:</strong> Private pastes require a passphrase to view. Burn-after-read pastes are deleted from the server after a single view. No registration or personal data is required.</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Trust & Methodology Section -->
    <section class="pb-content-section">
        <div class="pb-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 0c-.69 0-1.843.265-2.928.56-1.11.3-2.229.655-2.887.87a1.54 1.54 0 0 0-1.044 1.262c-.596 4.477.787 7.795 2.465 9.99a11.777 11.777 0 0 0 2.517 2.453c.386.273.744.482 1.048.625.28.132.581.24.829.24s.548-.108.829-.24a7.159 7.159 0 0 0 1.048-.625 11.775 11.775 0 0 0 2.517-2.453c1.678-2.195 3.061-5.513 2.465-9.99a1.541 1.541 0 0 0-1.044-1.263 62.467 62.467 0 0 0-2.887-.87C9.843.266 8.69 0 8 0z"/></svg>
                    About This Tool & Methodology
                </div>
                <div class="tool-card-body">
                    <p>This pastebin stores pastes on a dedicated backend server. Private pastes are encrypted server-side with the provided passphrase. All API communication uses HTTPS.</p>

                    <div class="pb-trust-grid">
                        <div class="pb-trust-block">
                            <h3 class="pb-subsection-title">Authorship & Review</h3>
                            <ul>
                                <li><strong>Author:</strong> 8gwifi.org engineering team</li>
                                <li><strong>Reviewed by:</strong> Anish Nath (tools maintainer)</li>
                                <li><strong>Last updated:</strong> 2026-03-10</li>
                            </ul>
                        </div>
                        <div class="pb-trust-block">
                            <h3 class="pb-subsection-title">Trust & Privacy</h3>
                            <ul>
                                <li>Private pastes require a passphrase for access.</li>
                                <li>Burn-after-read pastes are permanently deleted after one view.</li>
                                <li>No personal data or registration required.</li>
                                <li>Questions? <a href="<%=request.getContextPath()%>/contactus.jsp" style="color:var(--tool-primary)">Contact us</a>.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    </div><!-- /.pb-page-layer -->

    <!-- Bootstrap JS -->
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Tool Utilities -->
    <script defer src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script defer src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

    <!-- Matter.js: subtle floating “paste” background (skipped if prefers-reduced-motion) -->
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js" crossorigin="anonymous"></script>
    <script defer src="<%=request.getContextPath()%>/js/pastebin-matter-bg.js?v=<%=cacheVersion%>"></script>

    <!-- Pastebin Config + JS -->
    <script>
    window.PASTEBIN_CONFIG = {
        apiBase: '<%=request.getContextPath()%>/api/pastebin',
        ctxPath: '<%=request.getContextPath()%>',
        compilerExecuteUrl: '<%=request.getContextPath()%>/OneCompilerFunctionality?action=execute'
    };
    </script>
    <script defer src="<%=request.getContextPath()%>/js/pastebin.js"></script>
</body>
</html>
