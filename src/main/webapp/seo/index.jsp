<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="SEO and Web Audit Tools - Free Lighthouse, AI SEO Checker" />
        <jsp:param name="toolCategory" value="SEO & Web Audits" />
        <jsp:param name="toolDescription" value="Free SEO and web performance audit tools. Run Google Lighthouse audits with AI fix suggestions, crawl websites for 79+ SEO issues with AI-generated fixes. Core Web Vitals, accessibility, performance scores. No signup required." />
        <jsp:param name="toolUrl" value="seo/" />
        <jsp:param name="toolImage" value="lighthouse-audit.svg" />
        <jsp:param name="toolKeywords" value="seo tools, lighthouse audit, seo checker, web audit, core web vitals, page speed test, ai seo fix, website analyzer, performance audit, accessibility audit, free seo tools" />
        <jsp:param name="toolFeatures" value="Google Lighthouse performance audits,AI-powered SEO checker with fix suggestions,Core Web Vitals monitoring,79+ technical SEO checks,Page load filmstrip and screenshots,AI generates exact code fixes,Free no signup required" />
        <jsp:param name="faq1q" value="What SEO tools are available?" />
        <jsp:param name="faq1a" value="We offer two complementary tools: a Lighthouse Audit that measures page performance, accessibility, and Core Web Vitals using real headless Chrome, and an AI SEO Checker that crawls your entire site for 79+ technical SEO issues. Both include AI-powered fix suggestions." />
        <jsp:param name="faq2q" value="Are these tools free?" />
        <jsp:param name="faq2a" value="Yes, all SEO and web audit tools are completely free with no signup, no API keys, and no usage limits. AI fix suggestions are included at no cost." />
    </jsp:include>

    <!-- CollectionPage Schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "SEO & Web Audit Tools",
      "description": "Free SEO and web performance audit tools with AI-powered fix suggestions.",
      "url": "https://8gwifi.org/seo/",
      "mainEntity": {
        "@type": "ItemList",
        "numberOfItems": 2,
        "itemListElement": [
          {"@type": "ListItem", "position": 1, "name": "Lighthouse Audit", "url": "https://8gwifi.org/seo/lighthouse.jsp"},
          {"@type": "ListItem", "position": 2, "name": "AI SEO Checker", "url": "https://8gwifi.org/seo/seo-checker.jsp"}
        ]
      }
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    </noscript>

    <style>
        :root {
            --seo-idx-font: 'Inter', system-ui, -apple-system, sans-serif;
        }
        .seo-idx-breadcrumbs {
            padding-top: var(--header-height-desktop, 72px);
            background: #f1f5f9;
            border-bottom: 1px solid #e2e8f0;
        }
        @media (max-width: 991px) {
            .seo-idx-breadcrumbs { padding-top: var(--header-height-mobile, 64px); }
        }
        .seo-idx-breadcrumbs-inner {
            max-width: 900px;
            margin: 0 auto;
            padding: 0.625rem 2rem;
            font-size: 0.8125rem;
            color: #94a3b8;
            font-family: var(--seo-idx-font);
        }
        .seo-idx-breadcrumbs a { color: #64748b; text-decoration: none; }
        .seo-idx-breadcrumbs a:hover { color: #0f172a; text-decoration: underline; }
        .seo-idx-breadcrumbs .sep { margin: 0 0.375rem; color: #cbd5e1; }
        .seo-idx-breadcrumbs .current { color: #0f172a; font-weight: 500; }

        .seo-idx-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 40%, #312e81 100%);
            padding: 4rem 2rem;
            text-align: center;
            position: relative;
        }
        .seo-idx-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 30% 40%, rgba(99,102,241,0.15) 0%, transparent 50%),
                        radial-gradient(circle at 70% 60%, rgba(139,92,246,0.12) 0%, transparent 50%);
            pointer-events: none;
        }
        .seo-idx-hero h1 {
            font-family: var(--seo-idx-font);
            font-size: clamp(1.75rem, 4vw, 2.5rem);
            font-weight: 800;
            color: #fff;
            margin-bottom: 0.75rem;
            letter-spacing: -0.02em;
            position: relative;
        }
        .seo-idx-hero p {
            font-family: var(--seo-idx-font);
            font-size: 1.0625rem;
            color: #cbd5e1;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
            position: relative;
        }

        .seo-idx-tools {
            max-width: 900px;
            margin: 0 auto;
            padding: 3rem 2rem 4rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        @media (max-width: 640px) {
            .seo-idx-tools { grid-template-columns: 1fr; padding: 2rem 1rem 3rem; }
        }

        .seo-idx-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 2rem 1.5rem;
            text-decoration: none;
            transition: transform 0.15s, box-shadow 0.15s, border-color 0.15s;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }
        .seo-idx-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(99,102,241,0.12);
            border-color: #a5b4fc;
        }
        .seo-idx-card-icon {
            width: 48px;
            height: 48px;
            border-radius: 0.625rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .seo-idx-card-icon.lighthouse { background: linear-gradient(135deg, #ff6633, #ff8855); }
        .seo-idx-card-icon.seo-check { background: linear-gradient(135deg, #6366f1, #8b5cf6); }

        .seo-idx-card h2 {
            font-family: var(--seo-idx-font);
            font-size: 1.25rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }
        .seo-idx-card p {
            font-family: var(--seo-idx-font);
            font-size: 0.875rem;
            color: #64748b;
            line-height: 1.6;
            margin: 0;
            flex: 1;
        }
        .seo-idx-card-features {
            display: flex;
            flex-wrap: wrap;
            gap: 0.375rem;
        }
        .seo-idx-tag {
            font-family: var(--seo-idx-font);
            font-size: 0.6875rem;
            font-weight: 500;
            padding: 0.25rem 0.625rem;
            border-radius: 9999px;
            background: #f1f5f9;
            color: #475569;
        }
        .seo-idx-tag.ai {
            background: rgba(99,102,241,0.1);
            color: #6366f1;
        }
        .seo-idx-card-cta {
            font-family: var(--seo-idx-font);
            font-size: 0.8125rem;
            font-weight: 600;
            color: #6366f1;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }
        .seo-idx-card:hover .seo-idx-card-cta { color: #4f46e5; }

        /* Dark mode */
        [data-theme="dark"] .seo-idx-breadcrumbs { background: #0f172a; border-bottom-color: rgba(255,255,255,0.06); }
        [data-theme="dark"] .seo-idx-breadcrumbs a { color: #94a3b8; }
        [data-theme="dark"] .seo-idx-breadcrumbs a:hover { color: #e2e8f0; }
        [data-theme="dark"] .seo-idx-breadcrumbs .sep { color: #475569; }
        [data-theme="dark"] .seo-idx-breadcrumbs .current { color: #e2e8f0; }
        [data-theme="dark"] .seo-idx-card { background: #1e293b; border-color: rgba(255,255,255,0.08); }
        [data-theme="dark"] .seo-idx-card:hover { border-color: #6366f1; box-shadow: 0 8px 24px rgba(99,102,241,0.15); }
        [data-theme="dark"] .seo-idx-card h2 { color: #f1f5f9; }
        [data-theme="dark"] .seo-idx-card p { color: #94a3b8; }
        [data-theme="dark"] .seo-idx-tag { background: rgba(255,255,255,0.06); color: #cbd5e1; }
        [data-theme="dark"] .seo-idx-tag.ai { background: rgba(99,102,241,0.15); color: #a5b4fc; }
    </style>
</head>
<body>

    <%@ include file="../modern/components/nav-header.jsp" %>

    <nav class="seo-idx-breadcrumbs" aria-label="Breadcrumb">
        <div class="seo-idx-breadcrumbs-inner">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <span class="sep">/</span>
            <span class="current">SEO &amp; Web Audits</span>
        </div>
    </nav>

    <div class="seo-idx-hero">
        <h1>SEO &amp; Web Audit Tools</h1>
        <p>Measure page performance with real Lighthouse audits and crawl your entire site for SEO issues. Both tools include AI-powered fix suggestions.</p>
    </div>

    <div class="seo-idx-tools">
        <a href="<%=request.getContextPath()%>/seo/lighthouse.jsp" class="seo-idx-card">
            <div class="seo-idx-card-icon lighthouse">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M7 3.5L12 1l5 2.5v5h2.5v3.5H17l2.5 12h-15L7 12H4.5V8.5H7v-5z" fill="#fff"/><rect x="10" y="5" width="4" height="4" fill="#ff3" rx="0.5"/></svg>
            </div>
            <h2>Lighthouse Audit</h2>
            <p>Run a real Google Lighthouse audit on any URL. Get Performance, Accessibility, Best Practices, and SEO scores plus Core Web Vitals, page load filmstrip, and screenshot.</p>
            <div class="seo-idx-card-features">
                <span class="seo-idx-tag ai">AI Fix Suggestions</span>
                <span class="seo-idx-tag">Core Web Vitals</span>
                <span class="seo-idx-tag">Mobile + Desktop</span>
                <span class="seo-idx-tag">Real Chrome</span>
            </div>
            <span class="seo-idx-card-cta">Run Lighthouse Audit &rarr;</span>
        </a>

        <a href="<%=request.getContextPath()%>/seo/seo-checker.jsp" class="seo-idx-card">
            <div class="seo-idx-card-icon seo-check">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="8" stroke="#fff" stroke-width="2"/><path d="M21 21l-4.35-4.35" stroke="#fff" stroke-width="2" stroke-linecap="round"/><path d="M8 11l2 2 4-4" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
            </div>
            <h2>AI SEO Checker</h2>
            <p>Crawl any website and check for 79+ technical SEO issues. AI analyzes each issue and generates copy-paste-ready fixes: meta tags, headers, alt text, canonical URLs, and more.</p>
            <div class="seo-idx-card-features">
                <span class="seo-idx-tag ai">AI-Generated Fixes</span>
                <span class="seo-idx-tag">79+ Checks</span>
                <span class="seo-idx-tag">Multi-Page Crawl</span>
                <span class="seo-idx-tag">0-100 Score</span>
            </div>
            <span class="seo-idx-card-cta">Run SEO Audit &rarr;</span>
        </a>
    </div>

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

    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>

</body>
</html>
