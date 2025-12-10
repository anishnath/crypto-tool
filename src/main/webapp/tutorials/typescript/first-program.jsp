<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "first-program" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>First TypeScript Program - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: write your first TypeScript program! Learn Node.js setup, TypeScript installation, tsconfig.json, compilation (tsc), and execution....">
            <meta name="keywords"
                content="typescript hello world, typescript first program, tsc compile, typescript setup, node.js typescript, typescript tutorial, learn typescript">

            <meta property="og:type" content="article">
            <meta property="og:title" content="First TypeScript Program - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description" content="Write your first TypeScript program with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/first-program.jsp">
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
        "name": "First TypeScript Program",
        "description": "Write your first TypeScript program. Learn setup, compilation, and execution.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["TypeScript setup", "Hello World", "tsc compiler", "Node.js", "TypeScript execution"],
        "timeRequired": "PT25M",
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

        <body class="tutorial-body no-preview" data-lesson="first-program">
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
                                    <span>First Program</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">First TypeScript Program</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Welcome to your first TypeScript program! In this lesson, you'll set
                                        up your development environment, write the classic "Hello, World!" program, and
                                        learn how to compile and execute TypeScript code. You'll understand the
                                        TypeScript compiler (tsc) and see how TypeScript code transforms into
                                        JavaScript.</p>

                                    <!-- Section 1: Environment Setup -->
                                    <h2>Environment Setup</h2>
                                    <p>Before writing TypeScript code, you need to install Node.js and TypeScript on
                                        your system.</p>

                                    <h3>Step 1: Install Node.js</h3>
                                    <p>TypeScript requires Node.js and npm (Node Package Manager). Download and install
                                        from <a href="https://nodejs.org/" target="_blank"
                                            rel="noopener">nodejs.org</a>.</p>

                                    <ul>
                                        <li><strong>Windows:</strong> Download the installer and run it</li>
                                        <li><strong>macOS:</strong> Use Homebrew: <code>brew install node</code> or
                                            download from nodejs.org</li>
                                        <li><strong>Linux:</strong> Use your package manager:
                                            <code>sudo apt install nodejs npm</code></li>
                                    </ul>

                                    <p>Verify the installation:</p>
                                    <pre><code class="language-bash">node --version
npm --version</code></pre>

                                    <h3>Step 2: Install TypeScript</h3>
                                    <p>Install TypeScript globally using npm:</p>
                                    <pre><code class="language-bash">npm install -g typescript</code></pre>

                                    <p>Verify TypeScript installation:</p>
                                    <pre><code class="language-bash">tsc --version</code></pre>

                                    <div class="tip-box">
                                        <strong>Recommended Editor:</strong> Visual Studio Code has excellent built-in
                                        TypeScript support with IntelliSense, debugging, and refactoring. Download it
                                        from <a href="https://code.visualstudio.com/" target="_blank"
                                            rel="noopener">code.visualstudio.com</a>.
                                    </div>

                                    <!-- Section 2: Hello World Program -->
                                    <h2>Hello, World!</h2>
                                    <p>The traditional first program in any programming language is "Hello, World!" - a
                                        simple program that displays text. Let's write it in TypeScript!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/first-hello-world.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-hello" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li>TypeScript files use the <code>.ts</code> extension</li>
                                            <li><code>console.log()</code> prints output to the console</li>
                                            <li>Strings are enclosed in quotes (single, double, or backticks)</li>
                                            <li>Statements end with a semicolon (optional but recommended)</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Compilation and Execution -->
                                    <h2>Compilation and Execution</h2>
                                    <p>TypeScript code must be compiled to JavaScript before it can run. Here's the
                                        process:</p>

                                    <h3>Step 1: Create a TypeScript File</h3>
                                    <p>Create a file named <code>hello.ts</code>:</p>
                                    <pre><code class="language-typescript">console.log("Hello, TypeScript!");</code></pre>

                                    <h3>Step 2: Compile with tsc</h3>
                                    <p>Use the TypeScript compiler to convert <code>.ts</code> to <code>.js</code>:</p>
                                    <pre><code class="language-bash">tsc hello.ts</code></pre>

                                    <p>This creates a <code>hello.js</code> file containing the compiled JavaScript:</p>
                                    <pre><code class="language-javascript">console.log("Hello, TypeScript!");</code></pre>

                                    <h3>Step 3: Execute with Node.js</h3>
                                    <p>Run the compiled JavaScript file:</p>
                                    <pre><code class="language-bash">node hello.js</code></pre>

                                    <p><strong>Output:</strong></p>
                                    <pre><code>Hello, TypeScript!</code></pre>

                                    <div class="tip-box">
                                        <strong>Quick Execution:</strong> Use <code>ts-node</code> to compile and run
                                        TypeScript files in one step:
                                        <pre><code class="language-bash">npm install -g ts-node
ts-node hello.ts</code></pre>
                                    </div>

                                    <!-- Section 4: Adding Types -->
                                    <h2>Adding Types</h2>
                                    <p>The real power of TypeScript comes from adding type annotations. Let's enhance
                                        our program:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/first-with-types.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-types" />
                                    </jsp:include>

                                    <h3>Type Annotations Explained</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Code</th>
                                                <th>Explanation</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>name: string</code></td>
                                                <td>Variable <code>name</code> must be a string</td>
                                            </tr>
                                            <tr>
                                                <td><code>age: number</code></td>
                                                <td>Variable <code>age</code> must be a number</td>
                                            </tr>
                                            <tr>
                                                <td><code>greet(person: string): void</code></td>
                                                <td>Function takes a string parameter and returns nothing</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Type Safety in Action:</strong> Try changing <code>age</code> to a
                                        string like <code>"25"</code> in the editor above. TypeScript will show an error
                                        because we declared it as a number!
                                    </div>

                                    <!-- Section 5: tsconfig.json -->
                                    <h2>TypeScript Configuration (tsconfig.json)</h2>
                                    <p>For larger projects, use a <code>tsconfig.json</code> file to configure the
                                        TypeScript compiler:</p>

                                    <pre><code class="language-bash">tsc --init</code></pre>

                                    <p>This creates a <code>tsconfig.json</code> file with default settings. Here's a
                                        basic configuration:</p>

                                    <pre><code class="language-json">{
  "compilerOptions": {
    "target": "ES2020",           // JavaScript version to compile to
    "module": "commonjs",          // Module system
    "outDir": "./dist",            // Output directory for .js files
    "rootDir": "./src",            // Input directory for .ts files
    "strict": true,                // Enable all strict type checking
    "esModuleInterop": true,       // Better CommonJS/ES module compatibility
    "skipLibCheck": true,          // Skip type checking of declaration files
    "forceConsistentCasingInFileNames": true
  }
}</code></pre>

                                    <h3>Common Compiler Options</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Option</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>target</code></td>
                                                <td>ECMAScript version for output (ES5, ES2015, ES2020, etc.)</td>
                                            </tr>
                                            <tr>
                                                <td><code>module</code></td>
                                                <td>Module system (commonjs, es2015, esnext)</td>
                                            </tr>
                                            <tr>
                                                <td><code>strict</code></td>
                                                <td>Enable all strict type-checking options</td>
                                            </tr>
                                            <tr>
                                                <td><code>outDir</code></td>
                                                <td>Output directory for compiled files</td>
                                            </tr>
                                            <tr>
                                                <td><code>rootDir</code></td>
                                                <td>Root directory of source files</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <p>With <code>tsconfig.json</code>, you can compile all files by simply running:</p>
                                    <pre><code class="language-bash">tsc</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to compile</h4>
                                        <pre><code class="language-bash"># Wrong - trying to run .ts file directly with node
node hello.ts

# Correct - compile first, then run
tsc hello.ts
node hello.js

# Or use ts-node
ts-node hello.ts</code></pre>
                                        <p><strong>Error:</strong> <code>SyntaxError: Unexpected token ':'</code></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Type mismatch</h4>
                                        <pre><code class="language-typescript">// Wrong
let age: number = "25";  // Error: Type 'string' is not assignable to type 'number'

// Correct
let age: number = 25;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. TypeScript not installed globally</h4>
                                        <pre><code class="language-bash"># Error: tsc: command not found

# Solution: Install TypeScript globally
npm install -g typescript</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Personalize Your Program</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a TypeScript program that introduces yourself
                                            with type safety!</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create variables for your name (string), age (number), and favorite
                                                language (string)</li>
                                            <li>Create a function that takes these parameters and prints an introduction
                                            </li>
                                            <li>Use proper type annotations</li>
                                            <li>Call the function with your information</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile"
                                                value="typescript/exercises/ex-first-program.ts" />
                                            <jsp:param name="language" value="typescript" />
                                            <jsp:param name="editorId" value="exercise-first" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>💡 Hint</summary>
                                            <p>Start with a function signature like:
                                                <code>function introduce(name: string, age: number, language: string): void</code>
                                            </p>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Install Node.js and TypeScript: <code>npm install -g typescript</code>
                                            </li>
                                            <li>TypeScript files use the <code>.ts</code> extension</li>
                                            <li>Compile with <code>tsc filename.ts</code> to create a <code>.js</code>
                                                file</li>
                                            <li>Execute with <code>node filename.js</code></li>
                                            <li>Type annotations add type safety:
                                                <code>let name: string = "Alice";</code></li>
                                            <li>Use <code>tsconfig.json</code> to configure compiler options</li>
                                            <li>Use <code>ts-node</code> for quick development without manual
                                                compilation</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've written your first TypeScript program and learned about
                                        the compilation process. Now that you understand the basics, let's dive into
                                        TypeScript's type system - starting with primitive types like strings, numbers,
                                        and booleans.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/intro.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-primitives.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Introduction" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Primitive Types →" />
                                                <jsp:param name="currentLessonId" value="first-program" />
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