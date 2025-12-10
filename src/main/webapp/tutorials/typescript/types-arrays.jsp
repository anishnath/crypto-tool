<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-arrays" );
        request.setAttribute("currentModule", "Getting Started & Basic Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <title>TypeScript Arrays & Tuples | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript arrays and tuples. Learn typed arrays, array methods, readonly arrays, tuple types, and destructuring with intera...">
            <meta name="keywords"
                content="typescript arrays, typescript tuples, typed arrays, array methods, readonly arrays, tuple destructuring">
            <meta property="og:type" content="article">
            <meta property="og:title" content="TypeScript Arrays & Tuples - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description" content="Learn TypeScript arrays and tuples with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/types-arrays.jsp">
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
        "name": "TypeScript Arrays & Tuples",
        "description": "Learn TypeScript arrays and tuples with type safety.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["arrays", "tuples", "array methods", "readonly arrays"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "TypeScript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
        }
    }
    </script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="types-arrays">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Arrays & Tuples</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Arrays & Tuples</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Arrays and tuples let you store collections of values with type
                                        safety. Arrays hold multiple values of the same type, while tuples hold a fixed
                                        number of values with specific types in specific positions.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-arrays-tuples.svg"
                                        alt="TypeScript Arrays vs Tuples Comparison" class="diagram-image"
                                        style="max-width: 900px; margin: 2rem auto; display: block;">

                                    <h2>Array Types</h2>
                                    <p>TypeScript provides two syntaxes for array types:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-arrays-basic.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-arrays" />
                                    </jsp:include>

                                    <h2>Array Methods</h2>
                                    <p>TypeScript arrays have all JavaScript array methods with full type safety:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-arrays-methods.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-methods" />
                                    </jsp:include>

                                    <h2>Readonly Arrays</h2>
                                    <p>Use <code>readonly</code> or <code>ReadonlyArray</code> to prevent modifications:
                                    </p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-arrays-readonly.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-readonly" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Tuples</h2>
                                    <p>Tuples are arrays with fixed length and specific types for each position:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-tuples.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-tuples" />
                                    </jsp:include>

                                    <h2>Tuple Destructuring</h2>
                                    <p>Extract tuple values into separate variables:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-tuples-destructure.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-destructure" />
                                    </jsp:include>

                                    <h2>Exercise: Shopping Cart</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a shopping cart with arrays and tuples!</p>
                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="typescript/exercises/ex-arrays.ts" />
                                            <jsp:param name="language" value="typescript" />
                                            <jsp:param name="editorId" value="exercise-arrays" />
                                        </jsp:include>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Arrays: <code>type[]</code> or <code>Array&lt;type&gt;</code></li>
                                            <li>Readonly arrays prevent modifications</li>
                                            <li>Tuples have fixed length and specific types per position</li>
                                            <li>Destructuring extracts values from tuples</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll learn about <strong>Enums</strong> - a way to define named constants!
                                    </p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-primitives.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-enums.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Primitive Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Enums →" />
                                                <jsp:param name="currentLessonId" value="types-arrays" />
                                            </jsp:include>
                                    </div>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>