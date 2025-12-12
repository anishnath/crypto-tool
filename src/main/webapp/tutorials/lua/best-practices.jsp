<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "best-practices" );
        request.setAttribute("currentModule", "Modules & Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Best Practices in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua best practices: code style, naming conventions, performance tips, security, and professional Lua programming patterns.">
            <meta name="keywords"
                content="lua best practices, lua coding standards, lua performance, lua style guide, professional lua">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Best Practices in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua best practices for writing clean, efficient, and maintainable code.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/best-practices.jsp">
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
        "name": "Best Practices in Lua",
        "description": "Master Lua best practices for writing clean, efficient, and maintainable code.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/best-practices.jsp",
        "keywords": "lua best practices, coding standards, performance, style guide",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Code style", "Naming conventions", "Performance", "Security", "Professional patterns"],
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
                "name": "Best Practices"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="best-practices">
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
                                    <span>Best Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Best Practices in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Writing clean, efficient, and maintainable code is essential for
                                        professional development. In this lesson, you'll learn Lua best practices
                                        covering
                                        code style, naming conventions, performance optimization, security, and
                                        professional
                                        patterns. Let's explore how to write excellent Lua code!</p>

                                    <!-- Code Style -->
                                    <h2>Code Style and Formatting</h2>

                                    <h3>Indentation and Spacing</h3>
                                    <pre><code class="language-lua">-- Good: Consistent 4-space indentation
function calculateTotal(items)
    local total = 0
    for i, item in ipairs(items) do
        if item.price > 0 then
            total = total + item.price
        end
    end
    return total
end

-- Bad: Inconsistent indentation
function calculateTotal(items)
local total = 0
  for i, item in ipairs(items) do
      if item.price > 0 then
    total = total + item.price
      end
  end
return total
end</code></pre>

                                    <h3>Line Length</h3>
                                    <pre><code class="language-lua">-- Good: Keep lines under 80-100 characters
local function createUser(name, email, age, address, phone)
    return {
        name = name,
        email = email,
        age = age,
        address = address,
        phone = phone
    }
end

-- Bad: Very long lines
local function createUser(name, email, age, address, phone) return {name = name, email = email, age = age, address = address, phone = phone} end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/best-practices-style.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-style" />
                                    </jsp:include>

                                    <!-- Naming Conventions -->
                                    <h2>Naming Conventions</h2>

                                    <h3>Variables and Functions</h3>
                                    <pre><code class="language-lua">-- Good: Descriptive, lowercase with underscores
local user_count = 0
local is_active = true
local max_retry_attempts = 3

function calculate_total_price(items)
    -- Implementation
end

-- Bad: Unclear, inconsistent
local uc = 0
local IsActive = true
local MAXRETRY = 3

function calcTP(i)
    -- Implementation
end</code></pre>

                                    <h3>Constants</h3>
                                    <pre><code class="language-lua">-- Good: UPPERCASE with underscores
local MAX_CONNECTIONS = 100
local DEFAULT_TIMEOUT = 30
local API_VERSION = "1.0"

-- Bad: Lowercase like variables
local maxConnections = 100
local defaulttimeout = 30</code></pre>

                                    <h3>Classes and Modules</h3>
                                    <pre><code class="language-lua">-- Good: PascalCase for classes
local UserManager = {}
local DatabaseConnection = {}
local HttpClient = {}

-- Good: lowercase for modules
local string_utils = require("string_utils")
local math_helpers = require("math_helpers")</code></pre>

                                    <!-- Use Local Variables -->
                                    <h2>Always Use Local Variables</h2>

                                    <pre><code class="language-lua">-- Good: Local variables
local function processData(data)
    local result = {}
    local count = 0
    
    for i, item in ipairs(data) do
        count = count + 1
        table.insert(result, item)
    end
    
    return result, count
end

-- Bad: Global variables (pollutes global namespace)
function processData(data)
    result = {}  -- Global!
    count = 0    -- Global!
    
    for i, item in ipairs(data) do
        count = count + 1
        table.insert(result, item)
    end
    
    return result, count
end</code></pre>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> Global variables can cause hard-to-find bugs and
                                        naming
                                        conflicts. Always use <code>local</code> unless you specifically need a global.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Performance Best Practices -->
                                    <h2>Performance Best Practices</h2>

                                    <h3>Cache Table Lookups</h3>
                                    <pre><code class="language-lua">-- Good: Cache frequently accessed values
local function processItems(items)
    local insert = table.insert  -- Cache table.insert
    local result = {}
    
    for i = 1, #items do
        insert(result, items[i] * 2)
    end
    
    return result
end

-- Less efficient: Repeated table lookups
local function processItems(items)
    local result = {}
    
    for i = 1, #items do
        table.insert(result, items[i] * 2)  -- Looks up table.insert every time
    end
    
    return result
end</code></pre>

                                    <h3>Use table.concat() for String Building</h3>
                                    <pre><code class="language-lua">-- Good: Use table.concat()
local function buildString(parts)
    return table.concat(parts, ", ")
end

-- Bad: String concatenation in loop
local function buildString(parts)
    local result = ""
    for i, part in ipairs(parts) do
        result = result .. part .. ", "  -- Creates new string each iteration
    end
    return result
end</code></pre>

                                    <h3>Reuse Tables</h3>
                                    <pre><code class="language-lua">-- Good: Reuse table
local temp = {}
for i = 1, 1000 do
    -- Clear and reuse
    for k in pairs(temp) do
        temp[k] = nil
    end
    -- Use temp
end

-- Less efficient: Create new table each iteration
for i = 1, 1000 do
    local temp = {}  -- New allocation each time
    -- Use temp
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/best-practices-performance.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-performance" />
                                    </jsp:include>

                                    <!-- Error Handling -->
                                    <h2>Error Handling Best Practices</h2>

                                    <h3>Validate Input Early</h3>
                                    <pre><code class="language-lua">-- Good: Validate at function entry
local function divide(a, b)
    assert(type(a) == "number", "First argument must be a number")
    assert(type(b) == "number", "Second argument must be a number")
    assert(b ~= 0, "Cannot divide by zero")
    
    return a / b
end

-- Bad: No validation
local function divide(a, b)
    return a / b  -- May cause runtime errors
end</code></pre>

                                    <h3>Return nil, error for Expected Failures</h3>
                                    <pre><code class="language-lua">-- Good: Return nil, error
local function readConfig(filename)
    local file, err = io.open(filename, "r")
    if not file then
        return nil, "Failed to open config: " .. err
    end
    
    local content = file:read("*all")
    file:close()
    
    return content
end

-- Usage
local config, err = readConfig("config.txt")
if not config then
    print("Error:", err)
    return
end</code></pre>

                                    <!-- Code Organization -->
                                    <h2>Code Organization</h2>

                                    <h3>Keep Functions Small</h3>
                                    <pre><code class="language-lua">-- Good: Small, focused functions
local function validateEmail(email)
    return email:match("^[%w.]+@[%w.]+%.%w+$") ~= nil
end

local function validateAge(age)
    return type(age) == "number" and age >= 0 and age <= 150
end

local function createUser(name, email, age)
    if not validateEmail(email) then
        return nil, "Invalid email"
    end
    if not validateAge(age) then
        return nil, "Invalid age"
    end
    
    return {name = name, email = email, age = age}
end

-- Bad: One large function
local function createUser(name, email, age)
    if not email:match("^[%w.]+@[%w.]+%.%w+$") then
        return nil, "Invalid email"
    end
    if type(age) ~= "number" or age < 0 or age > 150 then
        return nil, "Invalid age"
    end
    -- More validation...
    -- More logic...
    -- Gets hard to read and maintain
end</code></pre>

                                    <h3>Single Responsibility Principle</h3>
                                    <pre><code class="language-lua">-- Good: Each function has one responsibility
local function loadData(filename)
    -- Only loads data
    local file = io.open(filename, "r")
    local content = file:read("*all")
    file:close()
    return content
end

local function parseData(content)
    -- Only parses data
    local data = {}
    for line in content:gmatch("[^\n]+") do
        table.insert(data, line)
    end
    return data
end

local function processData(data)
    -- Only processes data
    local result = {}
    for i, item in ipairs(data) do
        table.insert(result, item:upper())
    end
    return result
end

-- Bad: One function does everything
local function loadAndProcessData(filename)
    -- Loads, parses, and processes - too many responsibilities
end</code></pre>

                                    <!-- Documentation -->
                                    <h2>Documentation</h2>

                                    <pre><code class="language-lua">--[[
    Calculates the total price of items in a shopping cart
    
    @param items table Array of item objects with 'price' and 'quantity' fields
    @param discount number Optional discount percentage (0-100)
    @return number Total price after discount
    @return number Amount saved from discount
]]
local function calculateTotal(items, discount)
    discount = discount or 0
    
    local subtotal = 0
    for i, item in ipairs(items) do
        subtotal = subtotal + (item.price * item.quantity)
    end
    
    local discountAmount = subtotal * (discount / 100)
    local total = subtotal - discountAmount
    
    return total, discountAmount
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/best-practices-code.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-organization" />
                                    </jsp:include>

                                    <!-- Security Best Practices -->
                                    <h2>Security Best Practices</h2>

                                    <div class="warning-box">
                                        <strong>Security Tips:</strong>
                                        <ul>
                                            <li><strong>Validate all input:</strong> Never trust user input</li>
                                            <li><strong>Avoid load() and loadstring():</strong> Can execute arbitrary
                                                code
                                            </li>
                                            <li><strong>Sanitize file paths:</strong> Prevent directory traversal</li>
                                            <li><strong>Use pcall() for untrusted code:</strong> Contain errors</li>
                                            <li><strong>Don't expose debug library:</strong> In production</li>
                                        </ul>
                                    </div>

                                    <!-- Summary Checklist -->
                                    <h2>Best Practices Checklist</h2>

                                    <div class="best-practice-box">
                                        <strong>✓ Code Style:</strong>
                                        <ul>
                                            <li>Consistent indentation (4 spaces)</li>
                                            <li>Lines under 80-100 characters</li>
                                            <li>Meaningful variable names</li>
                                            <li>Proper spacing around operators</li>
                                        </ul>

                                        <strong>✓ Variables:</strong>
                                        <ul>
                                            <li>Always use <code>local</code></li>
                                            <li>Descriptive names</li>
                                            <li>UPPERCASE for constants</li>
                                        </ul>

                                        <strong>✓ Functions:</strong>
                                        <ul>
                                            <li>Keep functions small and focused</li>
                                            <li>Validate input early</li>
                                            <li>Return nil, error for failures</li>
                                            <li>Document complex functions</li>
                                        </ul>

                                        <strong>✓ Performance:</strong>
                                        <ul>
                                            <li>Cache table lookups</li>
                                            <li>Use table.concat() for strings</li>
                                            <li>Reuse tables when possible</li>
                                            <li>Profile before optimizing</li>
                                        </ul>

                                        <strong>✓ Organization:</strong>
                                        <ul>
                                            <li>One module, one responsibility</li>
                                            <li>Group related functions</li>
                                            <li>Use meaningful file names</li>
                                            <li>Keep modules focused</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Review and improve this code:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-best-practices.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Code style and formatting guidelines</li>
                                            <li>Naming conventions for variables, functions, and modules</li>
                                            <li>Always using local variables</li>
                                            <li>Performance optimization techniques</li>
                                            <li>Error handling best practices</li>
                                            <li>Code organization principles</li>
                                            <li>Documentation standards</li>
                                            <li>Security considerations</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing Module 6! You now know how to write professional,
                                        maintainable Lua code. In the final module, we'll explore <strong>advanced
                                            topics</strong> including coroutines, file I/O, and performance
                                        optimization.
                                        Let's finish strong! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="debugging.jsp" />
                                    <jsp:param name="prevTitle" value="Debugging" />
                                    <jsp:param name="nextLink" value="coroutines.jsp" />
                                    <jsp:param name="nextTitle" value="Coroutines" />
                                    <jsp:param name="currentLessonId" value="best-practices" />
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