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
    <link rel="dns-prefetch" href="https://code.jquery.com">

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#667eea;--primary-dark:#5a67d8;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="PGP Key Generator Online - Free RSA 2048 & 4096-bit Keys" />
        <jsp:param name="toolDescription" value="Generate PGP key pairs online free. RSA 2048 or 4096-bit with AES-256 encryption. OpenPGP RFC 4880 compliant. No data stored. Compatible with GnuPG." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="pgpkeyfunction.jsp" />
        <jsp:param name="toolKeywords" value="pgp key generator, pgp key generation online, generate pgp keys, rsa key pair generator, pgp public key, pgp private key, openpgp key generator, free pgp key generator, aes-256, twofish, blowfish, rfc 4880, pgp python keygen, pgp key pair online, gpg key generator" />
        <jsp:param name="toolImage" value="pgp.png" />
        <jsp:param name="toolFeatures" value="Generate RSA public/private key pairs (2048-4096 bit),Multiple cipher algorithms: AES-256 TWOFISH BLOWFISH CAST5 TRIPLE_DES,OpenPGP standard (RFC 4880) compliant,Built-in Python compiler for PGP key generation code,Email key pair delivery option,Custom identity and passphrase support,Passphrase strength indicator,Secure passphrase generator,No data retention - keys generated in memory,No software to install - browser-based tool,HTTPS/TLS encryption for data transmission,Compatible with GnuPG and all OpenPGP software" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the difference between RSA key sizes (1024, 2048, 4096)?" />
        <jsp:param name="faq1a" value="RSA key size determines security strength. 1024-bit is weak and not recommended. 2048-bit is the current standard with strong security. 4096-bit offers maximum security for long-term protection but slower performance. Use 2048-bit minimum for new keys." />
        <jsp:param name="faq2q" value="Which cipher algorithm should I choose for PGP key generation?" />
        <jsp:param name="faq2a" value="Choose AES-256 for maximum security (256-bit key). TWOFISH is a good alternative. BLOWFISH, CAST5, and TRIPLE_DES are legacy algorithms - use only for compatibility with older systems." />
        <jsp:param name="faq3q" value="Is it safe to generate PGP keys online?" />
        <jsp:param name="faq3a" value="This tool implements zero data retention - keys are never stored or logged. All processing is in-memory with HTTPS encryption. For maximum security with highly sensitive applications, use offline tools like GnuPG." />
        <jsp:param name="faq4q" value="What should I do with my PGP keys after generation?" />
        <jsp:param name="faq4a" value="Save your private key securely and never share it. Share your public key freely via keyservers. Test your keys using the PGP Encrypt/Decrypt tool. Generate a revocation certificate immediately." />
        <jsp:param name="faq5q" value="Can I use the generated keys with GPG/GnuPG?" />
        <jsp:param name="faq5a" value="Yes, generated keys follow OpenPGP standard (RFC 4880) and are compatible with GnuPG, PGP Desktop, OpenKeychain, Mailvelope, and Thunderbird/Enigmail. Keys are in ASCII-armored format." />
        <jsp:param name="faq6q" value="How do I generate PGP keys in Python?" />
        <jsp:param name="faq6a" value="Use the pgpy library. This tool includes a built-in Python compiler with ready-to-run PGP key generation templates. Click Try It Live in the output panel to generate keys with Python code instantly." />
        <jsp:param name="faq7q" value="How strong should my passphrase be?" />
        <jsp:param name="faq7a" value="Use at least 16 characters combining uppercase, lowercase, numbers, and symbols. A strong passphrase is critical because if you forget it, encrypted data cannot be recovered. Use the built-in passphrase generator for secure random passphrases." />
        <jsp:param name="faq8q" value="What is the identity field and what should I enter?" />
        <jsp:param name="faq8a" value="The identity associates your PGP key with your name or email. Use formats like 'John Doe' or 'john@example.com'. This appears in key metadata and helps others verify they are using the correct public key." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <style>
        /* PGP Key Generator - Compact input, spacious output */

        /* Override grid: narrower input column, more output space */
        .tool-page-container {
            grid-template-columns: minmax(280px, 320px) 1fr 300px;
        }
        @media (max-width: 1024px) {
            .tool-page-container { grid-template-columns: minmax(270px, 310px) 1fr; }
        }

        /* Compact form padding */
        .tool-form-section { padding: 0.875rem; }

        /* Section labels - no card wrappers, just clean dividers */
        .pgk-section-label {
            display: flex;
            align-items: center;
            gap: 0.375rem;
            font-size: 0.6875rem;
            font-weight: 700;
            color: var(--text-secondary, #64748b);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin: 0.75rem 0 0.5rem 0;
            padding-bottom: 0.375rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }
        .pgk-section-label:first-child { margin-top: 0; }

        /* Label and hint - tighter */
        .tool-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.25rem;
        }

        .tool-hint {
            font-size: 0.6875rem;
            color: var(--text-secondary, #64748b);
            margin: 0 0 0.375rem 0;
        }

        .tool-badge-info {
            background: #dbeafe;
            color: #1e40af;
            padding: 0.0625rem 0.375rem;
            border-radius: 0.25rem;
            font-size: 0.5625rem;
            font-weight: 600;
            margin-left: 0.125rem;
            vertical-align: middle;
        }

        [data-theme="dark"] .tool-badge-info {
            background: rgba(59, 130, 246, 0.2);
            color: #93c5fd;
        }

        /* Form groups - tight spacing */
        .pgk-form-group { margin-bottom: 0.625rem; }
        .pgk-form-group:last-child { margin-bottom: 0; }

        /* Sticky action buttons at bottom of input column */
        .pgk-sticky-actions {
            position: sticky;
            bottom: 0;
            background: var(--bg-primary, #fff);
            padding: 0.75rem 0.875rem;
            border-top: 1px solid var(--border, #e2e8f0);
            margin: 0 -0.875rem -0.875rem;
            border-radius: 0 0 0.75rem 0.75rem;
            display: flex;
            gap: 0.375rem;
            z-index: 5;
        }

        .pgk-sticky-actions .tool-action-btn {
            flex: 1;
            padding: 0.625rem 0.5rem;
            font-size: 0.8125rem;
        }

        /* Cipher & key size options - compact chips */
        .pgk-options-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.375rem;
            margin-top: 0.25rem;
        }

        .pgk-option-label {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.3125rem 0.625rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            cursor: pointer;
            font-size: 0.75rem;
            font-weight: 500;
            color: var(--text-primary, #0f172a);
            background: var(--bg-primary, #ffffff);
            transition: all 0.15s;
        }

        .pgk-option-label:hover {
            border-color: var(--primary, #667eea);
            background: rgba(102, 126, 234, 0.05);
        }

        .pgk-option-label input[type="radio"] { display: none; }

        .pgk-option-label:has(input:checked) {
            border-color: var(--primary, #667eea);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
        }
        .pgk-option-label.selected {
            border-color: var(--primary, #667eea);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
        }

        .pgk-option-label.selected .pgk-badge-rec,
        .pgk-option-label:has(input:checked) .pgk-badge-rec {
            background: rgba(255, 255, 255, 0.3);
            color: #fff;
        }

        .pgk-option-label.selected .pgk-badge-legacy,
        .pgk-option-label:has(input:checked) .pgk-badge-legacy,
        .pgk-option-label.selected .pgk-badge-weak,
        .pgk-option-label:has(input:checked) .pgk-badge-weak {
            background: rgba(255, 255, 255, 0.25);
            color: #fff;
        }

        .pgk-badge-rec {
            background: #dcfce7;
            color: #166534;
            padding: 0rem 0.3125rem;
            border-radius: 0.5rem;
            font-size: 0.5625rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .pgk-badge-legacy {
            background: #fef3c7;
            color: #92400e;
            padding: 0rem 0.3125rem;
            border-radius: 0.5rem;
            font-size: 0.5625rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .pgk-badge-weak {
            background: #fee2e2;
            color: #991b1b;
            padding: 0rem 0.3125rem;
            border-radius: 0.5rem;
            font-size: 0.5625rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        [data-theme="dark"] .pgk-badge-rec { background: rgba(22, 163, 74, 0.2); color: #86efac; }
        [data-theme="dark"] .pgk-badge-legacy { background: rgba(251, 191, 36, 0.15); color: #fcd34d; }
        [data-theme="dark"] .pgk-badge-weak { background: rgba(239, 68, 68, 0.15); color: #fca5a5; }
        [data-theme="dark"] .pgk-option-label { background: var(--bg-primary); color: var(--text-primary); border-color: var(--border); }

        /* Passphrase - inline buttons */
        .pgk-passphrase-row {
            display: flex;
            gap: 0.375rem;
            align-items: center;
        }
        .pgk-passphrase-row .tool-input { flex: 1; font-size: 0.8125rem; padding: 0.4375rem 0.625rem; }

        .pgk-passphrase-btn {
            padding: 0.4375rem 0.5rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-secondary, #475569);
            cursor: pointer;
            font-size: 0.8125rem;
            transition: all 0.15s;
            flex-shrink: 0;
            line-height: 1;
        }
        .pgk-passphrase-btn:hover { background: var(--border); color: var(--text-primary); }

        .pgk-strength-bar {
            height: 3px;
            border-radius: 1.5px;
            background: var(--border, #e2e8f0);
            margin-top: 0.375rem;
            overflow: hidden;
        }

        .pgk-strength-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
            border-radius: 1.5px;
        }
        .pgk-strength-fill.weak { background: #ef4444; width: 25%; }
        .pgk-strength-fill.fair { background: #f59e0b; width: 50%; }
        .pgk-strength-fill.good { background: #06b6d4; width: 75%; }
        .pgk-strength-fill.strong { background: #22c55e; width: 100%; }

        .pgk-strength-text {
            font-size: 0.625rem;
            margin-top: 0.125rem;
            font-weight: 600;
        }

        /* Info box - compact */
        .tool-info-box {
            margin-top: 0.5rem;
            padding: 0.375rem 0.625rem;
            background: #fef3c7;
            border-radius: 0.3125rem;
            font-size: 0.6875rem;
            color: #92400e;
        }
        [data-theme="dark"] .tool-info-box { background: rgba(251, 191, 36, 0.15); color: #fcd34d; }

        /* ========== OUTPUT COLUMN STYLES ========== */
        .tool-result-card {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .tool-result-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: var(--bg-secondary, #f8fafc);
            border-bottom: 1px solid var(--border, #e2e8f0);
            border-radius: 0.75rem 0.75rem 0 0;
        }

        .tool-result-header h4 {
            margin: 0;
            font-size: 0.9375rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
        }

        .tool-result-content {
            flex: 1;
            padding: 1.25rem;
            min-height: 400px;
            overflow-y: auto;
        }

        #output textarea {
            width: 100%;
            min-height: 200px;
            padding: 0.875rem;
            border: 2px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8rem;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-primary, #0f172a);
            resize: vertical;
        }

        .tool-output-wrapper { position: relative; }

        .tool-copy-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            padding: 0.375rem 0.75rem;
            background: var(--tool-primary, var(--primary));
            color: white;
            border: none;
            border-radius: 0.375rem;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.2s;
            z-index: 10;
        }
        .tool-copy-btn:hover { transform: translateY(-1px); }

        .pgk-key-card-actions {
            display: flex;
            gap: 0.375rem;
        }

        .pgk-key-action-btn {
            padding: 0.25rem 0.625rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            background: var(--bg-primary, #fff);
            color: var(--text-secondary);
            font-size: 0.75rem;
            cursor: pointer;
            transition: all 0.15s;
            font-family: inherit;
        }
        .pgk-key-action-btn:hover {
            background: var(--primary, #667eea);
            color: #fff;
            border-color: var(--primary, #667eea);
        }

        /* Result actions row */
        .tool-result-actions {
            display: none;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0 0 0.75rem 0.75rem;
            flex-wrap: wrap;
        }
        .tool-result-actions.visible { display: flex; }
        .tool-result-actions .tool-action-btn { flex: 1; min-width: 100px; margin-top: 0; }

        .tool-action-btn-secondary { background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%); }
        .tool-action-btn-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }

        /* Dark mode overrides */
        [data-theme="dark"] .tool-alert-success { background: rgba(16, 185, 129, 0.15); border-color: rgba(16, 185, 129, 0.3); color: #6ee7b7; }
        [data-theme="dark"] .tool-alert-error { background: rgba(239, 68, 68, 0.15); border-color: rgba(239, 68, 68, 0.3); color: #fca5a5; }
        [data-theme="dark"] .tool-alert-info { background: rgba(59, 130, 246, 0.15); border-color: rgba(59, 130, 246, 0.3); color: #93c5fd; }

        /* Key generation animation - compact */
        .pgk-keygen-flow {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 2rem 1.5rem;
            gap: 0.875rem;
        }

        .pgk-flow-step {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            width: 100%;
            max-width: 360px;
            animation: pgkFadeIn 0.6s ease both;
        }

        .pgk-flow-step:nth-child(2) { animation-delay: 0.2s; }
        .pgk-flow-step:nth-child(3) { animation-delay: 0.4s; }
        .pgk-flow-step:nth-child(4) { animation-delay: 0.6s; }
        .pgk-flow-step:nth-child(5) { animation-delay: 0.8s; }

        .pgk-flow-num {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            font-size: 0.6875rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .pgk-flow-text {
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
        }
        .pgk-flow-text strong { color: var(--text-primary, #0f172a); }

        @keyframes pgkFadeIn {
            from { opacity: 0; transform: translateX(-10px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .pgk-flow-caption {
            font-size: 0.8125rem;
            color: var(--text-secondary);
            text-align: center;
            margin-top: 0.5rem;
        }

        /* Output tabs */
        .pgp-output-tabs{display:flex;gap:0;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.75rem}
        .pgp-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;font-family:inherit;text-align:center}
        .pgp-output-tab.active{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff}
        .pgp-output-tab:hover:not(.active){background:var(--border)}
        [data-theme="dark"] .pgp-output-tab{background:rgba(255,255,255,0.05)}
        [data-theme="dark"] .pgp-output-tab.active{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff}
        .pgp-panel{display:none;flex:1;min-height:0}.pgp-panel.active{display:flex;flex-direction:column}
        #pgk-panel-output .tool-result-card{flex:1}
        #pgk-panel-python{min-height:540px}

        /* FAQ accordion */
        .faq-item{border:1px solid var(--border,#e2e8f0);border-radius:0.5rem;margin-bottom:0.5rem;overflow:hidden}
        .faq-question{padding:0.75rem 1rem;font-weight:600;font-size:0.875rem;color:var(--text-primary,#0f172a);background:var(--bg-secondary,#f8fafc);border:none;width:100%;cursor:pointer;display:flex;align-items:center;justify-content:space-between;gap:0.75rem;font-family:inherit;text-align:left}
        .faq-question:hover{background:var(--border,#f1f5f9)}
        .faq-answer{display:none;padding:0.75rem 1rem;font-size:0.8125rem;line-height:1.6;color:var(--text-secondary,#475569);border-top:1px solid var(--border,#e2e8f0)}
        .faq-item.open .faq-answer{display:block}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-chevron{transition:transform .2s;flex-shrink:0}
        [data-theme="dark"] .faq-question{background:rgba(255,255,255,0.05);color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .faq-question:hover{background:rgba(255,255,255,0.08)}
        [data-theme="dark"] .faq-answer{color:var(--text-secondary,#cbd5e1);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .faq-item{border-color:var(--border,#334155)}

        /* Email modal */
        .pgk-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .pgk-modal-overlay.active { display: flex; }

        .pgk-modal {
            background: var(--bg-primary, #fff);
            border-radius: 0.75rem;
            padding: 1.5rem;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .pgk-modal h3 { margin: 0 0 1rem 0; font-size: 1.125rem; color: var(--text-primary); }

        .pgk-modal-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            justify-content: flex-end;
        }

        .pgk-modal-cancel {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            background: var(--bg-secondary);
            color: var(--text-primary);
            cursor: pointer;
            font-family: inherit;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .tool-page-container { grid-template-columns: 1fr; }
            .pgk-sticky-actions { position: static; margin: 0.5rem 0 0; border-top: none; padding: 0; }
        }
        @media (max-width: 768px) {
            .tool-result-actions { flex-direction: column; }
            .tool-result-actions .tool-action-btn { width: 100%; }
            .pgk-passphrase-row { flex-wrap: wrap; }
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
                <h1 class="tool-page-title">PGP Key Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    <a href="<%=request.getContextPath()%>/pgpencdec.jsp">PGP Tools</a> /
                    Key Generator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">OpenPGP RFC 4880</span>
                <span class="tool-badge">RSA 2048-4096 bit</span>
                <span class="tool-badge">Python Compiler</span>
                <span class="tool-badge">No Data Stored</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online PGP key pair generator implementing OpenPGP standard (RFC 4880). Generate RSA public/private keys with multiple cipher options (AES-256, TWOFISH, BLOWFISH). Choose 2048 or 4096-bit key sizes. Run PGP key generation Python code in your browser. No data retained.</p>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN (Compact) ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <form id="pgkForm" method="POST" enctype="application/x-www-form-urlencoded">
                    <input type="hidden" name="methodName" id="methodName" value="GENERATE_PGEP_KEY">
                    <input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>">
                    <input type="hidden" id="email" name="email" value="">

                    <div class="tool-form-section">
                        <!-- Identity -->
                        <div class="pgk-form-group">
                            <label class="tool-label">Identity <span class="tool-badge-info">Required</span></label>
                            <input type="text" class="tool-input" id="p_identity" name="p_identity" placeholder="john@example.com" style="font-size:0.8125rem;padding:0.4375rem 0.625rem;">
                        </div>

                        <!-- Passphrase -->
                        <div class="pgk-form-group">
                            <label class="tool-label">Passphrase <span class="tool-badge-info">Required</span></label>
                            <div class="pgk-passphrase-row">
                                <input type="password" class="tool-input" id="p_passpharse" name="p_passpharse" placeholder="Min 8 characters">
                                <button type="button" class="pgk-passphrase-btn" id="togglePassphrase" title="Show/hide">&#128065;</button>
                                <button type="button" class="pgk-passphrase-btn" id="generatePassphrase" title="Generate secure passphrase">&#127922;</button>
                            </div>
                            <div class="pgk-strength-bar">
                                <div class="pgk-strength-fill" id="strengthFill"></div>
                            </div>
                            <div class="pgk-strength-text" id="strengthText"></div>
                        </div>

                        <!-- Cipher Algorithm -->
                        <div class="pgk-section-label">&#128274; Cipher</div>
                        <div class="pgk-options-grid">
                            <label class="pgk-option-label selected">
                                <input type="radio" name="cipherparameter" value="AES_256" checked>
                                <span>AES-256</span>
                                <span class="pgk-badge-rec">REC</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="cipherparameter" value="AES_192">
                                <span>AES-192</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="cipherparameter" value="AES_128">
                                <span>AES-128</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="cipherparameter" value="TWOFISH">
                                <span>TWOFISH</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="cipherparameter" value="BLOWFISH">
                                <span>BLOWFISH</span>
                                <span class="pgk-badge-legacy">Legacy</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="cipherparameter" value="CAST5">
                                <span>CAST5</span>
                                <span class="pgk-badge-legacy">Legacy</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="cipherparameter" value="TRIPLE_DES">
                                <span>3DES</span>
                                <span class="pgk-badge-legacy">Legacy</span>
                            </label>
                        </div>

                        <!-- Key Size -->
                        <div class="pgk-section-label">&#128207; RSA Key Size</div>
                        <div class="pgk-options-grid">
                            <label class="pgk-option-label selected">
                                <input type="radio" name="p_keysize" value="2048" checked>
                                <span>2048-bit</span>
                                <span class="pgk-badge-rec">REC</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="p_keysize" value="4096">
                                <span>4096-bit</span>
                            </label>
                            <label class="pgk-option-label">
                                <input type="radio" name="p_keysize" value="1024">
                                <span>1024-bit</span>
                                <span class="pgk-badge-weak">Weak</span>
                            </label>
                        </div>

                        <div class="tool-info-box">&#128161; No data retained. Keys generated with CSRNG.</div>
                    </div>

                    <!-- Sticky Action Buttons -->
                    <div class="pgk-sticky-actions">
                        <button type="button" class="tool-action-btn" id="genkeypair">
                            &#128273; Generate
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-success" id="genkeypairemail">
                            &#128231; Email
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Tab bar -->
            <div class="pgp-output-tabs">
                <button type="button" class="pgp-output-tab active" data-panel="output">Output</button>
                <button type="button" class="pgp-output-tab" data-panel="python">&#9654; Try It Live</button>
            </div>

            <!-- Output Panel -->
            <div class="pgp-panel active" id="pgk-panel-output">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <span>&#128273;</span>
                        <h4>Generated Keys</h4>
                    </div>
                    <div class="tool-result-content" id="output">
                        <div class="tool-empty-state" id="pgkEmptyState">
                            <div class="pgk-keygen-flow">
                                <div style="font-size:0.8125rem;font-weight:600;color:var(--primary);text-transform:uppercase;letter-spacing:0.08em;">RSA Key Generation</div>

                                <div class="pgk-flow-step">
                                    <div class="pgk-flow-num">1</div>
                                    <div class="pgk-flow-text"><strong>Prime Generation</strong> - Two large random primes (p, q)</div>
                                </div>
                                <div class="pgk-flow-step">
                                    <div class="pgk-flow-num">2</div>
                                    <div class="pgk-flow-text"><strong>Modulus</strong> - Compute n = p &times; q</div>
                                </div>
                                <div class="pgk-flow-step">
                                    <div class="pgk-flow-num">3</div>
                                    <div class="pgk-flow-text"><strong>Key Pair</strong> - Public (e, n) + Private (d, n)</div>
                                </div>
                                <div class="pgk-flow-step">
                                    <div class="pgk-flow-num">4</div>
                                    <div class="pgk-flow-text"><strong>OpenPGP Wrap</strong> - RFC 4880 armored format</div>
                                </div>
                                <div class="pgk-flow-step">
                                    <div class="pgk-flow-num">5</div>
                                    <div class="pgk-flow-text"><strong>Passphrase Lock</strong> - Private key encrypted with S2K</div>
                                </div>

                                <p class="pgk-flow-caption">Enter identity, passphrase, select options, and click Generate.</p>
                            </div>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn" id="downloadKeys">
                            <span>&#8681;</span> Download Keys
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-success" id="testKeys">
                            <span>&#128274;</span> Test Encrypt/Decrypt
                        </button>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="pgp-panel" id="pgk-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--primary);">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <h4>Python Compiler</h4>
                        <select id="pgkCompilerTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:inherit;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="keygen">Generate PGP Keys</option>
                            <option value="keygen-advanced">Advanced Key Generation</option>
                            <option value="encrypt">PGP Encrypt</option>
                            <option value="decrypt">PGP Decrypt</option>
                            <option value="sign">PGP Sign Message</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="pgkCompilerIframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <!-- In-Content Ad (Mobile Fallback) -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related PGP Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="pgpkeyfunction.jsp"/>
        <jsp:param name="keyword" value="pgp"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- E-E-A-T: Cryptographic Methodology -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Cryptographic Key Generation Methodology</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1.25rem;">This tool generates PGP key pairs using the RSA (Rivest-Shamir-Adleman) public-key cryptosystem following the OpenPGP standard (RFC 4880) with Bouncy Castle cryptographic library.</p>

            <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">RSA Key Generation Steps:</h3>
            <ol style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.5rem;"><strong>Prime Generation:</strong> Two large random primes (p and q) generated using CSRNG</li>
                <li style="margin-bottom: 0.5rem;"><strong>Modulus Calculation:</strong> n = p &times; q (key size determines bit length)</li>
                <li style="margin-bottom: 0.5rem;"><strong>Totient Function:</strong> &phi;(n) = (p-1)(q-1)</li>
                <li style="margin-bottom: 0.5rem;"><strong>Public Exponent:</strong> e = 65537, where gcd(e, &phi;(n)) = 1</li>
                <li style="margin-bottom: 0.5rem;"><strong>Private Exponent:</strong> d &equiv; e&sup1; (mod &phi;(n))</li>
                <li><strong>Key Packaging:</strong> Formatted per OpenPGP standard (RFC 4880) in ASCII-armored output</li>
            </ol>

            <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">Cipher Algorithm Comparison:</h3>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; font-size: 0.875rem; margin-top: 0.5rem;">
                    <thead>
                        <tr style="background: var(--bg-secondary); border-bottom: 2px solid var(--border);">
                            <th style="padding: 0.625rem 0.75rem; text-align: left; font-weight: 600; color: var(--text-primary);">Algorithm</th>
                            <th style="padding: 0.625rem 0.75rem; text-align: left; font-weight: 600; color: var(--text-primary);">Block Size</th>
                            <th style="padding: 0.625rem 0.75rem; text-align: left; font-weight: 600; color: var(--text-primary);">Key Size</th>
                            <th style="padding: 0.625rem 0.75rem; text-align: left; font-weight: 600; color: var(--text-primary);">Security</th>
                        </tr>
                    </thead>
                    <tbody style="color: var(--text-secondary);">
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding: 0.5rem 0.75rem;"><strong>AES-256</strong></td><td style="padding: 0.5rem 0.75rem;">128 bits</td><td style="padding: 0.5rem 0.75rem;">256 bits</td><td style="padding: 0.5rem 0.75rem;">Highest (recommended)</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding: 0.5rem 0.75rem;"><strong>AES-192</strong></td><td style="padding: 0.5rem 0.75rem;">128 bits</td><td style="padding: 0.5rem 0.75rem;">192 bits</td><td style="padding: 0.5rem 0.75rem;">High</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding: 0.5rem 0.75rem;"><strong>AES-128</strong></td><td style="padding: 0.5rem 0.75rem;">128 bits</td><td style="padding: 0.5rem 0.75rem;">128 bits</td><td style="padding: 0.5rem 0.75rem;">High</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding: 0.5rem 0.75rem;"><strong>TWOFISH</strong></td><td style="padding: 0.5rem 0.75rem;">128 bits</td><td style="padding: 0.5rem 0.75rem;">256 bits</td><td style="padding: 0.5rem 0.75rem;">High</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding: 0.5rem 0.75rem;"><strong>BLOWFISH</strong></td><td style="padding: 0.5rem 0.75rem;">64 bits</td><td style="padding: 0.5rem 0.75rem;">32-448 bits</td><td style="padding: 0.5rem 0.75rem;">Medium (legacy)</td></tr>
                        <tr style="border-bottom: 1px solid var(--border);"><td style="padding: 0.5rem 0.75rem;"><strong>CAST5</strong></td><td style="padding: 0.5rem 0.75rem;">64 bits</td><td style="padding: 0.5rem 0.75rem;">128 bits</td><td style="padding: 0.5rem 0.75rem;">Medium</td></tr>
                        <tr><td style="padding: 0.5rem 0.75rem;"><strong>TRIPLE_DES</strong></td><td style="padding: 0.5rem 0.75rem;">64 bits</td><td style="padding: 0.5rem 0.75rem;">168 bits</td><td style="padding: 0.5rem 0.75rem;">Medium (legacy)</td></tr>
                    </tbody>
                </table>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship & Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Security engineer, 15+ years in cryptographic implementations</li>
                        <li><strong>Standards:</strong> RFC 4880, NIST SP 800-57, FIPS 140-2</li>
                        <li><strong>Library:</strong> Bouncy Castle - peer-reviewed Java crypto provider</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Trust & Privacy</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>No Data Retention:</strong> Keys never stored or logged</li>
                        <li><strong>HTTPS Only:</strong> TLS 1.2+ encryption</li>
                        <li><strong>CSRNG:</strong> /dev/urandom with hardware RNG support</li>
                        <li><strong>Compatibility:</strong> GnuPG, OpenKeychain, Mailvelope, Thunderbird</li>
                    </ul>
                </div>
            </div>

            <div class="tool-alert tool-alert-info" style="margin-top: 1.5rem;">
                <strong>Security Disclaimer:</strong> For maximum security with highly sensitive applications, consider using offline tools like GnuPG on air-gapped systems. Never share your private key or forget your passphrase - encrypted data cannot be recovered.
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the difference between RSA key sizes (1024, 2048, 4096)?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">RSA key size determines security strength and computational cost. 1024-bit keys are weak and vulnerable to modern attacks. 2048-bit keys are the current standard, providing strong security with reasonable performance. 4096-bit keys offer maximum security and future-proofing but require more resources. For new keys, use 2048-bit minimum, 4096-bit for long-term sensitive data.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Which cipher algorithm should I choose?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Choose AES-256 for maximum security (256-bit key). AES-192 and AES-128 are also strong. TWOFISH is a good alternative with 256-bit security. BLOWFISH, CAST5, and TRIPLE_DES are legacy - use only for compatibility with older systems.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is it safe to generate PGP keys online?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">This tool has zero data retention - keys are never logged or stored. Generation uses CSRNG over HTTPS. For highly sensitive applications, consider offline tools like GnuPG on air-gapped computers.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What should I do after generating keys?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Save your private key securely (never share it). Share your public key via keyservers (keys.openpgp.org). Test keys using the <a href="pgpencdec.jsp" style="color: var(--primary);">PGP Encrypt/Decrypt tool</a>. Generate and store a revocation certificate. Verify fingerprints when exchanging keys.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Can I use these keys with GPG/GnuPG?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes. Keys follow OpenPGP standard (RFC 4880) and are compatible with GnuPG, PGP Desktop, OpenKeychain, Mailvelope, and Thunderbird/Enigmail. Keys are in ASCII-armored format, universally supported.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I generate PGP keys in Python?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Use the <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">pgpy</code> library. This tool includes a built-in Python compiler with key generation templates. Click <strong>Try It Live</strong> in the output panel to generate PGP keys with Python code directly in your browser.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How strong should my passphrase be?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Use at least 16 characters with mixed case, numbers, and symbols. If you forget your passphrase, encrypted data cannot be recovered - there is no backdoor or reset mechanism. Use the built-in passphrase generator for cryptographically secure random passphrases.</div>
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

    <!-- Email Modal -->
    <div class="pgk-modal-overlay" id="emailModal">
        <div class="pgk-modal">
            <h3>&#128231; Email PGP Key Pair</h3>
            <div class="tool-form-group">
                <label class="tool-label">Email Address</label>
                <input type="email" class="tool-input" id="emailInput" placeholder="Enter your email address">
                <p class="tool-hint" style="margin-top: 0.375rem;">Your PGP keys will be sent to this email address.</p>
            </div>
            <div class="pgk-modal-actions">
                <button type="button" class="pgk-modal-cancel" id="emailModalCancel">Cancel</button>
                <button type="button" class="tool-action-btn" id="sendEmailBtn">&#128228; Send Keys</button>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        var TOOL_NAME = 'PGP Key Generator';

        // ========== RADIO OPTION SELECTION ==========
        $('.pgk-option-label').on('click', function() {
            var name = $(this).find('input[type="radio"]').attr('name');
            $('input[name="' + name + '"]').closest('.pgk-option-label').removeClass('selected');
            $(this).addClass('selected');
        });

        // ========== PASSPHRASE STRENGTH ==========
        $('#p_passpharse').on('input', function() {
            var pass = $(this).val();
            var strength = 0;
            var text = '';
            var cls = '';

            if (pass.length >= 8) strength++;
            if (pass.length >= 12) strength++;
            if (/[a-z]/.test(pass) && /[A-Z]/.test(pass)) strength++;
            if (/\d/.test(pass)) strength++;
            if (/[^a-zA-Z0-9]/.test(pass)) strength++;

            if (pass.length === 0) {
                text = '';
                cls = '';
            } else if (strength <= 2) {
                text = 'Weak';
                cls = 'weak';
            } else if (strength === 3) {
                text = 'Fair';
                cls = 'fair';
            } else if (strength === 4) {
                text = 'Good';
                cls = 'good';
            } else {
                text = 'Strong';
                cls = 'strong';
            }

            $('#strengthFill').attr('class', 'pgk-strength-fill ' + cls);
            $('#strengthText').text(text).css('color',
                cls === 'weak' ? '#ef4444' :
                cls === 'fair' ? '#f59e0b' :
                cls === 'good' ? '#06b6d4' :
                cls === 'strong' ? '#22c55e' : ''
            );
        });

        // ========== TOGGLE PASSPHRASE VISIBILITY ==========
        $('#togglePassphrase').on('click', function() {
            var input = $('#p_passpharse');
            if (input.attr('type') === 'password') {
                input.attr('type', 'text');
                $(this).html('&#128064;');
            } else {
                input.attr('type', 'password');
                $(this).html('&#128065;');
            }
        });

        // ========== GENERATE SECURE PASSPHRASE ==========
        $('#generatePassphrase').on('click', function() {
            var length = 20;
            var charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?';
            var passphrase = '';
            var values = new Uint32Array(length);
            window.crypto.getRandomValues(values);

            for (var i = 0; i < length; i++) {
                passphrase += charset[values[i] % charset.length];
            }

            // Ensure minimum requirements
            if (!/[a-z]/.test(passphrase) || !/[A-Z]/.test(passphrase) || !/[0-9]/.test(passphrase) || !/[^a-zA-Z0-9]/.test(passphrase)) {
                $('#generatePassphrase').click();
                return;
            }

            $('#p_passpharse').val(passphrase).attr('type', 'text').trigger('input');
            $('#togglePassphrase').html('&#128064;');

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('Secure passphrase generated!', 2000, 'success');
            }
        });

        // ========== FORM VALIDATION ==========
        function validateForm() {
            var errors = [];
            var identity = $('#p_identity').val().trim();
            var passphrase = $('#p_passpharse').val().trim();

            $('input').removeClass('invalid field-invalid');

            if (!identity) {
                errors.push('Identity is required (e.g., your name or email)');
                $('#p_identity').addClass('invalid field-invalid');
            }
            if (!passphrase) {
                errors.push('Passphrase is required');
                $('#p_passpharse').addClass('invalid field-invalid');
            } else if (passphrase.length < 8) {
                errors.push('Passphrase must be at least 8 characters');
                $('#p_passpharse').addClass('invalid field-invalid');
            }

            if (errors.length > 0) {
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showError('Validation Failed', '#output', errors);
                }
                var firstInvalid = $('.invalid, .field-invalid').first();
                if (firstInvalid.length > 0) {
                    firstInvalid[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
                    setTimeout(function() { firstInvalid.focus(); }, 300);
                }
                return false;
            }
            return true;
        }

        // Remove invalid class on input
        $('input').on('input', function() {
            $(this).removeClass('invalid field-invalid');
        });

        // ========== GENERATE KEY PAIR ==========
        $('#genkeypair').on('click', function() {
            if (!validateForm()) return;
            $('#email').val('');
            submitKeyGen();
        });

        // ========== EMAIL KEY PAIR ==========
        $('#genkeypairemail').on('click', function() {
            if (!validateForm()) return;
            $('#emailModal').addClass('active');
        });

        $('#emailModalCancel').on('click', function() {
            $('#emailModal').removeClass('active');
        });

        $('#emailModal').on('click', function(e) {
            if (e.target === this) $(this).removeClass('active');
        });

        $('#sendEmailBtn').on('click', function() {
            var email = $('#emailInput').val().trim();
            var validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

            if (email.match(validRegex)) {
                $('#emailModal').removeClass('active');
                $('#email').val(email);
                submitKeyGen();
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showToast('Keys will be delivered to ' + email, 3000, 'info');
                }
                $('#emailInput').val('');
            } else {
                $('#emailInput').addClass('invalid field-invalid');
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showToast('Invalid email address', 3000, 'error');
                }
            }
        });

        // ========== SUBMIT KEY GENERATION ==========
        function submitKeyGen() {
            var identity = $('#p_identity').val();
            var cipher = $('input[name="cipherparameter"]:checked').val();
            var keysize = $('input[name="p_keysize"]:checked').val();

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showLoading('Generating ' + keysize + '-bit RSA keys with ' + cipher + '...', '#output');
            } else {
                $('#output').html('<div style="text-align:center;padding:2rem;"><p>Generating keys... This may take a moment.</p></div>');
            }

            $('#resultActions').removeClass('visible');

            $.ajax({
                type: "POST",
                url: "PGPFunctionality",
                data: $("#pgkForm").serialize(),
                success: function(msg) {
                    // Modernize server response
                    var modernMsg = msg;
                    modernMsg = modernMsg.replace(/<font[^>]*color\s*=\s*["']green["'][^>]*>/gi, '<div class="tool-alert tool-alert-success">');
                    modernMsg = modernMsg.replace(/<font[^>]*color\s*=\s*["']red["'][^>]*>/gi, '<div class="tool-alert tool-alert-error">');

                    var fontCount = (modernMsg.match(/<div class="tool-alert/g) || []).length;
                    for (var i = 0; i < fontCount; i++) {
                        modernMsg = modernMsg.replace('</font>', '</div>');
                    }

                    var hasError = modernMsg.indexOf('tool-alert-error') !== -1 || modernMsg.indexOf('color="red"') !== -1 || modernMsg.indexOf('System Error') !== -1;

                    $('#output').empty().append(modernMsg);

                    // Add copy & download buttons to textareas
                    $('#output textarea').each(function(index) {
                        var textarea = $(this);
                        var textareaId = 'pgk_textarea_' + index;
                        textarea.attr('id', textareaId);

                        var actions = $('<div class="pgk-key-card-actions" style="margin-top: 0.5rem; margin-bottom: 1rem;"></div>');
                        var copyBtn = $('<button type="button" class="pgk-key-action-btn pgk-copy-btn" data-target="' + textareaId + '">&#128203; Copy</button>');
                        var downloadBtn = $('<button type="button" class="pgk-key-action-btn pgk-download-btn" data-target="' + textareaId + '">&#8681; Download</button>');
                        actions.append(copyBtn).append(downloadBtn);
                        textarea.after(actions);
                    });

                    if (!hasError) {
                        $('#resultActions').addClass('visible');
                        if (typeof ToolUtils !== 'undefined') {
                            ToolUtils.showToast('PGP key pair generated! Identity: ' + identity, 3000, 'success');
                        }
                    }
                },
                error: function(xhr, status, error) {
                    if (typeof ToolUtils !== 'undefined') {
                        ToolUtils.showError(error || 'Failed to generate keys', '#output', [
                            'Check your internet connection',
                            'Try again in a few moments'
                        ]);
                    } else {
                        $('#output').html('<div class="tool-alert tool-alert-error">Error generating keys. Please try again.</div>');
                    }
                    $('#resultActions').removeClass('visible');
                }
            });
        }

        // ========== COPY HANDLER (delegated) ==========
        $(document).on('click', '.pgk-copy-btn', function() {
            var targetId = $(this).data('target');
            var text = $('#' + targetId).val();
            if (text && typeof ToolUtils !== 'undefined') {
                ToolUtils.copyToClipboard(text, {
                    showToast: true,
                    toastMessage: 'Key copied to clipboard!',
                    showSupportPopup: true,
                    toolName: TOOL_NAME
                });
            } else if (text) {
                var ta = document.getElementById(targetId);
                ta.select();
                document.execCommand('copy');
            }
        });

        // ========== DOWNLOAD HANDLER (delegated) ==========
        $(document).on('click', '.pgk-download-btn', function() {
            var targetId = $(this).data('target');
            var content = $('#' + targetId).val();
            var isPrivate = content && content.indexOf('PRIVATE') !== -1;
            var filename = isPrivate ? 'pgp_private_key.asc' : 'pgp_public_key.asc';

            if (content && typeof ToolUtils !== 'undefined') {
                ToolUtils.downloadAsFile(content, filename, {
                    showToast: true,
                    toastMessage: filename + ' downloaded!',
                    showSupportPopup: true,
                    toolName: TOOL_NAME
                });
            } else if (content) {
                var blob = new Blob([content], { type: 'text/plain' });
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = url;
                a.download = filename;
                a.click();
                window.URL.revokeObjectURL(url);
            }
        });

        // ========== DOWNLOAD ALL KEYS ==========
        $('#downloadKeys').on('click', function() {
            $('#output .pgk-download-btn').each(function() {
                $(this).click();
            });
        });

        // ========== TEST ENCRYPT/DECRYPT ==========
        $('#testKeys').on('click', function() {
            window.open('<%=request.getContextPath()%>/pgpencdec.jsp', '_blank');
        });

        // ========== OUTPUT TABS ==========
        var pgkCompilerLoaded = false;

        $('.pgp-output-tab').on('click', function() {
            var panel = $(this).data('panel');
            $('.pgp-output-tab').removeClass('active');
            $(this).addClass('active');
            $('.pgp-panel').removeClass('active');
            $('#pgk-panel-' + panel).addClass('active');

            if (panel === 'python' && !pgkCompilerLoaded) {
                loadPgkCompiler();
                pgkCompilerLoaded = true;
            }
        });

        // ========== PYTHON COMPILER ==========
        function buildPgkCompilerCode(template) {
            switch (template) {
                case 'keygen':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate RSA 2048-bit PGP key pair\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n\n' +
                        '# Add user ID with capabilities\nuid = pgpy.PGPUID.new("Alice", email="alice@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.Sign, KeyFlags.EncryptCommunications, KeyFlags.EncryptStorage},\n' +
                        '    hashes=[HashAlgorithm.SHA256],\n' +
                        '    ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        'print("=== PUBLIC KEY ===")\nprint(str(key.pubkey)[:300] + "...")\n' +
                        'print("\\n=== KEY INFO ===")\nprint("Fingerprint:", key.fingerprint)\n' +
                        'print("Algorithm:", key.key_algorithm.name)\nprint("Key size:", key.key_size, "bits")';

                case 'keygen-advanced':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Advanced: Generate key with multiple UIDs and capabilities\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n\n' +
                        '# Primary UID\nuid1 = pgpy.PGPUID.new("Alice Smith", comment="Primary", email="alice@example.com")\n' +
                        'key.add_uid(uid1, usage={KeyFlags.Sign, KeyFlags.EncryptCommunications, KeyFlags.EncryptStorage, KeyFlags.Authentication},\n' +
                        '    hashes=[HashAlgorithm.SHA256, HashAlgorithm.SHA512],\n' +
                        '    ciphers=[SymmetricKeyAlgorithm.AES256, SymmetricKeyAlgorithm.AES128],\n' +
                        '    compression=[CompressionAlgorithm.ZIP, CompressionAlgorithm.ZLIB])\n\n' +
                        '# Protect with passphrase\nkey.protect("my-secure-passphrase", SymmetricKeyAlgorithm.AES256, HashAlgorithm.SHA256)\n\n' +
                        'print("=== KEY DETAILS ===")\nprint("Fingerprint:", key.fingerprint)\nprint("Algorithm:", key.key_algorithm.name)\n' +
                        'print("Key size:", key.key_size, "bits")\nprint("Protected:", key.is_protected)\n' +
                        'print("\\n=== PUBLIC KEY (first 400 chars) ===")\nprint(str(key.pubkey)[:400])';

                case 'encrypt':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate key pair for demo\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n' +
                        'uid = pgpy.PGPUID.new("Test User", email="test@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.EncryptCommunications, KeyFlags.EncryptStorage},\n' +
                        '    hashes=[HashAlgorithm.SHA256], ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        '# Encrypt a message\nmessage = pgpy.PGPMessage.new("Hello, this is a secret PGP message!")\n' +
                        'encrypted = key.pubkey.encrypt(message)\nprint("=== Encrypted ===")\nprint(str(encrypted)[:200] + "...")\n' +
                        'print("\\n=== Decrypting... ===")\ndecrypted = key.decrypt(encrypted)\nprint("Decrypted:", decrypted.message)';

                case 'decrypt':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate key pair\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n' +
                        'uid = pgpy.PGPUID.new("Demo User", email="demo@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.EncryptCommunications},\n' +
                        '    hashes=[HashAlgorithm.SHA256], ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        '# Encrypt then decrypt\noriginal = "Top secret message for decryption demo"\n' +
                        'msg = pgpy.PGPMessage.new(original)\nenc = key.pubkey.encrypt(msg)\n' +
                        'print("Encrypted length:", len(str(enc)), "chars")\n\n' +
                        'dec = key.decrypt(enc)\nprint("Decrypted:", dec.message)\nprint("Match:", dec.message == original)';

                case 'sign':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate signing key\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n' +
                        'uid = pgpy.PGPUID.new("Signer", email="signer@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.Sign},\n' +
                        '    hashes=[HashAlgorithm.SHA256], ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        '# Sign a message\nmessage = pgpy.PGPMessage.new("This message is signed with PGP")\n' +
                        'signature = key.sign(message)\nprint("=== PGP Signature ===")\nprint(str(signature)[:200] + "...")\n' +
                        'print("\\nSignature type:", signature.type)\nprint("Hash algorithm:", signature.hash_algorithm.name)';

                default: return '';
            }
        }

        function loadPgkCompiler() {
            var template = $('#pgkCompilerTemplate').val();
            var code = buildPgkCompilerCode(template);
            var b64Code = btoa(unescape(encodeURIComponent(code)));
            var config = JSON.stringify({lang: 'python', code: b64Code});
            $('#pgkCompilerIframe').attr('src', '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config));
        }

        $('#pgkCompilerTemplate').on('change', function() {
            pgkCompilerLoaded = false;
            loadPgkCompiler();
            pgkCompilerLoaded = true;
        });
    });

    // ========== FAQ Toggle ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };
    </script>

    <!-- All JSON-LD schemas generated by seo-tool-page.jsp -->
</body>
</html>
