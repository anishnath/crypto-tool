<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Siderail Ads (Very wide screens >=1490px only)
    Size: 160x600 fixed on left and right edges

    Usage: <%@ include file="../ads/ad-siderails.jsp" %>
    Place once in page body (position is fixed)
--%>
<%-- Left Siderail --%>
<div id='site_8gwifi_org_siderail_left_desktop' style="position: fixed; left: 10px; top: 135px; z-index: 100;">
    <script>
        if (window.innerWidth >= 1490) {
            googletag.cmd.push(function() { googletag.display('site_8gwifi_org_siderail_left_desktop'); });
        }
    </script>
</div>

<%-- Right Siderail --%>
<div id='site_8gwifi_org_siderail_right_desktop' style="position: fixed; right: 10px; top: 135px; z-index: 100;">
    <script>
        if (window.innerWidth >= 1490) {
            googletag.cmd.push(function() { googletag.display('site_8gwifi_org_siderail_right_desktop'); });
        }
    </script>
</div>
