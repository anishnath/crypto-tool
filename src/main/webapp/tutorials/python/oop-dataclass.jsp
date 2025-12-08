<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-dataclass");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Dataclasses - @dataclass, field(), frozen, __post_init__ | 8gwifi.org</title>
    <meta name="description"
        content="Master Python dataclasses for cleaner code. Learn @dataclass decorator, field() options, frozen immutable classes, __post_init__, and inheritance.">
    <meta name="keywords"
        content="python dataclass, python @dataclass, python field, python frozen dataclass, python __post_init__, python dataclass inheritance">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Dataclasses - @dataclass, field(), frozen, __post_init__">
    <meta property="og:description" content="Master Python dataclasses for cleaner, more maintainable code.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-dataclass.jsp">
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
        "name": "Python Dataclasses",
        "description": "Master Python dataclasses for cleaner code with @dataclass decorator, field() options, frozen immutable classes, and __post_init__.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["@dataclass decorator", "Auto-generated methods", "field() function", "default_factory", "Frozen dataclasses", "__post_init__", "InitVar", "Dataclass inheritance", "asdict and astuple", "slots and kw_only"],
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

<body class="tutorial-body no-preview" data-lesson="oop-dataclass">
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
                    <h1 class="lesson-title">Dataclasses</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Dataclasses (Python 3.7+) eliminate boilerplate code when creating classes that
                        primarily store data. The <code>@dataclass</code> decorator automatically generates
                        <code>__init__</code>, <code>__repr__</code>, <code>__eq__</code>, and other methods from
                        class attributes with type hints. What takes 15+ lines traditionally becomes just 4 lines.</p>

                    <div class="info-box">
                        <h4>What @dataclass Generates</h4>
                        <ul>
                            <li><strong>__init__:</strong> Initializer with all fields as parameters</li>
                            <li><strong>__repr__:</strong> String representation showing all field values</li>
                            <li><strong>__eq__:</strong> Equality comparison based on all fields</li>
                            <li><strong>__hash__:</strong> Hash function (if frozen=True or eq=False)</li>
                            <li><strong>Ordering methods:</strong> __lt__, __le__, __gt__, __ge__ (if order=True)</li>
                        </ul>
                    </div>

                    <!-- Section 1: Basics -->
                    <h2>Dataclass Basics</h2>
                    <p>A dataclass is defined by decorating a class with <code>@dataclass</code> and using type
                        annotations for fields. The decorator introspects the annotations and generates the
                        necessary methods automatically.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dataclass-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dataclass-basics" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Type Hints Are Required, Not Enforced</h4>
                        <p>Dataclasses require type annotations to identify fields, but Python doesn't enforce types
                            at runtime. Use type checkers like <code>mypy</code> or <code>pyright</code> for static
                            type validation during development.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: Fields -->
                    <h2>Dataclass Fields</h2>
                    <p>The <code>field()</code> function provides fine-grained control over individual fields.
                        Use it to set mutable defaults, exclude fields from repr/comparison, or add metadata.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dataclass-fields.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dataclass-fields" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>Never Use Mutable Defaults Directly</h4>
                        <p>Using <code>items: list = []</code> would share one list across all instances!
                            Always use <code>field(default_factory=list)</code> for mutable defaults like
                            lists, dicts, or sets. Python raises <code>ValueError</code> if you try to use
                            a mutable default directly.</p>
                    </div>

                    <!-- Section 3: Frozen and __post_init__ -->
                    <h2>Frozen Dataclasses & __post_init__</h2>
                    <p>Frozen dataclasses are immutable - attempting to modify fields raises an error. The
                        <code>__post_init__</code> method runs after <code>__init__</code> completes, perfect
                        for validation or computing derived fields.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dataclass-frozen.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dataclass-frozen" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>InitVar for Init-Only Variables</h4>
                        <p><code>InitVar[T]</code> declares parameters that are passed to <code>__init__</code> and
                            <code>__post_init__</code> but not stored as instance attributes. Use this for values
                            needed during initialization but shouldn't be kept (like passwords to hash).</p>
                    </div>

                    <!-- Section 4: Advanced Features -->
                    <h2>Advanced Features</h2>
                    <p>Dataclasses support ordering, inheritance, conversion to dict/tuple, memory-efficient
                        slots, and keyword-only arguments. These features make dataclasses suitable for
                        complex real-world applications.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dataclass-advanced.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dataclass-advanced" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Python 3.10+ Features</h4>
                        <p><code>slots=True</code> reduces memory usage and prevents adding dynamic attributes.
                            <code>kw_only=True</code> forces all arguments to be keyword-only, improving code
                            readability for classes with many fields.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using mutable default values directly</h4>
                        <pre><code class="language-python"># Wrong - shared mutable default!
@dataclass
class BadInventory:
    items: list = []  # ValueError! Python prevents this

# Correct - each instance gets its own list
@dataclass
class GoodInventory:
    items: list = field(default_factory=list)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Putting defaults before non-defaults</h4>
                        <pre><code class="language-python"># Wrong - defaults must come after non-defaults!
@dataclass
class BadOrder:
    status: str = "pending"  # Default
    order_id: str            # No default - TypeError!

# Correct - non-defaults first
@dataclass
class GoodOrder:
    order_id: str            # Required
    status: str = "pending"  # Optional

# Alternative - use field(default=...) for complex ordering
@dataclass
class FlexibleOrder:
    status: str = field(default="pending")
    order_id: str = field(default_factory=lambda: "ORD-001")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting frozen dataclasses need object.__setattr__ in __post_init__</h4>
                        <pre><code class="language-python"># Wrong - can't set attributes on frozen instance
@dataclass(frozen=True)
class BadVector:
    x: float
    y: float
    magnitude: float = field(init=False)

    def __post_init__(self):
        self.magnitude = (self.x**2 + self.y**2)**0.5  # FrozenInstanceError!

# Correct - use object.__setattr__ for frozen
@dataclass(frozen=True)
class GoodVector:
    x: float
    y: float
    magnitude: float = field(init=False)

    def __post_init__(self):
        object.__setattr__(self, 'magnitude', (self.x**2 + self.y**2)**0.5)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Inheriting from non-dataclass with defaults</h4>
                        <pre><code class="language-python"># Problem - parent has defaults, child has required fields
@dataclass
class Parent:
    name: str = "Unknown"

@dataclass
class Child(Parent):
    age: int  # TypeError! Non-default follows default

# Solution 1 - give child fields defaults too
@dataclass
class Child(Parent):
    age: int = 0

# Solution 2 - use field() with kw_only in Python 3.10+
@dataclass
class Parent:
    name: str = "Unknown"

@dataclass
class Child(Parent):
    age: int = field(kw_only=True)  # Now works!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Using dataclass when attrs or namedtuple would be better</h4>
                        <pre><code class="language-python"># Dataclass might be overkill for simple cases
from dataclasses import dataclass

@dataclass
class Point:  # Fine, but consider alternatives
    x: int
    y: int

# For simple immutable data, NamedTuple is lighter
from typing import NamedTuple

class Point(NamedTuple):
    x: int
    y: int

# For more features (validators, converters), use attrs
import attrs

@attrs.define
class Point:
    x: int = attrs.field(validator=attrs.validators.instance_of(int))
    y: int = attrs.field(validator=attrs.validators.instance_of(int))

# Rule of thumb:
# - NamedTuple: simple immutable records
# - dataclass: most cases, stdlib solution
# - attrs: need validation, converters, advanced features</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: E-Commerce Product System</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a product management system using dataclasses.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li><code>Product</code> dataclass with sku, name, price, quantity, category, and total_value() method</li>
                            <li><code>Order</code> dataclass with items list (default_factory), discount (hidden from repr), and total() method</li>
                            <li><code>Address</code> frozen dataclass that can be used as dict keys</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-dataclass.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-dataclass" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">from dataclasses import dataclass, field
from typing import List

@dataclass
class Product:
    sku: str
    name: str
    price: float
    quantity: int = 0
    category: str = "General"

    def total_value(self) -> float:
        return self.price * self.quantity


@dataclass
class Order:
    order_id: str
    customer: str
    items: List[Product] = field(default_factory=list)
    discount: float = field(default=0.0, repr=False)

    def add_item(self, product: Product):
        self.items.append(product)

    def subtotal(self) -> float:
        return sum(item.price for item in self.items)

    def total(self) -> float:
        return self.subtotal() - self.discount


@dataclass(frozen=True)
class Address:
    street: str
    city: str
    zip_code: str
    country: str = "USA"


# Test
p1 = Product("SKU001", "Laptop", 999.99, 2)
p2 = Product("SKU002", "Mouse", 29.99, 5)
p3 = Product("SKU003", "Keyboard", 79.99, 3, "Electronics")

print("Products:")
print(f"  {p1}")
print(f"  Total value: \${p1.total_value():.2f}")

order = Order("ORD-001", "Alice")
order.add_item(p1)
order.add_item(p2)
order.add_item(p3)

print(f"\nOrder: {order.order_id}")
print(f"  Items: {len(order.items)}")
print(f"  Subtotal: \${order.subtotal():.2f}")
order.discount = 100.00
print(f"  After \$100 discount: \${order.total():.2f}")

addr1 = Address("123 Main St", "Boston", "02101")
addr2 = Address("123 Main St", "Boston", "02101")
print(f"\nAddress: {addr1}")
print(f"  addr1 == addr2: {addr1 == addr2}")
print(f"  Hashable: {hash(addr1) == hash(addr2)}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><code>@dataclass</code> auto-generates __init__, __repr__, __eq__ from type-annotated fields</li>
                            <li>Use <code>field(default_factory=list)</code> for mutable defaults</li>
                            <li><code>field(repr=False, compare=False)</code> controls which methods include a field</li>
                            <li><code>frozen=True</code> creates immutable, hashable dataclasses</li>
                            <li><code>__post_init__</code> runs after init for validation or computed fields</li>
                            <li><code>InitVar[T]</code> declares init-only variables not stored as attributes</li>
                            <li><code>order=True</code> adds comparison methods (__lt__, __gt__, etc.)</li>
                            <li><code>asdict()</code> and <code>astuple()</code> convert to dict/tuple</li>
                            <li>Python 3.10+: <code>slots=True</code>, <code>kw_only=True</code> for more control</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>You've completed the Object-Oriented Programming module! Next, explore
                            <strong>Iterators & Generators</strong> to learn about lazy evaluation,
                            the iterator protocol, <code>yield</code>, and memory-efficient data processing.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-abstract.jsp" />
                    <jsp:param name="prevTitle" value="Abstract Classes" />
                    <jsp:param name="nextLink" value="adv-iterators.jsp" />
                    <jsp:param name="nextTitle" value="Iterators" />
                    <jsp:param name="currentLessonId" value="oop-dataclass" />
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
