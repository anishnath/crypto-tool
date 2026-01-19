<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Sidebar Ad Slot (Desktop only >=992px)
    Sizes: 336x336 or 300x250

    Usage: <%@ include file="components/ad-sidebar.jsp" %>
    Place in sidebar area
--%>
<div id='exam_sidebar' class="ad-slot ad-slot-sidebar" style="min-height: 250px; margin-top: var(--space-4);">
    <script>
        if (window.innerWidth >= 992) {
            googletag.cmd.push(function() {
                googletag.display('exam_sidebar');
                if (typeof stpd !== 'undefined') {
                    stpd.initializeAdUnit('exam_sidebar');
                }
            });
        }
    </script>
</div>
