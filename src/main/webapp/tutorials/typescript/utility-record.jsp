<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "utility-record" );
        request.setAttribute("currentModule", "Generics & Utility Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Record & Readonly | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript Record and Readonly utility types for object creation and immutability.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/utility-record.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })()</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "TypeScript Record & Readonly",
        "description": "Learn Record and Readonly utilities for typed maps and immutability.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "timeRequired": "PT20M",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "isPartOf": {
            "@type": "Course",
            "name": "TypeScript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2025-12-10",
        "dateModified": "2025-12-10"
    }
    </script>
        </head>

        <body class="tutorial-body no-preview" data-lesson="utility-record">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb"><a
                                        href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span
                                        class="breadcrumb-separator">/</span><a
                                        href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a><span
                                        class="breadcrumb-separator">/</span><span>Record & Readonly</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Record & Readonly</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Record creates object types with specific keys and values, while
                                        Readonly makes all properties immutable.</p>

                                    <h2>Record & Readonly Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/utility-record.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-record" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Utility Types:</strong>
                                        <ul>
                                            <li><code>Record&lt;K, T&gt;</code> - Create object with keys K and values T
                                            </li>
                                            <li><code>Readonly&lt;T&gt;</code> - Make all properties read-only</li>
                                        </ul>
                                    </div>

                                    <h2>When to Use</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Utility</th>
                                                <th>Use Case</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Record</td>
                                                <td>Maps, dictionaries</td>
                                                <td><code>Record&lt;string, number&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td>Readonly</td>
                                                <td>Immutable config</td>
                                                <td><code>Readonly&lt;Config&gt;</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Readonly is Shallow</h4>
                                        <pre><code class="language-typescript">interface User {
    settings: { theme: string };
}

type ReadonlyUser = Readonly<User>;

let user: ReadonlyUser = { settings: { theme: "dark" } };
// user.settings = {};  // ✗ Error - readonly
user.settings.theme = "light";  // ✓ OK - nested not readonly!</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use <code>Record</code> for
                                        maps/dictionaries, <code>Readonly</code> for configuration objects.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>Record&lt;K, T&gt;</code> creates typed object maps</li>
                                            <li><code>Readonly&lt;T&gt;</code> makes properties immutable</li>
                                            <li>Perfect for dictionaries and config</li>
                                            <li>Readonly is shallow - doesn't affect nested objects</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! Module 5 complete. Next: <strong>Type Manipulation</strong>!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/utility-pick.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/manipulation-keyof.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Pick & Omit" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="keyof Operator →" />
                                                <jsp:param name="currentLessonId" value="utility-record" />
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