<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-methods");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Methods - Instance, Class, Static Methods, Method Chaining | 8gwifi.org</title>
    <meta name="description"
        content="Master Python methods: instance methods with self, class methods with @classmethod, static methods with @staticmethod, and method chaining patterns.">
    <meta name="keywords"
        content="python methods, python instance method, python class method, python static method, python @classmethod, python @staticmethod, python self, method chaining">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Methods - Instance, Class, Static Methods, Method Chaining">
    <meta property="og:description" content="Master Python methods: instance methods, @classmethod, @staticmethod, and fluent method chaining patterns.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-methods.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
        "name": "Python Methods",
        "description": "Master Python methods: instance methods with self, class methods with @classmethod, static methods with @staticmethod, and method chaining.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Instance methods", "self parameter", "Class methods", "@classmethod decorator", "Static methods", "@staticmethod decorator", "Alternative constructors", "Method chaining"],
        "timeRequired": "PT30M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="oop-methods">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Methods</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Methods</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Methods are functions defined inside a class that operate on objects. Python
                    has three types: <strong>instance methods</strong> (most common, use <code>self</code>),
                    <strong>class methods</strong> (use <code>@classmethod</code> and <code>cls</code>), and
                    <strong>static methods</strong> (use <code>@staticmethod</code>, no special first parameter).
                    Each serves a different purpose!</p>

                    <!-- Section 1: Instance Methods -->
                    <h2>Instance Methods</h2>
                    <p>Instance methods are the most common type. They take <code>self</code> as the first parameter,
                    which refers to the instance calling the method. This lets them access and modify instance
                    attributes. When you call <code>obj.method()</code>, Python automatically passes <code>obj</code>
                    as <code>self</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/method-instance.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-instance" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Instance Methods:</strong><br>
                        <code>def method(self):</code> - First parameter is always self<br>
                        <code>obj.method()</code> - Python passes obj as self automatically<br>
                        <code>self.attr</code> - Access instance attributes<br>
                        <code>self.other_method()</code> - Call other instance methods<br><br>
                        <strong>Use for:</strong> Operations that need instance data or modify instance state.
                    </div>

                    <!-- Section 2: Class Methods -->
                    <h2>Class Methods</h2>
                    <p>Class methods use the <code>@classmethod</code> decorator and receive the class (not instance)
                    as the first parameter, conventionally called <code>cls</code>. They're perfect for alternative
                    constructors (factory methods) and operations on class-level data. They work with inheritance too!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/method-classmethod.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-classmethod" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Class Methods - When to Use:</strong><br>
                        <code>@classmethod</code> + <code>cls</code> parameter<br><br>
                        - Alternative constructors: <code>from_string()</code>, <code>from_dict()</code><br>
                        - Factory methods that create instances<br>
                        - Access/modify class attributes<br>
                        - Methods that should work with inheritance (cls is actual class)<br>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Static Methods -->
                    <h2>Static Methods</h2>
                    <p>Static methods use the <code>@staticmethod</code> decorator and don't receive <code>self</code>
                    or <code>cls</code>. They're essentially regular functions that live in a class's namespace.
                    Use them for utility functions that are logically related to the class but don't need instance
                    or class data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/method-staticmethod.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-staticmethod" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Static Methods - When to Use:</strong><br>
                        <code>@staticmethod</code> - No self or cls parameter<br><br>
                        - Utility functions related to the class<br>
                        - Validation helpers<br>
                        - Conversion functions<br>
                        - When you don't need instance or class data<br>
                        - Namespace organization (group related functions)
                    </div>

                    <!-- Section 4: Method Chaining -->
                    <h2>Method Chaining</h2>
                    <p>Method chaining (fluent interface) lets you call multiple methods in sequence:
                    <code>obj.method1().method2().method3()</code>. The trick is returning <code>self</code>
                    from each method. This pattern creates readable, expressive code for builders and queries.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/method-chaining.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-chaining" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Method Chaining Tips:</strong><br>
                        - Return <code>self</code> from methods you want to chain<br>
                        - Final method often returns a result (not self): <code>.build()</code>, <code>.execute()</code><br>
                        - Use parentheses for multi-line chains for readability<br>
                        - Don't overuse - sometimes explicit steps are clearer
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting self in instance methods</h4>
                        <pre><code class="language-python"># Wrong - missing self parameter!
class Dog:
    def bark():  # Missing self!
        print("Woof!")

dog = Dog()
dog.bark()  # TypeError: bark() takes 0 arguments but 1 was given

# Correct - include self
class Dog:
    def bark(self):
        print("Woof!")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using self in static method</h4>
                        <pre><code class="language-python"># Wrong - static methods don't have self!
class Calculator:
    @staticmethod
    def add(self, a, b):  # self doesn't belong here!
        return a + b

# Correct - no self in static method
class Calculator:
    @staticmethod
    def add(a, b):
        return a + b</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Using cls with instance method</h4>
                        <pre><code class="language-python"># Wrong - instance methods use self, not cls
class Person:
    def greet(cls):  # Should be self!
        print(f"Hello, {cls.name}")  # Confusing!

# Correct - use self for instance methods
class Person:
    def greet(self):
        print(f"Hello, {self.name}")

# Use cls only with @classmethod
class Person:
    @classmethod
    def create(cls, name):  # cls is correct here
        return cls(name)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting return self for chaining</h4>
                        <pre><code class="language-python"># Wrong - can't chain without return self
class Builder:
    def set_name(self, name):
        self.name = name
        # Missing return self!

    def set_age(self, age):
        self.age = age

b = Builder()
b.set_name("Alice").set_age(30)  # AttributeError: 'NoneType'

# Correct - return self for chaining
class Builder:
    def set_name(self, name):
        self.name = name
        return self

    def set_age(self, age):
        self.age = age
        return self</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Wrong method type for the job</h4>
                        <pre><code class="language-python"># Wrong - using static when you need class
class Counter:
    count = 0

    @staticmethod
    def increment():
        Counter.count += 1  # Hardcoded class name!

# Better - use classmethod for class operations
class Counter:
    count = 0

    @classmethod
    def increment(cls):
        cls.count += 1  # Works with inheritance!

# Wrong - using instance method for utility
class Math:
    def add(self, a, b):  # self is never used!
        return a + b

# Better - use staticmethod for utilities
class Math:
    @staticmethod
    def add(a, b):
        return a + b</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Shopping Cart</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a ShoppingCart class with different method types.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Instance method: <code>add_item(name, price)</code> - adds item and returns self for chaining</li>
                            <li>Instance method: <code>total()</code> - returns total price</li>
                            <li>Class method: <code>from_list(items)</code> - creates cart from list of (name, price) tuples</li>
                            <li>Static method: <code>format_price(amount)</code> - formats number as "$X.XX"</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-methods.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-methods" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class ShoppingCart:
    """Shopping cart with different method types."""

    def __init__(self):
        self.items = []

    def add_item(self, name, price):
        """Instance method - add item and return self for chaining."""
        self.items.append({'name': name, 'price': price})
        return self

    def total(self):
        """Instance method - calculate total price."""
        return sum(item['price'] for item in self.items)

    def display(self):
        """Instance method - show cart contents."""
        print("Shopping Cart:")
        for item in self.items:
            print(f"  - {item['name']}: {self.format_price(item['price'])}")
        print(f"  Total: {self.format_price(self.total())}")

    @classmethod
    def from_list(cls, items):
        """Class method - create cart from list of (name, price) tuples."""
        cart = cls()
        for name, price in items:
            cart.add_item(name, price)
        return cart

    @staticmethod
    def format_price(amount):
        """Static method - format price as currency."""
        return f"\${amount:.2f}"


# Test instance methods with chaining
cart1 = ShoppingCart()
cart1.add_item("Apple", 1.50).add_item("Banana", 0.75).add_item("Orange", 2.00)
cart1.display()

print()

# Test class method (alternative constructor)
items_list = [("Milk", 3.50), ("Bread", 2.25), ("Eggs", 4.00)]
cart2 = ShoppingCart.from_list(items_list)
cart2.display()

print()

# Test static method
print(f"Formatted price: {ShoppingCart.format_price(99.999)}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Instance methods:</strong> <code>def method(self)</code> - access instance data</li>
                            <li><strong>Class methods:</strong> <code>@classmethod</code> + <code>cls</code> - access class, alternative constructors</li>
                            <li><strong>Static methods:</strong> <code>@staticmethod</code> - no self/cls, utility functions</li>
                            <li><strong>self:</strong> Passed automatically when calling <code>obj.method()</code></li>
                            <li><strong>cls:</strong> Receives the class itself, works with inheritance</li>
                            <li><strong>Method chaining:</strong> Return <code>self</code> to enable <code>.method1().method2()</code></li>
                            <li><strong>Choose wisely:</strong> Instance for data, class for factories, static for utilities</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now you know how to create classes with attributes and methods. Next, we'll learn about
                    <strong>inheritance</strong> - how to create new classes based on existing ones. You'll
                    learn to extend functionality, override methods, and build class hierarchies!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-classes.jsp" />
                    <jsp:param name="prevTitle" value="Classes & Objects" />
                    <jsp:param name="nextLink" value="oop-inheritance.jsp" />
                    <jsp:param name="nextTitle" value="Inheritance" />
                    <jsp:param name="currentLessonId" value="oop-methods" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
