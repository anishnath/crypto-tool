<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tutorial Right Ad Rail Component

    Displays a sticky right sidebar with ads on wide screens (>=1400px).
    Shows 2 ad slots: one 300x250 and one 300x600.

    Usage:
    <%@ include file="../tutorial-ad-rail.jsp" %>

    Note: Add class "has-ad-rail" to tutorial-layout div when using this component.
--%>

<aside class="tutorial-ad-rail" id="adRail">
    <div class="ad-rail-inner">
        <%-- Ad Slot 1: 300x250 Medium Rectangle --%>
        <div class="ad-rail-slot" id="ad_rail_top">
            <script>
                (function() {
                    if (window.innerWidth < 1400) return;

                    if (typeof googletag !== 'undefined') {
                        googletag.cmd.push(function() {
                            try {
                                googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x250_sidebar',
                                    [[300,250],[336,280],[320,250]],
                                    'ad_rail_top'
                                ).addService(googletag.pubads());
                                googletag.display('ad_rail_top');
                                if (typeof stpd !== 'undefined' && stpd.initializeAdUnit) {
                                    stpd.initializeAdUnit('ad_rail_top');
                                }
                            } catch(e) {
                                document.getElementById('ad_rail_top').style.display = 'none';
                            }
                        });
                    }
                })();
            </script>
        </div>

        <%-- Ad Slot 2: 300x600 Half Page (sticky behavior via CSS) --%>
        <div class="ad-rail-slot" id="ad_rail_bottom" style="min-height: 600px;">
            <script>
                (function() {
                    if (window.innerWidth < 1400) return;

                    if (typeof googletag !== 'undefined') {
                        googletag.cmd.push(function() {
                            try {
                                googletag.defineSlot('/147246189,22976055811/8gwifi.org_300x600_sidebar',
                                    [[300,600],[160,600],[300,250]],
                                    'ad_rail_bottom'
                                ).addService(googletag.pubads());
                                googletag.display('ad_rail_bottom');
                                if (typeof stpd !== 'undefined' && stpd.initializeAdUnit) {
                                    stpd.initializeAdUnit('ad_rail_bottom');
                                }
                            } catch(e) {
                                document.getElementById('ad_rail_bottom').style.display = 'none';
                            }
                        });
                    }
                })();
            </script>
        </div>
    </div>
</aside>
