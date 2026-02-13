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
            --tool-primary:#3b82f6;--tool-primary-dark:#2563eb;--tool-gradient:linear-gradient(135deg,#60a5fa 0%,#3b82f6 100%);--tool-light:#eff6ff
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(59,130,246,0.15)}
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
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(59,130,246,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-empty-state h3{color:var(--text-secondary,#cbd5e1)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Subdomain Finder | Free Online Subdomain Lookup" />
        <jsp:param name="toolDescription" value="Free subdomain finder to discover all subdomains of any domain. Scans certificate transparency logs and DNS records for complete subdomain enumeration." />
        <jsp:param name="toolCategory" value="Network Tools" />
        <jsp:param name="toolUrl" value="subdomain.jsp" />
        <jsp:param name="toolKeywords" value="subdomain finder, subdomain lookup, find subdomains, subdomain scanner, subdomain enumeration, subdomain search, subdomain checker, find subdomains of a domain, subdomain finder online free, subdomain discovery tool, dns subdomain finder, certificate transparency subdomain, domain reconnaissance, attack surface discovery, find all subdomains, subdomain enumeration tool" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Certificate transparency log scanning,DNS record enumeration,Real-time subdomain discovery,Multiple OSINT source aggregation,Source attribution for each subdomain,Free with no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is subdomain enumeration?" />
        <jsp:param name="faq1a" value="Subdomain enumeration is the process of discovering all subdomains associated with a root domain. It uses techniques like certificate transparency log scanning, DNS brute-forcing, and OSINT data collection to reveal hosts such as mail.example.com, dev.example.com, or api.example.com that may not be publicly linked." />
        <jsp:param name="faq2q" value="How do I find all subdomains of a domain?" />
        <jsp:param name="faq2a" value="Enter the root domain (e.g., example.com) into a subdomain finder tool. The tool queries certificate transparency logs, DNS records, and search engine indexes to compile a list of known subdomains. For thorough results, combine multiple sources including CT logs, passive DNS databases, and brute-force wordlists." />
        <jsp:param name="faq3q" value="What is certificate transparency and how does it help find subdomains?" />
        <jsp:param name="faq3a" value="Certificate Transparency (CT) is a public framework that logs all SSL/TLS certificates issued by certificate authorities. Since certificates often include subdomain names in the Subject Alternative Name (SAN) field, querying CT logs reveals subdomains that have valid SSL certificates - even internal or staging subdomains that are not publicly linked." />
        <jsp:param name="faq4q" value="Why is subdomain discovery important for security?" />
        <jsp:param name="faq4a" value="Subdomains often expose forgotten staging environments, unpatched services, internal APIs, and legacy applications. These overlooked assets are common targets for attackers. Subdomain enumeration during penetration testing or bug bounty hunting helps map the full attack surface so vulnerabilities can be identified and remediated before exploitation." />
        <jsp:param name="faq5q" value="What are the best methods for subdomain enumeration?" />
        <jsp:param name="faq5a" value="The most effective methods include: (1) Certificate transparency log scanning for SSL-covered subdomains, (2) Passive DNS databases that store historical DNS resolutions, (3) DNS brute-force with wordlists to guess common subdomain names, (4) Search engine dorking using site: operator, and (5) Web archive crawling for historically referenced subdomains." />
        <jsp:param name="faq6q" value="Can subdomain finder tools discover hidden subdomains?" />
        <jsp:param name="faq6a" value="Yes, subdomain finder tools can reveal subdomains that are not publicly linked on a website. Certificate transparency logs capture subdomains with SSL certificates, passive DNS records store historical resolutions, and brute-force techniques can guess internal names like dev, staging, or admin. However, subdomains without DNS records, certificates, or public references may remain undiscovered." />
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
    <style>
        .sd-input{width:100%;padding:0.625rem 0.75rem;border:1.5px solid var(--border,#e2e8f0);border-radius:var(--radius-md,0.5rem);font-size:0.9375rem;font-family:var(--font-mono);background:var(--bg-primary,#fff);color:var(--text-primary,#0f172a);transition:border-color var(--transition-fast);letter-spacing:-0.01em}
        .sd-input:focus{outline:none;border-color:var(--tool-primary);box-shadow:0 0 0 3px rgba(59,130,246,0.1)}
        [data-theme="dark"] .sd-input{background:var(--bg-tertiary);border-color:var(--border);color:var(--text-primary)}
        [data-theme="dark"] .sd-input:focus{box-shadow:0 0 0 3px rgba(59,130,246,0.25)}
        .sd-examples{display:flex;flex-wrap:wrap;gap:0.375rem}
        .sd-example-chip{padding:0.3rem 0.625rem;font-size:0.75rem;font-family:var(--font-mono);background:var(--bg-secondary,#f8fafc);border:1px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);cursor:pointer;transition:all 0.15s;color:var(--text-secondary);white-space:nowrap;border:none}
        .sd-example-chip:hover{background:var(--tool-primary);color:#fff;border-color:var(--tool-primary)}
        [data-theme="dark"] .sd-example-chip{background:var(--bg-tertiary);color:var(--text-secondary)}
        [data-theme="dark"] .sd-example-chip:hover{background:var(--tool-primary);color:#fff}
        .sd-sep{border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.75rem 0}
        .sd-stats{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem;margin-bottom:1rem}
        .sd-stat{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:0.75rem 1rem;text-align:center}
        .sd-stat-value{font-size:1.5rem;font-weight:700;color:var(--tool-primary);font-family:var(--font-mono)}
        .sd-stat-label{font-size:0.6875rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted);margin-top:0.125rem}
        [data-theme="dark"] .sd-stat{background:var(--bg-tertiary);border-color:var(--border)}
        .sd-sources{display:flex;flex-wrap:wrap;gap:0.375rem;margin-bottom:1rem}
        .sd-source-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:600;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .sd-list{list-style:none;padding:0;margin:0}
        .sd-item{display:flex;align-items:center;justify-content:space-between;padding:0.5rem 0.75rem;border-bottom:1px solid var(--border-light,#f1f5f9);font-size:0.8125rem;transition:background 0.1s}
        .sd-item:last-child{border-bottom:none}
        .sd-item:hover{background:var(--bg-hover,#f8fafc)}
        .sd-item-host{font-family:var(--font-mono);font-weight:500;color:var(--text-primary);word-break:break-all;font-size:0.8125rem}
        .sd-item-source{font-size:0.6875rem;color:var(--text-muted);white-space:nowrap;margin-left:0.75rem}
        [data-theme="dark"] .sd-item:hover{background:var(--bg-tertiary)}
        @keyframes sd-spin{to{transform:rotate(360deg)}}
        .sd-spinner{width:14px;height:14px;border:2px solid var(--border);border-top-color:var(--tool-primary);border-radius:50%;animation:sd-spin 0.6s linear infinite;display:inline-block;vertical-align:middle;margin-right:0.5rem}
        .sd-loading{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:3rem 1.5rem;gap:1rem}
        .sd-loading-spinner{width:40px;height:40px;border:3px solid var(--border);border-top-color:var(--tool-primary);border-radius:50%;animation:sd-spin 0.8s linear infinite}
        .sd-loading-text{font-size:0.875rem;color:var(--text-secondary);font-weight:500}
        .sd-error{background:#fef3c7;border:1px solid #fbbf24;border-radius:var(--radius-md);padding:1rem;color:#92400e;font-size:0.8125rem}
        [data-theme="dark"] .sd-error{background:rgba(251,191,36,0.15);border-color:rgba(251,191,36,0.3);color:#fbbf24}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
        .sd-edu-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;margin-top:1rem}
        .sd-edu-card{background:var(--bg-secondary);border:1px solid var(--border);border-radius:var(--radius-md);padding:1.25rem}
        .sd-edu-card h4{font-size:0.875rem;font-weight:700;color:var(--text-primary);margin-bottom:0.375rem}
        .sd-edu-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        [data-theme="dark"] .sd-edu-card{background:var(--bg-tertiary);border-color:var(--border)}
        .sd-methods-table{width:100%;border-collapse:collapse;font-size:0.8125rem;margin-top:0.75rem}
        .sd-methods-table th,.sd-methods-table td{padding:0.5rem 0.75rem;text-align:left;border-bottom:1px solid var(--border)}
        .sd-methods-table th{font-weight:600;color:var(--text-primary);background:var(--bg-secondary);font-size:0.75rem;text-transform:uppercase;letter-spacing:0.04em}
        .sd-methods-table td{color:var(--text-secondary)}
        [data-theme="dark"] .sd-methods-table th{background:var(--bg-tertiary)}
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Subdomain Finder - Find All Subdomains of a Domain</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#network-tools">Network Tools</a> /
                    Subdomain Finder
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">CT Log Scanning</span>
                <span class="tool-badge">DNS Enumeration</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>subdomain finder</strong> that discovers all subdomains of any domain. Scans <strong>certificate transparency logs</strong>, <strong>DNS records</strong>, and multiple OSINT sources for complete <strong>subdomain enumeration</strong>. Ideal for <strong>penetration testing</strong>, bug bounty reconnaissance, and <strong>attack surface discovery</strong>. Instant results with source attribution. No signup required.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- INPUT COLUMN -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    Subdomain Finder
                </div>
                <div class="tool-card-body">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="sd-domain">Domain Name</label>
                        <input type="text" class="sd-input" id="sd-domain" placeholder="e.g., example.com" autocomplete="off" spellcheck="false">
                        <div class="tool-form-hint">Enter a domain without protocol (http/https) or path</div>
                    </div>
                    <button type="button" class="tool-action-btn" id="sd-find-btn">Find Subdomains</button>
                    <hr class="sd-sep">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="sd-examples" id="sd-examples">
                            <button type="button" class="sd-example-chip" data-domain="google.com">google.com</button>
                            <button type="button" class="sd-example-chip" data-domain="github.com">github.com</button>
                            <button type="button" class="sd-example-chip" data-domain="microsoft.com">microsoft.com</button>
                            <button type="button" class="sd-example-chip" data-domain="cloudflare.com">cloudflare.com</button>
                            <button type="button" class="sd-example-chip" data-domain="mozilla.org">mozilla.org</button>
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
                        <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 002 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"/>
                        <polyline points="7.5 4.21 12 6.81 16.5 4.21"/>
                        <polyline points="7.5 19.79 7.5 14.6 3 12"/>
                        <polyline points="21 12 16.5 14.6 16.5 19.79"/>
                        <polyline points="3.27 6.96 12 12.01 20.73 6.96"/>
                        <line x1="12" y1="22.08" x2="12" y2="12"/>
                    </svg>
                    <h4>Results</h4>
                    <span id="sd-result-count" style="font-size:0.75rem;color:var(--text-muted);display:none;"></span>
                </div>
                <div class="tool-result-content" id="sd-result-content">
                    <div class="tool-empty-state" id="sd-empty-state">
                        <svg viewBox="0 0 280 200" style="width:280px;max-width:100%;height:auto;margin-bottom:1rem;" xmlns="http://www.w3.org/2000/svg">
                            <!-- Connecting lines (drawn first, behind nodes) -->
                            <line x1="140" y1="100" x2="60" y2="40" stroke="var(--border,#e2e8f0)" stroke-width="1.5" stroke-dasharray="4,3"><animate attributeName="stroke-dashoffset" from="7" to="0" dur="1.5s" repeatCount="indefinite"/></line>
                            <line x1="140" y1="100" x2="220" y2="40" stroke="var(--border,#e2e8f0)" stroke-width="1.5" stroke-dasharray="4,3"><animate attributeName="stroke-dashoffset" from="7" to="0" dur="1.5s" repeatCount="indefinite"/></line>
                            <line x1="140" y1="100" x2="40" y2="120" stroke="var(--border,#e2e8f0)" stroke-width="1.5" stroke-dasharray="4,3"><animate attributeName="stroke-dashoffset" from="7" to="0" dur="1.8s" repeatCount="indefinite"/></line>
                            <line x1="140" y1="100" x2="240" y2="120" stroke="var(--border,#e2e8f0)" stroke-width="1.5" stroke-dasharray="4,3"><animate attributeName="stroke-dashoffset" from="7" to="0" dur="1.8s" repeatCount="indefinite"/></line>
                            <line x1="140" y1="100" x2="80" y2="170" stroke="var(--border,#e2e8f0)" stroke-width="1.5" stroke-dasharray="4,3"><animate attributeName="stroke-dashoffset" from="7" to="0" dur="2s" repeatCount="indefinite"/></line>
                            <line x1="140" y1="100" x2="200" y2="170" stroke="var(--border,#e2e8f0)" stroke-width="1.5" stroke-dasharray="4,3"><animate attributeName="stroke-dashoffset" from="7" to="0" dur="2s" repeatCount="indefinite"/></line>

                            <!-- Pulse rings on center -->
                            <circle cx="140" cy="100" r="18" fill="none" stroke="var(--tool-primary,#3b82f6)" stroke-width="1" opacity="0"><animate attributeName="r" values="18;40" dur="2.5s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.4;0" dur="2.5s" repeatCount="indefinite"/></circle>
                            <circle cx="140" cy="100" r="18" fill="none" stroke="var(--tool-primary,#3b82f6)" stroke-width="1" opacity="0"><animate attributeName="r" values="18;40" dur="2.5s" begin="1.25s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.4;0" dur="2.5s" begin="1.25s" repeatCount="indefinite"/></circle>

                            <!-- Center node (root domain) -->
                            <circle cx="140" cy="100" r="18" fill="var(--tool-primary,#3b82f6)" opacity="0.9"/>
                            <text x="140" y="104" text-anchor="middle" fill="#fff" font-size="8" font-weight="600" font-family="Inter,sans-serif">.com</text>

                            <!-- Subdomain nodes -->
                            <circle cx="60" cy="40" r="11" fill="var(--bg-secondary,#f8fafc)" stroke="var(--tool-primary,#3b82f6)" stroke-width="1.5"><animate attributeName="r" values="10;12;10" dur="3s" repeatCount="indefinite"/></circle>
                            <text x="60" y="43" text-anchor="middle" fill="var(--tool-primary,#3b82f6)" font-size="6.5" font-weight="600" font-family="monospace">mail</text>

                            <circle cx="220" cy="40" r="11" fill="var(--bg-secondary,#f8fafc)" stroke="var(--tool-primary,#3b82f6)" stroke-width="1.5"><animate attributeName="r" values="10;12;10" dur="3s" begin="0.5s" repeatCount="indefinite"/></circle>
                            <text x="220" y="43" text-anchor="middle" fill="var(--tool-primary,#3b82f6)" font-size="6.5" font-weight="600" font-family="monospace">api</text>

                            <circle cx="40" cy="120" r="11" fill="var(--bg-secondary,#f8fafc)" stroke="var(--tool-primary,#3b82f6)" stroke-width="1.5"><animate attributeName="r" values="10;12;10" dur="3s" begin="1s" repeatCount="indefinite"/></circle>
                            <text x="40" y="123" text-anchor="middle" fill="var(--tool-primary,#3b82f6)" font-size="6.5" font-weight="600" font-family="monospace">dev</text>

                            <circle cx="240" cy="120" r="11" fill="var(--bg-secondary,#f8fafc)" stroke="var(--tool-primary,#3b82f6)" stroke-width="1.5"><animate attributeName="r" values="10;12;10" dur="3s" begin="1.5s" repeatCount="indefinite"/></circle>
                            <text x="240" y="123" text-anchor="middle" fill="var(--tool-primary,#3b82f6)" font-size="6.5" font-weight="600" font-family="monospace">cdn</text>

                            <circle cx="80" cy="170" r="11" fill="var(--bg-secondary,#f8fafc)" stroke="var(--tool-primary,#3b82f6)" stroke-width="1.5"><animate attributeName="r" values="10;12;10" dur="3s" begin="2s" repeatCount="indefinite"/></circle>
                            <text x="80" y="173" text-anchor="middle" fill="var(--tool-primary,#3b82f6)" font-size="6.5" font-weight="600" font-family="monospace">staging</text>

                            <circle cx="200" cy="170" r="11" fill="var(--bg-secondary,#f8fafc)" stroke="var(--tool-primary,#3b82f6)" stroke-width="1.5"><animate attributeName="r" values="10;12;10" dur="3s" begin="2.5s" repeatCount="indefinite"/></circle>
                            <text x="200" y="173" text-anchor="middle" fill="var(--tool-primary,#3b82f6)" font-size="6.5" font-weight="600" font-family="monospace">admin</text>
                        </svg>
                        <h3>Enter a domain and click Find Subdomains</h3>
                        <p>Discovers subdomains using certificate transparency logs, DNS records, and OSINT sources.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="sd-result-actions">
                    <button type="button" class="tool-action-btn" id="sd-copy-btn">&#128203; Copy All</button>
                    <button type="button" class="tool-action-btn" id="sd-download-btn">&#8681; Download CSV</button>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="subdomain.jsp"/>
        <jsp:param name="keyword" value="network"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Educational Content -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a Subdomain Finder?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>subdomain finder</strong> is a tool that discovers all subdomains associated with a root domain. Subdomains are prefixes added to a domain name (e.g., <code style="font-family:var(--font-mono);font-size:0.875em;background:var(--bg-tertiary);padding:0.125rem 0.375rem;border-radius:0.25rem;">mail.example.com</code>, <code style="font-family:var(--font-mono);font-size:0.875em;background:var(--bg-tertiary);padding:0.125rem 0.375rem;border-radius:0.25rem;">api.example.com</code>, <code style="font-family:var(--font-mono);font-size:0.875em;background:var(--bg-tertiary);padding:0.125rem 0.375rem;border-radius:0.25rem;">dev.example.com</code>) that often host separate services, applications, or environments.</p>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Subdomain discovery is a critical first step in <strong>penetration testing</strong>, <strong>bug bounty hunting</strong>, and <strong>attack surface management</strong>. Subdomains frequently expose:</p>
            <div class="sd-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
                <div class="sd-edu-card" style="border-left:3px solid #3b82f6;">
                    <h4>Staging Environments</h4>
                    <p>Development and staging servers often run with weaker security configurations and default credentials.</p>
                </div>
                <div class="sd-edu-card" style="border-left:3px solid #60a5fa;">
                    <h4>Internal APIs</h4>
                    <p>Microservices and internal APIs may lack proper authentication or rate limiting when exposed.</p>
                </div>
                <div class="sd-edu-card" style="border-left:3px solid #2563eb;">
                    <h4>Legacy Applications</h4>
                    <p>Forgotten services running outdated, unpatched software are common attack vectors.</p>
                </div>
                <div class="sd-edu-card" style="border-left:3px solid #1d4ed8;">
                    <h4>Admin Panels</h4>
                    <p>Management interfaces not intended for public access but discoverable via subdomain enumeration.</p>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Find Subdomains of a Domain</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Follow these steps to discover subdomains using this free <strong>subdomain lookup</strong> tool:</p>
            <div style="display:flex;flex-direction:column;gap:0.75rem;">
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">1</span>
                    <div><strong style="color:var(--text-primary);">Enter the root domain</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Type the target domain (e.g., <code style="font-family:var(--font-mono);font-size:0.875em;">example.com</code>) into the search field. Do not include the protocol or any path.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">2</span>
                    <div><strong style="color:var(--text-primary);">Click &ldquo;Find Subdomains&rdquo;</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">The tool queries certificate transparency logs and DNS data sources in parallel to enumerate subdomains.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">3</span>
                    <div><strong style="color:var(--text-primary);">Review discovered subdomains</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Browse results organized by data source. Check the total count and look for staging, admin, API, and internal subdomains.</p></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:28px;height:28px;background:var(--tool-gradient);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">4</span>
                    <div><strong style="color:var(--text-primary);">Export and investigate</strong><p style="color:var(--text-secondary);margin:0.25rem 0 0;font-size:0.875rem;line-height:1.6;">Copy or download results as CSV. Use discovered subdomains with DNS lookup, port scanners, or HTTP probers to identify live services.</p></div>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Subdomain Enumeration Methods</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Effective <strong>subdomain enumeration</strong> combines multiple techniques for maximum coverage:</p>
            <table class="sd-methods-table">
                <thead><tr><th style="width:25%;">Method</th><th style="width:40%;">How It Works</th><th>Strengths</th></tr></thead>
                <tbody>
                    <tr><td style="font-weight:600;">Certificate Transparency</td><td>Queries public CT logs that record every SSL/TLS certificate issued. Subdomain names appear in the SAN field.</td><td>Discovers subdomains with SSL certs, including internal hosts</td></tr>
                    <tr><td style="font-weight:600;">Passive DNS</td><td>Aggregates historical DNS resolution data collected by sensors worldwide.</td><td>Reveals subdomains that existed in the past, even if offline</td></tr>
                    <tr><td style="font-weight:600;">DNS Brute-Force</td><td>Systematically resolves common subdomain names using wordlists against the target domain.</td><td>Finds subdomains without certificates or public references</td></tr>
                    <tr><td style="font-weight:600;">Search Engine Dorking</td><td>Uses <code style="font-family:var(--font-mono);font-size:0.8em;">site:example.com</code> operator to find indexed subdomains from crawlers.</td><td>Discovers web-facing subdomains with actual content</td></tr>
                    <tr><td style="font-weight:600;">Web Archive Crawling</td><td>Searches historical snapshots for referenced subdomain URLs.</td><td>Uncovers decommissioned subdomains that may still resolve</td></tr>
                </tbody>
            </table>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Why Subdomain Discovery Matters for Security</h2>
            <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Subdomain discovery</strong> is one of the most important reconnaissance steps in any security assessment. Organizations often have hundreds of subdomains, many unmonitored:</p>
            <div class="sd-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(240px,1fr));">
                <div class="sd-edu-card" style="border-left:3px solid #ef4444;">
                    <h4>Subdomain Takeover</h4>
                    <p>When a subdomain points to a decommissioned cloud service (S3 bucket, Heroku app), attackers can claim that resource and serve malicious content under your domain.</p>
                </div>
                <div class="sd-edu-card" style="border-left:3px solid #f59e0b;">
                    <h4>Shadow IT Exposure</h4>
                    <p>Departments may create subdomains for internal projects without security review, leaving them vulnerable to exploitation.</p>
                </div>
                <div class="sd-edu-card" style="border-left:3px solid #8b5cf6;">
                    <h4>Credential Leakage</h4>
                    <p>Staging and development environments frequently use weaker passwords or expose debug endpoints with sensitive data.</p>
                </div>
                <div class="sd-edu-card" style="border-left:3px solid #10b981;">
                    <h4>Compliance Gaps</h4>
                    <p>PCI-DSS and SOC 2 require organizations to maintain an inventory of all internet-facing assets, including subdomains.</p>
                </div>
            </div>
        </div>

        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is subdomain enumeration?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Subdomain enumeration is the process of discovering all subdomains associated with a root domain. It uses techniques like certificate transparency log scanning, DNS brute-forcing, and OSINT data collection to reveal hosts such as mail.example.com, dev.example.com, or api.example.com that may not be publicly linked.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do I find all subdomains of a domain?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Enter the root domain (e.g., example.com) into a subdomain finder tool. The tool queries certificate transparency logs, DNS records, and search engine indexes to compile a list of known subdomains. For thorough results, combine multiple sources including CT logs, passive DNS databases, and brute-force wordlists.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is certificate transparency and how does it help find subdomains?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Certificate Transparency (CT) is a public framework that logs all SSL/TLS certificates issued by certificate authorities. Since certificates often include subdomain names in the Subject Alternative Name (SAN) field, querying CT logs reveals subdomains that have valid SSL certificates &mdash; even internal or staging subdomains that aren't publicly linked.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Why is subdomain discovery important for security?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Subdomains often expose forgotten staging environments, unpatched services, internal APIs, and legacy applications. These overlooked assets are common targets for attackers. Subdomain enumeration during penetration testing or bug bounty hunting helps map the full attack surface so vulnerabilities can be identified and remediated before exploitation.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What are the best methods for subdomain enumeration?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The most effective methods include: (1) Certificate transparency log scanning for SSL-covered subdomains, (2) Passive DNS databases that store historical DNS resolutions, (3) DNS brute-force with wordlists to guess common subdomain names, (4) Search engine dorking using site: operator, and (5) Web archive crawling for historically referenced subdomains.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Can subdomain finder tools discover hidden subdomains?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes, subdomain finder tools can reveal subdomains that aren't publicly linked on a website. Certificate transparency logs capture subdomains with SSL certificates, passive DNS records store historical resolutions, and brute-force techniques can guess internal names like dev, staging, or admin. However, subdomains without DNS records, certificates, or public references may remain undiscovered.</div></div>
        </div>
    </section>

    <!-- Cross-links to related network tools -->
    <section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        <div class="tool-card" style="padding:1.5rem 2rem;">
            <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">&#128293; Explore More Network Tools</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
                <a href="<%=request.getContextPath()%>/dns.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(59,130,246,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#3b82f6,#2563eb);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1rem;color:#fff;font-weight:700;">DNS</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">DNS Lookup</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Query A, AAAA, MX, CNAME, NS, TXT, and SOA records for any domain</p></div>
                </a>
                <a href="<%=request.getContextPath()%>/whois.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(59,130,246,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#8b5cf6,#7c3aed);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;">WHOIS</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">WHOIS Lookup</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Domain registration details, nameservers, registrar info, and expiry dates</p></div>
                </a>
                <a href="<%=request.getContextPath()%>/pingfunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(59,130,246,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                    <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#10b981,#059669);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.85rem;color:#fff;font-weight:700;">PING</div>
                    <div><h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Ping &amp; Traceroute</h4><p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Test connectivity, measure latency, and trace network path to any host</p></div>
                </a>
            </div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>
    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a><a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a></div></div></footer>
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script>
    // ========== STATE ==========
    var sdResults = null;

    // ========== DOM REFS ==========
    var domainInput = document.getElementById('sd-domain');
    var findBtn = document.getElementById('sd-find-btn');
    var resultContent = document.getElementById('sd-result-content');
    var emptyState = document.getElementById('sd-empty-state');
    var resultActions = document.getElementById('sd-result-actions');
    var resultCount = document.getElementById('sd-result-count');

    // ========== FIND SUBDOMAINS ==========
    function findSubdomains() {
        var domain = domainInput.value.trim();
        if (!domain) { domainInput.focus(); return; }

        // Strip protocol if user accidentally included it
        domain = domain.replace(/^https?:\/\//i, '').replace(/\/.*$/, '').trim();
        domainInput.value = domain;

        // Show loading
        findBtn.disabled = true;
        findBtn.innerHTML = '<span class="sd-spinner"></span> Scanning\u2026';
        resultActions.classList.remove('visible');
        resultCount.style.display = 'none';
        resultContent.innerHTML = '<div class="sd-loading"><div class="sd-loading-spinner"></div><div class="sd-loading-text">Scanning subdomains for ' + escapeHtml(domain) + '\u2026</div></div>';

        fetch('SubdomainFunctionality?domain=' + encodeURIComponent(domain))
            .then(function(resp) {
                if (!resp.ok) {
                    return resp.json().catch(function() { return {}; }).then(function(body) {
                        var msg = (body && body.error) ? body.error : 'Error fetching subdomains (HTTP ' + resp.status + ')';
                        throw new Error(msg);
                    });
                }
                return resp.json();
            })
            .then(function(data) {
                sdResults = data;
                renderResults(data);
            })
            .catch(function(err) {
                resultContent.innerHTML = '<div class="sd-error"><strong>Error:</strong> ' + escapeHtml(err.message) + '</div>';
            })
            .finally(function() {
                findBtn.disabled = false;
                findBtn.textContent = 'Find Subdomains';
            });
    }

    // ========== RENDER ==========
    function renderResults(data) {
        var html = '';

        // Stats row
        html += '<div class="sd-stats">';
        html += '<div class="sd-stat"><div class="sd-stat-value">' + (data.count || 0) + '</div><div class="sd-stat-label">Subdomains Found</div></div>';
        html += '<div class="sd-stat"><div class="sd-stat-value">' + (data.time_seconds || '0') + 's</div><div class="sd-stat-label">Search Time</div></div>';
        html += '</div>';

        // Sources
        if (data.subdomains && data.subdomains.length > 0) {
            var sources = [];
            for (var i = 0; i < data.subdomains.length; i++) {
                if (data.subdomains[i].source && sources.indexOf(data.subdomains[i].source) === -1) {
                    sources.push(data.subdomains[i].source);
                }
            }
            if (sources.length > 0) {
                html += '<div class="sd-sources">';
                for (var s = 0; s < sources.length; s++) {
                    html += '<span class="sd-source-badge">' + escapeHtml(sources[s]) + '</span>';
                }
                html += '</div>';
            }

            // Subdomain list
            html += '<ul class="sd-list">';
            for (var j = 0; j < data.subdomains.length; j++) {
                var sub = data.subdomains[j];
                html += '<li class="sd-item"><span class="sd-item-host">' + escapeHtml(sub.host) + '</span>';
                if (sub.source) html += '<span class="sd-item-source">' + escapeHtml(sub.source) + '</span>';
                html += '</li>';
            }
            html += '</ul>';

            resultActions.classList.add('visible');
            resultCount.textContent = data.count + ' found';
            resultCount.style.display = 'inline';
        } else {
            html += '<div class="tool-empty-state"><h3>No subdomains found</h3><p>No subdomains were discovered for this domain. Try a different domain.</p></div>';
        }

        resultContent.innerHTML = html;
    }

    // ========== ACTIONS ==========
    function copyAll() {
        if (!sdResults || !sdResults.subdomains) return;
        var text = sdResults.subdomains.map(function(s) { return s.host; }).join('\n');
        if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(text);
            ToolUtils.showToast('Copied ' + sdResults.subdomains.length + ' subdomains!');
        } else {
            navigator.clipboard.writeText(text);
        }
    }

    function downloadCSV() {
        if (!sdResults || !sdResults.subdomains) return;
        var csv = 'subdomain,source\n';
        for (var i = 0; i < sdResults.subdomains.length; i++) {
            csv += '"' + sdResults.subdomains[i].host + '","' + (sdResults.subdomains[i].source || '') + '"\n';
        }
        var blob = new Blob([csv], { type: 'text/csv' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = sdResults.domain + '-subdomains.csv';
        a.click();
        URL.revokeObjectURL(url);
        if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) ToolUtils.showToast('CSV downloaded!');
    }

    // ========== UTILS ==========
    function escapeHtml(str) {
        if (!str) return '';
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function toggleFaq(btn) {
        var item = btn.closest('.faq-item');
        if (item) item.classList.toggle('open');
    }

    // ========== EVENT LISTENERS ==========
    findBtn.addEventListener('click', findSubdomains);

    domainInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); findSubdomains(); }
    });

    document.getElementById('sd-copy-btn').addEventListener('click', copyAll);
    document.getElementById('sd-download-btn').addEventListener('click', downloadCSV);

    // Example chips
    var chips = document.querySelectorAll('.sd-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            domainInput.value = this.getAttribute('data-domain');
            findSubdomains();
        });
    }

    // URL param support
    (function() {
        var params = new URLSearchParams(window.location.search);
        var d = params.get('domain') || params.get('d');
        if (d) { domainInput.value = d; findSubdomains(); }
    })();
    </script>
</body>
</html>
