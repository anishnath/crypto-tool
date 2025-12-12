<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators" );
        request.setAttribute("currentModule", "Operators & Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Operators in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Lua operators including arithmetic, relational, logical, concatenation, and length operators. Master operator precedence and short-circuit evaluation.">
            <meta name="keywords"
                content="lua operators, arithmetic operators, logical operators, relational operators, lua concatenation, operator precedence, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Operators in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Master Lua operators: arithmetic, relational, logical, and more. Learn operator precedence and best practices.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/operators.jsp">
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
        "name": "Operators in Lua",
        "description": "Learn about Lua operators including arithmetic, relational, logical, concatenation, and length operators.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/operators.jsp",
        "keywords": "lua operators, arithmetic operators, logical operators, relational operators",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Arithmetic operators", "Relational operators", "Logical operators", "Operator precedence"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "description": "Complete Lua programming course from beginner to advanced",
            "url": "https://8gwifi.org/tutorials/lua/",
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            }
        }
    }
    </script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Tutorials",
                "item": "https://8gwifi.org/tutorials/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Lua",
                "item": "https://8gwifi.org/tutorials/lua/"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Operators"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="operators">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-lua.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/">Lua</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Operators in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Operators are symbols that perform operations on values and
                                        variables.
                                        Lua provides a comprehensive set of operators for arithmetic, comparison, logic,
                                        and
                                        string manipulation. Understanding operators is fundamental to writing effective
                                        Lua
                                        code. Let's explore all the operators Lua has to offer!</p>

                                    <!-- Arithmetic Operators -->
                                    <h2>Arithmetic Operators</h2>
                                    <p>Lua supports all standard arithmetic operations:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>+</code></td>
                                                <td>Addition</td>
                                                <td><code>10 + 5</code></td>
                                                <td>15</td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Subtraction</td>
                                                <td><code>10 - 5</code></td>
                                                <td>5</td>
                                            </tr>
                                            <tr>
                                                <td><code>*</code></td>
                                                <td>Multiplication</td>
                                                <td><code>10 * 5</code></td>
                                                <td>50</td>
                                            </tr>
                                            <tr>
                                                <td><code>/</code></td>
                                                <td>Division</td>
                                                <td><code>10 / 5</code></td>
                                                <td>2</td>
                                            </tr>
                                            <tr>
                                                <td><code>%</code></td>
                                                <td>Modulo (remainder)</td>
                                                <td><code>10 % 3</code></td>
                                                <td>1</td>
                                            </tr>
                                            <tr>
                                                <td><code>^</code></td>
                                                <td>Exponentiation</td>
                                                <td><code>2 ^ 3</code></td>
                                                <td>8</td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Unary negation</td>
                                                <td><code>-10</code></td>
                                                <td>-10</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Try It Yourself</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/operators-all.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-arithmetic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> The <code>^</code> operator is for exponentiation, not XOR
                                        like
                                        in some other languages. Lua doesn't have built-in bitwise operators in Lua 5.1,
                                        but
                                        they were added in Lua 5.2+.
                                    </div>

                                    <!-- Relational Operators -->
                                    <h2>Relational Operators</h2>
                                    <p>Relational operators compare two values and return <code>true</code> or
                                        <code>false</code>:
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>==</code></td>
                                                <td>Equal to</td>
                                                <td><code>5 == 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>~=</code></td>
                                                <td>Not equal to</td>
                                                <td><code>5 ~= 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;</code></td>
                                                <td>Less than</td>
                                                <td><code>3 &lt; 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;</code></td>
                                                <td>Greater than</td>
                                                <td><code>5 &gt; 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;=</code></td>
                                                <td>Less than or equal</td>
                                                <td><code>3 &lt;= 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;=</code></td>
                                                <td>Greater than or equal</td>
                                                <td><code>5 &gt;= 5</code></td>
                                                <td>true</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Lua uses <code>~=</code> for "not equal", not
                                        <code>!=</code> like many other languages. Also, use <code>==</code> for
                                        comparison,
                                        not <code>=</code> (which is assignment).
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Logical Operators -->
                                    <h2>Logical Operators</h2>
                                    <p>Logical operators work with boolean values and use short-circuit evaluation:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>and</code></td>
                                                <td>Logical AND</td>
                                                <td><code>true and false</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>or</code></td>
                                                <td>Logical OR</td>
                                                <td><code>true or false</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>not</code></td>
                                                <td>Logical NOT</td>
                                                <td><code>not true</code></td>
                                                <td>false</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Short-Circuit Evaluation</h3>
                                    <p>Lua uses short-circuit evaluation for <code>and</code> and <code>or</code>:</p>
                                    <ul>
                                        <li><code>and</code> returns the first operand if it's false, otherwise the
                                            second</li>
                                        <li><code>or</code> returns the first operand if it's true, otherwise the second
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/operators-shortcircuit.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-logical" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use short-circuit evaluation for default values:
                                        <code>local value = input or "default"</code>. This is a common Lua idiom!
                                    </div>

                                    <!-- Other Operators -->
                                    <h2>String Concatenation</h2>
                                    <p>Lua uses <code>..</code> (two dots) for string concatenation:</p>

                                    <pre><code class="language-lua">local greeting = "Hello" .. " " .. "World"
print(greeting)  -- Hello World

local name = "Alice"
local message = "Welcome, " .. name .. "!"
print(message)  -- Welcome, Alice!</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Numbers are automatically converted to strings when
                                        concatenated:
                                        <code>"Score: " .. 100</code> works fine!
                                    </div>

                                    <h2>Length Operator</h2>
                                    <p>The <code>#</code> operator returns the length of strings and tables:</p>

                                    <pre><code class="language-lua">local str = "Hello"
print(#str)  -- 5

local arr = {10, 20, 30, 40}
print(#arr)  -- 4</code></pre>

                                    <!-- Operator Precedence -->
                                    <h2>Operator Precedence</h2>
                                    <p>When multiple operators appear in an expression, Lua follows this precedence
                                        (highest to
                                        lowest):</p>

                                    <ol>
                                        <li><code>^</code> (exponentiation)</li>
                                        <li><code>not</code>, <code>#</code>, <code>-</code> (unary)</li>
                                        <li><code>*</code>, <code>/</code>, <code>%</code></li>
                                        <li><code>+</code>, <code>-</code></li>
                                        <li><code>..</code> (concatenation)</li>
                                        <li><code>&lt;</code>, <code>&gt;</code>, <code>&lt;=</code>,
                                            <code>&gt;=</code>,
                                            <code>~=</code>, <code>==</code>
                                        </li>
                                        <li><code>and</code></li>
                                        <li><code>or</code></li>
                                    </ol>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/operators-precedence.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-precedence" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use parentheses to make your intentions clear,
                                        even if
                                        not strictly necessary. <code>(a + b) * c</code> is clearer than <code>a + b *
                                            c</code>.
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try solving these operator challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-operators.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Arithmetic operators: <code>+</code>, <code>-</code>, <code>*</code>,
                                                <code>/</code>, <code>%</code>, <code>^</code>
                                            </li>
                                            <li>Relational operators: <code>==</code>, <code>~=</code>,
                                                <code>&lt;</code>,
                                                <code>&gt;</code>, <code>&lt;=</code>, <code>&gt;=</code>
                                            </li>
                                            <li>Logical operators: <code>and</code>, <code>or</code>, <code>not</code>
                                            </li>
                                            <li>String concatenation with <code>..</code></li>
                                            <li>Length operator <code>#</code></li>
                                            <li>Operator precedence and short-circuit evaluation</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand operators, you're ready to learn about
                                        <strong>strings</strong> in Lua. In the next lesson, we'll explore string
                                        manipulation,
                                        pattern matching, and the powerful string library. Let's continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="variables.jsp" />
                                    <jsp:param name="prevTitle" value="Variables & Types" />
                                    <jsp:param name="nextLink" value="strings.jsp" />
                                    <jsp:param name="nextTitle" value="Strings" />
                                    <jsp:param name="currentLessonId" value="operators" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/lua.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>