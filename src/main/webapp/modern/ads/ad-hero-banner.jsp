<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Hero Banner Ad Unit
    Placement: Above-the-fold, inside hero section before tool content

    Desktop: 970x90 / 728x90 (wide leaderboard)
    Tablet:  728x90
    Mobile:  320x100 / 320x50

    Loads immediately (no lazy loading) — above the fold = highest viewability.
    Collapses to zero height if no ad fill, so hero section stays clean.

    Usage: <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
--%>

<div class="ad-container ad-hero-banner"
     id="site_8gwifi_org_hero_banner"
     data-ad-type="hero-banner"
     data-ad-position="hero"
     role="complementary"
     aria-label="Advertisement">

    <div class="ad-label">Sponsored</div>

    <script>
        // Load immediately — above-the-fold ad, highest viewability
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_hero_banner');
            if (!adContainer) return;

            if (typeof googletag !== 'undefined' && googletag.cmd) {
                googletag.cmd.push(function() {
                    googletag.display('site_8gwifi_org_hero_banner');
                    adContainer.classList.add('ad-loaded');
                    console.log('Ad loaded: Hero Banner');
                });
            }
        })();
    </script>
</div>
