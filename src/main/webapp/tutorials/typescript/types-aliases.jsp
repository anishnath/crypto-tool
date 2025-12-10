<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-aliases" );
        request.setAttribute("currentModule", "Functions & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Type Aliases - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript type aliases to create custom type names for primitives, unions, intersections, and complex types.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/types-aliases.jsp">
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
        "name": "TypeScript Type Aliases",
        "description": "Master type aliases for reusable type definitions.",
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

        <body class="tutorial-body no-preview" data-lesson="types-aliases">
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
                                        class="breadcrumb-separator">/</span><span>Type Aliases</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Type Aliases</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~15 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Type aliases create custom names for any type, making code more
                                        readable and maintainable.</p>

                                    <h2>Basic Type Alias</h2>
                                    <p>Use the <code>type</code> keyword to create reusable type definitions:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/type-alias-basic.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-alias" />
                                    </jsp:include>

                                    <div class="tip-box"><strong>Naming Convention:</strong> Use PascalCase for type
                                        aliases (e.g., <code>UserId</code>, <code>Point</code>).</div>

                                    <h2>Union Types</h2>
                                    <p>Type aliases are perfect for union types (OR logic):</p>
                                    <pre><code class="language-typescript">type Status = "pending" | "approved" | "rejected";
type ID = string | number;

let orderStatus: Status = "pending";
let userId: ID = "user123";
let productId: ID = 456;</code></pre>

                                    <h2>When to Use Type Aliases</h2>
                                    <ul>
                                        <li><strong>Union types:</strong> <code>string | number</code></li>
                                        <li><strong>Primitive aliases:</strong> <code>type ID = string</code></li>
                                        <li><strong>Tuple types:</strong> <code>type Point = [number, number]</code>
                                        </li>
                                        <li><strong>Function types:</strong>
                                            <code>type Handler = (e: Event) => void</code></li>
                                        <li><strong>Complex types:</strong> Combinations of the above</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Type Alias vs Interface</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use Case</th>
                                                <th>Recommendation</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Object shape</td>
                                                <td>Interface</td>
                                                <td><code>interface User { }</code></td>
                                            </tr>
                                            <tr>
                                                <td>Union type</td>
                                                <td>Type alias</td>
                                                <td><code>type ID = string | number</code></td>
                                            </tr>
                                            <tr>
                                                <td>Primitive alias</td>
                                                <td>Type alias</td>
                                                <td><code>type Email = string</code></td>
                                            </tr>
                                            <tr>
                                                <td>Tuple</td>
                                                <td>Type alias</td>
                                                <td><code>type Point = [number, number]</code></td>
                                            </tr>
                                            <tr>
                                                <td>Function type</td>
                                                <td>Either</td>
                                                <td><code>type Fn = () => void</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Patterns</h2>
                                    <div class="info-box">
                                        <h4>1. String Literal Unions</h4>
                                        <pre><code class="language-typescript">type Direction = "north" | "south" | "east" | "west";
type Theme = "light" | "dark" | "auto";</code></pre>

                                        <h4>2. Intersection Types (AND logic)</h4>
                                        <pre><code class="language-typescript">type Timestamped = { createdAt: Date };
type User = { userName: string };
type TimestampedUser = User & Timestamped;</code></pre>

                                        <h4>3. Utility Type Aliases</h4>
                                        <pre><code class="language-typescript">type Nullable<T> = T | null;
type Optional<T> = T | undefined;</code></pre>
                                    </div>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Redeclaring Type Aliases</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - cannot redeclare
type ID = string;
type ID = number;  // Error!

// ✓ Correct - use union
type ID = string | number;</code></pre>

                                        <h4>2. Confusing Type Alias with Value</h4>
                                        <pre><code class="language-typescript">type Point = { x: number; y: number };

// ✗ Wrong - Point is a type, not a value
let p = new Point();

// ✓ Correct
let p: Point = { x: 10, y: 20 };</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>type</code> keyword to create aliases</li>
                                            <li>Perfect for unions, primitives, tuples</li>
                                            <li>Cannot be redeclared (unlike interfaces)</li>
                                            <li>Use PascalCase naming convention</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Extending Interfaces</strong> to build complex types!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/interfaces-basics.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/interfaces-extending.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Interfaces" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Extending →" />
                                                <jsp:param name="currentLessonId" value="types-aliases" />
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