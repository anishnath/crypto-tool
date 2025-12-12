<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "error-handling" );
        request.setAttribute("currentModule", "Modules & Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Error Handling in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master error handling in Lua: pcall, xpcall, error(), assert(), custom error handlers, and robust error handling patterns.">
            <meta name="keywords"
                content="lua error handling, pcall, xpcall, lua errors, assert lua, error recovery lua">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Error Handling in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn error handling in Lua: pcall, xpcall, and robust error handling patterns.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/error-handling.jsp">
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
        "name": "Error Handling in Lua",
        "description": "Master error handling in Lua: pcall, xpcall, and robust error handling patterns.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/error-handling.jsp",
        "keywords": "lua error handling, pcall, xpcall, lua errors, assert",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Error handling", "pcall", "xpcall", "error()", "assert()", "Custom error handlers"],
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
                "name": "Error Handling"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="error-handling">
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
                                    <span>Error Handling</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Error Handling in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Robust error handling is crucial for building reliable applications.
                                        Lua
                                        provides several mechanisms for handling errors: <code>error()</code>,
                                        <code>assert()</code>, <code>pcall()</code>, and <code>xpcall()</code>. In this
                                        lesson, you'll learn how to handle errors gracefully and build resilient code.
                                        Let's
                                        explore error handling in Lua!
                                    </p>

                                    <!-- Raising Errors -->
                                    <h2>Raising Errors</h2>

                                    <h3>Using error()</h3>
                                    <pre><code class="language-lua">function divide(a, b)
    if b == 0 then
        error("Division by zero")
    end
    return a / b
end

-- This will raise an error
-- divide(10, 0)  -- Error: Division by zero</code></pre>

                                    <h3>Error with Level</h3>
                                    <pre><code class="language-lua">function validateAge(age)
    if type(age) ~= "number" then
        error("Age must be a number", 2)  -- Level 2: caller's location
    end
    if age < 0 or age > 150 then
        error("Age must be between 0 and 150", 2)
    end
    return true
end</code></pre>

                                    <div class="info-box">
                                        <strong>Error Levels:</strong>
                                        <ul>
                                            <li><code>1</code> (default): Error at current function</li>
                                            <li><code>2</code>: Error at caller's location</li>
                                            <li><code>0</code>: No location information</li>
                                        </ul>
                                    </div>

                                    <!-- Using assert() -->
                                    <h2>Using assert()</h2>
                                    <p><code>assert()</code> raises an error if a condition is false:</p>

                                    <pre><code class="language-lua">function sqrt(x)
    assert(x >= 0, "Cannot take square root of negative number")
    return math.sqrt(x)
end

print(sqrt(16))  -- 4
-- print(sqrt(-4))  -- Error: Cannot take square root of negative number</code></pre>

                                    <h3>Assert with Function Calls</h3>
                                    <pre><code class="language-lua">-- Assert that a file opened successfully
local file = assert(io.open("data.txt", "r"), "Failed to open file")

-- Assert function return values
local function getConfig()
    return nil, "Configuration not found"
end

local config = assert(getConfig())  -- Error: Configuration not found</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/error-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Protected Calls with pcall() -->
                                    <h2>Protected Calls with pcall()</h2>
                                    <p><code>pcall()</code> (protected call) catches errors without stopping execution:
                                    </p>

                                    <pre><code class="language-lua">function riskyFunction()
    error("Something went wrong!")
end

local success, result = pcall(riskyFunction)

if success then
    print("Success:", result)
else
    print("Error:", result)  -- Error: Something went wrong!
end</code></pre>

                                    <h3>pcall() with Arguments</h3>
                                    <pre><code class="language-lua">function divide(a, b)
    if b == 0 then
        error("Division by zero")
    end
    return a / b
end

local success, result = pcall(divide, 10, 2)
print(success, result)  -- true  5

local success, error = pcall(divide, 10, 0)
print(success, error)  -- false  Division by zero</code></pre>

                                    <h3>Practical pcall() Usage</h3>
                                    <pre><code class="language-lua">local function safeRequire(module)
    local success, result = pcall(require, module)
    if success then
        return result
    else
        print("Warning: Failed to load module " .. module)
        return nil
    end
end

local json = safeRequire("json")
if json then
    -- Use json module
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/error-pcall.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-pcall" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- xpcall() with Error Handler -->
                                    <h2>xpcall() with Error Handler</h2>
                                    <p><code>xpcall()</code> allows you to specify a custom error handler:</p>

                                    <pre><code class="language-lua">local function errorHandler(err)
    return "Error occurred: " .. tostring(err) .. "\n" .. debug.traceback()
end

local function riskyFunction()
    local x = nil
    return x.field  -- Error: attempt to index nil value
end

local success, result = xpcall(riskyFunction, errorHandler)

if not success then
    print(result)  -- Prints error with stack trace
end</code></pre>

                                    <h3>Custom Error Handler</h3>
                                    <pre><code class="language-lua">local function detailedErrorHandler(err)
    local info = {
        error = tostring(err),
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        traceback = debug.traceback()
    }
    return info
end

local function buggyFunction()
    error("Oops!")
end

local success, errorInfo = xpcall(buggyFunction, detailedErrorHandler)

if not success then
    print("Error:", errorInfo.error)
    print("Time:", errorInfo.timestamp)
    print("Trace:", errorInfo.traceback)
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/error-xpcall.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-xpcall" />
                                    </jsp:include>

                                    <!-- Error Handling Patterns -->
                                    <h2>Error Handling Patterns</h2>

                                    <h3>Return nil, error Pattern</h3>
                                    <pre><code class="language-lua">local function readFile(filename)
    local file, err = io.open(filename, "r")
    if not file then
        return nil, "Failed to open file: " .. err
    end
    
    local content = file:read("*all")
    file:close()
    
    return content
end

local content, err = readFile("data.txt")
if not content then
    print("Error:", err)
else
    print("Content:", content)
end</code></pre>

                                    <h3>Try-Catch Pattern</h3>
                                    <pre><code class="language-lua">local function try(func, catch)
    local success, result = pcall(func)
    if not success then
        if catch then
            catch(result)
        end
        return nil
    end
    return result
end

-- Usage
try(function()
    error("Something went wrong")
end, function(err)
    print("Caught error:", err)
end)</code></pre>

                                    <h3>Retry Pattern</h3>
                                    <pre><code class="language-lua">local function retry(func, maxAttempts, delay)
    local attempts = 0
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        local success, result = pcall(func)
        
        if success then
            return result
        end
        
        if attempts < maxAttempts then
            print("Attempt " .. attempts .. " failed, retrying...")
            -- In real code, you'd sleep here
        end
    end
    
    error("Failed after " .. maxAttempts .. " attempts")
end

-- Usage
local result = retry(function()
    -- Potentially failing operation
    if math.random() > 0.7 then
        return "Success!"
    else
        error("Random failure")
    end
end, 3)</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/error-pcall.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <!-- Validation and Error Messages -->
                                    <h2>Validation and Error Messages</h2>

                                    <h3>Input Validation</h3>
                                    <pre><code class="language-lua">local function createUser(name, email, age)
    -- Validate name
    assert(type(name) == "string", "Name must be a string")
    assert(#name > 0, "Name cannot be empty")
    
    -- Validate email
    assert(type(email) == "string", "Email must be a string")
    assert(email:match("^[%w.]+@[%w.]+%.%w+$"), "Invalid email format")
    
    -- Validate age
    assert(type(age) == "number", "Age must be a number")
    assert(age >= 0 and age <= 150, "Age must be between 0 and 150")
    
    return {
        name = name,
        email = email,
        age = age
    }
end

local success, result = pcall(createUser, "Alice", "alice@example.com", 25)
if success then
    print("User created:", result.name)
else
    print("Validation error:", result)
end</code></pre>

                                    <h3>Custom Error Types</h3>
                                    <pre><code class="language-lua">local ValidationError = {}
ValidationError.__index = ValidationError

function ValidationError:new(field, message)
    local self = setmetatable({}, ValidationError)
    self.type = "ValidationError"
    self.field = field
    self.message = message
    return self
end

function ValidationError:__tostring()
    return string.format("ValidationError [%s]: %s", self.field, self.message)
end

local function validateUser(user)
    if not user.name or #user.name == 0 then
        error(ValidationError:new("name", "Name is required"))
    end
    if not user.email or not user.email:match("@") then
        error(ValidationError:new("email", "Invalid email"))
    end
    return true
end

local success, err = pcall(validateUser, {name = "", email = "invalid"})
if not success then
    if type(err) == "table" and err.type == "ValidationError" then
        print("Validation failed:", err.field, err.message)
    else
        print("Unknown error:", err)
    end
end</code></pre>

                                    <!-- Best Practices -->
                                    <h2>Error Handling Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Best Practices:</strong>
                                        <ul>
                                            <li><strong>Use pcall() for risky operations:</strong> File I/O, network
                                                calls,
                                                external modules</li>
                                            <li><strong>Provide meaningful error messages:</strong> Help users
                                                understand
                                                what went wrong</li>
                                            <li><strong>Validate early:</strong> Check inputs at function entry</li>
                                            <li><strong>Use assert() for preconditions:</strong> Document assumptions
                                            </li>
                                            <li><strong>Return nil, error for expected failures:</strong> Use error()
                                                for
                                                unexpected failures</li>
                                            <li><strong>Log errors appropriately:</strong> Include context and stack
                                                traces
                                            </li>
                                            <li><strong>Clean up resources:</strong> Use pcall() with cleanup in finally
                                                pattern</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these error handling challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-error-handling.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Raising errors with <code>error()</code> and <code>assert()</code></li>
                                            <li>Protected calls with <code>pcall()</code></li>
                                            <li>Custom error handlers with <code>xpcall()</code></li>
                                            <li>Common error handling patterns (try-catch, retry, nil-error)</li>
                                            <li>Input validation and custom error types</li>
                                            <li>Error handling best practices</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered error handling! Next, we'll explore <strong>debugging</strong>
                                        techniques in Lua. You'll learn how to use the debug library, print debugging,
                                        logging, and tools for finding and fixing bugs. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="creating-modules.jsp" />
                                    <jsp:param name="prevTitle" value="Creating Modules" />
                                    <jsp:param name="nextLink" value="debugging.jsp" />
                                    <jsp:param name="nextTitle" value="Debugging" />
                                    <jsp:param name="currentLessonId" value="error-handling" />
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