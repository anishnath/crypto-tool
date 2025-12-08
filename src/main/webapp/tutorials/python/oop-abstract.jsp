<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-abstract");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Abstract Classes - ABC, @abstractmethod, Interfaces | 8gwifi.org</title>
    <meta name="description"
        content="Master Python abstract classes using the abc module. Learn @abstractmethod, abstract properties, and when to use abstract classes vs duck typing.">
    <meta name="keywords"
        content="python abstract class, python abc, python abstractmethod, python interface, python abstract property, python duck typing vs abc">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Abstract Classes - ABC, @abstractmethod, Interfaces">
    <meta property="og:description" content="Master Python abstract classes with ABC module, @abstractmethod, and abstract properties.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-abstract.jsp">
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
        "name": "Python Abstract Classes",
        "description": "Master Python abstract classes using the abc module, @abstractmethod, abstract properties, and interface design.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["ABC module", "@abstractmethod decorator", "Abstract properties", "Interface design", "Template method pattern", "Duck typing vs ABC", "Protocol (typing)", "Plugin systems"],
        "timeRequired": "PT25M",
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

<body class="tutorial-body no-preview" data-lesson="oop-abstract">
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
                    <h1 class="lesson-title">Abstract Classes</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Abstract classes define interfaces that subclasses must implement. Using Python's
                        <code>abc</code> module, you can create classes that cannot be instantiated directly and enforce
                        that child classes implement specific methods. This is Python's way of creating formal contracts
                        between classes.</p>

                    <div class="info-box">
                        <h4>What Are Abstract Classes?</h4>
                        <ul>
                            <li><strong>Abstract class:</strong> A class that cannot be instantiated directly</li>
                            <li><strong>Abstract method:</strong> A method with no implementation that must be overridden</li>
                            <li><strong>Concrete method:</strong> A regular method with implementation (can be inherited)</li>
                            <li>Subclasses must implement ALL abstract methods to be instantiable</li>
                        </ul>
                    </div>

                    <!-- Section 1: Abstract Basics -->
                    <h2>Abstract Class Basics</h2>
                    <p>Inherit from <code>ABC</code> and use <code>@abstractmethod</code> to define methods that
                        subclasses must implement. Trying to instantiate an incomplete class raises <code>TypeError</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/abstract-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-abstract-basics" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Concrete Methods in Abstract Classes</h4>
                        <p>Abstract classes can have concrete (implemented) methods too. These are inherited normally.
                            Use this for shared functionality that all subclasses need, while still enforcing that
                            specific methods must be customized.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: Abstract Properties -->
                    <h2>Abstract Properties</h2>
                    <p>You can also define abstract properties that subclasses must implement. Stack
                        <code>@property</code> and <code>@abstractmethod</code> decorators (property first).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/abstract-properties.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-abstract-props" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>Decorator Order Matters</h4>
                        <p>When combining decorators, <code>@property</code> must come before <code>@abstractmethod</code>:
                        <pre><code>@property
@abstractmethod
def name(self):
    pass</code></pre>
                        </p>
                    </div>

                    <!-- Section 3: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>Abstract classes are ideal for defining interfaces in plugin systems, database drivers,
                        payment processors, and other extensible systems.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/abstract-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-abstract-practical" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>Template Method Pattern</h4>
                        <p>Abstract classes enable the Template Method pattern: define the skeleton of an algorithm
                            in a concrete method, calling abstract methods that subclasses customize. The abstract class
                            controls the flow while subclasses provide specific behavior.</p>
                    </div>

                    <!-- Section 4: ABC vs Duck Typing -->
                    <h2>Abstract Classes vs Duck Typing</h2>
                    <p>Python offers both explicit interfaces (ABC) and implicit interfaces (duck typing).
                        Understanding when to use each is key to Pythonic design.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/abstract-vs-duck.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-abstract-vs-duck" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>typing.Protocol (Python 3.8+)</h4>
                        <p>For the best of both worlds, consider <code>Protocol</code> from the typing module. It provides
                            structural subtyping (duck typing) with type checker support - no inheritance required, but
                            still documents the expected interface.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to inherit from ABC</h4>
                        <pre><code class="language-python"># Wrong - @abstractmethod does nothing without ABC!
class Shape:
    @abstractmethod
    def area(self):
        pass

s = Shape()  # Works! No enforcement

# Correct - must inherit from ABC
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

s = Shape()  # TypeError! Can't instantiate</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Wrong decorator order for abstract properties</h4>
                        <pre><code class="language-python"># Wrong order!
class Vehicle(ABC):
    @abstractmethod
    @property
    def speed(self):  # This won't work correctly
        pass

# Correct - @property first, then @abstractmethod
class Vehicle(ABC):
    @property
    @abstractmethod
    def speed(self):
        pass</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not implementing all abstract methods</h4>
                        <pre><code class="language-python">class Animal(ABC):
    @abstractmethod
    def speak(self): pass

    @abstractmethod
    def move(self): pass

# Incomplete - missing move()
class Dog(Animal):
    def speak(self):
        return "Woof"

d = Dog()  # TypeError: Can't instantiate - move() not implemented

# Complete - both methods implemented
class Dog(Animal):
    def speak(self):
        return "Woof"

    def move(self):
        return "Run"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Calling super() on abstract methods that raise NotImplementedError</h4>
                        <pre><code class="language-python"># Problem - abstract method raises error
class Base(ABC):
    @abstractmethod
    def process(self):
        raise NotImplementedError

class Child(Base):
    def process(self):
        super().process()  # This raises NotImplementedError!
        return "processed"

# Better - abstract method with pass or documentation
class Base(ABC):
    @abstractmethod
    def process(self):
        """Process the data. Override in subclass."""
        pass  # or just docstring</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Using ABC when duck typing would suffice</h4>
                        <pre><code class="language-python"># Over-engineered - simple interface doesn't need ABC
class Printable(ABC):
    @abstractmethod
    def to_string(self): pass

# Pythonic - just document the expected interface
def print_item(item):
    """Print item. Item must have to_string() method."""
    print(item.to_string())

# ABC is best for complex interfaces, frameworks, or team codebases</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Notification System</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create an abstract notification system with multiple notification types.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Abstract <code>Notifier</code> class with abstract <code>send()</code> and <code>name</code> property</li>
                            <li>Concrete <code>notify()</code> method that prints "[name] Sending..." then calls send()</li>
                            <li><code>EmailNotifier</code>, <code>SMSNotifier</code>, <code>PushNotifier</code> implementations</li>
                            <li><code>notify_all()</code> function to send to multiple notifiers</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-abstract.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-abstract" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">from abc import ABC, abstractmethod

class Notifier(ABC):
    @property
    @abstractmethod
    def name(self):
        pass

    @abstractmethod
    def send(self, message):
        pass

    def notify(self, message):
        print(f"[{self.name}] Sending...")
        result = self.send(message)
        print(result)


class EmailNotifier(Notifier):
    def __init__(self, email_address):
        self.email_address = email_address

    @property
    def name(self):
        return "Email"

    def send(self, message):
        return f"Email sent to {self.email_address}: {message}"


class SMSNotifier(Notifier):
    def __init__(self, phone_number):
        self.phone_number = phone_number

    @property
    def name(self):
        return "SMS"

    def send(self, message):
        return f"SMS sent to {self.phone_number}: {message}"


class PushNotifier(Notifier):
    def __init__(self, device_id):
        self.device_id = device_id

    @property
    def name(self):
        return "Push"

    def send(self, message):
        return f"Push notification to device {self.device_id}: {message}"


def notify_all(notifiers, message):
    for notifier in notifiers:
        notifier.notify(message)


# Test
notifiers = [
    EmailNotifier("user@example.com"),
    SMSNotifier("+1234567890"),
    PushNotifier("device-abc-123")
]
notify_all(notifiers, "Your order has shipped!")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><code>from abc import ABC, abstractmethod</code> to use abstract classes</li>
                            <li>Inherit from <code>ABC</code> to make a class abstract</li>
                            <li><code>@abstractmethod</code> marks methods that must be overridden</li>
                            <li>Can't instantiate abstract classes or classes with unimplemented abstract methods</li>
                            <li>Abstract classes can have concrete methods (template method pattern)</li>
                            <li>Use <code>@property</code> before <code>@abstractmethod</code> for abstract properties</li>
                            <li>Consider <code>typing.Protocol</code> for structural (duck) typing with type hints</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>Now that you understand abstract classes, learn about <strong>Dataclasses</strong> - Python's
                            <code>@dataclass</code> decorator that automatically generates <code>__init__</code>,
                            <code>__repr__</code>, <code>__eq__</code>, and more for data-holding classes.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-properties.jsp" />
                    <jsp:param name="prevTitle" value="Properties" />
                    <jsp:param name="nextLink" value="oop-dataclass.jsp" />
                    <jsp:param name="nextTitle" value="Dataclasses" />
                    <jsp:param name="currentLessonId" value="oop-abstract" />
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
