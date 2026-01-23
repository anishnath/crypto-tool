<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Left Sidebar Ad Slot (Large Desktop only >=1400px)
    Sizes: 160x600 (Skyscraper) or 120x600

    Usage: <%@ include file="components/ad-sidebar-left.jsp" %>
    Place in left sidebar area
--%>
<div id='exam_sidebar_left' class="ad-slot ad-slot-sidebar-left" style="min-height: 600px; width: 160px;">
    <script>
        (function() {
            // Only show left sidebar ads on large desktop
            if (window.innerWidth >= 1400) {
                if (typeof googletag === 'undefined') {
                    console.debug('Google Tag Manager not loaded yet');
                    return;
                }

                googletag.cmd.push(function() {
                    try {
                        googletag.display('exam_sidebar_left');
                        // Initialize SetupAds if available
                        if (typeof stpd !== 'undefined' && typeof stpd.initializeAdUnit === 'function') {
                            stpd.initializeAdUnit('exam_sidebar_left');
                        } else if (typeof stpd !== 'undefined' && stpd.que) {
                            stpd.que.push(function() {
                                if (typeof stpd.initializeAdUnit === 'function') {
                                    stpd.initializeAdUnit('exam_sidebar_left');
                                }
                            });
                        }
                    } catch(e) {
                        console.debug('Ad display error (expected if ad blocker active):', e);
                    }
                });
            }
        })();
    </script>
</div>
