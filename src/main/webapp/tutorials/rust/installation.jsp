<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "installation" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>How to Install Rust - Rustup Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to install Rust with Rustup on Windows, macOS, and Linux. Step-by-step guide to set up Rust development environment. Free tutorial.">
            <meta name="keywords"
                content="install rust, how to install rust, rustup, rust installation, rust setup, rust windows, rust macos, rust linux, rust development environment, rust tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Install Rust - Rustup Installation Guide">
            <meta property="og:description"
                content="Complete guide to installing Rust and setting up your development environment.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/installation.jsp">
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
    "name": "How to Install Rust - Rustup Tutorial",
    "description": "Learn how to install Rust with Rustup on Windows, macOS, and Linux. Step-by-step guide to set up Rust development environment. Free tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/installation.jsp",
    "keywords": "install rust, how to install rust, rustup, rust installation, rust setup, rust windows, rust macos, rust linux, rust development environment, rust tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust installation", "Rustup", "Development environment setup", "Rust verification"],
    "timeRequired": "PT10M",
    "isPartOf": {
        "@type": "Course",
        "name": "Rust Tutorial",
        "description": "Complete Rust programming course from beginner to advanced with interactive examples",
        "url": "https://8gwifi.org/tutorials/rust/",
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
            "name": "Rust",
            "item": "https://8gwifi.org/tutorials/rust/"
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
                        <%@ include file="../tutorial-sidebar-rust.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/rust/">Rust</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Installation & Setup</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Installing Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Installing Rust is straightforward thanks to Rustup, the official
                                        Rust installer and version manager.
                                        In this lesson, you'll learn how to install Rust on Windows, macOS, and Linux,
                                        set up your development environment,
                                        and verify everything is working correctly.</p>

                                    <!-- Section 1: What is Rustup? -->
                                    <h2>What is Rustup?</h2>
                                    <p>Rustup is the recommended way to install Rust. It's a toolchain installer that
                                        manages:</p>
                                    <ul>
                                        <li><strong>Rust compiler (rustc):</strong> Compiles your Rust code</li>
                                        <li><strong>Cargo:</strong> Rust's package manager and build tool</li>
                                        <li><strong>Standard library:</strong> Core Rust functionality</li>
                                        <li><strong>Toolchains:</strong> Different versions of Rust (stable, beta,
                                            nightly)</li>
                                    </ul>

                                    <div class="info-box">
                                        <strong>Why Rustup?</strong> Rustup makes it easy to:
                                        <ul>
                                            <li>Install and update Rust</li>
                                            <li>Switch between Rust versions</li>
                                            <li>Add cross-compilation targets</li>
                                            <li>Install additional components (rustfmt, clippy)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Installation by Platform -->
                                    <h2>Installation Instructions</h2>

                                    <h3>Windows</h3>
                                    <p>On Windows, you'll need the Microsoft C++ build tools before installing Rust.</p>

                                    <ol>
                                        <li><strong>Install Visual Studio C++ Build Tools:</strong>
                                            <ul>
                                                <li>Download from <a
                                                        href="https://visualstudio.microsoft.com/visual-cpp-build-tools/"
                                                        target="_blank" rel="noopener">Microsoft's website</a></li>
                                                <li>Run the installer and select "Desktop development with C++"</li>
                                            </ul>
                                        </li>
                                        <li><strong>Download Rustup:</strong>
                                            <ul>
                                                <li>Visit <a href="https://rustup.rs/" target="_blank"
                                                        rel="noopener">rustup.rs</a></li>
                                                <li>Download and run <code>rustup-init.exe</code></li>
                                            </ul>
                                        </li>
                                        <li><strong>Run the Installer:</strong>
                                            <ul>
                                                <li>Follow the prompts (default options are recommended)</li>
                                                <li>The installer will add Rust to your PATH</li>
                                            </ul>
                                        </li>
                                    </ol>

                                    <div class="tip-box">
                                        <strong>Windows Tip:</strong> After installation, restart your terminal or
                                        command prompt to ensure the PATH is updated.
                                    </div>

                                    <h3>macOS</h3>
                                    <p>On macOS, you'll need Xcode Command Line Tools.</p>

                                    <ol>
                                        <li><strong>Install Xcode Command Line Tools:</strong>
                                            <pre><code class="language-bash">xcode-select --install</code></pre>
                                        </li>
                                        <li><strong>Install Rustup:</strong>
                                            <pre><code class="language-bash">curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh</code></pre>
                                        </li>
                                        <li><strong>Follow the Prompts:</strong>
                                            <ul>
                                                <li>Press <code>1</code> for default installation</li>
                                                <li>The installer will configure your PATH automatically</li>
                                            </ul>
                                        </li>
                                        <li><strong>Reload your shell:</strong>
                                            <pre><code class="language-bash">source $HOME/.cargo/env</code></pre>
                                        </li>
                                    </ol>

                                    <h3>Linux</h3>
                                    <p>On Linux, installation is similar to macOS.</p>

                                    <ol>
                                        <li><strong>Install build essentials:</strong>
                                            <pre><code class="language-bash"># Ubuntu/Debian
sudo apt update
sudo apt install build-essential

# Fedora
sudo dnf install gcc

# Arch
sudo pacman -S base-devel</code></pre>
                                        </li>
                                        <li><strong>Install Rustup:</strong>
                                            <pre><code class="language-bash">curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh</code></pre>
                                        </li>
                                        <li><strong>Configure PATH:</strong>
                                            <pre><code class="language-bash">source $HOME/.cargo/env</code></pre>
                                        </li>
                                    </ol>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Verify Installation -->
                                    <h2>Verify Installation</h2>
                                    <p>After installation, verify that Rust is installed correctly:</p>

                                    <pre><code class="language-bash"># Check Rust compiler version
rustc --version

# Check Cargo version
cargo --version

# Check Rustup version
rustup --version</code></pre>

                                    <p>You should see output similar to:</p>
                                    <pre><code class="language-bash">rustc 1.75.0 (82e1608df 2023-12-21)
cargo 1.75.0 (1d8b05cdd 2023-11-20)
rustup 1.26.0 (5af9b9484 2023-04-05)</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Keep Rust updated regularly using
                                        <code>rustup update</code>.
                                        Rust releases a new stable version every 6 weeks with improvements and bug
                                        fixes.
                                    </div>

                                    <!-- Section 4: Rustup Commands -->
                                    <h2>Essential Rustup Commands</h2>
                                    <p>Here are the most useful Rustup commands you'll need:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Command</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>rustup update</code></td>
                                                <td>Update Rust to the latest version</td>
                                            </tr>
                                            <tr>
                                                <td><code>rustup self uninstall</code></td>
                                                <td>Uninstall Rust and Rustup</td>
                                            </tr>
                                            <tr>
                                                <td><code>rustup doc</code></td>
                                                <td>Open offline documentation</td>
                                            </tr>
                                            <tr>
                                                <td><code>rustup component add rustfmt</code></td>
                                                <td>Install code formatter</td>
                                            </tr>
                                            <tr>
                                                <td><code>rustup component add clippy</code></td>
                                                <td>Install linter for code quality</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Recommended:</strong> Install rustfmt and clippy right away:
                                        <pre><code class="language-bash">rustup component add rustfmt clippy</code></pre>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. PATH not updated</h4>
                                        <p><strong>Problem:</strong> Commands like <code>rustc</code> or
                                            <code>cargo</code> not found after installation
                                        </p>
                                        <p><strong>Solution:</strong> Restart your terminal or manually source the
                                            environment:</p>
                                        <pre><code class="language-bash"># macOS/Linux
source $HOME/.cargo/env

# Windows: Restart terminal or add to PATH manually
# %USERPROFILE%\.cargo\bin</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Missing C++ build tools (Windows)</h4>
                                        <p><strong>Problem:</strong> Compilation fails with linker errors</p>
                                        <p><strong>Solution:</strong> Install Visual Studio C++ Build Tools before Rust
                                        </p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Using outdated Rust version</h4>
                                        <p><strong>Problem:</strong> Code examples don't work or new features
                                            unavailable</p>
                                        <p><strong>Solution:</strong> Update regularly with <code>rustup update</code>
                                        </p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Rustup</strong> is the official Rust installer and version
                                                manager</li>
                                            <li>Installation requires <strong>C++ build tools</strong> on Windows,
                                                <strong>Xcode tools</strong> on macOS, and
                                                <strong>build-essential</strong> on Linux
                                            </li>
                                            <li>Verify installation with <code>rustc --version</code> and
                                                <code>cargo --version</code>
                                            </li>
                                            <li>Keep Rust updated with <code>rustup update</code></li>
                                            <li>Install <strong>rustfmt</strong> and <strong>clippy</strong> for better
                                                development experience</li>
                                            <li>Use <code>rustup doc</code> to access offline documentation</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that Rust is installed, you're ready to write your first Rust program! In the
                                        next lesson,
                                        we'll create a "Hello, World!" program, understand the basic structure of a Rust
                                        program,
                                        and learn how to compile and run it.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="intro.jsp" />
                                    <jsp:param name="prevTitle" value="Introduction" />
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
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/rust.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>