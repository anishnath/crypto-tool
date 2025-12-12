<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-functions" ); request.setAttribute("currentModule", "Functions"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Advanced Functions in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master advanced Lua function techniques: higher-order functions, map/filter/reduce, function composition, currying, and functional programming patterns.">
            <meta name="keywords"
                content="lua advanced functions, higher-order functions, map filter reduce, function composition, currying, functional programming lua">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Advanced Functions in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn advanced Lua function techniques: higher-order functions, composition, and functional programming.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/advanced-functions.jsp">
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
        "name": "Advanced Functions in Lua",
        "description": "Master advanced Lua function techniques including higher-order functions, composition, and functional programming.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/advanced-functions.jsp",
        "keywords": "lua advanced functions, higher-order functions, map filter reduce, function composition",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Higher-order functions", "Map/Filter/Reduce", "Function composition", "Currying", "Functional programming"],
        "timeRequired": "PT35M",
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
                "name": "Advanced Functions"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="advanced-functions">
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
                                    <span>Advanced Functions</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Advanced Functions in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Advanced function techniques unlock the full power of Lua's
                                        functional
                                        programming capabilities. In this lesson, you'll learn about higher-order
                                        functions,
                                        function composition, currying, and classic functional patterns like map,
                                        filter, and
                                        reduce. These techniques will help you write more elegant, reusable, and
                                        expressive
                                        code. Let's dive into advanced function mastery!</p>

                                    <!-- Higher-Order Functions -->
                                    <h2>Higher-Order Functions</h2>
                                    <p>A higher-order function is a function that either:</p>
                                    <ul>
                                        <li>Takes one or more functions as arguments, OR</li>
                                        <li>Returns a function as its result</li>
                                    </ul>

                                    <h3>Functions as Arguments</h3>
                                    <pre><code class="language-lua">local function apply(func, value)
    return func(value)
end

local function double(x)
    return x * 2
end

local function square(x)
    return x * x
end

print(apply(double, 5))  -- 10
print(apply(square, 5))  -- 25</code></pre>

                                    <h3>Functions as Return Values</h3>
                                    <pre><code class="language-lua">local function createAdder(x)
    return function(y)
        return x + y
    end
end

local add5 = createAdder(5)
local add10 = createAdder(10)

print(add5(3))   -- 8
print(add10(3))  -- 13</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-higher-order.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-higher-order" />
                                    </jsp:include>

                                    <!-- Map, Filter, Reduce -->
                                    <h2>Map, Filter, and Reduce</h2>
                                    <p>These are fundamental functional programming patterns:</p>

                                    <h3>Map - Transform Each Element</h3>
                                    <pre><code class="language-lua">local function map(array, func)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = func(v)
    end
    return result
end

local numbers = {1, 2, 3, 4, 5}
local doubled = map(numbers, function(x) return x * 2 end)
-- doubled = {2, 4, 6, 8, 10}

local squared = map(numbers, function(x) return x * x end)
-- squared = {1, 4, 9, 16, 25}</code></pre>

                                    <h3>Filter - Select Elements</h3>
                                    <pre><code class="language-lua">local function filter(array, predicate)
    local result = {}
    for i, v in ipairs(array) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local evens = filter(numbers, function(x) return x % 2 == 0 end)
-- evens = {2, 4, 6, 8, 10}

local greaterThan5 = filter(numbers, function(x) return x > 5 end)
-- greaterThan5 = {6, 7, 8, 9, 10}</code></pre>

                                    <h3>Reduce - Combine Elements</h3>
                                    <pre><code class="language-lua">local function reduce(array, func, initial)
    local accumulator = initial
    for i, v in ipairs(array) do
        accumulator = func(accumulator, v)
    end
    return accumulator
end

local numbers = {1, 2, 3, 4, 5}

-- Sum
local sum = reduce(numbers, function(acc, x) return acc + x end, 0)
print(sum)  -- 15

-- Product
local product = reduce(numbers, function(acc, x) return acc * x end, 1)
print(product)  -- 120

-- Max
local max = reduce(numbers, function(acc, x) return math.max(acc, x) end, numbers[1])
print(max)  -- 5</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-higher-order.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-map-filter" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Map, filter, and reduce make your code more
                                        declarative and easier to understand. Instead of writing loops, you describe
                                        <em>what</em> you want to do, not <em>how</em> to do it.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Function Composition -->
                                    <h2>Function Composition</h2>
                                    <p>Combine multiple functions into a single function:</p>

                                    <pre><code class="language-lua">local function compose(f, g)
    return function(x)
        return f(g(x))
    end
end

local function double(x)
    return x * 2
end

local function addOne(x)
    return x + 1
end

-- Compose: first addOne, then double
local doubleAfterAddOne = compose(double, addOne)
print(doubleAfterAddOne(5))  -- 12 (5 + 1 = 6, 6 * 2 = 12)

-- Multiple composition
local function square(x)
    return x * x
end

local complexFunc = compose(compose(square, double), addOne)
print(complexFunc(3))  -- 64 (3 + 1 = 4, 4 * 2 = 8, 8 * 8 = 64)</code></pre>

                                    <h3>Pipe - Left-to-Right Composition</h3>
                                    <pre><code class="language-lua">local function pipe(...)
    local funcs = {...}
    return function(x)
        local result = x
        for i, func in ipairs(funcs) do
            result = func(result)
        end
        return result
    end
end

-- More readable: addOne -> double -> square
local transform = pipe(addOne, double, square)
print(transform(3))  -- 64</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-higher-order.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-composition" />
                                    </jsp:include>

                                    <!-- Currying -->
                                    <h2>Currying</h2>
                                    <p>Transform a function with multiple arguments into a sequence of functions:</p>

                                    <pre><code class="language-lua">-- Regular function
local function add(a, b, c)
    return a + b + c
end

-- Curried version
local function curriedAdd(a)
    return function(b)
        return function(c)
            return a + b + c
        end
    end
end

print(add(1, 2, 3))              -- 6
print(curriedAdd(1)(2)(3))       -- 6

-- Partial application with currying
local add1 = curriedAdd(1)
local add1and2 = add1(2)
print(add1and2(3))  -- 6</code></pre>

                                    <h3>Generic Curry Function</h3>
                                    <pre><code class="language-lua">local function curry(func, numArgs)
    local function curried(args)
        return function(x)
            local newArgs = {table.unpack(args)}
            table.insert(newArgs, x)
            
            if #newArgs >= numArgs then
                return func(table.unpack(newArgs))
            else
                return curried(newArgs)
            end
        end
    end
    
    return curried({})
end

local function multiply(a, b, c)
    return a * b * c
end

local curriedMultiply = curry(multiply, 3)
print(curriedMultiply(2)(3)(4))  -- 24</code></pre>

                                    <!-- Partial Application -->
                                    <h2>Partial Application</h2>
                                    <p>Fix some arguments of a function, creating a new function:</p>

                                    <pre><code class="language-lua">local function partial(func, ...)
    local fixedArgs = {...}
    return function(...)
        local allArgs = {}
        for i, v in ipairs(fixedArgs) do
            table.insert(allArgs, v)
        end
        for i, v in ipairs({...}) do
            table.insert(allArgs, v)
        end
        return func(table.unpack(allArgs))
    end
end

local function greet(greeting, name)
    return greeting .. ", " .. name .. "!"
end

local sayHello = partial(greet, "Hello")
local sayHi = partial(greet, "Hi")

print(sayHello("Alice"))  -- Hello, Alice!
print(sayHi("Bob"))       -- Hi, Bob!</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-higher-order.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-currying" />
                                    </jsp:include>

                                    <!-- Decorators -->
                                    <h2>Function Decorators</h2>
                                    <p>Wrap functions to add behavior without modifying them:</p>

                                    <pre><code class="language-lua">-- Timing decorator
local function timed(func)
    return function(...)
        local start = os.clock()
        local result = {func(...)}
        local elapsed = os.clock() - start
        print(string.format("Execution time: %.6f seconds", elapsed))
        return table.unpack(result)
    end
end

-- Logging decorator
local function logged(func, name)
    return function(...)
        print("Calling " .. name .. " with args:", ...)
        local result = {func(...)}
        print("Result:", table.unpack(result))
        return table.unpack(result)
    end
end

-- Memoization decorator
local function memoized(func)
    local cache = {}
    return function(x)
        if cache[x] == nil then
            cache[x] = func(x)
        end
        return cache[x]
    end
end

-- Usage
local function fibonacci(n)
    if n <= 1 then return n end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

local fastFib = memoized(fibonacci)
local timedFib = timed(fastFib)

print(timedFib(30))</code></pre>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Data Processing Pipeline</h3>
                                    <pre><code class="language-lua">local users = {
    {name = "Alice", age = 25, active = true},
    {name = "Bob", age = 30, active = false},
    {name = "Charlie", age = 35, active = true},
    {name = "David", age = 28, active = true}
}

-- Get names of active users over 25
local activeUsers = filter(users, function(u) return u.active end)
local over25 = filter(activeUsers, function(u) return u.age > 25 end)
local names = map(over25, function(u) return u.name end)
-- names = {"Charlie", "David"}

-- Or using composition
local getActiveUsersOver25 = pipe(
    function(users) return filter(users, function(u) return u.active end) end,
    function(users) return filter(users, function(u) return u.age > 25 end) end,
    function(users) return map(users, function(u) return u.name end) end
)

local result = getActiveUsersOver25(users)</code></pre>

                                    <h3>Validation Pipeline</h3>
                                    <pre><code class="language-lua">local function validate(validators)
    return function(value)
        for i, validator in ipairs(validators) do
            local valid, error = validator(value)
            if not valid then
                return false, error
            end
        end
        return true
    end
end

local function notEmpty(value)
    if value == "" then
        return false, "Value cannot be empty"
    end
    return true
end

local function minLength(min)
    return function(value)
        if #value < min then
            return false, "Value must be at least " .. min .. " characters"
        end
        return true
    end
end

local validateUsername = validate({
    notEmpty,
    minLength(3)
})

print(validateUsername("ab"))      -- false, "Value must be at least 3 characters"
print(validateUsername("alice"))   -- true</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/functions-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these advanced function challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-advanced-functions.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Higher-order functions that take or return functions</li>
                                            <li>Map, filter, and reduce patterns for data transformation</li>
                                            <li>Function composition for combining functions</li>
                                            <li>Currying to transform multi-argument functions</li>
                                            <li>Partial application for fixing function arguments</li>
                                            <li>Function decorators for adding behavior</li>
                                            <li>Practical examples: data pipelines and validation</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing Module 3! You've mastered functions, closures, and
                                        advanced functional programming techniques. Next, we'll dive into
                                        <strong>tables</strong>
                                        —Lua's most versatile data structure. You'll learn how to use tables as arrays,
                                        dictionaries, objects, and more. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="closures.jsp" />
                                    <jsp:param name="prevTitle" value="Closures" />
                                    <jsp:param name="nextLink" value="tables.jsp" />
                                    <jsp:param name="nextTitle" value="Tables" />
                                    <jsp:param name="currentLessonId" value="advanced-functions" />
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