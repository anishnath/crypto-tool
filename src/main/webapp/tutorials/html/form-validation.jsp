<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Form Validation --%>
<% request.setAttribute("currentLesson", "form-validation"); request.setAttribute("currentModule", "Forms"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Form Validation - Required, Pattern & More | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn HTML5 form validation using required, pattern, min, max, and other validation attributes for better user experience.">
    <meta name="keywords" content="HTML form validation, required attribute, pattern regex HTML, min max validation, HTML5 validation">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Form Validation - Required, Pattern & More">
    <meta property="og:description" content="Learn HTML5 form validation using required, pattern, min, max attributes.">
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
        "name": "HTML Form Validation",
        "description": "Learn HTML5 form validation using required, pattern, min, max attributes",
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
<body class="tutorial-body" data-lesson="form-validation">
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
                    <span>Form Validation</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Form Validation</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~10 min read</span>
                    </div>
                </header>

                <%
                String requiredHtml = "<" + "form>\\n" +
                    "  <" + "label>Username (required):<" + "/label><" + "br>\\n" +
                    "  <" + "input type=\"text\" name=\"user\" required><" + "br><" + "br>\\n" +
                    "  <" + "label>Email (required):<" + "/label><" + "br>\\n" +
                    "  <" + "input type=\"email\" name=\"email\" required><" + "br><" + "br>\\n" +
                    "  <" + "button type=\"submit\">Submit<" + "/button>\\n" +
                    "<" + "/form>";

                String patternHtml = "<" + "form>\\n" +
                    "  <" + "label>Phone (format: 123-456-7890):<" + "/label><" + "br>\\n" +
                    "  <" + "input type=\"tel\"\\n" +
                    "         pattern=\"[0-9]{3}-[0-9]{3}-[0-9]{4}\"\\n" +
                    "         placeholder=\"123-456-7890\"\\n" +
                    "         title=\"Format: 123-456-7890\"><" + "br><" + "br>\\n" +
                    "  <" + "button type=\"submit\">Submit<" + "/button>\\n" +
                    "<" + "/form>";

                String minmaxHtml = "<" + "form>\\n" +
                    "  <" + "label>Age (18-100):<" + "/label><" + "br>\\n" +
                    "  <" + "input type=\"number\" min=\"18\" max=\"100\"><" + "br><" + "br>\\n" +
                    "  <" + "label>Password (8-20 chars):<" + "/label><" + "br>\\n" +
                    "  <" + "input type=\"password\" minlength=\"8\" maxlength=\"20\"><" + "br><" + "br>\\n" +
                    "  <" + "button type=\"submit\">Submit<" + "/button>\\n" +
                    "<" + "/form>";
                %>

                <div class="lesson-body">
                    <h2>HTML5 Form Validation</h2>
                    <p>HTML5 provides built-in form validation without JavaScript. The browser automatically validates input before submission.</p>

                    <h2>The Required Attribute</h2>
                    <p>The <code>required</code> attribute makes a field mandatory. The form won't submit until it's filled.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-required" />
                        <jsp:param name="initialHtml" value="<%= requiredHtml %>" />
                    </jsp:include>

                    <h2>The Pattern Attribute</h2>
                    <p>The <code>pattern</code> attribute specifies a regular expression that the input must match.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-pattern" />
                        <jsp:param name="initialHtml" value="<%= patternHtml %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Tip:</strong> Use the <code>title</code> attribute to explain the expected format to users.
                        </div>
                    </div>

                    <h2>Min, Max, and Length</h2>
                    <ul>
                        <li><code>min</code> / <code>max</code> - For numbers and dates</li>
                        <li><code>minlength</code> / <code>maxlength</code> - For text length</li>
                        <li><code>step</code> - Specifies valid number intervals</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-minmax" />
                        <jsp:param name="initialHtml" value="<%= minmaxHtml %>" />
                    </jsp:include>

                    <h2>Other Validation Attributes</h2>
                    <ul>
                        <li><code>type="email"</code> - Validates email format</li>
                        <li><code>type="url"</code> - Validates URL format</li>
                        <li><code>type="number"</code> - Only accepts numbers</li>
                        <li><code>readonly</code> - Field cannot be modified</li>
                        <li><code>disabled</code> - Field is disabled and not submitted</li>
                    </ul>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-validation" />
                        <jsp:param name="question" value="Which attribute uses regular expressions for validation?" />
                        <jsp:param name="option1" value="required" />
                        <jsp:param name="option2" value="pattern" />
                        <jsp:param name="option3" value="validate" />
                        <jsp:param name="option4" value="regex" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="form-attributes.jsp" />
                        <jsp:param name="prevTitle" value="Form Attributes" />
                        <jsp:param name="nextLink" value="block-inline.jsp" />
                        <jsp:param name="nextTitle" value="Block vs Inline" />
                        <jsp:param name="currentLessonId" value="form-validation" />
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
