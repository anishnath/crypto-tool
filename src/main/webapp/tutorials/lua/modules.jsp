<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "modules" );
        request.setAttribute("currentModule", "Object-Oriented Programming" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Modules in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua modules: create reusable packages, use require(), manage dependencies, and organize code with module patterns and best practices.">
            <meta name="keywords"
                content="lua modules, require lua, lua packages, module patterns, lua code organization, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Modules in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua modules: create reusable packages and organize your code effectively.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/modules.jsp">
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
        "name": "Modules in Lua",
        "description": "Master Lua modules: create reusable packages, use require(), and organize code effectively.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/modules.jsp",
        "keywords": "lua modules, require, packages, module patterns",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Modules", "require()", "Module patterns", "Code organization", "Dependencies"],
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
                "name": "Modules"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="modules">
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
                                    <span>Modules</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Modules in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Modules are the key to organizing and reusing code in Lua. They
                                        allow you
                                        to split your code into separate files, create libraries, and manage
                                        dependencies.
                                        Lua's module system is simple yet powerful, using tables and the
                                        <code>require()</code>
                                        function. In this lesson, you'll learn how to create, use, and organize modules
                                        effectively. Let's dive in!</p>

                                    <!-- What are Modules? -->
                                    <h2>What are Modules?</h2>
                                    <p>A module is simply a Lua file that returns a table containing functions and
                                        values:
                                    </p>

                                    <pre><code class="language-lua">-- mymodule.lua
local M = {}

function M.greet(name)
    return "Hello, " .. name
end

function M.add(a, b)
    return a + b
end

M.version = "1.0"

return M</code></pre>

                                    <div class="info-box">
                                        <strong>Module Structure:</strong>
                                        <ol>
                                            <li>Create a local table (usually named <code>M</code> or the module name)
                                            </li>
                                            <li>Add functions and values to the table</li>
                                            <li>Return the table at the end</li>
                                        </ol>
                                    </div>

                                    <!-- Using require() -->
                                    <h2>Using require()</h2>
                                    <p>Load modules with the <code>require()</code> function:</p>

                                    <pre><code class="language-lua">-- main.lua
local mymodule = require("mymodule")

print(mymodule.greet("Alice"))  -- Hello, Alice
print(mymodule.add(5, 3))       -- 8
print(mymodule.version)         -- 1.0</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> <code>require()</code> caches modules. If you require the
                                        same
                                        module multiple times, it only loads once and returns the cached version.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/modules-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Module Patterns -->
                                    <h2>Module Patterns</h2>

                                    <h3>1. Basic Table Module</h3>
                                    <pre><code class="language-lua">-- math_utils.lua
local M = {}

function M.square(x)
    return x * x
end

function M.cube(x)
    return x * x * x
end

return M</code></pre>

                                    <h3>2. Module with Private Functions</h3>
                                    <pre><code class="language-lua">-- calculator.lua
local M = {}

-- Private function (not exported)
local function validate(x)
    return type(x) == "number"
end

-- Public functions
function M.add(a, b)
    if not (validate(a) and validate(b)) then
        error("Arguments must be numbers")
    end
    return a + b
end

function M.multiply(a, b)
    if not (validate(a) and validate(b)) then
        error("Arguments must be numbers")
    end
    return a * b
end

return M</code></pre>

                                    <h3>3. Module with State</h3>
                                    <pre><code class="language-lua">-- counter.lua
local M = {}
local count = 0  -- Private state

function M.increment()
    count = count + 1
    return count
end

function M.decrement()
    count = count - 1
    return count
end

function M.get()
    return count
end

function M.reset()
    count = 0
end

return M</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/module-creation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Class Modules -->
                                    <h2>Class Modules</h2>
                                    <p>Modules can export classes:</p>

                                    <pre><code class="language-lua">-- person.lua
local Person = {}
Person.__index = Person

function Person:new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

function Person:greet()
    return "Hello, I'm " .. self.name
end

function Person:birthday()
    self.age = self.age + 1
end

return Person</code></pre>

                                    <pre><code class="language-lua">-- main.lua
local Person = require("person")

local alice = Person:new("Alice", 25)
print(alice:greet())  -- Hello, I'm Alice
alice:birthday()
print(alice.age)  -- 26</code></pre>

                                    <!-- Module Organization -->
                                    <h2>Module Organization</h2>

                                    <h3>Directory Structure</h3>
                                    <pre><code class="language-plaintext">myapp/
├── main.lua
├── lib/
│   ├── utils.lua
│   ├── database.lua
│   └── models/
│       ├── user.lua
│       └── product.lua
└── config.lua</code></pre>

                                    <h3>Loading from Subdirectories</h3>
                                    <pre><code class="language-lua">-- Use dot notation for subdirectories
local User = require("lib.models.user")
local utils = require("lib.utils")</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Lua searches for modules in paths specified by
                                        <code>package.path</code>. Use forward slashes or dots for subdirectories, not
                                        backslashes.
                                    </div>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>String Utilities Module</h3>
                                    <pre><code class="language-lua">-- string_utils.lua
local M = {}

function M.trim(s)
    return s:match("^%s*(.-)%s*$")
end

function M.split(s, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    for match in s:gmatch(pattern) do
        table.insert(result, match)
    end
    return result
end

function M.capitalize(s)
    return s:sub(1, 1):upper() .. s:sub(2):lower()
end

function M.reverse(s)
    return s:reverse()
end

return M</code></pre>

                                    <h3>Configuration Module</h3>
                                    <pre><code class="language-lua">-- config.lua
local M = {}

M.app = {
    name = "MyApp",
    version = "1.0.0",
    debug = true
}

M.database = {
    host = "localhost",
    port = 5432,
    name = "mydb"
}

M.server = {
    host = "0.0.0.0",
    port = 8080
}

function M.get(key)
    local keys = {}
    for k in key:gmatch("[^.]+") do
        table.insert(keys, k)
    end
    
    local value = M
    for i, k in ipairs(keys) do
        value = value[k]
        if not value then return nil end
    end
    return value
end

return M</code></pre>

                                    <h3>Logger Module</h3>
                                    <pre><code class="language-lua">-- logger.lua
local M = {}

local levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4
}

local currentLevel = levels.INFO

function M.setLevel(level)
    currentLevel = levels[level] or levels.INFO
end

local function log(level, message)
    if levels[level] >= currentLevel then
        print(string.format("[%s] %s: %s", 
            os.date("%Y-%m-%d %H:%M:%S"),
            level,
            message))
    end
end

function M.debug(message)
    log("DEBUG", message)
end

function M.info(message)
    log("INFO", message)
end

function M.warn(message)
    log("WARN", message)
end

function M.error(message)
    log("ERROR", message)
end

return M</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/module-exports.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- Best Practices -->
                                    <h2>Module Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Best Practices:</strong>
                                        <ul>
                                            <li>Always use <code>local</code> for the module table</li>
                                            <li>Return the module table at the end</li>
                                            <li>Keep private functions local (don't add to module table)</li>
                                            <li>Use meaningful module names</li>
                                            <li>Document your module's public API</li>
                                            <li>Avoid global variables in modules</li>
                                            <li>Keep modules focused on a single responsibility</li>
                                        </ul>
                                    </div>

                                    <h3>Module Template</h3>
                                    <pre><code class="language-lua">-- module_name.lua
-- Description: What this module does
-- Author: Your name
-- Version: 1.0

local M = {}

-- Private variables
local privateVar = "private"

-- Private functions
local function privateFunction()
    -- Implementation
end

-- Public functions
function M.publicFunction()
    -- Implementation
    privateFunction()  -- Can call private functions
end

-- Constants
M.VERSION = "1.0"
M.CONSTANT = "value"

return M</code></pre>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these module challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-modules.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>What modules are and why they're important</li>
                                            <li>Using <code>require()</code> to load modules</li>
                                            <li>Different module patterns (basic, private functions, state)</li>
                                            <li>Creating class modules</li>
                                            <li>Organizing modules in directories</li>
                                            <li>Practical examples: string utils, config, logger</li>
                                            <li>Module best practices and templates</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing Module 5! You've mastered OOP and modules in Lua.
                                        Next,
                                        we'll explore <strong>advanced topics</strong> including error handling,
                                        debugging,
                                        and best practices for writing robust Lua code. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="inheritance.jsp" />
                                    <jsp:param name="prevTitle" value="Inheritance" />
                                    <jsp:param name="nextLink" value="creating-modules.jsp" />
                                    <jsp:param name="nextTitle" value="Creating Modules" />
                                    <jsp:param name="currentLessonId" value="modules" />
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