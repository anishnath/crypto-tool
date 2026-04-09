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
        <jsp:param name="toolName" value="SEO Checker - Free Website SEO Audit Tool Online" />
        <jsp:param name="toolDescription" value="Crawl any website and get a detailed SEO audit with 79+ technical checks. Find broken links, missing meta tags, duplicate content, security issues, and more. Free score 0-100." />
        <jsp:param name="toolCategory" value="Network Tools" />
        <jsp:param name="toolUrl" value="seo/seo-checker.jsp" />
        <jsp:param name="toolKeywords" value="seo checker, seo audit tool, website seo analyzer, technical seo checker, free seo tool, seo score, broken link checker, meta tag checker, site crawler, seo report, website audit, on-page seo, seo analysis online free" />
        <jsp:param name="toolFeatures" value="Full multi-page website crawl,79+ SEO issue checks,0-100 SEO score with grade,Issues grouped by severity,Drill-down to affected URLs,Free no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter URL|Enter the website URL you want to audit and click Analyze,Wait for Crawl|The crawler visits your pages and checks for 79+ SEO issues,Review Results|View your SEO score and issues grouped by Critical Alerts and Warnings,Fix Issues|Click any issue to see affected URLs then fix them on your site" />
        <jsp:param name="faq1q" value="What does this SEO Checker do?" />
        <jsp:param name="faq1a" value="It crawls your website and checks for 79+ technical SEO issues including broken links, missing meta tags, duplicate content, heading hierarchy, security headers, image optimization, and more. You get a 0-100 score with prioritized recommendations." />
        <jsp:param name="faq2q" value="Is it free?" />
        <jsp:param name="faq2a" value="Yes, completely free with no signup or login required. Enter any URL and get a full audit report instantly." />
        <jsp:param name="faq3q" value="How many pages does it crawl?" />
        <jsp:param name="faq3a" value="The crawler follows links within your domain and can check up to 20,000 pages per crawl. It respects robots.txt by default." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/seo/css/seo-checker.css">
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

    <!-- Navigation -->
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- ═══════════════════════════════════════════════
         STATE: INPUT — Hero search bar
         ═══════════════════════════════════════════════ -->
    <div id="seo-input-section">
        <div class="seo-hero">
            <!-- Matter.js physics background -->
            <div id="seo-matter-host" class="seo-matter-host" aria-hidden="true"></div>
            <div class="seo-hero-inner">
                <h1 class="seo-hero-title">SEO Checker</h1>
                <p class="seo-hero-sub">Analyze any website. 79+ technical SEO checks. Instant results.</p>
                <form id="seo-crawl-form" class="seo-hero-form">
                    <div class="seo-search-bar">
                        <svg class="seo-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="url" id="seo-url" class="seo-search-input" placeholder="https://example.com" required autocomplete="url" spellcheck="false">
                        <button type="submit" id="seo-start-btn" class="seo-search-btn">Analyze</button>
                    </div>
                    <!-- Advanced options toggle -->
                    <div class="seo-advanced-toggle">
                        <button type="button" id="seo-advanced-btn" class="seo-advanced-btn">Advanced Options</button>
                    </div>
                    <div class="seo-advanced-panel" id="seo-advanced-panel" style="display:none;">
                        <label><input type="checkbox" id="seo-opt-sitemap"> Crawl sitemap</label>
                        <label><input type="checkbox" id="seo-opt-external"> Check external links</label>
                        <label><input type="checkbox" id="seo-opt-nofollow"> Follow nofollow links</label>
                        <label><input type="checkbox" id="seo-opt-noindex"> Include noindex pages</label>
                        <label><input type="checkbox" id="seo-opt-robots"> Ignore robots.txt</label>
                        <label><input type="checkbox" id="seo-opt-subdomains"> Allow subdomains</label>
                    </div>
                </form>
                <div class="seo-error-msg" id="seo-error-msg"></div>
                <div class="seo-hero-features">
                    <span>Titles &amp; Meta</span>
                    <span>Links &amp; Images</span>
                    <span>Security Headers</span>
                    <span>Performance</span>
                    <span>Structured Data</span>
                </div>
                <!-- Recent scans (loaded dynamically) -->
                <div class="seo-history" id="seo-history"></div>
            </div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: CRAWLING — Live progress
         ═══════════════════════════════════════════════ -->
    <div id="seo-progress-section" style="display:none;">
        <div class="seo-progress-container">
            <div class="seo-progress-visual">
                <div class="seo-pulse-ring"></div>
                <div class="seo-pulse-dot"></div>
            </div>
            <div class="seo-progress-info">
                <div class="seo-progress-url" id="seo-progress-url"></div>
                <div class="seo-progress-label" id="seo-progress-text">Starting crawl...</div>
                <div class="seo-progress-track">
                    <div class="seo-progress-fill" id="seo-progress-bar"></div>
                </div>
                <button class="seo-cancel-btn" id="seo-cancel-btn">Cancel</button>
            </div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: RESULTS — Dashboard
         ═══════════════════════════════════════════════ -->
    <div id="seo-results-section" style="display:none;">
        <div class="seo-results-wrap">

            <!-- Top bar: analyzed URL + actions -->
            <div class="seo-results-topbar">
                <div class="seo-results-url" id="seo-results-url"></div>
                <div class="seo-results-actions">
                    <button class="seo-pill-btn seo-pill-primary" id="seo-share-btn">Share</button>
                    <button class="seo-pill-btn" id="seo-rescan-btn">Re-analyze</button>
                    <button class="seo-pill-btn" id="seo-export-btn">Export CSV</button>
                    <button class="seo-pill-btn" id="seo-new-scan-btn">New Scan</button>
                </div>
            </div>

            <!-- Score + Summary row -->
            <div class="seo-dashboard-row">
                <div id="seo-score-container" class="seo-score-cell"></div>
                <div id="seo-summary" class="seo-summary-cell"></div>
            </div>

            <!-- Ad slot -->
            <div class="seo-ad-slot">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>

            <!-- Issues -->
            <div id="seo-issues-container"></div>

            <!-- Passed checks -->
            <div id="seo-passed-container"></div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: DRILLDOWN — Affected URLs
         ═══════════════════════════════════════════════ -->
    <div id="seo-drilldown-section" style="display:none;">
        <div class="seo-drilldown-wrap">
            <button class="seo-back-btn" id="seo-back-btn">&larr; Back to Results</button>
            <h2 class="seo-drilldown-title" id="seo-drilldown-title"></h2>
            <p class="seo-drilldown-desc" id="seo-drilldown-desc"></p>
            <div id="seo-drilldown-pages"></div>
        </div>
    </div>

    <!-- Below-fold ad -->
    <div class="seo-bottom-ad">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- SEO content (below fold, for crawlers) -->
    <section class="seo-seo-content">
        <div class="seo-seo-inner">
            <h2>Free Online SEO Checker &amp; Website Audit Tool</h2>
            <p>Our SEO Checker crawls your entire website and checks for 79+ technical SEO issues. Get a 0-100 SEO score with issues grouped by severity: critical, alerts, and warnings. Click any issue to see the exact pages affected. Checks include page titles, meta descriptions, heading hierarchy, broken links, image alt text, HTTPS, security headers, structured data, hreflang, canonicals, and much more.</p>
        </div>
    </section>

    <!-- Related Tools -->
    <jsp:include page="/modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="seo/seo-checker.jsp"/>
        <jsp:param name="category" value="Network Tools"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="../modern/components/support-section.jsp" %>

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

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/seo-issues.js" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/seo-checker.js" defer></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js" crossorigin="anonymous"></script>
    <script defer src="<%=request.getContextPath()%>/seo/js/seo-matter-bg.js"></script>

</body>
</html>
