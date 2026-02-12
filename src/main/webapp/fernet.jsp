<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@page import="z.y.x.Security.fernetpojo"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
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

    <!-- Critical CSS - inlined for zero render-blocking requests on mobile -->
    <style>
        /* Reset */
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        *:focus-visible{outline:2px solid var(--primary);outline-offset:2px}
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}

        /* Design tokens */
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
            --tool-primary:#8b5cf6;--tool-primary-dark:#7c3aed;--tool-gradient:linear-gradient(135deg,#8b5cf6 0%,#7c3aed 100%);--tool-light:#f5f3ff
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(139,92,246,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}

        /* Nav header */
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

        /* Page header + breadcrumbs */
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}

        /* Description section */
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}

        /* Three-column grid */
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) 1fr 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) 1fr}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}

        /* Card + form (above-fold) */
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:1rem;transition:opacity .15s,transform .15s}

        /* Result card */
        .tool-result-card{display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions.visible{display:flex}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}

        /* Empty state */
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}

        /* Dark mode (above-fold elements) */
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary,#cbd5e1)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(139,92,246,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}

        /* Utility */
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Fernet Encrypt & Decrypt Online - Key Generator" />
        <jsp:param name="toolDescription" value="Encrypt & decrypt Fernet tokens instantly. Generate keys, inspect token fields (IV, timestamp, HMAC). Python-compatible. Free, no signup, no data stored." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="fernet.jsp" />
        <jsp:param name="toolKeywords" value="fernet encryption online, fernet decryption online, generate fernet key, fernet token, AES-128-CBC, HMAC-SHA256, base64url key, python fernet, cryptography fernet, fernet encrypt decrypt, symmetric encryption online, fernet key generator, fernet token decoder, authenticated encryption" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Generate Fernet keys (base64url),Encrypt plaintext to Fernet tokens,Decrypt Fernet tokens to plaintext,AES-128-CBC with HMAC-SHA256,Token structure breakdown (version/IV/timestamp/HMAC),Copy and share results,Works with Python cryptography library,No data stored on server" />
        <jsp:param name="hasSteps" value="false" />
        <jsp:param name="faq1q" value="What is a Fernet key and how is it formatted?" />
        <jsp:param name="faq1a" value="A Fernet key is 32 bytes, base64url (URL-safe) encoded. It contains a 128-bit signing key and a 128-bit encryption key concatenated together. The key is used for both HMAC-SHA256 authentication and AES-128-CBC encryption." />
        <jsp:param name="faq2q" value="Which algorithms does Fernet use?" />
        <jsp:param name="faq2a" value="Fernet uses AES-128 in CBC mode for encryption and HMAC-SHA256 for authentication. The signing key handles HMAC and the encryption key handles AES. All encryption is authenticated, meaning tampering is detected before any plaintext is returned." />
        <jsp:param name="faq3q" value="How do I decrypt a Fernet token?" />
        <jsp:param name="faq3a" value="Select Decrypt mode, paste the Fernet token into the message field, enter the same base64url-encoded key that was used for encryption, and click Decrypt. The tool verifies the HMAC, checks the version byte, and returns the original plaintext." />
        <jsp:param name="faq4q" value="Does this tool store my messages or keys?" />
        <jsp:param name="faq4a" value="No. Encryption and decryption are processed server-side but no data is stored, logged, or transmitted to third parties. For maximum security, you can use the Python cryptography library locally." />
        <jsp:param name="faq5q" value="Is Fernet the same as AES encryption?" />
        <jsp:param name="faq5a" value="Fernet is built on top of AES-128-CBC but adds authenticated encryption via HMAC-SHA256, a version byte, a timestamp, and a random IV. Raw AES does not include authentication, so Fernet provides stronger guarantees against tampering." />
        <jsp:param name="faq6q" value="How do I use Fernet encryption in Python?" />
        <jsp:param name="faq6a" value="Install the cryptography library with pip install cryptography. Then use: from cryptography.fernet import Fernet; key = Fernet.generate_key(); f = Fernet(key); token = f.encrypt(b'message'); print(f.decrypt(token)). Tokens generated by this tool are fully compatible with Python Fernet." />
    </jsp:include>

    <!-- HowTo JSON-LD Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt and Decrypt with Fernet",
        "description": "Use this free online Fernet tool to generate keys, encrypt plaintext to tokens, and decrypt tokens back to text using AES-128-CBC with HMAC-SHA256.",
        "totalTime": "PT30S",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Generate or Enter Fernet Key",
                "text": "A Fernet key is pre-generated on page load. You can click Generate to create a new key, or paste your own base64url-encoded key into the key field.",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Enter Message and Select Mode",
                "text": "Type your plaintext message to encrypt or paste a Fernet token to decrypt. Use the Encrypt/Decrypt toggle to select the operation mode.",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "View and Copy Results",
                "text": "Click the action button to process. The encrypted token or decrypted plaintext appears in the output panel. Use Copy to clipboard or Share URL to save your results.",
                "position": 3
            }
        ]
    }
    </script>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS - all async (critical styles inlined above) -->
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
        /* Labels & inputs */
        .tool-label {
            display: block;
            font-weight: 600;
            font-size: 0.8125rem;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.375rem;
            letter-spacing: 0.01em;
        }

        .tool-hint {
            font-size: 0.6875rem;
            color: var(--text-secondary, #64748b);
            margin: 0.25rem 0 0 0;
            line-height: 1.4;
        }

        .tool-input {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-family: var(--font-mono);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .tool-input:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.15);
        }

        .tool-input::placeholder {
            color: #94a3b8;
            font-family: var(--font-sans);
            font-style: italic;
            font-size: 0.8125rem;
        }

        textarea.tool-input {
            resize: vertical;
            line-height: 1.5;
        }

        [data-theme="dark"] .tool-label { color: var(--text-primary, #e2e8f0); }
        [data-theme="dark"] .tool-hint { color: var(--text-secondary, #94a3b8); }
        [data-theme="dark"] .tool-input {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }
        [data-theme="dark"] .tool-input:focus {
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.25);
        }
        [data-theme="dark"] .tool-input::placeholder { color: #64748b; }

        /* Mode toggle (Encrypt/Decrypt buttons) */
        .fernet-mode-toggle {
            display: flex;
            gap: 0;
            margin-bottom: 1rem;
            border-radius: 0.5rem;
            overflow: hidden;
            border: 1.5px solid var(--border);
        }

        .fernet-mode-btn {
            flex: 1;
            padding: 0.625rem;
            font-weight: 600;
            font-size: 0.8125rem;
            border: none;
            cursor: pointer;
            background: var(--bg-secondary);
            color: var(--text-secondary);
            transition: all 0.15s;
            font-family: var(--font-sans);
        }

        .fernet-mode-btn.active {
            background: var(--tool-gradient);
            color: #fff;
        }

        .fernet-mode-btn:hover:not(.active) {
            background: var(--bg-tertiary);
        }

        [data-theme="dark"] .fernet-mode-btn { background: var(--bg-tertiary); color: var(--text-secondary); }
        [data-theme="dark"] .fernet-mode-btn.active { background: var(--tool-gradient); color: #fff; }
        [data-theme="dark"] .fernet-mode-btn:hover:not(.active) { background: rgba(255,255,255,0.08); }

        /* Key row (input + buttons) */
        .fernet-key-row {
            display: flex;
            gap: 0.5rem;
        }

        .fernet-key-row .tool-input { flex: 1; }

        .fernet-key-btn {
            padding: 0.5rem 0.75rem;
            border: 1.5px solid var(--border);
            border-radius: 0.5rem;
            background: var(--bg-secondary);
            color: var(--text-secondary);
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            font-family: var(--font-sans);
            transition: all 0.15s;
        }

        .fernet-key-btn:hover {
            border-color: var(--tool-primary);
            color: var(--tool-primary);
            background: var(--tool-light);
        }

        [data-theme="dark"] .fernet-key-btn {
            background: var(--bg-tertiary);
            border-color: var(--border);
            color: var(--text-secondary);
        }
        [data-theme="dark"] .fernet-key-btn:hover {
            border-color: var(--tool-primary);
            color: var(--tool-primary);
            background: rgba(139,92,246,0.15);
        }

        /* Style servlet HTML response within output area */
        #displaySection h4 {
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin: 1rem 0 0.375rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        #displaySection h4:first-child { margin-top: 0; }

        #displaySection textarea,
        #displaySection .form-control {
            width: 100%;
            padding: 0.625rem 0.75rem;
            border: 1.5px solid var(--border);
            border-radius: 0.5rem;
            font-family: var(--font-mono);
            font-size: 0.8125rem;
            background: var(--bg-secondary);
            color: var(--text-primary);
            resize: vertical;
        }

        [data-theme="dark"] #displaySection textarea,
        [data-theme="dark"] #displaySection .form-control {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary);
        }

        /* Loading state */
        .fernet-loading {
            text-align: center;
            padding: 2rem;
            color: var(--text-muted);
        }

        /* Error alert */
        .fernet-error {
            background: rgba(239,68,68,0.08);
            border: 1px solid rgba(239,68,68,0.3);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            color: var(--error, #ef4444);
            font-size: 0.8125rem;
            font-weight: 500;
        }

        /* Terminal blocks for educational content */
        .terminal-block {
            background: #1e1e1e;
            border-radius: 0.5rem;
            overflow: hidden;
            margin-bottom: 0.75rem;
        }

        .terminal-header {
            background: #323232;
            color: #d4d4d4;
            padding: 0.5rem 0.75rem;
            font-size: 0.75rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .terminal-body {
            padding: 0.75rem;
            color: #4ec9b0;
            font-family: var(--font-mono);
            font-size: 0.8rem;
            overflow-x: auto;
            white-space: pre;
            line-height: 1.6;
        }

        .terminal-body code { color: #ce9178; }

        .copy-cmd-btn {
            background: none;
            border: 1px solid rgba(255,255,255,0.2);
            color: #d4d4d4;
            padding: 0.2rem 0.5rem;
            border-radius: 0.25rem;
            cursor: pointer;
            font-size: 0.7rem;
            transition: all 0.15s;
        }

        .copy-cmd-btn:hover {
            background: rgba(255,255,255,0.1);
            border-color: rgba(255,255,255,0.4);
        }

        /* Token format table */
        .token-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.85rem;
            margin-top: 0.75rem;
        }

        .token-table thead th {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.5rem 0.75rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.8rem;
            color: var(--text-secondary, #475569);
            border-bottom: 2px solid var(--border, #e2e8f0);
        }

        .token-table tbody td {
            padding: 0.5rem 0.75rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            color: var(--text-primary, #0f172a);
        }

        .token-table tbody td:first-child {
            font-family: var(--font-mono);
            font-weight: 600;
            color: var(--tool-primary);
        }

        [data-theme="dark"] .token-table thead th {
            background: var(--bg-tertiary, #334155);
            border-bottom-color: var(--border, #475569);
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .token-table tbody td {
            border-bottom-color: var(--border, #334155);
            color: var(--text-primary, #f1f5f9);
        }

        /* FAQ section */
        .faq-item {
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
            overflow: hidden;
        }

        .faq-question {
            padding: 0.75rem 1rem;
            font-weight: 600;
            font-size: 0.875rem;
            color: var(--text-primary, #0f172a);
            background: var(--bg-secondary, #f8fafc);
            border: none;
            width: 100%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
            font-family: var(--font-sans);
            text-align: left;
        }

        .faq-question:hover { background: var(--bg-tertiary, #f1f5f9); }

        .faq-answer {
            display: none;
            padding: 0.75rem 1rem;
            font-size: 0.8125rem;
            line-height: 1.6;
            color: var(--text-secondary, #475569);
            border-top: 1px solid var(--border, #e2e8f0);
        }

        .faq-item.open .faq-answer { display: block; }
        .faq-item.open .faq-chevron { transform: rotate(180deg); }

        .faq-chevron {
            transition: transform 0.2s;
            flex-shrink: 0;
        }

        [data-theme="dark"] .faq-question {
            background: var(--bg-tertiary, #334155);
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .faq-question:hover { background: rgba(255,255,255,0.08); }

        [data-theme="dark"] .faq-answer {
            color: var(--text-secondary, #cbd5e1);
            border-top-color: var(--border, #475569);
        }

        [data-theme="dark"] .faq-item {
            border-color: var(--border, #334155);
        }

        /* Output column tabs */
        .fernet-output-tabs {
            display: flex;
            gap: 0;
            border: 1.5px solid var(--border);
            border-radius: 0.5rem;
            overflow: hidden;
            margin-bottom: 0.75rem;
        }

        .fernet-output-tab {
            flex: 1;
            padding: 0.5rem;
            font-weight: 600;
            font-size: 0.8125rem;
            border: none;
            cursor: pointer;
            background: var(--bg-secondary);
            color: var(--text-secondary);
            transition: all 0.15s;
            font-family: var(--font-sans);
            text-align: center;
        }

        .fernet-output-tab.active {
            background: var(--tool-gradient);
            color: #fff;
        }

        .fernet-output-tab:hover:not(.active) {
            background: var(--bg-tertiary);
        }

        [data-theme="dark"] .fernet-output-tab { background: var(--bg-tertiary); }
        [data-theme="dark"] .fernet-output-tab.active { background: var(--tool-gradient); color: #fff; }
        [data-theme="dark"] .fernet-output-tab:hover:not(.active) { background: rgba(255,255,255,0.08); }

        .fernet-panel { display: none; flex: 1; min-height: 0; }
        .fernet-panel.active { display: flex; flex-direction: column; }

        #panel-output .tool-result-card { flex: 1; }
        #panel-python { min-height: 540px; }

    </style>

    <%-- Server-side key generation scriptlet --%>
    <%
        String key = "";

        if (request.getSession().getAttribute("key") == null) {
            Gson gson = new Gson();
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "fernet/genkey";

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
            fernetpojo fernetpojo = (fernetpojo) gson.fromJson(content.toString(), fernetpojo.class);

            key = fernetpojo.getKey();
        } else {
            key = (String) request.getSession().getAttribute("key");
        }
    %>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Fernet Encrypt & Decrypt Online</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    Fernet
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">AES-128-CBC</span>
                <span class="tool-badge">HMAC-SHA256</span>
                <span class="tool-badge">Free</span>
                <span class="tool-badge">Python Compatible</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate Fernet keys, encrypt plaintext to tokens, and decrypt tokens back to text. Run Python Fernet code directly in your browser. AES-128-CBC + HMAC-SHA256. No data stored.</p>
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
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    Fernet Tool
                </div>
                <div class="tool-card-body">
                    <!-- Encrypt/Decrypt Toggle -->
                    <div class="fernet-mode-toggle">
                        <button type="button" class="fernet-mode-btn active" data-mode="encrypt">Encrypt</button>
                        <button type="button" class="fernet-mode-btn" data-mode="decrypt">Decrypt</button>
                    </div>

                    <!-- Fernet Key -->
                    <div class="tool-form-group">
                        <label class="tool-label" for="privatekeyparam">Fernet Key</label>
                        <div class="fernet-key-row">
                            <input type="text" class="tool-input" id="privatekeyparam" name="privatekeyparam" value="<%= key %>" placeholder="Base64-URL key">
                            <button type="button" class="fernet-key-btn" id="generateKeyBtn" title="Generate new key">Generate</button>
                            <button type="button" class="fernet-key-btn" id="copyKeyBtn" title="Copy key">Copy</button>
                        </div>
                        <p class="tool-hint">Base64-URL encoded key (32 bytes = signing key + encryption key)</p>
                    </div>

                    <!-- Message Input -->
                    <div class="tool-form-group">
                        <label class="tool-label" for="message" id="messageLabel">Plaintext Message</label>
                        <textarea class="tool-input" id="message" name="message" rows="5" placeholder="Enter text to encrypt..."></textarea>
                        <p class="tool-hint" id="messageHint">Text will be encrypted with AES-128-CBC</p>
                    </div>

                    <!-- Submit -->
                    <button type="button" class="tool-action-btn" id="submitBtn">Encrypt Message</button>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Tab bar -->
            <div class="fernet-output-tabs">
                <button type="button" class="fernet-output-tab active" data-panel="output">Output</button>
                <button type="button" class="fernet-output-tab" data-panel="python">Python</button>
            </div>

            <!-- Output Panel -->
            <div class="fernet-panel active" id="panel-output">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                        <h4>Output</h4>
                    </div>
                    <div class="tool-result-content" id="displaySection">
                        <div class="tool-empty-state" id="emptyState">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;margin-bottom:0.75rem;opacity:0.4;">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                <circle cx="12" cy="16" r="1"/>
                            </svg>
                            <h3>Fernet Encryption</h3>
                            <p>Enter a message and key, then click Encrypt or Decrypt.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn" id="copyResultBtn">
                            <span>&#128203;</span> Copy
                        </button>
                        <button type="button" class="tool-action-btn" id="downloadBtn">
                            <span>&#128229;</span> Download JSON
                        </button>
                        <button type="button" class="tool-action-btn" id="shareBtn">
                            <span>&#128279;</span> Share URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="fernet-panel" id="panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <h4>Python Compiler</h4>
                        <select id="compilerTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="encrypt">Encrypt with my key</option>
                            <option value="decrypt">Decrypt with my key</option>
                            <option value="keygen">Generate &amp; inspect key</option>
                            <option value="token-inspect">Inspect token fields</option>
                            <option value="pbkdf2">PBKDF2 password key</option>
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

    <!-- Hidden form for key generation (kept for servlet compatibility) -->
    <div style="display:none" aria-hidden="true">
        <form id="keyGenForm" action="CipherFunctionality" method="POST">
            <input type="hidden" name="methodName" value="FERNET_GENERATE_KEYPAIR">
        </form>
    </div>

    <!-- Mobile Ad Fallback -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="fernet.jsp"/>
        <jsp:param name="keyword" value="cryptography"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

        <!-- What is Fernet? -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is Fernet Encryption?</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">Fernet guarantees that a message encrypted using it cannot be manipulated or read without the key. All encryption uses <strong>AES-128</strong> in <strong>CBC</strong> mode with <strong>HMAC-SHA256</strong> authentication. The Fernet specification is part of the Python <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">cryptography</code> library and provides a simple, high-level symmetric encryption API.</p>
            <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">Unlike raw AES, Fernet is an <em>authenticated encryption</em> scheme: any tampering with the ciphertext is detected before any plaintext is returned. This prevents padding oracle attacks and other manipulation-based vulnerabilities.</p>
        </div>

        <!-- Key Format -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Fernet Key Format</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">A Fernet <em>key</em> is the base64url encoding of the following fields:</p>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Key Structure (32 bytes total)</span>
                </div>
                <div class="terminal-body">Signing-key (128 bits) || Encryption-key (128 bits)</div>
            </div>
            <p style="color: var(--text-secondary); margin-top: 0.75rem; line-height: 1.7;">The <strong>signing key</strong> (first 16 bytes) is used for HMAC-SHA256 authentication. The <strong>encryption key</strong> (last 16 bytes) is used for AES-128-CBC encryption. Both are generated from cryptographically secure random bytes.</p>
        </div>

        <!-- Token Format -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Fernet Token Format</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">A Fernet <em>token</em> is the base64url encoding of the concatenation of the following fields:</p>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Token Structure</span>
                </div>
                <div class="terminal-body">Version || Timestamp || IV || Ciphertext || HMAC</div>
            </div>
            <table class="token-table">
                <thead>
                    <tr><th>Field</th><th>Size</th><th>Description</th></tr>
                </thead>
                <tbody>
                    <tr><td>Version</td><td>8 bits</td><td>Always 0x80 (128) for current Fernet spec</td></tr>
                    <tr><td>Timestamp</td><td>64 bits</td><td>Seconds since January 1, 1970 UTC when token was created</td></tr>
                    <tr><td>IV</td><td>128 bits</td><td>Random initialization vector for AES-CBC</td></tr>
                    <tr><td>Ciphertext</td><td>Variable</td><td>PKCS7-padded plaintext encrypted with AES-128-CBC (multiple of 128 bits)</td></tr>
                    <tr><td>HMAC</td><td>256 bits</td><td>SHA256 HMAC of Version || Timestamp || IV || Ciphertext</td></tr>
                </tbody>
            </table>
        </div>

        <!-- Python Examples -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Fernet Python Examples</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem; line-height: 1.7;">Try these examples using the Python tab above, or copy them to run locally.</p>

            <h3 style="font-size: 1rem; font-weight: 600; margin-bottom: 0.75rem; color: var(--text-primary);">Basic Encrypt &amp; Decrypt</h3>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Python: Basic Fernet encrypt/decrypt</span>
                    <div style="display:flex;gap:0.5rem;">
                        <button class="copy-cmd-btn" data-snippet="basic">Copy</button>
                    </div>
                </div>
                <div class="terminal-body">from cryptography.fernet import Fernet

key = Fernet.generate_key()
print(<code>"Key:"</code>, key.decode())

f = Fernet(key)
token = f.encrypt(b<code>"Hello 8gwifi.org"</code>)
print(<code>"Token:"</code>, token.decode())

plaintext = f.decrypt(token)
print(<code>"Decrypted:"</code>, plaintext.decode())</div>
            </div>

            <h3 style="font-size: 1rem; font-weight: 600; margin: 1.5rem 0 0.75rem; color: var(--text-primary);">Token Inspection</h3>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Python: Inspect Fernet token fields</span>
                    <div style="display:flex;gap:0.5rem;">
                        <button class="copy-cmd-btn" data-snippet="inspect">Copy</button>
                    </div>
                </div>
                <div class="terminal-body">import base64, struct, datetime
from cryptography.fernet import Fernet

key = Fernet.generate_key()
f = Fernet(key)
token = f.encrypt(b<code>"Hello 8gwifi.org"</code>)

<code># Decode the token</code>
data = base64.urlsafe_b64decode(token)
version = data[0]
timestamp = struct.unpack(<code>"&gt;Q"</code>, data[1:9])[0]
iv = data[9:25]
ciphertext = data[25:-32]
hmac_val = data[-32:]

print(f<code>"Version:    0x{version:02x}"</code>)
print(f<code>"Timestamp:  {datetime.datetime.fromtimestamp(timestamp, tz=datetime.timezone.utc)}"</code>)
print(f<code>"IV:         {iv.hex()}"</code>)
print(f<code>"Ciphertext: {ciphertext.hex()}"</code>)
print(f<code>"HMAC:       {hmac_val.hex()}"</code>)</div>
            </div>
        </div>

        <!-- Password-Based Fernet -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Using Password with Fernet (PBKDF2)</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">You can derive a Fernet key from a password using PBKDF2-HMAC-SHA256. This is useful when you want users to encrypt/decrypt with a memorable password rather than a random key.</p>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Python: Password-derived Fernet key</span>
                    <div style="display:flex;gap:0.5rem;">
                        <button class="copy-cmd-btn" data-snippet="pbkdf2">Copy</button>
                    </div>
                </div>
                <div class="terminal-body">import base64, os
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

password = b<code>"my_secret_password"</code>
salt = os.urandom(16)

kdf = PBKDF2HMAC(
    algorithm=hashes.SHA256(),
    length=32,
    salt=salt,
    iterations=100000,
)
key = base64.urlsafe_b64encode(kdf.derive(password))
print(<code>"Derived Key:"</code>, key.decode())

f = Fernet(key)
token = f.encrypt(b<code>"Hello 8gwifi.org"</code>)
print(<code>"Token:"</code>, token.decode())
print(<code>"Decrypted:"</code>, f.decrypt(token).decode())</div>
            </div>
        </div>

        <!-- Limitations -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Fernet Limitations</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">Fernet is ideal for encrypting data that easily fits in memory. As a design feature it does not expose unauthenticated bytes. This means that the complete message contents must be available in memory, making Fernet generally unsuitable for very large files at this time.</p>
            <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">For large file encryption, consider <strong>AES-GCM</strong> (which supports streaming) or chunked encryption approaches. Fernet also does not support key rotation natively &mdash; you must re-encrypt data with a new key manually.</p>
        </div>

        <!-- FAQ Section -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is a Fernet key and how is it formatted?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">A Fernet key is 32 bytes, base64url (URL-safe) encoded. It contains a 128-bit signing key and a 128-bit encryption key concatenated together. The key is used for both HMAC-SHA256 authentication and AES-128-CBC encryption.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Which algorithms does Fernet use?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Fernet uses AES-128 in CBC mode for encryption and HMAC-SHA256 for authentication. The signing key handles HMAC and the encryption key handles AES. All encryption is authenticated, meaning tampering is detected before any plaintext is returned.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I decrypt a Fernet token?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Select Decrypt mode, paste the Fernet token into the message field, enter the same base64url-encoded key that was used for encryption, and click Decrypt. The tool verifies the HMAC, checks the version byte, and returns the original plaintext.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Does this tool store my messages or keys?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">No. Encryption and decryption are processed server-side but no data is stored, logged, or transmitted to third parties. For maximum security, you can use the Python cryptography library locally.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is Fernet the same as AES encryption?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Fernet is built on top of AES-128-CBC but adds authenticated encryption via HMAC-SHA256, a version byte, a timestamp, and a random IV. Raw AES does not include authentication, so Fernet provides stronger guarantees against tampering.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I use Fernet encryption in Python?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Install the cryptography library with <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">pip install cryptography</code>. Then use: <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">from cryptography.fernet import Fernet; key = Fernet.generate_key(); f = Fernet(key); token = f.encrypt(b'message'); print(f.decrypt(token))</code>. Tokens generated by this tool are fully compatible with Python Fernet.</div>
            </div>
        </div>

        <!-- About This Tool -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">About This Tool</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">This Fernet encryption/decryption tool is maintained by <strong>Anish Nath</strong>. It implements the standard Fernet specification as defined by the Python <code style="background:var(--bg-tertiary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">cryptography</code> library.</p>
            <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">The tool generates cryptographically secure Fernet keys, encrypts plaintext messages into Fernet tokens, and decrypts tokens back to their original plaintext. All operations use AES-128-CBC with HMAC-SHA256 authentication as per the Fernet spec.</p>
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

    var currentMode = 'encrypt';
    var lastResponseTimestamp = null;
    var modeBtns = document.querySelectorAll('.fernet-mode-btn');
    var messageLabel = document.getElementById('messageLabel');
    var messageInput = document.getElementById('message');
    var messageHint = document.getElementById('messageHint');
    var submitBtn = document.getElementById('submitBtn');
    var displaySection = document.getElementById('displaySection');
    var resultActions = document.getElementById('resultActions');

    // ========== Mode Toggle ==========

    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;

            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');

            if (mode === 'decrypt') {
                messageLabel.textContent = 'Fernet Token';
                messageInput.placeholder = 'Paste Fernet token to decrypt...';
                messageHint.textContent = 'Token will be verified and decrypted';
                submitBtn.textContent = 'Decrypt Token';

                // Auto-fill: if output has an encrypted token, copy it to input
                var outputTextarea = displaySection.querySelector('textarea');
                if (outputTextarea && outputTextarea.value) {
                    messageInput.value = outputTextarea.value;
                }
            } else {
                messageLabel.textContent = 'Plaintext Message';
                messageInput.placeholder = 'Enter text to encrypt...';
                messageHint.textContent = 'Text will be encrypted with AES-128-CBC';
                submitBtn.textContent = 'Encrypt Message';
            }
        });
    });

    // ========== Generate Key ==========

    document.getElementById('generateKeyBtn').addEventListener('click', function() {
        document.getElementById('keyGenForm').submit();
    });

    // ========== Copy Key ==========

    document.getElementById('copyKeyBtn').addEventListener('click', function() {
        var keyVal = document.getElementById('privatekeyparam').value;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(keyVal, 'Key copied!');
        } else {
            navigator.clipboard.writeText(keyVal);
        }
    });

    // ========== Submit Encrypt/Decrypt ==========

    function showLoading() {
        displaySection.innerHTML = '<div class="fernet-loading">Processing...</div>';
        resultActions.classList.remove('visible');
    }

    function showError(msg) {
        displaySection.innerHTML = '<div class="fernet-error">' + msg + '</div>';
        resultActions.classList.remove('visible');
    }

    function renderResult(html) {
        displaySection.innerHTML = html;
        resultActions.classList.add('visible');
    }

    submitBtn.addEventListener('click', function() {
        var keyVal = document.getElementById('privatekeyparam').value.trim();
        var msg = messageInput.value.trim();
        if (!keyVal || !msg) {
            showError('Please enter both a key and a message.');
            return;
        }

        showLoading();

        var params = new URLSearchParams();
        params.append('methodName', 'FERNET_ENCRYPT_DECRYPT_MESSAGEE');
        params.append('encryptdecryptparameter', currentMode);
        params.append('privatekeyparam', keyVal);
        params.append('message', msg);

        fetch('CipherFunctionality', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(r) {
            var serverDate = r.headers.get('Date');
            lastResponseTimestamp = serverDate ? new Date(serverDate).toISOString() : new Date().toISOString();
            return r.text();
        })
        .then(function(html) { renderResult(html); })
        .catch(function(err) { showError('Request failed: ' + err.message); });
    });

    // ========== Copy Result ==========

    document.getElementById('copyResultBtn').addEventListener('click', function() {
        var textarea = displaySection.querySelector('textarea');
        var text = textarea ? textarea.value : displaySection.textContent;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(text, 'Result copied!');
        } else {
            navigator.clipboard.writeText(text);
        }
    });

    // ========== Download Result ==========

    function parseOutputFields() {
        var fields = {};
        var headers = displaySection.querySelectorAll('h4');
        headers.forEach(function(h4) {
            var label = h4.textContent.trim();
            var next = h4.nextElementSibling;
            while (next && next.tagName !== 'TEXTAREA' && next.tagName !== 'H4') {
                next = next.nextElementSibling;
            }
            if (next && next.tagName === 'TEXTAREA') {
                // Normalize label to camelCase key
                var key = label.toLowerCase()
                    .replace(/[^a-z0-9\s]/g, '')
                    .replace(/\s+(.)/g, function(m, c) { return c.toUpperCase(); });
                fields[key] = next.value;
            }
        });
        return fields;
    }

    document.getElementById('downloadBtn').addEventListener('click', function() {
        var firstTextarea = displaySection.querySelector('textarea');
        if (!firstTextarea || !firstTextarea.value.trim()) return;

        var outputFields = parseOutputFields();

        var output = {
            tool: '8gwifi.org/fernet.jsp',
            mode: currentMode,
            algorithm: 'Fernet (AES-128-CBC + HMAC-SHA256)',
            inputKey: document.getElementById('privatekeyparam').value,
            inputMessage: messageInput.value,
            result: outputFields,
            serverTimestamp: lastResponseTimestamp || new Date().toISOString()
        };

        var json = JSON.stringify(output, null, 2);
        var filename = currentMode === 'encrypt' ? 'fernet-encrypted.json' : 'fernet-decrypted.json';

        if (typeof ToolUtils !== 'undefined' && ToolUtils.downloadAsFile) {
            ToolUtils.downloadAsFile(json, filename, { toolName: 'Fernet Encryption & Decryption' });
        } else {
            var blob = new Blob([json], { type: 'application/json' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }
    });

    // ========== Share URL ==========

    document.getElementById('shareBtn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.generateShareUrl) {
            var url = ToolUtils.generateShareUrl({
                mode: currentMode,
                key: document.getElementById('privatekeyparam').value,
                message: messageInput.value
            }, { toolName: 'Fernet Encryption & Decryption' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        } else {
            var params = new URLSearchParams();
            params.set('mode', currentMode);
            params.set('key', document.getElementById('privatekeyparam').value);
            params.set('message', messageInput.value);
            var url = window.location.origin + window.location.pathname + '?' + params.toString();
            navigator.clipboard.writeText(url);
        }
    });

    // ========== Load from URL (restore shared state) ==========

    (function() {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.loadFromUrl) {
            var loaded = ToolUtils.loadFromUrl({
                key: 'privatekeyparam',
                message: 'message'
            });

            // Restore mode from URL
            var urlParams = new URLSearchParams(window.location.search);
            var urlMode = urlParams.get('mode');
            if (urlMode === 'decrypt' || urlMode === 'encrypt') {
                var targetBtn = document.querySelector('.fernet-mode-btn[data-mode="' + urlMode + '"]');
                if (targetBtn) targetBtn.click();
            }
        }
    })();

    // ========== Output Column Tabs ==========

    var outputTabs = document.querySelectorAll('.fernet-output-tab');
    var compilerLoaded = false;

    outputTabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            outputTabs.forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');

            document.querySelectorAll('.fernet-panel').forEach(function(p) { p.classList.remove('active'); });
            document.getElementById('panel-' + panel).classList.add('active');

            // Lazy-load compiler on first Python tab click
            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Python Compiler Templates ==========

    function buildCompilerCode(template) {
        var keyVal = document.getElementById('privatekeyparam').value.trim();
        var msg = messageInput.value.trim();

        // Get output token if available
        var outputTextarea = displaySection.querySelector('textarea');
        var outputToken = (outputTextarea && outputTextarea.value) ? outputTextarea.value.trim() : '';

        switch (template) {
            case 'encrypt':
                return 'from cryptography.fernet import Fernet\n\n' +
                    '# Using your key from the tool\n' +
                    'key = b"' + (keyVal || 'YOUR_KEY_HERE') + '"\n' +
                    'f = Fernet(key)\n\n' +
                    'message = b"' + (msg || 'Hello World') + '"\n' +
                    'token = f.encrypt(message)\n\n' +
                    'print("Key:      ", key.decode())\n' +
                    'print("Message:  ", message.decode())\n' +
                    'print("Token:    ", token.decode())';

            case 'decrypt':
                return 'from cryptography.fernet import Fernet\n\n' +
                    '# Using your key from the tool\n' +
                    'key = b"' + (keyVal || 'YOUR_KEY_HERE') + '"\n' +
                    'f = Fernet(key)\n\n' +
                    'token = b"' + (outputToken || msg || 'YOUR_TOKEN_HERE') + '"\n' +
                    'plaintext = f.decrypt(token)\n\n' +
                    'print("Key:       ", key.decode())\n' +
                    'print("Token:     ", token.decode())\n' +
                    'print("Decrypted: ", plaintext.decode())';

            case 'keygen':
                return 'import base64\nfrom cryptography.fernet import Fernet\n\n' +
                    'key = Fernet.generate_key()\n' +
                    'raw = base64.urlsafe_b64decode(key)\n\n' +
                    'print("Full key (base64url):", key.decode())\n' +
                    'print("Key length:          ", len(raw), "bytes")\n' +
                    'print("Signing key:         ", raw[:16].hex())\n' +
                    'print("Encryption key:      ", raw[16:].hex())';

            case 'token-inspect':
                var tokenToInspect = outputToken || msg || '';
                return 'import base64, struct, datetime\nfrom cryptography.fernet import Fernet\n\n' +
                    (tokenToInspect
                        ? '# Inspecting your token from the tool\ntoken = b"' + tokenToInspect + '"\n'
                        : '# Generate a sample token to inspect\nkey = Fernet.generate_key()\nf = Fernet(key)\ntoken = f.encrypt(b"Hello 8gwifi.org")\nprint("Token:", token.decode())\n') +
                    '\ndata = base64.urlsafe_b64decode(token)\n' +
                    'version = data[0]\n' +
                    'timestamp = struct.unpack(">Q", data[1:9])[0]\n' +
                    'iv = data[9:25]\n' +
                    'ciphertext = data[25:-32]\n' +
                    'hmac_val = data[-32:]\n\n' +
                    'print(f"Version:    0x{version:02x}")\n' +
                    'print(f"Timestamp:  {datetime.datetime.fromtimestamp(timestamp, tz=datetime.timezone.utc)}")\n' +
                    'print(f"IV:         {iv.hex()}")\n' +
                    'print(f"Ciphertext: {ciphertext.hex()}")\n' +
                    'print(f"HMAC:       {hmac_val.hex()}")';

            case 'pbkdf2':
                return 'import base64, os\nfrom cryptography.fernet import Fernet\n' +
                    'from cryptography.hazmat.primitives import hashes\n' +
                    'from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC\n\n' +
                    'password = b"my_secret_password"\nsalt = os.urandom(16)\n\n' +
                    'kdf = PBKDF2HMAC(\n    algorithm=hashes.SHA256(),\n    length=32,\n    salt=salt,\n    iterations=100000,\n)\n' +
                    'key = base64.urlsafe_b64encode(kdf.derive(password))\n' +
                    'print("Derived Key:", key.decode())\n\n' +
                    'f = Fernet(key)\n' +
                    'token = f.encrypt(b"' + (msg || 'Hello 8gwifi.org') + '")\n' +
                    'print("Token:     ", token.decode())\n' +
                    'print("Decrypted: ", f.decrypt(token).decode())';

            default:
                return '';
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


    // ========== FAQ Toggle ==========

    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Copy Command (educational content) ==========

    // Python code snippets for educational section Copy buttons
    var codeSnippets = {
        basic: [
            'from cryptography.fernet import Fernet',
            '',
            'key = Fernet.generate_key()',
            'print("Key:", key.decode())',
            '',
            'f = Fernet(key)',
            'token = f.encrypt(b"Hello 8gwifi.org")',
            'print("Token:", token.decode())',
            '',
            'plaintext = f.decrypt(token)',
            'print("Decrypted:", plaintext.decode())'
        ].join('\n'),

        inspect: [
            'import base64, struct, datetime',
            'from cryptography.fernet import Fernet',
            '',
            'key = Fernet.generate_key()',
            'f = Fernet(key)',
            'token = f.encrypt(b"Hello 8gwifi.org")',
            '',
            '# Decode the token',
            'data = base64.urlsafe_b64decode(token)',
            'version = data[0]',
            'timestamp = struct.unpack(">Q", data[1:9])[0]',
            'iv = data[9:25]',
            'ciphertext = data[25:-32]',
            'hmac_val = data[-32:]',
            '',
            'print(f"Version:    0x{version:02x}")',
            'print(f"Timestamp:  {datetime.datetime.fromtimestamp(timestamp, tz=datetime.timezone.utc)}")',
            'print(f"IV:         {iv.hex()}")',
            'print(f"Ciphertext: {ciphertext.hex()}")',
            'print(f"HMAC:       {hmac_val.hex()}")'
        ].join('\n'),

        pbkdf2: [
            'import base64, os',
            'from cryptography.fernet import Fernet',
            'from cryptography.hazmat.primitives import hashes',
            'from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC',
            '',
            'password = b"my_secret_password"',
            'salt = os.urandom(16)',
            '',
            'kdf = PBKDF2HMAC(',
            '    algorithm=hashes.SHA256(),',
            '    length=32,',
            '    salt=salt,',
            '    iterations=100000,',
            ')',
            'key = base64.urlsafe_b64encode(kdf.derive(password))',
            'print("Derived Key:", key.decode())',
            '',
            'f = Fernet(key)',
            'token = f.encrypt(b"Hello 8gwifi.org")',
            'print("Token:", token.decode())',
            'print("Decrypted:", f.decrypt(token).decode())'
        ].join('\n')
    };

    // Bind Copy buttons via data-snippet attribute
    document.querySelectorAll('.copy-cmd-btn[data-snippet]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var code = codeSnippets[this.getAttribute('data-snippet')];
            if (code) copyCommand(code);
        });
    });

    window.copyCommand = function(cmd) {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(cmd, 'Command copied!');
        } else {
            navigator.clipboard.writeText(cmd);
        }
    };

    })();
    </script>
</body>
</html>
