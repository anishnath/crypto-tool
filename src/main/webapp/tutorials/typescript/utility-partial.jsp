<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "utility-partial" );
        request.setAttribute("currentModule", "Generics & Utility Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Partial & Required | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript Partial and Required utility types for flexible object types.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/utility-partial.jsp">
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
        "name": "TypeScript Partial & Required",
        "description": "Learn Partial and Required utility types for object manipulation.",
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

        <body class="tutorial-body no-preview" data-lesson="utility-partial">
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
                                        class="breadcrumb-separator">/</span><span>Partial & Required</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Partial & Required</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Partial and Required utility types transform object types by making
                                        properties optional or required.</p>

                                    <h2>Partial & Required Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/utility-partial.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-partial" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Utility Types:</strong>
                                        <ul>
                                            <li><code>Partial&lt;T&gt;</code> - Makes all properties optional</li>
                                            <li><code>Required&lt;T&gt;</code> - Makes all properties required</li>
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
                                                <td>Partial</td>
                                                <td>Updates, patches</td>
                                                <td><code>updateUser(partial)</code></td>
                                            </tr>
                                            <tr>
                                                <td>Required</td>
                                                <td>Ensure all fields</td>
                                                <td><code>validateConfig(required)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Using Partial for New Objects</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - new users should have all fields
function createUser(user: Partial<User>) { }

// ✓ Correct - use full type for creation
function createUser(user: User) { }
function updateUser(updates: Partial<User>) { }</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use <code>Partial</code> for
                                        updates/patches, <code>Required</code> to enforce completeness.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>Partial&lt;T&gt;</code> makes all properties optional</li>
                                            <li><code>Required&lt;T&gt;</code> makes all properties required</li>
                                            <li>Perfect for update operations and validation</li>
                                            <li>Built-in TypeScript utility types</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/generics-constraints.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/utility-pick.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Generic Constraints" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Pick & Omit →" />
                                                <jsp:param name="currentLessonId" value="utility-partial" />
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