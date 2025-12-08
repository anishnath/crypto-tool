<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings-basics" );
        request.setAttribute("currentModule", "Strings & Text Processing" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <!-- 1. META TAGS -->
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>String Basics - Bash Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the fundamentals of strings in Bash scripting. Covers string assignment, quoting mechanisms (single vs double quotes), concatenation, and calculating string length.">
            <meta name="keywords"
                content="bash strings, bash quoting, bash string length, bash concatenation, shell scripting strings">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="String Basics - Bash Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Learn the fundamentals of strings in Bash scripting. Covers string assignment, quoting mechanisms, and concatenation.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <!-- 2. RESOURCES -->
            <link rel="canonical" href="https://8gwifi.org/tutorials/bash/strings-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <!-- 3. THEME DETECTION -->
            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>

            <!-- 4. STRUCTURED DATA -->
            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Bash String Basics",
        "description": "Learn the fundamentals of strings in Bash scripting, including quoting and concatenation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["String assignment", "Quoting mechanisms", "String concatenation", "String length"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="strings-basics">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-bash.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <!-- 5. BREADCRUMB -->
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>String Basics</span>
                                </nav>

                                <!-- 6. LESSON HEADER -->
                                <header class="lesson-header">
                                    <h1 class="lesson-title">String Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <!-- 7. LESSON BODY -->
                                <div class="lesson-body">

                                    <p class="lead">Strings are the most fundamental data type in Bash scripting. Unlike
                                        many other programming languages, Bash treats almost everything as a string
                                        unless specified otherwise. In this lesson, we'll cover how to define strings,
                                        the importance of quoting, and basic operations like concatenation and length
                                        calculation.</p>

                                    <h2>Defining Strings</h2>
                                    <p>In Bash, you can assign a string to a variable simply by using the equals sign
                                        <code>=</code>. There should be no spaces around the equals sign.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="bash/strings-basics.sh" />
                                        <jsp:param name="language" value="bash" />
                                        <jsp:param name="editorId" value="compiler-strings-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Note:</strong> If your string contains spaces, you <em>must</em> wrap it
                                        in quotes. For example, <code>name=John Doe</code> will cause an error, but
                                        <code>name="John Doe"</code> works correctly.
                                    </div>

                                    <h2>Quoting Mechanisms</h2>
                                    <p>Bash provides three main ways to quote strings, each with different behaviors
                                        regarding variable expansion and special characters.</p>

                                    <ul>
                                        <li><strong>Double Quotes (<code>" "</code>)</strong>: Allow variable expansion
                                            (<code>$var</code>) and command substitution (<code>$(cmd)</code>).</li>
                                        <li><strong>Single Quotes (<code>' '</code>)</strong>: Treat everything
                                            literally. No expansion occurs.</li>
                                        <li><strong>Backticks (<code>` `</code>)</strong>: Used for command substitution
                                            (legacy). It's recommended to use <code>$(...)</code> instead.</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="bash/strings-quoting.sh" />
                                        <jsp:param name="language" value="bash" />
                                        <jsp:param name="editorId" value="compiler-strings-quoting" />
                                    </jsp:include>

                                    <div class="mistake-box">
                                        <strong>Common Mistake:</strong> Using single quotes when you want to use a
                                        variable.
                                        <br>
                                        <code>echo 'Hello $USER'</code> prints literally <code>Hello $USER</code>.
                                        <br>
                                        <code>echo "Hello $USER"</code> prints <code>Hello anish</code> (or your
                                        username).
                                    </div>

                                    <h2>String Concatenation</h2>
                                    <p>Concatenating strings in Bash is straightforward: just place them next to each
                                        other.</p>
                                    <pre><code class="language-bash">part1="Hello"
part2="World"
combined="$part1 $part2"  # Result: "Hello World"
combined2="\${part1}World" # Result: "HelloWorld" (using braces to separate variable name)</code></pre>

                                    <h2>String Length</h2>
                                    <p>You can find the length of a string stored in a variable using the
                                        <code>\${#variable}</code> syntax.</p>
                                    <pre><code class="language-bash">text="abcdef"
echo \${#text}  # Output: 6</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                        <jsp:param name="responsive" value="true" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>var="value"</code> to assign strings. No spaces around
                                                <code>=</code>.</li>
                                            <li>Use <strong>double quotes</strong> when you need variable expansion.
                                            </li>
                                            <li>Use <strong>single quotes</strong> for literal strings.</li>
                                            <li>Use <code>\${#var}</code> to get the length of a string.</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand the basics, let's look at how to modify and extract parts
                                        of strings in the next lesson on <a href="strings-manipulation.jsp">String
                                            Manipulation</a>.</p>

                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <!-- 8. NAVIGATION -->
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="variables-arrays.jsp" />
                                    <jsp:param name="prevTitle" value="Arrays" />
                                    <jsp:param name="nextLink" value="strings-manipulation.jsp" />
                                    <jsp:param name="nextTitle" value="String Manipulation" />
                                    <jsp:param name="currentLessonId" value="strings-basics" />
                                </jsp:include>

                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>