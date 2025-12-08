<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Siderail Ads (Very wide screens >=1600px only)
    Size: 160x600 fixed on left and right edges

    Note: Left siderail disabled for tutorials as it overlaps the sidebar navigation.
    Only right siderail is shown on very wide screens.

    Usage: <%@ include file="../ads/ad-siderails.jsp" %>
    Place once in page body (position is fixed)
--%>

<%-- Left Siderail - DISABLED for tutorials (overlaps sidebar navigation)
<div id='site_8gwifi_org_siderail_left_desktop' class="tutorial-siderail-ad" style="position: fixed; left: 10px; top: 135px; z-index: 100; display: none;">
    <script>
        if (window.innerWidth >= 1600) {
            var el = document.getElementById('site_8gwifi_org_siderail_left_desktop');
            if (el) el.style.display = 'block';
            googletag.cmd.push(function() { googletag.display('site_8gwifi_org_siderail_left_desktop'); });
        }
    </script>
</div>
--%>

<%-- Right Siderail - Only on very wide screens (>=1600px) --%>
<div id='site_8gwifi_org_siderail_right_desktop' class="tutorial-siderail-ad" style="position: fixed; right: 10px; top: 135px; z-index: 100; display: none;">
    <script>
        if (window.innerWidth >= 1600) {
            var el = document.getElementById('site_8gwifi_org_siderail_right_desktop');
            if (el) el.style.display = 'block';
            googletag.cmd.push(function() { googletag.display('site_8gwifi_org_siderail_right_desktop'); });
        }
    </script>
</div>
