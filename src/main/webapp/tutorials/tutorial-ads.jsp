<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    8gwifi.org Tutorial Platform - Ad Scripts (HEAD)

    This file is included in the <head> section of tutorial pages.
    It initializes SetupAds + GPT for lazy loading ad delivery.

    Usage: <%@ include file="../tutorial-ads.jsp" %> (in <head>)

    Ad slots available after including this:
    - site_8gwifi_org_sidebar_desktop (336x336 or 250x250)
    - site_8gwifi_org_siderail_left_desktop (160x600)
    - site_8gwifi_org_siderail_right_desktop (160x600)
    - site_8gwifi_org_leaderboard_responsive (728x90 or 336x336)
    - site_8gwifi_org_anchor_responsive (sticky bottom)
--%>

<%-- Lazy loading library for ads --%>
<script src="https://cdn.jsdelivr.net/npm/in-view@0.6.1/dist/in-view.min.js"></script>
<script>inView.offset(-200);</script>

<%-- Google Publisher Tags (GPT) --%>
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js"></script>
<script>
    stpd = window.stpd || {que: []};
    window.googletag = window.googletag || {cmd: []};
    googletag.cmd.push(function() {
        // Sidebar ad - desktop only (>=992px)
        if (window.innerWidth >= 1200) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_336x336_sidebar_desktop', [[336,336],[336,320],[320,336],[320,320],[300,300],[336,280],[320,250],[300,250]], 'site_8gwifi_org_sidebar_desktop').addService(googletag.pubads());
        } else if (window.innerWidth >= 992) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_250x250_sidebar_desktop', [[250,250]], 'site_8gwifi_org_sidebar_desktop').addService(googletag.pubads());
        }

        // Siderail ads - very wide screens only (>=1490px)
        if (window.innerWidth >= 1490) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_160x600_siderail_left_desktop', [[160,600],[120,600]], 'site_8gwifi_org_siderail_left_desktop').addService(googletag.pubads());
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_160x600_siderail_right_desktop', [[160,600],[120,600]], 'site_8gwifi_org_siderail_right_desktop').addService(googletag.pubads());
        }

        // Anchor ad - responsive (desktop vs mobile sizes)
        if (window.innerWidth >= 1000) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_1000x100_anchor_desktop', [[1000,100],[970,90],[728,90],[990,90],[970,50],[960,90],[950,90],[980,90]], 'site_8gwifi_org_anchor_responsive').addService(googletag.pubads());
        } else {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_anchor_mobile', [[320,100],[320,50],[300,100],[300,50]], 'site_8gwifi_org_anchor_responsive').addService(googletag.pubads());
        }

        // Interstitial ad
        var interstitialSlot = googletag.defineOutOfPageSlot('/147246189,22976055811/8gwifi.org_interstitial', googletag.enums.OutOfPageFormat.INTERSTITIAL);
        if (interstitialSlot) interstitialSlot.addService(googletag.pubads());

        // GPT configuration
        googletag.pubads().disableInitialLoad();
        googletag.pubads().enableSingleRequest();
        googletag.pubads().collapseEmptyDivs();
        googletag.enableServices();
        googletag.display(interstitialSlot);
    });
</script>

<%-- SetupAds optimization script --%>
<script async src="https://stpd.cloud/saas/5796"></script>

<%-- Responsive ad sizing --%>
<style>
    @media (min-width: 1000px) {
        #site_8gwifi_org_leaderboard_responsive {
            min-height: 100px !important;
        }
    }
    @media (max-width: 999px) {
        #site_8gwifi_org_leaderboard_responsive {
            min-height: 336px !important;
        }
    }
    /* Tutorial-specific ad container styling */
    .tutorial-ad-slot {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: var(--space-6) 0;
    }
    .tutorial-ad-slot-sidebar {
        margin-bottom: var(--space-4);
    }
    /* Hide siderails when they would overlap content */
    @media (max-width: 1489px) {
        #site_8gwifi_org_siderail_left_desktop,
        #site_8gwifi_org_siderail_right_desktop {
            display: none !important;
        }
    }
</style>
