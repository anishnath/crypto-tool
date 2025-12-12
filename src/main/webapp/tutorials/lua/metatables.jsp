<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "metatables" ); request.setAttribute("currentModule", "Tables & Metatables"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Metatables in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua metatables: metamethods, operator overloading, __index, __newindex, __call, and advanced metaprogramming techniques.">
            <meta name="keywords"
                content="lua metatables, metamethods, operator overloading, __index, __newindex, lua metaprogramming">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Metatables in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua metatables for operator overloading and advanced table customization.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/metatables.jsp">
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
        "name": "Metatables in Lua",
        "description": "Master Lua metatables: metamethods, operator overloading, and metaprogramming techniques.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/metatables.jsp",
        "keywords": "lua metatables, metamethods, operator overloading, __index, __newindex",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Metatables", "Metamethods", "Operator overloading", "__index", "__newindex", "__call"],
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
                "name": "Metatables"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="metatables">
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
                                    <span>Metatables</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Metatables in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Metatables are one of Lua's most powerful features, allowing you to
                                        change
                                        the behavior of tables. With metatables, you can overload operators, customize
                                        table
                                        access, create object-oriented systems, and implement advanced metaprogramming
                                        patterns. Understanding metatables is key to mastering Lua. Let's explore this
                                        powerful feature!</p>

                                    <!-- What are Metatables? -->
                                    <h2>What are Metatables?</h2>
                                    <p>A metatable is a table that defines how another table behaves in certain
                                        situations:
                                    </p>

                                    <pre><code class="language-lua">local t = {}  -- Regular table
local mt = {}  -- Metatable

setmetatable(t, mt)  -- Attach metatable to t

-- Check metatable
local meta = getmetatable(t)
print(meta == mt)  -- true</code></pre>

                                    <div class="info-box">
                                        <strong>Key Functions:</strong>
                                        <ul>
                                            <li><code>setmetatable(table, metatable)</code> - Set a table's metatable
                                            </li>
                                            <li><code>getmetatable(table)</code> - Get a table's metatable</li>
                                        </ul>
                                    </div>

                                    <!-- __index Metamethod -->
                                    <h2>The __index Metamethod</h2>
                                    <p>Called when accessing a non-existent key:</p>

                                    <pre><code class="language-lua">local defaults = {
    name = "Guest",
    age = 0
}

local person = {}

setmetatable(person, {
    __index = defaults
})

print(person.name)  -- "Guest" (from defaults)
print(person.age)   -- 0 (from defaults)

person.name = "Alice"
print(person.name)  -- "Alice" (from person)</code></pre>

                                    <h3>__index as a Function</h3>
                                    <pre><code class="language-lua">local t = {}

setmetatable(t, {
    __index = function(table, key)
        return "Key '" .. key .. "' not found"
    end
})

print(t.anything)  -- "Key 'anything' not found"</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/metatables-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-index" />
                                    </jsp:include>

                                    <!-- __newindex Metamethod -->
                                    <h2>The __newindex Metamethod</h2>
                                    <p>Called when setting a new key:</p>

                                    <pre><code class="language-lua">local t = {}
local storage = {}

setmetatable(t, {
    __newindex = function(table, key, value)
        print("Setting " .. key .. " = " .. tostring(value))
        storage[key] = value
    end,
    
    __index = storage
})

t.name = "Alice"  -- Prints: Setting name = Alice
print(t.name)     -- Alice (from storage)</code></pre>

                                    <h3>Read-Only Tables</h3>
                                    <pre><code class="language-lua">local function readOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(table, key, value)
            error("Attempt to modify read-only table")
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

local config = readOnly({debug = true, timeout = 30})
print(config.debug)  -- true
-- config.debug = false  -- Error!</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/metatables-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-newindex" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Arithmetic Metamethods -->
                                    <h2>Arithmetic Metamethods</h2>
                                    <p>Overload arithmetic operators:</p>

                                    <pre><code class="language-lua">local Vector = {}

function Vector:new(x, y)
    local v = {x = x, y = y}
    setmetatable(v, {__index = self})
    return v
end

-- Addition
function Vector.__add(a, b)
    return Vector:new(a.x + b.x, a.y + b.y)
end

-- Subtraction
function Vector.__sub(a, b)
    return Vector:new(a.x - b.x, a.y - b.y)
end

-- Multiplication (scalar)
function Vector.__mul(a, scalar)
    return Vector:new(a.x * scalar, a.y * scalar)
end

local v1 = Vector:new(1, 2)
local v2 = Vector:new(3, 4)
local v3 = v1 + v2  -- {x = 4, y = 6}</code></pre>

                                    <h3>Available Arithmetic Metamethods</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Metamethod</th>
                                                <th>Operator</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>__add</code></td>
                                                <td><code>+</code></td>
                                                <td>Addition</td>
                                            </tr>
                                            <tr>
                                                <td><code>__sub</code></td>
                                                <td><code>-</code></td>
                                                <td>Subtraction</td>
                                            </tr>
                                            <tr>
                                                <td><code>__mul</code></td>
                                                <td><code>*</code></td>
                                                <td>Multiplication</td>
                                            </tr>
                                            <tr>
                                                <td><code>__div</code></td>
                                                <td><code>/</code></td>
                                                <td>Division</td>
                                            </tr>
                                            <tr>
                                                <td><code>__mod</code></td>
                                                <td><code>%</code></td>
                                                <td>Modulo</td>
                                            </tr>
                                            <tr>
                                                <td><code>__pow</code></td>
                                                <td><code>^</code></td>
                                                <td>Exponentiation</td>
                                            </tr>
                                            <tr>
                                                <td><code>__unm</code></td>
                                                <td><code>-</code></td>
                                                <td>Unary negation</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/metatables-operators.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-arithmetic" />
                                    </jsp:include>

                                    <!-- Comparison Metamethods -->
                                    <h2>Comparison Metamethods</h2>
                                    <p>Overload comparison operators:</p>

                                    <pre><code class="language-lua">local Set = {}

function Set:new(items)
    local s = {items = items or {}}
    setmetatable(s, {
        __index = self,
        __eq = function(a, b)
            -- Check if sets are equal
            for k in pairs(a.items) do
                if not b.items[k] then return false end
            end
            for k in pairs(b.items) do
                if not a.items[k] then return false end
            end
            return true
        end,
        __lt = function(a, b)
            -- Check if a is subset of b
            for k in pairs(a.items) do
                if not b.items[k] then return false end
            end
            return true
        end
    })
    return s
end

local s1 = Set:new({a = true, b = true})
local s2 = Set:new({a = true, b = true, c = true})

print(s1 < s2)   -- true (s1 is subset of s2)
print(s1 == s2)  -- false</code></pre>

                                    <!-- __tostring Metamethod -->
                                    <h2>The __tostring Metamethod</h2>
                                    <p>Customize string representation:</p>

                                    <pre><code class="language-lua">local Person = {}

function Person:new(name, age)
    local p = {name = name, age = age}
    setmetatable(p, {
        __index = self,
        __tostring = function(self)
            return self.name .. " (" .. self.age .. " years old)"
        end
    })
    return p
end

local person = Person:new("Alice", 25)
print(person)  -- Alice (25 years old)</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/metatables-operators.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-tostring" />
                                    </jsp:include>

                                    <!-- __call Metamethod -->
                                    <h2>The __call Metamethod</h2>
                                    <p>Make tables callable like functions:</p>

                                    <pre><code class="language-lua">local Counter = {}

function Counter:new(start)
    local c = {count = start or 0}
    setmetatable(c, {
        __index = self,
        __call = function(self)
            self.count = self.count + 1
            return self.count
        end
    })
    return c
end

local counter = Counter:new(0)
print(counter())  -- 1
print(counter())  -- 2
print(counter())  -- 3</code></pre>

                                    <!-- __len Metamethod -->
                                    <h2>The __len Metamethod</h2>
                                    <p>Customize the <code>#</code> operator:</p>

                                    <pre><code class="language-lua">local CustomArray = {}

function CustomArray:new()
    local arr = {items = {}, count = 0}
    setmetatable(arr, {
        __index = self,
        __len = function(self)
            return self.count
        end
    })
    return arr
end

function CustomArray:add(value)
    self.count = self.count + 1
    self.items[self.count] = value
end

local arr = CustomArray:new()
arr:add("a")
arr:add("b")
print(#arr)  -- 2</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/metatables-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-call" />
                                    </jsp:include>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Class System</h3>
                                    <pre><code class="language-lua">local Class = {}

function Class:new()
    local class = {}
    class.__index = class
    
    function class:create(...)
        local instance = setmetatable({}, self)
        if instance.init then
            instance:init(...)
        end
        return instance
    end
    
    return class
end

-- Usage
local Animal = Class:new()

function Animal:init(name)
    self.name = name
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

local dog = Animal:create("Buddy")
dog:speak()  -- Buddy makes a sound</code></pre>

                                    <h3>Property Tracking</h3>
                                    <pre><code class="language-lua">local function tracked(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(table, key, value)
            print("Changed: " .. key .. " = " .. tostring(value))
            t[key] = value
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

local person = tracked({name = "Alice"})
person.age = 25  -- Prints: Changed: age = 25</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/metatables-oop.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- All Metamethods -->
                                    <h2>Complete Metamethod Reference</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Metamethod</th>
                                                <th>Purpose</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>__index</code></td>
                                                <td>Table access (read)</td>
                                            </tr>
                                            <tr>
                                                <td><code>__newindex</code></td>
                                                <td>Table access (write)</td>
                                            </tr>
                                            <tr>
                                                <td><code>__call</code></td>
                                                <td>Call table as function</td>
                                            </tr>
                                            <tr>
                                                <td><code>__tostring</code></td>
                                                <td>String conversion</td>
                                            </tr>
                                            <tr>
                                                <td><code>__len</code></td>
                                                <td>Length operator #</td>
                                            </tr>
                                            <tr>
                                                <td><code>__add, __sub, __mul, __div</code></td>
                                                <td>Arithmetic operators</td>
                                            </tr>
                                            <tr>
                                                <td><code>__eq, __lt, __le</code></td>
                                                <td>Comparison operators</td>
                                            </tr>
                                            <tr>
                                                <td><code>__concat</code></td>
                                                <td>Concatenation ..</td>
                                            </tr>
                                            <tr>
                                                <td><code>__pairs, __ipairs</code></td>
                                                <td>Custom iteration</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these metatable challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-table-library.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>What metatables are and how to use them</li>
                                            <li><code>__index</code> for customizing table access</li>
                                            <li><code>__newindex</code> for controlling table modification</li>
                                            <li>Arithmetic metamethods for operator overloading</li>
                                            <li>Comparison metamethods for custom comparisons</li>
                                            <li><code>__tostring</code> for string representation</li>
                                            <li><code>__call</code> to make tables callable</li>
                                            <li>Practical applications: classes, read-only tables, property tracking
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered metatables! Next, we'll explore <strong>iterators</strong>—how to
                                        create custom iteration patterns for your tables. You'll learn about stateless
                                        and
                                        stateful iterators, and how to build powerful iteration abstractions. Let's
                                        continue!
                                        🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="table-library.jsp" />
                                    <jsp:param name="prevTitle" value="Table Library" />
                                    <jsp:param name="nextLink" value="iterators.jsp" />
                                    <jsp:param name="nextTitle" value="Iterators" />
                                    <jsp:param name="currentLessonId" value="metatables" />
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