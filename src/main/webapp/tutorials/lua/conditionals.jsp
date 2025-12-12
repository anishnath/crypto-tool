<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "conditionals" );
        request.setAttribute("currentModule", "Operators & Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Conditionals in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Lua conditional statements: if, elseif, else. Master decision-making in your code with practical examples and best practices.">
            <meta name="keywords"
                content="lua conditionals, if statement, elseif, else, lua control flow, decision making, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Conditionals in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Master conditional statements in Lua: if, elseif, else. Learn to make decisions in your code.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/conditionals.jsp">
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
        "name": "Conditionals in Lua",
        "description": "Learn Lua conditional statements: if, elseif, else for decision-making in your code.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/conditionals.jsp",
        "keywords": "lua conditionals, if statement, elseif, control flow",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["if statements", "elseif", "else", "nested conditionals", "truthiness"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "url": "https://8gwifi.org/tutorials/lua/"
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
                "name": "Conditionals"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="conditionals">
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
                                    <span>Conditionals</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Conditionals in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Conditional statements allow your program to make decisions and
                                        execute
                                        different code based on conditions. They're essential for creating dynamic,
                                        responsive
                                        programs. Lua provides <code>if</code>, <code>elseif</code>, and
                                        <code>else</code>
                                        statements for controlling program flow. Let's learn how to use them
                                        effectively!
                                    </p>

                                    <!-- Basic if Statement -->
                                    <h2>The if Statement</h2>
                                    <p>The simplest conditional statement checks if a condition is true:</p>

                                    <pre><code class="language-lua">local age = 18

if age >= 18 then
    print("You are an adult")
end</code></pre>

                                    <div class="info-box">
                                        <strong>Syntax:</strong>
                                        <ul>
                                            <li>Start with <code>if</code> followed by a condition</li>
                                            <li>Use <code>then</code> after the condition</li>
                                            <li>Write the code to execute if true</li>
                                            <li>End with <code>end</code></li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/conditionals-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-if" />
                                    </jsp:include>

                                    <!-- if-else Statement -->
                                    <h2>The if-else Statement</h2>
                                    <p>Use <code>else</code> to execute code when the condition is false:</p>

                                    <pre><code class="language-lua">local temperature = 25

if temperature > 30 then
    print("It's hot!")
else
    print("It's not too hot")
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/conditionals-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-ifelse" />
                                    </jsp:include>

                                    <!-- if-elseif-else Statement -->
                                    <h2>The if-elseif-else Statement</h2>
                                    <p>Use <code>elseif</code> to check multiple conditions:</p>

                                    <pre><code class="language-lua">local score = 85

if score >= 90 then
    print("Grade: A")
elseif score >= 80 then
    print("Grade: B")
elseif score >= 70 then
    print("Grade: C")
elseif score >= 60 then
    print("Grade: D")
else
    print("Grade: F")
end</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Lua checks conditions from top to bottom and executes the
                                        first
                                        one that's true. Once a condition matches, the rest are skipped!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/conditionals-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-elseif" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Truthiness -->
                                    <h2>Truthiness in Lua</h2>
                                    <p>In Lua, only <code>false</code> and <code>nil</code> are considered false.
                                        Everything
                                        else is true!</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Value</th>
                                                <th>Truthiness</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>false</code></td>
                                                <td>❌ False</td>
                                            </tr>
                                            <tr>
                                                <td><code>nil</code></td>
                                                <td>❌ False</td>
                                            </tr>
                                            <tr>
                                                <td><code>true</code></td>
                                                <td>✅ True</td>
                                            </tr>
                                            <tr>
                                                <td><code>0</code></td>
                                                <td>✅ True</td>
                                            </tr>
                                            <tr>
                                                <td><code>""</code> (empty string)</td>
                                                <td>✅ True</td>
                                            </tr>
                                            <tr>
                                                <td><code>{}</code> (empty table)</td>
                                                <td>✅ True</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Unlike many languages, <code>0</code> and empty
                                        strings are
                                        <strong>true</strong> in Lua! Only <code>false</code> and <code>nil</code> are
                                        false.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/conditionals-complex.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-truthiness" />
                                    </jsp:include>

                                    <!-- Nested Conditionals -->
                                    <h2>Nested Conditionals</h2>
                                    <p>You can nest <code>if</code> statements inside each other:</p>

                                    <pre><code class="language-lua">local age = 25
local hasLicense = true

if age >= 18 then
    if hasLicense then
        print("You can drive")
    else
        print("You need a license")
    end
else
    print("You're too young to drive")
end</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Avoid deep nesting. Use logical operators
                                        (<code>and</code>, <code>or</code>) to combine conditions instead:
                                        <pre><code class="language-lua">if age >= 18 and hasLicense then
    print("You can drive")
end</code></pre>
                                    </div>

                                    <!-- Logical Operators in Conditions -->
                                    <h2>Combining Conditions</h2>
                                    <p>Use logical operators to create complex conditions:</p>

                                    <h3>AND Operator</h3>
                                    <pre><code class="language-lua">local age = 25
local hasTicket = true

if age >= 18 and hasTicket then
    print("You can enter the concert")
end</code></pre>

                                    <h3>OR Operator</h3>
                                    <pre><code class="language-lua">local isWeekend = true
local isHoliday = false

if isWeekend or isHoliday then
    print("No work today!")
end</code></pre>

                                    <h3>NOT Operator</h3>
                                    <pre><code class="language-lua">local isRaining = false

if not isRaining then
    print("Let's go outside!")
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/conditionals-complex.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-logical" />
                                    </jsp:include>

                                    <!-- Ternary-like Pattern -->
                                    <h2>Ternary-like Pattern</h2>
                                    <p>Lua doesn't have a ternary operator, but you can use
                                        <code>and</code>/<code>or</code>:
                                    </p>

                                    <pre><code class="language-lua">-- Pattern: condition and trueValue or falseValue
local age = 20
local status = age >= 18 and "adult" or "minor"
print(status)  -- "adult"

-- Traditional if-else equivalent:
local status
if age >= 18 then
    status = "adult"
else
    status = "minor"
end</code></pre>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> The <code>and</code>/<code>or</code> pattern only
                                        works if
                                        the true value is not <code>false</code> or <code>nil</code>. When in doubt, use
                                        a
                                        regular <code>if</code> statement!
                                    </div>

                                    <!-- Common Patterns -->
                                    <h2>Common Patterns</h2>

                                    <h3>Checking for nil</h3>
                                    <pre><code class="language-lua">local value = getUserInput()

if value then
    print("Got value:", value)
else
    print("No value provided")
end</code></pre>

                                    <h3>Default Values</h3>
                                    <pre><code class="language-lua">local function greet(name)
    name = name or "Guest"  -- Default to "Guest" if nil
    print("Hello, " .. name)
end

greet()         -- Hello, Guest
greet("Alice")  -- Hello, Alice</code></pre>

                                    <h3>Range Checking</h3>
                                    <pre><code class="language-lua">local score = 85

if score >= 0 and score <= 100 then
    print("Valid score")
else
    print("Invalid score")
end</code></pre>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these conditional challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-conditionals.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Basic <code>if</code> statements with <code>then</code> and
                                                <code>end</code>
                                            </li>
                                            <li><code>if-else</code> for two-way decisions</li>
                                            <li><code>if-elseif-else</code> for multiple conditions</li>
                                            <li>Truthiness: only <code>false</code> and <code>nil</code> are false</li>
                                            <li>Combining conditions with <code>and</code>, <code>or</code>,
                                                <code>not</code>
                                            </li>
                                            <li>Ternary-like pattern with <code>and</code>/<code>or</code></li>
                                            <li>Common patterns for nil checking and default values</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can make decisions in your code, it's time to learn about
                                        <strong>loops</strong>! In the next lesson, we'll explore how to repeat code
                                        with
                                        <code>while</code>, <code>repeat</code>, and <code>for</code> loops. Let's
                                        continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings.jsp" />
                                    <jsp:param name="prevTitle" value="Strings" />
                                    <jsp:param name="nextLink" value="loops.jsp" />
                                    <jsp:param name="nextTitle" value="Loops" />
                                    <jsp:param name="currentLessonId" value="conditionals" />
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