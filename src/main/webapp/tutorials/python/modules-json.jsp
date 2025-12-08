<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "modules-json");
   request.setAttribute("currentModule", "Modules & Packages"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python JSON Module - Parse, Encode, Read/Write JSON Files | 8gwifi.org</title>
    <meta name="description"
        content="Master Python json module - parse JSON strings with loads(), encode Python to JSON with dumps(), read/write JSON files, and format JSON output with pretty printing.">
    <meta name="keywords"
        content="python json, python json loads, python json dumps, python json load, python json dump, python parse json, python json pretty print, python json file">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python JSON Module - Parse, Encode, Read/Write JSON Files">
    <meta property="og:description" content="Master Python json: parsing, encoding, and working with JSON files.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/modules-json.jsp">
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
        "name": "Python JSON Module",
        "description": "Master Python json module - parse JSON strings, encode Python objects, read/write JSON files, and format output.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["JSON parsing with loads()", "JSON encoding with dumps()", "Reading JSON files", "Writing JSON files", "Pretty printing", "Type conversions", "Custom encoders"],
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

<body class="tutorial-body no-preview" data-lesson="modules-json">
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
                    <span>JSON</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">JSON Module</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">JSON (JavaScript Object Notation) is the universal language of data exchange on the
                    web. APIs return JSON, configuration files use JSON, and databases store JSON. Python's built-in
                    <code>json</code> module makes it easy to parse JSON strings into Python dictionaries, convert
                    Python objects to JSON, and read/write JSON files. If you're building web applications, working
                    with APIs, or handling configuration data - JSON mastery is essential!</p>

                    <!-- Section 1: Parsing JSON -->
                    <h2>Parsing JSON (String to Python)</h2>
                    <p>Use <code>json.loads()</code> ("load string") to parse a JSON string into a Python object.
                    JSON objects become Python dictionaries, arrays become lists, and JSON's <code>true</code>,
                    <code>false</code>, and <code>null</code> become Python's <code>True</code>, <code>False</code>,
                    and <code>None</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-parsing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-parsing" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>JSON Type Mapping:</strong><br>
                        JSON object <code>{}</code> → Python <code>dict</code><br>
                        JSON array <code>[]</code> → Python <code>list</code><br>
                        JSON string → Python <code>str</code><br>
                        JSON number → Python <code>int</code> or <code>float</code><br>
                        JSON <code>true/false</code> → Python <code>True/False</code><br>
                        JSON <code>null</code> → Python <code>None</code>
                    </div>

                    <!-- Section 2: Encoding JSON -->
                    <h2>Converting Python to JSON</h2>
                    <p>Use <code>json.dumps()</code> ("dump string") to convert Python objects to a JSON string.
                    Most Python types convert naturally: dictionaries become objects, lists/tuples become arrays,
                    and booleans/None convert to their JSON equivalents. Some types (like sets and datetime) require
                    custom handling.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-encoding.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-encoding" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Remember the 's' suffix:</strong> <code>loads()</code> and <code>dumps()</code>
                        work with <strong>strings</strong> (the 's' stands for string). <code>load()</code> and
                        <code>dump()</code> (without 's') work with <strong>files</strong>. This naming convention
                        helps you remember which function to use!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: JSON Files -->
                    <h2>Reading and Writing JSON Files</h2>
                    <p>Use <code>json.load()</code> to read JSON from a file and <code>json.dump()</code> to write
                    JSON to a file. These work directly with file objects, making it easy to persist data or
                    read configuration files. Always use the <code>with</code> statement to ensure proper file handling.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-files.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-files" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>JSON File Safety:</strong> Always validate JSON from untrusted sources. While
                        <code>json.loads()</code> is safer than <code>eval()</code>, malformed JSON can still
                        cause errors. Wrap parsing in try/except blocks:
                        <code>try: data = json.loads(text) except json.JSONDecodeError: handle_error()</code>
                    </div>

                    <!-- Section 4: Formatting -->
                    <h2>Formatting and Pretty Printing</h2>
                    <p>By default, <code>json.dumps()</code> produces compact output. For human-readable output, use
                    <code>indent</code> for pretty printing and <code>sort_keys</code> for consistent key ordering.
                    These options are invaluable for debugging, logging, and configuration files.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/json-formatting.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-formatting" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing loads/dumps with load/dump</h4>
                        <pre><code class="language-python">import json

# Wrong - loads expects a string, not a file!
with open("data.json") as f:
    data = json.loads(f)  # TypeError!

# Correct - use load (no 's') for files
with open("data.json") as f:
    data = json.load(f)

# Wrong - dumps returns a string, doesn't write to file
with open("out.json", "w") as f:
    json.dumps(data, f)  # Just returns string, ignores f!

# Correct - use dump (no 's') for files
with open("out.json", "w") as f:
    json.dump(data, f)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using single quotes in JSON strings</h4>
                        <pre><code class="language-python">import json

# Wrong - JSON requires double quotes!
bad_json = "{'name': 'Alice'}"
data = json.loads(bad_json)  # JSONDecodeError!

# Correct - use double quotes
good_json = '{"name": "Alice"}'
data = json.loads(good_json)  # Works!

# Tip: Use triple quotes for multiline JSON
json_str = """
{
    "name": "Alice",
    "age": 30
}
"""</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Trying to serialize non-JSON types</h4>
                        <pre><code class="language-python">import json
from datetime import datetime

# Wrong - sets and datetime aren't JSON serializable!
data = {
    "tags": {"python", "json"},  # set
    "created": datetime.now()     # datetime
}
json.dumps(data)  # TypeError!

# Fix 1: Convert to serializable types
data = {
    "tags": list({"python", "json"}),
    "created": datetime.now().isoformat()
}

# Fix 2: Use custom encoder
def custom_encoder(obj):
    if isinstance(obj, set):
        return list(obj)
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError(f"Not serializable: {type(obj)}")

json.dumps(data, default=custom_encoder)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not handling JSONDecodeError</h4>
                        <pre><code class="language-python">import json

# Wrong - crashes on invalid JSON
user_input = "not valid json"
data = json.loads(user_input)  # JSONDecodeError!

# Correct - handle the error
try:
    data = json.loads(user_input)
except json.JSONDecodeError as e:
    print(f"Invalid JSON: {e}")
    data = {}  # Default value</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Forgetting to specify encoding for non-ASCII</h4>
                        <pre><code class="language-python">import json

# Unicode characters
data = {"name": "Caf\u00e9", "city": "Z\u00fcrich"}

# Default - escapes non-ASCII (safe but ugly)
print(json.dumps(data))
# {"name": "Caf\u00e9", "city": "Z\u00fcrich"}

# Better for readability - preserve unicode
print(json.dumps(data, ensure_ascii=False))
# {"name": "Caf", "city": "Zrich"}

# When writing files - specify encoding!
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Configuration Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create functions to manage application configuration stored as JSON.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a function to load config from a JSON string</li>
                            <li>Create a function to get a config value with a default</li>
                            <li>Create a function to update config and return the JSON string</li>
                            <li>Handle missing keys gracefully</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-modules-json.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-json" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">import json

def load_config(json_string):
    """Load configuration from JSON string."""
    try:
        return json.loads(json_string)
    except json.JSONDecodeError:
        return {}

def get_config_value(config, key, default=None):
    """Get a configuration value with optional default."""
    return config.get(key, default)

def update_config(config, key, value):
    """Update config and return as formatted JSON string."""
    config[key] = value
    return json.dumps(config, indent=2)

# Test the functions
config_json = '{"theme": "dark", "font_size": 14}'

# Load
config = load_config(config_json)
print(f"Loaded: {config}")

# Get values
theme = get_config_value(config, "theme", "light")
language = get_config_value(config, "language", "en")
print(f"Theme: {theme}")
print(f"Language: {language}")

# Update
new_json = update_config(config, "notifications", True)
print(f"Updated config:\n{new_json}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Parse string:</strong> <code>json.loads(json_string)</code> - JSON string to Python</li>
                            <li><strong>Encode to string:</strong> <code>json.dumps(python_obj)</code> - Python to JSON string</li>
                            <li><strong>Read file:</strong> <code>json.load(file_object)</code> - file to Python</li>
                            <li><strong>Write file:</strong> <code>json.dump(python_obj, file_object)</code> - Python to file</li>
                            <li><strong>Pretty print:</strong> <code>json.dumps(data, indent=2)</code></li>
                            <li><strong>Sort keys:</strong> <code>json.dumps(data, sort_keys=True)</code></li>
                            <li><strong>Custom types:</strong> <code>json.dumps(data, default=encoder_func)</code></li>
                            <li><strong>Error handling:</strong> Catch <code>json.JSONDecodeError</code> for invalid JSON</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can work with JSON data, let's learn about <strong>Regular Expressions (RegEx)</strong>
                    - the powerful pattern matching language for searching, validating, and manipulating text. RegEx
                    is essential for data validation, text processing, and parsing complex string patterns!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="modules-math.jsp" />
                    <jsp:param name="prevTitle" value="Math" />
                    <jsp:param name="nextLink" value="modules-regex.jsp" />
                    <jsp:param name="nextTitle" value="RegEx" />
                    <jsp:param name="currentLessonId" value="modules-json" />
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
