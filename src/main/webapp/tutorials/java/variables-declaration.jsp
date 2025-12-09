<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "variables-declaration" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Variables: Declaration, Initialization & Scope - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to declare, initialize, and use variables in Java. Understand variable scope (local, instance, static), the final keyword for constants, and type inference with var.">
            <meta name="keywords"
                content="java variables, java variable declaration, java variable scope, java final keyword, java var keyword, local vs instance variables">

            <meta property="og:type" content="article">
            <meta property="og:title"
                content="Java Variables: Declaration, Initialization & Scope - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java variables: how to declare them, assign values, and understand their scope.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/variables-declaration.jsp">
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
        "name": "Java Variables",
        "description": "Learn about Java variable declaration, initialization, and scope.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Variable declaration", "Variable scope", "Final constants", "Var keyword"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Java Tutorial",
            "url": "https://8gwifi.org/tutorials/java/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="variables-declaration">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Variables</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Variables</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A variable is like a container that holds data values. In Java,
                                        every variable has a specific <strong>type</strong> (which determines what kind
                                        of data it can hold) and a <strong>name</strong> (how you refer to it).
                                        Understanding how to declare, initialize, and manage variables is the first step
                                        to becoming a Java developer.</p>

                                    <!-- Section 1: Declaration & Initialization -->
                                    <h2>Declaration & Initialization</h2>
                                    <p>To use a variable in Java, you must first declared it and then initialize it with
                                        a value.</p>

                                    <pre><code class="language-java">// Syntax: Type variableName = value;
int age = 25;</code></pre>

                                    <p>There are three ways to do this:</p>
                                    <ol>
                                        <li><strong>Declaration only:</strong> <code>int score;</code> (Allocates
                                            memory)</li>
                                        <li><strong>Initialization:</strong> <code>score = 100;</code> (Assigns value)
                                        </li>
                                        <li><strong>Both together:</strong> <code>int score = 100;</code> (Most common)
                                        </li>
                                    </ol>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/variables-declaration.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-vars" />
                                    </jsp:include>

                                    <!-- Section 2: Variable Naming Rules -->
                                    <h2>Variable Naming Rules</h2>
                                    <p>Java enforces strict rules for naming variables (identifiers):</p>
                                    <ul>
                                        <li>Must start with a letter, underscore (<code>_</code>), or dollar sign
                                            (<code>$</code>).</li>
                                        <li>Cannot start with a digit.</li>
                                        <li>Case-sensitive (<code>age</code> and <code>Age</code> are different).</li>
                                        <li>Cannot use Java reserved keywords (like <code>int</code>,
                                            <code>class</code>, <code>public</code>).
                                        </li>
                                    </ul>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use <strong>camelCase</strong> for variable
                                        names. Start with a lowercase letter and capitalize each subsequent word.
                                        <br>Examples: <code>userName</code>, <code>accountBalance</code>,
                                        <code>isLoggedIn</code>.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Variable Scope -->
                                    <h2>Variable Scope</h2>
                                    <p>The <strong>scope</strong> of a variable determines where it can be accessed
                                        within your code. Java has three main types of variables based on scope:</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-variable-scope.svg"
                                        alt="Java Variable Scope Diagram" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <ul class="comparison-list">
                                        <li>
                                            <strong>Local Variables:</strong> Declared inside a method or block.
                                            <br><span class="text-small">Scope: Only inside that method/block. Recreated
                                                every time the method runs.</span>
                                        </li>
                                        <li>
                                            <strong>Instance Variables:</strong> Declared inside a class but outside
                                            methods.
                                            <br><span class="text-small">Scope: Accessible by all methods in the class.
                                                Specific to an object instance.</span>
                                        </li>
                                        <li>
                                            <strong>Static (Class) Variables:</strong> Declared with <code>static</code>
                                            keyword.
                                            <br><span class="text-small">Scope: Global to the class. Shared by all
                                                instances.</span>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/variables-scope.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-scope" />
                                    </jsp:include>

                                    <!-- Section 4: The 'final' Keyword -->
                                    <h2>Constants (final Keyword)</h2>
                                    <p>If you want a variable to be constant (meaning its value cannot be changed after
                                        initialization), use the <code>final</code> keyword.</p>
                                    <pre><code class="language-java">final float PI = 3.14f;
// PI = 3.15f; // Compilation Error!</code></pre>

                                    <div class="info-box">
                                        <strong>Convention:</strong> Constant variable names are usually written in
                                        <strong>UPPER_SNAKE_CASE</strong>.
                                        <br>Example: <code>MAX_USER_LIMIT</code>, <code>DEFAULT_TIMEOUT</code>.
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Variables are containers for data with a specific <strong>Type</strong>
                                                and <strong>Name</strong>.</li>
                                            <li>Use <strong>camelCase</strong> for naming variables.</li>
                                            <li><strong>Local variables</strong> exist only inside their block.</li>
                                            <li><strong>Instance variables</strong> belong to an object.</li>
                                            <li><strong>Static variables</strong> belong to the class.</li>
                                            <li>Use <strong>final</strong> to create constants that cannot change.</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Sometimes you need to convert data from one type to another—like turning an
                                        integer into a double. In the next lesson, we'll learn about <strong>Type
                                            Casting</strong> and how to handle data conversion safely.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/types-casting.jsp" ; String
                                            prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/types-primitives.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Primitive Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Type Casting →" />
                                                <jsp:param name="currentLessonId" value="variables-declaration" />
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
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>