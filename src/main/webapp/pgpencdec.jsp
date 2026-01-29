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
        <jsp:param name="toolName" value="PGP Encryption Decryption Online - Free | 8gwifi.org" />
        <jsp:param name="toolDescription" value="Free PGP encryption & decryption tool implementing OpenPGP (RFC 4880). Secure RSA public-key cryptography with AES-256. No data retention. Share encrypted messages via URL or email." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="pgpencdec.jsp" />
        <jsp:param name="toolKeywords" value="pgp encryption, pgp decryption, online pgp tool, free pgp encryption, openpgp, rfc 4880, rsa encryption, public key encryption, private key decryption, end-to-end encryption, pgp message format, pgp key generator, aes-256 encryption, secure messaging, email encryption" />
        <jsp:param name="toolImage" value="pgp.png" />
        <jsp:param name="toolFeatures" value="PGP encryption using OpenPGP standard (RFC 4880),RSA public-key cryptography (2048-4096 bit),AES-256 symmetric encryption,Secure message encryption and decryption,Private key passphrase protection,Share encrypted messages via URL,Send encrypted messages via email,No data retention - all processing in-memory,HTTPS/TLS encryption for data transmission" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is PGP encryption and how does it work?" />
        <jsp:param name="faq1a" value="PGP (Pretty Good Privacy) uses RSA asymmetric encryption with public keys for encryption and private keys for decryption. Messages are encrypted with AES-256 for the body and RSA for the session key." />
        <jsp:param name="faq2q" value="Is this PGP tool secure? Do you store my keys?" />
        <jsp:param name="faq2a" value="Yes, we implement OpenPGP (RFC 4880) with Bouncy Castle. No keys or messages are stored - all processing is in-memory only with HTTPS encryption." />
        <jsp:param name="faq3q" value="How do I encrypt a message with PGP?" />
        <jsp:param name="faq3a" value="Select Encrypt mode, enter your message, paste the recipient's public key (with BEGIN/END markers), and click Encrypt. Share the result via URL or email." />
    </jsp:include>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/pgpencdec.jsp">
    <meta property="og:title" content="PGP Encryption Decryption Online - Free | 8gwifi.org">
    <meta property="og:description" content="Free PGP encryption & decryption tool implementing OpenPGP (RFC 4880). Secure RSA public-key cryptography with AES-256. No data retention.">
    <meta property="og:image" content="https://8gwifi.org/images/site/pgp.png">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:locale" content="en_US">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/pgpencdec.jsp">
    <meta name="twitter:title" content="PGP Encryption Decryption Online - Free | 8gwifi.org">
    <meta name="twitter:description" content="Free PGP encryption & decryption tool implementing OpenPGP (RFC 4880). Secure RSA public-key cryptography with AES-256. No data retention.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/pgp.png">
    <meta name="twitter:creator" content="@anish2good">
    <meta name="twitter:site" content="@8gwifi">

    <link rel="canonical" href="https://8gwifi.org/pgpencdec.jsp">

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PGP Encryption Decryption Online - Free",
  "description" : "Free online PGP encryption and decryption tool implementing OpenPGP standard (RFC 4880) with RSA public-key cryptography and AES-256 encryption. No data retention, secure message encryption.",
  "url" : "https://8gwifi.org/pgpencdec.jsp",
  "image" : "https://8gwifi.org/images/site/pgp.png",
  "screenshot" : "https://8gwifi.org/images/site/pgp.png",
  "applicationCategory" : ["SecurityApplication", "CryptographyApplication", "UtilitiesApplication"],
  "applicationSubCategory" : "Encryption Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer",
    "description" : "Security engineer specializing in cryptographic implementations and secure coding practices"
  },
  "datePublished" : "2018-10-23",
  "dateModified" : "2025-11-20",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "PGP encryption using OpenPGP standard (RFC 4880)",
    "RSA public-key cryptography (2048-4096 bit)",
    "AES-256 symmetric encryption",
    "Secure message encryption and decryption",
    "Private key passphrase protection",
    "Share encrypted messages via URL",
    "Send encrypted messages via email",
    "No data retention - all processing in-memory",
    "HTTPS/TLS encryption for data transmission"
  ]
}
    </script>

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
                <span class="tool-badge">No Data Stored</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Secure your messages with military-grade PGP encryption. Encrypt using recipient's public key, decrypt with your private key and passphrase. Share encrypted messages via URL or email. All processing is server-side with no data retention.</p>
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
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <span>&#128203;</span>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="output">
                    <div class="tool-empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                        <h3>Ready to encrypt or decrypt</h3>
                        <p>Select a mode and fill in the form. Your result will appear here.</p>
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
            $('#output').html(
                '<div class="tool-empty-state">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">' +
                '<rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>' +
                '<path d="M7 11V7a5 5 0 0 1 10 0v4"/>' +
                '</svg>' +
                '<h3>Ready to encrypt or decrypt</h3>' +
                '<p>Select a mode and fill in the form. Your result will appear here.</p>' +
                '</div>'
            );
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
    });
    </script>

    <!-- E-E-A-T JSON-LD Schemas -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "PGP Encryption Decryption Online - Free | 8gwifi.org",
  "url": "https://8gwifi.org/pgpencdec.jsp",
  "description": "Free online PGP encryption and decryption tool implementing OpenPGP standard (RFC 4880). Secure message encryption using RSA public-key cryptography.",
  "datePublished": "2018-10-23",
  "dateModified": "2025-11-20",
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://x.com/anish2good",
    "jobTitle": "Security Engineer"
  },
  "reviewedBy": {
    "@type": "Organization",
    "name": "8gwifi.org Security Team"
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
    {"@type": "ListItem", "position": 2, "name": "Cryptography Tools", "item": "https://8gwifi.org/index.jsp#cryptography"},
    {"@type": "ListItem", "position": 3, "name": "PGP Encryption/Decryption", "item": "https://8gwifi.org/pgpencdec.jsp"}
  ]
}
    </script>

    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Encrypt Messages with PGP",
  "description": "Step-by-step guide to encrypt messages using PGP public key encryption",
  "step": [
    {"@type": "HowToStep", "position": 1, "name": "Select Encrypt Mode", "text": "Choose 'Encrypt' mode in the operation selector"},
    {"@type": "HowToStep", "position": 2, "name": "Enter Message", "text": "Type or paste the message you want to encrypt"},
    {"@type": "HowToStep", "position": 3, "name": "Add Public Key", "text": "Paste the recipient's PGP public key (BEGIN PGP PUBLIC KEY BLOCK)"},
    {"@type": "HowToStep", "position": 4, "name": "Encrypt", "text": "Click 'Encrypt Message' button to generate encrypted PGP message"},
    {"@type": "HowToStep", "position": 5, "name": "Share", "text": "Copy the encrypted message or use 'Share URL' to send to recipient"}
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
      "name": "What is PGP encryption and how does it work?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "PGP (Pretty Good Privacy) is a public-key cryptography system that uses RSA asymmetric encryption. It works by generating a keypair (public key for encryption, private key for decryption), encrypting messages with the recipient's public key, and the recipient decrypts with their private key protected by a passphrase."
      }
    },
    {
      "@type": "Question",
      "name": "Is this PGP tool secure? Do you store my keys or messages?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, this tool is secure. We implement OpenPGP standard (RFC 4880) using Bouncy Castle cryptography library. All encryption/decryption happens server-side in-memory only. We do NOT store, log, or retain any keys, passphrases, or messages."
      }
    },
    {
      "@type": "Question",
      "name": "How do I encrypt a message with PGP?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To encrypt: Select 'Encrypt' mode, enter your message, paste the recipient's PGP public key (must include BEGIN/END markers), click 'Encrypt Message'. Share the encrypted message via the 'Share URL' feature or copy it directly."
      }
    },
    {
      "@type": "Question",
      "name": "How do I decrypt a PGP encrypted message?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To decrypt: Select 'Decrypt' mode, paste the PGP encrypted message, paste your PGP private key, enter your passphrase, click 'Decrypt'. The tool will display the original plaintext if the private key matches."
      }
    },
    {
      "@type": "Question",
      "name": "Can I share encrypted messages via URL?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! After encrypting a message, click the 'Share URL' button. This generates a shareable link with the encrypted message encoded in the URL parameter. Recipients can click the link to automatically load and decrypt with their private key."
      }
    }
  ]
}
    </script>
</body>
</html>
