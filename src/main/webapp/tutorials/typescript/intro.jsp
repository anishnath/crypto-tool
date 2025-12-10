<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "intro" ); request.setAttribute("currentModule", "Introduction" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: learn what TypeScript is, understand TypeScript vs JavaScript, static typing benefits, transpilation, and installation. Start your ...">
            <meta name="keywords"
                content="typescript introduction, what is typescript, typescript vs javascript, static typing, typescript tutorial, learn typescript, typescript programming, typescript installation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Introduction to TypeScript - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Learn about TypeScript programming language, its static typing system, and core concepts.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/intro.jsp">
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
        "name": "Introduction to TypeScript",
        "description": "Learn what TypeScript is, understand TypeScript vs JavaScript, static typing, and transpilation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["TypeScript programming language", "Static typing", "TypeScript vs JavaScript", "Transpilation"],
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

        <body class="tutorial-body no-preview" data-lesson="intro">
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
                                    <span>Introduction</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Introduction to TypeScript</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">TypeScript is a strongly typed programming language that builds on
                                        JavaScript, giving you better tooling at any scale. In this lesson, you'll learn
                                        what TypeScript is, why it's so widely used, and understand the key benefits of
                                        adding types to your JavaScript code.</p>

                                    <!-- Section 1: What is TypeScript? -->
                                    <h2>What is TypeScript?</h2>
                                    <p>TypeScript is a free and open-source programming language developed and
                                        maintained by Microsoft. It is a strict syntactical superset of JavaScript,
                                        meaning that any valid JavaScript code is also valid TypeScript code. TypeScript
                                        adds optional static typing and class-based object-oriented programming to
                                        JavaScript.</p>

                                    <div class="info-box">
                                        <strong>Key Features of TypeScript:</strong>
                                        <ul>
                                            <li><strong>Static Typing:</strong> Catch errors at compile-time instead of
                                                runtime</li>
                                            <li><strong>Type Inference:</strong> TypeScript can automatically infer
                                                types, reducing the need for explicit annotations</li>
                                            <li><strong>Enhanced IDE Support:</strong> Better autocompletion,
                                                navigation, and refactoring</li>
                                            <li><strong>Modern JavaScript Features:</strong> Use latest ECMAScript
                                                features with backward compatibility</li>
                                            <li><strong>Gradual Adoption:</strong> Add types incrementally to existing
                                                JavaScript projects</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: TypeScript vs JavaScript -->
                                    <h2>TypeScript vs JavaScript</h2>
                                    <p>Understanding the relationship between TypeScript and JavaScript is crucial.
                                        TypeScript is a superset of JavaScript, which means it extends JavaScript by
                                        adding new features.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-vs-js-venn.svg"
                                        alt="TypeScript vs JavaScript Venn Diagram" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>JavaScript</th>
                                                <th>TypeScript</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Typing</strong></td>
                                                <td>Dynamic typing</td>
                                                <td>Static typing (optional)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Error Detection</strong></td>
                                                <td>Runtime errors</td>
                                                <td>Compile-time errors</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Compilation</strong></td>
                                                <td>Interpreted directly</td>
                                                <td>Transpiled to JavaScript</td>
                                            </tr>
                                            <tr>
                                                <td><strong>IDE Support</strong></td>
                                                <td>Basic</td>
                                                <td>Advanced (IntelliSense, refactoring)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Learning Curve</strong></td>
                                                <td>Easier for beginners</td>
                                                <td>Requires understanding of types</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Remember:</strong> Every JavaScript file (.js) is a valid TypeScript
                                        file (.ts). You can rename any .js file to .ts and it will work!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: How TypeScript Works -->
                                    <h2>How TypeScript Works</h2>
                                    <p>TypeScript code cannot run directly in browsers or Node.js. It must be transpiled
                                        (compiled) into JavaScript first. Here's how the process works:</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-compilation-flow.svg"
                                        alt="TypeScript Compilation Process" class="diagram-image"
                                        style="max-width: 700px; margin: 2rem auto; display: block;">

                                    <ol>
                                        <li><strong>Write:</strong> You write TypeScript source code (.ts files) with
                                            type annotations</li>
                                        <li><strong>Compile:</strong> The TypeScript compiler (tsc) checks types and
                                            converts .ts to .js files</li>
                                        <li><strong>Run:</strong> The generated JavaScript runs in any JavaScript
                                            environment (browser, Node.js)</li>
                                    </ol>

                                    <div class="info-box">
                                        <strong>Example:</strong> You write TypeScript with type safety, the compiler
                                        catches errors during development, and the output is clean JavaScript that runs
                                        anywhere!
                                    </div>

                                    <!-- Section 4: Benefits of TypeScript -->
                                    <h2>Why Use TypeScript?</h2>

                                    <h3>1. Early Error Detection</h3>
                                    <p>TypeScript catches errors during development, not in production:</p>
                                    <pre><code class="language-typescript">// JavaScript - Error only at runtime
function greet(name) {
    return "Hello, " + name.toUpperCase();
}
greet(123); // Runtime error: name.toUpperCase is not a function

// TypeScript - Error caught immediately
function greet(name: string) {
    return "Hello, " + name.toUpperCase();
}
greet(123); // Compile error: Argument of type 'number' is not assignable to parameter of type 'string'</code></pre>

                                    <h3>2. Better Code Documentation</h3>
                                    <p>Types serve as inline documentation:</p>
                                    <pre><code class="language-typescript">interface User {
    id: number;
    name: string;
    email: string;
    isActive: boolean;
}

function createUser(user: User): void {
    // Function signature tells you exactly what's expected
}</code></pre>

                                    <h3>3. Enhanced IDE Experience</h3>
                                    <p>TypeScript provides:</p>
                                    <ul>
                                        <li>Intelligent code completion</li>
                                        <li>Accurate go-to-definition</li>
                                        <li>Safe refactoring</li>
                                        <li>Real-time error highlighting</li>
                                    </ul>

                                    <h3>4. Easier Refactoring</h3>
                                    <p>When you change a type, TypeScript shows you all the places that need updating.
                                        No more hunting for bugs after refactoring!</p>

                                    <!-- Section 5: TypeScript Versions -->
                                    <h2>TypeScript Versions</h2>
                                    <p>TypeScript is actively developed with regular updates. Here are some major
                                        milestones:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Version</th>
                                                <th>Year</th>
                                                <th>Key Features</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>TypeScript 1.0</td>
                                                <td>2014</td>
                                                <td>Initial release</td>
                                            </tr>
                                            <tr>
                                                <td>TypeScript 2.0</td>
                                                <td>2016</td>
                                                <td>Non-nullable types, readonly properties</td>
                                            </tr>
                                            <tr>
                                                <td>TypeScript 3.0</td>
                                                <td>2018</td>
                                                <td>Project references, unknown type</td>
                                            </tr>
                                            <tr>
                                                <td>TypeScript 4.0</td>
                                                <td>2020</td>
                                                <td>Variadic tuple types, labeled tuple elements</td>
                                            </tr>
                                            <tr>
                                                <td>TypeScript 5.0</td>
                                                <td>2023</td>
                                                <td>Decorators, const type parameters</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 6: Installation -->
                                    <h2>Installation</h2>
                                    <p>To start developing TypeScript applications, you need to install Node.js and
                                        TypeScript. Here's how:</p>

                                    <h3>1. Install Node.js</h3>
                                    <ul>
                                        <li>Visit <a href="https://nodejs.org/" target="_blank"
                                                rel="noopener">nodejs.org</a></li>
                                        <li>Download and install the LTS (Long Term Support) version</li>
                                        <li>Node.js includes npm (Node Package Manager)</li>
                                    </ul>

                                    <h3>2. Install TypeScript</h3>
                                    <p>Open terminal/command prompt and run:</p>
                                    <pre><code class="language-bash">npm install -g typescript</code></pre>

                                    <h3>3. Verify Installation</h3>
                                    <pre><code class="language-bash">tsc --version</code></pre>

                                    <div class="tip-box">
                                        <strong>VS Code:</strong> Visual Studio Code has excellent built-in TypeScript
                                        support. It's the recommended editor for TypeScript development.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using 'any' Everywhere</h4>
                                        <p><strong>Problem:</strong> Defeating the purpose of TypeScript by using 'any'
                                            type</p>
                                        <pre><code class="language-typescript">// Bad - loses all type safety
let data: any = fetchData();

// Good - use proper types
interface Data {
    id: number;
    name: string;
}
let data: Data = fetchData();</code></pre>
                                        <p><strong>Solution:</strong> Use specific types or 'unknown' when type is truly
                                            unknown</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Ignoring Compiler Errors</h4>
                                        <p><strong>Problem:</strong> Using @ts-ignore to suppress errors instead of
                                            fixing them</p>
                                        <p><strong>Solution:</strong> Address the root cause of type errors rather than
                                            hiding them</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>TypeScript is a typed superset of JavaScript that compiles to plain
                                                JavaScript</li>
                                            <li>It adds optional static typing to catch errors at compile-time</li>
                                            <li>TypeScript provides better IDE support with autocompletion and
                                                refactoring</li>
                                            <li>Any valid JavaScript is valid TypeScript - gradual adoption is possible
                                            </li>
                                            <li>TypeScript code must be transpiled to JavaScript before execution</li>
                                            <li>Install TypeScript globally using npm:
                                                <code>npm install -g typescript</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand what TypeScript is and its benefits, you're ready to set
                                        up your development environment! In the next lesson, you'll learn how to
                                        configure your project, set up tsconfig.json, and write your first TypeScript
                                        program.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/first-program.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="" />
                                                <jsp:param name="prevTitle" value="" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="First Program →" />
                                                <jsp:param name="currentLessonId" value="intro" />
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