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
            --tool-primary:#0891b2;--tool-primary-dark:#0e7490;--tool-gradient:linear-gradient(135deg,#0891b2 0%,#06b6d4 100%);--tool-light:#ecfeff
        }
        @media(prefers-color-scheme:dark){
            :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}
        }
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(8,145,178,0.15)}
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

        /* Dark mode (above-fold elements) */
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary,#94a3b8)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary,#cbd5e1)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(8,145,178,0.3)}

        /* Utility */
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="IP Subnet Calculator - Instant CIDR, Visual Map" />
        <jsp:param name="toolDescription" value="Free instant IP subnet calculator with visual subnet map and live CIDR results. Get subnet mask, network/broadcast address, wildcard mask, host range, and IP-in-subnet checker. Includes interactive subnetting practice worksheets for CCNA and Network+ exam prep. Runs entirely in your browser." />
        <jsp:param name="toolCategory" value="Network Tools" />
        <jsp:param name="toolUrl" value="SubnetFunctions.jsp" />
        <jsp:param name="toolKeywords" value="subnet calculator, CIDR calculator, IP subnet calculator, network calculator, subnet mask calculator, IPv4 subnetting, wildcard mask, visual subnet map, IP in subnet checker, subnet planner, network address calculator, broadcast address, host range calculator, CIDR to subnet mask, online subnet tool, subnetting practice, CCNA subnet quiz, subnet practice worksheet, network+ subnetting practice" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Instant live CIDR calculation as you type,Visual subnet address space map,IP-in-subnet membership checker,Network and broadcast address calculation,Subnet mask and wildcard mask,Usable host range with binary view,Private network and class detection,Calculation history with one-click reload,IP address list generation,Works fully offline in browser,Interactive subnetting practice worksheets with difficulty levels,Downloadable practice sheets for CCNA exam prep" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is CIDR notation and how does this calculator use it?" />
        <jsp:param name="faq1a" value="CIDR (Classless Inter-Domain Routing) notation combines an IP address with a prefix length, like 192.168.1.0/24, where /24 means the first 24 bits define the network. This calculator instantly computes subnet mask, network address, broadcast address, usable host range, and wildcard mask from any CIDR input. Results update live as you type or drag the CIDR slider." />
        <jsp:param name="faq2q" value="How do I convert CIDR prefix to subnet mask?" />
        <jsp:param name="faq2a" value="The CIDR prefix indicates how many leading bits are 1 in the subnet mask. For /24, the mask is 11111111.11111111.11111111.00000000 = 255.255.255.0. This calculator shows both dotted-decimal and binary representations instantly. Common conversions: /8 = 255.0.0.0, /16 = 255.255.0.0, /24 = 255.255.255.0, /28 = 255.255.255.240, /30 = 255.255.255.252." />
        <jsp:param name="faq3q" value="What does the Visual Subnet Map show?" />
        <jsp:param name="faq3a" value="The Visual Subnet Map displays the address space as a proportional horizontal bar. It shows three color-coded segments: the network address (teal), usable host addresses (gradient fill), and broadcast address (orange). This helps you visualize how much of the subnet is usable versus reserved. Smaller subnets like /30 show mostly reserved space, while /24 shows mostly usable." />
        <jsp:param name="faq4q" value="How do I check if an IP address belongs to a subnet?" />
        <jsp:param name="faq4a" value="Use the IP-in-Subnet Checker below the results. Type any IP address and it instantly tells you whether that IP falls within the calculated subnet. If the IP is outside the subnet, it shows which subnet the IP would belong to using the same prefix length. The check uses bitwise AND: (IP AND mask) must equal the network address." />
        <jsp:param name="faq5q" value="How many usable hosts are in a subnet?" />
        <jsp:param name="faq5a" value="Usable hosts = 2^(32 - prefix) - 2. The two subtracted addresses are the network address (all host bits 0) and broadcast address (all host bits 1). Examples: /24 = 254 hosts, /28 = 14 hosts, /30 = 2 hosts (point-to-point links). Special cases: /31 has 2 usable addresses (RFC 3021), and /32 is a single host route. This tool works fully offline after the page loads and your calculation history persists in localStorage across sessions." />
        <jsp:param name="faq6q" value="Can I practice subnetting problems with this tool?" />
        <jsp:param name="faq6a" value="Yes. Switch to the Practice Questions tab to generate randomized subnetting problems at Easy, Medium, or Hard difficulty. Easy covers /8, /16, /24 masks. Medium covers /20-/28. Hard includes unusual prefixes and extra fields like wildcard mask. Check your answers instantly, reveal solutions, or download the worksheet as a printable PNG for offline study." />
    </jsp:include>

    <!-- Enhanced HowTo Schema (Subnet-Specific for High CTR) -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Calculate IP Subnet Information from CIDR Notation",
        "description": "Use this free online subnet calculator to instantly compute network details from any IPv4 CIDR address.",
        "totalTime": "PT10S",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter CIDR Address",
                "text": "Type an IP address with CIDR prefix (e.g., 192.168.1.0/24) or drag the CIDR slider. Results calculate instantly as you type.",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Review Subnet Details and Visual Map",
                "text": "View computed network address, broadcast address, subnet mask, wildcard mask, usable host range, binary representation, and the visual address space map showing proportional allocation.",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "Check IP Membership and Export",
                "text": "Use the IP-in-Subnet Checker to verify if any IP belongs to the subnet. Copy results as text, share via URL, or download as JSON. Your calculation is saved to history for quick reload.",
                "position": 3
            },
            {
                "@type": "HowToStep",
                "name": "Practice Subnetting Skills",
                "text": "Switch to the Practice Questions tab, select difficulty, and generate randomized problems. Check answers instantly or download the worksheet as a PNG.",
                "position": 4
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
        :root {
            --tool-primary: #0891b2;
            --tool-primary-dark: #0e7490;
            --tool-gradient: linear-gradient(135deg, #0891b2 0%, #06b6d4 100%);
            --tool-light: #ecfeff;
        }

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
            box-shadow: 0 0 0 3px rgba(8, 145, 178, 0.15);
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
            box-shadow: 0 0 0 3px rgba(8, 145, 178, 0.25);
        }

        /* CIDR slider */
        .cidr-slider {
            width: 100%;
            height: 8px;
            border-radius: 4px;
            background: var(--bg-tertiary, #e9ecef);
            outline: none;
            -webkit-appearance: none;
            margin: 0.5rem 0;
            cursor: pointer;
        }

        .cidr-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: var(--tool-gradient);
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(8, 145, 178, 0.35);
            border: 2px solid #fff;
        }

        .cidr-slider::-moz-range-thumb {
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: var(--tool-gradient);
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(8, 145, 178, 0.35);
            border: 2px solid #fff;
        }

        [data-theme="dark"] .cidr-slider {
            background: var(--bg-tertiary, #334155);
        }

        [data-theme="dark"] .cidr-slider::-webkit-slider-thumb {
            border-color: var(--bg-secondary, #1e293b);
        }

        .slider-scale {
            display: flex;
            justify-content: space-between;
            font-size: 0.6875rem;
            color: var(--text-muted, #94a3b8);
            margin-top: 0.25rem;
        }

        /* Preset chips */
        .preset-chip {
            display: inline-block;
            margin: 3px;
            padding: 5px 10px;
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 9999px;
            cursor: pointer;
            font-size: 0.75rem;
            font-family: var(--font-sans);
            transition: all 0.15s;
            color: var(--text-primary, #0f172a);
        }

        .preset-chip:hover {
            background: var(--tool-light);
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        [data-theme="dark"] .preset-chip {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .preset-chip:hover {
            background: rgba(8,145,178,0.15);
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        /* Checkbox */
        .tool-checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.875rem;
        }

        .tool-checkbox-group input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--tool-primary);
            cursor: pointer;
        }

        .tool-checkbox-group label {
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
            cursor: pointer;
        }

        [data-theme="dark"] .tool-checkbox-group label {
            color: var(--text-secondary, #94a3b8);
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
            flex: 1;
        }

        .tool-result-content {
            flex: 1;
            padding: 1.25rem;
            min-height: 300px;
            overflow-y: auto;
        }

        .tool-result-actions {
            display: none;
            gap: 0.5rem;
            padding: 1rem 1.25rem;
            border-top: 1px solid var(--border, #e2e8f0);
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0 0 0.75rem 0.75rem;
            flex-wrap: wrap;
        }

        .tool-result-actions.visible { display: flex; }

        .tool-result-actions .tool-action-btn {
            flex: 1;
            min-width: 90px;
            margin-top: 0;
        }

        [data-theme="dark"] .tool-result-header {
            background: var(--bg-tertiary, #334155);
            border-bottom-color: var(--border, #475569);
        }

        [data-theme="dark"] .tool-result-header h4 {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .tool-result-actions {
            background: var(--bg-tertiary, #334155);
            border-top-color: var(--border, #475569);
        }

        /* Empty state */
        .tool-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 3rem 1.5rem;
            color: var(--text-muted, #94a3b8);
        }

        .tool-empty-state h3 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-secondary, #475569);
        }

        .tool-empty-state p {
            font-size: 0.875rem;
            max-width: 280px;
        }

        /* Result grid */
        .result-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.625rem;
        }

        @media (max-width: 600px) {
            .result-grid { grid-template-columns: 1fr; }
        }

        .result-item {
            background: var(--bg-secondary, #f8f9fa);
            border-radius: 0.5rem;
            padding: 0.625rem 0.75rem;
        }

        .result-item label {
            font-size: 0.6875rem;
            color: var(--text-muted, #94a3b8);
            margin-bottom: 0.125rem;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            font-weight: 500;
        }

        .result-item .value {
            font-family: var(--font-mono);
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--tool-primary);
            word-break: break-all;
        }

        [data-theme="dark"] .result-item {
            background: rgba(255,255,255,0.05);
        }

        [data-theme="dark"] .result-item label {
            color: var(--text-muted, #64748b);
        }

        [data-theme="dark"] .result-item .value {
            color: #22d3ee;
        }

        /* Binary display */
        .binary-display {
            font-family: var(--font-mono);
            font-size: 0.75rem;
            background: #1e1e1e;
            color: #4ec9b0;
            padding: 0.75rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            line-height: 1.8;
        }

        .binary-display .bin-label {
            color: #808080;
            display: inline-block;
            min-width: 85px;
        }

        .binary-display .network-bits { color: #ce9178; font-weight: 600; }
        .binary-display .host-bits { color: #9cdcfe; }

        /* IP address list */
        .ip-list {
            max-height: 200px;
            overflow-y: auto;
            font-family: var(--font-mono);
            font-size: 0.75rem;
            background: var(--bg-secondary, #f8f9fa);
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: 1px solid var(--border, #e2e8f0);
            line-height: 1.6;
        }

        [data-theme="dark"] .ip-list {
            background: rgba(255,255,255,0.05);
            border-color: var(--border, #334155);
        }

        /* Badges */
        .badge-private {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            background: rgba(16, 185, 129, 0.15);
            color: #059669;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.625rem;
            border-radius: 9999px;
        }

        .badge-public {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            background: rgba(239, 68, 68, 0.15);
            color: #dc2626;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.625rem;
            border-radius: 9999px;
        }

        .badge-class {
            display: inline-flex;
            align-items: center;
            background: var(--bg-tertiary, #f1f5f9);
            color: var(--text-secondary, #475569);
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.625rem;
            border-radius: 9999px;
        }

        [data-theme="dark"] .badge-private {
            background: rgba(16, 185, 129, 0.2);
            color: #6ee7b7;
        }

        [data-theme="dark"] .badge-public {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
        }

        [data-theme="dark"] .badge-class {
            background: rgba(255,255,255,0.1);
            color: var(--text-secondary, #94a3b8);
        }

        /* Terminal block */
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

        /* CIDR reference table */
        .cidr-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.8rem;
        }

        .cidr-table thead th {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.5rem 0.625rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.75rem;
            color: var(--text-secondary, #475569);
            border-bottom: 2px solid var(--border, #e2e8f0);
        }

        .cidr-table tbody td {
            padding: 0.375rem 0.625rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            color: var(--text-primary, #0f172a);
        }

        .cidr-table tbody td:first-child {
            font-family: var(--font-mono);
            font-weight: 600;
            color: var(--tool-primary);
        }

        .cidr-table tbody td:nth-child(2) {
            font-family: var(--font-mono);
            font-size: 0.75rem;
        }

        [data-theme="dark"] .cidr-table thead th {
            background: var(--bg-tertiary, #334155);
            border-bottom-color: var(--border, #475569);
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .cidr-table tbody td {
            border-bottom-color: var(--border, #334155);
            color: var(--text-primary, #f1f5f9);
        }

        /* Error alert */
        .subnet-error {
            background: rgba(239, 68, 68, 0.1);
            border-left: 4px solid var(--error, #ef4444);
            padding: 0.75rem 1rem;
            border-radius: 0 0.375rem 0.375rem 0;
            color: var(--error, #ef4444);
            font-size: 0.875rem;
            font-weight: 500;
        }

        .subnet-warning {
            background: rgba(245, 158, 11, 0.1);
            border-left: 4px solid var(--warning, #f59e0b);
            padding: 0.625rem 0.75rem;
            border-radius: 0 0.375rem 0.375rem 0;
            color: #92400e;
            font-size: 0.8125rem;
        }

        [data-theme="dark"] .subnet-warning {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
        }

        /* Info boxes for educational content */
        .info-box {
            background: var(--tool-light);
            border-left: 4px solid var(--tool-primary);
            padding: 0.75rem 1rem;
            margin: 0.75rem 0;
            border-radius: 0 0.375rem 0.375rem 0;
        }

        .info-box h6 {
            margin: 0 0 0.375rem;
            font-size: 0.875rem;
            color: var(--text-primary, #0f172a);
        }

        .info-box p {
            margin: 0;
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
        }

        [data-theme="dark"] .info-box {
            background: rgba(8,145,178,0.12);
        }

        [data-theme="dark"] .info-box h6 { color: var(--text-primary, #f1f5f9); }
        [data-theme="dark"] .info-box p { color: var(--text-secondary, #cbd5e1); }

        .warning-box {
            background: rgba(245, 158, 11, 0.1);
            border-left: 4px solid var(--warning, #f59e0b);
            padding: 0.75rem 1rem;
            margin: 0.75rem 0;
            border-radius: 0 0.375rem 0.375rem 0;
        }

        .warning-box h6 {
            margin: 0 0 0.375rem;
            font-size: 0.875rem;
            color: var(--text-primary, #0f172a);
        }

        .warning-box p {
            margin: 0;
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
        }

        [data-theme="dark"] .warning-box {
            background: rgba(245, 158, 11, 0.12);
        }

        [data-theme="dark"] .warning-box h6 { color: var(--text-primary, #f1f5f9); }
        [data-theme="dark"] .warning-box p { color: var(--text-secondary, #cbd5e1); }

        /* RFC table in educational section */
        .rfc-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.85rem;
            margin-top: 0.75rem;
        }

        .rfc-table thead th {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.5rem 0.75rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.8rem;
            color: var(--text-secondary, #475569);
            border-bottom: 2px solid var(--border, #e2e8f0);
        }

        .rfc-table tbody td {
            padding: 0.5rem 0.75rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            color: var(--text-primary, #0f172a);
        }

        [data-theme="dark"] .rfc-table thead th {
            background: var(--bg-tertiary, #334155);
            border-bottom-color: var(--border, #475569);
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .rfc-table tbody td {
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
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-primary, #0f172a);
            border: none;
            width: 100%;
            text-align: left;
        }

        .faq-question:hover { background: var(--bg-tertiary, #f1f5f9); }

        .faq-answer {
            display: none;
            padding: 0.75rem 1rem;
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
            line-height: 1.6;
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

        /* === Visual Subnet Map === */
        .subnet-map {
            margin-top: 1.25rem;
            padding: 1rem;
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0.5rem;
            border: 1px solid var(--border, #e2e8f0);
        }

        .subnet-map-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary, #475569);
            text-transform: uppercase;
            letter-spacing: 0.03em;
            margin-bottom: 0.5rem;
        }

        .subnet-map-bar {
            width: 100%;
            height: 28px;
            border-radius: 6px;
            overflow: hidden;
            display: flex;
            position: relative;
            background: var(--bg-tertiary, #e2e8f0);
        }

        .subnet-map-network {
            background: #0d9488;
            min-width: 3px;
            height: 100%;
        }

        .subnet-map-usable {
            background: linear-gradient(90deg, #06b6d4, #0891b2);
            height: 100%;
            flex: 1;
        }

        .subnet-map-broadcast {
            background: #f59e0b;
            min-width: 3px;
            height: 100%;
        }

        .subnet-map-labels {
            display: flex;
            justify-content: space-between;
            font-size: 0.6875rem;
            font-family: var(--font-mono);
            color: var(--text-muted, #94a3b8);
            margin-top: 0.375rem;
        }

        .subnet-map-legend {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
            flex-wrap: wrap;
        }

        .subnet-map-legend-item {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.6875rem;
            color: var(--text-secondary, #475569);
        }

        .subnet-map-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 2px;
            flex-shrink: 0;
        }

        [data-theme="dark"] .subnet-map {
            background: rgba(255,255,255,0.05);
            border-color: var(--border, #334155);
        }

        [data-theme="dark"] .subnet-map-label {
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .subnet-map-legend-item {
            color: var(--text-secondary, #94a3b8);
        }

        /* === IP-in-Subnet Checker === */
        .ip-checker {
            margin-top: 1.25rem;
            padding: 1rem;
            background: var(--bg-secondary, #f8fafc);
            border-radius: 0.5rem;
            border: 1px solid var(--border, #e2e8f0);
        }

        .ip-checker-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary, #475569);
            text-transform: uppercase;
            letter-spacing: 0.03em;
            margin-bottom: 0.5rem;
        }

        .ip-checker-row {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .ip-checker-input {
            flex: 1;
            padding: 0.4rem 0.625rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            font-size: 0.8125rem;
            font-family: var(--font-mono);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
        }

        .ip-checker-input:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 2px rgba(8, 145, 178, 0.15);
        }

        .ip-checker-result {
            margin-top: 0.5rem;
            font-size: 0.8125rem;
            font-weight: 500;
            min-height: 1.25rem;
        }

        .ip-checker-result.in-range {
            color: #059669;
        }

        .ip-checker-result.out-range {
            color: #dc2626;
        }

        [data-theme="dark"] .ip-checker {
            background: rgba(255,255,255,0.05);
            border-color: var(--border, #334155);
        }

        [data-theme="dark"] .ip-checker-label {
            color: var(--text-secondary, #94a3b8);
        }

        [data-theme="dark"] .ip-checker-input {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.15);
            color: var(--text-primary, #e2e8f0);
        }

        [data-theme="dark"] .ip-checker-result.in-range { color: #6ee7b7; }
        [data-theme="dark"] .ip-checker-result.out-range { color: #fca5a5; }

        /* === Tab Navigation === */
        .subnet-tabs { display:flex; gap:0; border-bottom:2px solid var(--border); margin-bottom:0; }
        .subnet-tab { flex:1; padding:0.75rem 1rem; font-size:0.875rem; font-weight:600;
            background:none; border:none; border-bottom:3px solid transparent;
            color:var(--text-secondary); cursor:pointer; transition:all 0.15s; font-family:var(--font-sans); }
        .subnet-tab:hover { color:var(--text-primary); background:var(--bg-secondary); }
        .subnet-tab.active { color:var(--tool-primary); border-bottom-color:var(--tool-primary); }
        [data-theme="dark"] .subnet-tab:hover { background:rgba(255,255,255,0.05); }
        .subnet-tab-panel { display:none; }
        .subnet-tab-panel.active { display:block; }

        /* === Calculation History === */
        .calc-history {
            margin-top: 0.75rem;
        }

        .calc-history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.625rem 0.75rem;
            background: var(--bg-secondary, #f8fafc);
            border-bottom: 1px solid var(--border, #e2e8f0);
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
        }

        .calc-history-clear {
            background: none;
            border: none;
            font-size: 0.6875rem;
            color: var(--text-muted, #94a3b8);
            cursor: pointer;
            padding: 0.125rem 0.375rem;
            border-radius: 0.25rem;
        }

        .calc-history-clear:hover {
            color: var(--error, #ef4444);
            background: rgba(239, 68, 68, 0.1);
        }

        .calc-history-list {
            list-style: none;
            margin: 0;
            padding: 0;
            max-height: 240px;
            overflow-y: auto;
        }

        .calc-history-item {
            padding: 0.5rem 0.75rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            cursor: pointer;
            transition: background 0.1s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .calc-history-item:hover {
            background: var(--tool-light);
        }

        .calc-history-item:last-child {
            border-bottom: none;
        }

        .calc-history-subnet {
            font-family: var(--font-mono);
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--tool-primary);
        }

        .calc-history-meta {
            font-size: 0.6875rem;
            color: var(--text-muted, #94a3b8);
        }

        .calc-history-empty {
            padding: 1rem 0.75rem;
            text-align: center;
            font-size: 0.8125rem;
            color: var(--text-muted, #94a3b8);
        }

        [data-theme="dark"] .calc-history-header {
            background: var(--bg-tertiary, #334155);
            border-bottom-color: var(--border, #475569);
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .calc-history-item {
            border-bottom-color: var(--border, #334155);
        }

        [data-theme="dark"] .calc-history-item:hover {
            background: rgba(8,145,178,0.1);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .tool-result-actions {
                flex-direction: column;
            }
            .tool-result-actions .tool-action-btn {
                width: 100%;
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
                <h1 class="tool-page-title">IP Subnet Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#network">Network Tools</a> /
                    IP Subnet Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">IPv4</span>
                <span class="tool-badge">CIDR</span>
                <span class="tool-badge">Instant Results</span>
                <span class="tool-badge">Visual Map</span>
                <span class="tool-badge">Offline</span>
            </div>
        </div>
    </header>

    <!-- Tool Description -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Instantly calculate subnet mask, network address, broadcast address, wildcard mask, and usable host range from CIDR notation. Features a visual subnet map, IP-in-subnet checker, and calculation history. All math runs client-side &mdash; works offline, no data leaves your browser.</p>
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
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <line x1="8" y1="21" x2="16" y2="21"/>
                        <line x1="12" y1="17" x2="12" y2="21"/>
                    </svg>
                    Calculate Subnet
                </div>
                <div class="tool-card-body">
                    <form id="subnetForm" onsubmit="return false;">
                        <!-- Subnet Input -->
                        <div class="tool-form-group">
                            <label class="tool-label" for="subnet">IP Address / CIDR</label>
                            <input type="text" id="subnet" name="subnet" class="tool-input" value="192.168.1.0/24" placeholder="e.g., 192.168.1.0/24" autocomplete="off">
                            <p class="tool-hint">Enter IP with CIDR prefix (e.g., 10.0.0.0/8) &mdash; results update live</p>
                        </div>

                        <!-- CIDR Slider -->
                        <div class="tool-form-group">
                            <label class="tool-label">CIDR Prefix: /<span id="cidrValue">24</span></label>
                            <input type="range" class="cidr-slider" id="cidrSlider" min="0" max="32" value="24">
                            <div class="slider-scale">
                                <span>/8</span>
                                <span>/16</span>
                                <span>/24</span>
                                <span>/30</span>
                            </div>
                        </div>

                        <!-- Preset Chips -->
                        <div class="tool-form-group">
                            <label class="tool-label">Common Subnets</label>
                            <div id="presetChips">
                                <span class="preset-chip" data-preset="10.0.0.0/8">Class A Private</span>
                                <span class="preset-chip" data-preset="172.16.0.0/12">Class B Private</span>
                                <span class="preset-chip" data-preset="192.168.1.0/24">Class C Private</span>
                                <span class="preset-chip" data-preset="192.168.1.0/28">/28 (16 IPs)</span>
                                <span class="preset-chip" data-preset="10.0.0.0/30">Point-to-Point</span>
                            </div>
                        </div>

                        <!-- Include IP List -->
                        <div class="tool-checkbox-group">
                            <input type="checkbox" id="includeAddresses">
                            <label for="includeAddresses">Include IP address list (for small subnets)</label>
                        </div>

                        <button type="button" class="tool-action-btn" id="calculateBtn">
                            Calculate Subnet
                        </button>
                    </form>
                </div>
            </div>

            <!-- CIDR Quick Reference -->
            <div class="tool-card" style="margin-top: 0.75rem;">
                <div class="tool-card-header" style="background: var(--bg-secondary, #f8fafc); color: var(--text-primary, #0f172a); font-size: 0.8125rem; border-bottom: 1px solid var(--border);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;">
                        <rect x="3" y="3" width="18" height="18" rx="2"/>
                        <line x1="3" y1="9" x2="21" y2="9"/>
                        <line x1="9" y1="21" x2="9" y2="9"/>
                    </svg>
                    CIDR Quick Reference
                </div>
                <div style="padding: 0;">
                    <table class="cidr-table">
                        <thead>
                            <tr><th>CIDR</th><th>Subnet Mask</th><th>Hosts</th></tr>
                        </thead>
                        <tbody>
                            <tr><td>/8</td><td>255.0.0.0</td><td>16,777,214</td></tr>
                            <tr><td>/16</td><td>255.255.0.0</td><td>65,534</td></tr>
                            <tr><td>/24</td><td>255.255.255.0</td><td>254</td></tr>
                            <tr><td>/25</td><td>255.255.255.128</td><td>126</td></tr>
                            <tr><td>/26</td><td>255.255.255.192</td><td>62</td></tr>
                            <tr><td>/27</td><td>255.255.255.224</td><td>30</td></tr>
                            <tr><td>/28</td><td>255.255.255.240</td><td>14</td></tr>
                            <tr><td>/29</td><td>255.255.255.248</td><td>6</td></tr>
                            <tr><td>/30</td><td>255.255.255.252</td><td>2</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Calculation History -->
            <div class="tool-card calc-history" id="historyCard">
                <div class="calc-history-header">
                    <span>Recent Calculations</span>
                    <button class="calc-history-clear" id="clearHistoryBtn">Clear</button>
                </div>
                <ul class="calc-history-list" id="historyList">
                    <li class="calc-history-empty">No calculations yet</li>
                </ul>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <!-- Tab Navigation -->
            <div class="subnet-tabs">
                <button class="subnet-tab active" data-tab="calculator">Calculator</button>
                <button class="subnet-tab" data-tab="practice">Practice Questions</button>
            </div>

            <!-- Tab Panel: Calculator (active by default) -->
            <div class="subnet-tab-panel active" id="tab-calculator">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="16" x2="12" y2="12"/>
                            <line x1="12" y1="8" x2="12.01" y2="8"/>
                        </svg>
                        <h4>Subnet Information</h4>
                    </div>
                    <div class="tool-result-content" id="displaySection">
                        <div class="tool-empty-state" id="emptyState">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;margin-bottom:0.75rem;opacity:0.4;">
                                <rect x="2" y="3" width="20" height="14" rx="2"/>
                                <line x1="8" y1="21" x2="16" y2="21"/>
                                <line x1="12" y1="17" x2="12" y2="21"/>
                                <circle cx="7" cy="10" r="1"/>
                                <circle cx="12" cy="10" r="1"/>
                                <circle cx="17" cy="10" r="1"/>
                            </svg>
                            <h3>IP Subnet Calculator</h3>
                            <p>Enter a CIDR address to see subnet information. Results update live as you type.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn" id="copyBtn">
                            <span>&#128203;</span> Copy Text
                        </button>
                        <button type="button" class="tool-action-btn" id="shareBtn">
                            <span>&#128279;</span> Share URL
                        </button>
                        <button type="button" class="tool-action-btn" id="downloadBtn">
                            <span>&#128229;</span> Download JSON
                        </button>
                    </div>
                </div>
            </div>

            <!-- Tab Panel: Practice -->
            <div class="subnet-tab-panel" id="tab-practice">
                <div id="practiceSection"></div>
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

    <!-- Related Network Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="SubnetFunctions.jsp"/>
        <jsp:param name="keyword" value="network"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
    <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

        <!-- CLI Commands -->
        <div class="tool-card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.125rem; margin-bottom: 1rem; color: var(--text-primary);">CLI Commands for Subnet Calculation</h2>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Linux: Calculate subnet with ipcalc</span>
                    <button class="copy-cmd-btn" onclick="copyCommand('ipcalc 192.168.1.0/24')">Copy</button>
                </div>
                <div class="terminal-body">$ ipcalc <code>192.168.1.0/24</code></div>
            </div>
            <div class="terminal-block">
                <div class="terminal-header">
                    <span>Windows: Show IP configuration</span>
                    <button class="copy-cmd-btn" onclick="copyCommand('ipconfig /all')">Copy</button>
                </div>
                <div class="terminal-body">C:\&gt; ipconfig <code>/all</code></div>
            </div>
        </div>

        <!-- Understanding IP Subnetting -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Understanding IP Subnetting</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;"><strong>Subnetting</strong> is the practice of dividing a network into smaller, more manageable sub-networks (subnets). This improves network performance, security, and simplifies administration. Each subnet has its own network address, broadcast address, and range of usable host addresses.</p>
            <p style="color: var(--text-secondary); margin-bottom: 0;">Subnetting is essential for efficient IP address allocation, reducing broadcast domains, and implementing network security policies. Whether you are designing a corporate network or configuring a home lab, understanding subnets is a fundamental networking skill.</p>
        </div>

        <!-- CIDR Notation Explained -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">CIDR Notation Explained</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">CIDR (Classless Inter-Domain Routing) notation combines an IP address with its subnet mask in a compact format: <code style="background:var(--bg-tertiary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-family:var(--font-mono);font-size:0.85rem;">192.168.1.0/24</code>. The number after the slash indicates how many bits are used for the network portion (prefix length).</p>
            <p style="color: var(--text-secondary); margin-bottom: 0;">CIDR replaced the older classful addressing system (Class A, B, C) and allows for much more flexible allocation of IP addresses. Instead of being limited to /8, /16, or /24 boundaries, networks can be divided at any bit boundary from /0 to /32.</p>
        </div>

        <!-- Network vs Broadcast Address -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Network vs Broadcast Address</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem;">
                <div class="info-box">
                    <h6>Network Address</h6>
                    <p>The first address in a subnet, where all host bits are 0. It identifies the network itself and cannot be assigned to a host. For 192.168.1.0/24, the network address is 192.168.1.0.</p>
                </div>
                <div class="warning-box">
                    <h6>Broadcast Address</h6>
                    <p>The last address in a subnet, where all host bits are 1. Packets sent here reach all hosts on the subnet. For 192.168.1.0/24, the broadcast address is 192.168.1.255.</p>
                </div>
            </div>
        </div>

        <!-- RFC 1918 Private Ranges -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">RFC 1918 Private Address Ranges</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem;">RFC 1918 defines three private IP address ranges that are not routed on the public internet. These are used for internal networks and require NAT to access the internet.</p>
            <div style="overflow-x: auto;">
                <table class="rfc-table">
                    <thead>
                        <tr><th>Range</th><th>CIDR</th><th>Addresses</th><th>Typical Use</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>10.0.0.0 &ndash; 10.255.255.255</td><td style="font-family:var(--font-mono);">10.0.0.0/8</td><td>16,777,216</td><td>Large enterprises, data centers</td></tr>
                        <tr><td>172.16.0.0 &ndash; 172.31.255.255</td><td style="font-family:var(--font-mono);">172.16.0.0/12</td><td>1,048,576</td><td>Medium organizations</td></tr>
                        <tr><td>192.168.0.0 &ndash; 192.168.255.255</td><td style="font-family:var(--font-mono);">192.168.0.0/16</td><td>65,536</td><td>Home networks, small offices</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Subnet Calculation Formula -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Subnet Calculation Formula</h2>
            <div style="background: var(--bg-secondary); padding: 1.25rem; border-radius: 0.5rem;">
                <ul style="margin: 0; padding-left: 1.25rem; color: var(--text-secondary); line-height: 2;">
                    <li><strong>Host bits:</strong> 32 &minus; prefix length</li>
                    <li><strong>Total addresses:</strong> 2<sup>(host bits)</sup></li>
                    <li><strong>Usable hosts:</strong> 2<sup>(host bits)</sup> &minus; 2</li>
                    <li><strong>Number of subnets:</strong> 2<sup>(borrowed bits)</sup></li>
                    <li><strong>Wildcard mask:</strong> 255.255.255.255 &minus; subnet mask</li>
                </ul>
            </div>
        </div>

        <!-- FAQ Section -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is CIDR notation and how does this calculator use it?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">CIDR (Classless Inter-Domain Routing) notation combines an IP address with a prefix length, like 192.168.1.0/24, where /24 means the first 24 bits define the network. This calculator instantly computes subnet mask, network address, broadcast address, usable host range, and wildcard mask from any CIDR input. Results update live as you type or drag the CIDR slider.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I convert CIDR prefix to subnet mask?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The CIDR prefix indicates how many leading bits are 1 in the subnet mask. For /24, the mask is 11111111.11111111.11111111.00000000 = 255.255.255.0. This calculator shows both dotted-decimal and binary representations instantly. Common conversions: /8 = 255.0.0.0, /16 = 255.255.0.0, /24 = 255.255.255.0, /28 = 255.255.255.240, /30 = 255.255.255.252.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What does the Visual Subnet Map show?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The Visual Subnet Map displays the address space as a proportional horizontal bar. It shows three color-coded segments: the network address (teal), usable host addresses (gradient fill), and broadcast address (orange). This helps you visualize how much of the subnet is usable versus reserved. Smaller subnets like /30 show mostly reserved space, while /24 shows mostly usable.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How do I check if an IP address belongs to a subnet?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Use the IP-in-Subnet Checker below the results. Type any IP address and it instantly tells you whether that IP falls within the calculated subnet. If the IP is outside the subnet, it shows which subnet the IP would belong to using the same prefix length. The check uses bitwise AND: (IP AND mask) must equal the network address.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    How many usable hosts are in a subnet?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Usable hosts = 2^(32 - prefix) - 2. The two subtracted addresses are the network address (all host bits 0) and broadcast address (all host bits 1). Examples: /24 = 254 hosts, /28 = 14 hosts, /30 = 2 hosts (point-to-point links). Special cases: /31 has 2 usable addresses (RFC 3021), and /32 is a single host route. This tool works fully offline after the page loads and your calculation history persists in localStorage across sessions.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Can I practice subnetting problems with this tool?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes. Switch to the Practice Questions tab to generate randomized subnetting problems at Easy, Medium, or Hard difficulty. Easy covers /8, /16, /24 masks. Medium covers /20-/28. Hard includes unusual prefixes and extra fields like wildcard mask. Check your answers instantly, reveal solutions, or download the worksheet as a printable PNG for offline study.</div>
            </div>
        </div>

        <!-- About This Tool -->
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">About This Tool</h2>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem;">This IP Subnet Calculator is maintained by <strong>Anish Nath</strong>, a software engineer with expertise in networking and security tools. The calculator uses standard IPv4 bit-math subnetting algorithms to compute accurate network information from CIDR notation.</p>
            <p style="color: var(--text-secondary); margin-bottom: 0.75rem;">All calculations run 100% client-side in your browser for instant results. Features include a <strong>Visual Subnet Map</strong> that shows address space proportionally, an <strong>IP-in-Subnet Checker</strong> for verifying IP membership, and <strong>Calculation History</strong> saved locally for quick access to previous lookups. The tool supports the full range of CIDR prefixes (/0 through /32) and correctly identifies RFC 1918 private address ranges and network classes.</p>
            <p style="color: var(--text-secondary); margin-bottom: 0;">Your input data never leaves your browser. No data is sent to any server. This tool works fully offline, making it ideal for network engineers, system administrators, and students studying for CCNA or CompTIA Network+ certifications.</p>
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
    <script src="<%=request.getContextPath()%>/modern/js/practice-sheet.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
    (function() {
    'use strict';

    var TOOL_NAME = 'IP Subnet Calculator';
    var HISTORY_KEY = 'subnet_calc_history';
    var MAX_HISTORY = 10;
    var lastResult = null;
    var debounceTimer = null;

    // ========== Pure Client-Side Subnet Math ==========

    function parseIp(str) {
        str = str.trim();
        var parts = str.split('.');
        if (parts.length !== 4) return -1;
        var val = 0;
        for (var i = 0; i < 4; i++) {
            var n = parseInt(parts[i], 10);
            if (isNaN(n) || n < 0 || n > 255 || parts[i] !== String(n)) return -1;
            val = (val * 256) + n;
        }
        return val;
    }

    function ipToString(num) {
        return [
            (num >>> 24) & 255,
            (num >>> 16) & 255,
            (num >>> 8) & 255,
            num & 255
        ].join('.');
    }

    function ipToBinary(num) {
        var s = '';
        for (var i = 31; i >= 0; i--) {
            s += (num >>> i) & 1;
            if (i > 0 && i % 8 === 0) s += '.';
        }
        return s;
    }

    function getNetworkClass(firstOctet) {
        if (firstOctet < 128) return 'A';
        if (firstOctet < 192) return 'B';
        if (firstOctet < 224) return 'C';
        if (firstOctet < 240) return 'D';
        return 'E';
    }

    function isPrivateIp(ip) {
        var a = (ip >>> 24) & 255;
        var b = (ip >>> 16) & 255;
        if (a === 10) return true;
        if (a === 172 && b >= 16 && b <= 31) return true;
        if (a === 192 && b === 168) return true;
        return false;
    }

    function calculateSubnetInfo(ipStr, prefix) {
        var ip = parseIp(ipStr);
        if (ip < 0) return null;
        if (prefix < 0 || prefix > 32) return null;

        // Mask: prefix 1-bits then 0-bits (use unsigned right shift)
        var mask = prefix === 0 ? 0 : ((0xFFFFFFFF << (32 - prefix)) >>> 0);
        var wildcard = (~mask) >>> 0;
        var network = (ip & mask) >>> 0;
        var broadcast = (network | wildcard) >>> 0;

        var hostBits = 32 - prefix;
        var totalAddresses = Math.pow(2, hostBits);
        var usableHosts = totalAddresses > 2 ? totalAddresses - 2 : 0;

        var firstUsable, lastUsable;
        if (prefix === 32) {
            firstUsable = network;
            lastUsable = network;
            usableHosts = 1;
        } else if (prefix === 31) {
            firstUsable = network;
            lastUsable = broadcast;
            usableHosts = 2;
        } else {
            firstUsable = (network + 1) >>> 0;
            lastUsable = (broadcast - 1) >>> 0;
        }

        var firstOctet = (network >>> 24) & 255;

        return {
            input: ipStr + '/' + prefix,
            networkAddress: ipToString(network),
            broadcastAddress: ipToString(broadcast),
            subnetMask: ipToString(mask),
            wildcardMask: ipToString(wildcard),
            lowAddress: ipToString(firstUsable),
            highAddress: ipToString(lastUsable),
            totalAddresses: totalAddresses,
            usableHosts: usableHosts,
            prefixLength: prefix,
            hostBits: hostBits,
            cidrNotation: ipToString(network) + '/' + prefix,
            networkClass: getNetworkClass(firstOctet),
            isPrivate: isPrivateIp(network),
            networkInt: network,
            broadcastInt: broadcast,
            maskInt: mask,
            binary: {
                networkAddress: ipToBinary(network),
                subnetMask: ipToBinary(mask),
                broadcastAddress: ipToBinary(broadcast)
            }
        };
    }

    function generateAddressList(networkInt, broadcastInt, cap) {
        var count = (broadcastInt - networkInt) + 1;
        if (count > cap) return null;
        var list = [];
        for (var i = networkInt; i <= broadcastInt; i++) {
            list.push(ipToString(i >>> 0));
        }
        return list;
    }

    // ========== Parse CIDR input ==========

    function parseSubnetInput(raw) {
        raw = raw.trim();
        var slashIdx = raw.indexOf('/');
        if (slashIdx === -1) return null;
        var ipPart = raw.substring(0, slashIdx);
        var prefixPart = raw.substring(slashIdx + 1);
        var prefix = parseInt(prefixPart, 10);
        if (isNaN(prefix) || prefix < 0 || prefix > 32) return null;
        if (parseIp(ipPart) < 0) return null;
        return { ip: ipPart, prefix: prefix };
    }

    // ========== Main Calculate ==========

    function calculateSubnet() {
        var subnetInput = document.getElementById('subnet').value.trim();
        if (!subnetInput) return;

        var parsed = parseSubnetInput(subnetInput);
        if (!parsed) {
            showError('Invalid CIDR notation. Use format: 192.168.1.0/24');
            return;
        }

        var result = calculateSubnetInfo(parsed.ip, parsed.prefix);
        if (!result) {
            showError('Could not calculate subnet. Check your IP address.');
            return;
        }

        // Build full result object matching old format for copy/download
        var includeList = document.getElementById('includeAddresses').checked;
        var addresses = null;
        var addressListTruncated = false;
        var addressListError = null;

        if (includeList) {
            if (result.totalAddresses <= 1024) {
                addresses = generateAddressList(result.networkInt, result.broadcastInt, 1024);
            } else {
                addressListError = 'Address list too large (' + result.totalAddresses.toLocaleString() + ' addresses). Only generated for subnets with up to 1,024 addresses.';
            }
        }

        lastResult = {
            input: result.input,
            success: true,
            network: result,
            addresses: addresses,
            addressListTruncated: addressListTruncated,
            addressListError: addressListError,
            totalAddresses: result.totalAddresses
        };

        renderResults(lastResult);
        addToHistory(result);
    }

    // ========== Render Results ==========

    function renderResults(data) {
        var net = data.network;
        var html = '';

        // Network type badges
        html += '<div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-bottom:1rem;">';
        if (net.isPrivate) {
            html += '<span class="badge-private">&#128274; Private Network</span>';
        } else {
            html += '<span class="badge-public">&#127760; Public Network</span>';
        }
        html += '<span class="badge-class">Class ' + escapeHtml(net.networkClass) + '</span>';
        html += '</div>';

        // Main results grid
        html += '<div class="result-grid">';
        html += resultItem('Network Address', net.networkAddress);
        html += resultItem('Broadcast Address', net.broadcastAddress);
        html += resultItem('Subnet Mask', net.subnetMask);
        html += resultItem('Wildcard Mask', net.wildcardMask);
        html += resultItem('First Usable IP', net.lowAddress);
        html += resultItem('Last Usable IP', net.highAddress);
        html += resultItem('Total Addresses', net.totalAddresses.toLocaleString());
        html += resultItem('Usable Hosts', net.usableHosts.toLocaleString());
        html += resultItem('CIDR Notation', net.cidrNotation);
        html += resultItem('Prefix / Host Bits', '/' + net.prefixLength + ' (' + net.hostBits + ' host bits)');
        html += '</div>';

        // Binary representation
        html += '<div style="margin-top:1rem;">';
        html += '<label class="tool-label" style="margin-bottom:0.5rem;">Binary Representation</label>';
        html += '<div class="binary-display">';
        html += '<div><span class="bin-label">Network:  </span>' + formatBinary(net.binary.networkAddress, net.prefixLength) + '</div>';
        html += '<div><span class="bin-label">Mask:     </span>' + net.binary.subnetMask + '</div>';
        html += '<div><span class="bin-label">Broadcast:</span>' + formatBinary(net.binary.broadcastAddress, net.prefixLength) + '</div>';
        html += '</div></div>';

        // Visual Subnet Map
        html += renderSubnetMap(net);

        // IP-in-Subnet Checker
        html += renderIpChecker(net);

        // IP address list
        if (data.addresses && data.addresses.length > 0) {
            html += '<div style="margin-top:1rem;">';
            html += '<label class="tool-label" style="margin-bottom:0.5rem;">IP Addresses (' + data.addresses.length;
            if (data.addressListTruncated) html += ' of ' + data.totalAddresses + ' &mdash; truncated';
            html += ')</label>';
            html += '<div class="ip-list">' + data.addresses.map(escapeHtml).join('<br>') + '</div>';
            html += '</div>';
        } else if (data.addressListError) {
            html += '<div class="subnet-warning" style="margin-top:1rem;">&#9888;&#65039; ' + escapeHtml(data.addressListError) + '</div>';
        }

        document.getElementById('displaySection').innerHTML = html;
        document.getElementById('resultActions').classList.add('visible');

        // Bind IP checker after DOM update
        var checkerInput = document.getElementById('ipCheckerInput');
        if (checkerInput) {
            checkerInput.addEventListener('input', function() {
                checkIpInSubnet(net);
            });
        }
    }

    // ========== Visual Subnet Map ==========

    function renderSubnetMap(net) {
        var total = net.totalAddresses;
        if (total <= 0) return '';

        var usable = net.usableHosts;
        var reserved = total - usable;
        var usablePct = total > 0 ? ((usable / total) * 100) : 0;
        var reservedPct = 100 - usablePct;

        // For /31 and /32, special layout
        var networkWidth, usableWidth, broadcastWidth;
        if (net.prefixLength === 32) {
            networkWidth = '100%';
            usableWidth = '0%';
            broadcastWidth = '0%';
        } else if (net.prefixLength === 31) {
            networkWidth = '50%';
            usableWidth = '0%';
            broadcastWidth = '50%';
        } else {
            // Minimum 3px for network and broadcast
            var minPx = 3;
            networkWidth = 'minmax(3px, ' + (1 / total * 100).toFixed(4) + '%)';
            broadcastWidth = networkWidth;
            // Use flex layout: network and broadcast get min-width, usable gets flex:1
            networkWidth = null; // handled via min-width
            usableWidth = null;
            broadcastWidth = null;
        }

        var html = '<div class="subnet-map">';
        html += '<div class="subnet-map-label">Address Space Map</div>';
        html += '<div class="subnet-map-bar">';
        html += '<div class="subnet-map-network" style="flex:0 0 auto;min-width:3px;width:' + Math.max(1 / total * 100, 0.5).toFixed(2) + '%" title="Network: ' + escapeHtml(net.networkAddress) + '"></div>';
        if (usable > 0) {
            html += '<div class="subnet-map-usable" title="Usable hosts: ' + usable.toLocaleString() + ' (' + usablePct.toFixed(1) + '%)"></div>';
        }
        if (net.prefixLength < 32) {
            html += '<div class="subnet-map-broadcast" style="flex:0 0 auto;min-width:3px;width:' + Math.max(1 / total * 100, 0.5).toFixed(2) + '%" title="Broadcast: ' + escapeHtml(net.broadcastAddress) + '"></div>';
        }
        html += '</div>';

        html += '<div class="subnet-map-labels">';
        html += '<span>' + escapeHtml(net.networkAddress) + '</span>';
        html += '<span>' + escapeHtml(net.broadcastAddress) + '</span>';
        html += '</div>';

        html += '<div class="subnet-map-legend">';
        html += '<span class="subnet-map-legend-item"><span class="subnet-map-legend-dot" style="background:#0d9488;"></span>Network</span>';
        if (usable > 0) {
            html += '<span class="subnet-map-legend-item"><span class="subnet-map-legend-dot" style="background:#0891b2;"></span>Usable: ' + usable.toLocaleString() + ' (' + usablePct.toFixed(1) + '%)</span>';
        }
        if (net.prefixLength < 32) {
            html += '<span class="subnet-map-legend-item"><span class="subnet-map-legend-dot" style="background:#f59e0b;"></span>Broadcast</span>';
        }
        html += '</div>';
        html += '</div>';
        return html;
    }

    // ========== IP-in-Subnet Checker ==========

    function renderIpChecker(net) {
        var html = '<div class="ip-checker">';
        html += '<div class="ip-checker-label">Check if IP belongs to this subnet</div>';
        html += '<div class="ip-checker-row">';
        html += '<input type="text" class="ip-checker-input" id="ipCheckerInput" placeholder="e.g., ' + escapeHtml(net.lowAddress) + '" autocomplete="off">';
        html += '</div>';
        html += '<div class="ip-checker-result" id="ipCheckerResult"></div>';
        html += '</div>';
        return html;
    }

    function checkIpInSubnet(net) {
        var resultEl = document.getElementById('ipCheckerResult');
        var input = document.getElementById('ipCheckerInput').value.trim();
        if (!input) {
            resultEl.textContent = '';
            resultEl.className = 'ip-checker-result';
            return;
        }

        var ip = parseIp(input);
        if (ip < 0) {
            resultEl.innerHTML = '&#10060; Invalid IP address';
            resultEl.className = 'ip-checker-result out-range';
            return;
        }

        var ipMasked = (ip & net.maskInt) >>> 0;
        if (ipMasked === net.networkInt) {
            resultEl.innerHTML = '&#9989; Yes, ' + escapeHtml(input) + ' is in ' + escapeHtml(net.cidrNotation);
            resultEl.className = 'ip-checker-result in-range';
        } else {
            var actualNetwork = ipToString(ipMasked);
            resultEl.innerHTML = '&#10060; No, not in this subnet. It belongs to ' + escapeHtml(actualNetwork) + '/' + net.prefixLength;
            resultEl.className = 'ip-checker-result out-range';
        }
    }

    // ========== Calculation History ==========

    function getHistory() {
        try {
            var data = localStorage.getItem(HISTORY_KEY);
            return data ? JSON.parse(data) : [];
        } catch (e) {
            return [];
        }
    }

    function saveHistory(history) {
        try {
            localStorage.setItem(HISTORY_KEY, JSON.stringify(history));
        } catch (e) { /* quota exceeded - silently fail */ }
    }

    function addToHistory(net) {
        var history = getHistory();
        // Avoid duplicating the most recent entry
        if (history.length > 0 && history[0].input === net.input) {
            history[0].timestamp = Date.now();
            saveHistory(history);
            renderHistory();
            return;
        }
        history.unshift({
            input: net.input,
            network: net.networkAddress,
            usableHosts: net.usableHosts,
            timestamp: Date.now()
        });
        if (history.length > MAX_HISTORY) history = history.slice(0, MAX_HISTORY);
        saveHistory(history);
        renderHistory();
    }

    function renderHistory() {
        var history = getHistory();
        var listEl = document.getElementById('historyList');
        if (!history.length) {
            listEl.innerHTML = '<li class="calc-history-empty">No calculations yet</li>';
            return;
        }
        var html = '';
        for (var i = 0; i < history.length; i++) {
            var item = history[i];
            var ago = timeAgo(item.timestamp);
            html += '<li class="calc-history-item" data-input="' + escapeHtml(item.input) + '">';
            html += '<div><span class="calc-history-subnet">' + escapeHtml(item.input) + '</span>';
            html += '<div class="calc-history-meta">' + escapeHtml(item.network) + ' &middot; ' + item.usableHosts.toLocaleString() + ' hosts</div></div>';
            html += '<span class="calc-history-meta">' + escapeHtml(ago) + '</span>';
            html += '</li>';
        }
        listEl.innerHTML = html;

        // Bind click events
        var items = listEl.querySelectorAll('.calc-history-item');
        for (var j = 0; j < items.length; j++) {
            items[j].addEventListener('click', function() {
                var cidr = this.getAttribute('data-input');
                document.getElementById('subnet').value = cidr;
                var prefix = parseInt(cidr.split('/')[1], 10);
                if (!isNaN(prefix)) {
                    document.getElementById('cidrSlider').value = prefix;
                    document.getElementById('cidrValue').textContent = prefix;
                }
                calculateSubnet();
            });
        }
    }

    function clearHistory() {
        try { localStorage.removeItem(HISTORY_KEY); } catch (e) {}
        renderHistory();
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('History cleared');
    }

    function timeAgo(ts) {
        var diff = Date.now() - ts;
        var seconds = Math.floor(diff / 1000);
        if (seconds < 60) return 'just now';
        var minutes = Math.floor(seconds / 60);
        if (minutes < 60) return minutes + 'm ago';
        var hours = Math.floor(minutes / 60);
        if (hours < 24) return hours + 'h ago';
        var days = Math.floor(hours / 24);
        return days + 'd ago';
    }

    // ========== Format Binary with colored bits ==========

    function formatBinary(binary, prefixLength) {
        var flat = binary.replace(/\./g, '');
        var result = '';
        for (var i = 0; i < 32; i++) {
            if (i > 0 && i % 8 === 0) result += '.';
            if (i < prefixLength) {
                result += '<span class="network-bits">' + flat[i] + '</span>';
            } else {
                result += '<span class="host-bits">' + flat[i] + '</span>';
            }
        }
        return result;
    }

    function resultItem(label, value) {
        return '<div class="result-item"><label>' + escapeHtml(label) + '</label><div class="value">' + escapeHtml(String(value)) + '</div></div>';
    }

    // ========== Show Error ==========

    function showError(message) {
        document.getElementById('displaySection').innerHTML = '<div class="subnet-error">&#10060; ' + escapeHtml(message) + '</div>';
        document.getElementById('resultActions').classList.remove('visible');
    }

    // ========== Escape HTML ==========

    function escapeHtml(str) {
        if (str === null || str === undefined) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    // ========== Copy Results ==========

    function copyResults() {
        if (!lastResult) return;
        var net = lastResult.network;
        var text = 'Subnet: ' + lastResult.input +
            '\nNetwork: ' + net.networkAddress +
            '\nBroadcast: ' + net.broadcastAddress +
            '\nSubnet Mask: ' + net.subnetMask +
            '\nWildcard Mask: ' + net.wildcardMask +
            '\nFirst Usable: ' + net.lowAddress +
            '\nLast Usable: ' + net.highAddress +
            '\nTotal Addresses: ' + net.totalAddresses +
            '\nUsable Hosts: ' + net.usableHosts +
            '\nCIDR: ' + net.cidrNotation +
            '\nClass: ' + net.networkClass +
            '\nPrivate: ' + (net.isPrivate ? 'Yes' : 'No');
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(text, 'Subnet info copied!');
        } else {
            navigator.clipboard.writeText(text);
        }
    }

    // ========== Share URL ==========

    function shareSubnet() {
        if (!lastResult) return;
        var url = window.location.origin + window.location.pathname + '?subnet=' + encodeURIComponent(lastResult.input);
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        } else {
            navigator.clipboard.writeText(url);
        }
    }

    // ========== Download JSON ==========

    function downloadResults() {
        if (!lastResult) return;
        var blob = new Blob([JSON.stringify(lastResult, null, 2)], { type: 'application/json' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'subnet-' + lastResult.input.replace('/', '-') + '.json';
        a.click();
        URL.revokeObjectURL(url);
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('JSON downloaded!');
    }

    // ========== CIDR Slider sync ==========

    function syncSliderToInput() {
        var cidr = document.getElementById('cidrSlider').value;
        document.getElementById('cidrValue').textContent = cidr;
        var subnetInput = document.getElementById('subnet');
        var val = subnetInput.value;
        if (val.indexOf('/') !== -1) {
            subnetInput.value = val.split('/')[0] + '/' + cidr;
        }
        calculateSubnet();
    }

    // ========== Debounced live calculation ==========

    function debouncedCalculate() {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(function() {
            // Sync slider from input if CIDR changed
            var val = document.getElementById('subnet').value.trim();
            var slashIdx = val.indexOf('/');
            if (slashIdx !== -1) {
                var prefix = parseInt(val.substring(slashIdx + 1), 10);
                if (!isNaN(prefix) && prefix >= 0 && prefix <= 32) {
                    document.getElementById('cidrSlider').value = prefix;
                    document.getElementById('cidrValue').textContent = prefix;
                }
            }
            calculateSubnet();
        }, 300);
    }

    // ========== Init ==========

    document.addEventListener('DOMContentLoaded', function() {
        var subnetEl = document.getElementById('subnet');
        var sliderEl = document.getElementById('cidrSlider');
        var calculateBtnEl = document.getElementById('calculateBtn');
        var includeEl = document.getElementById('includeAddresses');

        // Tab switching
        var tabs = document.querySelectorAll('.subnet-tab');
        for (var t = 0; t < tabs.length; t++) {
            tabs[t].addEventListener('click', function() {
                document.querySelectorAll('.subnet-tab').forEach(function(b){b.classList.remove('active');});
                document.querySelectorAll('.subnet-tab-panel').forEach(function(p){p.classList.remove('active');});
                this.classList.add('active');
                document.getElementById('tab-' + this.getAttribute('data-tab')).classList.add('active');
            });
        }

        // Live input calculation (debounced)
        subnetEl.addEventListener('input', debouncedCalculate);

        // Slider: real-time (no debounce)
        sliderEl.addEventListener('input', syncSliderToInput);

        // Include addresses checkbox
        includeEl.addEventListener('change', calculateSubnet);

        // Calculate button (accessibility)
        calculateBtnEl.addEventListener('click', calculateSubnet);

        // Enter key
        subnetEl.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                clearTimeout(debounceTimer);
                calculateSubnet();
            }
        });

        // Preset chips
        var chips = document.querySelectorAll('#presetChips .preset-chip');
        for (var i = 0; i < chips.length; i++) {
            chips[i].addEventListener('click', function() {
                var preset = this.getAttribute('data-preset');
                subnetEl.value = preset;
                var cidr = preset.split('/')[1];
                sliderEl.value = cidr;
                document.getElementById('cidrValue').textContent = cidr;
                calculateSubnet();
                if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Applied: ' + preset);
            });
        }

        // Action buttons
        document.getElementById('copyBtn').addEventListener('click', copyResults);
        document.getElementById('shareBtn').addEventListener('click', shareSubnet);
        document.getElementById('downloadBtn').addEventListener('click', downloadResults);

        // History
        document.getElementById('clearHistoryBtn').addEventListener('click', clearHistory);
        renderHistory();

        // URL param auto-load
        var params = new URLSearchParams(window.location.search);
        var subnet = params.get('subnet');
        if (subnet) {
            subnetEl.value = subnet;
            var cidr = subnet.split('/')[1];
            if (cidr) {
                var cidrNum = parseInt(cidr, 10);
                if (cidrNum >= 0 && cidrNum <= 32) {
                    sliderEl.value = cidrNum;
                    document.getElementById('cidrValue').textContent = cidrNum;
                }
            }
            calculateSubnet();
        }
    });

    // ========== Globals for inline onclick handlers ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };
    window.copyCommand = function(cmd) {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(cmd, 'Command copied!');
        } else {
            navigator.clipboard.writeText(cmd);
        }
    };

    // ========== Practice Sheet (uses shared module) ==========

    var PRACTICE_OCTETS = [10, 172, 192, 8, 44, 100, 198, 203];
    var EASY_PREFIXES   = [8, 16, 24];
    var MEDIUM_PREFIXES = [20, 21, 22, 25, 26, 27, 28];
    var HARD_PREFIXES   = [9, 11, 13, 15, 17, 19, 23, 27, 29, 30];

    function randInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function pickRandom(arr) {
        return arr[Math.floor(Math.random() * arr.length)];
    }

    function randomIp() {
        return pickRandom(PRACTICE_OCTETS) + '.' + randInt(0, 255) + '.' + randInt(0, 255) + '.' + randInt(0, 254);
    }

    function generateSubnetProblems(difficulty, count) {
        var problems = [];
        var prefixes;
        if (difficulty === 'easy')        prefixes = EASY_PREFIXES;
        else if (difficulty === 'medium') prefixes = MEDIUM_PREFIXES;
        else                              prefixes = HARD_PREFIXES;

        for (var i = 0; i < count; i++) {
            var ip = randomIp();
            var prefix = pickRandom(prefixes);
            var info = calculateSubnetInfo(ip, prefix);
            if (!info) continue;

            var fields = [
                { id: 'net',   label: 'Network Address',   answer: info.networkAddress,   placeholder: 'e.g. 192.168.1.0' },
                { id: 'bcast', label: 'Broadcast Address',  answer: info.broadcastAddress, placeholder: 'e.g. 192.168.1.255' },
                { id: 'mask',  label: 'Subnet Mask',        answer: info.subnetMask,       placeholder: 'e.g. 255.255.255.0' },
                { id: 'hosts', label: 'Usable Hosts',       answer: String(info.usableHosts), placeholder: 'number' }
            ];

            if (difficulty === 'hard') {
                fields.push({ id: 'wild', label: 'Wildcard Mask', answer: info.wildcardMask, placeholder: 'e.g. 0.0.0.255' });
                fields.push({ id: 'first', label: 'First Usable IP', answer: info.lowAddress, placeholder: '' });
            }

            problems.push({
                prompt: 'Given: <strong>' + escapeHtml(ip + '/' + prefix) + '</strong>',
                hint: difficulty === 'easy' ? 'Hint: /' + prefix + ' means ' + (32 - prefix) + ' host bits' : '',
                fields: fields
            });
        }
        return problems;
    }

    // Init practice sheet after DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.PracticeSheet) {
            ToolUtils.PracticeSheet.init({
                containerId: 'practiceSection',
                title: 'Subnetting Practice',
                toolColor: '#0891b2',
                difficulties: [
                    { id: 'easy',   label: 'Easy',   description: '/8, /16, /24' },
                    { id: 'medium', label: 'Medium', description: '/20 - /28' },
                    { id: 'hard',   label: 'Hard',   description: 'Random prefixes, more fields' }
                ],
                generateProblems: generateSubnetProblems
            });
        }
    });

    })();
    </script>
</body>
</html>
