<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-discriminated" );
        request.setAttribute("currentModule", "Advanced Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Discriminated Unions | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript discriminated unions for type-safe pattern matching with tagged unions.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/advanced-discriminated.jsp">
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
        "name": "TypeScript Discriminated Unions",
        "description": "Master discriminated unions for type-safe pattern matching.",
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
            "name": "Typescript Tutorial",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-discriminated">
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
                                        class="breadcrumb-separator">/</span><span>Discriminated Unions</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Discriminated Unions</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~22 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Discriminated unions (tagged unions) use a common property to
                                        distinguish between union members, enabling type-safe pattern matching.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-discriminated-unions.svg"
                                        alt="TypeScript Discriminated Unions" class="diagram-image"
                                        style="max-width: 900px; margin: 2rem auto; display: block;">

                                    <h2>Basic Discriminated Union</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/advanced-discriminated.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-discriminated" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Key Components:</strong>
                                        <ul>
                                            <li><strong>Discriminant:</strong> Common property (e.g., <code>kind</code>)
                                            </li>
                                            <li><strong>Union members:</strong> Types with different discriminant values
                                            </li>
                                            <li><strong>Switch/if:</strong> Pattern match on discriminant</li>
                                        </ul>
                                    </div>

                                    <h2>Why Use Discriminated Unions?</h2>
                                    <ul>
                                        <li><strong>Type safety:</strong> TypeScript narrows types automatically</li>
                                        <li><strong>Exhaustiveness:</strong> Compiler ensures all cases handled</li>
                                        <li><strong>Clarity:</strong> Clear intent with explicit type tags</li>
                                        <li><strong>Refactoring:</strong> Adding new types shows missing cases</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Pattern Matching</h2>
                                    <pre><code class="language-typescript">type Result<T> = 
    | { status: "success"; data: T }
    | { status: "error"; error: string }
    | { status: "loading" };

function handleResult<T>(result: Result<T>) {
    switch (result.status) {
        case "success":
            console.log(result.data);  // ✓ TypeScript knows data exists
            break;
        case "error":
            console.log(result.error);  // ✓ TypeScript knows error exists
            break;
        case "loading":
            console.log("Loading...");
            break;
    }
}</code></pre>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Inconsistent Discriminant Names</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - different property names
type A = { type: "a"; value: string };
type B = { kind: "b"; value: number };  // Different name!

// ✓ Correct - same property name
type A = { kind: "a"; value: string };
type B = { kind: "b"; value: number };</code></pre>

                                        <h4>2. Missing Cases</h4>
                                        <pre><code class="language-typescript">type Shape = Circle | Rectangle | Triangle;

function area(shape: Shape): number {
    switch (shape.kind) {
        case "circle":
            return Math.PI * shape.radius ** 2;
        case "rectangle":
            return shape.width * shape.height;
        // ✗ Missing triangle case!
    }
    return 0;  // Unsafe fallback
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use discriminated unions for
                                        state machines, API responses, and complex data structures.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Discriminated unions use a common discriminant property</li>
                                            <li>TypeScript narrows types based on discriminant</li>
                                            <li>Perfect for pattern matching with switch</li>
                                            <li>Ensures exhaustive handling of all cases</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! Module 4 complete. Next: <strong>Generics & Utility
                                            Types</strong>!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-guards.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/generics-intro.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Type Guards" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Generics →" />
                                                <jsp:param name="currentLessonId" value="advanced-discriminated" />
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