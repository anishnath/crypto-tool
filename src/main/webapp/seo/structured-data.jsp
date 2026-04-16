<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- SEO -->
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Structured Data Testing Tool - JSON-LD, Microdata, Open Graph Validator" />
        <jsp:param name="toolDescription" value="Test and validate structured data on any URL. Checks JSON-LD, Microdata, RDFa, Open Graph, and Twitter Cards against Google Rich Results requirements. See exactly what search engines see. Free, no signup." />
        <jsp:param name="toolCategory" value="SEO & Web Audits" />
        <jsp:param name="toolUrl" value="seo/structured-data.jsp" />
        <jsp:param name="toolImage" value="lighthouse-audit.svg" />
        <jsp:param name="breadcrumbCategoryUrl" value="seo/" />
        <jsp:param name="toolKeywords" value="structured data testing tool, json-ld validator, schema.org tester, rich results test, open graph checker, twitter card validator, microdata tester, rdfa validator, google rich snippets, structured data checker, schema markup tester, seo structured data" />
        <jsp:param name="toolFeatures" value="JSON-LD Microdata RDFa extraction and validation,Google Rich Results preset checks,Open Graph and Twitter Card validation,Schema.org property testing,Per-schema pass/fail/warning scores,Raw extracted data viewer,Free no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter URL|Paste any public URL you want to test,Extract|The tool fetches the page and extracts all structured data formats,Review results|See per-schema test results with pass fail and warning indicators,Inspect raw data|View the raw JSON-LD Microdata RDFa and meta tags extracted from the page" />
        <jsp:param name="faq1q" value="What structured data formats does this tool check?" />
        <jsp:param name="faq1a" value="It extracts and validates JSON-LD (including @graph), Microdata, RDFa, Open Graph meta tags, and Twitter Card meta tags. Each format is tested against its respective specification." />
        <jsp:param name="faq2q" value="Does it check Google Rich Results eligibility?" />
        <jsp:param name="faq2a" value="Yes. It runs Google Rich Results preset checks for Article, Product, FAQPage, BreadcrumbList, HowTo, LocalBusiness, Organization, WebApplication, and more. Each schema is tested for required and recommended properties." />
        <jsp:param name="faq3q" value="How is this different from Google Rich Results Test?" />
        <jsp:param name="faq3a" value="Google Rich Results Test only checks a subset of schemas Google supports. Our tool tests all structured data on the page including Open Graph, Twitter Cards, and schema types Google does not explicitly document. It also shows the raw extracted data." />
        <jsp:param name="faq4q" value="Is it free?" />
        <jsp:param name="faq4a" value="Yes, completely free with no signup required." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/seo/css/structured-data.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body>

    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Breadcrumbs -->
    <nav class="sd-breadcrumbs" aria-label="Breadcrumb">
        <div class="sd-breadcrumbs-inner">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <span class="sep">/</span>
            <a href="<%=request.getContextPath()%>/seo/">SEO &amp; Web Audits</a>
            <span class="sep">/</span>
            <span class="current">Structured Data Test</span>
        </div>
    </nav>

    <!-- ═══════════════════════════════════════════════
         STATE: INPUT
         ═══════════════════════════════════════════════ -->
    <div id="sd-input-section">
        <div class="sd-hero">
            <div id="sd-matter-host" class="sd-matter-host" aria-hidden="true"></div>
            <div class="sd-hero-inner">
                <h1 class="sd-hero-title">Structured Data Test</h1>
                <p class="sd-hero-sub">Validate JSON-LD, Microdata, RDFa, Open Graph &amp; Twitter Cards. Check Google Rich Results eligibility.</p>

                <form id="sd-form">
                    <div class="sd-search-bar">
                        <svg class="sd-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="url" id="sd-url" class="sd-search-input" placeholder="https://example.com" required autocomplete="url" spellcheck="false">
                        <button type="submit" id="sd-start-btn" class="sd-search-btn">Test</button>
                    </div>
                </form>

                <div class="sd-error-msg" id="sd-error-msg"></div>

                <div class="sd-hero-features">
                    <span>JSON-LD + Microdata + RDFa</span>
                    <span>Google Rich Results</span>
                    <span>Open Graph + Twitter</span>
                    <span>Free, no signup</span>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: PROGRESS
         ═══════════════════════════════════════════════ -->
    <div id="sd-progress-section" style="display:none;">
        <div class="sd-progress-wrap">
            <div class="sd-progress-spinner"></div>
            <div class="sd-progress-url" id="sd-progress-url"></div>
            <div class="sd-progress-text" id="sd-progress-text">Extracting structured data&hellip;</div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: RESULTS
         ═══════════════════════════════════════════════ -->
    <div id="sd-results-section" style="display:none;">
        <div class="sd-results-wrap">

            <!-- Top bar -->
            <div class="sd-results-topbar">
                <div id="sd-results-url"></div>
                <button class="sd-new-btn" id="sd-new-btn">New Test</button>
            </div>

            <!-- Detection badges -->
            <div class="sd-detection" id="sd-detection-badges"></div>

            <!-- Score -->
            <div class="sd-score-row" id="sd-score"></div>

            <!-- Test groups -->
            <div id="sd-groups"></div>

            <!-- Ad slot -->
            <div style="max-width:840px; margin:1.5rem auto; padding:0;">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>

            <!-- Raw data viewer -->
            <div class="sd-raw-section" id="sd-raw-section">
                <div class="sd-raw-header" id="sd-raw-toggle">
                    <span class="sd-raw-chev">&#9654;</span> Raw Extracted Data
                </div>
                <div class="sd-raw-body">
                    <pre class="sd-raw-pre" id="sd-raw-data"></pre>
                </div>
            </div>
        </div>
    </div>

    <!-- Ad slot -->
    <div style="max-width:840px; margin:2rem auto; padding:0 2rem;">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- SEO content -->
    <section style="background:#fff; border-top:1px solid #ebebeb; padding:48px 2rem;">
        <div style="max-width:840px; margin:0 auto;">
            <h2 style="font-size:20px; font-weight:500; color:#222; margin-bottom:12px;">Free Structured Data Testing Tool</h2>
            <p style="font-size:14px; color:#666; line-height:1.7;">Test and validate all structured data on any public URL. Our tool extracts JSON-LD, Microdata, RDFa, Open Graph tags, and Twitter Card tags, then runs validation checks against Google Rich Results requirements and Schema.org specifications. See exactly what search engines see when they crawl your page. Validate Article, Product, FAQ, BreadcrumbList, HowTo, Organization, LocalBusiness, and more. Free, no signup required.</p>

            <div style="margin-top:24px; padding:16px 20px; border:1px solid #ebebeb; border-left:3px solid #4285f4; border-radius:4px; background:#f5f5f5;">
                <h3 style="font-size:15px; font-weight:600; color:#222; margin-bottom:6px;">Also try our other SEO tools</h3>
                <p style="font-size:13px; color:#666; margin:0;">Run a <a href="<%=request.getContextPath()%>/seo/lighthouse.jsp" style="color:#15c; text-decoration:none;"><strong>Lighthouse Audit</strong></a> for performance and Core Web Vitals, or crawl your entire site with our <a href="<%=request.getContextPath()%>/seo/seo-checker.jsp" style="color:#15c; text-decoration:none;"><strong>AI SEO Checker</strong></a> for 79+ technical SEO issues with AI-generated fixes.</p>
            </div>
        </div>
    </section>

    <!-- Related Tools -->
    <jsp:include page="/modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="seo/structured-data.jsp"/>
        <jsp:param name="category" value="SEO &amp; Web Audits"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="../modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/seo/" class="footer-link">SEO Tools</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/structured-data-tests.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/structured-data-ai.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/structured-data.js?v=<%=cacheVersion%>" defer></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js" crossorigin="anonymous"></script>
    <script defer src="<%=request.getContextPath()%>/seo/js/structured-data-matter.js?v=<%=cacheVersion%>"></script>

    <!-- Raw data toggle -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toggle = document.getElementById('sd-raw-toggle');
            if (toggle) toggle.addEventListener('click', function() {
                document.getElementById('sd-raw-section').classList.toggle('open');
            });
        });
    </script>

</body>
</html>
