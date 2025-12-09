<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-primitives" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Primitive Data Types (int, boolean, char, double) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java's 8 primitive data types: byte, short, int, long, float, double, boolean, and char. Understand their sizes, ranges, and default values with interactive examples.">
            <meta name="keywords"
                content="java primitive types, java int, java double, java boolean, java char, java data types, primitive vs reference, java variable sizes">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Primitive Data Types - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java's 8 primitive data types (int, float, boolean, etc.) with interactive code examples and diagrams.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/types-primitives.jsp">
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
        "name": "Java Primitive Data Types",
        "description": "Comprehensive guide to Java's 8 primitive data types.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Primitive types", "int vs long", "float vs double", "boolean"],
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

        <body class="tutorial-body no-preview" data-lesson="types-primitives">
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
                                    <span>Primitive Types</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Primitive Data Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Data types are the foundation of any programming language. They tell
                                        the compiler what kind of data a variable holds—whether it's a number, a
                                        character, or a true/false value. Java has <strong>8 primitive data
                                            types</strong> that act as the building blocks for data manipulation.</p>

                                    <!-- Section 1: The 8 Primitive Types -->
                                    <h2>The 8 Primitive Data Types</h2>
                                    <p>Java is a strongly-typed language, meaning every variable must have a declared
                                        type. The 8 primitive types are categorized into four groups:</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-primitive-types.svg"
                                        alt="Java Primitive Data Types Comparison" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Group</th>
                                                <th>Size</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>byte</code></td>
                                                <td>Integer</td>
                                                <td>1 byte</td>
                                                <td>Very small logical numbers (-128 to 127)</td>
                                            </tr>
                                            <tr>
                                                <td><code>short</code></td>
                                                <td>Integer</td>
                                                <td>2 bytes</td>
                                                <td>Small numbers (-32,768 to 32,767)</td>
                                            </tr>
                                            <tr>
                                                <td><code>int</code></td>
                                                <td>Integer</td>
                                                <td>4 bytes</td>
                                                <td>Standard integer (default for whole numbers)</td>
                                            </tr>
                                            <tr>
                                                <td><code>long</code></td>
                                                <td>Integer</td>
                                                <td>8 bytes</td>
                                                <td>Large integers (requires 'L' suffix)</td>
                                            </tr>
                                            <tr>
                                                <td><code>float</code></td>
                                                <td>Floating Point</td>
                                                <td>4 bytes</td>
                                                <td>Decimal numbers (requires 'f' suffix)</td>
                                            </tr>
                                            <tr>
                                                <td><code>double</code></td>
                                                <td>Floating Point</td>
                                                <td>8 bytes</td>
                                                <td>Precise decimals (default for decimals)</td>
                                            </tr>
                                            <tr>
                                                <td><code>boolean</code></td>
                                                <td>Other</td>
                                                <td>1 bit*</td>
                                                <td>True or false values</td>
                                            </tr>
                                            <tr>
                                                <td><code>char</code></td>
                                                <td>Other</td>
                                                <td>2 bytes</td>
                                                <td>Single character (Unicode)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <p class="text-small">* The size of boolean is not precisely defined by the JVM
                                        specification, but conceptually represents 1 bit of information.</p>

                                    <!-- Section 2: Integer Types -->
                                    <h2>Integer Types (Whole Numbers)</h2>
                                    <p>Integer types store whole numbers without decimals. Use <code>int</code> for most
                                        counting needs. Use <code>long</code> when <code>int</code> isn't big enough.
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/types-primitives.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-primitives" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>The 'L' Suffix:</strong> When declaring a <code>long</code> variable,
                                        you MUST append an 'L' or 'l' to the number if it exceeds the range of
                                        <code>int</code>. Otherwise, the compiler treats it as an integer and throws an
                                        error if it's too large.
                                        <br><code>long bigNum = 10000000000L; // Correct</code>
                                    </div>

                                    <!-- Section 3: Floating Point Types -->
                                    <h2>Floating Point Types (Decimals)</h2>
                                    <p>Floating point types store numbers with fractional parts. <code>double</code> is
                                        the default choice for modern applications as it's more precise than
                                        <code>float</code>.
                                    </p>

                                    <ul>
                                        <li><strong>float:</strong> Single precision (6-7 significant decimal digits).
                                            Suffix 'f' required (e.g., <code>3.14f</code>).</li>
                                        <li><strong>double:</strong> Double precision (15-16 significant decimal
                                            digits). No suffix needed.</li>
                                    </ul>

                                    <div class="mistake-box">
                                        <h4>Financial Calculations</h4>
                                        <p><strong>Never use float or double for currency!</strong> Floating-point
                                            arithmetic can have rounding errors (e.g., 0.1 + 0.2 might equal
                                            0.30000000000000004). For precise calculations like money, use the
                                            <code>BigDecimal</code> class.
                                        </p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 4: Boolean & Char -->
                                    <h2>Boolean & Character Types</h2>

                                    <h3>Boolean</h3>
                                    <p>The <code>boolean</code> data type has only two possible values:
                                        <code>true</code> or <code>false</code>. It's essential for logic and decision
                                        making.
                                    </p>
                                    <pre><code class="language-java">boolean isActive = true;
boolean isGameOver = false;</code></pre>

                                    <h3>Char</h3>
                                    <p>The <code>char</code> data type stores a single 16-bit Unicode character. It must
                                        be enclosed in <strong>single quotes</strong> <code>' '</code>.</p>
                                    <pre><code class="language-java">char grade = 'A';
char symbol = '$';</code></pre>

                                    <!-- Section 5: Size & Range Demo -->
                                    <h2>Size & Range Demonstration</h2>
                                    <p>Let's use Java's wrapper classes to inspect the minimum and maximum values for
                                        each numeric type.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/types-sizes.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-sizes" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>int</strong> is the go-to type for whole numbers.</li>
                                            <li><strong>double</strong> is the default for decimal numbers.</li>
                                            <li><strong>boolean</strong> stores simply true or false.</li>
                                            <li><strong>char</strong> stores a single character using single quotes.
                                            </li>
                                            <li>Remember suffixes: <strong>L</strong> for long literals,
                                                <strong>f</strong> for float literals.
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you know the available types, you need to learn how to store them! In
                                        the next lesson, we'll dive deep into <strong>Variables</strong>—how to declare,
                                        initialize, and name them correctly.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/variables-declaration.jsp" ; String
                                            prevLinkUrl=request.getContextPath() + "/tutorials/java/syntax-basics.jsp" ;
                                            %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Syntax Basics" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Variables →" />
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
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>