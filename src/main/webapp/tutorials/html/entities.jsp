<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - HTML Entities --%>
<% request.setAttribute("currentLesson", "entities"); request.setAttribute("currentModule", "Advanced Topics"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Entities - Special Characters | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to display special characters in HTML using entities like &amp;nbsp;, &amp;lt;, &amp;gt;, &amp;copy; and more.">
    <meta name="keywords" content="HTML entities, special characters HTML, nbsp, HTML symbols, character codes, HTML escape">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Entities - Special Characters">
    <meta property="og:description" content="Learn how to display special characters in HTML using entities.">
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
        "name": "HTML Entities",
        "description": "Learn how to display special characters in HTML using entities",
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
<body class="tutorial-body" data-lesson="entities">
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
                    <span>HTML Entities</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Entities</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~8 min read</span>
                    </div>
                </header>

                <%
                String reservedHtml = "<" + "p>To display a less-than sign, use: &lt;<" + "/p>\\n" +
                    "<" + "p>To display a greater-than sign, use: &gt;<" + "/p>\\n" +
                    "<" + "p>To display an ampersand, use: &amp;<" + "/p>\\n" +
                    "<" + "p>To display quotes, use: &quot; or &apos;<" + "/p>";

                String commonHtml = "<" + "p>Non-breaking space: Hello&nbsp;&nbsp;&nbsp;World<" + "/p>\\n" +
                    "<" + "p>Copyright: &copy; 2024 My Company<" + "/p>\\n" +
                    "<" + "p>Registered: Brand&reg;<" + "/p>\\n" +
                    "<" + "p>Trademark: Product&trade;<" + "/p>\\n" +
                    "<" + "p>Euro: &euro;100<" + "/p>\\n" +
                    "<" + "p>Pound: &pound;50<" + "/p>\\n" +
                    "<" + "p>Yen: &yen;1000<" + "/p>";

                String symbolsHtml = "<" + "p>Arrows: &larr; &uarr; &rarr; &darr;<" + "/p>\\n" +
                    "<" + "p>Math: &plusmn; &times; &divide; &ne; &le; &ge;<" + "/p>\\n" +
                    "<" + "p>Greek: &alpha; &beta; &gamma; &delta; &pi;<" + "/p>\\n" +
                    "<" + "p>Cards: &spades; &clubs; &hearts; &diams;<" + "/p>\\n" +
                    "<" + "p>Music: &#9834; &#9835; &#9836;<" + "/p>";
                %>

                <div class="lesson-body">
                    <h2>What are HTML Entities?</h2>
                    <p>HTML entities are special codes used to display characters that:</p>
                    <ul>
                        <li>Are reserved in HTML (like &lt; and &gt;)</li>
                        <li>Are not on your keyboard</li>
                        <li>Might not display correctly</li>
                    </ul>
                    <p>Entities start with <code>&amp;</code> and end with <code>;</code></p>

                    <h2>Reserved Characters</h2>
                    <p>These characters have special meaning in HTML and must be escaped:</p>

                    <div class="card" style="margin: var(--space-4) 0;">
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr style="background: var(--bg-secondary);">
                                <th style="padding: 10px; text-align: left;">Character</th>
                                <th style="padding: 10px; text-align: left;">Entity</th>
                                <th style="padding: 10px; text-align: left;">Description</th>
                            </tr>
                            <tr><td style="padding: 10px; border-top: 1px solid var(--border-color);">&lt;</td><td><code>&amp;lt;</code></td><td>Less than</td></tr>
                            <tr><td style="padding: 10px; border-top: 1px solid var(--border-color);">&gt;</td><td><code>&amp;gt;</code></td><td>Greater than</td></tr>
                            <tr><td style="padding: 10px; border-top: 1px solid var(--border-color);">&amp;</td><td><code>&amp;amp;</code></td><td>Ampersand</td></tr>
                            <tr><td style="padding: 10px; border-top: 1px solid var(--border-color);">"</td><td><code>&amp;quot;</code></td><td>Double quote</td></tr>
                            <tr><td style="padding: 10px; border-top: 1px solid var(--border-color);">'</td><td><code>&amp;apos;</code></td><td>Single quote</td></tr>
                        </table>
                    </div>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-reserved" />
                        <jsp:param name="initialHtml" value="<%= reservedHtml %>" />
                    </jsp:include>

                    <h2>Common Useful Entities</h2>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-common" />
                        <jsp:param name="initialHtml" value="<%= commonHtml %>" />
                    </jsp:include>

                    <h2>Symbols and Special Characters</h2>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-symbols" />
                        <jsp:param name="initialHtml" value="<%= symbolsHtml %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Numeric Codes:</strong> You can also use numeric codes: <code>&amp;#60;</code> for &lt; or <code>&amp;#x3C;</code> (hex).
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-entities" />
                        <jsp:param name="question" value="Which entity creates a non-breaking space?" />
                        <jsp:param name="option1" value="&amp;space;" />
                        <jsp:param name="option2" value="&amp;nbsp;" />
                        <jsp:param name="option3" value="&amp;sp;" />
                        <jsp:param name="option4" value="&amp;blank;" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="page-layout.jsp" />
                        <jsp:param name="prevTitle" value="Page Layout" />
                        <jsp:param name="nextLink" value="meta-seo.jsp" />
                        <jsp:param name="nextTitle" value="Meta Tags & SEO" />
                        <jsp:param name="currentLessonId" value="entities" />
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
