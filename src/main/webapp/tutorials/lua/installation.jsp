<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "installation" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Lua Installation & Setup - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to install Lua on Windows, macOS, and Linux. Set up your development environment and write your first Lua script. Free Lua tutorial for beginners.">
            <meta name="keywords"
                content="install lua, lua setup, lua installation, lua windows, lua mac, lua linux, lua ide, learn lua">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Lua Installation & Setup - Lua Tutorial">
            <meta property="og:description"
                content="Install Lua and set up your development environment on any platform.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/installation.jsp">
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
        "name": "Lua Installation & Setup Guide",
        "description": "Learn how to install Lua on Windows, macOS, and Linux. Set up your development environment and write your first Lua script.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/installation.jsp",
        "keywords": "install lua, lua setup, lua installation, lua development environment",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Installing Lua", "Setting up Lua environment", "Running Lua scripts", "Lua IDEs"],
        "timeRequired": "PT15M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "description": "Complete Lua programming course from beginner to advanced with interactive examples",
            "url": "https://8gwifi.org/tutorials/lua/",
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            }
        },
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    }
    </script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Tutorials",
                "item": "https://8gwifi.org/tutorials/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Lua",
                "item": "https://8gwifi.org/tutorials/lua/"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Installation & Setup"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="installation">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-lua.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/">Lua</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Installation & Setup</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Installation & Setup</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Before we start coding in Lua, we need to set up our development
                                        environment.
                                        In this lesson, you'll learn how to install Lua on Windows, macOS, and Linux,
                                        choose a code editor,
                                        and run your first Lua script from the command line. Don't worry—it's easier
                                        than you think!</p>

                                    <!-- Installing Lua -->
                                    <h2>Installing Lua</h2>
                                    <p>Lua is available for all major operating systems. Choose your platform below:</p>

                                    <h3>Windows Installation</h3>
                                    <p>There are several ways to install Lua on Windows:</p>

                                    <h4>Option 1: LuaForWindows (Recommended for Beginners)</h4>
                                    <ol>
                                        <li>Visit <a href="https://github.com/rjpcomputing/luaforwindows"
                                                target="_blank" rel="noopener">LuaForWindows on GitHub</a></li>
                                        <li>Download the latest installer (.exe file)</li>
                                        <li>Run the installer and follow the prompts</li>
                                        <li>This includes Lua, LuaRocks (package manager), and several useful libraries
                                        </li>
                                    </ol>

                                    <h4>Option 2: Manual Installation</h4>
                                    <ol>
                                        <li>Download pre-compiled binaries from <a
                                                href="https://luabinaries.sourceforge.net/" target="_blank"
                                                rel="noopener">LuaBinaries</a></li>
                                        <li>Extract to a folder (e.g., <code>C:\Lua</code>)</li>
                                        <li>Add the folder to your PATH environment variable</li>
                                    </ol>

                                    <h3>macOS Installation</h3>
                                    <p>The easiest way to install Lua on macOS is using Homebrew:</p>

                                    <pre><code class="language-bash"># Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Lua
brew install lua

# Verify installation
lua -v</code></pre>

                                    <h3>Linux Installation</h3>
                                    <p>Most Linux distributions include Lua in their package repositories:</p>

                                    <pre><code class="language-bash"># Ubuntu/Debian
sudo apt-get update
sudo apt-get install lua5.4

# Fedora
sudo dnf install lua

# Arch Linux
sudo pacman -S lua

# Verify installation
lua -v</code></pre>

                                    <div class="info-box">
                                        <strong>Version Note:</strong> This tutorial uses Lua 5.4 (the latest version).
                                        Lua 5.3 and 5.2 are also widely used and mostly compatible. Most code examples
                                        will work across versions, but we'll note any version-specific features.
                                    </div>

                                    <!-- Verifying Installation -->
                                    <h2>Verifying Your Installation</h2>
                                    <p>Open your terminal (Command Prompt on Windows, Terminal on macOS/Linux) and type:
                                    </p>

                                    <pre><code class="language-bash">lua -v</code></pre>

                                    <p>You should see output similar to:</p>

                                    <pre><code>Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> If you get a "command not found" error, Lua might not
                                        be in your PATH.
                                        On Windows, try restarting your terminal or computer after installation. On
                                        macOS/Linux,
                                        you may need to add Lua to your PATH in your shell configuration file.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Interactive Lua -->
                                    <h2>The Lua Interactive Interpreter</h2>
                                    <p>Lua comes with an interactive interpreter (REPL - Read-Eval-Print Loop) that's
                                        perfect for
                                        testing code snippets. Start it by typing <code>lua</code> in your terminal:</p>

                                    <pre><code class="language-bash">$ lua
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio
> print("Hello, Lua!")
Hello, Lua!
> x = 10
> print(x * 2)
20
> os.exit()  -- Exit the interpreter</code></pre>

                                    <p>This is great for quick experiments! Try it now—type some simple Lua commands and
                                        see the results immediately.</p>

                                    <!-- Choosing an Editor -->
                                    <h2>Choosing a Code Editor</h2>
                                    <p>While you can write Lua in any text editor, these editors provide excellent Lua
                                        support:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Editor</th>
                                                <th>Platform</th>
                                                <th>Best For</th>
                                                <th>Lua Support</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>VS Code</strong></td>
                                                <td>All</td>
                                                <td>General development</td>
                                                <td>Excellent (with Lua extension)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>ZeroBrane Studio</strong></td>
                                                <td>All</td>
                                                <td>Lua-specific IDE</td>
                                                <td>Built-in debugger</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Sublime Text</strong></td>
                                                <td>All</td>
                                                <td>Lightweight editing</td>
                                                <td>Good (with packages)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Neovim/Vim</strong></td>
                                                <td>All</td>
                                                <td>Terminal-based</td>
                                                <td>Excellent (native Lua config)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Recommended: Visual Studio Code</h3>
                                    <p>For beginners, we recommend <strong>VS Code</strong> with the Lua extension:</p>

                                    <ol>
                                        <li>Download and install <a href="https://code.visualstudio.com/"
                                                target="_blank" rel="noopener">VS Code</a></li>
                                        <li>Open VS Code</li>
                                        <li>Go to Extensions (Ctrl+Shift+X or Cmd+Shift+X)</li>
                                        <li>Search for "Lua" and install the "Lua" extension by sumneko</li>
                                        <li>Restart VS Code</li>
                                    </ol>

                                    <div class="best-practice-box">
                                        <strong>Editor Features to Look For:</strong>
                                        <ul>
                                            <li>Syntax highlighting</li>
                                            <li>Auto-completion</li>
                                            <li>Error detection (linting)</li>
                                            <li>Integrated terminal</li>
                                            <li>Debugger support</li>
                                        </ul>
                                    </div>

                                    <!-- Running Lua Scripts -->
                                    <h2>Running Lua Scripts</h2>
                                    <p>There are three main ways to run Lua code:</p>

                                    <h3>1. From a File</h3>
                                    <p>Create a file called <code>test.lua</code> with this content:</p>

                                    <pre><code class="language-lua">print("Hello from a Lua file!")
print("2 + 2 =", 2 + 2)</code></pre>

                                    <p>Run it from the terminal:</p>

                                    <pre><code class="language-bash">lua test.lua</code></pre>

                                    <h3>2. Using the Interactive Interpreter</h3>
                                    <p>As we saw earlier, just type <code>lua</code> and enter commands interactively.
                                    </p>

                                    <h3>3. One-liner Execution</h3>
                                    <p>Execute Lua code directly from the command line:</p>

                                    <pre><code class="language-bash">lua -e "print('Quick test!')"</code></pre>

                                    <div class="warning-box">
                                        <strong>File Extension:</strong> Lua files use the <code>.lua</code> extension.
                                        Make sure your text editor doesn't add an extra extension like
                                        <code>.txt</code>.
                                        The file should be named <code>script.lua</code>, not
                                        <code>script.lua.txt</code>.
                                    </div>

                                    <!-- Installing LuaRocks -->
                                    <h2>Installing LuaRocks (Package Manager)</h2>
                                    <p>LuaRocks is Lua's package manager, similar to npm for JavaScript or pip for
                                        Python.
                                        It allows you to easily install third-party libraries.</p>

                                    <h3>Windows</h3>
                                    <p>LuaForWindows includes LuaRocks. Otherwise, download from
                                        <a href="https://luarocks.org/" target="_blank" rel="noopener">luarocks.org</a>.
                                    </p>

                                    <h3>macOS</h3>
                                    <pre><code class="language-bash">brew install luarocks</code></pre>

                                    <h3>Linux</h3>
                                    <pre><code class="language-bash"># Ubuntu/Debian
sudo apt-get install luarocks

# Fedora
sudo dnf install luarocks</code></pre>

                                    <h3>Verify LuaRocks</h3>
                                    <pre><code class="language-bash">luarocks --version</code></pre>

                                    <!-- Common Issues -->
                                    <h2>Common Installation Issues</h2>

                                    <div class="mistake-box">
                                        <h4>1. "lua: command not found"</h4>
                                        <p><strong>Problem:</strong> Lua is not in your system PATH.</p>
                                        <p><strong>Solution:</strong></p>
                                        <ul>
                                            <li><strong>Windows:</strong> Add Lua's bin folder to PATH in System
                                                Environment Variables</li>
                                            <li><strong>macOS/Linux:</strong> Add to PATH in <code>~/.bashrc</code> or
                                                <code>~/.zshrc</code></li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Multiple Lua versions installed</h4>
                                        <p><strong>Problem:</strong> Different versions causing conflicts.</p>
                                        <p><strong>Solution:</strong> Use version managers like <code>luaenv</code> or
                                            specify the version
                                            explicitly (e.g., <code>lua5.4</code> instead of <code>lua</code>).</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Installation:</strong> Use package managers (Homebrew, apt,
                                                etc.) or download binaries</li>
                                            <li><strong>Verification:</strong> Run <code>lua -v</code> to check
                                                installation</li>
                                            <li><strong>Interactive Mode:</strong> Type <code>lua</code> for REPL</li>
                                            <li><strong>Editor:</strong> VS Code with Lua extension recommended for
                                                beginners</li>
                                            <li><strong>Running Scripts:</strong> Use <code>lua filename.lua</code></li>
                                            <li><strong>LuaRocks:</strong> Package manager for installing libraries</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You now have Lua installed and ready to use. In the next lesson,
                                        we'll write our first Lua program—the classic <strong>"Hello,
                                            World!"</strong>—and explore
                                        the basic structure of a Lua script. Let's start coding! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="intro.jsp" />
                                    <jsp:param name="prevTitle" value="Introduction to Lua" />
                                    <jsp:param name="nextLink" value="hello-world.jsp" />
                                    <jsp:param name="nextTitle" value="Hello World" />
                                    <jsp:param name="currentLessonId" value="installation" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/lua.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>