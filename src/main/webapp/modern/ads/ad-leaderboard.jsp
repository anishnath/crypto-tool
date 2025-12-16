<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Leaderboard Ad (728x90)
    Placement: Header bar next to H1 (above the fold)

    Desktop: 728x90 Leaderboard

    Usage: <%@ include file="/modern/ads/ad-leaderboard.jsp" %>

    Note: This ad loads immediately (no lazy loading) since it's above the fold
--%>

<div class="ad-container ad-leaderboard"
     id="site_8gwifi_org_header_leaderboard"
     data-ad-type="leaderboard"
     data-ad-position="header"
     role="complementary"
     aria-label="Advertisement">

    <script>
        // Load immediately - above the fold ad
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_header_leaderboard');
            if (!adContainer) return;

            if (typeof googletag !== 'undefined' && googletag.cmd) {
                googletag.cmd.push(function() {
                    googletag.display('site_8gwifi_org_header_leaderboard');
                    adContainer.classList.add('ad-loaded');
                    console.log('Ad loaded: Header Leaderboard 728x90');
                });
            }
        })();
    </script>
</div>
