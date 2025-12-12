<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-basics" );
        request.setAttribute("currentModule", "Object-Oriented Programming" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>OOP Basics in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Object-Oriented Programming in Lua: classes, objects, constructors, methods, and encapsulation using tables and metatables.">
            <meta name="keywords"
                content="lua oop, lua classes, lua objects, object-oriented programming lua, lua constructors, lua methods">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="OOP Basics in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Object-Oriented Programming in Lua: create classes, objects, and methods.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/oop-basics.jsp">
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
        "name": "OOP Basics in Lua",
        "description": "Master Object-Oriented Programming in Lua: classes, objects, constructors, and methods.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/oop-basics.jsp",
        "keywords": "lua oop, lua classes, lua objects, object-oriented programming",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Classes", "Objects", "Constructors", "Methods", "Encapsulation"],
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
                "name": "OOP Basics"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="oop-basics">
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
                                    <span>OOP Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">OOP Basics in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Lua doesn't have built-in classes, but its flexible table and
                                        metatable
                                        system makes it easy to implement Object-Oriented Programming. You can create
                                        classes, objects, methods, and all the OOP patterns you need. In this lesson,
                                        you'll
                                        learn how to build robust OOP systems in Lua using tables and metatables. Let's
                                        get
                                        started!</p>

                                    <!-- Basic Class Pattern -->
                                    <h2>Creating a Class</h2>
                                    <p>A class in Lua is typically a table with methods:</p>

                                    <pre><code class="language-lua">-- Define the class
local Person = {}
Person.__index = Person

-- Constructor
function Person:new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

-- Method
function Person:greet()
    print("Hello, I'm " .. self.name)
end

-- Create instances
local alice = Person:new("Alice", 25)
local bob = Person:new("Bob", 30)

alice:greet()  -- Hello, I'm Alice
bob:greet()    -- Hello, I'm Bob</code></pre>

                                    <div class="info-box">
                                        <strong>How it works:</strong>
                                        <ol>
                                            <li><code>Person</code> is a table that serves as the class</li>
                                            <li><code>Person.__index = Person</code> makes methods available to
                                                instances</li>
                                            <li><code>new()</code> creates an instance with <code>setmetatable</code>
                                            </li>
                                            <li>The colon <code>:</code> syntax passes <code>self</code> automatically
                                            </li>
                                        </ol>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-classes.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-classes" />
                                    </jsp:include>

                                    <!-- Instance vs Class Methods -->
                                    <h2>Instance Methods vs Class Methods</h2>

                                    <h3>Instance Methods</h3>
                                    <p>Methods that operate on individual instances:</p>

                                    <pre><code class="language-lua">local Dog = {}
Dog.__index = Dog

function Dog:new(name, breed)
    local self = setmetatable({}, Dog)
    self.name = name
    self.breed = breed
    return self
end

-- Instance method (uses self)
function Dog:bark()
    print(self.name .. " says: Woof!")
end

function Dog:getInfo()
    return self.name .. " is a " .. self.breed
end

local dog = Dog:new("Buddy", "Golden Retriever")
dog:bark()  -- Buddy says: Woof!</code></pre>

                                    <h3>Class Methods (Static Methods)</h3>
                                    <p>Methods that belong to the class itself:</p>

                                    <pre><code class="language-lua">local Dog = {}
Dog.__index = Dog
Dog.count = 0  -- Class variable

function Dog:new(name, breed)
    local self = setmetatable({}, Dog)
    self.name = name
    self.breed = breed
    Dog.count = Dog.count + 1  -- Increment class variable
    return self
end

-- Class method (uses dot notation)
function Dog.getCount()
    return Dog.count
end

local dog1 = Dog:new("Buddy", "Golden Retriever")
local dog2 = Dog:new("Max", "Labrador")
print("Total dogs:", Dog.getCount())  -- Total dogs: 2</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-methods.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-methods" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Encapsulation -->
                                    <h2>Encapsulation and Private Variables</h2>
                                    <p>Use closures to create private variables:</p>

                                    <pre><code class="language-lua">local function BankAccount(initialBalance)
    -- Private variables
    local balance = initialBalance
    
    -- Public interface
    local self = {}
    
    function self:deposit(amount)
        if amount > 0 then
            balance = balance + amount
            return true
        end
        return false
    end
    
    function self:withdraw(amount)
        if amount > 0 and amount <= balance then
            balance = balance - amount
            return true
        end
        return false
    end
    
    function self:getBalance()
        return balance
    end
    
    return self
end

local account = BankAccount(1000)
account:deposit(500)
print(account:getBalance())  -- 1500
-- print(account.balance)  -- nil (private!)</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use closures for true privacy. Table fields can
                                        always be accessed, but closure variables are truly private.
                                    </div>

                                    <!-- Getters and Setters -->
                                    <h2>Getters and Setters</h2>
                                    <p>Control access to properties:</p>

                                    <pre><code class="language-lua">local Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:new(width, height)
    local self = setmetatable({}, Rectangle)
    self._width = width
    self._height = height
    return self
end

-- Getter
function Rectangle:getWidth()
    return self._width
end

-- Setter with validation
function Rectangle:setWidth(width)
    if width > 0 then
        self._width = width
    else
        error("Width must be positive")
    end
end

function Rectangle:getArea()
    return self._width * self._height
end

local rect = Rectangle:new(10, 5)
print(rect:getArea())  -- 50
rect:setWidth(20)
print(rect:getArea())  -- 100</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-encapsulation.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-encapsulation" />
                                    </jsp:include>

                                    <!-- Method Chaining -->
                                    <h2>Method Chaining</h2>
                                    <p>Return <code>self</code> to enable fluent interfaces:</p>

                                    <pre><code class="language-lua">local StringBuilder = {}
StringBuilder.__index = StringBuilder

function StringBuilder:new()
    local self = setmetatable({}, StringBuilder)
    self.parts = {}
    return self
end

function StringBuilder:append(str)
    table.insert(self.parts, str)
    return self  -- Enable chaining
end

function StringBuilder:prepend(str)
    table.insert(self.parts, 1, str)
    return self  -- Enable chaining
end

function StringBuilder:toString()
    return table.concat(self.parts)
end

-- Chaining in action
local result = StringBuilder:new()
    :append("Hello")
    :append(" ")
    :append("World")
    :prepend(">>> ")
    :toString()

print(result)  -- >>> Hello World</code></pre>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Shopping Cart</h3>
                                    <pre><code class="language-lua">local ShoppingCart = {}
ShoppingCart.__index = ShoppingCart

function ShoppingCart:new()
    local self = setmetatable({}, ShoppingCart)
    self.items = {}
    return self
end

function ShoppingCart:addItem(name, price, quantity)
    table.insert(self.items, {
        name = name,
        price = price,
        quantity = quantity or 1
    })
    return self
end

function ShoppingCart:getTotal()
    local total = 0
    for i, item in ipairs(self.items) do
        total = total + (item.price * item.quantity)
    end
    return total
end

function ShoppingCart:getItemCount()
    return #self.items
end

local cart = ShoppingCart:new()
cart:addItem("Apple", 1.50, 3)
    :addItem("Banana", 0.75, 5)
    :addItem("Orange", 2.00, 2)

print("Total:", cart:getTotal())  -- 12.25
print("Items:", cart:getItemCount())  -- 3</code></pre>

                                    <h3>Timer Class</h3>
                                    <pre><code class="language-lua">local Timer = {}
Timer.__index = Timer

function Timer:new()
    local self = setmetatable({}, Timer)
    self.startTime = nil
    self.elapsed = 0
    return self
end

function Timer:start()
    self.startTime = os.clock()
    return self
end

function Timer:stop()
    if self.startTime then
        self.elapsed = os.clock() - self.startTime
        self.startTime = nil
    end
    return self
end

function Timer:getElapsed()
    if self.startTime then
        return os.clock() - self.startTime
    end
    return self.elapsed
end

local timer = Timer:new()
timer:start()
-- Do some work...
timer:stop()
print("Elapsed:", timer:getElapsed(), "seconds")</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-practical.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-practical" />
                                    </jsp:include>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these OOP challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-oop-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Creating classes using tables and metatables</li>
                                            <li>Constructors with <code>new()</code> method</li>
                                            <li>Instance methods vs class methods</li>
                                            <li>Encapsulation with closures for private variables</li>
                                            <li>Getters and setters for controlled access</li>
                                            <li>Method chaining for fluent interfaces</li>
                                            <li>Practical examples: ShoppingCart, Timer</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've learned the basics of OOP in Lua! Next, we'll explore
                                        <strong>inheritance</strong>—how to create class hierarchies, extend
                                        functionality,
                                        and implement polymorphism. Let's continue! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="iterators.jsp" />
                                    <jsp:param name="prevTitle" value="Iterators" />
                                    <jsp:param name="nextLink" value="inheritance.jsp" />
                                    <jsp:param name="nextTitle" value="Inheritance" />
                                    <jsp:param name="currentLessonId" value="oop-basics" />
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