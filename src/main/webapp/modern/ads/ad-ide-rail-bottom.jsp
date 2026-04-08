<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    IDE Right Rail — Bottom Ad Slot (Desktop Only, Sticky)
    Placement: Right column of IDE layout, sticks on scroll
    Format: 300x250 MPU or 336x280
    Display: Only on screens >= 1024px

    Usage: <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
--%>

<div class="ad-container ad-ide-rail-slot ad-ide-rail-sticky"
     id="site_8gwifi_org_ide_rail_bottom"
     data-ad-type="ide-rail-rectangle-sticky"
     role="complementary"
     aria-label="Advertisement">

    <div class="ad-label">Sponsored</div>

    <script>
        (function() {
            var adEl = document.getElementById('site_8gwifi_org_ide_rail_bottom');
            if (!adEl || window.innerWidth < 1024) { if (adEl) adEl.style.display = 'none'; return; }

            // Lazy load — slightly delayed to prioritize top slot
            setTimeout(function() {
                if (typeof googletag !== 'undefined' && googletag.cmd) {
                    googletag.cmd.push(function() {
                        googletag.display('site_8gwifi_org_ide_rail_bottom');
                    });
                }
            }, 2000);
        })();
    </script>
</div>
