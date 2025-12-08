<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-paths");
   request.setAttribute("currentModule", "File Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Working with Paths - os.path, pathlib, Directory Operations | 8gwifi.org</title>
    <meta name="description"
        content="Master Python path handling - use os.path for traditional path operations, pathlib for modern OOP approach, and learn directory traversal with glob and os.walk.">
    <meta name="keywords"
        content="python path, python os.path, python pathlib, python glob, python os.walk, python directory, python file path, python cross-platform">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Working with Paths - os.path, pathlib, Directory Operations">
    <meta property="og:description" content="Master Python path handling: os.path, pathlib, and directory traversal.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/files-paths.jsp">
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
        "name": "Python Working with Paths",
        "description": "Master Python path handling - use os.path and pathlib for cross-platform file paths, and learn directory operations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["os.path module", "pathlib Path class", "Path joining and splitting", "File and directory operations", "Directory traversal", "glob pattern matching"],
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

<body class="tutorial-body no-preview" data-lesson="files-paths">
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
                    <span>Working with Paths</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Working with Paths</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">File paths are different on Windows (<code>C:\Users\name</code>) vs Unix
                    (<code>/home/name</code>). Python provides tools to handle paths in a cross-platform way. The
                    traditional <code>os.path</code> module uses string functions, while the modern <code>pathlib</code>
                    module (Python 3.4+) treats paths as objects. Understanding both makes you prepared for any codebase!</p>

                    <!-- Section 1: os.path -->
                    <h2>The os.path Module</h2>
                    <p>The <code>os.path</code> module has been Python's path-handling solution since the beginning.
                    It provides functions to join, split, normalize, and query paths. The key function is
                    <code>os.path.join()</code> which uses the correct separator for the operating system.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/paths-ospath.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-ospath" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Essential os.path Functions:</strong><br>
                        <code>os.path.join(a, b)</code> - Join paths with correct separator<br>
                        <code>os.path.split(path)</code> - Split into (directory, filename)<br>
                        <code>os.path.splitext(path)</code> - Split into (name, extension)<br>
                        <code>os.path.exists(path)</code> - Check if path exists<br>
                        <code>os.path.isfile(path)</code> / <code>isdir(path)</code> - Check type<br>
                        <code>os.path.abspath(path)</code> - Get absolute path
                    </div>

                    <!-- Section 2: pathlib -->
                    <h2>The pathlib Module (Modern)</h2>
                    <p>The <code>pathlib</code> module, introduced in Python 3.4, represents paths as objects with
                    methods and properties. This is now the recommended approach for new code. Paths can be joined
                    with the <code>/</code> operator, making code more readable and Pythonic.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/paths-pathlib.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-pathlib" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Why Prefer pathlib?</strong><br>
                        - Object-oriented: methods on path objects, not functions<br>
                        - Readable: <code>Path("a") / "b" / "c"</code> vs <code>os.path.join("a", "b", "c")</code><br>
                        - Convenient: properties like <code>.name</code>, <code>.suffix</code>, <code>.parent</code><br>
                        - Powerful: built-in <code>glob()</code>, <code>read_text()</code>, <code>write_text()</code><br>
                        - Type hints: better IDE support and static analysis
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Operations -->
                    <h2>File and Directory Operations</h2>
                    <p>Beyond just manipulating path strings, you'll often need to create directories, copy files,
                    rename items, and delete things. The <code>pathlib</code> module handles most operations, but
                    <code>shutil</code> is needed for copying files and recursively deleting directories.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/paths-operations.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-operations" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Destructive Operations!</strong> Be careful with <code>shutil.rmtree()</code> - it
                        recursively deletes everything without confirmation. Always double-check the path before
                        deleting. Consider using <code>send2trash</code> package to move files to trash instead.
                    </div>

                    <!-- Section 4: Traversal -->
                    <h2>Directory Traversal</h2>
                    <p>Finding files in a directory tree is a common task. Use <code>iterdir()</code> for immediate
                    contents, <code>glob()</code> for pattern matching, and <code>os.walk()</code> when you need
                    full control over the traversal. The <code>**</code> pattern enables recursive searching.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/paths-traversal.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-traversal" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Glob Patterns:</strong><br>
                        <code>*</code> - Match any characters (except path separator)<br>
                        <code>**</code> - Match any path (recursive, crosses directories)<br>
                        <code>?</code> - Match single character<br>
                        <code>[abc]</code> - Match character set<br>
                        <code>*.py</code> - All Python files in current directory<br>
                        <code>**/*.py</code> - All Python files recursively
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Hardcoding path separators</h4>
                        <pre><code class="language-python"># Wrong - breaks on Windows!
path = "folder/subfolder/file.txt"
path = "folder" + "/" + "file.txt"

# Correct - use os.path.join or pathlib
import os
path = os.path.join("folder", "subfolder", "file.txt")

from pathlib import Path
path = Path("folder") / "subfolder" / "file.txt"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not checking if path exists before operating</h4>
                        <pre><code class="language-python"># Wrong - crashes if file doesn't exist!
from pathlib import Path
p = Path("maybe_exists.txt")
content = p.read_text()  # FileNotFoundError!

# Correct - check first
if p.exists():
    content = p.read_text()
else:
    content = ""

# Or use try/except
try:
    content = p.read_text()
except FileNotFoundError:
    content = ""</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting parents=True for nested directories</h4>
                        <pre><code class="language-python"># Wrong - fails if parent doesn't exist!
from pathlib import Path
Path("new/nested/dir").mkdir()  # FileNotFoundError!

# Correct - create parents too
Path("new/nested/dir").mkdir(parents=True)

# And exist_ok to avoid error if exists
Path("new/nested/dir").mkdir(parents=True, exist_ok=True)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using strings instead of Path objects</h4>
                        <pre><code class="language-python"># Mixing strings and Paths can cause issues
from pathlib import Path

# Wrong - string concatenation
base = Path("/home/user")
full = str(base) + "/file.txt"  # String, not Path!

# Correct - use / operator
full = base / "file.txt"  # Still a Path object

# Or convert at the end if needed
path_str = str(base / "file.txt")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Forgetting glob returns an iterator</h4>
                        <pre><code class="language-python"># Wrong - iterator exhausted after first use!
from pathlib import Path
files = Path(".").glob("*.py")
print(f"Count: {len(list(files))}")
for f in files:  # Empty! Iterator already consumed
    print(f)

# Correct - convert to list first
files = list(Path(".").glob("*.py"))
print(f"Count: {len(files)}")
for f in files:
    print(f)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: File Organizer</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that organizes files into folders by extension.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use pathlib for all path operations</li>
                            <li>Find all files in a directory (not subdirectories)</li>
                            <li>Group them by extension (.py, .txt, etc.)</li>
                            <li>Move each file to a folder named after its extension</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-files-paths.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-paths" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">from pathlib import Path
import shutil

def organize_by_extension(directory):
    """Organize files into folders by their extension."""
    base = Path(directory)

    # Find all files (not directories)
    files = [f for f in base.iterdir() if f.is_file()]

    for file in files:
        # Get extension without dot, or 'no_extension'
        ext = file.suffix[1:] if file.suffix else "no_extension"

        # Create extension folder
        ext_folder = base / ext
        ext_folder.mkdir(exist_ok=True)

        # Move file to extension folder
        dest = ext_folder / file.name
        file.rename(dest)
        print(f"Moved: {file.name} -> {ext}/{file.name}")


# Test it
test_dir = Path("test_organize")
test_dir.mkdir(exist_ok=True)

# Create sample files
(test_dir / "script.py").touch()
(test_dir / "utils.py").touch()
(test_dir / "data.txt").touch()
(test_dir / "notes.txt").touch()
(test_dir / "image.png").touch()
(test_dir / "README").touch()

print("Before organizing:")
for f in test_dir.iterdir():
    print(f"  {f.name}")
print()

organize_by_extension(test_dir)
print()

print("After organizing:")
for item in sorted(test_dir.iterdir()):
    if item.is_dir():
        print(f"  {item.name}/")
        for f in item.iterdir():
            print(f"    {f.name}")

# Cleanup
shutil.rmtree(test_dir)</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>os.path.join():</strong> Join paths with correct separator</li>
                            <li><strong>pathlib.Path:</strong> Modern OOP approach to paths</li>
                            <li><strong>Path / operator:</strong> <code>Path("a") / "b"</code> joins paths</li>
                            <li><strong>Path properties:</strong> <code>.name</code>, <code>.suffix</code>, <code>.parent</code>, <code>.stem</code></li>
                            <li><strong>Path methods:</strong> <code>.exists()</code>, <code>.is_file()</code>, <code>.is_dir()</code></li>
                            <li><strong>Create dirs:</strong> <code>Path.mkdir(parents=True, exist_ok=True)</code></li>
                            <li><strong>File ops:</strong> <code>.read_text()</code>, <code>.write_text()</code>, <code>.touch()</code></li>
                            <li><strong>Traversal:</strong> <code>.iterdir()</code>, <code>.glob()</code>, <code>.rglob()</code></li>
                            <li><strong>Copying:</strong> Use <code>shutil.copy()</code>, <code>shutil.copytree()</code></li>
                            <li><strong>Deleting:</strong> <code>.unlink()</code> for files, <code>shutil.rmtree()</code> for dirs</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can navigate the filesystem, let's learn about <strong>CSV files</strong> - one of
                    the most common data formats. Python's <code>csv</code> module makes it easy to read and write
                    spreadsheet-like data, and you'll see how to handle headers, different delimiters, and common
                    pitfalls!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-context.jsp" />
                    <jsp:param name="prevTitle" value="Context Managers" />
                    <jsp:param name="nextLink" value="files-csv.jsp" />
                    <jsp:param name="nextTitle" value="CSV Files" />
                    <jsp:param name="currentLessonId" value="files-paths" />
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
