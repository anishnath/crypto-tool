<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-literals" );
        request.setAttribute("currentModule", "Advanced Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Literal Types - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript literal types for precise type definitions with exact values.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/advanced-literals.jsp">
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
        "name": "TypeScript Literal Types",
        "description": "Master literal types for exact value type definitions.",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-literals">
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
                                        class="breadcrumb-separator">/</span><span>Literal Types</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Literal Types</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~15 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Literal types allow you to specify exact values a variable can have,
                                        providing precise type safety.</p>

                                    <h2>String Literal Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/advanced-literals.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-literals" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Literal Types:</strong> Instead of allowing any
                                        string/number, limit to specific values like <code>"north" | "south"</code>
                                    </div>

                                    <h2>When to Use Literal Types</h2>
                                    <ul>
                                        <li><strong>Status values:</strong> "pending" | "approved" | "rejected"</li>
                                        <li><strong>Directions:</strong> "north" | "south" | "east" | "west"</li>
                                        <li><strong>Modes:</strong> "light" | "dark" | "auto"</li>
                                        <li><strong>Fixed values:</strong> Dice rolls (1-6), HTTP methods</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Literal Types vs Enums</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Literal Types</th>
                                                <th>Enums</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Syntax</td>
                                                <td>Simple union</td>
                                                <td>Enum declaration</td>
                                            </tr>
                                            <tr>
                                                <td>Runtime</td>
                                                <td>No runtime code</td>
                                                <td>Generates object</td>
                                            </tr>
                                            <tr>
                                                <td>Autocomplete</td>
                                                <td>✓ Yes</td>
                                                <td>✓ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Best for</td>
                                                <td>Simple string/number sets</td>
                                                <td>Complex enumerations</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Using String Instead of Literal</h4>
                                        <pre><code class="language-typescript">// ✗ Too broad - any string allowed
function setTheme(theme: string) { }

// ✓ Precise - only specific values
function setTheme(theme: "light" | "dark") { }</code></pre>

                                        <h4>2. Forgetting const Assertion</h4>
                                        <pre><code class="language-typescript">let direction = "north";  // Type: string

// ✓ Use const or as const
const direction = "north";  // Type: "north"
let dir = "north" as const;  // Type: "north"</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use literal types for fixed
                                        sets of values. They provide better type safety than plain strings.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Literal types specify exact values</li>
                                            <li>Works with strings, numbers, booleans</li>
                                            <li>Combine with unions for multiple options</li>
                                            <li>Provides autocomplete and type safety</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-intersection.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-guards.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Intersection Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Type Guards →" />
                                                <jsp:param name="currentLessonId" value="advanced-literals" />
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