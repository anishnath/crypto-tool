<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String[] validList = {"PBKDF2WithHmacSHA256", "PBKDF2WithHmacSHA224", "PBKDF2WithHmacSHA512", "PBKDF2WithHmacSHA384"};
    byte[] salt = new byte[16];
    new SecureRandom().nextBytes(salt);
    String defaultSalt = new String(Base64.encodeBase64(salt));
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
        .tool-action-btn{width:100%;padding:0.625rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:0.5rem;transition:opacity .15s,transform .15s}

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
        <jsp:param name="toolName" value="PBKDF2 Key Derivation Online - Free Tool" />
        <jsp:param name="toolDescription" value="Derive cryptographic keys from passwords using PBKDF2 (RFC 2898). Supports HMAC-SHA1, SHA256, SHA384, SHA512. OWASP-compliant iterations. WPA2/WPA3 PSK calculator included. Free, no signup." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="pbkdf.jsp" />
        <jsp:param name="toolKeywords" value="PBKDF2 online, password key derivation, PBKDF2 generator, derive key from password, HMAC-SHA256, PKCS5, RFC 2898, key derivation function, PBKDF2 tool, password hashing, WPA PSK calculator, WPA2 key generator, WiFi PSK, WPA passphrase to key, PMK calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Derive keys with PBKDF2-HMAC-SHA256/384/512,Configurable iterations (1K to 1M),OWASP-compliant security presets,Multiple algorithm comparison,Base64 and Hex output formats,Share parameters via URL,Download keys as JSON,No passwords stored on server,WPA2/WPA3 PSK Calculator (IEEE 802.11i),Security Audit Scorecard" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is PBKDF2?" />
        <jsp:param name="faq1a" value="PBKDF2 (Password-Based Key Derivation Function 2) is a key derivation function specified in RFC 2898 and PKCS#5. It applies a pseudorandom function (like HMAC-SHA256) to a password along with a salt, repeating the process many times to produce a derived key suitable for cryptographic operations." />
        <jsp:param name="faq2q" value="How many iterations should I use for PBKDF2?" />
        <jsp:param name="faq2a" value="OWASP recommends at least 600,000 iterations for PBKDF2-HMAC-SHA256 as of 2023. For older systems, minimum 310,000 iterations for SHA-256 or 120,000 for SHA-512. Higher iterations increase security but also computation time." />
        <jsp:param name="faq3q" value="What is the difference between PBKDF2 and bcrypt or Argon2?" />
        <jsp:param name="faq3a" value="PBKDF2 is CPU-intensive but not memory-hard, making it vulnerable to GPU attacks. Bcrypt uses 4KB of memory, while Argon2 uses configurable memory (typically 64MB+). For new applications, Argon2id is recommended over PBKDF2. However, PBKDF2 remains widely used for compatibility and FIPS 140-2 compliance." />
        <jsp:param name="faq4q" value="What key length should I use with PBKDF2?" />
        <jsp:param name="faq4a" value="The key length depends on your use case: 128 bits (16 bytes) for AES-128, 256 bits (32 bytes) for AES-256, or 512 bits (64 bytes) for HMAC-SHA512. Never derive more bits than the hash function outputs without careful consideration." />
        <jsp:param name="faq5q" value="Is PBKDF2 still safe to use in 2024?" />
        <jsp:param name="faq5a" value="PBKDF2 is still safe when configured correctly with high iteration counts (600K+ for SHA-256). It is required for FIPS 140-2 compliance. However, for new applications without compliance requirements, Argon2id provides stronger protection against GPU and ASIC attacks." />
        <jsp:param name="faq6q" value="How do I implement PBKDF2 in Python?" />
        <jsp:param name="faq6a" value="Use Python's hashlib module: import hashlib, os; password = b'secret'; salt = os.urandom(16); key = hashlib.pbkdf2_hmac('sha256', password, salt, iterations=600000, dklen=32). The derived key is 32 bytes suitable for AES-256 encryption." />
        <jsp:param name="faq7q" value="Is PBKDF2 FIPS 140-2 compliant?" />
        <jsp:param name="faq7a" value="Yes. PBKDF2 is the only password-based key derivation function approved under FIPS 140-2 (NIST SP 800-132). This makes it mandatory in government, financial, and healthcare systems requiring FIPS compliance. Neither bcrypt nor Argon2 are FIPS-approved alternatives." />
        <jsp:param name="faq8q" value="How does WPA2 use PBKDF2?" />
        <jsp:param name="faq8a" value="WPA2-Personal (WPA-PSK) uses PBKDF2-HMAC-SHA1 with 4096 iterations to derive a 256-bit Pairwise Master Key (PMK) from the WiFi passphrase and SSID. The formula is: PMK = PBKDF2(passphrase, SSID, 4096, 256). This is defined in IEEE 802.11i." />
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
        [data-theme="dark"] .tool-label{color:var(--text-primary,#e2e8f0)}
        [data-theme="dark"] .tool-hint{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-input{background:rgba(255,255,255,0.05);border-color:rgba(255,255,255,0.15);color:var(--text-primary,#e2e8f0)}
        [data-theme="dark"] .tool-input:focus{border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(5,150,105,0.25)}

        /* Algorithm checkboxes */
        .algo-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:0.375rem}
        .algo-checkbox{cursor:pointer;position:relative}
        .algo-checkbox input[type="checkbox"]{display:none}
        .algo-label{display:flex;flex-direction:column;align-items:center;padding:0.4rem 0.25rem;border:1.5px solid var(--border,#e2e8f0);border-radius:0.5rem;background:var(--bg-primary,#fff);text-align:center;transition:all .15s;font-family:var(--font-sans);position:relative}
        .algo-checkbox:hover .algo-label{border-color:var(--tool-primary)}
        .algo-checkbox input[type="checkbox"]:checked+.algo-label{background:var(--tool-gradient);color:#fff;border-color:var(--tool-primary)}
        .algo-label strong{display:block;font-size:0.75rem;line-height:1.2}
        .algo-label small{font-size:0.6rem;opacity:0.8;line-height:1}
        .algo-strength{display:inline-block;width:6px;height:6px;border-radius:50%;margin-bottom:0.2rem}
        .algo-strength-legacy{background:#ef4444}
        .algo-strength-good{background:#059669}
        .algo-strength-strong{background:#3b82f6}
        .algo-strength-strongest{background:#8b5cf6}
        .algo-checkbox input[type="checkbox"]:checked+.algo-label .algo-strength{box-shadow:0 0 0 2px rgba(255,255,255,0.5)}
        [data-theme="dark"] .algo-label{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        [data-theme="dark"] .algo-checkbox input[type="checkbox"]:checked+.algo-label{background:var(--tool-gradient);color:#fff}

        /* Input group */
        .pbkdf-input-group{display:flex;gap:0}
        .pbkdf-input-group .tool-input{border-radius:0.5rem 0 0 0.5rem;flex:1}
        .pbkdf-input-group .pbkdf-input-btn{padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-left:none;border-radius:0 0.5rem 0.5rem 0;background:var(--bg-secondary,#f8fafc);color:var(--text-secondary);cursor:pointer;font-family:var(--font-sans);font-size:0.8125rem;transition:all .15s;white-space:nowrap}
        .pbkdf-input-group .pbkdf-input-btn:hover{background:var(--tool-light);color:var(--tool-primary);border-color:var(--tool-primary)}
        [data-theme="dark"] .pbkdf-input-group .pbkdf-input-btn{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-secondary)}

        /* Preset buttons */
        .preset-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:0.375rem}
        .preset-btn{padding:0.5rem 0.375rem;border:1.5px solid var(--border,#e2e8f0);border-radius:0.5rem;background:var(--bg-primary,#fff);cursor:pointer;font-size:0.7rem;font-weight:600;font-family:var(--font-sans);transition:all .15s;color:var(--text-secondary);text-align:center;line-height:1.2}
        .preset-btn:hover{transform:translateY(-1px);box-shadow:0 2px 8px rgba(0,0,0,0.1)}
        .preset-btn-fast{border-color:#f59e0b;color:#b45309;background:rgba(245,158,11,0.06)}
        .preset-btn-fast:hover{background:rgba(245,158,11,0.15);border-color:#f59e0b}
        .preset-btn-moderate{border-color:#3b82f6;color:#1e40af;background:rgba(59,130,246,0.06)}
        .preset-btn-moderate:hover{background:rgba(59,130,246,0.15);border-color:#3b82f6}
        .preset-btn-owasp{border-color:#059669;color:#047857;background:rgba(5,150,105,0.06)}
        .preset-btn-owasp:hover{background:rgba(5,150,105,0.15);border-color:#059669}
        .preset-icon{display:block;font-size:1rem;margin-bottom:0.125rem}
        .preset-label{display:block;font-size:0.625rem;font-weight:400;opacity:0.75;margin-top:0.125rem}
        [data-theme="dark"] .preset-btn-fast{background:rgba(245,158,11,0.1);color:#fbbf24;border-color:rgba(245,158,11,0.4)}
        [data-theme="dark"] .preset-btn-moderate{background:rgba(59,130,246,0.1);color:#93c5fd;border-color:rgba(59,130,246,0.4)}
        [data-theme="dark"] .preset-btn-owasp{background:rgba(5,150,105,0.1);color:#6ee7b7;border-color:rgba(5,150,105,0.4)}

        /* Parameter sliders */
        .param-slider{margin-bottom:0.625rem}
        .param-slider label{display:flex;justify-content:space-between;font-size:0.75rem;font-weight:500;margin-bottom:0.25rem;color:var(--text-primary)}
        .param-slider .value{color:var(--tool-primary);font-weight:700;font-family:var(--font-mono);font-size:0.8rem}
        .param-slider input[type="range"]{width:100%;height:8px;border-radius:4px;background:linear-gradient(90deg,#e2e8f0,#cbd5e1);outline:none;-webkit-appearance:none;border:1px solid var(--border,#e2e8f0)}
        .param-slider input[type="range"]::-webkit-slider-thumb{-webkit-appearance:none;width:20px;height:20px;border-radius:50%;background:var(--tool-gradient);cursor:pointer;box-shadow:0 2px 6px rgba(5,150,105,0.35);border:2px solid #fff}
        .param-slider input[type="range"]::-moz-range-thumb{width:20px;height:20px;border-radius:50%;background:var(--tool-gradient);cursor:pointer;box-shadow:0 2px 6px rgba(5,150,105,0.35);border:2px solid #fff}
        .param-slider input[type="range"]::-webkit-slider-runnable-track{height:8px;border-radius:4px}
        .param-slider input[type="range"]:focus{box-shadow:0 0 0 3px rgba(5,150,105,0.15)}
        [data-theme="dark"] .param-slider input[type="range"]{background:linear-gradient(90deg,#334155,#475569);border-color:#475569}
        [data-theme="dark"] .param-slider input[type="range"]::-webkit-slider-thumb{border-color:#1e293b;box-shadow:0 2px 8px rgba(5,150,105,0.5)}
        [data-theme="dark"] .param-slider input[type="range"]::-moz-range-thumb{border-color:#1e293b;box-shadow:0 2px 8px rgba(5,150,105,0.5)}

        /* Form section */
        .form-section{background:var(--bg-secondary,#f8fafc);border-radius:0.5rem;padding:0.625rem;margin-bottom:0.5rem}
        .form-section-title{font-weight:600;color:var(--tool-primary);margin-bottom:0.375rem;font-size:0.75rem;display:flex;align-items:center;gap:0.375rem}
        [data-theme="dark"] .form-section{background:var(--bg-tertiary)}

        /* Security warning */
        .pbkdf-warning{background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);border-radius:0.5rem;padding:0.5rem 0.625rem;font-size:0.7rem;color:var(--text-secondary);margin-top:0.5rem;line-height:1.5}
        .pbkdf-warning strong{color:var(--warning,#f59e0b)}

        /* Output tabs */
        .pbkdf-output-tabs{display:flex;gap:0;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.75rem}
        .pbkdf-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;font-family:var(--font-sans);text-align:center}
        .pbkdf-output-tab.active{background:var(--tool-gradient);color:#fff}
        .pbkdf-output-tab:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .pbkdf-output-tab{background:var(--bg-tertiary)}
        [data-theme="dark"] .pbkdf-output-tab.active{background:var(--tool-gradient);color:#fff}
        .pbkdf-panel{display:none;flex:1;min-height:0}.pbkdf-panel.active{display:flex;flex-direction:column}
        #panel-output .tool-result-card{flex:1}
        #panel-python{min-height:540px}

        /* Flow animation */
        .pbkdf-flow{display:flex;flex-direction:column;align-items:center;padding:1.5rem 1rem;gap:1.25rem}
        .pbkdf-flow-row{display:flex;align-items:center;gap:0;width:100%;max-width:380px}
        .pbkdf-flow-box{padding:0.5rem 0.75rem;border-radius:0.5rem;font-size:0.7rem;font-weight:600;text-align:center;white-space:nowrap;animation:flowFadeIn .6s ease both}
        .flow-password{background:#dbeafe;color:#1e40af;border:1.5px solid #93c5fd;min-width:72px;animation-delay:0s}
        .flow-derived{background:#fce7f3;color:#9d174d;border:1.5px solid #f9a8d4;min-width:72px;animation-delay:.8s}
        .flow-engine{background:var(--tool-gradient);color:#fff;border:none;padding:0.625rem 0.875rem;border-radius:0.625rem;box-shadow:0 4px 16px rgba(5,150,105,0.25);animation-delay:.3s;position:relative}
        .flow-engine-label{font-size:0.625rem;opacity:0.85;margin-top:0.125rem;font-weight:500}
        [data-theme="dark"] .flow-password{background:rgba(59,130,246,0.15);color:#93c5fd;border-color:rgba(59,130,246,0.3)}
        [data-theme="dark"] .flow-derived{background:rgba(236,72,153,0.15);color:#f9a8d4;border-color:rgba(236,72,153,0.3)}
        .flow-arrow{flex:1;min-width:28px;height:2px;position:relative;overflow:visible}
        .flow-arrow-line{position:absolute;top:0;left:0;right:0;height:2px;background:var(--border);border-radius:1px}
        .flow-arrow-dot{position:absolute;top:-3px;width:8px;height:8px;border-radius:50%;background:var(--tool-primary);animation:flowDot 2s ease-in-out infinite}
        .flow-arrow-head{position:absolute;top:-4px;right:-2px;width:0;height:0;border-left:6px solid var(--border);border-top:5px solid transparent;border-bottom:5px solid transparent}
        @keyframes flowDot{0%{left:0;opacity:0}10%{opacity:1}90%{opacity:1}100%{left:calc(100% - 8px);opacity:0}}
        @keyframes flowFadeIn{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:translateY(0)}}
        .pbkdf-flow-label{font-size:0.6875rem;font-weight:600;color:var(--tool-primary);text-transform:uppercase;letter-spacing:0.08em;animation:flowFadeIn .3s ease both}
        .pbkdf-flow-caption{font-size:0.8125rem;color:var(--text-muted);text-align:center;animation:flowFadeIn .6s ease 1s both}
        .flow-salt-icon{position:absolute;top:-18px;right:-6px;font-size:0.75rem;animation:flowKeyBob 2.5s ease-in-out infinite}
        @keyframes flowKeyBob{0%,100%{transform:translateY(0)}50%{transform:translateY(-3px)}}

        /* Key output */
        .key-output{background:var(--bg-secondary,#f8f9fa);border:2px solid var(--tool-primary);border-radius:0.5rem;padding:0.75rem;font-family:var(--font-mono);font-size:0.7rem;word-break:break-all;position:relative;color:var(--text-primary)}
        [data-theme="dark"] .key-output{background:var(--bg-tertiary);color:var(--text-primary)}

        /* Output format toggle */
        .output-format-btn{padding:0.25rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);cursor:pointer;font-size:0.7rem;font-weight:500;font-family:var(--font-sans);transition:all .15s;color:var(--text-secondary)}
        .output-format-btn:hover{border-color:var(--tool-primary)}
        .output-format-btn.active{background:var(--tool-primary);color:#fff;border-color:var(--tool-primary)}

        /* Success/error banners */
        .pbkdf-success{background:#ecfdf5;border:1.5px solid #a7f3d0;border-radius:0.5rem;padding:0.75rem 1rem;font-size:0.8125rem;font-weight:500;color:#047857;margin-bottom:0.75rem}
        .pbkdf-error{background:rgba(239,68,68,0.08);border:1px solid rgba(239,68,68,0.3);border-radius:0.5rem;padding:0.75rem 1rem;color:var(--error,#ef4444);font-size:0.8125rem;font-weight:500}
        [data-theme="dark"] .pbkdf-success{background:rgba(5,150,105,0.15);border-color:rgba(5,150,105,0.3);color:#6ee7b7}

        /* Result algo block */
        .result-algo-block{margin-bottom:0.75rem;padding:0.75rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-secondary)}
        .result-algo-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:0.5rem}
        .result-algo-badge{display:inline-flex;padding:0.2rem 0.5rem;border-radius:9999px;font-size:0.7rem;font-weight:600;background:var(--tool-gradient);color:#fff}
        .result-copy-btn{padding:0.25rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);font-size:0.6875rem;font-weight:500;cursor:pointer;font-family:var(--font-sans);transition:all .15s}
        .result-copy-btn:hover{border-color:var(--tool-primary);color:var(--tool-primary)}
        [data-theme="dark"] .result-algo-block{background:var(--bg-tertiary);border-color:var(--border)}
        [data-theme="dark"] .result-copy-btn{background:var(--bg-secondary);border-color:var(--border);color:var(--text-secondary)}

        /* Action buttons row */
        .result-actions-row{display:flex;gap:0.5rem;flex-wrap:wrap;margin-bottom:0.75rem}
        .result-action-btn{padding:0.4rem 0.75rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-secondary);font-size:0.75rem;font-weight:500;cursor:pointer;font-family:var(--font-sans);transition:all .15s;display:inline-flex;align-items:center;gap:0.375rem}
        .result-action-btn:hover{border-color:var(--tool-primary);color:var(--tool-primary)}

        /* Share URL inline */
        .share-inline{margin-top:0.75rem;padding:0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;display:none}
        .share-inline.visible{display:block}
        .share-inline-input{width:100%;padding:0.4rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.7rem;font-family:var(--font-mono);background:var(--bg-primary);color:var(--text-primary);margin-bottom:0.5rem}
        .share-inline-info{font-size:0.7rem;color:var(--text-muted);line-height:1.5}
        [data-theme="dark"] .share-inline{background:var(--bg-tertiary);border-color:var(--border)}
        [data-theme="dark"] .share-inline-input{background:var(--bg-secondary);border-color:var(--border);color:var(--text-primary)}

        /* Terminal blocks */
        .terminal-block{background:#1e1e1e;border-radius:0.5rem;overflow:hidden;margin-bottom:0}
        .terminal-header{background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center}
        .terminal-body{padding:0.75rem;color:#4ec9b0;font-family:var(--font-mono);font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:360px}
        .terminal-body code{color:#ce9178}
        .copy-cmd-btn{background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;transition:all .15s;font-family:var(--font-sans)}
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

        /* Security practices grid */
        .practices-grid{display:grid;grid-template-columns:1fr 1fr;gap:1.5rem}
        @media(max-width:600px){.practices-grid{grid-template-columns:1fr}}
        .practices-grid ul{color:var(--text-secondary);font-size:0.8125rem;padding-left:1.25rem;line-height:1.8}
        .practices-grid ul strong{color:var(--text-primary)}

        /* Toast */
        .pbkdf-toast{position:fixed;bottom:1.5rem;right:1.5rem;padding:0.75rem 1.25rem;background:var(--tool-gradient);color:#fff;border-radius:0.5rem;font-size:0.8125rem;font-weight:500;z-index:9999;opacity:0;transform:translateY(10px);transition:all .3s;pointer-events:none;font-family:var(--font-sans)}
        .pbkdf-toast.visible{opacity:1;transform:translateY(0)}

        /* Mode toggle */
        .pbkdf-mode-toggle{display:flex;gap:0.25rem;background:var(--bg-tertiary);border-radius:0.5rem;padding:0.25rem}
        .mode-btn{flex:1;padding:0.5rem;border:none;border-radius:0.375rem;font-size:0.8125rem;font-weight:500;cursor:pointer;background:transparent;color:var(--text-secondary);transition:all 0.15s;font-family:var(--font-sans)}
        .mode-btn.active{background:var(--bg-primary);color:var(--tool-primary);box-shadow:var(--shadow-sm);font-weight:600}
        [data-theme="dark"] .mode-btn.active{background:var(--bg-secondary)}
        .wpa-info-banner{background:rgba(59,130,246,0.08);border:1px solid rgba(59,130,246,0.2);border-radius:0.5rem;padding:0.625rem;font-size:0.75rem;color:var(--text-secondary);margin-bottom:0.5rem;line-height:1.5}
        [data-theme="dark"] .wpa-info-banner{background:rgba(59,130,246,0.12);border-color:rgba(59,130,246,0.3)}
        .wpa-hidden{display:none!important}

        /* Security audit panel */
        .security-audit{border:1px solid var(--border);border-radius:0.75rem;margin:1rem 0;overflow:hidden}
        .audit-header{display:flex;align-items:center;gap:0.5rem;padding:0.75rem 1rem;background:var(--bg-secondary);border-bottom:1px solid var(--border)}
        .audit-header h4{margin:0;font-size:0.875rem;font-weight:600;color:var(--text-primary)}
        .audit-grade{margin-left:auto;padding:0.25rem 0.75rem;border-radius:9999px;font-weight:700;font-size:0.875rem}
        .audit-grade-A{background:#dcfce7;color:#166534}
        .audit-grade-B{background:#fef9c3;color:#854d0e}
        .audit-grade-C{background:#fee2e2;color:#991b1b}
        .audit-grade-D{background:#fee2e2;color:#991b1b}
        .audit-items{padding:0.75rem 1rem}
        .audit-item{display:flex;gap:0.75rem;padding:0.5rem 0;border-bottom:1px solid var(--border-light);font-size:0.8125rem}
        .audit-item:last-child{border-bottom:none}
        .audit-indicator{width:20px;text-align:center;flex-shrink:0}
        .audit-pass .audit-indicator{color:#059669}
        .audit-warn .audit-indicator{color:#f59e0b}
        .audit-fail .audit-indicator{color:#ef4444}
        .audit-item strong{display:block;color:var(--text-primary);margin-bottom:0.125rem}
        .audit-item p{margin:0;color:var(--text-secondary);font-size:0.75rem;line-height:1.4}
        .audit-details{padding:0.75rem 1rem;background:var(--bg-tertiary);font-size:0.8125rem}
        .audit-detail-row{display:flex;justify-content:space-between;padding:0.25rem 0}
        .audit-value{font-weight:600;font-family:var(--font-mono)}
        [data-theme="dark"] .audit-grade-A{background:rgba(22,163,74,0.2);color:#86efac}
        [data-theme="dark"] .audit-grade-B{background:rgba(234,179,8,0.2);color:#fde047}
        [data-theme="dark"] .audit-grade-C{background:rgba(239,68,68,0.2);color:#fca5a5}
        [data-theme="dark"] .audit-grade-D{background:rgba(239,68,68,0.2);color:#fca5a5}
        [data-theme="dark"] .security-audit{border-color:var(--border)}
        [data-theme="dark"] .audit-header{background:var(--bg-tertiary);border-bottom-color:var(--border)}
        [data-theme="dark"] .audit-details{background:rgba(255,255,255,0.03)}
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">PBKDF2 Key Derivation</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    PBKDF2
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">RFC 2898</span>
                <span class="tool-badge">PKCS#5</span>
                <span class="tool-badge">HMAC-based</span>
                <span class="tool-badge">Free</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Derive cryptographic keys from passwords using PBKDF2 (Password-Based Key Derivation Function 2). Supports HMAC-SHA1, SHA256, SHA384, SHA512 with configurable iterations and key length. RFC 2898 / PKCS#5 compliant. No passwords stored.</p>
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
                        <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
                    </svg>
                    Derive Key from Password
                </div>
                <div class="tool-card-body">
                    <form id="pbkdfForm">
                        <input type="hidden" name="methodName" value="PBKDFDERIVEKEY">

                        <!-- Mode Toggle -->
                        <div class="form-section">
                            <div class="pbkdf-mode-toggle">
                                <button class="mode-btn active" type="button" data-mode="standard">Standard PBKDF2</button>
                                <button class="mode-btn" type="button" data-mode="wpa">WPA-PSK</button>
                            </div>
                        </div>

                        <!-- WPA Info Banner (hidden by default) -->
                        <div class="wpa-info-banner wpa-hidden" id="wpaInfoBanner">
                            WPA/WPA2 uses PBKDF2(passphrase, SSID, 4096, 256) per IEEE 802.11i to derive a 256-bit Pairwise Master Key (PMK).
                        </div>

                        <!-- Algorithm Selection -->
                        <div class="form-section" id="algoSection">
                            <div class="form-section-title">Hash Algorithms <span style="font-weight:400;color:var(--text-muted);font-size:0.7rem;">(select one or more)</span></div>
                            <div class="algo-grid">
                                <label class="algo-checkbox">
                                    <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA1">
                                    <span class="algo-label">
                                        <span class="algo-strength algo-strength-legacy"></span>
                                        <strong>SHA-1</strong>
                                        <small>Legacy</small>
                                    </span>
                                </label>
                                <label class="algo-checkbox">
                                    <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA256" checked>
                                    <span class="algo-label">
                                        <span class="algo-strength algo-strength-good"></span>
                                        <strong>SHA-256</strong>
                                        <small>Recommended</small>
                                    </span>
                                </label>
                                <label class="algo-checkbox">
                                    <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA384">
                                    <span class="algo-label">
                                        <span class="algo-strength algo-strength-strong"></span>
                                        <strong>SHA-384</strong>
                                        <small>Strong</small>
                                    </span>
                                </label>
                                <label class="algo-checkbox">
                                    <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA512">
                                    <span class="algo-label">
                                        <span class="algo-strength algo-strength-strongest"></span>
                                        <strong>SHA-512</strong>
                                        <small>Strongest</small>
                                    </span>
                                </label>
                            </div>
                        </div>

                        <!-- Password Input -->
                        <div class="form-section">
                            <div class="form-section-title">Password</div>
                            <div class="pbkdf-input-group">
                                <input type="password" class="tool-input" id="password" name="password" placeholder="Enter password to derive key from" required>
                                <button class="pbkdf-input-btn" type="button" id="togglePasswordBtn" aria-label="Toggle password visibility">Show</button>
                            </div>
                        </div>

                        <!-- SSID Input (WPA mode, hidden by default) -->
                        <div class="form-section wpa-hidden" id="ssidSection">
                            <div class="form-section-title">SSID (WiFi Network Name)</div>
                            <input type="text" class="tool-input" id="ssid" name="ssid" placeholder="Enter WiFi network name (1-32 chars)" maxlength="32">
                            <p class="tool-hint">The WiFi network name is used as the salt for WPA-PSK derivation.</p>
                        </div>

                        <!-- Salt -->
                        <div class="form-section" id="saltSection">
                            <div class="form-section-title">Salt (Base64)</div>
                            <div class="pbkdf-input-group">
                                <input type="text" class="tool-input" id="salt" name="salt" value="<%=defaultSalt%>" placeholder="Enter salt (Base64)">
                                <button class="pbkdf-input-btn" type="button" id="generateSaltBtn" aria-label="Generate random salt">Random</button>
                            </div>
                            <p class="tool-hint">Minimum 16 bytes recommended. Click Random for a new salt.</p>
                        </div>

                        <!-- Security Presets -->
                        <div class="form-section" id="presetsSection">
                            <div class="form-section-title">Security Presets</div>
                            <div class="preset-grid">
                                <button type="button" class="preset-btn preset-btn-fast" data-preset="fast">
                                    <span class="preset-icon">&#9889;</span>
                                    Fast (10K)
                                    <span class="preset-label">Development</span>
                                </button>
                                <button type="button" class="preset-btn preset-btn-moderate" data-preset="moderate">
                                    <span class="preset-icon">&#9878;</span>
                                    Moderate (100K)
                                    <span class="preset-label">Balanced</span>
                                </button>
                                <button type="button" class="preset-btn preset-btn-owasp" data-preset="owasp">
                                    <span class="preset-icon">&#128737;</span>
                                    OWASP (600K)
                                    <span class="preset-label">Production</span>
                                </button>
                            </div>
                        </div>

                        <!-- Parameters -->
                        <div class="form-section" id="paramsSection">
                            <div class="form-section-title">Parameters</div>
                            <div class="param-slider">
                                <label>
                                    <span>Iterations</span>
                                    <span class="value" id="iterationsValue">100,000</span>
                                </label>
                                <input type="range" id="iterationsSlider" min="1000" max="1000000" step="1000" value="100000">
                                <input type="hidden" name="rounds" id="rounds" value="100000">
                                <p class="tool-hint">OWASP recommends 600,000+ for SHA-256</p>
                            </div>
                            <div class="param-slider">
                                <label>
                                    <span>Key Length (bytes)</span>
                                    <span class="value" id="keyLengthValue">32</span>
                                </label>
                                <input type="range" id="keyLengthSlider" min="16" max="128" step="8" value="32">
                                <input type="hidden" name="keylength" id="keylength" value="32">
                                <p class="tool-hint">32 bytes = 256 bits (AES-256)</p>
                            </div>
                        </div>

                        <button type="submit" class="tool-action-btn" id="generateBtn">Derive Key</button>
                    </form>

                    <div class="pbkdf-warning">
                        <strong>Security Note:</strong> Key derivation is performed server-side. For production use, always derive keys locally.
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Tab bar -->
            <div class="pbkdf-output-tabs">
                <button class="pbkdf-output-tab active" data-panel="output">Output</button>
                <button class="pbkdf-output-tab" data-panel="python">Try It Live</button>
            </div>

            <!-- Output Panel -->
            <div class="pbkdf-panel active" id="panel-output">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
                        </svg>
                        <h4>Derived Key Output</h4>
                    </div>
                    <div class="tool-result-content" id="resultArea">
                        <!-- Empty state: flow animation -->
                        <div class="tool-empty-state" id="emptyState">
                            <div class="pbkdf-flow">
                                <div class="pbkdf-flow-label">PBKDF2 Key Derivation</div>
                                <div class="pbkdf-flow-row">
                                    <div class="pbkdf-flow-box flow-password">Password</div>
                                    <div class="flow-arrow"><div class="flow-arrow-line"></div><div class="flow-arrow-dot"></div><div class="flow-arrow-head"></div></div>
                                    <div class="pbkdf-flow-box flow-engine">
                                        HMAC-SHA256
                                        <div class="flow-engine-label">x iterations</div>
                                        <span class="flow-salt-icon">+ Salt</span>
                                    </div>
                                    <div class="flow-arrow"><div class="flow-arrow-line"></div><div class="flow-arrow-dot"></div><div class="flow-arrow-head"></div></div>
                                    <div class="pbkdf-flow-box flow-derived">Derived Key</div>
                                </div>
                                <div class="pbkdf-flow-caption">Enter a password and click Derive Key</div>
                            </div>
                        </div>
                        <!-- Results injected here -->
                        <div id="resultContent" style="display:none;"></div>
                    </div>
                </div>
            </div>

            <!-- Python Compiler Panel -->
            <div class="pbkdf-panel" id="panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <h4>Python Compiler</h4>
                        <select id="compilerTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="basic">Basic PBKDF2</option>
                            <option value="all_algos">All algorithms</option>
                            <option value="compare">PBKDF2 vs bcrypt</option>
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

    <!-- Mobile Ad Fallback -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="pbkdf.jsp"/>
        <jsp:param name="keyword" value="cryptography"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- How PBKDF2 Works -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1.5rem;color:var(--text-primary);">How PBKDF2 Works</h2>
            <p style="color:var(--text-secondary);font-size:0.9375rem;line-height:1.7;margin-bottom:1.5rem;">PBKDF2 derives a cryptographic key from a password by applying a pseudorandom function (typically HMAC) with a salt, repeating the process many times to increase the computational cost of brute-force attacks.</p>

            <!-- Process diagram -->
            <div style="overflow-x:auto;margin-bottom:1.25rem;">
                <svg viewBox="0 0 700 120" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:700px;height:auto;display:block;margin:0 auto;" role="img" aria-label="PBKDF2 key derivation process diagram">
                    <rect x="2" y="30" width="100" height="60" rx="8" fill="#dbeafe" stroke="#3b82f6" stroke-width="1.5"/>
                    <text x="52" y="56" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#1e40af">Password</text>
                    <text x="52" y="72" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#3b82f6">User secret</text>

                    <line x1="106" y1="60" x2="152" y2="60" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="152,55 162,60 152,65" fill="#94a3b8"/>

                    <rect x="2" y="95" width="100" height="22" rx="4" fill="#fef3c7" stroke="#f59e0b" stroke-width="1"/>
                    <text x="52" y="110" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="8" font-weight="500" fill="#92400e">Salt (16+ bytes)</text>

                    <line x1="106" y1="106" x2="140" y2="85" stroke="#94a3b8" stroke-width="1" stroke-dasharray="4,3"/>

                    <rect x="166" y="20" width="130" height="80" rx="10" fill="#059669" stroke="#047857" stroke-width="1.5"/>
                    <text x="231" y="50" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="12" font-weight="700" fill="#fff">HMAC-SHA256</text>
                    <text x="231" y="68" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#d1fae5">Pseudorandom Function</text>
                    <text x="231" y="85" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="8" fill="#a7f3d0">x iterations</text>

                    <path d="M231 102 Q231 115 280 115 Q300 115 300 100" stroke="#059669" stroke-width="1.5" fill="none" stroke-dasharray="4,3"/>
                    <text x="270" y="112" font-family="Inter,system-ui,sans-serif" font-size="7" fill="#047857">repeat</text>

                    <line x1="300" y1="60" x2="346" y2="60" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="346,55 356,60 346,65" fill="#94a3b8"/>

                    <rect x="360" y="20" width="100" height="80" rx="8" fill="#f1f5f9" stroke="#cbd5e1" stroke-width="1.5"/>
                    <text x="410" y="50" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#334155">XOR</text>
                    <text x="410" y="68" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="9" fill="#64748b">Combine blocks</text>
                    <text x="410" y="85" text-anchor="middle" font-family="monospace" font-size="7" fill="#94a3b8">U1 ^ U2 ^ ... ^ Uc</text>

                    <line x1="464" y1="60" x2="510" y2="60" stroke="#94a3b8" stroke-width="1.5"/>
                    <polygon points="510,55 520,60 510,65" fill="#94a3b8"/>

                    <rect x="524" y="30" width="120" height="60" rx="8" fill="#fce7f3" stroke="#f9a8d4" stroke-width="1.5"/>
                    <text x="584" y="56" text-anchor="middle" font-family="Inter,system-ui,sans-serif" font-size="11" font-weight="600" fill="#9d174d">Derived Key</text>
                    <text x="584" y="72" text-anchor="middle" font-family="monospace" font-size="8" fill="#be185d">32 bytes (256 bits)</text>
                </svg>
            </div>

            <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.75rem;color:var(--text-primary);">PBKDF2 Formula</h3>
            <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;padding:1rem;margin-bottom:1.5rem;">
                <code style="font-family:var(--font-mono);font-size:0.875rem;color:var(--tool-primary);font-weight:600;">DK = PBKDF2(PRF, Password, Salt, c, dkLen)</code>
                <ul style="margin:0.5rem 0 0 1.25rem;font-size:0.8125rem;color:var(--text-secondary);line-height:1.8;">
                    <li><strong style="color:var(--text-primary);">PRF</strong> &mdash; Pseudorandom function (e.g., HMAC-SHA256)</li>
                    <li><strong style="color:var(--text-primary);">Password</strong> &mdash; Master password</li>
                    <li><strong style="color:var(--text-primary);">Salt</strong> &mdash; Random salt (min 16 bytes recommended)</li>
                    <li><strong style="color:var(--text-primary);">c</strong> &mdash; Iteration count</li>
                    <li><strong style="color:var(--text-primary);">dkLen</strong> &mdash; Desired key length in bytes</li>
                </ul>
            </div>
        </div>

        <!-- PBKDF2 vs Other KDFs -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">PBKDF2 vs Other KDFs</h2>
            <table class="compare-table">
                <thead><tr><th>Algorithm</th><th>Memory-Hard</th><th>GPU Resistant</th><th>Standard</th><th>Recommendation</th></tr></thead>
                <tbody>
                    <tr><td>PBKDF2</td><td>No</td><td>Low</td><td>RFC 2898</td><td>Legacy / FIPS compliance</td></tr>
                    <tr><td>BCrypt</td><td>4KB</td><td>Medium</td><td>De facto</td><td>Still acceptable</td></tr>
                    <tr><td>Scrypt</td><td>Yes</td><td>High</td><td>RFC 7914</td><td>Good choice</td></tr>
                    <tr><td style="font-weight:700;">Argon2id</td><td>Yes (configurable)</td><td>High</td><td>RFC 9106</td><td style="font-weight:700;color:var(--tool-primary);">Best for new apps</td></tr>
                </tbody>
            </table>
        </div>

        <!-- OWASP Recommendations -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">OWASP Iteration Recommendations (2023)</h2>
            <table class="compare-table">
                <thead><tr><th>Algorithm</th><th>Min Iterations</th><th>Notes</th></tr></thead>
                <tbody>
                    <tr><td>PBKDF2-HMAC-SHA1</td><td>1,300,000</td><td>Legacy, avoid for new apps</td></tr>
                    <tr><td style="font-weight:700;">PBKDF2-HMAC-SHA256</td><td style="font-weight:700;">600,000</td><td style="font-weight:700;color:var(--tool-primary);">Recommended default</td></tr>
                    <tr><td>PBKDF2-HMAC-SHA512</td><td>210,000</td><td>Faster on 64-bit systems</td></tr>
                </tbody>
            </table>
        </div>

        <!-- Code Examples -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Code Examples</h2>

            <div class="code-tabs" role="tablist">
                <button class="code-tab active" onclick="switchCodeTab('python',this)" role="tab">Python</button>
                <button class="code-tab" onclick="switchCodeTab('java',this)" role="tab">Java</button>
                <button class="code-tab" onclick="switchCodeTab('nodejs',this)" role="tab">Node.js</button>
                <button class="code-tab" onclick="switchCodeTab('go',this)" role="tab">Go</button>
                <button class="code-tab" onclick="switchCodeTab('openssl',this)" role="tab">OpenSSL</button>
            </div>

            <div class="code-tab-panel active" id="codePanel-python">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Python: PBKDF2 Key Derivation</span>
                        <button class="copy-cmd-btn" data-snippet="python">Copy</button>
                    </div>
                    <div class="terminal-body">import hashlib
import os

<code># Generate random salt</code>
salt = os.urandom(16)

<code># Derive key using PBKDF2-HMAC-SHA256</code>
password = b<code>"secret"</code>
key = hashlib.pbkdf2_hmac(
    <code>'sha256'</code>, password, salt,
    iterations=600000, dklen=32
)
print(f<code>"Key: {key.hex()}"</code>)
print(f<code>"Salt: {salt.hex()}"</code>)</div>
                </div>
            </div>

            <div class="code-tab-panel" id="codePanel-java">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Java: PBKDF2 Key Derivation</span>
                        <button class="copy-cmd-btn" data-snippet="java">Copy</button>
                    </div>
                    <div class="terminal-body">import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;

<code>// Generate salt</code>
byte[] salt = new byte[16];
new SecureRandom().nextBytes(salt);

<code>// Derive key</code>
PBEKeySpec spec = new PBEKeySpec(
    <code>"password"</code>.toCharArray(), salt, 600000, 256
);
SecretKeyFactory f = SecretKeyFactory
    .getInstance(<code>"PBKDF2WithHmacSHA256"</code>);
byte[] key = f.generateSecret(spec).getEncoded();</div>
                </div>
            </div>

            <div class="code-tab-panel" id="codePanel-nodejs">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Node.js: PBKDF2 Key Derivation</span>
                        <button class="copy-cmd-btn" data-snippet="nodejs">Copy</button>
                    </div>
                    <div class="terminal-body">const crypto = require(<code>'crypto'</code>);

<code>// Generate salt</code>
const salt = crypto.randomBytes(16);

<code>// Derive key (async)</code>
crypto.pbkdf2(
    <code>'password'</code>, salt, 600000, 32, <code>'sha256'</code>,
    (err, key) => {
        console.log(<code>`Key: ${key.toString('hex')}`</code>);
    }
);

<code>// Synchronous version</code>
const key = crypto.pbkdf2Sync(
    <code>'password'</code>, salt, 600000, 32, <code>'sha256'</code>
);</div>
                </div>
            </div>

            <div class="code-tab-panel" id="codePanel-go">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Go: PBKDF2 Key Derivation</span>
                        <button class="copy-cmd-btn" data-snippet="go">Copy</button>
                    </div>
                    <div class="terminal-body">import (
    <code>"crypto/sha256"</code>
    <code>"golang.org/x/crypto/pbkdf2"</code>
    <code>"crypto/rand"</code>
)

<code>// Generate salt</code>
salt := make([]byte, 16)
rand.Read(salt)

<code>// Derive 32-byte key</code>
key := pbkdf2.Key(
    []byte(<code>"password"</code>), salt,
    600000, 32, sha256.New,
)</div>
                </div>
            </div>

            <div class="code-tab-panel" id="codePanel-openssl">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>OpenSSL: PBKDF2 Key Derivation</span>
                        <button class="copy-cmd-btn" data-snippet="openssl">Copy</button>
                    </div>
                    <div class="terminal-body"><code># Derive 256-bit key using PBKDF2-HMAC-SHA256 (OpenSSL 3.0+)</code>
openssl kdf -keylen 32 \
  -kdfopt digest:SHA256 \
  -kdfopt pass:password \
  -kdfopt salt:hex:0102030405060708 \
  -kdfopt iter:600000 PBKDF2

<code># Using enc command (older OpenSSL)</code>
openssl enc -aes-256-cbc -pbkdf2 -iter 600000 \
  -salt -in plain.txt -out encrypted.bin</div>
                </div>
            </div>
        </div>

        <!-- Security Best Practices -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Security Best Practices</h2>
            <div class="practices-grid">
                <div>
                    <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:#059669;">Do's</h3>
                    <ul>
                        <li>Use <strong>600,000+ iterations</strong> for SHA-256</li>
                        <li>Use a <strong>unique random salt</strong> per password (16+ bytes)</li>
                        <li>Use <strong>HMAC-SHA256 or SHA512</strong></li>
                        <li>Store salt alongside the derived key</li>
                        <li>Consider <strong>Argon2id</strong> for new applications</li>
                        <li>Benchmark iterations on your target hardware</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:#ef4444;">Don'ts</h3>
                    <ul>
                        <li>Don't use <strong>fewer than 100,000 iterations</strong></li>
                        <li>Don't use <strong>HMAC-SHA1</strong> for new applications</li>
                        <li>Don't reuse salts across different passwords</li>
                        <li>Don't derive more bytes than the hash output</li>
                        <li>Don't use a static/hardcoded salt</li>
                        <li>Don't skip key stretching for password storage</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- FAQ Accordion -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is PBKDF2?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PBKDF2 (Password-Based Key Derivation Function 2) is a key derivation function specified in RFC 2898 and PKCS#5. It applies a pseudorandom function (like HMAC-SHA256) to a password along with a salt, repeating the process many times to produce a derived key suitable for cryptographic operations.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How many iterations should I use for PBKDF2?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">OWASP recommends at least 600,000 iterations for PBKDF2-HMAC-SHA256 as of 2023. For older systems, minimum 310,000 iterations for SHA-256 or 120,000 for SHA-512. Higher iterations increase security but also computation time.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the difference between PBKDF2 and bcrypt or Argon2?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PBKDF2 is CPU-intensive but not memory-hard, making it vulnerable to GPU attacks. Bcrypt uses 4KB of memory, while Argon2 uses configurable memory (typically 64MB+). For new applications, Argon2id is recommended over PBKDF2. However, PBKDF2 remains widely used for compatibility and FIPS 140-2 compliance.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What key length should I use with PBKDF2?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The key length depends on your use case: 128 bits (16 bytes) for AES-128, 256 bits (32 bytes) for AES-256, or 512 bits (64 bytes) for HMAC-SHA512. Never derive more bits than the hash function outputs without careful consideration.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is PBKDF2 still safe to use?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PBKDF2 is still safe when configured correctly with high iteration counts (600K+ for SHA-256). It is required for FIPS 140-2 compliance. However, for new applications without compliance requirements, Argon2id provides stronger protection against GPU and ASIC attacks.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I implement PBKDF2 in Python?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Use Python's <code>hashlib</code> module: <code>import hashlib, os; password = b'secret'; salt = os.urandom(16); key = hashlib.pbkdf2_hmac('sha256', password, salt, iterations=600000, dklen=32)</code>. The derived key is 32 bytes suitable for AES-256 encryption.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Is PBKDF2 FIPS 140-2 compliant?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes. PBKDF2 is the only password-based key derivation function approved under FIPS 140-2 (NIST SP 800-132). This makes it mandatory in government, financial, and healthcare systems requiring FIPS compliance. Neither bcrypt nor Argon2 are FIPS-approved alternatives.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How does WPA2 use PBKDF2?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">WPA2-Personal (WPA-PSK) uses PBKDF2-HMAC-SHA1 with 4096 iterations to derive a 256-bit Pairwise Master Key (PMK) from the WiFi passphrase and SSID. The formula is: PMK = PBKDF2(passphrase, SSID, 4096, 256). This is defined in IEEE 802.11i. Use our WPA-PSK calculator above to compute this.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the PBKDF2 output length design flaw?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">If you request more output bytes than the underlying hash function produces (e.g., &gt;32 bytes for SHA-256), PBKDF2 must run the entire iteration process multiple times. Requesting 64 bytes from SHA-256 doubles the computation for the defender but not for an attacker targeting just the first block. Always match key length to hash output: 32 bytes for SHA-256, 64 bytes for SHA-512.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I migrate from PBKDF2 to Argon2?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The common approach is transparent rehashing: (1) Keep PBKDF2 hashes in your database, (2) When a user logs in, verify with PBKDF2, then immediately rehash the password with Argon2id and store the new hash, (3) Mark the record as migrated. Over time, most active users will be migrated. For inactive accounts, force a password reset.</div>
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

    <!-- Toast element -->
    <div class="pbkdf-toast" id="pbkdfToast"></div>

    <script>
    (function() {
    'use strict';

    var lastResults = [];
    var lastParams = {};
    var compilerLoaded = false;
    var currentMode = 'standard'; // 'standard' or 'wpa'

    // ========== Utility ==========

    function $(id) { return document.getElementById(id); }
    function qs(sel) { return document.querySelector(sel); }
    function qsa(sel) { return document.querySelectorAll(sel); }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function showToast(message) {
        var toast = $('pbkdfToast');
        toast.textContent = message;
        toast.classList.add('visible');
        clearTimeout(toast._timer);
        toast._timer = setTimeout(function() { toast.classList.remove('visible'); }, 2000);
    }

    function copyText(text, msg) {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(text, msg || 'Copied!');
        } else {
            navigator.clipboard.writeText(text).then(function() { showToast(msg || 'Copied!'); });
        }
    }

    // ========== Password Toggle ==========

    $('togglePasswordBtn').addEventListener('click', function() {
        var input = $('password');
        if (input.type === 'password') {
            input.type = 'text';
            this.textContent = 'Hide';
        } else {
            input.type = 'password';
            this.textContent = 'Show';
        }
    });

    // ========== Salt Generation ==========

    $('generateSaltBtn').addEventListener('click', function() {
        var array = new Uint8Array(16);
        crypto.getRandomValues(array);
        var base64 = btoa(String.fromCharCode.apply(null, array));
        $('salt').value = base64;
        showToast('Random salt generated (16 bytes)');
    });

    // ========== Presets ==========

    var presets = { fast: 10000, moderate: 100000, owasp: 600000 };

    qsa('.preset-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var preset = this.getAttribute('data-preset');
            var iterations = presets[preset];
            $('iterationsSlider').value = iterations;
            $('iterationsValue').textContent = parseInt(iterations).toLocaleString();
            $('rounds').value = iterations;
            showToast('Applied ' + preset + ' preset');
        });
    });

    // ========== Sliders ==========

    $('iterationsSlider').addEventListener('input', function() {
        $('iterationsValue').textContent = parseInt(this.value).toLocaleString();
        $('rounds').value = this.value;
    });

    $('keyLengthSlider').addEventListener('input', function() {
        $('keyLengthValue').textContent = this.value;
        $('keylength').value = this.value;
    });

    // ========== Output Tabs ==========

    qsa('.pbkdf-output-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            qsa('.pbkdf-output-tab').forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');
            qsa('.pbkdf-panel').forEach(function(p) { p.classList.remove('active'); });
            $('panel-' + panel).classList.add('active');

            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Python Compiler ==========

    function buildCompilerCode(template) {
        if (template === 'all_algos') {
            return 'import hashlib\nimport os\nimport base64\n\npassword = b"secret"\nsalt = os.urandom(16)\n\nfor algo in ["sha1", "sha256", "sha384", "sha512"]:\n    key = hashlib.pbkdf2_hmac(algo, password, salt, iterations=100000, dklen=32)\n    print(f"PBKDF2-HMAC-{algo.upper()}: {key.hex()}")\n\nprint(f"\\nSalt (base64): {base64.b64encode(salt).decode()}")\n';
        }
        if (template === 'compare') {
            return 'import hashlib\nimport os\nimport time\n\npassword = b"secret"\nsalt = os.urandom(16)\n\n# PBKDF2\nstart = time.time()\nkey1 = hashlib.pbkdf2_hmac("sha256", password, salt, iterations=100000, dklen=32)\nt1 = time.time() - start\nprint(f"PBKDF2-SHA256 (100K iter): {t1*1000:.1f}ms")\nprint(f"  Key: {key1.hex()[:32]}...")\n\ntry:\n    import bcrypt\n    start = time.time()\n    hash2 = bcrypt.hashpw(password, bcrypt.gensalt(rounds=12))\n    t2 = time.time() - start\n    print(f"\\nbcrypt (cost=12): {t2*1000:.1f}ms")\n    print(f"  Hash: {hash2.decode()[:32]}...")\nexcept ImportError:\n    print("\\nbcrypt not installed (pip install bcrypt)")\n\nprint("\\nNote: Argon2id is recommended for new applications")\n';
        }
        // basic
        return 'import hashlib\nimport os\nimport base64\n\n# PBKDF2 Key Derivation\npassword = b"secret"\nsalt = os.urandom(16)\n\nkey = hashlib.pbkdf2_hmac(\n    "sha256",\n    password,\n    salt,\n    iterations=600000,\n    dklen=32\n)\n\nprint(f"Password: secret")\nprint(f"Salt (base64): {base64.b64encode(salt).decode()}")\nprint(f"Iterations: 600,000")\nprint(f"Key Length: 32 bytes (256 bits)")\nprint(f"Derived Key (hex): {key.hex()}")\nprint(f"Derived Key (base64): {base64.b64encode(key).decode()}")\n';
    }

    function loadCompilerWithTemplate() {
        var template = $('compilerTemplate').value;
        var code = buildCompilerCode(template);
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({lang: 'python', code: b64Code});
        $('compilerIframe').src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    $('compilerTemplate').addEventListener('change', function() {
        compilerLoaded = false;
        loadCompilerWithTemplate();
        compilerLoaded = true;
    });

    // ========== Mode Toggle (Standard / WPA-PSK) ==========

    function switchMode(mode) {
        currentMode = mode;
        qsa('.mode-btn').forEach(function(b) { b.classList.remove('active'); });
        qs('.mode-btn[data-mode="' + mode + '"]').classList.add('active');

        var standardSections = [$('algoSection'), $('saltSection'), $('presetsSection'), $('paramsSection')];
        var wpaSections = [$('ssidSection'), $('wpaInfoBanner')];

        if (mode === 'wpa') {
            standardSections.forEach(function(el) { if (el) el.classList.add('wpa-hidden'); });
            wpaSections.forEach(function(el) { if (el) el.classList.remove('wpa-hidden'); });
            $('generateBtn').textContent = 'Calculate PSK';
        } else {
            standardSections.forEach(function(el) { if (el) el.classList.remove('wpa-hidden'); });
            wpaSections.forEach(function(el) { if (el) el.classList.add('wpa-hidden'); });
            $('generateBtn').textContent = 'Derive Key';
        }
    }

    qsa('.mode-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchMode(this.getAttribute('data-mode'));
        });
    });

    // ========== Security Audit ==========

    function computeSecurityAudit(params) {
        var checks = [];
        var iterations = parseInt(params.iterations) || 0;
        var algo = params.algorithm || '';
        var saltB64 = params.salt || '';
        var keyLen = parseInt(params.keyLength) || 0;

        // Determine hash output size
        var hashOutput = 32; // default SHA-256
        if (algo.indexOf('SHA512') !== -1) hashOutput = 64;
        else if (algo.indexOf('SHA384') !== -1) hashOutput = 48;
        else if (algo.indexOf('SHA1') !== -1) hashOutput = 20;

        // Iteration check
        var iterThresholdPass = (algo.indexOf('SHA512') !== -1) ? 210000 : 600000;
        if (iterations >= iterThresholdPass) {
            checks.push({ status: 'pass', title: 'Iteration Count', desc: iterations.toLocaleString() + ' iterations meets OWASP 2023 recommendation' });
        } else if (iterations >= 100000) {
            checks.push({ status: 'warn', title: 'Iteration Count', desc: iterations.toLocaleString() + ' iterations — OWASP recommends ' + iterThresholdPass.toLocaleString() + '+' });
        } else {
            checks.push({ status: 'fail', title: 'Iteration Count', desc: iterations.toLocaleString() + ' iterations is below the minimum safe threshold (100K)' });
        }

        // Algorithm check
        if (algo.indexOf('SHA256') !== -1 || algo.indexOf('SHA512') !== -1) {
            checks.push({ status: 'pass', title: 'Algorithm', desc: getAlgoDisplayName(algo) + ' is recommended' });
        } else if (algo.indexOf('SHA384') !== -1) {
            checks.push({ status: 'warn', title: 'Algorithm', desc: 'SHA-384 is acceptable but SHA-256 or SHA-512 are preferred' });
        } else {
            checks.push({ status: 'fail', title: 'Algorithm', desc: 'HMAC-SHA1 is legacy — consider SHA-256 or SHA-512' });
        }

        // Salt length check (estimate from Base64)
        var saltBytes = 0;
        try { saltBytes = atob(saltB64).length; } catch(e) { saltBytes = saltB64.length; }
        if (saltBytes >= 16) {
            checks.push({ status: 'pass', title: 'Salt Length', desc: saltBytes + ' bytes meets the 16-byte minimum' });
        } else if (saltBytes >= 8) {
            checks.push({ status: 'warn', title: 'Salt Length', desc: saltBytes + ' bytes — recommend 16+ bytes' });
        } else {
            checks.push({ status: 'fail', title: 'Salt Length', desc: saltBytes + ' bytes is too short (minimum 8, recommend 16+)' });
        }

        // Key length check
        if (keyLen <= hashOutput) {
            checks.push({ status: 'pass', title: 'Key Length', desc: keyLen + ' bytes fits within ' + hashOutput + '-byte hash output' });
        } else {
            checks.push({ status: 'warn', title: 'Key Length', desc: keyLen + ' bytes exceeds ' + hashOutput + '-byte hash output (PBKDF2 design flaw — runs multiple passes)' });
        }

        // FIPS compliance
        checks.push({ status: 'pass', title: 'FIPS 140-2', desc: 'PBKDF2 is FIPS 140-2 approved (NIST SP 800-132)' });

        // Grade
        var fails = checks.filter(function(c) { return c.status === 'fail'; }).length;
        var warns = checks.filter(function(c) { return c.status === 'warn'; }).length;
        var grade;
        if (fails >= 2) grade = 'D';
        else if (fails >= 1) grade = 'C';
        else if (warns === 0) grade = 'A+';
        else if (warns === 1) grade = 'A';
        else if (warns === 2) grade = 'B+';
        else grade = 'B';

        // Crack time estimate
        var hashrate = 500000; // hashes/sec on RTX 4090 for PBKDF2-SHA256
        if (algo.indexOf('SHA512') !== -1) hashrate = 150000;
        else if (algo.indexOf('SHA1') !== -1) hashrate = 1500000;
        var passwordLen = ($('password').value || '').length;
        var charset = 26; // lowercase
        if (/[A-Z]/.test($('password').value)) charset += 26;
        if (/[0-9]/.test($('password').value)) charset += 10;
        if (/[^a-zA-Z0-9]/.test($('password').value)) charset += 32;
        if (charset < 26) charset = 26;
        var keyspace = Math.pow(charset, Math.min(passwordLen, 20));
        var secondsToCrack = keyspace / hashrate;
        var crackTimeStr;
        if (secondsToCrack < 1) crackTimeStr = '< 1 second';
        else if (secondsToCrack < 60) crackTimeStr = '< 1 minute';
        else if (secondsToCrack < 3600) crackTimeStr = '~' + Math.round(secondsToCrack / 60) + ' minutes';
        else if (secondsToCrack < 86400) crackTimeStr = '~' + Math.round(secondsToCrack / 3600) + ' hours';
        else if (secondsToCrack < 86400 * 365) crackTimeStr = '~' + Math.round(secondsToCrack / 86400) + ' days';
        else if (secondsToCrack < 86400 * 365 * 1000) crackTimeStr = '~' + Math.round(secondsToCrack / (86400 * 365)) + ' years';
        else crackTimeStr = '~' + Math.round(secondsToCrack / (86400 * 365 * 100)) + ' centuries';

        return { checks: checks, grade: grade, crackTime: crackTimeStr };
    }

    function renderSecurityAudit(audit) {
        var gradeClass = 'audit-grade-A';
        if (audit.grade.charAt(0) === 'B') gradeClass = 'audit-grade-B';
        else if (audit.grade.charAt(0) === 'C') gradeClass = 'audit-grade-C';
        else if (audit.grade.charAt(0) === 'D') gradeClass = 'audit-grade-D';

        var html = '<div class="security-audit">';
        html += '<div class="audit-header">';
        html += '<span style="font-size:1.1rem;">&#128737;</span>';
        html += '<h4>Security Audit</h4>';
        html += '<span class="audit-grade ' + gradeClass + '">' + escapeHtml(audit.grade) + '</span>';
        html += '</div>';
        html += '<div class="audit-items">';
        for (var i = 0; i < audit.checks.length; i++) {
            var c = audit.checks[i];
            var icon = c.status === 'pass' ? '&#10003;' : (c.status === 'warn' ? '&#9888;' : '&#10007;');
            html += '<div class="audit-item audit-' + c.status + '">';
            html += '<span class="audit-indicator">' + icon + '</span>';
            html += '<div><strong>' + escapeHtml(c.title) + '</strong><p>' + escapeHtml(c.desc) + '</p></div>';
            html += '</div>';
        }
        html += '</div>';
        html += '<div class="audit-details">';
        html += '<div class="audit-detail-row"><span>Estimated crack time (GPU)</span><span class="audit-value">' + escapeHtml(audit.crackTime) + '</span></div>';
        html += '<div class="audit-detail-row"><span>FIPS 140-2 compliant</span><span class="audit-value audit-pass">Yes &#10003;</span></div>';
        html += '</div>';
        html += '</div>';
        return html;
    }

    // ========== WPA Result Rendering ==========

    function renderWpaResult(result, duration) {
        var hexKey = '';
        try {
            var binary = atob(result.derivedKey);
            for (var j = 0; j < binary.length; j++) {
                hexKey += ('0' + binary.charCodeAt(j).toString(16)).slice(-2);
            }
        } catch(e) { hexKey = result.derivedKey; }

        var ssid = $('ssid').value || '';
        var passLen = ($('password').value || '').length;

        var html = '<div class="pbkdf-success"><strong>WPA Pre-Shared Key Derived!</strong> Computed in ' + duration + 'ms</div>';
        html += '<div class="result-algo-block">';
        html += '<div class="result-algo-header">';
        html += '<span class="result-algo-badge">WPA PMK</span>';
        html += '<button class="result-copy-btn" onclick="window._pbkdfCopyKey(0)">Copy PMK</button>';
        html += '</div>';
        html += '<div class="key-output"><span id="derivedKey_0" data-base64="' + escapeHtml(result.derivedKey) + '">' + hexKey + '</span></div>';
        html += '</div>';

        html += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:0.5rem;font-size:0.75rem;color:var(--text-muted);margin-bottom:0.75rem;">';
        html += '<div><strong>SSID:</strong> ' + escapeHtml(ssid) + '</div>';
        html += '<div><strong>Passphrase length:</strong> ' + passLen + ' characters</div>';
        html += '<div><strong>Standard:</strong> IEEE 802.11i / WPA2-Personal</div>';
        html += '<div><strong>Algorithm:</strong> PBKDF2-HMAC-SHA1 (4096 iter)</div>';
        html += '</div>';

        // Action buttons
        html += '<div class="result-actions-row">';
        html += '<button class="result-action-btn" onclick="window._pbkdfCopyKey(0)">Copy PMK</button>';
        html += '<button class="result-action-btn" onclick="window._pbkdfShareUrl()">Share URL</button>';
        html += '</div>';

        // Share URL inline section
        html += '<div class="share-inline" id="shareInline">';
        html += '<input class="share-inline-input" id="shareUrlInput" readonly>';
        html += '<button class="result-action-btn" onclick="window._pbkdfCopyShareUrl()" style="margin-bottom:0.5rem;">Copy URL</button>';
        html += '<div class="share-inline-info">This URL contains only the SSID and mode. <strong>Your passphrase is NOT included</strong>.</div>';
        html += '</div>';

        $('emptyState').style.display = 'none';
        var rc = $('resultContent');
        rc.innerHTML = html;
        rc.style.display = 'block';
    }

    // ========== Form Submit ==========

    $('pbkdfForm').addEventListener('submit', function(e) {
        e.preventDefault();
        deriveKey();
    });

    function deriveKey() {
        var password = $('password').value;
        if (!password) { showToast('Please enter a password'); return; }

        var isWpa = (currentMode === 'wpa');

        if (isWpa) {
            var ssid = ($('ssid').value || '').trim();
            if (!ssid) { showToast('Please enter the WiFi SSID'); return; }
            if (ssid.length < 1 || ssid.length > 32) { showToast('SSID must be 1-32 characters'); return; }
            if (password.length < 8 || password.length > 63) { showToast('WPA passphrase must be 8-63 characters'); return; }
        }

        var saltVal = $('salt').value.trim();
        if (!isWpa && !saltVal) {
            $('generateSaltBtn').click();
            saltVal = $('salt').value;
        }

        var btn = $('generateBtn');
        btn.disabled = true;
        btn.textContent = isWpa ? 'Calculating...' : 'Deriving...';

        var startTime = performance.now();
        var formData = new FormData($('pbkdfForm'));

        // WPA mode: override params for IEEE 802.11i compliance
        if (isWpa) {
            // Remove any existing algo checkboxes from form data
            formData.delete('cipherparameternew');
            formData.set('cipherparameternew', 'PBKDF2WithHmacSHA1');
            formData.set('rounds', '4096');
            formData.set('keylength', '32');
            // Use SSID as salt — encode to Base64
            var ssidB64 = btoa($('ssid').value);
            formData.set('salt', ssidB64);
        }

        fetch('PBEFunctionality', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams(formData).toString()
        })
        .then(function(r) { return r.json(); })
        .then(function(response) {
            var duration = (performance.now() - startTime).toFixed(0);
            btn.disabled = false;
            btn.textContent = isWpa ? 'Calculate PSK' : 'Derive Key';

            if (response.success) {
                lastResults = response.results;
                lastParams = {
                    salt: response.salt,
                    iterations: response.iterations,
                    keyLength: response.keyLengthBytes
                };
                if (isWpa && response.results.length > 0) {
                    renderWpaResult(response.results[0], duration);
                } else {
                    renderKeyResults(response.results, duration);
                }
            } else {
                showError(response.errorMessage || 'Key derivation failed');
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.textContent = isWpa ? 'Calculate PSK' : 'Derive Key';
            showError('Request failed: ' + err.message);
        });
    }

    // ========== Render Results ==========

    function getAlgoDisplayName(algo) {
        var names = {
            'PBKDF2WithHmacSHA1': 'HMAC-SHA1',
            'PBKDF2WithHmacSHA256': 'HMAC-SHA256',
            'PBKDF2WithHmacSHA384': 'HMAC-SHA384',
            'PBKDF2WithHmacSHA512': 'HMAC-SHA512'
        };
        return names[algo] || algo;
    }

    function renderKeyResults(results, duration) {
        var html = '';

        html += '<div class="pbkdf-success">';
        html += '<strong>' + results.length + ' Key' + (results.length > 1 ? 's' : '') + ' Derived!</strong> Computed in ' + duration + 'ms';
        html += '</div>';

        for (var i = 0; i < results.length; i++) {
            var result = results[i];
            html += '<div class="result-algo-block">';
            html += '<div class="result-algo-header">';
            html += '<span class="result-algo-badge">' + getAlgoDisplayName(result.algorithm) + '</span>';
            html += '<button class="result-copy-btn" onclick="window._pbkdfCopyKey(' + i + ')">Copy</button>';
            html += '</div>';
            html += '<div class="key-output">';
            html += '<span id="derivedKey_' + i + '" data-base64="' + escapeHtml(result.derivedKey) + '">' + escapeHtml(result.derivedKey) + '</span>';
            html += '</div>';
            if (result.iv && result.iv !== 'null') {
                html += '<p class="tool-hint" style="margin-top:0.375rem;">IV: ' + escapeHtml(result.iv) + '</p>';
            }
            html += '</div>';
        }

        // Format toggle
        html += '<div style="margin-bottom:0.75rem;">';
        html += '<span style="font-size:0.75rem;color:var(--text-muted);margin-right:0.5rem;">Output Format:</span>';
        html += '<button class="output-format-btn active" onclick="window._pbkdfFormatAll(\'base64\',this)">Base64</button> ';
        html += '<button class="output-format-btn" onclick="window._pbkdfFormatAll(\'hex\',this)">Hex</button>';
        html += '</div>';

        // Action buttons
        html += '<div class="result-actions-row">';
        html += '<button class="result-action-btn" onclick="window._pbkdfShareUrl()">Share URL</button>';
        html += '<button class="result-action-btn" onclick="window._pbkdfDownload()">Download JSON</button>';
        html += '</div>';

        // Share URL inline section
        html += '<div class="share-inline" id="shareInline">';
        html += '<input class="share-inline-input" id="shareUrlInput" readonly>';
        html += '<button class="result-action-btn" onclick="window._pbkdfCopyShareUrl()" style="margin-bottom:0.5rem;">Copy URL</button>';
        html += '<div class="share-inline-info">This URL contains only derivation parameters (salt, iterations, key length, algorithms). <strong>Your password is NOT included</strong>.</div>';
        html += '</div>';

        // Parameters used
        html += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:0.5rem;font-size:0.75rem;color:var(--text-muted);">';
        html += '<div><strong>Iterations:</strong> ' + parseInt(lastParams.iterations).toLocaleString() + '</div>';
        html += '<div><strong>Key Length:</strong> ' + lastParams.keyLength + ' bytes</div>';
        html += '</div>';

        // Security Audit Panel
        if (results.length > 0) {
            var auditParams = {
                iterations: lastParams.iterations,
                algorithm: results[0].algorithm,
                salt: lastParams.salt,
                keyLength: lastParams.keyLength
            };
            var audit = computeSecurityAudit(auditParams);
            html += renderSecurityAudit(audit);
        }

        $('emptyState').style.display = 'none';
        var rc = $('resultContent');
        rc.innerHTML = html;
        rc.style.display = 'block';
    }

    function showError(message) {
        var html = '<div class="pbkdf-error"><strong>Error:</strong> ' + escapeHtml(message) + '</div>';
        $('emptyState').style.display = 'none';
        var rc = $('resultContent');
        rc.innerHTML = html;
        rc.style.display = 'block';
    }

    // ========== Global handlers (called from rendered HTML) ==========

    window._pbkdfCopyKey = function(index) {
        var el = $('derivedKey_' + index);
        if (el) copyText(el.textContent, 'Key copied!');
    };

    window._pbkdfFormatAll = function(format, btn) {
        qsa('.output-format-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');

        for (var i = 0; i < lastResults.length; i++) {
            var base64 = lastResults[i].derivedKey;
            var el = $('derivedKey_' + i);
            if (!el) continue;
            if (format === 'hex') {
                try {
                    var binary = atob(base64);
                    var hex = '';
                    for (var j = 0; j < binary.length; j++) {
                        hex += ('0' + binary.charCodeAt(j).toString(16)).slice(-2);
                    }
                    el.textContent = hex;
                } catch (e) { showToast('Error converting to hex'); }
            } else {
                el.textContent = base64;
            }
        }
    };

    window._pbkdfShareUrl = function() {
        if (!lastResults || lastResults.length === 0) { showToast('Derive a key first'); return; }

        var params = new URLSearchParams();

        if (currentMode === 'wpa') {
            params.set('mode', 'wpa');
            params.set('ssid', $('ssid').value || '');
        } else {
            var algos = lastResults.map(function(r) { return r.algorithm; }).join(',');
            params.set('salt', lastParams.salt || '');
            params.set('iter', lastParams.iterations);
            params.set('len', lastParams.keyLength);
            params.set('algos', algos);
        }

        var shareUrlStr = window.location.origin + window.location.pathname + '?' + params.toString();
        var shareInput = $('shareUrlInput');
        if (shareInput) {
            shareInput.value = shareUrlStr;
            $('shareInline').classList.add('visible');
        }
    };

    window._pbkdfCopyShareUrl = function() {
        var url = $('shareUrlInput').value;
        copyText(url, 'URL copied!');
    };

    window._pbkdfDownload = function() {
        if (!lastResults || lastResults.length === 0) { showToast('Derive a key first'); return; }

        var content = {
            results: lastResults.map(function(r) {
                return { algorithm: r.algorithm, derivedKey: r.derivedKey, iv: r.iv };
            }),
            salt: lastParams.salt,
            iterations: parseInt(lastParams.iterations),
            keyLengthBytes: parseInt(lastParams.keyLength),
            timestamp: new Date().toISOString()
        };

        var blob = new Blob([JSON.stringify(content, null, 2)], { type: 'application/json' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'pbkdf2-keys-' + Date.now() + '.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        showToast('Key file downloaded');
    };

    // ========== Load from URL ==========

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var modeParam = params.get('mode');
        var ssidParam = params.get('ssid');
        var saltParam = params.get('salt');
        var iter = params.get('iter');
        var len = params.get('len');
        var algos = params.get('algos');

        // WPA mode from URL
        if (modeParam === 'wpa') {
            switchMode('wpa');
            if (ssidParam) $('ssid').value = ssidParam;
            showToast('WPA-PSK mode loaded - enter passphrase to calculate');
            return;
        }

        if (saltParam) $('salt').value = saltParam;
        if (iter) {
            $('iterationsSlider').value = iter;
            $('iterationsValue').textContent = parseInt(iter).toLocaleString();
            $('rounds').value = iter;
        }
        if (len) {
            $('keyLengthSlider').value = len;
            $('keyLengthValue').textContent = len;
            $('keylength').value = len;
        }
        if (algos) {
            qsa('input[name="cipherparameternew"]').forEach(function(cb) { cb.checked = false; });
            algos.split(',').forEach(function(algo) {
                var cb = qs('input[name="cipherparameternew"][value="' + algo + '"]');
                if (cb) cb.checked = true;
            });
            showToast('Shared parameters loaded - enter password to derive');
        }
    }

    loadFromUrl();

    })();

    // ========== Code Tabs (global) ==========

    function switchCodeTab(lang, btn) {
        document.querySelectorAll('.code-tab').forEach(function(t) { t.classList.remove('active'); });
        document.querySelectorAll('.code-tab-panel').forEach(function(p) { p.classList.remove('active'); });
        btn.classList.add('active');
        var panel = document.getElementById('codePanel-' + lang);
        if (panel) panel.classList.add('active');
    }

    // Copy code snippets
    document.querySelectorAll('.copy-cmd-btn[data-snippet]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.closest('.terminal-block');
            var body = panel.querySelector('.terminal-body');
            if (body) {
                navigator.clipboard.writeText(body.textContent).then(function() {
                    btn.textContent = 'Copied!';
                    setTimeout(function() { btn.textContent = 'Copy'; }, 1500);
                });
            }
        });
    });

    // ========== FAQ Accordion (global) ==========

    function toggleFaq(btn) {
        var item = btn.closest('.faq-item');
        item.classList.toggle('open');
    }
    </script>
</body>
</html>
