<%-- Math Editor nav: Dashboard | New Doc --%>
<nav class="me-math-nav" aria-label="Math Editor navigation">
    <a href="<%=request.getContextPath()%>/math/dashboard.jsp" class="me-math-nav-logo">
        <svg width="24" height="24" viewBox="0 0 28 28" fill="none"><rect width="28" height="28" rx="6" fill="#2563EB"/><text x="14" y="19" text-anchor="middle" fill="white" font-size="14" font-weight="bold" font-family="serif">&#x3A3;</text></svg>
        <span>Math Editor</span>
    </a>
    <div class="me-math-nav-links">
        <a href="<%=request.getContextPath()%>/math/dashboard.jsp" class="me-math-nav-link">Documents</a>
        <a href="<%=request.getContextPath()%>/math/editor.jsp" class="me-math-nav-link me-math-nav-new">+ New Doc</a>
    </div>
</nav>
