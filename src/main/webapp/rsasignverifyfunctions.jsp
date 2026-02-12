<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.Security.pgppojo" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
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
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

    <!-- Critical CSS -->
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
            --tool-primary:#059669;--tool-primary-dark:#047857;--tool-gradient:linear-gradient(135deg,#059669 0%,#047857 100%);--tool-light:#ecfdf5
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(5,150,105,0.15)}
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

        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) 1fr 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) 1fr}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}

        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:1rem;transition:opacity .15s,transform .15s}

        .tool-result-card{display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions.visible{display:flex}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}

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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(5,150,105,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="RSA Sign & Verify Online - Digital Signature Tool" />
        <jsp:param name="toolDescription" value="Sign messages with RSA private key and verify signatures with public key. SHA256withRSA, RSASSA-PSS, SHA512withRSA. Generate 2048/4096-bit keys. Free, no signup." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="rsasignverifyfunctions.jsp" />
        <jsp:param name="toolKeywords" value="rsa signature online, rsa sign verify, digital signature generator, SHA256withRSA, RSASSA-PSS, rsa sign message, verify rsa signature, rsa key pair generator, PKCS1 signature, code signing, rsa 2048 sign" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Generate RSA keys (512/1024/2048/4096-bit),Sign messages with private key,Verify signatures with public key,SHA256withRSA and RSASSA-PSS,Base64 encoded signatures,Copy and share results,Use for Verification one-click swap,No data stored on server" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is an RSA digital signature?" />
        <jsp:param name="faq1a" value="An RSA digital signature is a cryptographic mechanism that allows you to sign a message with your private key to prove authenticity and integrity. Anyone can verify the signature using your public key. Signing uses the private key to create the signature, and the public key to verify it." />
        <jsp:param name="faq2q" value="How do I sign a message with RSA?" />
        <jsp:param name="faq2a" value="To sign a message: 1) Generate or provide an RSA key pair, 2) Select Sign mode, 3) Choose a signature algorithm (SHA256withRSA recommended), 4) Enter your message, 5) Click Process. The tool creates a hash of your message and encrypts it with your private key, producing a Base64-encoded signature." />
        <jsp:param name="faq3q" value="What signature algorithms are supported?" />
        <jsp:param name="faq3a" value="This tool supports SHA256withRSA (recommended), SHA1withRSA, SHA384withRSA, SHA512withRSA, MD5withRSA, RSASSA-PSS, SHA1WithRSA/PSS, SHA224WithRSA/PSS, SHA384WithRSA/PSS, and SHA1withRSAandMGF1. SHA256withRSA and SHA384withRSA are recommended for modern applications." />
        <jsp:param name="faq4q" value="What is the difference between RSASSA-PSS and PKCS1-v1_5?" />
        <jsp:param name="faq4a" value="RSASSA-PKCS1-v1_5 is the older deterministic signature scheme, while RSASSA-PSS (Probabilistic Signature Scheme) is newer and more secure with a formal security proof. PSS uses random padding so signatures differ each time. PSS is recommended for new applications." />
        <jsp:param name="faq5q" value="How do I verify an RSA signature?" />
        <jsp:param name="faq5a" value="To verify: 1) Switch to Verify mode, 2) Enter the original message, 3) Paste the Base64-encoded signature, 4) Ensure the public key is present, 5) Select the same algorithm used for signing, 6) Click Process. The tool indicates whether the signature is valid or invalid." />
        <jsp:param name="faq6q" value="How do I sign and verify with RSA in Python?" />
        <jsp:param name="faq6a" value="Use the cryptography library: from cryptography.hazmat.primitives.asymmetric import rsa, padding; private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048); signature = private_key.sign(message, padding.PKCS1v15(), hashes.SHA256()); public_key.verify(signature, message, padding.PKCS1v15(), hashes.SHA256())." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
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

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- Tool-specific styles -->
    <style>
        .tool-label{display:block;font-weight:600;font-size:0.8125rem;color:var(--text-primary,#0f172a);margin-bottom:0.375rem;letter-spacing:0.01em}
        .tool-hint{font-size:0.6875rem;color:var(--text-secondary,#64748b);margin:0.25rem 0 0 0;line-height:1.4}
        .tool-input{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:0.5rem;font-size:0.875rem;font-family:var(--font-mono);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);transition:border-color .15s,box-shadow .15s}
        .tool-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(5,150,105,0.15)}
        .tool-input::placeholder{color:#94a3b8;font-family:var(--font-sans);font-style:italic;font-size:0.8125rem}
        textarea.tool-input{resize:vertical;line-height:1.5}
        .tool-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);cursor:pointer}
        .tool-select:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(5,150,105,0.15)}
        [data-theme="dark"] .tool-label{color:var(--text-primary,#e2e8f0)}
        [data-theme="dark"] .tool-hint{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-input,[data-theme="dark"] .tool-select{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);color:var(--text-primary,#e2e8f0)}
        [data-theme="dark"] .tool-input:focus,[data-theme="dark"] .tool-select:focus{border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(5,150,105,0.25)}
        [data-theme="dark"] .tool-input::placeholder{color:#64748b}

        /* Mode toggle */
        .rsa-mode-toggle{display:flex;gap:0;margin-bottom:1rem;border-radius:0.5rem;overflow:hidden;border:1.5px solid var(--border)}
        .rsa-mode-btn{flex:1;padding:0.625rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;font-family:var(--font-sans)}
        .rsa-mode-btn.active{background:var(--tool-gradient);color:#fff}
        .rsa-mode-btn:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .rsa-mode-btn{background:var(--bg-tertiary);color:var(--text-secondary)}
        [data-theme="dark"] .rsa-mode-btn.active{background:var(--tool-gradient);color:#fff}
        [data-theme="dark"] .rsa-mode-btn:hover:not(.active){background:rgba(255,255,255,0.08)}

        /* Key size radio group */
        .rsa-keysize-group{display:flex;gap:0;border-radius:0.5rem;overflow:hidden;border:1.5px solid var(--border)}
        .rsa-keysize-btn{flex:1;padding:0.5rem;text-align:center;font-weight:600;font-size:0.75rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);font-family:var(--font-sans);transition:all .15s}
        .rsa-keysize-btn.active{background:var(--tool-gradient);color:#fff}
        .rsa-keysize-btn:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .rsa-keysize-btn{background:var(--bg-tertiary);color:var(--text-secondary)}
        [data-theme="dark"] .rsa-keysize-btn.active{background:var(--tool-gradient);color:#fff}

        .rsa-generate-btn{width:100%;padding:0.5rem;font-weight:600;font-size:0.75rem;border:1.5px solid var(--tool-primary);border-radius:0.5rem;cursor:pointer;background:transparent;color:var(--tool-primary);font-family:var(--font-sans);transition:all .15s;margin-top:0.5rem}
        .rsa-generate-btn:hover{background:var(--tool-gradient);color:#fff;border-color:transparent}

        /* Collapsible keys */
        .rsa-keys-toggle{display:flex;align-items:center;gap:0.5rem;padding:0.625rem 0.75rem;background:var(--bg-secondary);border:1.5px solid var(--border);border-radius:0.5rem;cursor:pointer;font-weight:600;font-size:0.8125rem;color:var(--text-secondary);width:100%;font-family:var(--font-sans);transition:all .15s}
        .rsa-keys-toggle:hover{background:var(--bg-tertiary);border-color:var(--tool-primary);color:var(--tool-primary)}
        .rsa-keys-chevron{transition:transform .2s;flex-shrink:0;margin-left:auto}
        .rsa-keys-toggle.open .rsa-keys-chevron{transform:rotate(180deg)}
        .rsa-keys-body{display:none;margin-top:0.5rem;padding:0.75rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-secondary)}
        .rsa-keys-body.open{display:block}
        [data-theme="dark"] .rsa-keys-toggle{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-secondary)}
        [data-theme="dark"] .rsa-keys-body{background:var(--bg-tertiary);border-color:var(--border)}

        .rsa-key-copy-btn{padding:0.3rem 0.6rem;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);font-size:0.6875rem;font-weight:500;cursor:pointer;font-family:var(--font-sans);transition:all .15s}
        .rsa-key-copy-btn:hover{border-color:var(--tool-primary);color:var(--tool-primary)}

        /* Signature field (conditional) */
        .rsa-sig-group{display:none}.rsa-sig-group.visible{display:block}

        /* Verify result banners */
        .rsa-result-valid{background:#ecfdf5;border:1.5px solid #a7f3d0;border-radius:0.75rem;padding:1.25rem}
        .rsa-result-invalid{background:#fef2f2;border:1.5px solid #fecaca;border-radius:0.75rem;padding:1.25rem}
        [data-theme="dark"] .rsa-result-valid{background:rgba(5,150,105,0.15);border-color:rgba(5,150,105,0.3)}
        [data-theme="dark"] .rsa-result-invalid{background:rgba(239,68,68,0.15);border-color:rgba(239,68,68,0.3)}

        /* Flow animation */
        .rsa-flow{display:flex;flex-direction:column;align-items:center;padding:1.5rem 1rem;gap:1.25rem}
        .rsa-flow-row{display:flex;align-items:center;gap:0;width:100%;max-width:380px}
        .rsa-flow-box{padding:0.5rem 0.75rem;border-radius:0.5rem;font-size:0.7rem;font-weight:600;text-align:center;white-space:nowrap;animation:flowFadeIn .6s ease both}
        .flow-message{background:#dbeafe;color:#1e40af;border:1.5px solid #93c5fd;min-width:72px;animation-delay:0s}
        .flow-signature{background:#fce7f3;color:#9d174d;border:1.5px solid #f9a8d4;min-width:72px;animation-delay:.8s}
        .flow-engine{background:var(--tool-gradient);color:#fff;border:none;padding:0.625rem 0.875rem;border-radius:0.625rem;box-shadow:0 4px 16px rgba(5,150,105,0.25);animation-delay:.3s;position:relative}
        .flow-engine-label{font-size:0.625rem;opacity:0.85;margin-top:0.125rem;font-weight:500}
        [data-theme="dark"] .flow-message{background:rgba(59,130,246,0.15);color:#93c5fd;border-color:rgba(59,130,246,0.3)}
        [data-theme="dark"] .flow-signature{background:rgba(236,72,153,0.15);color:#f9a8d4;border-color:rgba(236,72,153,0.3)}
        .flow-arrow{flex:1;min-width:28px;height:2px;position:relative;overflow:visible}
        .flow-arrow-line{position:absolute;top:0;left:0;right:0;height:2px;background:var(--border);border-radius:1px}
        .flow-arrow-dot{position:absolute;top:-3px;width:8px;height:8px;border-radius:50%;background:var(--tool-primary);animation:flowDot 2s ease-in-out infinite}
        .flow-arrow-head{position:absolute;top:-4px;right:-2px;width:0;height:0;border-left:6px solid var(--border);border-top:5px solid transparent;border-bottom:5px solid transparent}
        @keyframes flowDot{0%{left:0;opacity:0}10%{opacity:1}90%{opacity:1}100%{left:calc(100% - 8px);opacity:0}}
        @keyframes flowFadeIn{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:translateY(0)}}
        .rsa-flow-mode{font-size:0.6875rem;font-weight:600;color:var(--tool-primary);text-transform:uppercase;letter-spacing:0.08em;animation:flowFadeIn .3s ease both}
        .rsa-flow-caption{font-size:0.8125rem;color:var(--text-muted);text-align:center;animation:flowFadeIn .6s ease 1s both}
        .flow-key-icon{position:absolute;top:-18px;right:-6px;font-size:0.75rem;animation:flowKeyBob 2.5s ease-in-out infinite}
        @keyframes flowKeyBob{0%,100%{transform:translateY(0)}50%{transform:translateY(-3px)}}
        .flow-arrow.reverse .flow-arrow-dot{animation:flowDotReverse 2s ease-in-out infinite}
        .flow-arrow.reverse .flow-arrow-head{left:-2px;right:auto;border-left:none;border-right:6px solid var(--border)}
        @keyframes flowDotReverse{0%{left:calc(100% - 8px);opacity:0}10%{opacity:1}90%{opacity:1}100%{left:0;opacity:0}}

        /* Output tabs */
        .rsa-output-tabs{display:flex;gap:0;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.75rem}
        .rsa-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;font-family:var(--font-sans);text-align:center}
        .rsa-output-tab.active{background:var(--tool-gradient);color:#fff}
        .rsa-output-tab:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .rsa-output-tab{background:var(--bg-tertiary)}
        [data-theme="dark"] .rsa-output-tab.active{background:var(--tool-gradient);color:#fff}
        .rsa-panel{display:none;flex:1;min-height:0}.rsa-panel.active{display:flex;flex-direction:column}
        #panel-output .tool-result-card{flex:1}
        #panel-python{min-height:540px}

        /* Error alert */
        .rsa-error{background:rgba(239,68,68,0.08);border:1px solid rgba(239,68,68,0.3);border-radius:0.5rem;padding:0.75rem 1rem;color:var(--error,#ef4444);font-size:0.8125rem;font-weight:500}
        .rsa-loading{text-align:center;padding:2rem;color:var(--text-muted)}

        /* Terminal blocks */
        .terminal-block{background:#1e1e1e;border-radius:0.5rem;overflow:hidden;margin-bottom:0}
        .terminal-header{background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center}
        .terminal-body{padding:0.75rem;color:#4ec9b0;font-family:var(--font-mono);font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px}
        .terminal-body code{color:#ce9178}
        .copy-cmd-btn{background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;transition:all .15s}
        .copy-cmd-btn:hover{background:rgba(255,255,255,0.1);border-color:rgba(255,255,255,0.4)}

        /* Code example tabs */
        .code-tabs{display:flex;gap:0;border-bottom:2px solid #323232;background:#2d2d2d;border-radius:0.5rem 0.5rem 0 0;overflow-x:auto}
        .code-tab{padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:var(--font-sans);position:relative;transition:color .15s}
        .code-tab:hover{color:#d4d4d4}
        .code-tab.active{color:#4ec9b0}
        .code-tab.active::after{content:'';position:absolute;bottom:-2px;left:0;right:0;height:2px;background:#4ec9b0}
        .code-tab-panel{display:none}.code-tab-panel.active{display:block}
        .code-tab-panel .terminal-block{border-radius:0 0 0.5rem 0.5rem}

        /* FAQ */
        .faq-item{border:1px solid var(--border,#e2e8f0);border-radius:0.5rem;margin-bottom:0.5rem;overflow:hidden}
        .faq-question{padding:0.75rem 1rem;font-weight:600;font-size:0.875rem;color:var(--text-primary,#0f172a);background:var(--bg-secondary,#f8fafc);border:none;width:100%;cursor:pointer;display:flex;align-items:center;justify-content:space-between;gap:0.75rem;font-family:var(--font-sans);text-align:left}
        .faq-question:hover{background:var(--bg-tertiary,#f1f5f9)}
        .faq-answer{display:none;padding:0.75rem 1rem;font-size:0.8125rem;line-height:1.6;color:var(--text-secondary,#475569);border-top:1px solid var(--border,#e2e8f0)}
        .faq-item.open .faq-answer{display:block}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-chevron{transition:transform .2s;flex-shrink:0}
        [data-theme="dark"] .faq-question{background:var(--bg-tertiary,#334155);color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .faq-question:hover{background:rgba(255,255,255,0.08)}
        [data-theme="dark"] .faq-answer{color:var(--text-secondary,#cbd5e1);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .faq-item{border-color:var(--border,#334155)}

        /* Comparison table */
        .compare-table{width:100%;border-collapse:collapse;font-size:0.85rem;margin-top:0.75rem}
        .compare-table thead th{background:var(--bg-secondary,#f8fafc);padding:0.5rem 0.75rem;text-align:left;font-weight:600;font-size:0.8rem;color:var(--text-secondary,#475569);border-bottom:2px solid var(--border,#e2e8f0)}
        .compare-table tbody td{padding:0.5rem 0.75rem;border-bottom:1px solid var(--border,#e2e8f0);color:var(--text-primary,#0f172a)}
        .compare-table tbody td:first-child{font-weight:600;color:var(--tool-primary)}
        [data-theme="dark"] .compare-table thead th{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569);color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .compare-table tbody td{border-bottom-color:var(--border,#334155);color:var(--text-primary,#f1f5f9)}
    </style>

    <%-- Server-side key generation --%>
    <%
        String pubKey = "";
        String privKey = "";
        String checkedKey = "1024";
        boolean k1 = false;
        boolean k2 = false;
        boolean k3 = false;
        boolean k4 = false;

        if (request.getSession().getAttribute("pubkey") == null) {
            Gson gson = new Gson();
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "rsa/" + 1024;

            HttpGet getRequest = new HttpGet(url1);
            getRequest.addHeader("accept", "application/json");

            HttpResponse response1 = httpClient.execute(getRequest);

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            (response1.getEntity().getContent())
                    )
            );

            StringBuilder content = new StringBuilder();
            String line;
            while (null != (line = br.readLine())) {
                content.append(line);
            }
            pgppojo pgppojo = (pgppojo) gson.fromJson(content.toString(), pgppojo.class);

            pubKey = pgppojo.getPubliceKey();
            privKey = pgppojo.getPrivateKey();
            checkedKey = "1024";
        } else {
            pubKey = (String) request.getSession().getAttribute("pubkey");
            privKey = (String) request.getSession().getAttribute("privKey");
            checkedKey = (String) request.getSession().getAttribute("keysize");
            if (checkedKey == null || checkedKey.isEmpty()) {
                checkedKey = "1024";
            }
        }

        if ("512".equals(checkedKey)) { k1 = true; }
        if ("1024".equals(checkedKey)) { k2 = true; }
        if ("2048".equals(checkedKey)) { k3 = true; }
        if ("4096".equals(checkedKey)) { k4 = true; }
    %>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">RSA Sign &amp; Verify Online</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    RSA Signature
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">SHA256withRSA</span>
                <span class="tool-badge">RSASSA-PSS</span>
                <span class="tool-badge">2048/4096-bit</span>
                <span class="tool-badge">Free</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate RSA key pairs, sign messages with your private key, and verify signatures with the public key. Supports SHA256withRSA, RSASSA-PSS, SHA512withRSA. Run Python signature code in your browser. No data stored.</p>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                        <polyline points="10 17 15 12 10 7"/>
                        <line x1="15" y1="12" x2="3" y2="12"/>
                    </svg>
                    RSA Signature Tool
                </div>
                <div class="tool-card-body">
                    <!-- Mode toggle -->
                    <div class="rsa-mode-toggle">
                        <button type="button" class="rsa-mode-btn active" data-mode="sign">Sign</button>
                        <button type="button" class="rsa-mode-btn" data-mode="verify">Verify</button>
                    </div>

                    <!-- Key Size -->
                    <div class="tool-form-group">
                        <label class="tool-label">Key Size</label>
                        <div class="rsa-keysize-group">
                            <button type="button" class="rsa-keysize-btn<% if(k1){%> active<%}%>" data-size="512">512</button>
                            <button type="button" class="rsa-keysize-btn<% if(k2){%> active<%}%>" data-size="1024">1024</button>
                            <button type="button" class="rsa-keysize-btn<% if(k3){%> active<%}%>" data-size="2048">2048</button>
                            <button type="button" class="rsa-keysize-btn<% if(k4){%> active<%}%>" data-size="4096">4096</button>
                        </div>
                        <button type="button" class="rsa-generate-btn" id="generateBtn">Generate New Keys</button>
                    </div>

                    <!-- Algorithm -->
                    <div class="tool-form-group">
                        <label class="tool-label" for="algorithmSelect">Algorithm</label>
                        <select class="tool-select" id="algorithmSelect">
                            <option value="SHA256withRSA" selected>SHA256withRSA (Recommended)</option>
                            <option value="SHA1WithRSA/PSS">RSASSA-PSS</option>
                            <option value="SHA1WithRSA/PSS">SHA1WithRSA/PSS</option>
                            <option value="SHA224WithRSA/PSS">SHA224WithRSA/PSS</option>
                            <option value="SHA384WithRSA/PSS">SHA384WithRSA/PSS</option>
                            <option value="SHA384WithRSA/PSS">SHA1withRSAandMGF1</option>
                            <option value="sha1WithRSA">SHA1withRSA</option>
                            <option value="sha384WithRSA">SHA384withRSA</option>
                            <option value="sha512WithRSA">SHA512withRSA</option>
                            <option value="md2WithRSA">MD2withRSA (Deprecated)</option>
                            <option value="md5WithRSA">MD5withRSA (Deprecated)</option>
                        </select>
                    </div>

                    <!-- Message -->
                    <div class="tool-form-group">
                        <label class="tool-label" for="message" id="messageLabel">Plaintext Message</label>
                        <textarea class="tool-input" id="message" rows="4" placeholder="Enter your message to sign..."></textarea>
                    </div>

                    <!-- Signature (verify mode) -->
                    <div class="tool-form-group rsa-sig-group" id="sigGroup">
                        <label class="tool-label" for="signature">Signature (Base64)</label>
                        <textarea class="tool-input" id="signature" rows="3" placeholder="Paste signature here for verification..."></textarea>
                        <p class="tool-hint">Required for signature verification</p>
                    </div>

                    <!-- Collapsible Keys -->
                    <div class="tool-form-group">
                        <button type="button" class="rsa-keys-toggle" id="keysToggle">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;flex-shrink:0;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                            RSA Keys
                            <svg class="rsa-keys-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><polyline points="6 9 12 15 18 9"/></svg>
                        </button>
                        <div class="rsa-keys-body" id="keysBody">
                            <div style="margin-bottom:0.75rem;">
                                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:0.25rem;">
                                    <label class="tool-label" style="margin-bottom:0;">Public Key</label>
                                    <button type="button" class="rsa-key-copy-btn" data-copy="publicKey">Copy</button>
                                </div>
                                <textarea class="tool-input" id="publicKey" rows="5" style="font-size:0.75rem;"><%= pubKey %></textarea>
                            </div>
                            <div style="margin-bottom:0.75rem;">
                                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:0.25rem;">
                                    <label class="tool-label" style="margin-bottom:0;">Private Key</label>
                                    <button type="button" class="rsa-key-copy-btn" data-copy="privateKey">Copy</button>
                                </div>
                                <textarea class="tool-input" id="privateKey" rows="5" style="font-size:0.75rem;"><%= privKey %></textarea>
                            </div>
                            <button type="button" class="rsa-key-copy-btn" id="copyBothKeys" style="width:100%;padding:0.5rem;text-align:center;">Copy Both Keys</button>
                        </div>
                    </div>

                    <!-- Submit -->
                    <button type="button" class="tool-action-btn" id="submitBtn">Sign Message</button>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Tab bar -->
            <div class="rsa-output-tabs">
                <button type="button" class="rsa-output-tab active" data-panel="output">Output</button>
                <button type="button" class="rsa-output-tab" data-panel="python">Python</button>
            </div>

            <!-- Output Panel -->
            <div class="rsa-panel active" id="panel-output">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                        </svg>
                        <h4>Output</h4>
                    </div>
                    <div class="tool-result-content" id="displaySection">
                        <div class="tool-empty-state" id="emptyState">
                            <div class="rsa-flow" id="rsaFlow">
                                <div class="rsa-flow-mode" id="flowModeLabel">Signing</div>
                                <div class="rsa-flow-row" id="flowRow">
                                    <div class="rsa-flow-box flow-message" id="flowBoxLeft">Message</div>
                                    <div class="flow-arrow" id="flowArrow1">
                                        <div class="flow-arrow-line"></div>
                                        <div class="flow-arrow-dot"></div>
                                        <div class="flow-arrow-head"></div>
                                    </div>
                                    <div class="rsa-flow-box flow-engine" id="flowEngine">
                                        <span class="flow-key-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;vertical-align:middle;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg></span>
                                        <span id="flowAlgoLabel">SHA256withRSA</span>
                                        <div class="flow-engine-label" id="flowKeyLabel">+ Private Key</div>
                                    </div>
                                    <div class="flow-arrow" id="flowArrow2">
                                        <div class="flow-arrow-line"></div>
                                        <div class="flow-arrow-dot" style="animation-delay:1s;"></div>
                                        <div class="flow-arrow-head"></div>
                                    </div>
                                    <div class="rsa-flow-box flow-signature" id="flowBoxRight">Signature</div>
                                </div>
                                <p class="rsa-flow-caption">Enter a message, select algorithm, and click Process.</p>
                            </div>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn" id="copyResultBtn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;vertical-align:-2px;"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg> Copy</button>
                        <button type="button" class="tool-action-btn" id="useForVerifyBtn" style="display:none;"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;vertical-align:-2px;"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg> Verify</button>
                        <button type="button" class="tool-action-btn" id="downloadBtn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;vertical-align:-2px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg> JSON</button>
                        <button type="button" class="tool-action-btn" id="shareBtn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;vertical-align:-2px;"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg> Share</button>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="rsa-panel" id="panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <h4>Python Compiler</h4>
                        <select id="compilerTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="sign">Sign with my key</option>
                            <option value="verify">Verify with my key</option>
                            <option value="keygen">Generate key pair</option>
                            <option value="pss">PSS signature</option>
                            <option value="pkcs1">PKCS1v15 signature</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="compilerIframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <!-- Hidden key generation form -->
    <div style="display:none" aria-hidden="true">
        <form id="keyGenForm" method="GET" action="RSAFunctionality">
            <input type="hidden" name="q" value="setNeKey">
            <input type="hidden" name="rsasignverifyfunctions" value="rsasignverifyfunctions">
            <input type="hidden" name="keysize" id="hiddenKeySize" value="<%= checkedKey %>">
        </form>
    </div>

    <!-- Mobile Ad Fallback -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="rsasignverifyfunctions.jsp"/>
        <jsp:param name="keyword" value="cryptography"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- How RSA Signatures Work -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1.5rem;color:var(--text-primary);">How RSA Digital Signatures Work</h2>

            <p style="color:var(--text-secondary);font-size:0.9375rem;line-height:1.7;margin-bottom:1.5rem;">RSA digital signatures use <strong style="color:var(--text-primary);">asymmetric cryptography</strong> &mdash; a private key signs, a public key verifies. The signature binds the signer's identity to the message and detects any tampering.</p>

            <!-- Signing Diagram -->
            <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.75rem;color:var(--text-primary);">Signing Process</h3>
            <div style="overflow-x:auto;margin-bottom:1.25rem;">
                <svg viewBox="0 0 760 140" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:760px;height:auto;display:block;margin:0 auto;" role="img" aria-label="RSA signing process diagram">
                    <!-- Message box -->
                    <rect x="2" y="40" width="110" height="60" rx="8" fill="#dbeafe" stroke="#3b82f6" stroke-width="1.5"/>
                    <text x="57" y="66" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="12" font-weight="600" fill="#1e40af">Message</text>
                    <text x="57" y="82" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#3b82f6">"Hello World"</text>

                    <!-- Arrow 1 -->
                    <line x1="116" y1="70" x2="172" y2="70" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="172,65 182,70 172,75" fill="#94a3b8"/>

                    <!-- Hash box -->
                    <rect x="186" y="40" width="100" height="60" rx="8" fill="#fef3c7" stroke="#f59e0b" stroke-width="1.5"/>
                    <text x="236" y="63" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#92400e">SHA-256</text>
                    <text x="236" y="80" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#b45309">Hash Function</text>

                    <!-- Arrow 2 -->
                    <line x1="290" y1="70" x2="346" y2="70" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="346,65 356,70 346,75" fill="#94a3b8"/>

                    <!-- Hash digest -->
                    <rect x="360" y="15" width="110" height="38" rx="6" fill="#f1f5f9" stroke="#cbd5e1" stroke-width="1"/>
                    <text x="415" y="38" text-anchor="middle" font-family="monospace" font-size="8" fill="#64748b">a3f2...9b71</text>

                    <!-- Encrypt box (private key) -->
                    <rect x="360" y="40" width="110" height="60" rx="8" fill="#059669" stroke="#047857" stroke-width="1.5"/>
                    <text x="415" y="63" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#fff">Encrypt</text>
                    <text x="415" y="80" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#d1fae5">w/ Private Key</text>

                    <!-- Private key icon -->
                    <rect x="360" y="105" width="110" height="24" rx="4" fill="#ecfdf5" stroke="#a7f3d0" stroke-width="1"/>
                    <text x="415" y="121" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="8" font-weight="500" fill="#047857">Private Key (d, n)</text>

                    <!-- Arrow 3 -->
                    <line x1="474" y1="70" x2="530" y2="70" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="530,65 540,70 530,75" fill="#94a3b8"/>

                    <!-- Signature output -->
                    <rect x="544" y="40" width="120" height="60" rx="8" fill="#fce7f3" stroke="#ec4899" stroke-width="1.5"/>
                    <text x="604" y="63" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#9d174d">Signature</text>
                    <text x="604" y="80" text-anchor="middle" font-family="monospace" font-size="8" fill="#be185d">Base64 encoded</text>

                    <!-- Step labels -->
                    <text x="57" y="28" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" font-weight="600" fill="#94a3b8">STEP 1</text>
                    <text x="236" y="28" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" font-weight="600" fill="#94a3b8">STEP 2</text>
                    <text x="415" y="8" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" font-weight="600" fill="#94a3b8">STEP 3</text>
                    <text x="604" y="28" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" font-weight="600" fill="#94a3b8">OUTPUT</text>
                </svg>
            </div>
            <ol style="color:var(--text-secondary);font-size:0.8125rem;padding-left:1.25rem;line-height:1.9;margin-bottom:2rem;">
                <li>The original <strong>message</strong> is fed into a cryptographic hash function (e.g., SHA-256).</li>
                <li>The hash function produces a fixed-length <strong>digest</strong> &mdash; a unique fingerprint of the message.</li>
                <li>The digest is <strong>encrypted with the signer's private key</strong>, producing the digital signature.</li>
                <li>The signature is Base64-encoded and sent alongside the original message.</li>
            </ol>

            <!-- Verification Diagram -->
            <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.75rem;color:var(--text-primary);">Verification Process</h3>
            <div style="overflow-x:auto;margin-bottom:1.25rem;">
                <svg viewBox="0 0 760 190" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:760px;height:auto;display:block;margin:0 auto;" role="img" aria-label="RSA verification process diagram">
                    <!-- Top path: Signature -> Decrypt -> Hash' -->
                    <text x="57" y="18" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" font-weight="600" fill="#94a3b8">PATH A</text>
                    <rect x="2" y="28" width="110" height="52" rx="8" fill="#fce7f3" stroke="#ec4899" stroke-width="1.5"/>
                    <text x="57" y="50" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#9d174d">Signature</text>
                    <text x="57" y="66" text-anchor="middle" font-family="monospace" font-size="8" fill="#be185d">Base64</text>

                    <line x1="116" y1="54" x2="172" y2="54" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="172,49 182,54 172,59" fill="#94a3b8"/>

                    <rect x="186" y="28" width="120" height="52" rx="8" fill="#059669" stroke="#047857" stroke-width="1.5"/>
                    <text x="246" y="50" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#fff">Decrypt</text>
                    <text x="246" y="66" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#d1fae5">w/ Public Key</text>

                    <rect x="186" y="85" width="120" height="22" rx="4" fill="#ecfdf5" stroke="#a7f3d0" stroke-width="1"/>
                    <text x="246" y="100" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="8" font-weight="500" fill="#047857">Public Key (e, n)</text>

                    <line x1="310" y1="54" x2="366" y2="54" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="366,49 376,54 366,59" fill="#94a3b8"/>

                    <rect x="380" y="28" width="100" height="52" rx="8" fill="#f1f5f9" stroke="#cbd5e1" stroke-width="1.5"/>
                    <text x="430" y="50" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#334155">Hash'</text>
                    <text x="430" y="66" text-anchor="middle" font-family="monospace" font-size="8" fill="#64748b">a3f2...9b71</text>

                    <!-- Bottom path: Message -> Hash -> Hash -->
                    <text x="57" y="128" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" font-weight="600" fill="#94a3b8">PATH B</text>
                    <rect x="2" y="138" width="110" height="52" rx="8" fill="#dbeafe" stroke="#3b82f6" stroke-width="1.5"/>
                    <text x="57" y="160" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#1e40af">Message</text>
                    <text x="57" y="176" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#3b82f6">"Hello World"</text>

                    <line x1="116" y1="164" x2="172" y2="164" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="172,159 182,164 172,169" fill="#94a3b8"/>

                    <rect x="186" y="138" width="120" height="52" rx="8" fill="#fef3c7" stroke="#f59e0b" stroke-width="1.5"/>
                    <text x="246" y="160" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#92400e">SHA-256</text>
                    <text x="246" y="176" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#b45309">Hash Function</text>

                    <line x1="310" y1="164" x2="366" y2="164" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="366,159 376,164 366,169" fill="#94a3b8"/>

                    <rect x="380" y="138" width="100" height="52" rx="8" fill="#f1f5f9" stroke="#cbd5e1" stroke-width="1.5"/>
                    <text x="430" y="160" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#334155">Hash</text>
                    <text x="430" y="176" text-anchor="middle" font-family="monospace" font-size="8" fill="#64748b">a3f2...9b71</text>

                    <!-- Compare arrows converge -->
                    <line x1="484" y1="54" x2="540" y2="100" stroke="#059669" stroke-width="1.5" stroke-dasharray="4,3"/>
                    <line x1="484" y1="164" x2="540" y2="118" stroke="#059669" stroke-width="1.5" stroke-dasharray="4,3"/>

                    <!-- Compare box -->
                    <rect x="540" y="88" width="80" height="42" rx="8" fill="#fff" stroke="#059669" stroke-width="2"/>
                    <text x="580" y="114" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="700" fill="#059669">Match?</text>

                    <!-- Result arrow -->
                    <line x1="624" y1="109" x2="660" y2="109" stroke="#059669" stroke-width="1.5"/>
                    <polygon points="660,104 670,109 660,114" fill="#059669"/>

                    <!-- Valid result -->
                    <rect x="674" y="88" width="80" height="42" rx="8" fill="#ecfdf5" stroke="#059669" stroke-width="2"/>
                    <text x="714" y="106" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="12" font-weight="700" fill="#059669">VALID</text>
                    <text x="714" y="120" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="8" fill="#047857">Authentic</text>
                </svg>
            </div>
            <ol style="color:var(--text-secondary);font-size:0.8125rem;padding-left:1.25rem;line-height:1.9;margin-bottom:1.5rem;">
                <li><strong>Path A:</strong> The signature is decrypted using the signer's <strong>public key</strong>, recovering the original hash digest.</li>
                <li><strong>Path B:</strong> The received message is independently hashed using the same algorithm (e.g., SHA-256).</li>
                <li>The two hash values are <strong>compared</strong>. If they match, the signature is valid &mdash; the message is authentic and untampered.</li>
            </ol>

            <!-- Key sizes -->
            <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.75rem;color:var(--text-primary);">Key Size Recommendations</h3>
            <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:0.5rem;">
                <div style="text-align:center;padding:0.75rem 0.5rem;border-radius:0.5rem;border:1.5px solid var(--border);">
                    <div style="font-size:1.125rem;font-weight:700;color:var(--text-muted);">512</div>
                    <div style="font-size:0.6875rem;color:#ef4444;font-weight:600;">Broken</div>
                </div>
                <div style="text-align:center;padding:0.75rem 0.5rem;border-radius:0.5rem;border:1.5px solid var(--border);">
                    <div style="font-size:1.125rem;font-weight:700;color:var(--text-muted);">1024</div>
                    <div style="font-size:0.6875rem;color:#f59e0b;font-weight:600;">Deprecated</div>
                </div>
                <div style="text-align:center;padding:0.75rem 0.5rem;border-radius:0.5rem;border:1.5px solid #059669;background:var(--tool-light);">
                    <div style="font-size:1.125rem;font-weight:700;color:#059669;">2048</div>
                    <div style="font-size:0.6875rem;color:#059669;font-weight:600;">Recommended</div>
                </div>
                <div style="text-align:center;padding:0.75rem 0.5rem;border-radius:0.5rem;border:1.5px solid var(--border);">
                    <div style="font-size:1.125rem;font-weight:700;color:var(--text-primary);">4096</div>
                    <div style="font-size:0.6875rem;color:#059669;font-weight:600;">High Security</div>
                </div>
            </div>
        </div>

        <!-- RSASSA-PSS vs PKCS1-v1_5 -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">RSASSA-PSS vs RSASSA-PKCS1-v1_5</h2>
            <table class="compare-table">
                <thead><tr><th>Property</th><th>RSASSA-PKCS1-v1_5</th><th>RSASSA-PSS</th></tr></thead>
                <tbody>
                    <tr><td>Type</td><td>Deterministic</td><td>Probabilistic (random salt)</td></tr>
                    <tr><td>Security Proof</td><td>No formal proof</td><td>Formal security proof</td></tr>
                    <tr><td>Same Input = Same Output?</td><td>Yes</td><td>No (different each time)</td></tr>
                    <tr><td>Recommendation</td><td>Legacy compatibility</td><td>New applications</td></tr>
                    <tr><td>Algorithm Names</td><td>SHA256withRSA, SHA512withRSA</td><td>RSASSA-PSS, SHA256WithRSA/PSS</td></tr>
                    <tr><td>Use Cases</td><td>TLS, X.509, existing systems</td><td>Modern apps, enhanced security</td></tr>
                </tbody>
            </table>
        </div>

        <!-- Common Use Cases -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Use Cases</h2>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1.25rem;">
                <div style="text-align:center;">
                    <div style="margin-bottom:0.5rem;"><svg viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="1.5" style="width:28px;height:28px;display:inline-block;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg></div>
                    <h3 style="font-size:0.9375rem;font-weight:600;margin-bottom:0.375rem;color:var(--text-primary);">Document Signing</h3>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;">Sign contracts, PDFs, and legal documents to prove authenticity and prevent tampering.</p>
                </div>
                <div style="text-align:center;">
                    <div style="margin-bottom:0.5rem;"><svg viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="1.5" style="width:28px;height:28px;display:inline-block;"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg></div>
                    <h3 style="font-size:0.9375rem;font-weight:600;margin-bottom:0.375rem;color:var(--text-primary);">Code Signing</h3>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;">Sign binaries and executables to verify publisher identity. Essential for app stores.</p>
                </div>
                <div style="text-align:center;">
                    <div style="margin-bottom:0.5rem;"><svg viewBox="0 0 24 24" fill="none" stroke="#8b5cf6" stroke-width="1.5" style="width:28px;height:28px;display:inline-block;"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22 6 12 13 2 6"/></svg></div>
                    <h3 style="font-size:0.9375rem;font-weight:600;margin-bottom:0.375rem;color:var(--text-primary);">Email (S/MIME)</h3>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;">Sign emails to prove sender identity and message integrity. Combats phishing.</p>
                </div>
                <div style="text-align:center;">
                    <div style="margin-bottom:0.5rem;"><svg viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="1.5" style="width:28px;height:28px;display:inline-block;"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg></div>
                    <h3 style="font-size:0.9375rem;font-weight:600;margin-bottom:0.375rem;color:var(--text-primary);">API Authentication</h3>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;">Sign API requests for OAuth, JWT tokens, and webhook verification.</p>
                </div>
            </div>
        </div>

        <!-- Security Best Practices -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Security Best Practices</h2>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;">
                <div>
                    <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:#059669;">Do's</h3>
                    <ul style="color:var(--text-secondary);font-size:0.8125rem;padding-left:1.25rem;line-height:1.8;">
                        <li>Use <strong>2048-bit or larger</strong> keys for production</li>
                        <li>Use <strong>SHA-256 or stronger</strong> hash algorithms</li>
                        <li>Consider <strong>RSASSA-PSS</strong> for new applications</li>
                        <li>Keep your <strong>private key secure</strong></li>
                        <li>Use <strong>HSMs</strong> for high-value signing keys</li>
                        <li>Rotate keys periodically</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:#ef4444;">Don'ts</h3>
                    <ul style="color:var(--text-secondary);font-size:0.8125rem;padding-left:1.25rem;line-height:1.8;">
                        <li>Don't use <strong>MD5 or SHA-1</strong> for new signatures</li>
                        <li>Don't use <strong>512-bit or 1024-bit</strong> in production</li>
                        <li>Don't <strong>share your private key</strong></li>
                        <li>Don't reuse keys across applications</li>
                        <li>Don't assume signatures provide confidentiality</li>
                        <li>Don't use same key for signing and encryption</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Code Examples -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Code Examples</h2>

            <!-- Language Tabs -->
            <div class="code-tabs" role="tablist">
                <button class="code-tab active" onclick="switchCodeTab('python',this)" role="tab">Python</button>
                <button class="code-tab" onclick="switchCodeTab('java',this)" role="tab">Java</button>
                <button class="code-tab" onclick="switchCodeTab('nodejs',this)" role="tab">Node.js</button>
                <button class="code-tab" onclick="switchCodeTab('go',this)" role="tab">Go</button>
                <button class="code-tab" onclick="switchCodeTab('openssl',this)" role="tab">OpenSSL</button>
            </div>

            <!-- Python -->
            <div class="code-tab-panel active" id="codePanel-python">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Python: RSA Sign &amp; Verify</span>
                        <button class="copy-cmd-btn" data-snippet="python">Copy</button>
                    </div>
                    <div class="terminal-body">from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa, padding

<code># Generate key pair</code>
private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
public_key = private_key.public_key()

<code># Sign</code>
message = b<code>"Hello, World!"</code>
signature = private_key.sign(message, padding.PKCS1v15(), hashes.SHA256())
print(f<code>"Signature (hex): {signature.hex()[:64]}..."</code>)

<code># Verify</code>
try:
    public_key.verify(signature, message, padding.PKCS1v15(), hashes.SHA256())
    print(<code>"Signature is valid"</code>)
except Exception:
    print(<code>"Signature is invalid"</code>)</div>
                </div>
            </div>

            <!-- Java -->
            <div class="code-tab-panel" id="codePanel-java">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Java: RSA Sign &amp; Verify</span>
                        <button class="copy-cmd-btn" data-snippet="java">Copy</button>
                    </div>
                    <div class="terminal-body">import java.security.*;
import java.util.Base64;

KeyPairGenerator keyGen = KeyPairGenerator.getInstance(<code>"RSA"</code>);
keyGen.initialize(2048);
KeyPair keyPair = keyGen.generateKeyPair();

<code>// Sign</code>
Signature sign = Signature.getInstance(<code>"SHA256withRSA"</code>);
sign.initSign(keyPair.getPrivate());
sign.update(<code>"Hello"</code>.getBytes(<code>"UTF-8"</code>));
byte[] signature = sign.sign();

<code>// Verify</code>
Signature verify = Signature.getInstance(<code>"SHA256withRSA"</code>);
verify.initVerify(keyPair.getPublic());
verify.update(<code>"Hello"</code>.getBytes(<code>"UTF-8"</code>));
System.out.println(<code>"Valid: "</code> + verify.verify(signature));</div>
                </div>
            </div>

            <!-- Node.js -->
            <div class="code-tab-panel" id="codePanel-nodejs">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Node.js: RSA Sign &amp; Verify</span>
                        <button class="copy-cmd-btn" data-snippet="nodejs">Copy</button>
                    </div>
                    <div class="terminal-body">const crypto = require(<code>'crypto'</code>);

const { publicKey, privateKey } = crypto.generateKeyPairSync(<code>'rsa'</code>, {
    modulusLength: 2048,
    publicKeyEncoding: { type: <code>'spki'</code>, format: <code>'pem'</code> },
    privateKeyEncoding: { type: <code>'pkcs8'</code>, format: <code>'pem'</code> }
});

const sign = crypto.createSign(<code>'SHA256'</code>);
sign.update(<code>'Hello, World!'</code>);
const signature = sign.sign(privateKey, <code>'base64'</code>);

const verify = crypto.createVerify(<code>'SHA256'</code>);
verify.update(<code>'Hello, World!'</code>);
console.log(<code>'Valid:'</code>, verify.verify(publicKey, signature, <code>'base64'</code>));</div>
                </div>
            </div>

            <!-- Go -->
            <div class="code-tab-panel" id="codePanel-go">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Go: RSA Sign &amp; Verify</span>
                        <button class="copy-cmd-btn" data-snippet="go">Copy</button>
                    </div>
                    <div class="terminal-body">package main
import (<code>"crypto"</code>; <code>"crypto/rand"</code>; <code>"crypto/rsa"</code>; <code>"crypto/sha256"</code>; <code>"fmt"</code>)

func main() {
    privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)
    message := []byte(<code>"Hello, World!"</code>)
    hashed := sha256.Sum256(message)
    sig, _ := rsa.SignPKCS1v15(rand.Reader, privateKey, crypto.SHA256, hashed[:])
    err := rsa.VerifyPKCS1v15(&amp;privateKey.PublicKey, crypto.SHA256, hashed[:], sig)
    if err == nil { fmt.Println(<code>"Valid"</code>) }
}</div>
                </div>
            </div>

            <!-- OpenSSL -->
            <div class="code-tab-panel" id="codePanel-openssl">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>OpenSSL: RSA Sign &amp; Verify</span>
                        <button class="copy-cmd-btn" data-snippet="openssl">Copy</button>
                    </div>
                    <div class="terminal-body"><code># Generate key pair</code>
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -pubout -out public.pem

<code># Sign</code>
echo -n <code>"Hello"</code> > msg.txt
openssl dgst -sha256 -sign private.pem -out sig.bin msg.txt

<code># Verify</code>
openssl dgst -sha256 -verify public.pem -signature sig.bin msg.txt</div>
                </div>
            </div>
        </div>

        <!-- FAQ -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is an RSA digital signature?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">An RSA digital signature is a cryptographic mechanism that allows you to sign a message with your private key to prove authenticity and integrity. The signature is created by hashing the message and encrypting the hash with your private key. Anyone can verify the signature using your public key.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I sign a message with RSA?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Generate or provide an RSA key pair, select Sign mode, choose a signature algorithm (SHA256withRSA recommended), enter your message, and click Process. The tool generates a Base64-encoded signature you can copy and share.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What signature algorithms are supported?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">SHA256withRSA (recommended), SHA1withRSA, SHA384withRSA, SHA512withRSA, MD5withRSA, RSASSA-PSS variants (SHA1WithRSA/PSS, SHA224WithRSA/PSS, SHA384WithRSA/PSS), and SHA1withRSAandMGF1. Avoid MD5 and SHA-1 for new implementations.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What's the difference between RSASSA-PSS and PKCS1-v1_5?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PKCS1-v1_5 is deterministic (same message = same signature). PSS uses random padding, making each signature unique. PSS has a formal security proof and is recommended for new applications, though PKCS1-v1_5 remains widely used for compatibility.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I verify an RSA signature?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Switch to Verify mode, enter the original message, paste the Base64-encoded signature, ensure the public key is present, select the same algorithm used for signing, and click Process. The tool shows whether the signature is valid or invalid.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I sign and verify with RSA in Python?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Install the <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">cryptography</code> library, then use <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">private_key.sign(message, padding.PKCS1v15(), hashes.SHA256())</code> and <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">public_key.verify(signature, message, padding.PKCS1v15(), hashes.SHA256())</code>. Use the Python tab above to try it live.</div>
            </div>
        </div>

        <!-- Standards & References -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Standards &amp; References</h2>
            <ul style="color:var(--text-secondary);font-size:0.875rem;padding-left:1.25rem;line-height:2;">
                <li><strong><a href="https://tools.ietf.org/html/rfc8017" target="_blank" rel="noopener" style="color:var(--tool-primary);">RFC 8017</a>:</strong> PKCS #1: RSA Cryptography Specifications Version 2.2</li>
                <li><strong><a href="https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5.pdf" target="_blank" rel="noopener" style="color:var(--tool-primary);">FIPS 186-5</a>:</strong> Digital Signature Standard (DSS)</li>
                <li><strong><a href="https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final" target="_blank" rel="noopener" style="color:var(--tool-primary);">NIST SP 800-57</a>:</strong> Recommendation for Key Management</li>
            </ul>
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
    (function() {
    'use strict';

    var currentMode = 'sign';
    var lastResponse = null;
    var modeBtns = document.querySelectorAll('.rsa-mode-btn');
    var keySizeBtns = document.querySelectorAll('.rsa-keysize-btn');
    var messageLabel = document.getElementById('messageLabel');
    var messageInput = document.getElementById('message');
    var sigGroup = document.getElementById('sigGroup');
    var submitBtn = document.getElementById('submitBtn');
    var displaySection = document.getElementById('displaySection');
    var resultActions = document.getElementById('resultActions');
    var useForVerifyBtn = document.getElementById('useForVerifyBtn');

    // ========== Flow Animation ==========

    function updateFlowAnimation(mode) {
        var flowLabel = document.getElementById('flowModeLabel');
        var flowBoxLeft = document.getElementById('flowBoxLeft');
        var flowBoxRight = document.getElementById('flowBoxRight');
        var flowKeyLabel = document.getElementById('flowKeyLabel');
        var flowArrow1 = document.getElementById('flowArrow1');
        var flowArrow2 = document.getElementById('flowArrow2');
        if (!flowLabel) return;

        if (mode === 'verify') {
            flowLabel.textContent = 'Verification';
            flowBoxLeft.textContent = 'Signature';
            flowBoxLeft.className = 'rsa-flow-box flow-signature';
            flowBoxRight.textContent = 'Valid';
            flowBoxRight.className = 'rsa-flow-box flow-message';
            flowKeyLabel.textContent = '+ Public Key';
            flowArrow1.classList.add('reverse');
            flowArrow2.classList.add('reverse');
        } else {
            flowLabel.textContent = 'Signing';
            flowBoxLeft.textContent = 'Message';
            flowBoxLeft.className = 'rsa-flow-box flow-message';
            flowBoxRight.textContent = 'Signature';
            flowBoxRight.className = 'rsa-flow-box flow-signature';
            flowKeyLabel.textContent = '+ Private Key';
            flowArrow1.classList.remove('reverse');
            flowArrow2.classList.remove('reverse');
        }
    }

    function updateFlowAlgo() {
        var label = document.getElementById('flowAlgoLabel');
        if (label) label.textContent = document.getElementById('algorithmSelect').value;
    }

    document.getElementById('algorithmSelect').addEventListener('change', updateFlowAlgo);

    // ========== Mode Toggle ==========

    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');

            if (mode === 'verify') {
                messageLabel.textContent = 'Message to Verify';
                messageInput.placeholder = 'Enter the message to verify...';
                sigGroup.classList.add('visible');
                submitBtn.textContent = 'Verify Signature';
            } else {
                messageLabel.textContent = 'Plaintext Message';
                messageInput.placeholder = 'Enter your message to sign...';
                sigGroup.classList.remove('visible');
                submitBtn.textContent = 'Sign Message';
            }
            updateFlowAnimation(mode);
        });
    });

    // ========== Key Size ==========

    keySizeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            keySizeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('hiddenKeySize').value = this.getAttribute('data-size');
        });
    });

    document.getElementById('generateBtn').addEventListener('click', function() {
        this.textContent = 'Generating...';
        this.disabled = true;
        document.getElementById('keyGenForm').submit();
    });

    // ========== Keys Toggle ==========

    document.getElementById('keysToggle').addEventListener('click', function() {
        this.classList.toggle('open');
        document.getElementById('keysBody').classList.toggle('open');
    });

    // ========== Copy Keys ==========

    document.querySelectorAll('.rsa-key-copy-btn[data-copy]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var id = this.getAttribute('data-copy');
            var text = document.getElementById(id).value;
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.copyToClipboard(text, 'Key copied!');
            } else {
                navigator.clipboard.writeText(text);
            }
        });
    });

    document.getElementById('copyBothKeys').addEventListener('click', function() {
        var both = '=== PUBLIC KEY ===\n' + document.getElementById('publicKey').value +
                   '\n\n=== PRIVATE KEY ===\n' + document.getElementById('privateKey').value;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(both, 'Both keys copied!');
        } else {
            navigator.clipboard.writeText(both);
        }
    });

    // ========== Submit Sign/Verify ==========

    function showLoading() {
        displaySection.innerHTML = '<div class="rsa-loading">Processing...</div>';
        resultActions.classList.remove('visible');
    }

    function showError(msg) {
        displaySection.innerHTML = '<div class="rsa-error">' + msg + '</div>';
        resultActions.classList.remove('visible');
    }

    submitBtn.addEventListener('click', function() {
        var msg = messageInput.value.trim();
        var sig = document.getElementById('signature').value.trim();
        var pubKey = document.getElementById('publicKey').value.trim();
        var privKey = document.getElementById('privateKey').value.trim();
        var algo = document.getElementById('algorithmSelect').value;

        // encryptdecryptparameter quirk: decryprt=Sign, encrypt=Verify
        var operation = currentMode === 'sign' ? 'decryprt' : 'encrypt';

        if (!msg) { showError('Message is required.'); messageInput.focus(); return; }
        if (currentMode === 'verify' && !sig) { showError('Signature is required for verification.'); document.getElementById('signature').focus(); return; }
        if (currentMode === 'verify' && !pubKey) { showError('Public key is required for verification.'); return; }
        if (currentMode === 'sign' && !privKey) { showError('Private key is required for signing.'); return; }

        showLoading();

        var params = new URLSearchParams();
        params.append('methodName', 'RSA_SIGN_VERIFY_MESSAGEE');
        params.append('encryptdecryptparameter', operation);
        params.append('cipherparameter', algo);
        params.append('message', msg);
        params.append('signature', sig);
        params.append('publickeyparam', pubKey);
        params.append('privatekeyparam', privKey);

        fetch('RSAFunctionality', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(r) { return r.json(); })
        .then(function(json) {
            lastResponse = json;
            renderOutput(json);
        })
        .catch(function(err) { showError('Request failed: ' + err.message); });
    });

    function renderOutput(response) {
        if (!response || typeof response !== 'object') { showError('Invalid response'); return; }

        if (!response.success) {
            displaySection.innerHTML = '<div class="rsa-error"><strong>Error:</strong> ' +
                (response.errorMessage || 'Unknown error') + '</div>';
            resultActions.classList.remove('visible');
            return;
        }

        var isSign = response.operation === 'sign';
        var html = '';

        if (isSign) {
            html += '<div style="display:flex;align-items:center;gap:0.5rem;margin-bottom:1rem;">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2" style="width:20px;height:20px;"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>' +
                '<strong style="color:#059669;">Success</strong></div>';

            html += '<div style="display:flex;gap:1.5rem;margin-bottom:1rem;font-size:0.8125rem;">' +
                '<div><span style="color:var(--text-muted);">Operation:</span> <strong>' + response.operation.toUpperCase() + '</strong></div>' +
                '<div><span style="color:var(--text-muted);">Algorithm:</span> <strong>' + response.algorithm + '</strong></div></div>';

            if (response.originalMessage) {
                html += '<div style="margin-bottom:1rem;"><label class="tool-label">Original Message</label>' +
                    '<div style="background:var(--bg-secondary);padding:0.5rem 0.75rem;border-radius:0.5rem;border:1px solid var(--border);font-size:0.8125rem;font-family:var(--font-mono);max-height:100px;overflow-y:auto;">' +
                    escapeHtml(response.originalMessage) + '</div></div>';
            }

            html += '<div><label class="tool-label">Signature (Base64)</label>' +
                '<textarea class="tool-input" id="resultSignature" rows="5" readonly style="font-size:0.75rem;">' +
                escapeHtml(response.base64Encoded) + '</textarea></div>';

            resultActions.classList.add('visible');
            useForVerifyBtn.style.display = '';
        } else {
            var isValid = response.message === 'VALID' || (response.base64Encoded && response.base64Encoded.toLowerCase().indexOf('passed') !== -1);

            if (isValid) {
                html += '<div class="rsa-result-valid">' +
                    '<div style="display:flex;align-items:center;gap:0.5rem;margin-bottom:0.75rem;">' +
                    '<svg viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2.5" style="width:24px;height:24px;"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>' +
                    '<strong style="font-size:1.125rem;color:#059669;">Signature Valid</strong></div>' +
                    '<p style="color:var(--text-secondary);font-size:0.875rem;margin:0;">The signature is authentic and the message has not been tampered with.</p></div>';
            } else {
                html += '<div class="rsa-result-invalid">' +
                    '<div style="display:flex;align-items:center;gap:0.5rem;margin-bottom:0.75rem;">' +
                    '<svg viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5" style="width:24px;height:24px;"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>' +
                    '<strong style="font-size:1.125rem;color:#ef4444;">Signature Invalid</strong></div>' +
                    '<p style="color:var(--text-secondary);font-size:0.875rem;margin:0;">The signature does not match. The message may have been modified or the wrong key was used.</p></div>';
            }

            html += '<div style="display:flex;gap:1.5rem;margin-top:1rem;font-size:0.8125rem;">' +
                '<div><span style="color:var(--text-muted);">Operation:</span> <strong>' + response.operation.toUpperCase() + '</strong></div>' +
                '<div><span style="color:var(--text-muted);">Algorithm:</span> <strong>' + response.algorithm + '</strong></div></div>';

            resultActions.classList.remove('visible');
            useForVerifyBtn.style.display = 'none';
        }

        displaySection.innerHTML = html;
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    // ========== Use for Verification ==========

    useForVerifyBtn.addEventListener('click', function() {
        var sigTextarea = document.getElementById('resultSignature');
        if (sigTextarea) {
            document.getElementById('signature').value = sigTextarea.value;
        }
        // Switch to verify mode
        var verifyBtn = document.querySelector('.rsa-mode-btn[data-mode="verify"]');
        if (verifyBtn) verifyBtn.click();
        messageInput.focus();
    });

    // ========== Copy Result ==========

    document.getElementById('copyResultBtn').addEventListener('click', function() {
        var sigTextarea = document.getElementById('resultSignature');
        var text = sigTextarea ? sigTextarea.value : displaySection.textContent;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(text, 'Copied!');
        } else {
            navigator.clipboard.writeText(text);
        }
    });

    // ========== Download JSON ==========

    document.getElementById('downloadBtn').addEventListener('click', function() {
        if (!lastResponse) return;
        var output = {
            tool: '8gwifi.org/rsasignverifyfunctions.jsp',
            operation: lastResponse.operation,
            algorithm: lastResponse.algorithm,
            success: lastResponse.success,
            originalMessage: lastResponse.originalMessage || messageInput.value,
            signature: lastResponse.base64Encoded || '',
            verificationResult: lastResponse.message || '',
            timestamp: new Date().toISOString()
        };
        var json = JSON.stringify(output, null, 2);
        var filename = lastResponse.operation === 'sign' ? 'rsa-signature.json' : 'rsa-verify.json';
        if (typeof ToolUtils !== 'undefined' && ToolUtils.downloadAsFile) {
            ToolUtils.downloadAsFile(json, filename, { toolName: 'RSA Sign & Verify' });
        } else {
            var blob = new Blob([json], { type: 'application/json' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url; a.download = filename;
            document.body.appendChild(a); a.click();
            document.body.removeChild(a); URL.revokeObjectURL(url);
        }
    });

    // ========== Share URL ==========

    document.getElementById('shareBtn').addEventListener('click', function() {
        var params = {
            op: currentMode,
            algo: document.getElementById('algorithmSelect').value,
            msg: messageInput.value,
            pubkey: document.getElementById('publicKey').value
        };
        var sigTextarea = document.getElementById('resultSignature');
        if (sigTextarea) params.sig = sigTextarea.value;

        var pageBase = window.location.origin + '/rsasignverifyfunctions.jsp';
        if (typeof ToolUtils !== 'undefined' && ToolUtils.generateShareUrl) {
            var url = ToolUtils.generateShareUrl(params, { baseUrl: pageBase, toolName: 'RSA Sign & Verify' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        } else {
            var sp = new URLSearchParams(params);
            var url = pageBase + '?' + sp.toString();
            navigator.clipboard.writeText(url);
        }
    });

    // ========== Load from URL ==========

    (function() {
        var urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('msg')) messageInput.value = urlParams.get('msg');
        if (urlParams.has('sig')) document.getElementById('signature').value = urlParams.get('sig');
        if (urlParams.has('algo')) document.getElementById('algorithmSelect').value = urlParams.get('algo');
        if (urlParams.has('pubkey')) document.getElementById('publicKey').value = urlParams.get('pubkey');

        if (urlParams.has('sig') || urlParams.get('op') === 'verify') {
            var verifyBtn = document.querySelector('.rsa-mode-btn[data-mode="verify"]');
            if (verifyBtn) verifyBtn.click();
        }
    })();

    // ========== Output Column Tabs ==========

    var outputTabs = document.querySelectorAll('.rsa-output-tab');
    var compilerLoaded = false;

    outputTabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            outputTabs.forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');
            document.querySelectorAll('.rsa-panel').forEach(function(p) { p.classList.remove('active'); });
            document.getElementById('panel-' + panel).classList.add('active');

            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Python Compiler Templates ==========

    function buildCompilerCode(template) {
        var pubKey = document.getElementById('publicKey').value.trim();
        var privKey = document.getElementById('privateKey').value.trim();
        var msg = messageInput.value.trim() || 'Hello World';

        switch (template) {
            case 'sign':
                return 'from cryptography.hazmat.primitives import hashes, serialization\n' +
                    'from cryptography.hazmat.primitives.asymmetric import padding\n' +
                    'import base64\n\n' +
                    '# Load private key\nprivate_key_pem = """' + (privKey || 'YOUR_PRIVATE_KEY_HERE') + '"""\n\n' +
                    'from cryptography.hazmat.primitives.serialization import load_pem_private_key\n' +
                    'private_key = load_pem_private_key(private_key_pem.encode(), password=None)\n\n' +
                    'message = b"' + msg + '"\n' +
                    'signature = private_key.sign(message, padding.PKCS1v15(), hashes.SHA256())\n' +
                    'print("Signature:", base64.b64encode(signature).decode())';

            case 'verify':
                return 'from cryptography.hazmat.primitives import hashes, serialization\n' +
                    'from cryptography.hazmat.primitives.asymmetric import padding\n' +
                    'import base64\n\n' +
                    '# Load public key\npublic_key_pem = """' + (pubKey || 'YOUR_PUBLIC_KEY_HERE') + '"""\n\n' +
                    'from cryptography.hazmat.primitives.serialization import load_pem_public_key\n' +
                    'public_key = load_pem_public_key(public_key_pem.encode())\n\n' +
                    'message = b"' + msg + '"\n' +
                    'signature = base64.b64decode("YOUR_SIGNATURE_HERE")\n\n' +
                    'try:\n    public_key.verify(signature, message, padding.PKCS1v15(), hashes.SHA256())\n' +
                    '    print("Signature is VALID")\nexcept Exception as e:\n    print("Signature is INVALID:", e)';

            case 'keygen':
                return 'from cryptography.hazmat.primitives.asymmetric import rsa\n' +
                    'from cryptography.hazmat.primitives import serialization\n\n' +
                    'private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)\n' +
                    'public_key = private_key.public_key()\n\n' +
                    'priv_pem = private_key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption())\n' +
                    'pub_pem = public_key.public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)\n\n' +
                    'print(pub_pem.decode())\nprint(priv_pem.decode())';

            case 'pss':
                return 'from cryptography.hazmat.primitives import hashes\n' +
                    'from cryptography.hazmat.primitives.asymmetric import rsa, padding\nimport base64\n\n' +
                    'private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)\n' +
                    'public_key = private_key.public_key()\n\n' +
                    'message = b"' + msg + '"\n' +
                    'signature = private_key.sign(message,\n    padding.PSS(mgf=padding.MGF1(hashes.SHA256()), salt_length=padding.PSS.MAX_LENGTH),\n    hashes.SHA256())\n' +
                    'print("PSS Signature:", base64.b64encode(signature).decode()[:64], "...")\n\n' +
                    'try:\n    public_key.verify(signature, message,\n        padding.PSS(mgf=padding.MGF1(hashes.SHA256()), salt_length=padding.PSS.MAX_LENGTH),\n        hashes.SHA256())\n' +
                    '    print("PSS Verification: VALID")\nexcept Exception as e:\n    print("INVALID:", e)';

            case 'pkcs1':
                return 'from cryptography.hazmat.primitives import hashes\n' +
                    'from cryptography.hazmat.primitives.asymmetric import rsa, padding\nimport base64\n\n' +
                    'private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)\n' +
                    'public_key = private_key.public_key()\n\n' +
                    'message = b"' + msg + '"\n' +
                    'signature = private_key.sign(message, padding.PKCS1v15(), hashes.SHA256())\n' +
                    'print("PKCS1v15 Signature:", base64.b64encode(signature).decode()[:64], "...")\n\n' +
                    'try:\n    public_key.verify(signature, message, padding.PKCS1v15(), hashes.SHA256())\n' +
                    '    print("PKCS1v15 Verification: VALID")\nexcept Exception as e:\n    print("INVALID:", e)';

            default: return '';
        }
    }

    function loadCompilerWithTemplate() {
        var template = document.getElementById('compilerTemplate').value;
        var code = buildCompilerCode(template);
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({lang: 'python', code: b64Code});
        var iframe = document.getElementById('compilerIframe');
        iframe.src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    document.getElementById('compilerTemplate').addEventListener('change', function() {
        compilerLoaded = false;
        loadCompilerWithTemplate();
        compilerLoaded = true;
    });

    // ========== Code Example Tabs ==========

    window.switchCodeTab = function(lang, btn) {
        document.querySelectorAll('.code-tab').forEach(function(t) { t.classList.remove('active'); });
        document.querySelectorAll('.code-tab-panel').forEach(function(p) { p.classList.remove('active'); });
        btn.classList.add('active');
        var panel = document.getElementById('codePanel-' + lang);
        if (panel) panel.classList.add('active');
    };

    // ========== FAQ Toggle ==========

    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Code Snippet Copy ==========

    var codeSnippets = {
        python: 'from cryptography.hazmat.primitives import hashes, serialization\nfrom cryptography.hazmat.primitives.asymmetric import rsa, padding\n\n# Generate key pair\nprivate_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)\npublic_key = private_key.public_key()\n\n# Sign\nmessage = b"Hello, World!"\nsignature = private_key.sign(message, padding.PKCS1v15(), hashes.SHA256())\nprint(f"Signature (hex): {signature.hex()[:64]}...")\n\n# Verify\ntry:\n    public_key.verify(signature, message, padding.PKCS1v15(), hashes.SHA256())\n    print("Signature is valid")\nexcept Exception:\n    print("Signature is invalid")',

        java: 'import java.security.*;\nimport java.util.Base64;\n\nKeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");\nkeyGen.initialize(2048);\nKeyPair keyPair = keyGen.generateKeyPair();\n\n// Sign\nSignature sign = Signature.getInstance("SHA256withRSA");\nsign.initSign(keyPair.getPrivate());\nsign.update("Hello".getBytes("UTF-8"));\nbyte[] signature = sign.sign();\n\n// Verify\nSignature verify = Signature.getInstance("SHA256withRSA");\nverify.initVerify(keyPair.getPublic());\nverify.update("Hello".getBytes("UTF-8"));\nSystem.out.println("Valid: " + verify.verify(signature));',

        nodejs: 'const crypto = require(\'crypto\');\n\nconst { publicKey, privateKey } = crypto.generateKeyPairSync(\'rsa\', {\n    modulusLength: 2048,\n    publicKeyEncoding: { type: \'spki\', format: \'pem\' },\n    privateKeyEncoding: { type: \'pkcs8\', format: \'pem\' }\n});\n\nconst sign = crypto.createSign(\'SHA256\');\nsign.update(\'Hello, World!\');\nconst signature = sign.sign(privateKey, \'base64\');\n\nconst verify = crypto.createVerify(\'SHA256\');\nverify.update(\'Hello, World!\');\nconsole.log(\'Valid:\', verify.verify(publicKey, signature, \'base64\'));',

        go: 'package main\nimport ("crypto"; "crypto/rand"; "crypto/rsa"; "crypto/sha256"; "fmt")\n\nfunc main() {\n    privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)\n    message := []byte("Hello, World!")\n    hashed := sha256.Sum256(message)\n    sig, _ := rsa.SignPKCS1v15(rand.Reader, privateKey, crypto.SHA256, hashed[:])\n    err := rsa.VerifyPKCS1v15(&privateKey.PublicKey, crypto.SHA256, hashed[:], sig)\n    if err == nil { fmt.Println("Valid") }\n}',

        openssl: '# Generate key pair\nopenssl genrsa -out private.pem 2048\nopenssl rsa -in private.pem -pubout -out public.pem\n\n# Sign\necho -n "Hello" > msg.txt\nopenssl dgst -sha256 -sign private.pem -out sig.bin msg.txt\n\n# Verify\nopenssl dgst -sha256 -verify public.pem -signature sig.bin msg.txt'
    };

    document.querySelectorAll('.copy-cmd-btn[data-snippet]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var code = codeSnippets[this.getAttribute('data-snippet')];
            if (code) {
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.copyToClipboard(code, 'Code copied!');
                } else {
                    navigator.clipboard.writeText(code);
                }
            }
        });
    });

    })();
    </script>
</body>
</html>
