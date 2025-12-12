<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "performance" ); request.setAttribute("currentModule", "Advanced Topics" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Performance Optimization in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua performance optimization: profiling, optimization techniques, memory management, and writing fast, efficient Lua code.">
            <meta name="keywords"
                content="lua performance, lua optimization, lua profiling, lua speed, efficient lua code">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Performance Optimization in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn performance optimization in Lua: profiling and writing efficient code.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/performance.jsp">
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
        "name": "Performance Optimization in Lua",
        "description": "Master Lua performance optimization: profiling and writing efficient code.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/performance.jsp",
        "keywords": "lua performance, optimization, profiling, efficient code",
        "educationalLevel": "Advanced",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Performance optimization", "Profiling", "Memory management", "Optimization techniques"],
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
                "name": "Performance"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="performance">
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
                                    <span>Performance</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Performance Optimization in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Writing fast, efficient code is crucial for performance-critical
                                        applications. In this final lesson, you'll learn how to profile your Lua code,
                                        identify bottlenecks, and apply optimization techniques. Let's explore
                                        performance
                                        optimization in Lua!</p>

                                    <!-- Profiling -->
                                    <h2>Profiling Your Code</h2>

                                    <h3>Simple Timing</h3>
                                    <pre><code class="language-lua">local function benchmark(func, iterations)
    iterations = iterations or 1000000
    
    local start = os.clock()
    for i = 1, iterations do
        func()
    end
    local finish = os.clock()
    
    local elapsed = finish - start
    print(string.format("Time: %.6f seconds", elapsed))
    print(string.format("Per iteration: %.9f seconds", elapsed / iterations))
end

-- Usage
benchmark(function()
    local x = 10 * 20
end)</code></pre>

                                    <h3>Profiler Function</h3>
                                    <pre><code class="language-lua">local Profiler = {}

function Profiler:new()
    local self = {
        times = {},
        counts = {}
    }
    setmetatable(self, {__index = Profiler})
    return self
end

function Profiler:start(name)
    self.times[name] = os.clock()
end

function Profiler:stop(name)
    if not self.times[name] then return end
    
    local elapsed = os.clock() - self.times[name]
    self.counts[name] = (self.counts[name] or 0) + 1
    self.times[name] = (self.times[name] or 0) + elapsed
end

function Profiler:report()
    print("\n=== Profiler Report ===")
    for name, time in pairs(self.times) do
        local count = self.counts[name]
        print(string.format("%s: %.6fs (%d calls, %.9fs avg)",
            name, time, count, time / count))
    end
end

-- Usage
local prof = Profiler:new()

prof:start("calculation")
-- Do work
prof:stop("calculation")

prof:report()</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/performance-tips.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-profiling" />
                                    </jsp:include>

                                    <!-- Optimization Techniques -->
                                    <h2>Optimization Techniques</h2>

                                    <h3>1. Use Local Variables</h3>
                                    <pre><code class="language-lua">-- Slow: Global lookups
function slow()
    for i = 1, 1000000 do
        local x = math.sin(i)
    end
end

-- Fast: Local cache
function fast()
    local sin = math.sin
    for i = 1, 1000000 do
        local x = sin(i)
    end
end</code></pre>

                                    <h3>2. Avoid table.insert() in Loops</h3>
                                    <pre><code class="language-lua">-- Slower
local function buildArray1(n)
    local arr = {}
    for i = 1, n do
        table.insert(arr, i)
    end
    return arr
end

-- Faster: Direct assignment
local function buildArray2(n)
    local arr = {}
    for i = 1, n do
        arr[i] = i
    end
    return arr
end</code></pre>

                                    <h3>3. Use table.concat() for Strings</h3>
                                    <pre><code class="language-lua">-- Slow: String concatenation
local function buildString1(n)
    local s = ""
    for i = 1, n do
        s = s .. tostring(i)
    end
    return s
end

-- Fast: table.concat()
local function buildString2(n)
    local parts = {}
    for i = 1, n do
        parts[i] = tostring(i)
    end
    return table.concat(parts)
end</code></pre>

                                    <h3>4. Reuse Tables</h3>
                                    <pre><code class="language-lua">-- Slow: Create new table each iteration
for i = 1, 10000 do
    local temp = {}
    temp.x = i
    temp.y = i * 2
    -- Use temp
end

-- Fast: Reuse table
local temp = {}
for i = 1, 10000 do
    temp.x = i
    temp.y = i * 2
    -- Use temp
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/performance-tables.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-optimization" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Memory Management -->
                                    <h2>Memory Management</h2>

                                    <h3>Garbage Collection</h3>
                                    <pre><code class="language-lua">-- Check memory usage
local function getMemoryUsage()
    return collectgarbage("count")
end

print("Memory:", getMemoryUsage(), "KB")

-- Force garbage collection
collectgarbage("collect")

-- Set GC parameters
collectgarbage("setpause", 100)  -- Pause between collections
collectgarbage("setstepmul", 200)  -- GC step multiplier</code></pre>

                                    <h3>Weak Tables</h3>
                                    <pre><code class="language-lua">-- Weak table for caching
local cache = {}
setmetatable(cache, {__mode = "v"})  -- Weak values

function getCachedValue(key)
    if not cache[key] then
        cache[key] = expensiveComputation(key)
    end
    return cache[key]
end</code></pre>

                                    <!-- Algorithm Optimization -->
                                    <h2>Algorithm Optimization</h2>

                                    <h3>Memoization</h3>
                                    <pre><code class="language-lua">-- Slow: Recursive fibonacci
local function fib1(n)
    if n <= 1 then return n end
    return fib1(n - 1) + fib1(n - 2)
end

-- Fast: Memoized fibonacci
local function memoize(func)
    local cache = {}
    return function(n)
        if not cache[n] then
            cache[n] = func(n)
        end
        return cache[n]
    end
end

local fib2
fib2 = memoize(function(n)
    if n <= 1 then return n end
    return fib2(n - 1) + fib2(n - 2)
end)

print(fib2(30))  -- Much faster!</code></pre>

                                    <h3>Early Exit</h3>
                                    <pre><code class="language-lua">-- Slow: Check all items
local function findItem1(items, target)
    local found = false
    for i, item in ipairs(items) do
        if item == target then
            found = true
        end
    end
    return found
end

-- Fast: Early exit
local function findItem2(items, target)
    for i, item in ipairs(items) do
        if item == target then
            return true
        end
    end
    return false
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/performance-algorithms.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-algorithms" />
                                    </jsp:include>

                                    <!-- Common Pitfalls -->
                                    <h2>Common Performance Pitfalls</h2>

                                    <div class="warning-box">
                                        <strong>Avoid These:</strong>
                                        <ul>
                                            <li><strong>Global variables:</strong> Slower than local</li>
                                            <li><strong>Repeated table lookups:</strong> Cache in locals</li>
                                            <li><strong>String concatenation in loops:</strong> Use table.concat()</li>
                                            <li><strong>Creating tables in loops:</strong> Reuse when possible</li>
                                            <li><strong>Unnecessary function calls:</strong> Inline simple operations
                                            </li>
                                            <li><strong>Premature optimization:</strong> Profile first!</li>
                                        </ul>
                                    </div>

                                    <!-- Best Practices -->
                                    <h2>Performance Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Best Practices:</strong>
                                        <ol>
                                            <li><strong>Profile before optimizing:</strong> Find real bottlenecks</li>
                                            <li><strong>Use local variables:</strong> Faster than globals</li>
                                            <li><strong>Cache table lookups:</strong> Especially in loops</li>
                                            <li><strong>Choose right data structures:</strong> Arrays vs hash tables
                                            </li>
                                            <li><strong>Avoid unnecessary allocations:</strong> Reuse tables</li>
                                            <li><strong>Use appropriate algorithms:</strong> O(n) vs O(n²)</li>
                                            <li><strong>Lazy evaluation:</strong> Compute only when needed</li>
                                            <li><strong>Batch operations:</strong> Reduce overhead</li>
                                        </ol>
                                    </div>

                                    <!-- Comparison Example -->
                                    <h2>Before and After Optimization</h2>

                                    <h3>Before: Slow Code</h3>
                                    <pre><code class="language-lua">function processData(data)
    local result = ""
    for i = 1, #data do
        result = result .. tostring(data[i])
        if math.sqrt(data[i]) > 10 then
            result = result .. " (large)"
        end
    end
    return result
end</code></pre>

                                    <h3>After: Optimized Code</h3>
                                    <pre><code class="language-lua">function processData(data)
    local parts = {}
    local sqrt = math.sqrt
    local tostring = tostring
    local n = #data
    
    for i = 1, n do
        local value = data[i]
        parts[#parts + 1] = tostring(value)
        if sqrt(value) > 10 then
            parts[#parts + 1] = " (large)"
        end
    end
    
    return table.concat(parts)
end</code></pre>

                                    <p><strong>Improvements:</strong></p>
                                    <ul>
                                        <li>Use table.concat() instead of string concatenation</li>
                                        <li>Cache math.sqrt and tostring in locals</li>
                                        <li>Cache #data outside loop</li>
                                        <li>Use direct array assignment</li>
                                    </ul>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Optimize this code:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-performance.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Profiling code with timing and profiler functions</li>
                                            <li>Optimization techniques (local variables, table operations)</li>
                                            <li>Memory management and garbage collection</li>
                                            <li>Algorithm optimization (memoization, early exit)</li>
                                            <li>Common performance pitfalls to avoid</li>
                                            <li>Performance best practices</li>
                                            <li>Before/after optimization examples</li>
                                        </ul>
                                    </div>

                                    <!-- Congratulations -->
                                    <h2>🎉 Congratulations!</h2>
                                    <div class="success-box">
                                        <p><strong>You've completed the Lua tutorial!</strong></p>
                                        <p>You've learned everything from basic syntax to advanced topics like
                                            coroutines,
                                            OOP, modules, error handling, and performance optimization. You now have the
                                            skills to build robust, efficient Lua applications.</p>

                                        <p><strong>What's next?</strong></p>
                                        <ul>
                                            <li>Build real projects to practice your skills</li>
                                            <li>Explore Lua frameworks (LÖVE for games, OpenResty for web)</li>
                                            <li>Contribute to open-source Lua projects</li>
                                            <li>Dive deeper into LuaJIT for maximum performance</li>
                                            <li>Learn C API for extending Lua</li>
                                        </ul>

                                        <p>Keep coding and happy Lua programming! 🚀</p>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="file-io.jsp" />
                                    <jsp:param name="prevTitle" value="File I/O" />
                                    <jsp:param name="nextLink" value="../lua/" />
                                    <jsp:param name="nextTitle" value="Back to Lua Home" />
                                    <jsp:param name="currentLessonId" value="performance" />
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