<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-properties");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Properties - @property Decorator, Getters and Setters | 8gwifi.org</title>
    <meta name="description"
        content="Master Python @property decorator: create getters, setters, and computed properties. Learn to manage attribute access with validation and Pythonic syntax.">
    <meta name="keywords"
        content="python property, python @property, python getter setter, python property decorator, python computed property, python encapsulation">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Properties - @property Decorator, Getters and Setters">
    <meta property="og:description" content="Master Python @property decorator for getters, setters, and computed properties.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-properties.jsp">
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
        "name": "Python Properties",
        "description": "Master Python @property decorator: create getters, setters, and computed properties with validation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["@property decorator", "Property getter", "Property setter", "Property deleter", "Computed properties", "Read-only properties", "Validation in setters", "Unit conversion", "Lazy loading", "cached_property"],
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

<body class="tutorial-body no-preview" data-lesson="oop-properties">
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
                    <h1 class="lesson-title">Properties</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>@property</code> decorator transforms methods into attribute-like access,
                        giving you the clean syntax of <code>obj.value</code> while keeping the control of getter/setter
                        methods. This is Python's preferred way to implement managed attributes with validation,
                        computation, or lazy loading.</p>

                    <div class="info-box">
                        <h4>Why Properties?</h4>
                        <p>Properties let you:</p>
                        <ul>
                            <li>Add validation without changing how users access the attribute</li>
                            <li>Create computed values that look like attributes</li>
                            <li>Make read-only attributes</li>
                            <li>Refactor internal implementation without breaking the public API</li>
                        </ul>
                    </div>

                    <!-- Section 1: Property Basics -->
                    <h2>Property Basics</h2>
                    <p>The <code>@property</code> decorator turns a method into a "getter" that's accessed like an
                        attribute - no parentheses needed.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/prop-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-prop-basics" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Start Public, Add Properties Later</h4>
                        <p>Python's philosophy: start with simple public attributes. If you later need validation or
                            computation, convert to a property - the interface stays the same! Users still write
                            <code>obj.value</code>, not <code>obj.get_value()</code>.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: Property Setters -->
                    <h2>Property Setters</h2>
                    <p>Add a setter to allow assignment (<code>obj.value = x</code>) with validation. Use the
                        <code>@property_name.setter</code> decorator.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/prop-setter.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-prop-setter" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>Setter Must Have the Same Name</h4>
                        <p>The setter decorator must be <code>@property_name.setter</code> and the method name must match
                            the property name. The internal storage should use a different name (typically with underscore:
                            <code>_property_name</code>).</p>
                    </div>

                    <!-- Section 3: Computed Properties -->
                    <h2>Computed Properties</h2>
                    <p>Properties can compute values from other attributes - like <code>area</code> from <code>width</code>
                        and <code>height</code>. These are typically read-only (no setter).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/prop-computed.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-prop-computed" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>@cached_property (Python 3.8+)</h4>
                        <p>For expensive computations that don't change, use <code>@cached_property</code> from functools.
                            It computes once on first access and caches the result. Unlike <code>@property</code>, it doesn't
                            recompute on each access.</p>
                    </div>

                    <!-- Section 4: Practical Patterns -->
                    <h2>Practical Property Patterns</h2>
                    <p>Real-world uses of properties: backward-compatible refactoring, dependent properties,
                        lazy loading, and access tracking.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/prop-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-prop-practical" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Properties for API Stability</h4>
                        <p>Properties let you change implementation details without changing the public interface.
                            Users write the same <code>obj.value</code> whether it's stored directly, computed,
                            validated, or lazily loaded.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using the same name for property and storage</h4>
                        <pre><code class="language-python"># Wrong - infinite recursion!
class Person:
    @property
    def name(self):
        return self.name  # Calls itself!

    @name.setter
    def name(self, value):
        self.name = value  # Calls itself!

# Correct - use different name for storage
class Person:
    @property
    def name(self):
        return self._name  # Underscore prefix

    @name.setter
    def name(self, value):
        self._name = value</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting to use @property_name.setter</h4>
                        <pre><code class="language-python"># Wrong - this creates a new property!
class Circle:
    @property
    def radius(self):
        return self._radius

    @property  # Wrong! Should be @radius.setter
    def radius(self, value):
        self._radius = value

# Correct
class Circle:
    @property
    def radius(self):
        return self._radius

    @radius.setter  # Correct decorator
    def radius(self, value):
        self._radius = value</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not using the setter in __init__</h4>
                        <pre><code class="language-python"># Problem - validation bypassed in __init__
class Temperature:
    def __init__(self, celsius):
        self._celsius = celsius  # Bypasses validation!

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Below absolute zero!")
        self._celsius = value

# Better - use property in __init__ for validation
class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius  # Uses setter - validates!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Making properties do too much work</h4>
                        <pre><code class="language-python"># Bad - expensive operation on every access
class Report:
    @property
    def data(self):
        # This runs a database query EVERY time!
        return self.database.fetch_all_records()

# Better - cache expensive operations
class Report:
    @property
    def data(self):
        if self._data is None:
            self._data = self.database.fetch_all_records()
        return self._data

# Or use @cached_property (Python 3.8+)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Properties with side effects</h4>
                        <pre><code class="language-python"># Bad - getter with surprising side effects
class Counter:
    @property
    def value(self):
        self._access_count += 1  # Side effect!
        return self._value

# Getters should be "pure" - no unexpected changes
# If you need to track access, be explicit about it</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Temperature Converter</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a Temperature class with properties for multiple units.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li><code>celsius</code> property with getter and setter (validates >= -273.15)</li>
                            <li><code>fahrenheit</code> property with getter and setter (converts to/from celsius)</li>
                            <li><code>kelvin</code> property - read-only getter (celsius + 273.15)</li>
                            <li><code>__str__</code> showing all three units</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-properties.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-properties" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class Temperature:
    def __init__(self, celsius=0):
        self.celsius = celsius  # Uses setter

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero!")
        self._celsius = value

    @property
    def fahrenheit(self):
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value):
        self.celsius = (value - 32) * 5/9

    @property
    def kelvin(self):
        return self._celsius + 273.15
    # No kelvin setter - read-only!

    def __str__(self):
        return f"{self.celsius}°C / {self.fahrenheit}°F / {self.kelvin}K"


# Test
t = Temperature(0)
print(t)  # 0°C / 32.0°F / 273.15K

t.celsius = 100
print(t)  # 100°C / 212.0°F / 373.15K

t.fahrenheit = 68
print(t)  # 20.0°C / 68.0°F / 293.15K</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><code>@property</code> creates a getter - access method like an attribute</li>
                            <li><code>@name.setter</code> creates a setter with validation</li>
                            <li><code>@name.deleter</code> handles <code>del obj.name</code></li>
                            <li>Store internal value with underscore: <code>_name</code> (not same as property name!)</li>
                            <li>Computed properties derive values from other attributes</li>
                            <li>Use <code>@cached_property</code> for expensive one-time computations</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>Now that you understand properties, learn about <strong>Abstract Classes</strong> - using
                            the <code>abc</code> module to define interfaces that subclasses must implement, ensuring
                            consistent APIs across related classes.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-dunder.jsp" />
                    <jsp:param name="prevTitle" value="Special Methods" />
                    <jsp:param name="nextLink" value="oop-abstract.jsp" />
                    <jsp:param name="nextTitle" value="Abstract Classes" />
                    <jsp:param name="currentLessonId" value="oop-properties" />
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
