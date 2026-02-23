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
        <jsp:param name="toolName" value="Free Online PGP Encrypt & Decrypt Tool - Run Python Code | 8gwifi.org" />
        <jsp:param name="toolDescription" value="Free online PGP encryption and decryption tool with built-in Python compiler. Encrypt messages with public keys, decrypt with private keys, and run PGP Python code in your browser. No data stored. No software to install." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="pgpencdec.jsp" />
        <jsp:param name="toolKeywords" value="pgp encryption online, pgp decryption online, online pgp tool, free pgp encryption tool, pgp encrypt decrypt, openpgp, rfc 4880, pgp public key encryption, pgp private key decryption, pgp python tutorial, pgp encryption python code, pgp key generator online, aes-256 encryption, browser-based pgp, client-side pgp, pgp message encrypt, email encryption pgp, pgp tool free, pgp python compiler" />
        <jsp:param name="toolImage" value="pgp.png" />
        <jsp:param name="toolFeatures" value="PGP encryption using OpenPGP standard (RFC 4880),RSA public-key cryptography (2048-4096 bit),AES-256 symmetric encryption,Built-in Python compiler for PGP code,Run PGP Python scripts in browser,Secure message encryption and decryption,Private key passphrase protection,Share encrypted messages via URL,Send encrypted messages via email,No data retention - all processing in-memory,No software to install - browser-based tool,HTTPS/TLS encryption for data transmission" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is PGP encryption and how does it work?" />
        <jsp:param name="faq1a" value="PGP (Pretty Good Privacy) uses RSA asymmetric encryption with public keys for encryption and private keys for decryption. Messages are encrypted with AES-256 for the body and RSA for the session key. This tool implements the OpenPGP standard (RFC 4880)." />
        <jsp:param name="faq2q" value="Is this PGP tool secure? Do you store my keys?" />
        <jsp:param name="faq2a" value="Yes, we implement OpenPGP (RFC 4880) with Bouncy Castle. No keys or messages are stored - all processing is in-memory only with HTTPS encryption. No software installation required." />
        <jsp:param name="faq3q" value="How do I encrypt a message with PGP?" />
        <jsp:param name="faq3a" value="Select Encrypt mode, enter your message, paste the recipient PGP public key (with BEGIN/END markers), and click Encrypt. Share the result via URL or email. You can also run PGP encryption code in the built-in Python compiler." />
        <jsp:param name="faq4q" value="Is PGP encryption still secure in 2025?" />
        <jsp:param name="faq4a" value="Yes, PGP with RSA-2048+ and AES-256 remains cryptographically secure. No practical attacks exist against properly implemented PGP. Use key sizes of 2048 bits or higher for long-term security." />
        <jsp:param name="faq5q" value="Is PGP encryption better than AES-256?" />
        <jsp:param name="faq5a" value="PGP and AES-256 serve different purposes. PGP is a hybrid system that uses both RSA (asymmetric) for key exchange and AES-256 (symmetric) for message encryption. AES-256 alone requires sharing a secret key, while PGP solves key distribution using public/private key pairs." />
        <jsp:param name="faq6q" value="How do I encrypt and decrypt with PGP in Python?" />
        <jsp:param name="faq6a" value="Use the pgpy or python-gnupg library. This tool includes a built-in Python compiler with ready-to-run PGP encrypt, decrypt, sign, verify, and key generation templates. Click Try It Live in the output panel to run code instantly." />
        <jsp:param name="faq7q" value="What is PGP encryption used for?" />
        <jsp:param name="faq7a" value="PGP is used for encrypting emails, securing files, digital signatures, verifying message authenticity, and protecting sensitive communications. It is the standard for end-to-end encrypted email and is widely used in journalism, security, and privacy-focused communications." />
        <jsp:param name="faq8q" value="Can I run PGP Python code online without installing anything?" />
        <jsp:param name="faq8a" value="Yes! This tool includes a built-in Python compiler with PGP templates. Click Try It Live to run PGP encryption, decryption, key generation, signing, and verification code directly in your browser with no installation needed." />
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
        /* PGP Tool - Minimal overrides (uses three-column-tool.css base) */

        /* Form sections visibility toggle */
        .tool-form-section { display: none; padding: 1.25rem; }
        .tool-form-section.active { display: block; }

        /* Two-column grid for input fields */
        .tool-input-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        /* Input card styling */
        .tool-input-card {
            background: var(--bg-primary, #ffffff);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.75rem;
            padding: 1.25rem;
        }

        .tool-input-card-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border, #e2e8f0);
        }

        .tool-input-card-header h4 {
            margin: 0;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
        }

        .tool-input-card-icon { font-size: 1.25rem; }

        /* Label and hint (extends base) */
        .tool-label {
            display: block;
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.375rem;
        }

        .tool-hint {
            font-size: 0.75rem;
            color: var(--text-secondary, #64748b);
            margin: 0 0 0.5rem 0;
        }

        .tool-badge-info {
            background: #dbeafe;
            color: #1e40af;
            padding: 0.125rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.6875rem;
            font-weight: 500;
            margin-left: 0.25rem;
        }

        [data-theme="dark"] .tool-badge-info {
            background: rgba(59, 130, 246, 0.2);
            color: #93c5fd;
        }

        /* Form actions */
        .tool-form-actions {
            margin-top: 1rem;
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

        /* Output textarea override */
        #output textarea {
            width: 100%;
            min-height: 250px;
            padding: 0.875rem;
            border: 2px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8rem;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-primary, #0f172a);
            resize: vertical;
        }

        /* Copy button overlay for output */
        .tool-output-wrapper {
            position: relative;
        }

        .tool-copy-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            padding: 0.375rem 0.75rem;
            background: var(--tool-primary);
            color: white;
            border: none;
            border-radius: 0.375rem;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.2s;
            z-index: 10;
        }

        .tool-copy-btn:hover {
            background: var(--tool-primary-dark);
            transform: translateY(-1px);
        }

        /* Info/hint box */
        .tool-info-box {
            margin-top: 0.75rem;
            padding: 0.5rem 0.75rem;
            background: #fef3c7;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            color: #92400e;
        }

        [data-theme="dark"] .tool-info-box {
            background: rgba(251, 191, 36, 0.15);
            color: #fcd34d;
        }

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

        /* Result actions row */
        .tool-result-actions {
            display: none;
            gap: 0.5rem;
            padding: 1rem 1.25rem;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0 0 0.75rem 0.75rem;
            flex-wrap: wrap;
        }

        .tool-result-actions.visible {
            display: flex;
        }

        .tool-result-actions .tool-action-btn {
            flex: 1;
            min-width: 100px;
            margin-top: 0;
        }

        /* Action button variants */
        .tool-action-btn-secondary {
            background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);
        }

        .tool-action-btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }

        /* Dark mode alert overrides */
        [data-theme="dark"] .tool-alert-success {
            background: rgba(16, 185, 129, 0.15);
            border-color: rgba(16, 185, 129, 0.3);
            color: #6ee7b7;
        }

        [data-theme="dark"] .tool-alert-error {
            background: rgba(239, 68, 68, 0.15);
            border-color: rgba(239, 68, 68, 0.3);
            color: #fca5a5;
        }

        [data-theme="dark"] .tool-alert-info {
            background: rgba(59, 130, 246, 0.15);
            border-color: rgba(59, 130, 246, 0.3);
            color: #93c5fd;
        }

        /* PGP Flow Animation */
        .pgp-flow{display:flex;flex-direction:column;align-items:center;padding:1.5rem 1rem;gap:1.25rem}
        .pgp-flow-row{display:flex;align-items:center;gap:0;width:100%;max-width:380px}
        .pgp-flow-box{padding:0.5rem 0.75rem;border-radius:0.5rem;font-size:0.7rem;font-weight:600;text-align:center;white-space:nowrap;animation:pgpFlowFadeIn .6s ease both}
        .pgp-flow-plaintext{background:#dbeafe;color:#1e40af;border:1.5px solid #93c5fd;min-width:72px;animation-delay:0s}
        .pgp-flow-ciphertext{background:#fce7f3;color:#9d174d;border:1.5px solid #f9a8d4;min-width:72px;animation-delay:.8s}
        .pgp-flow-engine{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff;border:none;padding:0.625rem 0.875rem;border-radius:0.625rem;box-shadow:0 4px 16px rgba(102,126,234,0.25);animation-delay:.3s;position:relative}
        .pgp-flow-engine-label{font-size:0.625rem;opacity:0.85;margin-top:0.125rem;font-weight:500}
        [data-theme="dark"] .pgp-flow-plaintext{background:rgba(59,130,246,0.15);color:#93c5fd;border-color:rgba(59,130,246,0.3)}
        [data-theme="dark"] .pgp-flow-ciphertext{background:rgba(236,72,153,0.15);color:#f9a8d4;border-color:rgba(236,72,153,0.3)}
        .pgp-flow-arrow{flex:1;min-width:28px;height:2px;position:relative;overflow:visible}
        .pgp-flow-arrow-line{position:absolute;top:0;left:0;right:0;height:2px;background:var(--border);border-radius:1px}
        .pgp-flow-arrow-dot{position:absolute;top:-3px;width:8px;height:8px;border-radius:50%;background:var(--primary);animation:pgpFlowDot 2s ease-in-out infinite}
        .pgp-flow-arrow-head{position:absolute;top:-4px;right:-2px;width:0;height:0;border-left:6px solid var(--border);border-top:5px solid transparent;border-bottom:5px solid transparent}
        @keyframes pgpFlowDot{0%{left:0;opacity:0}10%{opacity:1}90%{opacity:1}100%{left:calc(100% - 8px);opacity:0}}
        @keyframes pgpFlowFadeIn{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:translateY(0)}}
        .pgp-flow-mode{font-size:0.6875rem;font-weight:600;color:var(--primary);text-transform:uppercase;letter-spacing:0.08em;animation:pgpFlowFadeIn .3s ease both}
        .pgp-flow-caption{font-size:0.8125rem;color:var(--text-secondary);text-align:center;animation:pgpFlowFadeIn .6s ease 1s both}
        .pgp-flow-key-icon{position:absolute;top:-18px;right:-6px;font-size:0.75rem;animation:pgpFlowKeyBob 2.5s ease-in-out infinite}
        @keyframes pgpFlowKeyBob{0%,100%{transform:translateY(0)}50%{transform:translateY(-3px)}}
        .pgp-flow-arrow.reverse .pgp-flow-arrow-dot{animation:pgpFlowDotReverse 2s ease-in-out infinite}
        .pgp-flow-arrow.reverse .pgp-flow-arrow-head{left:-2px;right:auto;border-left:none;border-right:6px solid var(--border)}
        @keyframes pgpFlowDotReverse{0%{left:calc(100% - 8px);opacity:0}10%{opacity:1}90%{opacity:1}100%{left:0;opacity:0}}

        /* Output tabs */
        .pgp-output-tabs{display:flex;gap:0;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.75rem}
        .pgp-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;font-family:inherit;text-align:center}
        .pgp-output-tab.active{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff}
        .pgp-output-tab:hover:not(.active){background:var(--border)}
        [data-theme="dark"] .pgp-output-tab{background:rgba(255,255,255,0.05)}
        [data-theme="dark"] .pgp-output-tab.active{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff}
        .pgp-panel{display:none;flex:1;min-height:0}.pgp-panel.active{display:flex;flex-direction:column}
        #pgp-panel-output .tool-result-card{flex:1}
        #pgp-panel-python{min-height:540px}

        /* Auto-resize textareas */
        .tool-textarea.auto-resize {
            min-height: 80px;
            max-height: 400px;
            overflow-y: auto;
            resize: none;
            transition: height 0.1s ease-out;
        }

        /* Smaller initial height for key textareas */
        #p_publicKey, #p_privateKey {
            min-height: 60px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .tool-input-grid {
                grid-template-columns: 1fr;
            }

            .tool-result-actions {
                flex-direction: column;
            }

            .tool-result-actions .tool-action-btn {
                width: 100%;
            }

            .tool-textarea.auto-resize {
                max-height: 300px;
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
                <h1 class="tool-page-title">PGP Encryption & Decryption</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    PGP Tool
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">OpenPGP RFC 4880</span>
                <span class="tool-badge">RSA + AES-256</span>
                <span class="tool-badge">Python Compiler</span>
                <span class="tool-badge">No Data Stored</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online PGP encrypt and decrypt tool with a built-in Python compiler. Encrypt messages with the recipient's public key, decrypt with your private key and passphrase, and run PGP Python code directly in your browser. Share encrypted messages via URL or email. No data stored, no software to install.</p>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <!-- Mode Selection Tabs -->
                <div class="tool-tabs" role="tablist">
                    <button type="button" class="tool-tab active" data-mode="encrypt" role="tab">
                        <span>&#128274;</span> Encrypt Message
                    </button>
                    <button type="button" class="tool-tab" data-mode="decrypt" role="tab">
                        <span>&#128275;</span> Decrypt Message
                    </button>
                </div>

                <form id="pgpForm" method="POST" enctype="application/x-www-form-urlencoded">
                    <input type="hidden" name="methodName" id="methodName" value="PGP_ENCRYPTION_DECRYPTION">
                    <input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>">
                    <input type="hidden" id="email" name="email" value="">
                    <input type="hidden" id="pgp_message" name="pgp_message" value="">
                    <input type="hidden" name="encryptdecrypt" id="encryptdecrypt" value="encrypt">

                    <!-- ========== ENCRYPT SECTION ========== -->
                    <div id="encryptSection" class="tool-form-section active">
                        <div class="tool-input-grid">
                            <!-- Message Column -->
                            <div class="tool-input-card">
                                <div class="tool-input-card-header">
                                    <span class="tool-input-card-icon">&#9999;&#65039;</span>
                                    <h4>Your Message</h4>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-label">Message to Encrypt <span class="tool-badge tool-badge-info">Required</span></label>
                                    <p class="tool-hint">Type or paste your secret message</p>
                                    <textarea class="tool-textarea auto-resize" id="p_cmsg" name="p_cmsg" placeholder="Type your secret message here..."></textarea>
                                    <div class="tool-info-box">&#128161; Only the recipient with the matching private key can decrypt this message</div>
                                </div>
                            </div>

                            <!-- Public Key Column -->
                            <div class="tool-input-card">
                                <div class="tool-input-card-header">
                                    <span class="tool-input-card-icon">&#128273;</span>
                                    <h4>Recipient's Public Key</h4>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-label">PGP Public Key <span class="tool-badge tool-badge-info">Required</span></label>
                                    <p class="tool-hint">Paste recipient's public key block</p>
                                    <textarea class="tool-textarea auto-resize" id="p_publicKey" name="p_publicKey" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----">-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----</textarea>
                                </div>
                                <div class="tool-form-actions">
                                    <button type="button" class="tool-action-btn" id="encryptBtn">
                                        &#9889; Run Encryption
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== DECRYPT SECTION ========== -->
                    <div id="decryptSection" class="tool-form-section">
                        <div class="tool-input-grid">
                            <!-- Encrypted Message Column -->
                            <div class="tool-input-card">
                                <div class="tool-input-card-header">
                                    <span class="tool-input-card-icon">&#128232;</span>
                                    <h4>Encrypted Message</h4>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-label">PGP Encrypted Message <span class="tool-badge tool-badge-info">Required</span></label>
                                    <p class="tool-hint">Paste the PGP message block</p>
                                    <textarea class="tool-textarea auto-resize" id="p_pgpmessage" name="p_pgpmessage" placeholder="-----BEGIN PGP MESSAGE-----
Version: BCPG v1.58

hIwDmCS94uDDx9kBA/9hH8V38pyzUOvcBPa5Rcv38doT3zJ/tvhxI/5h+1tF5sPg
nmeQDs7D829eR9x6nMos395hbJZezx+iGn1tfdhBoy0FpH3KHTNY+0qLNu37qVwU
...
-----END PGP MESSAGE-----"></textarea>
                                    <div class="tool-info-box">&#9888;&#65039; Include the complete message including BEGIN/END markers</div>
                                </div>
                            </div>

                            <!-- Private Key & Passphrase Column -->
                            <div class="tool-input-card">
                                <div class="tool-input-card-header">
                                    <span class="tool-input-card-icon">&#128272;</span>
                                    <h4>Your Credentials</h4>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-label">PGP Private Key <span class="tool-badge tool-badge-info">Required</span></label>
                                    <p class="tool-hint">Your private key to decrypt</p>
                                    <textarea class="tool-textarea auto-resize" id="p_privateKey" name="p_privateKey" placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: BCPG v1.58

lQH+BFojjHkBBACJghEFJ0kOeHnvpp5ADbI8r2ZtkLAtbBiARKZsiW4dsVrpbify
...
-----END PGP PRIVATE KEY BLOCK-----"></textarea>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-label">Passphrase <span class="tool-badge tool-badge-info">Required</span></label>
                                    <p class="tool-hint">Private key passphrase</p>
                                    <input type="password" class="tool-input" id="p_passpharse" name="p_passpharse" placeholder="Enter your passphrase">
                                </div>
                                <div class="tool-form-actions">
                                    <button type="button" class="tool-action-btn" id="decryptBtn">
                                        &#9889; Run Decryption
                                    </button>
                                </div>
                            </div>
                        </div>
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
            <div class="pgp-panel active" id="pgp-panel-output">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <span>&#128203;</span>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="output">
                        <div class="tool-empty-state" id="pgpEmptyState">
                            <div class="pgp-flow" id="pgpFlow">
                                <div class="pgp-flow-mode" id="pgpFlowModeLabel">PGP Encrypt</div>

                                <!-- Row 1: Message -> Compress + AES-256 -> Encrypted Body -->
                                <div style="font-size:0.6rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;align-self:flex-start;margin-left:calc(50% - 190px);animation:pgpFlowFadeIn .4s ease both;">Step 1: Symmetric Encryption</div>
                                <div class="pgp-flow-row">
                                    <div class="pgp-flow-box pgp-flow-plaintext">Message</div>
                                    <div class="pgp-flow-arrow">
                                        <div class="pgp-flow-arrow-line"></div>
                                        <div class="pgp-flow-arrow-dot"></div>
                                        <div class="pgp-flow-arrow-head"></div>
                                    </div>
                                    <div class="pgp-flow-box pgp-flow-engine">
                                        ZIP + AES-256
                                        <div class="pgp-flow-engine-label">Session Key</div>
                                    </div>
                                    <div class="pgp-flow-arrow">
                                        <div class="pgp-flow-arrow-line"></div>
                                        <div class="pgp-flow-arrow-dot" style="animation-delay:1s;"></div>
                                        <div class="pgp-flow-arrow-head"></div>
                                    </div>
                                    <div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Encrypted Body</div>
                                </div>

                                <!-- Row 2: Session Key -> RSA Public Key -> Wrapped Key -->
                                <div style="font-size:0.6rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;align-self:flex-start;margin-left:calc(50% - 190px);animation:pgpFlowFadeIn .4s ease .5s both;">Step 2: Key Wrapping</div>
                                <div class="pgp-flow-row">
                                    <div class="pgp-flow-box pgp-flow-plaintext" style="background:#fef3c7;color:#92400e;border-color:#fcd34d;">Session Key</div>
                                    <div class="pgp-flow-arrow">
                                        <div class="pgp-flow-arrow-line"></div>
                                        <div class="pgp-flow-arrow-dot" style="animation-delay:1.5s;"></div>
                                        <div class="pgp-flow-arrow-head"></div>
                                    </div>
                                    <div class="pgp-flow-box pgp-flow-engine">
                                        <span class="pgp-flow-key-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;vertical-align:middle;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg></span>
                                        RSA Encrypt
                                        <div class="pgp-flow-engine-label" id="pgpFlowKeyLabel">+ Public Key</div>
                                    </div>
                                    <div class="pgp-flow-arrow">
                                        <div class="pgp-flow-arrow-line"></div>
                                        <div class="pgp-flow-arrow-dot" style="animation-delay:2s;"></div>
                                        <div class="pgp-flow-arrow-head"></div>
                                    </div>
                                    <div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Wrapped Key</div>
                                </div>

                                <!-- Row 3: Result -->
                                <div style="display:flex;align-items:center;gap:0.5rem;animation:pgpFlowFadeIn .6s ease 1.2s both;">
                                    <div style="font-size:0.625rem;color:var(--text-secondary);">Encrypted Body + Wrapped Key =</div>
                                    <div class="pgp-flow-box pgp-flow-ciphertext" style="animation-delay:1.4s;font-size:0.65rem;padding:0.375rem 0.625rem;">PGP Message</div>
                                </div>

                                <p class="pgp-flow-caption">Enter a message, paste a public key, and click Encrypt.</p>
                            </div>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn tool-action-btn-secondary" id="shareUrl">
                            <span>&#128279;</span> Share
                        </button>
                        <button type="button" class="tool-action-btn" id="downloadResult">
                            <span>&#8681;</span> Download
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-success" id="sendEmail">
                            <span>&#128231;</span> Email
                        </button>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="pgp-panel" id="pgp-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--primary);">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <h4>Python Compiler</h4>
                        <select id="pgpCompilerTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:inherit;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="encrypt">PGP Encrypt</option>
                            <option value="decrypt">PGP Decrypt</option>
                            <option value="keygen">Generate PGP Keys</option>
                            <option value="sign">PGP Sign Message</option>
                            <option value="verify">PGP Verify Signature</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="pgpCompilerIframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
        <jsp:param name="currentToolUrl" value="pgpencdec.jsp"/>
        <jsp:param name="keyword" value="pgp"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Code Examples Section (SEO: targets "pgp python tutorial", "pgp encryption python code", "pgp java", "pgp openssl") -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">PGP Encryption Code Examples</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1.25rem;">Copy-paste PGP encryption and decryption code in Python, Java, Node.js, Go, or OpenSSL. Or click <strong>Try It Live</strong> above to run PGP code directly in your browser.</p>

            <!-- Language Tabs -->
            <div class="pgp-code-tabs" role="tablist" style="display:flex;gap:0;border-bottom:2px solid #323232;background:#2d2d2d;border-radius:0.5rem 0.5rem 0 0;overflow-x:auto;">
                <button class="pgp-code-tab active" onclick="switchPgpCodeTab('python',this)" role="tab" style="padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:inherit;position:relative;transition:color .15s;">Python</button>
                <button class="pgp-code-tab" onclick="switchPgpCodeTab('java',this)" role="tab" style="padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:inherit;position:relative;transition:color .15s;">Java</button>
                <button class="pgp-code-tab" onclick="switchPgpCodeTab('nodejs',this)" role="tab" style="padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:inherit;position:relative;transition:color .15s;">Node.js</button>
                <button class="pgp-code-tab" onclick="switchPgpCodeTab('go',this)" role="tab" style="padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:inherit;position:relative;transition:color .15s;">Go</button>
                <button class="pgp-code-tab" onclick="switchPgpCodeTab('openssl',this)" role="tab" style="padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:inherit;position:relative;transition:color .15s;">OpenSSL</button>
            </div>

            <!-- Python -->
            <div class="pgp-code-panel active" id="pgpCodePanel-python">
                <div style="background:#1e1e1e;border-radius:0 0 0.5rem 0.5rem;overflow:hidden;">
                    <div style="background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center;">
                        <span>Python: PGP Encrypt &amp; Decrypt</span>
                        <button class="pgp-copy-cmd-btn" data-snippet="python" style="background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;">Copy</button>
                    </div>
                    <div style="padding:0.75rem;color:#4ec9b0;font-family:'JetBrains Mono',monospace;font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px;">import pgpy
from pgpy.constants import PubKeyAlgorithm, KeyFlags
from pgpy.constants import HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm

<code># Generate PGP key pair</code>
key = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)
uid = pgpy.PGPUID.new(<code>"Alice"</code>, email=<code>"alice@example.com"</code>)
key.add_uid(uid, usage={KeyFlags.EncryptCommunications},
    hashes=[HashAlgorithm.SHA256],
    ciphers=[SymmetricKeyAlgorithm.AES256],
    compression=[CompressionAlgorithm.ZIP])

<code># Encrypt</code>
message = pgpy.PGPMessage.new(<code>"Hello, this is a secret message!"</code>)
encrypted = key.pubkey.encrypt(message)
print(<code>"Encrypted:"</code>, str(encrypted)[:80], <code>"..."</code>)

<code># Decrypt</code>
decrypted = key.decrypt(encrypted)
print(<code>"Decrypted:"</code>, decrypted.message)</div>
                </div>
            </div>

            <!-- Java -->
            <div class="pgp-code-panel" id="pgpCodePanel-java" style="display:none;">
                <div style="background:#1e1e1e;border-radius:0 0 0.5rem 0.5rem;overflow:hidden;">
                    <div style="background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center;">
                        <span>Java: PGP Encrypt &amp; Decrypt (Bouncy Castle)</span>
                        <button class="pgp-copy-cmd-btn" data-snippet="java" style="background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;">Copy</button>
                    </div>
                    <div style="padding:0.75rem;color:#4ec9b0;font-family:'JetBrains Mono',monospace;font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px;">import org.bouncycastle.openpgp.*;
import org.bouncycastle.openpgp.operator.jcajce.*;
import java.io.*;
import java.security.SecureRandom;

<code>// Load public key</code>
PGPPublicKey pubKey = readPublicKey(new FileInputStream(<code>"public.asc"</code>));

<code>// Encrypt</code>
JcePGPDataEncryptorBuilder encBuilder =
    new JcePGPDataEncryptorBuilder(PGPEncryptedData.AES_256)
        .setWithIntegrityPacket(true)
        .setSecureRandom(new SecureRandom());
PGPEncryptedDataGenerator encGen = new PGPEncryptedDataGenerator(encBuilder);
encGen.addMethod(new JcePublicKeyKeyEncryptionMethodGenerator(pubKey));

ByteArrayOutputStream encOut = new ByteArrayOutputStream();
OutputStream out = encGen.open(encOut, new byte[4096]);
PGPCompressedDataGenerator compressor =
    new PGPCompressedDataGenerator(PGPCompressedData.ZIP);
PGPUtil.writeFileToLiteralData(compressor.open(out), PGPLiteralData.BINARY,
    new File(<code>"message.txt"</code>));
compressor.close();
out.close();
System.out.println(<code>"Encrypted: "</code> + encOut.size() + <code>" bytes"</code>);</div>
                </div>
            </div>

            <!-- Node.js -->
            <div class="pgp-code-panel" id="pgpCodePanel-nodejs" style="display:none;">
                <div style="background:#1e1e1e;border-radius:0 0 0.5rem 0.5rem;overflow:hidden;">
                    <div style="background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center;">
                        <span>Node.js: PGP Encrypt &amp; Decrypt (OpenPGP.js)</span>
                        <button class="pgp-copy-cmd-btn" data-snippet="nodejs" style="background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;">Copy</button>
                    </div>
                    <div style="padding:0.75rem;color:#4ec9b0;font-family:'JetBrains Mono',monospace;font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px;">const openpgp = require(<code>'openpgp'</code>);

<code>// Generate key pair</code>
const { privateKey, publicKey } = await openpgp.generateKey({
    type: <code>'rsa'</code>,
    rsaBits: 2048,
    userIDs: [{ name: <code>'Alice'</code>, email: <code>'alice@example.com'</code> }],
    passphrase: <code>'super-secret'</code>
});

<code>// Encrypt</code>
const pubKeyObj = await openpgp.readKey({ armoredKey: publicKey });
const encrypted = await openpgp.encrypt({
    message: await openpgp.createMessage({ text: <code>'Hello, PGP!'</code> }),
    encryptionKeys: pubKeyObj
});
console.log(<code>'Encrypted:'</code>, encrypted.substring(0, 80));

<code>// Decrypt</code>
const privKeyObj = await openpgp.decryptKey({
    privateKey: await openpgp.readPrivateKey({ armoredKey: privateKey }),
    passphrase: <code>'super-secret'</code>
});
const { data } = await openpgp.decrypt({
    message: await openpgp.readMessage({ armoredMessage: encrypted }),
    decryptionKeys: privKeyObj
});
console.log(<code>'Decrypted:'</code>, data);</div>
                </div>
            </div>

            <!-- Go -->
            <div class="pgp-code-panel" id="pgpCodePanel-go" style="display:none;">
                <div style="background:#1e1e1e;border-radius:0 0 0.5rem 0.5rem;overflow:hidden;">
                    <div style="background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center;">
                        <span>Go: PGP Encrypt (golang.org/x/crypto/openpgp)</span>
                        <button class="pgp-copy-cmd-btn" data-snippet="go" style="background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;">Copy</button>
                    </div>
                    <div style="padding:0.75rem;color:#4ec9b0;font-family:'JetBrains Mono',monospace;font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px;">package main

import (
    <code>"bytes"</code>
    <code>"fmt"</code>
    <code>"golang.org/x/crypto/openpgp"</code>
    <code>"golang.org/x/crypto/openpgp/armor"</code>
    <code>"io"</code>
)

func main() {
    <code>// Generate new entity (key pair)</code>
    entity, _ := openpgp.NewEntity(<code>"Alice"</code>, <code>""</code>, <code>"alice@example.com"</code>, nil)

    <code>// Encrypt</code>
    var encrypted bytes.Buffer
    armorWriter, _ := armor.Encode(&encrypted, <code>"PGP MESSAGE"</code>, nil)
    plainWriter, _ := openpgp.Encrypt(armorWriter,
        []*openpgp.Entity{entity}, nil, nil, nil)
    fmt.Fprint(plainWriter, <code>"Hello, PGP from Go!"</code>)
    plainWriter.Close()
    armorWriter.Close()
    fmt.Println(<code>"Encrypted:"</code>, encrypted.String()[:80])
}</div>
                </div>
            </div>

            <!-- OpenSSL -->
            <div class="pgp-code-panel" id="pgpCodePanel-openssl" style="display:none;">
                <div style="background:#1e1e1e;border-radius:0 0 0.5rem 0.5rem;overflow:hidden;">
                    <div style="background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center;">
                        <span>GPG CLI: Encrypt &amp; Decrypt</span>
                        <button class="pgp-copy-cmd-btn" data-snippet="openssl" style="background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;">Copy</button>
                    </div>
                    <div style="padding:0.75rem;color:#4ec9b0;font-family:'JetBrains Mono',monospace;font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px;"><code># Generate PGP key pair</code>
gpg --full-generate-key

<code># List keys</code>
gpg --list-keys

<code># Export public key</code>
gpg --armor --export alice@example.com > public.asc

<code># Import recipient's public key</code>
gpg --import recipient-public.asc

<code># Encrypt a message</code>
echo <code>"Hello, PGP!"</code> | gpg --encrypt --armor --recipient alice@example.com

<code># Encrypt a file</code>
gpg --encrypt --armor --recipient alice@example.com message.txt

<code># Decrypt</code>
gpg --decrypt message.txt.asc

<code># Sign and encrypt</code>
gpg --sign --encrypt --armor --recipient alice@example.com message.txt</div>
                </div>
            </div>
        </div>
    </section>

    <!-- E-E-A-T: Experience, Expertise, Authoritativeness, Trustworthiness -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">About This PGP Tool & Cryptographic Methodology</h2>
            <p style="margin-bottom: 1rem; color: var(--text-secondary);">This online PGP encryption and decryption tool implements the OpenPGP standard (RFC 4880) using industry-standard Java cryptography libraries (Bouncy Castle). All cryptographic operations are performed server-side using RSA public-key cryptography with configurable key sizes (1024-4096 bits). Messages are encrypted using a hybrid approach: symmetric encryption (AES/3DES) for the message body and RSA public-key encryption for the session key.</p>

            <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">How PGP Encryption Works:</h3>
            <ol style="margin-left: 1.5rem; color: var(--text-secondary);">
                <li style="margin-bottom: 0.5rem;"><strong>Key Generation:</strong> RSA keypair (public + private) is generated using cryptographically secure random number generation</li>
                <li style="margin-bottom: 0.5rem;"><strong>Encryption:</strong> Message is compressed (ZIP), encrypted with a symmetric key (AES-256), then the symmetric key is encrypted with recipient's RSA public key</li>
                <li style="margin-bottom: 0.5rem;"><strong>Decryption:</strong> Private key decrypts the session key, which then decrypts the message body. Passphrase protects the private key using symmetric encryption</li>
                <li><strong>Security Model:</strong> Even if the encrypted message is intercepted, only the holder of the private key (and passphrase) can decrypt it</li>
            </ol>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship & Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--tool-primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Security engineer specializing in cryptographic implementations</li>
                        <li><strong>Reviewed by:</strong> 8gwifi.org security team</li>
                        <li><strong>First published:</strong> 2018-10-23</li>
                        <li><strong>Last updated:</strong> 2025-11-20</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Trust & Privacy Guarantees</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>No Data Retention:</strong> Messages and keys processed in-memory only</li>
                        <li><strong>HTTPS Only:</strong> All data transmission uses TLS 1.2+ encryption</li>
                        <li><strong>Open Standards:</strong> Implements RFC 4880 (OpenPGP)</li>
                        <li><strong>Library:</strong> Bouncy Castle - peer-reviewed Java crypto provider</li>
                        <li><strong>Support:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--tool-primary);">@anish2good</a></li>
                    </ul>
                </div>
            </div>

            <div class="tool-alert tool-alert-info" style="margin-top: 1.5rem;">
                <strong>Security Disclaimer:</strong> While this tool implements industry-standard cryptography, for maximum security when handling highly sensitive data (financial, medical, classified), consider using offline PGP implementations (GPG) on air-gapped systems.
            </div>
        </div>
    </section>

    <!-- FAQ Section (visible on page - matches JSON-LD FAQ schema) -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is PGP encryption and how does it work?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PGP (Pretty Good Privacy) is a public-key cryptography system that uses RSA asymmetric encryption. It works by generating a keypair (public key for encryption, private key for decryption), encrypting messages with the recipient's public key, and the recipient decrypts with their private key protected by a passphrase. This tool implements the OpenPGP standard (RFC 4880).</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is this PGP tool secure? Do you store my keys or messages?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes, this tool is secure. We implement OpenPGP standard (RFC 4880) using Bouncy Castle cryptography library. All encryption/decryption happens in-memory only. We do NOT store, log, or retain any keys, passphrases, or messages. No software installation required.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I encrypt a message with PGP?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">To encrypt: Select 'Encrypt' mode, enter your message, paste the recipient's PGP public key (must include BEGIN/END markers), click 'Encrypt Message'. Share the encrypted message via the 'Share URL' feature or copy it directly. You can also run PGP encryption code in the built-in Python compiler.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is PGP encryption still secure in 2025?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes, PGP with RSA-2048 or higher and AES-256 remains cryptographically secure. No practical attacks exist against properly implemented PGP. For maximum security, use key sizes of 2048 bits or higher and keep your private key and passphrase safe.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is PGP encryption better than AES-256?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PGP and AES-256 serve different purposes. PGP is a hybrid cryptosystem that uses both RSA (asymmetric) for key exchange and AES-256 (symmetric) for message body encryption. AES-256 alone requires both parties to share a secret key beforehand, while PGP solves key distribution using public/private key pairs.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I encrypt and decrypt with PGP in Python?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Use the <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">pgpy</code> or <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">python-gnupg</code> library. This tool includes a built-in Python compiler with ready-to-run templates for PGP encryption, decryption, key generation, signing, and verification. Click <strong>Try It Live</strong> in the output panel to write and execute PGP Python code directly in your browser.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is PGP encryption used for?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PGP is used for encrypting emails, securing files, creating digital signatures, verifying message authenticity, and protecting sensitive communications. It is the standard for end-to-end encrypted email and is widely used in journalism, security research, and privacy-focused communications.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Can I run PGP Python code online without installing anything?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes! This tool includes a built-in Python compiler with PGP templates. Click <strong>Try It Live</strong> to run PGP encryption, decryption, key generation, signing, and verification code directly in your browser. No installation or setup is needed.</div>
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
    $(document).ready(function() {
        const TOOL_NAME = 'PGP Encryption Tool';

        // ========== AUTO-RESIZE TEXTAREAS ==========
        function autoResizeTextarea(el) {
            el.style.height = 'auto';
            const newHeight = Math.min(el.scrollHeight, 400);
            el.style.height = newHeight + 'px';
        }

        // Initialize auto-resize for all textareas (only on user interaction, not on load)
        $('.tool-textarea.auto-resize').each(function() {
            const textarea = this;

            // Resize on input
            $(textarea).on('input', function() {
                autoResizeTextarea(this);
            });

            // Also resize on paste (with slight delay to let content load)
            $(textarea).on('paste', function() {
                const self = this;
                setTimeout(function() {
                    autoResizeTextarea(self);
                }, 10);
            });

            // Resize on focus if content exists (user clicks into field)
            $(textarea).on('focus', function() {
                if (this.value.trim()) {
                    autoResizeTextarea(this);
                }
            });
        });

        // ========== URL PARAMETER HANDLING (using ToolUtils) ==========
        // Check for encrypted message in URL using ToolUtils
        const sharedData = ToolUtils.loadSharedResult('encrypted');
        if (sharedData) {
            switchToMode('decrypt');
            $('#p_pgpmessage').val(sharedData);
            autoResizeTextarea($('#p_pgpmessage')[0]);
            ToolUtils.showToast('Encrypted message loaded from URL!', 3000, 'success');
        } else {
            // Fallback: check for non-encoded parameter
            const urlParams = new URLSearchParams(window.location.search);
            const encryptedMessage = urlParams.get('encrypted');
            if (encryptedMessage) {
                switchToMode('decrypt');
                $('#p_pgpmessage').val(decodeURIComponent(encryptedMessage));
                autoResizeTextarea($('#p_pgpmessage')[0]);
                ToolUtils.showToast('Encrypted message loaded!', 3000, 'success');
            }
        }

        // ========== MODE SWITCHING ==========
        $('.tool-tab').on('click', function() {
            const mode = $(this).data('mode');
            switchToMode(mode);
        });

        function switchToMode(mode) {
            $('.tool-tab').removeClass('active');
            $('.tool-tab[data-mode="' + mode + '"]').addClass('active');
            $('.tool-form-section').removeClass('active');

            if (mode === 'encrypt') {
                $('#encryptSection').addClass('active');
                $('#encryptdecrypt').val('encrypt');
            } else {
                $('#decryptSection').addClass('active');
                $('#encryptdecrypt').val('decrypt');
            }
            resetOutput();
        }

        function resetOutput() {
            const isEncrypt = $('#encryptdecrypt').val() === 'encrypt';
            var html;

            if (isEncrypt) {
                html = '<div class="tool-empty-state" id="pgpEmptyState">' +
                '<div class="pgp-flow" id="pgpFlow">' +
                '<div class="pgp-flow-mode">PGP Encrypt</div>' +

                // Step 1: Symmetric
                '<div style="font-size:0.6rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;align-self:flex-start;margin-left:calc(50% - 190px);animation:pgpFlowFadeIn .4s ease both;">Step 1: Symmetric Encryption</div>' +
                '<div class="pgp-flow-row">' +
                '<div class="pgp-flow-box pgp-flow-plaintext">Message</div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-engine">ZIP + AES-256<div class="pgp-flow-engine-label">Session Key</div></div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot" style="animation-delay:1s;"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Encrypted Body</div>' +
                '</div>' +

                // Step 2: Key wrapping
                '<div style="font-size:0.6rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;align-self:flex-start;margin-left:calc(50% - 190px);animation:pgpFlowFadeIn .4s ease .5s both;">Step 2: Key Wrapping</div>' +
                '<div class="pgp-flow-row">' +
                '<div class="pgp-flow-box pgp-flow-plaintext" style="background:#fef3c7;color:#92400e;border-color:#fcd34d;">Session Key</div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot" style="animation-delay:1.5s;"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-engine"><span class="pgp-flow-key-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;vertical-align:middle;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg></span>RSA Encrypt<div class="pgp-flow-engine-label">+ Public Key</div></div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot" style="animation-delay:2s;"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Wrapped Key</div>' +
                '</div>' +

                // Result
                '<div style="display:flex;align-items:center;gap:0.5rem;animation:pgpFlowFadeIn .6s ease 1.2s both;">' +
                '<div style="font-size:0.625rem;color:var(--text-secondary);">Encrypted Body + Wrapped Key =</div>' +
                '<div class="pgp-flow-box pgp-flow-ciphertext" style="animation-delay:1.4s;font-size:0.65rem;padding:0.375rem 0.625rem;">PGP Message</div>' +
                '</div>' +

                '<p class="pgp-flow-caption">Enter a message, paste a public key, and click Encrypt.</p>' +
                '</div></div>';
            } else {
                html = '<div class="tool-empty-state" id="pgpEmptyState">' +
                '<div class="pgp-flow" id="pgpFlow">' +
                '<div class="pgp-flow-mode">PGP Decrypt</div>' +

                // Step 1: Unwrap session key
                '<div style="font-size:0.6rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;align-self:flex-start;margin-left:calc(50% - 190px);animation:pgpFlowFadeIn .4s ease both;">Step 1: Key Unwrapping</div>' +
                '<div class="pgp-flow-row">' +
                '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Wrapped Key</div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-engine"><span class="pgp-flow-key-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;vertical-align:middle;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg></span>RSA Decrypt<div class="pgp-flow-engine-label">+ Private Key</div></div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot" style="animation-delay:1s;"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-plaintext" style="background:#fef3c7;color:#92400e;border-color:#fcd34d;">Session Key</div>' +
                '</div>' +

                // Step 2: Decrypt body
                '<div style="font-size:0.6rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;align-self:flex-start;margin-left:calc(50% - 190px);animation:pgpFlowFadeIn .4s ease .5s both;">Step 2: Symmetric Decryption</div>' +
                '<div class="pgp-flow-row">' +
                '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Encrypted Body</div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot" style="animation-delay:1.5s;"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-engine">AES-256 + Decompress<div class="pgp-flow-engine-label">Session Key</div></div>' +
                '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot" style="animation-delay:2s;"></div><div class="pgp-flow-arrow-head"></div></div>' +
                '<div class="pgp-flow-box pgp-flow-plaintext">Message</div>' +
                '</div>' +

                '<p class="pgp-flow-caption">Paste a PGP message, your private key, and passphrase, then click Decrypt.</p>' +
                '</div></div>';
            }

            $('#output').html(html);
            $('#resultActions').removeClass('visible');
        }

        // ========== HELPER: Get encrypted result text ==========
        function getResultText() {
            const textarea = $('#output').find('textarea[name="comment"]');
            return textarea.length > 0 ? textarea.val() : null;
        }

        // ========== COPY BUTTON (using ToolUtils) ==========
        window.copyToClipboard = function(elementId) {
            const text = getResultText();
            if (text) {
                ToolUtils.copyToClipboard(text, {
                    showToast: true,
                    toastMessage: 'Encrypted message copied!',
                    showSupportPopup: true,
                    toolName: TOOL_NAME
                });
            }
        };

        // ========== SHARE URL (using ToolUtils) ==========
        $('#shareUrl').on('click', function() {
            const text = getResultText();
            if (!text || text.trim() === '') {
                ToolUtils.showToast('No encrypted message to share', 3000, 'error');
                return;
            }

            // Use ToolUtils shareResult with base64 encoding for safe URL transport
            ToolUtils.shareResult(text, {
                paramName: 'encrypted',
                encode: true,
                copyToClipboard: true,
                showSupportPopup: true,
                toolName: TOOL_NAME
            });
        });

        // ========== DOWNLOAD (using ToolUtils) ==========
        $('#downloadResult').on('click', function() {
            const text = getResultText();
            if (!text || text.trim() === '') {
                ToolUtils.showToast('No encrypted message to download', 3000, 'error');
                return;
            }

            const timestamp = new Date().toISOString().slice(0, 10);
            ToolUtils.downloadAsFile(text, 'pgp-encrypted-' + timestamp + '.txt', {
                showToast: true,
                toastMessage: 'Encrypted message downloaded!',
                showSupportPopup: true,
                toolName: TOOL_NAME
            });
        });

        // ========== SEND EMAIL ==========
        $('#sendEmail').on('click', function() {
            const text = getResultText();
            if (text) {
                $("#pgp_message").val(text);
            }

            if (!text || text.trim() === '') {
                ToolUtils.showToast('Encrypt the message first', 3000, 'warning');
                return;
            }

            const email = prompt("Please enter recipient's email address:");
            if (!email) return;

            const validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
            if (email.match(validRegex)) {
                $("#methodName").val("PGP_SEND_ENCRYPTION_EMAIL");
                $("#email").val(email);
                $('#pgpForm').delay(200).submit();
                $("#methodName").val("PGP_ENCRYPTION_DECRYPTION");
                ToolUtils.showToast('Sending encrypted message...', 2000, 'info');
            } else {
                ToolUtils.showToast('Invalid email address', 3000, 'error');
            }
        });

        // ========== BUTTON HANDLERS ==========
        $('#encryptBtn').on('click', submitForm);
        $('#decryptBtn').on('click', submitForm);

        // Remove invalid class on input
        $('textarea, input[type="password"]').on('input', function() {
            $(this).removeClass('invalid field-invalid');
        });

        // ========== FORM SUBMISSION ==========
        function submitForm() {
            // Clear previous states
            $('textarea, input[type="password"]').removeClass('invalid field-invalid');

            const isEncryptMode = $('#encryptdecrypt').val() === 'encrypt';
            let validationErrors = [];

            // ========== VALIDATION ==========
            if (isEncryptMode) {
                const message = $('#p_cmsg').val().trim();
                const publicKey = $('#p_publicKey').val().trim();

                if (!message) {
                    validationErrors.push('Message to encrypt is required');
                    $('#p_cmsg').addClass('invalid field-invalid');
                }
                if (!publicKey) {
                    validationErrors.push('PGP Public Key is required');
                    $('#p_publicKey').addClass('invalid field-invalid');
                } else if (!publicKey.includes('BEGIN PGP PUBLIC KEY BLOCK') || !publicKey.includes('END PGP PUBLIC KEY BLOCK')) {
                    validationErrors.push('Invalid PGP Public Key format');
                    $('#p_publicKey').addClass('invalid field-invalid');
                }
            } else {
                const pgpMessage = $('#p_pgpmessage').val().trim();
                const privateKey = $('#p_privateKey').val().trim();
                const passphrase = $('#p_passpharse').val().trim();

                if (!pgpMessage) {
                    validationErrors.push('PGP Encrypted Message is required');
                    $('#p_pgpmessage').addClass('invalid field-invalid');
                } else if (!pgpMessage.includes('BEGIN PGP MESSAGE') || !pgpMessage.includes('END PGP MESSAGE')) {
                    validationErrors.push('Invalid PGP Message format');
                    $('#p_pgpmessage').addClass('invalid field-invalid');
                }
                if (!privateKey) {
                    validationErrors.push('PGP Private Key is required');
                    $('#p_privateKey').addClass('invalid field-invalid');
                } else if (!privateKey.includes('BEGIN PGP PRIVATE KEY BLOCK') || !privateKey.includes('END PGP PRIVATE KEY BLOCK')) {
                    validationErrors.push('Invalid PGP Private Key format');
                    $('#p_privateKey').addClass('invalid field-invalid');
                }
                if (!passphrase) {
                    validationErrors.push('Passphrase is required');
                    $('#p_passpharse').addClass('invalid field-invalid');
                }
            }

            // Show validation errors using ToolUtils
            if (validationErrors.length > 0) {
                ToolUtils.showError('Validation Failed', '#output', validationErrors);
                $('#resultActions').removeClass('visible');

                const firstInvalid = $('.invalid, .field-invalid').first();
                if (firstInvalid.length > 0) {
                    firstInvalid[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
                    setTimeout(() => firstInvalid.focus(), 300);
                }
                return false;
            }

            // Show loading using ToolUtils
            const mode = isEncryptMode ? 'Encrypting' : 'Decrypting';
            ToolUtils.showLoading(mode + ' your message...', '#output');

            // ========== AJAX SUBMISSION ==========
            $.ajax({
                type: "POST",
                url: "PGPFunctionality",
                data: $("#pgpForm").serialize(),
                success: function(msg) {
                    // Modernize server's legacy HTML
                    let modernMsg = msg;
                    modernMsg = modernMsg.replace(/<font[^>]*color\s*=\s*["']green["'][^>]*>/gi, '<div class="tool-alert tool-alert-success">');
                    modernMsg = modernMsg.replace(/<font[^>]*color\s*=\s*["']red["'][^>]*>/gi, '<div class="tool-alert tool-alert-error">');

                    let fontCount = (modernMsg.match(/<div class="tool-alert/g) || []).length;
                    for (let i = 0; i < fontCount; i++) {
                        modernMsg = modernMsg.replace('</font>', '</div>');
                    }

                    const hasError = modernMsg.includes('tool-alert-error') || modernMsg.includes('color="red"') || modernMsg.includes('System Error') || modernMsg.includes('INVALID');
                    const hasTextarea = modernMsg.includes('<textarea');
                    const currentIsEncrypt = $('#encryptdecrypt').val() === 'encrypt';

                    $('#output').empty();

                    if (hasTextarea) {
                        const outputWrapper = $('<div class="tool-output-wrapper"></div>');
                        outputWrapper.append(modernMsg);
                        outputWrapper.append('<button class="tool-copy-btn" onclick="copyToClipboard(\'#output\')">&#128203; Copy</button>');
                        $('#output').append(outputWrapper);

                        // Show success toast
                        if (!hasError) {
                            ToolUtils.showToast(currentIsEncrypt ? 'Message encrypted!' : 'Message decrypted!', 2000, 'success');
                        }
                    } else if (hasError) {
                        $('#output').html(modernMsg);
                    } else if (modernMsg.includes('tool-alert-success')) {
                        const wrapper = $('<div style="padding: 1rem; background: var(--bg-primary); border-radius: 0.5rem; border: 2px solid #10b981;"></div>');
                        wrapper.append(modernMsg);
                        $('#output').append(wrapper);
                        ToolUtils.showToast('Decryption successful!', 2000, 'success');
                    } else {
                        $('#output').append(modernMsg);
                    }

                    // Show/hide action buttons
                    if (!hasError && hasTextarea && currentIsEncrypt) {
                        $('#resultActions').addClass('visible');
                    } else {
                        $('#resultActions').removeClass('visible');
                    }
                },
                error: function(xhr, status, error) {
                    ToolUtils.showError(error || 'Failed to process request', '#output', [
                        'Check your internet connection',
                        'Verify your input format',
                        'Try again in a few moments'
                    ]);
                    $('#resultActions').removeClass('visible');
                }
            });
        }

        // Form submit handler
        $('#pgpForm').on('submit', function(event) {
            event.preventDefault();
            submitForm();
        });

        // ========== Output Column Tabs ==========
        var pgpCompilerLoaded = false;

        $('.pgp-output-tab').on('click', function() {
            var panel = $(this).data('panel');
            $('.pgp-output-tab').removeClass('active');
            $(this).addClass('active');
            $('.pgp-panel').removeClass('active');
            $('#pgp-panel-' + panel).addClass('active');

            if (panel === 'python' && !pgpCompilerLoaded) {
                loadPgpCompiler();
                pgpCompilerLoaded = true;
            }
        });

        // ========== Python Compiler Templates ==========
        function buildPgpCompilerCode(template) {
            switch (template) {
                case 'encrypt':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate a PGP key pair for demo\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n' +
                        'uid = pgpy.PGPUID.new("Test User", email="test@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.EncryptCommunications, KeyFlags.EncryptStorage},\n' +
                        '    hashes=[HashAlgorithm.SHA256],\n' +
                        '    ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        '# Encrypt a message\nmessage = pgpy.PGPMessage.new("Hello, this is a secret PGP message!")\n' +
                        'encrypted = key.pubkey.encrypt(message)\n' +
                        'print("=== Encrypted PGP Message ===")\nprint(str(encrypted)[:200] + "...")\n' +
                        'print("\\n=== Decrypting... ===")\n' +
                        'decrypted = key.decrypt(encrypted)\nprint("Decrypted:", decrypted.message)';

                case 'decrypt':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate key pair (in real use, load your existing key)\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n' +
                        'uid = pgpy.PGPUID.new("Demo User", email="demo@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.EncryptCommunications},\n' +
                        '    hashes=[HashAlgorithm.SHA256], ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        '# First encrypt, then decrypt\noriginal = "Top secret message for decryption demo"\n' +
                        'msg = pgpy.PGPMessage.new(original)\nenc = key.pubkey.encrypt(msg)\n' +
                        'print("Encrypted length:", len(str(enc)), "chars")\n\n' +
                        '# Decrypt with private key\ndec = key.decrypt(enc)\nprint("Decrypted:", dec.message)\n' +
                        'print("Match:", dec.message == original)';

                case 'keygen':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate RSA 2048-bit PGP key pair\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n\n' +
                        '# Add user ID with capabilities\nuid = pgpy.PGPUID.new("Alice", comment="PGP Demo", email="alice@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.Sign, KeyFlags.EncryptCommunications, KeyFlags.EncryptStorage},\n' +
                        '    hashes=[HashAlgorithm.SHA256, HashAlgorithm.SHA512],\n' +
                        '    ciphers=[SymmetricKeyAlgorithm.AES256, SymmetricKeyAlgorithm.AES128],\n' +
                        '    compression=[CompressionAlgorithm.ZIP, CompressionAlgorithm.ZLIB])\n\n' +
                        'print("=== PUBLIC KEY ===")\nprint(str(key.pubkey)[:300] + "...")\n' +
                        'print("\\n=== KEY INFO ===")\nprint("Fingerprint:", key.fingerprint)\n' +
                        'print("Algorithm:", key.key_algorithm.name)\nprint("Key size:", key.key_size, "bits")';

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

                case 'verify':
                    return 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags, HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n' +
                        '# Generate key and sign a message\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\n' +
                        'uid = pgpy.PGPUID.new("Verifier", email="verify@example.com")\n' +
                        'key.add_uid(uid, usage={KeyFlags.Sign},\n' +
                        '    hashes=[HashAlgorithm.SHA256], ciphers=[SymmetricKeyAlgorithm.AES256],\n' +
                        '    compression=[CompressionAlgorithm.ZIP])\n\n' +
                        'message = pgpy.PGPMessage.new("Verify this PGP signed message")\nsignature = key.sign(message)\n\n' +
                        '# Verify with public key\nverify_result = key.pubkey.verify(message, signature)\n' +
                        'print("=== Verification Result ===")\n' +
                        'for v in verify_result:\n    print("Valid:", v.valid)\n    print("By:", v.by)\n    print("Signature type:", v.signature.type)';

                default: return '';
            }
        }

        function loadPgpCompiler() {
            var template = $('#pgpCompilerTemplate').val();
            var code = buildPgpCompilerCode(template);
            var b64Code = btoa(unescape(encodeURIComponent(code)));
            var config = JSON.stringify({lang: 'python', code: b64Code});
            $('#pgpCompilerIframe').attr('src', '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config));
        }

        $('#pgpCompilerTemplate').on('change', function() {
            pgpCompilerLoaded = false;
            loadPgpCompiler();
            pgpCompilerLoaded = true;
        });
    });

    // ========== FAQ Toggle ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Code Example Tabs ==========
    window.switchPgpCodeTab = function(lang, btn) {
        document.querySelectorAll('.pgp-code-tab').forEach(function(t) {
            t.classList.remove('active');
            t.style.color = '#9ca3af';
        });
        document.querySelectorAll('.pgp-code-panel').forEach(function(p) {
            p.classList.remove('active');
            p.style.display = 'none';
        });
        btn.classList.add('active');
        btn.style.color = '#4ec9b0';
        var panel = document.getElementById('pgpCodePanel-' + lang);
        if (panel) {
            panel.classList.add('active');
            panel.style.display = 'block';
        }
    };

    // ========== Code Snippet Copy ==========
    var pgpCodeSnippets = {
        python: 'import pgpy\nfrom pgpy.constants import PubKeyAlgorithm, KeyFlags\nfrom pgpy.constants import HashAlgorithm, SymmetricKeyAlgorithm, CompressionAlgorithm\n\n# Generate PGP key pair\nkey = pgpy.PGPKey.new(PubKeyAlgorithm.RSAEncryptOrSign, 2048)\nuid = pgpy.PGPUID.new("Alice", email="alice@example.com")\nkey.add_uid(uid, usage={KeyFlags.EncryptCommunications},\n    hashes=[HashAlgorithm.SHA256],\n    ciphers=[SymmetricKeyAlgorithm.AES256],\n    compression=[CompressionAlgorithm.ZIP])\n\n# Encrypt\nmessage = pgpy.PGPMessage.new("Hello, this is a secret message!")\nencrypted = key.pubkey.encrypt(message)\nprint("Encrypted:", str(encrypted)[:80], "...")\n\n# Decrypt\ndecrypted = key.decrypt(encrypted)\nprint("Decrypted:", decrypted.message)',

        java: 'import org.bouncycastle.openpgp.*;\nimport org.bouncycastle.openpgp.operator.jcajce.*;\nimport java.io.*;\nimport java.security.SecureRandom;\n\n// Load public key\nPGPPublicKey pubKey = readPublicKey(new FileInputStream("public.asc"));\n\n// Encrypt\nJcePGPDataEncryptorBuilder encBuilder =\n    new JcePGPDataEncryptorBuilder(PGPEncryptedData.AES_256)\n        .setWithIntegrityPacket(true)\n        .setSecureRandom(new SecureRandom());\nPGPEncryptedDataGenerator encGen = new PGPEncryptedDataGenerator(encBuilder);\nencGen.addMethod(new JcePublicKeyKeyEncryptionMethodGenerator(pubKey));\n\nByteArrayOutputStream encOut = new ByteArrayOutputStream();\nOutputStream out = encGen.open(encOut, new byte[4096]);\nPGPCompressedDataGenerator compressor =\n    new PGPCompressedDataGenerator(PGPCompressedData.ZIP);\nPGPUtil.writeFileToLiteralData(compressor.open(out), PGPLiteralData.BINARY,\n    new File("message.txt"));\ncompressor.close();\nout.close();\nSystem.out.println("Encrypted: " + encOut.size() + " bytes");',

        nodejs: 'const openpgp = require(\'openpgp\');\n\n// Generate key pair\nconst { privateKey, publicKey } = await openpgp.generateKey({\n    type: \'rsa\',\n    rsaBits: 2048,\n    userIDs: [{ name: \'Alice\', email: \'alice@example.com\' }],\n    passphrase: \'super-secret\'\n});\n\n// Encrypt\nconst pubKeyObj = await openpgp.readKey({ armoredKey: publicKey });\nconst encrypted = await openpgp.encrypt({\n    message: await openpgp.createMessage({ text: \'Hello, PGP!\' }),\n    encryptionKeys: pubKeyObj\n});\nconsole.log(\'Encrypted:\', encrypted.substring(0, 80));\n\n// Decrypt\nconst privKeyObj = await openpgp.decryptKey({\n    privateKey: await openpgp.readPrivateKey({ armoredKey: privateKey }),\n    passphrase: \'super-secret\'\n});\nconst { data } = await openpgp.decrypt({\n    message: await openpgp.readMessage({ armoredMessage: encrypted }),\n    decryptionKeys: privKeyObj\n});\nconsole.log(\'Decrypted:\', data);',

        go: 'package main\n\nimport (\n    "bytes"\n    "fmt"\n    "golang.org/x/crypto/openpgp"\n    "golang.org/x/crypto/openpgp/armor"\n    "io"\n)\n\nfunc main() {\n    // Generate new entity (key pair)\n    entity, _ := openpgp.NewEntity("Alice", "", "alice@example.com", nil)\n\n    // Encrypt\n    var encrypted bytes.Buffer\n    armorWriter, _ := armor.Encode(&encrypted, "PGP MESSAGE", nil)\n    plainWriter, _ := openpgp.Encrypt(armorWriter,\n        []*openpgp.Entity{entity}, nil, nil, nil)\n    fmt.Fprint(plainWriter, "Hello, PGP from Go!")\n    plainWriter.Close()\n    armorWriter.Close()\n    fmt.Println("Encrypted:", encrypted.String()[:80])\n}',

        openssl: '# Generate PGP key pair\ngpg --full-generate-key\n\n# List keys\ngpg --list-keys\n\n# Export public key\ngpg --armor --export alice@example.com > public.asc\n\n# Import recipient\'s public key\ngpg --import recipient-public.asc\n\n# Encrypt a message\necho "Hello, PGP!" | gpg --encrypt --armor --recipient alice@example.com\n\n# Encrypt a file\ngpg --encrypt --armor --recipient alice@example.com message.txt\n\n# Decrypt\ngpg --decrypt message.txt.asc\n\n# Sign and encrypt\ngpg --sign --encrypt --armor --recipient alice@example.com message.txt'
    };

    document.querySelectorAll('.pgp-copy-cmd-btn[data-snippet]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var code = pgpCodeSnippets[this.getAttribute('data-snippet')];
            if (code) {
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.copyToClipboard(code, { showToast: true, toastMessage: 'Code copied!' });
                } else {
                    navigator.clipboard.writeText(code);
                }
            }
        });
    });

    // Set initial active tab style
    document.querySelector('.pgp-code-tab.active').style.color = '#4ec9b0';
    </script>

    <!-- All JSON-LD schemas (WebApplication, BreadcrumbList, HowTo, FAQ) generated by seo-tool-page.jsp -->
</body>
</html>
