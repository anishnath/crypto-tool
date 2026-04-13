/* SEO Issue Types — 79 error types with human-readable titles, descriptions, severity, weight
   Mapped from seonaut translation files */

'use strict';

var SEO_ISSUES = {
    // ══════════ CRITICAL (Priority 1) ══════════
    "ERROR_30x":            { title: "Pages returning 30x redirect", desc: "Redirects waste crawl budget and slow page loading for users and search engines.", severity: "critical", weight: 10 },
    "ERROR_40x":            { title: "Pages returning 4xx client error", desc: "Missing pages hurt crawl efficiency, user experience, and domain authority.", severity: "critical", weight: 10 },
    "ERROR_50x":            { title: "Pages returning 5xx server error", desc: "Server errors prevent indexing and frustrate users.", severity: "critical", weight: 10 },
    "ERROR_REDIRECT_CHAIN": { title: "Redirect chains detected", desc: "Multiple redirects slow down page loading and waste crawl budget.", severity: "critical", weight: 10 },
    "ERROR_REDIRECT_LOOP":  { title: "Redirect loops detected", desc: "Infinite redirect loops prevent search engines from reaching the destination page.", severity: "critical", weight: 10 },
    "HTTP_SCHEME":          { title: "Pages using HTTP instead of HTTPS", desc: "HTTPS provides security and is a ranking signal. HTTP pages may show browser warnings.", severity: "critical", weight: 10 },
    "ERROR_TIMEOUT":        { title: "Pages that timed out", desc: "Slow pages that time out cannot be indexed and frustrate users.", severity: "critical", weight: 10 },

    // ══════════ ALERT (Priority 2) ══════════
    "ERROR_DUPLICATED_TITLE":       { title: "Duplicate page titles", desc: "Unique titles help search engines distinguish pages. Duplicates cause ranking confusion.", severity: "alert", weight: 5 },
    "ERROR_DUPLICATED_DESCRIPTION": { title: "Duplicate meta descriptions", desc: "Unique descriptions improve click-through rates from search results.", severity: "alert", weight: 5 },
    "ERROR_EMPTY_TITLE":            { title: "Missing page title", desc: "Pages without a title rank lower and appear unprofessional in search results.", severity: "alert", weight: 5 },
    "ERROR_SHORT_TITLE":            { title: "Title too short", desc: "Short titles (under 30 chars) miss keyword opportunities and look sparse in SERPs.", severity: "alert", weight: 5 },
    "ERROR_LONG_TITLE":             { title: "Title too long", desc: "Long titles (over 60 chars) get truncated in search results, reducing click-through rate.", severity: "alert", weight: 5 },
    "ERROR_EMPTY_DESCRIPTION":      { title: "Missing meta description", desc: "Meta descriptions appear as snippets in search results. Missing ones reduce CTR.", severity: "alert", weight: 5 },
    "ERROR_SHORT_DESCRIPTION":      { title: "Meta description too short", desc: "Short descriptions (under 70 chars) don't fully utilize the snippet space in SERPs.", severity: "alert", weight: 5 },
    "ERROR_LONG_DESCRIPTION":       { title: "Meta description too long", desc: "Long descriptions (over 160 chars) get truncated, cutting off your message.", severity: "alert", weight: 5 },
    "ERROR_IMAGES_NO_ALT":          { title: "Images missing alt attribute", desc: "Alt text improves accessibility and helps search engines understand image content.", severity: "alert", weight: 5 },
    "ERROR_NO_H1":                  { title: "Missing H1 heading", desc: "The H1 heading tells search engines and users what the page is about.", severity: "alert", weight: 5 },
    "ERROR_HTTP_LINKS":             { title: "HTTPS pages linking to HTTP", desc: "Mixed content links undermine HTTPS security and may trigger browser warnings.", severity: "alert", weight: 5 },
    "ERROR_HREFLANG_RETURN":        { title: "Missing hreflang return link", desc: "Hreflang tags must be bidirectional. Missing return links confuse language targeting.", severity: "alert", weight: 5 },
    "ERROR_CANONICALIZED_NON_CANONICAL": { title: "Canonical points to non-canonical page", desc: "The canonical URL should point to the actual preferred version of the page.", severity: "alert", weight: 5 },
    "ERROR_NOT_VALID_HEADINGS":     { title: "Invalid heading hierarchy", desc: "Headings should follow a logical order (H1 > H2 > H3). Skipping levels hurts structure.", severity: "alert", weight: 5 },
    "ERROR_HREFLANG_TO_NON_CANONICAL": { title: "Hreflang points to non-canonical", desc: "Hreflang should reference canonical URLs to avoid confusing search engines.", severity: "alert", weight: 5 },
    "ERROR_NOFOLLOW_INDEXABLE":     { title: "Nofollow links to indexable pages", desc: "Internal nofollow links prevent link equity flow to important pages.", severity: "alert", weight: 5 },
    "ERROR_SITEMAP_NON_INDEXABLE":  { title: "Non-indexable URLs in sitemap", desc: "Sitemap should only contain indexable URLs. Non-indexable entries waste crawl budget.", severity: "alert", weight: 5 },
    "ERROR_SITEMAP_BLOCKED":        { title: "Blocked URLs in sitemap", desc: "URLs blocked by robots.txt should not appear in the sitemap.", severity: "alert", weight: 5 },
    "ERROR_SITEMAP_NON_CANONICAL":  { title: "Non-canonical URLs in sitemap", desc: "Sitemap should reference canonical URLs, not alternate versions.", severity: "alert", weight: 5 },
    "INCOMING_FOLLOW_NOFOLLOW":     { title: "Mixed follow/nofollow incoming links", desc: "Pages receiving both follow and nofollow links have diluted authority signals.", severity: "alert", weight: 5 },
    "INVALID_LANG":                 { title: "Invalid language attribute", desc: "Invalid lang values prevent search engines from correctly identifying page language.", severity: "alert", weight: 5 },
    "ERROR_HREFLANG_TO_REDIRECT":   { title: "Hreflang points to redirect", desc: "Hreflang should point directly to the destination, not a redirect.", severity: "alert", weight: 5 },
    "ERROR_HREFLANG_TO_ERROR":      { title: "Hreflang points to error page", desc: "Hreflang references should not point to 4xx or 5xx error pages.", severity: "alert", weight: 5 },
    "ERROR_CANONICAL_TO_REDIRECT":  { title: "Canonical points to redirect", desc: "The canonical URL should resolve directly, not redirect.", severity: "alert", weight: 5 },
    "ERROR_CANONICAL_TO_ERROR":     { title: "Canonical points to error page", desc: "Canonical should not reference pages that return error status codes.", severity: "alert", weight: 5 },
    "ERROR_MULTIPLE_CANONICALS":    { title: "Multiple canonical tags", desc: "Only one canonical tag should be present per page to avoid confusion.", severity: "alert", weight: 5 },
    "ERROR_MULTIPLE_HREFLANGS":     { title: "Multiple hreflang tags for same language", desc: "Duplicate hreflang entries for the same language confuse search engines.", severity: "alert", weight: 5 },
    "ERROR_RELATIVE_CANONICAL":     { title: "Relative canonical URL", desc: "Canonical URLs should be absolute (starting with https://) to avoid ambiguity.", severity: "alert", weight: 5 },
    "ERROR_RELATIVE_HREFLANG":      { title: "Relative hreflang URL", desc: "Hreflang URLs should be absolute to ensure correct resolution.", severity: "alert", weight: 5 },
    "ERROR_HREFLANG_MISSING_DEFAULT": { title: "Missing hreflang x-default", desc: "The x-default hreflang tells search engines which version to show for unlisted languages.", severity: "alert", weight: 5 },
    "ERROR_CANONICAL_MISMATCH":     { title: "Canonical mismatch (HTML vs header)", desc: "The canonical URL in the HTML and HTTP header should match.", severity: "alert", weight: 5 },
    "ERROR_LONG_ALT_TEXT":          { title: "Images with very long alt text", desc: "Alt text should be concise (under 125 chars). Overly long alt text looks like keyword stuffing.", severity: "alert", weight: 5 },
    "ERROR_MULTIPLE_TITLES":        { title: "Multiple title tags", desc: "Only one title tag should exist per page. Multiple titles confuse search engines.", severity: "alert", weight: 5 },
    "ERROR_MULTIPLE_DESCRIPTIONS":  { title: "Multiple meta descriptions", desc: "Only one meta description should exist. Multiple descriptions cause unpredictable snippets.", severity: "alert", weight: 5 },
    "ERROR_MULTIPLE_LANG_REFERENCE": { title: "Multiple language references", desc: "Multiple conflicting language indicators confuse search engine language targeting.", severity: "alert", weight: 5 },
    "ERROR_DUPLICATED_CONTENT":     { title: "Duplicate content detected", desc: "Duplicate content dilutes ranking signals and causes indexing confusion.", severity: "alert", weight: 5 },
    "ERROR_HTTP_FORM":              { title: "Forms on HTTP pages", desc: "Forms on non-HTTPS pages expose user data to interception.", severity: "alert", weight: 5 },
    "ERROR_INSECURE_FORM":          { title: "Forms with HTTP action URL", desc: "Form data submitted to HTTP URLs is not encrypted and can be intercepted.", severity: "alert", weight: 5 },
    "ERROR_SPACE_URL":              { title: "URLs containing spaces", desc: "Spaces in URLs cause encoding issues and can break links.", severity: "alert", weight: 5 },
    "ERROR_MULTIPLE_SLASHES":       { title: "URLs with multiple slashes", desc: "Double slashes in URLs create duplicate content issues.", severity: "alert", weight: 5 },
    "ERROR_PICTURE_MISSONG_IMG":    { title: "Picture element missing img fallback", desc: "The picture element should contain an img fallback for browsers that don't support it.", severity: "alert", weight: 5 },
    "ERROR_METAS_IN_BODY":          { title: "Meta tags in document body", desc: "Meta tags must be in the head section. Tags in body may be ignored by search engines.", severity: "alert", weight: 5 },
    "ERROR_PAGINATION_LINKS":       { title: "Pagination URL not linked in body", desc: "Pagination URLs should have corresponding links in the page body.", severity: "alert", weight: 5 },
    "ERROR_LOCALHOST_LINKS":        { title: "Links to localhost", desc: "Localhost links are inaccessible to users and search engines.", severity: "alert", weight: 5 },

    // ══════════ WARNING (Priority 3) ══════════
    "ERROR_LITTLE_CONTENT":         { title: "Thin content (few words)", desc: "Pages with very little text content provide less value and may rank poorly.", severity: "warning", weight: 2 },
    "ERROR_NO_LANG":                { title: "Missing language attribute", desc: "The lang attribute helps screen readers and search engines identify the page language.", severity: "warning", weight: 2 },
    "ERROR_TOO_MANY_LINKS":         { title: "Too many links on page", desc: "Excessive links (100+) dilute link equity and can look spammy.", severity: "warning", weight: 2 },
    "ERROR_INTERNAL_NOFOLLOW":      { title: "Internal nofollow links", desc: "Using nofollow on internal links wastes link equity that could boost important pages.", severity: "warning", weight: 2 },
    "ERROR_EXTERNAL_WITHOUT_NOFOLLOW": { title: "External links without nofollow", desc: "Consider using nofollow on external links to preserve link equity.", severity: "warning", weight: 2 },
    "ERROR_NO_INDEXABLE":           { title: "Non-indexable pages found", desc: "Check if important pages are accidentally marked as noindex.", severity: "warning", weight: 2 },
    "ERROR_HREFLANG_NO_INDEXABLE":  { title: "Hreflang to non-indexable page", desc: "Hreflang should not reference noindex pages.", severity: "warning", weight: 2 },
    "ERROR_BLOCKED":                { title: "Pages blocked by robots.txt", desc: "Blocked pages cannot be crawled or indexed. Ensure important pages are accessible.", severity: "warning", weight: 2 },
    "ERROR_ORPHAN":                 { title: "Orphan pages (no incoming links)", desc: "Pages without internal links are hard to discover for users and crawlers.", severity: "warning", weight: 2 },
    "DEAD_END":                     { title: "Dead-end pages (no outgoing links)", desc: "Pages without outgoing links are navigation dead ends for users and crawlers.", severity: "warning", weight: 2 },
    "ERROR_CANONICALIZED_NON_INDEXABLE": { title: "Canonical to non-indexable page", desc: "Canonicalizing to a noindex page sends conflicting signals.", severity: "warning", weight: 2 },
    "ERROR_MISSING_HSTS":           { title: "Missing HSTS header", desc: "HTTP Strict Transport Security prevents protocol downgrade attacks.", severity: "warning", weight: 2 },
    "ERROR_MISSING_CSP":            { title: "Missing Content-Security-Policy", desc: "CSP helps prevent XSS attacks and other code injection vulnerabilities.", severity: "warning", weight: 2 },
    "ERROR_CONTENT_TYPE_OPTIONS":   { title: "Missing X-Content-Type-Options", desc: "This header prevents MIME type sniffing, reducing security risks.", severity: "warning", weight: 2 },
    "ERROR_LARGE_IMAGE":            { title: "Large images (slow loading)", desc: "Images over 200KB slow page loading, hurting user experience and Core Web Vitals.", severity: "warning", weight: 2 },
    "ERROR_PAGE_DEPTH":             { title: "High page depth", desc: "Pages buried deep in the site hierarchy are harder for crawlers and users to find.", severity: "warning", weight: 2 },
    "ERROR_EXTERNAL_LINK_REDIRECT": { title: "External links to redirects", desc: "External links that redirect waste time and may lead to unexpected destinations.", severity: "warning", weight: 2 },
    "ERROR_EXTERNAL_LINK_BROKEN":   { title: "Broken external links", desc: "Broken outbound links frustrate users and can hurt perceived quality.", severity: "warning", weight: 2 },
    "ERROR_UNDERSCORE_URL":         { title: "URLs with underscores", desc: "Search engines treat underscores as joiners, not separators. Use hyphens instead.", severity: "warning", weight: 2 },
    "ERROR_SLOW_TTFB":              { title: "Slow Time to First Byte", desc: "High TTFB indicates server performance issues that hurt page speed rankings.", severity: "warning", weight: 2 },
    "ERROR_NOIMAGEINDEX":           { title: "Pages with noimageindex", desc: "The noimageindex directive prevents images from appearing in image search.", severity: "warning", weight: 2 },
    "ERROR_NOSNIPPET":              { title: "Pages with nosnippet", desc: "The nosnippet directive prevents search engines from showing text snippets.", severity: "warning", weight: 2 },
    "ERROR_IMG_SIZE_ATTR":          { title: "Images missing size attributes", desc: "Missing width/height causes layout shifts (CLS), hurting Core Web Vitals.", severity: "warning", weight: 2 },
    "ERROR_INCORRECT_MEDIA_TYPE":   { title: "Incorrect content type", desc: "Mismatched content type headers cause browser rendering issues.", severity: "warning", weight: 2 },
    "ERROR_DUPLICATED_ID":          { title: "Duplicate HTML IDs", desc: "Duplicate IDs break JavaScript functionality and confuse assistive technologies.", severity: "warning", weight: 2 },
    "ERROR_MISSING_VIEWPORT":       { title: "Missing viewport meta tag", desc: "Without the viewport tag, pages won't display correctly on mobile devices.", severity: "warning", weight: 2 },
    "ERROR_DOM_SIZE":               { title: "Excessive DOM size", desc: "Large DOM trees slow down rendering and interaction, hurting performance.", severity: "warning", weight: 2 }
};

// ── Scoring ──
//
// Score is 100 minus deductions across three severity tiers. Each tier has a
// maximum deduction cap so one tier cannot tank the whole score. Per-issue
// deduction scales by the fraction of crawled pages affected (so 1/100 pages
// with missing alt is not the same as 100/100). Weights come from SEO_ISSUES.

var SCORE_TIER_CAP = { critical: 45, alert: 30, warning: 20 };
// Multiplier turning (weight × page-fraction) into points. Tuned so a
// maxed-out tier (several 100%-affected issues) hits its cap; a modest site
// with a few issues loses single digits per issue.
var SCORE_SCALAR = 3;

function calculateSeoScore(findings, totalUrls) {
    var pages = (typeof totalUrls === 'number' && totalUrls > 0) ? totalUrls : null;
    var score = 100;
    var tiers = ['critical', 'alert', 'warning'];
    tiers.forEach(function(tier) {
        var tierDeduction = 0;
        (findings[tier] || []).forEach(function(issue) {
            var meta = SEO_ISSUES[issue.error_type] || { weight: 1 };
            var count = Math.max(0, issue.count || 0);
            // Fraction of pages affected. If we don't know total pages, fall
            // back to treating each 10-page chunk as "full saturation".
            var fraction;
            if (pages) {
                fraction = Math.min(count / pages, 1);
            } else {
                fraction = Math.min(count / 10, 1);
            }
            tierDeduction += meta.weight * fraction * SCORE_SCALAR;
        });
        // Cap each tier's contribution
        score -= Math.min(tierDeduction, SCORE_TIER_CAP[tier]);
    });
    return Math.max(0, Math.min(100, Math.round(score)));
}

// Estimate score from aggregate counts (history/list view — we don't have the
// per-issue-type breakdown, so we approximate using average weights per tier
// and "issues per page" as a saturation proxy).
function estimateSeoScore(criticalCount, alertCount, warningCount, totalUrls) {
    var pages = (typeof totalUrls === 'number' && totalUrls > 0) ? totalUrls : 10;
    // Average weights per tier: critical~10, alert~5, warning~2
    var tiers = [
        { count: criticalCount || 0, weight: 10, cap: SCORE_TIER_CAP.critical },
        { count: alertCount    || 0, weight: 5,  cap: SCORE_TIER_CAP.alert },
        { count: warningCount  || 0, weight: 2,  cap: SCORE_TIER_CAP.warning }
    ];
    var score = 100;
    tiers.forEach(function(t) {
        // Aggregate issues-per-page as a saturation proxy. Clamped at 3
        // (3+ distinct issues per page = max deduction for that tier), then
        // multiplied through the standard scalar and capped.
        var issuesPerPage = t.count / pages;
        var deduction = t.weight * Math.min(issuesPerPage, 3) * SCORE_SCALAR;
        score -= Math.min(deduction, t.cap);
    });
    return Math.max(0, Math.min(100, Math.round(score)));
}

function getScoreGrade(score) {
    if (score >= 90) return { label: 'Excellent', color: '#16a34a' };
    if (score >= 70) return { label: 'Good', color: '#65a30d' };
    if (score >= 50) return { label: 'Needs Work', color: '#f59e0b' };
    if (score >= 30) return { label: 'Poor', color: '#ea580c' };
    return { label: 'Critical', color: '#dc2626' };
}

function getIssueMeta(errorType) {
    return SEO_ISSUES[errorType] || {
        title: errorType.replace(/^ERROR_/, '').replace(/_/g, ' '),
        desc: '',
        severity: 'warning',
        weight: 1
    };
}
