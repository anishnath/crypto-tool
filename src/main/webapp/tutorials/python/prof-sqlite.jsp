<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "prof-sqlite" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python SQLite - Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn Python SQLite. Built-in database support.">
            <meta name="keywords" content="python sqlite, sqlite3, database, sql">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python SQLite - Tutorial">
            <meta property="og:description" content="Master Python SQLite: create tables, insert, select.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/prof-sqlite.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Python SQLite",
        "description": "Learn to use Python SQLite.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="prof-sqlite">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Professional Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">SQLite Database</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Python comes with built-in support for SQLite, a lightweight
                                        disk-based database. It doesn't require a separate server process.</p>

                                    <h2>Basic Operations</h2>
                                    <p>The <code>sqlite3</code> module provides an SQL interface compliant with the
                                        DB-API 2.0 specification.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-sqlite.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-prof-sqlite" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Products Table</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a products table and insert data.</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create table <code>products</code> (id, name, price).</li>
                                            <li>Insert 'Laptop' with price 999.99.</li>
                                            <li>Select and print all products.</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-prof-sqlite.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-prof-sqlite" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">c.execute("CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price REAL)")
c.execute("INSERT INTO products (name, price) VALUES ('Laptop', 999.99)")
c.execute("SELECT * FROM products")</code></pre>
                                        </details>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

<%
    String nextLinkUrl = request.getContextPath() + "/tutorials/python/";
%>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="prof-args.jsp" />
                                    <jsp:param name="prevTitle" value="Command Line Args" />
                                    <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                    <jsp:param name="nextTitle" value="Back to Index" />
                                    <jsp:param name="currentLessonId" value="prof-sqlite" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>