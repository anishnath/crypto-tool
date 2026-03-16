<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis());
   HttpSession dashSession = request.getSession(false);
   String dashUserSub = dashSession != null ? (String) dashSession.getAttribute("oauth_user_sub") : null;
   String dashUserEmail = dashSession != null ? (String) dashSession.getAttribute("oauth_user_email") : null;
   boolean dashLoggedIn = (dashUserSub != null && !dashUserSub.isEmpty()) || (dashUserEmail != null && !dashUserEmail.isEmpty());
   String dashRedirectPath = "/math/dashboard.jsp";
   String dashLoginUrl = request.getContextPath() + "/GoogleOAuthFunctionality?action=login&redirect_path=" + java.net.URLEncoder.encode(dashRedirectPath, "UTF-8");
   String dashLogoutUrl = request.getContextPath() + "/GoogleOAuthFunctionality?action=logout&redirect_path=" + java.net.URLEncoder.encode(dashRedirectPath, "UTF-8");
   String dashUserInitials = "?";
   if (dashUserEmail != null && !dashUserEmail.isEmpty()) {
     String pre = dashUserEmail.split("@")[0];
     dashUserInitials = pre.length() >= 2 ? pre.substring(0, 2).toUpperCase() : pre.toUpperCase();
   } else if (dashUserSub != null && dashUserSub.length() >= 2) {
     dashUserInitials = dashUserSub.substring(0, 2).toUpperCase();
   }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- SEO Component -->
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="My Documents - Math Editor Dashboard" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Manage your math documents. Create, organize, share and collaborate on mathematical documents with the free online math editor." />
        <jsp:param name="toolUrl" value="math/dashboard.jsp" />
        <jsp:param name="toolKeywords" value="math editor dashboard, math documents, manage equations, collaborative math, document management" />
        <jsp:param name="toolImage" value="math-dashboard.svg" />
        <jsp:param name="toolFeatures" value="Document management,Real-time collaboration,Share documents,Export to PDF Word LaTeX,Star and organize,Version history" />
    </jsp:include>

    <!-- LCP: Preconnect for fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Site-wide CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%= cacheVersion %>">

    <!-- Ad Initialization -->
    <%@ include file="../modern/ads/ad-init.jsp" %>

    <!-- Math Editor CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/assets/css/main.css?v=<%= cacheVersion %>">
</head>
<body>

<!-- Site Navigation -->
<jsp:include page="../modern/components/nav-header.jsp" />

<div class="math-editor-app">

    <jsp:include page="components/math-nav.jsp" />

    <!-- Hero Banner Ad -->
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>

    <!-- ============================
         DASHBOARD TOP BAR
         ============================ -->
    <div class="me-dash-topbar">
        <div class="me-dash-left">
            <a href="<%=request.getContextPath()%>/math/dashboard.jsp" class="me-dash-logo">
                <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                    <rect width="28" height="28" rx="6" fill="#2563EB"/>
                    <text x="14" y="19" text-anchor="middle" fill="white" font-size="14" font-weight="bold" font-family="serif">&#x3A3;</text>
                </svg>
                Math Editor
            </a>
            <a href="<%=request.getContextPath()%>/math/editor.jsp" class="me-btn-new-doc" id="me-btn-new-doc">
                <span>+</span> New Document
            </a>
            <% if (dashLoggedIn) { %>
            <a href="<%= dashLogoutUrl %>" class="me-btn-login" title="Logout">Logout</a>
            <div class="me-avatar" title="<%= dashUserEmail != null ? dashUserEmail : "User" %>"><%= dashUserInitials %></div>
            <% } else { %>
            <a href="<%= dashLoginUrl %>" class="me-btn-login" title="Login with Google">Login</a>
            <% } %>
        </div>
        <div class="me-dash-search">
            <span class="me-dash-search-icon">&#x1F50D;</span>
            <input type="search" placeholder="Search documents...">
        </div>
    </div>

    <!-- ============================
         DASHBOARD BODY
         ============================ -->
    <div class="me-dashboard">

        <!-- Sidebar -->
        <aside class="me-sidebar">
            <a class="me-sidebar-item active" href="#">
                <span class="me-sidebar-item-icon">&#x1F4C4;</span>
                My Documents
            </a>
            <a class="me-sidebar-item" href="#">
                <span class="me-sidebar-item-icon">&#x1F552;</span>
                Recent
            </a>

            <div class="me-sidebar-divider"></div>

        </aside>

        <!-- Main Content -->
        <main class="me-dash-main">
            <div class="me-dash-main-header">
                <h2 id="me-dash-title">Documents</h2>
                <div class="me-view-toggle">
                    <button class="active" title="Grid view">&#x25A6;</button>
                    <button title="List view">&#x2630;</button>
                </div>
            </div>

            <!-- Document Grid (loaded via API) -->
            <div class="me-doc-grid" id="me-doc-grid">
                <div class="me-doc-loading" id="me-doc-loading">Loading...</div>
            </div>
        </main>
    </div>

</div>

<!-- Right Sidebar Ad (desktop > 1300px) -->
<%@ include file="../modern/ads/ad-right-sidebar.jsp" %>

<!-- Sticky Footer Ad -->
<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>

<script>window.ME_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/math/assets/js/math-api.js?v=<%= cacheVersion %>"></script>
<script>
(function(){
  var grid = document.getElementById('me-doc-grid');
  var loading = document.getElementById('me-doc-loading');
  if (!grid || !window.MathAPI) return;

  function renderDocs(docs, editorBase, isMyDocs) {
    if (!docs || docs.length === 0) {
      var msg = isMyDocs ? 'No documents yet.' : 'No shared documents yet.';
      grid.innerHTML = '<div class="me-doc-empty"><p>' + msg + '</p><a href="' + (editorBase || '') + '/math/editor.jsp" class="me-btn me-btn-primary">Start writing</a></div>';
      return;
    }
    var html = '';
    docs.forEach(function(doc) {
      var href = (editorBase || '') + '/math/editor.jsp?id=' + encodeURIComponent(doc.id);
      var title = (doc.title || 'Untitled').replace(/</g, '&lt;');
      var d = doc.updated_at || doc.created_at || '';
      try { d = d ? new Date(d).toLocaleDateString() : ''; } catch (e) { d = ''; }
      html += '<a href="' + href + '" class="me-doc-card">' +
        '<div class="me-doc-card-preview"><div><div style="font-weight:600;font-size:13px;margin-bottom:4px;color:#0F172A;">' + title + '</div><div style="font-size:11px;color:#64748B;">' + (doc.doc_type || 'math') + '</div></div></div>' +
        '<div class="me-doc-card-title">' + title + '</div>' +
        '<div class="me-doc-card-meta"><span class="me-doc-card-date">' + (d ? 'Edited ' + d : '') + '</span></div>' +
        '</a>';
    });
    grid.innerHTML = html;
  }

  MathAPI.checkSession().then(function(session) {
    loading.style.display = 'none';
    var opts = { limit: 50, sort: 'updated_at' };
    var isLoggedIn = session && session.logged_in && (session.user_id || session.user_sub);
    if (isLoggedIn) {
      opts.user_id = session.user_id || session.user_sub;
    }
    var titleEl = document.getElementById('me-dash-title');
    if (titleEl) titleEl.textContent = isLoggedIn ? 'My Documents' : 'Shared Documents';
    return MathAPI.list(opts).then(function(r) {
      if (!r.ok) {
        grid.innerHTML = '<div class="me-doc-empty"><p>Unable to load documents.</p></div>';
        return;
      }
      return r.json().then(function(data) {
        renderDocs(data.documents || [], window.ME_CTX || '', isLoggedIn);
      });
    });
  }).catch(function() {
    loading.style.display = 'none';
    var titleEl = document.getElementById('me-dash-title');
    if (titleEl) titleEl.textContent = 'Documents';
    grid.innerHTML = '<div class="me-doc-empty"><p>Unable to load documents.</p></div>';
  });
})();
</script>

<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
