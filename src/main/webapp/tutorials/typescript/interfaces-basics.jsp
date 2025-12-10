<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "interfaces-basics" );
        request.setAttribute("currentModule", "Functions & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Interfaces - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript interfaces to define object shapes with type safety, optional properties, and readonly fields.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/interfaces-basics.jsp">
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
        "name": "TypeScript Interfaces",
        "description": "Learn interfaces to define object shapes and contracts.",
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

        <body class="tutorial-body no-preview" data-lesson="interfaces-basics">
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
                                        class="breadcrumb-separator">/</span><span>Interfaces</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Interface Basics</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Interfaces define the structure of objects, ensuring type safety and
                                        providing clear contracts for your code.</p>

                                    <h2>Basic Interface</h2>
                                    <p>Interfaces describe the shape of an object - what properties it must have and
                                        their types:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/interface-basic.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-basic" />
                                    </jsp:include>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use PascalCase for interface
                                        names (e.g., <code>Person</code>, <code>UserProfile</code>).</div>

                                    <h2>Optional Properties</h2>
                                    <p>Mark properties as optional with <code>?</code> when they may not always be
                                        present:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/interface-optional.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-optional" />
                                    </jsp:include>

                                    <h2>Why Use Interfaces?</h2>
                                    <ul>
                                        <li><strong>Type Safety:</strong> Catch errors at compile time</li>
                                        <li><strong>Documentation:</strong> Self-documenting code structure</li>
                                        <li><strong>Autocomplete:</strong> Better IDE support</li>
                                        <li><strong>Refactoring:</strong> Easier to change object structures</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Interfaces vs Type Aliases</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Interface</th>
                                                <th>Type Alias</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Extend/Implement</td>
                                                <td>✓ Yes</td>
                                                <td>✓ Yes (with &)</td>
                                            </tr>
                                            <tr>
                                                <td>Declaration Merging</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Primitives/Unions</td>
                                                <td>✗ No</td>
                                                <td>✓ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Best for</td>
                                                <td>Object shapes</td>
                                                <td>Unions, primitives</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box"><strong>Rule of Thumb:</strong> Use interfaces for object
                                        shapes, type aliases for everything else.</div>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Missing Required Properties</h4>
                                        <pre><code class="language-typescript">interface User {
    userName: string;
    email: string;
}

// ✗ Wrong - missing email
let user: User = {
    userName: "alice"
};

// ✓ Correct
let user: User = {
    userName: "alice",
    email: "alice@example.com"
};</code></pre>

                                        <h4>2. Extra Properties</h4>
                                        <pre><code class="language-typescript">interface Point {
    x: number;
    y: number;
}

// ✗ Wrong - extra property 'z'
let point: Point = { x: 10, y: 20, z: 30 };

// ✓ Correct
let point: Point = { x: 10, y: 20 };</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Interfaces</strong> define object shapes with type safety</li>
                                            <li>Use <code>?</code> for optional properties</li>
                                            <li>Prefer interfaces for object types</li>
                                            <li>All required properties must be present</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Type Aliases</strong> for creating custom type names!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/functions-overloading.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/types-aliases.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Overloading" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Type Aliases →" />
                                                <jsp:param name="currentLessonId" value="interfaces-basics" />
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