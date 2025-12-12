<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "coroutines" ); request.setAttribute("currentModule", "Advanced Topics" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Coroutines in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua coroutines: create, resume, yield, coroutine states, and practical coroutine patterns for cooperative multitasking.">
            <meta name="keywords"
                content="lua coroutines, coroutine.create, coroutine.resume, coroutine.yield, cooperative multitasking lua">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Coroutines in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua coroutines for cooperative multitasking and advanced control flow.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/coroutines.jsp">
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
        "name": "Coroutines in Lua",
        "description": "Master Lua coroutines for cooperative multitasking and advanced control flow.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/coroutines.jsp",
        "keywords": "lua coroutines, cooperative multitasking, coroutine.resume, coroutine.yield",
        "educationalLevel": "Advanced",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Coroutines", "create/resume/yield", "Coroutine states", "Cooperative multitasking"],
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
                "name": "Coroutines"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="coroutines">
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
                                    <span>Coroutines</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Coroutines in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Coroutines are one of Lua's most powerful features, enabling
                                        cooperative
                                        multitasking and sophisticated control flow. Unlike threads, coroutines are
                                        cooperative—they explicitly yield control to other coroutines. In this lesson,
                                        you'll learn how to create, manage, and use coroutines effectively. Let's
                                        explore
                                        this advanced feature!</p>

                                    <!-- What are Coroutines? -->
                                    <h2>What are Coroutines?</h2>
                                    <p>A coroutine is like a function that can pause and resume execution:</p>

                                    <pre><code class="language-lua">-- Create a coroutine
local co = coroutine.create(function()
    print("Hello")
    coroutine.yield()
    print("World")
end)

-- Resume the coroutine
coroutine.resume(co)  -- Prints: Hello
coroutine.resume(co)  -- Prints: World</code></pre>

                                    <div class="info-box">
                                        <strong>Key Concepts:</strong>
                                        <ul>
                                            <li><strong>Create:</strong> <code>coroutine.create(func)</code> creates a
                                                coroutine</li>
                                            <li><strong>Resume:</strong> <code>coroutine.resume(co)</code>
                                                starts/resumes
                                                execution</li>
                                            <li><strong>Yield:</strong> <code>coroutine.yield()</code> pauses execution
                                            </li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/coroutines-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Coroutine States -->
                                    <h2>Coroutine States</h2>
                                    <p>A coroutine can be in one of four states:</p>

                                    <pre><code class="language-lua">local co = coroutine.create(function()
    print("Running")
    coroutine.yield()
    print("Done")
end)

print(coroutine.status(co))  -- suspended

coroutine.resume(co)
print(coroutine.status(co))  -- suspended (yielded)

coroutine.resume(co)
print(coroutine.status(co))  -- dead</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>State</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>suspended</code></td>
                                                <td>Created but not started, or yielded</td>
                                            </tr>
                                            <tr>
                                                <td><code>running</code></td>
                                                <td>Currently executing</td>
                                            </tr>
                                            <tr>
                                                <td><code>normal</code></td>
                                                <td>Resumed another coroutine</td>
                                            </tr>
                                            <tr>
                                                <td><code>dead</code></td>
                                                <td>Finished execution or error</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Passing Values -->
                                    <h2>Passing Values</h2>

                                    <h3>Resume to Yield</h3>
                                    <pre><code class="language-lua">local co = coroutine.create(function(a, b)
    print("Received:", a, b)
    local x, y = coroutine.yield(a + b)
    print("Received after yield:", x, y)
    return x * y
end)

local success, result = coroutine.resume(co, 10, 20)
print("First resume:", result)  -- 30

local success, result = coroutine.resume(co, 5, 6)
print("Second resume:", result)  -- 30</code></pre>

                                    <h3>Yield to Resume</h3>
                                    <pre><code class="language-lua">local co = coroutine.create(function()
    for i = 1, 5 do
        coroutine.yield(i)
    end
end)

while coroutine.status(co) ~= "dead" do
    local success, value = coroutine.resume(co)
    if success and value then
        print("Yielded:", value)
    end
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/coroutines-yield.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-values" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Coroutine Patterns -->
                                    <h2>Coroutine Patterns</h2>

                                    <h3>Producer-Consumer</h3>
                                    <pre><code class="language-lua">local function producer()
    return coroutine.create(function()
        for i = 1, 10 do
            coroutine.yield(i)
        end
    end)
end

local function consumer(prod)
    while true do
        local success, value = coroutine.resume(prod)
        if not success or not value then
            break
        end
        print("Consumed:", value)
    end
end

local prod = producer()
consumer(prod)</code></pre>

                                    <h3>Iterator with Coroutines</h3>
                                    <pre><code class="language-lua">local function range(from, to)
    return coroutine.wrap(function()
        for i = from, to do
            coroutine.yield(i)
        end
    end)
end

-- Use like a regular iterator
for i in range(1, 5) do
    print(i)  -- 1, 2, 3, 4, 5
end</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> <code>coroutine.wrap()</code> creates a coroutine and
                                        returns
                                        a function that resumes it. It's simpler than <code>create()</code> +
                                        <code>resume()</code> for iterators.
                                    </div>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Task Scheduler</h3>
                                    <pre><code class="language-lua">local Scheduler = {}

function Scheduler:new()
    local self = {tasks = {}}
    setmetatable(self, {__index = Scheduler})
    return self
end

function Scheduler:add(func)
    table.insert(self.tasks, coroutine.create(func))
end

function Scheduler:run()
    while #self.tasks > 0 do
        for i = #self.tasks, 1, -1 do
            local task = self.tasks[i]
            local success, err = coroutine.resume(task)
            
            if not success then
                print("Task error:", err)
                table.remove(self.tasks, i)
            elseif coroutine.status(task) == "dead" then
                table.remove(self.tasks, i)
            end
        end
    end
end

-- Usage
local scheduler = Scheduler:new()

scheduler:add(function()
    for i = 1, 3 do
        print("Task 1:", i)
        coroutine.yield()
    end
end)

scheduler:add(function()
    for i = 1, 3 do
        print("Task 2:", i)
        coroutine.yield()
    end
end)

scheduler:run()</code></pre>

                                    <h3>Async File Reader</h3>
                                    <pre><code class="language-lua">local function asyncReadFile(filename)
    return coroutine.create(function()
        local file = io.open(filename, "r")
        if not file then
            return nil, "File not found"
        end
        
        while true do
            local line = file:read("*line")
            if not line then break end
            coroutine.yield(line)
        end
        
        file:close()
    end)
end

-- Usage
local reader = asyncReadFile("data.txt")
while coroutine.status(reader) ~= "dead" do
    local success, line = coroutine.resume(reader)
    if success and line then
        print("Line:", line)
    end
end</code></pre>

                                    <h3>State Machine</h3>
                                    <pre><code class="language-lua">local function stateMachine()
    return coroutine.create(function()
        -- State 1: Idle
        print("State: Idle")
        local input = coroutine.yield()
        
        -- State 2: Processing
        if input == "start" then
            print("State: Processing")
            coroutine.yield()
            
            -- State 3: Complete
            print("State: Complete")
        else
            print("State: Error")
        end
    end)
end

local sm = stateMachine()
coroutine.resume(sm)
coroutine.resume(sm, "start")
coroutine.resume(sm)</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/coroutines-practical.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- coroutine.wrap() -->
                                    <h2>coroutine.wrap() vs coroutine.create()</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>create()</th>
                                                <th>wrap()</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Returns</td>
                                                <td>Coroutine object</td>
                                                <td>Function</td>
                                            </tr>
                                            <tr>
                                                <td>Resume</td>
                                                <td>coroutine.resume(co)</td>
                                                <td>func()</td>
                                            </tr>
                                            <tr>
                                                <td>Error handling</td>
                                                <td>Returns success, result</td>
                                                <td>Propagates errors</td>
                                            </tr>
                                            <tr>
                                                <td>Use case</td>
                                                <td>When you need error handling</td>
                                                <td>Simple iterators</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these coroutine challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-coroutines.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>What coroutines are and how they work</li>
                                            <li>Creating coroutines with <code>coroutine.create()</code></li>
                                            <li>Resuming and yielding with <code>resume()</code> and
                                                <code>yield()</code>
                                            </li>
                                            <li>Coroutine states (suspended, running, normal, dead)</li>
                                            <li>Passing values between resume and yield</li>
                                            <li>Common patterns (producer-consumer, iterators)</li>
                                            <li>Practical examples (scheduler, async reader, state machine)</li>
                                            <li>Difference between <code>create()</code> and <code>wrap()</code></li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered coroutines! Next, we'll explore <strong>file I/O</strong>—how to
                                        read and write files, handle different file modes, and work with the file
                                        system.
                                        Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="best-practices.jsp" />
                                    <jsp:param name="prevTitle" value="Best Practices" />
                                    <jsp:param name="nextLink" value="file-io.jsp" />
                                    <jsp:param name="nextTitle" value="File I/O" />
                                    <jsp:param name="currentLessonId" value="coroutines" />
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