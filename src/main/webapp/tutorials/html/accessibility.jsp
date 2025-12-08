<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Accessibility --%>
<% request.setAttribute("currentLesson", "accessibility"); request.setAttribute("currentModule", "Advanced Topics"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Accessibility - ARIA & Best Practices | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to make your HTML accessible to all users, including those using screen readers, with proper semantic HTML and ARIA attributes.">
    <meta name="keywords" content="HTML accessibility, ARIA attributes, screen reader, web accessibility, a11y, accessible HTML">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Accessibility - ARIA & Best Practices">
    <meta property="og:description" content="Learn how to make your HTML accessible to all users with ARIA and semantic HTML.">
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
        "name": "HTML Accessibility",
        "description": "Learn how to make your HTML accessible to all users with ARIA and semantic HTML",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
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
<body class="tutorial-body" data-lesson="accessibility">
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
                    <span>Accessibility</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Accessibility</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~12 min read</span>
                    </div>
                </header>

                <%
                String altHtml = "<" + "!-- Good: Descriptive alt text -->\\n" +
                    "<" + "img src=\"dog.jpg\" alt=\"Golden retriever playing fetch in a park\">\\n\\n" +
                    "<" + "!-- Bad: Non-descriptive -->\\n" +
                    "<" + "img src=\"dog.jpg\" alt=\"image\">\\n\\n" +
                    "<" + "!-- Decorative images: Empty alt -->\\n" +
                    "<" + "img src=\"decoration.jpg\" alt=\"\">";

                String labelHtml = "<" + "form>\\n" +
                    "  <" + "!-- Good: Label with for attribute -->\\n" +
                    "  <" + "label for=\"email\">Email Address:<" + "/label>\\n" +
                    "  <" + "input type=\"email\" id=\"email\" name=\"email\">\\n" +
                    "  \\n" +
                    "  <" + "!-- Also Good: Wrapped label -->\\n" +
                    "  <" + "label>\\n" +
                    "    Phone Number:\\n" +
                    "    <" + "input type=\"tel\" name=\"phone\">\\n" +
                    "  <" + "/label>\\n" +
                    "<" + "/form>";

                String ariaHtml = "<" + "!-- Navigation landmark -->\\n" +
                    "<" + "nav aria-label=\"Main navigation\">\\n" +
                    "  <" + "a href=\"/\">Home<" + "/a>\\n" +
                    "  <" + "a href=\"/about\">About<" + "/a>\\n" +
                    "<" + "/nav>\\n\\n" +
                    "<" + "!-- Button with description -->\\n" +
                    "<" + "button aria-label=\"Close dialog\">\\n" +
                    "  X\\n" +
                    "<" + "/button>\\n\\n" +
                    "<" + "!-- Live region for updates -->\\n" +
                    "<" + "div aria-live=\"polite\" id=\"status\">\\n" +
                    "  Form submitted successfully!\\n" +
                    "<" + "/div>";

                String skipHtml = "<" + "!-- Skip to main content link -->\\n" +
                    "<" + "a href=\"#main-content\" class=\"skip-link\">\\n" +
                    "  Skip to main content\\n" +
                    "<" + "/a>\\n\\n" +
                    "<" + "header>Navigation here...<" + "/header>\\n\\n" +
                    "<" + "main id=\"main-content\">\\n" +
                    "  <" + "h1>Page Content<" + "/h1>\\n" +
                    "  <" + "p>Main content starts here.<" + "/p>\\n" +
                    "<" + "/main>";
                %>

                <div class="lesson-body">
                    <h2>Why Accessibility Matters</h2>
                    <p>Web accessibility ensures that websites are usable by everyone, including people with:</p>
                    <ul>
                        <li>Visual impairments (blindness, low vision, color blindness)</li>
                        <li>Hearing impairments</li>
                        <li>Motor impairments</li>
                        <li>Cognitive disabilities</li>
                    </ul>

                    <h2>Image Alt Text</h2>
                    <p>The <code>alt</code> attribute is read by screen readers and shown when images fail to load:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-alt" />
                        <jsp:param name="initialHtml" value="<%= altHtml %>" />
                    </jsp:include>

                    <h2>Form Labels</h2>
                    <p>Every form input needs an associated label for screen reader users:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-label" />
                        <jsp:param name="initialHtml" value="<%= labelHtml %>" />
                    </jsp:include>

                    <h2>ARIA Attributes</h2>
                    <p>ARIA (Accessible Rich Internet Applications) provides extra information to assistive technologies:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-aria" />
                        <jsp:param name="initialHtml" value="<%= ariaHtml %>" />
                    </jsp:include>

                    <h2>Skip Links</h2>
                    <p>Allow keyboard users to skip repetitive navigation:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-skip" />
                        <jsp:param name="initialHtml" value="<%= skipHtml %>" />
                    </jsp:include>

                    <h2>Accessibility Checklist</h2>
                    <div class="card" style="margin: var(--space-4) 0;">
                        <ul style="margin: 0; padding-left: var(--space-6);">
                            <li>Use semantic HTML elements</li>
                            <li>Add alt text to all meaningful images</li>
                            <li>Label all form inputs</li>
                            <li>Ensure sufficient color contrast</li>
                            <li>Make all functionality keyboard accessible</li>
                            <li>Use proper heading hierarchy</li>
                            <li>Provide skip navigation links</li>
                            <li>Don't rely on color alone to convey information</li>
                        </ul>
                    </div>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Testing Tip:</strong> Try navigating your site using only the keyboard (Tab, Enter, Arrow keys) to test accessibility.
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-a11y" />
                        <jsp:param name="question" value="What should you put in the alt attribute for decorative images?" />
                        <jsp:param name="option1" value="The word 'decorative'" />
                        <jsp:param name="option2" value="Empty string (alt='')" />
                        <jsp:param name="option3" value="The filename" />
                        <jsp:param name="option4" value="Nothing, remove alt entirely" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="meta-seo.jsp" />
                        <jsp:param name="prevTitle" value="Meta Tags & SEO" />
                        <jsp:param name="nextLink" value="" />
                        <jsp:param name="nextTitle" value="" />
                        <jsp:param name="currentLessonId" value="accessibility" />
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
