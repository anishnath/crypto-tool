<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    IDE Right Rail — Top Ad Slot (Desktop Only)
    Placement: Right column of IDE layout, above fold
    Format: 300x250 MPU (highest CPM) or 336x280
    Display: Only on screens >= 1024px (right rail visible)

    Usage: <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
--%>

<div class="ad-container ad-ide-rail-slot"
     id="site_8gwifi_org_ide_rail_top"
     data-ad-type="ide-rail-rectangle"
     role="complementary"
     aria-label="Advertisement">

    <div class="ad-label">Sponsored</div>

    <script>
        (function() {
            var adEl = document.getElementById('site_8gwifi_org_ide_rail_top');
            if (!adEl || window.innerWidth < 1024) { if (adEl) adEl.style.display = 'none'; return; }

            // Load immediately — above fold, always visible
            if (typeof googletag !== 'undefined' && googletag.cmd) {
                googletag.cmd.push(function() {
                    googletag.display('site_8gwifi_org_ide_rail_top');
                });
            }
        })();
    </script>
</div>
