<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Leaderboard Ad Slot (Lazy-loaded)
    Desktop: 728x90 / Mobile: 336x336

    Usage: <%@ include file="components/ad-leaderboard.jsp" %>
    Place between content sections
--%>
<div id='exam_leaderboard' class="ad-slot" style="margin: var(--space-6) auto; text-align: center; max-width: 728px;">
    <script type="text/javascript">
        (function() {
            function displayAd() {
                if (typeof googletag === 'undefined') {
                    console.debug('Google Tag Manager not loaded yet');
                    return;
                }
                
                googletag.cmd.push(function() {
                    try {
                        googletag.display('exam_leaderboard');
                        // Initialize SetupAds if available
                        if (typeof stpd !== 'undefined' && typeof stpd.initializeAdUnit === 'function') {
                            stpd.initializeAdUnit('exam_leaderboard');
                        } else if (typeof stpd !== 'undefined' && stpd.que) {
                            // Queue the call if SetupAds is still loading
                            stpd.que.push(function() {
                                if (typeof stpd.initializeAdUnit === 'function') {
                                    stpd.initializeAdUnit('exam_leaderboard');
                                }
                            });
                        }
                    } catch(e) {
                        console.debug('Ad display error (expected if ad blocker active):', e);
                    }
                });
            }
            
            // Lazy load when element enters viewport
            if (typeof inView !== 'undefined') {
                inView('#exam_leaderboard').once('enter', displayAd);
            } else {
                // Fallback: display immediately if inView not available
                displayAd();
            }
        })();
    </script>
</div>
