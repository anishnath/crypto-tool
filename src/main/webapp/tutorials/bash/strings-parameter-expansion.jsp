<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings-parameter-expansion" );
        request.setAttribute("currentModule", "Strings & Text Processing" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <!-- 1. META TAGS -->
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Parameter Expansion - Bash Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn advanced Bash parameter expansion techniques for string manipulation, pattern matching, and default value assignment.">
            <meta name="keywords"
                content="bash parameter expansion, bash string removal, bash default values, bash variable manipulation">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Parameter Expansion - Bash Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Learn advanced Bash parameter expansion techniques for string manipulation, pattern matching, and default value assignment.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <!-- 2. RESOURCES -->
            <link rel="canonical" href="https://8gwifi.org/tutorials/bash/strings-parameter-expansion.jsp">
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
        "name": "Bash Parameter Expansion",
        "description": "Learn advanced Bash parameter expansion techniques.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Parameter expansion", "Pattern matching", "Default values"],
        "timeRequired": "PT25M",
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

        <body class="tutorial-body no-preview" data-lesson="strings-parameter-expansion">
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
                                    <span>Parameter Expansion</span>
                                </nav>

                                <!-- 6. LESSON HEADER -->
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Parameter Expansion</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <!-- 7. LESSON BODY -->
                                <div class="lesson-body">

                                    <p class="lead">Parameter expansion is one of the most powerful features in Bash. It
                                        allows you to transform the value of a variable at the time it is expanded. This
                                        is incredibly useful for file path manipulation, setting default values, and
                                        cleaning up data.</p>

                                    <h2>Removing Patterns</h2>
                                    <p>You can remove parts of a string that match a specific pattern. This is often
                                        used for file extensions or directory paths.</p>

                                    <table class="tutorial-table">
                                        <thead>
                                            <tr>
                                                <th>Syntax</th>
                                                <th>Description</th>
                                                <th>Mnemonic</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>\${var#pattern}</code></td>
                                                <td>Remove <strong>shortest</strong> match from
                                                    <strong>beginning</strong></td>
                                                <td># is on the left of $ on US keyboards</td>
                                            </tr>
                                            <tr>
                                                <td><code>\${var##pattern}</code></td>
                                                <td>Remove <strong>longest</strong> match from
                                                    <strong>beginning</strong></td>
                                                <td>Double # means "more" removal</td>
                                            </tr>
                                            <tr>
                                                <td><code>\${var%pattern}</code></td>
                                                <td>Remove <strong>shortest</strong> match from <strong>end</strong>
                                                </td>
                                                <td>% is on the right of $ on US keyboards</td>
                                            </tr>
                                            <tr>
                                                <td><code>\${var%%pattern}</code></td>
                                                <td>Remove <strong>longest</strong> match from <strong>end</strong></td>
                                                <td>Double % means "more" removal</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Default Values</h2>
                                    <p>Bash allows you to provide default values if a variable is unset or empty.</p>
                                    <ul>
                                        <li><code>\${var:-default}</code>: Use <code>default</code> if <code>var</code>
                                            is unset or empty. <code>var</code> remains unchanged.</li>
                                        <li><code>\${var:=default}</code>: Set <code>var</code> to <code>default</code>
                                            if it is unset or empty.</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="bash/strings-parameter-expansion.sh" />
                                        <jsp:param name="language" value="bash" />
                                        <jsp:param name="editorId" value="compiler-strings-parameter-expansion" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Tip:</strong> The pattern matching used here uses "glob" patterns (like
                                        <code>*</code> and <code>?</code>), not regular expressions.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                        <jsp:param name="responsive" value="true" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>#</code> and <code>##</code> to strip from the
                                                <strong>start</strong>.</li>
                                            <li>Use <code>%</code> and <code>%%</code> to strip from the
                                                <strong>end</strong>.</li>
                                            <li>Use <code>:-</code> to provide a fallback value without setting the
                                                variable.</li>
                                            <li>Use <code>:=</code> to set a default value if the variable is missing.
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>In the final lesson of this module, we'll look at <a
                                            href="strings-heredoc.jsp">Here Documents</a>, a convenient way to handle
                                        multi-line text blocks in your scripts.</p>

                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <!-- 8. NAVIGATION -->
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings-manipulation.jsp" />
                                    <jsp:param name="prevTitle" value="String Manipulation" />
                                    <jsp:param name="nextLink" value="strings-heredoc.jsp" />
                                    <jsp:param name="nextTitle" value="Here Documents" />
                                    <jsp:param name="currentLessonId" value="strings-parameter-expansion" />
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