<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Leaderboard/In-Content Ad Slot (Lazy-loaded)
    Desktop: 728x90 / Mobile: 336x336

    Usage: <%@ include file="../ads/ad-leaderboard.jsp" %>
    Place between content sections (e.g., after introduction, before quiz)
--%>
<div id='site_8gwifi_org_leaderboard_responsive' class="tutorial-ad-slot" style="margin: var(--space-8) 0; text-align: center;">
    <script type="text/javascript">
        inView('#site_8gwifi_org_leaderboard_responsive').once('enter', (function() {
            googletag.cmd.push(function() {
                if(window.innerWidth >= 1000) {
                    googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop', [[728,90],[468,60]], 'site_8gwifi_org_leaderboard_responsive').addService(googletag.pubads());
                } else {
                    googletag.defineSlot('/147246189,22976055811/8gwifi.org_336x336_leaderboard_mobile', [[336,336],[336,320],[320,336],[320,320],[300,300],[336,280],[320,250],[300,250]], 'site_8gwifi_org_leaderboard_responsive').addService(googletag.pubads());
                }
                googletag.display('site_8gwifi_org_leaderboard_responsive');
                stpd.initializeAdUnit('site_8gwifi_org_leaderboard_responsive');
            });
        }));
    </script>
</div>
