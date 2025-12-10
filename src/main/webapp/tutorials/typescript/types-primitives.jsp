<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-primitives" );
        request.setAttribute("currentModule", "Getting Started & Basic Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>TypeScript Primitive Types | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: learn TypeScript's 3 primitive types: string, number, and boolean. Master type annotations, template literals, type inference, and ...">
            <meta name="keywords"
                content="typescript string, typescript number, typescript boolean, primitive types, type annotations, template literals, typescript types">

            <meta property="og:type" content="article">
            <meta property="og:title" content="TypeScript Primitive Types - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master TypeScript's primitive types (string, number, boolean) with interactive code examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/types-primitives.jsp">
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
        "name": "TypeScript Primitive Types",
        "description": "Comprehensive guide to TypeScript's primitive types: string, number, and boolean.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["string type", "number type", "boolean type", "type annotations", "template literals"],
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

        <body class="tutorial-body no-preview" data-lesson="types-primitives">
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
                                    <span>Primitive Types</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">TypeScript Primitive Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">TypeScript has three main primitive types that form the foundation
                                        of type-safe programming: <code>string</code>, <code>number</code>, and
                                        <code>boolean</code>. Unlike Java with its 8 primitive types, TypeScript keeps
                                        it simple while maintaining powerful type safety. Let's master these fundamental
                                        types!
                                    </p>

                                    <!-- Section 1: The 3 Primitive Types -->
                                    <h2>The 3 Primitive Types</h2>
                                    <p>TypeScript's primitive types correspond directly to JavaScript's primitive
                                        values, but with added type safety:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th>Example Values</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>string</code></td>
                                                <td>Text data</td>
                                                <td><code>"hello"</code>, <code>'world'</code>, <code>`template`</code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><code>number</code></td>
                                                <td>All numeric values (integers and decimals)</td>
                                                <td><code>42</code>, <code>3.14</code>, <code>-10</code>,
                                                    <code>0xFF</code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><code>boolean</code></td>
                                                <td>True or false values</td>
                                                <td><code>true</code>, <code>false</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Key Difference from Java:</strong> TypeScript has only ONE number type
                                        for all numeric values. There's no separate <code>int</code>, <code>long</code>,
                                        <code>float</code>, or <code>double</code> - just <code>number</code>!
                                    </div>

                                    <!-- Section 2: String Type -->
                                    <h2>String Type</h2>
                                    <p>The <code>string</code> type represents textual data. TypeScript supports three
                                        ways to define strings:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-string.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-string" />
                                    </jsp:include>

                                    <h3>Template Literals (Backticks)</h3>
                                    <p>Template literals are the most powerful string type. They support:</p>
                                    <ul>
                                        <li><strong>String interpolation:</strong> Embed expressions with
                                            <code>\${}</code>
                                        </li>
                                        <li><strong>Multi-line strings:</strong> No need for escape characters</li>
                                        <li><strong>Expression evaluation:</strong> Calculate values inside strings</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-template-literals.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-template" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use template literals for string interpolation
                                        instead of concatenation. It's more readable and less error-prone!
                                    </div>

                                    <!-- Section 3: Number Type -->
                                    <h2>Number Type</h2>
                                    <p>The <code>number</code> type handles all numeric values - integers, decimals,
                                        hexadecimal, binary, and octal:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-number.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-number" />
                                    </jsp:include>

                                    <h3>Special Number Values</h3>
                                    <p>TypeScript's <code>number</code> type includes special values:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Value</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>Infinity</code></td>
                                                <td>Positive infinity</td>
                                                <td><code>1 / 0</code> → <code>Infinity</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>-Infinity</code></td>
                                                <td>Negative infinity</td>
                                                <td><code>-1 / 0</code> → <code>-Infinity</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>NaN</code></td>
                                                <td>Not a Number</td>
                                                <td><code>"hello" * 2</code> → <code>NaN</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Floating Point Precision:</strong> Like JavaScript, TypeScript uses IEEE
                                        754 double-precision floating-point. This can lead to precision issues:
                                        <pre><code class="language-typescript">console.log(0.1 + 0.2); // 0.30000000000000004 (not exactly 0.3!)</code></pre>
                                        For financial calculations, consider using libraries like
                                        <code>decimal.js</code> or <code>big.js</code>.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 4: Boolean Type -->
                                    <h2>Boolean Type</h2>
                                    <p>The <code>boolean</code> type has only two values: <code>true</code> and
                                        <code>false</code>. It's essential for conditional logic:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-boolean.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-boolean" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Truthy vs Boolean:</strong> In JavaScript/TypeScript, many values are
                                        "truthy" or "falsy" in conditions, but the <code>boolean</code> type only
                                        accepts literal <code>true</code> or <code>false</code>:
                                        <pre><code class="language-typescript">let isActive: boolean = true;  // ✓ Correct
let isActive: boolean = 1;     // ✗ Error: Type 'number' is not assignable to type 'boolean'</code></pre>
                                    </div>

                                    <!-- Section 5: Type Annotations vs Type Inference -->
                                    <h2>Type Annotations vs Type Inference</h2>
                                    <p>TypeScript can automatically infer types, but you can also explicitly annotate
                                        them:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-inference.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-inference" />
                                    </jsp:include>

                                    <h3>When to Use Annotations</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Scenario</th>
                                                <th>Recommendation</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Variable initialized with a value</td>
                                                <td>Let TypeScript infer (no annotation needed)</td>
                                            </tr>
                                            <tr>
                                                <td>Variable declared without initialization</td>
                                                <td>Use explicit annotation</td>
                                            </tr>
                                            <tr>
                                                <td>Function parameters</td>
                                                <td>Always use annotations</td>
                                            </tr>
                                            <tr>
                                                <td>Function return types</td>
                                                <td>Recommended for clarity</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 6: Type Safety in Action -->
                                    <h2>Type Safety in Action</h2>
                                    <p>TypeScript prevents common type-related errors at compile time:</p>

                                    <div class="mistake-box">
                                        <h4>Common Type Errors</h4>
                                        <pre><code class="language-typescript">// Error: Type 'number' is not assignable to type 'string'
let userName: string = 42;

// Error: Type 'string' is not assignable to type 'number'
let age: number = "25";

// Error: Type 'string' is not assignable to type 'boolean'
let isActive: boolean = "true";

// Correct usage
let userName: string = "Alice";
let age: number = 25;
let isActive: boolean = true;</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: User Profile</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a user profile with proper type annotations!
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create variables for: firstName, lastName, age, email, isVerified,
                                                balance</li>
                                            <li>Use appropriate primitive types for each</li>
                                            <li>Create a greeting message using template literals</li>
                                            <li>Display all user information</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="typescript/exercises/ex-primitives.ts" />
                                            <jsp:param name="language" value="typescript" />
                                            <jsp:param name="editorId" value="exercise-primitives" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>💡 Hint</summary>
                                            <p>Remember: names and email are strings, age and balance are numbers, and
                                                isVerified is a boolean. Use template literals to create a nice
                                                greeting!</p>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>string</strong> - Text data, supports single quotes, double
                                                quotes, and template literals</li>
                                            <li><strong>number</strong> - All numeric values (integers, decimals, hex,
                                                binary, octal)</li>
                                            <li><strong>boolean</strong> - Only <code>true</code> or <code>false</code>
                                            </li>
                                            <li>Template literals (<code>`backticks`</code>) support string
                                                interpolation with <code>\${}</code></li>
                                            <li>TypeScript can infer types, but explicit annotations improve clarity
                                            </li>
                                            <li>Type annotations prevent runtime errors by catching type mismatches at
                                                compile time</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand primitive types, let's explore more complex data
                                        structures! In the next lesson, we'll learn about <strong>Arrays &
                                            Tuples</strong> - how to store collections of values with type safety.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/first-program.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-arrays.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← First Program" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Arrays & Tuples →" />
                                                <jsp:param name="currentLessonId" value="types-primitives" />
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