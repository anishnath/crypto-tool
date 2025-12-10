<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-guards" ); request.setAttribute("currentModule", "Advanced Types"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Type Guards - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript type guards for runtime type checking and type narrowing.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/advanced-guards.jsp">
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
        "name": "TypeScript Type Guards",
        "description": "Learn type guards for runtime type checking and narrowing.",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-guards">
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
                                        class="breadcrumb-separator">/</span><span>Type Guards</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Type Guards</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~20 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Type guards are runtime checks that narrow types, allowing
                                        TypeScript to understand what type a value is within a specific code block.</p>

                                    <h2>Built-in Type Guards</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/advanced-guards.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-guards" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Type Guard Syntax:</strong> Use
                                        <code>value is Type</code> as return type for custom type guard functions</div>

                                    <h2>Types of Type Guards</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type Guard</th>
                                                <th>Use Case</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>typeof</code></td>
                                                <td>Primitives</td>
                                                <td><code>typeof x === "string"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>instanceof</code></td>
                                                <td>Classes</td>
                                                <td><code>x instanceof Date</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>in</code></td>
                                                <td>Properties</td>
                                                <td><code>"name" in obj</code></td>
                                            </tr>
                                            <tr>
                                                <td>Custom</td>
                                                <td>Complex types</td>
                                                <td><code>isUser(x)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Custom Type Guards</h2>
                                    <pre><code class="language-typescript">interface User {
    userName: string;
    email: string;
}

function isUser(obj: any): obj is User {
    return obj && 
           typeof obj.userName === "string" &&
           typeof obj.email === "string";
}

function process(data: unknown) {
    if (isUser(data)) {
        console.log(data.userName);  // ✓ TypeScript knows it's User
    }
}</code></pre>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Forgetting 'is' in Return Type</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - returns boolean, doesn't narrow type
function isString(value: unknown): boolean {
    return typeof value === "string";
}

// ✓ Correct - narrows type
function isString(value: unknown): value is string {
    return typeof value === "string";
}</code></pre>

                                        <h4>2. Incomplete Type Checks</h4>
                                        <pre><code class="language-typescript">// ✗ Unsafe - doesn't check all properties
function isUser(obj: any): obj is User {
    return obj.userName !== undefined;
}

// ✓ Safe - checks all required properties
function isUser(obj: any): obj is User {
    return obj && 
           typeof obj.userName === "string" &&
           typeof obj.email === "string";
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use type guards to safely work
                                        with union types and unknown values.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Type guards narrow types at runtime</li>
                                            <li>Use <code>typeof</code>, <code>instanceof</code>, <code>in</code>
                                                operators</li>
                                            <li>Custom guards use <code>value is Type</code> syntax</li>
                                            <li>Essential for working with union types</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-literals.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-discriminated.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Literal Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Discriminated Unions →" />
                                                <jsp:param name="currentLessonId" value="advanced-guards" />
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