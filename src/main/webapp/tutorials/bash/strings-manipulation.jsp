<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings-manipulation" );
        request.setAttribute("currentModule", "Strings & Text Processing" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <!-- 1. META TAGS -->
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>String Manipulation - Bash Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Bash string manipulation techniques: substring extraction, pattern replacement, and case conversion.">
            <meta name="keywords"
                content="bash substring, bash string replace, bash string case, bash string manipulation">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="String Manipulation - Bash Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Bash string manipulation techniques: substring extraction, pattern replacement, and case conversion.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <!-- 2. RESOURCES -->
            <link rel="canonical" href="https://8gwifi.org/tutorials/bash/strings-manipulation.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <!-- 3. THEME DETECTION -->
            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>

            <!-- 4. STRUCTURED DATA -->
            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Bash String Manipulation",
        "description": "Learn how to manipulate strings in Bash: substrings, replacement, and case conversion.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Substring extraction", "String replacement", "Case conversion"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="strings-manipulation">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-bash.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <!-- 5. BREADCRUMB -->
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>String Manipulation</span>
                                </nav>

                                <!-- 6. LESSON HEADER -->
                                <header class="lesson-header">
                                    <h1 class="lesson-title">String Manipulation</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <!-- 7. LESSON BODY -->
                                <div class="lesson-body">

                                    <p class="lead">Bash provides powerful built-in capabilities for manipulating
                                        strings without needing external tools like <code>sed</code> or <code>awk</code>
                                        for simple tasks. In this lesson, we'll explore how to extract substrings,
                                        replace text patterns, and change string case directly within Bash.</p>

                                    <h2>Substring Extraction</h2>
                                    <p>You can extract a portion of a string using the syntax
                                        <code>\${string:position:length}</code>.</p>
                                    <ul>
                                        <li><code>position</code>: The starting index (0-based).</li>
                                        <li><code>length</code>: (Optional) The number of characters to extract. If
                                            omitted, extracts to the end of the string.</li>
                                    </ul>

                                    <h2>String Replacement</h2>
                                    <p>Bash allows you to replace patterns within a string using
                                        <code>\${string/pattern/replacement}</code>.</p>
                                    <ul>
                                        <li><code>\${string/pattern/replacement}</code>: Replaces the
                                            <strong>first</strong> occurrence.</li>
                                        <li><code>\${string//pattern/replacement}</code>: Replaces <strong>all</strong>
                                            occurrences.</li>
                                    </ul>

                                    <h2>Case Conversion</h2>
                                    <p>Starting from Bash 4.0, you can easily convert case using <code>^</code>
                                        (uppercase) and <code>,</code> (lowercase).</p>
                                    <ul>
                                        <li><code>\${var^^}</code>: Converts all characters to uppercase.</li>
                                        <li><code>\${var,,}</code>: Converts all characters to lowercase.</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="bash/strings-manipulation.sh" />
                                        <jsp:param name="language" value="bash" />
                                        <jsp:param name="editorId" value="compiler-strings-manipulation" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Tip:</strong> These operations are pure Bash features. They are faster
                                        than spawning external processes like <code>sed</code> or <code>cut</code>
                                        because they run inside the shell process itself.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                        <jsp:param name="responsive" value="true" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>\${var:start:len}</code> for substrings.</li>
                                            <li>Use <code>\${var/old/new}</code> for single replacement.</li>
                                            <li>Use <code>\${var//old/new}</code> for global replacement.</li>
                                            <li>Use <code>\${var^^}</code> and <code>\${var,,}</code> for case conversion.
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll dive deeper into one of Bash's most powerful features: <a
                                            href="strings-parameter-expansion.jsp">Parameter Expansion</a>, which allows
                                        for even more complex string operations.</p>

                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <!-- 8. NAVIGATION -->
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings-basics.jsp" />
                                    <jsp:param name="prevTitle" value="String Basics" />
                                    <jsp:param name="nextLink" value="strings-parameter-expansion.jsp" />
                                    <jsp:param name="nextTitle" value="Parameter Expansion" />
                                    <jsp:param name="currentLessonId" value="strings-manipulation" />
                                </jsp:include>

                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>