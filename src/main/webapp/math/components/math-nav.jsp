<%-- Math Editor nav: Dashboard | New Doc --%>
<%
    String currentURI = request.getRequestURI();
    String ctxPath = request.getContextPath();
    String dashboardPath = ctxPath + "/math/dashboard.jsp";
    String editorPath = ctxPath + "/math/editor.jsp";
    boolean isDashboard = currentURI.endsWith("/dashboard.jsp");
    boolean isEditor = currentURI.endsWith("/editor.jsp");
%>
<nav class="me-math-nav" aria-label="Math Editor navigation">
    <a href="<%=dashboardPath%>" class="me-math-nav-logo">
        <svg width="24" height="24" viewBox="0 0 28 28" fill="none"><rect width="28" height="28" rx="6" fill="#2563EB"/><text x="14" y="19" text-anchor="middle" fill="white" font-size="14" font-weight="bold" font-family="serif">&#x3A3;</text></svg>
        <span>Math Editor</span>
    </a>
    <div class="me-math-nav-links">
        <a href="<%=dashboardPath%>" class="me-math-nav-link<%= isDashboard ? " active" : "" %>"<%= isDashboard ? " aria-current=\"page\"" : "" %>>Documents</a>
        <a href="<%=editorPath%>" class="me-math-nav-link me-math-nav-new<%= (isEditor && request.getParameter("id") == null) ? " active" : "" %>"<%= (isEditor && request.getParameter("id") == null) ? " aria-current=\"page\"" : "" %>>+ New Doc</a>
    </div>
</nav>
