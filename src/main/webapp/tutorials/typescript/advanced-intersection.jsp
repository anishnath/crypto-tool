<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-intersection" );
        request.setAttribute("currentModule", "Advanced Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Intersection Types | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript intersection types for combining multiple types with AND logic.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/advanced-intersection.jsp">
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
        "name": "TypeScript Intersection Types",
        "description": "Learn intersection types to combine multiple types with AND logic.",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-intersection">
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
                                        class="breadcrumb-separator">/</span><span>Intersection Types</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Intersection Types</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Intersection types combine multiple types into one using AND logic.
                                        The result must have ALL properties from all types.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-intersection-types.svg"
                                        alt="TypeScript Intersection Types" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Basic Intersection Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/advanced-intersection.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-intersection" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Intersection Syntax:</strong> Use the ampersand
                                        <code>&</code> to combine types: <code>type C = A & B</code></div>

                                    <h2>When to Use Intersection Types</h2>
                                    <ul>
                                        <li><strong>Mixins:</strong> Combine multiple behaviors</li>
                                        <li><strong>Composition:</strong> Build complex types from simple ones</li>
                                        <li><strong>Extending types:</strong> Add properties to existing types</li>
                                        <li><strong>Multiple constraints:</strong> Require all properties</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Intersection vs Union</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Intersection (&)</th>
                                                <th>Union (|)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Logic</td>
                                                <td>AND - must have ALL</td>
                                                <td>OR - can be ANY</td>
                                            </tr>
                                            <tr>
                                                <td>Properties</td>
                                                <td>Combined from all types</td>
                                                <td>Only common properties</td>
                                            </tr>
                                            <tr>
                                                <td>Use case</td>
                                                <td>Composition, mixins</td>
                                                <td>Flexible parameters</td>
                                            </tr>
                                            <tr>
                                                <td>Example</td>
                                                <td><code>A & B</code> has all from A and B</td>
                                                <td><code>A | B</code> is either A or B</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Conflicting Property Types</h4>
                                        <pre><code class="language-typescript">type A = { value: string };
type B = { value: number };

type C = A & B;  // value is never (impossible!)

// ✓ Better - compatible types
type A = { name: string };
type B = { age: number };
type C = A & B;  // { name: string; age: number }</code></pre>

                                        <h4>2. Confusing & with |</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - using union when intersection needed
function merge(a: Named | Aged) {
    // Can't access both name and age
}

// ✓ Correct - intersection requires both
function merge(a: Named & Aged) {
    console.log(a.name, a.age);  // ✓ OK
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use intersection types for
                                        composition. They're perfect for combining multiple interfaces or type aliases.
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Intersection types use <code>&</code> for AND logic</li>
                                            <li>Result must have ALL properties from all types</li>
                                            <li>Perfect for composition and mixins</li>
                                            <li>Avoid conflicting property types</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-union.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-literals.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Union Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Literal Types →" />
                                                <jsp:param name="currentLessonId" value="advanced-intersection" />
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