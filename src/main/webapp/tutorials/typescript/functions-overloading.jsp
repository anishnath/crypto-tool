<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-overloading" );
        request.setAttribute("currentModule", "Functions & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Function Overloading | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: learn TypeScript function overloading with multiple function signatures for flexible APIs.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/functions-overloading.jsp">
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
        "name": "TypeScript Function Overloading",
        "description": "Master function overloading for multiple function signatures.",
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

        <body class="tutorial-body no-preview" data-lesson="functions-overloading">
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
                                        class="breadcrumb-separator">/</span><span>Function Overloading</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Function Overloading</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~15 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Function overloading allows you to define multiple function
                                        signatures for the same function name, providing different ways to call the
                                        function based on parameter types.</p>

                                    <h2>Basic Overloading</h2>
                                    <p>Define multiple signatures, then implement the function with a compatible
                                        signature:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/overload-basic.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-overload" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How It Works:</strong>
                                        <ol>
                                            <li><strong>Overload signatures</strong> - Define the different ways to call
                                                the function</li>
                                            <li><strong>Implementation signature</strong> - Write the actual function
                                                body</li>
                                            <li>TypeScript picks the correct overload based on arguments</li>
                                        </ol>
                                    </div>

                                    <h2>Why Use Overloading?</h2>
                                    <p>Function overloading is useful when a function can accept different parameter
                                        combinations:</p>
                                    <ul>
                                        <li><strong>Different parameter types:</strong> String or number input</li>
                                        <li><strong>Different parameter counts:</strong> 1, 2, or 3 parameters</li>
                                        <li><strong>Different return types:</strong> Based on input type</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Overloading vs Union Types</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Approach</th>
                                                <th>When to Use</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Overloading</strong></td>
                                                <td>Different return types based on input</td>
                                                <td><code>getValue(id: number): User<br>getValue(name: string): User[]</code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Union Types</strong></td>
                                                <td>Same return type, flexible input</td>
                                                <td><code>format(value: string | number): string</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Implementation Signature Visible to Callers</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - implementation signature is too specific
function greet(name: string): string;
function greet(name: string): string {  // Duplicate!
    return `Hello, ${name}`;
}

// ✓ Correct - use 'any' or union in implementation
function greet(name: string): string;
function greet(name: any): any {
    return `Hello, ${name}`;
}</code></pre>

                                        <h4>2. Incompatible Implementation</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - implementation doesn't match overloads
function process(x: string): number;
function process(x: number): string;
function process(x: boolean): boolean {  // Error!
    return x;
}

// ✓ Correct - implementation covers all overloads
function process(x: string): number;
function process(x: number): string;
function process(x: string | number): string | number {
    return typeof x === "string" ? x.length : x.toString();
}</code></pre>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Important:</strong> The implementation signature is NOT visible to
                                        callers. Only the overload signatures are used for type checking.
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Multiple signatures</strong> for different call patterns</li>
                                            <li><strong>One implementation</strong> that handles all cases</li>
                                            <li>TypeScript chooses the correct overload automatically</li>
                                            <li>Use when return type depends on parameter type</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Interface Basics</strong> to define object shapes!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/functions-params.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/interfaces-basics.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Parameters" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Interfaces →" />
                                                <jsp:param name="currentLessonId" value="functions-overloading" />
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