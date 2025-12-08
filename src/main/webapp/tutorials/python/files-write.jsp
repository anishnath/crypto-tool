<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-write");
   request.setAttribute("currentModule", "File Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Writing Files - write(), writelines(), Append & Binary Modes | 8gwifi.org</title>
    <meta name="description"
        content="Master Python file writing - use write() and writelines() methods, understand write vs append modes, write binary data, and format output for files.">
    <meta name="keywords"
        content="python write file, python append file, python writelines, python write mode, python binary write, python file output, python create file">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Writing Files - write(), writelines(), Append & Binary Modes">
    <meta property="og:description" content="Master Python file writing: write methods, modes, binary data, and formatted output.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/files-write.jsp">
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
        "name": "Python Writing Files",
        "description": "Master Python file writing - use write() and writelines() methods, understand write vs append modes, and write binary data.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Write mode vs Append mode", "write() method", "writelines() method", "Binary file writing", "Formatted file output", "File creation modes"],
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

<body class="tutorial-body no-preview" data-lesson="files-write">
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
                    <span>Writing Files</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Writing Files</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Creating and writing files is essential for saving program output, generating reports,
                    logging events, and persisting data. Python provides intuitive methods for writing text and binary
                    files. Understanding the difference between write mode (<code>'w'</code>) which overwrites and append
                    mode (<code>'a'</code>) which adds to existing content is crucial - choosing wrong can destroy your data!</p>

                    <!-- Section 1: Write Modes -->
                    <h2>Write Modes</h2>
                    <p>The mode parameter in <code>open()</code> determines how files are created and written. Write mode
                    (<code>'w'</code>) creates a new file or <strong>completely overwrites</strong> an existing one - all
                    previous content is lost! Append mode (<code>'a'</code>) is safer when you want to add to existing
                    content. Exclusive create mode (<code>'x'</code>) prevents accidental overwrites.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/write-modes.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-modes" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Danger Zone!</strong> Write mode (<code>'w'</code>) <strong>destroys existing content</strong>
                        without warning! If you open an important file in write mode, all its data is gone the moment you
                        call <code>open()</code> - even before you write anything. Always double-check your mode when
                        working with existing files.
                    </div>

                    <!-- Section 2: Write Methods -->
                    <h2>Write Methods</h2>
                    <p>Python provides two main methods for writing: <code>write()</code> writes a single string and returns
                    the number of characters written, while <code>writelines()</code> writes a list of strings. Important:
                    neither method adds newlines automatically - you must include <code>\n</code> yourself!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/write-methods.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-methods" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>write() vs writelines():</strong><br>
                        <code>write(string)</code> - Writes one string, returns character count<br>
                        <code>writelines(list)</code> - Writes list of strings, returns None<br>
                        Neither adds newlines! You must include <code>\n</code> in your strings.<br>
                        For large data, <code>writelines()</code> with a generator is memory-efficient.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Binary Writing -->
                    <h2>Writing Binary Files</h2>
                    <p>Binary mode (<code>'wb'</code>) writes raw bytes instead of text. This is essential for images,
                    audio, compressed files, and any non-text data. You must write <code>bytes</code> or <code>bytearray</code>
                    objects, not strings. Use <code>encode()</code> to convert strings to bytes, or the <code>struct</code>
                    module for structured binary data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/write-binary.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-binary" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>When to Use Binary Mode:</strong><br>
                        - Images (PNG, JPEG, GIF)<br>
                        - Audio/Video files<br>
                        - Compressed archives (ZIP, GZIP)<br>
                        - Executables and compiled code<br>
                        - Network protocols and serialized data<br>
                        - Any file where exact byte representation matters
                    </div>

                    <!-- Section 4: Formatted Output -->
                    <h2>Formatted File Output</h2>
                    <p>Often you need to write formatted data - tables, reports, or structured text. Python offers several
                    ways to format output: f-strings for inline formatting, <code>format()</code> for templates, and even
                    <code>print()</code> with the <code>file</code> parameter. For efficiency with many lines, join them
                    into one string before writing.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/write-formatting.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-formatting" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Accidentally overwriting important files</h4>
                        <pre><code class="language-python"># DISASTER - overwrites config file!
with open("config.txt", "w") as f:
    f.write("debug=true")  # Lost all other settings!

# Safe approach - read first, modify, write back
with open("config.txt", "r") as f:
    content = f.read()
# Modify content...
with open("config.txt", "w") as f:
    f.write(modified_content)

# Or use append mode to add settings
with open("config.txt", "a") as f:
    f.write("\ndebug=true")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting newlines with writelines()</h4>
                        <pre><code class="language-python"># Wrong - creates one long line!
lines = ["apple", "banana", "cherry"]
with open("fruits.txt", "w") as f:
    f.writelines(lines)  # Result: "applebananacherry"

# Correct - add newlines
lines = ["apple\n", "banana\n", "cherry\n"]
with open("fruits.txt", "w") as f:
    f.writelines(lines)

# Or use generator expression
lines = ["apple", "banana", "cherry"]
with open("fruits.txt", "w") as f:
    f.writelines(line + "\n" for line in lines)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Writing strings to binary files</h4>
                        <pre><code class="language-python"># Wrong - TypeError: a bytes-like object is required
with open("data.bin", "wb") as f:
    f.write("Hello")  # Error!

# Correct - encode string to bytes
with open("data.bin", "wb") as f:
    f.write("Hello".encode("utf-8"))

# Or use bytes literal
with open("data.bin", "wb") as f:
    f.write(b"Hello")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not flushing or closing files</h4>
                        <pre><code class="language-python"># Wrong - data may not be written yet!
f = open("log.txt", "w")
f.write("Important data")
# Program crashes here - data may be lost!

# Correct - use 'with' statement
with open("log.txt", "w") as f:
    f.write("Important data")
# Automatically closed and flushed

# Or manually flush for long-running programs
f = open("log.txt", "w")
f.write("Log entry")
f.flush()  # Force write to disk now</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Writing many small strings inefficiently</h4>
                        <pre><code class="language-python"># Slow - many small write calls
with open("output.txt", "w") as f:
    for i in range(10000):
        f.write(f"Line {i}\n")  # 10000 write calls!

# Fast - build string first, single write
lines = [f"Line {i}" for i in range(10000)]
with open("output.txt", "w") as f:
    f.write("\n".join(lines))  # One write call!

# Or use writelines with generator
with open("output.txt", "w") as f:
    f.writelines(f"Line {i}\n" for i in range(10000))</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Log File Writer</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a simple log file writer that appends timestamped entries.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Write a function that appends log entries with timestamps</li>
                            <li>Each entry should be on its own line</li>
                            <li>Include the log level (INFO, WARNING, ERROR)</li>
                            <li>Demonstrate with multiple log entries</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-files-write.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-write" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">from datetime import datetime
import os

def log_message(filename, level, message):
    """Append a timestamped log entry to a file."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry = f"[{timestamp}] {level}: {message}\n"

    with open(filename, "a") as f:
        f.write(entry)

# Test the logger
log_file = "app.log"

# Write some log entries
log_message(log_file, "INFO", "Application started")
log_message(log_file, "INFO", "User logged in: alice")
log_message(log_file, "WARNING", "Low memory: 85% used")
log_message(log_file, "ERROR", "Database connection failed")
log_message(log_file, "INFO", "Retrying connection...")
log_message(log_file, "INFO", "Connection restored")

# Read and display the log
print("=== Log Contents ===")
with open(log_file, "r") as f:
    print(f.read())

# Cleanup
os.remove(log_file)</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Write mode:</strong> <code>open("file", "w")</code> - overwrites existing content</li>
                            <li><strong>Append mode:</strong> <code>open("file", "a")</code> - adds to end of file</li>
                            <li><strong>Exclusive create:</strong> <code>open("file", "x")</code> - fails if file exists</li>
                            <li><strong>Write string:</strong> <code>f.write("text")</code> - returns char count</li>
                            <li><strong>Write list:</strong> <code>f.writelines(["a", "b"])</code> - no auto newlines!</li>
                            <li><strong>Binary write:</strong> <code>open("file", "wb")</code> with <code>bytes</code></li>
                            <li><strong>Print to file:</strong> <code>print("text", file=f)</code></li>
                            <li><strong>Force flush:</strong> <code>f.flush()</code> - writes buffer to disk</li>
                            <li><strong>Always use:</strong> <code>with open(...) as f:</code> for auto-close</li>
                            <li><strong>Efficiency:</strong> Join strings before writing for better performance</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can read and write files, let's learn about <strong>context managers</strong> - the
                    Pythonic way to handle resources. The <code>with</code> statement ensures files are properly closed
                    even when errors occur, and you can create your own context managers for other resources!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-read.jsp" />
                    <jsp:param name="prevTitle" value="Reading Files" />
                    <jsp:param name="nextLink" value="files-context.jsp" />
                    <jsp:param name="nextTitle" value="Context Managers" />
                    <jsp:param name="currentLessonId" value="files-write" />
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
