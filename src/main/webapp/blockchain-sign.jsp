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

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Ethereum Message Signing & Verification Tool - EIP-191 Personal Sign" />
        <jsp:param name="toolDescription" value="Sign and verify Ethereum messages client-side using ethers.js. Supports EIP-191 personal_sign (MetaMask-compatible) and raw keccak256 hash signing with secp256k1. Generate key pairs, import private keys, and recover signer addresses." />
        <jsp:param name="toolCategory" value="Blockchain" />
        <jsp:param name="toolUrl" value="blockchain-sign.jsp" />
        <jsp:param name="toolKeywords" value="ethereum sign message, EIP-191 personal sign, secp256k1 signature, verify ethereum signature, recover signer address, ethers.js sign, MetaMask sign message, blockchain digital signature, keccak256 hash sign, ethereum key pair generator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="EIP-191 Personal Sign, Raw Keccak256 Hash Sign, Key Pair Generation, Signature Verification, Address Recovery, Client-Side Only" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="College, Professional" />
        <jsp:param name="teaches" value="Ethereum message signing, EIP-191 standard, secp256k1 elliptic curve cryptography, digital signature verification" />
        <jsp:param name="howToSteps" value="Generate or import an Ethereum private key|Enter the message you want to sign|Choose signing method: EIP-191 Personal Sign or Raw Hash|Click Sign Message to produce the signature|Switch to Verify mode to recover the signer address" />
        <jsp:param name="faq1q" value="What is EIP-191 Personal Sign?" />
        <jsp:param name="faq1a" value="EIP-191 defines a standard for signing human-readable messages in Ethereum. It prefixes the message with the string Ethereum Signed Message and the message length before hashing with keccak256 and signing. This is the same method MetaMask and other wallets use when you click Sign Message, preventing signed messages from being replayed as transactions." />
        <jsp:param name="faq2q" value="Is it safe to use a private key in a browser tool?" />
        <jsp:param name="faq2a" value="This tool runs 100% client-side using ethers.js. No private keys are ever sent to a server. You can verify this by checking the network tab in your browser developer tools. For maximum security, use this tool offline after the page has loaded, or use it only with test keys." />
        <jsp:param name="faq3q" value="What blockchains are compatible with these signatures?" />
        <jsp:param name="faq3a" value="Any EVM-compatible blockchain uses the same secp256k1 curve and address format. Signatures generated here work on Ethereum, Polygon, Arbitrum, Optimism, Avalanche C-Chain, BNB Smart Chain, and all other EVM chains." />
        <jsp:param name="faq4q" value="What is the difference between Personal Sign and Raw Hash Sign?" />
        <jsp:param name="faq4a" value="Personal Sign (EIP-191) adds a prefix to prevent signed messages from being used as transactions. Raw Hash Sign signs an arbitrary 32-byte keccak256 hash directly without any prefix. Use Personal Sign for user-facing messages and Raw Hash for protocol-level signing." />
        <jsp:param name="faq5q" value="How do I verify a signature without the private key?" />
        <jsp:param name="faq5a" value="Ethereum signatures allow you to recover the signer public key and address from just the message and signature using ecrecover. Switch to Verify mode, paste the original message and signature, and the tool will recover the signer address so you can confirm it matches the expected signer." />
        <jsp:param name="faq6q" value="What are the r, s, and v components of a signature?" />
        <jsp:param name="faq6a" value="An ECDSA signature consists of two 256-bit integers r and s, plus a recovery parameter v (27 or 28). The r and s values are the mathematical output of the signing algorithm, while v helps identify which of two possible public keys was used to create the signature." />
        <jsp:param name="faq7q" value="Can I use this tool offline?" />
        <jsp:param name="faq7a" value="Yes. Once the page and ethers.js library have loaded, all operations run entirely in your browser with no server calls. You can disconnect from the internet and the tool will continue to work." />
        <jsp:param name="faq8q" value="Why does my recovered address not match?" />
        <jsp:param name="faq8a" value="The recovered address will only match if you use exactly the same message text and the correct signature. Even a single character difference, including trailing whitespace or newlines, will produce a different recovered address. Make sure you are comparing against the correct signer address." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "mainEntityOfPage": { "@type": "WebPage", "@id": "https://8gwifi.org/blockchain-sign.jsp" },
      "headline": "Ethereum Message Signing Tool - EIP-191 Personal Sign & Verification",
      "description": "Sign and verify Ethereum messages client-side with ethers.js. Supports EIP-191 personal_sign, raw keccak256 hash signing, key generation, and address recovery.",
      "about": [
        { "@type": "Thing", "name": "EIP-191", "description": "Ethereum standard for signing human-readable messages with a prefix to prevent transaction replay", "sameAs": "https://eips.ethereum.org/EIPS/eip-191" },
        { "@type": "Thing", "name": "secp256k1", "description": "Elliptic curve used by Ethereum and Bitcoin for digital signatures", "sameAs": "https://en.bitcoin.it/wiki/Secp256k1" },
        { "@type": "Thing", "name": "ethers.js", "description": "Complete Ethereum library for JavaScript and TypeScript", "sameAs": "https://docs.ethers.org/v6/" }
      ],
      "author": { "@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org" },
      "publisher": { "@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org", "logo": { "@type": "ImageObject", "url": "https://8gwifi.org/images/site/logo.png" } },
      "datePublished": "2023-05-11",
      "dateModified": "2026-02-28",
      "inLanguage": "en-US"
    }
    </script>

    <style>
        :root{
            --eth-tool:#6366f1;--eth-tool-dark:#4f46e5;--eth-gradient:linear-gradient(135deg,#6366f1 0%,#818cf8 100%);--eth-light:rgba(99,102,241,0.1);
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
        [data-theme="dark"]{--eth-light:rgba(99,102,241,0.15);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}

        /* Shared layout classes */
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--eth-light);color:var(--eth-tool-dark)}
        [data-theme="dark"] .tool-badge{color:#a5b4fc}
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
        .tool-card-header{background:var(--eth-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem}
        .tool-card-body{padding:1rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary);font-size:0.8125rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-input,.tool-form-select{width:100%;padding:0.5rem 0.75rem;font-family:var(--font-sans);font-size:0.8125rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);transition:border-color 0.15s;box-sizing:border-box}
        .tool-form-input:focus,.tool-form-select:focus{outline:none;border-color:var(--eth-tool);box-shadow:0 0 0 3px rgba(99,102,241,0.15)}
        textarea.tool-form-input{font-family:var(--font-mono);resize:vertical}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--eth-gradient)!important;color:#fff;transition:opacity .15s;font-family:var(--font-sans)}
        .tool-action-btn:hover{opacity:0.9}
        .tool-action-btn:disabled{opacity:0.5;cursor:not-allowed}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary);flex:1}
        .tool-result-content{padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted)}
        .tool-empty-state svg{margin-bottom:1rem;opacity:0.4}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary)}

        /* ETH-specific: Mode Toggle */
        .eth-mode-toggle{display:flex;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.625rem}
        .eth-mode-btn{flex:1;padding:0.625rem;font-size:0.8125rem;font-weight:600;border:none;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .eth-mode-btn:not(:last-child){border-right:1.5px solid var(--border)}
        .eth-mode-btn.eth-active{background:var(--eth-gradient);color:#fff}
        [data-theme="dark"] .eth-mode-btn{background:var(--bg-secondary);color:var(--text-secondary)}
        [data-theme="dark"] .eth-mode-btn.eth-active{background:var(--eth-gradient);color:#fff}
        .eth-panel{display:none}
        .eth-panel-active{display:block}

        /* Key input row */
        .eth-key-row{display:flex;gap:0.5rem}
        .eth-key-row .tool-form-input{flex:1;min-width:0}
        .eth-gen-btn{padding:0.5rem 0.75rem;font-size:0.75rem;font-weight:600;border:none;border-radius:0.5rem;background:var(--eth-gradient);color:#fff;cursor:pointer;white-space:nowrap;font-family:var(--font-sans);transition:opacity .15s}
        .eth-gen-btn:hover{opacity:0.9}

        /* Derived address */
        .eth-derived{padding:0.5rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;font-family:var(--font-mono);font-size:0.75rem;color:var(--text-secondary);word-break:break-all;min-height:2rem;display:flex;align-items:center}
        .eth-derived:empty::before{content:'No key loaded';color:var(--text-muted);font-family:var(--font-sans);font-style:italic}

        /* Sign type selector */
        .eth-sign-type{display:flex;gap:0.5rem;margin-bottom:0.875rem}
        .eth-sign-type label{flex:1;display:flex;align-items:center;gap:0.375rem;padding:0.5rem 0.625rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.75rem;font-weight:500;color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .eth-sign-type input[type="radio"]{accent-color:var(--eth-tool)}
        .eth-sign-type label:has(input:checked){border-color:var(--eth-tool);background:var(--eth-light);color:var(--eth-tool-dark)}
        [data-theme="dark"] .eth-sign-type label:has(input:checked){color:#a5b4fc}

        /* Warning box */
        .eth-warning{padding:0.75rem;background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);border-radius:0.5rem;font-size:0.75rem;line-height:1.5;color:#92400e;margin-bottom:0.875rem;display:flex;gap:0.5rem;align-items:flex-start}
        .eth-warning svg{flex-shrink:0;margin-top:1px}
        [data-theme="dark"] .eth-warning{background:rgba(245,158,11,0.12);border-color:rgba(245,158,11,0.25);color:#fbbf24}

        /* Output rows */
        .eth-output-row{margin-bottom:1rem}
        .eth-output-label{font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem;display:flex;align-items:center;justify-content:space-between}
        .eth-output-value{padding:0.625rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;font-family:var(--font-mono);font-size:0.75rem;color:var(--text-primary);word-break:break-all;line-height:1.5;position:relative}
        [data-theme="dark"] .eth-output-value{background:var(--bg-tertiary)}

        /* Copy button */
        .eth-copy-btn{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.5rem;font-size:0.6875rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .eth-copy-btn:hover{border-color:var(--eth-tool);color:var(--eth-tool-dark)}
        .eth-copy-btn.copied{border-color:var(--success);color:var(--success)}
        [data-theme="dark"] .eth-copy-btn{background:var(--bg-secondary)}

        /* Verification status */
        .eth-status{display:inline-flex;align-items:center;gap:0.375rem;padding:0.5rem 0.875rem;border-radius:0.5rem;font-size:0.8125rem;font-weight:600;font-family:var(--font-sans)}
        .eth-status-valid{background:rgba(22,163,74,0.1);color:#16a34a;border:1px solid rgba(22,163,74,0.3)}
        .eth-status-invalid{background:rgba(220,38,38,0.1);color:#dc2626;border:1px solid rgba(220,38,38,0.3)}
        .eth-status-mismatch{background:rgba(245,158,11,0.1);color:#d97706;border:1px solid rgba(245,158,11,0.3)}

        /* Toast */
        .eth-toast{position:fixed;top:1rem;right:1rem;z-index:9999;padding:0.75rem 1rem;border-radius:0.5rem;font-size:0.8125rem;font-weight:500;color:#fff;transform:translateY(-1rem);opacity:0;transition:all 0.3s;font-family:var(--font-sans)}
        .eth-toast.show{transform:translateY(0);opacity:1}
        .eth-toast.success{background:#16a34a}
        .eth-toast.error{background:#dc2626}

        /* Scroll animations */
        .eth-anim{opacity:0;transform:translateY(20px);transition:opacity 0.6s ease-out,transform 0.6s ease-out}
        .eth-visible{opacity:1;transform:translateY(0)}
        .eth-anim-d1{transition-delay:0.1s}
        .eth-anim-d2{transition-delay:0.2s}
        .eth-anim-d3{transition-delay:0.3s}

        /* FAQ */
        .faq-container{display:grid;gap:0.5rem}
        .faq-item{border:1px solid var(--border);border-radius:0.5rem;overflow:hidden}
        .faq-question{width:100%;display:flex;align-items:center;justify-content:space-between;padding:0.875rem 1rem;border:none;background:var(--bg-primary);color:var(--text-primary);font-size:0.875rem;font-weight:500;cursor:pointer;text-align:left;font-family:var(--font-sans)}
        [data-theme="dark"] .faq-question{background:var(--bg-secondary)}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0;margin-left:0.5rem}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-answer{display:none;padding:0 1rem 0.875rem;font-size:0.8125rem;line-height:1.6;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}

        /* Intro animation */
        .eth-intro{padding:1.5rem 1.25rem;text-align:center}
        .eth-intro-icon{display:inline-flex;align-items:center;justify-content:center;width:56px;height:56px;border-radius:50%;background:var(--eth-light);color:var(--eth-tool);margin-bottom:0.75rem;animation:eth-pulse 2s ease-in-out infinite}
        @keyframes eth-pulse{0%,100%{transform:scale(1);opacity:1}50%{transform:scale(1.08);opacity:0.85}}
        .eth-intro-title{font-size:1rem;font-weight:700;color:var(--text-primary);margin:0 0 1.25rem;font-family:var(--font-sans)}
        .eth-intro-steps{display:grid;gap:0.625rem;text-align:left;max-width:400px;margin:0 auto 1.25rem}
        .eth-intro-step{display:flex;gap:0.75rem;align-items:flex-start;padding:0.625rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;opacity:0;transform:translateX(-12px);animation:eth-slideIn 0.4s ease-out forwards;animation-delay:var(--delay)}
        @keyframes eth-slideIn{to{opacity:1;transform:translateX(0)}}
        .eth-intro-num{display:flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;border-radius:50%;background:var(--eth-gradient);color:#fff;font-size:0.6875rem;font-weight:700;flex-shrink:0;margin-top:1px}
        .eth-intro-step strong{display:block;font-size:0.8125rem;font-weight:600;color:var(--text-primary);margin-bottom:0.125rem}
        .eth-intro-step span{font-size:0.75rem;line-height:1.5;color:var(--text-secondary)}
        .eth-intro-cta{opacity:0;transform:translateY(8px);animation:eth-fadeUp 0.5s ease-out forwards;animation-delay:var(--delay)}
        @keyframes eth-fadeUp{to{opacity:1;transform:translateY(0)}}
        [data-theme="dark"] .eth-intro-step{background:var(--bg-tertiary)}

        /* Password toggle */
        .eth-pw-wrap{position:relative;flex:1;min-width:0}
        .eth-pw-wrap input{padding-right:2.25rem;width:100%}
        .eth-pw-toggle{position:absolute;right:0.5rem;top:50%;transform:translateY(-50%);border:none;background:none;color:var(--text-muted);cursor:pointer;padding:0.25rem}
        .eth-pw-toggle:hover{color:var(--text-primary)}
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

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Ethereum Message Signing</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/CipherFunctions.jsp">Cryptography</a> /
                Blockchain Sign
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">EIP-191</span>
            <span class="tool-badge">secp256k1</span>
            <span class="tool-badge">ethers.js v6</span>
            <span class="tool-badge">100% Client-Side</span>
        </div>
    </div>
</header>

<!-- Description -->
<section class="tool-description-section" style="background:var(--eth-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Sign and verify <strong>Ethereum messages</strong> entirely in your browser using <strong>ethers.js v6</strong>. Supports <strong>EIP-191 personal_sign</strong> (MetaMask-compatible) and <strong>raw keccak256 hash signing</strong>. Generate key pairs, import private keys, and recover signer addresses &mdash; no server calls, no data leaves your device.</p>
        </div>
    </div>
</section>

<!-- Main Layout -->
<main class="tool-page-container">

    <!-- Left Column: Input -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                Blockchain Signing Tool
            </div>
            <div class="tool-card-body">

                <!-- Mode Toggle -->
                <div class="eth-mode-toggle">
                    <button type="button" class="eth-mode-btn eth-active" id="eth-mode-sign" onclick="EthSign.switchMode('sign')">Sign</button>
                    <button type="button" class="eth-mode-btn" id="eth-mode-verify" onclick="EthSign.switchMode('verify')">Verify</button>
                </div>

                <!-- Sign Panel -->
                <div class="eth-panel eth-panel-active" id="eth-sign-panel">

                    <div class="eth-warning">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                        <span><strong>Security:</strong> Never paste a real private key on any website. Use this tool with test keys only, or run it offline.</span>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Private Key (hex)</label>
                        <div class="eth-key-row">
                            <div class="eth-pw-wrap">
                                <input type="password" class="tool-form-input" id="eth-private-key" placeholder="0x... or raw hex" spellcheck="false" oninput="EthSign.deriveAddress()">
                                <button type="button" class="eth-pw-toggle" onclick="EthSign.toggleKeyVisibility()" aria-label="Toggle key visibility">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                            <button type="button" class="eth-gen-btn" onclick="EthSign.generateKeyPair()">Generate</button>
                        </div>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Derived Address</label>
                        <div class="eth-derived" id="eth-address"></div>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Message</label>
                        <textarea class="tool-form-input" id="eth-sign-message" rows="4" placeholder="Enter message to sign..." style="font-family:var(--font-mono);resize:vertical"></textarea>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Signing Method</label>
                        <div class="eth-sign-type">
                            <label><input type="radio" name="eth-sign-type" value="personal" checked> EIP-191 Personal</label>
                            <label><input type="radio" name="eth-sign-type" value="raw"> Raw Keccak256</label>
                        </div>
                    </div>

                    <button type="button" class="tool-action-btn" onclick="EthSign.signMessage()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        Sign Message
                    </button>
                </div>

                <!-- Verify Panel -->
                <div class="eth-panel" id="eth-verify-panel">

                    <div class="tool-form-group">
                        <label class="tool-form-label">Original Message</label>
                        <textarea class="tool-form-input" id="eth-verify-message" rows="4" placeholder="Enter the original message..." style="font-family:var(--font-mono);resize:vertical"></textarea>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Signature (0x hex, 65 bytes)</label>
                        <textarea class="tool-form-input" id="eth-verify-sig" rows="3" placeholder="0x..." spellcheck="false" style="font-family:var(--font-mono);resize:vertical"></textarea>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Expected Address (optional)</label>
                        <input type="text" class="tool-form-input" id="eth-verify-addr" placeholder="0x... for match check" spellcheck="false" style="font-family:var(--font-mono)">
                    </div>

                    <button type="button" class="tool-action-btn" onclick="EthSign.verifySignature()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polyline points="20 6 9 17 4 12"/></svg>
                        Verify Signature
                    </button>
                </div>

            </div>
        </div>
    </div>

    <!-- Center Column: Output -->
    <div class="tool-output-column">
        <div class="tool-card" style="height:100%;">
            <div class="tool-result-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                <h4 id="eth-result-title">Result</h4>
                <div style="display:flex;gap:0.375rem" id="eth-result-actions">
                    <button type="button" class="eth-copy-btn" id="eth-share-btn" onclick="EthSign.shareResultUrl()" style="display:none">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                        Share
                    </button>
                    <button type="button" class="eth-copy-btn" id="eth-download-btn" onclick="EthSign.downloadResult()" style="display:none">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        Download
                    </button>
                </div>
            </div>
            <div class="tool-result-content" id="eth-result-content">
                <div class="eth-intro" id="eth-intro">
                    <div class="eth-intro-icon">
                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    </div>
                    <h3 class="eth-intro-title">What is Ethereum Message Signing?</h3>
                    <div class="eth-intro-steps">
                        <div class="eth-intro-step" style="--delay:0.3s">
                            <span class="eth-intro-num">1</span>
                            <div>
                                <strong>Prove Identity</strong>
                                <span>Sign a message to prove you own an Ethereum address &mdash; without revealing your private key</span>
                            </div>
                        </div>
                        <div class="eth-intro-step" style="--delay:0.6s">
                            <span class="eth-intro-num">2</span>
                            <div>
                                <strong>Sign In with Ethereum</strong>
                                <span>Authenticate to dApps and Web3 services using EIP-191 personal_sign &mdash; the same method MetaMask uses</span>
                            </div>
                        </div>
                        <div class="eth-intro-step" style="--delay:0.9s">
                            <span class="eth-intro-num">3</span>
                            <div>
                                <strong>Verify Signatures</strong>
                                <span>Recover the signer address from any message + signature pair to confirm authenticity</span>
                            </div>
                        </div>
                        <div class="eth-intro-step" style="--delay:1.2s">
                            <span class="eth-intro-num">4</span>
                            <div>
                                <strong>Off-Chain Governance</strong>
                                <span>Cast gasless votes on Snapshot and other off-chain governance platforms with signed messages</span>
                            </div>
                        </div>
                    </div>
                    <div class="eth-intro-cta" style="--delay:1.6s">
                        <button type="button" class="tool-action-btn" onclick="EthSign.generateKeyPair()" style="max-width:280px;margin:0 auto;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                            Try It &mdash; Generate a Key Pair
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Ads -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

</main>

<!-- Educational Sections -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="eth-anim">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">What is Ethereum Message Signing?</h2>
        <p style="font-size:0.875rem;line-height:1.7;color:var(--text-secondary);margin:0 0 0.75rem;">Ethereum message signing uses the <strong>secp256k1</strong> elliptic curve to produce a cryptographic signature that proves the signer controls a specific private key &mdash; and therefore a specific Ethereum address &mdash; without revealing the key itself. This is the foundation of authentication in decentralized applications (dApps), token approvals, and off-chain governance voting.</p>
        <p style="font-size:0.875rem;line-height:1.7;color:var(--text-secondary);margin:0;">The <strong>EIP-191</strong> standard (also known as <code style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;">personal_sign</code>) prefixes the message with <code style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;">\x19Ethereum Signed Message:\n&lt;length&gt;</code> before hashing with keccak256. This prefix prevents a signed message from being replayed as a valid Ethereum transaction, making it safe for user-facing "Sign In with Ethereum" flows.</p>
    </div>
</section>

<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="eth-anim eth-anim-d1">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">Security Best Practices</h2>
        <ul style="font-size:0.875rem;line-height:1.8;color:var(--text-secondary);margin:0;padding-left:1.25rem;">
            <li><strong>Never share your private key.</strong> Anyone with your private key can sign messages and transactions as you.</li>
            <li><strong>Use test keys for experimentation.</strong> Generate a throwaway key pair with the "Generate" button for learning purposes.</li>
            <li><strong>Verify client-side operation.</strong> Open your browser's Network tab to confirm no data leaves your device.</li>
            <li><strong>Prefer EIP-191 for user messages.</strong> Raw hash signing should only be used for protocol-level operations where you understand the implications.</li>
            <li><strong>Check the recovered address.</strong> Always verify signatures by recovering the signer address and comparing it against the expected signer.</li>
        </ul>
    </div>
</section>

<!-- FAQ Section -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="eth-anim eth-anim-d2">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Frequently Asked Questions</h3>
        <div class="faq-container">
            <div class="faq-item">
                <button class="faq-question" onclick="EthSign.toggleFaq(this)">What is EIP-191 Personal Sign?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">EIP-191 defines a standard for signing human-readable messages in Ethereum. It prefixes the message with <code>\x19Ethereum Signed Message:\n</code> and the message length before hashing with keccak256 and signing. This is the same method MetaMask and other wallets use, preventing signed messages from being replayed as transactions.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthSign.toggleFaq(this)">Is it safe to use a private key in a browser tool?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">This tool runs 100% client-side using ethers.js. No private keys are ever sent to a server. You can verify this by checking the Network tab in your browser developer tools. For maximum security, use this tool offline after the page has loaded, or use it only with test keys.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthSign.toggleFaq(this)">What blockchains are compatible with these signatures?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Any EVM-compatible blockchain uses the same secp256k1 curve and address format. Signatures generated here work on Ethereum, Polygon, Arbitrum, Optimism, Avalanche C-Chain, BNB Smart Chain, and all other EVM chains.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthSign.toggleFaq(this)">What is the difference between Personal Sign and Raw Hash Sign?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Personal Sign (EIP-191) adds a prefix to prevent signed messages from being used as transactions. Raw Hash Sign signs an arbitrary 32-byte keccak256 hash directly without any prefix. Use Personal Sign for user-facing messages and Raw Hash for protocol-level signing.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthSign.toggleFaq(this)">How do I verify a signature without the private key?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Ethereum signatures allow you to recover the signer's public key and address from just the message and signature using ecrecover. Switch to Verify mode, paste the original message and signature, and the tool will recover the signer address so you can confirm it matches the expected signer.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthSign.toggleFaq(this)">What are the r, s, and v components of a signature?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">An ECDSA signature consists of two 256-bit integers <code>r</code> and <code>s</code>, plus a recovery parameter <code>v</code> (27 or 28). The r and s values are the mathematical output of the signing algorithm, while v helps identify which of two possible public keys was used to create the signature.</div>
            </div>
        </div>
    </div>
</section>

<!-- Related Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="eth-anim eth-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Explore More Cryptography Tools</h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/bip39-mnemonic.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#f97316);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;">BIP39</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">BIP39 Mnemonic Generator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Generate &amp; validate seed phrases in 10 languages</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/ecfunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#10b981,#34d399);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.65rem;color:#fff;font-weight:700;">ECDSA</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">ECDSA Key &amp; Signature</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Elliptic curve key generation, sign &amp; verify</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/pgpencdec.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#8b5cf6,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.85rem;color:#fff;font-weight:700;">PGP</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">PGP Encryption</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">PGP key generation, encrypt, sign &amp; verify</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/rsafunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#ef4444,#f87171);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.85rem;color:#fff;font-weight:700;">RSA</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">RSA Functions</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">RSA key generation, encrypt, decrypt &amp; sign</p>
                </div>
            </a>
        </div>
    </div>
</section>

<%@ include file="modern/components/support-section.jsp" %>

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

<!-- ethers.js v6 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.13.4/ethers.umd.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>

<script>
var EthSign = (function() {
    'use strict';

    // --- State ---
    var lastResult = null; // stores last sign/verify result for download

    // --- Helpers ---
    function $(id) { return document.getElementById(id); }

    function showToast(msg, type) {
        var t = document.createElement('div');
        t.className = 'eth-toast ' + type + ' show';
        t.textContent = msg;
        document.body.appendChild(t);
        setTimeout(function() { t.remove(); }, 3000);
    }

    function copyText(text, btn) {
        navigator.clipboard.writeText(text).then(function() {
            if (btn) {
                btn.classList.add('copied');
                var orig = btn.innerHTML;
                btn.innerHTML = '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Copied';
                setTimeout(function() { btn.classList.remove('copied'); btn.innerHTML = orig; }, 1500);
            }
            showToast('Copied to clipboard', 'success');
        });
    }

    function escapeHtml(s) {
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(s));
        return d.innerHTML;
    }

    function copyBtnHtml(id) {
        return '<button type="button" class="eth-copy-btn" onclick="EthSign.copyById(\'' + id + '\',this)">' +
               '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>' +
               ' Copy</button>';
    }

    // --- Mode switching ---
    function switchMode(mode) {
        var signBtn = $('eth-mode-sign'), verifyBtn = $('eth-mode-verify');
        var signPanel = $('eth-sign-panel'), verifyPanel = $('eth-verify-panel');
        if (mode === 'sign') {
            signBtn.classList.add('eth-active');
            verifyBtn.classList.remove('eth-active');
            signPanel.classList.add('eth-panel-active');
            verifyPanel.classList.remove('eth-panel-active');
        } else {
            signBtn.classList.remove('eth-active');
            verifyBtn.classList.add('eth-active');
            signPanel.classList.remove('eth-panel-active');
            verifyPanel.classList.add('eth-panel-active');
        }
    }

    // --- Key operations ---
    function generateKeyPair() {
        try {
            var wallet = ethers.Wallet.createRandom();
            var pkInput = $('eth-private-key');
            pkInput.value = wallet.privateKey;
            pkInput.type = 'text'; // show the generated key
            $('eth-address').textContent = wallet.address;
            showToast('Key pair generated', 'success');
        } catch (e) {
            showToast('Error generating key: ' + e.message, 'error');
        }
    }

    function deriveAddress() {
        var pk = $('eth-private-key').value.trim();
        var addrEl = $('eth-address');
        if (!pk) { addrEl.textContent = ''; return; }
        try {
            if (pk.length === 64) pk = '0x' + pk;
            var wallet = new ethers.Wallet(pk);
            addrEl.textContent = wallet.address;
        } catch (e) {
            addrEl.textContent = '';
        }
    }

    function toggleKeyVisibility() {
        var inp = $('eth-private-key');
        inp.type = inp.type === 'password' ? 'text' : 'password';
    }

    // --- Sign ---
    function signMessage() {
        var pk = $('eth-private-key').value.trim();
        var msg = $('eth-sign-message').value;
        var signType = document.querySelector('input[name="eth-sign-type"]:checked').value;

        if (!pk) { showToast('Please enter or generate a private key', 'error'); return; }
        if (!msg) { showToast('Please enter a message to sign', 'error'); return; }

        try {
            if (pk.length === 64) pk = '0x' + pk;
            var wallet = new ethers.Wallet(pk);
            var signerAddress = wallet.address;

            if (signType === 'personal') {
                wallet.signMessage(msg).then(function(signature) {
                    displaySignResult(signature, signerAddress, 'EIP-191 Personal Sign');
                }).catch(function(e) {
                    showToast('Signing failed: ' + e.message, 'error');
                });
            } else {
                // Raw keccak256 hash sign
                var hash = ethers.keccak256(ethers.toUtf8Bytes(msg));
                var signingKey = new ethers.SigningKey(pk);
                var sig = signingKey.sign(hash);
                var fullSig = ethers.Signature.from(sig).serialized;
                displaySignResult(fullSig, signerAddress, 'Raw Keccak256 Hash');
            }
        } catch (e) {
            showToast('Error: ' + e.message, 'error');
        }
    }

    function displaySignResult(signature, signerAddress, method) {
        var sig = ethers.Signature.from(signature);
        var content = $('eth-result-content');
        $('eth-result-title').textContent = 'Signature Result';

        content.innerHTML =
            '<div class="eth-output-row">' +
                '<div class="eth-output-label">Method ' + copyBtnHtml('eth-out-method') + '</div>' +
                '<div class="eth-output-value" id="eth-out-method">' + escapeHtml(method) + '</div>' +
            '</div>' +
            '<div class="eth-output-row">' +
                '<div class="eth-output-label">Signer Address ' + copyBtnHtml('eth-out-addr') + '</div>' +
                '<div class="eth-output-value" id="eth-out-addr" style="color:var(--eth-tool);font-weight:500">' + escapeHtml(signerAddress) + '</div>' +
            '</div>' +
            '<div class="eth-output-row">' +
                '<div class="eth-output-label">Full Signature (130 hex + 0x) ' + copyBtnHtml('eth-out-sig') + '</div>' +
                '<div class="eth-output-value" id="eth-out-sig">' + escapeHtml(signature) + '</div>' +
            '</div>' +
            '<div class="eth-output-row">' +
                '<div class="eth-output-label">r ' + copyBtnHtml('eth-out-r') + '</div>' +
                '<div class="eth-output-value" id="eth-out-r">' + escapeHtml(sig.r) + '</div>' +
            '</div>' +
            '<div class="eth-output-row">' +
                '<div class="eth-output-label">s ' + copyBtnHtml('eth-out-s') + '</div>' +
                '<div class="eth-output-value" id="eth-out-s">' + escapeHtml(sig.s) + '</div>' +
            '</div>' +
            '<div class="eth-output-row">' +
                '<div class="eth-output-label">v (recovery id)</div>' +
                '<div class="eth-output-value">' + sig.v + '</div>' +
            '</div>';

        lastResult = {
            type: 'sign',
            method: method,
            address: signerAddress,
            signature: signature,
            r: sig.r,
            s: sig.s,
            v: sig.v
        };
        showResultActions();
        showToast('Message signed successfully', 'success');
    }

    // --- Verify ---
    function verifySignature() {
        var msg = $('eth-verify-message').value;
        var sig = $('eth-verify-sig').value.trim();
        var expected = $('eth-verify-addr').value.trim();

        if (!msg) { showToast('Please enter the original message', 'error'); return; }
        if (!sig) { showToast('Please enter the signature', 'error'); return; }

        try {
            var recovered = ethers.verifyMessage(msg, sig);
            var sigObj = ethers.Signature.from(sig);
            var content = $('eth-result-content');
            $('eth-result-title').textContent = 'Verification Result';

            var statusHtml;
            if (expected) {
                var match = recovered.toLowerCase() === expected.toLowerCase();
                if (match) {
                    statusHtml = '<div class="eth-status eth-status-valid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Valid &mdash; Address Matches</div>';
                } else {
                    statusHtml = '<div class="eth-status eth-status-mismatch"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Mismatch &mdash; Addresses Differ</div>';
                }
            } else {
                statusHtml = '<div class="eth-status eth-status-valid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Valid Signature</div>';
            }

            content.innerHTML =
                '<div class="eth-output-row">' +
                    '<div class="eth-output-label">Status</div>' +
                    statusHtml +
                '</div>' +
                '<div class="eth-output-row">' +
                    '<div class="eth-output-label">Recovered Signer Address ' + copyBtnHtml('eth-out-recovered') + '</div>' +
                    '<div class="eth-output-value" id="eth-out-recovered" style="color:var(--eth-tool);font-weight:500">' + escapeHtml(recovered) + '</div>' +
                '</div>' +
                (expected ? '<div class="eth-output-row"><div class="eth-output-label">Expected Address</div><div class="eth-output-value">' + escapeHtml(expected) + '</div></div>' : '') +
                '<div class="eth-output-row">' +
                    '<div class="eth-output-label">r ' + copyBtnHtml('eth-out-vr') + '</div>' +
                    '<div class="eth-output-value" id="eth-out-vr">' + escapeHtml(sigObj.r) + '</div>' +
                '</div>' +
                '<div class="eth-output-row">' +
                    '<div class="eth-output-label">s ' + copyBtnHtml('eth-out-vs') + '</div>' +
                    '<div class="eth-output-value" id="eth-out-vs">' + escapeHtml(sigObj.s) + '</div>' +
                '</div>' +
                '<div class="eth-output-row">' +
                    '<div class="eth-output-label">v (recovery id)</div>' +
                    '<div class="eth-output-value">' + sigObj.v + '</div>' +
                '</div>';

            lastResult = {
                type: 'verify',
                recovered: recovered,
                expected: expected || '',
                match: expected ? recovered.toLowerCase() === expected.toLowerCase() : null,
                r: sigObj.r,
                s: sigObj.s,
                v: sigObj.v
            };
            showResultActions();
            showToast(expected ? (recovered.toLowerCase() === expected.toLowerCase() ? 'Signature valid - address matches!' : 'Address mismatch!') : 'Signature verified', expected && recovered.toLowerCase() !== expected.toLowerCase() ? 'error' : 'success');
        } catch (e) {
            $('eth-result-content').innerHTML =
                '<div class="eth-output-row"><div class="eth-output-label">Status</div>' +
                '<div class="eth-status eth-status-invalid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Invalid Signature</div></div>' +
                '<div class="eth-output-row"><div class="eth-output-label">Error</div><div class="eth-output-value" style="color:var(--error)">' + escapeHtml(e.message) + '</div></div>';
            $('eth-result-title').textContent = 'Verification Result';
            showToast('Invalid signature: ' + e.message, 'error');
        }
    }

    // --- FAQ toggle ---
    function toggleFaq(btn) {
        var item = btn.parentElement;
        item.classList.toggle('open');
    }

    // --- Show result action buttons ---
    function showResultActions() {
        $('eth-download-btn').style.display = '';
        $('eth-share-btn').style.display = '';
    }

    // --- Share result via URL ---
    function shareResultUrl() {
        if (!lastResult) { showToast('No result to share', 'error'); return; }
        var shareData = JSON.stringify(lastResult);
        if (window.ToolUtils && ToolUtils.shareResult) {
            ToolUtils.shareResult(shareData, {
                paramName: 'sig',
                toolName: 'Ethereum Message Signing'
            });
        } else {
            // fallback: base64 encode and copy URL
            var encoded = btoa(unescape(encodeURIComponent(shareData)));
            var url = window.location.origin + window.location.pathname + '?sig=' + encoded + '&enc=base64';
            copyText(url, $('eth-share-btn'));
            showToast('Share URL copied to clipboard!', 'success');
        }
    }

    // --- Load shared result from URL ---
    function loadSharedResult() {
        var data = null;
        if (window.ToolUtils && ToolUtils.loadSharedResult) {
            data = ToolUtils.loadSharedResult('sig');
        } else {
            var params = new URLSearchParams(window.location.search);
            var raw = params.get('sig');
            if (!raw) return;
            var enc = params.get('enc');
            if (enc === 'base64') {
                try { data = decodeURIComponent(escape(atob(raw))); } catch(e) { return; }
            } else {
                data = decodeURIComponent(raw);
            }
        }
        if (!data) return;
        try {
            var result = JSON.parse(data);
            lastResult = result;
            if (result.type === 'sign') {
                displaySignResult(result.signature, result.address, result.method);
            } else if (result.type === 'verify') {
                var content = $('eth-result-content');
                $('eth-result-title').textContent = 'Shared Verification Result';
                var statusHtml;
                if (result.expected && result.match !== null) {
                    statusHtml = result.match
                        ? '<div class="eth-status eth-status-valid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Valid &mdash; Address Matches</div>'
                        : '<div class="eth-status eth-status-mismatch"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Mismatch</div>';
                } else {
                    statusHtml = '<div class="eth-status eth-status-valid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Valid Signature</div>';
                }
                content.innerHTML =
                    '<div class="eth-output-row"><div class="eth-output-label">Status</div>' + statusHtml + '</div>' +
                    '<div class="eth-output-row"><div class="eth-output-label">Recovered Address ' + copyBtnHtml('eth-out-recovered') + '</div><div class="eth-output-value" id="eth-out-recovered" style="color:var(--eth-tool);font-weight:500">' + escapeHtml(result.recovered) + '</div></div>' +
                    (result.expected ? '<div class="eth-output-row"><div class="eth-output-label">Expected Address</div><div class="eth-output-value">' + escapeHtml(result.expected) + '</div></div>' : '') +
                    '<div class="eth-output-row"><div class="eth-output-label">r</div><div class="eth-output-value">' + escapeHtml(result.r) + '</div></div>' +
                    '<div class="eth-output-row"><div class="eth-output-label">s</div><div class="eth-output-value">' + escapeHtml(result.s) + '</div></div>' +
                    '<div class="eth-output-row"><div class="eth-output-label">v</div><div class="eth-output-value">' + result.v + '</div></div>';
                showResultActions();
            }
        } catch(e) {
            // invalid shared data, ignore silently
        }
    }

    // --- Copy by element ID ---
    function copyById(id, btn) {
        var el = document.getElementById(id);
        if (el) copyText(el.textContent, btn);
    }

    // --- Download result ---
    function downloadResult() {
        if (!lastResult) { showToast('No result to download', 'error'); return; }
        var lines = [];
        lines.push('Ethereum Signature - ' + (lastResult.type === 'sign' ? 'Sign Result' : 'Verification Result'));
        lines.push('Generated: ' + new Date().toISOString());
        lines.push('Tool: https://8gwifi.org/blockchain-sign.jsp');
        lines.push('');
        if (lastResult.type === 'sign') {
            lines.push('Method:    ' + lastResult.method);
            lines.push('Address:   ' + lastResult.address);
            lines.push('Signature: ' + lastResult.signature);
            lines.push('');
            lines.push('Components:');
            lines.push('  r: ' + lastResult.r);
            lines.push('  s: ' + lastResult.s);
            lines.push('  v: ' + lastResult.v);
        } else {
            lines.push('Recovered Address: ' + lastResult.recovered);
            if (lastResult.expected) {
                lines.push('Expected Address:  ' + lastResult.expected);
                lines.push('Match: ' + (lastResult.match ? 'YES' : 'NO'));
            }
            lines.push('');
            lines.push('Components:');
            lines.push('  r: ' + lastResult.r);
            lines.push('  s: ' + lastResult.s);
            lines.push('  v: ' + lastResult.v);
        }
        var text = lines.join('\n');
        var filename = 'eth-signature-' + lastResult.type + '-' + Date.now() + '.txt';
        if (window.ToolUtils && ToolUtils.downloadAsFile) {
            ToolUtils.downloadAsFile(text, filename, { toolName: 'Ethereum Message Signing' });
        } else {
            // fallback
            var blob = new Blob([text], { type: 'text/plain' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url; a.download = filename; a.click();
            setTimeout(function() { URL.revokeObjectURL(url); }, 100);
            showToast('Downloaded ' + filename, 'success');
        }
    }

    // Auto-load shared result from URL on init
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadSharedResult);
    } else {
        loadSharedResult();
    }

    // Public API
    return {
        switchMode: switchMode,
        generateKeyPair: generateKeyPair,
        deriveAddress: deriveAddress,
        toggleKeyVisibility: toggleKeyVisibility,
        signMessage: signMessage,
        verifySignature: verifySignature,
        downloadResult: downloadResult,
        shareResultUrl: shareResultUrl,
        toggleFaq: toggleFaq,
        copyById: copyById
    };
})();

// Scroll animations
(function(){
    var els = document.querySelectorAll('.eth-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('eth-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('eth-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

</body>
</html>