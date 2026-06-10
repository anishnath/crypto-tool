<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Reusable studio shell — closer. Closes the workspace + main, drops the
    right-hand ad rail, sticky footer ad and analytics, and ends the document.
    Pair with studio-open.jsp.

    Usage:
        <%@ include file="/math/partials/studio-close.jsp" %>
--%>
    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="/modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="/modern/components/analytics.jsp" %>

</body>
</html>
