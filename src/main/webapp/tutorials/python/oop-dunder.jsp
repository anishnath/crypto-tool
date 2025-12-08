<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-dunder");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Special Methods (Dunder) - __str__, __eq__, Operator Overloading | 8gwifi.org</title>
    <meta name="description"
        content="Master Python special methods (dunder methods): __str__, __repr__, __eq__, __add__, __len__, and more. Learn operator overloading and make your classes Pythonic.">
    <meta name="keywords"
        content="python dunder methods, python magic methods, python __str__, python __repr__, python __eq__, python operator overloading, python special methods">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Special Methods (Dunder) - __str__, __eq__, Operator Overloading">
    <meta property="og:description" content="Master Python dunder methods: __str__, __repr__, __eq__, __add__, and operator overloading.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-dunder.jsp">
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
        "name": "Python Special Methods (Dunder)",
        "description": "Master Python special methods: __str__, __repr__, __eq__, __add__, __len__, and operator overloading.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["__str__ method", "__repr__ method", "__eq__ comparison", "__lt__ and @total_ordering", "__hash__ for sets/dicts", "Arithmetic operators", "__add__ __sub__ __mul__", "__getitem__ __setitem__", "__len__ and __iter__", "Operator overloading"],
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

<body class="tutorial-body no-preview" data-lesson="oop-dunder">
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
                    <h1 class="lesson-title">Special Methods (Dunder)</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Special methods (also called "dunder" methods for "double underscore") let you define
                        how your objects behave with Python's built-in operations. Implement <code>__str__</code> for
                        <code>print()</code>, <code>__eq__</code> for <code>==</code>, <code>__add__</code> for <code>+</code>,
                        and make your classes feel like native Python types.</p>

                    <div class="info-box">
                        <h4>What Are Dunder Methods?</h4>
                        <p>Dunder methods have double underscores on both sides: <code>__init__</code>, <code>__str__</code>,
                            <code>__add__</code>. Python calls these automatically when you use operators, built-in functions,
                            or certain syntax on your objects. They're the hook into Python's data model.</p>
                    </div>

                    <!-- Section 1: __str__ and __repr__ -->
                    <h2>String Representation: __str__ and __repr__</h2>
                    <p>Control how your objects appear when printed or displayed. <code>__str__</code> is for end users,
                        <code>__repr__</code> is for developers and debugging.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dunder-repr-str.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dunder-str" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>The Golden Rule for __repr__</h4>
                        <p>Make <code>__repr__</code> return valid Python code that could recreate the object:
                            <code>eval(repr(obj))</code> should give you an equivalent object. If you only implement one,
                            implement <code>__repr__</code> - Python uses it as a fallback for <code>__str__</code>.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: Comparison Methods -->
                    <h2>Comparison Methods</h2>
                    <p>Make your objects comparable with <code>==</code>, <code>&lt;</code>, <code>&gt;</code>, and enable
                        sorting. Use <code>@total_ordering</code> to only define <code>__eq__</code> and <code>__lt__</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dunder-comparison.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dunder-cmp" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>__eq__ and __hash__ Are Linked</h4>
                        <p>If you define <code>__eq__</code>, you should also define <code>__hash__</code> (or set
                            <code>__hash__ = None</code> to make objects unhashable). Objects that compare equal must
                            have the same hash value - this is required for sets and dict keys.</p>
                    </div>

                    <!-- Section 3: Arithmetic Operators -->
                    <h2>Arithmetic Operators</h2>
                    <p>Implement <code>+</code>, <code>-</code>, <code>*</code>, and other operators for your objects.
                        This is called operator overloading.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dunder-arithmetic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dunder-math" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>Regular vs Reverse vs In-place</h4>
                        <ul>
                            <li><code>__add__</code>: <code>a + b</code> - called on the left operand</li>
                            <li><code>__radd__</code>: <code>b + a</code> - called if left doesn't support the operation</li>
                            <li><code>__iadd__</code>: <code>a += b</code> - in-place, should return <code>self</code></li>
                        </ul>
                    </div>

                    <!-- Section 4: Container Methods -->
                    <h2>Container Methods</h2>
                    <p>Make your objects behave like lists, dicts, or other containers. Implement <code>__len__</code>,
                        <code>__getitem__</code>, <code>__iter__</code>, and more.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dunder-container.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dunder-container" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Iterator vs Iterable</h4>
                        <p>An <strong>iterable</strong> has <code>__iter__</code> and returns an iterator.
                            An <strong>iterator</strong> has both <code>__iter__</code> (returns self) and <code>__next__</code>.
                            For simple cases, <code>__iter__</code> can return <code>iter(self.data)</code> and skip <code>__next__</code>.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to return in __str__ / __repr__</h4>
                        <pre><code class="language-python"># Wrong - prints instead of returning
class Person:
    def __str__(self):
        print(f"Person: {self.name}")  # Returns None!

# Correct - return a string
class Person:
    def __str__(self):
        return f"Person: {self.name}"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting __hash__ when defining __eq__</h4>
                        <pre><code class="language-python"># Problem - objects become unhashable
class Point:
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y
    # No __hash__!

p = Point(1, 2)
{p}  # TypeError: unhashable type: 'Point'

# Solution 1 - implement __hash__
def __hash__(self):
    return hash((self.x, self.y))

# Solution 2 - explicitly unhashable
__hash__ = None  # Can't be in sets/dict keys</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not returning self from __iadd__</h4>
                        <pre><code class="language-python"># Wrong - doesn't return self
class Counter:
    def __iadd__(self, other):
        self.value += other
        # Missing return self!

c = Counter(5)
c += 3  # c becomes None!

# Correct - always return self
def __iadd__(self, other):
    self.value += other
    return self  # Required!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not handling different types in __eq__</h4>
                        <pre><code class="language-python"># Wrong - crashes on type mismatch
class Point:
    def __eq__(self, other):
        return self.x == other.x  # AttributeError if other isn't Point!

# Correct - check type or return NotImplemented
class Point:
    def __eq__(self, other):
        if not isinstance(other, Point):
            return NotImplemented  # Let Python try other.__eq__
        return self.x == other.x and self.y == other.y</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Inconsistent __lt__ and __eq__</h4>
                        <pre><code class="language-python"># Problem - sorting may give unexpected results
class Score:
    def __lt__(self, other):
        return self.value < other.value

    def __eq__(self, other):
        return self.name == other.name  # Different criterion!

# Both should use the same comparison logic
# Or use @total_ordering and be explicit</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Fraction Class</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a Fraction class with dunder methods for arithmetic and comparison.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li><code>__str__</code>: Return "numerator/denominator" (e.g., "3/4")</li>
                            <li><code>__repr__</code>: Return "Fraction(num, denom)"</li>
                            <li><code>__eq__</code>: Check equality (1/2 should equal 2/4)</li>
                            <li><code>__lt__</code>: Enable sorting</li>
                            <li><code>__add__</code>: Add fractions (a/b + c/d = (ad + cb) / bd)</li>
                            <li><code>__mul__</code>: Multiply fractions (a/b * c/d = ac / bd)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-dunder.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-dunder" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class Fraction:
    def __init__(self, numerator, denominator):
        # Simplify fraction
        gcd = self._gcd(abs(numerator), abs(denominator))
        self.num = numerator // gcd
        self.denom = denominator // gcd

    @staticmethod
    def _gcd(a, b):
        while b:
            a, b = b, a % b
        return a

    def __str__(self):
        return f"{self.num}/{self.denom}"

    def __repr__(self):
        return f"Fraction({self.num}, {self.denom})"

    def __eq__(self, other):
        # Works because fractions are simplified
        return self.num == other.num and self.denom == other.denom

    def __lt__(self, other):
        # Compare by cross multiplication
        return self.num * other.denom < other.num * self.denom

    def __add__(self, other):
        new_num = self.num * other.denom + other.num * self.denom
        new_denom = self.denom * other.denom
        return Fraction(new_num, new_denom)

    def __mul__(self, other):
        return Fraction(self.num * other.num, self.denom * other.denom)


# Test
f1 = Fraction(1, 2)
f2 = Fraction(1, 4)
f3 = Fraction(2, 4)

print(f"f1: {f1}, repr: {repr(f1)}")
print(f"f1 == f3: {f1 == f3}")  # True
print(f"f1 + f2: {f1 + f2}")    # 3/4
print(f"f1 * f2: {f1 * f2}")    # 1/8
print(f"Sorted: {sorted([Fraction(3,4), f1, f2])}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><code>__str__</code> for users, <code>__repr__</code> for developers (implement __repr__ first)</li>
                            <li><code>__eq__</code> + <code>__hash__</code> for equality and set/dict usage</li>
                            <li><code>@total_ordering</code>: Define <code>__eq__</code> + <code>__lt__</code>, get all comparisons</li>
                            <li><code>__add__</code>, <code>__radd__</code>, <code>__iadd__</code> for <code>+</code>, reverse, and in-place</li>
                            <li><code>__len__</code>, <code>__getitem__</code>, <code>__iter__</code> for container behavior</li>
                            <li>Return <code>NotImplemented</code> (not <code>raise NotImplementedError</code>) from operators on type mismatch</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>Now that you know about dunder methods, learn about <strong>Properties</strong> - using
                            <code>@property</code> decorator to create getters and setters that look like attribute access,
                            providing cleaner syntax than explicit getter/setter methods.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-polymorphism.jsp" />
                    <jsp:param name="prevTitle" value="Polymorphism" />
                    <jsp:param name="nextLink" value="oop-properties.jsp" />
                    <jsp:param name="nextTitle" value="Properties" />
                    <jsp:param name="currentLessonId" value="oop-dunder" />
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
