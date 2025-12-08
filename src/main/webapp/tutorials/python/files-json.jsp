<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-json");
   request.setAttribute("currentModule", "File Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python JSON - loads, dumps, load, dump, Custom Encoders | 8gwifi.org</title>
    <meta name="description"
        content="Master Python JSON handling - parse JSON with loads(), serialize with dumps(), work with files using load()/dump(), and handle custom types with encoders.">
    <meta name="keywords"
        content="python json, python json.loads, python json.dumps, python json.load, python json.dump, python JSONEncoder, python parse json">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python JSON - loads, dumps, load, dump, Custom Encoders">
    <meta property="og:description" content="Master Python JSON handling: parsing, serializing, files, and custom types.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/files-json.jsp">
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
        "name": "Python JSON Files",
        "description": "Master Python JSON handling - parse and serialize JSON data, work with files, and handle custom types.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["json.loads() and json.dumps()", "json.load() and json.dump()", "JSON to Python type mapping", "Pretty printing JSON", "Custom JSONEncoder", "JSON Lines format"],
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

<body class="tutorial-body no-preview" data-lesson="files-json">
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
                    <span>JSON Files</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">JSON Files</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">JSON (JavaScript Object Notation) is the lingua franca of data exchange on the web.
                    Every API speaks JSON, configuration files use it, and it's the go-to format for storing structured
                    data. Python's built-in <code>json</code> module makes it easy to parse JSON strings, serialize
                    Python objects, read/write JSON files, and even handle custom types like dates that JSON doesn't
                    natively support!</p>

                    <!-- Section 1: Parsing -->
                    <h2>Parsing JSON (loads)</h2>
                    <p>The <code>json.loads()</code> function parses a JSON string and returns the corresponding Python
                    object. JSON objects become Python dicts, arrays become lists, strings stay strings, numbers become
                    int or float, booleans become True/False, and null becomes None.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-load.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-load" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>JSON to Python Type Mapping:</strong><br>
                        <code>object {}</code> → <code>dict</code><br>
                        <code>array []</code> → <code>list</code><br>
                        <code>string</code> → <code>str</code><br>
                        <code>number (int)</code> → <code>int</code><br>
                        <code>number (float)</code> → <code>float</code><br>
                        <code>true/false</code> → <code>True/False</code><br>
                        <code>null</code> → <code>None</code>
                    </div>

                    <!-- Section 2: Serializing -->
                    <h2>Serializing to JSON (dumps)</h2>
                    <p>The <code>json.dumps()</code> function converts Python objects to JSON strings. Use
                    <code>indent</code> for pretty printing, <code>sort_keys</code> for consistent ordering, and
                    <code>ensure_ascii</code> to control Unicode handling.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-dump.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dump" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Remember the 's':</strong><br>
                        <code>loads()</code> and <code>dumps()</code> = work with <strong>s</strong>trings<br>
                        <code>load()</code> and <code>dump()</code> = work with <strong>files</strong><br>
                        The 's' stands for 'string'!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Files -->
                    <h2>Reading and Writing JSON Files</h2>
                    <p>For files, use <code>json.load()</code> (without 's') to read and <code>json.dump()</code> to
                    write. These work directly with file objects. The JSON Lines format (one JSON object per line) is
                    great for log files and streaming data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-files.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-files" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>JSON Lines (.jsonl) Format:</strong><br>
                        Each line is a valid JSON object. Great for:<br>
                        - Log files (append new entries)<br>
                        - Streaming data (process line by line)<br>
                        - Large datasets (no memory issues)<br>
                        - Data pipelines (easy to split/merge)
                    </div>

                    <!-- Section 4: Advanced -->
                    <h2>Custom Types and Encoders</h2>
                    <p>JSON only supports basic types. For datetime, Decimal, sets, or custom classes, you need a
                    custom encoder. Subclass <code>JSONEncoder</code> or use the <code>default</code> parameter. For
                    decoding custom types, use <code>object_hook</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-advanced.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-advanced" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Not JSON Serializable!</strong> These Python types will raise <code>TypeError</code>:<br>
                        - <code>datetime</code>, <code>date</code>, <code>time</code><br>
                        - <code>Decimal</code>, <code>complex</code><br>
                        - <code>set</code>, <code>frozenset</code><br>
                        - <code>bytes</code>, <code>bytearray</code><br>
                        - Custom class instances<br>
                        Use a custom encoder to handle these!
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing load/loads and dump/dumps</h4>
                        <pre><code class="language-python"># Wrong - using loads() with a file!
with open("data.json", "r") as f:
    data = json.loads(f)  # TypeError!

# Correct - use load() for files
with open("data.json", "r") as f:
    data = json.load(f)

# For strings, use loads()
json_string = '{"key": "value"}'
data = json.loads(json_string)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Single quotes in JSON</h4>
                        <pre><code class="language-python"># Wrong - JSON requires double quotes!
bad_json = "{'name': 'Alice'}"  # Single quotes!
data = json.loads(bad_json)  # JSONDecodeError!

# Correct - use double quotes
good_json = '{"name": "Alice"}'
data = json.loads(good_json)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Trailing commas</h4>
                        <pre><code class="language-python"># Wrong - JSON doesn't allow trailing commas!
bad_json = '{"a": 1, "b": 2,}'  # Trailing comma!
data = json.loads(bad_json)  # JSONDecodeError!

# Correct - no trailing comma
good_json = '{"a": 1, "b": 2}'
data = json.loads(good_json)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Trying to serialize non-JSON types</h4>
                        <pre><code class="language-python">from datetime import datetime

# Wrong - datetime is not serializable!
data = {"created": datetime.now()}
json.dumps(data)  # TypeError!

# Correct - convert to string first
data = {"created": datetime.now().isoformat()}
json.dumps(data)  # Works!

# Or use a custom encoder
class DateEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not handling JSON errors</h4>
                        <pre><code class="language-python"># Wrong - crashes on invalid JSON!
user_input = request.get_json()  # Could be invalid!
data = json.loads(user_input)

# Correct - handle errors
try:
    data = json.loads(user_input)
except json.JSONDecodeError as e:
    print(f"Invalid JSON: {e}")
    data = {}</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Configuration Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a configuration manager that loads, updates, and saves settings.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Load configuration from a JSON file (or use defaults if not exists)</li>
                            <li>Provide get and set methods for settings</li>
                            <li>Save changes back to the file</li>
                            <li>Use pretty printing for readability</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-files-json.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-json" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">import json
import os

class ConfigManager:
    """Simple configuration manager using JSON."""

    def __init__(self, filename, defaults=None):
        self.filename = filename
        self.config = defaults or {}
        self.load()

    def load(self):
        """Load config from file, keep defaults if not exists."""
        try:
            with open(self.filename, "r") as f:
                loaded = json.load(f)
                self.config.update(loaded)
        except FileNotFoundError:
            print(f"No config file, using defaults")
        except json.JSONDecodeError:
            print(f"Invalid JSON, using defaults")

    def save(self):
        """Save config to file with pretty printing."""
        with open(self.filename, "w") as f:
            json.dump(self.config, f, indent=2)
        print(f"Saved to {self.filename}")

    def get(self, key, default=None):
        """Get a config value."""
        return self.config.get(key, default)

    def set(self, key, value):
        """Set a config value."""
        self.config[key] = value

    def __repr__(self):
        return json.dumps(self.config, indent=2)


# Test it
defaults = {
    "app_name": "MyApp",
    "debug": False,
    "max_connections": 10
}

config = ConfigManager("settings.json", defaults)
print("Initial config:")
print(config)
print()

# Modify settings
config.set("debug", True)
config.set("theme", "dark")
config.save()

# Reload and verify
config2 = ConfigManager("settings.json")
print("\nReloaded config:")
print(config2)
print(f"Debug: {config2.get('debug')}")
print(f"Theme: {config2.get('theme')}")

# Cleanup
os.remove("settings.json")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Parse string:</strong> <code>data = json.loads(json_string)</code></li>
                            <li><strong>Serialize to string:</strong> <code>json_str = json.dumps(data)</code></li>
                            <li><strong>Read file:</strong> <code>data = json.load(file)</code></li>
                            <li><strong>Write file:</strong> <code>json.dump(data, file)</code></li>
                            <li><strong>Pretty print:</strong> <code>json.dumps(data, indent=2)</code></li>
                            <li><strong>Sort keys:</strong> <code>json.dumps(data, sort_keys=True)</code></li>
                            <li><strong>Unicode:</strong> <code>ensure_ascii=False</code> for non-ASCII chars</li>
                            <li><strong>Custom encoder:</strong> Subclass <code>JSONEncoder</code> or use <code>default=func</code></li>
                            <li><strong>Custom decoder:</strong> Use <code>object_hook=func</code></li>
                            <li><strong>Handle errors:</strong> Catch <code>JSONDecodeError</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the File Handling module! You've learned to read, write, and manage
                    files in Python. Next, we'll tackle <strong>Error Handling</strong> - how to gracefully handle
                    exceptions, create custom errors, and write robust code that doesn't crash unexpectedly!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-csv.jsp" />
                    <jsp:param name="prevTitle" value="CSV Files" />
                    <jsp:param name="nextLink" value="errors-basics.jsp" />
                    <jsp:param name="nextTitle" value="Exceptions" />
                    <jsp:param name="currentLessonId" value="files-json" />
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
