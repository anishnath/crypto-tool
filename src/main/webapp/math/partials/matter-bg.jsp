<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Decorative physics backdrop for math pages.

    Usage (from any math tool page):
        <jsp:include page="/math/partials/matter-bg.jsp" />

    Place this include anywhere inside <body> but BEFORE <main class="ms-main">,
    so the canvas sits behind the three-column grid.  The host div is
    positioned `absolute` inside the page (body / its own wrapper), and the
    CSS in math-studio.css fades it out toward the bottom so content further
    down the page sits on the plain page background.

    Requirements:
      · body must have class "ms-body" (provides position:relative + padding-top
        for the fixed nav)
      · math-studio.css loaded
      · Matter.js CDN + math-matter-bg.js script are included here — NO need
        to add them separately in the parent page.

    Skips when the user has `prefers-reduced-motion: reduce` set.
--%>
<div id="math-matter-host" class="ms-matter-host" aria-hidden="true"></div>

<script defer src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js"
        crossorigin="anonymous"></script>
<script defer src="<%=request.getContextPath()%>/math/js/math-matter-bg.js"></script>
