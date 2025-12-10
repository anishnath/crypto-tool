<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-basics" );
        request.setAttribute("currentModule", "Functions & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <title>TypeScript Function Types - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript function types: function declarations, expressions, arrow functions, return types, and type annotations with inte...">
            <meta name="keywords"
                content="typescript functions, function types, arrow functions, return types, function expressions">
            <meta property="og:type" content="article">
            <meta property="og:title" content="TypeScript Function Types - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description" content="Learn TypeScript function types with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/functions-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>
            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "TypeScript Function Types",
        "description": "Learn TypeScript function types and annotations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["function types", "arrow functions", "return types"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "TypeScript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
        }
    }
    </script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-basics">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Function Types</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Function Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Functions are the building blocks of TypeScript applications.
                                        TypeScript adds type safety to function parameters and return values, catching
                                        errors before runtime.</p>

                                    <h2>Function Declarations</h2>
                                    <p>The most common way to define functions with type annotations:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/functions-declarations.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-declarations" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Always annotate function parameters. TypeScript
                                        cannot infer parameter types, so explicit annotations are required for type
                                        safety.
                                    </div>

                                    <h2>Function Expressions</h2>
                                    <p>Assign functions to variables with explicit types:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/functions-expressions.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-expressions" />
                                    </jsp:include>

                                    <h3>When to Use Function Expressions</h3>
                                    <ul>
                                        <li><strong>Callbacks:</strong> Passing functions as arguments</li>
                                        <li><strong>Conditional functions:</strong> Assigning different functions based
                                            on conditions</li>
                                        <li><strong>IIFEs:</strong> Immediately Invoked Function Expressions</li>
                                    </ul>

                                    <h2>Arrow Functions</h2>
                                    <p>Arrow functions provide concise syntax and lexical <code>this</code> binding:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/functions-arrow.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-arrow" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Arrow Functions vs Regular Functions:</strong>
                                        <ul>
                                            <li>Arrow functions don't have their own <code>this</code></li>
                                            <li>Cannot be used as constructors</li>
                                            <li>No <code>arguments</code> object</li>
                                            <li>More concise for simple operations</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Return Types</h2>
                                    <p>TypeScript can infer return types, but explicit annotations improve clarity and
                                        catch errors:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/functions-return.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-return" />
                                    </jsp:include>

                                    <h3>When to Annotate Return Types</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Scenario</th>
                                                <th>Recommendation</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Public API functions</td>
                                                <td>Always annotate</td>
                                            </tr>
                                            <tr>
                                                <td>Complex return types</td>
                                                <td>Always annotate</td>
                                            </tr>
                                            <tr>
                                                <td>Simple helper functions</td>
                                                <td>Can rely on inference</td>
                                            </tr>
                                            <tr>
                                                <td>Functions with multiple return paths</td>
                                                <td>Annotate for clarity</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Function Type Aliases</h2>
                                    <p>Create reusable function type definitions for consistency:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/functions-type-alias.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-alias" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Use Case:</strong> Function type aliases are perfect for callback types,
                                        event handlers, and any function signature you use multiple times.
                                    </div>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Forgetting Parameter Types</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - parameters have implicit 'any' type
function add(a, b) {
    return a + b;
}

// ✓ Correct - explicit types
function add(a: number, b: number): number {
    return a + b;
}</code></pre>

                                        <h4>2. Inconsistent Return Types</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - returns different types
function getValue(flag: boolean) {
    if (flag) return "yes";
    return 0;  // string | number - confusing!
}

// ✓ Correct - consistent return type
function getValue(flag: boolean): string {
    return flag ? "yes" : "no";
}</code></pre>

                                        <h4>3. Ignoring void Return Type</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - function shouldn't return a value
function logMessage(msg: string): void {
    console.log(msg);
    return msg;  // Error!
}

// ✓ Correct
function logMessage(msg: string): void {
    console.log(msg);
}</code></pre>
                                    </div>

                                    <h2>Exercise: Calculator Functions</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a calculator with typed functions!</p>
                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="typescript/exercises/ex-functions.ts" />
                                            <jsp:param name="language" value="typescript" />
                                            <jsp:param name="editorId" value="exercise-functions" />
                                        </jsp:include>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Always type function parameters</strong> - TypeScript cannot
                                                infer them</li>
                                            <li><strong>Return types</strong> can be inferred but explicit is better for
                                                public APIs</li>
                                            <li><strong>Arrow functions</strong> provide concise syntax and lexical
                                                <code>this</code></li>
                                            <li><strong>Function type aliases</strong> enable reusability and
                                                consistency</li>
                                            <li><strong>void</strong> means no return value, <strong>never</strong>
                                                means function never returns</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll explore <strong>Function Parameters</strong> including optional,
                                        default, and rest parameters!</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-special.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/functions-params.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Special Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Parameters →" />
                                                <jsp:param name="currentLessonId" value="functions-basics" />
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