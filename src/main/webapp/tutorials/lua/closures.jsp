<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "closures" ); request.setAttribute("currentModule", "Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Closures in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua closures: lexical scoping, upvalues, private variables, factory functions, and practical closure patterns. Learn advanced function techniques.">
            <meta name="keywords"
                content="lua closures, upvalues, lexical scoping, private variables, factory functions, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Closures in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua closures: how functions capture and remember their environment for powerful programming patterns.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/closures.jsp">
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
        "name": "Closures in Lua",
        "description": "Master Lua closures: lexical scoping, upvalues, private variables, and factory functions.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/closures.jsp",
        "keywords": "lua closures, upvalues, lexical scoping, private variables, factory functions",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Closures", "Lexical scoping", "Upvalues", "Private variables", "Factory functions"],
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
                "name": "Closures"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="closures">
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
                                    <span>Closures</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Closures in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A closure is a function that captures and remembers variables from
                                        its
                                        surrounding scope, even after that scope has finished executing. Closures are
                                        one of
                                        Lua's most powerful features, enabling elegant solutions to complex problems.
                                        They're
                                        essential for creating private variables, factory functions, callbacks, and
                                        functional
                                        programming patterns. Let's explore how closures work and how to use them
                                        effectively!</p>

                                    <!-- What is a Closure? -->
                                    <h2>What is a Closure?</h2>
                                    <p>A closure is created when a function accesses variables from an outer scope:</p>

                                    <pre><code class="language-lua">local function createCounter()
    local count = 0  -- This variable is "captured"
    
    return function()
        count = count + 1
        return count
    end
end

local counter = createCounter()
print(counter())  -- 1
print(counter())  -- 2
print(counter())  -- 3</code></pre>

                                    <div class="info-box">
                                        <strong>Key Concept:</strong> The inner function "closes over" the
                                        <code>count</code>
                                        variable. Even though <code>createCounter()</code> has finished executing, the
                                        returned function still has access to <code>count</code>!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/closures-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Lexical Scoping -->
                                    <h2>Lexical Scoping</h2>
                                    <p>Lua uses lexical scoping, meaning functions can access variables from their
                                        enclosing
                                        scopes:</p>

                                    <pre><code class="language-lua">local x = 10

local function outer()
    local y = 20
    
    local function inner()
        local z = 30
        print(x, y, z)  -- Can access all three!
    end
    
    inner()
end

outer()  -- 10  20  30</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Variables captured by closures are called
                                        <strong>upvalues</strong>.
                                        Each closure maintains its own copy of upvalues, allowing multiple independent
                                        closures.
                                    </div>

                                    <!-- Private Variables -->
                                    <h2>Private Variables</h2>
                                    <p>Closures enable true private variables in Lua:</p>

                                    <pre><code class="language-lua">local function createBankAccount(initialBalance)
    local balance = initialBalance  -- Private!
    
    return {
        deposit = function(amount)
            balance = balance + amount
            return balance
        end,
        
        withdraw = function(amount)
            if amount > balance then
                return nil, "Insufficient funds"
            end
            balance = balance - amount
            return balance
        end,
        
        getBalance = function()
            return balance
        end
    }
end

local account = createBankAccount(1000)
print(account.getBalance())  -- 1000
account.deposit(500)
print(account.getBalance())  -- 1500
-- print(balance)  -- Error: balance is not accessible!</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/closures-private.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-private" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Factory Functions -->
                                    <h2>Factory Functions</h2>
                                    <p>Closures are perfect for creating factory functions that generate customized
                                        functions:</p>

                                    <pre><code class="language-lua">local function createMultiplier(factor)
    return function(x)
        return x * factor
    end
end

local double = createMultiplier(2)
local triple = createMultiplier(3)
local quadruple = createMultiplier(4)

print(double(5))     -- 10
print(triple(5))     -- 15
print(quadruple(5))  -- 20</code></pre>

                                    <h3>More Factory Examples</h3>
                                    <pre><code class="language-lua">-- Greeting factory
local function createGreeter(greeting)
    return function(name)
        return greeting .. ", " .. name .. "!"
    end
end

local sayHello = createGreeter("Hello")
local sayHi = createGreeter("Hi")

print(sayHello("Alice"))  -- Hello, Alice!
print(sayHi("Bob"))       -- Hi, Bob!

-- Validator factory
local function createValidator(min, max)
    return function(value)
        return value >= min and value <= max
    end
end

local isValidAge = createValidator(0, 120)
local isValidScore = createValidator(0, 100)

print(isValidAge(25))   -- true
print(isValidScore(150)) -- false</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/closures-factory.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-factory" />
                                    </jsp:include>

                                    <!-- Callbacks and Event Handlers -->
                                    <h2>Callbacks and Event Handlers</h2>
                                    <p>Closures are commonly used for callbacks that need to remember context:</p>

                                    <pre><code class="language-lua">local function createButton(label)
    local clickCount = 0
    
    return {
        onClick = function()
            clickCount = clickCount + 1
            print(label .. " clicked " .. clickCount .. " times")
        end
    }
end

local button1 = createButton("Submit")
local button2 = createButton("Cancel")

button1.onClick()  -- Submit clicked 1 times
button1.onClick()  -- Submit clicked 2 times
button2.onClick()  -- Cancel clicked 1 times</code></pre>

                                    <!-- Iterators with Closures -->
                                    <h2>Custom Iterators</h2>
                                    <p>Closures enable powerful custom iterators:</p>

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

-- Use in for loop
for i in range(1, 10, 2) do
    print(i)  -- 1, 3, 5, 7, 9
end

-- Fibonacci iterator
local function fibonacci()
    local a, b = 0, 1
    return function()
        a, b = b, a + b
        return a
    end
end

local fib = fibonacci()
for i = 1, 10 do
    print(fib())  -- 1, 1, 2, 3, 5, 8, 13, 21, 34, 55
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/closures-factory.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-iterators" />
                                    </jsp:include>

                                    <!-- Memoization -->
                                    <h2>Memoization Pattern</h2>
                                    <p>Use closures to cache expensive function results:</p>

                                    <pre><code class="language-lua">local function memoize(func)
    local cache = {}
    
    return function(x)
        if cache[x] == nil then
            cache[x] = func(x)
        end
        return cache[x]
    end
end

-- Expensive fibonacci
local function fib(n)
    if n <= 1 then return n end
    return fib(n - 1) + fib(n - 2)
end

local fastFib = memoize(fib)
print(fastFib(30))  -- Fast!
print(fastFib(30))  -- Even faster (cached)!</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Memoization is a powerful optimization
                                        technique.
                                        Use it for pure functions (same input always gives same output) with expensive
                                        computations.
                                    </div>

                                    <!-- Common Patterns -->
                                    <h2>Common Closure Patterns</h2>

                                    <h3>1. Configuration Object</h3>
                                    <pre><code class="language-lua">local function createConfig()
    local settings = {}
    
    return {
        set = function(key, value)
            settings[key] = value
        end,
        
        get = function(key)
            return settings[key]
        end,
        
        getAll = function()
            local copy = {}
            for k, v in pairs(settings) do
                copy[k] = v
            end
            return copy
        end
    }
end</code></pre>

                                    <h3>2. State Machine</h3>
                                    <pre><code class="language-lua">local function createStateMachine()
    local state = "idle"
    
    return {
        getState = function()
            return state
        end,
        
        transition = function(newState)
            print("Transitioning from " .. state .. " to " .. newState)
            state = newState
        end
    }
end</code></pre>

                                    <h3>3. Partial Application</h3>
                                    <pre><code class="language-lua">local function partial(func, ...)
    local args = {...}
    return function(...)
        local allArgs = {}
        for i, v in ipairs(args) do
            table.insert(allArgs, v)
        end
        for i, v in ipairs({...}) do
            table.insert(allArgs, v)
        end
        return func(table.unpack(allArgs))
    end
end

local function add(a, b, c)
    return a + b + c
end

local add5 = partial(add, 5)
print(add5(3, 2))  -- 10</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/closures-private.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these closure challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-closures.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>What closures are and how they work</li>
                                            <li>Lexical scoping and upvalues</li>
                                            <li>Creating private variables with closures</li>
                                            <li>Factory functions for generating customized functions</li>
                                            <li>Using closures for callbacks and event handlers</li>
                                            <li>Custom iterators with closures</li>
                                            <li>Memoization pattern for optimization</li>
                                            <li>Common closure patterns (config, state machine, partial application)
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered closures—one of Lua's most powerful features! Next, we'll explore
                                        <strong>advanced function techniques</strong> including higher-order functions,
                                        function
                                        composition, currying, and functional programming patterns. Let's continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions.jsp" />
                                    <jsp:param name="prevTitle" value="Functions" />
                                    <jsp:param name="nextLink" value="advanced-functions.jsp" />
                                    <jsp:param name="nextTitle" value="Advanced Functions" />
                                    <jsp:param name="currentLessonId" value="closures" />
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