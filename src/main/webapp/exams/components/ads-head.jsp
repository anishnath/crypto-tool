<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Ad Scripts for Head

    Usage: <%@ include file="components/ads-head.jsp" %> (in <head>)
--%>
<!-- Google Tag Manager / Ad Setup -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js"></script>
<script>
    var googletag = googletag || {};
    googletag.cmd = googletag.cmd || [];

    googletag.cmd.push(function() {
        // Define ad slots for exam platform
        if(window.innerWidth >= 1400) {
            // Large desktop: 3-column layout with left sidebar
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop', [[728,90],[468,60]], 'exam_leaderboard').addService(googletag.pubads());
            googletag.defineSlot('/147246189,22976055811/site_8gwifi_org_336x336_sidebar', [[336,336],[300,250]], 'exam_sidebar').addService(googletag.pubads());
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_160x600_skyscraper', [[160,600],[120,600]], 'exam_sidebar_left').addService(googletag.pubads());
        } else if(window.innerWidth >= 1000) {
            // Desktop: 2-column layout
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop', [[728,90],[468,60]], 'exam_leaderboard').addService(googletag.pubads());
            googletag.defineSlot('/147246189,22976055811/site_8gwifi_org_336x336_sidebar', [[336,336],[300,250]], 'exam_sidebar').addService(googletag.pubads());
        } else {
            // Mobile: single column
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_336x336_leaderboard_mobile', [[336,336],[320,320],[300,300],[320,250],[300,250]], 'exam_leaderboard').addService(googletag.pubads());
        }
        googletag.defineSlot('/147246189,22976055811/8gwifi.org_anchor_responsive', [[320,50],[320,100]], 'exam_anchor').addService(googletag.pubads());

        googletag.pubads().enableSingleRequest();
        googletag.pubads().collapseEmptyDivs();
        googletag.enableServices();
    });
</script>

<!-- SetupAds Optimization Service -->
<script>
    // Initialize stpd queue before SetupAds script loads
    window.stpd = window.stpd || { que: [] };
    
    // Load SetupAds script (silently fail if blocked by ad blocker)
    (function() {
        var script = document.createElement('script');
        script.src = 'https://stpd.cloud/saas/5796';
        script.async = true;
        script.onerror = function() {
            // Silently handle ad blocker - this is expected behavior
            console.debug('SetupAds script blocked by ad blocker (expected)');
        };
        document.head.appendChild(script);
    })();
</script>

<!-- InView for lazy loading (using jsdelivr) - defer to avoid blocking LCP -->
<script defer src="https://cdn.jsdelivr.net/npm/in-view@0.6.1/dist/in-view.min.js"></script>
