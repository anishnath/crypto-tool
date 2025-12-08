<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Bash Tutorial - Landing Page
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bash Tutorial - Learn Shell Scripting | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn Bash shell scripting from scratch with interactive examples. Free Bash tutorial for beginners to advanced with live code execution.">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">

    <script>
        (function() {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "Course",
        "name": "Bash Shell Scripting Tutorial",
        "description": "A comprehensive interactive course to learn Bash shell scripting from scratch to advanced automation.",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "sameAs": "https://8gwifi.org"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-bash.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content" style="margin-right: 0;">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Bash</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Bash Tutorial</h1>
                    <p style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                        Learn Bash shell scripting from scratch with interactive examples. Master the command line for automation, system administration, and DevOps.
                    </p>
                </header>

                <div class="lesson-body">
                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                        <%-- Start Learning Card --%>
                        <a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp" class="card" style="text-decoration: none; display: flex; align-items: center; gap: var(--space-4);">
                            <div style="width: 48px; height: 48px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2">
                                    <polygon points="5 3 19 12 5 21 5 3"/>
                                </svg>
                            </div>
                            <div>
                                <h3 style="margin: 0; font-size: var(--text-lg); color: var(--text-primary);">Start Learning</h3>
                                <p style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">Begin with Bash Introduction</p>
                            </div>
                            <svg style="margin-left: auto;" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                                <polyline points="9 18 15 12 9 6"/>
                            </svg>
                        </a>

                        <%-- What You'll Learn --%>
                        <div class="card">
                            <h3 style="margin: 0 0 var(--space-4) 0;">What You'll Learn</h3>
                            <ul style="margin: 0; padding-left: var(--space-6); color: var(--text-secondary);">
                                <li>Variables, arrays, and environment management</li>
                                <li>String manipulation and parameter expansion</li>
                                <li>Operators: arithmetic, comparison, logical, file tests</li>
                                <li>Control flow: if/else, case, loops</li>
                                <li>Functions with parameters and return values</li>
                                <li>Input/Output, pipes, and redirection</li>
                                <li>File operations and directory traversal</li>
                                <li>Advanced: regex, sed, awk, signals, debugging</li>
                                <li>Professional: error handling, logging, testing</li>
                            </ul>
                        </div>

                        <%-- Course Info --%>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">53</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Lessons</div>
                            </div>
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">10</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Modules</div>
                            </div>
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--success);">Free</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Forever</div>
                            </div>
                        </div>

                        <%-- Course Modules Overview --%>
                        <div class="card">
                            <h3 style="margin: 0 0 var(--space-4) 0;">Course Modules</h3>
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--space-3);">
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">1. Getting Started</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Introduction, first script, terminal</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">2. Variables & Environment</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Variables, expansion, arrays</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">3. Strings & Text</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Quoting, manipulation, heredocs</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">4. Operators & Arithmetic</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Math, comparison, file tests</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">5. Control Flow</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">If/else, case, for, while loops</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">6. Functions</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Defining, parameters, scope</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">7. Input & Output</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Read, redirection, pipes</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">8. File Operations</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Read, write, find, test</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">9. Advanced Topics</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Regex, sed, awk, signals</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">10. Professional Practices</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Error handling, logging, testing</p>
                                </div>
                            </div>
                        </div>

                        <%-- Why Learn Bash --%>
                        <div class="card">
                            <h3 style="margin: 0 0 var(--space-4) 0;">Why Learn Bash?</h3>
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: var(--space-4);">
                                <div>
                                    <strong style="color: var(--text-primary);">Automation</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Automate repetitive tasks and workflows</p>
                                </div>
                                <div>
                                    <strong style="color: var(--text-primary);">DevOps</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Essential for CI/CD and deployment</p>
                                </div>
                                <div>
                                    <strong style="color: var(--text-primary);">System Admin</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Manage servers and infrastructure</p>
                                </div>
                                <div>
                                    <strong style="color: var(--text-primary);">Universal</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Available on Linux, macOS, WSL</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
