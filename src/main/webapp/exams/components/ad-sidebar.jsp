<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Sidebar Ad Slot (Desktop only >=992px)
    Sizes: 336x336 or 300x250

    Usage: <%@ include file="components/ad-" %>
    Place in sidebar area
--%>
<div id='exam_sidebar' class="ad-slot ad-slot-sidebar" style="min-height: 250px; margin-top: var(--space-4);">
    <script>
        (function() {
            // Only show sidebar ads on desktop
            if (window.innerWidth >= 992) {
                if (typeof googletag === 'undefined') {
                    console.debug('Google Tag Manager not loaded yet');
                    return;
                }
                
                googletag.cmd.push(function() {
                    try {
                        googletag.display('exam_sidebar');
                        // Initialize SetupAds if available
                        if (typeof stpd !== 'undefined' && typeof stpd.initializeAdUnit === 'function') {
                            stpd.initializeAdUnit('exam_sidebar');
                        } else if (typeof stpd !== 'undefined' && stpd.que) {
                            // Queue the call if SetupAds is still loading
                            stpd.que.push(function() {
                                if (typeof stpd.initializeAdUnit === 'function') {
                                    stpd.initializeAdUnit('exam_sidebar');
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
