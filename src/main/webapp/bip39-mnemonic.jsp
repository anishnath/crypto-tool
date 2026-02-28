<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">


    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="BIP39 Mnemonic Generator & Validator - Seed Phrase Tool" />
        <jsp:param name="toolDescription" value="Generate and validate BIP39 mnemonic seed phrases in 10 languages including English Japanese Korean Chinese Spanish French Italian Portuguese and Czech. Create secure 12-24 word phrases, verify checksums, and derive 512-bit seeds with optional passphrases. Uses Web Crypto API, 100% client-side." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="bip39-mnemonic.jsp" />
        <jsp:param name="toolKeywords" value="BIP39 mnemonic generator, seed phrase generator, mnemonic validator, cryptocurrency seed phrase, bitcoin mnemonic, 12 word seed phrase, 24 word seed phrase, BIP39 passphrase, HD wallet seed, PBKDF2 seed derivation, mnemonic checksum, crypto wallet recovery, BIP39 wordlist, mnemonic entropy, seed phrase tool, Web Crypto API" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Generate 12 15 18 21 or 24 word BIP39 mnemonics,10 language wordlists: English Spanish French Italian Portuguese Czech Japanese Korean Chinese Simplified and Traditional,Validate mnemonic checksums against BIP39 standard,Derive 512-bit seeds with PBKDF2-HMAC-SHA512,Optional passphrase (25th word) support,Web Crypto API for all cryptographic operations,Visual entropy strength meter,Numbered word grid with copy support,Full BIP39 wordlists (2048 words each),100% client-side processing,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="College, Professional" />
        <jsp:param name="teaches" value="BIP39 standard, mnemonic phrases, seed derivation, PBKDF2, cryptocurrency wallets, HD wallets, entropy, checksums" />
        <jsp:param name="howToSteps" value="Select mnemonic length|Choose 12 15 18 21 or 24 words corresponding to 128-256 bits of entropy,Generate mnemonic|Click Generate to create a cryptographically secure random mnemonic using Web Crypto API,Review word grid|Examine the numbered word grid and copy the phrase securely,Validate a mnemonic|Enter an existing mnemonic phrase to verify its checksum and word validity,Add passphrase (optional)|Enter an optional passphrase for additional security as the BIP39 25th word,Derive seed|View the 512-bit seed derived via PBKDF2-HMAC-SHA512 with 2048 iterations" />
        <jsp:param name="faq1q" value="What is BIP39 and how does it work?" />
        <jsp:param name="faq1a" value="BIP39 (Bitcoin Improvement Proposal 39) is a standard for generating mnemonic phrases that represent cryptographic keys. Random entropy (128-256 bits) is generated, a SHA-256 checksum is appended, and the combined bits are split into 11-bit segments mapped to words from a 2048-word list. The mnemonic plus an optional passphrase are then processed through PBKDF2-HMAC-SHA512 with 2048 iterations to derive a 512-bit seed for HD wallet key generation." />
        <jsp:param name="faq2q" value="Is this tool safe to use for real wallets?" />
        <jsp:param name="faq2a" value="This tool runs 100% client-side using the Web Crypto API. No data is sent to any server. However for real cryptocurrency wallets we strongly recommend generating mnemonics offline on an air-gapped computer or using a hardware wallet. Never share your mnemonic phrase with anyone and never store it digitally." />
        <jsp:param name="faq3q" value="What is the difference between 12 and 24 word mnemonics?" />
        <jsp:param name="faq3a" value="A 12-word mnemonic has 128 bits of entropy providing 2 to the power of 128 possible combinations which is approximately 340 undecillion. A 24-word mnemonic has 256 bits of entropy providing 2 to the power of 256 combinations which exceeds the number of atoms in the observable universe. Both are considered secure but 24 words provides a larger security margin." />
        <jsp:param name="faq4q" value="What is the BIP39 passphrase and should I use one?" />
        <jsp:param name="faq4a" value="The BIP39 passphrase also called the 25th word is an optional additional input to the seed derivation. It creates a completely different wallet for each passphrase. This provides plausible deniability and protection against physical theft of your mnemonic. However if you forget the passphrase you lose access to that wallet permanently. Only use a passphrase if you can securely store it separately from your mnemonic." />
        <jsp:param name="faq5q" value="Does this tool use any external libraries?" />
        <jsp:param name="faq5a" value="No. This tool uses only the native Web Crypto API built into all modern browsers. SHA-256 for checksum calculation and PBKDF2-HMAC-SHA512 for seed derivation are performed entirely through the browser standard crypto.subtle interface. No CryptoJS jQuery or other external dependencies are needed." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "mainEntityOfPage": { "@type": "WebPage", "@id": "https://8gwifi.org/bip39-mnemonic.jsp" },
      "headline": "BIP39 Mnemonic Generator - Seed Phrase Tool with Web Crypto API",
      "description": "Generate and validate BIP39 mnemonic seed phrases for cryptocurrency wallets using native Web Crypto API. 100% client-side, zero dependencies.",
      "about": [
        {
          "@type": "Thing",
          "name": "BIP39",
          "description": "Bitcoin Improvement Proposal 39, a standard for generating mnemonic phrases that encode cryptographic entropy for deterministic wallet key generation.",
          "sameAs": "https://en.wikipedia.org/wiki/Cryptocurrency_wallet#Seed_phrases"
        },
        {
          "@type": "Thing",
          "name": "PBKDF2",
          "description": "Password-Based Key Derivation Function 2, used in BIP39 to derive a 512-bit seed from a mnemonic phrase and optional passphrase using HMAC-SHA512 with 2048 iterations.",
          "sameAs": "https://en.wikipedia.org/wiki/PBKDF2"
        }
      ],
      "author": { "@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org" },
      "publisher": { "@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org", "logo": { "@type": "ImageObject", "url": "https://8gwifi.org/images/site/logo.png" } },
      "datePublished": "2025-06-15",
      "dateModified": "2026-02-28",
      "inLanguage": "en-US"
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        :root{
            --bip-tool:#f59e0b;--bip-tool-dark:#d97706;--bip-gradient:linear-gradient(135deg,#f59e0b 0%,#f97316 100%);--bip-light:#fffbeb;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;
            --border:#e2e8f0;--font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --shadow-sm:0 1px 2px rgba(0,0,0,0.05);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1);
            --radius-md:0.5rem;--radius-lg:0.75rem;
            --z-dropdown:1000;--z-fixed:1030;--z-modal:1050;
            --header-height-desktop:72px;--header-height-mobile:64px;
            --success:#16a34a;--error:#dc2626;--warning:#f59e0b
        }
        [data-theme="dark"]{--bip-light:rgba(245,158,11,0.12);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--bip-light);color:var(--bip-tool-dark)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-muted);margin-top:0.25rem}
        .tool-breadcrumbs a{color:var(--text-secondary);text-decoration:none}
        .tool-breadcrumbs a:hover{text-decoration:underline}
        .tool-description-section{border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;display:flex;flex-direction:column}.tool-input-column{order:1}.tool-output-column{order:2;min-height:350px}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--bip-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem}
        .tool-card-body{padding:1rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary);font-size:0.8125rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-input,.tool-form-select{width:100%;padding:0.5rem 0.75rem;font-family:var(--font-sans);font-size:0.8125rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);transition:border-color 0.15s}
        .tool-form-input:focus,.tool-form-select:focus{outline:none;border-color:var(--bip-tool);box-shadow:0 0 0 3px rgba(245,158,11,0.1)}
        textarea.tool-form-input{font-family:var(--font-mono);resize:vertical}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--bip-gradient)!important;color:#fff;transition:opacity .15s;font-family:var(--font-sans)}
        .tool-action-btn:hover{opacity:0.9}
        .tool-action-btn:disabled{opacity:0.5;cursor:not-allowed}
        .tool-action-btn.bip-secondary{background:linear-gradient(135deg,#6366f1 0%,#818cf8 100%)!important}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary);flex:1}
        .tool-result-content{padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted)}
        .tool-empty-state svg{margin-bottom:1rem;opacity:0.4}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary)}

        /* BIP39 Specific */
        .bip-mode-toggle{display:flex;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.625rem}
        .bip-mode-btn{flex:1;padding:0.625rem;font-size:0.8125rem;font-weight:600;border:none;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .bip-mode-btn:not(:last-child){border-right:1.5px solid var(--border)}
        .bip-mode-btn.bip-active{background:var(--bip-gradient);color:#fff}
        .bip-panel{display:none}
        .bip-panel-active{display:block}
        .bip-word-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:0.5rem;margin-bottom:1rem}
        @media(max-width:500px){.bip-word-grid{grid-template-columns:repeat(2,1fr)}}
        .bip-word-cell{display:flex;align-items:center;gap:0.5rem;padding:0.5rem 0.625rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.375rem;font-size:0.8125rem;transition:all 0.15s}
        .bip-word-cell:hover{border-color:var(--bip-tool);background:var(--bip-light)}
        .bip-word-num{font-size:0.6875rem;font-weight:600;color:var(--text-muted);min-width:1.25rem}
        .bip-word-text{font-family:var(--font-mono);font-weight:500;color:var(--text-primary)}
        .bip-strength-bar{height:4px;border-radius:2px;background:var(--bg-tertiary);margin-top:0.5rem;overflow:hidden}
        .bip-strength-fill{height:100%;border-radius:2px;transition:width 0.3s,background 0.3s}
        .bip-strength-label{display:flex;justify-content:space-between;margin-top:0.25rem;font-size:0.6875rem;color:var(--text-muted)}
        .bip-info-grid{display:grid;gap:0.625rem}
        .bip-info-row{display:flex;justify-content:space-between;align-items:flex-start;padding:0.625rem 0;border-bottom:1px solid var(--border)}
        .bip-info-row:last-child{border-bottom:none}
        .bip-info-label{font-size:0.8125rem;font-weight:500;color:var(--text-secondary);flex-shrink:0}
        .bip-info-value{font-family:var(--font-mono);font-size:0.8125rem;color:var(--text-primary);word-break:break-all;text-align:right;max-width:65%}
        .bip-info-value.bip-success{color:var(--success);font-weight:600}
        .bip-info-value.bip-error{color:var(--error);font-weight:600}
        .bip-seed-box{background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:0.75rem;font-family:var(--font-mono);font-size:0.75rem;word-break:break-all;line-height:1.6;color:var(--text-primary)}
        .bip-copy-btn{display:inline-flex;align-items:center;gap:0.375rem;padding:0.375rem 0.75rem;font-size:0.75rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .bip-copy-btn:hover{border-color:var(--bip-tool);color:var(--bip-tool-dark)}
        .bip-copy-btn.copied{border-color:var(--success);color:var(--success)}
        .bip-alert{padding:0.75rem 1rem;border-radius:0.5rem;font-size:0.8125rem;line-height:1.5;margin-bottom:0.75rem}
        .bip-alert-warning{background:#fef3c7;border:1px solid #fde68a;color:#92400e}
        [data-theme="dark"] .bip-alert-warning{background:rgba(245,158,11,0.15);border-color:rgba(245,158,11,0.3);color:#fbbf24}
        .bip-alert-info{background:#eff6ff;border:1px solid #bfdbfe;color:#1e40af}
        [data-theme="dark"] .bip-alert-info{background:rgba(59,130,246,0.12);border-color:rgba(59,130,246,0.3);color:#60a5fa}
        .bip-section-title{font-size:0.875rem;font-weight:600;color:var(--text-primary);margin-bottom:0.75rem;display:flex;align-items:center;gap:0.5rem}
        .bip-result-section{margin-bottom:1.25rem}
        .bip-result-section:last-child{margin-bottom:0}
        .bip-toolbar{display:flex;gap:0.5rem;margin-top:0.5rem}
        .bip-password-wrap{position:relative}
        .bip-password-wrap input{padding-right:2.5rem}
        .bip-password-toggle{position:absolute;right:0.5rem;top:50%;transform:translateY(-50%);border:none;background:none;color:var(--text-muted);cursor:pointer;padding:0.25rem}
        .bip-password-toggle:hover{color:var(--text-primary)}

        /* Toast notification */
        .bip-toast{position:fixed;top:1rem;right:1rem;z-index:9999;padding:0.75rem 1rem;border-radius:0.5rem;font-size:0.8125rem;font-weight:500;color:#fff;transform:translateY(-1rem);opacity:0;transition:all 0.3s;font-family:var(--font-sans)}
        .bip-toast.show{transform:translateY(0);opacity:1}
        .bip-toast.success{background:#16a34a}
        .bip-toast.error{background:#dc2626}

        /* FAQ */
        .faq-container{display:grid;gap:0.5rem}
        .faq-item{border:1px solid var(--border);border-radius:0.5rem;overflow:hidden}
        .faq-question{width:100%;display:flex;align-items:center;justify-content:space-between;padding:0.875rem 1rem;border:none;background:var(--bg-primary);color:var(--text-primary);font-size:0.875rem;font-weight:500;cursor:pointer;text-align:left;font-family:var(--font-sans)}
        [data-theme="dark"] .faq-question{background:var(--bg-secondary)}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0;margin-left:0.5rem}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-answer{display:none;padding:0 1rem 0.875rem;font-size:0.8125rem;line-height:1.6;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
    </style>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">BIP39 Mnemonic Generator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/CipherFunctions.jsp">Cryptography</a> /
                BIP39 Mnemonic
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">BIP39 Standard</span>
            <span class="tool-badge">10 Languages</span>
            <span class="tool-badge">Web Crypto API</span>
            <span class="tool-badge">PBKDF2-SHA512</span>
            <span class="tool-badge">100% Client-Side</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--bip-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Generate and validate <strong>BIP39 mnemonic seed phrases</strong> in <strong>10 languages</strong> for cryptocurrency wallets. Create secure 12-24 word phrases with cryptographic entropy, verify checksums, and derive <strong>512-bit seeds</strong> via PBKDF2-HMAC-SHA512. Supports English, Japanese, Korean, Chinese, Spanish, French, Italian, Portuguese, and Czech wordlists. Uses the native <strong>Web Crypto API</strong> with zero external dependencies, all processing happens client-side.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">

        <!-- Mode Toggle -->
        <div class="bip-mode-toggle">
            <button type="button" class="bip-mode-btn bip-active" id="bip-mode-generate" onclick="switchMode('generate')">Generate</button>
            <button type="button" class="bip-mode-btn" id="bip-mode-validate" onclick="switchMode('validate')">Validate</button>
        </div>

        <!-- ===== Generate Panel ===== -->
        <div class="bip-panel bip-panel-active" id="bip-generate-panel">
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header">Generate Mnemonic</div>
                <div class="tool-card-body">
                    <div class="bip-alert bip-alert-warning">
                        <strong>Security:</strong> For real wallets, generate offline on an air-gapped device. Never share your mnemonic.
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bip-gen-lang">Language</label>
                        <select class="tool-form-select" id="bip-gen-lang" onchange="loadWordlist(this.value)">
                            <option value="english" selected>English</option>
                            <option value="spanish">Spanish (Espa&#241;ol)</option>
                            <option value="french">French (Fran&#231;ais)</option>
                            <option value="italian">Italian (Italiano)</option>
                            <option value="portuguese">Portuguese (Portugu&#234;s)</option>
                            <option value="czech">Czech (&#268;e&#353;tina)</option>
                            <option value="japanese">Japanese (&#26085;&#26412;&#35486;)</option>
                            <option value="korean">Korean (&#54620;&#44397;&#50612;)</option>
                            <option value="chinese_simplified">Chinese Simplified (&#31616;&#20307;&#20013;&#25991;)</option>
                            <option value="chinese_traditional">Chinese Traditional (&#32321;&#39636;&#20013;&#25991;)</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bip-gen-length">Word Count</label>
                        <select class="tool-form-select" id="bip-gen-length">
                            <option value="12">12 words (128-bit entropy)</option>
                            <option value="15">15 words (160-bit)</option>
                            <option value="18">18 words (192-bit)</option>
                            <option value="21">21 words (224-bit)</option>
                            <option value="24" selected>24 words (256-bit)</option>
                        </select>
                    </div>
                    <div class="bip-strength-bar"><div class="bip-strength-fill" id="bip-strength-fill" style="width:100%;background:#16a34a;"></div></div>
                    <div class="bip-strength-label"><span id="bip-strength-text">256-bit entropy</span><span id="bip-strength-level">Maximum</span></div>
                </div>
            </div>
            <button type="button" class="tool-action-btn" onclick="generateMnemonic()">Generate Mnemonic</button>
        </div>

        <!-- ===== Validate Panel ===== -->
        <div class="bip-panel" id="bip-validate-panel">
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header">Validate & Derive Seed</div>
                <div class="tool-card-body">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bip-val-lang">Language</label>
                        <select class="tool-form-select" id="bip-val-lang" onchange="loadWordlist(this.value)">
                            <option value="english" selected>English</option>
                            <option value="spanish">Spanish (Espa&#241;ol)</option>
                            <option value="french">French (Fran&#231;ais)</option>
                            <option value="italian">Italian (Italiano)</option>
                            <option value="portuguese">Portuguese (Portugu&#234;s)</option>
                            <option value="czech">Czech (&#268;e&#353;tina)</option>
                            <option value="japanese">Japanese (&#26085;&#26412;&#35486;)</option>
                            <option value="korean">Korean (&#54620;&#44397;&#50612;)</option>
                            <option value="chinese_simplified">Chinese Simplified (&#31616;&#20307;&#20013;&#25991;)</option>
                            <option value="chinese_traditional">Chinese Traditional (&#32321;&#39636;&#20013;&#25991;)</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bip-val-input">Mnemonic Phrase</label>
                        <textarea class="tool-form-input" id="bip-val-input" rows="3" placeholder="Enter mnemonic words separated by spaces..."></textarea>
                    </div>
                    <div class="tool-form-group" style="margin-bottom:0;">
                        <label class="tool-form-label" for="bip-val-passphrase">Passphrase (optional 25th word)</label>
                        <div class="bip-password-wrap">
                            <input type="password" class="tool-form-input" id="bip-val-passphrase" placeholder="Leave empty if not used">
                            <button type="button" class="bip-password-toggle" onclick="togglePassphrase()" aria-label="Toggle visibility">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <button type="button" class="tool-action-btn bip-secondary" onclick="validateAndDerive()">Validate & Derive Seed</button>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <div class="tool-card">
            <div class="tool-result-header">
                <h4 id="bip-result-title">Result</h4>
                <button type="button" class="bip-copy-btn" id="bip-copy-mnemonic" style="display:none;" onclick="copyMnemonic()">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    Copy Phrase
                </button>
            </div>
            <div class="tool-result-content" id="bip-result-content">
                <div class="tool-empty-state">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    <h3>No Mnemonic Yet</h3>
                    <p>Generate a new BIP39 mnemonic phrase or validate an existing one.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- ==================== BELOW-FOLD CONTENT ==================== -->

<!-- What is BIP39? -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">What is BIP39?</h2>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            <strong>BIP39 (Bitcoin Improvement Proposal 39)</strong> is a standard for generating mnemonic phrases that represent cryptographic keys. It provides a human-readable way to backup and restore cryptocurrency wallets using a sequence of common English words.
        </p>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            The process works in four steps: <strong>(1)</strong> Cryptographically secure random entropy (128-256 bits) is generated. <strong>(2)</strong> A SHA-256 checksum is appended for integrity verification. <strong>(3)</strong> The combined bits are split into 11-bit segments, each mapped to one of 2048 words. <strong>(4)</strong> The mnemonic plus an optional passphrase are fed through PBKDF2-HMAC-SHA512 (2048 iterations) to produce a 512-bit seed for HD wallet derivation.
        </p>

        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1rem;margin-top:1rem;">
            <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1rem;text-align:center;">
                <div style="font-size:1.5rem;font-weight:700;color:var(--bip-tool-dark);">12 words</div>
                <div style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.25rem;">128-bit entropy</div>
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.125rem;">2<sup>128</sup> combinations</div>
            </div>
            <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1rem;text-align:center;">
                <div style="font-size:1.5rem;font-weight:700;color:var(--bip-tool-dark);">18 words</div>
                <div style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.25rem;">192-bit entropy</div>
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.125rem;">2<sup>192</sup> combinations</div>
            </div>
            <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1rem;text-align:center;">
                <div style="font-size:1.5rem;font-weight:700;color:var(--bip-tool-dark);">24 words</div>
                <div style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.25rem;">256-bit entropy</div>
                <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.125rem;">2<sup>256</sup> combinations</div>
            </div>
        </div>
    </div>
</section>

<!-- Security Best Practices -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">Security Best Practices</h2>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:1rem;">
            <div style="padding:0.75rem;border-left:3px solid #16a34a;">
                <h4 style="font-size:0.875rem;font-weight:600;color:#16a34a;margin:0 0 0.375rem;">Do</h4>
                <ul style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;padding-left:1rem;margin:0;">
                    <li>Write on paper, store in a safe</li>
                    <li>Use a metal backup plate</li>
                    <li>Generate offline or air-gapped</li>
                    <li>Verify the checksum is valid</li>
                </ul>
            </div>
            <div style="padding:0.75rem;border-left:3px solid #dc2626;">
                <h4 style="font-size:0.875rem;font-weight:600;color:#dc2626;margin:0 0 0.375rem;">Don't</h4>
                <ul style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;padding-left:1rem;margin:0;">
                    <li>Store digitally (photos, cloud, email)</li>
                    <li>Share with anyone</li>
                    <li>Enter on untrusted websites</li>
                    <li>Use for large amounts without hardware wallet</li>
                </ul>
            </div>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Frequently Asked Questions</h2>
        <div class="faq-container">
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is BIP39 and how does it work?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">BIP39 (Bitcoin Improvement Proposal 39) is a standard for generating mnemonic phrases that encode cryptographic entropy for deterministic wallet key generation. Random entropy is generated, checksummed with SHA-256, split into 11-bit segments mapped to a 2048-word list, then processed through PBKDF2-HMAC-SHA512 with 2048 iterations to derive a 512-bit seed.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is this tool safe for real cryptocurrency wallets?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">This tool processes everything 100% client-side using the Web Crypto API. No data leaves your browser. However, for real wallets with significant funds, we recommend generating mnemonics offline on an air-gapped computer or using a hardware wallet like Ledger or Trezor.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the difference between 12 and 24 word mnemonics?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">A 12-word mnemonic provides 128 bits of entropy (2^128 combinations), while a 24-word mnemonic provides 256 bits (2^256 combinations). Both are considered secure, but 24 words provides a significantly larger security margin against future advances in computing power.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the BIP39 passphrase (25th word)?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The passphrase is an optional additional input to the PBKDF2 seed derivation. Each different passphrase produces a completely different wallet, providing plausible deniability. If you lose the passphrase, you lose access to that specific wallet. Only use it if you can securely store it separately from your mnemonic.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Does this tool use any external libraries?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">No. All cryptographic operations use the native Web Crypto API (crypto.subtle) built into all modern browsers. SHA-256 for checksums and PBKDF2-HMAC-SHA512 for seed derivation are performed natively without any external JavaScript libraries.</div>
            </div>
        </div>
    </div>
</section>

<!-- Related Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Explore More Cryptography Tools</h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/blockchain-sign.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#f97316);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;color:#fff;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                </div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Blockchain Sign</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;">Sign and verify blockchain transactions</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/ethfunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#6366f1,#818cf8);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">ETH</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Ethereum Tools</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;">Ethereum address and transaction utilities</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/pgpencdec.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#34d399);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.9rem;color:#fff;font-weight:700;">PGP</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">PGP Encryption</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;">Encrypt, decrypt, sign with PGP keys</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/rsafunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#2563eb,#60a5fa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">RSA</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">RSA Functions</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;">RSA key generation, encryption, signing</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/navigation.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<script>
// ── Wordlist management ──
const WORDLIST_BASE = '<%=request.getContextPath()%>/blockchain/wordlists/';
const wordlistCache = {};
let activeWordlist = [];
let activeLanguage = 'english';
let currentMnemonic = '';
let currentSeedHex = '';

async function loadWordlist(lang) {
    activeLanguage = lang;
    // Sync both selectors
    document.getElementById('bip-gen-lang').value = lang;
    document.getElementById('bip-val-lang').value = lang;

    if (wordlistCache[lang]) {
        activeWordlist = wordlistCache[lang];
        return;
    }
    try {
        const resp = await fetch(WORDLIST_BASE + lang + '.json');
        if (!resp.ok) throw new Error('Failed to load ' + lang);
        const words = await resp.json();
        if (!Array.isArray(words) || words.length !== 2048) throw new Error('Invalid wordlist');
        wordlistCache[lang] = words;
        activeWordlist = words;
    } catch (e) {
        showToast('Failed to load ' + lang + ' wordlist', 'error');
    }
}

// Load English on startup
loadWordlist('english');

// ── Helpers ──
function bytesToBinary(bytes) {
    let b = '';
    for (let i = 0; i < bytes.length; i++) b += bytes[i].toString(2).padStart(8, '0');
    return b;
}
function binaryToBytes(bin) {
    const a = [];
    for (let i = 0; i < bin.length; i += 8) a.push(parseInt(bin.substring(i, i + 8), 2));
    return new Uint8Array(a);
}
function bytesToHex(bytes) {
    let h = '';
    for (let i = 0; i < bytes.length; i++) h += bytes[i].toString(16).padStart(2, '0');
    return h;
}
function hexToBinary(hex) {
    let b = '';
    for (let i = 0; i < hex.length; i++) {
        b += parseInt(hex[i], 16).toString(2).padStart(4, '0');
        if ((i + 1) % 8 === 0) b += ' ';
    }
    return b.trim();
}

// ── SHA-256 via Web Crypto ──
async function sha256(data) {
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    return new Uint8Array(hashBuffer);
}

// ── PBKDF2 via Web Crypto ──
async function pbkdf2Derive(mnemonic, passphrase) {
    const enc = new TextEncoder();
    const keyMaterial = await crypto.subtle.importKey('raw', enc.encode(mnemonic.normalize('NFKD')), 'PBKDF2', false, ['deriveBits']);
    const salt = enc.encode(('mnemonic' + passphrase).normalize('NFKD'));
    const bits = await crypto.subtle.deriveBits({ name: 'PBKDF2', salt: salt, iterations: 2048, hash: 'SHA-512' }, keyMaterial, 512);
    return new Uint8Array(bits);
}

// ── Mode switching ──
function switchMode(mode) {
    document.querySelectorAll('.bip-mode-btn').forEach(b => b.classList.remove('bip-active'));
    document.getElementById('bip-mode-' + mode).classList.add('bip-active');
    document.querySelectorAll('.bip-panel').forEach(p => p.classList.remove('bip-panel-active'));
    document.getElementById('bip-' + mode + '-panel').classList.add('bip-panel-active');
}

// ── Strength meter ──
document.getElementById('bip-gen-length').addEventListener('change', function() {
    const len = parseInt(this.value);
    const entropyBits = (len * 11) - (len / 3);
    const pct = (entropyBits / 256) * 100;
    const fill = document.getElementById('bip-strength-fill');
    fill.style.width = pct + '%';
    fill.style.background = pct >= 80 ? '#16a34a' : pct >= 60 ? '#f59e0b' : '#dc2626';
    document.getElementById('bip-strength-text').textContent = entropyBits + '-bit entropy';
    const levels = { 128: 'Strong', 160: 'Very Strong', 192: 'Excellent', 224: 'Superior', 256: 'Maximum' };
    document.getElementById('bip-strength-level').textContent = levels[entropyBits] || '';
});

// ── Generate ──
async function generateMnemonic() {
    const length = parseInt(document.getElementById('bip-gen-length').value);
    const entropyBits = (length * 11) - (length / 3);
    const entropyBytes = entropyBits / 8;

    const randomBytes = new Uint8Array(entropyBytes);
    crypto.getRandomValues(randomBytes);

    const hashBytes = await sha256(randomBytes);
    const checksumBits = entropyBits / 32;

    if (!activeWordlist.length) { showToast('Wordlist not loaded yet', 'error'); return; }

    const allBits = bytesToBinary(randomBytes) + bytesToBinary(hashBytes).substring(0, checksumBits);

    const words = [];
    for (let i = 0; i < allBits.length; i += 11) {
        words.push(activeWordlist[parseInt(allBits.substring(i, i + 11), 2)]);
    }

    currentMnemonic = words.join(' ');
    document.getElementById('bip-val-input').value = currentMnemonic;

    // Derive seed
    const seedBytes = await pbkdf2Derive(currentMnemonic, '');
    currentSeedHex = bytesToHex(seedBytes);
    const entropy = bytesToHex(randomBytes);

    renderGenerateResult(words, entropy, entropyBits, currentSeedHex);
    showToast('Mnemonic generated', 'success');
}

// ── Validate ──
async function validateAndDerive() {
    const input = document.getElementById('bip-val-input').value.trim().toLowerCase();
    const passphrase = document.getElementById('bip-val-passphrase').value;

    if (!input) { showToast('Enter a mnemonic phrase', 'error'); return; }

    const words = input.split(/\s+/).filter(w => w);
    const wordCount = words.length;

    if (![12, 15, 18, 21, 24].includes(wordCount)) {
        renderValidationError('Invalid word count: ' + wordCount + '. Must be 12, 15, 18, 21, or 24.');
        return;
    }

    if (!activeWordlist.length) { showToast('Wordlist not loaded yet', 'error'); return; }

    const invalidWords = words.filter(w => !activeWordlist.includes(w));
    if (invalidWords.length) {
        renderValidationError('Invalid word' + (invalidWords.length > 1 ? 's' : '') + ': ' + invalidWords.join(', '));
        return;
    }

    let allBits = '';
    for (const w of words) allBits += activeWordlist.indexOf(w).toString(2).padStart(11, '0');

    const entropyBits = (wordCount * 11) - (wordCount / 3);
    const checksumLen = wordCount / 3;
    const entropyBin = allBits.substring(0, entropyBits);
    const checksumBin = allBits.substring(entropyBits);
    const entropyBytes = binaryToBytes(entropyBin);
    const entropy = bytesToHex(entropyBytes);

    const hashBytes = await sha256(entropyBytes);
    const calcChecksum = bytesToBinary(hashBytes).substring(0, checksumLen);

    if (checksumBin !== calcChecksum) {
        renderValidationError('Invalid checksum. Mnemonic may be corrupted or incorrectly transcribed.');
        return;
    }

    const seedBytes = await pbkdf2Derive(words.join(' '), passphrase);
    currentSeedHex = bytesToHex(seedBytes);
    currentMnemonic = words.join(' ');

    renderValidateResult(words, entropy, entropyBits, currentSeedHex, passphrase);
    showToast('Valid BIP39 mnemonic', 'success');
}

// ── Render: Generate result ──
function renderGenerateResult(words, entropy, entropyBits, seedHex) {
    const el = document.getElementById('bip-result-content');
    document.getElementById('bip-copy-mnemonic').style.display = '';
    document.getElementById('bip-result-title').textContent = 'Generated Mnemonic';

    const langLabel = document.getElementById('bip-gen-lang').selectedOptions[0].textContent;

    let html = '<div class="bip-result-section">';
    html += '<div class="bip-section-title">Mnemonic Phrase (' + words.length + ' words)</div>';
    html += '<div class="bip-word-grid">';
    words.forEach((w, i) => {
        html += '<div class="bip-word-cell"><span class="bip-word-num">' + (i + 1) + '</span><span class="bip-word-text">' + escapeHtml(w) + '</span></div>';
    });
    html += '</div></div>';

    html += '<div class="bip-result-section">';
    html += '<div class="bip-section-title">Details</div>';
    html += '<div class="bip-info-grid">';
    html += infoRow('Language', langLabel);
    html += infoRow('Entropy', entropyBits + ' bits');
    html += infoRow('Entropy (hex)', entropy);
    html += infoRow('Checksum', (words.length / 3) + ' bits');
    html += infoRow('Word count', words.length);
    html += '</div></div>';

    html += '<div class="bip-result-section">';
    html += '<div class="bip-section-title">Derived Seed (512-bit)</div>';
    html += '<div class="bip-seed-box">' + seedHex + '</div>';
    html += '<div class="bip-toolbar"><button class="bip-copy-btn" onclick="copySeed()"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg> Copy Seed</button></div>';
    html += '</div>';

    html += '<div class="bip-alert bip-alert-info" style="margin-top:1rem;">This seed can be used with BIP32/BIP44 derivation to generate HD wallet keys for Bitcoin, Ethereum, and other cryptocurrencies.</div>';

    el.innerHTML = html;
}

// ── Render: Validate result ──
function renderValidateResult(words, entropy, entropyBits, seedHex, passphrase) {
    const el = document.getElementById('bip-result-content');
    document.getElementById('bip-copy-mnemonic').style.display = '';
    document.getElementById('bip-result-title').textContent = 'Validation Result';
    const langLabel = document.getElementById('bip-val-lang').selectedOptions[0].textContent;

    let html = '<div class="bip-result-section">';
    html += '<div class="bip-section-title">Mnemonic Phrase</div>';
    html += '<div class="bip-word-grid">';
    words.forEach((w, i) => {
        html += '<div class="bip-word-cell"><span class="bip-word-num">' + (i + 1) + '</span><span class="bip-word-text">' + escapeHtml(w) + '</span></div>';
    });
    html += '</div></div>';

    html += '<div class="bip-result-section">';
    html += '<div class="bip-section-title">Validation</div>';
    html += '<div class="bip-info-grid">';
    html += '<div class="bip-info-row"><span class="bip-info-label">Status</span><span class="bip-info-value bip-success">Valid BIP39 Mnemonic</span></div>';
    html += infoRow('Language', langLabel);
    html += infoRow('Word count', words.length);
    html += infoRow('Entropy', entropyBits + ' bits');
    html += infoRow('Entropy (hex)', entropy);
    if (passphrase) html += infoRow('Passphrase', 'Protected');
    html += '</div></div>';

    html += '<div class="bip-result-section">';
    html += '<div class="bip-section-title">Derived Seed (512-bit)</div>';
    html += '<div class="bip-seed-box">' + seedHex + '</div>';
    html += '<div class="bip-toolbar"><button class="bip-copy-btn" onclick="copySeed()"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg> Copy Seed</button></div>';
    html += '</div>';

    el.innerHTML = html;
}

// ── Render: Validation error ──
function renderValidationError(msg) {
    const el = document.getElementById('bip-result-content');
    document.getElementById('bip-copy-mnemonic').style.display = 'none';
    document.getElementById('bip-result-title').textContent = 'Validation Result';
    el.innerHTML = '<div class="bip-result-section"><div class="bip-info-grid"><div class="bip-info-row"><span class="bip-info-label">Status</span><span class="bip-info-value bip-error">Invalid</span></div><div class="bip-info-row"><span class="bip-info-label">Error</span><span class="bip-info-value" style="color:var(--error);">' + escapeHtml(msg) + '</span></div></div></div>';
    showToast('Validation failed', 'error');
}

function infoRow(label, value) {
    return '<div class="bip-info-row"><span class="bip-info-label">' + label + '</span><span class="bip-info-value">' + escapeHtml(String(value)) + '</span></div>';
}

function escapeHtml(s) {
    const d = document.createElement('div');
    d.textContent = s;
    return d.innerHTML;
}

// ── Copy ──
function copyMnemonic() {
    if (!currentMnemonic) return;
    navigator.clipboard.writeText(currentMnemonic).then(() => {
        const btn = document.getElementById('bip-copy-mnemonic');
        btn.classList.add('copied');
        btn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Copied!';
        setTimeout(() => {
            btn.classList.remove('copied');
            btn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg> Copy Phrase';
        }, 2000);
    });
}

function copySeed() {
    if (!currentSeedHex) return;
    navigator.clipboard.writeText(currentSeedHex).then(() => showToast('Seed copied', 'success'));
}

// ── Toggle passphrase visibility ──
function togglePassphrase() {
    const input = document.getElementById('bip-val-passphrase');
    input.type = input.type === 'password' ? 'text' : 'password';
}

// ── Toast ──
function showToast(msg, type) {
    const existing = document.querySelector('.bip-toast');
    if (existing) existing.remove();
    const t = document.createElement('div');
    t.className = 'bip-toast ' + type;
    t.textContent = msg;
    document.body.appendChild(t);
    requestAnimationFrame(() => t.classList.add('show'));
    setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 300); }, 2500);
}

// ── FAQ toggle ──
function toggleFaq(btn) {
    btn.parentElement.classList.toggle('open');
}
</script>
</body>
</html>
