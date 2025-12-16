<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Mobile Banner Ad (320x100 or 320x50)
    Placement: Header bar below H1 on mobile/tablet (above the fold)

    Mobile: 320x100 Large Mobile Banner or 320x50 Mobile Banner

    Usage: <%@ include file="/modern/ads/ad-mobile-banner.jsp" %>

    Note: This ad loads immediately (no lazy loading) since it's above the fold
--%>

<div class="ad-container ad-mobile-banner"
     id="site_8gwifi_org_header_mobile"
     data-ad-type="mobile-banner"
     data-ad-position="header"
     role="complementary"
     aria-label="Advertisement">

    <script>
        // Load immediately - above the fold ad
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_header_mobile');
            if (!adContainer) return;

            if (typeof googletag !== 'undefined' && googletag.cmd) {
                googletag.cmd.push(function() {
                    googletag.display('site_8gwifi_org_header_mobile');
                    adContainer.classList.add('ad-loaded');
                    console.log('Ad loaded: Header Mobile Banner');
                });
            }
        })();
    </script>
</div>
