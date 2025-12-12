<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "iterators" ); request.setAttribute("currentModule", "Tables & Metatables"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Iterators in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua iterators: stateless and stateful iterators, custom iteration patterns, and the generic for loop protocol.">
            <meta name="keywords"
                content="lua iterators, stateless iterators, stateful iterators, custom iterators, generic for loop, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Iterators in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua iterators: create custom iteration patterns for powerful data processing.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/iterators.jsp">
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
        "name": "Iterators in Lua",
        "description": "Master Lua iterators: stateless and stateful iterators, custom iteration patterns.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/iterators.jsp",
        "keywords": "lua iterators, stateless iterators, stateful iterators, custom iterators",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Iterator protocol", "Stateless iterators", "Stateful iterators", "Custom iterators"],
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
                "name": "Iterators"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="iterators">
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
                                    <span>Iterators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Iterators in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Iterators are functions that allow you to traverse collections in a
                                        controlled way. Lua's generic for loop works with iterators to provide elegant
                                        iteration patterns. Understanding how iterators work enables you to create
                                        custom
                                        iteration logic for any data structure. Let's explore how to create and use
                                        iterators
                                        effectively!</p>

                                    <!-- Iterator Protocol -->
                                    <h2>The Iterator Protocol</h2>
                                    <p>The generic for loop expects an iterator function:</p>

                                    <pre><code class="language-lua">for var1, var2, ... in iterator do
    -- body
end</code></pre>

                                    <p>The iterator function is called repeatedly, returning values until it returns
                                        <code>nil</code>:
                                    </p>

                                    <pre><code class="language-lua">-- Simple iterator
local function simpleIterator()
    local i = 0
    return function()
        i = i + 1
        if i <= 3 then
            return i
        end
    end
end

for value in simpleIterator() do
    print(value)  -- 1, 2, 3
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/iterators-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Stateless Iterators -->
                                    <h2>Stateless Iterators</h2>
                                    <p>Stateless iterators don't maintain state between calls. They receive the state
                                        from
                                        the for loop:</p>

                                    <pre><code class="language-lua">-- Iterator function
local function iter(t, i)
    i = i + 1
    local v = t[i]
    if v then
        return i, v
    end
end

-- Factory function
local function values(t)
    return iter, t, 0
end

-- Usage
local fruits = {"apple", "banana", "cherry"}
for i, v in values(fruits) do
    print(i, v)
end</code></pre>

                                    <div class="info-box">
                                        <strong>How it works:</strong>
                                        <ol>
                                            <li>Factory returns: iterator function, invariant state, control variable
                                            </li>
                                            <li>For loop calls: <code>iterator(state, control)</code></li>
                                            <li>Iterator returns new control variable and values</li>
                                            <li>Loop continues until iterator returns <code>nil</code></li>
                                        </ol>
                                    </div>

                                    <h3>ipairs Implementation</h3>
                                    <p>Here's how <code>ipairs</code> works internally:</p>

                                    <pre><code class="language-lua">local function myIpairs(t)
    local function iter(t, i)
        i = i + 1
        local v = t[i]
        if v ~= nil then
            return i, v
        end
    end
    return iter, t, 0
end

local arr = {10, 20, 30}
for i, v in myIpairs(arr) do
    print(i, v)
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/iterators-stateless.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-stateless" />
                                    </jsp:include>

                                    <!-- Stateful Iterators -->
                                    <h2>Stateful Iterators</h2>
                                    <p>Stateful iterators use closures to maintain state:</p>

                                    <pre><code class="language-lua">local function range(from, to, step)
    step = step or 1
    local current = from - step
    
    return function()
        current = current + step
        if current <= to then
            return current
        end
    end
end

-- Usage
for i in range(1, 10, 2) do
    print(i)  -- 1, 3, 5, 7, 9
end</code></pre>

                                    <h3>Fibonacci Iterator</h3>
                                    <pre><code class="language-lua">local function fibonacci(n)
    local a, b = 0, 1
    local count = 0
    
    return function()
        if count < n then
            count = count + 1
            a, b = b, a + b
            return a
        end
    end
end

for num in fibonacci(10) do
    print(num)  -- 1, 1, 2, 3, 5, 8, 13, 21, 34, 55
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/iterators-stateful.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-stateful" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Custom Iterators -->
                                    <h2>Custom Iterators</h2>

                                    <h3>Words Iterator</h3>
                                    <pre><code class="language-lua">local function words(str)
    local pos = 1
    return function()
        local start, finish = str:find("%w+", pos)
        if start then
            pos = finish + 1
            return str:sub(start, finish)
        end
    end
end

local text = "Hello World from Lua"
for word in words(text) do
    print(word)
end</code></pre>

                                    <h3>Lines Iterator</h3>
                                    <pre><code class="language-lua">local function lines(str)
    local pos = 1
    return function()
        if pos > #str then return nil end
        local start = pos
        local finish = str:find("\n", pos) or #str + 1
        pos = finish + 1
        return str:sub(start, finish - 1)
    end
end

local text = "Line 1\nLine 2\nLine 3"
for line in lines(text) do
    print(line)
end</code></pre>

                                    <h3>Reverse Iterator</h3>
                                    <pre><code class="language-lua">local function reverse(t)
    local i = #t + 1
    return function()
        i = i - 1
        if i > 0 then
            return i, t[i]
        end
    end
end

local arr = {10, 20, 30, 40}
for i, v in reverse(arr) do
    print(i, v)  -- 4,40  3,30  2,20  1,10
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/iterators-custom.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-custom" />
                                    </jsp:include>

                                    <!-- Advanced Patterns -->
                                    <h2>Advanced Iterator Patterns</h2>

                                    <h3>Filter Iterator</h3>
                                    <pre><code class="language-lua">local function filter(predicate, iterator, state, var)
    return function()
        while true do
            local value
            var, value = iterator(state, var)
            if var == nil then return nil end
            if predicate(value) then
                return var, value
            end
        end
    end, state, var
end

-- Usage
local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
for i, v in filter(function(x) return x % 2 == 0 end, ipairs(numbers)) do
    print(i, v)  -- Even numbers only
end</code></pre>

                                    <h3>Map Iterator</h3>
                                    <pre><code class="language-lua">local function map(func, iterator, state, var)
    return function()
        local value
        var, value = iterator(state, var)
        if var == nil then return nil end
        return var, func(value)
    end, state, var
end

-- Usage
local numbers = {1, 2, 3, 4, 5}
for i, v in map(function(x) return x * 2 end, ipairs(numbers)) do
    print(i, v)  -- Doubled values
end</code></pre>

                                    <h3>Take Iterator</h3>
                                    <pre><code class="language-lua">local function take(n, iterator, state, var)
    local count = 0
    return function()
        if count >= n then return nil end
        count = count + 1
        return iterator(state, var)
    end, state, var
end

-- Usage
local function infiniteOnes()
    return function() return 1 end
end

for value in take(5, infiniteOnes()) do
    print(value)  -- 1, 1, 1, 1, 1
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/iterators-advanced.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-advanced" />
                                    </jsp:include>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Tree Traversal</h3>
                                    <pre><code class="language-lua">local function traverse(node)
    local stack = {node}
    
    return function()
        if #stack == 0 then return nil end
        
        local current = table.remove(stack)
        
        -- Add children to stack
        if current.children then
            for i = #current.children, 1, -1 do
                table.insert(stack, current.children[i])
            end
        end
        
        return current
    end
end

local tree = {
    value = 1,
    children = {
        {value = 2},
        {value = 3, children = {{value = 4}, {value = 5}}}
    }
}

for node in traverse(tree) do
    print(node.value)
end</code></pre>

                                    <h3>Pagination Iterator</h3>
                                    <pre><code class="language-lua">local function paginate(items, pageSize)
    local page = 0
    local totalPages = math.ceil(#items / pageSize)
    
    return function()
        if page >= totalPages then return nil end
        page = page + 1
        
        local start = (page - 1) * pageSize + 1
        local finish = math.min(page * pageSize, #items)
        
        local pageItems = {}
        for i = start, finish do
            table.insert(pageItems, items[i])
        end
        
        return page, pageItems
    end
end

local items = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
for page, pageItems in paginate(items, 3) do
    print("Page " .. page .. ":", table.concat(pageItems, ", "))
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/iterators-practical.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these iterator challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-iterators.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>The iterator protocol and how generic for loops work</li>
                                            <li>Stateless iterators that receive state from the loop</li>
                                            <li>Stateful iterators using closures</li>
                                            <li>Custom iterators for specific use cases</li>
                                            <li>Advanced patterns: filter, map, take</li>
                                            <li>Practical examples: tree traversal, pagination</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing Module 4! You've mastered tables, the table
                                        library,
                                        metatables, and iterators—the core of Lua's data manipulation capabilities.
                                        Next,
                                        we'll explore <strong>Object-Oriented Programming</strong> in Lua. You'll learn
                                        how
                                        to create classes, implement inheritance, and build robust OOP systems using
                                        tables
                                        and metatables. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="metatables.jsp" />
                                    <jsp:param name="prevTitle" value="Metatables" />
                                    <jsp:param name="nextLink" value="oop-basics.jsp" />
                                    <jsp:param name="nextTitle" value="OOP Basics" />
                                    <jsp:param name="currentLessonId" value="iterators" />
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