<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "loops" ); request.setAttribute("currentModule", "Operators & Control Flow"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Loops in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua loops: while, repeat-until, numeric for, and generic for. Learn to iterate efficiently with break and practical examples.">
            <meta name="keywords"
                content="lua loops, while loop, for loop, repeat until, lua iteration, break statement, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Loops in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn all Lua loop types: while, repeat-until, numeric for, and generic for loops.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/loops.jsp">
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
        "name": "Loops in Lua",
        "description": "Master Lua loops: while, repeat-until, numeric for, and generic for loops with practical examples.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/loops.jsp",
        "keywords": "lua loops, while loop, for loop, repeat until, iteration",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["while loops", "repeat-until", "for loops", "break statement", "loop control"],
        "timeRequired": "PT25M",
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
                "name": "Loops"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="loops">
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
                                    <span>Loops</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Loops in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Loops allow you to repeat code multiple times, making your programs
                                        more
                                        efficient and powerful. Lua provides several types of loops: <code>while</code>,
                                        <code>repeat-until</code>, and <code>for</code> (both numeric and generic). Each
                                        has
                                        its own use case and advantages. Let's explore them all!
                                    </p>

                                    <!-- while Loop -->
                                    <h2>The while Loop</h2>
                                    <p>The <code>while</code> loop repeats code as long as a condition is true:</p>

                                    <pre><code class="language-lua">local count = 1

while count <= 5 do
    print("Count:", count)
    count = count + 1
end

-- Output:
-- Count: 1
-- Count: 2
-- Count: 3
-- Count: 4
-- Count: 5</code></pre>

                                    <div class="info-box">
                                        <strong>Syntax:</strong>
                                        <ul>
                                            <li>Start with <code>while</code> followed by a condition</li>
                                            <li>Use <code>do</code> after the condition</li>
                                            <li>Write the code to repeat</li>
                                            <li>End with <code>end</code></li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/loops-while.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-while" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> Make sure your loop condition eventually becomes
                                        false, or
                                        you'll create an infinite loop! Always update the loop variable inside the loop.
                                    </div>

                                    <!-- repeat-until Loop -->
                                    <h2>The repeat-until Loop</h2>
                                    <p>The <code>repeat-until</code> loop executes at least once, then checks the
                                        condition:
                                    </p>

                                    <pre><code class="language-lua">local count = 1

repeat
    print("Count:", count)
    count = count + 1
until count > 5

-- Output is the same as while loop
-- But the code runs at least once!</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Use <code>repeat-until</code> when you need the loop body
                                        to
                                        execute at least once, like validating user input or menu systems.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/loops-repeat.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-repeat" />
                                    </jsp:include>

                                    <h3>while vs repeat-until</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>while</th>
                                                <th>repeat-until</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Condition check</td>
                                                <td>Before execution</td>
                                                <td>After execution</td>
                                            </tr>
                                            <tr>
                                                <td>Minimum executions</td>
                                                <td>0 (may not run)</td>
                                                <td>1 (always runs once)</td>
                                            </tr>
                                            <tr>
                                                <td>Condition</td>
                                                <td>Continue while true</td>
                                                <td>Stop when true</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Numeric for Loop -->
                                    <h2>The Numeric for Loop</h2>
                                    <p>The numeric <code>for</code> loop is perfect for counting:</p>

                                    <pre><code class="language-lua">-- Count from 1 to 5
for i = 1, 5 do
    print(i)
end

-- Count from 1 to 10 by 2s
for i = 1, 10, 2 do
    print(i)  -- 1, 3, 5, 7, 9
end

-- Count backwards
for i = 5, 1, -1 do
    print(i)  -- 5, 4, 3, 2, 1
end</code></pre>

                                    <div class="info-box">
                                        <strong>Syntax:</strong> <code>for variable = start, stop, step do</code>
                                        <ul>
                                            <li><code>start</code>: Starting value</li>
                                            <li><code>stop</code>: Ending value (inclusive)</li>
                                            <li><code>step</code>: Increment (default is 1)</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/loops-for.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-numeric" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> The loop variable (<code>i</code>) is local to
                                        the
                                        loop and cannot be modified inside the loop body. This prevents common errors!
                                    </div>

                                    <!-- Generic for Loop -->
                                    <h2>The Generic for Loop</h2>
                                    <p>The generic <code>for</code> loop iterates over collections using iterators:</p>

                                    <h3>Iterating Over Arrays</h3>
                                    <pre><code class="language-lua">local fruits = {"apple", "banana", "cherry"}

-- Using ipairs for arrays
for index, value in ipairs(fruits) do
    print(index, value)
end

-- Output:
-- 1    apple
-- 2    banana
-- 3    cherry</code></pre>

                                    <h3>Iterating Over Tables</h3>
                                    <pre><code class="language-lua">local person = {
    name = "Alice",
    age = 25,
    city = "New York"
}

-- Using pairs for tables
for key, value in pairs(person) do
    print(key, value)
end

-- Output:
-- name    Alice
-- age     25
-- city    New York</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/loops-generic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-generic" />
                                    </jsp:include>

                                    <h3>ipairs vs pairs</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Iterator</th>
                                                <th>Use For</th>
                                                <th>Order</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>ipairs</code></td>
                                                <td>Arrays (sequential tables)</td>
                                                <td>Guaranteed (1, 2, 3...)</td>
                                            </tr>
                                            <tr>
                                                <td><code>pairs</code></td>
                                                <td>All tables (any keys)</td>
                                                <td>Not guaranteed</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Use <code>ipairs</code> for arrays and <code>pairs</code>
                                        for
                                        hash tables. <code>ipairs</code> stops at the first nil value!
                                    </div>

                                    <!-- break Statement -->
                                    <h2>The break Statement</h2>
                                    <p>Use <code>break</code> to exit a loop early:</p>

                                    <pre><code class="language-lua">-- Find first even number
for i = 1, 10 do
    if i % 2 == 0 then
        print("First even number:", i)
        break  -- Exit the loop
    end
end

-- Search in array
local numbers = {1, 3, 5, 8, 9, 11}
for i, num in ipairs(numbers) do
    if num % 2 == 0 then
        print("Found even number at index", i)
        break
    end
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/loops-repeat.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-break" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Note:</strong> Lua does NOT have a <code>continue</code> statement. To
                                        skip to
                                        the next iteration, use <code>if</code> statements or restructure your code.
                                    </div>

                                    <!-- Nested Loops -->
                                    <h2>Nested Loops</h2>
                                    <p>You can put loops inside other loops:</p>

                                    <pre><code class="language-lua">-- Multiplication table
for i = 1, 5 do
    for j = 1, 5 do
        print(i .. " x " .. j .. " = " .. (i * j))
    end
end

-- 2D grid
for row = 1, 3 do
    for col = 1, 3 do
        print("(" .. row .. "," .. col .. ")")
    end
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/loops-for.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-nested" />
                                    </jsp:include>

                                    <!-- Common Patterns -->
                                    <h2>Common Loop Patterns</h2>

                                    <h3>Sum of Numbers</h3>
                                    <pre><code class="language-lua">local sum = 0
for i = 1, 10 do
    sum = sum + i
end
print("Sum:", sum)  -- 55</code></pre>

                                    <h3>Finding Maximum</h3>
                                    <pre><code class="language-lua">local numbers = {5, 2, 9, 1, 7}
local max = numbers[1]

for i = 2, #numbers do
    if numbers[i] > max then
        max = numbers[i]
    end
end
print("Maximum:", max)  -- 9</code></pre>

                                    <h3>Filtering</h3>
                                    <pre><code class="language-lua">local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local evens = {}

for i, num in ipairs(numbers) do
    if num % 2 == 0 then
        table.insert(evens, num)
    end
end
-- evens = {2, 4, 6, 8, 10}</code></pre>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these loop challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-loops.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li><code>while</code> loops: repeat while condition is true</li>
                                            <li><code>repeat-until</code> loops: execute at least once</li>
                                            <li>Numeric <code>for</code> loops: count from start to stop</li>
                                            <li>Generic <code>for</code> loops: iterate with <code>ipairs</code> and
                                                <code>pairs</code>
                                            </li>
                                            <li><code>break</code> statement to exit loops early</li>
                                            <li>Nested loops for multi-dimensional iteration</li>
                                            <li>Common patterns: sum, max, filtering</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing Module 2! You now understand operators, strings,
                                        conditionals, and loops—the building blocks of programming. Next, we'll dive
                                        into
                                        <strong>functions</strong>, one of Lua's most powerful features. You'll learn
                                        how to
                                        write reusable code, work with closures, and master functional programming
                                        concepts.
                                        Let's continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="conditionals.jsp" />
                                    <jsp:param name="prevTitle" value="Conditionals" />
                                    <jsp:param name="nextLink" value="functions.jsp" />
                                    <jsp:param name="nextTitle" value="Functions" />
                                    <jsp:param name="currentLessonId" value="loops" />
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