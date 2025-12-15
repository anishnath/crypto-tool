<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "installation" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Installing PHP - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to install PHP on Windows, Mac, and Linux. Set up XAMPP, MAMP, or install PHP directly for local development.">
            <meta name="keywords"
                content="install php, php setup, xampp, mamp, php installation, php windows, php mac, php linux">
            <meta property="og:title" content="Installing PHP - PHP Tutorial | 8gwifi.org">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/installation.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>
                (function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();
            </script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Installing PHP","description":"Learn how to install PHP and set up your development environment","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP installation","XAMPP setup","MAMP setup","Development environment"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="installation">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Installation</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Installing PHP</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Before you can start writing PHP code, you need to set up a
                                        development environment. This lesson will guide you through installing PHP on
                                        Windows, Mac, and Linux, plus setting up a local web server.</p>

                                    <h2>Installation Options</h2>
                                    <p>There are two main approaches to installing PHP:</p>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Pros</th>
                                                <th>Cons</th>
                                                <th>Best For</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>All-in-One Package</strong><br>(XAMPP, MAMP, WAMP)</td>
                                                <td>Easy setup, includes Apache & MySQL, GUI tools</td>
                                                <td>Larger download, may include unused features</td>
                                                <td>Beginners, quick setup</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Standalone PHP</strong></td>
                                                <td>Lightweight, full control, latest version</td>
                                                <td>Manual configuration, command-line only</td>
                                                <td>Advanced users, production-like setup</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Option 1: XAMPP (Recommended for Beginners)</h2>
                                    <p>XAMPP is a free, cross-platform package that includes Apache, MySQL, PHP, and
                                        Perl. It's the easiest way to get started.</p>
                                    <div class="info-box">
                                        <strong>What's Included:</strong>
                                        <ul>
                                            <li>Apache Web Server</li>
                                            <li>PHP (latest version)</li>
                                            <li>MySQL Database</li>
                                            <li>phpMyAdmin (database management)</li>
                                            <li>Control panel for easy management</li>
                                        </ul>
                                    </div>

                                    <h3>Installing XAMPP on Windows</h3>
                                    <ol>
                                        <li>Download XAMPP from <a href="https://www.apachefriends.org" target="_blank"
                                                rel="noopener">apachefriends.org</a></li>
                                        <li>Run the installer (xampp-windows-x64-installer.exe)</li>
                                        <li>Choose installation directory (default: C:\xampp)</li>
                                        <li>Select components (keep all defaults)</li>
                                        <li>Click "Next" through the installation</li>
                                        <li>Launch XAMPP Control Panel</li>
                                        <li>Click "Start" next to Apache and MySQL</li>
                                    </ol>

                                    <h3>Installing XAMPP on Mac</h3>
                                    <ol>
                                        <li>Download XAMPP for Mac from <a href="https://www.apachefriends.org"
                                                target="_blank" rel="noopener">apachefriends.org</a></li>
                                        <li>Open the .dmg file</li>
                                        <li>Drag XAMPP to Applications folder</li>
                                        <li>Open XAMPP from Applications</li>
                                        <li>Click "Start" for Apache and MySQL</li>
                                    </ol>

                                    <h3>Installing XAMPP on Linux</h3>
                                    <pre><code class="language-bash"># Download XAMPP
wget https://www.apachefriends.org/xampp-files/8.2.12/xampp-linux-x64-8.2.12-0-installer.run

# Make it executable
chmod +x xampp-linux-x64-8.2.12-0-installer.run

# Run installer
sudo ./xampp-linux-x64-8.2.12-0-installer.run

# Start XAMPP
sudo /opt/lampp/lampp start</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Option 2: Standalone PHP Installation</h2>

                                    <h3>Windows</h3>
                                    <ol>
                                        <li>Download PHP from <a href="https://windows.php.net/download" target="_blank"
                                                rel="noopener">windows.php.net</a></li>
                                        <li>Choose "Thread Safe" version (VS16 x64)</li>
                                        <li>Extract to C:\php</li>
                                        <li>Add C:\php to system PATH</li>
                                        <li>Rename php.ini-development to php.ini</li>
                                    </ol>

                                    <h3>Mac (using Homebrew)</h3>
                                    <pre><code class="language-bash"># Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install PHP
brew install php

# Verify installation
php -v</code></pre>

                                    <h3>Linux (Ubuntu/Debian)</h3>
                                    <pre><code class="language-bash"># Update package list
sudo apt update

# Install PHP and common extensions
sudo apt install php php-cli php-mysql php-mbstring php-xml

# Verify installation
php -v</code></pre>

                                    <h2>Verifying Your Installation</h2>
                                    <p>After installation, verify PHP is working correctly:</p>

                                    <h3>Method 1: Command Line</h3>
                                    <pre><code class="language-bash"># Check PHP version
php -v

# Run PHP code directly
php -r "echo 'Hello from PHP!';"</code></pre>

                                    <h3>Method 2: Create a Test File</h3>
                                    <p>Create a file named <code>test.php</code> in your web server's document root:</p>
                                    <ul>
                                        <li><strong>XAMPP Windows:</strong> C:\xampp\htdocs\test.php</li>
                                        <li><strong>XAMPP Mac:</strong> /Applications/XAMPP/htdocs/test.php</li>
                                        <li><strong>XAMPP Linux:</strong> /opt/lampp/htdocs/test.php</li>
                                    </ul>

                                    <pre><code class="language-php">&lt;?php
phpinfo();
?&gt;</code></pre>

                                    <p>Then visit <code>http://localhost/test.php</code> in your browser. You should see
                                        a detailed PHP information page.</p>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> The phpinfo() page shows all PHP settings, loaded
                                        extensions, and server information. It's invaluable for troubleshooting!
                                    </div>

                                    <h2>Setting Up a Code Editor</h2>
                                    <p>While you can write PHP in any text editor, these are recommended:</p>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Editor</th>
                                                <th>Features</th>
                                                <th>Best For</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>VS Code</strong></td>
                                                <td>Free, extensions, IntelliSense, debugging</td>
                                                <td>Most developers</td>
                                            </tr>
                                            <tr>
                                                <td><strong>PHPStorm</strong></td>
                                                <td>Professional IDE, advanced features, paid</td>
                                                <td>Professional development</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Sublime Text</strong></td>
                                                <td>Fast, lightweight, extensible</td>
                                                <td>Quick editing</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Atom</strong></td>
                                                <td>Free, hackable, GitHub integration</td>
                                                <td>Customization lovers</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Recommended VS Code Extensions for PHP:</strong>
                                        <ul>
                                            <li>PHP Intelephense - IntelliSense and code navigation</li>
                                            <li>PHP Debug - Debugging support</li>
                                            <li>PHP DocBlocker - Auto-generate documentation</li>
                                            <li>Prettier - Code formatting</li>
                                        </ul>
                                    </div>

                                    <h2>Common Installation Issues</h2>

                                    <div class="mistake-box">
                                        <h4>Port 80 Already in Use</h4>
                                        <p><strong>Problem:</strong> Apache won't start because port 80 is occupied
                                            (often by Skype or IIS)</p>
                                        <p><strong>Solution:</strong></p>
                                        <ul>
                                            <li>Close applications using port 80</li>
                                            <li>Or change Apache port in httpd.conf (Listen 8080)</li>
                                            <li>Then access via http://localhost:8080</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>PHP Not Found in Command Line</h4>
                                        <p><strong>Problem:</strong> "php is not recognized" error</p>
                                        <p><strong>Solution:</strong> Add PHP to your system PATH</p>
                                        <ul>
                                            <li><strong>Windows:</strong> System Properties → Environment Variables →
                                                Path → Add C:\xampp\php</li>
                                            <li><strong>Mac/Linux:</strong> Add to ~/.bashrc or ~/.zshrc: export
                                                PATH="/path/to/php:$PATH"</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>XAMPP:</strong> All-in-one package with Apache, PHP, MySQL -
                                                easiest for beginners</li>
                                            <li><strong>Standalone:</strong> Install PHP directly for more control</li>
                                            <li><strong>Verify:</strong> Use php -v or phpinfo() to confirm installation
                                            </li>
                                            <li><strong>Document Root:</strong> Place PHP files in htdocs folder (XAMPP)
                                            </li>
                                            <li><strong>Editor:</strong> VS Code with PHP extensions recommended</li>
                                            <li><strong>Troubleshooting:</strong> Check ports, PATH, and firewall
                                                settings</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that PHP is installed, you're ready to write your first program! In the next
                                        lesson, we'll create a complete PHP file, understand the basic syntax, and run
                                        it on your local server.</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="intro.jsp" />
                                    <jsp:param name="prevTitle" value="Introduction" />
                                    <jsp:param name="nextLink" value="first-program.jsp" />
                                    <jsp:param name="nextTitle" value="First Program" />
                                    <jsp:param name="currentLessonId" value="installation" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>