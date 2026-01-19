<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Leaderboard Ad Slot (Lazy-loaded)
    Desktop: 728x90 / Mobile: 336x336

    Usage: <%@ include file="components/ad-leaderboard.jsp" %>
    Place between content sections
--%>
<div id='exam_leaderboard' class="ad-slot" style="margin: var(--space-6) auto; text-align: center; max-width: 728px;">
    <script type="text/javascript">
        if (typeof inView !== 'undefined') {
            inView('#exam_leaderboard').once('enter', (function() {
                googletag.cmd.push(function() {
                    googletag.display('exam_leaderboard');
                    if (typeof stpd !== 'undefined') {
                        stpd.initializeAdUnit('exam_leaderboard');
                    }
                });
            }));
        } else {
            googletag.cmd.push(function() {
                googletag.display('exam_leaderboard');
            });
        }
    </script>
</div>
