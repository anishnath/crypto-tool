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
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
            --tool-primary:#8b5cf6;--tool-primary-dark:#7c3aed;--tool-gradient:linear-gradient(135deg,#a78bfa 0%,#8b5cf6 100%);--tool-light:#ede9fe
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(139,92,246,0.15)}
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
        @media(max-width:991px){.modern-nav{height:var(--header-height-mobile,64px)}.nav-container{padding:0 var(--space-3,0.75rem)}.nav-search,.nav-items{display:none}.nav-actions{gap:var(--space-2,0.5rem)}.btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}.mobile-menu-toggle,.mobile-search-toggle{display:flex}.btn-nav .nav-text{display:none}}
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
        .tool-action-btn:hover{opacity:0.9;transform:translateY(-1px)}
        .tool-action-btn:active{transform:translateY(0)}
        .tool-action-btn:disabled{opacity:0.5;cursor:not-allowed;transform:none}
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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(139,92,246,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ISBN Validator & Barcode Generator | Free Online" />
        <jsp:param name="toolDescription" value="Validate ISBN-10 and ISBN-13 instantly. Convert formats, calculate check digits, and generate EAN-13 barcodes. Download as PNG or SVG. No signup needed." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="isbn-validator.jsp" />
        <jsp:param name="toolKeywords" value="isbn validator, isbn checker, isbn converter, isbn-10 validator, isbn-13 validator, isbn format checker, isbn check digit calculator, isbn to ean, convert isbn-10 to isbn-13, isbn barcode generator, validate isbn number, isbn lookup, isbn-10 to isbn-13 converter, isbn number checker, book isbn validator, verify isbn" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Validate ISBN-10 and ISBN-13 format,Convert between ISBN-10 and ISBN-13,Calculate check digits automatically,Generate EAN-13 barcodes from ISBN,Download barcode as PNG or SVG,Real-time validation with error messages" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is an ISBN and what does it stand for?" />
        <jsp:param name="faq1a" value="ISBN stands for International Standard Book Number. It is a unique numeric identifier assigned to every published book. ISBN-10 uses 10 digits (legacy format before 2007) and ISBN-13 uses 13 digits (current standard). The ISBN system is defined by ISO 2108 and managed by the International ISBN Agency." />
        <jsp:param name="faq2q" value="How do you validate an ISBN check digit?" />
        <jsp:param name="faq2a" value="For ISBN-13, multiply each digit alternately by 1 and 3, sum the results, and verify the check digit makes the total divisible by 10. For ISBN-10, multiply each digit by its position (1-10), sum the results, and verify the total is divisible by 11. The check digit X in ISBN-10 represents the value 10." />
        <jsp:param name="faq3q" value="How do you convert ISBN-10 to ISBN-13?" />
        <jsp:param name="faq3a" value="To convert ISBN-10 to ISBN-13: add the prefix 978, drop the old check digit, then recalculate a new check digit using the ISBN-13 modulo-10 algorithm. Only ISBN-13 numbers starting with 978 can be converted back to ISBN-10. Numbers with the 979 prefix have no ISBN-10 equivalent." />
        <jsp:param name="faq4q" value="What is the difference between ISBN-10 and ISBN-13?" />
        <jsp:param name="faq4a" value="ISBN-10 is the older 10-digit format used before 2007 with a modulo-11 check digit that can include X. ISBN-13 is the current 13-digit standard that starts with 978 or 979 and uses a modulo-10 check digit. ISBN-13 is compatible with the EAN-13 barcode system used in retail." />
        <jsp:param name="faq5q" value="Can I generate a barcode from an ISBN number?" />
        <jsp:param name="faq5a" value="Yes, ISBN-13 numbers are directly compatible with EAN-13 barcodes used in bookstores and retail. Enter any valid ISBN into the validator and it will automatically generate a scannable EAN-13 barcode that you can download as PNG or SVG for use on book covers or labels." />
        <jsp:param name="faq6q" value="Who needs to validate ISBN numbers?" />
        <jsp:param name="faq6a" value="Publishers need to validate ISBNs before printing books. Libraries use ISBN validation for cataloging and inventory systems. Bookstores verify ISBNs for product listings. Authors check their assigned ISBNs before submission. E-commerce platforms validate ISBNs for accurate book identification in databases." />
    </jsp:include>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
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
    <!-- JsBarcode Library -->
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js" defer></script>
    <style>
        .isbn-input{width:100%;padding:0.625rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.9375rem;font-family:var(--font-mono);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);transition:border-color var(--transition-fast);letter-spacing:0.02em}
        .isbn-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(139,92,246,0.1)}
        [data-theme="dark"] .isbn-input{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        [data-theme="dark"] .isbn-input:focus{box-shadow:0 0 0 3px rgba(139,92,246,0.25)}
        .isbn-select{width:100%;padding:0.625rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.875rem;font-family:var(--font-sans);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);cursor:pointer}
        .isbn-select:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(139,92,246,0.1)}
        [data-theme="dark"] .isbn-select{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        .isbn-examples{display:flex;flex-wrap:wrap;gap:0.375rem}
        .isbn-chip{padding:0.3rem 0.625rem;font-size:0.75rem;font-family:var(--font-mono);background:var(--bg-secondary,#f8fafc);border:none;border-radius:var(--radius-full,9999px);cursor:pointer;transition:all 0.15s;color:var(--text-secondary);white-space:nowrap}
        .isbn-chip:hover{background:var(--tool-primary);color:#fff}
        [data-theme="dark"] .isbn-chip{background:var(--bg-tertiary);color:var(--text-secondary)}
        [data-theme="dark"] .isbn-chip:hover{background:var(--tool-primary);color:#fff}
        .isbn-sep{border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.75rem 0}
        .isbn-btn-row{display:flex;gap:0.5rem;margin-top:0.75rem}
        .isbn-btn-row .tool-action-btn{margin-top:0;flex:1}
        .isbn-btn-secondary{background:linear-gradient(135deg,#10b981 0%,#059669 100%)}
        .isbn-btn-clear{background:var(--bg-secondary,#f8fafc);color:var(--text-secondary);border:1px solid var(--border)}
        .isbn-btn-clear:hover{background:var(--bg-tertiary)}
        [data-theme="dark"] .isbn-btn-clear{background:var(--bg-tertiary);color:var(--text-secondary);border-color:var(--border)}
        .isbn-valid{background:#d1fae5;color:#065f46;border-left:4px solid #10b981;padding:0.75rem;border-radius:0 var(--radius-md) var(--radius-md) 0;font-weight:600;font-size:0.875rem;margin-bottom:0.75rem}
        .isbn-invalid{background:#fee2e2;color:#991b1b;border-left:4px solid #ef4444;padding:0.75rem;border-radius:0 var(--radius-md) var(--radius-md) 0;font-weight:600;font-size:0.875rem;margin-bottom:0.75rem}
        .isbn-warn{background:#fef3c7;color:#92400e;border-left:4px solid #f59e0b;padding:0.75rem;border-radius:0 var(--radius-md) var(--radius-md) 0;font-weight:600;font-size:0.875rem;margin-bottom:0.75rem}
        [data-theme="dark"] .isbn-valid{background:rgba(16,185,129,0.15);color:#6ee7b7;border-left-color:#10b981}
        [data-theme="dark"] .isbn-invalid{background:rgba(239,68,68,0.15);color:#fca5a5;border-left-color:#ef4444}
        [data-theme="dark"] .isbn-warn{background:rgba(245,158,11,0.15);color:#fcd34d;border-left-color:#f59e0b}
        .isbn-display{font-family:var(--font-mono);font-size:1.25rem;font-weight:700;color:var(--tool-primary-dark);background:var(--tool-light);padding:0.75rem;border-radius:var(--radius-md);text-align:center;margin-bottom:0.75rem;letter-spacing:0.04em}
        .isbn-info-grid{display:grid;gap:0.375rem;margin-bottom:0.75rem}
        .isbn-info-row{display:flex;justify-content:space-between;padding:0.5rem 0.75rem;background:var(--bg-secondary);border-radius:var(--radius-sm);font-size:0.8125rem}
        .isbn-info-label{font-weight:600;color:var(--text-muted)}
        .isbn-info-value{font-weight:600;color:var(--tool-primary-dark);font-family:var(--font-mono)}
        [data-theme="dark"] .isbn-info-row{background:var(--bg-tertiary)}
        [data-theme="dark"] .isbn-info-value{color:var(--tool-primary)}
        .isbn-convert-box{padding:0.75rem;background:var(--primary-50,#eef2ff);border:1px solid var(--primary-100,#e0e7ff);border-radius:var(--radius-md);margin-bottom:0.75rem}
        .isbn-convert-box strong{font-size:0.8125rem;color:var(--text-secondary);display:block;margin-bottom:0.25rem}
        .isbn-convert-box code{font-size:1.1rem;font-weight:700;font-family:var(--font-mono);color:var(--tool-primary-dark)}
        [data-theme="dark"] .isbn-convert-box{background:rgba(139,92,246,0.1);border-color:rgba(139,92,246,0.2)}
        [data-theme="dark"] .isbn-convert-box code{color:var(--tool-primary)}
        .isbn-barcode-section{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:1rem;text-align:center;margin-bottom:0.75rem}
        .isbn-barcode-section h5{font-size:0.8125rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.75rem}
        .isbn-barcode-area{min-height:80px;display:flex;align-items:center;justify-content:center}
        .isbn-barcode-btns{display:flex;gap:0.5rem;justify-content:center;margin-top:0.75rem}
        .isbn-barcode-btns button{padding:0.4rem 0.75rem;font-size:0.75rem;font-weight:600;border:1px solid var(--border);border-radius:var(--radius-md);background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .isbn-barcode-btns button:hover{border-color:var(--tool-primary);color:var(--tool-primary)}
        [data-theme="dark"] .isbn-barcode-section{background:var(--bg-tertiary);border-color:var(--border)}
        [data-theme="dark"] .isbn-barcode-btns button{background:var(--bg-secondary);color:var(--text-secondary);border-color:var(--border)}
        /* CSS-animated empty state */
        .isbn-empty-anim{position:relative;width:260px;height:180px;margin:0 auto 1rem}
        .isbn-book{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);width:80px;height:110px;background:var(--tool-gradient);border-radius:4px 12px 12px 4px;box-shadow:0 8px 24px rgba(139,92,246,0.25);display:flex;align-items:center;justify-content:center;animation:isbn-float 3s ease-in-out infinite}
        .isbn-book-spine{position:absolute;left:0;top:0;bottom:0;width:8px;background:rgba(0,0,0,0.15);border-radius:4px 0 0 4px}
        .isbn-book-lines{display:flex;flex-direction:column;gap:4px;align-items:center}
        .isbn-book-line{height:2px;background:rgba(255,255,255,0.6);border-radius:1px}
        .isbn-book-line:nth-child(1){width:36px}
        .isbn-book-line:nth-child(2){width:28px}
        .isbn-book-line:nth-child(3){width:32px}
        .isbn-barcode-anim{position:absolute;bottom:20px;left:50%;transform:translateX(-50%);display:flex;gap:2px;align-items:flex-end;height:30px;animation:isbn-barcode-fade 2.5s ease-in-out infinite}
        .isbn-bar{width:2px;background:var(--text-muted,#94a3b8);border-radius:1px;animation:isbn-bar-grow 2s ease-in-out infinite}
        .isbn-bar:nth-child(1){height:20px;animation-delay:0s}
        .isbn-bar:nth-child(2){height:28px;animation-delay:0.1s}
        .isbn-bar:nth-child(3){height:14px;animation-delay:0.2s}
        .isbn-bar:nth-child(4){height:28px;animation-delay:0.3s}
        .isbn-bar:nth-child(5){height:18px;animation-delay:0.4s}
        .isbn-bar:nth-child(6){height:26px;animation-delay:0.5s}
        .isbn-bar:nth-child(7){height:12px;animation-delay:0.6s}
        .isbn-bar:nth-child(8){height:24px;animation-delay:0.7s}
        .isbn-bar:nth-child(9){height:28px;animation-delay:0.8s}
        .isbn-bar:nth-child(10){height:16px;animation-delay:0.9s}
        .isbn-bar:nth-child(11){height:22px;animation-delay:1s}
        .isbn-bar:nth-child(12){height:28px;animation-delay:1.1s}
        .isbn-check-circle{position:absolute;top:18px;right:40px;width:32px;height:32px;border:2.5px solid var(--success,#10b981);border-radius:50%;display:flex;align-items:center;justify-content:center;animation:isbn-pulse 2s ease-in-out infinite;opacity:0.7}
        .isbn-check-circle::after{content:'';width:8px;height:14px;border-right:2.5px solid var(--success,#10b981);border-bottom:2.5px solid var(--success,#10b981);transform:rotate(45deg) translate(-1px,-1px)}
        .isbn-convert-arrows{position:absolute;top:28px;left:36px;animation:isbn-arrows 2.5s ease-in-out infinite;opacity:0.5}
        .isbn-arrow{width:20px;height:2px;background:var(--tool-primary);border-radius:1px;position:relative;margin:6px 0}
        .isbn-arrow::after{content:'';position:absolute;right:-1px;top:-3px;border:4px solid transparent;border-left:5px solid var(--tool-primary)}
        .isbn-arrow:nth-child(2){transform:rotate(180deg)}
        @keyframes isbn-float{0%,100%{transform:translate(-50%,-50%) translateY(0)}50%{transform:translate(-50%,-50%) translateY(-8px)}}
        @keyframes isbn-bar-grow{0%,100%{transform:scaleY(1)}50%{transform:scaleY(0.6)}}
        @keyframes isbn-barcode-fade{0%,100%{opacity:0.7}50%{opacity:1}}
        @keyframes isbn-pulse{0%,100%{transform:scale(1);opacity:0.7}50%{transform:scale(1.15);opacity:1}}
        @keyframes isbn-arrows{0%,100%{transform:translateX(0);opacity:0.5}50%{transform:translateX(4px);opacity:0.9}}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
        .isbn-edu-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;margin-top:1rem}
        .isbn-edu-card{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:1.25rem}
        .isbn-edu-card h4{font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem}
        .isbn-edu-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        [data-theme="dark"] .isbn-edu-card{background:var(--bg-tertiary);border-color:var(--border)}
        .isbn-format-table{width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem}
        .isbn-format-table th,.isbn-format-table td{padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border)}
        .isbn-format-table th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary);font-size:0.75rem;text-transform:uppercase;letter-spacing:0.04em}
        .isbn-format-table td{color:var(--text-secondary)}
        [data-theme="dark"] .isbn-format-table th{background:var(--bg-tertiary)}
        .isbn-book-card{display:flex;gap:1rem;padding:0.875rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);margin-bottom:0.75rem}
        .isbn-book-cover{width:60px;height:90px;border-radius:4px;object-fit:cover;background:var(--bg-tertiary);flex-shrink:0;box-shadow:0 2px 8px rgba(0,0,0,0.12)}
        .isbn-book-cover-placeholder{width:60px;height:90px;border-radius:4px;background:var(--tool-light);display:flex;align-items:center;justify-content:center;flex-shrink:0;color:var(--tool-primary);font-size:0.625rem;font-weight:600;text-align:center;padding:0.25rem}
        .isbn-book-meta{flex:1;min-width:0}
        .isbn-book-title{font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.25rem;line-height:1.3}
        .isbn-book-author{font-size:0.75rem;color:var(--text-secondary);margin-bottom:0.375rem}
        .isbn-book-details{display:flex;flex-wrap:wrap;gap:0.375rem}
        .isbn-book-tag{font-size:0.625rem;font-weight:600;padding:0.15rem 0.5rem;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .isbn-book-card{background:var(--bg-tertiary);border-color:var(--border)}
        .isbn-book-loading{font-size:0.75rem;color:var(--text-muted);display:flex;align-items:center;gap:0.5rem}
        @keyframes isbn-dot-pulse{0%,80%,100%{opacity:0.3}40%{opacity:1}}
        .isbn-book-loading span{animation:isbn-dot-pulse 1.4s ease-in-out infinite}
        .isbn-book-loading span:nth-child(2){animation-delay:0.2s}
        .isbn-book-loading span:nth-child(3){animation-delay:0.4s}
        .isbn-steps{margin-bottom:0.75rem;border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
        .isbn-steps-header{display:flex;align-items:center;justify-content:space-between;padding:0.625rem 0.75rem;background:var(--bg-secondary);cursor:pointer;font-size:0.8125rem;font-weight:600;color:var(--text-primary);border:none;width:100%;font-family:var(--font-sans)}
        .isbn-steps-header:hover{background:var(--bg-tertiary)}
        .isbn-steps-body{display:none;padding:0.75rem;font-size:0.75rem;font-family:var(--font-mono);line-height:1.8;color:var(--text-secondary);border-top:1px solid var(--border);background:var(--bg-primary)}
        .isbn-steps.open .isbn-steps-body{display:block}
        .isbn-steps-chevron{transition:transform 0.2s;font-size:0.625rem}
        .isbn-steps.open .isbn-steps-chevron{transform:rotate(180deg)}
        .isbn-step-row{display:flex;justify-content:space-between;padding:0.125rem 0;border-bottom:1px dashed var(--border-light)}
        .isbn-step-row:last-child{border-bottom:none}
        .isbn-step-highlight{font-weight:700;color:var(--tool-primary)}
        [data-theme="dark"] .isbn-steps-header{background:var(--bg-tertiary)}
        [data-theme="dark"] .isbn-steps-body{background:var(--bg-secondary)}
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">ISBN Validator - Validate, Convert & Generate Barcodes</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#developer-tools">Developer Tools</a> /
                    ISBN Validator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">ISBN-10 &amp; ISBN-13</span>
                <span class="tool-badge">Barcode Generator</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>ISBN validator</strong> and converter. Validate <strong>ISBN-10</strong> and <strong>ISBN-13</strong> numbers instantly, <strong>convert between formats</strong>, calculate check digits, and generate <strong>EAN-13 barcodes</strong>. Used by publishers, libraries, and bookstores for book identification. Client-side processing &mdash; no data sent to servers.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- INPUT COLUMN -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/>
                    </svg>
                    ISBN Validator
                </div>
                <div class="tool-card-body">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="isbn-input">ISBN Number</label>
                        <input type="text" class="isbn-input" id="isbn-input" placeholder="978-0-306-40615-7" autocomplete="off" spellcheck="false">
                        <div class="tool-form-hint">Enter ISBN-10 or ISBN-13 (dashes are optional)</div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="isbn-action">Action</label>
                        <select class="isbn-select" id="isbn-action">
                            <option value="validate">Validate ISBN</option>
                            <option value="convert">Convert Format</option>
                            <option value="checkdigit">Calculate Check Digit</option>
                        </select>
                    </div>
                    <button type="button" class="tool-action-btn" id="isbn-process-btn">Validate ISBN</button>
                    <div class="isbn-btn-row">
                        <button type="button" class="tool-action-btn isbn-btn-secondary" id="isbn-convert-btn">Convert Format</button>
                        <button type="button" class="tool-action-btn isbn-btn-clear" id="isbn-clear-btn">Clear</button>
                    </div>
                    <hr class="isbn-sep">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Sample ISBNs</label>
                        <div class="isbn-examples">
                            <button type="button" class="isbn-chip" data-isbn="9780061120084">The Alchemist</button>
                            <button type="button" class="isbn-chip" data-isbn="0451524934">1984 (ISBN-10)</button>
                            <button type="button" class="isbn-chip" data-isbn="9791034908219">979 Prefix</button>
                            <button type="button" class="isbn-chip" data-isbn="007462542X">X Check Digit</button>
                            <button type="button" class="isbn-chip" data-isbn="9780306406157">ISBN-13</button>
                            <button type="button" class="isbn-chip" data-isbn="978-0-14-300723-4">With Dashes</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN -->
        <div class="tool-output-column">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>
                    </svg>
                    <h4>Results</h4>
                </div>
                <div class="tool-result-content" id="isbn-result-content">
                    <div class="tool-empty-state" id="isbn-empty-state">
                        <!-- CSS-animated book + barcode empty state -->
                        <div class="isbn-empty-anim">
                            <div class="isbn-book">
                                <div class="isbn-book-spine"></div>
                                <div class="isbn-book-lines">
                                    <div class="isbn-book-line"></div>
                                    <div class="isbn-book-line"></div>
                                    <div class="isbn-book-line"></div>
                                </div>
                            </div>
                            <div class="isbn-barcode-anim">
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                                <div class="isbn-bar"></div>
                            </div>
                            <div class="isbn-check-circle"></div>
                            <div class="isbn-convert-arrows">
                                <div class="isbn-arrow"></div>
                                <div class="isbn-arrow"></div>
                            </div>
                        </div>
                        <h3>Enter an ISBN to validate</h3>
                        <p>Check ISBN format, convert between ISBN-10 and ISBN-13, and generate EAN-13 barcodes.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="isbn-result-actions">
                    <button type="button" class="tool-action-btn" id="isbn-copy-btn">&#128203; Copy Result</button>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="isbn-validator.jsp"/>
        <jsp:param name="keyword" value="developer"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Educational Content -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is an ISBN?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">An <strong>ISBN</strong> (International Standard Book Number) is a unique numeric commercial book identifier assigned to every published edition. Since 2007, all new ISBNs are 13 digits long (<strong>ISBN-13</strong>). Older books may use the legacy 10-digit format (<strong>ISBN-10</strong>), which can be converted to ISBN-13.</p>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The ISBN system is defined by <strong>ISO 2108</strong> and managed by the International ISBN Agency. It is used worldwide by publishers, libraries, bookstores, and e-commerce platforms for accurate book identification.</p>
            <div class="isbn-edu-grid">
                <div class="isbn-edu-card" style="border-left:3px solid #8b5cf6;">
                    <h4>Publishers</h4>
                    <p>Register books with unique identifiers for distribution, tracking, and royalty reporting across markets.</p>
                </div>
                <div class="isbn-edu-card" style="border-left:3px solid #a78bfa;">
                    <h4>Libraries</h4>
                    <p>Cataloging and inventory management systems rely on ISBNs for accurate book identification and inter-library loans.</p>
                </div>
                <div class="isbn-edu-card" style="border-left:3px solid #7c3aed;">
                    <h4>Bookstores</h4>
                    <p>Point-of-sale systems use ISBN barcodes (EAN-13) for inventory tracking and automated checkout.</p>
                </div>
                <div class="isbn-edu-card" style="border-left:3px solid #6d28d9;">
                    <h4>E-commerce</h4>
                    <p>Online retailers use ISBNs to match product listings, aggregate reviews, and prevent duplicate entries.</p>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Validate an ISBN Step by Step</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Follow these steps to check if an ISBN number is valid using this free <strong>ISBN checker</strong>:</p>
            <div style="display:flex;flex-direction:column;gap:0.75rem;">
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">1</span>
                    <div><strong style="color:var(--text-primary);">Enter the ISBN number</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Type or paste the ISBN-10 or ISBN-13 number. Dashes and spaces are automatically stripped during validation.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">2</span>
                    <div><strong style="color:var(--text-primary);">Click &ldquo;Validate ISBN&rdquo;</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">The tool checks the format, verifies the check digit using the appropriate algorithm (modulo-10 for ISBN-13, modulo-11 for ISBN-10), and reports validity.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">3</span>
                    <div><strong style="color:var(--text-primary);">View results and convert</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">See formatted ISBN, check digit details, and optionally convert between ISBN-10 and ISBN-13. An EAN-13 barcode is automatically generated.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">4</span>
                    <div><strong style="color:var(--text-primary);">Download the barcode</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Export the generated EAN-13 barcode as PNG or SVG for use on book covers, packaging, or library labels.</p></div>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">ISBN-10 vs ISBN-13 Comparison</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Understanding the differences between the two ISBN formats:</p>
            <table class="isbn-format-table">
                <thead><tr><th>Feature</th><th>ISBN-10</th><th>ISBN-13</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Length</td><td>10 digits</td><td>13 digits</td></tr>
                    <tr><td style="font-weight:600;">Prefix</td><td>None</td><td>978 or 979</td></tr>
                    <tr><td style="font-weight:600;">Check Digit</td><td>Modulo-11 (0-9 or X)</td><td>Modulo-10 (0-9 only)</td></tr>
                    <tr><td style="font-weight:600;">Status</td><td>Legacy (pre-2007)</td><td>Current standard</td></tr>
                    <tr><td style="font-weight:600;">Barcode</td><td>Not EAN-compatible</td><td>EAN-13 compatible</td></tr>
                    <tr><td style="font-weight:600;">Conversion</td><td>Add 978 + recalculate</td><td>Only 978-prefix to ISBN-10</td></tr>
                </tbody>
            </table>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How ISBN Check Digits Are Calculated</h2>
            <div class="isbn-edu-grid" style="grid-template-columns:1fr 1fr;">
                <div class="isbn-edu-card" style="border-left:3px solid #8b5cf6;">
                    <h4>ISBN-13 (Modulo-10)</h4>
                    <p>Multiply each of the first 12 digits by alternating weights of 1 and 3. Sum all products. The check digit is (10 - sum mod 10) mod 10. This makes the total of all 13 weighted digits divisible by 10.</p>
                </div>
                <div class="isbn-edu-card" style="border-left:3px solid #7c3aed;">
                    <h4>ISBN-10 (Modulo-11)</h4>
                    <p>Multiply each of the first 9 digits by its position (1 through 9). Sum all products. The check digit is sum mod 11. If the result is 10, the check digit is represented as X.</p>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is an ISBN and what does it stand for?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">ISBN stands for International Standard Book Number. It is a unique numeric identifier assigned to every published book. ISBN-10 uses 10 digits (legacy format before 2007) and ISBN-13 uses 13 digits (current standard). The ISBN system is defined by ISO 2108 and managed by the International ISBN Agency.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you validate an ISBN check digit?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">For ISBN-13, multiply each digit alternately by 1 and 3, sum the results, and verify the check digit makes the total divisible by 10. For ISBN-10, multiply each digit by its position (1-10), sum the results, and verify the total is divisible by 11. The check digit X in ISBN-10 represents the value 10.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you convert ISBN-10 to ISBN-13?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To convert ISBN-10 to ISBN-13: add the prefix 978, drop the old check digit, then recalculate a new check digit using the ISBN-13 modulo-10 algorithm. Only ISBN-13 numbers starting with 978 can be converted back to ISBN-10. Numbers with the 979 prefix have no ISBN-10 equivalent.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the difference between ISBN-10 and ISBN-13?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">ISBN-10 is the older 10-digit format used before 2007 with a modulo-11 check digit that can include X. ISBN-13 is the current 13-digit standard that starts with 978 or 979 and uses a modulo-10 check digit. ISBN-13 is compatible with the EAN-13 barcode system used in retail.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Can I generate a barcode from an ISBN number?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes, ISBN-13 numbers are directly compatible with EAN-13 barcodes used in bookstores and retail. Enter any valid ISBN into the validator and it will automatically generate a scannable EAN-13 barcode that you can download as PNG or SVG for use on book covers or labels.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Who needs to validate ISBN numbers?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Publishers need to validate ISBNs before printing books. Libraries use ISBN validation for cataloging and inventory systems. Bookstores verify ISBNs for product listings. Authors check their assigned ISBNs before submission. E-commerce platforms validate ISBNs for accurate book identification in databases.</div></div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>
    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a><a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a></div></div></footer>
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/js/isbn-validator.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
