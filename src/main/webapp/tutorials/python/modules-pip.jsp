<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "modules-pip");
   request.setAttribute("currentModule", "Modules & Packages"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python PIP - Package Manager, Install Packages, Virtual Environments | 8gwifi.org</title>
    <meta name="description"
        content="Master Python PIP - install, upgrade, and manage Python packages. Learn requirements.txt, virtual environments, and essential pip commands for dependency management.">
    <meta name="keywords"
        content="python pip, pip install, pip uninstall, python package manager, requirements.txt, python virtual environment, pip freeze, pip list, pypi">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python PIP - Package Manager, Install Packages, Virtual Environments">
    <meta property="og:description" content="Master Python PIP: installing and managing packages for your projects.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/modules-pip.jsp">
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
        "name": "Python PIP Package Manager",
        "description": "Master Python PIP - install, upgrade, and manage Python packages. Learn requirements.txt, virtual environments, and dependency management.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["pip install and uninstall", "Version specifiers", "requirements.txt", "Virtual environments", "pip freeze and list", "Popular packages", "Dependency management"],
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

<body class="tutorial-body no-preview" data-lesson="modules-pip">
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
                    <span>PIP</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PIP Package Manager</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">PIP (Pip Installs Packages) is Python's package manager - your gateway to over
                    400,000 packages on PyPI (Python Package Index). From web frameworks like Flask and Django to
                    data science libraries like NumPy and Pandas, pip lets you easily install, upgrade, and manage
                    third-party packages. Understanding pip and virtual environments is essential for any Python
                    developer working on real-world projects!</p>

                    <!-- Section 1: Essential Commands -->
                    <h2>Essential PIP Commands</h2>
                    <p>PIP commands run in your terminal (Command Prompt, PowerShell, or Terminal), not in Python.
                    The most common commands are <code>pip install</code> to add packages, <code>pip uninstall</code>
                    to remove them, and <code>pip list</code> to see what's installed. You can also specify exact
                    versions for reproducible builds.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/pip-commands.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-commands" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>pip vs pip3:</strong> On systems with both Python 2 and 3, use <code>pip3</code> for
                        Python 3 packages. On newer systems with only Python 3, <code>pip</code> and <code>pip3</code>
                        are usually the same. To be safe, use <code>python -m pip install package</code> which always
                        uses the pip for the current Python interpreter.
                    </div>

                    <!-- Section 2: requirements.txt -->
                    <h2>Managing Dependencies with requirements.txt</h2>
                    <p>The <code>requirements.txt</code> file lists all packages your project needs. It's the
                    standard way to share dependencies - anyone can recreate your environment by running
                    <code>pip install -r requirements.txt</code>. Use <code>pip freeze</code> to generate this
                    file from your current environment.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/pip-requirements.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-requirements" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Version Specifiers:</strong><br>
                        <code>==1.2.3</code> - Exact version (most reproducible)<br>
                        <code>>=1.2.0</code> - Minimum version (allows updates)<br>
                        <code>~=1.2.0</code> - Compatible release (>=1.2.0, <1.3.0)<br>
                        <code>>=1.2,<2.0</code> - Version range (flexible but bounded)
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Virtual Environments -->
                    <h2>Virtual Environments</h2>
                    <p>Virtual environments solve a critical problem: different projects needing different package
                    versions. Each virtual environment is an isolated Python installation with its own packages.
                    This is a must-know skill for professional Python development - always use virtual environments
                    for your projects!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/pip-virtualenv.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-virtualenv" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Don't Commit Your venv!</strong> Add <code>venv/</code> or <code>.venv/</code> to your
                        <code>.gitignore</code> file. Virtual environments are large, machine-specific, and can be
                        recreated from requirements.txt. Only commit the requirements.txt file, not the entire
                        virtual environment folder.
                    </div>

                    <!-- Section 4: Using Packages -->
                    <h2>Using Installed Packages</h2>
                    <p>Once installed, packages are imported just like standard library modules. Python's ecosystem
                    includes packages for nearly everything: web development, data science, machine learning, API
                    clients, automation, and more. Learning to find and use the right packages is a superpower!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/pip-using-packages.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-using" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Installing globally without virtual environment</h4>
                        <pre><code class="language-bash"># Wrong - installs globally, can cause conflicts
pip install flask

# Better - always use virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install flask

# Now flask is isolated to this project</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not pinning versions in production</h4>
                        <pre><code class="language-python"># requirements.txt - Bad for production
requests
flask
numpy

# requirements.txt - Good for production
requests==2.28.0
flask==2.2.2
numpy==1.24.0

# Generate pinned requirements:
pip freeze > requirements.txt</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to activate virtual environment</h4>
                        <pre><code class="language-bash"># Wrong - installs to wrong Python!
python -m venv venv
pip install requests  # Still using global pip!

# Correct - activate first!
python -m venv venv
source venv/bin/activate  # IMPORTANT!
pip install requests  # Now goes to venv

# Check which pip you're using:
which pip  # Should show path inside venv</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Committing virtual environment to git</h4>
                        <pre><code class="language-bash"># .gitignore - Add these lines!
venv/
.venv/
env/
.env/
__pycache__/
*.pyc

# Only commit requirements.txt
# Others can recreate the environment with:
pip install -r requirements.txt</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Using pip install in Python code</h4>
                        <pre><code class="language-python"># Wrong - don't install packages from Python
import pip
pip.main(['install', 'requests'])  # Bad practice!

# Correct - install from terminal
# $ pip install requests

# If you must install programmatically:
import subprocess
import sys
subprocess.check_call([sys.executable, "-m", "pip", "install", "requests"])</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Project Setup</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Write the commands for a proper project setup workflow.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a virtual environment named 'venv'</li>
                            <li>Activate the virtual environment</li>
                            <li>Install requests and flask packages</li>
                            <li>Save dependencies to requirements.txt</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-modules-pip.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-pip" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Project setup commands (run in terminal, not Python)
print("=== Project Setup Commands ===")
print()
print("# 1. Create virtual environment")
print("python -m venv venv")
print()
print("# 2. Activate virtual environment")
print("# Windows:")
print("venv\\Scripts\\activate")
print("# macOS/Linux:")
print("source venv/bin/activate")
print()
print("# 3. Install packages")
print("pip install requests flask")
print()
print("# 4. Save dependencies")
print("pip freeze > requirements.txt")
print()
print("# Bonus: Verify installation")
print("pip list")
print("python -c \"import requests, flask; print('Success!')\"")
print()
print("# When done working:")
print("deactivate")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Install:</strong> <code>pip install package_name</code></li>
                            <li><strong>Specific version:</strong> <code>pip install package==1.2.3</code></li>
                            <li><strong>Upgrade:</strong> <code>pip install --upgrade package</code></li>
                            <li><strong>Uninstall:</strong> <code>pip uninstall package</code></li>
                            <li><strong>List packages:</strong> <code>pip list</code> or <code>pip freeze</code></li>
                            <li><strong>requirements.txt:</strong> <code>pip install -r requirements.txt</code></li>
                            <li><strong>Create venv:</strong> <code>python -m venv venv</code></li>
                            <li><strong>Activate:</strong> <code>source venv/bin/activate</code> (Linux/Mac) or <code>venv\Scripts\activate</code> (Windows)</li>
                            <li><strong>Deactivate:</strong> <code>deactivate</code></li>
                            <li><strong>Best practice:</strong> Always use virtual environments for projects</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the Modules & Packages module! You now know how to work with
                    Python's standard library modules and install third-party packages. Next, we'll learn about
                    <strong>File Handling</strong> - reading from and writing to files, which is essential for
                    data processing, configuration, and persistence!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="modules-regex.jsp" />
                    <jsp:param name="prevTitle" value="RegEx" />
                    <jsp:param name="nextLink" value="files-read.jsp" />
                    <jsp:param name="nextTitle" value="Reading Files" />
                    <jsp:param name="currentLessonId" value="modules-pip" />
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
