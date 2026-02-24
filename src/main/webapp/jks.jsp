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

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        *:focus-visible{outline:2px solid var(--primary);outline-offset:2px}
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}

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
            --tool-primary:#2563eb;--tool-primary-dark:#1d4ed8;--tool-gradient:linear-gradient(135deg,#2563eb 0%,#1d4ed8 100%);--tool-light:#eff6ff
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(37,99,235,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}

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

        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}

        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}

        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{min-width:0;display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{min-width:0;display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}

        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-input{width:100%;padding:0.5rem 0.75rem;border:1px solid var(--border,#e2e8f0);border-radius:0.375rem;font-size:0.875rem;background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);font-family:var(--font-sans,inherit)}
        .tool-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(37,99,235,0.1)}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:0.75rem;transition:opacity .15s,transform .15s;font-family:var(--font-sans,inherit)}
        .tool-action-btn:hover{opacity:0.9}

        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}

        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary,#cbd5e1)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(37,99,235,0.3)}
        [data-theme="dark"] .tool-input{background:var(--bg-tertiary,#334155);border-color:var(--border,#475569);color:var(--text-primary,#f1f5f9)}

        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}

        /* Educational sections */
        .jks-educational{max-width:1600px;margin:0 auto;padding:0 1.5rem}
        .jks-section{margin-bottom:2.5rem}
        .jks-section h2{font-size:1.25rem;font-weight:700;color:var(--text-primary,#0f172a);margin-bottom:1rem}
    </style>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS framework (async, critical styles inlined above) -->
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

    <!-- Tool-specific CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/jks.css?v=<%=cacheVersion%>">

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="JKS Viewer &amp; KeyStore Manager Online - Free" />
        <jsp:param name="toolDescription" value="View, create, and manage JKS, PKCS12, JCEKS keystores online. Generate key pairs, validate chains, security audit, expiry dashboard. No install needed." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="jks.jsp" />
        <jsp:param name="toolKeywords" value="jks viewer online, keystore viewer, java keystore viewer, pkcs12 viewer, p12 viewer online, pfx viewer, jceks viewer, keytool online, keystore manager online, create keystore online, generate key pair online, certificate chain viewer, ssl certificate viewer, certificate expiry checker, export jks to pem, truststore viewer, keystore security audit, validate key pair, order certificate chain, import pem certificate" />
        <jsp:param name="toolImage" value="images/jks-tool-icon.svg" />
        <jsp:param name="toolFeatures" value="View JKS PKCS12 JCEKS keystores,Create new JKS/PKCS12/JCEKS keystores,Generate RSA/EC/DSA key pairs,Validate key pair integrity,Order certificate chains,Export certificates to PEM/DER/Base64,Import PEM certificates,Fetch remote SSL certificates,Certificate health dashboard with expiry timeline,Security audit detecting weak keys and SHA-1,Rename duplicate and delete aliases,Download modified keystores" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Upload or Create KeyStore|Upload a JKS PKCS12 or JCEKS file with password or create a new empty keystore from the Create New tab,Browse Aliases and Health Dashboard|View all certificate and key entries with color-coded health status showing valid expiring and expired counts plus expiry timeline,Inspect Certificate Details|Click any alias to view full details including subject issuer validity key algorithm extensions fingerprints and security analysis,Manage Entries|Generate new RSA EC or DSA key pairs and import PEM certificates. Validate key pairs and order certificate chains for correct TLS handshake order,Export and Download|Export individual certificates as PEM or DER and download the complete modified keystore file" />
        <jsp:param name="faq1q" value="What is a Java KeyStore (JKS) file?" />
        <jsp:param name="faq1a" value="A Java KeyStore (JKS) is a password-protected file that stores cryptographic keys and X.509 certificates for SSL/TLS. It holds private keys, public key certificates, and trusted CA certificates. Since Java 9, the default keystore type changed from JKS to PKCS12 for stronger encryption." />
        <jsp:param name="faq2q" value="What is the difference between JKS, PKCS12, and JCEKS formats?" />
        <jsp:param name="faq2a" value="JKS is Java-proprietary with weaker encryption. PKCS12 (.p12, .pfx) is the cross-platform industry standard with strong encryption, recommended for all new projects. JCEKS offers stronger encryption than JKS but remains Java-proprietary. This tool supports viewing, creating, and managing all three formats." />
        <jsp:param name="faq3q" value="Can I create a new keystore and generate key pairs online?" />
        <jsp:param name="faq3a" value="Yes. Use the Create New tab to create an empty JKS, PKCS12, or JCEKS keystore, then click Generate Key Pair to add RSA (2048-4096 bit), EC (P-256/384/521), or DSA key pairs with self-signed certificates. Set alias, Common Name, and validity period — all in your browser." />
        <jsp:param name="faq4q" value="How do I check certificate expiry dates in a keystore?" />
        <jsp:param name="faq4a" value="Upload your keystore to see the health dashboard showing valid, expiring (within 30 days), and expired certificate counts. The visual expiry timeline displays each certificate as a color-coded bar. Click any alias for exact Not Before and Not After dates." />
        <jsp:param name="faq5q" value="How do I fetch and inspect SSL certificates from a website?" />
        <jsp:param name="faq5a" value="Switch to the Fetch URL tab, enter any hostname (e.g. google.com), and click Fetch. The tool retrieves the full certificate chain showing subject, issuer, validity, and fingerprints. You can copy the PEM, parse full details, or add certificates directly to your keystore." />
        <jsp:param name="faq6q" value="Is it safe to upload my keystore file?" />
        <jsp:param name="faq6a" value="Your keystore is uploaded over HTTPS for server-side parsing and is not stored permanently. No keystore data is persisted after your session. For production keystores containing sensitive private keys, consider using offline tools like keytool or KeyStore Explorer." />
        <jsp:param name="faq7q" value="How do I validate a key pair and order the certificate chain?" />
        <jsp:param name="faq7a" value="Select a key entry alias and click Validate Key Pair to verify the private key matches its certificate. For certificate chains, click Order Chain to automatically arrange certificates from end-entity to root CA in the correct order for TLS handshakes." />
        <jsp:param name="faq8q" value="How do I convert JKS to PKCS12?" />
        <jsp:param name="faq8a" value="Use keytool: keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.p12 -deststoretype PKCS12. You will be prompted for source and destination passwords. Alternatively, upload your JKS file here, then export individual certificates as PEM or DER for import into any format." />
    </jsp:include>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">JKS Viewer &amp; KeyStore Manager Online</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#developer-tools">Developer Tools</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    KeyStore Manager
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">JKS</span>
                <span class="tool-badge">PKCS12</span>
                <span class="tool-badge">JCEKS</span>
                <span class="tool-badge">Generate Keys</span>
                <span class="tool-badge">Security Audit</span>
                <span class="tool-badge">Free</span>
            </div>
        </div>
    </header>

    <!-- Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>View, create, and manage Java KeyStore files online. Upload JKS, PKCS12, or JCEKS files to inspect certificates, run security audits, and track expiry dates with a visual timeline. Create new keystores, generate RSA/EC/DSA key pairs, fetch remote SSL certificates, validate key pairs, and order certificate chains &mdash; all from your browser.</p>
            </div>
        </div>
    </section>

    <!-- Toast Container -->
    <div id="jksToastContainer" class="jks-toast-container"></div>

    <!-- ==================== MAIN THREE-COLUMN LAYOUT ==================== -->
    <main class="tool-page-container jks-page">

        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    KeyStore Manager
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="jks-mode-toggle" id="jksModeToggle">
                        <button class="jks-mode-btn active" data-mode="upload">
                            <span class="jks-mode-label">Upload</span>
                            <span class="jks-mode-desc">Open existing file</span>
                        </button>
                        <button class="jks-mode-btn" data-mode="fetch">
                            <span class="jks-mode-label">Fetch URL</span>
                            <span class="jks-mode-desc">Inspect SSL certs</span>
                        </button>
                        <button class="jks-mode-btn" data-mode="create">
                            <span class="jks-mode-label">Create New</span>
                            <span class="jks-mode-desc">Start from scratch</span>
                        </button>
                    </div>

                    <!-- Upload Mode (default) -->
                    <div id="modeUpload" class="jks-mode-content">
                        <div class="jks-dropzone" id="jksDropzone">
                            <div class="jks-dropzone-icon">&#128274;</div>
                            <div class="jks-dropzone-text">Drop keystore file here or click to browse</div>
                            <div class="jks-dropzone-hint">.jks, .p12, .pfx, .keystore, .jceks</div>
                            <input type="file" id="jksFileInput" accept=".jks,.p12,.pfx,.keystore,.jceks">
                        </div>
                        <div id="jksDetectedType"></div>

                        <div class="tool-form-group" style="margin-top:0.75rem">
                            <label class="tool-form-label" for="jksPassword">Keystore Password</label>
                            <input type="password" class="tool-input" id="jksPassword" placeholder="Enter password">
                        </div>
                        <button class="tool-action-btn" id="jksUploadBtn">Upload &amp; Analyze</button>
                    </div>

                    <!-- Fetch URL Mode -->
                    <div id="modeFetch" class="jks-mode-content" style="display:none">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="jksRemoteUrl">URL or Hostname</label>
                            <input type="text" class="tool-input" id="jksRemoteUrl" placeholder="https://example.com or example.com:443">
                            <div class="tool-form-hint">Fetches the SSL certificate chain from the remote server</div>
                        </div>
                        <button class="tool-action-btn" id="jksFetchBtn">Fetch Certificates</button>
                    </div>

                    <!-- Create New Mode -->
                    <div id="modeCreate" class="jks-mode-content" style="display:none">
                        <div class="tool-form-group">
                            <label class="tool-form-label">Keystore Type</label>
                            <div class="jks-alg-toggle" id="jksCreateTypeToggle">
                                <button class="jks-alg-btn active" data-type="JKS">JKS</button>
                                <button class="jks-alg-btn" data-type="PKCS12">PKCS12</button>
                                <button class="jks-alg-btn" data-type="JCEKS">JCEKS</button>
                            </div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="jksCreatePassword">Password</label>
                            <input type="password" class="tool-input" id="jksCreatePassword" placeholder="Enter password for new keystore">
                        </div>
                        <button class="tool-action-btn" id="jksCreateBtn">Create Empty Keystore</button>
                    </div>

                    <!-- Keystore Info Bar (shown after load) -->
                    <div class="jks-keystore-info" id="jksKeystoreInfo">
                        <span class="jks-info-name" id="jksInfoName">-</span>
                        <span class="jks-info-badge" id="jksInfoType">JKS</span>
                        <span class="jks-info-badge" style="background:var(--jks-valid)"><span id="jksInfoCount">0</span> entries</span>
                        <button class="jks-info-change" id="jksChangeInputBtn" title="Load a different keystore">Change</button>
                        <button class="jks-info-clear" id="jksClearBtn" title="Clear keystore">&times;</button>
                    </div>

                    <!-- Prominent Download Bar (shown after load) -->
                    <div class="jks-download-bar" id="jksDownloadBar">
                        <button class="jks-download-btn-large" id="jksDownloadBtn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                <polyline points="7 10 12 15 17 10"/>
                                <line x1="12" y1="15" x2="12" y2="3"/>
                            </svg>
                            Download Keystore
                        </button>
                    </div>
                </div>
            </div>

            <!-- Alias List Card (shown after load) -->
            <div class="jks-alias-card" id="jksAliasCard">
                <div class="tool-card">
                    <div class="tool-card-body">
                        <div class="jks-alias-header">
                            <h4>Aliases <span class="jks-alias-count" id="jksAliasCount">0</span></h4>
                            <div style="display:flex;gap:0.375rem">
                                <button class="jks-gen-btn" id="jksGenKeyPairBtn">+ Generate</button>
                                <button class="jks-gen-btn" id="jksImportCertBtn">Import PEM</button>
                                <button class="jks-gen-btn" id="jksExportKsBtn">Export</button>
                            </div>
                        </div>
                        <div class="jks-alias-search">
                            <input type="text" id="jksAliasSearch" placeholder="Search aliases...">
                        </div>
                        <div class="jks-alias-list" id="jksAliasList">
                            <!-- Rendered by JS -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Health Dashboard -->
            <div class="jks-health" id="jksHealth">
                <div class="jks-health-grid">
                    <div class="jks-health-card jks-health-valid">
                        <div class="count" id="jksHealthValid">0</div>
                        <div class="label">Valid</div>
                    </div>
                    <div class="jks-health-card jks-health-expiring">
                        <div class="count" id="jksHealthExpiring">0</div>
                        <div class="label">Expiring</div>
                    </div>
                    <div class="jks-health-card jks-health-expired">
                        <div class="count" id="jksHealthExpired">0</div>
                        <div class="label">Expired</div>
                    </div>
                    <div class="jks-health-card jks-health-weak">
                        <div class="count" id="jksHealthWeak">0</div>
                        <div class="label">Security</div>
                    </div>
                </div>
                <div class="jks-timeline">
                    <div class="jks-timeline-title">Certificate Expiry Timeline</div>
                    <div class="jks-timeline-bar" id="jksTimelineBar"></div>
                    <div class="jks-timeline-legend">
                        <span><span class="jks-timeline-dot" style="background:#10b981"></span> Valid</span>
                        <span><span class="jks-timeline-dot" style="background:#f59e0b"></span> Expiring (&lt;30d)</span>
                        <span><span class="jks-timeline-dot" style="background:#ef4444"></span> Expired</span>
                    </div>
                </div>
            </div>

            <!-- Onboarding / Empty State -->
            <div id="jksOnboarding" class="jks-onboarding">
                <div class="jks-onboarding-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;opacity:0.4">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                </div>
                <h3>Java KeyStore Manager</h3>
                <p class="jks-onboarding-subtitle">View, create, and manage keystores with security analysis</p>

                <div class="jks-onboarding-cards">
                    <div class="jks-onboarding-card" data-switch-mode="upload">
                        <div class="jks-onboarding-card-icon">&#128194;</div>
                        <div class="jks-onboarding-card-title">Upload Keystore</div>
                        <div class="jks-onboarding-card-desc">Open an existing .jks, .p12, or .pfx file to view and manage certificates</div>
                    </div>
                    <div class="jks-onboarding-card" data-switch-mode="fetch">
                        <div class="jks-onboarding-card-icon">&#127760;</div>
                        <div class="jks-onboarding-card-title">Fetch SSL Certificate</div>
                        <div class="jks-onboarding-card-desc">Inspect any website's SSL certificate chain and add certs to a keystore</div>
                    </div>
                    <div class="jks-onboarding-card" data-switch-mode="create">
                        <div class="jks-onboarding-card-icon">&#10024;</div>
                        <div class="jks-onboarding-card-title">Create New Keystore</div>
                        <div class="jks-onboarding-card-desc">Start with an empty keystore and generate key pairs or import certificates</div>
                    </div>
                </div>
            </div>

            <!-- Post-Create / Post-Load Guidance (hidden initially) -->
            <div id="jksGuidance" class="jks-guidance" style="display:none">
                <div class="jks-guidance-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:20px;height:20px;color:var(--jks-valid)">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                        <polyline points="22 4 12 14.01 9 11.01"/>
                    </svg>
                    <span id="jksGuidanceTitle">Keystore Ready</span>
                </div>
                <p id="jksGuidanceText" class="jks-guidance-text">Your keystore is loaded. Select an alias from the left to view details, or use the actions below.</p>
                <div class="jks-guidance-actions">
                    <button class="jks-guidance-btn" id="jksGuideGenBtn">
                        <span class="jks-guidance-btn-icon">&#128273;</span>
                        <span class="jks-guidance-btn-label">Generate Key Pair</span>
                    </button>
                    <button class="jks-guidance-btn" id="jksGuideImportBtn">
                        <span class="jks-guidance-btn-icon">&#128196;</span>
                        <span class="jks-guidance-btn-label">Import PEM Certificate</span>
                    </button>
                    <button class="jks-guidance-btn" id="jksGuideFetchBtn">
                        <span class="jks-guidance-btn-icon">&#127760;</span>
                        <span class="jks-guidance-btn-label">Fetch &amp; Add SSL Cert</span>
                    </button>
                    <button class="jks-guidance-btn" id="jksGuideDownloadBtn">
                        <span class="jks-guidance-btn-icon">&#11015;</span>
                        <span class="jks-guidance-btn-label">Download Keystore</span>
                    </button>
                </div>
            </div>

            <!-- Detail Card (shown when alias selected) -->
            <div class="tool-card" style="flex:1;min-height:300px;">
                <div id="jksDetailEmpty" class="jks-detail-empty" style="display:none">
                    <div class="jks-detail-empty-icon">&#128270;</div>
                    <h3>Select an Alias</h3>
                    <p>Click on an alias in the left panel to view certificate details and security analysis</p>
                </div>
                <div id="jksDetailCard" class="jks-detail-card" style="position:relative">
                    <!-- Rendered by JS -->
                </div>
            </div>

            <!-- Fetch Remote Results -->
            <div class="jks-remote-results" id="jksRemoteResults">
                <div class="tool-card">
                    <div class="tool-card-header">Remote Certificates</div>
                    <div class="tool-card-body" id="jksRemoteResultsBody">
                        <!-- Rendered by JS -->
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <!-- Mobile Ad Fallback -->
    <div style="display:none" class="mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="jks.jsp" />
        <jsp:param name="category" value="Cryptography" />
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <div class="jks-educational">

        <!-- Features Section -->
        <section class="jks-section">
            <h2>Features</h2>
            <div class="jks-features-grid">
                <div class="jks-feature-card">
                    <h4>View &amp; Manage</h4>
                    <ul>
                        <li>View JKS, PKCS12, JCEKS files</li>
                        <li>Auto-detect keystore type</li>
                        <li>View certificate details</li>
                        <li>Delete and rename aliases</li>
                        <li>Export modified keystore</li>
                        <li>Create empty keystores</li>
                    </ul>
                </div>
                <div class="jks-feature-card">
                    <h4>Import &amp; Export</h4>
                    <ul>
                        <li>Export certificates to PEM/DER</li>
                        <li>Import PEM certificates</li>
                        <li>Fetch remote SSL certificates</li>
                        <li>Add fetched certs to keystore</li>
                        <li>Generate new key pairs</li>
                        <li>Parse full certificate details</li>
                    </ul>
                </div>
                <div class="jks-feature-card">
                    <h4>Security &amp; Monitoring</h4>
                    <ul>
                        <li>Certificate health dashboard</li>
                        <li>Expiry timeline visualization</li>
                        <li>Weak key detection (&lt;2048 bit)</li>
                        <li>SHA-1 signature warnings</li>
                        <li>Self-signed certificate detection</li>
                        <li>Key pair validation</li>
                    </ul>
                </div>
            </div>
        </section>

        <!-- Java Keytool Commands -->
        <section class="jks-section">
            <h2>Java Keytool Commands Reference</h2>
            <div class="jks-commands-grid">
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Generate Keys &amp; Certificates</div>
                    <pre><code># Generate a new key pair and self-signed certificate
keytool -genkeypair -alias mydomain -keyalg RSA -keysize 2048 \
  -validity 365 -keystore keystore.jks

# Generate with specific DN
keytool -genkeypair -alias server -keyalg RSA -keysize 2048 \
  -dname "CN=example.com,O=MyOrg,L=City,ST=State,C=US" \
  -keystore keystore.jks

# Generate EC key pair
keytool -genkeypair -alias eckey -keyalg EC -keysize 256 \
  -keystore keystore.jks</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">View &amp; List</div>
                    <pre><code># List all entries in keystore
keytool -list -keystore keystore.jks

# List with verbose details
keytool -list -v -keystore keystore.jks

# List specific alias
keytool -list -v -alias mydomain -keystore keystore.jks

# Print certificate in RFC format
keytool -list -rfc -alias mydomain -keystore keystore.jks</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Import Certificates</div>
                    <pre><code># Import a trusted CA certificate
keytool -importcert -trustcacerts -alias rootca \
  -file ca-cert.pem -keystore keystore.jks

# Import a certificate chain
keytool -importcert -alias myserver -file server.crt \
  -keystore keystore.jks

# Import PKCS12 into JKS
keytool -importkeystore -srckeystore cert.p12 \
  -srcstoretype PKCS12 -destkeystore keystore.jks</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Export Certificates</div>
                    <pre><code># Export certificate to file (DER format)
keytool -exportcert -alias mydomain -keystore keystore.jks \
  -file cert.der

# Export certificate in PEM format
keytool -exportcert -alias mydomain -keystore keystore.jks \
  -rfc -file cert.pem

# Convert JKS to PKCS12
keytool -importkeystore -srckeystore keystore.jks \
  -destkeystore keystore.p12 -deststoretype PKCS12</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Generate CSR</div>
                    <pre><code># Generate Certificate Signing Request
keytool -certreq -alias mydomain -keystore keystore.jks \
  -file mydomain.csr

# Generate CSR with SAN (Subject Alternative Names)
keytool -certreq -alias mydomain -keystore keystore.jks \
  -ext san=dns:www.example.com,dns:example.com \
  -file mydomain.csr</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Delete &amp; Modify</div>
                    <pre><code># Delete an alias
keytool -delete -alias oldcert -keystore keystore.jks

# Change alias name
keytool -changealias -alias oldname -destalias newname \
  -keystore keystore.jks

# Change keystore password
keytool -storepasswd -keystore keystore.jks

# Change key password
keytool -keypasswd -alias mydomain -keystore keystore.jks</code></pre>
                </div>
            </div>
        </section>

        <!-- OpenSSL Commands -->
        <section class="jks-section">
            <h2>OpenSSL Commands for Keystore Operations</h2>
            <div class="jks-commands-grid">
                <div class="jks-command-card">
                    <div class="jks-command-card-header">View &amp; Convert</div>
                    <pre><code># View PKCS12 contents
openssl pkcs12 -info -in keystore.p12

# Extract certificate from PKCS12
openssl pkcs12 -in keystore.p12 -clcerts -nokeys \
  -out cert.pem

# Extract private key from PKCS12
openssl pkcs12 -in keystore.p12 -nocerts -nodes \
  -out key.pem

# Extract CA certificates
openssl pkcs12 -in keystore.p12 -cacerts -nokeys \
  -out ca-certs.pem</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Create PKCS12</div>
                    <pre><code># Create PKCS12 from cert and key
openssl pkcs12 -export -in cert.pem -inkey key.pem \
  -out keystore.p12 -name "myalias"

# Include CA chain
openssl pkcs12 -export -in cert.pem -inkey key.pem \
  -certfile ca-chain.pem -out keystore.p12

# Create with legacy encryption (Java compatibility)
openssl pkcs12 -export -in cert.pem -inkey key.pem \
  -out keystore.p12 -legacy</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Certificate Operations</div>
                    <pre><code># View certificate details
openssl x509 -in cert.pem -text -noout

# Check certificate expiry
openssl x509 -in cert.pem -noout -dates

# Verify certificate chain
openssl verify -CAfile ca-chain.pem cert.pem

# Get certificate from server
openssl s_client -connect example.com:443 \
  -showcerts &lt;/dev/null 2&gt;/dev/null | \
  openssl x509 -outform PEM &gt; server.pem</code></pre>
                </div>
                <div class="jks-command-card">
                    <div class="jks-command-card-header">Convert Formats</div>
                    <pre><code># DER to PEM
openssl x509 -inform DER -in cert.der \
  -outform PEM -out cert.pem

# PEM to DER
openssl x509 -inform PEM -in cert.pem \
  -outform DER -out cert.der

# Convert PKCS7 to PEM
openssl pkcs7 -print_certs -in cert.p7b \
  -out cert.pem

# Extract public key from certificate
openssl x509 -in cert.pem -pubkey -noout &gt; pubkey.pem</code></pre>
                </div>
            </div>
        </section>

        <!-- FAQ Section -->
        <section class="jks-section">
            <h2>Frequently Asked Questions</h2>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    What is a Java KeyStore (JKS)?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    A Java KeyStore (JKS) is a repository for cryptographic keys and certificates. It's commonly used to store:
                    <ul>
                        <li><strong>Private keys</strong> - Used for SSL/TLS server authentication</li>
                        <li><strong>Public key certificates</strong> - X.509 certificates</li>
                        <li><strong>Trusted CA certificates</strong> - For certificate chain validation</li>
                    </ul>
                    JKS files are protected by a password and use proprietary Java format. The default keystore type changed to PKCS12 in Java 9.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    What's the difference between JKS, PKCS12, and JCEKS?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <table>
                        <thead><tr><th>Format</th><th>Extension</th><th>Description</th></tr></thead>
                        <tbody>
                            <tr><td><strong>JKS</strong></td><td>.jks, .keystore</td><td>Java-proprietary format. Uses weak encryption (SHA1). Not recommended for new projects.</td></tr>
                            <tr><td><strong>PKCS12</strong></td><td>.p12, .pfx</td><td>Industry standard, cross-platform. Supports stronger encryption. Default since Java 9.</td></tr>
                            <tr><td><strong>JCEKS</strong></td><td>.jceks</td><td>Java Cryptography Extension KeyStore. Stronger encryption than JKS, but still Java-proprietary.</td></tr>
                        </tbody>
                    </table>
                    <strong>Recommendation:</strong> Use PKCS12 for new projects for better compatibility and security.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    How do I convert JKS to PKCS12?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    Use the keytool command to convert:
                    <pre><code>keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.p12 -deststoretype PKCS12</code></pre>
                    You'll be prompted for both the source and destination keystore passwords.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    How do I view the contents of a keystore?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <strong>Using keytool:</strong>
                    <pre><code>keytool -list -v -keystore keystore.jks</code></pre>
                    <strong>Using this online tool:</strong> Simply upload your keystore file and enter the password. The tool will display all aliases, certificates, and their details including expiry dates and security information.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    What is a truststore vs keystore?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    Both are technically the same file format, but they serve different purposes:
                    <ul>
                        <li><strong>Keystore:</strong> Contains your private keys and certificates. Used for server authentication (proving your identity).</li>
                        <li><strong>Truststore:</strong> Contains trusted CA certificates. Used to verify certificates from others (validating their identity).</li>
                    </ul>
                    In Java, the default truststore is <code>$JAVA_HOME/lib/security/cacerts</code> with default password "changeit".
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    How do I add a certificate to Java's truststore?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <pre><code>keytool -importcert -trustcacerts -alias myca \
  -file ca-cert.pem \
  -keystore $JAVA_HOME/lib/security/cacerts \
  -storepass changeit</code></pre>
                    <strong>Note:</strong> You may need administrator/root privileges to modify the system cacerts file.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    How do I check certificate expiry dates?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <strong>Using keytool:</strong>
                    <pre><code>keytool -list -v -keystore keystore.jks | grep -A2 "Valid from"</code></pre>
                    <strong>Using OpenSSL:</strong>
                    <pre><code>openssl x509 -in cert.pem -noout -dates</code></pre>
                    <strong>Using this tool:</strong> Upload your keystore to see the health dashboard with expiring/expired certificate counts and a visual expiry timeline.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    What key size should I use?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <strong>Recommended minimum key sizes:</strong>
                    <ul>
                        <li><strong>RSA:</strong> 2048 bits minimum, 4096 bits for high security</li>
                        <li><strong>ECDSA:</strong> 256 bits (P-256 curve) or 384 bits (P-384)</li>
                        <li><strong>DSA:</strong> 2048 bits (deprecated, prefer RSA or ECDSA)</li>
                    </ul>
                    This tool's security audit will warn you about keys smaller than 2048 bits.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    Is it safe to upload my keystore to this tool?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <strong>Privacy considerations:</strong>
                    <ul>
                        <li>Your keystore is read client-side in your browser</li>
                        <li>The keystore data is stored in browser memory, not on our servers</li>
                        <li>All operations happen locally with AJAX calls</li>
                        <li>No keystore data is persisted after you close the page</li>
                    </ul>
                    <strong>Best practice:</strong> For production keystores containing private keys, consider using offline tools like keytool or OpenSSL.
                </div>
            </div>

            <div class="jks-faq-item">
                <div class="jks-faq-question" onclick="this.nextElementSibling.classList.toggle('open');this.querySelector('.jks-collapsible-chevron').classList.toggle('open')">
                    How do I fetch SSL certificates from a website?
                    <span class="jks-collapsible-chevron">&#9660;</span>
                </div>
                <div class="jks-faq-answer">
                    <strong>Using this tool:</strong> Switch to "Fetch URL" mode, enter the URL (e.g., google.com), and click "Fetch Certificates". You can then copy the PEM or add it directly to your keystore.
                    <br><br>
                    <strong>Using OpenSSL:</strong>
                    <pre><code>openssl s_client -connect example.com:443 -showcerts &lt;/dev/null 2&gt;/dev/null | \
  openssl x509 -outform PEM &gt; cert.pem</code></pre>
                </div>
            </div>
        </section>

        <!-- About -->
        <section class="jks-section">
            <div class="tool-card" style="padding:2rem;">
                <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">About This Tool</h2>
                <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">This Java KeyStore viewer is maintained by <strong>Anish Nath</strong>, a security engineer with expertise in cryptography, PKI, and Java security. Building security tools for developers since 2015.</p>
                <p style="color:var(--text-secondary);margin-bottom:0;line-height:1.7;">The tool supports viewing and managing JKS, PKCS12, and JCEKS keystores, with security audit capabilities including weak key detection, SHA-1 warnings, and certificate expiry monitoring.</p>
            </div>
        </section>
    </div>

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

    <!-- ==================== GENERATE KEY PAIR MODAL ==================== -->
    <div class="jks-modal-backdrop" id="jksGenModal">
        <div class="jks-modal">
            <div class="jks-modal-header">
                <h4>Generate Key Pair</h4>
                <button class="jks-modal-close" id="jksGenModalClose">&times;</button>
            </div>
            <div class="jks-modal-body">
                <div class="jks-modal-form-group">
                    <label for="genAlias">Alias Name *</label>
                    <input type="text" id="genAlias" placeholder="my-server-key">
                </div>
                <div class="jks-modal-form-group">
                    <label>Algorithm</label>
                    <div class="jks-alg-toggle" id="genAlgToggle">
                        <button class="jks-alg-btn active" data-alg="RSA">RSA</button>
                        <button class="jks-alg-btn" data-alg="EC">EC</button>
                        <button class="jks-alg-btn" data-alg="DSA">DSA</button>
                    </div>
                </div>
                <div class="jks-modal-form-group">
                    <label for="genKeySize">Key Size</label>
                    <select id="genKeySize">
                        <option value="2048">2048 bits</option>
                        <option value="3072">3072 bits</option>
                        <option value="4096">4096 bits</option>
                    </select>
                </div>
                <div class="jks-modal-form-group">
                    <label for="genCN">Common Name (CN)</label>
                    <input type="text" id="genCN" placeholder="example.com">
                </div>
                <div class="jks-modal-form-group">
                    <label for="genValidity">Validity (days)</label>
                    <input type="number" id="genValidity" value="365" min="1" max="7300">
                </div>
                <div class="jks-modal-form-group">
                    <label for="genKeyPassword">Key Password (optional)</label>
                    <input type="password" id="genKeyPassword" placeholder="Defaults to store password">
                </div>
                <div class="jks-gen-preview" id="genPreview">
                    Will generate: RSA 2048-bit key pair with self-signed certificate, valid for 365 days
                </div>
            </div>
            <div class="jks-modal-footer">
                <button class="jks-btn" id="jksGenCancelBtn">Cancel</button>
                <button class="jks-btn jks-btn-primary" id="jksGenSubmitBtn">Generate</button>
            </div>
        </div>
    </div>

    <!-- ==================== IMPORT PEM MODAL ==================== -->
    <div class="jks-modal-backdrop" id="jksImportModal">
        <div class="jks-modal">
            <div class="jks-modal-header">
                <h4>Import PEM Certificate</h4>
                <button class="jks-modal-close" id="jksImportModalClose">&times;</button>
            </div>
            <div class="jks-modal-body">
                <div class="jks-modal-form-group">
                    <label for="importAlias">Alias Name *</label>
                    <input type="text" id="importAlias" placeholder="my-trusted-ca">
                </div>
                <div class="jks-modal-form-group">
                    <label for="importPem">PEM Certificate *</label>
                    <textarea id="importPem" class="jks-import-textarea" rows="10" placeholder="-----BEGIN CERTIFICATE-----
MIIDdzCCAl+gAwIBAgIEAgAAuTANBgkq...
-----END CERTIFICATE-----"></textarea>
                </div>
                <div class="jks-import-hint">Paste the full PEM including BEGIN/END markers. Supports single certificates and certificate chains.</div>
            </div>
            <div class="jks-modal-footer">
                <button class="jks-btn" id="jksImportCancelBtn">Cancel</button>
                <button class="jks-btn jks-btn-primary" id="jksImportSubmitBtn">Import Certificate</button>
            </div>
        </div>
    </div>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/js/jks-render.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/jks-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
