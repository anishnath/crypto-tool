<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sidebar Ad Slot (Desktop only >=992px)
    Sizes: 336x336 (large) or 250x250 (tablet)

    Usage: <%@ include file="../ads/ad-sidebar.jsp" %>
    Place in sidebar or after navigation
--%>
<div id='site_8gwifi_org_sidebar_desktop' class="tutorial-ad-slot tutorial-ad-slot-sidebar" style="min-height: 250px; margin-top: var(--space-4);">
    <script>
        if (window.innerWidth >= 992) {
            googletag.cmd.push(function() { googletag.display('site_8gwifi_org_sidebar_desktop'); });
        }
    </script>
</div>
