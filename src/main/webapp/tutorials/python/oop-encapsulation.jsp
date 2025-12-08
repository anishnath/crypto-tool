<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-encapsulation");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Encapsulation - Public, Protected, Private Attributes | 8gwifi.org</title>
    <meta name="description"
        content="Master Python encapsulation: public, protected (_), and private (__) attributes. Learn name mangling, getters/setters, and data hiding best practices.">
    <meta name="keywords"
        content="python encapsulation, python private variable, python protected, python underscore, python double underscore, name mangling, python getters setters">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Encapsulation - Public, Protected, Private Attributes">
    <meta property="og:description" content="Master Python encapsulation: public, protected (_), and private (__) attributes with name mangling.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-encapsulation.jsp">
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
        "name": "Python Encapsulation",
        "description": "Master Python encapsulation: public, protected (_), and private (__) attributes, name mangling, and getter/setter methods.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Encapsulation concept", "Public attributes", "Protected attributes (_)", "Private attributes (__)", "Name mangling", "Getter methods", "Setter methods", "Data validation", "Read-only attributes"],
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

<body class="tutorial-body no-preview" data-lesson="oop-encapsulation">
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
                    <h1 class="lesson-title">Encapsulation</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Encapsulation is the practice of bundling data and methods that operate on that data
                        within a single class, while restricting direct access to some components. Python uses naming
                        conventions (underscores) rather than strict access modifiers to indicate the intended visibility
                        of attributes and methods.</p>

                    <div class="info-box">
                        <h4>Python's Access Levels</h4>
                        <table style="width:100%; border-collapse: collapse;">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <th style="text-align:left; padding: 8px;">Prefix</th>
                                <th style="text-align:left; padding: 8px;">Name</th>
                                <th style="text-align:left; padding: 8px;">Meaning</th>
                            </tr>
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 8px;"><code>attr</code></td>
                                <td style="padding: 8px;">Public</td>
                                <td style="padding: 8px;">Accessible from anywhere</td>
                            </tr>
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 8px;"><code>_attr</code></td>
                                <td style="padding: 8px;">Protected</td>
                                <td style="padding: 8px;">Internal use, subclasses OK (convention)</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px;"><code>__attr</code></td>
                                <td style="padding: 8px;">Private</td>
                                <td style="padding: 8px;">Name mangled to prevent accidental access</td>
                            </tr>
                        </table>
                    </div>

                    <!-- Section 1: Public Attributes -->
                    <h2>Public Attributes</h2>
                    <p>Public attributes have no underscore prefix and can be freely accessed and modified from anywhere.
                        They're part of the class's public interface.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/encap-public.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-encap-public" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Start Public, Encapsulate Later</h4>
                        <p>Python philosophy: start with public attributes. Add encapsulation (underscore) when you actually
                            need validation or computed values. Don't over-engineer prematurely.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: Protected Attributes -->
                    <h2>Protected Attributes (_single underscore)</h2>
                    <p>A single underscore prefix signals "this is internal, use at your own risk." It's a convention
                        that Python developers respect, though it's not enforced by the language.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/encap-protected.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-encap-protected" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>It's a Convention, Not Enforcement</h4>
                        <p>Python won't stop you from accessing <code>_protected</code> attributes. The underscore is a
                            signal to other developers: "this is an implementation detail that may change." Respect the
                            convention in your own code.</p>
                    </div>

                    <!-- Section 3: Private Attributes -->
                    <h2>Private Attributes (__double underscore)</h2>
                    <p>Double underscore prefix triggers "name mangling" - Python renames the attribute to include the
                        class name, making accidental access harder. Use this to prevent subclass attribute conflicts.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/encap-private.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-encap-private" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>Name Mangling: __attr becomes _ClassName__attr</h4>
                        <p>Python doesn't truly hide private attributes. It renames <code>__secret</code> to
                            <code>_MyClass__secret</code>. This prevents accidental name clashes in inheritance, but
                            determined users can still access it. Privacy in Python is about intent, not enforcement.</p>
                    </div>

                    <!-- Section 4: Getter and Setter Methods -->
                    <h2>Getter and Setter Methods</h2>
                    <p>To control access to attributes, provide getter and setter methods. These allow validation,
                        computed values, and read-only attributes.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/encap-getters-setters.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-encap-getters" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Python Has a Better Way: @property</h4>
                        <p>Instead of explicit <code>get_x()</code> and <code>set_x()</code> methods, Python provides
                            the <code>@property</code> decorator for cleaner syntax. You'll learn this in the
                            <strong>Properties</strong> lesson.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing _ and __ purposes</h4>
                        <pre><code class="language-python"># Wrong - using __ just for "privacy"
class User:
    def __init__(self, name):
        self.__name = name  # Overkill! Use single underscore

# Better - single underscore for internal attributes
class User:
    def __init__(self, name):
        self._name = name  # Convention: internal use

# Use __ only to prevent subclass conflicts</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Accessing private via name mangling</h4>
                        <pre><code class="language-python"># Bad practice - bypassing name mangling
class Secret:
    def __init__(self):
        self.__value = 42

s = Secret()
print(s._Secret__value)  # Works but DON'T DO THIS!

# If you need to access it, the class should provide a method
# Or reconsider your design</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting validation in setters</h4>
                        <pre><code class="language-python"># Pointless getter/setter - no validation
class Person:
    def __init__(self, age):
        self._age = age

    def get_age(self):
        return self._age

    def set_age(self, age):
        self._age = age  # No validation! Why have a setter?

# Better - setter should validate
class Person:
    def set_age(self, age):
        if age < 0 or age > 150:
            raise ValueError("Invalid age")
        self._age = age</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Returning mutable internal data</h4>
                        <pre><code class="language-python"># Wrong - exposing internal list
class ShoppingCart:
    def __init__(self):
        self._items = []

    def get_items(self):
        return self._items  # Caller can modify!

cart = ShoppingCart()
items = cart.get_items()
items.append("hacked!")  # Modifies internal state!

# Correct - return a copy
def get_items(self):
    return self._items.copy()  # Safe copy</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Over-encapsulating simple data classes</h4>
                        <pre><code class="language-python"># Over-engineered for simple data
class Point:
    def __init__(self, x, y):
        self._x = x
        self._y = y

    def get_x(self): return self._x
    def get_y(self): return self._y
    def set_x(self, x): self._x = x
    def set_y(self, y): self._y = y

# Better - just use public attributes for simple data
class Point:
    def __init__(self, x, y):
        self.x = x  # Simple, direct
        self.y = y</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Secure User Account</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a User class with proper encapsulation for sensitive data.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Public: <code>username</code> - visible to everyone</li>
                            <li>Protected: <code>_email</code> - internal use with getter</li>
                            <li>Private: <code>__password</code> - never exposed directly</li>
                            <li>Methods: <code>verify_password()</code>, <code>change_password()</code></li>
                            <li><code>__str__</code>: Show username and masked email</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-encapsulation.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-encapsulation" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class User:
    def __init__(self, username, email, password):
        self.username = username      # Public
        self._email = email           # Protected
        self.__password = password    # Private

    def get_email(self):
        return self._email

    def verify_password(self, password):
        return password == self.__password

    def change_password(self, old_password, new_password):
        if self.verify_password(old_password):
            self.__password = new_password
            return True
        return False

    def __str__(self):
        # Mask email: first char + *** + @domain
        parts = self._email.split('@')
        masked = parts[0][0] + '***@' + parts[1]
        return f"User: {self.username}, Email: {masked}"


# Test
user = User("alice", "alice@example.com", "secret123")
print(user.username)  # alice
print(user.get_email())  # alice@example.com
print(user.verify_password("secret123"))  # True
print(user.verify_password("wrong"))  # False
print(user.change_password("secret123", "newpass"))  # True
print(user)  # User: alice, Email: a***@example.com</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><strong>Public</strong> (no prefix): Accessible from anywhere, part of public API</li>
                            <li><strong>Protected</strong> (<code>_single</code>): Convention for internal use, subclasses OK</li>
                            <li><strong>Private</strong> (<code>__double</code>): Name mangled to prevent subclass conflicts</li>
                            <li><strong>Name mangling:</strong> <code>__attr</code> becomes <code>_ClassName__attr</code></li>
                            <li><strong>Getters/setters:</strong> Methods for controlled access and validation</li>
                            <li>Python relies on conventions, not enforcement - "we're all consenting adults"</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>Now that you understand encapsulation, learn about <strong>Polymorphism</strong> - how
                            different classes can share the same interface, enabling flexible and reusable code through
                            duck typing and method overriding.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-inheritance.jsp" />
                    <jsp:param name="prevTitle" value="Inheritance" />
                    <jsp:param name="nextLink" value="oop-polymorphism.jsp" />
                    <jsp:param name="nextTitle" value="Polymorphism" />
                    <jsp:param name="currentLessonId" value="oop-encapsulation" />
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
