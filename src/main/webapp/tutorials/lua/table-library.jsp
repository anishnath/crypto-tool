<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "table-library" );
        request.setAttribute("currentModule", "Tables & Metatables" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Table Library in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua's table library: insert, remove, sort, concat, pack, unpack. Learn powerful built-in functions for table manipulation.">
            <meta name="keywords"
                content="lua table library, table.insert, table.remove, table.sort, table.concat, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Table Library in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua's table library functions for efficient table manipulation.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/table-library.jsp">
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
        "name": "Table Library in Lua",
        "description": "Master Lua's table library functions: insert, remove, sort, concat, and more.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/table-library.jsp",
        "keywords": "lua table library, table.insert, table.remove, table.sort",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["table.insert", "table.remove", "table.sort", "table.concat", "table.pack", "table.unpack"],
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
                "name": "Table Library"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="table-library">
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
                                    <span>Table Library</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Table Library in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Lua provides a powerful table library with built-in functions for
                                        manipulating tables efficiently. These functions handle common operations like
                                        inserting, removing, sorting, and joining table elements. Mastering the table
                                        library
                                        will make your code cleaner and more efficient. Let's explore all the essential
                                        table
                                        functions!</p>

                                    <!-- table.insert -->
                                    <h2>table.insert()</h2>
                                    <p>Insert elements into a table:</p>

                                    <pre><code class="language-lua">local fruits = {"apple", "banana"}

-- Insert at end
table.insert(fruits, "cherry")
-- fruits = {"apple", "banana", "cherry"}

-- Insert at specific position
table.insert(fruits, 2, "blueberry")
-- fruits = {"apple", "blueberry", "banana", "cherry"}</code></pre>

                                    <div class="info-box">
                                        <strong>Syntax:</strong>
                                        <ul>
                                            <li><code>table.insert(t, value)</code> - Append to end</li>
                                            <li><code>table.insert(t, pos, value)</code> - Insert at position</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-library.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-insert" />
                                    </jsp:include>

                                    <!-- table.remove -->
                                    <h2>table.remove()</h2>
                                    <p>Remove elements from a table:</p>

                                    <pre><code class="language-lua">local fruits = {"apple", "banana", "cherry", "date"}

-- Remove last element
local removed = table.remove(fruits)
print(removed)  -- "date"
-- fruits = {"apple", "banana", "cherry"}

-- Remove at specific position
local removed = table.remove(fruits, 2)
print(removed)  -- "banana"
-- fruits = {"apple", "cherry"}</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> <code>table.remove()</code> shifts elements to fill
                                        the
                                        gap. Removing from the beginning or middle is O(n) complexity!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-library.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-remove" />
                                    </jsp:include>

                                    <!-- table.sort -->
                                    <h2>table.sort()</h2>
                                    <p>Sort table elements in-place:</p>

                                    <pre><code class="language-lua">local numbers = {5, 2, 8, 1, 9, 3}

-- Sort ascending (default)
table.sort(numbers)
-- numbers = {1, 2, 3, 5, 8, 9}

-- Sort descending with custom comparator
table.sort(numbers, function(a, b)
    return a > b
end)
-- numbers = {9, 8, 5, 3, 2, 1}

-- Sort strings
local names = {"Charlie", "Alice", "Bob"}
table.sort(names)
-- names = {"Alice", "Bob", "Charlie"}</code></pre>

                                    <h3>Custom Sorting</h3>
                                    <pre><code class="language-lua">local people = {
    {name = "Alice", age = 25},
    {name = "Bob", age = 30},
    {name = "Charlie", age = 20}
}

-- Sort by age
table.sort(people, function(a, b)
    return a.age < b.age
end)
-- Charlie (20), Alice (25), Bob (30)</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-sorting.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-sort" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- table.concat -->
                                    <h2>table.concat()</h2>
                                    <p>Join table elements into a string:</p>

                                    <pre><code class="language-lua">local words = {"Hello", "World", "Lua"}

-- Join with default separator (empty string)
local result = table.concat(words)
print(result)  -- "HelloWorldLua"

-- Join with custom separator
local result = table.concat(words, " ")
print(result)  -- "Hello World Lua"

-- Join with separator and range
local result = table.concat(words, ", ", 1, 2)
print(result)  -- "Hello, World"</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use <code>table.concat()</code> instead of
                                        string
                                        concatenation in loops—it's much faster for building long strings!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-library.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-concat" />
                                    </jsp:include>

                                    <!-- table.pack and table.unpack -->
                                    <h2>table.pack() and table.unpack()</h2>

                                    <h3>table.pack() - Lua 5.2+</h3>
                                    <p>Pack values into a table:</p>

                                    <pre><code class="language-lua">local packed = table.pack(10, 20, 30)
-- packed = {10, 20, 30, n = 3}
-- 'n' field stores the count

print(packed[1])  -- 10
print(packed.n)   -- 3</code></pre>

                                    <h3>table.unpack() (or unpack in Lua 5.1)</h3>
                                    <p>Unpack table into multiple values:</p>

                                    <pre><code class="language-lua">local numbers = {10, 20, 30}

-- Unpack all values
local a, b, c = table.unpack(numbers)
print(a, b, c)  -- 10  20  30

-- Unpack range
local x, y = table.unpack(numbers, 1, 2)
print(x, y)  -- 10  20

-- Use in function calls
local function add(a, b, c)
    return a + b + c
end

print(add(table.unpack(numbers)))  -- 60</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-library.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-pack" />
                                    </jsp:include>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Building a CSV String</h3>
                                    <pre><code class="language-lua">local function toCSV(rows)
    local lines = {}
    for i, row in ipairs(rows) do
        table.insert(lines, table.concat(row, ","))
    end
    return table.concat(lines, "\n")
end

local data = {
    {"Name", "Age", "City"},
    {"Alice", "25", "NYC"},
    {"Bob", "30", "LA"}
}

print(toCSV(data))</code></pre>

                                    <h3>Stack Implementation</h3>
                                    <pre><code class="language-lua">local Stack = {}

function Stack:new()
    local stack = {items = {}}
    setmetatable(stack, {__index = self})
    return stack
end

function Stack:push(value)
    table.insert(self.items, value)
end

function Stack:pop()
    return table.remove(self.items)
end

function Stack:peek()
    return self.items[#self.items]
end

function Stack:isEmpty()
    return #self.items == 0
end

local s = Stack:new()
s:push(10)
s:push(20)
print(s:pop())  -- 20</code></pre>

                                    <h3>Queue Implementation</h3>
                                    <pre><code class="language-lua">local Queue = {}

function Queue:new()
    local queue = {items = {}}
    setmetatable(queue, {__index = self})
    return queue
end

function Queue:enqueue(value)
    table.insert(self.items, value)
end

function Queue:dequeue()
    return table.remove(self.items, 1)
end

local q = Queue:new()
q:enqueue("first")
q:enqueue("second")
print(q:dequeue())  -- "first"</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-manipulation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- Summary Table -->
                                    <h2>Quick Reference</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Purpose</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>table.insert(t, v)</code></td>
                                                <td>Append value</td>
                                                <td><code>table.insert(arr, 10)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.insert(t, i, v)</code></td>
                                                <td>Insert at position</td>
                                                <td><code>table.insert(arr, 2, 10)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.remove(t)</code></td>
                                                <td>Remove last</td>
                                                <td><code>table.remove(arr)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.remove(t, i)</code></td>
                                                <td>Remove at position</td>
                                                <td><code>table.remove(arr, 2)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.sort(t)</code></td>
                                                <td>Sort ascending</td>
                                                <td><code>table.sort(arr)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.sort(t, comp)</code></td>
                                                <td>Sort with comparator</td>
                                                <td><code>table.sort(arr, function(a,b) return a>b end)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.concat(t, sep)</code></td>
                                                <td>Join to string</td>
                                                <td><code>table.concat(arr, ", ")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table.unpack(t)</code></td>
                                                <td>Unpack values</td>
                                                <td><code>a, b = table.unpack(arr)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these table library challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-tables.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li><code>table.insert()</code> for adding elements</li>
                                            <li><code>table.remove()</code> for removing elements</li>
                                            <li><code>table.sort()</code> for sorting with custom comparators</li>
                                            <li><code>table.concat()</code> for efficient string building</li>
                                            <li><code>table.pack()</code> and <code>table.unpack()</code> for value
                                                manipulation</li>
                                            <li>Practical implementations: CSV, Stack, Queue</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered the table library! Next, we'll explore
                                        <strong>metatables</strong>—one
                                        of Lua's most powerful features. Metatables let you customize table behavior,
                                        overload operators, and create sophisticated object-oriented patterns. Let's
                                        continue!
                                        🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="tables.jsp" />
                                    <jsp:param name="prevTitle" value="Tables" />
                                    <jsp:param name="nextLink" value="metatables.jsp" />
                                    <jsp:param name="nextTitle" value="Metatables" />
                                    <jsp:param name="currentLessonId" value="table-library" />
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