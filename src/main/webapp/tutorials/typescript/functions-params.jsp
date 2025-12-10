<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-params" );
        request.setAttribute("currentModule", "Functions & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Function Parameters | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript function parameters: optional, default, and rest parameters with type safety.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/functions-params.jsp">
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
        "name": "TypeScript Function Parameters",
        "description": "Learn optional, default, and rest parameters in TypeScript.",
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

        <body class="tutorial-body no-preview" data-lesson="functions-params">
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
                                        class="breadcrumb-separator">/</span><span>Parameters</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Function Parameters</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">TypeScript provides flexible parameter options: optional, default,
                                        and rest parameters, all with type safety.</p>

                                    <h2>Optional Parameters</h2>
                                    <p>Use <code>?</code> to make parameters optional. Optional parameters can be
                                        <code>undefined</code>:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/params-optional.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-optional" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Optional parameters must come AFTER required
                                        parameters.
                                        <pre><code class="language-typescript">// ✗ Wrong
function greet(lastName?: string, firstName: string) { }

// ✓ Correct
function greet(firstName: string, lastName?: string) { }</code></pre>
                                    </div>

                                    <h2>Default Parameters</h2>
                                    <p>Default parameters have a fallback value if not provided:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/params-default.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-default" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Default parameters are automatically optional. You don't
                                        need to add <code>?</code>
                                    </div>

                                    <h3>Optional vs Default Parameters</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Optional (<code>?</code>)</th>
                                                <th>Default (<code>=</code>)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Value if omitted</td>
                                                <td><code>undefined</code></td>
                                                <td>Default value</td>
                                            </tr>
                                            <tr>
                                                <td>Type includes undefined</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Must check for undefined</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Position requirement</td>
                                                <td>After required</td>
                                                <td>Anywhere</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Rest Parameters</h2>
                                    <p>Rest parameters collect multiple arguments into an array:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/params-rest.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-rest" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Rest Parameter Rules:</strong>
                                        <ul>
                                            <li>Must be the LAST parameter</li>
                                            <li>Only ONE rest parameter allowed</li>
                                            <li>Type must be an array</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Wrong Parameter Order</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - optional before required
function create(id?: number, userName: string) { }

// ✓ Correct
function create(userName: string, id?: number) { }</code></pre>

                                        <h4>2. Multiple Rest Parameters</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - only one rest parameter allowed
function combine(...nums: number[], ...strs: string[]) { }

// ✓ Correct - use union type
function combine(...items: (number | string)[]) { }</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Optional:</strong> <code>param?</code> - can be undefined</li>
                                            <li><strong>Default:</strong> <code>param = value</code> - has fallback</li>
                                            <li><strong>Rest:</strong> <code>...params</code> - collects multiple args
                                            </li>
                                            <li>Optional/rest must come after required parameters</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Function Overloading</strong> for multiple function signatures!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/functions-basics.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/functions-overloading.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Function Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Overloading →" />
                                                <jsp:param name="currentLessonId" value="functions-params" />
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