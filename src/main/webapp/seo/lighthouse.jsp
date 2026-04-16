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
        <jsp:param name="toolName" value="Free Lighthouse Audit - Performance, SEO, Accessibility, Core Web Vitals" />
        <jsp:param name="toolDescription" value="Run a real Google Lighthouse audit on any URL with AI-powered fix suggestions. Get Performance, Accessibility, Best Practices, and SEO scores plus Core Web Vitals (LCP, FCP, CLS, TBT, TTFB). AI analyzes every failed audit and generates the exact fix. Free, no signup." />
        <jsp:param name="toolCategory" value="SEO &amp; Web Audits" />
        <jsp:param name="toolUrl" value="seo/lighthouse.jsp" />
        <jsp:param name="toolImage" value="lighthouse-audit.svg" />
        <jsp:param name="breadcrumbCategoryUrl" value="seo/seo-checker.jsp" />
        <jsp:param name="toolKeywords" value="lighthouse audit, lighthouse online, free lighthouse test, page speed test, core web vitals checker, lcp tester, performance audit, seo audit, accessibility audit, best practices audit, web vitals online, page speed insights alternative, lighthouse score, ai lighthouse fix, ai performance fix, mobile vs desktop performance" />
        <jsp:param name="toolFeatures" value="Real Google Lighthouse engine (headless Chrome),AI Fix suggestions for every failed audit,Mobile and desktop strategies,Performance Accessibility Best Practices SEO scores,Core Web Vitals: LCP FCP CLS TBT TTFB Speed Index TTI,Page load filmstrip and final screenshot,Failed and passed audits with descriptions,Audit history per URL,Shareable result links,Free no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter URL|Paste any public URL you want to audit,Choose strategy|Pick mobile (default) or desktop and select which categories to test,Run audit|Click Audit and wait 30-90 seconds while Lighthouse runs in real headless Chrome,Review scores|See category scores 0-100 plus Core Web Vitals and the full list of failed and passed audits,Get AI fixes|Click AI Fix on any failed audit to get an AI-generated fix with exact code changes" />
        <jsp:param name="faq1q" value="What is a Lighthouse audit?" />
        <jsp:param name="faq1a" value="Lighthouse is Google's open-source tool that runs a real headless Chrome browser against any URL and measures Performance, Accessibility, Best Practices, and SEO. It reports Core Web Vitals (LCP, FCP, CLS, TBT) which Google uses as ranking signals." />
        <jsp:param name="faq2q" value="How does the AI Fix feature work?" />
        <jsp:param name="faq2a" value="After your audit completes, click AI Fix on any failed audit item. AI analyzes the audit evidence, your page URL, and the Lighthouse recommendation, then generates a specific fix with exact code, configuration changes, or HTML modifications you can copy-paste directly." />
        <jsp:param name="faq3q" value="How is this different from PageSpeed Insights?" />
        <jsp:param name="faq3a" value="PageSpeed Insights uses real-user CrUX field data plus a single Lighthouse run. Our tool runs Lighthouse on demand, shows a page load filmstrip and final screenshot, and adds AI-generated fix suggestions for every failed audit - something PageSpeed Insights does not offer." />
        <jsp:param name="faq4q" value="What do the score colors mean?" />
        <jsp:param name="faq4a" value="Lighthouse uses three thresholds: 90-100 is green (good), 50-89 is orange (needs improvement), and 0-49 is red (poor). Each category score is a weighted average of its individual audits." />
        <jsp:param name="faq5q" value="How long does an audit take?" />
        <jsp:param name="faq5a" value="Typically 30-90 seconds. The tool spins up real headless Chrome, loads the page, simulates network throttling, and runs all enabled audits. Slow pages or large bundles take longer." />
        <jsp:param name="faq6q" value="Is the Lighthouse audit free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no signup, no API keys, and no limits on pages you can audit. AI fix suggestions are included at no cost." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/seo/css/lighthouse.css">
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

    <!-- Lighthouse Left Rail Ad Slot (page-specific, desktop 1200px+) -->
    <script>
        googletag.cmd.push(function() {
            if (window.innerWidth >= 1200) {
                googletag.defineSlot('/147246189,22976055811/8gwifi.org_160x600_siderail_left_desktop',
                    [[160,600],[120,600]],
                    'site_8gwifi_org_lh_left_rail')
                    .addService(googletag.pubads());
            }
        });
    </script>
</head>
<body>

    <!-- Navigation -->
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Left Rail Ad (desktop only, visible when results are shown) -->
    <div class="lh-left-rail-ad" id="lh-left-rail-ad">
        <div id="site_8gwifi_org_lh_left_rail" class="lh-left-rail-slot"
             data-ad-type="side-rail" role="complementary" aria-label="Advertisement">
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: INPUT — Hero with audit form
         ═══════════════════════════════════════════════ -->
    <div id="lh-input-section">
        <div class="lh-hero">
            <!-- Matter.js physics background -->
            <div id="lh-matter-host" class="lh-matter-host" aria-hidden="true"></div>
            <div class="lh-hero-inner">
                <h1 class="lh-hero-title">Lighthouse Audit</h1>
                <p class="lh-hero-sub">Real Google Lighthouse audit on any URL. Performance, Accessibility, Best Practices, SEO &amp; Core Web Vitals.</p>

                <form id="lh-form" class="lh-hero-form">
                    <div class="lh-search-bar">
                        <svg class="lh-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="url" id="lh-url" class="lh-search-input" placeholder="https://example.com" required autocomplete="url" spellcheck="false">
                        <button type="submit" id="lh-start-btn" class="lh-search-btn">Audit</button>
                    </div>

                    <div class="lh-options-row">
                        <!-- Strategy: mobile / desktop -->
                        <div class="lh-option-group">
                            <button type="button" class="lh-option-btn lh-strategy-btn active" data-strategy="mobile">Mobile</button>
                            <button type="button" class="lh-option-btn lh-strategy-btn" data-strategy="desktop">Desktop</button>
                        </div>

                        <!-- Categories -->
                        <label class="lh-cat-checkbox"><input type="checkbox" value="performance" checked> Performance</label>
                        <label class="lh-cat-checkbox"><input type="checkbox" value="accessibility" checked> Accessibility</label>
                        <label class="lh-cat-checkbox"><input type="checkbox" value="best-practices" checked> Best Practices</label>
                        <label class="lh-cat-checkbox"><input type="checkbox" value="seo" checked> SEO</label>
                    </div>
                </form>

                <div class="lh-error-msg" id="lh-error-msg"></div>

                <div class="lh-hero-features">
                    <span>Real headless Chrome</span>
                    <span>Mobile + Desktop</span>
                    <span>Core Web Vitals</span>
                    <span>Audit history</span>
                    <span>Free, no signup</span>
                </div>

                <!-- Recent audits (loaded dynamically) -->
                <div class="lh-history" id="lh-history"></div>
            </div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: PROGRESS — running audit (30-90s)
         ═══════════════════════════════════════════════ -->
    <div id="lh-progress-section" style="display:none;">
        <div class="lh-progress-wrap">
            <div class="lh-pulse-visual">
                <div class="lh-pulse-ring"></div>
                <div class="lh-pulse-dot"></div>
            </div>
            <div class="lh-progress-url" id="lh-progress-url"></div>
            <div class="lh-progress-text" id="lh-progress-text">Enqueuing audit&hellip;</div>
            <div class="lh-progress-hint" id="lh-progress-hint">Your audit is running on a real headless Chrome worker. Typical total wait: 30&ndash;90 seconds (including queue time).</div>
            <div class="lh-elapsed" id="lh-elapsed">0s</div>
            <div style="margin-top:1rem;">
                <button type="button" class="lh-pill-btn" id="lh-cancel-btn" style="font-size:0.8125rem;">Cancel &amp; Start Over</button>
            </div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         STATE: RESULTS — gauges + Core Web Vitals + audits
         ═══════════════════════════════════════════════ -->
    <div id="lh-results-section" style="display:none;">
        <!-- Matter.js ambient background for results -->
        <div id="lh-results-matter" class="lh-results-matter" aria-hidden="true"></div>
        <div class="lh-results-wrap">

            <!-- Top bar -->
            <div class="lh-results-topbar">
                <div class="lh-results-url" id="lh-results-url"></div>
                <div class="lh-results-actions">
                    <button class="lh-pill-btn lh-pill-primary" id="lh-share-btn">Share</button>
                    <button class="lh-pill-btn" id="lh-rescan-btn">Re-audit</button>
                    <button class="lh-pill-btn" id="lh-new-btn">New Audit</button>
                </div>
            </div>

            <!-- Category header: gauges | separator | screenshot (Lighthouse layout) -->
            <div class="lh-category-header" id="lh-category-header">
                <div class="lh-gauges-col" id="lh-gauges"></div>
                <div class="lh-header-separator" id="lh-header-separator" style="display:none;"></div>
                <div class="lh-screenshot-col" id="lh-screenshot-wrap" style="display:none;"></div>
            </div>

            <!-- Filmstrip (page-load progression thumbnails) -->
            <div class="lh-filmstrip-container" id="lh-filmstrip-section" style="display:none;">
                <div class="lh-filmstrip" id="lh-filmstrip-strip"></div>
            </div>

            <!-- Performance metrics (2-col grid like Lighthouse) -->
            <div class="lh-metrics-section" id="lh-cwv-section" style="display:none;">
                <div class="lh-metrics-header">
                    <span class="lh-metrics-title">Metrics</span>
                </div>
                <div class="lh-metrics-container" id="lh-cwv-grid"></div>
            </div>

            <!-- Ad slot -->
            <div class="lh-bottom-ad">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>

            <!-- Failed audits -->
            <div class="lh-audit-section" id="lh-failed-section" style="display:none;">
                <div class="lh-audit-header">
                    <div class="lh-audit-header-left">
                        <span class="lh-audit-header-title">Opportunities &amp; Diagnostics</span>
                        <span class="lh-audit-count-badge" id="lh-failed-count"></span>
                    </div>
                    <span class="lh-audit-chevron">&#9660;</span>
                </div>
                <div class="lh-audit-list" id="lh-failed-list"></div>
            </div>

            <!-- Passed audits (collapsed by default) -->
            <div class="lh-audit-section collapsed" id="lh-passed-section" style="display:none;">
                <div class="lh-audit-header">
                    <div class="lh-audit-header-left">
                        <span class="lh-audit-header-title">Passed audits</span>
                        <span class="lh-audit-count-badge" id="lh-passed-count"></span>
                    </div>
                    <span class="lh-audit-chevron">&#9660;</span>
                </div>
                <div class="lh-audit-list" id="lh-passed-list"></div>
            </div>

        </div>
    </div>

    <!-- Below-fold ad -->
    <div class="lh-bottom-ad">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- SEO content (below fold, for crawlers) -->
    <section class="lh-seo-content">
        <div class="lh-seo-inner">
            <h2>Free Online Lighthouse Audit Tool</h2>
            <p>Run a real Google Lighthouse audit on any public URL with one click. Our tool spins up a headless Chrome instance and runs the official Lighthouse engine against your page, returning the same scores you'd get from Chrome DevTools or PageSpeed Insights: Performance, Accessibility, Best Practices, and SEO. You also get every Core Web Vital that Google uses as a ranking signal &mdash; Largest Contentful Paint (LCP), First Contentful Paint (FCP), Cumulative Layout Shift (CLS), Total Blocking Time (TBT), Time to First Byte (TTFB), Speed Index, and Time to Interactive (TTI). Choose between mobile and desktop strategies, and pick which categories to test. Every audit is saved so you can compare runs over time. Free, no signup, no API keys.</p>

            <div class="lh-cross-link">
                <h3>Also try our SEO Checker</h3>
                <p>Lighthouse measures page performance and Core Web Vitals. For a full technical SEO audit &mdash; crawl your entire site for 79+ issues including broken links, missing meta tags, duplicate content, security headers, and more &mdash; use our <a href="<%=request.getContextPath()%>/seo/seo-checker.jsp"><strong>AI SEO Checker</strong></a>. It scores your site 0&ndash;100, groups issues by severity, and generates copy-paste-ready fixes with AI.</p>
            </div>
        </div>
    </section>

    <!-- Related Tools -->
    <jsp:include page="/modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="seo/lighthouse.jsp"/>
        <jsp:param name="category" value="SEO &amp; Web Audits"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="../modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/seo/seo-checker.jsp" class="footer-link">SEO Checker</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/lighthouse-ai.js" defer></script>
    <script src="<%=request.getContextPath()%>/seo/js/lighthouse.js" defer></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js" crossorigin="anonymous"></script>
    <script defer src="<%=request.getContextPath()%>/seo/js/lighthouse-matter-bg.js"></script>
    <script defer src="<%=request.getContextPath()%>/seo/js/lighthouse-matter-results.js"></script>

</body>
</html>
