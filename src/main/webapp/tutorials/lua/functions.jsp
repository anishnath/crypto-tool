<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions" ); request.setAttribute("currentModule", "Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Functions in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua functions: defining, calling, parameters, return values, multiple returns, and variadic functions. Learn to write reusable code.">
            <meta name="keywords"
                content="lua functions, function parameters, return values, variadic functions, lua tutorial, function definition">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Functions in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua functions: definition, parameters, return values, and advanced features.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/functions.jsp">
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
        "name": "Functions in Lua",
        "description": "Master Lua functions: defining, calling, parameters, return values, and variadic functions.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/functions.jsp",
        "keywords": "lua functions, function parameters, return values, variadic functions",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Function definition", "Parameters", "Return values", "Multiple returns", "Variadic functions"],
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
                "name": "Functions"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="functions">
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
                                    <span>Functions</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Functions in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Functions are reusable blocks of code that perform specific tasks.
                                        They're
                                        fundamental to writing clean, organized, and maintainable code. Lua treats
                                        functions
                                        as first-class values, meaning they can be stored in variables, passed as
                                        arguments,
                                        and returned from other functions. This makes Lua incredibly powerful for
                                        functional
                                        programming. Let's explore everything about functions!</p>

                                    <!-- Defining Functions -->
                                    <h2>Defining Functions</h2>
                                    <p>There are several ways to define functions in Lua:</p>

                                    <h3>Basic Function Definition</h3>
                                    <pre><code class="language-lua">function greet()
    print("Hello, World!")
end

greet()  -- Call the function</code></pre>

                                    <h3>Function as Variable</h3>
                                    <pre><code class="language-lua">local greet = function()
    print("Hello, World!")
end

greet()  -- Same result</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always use <code>local</code> for function
                                        variables
                                        to avoid polluting the global namespace:
                                        <pre><code class="language-lua">local function greet()
    print("Hello!")
end</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Function Parameters -->
                                    <h2>Function Parameters</h2>
                                    <p>Functions can accept input through parameters:</p>

                                    <pre><code class="language-lua">local function greet(name)
    print("Hello, " .. name .. "!")
end

greet("Alice")  -- Hello, Alice!
greet("Bob")    -- Hello, Bob!</code></pre>

                                    <h3>Multiple Parameters</h3>
                                    <pre><code class="language-lua">local function add(a, b)
    return a + b
end

local result = add(5, 3)
print(result)  -- 8</code></pre>

                                    <h3>Default Parameters</h3>
                                    <p>Lua doesn't have built-in default parameters, but you can use <code>or</code>:
                                    </p>

                                    <pre><code class="language-lua">local function greet(name)
    name = name or "Guest"  -- Default to "Guest" if nil
    print("Hello, " .. name)
end

greet()         -- Hello, Guest
greet("Alice")  -- Hello, Alice</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-params.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-params" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Return Values -->
                                    <h2>Return Values</h2>
                                    <p>Functions can return values using the <code>return</code> statement:</p>

                                    <pre><code class="language-lua">local function square(x)
    return x * x
end

local result = square(5)
print(result)  -- 25</code></pre>

                                    <h3>Multiple Return Values</h3>
                                    <p>Lua functions can return multiple values—a unique and powerful feature!</p>

                                    <pre><code class="language-lua">local function divmod(a, b)
    local quotient = math.floor(a / b)
    local remainder = a % b
    return quotient, remainder
end

local q, r = divmod(17, 5)
print("Quotient:", q)   -- 3
print("Remainder:", r)  -- 2</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Multiple return values are commonly used in Lua. Many
                                        standard
                                        library functions return multiple values, like <code>string.find()</code> which
                                        returns start and end positions.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-return.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-return" />
                                    </jsp:include>

                                    <!-- Variadic Functions -->
                                    <h2>Variadic Functions</h2>
                                    <p>Functions can accept variable numbers of arguments using <code>...</code>:</p>

                                    <pre><code class="language-lua">local function sum(...)
    local total = 0
    for i, v in ipairs({...}) do
        total = total + v
    end
    return total
end

print(sum(1, 2, 3))        -- 6
print(sum(10, 20, 30, 40)) -- 100</code></pre>

                                    <h3>Accessing Variadic Arguments</h3>
                                    <pre><code class="language-lua">local function printAll(...)
    local args = {...}  -- Pack into table
    for i, v in ipairs(args) do
        print(i, v)
    end
end

printAll("apple", "banana", "cherry")</code></pre>

                                    <h3>Mixed Parameters</h3>
                                    <pre><code class="language-lua">local function greetAll(greeting, ...)
    local names = {...}
    for i, name in ipairs(names) do
        print(greeting .. ", " .. name .. "!")
    end
end

greetAll("Hello", "Alice", "Bob", "Charlie")</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-variadic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-variadic" />
                                    </jsp:include>

                                    <!-- Functions as Values -->
                                    <h2>Functions as First-Class Values</h2>
                                    <p>In Lua, functions are values that can be stored and passed around:</p>

                                    <h3>Storing in Variables</h3>
                                    <pre><code class="language-lua">local function add(a, b)
    return a + b
end

local operation = add  -- Store function in variable
print(operation(5, 3))  -- 8</code></pre>

                                    <h3>Passing to Other Functions</h3>
                                    <pre><code class="language-lua">local function apply(func, a, b)
    return func(a, b)
end

local function multiply(x, y)
    return x * y
end

local result = apply(multiply, 4, 5)
print(result)  -- 20</code></pre>

                                    <h3>Returning Functions</h3>
                                    <pre><code class="language-lua">local function createMultiplier(factor)
    return function(x)
        return x * factor
    end
end

local double = createMultiplier(2)
local triple = createMultiplier(3)

print(double(5))  -- 10
print(triple(5))  -- 15</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-firstclass.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-firstclass" />
                                    </jsp:include>

                                    <!-- Anonymous Functions -->
                                    <h2>Anonymous Functions</h2>
                                    <p>Functions without names, often used as callbacks:</p>

                                    <pre><code class="language-lua">-- Sort with custom comparator
local numbers = {5, 2, 8, 1, 9}
table.sort(numbers, function(a, b)
    return a > b  -- Sort descending
end)

-- Map function
local function map(array, func)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = func(v)
    end
    return result
end

local doubled = map({1, 2, 3}, function(x)
    return x * 2
end)
-- doubled = {2, 4, 6}</code></pre>

                                    <!-- Scope and Closures Preview -->
                                    <h2>Variable Scope</h2>
                                    <p>Variables in functions follow scoping rules:</p>

                                    <pre><code class="language-lua">local x = 10  -- Global to this file

local function test()
    local y = 20  -- Local to function
    print(x)      -- Can access outer x
    print(y)      -- Can access local y
end

test()
-- print(y)  -- Error: y is not accessible here</code></pre>

                                    <div class="info-box">
                                        <strong>Scope Rules:</strong>
                                        <ul>
                                            <li>Local variables are only accessible within their block</li>
                                            <li>Functions can access variables from outer scopes</li>
                                            <li>Parameters are local to the function</li>
                                            <li>Always use <code>local</code> to avoid global pollution</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these function challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-functions.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Defining functions with <code>function</code> keyword</li>
                                            <li>Function parameters and default values</li>
                                            <li>Returning single and multiple values</li>
                                            <li>Variadic functions with <code>...</code></li>
                                            <li>Functions as first-class values</li>
                                            <li>Anonymous functions for callbacks</li>
                                            <li>Variable scope in functions</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered the basics of functions! Next, we'll explore
                                        <strong>closures</strong>
                                        —one of Lua's most powerful features. You'll learn how functions can "remember"
                                        their
                                        environment, enabling advanced patterns like private variables, factories, and
                                        decorators. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="loops.jsp" />
                                    <jsp:param name="prevTitle" value="Loops" />
                                    <jsp:param name="nextLink" value="closures.jsp" />
                                    <jsp:param name="nextTitle" value="Closures" />
                                    <jsp:param name="currentLessonId" value="functions" />
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