<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "errors-raise");
   request.setAttribute("currentModule", "Error Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Raise - Custom Exceptions, Re-raising, Exception Chaining | 8gwifi.org</title>
    <meta name="description"
        content="Master Python raise statement. Learn to raise exceptions, create custom exception classes, re-raise exceptions, and use exception chaining with 'from' for better error handling.">
    <meta name="keywords"
        content="python raise, python custom exception, python raise from, python exception chaining, python reraise, python throw error">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Raise - Custom Exceptions, Re-raising, Exception Chaining">
    <meta property="og:description" content="Master Python raise: create custom exceptions, re-raise errors, and use exception chaining for robust error handling.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/errors-raise.jsp">
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
        "name": "Python Raising Exceptions",
        "description": "Master Python raise statement. Learn to raise exceptions, create custom exception classes, re-raise exceptions, and use exception chaining.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Raise statement basics", "Validation with raise", "Re-raising exceptions", "Custom exception classes", "Exception hierarchy", "Exception chaining", "raise from syntax", "Error wrapping patterns"],
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

<body class="tutorial-body no-preview" data-lesson="errors-raise">
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
                    <span>Raising Exceptions</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Raising Exceptions</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Sometimes you need to signal an error yourself - when validation fails, when
                    preconditions aren't met, or when something unexpected happens. The <code>raise</code> statement
                    lets you throw exceptions, create custom exception types for your application, and chain
                    exceptions to preserve error context!</p>

                    <!-- Section 1: Basic Raise -->
                    <h2>Basic Raise Statement</h2>
                    <p>Use <code>raise ExceptionType("message")</code> to throw an exception. Choose the appropriate
                    built-in exception type - <code>ValueError</code> for invalid values, <code>TypeError</code> for
                    wrong types, <code>KeyError</code> for missing keys. Always include a descriptive message.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/raise-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>When to Raise Which Exception:</strong><br>
                        <code>ValueError</code> - Right type, wrong value: <code>raise ValueError("age must be positive")</code><br>
                        <code>TypeError</code> - Wrong type: <code>raise TypeError("expected string")</code><br>
                        <code>KeyError</code> - Missing key: <code>raise KeyError("config missing 'host'")</code><br>
                        <code>RuntimeError</code> - General runtime issue: <code>raise RuntimeError("state corrupted")</code><br>
                        <code>NotImplementedError</code> - Subclass must override: <code>raise NotImplementedError</code>
                    </div>

                    <!-- Section 2: Re-raising -->
                    <h2>Re-raising Exceptions</h2>
                    <p>Sometimes you want to catch an exception, do something (like logging), and then let it
                    propagate. Use bare <code>raise</code> (without arguments) to re-raise the current exception.
                    This preserves the original traceback, which is crucial for debugging.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/raise-reraise.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-reraise" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Re-raise Best Practices:</strong><br>
                        <code>raise</code> - Bare raise preserves original traceback<br>
                        <code>raise ValueError(...)</code> - Creates NEW exception, loses original traceback<br><br>
                        Use bare <code>raise</code> when you want to log and continue propagating.
                        Use <code>raise NewException() from original</code> when converting exception types.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Custom Exceptions -->
                    <h2>Custom Exception Classes</h2>
                    <p>Create custom exceptions by inheriting from <code>Exception</code>. This lets you add
                    attributes, create exception hierarchies, and provide domain-specific error handling.
                    Always inherit from <code>Exception</code>, not <code>BaseException</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/raise-custom.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-custom" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Custom Exception Guidelines:</strong><br>
                        - Always inherit from <code>Exception</code> (not <code>BaseException</code>)<br>
                        - Call <code>super().__init__(message)</code> in your __init__<br>
                        - Add useful attributes (error codes, field names, etc.)<br>
                        - Create a base exception for your app: <code>class MyAppError(Exception)</code><br>
                        - Specific exceptions inherit from base: <code>class AuthError(MyAppError)</code>
                    </div>

                    <!-- Section 4: Exception Chaining -->
                    <h2>Exception Chaining</h2>
                    <p>Exception chaining preserves the original error when wrapping it in a new exception.
                    Use <code>raise NewException() from original</code> to explicitly chain. Use
                    <code>raise NewException() from None</code> to suppress the chain (hide internal details).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/raise-chaining.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-chaining" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Chaining Summary:</strong><br>
                        <code>raise X from Y</code> - Explicit: "Y caused X" (<code>__cause__</code>)<br>
                        <code>raise X</code> (during handling) - Implicit: "X happened while handling Y" (<code>__context__</code>)<br>
                        <code>raise X from None</code> - Suppress chain (hide internal errors)<br><br>
                        Use explicit chaining when converting internal errors to public API errors.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Raising wrong exception type</h4>
                        <pre><code class="language-python"># Wrong - RuntimeError for validation
def set_age(age):
    if age < 0:
        raise RuntimeError("Age cannot be negative")  # Wrong type

# Correct - ValueError for invalid values
def set_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative")  # Right type

# Wrong - using Exception (too generic)
raise Exception("Something went wrong")

# Correct - specific exception
raise ConnectionError("Failed to connect to database")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Losing traceback when re-raising</h4>
                        <pre><code class="language-python"># Wrong - creates new exception, loses traceback!
try:
    process_data()
except ValueError as e:
    log_error(e)
    raise ValueError(str(e))  # NEW exception, lost traceback!

# Correct - bare raise preserves traceback
try:
    process_data()
except ValueError:
    log_error("Processing failed")
    raise  # Same exception, same traceback

# Also correct - explicit chaining preserves cause
try:
    process_data()
except ValueError as e:
    raise ProcessingError("Failed to process") from e</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to chain exceptions</h4>
                        <pre><code class="language-python"># Wrong - original error lost
def get_config():
    try:
        return json.load(open("config.json"))
    except (FileNotFoundError, json.JSONDecodeError):
        raise ConfigError("Bad config")  # What was the original error?

# Correct - chain with 'from'
def get_config():
    try:
        return json.load(open("config.json"))
    except (FileNotFoundError, json.JSONDecodeError) as e:
        raise ConfigError("Bad config") from e  # Original preserved!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Inheriting from BaseException</h4>
                        <pre><code class="language-python"># Wrong - BaseException isn't caught by 'except Exception'
class MyError(BaseException):  # Wrong!
    pass

try:
    raise MyError("oops")
except Exception:
    print("Not caught!")  # MyError escapes!

# Correct - inherit from Exception
class MyError(Exception):  # Correct!
    pass

try:
    raise MyError("oops")
except Exception:
    print("Caught!")  # Works!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not calling super().__init__ in custom exception</h4>
                        <pre><code class="language-python"># Wrong - forgets super().__init__
class APIError(Exception):
    def __init__(self, code, message):
        self.code = code
        self.message = message
        # Forgot super().__init__!

err = APIError(404, "Not found")
print(str(err))  # Empty string!

# Correct - call super().__init__
class APIError(Exception):
    def __init__(self, code, message):
        super().__init__(f"[{code}] {message}")
        self.code = code
        self.message = message

err = APIError(404, "Not found")
print(str(err))  # "[404] Not found"</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Validation Library</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a validation library with custom exceptions.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a base <code>ValidationError</code> exception</li>
                            <li>Create specific exceptions: <code>RequiredFieldError</code>, <code>TypeValidationError</code>, <code>RangeError</code></li>
                            <li>Write a <code>validate_user()</code> function that validates user data</li>
                            <li>Chain exceptions properly to preserve context</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-errors-raise.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-raise" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Custom exceptions
class ValidationError(Exception):
    """Base validation error."""
    pass

class RequiredFieldError(ValidationError):
    """Field is required but missing."""
    def __init__(self, field):
        super().__init__(f"Field '{field}' is required")
        self.field = field

class TypeValidationError(ValidationError):
    """Field has wrong type."""
    def __init__(self, field, expected, got):
        super().__init__(f"Field '{field}' expected {expected}, got {got}")
        self.field = field
        self.expected = expected
        self.got = got

class RangeError(ValidationError):
    """Value out of allowed range."""
    def __init__(self, field, value, min_val=None, max_val=None):
        if min_val is not None and max_val is not None:
            msg = f"Field '{field}' value {value} not in range [{min_val}, {max_val}]"
        elif min_val is not None:
            msg = f"Field '{field}' value {value} must be >= {min_val}"
        else:
            msg = f"Field '{field}' value {value} must be <= {max_val}"
        super().__init__(msg)
        self.field = field
        self.value = value


def validate_user(data):
    """Validate user data dictionary."""
    # Check required fields
    for field in ['username', 'email', 'age']:
        if field not in data or data[field] is None:
            raise RequiredFieldError(field)

    # Validate types
    if not isinstance(data['username'], str):
        raise TypeValidationError('username', 'str', type(data['username']).__name__)

    if not isinstance(data['email'], str):
        raise TypeValidationError('email', 'str', type(data['email']).__name__)

    if not isinstance(data['age'], int):
        raise TypeValidationError('age', 'int', type(data['age']).__name__)

    # Validate ranges
    if len(data['username']) < 3:
        raise RangeError('username length', len(data['username']), min_val=3)

    if data['age'] < 0 or data['age'] > 150:
        raise RangeError('age', data['age'], min_val=0, max_val=150)

    if '@' not in data['email']:
        raise ValidationError("Email must contain '@'")

    return True


# Test the validation
test_users = [
    {},
    {'username': 'ab', 'email': 'test@mail.com', 'age': 25},
    {'username': 'alice', 'email': 'noatsign', 'age': 25},
    {'username': 'bob', 'email': 'bob@mail.com', 'age': -5},
    {'username': 'charlie', 'email': 'charlie@mail.com', 'age': 30},
]

print("=== User Validation Tests ===\n")
for user in test_users:
    try:
        validate_user(user)
        print(f"Valid: {user}")
    except ValidationError as e:
        print(f"Invalid: {type(e).__name__}: {e}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>raise:</strong> <code>raise ValueError("message")</code> throws an exception</li>
                            <li><strong>Choose right type:</strong> ValueError for bad values, TypeError for wrong types</li>
                            <li><strong>Bare raise:</strong> <code>raise</code> re-raises current exception with traceback</li>
                            <li><strong>Custom exceptions:</strong> Inherit from <code>Exception</code>, call <code>super().__init__()</code></li>
                            <li><strong>Exception hierarchy:</strong> Create base exception, specific ones inherit from it</li>
                            <li><strong>raise from:</strong> <code>raise X from Y</code> chains exceptions (Y caused X)</li>
                            <li><strong>from None:</strong> <code>raise X from None</code> suppresses chain</li>
                            <li><strong>Add attributes:</strong> Custom exceptions can have extra data (code, field, etc.)</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now you can both catch and raise exceptions. But sometimes you just want to check
                    that something is true during development - not handle it as an error, but catch bugs
                    early. Next, we'll learn about <code>assert</code> statements for debugging and
                    development-time checks!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="errors-finally.jsp" />
                    <jsp:param name="prevTitle" value="Finally & Else" />
                    <jsp:param name="nextLink" value="errors-assert.jsp" />
                    <jsp:param name="nextTitle" value="Assertions" />
                    <jsp:param name="currentLessonId" value="errors-raise" />
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
