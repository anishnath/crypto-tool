<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "generics-intro" );
        request.setAttribute("currentModule", "Generics & Utility Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Generics Intro | 8gwifi.org</title>
            <meta name="description" content="Free TypeScript tutorial: master TypeScript generics for writing reusable, type-safe code.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/generics-intro.jsp">
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
        "name": "TypeScript Generics Introduction",
        "description": "Learn generics for reusable, type-safe code with type parameters.",
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

        <body class="tutorial-body no-preview" data-lesson="generics-intro">
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
                                        class="breadcrumb-separator">/</span><span>Generics Intro</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Generics Introduction</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~20 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Generics allow you to write reusable code that works with multiple
                                        types while maintaining type safety.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-generics.svg"
                                        alt="TypeScript Generics" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>What Are Generics?</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/generics-intro.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-generics" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Generic Syntax:</strong> Use angle brackets
                                        <code>&lt;T&gt;</code> to define type parameters. <code>T</code> is a
                                        placeholder for any type.</div>

                                    <h2>Why Use Generics?</h2>
                                    <ul>
                                        <li><strong>Reusability:</strong> Write once, use with any type</li>
                                        <li><strong>Type safety:</strong> Catch errors at compile-time</li>
                                        <li><strong>No type casting:</strong> TypeScript infers types</li>
                                        <li><strong>Better IDE support:</strong> Autocomplete works perfectly</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Generics vs Any</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Generics</th>
                                                <th>Any</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Type safety</td>
                                                <td>✓ Full type checking</td>
                                                <td>✗ No type checking</td>
                                            </tr>
                                            <tr>
                                                <td>Autocomplete</td>
                                                <td>✓ Works perfectly</td>
                                                <td>✗ No autocomplete</td>
                                            </tr>
                                            <tr>
                                                <td>Refactoring</td>
                                                <td>✓ Safe refactoring</td>
                                                <td>✗ Unsafe</td>
                                            </tr>
                                            <tr>
                                                <td>Return type</td>
                                                <td>✓ Preserves type</td>
                                                <td>✗ Returns any</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Using Any Instead of Generics</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - loses type safety
function identity(value: any): any {
    return value;
}

// ✓ Correct - maintains type safety
function identity<T>(value: T): T {
    return value;
}</code></pre>

                                        <h4>2. Not Specifying Type Parameters</h4>
                                        <pre><code class="language-typescript">// Works but less explicit
let result = identity(42);  // Type inferred

// ✓ Better - explicit type
let result = identity<number>(42);</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use generics when you need
                                        type-safe reusable code. Common naming: <code>T</code> (Type), <code>K</code>
                                        (Key), <code>V</code> (Value).</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Generics enable reusable, type-safe code</li>
                                            <li>Use <code>&lt;T&gt;</code> syntax for type parameters</li>
                                            <li>Better than <code>any</code> - preserves type information</li>
                                            <li>TypeScript can infer generic types</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-discriminated.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/generics-functions.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Discriminated Unions" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Generic Functions →" />
                                                <jsp:param name="currentLessonId" value="generics-intro" />
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