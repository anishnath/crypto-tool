<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Shared sidebar for the Video Studio pages.

    Usage (from the parent JSP, before the include):
        request.setAttribute("activeService", "transcribe");     // or "captions", etc.
        <jsp:include page="/video/partials/sidebar.jsp" />

    Each entry is a real link, so switching tools = a normal page navigation
    (same dashboard shell, different workspace).  Items flagged "disabled"
    render greyed-out with a "Soon" badge and no href.
--%>
<%
    String activeService = (String) request.getAttribute("activeService");
    if (activeService == null) activeService = "";
    String ctx = request.getContextPath();
%>
<aside class="vs-sidebar" aria-label="Video services">
    <div class="vs-sidebar-heading">Audio &amp; Speech</div>
    <ul class="vs-sidebar-list" role="tablist">
        <li class="vs-sidebar-item <%= "transcribe".equals(activeService) ? "active" : "" %>" data-service="transcribe" role="tab">
            <a href="<%= ctx %>/video/" class="vs-sidebar-link">
                <span class="vs-sidebar-icon">&#127908;</span>
                <span class="vs-sidebar-label">Transcribe</span>
            </a>
        </li>
        <li class="vs-sidebar-item disabled" aria-disabled="true">
            <span class="vs-sidebar-icon">&#127916;</span>
            <span class="vs-sidebar-label">Dubbing</span>
            <span class="vs-sidebar-badge">Soon</span>
        </li>
        <li class="vs-sidebar-item disabled" aria-disabled="true">
            <span class="vs-sidebar-icon">&#128483;</span>
            <span class="vs-sidebar-label">Voice Clone</span>
            <span class="vs-sidebar-badge">Soon</span>
        </li>
        <li class="vs-sidebar-item disabled" aria-disabled="true">
            <span class="vs-sidebar-icon">&#128266;</span>
            <span class="vs-sidebar-label">Voice Changer</span>
            <span class="vs-sidebar-badge">Soon</span>
        </li>
    </ul>

    <div class="vs-sidebar-heading" style="margin-top:0.5rem;">Video</div>
    <ul class="vs-sidebar-list">
        <li class="vs-sidebar-item <%= "captions".equals(activeService) ? "active" : "" %>" data-service="captions" role="tab">
            <a href="<%= ctx %>/video/captions/" class="vs-sidebar-link">
                <span class="vs-sidebar-icon">&#10024;</span>
                <span class="vs-sidebar-label">Auto-Captions</span>
            </a>
        </li>
        <li class="vs-sidebar-item disabled" aria-disabled="true">
            <span class="vs-sidebar-icon">&#128196;</span>
            <span class="vs-sidebar-label">Summarize Video</span>
            <span class="vs-sidebar-badge">Soon</span>
        </li>
    </ul>
</aside>
