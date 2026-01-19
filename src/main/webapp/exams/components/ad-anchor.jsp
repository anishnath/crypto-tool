<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Anchor/Sticky Bottom Ad (Mobile only)
    Size: 320x50 or 320x100

    Usage: <%@ include file="components/ad-anchor.jsp" %>
    Place once at end of body (before closing </body>)
--%>
<div id='exam_anchor' class="ad-slot-sticky" style="display: none;">
    <button onclick="this.parentElement.style.display='none'" style="position: absolute; top: -24px; right: 8px; background: var(--bg-tertiary); border: none; border-radius: 4px 4px 0 0; padding: 2px 8px; font-size: 12px; color: var(--text-muted); cursor: pointer;">
        Close
    </button>
    <script>
        if (window.innerWidth < 992) {
            document.getElementById('exam_anchor').style.display = 'block';
            googletag.cmd.push(function() {
                googletag.display('exam_anchor');
            });
        }
    </script>
</div>
