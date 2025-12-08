<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "adv-typing" ); request.setAttribute("currentModule", "Advanced Topics" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Type Hinting - typing Module, Annotations & Type Checking | 8gwifi.org</title>
            <meta name="description"
                content="Master Python type hinting and the typing module. Learn how to add type annotations to functions, variables, and classes for better code documentation, IDE support, and static type checking.">
            <meta name="keywords"
                content="python type hinting, python typing module, python type annotations, static type checking, python mypy, python type hints">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Type Hinting - typing Module, Annotations & Type Checking">
            <meta property="og:description"
                content="Master Python type hinting and the typing module. Learn how to add type annotations for better code documentation and IDE support with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/adv-typing.jsp">
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
        "name": "Python Type Hinting",
        "description": "Master Python type hinting and the typing module. Learn how to add type annotations for better code documentation and IDE support.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Type annotations", "typing module", "Function type hints", "Variable type hints", "Generic types", "Optional types", "Union types", "Type checking"],
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

        <body class="tutorial-body no-preview" data-lesson="adv-typing">
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
                                    <span>Advanced</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Type Hinting</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Type hinting lets you add type annotations to your Python code,
                                        making it clearer what types of values functions expect and return. While Python
                                        remains dynamically typed at runtime, type hints improve code documentation, enable
                                        better IDE autocomplete and error detection, and can be checked statically with
                                        tools like mypy. Introduced in PEP 484 (Python 3.5) and enhanced in later
                                        versions!</p>

                                    <h2>Basic Type Annotations</h2>
                                    <p>You can add type hints to function parameters and return values using the syntax
                                        <code>parameter: type</code> and <code>-&gt; return_type</code>. For simple types,
                                        use built-in types like <code>int</code>, <code>str</code>, <code>list</code>,
                                        <code>dict</code>.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-typing-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Why Use Type Hints:</strong><br>
                                        - <strong>Documentation:</strong> Makes code self-documenting about expected types<br>
                                        - <strong>IDE Support:</strong> Better autocomplete, refactoring, and error
                                        detection<br>
                                        - <strong>Type Checking:</strong> Tools like mypy can catch type errors before
                                        runtime<br>
                                        - <strong>Refactoring:</strong> Easier to safely modify code when types are known<br>
                                        Note: Type hints don't affect runtime behavior - Python remains dynamically typed!
                                    </div>

                                    <h2>The typing Module</h2>
                                    <p>For more complex types, use the <code>typing</code> module. It provides generic
                                        types like <code>List</code>, <code>Dict</code>, <code>Optional</code>,
                                        <code>Union</code>, and more. Python 3.9+ allows using built-in types like
                                        <code>list</code> and <code>dict</code> directly in type hints!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-typing-module.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-module" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> In Python 3.9+, you can use built-in types like
                                        <code>list[str]</code> instead of <code>List[str]</code> from typing. Use
                                        <code>from __future__ import annotations</code> at the top of files for Python
                                        3.7+ to enable this syntax!
                                    </div>

                                    <h2>Optional and Union Types</h2>
                                    <p>Use <code>Optional[Type]</code> for values that can be <code>None</code> (same as
                                        <code>Union[Type, None]</code>). Use <code>Union[Type1, Type2]</code> when a value
                                        can be one of multiple types. Python 3.10+ supports the cleaner <code>Type1 |
                                        Type2</code> syntax!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-typing-optional.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-optional" />
                                    </jsp:include>

                                    <h2>Variable Type Annotations</h2>
                                    <p>You can also annotate variables directly, not just function parameters. This is
                                        useful for class attributes, module-level variables, and complex types that might
                                        not be obvious.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-typing-variables.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-variables" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Type hints are not enforced at runtime! Python will
                                        still allow you to pass any type. Type hints are primarily for documentation and
                                        static type checking. Use type checkers like mypy to catch type errors before
                                        runtime!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Thinking type hints enforce types at runtime</h4>
                                        <pre><code class="language-python"># Wrong - type hints don't prevent runtime errors
def add(a: int, b: int) -> int:
    return a + b

# This still works - Python doesn't check types at runtime!
result = add("hello", "world")  # No error, returns "helloworld"
result = add([1, 2], [3, 4])    # No error, returns [1, 2, 3, 4]

# Type hints are for documentation and static type checkers only
# Use mypy or other tools to catch these before runtime!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using old typing.List syntax when not needed</h4>
                                        <pre><code class="language-python"># Old way (Python 3.8 and earlier)
from typing import List, Dict

def process(items: List[str]) -> Dict[str, int]:
    return {}

# Modern way (Python 3.9+)
def process(items: list[str]) -> dict[str, int]:
    return {}

# Or for Python 3.7+ with future import
from __future__ import annotations

def process(items: list[str]) -> dict[str, int]:
    return {}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting Optional for None-able values</h4>
                                        <pre><code class="language-python"># Wrong - suggests value can't be None
from typing import Optional

def find_user(name: str) -> dict:  # Type checker might complain
    if name not in database:
        return None  # Type error: returning None but hint says dict
    
    return {"name": name}

# Correct - use Optional
def find_user(name: str) -> Optional[dict]:
    if name not in database:
        return None  # OK - Optional allows None
    return {"name": name}</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Add Type Hints to a Function</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Write a function with comprehensive type hints that
                                            processes user data. The function should accept a list of user dictionaries and
                                            return statistics.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a function <code>get_user_stats(users)</code> that processes user
                                                data</li>
                                            <li>Parameter: list of dictionaries, each with <code>name</code> (str) and
                                                <code>age</code> (int)</li>
                                            <li>Return: dictionary with keys <code>total</code> (int), <code>avg_age</code>
                                                (float), and <code>names</code> (list of str)</li>
                                            <li>Use type hints for all parameters and return value</li>
                                            <li>Import necessary types from <code>typing</code> module</li>
                                            <li>Handle empty list case</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-adv-typing.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-adv-typing" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">from typing import List, Dict, Any

def get_user_stats(users: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Calculate statistics from a list of user dictionaries.
    
    Args:
        users: List of user dicts with 'name' (str) and 'age' (int)
    
    Returns:
        Dict with 'total' (int), 'avg_age' (float), 'names' (List[str])
    """
    if not users:
        return {"total": 0, "avg_age": 0.0, "names": []}
    
    total = len(users)
    ages = [user["age"] for user in users]
    avg_age = sum(ages) / len(ages)
    names = [user["name"] for user in users]
    
    return {
        "total": total,
        "avg_age": avg_age,
        "names": names
    }


# Test the function
users = [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 30},
    {"name": "Charlie", "age": 35}
]

stats = get_user_stats(users)
print(f"Total users: {stats['total']}")
print(f"Average age: {stats['avg_age']:.1f}")
print(f"Names: {', '.join(stats['names'])}")</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Type Hints:</strong> Annotations that document expected types without
                                                affecting runtime behavior</li>
                                            <li><strong>Function Annotations:</strong> Use <code>parameter: type</code> and
                                                <code>-&gt; return_type</code> syntax</li>
                                            <li><strong>Built-in Types:</strong> Use <code>int</code>, <code>str</code>,
                                                <code>list</code>, <code>dict</code> for simple types (Python 3.9+)</li>
                                            <li><strong>typing Module:</strong> Provides <code>List</code>, <code>Dict</code>,
                                                <code>Optional</code>, <code>Union</code> for complex types</li>
                                            <li><strong>Optional:</strong> <code>Optional[Type]</code> means <code>Type |
                                                None</code>, for values that can be None</li>
                                            <li><strong>Union:</strong> <code>Union[Type1, Type2]</code> or <code>Type1 |
                                                Type2</code> (Python 3.10+) for multiple possible types</li>
                                            <li><strong>Variable Annotations:</strong> Can annotate variables directly:
                                                <code>name: str = "value"</code></li>
                                            <li><strong>Static Checking:</strong> Use tools like mypy to validate type hints
                                                before runtime</li>
                                            <li><strong>Benefits:</strong> Better documentation, IDE support, easier
                                                refactoring, catch errors early</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Type hinting helps make your code more maintainable and self-documenting! You've now
                                        completed all the Advanced Topics modules. Continue exploring Python by diving deeper
                                        into specific libraries, frameworks, or advanced patterns. Consider learning about
                                        virtual environments, package management, async programming, or contributing to open
                                        source projects to further your Python journey!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="adv-regex.jsp" />
                                    <jsp:param name="prevTitle" value="Regular Expressions" />
                                    <jsp:param name="nextLink" value="prof-venv.jsp" />
                                    <jsp:param name="nextTitle" value="Virtual Envs" />
                                    <jsp:param name="currentLessonId" value="adv-typing" />
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