<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Form Attributes --%>
<% request.setAttribute("currentLesson", "form-attributes"); request.setAttribute("currentModule", "Forms"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Form Attributes - Action, Method & More | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn about HTML form attributes including action, method, enctype, target, and how forms submit data to servers.">
    <meta name="keywords" content="HTML form action, form method GET POST, enctype multipart, HTML form attributes, form submit">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Form Attributes - Action, Method & More">
    <meta property="og:description" content="Learn about HTML form attributes including action, method, and enctype.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <%-- Favicon --%>
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
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

    <%-- JSON-LD --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "HTML Form Attributes",
        "description": "Learn about HTML form attributes including action, method, enctype, and target",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "isPartOf": {
            "@type": "Course",
            "name": "HTML Tutorial",
            "url": "https://8gwifi.org/tutorials/html/"
        }
    }
    </script>
    <%-- Analytics & Ads --%>
    <%@ include file="../tutorial-analytics.jsp" %>
    <%@ include file="../tutorial-ads.jsp" %>
</head>
<body class="tutorial-body" data-lesson="form-attributes">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/html/">HTML</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Form Attributes</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Form Attributes</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~10 min read</span>
                    </div>
                </header>

                <%
                String formAction = "<" + "form action=\"/submit\" method=\"post\">\\n" +
                    "  <" + "input type=\"text\" name=\"username\">\\n" +
                    "  <" + "button type=\"submit\">Submit<" + "/button>\\n" +
                    "<" + "/form>";

                String formMethods = "<" + "!-- GET: Data visible in URL -->\\n" +
                    "<" + "form action=\"/search\" method=\"get\">\\n" +
                    "  <" + "input type=\"text\" name=\"q\" placeholder=\"Search...\">\\n" +
                    "  <" + "button type=\"submit\">Search<" + "/button>\\n" +
                    "<" + "/form>\\n\\n" +
                    "<" + "!-- POST: Data hidden in request body -->\\n" +
                    "<" + "form action=\"/login\" method=\"post\">\\n" +
                    "  <" + "input type=\"password\" name=\"pass\">\\n" +
                    "  <" + "button type=\"submit\">Login<" + "/button>\\n" +
                    "<" + "/form>";

                String formEnctype = "<" + "!-- For file uploads -->\\n" +
                    "<" + "form action=\"/upload\"\\n" +
                    "      method=\"post\"\\n" +
                    "      enctype=\"multipart/form-data\">\\n" +
                    "  <" + "input type=\"file\" name=\"photo\">\\n" +
                    "  <" + "button type=\"submit\">Upload<" + "/button>\\n" +
                    "<" + "/form>";
                %>

                <div class="lesson-body">
                    <h2>The Action Attribute</h2>
                    <p>The <code>action</code> attribute specifies where to send the form data when submitted. It usually points to a server-side script.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-action" />
                        <jsp:param name="initialHtml" value="<%= formAction %>" />
                    </jsp:include>

                    <h2>The Method Attribute</h2>
                    <p>The <code>method</code> attribute specifies how to send form data:</p>
                    <ul>
                        <li><code>GET</code> - Appends data to URL (visible, bookmarkable, limited size)</li>
                        <li><code>POST</code> - Sends data in request body (hidden, no size limit)</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-method" />
                        <jsp:param name="initialHtml" value="<%= formMethods %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Best Practice:</strong> Use GET for searches and filters. Use POST for sensitive data like passwords or when modifying data.
                        </div>
                    </div>

                    <h2>The Enctype Attribute</h2>
                    <p>The <code>enctype</code> specifies how form data should be encoded. It's required for file uploads:</p>
                    <ul>
                        <li><code>application/x-www-form-urlencoded</code> - Default, encodes all characters</li>
                        <li><code>multipart/form-data</code> - Required for file uploads</li>
                        <li><code>text/plain</code> - Sends data without encoding (not recommended)</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-enctype" />
                        <jsp:param name="initialHtml" value="<%= formEnctype %>" />
                    </jsp:include>

                    <h2>Other Form Attributes</h2>
                    <ul>
                        <li><code>target</code> - Where to display response (_self, _blank, _parent, _top)</li>
                        <li><code>autocomplete</code> - Enable/disable browser autocomplete (on/off)</li>
                        <li><code>novalidate</code> - Disable browser validation</li>
                        <li><code>name</code> - Name for the form (used in JavaScript)</li>
                    </ul>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-form-attrs" />
                        <jsp:param name="question" value="Which enctype is required for file uploads?" />
                        <jsp:param name="option1" value="application/x-www-form-urlencoded" />
                        <jsp:param name="option2" value="multipart/form-data" />
                        <jsp:param name="option3" value="text/plain" />
                        <jsp:param name="option4" value="application/json" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="input-types.jsp" />
                        <jsp:param name="prevTitle" value="Input Types" />
                        <jsp:param name="nextLink" value="form-validation.jsp" />
                        <jsp:param name="nextTitle" value="Form Validation" />
                        <jsp:param name="currentLessonId" value="form-attributes" />
                    </jsp:include>
                </div>
            </article>

            <aside class="tutorial-preview" id="previewPanel">
                <div class="preview-header">
                    <span>Live Preview</span>
                    <button class="btn btn-ghost btn-icon" onclick="refreshPreview()" title="Refresh">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M23 4v6h-6M1 20v-6h6" />
                            <path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" />
                        </svg>
                    </button>
                </div>
                <iframe id="previewFrame" class="preview-frame" sandbox="allow-scripts allow-same-origin"></iframe>
            </aside>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
