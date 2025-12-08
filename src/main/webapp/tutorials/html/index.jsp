<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    HTML Tutorial - Landing Page
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HTML Tutorial - Learn HTML from Scratch | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn HTML from scratch with interactive examples. Free HTML tutorial for beginners with live code editor and instant preview.">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">

    <script>
        (function() {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>
<%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>
<body class="tutorial-body">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content" style="margin-right: 0;">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>HTML</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Tutorial</h1>
                    <p style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                        Learn HTML from scratch with interactive examples. Master the foundation of web development.
                    </p>
                </header>

                <div class="lesson-body">
                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                        <%-- Start Learning Card --%>
                        <a href="<%=request.getContextPath()%>/tutorials/html/introduction.jsp" class="card" style="text-decoration: none; display: flex; align-items: center; gap: var(--space-4);">
                            <div style="width: 48px; height: 48px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2">
                                    <polygon points="5 3 19 12 5 21 5 3"/>
                                </svg>
                            </div>
                            <div>
                                <h3 style="margin: 0; font-size: var(--text-lg); color: var(--text-primary);">Start Learning</h3>
                                <p style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">Begin with HTML Introduction</p>
                            </div>
                            <svg style="margin-left: auto;" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                                <polyline points="9 18 15 12 9 6"/>
                            </svg>
                        </a>

                        <%-- What You'll Learn --%>
                        <div class="card">
                            <h3 style="margin: 0 0 var(--space-4) 0;">What You'll Learn</h3>
                            <ul style="margin: 0; padding-left: var(--space-6); color: var(--text-secondary);">
                                <li>HTML document structure and syntax</li>
                                <li>Text formatting and headings</li>
                                <li>Links, images, and media</li>
                                <li>Lists, tables, and forms</li>
                                <li>Semantic HTML5 elements</li>
                                <li>Best practices and accessibility</li>
                            </ul>
                        </div>

                        <%-- Course Info --%>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">15</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Lessons</div>
                            </div>
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">~2h</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Duration</div>
                            </div>
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--success);">Free</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Forever</div>
                            </div>
                        </div>
                    </div>
                </div>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
