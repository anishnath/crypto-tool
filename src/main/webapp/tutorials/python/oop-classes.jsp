<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-classes");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Classes & Objects - __init__, self, Attributes, OOP Basics | 8gwifi.org</title>
    <meta name="description"
        content="Master Python classes and objects. Learn the class keyword, __init__ constructor, self parameter, instance vs class attributes, and object-oriented programming fundamentals.">
    <meta name="keywords"
        content="python class, python object, python oop, python __init__, python self, python constructor, python attributes, python instance">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Classes & Objects - __init__, self, Attributes, OOP Basics">
    <meta property="og:description" content="Master Python OOP: classes, objects, __init__ constructor, self parameter, and instance vs class attributes.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-classes.jsp">
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
        "name": "Python Classes & Objects",
        "description": "Master Python classes and objects. Learn the class keyword, __init__ constructor, self parameter, and instance vs class attributes.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Class definition", "Creating objects", "__init__ constructor", "self parameter", "Instance attributes", "Class attributes", "Object identity", "Dynamic attributes"],
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

<body class="tutorial-body no-preview" data-lesson="oop-classes">
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
                    <span>Classes & Objects</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Classes & Objects</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Object-Oriented Programming (OOP) lets you model real-world things as objects
                    with attributes (data) and methods (behavior). A class is a blueprint, and objects are
                    instances created from that blueprint. Almost everything in Python is an object - strings,
                    lists, functions - and now you'll learn to create your own!</p>

                    <!-- Section 1: Class Basics -->
                    <h2>Class Basics</h2>
                    <p>Define a class with the <code>class</code> keyword. Classes are blueprints for creating
                    objects. When you create an object from a class, you get an <strong>instance</strong> with
                    its own data. Each instance is independent - changing one doesn't affect others.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/class-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Concepts:</strong><br>
                        <code>class ClassName:</code> - Define a class (PascalCase naming)<br>
                        <code>obj = ClassName()</code> - Create an instance (object)<br>
                        <code>type(obj)</code> - Check object's type<br>
                        <code>isinstance(obj, Class)</code> - Check if object is instance of class<br><br>
                        <strong>Remember:</strong> A class is a blueprint; objects are instances built from it.
                    </div>

                    <!-- Section 2: The __init__ Method -->
                    <h2>The __init__ Method</h2>
                    <p>The <code>__init__</code> method (constructor) initializes new objects. It runs automatically
                    when you create an instance. The first parameter is always <code>self</code>, which refers to
                    the instance being created. Use it to set up instance attributes with initial values.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/class-init.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-init" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>About self:</strong><br>
                        - <code>self</code> is the instance being created or operated on<br>
                        - It's passed automatically - you don't provide it when calling<br>
                        - Use <code>self.attribute = value</code> to set instance attributes<br>
                        - <code>__init__</code> doesn't return anything (always returns None)<br><br>
                        Note: <code>self</code> is just a convention - you could use any name, but don't!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Instance vs Class Attributes -->
                    <h2>Instance vs Class Attributes</h2>
                    <p><strong>Instance attributes</strong> are unique to each object - set them in <code>__init__</code>
                    using <code>self.attr = value</code>. <strong>Class attributes</strong> are shared by all instances -
                    define them directly in the class body. Be careful: assigning to an instance can shadow class attributes!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/class-attributes.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-attributes" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Mutable Class Attribute Trap!</strong><br>
                        Never use mutable defaults (lists, dicts) as class attributes! They're shared by all instances.<br><br>
                        <code>class Bad: items = []</code> - All instances share the same list!<br>
                        <code>class Good: def __init__(self): self.items = []</code> - Each gets its own list.
                    </div>

                    <!-- Section 4: Working with Objects -->
                    <h2>Working with Objects</h2>
                    <p>Objects are reference types - variables hold references to objects, not the objects themselves.
                    This means passing objects to functions passes the reference, allowing modification of the original.
                    Use <code>is</code> to check identity (same object) and <code>==</code> for equality (same value).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/class-objects.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-objects" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Object Operations:</strong><br>
                        <code>obj.attr</code> - Access attribute<br>
                        <code>obj.attr = value</code> - Set attribute<br>
                        <code>hasattr(obj, 'attr')</code> - Check if attribute exists<br>
                        <code>getattr(obj, 'attr', default)</code> - Get attribute with default<br>
                        <code>obj.__dict__</code> - Dictionary of instance attributes<br>
                        <code>id(obj)</code> - Unique object identifier (memory address)
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting self in __init__</h4>
                        <pre><code class="language-python"># Wrong - name becomes local variable, not attribute!
class Person:
    def __init__(self, name):
        name = name  # Useless! Doesn't save to instance

# Correct - use self to save to instance
class Person:
    def __init__(self, name):
        self.name = name  # Now it's an instance attribute</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Mutable default in class body</h4>
                        <pre><code class="language-python"># Wrong - all instances share the same list!
class Team:
    members = []  # Class attribute - shared!

t1 = Team()
t2 = Team()
t1.members.append("Alice")
print(t2.members)  # ['Alice'] - OOPS!

# Correct - create list in __init__
class Team:
    def __init__(self):
        self.members = []  # Instance attribute - unique</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing class name with variable</h4>
                        <pre><code class="language-python"># Wrong - calling class like function without saving result
class User:
    def __init__(self, name):
        self.name = name

User("Alice")  # Creates object but throws it away!

# Correct - save the instance to a variable
user = User("Alice")
print(user.name)  # Now we can use it</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Shadowing class attributes</h4>
                        <pre><code class="language-python">class Counter:
    count = 0  # Class attribute

c1 = Counter()
c2 = Counter()

# Wrong - this creates an INSTANCE attribute on c1!
c1.count = 5
print(Counter.count)  # Still 0!
print(c2.count)       # Still 0!

# Correct - modify class attribute through class name
Counter.count = 5
print(c1.count)  # 5 (reads class attr)
print(c2.count)  # 5</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Returning from __init__</h4>
                        <pre><code class="language-python"># Wrong - __init__ should not return anything!
class Builder:
    def __init__(self, name):
        self.name = name
        return self  # Error or ignored!

# Correct - just set attributes, no return
class Builder:
    def __init__(self, name):
        self.name = name
        # Implicitly returns None</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Bank Account Class</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a BankAccount class with proper initialization.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Initialize with owner name and optional starting balance (default 0)</li>
                            <li>Add a class attribute to track total accounts created</li>
                            <li>Validate that balance is not negative in __init__</li>
                            <li>Create a method to display account info</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-classes.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-classes" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class BankAccount:
    """A simple bank account class."""
    # Class attribute - tracks all accounts
    total_accounts = 0

    def __init__(self, owner, balance=0):
        """Initialize account with owner and optional balance."""
        if not owner:
            raise ValueError("Owner name is required")
        if balance < 0:
            raise ValueError("Initial balance cannot be negative")

        self.owner = owner
        self.balance = balance
        self.account_number = BankAccount.total_accounts + 1000

        # Increment class counter
        BankAccount.total_accounts += 1

    def display(self):
        """Display account information."""
        return f"Account \#{self.account_number}: {self.owner}, Balance: \${self.balance:.2f}"


# Test the class
acc1 = BankAccount("Alice", 1000)
acc2 = BankAccount("Bob", 500)
acc3 = BankAccount("Charlie")  # Uses default balance

print("=== Bank Accounts ===")
print(acc1.display())
print(acc2.display())
print(acc3.display())
print(f"\nTotal accounts created: {BankAccount.total_accounts}")

# Test validation
try:
    bad = BankAccount("", 100)
except ValueError as e:
    print(f"\nValidation error: {e}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>class:</strong> <code>class ClassName:</code> defines a blueprint for objects</li>
                            <li><strong>Object:</strong> An instance created from a class: <code>obj = ClassName()</code></li>
                            <li><strong>__init__:</strong> Constructor method that initializes new instances</li>
                            <li><strong>self:</strong> First parameter, refers to the instance being created/used</li>
                            <li><strong>Instance attributes:</strong> Unique per object, set with <code>self.attr</code></li>
                            <li><strong>Class attributes:</strong> Shared by all instances, defined in class body</li>
                            <li><strong>Identity:</strong> <code>is</code> checks same object, <code>==</code> checks equality</li>
                            <li><strong>Avoid:</strong> Mutable class attributes, forgetting self, returning from __init__</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can create classes with attributes, it's time to add behavior! Next, we'll
                    learn about <strong>methods</strong> - functions that belong to classes. You'll learn about
                    instance methods, class methods, static methods, and how to make your objects do things!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="errors-assert.jsp" />
                    <jsp:param name="prevTitle" value="Assertions" />
                    <jsp:param name="nextLink" value="oop-methods.jsp" />
                    <jsp:param name="nextTitle" value="Methods" />
                    <jsp:param name="currentLessonId" value="oop-classes" />
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
