<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "inheritance" );
        request.setAttribute("currentModule", "Object-Oriented Programming" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Inheritance in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master inheritance in Lua: create class hierarchies, extend classes, override methods, call super methods, and implement polymorphism.">
            <meta name="keywords"
                content="lua inheritance, lua class hierarchy, lua polymorphism, lua super, method overriding lua">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Inheritance in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn inheritance in Lua: class hierarchies, method overriding, and polymorphism.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/inheritance.jsp">
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
        "name": "Inheritance in Lua",
        "description": "Master inheritance in Lua: class hierarchies, method overriding, and polymorphism.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/inheritance.jsp",
        "keywords": "lua inheritance, class hierarchy, polymorphism, method overriding",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Inheritance", "Class hierarchies", "Method overriding", "Super methods", "Polymorphism"],
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
                "name": "Inheritance"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="inheritance">
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
                                    <span>Inheritance</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Inheritance in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Inheritance allows you to create new classes based on existing ones,
                                        reusing and extending functionality. In Lua, inheritance is implemented using
                                        metatables and the <code>__index</code> metamethod. You can create class
                                        hierarchies,
                                        override methods, and implement polymorphism. Let's explore how to build
                                        powerful
                                        inheritance systems in Lua!</p>

                                    <!-- Basic Inheritance -->
                                    <h2>Basic Inheritance</h2>
                                    <p>Create a child class that inherits from a parent class:</p>

                                    <pre><code class="language-lua">-- Parent class
local Animal = {}
Animal.__index = Animal

function Animal:new(name)
    local self = setmetatable({}, Animal)
    self.name = name
    return self
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

-- Child class
local Dog = setmetatable({}, {__index = Animal})
Dog.__index = Dog

function Dog:new(name, breed)
    local self = setmetatable({}, Dog)
    self.name = name
    self.breed = breed
    return self
end

function Dog:speak()
    print(self.name .. " barks: Woof!")
end

local animal = Animal:new("Generic Animal")
local dog = Dog:new("Buddy", "Golden Retriever")

animal:speak()  -- Generic Animal makes a sound
dog:speak()     -- Buddy barks: Woof!</code></pre>

                                    <div class="info-box">
                                        <strong>How it works:</strong>
                                        <ol>
                                            <li><code>Dog</code> has <code>Animal</code> as its metatable</li>
                                            <li>When a method isn't found in <code>Dog</code>, Lua looks in
                                                <code>Animal</code>
                                            </li>
                                            <li>This creates an inheritance chain: Dog → Animal</li>
                                        </ol>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-inheritance.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-inheritance" />
                                    </jsp:include>

                                    <!-- Calling Parent Methods -->
                                    <h2>Calling Parent Methods (Super)</h2>
                                    <p>Access parent class methods from child class:</p>

                                    <pre><code class="language-lua">local Animal = {}
Animal.__index = Animal

function Animal:new(name)
    local self = setmetatable({}, Animal)
    self.name = name
    self.energy = 100
    return self
end

function Animal:eat()
    self.energy = self.energy + 10
    print(self.name .. " is eating")
end

-- Child class
local Dog = setmetatable({}, {__index = Animal})
Dog.__index = Dog

function Dog:new(name, breed)
    -- Call parent constructor
    local self = Animal.new(self, name)
    setmetatable(self, Dog)
    self.breed = breed
    return self
end

function Dog:eat()
    -- Call parent method
    Animal.eat(self)
    print("Energy is now: " .. self.energy)
end

local dog = Dog:new("Buddy", "Golden Retriever")
dog:eat()
-- Buddy is eating
-- Energy is now: 110</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-super.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-super" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Multiple Levels of Inheritance -->
                                    <h2>Multiple Levels of Inheritance</h2>
                                    <p>Create deep inheritance hierarchies:</p>

                                    <pre><code class="language-lua">-- Base class
local Shape = {}
Shape.__index = Shape

function Shape:new()
    local self = setmetatable({}, Shape)
    return self
end

function Shape:getArea()
    return 0
end

-- Rectangle inherits from Shape
local Rectangle = setmetatable({}, {__index = Shape})
Rectangle.__index = Rectangle

function Rectangle:new(width, height)
    local self = setmetatable({}, Rectangle)
    self.width = width
    self.height = height
    return self
end

function Rectangle:getArea()
    return self.width * self.height
end

-- Square inherits from Rectangle
local Square = setmetatable({}, {__index = Rectangle})
Square.__index = Square

function Square:new(side)
    local self = Rectangle.new(self, side, side)
    setmetatable(self, Square)
    return self
end

local square = Square:new(5)
print(square:getArea())  -- 25</code></pre>

                                    <!-- Polymorphism -->
                                    <h2>Polymorphism</h2>
                                    <p>Different objects respond to the same method call in their own way:</p>

                                    <pre><code class="language-lua">local Shape = {}
Shape.__index = Shape

function Shape:new()
    return setmetatable({}, Shape)
end

function Shape:draw()
    print("Drawing a shape")
end

-- Circle
local Circle = setmetatable({}, {__index = Shape})
Circle.__index = Circle

function Circle:new(radius)
    local self = setmetatable({}, Circle)
    self.radius = radius
    return self
end

function Circle:draw()
    print("Drawing a circle with radius " .. self.radius)
end

-- Rectangle
local Rectangle = setmetatable({}, {__index = Shape})
Rectangle.__index = Rectangle

function Rectangle:new(width, height)
    local self = setmetatable({}, Rectangle)
    self.width = width
    self.height = height
    return self
end

function Rectangle:draw()
    print("Drawing a rectangle " .. self.width .. "x" .. self.height)
end

-- Polymorphism in action
local shapes = {
    Circle:new(5),
    Rectangle:new(10, 20),
    Circle:new(3)
}

for i, shape in ipairs(shapes) do
    shape:draw()  -- Each shape draws itself differently
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-polymorphism.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-polymorphism" />
                                    </jsp:include>

                                    <!-- Helper Function for Inheritance -->
                                    <h2>Inheritance Helper Function</h2>
                                    <p>Create a reusable function to simplify inheritance:</p>

                                    <pre><code class="language-lua">local function class(base)
    local c = {}
    
    if base then
        setmetatable(c, {__index = base})
    end
    
    c.__index = c
    
    function c:new(...)
        local instance = setmetatable({}, c)
        if instance.init then
            instance:init(...)
        end
        return instance
    end
    
    return c
end

-- Usage
local Animal = class()

function Animal:init(name)
    self.name = name
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

-- Dog inherits from Animal
local Dog = class(Animal)

function Dog:init(name, breed)
    Animal.init(self, name)
    self.breed = breed
end

function Dog:speak()
    print(self.name .. " barks!")
end

local dog = Dog:new("Buddy", "Golden Retriever")
dog:speak()  -- Buddy barks!</code></pre>

                                    <!-- Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>Employee Hierarchy</h3>
                                    <pre><code class="language-lua">-- Base Employee class
local Employee = {}
Employee.__index = Employee

function Employee:new(name, salary)
    local self = setmetatable({}, Employee)
    self.name = name
    self.salary = salary
    return self
end

function Employee:getInfo()
    return self.name .. " - $" .. self.salary
end

function Employee:getBonus()
    return self.salary * 0.1  -- 10% bonus
end

-- Manager inherits from Employee
local Manager = setmetatable({}, {__index = Employee})
Manager.__index = Manager

function Manager:new(name, salary, department)
    local self = Employee.new(self, name, salary)
    setmetatable(self, Manager)
    self.department = department
    return self
end

function Manager:getBonus()
    return self.salary * 0.2  -- 20% bonus for managers
end

function Manager:getInfo()
    return Employee.getInfo(self) .. " (Manager of " .. self.department .. ")"
end

local emp = Employee:new("Alice", 50000)
local mgr = Manager:new("Bob", 80000, "Engineering")

print(emp:getInfo())  -- Alice - $50000
print(emp:getBonus())  -- 5000

print(mgr:getInfo())  -- Bob - $80000 (Manager of Engineering)
print(mgr:getBonus())  -- 16000</code></pre>

                                    <h3>Vehicle Hierarchy</h3>
                                    <pre><code class="language-lua">local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new(brand, model)
    local self = setmetatable({}, Vehicle)
    self.brand = brand
    self.model = model
    self.speed = 0
    return self
end

function Vehicle:accelerate(amount)
    self.speed = self.speed + amount
end

function Vehicle:getInfo()
    return self.brand .. " " .. self.model .. " - Speed: " .. self.speed
end

-- Car inherits from Vehicle
local Car = setmetatable({}, {__index = Vehicle})
Car.__index = Car

function Car:new(brand, model, doors)
    local self = Vehicle.new(self, brand, model)
    setmetatable(self, Car)
    self.doors = doors
    return self
end

function Car:honk()
    print("Beep beep!")
end

-- Motorcycle inherits from Vehicle
local Motorcycle = setmetatable({}, {__index = Vehicle})
Motorcycle.__index = Motorcycle

function Motorcycle:new(brand, model, hasWindshield)
    local self = Vehicle.new(self, brand, model)
    setmetatable(self, Motorcycle)
    self.hasWindshield = hasWindshield
    return self
end

function Motorcycle:wheelie()
    print("Doing a wheelie!")
end

local car = Car:new("Toyota", "Camry", 4)
local bike = Motorcycle:new("Harley", "Davidson", true)

car:accelerate(60)
car:honk()
print(car:getInfo())

bike:accelerate(80)
bike:wheelie()
print(bike:getInfo())</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/oop-hierarchy.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-hierarchy" />
                                    </jsp:include>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these inheritance challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-oop-inheritance.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Creating inheritance using metatables and <code>__index</code></li>
                                            <li>Calling parent methods (super) from child classes</li>
                                            <li>Building multiple levels of inheritance</li>
                                            <li>Implementing polymorphism for flexible code</li>
                                            <li>Creating inheritance helper functions</li>
                                            <li>Practical examples: Employee and Vehicle hierarchies</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered inheritance in Lua! Next, we'll explore
                                        <strong>modules</strong>—how
                                        to organize your code into reusable packages, manage dependencies, and create
                                        clean
                                        APIs. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-basics.jsp" />
                                    <jsp:param name="prevTitle" value="OOP Basics" />
                                    <jsp:param name="nextLink" value="modules.jsp" />
                                    <jsp:param name="nextTitle" value="Modules" />
                                    <jsp:param name="currentLessonId" value="inheritance" />
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