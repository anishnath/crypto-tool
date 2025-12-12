<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "creating-modules" );
        request.setAttribute("currentModule", "Modules & Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Creating Modules in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master advanced module creation in Lua: module design, exports, private members, initialization, and professional module patterns.">
            <meta name="keywords"
                content="lua modules, module design, module exports, lua packages, module patterns, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Creating Modules in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn advanced module creation techniques in Lua for professional code organization.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/creating-modules.jsp">
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
        "name": "Creating Modules in Lua",
        "description": "Master advanced module creation in Lua: design, exports, and professional patterns.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/creating-modules.jsp",
        "keywords": "lua modules, module design, module exports, module patterns",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Module design", "Exports", "Private members", "Initialization", "Module patterns"],
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
                "name": "Creating Modules"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="creating-modules">
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
                                    <span>Creating Modules</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Creating Modules in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Creating well-designed modules is essential for building
                                        maintainable Lua
                                        applications. In this lesson, you'll learn advanced module creation techniques
                                        including proper exports, private members, initialization patterns, and
                                        professional
                                        module design. Let's explore how to create robust, reusable modules!</p>

                                    <!-- Module Creation Patterns -->
                                    <h2>Module Creation Patterns</h2>

                                    <h3>Basic Module Pattern</h3>
                                    <pre><code class="language-lua">-- mymodule.lua
local M = {}

function M.func1()
    return "Function 1"
end

function M.func2()
    return "Function 2"
end

return M</code></pre>

                                    <h3>Module with Private Functions</h3>
                                    <pre><code class="language-lua">-- validator.lua
local M = {}

-- Private helper function
local function isString(value)
    return type(value) == "string"
end

-- Private helper function
local function isNumber(value)
    return type(value) == "number"
end

-- Public function using private helpers
function M.validateEmail(email)
    if not isString(email) then
        return false, "Email must be a string"
    end
    if not email:match("^[%w.]+@[%w.]+%.%w+$") then
        return false, "Invalid email format"
    end
    return true
end

function M.validateAge(age)
    if not isNumber(age) then
        return false, "Age must be a number"
    end
    if age < 0 or age > 150 then
        return false, "Age must be between 0 and 150"
    end
    return true
end

return M</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/module-creation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-creation" />
                                    </jsp:include>

                                    <!-- Module Exports -->
                                    <h2>Module Exports</h2>

                                    <h3>Explicit Exports</h3>
                                    <pre><code class="language-lua">-- math_utils.lua
local M = {}

local function square(x)
    return x * x
end

local function cube(x)
    return x * x * x
end

-- Explicitly export functions
M.square = square
M.cube = cube

-- Or define directly
M.add = function(a, b)
    return a + b
end

return M</code></pre>

                                    <h3>Selective Exports</h3>
                                    <pre><code class="language-lua">-- database.lua
local M = {}

-- Internal state (not exported)
local connection = nil
local isConnected = false

-- Private function
local function validateConnection()
    if not isConnected then
        error("Not connected to database")
    end
end

-- Public API
function M.connect(host, port)
    connection = {host = host, port = port}
    isConnected = true
    return true
end

function M.disconnect()
    connection = nil
    isConnected = false
end

function M.query(sql)
    validateConnection()
    -- Execute query
    return "Query result"
end

-- Export only what's needed
return M</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/module-exports.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exports" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Module Initialization -->
                                    <h2>Module Initialization</h2>

                                    <h3>Initialization on Load</h3>
                                    <pre><code class="language-lua">-- config.lua
local M = {}

-- Initialize on module load
local defaults = {
    debug = false,
    timeout = 30,
    retries = 3
}

local settings = {}

-- Copy defaults
for k, v in pairs(defaults) do
    settings[k] = v
end

function M.set(key, value)
    settings[key] = value
end

function M.get(key)
    return settings[key]
end

function M.reset()
    for k, v in pairs(defaults) do
        settings[k] = v
    end
end

return M</code></pre>

                                    <h3>Lazy Initialization</h3>
                                    <pre><code class="language-lua">-- cache.lua
local M = {}

local cache = nil

local function initCache()
    if not cache then
        cache = {}
        print("Cache initialized")
    end
end

function M.set(key, value)
    initCache()
    cache[key] = value
end

function M.get(key)
    initCache()
    return cache[key]
end

return M</code></pre>

                                    <!-- Module Constants -->
                                    <h2>Module Constants and Metadata</h2>
                                    <pre><code class="language-lua">-- http.lua
local M = {}

-- Constants
M.VERSION = "1.0.0"
M.AUTHOR = "Your Name"

M.STATUS_CODES = {
    OK = 200,
    NOT_FOUND = 404,
    SERVER_ERROR = 500
}

M.METHODS = {
    GET = "GET",
    POST = "POST",
    PUT = "PUT",
    DELETE = "DELETE"
}

-- Functions
function M.request(method, url)
    if not M.METHODS[method] then
        error("Invalid HTTP method")
    end
    -- Make request
    return {status = M.STATUS_CODES.OK}
end

return M</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/module-private.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-constants" />
                                    </jsp:include>

                                    <!-- Module Documentation -->
                                    <h2>Module Documentation</h2>
                                    <pre><code class="language-lua">--[[
    String Utilities Module
    
    Provides common string manipulation functions.
    
    @module string_utils
    @author Your Name
    @version 1.0.0
    @license MIT
]]

local M = {}

--[[
    Trims whitespace from both ends of a string
    
    @param s string The string to trim
    @return string The trimmed string
    @usage local result = string_utils.trim("  hello  ")
]]
function M.trim(s)
    return s:match("^%s*(.-)%s*$")
end

--[[
    Splits a string by a delimiter
    
    @param s string The string to split
    @param delimiter string The delimiter to split by
    @return table Array of string parts
    @usage local parts = string_utils.split("a,b,c", ",")
]]
function M.split(s, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    for match in s:gmatch(pattern) do
        table.insert(result, match)
    end
    return result
end

return M</code></pre>

                                    <!-- Practical Module Examples -->
                                    <h2>Practical Module Examples</h2>

                                    <h3>Event Emitter Module</h3>
                                    <pre><code class="language-lua">-- event_emitter.lua
local M = {}

function M.new()
    local self = {
        listeners = {}
    }
    
    function self:on(event, callback)
        if not self.listeners[event] then
            self.listeners[event] = {}
        end
        table.insert(self.listeners[event], callback)
    end
    
    function self:emit(event, ...)
        if self.listeners[event] then
            for i, callback in ipairs(self.listeners[event]) do
                callback(...)
            end
        end
    end
    
    function self:off(event, callback)
        if self.listeners[event] then
            for i, cb in ipairs(self.listeners[event]) do
                if cb == callback then
                    table.remove(self.listeners[event], i)
                    break
                end
            end
        end
    end
    
    return self
end

return M</code></pre>

                                    <h3>Validation Module</h3>
                                    <pre><code class="language-lua">-- validation.lua
local M = {}

local validators = {}

function validators.required(value)
    if value == nil or value == "" then
        return false, "This field is required"
    end
    return true
end

function validators.email(value)
    if not value:match("^[%w.]+@[%w.]+%.%w+$") then
        return false, "Invalid email format"
    end
    return true
end

function validators.minLength(min)
    return function(value)
        if #value < min then
            return false, "Minimum length is " .. min
        end
        return true
    end
end

function validators.maxLength(max)
    return function(value)
        if #value > max then
            return false, "Maximum length is " .. max
        end
        return true
    end
end

function M.validate(value, rules)
    for i, rule in ipairs(rules) do
        local valid, error = rule(value)
        if not valid then
            return false, error
        end
    end
    return true
end

M.validators = validators

return M</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/module-creation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- Module Best Practices -->
                                    <h2>Module Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Best Practices:</strong>
                                        <ul>
                                            <li><strong>Use local for everything:</strong> Avoid global variables</li>
                                            <li><strong>Return a table:</strong> Always return the module table</li>
                                            <li><strong>Keep it focused:</strong> One module, one responsibility</li>
                                            <li><strong>Document your API:</strong> Add comments for public functions
                                            </li>
                                            <li><strong>Version your modules:</strong> Include version information</li>
                                            <li><strong>Hide implementation:</strong> Keep private functions local</li>
                                            <li><strong>Avoid side effects:</strong> Don't modify global state</li>
                                            <li><strong>Test your modules:</strong> Write tests for public API</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try creating these modules:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-module-creation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Advanced module creation patterns</li>
                                            <li>Explicit and selective exports</li>
                                            <li>Module initialization strategies</li>
                                            <li>Adding constants and metadata</li>
                                            <li>Documenting modules properly</li>
                                            <li>Practical examples: EventEmitter, Validation</li>
                                            <li>Module best practices</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can create professional modules, it's time to learn
                                        <strong>error handling</strong>! In the next lesson, you'll explore how to
                                        handle
                                        errors gracefully using pcall, xpcall, and custom error handling patterns. Let's
                                        continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="modules.jsp" />
                                    <jsp:param name="prevTitle" value="Modules" />
                                    <jsp:param name="nextLink" value="error-handling.jsp" />
                                    <jsp:param name="nextTitle" value="Error Handling" />
                                    <jsp:param name="currentLessonId" value="creating-modules" />
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