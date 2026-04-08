<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modern Ad System - Initialization (HEAD)
    
    Include this ONCE in <head> section of pages.
    
    Initializes GPT slots for:
    - Leaderboard (in-content top): 728x90 desktop, 320x100 mobile
    - Rectangle (in-content mid): 300x250 all screens
    - Anchor (sticky footer): 728x90 desktop, 320x100 mobile
    
    Usage: <%@ include file="modern/ads/ad-init.jsp" %>
--%>

<!-- Native IntersectionObserver used for lazy loading (no external library needed) -->
<!-- Supported by all modern browsers: Chrome 51+, Firefox 55+, Safari 12.1+, Edge 15+ -->

<!-- Google Publisher Tags (GPT) -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed to load')"></script>
<script>
    // Initialize GPT
    stpd = window.stpd || {que: []};
    window.googletag = window.googletag || {cmd: []};
    
    googletag.cmd.push(function() {
        var width = window.innerWidth;
        
        // ============================================
        // AD SLOT 1: Leaderboard (In-Content Top)
        // Placement: After tool results, before "How It Works"
        // ============================================
        if (width >= 992) {
            // Desktop: Prioritize larger formats for higher CPM (970x90, 970x250)
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop', 
                [[970,250],[970,90],[728,90],[728,250]], 
                'site_8gwifi_org_leaderboard_responsive')
                .addService(googletag.pubads());
        } else if (width >= 768) {
            // Tablet: 728x90 Leaderboard
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_tablet', 
                [[728,90],[970,90]], 
                'site_8gwifi_org_leaderboard_responsive')
                .addService(googletag.pubads());
        } else {
            // Mobile: 320x100 Banner or 336x280 Large Mobile
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile', 
                [[320,100],[336,280],[320,50],[300,100],[300,250]], 
                'site_8gwifi_org_leaderboard_responsive')
                .addService(googletag.pubads());
        }
        
        // ============================================
        // AD SLOT 2: Rectangle (In-Content Mid)
        // Placement: Between content sections (after "How It Works")
        // ============================================
        if (width >= 768) {
            // Desktop/Tablet: Prioritize larger rectangle (336x280) for better CPM
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_rectangle_desktop', 
                [[336,280],[300,250],[250,250]], 
                'site_8gwifi_org_rectangle_responsive')
                .addService(googletag.pubads());
        } else {
            // Mobile: 300x250 or 320x100
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_rectangle_mobile', 
                [[300,250],[320,100],[336,280],[250,250]], 
                'site_8gwifi_org_rectangle_responsive')
                .addService(googletag.pubads());
        }
        
        // ============================================
        // AD SLOT 3: Anchor (Sticky Footer)
        // Placement: Fixed bottom, dismissible
        // ============================================
        if (width >= 992) {
            // Desktop: Prioritize larger formats for sticky footer (970x250, 970x90)
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_anchor_desktop', 
                [[970,250],[970,90],[728,90]], 
                'site_8gwifi_org_anchor_responsive')
                .addService(googletag.pubads());
        } else {
            // Mobile: 320x100 Banner
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_anchor_mobile', 
                [[320,100],[320,50],[300,100],[300,50]], 
                'site_8gwifi_org_anchor_responsive')
                .addService(googletag.pubads());
        }
        
        // ============================================
        // AD SLOT 4: Floating Right Rectangle (Desktop Only, > 1300px)
        // Placement: Fixed right side, appears after scroll
        // ============================================
        if (width >= 1300) {
            // Desktop Wide: 336x280 or 300x250 Rectangle
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_floating_desktop', 
                [[336,280],[300,250],[250,250]], 
                'site_8gwifi_org_floating_right')
                .addService(googletag.pubads());
        }
        
        // ============================================
        // AD SLOT 5: Right Sidebar Top (Desktop Only, >= 1025px)
        // Placement: Three-column layout sidebar, top position
        // ============================================
        if (width >= 1025) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_sidebar_top',
                [[336,280],[300,250],[250,250]],
                'site_8gwifi_org_sidebar_top')
                .addService(googletag.pubads());
        }

        // ============================================
        // AD SLOT 6: Right Sidebar Mid (Desktop Only, >= 1025px)
        // Placement: Three-column layout sidebar, middle position
        // ============================================
        if (width >= 1025) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_sidebar_mid',
                [[336,280],[300,250],[250,250]],
                'site_8gwifi_org_sidebar_mid')
                .addService(googletag.pubads());
        }
        
        // ============================================
        // AD SLOT 7: Hero Banner (Above Tool Content)
        // Placement: Hero section, above-the-fold, loads immediately
        // ============================================
        if (width >= 992) {
            // Desktop: Wide banner (970x90, 728x90)
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',
                [[970,90],[728,90],[970,250],[728,250]],
                'site_8gwifi_org_hero_banner')
                .addService(googletag.pubads());
        } else if (width >= 768) {
            // Tablet: 728x90
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',
                [[728,90],[468,60]],
                'site_8gwifi_org_hero_banner')
                .addService(googletag.pubads());
        } else {
            // Mobile: 320x100 or 320x50
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',
                [[320,100],[320,50],[300,100],[300,50]],
                'site_8gwifi_org_hero_banner')
                .addService(googletag.pubads());
        }

        // ============================================
        // AD SLOT 8: Panel Native (Editor Right Panel Top)
        // Placement: Above outline in editor .me-right-panel
        // ============================================
        if (width >= 1025) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_250x250_panel_native',
                [[250,250],[300,250]],
                'site_8gwifi_org_panel_native')
                .addService(googletag.pubads());
        }

        // ============================================
        // AD SLOT 9: Sidebar Native (Dashboard Left Sidebar)
        // Placement: Below nav links in dashboard .me-sidebar
        // ============================================
        if (width >= 769) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_200x200_sidebar_native',
                [[200,200],[160,600],[120,600],[250,250]],
                'site_8gwifi_org_sidebar_native')
                .addService(googletag.pubads());
        }

        // ============================================
        // AD SLOT 10: Below Grid (Dashboard Content Bottom)
        // Placement: After document grid in dashboard .me-dash-main
        // ============================================
        if (width >= 992) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_below_grid_desktop',
                [[728,90],[970,90]],
                'site_8gwifi_org_below_grid')
                .addService(googletag.pubads());
        } else {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_below_grid_mobile',
                [[320,100],[320,50],[300,100]],
                'site_8gwifi_org_below_grid')
                .addService(googletag.pubads());
        }

        // ============================================
        // AD SLOT 11: IDE Right Rail Top (Desktop Only, >= 1024px)
        // Placement: Dedicated right column in IDE/compiler layout
        // ============================================
        if (width >= 1024) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_ide_rail_top',
                [[300,250],[336,280],[250,250]],
                'site_8gwifi_org_ide_rail_top')
                .addService(googletag.pubads());
        }

        // ============================================
        // AD SLOT 12: IDE Right Rail Bottom Sticky (Desktop Only, >= 1024px)
        // Placement: Sticky ad in IDE right column, stays visible on scroll
        // ============================================
        if (width >= 1024) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_ide_rail_bottom',
                [[300,250],[336,280],[250,250]],
                'site_8gwifi_org_ide_rail_bottom')
                .addService(googletag.pubads());
        }

        // ============================================
        // GPT Configuration
        // ============================================
        googletag.pubads().disableInitialLoad();  // Lazy load ads
        googletag.pubads().enableSingleRequest(); // Single request for all ads
        googletag.pubads().collapseEmptyDivs();   // Hide empty ad slots
        googletag.enableServices();
    });
</script>

<!-- SetupAds Optimization Service -->
<!-- Ad System Script (silently fail if blocked by ad blocker) -->
<script>
    (function() {
        var script = document.createElement('script');
        script.src = 'https://stpd.cloud/saas/5796';
        script.async = true;
        script.onerror = function() {
            // Silently handle ad blocker - this is expected behavior
            console.debug('Ad script blocked by ad blocker (expected)');
        };
        document.head.appendChild(script);
    })();
</script>

<!-- Ad Styling -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">

