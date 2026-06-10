<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Reusable studio shell — opener. Emits <body> through the open
    <section class="ms-workspace">. Pair with studio-close.jsp.

    Usage:
        <% request.setAttribute("activeService", "quick-math"); %>
        <%@ include file="/math/partials/studio-open.jsp" %>
            ... your <header class="ms-title"> + page content ...
        <%@ include file="/math/partials/studio-close.jsp" %>

    Set request attr "activeService" BEFORE this include so the sidebar
    highlights the current tool and expands its group.
--%>
<body class="ms-body">

<jsp:include page="/modern/components/nav-header.jsp" />
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">
    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">
