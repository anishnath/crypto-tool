<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-inheritance");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Inheritance - Parent Child Classes, super(), Method Overriding | 8gwifi.org</title>
    <meta name="description"
        content="Master Python inheritance: create parent and child classes, use super() to call parent methods, override methods, and understand multiple inheritance with MRO.">
    <meta name="keywords"
        content="python inheritance, python super, python subclass, python parent class, python child class, method overriding, multiple inheritance, python MRO">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Inheritance - Parent Child Classes, super(), Method Overriding">
    <meta property="og:description" content="Master Python inheritance: parent/child classes, super(), method overriding, and multiple inheritance.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-inheritance.jsp">
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
        "name": "Python Inheritance",
        "description": "Master Python inheritance: create parent and child classes, use super() to call parent methods, override methods, and understand multiple inheritance.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Inheritance basics", "Parent and child classes", "super() function", "Calling parent methods", "Method overriding", "Extending vs replacing methods", "Multiple inheritance", "Method Resolution Order (MRO)", "Mixins pattern"],
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

<body class="tutorial-body no-preview" data-lesson="oop-inheritance">
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
                    <span>OOP</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Inheritance</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Inheritance is a fundamental OOP concept that allows you to create new classes based on existing ones.
                        The child class inherits attributes and methods from the parent class, enabling code reuse and establishing
                        logical hierarchies between related classes.</p>

                    <div class="info-box">
                        <h4>Key Terms</h4>
                        <ul>
                            <li><strong>Parent class</strong> (base class, superclass): The class being inherited from</li>
                            <li><strong>Child class</strong> (derived class, subclass): The class that inherits</li>
                            <li><strong>super()</strong>: Function to call parent class methods</li>
                            <li><strong>Override</strong>: Redefining a parent method in the child</li>
                        </ul>
                    </div>

                    <!-- Section 1: Inheritance Basics -->
                    <h2>Basic Inheritance</h2>
                    <p>To create a child class, put the parent class name in parentheses after the class name.
                        The child automatically inherits all attributes and methods from the parent.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/inherit-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-inherit-basics" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Use isinstance() for Type Checking</h4>
                        <p>With inheritance, <code>isinstance(dog, Animal)</code> returns True because Dog inherits from Animal.
                            This is better than <code>type(dog) == Dog</code> which doesn't account for inheritance.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: The super() Function -->
                    <h2>The super() Function</h2>
                    <p>When a child class defines its own <code>__init__</code>, it overrides the parent's.
                        Use <code>super()</code> to call the parent's <code>__init__</code> and ensure proper initialization.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/inherit-super.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-inherit-super" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>Always Call super().__init__() First</h4>
                        <p>If your child class has its own <code>__init__</code>, call <code>super().__init__()</code>
                            at the beginning to properly initialize the parent's attributes. Forgetting this is a common
                            source of AttributeError bugs.</p>
                    </div>

                    <!-- Section 3: Method Overriding -->
                    <h2>Method Overriding</h2>
                    <p>Child classes can override parent methods by defining a method with the same name.
                        You can either replace the method entirely or extend it by calling the parent's version.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/inherit-override.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-inherit-override" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>Extend vs Replace</h4>
                        <ul>
                            <li><strong>Replace:</strong> Define method without calling super() - completely new behavior</li>
                            <li><strong>Extend:</strong> Call super().method() inside your override - add to parent behavior</li>
                        </ul>
                        <p>Extending is often preferred because it preserves parent functionality while adding child-specific behavior.</p>
                    </div>

                    <!-- Section 4: Multiple Inheritance -->
                    <h2>Multiple Inheritance</h2>
                    <p>Python supports inheriting from multiple parent classes. While powerful, this requires
                        understanding the Method Resolution Order (MRO) to know which method gets called.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/inherit-multiple.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-inherit-multiple" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Prefer Mixins or Composition</h4>
                        <p>Instead of complex multiple inheritance, consider using <strong>mixins</strong> (small classes with focused functionality)
                            or <strong>composition</strong> (having objects as attributes rather than inheriting). These patterns are easier to understand and maintain.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to call super().__init__()</h4>
                        <pre><code class="language-python"># Wrong - parent attributes not initialized
class Student(Person):
    def __init__(self, name, age, grade):
        self.grade = grade  # name and age are missing!

# Correct - call super() first
class Student(Person):
    def __init__(self, name, age, grade):
        super().__init__(name, age)
        self.grade = grade</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Hardcoding parent class name</h4>
                        <pre><code class="language-python"># Bad - hardcodes parent class name
class Child(Parent):
    def method(self):
        Parent.method(self)  # What if parent changes?

# Good - use super() for flexibility
class Child(Parent):
    def method(self):
        super().method()  # Works with any parent</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Wrong argument passing to super()</h4>
                        <pre><code class="language-python"># Wrong - passing arguments incorrectly
class Student(Person):
    def __init__(self, name, age, grade):
        super().__init__()  # Missing arguments!

# Wrong - passing self explicitly (Python 2 style)
class Student(Person):
    def __init__(self, name, age, grade):
        super(Student, self).__init__(name, age)  # Verbose

# Correct (Python 3) - super() figures it out
class Student(Person):
    def __init__(self, name, age, grade):
        super().__init__(name, age)  # Clean!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Overriding without understanding</h4>
                        <pre><code class="language-python"># Wrong - accidentally breaking parent functionality
class SafeList(list):
    def append(self, item):
        print(f"Adding: {item}")
        # Forgot to actually append! List stays empty.

# Correct - call parent to preserve functionality
class SafeList(list):
    def append(self, item):
        print(f"Adding: {item}")
        super().append(item)  # Actually add the item</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Confusing MRO in multiple inheritance</h4>
                        <pre><code class="language-python"># Confusing - which method gets called?
class A:
    def method(self): return "A"

class B(A):
    def method(self): return "B"

class C(A):
    def method(self): return "C"

class D(B, C):  # Which method does D use?
    pass

d = D()
d.method()  # Returns "B" - follows MRO: D -> B -> C -> A

# Check MRO to understand:
print(D.__mro__)  # Shows the lookup order</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Employee Hierarchy</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a class hierarchy for employees using inheritance.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li><code>Manager</code> class: inherits from Employee, adds department and team management</li>
                            <li><code>Developer</code> class: inherits from Employee, adds programming languages</li>
                            <li><code>TechLead</code> class: inherits from both Developer and Manager (multiple inheritance)</li>
                            <li>Override <code>describe()</code> in each child class to include additional info</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-inheritance.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-inheritance" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def get_annual_salary(self):
        return self.salary * 12

    def describe(self):
        return f"{self.name}, Salary: \${self.salary:,}/month"


class Manager(Employee):
    def __init__(self, name, salary, department):
        super().__init__(name, salary)
        self.department = department
        self.team = []

    def add_report(self, employee):
        self.team.append(employee)

    def describe(self):
        base = super().describe()
        return f"{base}, Dept: {self.department}, Team: {len(self.team)}"


class Developer(Employee):
    def __init__(self, name, salary, languages=None):
        super().__init__(name, salary)
        self.programming_languages = languages or []

    def add_language(self, language):
        self.programming_languages.append(language)

    def describe(self):
        base = super().describe()
        langs = ", ".join(self.programming_languages)
        return f"{base}, Languages: [{langs}]"


class TechLead(Developer, Manager):
    def __init__(self, name, salary, department, languages=None):
        # Need to handle multiple inheritance carefully
        Employee.__init__(self, name, salary)
        self.department = department
        self.team = []
        self.programming_languages = languages or []

    def describe(self):
        langs = ", ".join(self.programming_languages)
        return (f"{self.name}, \${self.salary:,}/month, "
                f"Dept: {self.department}, Team: {len(self.team)}, "
                f"Languages: [{langs}]")


# Test
dev1 = Developer("Alice", 6000, ["Python", "JavaScript"])
mgr = Manager("Carol", 8000, "Engineering")
mgr.add_report(dev1)
lead = TechLead("David", 9000, "Platform", ["Python", "Go"])
lead.add_report(dev1)
lead.add_language("Rust")

print(dev1.describe())
print(mgr.describe())
print(lead.describe())</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><strong>Inheritance syntax:</strong> <code>class Child(Parent):</code> creates a child class</li>
                            <li><strong>super()</strong> calls parent class methods, essential for <code>__init__</code></li>
                            <li><strong>Method overriding</strong> lets children replace or extend parent behavior</li>
                            <li><strong>isinstance()</strong> checks if an object is an instance of a class or its parent</li>
                            <li><strong>Multiple inheritance:</strong> <code>class Child(Parent1, Parent2):</code> - use MRO to understand method lookup</li>
                            <li><strong>Mixins and composition</strong> are often better alternatives to complex inheritance</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>Now that you understand inheritance, learn about <strong>Encapsulation</strong> - controlling
                            access to attributes and methods using Python's naming conventions for public, protected,
                            and private members.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-methods.jsp" />
                    <jsp:param name="prevTitle" value="Methods" />
                    <jsp:param name="nextLink" value="oop-encapsulation.jsp" />
                    <jsp:param name="nextTitle" value="Encapsulation" />
                    <jsp:param name="currentLessonId" value="oop-inheritance" />
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
