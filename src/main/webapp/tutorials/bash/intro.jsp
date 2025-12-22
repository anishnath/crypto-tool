<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "intro");
   request.setAttribute("currentModule", "Introduction"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Introduction - What is Bash, Why Learn Bash Scripting | 8gwifi.org</title>
    <meta name="description"
        content="Learn what Bash is, why it's powerful, and how it differs from other shells. Start your Bash scripting journey with this comprehensive introduction.">
    <meta name="keywords"
        content="bash introduction, what is bash, bash scripting, shell scripting, learn bash, bash tutorial, linux shell, unix shell">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Introduction - What is Bash, Why Learn Bash Scripting">
    <meta property="og:description" content="Learn what Bash is, why it's essential for system administration and automation, and how to get started with Bash scripting.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/intro.jsp">
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
        "name": "Bash Introduction",
        "description": "Learn what Bash is, why it's powerful, and how it differs from other shells. Start your Bash scripting journey.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["What is Bash", "Shell vs Script", "Bash versions", "Why learn Bash", "Terminal basics", "Bash features"],
        "timeRequired": "PT15M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="intro">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-bash.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Introduction</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Introduction to Bash</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Welcome to Bash scripting! Bash (Bourne Again SHell) is the default shell on most Linux and macOS systems, and it's one of the most powerful tools for system administration, automation, and development. Whether you're managing servers, automating tasks, or writing deployment scripts, Bash is an essential skill for any developer or system administrator.</p>

                    <!-- Section 1: What is Bash -->
                    <h2>What is Bash?</h2>
                    <p>Bash is a command processor that typically runs in a text window where users type commands. It's also a scripting language that allows you to automate tasks, combine system utilities, and create powerful workflows. Bash stands for "Bourne Again SHell" - it's an enhanced version of the original Bourne shell (sh).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/intro-what-is-bash.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-what-is-bash" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Shell vs Terminal:</strong><br>
                        - <strong>Terminal:</strong> The application you use to interact with the shell (e.g., Terminal.app, GNOME Terminal, iTerm2)<br>
                        - <strong>Shell:</strong> The command interpreter that processes your commands (Bash, Zsh, Fish, etc.)<br>
                        - <strong>Bash Script:</strong> A file containing Bash commands that can be executed as a program
                    </div>

                    <!-- Section 2: Why Learn Bash -->
                    <h2>Why Learn Bash?</h2>
                    <p>Bash scripting is incredibly useful for:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Use Case</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>System Administration</strong></td>
                                <td>Automate server maintenance, backups, log rotation, and system monitoring</td>
                            </tr>
                            <tr>
                                <td><strong>Development</strong></td>
                                <td>Build automation, deployment scripts, testing, and CI/CD pipelines</td>
                            </tr>
                            <tr>
                                <td><strong>File Management</strong></td>
                                <td>Batch processing, renaming, organizing, and manipulating files</td>
                            </tr>
                            <tr>
                                <td><strong>Data Processing</strong></td>
                                <td>Text processing, log analysis, and data transformation using pipes and filters</td>
                            </tr>
                            <tr>
                                <td><strong>Task Automation</strong></td>
                                <td>Automate repetitive tasks and create shortcuts for complex operations</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Even if you primarily use Python, Ruby, or other languages, Bash is still valuable for orchestrating those tools, setting up environments, and writing one-liners for quick tasks!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Bash vs Other Shells -->
                    <h2>Bash vs Other Shells</h2>
                    <p>While there are many shells available, Bash is the most widely used and compatible. Here's a quick comparison:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/intro-shell-types.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-shell-types" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Shell</th>
                                <th>Description</th>
                                <th>Common Use</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Bash</strong></td>
                                <td>Bourne Again SHell - most common on Linux</td>
                                <td>Default on most Linux systems, macOS (pre-Catalina)</td>
                            </tr>
                            <tr>
                                <td><strong>Zsh</strong></td>
                                <td>Z Shell - feature-rich with plugins</td>
                                <td>Default on macOS (Catalina+), power users</td>
                            </tr>
                            <tr>
                                <td><strong>sh</strong></td>
                                <td>Bourne Shell - POSIX compliant</td>
                                <td>Maximum compatibility, minimal scripts</td>
                            </tr>
                            <tr>
                                <td><strong>Fish</strong></td>
                                <td>Friendly Interactive SHell - user-friendly</td>
                                <td>Interactive use, beginners</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Compatibility Note:</strong> Bash scripts are generally compatible across different Unix-like systems (Linux, macOS, BSD). This portability makes Bash a great choice for cross-platform automation!
                    </div>

                    <!-- Section 4: Bash Versions -->
                    <h2>Bash Versions</h2>
                    <p>Bash has evolved over the years, with each version adding new features. Most modern systems use Bash 4.x or 5.x. Key features were added in:</p>

                    <ul>
                        <li><strong>Bash 4.0+</strong>: Associative arrays, case modification, globstar, and more</li>
                        <li><strong>Bash 4.4+</strong>: Improved error handling, more built-in commands</li>
                        <li><strong>Bash 5.0+</strong>: Bug fixes and performance improvements</li>
                    </ul>

                    <div class="warning-box">
                        <strong>macOS Note:</strong> macOS ships with an older Bash version (3.2) due to GPL licensing. For modern Bash features, install a newer version using Homebrew: <code>brew install bash</code>
                    </div>

                    <!-- Section 5: Where Bash is Used -->
                    <h2>Where is Bash Used?</h2>
                    <p>Bash is everywhere in the Unix/Linux world:</p>

                    <ul>
                        <li><strong>Linux Servers:</strong> Nearly every Linux server uses Bash as the default shell</li>
                        <li><strong>macOS:</strong> Available by default (though Zsh is now the default in newer versions)</li>
                        <li><strong>Windows:</strong> Available via WSL (Windows Subsystem for Linux), Git Bash, or Cygwin</li>
                        <li><strong>Docker Containers:</strong> Most container images include Bash</li>
                        <li><strong>CI/CD Systems:</strong> Many pipeline configurations use Bash scripts</li>
                        <li><strong>Embedded Systems:</strong> Many routers, IoT devices, and embedded systems use Bash</li>
                    </ul>

                    <!-- Common Mistakes -->
                    <h2>Common Misconceptions</h2>

                    <div class="mistake-box">
                        <h4>1. "Bash is just for Linux"</h4>
                        <p><strong>Wrong:</strong> Bash runs on macOS, Windows (via WSL/Git Bash), Unix systems, and even Android (via Termux).</p>
                        <p><strong>Correct:</strong> Bash is cross-platform and works on any system that has a Unix-like environment.</p>
                    </div>

                    <div class="mistake-box">
                        <h4>2. "Python/Perl is always better than Bash"</h4>
                        <p><strong>Wrong:</strong> While Python is great for complex logic, Bash excels at:</p>
                        <ul>
                            <li>Combining command-line tools with pipes</li>
                            <li>System administration tasks</li>
                            <li>Quick automation scripts</li>
                            <li>Scripts that primarily call other programs</li>
                        </ul>
                        <p><strong>Correct:</strong> Use the right tool for the job. Bash for system tasks, Python for complex logic.</p>
                    </div>

                    <div class="mistake-box">
                        <h4>3. "Bash is outdated"</h4>
                        <p><strong>Wrong:</strong> Bash is actively maintained and widely used. It's the foundation of Linux system administration.</p>
                        <p><strong>Correct:</strong> Bash remains the standard for shell scripting and system automation. Learning it is highly valuable!</p>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Bash:</strong> Bourne Again SHell - a powerful command interpreter and scripting language</li>
                            <li><strong>Default Shell:</strong> Bash is the default on most Linux systems and available on macOS</li>
                            <li><strong>Use Cases:</strong> System administration, automation, development workflows, file management</li>
                            <li><strong>Compatibility:</strong> Bash scripts are portable across Unix-like systems</li>
                            <li><strong>Versions:</strong> Most systems use Bash 4.x or 5.x; check with <code>bash --version</code></li>
                            <li><strong>Scripts:</strong> Files containing Bash commands that can be executed like programs</li>
                            <li><strong>Shell vs Terminal:</strong> Terminal is the application; Shell is the command processor</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand what Bash is and why it's valuable, let's write your first Bash script! In the next lesson, we'll learn about the shebang (<code>#!</code>), making scripts executable, and running your first Bash program.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="index.jsp" />
                    <jsp:param name="prevTitle" value="Course Overview" />
                    <jsp:param name="nextLink" value="first-script.jsp" />
                    <jsp:param name="nextTitle" value="First Script" />
                    <jsp:param name="currentLessonId" value="intro" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>




