<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "prof-testing" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Unit Testing - unittest Module, TestCase & Assertions | 8gwifi.org</title>
            <meta name="description"
                content="Master Python unit testing with the unittest module. Learn to write test cases, use assertions, test exceptions, organize test suites, and follow testing best practices.">
            <meta name="keywords"
                content="python unittest, python testing, unittest module, test case, test assertions, python pytest, unit testing best practices">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Unit Testing - unittest Module, TestCase & Assertions">
            <meta property="og:description"
                content="Master Python unit testing with the unittest module. Learn to write test cases, use assertions, and test exceptions with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/prof-testing.jsp">
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
        "name": "Python Unit Testing",
        "description": "Master Python unit testing with the unittest module. Learn to write test cases, use assertions, and test exceptions.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["unittest module", "TestCase class", "Test assertions", "Testing exceptions", "setUp and tearDown", "Test organization", "Running tests", "Test coverage"],
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

        <body class="tutorial-body no-preview" data-lesson="prof-testing">
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
                                    <span>Professional Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Unit Testing</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Unit testing is essential for writing reliable, maintainable code.
                                        Python's built-in <code>unittest</code> module provides a comprehensive testing
                                        framework inspired by JUnit. Learn to write test cases, use assertions, test
                                        exceptions, and organize your tests effectively. Good tests catch bugs early and
                                        give confidence when refactoring!</p>

                                    <h2>Basic Test Structure</h2>
                                    <p>The <code>unittest</code> module provides the <code>TestCase</code> class that you
                                        inherit from. Test methods must start with <code>test_</code> to be automatically
                                        discovered. Use assertion methods like <code>assertEqual</code>,
                                        <code>assertTrue</code>, and <code>assertRaises</code> to verify expected
                                        behavior.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-testing-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Test Method Naming:</strong><br>
                                        - Methods starting with <code>test_</code> are automatically discovered and run<br>
                                        - Use descriptive names: <code>test_add_positive_numbers</code>,
                                        <code>test_divide_by_zero_raises_error</code><br>
                                        - One test method should test one specific behavior<br>
                                        - Keep tests simple and focused
                                    </div>

                                    <h2>Common Assertions</h2>
                                    <p>The <code>TestCase</code> class provides many assertion methods to verify expected
                                        behavior. Use the most specific assertion that fits your test case for clearer
                                        error messages.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-testing-assertions.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-assertions" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use specific assertions like <code>assertEqual</code>
                                        instead of <code>assertTrue(x == y)</code>. Specific assertions provide better
                                        error messages showing the expected and actual values when tests fail!
                                    </div>

                                    <h2>Testing Exceptions</h2>
                                    <p>Use <code>assertRaises</code> to verify that functions raise expected exceptions
                                        under certain conditions. This ensures your error handling works correctly.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-testing-exceptions.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-exceptions" />
                                    </jsp:include>

                                    <h2>setUp and tearDown</h2>
                                    <p>The <code>setUp</code> method runs before each test method, and
                                        <code>tearDown</code> runs after. Use them to initialize test fixtures (common
                                        test data) and clean up resources. This keeps test methods focused on testing
                                        logic rather than setup code.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-testing-setup.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-setup" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Tests should be independent - each test should be able
                                        to run alone and in any order. Don't rely on test execution order or shared state
                                        between tests. Use <code>setUp</code> to create fresh test data for each test!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting 'test_' prefix on test methods</h4>
                                        <pre><code class="language-python"># Wrong - won't be discovered by unittest
class TestMath(unittest.TestCase):
    def check_add(self):  # No 'test_' prefix!
        self.assertEqual(add(2, 3), 5)

# Correct - method starts with 'test_'
class TestMath(unittest.TestCase):
    def test_add(self):  # Correct prefix
        self.assertEqual(add(2, 3), 5)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Testing multiple things in one test</h4>
                                        <pre><code class="language-python"># Wrong - multiple assertions for different behaviors
def test_math_operations(self):
    self.assertEqual(add(2, 3), 5)
    self.assertEqual(subtract(5, 2), 3)
    self.assertEqual(multiply(4, 3), 12)
    # If first fails, you don't know if others work

# Correct - one test per behavior
def test_add(self):
    self.assertEqual(add(2, 3), 5)

def test_subtract(self):
    self.assertEqual(subtract(5, 2), 3)

def test_multiply(self):
    self.assertEqual(multiply(4, 3), 12)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not testing edge cases and error conditions</h4>
                                        <pre><code class="language-python"># Wrong - only testing happy path
def test_divide(self):
    self.assertEqual(divide(10, 2), 5)

# Correct - test normal case AND edge cases
def test_divide_normal(self):
    self.assertEqual(divide(10, 2), 5)

def test_divide_by_zero(self):
    with self.assertRaises(ValueError):
        divide(10, 0)

def test_divide_negative(self):
    self.assertEqual(divide(-10, 2), -5)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Tests that depend on execution order</h4>
                                        <pre><code class="language-python"># Wrong - tests depend on each other
class TestCounter(unittest.TestCase):
    counter = 0  # Class variable - shared state!
    
    def test_increment_first(self):
        TestCounter.counter += 1
        self.assertEqual(TestCounter.counter, 1)
    
    def test_increment_second(self):
        TestCounter.counter += 1
        self.assertEqual(TestCounter.counter, 2)  # Fails if run alone!

# Correct - each test is independent
class TestCounter(unittest.TestCase):
    def setUp(self):
        self.counter = 0  # Fresh instance variable per test
    
    def test_increment(self):
        self.counter += 1
        self.assertEqual(self.counter, 1)</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Write Comprehensive Tests</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Write a complete test suite for a <code>Calculator</code>
                                            class that has methods for basic math operations. Test both normal cases and
                                            edge cases.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a <code>TestCalculator</code> class inheriting from
                                                <code>unittest.TestCase</code></li>
                                            <li>Use <code>setUp</code> to create a Calculator instance</li>
                                            <li>Test <code>add</code> method: positive numbers, negative numbers, zero</li>
                                            <li>Test <code>divide</code> method: normal division and division by zero
                                                (should raise ValueError)</li>
                                            <li>Test <code>multiply</code> method: normal case, with zero, negative
                                                numbers</li>
                                            <li>Run the tests and verify they all pass</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-prof-testing.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-prof-testing" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">import unittest

class Calculator:
    def add(self, a, b):
        return a + b
    
    def subtract(self, a, b):
        return a - b
    
    def multiply(self, a, b):
        return a * b
    
    def divide(self, a, b):
        if b == 0:
            raise ValueError("Cannot divide by zero")
        return a / b


class TestCalculator(unittest.TestCase):
    def setUp(self):
        """Set up test fixtures before each test method."""
        self.calc = Calculator()
    
    def test_add_positive(self):
        self.assertEqual(self.calc.add(2, 3), 5)
    
    def test_add_negative(self):
        self.assertEqual(self.calc.add(-2, -3), -5)
    
    def test_add_zero(self):
        self.assertEqual(self.calc.add(5, 0), 5)
    
    def test_divide_normal(self):
        self.assertEqual(self.calc.divide(10, 2), 5.0)
    
    def test_divide_by_zero(self):
        with self.assertRaises(ValueError):
            self.calc.divide(10, 0)
    
    def test_multiply_normal(self):
        self.assertEqual(self.calc.multiply(3, 4), 12)
    
    def test_multiply_with_zero(self):
        self.assertEqual(self.calc.multiply(5, 0), 0)
    
    def test_multiply_negative(self):
        self.assertEqual(self.calc.multiply(-2, 3), -6)


if __name__ == '__main__':
    unittest.main()</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>unittest Module:</strong> Python's built-in testing framework,
                                                inspired by JUnit</li>
                                            <li><strong>TestCase:</strong> Inherit from <code>unittest.TestCase</code> to
                                                create test classes</li>
                                            <li><strong>Test Methods:</strong> Methods starting with <code>test_</code> are
                                                automatically discovered and run</li>
                                            <li><strong>Assertions:</strong> Use <code>assertEqual</code>,
                                                <code>assertTrue</code>, <code>assertRaises</code>, etc. for
                                                verification</li>
                                            <li><strong>setUp/tearDown:</strong> Run before/after each test method for
                                                fixture setup and cleanup</li>
                                            <li><strong>Testing Exceptions:</strong> Use <code>assertRaises</code> to verify
                                                functions raise expected exceptions</li>
                                            <li><strong>Test Independence:</strong> Tests should be independent and
                                                runnable in any order</li>
                                            <li><strong>Best Practices:</strong> One test per behavior, test edge cases,
                                                use descriptive names, keep tests simple</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Unit testing ensures your code works correctly! Next, we'll explore
                                        <strong>logging</strong>, which helps you track application behavior and debug
                                        issues in production. The <code>logging</code> module is much more powerful than
                                        <code>print()</code> statements and is essential for professional Python
                                        applications!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="prof-venv.jsp" />
                                    <jsp:param name="prevTitle" value="Virtual Envs" />
                                    <jsp:param name="nextLink" value="prof-logging.jsp" />
                                    <jsp:param name="nextTitle" value="Logging" />
                                    <jsp:param name="currentLessonId" value="prof-testing" />
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