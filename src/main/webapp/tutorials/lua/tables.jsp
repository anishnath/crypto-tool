<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "tables" ); request.setAttribute("currentModule", "Tables & Metatables" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Tables in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua tables: arrays, dictionaries, mixed tables, nested structures, and table operations. Learn Lua's most versatile data structure.">
            <meta name="keywords"
                content="lua tables, lua arrays, lua dictionaries, table operations, lua data structures, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Tables in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua tables: the versatile data structure used for arrays, dictionaries, objects, and more.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/tables.jsp">
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
        "name": "Tables in Lua",
        "description": "Master Lua tables: arrays, dictionaries, mixed tables, and table operations.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/tables.jsp",
        "keywords": "lua tables, lua arrays, lua dictionaries, table operations",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Table basics", "Arrays", "Dictionaries", "Mixed tables", "Table operations"],
        "timeRequired": "PT30M",
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
                "name": "Tables"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="tables">
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
                                    <span>Tables</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Tables in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Tables are Lua's only data structuring mechanism, but don't let that
                                        fool
                                        you—they're incredibly versatile! Tables can be used as arrays, dictionaries,
                                        sets,
                                        objects, modules, and more. Understanding tables is essential to mastering Lua.
                                        In
                                        this lesson, you'll learn everything about creating, accessing, and manipulating
                                        tables. Let's dive in!</p>

                                    <!-- Creating Tables -->
                                    <h2>Creating Tables</h2>
                                    <p>Tables are created using curly braces <code>{}</code>:</p>

                                    <pre><code class="language-lua">-- Empty table
local empty = {}

-- Table with values
local numbers = {10, 20, 30, 40, 50}

-- Table with key-value pairs
local person = {
    name = "Alice",
    age = 25,
    city = "New York"
}</code></pre>

                                    <div class="info-box">
                                        <strong>Important:</strong> Lua tables use <strong>1-based indexing</strong> for
                                        arrays, not 0-based like most languages. The first element is at index 1!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Arrays -->
                                    <h2>Tables as Arrays</h2>
                                    <p>Use tables with numeric indices as arrays:</p>

                                    <pre><code class="language-lua">local fruits = {"apple", "banana", "cherry"}

-- Access elements (1-based!)
print(fruits[1])  -- apple
print(fruits[2])  -- banana
print(fruits[3])  -- cherry

-- Get length
print(#fruits)  -- 3

-- Modify elements
fruits[2] = "blueberry"
print(fruits[2])  -- blueberry

-- Add elements
fruits[4] = "date"
table.insert(fruits, "elderberry")  -- Append to end</code></pre>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> Arrays must have consecutive indices starting from 1.
                                        Gaps
                                        in indices can cause <code>#</code> to return unexpected results!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-arrays.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-arrays" />
                                    </jsp:include>

                                    <!-- Dictionaries -->
                                    <h2>Tables as Dictionaries</h2>
                                    <p>Use tables with string keys as dictionaries (hash maps):</p>

                                    <pre><code class="language-lua">local person = {
    name = "Alice",
    age = 25,
    city = "New York"
}

-- Access with dot notation
print(person.name)  -- Alice
print(person.age)   -- 25

-- Access with bracket notation
print(person["city"])  -- New York

-- Add new fields
person.email = "alice@example.com"
person["phone"] = "555-1234"

-- Modify fields
person.age = 26</code></pre>

                                    <h3>Dot vs Bracket Notation</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Notation</th>
                                                <th>Use When</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Dot</td>
                                                <td>Key is a valid identifier</td>
                                                <td><code>person.name</code></td>
                                            </tr>
                                            <tr>
                                                <td>Bracket</td>
                                                <td>Key has spaces, special chars, or is dynamic</td>
                                                <td><code>person["first name"]</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-dictionaries.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-dictionaries" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Mixed Tables -->
                                    <h2>Mixed Tables</h2>
                                    <p>Tables can have both numeric and string keys:</p>

                                    <pre><code class="language-lua">local mixed = {
    "first",      -- [1]
    "second",     -- [2]
    name = "Alice",
    age = 25,
    "third"       -- [3]
}

print(mixed[1])      -- first
print(mixed[2])      -- second
print(mixed[3])      -- third
print(mixed.name)    -- Alice
print(mixed.age)     -- 25
print(#mixed)        -- 3 (only counts numeric indices)</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> While mixed tables are possible, it's usually clearer to
                                        keep
                                        arrays and dictionaries separate for better code readability.
                                    </div>

                                    <!-- Nested Tables -->
                                    <h2>Nested Tables</h2>
                                    <p>Tables can contain other tables:</p>

                                    <pre><code class="language-lua">local company = {
    name = "Tech Corp",
    employees = {
        {name = "Alice", role = "Developer"},
        {name = "Bob", role = "Designer"},
        {name = "Charlie", role = "Manager"}
    },
    location = {
        city = "San Francisco",
        state = "CA",
        coordinates = {
            lat = 37.7749,
            lon = -122.4194
        }
    }
}

-- Access nested values
print(company.name)                      -- Tech Corp
print(company.employees[1].name)         -- Alice
print(company.location.city)             -- San Francisco
print(company.location.coordinates.lat)  -- 37.7749</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-dictionaries.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-nested" />
                                    </jsp:include>

                                    <!-- Iterating Tables -->
                                    <h2>Iterating Over Tables</h2>

                                    <h3>Arrays with ipairs</h3>
                                    <pre><code class="language-lua">local fruits = {"apple", "banana", "cherry"}

for index, value in ipairs(fruits) do
    print(index, value)
end
-- Output:
-- 1    apple
-- 2    banana
-- 3    cherry</code></pre>

                                    <h3>Dictionaries with pairs</h3>
                                    <pre><code class="language-lua">local person = {
    name = "Alice",
    age = 25,
    city = "New York"
}

for key, value in pairs(person) do
    print(key, value)
end
-- Output (order not guaranteed):
-- name    Alice
-- age     25
-- city    New York</code></pre>

                                    <div class="info-box">
                                        <strong>Remember:</strong>
                                        <ul>
                                            <li><code>ipairs</code>: For arrays (numeric indices), guaranteed order</li>
                                            <li><code>pairs</code>: For all tables, no guaranteed order</li>
                                        </ul>
                                    </div>

                                    <!-- Table Operations -->
                                    <h2>Common Table Operations</h2>

                                    <h3>Checking if Key Exists</h3>
                                    <pre><code class="language-lua">local person = {name = "Alice", age = 25}

if person.name then
    print("Name exists")
end

if person.email == nil then
    print("Email does not exist")
end</code></pre>

                                    <h3>Removing Elements</h3>
                                    <pre><code class="language-lua">local person = {name = "Alice", age = 25, city = "NYC"}

-- Set to nil to remove
person.city = nil

-- For arrays, use table.remove
local fruits = {"apple", "banana", "cherry"}
table.remove(fruits, 2)  -- Remove "banana"
-- fruits = {"apple", "cherry"}</code></pre>

                                    <h3>Copying Tables</h3>
                                    <pre><code class="language-lua">-- Shallow copy
local function shallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

local original = {a = 1, b = 2}
local copy = shallowCopy(original)

-- Deep copy (for nested tables)
local function deepCopy(t)
    if type(t) ~= "table" then
        return t
    end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = deepCopy(v)
    end
    return copy
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/tables-manipulation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-operations" />
                                    </jsp:include>

                                    <!-- Tables as Objects -->
                                    <h2>Tables as Objects</h2>
                                    <p>Tables can store functions, making them behave like objects:</p>

                                    <pre><code class="language-lua">local calculator = {
    value = 0,
    
    add = function(self, x)
        self.value = self.value + x
        return self
    end,
    
    subtract = function(self, x)
        self.value = self.value - x
        return self
    end,
    
    getResult = function(self)
        return self.value
    end
}

-- Using the object
calculator:add(10)
calculator:subtract(3)
print(calculator:getResult())  -- 7</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> The colon <code>:</code> syntax automatically passes the
                                        table
                                        as the first argument (<code>self</code>). <code>obj:method()</code> is
                                        equivalent to
                                        <code>obj.method(obj)</code>.
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these table challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-variables.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Creating tables with <code>{}</code></li>
                                            <li>Using tables as arrays (1-based indexing!)</li>
                                            <li>Using tables as dictionaries with string keys</li>
                                            <li>Mixed tables with both numeric and string keys</li>
                                            <li>Nested tables for complex data structures</li>
                                            <li>Iterating with <code>ipairs</code> and <code>pairs</code></li>
                                            <li>Common operations: checking keys, removing, copying</li>
                                            <li>Tables as objects with functions</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand table basics, it's time to explore the <strong>table
                                            library</strong>! In the next lesson, you'll learn powerful built-in
                                        functions for
                                        manipulating tables: insert, remove, sort, concat, and more. Let's continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="advanced-functions.jsp" />
                                    <jsp:param name="prevTitle" value="Advanced Functions" />
                                    <jsp:param name="nextLink" value="table-library.jsp" />
                                    <jsp:param name="nextTitle" value="Table Library" />
                                    <jsp:param name="currentLessonId" value="tables" />
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