<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="google-site-verification" content="k5l9OPcSV01yURjfTQ1v1I_6sPq7cSiwdVM76VaJwM8" />
    <title>8gwifi.org - Free Online Tools | 200+ Professional Tools</title>

    <!-- Comprehensive SEO Meta Tags -->
    <meta name="title" content="8gwifi.org - Free Online Tools | 200+ Professional Tools">
    <meta name="description" content="Free online tools for professionals, students, and developers: Cryptography (AES, RSA, PGP encryption), Network tools (DNS, port scanner), DevOps (Kubernetes, Docker), Data Converters (Base64, JSON, YAML), Mathematics calculators, Finance tools (EMI, compound interest), Chemistry tools, and 200+ more. All free, secure, client-side processing. No registration required.">
    <meta name="keywords" content="online tools, free tools, cryptography tools, encryption online, AES encryption, network tools, subnet calculator, DNS lookup, devops tools, kubernetes generator, base64 encoder, json beautifier, math calculator, finance calculator, chemistry tools, EMI calculator, compound interest calculator, free online tools, client-side tools">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index, follow">
    <link rel="canonical" href="https://8gwifi.org">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org">
    <meta property="og:title" content="8gwifi.org - Free Online Tools | 200+ Professional Tools">
    <meta property="og:description" content="Free online tools for professionals, students, and developers: Cryptography, Network diagnostics, DevOps, Data Converters, Mathematics, Finance, Chemistry, and 200+ more. All free, secure, client-side. No registration.">
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org">
    <meta name="twitter:title" content="8gwifi.org - Free Online Tools">
    <meta name="twitter:description" content="200+ free online tools for professionals, students, and developers. Cryptography, Network, DevOps, Mathematics, Finance, Chemistry, and more. All free, secure, client-side.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png">
    <meta name="twitter:site" content="@anish2good">
    <meta name="twitter:creator" content="@anish2good">
    
    <!-- Additional Index Page SEO Schemas -->
    <%@ include file="modern/components/seo-index.jsp" %>

    <!-- Modern Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <!-- Design System -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    
    <!-- Ad System -->
    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- Modern Index Styles -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --gradient-accent: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            color: #0f172a;
            background: #ffffff;
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        /* Hero Section */
        .hero {
            position: relative;
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--gradient-primary);
            color: white;
            padding: 8rem 1.5rem 4rem;
            overflow: hidden;
            margin-top: 72px;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 50%, rgba(255,255,255,0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255,255,255,0.1) 0%, transparent 50%);
            pointer-events: none;
        }

        .hero::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px),
                linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 900px;
            margin: 0 auto;
            text-align: center;
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-title {
            font-size: clamp(2.5rem, 6vw, 4.5rem);
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 1.5rem;
            letter-spacing: -0.02em;
        }

        .hero-subtitle {
            font-size: clamp(1.125rem, 2.5vw, 1.5rem);
            font-weight: 400;
            margin-bottom: 2rem;
            opacity: 0.95;
            line-height: 1.6;
        }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 3rem;
            margin-bottom: 3rem;
            flex-wrap: wrap;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            display: block;
            margin-bottom: 0.25rem;
        }

        .stat-label {
            font-size: 0.875rem;
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .hero-search {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .search-wrapper {
            position: relative;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 0.75rem 1.5rem;
            border: 2px solid rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s ease;
        }

        .search-wrapper:focus-within {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .search-icon {
            font-size: 1.25rem;
            opacity: 0.8;
        }

        .search-input-hero {
            flex: 1;
            background: none;
            border: none;
            color: white;
            font-size: 1rem;
            font-family: inherit;
            outline: none;
        }

        .search-input-hero::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .category-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .category-pill {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            padding: 0.5rem 1.25rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 500;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: white;
            display: inline-block;
        }

        .category-pill:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        /* Tools Section */
        .tools-section {
            padding: 5rem 1.5rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }

        .section-title {
            font-size: clamp(2rem, 4vw, 3rem);
            font-weight: 800;
            margin-bottom: 1rem;
            color: #0f172a;
            letter-spacing: -0.02em;
        }

        .section-subtitle {
            font-size: 1.125rem;
            color: #64748b;
            max-width: 600px;
            margin: 0 auto;
        }

        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2rem;
        }

        .tool-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 1rem;
            padding: 2rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            cursor: default;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
        }

        .tool-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }

        .tool-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border-color: #6366f1;
        }

        .tool-card:hover::before {
            transform: scaleX(1);
        }

        .tool-card-header {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .tool-icon {
            width: 56px;
            height: 56px;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
        }

        .tool-icon::after {
            content: '';
            position: absolute;
            inset: 0;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .tool-card:hover .tool-icon::after {
            opacity: 1;
        }

        .tool-title {
            font-size: 1.375rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #0f172a;
        }

        .tool-description {
            font-size: 0.9375rem;
            color: #64748b;
            line-height: 1.6;
            margin-bottom: 1.5rem;
            flex: 1;
        }

        .tool-links {
            list-style: none;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .tool-link {
            font-size: 0.875rem;
            color: #475569;
            text-decoration: none;
            padding: 0.5rem 0.75rem;
            border-radius: 0.5rem;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .tool-link:hover {
            background: #f1f5f9;
            color: #6366f1;
            transform: translateX(4px);
        }

        .tool-link::before {
            content: '→';
            opacity: 0;
            transition: opacity 0.2s;
        }

        .tool-link:hover::before {
            opacity: 1;
        }

        .tool-more-btn {
            margin-top: auto;
            padding: 0.75rem 1.5rem;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            color: #475569;
            font-weight: 500;
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            font-family: inherit;
            width: 100%;
            position: relative;
            z-index: 10;
        }

        .tool-more-btn:hover {
            background: #6366f1;
            color: white;
            border-color: #6366f1;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(99, 102, 241, 0.3);
        }

        .tool-more-content {
            display: none;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e2e8f0;
        }

        .tool-more-content.show {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Icon Gradients */
        .icon-crypto {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .icon-pki {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .icon-security {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .icon-network {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .icon-sharing {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }
        .icon-devops {
            background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
            color: white;
        }
        .icon-blockchain {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            color: #1e293b;
        }
        .icon-encoder {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            color: #1e293b;
        }
        .icon-misc {
            background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%);
            color: #1e293b;
        }
        .icon-finance {
            background: linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%);
            color: white;
        }
        .icon-chemistry {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: white;
        }
        .icon-education {
            background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
            color: white;
        }

        /* Footer */
        .page-footer {
            background: #0f172a;
            color: white;
            padding: 3rem 1.5rem;
            text-align: center;
            margin-top: 5rem;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-text {
            font-size: 0.9375rem;
            opacity: 0.8;
            margin-bottom: 1rem;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            gap: 2rem;
            flex-wrap: wrap;
            margin-top: 1.5rem;
        }

        .footer-link {
            color: white;
            text-decoration: none;
            opacity: 0.7;
            transition: opacity 0.2s;
            font-size: 0.875rem;
        }

        .footer-link:hover {
            opacity: 1;
        }

        /* Responsive */
        @media (max-width: 991px) {
            .hero {
                min-height: 70vh;
                padding: 6rem 1rem 3rem;
                margin-top: 64px;
            }

            .hero-stats {
                gap: 2rem;
            }

            .tools-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .tools-section {
                padding: 3rem 1rem;
            }

            .tool-links {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .hero-stats {
                gap: 1.5rem;
            }

            .stat-number {
                font-size: 1.5rem;
            }
        }

        /* Enhanced Animations */
        .fade-in {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }

        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }

        /* Stagger animation for cards */
        .tool-card:nth-child(1) { transition-delay: 0.1s; }
        .tool-card:nth-child(2) { transition-delay: 0.2s; }
        .tool-card:nth-child(3) { transition-delay: 0.3s; }
        .tool-card:nth-child(4) { transition-delay: 0.4s; }
        .tool-card:nth-child(5) { transition-delay: 0.5s; }
        .tool-card:nth-child(6) { transition-delay: 0.6s; }
        .tool-card:nth-child(7) { transition-delay: 0.7s; }
        .tool-card:nth-child(8) { transition-delay: 0.8s; }
        .tool-card:nth-child(9) { transition-delay: 0.9s; }

        /* Pulse animation for search */
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        .search-wrapper:focus-within .search-icon {
            animation: pulse 2s ease-in-out infinite;
        }

        /* Floating animation */
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .hero-content {
            animation: fadeInUp 0.8s ease-out, float 6s ease-in-out infinite;
            animation-delay: 0s, 1s;
        }

        /* Gradient animation */
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .hero {
            background-size: 200% 200%;
            animation: gradientShift 15s ease infinite;
        }
    </style>

    <!-- Analytics -->
    <%@ include file="modern/components/analytics.jsp" %>
    
    <%@ include file="header-script.jsp"%>
</head>

<body>
    <!-- Modern Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1 class="hero-title">Free Online Tools</h1>
            <p class="hero-subtitle">Professional-grade tools for cryptography, networking, DevOps, mathematics, finance, chemistry, and more. All free, all online, no registration.</p>
            
            <div class="hero-stats">
                <div class="stat-item">
                    <span class="stat-number">200+</span>
                    <span class="stat-label">Tools</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">60+</span>
                    <span class="stat-label">Categories</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">100%</span>
                    <span class="stat-label">Free</span>
                </div>
            </div>

            <div class="hero-search">
                <div class="search-wrapper">
                    <span class="search-icon">🔍</span>
                    <input type="search" 
                           class="search-input-hero" 
                           placeholder="Search tools, categories, keywords..."
                           id="heroSearch">
                </div>
            </div>

            <div class="category-pills">
                <a href="#tools" class="category-pill">Security & PKI</a>
                <a href="#tools" class="category-pill">PGP</a>
                <a href="#tools" class="category-pill">DevOps</a>
                <a href="#tools" class="category-pill">Cryptography</a>
                <a href="#tools" class="category-pill">Mathematics</a>
                <a href="#tools" class="category-pill">Chemistry</a>
                <a href="#tools" class="category-pill">Finance</a>
            </div>
        </div>
    </section>

    <!-- In-Content Ad -->
    <%@ include file="modern/ads/ad-in-content-top.jsp" %>

    <!-- Tools Section -->
    <section class="tools-section" id="tools">
        <div class="section-header fade-in">
            <h2 class="section-title">Explore Tools</h2>
            <p class="section-subtitle">Browse our collection of free, professional tools organized by category</p>
        </div>

        <div class="tools-grid">
            <!-- Security & PKI (First - Most Demanding) -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-security">🛡️</div>
                    <div>
                        <h3 class="tool-title">Security & PKI</h3>
                    </div>
                </div>
                <p class="tool-description">SSL/TLS scanners, certificate management, JWT/JWS tools, keystores, and comprehensive security utilities.</p>
                <ul class="tool-links">
                    <li><a href="sslscan.jsp" class="tool-link">SSL/TLS Scanner</a></li>
                    <li><a href="SelfSignCertificateFunctions.jsp" class="tool-link">Self Sign Cert</a></li>
                    <li><a href="cafunctions.jsp" class="tool-link">CA Generator</a></li>
                    <li><a href="JKSManagementFunctionality?invalidate=yes" class="tool-link">Keystore Viewer</a></li>
                    <li><a href="jwkfunctions.jsp" class="tool-link">JWK Generate</a></li>
                    <li><a href="PemParserFunctions.jsp" class="tool-link">PEM Parser</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'securityMore')">View All →</button>
                <div id="securityMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="ocsp.jsp" class="tool-link">OCSP Query</a></li>
                        <li><a href="jws-sign-verify.jsp" class="tool-link">JWS Sign/Verify</a></li>
                        <li><a href="saml-decoder.jsp" class="tool-link">SAML Decoder</a></li>
                        <li><a href="certsverify.jsp" class="tool-link">Verify Certificates</a></li>
                    </ul>
                </div>
            </div>

            <!-- PGP (Second - Most Demanding) -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-pki">🔑</div>
                    <div>
                        <h3 class="tool-title">PGP</h3>
                    </div>
                </div>
                <p class="tool-description">PGP encryption, decryption, key generation, signing, verification, and comprehensive PGP utilities.</p>
                <ul class="tool-links">
                    <li><a href="pgpencdec.jsp" class="tool-link">PGP Encrypt/Decrypt</a></li>
                    <li><a href="pgpkeyfunction.jsp" class="tool-link">PGP Key Generation</a></li>
                    <li><a href="pgpdump.jsp" class="tool-link">PGP KeyDumper</a></li>
                    <li><a href="PGPFunctionality?invalidate=yes" class="tool-link">PGP Signature</a></li>
                    <li><a href="pgp-file-decrypt.jsp" class="tool-link">PGP File Decrypt</a></li>
                    <li><a href="pgp-suite.jsp" class="tool-link">PGP Suite</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'pgpMore')">View All →</button>
                <div id="pgpMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="sshfunctions.jsp" class="tool-link">SSH Key Generator</a></li>
                        <li><a href="pgp-upload.jsp" class="tool-link">PGP File Transfer</a></li>
                    </ul>
                </div>
            </div>

            <!-- DevOps (Third - Most Demanding) -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-devops">🐳</div>
                    <div>
                        <h3 class="tool-title">DevOps & Container</h3>
                    </div>
                </div>
                <p class="tool-description">Kubernetes generators, Docker Compose builders, Ansible playbooks, and infrastructure automation.</p>
                <ul class="tool-links">
                    <li><a href="kube.jsp" class="tool-link">Kubernetes Generator</a></li>
                    <li><a href="dc.jsp" class="tool-link">Docker Compose</a></li>
                    <li><a href="kube1.jsp" class="tool-link">Docker → K8s</a></li>
                    <li><a href="aws.jsp" class="tool-link">Ansible Generator</a></li>
                    <li><a href="dockerfile-generator.jsp" class="tool-link">Dockerfile Gen</a></li>
                    <li><a href="nginx-config-generator.jsp" class="tool-link">Nginx Config</a></li>
                </ul>
            </div>

            <!-- Cryptography -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-crypto">🔒</div>
                    <div>
                        <h3 class="tool-title">Cryptography</h3>
                    </div>
                </div>
                <p class="tool-description">Encrypt, decrypt, hash, and sign data using industry-standard algorithms like AES, RSA, PGP, and more.</p>
                <ul class="tool-links">
                    <li><a href="CipherFunctions.jsp" class="tool-link">Encryption/Decryption</a></li>
                    <li><a href="MessageDigest.jsp" class="tool-link">Message Digest</a></li>
                    <li><a href="rsafunctions.jsp" class="tool-link">RSA Encryption</a></li>
                    <li><a href="hmacgen.jsp" class="tool-link">HMAC Generator</a></li>
                    <li><a href="bccrypt.jsp" class="tool-link">BCrypt Hash</a></li>
                    <li><a href="scrypt.jsp" class="tool-link">SCrypt Hash</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'cryptoMore')">View All →</button>
                <div id="cryptoMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="file-encrypt.jsp" class="tool-link">File Encryption</a></li>
                        <li><a href="ecfunctions.jsp" class="tool-link">EC Encryption</a></li>
                        <li><a href="passwdgen.jsp" class="tool-link">Password Generator</a></li>
                        <li><a href="pbkdf.jsp" class="tool-link">PBKDF2</a></li>
                    </ul>
                </div>
            </div>


            <!-- Network Tools -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-network">🌐</div>
                    <div>
                        <h3 class="tool-title">Network Tools</h3>
                    </div>
                </div>
                <p class="tool-description">DNS lookup, IP tools, port scanning, subnet calculators, and comprehensive network diagnostics.</p>
                <ul class="tool-links">
                    <li><a href="SubnetFunctions.jsp" class="tool-link">Subnet Calculator</a></li>
                    <li><a href="dns.jsp" class="tool-link">DNS Lookup</a></li>
                    <li><a href="pingfunctions.jsp" class="tool-link">Ping/Locate IP</a></li>
                    <li><a href="whois.jsp" class="tool-link">Whois Lookup</a></li>
                    <li><a href="portscan.jsp" class="tool-link">Port Scanner</a></li>
                    <li><a href="sslscan.jsp" class="tool-link">SSL Scanner</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'netMore')">View All →</button>
                <div id="netMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="subdomain.jsp" class="tool-link">Subdomain Finder</a></li>
                        <li><a href="revdns.jsp" class="tool-link">Reverse DNS</a></li>
                        <li><a href="screenshot.jsp" class="tool-link">Screenshot</a></li>
                        <li><a href="websocket-client.jsp" class="tool-link">WebSocket Client</a></li>
                    </ul>
                </div>
            </div>

            <!-- Secure Sharing -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-sharing">📁</div>
                    <div>
                        <h3 class="tool-title">Secure Sharing</h3>
                    </div>
                </div>
                <p class="tool-description">Share files and messages securely with encryption, password protection, and temporary links.</p>
                <ul class="tool-links">
                    <li><a href="pgp-upload.jsp" class="tool-link">PGP File Transfer</a></li>
                    <li><a href="share-file.jsp" class="tool-link">Secure File Share</a></li>
                    <li><a href="securebin.jsp" class="tool-link">Secret Content</a></li>
                    <li><a href="pastebin.jsp" class="tool-link">TextBin</a></li>
                    <li><a href="temp-email.jsp" class="tool-link">Temp Email</a></li>
                    <li><a href="short.jsp" class="tool-link">URL Shortener</a></li>
                </ul>
            </div>

            <!-- Blockchain -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-blockchain">⛓️</div>
                    <div>
                        <h3 class="tool-title">Blockchain</h3>
                    </div>
                </div>
                <p class="tool-description">Cryptocurrency and blockchain development tools for Ethereum, HD wallets, and key generation.</p>
                <ul class="tool-links">
                    <li><a href="eth-keygen.jsp" class="tool-link">Ethereum Keys</a></li>
                    <li><a href="hdwallet.jsp" class="tool-link">HD Wallet</a></li>
                    <li><a href="bip39-mnemonic.jsp" class="tool-link">BIP39 Mnemonic</a></li>
                    <li><a href="crypto-profit-calculator.jsp" class="tool-link">Profit Calc</a></li>
                </ul>
            </div>

            <!-- Encoders -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-encoder">🔄</div>
                    <div>
                        <h3 class="tool-title">Encoders & Converters</h3>
                    </div>
                </div>
                <p class="tool-description">Convert between formats: Base64, Hex, JSON, YAML, XML, CSV, URL encoding, and more.</p>
                <ul class="tool-links">
                    <li><a href="Base64Functions.jsp" class="tool-link">Base64</a></li>
                    <li><a href="UrlEncodeDecodeFunctions.jsp" class="tool-link">URL Encode</a></li>
                    <li><a href="HexToStringFunctions.jsp" class="tool-link">Hex/String</a></li>
                    <li><a href="jsonparser.jsp" class="tool-link">JSON Tools</a></li>
                    <li><a href="xml2json.jsp" class="tool-link">XML Tools</a></li>
                    <li><a href="yamlparser.jsp" class="tool-link">YAML Tools</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'encodersMore')">View All →</button>
                <div id="encodersMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="json-2-csv.jsp" class="tool-link">JSON → CSV</a></li>
                        <li><a href="csv-2-json.jsp" class="tool-link">CSV → JSON</a></li>
                        <li><a href="base64image.jsp" class="tool-link">Base64 Image</a></li>
                    </ul>
                </div>
            </div>

            <!-- Miscellaneous -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-misc">🛠️</div>
                    <div>
                        <h3 class="tool-title">Utilities</h3>
                    </div>
                </div>
                <p class="tool-description">PDF tools, QR codes, hex editor, text comparison, URL shortener, and utility tools.</p>
                <ul class="tool-links">
                    <li><a href="merge-pdf.jsp" class="tool-link">Merge PDF</a></li>
                    <li><a href="watermark-pdf.jsp" class="tool-link">PDF Watermark</a></li>
                    <li><a href="qrcodegen.jsp" class="tool-link">QR Generator</a></li>
                    <li><a href="hexeditor.jsp" class="tool-link">Hex Editor</a></li>
                    <li><a href="diff.jsp" class="tool-link">Text Diff</a></li>
                    <li><a href="onecompiler.jsp" class="tool-link">Online Compiler</a></li>
                </ul>
            </div>

            <!-- Finance -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-finance">💰</div>
                    <div>
                        <h3 class="tool-title">Finance</h3>
                    </div>
                </div>
                <p class="tool-description">EMI calculators, compound interest, stock profit calculations, and financial planning tools.</p>
                <ul class="tool-links">
                    <li><a href="emi.jsp" class="tool-link">EMI Calculator</a></li>
                    <li><a href="cinterest2.jsp" class="tool-link">Compound Interest</a></li>
                    <li><a href="stock-calc.jsp" class="tool-link">Stock Profit</a></li>
                    <li><a href="sip-calculator.jsp" class="tool-link">SIP Calculator</a></li>
                </ul>
            </div>

            <!-- Chemistry -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-chemistry">🧪</div>
                    <div>
                        <h3 class="tool-title">Chemistry</h3>
                    </div>
                </div>
                <p class="tool-description">Periodic table, molecular geometry, equation balancer, stoichiometry, thermochemistry, and electrochemistry tools.</p>
                <ul class="tool-links">
                    <li><a href="chemistry/index.jsp" class="tool-link">All Chemistry Tools</a></li>
                    <li><a href="periodic-table.jsp" class="tool-link">Periodic Table</a></li>
                    <li><a href="chemical-equation-balancer.jsp" class="tool-link">Equation Balancer</a></li>
                    <li><a href="molecular-geometry-calculator.jsp" class="tool-link">Molecular Geometry</a></li>
                    <li><a href="lewis-structure-generator.jsp" class="tool-link">Lewis Structures</a></li>
                    <li><a href="stoichiometry-calculator.jsp" class="tool-link">Stoichiometry</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'chemMore')">View All →</button>
                <div id="chemMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="electron-configuration-calculator.jsp" class="tool-link">Electron Config</a></li>
                        <li><a href="electronegativity-polarity-checker.jsp" class="tool-link">Electronegativity</a></li>
                        <li><a href="molar-mass-calculator.jsp" class="tool-link">Molar Mass</a></li>
                        <li><a href="molarity-dilution-calculator.jsp" class="tool-link">Molarity & Dilution</a></li>
                        <li><a href="thermochemistry-calculator.jsp" class="tool-link">Thermochemistry</a></li>
                        <li><a href="electrochemistry-calculator.jsp" class="tool-link">Electrochemistry</a></li>
                    </ul>
                </div>
            </div>

            <!-- Education & Science -->
            <div class="tool-card fade-in">
                <div class="tool-card-header">
                    <div class="tool-icon icon-education">📚</div>
                    <div>
                        <h3 class="tool-title">Education & Science</h3>
                    </div>
                </div>
                <p class="tool-description">NCERT solutions, physics simulators, chemistry tools, and math calculators for students.</p>
                <ul class="tool-links">
                    <li><a href="exams/books/ncert/index.jsp" class="tool-link">NCERT Solutions</a></li>
                    <li><a href="math/index.jsp" class="tool-link">Math Tools</a></li>
                    <li><a href="physics/index.jsp" class="tool-link">Physics Tools</a></li>
                    <li><a href="exams/books/ncert/class-12/mathematics-part-1/index.jsp" class="tool-link">Class 12 Maths</a></li>
                    <li><a href="exams/books/ncert/class-11/physics-part-1/index.jsp" class="tool-link">Class 11 Physics</a></li>
                    <li><a href="exams/books/ncert/class-10/mathematics/index.jsp" class="tool-link">Class 10 Maths</a></li>
                </ul>
                <button class="tool-more-btn" onclick="toggleToolMore(event, this, 'educationMore')">View All →</button>
                <div id="educationMore" class="tool-more-content">
                    <ul class="tool-links">
                        <li><a href="exams/books/ncert/class-12/physics-part-1/index.jsp" class="tool-link">Class 12 Physics</a></li>
                        <li><a href="exams/books/ncert/class-11/mathematics/index.jsp" class="tool-link">Class 11 Maths</a></li>
                        <li><a href="exams/books/ncert/class-9/mathematics/index.jsp" class="tool-link">Class 9 Maths</a></li>
                        <li><a href="lewis-structure-generator.jsp" class="tool-link">Lewis Structure</a></li>
                        <li><a href="integral-calculator.jsp" class="tool-link">Integral Calculator</a></li>
                        <li><a href="inclined-plane-calculator.jsp" class="tool-link">Inclined Plane</a></li>
                        <li><a href="projectile-motion-simulator.jsp" class="tool-link">Projectile Motion</a></li>
                        <li><a href="molecular-geometry-calculator.jsp" class="tool-link">Molecular Geometry</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- In-Content Ad -->
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">© 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="exams/books/ncert/index.jsp" class="footer-link">NCERT Solutions</a>
                <a href="tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
                <a href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener" class="footer-link">Support</a>
            </div>
        </div>
    </footer>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>

    <!-- Floating Right Ad (Desktop Only) -->
    <%@ include file="modern/ads/ad-floating-right.jsp" %>

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=2.1"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script>
        // Tool more toggle with animation
        function toggleToolMore(event, button, id) {
            // Prevent event bubbling to parent card
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }
            
            const content = document.getElementById(id);
            if (!content) {
                console.warn('Content element not found:', id);
                return;
            }
            
            const isOpen = content.classList.contains('show');
            
            if (isOpen) {
                content.classList.remove('show');
                button.textContent = 'View All →';
                button.style.transform = 'rotate(0deg)';
            } else {
                content.classList.add('show');
                button.textContent = 'Hide →';
                button.style.transform = 'rotate(180deg)';
            }
        }

        // Enhanced scroll animations with stagger
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    // Add bounce effect
                    entry.target.style.animation = 'fadeInUp 0.6s ease-out';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.fade-in').forEach((el, index) => {
            observer.observe(el);
            el.style.transitionDelay = `${index * 0.1}s`;
        });

        // Smooth scroll for category pills with bounce
        document.querySelectorAll('.category-pill').forEach(pill => {
            pill.addEventListener('click', (e) => {
                e.preventDefault();
                document.getElementById('tools').scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
                
                // Add bounce animation to target
                setTimeout(() => {
                    const toolsSection = document.getElementById('tools');
                    toolsSection.style.animation = 'fadeInUp 0.6s ease-out';
                    setTimeout(() => {
                        toolsSection.style.animation = '';
                    }, 600);
                }, 300);
            });
        });

        // Card hover enhancements
        document.querySelectorAll('.tool-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Stats counter animation
        function animateValue(element, start, end, duration) {
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                element.textContent = Math.floor(progress * (end - start) + start) + (element.textContent.includes('%') ? '%' : '+');
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }

        // Animate stats when hero is visible
        const statsObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const stats = entry.target.querySelectorAll('.stat-number');
                    stats.forEach(stat => {
                        const text = stat.textContent;
                        const number = parseInt(text);
                        if (!isNaN(number)) {
                            animateValue(stat, 0, number, 1500);
                        }
                    });
                    statsObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.5 });

        const heroStats = document.querySelector('.hero-stats');
        if (heroStats) {
            statsObserver.observe(heroStats);
        }

        // Parallax effect for hero
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const hero = document.querySelector('.hero');
            if (hero && scrolled < hero.offsetHeight) {
                hero.style.transform = `translateY(${scrolled * 0.5}px)`;
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            // Ctrl/Cmd + K for search
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                const searchInput = document.querySelector('.search-input-hero, .search-input');
                if (searchInput) {
                    searchInput.focus();
                    searchInput.select();
                }
            }
            
            // Esc to close search
            if (e.key === 'Escape') {
                const searchResults = document.getElementById('searchResults');
                if (searchResults && searchResults.classList.contains('show')) {
                    searchResults.classList.remove('show');
                }
            }
        });
    </script>

</body>
</html>
