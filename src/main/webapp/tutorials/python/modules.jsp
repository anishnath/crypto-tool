<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "modules");
   request.setAttribute("currentModule", "Modules & Packages"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Modules - Import, Create, and Organize Code Libraries | 8gwifi.org</title>
    <meta name="description"
        content="Master Python modules - learn different import styles, create your own modules, understand packages, and use popular built-in modules like os, sys, random, and collections.">
    <meta name="keywords"
        content="python modules, python import, python from import, python import as, python packages, python __init__.py, python os module, python sys module, python collections">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Modules - Import, Create, and Organize Code Libraries">
    <meta property="og:description" content="Master Python modules: importing, creating, and organizing reusable code.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/modules.jsp">
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
        "name": "Python Modules",
        "description": "Master Python modules - learn different import styles, create your own modules, understand packages, and use popular built-in modules.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Import syntax variations", "Creating custom modules", "Package structure", "__init__.py", "Built-in modules", "Module aliases", "Namespace management"],
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

<body class="tutorial-body no-preview" data-lesson="modules">
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
                    <span>Modules</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Modules</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Modules are the building blocks of Python's code organization. A module is simply
                    a Python file containing functions, classes, and variables that you can reuse across projects.
                    Instead of writing everything from scratch, you can import existing code - whether it's Python's
                    powerful standard library or your own custom modules. This is how professional Python code stays
                    organized, maintainable, and DRY (Don't Repeat Yourself)!</p>

                    <!-- Section 1: Import Syntax -->
                    <h2>Different Ways to Import</h2>
                    <p>Python offers multiple import styles, each with its own use case. You can import entire
                    modules, specific items, or use aliases to avoid name conflicts. Understanding these patterns
                    helps you write cleaner code and manage namespaces effectively.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/modules-importing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-importing" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Import Best Practices:</strong> Prefer <code>import module</code> or
                        <code>from module import specific_item</code> over <code>from module import *</code>.
                        The wildcard import pollutes your namespace and makes it hard to track where names come from.
                        PEP 8 recommends putting imports at the top of your file, grouped in order: standard library,
                        third-party packages, then local modules.
                    </div>

                    <!-- Section 2: Creating Modules -->
                    <h2>Creating Your Own Modules</h2>
                    <p>Creating a module is as simple as writing a Python file! Any <code>.py</code> file can be
                    imported as a module. This lets you organize related functions and classes together, making
                    your code reusable and maintainable. The <code>if __name__ == "__main__"</code> pattern is
                    essential for writing modules that can both be imported and run directly.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/modules-creating.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-creating" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>The __name__ Pattern:</strong> When a file is run directly, <code>__name__</code>
                        equals <code>"__main__"</code>. When imported, it equals the module name. Use
                        <code>if __name__ == "__main__":</code> to include test code or a main entry point that
                        only runs when the file is executed directly, not when imported.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Packages -->
                    <h2>Packages: Organizing Multiple Modules</h2>
                    <p>As projects grow, you need to organize modules into packages - directories containing
                    multiple related modules. A package is simply a folder with an <code>__init__.py</code> file.
                    This hierarchical structure enables clean imports like <code>import mypackage.submodule</code>
                    and helps manage large codebases.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/modules-packages.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-packages" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Package Pitfalls:</strong> Don't name your modules the same as standard library
                        modules (e.g., don't create <code>random.py</code> or <code>math.py</code>). Python might
                        import your file instead of the built-in module, causing confusing errors. Also, ensure
                        your package directories are in Python's path (<code>sys.path</code>) or installed properly.
                    </div>

                    <!-- Section 4: Built-in Modules -->
                    <h2>Essential Built-in Modules</h2>
                    <p>Python's standard library is "batteries included" - it comes with powerful modules for
                    common tasks. The <code>os</code> module handles operating system interactions,
                    <code>sys</code> provides system-specific parameters, <code>random</code> generates random
                    numbers, and <code>collections</code> offers specialized container data types.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/modules-builtins.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-builtins" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Circular imports</h4>
                        <pre><code class="language-python"># module_a.py
from module_b import func_b  # Imports module_b
def func_a(): return func_b()

# module_b.py
from module_a import func_a  # Tries to import module_a - CIRCULAR!
def func_b(): return func_a()

# Fix: Restructure code, use lazy imports, or import inside functions
# module_b.py (fixed)
def func_b():
    from module_a import func_a  # Import inside function
    return func_a()</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Naming files same as standard library modules</h4>
                        <pre><code class="language-python"># BAD: You created a file called random.py
# random.py
def my_random():
    return 42

# other_file.py
import random  # This imports YOUR random.py, not the standard library!
print(random.randint(1, 10))  # AttributeError: no 'randint'

# Fix: Use unique names for your modules
# my_random.py or random_utils.py instead</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting __init__.py in packages (Python < 3.3)</h4>
                        <pre><code class="language-python"># Wrong structure (pre-Python 3.3)
# mypackage/
#     module1.py   # No __init__.py!

import mypackage.module1  # ImportError!

# Correct structure
# mypackage/
#     __init__.py  # Can be empty
#     module1.py

# Note: Python 3.3+ supports implicit namespace packages,
# but explicit __init__.py is still recommended</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using "from module import *" and losing track of names</h4>
                        <pre><code class="language-python"># Dangerous - where does 'open' come from?
from os import *
from pathlib import *

open("file.txt")  # Which 'open'? Built-in or os.open?

# Better - explicit imports
from os import getcwd, listdir
from pathlib import Path

# Or use the module prefix
import os
import pathlib
os.getcwd()
pathlib.Path(".")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not understanding module search path</h4>
                        <pre><code class="language-python"># Your project structure:
# project/
#     main.py
#     utils/
#         helpers.py

# In main.py - this might fail depending on how you run it
from utils.helpers import func  # Works if run from project/

# Running from different directory
# $ cd project/utils && python ../main.py
# ModuleNotFoundError!

# Fix: Use relative imports in packages, or add to sys.path
import sys
sys.path.insert(0, '/path/to/project')

# Or use -m flag: python -m main</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a Utility Module</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create functions that could be part of a utility module.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Write a function <code>is_even(n)</code> that returns True if n is even</li>
                            <li>Write a function <code>clamp(value, min_val, max_val)</code> that constrains a value within bounds</li>
                            <li>Write a function <code>flatten(nested_list)</code> that flattens a nested list one level</li>
                            <li>Include docstrings for each function</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-modules-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-modules" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># my_utils.py - A utility module

def is_even(n):
    """Return True if n is even, False otherwise."""
    return n % 2 == 0

def clamp(value, min_val, max_val):
    """Constrain value to be within [min_val, max_val]."""
    return max(min_val, min(value, max_val))

def flatten(nested_list):
    """Flatten a nested list by one level."""
    result = []
    for item in nested_list:
        if isinstance(item, list):
            result.extend(item)
        else:
            result.append(item)
    return result

# Test the functions
if __name__ == "__main__":
    print(f"is_even(4): {is_even(4)}")
    print(f"is_even(7): {is_even(7)}")
    print(f"clamp(15, 0, 10): {clamp(15, 0, 10)}")
    print(f"clamp(-5, 0, 10): {clamp(-5, 0, 10)}")
    print(f"flatten([[1, 2], [3, 4], 5]): {flatten([[1, 2], [3, 4], 5])}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Module:</strong> A Python file (<code>.py</code>) containing reusable code</li>
                            <li><strong>Import styles:</strong> <code>import module</code>, <code>from module import item</code>, <code>import module as alias</code></li>
                            <li><strong>Creating modules:</strong> Just write a <code>.py</code> file with functions, classes, variables</li>
                            <li><strong>__name__ pattern:</strong> <code>if __name__ == "__main__":</code> for code that runs only when executed directly</li>
                            <li><strong>Package:</strong> A directory with <code>__init__.py</code> containing related modules</li>
                            <li><strong>Standard library:</strong> <code>os</code>, <code>sys</code>, <code>random</code>, <code>collections</code>, <code>itertools</code>, and many more</li>
                            <li><strong>Avoid:</strong> Circular imports, naming conflicts with stdlib, wildcard imports</li>
                            <li><strong>Best practice:</strong> Group imports at file top: stdlib, third-party, local</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand how modules work, let's explore some of Python's most useful
                    built-in modules! Next up: the <strong>datetime</strong> module for working with dates and
                    times - essential for any application dealing with scheduling, timestamps, or time calculations.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="functions-recursion.jsp" />
                    <jsp:param name="prevTitle" value="Recursion" />
                    <jsp:param name="nextLink" value="modules-dates.jsp" />
                    <jsp:param name="nextTitle" value="Dates" />
                    <jsp:param name="currentLessonId" value="modules" />
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
