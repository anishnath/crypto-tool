<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "prof-venv" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Virtual Environments - venv, pip, requirements.txt & Dependency Isolation | 8gwifi.org</title>
            <meta name="description"
                content="Master Python virtual environments with venv. Learn to create isolated environments, manage dependencies with pip, use requirements.txt, and avoid package conflicts across projects.">
            <meta name="keywords"
                content="python venv, virtual environment, python pip, requirements.txt, dependency isolation, python package management, venv activation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Virtual Environments - venv, pip, requirements.txt & Dependency Isolation">
            <meta property="og:description"
                content="Master Python virtual environments with venv. Learn to create isolated environments, manage dependencies, and avoid package conflicts with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/prof-venv.jsp">
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
        "name": "Python Virtual Environments",
        "description": "Master Python virtual environments with venv. Learn to create isolated environments, manage dependencies with pip, and use requirements.txt.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Virtual environments", "venv module", "Creating environments", "Activating environments", "pip package management", "requirements.txt", "Dependency isolation", "Deactivating environments"],
        "timeRequired": "PT20M",
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

        <body class="tutorial-body no-preview" data-lesson="prof-venv">
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
                                    <h1 class="lesson-title">Virtual Environments</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Virtual environments are isolated Python environments that allow
                                        each project to have its own set of dependencies without conflicts. Using
                                        <code>venv</code>, you can create separate environments for different projects,
                                        ensuring that package versions don't interfere with each other. This is
                                        essential for professional Python development!</p>

                                    <h2>Why Virtual Environments?</h2>
                                    <p>Without virtual environments, all Python packages are installed globally. This
                                        causes problems when different projects need different versions of the same
                                        package. Virtual environments solve this by giving each project its own isolated
                                        Python environment with its own packages.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-venv-why.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-why" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Benefits of Virtual Environments:</strong><br>
                                        - <strong>Isolation:</strong> Each project has its own packages, no conflicts<br>
                                        - <strong>Reproducibility:</strong> Easy to recreate exact environment with
                                        requirements.txt<br>
                                        - <strong>Clean System:</strong> Keep your system Python installation clean<br>
                                        - <strong>Version Control:</strong> Track dependencies per project<br>
                                        - <strong>Deployment:</strong> Match production environment exactly
                                    </div>

                                    <h2>Creating Virtual Environments</h2>
                                    <p>Python 3.3+ includes the <code>venv</code> module for creating virtual
                                        environments. The command creates a new directory containing a Python interpreter
                                        and a copy of the standard library.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-venv-create.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-create" />
                                    </jsp:include>

                                    <h2>Activating Virtual Environments</h2>
                                    <p>After creating a virtual environment, you must activate it before use. Activation
                                        modifies your PATH so that Python and pip commands use the virtual environment's
                                        versions. The command differs between operating systems.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-venv-activate.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-activate" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> When activated, your terminal prompt shows the
                                        environment name in parentheses, like <code>(myenv)</code>. This confirms the
                                        virtual environment is active. You can have multiple terminals with different
                                        environments activated simultaneously!
                                    </div>

                                    <h2>Working with requirements.txt</h2>
                                    <p>The <code>requirements.txt</code> file is the standard way to specify project
                                        dependencies. You can generate it from your current environment and use it to
                                        recreate the exact same environment elsewhere.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-venv-requirements.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-requirements" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Always include <code>requirements.txt</code> in your
                                        version control (git)! This allows others (and you on different machines) to
                                        recreate the exact environment. Never commit the virtual environment directory
                                        itself - it's large and OS-specific!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not activating the virtual environment</h4>
                                        <pre><code class="language-bash"># Wrong - installing globally
python -m venv myenv
pip install requests  # Installs to system Python, not venv!

# Correct - activate first
python -m venv myenv
source myenv/bin/activate  # On Mac/Linux
# OR: myenv\Scripts\activate  # On Windows
pip install requests  # Now installs to venv</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Committing the virtual environment directory</h4>
                                        <pre><code class="language-bash"># Wrong - committing entire venv directory
git add myenv/
git commit -m "Add virtual environment"

# Correct - only commit requirements.txt
# Add to .gitignore:
echo "myenv/" >> .gitignore
echo "venv/" >> .gitignore
echo "env/" >> .gitignore

git add requirements.txt
git commit -m "Add dependencies"</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting to update requirements.txt</h4>
                                        <pre><code class="language-bash"># Wrong - install package but forget to save
pip install new-package==1.2.3
# requirements.txt is now out of date!

# Correct - update requirements.txt after installing
pip install new-package==1.2.3
pip freeze > requirements.txt  # Update immediately

# Or better yet, install from requirements directly
pip install -r requirements.txt</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Creating venv inside project that's already in venv</h4>
                                        <pre><code class="language-bash"># Wrong - nested virtual environments
source myenv/bin/activate  # Already in venv
python -m venv nested_env  # Creating venv inside venv - confusing!

# Correct - deactivate first, or create in project root
deactivate  # Exit current venv
python -m venv project_env  # Create at project level</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Create a Project Environment</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Write a Python script that simulates setting up a new
                                            project with a virtual environment. The script should demonstrate the workflow
                                            of creating a venv, installing packages, and managing requirements.txt.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Print commands to create a virtual environment named 'myproject_env'</li>
                                            <li>Show activation commands for both Windows and Mac/Linux</li>
                                            <li>Demonstrate installing packages (requests, flask)</li>
                                            <li>Show how to generate and read requirements.txt</li>
                                            <li>Include deactivation command</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-prof-venv.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-prof-venv" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python"># Creating virtual environment
print("Step 1: Create virtual environment")
print("python3 -m venv myproject_env")

# Activating (choose based on OS)
print("\nStep 2: Activate virtual environment")
print("Windows: myproject_env\\Scripts\\activate")
print("Mac/Linux: source myproject_env/bin/activate")

# Installing packages
print("\nStep 3: Install packages")
print("pip install requests flask")

# Generate requirements
print("\nStep 4: Save dependencies")
print("pip freeze > requirements.txt")

# Deactivate
print("\nStep 5: Deactivate when done")
print("deactivate")

# Recreate environment (for deployment)
print("\nTo recreate environment:")
print("python3 -m venv myproject_env")
print("source myproject_env/bin/activate  # or Scripts\\activate on Windows")
print("pip install -r requirements.txt")</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Virtual Environments:</strong> Isolated Python environments for
                                                each project to avoid dependency conflicts</li>
                                            <li><strong>Creating:</strong> Use <code>python3 -m venv env_name</code> to
                                                create a new virtual environment</li>
                                            <li><strong>Activating:</strong> <code>source env_name/bin/activate</code>
                                                (Mac/Linux) or <code>env_name\Scripts\activate</code> (Windows)</li>
                                            <li><strong>Deactivating:</strong> Simply run <code>deactivate</code></li>
                                            <li><strong>Installing Packages:</strong> Use <code>pip install package</code>
                                                while venv is activated</li>
                                            <li><strong>requirements.txt:</strong> Generate with <code>pip freeze >
                                                    requirements.txt</code>, install with <code>pip install -r
                                                    requirements.txt</code></li>
                                            <li><strong>Best Practice:</strong> Always use virtual environments for
                                                projects, commit requirements.txt to version control, never commit the
                                                venv directory</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Virtual environments are essential for professional development! Next, we'll
                                        explore <strong>unit testing</strong> with Python's <code>unittest</code> module.
                                        Testing ensures your code works correctly and helps catch bugs before they reach
                                        production. Writing tests is a critical professional practice!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="adv-typing.jsp" />
                                    <jsp:param name="prevTitle" value="Type Hinting" />
                                    <jsp:param name="nextLink" value="prof-testing.jsp" />
                                    <jsp:param name="nextTitle" value="Unit Testing" />
                                    <jsp:param name="currentLessonId" value="prof-venv" />
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